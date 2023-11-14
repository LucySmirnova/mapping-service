BEGIN;

--
--  Update currency with network data
--

CREATE OR REPLACE FUNCTION mapping_service.update_currency_with_network(
    currency_network_data jsonb
)
    RETURNS integer
    LANGUAGE plpgsql
    SECURITY DEFINER
AS $$
    #variable_conflict use_variable
DECLARE
  synced_count integer;
BEGIN
    INSERT INTO mapping_service.currency_with_network(
        currency_id,
        network_id,
        contract_address,
    )
    SELECT cd.id, nd.id, lower(j_cnd.contract_address)
    FROM jsonb_to_recordset(currency_network_data) AS j_cnd(
            cmc_id int,
            ticker varchar,
            name text,
            network_ticker varchar,
            network_name text,
            contract_address text
        )
        INNER JOIN mapping_service.currencies_data AS cd
            ON cd.cmc_id = j_cnd.cmc_id
                AND cd.ticker = j_cnd.ticker
                AND cd.name = j_cnd.name
        INNER JOIN mapping_service.networks_data AS nd
            ON nd.network_ticker = j_cnd.network_ticker
                AND nd.network_name = j_cnd.network_name

        ON CONFLICT ON CONSTRAINT unique_currency_with_network DO UPDATE
            SET contract_address = lower(EXCLUDED.contract_address),
                match_only_by_contract_address = COALESCE(EXCLUDED.match_only_by_contract_address, EXCLUDED.contract_address IS NOT NULL, true),
                updated_at = EXCLUDED.updated_at::timestamptz
            WHERE lower(currency_with_network.contract_address) <> lower(EXCLUDED.contract_address)
    ;

    GET DIAGNOSTICS synced_count := ROW_COUNT;

    RETURN synced_count;

END
$$;

-- GRANT SELECT, UPDATE, INSERT ON mapping_service.update_currency_with_network TO ${app_role};
-- GRANT SELECT ON mapping_service.update_currency_with_network TO ${app_role_viewer};
