



USE venturaDb
EXEC  TruncateMG13_SP
Go

USE MSDB
EXEC dbo.sp_start_job @job_name = 'ImportMG13';
GO


