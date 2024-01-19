
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
gcloud pubsub --project my-project-id subscriptions create --topic all_pims.pim_catalog_attribute_translation all_pims.pim_catalog_attribute_translation  --retain-acked-messages
gcloud pubsub --project my-project-id subscriptions create --topic all_pims.pim_catalog_attribute all_pims.pim_catalog_attribute --retain-acked-messages
gcloud pubsub --project my-project-id subscriptions create --topic all_pims.pim_catalog_product all_pims.pim_catalog_product --retain-acked-messages
```
