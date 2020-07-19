/*
Начало проектной работы.
Создание таблиц и представлений для своего проекта.
Если вы не сделали этого раньше, придумайте и сделайте краткое описание проекта, который будете делать в рамках всего курса.

Нужно используя операторы DDL создать:
1. Создать базу данных.
2. 3-4 основные таблицы для своего проекта.
3. Первичные и внешние ключи для всех созданных таблиц.
4. 1-2 индекса на таблицы.
5. Наложите по одному ограничению в каждой таблице на ввод данных.
*/

USE master
go
 
DROP DATABASE IF EXISTS [WAREHOUS]
GO

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

create schema Dictionary
go

/*Виды контрагентов - НАПРИМЕР, ЮРЛИЦО, ФИЗЛИЦО, ИНОСТРАННОЕ*/
create table Dictionary.ContragentType
(
   ContragentTypeId int not null identity(1,1),
   ContragentTypeName varchar(255) not null,
   [Description] varchar(500) not null, 
   CONSTRAINT [PK_Dictionary_ContragentType] PRIMARY KEY CLUSTERED  ( [ContragentTypeId] ASC)
)   
GO

ALTER TABLE Dictionary.ContragentType ADD CONSTRAINT CHK_Dictionary_ContragentType_ContragentTypeName CHECK (trim(ContragentTypeName) != '');
GO

/*Контрагенты*/
create table Dictionary.Contragents
(
  ContragentId int not null identity(1,1),
  ContragentName varchar(255) not null,
  ContragetFullName varchar(500) not null,  
  ContragentTypeId int not null,
  Inn varchar(30), 
  ParentContragentId int,
  CONSTRAINT [PK_Dictionary_Contragents] PRIMARY KEY CLUSTERED  ( [ContragentId] ASC)
)   
GO

ALTER TABLE Dictionary.Contragents ADD CONSTRAINT CHK_Dictionary_Contragents_ContragentName CHECK (trim(ContragentName) != '');
GO

ALTER TABLE Dictionary.Contragents ADD CONSTRAINT CHK_Dictionary_Contragents_ContragetFullName CHECK (trim(ContragetFullName) != '');
GO

ALTER TABLE Dictionary.Contragents ADD CONSTRAINT CHK_Dictionary_Contragents_Inn CHECK (Inn IS NULL OR LEN(Inn)>=10);
GO

ALTER TABLE Dictionary.Contragents ADD CONSTRAINT [FK_Dictionary_Contragents_ContragentTypeId_Dictionary_ContragentType] FOREIGN KEY(ContragentTypeId) REFERENCES Dictionary.ContragentType (ContragentTypeId)
GO

ALTER TABLE Dictionary.Contragents ADD CONSTRAINT [FK_Dictionary_Contragents_ContragentId_Dictionary_Contragents] FOREIGN KEY(ParentContragentId) REFERENCES Dictionary.Contragents (ContragentId)
GO

CREATE NONCLUSTERED INDEX [IX_Dictionary_Contragents_ContragentTypeId] ON [Dictionary].[Contragents] (ContragentTypeId ASC)
GO

/*Реквизиты*/
create table Dictionary.ContragentRequisites
(
	RequisiteId int not null identity(1,1),
	ContragentId int not null,
	BeginDate date not null,
	EndDate   date,
	RegisterDate datetime,	
    Kpp varchar(30),
	JurAddress varchar(1000),
	FactAddress varchar(1000),
	CONSTRAINT [PK_Dictionary_ContragentRequisites] PRIMARY KEY CLUSTERED  ([RequisiteId] ASC))   
GO

ALTER TABLE Dictionary.ContragentRequisites ADD CONSTRAINT CHK_Dictionary_ContragentRequisites_BeginDate_EndDate CHECK (BeginDate >= ISNULL(EndDate, BeginDate));
GO

ALTER TABLE Dictionary.ContragentRequisites ADD CONSTRAINT [FK_Dictionary_ContragentRequisites_ContragentId_Dictionary_Contragents] FOREIGN KEY(ContragentId) REFERENCES Dictionary.Contragents (ContragentId)
GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Dictionary_ContragentRequisites_ContragentId_BeginDate] ON [Dictionary].[ContragentRequisites] (ContragentId ASC,BeginDate ASC)
GO

/*Список свойств*/
create table Dictionary.ContragentProperty
(
 PropertyId int not null identity(1,1),
 PropertyName varchar(255) not null,
 [Description] varchar(500) not null, 
 CONSTRAINT [PK_Dictionary_ContragentProperty] PRIMARY KEY CLUSTERED  ( [PropertyId] ASC)
)   
GO

ALTER TABLE Dictionary.ContragentProperty ADD CONSTRAINT CHK_Dictionary_ContragentProperty_PropertyName CHECK (trim(PropertyName) != '');
GO

/*Значения свойств контрагентов*/
create table Dictionary.ContragentProperties
(
RowId        bigint not null identity(1,1),
ContragentId int not null,
PropertyId   int not null,
ValueInt       int,
ValueDecimal   decimal(20,4),
ValueDatetime  datetime,
ValueVarchar   varchar(max), 
CONSTRAINT [PK_Dictionary_ContragentProperties] PRIMARY KEY CLUSTERED  ( [RowId] ASC)
)   
go

ALTER TABLE Dictionary.ContragentProperties ADD CONSTRAINT [FK_Dictionary_ContragentProperties_ContragentId_Dictionary_Contragents] FOREIGN KEY(ContragentId)
REFERENCES Dictionary.Contragents (ContragentId)
GO

ALTER TABLE Dictionary.ContragentProperties ADD CONSTRAINT [FK_Dictionary_ContragentProperties_PropertyId_Dictionary_ContragentProperty] FOREIGN KEY(PropertyId) REFERENCES Dictionary.ContragentProperty (PropertyId)
GO

CREATE UNIQUE INDEX [UQ_Dictionary_ContragentProperties_PropertyId_ContragentId] ON [Dictionary].[ContragentProperties] (ContragentId, PropertyId)
GO

ALTER TABLE Dictionary.ContragentProperties ADD CONSTRAINT CHK_Dictionary_ContragentProperties_Value CHECK (ValueInt is not null or ValueDecimal is not null or ValueDatetime is not null or ValueVarchar is not null);
GO

