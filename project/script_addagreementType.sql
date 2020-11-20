USE FitnessClub
GO

INSERT INTO dbo.AgreementType
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
 ,'20200101'
 ,0
 , 1
);
GO

INSERT INTO dbo.AgreementType
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

INSERT INTO dbo.AgreementType
(
  Name
 ,StartDate
 ,EndDate
 ,Discount
  ,PeopleCategoryId
)
VALUES
(
  N'Корпоративный 2020-2024 (ООО АвтоТо, ИНН 4560069698)'  
 ,'20200101'
 ,'20241231'
 ,2
  ,2
);
GO

INSERT INTO dbo.AgreementType
(
  Name
 ,StartDate
 ,EndDate
 ,Discount
  ,PeopleCategoryId
)
VALUES
(
  N'Корпоративный 2020-2022 (ООО Ромашка, ИНН 6560069698)'  
 ,'20200101'
 ,'20221231'
 ,5
  ,2
);
GO
 

INSERT INTO dbo.AgreementType
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