1. выполняю запрос с установленными SET STATISTICS IO, TIME, XML ON;
смотрю статистику, обращаю внимание сколько логических чтений

выделяю таблицу Sales.Invoices

2. открываю полученный план запроса, смотрю как оптимизатор строит соединение по этой таблице и какие индексы

отмечаю что поиск по FK_Sales_Invoices_OrderID, считано 70510 строк,
 индекс не охватывает все данные (index scan), которые используются в запросе и остальные считываются переборобом (key lookup),
далее вижу что для перебора значений по таблице Sales.Invoices был выбран nested loops

3. Скорее всего из-за того, что бы получить все значения для дальнейшей фильтрации по данным из таблицы Sales.Invoices требуется перебор значений (key lookup), 
оптимизатор sql считает оптимальнее использовать nested loops отсюда и большое количество логических чтений по таблице (Table 'Invoices'. Scan count 1, logical reads 44411)

4. Поиски оптимизации

варианты оптимизации 
- добавить индекс, который бы покрывал весь требуемый выходной набор и поиск

create nonclustered index IX_Sales_Invoices_OrderId_CustomerId_BillToCustomerId on Sales.Invoices (OrderId, CustomerID, BillToCustomerId) include (InvoiceId, InvoiceDate)

- поиграть с hint

Начну с них.

- добавить указание какое соединение использовать
  добавим hash 

план меняется, используется PK_Sales_Invoices, логических чтений по таблице меньше (Table 'Invoices'. Scan count 7, logical reads 8300)

- проверяю последовательность с которой выполняется соединение по таблица
  добавляю force order, убираю hash 

  план и статистика почти схожи

хинты добавляют параллелизм, добавим maxdop 1

Получаем 
Table 'Orders'. Scan count 2, logical reads 822
Table 'Invoices'. Scan count 1, logical reads 7888

оптимизация без hint

Прежде чем добавить индекс пробую поиграть с запросом
самой частой проблемой запроса оказывается большой объем выборки, поэтому
убираю поиск клиентов, которые купили на более чем 250000, убираю в цте, вычислим раз и будем использовать в where
обращаю внимание на Warehouse.StockItems, перебирем по StockItemID, оставляем только по определенному постащику
на самом деле выходит что весь запрос строится в разрезе товаров одного поставщика и можно перенести в часть from

проверяю что получилось

используется PK_Sales_Invoices, логических чтений по таблице меньше (Table 'Invoices'. Scan count 1, logical reads 7888)

сравниваю старый запрос и новый, планы различаются (ожидаемо), оптимизированный запрос чуть быстрее, стоимость 50%

добавляю индекс IX_Sales_Invoices_OrderId_CustomerId_BillToCustomerId 

сравниваю запросы

индекс повлиял как на базовый запрос (тот что оптимизируем) и на оптимизированный запрос,
Table 'Orders'. Scan count 2, logical reads 822
Table 'Invoices'. Scan count 1, logical reads 223

оптимизированный запрос значительно быстрее
базовый (стоимисть 73%)
 SQL Server Execution Times:
   CPU time = 391 ms,  elapsed time = 600 ms.,

оптизируемый (стоимость 27%)
SQL Server Execution Times:
   CPU time = 218 ms,  elapsed time = 393 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

проверяем использование индекса - есть IX_Sales_Invoices_OrderId_CustomerId_BillToCustomerId

Сравнивая планы запросов в оптимизированном отмечаю - FK_Warehouse_StockItems_SupplierID, то что убрала из where коррелированный подзапрос правильно

Цель достигнута - запрос оптимизирован


  


