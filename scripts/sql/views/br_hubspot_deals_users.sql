CREATE OR REPLACE VIEW INTERVIEW_DATA_7.DANIEL_DW.BR_HUBSPOT_DEALS_USERS (
  deal_id,
  owner_id
) AS
SELECT
  hs_object_id as d.deal_id
  flattened_owners.value::string AS owner_id
FROM 
  INTERVIEW_DATA_7.DANIEL_HUBSPOT.HUBSPOT_DEALS d
  JOIN lateral flatten(input => d.hs_user_ids_of_all_owners) AS flattened_owners ON TRUE
;
