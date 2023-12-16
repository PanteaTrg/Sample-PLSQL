
-- Sample - 3

CREATE OR REPLACE PROCEDURE SP_EMPLOYEE_SEARCH_TEST(IN_EMP_NO           IN VARCHAR2,
                                                    IN_EMP_NAME         IN VARCHAR2,
                                                    OUT_C_SEARCH_RESULT OUT sys_refcursor) IS

  SQL_QUERY VARCHAR2(500);
  cur       INTEGER;
  ret       NUMBER;
  bind      BOOLEAN := FALSE;

BEGIN

  IF (IN_EMP_NO IS NOT NULL) THEN
    SQL_QUERY := SQL_QUERY || 'AND EMPLOYEE_NO = :p1 '; -- note the space at the end!
    bind      := TRUE;
  END IF;

  IF (IN_EMP_NAME IS NOT NULL) THEN
    SQL_QUERY := SQL_QUERY || 'AND EMPLOYEE_NAME = :p2 ';
    bind      := TRUE;
  END IF;

  IF bind then
    SQL_QUERY := 'SELECT * FROM EMPLOYEE ' ||
                 REGEXP_REPLACE(SQL_QUERY, '^AND', 'WHERE');
  ELSE
    SQL_QUERY := 'SELECT * FROM EMPLOYEE';
  END IF :dbms_output.put_line(SQL_QUERY);

  cur := dbms_sql.open_cursor;
  DBMS_SQL.PARSE(cur, SQL_QUERY, DBMS_SQL.NATIVE);

  IF (IN_EMP_NO IS NOT NULL) THEN
    DBMS_SQL.BIND_VARIABLE(cur, ':p1', IN_EMP_NO);
  END IF;
  IF (IN_EMP_NAME IS NOT NULL) THEN
    DBMS_SQL.BIND_VARIABLE(cur, ':p2', IN_EMP_NAME);
  END IF;

  ret                 := DBMS_SQL.EXECUTE(cur);
  OUT_C_SEARCH_RESULT := DBMS_SQL.TO_REFCURSOR(cur);

END SP_EMPLOYEE_SEARCH_TEST;
