USE WideWorldImporters 
GO

select [dbo].[StringAgg](c.Region, '; ', 1) URegions,
       [dbo].[StringAgg](c.Region, '; ', 0) Regions
  from [Application].[Countries] c;

select * from [dbo].[StringSplit]('Asia;Europe,Africa.Americas;Oceania',';,.');

SELECT [EmailAddress], 
       [dbo].[RegexMatch]([EmailAddress], '(\w+)\@(\w+)') IsValid,
	   [dbo].[RegexMatch]([EmailAddress], '(\w+)\@tailspintoys.com') IsTailspintoys,
       [dbo].[ReplaceMatch]([EmailAddress], '(\w+)\@tailspintoys.com', 'F')
  FROM [WideWorldImporters].[Application].[People];
 
select *
 from [dbo].[RegexMatches] ('robert@tailspintoys.com roberta@tailspintoys.com
 ivar@tailspintoys.com', '(\w+)\@(\w+)');
