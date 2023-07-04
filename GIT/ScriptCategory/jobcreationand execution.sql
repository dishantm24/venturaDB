USE msdb;
GO

EXEC dbo.sp_add_job
    @job_name = 'ScriptCatImport',
    @enabled = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ScriptCatImport',
    @step_name = 'marginreport',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..marginreport in "D:\FirstAssignment\marginreport.csv" -c -t, -T -S VSL1184',
    @on_success_action = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ScriptCatImport',
    @step_name = 'bhav1',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..bhav1 in "D:\FirstAssignment\bhav1.csv" -c -t, -T -S VSL1184',
    @on_success_action = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ScriptCatImport',
    @step_name = 'bhav2',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..bhav2 in "D:\FirstAssignment\bhav2.csv" -c -t, -T -S VSL1184',
    @on_success_action = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ScriptCatImport',
    @step_name = 'bhav3',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..bhav3 in "D:\FirstAssignment\bhav3.csv" -c -t, -T -S VSL1184',
    @on_success_action = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ScriptCatImport',
    @step_name = 'bhav4',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..bhav4 in "D:\FirstAssignment\bhav4.csv" -c -t, -T -S VSL1184',
    @on_success_action = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ScriptCatImport',
    @step_name = 'bhav5',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..bhav5 in "D:\FirstAssignment\bhav5.csv" -c -t, -T -S VSL1184',
    @on_success_action =1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ScriptCatImport',
    @step_name = 'NSEM',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..NSEM in "D:\FirstAssignment\NSEM.csv" -c -t, -T -S VSL1184',
    @on_success_action =1;
GO


EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ScriptCatImport',
    @step_name = 'BSEM',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..BSEM in "D:\FirstAssignment\BSEM.csv" -c -t, -T -S VSL1184',
    @on_success_action =1;
GO


EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ScriptCatImport',
    @step_name = 'Security',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..securitydata in "D:\FirstAssignment\security.csv" -c -t, -T -S VSL1184',
    @on_success_action =1;
GO


EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ScriptCatImport',
    @step_name = 'VAR',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..VARreport in "D:\FirstAssignment\VAR.csv" -c -t, -T -S VSL1184',
    @on_success_action =1;
GO


EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ScriptCatImport',
    @step_name = 'SPAN',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..spanreport in "D:\FirstAssignment\span.csv" -c -t, -T -S VSL1184',
    @on_success_action =1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'ScriptCatImport',
    @step_name = 'BSE',
    @subsystem = 'CMDEXEC',
    @command = 'bcp venturaDb..BSEM in D:\ScriptCategoryScriptsanddocs\BSEM.rpt" -c -t, -T -S VSL1184',
    @on_success_action =1;
GO


--exec xp_cmdshell
--'bcp venturaDb..BSEM format nul -n -f  "D:\FirstAssignment\BSEM.txt" -c -T -S VSL1184'


BULK insert venturaDb..NSEM from
'D:\ScriptCategoryScriptsanddocs\NSEM.csv'
WITH (
   

 ROWTERMINATOR = '\n',FIELDTERMINATOR = ',',CODEPAGE = 'ACP',
 
ERRORFILE = 'D:\ScriptCategoryScriptsanddocs\myRubbishData.log'
)

select * from nsem

exec xp_cmdshell 'bcp venturaDb..NSEM
in "D:\ScriptCategoryScriptsanddocs\NSEM.csv" -c  -T -S VSL1184'


exec xp_cmdshell 'bcp venturaDb..NSEM  in D:\ScriptCategoryScriptsanddocs\NSEM.csv  -c -t, -T -S VSL1184'

exec xp_cmdshell 'bcp venturaDb..BSEM in D:\ScriptCategoryScriptsanddocs\BSEM.csv -c -r\n -q -t ,  -T'

CODEPAGE = 'ACP'


select * from  spanreport

BULK insert venturaDb..BSEM from
'D:\ScriptCategoryScriptsanddocs\BSEM.csv'
WITH ( DATAFILETYPE = 'char',ROWTERMINATOR ='\n',FIELDTERMINATOR  = ','
)

BULK insert venturaDb..spanreport from 'D:\ScriptCategoryScriptsanddocs\span22052.csv'
     WITH (
     DATAFILETYPE = 'char',
     FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a')


truncate table NSEM

insert into spanreport1

select * from spanreport1


--span,BSEM : XLSX normal import 
--NSEM : CSV import 
--rest all via job 

select * from spanreport

exec xp_cmdshell 'bcp venturaDb..spanreport in D:\ScriptCategoryScriptsanddocs\span22052.csv -c -t , -T'


truncate table BSEM

drop table spanreport

Insert into  spanreport1
--select 

-- Symbol,s,CAST([MktRate] as FLOAT),CAST([Change] as FLOAT),
--CAST(Mkt_Lot as FLOAT),CAST([SPANMgn] as FLOAT),CAST([ExpMgn] as FLOAT),
--CAST([AddExpMgn] as FLOAT),CAST([TotalMgn] as FLOAT),CAST([SPANMgn_Share] as FLOAT),
--CAST([ExpMgn_Share] as FLOAT),CAST([AddExpMgn_Share] as FLOAT)
--,CAST([TotalMgn_Share] as FLOAT),CAST([SPANMgn_Lot] as FLOAT),
--CAST([ExpMgn_Lot] as FLOAT),CAST([AddExpMgn_Lot] as FLOAT),
--CAST([TotalMgn_Lot] as FLOAT) from spanreport


-- from spanreport1

 delete from spanreport1 where Symbol = 'Symbol'
select * from spanreport1

exec xp_cmdshell 'bcp  venturaDb..spanreport1 out D:\ScriptCategoryScriptsanddocs\span_n.csv -c -t , -T'

exec xp_cmdshell 'bcp venturaDb..spanreport in D:\ScriptCategoryScriptsanddocs\span.csv -c -t , -T'


 select * from newsp

 Insert into  spanreport
 select * from spanreport1


 


alter table spanreport
add FLoatvalue float

Update float column = Try_Cast(nvarchar column as float);

update spanreport
set FLoatvalue = TRY_CAST(nvarchar [Mkt Lot] as Float);


select * from NSEM

drop  table nsem

DECLARE @location as varchar(20)

Set @location = 'D:\ScriptCategoryScriptsanddocs\bhav1.'

exec xp_cmdshell 'bcp venturaDb..bhav1 in D:\ScriptCategoryScriptsanddocs\bhav1.csv -c -t , -T'

select * from bhav1

BULK insert venturaDb..bhav1 from 'D:\ScriptCategoryScriptsanddocs\bhav1.csv'
     WITH (
     DATAFILETYPE = 'char',
     FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a')
