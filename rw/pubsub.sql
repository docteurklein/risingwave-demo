drop sink if exists product_to_es;
drop table if exists dbz_cdc;

create table dbz_cdc (
    id int,
    raw_values jsonb,
    primary key (id)
) with (
    connector = 'google_pubsub',
    pubsub.subscription = 'projects/my-project-id/subscriptions/all_pims.pim_catalog_product',
    -- pubsub.credentials = '{}',
    pubsub.emulator_host = 'pubsub-emulator:8085',
    pubsub.split_count = 1
) format debezium encode json;

create sink product_to_es
from dbz_cdc
with (
  connector = 'elasticsearch',
  index = 'product',
  url = 'http://es:9200',
);
