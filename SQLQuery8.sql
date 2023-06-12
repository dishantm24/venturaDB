select * into NSEM from NSEM_TEST

truncate table  NSEM

BULK insert venturaDb.. 
from 'D:\ScriptCategoryScriptsanddocs\SPAN.csv'
     WITH (
     DATAFILETYPE = 'char',
     FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a')

exec xp_cmdshell 'bcp venturaDb..NSEM_TEST in D:\ScriptCategoryScriptsanddocs\NSEM.csv -c -t , -T'

TRUNCATE TABLE NSEM_TEST

truncate table SPAN

select * from NSEM
exec xp_cmdshell 'bcp venturaDb..SPAN in D:\ScriptCategoryScriptsanddocs\SPAN.csv -c -t , -T'



select * from SPAN

alter table SPAN
Drop Column  MktRate,

SPANMgn_Share,
ExpMgn_Share,
AddExpMgn_Share,
TotalMgn_Share,
SPANMgn_Lot,
AddExpMgn_Lot,
ExpMgn_Lot,
Change,
TotalMgn_Lot




delete MktRate,
Mkt_Lot,
SPANMgn_Share,
ExpMgn_Share,
AddExpMgn_Share,
TotalMgn_Share,
SPANMgn_Lot,
AddExpMgn_Lot,
ExpMgn_Lot,
Change,
TotalMgn_Lot
from SPAN
whhere 

