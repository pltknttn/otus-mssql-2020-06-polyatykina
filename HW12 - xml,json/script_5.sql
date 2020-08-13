/*
5. ѕишем динамический PIVOT.
ѕо заданию из зан¤ти¤ Уќператоры CROSS APPLY, PIVOT, CUBEФ.
“ребуетс¤ написать запрос, который в результате своего выполнени¤ формирует таблицу следующего вида:
Ќазвание клиента
ћес¤ц√од  оличество покупок
*/

USE [WideWorldImporters]
GO

drop table if exists #result 
create table #result (InvoiceMonth date)

drop table if exists #report
select isnull(p2.CustomerName, p1.CustomerName) CustomerName,  
       DATEADD(MONTH,DATEDIFF(MONTH,0,i.InvoiceDate),0) InvoiceMonth,
	   count(i.InvoiceID) CountInvoices
 into #report
 from [Sales].[Customers] c
   join [Sales].[Invoices] i on i.CustomerID = c.CustomerID
   cross apply (select SUBSTRING(c.CustomerName, CHARINDEX('(', c.CustomerName,0) + 1, LEN(c.CustomerName)) CustomerName) p1
   outer apply (select LEFT(p1.CustomerName, CHARINDEX(')', p1.CustomerName,0) - 1) CustomerName WHERE CHARINDEX(')', p1.CustomerName,0) >= 1) p2        
group by DATEADD(MONTH,DATEDIFF(MONTH,0,i.InvoiceDate),0), isnull(p2.CustomerName, p1.CustomerName)
 

declare @CustomerName NVARCHAR(max),  @CustomerField NVARCHAR(max), 
        @Command NVARCHAR(max)  = '
insert into #result
SELECT InvoiceMonth,  @CustomerName 
FROM  ( select CustomerName, InvoiceMonth, CountInvoices from #report
) p PIVOT ( max(CountInvoices) FOR CustomerName IN  ( @CustomerName )) AS pvt  
ORDER BY pvt.InvoiceMonth;', 
        @CommandAlterTable NVARCHAR(max)  = 'ALTER TABLE #result ADD @CustomerField;'

set @CustomerField = stuff((select distinct ', ['+CustomerName+'] int' as 'data()'  from #report for xml path('')), 1, 1, '');
set @CommandAlterTable = REPLACE(@CommandAlterTable, '@CustomerField', @CustomerField )

--select @CustomerField, @CommandAlterTable 

EXEC sp_executesql @CommandAlterTable  

set @CustomerName = stuff((select distinct ', ['+CustomerName+']' as 'data()'  from #report for xml path('')), 1, 1, '');
set @Command = REPLACE(@Command, '@CustomerName', @CustomerName )

--select @CustomerName, @Command 
 
EXEC sp_executesql @Command  

select * from #result