import os
import shutil
import subprocess
import logging

# Setup logging
logging.basicConfig(filename='logs/load.log', level=logging.INFO, format='%(asctime)s - %(message)s', datefmt='%Y-%m-%d %H:%M:%S')

def read_sql_file(sql_path, **kwargs):
    """
    Read an SQL file and substitute placeholders with actual values.
    """
    with open(sql_path, 'r') as file:
        sql_template = file.read()
    return sql_template.format(**kwargs)

def execute_snowsql_transaction(hs_obj, sql_commands):
    """
    Execute a list of SQL commands as a single transaction using SnowSQL.
    """
    transaction_block = "BEGIN;\n" + "\n".join(sql_commands) + "\nCOMMIT;"
    sql_file_path = 'scripts/.tmp/temp_load_transaction.sql'
    with open(sql_file_path, 'w') as file:
        file.write(transaction_block)

    command = ['snowsql', '-f', sql_file_path]
    try:
        subprocess.run(command, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        logging.info(f"Transaction executed successfully for: {hs_obj}.")
        os.remove(sql_file_path)
        return True
    except subprocess.CalledProcessError as e:
        logging.error(e.output)
    except Exception as e:
        logging.error(f"Transaction failed: {e}")
        return False

def move_files(src, dst):
    """
    Move files from source to destination directory.
    """
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    for file in os.listdir(src):
        src_file = os.path.join(src, file)
        dst_file = os.path.join(dst, file)
        try:
            shutil.move(src_file, dst_file)
            logging.info(f"Moved {file} from {src} to {dst}")
        except Exception as e:
            logging.info(f"Error moving {src_file}: {e}")


def main():
    """
    For pre-set HubSpot objects that have already been downloaded,
    for each object, load all unprocessed files into a staging area.
    Create a temp table for the files, then upsert into the main table.
    
    Upon success, the staging area and temp tables are empty or deleted.
    Upon failure, the transaction adds safeguards and staging/tables are reverted.
    """
    hs_objs = ['deals', 'contacts', 'companies']
    table_names = {obj: f"hubspot_{obj}" for obj in hs_objs}
    temp_table_creates = {obj: f"create_temp_{obj}_table.sql" for obj in hs_objs}
    upsert_creates = {obj: f"upsert_{obj}.sql" for obj in hs_objs}

    root_dir = 'data/hubspot'
    for hs_obj in hs_objs:
        topic_path = os.path.join(root_dir, hs_obj)
        raw_dir = os.path.join(topic_path, 'raw/')
        if not os.listdir(raw_dir):
            logging_message = f"No files to load for: {hs_obj}"
            print(logging_message)
            logging.info(logging_message)
            continue
        table_name = table_names[hs_obj]
        temp_table_name = 'temp_' + table_name
        temp_table_create = temp_table_creates[hs_obj]

        # Prepare SQL commands
        create_temp_obj_table_command = read_sql_file(f"scripts/sql/load/{temp_table_create}")
        put_command = read_sql_file('scripts/sql/load/put.sql', path_to_topic=topic_path)
        copy_into_command = read_sql_file('scripts/sql/load/copy_into.sql', \
                temp_table_name=temp_table_name, hubspot_obj=hs_obj)
        upsert_command = read_sql_file(f'scripts/sql/load/upsert_{hs_obj}.sql', \
                temporary_table_name=temp_table_name, table_name=table_name)
        empty_command = read_sql_file('scripts/sql/load/empty_stage.sql')


        test_query = f"select * from hubspot_{hs_obj} limit 10;"
        test_query1 = f"select 42 from hubspot_{hs_obj} limit 1;"
                
        # Execute all commands as a single transaction
        transaction = [put_command, create_temp_obj_table_command, \
                       copy_into_command, upsert_command, \
                       empty_command]
        
        if execute_snowsql_transaction(hs_obj, transaction):
            for root, dirs, files in os.walk(raw_dir):
                if root.endswith('/raw/'):
                    for file in files:
                        processed_dir = raw_dir.replace('/raw/', '/processed/')
                        file_path = os.path.join(root, file)
                        try:
                            move_files(raw_dir, processed_dir)
                        except Exception as e:
                            print(e)
        else:
            logging.error(f"Failed to process {file_path}.")


        


if __name__ == "__main__":
    main()

