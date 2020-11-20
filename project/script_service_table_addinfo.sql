USE FitnessClub
GO


INSERT INTO dbo.PeopleCategory
(
  Name
)
VALUES
(
  N'Обычный клиент'  
);
GO 

INSERT INTO dbo.PeopleCategory
(
  Name
)
VALUES
(
  N'Корпоративный клиент'  
);
GO 

INSERT INTO dbo.PeopleCategory
(
  Name
)
VALUES
(
  N'Сотрудник'  
);
GO 
INSERT INTO dbo.PeopleCategory
(
  Name
)
VALUES
(
  N'Социальный клиент'  
);
GO

SELECT * FROM dbo.PeopleCategory
 
GO

INSERT INTO dbo.Sex
(
  Name
 ,ShortName
)
VALUES
(
  N'Female'  
 ,N'Ж' 
);
GO

INSERT INTO dbo.Sex
(
  Name
 ,ShortName
)
VALUES
(
  N'Man' 
 ,N'М'  
);
GO

SELECT * FROM dbo.Sex
GO
 

INSERT INTO dbo.RoomCategory
(
  Name
)
VALUES
(
  N'Тренерская комната'
);
GO

INSERT INTO dbo.RoomCategory
(
  Name
)
VALUES
(
  N'Взрослый бассейн'
);
GO

INSERT INTO dbo.RoomCategory
(
  Name
)
VALUES
(
  N'Детский бассейн'
);
GO

INSERT INTO dbo.RoomCategory
(
  Name
)
VALUES
(
  N'Массажный кабинет'
);
GO

INSERT INTO dbo.RoomCategory
(
  Name
)
VALUES
(
  N'Тренажерный зал'
);
GO

INSERT INTO dbo.RoomCategory
(
  Name
)
VALUES
(
  N'Сауна, баня, хаммам'
);
GO

INSERT INTO dbo.RoomCategory
(
  Name
)
VALUES
(
  N'Зал для танцев'
);
GO

INSERT INTO dbo.RoomCategory
(
  Name
)
VALUES
(
  N'Детская комната'
);
GO

INSERT INTO dbo.RoomCategory
(
  Name
)
VALUES
(
  N'Косметический кабинет'
);
GO

INSERT INTO dbo.RoomCategory
(
  Name
)
VALUES
(
  N'Раздевалка'
);
GO


INSERT INTO dbo.RoomCategory
(
  Name
)
VALUES
(
  N'Служебное помещение'
);
GO

INSERT INTO dbo.RoomCategory
(
  Name
)
VALUES
(
  N'Медицинский кабинет'
);
GO

INSERT INTO dbo.RoomCategory
(
  Name
)
VALUES
(
  N'Дополнительные услуги'
);
GO

INSERT INTO dbo.RoomCategory
(
  Name
)
VALUES
(
  N'Раздевалка мужская'
);
GO

INSERT INTO dbo.RoomCategory
(
  Name
)
VALUES
(
  N'Раздевалка женская'
);
GO

SELECT * FROM dbo.RoomCategory
GO

USE FitnessClub
GO

INSERT INTO dbo.StorageType
(
  Name
)
VALUES
(
  N'Шкаф'  
);
GO

INSERT INTO dbo.StorageType
(
  Name
)
VALUES
(
  N'Ячейка'  
);
GO

SELECT * FROM StorageType st
GO

