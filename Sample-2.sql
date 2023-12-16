

--Sample - 2

create or replace sample_function (
   v_field1 tablename.field1%type default 1,
   v_field2 tablename.field2%type default null,
   v_field3 tablename.field3%type default 'some value') is
   v_base_query varchar2(2000) := 
      'with binds as (
          select :bind1 as field1,
                 :bind2 as field2,
                 :bind3 as field3
            from dual)
       select t.field4, b.field3 from tablename t, binds b
       where 1=1 ';
   v_where varchar2(2000);
   cur_tablename sys_refcursor;
begin
   if v_field1 is not null then
      v_where := v_where || ' and t.field1 = b.field1';
   end if;
   if v_field2 is not null then
      v_where := v_where || ' and t.field2 = b.field2';
   end if;
   if v_field3 is not null then
      v_where := v_where || ' and t.field3 <= b.field3';
   end if;
   open cur_tablename for v_base_query || v_where
      using v_field1, v_field2, v_field3;
   return cur_tablename;
end sample_function;
