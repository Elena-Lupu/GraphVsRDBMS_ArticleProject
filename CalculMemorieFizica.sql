USE [Precis]

DECLARE @init_mem INT
SELECT @init_mem = physical_memory_in_use_kb FROM sys.dm_os_process_memory

EXEC [dbo].[CalculeazaTraseu]
		@StartNode = 1,
		@EndNode = 13,
		@FaraScari = 0,
		@puncteEvitate = '',
		@puncteIntermediare = N'2'

SELECT (physical_memory_in_use_kb - @init_mem) AS [Physical Memory Used] FROM sys.dm_os_process_memory
