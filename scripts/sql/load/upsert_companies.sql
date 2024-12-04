MERGE INTO {table_name} AS TARGET
USING {temporary_table_name} AS SOURCE
ON TARGET.hs_object_id = SOURCE.hs_object_id
  AND SOURCE.hs_lastmodifieddate >= TARGET.hs_lastmodifieddate
WHEN MATCHED THEN
  UPDATE SET
    TARGET.createdate = SOURCE.createdate,
    TARGET.name = SOURCE.name,
    TARGET.domain = SOURCE.domain,
    TARGET.phone = SOURCE.phone,
    TARGET.city = SOURCE.city,
    TARGET.country = SOURCE.country,
    TARGET.industry = SOURCE.industry,
    TARGET.hs_lastmodifieddate = SOURCE.hs_lastmodifieddate
WHEN NOT MATCHED THEN
  INSERT (hs_object_id, createdate, name, domain, phone, city, country, industry, hs_lastmodifieddate)
  VALUES (SOURCE.hs_object_id, SOURCE.createdate, SOURCE.name, SOURCE.domain, SOURCE.phone, SOURCE.city, SOURCE.country, SOURCE.industry, SOURCE.hs_lastmodifieddate)
;

