 /*
 
 4. Написать рекурсивный CTE sql запрос и заполнить им временную таблицу и табличную переменную

Дано :
CREATE TABLE dbo.MyEmployees
(
EmployeeID smallint NOT NULL,
FirstName nvarchar(30) NOT NULL,
LastName nvarchar(40) NOT NULL,
Title nvarchar(50) NOT NULL,
DeptID smallint NOT NULL,
ManagerID int NULL,
CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC)
);

INSERT INTO dbo.MyEmployees VALUES
(1, N'Ken', N'Sánchez', N'Chief Executive Officer',16,NULL)
,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1)
,(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273)
,(275, N'Michael', N'Blythe', N'Sales Representative',3,274)
,(276, N'Linda', N'Mitchell', N'Sales Representative',3,274)
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273)
,(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285)
,(16, N'David',N'Bradley', N'Marketing Manager', 4, 273)
,(23, N'Mary', N'Gibson', N'Marketing Specialist', 4, 16);

Результат вывода рекурсивного CTE:
EmployeeID Name Title EmployeeLevel
1 Ken Sánchez Chief Executive Officer 1
273 | Brian Welcker Vice President of Sales 2
16 | | David Bradley Marketing Manager 3
23 | | | Mary Gibson Marketing Specialist 4
274 | | Stephen Jiang North American Sales Manager 3
276 | | | Linda Mitchell Sales Representative 4
275 | | | Michael Blythe Sales Representative 4
285 | | Syed Abbas Pacific Sales Manager 3
286 | | | Lynn Tsoflias Sales Representative 4

 
 */

 DROP TABLE IF EXISTS dbo.MyEmployees

 CREATE TABLE dbo.MyEmployees
(
EmployeeID smallint NOT NULL,
FirstName nvarchar(30) NOT NULL,
LastName nvarchar(40) NOT NULL,
Title nvarchar(50) NOT NULL,
DeptID smallint NOT NULL,
ManagerID int NULL,
CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC)
);

INSERT INTO dbo.MyEmployees VALUES
(1, N'Ken', N'Sánchez', N'Chief Executive Officer',16,NULL)
,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1)
,(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273)
,(275, N'Michael', N'Blythe', N'Sales Representative',3,274)
,(276, N'Linda', N'Mitchell', N'Sales Representative',3,274)
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273)
,(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285)
,(16, N'David',N'Bradley', N'Marketing Manager', 4, 273)
,(23, N'Mary', N'Gibson', N'Marketing Specialist', 4, 16);


/*Рекурсивный CTE для решения задачи*/

;WITH EmployeesRowNumber AS
(
  SELECT 
    EmployeeID, concat(FirstName, ' ', LastName) [Name], Title, ManagerID, DeptID,
    ROW_NUMBER() OVER(PARTITION BY ManagerID ORDER BY concat(FirstName, ' ', LastName), EmployeeID) AS RowNum
  FROM dbo.MyEmployees
),
EmployeesLevel as (
     select EmployeeID, [Name], Title, convert(int, 0) EmployeeLevel,
	        CAST(0x AS VARBINARY(MAX)) AS SortNum
	   from EmployeesRowNumber 
	 where ManagerID IS NULL

	 UNION ALL

	 SELECT ch.EmployeeID, ch.[Name], ch.Title, p.EmployeeLevel + 1 EmployeeLevel,
	        P.SortNum + CAST(ch.RowNum AS BINARY(2)) SortNum
	   FROM EmployeesLevel p
	      join EmployeesRowNumber ch on ch.ManagerID = p.EmployeeID 
) 
select EmployeeID, REPLICATE(' | ', EmployeeLevel) + [Name] AS [Name], Title, EmployeeLevel + 1 EmployeeLevel 
  from EmployeesLevel 
 ORDER BY SortNum;

 /* временная таблица */

 DROP TABLE IF EXISTS #EmployeesLevel 
 CREATE TABLE #EmployeesLevel  
 (
    EmployeeID int NOT NULL PRIMARY KEY (EmployeeID ASC),
	[Name]  nvarchar(255) NOT NULL,
	Title   nvarchar(50) NOT NULL,
	EmployeeLevel int 
 )

 ;WITH EmployeesRowNumber AS
(
  SELECT 
    EmployeeID, concat(FirstName, ' ', LastName) [Name], Title, ManagerID, DeptID,
    ROW_NUMBER() OVER(PARTITION BY ManagerID ORDER BY concat(FirstName, ' ', LastName), EmployeeID) AS RowNum
  FROM dbo.MyEmployees
),
EmployeesLevel as (
     select EmployeeID, [Name], Title, convert(int, 0) EmployeeLevel,
	        CAST(0x AS VARBINARY(MAX)) AS SortNum
	   from EmployeesRowNumber 
	 where ManagerID IS NULL

	 UNION ALL

	 SELECT ch.EmployeeID, ch.[Name], ch.Title, p.EmployeeLevel + 1 EmployeeLevel,
	        P.SortNum + CAST(ch.RowNum AS BINARY(2)) SortNum
	   FROM EmployeesLevel p
	      join EmployeesRowNumber ch on ch.ManagerID = p.EmployeeID 
) 
insert into #EmployeesLevel (EmployeeID, [Name], Title, EmployeeLevel)
select EmployeeID, [Name], Title, EmployeeLevel + 1 EmployeeLevel   
  from EmployeesLevel 
 ORDER BY SortNum;

select EmployeeID, 
       REPLICATE(' | ', EmployeeLevel) + [Name] AS [Name],
	   Title, 
	   EmployeeLevel
from #EmployeesLevel

/* табличная переменная */
DECLARE @EmployeesLevel TABLE 
 (
    EmployeeID int NOT NULL PRIMARY KEY (EmployeeID ASC),
	[Name]  nvarchar(255) NOT NULL,
	Title   nvarchar(50) NOT NULL,
	EmployeeLevel int 
 )

 ;WITH EmployeesRowNumber AS
(
  SELECT 
    EmployeeID, concat(FirstName, ' ', LastName) [Name], Title, ManagerID, DeptID,
    ROW_NUMBER() OVER(PARTITION BY ManagerID ORDER BY concat(FirstName, ' ', LastName), EmployeeID) AS RowNum
  FROM dbo.MyEmployees
),
EmployeesLevel as (
     select EmployeeID, [Name], Title, convert(int, 0) EmployeeLevel,
	        CAST(0x AS VARBINARY(MAX)) AS SortNum
	   from EmployeesRowNumber 
	 where ManagerID IS NULL

	 UNION ALL

	 SELECT ch.EmployeeID, ch.[Name], ch.Title, p.EmployeeLevel + 1 EmployeeLevel,
	        P.SortNum + CAST(ch.RowNum AS BINARY(2)) SortNum
	   FROM EmployeesLevel p
	      join EmployeesRowNumber ch on ch.ManagerID = p.EmployeeID 
) 
insert into @EmployeesLevel (EmployeeID, [Name], Title, EmployeeLevel)
select EmployeeID, [Name], Title, EmployeeLevel + 1 EmployeeLevel   
  from EmployeesLevel 
 ORDER BY SortNum;

select EmployeeID, 
       REPLICATE(' | ', EmployeeLevel) + [Name] AS [Name],
	   Title, 
	   EmployeeLevel
from @EmployeesLevel


 DROP TABLE IF EXISTS dbo.MyEmployees
 DROP TABLE IF EXISTS #EmployeesLevel 