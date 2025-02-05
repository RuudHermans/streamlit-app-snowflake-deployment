-- Snowflake Setup Script

-- Step 1: Use SECURITYADMIN for Role and User Management
USE ROLE SECURITYADMIN;

-- Create Custom Roles for Each Environment
CREATE OR REPLACE ROLE dev_read_role;
CREATE OR REPLACE ROLE acc_read_role;
CREATE OR REPLACE ROLE prod_read_role;

-- Create Service Users for Each Environment
CREATE OR REPLACE USER deploy_dev_user PASSWORD = 'StrongPassword1!' DEFAULT_ROLE = dev_read_role TYPE = 'LEGACY_SERVICE' MUST_CHANGE_PASSWORD = FALSE;
CREATE OR REPLACE USER deploy_acc_user PASSWORD = 'StrongPassword2!' DEFAULT_ROLE = acc_read_role TYPE = 'LEGACY_SERVICE' MUST_CHANGE_PASSWORD = FALSE;
CREATE OR REPLACE USER deploy_prod_user PASSWORD = 'StrongPassword3!' DEFAULT_ROLE = prod_read_role TYPE = 'LEGACY_SERVICE' MUST_CHANGE_PASSWORD = FALSE;

-- Assign Roles to Service Users
GRANT ROLE dev_read_role TO USER deploy_dev_user;
GRANT ROLE acc_read_role TO USER deploy_acc_user;
GRANT ROLE prod_read_role TO USER deploy_prod_user;

-- Step 2: Switch to SYSADMIN for Database, Warehouse, and Object Creation
USE ROLE SYSADMIN;

-- Create Warehouses for Each Environment
CREATE OR REPLACE WAREHOUSE dev_wh WITH 
    WAREHOUSE_SIZE = 'XSMALL' 
    AUTO_SUSPEND = 300 
    AUTO_RESUME = TRUE;

CREATE OR REPLACE WAREHOUSE acc_wh WITH 
    WAREHOUSE_SIZE = 'XSMALL' 
    AUTO_SUSPEND = 300 
    AUTO_RESUME = TRUE;

CREATE OR REPLACE WAREHOUSE prod_wh WITH 
    WAREHOUSE_SIZE = 'XSMALL' 
    AUTO_SUSPEND = 300 
    AUTO_RESUME = TRUE;

-- Create SYSADMIN Warehouse
CREATE OR REPLACE WAREHOUSE sysadmin_wh WITH 
    WAREHOUSE_SIZE = 'XSMALL' 
    AUTO_SUSPEND = 300 
    AUTO_RESUME = TRUE;

-- Grant Usage Privileges on Warehouses to Corresponding Roles
GRANT USAGE ON WAREHOUSE dev_wh TO ROLE dev_read_role;
GRANT USAGE ON WAREHOUSE acc_wh TO ROLE acc_read_role;
GRANT USAGE ON WAREHOUSE prod_wh TO ROLE prod_read_role;

-- Use the SYSADMIN Warehouse for Initial Setup
USE WAREHOUSE sysadmin_wh;

-- Create Databases and Schemas for All Environments
CREATE OR REPLACE DATABASE dev_database;
CREATE OR REPLACE SCHEMA dev_database.dev_schema;

CREATE OR REPLACE DATABASE acc_database;
CREATE OR REPLACE SCHEMA acc_database.acc_schema;

CREATE OR REPLACE DATABASE prod_database;
CREATE OR REPLACE SCHEMA prod_database.prod_schema;

-- Development Environment stage
CREATE OR REPLACE STAGE dev_database.dev_schema.streamlit_stage;
GRANT READ ON STAGE dev_database.dev_schema.streamlit_stage TO ROLE dev_read_role;
GRANT WRITE ON STAGE dev_database.dev_schema.streamlit_stage TO ROLE dev_read_role;

-- Acceptance Environment stage
CREATE OR REPLACE STAGE acc_database.acc_schema.streamlit_stage;
GRANT READ ON STAGE acc_database.acc_schema.streamlit_stage TO ROLE acc_read_role;
GRANT WRITE ON STAGE acc_database.acc_schema.streamlit_stage TO ROLE acc_read_role;

-- Production Environment stage
CREATE OR REPLACE STAGE prod_database.prod_schema.streamlit_stage;
GRANT READ ON STAGE prod_database.prod_schema.streamlit_stage TO ROLE prod_read_role;
GRANT WRITE ON STAGE prod_database.prod_schema.streamlit_stage TO ROLE prod_read_role;

-- Create the 'orders' Table for Each Environment
CREATE OR REPLACE TABLE dev_database.dev_schema.orders (
    order_number STRING,
    order_name STRING
);

CREATE OR REPLACE TABLE acc_database.acc_schema.orders (
    order_number STRING,
    order_name STRING
);

CREATE OR REPLACE TABLE prod_database.prod_schema.orders (
    order_number STRING,
    order_name STRING
);

CREATE OR REPLACE TABLE prod_database.prod_schema.customers (
    customer_id STRING,
    customer_name STRING,
    email STRING
);

-- Insert Sample Data into the 'orders' Table for All Environments
INSERT INTO dev_database.dev_schema.orders (order_number, order_name) VALUES
    ('001', 'Order Alpha'),
    ('002', 'Order Beta'),
    ('003', 'Order Gamma'),
    ('004', 'Order Delta'),
    ('005', 'Order Epsilon');

INSERT INTO acc_database.acc_schema.orders (order_number, order_name) VALUES
    ('001', 'Order Alpha'),
    ('002', 'Order Beta'),
    ('003', 'Order Gamma'),
    ('004', 'Order Delta'),
    ('005', 'Order Epsilon');

INSERT INTO prod_database.prod_schema.orders (order_number, order_name) VALUES
    ('001', 'Order Alpha'),
    ('002', 'Order Beta'),
    ('003', 'Order Gamma'),
    ('004', 'Order Delta'),
    ('005', 'Order Epsilon');

-- Grant Read-Only Privileges to Custom Roles
GRANT USAGE ON DATABASE dev_database TO ROLE dev_read_role;
GRANT USAGE ON SCHEMA dev_database.dev_schema TO ROLE dev_read_role;
GRANT SELECT ON dev_database.dev_schema.orders TO ROLE dev_read_role;

GRANT USAGE ON DATABASE acc_database TO ROLE acc_read_role;
GRANT USAGE ON SCHEMA acc_database.acc_schema TO ROLE acc_read_role;
GRANT SELECT ON acc_database.acc_schema.orders TO ROLE acc_read_role;

GRANT USAGE ON DATABASE prod_database TO ROLE prod_read_role;
GRANT USAGE ON SCHEMA prod_database.prod_schema TO ROLE prod_read_role;
GRANT SELECT ON prod_database.prod_schema.orders TO ROLE prod_read_role;

-- Switch Back to SECURITYADMIN to Set Default Warehouse for Each Service User
USE ROLE SECURITYADMIN;

-- Set Default Warehouse for Each Service User
-- Note: We set the default warehouse for each service account instead of specifying it in snowflake_app.yml.
-- This approach ensures environment-specific isolation and avoids the need for multiple configuration files.
ALTER USER deploy_dev_user SET DEFAULT_WAREHOUSE = dev_wh;
ALTER USER deploy_acc_user SET DEFAULT_WAREHOUSE = acc_wh;
ALTER USER deploy_prod_user SET DEFAULT_WAREHOUSE = prod_wh;

-- Confirm Setup
SHOW TABLES IN SCHEMA dev_database.dev_schema;
SHOW TABLES IN SCHEMA acc_database.acc_schema;
SHOW TABLES IN SCHEMA prod_database.prod_schema;
