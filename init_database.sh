#!/bin/bash

SETUP_DIR="./scripts/sql/setup"
for FILE in $(ls $SETUP_DIR/create*schema*.sql); do snowsql -f $FILE; done
for FILE in $(ls $SETUP_DIR/create*stage*.sql); do snowsql -f $FILE; done
for FILE in $(ls $SETUP_DIR/create*table*.sql); do snowsql -f $FILE; done
