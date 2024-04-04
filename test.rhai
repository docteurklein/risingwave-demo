const colMap = #{
	pim_catalog_product: #{
        "@0": "uuid",
        "@1": "family_id",
        "@2": "product_model_id",
        "@3": "family_variant_id",
        "@4": "id",
        "@5": "is_enabled",
        "@6": "identifier",
        "@7": "raw_values",
        "@8": "created",
        "@9": "updated",
    },
	pim_catalog_product_model: #{
        "@0": "id",
        "@1": "code",
        "@2": "parent_id",
        "@3": "family_variant_id",
        "@4": "raw_values",
        "@5": "created",
        "@6": "updated",
    },
};

fn rename(table, fields) {
	let to = #{};
	let t = global::colMap[table];
	for k in fields.keys() {
		let nk = t[k] ?? k;
		if nk == "uuid" {
			fields[k].crop(2);
		}
		to.set(nk, fields[k]);
	}
	to
}

fn transform(db, table, changeType, before, after, ts) {
	before.tenant = db;
	after.tenant = db;
	#{
		payload: #{
			before: rename(table, before),
			after: rename(table, after),
			op: switch changeType {
				"INSERT" => "c",
				"UPDATE" => "u",
				"DELETE" => "d",
				_ => changeType,
			},
			source: #{
				ts_ms: ts,
				db: db,
				table: table,
			},
			ts_ms: ts,
		}
	}
}

fn topic(db, table) {
	`projects/my-project-id/topics/all_pims.${table}`
}

