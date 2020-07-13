use [WideWorldImporters]
go

/*SQL SERVER 2019*/

/*--------------------------------------------------------------------------------------------------


2. Выберите товары с минимальной ценой (подзапросом). Сделайте два варианта подзапроса. Вывести: ИД товара, наименование товара, цена.*/
 
select si.StockItemID
     , si.StockItemName
	 , si.UnitPrice
  from [Warehouse].[StockItems] si
where si.UnitPrice = (select min(UnitPrice) from [Warehouse].[StockItems])
 
select si.StockItemID
     , si.StockItemName
	 , si.UnitPrice
  from [Warehouse].[StockItems] si
where si.UnitPrice <= ALL(select UnitPrice from [Warehouse].[StockItems])
 
;with GP as (select min(UnitPrice) MinUnitPrice from [Warehouse].[StockItems])
select si.StockItemID
     , si.StockItemName
	 , si.UnitPrice
  from [Warehouse].[StockItems] si join GP on gp.MinUnitPrice = si.UnitPrice 