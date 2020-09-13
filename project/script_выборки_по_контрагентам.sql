/*
работа с контрагентами
*/

USE WMS
GO

/*Реквизиты - реквизиты на дату начала действия уникальны*/
DROP INDEX if exists [UQ_Dict_ContragentRequisites_ContragentId_BeginDate] ON [dict].[ContragentRequisites]
GO 

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Dict_ContragentRequisites_ContragentId_BeginDate] ON [dict].[ContragentRequisites]
(
	[ContragentId] ASC,
	[BeginDate] ASC
)
go


SELECT c.ContragentId,
       c.ContragentName,
       c.ContragetFullName,
       c.Inn,
       c.ParentContragentId,
       c.CountryId,
       c.Ogrn,
       c.OgrnDate,
       requisite.RegisterDate,
       requisite.Kpp,
       requisite.JurAddress,
       requisite.FactAddress,
       requisite.LiquidationDate,
       requisite.FnsParticipantId,
       requisite.FnsRegistrationDate,
	   ct.ContragentTypeName,
	   cs.CountryName 
   FROM dict.Contragents c
    JOIN dict.ContragentType ct on ct.ContragentTypeId = c.ContragentTypeId
	JOIN dict.Countries cs on cs.CountryId = c.CountryId
    CROSS APPLY (SELECT TOP 1
                        cr.RegisterDate,
                        cr.Kpp,
                        cr.JurAddress,
                        cr.FactAddress,
                        cr.LiquidationDate,
                        cr.FnsParticipantId,
                        cr.FnsRegistrationDate
                   FROM dict.ContragentRequisites cr
                  WHERE cr.ContragentId = c.ContragentId
                ORDER BY cr.BeginDate DESC) requisite

DROP INDEX if exists [IX_Dict_ContragentRequisites_ContragentId] ON [dict].[ContragentRequisites]
GO
 
CREATE NONCLUSTERED INDEX [IX_Dict_ContragentRequisites_ContragentId] ON [dict].[ContragentRequisites]
(
	[ContragentId] ASC
)
INCLUDE([BeginDate],[EndDate],[RegisterDate],[Kpp],[JurAddress],[FactAddress],[LiquidationDate],[FnsParticipantId],[FnsRegistrationDate]) 
GO

/*список реквизитов для контрагента*/
declare @ContragentId int = 1
SELECT cr.BeginDate,
       cr.EndDate,
       cr.RegisterDate,
       cr.Kpp,
       cr.JurAddress,
       cr.FactAddress,
       cr.LiquidationDate,
       cr.FnsParticipantId,
       cr.FnsRegistrationDate
   FROM dict.ContragentRequisites cr
  WHERE cr.ContragentId = @ContragentId 

DROP INDEX if exists [IX_Dict_Contragents_ContragentTypeId] ON [dict].[Contragents]
GO
 
CREATE NONCLUSTERED INDEX [IX_Dict_Contragents_ContragentTypeId] ON [dict].[Contragents]
(
	[ContragentTypeId] ASC
)
INCLUDE([ContragentId],[ContragentName],[ContragetFullName],[Inn],[ParentContragentId],[CountryId],[Ogrn],[OgrnDate],[ContragentUID])
GO

/*поиск по типу*/
declare @ContragentTypeId int = 1
SELECT c.ContragentId,
       c.ContragentName,
       c.ContragetFullName,
	   c.Inn
   FROM dict.Contragents c 
where c.ContragentTypeId = @ContragentTypeId


DROP INDEX if exists [IX_Dict_Contragents_Inn] ON [dict].[Contragents]
GO
 
CREATE NONCLUSTERED INDEX [IX_Dict_Contragents_Inn] ON [dict].[Contragents]
(
	[Inn] ASC
)
INCLUDE([ContragentId],[ContragentName],[ContragetFullName],ContragentTypeId,[ParentContragentId],[CountryId],[Ogrn],[OgrnDate],[ContragentUID])
GO

/*поиск по ИНН*/
declare @Inn nvarchar(30) = '1111111111'
SELECT c.ContragentId,
       c.ContragentName,
       c.ContragetFullName
   FROM dict.Contragents c 
where c.Inn = @Inn


/*клиенты -  код клиента уникален*/
 
DROP INDEX if exists  [UQ_Dict_Clients_ClientCode] ON [dict].[Clients]
GO 

CREATE NONCLUSTERED INDEX [UQ_Dict_Clients_ClientCode] ON [dict].[Clients]
(
	[ClientCode] ASC
)
go

/*клиенты - контрагенты, список дейсвующих связей по клиенту*/

DROP INDEX if exists [IX_Fin_ClientContragentLinks_IsActive] ON [fin].[ClientContragentLinks]
GO
 
CREATE NONCLUSTERED INDEX [IX_Fin_ClientContragentLinks_IsActive] ON [fin].[ClientContragentLinks]
(
	[IsActive] ASC
)
INCLUDE([ClientId],[ContragentId],[AgreementId],[BeginDate],[EndDate],[IsMajor])
go

declare @ClientId bigint = 1
SELECT c.ClientId,
       c.ClientName,
	   contr.ContragentId,
       contr.ContragetFullName,
	   a.AgreementId,
       a.AgreementNum,
       a.AgreementDate,
       ccl.IsActive,
       ccl.BeginDate,
       ccl.EndDate,
       ccl.IsMajor
  FROM fin.ClientContragentLinks ccl
  JOIN dict.Clients c ON c.ClientId = ccl.ClientId
  JOIN dict.Contragents contr ON contr.ContragentId = ccl.ContragentId
  JOIN fin.Agreements a ON a.AgreementId = ccl.AgreementId
where ccl.ClientId = @ClientId and ccl.IsActive = 1

/*поставщики -  код поставщика уникален*/
 
DROP INDEX if exists  [UQ_Dict_Suppliers_SupplierCode] ON [dict].[Suppliers]
GO 

CREATE NONCLUSTERED INDEX [UQ_Dict_Suppliers_SupplierCode] ON [dict].[Suppliers]
(
	[SupplierCode] ASC
)
go

/*поставщики - контрагенты, список дейсвующих связей по поставщику*/
 
DROP INDEX if exists [IX_Fin_SupplierContragentLinks_IsActive] ON [fin].[SupplierContragentLinks]
GO
 
CREATE NONCLUSTERED INDEX [IX_Fin_SupplierContragentLinks_IsActive] ON [fin].[SupplierContragentLinks]
(
	[IsActive] ASC
)
INCLUDE([SupplierId],[ContragentId],[AgreementId],[BeginDate],[EndDate],[IsMajor])
go

declare @SupplierId bigint = 1
SELECT c.SupplierId,
       c.SupplierName,
	   contr.ContragentId,
       contr.ContragetFullName,
	   a.AgreementId,
       a.AgreementNum,
       a.AgreementDate,
       ccl.IsActive,
       ccl.BeginDate,
       ccl.EndDate,
       ccl.IsMajor
  FROM fin.SupplierContragentLinks ccl
  JOIN dict.Suppliers c ON c.SupplierId = ccl.SupplierId
  JOIN dict.Contragents contr ON contr.ContragentId = ccl.ContragentId
  JOIN fin.Agreements a ON a.AgreementId = ccl.AgreementId
where ccl.SupplierId = @SupplierId and ccl.IsActive = 1

/*склады поставщика -  код склада по поставщику уникален*/
 
DROP INDEX if exists  [UQ_Dict_SupplierStocks_SupplierId_StockCode] ON [dict].[SupplierStocks]
GO 

CREATE NONCLUSTERED INDEX [UQ_Dict_SupplierStocks_SupplierId_StockCode] ON [dict].[SupplierStocks]
(
    [SupplierId] ASC,
	[StockCode] ASC
)
go

/*склады поставщика*/
DROP INDEX if exists  [IX_Dict_SupplierStocks_SupplierId] ON [dict].[SupplierStocks]
GO
 
CREATE NONCLUSTERED INDEX [IX_Dict_SupplierStocks_SupplierId] ON [dict].[SupplierStocks]
(
	[SupplierId] ASC
) INCLUDE ([StockName],[StockCode])
go

declare @Supplier  bigint = 1
SELECT ss.StockName,
       ss.StockCode
  FROM dict.SupplierStocks ss 
 where ss.SupplierId = @Supplier
