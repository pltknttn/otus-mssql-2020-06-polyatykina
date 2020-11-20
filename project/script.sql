USE master
GO


EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'FitnessClub'
GO

USE master
GO

DROP DATABASE IF EXISTS FitnessClub
GO

IF DB_ID('FitnessClub') IS NULL
  CREATE DATABASE FitnessClub
  ON PRIMARY (
  NAME = N'FitnessClub',
  FILENAME = N'D:\Working\Database\SQL Server\FitnessClub.mdf',
  SIZE = 8192 KB,
  MAXSIZE = UNLIMITED,
  FILEGROWTH = 65536 KB
  )
  LOG ON (
  NAME = N'FitnessClub_log',
  FILENAME = N'D:\Working\Database\SQL Server\FitnessClub.ldf',
  SIZE = 8192 KB,
  MAXSIZE = 52428800 KB,
  FILEGROWTH = 65536 KB
  )
GO

ALTER DATABASE FitnessClub
SET
ANSI_NULL_DEFAULT OFF,
ANSI_NULLS OFF,
ANSI_PADDING OFF,
ANSI_WARNINGS OFF,
ARITHABORT OFF,
AUTO_CLOSE OFF,
AUTO_CREATE_STATISTICS ON,
AUTO_SHRINK OFF,
AUTO_UPDATE_STATISTICS ON,
AUTO_UPDATE_STATISTICS_ASYNC OFF,
COMPATIBILITY_LEVEL = 150,
CONCAT_NULL_YIELDS_NULL OFF,
CURSOR_CLOSE_ON_COMMIT OFF,
CURSOR_DEFAULT GLOBAL,
DATE_CORRELATION_OPTIMIZATION OFF,
DB_CHAINING OFF,
HONOR_BROKER_PRIORITY OFF,
MULTI_USER,
NESTED_TRIGGERS = ON,
NUMERIC_ROUNDABORT OFF,
PAGE_VERIFY CHECKSUM,
PARAMETERIZATION SIMPLE,
QUOTED_IDENTIFIER OFF,
READ_COMMITTED_SNAPSHOT OFF,
RECOVERY FULL,
RECURSIVE_TRIGGERS OFF,
TRANSFORM_NOISE_WORDS = OFF,
TRUSTWORTHY OFF
WITH ROLLBACK IMMEDIATE
GO

ALTER DATABASE FitnessClub
COLLATE Cyrillic_General_CI_AS
GO

ALTER DATABASE FitnessClub
SET ENABLE_BROKER
GO

ALTER DATABASE FitnessClub
SET ALLOW_SNAPSHOT_ISOLATION OFF
GO

ALTER DATABASE FitnessClub
SET FILESTREAM (NON_TRANSACTED_ACCESS = OFF)
GO

ALTER DATABASE FitnessClub
SET QUERY_STORE = OFF
GO

USE FitnessClub
GO

ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO

ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO

ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO

ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO

ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO

ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO

ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO

ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
 

USE FitnessClub
GO

IF DB_NAME() <> N'FitnessClub' SET NOEXEC ON
GO

--
-- Create table [dbo].[StorageType]
--
PRINT (N'Create table [dbo].[StorageType]')
GO
CREATE TABLE dbo.StorageType (
  Id int IDENTITY,
  Name nvarchar(150) NOT NULL,
  CONSTRAINT PK_StorageType_Id PRIMARY KEY CLUSTERED (Id),
  CONSTRAINT UQ_StorageType_Name UNIQUE (Name)
)
ON [PRIMARY]
GO

--
-- Create table [dbo].[Sex]
--
PRINT (N'Create table [dbo].[Sex]')
GO
CREATE TABLE dbo.Sex (
  Id smallint IDENTITY,
  Name nvarchar(10) NOT NULL,
  ShortName nvarchar(5) NOT NULL,
  CONSTRAINT PK_Sex_Id PRIMARY KEY CLUSTERED (Id),
  CONSTRAINT UQ_Sex_Name UNIQUE (Name)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [dbo].[Sex]
--
PRINT (N'Add extended property [MS_Description] on table [dbo].[Sex]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Пол', 'SCHEMA', N'dbo', 'TABLE', N'Sex'
GO

--
-- Create table [dbo].[ServiceCategory]
--
PRINT (N'Create table [dbo].[ServiceCategory]')
GO
CREATE TABLE dbo.ServiceCategory (
  Id int IDENTITY,
  Name nvarchar(150) NOT NULL,
  Description nvarchar(300) NULL,
  CONSTRAINT PK_ServiceCategory_Id PRIMARY KEY CLUSTERED (Id),
  CONSTRAINT UQ_ServiceCategory_Name UNIQUE (Name)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [dbo].[ServiceCategory]
--
PRINT (N'Add extended property [MS_Description] on table [dbo].[ServiceCategory]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Категории услуг', 'SCHEMA', N'dbo', 'TABLE', N'ServiceCategory'
GO

--
-- Create table [dbo].[Service]
--
PRINT (N'Create table [dbo].[Service]')
GO
CREATE TABLE dbo.Service (
  Id bigint IDENTITY,
  Name nvarchar(150) NOT NULL,
  CategoryId int NOT NULL,
  Price decimal(16, 2) NOT NULL,
  Duration int NOT NULL,
  Term int NOT NULL,
  EmployeeDiscount decimal(5, 2) NOT NULL DEFAULT (0),
  Quantity int NOT NULL DEFAULT (0),
  CanRestore bit NOT NULL DEFAULT (0),
  CONSTRAINT PK_Service_Id PRIMARY KEY CLUSTERED (Id),
  CONSTRAINT UQ_Service_Name_CategoryId UNIQUE (Name, CategoryId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Service_CategoryId] on table [dbo].[Service]
--
PRINT (N'Create foreign key [FK_Service_CategoryId] on table [dbo].[Service]')
GO
ALTER TABLE dbo.Service
  ADD CONSTRAINT FK_Service_CategoryId FOREIGN KEY (CategoryId) REFERENCES dbo.ServiceCategory (Id)
GO

--
-- Add extended property [MS_Description] on table [dbo].[Service]
--
PRINT (N'Add extended property [MS_Description] on table [dbo].[Service]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Услуги', 'SCHEMA', N'dbo', 'TABLE', N'Service'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Service].[Name]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Service].[Name]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Название', 'SCHEMA', N'dbo', 'TABLE', N'Service', 'COLUMN', N'Name'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Service].[CategoryId]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Service].[CategoryId]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Категория услуг', 'SCHEMA', N'dbo', 'TABLE', N'Service', 'COLUMN', N'CategoryId'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Service].[Price]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Service].[Price]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Цена', 'SCHEMA', N'dbo', 'TABLE', N'Service', 'COLUMN', N'Price'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Service].[Duration]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Service].[Duration]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Длительность одной услуги', 'SCHEMA', N'dbo', 'TABLE', N'Service', 'COLUMN', N'Duration'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Service].[Term]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Service].[Term]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Срок действия', 'SCHEMA', N'dbo', 'TABLE', N'Service', 'COLUMN', N'Term'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Service].[EmployeeDiscount]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Service].[EmployeeDiscount]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Размер скидки для сотрудников', 'SCHEMA', N'dbo', 'TABLE', N'Service', 'COLUMN', N'EmployeeDiscount'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Service].[Quantity]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Service].[Quantity]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Количество услуг в пакете', 'SCHEMA', N'dbo', 'TABLE', N'Service', 'COLUMN', N'Quantity'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Service].[CanRestore]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Service].[CanRestore]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Можно восстановить', 'SCHEMA', N'dbo', 'TABLE', N'Service', 'COLUMN', N'CanRestore'
GO

--
-- Create table [dbo].[RoomCategory]
--
PRINT (N'Create table [dbo].[RoomCategory]')
GO
CREATE TABLE dbo.RoomCategory (
  Id int IDENTITY,
  Name nvarchar(150) NOT NULL,
  CONSTRAINT PK_RoomCategory_Id PRIMARY KEY CLUSTERED (Id),
  CONSTRAINT UQ_RoomCategory_Name UNIQUE (Name)
)
ON [PRIMARY]
GO

--
-- Create table [dbo].[Room]
--
PRINT (N'Create table [dbo].[Room]')
GO
CREATE TABLE dbo.Room (
  Id int IDENTITY,
  Number nvarchar(50) NOT NULL,
  CategoryId int NOT NULL,
  Description nvarchar(300) NULL,
  Floor int NOT NULL,
  CONSTRAINT PK_Room_Id PRIMARY KEY CLUSTERED (Id),
  CONSTRAINT UQ_Room_Number_Floor UNIQUE (Number, Floor)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Room_CategoryId] on table [dbo].[Room]
--
PRINT (N'Create foreign key [FK_Room_CategoryId] on table [dbo].[Room]')
GO
ALTER TABLE dbo.Room
  ADD CONSTRAINT FK_Room_CategoryId FOREIGN KEY (CategoryId) REFERENCES dbo.RoomCategory (Id)
GO

--
-- Create table [dbo].[Storage]
--
PRINT (N'Create table [dbo].[Storage]')
GO
CREATE TABLE dbo.Storage (
  Id int IDENTITY,
  Number nvarchar(50) NOT NULL,
  RoomId int NOT NULL,
  TypeId int NOT NULL,
  CONSTRAINT PK_Storage_Id PRIMARY KEY CLUSTERED (Id),
  CONSTRAINT UQ_Storage_Number_RoomId UNIQUE (Number, RoomId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Storage_RoomId] on table [dbo].[Storage]
--
PRINT (N'Create foreign key [FK_Storage_RoomId] on table [dbo].[Storage]')
GO
ALTER TABLE dbo.Storage
  ADD CONSTRAINT FK_Storage_RoomId FOREIGN KEY (RoomId) REFERENCES dbo.Room (Id)
GO

--
-- Create foreign key [FK_Storage_TypeId] on table [dbo].[Storage]
--
PRINT (N'Create foreign key [FK_Storage_TypeId] on table [dbo].[Storage]')
GO
ALTER TABLE dbo.Storage
  ADD CONSTRAINT FK_Storage_TypeId FOREIGN KEY (TypeId) REFERENCES dbo.StorageType (Id)
GO

--
-- Create table [dbo].[PeopleCategory]
--
PRINT (N'Create table [dbo].[PeopleCategory]')
GO
CREATE TABLE dbo.PeopleCategory (
  Id int IDENTITY,
  Name nvarchar(255) NOT NULL,
  CONSTRAINT PK_PeopleCategory_Id PRIMARY KEY CLUSTERED (Id)
)
ON [PRIMARY]
GO

--
-- Create table [dbo].[Organization]
--
PRINT (N'Create table [dbo].[Organization]')
GO
CREATE TABLE dbo.Organization (
  Id bigint IDENTITY,
  Name nvarchar(255) NOT NULL,
  Inn nvarchar(12) NOT NULL,
  Kpp nvarchar(10) NULL,
  Address nvarchar(300) NOT NULL,
  CONSTRAINT PK_Organization_Id PRIMARY KEY CLUSTERED (Id)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [dbo].[Organization]
--
PRINT (N'Add extended property [MS_Description] on table [dbo].[Organization]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Организации', 'SCHEMA', N'dbo', 'TABLE', N'Organization'
GO

--
-- Create table [dbo].[People]
--
PRINT (N'Create table [dbo].[People]')
GO
CREATE TABLE dbo.People (
  Id bigint IDENTITY,
  FirstName nvarchar(150) NOT NULL,
  Patronymic nvarchar(150) NOT NULL,
  Surname nvarchar(250) NOT NULL,
  DateOfBirth date NOT NULL,
  Sex smallint NOT NULL,
  Address nvarchar(500) NOT NULL,
  Email nvarchar(255) NOT NULL,
  Mobilephone nvarchar(20) NOT NULL,
  Photo varbinary(max) NULL,
  CategoryId int NOT NULL,
  OrganizationId bigint NULL,
  CONSTRAINT PK_People_Id PRIMARY KEY CLUSTERED (Id),
  CONSTRAINT UQ_People_Mobilephone UNIQUE (Mobilephone)
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

--
-- Create foreign key [FK_People_CategoryId] on table [dbo].[People]
--
PRINT (N'Create foreign key [FK_People_CategoryId] on table [dbo].[People]')
GO
ALTER TABLE dbo.People
  ADD CONSTRAINT FK_People_CategoryId FOREIGN KEY (CategoryId) REFERENCES dbo.PeopleCategory (Id)
GO

--
-- Create foreign key [FK_People_OrganizationId] on table [dbo].[People]
--
PRINT (N'Create foreign key [FK_People_OrganizationId] on table [dbo].[People]')
GO
ALTER TABLE dbo.People
  ADD CONSTRAINT FK_People_OrganizationId FOREIGN KEY (OrganizationId) REFERENCES dbo.Organization (Id)
GO

--
-- Create foreign key [FK_People_Sex] on table [dbo].[People]
--
PRINT (N'Create foreign key [FK_People_Sex] on table [dbo].[People]')
GO
ALTER TABLE dbo.People
  ADD CONSTRAINT FK_People_Sex FOREIGN KEY (Sex) REFERENCES dbo.Sex (Id)
GO

--
-- Create table [dbo].[Visit]
--
PRINT (N'Create table [dbo].[Visit]')
GO
CREATE TABLE dbo.Visit (
  Id bigint IDENTITY,
  Date date NOT NULL,
  ServiceId bigint NOT NULL,
  ClientId bigint NOT NULL,
  EmployeeId bigint NULL,
  VisitStart time NOT NULL,
  VisitEnd time NULL,
  StoragelId int NULL,
  CONSTRAINT PK_Visit_Id PRIMARY KEY CLUSTERED (Id)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Visit_ClientId] on table [dbo].[Visit]
--
PRINT (N'Create foreign key [FK_Visit_ClientId] on table [dbo].[Visit]')
GO
ALTER TABLE dbo.Visit
  ADD CONSTRAINT FK_Visit_ClientId FOREIGN KEY (ClientId) REFERENCES dbo.People (Id)
GO

--
-- Create foreign key [FK_Visit_EmployeeId] on table [dbo].[Visit]
--
PRINT (N'Create foreign key [FK_Visit_EmployeeId] on table [dbo].[Visit]')
GO
ALTER TABLE dbo.Visit
  ADD CONSTRAINT FK_Visit_EmployeeId FOREIGN KEY (EmployeeId) REFERENCES dbo.People (Id)
GO

--
-- Create foreign key [FK_Visit_ServiceId] on table [dbo].[Visit]
--
PRINT (N'Create foreign key [FK_Visit_ServiceId] on table [dbo].[Visit]')
GO
ALTER TABLE dbo.Visit
  ADD CONSTRAINT FK_Visit_ServiceId FOREIGN KEY (ServiceId) REFERENCES dbo.Service (Id)
GO

--
-- Create foreign key [FK_Visit_StoragelId] on table [dbo].[Visit]
--
PRINT (N'Create foreign key [FK_Visit_StoragelId] on table [dbo].[Visit]')
GO
ALTER TABLE dbo.Visit
  ADD CONSTRAINT FK_Visit_StoragelId FOREIGN KEY (StoragelId) REFERENCES dbo.Storage (Id)
GO

--
-- Create table [dbo].[Shedule]
--
PRINT (N'Create table [dbo].[Shedule]')
GO
CREATE TABLE dbo.Shedule (
  Id bigint IDENTITY,
  ServiceId bigint NOT NULL,
  EmployeeId bigint NOT NULL,
  RoomId int NOT NULL,
  Date date NOT NULL,
  StartTime time NOT NULL,
  EndTime time NOT NULL,
  ClientId bigint NULL
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Shedule_ClientId] on table [dbo].[Shedule]
--
PRINT (N'Create foreign key [FK_Shedule_ClientId] on table [dbo].[Shedule]')
GO
ALTER TABLE dbo.Shedule
  ADD CONSTRAINT FK_Shedule_ClientId FOREIGN KEY (ClientId) REFERENCES dbo.People (Id)
GO

--
-- Create foreign key [FK_Shedule_EmployeeId] on table [dbo].[Shedule]
--
PRINT (N'Create foreign key [FK_Shedule_EmployeeId] on table [dbo].[Shedule]')
GO
ALTER TABLE dbo.Shedule
  ADD CONSTRAINT FK_Shedule_EmployeeId FOREIGN KEY (EmployeeId) REFERENCES dbo.People (Id)
GO

--
-- Create foreign key [FK_Shedule_RoomId] on table [dbo].[Shedule]
--
PRINT (N'Create foreign key [FK_Shedule_RoomId] on table [dbo].[Shedule]')
GO
ALTER TABLE dbo.Shedule
  ADD CONSTRAINT FK_Shedule_RoomId FOREIGN KEY (RoomId) REFERENCES dbo.Room (Id)
GO

--
-- Create foreign key [FK_Shedule_ServiceId] on table [dbo].[Shedule]
--
PRINT (N'Create foreign key [FK_Shedule_ServiceId] on table [dbo].[Shedule]')
GO
ALTER TABLE dbo.Shedule
  ADD CONSTRAINT FK_Shedule_ServiceId FOREIGN KEY (ServiceId) REFERENCES dbo.Service (Id)
GO

--
-- Create table [dbo].[PurchaseService]
--
PRINT (N'Create table [dbo].[PurchaseService]')
GO
CREATE TABLE dbo.PurchaseService (
  Id bigint IDENTITY,
  Date date NOT NULL,
  PeopleId bigint NOT NULL,
  SeviceId bigint NOT NULL,
  Pait bit NOT NULL CONSTRAINT DF_PurchaseService_PaitSum DEFAULT (0),
  PaitSum decimal(16, 2) NOT NULL,
  Discount decimal(16, 2) NOT NULL CONSTRAINT DF_PurchaseService_Discout DEFAULT (0),
  EmployeeId bigint NULL,
  AddDate datetime2 NOT NULL CONSTRAINT DF_PurchaseService_AddDate DEFAULT (getdate()),
  PaitDate datetime2 NULL,
  DateStart date NOT NULL DEFAULT (getdate()),
  DateEnd date NULL,
  CONSTRAINT PK_PurchaseService_Id PRIMARY KEY CLUSTERED (Id)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_PurchaseService_EmployeeId] on table [dbo].[PurchaseService]
--
PRINT (N'Create foreign key [FK_PurchaseService_EmployeeId] on table [dbo].[PurchaseService]')
GO
ALTER TABLE dbo.PurchaseService
  ADD CONSTRAINT FK_PurchaseService_EmployeeId FOREIGN KEY (EmployeeId) REFERENCES dbo.People (Id)
GO

--
-- Create foreign key [FK_PurchaseService_PeopleId] on table [dbo].[PurchaseService]
--
PRINT (N'Create foreign key [FK_PurchaseService_PeopleId] on table [dbo].[PurchaseService]')
GO
ALTER TABLE dbo.PurchaseService
  ADD CONSTRAINT FK_PurchaseService_PeopleId FOREIGN KEY (PeopleId) REFERENCES dbo.People (Id)
GO

--
-- Create foreign key [FK_PurchaseService_SeviceId] on table [dbo].[PurchaseService]
--
PRINT (N'Create foreign key [FK_PurchaseService_SeviceId] on table [dbo].[PurchaseService]')
GO
ALTER TABLE dbo.PurchaseService
  ADD CONSTRAINT FK_PurchaseService_SeviceId FOREIGN KEY (SeviceId) REFERENCES dbo.Service (Id)
GO

--
-- Create table [dbo].[EmployeeService]
--
PRINT (N'Create table [dbo].[EmployeeService]')
GO
CREATE TABLE dbo.EmployeeService (
  EmployeeId bigint NOT NULL,
  ServiceId bigint NOT NULL,
  CONSTRAINT PK_EmployeeService PRIMARY KEY CLUSTERED (EmployeeId, ServiceId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_EmployeeService_EmployeeId] on table [dbo].[EmployeeService]
--
PRINT (N'Create foreign key [FK_EmployeeService_EmployeeId] on table [dbo].[EmployeeService]')
GO
ALTER TABLE dbo.EmployeeService
  ADD CONSTRAINT FK_EmployeeService_EmployeeId FOREIGN KEY (EmployeeId) REFERENCES dbo.People (Id)
GO

--
-- Create foreign key [FK_EmployeeService_ServiceId] on table [dbo].[EmployeeService]
--
PRINT (N'Create foreign key [FK_EmployeeService_ServiceId] on table [dbo].[EmployeeService]')
GO
ALTER TABLE dbo.EmployeeService
  ADD CONSTRAINT FK_EmployeeService_ServiceId FOREIGN KEY (ServiceId) REFERENCES dbo.Service (Id)
GO

--
-- Add extended property [MS_Description] on table [dbo].[EmployeeService]
--
PRINT (N'Add extended property [MS_Description] on table [dbo].[EmployeeService]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Услуги сотрудников', 'SCHEMA', N'dbo', 'TABLE', N'EmployeeService'
GO

--
-- Create table [dbo].[Card]
--
PRINT (N'Create table [dbo].[Card]')
GO
CREATE TABLE dbo.Card (
  Id bigint IDENTITY,
  Number nvarchar(50) NOT NULL,
  PeopleId bigint NOT NULL,
  DateStart date NOT NULL,
  DateEnd date NOT NULL,
  CONSTRAINT PK_Card_Id PRIMARY KEY CLUSTERED (Id),
  CONSTRAINT UQ_Card_Number UNIQUE (Number)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Card_PeopleId] on table [dbo].[Card]
--
PRINT (N'Create foreign key [FK_Card_PeopleId] on table [dbo].[Card]')
GO
ALTER TABLE dbo.Card
  ADD CONSTRAINT FK_Card_PeopleId FOREIGN KEY (PeopleId) REFERENCES dbo.People (Id)
GO

--
-- Create table [dbo].[AgreementTemplate]
--
PRINT (N'Create table [dbo].[AgreementTemplate]')
GO
CREATE TABLE dbo.AgreementTemplate (
  Id int IDENTITY,
  Name nvarchar(150) NOT NULL,
  StartDate date NOT NULL,
  EndDate date NULL,
  Discount decimal(5, 2) NOT NULL CONSTRAINT DF_AgreementTemplate_Discount DEFAULT (0),
  PeopleCategoryId int NOT NULL,
  OrganizationId bigint NULL,
  CanFrozen bit NOT NULL DEFAULT (1),
  FrozenTerm int NOT NULL DEFAULT (0),
  CONSTRAINT PK_AgreementTemplate_Id PRIMARY KEY CLUSTERED (Id),
  CONSTRAINT UQ_AgreementTemplate_Name UNIQUE (Name)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_AgreementTemplate_OrganizationId] on table [dbo].[AgreementTemplate]
--
PRINT (N'Create foreign key [FK_AgreementTemplate_OrganizationId] on table [dbo].[AgreementTemplate]')
GO
ALTER TABLE dbo.AgreementTemplate
  ADD CONSTRAINT FK_AgreementTemplate_OrganizationId FOREIGN KEY (OrganizationId) REFERENCES dbo.Organization (Id)
GO

--
-- Create foreign key [FK_AgreementTemplate_PeopleCategoryId] on table [dbo].[AgreementTemplate]
--
PRINT (N'Create foreign key [FK_AgreementTemplate_PeopleCategoryId] on table [dbo].[AgreementTemplate]')
GO
ALTER TABLE dbo.AgreementTemplate
  ADD CONSTRAINT FK_AgreementTemplate_PeopleCategoryId FOREIGN KEY (PeopleCategoryId) REFERENCES dbo.PeopleCategory (Id)
GO

--
-- Add extended property [MS_Description] on table [dbo].[AgreementTemplate]
--
PRINT (N'Add extended property [MS_Description] on table [dbo].[AgreementTemplate]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Шаблоны договоров', 'SCHEMA', N'dbo', 'TABLE', N'AgreementTemplate'
GO

--
-- Add extended property [MS_Description] on column [dbo].[AgreementTemplate].[Name]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[AgreementTemplate].[Name]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Название', 'SCHEMA', N'dbo', 'TABLE', N'AgreementTemplate', 'COLUMN', N'Name'
GO

--
-- Add extended property [MS_Description] on column [dbo].[AgreementTemplate].[PeopleCategoryId]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[AgreementTemplate].[PeopleCategoryId]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Категория людей, которой доступен вид договора', 'SCHEMA', N'dbo', 'TABLE', N'AgreementTemplate', 'COLUMN', N'PeopleCategoryId'
GO

--
-- Create table [dbo].[AgreementTemplateService]
--
PRINT (N'Create table [dbo].[AgreementTemplateService]')
GO
CREATE TABLE dbo.AgreementTemplateService (
  AgreementTemplateId int NOT NULL,
  ServiceId bigint NOT NULL,
  Quantity int NOT NULL,
  Duration int NOT NULL,
  CONSTRAINT PK_AgreementTemplateService PRIMARY KEY CLUSTERED (AgreementTemplateId, ServiceId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_AgreementTemplateService_AgreementTemplateId] on table [dbo].[AgreementTemplateService]
--
PRINT (N'Create foreign key [FK_AgreementTemplateService_AgreementTemplateId] on table [dbo].[AgreementTemplateService]')
GO
ALTER TABLE dbo.AgreementTemplateService
  ADD CONSTRAINT FK_AgreementTemplateService_AgreementTemplateId FOREIGN KEY (AgreementTemplateId) REFERENCES dbo.AgreementTemplate (Id)
GO

--
-- Create foreign key [FK_AgreementTemplateService_ServiceId] on table [dbo].[AgreementTemplateService]
--
PRINT (N'Create foreign key [FK_AgreementTemplateService_ServiceId] on table [dbo].[AgreementTemplateService]')
GO
ALTER TABLE dbo.AgreementTemplateService
  ADD CONSTRAINT FK_AgreementTemplateService_ServiceId FOREIGN KEY (ServiceId) REFERENCES dbo.Service (Id)
GO

--
-- Create table [dbo].[Agreement]
--
PRINT (N'Create table [dbo].[Agreement]')
GO
CREATE TABLE dbo.Agreement (
  Id bigint IDENTITY,
  Number nvarchar(50) NOT NULL,
  Date date NOT NULL,
  PeopleId bigint NOT NULL,
  TemplateId int NOT NULL,
  PeriodStart date NOT NULL,
  PeriodEnd date NULL,
  Discount decimal(6, 2) NOT NULL CONSTRAINT DF_Agreement_Discount DEFAULT (0),
  Frozen bit NOT NULL CONSTRAINT DF_Agreement_Blocked DEFAULT (0),
  FrozenTerm int NOT NULL DEFAULT (0),
  CONSTRAINT PK_Agreement_Id PRIMARY KEY CLUSTERED (Id)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Agreement_PeopleId] on table [dbo].[Agreement]
--
PRINT (N'Create foreign key [FK_Agreement_PeopleId] on table [dbo].[Agreement]')
GO
ALTER TABLE dbo.Agreement
  ADD CONSTRAINT FK_Agreement_PeopleId FOREIGN KEY (PeopleId) REFERENCES dbo.People (Id)
GO

--
-- Create foreign key [FK_Agreement_TemplateId] on table [dbo].[Agreement]
--
PRINT (N'Create foreign key [FK_Agreement_TemplateId] on table [dbo].[Agreement]')
GO
ALTER TABLE dbo.Agreement
  ADD CONSTRAINT FK_Agreement_TemplateId FOREIGN KEY (TemplateId) REFERENCES dbo.AgreementTemplate (Id)
GO

--
-- Add extended property [MS_Description] on table [dbo].[Agreement]
--
PRINT (N'Add extended property [MS_Description] on table [dbo].[Agreement]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Договора', 'SCHEMA', N'dbo', 'TABLE', N'Agreement'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Agreement].[Number]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Agreement].[Number]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Номер договора', 'SCHEMA', N'dbo', 'TABLE', N'Agreement', 'COLUMN', N'Number'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Agreement].[Date]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Agreement].[Date]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Дата договора', 'SCHEMA', N'dbo', 'TABLE', N'Agreement', 'COLUMN', N'Date'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Agreement].[PeopleId]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Agreement].[PeopleId]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Владелец (на кого оформлен)', 'SCHEMA', N'dbo', 'TABLE', N'Agreement', 'COLUMN', N'PeopleId'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Agreement].[PeriodStart]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Agreement].[PeriodStart]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Период действия (с)', 'SCHEMA', N'dbo', 'TABLE', N'Agreement', 'COLUMN', N'PeriodStart'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Agreement].[PeriodEnd]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Agreement].[PeriodEnd]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Период действия (по)', 'SCHEMA', N'dbo', 'TABLE', N'Agreement', 'COLUMN', N'PeriodEnd'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Agreement].[Discount]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Agreement].[Discount]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Скидка на период действия по договору', 'SCHEMA', N'dbo', 'TABLE', N'Agreement', 'COLUMN', N'Discount'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Agreement].[Frozen]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Agreement].[Frozen]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Заморожен', 'SCHEMA', N'dbo', 'TABLE', N'Agreement', 'COLUMN', N'Frozen'
GO

--
-- Create table [dbo].[MaterialCategory]
--
PRINT (N'Create table [dbo].[MaterialCategory]')
GO
CREATE TABLE dbo.MaterialCategory (
  Id int IDENTITY,
  Name nvarchar(150) NOT NULL,
  CONSTRAINT PK_MaterialCategory_Id PRIMARY KEY CLUSTERED (Id),
  CONSTRAINT UQ_MaterialCategory_Name UNIQUE (Name)
)
ON [PRIMARY]
GO

--
-- Create table [dbo].[Material]
--
PRINT (N'Create table [dbo].[Material]')
GO
CREATE TABLE dbo.Material (
  Id int IDENTITY,
  Name nvarchar(150) NOT NULL,
  CategoryId int NOT NULL,
  Price decimal(16, 2) NOT NULL,
  Description nvarchar(300) NULL,
  CONSTRAINT PK_Material_Id PRIMARY KEY CLUSTERED (Id),
  CONSTRAINT UQ_Material_Name_CategoryId UNIQUE (Name, CategoryId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Material_CategoryId] on table [dbo].[Material]
--
PRINT (N'Create foreign key [FK_Material_CategoryId] on table [dbo].[Material]')
GO
ALTER TABLE dbo.Material
  ADD CONSTRAINT FK_Material_CategoryId FOREIGN KEY (CategoryId) REFERENCES dbo.MaterialCategory (Id)
GO

--
-- Create table [dbo].[PurchaseMaterial]
--
PRINT (N'Create table [dbo].[PurchaseMaterial]')
GO
CREATE TABLE dbo.PurchaseMaterial (
  PurchaseId bigint NOT NULL,
  MaterialId int NOT NULL,
  Quantity int NOT NULL DEFAULT (1),
  Price decimal(16, 2) NOT NULL,
  CONSTRAINT PK_PurchaseMaterial PRIMARY KEY CLUSTERED (PurchaseId, MaterialId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_PurchaseMaterial_MaterialId] on table [dbo].[PurchaseMaterial]
--
PRINT (N'Create foreign key [FK_PurchaseMaterial_MaterialId] on table [dbo].[PurchaseMaterial]')
GO
ALTER TABLE dbo.PurchaseMaterial
  ADD CONSTRAINT FK_PurchaseMaterial_MaterialId FOREIGN KEY (MaterialId) REFERENCES dbo.Material (Id)
GO

--
-- Create foreign key [FK_PurchaseMaterial_PurchaseId] on table [dbo].[PurchaseMaterial]
--
PRINT (N'Create foreign key [FK_PurchaseMaterial_PurchaseId] on table [dbo].[PurchaseMaterial]')
GO
ALTER TABLE dbo.PurchaseMaterial
  ADD CONSTRAINT FK_PurchaseMaterial_PurchaseId FOREIGN KEY (PurchaseId) REFERENCES dbo.PurchaseService (Id)
GO

--
-- Create table [dbo].[CheckOperation]
--
PRINT (N'Create table [dbo].[CheckOperation]')
GO
CREATE TABLE dbo.CheckOperation (
  Id bigint NOT NULL,
  PurchaseId bigint NOT NULL,
  Quantity int NOT NULL DEFAULT (0),
  Duration int NOT NULL DEFAULT (0),
  CheckDate datetime2 NOT NULL DEFAULT (getdate()),
  MaterialId int NULL,
  VisitId bigint NULL,
  CONSTRAINT PK_CheckOperation_Id PRIMARY KEY CLUSTERED (Id)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_CheckOperation_MaterialId] on table [dbo].[CheckOperation]
--
PRINT (N'Create foreign key [FK_CheckOperation_MaterialId] on table [dbo].[CheckOperation]')
GO
ALTER TABLE dbo.CheckOperation
  ADD CONSTRAINT FK_CheckOperation_MaterialId FOREIGN KEY (MaterialId) REFERENCES dbo.Material (Id)
GO

--
-- Create foreign key [FK_CheckOperation_PurchaseId] on table [dbo].[CheckOperation]
--
PRINT (N'Create foreign key [FK_CheckOperation_PurchaseId] on table [dbo].[CheckOperation]')
GO
ALTER TABLE dbo.CheckOperation
  ADD CONSTRAINT FK_CheckOperation_PurchaseId FOREIGN KEY (PurchaseId) REFERENCES dbo.PurchaseService (Id)
GO

--
-- Create foreign key [FK_CheckOperation_VisitId] on table [dbo].[CheckOperation]
--
PRINT (N'Create foreign key [FK_CheckOperation_VisitId] on table [dbo].[CheckOperation]')
GO
ALTER TABLE dbo.CheckOperation
  ADD CONSTRAINT FK_CheckOperation_VisitId FOREIGN KEY (VisitId) REFERENCES dbo.Visit (Id)
GO

--
-- Create table [dbo].[HealthRestrictionsCategory]
--
PRINT (N'Create table [dbo].[HealthRestrictionsCategory]')
GO
CREATE TABLE dbo.HealthRestrictionsCategory (
  Id int IDENTITY,
  Name nvarchar(150) NOT NULL,
  Description nvarchar(300) NULL,
  CONSTRAINT PK_HealthRestrictionsCategory_Id PRIMARY KEY CLUSTERED (Id),
  CONSTRAINT UQ_HealthRestrictionsCategory_Name UNIQUE (Name)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [dbo].[HealthRestrictionsCategory]
--
PRINT (N'Add extended property [MS_Description] on table [dbo].[HealthRestrictionsCategory]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Категория ограничений по здоровью', 'SCHEMA', N'dbo', 'TABLE', N'HealthRestrictionsCategory'
GO

--
-- Create table [dbo].[HealthRestriction]
--
PRINT (N'Create table [dbo].[HealthRestriction]')
GO
CREATE TABLE dbo.HealthRestriction (
  Id int IDENTITY,
  Name nvarchar(150) NOT NULL,
  CategoryId int NOT NULL,
  Description nvarchar(300) NULL,
  CONSTRAINT PK_HealthRestriction_Id PRIMARY KEY CLUSTERED (Id)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_HealthRestrictions_CategoryId] on table [dbo].[HealthRestriction]
--
PRINT (N'Create foreign key [FK_HealthRestrictions_CategoryId] on table [dbo].[HealthRestriction]')
GO
ALTER TABLE dbo.HealthRestriction
  ADD CONSTRAINT FK_HealthRestrictions_CategoryId FOREIGN KEY (CategoryId) REFERENCES dbo.HealthRestrictionsCategory (Id)
GO

--
-- Add extended property [MS_Description] on table [dbo].[HealthRestriction]
--
PRINT (N'Add extended property [MS_Description] on table [dbo].[HealthRestriction]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Ограничения по здоровью', 'SCHEMA', N'dbo', 'TABLE', N'HealthRestriction'
GO

--
-- Create table [dbo].[ClientHealthRestriction]
--
PRINT (N'Create table [dbo].[ClientHealthRestriction]')
GO
CREATE TABLE dbo.ClientHealthRestriction (
  ClientId bigint NOT NULL,
  [HealthRestrictionId ] int NOT NULL,
  CONSTRAINT [PK_ClientHealthRestriction ] PRIMARY KEY CLUSTERED (ClientId, [HealthRestrictionId ])
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_ClientHealthRestriction_ClientId] on table [dbo].[ClientHealthRestriction]
--
PRINT (N'Create foreign key [FK_ClientHealthRestriction_ClientId] on table [dbo].[ClientHealthRestriction]')
GO
ALTER TABLE dbo.ClientHealthRestriction
  ADD CONSTRAINT FK_ClientHealthRestriction_ClientId FOREIGN KEY (ClientId) REFERENCES dbo.People (Id)
GO

--
-- Create foreign key [FK_ClientHealthRestriction_HealthRestrictionId ] on table [dbo].[ClientHealthRestriction]
--
PRINT (N'Create foreign key [FK_ClientHealthRestriction_HealthRestrictionId ] on table [dbo].[ClientHealthRestriction]')
GO
ALTER TABLE dbo.ClientHealthRestriction
  ADD CONSTRAINT [FK_ClientHealthRestriction_HealthRestrictionId ] FOREIGN KEY ([HealthRestrictionId ]) REFERENCES dbo.HealthRestriction (Id)
GO

--
-- Add extended property [MS_Description] on table [dbo].[ClientHealthRestriction]
--
PRINT (N'Add extended property [MS_Description] on table [dbo].[ClientHealthRestriction]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Ограничения по здоровью клиента', 'SCHEMA', N'dbo', 'TABLE', N'ClientHealthRestriction'
GO

--
-- Create table [dbo].[EmployeeSpeciality]
--
PRINT (N'Create table [dbo].[EmployeeSpeciality]')
GO
CREATE TABLE dbo.EmployeeSpeciality (
  Id int IDENTITY,
  Name nvarchar(255) NOT NULL,
  Description nvarchar(300) NULL,
  CONSTRAINT PK_EmployeeSpeciality_Id PRIMARY KEY CLUSTERED (Id),
  CONSTRAINT UQ_EmployeeSpeciality_Name UNIQUE (Name)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [dbo].[EmployeeSpeciality]
--
PRINT (N'Add extended property [MS_Description] on table [dbo].[EmployeeSpeciality]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Специальности сотрудников', 'SCHEMA', N'dbo', 'TABLE', N'EmployeeSpeciality'
GO

--
-- Create table [dbo].[EmployeeCategory]
--
PRINT (N'Create table [dbo].[EmployeeCategory]')
GO
CREATE TABLE dbo.EmployeeCategory (
  Id int IDENTITY,
  Name nvarchar(255) NOT NULL,
  Description nvarchar(300) NULL,
  CONSTRAINT PK_EmployeeCategory_Id PRIMARY KEY CLUSTERED (Id),
  CONSTRAINT UQ_EmployeeCategory_Name UNIQUE (Name)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on table [dbo].[EmployeeCategory]
--
PRINT (N'Add extended property [MS_Description] on table [dbo].[EmployeeCategory]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Категории сотрудников', 'SCHEMA', N'dbo', 'TABLE', N'EmployeeCategory'
GO

--
-- Create table [dbo].[Employee]
--
PRINT (N'Create table [dbo].[Employee]')
GO
CREATE TABLE dbo.Employee (
  Id bigint IDENTITY,
  SpecialityId int NOT NULL,
  CategoryId int NOT NULL,
  PeopleId bigint NOT NULL,
  WorkStart date NOT NULL,
  WorkEnd date NULL,
  CONSTRAINT PK_Employee_Id PRIMARY KEY CLUSTERED (Id)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Employee_CategoryId] on table [dbo].[Employee]
--
PRINT (N'Create foreign key [FK_Employee_CategoryId] on table [dbo].[Employee]')
GO
ALTER TABLE dbo.Employee
  ADD CONSTRAINT FK_Employee_CategoryId FOREIGN KEY (CategoryId) REFERENCES dbo.EmployeeCategory (Id)
GO

--
-- Create foreign key [FK_Employee_PeopleId] on table [dbo].[Employee]
--
PRINT (N'Create foreign key [FK_Employee_PeopleId] on table [dbo].[Employee]')
GO
ALTER TABLE dbo.Employee
  ADD CONSTRAINT FK_Employee_PeopleId FOREIGN KEY (PeopleId) REFERENCES dbo.People (Id)
GO

--
-- Create foreign key [FK_Employee_SpecialityId] on table [dbo].[Employee]
--
PRINT (N'Create foreign key [FK_Employee_SpecialityId] on table [dbo].[Employee]')
GO
ALTER TABLE dbo.Employee
  ADD CONSTRAINT FK_Employee_SpecialityId FOREIGN KEY (SpecialityId) REFERENCES dbo.EmployeeSpeciality (Id)
GO

--
-- Create table [dbo].[EmployeeSpecializationByHealthRestriction]
--
PRINT (N'Create table [dbo].[EmployeeSpecializationByHealthRestriction]')
GO
CREATE TABLE dbo.EmployeeSpecializationByHealthRestriction (
  EmployeeId bigint NOT NULL,
  HealthRestrictionId int NOT NULL,
  CONSTRAINT PK_EmployeeSpecializationByHealthRestriction PRIMARY KEY CLUSTERED (EmployeeId, HealthRestrictionId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_EmployeeSpecializationByHealthRestriction_EmployeeId] on table [dbo].[EmployeeSpecializationByHealthRestriction]
--
PRINT (N'Create foreign key [FK_EmployeeSpecializationByHealthRestriction_EmployeeId] on table [dbo].[EmployeeSpecializationByHealthRestriction]')
GO
ALTER TABLE dbo.EmployeeSpecializationByHealthRestriction
  ADD CONSTRAINT FK_EmployeeSpecializationByHealthRestriction_EmployeeId FOREIGN KEY (EmployeeId) REFERENCES dbo.Employee (Id)
GO

--
-- Create foreign key [FK_EmployeeSpecializationByHealthRestriction_HealthRestrictionId] on table [dbo].[EmployeeSpecializationByHealthRestriction]
--
PRINT (N'Create foreign key [FK_EmployeeSpecializationByHealthRestriction_HealthRestrictionId] on table [dbo].[EmployeeSpecializationByHealthRestriction]')
GO
ALTER TABLE dbo.EmployeeSpecializationByHealthRestriction
  ADD CONSTRAINT FK_EmployeeSpecializationByHealthRestriction_HealthRestrictionId FOREIGN KEY (HealthRestrictionId) REFERENCES dbo.HealthRestriction (Id)
GO

--
-- Add extended property [MS_Description] on table [dbo].[EmployeeSpecializationByHealthRestriction]
--
PRINT (N'Add extended property [MS_Description] on table [dbo].[EmployeeSpecializationByHealthRestriction]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', 'Специализация сотрудников по ограничениям здоровья', 'SCHEMA', N'dbo', 'TABLE', N'EmployeeSpecializationByHealthRestriction'
GO