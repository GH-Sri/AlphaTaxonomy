#!/bin/bash

# DLL step - Create the DB, Schema, Tables, etc.
psql -v ON_ERROR_STOP=1 -h mdas.c33zx3vjrof0.us-east-1.rds.amazonaws.com -U mdas -f 01_create_db.sql

# DML step - Populate initial data
psql -v ON_ERROR_STOP=1 -1 -h mdas.c33zx3vjrof0.us-east-1.rds.amazonaws.com -U mdas -d mdas -f 02_populate_db.sql

