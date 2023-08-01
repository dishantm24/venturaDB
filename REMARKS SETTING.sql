----select * from [dbo].[FinalScriptCategory] where AVEGRAGES <=95000
----where T =  'null'

--order by FNOIND desc



---ADD NEW COLUMN REMARKS ----------------------------------

ALTER TABLE FinalScriptCategory
add REMARKS nvarchar(max)

----ASM ----------------------------------------------

UPDATE venturaDb..FinalScriptCategory
SET REMARKS = 'ASM'
WHERE  [ASM FLAG] in (11,13,14)

UPDATE venturaDb..FinalScriptCategory
SET MAXIUMVALUE =100
WHERE REMARKS = 'ASM' and  MAXIUMVALUE <> 100  

UPDATE venturaDb..FinalScriptCategory
SET NEWCAT = 'D'
WHERE REMARKS = 'ASM' and   NEWCAT  not in('D','E')

--------------Scrip for no trading AVG column () (GS/GB)----------------------------

UPDATE venturaDb..FinalScriptCategory
SET REMARKS = 'Scrip for no trading AVG column () (GS/GB)'
where Series in ('GB','GS') and AVEGRAGES = 0 

UPDATE venturaDb..FinalScriptCategory
SET MAXCAT =100 
where REMARKS = 'Scrip for no trading AVG column () (GS/GB)' and MAXCAT <>100


UPDATE venturaDb..FinalScriptCategory
SET CAT1NEW = 'D'
where REMARKS = 'Scrip for no trading AVG column () (GS/GB)' and CAT1NEW  not in('D','E')

-----Scrip for no trading for the day----------------------------------------------------

UPDATE venturaDb..FinalScriptCategory
SET REMARKS = 'Scrip for no trading for the day'
where T IS NULL and Series not in ('GB','GS')


UPDATE venturaDb..FinalScriptCategory
SET MAXCAT =100 
where REMARKS = 'Scrip for no trading for the day' and MAXCAT <>100

UPDATE venturaDb..FinalScriptCategory
SET  CAT1NEW = 'D'
where REMARKS = 'Scrip for no trading for the day' and CAT1NEW  not in('D','E')


-------Scrip not traded last 5 days (AVG column)---------------------------
UPDATE venturaDb..FinalScriptCategory
SET REMARKS = 'Scrip not traded last 5 days (AVG column)'
WHERE AVEGRAGES iS NULL and Series = 'EQ'

UPDATE venturaDb..FinalScriptCategory
SET MAXCAT =100 
where REMARKS = 'Scrip not traded last 5 days (AVG column)' and MAXCAT <>100

UPDATE venturaDb..FinalScriptCategory
SET  CAT1NEW = 'D'
where REMARKS = 'Scrip not traded last 5 days (AVG column)' and CAT1NEW  not in('D','E')

-----Avg val below 95k QAB SCRIPT for NON FO only------------------------

UPDATE venturaDb..FinalScriptCategory
SET REMARKS = 'Avg val below 95k QAB SCRIPT for NON FO only'
where AVEGRAGES <=95000 AND BASE <> 999 and FNOIND = ''


with CTE AS (

Select ISINNO,([VAR] + [ELM] + [ADDI] + 15) as 'VARADDIELM' from FinalScriptCategory)


--var+elm+addi<=50
UPDATE FinalScriptCategory
SET  MAXIUMVALUE = 50 ,NEWCAT = 'C'
from FinalScriptCategory f  inner join CTE c on f.ISINNO = c.ISINNO and VARADDIELM <=50
where REMARKS = 'Avg val below 95k QAB SCRIPT for NON FO only'
;

with CTE AS (

Select ISINNO,([VAR] + [ELM] + [ADDI] + 15) as 'VARADDIELM' from FinalScriptCategory)

----var+elm+addi>50
UPDATE FinalScriptCategory
SET MAXIUMVALUE = ca.Margin ,NEWCAT = ca.Category
from FinalScriptCategory f  inner join CTE c on f.ISINNO = c.ISINNO and VARADDIELM >50
left join catc ca on c.VARADDIELM = ca.Margin
where REMARKS = 'Avg val below 95k QAB SCRIPT for NON FO only'

---------------------------------Category 1 Marking---------------------------------------------------------------------------------
---turncate old data---------------------------------

Truncate table [dbo].[Category1marking] 

-------Import categor1marking file ----
exec xp_cmdshell 'bcp venturaDb..[Category1marking] in "D:\ScriptCategoryScriptsanddocs\Category1Marking.csv" -c -t, -T -S VSL1184'


Delete  from [Category1marking] where  ISIN = 'ISIN'

UPDATE FinalScriptCategory
Set CAT1NEW = 'A36'
from FinalScriptCategory f  inner  join [dbo].[Category1marking] c on f.ISINNO = c.ISIN
where MAXCAT between 25 and 50

-------------------------------NEWCAT Updates---------------------------------------------------------------


UPDATE FinalScriptCategory
SET NEWCAT = c.C
from FinalScriptCategory f 
left join CATMARNEW c on f.MAXIUMVALUE = c.margin
where FNOIND = '' and ceiling(MAXIUMVALUE) between  50 and 99 and  
(CAT not like 'A%' OR CAT not like 'B%' OR CAT not like 'Q%') and BASE = 999 

-------------------Coorpoate Action list Updates ------------------------------------------------------

----USE Coorporate Action List.xlsx file (it dosent changes frequently)

--Select 
--* from CoorporateAction where 
--convert(varchar,Currentdate ,112) <=convert(varchar,Getdate() ,112) order by Currentdate desc

UPDATE FinalScriptCategory
SET REMARKS = 'CoorporateAction'
from FinalScriptCategory f inner join CoorporateAction c on f.ISINNO = c.ISIN
 where 
convert(varchar,Currentdate ,112) <=convert(varchar,Getdate() ,112) 


UPDATE FinalScriptCategory
SET MAXCAT = 100
where REMARKS = 'CoorporateAction' and MAXCAT <>100

UPDATE FinalScriptCategory
SET CAT1NEW = 'D'
where REMARKS = 'CoorporateAction' and  CAT1NEW  not in('D','E')

UPDATE FinalScriptCategory
SET MAXIUMVALUE = 100
where REMARKS = 'CoorporateAction' and MAXIUMVALUE <>100

UPDATE FinalScriptCategory
SET NEWCAT = 'D'
where REMARKS = 'CoorporateAction' and  NEWCAT  not in('D','E')


select * from FinalScriptCategory 
--where REMARKS = 'CoorporateAction'
--where MAXIUMVALUE  <> 50 and NEWCAT like 'C%'
 Order by FNOIND desc 

