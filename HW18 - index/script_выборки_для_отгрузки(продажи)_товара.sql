/*
список товаров для отгрузки клиентам
IsFinish = 0 - товары ожидающие отгрузки
*/

USE WMS
GO

DROP INDEX IF EXISTS [IX_Stock_SaleProcessingTask_IsFinish] ON [stock].[SaleProcessingTask]
GO
 
 CREATE NONCLUSTERED INDEX [IX_Stock_SaleProcessingTask_IsFinish] ON [stock].[SaleProcessingTask] ([IsFinish] ASC) 
	INCLUDE ([ClientId], [ProductId], [OrderQuantity], [SaleOrderId]) 
GO

SELECT spt.ClientId,
       cl.ClientName,
       spt.ProductId, 
	   pi.ProductName,
       SUM(spt.OrderQuantity) OrderQuantity
   FROM stock.SaleProcessingTask spt     
      JOIN goods.ProductItems pi ON pi.ProductId = spt.ProductId 
	  JOIN dict.Clients cl ON cl.ClientId = spt.ClientId
  WHERE spt.IsFinish = 0
GROUP BY spt.ClientId, cl.ClientName, spt.ProductId, pi.ProductName


/*список товаров для отгрузки клиенту*/
declare @ClientId bigint = 0
SELECT spt.ClientId,
       cl.ClientName,
       spt.ProductId, 
	   pi.ProductName,
       spt.OrderQuantity,
	   spt.SaleOrderId,
	   so.OrderNumber,
	   so.OrderDate
   FROM stock.SaleProcessingTask spt     
      JOIN goods.ProductItems pi ON pi.ProductId = spt.ProductId 
	  JOIN dict.Clients cl ON cl.ClientId = spt.ClientId
	  JOIN zak.SaleOrders so on so.OrderId = spt.SaleOrderId
  WHERE spt.IsFinish = 0 and spt.ClientId = @ClientId 

