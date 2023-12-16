create or replace procedure Injection_test(p_qry1    varchar2,
                                           p_qry2    varchar2,
                                           p_user_id varchar2) is
  final_query varchar2(1000) := '';
begin

  -- put some logic here to validate the content of p_qry1 and p_qry2 to make sure
  -- they don't contain keywords like "select", "update", "delete", "1=1", ";" or
  -- equivalents, and/or that they do contain things you expect to see. Raise an
  -- application error anything unexpected is found

  if p_qry1 is not null then
    final_query := 'select c_num from z_test_a where userid = :user_id and ' || qry1;
    if p_qry2 is not null then
      final_query := final_query || ' intersect ';
    end if;
  end if;

  if p_qry2 is not null then
    final_query := final_query ||
                   'select c_num from z_test_b where userid = :user_id and ' || qry2;
  end if;

  if final_query is not null then
    final_query := 'insert into Z_final_result (c_num) ' || final_query;
    --dbms_output.put_line(final_query);
  
    if instr(final_query, 'intersect') > 1 then
      execute immediate final_query
        using p_user_id, p_user_id;
    else
      execute immediate final_query
        using p_user_id;
    end if;
  
    commit;
  end if;
end;
