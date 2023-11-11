REVOKE USAGE ON SCHEMA mapping_service FROM ${app_role}, ${app_role_viewer};
DROP SCHEMA mapping_service CASCADE;
