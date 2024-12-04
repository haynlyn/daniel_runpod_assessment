CREATE OR REPLACE VIEW INTERVIEW_DATA_7.DANIEL_DW.DIM_HUBSPOT_COMPANIES (
  id,
  name,
  domain,
  phone,
  city,
  country,
  industry,
) AS
SELECT
  hs_object_id as id,
  name,
  lower(domain) as domain,
  phone,
  city,
  country,
  industry
FROM INTERVIEW_DATA_7.DANIEL_HUBSPOT.HUBSPOT_COMPANIES
;


