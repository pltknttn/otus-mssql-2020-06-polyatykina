USE FitnessClub
GO

INSERT INTO dbo.ServiceCategory
(
  Name
 ,Description
)
VALUES
(
  N'Абонемент' -- Name - nvarchar(150) NOT NULL
 ,N'' -- Description - nvarchar(300)
);
GO 

INSERT INTO dbo.ServiceCategory
(
  Name
 ,Description
)
VALUES
(
  N'Индивидуальные занятия в зале'  
 ,N''  
);
GO 


INSERT INTO dbo.ServiceCategory
(
  Name
 ,Description
)
VALUES
(
  N'Индивидуальные занятия в бассейне'  
 ,N''  
);
GO 

INSERT INTO dbo.ServiceCategory
(
  Name
 ,Description
)
VALUES
(
  N'Групповые занятия в зале'  
 ,N''  
);
GO 

INSERT INTO dbo.ServiceCategory
(
  Name
 ,Description
)
VALUES
(
  N'Фитнес тестирование'  
 ,N''  
);
GO 

SELECT * FROM dbo.ServiceCategory