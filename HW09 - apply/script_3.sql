/*
3. В таблице стран есть поля с кодом страны цифровым и буквенным
сделайте выборку ИД страны, название, код - чтобы в поле был либо цифровой либо буквенный код
Пример выдачи

CountryId CountryName Code
1 Afghanistan AFG
1 Afghanistan 4
3 Albania ALB
3 Albania 8
*/

use [WideWorldImporters]
go

select unpvt.CountryID, unpvt.CountryName, unpvt.Code
  from (
select CountryID,
       CountryName,
	   IsoAlpha3Code,
	   convert(nvarchar(3), IsoNumericCode) IsoNumericCode
from [Application].[Countries]
) p UNPIVOT(Code FOR CodeType in (IsoAlpha3Code, IsoNumericCode)) unpvt