delete from pim_catalog_product;

insert into pim_catalog_product (uuid, id, family_id, raw_values) values
(UUID_TO_BIN(uuid()), 1, 1, '{
    "a1": {
        "<all_channels>": {
            "<all_locales>": "p1 a1 1"
        }
    }
}'),
(UUID_TO_BIN(uuid()), 2, 1, '{
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

-- update pim_catalog_product
-- set raw_values = JSON_MERGE_PATCH(
--     raw_values, '{
--         "a2": {
--             "<all_channels>": {
--                 "<all_locales>": "p1 a2 2"
--             }
--         }
--     }'
-- )
-- where id = 1;
