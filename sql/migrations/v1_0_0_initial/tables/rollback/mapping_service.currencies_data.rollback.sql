REVOKE SELECT, UPDATE, INSERT ON mapping_service.currencies_data FROM ${app_role};
REVOKE SELECT ON mapping_service.currencies_data FROM ${app_role_viewer};

DROP TABLE mapping_service.currencies_data;
