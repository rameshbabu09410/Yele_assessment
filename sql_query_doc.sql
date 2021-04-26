
CREATE TABLE PERSON ( person_id int not null, Last_Name varchar2(100) not null, First_Name varchar2(100), Preferred_first_name varchar2(100), date_of_birth date, hire_date date, occupation varchar2(1), primary key (person_id) );

CREATE TABLE ADDRESS ( address_id int not null, person_id int not null, address_type varchar2(4) not null, street_line varchar2(100), city varchar2(100), state varchar2(100), zip_code varchar2(30), primary key (address_id) , foreign key (person_id) references Person(person_id) );

INSERT INTO person (person_id, last_name, first_name, Preferred_first_name, date_of_birth, hire_date, occupation) values (1234, 'Smith','Johnson','John', sysdate(), sysdate(), 'P') ;

INSERT INTO person (person_id, last_name, first_name, Preferred_first_name, date_of_birth, hire_date, occupation) values (1235, 'Rob','Michael','Mike', sysdate(), sysdate(), null) ;

INSERT INTO person (person_id, last_name, first_name, Preferred_first_name, date_of_birth, hire_date, occupation) values (1236, 'Faucher','MitchelRoss', 'Ross', TO_DATE('1988/05/03 ', 'yyyy/mm/dd '), sysdate(), null) ;

INSERT INTO person (person_id, last_name, first_name, Preferred_first_name, date_of_birth, hire_date, occupation) values (1237, 'Hirtzell','jeff', 'Jeff', TO_DATE('1988/05/03 ', 'yyyy/mm/dd '), TO_DATE('2021/03/03 ', 'yyyy/mm/dd '), null) ;

INSERT INTO address(address_id,person_id,address_type, street_line, city, state, zip_code) values ( 1, 1234,'HOME', 'East Squire dr','Rochester','NY','14623');

INSERT INTO address(address_id,person_id,address_type, street_line, city, state, zip_code) values ( 2, 1235,'BILL', 'Henrietta','Rochester','NY','14623');

INSERT INTO address(address_id,person_id,address_type, street_line, city, state, zip_code) values ( 3, 1235,'HOME', 'Henrietta Rd','Rochester','NY','14623');

INSERT INTO address(address_id,person_id,address_type, street_line, city, state, zip_code) values ( 4, 1234,'BILL', 'Broddock rd','Rochester','NY','14623');

INSERT INTO address(address_id,person_id,address_type, street_line, city, state, zip_code) values ( 5, 1236,'BILL', 'Henrietta','Rochester','NY','14623');
--Queries 
--1) Write a query to select all rows from person.  If the person row has a value in preferred_first_name, select the preferred name instead of the value in first name.  Alias the column as REPORTING_NAME.
SELECT  person_id
       ,CASE WHEN preferred_first_name is not NULL THEN preferred_first_name  ELSE first_name END AS REPORTING_NAME
       ,last_name
       ,date_of_birth
       ,hire_date
       ,occupation
FROM person;

--Output
PERSON_ID ▼	REPORTING_NAME  	LAST_NAME  	DATE_OF_BIRTH  	HIRE_DATE  	OCCUPATION 
-----------   ---------------   ---------  -------------   ----------  ----------- 
1234	        John	          Smith	      2021-04-25	    2021-04-25	P
1235	        Mike	          Rob	        2021-04-25	    2021-04-25	X
1236	        Ross	          Faucher	    1988-05-03	    2021-04-25	null
1237	        Jeff	          Hirtzell	  1988-05-03	    2020-03-03	null



--Write a query to select all rows from person that have a NULL occupation.
SELECT  *
FROM person
WHERE occupation is NULL ;

--Output
PERSON_ID ▼	LAST_NAME  	FIRST_NAME  	PREFERRED_FIRST_NAME  	DATE_OF_BIRTH  	HIRE_DATE  	OCCUPATION  
-----------   ---------   -----------  ---------------------   --------------  -----------  -------------
1236	      Faucher	    MitchelRoss	  Ross	                  1988-05-03	    2021-04-25	null
1237	      Hirtzell	  jeff	        Jeff	                  1988-05-03	    2020-03-03	null


--Write a query to select all rows from person that have a date_of_birth before August 7th, 1990
SELECT  *
FROM person
WHERE date_of_birth < '1990-08-07' ;

--output
PERSON_ID ▼	LAST_NAME  	FIRST_NAME  	PREFERRED_FIRST_NAME  	DATE_OF_BIRTH  	HIRE_DATE  	OCCUPATION  
----------  ---------   ----------    -------------------     -----------   -----------   ----------
1236	      Faucher	    MitchelRoss	  Ross	                  1988-05-03	    2021-04-25	null
1237	      Hirtzell	  jeff	        Jeff	                  1988-05-03	    2020-03-03	null


--Write a query to select all rows from person that have a hire_date in the past 100 days.
SELECT  *
FROM person
WHERE DATEDIFF(day,hire_date,sysdate()) BETWEEN 0 AND 100 ;  

--Output
PERSON_ID ▼	LAST_NAME  	FIRST_NAME  	PREFERRED_FIRST_NAME  	DATE_OF_BIRTH  	HIRE_DATE  	OCCUPATION  
---------   ---------   ----------    -----------------     ---------------   ---------   ---------
1234	      Smith	      Johnson	      John	                  2021-04-25	    2021-04-25	P
1235	      Rob	        Michael	      Mike	                  2021-04-25	    2021-04-25	X
1236	      Faucher	    MitchelRoss	  Ross	                  1988-05-03	    2021-04-25	null


--Write a query to select rows from person that also have a row in address with address_type = 'HOME'.
SELECT  *
FROM person
WHERE person_id IN ( SELECT person_id FROM address WHERE address_type = 'HOME') ;

--Output
PERSON_ID ▼	LAST_NAME  	FIRST_NAME  	PREFERRED_FIRST_NAME  	DATE_OF_BIRTH  	HIRE_DATE  	OCCUPATION  
--------- ------------  ---------     ------------------    --------------    --------- -------------
1234	      Smith	      Johnson	      John	                  2021-04-25	    2021-04-25	P
1235	      Rob	        Michael	      Mike	                  2021-04-25	    2021-04-25	X

--Write a query to select all rows from person and only those rows from address that have a matching billing address (address_type = 'BILL').  If a matching billing address does not exist, display 'NONE' in the address_type column.
SELECT  p.* 
       ,a.address_id 
       ,a.person_id
       ,nvl(a.address_type,'NONE') AS address_type
       ,a.street_line
       ,a.city
       ,a.state
       ,a.zip_code
FROM person p
LEFT JOIN address a
ON p.person_id = a.person_id AND a.address_type = 'BILL';

--Output
PERSON_ID  	LAST_NAME  	FIRST_NAME  	PREFERRED_FIRST_NAME  	DATE_OF_BIRTH  	HIRE_DATE  	OCCUPATION  	ADDRESS_ID  	PERSON_ID  	ADDRESS_TYPE  	STREET_LINE  	CITY  	    STATE  	ZIP_CODE  
----------  --------    ----------    -------------------   ---------------   ----------    -----------   ----------- ----------  -------------
1234	      Smith	      Johnson	      John	                  2021-04-25	    2021-04-25	P	            4	            1234	      BILL	          Broddock rd	  Rochester	  NY	    14623
1235	      Rob	        Michael	      Mike	                  2021-04-25	    2021-04-25	X	            2	            1235	      BILL	          Henrietta	    Rochester	  NY	    14623
1236	      Faucher	    MitchelRoss	  Ross	                  1988-05-03	    2021-04-25	null	        5	            1236	      BILL	          Henrietta	    Rochester	  NY	    14623
1237	      Hirtzell	  jeff	        Jeff	                  1988-05-03	    2020-03-03	null	        null	        null	      NONE	          null	        null	      null	  null

--Write a query to count the number of addresses per address type.

--correct Query
SELECT  address_type 
       ,COUNT(*) AS count
FROM address
GROUP BY  address_type;

--Output
ADDRESS_TYPE  	COUNT  
-----------   --------
BILL	          3
HOME	          2



--Write a query to select data in the following format:
with temp_table as (SELECT  p.last_name 
       ,CASE WHEN address_type = 'HOME' THEN concat (street_line ,', '  ,city ,', ' ,state ,' ' ,zip_code )END  AS home_address 
        ,CASE WHEN address_type = 'BILL' THEN concat (street_line ,', '  ,city ,', '  ,state ,' ' ,zip_code ) END AS billing_address
FROM person p
INNER JOIN address a
ON p.person_id = a.person_id)
select distinct a.last_name , nvl(a.home_address, b.home_address) as home_address, nvl(a.billing_address,b.billing_address) as billing_address
  from temp_table a , temp_table b
where a.last_name = b.last_name
and nvl(a.home_address, 'not_there') != nvl(b.home_address, 'not_there');

--Output

LAST_NAME  	HOME_ADDRESS  	                        BILLING_ADDRESS  
---------   ----------------------                  ---------------------
Rob	        Henderson Rd, Rochester, NY 14623	      Henrietta, Rochester, NY 14623
Smith	      East Squire dr, Rochester, NY 14623	    Broddock rd, Rochester, NY 14623


--Write a query to update the person.occupation column to ‘X’ for all rows that have a ‘BILL’ address in the address table.
update person
SET occupation='X'
WHERE person_id IN ( SELECT person_id FROM address WHERE address_type = 'BILL') ;

PERSON_ID  	LAST_NAME  	FIRST_NAME  	PREFERRED_FIRST_NAME  	DATE_OF_BIRTH  	HIRE_DATE  	OCCUPATION  	ADDRESS_TYPE  
----------  ---------   ----------    -------------------   ---------------   ----------    ---------   -------------
1235	      Rob	        Michael	      Mike	                  2021-04-25	    2021-04-25	X	            BILL
1234	      Smith	      Johnson	      John	                  2021-04-25	    2021-04-25	X	            BILL
1236	      Faucher	    MitchelRoss	  Ross	                  1988-05-03	    2021-04-25	X	            BILL



