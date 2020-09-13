/*поиск договора по номеру и\или дате*/

USE WMS
GO

DROP INDEX IF EXISTS [IX_Agreements_AgreementDate_AgreementNum] ON [fin].[Agreements]
GO
 
CREATE NONCLUSTERED INDEX [IX_Agreements_AgreementDate_AgreementNum] ON [fin].[Agreements]
(
	[AgreementDate] ASC,
	[AgreementNum] ASC
)
INCLUDE([AgreementId],[AgreementBeginDate],[AgreementEndDate],[AgreementTypeId],[SellerId],[BuyerId],[ShipperId],[ConsigneeId])
GO

declare @AgreementDate date='20200108', @AgreementNum NVARCHAR(150) ='80-К5'
select a.AgreementId,
       a.AgreementDate,
	   a.AgreementBeginDate,
	   a.AgreementEndDate,
	   at.AgreementTypeName
  FROM fin.Agreements a
    join fin.AgreementType at on at.AgreementTypeId = a.AgreementTypeId
  WHERE a.AgreementDate = @AgreementDate and a.AgreementNum = @AgreementNum

/*например, если поиск только по номеру, то можно составить запрос под индекс */
set @AgreementDate = null
IF @AgreementDate IS NULL SET @AgreementDate = '19010101' 
select a.AgreementId,
       a.AgreementDate,
	   a.AgreementBeginDate,
	   a.AgreementEndDate,
	   at.AgreementTypeName
  FROM fin.Agreements a
    join fin.AgreementType at on at.AgreementTypeId = a.AgreementTypeId
  WHERE a.AgreementDate = @AgreementDate and a.AgreementNum = @AgreementNum

select a.AgreementId,
       a.AgreementDate,
	   a.AgreementBeginDate,
	   a.AgreementEndDate,
	   at.AgreementTypeName
  FROM fin.Agreements a
    join fin.AgreementType at on at.AgreementTypeId = a.AgreementTypeId
  WHERE a.AgreementDate > N'' and a.AgreementNum = @AgreementNum