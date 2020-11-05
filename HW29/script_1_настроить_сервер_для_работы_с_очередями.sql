USE master
GO

-- посмотрим свойства БД через студию
select DATABASEPROPERTYEX ('WideWorldImporters','UserAccess');
SELECT is_broker_enabled FROM sys.databases WHERE name = 'WideWorldImporters';

--переведем БД в однопользовательский режим, отключив остальных (перевод в эксклюзивный режим)
ALTER DATABASE WideWorldImporters SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO

ALTER DATABASE WideWorldImporters SET ENABLE_BROKER;	-- необходимо включить service broker. !Включается он только в эксклюзивном режиме
GO

-- соответственно у пользователя должны быть права на ALTER DATABASE
ALTER DATABASE WideWorldImporters SET TRUSTWORTHY ON; -- и разрешить доверенные подключения
GO

-- посмотрим свойства БД через студию
select DATABASEPROPERTYEX ('WideWorldImporters','UserAccess');
SELECT is_broker_enabled FROM sys.databases WHERE name = 'WideWorldImporters';

ALTER AUTHORIZATION ON DATABASE::WideWorldImporters TO [sa]; -- добавим авторизацию для sa, для доступа с других серверов
GO

--переведем БД в мультипользовательский режим 
ALTER DATABASE WideWorldImporters SET MULTI_USER WITH ROLLBACK IMMEDIATE
GO

-- посмотрим свойства БД через студию
select DATABASEPROPERTYEX ('WideWorldImporters','UserAccess');
SELECT is_broker_enabled FROM sys.databases WHERE name = 'WideWorldImporters';
