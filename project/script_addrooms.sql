USE FitnessClub
GO

INSERT INTO dbo.Room
(
  Number
 ,CategoryId
 ,Description
 ,Floor
)
VALUES
(
  N'002' -- Number - nvarchar(50) NOT NULL
 ,2 -- CategoryId - int NOT NULL
 ,N'Бассейн для взрослых' -- Description - nvarchar(300)
 ,-1 -- Floor - int NOT NULL
);
GO

INSERT INTO dbo.Room
(
  Number
 ,CategoryId
 ,Description
 ,Floor
)
VALUES
(
  N'023'  
 ,3  
 ,N'Детский бассейн'  
 ,-1  
);
GO

INSERT INTO dbo.Room
(
  Number
 ,CategoryId
 ,Description
 ,Floor
)
VALUES
(
  N'003 Б'  
 ,1  
 ,N'Раздевалка для взрослых'  
 ,-1  
);
GO
 

INSERT INTO dbo.Room
(
  Number
 ,CategoryId
 ,Description
 ,Floor
)
VALUES
(
  N'004 М'  
 ,1  
 ,N'Раздевалка для маленьких'  
 ,-1  
);
GO

INSERT INTO dbo.Room
(
  Number
 ,CategoryId
 ,Description
 ,Floor
)
VALUES
(
  N'034'  
 ,14  
 ,N''  
 ,3  
);
GO

INSERT INTO dbo.Room
(
  Number
 ,CategoryId
 ,Description
 ,Floor
)
VALUES
(
  N'035'  
 ,15  
 ,N''  
 ,3  
);
GO

INSERT INTO dbo.Room
(
  Number
 ,CategoryId
 ,Description
 ,Floor
)
VALUES
(
  N'029'  
 ,5  
 ,N''  
 ,2  
);
GO

INSERT INTO dbo.Room
(
  Number
 ,CategoryId
 ,Description
 ,Floor
)
VALUES
(
  N'030'  
 ,5  
 ,N''  
 ,2  
);
GO

INSERT INTO dbo.Room
(
  Number
 ,CategoryId
 ,Description
 ,Floor
)
VALUES
(
  N'031'  
 ,5  
 ,N''  
 ,3  
);
GO


SELECT * FROM dbo.Room