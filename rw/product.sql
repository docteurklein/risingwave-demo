create schema if not exists pim1;

set search_path to pim1, public;

drop sink if exists product_stats;
drop sink if exists product_value_edited;
drop sink if exists product_to_es;
drop view if exists es_product;
drop materialized view if exists product_value;

create materialized view product_value as
  with by_raw_value (uuid, rest) as (
    select uuid, jsonb_each(raw_values) from pim1.product
  ),
  by_attr (uuid, attribute, rest) as (
    select uuid, (rest).key, jsonb_each((rest).value)
    from by_raw_value
  ),
  by_channel (uuid, attribute, channel, rest) as (
    select uuid, attribute, nullif((rest).key, '<all_channels>'), jsonb_each((rest).value)
    from by_attr
  ),
  by_locale (uuid, attribute, channel, locale, value) as (
    select uuid, attribute, channel, nullif((rest).key, '<all_locales>'), (rest).value
    from by_channel
  )
  select * from by_locale
;

-- create sink product_stats as
--   select coalesce(p.family_id, 0) family, count(*) as num_values
--   from pim1.product_value pv
--   inner join pim1.product p using (uuid)
--   group by 1
-- with (
--   connector = 'jdbc',
--   jdbc.url = 'jdbc:mysql://mysql:3306/pim1?user=root&password=root',
--   primary_key = 'family',
--   table.name = 'product_stats',
--   type = 'upsert'
-- );

-- create sink product_value_edited
-- from pim1.product_value
-- with (
--   connector = 'kafka',
--   type = 'upsert',
--   primary_key = 'uuid, attribute, channel, locale',
--   properties.bootstrap.server = 'redpanda:9092',
--   topic = 'product_value_edited'
-- );

create view es_product as
select p.uuid::text pkey, -- concat_ws('-', p.uuid, coalesce(pv.channel, 'any'), coalesce(pv.locale, 'any')) pkey,
p.id, -- pv.channel, pv.locale,
jsonb_object_agg(
  concat_ws('-', pv.attribute, coalesce(pv.channel, 'any'), coalesce(pv.locale, 'any')),
  pv.value
) values
from pim1.product p
join pim1.product_value pv using (uuid)
-- join pim1.attribute a on (pv.attribute = a.code)
-- left join pim1.attribute_translation at on (a.id = at.foreign_key and at.locale = pv.locale)
group by 1, 2;

create sink product_to_es
from es_product
with (
  connector = 'elasticsearch',
  index = 'product',
  url = 'http://es:9200',
);
