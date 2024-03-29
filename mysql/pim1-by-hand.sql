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

insert into pim_catalog_product (uuid, id, product_model_id, family_id, raw_values) values
(UUID_TO_BIN(uuid()), 1, 4, 1, '{
    "a1": {
        "<all_channels>": {
            "<all_locales>": "p1 a1 1"
        }
    }
}'),
(UUID_TO_BIN(uuid()), 2, 3, 1, '{
    "a1": {
        "<all_channels>": {
            "<all_locales>": "p2 a1 1"
        }
    },
    "a2": {
        "<all_channels>": {
            "en_US": "p2 a2 us 1",
            "fr_FR": "p2 a2 fr 1"
        }
    }
}'),
(UUID_TO_BIN(uuid()), 3, null, 1, '{
    "a1": {
        "<all_channels>": {
            "<all_locales>": "p3 a1 1"
        }
    },
    "a2": {
        "<all_channels>": {
            "en_US": "p3 a2 us 1",
            "fr_FR": "p3 a2 fr 1"
        }
    }
}');

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

insert into pim_catalog_product_model (id, parent_id, family_variant_id, raw_values) values
(3, null, 2, '{
    "a3": {
        "<all_channels>": {
            "<all_locales>": "pm3 a3 1"
        }
    }
}'),
(4, 3, 2, '{
    "a4": {
        "<all_channels>": {
            "<all_locales>": "pm4 a4 1"
        }
    }
}');

drop table if exists pim_catalog_attribute;
create table pim_catalog_attribute (
  id int,
  code varchar(255),
  primary key (id)
);

insert into pim_catalog_attribute (id, code) values
(1, 'a1'),
(2, 'a2');

drop table if exists pim_catalog_attribute_translation;
create table pim_catalog_attribute_translation (
  foreign_key int,
  label text,
  locale varchar(255),
  primary key (foreign_key, locale)
);

insert into pim_catalog_attribute_translation (foreign_key, locale, label) values
(1, 'en_US', 'a1 US'),
(1, 'fr_FR', 'a1 FR'),
(2, 'fr_FR', 'a2 FR');
