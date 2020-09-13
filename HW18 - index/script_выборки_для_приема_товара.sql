/*
список товаров для приема поставки
IsFinish = 0 - товары ожидающие прием поставки товаров от поставщика
*/

USE WMS
GO

DROP INDEX IF EXISTS [IX_Supply_SupplyProcessingTask_IsFinish] ON supply.SupplyProcessingTask
GO
 
 CREATE NONCLUSTERED INDEX [IX_Supply_SupplyProcessingTask_IsFinish] ON supply.SupplyProcessingTask ([IsFinish] ASC) 
	INCLUDE ([SupplierId], [ProductId], [AwaitedQuantity], [SupplyId], [DocumentId]) 
GO

SELECT spt.SupplierId,
       s.SupplierName,
       spt.ProductId,
	   pi.ProductName,
       SUM(spt.AwaitedQuantity) AwaitedQuantity
  FROM supply.SupplyProcessingTask spt
	  JOIN goods.ProductItems pi ON pi.ProductId = spt.ProductId 
	  JOIN dict.Suppliers s on s.SupplierId = spt.SupplierId
  WHERE spt.IsFinish = 0
  GROUP BY spt.SupplierId, s.SupplierName, spt.ProductId, pi.ProductName

/*прием товара от поставщика*/
declare @SupplierId bigint = 0
drop table if exists #Documents
create table #Documents (DocumentId bigint not null primary key) -- заполниться ид документов, по которым будет прием товара

SELECT spt.SupplierId,
       s.SupplierName,
       spt.ProductId,
	   pi.ProductName,
       spt.AwaitedQuantity,
	   spt.SupplyId,
	   sup.SupplyNumber,
	   sup.SupplyDate, 
	   doc.DocumentNumber,
	   doc.DocumentDate
  FROM supply.SupplyProcessingTask spt
	  JOIN goods.ProductItems pi ON pi.ProductId = spt.ProductId 
	  JOIN dict.Suppliers s on s.SupplierId = spt.SupplierId
	  JOIN #Documents d on d.DocumentId = spt.DocumentId
	  JOIN doc.Document doc on doc.DocumentId = spt.DocumentId
	  JOIN supply.Supplies sup on sup.SupplyId = spt.SupplyId
  WHERE spt.IsFinish = 0 and spt.SupplierId = @SupplierId