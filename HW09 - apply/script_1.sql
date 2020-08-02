/*

1. Требуется написать запрос, который в результате своего выполнения формирует таблицу следующего вида:
Название клиента
МесяцГод Количество покупок

Клиентов взять с ID 2-6, это все подразделение Tailspin Toys
имя клиента нужно поменять так чтобы осталось только уточнение
например исходное Tailspin Toys (Gasport, NY) - вы выводите в имени только Gasport,NY
дата должна иметь формат dd.mm.yyyy например 25.12.2019

Например, как должны выглядеть результаты:
InvoiceMonth Peeples Valley, AZ Medicine Lodge, KS Gasport, NY Sylvanite, MT Jessie, ND
01.01.2013 3 1 4 2 2
01.02.2013 7 3 4 2 1

*/

use [WideWorldImporters]
go
 
SELECT InvoiceMonth, pvt.[Peeples Valley, AZ], pvt.[Medicine Lodge, KS], pvt.[Gasport, NY], pvt.[Sylvanite, MT], pvt.[Jessie, ND]  
FROM 
(
select p2.CustomerName CustomerName,  
       DATEADD(MONTH,DATEDIFF(MONTH,0,i.InvoiceDate),0) InvoiceMonth,
	   count(i.InvoiceID) CountInvoices
 from [Sales].[Customers] c
   join [Sales].[Invoices] i on i.CustomerID = c.CustomerID
   cross apply (select SUBSTRING(c.CustomerName, CHARINDEX('(', c.CustomerName,0) + 1, LEN(c.CustomerName)) CustomerName) p1
   cross apply (select SUBSTRING(p1.CustomerName, 1, CHARINDEX(')', p1.CustomerName,0) - 1) CustomerName) p2  
where c.CustomerID between 2 and 6
group by DATEADD(MONTH,DATEDIFF(MONTH,0,i.InvoiceDate),0), p2.CustomerName 
) p PIVOT ( max(CountInvoices) FOR CustomerName IN  ( [Peeples Valley, AZ], [Medicine Lodge, KS], [Gasport, NY], [Sylvanite, MT], [Jessie, ND] )) AS pvt  
ORDER BY pvt.InvoiceMonth; 
 
/*в задании сказано, что результат таблица*/

drop table if exists #result

SELECT InvoiceMonth, pvt.[Peeples Valley, AZ], pvt.[Medicine Lodge, KS], pvt.[Gasport, NY], pvt.[Sylvanite, MT], pvt.[Jessie, ND]  
into #result
FROM 
(
select p2.CustomerName CustomerName,  
       DATEADD(MONTH,DATEDIFF(MONTH,0,i.InvoiceDate),0) InvoiceMonth,
	   count(i.InvoiceID) CountInvoices
 from [Sales].[Customers] c
   join [Sales].[Invoices] i on i.CustomerID = c.CustomerID
   cross apply (select SUBSTRING(c.CustomerName, CHARINDEX('(', c.CustomerName,0) + 1, LEN(c.CustomerName)) CustomerName) p1
   cross apply (select SUBSTRING(p1.CustomerName, 1, CHARINDEX(')', p1.CustomerName,0) - 1) CustomerName) p2  
where c.CustomerID between 2 and 6
group by DATEADD(MONTH,DATEDIFF(MONTH,0,i.InvoiceDate),0), p2.CustomerName 
) p PIVOT ( max(CountInvoices) FOR CustomerName IN  ( [Peeples Valley, AZ], [Medicine Lodge, KS], [Gasport, NY], [Sylvanite, MT], [Jessie, ND] )) AS pvt  
 

select InvoiceMonth, [Peeples Valley, AZ], [Medicine Lodge, KS], [Gasport, NY], [Sylvanite, MT], [Jessie, ND]  
from #result
order by InvoiceMonth
