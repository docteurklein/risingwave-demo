
```sh
dc exec -T mysql mysql -uroot -proot -e 'create database pim1'
dc exec -T mysql mysql -uroot -proot pim1 < mysql/pim1.sql
dc exec -T mysql mysql -uroot -proot pim1 < mysql/stats.sql

psql -h localhost -p 4566 -d dev -U root < rw/product.sql

dc exec -T mysql mysql -uroot -proot pim1 << 'SQL'
    update pim_catalog_product set raw_values = 
      JSON_MERGE_PATCH(raw_values, '{"desc3": {"<all_channels>": {"<all_locales>": 4}}}')
    where id = 1;
SQL

#dc exec redpanda rpk topic consume product_value_edited

export CLOUDSDK_API_ENDPOINT_OVERRIDES_PUBSUB=http://localhost:8085/
gcloud pubsub --project my-project-id topics create  all_pims.pim_catalog_product
gcloud pubsub --project my-project-id topics create  all_pims.pim_catalog_product_model
gcloud pubsub --project my-project-id subscriptions create --topic all_pims.pim_catalog_product all_pims.pim_catalog_product --retain-acked-messages
gcloud pubsub --project my-project-id subscriptions create --topic all_pims.pim_catalog_product_model all_pims.pim_catalog_product_model --retain-acked-messages


curl -X PUT "localhost:9200/product?pretty" -H 'Content-Type: application/json' -d'
  {
    "mappings": {
      "dynamic": "strict",
      "properties": {
        "tenant": {
          "type": "keyword"
        },
        "id": {
          "type": "keyword"
        },
        "raw_values": {
          "type": "flattened"
        }
      }
    }
  }
'
```

### generate RW dll from mysql

```
dc exec -T mysql mysql -q -uroot -proot akeneo_pim < mysql/export-schema.sql

dc exec -T mysql mysql -q -uroot -proot akeneo_pim -e 'select def from pim_table where table_name = "pim_catalog_attribute"' | tail -n +2 |
  jq -r --arg 'creds' '{}' '"create table \(.table) (
    tenant text, \(.cols.rw_table_ddl),
    primary key (tenant, \(.pkeys.rw_ddl))
  ) with (
    connector = \'google_pubsub\',
    pubsub.subscription = \'projects/my-project-id/subscriptions/all_pims.\(.table)\',
    pubsub.credentials = \'\($creds)\',
    pubsub.emulator_host = \'pubsub-emulator:8085\',
  ) format debezium encode json;
"' | psql -h localhost -p 4566 -d dev -U root


dc exec -T mysql mysql -q -uroot -proot akeneo_pim -e 'select def from pim_table where table_name = "pim_catalog_product"' | tail -n +2 |
  jq -r --arg 'creds' '{}' '"create sink \(.table)_to_pim2 as
    select \(.cols.rw_sink_cols) from \(.table) where tenant = \'akeneo_pim\'
  with (
    connector = \'jdbc\',
    jdbc.url = \'jdbc:mysql://mysql2:3306/pim2?user=root&password=root\',
    primary_key = \'uuid\',
    table.name = \'\(.table)\',
    type = \'upsert\'
  )

  "'| psql -h localhost -p 4566 -d dev -U root

```