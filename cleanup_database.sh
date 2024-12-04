#!/bin/bash

SNOWSQL_SCHEMA="DANIEL_HUBSPOT"

# Check for any errors and exit if anything fails
set -e

# Deleting all tables in the schema
echo "Deleting all tables in schema ${SNOWSQL_SCHEMA}..."
snowsql -q "
USE SCHEMA ${SNOWSQL_SCHEMA};
SET stmt := 'DROP TABLE IF EXISTS ' || STRING_AGG(TABLE_NAME, ', ') || ';';
EXECUTE IMMEDIATE :stmt
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = '${SNOWSQL_SCHEMA}';
"

# Deleting all stages in the schema
echo "Deleting all stages in schema ${SNOWSQL_SCHEMA}..."
snowsql -q "
USE SCHEMA ${SNOWSQL_SCHEMA};
SET stmt := 'DROP STAGE IF EXISTS ' || STRING_AGG(STAGE_NAME, ', ') || ';';
EXECUTE IMMEDIATE :stmt
FROM INFORMATION_SCHEMA.STAGES
WHERE STAGE_SCHEMA = '${SNOWSQL_SCHEMA}';
"

# Dropping the schema
echo "Dropping the schema ${SNOWSQL_SCHEMA}..."
snowsql -q "
DROP SCHEMA IF EXISTS ${SNOWSQL_SCHEMA};
"

echo "Cleanup completed."

