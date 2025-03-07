-- This script is provided as a sample setup to use database roles, warehouse, admin role, deploy role as an example.
-- YOu may choose to have your own RBAC and SCHEMACHANGE database setup depending on your organization objectives.
-- Set these to personalize your deployment
SET ADMIN_USER = 'MAGNUS'; -- Name of Admin initializing SCHEMACHANGE.
SET SERVICE_USER = 'SCHEMACHANGE_DEMO_SVC_USER'; -- Service user used to run SCHEMACHANGE deployments.
SET ADMIN_ROLE = 'SCHEMACHANGE_ADMIN'; -- This role will own the database and schemas & granted privileges to create objects in any schema in the database.
SET TARGET_DB_NAME = 'SCHEMACHANGE_DEMO'; -- Name of database that will have the SCHEMACHANGE Schema for change tracking.
SET WAREHOUSE_NAME = 'SCHEMACHANGE_DEMO_WH'; -- Name of warehouse

-- Dependent Variables; Change the naming pattern if you want but not necessary
SET AC_U = '_AC_U_' || $WAREHOUSE_NAME; -- Access Control User (will be granted Usage privileges)
SET AC_O = '_AC_O_' || $WAREHOUSE_NAME; -- Access Control Operator (will be granted Operate privileges)

USE ROLE USERADMIN;
-- Role granted to a human user to manage the database permissions and database roles.
CREATE ROLE IF NOT EXISTS IDENTIFIER($ADMIN_ROLE);
CREATE ROLE IF NOT EXISTS IDENTIFIER($AC_U);
CREATE ROLE IF NOT EXISTS IDENTIFIER($AC_O);
GRANT ROLE IDENTIFIER($AC_U) TO ROLE IDENTIFIER($AC_O);

-- Role hierarchy tied to SYSADMIN;
USE ROLE SECURITYADMIN;
GRANT ROLE IDENTIFIER($ADMIN_ROLE) TO ROLE SYSADMIN;

GRANT ROLE IDENTIFIER($ADMIN_ROLE) TO USER IDENTIFIER($SERVICE_USER);
GRANT ROLE IDENTIFIER($ADMIN_ROLE) TO USER IDENTIFIER($ADMIN_USER);

GRANT OWNERSHIP ON DATABASE IDENTIFIER($TARGET_DB_NAME) TO ROLE IDENTIFIER($ADMIN_ROLE) WITH GRANT OPTION;

GRANT OWNERSHIP ON WAREHOUSE IDENTIFIER($WAREHOUSE_NAME) TO ROLE IDENTIFIER($ADMIN_ROLE) WITH GRANT OPTION;
GRANT USAGE ON WAREHOUSE IDENTIFIER($WAREHOUSE_NAME) TO ROLE IDENTIFIER($AC_U);
GRANT OPERATE ON WAREHOUSE IDENTIFIER($WAREHOUSE_NAME) TO ROLE IDENTIFIER($AC_O);
GRANT ROLE IDENTIFIER($AC_U) TO ROLE IDENTIFIER($ADMIN_ROLE);