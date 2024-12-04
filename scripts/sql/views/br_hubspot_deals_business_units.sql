CREATE OR REPLACE VIEW INTERVIEW_DATA_7.DANIEL_DW.BR_HUBSPOT_DEALS_USERS (
  deal_id,
  business_unit_id
) AS
SELECT
  hs_object_id as d.deal_id
  flattened_business_units.value::string AS owner_id
FROM 
  INTERVIEW_DATA_7.DANIEL_HUBSPOT.HUBSPOT_DEALS d
  JOIN lateral flatten(input => d.hs_all_assigned_business_unit_ids) AS flattened_business_units ON TRUE
;
