
```sh
dc exec -T mysql mysql -uroot -proot -e 'create database pim1'
dc exec -T mysql mysql -uroot -proot pim1 < mysql/pim1.sql
dc exec -T mysql mysql -uroot -proot pim1 < mysql/stats.sql

psql -h localhost -p 4566 -d dev -U root < rw/product.sql

dc exec -T mysql mysql -uroot -proot pim1 << 'SQL'
    update pim_catalog_product set raw_values =
    json_set(raw_values, '$.name."<all_channels>"."<all_locales>"', random())
    where id = 1
SQL

dc exec redpanda rpk topic consume all_pim_product_value_edited
```
