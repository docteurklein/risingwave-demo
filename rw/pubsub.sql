drop table if exists product cascade;
drop table if exists product_model cascade;

create table product (
    tenant text,
    uuid text,
    id int,
    product_model_id int,
    raw_values jsonb,
    primary key (tenant, uuid)
) with (
    -- connector = 'kafka',
    -- topic = 'all_pims.pim_catalog_product',
    -- properties.bootstrap.server = 'redpanda:9092'
    connector = 'google_pubsub',
    pubsub.subscription = 'projects/my-project-id/subscriptions/all_pims.pim_catalog_product',
    pubsub.credentials = '{}',
    pubsub.emulator_host = 'pubsub-emulator:8085',
) format debezium encode json;

create table product_model (
    tenant text,
    id int,
    parent_id int,
    raw_values jsonb,
    primary key (tenant, id)
) with (
    -- connector = 'kafka',
    -- topic = 'all_pims.pim_catalog_product_model',
    -- properties.bootstrap.server = 'redpanda:9092'
    connector = 'google_pubsub',
    pubsub.subscription = 'projects/my-project-id/subscriptions/all_pims.pim_catalog_product_model',
    pubsub.credentials = '{}',
    pubsub.emulator_host = 'pubsub-emulator:8085',
) format debezium encode json;

