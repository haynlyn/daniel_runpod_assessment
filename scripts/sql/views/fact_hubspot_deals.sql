CREATE OR REPLACE VIEW INTERVIEW_DATA_7.DANIEL_DW.FACT_HUBSPOT_DEALS (
  id,
  name,
  stage,
  description,
  created_at,
  closed_at,
  closed_amount,
  closed_amount_in_home_currency,
  pipeline,
  is_closed,
  is_closed_won,
  is_closed_lost,
  hubspot_owner_id,
  owner_ids,
  business_unit_ids,
  updated_at,
  deal_company_id
) AS
WITH base AS (
  SELECT
    hs_object_id as id,
    dealname as name,
    dealstage as stage,
    description,
    createdate created_at,
    closedate closed_at,
    hs_closed_amount as closed_amount,
    hs_closed_amount_in_home_currency as closed_amount_in_home_currency,
    pipeline,
    coalesce(hs_is_closed, stage ilike '%closed%') as is_closed,
    coalesce(hs_is_closed_won, is_closed and stage ilike '%won%') as is_closed_won,
    coalesce(hs_is_closed_lost, is_closed and stage ilike '%lost%') as is_closed_lost,
    hubspot_owner_id as hubspot_owner_id,
    hs_lastmodifieddate as updated_at
  FROM
    INTERVIEW_DATA_7.DANIEL_HUBSPOT.HUBSPOT_DEALS
)
SELECT
  b.*, dhc.id as deal_company_id
FROM base b
  JOIN INTERVIEW_DATA_7.DANIEL_DW.DIM_HUBSPOT_COMPANIES dhc
    ON b.name ilike '%' || dhc.name || '%'
;
