DECLARE @init_sum_cpu_time INT, @utilizedCpuCount INT 
--get CPU count used by SQL Server
SELECT @utilizedCpuCount = COUNT( * ) FROM sys.dm_os_schedulers WHERE status = 'VISIBLE ONLINE' 
--calculate the CPU usage by queries OVER a 5 sec interval 
SELECT @init_sum_cpu_time = SUM(cpu_time) FROM sys.dm_exec_requests

EXEC [dbo].[CalculeazaTraseu]
		@StartNode = 1,
		@EndNode = 13,
		@FaraScari = 0,
		@puncteEvitate = '',
		@puncteIntermediare = N'2'

SELECT CONVERT(DECIMAL(5,2), ((SUM(cpu_time) - @init_sum_cpu_time) / (@utilizedCpuCount * 5000.00)) * 100) AS [CPU from Queries as Percent of Total CPU Capacity] 
	FROM sys.dm_exec_requests
