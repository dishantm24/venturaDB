
---backup of the file
Truncate venturaDb..HoldingsFile_backup

insert into venturaDb..HoldingsFile_backup (select * from  HoldingsFile )

----drop the table if exsist 

IF EXISTS (Select * from venturaDb..HoldingsData) 
Begin 

DROP table venturaDb..HoldingsData

END

----Insert into final table from the original table  

select  ROW_NUMBER () over ( order by column1)as
'RowNUMBER',* into venturaDb..HoldingsData
from HoldingsFile



--Sorting data 

---1
Select column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,
column13,column14,column15,column16
from venturaDb..HoldingsData
where RowNUMBER between 1 and 99999
order by RowNUMBER 

----- 2
Select column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,
column13,column14,column15,column16
from venturaDb..HoldingsData
where RowNUMBER between 100000 and 199998
order by RowNUMBER 

---3
Select column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,
column13,column14,column15,column16
from venturaDb..HoldingsData
where RowNUMBER between 199999 and 299997
order by RowNUMBER 

--4
Select column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,
column13,column14,column15,column16
from venturaDb..HoldingsData
where RowNUMBER  between 299998 and 399996
order by RowNUMBER 


--5
Select column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,
column13,column14,column15,column16
from venturaDb..HoldingsData
where RowNUMBER  between 399997 and 499995
order by RowNUMBER 

--6

Select column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,
column13,column14,column15,column16
from venturaDb..HoldingsData
where RowNUMBER  between 499996 and 599994
order by RowNUMBER 

--7

Select column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,
column13,column14,column15,column16
from venturaDb..HoldingsData
where RowNUMBER  between 599995 and 699993
order by RowNUMBER 

--8

Select column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,
column13,column14,column15,column16
from venturaDb..HoldingsData
where RowNUMBER  between 699994 and 799992
order by RowNUMBER 

--9

Select column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,
column13,column14,column15,column16
from venturaDb..HoldingsData
where RowNUMBER  between 799993 and 899991
order by RowNUMBER 


--10

Select column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,
column13,column14,column15,column16
from venturaDb..HoldingsData
where RowNUMBER  between 899992 and 999990
order by RowNUMBER 

--11

Select column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,
column13,column14,column15,column16
from venturaDb..HoldingsData
where RowNUMBER  between 999991 and 1099989
order by RowNUMBER 

--12

Select column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,
column13,column14,column15,column16
from venturaDb..HoldingsData
where RowNUMBER  between 1099990 and 1199988
order by RowNUMBER 


--13

Select column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,
column13,column14,column15,column16
from venturaDb..HoldingsData
where RowNUMBER  between 1199989 and 1299987
order by RowNUMBER 

--14

Select column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,
column13,column14,column15,column16
from venturaDb..HoldingsData
where RowNUMBER  between 1299988 and 1399986
order by RowNUMBER 


--15

Select column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,
column13,column14,column15,column16
from venturaDb..HoldingsData
where RowNUMBER  between 1399987 and 1499985
order by RowNUMBER 



--16

Select column1,column2,column3,column4,column5,column6,column7,column8,column9,column10,column11,column12,
column13,column14,column15,column16
from venturaDb..HoldingsData
where RowNUMBER  > 1499985
order by RowNUMBER 





