create or replace view pim_table as 
with pkeys(table_schema, table_name, pkeys, rw_ddl) as (
    select table_schema, table_name,
    json_arrayagg(column_name),
    group_concat(column_name order by ordinal_position asc separator ', ')
    from information_schema.columns
    where column_key = 'PRI'
    group by table_schema, table_name
),
type_map(mysql, rw) as (
    values
    row('json', 'jsonb'),
    row('char', 'char'),
    row('varchar', 'text'),
    row('tinytext', 'text'),
    row('mediumtext', 'text'),
    row('longtext', 'text'),
    row('binary', 'text'), -- bytea -- TODO: weirdly, this needs to be handled in mysql sink with `decode(some_col, 'hex')`
    row('varbinary', 'bytea'),
    row('blob', 'bytea'),
    row('mediumblob', 'bytea'),
    row('longblob', 'bytea'),
    row('tinyint', 'bool'),
    row('smallint', 'smallint'),
    row('int', 'int'),
    row('bigint', 'bigint'),
    row('double', 'double'),
    row('decimal', 'decimal'),
    row('datetime', 'timestamp'),
    row('timestamp', 'timestamp'),
    row('time', 'time'),
    row('float', 'float')
    -- enum
    -- set
),
cols(table_schema, table_name, cols, rw_table_ddl, rw_sink_cols) as (
    select table_schema, table_name,
    json_objectagg(column_name, json_object(
        'type', data_type,
        'rw_type', coalesce(t.rw, 'bytea'),
        'nullable', case when is_nullable = 'YES' then true else false end
    )),
    group_concat(
        concat_ws(' ', column_name, coalesce(t.rw, 'bytea'))
        order by ordinal_position asc 
        separator ', '
    ),
    group_concat(
        concat_ws(' ', case when c.data_type = 'binary' then concat('decode(', column_name, ', ''hex'') ', column_name) else column_name end)
        order by ordinal_position asc
        separator ', '
    )
    from information_schema.columns c
    left join type_map t on (c.data_type = t.mysql)
    group by table_schema, table_name
)
select c.table_schema, c.table_name,
json_object(
    'schema', c.table_schema,
    'table', c.table_name,
    'cols', json_object(
        'def', c.cols,
        'rw_table_ddl', c.rw_table_ddl,
        'rw_sink_cols', c.rw_sink_cols
    ),
    'pkeys', json_object(
        'def', pk.pkeys,
        'rw_ddl', pk.rw_ddl
    )
) def,
concat_ws(' ', 'create table', c.table_name, '(', c.rw_table_ddl, ', primary key (', pk.rw_ddl, ')', ')') rw_table_ddl
from cols c
join pkeys pk on (pk.table_schema, pk.table_name) = (c.table_schema, c.table_name)
;
