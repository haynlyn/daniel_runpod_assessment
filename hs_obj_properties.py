obj_search_params = {
    'deals' : {'filter_property': 'hs_lastmodifieddate',
                'properties': [
                    'hs_object_id', 
                    'closedate', 'createdate',
                    'hubspot_owner_id', 
                    'dealname', 'dealstage', 'amount',
                    'hs_lastmodifieddate',
                    ]
    },
    'contacts' : {'filter_property': 'lastmodifieddate',
                    'properties': [
                      'hs_object_id', 
                      'createdate',
                      'email', 'firstname', 'lastname', 'lifetime_spend',
                      'associatedcompanyid', 'runpod_user_id',
                      'lastmodifieddate',
                      ]
    },
        'companies': {'filter_property': 'hs_lastmodifieddate',
                      'properties': [
                        'hs_object_id',
                        'createdate', 'name', 'domain',
                        'phone', 'city', 'country', 'industry',
                        'hs_last_modifieddate',
                    ]
    }
}
