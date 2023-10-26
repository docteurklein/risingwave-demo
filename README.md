
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

dc exec redpanda rpk topic consume product_value_edited
```
