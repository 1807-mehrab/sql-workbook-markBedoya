conn chinook/p4ssw0rd;

/*
# SQL Lab
Follow the directions and tasks below. Upload your answers in .sql script files to this repository.
---
*/

/*
## 1. Setting up Oracle Chinook
In this section you will begin the process of working with the Oracle Chinook database
Task - Open the Chinook_Oracle.sql file and execute the scripts within.
*/

/*
## 2. SQL Queries
In this section you will be performing various queries against the Oracle Chinook database.
/*

/*
### 2.1 SELECT
Task - Select all records from the Employee table.
Task - Select all records from the Employee table where last name is King.
Task - Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
*/
--1
SELECT * FROM Employee;
--2
SELECT * FROM Employee WHERE LASTNAME = 'King';
--3
SELECT * FROM Employee WHERE FIRSTNAME = 'Andrew' AND REPORTSTO IS NULL;

/*
### 2.2 ORDER BY
Task - Select all albums in Album table and sort result set in descending order by title.
Task - Select first name from Customer and sort result set in ascending order by city
*/
--1
SELECT * FROM Album ORDER BY TITLE DESC;
--2
--SELECT * FROM Customer;
--SELECT FIRSTNAME, CITY FROM Customer ORDER BY CITY ASC;
SELECT FIRSTNAME FROM Customer ORDER BY CITY ASC;

/*
### 2.3 INSERT INTO
Task - Insert two new records into Genre table
Task - Insert two new records into Employee table
Task - Insert two new records into Customer table
*/
--1
INSERT INTO GENRE (GENREID, NAME) VALUES (26, 'Funk');
INSERT INTO GENRE (GENREID, NAME) VALUES (27, 'Breakdance');
--SELECT * FROM GENRE;
--2
INSERT INTO Employee (EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE) VALUES (9, 'Bedoya', 'Mark', 'New Guy');
INSERT INTO Employee (EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE) VALUES (10, 'Butterfield', 'Kyle', 'New Guy');
--SELECT * FROM Employee;
--3
INSERT INTO Customer (CUSTOMERID, LASTNAME, FIRSTNAME, EMAIL) VALUES (60, 'Bedoya', 'Mark', 'mark.bedoya@gmail.com');
INSERT INTO Customer (CUSTOMERID, LASTNAME, FIRSTNAME, EMAIL) VALUES (61, 'Butterfield', 'kyle', 'kyle.butterfield@gmail.com');
--SELECT * FROM Customer;

/*
### 2.4 UPDATE
Task - Update Aaron Mitchell in Customer table to Robert Walter
Task - Update name of artist in the Artist table "Creedence Clearwater Revival" to "CCR"
*/

--1
--SELECT * FROM Customer ORDER BY FIRSTNAME ASC;
UPDATE Customer SET FIRSTNAME = 'Robert', LASTNAME = 'Walter' WHERE FIRSTNAME = 'Aaron' AND LASTNAME = 'Mitchell';
--SELECT * FROM Customer ORDER BY FIRSTNAME ASC;
--2
UPDATE Artist SET NAME = 'CCR' WHERE NAME = 'Creedence Clearwater Revival';
--SELECT * FROM Artist;

/*
### 2.5 LIKE
Task - Select all invoices with a billing address like “T%”
*/

SELECT * FROM INVOICE WHERE BILLINGADDRESS LIKE 'T%';

/*
### 2.6 BETWEEN
Task - Select all invoices that have a total between 15 and 50
Task - Select all employees hired between 1st of June 2003 and 1st of March 2004
*/

--1
SELECT * FROM INVOICE WHERE TOTAL BETWEEN 15 AND 50;
--SELECT TOTAL FROM INVOICE;
--2
SELECT * FROM EMPLOYEE WHERE HIREDATE BETWEEN TO_DATE('01-06-03','DD-MM-YY') AND TO_DATE('01-03-04','DD-MM-YY');
--SELECT * FROM EMPLOYEE;

/*
### 2.7 DELETE
Task - Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
*/

--SELECT * FROM CUSTOMER ORDER BY FIRSTNAME;

ALTER TABLE Invoice
   DROP CONSTRAINT FK_InvoiceCustomerId;
   
ALTER TABLE Invoice
   ADD CONSTRAINT FK_InvoiceCustomerId
   FOREIGN KEY (CustomerId) REFERENCES Customer (CustomerId) ON DELETE CASCADE;
   
ALTER TABLE InvoiceLine
   DROP CONSTRAINT FK_InvoiceLineInvoiceId;  
   
ALTER TABLE InvoiceLine
   ADD CONSTRAINT FK_InvoiceLineInvoiceId
   FOREIGN KEY (InvoiceId) REFERENCES Invoice (InvoiceId) ON DELETE CASCADE;

DELETE FROM Customer WHERE FIRSTNAME = 'Robert' AND LASTNAME = 'Walter'; 
   
/*
## 3. SQL Functions
In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database
*/

/*
### 3.1 System Defined Functions
Task - Create a function that returns the current time.
Task - create a function that returns the length of a mediatype from the mediatype table
*/
--create function
create or replace function getSysTime
return timestamp as 
    time timestamp;
begin
    time := localtimestamp;
    RETURN time;
end;
/
-- run it
SELECT getSysTime() FROM DUAL;

-- run it
DECLARE
    time timestamp;
BEGIN
    time:= getSysTime;
    DBMS_OUTPUT.PUT_LINE('TIME = ' || time);
END;
/

create or replace function getlengthmediatype (MEDIATYPE_ID IN NUMBER)
return number as
  mediatype_length number;
begin
    SELECT length(NAME) 
    INTO mediatype_length
    FROM MEDIATYPE
    WHERE mediatypeid = MEDIATYPE_ID;
    --mediatype_length := SELECT length(NAME) FROM MEDIATYPE WHERE mediatypeid = MEDIATYPE_ID;
    RETURN mediatype_length;
end;
/
--run it (returns table that i don't want. idk why yet
--SELECT getlengthmediatype(1) FROM MEDIATYPE;

-- run it
DECLARE
    mediatype_length number;
BEGIN
    mediatype_length := getlengthmediatype(1);
    DBMS_OUTPUT.PUT_LINE('mediatype_length = ' || mediatype_length);
END;
/

--SELECT length(NAME) FROM MEDIATYPE;
--SELECT * FROM MEDIATYPE;

/*
### 3.2 System Defined Aggregate Functions
Task - Create a function that returns the average total of all invoices
Task - Create a function that returns the most expensive track
*/

--SELECT * FROM INVOICE;
-- 1
create or replace function getinvoiceavgtotal 
return number as
  total_avg number;
begin
    SELECT avg(total) 
    INTO total_avg
    FROM invoice;
    RETURN total_avg;
end;
/
--SELECT getinvoiceavgtotal FROM INVOICE;

DECLARE
    total_avg number;
BEGIN
    total_avg := getinvoiceavgtotal;
    DBMS_OUTPUT.PUT_LINE('Invoice Totals Average is: ' || total_avg);
    
END;
/

--2
CREATE VIEW get_most_expensive_track (NAME, UNITPRICE) AS
SELECT name, unitprice 
    FROM track
    where unitprice = (select max(unitprice) from track);

--to run    
select * from get_most_expensive_track;

/*
### 3.3 User Defined Scalar Functions
Task - Create a function that returns the average price of invoiceline items in the invoiceline table
*/

create or replace function getinvoicelineavgunitprice 
return number as
  total_avg number;
begin
    SELECT avg(unitprice) 
    INTO total_avg
    FROM invoiceline;
    RETURN total_avg;
end;
/

select getinvoicelineavgunitprice from dual;

DECLARE
    total_avg number;
BEGIN
    total_avg := getinvoicelineavgunitprice;
    DBMS_OUTPUT.PUT_LINE('Invoiceline unit price average is: ' || total_avg);
    
END;
/

/*
### 3.4 User Defined Table Valued Functions
Task - Create a function that returns all employees who are born after 1968.
*/

CREATE VIEW employees_born_after_1968 AS
select * from employee where birthdate >= '01-JAN-68';

--to run    
select * from employees_born_after_1968;

/*
## 4. Stored Procedures
In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
*/

/*
### 4.1 Basic Stored Procedure
Task - Create a stored procedure that selects the first and last names of all the employees.
*/

CREATE VIEW Get_Employee_Names AS
Select FirstName, LastName From Employee;

--to run    
select * from Get_Employee_Names;

/*
### 4.2 Stored Procedure Input Parameters
Task - Create a stored procedure that updates the personal information of an employee.
Task - Create a stored procedure that returns the managers of an employee.
*/

-- 1
CREATE OR REPLACE PROCEDURE update_employee_personalnfo
(E_ID IN NUMBER, FN IN VARCHAR2, LN IN VARCHAR2) AS
BEGIN
    --SAVEPOINT;
    
    -- all personal info for an employee that you want to change i would just add more into the "set" fields 
    UPDATE Employee SET FirstName = FN, LastName = LN
        WHERE EmployeeId = E_ID;
       
    --ROLLBACK    
    COMMIT;
END;
/
--Test

BEGIN
    update_employee_personalnfo(9, 'Mark', 'Bedoya');
END;
/

-- 2 I would just create a view of this select statement. 
SELECT a.employeeid AS "Emp_ID", a.firstname AS "Employee Name",
b.employeeid AS "Supervisor ID", b.firstname AS "Supervisor Name"
FROM employee a, employee b 
WHERE a.reportsto = b.employeeid;

/*
### 4.3 Stored Procedure Output Parameters
Task - Create a stored procedure that returns the name and company of a customer.
*/

select firstname, lastname, company from customer;

/*
## 5. Transactions
In this section you will be working with transactions. Transactions are usually nested within a stored procedure.
Task - Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
Task - Create a transaction nested within a stored procedure that inserts a new record in the Customer table
*/

-- 1
CREATE OR REPLACE PROCEDURE delete_invoice
(I_ID IN NUMBER) AS
BEGIN
    --SAVEPOINT;
   
    execute immediate 'ALTER TABLE InvoiceLine DROP CONSTRAINT FK_InvoiceLineInvoiceId';
   
    execute immediate 'ALTER TABLE InvoiceLine ADD CONSTRAINT FK_InvoiceLineInvoiceId FOREIGN KEY (InvoiceId) REFERENCES Invoice (InvoiceId) ON DELETE CASCADE'; 

    DELETE invoice WHERE INVOICEID = I_ID;
       
    --ROLLBACK    
    COMMIT;
END;
/

--Test
BEGIN
    delete_invoice(213);
END;
/

-- 2
CREATE OR REPLACE PROCEDURE create_new_customer
(FN IN VARCHAR2, LN IN VARCHAR2, ...) AS
BEGIN
    --SAVEPOINT;
    --i would continue puttin in the parameters to create a new customer but this is how to do it and it will work.
    INSERT INTO Customer (CustomerId, FirstName, LastName, ...) VALUES (1, 'FN', 'LN', ...);
       
    --ROLLBACK    
    COMMIT;
END;
/
--Test

BEGIN
    -- continue inouting the parameters 'wanted' to create a new customer.
    create_new_customer(9, 'Mark', 'Bedoya' ...);
END;
/

/*
## 6. Triggers
In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
*/

/*
### 6.1 AFTER/FOR
Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
Task - Create an after update trigger on the album table that fires after a row is inserted in the table
Task - Create an after delete trigger on the customer table that fires after a row is deleted from the table.
*/

-- 1
CREATE OR REPLACE TRIGGER TR_Employee_PK
After INSERT ON Employee
FOR EACH ROW
BEGIN
    -- do something here that does what you want the trigger to do.
    SELECT SQ_Employee_PK.NEXTVAL INTO :NEW.EmployeeId FROM DUAL;
END;
/

-- 2
CREATE OR REPLACE TRIGGER TR_Album_PK
After update ON Album
FOR EACH ROW
BEGIN
    -- do something here that does what you want the trigger to do.
    SELECT TR_Album_PK.NEXTVAL INTO :NEW.AlbumId FROM DUAL;
END;
/

-- 3 
CREATE OR REPLACE TRIGGER TR_Customer_PK
BEFORE INSERT ON Customer
FOR EACH ROW
BEGIN
    -- do something here that does what you want the trigger to do.
    SELECT TR_Customer_PK.NEXTVAL INTO :NEW.CustomerId FROM DUAL;
END;
/

/*
## 7. JOIN
In this section you will be working with combining various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
*/

/*
### 7.1 INNER
Task - Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
*/

Select firstname, lastname, invoiceid from customer inner join invoice on invoice.customerid = customer.customerid;

/*
### 7.2 OUTER
Task - Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
*/

select customer.customerid, firstname, lastname, invoiceid, total from customer left outer join invoice on customer.customerid = invoice.customerid;

/*
### 7.3 RIGHT
Task - Create a right join that joins album and artist specifying artist name and title.
*/

select name, title from album right outer join artist on album.artistid = artist.artistid;

/*
### 7.4 CROSS
Task - Create a cross join that joins album and artist and sorts by artist name in ascending order.
*/

select name from artist cross join album order by artist.name asc;

/*
### 7.5 SELF
Task - Perform a self-join on the employee table, joining on the reportsto column.
*/

SELECT a.employeeid AS "Emp_ID", a.firstname AS "Employee Name",
b.employeeid AS "Supervisor ID", b.firstname AS "Supervisor Name"
FROM employee a, employee b 
WHERE a.reportsto = b.employeeid;

/*
## 8. Administration
In this section you will be creating backup files of your database. After you create the backup file you will also restore the database.
Task - Create a .bak file for the Chinook database.
*/

exit;