/* 
Intermediate to Advance Tools in SQL
*/


/* 
Using Group by, Order by
*/


Select *
From dbo.EmployeeDemographics;

Select Gender, COUNT(Gender) as CountGender
From dbo.EmployeeDemographics
Where Age > 30
Group by Gender
Order by 2 DESC

/* 
Sort with Order by
*/

Select *
From dbo.EmployeeDemographics
Order by 4, 5 DESC

/* 
Using Joins, a way to combine multiple tables into a single output
*/

Select EmployeeDemographics.EmployeeID, FirstName, LastName, JobTitle, Salary
From dbo.EmployeeDemographics
Join dbo.EmployeeSalary
	On EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
Where FirstName <> 'Michael'
Order by Salary DESC

/* 
Inner Join is going to show everything that is common or overlapping between table A and table B
Full Outer Join is going to show everything from Table A and table B regardless is they have match
Left Outer Join is going to show everything that matchs on the the left or first table 
Right Outer Join is going to show everything that matchs on the the right or second table 
Remember that in the select statement for the columns that are present in the two tables,
we have to specify from what table as "table.column"
*/


/* Union, Union All are closed related to Joins because in both instances they are combining two tables to create one output
The difference is the Join combine the tables based off a common column,
With an Union you are able to select all the data from both tables and put it into one output where all the data is in each column
and you don't have to choose which table you're choosing it from. 
*/


Select EmployeeID, FirstName, Age
From dbo.EmployeeDemographics
UNION
Select EmployeeID, JobTitle, Salary
From dbo.EmployeeSalary

/* We use union when we have the same data types, or at least similar, if you look closely at the table you see the employeeID
repeated to show the other two columns combining information from both table.
*/

/* CASE Statement allows you to specify a condition, and what is going to return when that condition is met.
The big difference using CASE is that we can make as many "When&Then" statement as we want.
Something to note is that the very first condition that is met, is going to be returned, if there are multiple conditions that
meet the criteria only the very first one is going to be returned.
*/

Select FirstName,LastName, Age,
CASE 
	When Age > 30 THEN 'Old'
	ELSE 'Young'
END 
From dbo.EmployeeDemographics
Where Age is not null
Order by Age ASC


Select FirstName,LastName, Age,
CASE 
	WHEN Age > 30 THEN 'Old'
	WHEN Age BETWEEN 27 AND 30 THEN 'Young'
	ELSE 'Baby'
END 
From dbo.EmployeeDemographics
Where Age is not null
Order by Age ASC


/*
Let's create a calculated column with CASE assuming we are going to rase the salary for next year
You use CASE statement when you want to categorize, label things or do additional calculations
*/


Select FirstName, LastName, JobTitle, Salary,
CASE 
	WHEN JobTitle = 'Salesman' THEN Salary + (Salary * .10)
	WHEN JobTitle = 'Accountant' THEN Salary + (Salary * .05)
	WHEN JobTitle = 'HR' THEN Salary + (Salary * .01)
	ELSE Salary + (Salary * .03)
END AS SalaryAfterRaise
From EmployeeDemographics
Join EmployeeSalary
	On EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID


/* 
Using HAVING, we cannot use aggregate functions in the WHERE Statement, we need to use HAVING.
HAVING Statement needs to go after the aggregate function.
*/

Select JobTitle, COUNT(JobTitle)
From EmployeeDemographics
Join EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
GROUP BY JobTitle
HAVING COUNT(JobTitle) > 1


Select JobTitle, AVG(Salary)
From EmployeeDemographics
Join EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
GROUP BY JobTitle
HAVING AVG(Salary) > 45000
ORDER BY AVG(Salary)


/* 
Update and Delete data into a table. The differences between the statements:
INSERT INTO: is going to create a new row in your table 
UPDATE: is going to alter a pre-existing row.
DELETE: is going to specify what rows you want removed
*/

Select *
From EmployeeDemographics

UPDATE EmployeeDemographics
SET Age = 26
WHERE FirstName = 'Jim' AND LastName = 'Halpert'

UPDATE EmployeeDemographics
SET Age = 27, Gender = 'Female'
WHERE FirstName = 'Jim' AND LastName = 'Halpert'

DELETE FROM EmployeeDemographics
WHERE EmployeeID = 1001

INSERT INTO EmployeeDemographics VALUES('1001', 'Jim', 'Halpert', '25', 'Male')

INSERT INTO EmployeeDemographics VALUES
('1010', 'Elan', 'Maurette', '31', 'Male'),
('1011', 'Aaron', 'Judge', '31', 'Male')


/* 
Using Alias, is temporarily changing the column name or the table name in your script. Is really useful to improve the 
readability of your script so that if you hand your work to somebody so they can easily undertand it.
*/

Select FirstName + ' ' + LastName AS FullName
From EmployeeDemographics

Select AVG(Age) AS AvgAge
From EmployeeDemographics

/* 
Aliasing Table Names
When you are aliasing table names, yu actually need in the select statement
to preface your column name with the table name that you established.
This important specially when you are working with Joins or working with a lot of columns.
Not only is faster to type, also improves readability. 
*/


Select demo.EmployeeID, demo.Age, salary.JobTitle
From EmployeeDemographics AS demo
Join EmployeeSalary AS salary
	On demo.EmployeeID = salary.EmployeeID


/* 
Partition by is often compared with the Group by Statement, but they are different.
Group by: is going to reduce the number of rows in our output by actually rolling them up and then calculating sums or avg for each group
Partition by: is going to divide results set into partition and changes how the window function is calculated, so the partition
does not actually reduce the number of rows returned in our output. 
*/


Select FirstName, LastName, Gender, Salary,
COUNT(Gender) OVER (PARTITION BY Gender) as TotalGender
From EmployeeDemographics AS demo
Join EmployeeSalary AS salary
	On demo.EmployeeID = salary.EmployeeID

/* 
Let's look at the output, if you look closely you realize that partition by aggregate the total of females working in a separate column
If we used a group by statement, all we would be able to do is see the aggregate of gender but because we used partition by
we are able to isolate just one column where we performe our opetarion and we are able to see the rest of the data at the same time
*/


Select FirstName, LastName, Gender, Salary, COUNT(Gender)
From EmployeeDemographics AS demo
Join EmployeeSalary AS salary
	On demo.EmployeeID = salary.EmployeeID
GROUP BY FirstName, LastName, Gender, Salary

Select Gender, COUNT(Gender)
From EmployeeDemographics AS demo
Join EmployeeSalary AS salary
	On demo.EmployeeID = salary.EmployeeID
GROUP BY Gender


/* 
CTE = Common Table Expression, it's a named temporary result set which is used to manipulate the complex subqueries data.
This only exist within the scope of the the statement that we are about to write once we cancel out this query it's like it never happened.
CTE is only created in memory rather than a tempdb file like a temp table. 
CTE works very much like a subquery, so if you know how to do subqueries, you should be able to pick up on CTE very easily.
*/

WITH CTE_Employee as 
(Select FirstName, LastName, Gender, Salary,
COUNT(Gender) OVER (PARTITION BY Gender) as TotalGender,
AVG(Salary) OVER (PARTITION BY Gender) as AvgSalary
From EmployeeDemographics AS demo
Join EmployeeSalary AS salary
	On demo.EmployeeID = salary.EmployeeID
Where Salary > '45000'
)
Select FirstName, AvgSalary
From CTE_Employee

/* 
As you can see is basically just a select statement within the "WITH CTE_Employee AS"
What this is going to do is take the columns selected, and it's going to place it where we can query off of this data.
So it's putting them in a temporary place where we can go and grab that data. 
If we want to run it we have to select everything and run it. 
*/


/* Temp Tables
Temp Tables are temporary tables. You can hit off of this temp table multiple times wich you cannot do with something like a CTE or a subquery
They are extremily useful. 
*/


CREATE TABLE #temp_Employee (
EmployeeId int,
JobTitle varchar(100),
Salary int
)

Select * 
From #temp_Employee

INSERT INTO #temp_Employee VALUES (
'1010', 'Salesman', '40000'),
('1011', 'Salesman', '45000')

INSERT INTO #temp_Employee
SELECT *
FROM EmployeeSalary

/*
As you can see literally the only difference between a regular table and a temp table is the pound sign at the beginning.
If you don't want to add new data manually, you can  use the "SELECT" and "FROM" statements to populate your table.
This is very useful when we have a big table with millions of rows, we can save time.
*/

CREATE TABLE #Temp_Employee2 (
JobTitle varchar(100),
EmployeesPerJob int, 
AvgAge int,
AvgSalary int
)

INSERT INTO #Temp_Employee2
Select JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
From EmployeeDemographics AS demo
Join EmployeeSalary AS salary
	On demo.EmployeeID = salary.EmployeeID
GROUP BY JobTitle

Select *
From #Temp_Employee2

/*
What the last query is going to do is that whenever we want to run this query we don't have to create the last two tables and the joins which take time
What is going to do is take this exact values, place it on a temporary table and if we want to run further calculations on these values,
we can easily do it in a fraction of the time instead of having to run this every single time which will take up so much processing power.
A lot of times this temp tables are used on stored procedures.
One last tip, when you run the query for a second time you will SHOW an ERROR that's why you have to put the "DROP TABLE" statement in front
What is going to do is DELETE the table stored and CREATE IT AGAIN
*/

DROP TABLE IF EXISTS #Temp_Employee2 
CREATE TABLE #Temp_Employee2 (
JobTitle varchar(100),
EmployeesPerJob int, 
AvgAge int,
AvgSalary int
)

INSERT INTO #Temp_Employee2
Select JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
From EmployeeDemographics AS demo
Join EmployeeSalary AS salary
	On demo.EmployeeID = salary.EmployeeID
GROUP BY JobTitle

Select *
From #Temp_Employee2


/*
Clean data with String Functions - TRIM, LTRIM, RTRIM, Replace, Substring, Upper, Lower 
*/

--Drop Table EmployeeErrors;


CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')

Select *
From EmployeeErrors

-- Using Trim, LTRIM, RTRIM 
-- TRIM: Eliminate blank spaces BOTH LEFT AND RIGHT SIDE
-- LTRIM: Eliminate blank spaces ON THE LEFT SIDE
-- RTRIM: Eliminate blank spaces ON THE RIGHT SIDE

Select EmployeeID, TRIM(EmployeeID)
From EmployeeErrors

Select EmployeeID, LTRIM(EmployeeID)
From EmployeeErrors

Select EmployeeID, RTRIM(EmployeeID)
From EmployeeErrors


-- Using Replace to eliminate a word or character that you don't want

Select LastName, REPLACE(LastName, '- Fired', '') as LastNameFixed
From EmployeeErrors


-- Using Substring
-- You can use substring to reduce or clean a column
Select SUBSTRING(FirstName,1,3)
From EmployeeErrors

-- You can use SUBSTRING to do some Fuzzy Matching BETWEEN COLUMNS LIKE Gender, LastName, Age, DOB

Select Substring(err.FirstName,1,3), Substring(dem.FirstName,1,3), Substring(err.LastName,1,3), Substring(dem.LastName,1,3)
FROM EmployeeErrors err
JOIN EmployeeDemographics dem
	on Substring(err.FirstName,1,3) = Substring(dem.FirstName,1,3)
	and Substring(err.LastName,1,3) = Substring(dem.LastName,1,3)


-- Using lower and UPPER 
Select firstname, LOWER(firstname)
from EmployeeErrors

Select Firstname, UPPER(FirstName)
from EmployeeErrors


/*
Stored Procedures: is a group of SQL statements that has been created and store in that database.
It can accept input parameters, that means that a single stored procedure can be used over the the network by several different users
It would reduce network traffic and increase performance. If we modified everyone that is using it will get that update.
*/

CREATE PROCEDURE TEST
AS
Select *
From EmployeeDemographics

EXEC TEST

/*
Let's do another example about Stored Procedures and go a little bit further using "ALTER PROCEDURE" Statement
We are going to add a Parameter, that's going to allow us to specify an input when we execute the procedure so we get an specific result back.
We include the Paramenter by going to the Stored Procedure, right click/Modify
When we go back to our query we have to EXECUTE THE PROCEDURE by stablishing the parameter
*/

CREATE PROCEDURE Temp_Employee 
AS
CREATE TABLE #temp_employee3 (
JobTitle varchar(100),
EmployeesPerJob int, 
AvgAge int,
AvgSalary int
)

INSERT INTO #temp_employee3
Select JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
From EmployeeDemographics AS demo
Join EmployeeSalary AS salary
	On demo.EmployeeID = salary.EmployeeID
GROUP BY JobTitle

Select *
From #temp_employee3

EXEC Temp_Employee @JobTitle = 'Salesman'


/*
Subqueries (in the Select, From, and Where Statement)
*/

Select *
From EmployeeSalary

-- Subquery in Select

Select EmployeeID, Salary, 
(
Select AVG(Salary) From EmployeeSalary) as AllAvgSalary
From EmployeeSalary

-- How to do the same thing using Partition By
Select EmployeeID, Salary, AVG(Salary) OVER () AS AllAvgSalary
From EmployeeSalary

-- Why Group By doesn't work
Select EmployeeID, Salary, AVG(Salary) as AllAvgSalary
From EmployeeSalary
Group By EmployeeID, Salary
order by EmployeeID

-- Subquery in From -- This is for the sake of the example but is more efficient to use a temp table or a CTE

Select a.EmployeeID, AllAvgSalary
From 
	(Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
	 From EmployeeSalary) a
Order by a.EmployeeID


-- Subquery in Where


Select EmployeeID, JobTitle, Salary
From EmployeeSalary
where EmployeeID in (
	Select EmployeeID 
	From EmployeeDemographics
	where Age > 30)