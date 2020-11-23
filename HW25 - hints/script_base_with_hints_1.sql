use WideWorldImporters
go

SET STATISTICS IO, TIME, XML ON;

--SET SHOWPLAN_ALL ON;  
--SET SHOWPLAN_ALL OFF;  

--SET SHOWPLAN_XML ON;
--SET SHOWPLAN_XML OFF;

GO 

Select 
	ord.CustomerID, 
	det.StockItemID, 
	SUM(det.UnitPrice) SUMUnitPrice, 
	SUM(det.Quantity) SUMQuantity, 
	COUNT(ord.OrderID) COUNTOrderID
FROM Sales.Orders AS ord
JOIN Sales.OrderLines AS det
	ON det.OrderID = ord.OrderID
INNER HASH JOIN Sales.Invoices AS Inv
	ON Inv.OrderID = ord.OrderID
JOIN Sales.CustomerTransactions AS Trans
	ON Trans.InvoiceID = Inv.InvoiceID
JOIN Warehouse.StockItemTransactions AS ItemTrans
	ON ItemTrans.StockItemID = det.StockItemID
WHERE Inv.BillToCustomerID != ord.CustomerID
	
	AND (Select SupplierId
		  FROM Warehouse.StockItems AS It
		  Where It.StockItemID = det.StockItemID) = 12
	
	AND (SELECT SUM(Total.UnitPrice*Total.Quantity)
		  FROM Sales.OrderLines AS Total
		  Join Sales.Orders AS ordTotal
					On ordTotal.OrderID = Total.OrderID
		 WHERE ordTotal.CustomerID = Inv.CustomerID) >= 250000
	
	AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
GROUP BY ord.CustomerID, det.StockItemID
ORDER BY ord.CustomerID, det.StockItemID
 