select col_id, trim(column_value) val
  from tbl_test,
       xmltable(trim(trailing ',' from
                     regexp_replace(col_name, '(.)', '"\1",')));
