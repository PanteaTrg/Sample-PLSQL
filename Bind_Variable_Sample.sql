create or replace procedure sample_bind_variable(i_c_num    number,
                                                 i_c_name   varchar2,
                                                 i_emp_name varchar2,
                                                 o_out      out sys_refcursor) is

  v_base_query varchar2(2000) := '
  with binds as (select :bind1 as C_NUM,
                        :bind2 as C_NAME,
                        :bind3 as EMP_NAME
                 from dual )
    select t.* from z_test_a t , binds b where 1=1  ';
  v_where      varchar2(2000);
begin

  if i_c_num is not null then
    v_where := v_where || ' and t.C_NUM = b.C_NUM  ';
    end if;

  if i_c_name is not null then
    v_where := v_where || ' and t.C_NAME = b.C_NAME  ';
    end if;

  if i_emp_name is not null then
    v_where := v_where || ' and t.EMP_NAME = b.EMP_NAME  ';
    end if;

  open o_out for v_base_query || v_where
  using i_c_num,i_c_name,i_emp_name;
end;
/
