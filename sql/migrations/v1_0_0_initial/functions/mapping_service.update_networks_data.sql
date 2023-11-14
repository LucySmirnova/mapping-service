BEGIN;

--
--  Update networks data
--

CREATE OR REPLACE FUNCTION mapping_service.update_networks_data(
    networks_data jsonb
)
    RETURNS integer
    LANGUAGE plpgsql
    SECURITY DEFINER
AS $$
    #variable_conflict use_variable
DECLARE
    synced_count integer;
BEGIN
    INSERT INTO mapping_service.networks_data(
        network_ticker,
        network_name
    )
    SELECT *
    FROM jsonb_to_recordset(networks_data) AS j_nd(
            network_ticker varchar,
            network_name text
        )

        ON CONFLICT ON CONSTRAINT unique_network DO NOTHING;

    GET DIAGNOSTICS synced_count := ROW_COUNT;

    RETURN synced_count;

END
$$;

-- GRANT SELECT, UPDATE, INSERT ON mapping_service.update_networks_data TO ${app_role};
-- GRANT SELECT ON mapping_service.update_networks_data TO ${app_role_viewer};
