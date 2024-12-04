CREATE OR REPLACE VIEW INTERVIEW_DATA_7.DANIEL_DW.DIM_RUNPOD_USERS (
  runpod_user_id,
  first_name,
  last_name,
  email,
  referral_id,
  hubspot_user_id,
  hubspot_company_id,
  created_at
) AS
SELECT
  u.id,
  cons.firstname as first_name,
  cons.lastname as last_name,
  coalesce(u.email, cons.email) as email,
  u.referral_id,
  cons.hs_object_id as hubspot_user_id,
  cons.associatedcompanyid as hubspot_company_id,
  u.created_at
FROM INTERVIEW_DATA_7.PUBLIC.USER u
  LEFT JOIN INTERVIEW_DATA_7.DANIEL_HUBSPOT.HUBSPOT_CONTACTS cons
    ON lower(cons.runpod_user_id) = lower(u.id)
;
