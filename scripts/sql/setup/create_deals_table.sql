CREATE TABLE IF NOT EXISTS hubspot_deals (
    hs_object_id int PRIMARY KEY,
    dealname VARCHAR(256),
    dealstage VARCHAR(256),
    description VARCHAR(1024),
    createdate TIMESTAMP,
    closedate TIMESTAMP,
    hs_closed_amount NUMERIC(20,10),
    hs_closed_amount_in_home_currency NUMERIC(20,10),
    pipeline VARCHAR(256),
    hs_is_closed BOOLEAN,
    hs_is_closed_won BOOLEAN,
    hs_is_closed_lost BOOLEAN,
    hubspot_owner_id INT,
    hs_user_ids_of_all_owners VARIANT,
    hs_all_assigned_business_unit_ids VARIANT,
    hs_lastmodifieddate TIMESTAMP
);

