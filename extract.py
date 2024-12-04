import os
import argparse
from datetime import datetime
import logging
import hubspot_grab as hgrab

# Setup directories and logging
PROJECT_DIR = './'
DATA_DIR = os.path.join(PROJECT_DIR, 'data')
EXTRACT_LOG = os.path.join(PROJECT_DIR, 'logs/extract.log')
os.makedirs('logs', exist_ok=True)

# Configure logging
logging.basicConfig(filename=EXTRACT_LOG, level=logging.INFO, format='%(asctime)s - %(message)s', datefmt='%Y-%m-%d %H:%M:%S')

def valid_datetime(s):
    """
    Validates valid dates. ;)
    Well... datetimes.
    """
    try:
        return datetime.strptime(s, "%Y-%m-%d %H:%M:%S")
    except ValueError:
        msg = f"Not a valid datetime: '{s}'. Expected format YYYY-MM-DD HH:MM:SS"
        raise argparse.ArgumentTypeError(msg)

def load_general_log(n):
    """
    Load the datetime of the N-th last successful extraction from the log file.
    This enables the --since_last_extract flag to be passed, allowing for getting
    data since a specific, earlier run.
    """
    try:
        with open(EXTRACT_LOG, 'r') as log:
            lines = log.readlines()
            if len(lines) >= n:
                last_log_entry = lines[-n].strip()
                return valid_datetime(last_log_entry.split(' - ')[0])
            else:
                return datetime.fromtimestamp(0)  # Return the epoch if not enough logs
    except FileNotFoundError:
        return datetime.fromtimestamp(0)  # Return the epoch if no log file exists

def parse_args():
    """
    Parses args for optionally resetting data collection.
    As carried out in `main()`, --since overrides --since_last_extract,
    but the latter is the default parameter and takes a default value of 1.
    """
    parser = argparse.ArgumentParser(description=\
            'Download data created/updated after a specified datetime or since the last N extracts.')
    parser.add_argument('--since', help=\
            "Enter the datetime in YYYY-MM-DD HH:MM:SS format to download data since this datetime.", \
            type=valid_datetime)
    parser.add_argument('--since_last_extract', help=\
            "Download data since the Nth last general extraction. If --since is provided, this is ignored.", \
            type=int, default=1)
    return parser.parse_args()

def main():
    args = parse_args()

    last_extract = args.since if args.since else load_general_log(args.since_last_extract)
    param_info = f'Called with --since {args.since}' if args.since \
            else f'Called with --since_last_extract {args.since_last_extract}'
    datetime_used = last_extract.strftime('%Y-%m-%d %H:%M:%S')
    written_topics = []

    for hs_obj in ['contacts', 'deals', 'companies']:
        obj_data_dir = os.path.join(DATA_DIR, 'hubspot', hs_obj, 'raw')
        os.makedirs(obj_data_dir, exist_ok=True)

        objects, has_new_data = hgrab.search_hubspot_data(hs_obj, datetime_used)
        if objects:
            filename = f"{hs_obj}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
            hgrab.write_hubspot_data(objects, obj_data_dir, filename)
            written_topics.append(hs_obj)
    
    # Log a single line summarizing the run
    if written_topics:
        logging_message = f"{param_info}, used datetime: {datetime_used}, topics written: {', '.join(written_topics)}"
        print(logging_message)
        logging.info(logging_message)
    else:
        print(f"No files were obtained from the server. Aborting without logging.")

if __name__ == "__main__":
    main()

