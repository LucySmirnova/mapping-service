CREATE TABLE mapping_service.consumers_currencies_data (
    id                              INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    tt_currency_with_network_id     INT NOT NULL,
    consumer_ticker                 VARCHAR(50) NOT NULL,
    consumer_name                   TEXT NOT NULL,

    CONSTRAINT unique_consumer_ticker UNIQUE(tt_currency_with_network_id, consumer_ticker, consumer_name)
);

-- index for search by consumer_ticker
CREATE INDEX consumers_currencies_data_consumer_ticker_idx
    ON mapping_service.consumers_currencies_data
    USING btree(consumer_ticker);

GRANT SELECT, UPDATE, INSERT ON mapping_service.consumers_currencies_data TO ${app_role};
GRANT SELECT ON mapping_service.consumers_currencies_data TO ${app_role_viewer};
