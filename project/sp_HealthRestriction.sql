use FitnessClub
go

create or alter procedure p_SaveHealthRestrictionsCategory
@Id int,
@Name nvarchar(150),
@Description nvarchar(300) = null
as
declare @msg nvarchar(255)
begin
     set @Id = isnull(@Id,0) 

	 if exists(select * from HealthRestrictionsCategory where Name = @Name and Id <> @Id)
	 begin 
	     set @msg = 'Категория "'+@Name+'" уже существует!';
	     raiserror(@msg,16,1)
		 return (-1)
	 end

    ;merge HealthRestrictionsCategory t
	 using (select @Id Id,
	               @Name Name,
				   @Description Description
	       ) s on s.Id = t.Id
    when matched then update set Name = s.Name, Description = s.Description 
	when not matched then insert (Name, Description) values(s.Name, s.Description);
	return (0)
end
go

create or alter procedure p_DeleteHealthRestrictionsCategory @Id int
as
begin
     if exists(select * from HealthRestriction where CategoryId = @Id)
	 begin 
	     raiserror('По категории добавлены сведения по ограничениям\проблемам здоровья!',16,1)
		 return (-1)
	 end 

	 delete from HealthRestrictionsCategory where Id = @Id
end
go

create or alter procedure p_SaveHealthRestriction
@Id int = 0,
@Name nvarchar(150),
@CategoryId int, 
@Description  nvarchar(300) = null
as
declare @msg nvarchar(255) 
begin      
     if @CategoryId is null or not exists(select * from HealthRestrictionsCategory where Id = @CategoryId)
	 begin 
	     raiserror('Категория не существует!',16,1)
		 return (-1)
	 end
	 
	 set @Id = isnull(@Id,0) 

	 if @Id <> 0 and not exists(select * from HealthRestriction where Id = @Id)
	 begin 
	     raiserror('Данное ограничение\проблема здоровья не существует!',16,1)
		 return (-1)
	 end

	 if exists(select * from HealthRestriction where Name = @Name and CategoryId = @CategoryId and Id <> @Id)
	 begin 
	     set @msg = 'Ограничение\проблема здоровья "'+@Name+'" уже существует!';
	     raiserror(@msg,16,1)
		 return (-1)
	 end

     ;merge HealthRestriction t
	 using (select 
	              @Id Id,
	              @Name Name,
				  @CategoryId  CategoryId, 
				  @Description Description
	       ) s on s.Id = t.Id
    when matched then update set Name = s.Name, CategoryId = s.CategoryId, Description = s.Description
	when not matched then insert (Name, CategoryId, Description) values(s.Name, s.CategoryId, s.Description);
	return (0)
end
go 
create or alter procedure p_DeleteHealthRestriction @Id int
as
begin
     if exists(select * from [dbo].[EmployeeSpecializationByHealthRestriction] where HealthRestrictionId = @Id) 
	 begin 
	     raiserror('Нельзя удалить! Есть сотрудники, которые специализируются по данному ограничению',16,1)
		 return (-1)
	 end
	 if exists(select * from [dbo].[ClientHealthRestriction] where HealthRestrictionId = @Id)
	 begin 
	     raiserror('Нельзя удалить! Есть клиенты с данным ограничением',16,1)
		 return (-1)
	 end

	 delete from HealthRestriction where Id = @Id
end
go

create or alter procedure p_SaveClientHealthRestriction
@ClientId bigint,
@HealthRestriction nvarchar(max)
as
declare @msg nvarchar(255)
      , @tranopen bit = 0
begin try    
    select @HealthRestriction = ISNULL(@HealthRestriction,''), @ClientId = isnull(@ClientId,0)
    if @HealthRestriction > '' AND ISJSON(@HealthRestriction) = 0 
	begin 
	     raiserror('Ошибка в параметре "@HealthRestriction"',16,1)
		 return (-1)
	end

	if not exists (select * from People where Id = @ClientId)
	begin 
	     raiserror('Клиент не существует',16,1)
		 return (-1)
	end
	        	
	declare @ClientHealthRestriction table (HealthRestrictionId int not null primary key, IsDelete bit not null default(1))
	
	if @HealthRestriction > ''
	begin
	     --select Id from [dbo].[HealthRestriction] FOR JSON PATH, ROOT('HealthRestrictions')
	     insert into @ClientHealthRestriction (HealthRestrictionId, IsDelete) 
		 SELECT distinct cast(value as int) Id, 0 IsDelete FROM OPENJSON(@HealthRestriction, '$.Id')
    end

	insert into @ClientHealthRestriction (HealthRestrictionId)
	select HealthRestrictionId from ClientHealthRestriction where ClientId = @ClientId
	except
	select HealthRestrictionId from @ClientHealthRestriction

	if (select count(*) from @ClientHealthRestriction ) = 0 return (0)

	if @@TRANCOUNT = 0  
	begin
	    begin tran
		set @tranopen = 1
	end


	delete from cl from ClientHealthRestriction cl
	    JOIN @ClientHealthRestriction sr on sr.HealthRestrictionId = cl.HealthRestrictionId and sr.IsDelete = 1
	where cl.ClientId = @ClientId 

	insert into ClientHealthRestriction (ClientId, HealthRestrictionId)
	select @ClientId ClientId, HealthRestrictionId from @ClientHealthRestriction where IsDelete = 0

	commit tran

	return (0)

end try
begin catch
    set @msg = ERROR_MESSAGE()
	if @tranopen = 1 and @@TRANCOUNT <> 0 rollback tran
	raiserror(@msg,16,1)
    return (-1)
end catch
GO

create or alter procedure p_SaveEmployeeSpecializationByHealthRestriction
@EmployeeId bigint,
@HealthRestriction nvarchar(max)
as
declare @msg nvarchar(255)
      , @tranopen bit = 0
begin try    
    select @HealthRestriction = ISNULL(@HealthRestriction,''), @EmployeeId = isnull(@EmployeeId,0)
    if @HealthRestriction > '' AND ISJSON(@HealthRestriction) = 0 
	begin 
	     raiserror('Ошибка в параметре "@HealthRestriction"',16,1)
		 return (-1)
	end

	if not exists (select * from dbo.Employee where Id = @EmployeeId and WorkEnd is null)
	begin 
	     raiserror('Клиент не существует или уже не работает',16,1)
		 return (-1)
	end
	        	
	declare @EmployeeSpecializationByHealthRestriction table (HealthRestrictionId int not null primary key, IsDelete bit not null default(1))
	
	if @HealthRestriction > ''
	begin
	     --select Id from [dbo].[HealthRestriction] FOR JSON PATH, ROOT('HealthRestrictions')
	     insert into @EmployeeSpecializationByHealthRestriction (HealthRestrictionId, IsDelete) 
		 SELECT distinct cast(value as int) Id, 0 IsDelete FROM OPENJSON(@HealthRestriction, '$.Id')
    end

	insert into @EmployeeSpecializationByHealthRestriction (HealthRestrictionId)
	select HealthRestrictionId from EmployeeSpecializationByHealthRestriction where EmployeeId = @EmployeeId
	except
	select HealthRestrictionId from @EmployeeSpecializationByHealthRestriction

	if (select count(*) from @EmployeeSpecializationByHealthRestriction ) = 0 return (0)

	if @@TRANCOUNT = 0  
	begin
	    begin tran
		set @tranopen = 1
	end

	delete from cl from EmployeeSpecializationByHealthRestriction cl
	    JOIN @EmployeeSpecializationByHealthRestriction sr on sr.HealthRestrictionId = cl.HealthRestrictionId
	where cl.EmployeeId = @EmployeeId

	insert into EmployeeSpecializationByHealthRestriction (EmployeeId, HealthRestrictionId)
	select @EmployeeId EmployeeId, HealthRestrictionId from @EmployeeSpecializationByHealthRestriction where  IsDelete = 0

	commit tran

	return (0)

end try
begin catch
    set @msg = ERROR_MESSAGE()
	if @tranopen = 1 and @@TRANCOUNT <> 0 rollback tran
	raiserror(@msg,16,1)
    return (-1)
end catch
GO 

