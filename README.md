
```sh
dc exec -T mysql mysql -uroot -proot -e 'create database pim1'
dc exec -T mysql mysql -uroot -proot pim1 < mysql/pim1.sql
dc exec -T mysql mysql -uroot -proot pim1 < mysql/stats.sql

psql -h localhost -p 4566 -d dev -U root < rw/product.sql
```
