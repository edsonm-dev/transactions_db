# Transactions DB

## About the Project

**Purpose**: Testing how some parts of Revenue ETL project could be done on local SQL Server. Creates a database with cleaned bank transaction data, category, subcategory, expression tables. The database contains function, view, trigger, stored procedure to categorize and analyse data automatically. There is also a python script that can be used to insert records into the database and categorize them with a stored procedure.

 - **Sources**: 
    - csv files for creating the initial state (categories, expressions, subcategories and transactions tables)

All data in the repository has been changed and/or randomized for privacy reasons.

### Built With

- T-SQL
- Python libraries:
  - pyodbc

## Usage

1. The user creates the database with 01_create_tables_sql, then 02_stored_procedures_triggers.sql, finally 03_views.sql
2. the database can be queried and modified with the code in main.py
