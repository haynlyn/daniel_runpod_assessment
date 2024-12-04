CREATE OR REPLACE VIEW INTERVIEW_DATA_7.DANIEL_DW.FACT_CLIENT_SPEND (
  runpod_user_id,
  hubspot_company_id,
  client_balance,
  client_lifetime_spend,
  client_spend_limit
) AS
SELECT
  u.id runpod_user_id,
  dru.hubspot_company_id,
  client_balance,
  client_lifetime_spend,
  spend_limit client_spend_limit
FROM INTERVIEW_DATA_7.PUBLIC.USER u
  LEFT JOIN INTERVIEW_DATA_7.DANIEL_DW.DIM_RUNPOD_USERS dru
    ON u.id = dru.runpod_user_id
;
