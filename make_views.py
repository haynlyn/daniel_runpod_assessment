import os
from datetime import datetime
import logging
import subprocess

# Setup constants
PROJECT_DIR = './'
VIEWS_DIR = os.path.join(PROJECT_DIR, 'scripts/sql/views')
VIEWS_LOG = os.path.join(PROJECT_DIR, 'logs/views.log')

# Configure logging.
logging.basicConfig(filename=VIEWS_LOG, level=logging.INFO, format='%(asctime)s - %(message)s', \
                    datefmt='%Y-%m-%d %H:%M:%S')

def read_sql_file(sql_file):
    sql_filepath = os.path.join(VIEWS_DIR, sql_file)
    """Simple read of SQL files since they take no parameters."""
    with open(sql_filepath, 'r') as file:
        sql_command = file.read()
    return sql_command

def execute_snowsql_transaction(sql_files, step):
    """
    Execute a list of SQL commands as a single transaction using SnowSQL.
    Retries could be added, but the entire script can easily be rerun.
    """
    sql_commands = [read_sql_file(file) for file in sql_files]
    transaction_block = "BEGIN;\n" + "\n".join(sql_commands) + "\nCOMMIT;"
    print(transaction_block)
    sql_file_path = 'scripts/.tmp/temp_build_transaction.sql'
    with open(sql_file_path, 'w') as file:
        file.write(transaction_block)

    command = ['snowsql', '-f', sql_file_path]
    try:
        subprocess.run(command, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        logging.info(f"Built views for {step} in order: {', '.join(sql_files)}")
        return True
    except subprocess.CalledProcessError as e:
        logging.error(e.output)
        logging.error(f"Failed on building: {', '.join(sql_files)}. Aborting all builds.")
        return False
    except Exception as e:
        logging.error(f"Transaction failed: {e}")
        logging.error(f"Failed on building: {', '.join(sql_files)}. Aborting all builds.")
        return False
    finally:
        if os.path.exists(sql_file_path):
            os.remove(sql_file_path)


def main():
    """The order of execution has been manually set. In a production
    setting, we'd use another tool such as dbt rather than hard-coding this."""
    execution_order = {
        0: ['dim_hubspot_companies.sql', 'dim_runpod_users.sql'],
        1: ['dim_runpod_teams.sql', 'br_hubspot_deals_business_units.sql', 'br_hubspot_deals_users.sql',\
            'fact_hubspot_deals.sql'],
        2: ['br_runpod_teams_users.sql', 'fact_client_spend.sql']
    }
    for step in execution_order:
        sql_files = execution_order[step]
        if not execute_snowsql_transaction(sql_files, step):
            break

if __name__ == '__main__':
    main()
