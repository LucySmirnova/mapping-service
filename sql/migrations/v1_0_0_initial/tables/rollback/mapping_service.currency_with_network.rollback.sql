REVOKE SELECT, UPDATE, INSERT ON mapping_service.currency_with_network FROM ${app_role};
REVOKE SELECT ON mapping_service.currency_with_network FROM ${app_role_viewer};

DROP TABLE mapping_service.currency_with_network;
