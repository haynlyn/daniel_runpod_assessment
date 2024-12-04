COPY INTO {temp_table_name}
FROM @daniel_hubspot_stage
PATTERN='.*{hubspot_obj}.*'
FILE_FORMAT = (TYPE = 'JSON', COMPRESSION = 'AUTO')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
;
