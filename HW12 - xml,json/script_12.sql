/*
1. Загрузить данные из файла StockItems.xml в таблицу Warehouse.StockItems.
Существующие записи в таблице обновить, отсутствующие добавить (сопоставлять записи по полю StockItemName).
Файл StockItems.xml в личном кабинете.

2. Выгрузить данные из таблицы StockItems в такой же xml-файл, как StockItems.xml
*/

USE [WideWorldImporters]
GO

/*Данные из таблицы Warehouse.StockItems скопировала в  таблицу Warehouse.StockItems_Copy*/

drop table if exists Warehouse.StockItems_Copy
go

create table Warehouse.StockItems_Copy (
	[StockItemID] [int] NOT NULL CONSTRAINT [DF_Purchasing_Warehouse_StockItems_Copy_StockItemID]  DEFAULT (NEXT VALUE FOR [Sequences].[StockItemID]), 
	[StockItemName] [nvarchar](100) NOT NULL CONSTRAINT [UQ_Warehouse_StockItems_Copy_StockItemName] UNIQUE NONCLUSTERED ,
	[SupplierID] [int] NOT NULL,
	[ColorID] [int] NULL,
	[UnitPackageID] [int] NOT NULL,
	[OuterPackageID] [int] NOT NULL,
	[Brand] [nvarchar](50) NULL,
	[Size] [nvarchar](20) NULL,
	[LeadTimeDays] [int] NOT NULL,
	[QuantityPerOuter] [int] NOT NULL,
	[IsChillerStock] [bit] NOT NULL,
	[Barcode] [nvarchar](50) NULL,
	[TaxRate] [decimal](18, 3) NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[RecommendedRetailPrice] [decimal](18, 2) NULL,
	[TypicalWeightPerUnit] [decimal](18, 3) NOT NULL,
	[MarketingComments] [nvarchar](max) NULL,
	[InternalComments] [nvarchar](max) NULL,
	[Photo] [varbinary](max) NULL,
	[CustomFields] [nvarchar](max) NULL,
	[Tags]  AS (json_query([CustomFields],N'$.Tags')),
	[SearchDetails]  AS (concat([StockItemName],N' ',[MarketingComments])),
	[LastEditedBy] [int] NOT NULL,
	CONSTRAINT [PK_Warehouse_StockItems_Copy_Copy] PRIMARY KEY CLUSTERED ( [StockItemID] ASC ),
	CONSTRAINT [FK_Warehouse_StockItems_Copy_SupplierID_Purchasing_Suppliers] FOREIGN KEY([SupplierID]) REFERENCES [Purchasing].[Suppliers] ([SupplierID]), 
	CONSTRAINT [FK_Warehouse_StockItems_Copy_UnitPackageID_Warehouse_PackageTypes] FOREIGN KEY([UnitPackageID]) REFERENCES [Warehouse].[PackageTypes] ([PackageTypeID]),
	CONSTRAINT [FK_Warehouse_StockItems_Copy_OuterPackageID_Warehouse_PackageTypes] FOREIGN KEY([OuterPackageID]) REFERENCES [Warehouse].[PackageTypes] ([PackageTypeID]),
	CONSTRAINT [FK_Warehouse_StockItems_Copy_ColorID_Warehouse_Colors] FOREIGN KEY([ColorID]) REFERENCES [Warehouse].[Colors] ([ColorID]),
	CONSTRAINT [FK_Warehouse_StockItems_Copy_Application_People] FOREIGN KEY([LastEditedBy]) REFERENCES [Application].[People] ([PersonID])
)
GO

INSERT INTO Warehouse.StockItems_Copy
           ([StockItemID]
           ,[StockItemName]
           ,[SupplierID]
           ,[ColorID]
           ,[UnitPackageID]
           ,[OuterPackageID]
           ,[Brand]
           ,[Size]
           ,[LeadTimeDays]
           ,[QuantityPerOuter]
           ,[IsChillerStock]
           ,[Barcode]
           ,[TaxRate]
           ,[UnitPrice]
           ,[RecommendedRetailPrice]
           ,[TypicalWeightPerUnit]
           ,[MarketingComments]
           ,[InternalComments]
           ,[Photo]
           ,[CustomFields]
           ,[LastEditedBy])
     select [StockItemID]
           ,[StockItemName]
           ,[SupplierID]
           ,[ColorID]
           ,[UnitPackageID]
           ,[OuterPackageID]
           ,[Brand]
           ,[Size]
           ,[LeadTimeDays]
           ,[QuantityPerOuter]
           ,[IsChillerStock]
           ,[Barcode]
           ,[TaxRate]
           ,[UnitPrice]
           ,[RecommendedRetailPrice]
           ,[TypicalWeightPerUnit]
           ,[MarketingComments]
           ,[InternalComments]
           ,[Photo]
           ,[CustomFields]
           ,[LastEditedBy]
  from Warehouse.StockItems
GO
 
/* 1. Загрузить данные из файла StockItems.xml в таблицу Warehouse.StockItems.
Существующие записи в таблице обновить, отсутствующие добавить (сопоставлять записи по полю StockItemName).
Файл StockItems.xml в личном кабинете.*/

DECLARE @hdocid int, @StockItemsXml XML
SET @StockItemsXml = (SELECT * FROM OPENROWSET (BULK 'D:\TEMP\StockItems.xml', SINGLE_BLOB) as data) 

select @StockItemsXml StockItemsImportXml

EXEC sp_xml_preparedocument @hdocid OUTPUT, @StockItemsXml;

MERGE Warehouse.StockItems_Copy t
using (
	SELECT l.*
	FROM OPENXML (@hdocid, N'/StockItems/Item',2)
	WITH (
			StockItemName nvarchar(100) '@Name',
			SupplierID    int 'SupplierID',
			UnitPackageID int 'Package/UnitPackageID',
			OuterPackageID int 'Package/OuterPackageID',
			QuantityPerOuter int 'Package/QuantityPerOuter',
			TypicalWeightPerUnit decimal(18,3) 'Package/TypicalWeightPerUnit',
			LeadTimeDays int 'LeadTimeDays',
			IsChillerStock bit 'IsChillerStock',
			TaxRate decimal(18,3) 'TaxRate',
			UnitPrice decimal(18,2) 'UnitPrice'
         ) l
	-- у нас есть FK, нам нужно отобрать валидные данные
	join [Purchasing].Suppliers sup on l.SupplierID = sup.SupplierID
	join [Warehouse].[PackageTypes] up on l.UnitPackageID = up.PackageTypeID
	join [Warehouse].[PackageTypes] op on l.OuterPackageID = op.PackageTypeID
	) s on s.StockItemName = t.StockItemName
when matched then update set SupplierID = s.SupplierID, 
							 UnitPackageID = s.UnitPackageID, 
							 OuterPackageID = s.OuterPackageID, 
							 QuantityPerOuter = s.QuantityPerOuter, 
							 TypicalWeightPerUnit = s.TypicalWeightPerUnit, 
							 LeadTimeDays = s.LeadTimeDays, 
							 IsChillerStock = s.IsChillerStock, 
							 TaxRate = s.TaxRate, 
							 UnitPrice = s.UnitPrice
when not matched then insert (StockItemName, SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice, LastEditedBy)
                      values (s.StockItemName, s.SupplierID, s.UnitPackageID, s.OuterPackageID, s.QuantityPerOuter, s.TypicalWeightPerUnit, s.LeadTimeDays, s.IsChillerStock, s.TaxRate, s.UnitPrice, 1)
output deleted.*, $action, inserted.*;

EXEC sp_xml_removedocument @hdocid

/*2. Выгрузить данные из таблицы StockItems в такой же xml-файл, как StockItems.xml*/
-- StockItems заменяю на Warehouse.StockItems_Copy

-- To update the currently configured value for advanced options.  
RECONFIGURE;  
GO  
-- To enable the feature.  
EXEC sp_configure 'xp_cmdshell', 1;  
GO  
-- To update the currently configured value for this feature.  
RECONFIGURE;  
GO 

drop table if exists  dbo.ExportXmlFile
go

create table dbo.ExportXmlFile(FileContent xml)
go

begin

    declare @StockItemsExport xml = ( select si.StockItemName    '@Name',
									     si.UnitPackageID        'Package/UnitPackageID',
									     si.OuterPackageID       'Package/OuterPackageID',
									     si.QuantityPerOuter     'Package/QuantityPerOuter',
									     si.TypicalWeightPerUnit 'Package/TypicalWeightPerUnit',
									     si.LeadTimeDays         'LeadTimeDays',
									     si.IsChillerStock       'IsChillerStock',
									     si.TaxRate              'TaxRate',
									     si.UnitPrice            'UnitPrice'
								   from Warehouse.StockItems_Copy si
								  for xml path('Item'), root('StockItems'))
    select @StockItemsExport StockItemsExportXml
    insert into dbo.ExportXmlFile (FileContent) values(convert(varbinary(max), @StockItemsExport))
    declare @ServerName nvarchar(255) = @@SERVERNAME, @Cmd nvarchar(4000);
    set @Cmd = 'bcp "select FileContent from [WideWorldImporters].dbo.ExportXmlFile"  queryout "D:\1\StockItemsExport.xml" -T -w -t -S  '+ @ServerName
	select @Cmd CommandSchell
	exec master..xp_cmdshell @Cmd--, no_output  
end
go

drop table if exists  dbo.ExportXmlFile
go
  
drop table if exists Warehouse.StockItems_Copy
go

/*Сбросить счетчик последовательности [Sequences].[StockItemID]*/ 
BEGIN 
    declare @start_value nvarchar(10)
	SELECT @start_value = cast(start_value  as nvarchar(10)) FROM sys.sequences WHERE [name] = 'StockItemID'
    DECLARE @resetSQL nvarchar(255) = 'ALTER SEQUENCE [Sequences].[StockItemID] RESTART WITH ' + @start_value;

    exec sp_executesql @resetSQL;
end
go
