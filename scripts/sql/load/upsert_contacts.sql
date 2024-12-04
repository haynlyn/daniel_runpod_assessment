MERGE INTO {table_name} AS TARGET
USING {temporary_table_name} AS SOURCE
ON TARGET.hs_object_id = SOURCE.hs_object_id
  AND SOURCE.lastmodifieddate >= TARGET.lastmodifieddate
WHEN MATCHED THEN
  UPDATE SET
    TARGET.createdate = SOURCE.createdate,
    TARGET.email = SOURCE.email,
    TARGET.firstname = SOURCE.firstname,
    TARGET.lastname = SOURCE.lastname,
    TARGET.lifetime_spend = SOURCE.lifetime_spend,
    TARGET.associatedcompanyid = SOURCE.associatedcompanyid,
    TARGET.runpod_user_id = SOURCE.runpod_user_id,
    TARGET.lastmodifieddate = SOURCE.lastmodifieddate
WHEN NOT MATCHED THEN
  INSERT (hs_object_id, createdate, email, firstname, lastname, lifetime_spend,
      associatedcompanyid, runpod_user_id, lastmodifieddate)
  VALUES (SOURCE.hs_object_id, SOURCE.createdate, SOURCE.email, SOURCE.firstname, SOURCE.lastname,
      SOURCE.lifetime_spend, SOURCE.associatedcompanyid, SOURCE.runpod_user_id, SOURCE.lastmodifieddate)
;

