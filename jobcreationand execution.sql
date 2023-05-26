USE msdb;
GO

EXEC dbo.sp_add_job
    @job_name = 'ImportDatafromcsv',
    @enabled = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ImportDatafromcsv',
    @step_name = 'marginreport',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..marginreport in "D:\FirstAssignment\marginreport.csv" -c -t, -T -S VSL1184',
    @on_success_action = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ImportDatafromcsv',
    @step_name = 'bhav1',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..bhav1 in "D:\FirstAssignment\bhav1.csv" -c -t, -T -S VSL1184',
    @on_success_action = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ImportDatafromcsv',
    @step_name = 'bhav2',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..bhav2 in "D:\FirstAssignment\bhav2.csv" -c -t, -T -S VSL1184',
    @on_success_action = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ImportDatafromcsv',
    @step_name = 'bhav3',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..bhav3 in "D:\FirstAssignment\bhav3.csv" -c -t, -T -S VSL1184',
    @on_success_action = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ImportDatafromcsv',
    @step_name = 'bhav4',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..bhav4 in "D:\FirstAssignment\bhav4.csv" -c -t, -T -S VSL1184',
    @on_success_action = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ImportDatafromcsv',
    @step_name = 'bhav5',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..bhav5 in "D:\FirstAssignment\bhav5.csv" -c -t, -T -S VSL1184',
    @on_success_action =1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ImportDatafromcsv',
    @step_name = 'NSEM',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..NSEM in "D:\FirstAssignment\NSEM.csv" -c -t, -T -S VSL1184',
    @on_success_action =1;
GO


EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ImportDatafromcsv',
    @step_name = 'BSEM',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..BSEM in "D:\FirstAssignment\BSEM.csv" -c -t, -T -S VSL1184',
    @on_success_action =1;
GO


EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ImportDatafromcsv',
    @step_name = 'Security',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..securitydata in "D:\FirstAssignment\security.csv" -c -t, -T -S VSL1184',
    @on_success_action =1;
GO


EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ImportDatafromcsv',
    @step_name = 'VAR',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..VARreport in "D:\FirstAssignment\VAR.csv" -c -t, -T -S VSL1184',
    @on_success_action =1;
GO


EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ImportDatafromcsv',
    @step_name = 'SPAN',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..spanreport in "D:\FirstAssignment\span.csv" -c -t, -T -S VSL1184',
    @on_success_action =1;
GO

--exec xp_cmdshell
--'bcp venturaDb..BSEM format nul -n -f  "D:\FirstAssignment\BSEM.txt" -c -T -S VSL1184'


BULK insert venturaDb..bhav1 from 'D:\FirstAssignment\6\cm17MAY2023bhav.xlsx'
with(FIELDTERMINATOR =',',ROWTERMINATOR ='\n')


USE MSDB
EXEC sp_add_jobserver @job_name = 'ImportDatafromcsv', @server_name =
'VSL1184'

USE venturaDb
EXEC TruncateTablesscriptcategory_SP
Go

USE MSDB
EXEC dbo.sp_start_job @job_name = 'ImportDatafromcsv';

GO


USE venturaDb
EXEC ScriptCateogryRecord_SP
Go

drop table bhav1
