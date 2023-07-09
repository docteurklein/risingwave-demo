create schema pim1;

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
  quantified_associations jsonb,
  primary key (uuid)
) with (
 connector = 'mysql-cdc',
 hostname = 'mysql',
 port = '3306',
 username = 'root',
 password = 'root',
 database.name = 'pim1',
 table.name = 'pim_catalog_product',
 server.id = '1'
);

drop sink if exists product_stats;
drop materialized view if exists pim1.product_value;

create materialized view pim1.product_value as
  with by_raw_value (product_id, rest) as (
    select id, jsonb_each(raw_values) from pim1.product
  ),
  by_attr (product_id, attribute, rest) as (
    select product_id, (rest).key, jsonb_each((rest).value)
    from by_raw_value
  ),
  by_channel (product_id, attribute, channel, rest) as (
    select product_id, attribute, nullif((rest).key, '<all_channels>'), jsonb_each((rest).value)
    from by_attr
  ),
  by_locale (product_id, attribute, channel, locale, value) as (
    select product_id, attribute, channel, nullif((rest).key, '<all_locales>'), (rest).value
    from by_channel
  )
  select * from by_locale
;

create sink product_stats as
select coalesce(p.family_id, 0) family, count(*) as num_values
from pim1.product_value pv
inner join pim1.product p on (pv.product_id = p.id)
group by 1
with (
    connector='jdbc',
    jdbc.url='jdbc:mysql://mysql:3306/pim1?user=root&password=root',
    table.name='product_stats',
    type='upsert'
);
