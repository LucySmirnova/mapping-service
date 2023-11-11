CREATE TABLE mapping_service.cmc_currencies_data (
    cmc_id          INT NOT NULL PRIMARY KEY,
    symbol          VARCHAR(50) NOT NULL,
    name            TEXT DEFAULT NULL,
    slug            TEXT DEFAULT NULL,
    category        VARCHAR(15) NOT NULL,
    platforms       jsonb NOT NULL DEFAULT '[]'::jsonb,
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT unique_cmc_currency UNIQUE(cmc_id)
);

GRANT SELECT, UPDATE, INSERT ON mapping_service.cmc_currencies_data TO ${app_role};
GRANT SELECT ON mapping_service.cmc_currencies_data TO ${app_role_viewer};
