use FitnessClub
go

create or alter procedure p_SaveEmployee
@Id int,
@SpecialityId int, 
@PeopleData  nvarchar(max),
@CategoryId  int,
@WorkStart date,
@WorkEnd   date = null
as
declare @msg nvarchar(255)
      , @tranopen bit = 0
	  , @peopleId bigint
begin try    
    select @PeopleData = ISNULL(@PeopleData,''), @SpecialityId = isnull(@SpecialityId,0), 
	       @Id = isnull(@Id, 0), @CategoryId = isnull(@CategoryId,0)

    if @PeopleData = '' or ISJSON(@PeopleData) = 0 
	begin 
	     raiserror('Ошибка в параметре "Персональные данные"',16,1)
		 return (-1)
	end

	if @SpecialityId = 0 or not exists (select * from EmployeeSpeciality where Id = @SpecialityId)
	begin 
	     raiserror('Специализация или не указана, или не существует!',16,1)
		 return (-1)
	end

	if @CategoryId = 0 or not exists (select * from EmployeeCategory where Id = @CategoryId)
	begin 
	     raiserror('Категория или не указана, или не существует!',16,1)
		 return (-1)
	end

	if @Id > 0 and not exists (select * from Employee where Id = @Id)
	begin 
	     raiserror('Сотрудник не существует, редактирование запрещено',16,1)
		 return (-1)
	end
	        	
	declare @People table (
	[Id] [bigint] NOT NULL primary key,
	[FirstName] [nvarchar](150) NOT NULL,
	[Patronymic] [nvarchar](150) NOT NULL,
	[Surname] [nvarchar](250) NOT NULL,
	[DateOfBirth] [date] NOT NULL,
	[Sex] [smallint] NOT NULL,
	[Address] [nvarchar](500) NOT NULL,
	[Email] [nvarchar](255) NOT NULL,
	[Mobilephone] [nvarchar](20) NOT NULL,
	[Photo] [varbinary](max) NULL,
	[CategoryId] [int] NOT NULL,
	[OrganizationId] [bigint] NULL)
	
	if @@TRANCOUNT = 0  
	begin
	    set xact_abort on
	    begin tran
		set @tranopen = 1
	end

	if @PeopleData > ''
	begin
	     --select top 1 * from [dbo].[People] where Id = 1 FOR JSON PATH, ROOT('Peoples')
	     insert into @People 
		 SELECT  
		       isnull([Id],0) Id
			  ,[FirstName]
			  ,[Patronymic]
			  ,[Surname]
			  ,[DateOfBirth]
			  ,[Sex]
			  ,[Address]
			  ,[Email]
			  ,[Mobilephone]
			  ,[Photo]
			  ,isnull([CategoryId],5) CategoryId
			  ,[OrganizationId]
		 FROM OPENJSON(@PeopleData, '$.Peoples')
		 with (
		      [Id] [bigint],
		      [FirstName] [nvarchar](150),
		      [Patronymic] [nvarchar](150),
		      [Surname] [nvarchar](250),
		      [DateOfBirth] [date],
		      [Sex] [smallint],
		      [Address] [nvarchar](500),
		      [Email] [nvarchar](255),
		      [Mobilephone] [nvarchar](20),
		      [Photo] [varbinary](max),
		      [CategoryId] [int],
		      [OrganizationId] [bigint]
		 )
		 if @@ROWCOUNT <> 1 raiserror('Персональные данные указаны некорретно!',16,1) 

		;merge dbo.People t using @People s on s.Id = t.Id
		 when matched then update SET 
		                           [FirstName] = s.[FirstName]
								  ,[Patronymic] = s.[Patronymic]
								  ,[Surname] = s.[Surname]
								  ,[DateOfBirth] = s.[DateOfBirth]
								  ,[Sex] = s.[Sex]
								  ,[Address] = s.[Address]
								  ,[Email] = s.[Email]
								  ,[Mobilephone] = s.[Mobilephone]
								  ,[Photo] = s.[Photo]
								  ,[CategoryId] = s.[CategoryId]
								  ,[OrganizationId] = s.[OrganizationId]
								  ,@peopleId = t.Id
	     when not matched then insert ( [FirstName]
									   ,[Patronymic]
									   ,[Surname]
									   ,[DateOfBirth]
									   ,[Sex]
									   ,[Address]
									   ,[Email]
									   ,[Mobilephone]
									   ,[Photo]
									   ,[CategoryId]
									   ,[OrganizationId])
							 values (   s.[FirstName]
									   ,s.[Patronymic]
									   ,s.[Surname]
									   ,s.[DateOfBirth]
									   ,s.[Sex]
									   ,s.[Address]
									   ,s.[Email]
									   ,s.[Mobilephone]
									   ,s.[Photo]
									   ,s.[CategoryId]
									   ,s.[OrganizationId]); 
		 set @peopleId = ISNULL(@peopleId, SCOPE_IDENTITY())	    
    end 
	
	if @Id > 0 and exists (select * from Employee where Id <> @Id and peopleId = @peopleId and WorkStart = @WorkStart)
	begin  
	     set @msg = 'Дублирование данных. Запись на ' + FORMAT(@WorkStart, 'dd.MM.yyyy')+ ' уже заведена ранее!'
	     raiserror(@msg,16,1) 
	end

	declare @NewPeopleCategoryId int = case when @WorkEnd is null then 3
	                                        when exists (select a.Id from Agreement a join AgreementTemplate t on a.TemplateId = t.Id and PeopleCategoryId = 1
													                    where PeopleId = @peopleId) then 1
											else 5 end									 
												
	update dbo.People set CategoryId = @NewPeopleCategoryId from dbo.People where Id = @PeopleId and CategoryId <> @NewPeopleCategoryId
	
	update dbo.Employee set WorkEnd = dateadd(day, -1, @WorkStart) from dbo.Employee where PeopleId = @PeopleId and WorkStart < @WorkStart and WorkEnd is null
	
	declare @NextDate date = (select dateadd(day, -1, min(WorkStart)) from dbo.Employee where PeopleId = @PeopleId and WorkStart > @WorkStart and Id <> @Id)
	if @WorkEnd >= @NextDate
	begin 
	     set @msg = 'Некорректная дата завершения. Дата должна быть меньше ' + FORMAT(@NextDate, 'dd.MM.yyyy')
	     raiserror(@msg,16,1) 
	end

	declare @PrevDate date = (select dateadd(day, 1, max(isnull(WorkEnd, WorkStart))) from dbo.Employee where PeopleId = @PeopleId and WorkStart < @WorkStart and Id <> @Id)
	if @WorkStart < @PrevDate
	begin 
	     set @msg = 'Некорректная дата начала. Дата должна быть больше ' + FORMAT(@PrevDate, 'dd.MM.yyyy')
	     raiserror(@msg,16,1) 
	end

	set @WorkEnd = ISNULL(@WorkEnd, @NextDate) 

	;merge Employee t
	using (select @Id Id,
	              @SpecialityId SpecialityId,
				  @peopleId PeopleId,
				  @CategoryId CategoryId,
				  @WorkStart WorkStart,
				  @WorkEnd   WorkEnd
	       ) s on s.Id = t.Id
    when matched then update set SpecialityId = s.SpecialityId, PeopleId = s.PeopleId, CategoryId = s.CategoryId, WorkStart = s.WorkStart, WorkEnd = s.WorkEnd
	when not matched then insert (SpecialityId, PeopleId, CategoryId, WorkStart, WorkEnd) values(s.SpecialityId, s.PeopleId, CategoryId, WorkStart, WorkEnd);
	 		 
	if @tranopen = 1 and @@TRANCOUNT <> 0 commit tran
	set @tranopen = 0
	return (0)

end try
begin catch
    set @msg = ERROR_MESSAGE()
	if @tranopen = 1 and @@TRANCOUNT <> 0 rollback tran
	raiserror(@msg,16,1)
    return (-1)
end catch
GO

