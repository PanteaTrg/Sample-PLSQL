
--sample - 4
CREATE OR REPLACE FUNCTION get_num_of_employees (p_loc VARCHAR2, p_job VARCHAR2) 
RETURN NUMBER
IS
  v_query_str VARCHAR2(1000);
  v_num_of_employees NUMBER;
BEGIN
  v_query_str := 'begin SELECT COUNT(*) INTO :into_bind FROM emp_' 
                 || p_loc
                 || ' WHERE job = :bind_job; end;';
  EXECUTE IMMEDIATE v_query_str
    USING out v_num_of_employees, p_job;
  RETURN v_num_of_employees;
END;
/
