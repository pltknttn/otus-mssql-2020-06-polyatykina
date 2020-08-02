/*
5. Code review (опционально). Запрос приложен в материалы Hometask_code_review.sql.
Что делает запрос?
Чем можно заменить CROSS APPLY - можно ли использовать другую стратегию выборки\запроса?

SELECT T.FolderId,
		   T.FileVersionId,
		   T.FileId		
	FROM dbo.vwFolderHistoryRemove FHR
	CROSS APPLY (SELECT TOP 1 FileVersionId, FileId, FolderId, DirId
			FROM #FileVersions V
			WHERE RowNum = 1
				AND DirVersionId <= FHR.DirVersionId
			ORDER BY V.DirVersionId DESC) T 
	WHERE FHR.[FolderId] = T.FolderId
	AND FHR.DirId = T.DirId
	AND EXISTS (SELECT 1 FROM #FileVersions V WHERE V.DirVersionId <= FHR.DirVersionId)
	AND NOT EXISTS (
			SELECT 1
			FROM dbo.vwFileHistoryRemove DFHR
			WHERE DFHR.FileId = T.FileId
				AND DFHR.[FolderId] = T.FolderId
				AND DFHR.DirVersionId = FHR.DirVersionId
				AND NOT EXISTS (
					SELECT 1
					FROM dbo.vwFileHistoryRestore DFHRes
					WHERE DFHRes.[FolderId] = T.FolderId
						AND DFHRes.FileId = T.FileId
						AND DFHRes.PreviousFileVersionId = DFHR.FileVersionId
					)
			)
*/

/*Возможно искали не удаленные файлы */

SELECT T.FolderId,
	   T.FileVersionId,
	   T.FileId		
	FROM 
		-- история удаленных каталогов
		dbo.vwFolderHistoryRemove FHR
	
	CROSS APPLY (
	      -- берется любой файл с версией директории по текущую (т.е. ниже или текущая)
		 SELECT TOP 1 FileVersionId, FileId, FolderId, DirId
			FROM #FileVersions V
			WHERE RowNum = 1 
			 AND V.DirVersionId <= FHR.DirVersionId
			ORDER BY V.DirVersionId DESC) T 

	WHERE 
	     -- если совпала папка и корневая директория
		 FHR.[FolderId] = T.FolderId AND FHR.DirId = T.DirId
    -- это условие не нужно, т.к. CROSS APPLY возвращает только коррелированные данные 
	--AND EXISTS (SELECT 1 FROM #FileVersions V WHERE V.DirVersionId <= FHR.DirVersionId)
	
	-- проверяем, что файл не удалялся
	AND NOT EXISTS (	        
			SELECT 1
			     -- история удаленния файла в 
			FROM dbo.vwFileHistoryRemove DFHR
			WHERE   DFHR.FileId = T.FileId --файл
				AND DFHR.[FolderId] = T.FolderId  -- папка

				AND DFHR.DirVersionId = FHR.DirVersionId --версия корневой директории
				
				-- не существует записи о том, что файл восстанавливался ранее 
				AND NOT EXISTS (
					SELECT 1
					FROM dbo.vwFileHistoryRestore DFHRes
					WHERE   DFHRes.[FolderId] = T.FolderId  --папка
						AND DFHRes.FileId = T.FileId -- файл

						-- предыдущая версия файла = версия удаленного файла
						AND DFHRes.PreviousFileVersionId = DFHR.FileVersionId
					)
			)

/*Возможно можно так сделать*/

SELECT TOP(1) WITH TIES
       T.FolderId, 
       T.FileVersionId, 
	   T.FileId,
       ROW_NUMBER() OVER(PARTITION BY T.FolderId,T.FileVersionId,T.FileId ORDER BY T.DirVersionId DESC) DirVersionId
	FROM 
	    -- история удаленных каталогов
	    dbo.vwFolderHistoryRemove FHR 
		
	    -- версии файлов
	 JOIN #FileVersions T on T.RowNum = 1 	                   
						   -- все версии до текущей
						   AND T.DirVersionId <= FHR.DirVersionId
						   -- по каталогу в директории 
						   AND FHR.[FolderId] = T.FolderId AND FHR.DirId = T.DirId 
	WHERE 
	 -- Проверка, что файл не удален
	 NOT EXISTS (
			SELECT DFHR.FileVersionId
			     -- история удаленных файлов по 
			FROM dbo.vwFileHistoryRemove DFHR

			WHERE   DFHR.FileId = T.FileId --файл
				AND DFHR.[FolderId] = T.FolderId -- папка
				AND DFHR.DirVersionId = FHR.DirVersionId --версия директории

			except

			SELECT DFHRes.PreviousFileVersionId
			     -- история восстановлений
			 FROM dbo.vwFileHistoryRestore DFHRes
			 WHERE DFHRes.[FolderId] = T.FolderId --папка
			   AND DFHRes.FileId = T.FileId -- файл  
			)
ORDER BY ROW_NUMBER() OVER(PARTITION BY T.FolderId,T.FileVersionId,T.FileId ORDER BY T.DirVersionId DESC)