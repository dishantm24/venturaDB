
USE venturaDb
EXEC  TruncateMG13_SP
Go

USE MSDB
EXEC dbo.sp_start_job @job_name = 'ImportMG13'

GO


USE venturaDb
EXEC MG13Report_SP
RETURN ;
Go 
