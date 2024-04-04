-- insert into pim_catalog_product (uuid, id, product_model_id, family_id, raw_values, is_enabled, created, updated) values (UUID_TO_BIN(uuid()), 1, null, null, '{}', 1, now(), now());

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

insert into pim_catalog_attribute (id, code) values
(1, 'a1'),
(2, 'a2');


insert into pim_catalog_attribute_translation (foreign_key, locale, label) values
(1, 'en_US', 'a1 US'),
(1, 'fr_FR', 'a1 FR'),
(2, 'fr_FR', 'a2 FR');
