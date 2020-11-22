  
USE [FitnessClub]
GO
 
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE IF EXISTS dbo.AgreementHistory
 
CREATE TABLE dbo.AgreementHistory
(
    [Id] [bigint] NOT NULL,
	[Number] [nvarchar](50) NOT NULL,
	[Date] [date] NOT NULL,
	[PeopleId] [bigint] NOT NULL,
	[TemplateId] [int] NOT NULL,
	[PeriodStart] [date] NOT NULL,
	[PeriodEnd] [date] NULL,
	[Discount] [decimal](6, 2) NOT NULL,
	[Frozen] [bit] NOT NULL,
	[FrozenTerm] [int] NOT NULL,
	[FrozenDate] [date] NULL,
    SysStartTime DATETIME2 NOT NULL,
    SysEndTime DATETIME2 NOT NULL
);
GO

CREATE CLUSTERED COLUMNSTORE INDEX IX_AgreementHistory ON dbo.AgreementHistory;
CREATE NONCLUSTERED INDEX IX_AgreementHistory_ID_PERIOD_COLUMNS  ON dbo.AgreementHistory (SysEndTime, SysStartTime, Id);
GO

ALTER TABLE dbo.Agreement ADD
    SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL  
  , SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL 
  , PERIOD FOR SYSTEM_TIME (SysStartTime,SysEndTime);
GO

ALTER TABLE dbo.Agreement ALTER COLUMN SysStartTime ADD HIDDEN;
ALTER TABLE dbo.Agreement ALTER COLUMN SysEndTime ADD HIDDEN;
GO

ALTER TABLE dbo.Agreement SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.AgreementHistory));
GO
 