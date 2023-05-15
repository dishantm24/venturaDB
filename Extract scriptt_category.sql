--select Rtrim(s.category1) As Cat_1, s.ISINNo, s.scripcode, rtrim(s.name)+s.series
--as SymbolSeries, s.series, Rtrim(s.category) as Cat ,
--(case when (s.category in ('C','D','E') or s.category like 'C_%_%' ) 
--then 999 else c.buymgn*100 end) as catM,
--(case when S.GSMFlag in (11,12,13,14,15,16,20,21,22,33) then S.GSMFlag  else '' end) 
--as ASM_FLAG  ---ASM Flag
--from scripmaster s inner join Scripcategory c on s.category=c.category
-- where series not in ('BE','BZ','BT','IT','SM','SG','ST','SZ') and
--exch = 'N' and  exchtype = 'C'  and scripcode in (...)


--FNO :  tokeninfo
--Cat_1 :  marginreport
--ISINNo :  marginreport
--scripcode :   marginreport
--SymbolSeries :  marginreport +   [NSEM_0905]
--series:   [NSEM_0905]
--base : CATM + marginreport
--buymgn : category margin 
--GSMFlag  : f23 from securitydata
--TOTTRDQTY--from bhavreport
--CLOSE--bhavreport
---var,elm,adii: varreport

--T-4V  0305  T-3V  0405, T-2V  0505,T-1V  0805,TV 0905***  : Total from BHav files 
--T-2Rate  0505	T-1Rate  0805	Trate  0905 : closing rate from Bhva files 
 


-- DECLARE @max1 AS int SET @max1 = 25
-- declare @max2 as int  set  @max2 = 38
 

--PRINT @TestVariable
--with casevar1 as(

--select F3,
--case when tf.F3 = 'IND' then 25 
--when tf.F3 = 'FNO' then 30 
--else 38
--end as 'value'
--from tokeninfo tf
--) 
--select * from casevar1;

with varvalues as (

select  F3, m.[ scripcode], case 
when tf.F3  ='IND' then ceiling((vr.VAR + vr.ELM*3 + vr.ADDI) + 5  )
when tf.F3  ='FNO' then ceiling((vr.VAR + vr.ELM*3 + vr.ADDI) + 5  )
else ceiling ( (vr.VAR + vr.ELM*5 + vr.ADDI) + 5 )
end as 'var+el+adii' from marginreport m 
left   join tokeninfo tf on m.[ scripcode] = tf.TOKEN 
inner join [dbo].[NSEM_0905] ns on m.[ scripcode] = ns.Token
inner join VARreport vr on m.ISINNO = vr.ISINNO
 where ns.series not in ('BE','BZ','BT','IT','SM','SG','ST','SZ') 
)
,
 fnovalues as ( select  m.[ scripcode],(sp.[SPANMgn%] +sp.[ExpMgn%]+sp.[AddExpMgn%]) *100 as 'FNOMAR'
 from marginreport m 
left   join tokeninfo tf on m.[ scripcode] = tf.TOKEN 
inner join [dbo].[NSEM_0905] ns on m.[ scripcode] = ns.Token
left join spanreport sp on m.[ Scrip_Name] = sp.Symbol
where ns.series not in ('BE','BZ','BT','IT','SM','SG','ST','SZ') 
),

maxvalue as (
select m.[ scripcode],F3,

case when 
F3 = 'IND' then 25 when 
F3 = 'FNO' then 30 
else 38
end as 'maxx'
from marginreport m 
left   join tokeninfo tf on m.[ scripcode] = tf.TOKEN 
inner join [dbo].[NSEM_0905] ns on m.[ scripcode] = ns.Token
where ns.series not in ('BE','BZ','BT','IT','SM','SG','ST','SZ') )


select * from varvalues v inner join fnovalues f on v.[ scripcode] = f.[ scripcode]
inner join maxvalue m on v.[ scripcode] = m.[ scripcode]



select    Distinct top 10   tf.F3 as 'FNO/IND',Rtrim(m.[ Category1]) as 'CAT_1',
m.ISINNO,m.[ scripcode] as 'scripcode',
Rtrim([ Scrip_Name])+ ns.Series as 'Symbol Series',
ns.Series,
Rtrim(m.[ Category]) as 'CAT',
(Case when (m.[ Category] in ('C','D','E') or m.[ Category] like 'C_%_%' ) then 999 else ca.Margin end) as 'BASE',
case when sd.F23 in (11,12,13,14,15,16,20,21,22,33) then sd.F23 else ''end as 'ASM FLAG',
b4.TOTTRDQTY as 'T-4V',
b5.TOTTRDQTY as 'T-3V',
b8.TOTTRDQTY as 'T-2V',
b9.TOTTRDQTY as 'T-1V',
b10.TOTTRDQTY as 'T', 
b8.[CLOSE] as 'T-2Rate',
b9.[CLOSE] as 'T-1Rate',
b10.[CLOSE] as 'TRate',
round ((abs((b10.[CLOSE]-b9.[CLOSE])/b10.[CLOSE]))* 100 , 5 ) as '1Day', --ABS((P1-O1)/P1)*100
round ((abs((b10.[CLOSE]-b8.[CLOSE])/b10.[CLOSE]))* 100 , 5 ) as '2Day' --ABS((P1-N1)/P1)*100
,case 
when ns.Series not in ('GS','GB') then (b4.TOTTRDQTY+b5.TOTTRDQTY+b8.TOTTRDQTY+b9.TOTTRDQTY+b10.TOTTRDQTY)/5
when  b4.TOTTRDQTY <> NULL  then (b4.TOTTRDQTY+b5.TOTTRDQTY+b8.TOTTRDQTY+b9.TOTTRDQTY+b10.TOTTRDQTY)/5
when  b5.TOTTRDQTY <> NULL  then (b4.TOTTRDQTY+b5.TOTTRDQTY+b8.TOTTRDQTY+b9.TOTTRDQTY+b10.TOTTRDQTY)/5
when  b8.TOTTRDQTY <> NULL  then (b4.TOTTRDQTY+b5.TOTTRDQTY+b8.TOTTRDQTY+b9.TOTTRDQTY+b10.TOTTRDQTY)/5
when  b9.TOTTRDQTY <> NULL  then (b4.TOTTRDQTY+b5.TOTTRDQTY+b8.TOTTRDQTY+b9.TOTTRDQTY+b10.TOTTRDQTY)/5
when  b10.TOTTRDQTY <> NULL then (b4.TOTTRDQTY+b5.TOTTRDQTY+b8.TOTTRDQTY+b9.TOTTRDQTY+b10.TOTTRDQTY)/5
else Null 
end as 'AVERAGEs',
vr.VAR as 'VAR',
vr.ELM as 'ELM',
vr.ADDI as 'ADDI',

case 
when tf.F3  ='IND' then ceiling((vr.VAR + vr.ELM*3 + vr.ADDI) + 5  )
when tf.F3  ='FNO' then ceiling((vr.VAR + vr.ELM*3 + vr.ADDI) + 5  )
else ceiling ( (vr.VAR + vr.ELM*5 + vr.ADDI) + 5 )
end as 'var+el+adii',

sp.[SPANMgn%] ,
sp.[ExpMgn%],
sp.[AddExpMgn%],
(sp.[SPANMgn%] +sp.[ExpMgn%]+sp.[AddExpMgn%]) *100 as 'FNOMAR'

--case when 
--tf.F3 = 'IND'  and 
from marginreport m 
left   join tokeninfo tf on m.[ scripcode] = tf.TOKEN 
inner join [dbo].[NSEM_0905] ns on m.[ scripcode] = ns.Token
inner join [catM] ca on m.[ Category] = ca.Category
inner join securitydata sd on m.[ scripcode] = sd.NEATCM
left join [dbo].[bhav0405] b4 on m.ISINNO = b4.ISIN  
left join [dbo].[bhav0505] b5 on m.ISINNO = b5.ISIN
left join [dbo].[bhav0805] b8 on m.ISINNO = b8.ISIN
left join [dbo].[bhav0905] b9 on m.ISINNO = b9.ISIN
left join [dbo].[bhav1005] b10 on m.ISINNO = b10.ISIN
inner join VARreport vr on m.ISINNO = vr.ISINNO
left join spanreport sp on m.[ Scrip_Name] = sp.Symbol

where ns.series not in ('BE','BZ','BT','IT','SM','SG','ST','SZ') 

order by  tf.F3  desc 


=ROUNDUP(MAX(X1,IF(A1="IND",25,IF(A1="FNO",30,38)),AB1),0)

x1 = var+adii+elm
a1 = f3
ab1 = fnomar v

max(14,25,30)
--=ROUNDUP(U1+IF(A1="IND",3*V1,IF(A1="FNO",3*V1+0,5*V1+0))+W1,0)+5
--=ROUNDUP(U1+IF(A1="IND",3*V1,IF(A1="FNO",3*V1+0,5*V1+0))+W1,0)+5

--u1 = var,a1 = ind/fno

--= Roundup(VAR+ (if Index scrip then 3 else 
--		If FNO scrip then 3 else
--		rest if category is not (C_%_%,D,E) then 5 ) * ELM
--		+ Addi
--		+ Cousion %
--		If C_%_%,D or E then
--		rouundup (VAR+ELM+Addi + + Cousion,50),0

--And same time If Index then Min 25,
--		If FNO then Min 30,
--		Rest Bxx will be Min 38
--		C_%_%,D,E min 50

select top 1 *  from spanreport
select top 1 * from marginreport

select top 1 * from VARreport
--select * from securitydata

--select * from[dbo].[CATM] 

--alter table [bhav0405]
--add TOTALTRDQTY INT
--select * from [dbo].[bhav0405] where ISIN = 'INE001A01036'

--select [ Category1],* from marginreport

 
-- select top 1  * from [dbo].[NSEM_0905]

-- select   * from [dbo].[BSEM_0905]



--select top 1  * from marginreport order  by 1 

--select top 1 *  from tokeninfo

 
