USE FitnessClub
GO
 
INSERT INTO [dbo].[Organization]
           ([Name]
           ,[Inn]
           ,[Kpp]
           ,[Address])
     VALUES
           ('ООО АвтоТо'
           ,'4560069698'
           ,null
           ,'Москва, ул Павлова, дом 78')
GO 

INSERT INTO [dbo].[Organization]
           ([Name]
           ,[Inn]
           ,[Kpp]
           ,[Address])
     VALUES
           ('ООО Ромашка'
           ,'6560069698'
           ,null
           ,'Москва, ул Шевченоко, дом 78')
GO




INSERT INTO dbo.AgreementTemplate
(
  Name
 ,StartDate
 ,EndDate
 ,Discount
 ,PeopleCategoryId
)
VALUES
(
  N'Клиенты 2019'  
 ,'20190101'
 ,'20191231'
 ,0
 , 1
);
GO

INSERT INTO dbo.AgreementTemplate
(
  Name
 ,StartDate 
 ,Discount
  ,PeopleCategoryId
)
VALUES
(
  N'Клиенты 2020'  
 ,'20200101' 
 ,0
  ,1
);
GO

INSERT INTO dbo.AgreementTemplate
(
  Name
 ,StartDate
 ,EndDate
 ,Discount
  ,PeopleCategoryId
  ,OrganizationId
)
VALUES
(
  N'Корпоративный 2020-2024 (ООО АвтоТо, ИНН 4560069698)'  
 ,'20200101'
 ,'20241231'
 ,2
  ,2
  ,1
);
GO

INSERT INTO dbo.AgreementTemplate
(
  Name
 ,StartDate
 ,EndDate
 ,Discount
  ,PeopleCategoryId 
  ,OrganizationId
)
VALUES
(
  N'Корпоративный 2020-2022 (ООО Ромашка, ИНН 6560069698)'  
 ,'20200101'
 ,'20221231'
 ,5
  ,2
  ,2
);
GO
 

INSERT INTO dbo.AgreementTemplate
(
  Name
 ,StartDate 
 ,Discount
  ,PeopleCategoryId
)
VALUES
(
  N'Сотрудник'  
 ,'20200101' 
 ,15
  ,2
);
GO

INSERT INTO dbo.AgreementTemplate
(
  Name
 ,StartDate
 ,EndDate
 ,Discount
  ,PeopleCategoryId
)
VALUES
(
  N'Сотрудник 2019'  
 ,'20190101' 
  ,'20191231'
 ,15
  ,2
);
GO