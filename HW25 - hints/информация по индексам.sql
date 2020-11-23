use WideWorldImporters
go

SELECT OBJECT_NAME(a.OBJECT_ID) Tabela, b.name, 
      leaf_insert_count, leaf_delete_count, leaf_update_count,
	  b.type_desc 
FROM sys.dm_db_index_operational_stats(DB_ID(), OBJECT_ID('Sales.Invoices'),-1, NULL) AS a
INNER JOIN sys.indexes b ON a.OBJECT_ID = b.OBJECT_ID
AND a.index_id = b.index_id


SELECT OBJECT_NAME(a.OBJECT_ID) Tabela, b.name, 
      leaf_insert_count, leaf_delete_count, leaf_update_count,
	  b.type_desc, b.index_id  
FROM sys.dm_db_index_operational_stats(DB_ID(), OBJECT_ID('Sales.Orders'),-1, NULL) AS a
INNER JOIN sys.indexes b ON a.OBJECT_ID = b.OBJECT_ID
AND a.index_id = b.index_id


select * from sysindexes where id = OBJECT_ID('Sales.Invoices') order by rowmodctr --rowmodctr сколько изменений было внесено в столбец или таблицу с момента последнего обновления статистики

select * from sysindexes where id = OBJECT_ID('Sales.Orders') order by rowmodctr 