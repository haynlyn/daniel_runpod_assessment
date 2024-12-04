CREATE TEMP TABLE IF NOT EXISTS temp_hubspot_companies (
    hs_object_id int PRIMARY KEY,
    createdate TIMESTAMP,
    name VARCHAR(256),
    domain VARCHAR(256),
    phone VARCHAR(32),
    city VARCHAR(256),
    country VARCHAR(256),
    industry VARCHAR(256),
    hs_lastmodifieddate TIMESTAMP
    -- first_contact_createdate TIMESTAMP,
    -- hs_created_by_user_id VARCHAR(256),
    -- hs_num_open_deals INT,
    -- hs_updated_by_user_id VARCHAR(256),
    -- lifecyclestage VARCHAR(256),
    -- num_associated_contacts INT
);

