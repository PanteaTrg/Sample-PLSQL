DECLARE

  pxRequest   xmltype := xmltype('<per:Person xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                                    xsi:schemaLocation="http://www.something.com/2014/11/bla/webservice.xsd"
                                    xmlns:per="http://www.something.com/2014/11/bla/person">
                                    <per:Initials>E.C.</per:Initials>
                                    <per:FirstName>Erik</per:FirstName>
                                    <per:LastName>Flipsen</per:LastName>
                                    <per:BirthDate>1980-01-01</per:BirthDate>
                                    <per:Gender>Male</per:Gender>
                                </per:Person>');
  lsInitials  varchar2(100);
  lsFirstname varchar2(100);

begin

  select pers.Initials, 
         pers.Firstname
    into lsInitials, lsFirstname
    from XMLTABLE('*:Person' passing pxRequest columns Initials PATH
                  '*:Initials',
                  Firstname PATH '*:FirstName') pers;

  dbms_output.put_line(lsInitials);
  dbms_output.put_line(lsFirstname);

end;
