USE msdb;
GO

EXEC dbo.sp_add_job
    @job_name = 'ExportDataToCSV1',
    @enabled = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ExportDataToCSV1',
    @step_name = 'ExportStep3',
    @subsystem = 'CMDEXEC',
    @command = 'bcp "SELECT ISINNO FROM marginreport" queryout "D:\FirstAssignment\opfile.csv" -c -t, -T -S VSL1184',
    @on_success_action = 3;
GO


USE MSDB
EXEC sp_add_jobserver @job_name = 'ExportDataToCSV1', @server_name =
'VSL1184'

USE MSDB
EXEC dbo.sp_start_job @job_name = 'ExportDataToCSV1';
GO