USE msdb;
GO

EXEC dbo.sp_add_job
    @job_name = 'ImportMG13',
    @enabled = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ImportMG13',
    @step_name = 'CASH4',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..CASH4 in "D:\MG13Peakdocsandscripts\MG13_Peak\250523\CASH4" -c -t, -T -S VSL1184',
    @on_success_action = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ImportMG13',
    @step_name = 'CUR4',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..CUR4 in "D:\MG13Peakdocsandscripts\MG13_Peak\250523\CUR4" -c -t, -T -S VSL1184',
    @on_success_action = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ImportMG13',
    @step_name = 'NCDX4',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..NCDX4 in "D:\MG13Peakdocsandscripts\MG13_Peak\250523\NCDX4" -c -t, -T -S VSL1184',
    @on_success_action = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ImportMG13',
    @step_name = 'FNO4',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..FNO4 in "D:\MG13Peakdocsandscripts\MG13_Peak\250523\FNO4" -c -t, -T -S VSL1184',
    @on_success_action = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ImportMG13',
    @step_name = 'MCX4',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..MCX4 in "D:\MG13Peakdocsandscripts\MG13_Peak\250523\MCX4" -c -t, -T -S VSL1184',
    @on_success_action = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ImportMG13',
    @step_name = 'COM4',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..COM4 in "D:\MG13Peakdocsandscripts\MG13_Peak\250523\COM4" -c -t, -T -S VSL1184',
    @on_success_action = 1;
GO


--exec xp_cmdshell
--'bcp venturaDb..BSEM format nul -n -f  "D:\FirstAssignment\BSEM.txt" -c -T -S VSL1184'


BULK insert venturaDb..CASH1 from 'D:\MG13Peakdocsandscripts\MG13_Peak\250523\CASH1.csv'
with(FIELDTERMINATOR =',',ROWTERMINATOR ='\n')


USE MSDB
EXEC sp_add_jobserver @job_name = 'ImportMG13', @server_name =
'VSL1184'

USE venturaDb
exec TruncateMG13_SP

USE MSDB
EXEC dbo.sp_start_job @job_name = 'ImportMG13';

GO

select * from CASH1
select * from CASH2


BULK insert venturaDb..CASH2 from 'D:\MG13Peakdocsandscripts\MG13_Peak\250523\CASH2.rpt'
with(FIELDTERMINATOR =',',ROWTERMINATOR ='\n')

truncate table CASH2

select * from CASH1