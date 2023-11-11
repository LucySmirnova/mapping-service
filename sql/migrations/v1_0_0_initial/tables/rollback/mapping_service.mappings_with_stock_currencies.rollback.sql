REVOKE SELECT, UPDATE, INSERT ON mapping_service.mappings_with_stock_currencies FROM ${app_role};
REVOKE SELECT ON mapping_service.mappings_with_stock_currencies FROM ${app_role_viewer};

DROP TABLE mapping_service.mappings_with_stock_currencies;
