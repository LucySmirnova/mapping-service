CREATE TABLE mapping_service.mappings_with_stock_currencies (
    currency_with_network_id        INT NOT NULL,
    stock_currency_id               INT NOT NULL,
    enabled boolean                 DEFAULT false,

    CONSTRAINT unique_mappings UNIQUE(stock_currency_id)
);

-- index for search by currency_with_network_id
CREATE INDEX mappings_currency_with_network_id_idx
    ON mapping_service.mappings_with_stock_currencies
    USING btree(currency_with_network_id);

GRANT SELECT, UPDATE, INSERT ON mapping_service.mappings_with_stock_currencies TO ${app_role};
GRANT SELECT ON mapping_service.mappings_with_stock_currencies TO ${app_role_viewer};
