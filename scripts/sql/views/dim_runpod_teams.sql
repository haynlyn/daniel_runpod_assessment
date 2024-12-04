CREATE OR REPLACE VIEW INTERVIEW_DATA_7.DANIEL_DW.DIM_RUNPOD_TEAMS (
  runpod_team_id,
  name,
  client_company_name,
  owner_id,
  created_at,
  updated_at
) AS
SELECT
  t.id,
  t.name,
  comp.name as client_company_name,
  t.owner_id,
  t.created_at,
  t.updated_at
FROM INTERVIEW_DATA_7.PUBLIC.TEAM t
  JOIN INTERVIEW_DATA_7.DANIEL_DW.DIM_RUNPOD_USERS dwu
    ON t.owner_id = dwu.runpod_user_id
  JOIN INTERVIEW_DATA_7.DANIEL_HUBSPOT.HUBSPOT_COMPANIES comp
    ON t.name ILIKE '%' || comp.name || '%'
;
