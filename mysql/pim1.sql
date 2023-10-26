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
  quantified_associations json,
  primary key (uuid)
);

insert into pim_catalog_product (uuid, id, family_id, raw_values) values
(UUID_TO_BIN(uuid()), 1, 1, '{}'),
(UUID_TO_BIN(uuid()), 2, 1, '{}');
