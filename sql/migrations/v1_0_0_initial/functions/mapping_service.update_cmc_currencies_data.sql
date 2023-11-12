BEGIN;

--
--  Update currency data by cmc
--

CREATE OR REPLACE FUNCTION mapping_service.update_cmc_currencies_data(
    currencies_data jsonb
)
    RETURNS integer
    LANGUAGE plpgsql
    SECURITY DEFINER
AS $$
    #variable_conflict use_variable
DECLARE
    synced_count integer;
BEGIN
    INSERT INTO mapping_service.cmc_currencies_data(
        cmc_id,
        symbol,
        name,
        slug,
        category,
        platforms
    )
    SELECT *
    FROM jsonb_to_recordset(currencies_data) AS j_cd(
            cmc_id int,
            symbol varchar,
            name text,
            slug text,
            category varchar,
            platforms jsonb
        )

        ON CONFLICT ON CONSTRAINT unique_cmc_currency DO UPDATE
            SET symbol = EXCLUDED.symbol,
                name = EXCLUDED.name,
                slug = EXCLUDED.slug,
                category = EXCLUDED.category,
                platforms = EXCLUDED.platforms,
                updated_at = EXCLUDED.updated_at::timestamptz
    ;

    GET DIAGNOSTICS synced_count := ROW_COUNT;

    RETURN synced_count;
END
$$;

-- GRANT SELECT, UPDATE, INSERT ON mapping_service.update_cmc_currencies_data TO ${app_role};
-- GRANT SELECT ON mapping_service.update_cmc_currencies_data TO ${app_role_viewer};
