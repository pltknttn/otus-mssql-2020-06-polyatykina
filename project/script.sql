/*
Начало проекта
Смотрим на схему, которая получилась в создании таблиц через DDL
Строим схему в use-case средстве, генерируем SQL код для создания.
Приводим свою БД в 3ю нормальную форму, либо если таблица в 1нф или 2нф или вообще не нормализована пишем зачем и почему так лучше.

В качестве проекта вы можете взять любую идею, которая вам близка и сделать схему базы данных, а затем создать ее.
Это может быть какая-то часть вашего рабочего проекта, которую вы хотите переосмыслить.
Если есть идея, но не понятно как ее уложить в рамки учебного проекта, напишите преподавателю и мы поможем.
На занятии-семинаре по представлению проектов в конце 2го модуля нужно будет показать схему БД, объяснить бизнес идею, а также технические решения, которые вы считаете важными.
*/

/*

Для всех таблиц выполнена 1НФ - повторяющихся строк не будет (во всех таблицах есть PK, что гарантирует уникальность каждой строки).
Для всех таблиц выполнена 2НФ - есть PK и каждый неключевой атрибут зависит от него.
Все таблицы приведены к 3НФ - функциональной зависимости между неключевыми атрибутами нет.

*/


USE master
go


DROP DATABASE IF  EXISTS [WMS]
GO

CREATE DATABASE [WMS]
CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = wms, FILENAME =N'D:\Working\Database\SQL Server\wms.mdf' , 
	SIZE = 8MB , 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 65536KB )
 LOG ON 
( NAME = wms_log, FILENAME = N'D:\Working\Database\SQL Server\wms.ldf' , 
	SIZE = 8MB , 
	MAXSIZE = 50GB , 
	FILEGROWTH = 65536KB )
 COLLATE Cyrillic_General_CI_AS
GO

USE [WMS]
GO

create schema [dict]
go

CREATE SCHEMA [fin]
go

CREATE SCHEMA [supply]
go

CREATE SCHEMA [doc]
go

CREATE SCHEMA [goods]
go

CREATE SCHEMA [zak]
go

CREATE SCHEMA [stock]
go
 
--
-- Create table [zak].[SaleOrderStatus]
--
PRINT (N'Create table [zak].[SaleOrderStatus]')
GO
CREATE TABLE zak.SaleOrderStatus (
  OrderStatusId int NOT NULL IDENTITY(1,1),
  OrderStatusName nvarchar(255) NOT NULL,
  OrderStatusCode nvarchar(100) NOT NULL,
  CONSTRAINT PK_Zak_SaleOrderState_OrderStatusId PRIMARY KEY CLUSTERED (OrderStatusId)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [zak].[SaleOrderStatus]
--
PRINT (N'Add extended property [MS_Description] on table [zak].[SaleOrderStatus]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Статусы', 'SCHEMA', N'zak', 'TABLE', N'SaleOrderStatus'
GO

--
-- Create table [zak].[PurchaseOrderStatus]
--
PRINT (N'Create table [zak].[PurchaseOrderStatus]')
GO
CREATE TABLE zak.PurchaseOrderStatus (
  OrderStatusId  int NOT NULL IDENTITY(1,1),
  OrderStatusName nvarchar(255) NOT NULL,
  OrderStatusCode nvarchar(100) NOT NULL,
  CONSTRAINT PK_Zak_PurchaseOrderState_OrderStatusId PRIMARY KEY CLUSTERED (OrderStatusId)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [zak].[PurchaseOrderStatus]
--
PRINT (N'Add extended property [MS_Description] on table [zak].[PurchaseOrderStatus]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Статусы', 'SCHEMA', N'zak', 'TABLE', N'PurchaseOrderStatus'
GO

--
-- Create table [supply].[SupplyOrderStatus]
--
PRINT (N'Create table [supply].[SupplyOrderStatus]')
GO
CREATE TABLE supply.SupplyOrderStatus (
  OrderStatusId int NOT NULL IDENTITY(1,1),
  OrderStatusName nvarchar(255) NOT NULL,
  OrderStatusCode nvarchar(100) NOT NULL,
  CONSTRAINT PK_Supply_SupplyOrderStatus_OrderStatusId PRIMARY KEY CLUSTERED (OrderStatusId)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [supply].[SupplyOrderStatus]
--
PRINT (N'Add extended property [MS_Description] on table [supply].[SupplyOrderStatus]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Статус заказа в  поставке', 'SCHEMA', N'supply', 'TABLE', N'SupplyOrderStatus'
GO

--
-- Create table [stock].[Places]
--
PRINT (N'Create table [stock].[Places]')
GO
CREATE TABLE stock.Places (
  PlaceId bigint NOT NULL IDENTITY(1,1),
  PlaceName nvarchar(100) NOT NULL,
  PlaceBarCode nvarchar(30) NOT NULL,
  CONSTRAINT PK_Place_PlaceId PRIMARY KEY CLUSTERED (PlaceId)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [stock].[Places]
--
PRINT (N'Add extended property [MS_Description] on table [stock].[Places]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Полки, места', 'SCHEMA', N'stock', 'TABLE', N'Places'
GO

--
-- Create table [stock].[Cells]
--
PRINT (N'Create table [stock].[Cells]')
GO
CREATE TABLE stock.Cells (
  CellId bigint NOT NULL IDENTITY(1,1),
  CellName nvarchar(100) NOT NULL,
  CellBarCode nvarchar(30) NOT NULL,
  PlaceId bigint NOT NULL,
  CONSTRAINT PK_Stock_Cells_CellId PRIMARY KEY CLUSTERED (CellId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Stock_Cells_PlaceId] on table [stock].[Cells]
--
PRINT (N'Create foreign key [FK_Stock_Cells_PlaceId] on table [stock].[Cells]')
GO
ALTER TABLE stock.Cells
  ADD CONSTRAINT FK_Stock_Cells_PlaceId FOREIGN KEY (PlaceId) REFERENCES stock.Places (PlaceId)
GO

--
-- Add extended property [MS_Description] on table [stock].[Cells]
--
PRINT (N'Add extended property [MS_Description] on table [stock].[Cells]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Ячейки', 'SCHEMA', N'stock', 'TABLE', N'Cells'
GO

--
-- Create table [stock].[Operation]
--
PRINT (N'Create table [stock].[Operation]')
GO
CREATE TABLE stock.Operation (
  OperationId bigint NOT NULL IDENTITY(1,1),
  OperationTypeId int NOT NULL,
  DateCreate datetime2 NOT NULL,
  Comment nvarchar(255) NOT NULL,
  CONSTRAINT PK_Stock_Operation_OperationId PRIMARY KEY CLUSTERED (OperationId)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [stock].[Operation]
--
PRINT (N'Add extended property [MS_Description] on table [stock].[Operation]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Операции', 'SCHEMA', N'stock', 'TABLE', N'Operation'
GO

--
-- Create table [fin].[TransactionType]
--
PRINT (N'Create table [fin].[TransactionType]')
GO
CREATE TABLE fin.TransactionType (
  TransactionTypeId int NOT NULL IDENTITY(1,1),
  TransactionTypeName nvarchar(150) NOT NULL,
  CONSTRAINT PK_Fin_TransactionType_TransactionTypeId PRIMARY KEY CLUSTERED (TransactionTypeId)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [fin].[TransactionType]
--
PRINT (N'Add extended property [MS_Description] on table [fin].[TransactionType]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Типы проводок', 'SCHEMA', N'fin', 'TABLE', N'TransactionType'
GO

--
-- Create table [fin].[TransactionSubType]
--
PRINT (N'Create table [fin].[TransactionSubType]')
GO
CREATE TABLE fin.TransactionSubType (
  TransactionSubTypeId int NOT NULL IDENTITY(1,1),
  TransactionSubTypeName nvarchar(150) NOT NULL,
  TransactionTypeId int NOT NULL,
  CONSTRAINT PK_Fin_TransactionSubType_TransactionSubTypeId PRIMARY KEY CLUSTERED (TransactionSubTypeId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Fint_TransactionSubType_TransactionTypeId] on table [fin].[TransactionSubType]
--
PRINT (N'Create foreign key [FK_Fint_TransactionSubType_TransactionTypeId] on table [fin].[TransactionSubType]')
GO
ALTER TABLE fin.TransactionSubType
  ADD CONSTRAINT FK_Fin_TransactionSubType_TransactionTypeId FOREIGN KEY (TransactionTypeId) REFERENCES fin.TransactionType (TransactionTypeId)
GO

--
-- Add extended property [MS_Description] on table [fin].[TransactionSubType]
--
PRINT (N'Add extended property [MS_Description] on table [fin].[TransactionSubType]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Подтипы проводок', 'SCHEMA', N'fin', 'TABLE', N'TransactionSubType'
GO

--
-- Create table [fin].[AgreementType]
--
PRINT (N'Create table [fin].[AgreementType]')
GO
CREATE TABLE fin.AgreementType (
  AgreementTypeId int NOT NULL IDENTITY (1, 1),
  AgreementTypeName nvarchar(255) NOT NULL,
  Description nvarchar(500) NOT NULL,
  CONSTRAINT PK_Fin_AgreementType_AgreementTypeId PRIMARY KEY CLUSTERED (AgreementTypeId),
  CONSTRAINT CHK_Fin_AgreementType_AgreementTypeName CHECK (Trim([AgreementTypeName])<>'')
)
ON [PRIMARY]
GO

--
-- Create table [fin].[AgreementProperty]
--
PRINT (N'Create table [fin].[AgreementProperty]')
GO
CREATE TABLE fin.AgreementProperty (
  PropertyId int NOT NULL IDENTITY (1,1),
  PropertyName nvarchar(255) NOT NULL,
  Description nvarchar(500) NOT NULL,
  CONSTRAINT PK_Fin_AgreementProperty_PropertyId PRIMARY KEY CLUSTERED (PropertyId),
  CONSTRAINT CHK_Fin_AgreementProperty_PropertyName CHECK (Trim([PropertyName])<>'')
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [fin].[AgreementProperty]
--
PRINT (N'Add extended property [MS_Description] on table [fin].[AgreementProperty]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Свойства', 'SCHEMA', N'fin', 'TABLE', N'AgreementProperty'
GO

--
-- Create table [doc].[DocumentType]
--
PRINT (N'Create table [doc].[DocumentType]')
GO
CREATE TABLE doc.DocumentType (
  DocumentTypeId int NOT NULL IDENTITY (1,1),
  DocumentTypeName nvarchar(255) NOT NULL,
  Description nvarchar(500) NOT NULL,
  CONSTRAINT PK_Doc_DocumentType_DocumentTypeId PRIMARY KEY CLUSTERED (DocumentTypeId)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [doc].[DocumentType]
--
PRINT (N'Add extended property [MS_Description] on table [doc].[DocumentType]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Типы документов', 'SCHEMA', N'doc', 'TABLE', N'DocumentType'
GO

--
-- Create table [doc].[DocumentProperty]
--
PRINT (N'Create table [doc].[DocumentProperty]')
GO
CREATE TABLE doc.DocumentProperty (
  PropertyId int NOT NULL IDENTITY (1,1),
  PropertyName nvarchar(255) NOT NULL,
  Description nvarchar(500) NOT NULL,
  CONSTRAINT PK_Doc_DocumentProperty_PropertyId PRIMARY KEY CLUSTERED (PropertyId),
  CONSTRAINT CHK_Doc_DocumentProperty_PropertyName CHECK (Trim([PropertyName])<>'')
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [doc].[DocumentProperty]
--
PRINT (N'Add extended property [MS_Description] on table [doc].[DocumentProperty]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Свойства', 'SCHEMA', N'doc', 'TABLE', N'DocumentProperty'
GO

--
-- Create table [doc].[DocumentLineProperty]
--
PRINT (N'Create table [doc].[DocumentLineProperty]')
GO
CREATE TABLE doc.DocumentLineProperty (
  PropertyId int NOT NULL IDENTITY(1,1),
  PropertyName nvarchar(255) NOT NULL,
  Description nvarchar(500) NOT NULL,
  CONSTRAINT PK_Doc_DocumentLineProperty_PropertyId PRIMARY KEY CLUSTERED (PropertyId),
  CONSTRAINT CHK_Doc_DocumentLineProperty_PropertyName CHECK (Trim([PropertyName])<>'')
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [doc].[DocumentLineProperty]
--
PRINT (N'Add extended property [MS_Description] on table [doc].[DocumentLineProperty]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Свойства', 'SCHEMA', N'doc', 'TABLE', N'DocumentLineProperty'
GO

--
-- Create table [doc].[DocumentDirection]
--
PRINT (N'Create table [doc].[DocumentDirection]')
GO
CREATE TABLE doc.DocumentDirection (
  DirectionId int NOT NULL IDENTITY(1,1),
  DirectionName nvarchar(255) NOT NULL,
  CONSTRAINT PK_Doc_DocumentDirection_DirectionId PRIMARY KEY CLUSTERED (DirectionId)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [doc].[DocumentDirection]
--
PRINT (N'Add extended property [MS_Description] on table [doc].[DocumentDirection]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Направление движения документа', 'SCHEMA', N'doc', 'TABLE', N'DocumentDirection'
GO

--
-- Create table [dict].[TaxValues]
--
PRINT (N'Create table [dict].[TaxValues]')
GO
CREATE TABLE dict.TaxValues (
  TaxValueId int IDENTITY (0, 1),
  TaxValue decimal(16, 2) NOT NULL,
  TaxName nvarchar(50) NOT NULL,
  TaxCode nvarchar(50) NOT NULL,
  CONSTRAINT PK_Dict_TaxValues_TaxValueId PRIMARY KEY CLUSTERED (TaxValueId)
)
ON [PRIMARY]
GO

--
-- Create table [dict].[Suppliers]
--
PRINT (N'Create table [dict].[Suppliers]')
GO
CREATE TABLE dict.Suppliers (
  SupplierId bigint NOT NULL IDENTITY(1,1),
  SupplierName nvarchar(255) NOT NULL,
  SupplierCode nvarchar(100) NOT NULL,
  CONSTRAINT PK_Dict_Suppliers_SupplierId PRIMARY KEY CLUSTERED (SupplierId)
)
ON [PRIMARY]
GO

--
-- Create table [supply].[Supplies]
--
PRINT (N'Create table [supply].[Supplies]')
GO
CREATE TABLE supply.Supplies (
  SupplyId bigint NOT NULL IDENTITY(1,1),
  SupplierId bigint NOT NULL,
  SupplyDate date NOT NULL,
  SupplyNumber nvarchar(150) NOT NULL,
  CreateDate datetime2 NOT NULL CONSTRAINT DF_Supply_Supplies__CreateDate DEFAULT (getdate()),
  ArrivalDate datetime2 NOT NULL,
  DriverName nvarchar(255) NOT NULL,
  VehicleName nvarchar(255) NOT NULL,
  PlaceCount int NOT NULL,
  CONSTRAINT PK_Supply_Supplies_SupplyId PRIMARY KEY CLUSTERED (SupplyId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Supply_Supplies_SupplierId] on table [supply].[Supplies]
--
PRINT (N'Create foreign key [FK_Supply_Supplies_SupplierId] on table [supply].[Supplies]')
GO
ALTER TABLE supply.Supplies
  ADD CONSTRAINT FK_Supply_Supplies_SupplierId FOREIGN KEY (SupplierId) REFERENCES dict.Suppliers (SupplierId)
GO

--
-- Add extended property [MS_Description] on table [supply].[Supplies]
--
PRINT (N'Add extended property [MS_Description] on table [supply].[Supplies]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Поставка', 'SCHEMA', N'supply', 'TABLE', N'Supplies'
GO

--
-- Create table [supply].[SupplyProcessingTask]
--
PRINT (N'Create table [supply].[SupplyProcessingTask]')
GO
CREATE TABLE supply.SupplyProcessingTask (
  TaskId bigint NOT NULL IDENTITY(1,1),
  SupplyId bigint NOT NULL,
  DocumentId bigint NOT NULL,
  PurchaseOrderId bigint NOT NULL,
  ProductId bigint NOT NULL,
  AwaitedQuantity int NOT NULL,
  RealQuantity int NOT NULL,
  GoodQuanity int NOT NULL,
  BrokenQuantity int NOT NULL,
  IsFinish bit NOT NULL CONSTRAINT [DF_Supply_SupplyProcessingTask_IsFinish]  DEFAULT ((0)),
  CONSTRAINT PK_Supply_SupplyProcessingTask_TaskId PRIMARY KEY CLUSTERED (TaskId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Supply_SupplyProcessingTask_SupplyId] on table [supply].[SupplyProcessingTask]
--
PRINT (N'Create foreign key [FK_Supply_SupplyProcessingTask_SupplyId] on table [supply].[SupplyProcessingTask]')
GO
ALTER TABLE supply.SupplyProcessingTask
  ADD CONSTRAINT FK_Supply_SupplyProcessingTask_SupplyId FOREIGN KEY (SupplyId) REFERENCES supply.Supplies (SupplyId)
GO

--
-- Add extended property [MS_Description] on table [supply].[SupplyProcessingTask]
--
PRINT (N'Add extended property [MS_Description] on table [supply].[SupplyProcessingTask]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Задания на прием', 'SCHEMA', N'supply', 'TABLE', N'SupplyProcessingTask'
GO

--
-- Create table [supply].[SupplyDetails]
--
PRINT (N'Create table [supply].[SupplyDetails]')
GO
CREATE TABLE supply.SupplyDetails (
  SupplyDetailId bigint NOT NULL IDENTITY(1,1),
  SupplyId bigint NOT NULL,
  DocumentId bigint NOT NULL,
  PurchaseOrderId bigint NOT NULL,
  ProductId bigint NOT NULL,
  Quantity int NOT NULL,
  OrderStatusId int NOT NULL,
  CONSTRAINT PK_SupplyDetails_SupplyDetailId PRIMARY KEY CLUSTERED (SupplyDetailId)
)
ON [PRIMARY]
GO

--
-- Create index [KEY_SupplyDetails_SupplyId] on table [supply].[SupplyDetails]
--
PRINT (N'Create index [KEY_SupplyDetails_SupplyId] on table [supply].[SupplyDetails]')
GO
CREATE UNIQUE INDEX KEY_SupplyDetails_SupplyId
  ON supply.SupplyDetails (SupplyId)
  ON [PRIMARY]
GO

--
-- Create foreign key [FK_Supply_SupplyDetails_OrderStatusId] on table [supply].[SupplyDetails]
--
PRINT (N'Create foreign key [FK_Supply_SupplyDetails_OrderStatusId] on table [supply].[SupplyDetails]')
GO
ALTER TABLE supply.SupplyDetails
  ADD CONSTRAINT FK_Supply_SupplyDetails_OrderStatusId FOREIGN KEY (OrderStatusId) REFERENCES supply.SupplyOrderStatus (OrderStatusId)
GO

--
-- Create foreign key [FK_Supply_SupplyDetails_SupplyId] on table [supply].[SupplyDetails]
--
PRINT (N'Create foreign key [FK_Supply_SupplyDetails_SupplyId] on table [supply].[SupplyDetails]')
GO
ALTER TABLE supply.SupplyDetails
  ADD CONSTRAINT FK_Supply_SupplyDetails_SupplyId FOREIGN KEY (SupplyId) REFERENCES supply.Supplies (SupplyId)
GO

--
-- Add extended property [MS_Description] on table [supply].[SupplyDetails]
--
PRINT (N'Add extended property [MS_Description] on table [supply].[SupplyDetails]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Детализация поставки', 'SCHEMA', N'supply', 'TABLE', N'SupplyDetails'
GO

--
-- Create table [goods].[PriceList]
--
PRINT (N'Create table [goods].[PriceList]')
GO
CREATE TABLE goods.PriceList (
  PriceListId bigint NOT NULL IDENTITY(1,1),
  PriceListNumber nvarchar(255) NOT NULL,
  PriceListDate date NOT NULL,
  SupplierId bigint NOT NULL,
  UploadDate datetime2 NOT NULL,
  CONSTRAINT PK_Goods_PriceList_PriceListId PRIMARY KEY CLUSTERED (PriceListId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Goods_PriceList_SupplierId] on table [goods].[PriceList]
--
PRINT (N'Create foreign key [FK_Goods_PriceList_SupplierId] on table [goods].[PriceList]')
GO
ALTER TABLE goods.PriceList
  ADD CONSTRAINT FK_Goods_PriceList_SupplierId FOREIGN KEY (SupplierId) REFERENCES dict.Suppliers (SupplierId)
GO

--
-- Add extended property [MS_Description] on table [goods].[PriceList]
--
PRINT (N'Add extended property [MS_Description] on table [goods].[PriceList]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Прайс-листы поставщиков', 'SCHEMA', N'goods', 'TABLE', N'PriceList'
GO

--
-- Create table [dict].[SupplierStocks]
--
PRINT (N'Create table [dict].[SupplierStocks]')
GO
CREATE TABLE dict.SupplierStocks (
  StockId bigint NOT NULL IDENTITY(1,1),
  SupplierId bigint NOT NULL,
  StockName nvarchar(255) NOT NULL,
  StockCode nvarchar(100) NOT NULL,
  CONSTRAINT PK_Dict_SupplierStocks_StockId PRIMARY KEY CLUSTERED (StockId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Dict_SupplierStocks_SupplierId] on table [dict].[SupplierStocks]
--
PRINT (N'Create foreign key [FK_Dict_SupplierStocks_SupplierId] on table [dict].[SupplierStocks]')
GO
ALTER TABLE dict.SupplierStocks
  ADD CONSTRAINT FK_Dict_SupplierStocks_SupplierId FOREIGN KEY (SupplierId) REFERENCES dict.Suppliers (SupplierId)
GO

--
-- Add extended property [MS_Description] on table [dict].[SupplierStocks]
--
PRINT (N'Add extended property [MS_Description] on table [dict].[SupplierStocks]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Склады поставщиков', 'SCHEMA', N'dict', 'TABLE', N'SupplierStocks'
GO

--
-- Create table [dict].[Manufacturers]
--
PRINT (N'Create table [dict].[Manufacturers]')
GO
CREATE TABLE dict.Manufacturers (
  ManufacturerId bigint NOT NULL IDENTITY(1,1),
  ManufacturerName nvarchar(255) NOT NULL,
  ManufacturerCode nvarchar(100) NOT NULL,
  ManufacturerUID uniqueidentifier NOT NULL,
  CONSTRAINT PK_Dict_Manufacturers_ManufacturerId PRIMARY KEY CLUSTERED (ManufacturerId)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [dict].[Manufacturers]
--
PRINT (N'Add extended property [MS_Description] on table [dict].[Manufacturers]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Производители', 'SCHEMA', N'dict', 'TABLE', N'Manufacturers'
GO

--
-- Create table [goods].[ProductItems]
--
PRINT (N'Create table [goods].[ProductItems]')
GO
CREATE TABLE goods.ProductItems (
  ProductId bigint NOT NULL IDENTITY(1,1),
  ProductName nvarchar(255) NOT NULL,
  Article nvarchar(50) NOT NULL,
  ParentProductId bigint NULL,
  ProductUID uniqueidentifier NOT NULL,
  ManufacturerId bigint NOT NULL,
  IsActive bit NOT NULL CONSTRAINT CK_Goods_ProductItems_IsActive DEFAULT (0),
  CONSTRAINT PK_Goods_ProductItems_ProductId PRIMARY KEY CLUSTERED (ProductId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Goods_ProductItems_ManufacturerId] on table [goods].[ProductItems]
--
PRINT (N'Create foreign key [FK_Goods_ProductItems_ManufacturerId] on table [goods].[ProductItems]')
GO
ALTER TABLE goods.ProductItems
  ADD CONSTRAINT FK_Goods_ProductItems_ManufacturerId FOREIGN KEY (ManufacturerId) REFERENCES dict.Manufacturers (ManufacturerId)
GO

--
-- Add extended property [MS_Description] on table [goods].[ProductItems]
--
PRINT (N'Add extended property [MS_Description] on table [goods].[ProductItems]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Товары', 'SCHEMA', N'goods', 'TABLE', N'ProductItems'
GO

--
-- Create table [stock].[Storage]
--
PRINT (N'Create table [stock].[Storage]')
GO
CREATE TABLE stock.Storage (
  StorageId bigint NOT NULL IDENTITY(1,1),
  ProductId bigint NOT NULL,
  PlaceId bigint NOT NULL,
  CellId bigint NULL,
  Quantity int NOT NULL,
  CONSTRAINT PK_Stock_Storage_StorageId PRIMARY KEY CLUSTERED (StorageId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Stock_Storage_CellId] on table [stock].[Storage]
--
PRINT (N'Create foreign key [FK_Stock_Storage_CellId] on table [stock].[Storage]')
GO
ALTER TABLE stock.Storage
  ADD CONSTRAINT FK_Stock_Storage_CellId FOREIGN KEY (CellId) REFERENCES stock.Cells (CellId)
GO

--
-- Create foreign key [FK_Stock_Storage_PlaceId] on table [stock].[Storage]
--
PRINT (N'Create foreign key [FK_Stock_Storage_PlaceId] on table [stock].[Storage]')
GO
ALTER TABLE stock.Storage
  ADD CONSTRAINT FK_Stock_Storage_PlaceId FOREIGN KEY (PlaceId) REFERENCES stock.Places (PlaceId)
GO

--
-- Create foreign key [FK_Stock_Storage_ProductId] on table [stock].[Storage]
--
PRINT (N'Create foreign key [FK_Stock_Storage_ProductId] on table [stock].[Storage]')
GO
ALTER TABLE stock.Storage
  ADD CONSTRAINT FK_Stock_Storage_ProductId FOREIGN KEY (ProductId) REFERENCES goods.ProductItems (ProductId)
GO

--
-- Add extended property [MS_Description] on table [stock].[Storage]
--
PRINT (N'Add extended property [MS_Description] on table [stock].[Storage]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Адресное хранение', 'SCHEMA', N'stock', 'TABLE', N'Storage'
GO

--
-- Create table [stock].[ProductUnits]
--
PRINT (N'Create table [stock].[ProductUnits]')
GO
CREATE TABLE stock.ProductUnits (
  ProductUnitId bigint NOT NULL IDENTITY(1,1),
  ProductId bigint NOT NULL,
  StorageId bigint NULL,
  MarkCode nvarchar(50) NOT NULL,
  SupplyId bigint NOT NULL,
  CONSTRAINT PK_Stock_ProductUnits_ProductUnitId PRIMARY KEY CLUSTERED (ProductUnitId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Stock_ProductUnits_ProductId] on table [stock].[ProductUnits]
--
PRINT (N'Create foreign key [FK_Stock_ProductUnits_ProductId] on table [stock].[ProductUnits]')
GO
ALTER TABLE stock.ProductUnits
  ADD CONSTRAINT FK_Stock_ProductUnits_ProductId FOREIGN KEY (ProductId) REFERENCES goods.ProductItems (ProductId)
GO

--
-- Create foreign key [FK_Stock_ProductUnits_StorageId] on table [stock].[ProductUnits]
--
PRINT (N'Create foreign key [FK_Stock_ProductUnits_StorageId] on table [stock].[ProductUnits]')
GO
ALTER TABLE stock.ProductUnits
  ADD CONSTRAINT FK_Stock_ProductUnits_StorageId FOREIGN KEY (StorageId) REFERENCES stock.Storage (StorageId)
GO

--
-- Create foreign key [FK_Stock_ProductUnits_SupplyId] on table [stock].[ProductUnits]
--
PRINT (N'Create foreign key [FK_Stock_ProductUnits_SupplyId] on table [stock].[ProductUnits]')
GO
ALTER TABLE stock.ProductUnits
  ADD CONSTRAINT FK_Stock_ProductUnits_SupplyId FOREIGN KEY (SupplyId) REFERENCES supply.Supplies (SupplyId)
GO

--
-- Add extended property [MS_Description] on table [stock].[ProductUnits]
--
PRINT (N'Add extended property [MS_Description] on table [stock].[ProductUnits]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Единицы товара', 'SCHEMA', N'stock', 'TABLE', N'ProductUnits'
GO

--
-- Create table [stock].[OperationDetails]
--
PRINT (N'Create table [stock].[OperationDetails]')
GO
CREATE TABLE stock.OperationDetails (
  OperationDetailId bigint NOT NULL IDENTITY(1,1),
  OperationId bigint NOT NULL,
  ProductId bigint NOT NULL,
  Quantity int NOT NULL,
  FromContragenttId bigint NOT NULL,
  ToContragentId bigint NOT NULL,
  FromPlaceId bigint NULL,
  ToPlaceId bigint NULL,
  FromCellId bigint NULL,
  ToCellId bigint NULL,
  CONSTRAINT PK_Stock_OperationDetails_OperationDetailId PRIMARY KEY CLUSTERED (OperationDetailId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Stock_OperationDetails_OperationId] on table [stock].[OperationDetails]
--
PRINT (N'Create foreign key [FK_Stock_OperationDetails_OperationId] on table [stock].[OperationDetails]')
GO
ALTER TABLE stock.OperationDetails
  ADD CONSTRAINT FK_Stock_OperationDetails_OperationId FOREIGN KEY (OperationId) REFERENCES stock.Operation (OperationId)
GO

--
-- Create foreign key [FK_Stock_OperationDetails_ProductId] on table [stock].[OperationDetails]
--
PRINT (N'Create foreign key [FK_Stock_OperationDetails_ProductId] on table [stock].[OperationDetails]')
GO
ALTER TABLE stock.OperationDetails
  ADD CONSTRAINT FK_Stock_OperationDetails_ProductId FOREIGN KEY (ProductId) REFERENCES goods.ProductItems (ProductId)
GO

--
-- Add extended property [MS_Description] on table [stock].[OperationDetails]
--
PRINT (N'Add extended property [MS_Description] on table [stock].[OperationDetails]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Детализация операций', 'SCHEMA', N'stock', 'TABLE', N'OperationDetails'
GO

--
-- Create table [goods].[PriceListItems]
--
PRINT (N'Create table [goods].[PriceListItems]')
GO
CREATE TABLE goods.PriceListItems (
  PriceListItemsId bigint NOT NULL IDENTITY(1,1),
  PriceListId bigint NOT NULL,
  ProductId bigint NOT NULL,
  Price decimal(16, 4) NOT NULL,
  Quantity int NOT NULL,
  StockId bigint NOT NULL,
  SupplierItemName nvarchar(255) NOT NULL,
  CONSTRAINT PK_Goods_PriceListItems_PriceListItemsId PRIMARY KEY CLUSTERED (PriceListItemsId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Goods_PriceListItems_PriceListId] on table [goods].[PriceListItems]
--
PRINT (N'Create foreign key [FK_Goods_PriceListItems_PriceListId] on table [goods].[PriceListItems]')
GO
ALTER TABLE goods.PriceListItems
  ADD CONSTRAINT FK_Goods_PriceListItems_PriceListId FOREIGN KEY (PriceListId) REFERENCES goods.PriceList (PriceListId)
GO

--
-- Create foreign key [FK_Goods_PriceListItems_ProductId] on table [goods].[PriceListItems]
--
PRINT (N'Create foreign key [FK_Goods_PriceListItems_ProductId] on table [goods].[PriceListItems]')
GO
ALTER TABLE goods.PriceListItems
  ADD CONSTRAINT FK_Goods_PriceListItems_ProductId FOREIGN KEY (ProductId) REFERENCES goods.ProductItems (ProductId)
GO

--
-- Create foreign key [FK_Goods_PriceListItems_StockId] on table [goods].[PriceListItems]
--
PRINT (N'Create foreign key [FK_Goods_PriceListItems_StockId] on table [goods].[PriceListItems]')
GO
ALTER TABLE goods.PriceListItems
  ADD CONSTRAINT FK_Goods_PriceListItems_StockId FOREIGN KEY (StockId) REFERENCES dict.SupplierStocks (StockId)
GO

--
-- Add extended property [MS_Description] on table [goods].[PriceListItems]
--
PRINT (N'Add extended property [MS_Description] on table [goods].[PriceListItems]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Позиции прайс-листа', 'SCHEMA', N'goods', 'TABLE', N'PriceListItems'
GO

--
-- Create table [dict].[Countries]
--
PRINT (N'Create table [dict].[Countries]')
GO
CREATE TABLE dict.Countries (
  CountryId int NOT NULL IDENTITY(1,1),
  CountryName nvarchar(100) NOT NULL,
  CountryFullName nvarchar(150) NOT NULL,
  IsoAlpha3Code nvarchar(3) NULL,
  IsoNumericCode int NULL,
  CONSTRAINT PK_dict_Countries_CountryId PRIMARY KEY CLUSTERED (CountryId),
  CONSTRAINT CHK_dict_Countries_CountryFullName CHECK (Trim([CountryFullName])<>''),
  CONSTRAINT CHK_dict_Countries_CountryName CHECK (Trim([CountryName])<>'')
)
ON [PRIMARY]
GO

--
-- Create index [IX_dict_Countries_IsoAlpha3Code] on table [dict].[Countries]
--
PRINT (N'Create index [IX_dict_Countries_IsoAlpha3Code] on table [dict].[Countries]')
GO
CREATE INDEX IX_dict_Countries_IsoAlpha3Code
  ON dict.Countries (IsoAlpha3Code)
  ON [PRIMARY]
GO

--
-- Create index [IX_dict_Countries_IsoNumericCode] on table [dict].[Countries]
--
PRINT (N'Create index [IX_dict_Countries_IsoNumericCode] on table [dict].[Countries]')
GO
CREATE INDEX IX_dict_Countries_IsoNumericCode
  ON dict.Countries (IsoNumericCode)
  ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [dict].[Countries]
--
PRINT (N'Add extended property [MS_Description] on table [dict].[Countries]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Страны', 'SCHEMA', N'dict', 'TABLE', N'Countries'
GO

--
-- Create table [dict].[ContragentType]
--
PRINT (N'Create table [dict].[ContragentType]')
GO
CREATE TABLE dict.ContragentType (
  ContragentTypeId int NOT NULL IDENTITY(1,1),
  ContragentTypeName nvarchar(255) NOT NULL,
  Description nvarchar(500) NOT NULL,
  CONSTRAINT PK_dict_ContragentType_ContragentTypeId PRIMARY KEY CLUSTERED (ContragentTypeId),
  CONSTRAINT CHK_dict_ContragentType_ContragentTypeName CHECK (Trim([ContragentTypeName])<>'')
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [dict].[ContragentType]
--
PRINT (N'Add extended property [MS_Description] on table [dict].[ContragentType]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Виды контрагентов', 'SCHEMA', N'dict', 'TABLE', N'ContragentType'
GO

--
-- Create table [dict].[Contragents]
--
PRINT (N'Create table [dict].[Contragents]')
GO
CREATE TABLE dict.Contragents (
  ContragentId bigint NOT NULL IDENTITY(1,1),
  ContragentName nvarchar(255) NOT NULL,
  ContragetFullName nvarchar(500) NOT NULL,
  ContragentTypeId int NOT NULL,
  Inn nvarchar(30) NULL,
  ParentContragentId bigint NULL,
  CountryId int NOT NULL,
  Ogrn nvarchar(30) NULL,
  OgrnDate datetime2(3) NULL,
  ContragentUID uniqueidentifier NOT NULL,
  CONSTRAINT PK_Dict_Contragents_ContragentId PRIMARY KEY CLUSTERED (ContragentId),
  CONSTRAINT CHK_Dict_Contragents_ContragentName CHECK (Trim([ContragentName])<>''),
  CONSTRAINT CHK_Dict_Contragents_ContragetFullName CHECK (Trim([ContragetFullName])<>''),
  CONSTRAINT CHK_Dict_Contragents_Inn CHECK ([Inn] IS NULL OR len([Inn])>=(10))
)
ON [PRIMARY]
GO

--
-- Create index [IX_Dict_Contragents_ContragentTypeId] on table [dict].[Contragents]
--
PRINT (N'Create index [IX_Dict_Contragents_ContragentTypeId] on table [dict].[Contragents]')
GO
CREATE INDEX IX_Dict_Contragents_ContragentTypeId
  ON dict.Contragents (ContragentTypeId)
  ON [PRIMARY]
GO

--
-- Create foreign key [FK_Dict_Contragents_ContragentId_Dict_Contragents] on table [dict].[Contragents]
--
PRINT (N'Create foreign key [FK_Dict_Contragents_ContragentId_Dict_Contragents] on table [dict].[Contragents]')
GO
ALTER TABLE dict.Contragents
  ADD CONSTRAINT FK_Dict_Contragents_ContragentId_Dict_Contragents FOREIGN KEY (ParentContragentId) REFERENCES dict.Contragents (ContragentId)
GO

--
-- Create foreign key [FK_Dict_Contragents_ContragentTypeId_Dict_ContragentType] on table [dict].[Contragents]
--
PRINT (N'Create foreign key [FK_Dict_Contragents_ContragentTypeId_Dict_ContragentType] on table [dict].[Contragents]')
GO
ALTER TABLE dict.Contragents
  ADD CONSTRAINT FK_Dict_Contragents_ContragentTypeId_Dict_ContragentType FOREIGN KEY (ContragentTypeId) REFERENCES dict.ContragentType (ContragentTypeId)
GO

--
-- Create foreign key [FK_Dict_Contragents_CountryId_Dict_Countries] on table [dict].[Contragents]
--
PRINT (N'Create foreign key [FK_Dict_Contragents_CountryId_Dict_Countries] on table [dict].[Contragents]')
GO
ALTER TABLE dict.Contragents
  ADD CONSTRAINT FK_Dict_Contragents_CountryId_Dict_Countries FOREIGN KEY (CountryId) REFERENCES dict.Countries (CountryId)
GO

--
-- Add extended property [MS_Description] on table [dict].[Contragents]
--
PRINT (N'Add extended property [MS_Description] on table [dict].[Contragents]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Контрагенты', 'SCHEMA', N'dict', 'TABLE', N'Contragents'
GO

--
-- Create table [fin].[Agreements]
--
PRINT (N'Create table [fin].[Agreements]')
GO
CREATE TABLE fin.Agreements (
  AgreementId bigint NOT NULL IDENTITY(1,1),
  AgreementNum nvarchar(150) NOT NULL,
  AgreementDate date NOT NULL,
  AgreementBeginDate date NULL,
  AgreementEndDate date NULL,
  AgreementUID uniqueidentifier NOT NULL,
  AgreementTypeId int NOT NULL,
  SellerId bigint NOT NULL,
  BuyerId bigint NOT NULL,
  ShipperId bigint NOT NULL,
  ConsigneeId bigint NOT NULL,
  CONSTRAINT PK_Fin_Agreements_AgreementId PRIMARY KEY CLUSTERED (AgreementId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Dict_Agreements_SellerId] on table [fin].[Agreements]
--
PRINT (N'Create foreign key [FK_Dict_Agreements_SellerId] on table [fin].[Agreements]')
GO
ALTER TABLE fin.Agreements
  ADD CONSTRAINT FK_Dict_Agreements_SellerId FOREIGN KEY (SellerId) REFERENCES dict.Contragents (ContragentId)
GO

--
-- Create foreign key [FK_Fin_Agreement_AgreementTypeId_Fin_AgreementType] on table [fin].[Agreements]
--
PRINT (N'Create foreign key [FK_Fin_Agreement_AgreementTypeId_Fin_AgreementType] on table [fin].[Agreements]')
GO
ALTER TABLE fin.Agreements
  ADD CONSTRAINT FK_Fin_Agreement_AgreementTypeId_Fin_AgreementType FOREIGN KEY (AgreementTypeId) REFERENCES fin.AgreementType (AgreementTypeId)
GO

--
-- Create foreign key [FK_Fin_Agreements_BuyerId] on table [fin].[Agreements]
--
PRINT (N'Create foreign key [FK_Fin_Agreements_BuyerId] on table [fin].[Agreements]')
GO
ALTER TABLE fin.Agreements
  ADD CONSTRAINT FK_Fin_Agreements_BuyerId FOREIGN KEY (BuyerId) REFERENCES dict.Contragents (ContragentId)
GO

--
-- Create foreign key [FK_Fin_Agreements_ConsigneeId] on table [fin].[Agreements]
--
PRINT (N'Create foreign key [FK_Fin_Agreements_ConsigneeId] on table [fin].[Agreements]')
GO
ALTER TABLE fin.Agreements
  ADD CONSTRAINT FK_Fin_Agreements_ConsigneeId FOREIGN KEY (ConsigneeId) REFERENCES dict.Contragents (ContragentId)
GO

--
-- Create foreign key [FK_Fin_Agreements_ShipperId] on table [fin].[Agreements]
--
PRINT (N'Create foreign key [FK_Fin_Agreements_ShipperId] on table [fin].[Agreements]')
GO
ALTER TABLE fin.Agreements
  ADD CONSTRAINT FK_Fin_Agreements_ShipperId FOREIGN KEY (ShipperId) REFERENCES dict.Contragents (ContragentId)
GO

--
-- Add extended property [MS_Description] on table [fin].[Agreements]
--
PRINT (N'Add extended property [MS_Description] on table [fin].[Agreements]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Договора', 'SCHEMA', N'fin', 'TABLE', N'Agreements'
GO

--
-- Create table [zak].[PurchaseOrders]
--
PRINT (N'Create table [zak].[PurchaseOrders]')
GO
CREATE TABLE zak.PurchaseOrders (
  OrderId bigint NOT NULL IDENTITY(1,1),
  OrderNumber nvarchar(255) NOT NULL,
  OrderDate date NOT NULL,
  CreateDate datetime2 NOT NULL CONSTRAINT DF_Zak_PurchaseOrders_CreateDate DEFAULT (getdate()),
  OutputDate datetime2 NULL,
  SupplierId bigint NOT NULL,
  AgreementId bigint NOT NULL,
  CONSTRAINT PK_Zak_PurchaseOrders_OrderId PRIMARY KEY CLUSTERED (OrderId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Zak_PurchaseOrders_AgreementId] on table [zak].[PurchaseOrders]
--
PRINT (N'Create foreign key [FK_Zak_PurchaseOrders_AgreementId] on table [zak].[PurchaseOrders]')
GO
ALTER TABLE zak.PurchaseOrders
  ADD CONSTRAINT FK_Zak_PurchaseOrders_AgreementId FOREIGN KEY (AgreementId) REFERENCES fin.Agreements (AgreementId)
GO

--
-- Create foreign key [FK_Zak_PurchaseOrders_SupplierId] on table [zak].[PurchaseOrders]
--
PRINT (N'Create foreign key [FK_Zak_PurchaseOrders_SupplierId] on table [zak].[PurchaseOrders]')
GO
ALTER TABLE zak.PurchaseOrders
  ADD CONSTRAINT FK_Zak_PurchaseOrders_SupplierId FOREIGN KEY (SupplierId) REFERENCES dict.Suppliers (SupplierId)
GO

--
-- Add extended property [MS_Description] on table [zak].[PurchaseOrders]
--
PRINT (N'Add extended property [MS_Description] on table [zak].[PurchaseOrders]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Заказы поставщику', 'SCHEMA', N'zak', 'TABLE', N'PurchaseOrders'
GO

--
-- Create table [zak].[PurchaseOrderItems]
--
PRINT (N'Create table [zak].[PurchaseOrderItems]')
GO
CREATE TABLE zak.PurchaseOrderItems (
  OrderItemId bigint NOT NULL IDENTITY(1,1),
  OrderId bigint NOT NULL,
  ProductId bigint NOT NULL,
  Price decimal(16, 4) NOT NULL,
  Quantity int NOT NULL,
  TaxValueId int NOT NULL,
  OrderStatusId int NOT NULL,
  ManufacturerId bigint NOT NULL,
  CONSTRAINT PK_Zak_PurchaseOrderItems_OrderItemId PRIMARY KEY CLUSTERED (OrderItemId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Zak_PurchaseOrderItems_ManufacturerId] on table [zak].[PurchaseOrderItems]
--
PRINT (N'Create foreign key [FK_Zak_PurchaseOrderItems_ManufacturerId] on table [zak].[PurchaseOrderItems]')
GO
ALTER TABLE zak.PurchaseOrderItems
  ADD CONSTRAINT FK_Zak_PurchaseOrderItems_ManufacturerId FOREIGN KEY (ManufacturerId) REFERENCES dict.Manufacturers (ManufacturerId)
GO

--
-- Create foreign key [FK_Zak_PurchaseOrderItems_OrderId] on table [zak].[PurchaseOrderItems]
--
PRINT (N'Create foreign key [FK_Zak_PurchaseOrderItems_OrderId] on table [zak].[PurchaseOrderItems]')
GO
ALTER TABLE zak.PurchaseOrderItems
  ADD CONSTRAINT FK_Zak_PurchaseOrderItems_OrderId FOREIGN KEY (OrderId) REFERENCES zak.PurchaseOrders (OrderId)
GO

--
-- Create foreign key [FK_Zak_PurchaseOrderItems_OrderStatusId] on table [zak].[PurchaseOrderItems]
--
PRINT (N'Create foreign key [FK_Zak_PurchaseOrderItems_OrderStatusId] on table [zak].[PurchaseOrderItems]')
GO
ALTER TABLE zak.PurchaseOrderItems
  ADD CONSTRAINT FK_Zak_PurchaseOrderItems_OrderStatusId FOREIGN KEY (OrderStatusId) REFERENCES zak.PurchaseOrderStatus (OrderStatusId)
GO

--
-- Create foreign key [FK_Zak_PurchaseOrderItems_ProductId] on table [zak].[PurchaseOrderItems]
--
PRINT (N'Create foreign key [FK_Zak_PurchaseOrderItems_ProductId] on table [zak].[PurchaseOrderItems]')
GO
ALTER TABLE zak.PurchaseOrderItems
  ADD CONSTRAINT FK_Zak_PurchaseOrderItems_ProductId FOREIGN KEY (ProductId) REFERENCES goods.ProductItems (ProductId)
GO

--
-- Add extended property [MS_Description] on table [zak].[PurchaseOrderItems]
--
PRINT (N'Add extended property [MS_Description] on table [zak].[PurchaseOrderItems]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Заказываемые товара из заказа поставщику', 'SCHEMA', N'zak', 'TABLE', N'PurchaseOrderItems'
GO

--
-- Create table [fin].[SupplierContragentLinks]
--
PRINT (N'Create table [fin].[SupplierContragentLinks]')
GO
CREATE TABLE fin.SupplierContragentLinks (
  LinkId bigint NOT NULL IDENTITY(1,1),
  SupplierId bigint NOT NULL,
  ContragentId bigint NOT NULL,
  AgreementId bigint NOT NULL,
  IsActive bit NOT NULL CONSTRAINT DF_FinSupplierContragentLinks_IsActive DEFAULT (1),
  BeginDate date NOT NULL,
  EndDate date NULL,
  IsMajor bit NOT NULL CONSTRAINT DF_Fin_SupplierContragentLinks_IsMajor DEFAULT (1),
  CONSTRAINT PK_Fin_SupplierContragentLinks_LinkId PRIMARY KEY CLUSTERED (LinkId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Fin_SupplierContragentLinks_AgreementId] on table [fin].[SupplierContragentLinks]
--
PRINT (N'Create foreign key [FK_Fin_SupplierContragentLinks_AgreementId] on table [fin].[SupplierContragentLinks]')
GO
ALTER TABLE fin.SupplierContragentLinks
  ADD CONSTRAINT FK_Fin_SupplierContragentLinks_AgreementId FOREIGN KEY (AgreementId) REFERENCES fin.Agreements (AgreementId)
GO

--
-- Create foreign key [FK_Fin_SupplierContragentLinks_ContragentId] on table [fin].[SupplierContragentLinks]
--
PRINT (N'Create foreign key [FK_Fin_SupplierContragentLinks_ContragentId] on table [fin].[SupplierContragentLinks]')
GO
ALTER TABLE fin.SupplierContragentLinks
  ADD CONSTRAINT FK_Fin_SupplierContragentLinks_ContragentId FOREIGN KEY (ContragentId) REFERENCES dict.Contragents (ContragentId)
GO

--
-- Create foreign key [FK_Fin_SupplierContragentLinks_SupplierId] on table [fin].[SupplierContragentLinks]
--
PRINT (N'Create foreign key [FK_Fin_SupplierContragentLinks_SupplierId] on table [fin].[SupplierContragentLinks]')
GO
ALTER TABLE fin.SupplierContragentLinks
  ADD CONSTRAINT FK_Fin_SupplierContragentLinks_SupplierId FOREIGN KEY (SupplierId) REFERENCES dict.Suppliers (SupplierId)
GO

--
-- Add extended property [MS_Description] on table [fin].[SupplierContragentLinks]
--
PRINT (N'Add extended property [MS_Description] on table [fin].[SupplierContragentLinks]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Связь поставщик - контрагенты', 'SCHEMA', N'fin', 'TABLE', N'SupplierContragentLinks'
GO

--
-- Create table [fin].[AgreementProperties]
--
PRINT (N'Create table [fin].[AgreementProperties]')
GO
CREATE TABLE fin.AgreementProperties (
  RowId bigint NOT NULL IDENTITY(1,1),
  AgreementId bigint NOT NULL,
  PropertyId int NOT NULL,
  ValueInt int NULL,
  ValueDecimal decimal(20, 4) NULL,
  ValueDatetime datetime2(3) NULL,
  ValueVarchar nvarchar(4000) NULL,
  CONSTRAINT PK_Fin_AgreementProperties_RowId PRIMARY KEY CLUSTERED (RowId),
  CONSTRAINT CHK_fin_AgreementProperties_Value CHECK ([ValueInt] IS NOT NULL OR [ValueDecimal] IS NOT NULL OR [ValueDatetime] IS NOT NULL OR [ValueVarchar] IS NOT NULL)
)
ON [PRIMARY]
GO

--
-- Create index [UQ_Fin_AgreementProperties_PropertyId_AgreementId] on table [fin].[AgreementProperties]
--
PRINT (N'Create index [UQ_Fin_AgreementProperties_PropertyId_AgreementId] on table [fin].[AgreementProperties]')
GO
CREATE UNIQUE INDEX UQ_Fin_AgreementProperties_PropertyId_AgreementId
  ON fin.AgreementProperties (AgreementId, PropertyId)
  ON [PRIMARY]
GO

--
-- Create foreign key [FK_Fin_AgreementProperties_AgreementId_fin_Agreements] on table [fin].[AgreementProperties]
--
PRINT (N'Create foreign key [FK_Fin_AgreementProperties_AgreementId_fin_Agreements] on table [fin].[AgreementProperties]')
GO
ALTER TABLE fin.AgreementProperties
  ADD CONSTRAINT FK_Fin_AgreementProperties_AgreementId_fin_Agreements FOREIGN KEY (AgreementId) REFERENCES fin.Agreements (AgreementId)
GO

--
-- Create foreign key [FK_Fin_AgreementProperties_PropertyId_Fin_AgreementProperty] on table [fin].[AgreementProperties]
--
PRINT (N'Create foreign key [FK_Fin_AgreementProperties_PropertyId_Fin_AgreementProperty] on table [fin].[AgreementProperties]')
GO
ALTER TABLE fin.AgreementProperties
  ADD CONSTRAINT FK_Fin_AgreementProperties_PropertyId_Fin_AgreementProperty FOREIGN KEY (PropertyId) REFERENCES fin.AgreementProperty (PropertyId)
GO

--
-- Add extended property [MS_Description] on table [fin].[AgreementProperties]
--
PRINT (N'Add extended property [MS_Description] on table [fin].[AgreementProperties]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Значения свойств договора', 'SCHEMA', N'fin', 'TABLE', N'AgreementProperties'
GO

--
-- Create table [doc].[Document]
--
PRINT (N'Create table [doc].[Document]')
GO
CREATE TABLE doc.Document (
  DocumentId bigint NOT NULL IDENTITY(1,1),
  DocumentNumber nvarchar(255) NOT NULL,
  DocumentDate date NOT NULL,
  DocumentTypeId int NOT NULL,
  TotalQuantity int NOT NULL,
  TotalSum decimal(16, 4) NOT NULL,
  DirectionId int NOT NULL,
  DocumentUID uniqueidentifier NOT NULL,
  AgreementId bigint NOT NULL,
  CONSTRAINT PK_Doc_Documents_DocumentId PRIMARY KEY CLUSTERED (DocumentId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Doc_Document_AgreementId] on table [doc].[Document]
--
PRINT (N'Create foreign key [FK_Doc_Document_AgreementId] on table [doc].[Document]')
GO
ALTER TABLE doc.Document
  ADD CONSTRAINT FK_Doc_Document_AgreementId FOREIGN KEY (AgreementId) REFERENCES fin.Agreements (AgreementId)
GO

--
-- Create foreign key [FK_Doc_Document_DirectionId] on table [doc].[Document]
--
PRINT (N'Create foreign key [FK_Doc_Document_DirectionId] on table [doc].[Document]')
GO
ALTER TABLE doc.Document
  ADD CONSTRAINT FK_Doc_Document_DirectionId FOREIGN KEY (DirectionId) REFERENCES doc.DocumentDirection (DirectionId)
GO

--
-- Create foreign key [FK_Doc_Document_DocumentTypeId] on table [doc].[Document]
--
PRINT (N'Create foreign key [FK_Doc_Document_DocumentTypeId] on table [doc].[Document]')
GO
ALTER TABLE doc.Document
  ADD CONSTRAINT FK_Doc_Document_DocumentTypeId FOREIGN KEY (DocumentTypeId) REFERENCES doc.DocumentType (DocumentTypeId)
GO

--
-- Add extended property [MS_Description] on table [doc].[Document]
--
PRINT (N'Add extended property [MS_Description] on table [doc].[Document]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Документ (шапка)', 'SCHEMA', N'doc', 'TABLE', N'Document'
GO

--
-- Create table [fin].[Transaction]
--
PRINT (N'Create table [fin].[Transaction]')
GO
CREATE TABLE fin.[Transaction] (
  TransactionId bigint NOT NULL IDENTITY(1,1),
  TransactionSubTypeId int NOT NULL,
  ProductId bigint NOT NULL,
  Quantity int NOT NULL,
  DocumentId bigint NULL,
  OperationId bigint NOT NULL,
  BusinesUnitId bigint NOT NULL,
  CONSTRAINT PK_Fin_Transaction_TransactionId PRIMARY KEY CLUSTERED (TransactionId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Fin_Transaction_DocumentId] on table [fin].[Transaction]
--
PRINT (N'Create foreign key [FK_Fin_Transaction_DocumentId] on table [fin].[Transaction]')
GO
ALTER TABLE fin.[Transaction]
  ADD CONSTRAINT FK_Fin_Transaction_DocumentId FOREIGN KEY (DocumentId) REFERENCES doc.Document (DocumentId)
GO

--
-- Create foreign key [FK_Fin_Transaction_OperationId] on table [fin].[Transaction]
--
PRINT (N'Create foreign key [FK_Fin_Transaction_OperationId] on table [fin].[Transaction]')
GO
ALTER TABLE fin.[Transaction]
  ADD CONSTRAINT FK_Fin_Transaction_OperationId FOREIGN KEY (OperationId) REFERENCES stock.Operation (OperationId)
GO

--
-- Create foreign key [FK_Fin_Transaction_ProductId] on table [fin].[Transaction]
--
PRINT (N'Create foreign key [FK_Fin_Transaction_ProductId] on table [fin].[Transaction]')
GO
ALTER TABLE fin.[Transaction]
  ADD CONSTRAINT FK_Fin_Transaction_ProductId FOREIGN KEY (ProductId) REFERENCES goods.ProductItems (ProductId)
GO

--
-- Create foreign key [FK_Fin_Transaction_TransactionSubTypeId] on table [fin].[Transaction]
--
PRINT (N'Create foreign key [FK_Fin_Transaction_TransactionSubTypeId] on table [fin].[Transaction]')
GO
ALTER TABLE fin.[Transaction]
  ADD CONSTRAINT FK_Fin_Transaction_TransactionSubTypeId FOREIGN KEY (TransactionSubTypeId) REFERENCES fin.TransactionSubType (TransactionSubTypeId)
GO

--
-- Add extended property [MS_Description] on table [fin].[Transaction]
--
PRINT (N'Add extended property [MS_Description] on table [fin].[Transaction]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Проводки', 'SCHEMA', N'fin', 'TABLE', N'Transaction'
GO

--
-- Create table [doc].[DocumentProperties]
--
PRINT (N'Create table [doc].[DocumentProperties]')
GO
CREATE TABLE doc.DocumentProperties (
  RowId bigint NOT NULL IDENTITY(1,1),
  DocumentId bigint NOT NULL,
  PropertyId int NOT NULL,
  ValueInt int NULL,
  ValueDecimal decimal(20, 4) NULL,
  ValueDatetime datetime2(3) NULL,
  ValueVarchar nvarchar(4000) NULL,
  CONSTRAINT PK_Doc_DocumentProperties_RowId PRIMARY KEY CLUSTERED (RowId),
  CONSTRAINT CHK_Doc_DocumentProperties_Value CHECK ([ValueInt] IS NOT NULL OR [ValueDecimal] IS NOT NULL OR [ValueDatetime] IS NOT NULL OR [ValueVarchar] IS NOT NULL)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Doc_DocumentProperties_DocumentId] on table [doc].[DocumentProperties]
--
PRINT (N'Create foreign key [FK_Doc_DocumentProperties_DocumentId] on table [doc].[DocumentProperties]')
GO
ALTER TABLE doc.DocumentProperties
  ADD CONSTRAINT FK_Doc_DocumentProperties_DocumentId FOREIGN KEY (DocumentId) REFERENCES doc.Document (DocumentId)
GO

--
-- Create foreign key [FK_Doc_DocumentProperties_PropertyId] on table [doc].[DocumentProperties]
--
PRINT (N'Create foreign key [FK_Doc_DocumentProperties_PropertyId] on table [doc].[DocumentProperties]')
GO
ALTER TABLE doc.DocumentProperties
  ADD CONSTRAINT FK_Doc_DocumentProperties_PropertyId FOREIGN KEY (PropertyId) REFERENCES doc.DocumentProperty (PropertyId)
GO

--
-- Add extended property [MS_Description] on table [doc].[DocumentProperties]
--
PRINT (N'Add extended property [MS_Description] on table [doc].[DocumentProperties]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Значения свойств документа', 'SCHEMA', N'doc', 'TABLE', N'DocumentProperties'
GO

--
-- Create table [doc].[DocumentLines]
--
PRINT (N'Create table [doc].[DocumentLines]')
GO
CREATE TABLE doc.DocumentLines (
  DocumentLineId bigint NOT NULL IDENTITY(1,1),
  ProductId bigint NOT NULL,
  LineNum int NOT NULL,
  Price decimal(16, 2) NOT NULL,
  Quantity int NOT NULL,
  DocumentId bigint NOT NULL,
  CONSTRAINT PK_DocumentLines_DocumentLineId PRIMARY KEY CLUSTERED (DocumentLineId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Doc_DocumentLines_DocumentId] on table [doc].[DocumentLines]
--
PRINT (N'Create foreign key [FK_Doc_DocumentLines_DocumentId] on table [doc].[DocumentLines]')
GO
ALTER TABLE doc.DocumentLines
  ADD CONSTRAINT FK_Doc_DocumentLines_DocumentId FOREIGN KEY (DocumentId) REFERENCES doc.Document (DocumentId)
GO

--
-- Create foreign key [FK_Doc_DocumentLines_ProductId] on table [doc].[DocumentLines]
--
PRINT (N'Create foreign key [FK_Doc_DocumentLines_ProductId] on table [doc].[DocumentLines]')
GO
ALTER TABLE doc.DocumentLines
  ADD CONSTRAINT FK_Doc_DocumentLines_ProductId FOREIGN KEY (ProductId) REFERENCES goods.ProductItems (ProductId)
GO

--
-- Add extended property [MS_Description] on table [doc].[DocumentLines]
--
PRINT (N'Add extended property [MS_Description] on table [doc].[DocumentLines]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Документ (Спецификация)', 'SCHEMA', N'doc', 'TABLE', N'DocumentLines'
GO

--
-- Create table [doc].[DocumentLineProperties]
--
PRINT (N'Create table [doc].[DocumentLineProperties]')
GO
CREATE TABLE doc.DocumentLineProperties (
  RowId bigint NOT NULL IDENTITY(1,1),
  DocumentLineId bigint NOT NULL,
  PropertyId int NOT NULL,
  ValueInt int NULL,
  ValueDecimal decimal(20, 4) NULL,
  ValueDatetime datetime2(3) NULL,
  ValueVarchar nvarchar(4000) NULL,
  CONSTRAINT PK_Doc_DocumentLineProperties_RowId PRIMARY KEY CLUSTERED (RowId),
  CONSTRAINT CHK_Doc_DocumentLineProperties_Value CHECK ([ValueInt] IS NOT NULL OR [ValueDecimal] IS NOT NULL OR [ValueDatetime] IS NOT NULL OR [ValueVarchar] IS NOT NULL)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Doc_DocumentLineProperties_DocumentLineId] on table [doc].[DocumentLineProperties]
--
PRINT (N'Create foreign key [FK_Doc_DocumentLineProperties_DocumentLineId] on table [doc].[DocumentLineProperties]')
GO
ALTER TABLE doc.DocumentLineProperties
  ADD CONSTRAINT FK_Doc_DocumentLineProperties_DocumentLineId FOREIGN KEY (DocumentLineId) REFERENCES doc.DocumentLines (DocumentLineId)
GO

--
-- Create foreign key [FK_Doc_DocumentLineProperties_PropertyId] on table [doc].[DocumentLineProperties]
--
PRINT (N'Create foreign key [FK_Doc_DocumentLineProperties_PropertyId] on table [doc].[DocumentLineProperties]')
GO
ALTER TABLE doc.DocumentLineProperties
  ADD CONSTRAINT FK_Doc_DocumentLineProperties_PropertyId FOREIGN KEY (PropertyId) REFERENCES doc.DocumentLineProperty (PropertyId)
GO

--
-- Add extended property [MS_Description] on table [doc].[DocumentLineProperties]
--
PRINT (N'Add extended property [MS_Description] on table [doc].[DocumentLineProperties]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Значения свойств позиции', 'SCHEMA', N'doc', 'TABLE', N'DocumentLineProperties'
GO

--
-- Create table [dict].[ContragentRequisites]
--
PRINT (N'Create table [dict].[ContragentRequisites]')
GO
CREATE TABLE dict.ContragentRequisites (
  RequisiteId bigint NOT NULL IDENTITY(1,1),
  ContragentId bigint NOT NULL,
  BeginDate date NOT NULL,
  EndDate date NULL,
  RegisterDate datetime2(3) NULL,
  Kpp nvarchar(30) NULL,
  JurAddress nvarchar(1000) NULL,
  FactAddress nvarchar(1000) NULL,
  LiquidationDate date NULL,
  FnsParticipantId nvarchar(50) NULL,
  FnsRegistrationDate datetime2(3) NULL,
  CONSTRAINT PK_dict_ContragentRequisites_RequisiteId PRIMARY KEY CLUSTERED (RequisiteId),
  CONSTRAINT CHK_dict_ContragentRequisites_BeginDate_EndDate CHECK ([BeginDate]<=isnull([EndDate],[BeginDate]))
)
ON [PRIMARY]
GO

--
-- Create index [UQ_dict_ContragentRequisites_ContragentId_BeginDate] on table [dict].[ContragentRequisites]
--
PRINT (N'Create index [UQ_dict_ContragentRequisites_ContragentId_BeginDate] on table [dict].[ContragentRequisites]')
GO
CREATE UNIQUE INDEX UQ_dict_ContragentRequisites_ContragentId_BeginDate
  ON dict.ContragentRequisites (ContragentId, BeginDate)
  ON [PRIMARY]
GO

--
-- Create foreign key [FK_dict_ContragentRequisites_ContragentId_dict_Contragents] on table [dict].[ContragentRequisites]
--
PRINT (N'Create foreign key [FK_dict_ContragentRequisites_ContragentId_dict_Contragents] on table [dict].[ContragentRequisites]')
GO
ALTER TABLE dict.ContragentRequisites
  ADD CONSTRAINT FK_dict_ContragentRequisites_ContragentId_dict_Contragents FOREIGN KEY (ContragentId) REFERENCES dict.Contragents (ContragentId)
GO

--
-- Add extended property [MS_Description] on table [dict].[ContragentRequisites]
--
PRINT (N'Add extended property [MS_Description] on table [dict].[ContragentRequisites]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Реквизиты', 'SCHEMA', N'dict', 'TABLE', N'ContragentRequisites'
GO

--
-- Create table [dict].[ContragentProperty]
--
PRINT (N'Create table [dict].[ContragentProperty]')
GO
CREATE TABLE dict.ContragentProperty (
  PropertyId int NOT NULL IDENTITY(1,1),
  PropertyName nvarchar(255) NOT NULL,
  Description nvarchar(500) NOT NULL,
  CONSTRAINT PK_dict_ContragentProperty_PropertyId PRIMARY KEY CLUSTERED (PropertyId),
  CONSTRAINT CHK_dict_ContragentProperty_PropertyName CHECK (Trim([PropertyName])<>'')
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [dict].[ContragentProperty]
--
PRINT (N'Add extended property [MS_Description] on table [dict].[ContragentProperty]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Свойства', 'SCHEMA', N'dict', 'TABLE', N'ContragentProperty'
GO

--
-- Create table [dict].[ContragentProperties]
--
PRINT (N'Create table [dict].[ContragentProperties]')
GO
CREATE TABLE dict.ContragentProperties (
  RowId bigint NOT NULL IDENTITY(1,1),
  ContragentId bigint NOT NULL,
  PropertyId int NOT NULL,
  ValueInt int NULL,
  ValueDecimal decimal(20, 4) NULL,
  ValueDatetime datetime2(3) NULL,
  ValueVarchar nvarchar(4000) NULL,
  CONSTRAINT PK_dict_ContragentProperties_RowId PRIMARY KEY CLUSTERED (RowId),
  CONSTRAINT CHK_dict_ContragentProperties_Value CHECK ([ValueInt] IS NOT NULL OR [ValueDecimal] IS NOT NULL OR [ValueDatetime] IS NOT NULL OR [ValueVarchar] IS NOT NULL)
)
ON [PRIMARY]
GO

--
-- Create index [UQ_dict_ContragentProperties_PropertyId_ContragentId] on table [dict].[ContragentProperties]
--
PRINT (N'Create index [UQ_dict_ContragentProperties_PropertyId_ContragentId] on table [dict].[ContragentProperties]')
GO
CREATE UNIQUE INDEX UQ_dict_ContragentProperties_PropertyId_ContragentId
  ON dict.ContragentProperties (ContragentId, PropertyId)
  ON [PRIMARY]
GO

--
-- Create foreign key [FK_dict_ContragentProperties_ContragentId_dict_Contragents] on table [dict].[ContragentProperties]
--
PRINT (N'Create foreign key [FK_dict_ContragentProperties_ContragentId_dict_Contragents] on table [dict].[ContragentProperties]')
GO
ALTER TABLE dict.ContragentProperties
  ADD CONSTRAINT FK_dict_ContragentProperties_ContragentId_dict_Contragents FOREIGN KEY (ContragentId) REFERENCES dict.Contragents (ContragentId)
GO

--
-- Create foreign key [FK_dict_ContragentProperties_PropertyId_dict_ContragentProperty] on table [dict].[ContragentProperties]
--
PRINT (N'Create foreign key [FK_dict_ContragentProperties_PropertyId_dict_ContragentProperty] on table [dict].[ContragentProperties]')
GO
ALTER TABLE dict.ContragentProperties
  ADD CONSTRAINT FK_dict_ContragentProperties_PropertyId_dict_ContragentProperty FOREIGN KEY (PropertyId) REFERENCES dict.ContragentProperty (PropertyId)
GO

--
-- Add extended property [MS_Description] on table [dict].[ContragentProperties]
--
PRINT (N'Add extended property [MS_Description] on table [dict].[ContragentProperties]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Значения свойств контрагентов', 'SCHEMA', N'dict', 'TABLE', N'ContragentProperties'
GO

--
-- Create table [dict].[Clients]
--
PRINT (N'Create table [dict].[Clients]')
GO
CREATE TABLE dict.Clients (
  ClientId bigint NOT NULL IDENTITY(1,1),
  ClientName nvarchar(255) NOT NULL,
  ClientCode nvarchar(100) NOT NULL,
  CONSTRAINT PK_Dict_Clients_ClientId PRIMARY KEY CLUSTERED (ClientId)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [dict].[Clients]
--
PRINT (N'Add extended property [MS_Description] on table [dict].[Clients]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Клиенты', 'SCHEMA', N'dict', 'TABLE', N'Clients'
GO

--
-- Create table [zak].[SaleOrders]
--
PRINT (N'Create table [zak].[SaleOrders]')
GO
CREATE TABLE zak.SaleOrders (
  OrderId bigint NOT NULL IDENTITY(1,1),
  OrderNumber nvarchar(255) NULL,
  OrderDate date NULL,
  CreateDate datetime2 NOT NULL CONSTRAINT DF_Zak_SaleOrders_CreateDate DEFAULT (getdate()),
  DeliveryDate datetime2 NULL,
  ClientId bigint NOT NULL,
  AgreementId bigint NOT NULL,
  CONSTRAINT PK_Zak_SaleOrders_OrderId PRIMARY KEY CLUSTERED (OrderId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Zak_SaleOrders_AgreementId] on table [zak].[SaleOrders]
--
PRINT (N'Create foreign key [FK_Zak_SaleOrders_AgreementId] on table [zak].[SaleOrders]')
GO
ALTER TABLE zak.SaleOrders
  ADD CONSTRAINT FK_Zak_SaleOrders_AgreementId FOREIGN KEY (AgreementId) REFERENCES fin.Agreements (AgreementId)
GO

--
-- Create foreign key [FK_Zak_SaleOrders_ClientId] on table [zak].[SaleOrders]
--
PRINT (N'Create foreign key [FK_Zak_SaleOrders_ClientId] on table [zak].[SaleOrders]')
GO
ALTER TABLE zak.SaleOrders
  ADD CONSTRAINT FK_Zak_SaleOrders_ClientId FOREIGN KEY (ClientId) REFERENCES dict.Clients (ClientId)
GO

--
-- Add extended property [MS_Description] on table [zak].[SaleOrders]
--
PRINT (N'Add extended property [MS_Description] on table [zak].[SaleOrders]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Заказы клиентов', 'SCHEMA', N'zak', 'TABLE', N'SaleOrders'
GO

--
-- Create table [zak].[SaleOrderItems]
--
PRINT (N'Create table [zak].[SaleOrderItems]')
GO
CREATE TABLE zak.SaleOrderItems (
  OrderItemId bigint NOT NULL IDENTITY(1,1),
  OrderId bigint NOT NULL,
  ProductId bigint NOT NULL,
  Price decimal(16, 4) NOT NULL,
  Quantity int NOT NULL,
  TaxValueId int NOT NULL,
  OrderStatusId int NOT NULL,
  SupplierId bigint NOT NULL,
  ManufacturerId bigint NOT NULL,
  CONSTRAINT PK_Zak_SaleOrderItems_OrderItemId PRIMARY KEY CLUSTERED (OrderItemId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Zak_SaleOrderItems_ManufacturerId] on table [zak].[SaleOrderItems]
--
PRINT (N'Create foreign key [FK_Zak_SaleOrderItems_ManufacturerId] on table [zak].[SaleOrderItems]')
GO
ALTER TABLE zak.SaleOrderItems
  ADD CONSTRAINT FK_Zak_SaleOrderItems_ManufacturerId FOREIGN KEY (ManufacturerId) REFERENCES dict.Manufacturers (ManufacturerId)
GO

--
-- Create foreign key [FK_Zak_SaleOrderItems_OrderId] on table [zak].[SaleOrderItems]
--
PRINT (N'Create foreign key [FK_Zak_SaleOrderItems_OrderId] on table [zak].[SaleOrderItems]')
GO
ALTER TABLE zak.SaleOrderItems
  ADD CONSTRAINT FK_Zak_SaleOrderItems_OrderId FOREIGN KEY (OrderId) REFERENCES zak.SaleOrders (OrderId)
GO

--
-- Create foreign key [FK_Zak_SaleOrderItems_OrderStatusId] on table [zak].[SaleOrderItems]
--
PRINT (N'Create foreign key [FK_Zak_SaleOrderItems_OrderStatusId] on table [zak].[SaleOrderItems]')
GO
ALTER TABLE zak.SaleOrderItems
  ADD CONSTRAINT FK_Zak_SaleOrderItems_OrderStatusId FOREIGN KEY (OrderStatusId) REFERENCES zak.SaleOrderStatus (OrderStatusId)
GO

--
-- Add extended property [MS_Description] on table [zak].[SaleOrderItems]
--
PRINT (N'Add extended property [MS_Description] on table [zak].[SaleOrderItems]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Позиции из заказа клиента', 'SCHEMA', N'zak', 'TABLE', N'SaleOrderItems'
GO

--
-- Create table [zak].[OrdersLink]
--
PRINT (N'Create table [zak].[OrdersLink]')
GO
CREATE TABLE zak.OrdersLink (
  LinkId bigint NOT NULL IDENTITY(1,1),
  PurchaseOrderItemId bigint NOT NULL,
  SaleOrderItemId bigint NOT NULL,
  Quantity int NOT NULL,
  CONSTRAINT PK_Zak_OrdersLink_LinkId PRIMARY KEY CLUSTERED (LinkId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Zak_OrdersLink_PurchaseOrderItemId] on table [zak].[OrdersLink]
--
PRINT (N'Create foreign key [FK_Zak_OrdersLink_PurchaseOrderItemId] on table [zak].[OrdersLink]')
GO
ALTER TABLE zak.OrdersLink
  ADD CONSTRAINT FK_Zak_OrdersLink_PurchaseOrderItemId FOREIGN KEY (PurchaseOrderItemId) REFERENCES zak.PurchaseOrderItems (OrderItemId)
GO

--
-- Create foreign key [FK_Zak_OrdersLink_SaleOrderItemId] on table [zak].[OrdersLink]
--
PRINT (N'Create foreign key [FK_Zak_OrdersLink_SaleOrderItemId] on table [zak].[OrdersLink]')
GO
ALTER TABLE zak.OrdersLink
  ADD CONSTRAINT FK_Zak_OrdersLink_SaleOrderItemId FOREIGN KEY (SaleOrderItemId) REFERENCES zak.SaleOrderItems (OrderItemId)
GO

--
-- Add extended property [MS_Description] on table [zak].[OrdersLink]
--
PRINT (N'Add extended property [MS_Description] on table [zak].[OrdersLink]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Связь между заказами', 'SCHEMA', N'zak', 'TABLE', N'OrdersLink'
GO

--
-- Create table [stock].[SaleProcessingTask]
--
PRINT (N'Create table [stock].[SaleProcessingTask]')
GO
CREATE TABLE stock.SaleProcessingTask (
  TaskId bigint NOT NULL IDENTITY(1,1),
  ClientId bigint NOT NULL,
  SaleOrderId bigint NOT NULL,
  ProductId bigint NOT NULL,
  OrderQuantity int NOT NULL,
  SaleQuantity int NOT NULL,
  RefuseQuantity int NOT NULL,
  BrokenQuantity int NOT NULL,
  IsFinish bit NOT NULL CONSTRAINT [DF_Stock_SaleProcessingTask_IsFinish]  DEFAULT ((0)),
  CONSTRAINT PK_Stock_SaleProcessingTask_TaskId PRIMARY KEY CLUSTERED (TaskId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Stock_SaleProcessingTask_ClientId] on table [stock].[SaleProcessingTask]
--
PRINT (N'Create foreign key [FK_Stock_SaleProcessingTask_ClientId] on table [stock].[SaleProcessingTask]')
GO
ALTER TABLE stock.SaleProcessingTask
  ADD CONSTRAINT FK_Stock_SaleProcessingTask_ClientId FOREIGN KEY (ClientId) REFERENCES dict.Clients (ClientId)
GO

--
-- Create foreign key [FK_Stock_SaleProcessingTask_ProductId] on table [stock].[SaleProcessingTask]
--
PRINT (N'Create foreign key [FK_Stock_SaleProcessingTask_ProductId] on table [stock].[SaleProcessingTask]')
GO
ALTER TABLE stock.SaleProcessingTask
  ADD CONSTRAINT FK_Stock_SaleProcessingTask_ProductId FOREIGN KEY (ProductId) REFERENCES goods.ProductItems (ProductId)
GO

--
-- Create foreign key [FK_Stock_SaleProcessingTask_SaleOrderId] on table [stock].[SaleProcessingTask]
--
PRINT (N'Create foreign key [FK_Stock_SaleProcessingTask_SaleOrderId] on table [stock].[SaleProcessingTask]')
GO
ALTER TABLE stock.SaleProcessingTask
  ADD CONSTRAINT FK_Stock_SaleProcessingTask_SaleOrderId FOREIGN KEY (SaleOrderId) REFERENCES zak.SaleOrders (OrderId)
GO

--
-- Add extended property [MS_Description] on table [stock].[SaleProcessingTask]
--
PRINT (N'Add extended property [MS_Description] on table [stock].[SaleProcessingTask]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Задания на отгрузку', 'SCHEMA', N'stock', 'TABLE', N'SaleProcessingTask'
GO

--
-- Create table [fin].[ClientContragentLinks]
--
PRINT (N'Create table [fin].[ClientContragentLinks]')
GO
CREATE TABLE fin.ClientContragentLinks (
  LinkId bigint NOT NULL IDENTITY(1,1),
  ClientId bigint NOT NULL,
  ContragentId bigint NOT NULL,
  AgreementId bigint NOT NULL,
  IsActive bit NOT NULL CONSTRAINT DF_Fin_ClientContragentLinks_IsActive DEFAULT (1),
  BeginDate date NOT NULL,
  EndDate date NULL,
  IsMajor bit NOT NULL CONSTRAINT DF_Fin_ClientContragentLinks_IsMajor DEFAULT (1),
  CONSTRAINT PK_Fin_ClientContragentLinks_LinkId PRIMARY KEY CLUSTERED (LinkId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Fin_ClientContragentLinks_AgreementId] on table [fin].[ClientContragentLinks]
--
PRINT (N'Create foreign key [FK_Fin_ClientContragentLinks_AgreementId] on table [fin].[ClientContragentLinks]')
GO
ALTER TABLE fin.ClientContragentLinks
  ADD CONSTRAINT FK_Fin_ClientContragentLinks_AgreementId FOREIGN KEY (AgreementId) REFERENCES fin.Agreements (AgreementId)
GO

--
-- Create foreign key [FK_Fin_ClientContragentLinks_ClientId] on table [fin].[ClientContragentLinks]
--
PRINT (N'Create foreign key [FK_Fin_ClientContragentLinks_ClientId] on table [fin].[ClientContragentLinks]')
GO
ALTER TABLE fin.ClientContragentLinks
  ADD CONSTRAINT FK_Fin_ClientContragentLinks_ClientId FOREIGN KEY (ClientId) REFERENCES dict.Clients (ClientId)
GO

--
-- Create foreign key [FK_Fin_ClientContragentLinks_ContragentId] on table [fin].[ClientContragentLinks]
--
PRINT (N'Create foreign key [FK_Fin_ClientContragentLinks_ContragentId] on table [fin].[ClientContragentLinks]')
GO
ALTER TABLE fin.ClientContragentLinks
  ADD CONSTRAINT FK_Fin_ClientContragentLinks_ContragentId FOREIGN KEY (ContragentId) REFERENCES dict.Contragents (ContragentId)
GO

--
-- Add extended property [MS_Description] on table [fin].[ClientContragentLinks]
--
PRINT (N'Add extended property [MS_Description] on table [fin].[ClientContragentLinks]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Связь клиенты - контрагенты', 'SCHEMA', N'fin', 'TABLE', N'ClientContragentLinks'
GO