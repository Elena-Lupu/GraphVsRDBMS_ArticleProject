USE [Precis]
GO
/****** Object:  StoredProcedure [dbo].[CalculeazaTraseu]    Script Date: 04.06.2024 11:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CalculeazaTraseu] (@StartNode INT, @EndNode INT, @FaraScari BIT, @puncteEvitate nvarchar(max), @puncteIntermediare nvarchar(max))
AS
BEGIN
BEGIN TRAN
	SET NOCOUNT ON;

	DECLARE @creationSQL nvarchar(max)
	DECLARE @harta nvarchar(100)
	DECLARE @FromNode INT, @CurrentEstimate INT

	IF OBJECT_ID(N'tempdb..#TempVal') IS NOT NULL
		DROP TABLE #TempVal

	CREATE TABLE #TempVal
	(
		Id INT NOT NULL PRIMARY KEY,
		Estimate INT NOT NULL,
		Predecessor INT NULL,
		Done BIT NOT NULL
	)

	SET @harta = '#Noduri_harta'

	IF (@FaraScari = 1) SET @harta += 'FaraScari'
	ELSE SET @harta += 'Completa'
	
	SET @harta += (SELECT REPLACE(@puncteEvitate, ',', 'o'))

	SET @creationSQL = 
		'IF OBJECT_ID(N''tempdb..' + @harta + ''') IS NULL
		BEGIN
			CREATE TABLE ' + @harta + '
			(
				ID INT NOT NULL PRIMARY KEY,
				Nume VARCHAR(50) NOT NULL
			)
			INSERT INTO ' + @harta + ' (ID, Nume) SELECT ID, Nume FROM dbo.Noduri'

	IF (@FaraScari = 1) SET @creationSQL += ' WHERE Tip != ''scari'''

	IF (@puncteEvitate IS NOT NULL AND @puncteEvitate != '')
	BEGIN
		IF (@FaraScari = 1) SET @creationSQL += ' AND '
		ELSE SET @creationSQL += ' WHERE '
		SET @creationSQL += 'ID NOT IN (' + @puncteEvitate + ')'
	END

	SET @creationSQL += 
		' END
		INSERT INTO #TempVal (Id, Estimate, Predecessor, Done) SELECT ID, 9999999, NULL, 0 FROM ' + @harta

	EXEC sp_executesql @creationSql

	IF (@puncteIntermediare = '' OR @puncteIntermediare = NULL)
	BEGIN
		UPDATE #TempVal SET Estimate = 0 WHERE Id = @StartNode
		IF @@rowcount <> 1
		BEGIN
			DROP TABLE #TempVal
			ROLLBACK TRAN
			RETURN 1
		END

		WHILE 1=1
		BEGIN
			SELECT @FromNode = NULL

			SELECT TOP 1 @FromNode = Id, @CurrentEstimate = Estimate FROM #TempVal WHERE Done = 0 AND Estimate < 9999999
			ORDER BY Estimate

			IF @FromNode IS NULL OR @FromNode = @EndNode BREAK

			UPDATE #TempVal SET Done = 1 WHERE Id = @FromNode

			UPDATE #TempVal SET Estimate = @CurrentEstimate + e.Pondere, Predecessor = @FromNode
			FROM #TempVal n INNER JOIN dbo.Relatii e ON n.Id = e.IdNodEnd
			WHERE Done = 0 AND e.IdNodStart = @FromNode AND (@CurrentEstimate + e.Pondere) < n.Estimate
		END;

		WITH BacktraceCTE(Id, Nam, Distance, Pat, NamePath) AS
		(
			SELECT n.Id, nd.Nume, n.Estimate, CAST(n.Id AS varchar(100)), CAST(nd.Nume AS varchar(1000))
			FROM #TempVal n JOIN dbo.Noduri nd ON n.Id = nd.ID
			WHERE n.Id = @StartNode	         

			UNION ALL
      
			SELECT n.Id, nd.Nume, n.Estimate,
				CAST(cte.Pat + ',' + CAST(n.Id as varchar(10)) as varchar(100)),
				CAST(cte.NamePath + ',' + nd.Nume AS varchar(1000))
			FROM #TempVal n JOIN BacktraceCTE cte ON n.Predecessor = cte.Id JOIN dbo.Noduri nd ON n.Id = nd.Id
		)

		SELECT Distance, Pat, NamePath FROM BacktraceCTE WHERE Id = @EndNode OR @EndNode IS NULL ORDER BY Id
	END
	ELSE
	BEGIN
		DECLARE @i INT = 0, @j INT = 0, @tempStartNod INT, @tempEndNod INT 
		DECLARE @lenVia INT, @DistanceTemp INT, @NamePathTemp varchar(1000), @PatTemp VARCHAR(100)
		DECLARE @NamePathVia varchar(1000), @PatVia varchar(100), @costVia INT = 999

		-- Sparge @puncteIntermediare intr-o lista si creeaza tabelul temporar corespunzator listei de puncte via
		IF OBJECT_ID(N'tempdb..#ViaList') IS NOT NULL DROP TABLE #ViaList

		CREATE TABLE #ViaList
		(
			Ord INT NOT NULL PRIMARY KEY,
			Val INT NOT NULL
		)
		INSERT INTO #ViaList(Ord, Val) SELECT ROW_NUMBER() OVER(ORDER BY value) AS Ord, value FROM STRING_SPLIT(@puncteIntermediare, ',')
		SELECT @lenVia = COUNT(Val) FROM #ViaList

		WHILE @i < @lenVia
		BEGIN
			SET @DistanceTemp = 0
			SET @NamePathTemp = ''
			SET @PatTemp = ''

			-- Calculeaza traseu @Start - @puncteIntermediare - @End => Distance, Pat, NamePath FROM BacktraceCTE (concateneaza/aduna pe masura ce adaugi la traseu)
			-- Start - lista[0]
			SELECT @tempEndNod = Val FROM #ViaList WHERE Ord=1
			UPDATE #TempVal SET Estimate = 0 WHERE Id = @StartNode
			IF @@rowcount <> 1
			BEGIN
				DROP TABLE #TempVal
				ROLLBACK TRAN
				RETURN 1
			END

			WHILE 1=1
			BEGIN
				SELECT @FromNode = NULL

				SELECT TOP 1 @FromNode = Id, @CurrentEstimate = Estimate FROM #TempVal WHERE Done = 0 AND Estimate < 9999999
				ORDER BY Estimate

				IF @FromNode IS NULL OR @FromNode = @tempEndNod BREAK

				UPDATE #TempVal SET Done = 1 WHERE Id = @FromNode

				UPDATE #TempVal SET Estimate = @CurrentEstimate + e.Pondere, Predecessor = @FromNode
				FROM #TempVal n INNER JOIN dbo.Relatii e ON n.Id = e.IdNodEnd
				WHERE Done = 0 AND e.IdNodStart = @FromNode AND (@CurrentEstimate + e.Pondere) < n.Estimate
			END;

			WITH BacktraceCTE(Id, Nam, Distance, Pat, NamePath) AS
			(
				SELECT n.Id, nd.Nume, n.Estimate, CAST(n.Id AS varchar(100)), CAST(nd.Nume AS varchar(1000))
				FROM #TempVal n JOIN dbo.Noduri nd ON n.Id = nd.ID
				WHERE n.Id = @StartNode	         

				UNION ALL
      
				SELECT n.Id, nd.Nume, n.Estimate,
					CAST(cte.Pat + ',' + CAST(n.Id as varchar(10)) as varchar(100)),
					CAST(cte.NamePath + ',' + nd.Nume AS varchar(1000))
				FROM #TempVal n JOIN BacktraceCTE cte ON n.Predecessor = cte.Id JOIN dbo.Noduri nd ON n.Id = nd.Id
			)

			SELECT @DistanceTemp = @DistanceTemp + Distance, @PatTemp = @PatTemp + Pat, @NamePathTemp = @NamePathTemp + NamePath FROM BacktraceCTE
			WHERE Id = @tempEndNod OR @tempEndNod IS NULL ORDER BY Id

			UPDATE #TempVal SET Estimate=9999999, Predecessor=NULL, Done=0
			
			-- FOR --> lista[0] - lista[1] ... lista[n-1] - lista[n]
			SET @j = 1
			WHILE @j <= @lenVia-1
			BEGIN
				SET @tempStartNod = (SELECT Val FROM #ViaList WHERE Ord=@j)
				SET @tempEndNod = (SELECT Val FROM #ViaList WHERE Ord=@j+1)

				UPDATE #TempVal SET Estimate = 0 WHERE Id = @tempStartNod
				IF @@rowcount <> 1
				BEGIN
					DROP TABLE #TempVal
					ROLLBACK TRAN
					RETURN 1
				END

				WHILE 1=1
				BEGIN
					SELECT @FromNode = NULL

					SELECT TOP 1 @FromNode = Id, @CurrentEstimate = Estimate FROM #TempVal WHERE Done = 0 AND Estimate < 9999999
					ORDER BY Estimate

					IF @FromNode IS NULL OR @FromNode = @tempEndNod BREAK

					UPDATE #TempVal SET Done = 1 WHERE Id = @FromNode

					UPDATE #TempVal SET Estimate = @CurrentEstimate + e.Pondere, Predecessor = @FromNode
					FROM #TempVal n INNER JOIN dbo.Relatii e ON n.Id = e.IdNodEnd
					WHERE Done = 0 AND e.IdNodStart = @FromNode AND (@CurrentEstimate + e.Pondere) < n.Estimate
				END;

				WITH BacktraceCTE(Id, Nam, Distance, Pat, NamePath) AS
				(
					SELECT n.Id, nd.Nume, n.Estimate, CAST(n.Id AS varchar(100)), CAST(nd.Nume AS varchar(1000))
					FROM #TempVal n JOIN dbo.Noduri nd ON n.Id = nd.ID
					WHERE n.Id = @tempStartNod        

					UNION ALL
      
					SELECT n.Id, nd.Nume, n.Estimate,
						CAST(cte.Pat + ',' + CAST(n.Id as varchar(10)) as varchar(100)),
						CAST(cte.NamePath + ',' + nd.Nume AS varchar(1000))
					FROM #TempVal n JOIN BacktraceCTE cte ON n.Predecessor = cte.Id JOIN dbo.Noduri nd ON n.Id = nd.Id
				)

				SELECT @DistanceTemp = @DistanceTemp + Distance, @PatTemp = @PatTemp + ',' + Pat, @NamePathTemp = @NamePathTemp + ',' + NamePath FROM BacktraceCTE
				WHERE Id = @tempEndNod OR @tempEndNod IS NULL ORDER BY Id

				UPDATE #TempVal SET Estimate=9999999, Predecessor=NULL, Done=0

				SET @j = @j + 1
			END

			-- lista[n] - End
			SET @tempStartNod = (SELECT Val FROM #ViaList WHERE Ord=@lenVia)
			
			UPDATE #TempVal SET Estimate = 0 WHERE Id = @tempStartNod
			IF @@rowcount <> 1
			BEGIN
				DROP TABLE #TempVal
				ROLLBACK TRAN
				RETURN 1
			END

			WHILE 1=1
			BEGIN
				SELECT @FromNode = NULL

				SELECT TOP 1 @FromNode = Id, @CurrentEstimate = Estimate FROM #TempVal WHERE Done = 0 AND Estimate < 9999999
				ORDER BY Estimate

				IF @FromNode IS NULL OR @FromNode = @EndNodE BREAK

				UPDATE #TempVal SET Done = 1 WHERE Id = @FromNode

				UPDATE #TempVal SET Estimate = @CurrentEstimate + e.Pondere, Predecessor = @FromNode
				FROM #TempVal n INNER JOIN dbo.Relatii e ON n.Id = e.IdNodEnd
				WHERE Done = 0 AND e.IdNodStart = @FromNode AND (@CurrentEstimate + e.Pondere) < n.Estimate
			END;

			WITH BacktraceCTE(Id, Nam, Distance, Pat, NamePath) AS
			(
				SELECT n.Id, nd.Nume, n.Estimate, CAST(n.Id AS varchar(100)), CAST(nd.Nume AS varchar(1000))
				FROM #TempVal n JOIN dbo.Noduri nd ON n.Id = nd.ID
				WHERE n.Id = @tempStartNod        

				UNION ALL
      
				SELECT n.Id, nd.Nume, n.Estimate,
					CAST(cte.Pat + ',' + CAST(n.Id as varchar(10)) as varchar(100)),
					CAST(cte.NamePath + ',' + nd.Nume AS varchar(1000))
				FROM #TempVal n JOIN BacktraceCTE cte ON n.Predecessor = cte.Id JOIN dbo.Noduri nd ON n.Id = nd.Id
			)

			SELECT @DistanceTemp = @DistanceTemp + Distance, @PatTemp = @PatTemp + ',' + Pat, @NamePathTemp = @NamePathTemp + ',' + NamePath FROM BacktraceCTE
			WHERE Id = @EndNode OR @EndNode IS NULL ORDER BY Id

			-- Compara Distance cu costVia: daca este mai mic, retine Distance, Pat, NamePath, update costVia
			IF (@DistanceTemp < @costVia)
			BEGIN
				SET @costVia = @DistanceTemp
				SET @PatVia = @PatTemp
				SET @NamePathVia = @NamePathTemp
			END
			
			-- Permuta @puncteIntermediareLista --> Ultimul (retinut deja de @tempStartNod) element devine primul
			SET @j = @lenVia
			WHILE @j > 1
			BEGIN
				UPDATE #ViaList SET Val = (SELECT Val FROM #ViaList WHERE Ord=@j-1) WHERE Ord = @j
				SET @j = @j - 1
			END
			UPDATE #ViaList SET Val = @tempStartNod WHERE Ord = 1

			UPDATE #TempVal SET Estimate=9999999, Predecessor=NULL, Done=0

			SET @i = @i + 1
		END
		-- DROP #ViaList + return valori
		DROP TABLE #ViaList
		SELECT Distance=@costVia, Pat=@PatVia, NamePath=@NamePathVia
	END
	
	IF (@harta != '#Noduri_hartaCompleta' AND @harta != '#Noduri_hartaFaraScari')
	BEGIN
		SET @creationSQL = 'DROP TABLE ' + @harta
		EXEC sp_executesql @creationSql
	END
		
	DROP TABLE #TempVal
	COMMIT TRAN
	RETURN 0
END
