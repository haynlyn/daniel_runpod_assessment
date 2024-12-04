import datetime
import os # should already be called in the main module, but we'll see
import json
from hs_obj_properties import obj_search_params as osp

from hubspot import HubSpot

api_client = HubSpot(access_token=os.environ['HUBSPOT_ACCESS_TOKEN'])

def search_hubspot_data(object_type, start):
    """
    Searches for updated or new objects based on the time of the function call.
    HubSpot API uses milliseconds in the Unix epoch.
    Default value is start of Unix epoch (+ offset for local machine).
        Use it for full refresh of business data.

    Returns a list of dicts (or an empty list if no data)
    """
    start_ms = int(datetime.datetime.fromisoformat(start).timestamp() * 1000)
    
    if object_type == 'contacts':
        search_api = api_client.crm.contacts.search_api
        filter_property = 'lastmodifieddate'
    elif object_type == 'deals':
        search_api = api_client.crm.deals.search_api
        filter_property = 'hs_lastmodifieddate'
    elif object_type == 'companies':
        search_api = api_client.crm.companies.search_api
        filter_property = 'hs_lastmodifieddate'
    else:
        raise ValueError("Unsupported object type")

    # Grab all values that have been updated or created since `start_ms`.
    # The latter indicates new records.
    filter_group = [
        {
            "filters": [
                {
                    "propertyName": osp[object_type]['filter_property'],
                    #"propertyName": filter_property,
                    "operator":     "GTE",
                    "value":        start_ms
                }
            ]
        },
        {
            "filters": [
                {
                    "propertyName": 'createdate',
                    "operator":     "GTE",
                    "value":        start_ms
                }
            ]
        }

    ]
    
    after = None # Define now to possibly overwrite later.

    query = {
        "filterGroups": filter_group,
        "limit": 200, # Set to the max to hopefully reduce the need for pagination.
        "after": after,
        "properties": osp[object_type]['properties']
    }

    all_objects = []
    # Grab data until the end of the paginator is reached.
    while True:
        query["after"] = after
        try:
            response = search_api.do_search(public_object_search_request=query)
            new_objects = response.results
            for object in new_objects:
                object_properties = object.properties
                all_objects.append(object_properties)

            # check for another page
            if response.paging:
                after = response.paging.next.after
            else:
                break

        except Exception as e:
            print(f"Exception when calling search APIs: {e}")
            break

    # This last_extract value should probably be defined in extract.py
    # after a successful download, as something could fail here?
    last_extract = datetime.datetime.date(datetime.datetime.now()).isoformat()
    return all_objects, last_extract

def write_hubspot_data(objects_list, dir_path, filename):
    """Assumes list of dicts."""
    with open(os.path.join(dir_path, filename), 'w') as wf:
        for record in objects_list:
            wf.write(json.dumps(record) + '\n')
        #json.dump(objects_list, wf)
