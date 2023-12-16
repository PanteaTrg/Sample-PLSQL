declare
  qry                  varchar2(5000);
  effdate              date := to_date('5/19/2020', 'mm/dd/yyyy');
  user_id              varchar2(1000) := 'pantea';
  search_number        varchar2(50)   := '8080';
  deposit_filter_query varchar2(5000) := '  deposit_group_code =  -1
                                      and deposit_group_desc =  -1                                      
                                      and currency_desc      = ''-1''
                                      group by customer_num
                                      having sum(dep_avg_balance) > 1'; -- removed semi-colon
  
  initial_dml           varchar2(5000) := 'insert into dep_filter_cust (col1, col2)' || chr(10) -- alway define the columns in INSERT
             || 'select distinct customer_num , :SEARCH_NUM
                from vmi_customer_deposit_detail v
                  inner join branchlf_user b
                on b.userid = :USER_ID
                  and dep_branch_cod = v.dep_branch_cod
             where effective_date = :EFFDATE' || CHR(10); -- chr(10) === \n; NEWLINE character for visualisation

actual_sql  varchar2(32767);
c   pls_integer;
ret PLS_INTEGER;

begin

  -- build your SQL (I do this in a separate function)
  actual_sql := initial_dml || ' and ' || deposit_filter_query;

  -- debug results
  dbms_output.put_line( actual_sql );

  -- get your cursor
  c := dbms_sql.open_cursor();

  -- parse the SQL
  dbms_sql.parse( c, actual_sql, DBMS_SQL.NATIVE );

  -- bind variables (this can be dynamic if needed)
  -- Oracle can use NAMED Binds
  dbms_sql.bind_variable( c, ':SEARCH_NUM', search_number );
  dbms_sql.bind_variable( c, ':USER_ID', user_id );
  dbms_sql.bind_variable( c, ':EFFDATE', effdate );

  -- execute
  ret := dbms_sql.execute( c );

  -- close the cursor
  dbms_sql.close_cursor( c );
end;
