use [WideWorldImporters]
go

/*SQL SERVER 2019*/
/*-------------------------------------------------------------------------------------------------- 

5. Объясните, что делает и оптимизируйте запрос:
SELECT
Invoices.InvoiceID,
Invoices.InvoiceDate,
(SELECT People.FullName
FROM Application.People
WHERE People.PersonID = Invoices.SalespersonPersonID
) AS SalesPersonName,
SalesTotals.TotalSumm AS TotalSummByInvoice,
(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
FROM Sales.OrderLines
WHERE OrderLines.OrderId = (SELECT Orders.OrderId
FROM Sales.Orders
WHERE Orders.PickingCompletedWhen IS NOT NULL
AND Orders.OrderId = Invoices.OrderId)
) AS TotalSummForPickedItems
FROM Sales.Invoices
JOIN
(SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
FROM Sales.InvoiceLines
GROUP BY InvoiceId
HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC
Можно двигаться как в сторону улучшения читабельности запроса, так и в сторону упрощения плана\ускорения. 
Сравнить производительность запросов можно через SET STATISTICS IO, TIME ON. Если знакомы с планами запросов, то используйте их (тогда к решению также приложите планы). Напишите ваши рассуждения по поводу оптимизации.*/
  

SET STATISTICS IO, TIME ON;
GO

/*CPU time = 95 ms,  elapsed time = 43 ms.
  Cost 50%
*/
SELECT
	Invoices.InvoiceID,
	Invoices.InvoiceDate,
	(SELECT People.FullName
	   FROM Application.People
	  WHERE People.PersonID = Invoices.SalespersonPersonID
	) AS SalesPersonName,
	SalesTotals.TotalSumm AS TotalSummByInvoice,
	(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
	  FROM Sales.OrderLines
	 WHERE OrderLines.OrderId = (SELECT Orders.OrderId FROM Sales.Orders WHERE Orders.PickingCompletedWhen IS NOT NULL AND Orders.OrderId = Invoices.OrderId)
	 ) AS TotalSummForPickedItems
FROM Sales.Invoices
JOIN
	(SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
	  FROM Sales.InvoiceLines
	 GROUP BY InvoiceId
	 HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC

/*Отбираются счета (т.е. фактические продажи) на сумму более 27000 и выводится инфорамация - идсчета, дата счета (дата фактической продажи), полное имя сотрудника продавшего товар, 
итоговая сумма счета (сумма продажи), итоговая сумма по заказам из счета которые были укомплетованы; результат выводится с сортирововкой по итоговой сумме по убыванию*/

/*CPU time = 155 ms,  elapsed time = 51 ms. 
  Cost 50%
*/
;WITH SalesTotals as
   (SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
	  FROM Sales.InvoiceLines
	  GROUP BY InvoiceId
	 HAVING SUM(Quantity*UnitPrice) > 27000),
	   Picked as  
	(SELECT  o.OrderID, SUM(ol.PickedQuantity*ol.UnitPrice) TotalSumm
	   FROM Sales.Orders o JOIN Sales.OrderLines ol on o.OrderID = ol.OrderID
	   WHERE o.PickingCompletedWhen IS NOT NULL 
	  GROUP BY o.OrderID
     )
SELECT
	i.InvoiceID,
	i.InvoiceDate,
	People.FullName AS SalesPersonName,
	SalesTotals.TotalSumm TotalSummByInvoice,
	Picked.TotalSumm AS TotalSummForPickedItems
FROM  Sales.Invoices i 
     JOIN SalesTotals ON i.InvoiceID = SalesTotals.InvoiceID	 	 
	 LEFT JOIN Picked ON Picked.OrderID = i.OrderID
	 JOIN Application.People ON People.PersonID = i.SalespersonPersonID
ORDER BY TotalSummByInvoice DESC
 
 
SET STATISTICS IO, TIME OFF;
GO

 
/*
Улучшение читабельности без потери скорости выполнения.
Использование подзапросов в SELECT очень усложняет восприятие запроса.  
*/
 