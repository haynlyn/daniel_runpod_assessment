CREATE TEMP TABLE IF NOT EXISTS temp_hubspot_contacts (
    hs_object_id int PRIMARY KEY,
    createdate TIMESTAMP,
    email VARCHAR(256),
    firstname VARCHAR(256),
    lastname VARCHAR(256),
    lifetime_spend FLOAT,
    associatedcompanyid VARCHAR(256),
    runpod_user_id VARCHAR(256),
    lastmodifieddate TIMESTAMP
    -- num_conversion_events INT,
);

