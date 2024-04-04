drop table if exists pim_catalog_product;
create table pim_catalog_product (
  uuid binary(16),
  family_id int,
  product_model_id int,
  family_variant_id int,
  id int,
  is_enabled bool,
  identifier text,
  raw_values json,
  created timestamp,
  updated timestamp,
  primary key (uuid)
);

drop table if exists pim_catalog_product_model;
create table pim_catalog_product_model (
  id int,
  code text,
  parent_id int,
  family_variant_id int,
  raw_values json,
  created timestamp,
  updated timestamp,
  primary key (id)
);

drop table if exists pim_catalog_attribute;
create table pim_catalog_attribute (
  id int,
  code varchar(255),
  primary key (id)
);

drop table if exists pim_catalog_attribute_translation;
create table pim_catalog_attribute_translation (
  foreign_key int,
  label text,
  locale varchar(255),
  primary key (foreign_key, locale)
);
