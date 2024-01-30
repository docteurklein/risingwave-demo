drop sink if exists product_to_es;
drop view if exists es_product;
drop table if exists product;
drop table if exists product_model;

create table product (
    tenant text,
    id int,
    product_model_id int,
    raw_values jsonb,
    primary key (tenant, id)
) with (
    connector = 'kafka',
    topic = 'all_pims.pim_catalog_product',
    properties.bootstrap.server = 'redpanda:9092'
    -- connector = 'google_pubsub',
    -- pubsub.subscription = 'projects/my-project-id/subscriptions/all_pims.pim_catalog_product',
    -- pubsub.credentials = '{}',
    -- pubsub.emulator_host = 'pubsub-emulator:8085',
    -- pubsub.split_count = 1
) format debezium encode json;

create table product_model (
    tenant text,
    id int,
    parent_id int,
    raw_values jsonb,
    primary key (tenant, id)
) with (
    connector = 'kafka',
    topic = 'all_pims.pim_catalog_product_model',
    properties.bootstrap.server = 'redpanda:9092'
    -- connector = 'google_pubsub',
    -- pubsub.subscription = 'projects/my-project-id/subscriptions/all_pims.pim_catalog_product_model',
    -- pubsub.credentials = '{}',
    -- pubsub.emulator_host = 'pubsub-emulator:8085',
    -- pubsub.split_count = 1
) format debezium encode json;

create view es_product as
select p.id,
coalesce(ppm.raw_values, '{}') || coalesce(pm.raw_values, '{}') || coalesce(p.raw_values, '{}') raw_values
from product p
left join product_model pm on (p.product_model_id = pm.id)
left join product_model ppm on (pm.parent_id = ppm.id);

create sink product_to_es
from es_product
with (
  connector = 'elasticsearch',
  index = 'product',
  url = 'http://es:9200',
);
