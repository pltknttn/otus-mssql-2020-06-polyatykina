use WideWorldImporters;
GO

--1. Создать файловую группу и файл (опционально)

--создадим файловую группу
ALTER DATABASE [WideWorldImporters] ADD FILEGROUP [PriceData]
GO
 
--добавляем файл БД
ALTER DATABASE [WideWorldImporters] ADD FILE ( NAME = N'Prices', FILENAME = N'D:\Working\Database\SQL Server\Pricedata.ndf' , 
SIZE = 1097152KB , FILEGROWTH = 65536KB ) TO FILEGROUP [PriceData]
GO

--2. Выбрать ключ секционирования
-- Цена 
SELECT min(UnitPrice), avg(UnitPrice), MAX(UnitPrice)  FROM Sales.OrderLines

--3. Создать схему и функцию партиционирования

--создаем функцию партиционирования по годам   
CREATE PARTITION FUNCTION [fnPricePartition](decimal(18,2)) AS RANGE RIGHT FOR VALUES
( 50, 100, 200, 400, 500, 800, 1000, 1200, 1600, 1700, 1800);																																																									
GO 

-- партиционируем, используя созданную нами функцию
CREATE PARTITION SCHEME [schmPricePartition] AS PARTITION [fnPricePartition]  ALL TO ([PriceData])
GO

--3. Создать партиционированные таблицы и кластерные индексы в той же схеме с тем же ключом

drop table if exists [Sales].[OrderLinesPrices]; 

--создадим партиционированную таблицу
CREATE TABLE [Sales].[OrderLinesPrices](
	[OrderLineID] [int] NOT NULL,
	[OrderID] [int] NOT NULL,
	[StockItemID] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[PackageTypeID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL DEFAULT(0),
	[TaxRate] [decimal](18, 3) NOT NULL,
	[PickedQuantity] [int] NOT NULL,
	[PickingCompletedWhen] [datetime2](7) NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL,
) ON [schmPricePartition]([UnitPrice])---в схеме [[schmPricePartition]] по ключу [UnitPrice]
GO

--создадим кластерный индекс в той же схеме с тем же ключом
ALTER TABLE [Sales].[OrderLinesPrices] ADD CONSTRAINT [PK_Sales_OrderLinesPrices]
PRIMARY KEY CLUSTERED  (UnitPrice, OrderLineID)
 ON [schmPricePartition]([UnitPrice]);
  
 -- 4. Заливка данных 

 --truncate table [Sales].[OrderLinesPrices]
 insert into [Sales].[OrderLinesPrices](
            [OrderLineID]
           ,[OrderID]
           ,[StockItemID]
           ,[Description]
           ,[PackageTypeID]
           ,[Quantity]
           ,[UnitPrice]
           ,[TaxRate]
           ,[PickedQuantity]
           ,[PickingCompletedWhen]
           ,[LastEditedBy]
           ,[LastEditedWhen])
 select     [OrderLineID]
           ,[OrderID]
           ,[StockItemID]
           ,[Description]
           ,[PackageTypeID]
           ,[Quantity]
           ,[UnitPrice] 
           ,[TaxRate]
           ,[PickedQuantity]
           ,[PickingCompletedWhen]
           ,[LastEditedBy]
           ,[LastEditedWhen] 
  from [Sales].[OrderLines] 
  WHERE UnitPrice > 0
   
-- разбивка
SELECT  $PARTITION.fnPricePartition([UnitPrice]) AS Partition
		, COUNT(*) AS [COUNT]
		, MIN([UnitPrice])
		,MAX([UnitPrice]) 
FROM [Sales].[OrderLinesPrices]
GROUP BY $PARTITION.fnPricePartition([UnitPrice])
ORDER BY Partition ;  

  -- 5. Запросы   
SELECT distinct Ord.OrderID 
FROM [Sales].[OrderLinesPrices] AS Ord
WHERE Ord.UnitPrice > 102 AND Ord.UnitPrice < 345

SELECT distinct Ord.OrderID 
FROM [Sales].[OrderLinesPrices] AS Ord
WHERE Ord.UnitPrice < 400

SELECT distinct Ord.OrderID 
FROM [Sales].[OrderLinesPrices] AS Ord
WHERE Ord.UnitPrice > 800 

--6. Возвращаем в исходное стостояние

drop table if exists  [Sales].[OrderLinesPrices]; 
drop PARTITION SCHEME [schmPricePartition];
drop PARTITION FUNCTION [fnPricePartition];
ALTER DATABASE [WideWorldImporters] REMOVE FILE Prices;
ALTER DATABASE [WideWorldImporters] REMOVE FILEGROUP [PriceData];
  
