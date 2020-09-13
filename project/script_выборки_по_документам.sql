/*
работа с документами
*/

USE WMS
GO

DROP INDEX IF EXISTS [IX_Doc_Document_DocumentTypeId] ON [doc].[Document]
GO
 
CREATE NONCLUSTERED INDEX [IX_Doc_Document_DocumentTypeId] ON [doc].[Document]
(
	[DocumentTypeId] ASC
)
INCLUDE([DocumentId],[DocumentNumber],[DocumentDate],[TotalQuantity],[TotalSum],[AgreementId])
GO

/*список документов УПД (или по любому другому типу)*/
DECLARE @DocumentTypeId INT = 1
SELECT d.DocumentId,
       d.DocumentNumber,
       d.DocumentDate, 
       a.AgreementNum,
       a.AgreementDate,
       a.SellerId,
	   seller.ContragentName SellerName,
       a.BuyerId,
	   buyer.ContragentName BuyerName,
       a.ShipperId,
	   shipper.ContragentName ShipperName,
       a.ConsigneeId,
	   consignee.ContragentName ConsigneeName,
	   d.TotalQuantity,
	   d.TotalSum
   FROM doc.Document d 
      JOIN fin.Agreements a ON a.AgreementId = d.AgreementId
	  JOIN dict.Contragents seller on seller.ContragentId = a.SellerId
	  JOIN dict.Contragents buyer on buyer.ContragentId = a.BuyerId
	  JOIN dict.Contragents shipper on shipper.ContragentId = a.ShipperId
	  JOIN dict.Contragents consignee on consignee.ContragentId = a.ConsigneeId
   WHERE  d.DocumentTypeId = @DocumentTypeId


/*поиск документов по номеру и\или дате*/
DROP INDEX IF EXISTS [IX_Doc_Document_DocumentDate_DocumentNumber] ON [doc].[Document]
GO
 
CREATE NONCLUSTERED INDEX [IX_Doc_Document_DocumentDate_DocumentNumber] ON [doc].[Document]
(
	[DocumentDate] asc, [DocumentNumber] asc
)
INCLUDE([DocumentId], [DocumentTypeId], [TotalQuantity],[TotalSum],[AgreementId])
GO

/*индекс используется для поиска либо по дате и номеру (когда 2 поля используются порядок не важен), либо по дате*/
 declare @DocumentNumber nvarchar(255) = '900', @DocumentDate date = '20200122'

select d.DocumentId,
       d.DocumentNumber,
	   d.DocumentDate,
	   d.TotalSum,
	   dt.DocumentTypeName
  FROM doc.Document d
   JOIN doc.DocumentType dt on dt.DocumentTypeId = d.DocumentTypeId
  where d.DocumentDate = @DocumentDate
    and (@DocumentNumber is null or d.DocumentNumber = @DocumentNumber)

select d.DocumentId,
       d.DocumentNumber,
	   d.DocumentDate,
	   d.TotalSum,
	   dt.DocumentTypeName
  FROM doc.Document d
   JOIN doc.DocumentType dt on dt.DocumentTypeId = d.DocumentTypeId
  where d.DocumentDate = @DocumentDate

declare @DocumentNumber2 nvarchar(255) = null 

select d.DocumentId,
       d.DocumentNumber,
	   d.DocumentDate,
	   d.TotalSum,
	   dt.DocumentTypeName
  FROM doc.Document d
   JOIN doc.DocumentType dt on dt.DocumentTypeId = d.DocumentTypeId
  where d.DocumentDate = @DocumentDate 
    and (@DocumentNumber2 is null or d.DocumentNumber = @DocumentNumber)

/*например, если поиск только по номеру, то можно составить запрос под индекс */
set @DocumentDate = null
if @DocumentDate is null set @DocumentDate = '19010101'
select d.DocumentId,
       d.DocumentNumber,
	   d.DocumentDate,
	   d.TotalSum,
	   dt.DocumentTypeName
  FROM doc.Document d
   JOIN doc.DocumentType dt on dt.DocumentTypeId = d.DocumentTypeId
  where d.DocumentDate > @DocumentDate
    and d.DocumentNumber = @DocumentNumber

DROP INDEX IF EXISTS [IX_Doc_DocumentLines_DocumentId] ON [doc].[DocumentLines]
GO
 
CREATE NONCLUSTERED INDEX [IX_Doc_DocumentLines_DocumentId] ON [doc].[DocumentLines]
(
	[DocumentId] ASC
)
INCLUDE([ProductId],[LineNum],[Price],[Quantity])
go

/*содержимое(спецификация) документа*/
declare @DocumentId bigint = 1
SELECT dl.LineNum,
       dl.ProductId,
	   pi.ProductName,
       dl.Price,
       dl.Quantity,
       dl.Price * dl.Quantity [Sum] 
  FROM doc.DocumentLines dl
  JOIN goods.ProductItems pi ON pi.ProductId = dl.ProductId
where dl.DocumentId = @DocumentId
order by dl.LineNum