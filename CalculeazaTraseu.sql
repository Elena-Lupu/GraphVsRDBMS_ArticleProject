USE [Precis]
GO
/****** Object:  StoredProcedure [dbo].[CalculeazaTraseu]    Script Date: 22.05.2024 22:33:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CalculeazaTraseu] (@StartNode INT, @EndNode INT, @FaraScari BIT, @puncteEvitate nvarchar(max))
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
	    SELECT n.Id, nd.Nume, n.Estimate, CAST(n.Id AS varchar(8000)), CAST(nd.Nume AS varchar(8000))
		FROM #TempVal n JOIN dbo.Noduri nd ON n.Id = nd.ID
		WHERE n.Id = @StartNode	         

	    UNION ALL
      
		SELECT n.Id, nd.Nume, n.Estimate,
			CAST(cte.Pat + ',' + CAST(n.Id as varchar(10)) as varchar(8000)),
			CAST(cte.NamePath + ',' + nd.Nume AS varchar(8000))
		FROM #TempVal n JOIN BacktraceCTE cte ON n.Predecessor = cte.Id JOIN dbo.Noduri nd ON n.Id = nd.Id
	)

	SELECT Distance, Pat, NamePath FROM BacktraceCTE
	WHERE Id = @EndNode OR @EndNode IS NULL
	ORDER BY Id
	
	IF (@harta != '#Noduri_hartaCompleta' AND @harta != '#Noduri_hartaFaraScari')
	BEGIN
		SET @creationSQL = 'DROP TABLE ' + @harta
		EXEC sp_executesql @creationSql
	END
		
	DROP TABLE #TempVal
	COMMIT TRAN
	RETURN 0
END
