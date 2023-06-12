

with
varvalues as (
select   FNOIND, m1.[ scripcode], case 
when tf.FNOIND  ='IND' then ceiling((vr.VAR + vr.ELM*3 + vr.ADDI) + 5  )
when tf.FNOIND  ='FNO' then ceiling((vr.VAR + vr.ELM*3 + vr.ADDI) + 5  )
else ceiling ( (vr.VAR + vr.ELM*5 + vr.ADDI) + 5 )
end as 'var+el+adii' from marginreport m1 
left   join tokeninfo tf on m1.[ scripcode] = tf.TOKEN 
inner  join [dbo].[NSEM] ns on m1.[ scripcode] = ns.Token
inner join VARreport vr on m1.ISINNO = vr.ISINNO
 where ns.series not in ('BE','BO','BZ','BT','IT','SM','SG','ST','SZ') 
),

 fnovalues as ( select   m2.[ scripcode],(sp.[SPANMgn%] +sp.[ExpMgn%]+sp.[AddExpMgn%]) *100 as 'FNOMAR'
 from marginreport m2
left   join tokeninfo tf on m2.[ scripcode] = tf.TOKEN 
inner  join [dbo].[NSEM] ns on m2.[ scripcode] = ns.Token
left join spanreport sp on m2.[ Scrip_Name] = sp.Symbol
where ns.series not in ('BE','BZ','BO','BT','IT','SM','SG','ST','SZ') 
),

maxvalue as (
select   m3.[ scripcode],FNOIND,
case when 
FNOIND = 'IND' then 25 when 
FNOIND = 'FNO' then 30 
else 38
end as 'maxvalues'
from marginreport m3 
left   join tokeninfo tf on m3.[ scripcode] = tf.TOKEN 
inner  join [dbo].[NSEM] ns on m3.[ scripcode] = ns.Token
where ns.series not in ('BE','BZ','BT','BO','IT','SM','SG','ST','SZ')
),

imvalue as (select  m4.[ scripcode],
Case
when m4.[ Category] = 'A' and m4.[ Category] like 'A%' then (vr.VAR + vr.ELM + 5) 
when m4.[ Category] = 'B' and m4.[ Category] like 'B%' then (vr.VAR + vr.ELM + 5) 
when m4.[ Category] = 'Q' and m4.[ Category] like 'Q%' then (vr.VAR + vr.ELM + 5) 
when m4.[ Category] = 'C' and m4.[ Category] like 'C%' then (vr.VAR + vr.ELM + vr.ADDI+  5)
when m4.[ Category] = 'D'  then (vr.VAR + vr.ELM + vr.ADDI+  5)
when m4.[ Category] = 'E'  then (vr.VAR + vr.ELM + vr.ADDI+  5)
else NULL 
end as 'I_M'
from marginreport m4
inner  join [dbo].[NSEM] ns on m4.[ scripcode] = ns.Token
inner join VARreport vr on m4.ISINNO = vr.ISINNO
 where ns.series not in ('BE','BZ','BT','BO','IT','SM','SG','ST','SZ') 
 ),

maxcatnew as (
select   m5.[ scripcode],FNOIND,
case when 
FNOIND = 'IND' then 20  when FNOIND= 'FNO' then 25
else 0
end as 'maxcat'
from marginreport m5 
left   join tokeninfo tf on m5.[ scripcode] = tf.TOKEN 
inner  join [dbo].[NSEM] ns on m5.[ scripcode] = ns.Token
where ns.series not in ('BE','BZ','BT','IT','SM','SG','ST','SZ')
) 
select distinct   ROW_NUMBER() over (Partition by m.ISINNO order by tf.FNOIND) as 'rownn',
tf.FNOIND as 'FNOIND',Rtrim(m.[ Category1]) as 'CAT_1',
m.ISINNO,m.[ scripcode] as 'scripcode',
Rtrim([ Scrip_Name])+ ns.Series as 'Symbol Series',
ns.Series,
Rtrim(m.[ Category]) as 'CAT',
(Case when (m.[ Category] in ('C','D','E') or m.[ Category] like 'C_%_%' ) then 999 else ca.Margin end) as 'BASE',
case when ns.Series in ('GS','GB') and b1.TOTTRDQTY is null then   0
else b1.TOTTRDQTY
end as 'T-4V',
case when ns.Series in ('GS','GB') and b2.TOTTRDQTY is null then   0
else b2.TOTTRDQTY
end as 'T-3V',
case when ns.Series in ('GS','GB') and b3.TOTTRDQTY is null then   0
else b3.TOTTRDQTY
end as 'T-2V',
case when ns.Series in ('GS','GB') and b4.TOTTRDQTY is null then   0
else b4.TOTTRDQTY
end as 'T-1V',
case when ns.Series in ('GS','GB') and b5.TOTTRDQTY is null then   0
else b5.TOTTRDQTY
end as 'T',
--b2.TOTTRDQTY as 'T-3V',
--b3.TOTTRDQTY as 'T-2V',
--b4.TOTTRDQTY as 'T-1V',
--b5.TOTTRDQTY as 'T', 
b3.[CLOSE] as 'T-2Rate',
b4.[CLOSE] as 'T-1Rate',
b5.[CLOSE] as 'TRate',
round ((abs((b5.[CLOSE]-b4.[CLOSE])/b5.[CLOSE]))* 100 ,3 ) as '1Day', --ABS((P1-O1)/P1)*100
round ((abs((b5.[CLOSE]-b3.[CLOSE])/b5.[CLOSE]))* 100 , 3 ) as '2Day', --ABS((P1-N1)/P1)*100
--,case 
--when ns.Series not in ('GS','GB') then (b1.TOTTRDQTY+b2.TOTTRDQTY+b3.TOTTRDQTY+b4.TOTTRDQTY+b5.TOTTRDQTY)/5
--when  b1.TOTTRDQTY <> 0 OR  b1.TOTTRDQTY = 0  then   (b1.TOTTRDQTY+b2.TOTTRDQTY+b3.TOTTRDQTY+b4.TOTTRDQTY+b5.TOTTRDQTY)/5
--when  b2.TOTTRDQTY <> 0 OR  b2.TOTTRDQTY = 0  then (b1.TOTTRDQTY+b2.TOTTRDQTY+b3.TOTTRDQTY+b4.TOTTRDQTY+b5.TOTTRDQTY)/5
--when  b3.TOTTRDQTY <> 0 OR  b3.TOTTRDQTY = 0  then  (b1.TOTTRDQTY+b2.TOTTRDQTY+b3.TOTTRDQTY+b4.TOTTRDQTY+b5.TOTTRDQTY)/5
--when  b4.TOTTRDQTY <> 0 OR  b4.TOTTRDQTY = 0  then  (b1.TOTTRDQTY+b2.TOTTRDQTY+b3.TOTTRDQTY+b4.TOTTRDQTY+b5.TOTTRDQTY)/5
--when  b5.TOTTRDQTY <> 0 OR  b5.TOTTRDQTY = 0  then  (b1.TOTTRDQTY+b2.TOTTRDQTY+b3.TOTTRDQTY+b4.TOTTRDQTY+b5.TOTTRDQTY)/5

--else  (b1.TOTTRDQTY+b2.TOTTRDQTY+b3.TOTTRDQTY+b4.TOTTRDQTY+b5.TOTTRDQTY)/5
--end as 'AVERAGEs',---=IF(F1<>"GB",IF(F1<>"GS",SUM(J1:N1)/5,SUMIF(J1:N1,"<>#N/A")/5),SUMIF(J1:N1,"<>#N/A")/5)
case 
--when ns.Series not in ('GS','GB') then (b1.TOTTRDQTY+b2.TOTTRDQTY+b3.TOTTRDQTY+b4.TOTTRDQTY+b5.TOTTRDQTY)/5
when  b1.TOTTRDQTY <> 0 OR  b1.TOTTRDQTY = 0  then   (b1.TOTTRDQTY+b2.TOTTRDQTY+b3.TOTTRDQTY+b4.TOTTRDQTY+b5.TOTTRDQTY)/5
when  b2.TOTTRDQTY <> 0 OR  b2.TOTTRDQTY = 0  then (b1.TOTTRDQTY+b2.TOTTRDQTY+b3.TOTTRDQTY+b4.TOTTRDQTY+b5.TOTTRDQTY)/5
when  b3.TOTTRDQTY <> 0 OR  b3.TOTTRDQTY = 0  then  (b1.TOTTRDQTY+b2.TOTTRDQTY+b3.TOTTRDQTY+b4.TOTTRDQTY+b5.TOTTRDQTY)/5
when  b4.TOTTRDQTY <> 0 OR  b4.TOTTRDQTY = 0  then  (b1.TOTTRDQTY+b2.TOTTRDQTY+b3.TOTTRDQTY+b4.TOTTRDQTY+b5.TOTTRDQTY)/5
when  b5.TOTTRDQTY <> 0 OR  b5.TOTTRDQTY = 0  then  (b1.TOTTRDQTY+b2.TOTTRDQTY+b3.TOTTRDQTY+b4.TOTTRDQTY+b5.TOTTRDQTY)/5

else  (b1.TOTTRDQTY+b2.TOTTRDQTY+b3.TOTTRDQTY+b4.TOTTRDQTY+b5.TOTTRDQTY)
end as 'AVERAGES '
,vr.VAR as 'VAR',
vr.ELM as 'ELM',
vr.ADDI as 'ADDI',
v.[var+el+adii],---=ROUNDUP(U1+IF(A1="IND",3*V1,IF(A1="FNO",3*V1+0,5*V1+0))+W1,0)+5
sp.[SPANMgn%] ,
sp.[ExpMgn%],
sp.[AddExpMgn%],
f.FNOMAR,--=(Y1+Z1+AA1)*100
case when 
mx.maxvalues> v.[var+el+adii] and mx.maxvalues > f.FNOMAR then mx.maxvalues
when v.[var+el+adii] > mx.maxvalues and v.[var+el+adii] > f.FNOMAR then v.[var+el+adii]
when  f.FNOMAR > v.[var+el+adii]and  f.FNOMAR >mx.maxvalues then  f.FNOMAR
when m.[ Category] ='C' and m.[ Category] like 'C%' then 50
when m.[ Category] ='D' and m.[ Category] like 'D%' then 100
when m.[ Category] ='E' and m.[ Category] like 'E%' then 100
else 38
end as 'MAXIUMVALUE',--=ROUNDUP(MAX(X1,IF(A1="IND",25,IF(A1="FNO",30,38)),AB1),0)
Rtrim(m.[ Category]) as 'NewCAT',
bs.ScripCode as 'BSECode',
bs.ScripId as 'scripNameBSE',
im.I_M,--for a,b,q ( var+elm+5) , for C,D,E(var + elm+Addi+5)
case when im.I_M > mxc.maxcat then ceiling( im.I_M) when 
mxc.maxcat > im.I_M then round(mxc.maxcat,0)
 
else ''
end as 'MAXCAT',--=ROUNDUP(MAX(AH1,IF(A1="IND",20,25)),0)
Rtrim(m.[ Category1]) as 'NEWCAT1',
case when sd.F23 in (11,12,13,14,15,16,20,21,22,33) then sd.F23 else ''end as 'ASM FLAG'
into  #temp1
from varvalues v inner join fnovalues f on v.[ scripcode] = f.[ scripcode]
inner join maxvalue mx on v.[ scripcode] = mx.[ scripcode]
inner join imvalue im on v.[ scripcode] = im.[ scripcode]
inner join maxcatnew mxc on v.[ scripcode] = mxc.[ scripcode]
--inner join AVERAGEs avgs on v.[ scripcode] = avgs.[ scripcode]
inner join  marginreport m on v.[ scripcode]  = m.[ scripcode]
left   join tokeninfo tf on m.[ scripcode] = tf.TOKEN 
inner  join [dbo].[NSEM] ns on m.[ scripcode] = ns.Token
inner join  [catM] ca on m.[ Category] = ca.Category
inner join securitydata sd on m.[ scripcode] = sd.NEATCM
left join [dbo].[bhav1] b1 on m.ISINNO = b1.ISIN  
left join [dbo].[bhav2] b2 on m.ISINNO = b2.ISIN
left join [dbo].[bhav3] b3 on m.ISINNO = b3.ISIN
left join [dbo].[bhav4] b4 on m.ISINNO = b4.ISIN
left  join   [dbo].[bhav6] b5 on m.[ Scrip_Name] = b5.SYMBOL 
inner join VARreport vr on m.ISINNO = vr.ISINNO
left join spanreport sp on m.[ Scrip_Name] = sp.Symbol
left  join   BSEM bs on m.ISINNO = bs.ISIN 
where ns.series not in ('BE','BO''BZ','BT','IT','SM','SG','ST','SZ') and 

vr.series not in ('BE','BO''BZ','BT','IT','SM','SG','ST','SZ') 
--and ns.Series in ('GB')
--and m.ISINNO = 'INE548C01032'
--and tf.FNOIND ='FNO'
order by  tf.FNOIND desc 

select * from #temp1

where rownn  =1 
order by FNOIND desc 


--select Distinct SYMBOL from bhav6 c inner join marginreport m
--on c.SYMBOL = m.[ Scrip_Name]

--select * from bhav6

--truncate table bhav6


--truncate table spanreport 