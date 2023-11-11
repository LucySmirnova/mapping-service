--
--  Create schemas / grant access
--
CREATE SCHEMA IF NOT EXISTS mapping_service;

GRANT USAGE ON SCHEMA mapping_service TO ${app_role}, ${app_role_viewer};
