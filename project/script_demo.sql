-- категории для людей
SELECT [Id],[Name]
  FROM [FitnessClub].[dbo].[PeopleCategory]

-- Материалы
exec p_SaveMaterialCategory @Id = 0, @Name = 'Косметические средства'
exec p_SaveMaterial @Id = 0, @Name = 'Масло массажное 124354690', @CategoryId = 1, @Price = 250
exec p_SaveMaterialCategory @Id = 0, @Name = 'Средтва гигинены'
exec p_SaveMaterialCategory @Id = 2, @Name = 'Средства гигиены'
exec p_SaveMaterialCategory @Id = 0, @Name = 'Моющие средства'
exec p_SaveMaterial @Id = 0, @Name = 'Мыло', @CategoryId = 6, @Price = 100
select * from MaterialCategory

-- Ограничения\проблемы здоровья
exec p_SaveHealthRestrictionsCategory 0, 'Проблемы спины'
exec p_SaveHealthRestrictionsCategory 0, 'Инвалидность'
exec p_SaveHealthRestrictionsCategory 1, 'Проблемы спины', 'Проблемы спины'
select * from [dbo].[HealthRestrictionsCategory]
exec p_SaveHealthRestriction 0, 'Межпозвоночная грыжа', 1
exec p_SaveHealthRestriction 0, '1-ая группа инвалидности', 2
select * from [dbo].[HealthRestriction]
exec p_SaveClientHealthRestriction 1, '{"HealthRestrictions":[{"Id":1},{"Id":2}]}'
exec p_SaveEmployeeSpecializationByHealthRestriction 1, '{"HealthRestrictions":[{"Id":1},{"Id":2}]}'

-- Сотрудники
 select * from Employee
 exec p_SaveEmployee 0, 1, '{"Peoples":[{"Id":1,"FirstName":"Иван","Patronymic":"Иванович","Surname":"Иванов","DateOfBirth":"1999-01-01","Sex":1,"Address":"Москва, Семеновская 21, дом 18","Email":"iv@mail.ru","Mobilephone":"89110654145","CategoryId":7}]}', 1, '20200102'