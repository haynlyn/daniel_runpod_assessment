CREATE OR REPLACE VIEW INTERVIEW_DATA_7.DANIEL_DW.BR_RUNPOD_TEAMS_USERS (
  team_id,
  user_id
) AS
SELECT
  drt.id as team_id,
  dru.id as user_id
FROM
  INTERVIEW_DATA_7.DANIEL_DW.DIM_RUNPOD_USERS dru
  JOIN INTERVIEW_DATA_7.PUBLIC.TEAM_MEMBERSHIP tm
    ON dru.runpod_user_id = tm.member_user_id
  JOIN INTERVIEW_DATA_7.DANIEL_DW.DIM_RUNPOD_TEAMS drt
    on drt.runpod_team_id = tm.team_id
;
