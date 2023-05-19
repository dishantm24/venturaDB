
---backup of the file
Truncate venturaDb..HoldingsFile_backup

insert into venturaDb..HoldingsFile_backup (select * from  HoldingsFile )

----drop the table if exsist 

IF EXISTS (Select * from venturaDb..HoldingsData) 
Begin 

DROP table venturaDb..HoldingsData

END

----Insert into final table from the original table  

select  ROW_NUMBER () over ( order by column1)as 'RowNUMBER',* into venturaDb..HoldingsData
from HoldingsFile



--Sorting data 

---1
Select column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,
column13,column14,column15,column16
from venturaDb..HoldingsData
where RowNUMBER between 1 and 499999
order by RowNUMBER 

----- 2
Select column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,
column13,column14,column15,column16
from venturaDb..HoldingsData
where RowNUMBER between 500000 and 999998
order by RowNUMBER 

---3
Select column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,
column13,column14,column15,column16
from venturaDb..HoldingsData
where RowNUMBER between 999999 and 1499997
order by RowNUMBER 

--4
Select column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,
column13,column14,column15,column16
from venturaDb..HoldingsData
where RowNUMBER  > 1499998
order by RowNUMBER 



