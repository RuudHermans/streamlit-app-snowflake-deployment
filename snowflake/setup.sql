-- Snowflake Script to Create Service Accounts with Basic Authentication

-- Use the SECURITYADMIN role to manage roles and users
USE ROLE SECURITYADMIN;

-- 1. Create Service Roles for Each Environment
CREATE ROLE IF NOT EXISTS deploy_dev_role;
CREATE ROLE IF NOT EXISTS deploy_acc_role;
CREATE ROLE IF NOT EXISTS deploy_prod_role;

-- 2. Create Service Users for Each Environment with Basic Authentication
CREATE USER IF NOT EXISTS deploy_dev_user PASSWORD='CHANGE-TO-SOMETHING-SAFE' DEFAULT_ROLE = deploy_dev_role MUST_CHANGE_PASSWORD = FALSE;
CREATE USER IF NOT EXISTS deploy_acc_user PASSWORD='CHANGE-TO-SOMETHING-SAFE' DEFAULT_ROLE = deploy_acc_role MUST_CHANGE_PASSWORD = FALSE;
CREATE USER IF NOT EXISTS deploy_prod_user PASSWORD='CHANGE-TO-SOMETHING-SAFE' DEFAULT_ROLE = deploy_prod_role MUST_CHANGE_PASSWORD = FALSE;

-- 3. Grant Roles to Service Users
GRANT ROLE deploy_dev_role TO USER deploy_dev_user;
GRANT ROLE deploy_acc_role TO USER deploy_acc_user;
GRANT ROLE deploy_prod_role TO USER deploy_prod_user;

-- 4. Grant Required Permissions for Each Environment

-- Development Environment
GRANT USAGE ON DATABASE dev_database TO ROLE deploy_dev_role;
GRANT USAGE ON SCHEMA dev_database.dev_schema TO ROLE deploy_dev_role;
GRANT CREATE STREAMLIT ON SCHEMA dev_database.dev_schema TO ROLE deploy_dev_role;
GRANT MODIFY ON SCHEMA dev_database.dev_schema TO ROLE deploy_dev_role;

-- Acceptance Environment
GRANT USAGE ON DATABASE acc_database TO ROLE deploy_acc_role;
GRANT USAGE ON SCHEMA acc_database.acc_schema TO ROLE deploy_acc_role;
GRANT CREATE STREAMLIT ON SCHEMA acc_database.acc_schema TO ROLE deploy_acc_role;
GRANT MODIFY ON SCHEMA acc_database.acc_schema TO ROLE deploy_acc_role;

-- Production Environment
GRANT USAGE ON DATABASE prod_database TO ROLE deploy_prod_role;
GRANT USAGE ON SCHEMA prod_database.prod_schema TO ROLE deploy_prod_role;
GRANT CREATE STREAMLIT ON SCHEMA prod_database.prod_schema TO ROLE deploy_prod_role;
GRANT MODIFY ON SCHEMA prod_database.prod_schema TO ROLE deploy_prod_role;

-- Optional: Grant Monitor Privileges for Debugging (if needed)
GRANT MONITOR ON ACCOUNT TO ROLE deploy_dev_role;
GRANT MONITOR ON ACCOUNT TO ROLE deploy_acc_role;
GRANT MONITOR ON ACCOUNT TO ROLE deploy_prod_role;

-- 5. Grant the Roles to the Appropriate Admin or Management Role
GRANT ROLE deploy_dev_role TO ROLE SYSADMIN;
GRANT ROLE deploy_acc_role TO ROLE SYSADMIN;
GRANT ROLE deploy_prod_role TO ROLE SYSADMIN;
