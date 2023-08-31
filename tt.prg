SELECT left(SALESEXTVA,30) as SALESEXTVA fROM SALESEXT 

*group by SALESEXTVA having count(*)>1

return



SELECT iif(SALESCANC=1 or SALESREFUN=1, -1,1) as ТипОперации, SALESEXTVA as АкцизМарка FROM SALESEXT;
left join sales	on sales.sessid=SALESEXT.sessid and sales.salesnum=SALESEXT.salesnum and sales.systemid=SALESEXT.systemid and SALES.SAREAID=SALESEXT.SAREAID;
left join SAREA on SALESEXT.SAREAID=SAREA.SAREAID;
where SALESEXTVA  in (SELECT SALESEXTVA fROM SALESEXT group by SALESEXTVA having count (*)>1)