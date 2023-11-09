drop table if exists pim1.product;
drop table if exists pim1.attribute;
drop table if exists pim1.attribute_translation;

create table pim1.product (
  uuid bytea,
  family_id int,
  product_model_id int,
  family_variant_id int,
  id int,
  is_enabled bool,
  identifier text,
  raw_values jsonb,
  created timestamptz,
  updated timestamptz,
  primary key (uuid)
)
with (
  connector = 'mysql-cdc',
  hostname = 'mysql',
  port = '3306',
  username = 'root',
  password = 'root',
  database.name = 'pim1',
  table.name = 'pim_catalog_product',
  server.id = '10'
);

create table pim1.attribute (
  id int,
  code text,
  primary key (id)
)
with (
  connector = 'mysql-cdc',
  hostname = 'mysql',
  port = '3306',
  username = 'root',
  password = 'root',
  database.name = 'pim1',
  table.name = 'pim_catalog_attribute',
  server.id = '20'
);

create table pim1.attribute_translation (
  foreign_key int,
  label text,
  locale text,
  primary key (foreign_key, locale)
)
with (
  connector = 'mysql-cdc',
  hostname = 'mysql',
  port = '3306',
  username = 'root',
  password = 'root',
  database.name = 'pim1',
  table.name = 'pim_catalog_attribute_translation',
  server.id = '30'
);

