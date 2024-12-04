# Makefile for setting up a Python virtual environment, SnowSQL, and installing dependencies

# Load env vars from .env file
include .env
export $(shell sed 's/=.*//' .env)

# Constants
PYTHON = python3
VENV_DIR = .venv
VENV_ACTIVATE = $(VENV_DIR)/bin/activate
SNOWSQL_INSTALL_URL = https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.3/linux_x86_64/snowsql-1.3.1-linux_x86_64.bash

# Default target: create a virtual environment, install SnowSQL, and install Python dependencies
all: create_venv install_snowsql install_python_deps init_db

# Create a virtual environment
create_venv:
	@echo "Creating Python virtual environment..."
	@if [ ! -d $(VENV_DIR) ]; then \
		$(PYTHON) -m venv $(VENV_DIR); \
		echo "Virtual environment created in $(VENV_DIR)"; \
	else \
		echo "Virtual environment already exists."; \
	fi

# Install SnowSQL
install_snowsql:
	@echo "Checking for SnowSQL installation..."
	@if ! command -v snowsql &> /dev/null; then \
		echo "SnowSQL not found. Trying to install..."; \
		curl -O $(SNOWSQL_INSTALL_URL); \
		bash snowsql-1.3.1-linux_x86_64.bash; \
	else \
		echo "SnowSQL is already installed."; \
	fi

# Install Python dependencies inside the virtual environment
install_python_deps:
	@echo "Installing Python dependencies in the virtual environment..."
	. $(VENV_ACTIVATE) && pip install --upgrade pip && pip install -r requirements.txt

# Sets up database for assessment or for refreshing data
init_db:
	@bash init_database.sh

# Empties and drops appropriate resources for the assessment
clean_db:
	@bash cleanup_database.sh

# Clean up temporary files
clean:
	rm -rf $(VENV_DIR)

.PHONY: all create_venv install_snowsql install_python_deps init_db clean_db clean

