CREATE TABLE mapping_service.consumers (
    consumer_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    consumer_name       TEXT NOT NULL,

    CONSTRAINT unique_consumer UNIQUE(consumer_name)
);

GRANT SELECT, UPDATE, INSERT ON mapping_service.consumers TO ${app_role};
GRANT SELECT ON mapping_service.consumers TO ${app_role_viewer};
