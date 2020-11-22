USE FitnessClub
GO

INSERT INTO dbo.Service
(
  Name
 ,CategoryId
 ,Price
 ,Duration
 ,Term
 ,EmployeeDiscount
 ,Quantity
)
VALUES
(
  N'Посещение клуба' -- Name - nvarchar(150) NOT NULL
 ,1 -- CategoryId - int NOT NULL
 ,0 -- Price - decimal(16, 2) NOT NULL
 ,1440 -- Duration - int NOT NULL
 ,365 -- Term - int NOT NULL
 ,0
 ,365
);
GO

INSERT INTO dbo.Service
(
  Name
 ,CategoryId
 ,Price
 ,Duration
 ,Term
 ,EmployeeDiscount
  ,Quantity
)
VALUES
(
  N'Раздевалка' -- Name - nvarchar(150) NOT NULL
 ,1 -- CategoryId - int NOT NULL
 ,0 -- Price - decimal(16, 2) NOT NULL
 ,1440 -- Duration - int NOT NULL
 ,365 -- Term - int NOT NULL
 ,0
  ,365
);
GO

INSERT INTO dbo.Service
(
  Name
 ,CategoryId
 ,Price
 ,Duration
 ,Term
 ,EmployeeDiscount
  ,Quantity
)
VALUES
(
  N'Персональная тренировка в зале с тренером мастером (10 ПТ)' 
 ,2  
 ,18900
 ,60  
 ,45  
 ,0
, 10
);
GO

INSERT INTO dbo.Service
(
  Name
 ,CategoryId
 ,Price
 ,Duration
 ,Term
 ,EmployeeDiscount
  ,Quantity
)
VALUES
(
  N'Персональная тренировка в зале с тренером  (10 ПТ)' 
 ,2  
 ,15900
 ,60  
 ,45  
 ,0
  ,10
);
GO

INSERT INTO dbo.Service
(
  Name
 ,CategoryId
 ,Price
 ,Duration
 ,Term
 ,EmployeeDiscount
  ,Quantity
)
VALUES
(
  N'Персональная тренировка в зале с инструктором  (10 ПТ)' 
 ,2  
 ,20900
 ,60  
 ,45  
 ,0
  ,10
);
GO

INSERT INTO dbo.Service
(
  Name
 ,CategoryId
 ,Price
 ,Duration
 ,Term
 ,EmployeeDiscount
  ,Quantity
)
VALUES
(
  N'Персональная тренировка в зале с тренером мастером (5 ПТ)' 
 ,2  
 ,10900
 ,60  
 ,45  
 ,0
, 5
);
GO

INSERT INTO dbo.Service
(
  Name
 ,CategoryId
 ,Price
 ,Duration
 ,Term
 ,EmployeeDiscount
  ,Quantity
)
VALUES
(
  N'Персональная тренировка в зале с тренером  (5 ПТ)' 
 ,2  
 ,8900
 ,60  
 ,45  
 ,0
  ,5
);
GO

INSERT INTO dbo.Service
(
  Name
 ,CategoryId
 ,Price
 ,Duration
 ,Term
 ,EmployeeDiscount
  ,Quantity
)
VALUES
(
  N'Персональная тренировка в зале с инструктором  (5 ПТ)' 
 ,2  
 ,12900
 ,60  
 ,45  
 ,0
 ,5
);
GO

INSERT INTO dbo.Service
(
  Name
 ,CategoryId
 ,Price
 ,Duration
 ,Term
 ,EmployeeDiscount
  ,Quantity
)
VALUES
(
  N'Персональная тренировка в зале с тренером мастером (15 ПТ)' 
 ,2  
 ,23900
 ,60  
 ,45  
 ,0
, 10
);
GO

INSERT INTO dbo.Service
(
  Name
 ,CategoryId
 ,Price
 ,Duration
 ,Term
 ,EmployeeDiscount
  ,Quantity
)
VALUES
(
  N'Персональная тренировка в зале с тренером  (15 ПТ)' 
 ,2  
 ,20900
 ,60  
 ,45  
 ,0
  ,10
);
GO

INSERT INTO dbo.Service
(
  Name
 ,CategoryId
 ,Price
 ,Duration
 ,Term
 ,EmployeeDiscount
  ,Quantity
)
VALUES
(
  N'Персональная тренировка в зале с инструктором  (15 ПТ)' 
 ,2  
 ,25900
 ,60  
 ,45  
 ,0
  ,10
);
GO

SELECT * FROM dbo.Service