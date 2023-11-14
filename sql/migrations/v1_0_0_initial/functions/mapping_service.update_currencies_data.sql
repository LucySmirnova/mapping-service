BEGIN;

--
--  Update currency data
--

CREATE OR REPLACE FUNCTION mapping_service.update_currencies_data(
    currencies_data jsonb
)
    RETURNS integer
    LANGUAGE plpgsql
    SECURITY DEFINER
AS $$
    #variable_conflict use_column
DECLARE
    synced_count integer;
BEGIN
    INSERT INTO mapping_service.currencies_data(
        cmc_id,
        ticker,
        name,
        enabled
    )
    SELECT j_cd.cmc_id, j_cd.ticker, j_cd.name, true
        FROM jsonb_to_recordset(currencies_data) AS j_cd(
            cmc_id int,
            ticker varchar,
            name text
        )

        ON CONFLICT (cmc_id) WHERE (cmc_id IS NOT NULL) DO UPDATE
            SET ticker = EXCLUDED.ticker,
                name = EXCLUDED.name,
                enabled = false,
                updated_at = EXCLUDED.updated_at::timestamptz
        WHERE currencies_data.ticker <> EXCLUDED.ticker
            OR currencies_data.name <> EXCLUDED.name
    ;

    GET DIAGNOSTICS synced_count := ROW_COUNT;

    RETURN synced_count;
END
$$;

-- GRANT SELECT, UPDATE, INSERT ON mapping_service.update_currencies_data TO ${app_role};
-- GRANT SELECT ON mapping_service.update_currencies_data TO ${app_role_viewer};
