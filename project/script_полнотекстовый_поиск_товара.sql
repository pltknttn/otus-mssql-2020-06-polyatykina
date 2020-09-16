USE WMS
GO

--DROP FULLTEXT INDEX ON [goods].[ProductItems] 
--GO

--DROP FULLTEXT CATALOG WMS_FullText_Catalog
--GO
 
-- Создаем полнотекстовый каталог
CREATE FULLTEXT CATALOG WMS_FullText_Catalog
WITH ACCENT_SENSITIVITY = ON AS DEFAULT AUTHORIZATION [dbo] 
GO

-- Создаем Full-Text Index на [goods].[ProductItems]
CREATE FULLTEXT INDEX ON goods.ProductItems([ProductName] LANGUAGE Russian, [Article] LANGUAGE Russian)
KEY INDEX [PK_Goods_ProductItems_ProductId]
ON (WMS_FullText_Catalog)
WITH (
  CHANGE_TRACKING = AUTO,  
  STOPLIST = SYSTEM  
);
GO

select ProductId, ProductName, Article, ManufacturerId from goods.ProductItems WHERE CONTAINS(ProductName, N'w23')

select ProductId, ProductName, Article, ManufacturerId from goods.ProductItems WHERE CONTAINS(Article, N'w23')

select ProductId, ProductName, Article, ManufacturerId from goods.ProductItems WHERE CONTAINS(Article, N'w23') or CONTAINS(ProductName, N'w23')
 