insert into pim_catalog_product (uuid, id, family_id, is_enabled, created, updated, raw_values) values
(UUID_TO_BIN(uuid()), 1, 1, true, now(), now(), '{
    "a1": {
        "<all_channels>": {
            "<all_locales>": "p1 a1 1"
        }
    }
}'),
(UUID_TO_BIN(uuid()), 2, 1, true, now(), now(), '{
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
}');

-- insert into pim_catalog_attribute (id, code) values
-- (1, 'a1'),
-- (2, 'a2');

-- insert into pim_catalog_attribute_translation (foreign_key, locale, label) values
-- (1, 'en_US', 'a1 US'),
-- (1, 'fr_FR', 'a1 FR'),
-- (2, 'fr_FR', 'a2 FR');
