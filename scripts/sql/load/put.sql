-- stage_name should be `daniel_$hubspotObject`
-- local_file_path can actually take wildcards to then call all unstaged/raw
-- files in the appropriate directory
PUT file://{path_to_topic}/raw/*.json @daniel_hubspot_stage;
