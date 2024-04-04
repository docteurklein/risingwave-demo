drop sink if exists product_pim1_to_pim2;
drop sink if exists product_to_es;

create sink product_pim1_to_pim2 as
    select
        uuid,
        id,
        product_model_id,
        raw_values
    from product
    where tenant = 'pim1'
with (
  connector = 'jdbc',
  jdbc.url = 'jdbc:mysql://mysql2:3306/pim2?user=root&password=root',
  primary_key = 'uuid',
  table.name = 'pim_catalog_product',
  type = 'upsert'
);

create view es_product as
select p.tenant, p.id,
coalesce(ppm.raw_values, '{}') || coalesce(pm.raw_values, '{}') || p.raw_values raw_values
from product p
left join product_model pm on (p.tenant, p.product_model_id) = (pm.tenant, pm.id)
left join product_model ppm on (pm.tenant, pm.parent_id) = (ppm.tenant, ppm.id);

create sink product_to_es
from es_product
with (
  connector = 'elasticsearch',
  url = 'http://es:9200',
  index = 'product',
  primary_key = 'tenant, id',
  delimiter = '-',
);
