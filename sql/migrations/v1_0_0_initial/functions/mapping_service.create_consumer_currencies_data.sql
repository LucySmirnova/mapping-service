BEGIN;

--
--  Create consumers currency data
--

CREATE OR REPLACE FUNCTION mapping_service.create_consumer_currencies_data(
    _consumer_id uuid,
    consumer_currency_data jsonb
)
    RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS $$
    #variable_conflict use_variable
DECLARE
    result jsonb;
    function_response jsonb;

    j_ccd record;
    input_currency_with_network_id int;
    input_consumer_ticker varchar;

    consumer text;
    currency_id int;
    ticker varchar;
BEGIN
    SELECT c.consumer_name
    INTO consumer
    FROM mapping_service.consumers c
    WHERE c.consumer_id = _consumer_id;

    IF consumer IS NULL THEN
        result := JSONB_BUILD_OBJECT(
            'error', 'Not found consumer'
        );

        RETURN result;

    END IF;

    FOR j_ccd IN SELECT *
        FROM jsonb_to_recordset(consumer_currency_data) AS j_ccd(
                currency_with_network_id int,
                consumer_ticker varchar
            )

    LOOP
        input_currency_with_network_id := j_ccd.currency_with_network_id;
        input_consumer_ticker = j_ccd.consumer_ticker;

        SELECT cwn.id
        INTO currency_id
        FROM mapping_service.currency_with_network cwn
        WHERE cwn.id = input_currency_with_network_id;

        IF currency_id IS NULL THEN
            function_response := JSONB_BUILD_OBJECT(
                'input_data', j_ccd,
                'error', 'Not found id currency'
            );

        ELSE
            SELECT ccd.consumer_ticker
            INTO ticker
            FROM mapping_service.consumers_currencies_data ccd
            WHERE ccd.consumer_ticker = lower(input_consumer_ticker)
                AND ccd.consumer_name = consumer;

            IF ticker IS NOT NULL THEN
                function_response := JSONB_BUILD_OBJECT(
                    'input_data', j_ccd,
                    'error', 'Duplicate consumer_ticker'
                );

            ELSE

                UPDATE mapping_service.consumers_currencies_data
                    SET consumer_ticker = lower(input_consumer_ticker)
                WHERE currency_with_network_id = input_currency_with_network_id
                        AND consumer_name = consumer
                ;

                IF FOUND THEN
                    function_response := JSONB_BUILD_OBJECT(
                        'input_data', j_ccd,
                        'result', 'Update ticker'
                    );

                ELSE

                    INSERT INTO mapping_service.consumers_currencies_data(
                        currency_with_network_id,
                        consumer_ticker,
                        consumer_name
                    )
                    VALUES (input_currency_with_network_id, lower(input_consumer_ticker), consumer)

                    ON CONFLICT ON CONSTRAINT unique_consumer_ticker DO NOTHING
                    ;

                    function_response := JSONB_BUILD_OBJECT(
                        'input_data', j_ccd,
                        'result', 'Add ticker'
                    );

                END IF;

            END IF;

        END IF;

        IF result IS NULL THEN
            result := JSONB_BUILD_ARRAY(function_response);
        ELSE
            result := result || JSONB_BUILD_ARRAY(function_response);
        END IF;

    END LOOP;

    RETURN result;

END
$$;

-- GRANT SELECT, UPDATE, INSERT ON mapping_service.create_consumer_currencies_data TO ${app_role};
-- GRANT SELECT ON mapping_service.create_consumer_currencies_data TO ${app_role_viewer};
