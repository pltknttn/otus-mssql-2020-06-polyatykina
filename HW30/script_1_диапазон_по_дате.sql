use WideWorldImporters;
GO

--1. Создать файловую группу и файл (опционально)

--создадим файловую группу
ALTER DATABASE [WideWorldImporters] ADD FILEGROUP [YearData]
GO
 
--добавляем файл БД
ALTER DATABASE [WideWorldImporters] ADD FILE ( NAME = N'Years', FILENAME = N'D:\Working\Database\SQL Server\Yeardata.ndf' , 
SIZE = 1097152KB , FILEGROWTH = 65536KB ) TO FILEGROUP [YearData]
GO

--2. Выбрать ключ секционирования
-- Дата 
 select min(OrderDate) MinOrderDate, max(OrderDate) MaxOrderDate FROM [Purchasing].[PurchaseOrders]

--3. Создать схему и функцию партиционирования

--создаем функцию партиционирования по годам   
CREATE PARTITION FUNCTION [fnYearPartition](DATE) AS RANGE RIGHT FOR VALUES
('20120101','20130101','20140101','20150101','20160101', '20170101', '20180101', '20190101', '20200101', '20210101');																																																									
GO 

-- партиционируем, используя созданную нами функцию
CREATE PARTITION SCHEME [schmYearPartition] AS PARTITION [fnYearPartition]  ALL TO ([YearData])
GO

--3. Создать партиционированные таблицы и кластерные индексы в той же схеме с тем же ключом

drop table if exists  Purchasing.[PurchaseOrderLinesYears];
drop table if exists  Purchasing.[PurchaseOrdersYears];

--создадим партиционированную таблицу
CREATE TABLE Purchasing.[PurchaseOrderLinesYears](
	[PurchaseOrderLineID] [int] NOT NULL,
	[PurchaseOrderID] [int] NOT NULL,
	[OrderDate] [date] NOT NULL,
	[StockItemID] [int] NOT NULL,
	[OrderedOuters] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[ReceivedOuters] [int] NOT NULL,
	[PackageTypeID] [int] NOT NULL,
	[ExpectedUnitPricePerOuter] [decimal](18, 2) NULL,
	[LastReceiptDate] [date] NULL,
	[IsOrderLineFinalized] [bit] NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL,
) ON [schmYearPartition]([OrderDate])---в схеме [schmYearPartition] по ключу [OrderDate]
GO

--создадим кластерный индекс в той же схеме с тем же ключом
ALTER TABLE Purchasing.[PurchaseOrderLinesYears] ADD CONSTRAINT [PK_Purchase_PurchaseOrderLinesYears]
PRIMARY KEY CLUSTERED  (OrderDate, PurchaseOrderID, PurchaseOrderLineID)
 ON [schmYearPartition]([OrderDate]);

--то же самое для второй таблицы
CREATE TABLE Purchasing.[PurchaseOrdersYears](
	[PurchaseOrderID] [int] NOT NULL,
	[SupplierID] [int] NOT NULL,
	[OrderDate] [date] NOT NULL,
	[DeliveryMethodID] [int] NOT NULL,
	[ContactPersonID] [int] NOT NULL,
	[ExpectedDeliveryDate] [date] NULL,
	[SupplierReference] [nvarchar](20) NULL,
	[IsOrderFinalized] [bit] NOT NULL,
	[Comments] [nvarchar](max) NULL,
	[InternalComments] [nvarchar](max) NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL,
) ON [schmYearPartition]([OrderDate])
GO

ALTER TABLE Purchasing.[PurchaseOrdersYears] ADD CONSTRAINT [PK_Purchase_PurchaseOrderYears] 
PRIMARY KEY CLUSTERED  (OrderDate, PurchaseOrderID)
 ON [schmYearPartition]([OrderDate]);


 -- 4. Заливка данных
 --truncate table Purchasing.[PurchaseOrderLinesYears]
 insert into Purchasing.[PurchaseOrderLinesYears](
            [PurchaseOrderLineID]
           ,[PurchaseOrderID]
           ,[OrderDate]
           ,[StockItemID]
           ,[OrderedOuters]
           ,[Description]
           ,[ReceivedOuters]
           ,[PackageTypeID]
           ,[ExpectedUnitPricePerOuter]
           ,[LastReceiptDate]
           ,[IsOrderLineFinalized]
           ,[LastEditedBy]
           ,[LastEditedWhen])
 select     l.[PurchaseOrderLineID]
           ,l.[PurchaseOrderID]
           ,o.[OrderDate]
           ,l.[StockItemID]
           ,l.[OrderedOuters]
           ,l.[Description]
           ,l.[ReceivedOuters]
           ,l.[PackageTypeID]
           ,l.[ExpectedUnitPricePerOuter]
           ,l.[LastReceiptDate]
           ,l.[IsOrderLineFinalized]
           ,l.[LastEditedBy]
           ,l.[LastEditedWhen]
  from Purchasing.[PurchaseOrderLines] l
  join Purchasing.[PurchaseOrders] o on l.PurchaseOrderID = o.PurchaseOrderID


  -- truncate table Purchasing.[PurchaseOrdersYears]
  insert into Purchasing.[PurchaseOrdersYears] (
            [PurchaseOrderID]
           ,[SupplierID]
           ,[OrderDate]
           ,[DeliveryMethodID]
           ,[ContactPersonID]
           ,[ExpectedDeliveryDate]
           ,[SupplierReference]
           ,[IsOrderFinalized]
           ,[Comments]
           ,[InternalComments]
           ,[LastEditedBy]
           ,[LastEditedWhen])
select      [PurchaseOrderID]
           ,[SupplierID]
           ,[OrderDate]
           ,[DeliveryMethodID]
           ,[ContactPersonID]
           ,[ExpectedDeliveryDate]
           ,[SupplierReference]
           ,[IsOrderFinalized]
           ,[Comments]
           ,[InternalComments]
           ,[LastEditedBy]
           ,[LastEditedWhen]
  from Purchasing.[PurchaseOrders]

  -- 5. Запросы
  -- смотрим план запроса
 
SET STATISTICS io, time on;
 
-- секционирование не используется
SELECT 
	Ord.PurchaseOrderID, Ord.OrderDate, Lines.[OrderedOuters], Lines.ExpectedUnitPricePerOuter
FROM Purchasing.[PurchaseOrdersYears] AS Ord
	JOIN Purchasing.[PurchaseOrderLinesYears] AS Lines
		ON Ord.PurchaseOrderID = Lines.PurchaseOrderID
			AND Ord.OrderDate = Lines.OrderDate
WHERE Ord.SupplierID = 1;

-- используется нужная секция
SELECT 
	Ord.PurchaseOrderID, Ord.OrderDate, Lines.[OrderedOuters], Lines.ExpectedUnitPricePerOuter
FROM Purchasing.[PurchaseOrdersYears] AS Ord
	JOIN Purchasing.[PurchaseOrderLinesYears] AS Lines
		ON Ord.PurchaseOrderID = Lines.PurchaseOrderID
			AND Ord.OrderDate = Lines.OrderDate
WHERE Ord.SupplierID = 1 
  AND Ord.OrderDate > '20160101'
  AND Ord.OrderDate < '20170101';


-- на обычной таблице
SELECT 
	Ord.PurchaseOrderID, Ord.OrderDate, Lines.[OrderedOuters], Lines.ExpectedUnitPricePerOuter
FROM Purchasing.[PurchaseOrders] AS Ord
	JOIN Purchasing.[PurchaseOrderLines] AS Lines
		ON Ord.PurchaseOrderID = Lines.PurchaseOrderID
WHERE Ord.SupplierID = 1 
  AND Ord.OrderDate > '20160101'
  AND Ord.OrderDate < '20170101';

-- Сравним:

-- используется нужная секция
SELECT 
	Ord.PurchaseOrderID, Ord.OrderDate, Lines.[OrderedOuters], Lines.ExpectedUnitPricePerOuter
FROM Purchasing.[PurchaseOrdersYears] AS Ord
	JOIN Purchasing.[PurchaseOrderLinesYears] AS Lines
		ON Ord.PurchaseOrderID = Lines.PurchaseOrderID
			AND Ord.OrderDate = Lines.OrderDate
WHERE Ord.OrderDate > '20160101'
  AND Ord.OrderDate < '20170101';

-- на обычной таблице
SELECT 
	Ord.PurchaseOrderID, Ord.OrderDate, Lines.[OrderedOuters], Lines.ExpectedUnitPricePerOuter
FROM Purchasing.[PurchaseOrders] AS Ord
	JOIN Purchasing.[PurchaseOrderLines] AS Lines
		ON Ord.PurchaseOrderID = Lines.PurchaseOrderID
WHERE Ord.OrderDate > '20160101'
  AND Ord.OrderDate < '20170101';

-- На обычной таблице (не смотря на то что есть индекс )
-- план стоимость 13 vs 87, seek vs scan, в первом случае (PurchaseOrderLinesYears 22, PurchaseOrdersYears 5) логических чтений меньше чем во втором (PurchaseOrderLines 158, PurchaseOrders 19 )


SET STATISTICS io, time off;

--6. Возвращаем в исходное стостояние

drop table if exists  Purchasing.[PurchaseOrderLinesYears];
drop table if exists  Purchasing.[PurchaseOrdersYears];
drop PARTITION SCHEME [schmYearPartition];
drop PARTITION FUNCTION [fnYearPartition];
ALTER DATABASE [WideWorldImporters] REMOVE FILE Years;
ALTER DATABASE [WideWorldImporters] REMOVE FILEGROUP [YearData];
  
