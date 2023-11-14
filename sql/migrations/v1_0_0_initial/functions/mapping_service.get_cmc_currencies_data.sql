BEGIN;

--
--  Get cmc data
--

CREATE OR REPLACE FUNCTION mapping_service.get_cmc_currencies_data()
    RETURNS TABLE (
        cmc_id int,
        ticker varchar,
        name text,
        slug text,
        category varchar,
        network_name text,
        contract_address text,
        network_coin_id int,
        network_coin_name text,
        network_coin_slug text,
        network_ticker varchar
    )
    LANGUAGE plpgsql
    SECURITY DEFINER
AS $$
    #variable_conflict use_column
BEGIN
    RETURN QUERY
    WITH
        separate_contract_address AS (
            SELECT ccd.cmc_id, ccd.symbol, ccd.name, ccd.slug, ccd.category,
                    specs.platform, specs.contract_address
	            FROM
                    mapping_service.mapping_service.cmc_currencies_data ccd,
  		            JSONB_TO_RECORDSET(ccd.platforms) AS specs(platform jsonb, contract_address text)
        ),
        separate_network_name AS (
            SELECT sca.cmc_id, sca.symbol, sca.name, sca.slug, sca.category,
                    specs.coin, specs.name AS network_name, sca.contract_address
	            FROM
                    separate_contract_address sca,
  		            JSONB_TO_RECORD(sca.platform) AS specs(coin jsonb, name text)
        ),
        currency_data_with_platforms AS (
            SELECT snn.cmc_id, snn.symbol, snn.name, snn.slug, snn.category,
                    snn.network_name, snn.contract_address,
		            specs.id AS network_coin_id, specs.name AS network_coin_name, specs.slug AS network_coin_slug, specs.symbol AS network_coin_symbol
	            FROM
                    separate_network_name snn,
  		            JSONB_TO_RECORD(snn.coin) AS specs(id int, name text, slug text, symbol varchar)
        ),
        only_network_data AS (
        	SELECT DISTINCT snn.network_name, snn.network_coin_id, snn.network_coin_name, snn.network_coin_slug, snn.network_coin_symbol
        	    FROM currency_data_with_platforms snn
        ),
        currency_data_without_platforms AS (
        	SELECT DISTINCT ccd.cmc_id, ccd.symbol, ccd.name, ccd.slug, ccd.category,
        		    cd_with_p.network_name, NULL AS contract_address,
        		    cd_with_p.network_coin_id, cd_with_p.network_coin_name, cd_with_p.network_coin_slug, cd_with_p.network_coin_symbol
                FROM mapping_service.mapping_service.cmc_currencies_data ccd
                	INNER JOIN only_network_data cd_with_p
                            ON ccd.cmc_id = cd_with_p.network_coin_id
	            	WHERE ccd.platforms = '[]'
                    AND ccd.category = 'coin'
	       UNION
	       SELECT ccd.cmc_id, ccd.symbol, ccd.name, ccd.slug, ccd.category,
        		    ccd.name, NULL AS contract_address,
        		    NULL, NULL, NULL, ccd.symbol
                FROM mapping_service.mapping_service.cmc_currencies_data ccd
                	LEFT JOIN only_network_data cd_with_p
                            ON ccd.cmc_id = cd_with_p.network_coin_id
	            	WHERE ccd.platforms = '[]'
                      AND ccd.category = 'coin'
                      AND cd_with_p.network_coin_id IS NULL
	       UNION
	       SELECT ccd.cmc_id, ccd.symbol, ccd.name, ccd.slug, ccd.category,
        		    NULL, NULL,
        		    NULL, NULL, NULL, NULL
                FROM mapping_service.mapping_service.cmc_currencies_data ccd
	            	WHERE ccd.platforms = '[]'
                        AND ccd.category = 'token'
        ),
        completed AS (
        	SELECT *
        	    FROM currency_data_with_platforms
        	UNION
        	SELECT *
        	    FROM currency_data_without_platforms
        )
    SELECT *
    FROM completed
    ;

END
$$;

-- GRANT SELECT, UPDATE, INSERT ON mapping_service.get_cmc_currencies_data TO ${app_role};
-- GRANT SELECT ON mapping_service.get_cmc_currencies_data TO ${app_role_viewer};
