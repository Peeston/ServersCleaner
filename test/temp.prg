*!*	SELECT DISTINCT ��������� as kod, ����� as tovar, 0000 as orig FROM czn WHERE ! EMPTY(���������) ORDER BY ���������, ����� desc   INTO CURSOR t1 READWRITE 
*!*	SELECT SUM(1) as kol, ��������� as kod  FROM czn GROUP BY ���������  INTO CURSOR koll

*!*	SELECT t1

*!*	thisTov=''
*!*	i=0

*!*	SCAN
*!*		
*!*		
*!*		IF thisTov=t1.kod
*!*			i=i+1
*!*		ELSE
*!*			i=1
*!*		endif
*!*		
*!*		replace t1.orig WITH i
*!*		thistov=t1.kod
*!*	ENDSCAN

*!*	SELECT t1.kod, descr, koll.kol  FROM t1;
*!*	 LEFT JOIN koll ON t1.kod=koll.kod;
*!*	 LEFT JOIN sprTov ON VAL(t1.kod)=VAL(code) WHERE orig=1 ORDER BY kol desc INTO TABLE fin 

*!*	 SELECT fin
*!*	use 
*!*	SELECT czn
*!*	use


CLEAR 
SET DATE GERMAN


thisVal=3

thisDayO=DAY(DATE())
thisMonO=Month(DATE())
thisYear=Year(DATE())

thisDay=IIF(thisDayO>9,ALLTRIM(STR(thisDayO)),'0'+ALLTRIM(STR(thisDayO)))
thisMon=IIF(thisMonO>9,ALLTRIM(STR(thisMonO)),'0'+ALLTRIM(STR(thisMonO)))
thisYearO=ALLTRIM(STR(Year(DATE())))


DO case
	CASE thisVal=1
		period_1=thisYearO+thisMon+thisDay+'000000'
		period_2=thisYearO+thisMon+thisDay+'235959'
		
	CASE thisVal=2
			period_1=thisYearO+thisMon+'01000000'
			
			m.D=CTOD('01/'+ThisMon+'/'+thisYearO)
			m.M=MONTH(GOMONTH(D-DAY(D)+1,1)-1)
			m.D=day(GOMONTH(D-DAY(D)+1,1)-1)
			valMon=IIF(m.M>9,ALLTRIM(STR(m.M)),'0'+ALLTRIM(STR(m.M)))
			valDay=IIF(m.D>9,ALLTRIM(STR(m.D)),'0'+ALLTRIM(STR(m.D)))
			period_2=thisYearO+valMon+valDay+'235959'
	
	CASE thisVal=3
			period_1=thisYearO+'0101000000'
			period_2=thisYearO+'1231235959'
ENDCASE


?period_1

?period_2