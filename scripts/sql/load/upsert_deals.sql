MERGE INTO {table_name} AS TARGET
USING {temporary_table_name} AS SOURCE
ON TARGET.hs_object_id = SOURCE.hs_object_id
  AND SOURCE.hs_lastmodifieddate >= TARGET.hs_lastmodifieddate
WHEN MATCHED THEN
  UPDATE SET
    TARGET.dealname = SOURCE.dealname,
    TARGET.dealstage = SOURCE.dealstage,
    TARGET.description = SOURCE.description,
    TARGET.hs_closed_amount = SOURCE.hs_closed_amount,
    TARGET.hs_closed_amount_in_home_currency = SOURCE.hs_closed_amount_in_home_currency,
    TARGET.pipeline = SOURCE.pipeline,
    TARGET.hs_is_closed = SOURCE.hs_is_closed,
    TARGET.hs_is_closed_won = SOURCE.hs_is_closed_won,
    TARGET.hs_is_closed_lost = SOURCE.hs_is_closed_lost,
    TARGET.hubspot_owner_id = SOURCE.hubspot_owner_id,
    TARGET.hs_user_ids_of_all_owners = SOURCE.hs_user_ids_of_all_owners,
    TARGET.hs_all_assigned_business_unit_ids = SOURCE.hs_all_assigned_business_unit_ids,
    TARGET.hs_lastmodifieddate = SOURCE.hs_lastmodifieddate
WHEN NOT MATCHED THEN
  INSERT (hs_object_id, dealname, dealstage, description, hs_closed_amount, hs_closed_amount_in_home_currency,
          pipeline, hs_is_closed, hs_is_closed_won, hs_is_closed_lost, hubspot_owner_id,
          hs_user_ids_of_all_owners, hs_all_assigned_business_unit_ids, hs_lastmodifieddate)
  VALUES (SOURCE.hs_object_id, SOURCE.dealname, SOURCE.dealstage, SOURCE.description, SOURCE.hs_closed_amount,
          SOURCE.hs_closed_amount_in_home_currency, SOURCE.pipeline, SOURCE.hs_is_closed, SOURCE.hs_is_closed_won,
          SOURCE.hs_is_closed_lost, SOURCE.hubspot_owner_id, SOURCE.hs_user_ids_of_all_owners,
          SOURCE.hs_all_assigned_business_unit_ids, SOURCE.hs_lastmodifieddate)
;

