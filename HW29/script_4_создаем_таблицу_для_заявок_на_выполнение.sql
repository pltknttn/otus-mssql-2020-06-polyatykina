--добавим в таблицу, в которую будем писать изменения из очереди
use WideWorldImporters;
 
-- пример ошибки, если не включить авторизацию для SA
--An exception occurred while enqueueing a message in the target queue. Error: 33009, State: 2. 
--The database owner SID recorded in the master database differs from the database owner SID recorded in database 'WideWorldImporters'. 
--You should correct this situation by resetting the owner of database 'WideWorldImporters' using the ALTER AUTHORIZATION statement.

DROP TABLE IF EXISTS Application.BrokerTask 
go

DROP TABLE IF EXISTS Application.BrokerTaskType
go

DROP TABLE IF EXISTS Application.BrokerTaskStatus
go

create table Application.BrokerTaskType
(
   Id int not null identity(1,1),
   Name nvarchar(255),
   CONSTRAINT [PK_Application_BrokerTaskType] PRIMARY KEY CLUSTERED (Id ASC)
)
go

insert into Application.BrokerTaskType(Name) values('Отчет: кол-во заказов по клиентам за период')
go

create table Application.BrokerTaskStatus
(
   Id int not null identity(1,1),
   Name nvarchar(255),
   CONSTRAINT [PK_Application_BrokerTaskStatus] PRIMARY KEY CLUSTERED (Id ASC)
)

insert into Application.BrokerTaskStatus(Name) values('Новая задача')
go

insert into Application.BrokerTaskStatus(Name) values('Задача передана в обработку')
go

insert into Application.BrokerTaskStatus(Name) values('Задача получена на обработку')
go

insert into Application.BrokerTaskStatus(Name) values('Задача обработана')
go

insert into Application.BrokerTaskStatus(Name) values('Задача выполнена')
go

create table Application.BrokerTask
(
	Id bigint not null identity(1,1),
	TaskTypeId int not null,
	RequestDate datetime2(7) not null default(GETUTCDATE()),
	Request nvarchar(max),
	ReplyDate datetime2(7),
	Reply nvarchar(max),
	TaskStatusId int not null default(1),
	TaskStatusChangedDate datetime2(7) not null default(GETUTCDATE()),
	CONSTRAINT [PK_Application_BrokerTask] PRIMARY KEY CLUSTERED (Id ASC)
)
go

ALTER TABLE Application.BrokerTask  WITH CHECK ADD  CONSTRAINT [FK_Application_BrokerTask_BrokerTaskType] FOREIGN KEY(TaskTypeId)
REFERENCES Application.BrokerTaskType ([Id])
GO

ALTER TABLE Application.BrokerTask  WITH CHECK ADD  CONSTRAINT [FK_Application_BrokerTask_BrokerTaskStatus] FOREIGN KEY(TaskStatusId)
REFERENCES Application.BrokerTaskStatus ([Id])
GO