BEGIN;

--
--  Update stocks currency data
--

CREATE OR REPLACE FUNCTION mapping_service.update_stocks_currencies_data(
    stock_currencies_data jsonb
)
    RETURNS integer
    LANGUAGE plpgsql
    SECURITY DEFINER
AS $$
    #variable_conflict use_variable
DECLARE
    synced_count integer;
BEGIN
    INSERT INTO mapping_service.stocks_currencies_data(
        stock_id,
        currency_ticker,
        currency_name,
        network_ticker,
        network_name,
        contract_address
    )
    SELECT sd.id, j_scd.currency_ticker, j_scd.currency_name, j_scd.network_ticker, j_scd.network_name, j_scd.contract_address
    FROM jsonb_to_recordset(stock_currencies_data) AS j_scd(
            stock_type varchar,
            currency_ticker varchar,
            currency_name text,
            network_ticker varchar,
            network_name text,
            contract_address text
        )
        INNER JOIN mapping_service.stocks AS sd
            ON sd.stock_type = j_scd.stock_type

        ON CONFLICT ON CONSTRAINT unique_stock_currency_data DO UPDATE
            SET contract_address = EXCLUDED.contract_address,
                updated_at = EXCLUDED.updated_at::timestamptz
            WHERE mapping_service.stocks_currencies_data.contract_address <> EXCLUDED.contract_address
    ;

    GET DIAGNOSTICS synced_count := ROW_COUNT;

    RETURN synced_count;
END
$$;

-- GRANT SELECT, UPDATE, INSERT ON mapping_service.update_stocks_currencies_data TO ${app_role};
-- GRANT SELECT ON mapping_service.update_stocks_currencies_data TO ${app_role_viewer};
