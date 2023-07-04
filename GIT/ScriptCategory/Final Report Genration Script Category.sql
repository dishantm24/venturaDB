USE venturaDb
EXEC TruncateTablesscriptcategory_SP
Go

USE MSDB
EXEC dbo.sp_start_job @job_name = 'ScriptCatImport';

GO


USE venturaDb
EXEC ScriptCateogryRecord_SP
Go


