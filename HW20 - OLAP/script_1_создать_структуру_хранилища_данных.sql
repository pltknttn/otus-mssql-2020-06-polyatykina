USE master
go
  

CREATE DATABASE [WAREHOUS]
CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = warehous, FILENAME =N'D:\Working\Database\SQL Server\WAREHOUS.mdf' , 
	SIZE = 8MB , 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 65536KB )
 LOG ON 
( NAME = warehous_log, FILENAME = N'D:\Working\Database\SQL Server\WAREHOUS.ldf' , 
	SIZE = 8MB , 
	MAXSIZE = 50GB , 
	FILEGROWTH = 65536KB )
GO

USE [WAREHOUS]
GO

/*Измерение: поставщики*/
create table dbo.DimSupplier
(
	SupplierKey bigint not null identity(1,1),
	SupplierID  bigint not null, 
	SupplierName nvarchar(255),
	ContactName nvarchar(255),
	EmailAddress nvarchar(256),
	PostAddress nvarchar(255),
	PhoneNumber nvarchar(100),
	FaxNumber nvarchar(100),
	CONSTRAINT [PK_DimSupplier] PRIMARY KEY CLUSTERED ( [SupplierKey] ASC)
)
go
 
/*Измерение: клиенты*/
create table dbo.DimCustomer
(
	CustomerKey bigint not null identity(1,1),
	CustomerID  bigint not null,
	CustomerName nvarchar(255),
	ContactName nvarchar(255),
	EmailAddress nvarchar(256),
	PostAddress nvarchar(255),
	PhoneNumber nvarchar(100),
	FaxNumber nvarchar(100),
	CONSTRAINT [PK_DimCustomer] PRIMARY KEY CLUSTERED ( [CustomerKey] ASC )
)
go

/*Измерение: товары*/
create table dbo.DimProductItem
(
	ProductKey   bigint not null identity(1,1),
	ProductID    bigint not null,
	ProductName  nvarchar(255) not null,
	ProductCode  nvarchar(100) not null,
	ProducerName nvarchar(255) not null,
	CategoryName nvarchar(255) not null,  
	RetailUnitPrice  decimal(16,2) not null,
	WeightPerUnit decimal(16,3) not null,
	Color         nvarchar(255) not null, 
	Size          nvarchar(100) not null
	CONSTRAINT [PK_DimProductItem] PRIMARY KEY CLUSTERED ( [ProductKey] ASC )
)
go

/*Измерение: Даты*/
CREATE TABLE dbo.DimDate(
	[Date]      date NOT NULL,
	DayNumber   int NOT NULL,
	[DateName]   nvarchar(30) NOT NULL,
	MonthNumber int NOT NULL,
	[MonthName] nvarchar(20) NOT NULL, 
	WeekNumber  int NOT NULL,
	WeekName    nvarchar(15) NOT NULL,
	[Year]      int NOT NULL,	
    CONSTRAINT [PK_DimDate] PRIMARY KEY CLUSTERED  ( [Date] ASC ) 
)  
GO


/*Факты: продажи*/
CREATE TABLE dbo.FactSale(
  SaleKey      bigint not null identity(1,1),
  CustomerKey  bigint not null,
  SupplierKey  bigint not null,
  ProductKey   bigint not null,
  InvoiceID    bigint not null,
  InvoiceNum   nvarchar(255) not null,
  InvoiceDate  date not null,
  Quantity     int  not null,
  UnitPrice    decimal(16,2) not null,
  Amount       decimal(16,2) not null,
  TaxRate      decimal(16,2) not null,
  TaxAmount    decimal(16,2) not null,
  CONSTRAINT [PK_FactSale] PRIMARY KEY CLUSTERED  ( [SaleKey] ASC ) 
)
GO
ALTER TABLE dbo.FactSale WITH CHECK ADD  CONSTRAINT [FK_FactSale_CustomerKey] FOREIGN KEY([CustomerKey]) REFERENCES dbo.[DimCustomer] ([CustomerKey])
GO
ALTER TABLE dbo.FactSale WITH CHECK ADD  CONSTRAINT [FK_FactSale_SupplierKey] FOREIGN KEY([SupplierKey]) REFERENCES dbo.[DimSupplier] ([SupplierKey])
GO
ALTER TABLE dbo.FactSale WITH CHECK ADD  CONSTRAINT [FK_FactSale_ProductKey] FOREIGN KEY([ProductKey]) REFERENCES dbo.[DimProductItem] ([ProductKey])
GO
ALTER TABLE dbo.FactSale WITH CHECK ADD  CONSTRAINT [FK_FactSale_InvoiceDate] FOREIGN KEY([InvoiceDate]) REFERENCES dbo.DimDate ([Date])
GO

CREATE NONCLUSTERED INDEX [IX_FactSale_InvoiceNum] ON [dbo].[FactSale]
(
	[InvoiceID] ASC 
)
GO
 
CREATE NONCLUSTERED INDEX [IX_FactSale_CustomerKey] ON [dbo].[FactSale]
(
	[CustomerKey] ASC 
)
GO

CREATE NONCLUSTERED INDEX [IX_FactSale_SupplierKey] ON [dbo].[FactSale]
(
	[SupplierKey] ASC 
)
GO

CREATE NONCLUSTERED INDEX [IX_FactSale_ProductKey] ON [dbo].[FactSale]
(
	[ProductKey] ASC 
)
GO

CREATE NONCLUSTERED INDEX [IX_FactSale_InvoiceDate] ON [dbo].[FactSale]
(
	[InvoiceDate] ASC 
)
GO

/*Техническая информация для обновления данных по таблицам хранилища*/
create table dbo.[LoadedDataInfo]
(
    DataKey    int not null identity(1,1),
    TableName  nvarchar(255) not null,
	LoadStart  datetime2(7)  not null,
	UpdateDate datetime2(7),
	Successful bit not null,
	ErrorMessage nvarchar(4000),
	CONSTRAINT [PK_LoadedDataInfo] PRIMARY KEY CLUSTERED  ( [DataKey] ASC ) 
)
GO


/*Обновление данных в таблице dbo.DimDate*/
create or alter procedure dbo.LoadDimDate
@p_date_from date, 
@p_date_to   date
as
begin
    SET NOCOUNT ON
	SET XACT_ABORT ON

	set @p_date_from = isnull(@p_date_from, {ts '2011-09-01 00:00:00'})
	set @p_date_to = isnull(@p_date_to,getdate())
	if @p_date_to < @p_date_from set @p_date_to = @p_date_from;--DATEADD(day, 1, @p_date_to)

    SET DATEFIRST 1;
	SET language russian;
	 
	with  tree (vDate)
	as (select  cast(@p_date_from as date)   vDate
		 union all
		select dateadd(day, 1, vDate) vDate
		 from tree
	 where vDate <  cast(@p_date_to as date) 
	 ) 
	select vDate [Date], 
		   day(vDate) DayNumber,
		   FORMAT(vDate,'dd MMMM yyyy') [DateName],
		   MONTH(vDate) MonthNumber,
		   lower(datename(MONTH, vDate)) [MonthName],
		   datepart(dw, vDate ) WeekNumber, datename(dw, vDate ) WeekName,
		   YEAR(vDate) [Year]
	  into #calcDates
	  from tree
	option(maxrecursion 0)

	merge dbo.DimDate t
	using #calcDates s on t.[Date] = s.[Date]
    when not matched then insert ([Date]
           ,[DayNumber]
           ,[DateName]
           ,[MonthNumber]
           ,[MonthName]
           ,[WeekNumber]
           ,[WeekName]
           ,[Year])
		   values (
		    s.[Date]
           ,s.[DayNumber]
           ,s.[DateName]
           ,s.[MonthNumber]
           ,s.[MonthName]
           ,s.[WeekNumber]
           ,s.[WeekName]
           ,s.[Year])
    when matched then 
	  update set 
       [DayNumber] = s.[DayNumber]
      ,[DateName] = s.[DateName]
      ,[MonthNumber] = s.[MonthNumber]
      ,[MonthName] = s.[MonthName]
      ,[WeekNumber] = s.[WeekNumber]
      ,[WeekName] = s.[WeekName]
      ,[Year] = s.[Year];

	RETURN (0)
end
go
 