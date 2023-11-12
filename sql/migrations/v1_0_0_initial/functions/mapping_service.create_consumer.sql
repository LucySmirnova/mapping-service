BEGIN;

--
--  Create consumer
--

CREATE OR REPLACE FUNCTION mapping_service.create_consumer(
    _consumer_name text,
    _consumer_id uuid DEFAULT gen_random_uuid()
)
    RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS $$
DECLARE
    result jsonb;
    consumer text;
    result_consumer_id uuid;
BEGIN
    SELECT c.consumer_name
    INTO consumer
    FROM mapping_service.consumers c
    WHERE c.consumer_name = _consumer_name;

    IF consumer IS NOT NULL THEN
        result := JSONB_BUILD_OBJECT(
            'error', 'A user with the same name already exists'
        );

        RETURN result;

    END IF;

    WITH
        completed AS (
            INSERT INTO mapping_service.consumers (consumer_name)
            VALUES (_consumer_name)

            ON CONFLICT ON CONSTRAINT unique_consumer DO NOTHING

            RETURNING *
        )
    SELECT
        (SELECT c.consumer_id FROM completed c)
    INTO
        result_consumer_id
    ;

    result := JSONB_BUILD_OBJECT(
        'consumer_id', result_consumer_id
    );

    RETURN result;
END
$$;

-- GRANT SELECT, UPDATE, INSERT ON mapping_service.create_consumer TO ${app_role};
-- GRANT SELECT ON mapping_service.create_consumer TO ${app_role_viewer};
