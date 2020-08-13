/*3. В таблице Warehouse.StockItems в колонке CustomFields есть данные в JSON.
Написать SELECT для вывода:
- StockItemID
- StockItemName
- CountryOfManufacture (из CustomFields)
- FirstTag (из поля CustomFields, первое значение из массива Tags)*/

USE [WideWorldImporters]
GO

select   
       si.StockItemID,
       si.StockItemName, 
	   js.CountryOfManufacture, 
	   js.FirstTag
  from Warehouse.StockItems si
  cross apply OPENJSON(si.CustomFields) 
 WITH (
    CountryOfManufacture	nvarchar(200) '$.CountryOfManufacture', 
    FirstTag    nvarchar(max)   		  '$.Tags[0]')  js  

/*
4. Найти в StockItems строки, где есть тэг "Vintage".
Вывести:
- StockItemID
- StockItemName
- (опционально) все теги (из CustomFields) через запятую в одном поле

Тэги искать в поле CustomFields, а не в Tags.
Запрос написать через функции работы с JSON.
Для поиска использовать равенство, использовать LIKE запрещено.

Должно быть в таком виде:
... where ... = 'Vintage'

Так принято не будет:
... where ... Tags like '%Vintage%'
... where ... CustomFields like '%Vintage%'
*/

select   
       si.StockItemID, 
       si.StockItemName, 
	   string_agg(cf.[key], N', ') AllField 
  from Warehouse.StockItems si
  cross apply OPENJSON(si.CustomFields, N'$') cf
  cross apply OPENJSON(si.CustomFields, N'$.Tags') js 
  where js.value = N'Vintage'
group by StockItemID, StockItemName 

select   
       si.StockItemID, 
       si.StockItemName, 
	   string_agg(cf.[key], N', ') AllField,
	   js.AllTags
  from Warehouse.StockItems si
  cross apply OPENJSON(si.CustomFields, N'$') cf
  cross apply (select string_agg(js.[value], N', ') AllTags, 
                      max(case when js.value = N'Vintage' then 1 else 0 end) ExistsVintage
				 from OPENJSON(si.CustomFields, N'$.Tags') js 
			   ) js
  where js.ExistsVintage = 1
group by StockItemID, StockItemName, js.AllTags