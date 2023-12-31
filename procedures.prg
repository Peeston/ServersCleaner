**
Procedure set_init
	Set Deleted On
	Set Century On
	Set Talk Off
	Set Date German
	Set Exclusive Off
	Codepage = 866
	error_kod = 0
*	If File('init.dbf')=.F.
*		Do error_wotch With 1, '���� Init.dbf �� ������ � �������� ���������!'
*	Endif
*	If Used('init')=.F.
*		Use Init.Dbf In 0
*	Endif
*	Select Init
*	Locate For Id='PATH'
*	If Found()=.F.
*		Do error_wotch With 2, '� ����� Init.dbf �� ������ ���� � ��!'
*	Endif
*	t_path = Alltrim(Init.String)
*	Set Path To &t_path
*	Locate For Id='YEAR'
*	If Found()=.F.
*		Do error_wotch With 3, '� ����� Init.dbf �� ������ ������� ���!'
*	Endif
*	_year = Init.String
	Return
Endproc
**
Procedure error_wotch
	Parameter error_kod, error_name
	If error_kod<>0

		m.lcTextWait = '��������, ������ #'+Alltrim(Str(error_kod))+' '+error_name
		Wait Window  m.lcTextWait Nowait At Srows()/2, Scols()/2-Len(m.lcTextWait)/2

		Close All
		Quit
	Endif
Endproc
**
Function name_mes
	Parameter tek_m
	Do Case
	Case tek_m=1
		tek_name = '������'
	Case tek_m=2
		tek_name = '�������'
	Case tek_m=3
		tek_name = '����'
	Case tek_m=4
		tek_name = '������'
	Case tek_m=5
		tek_name = '���'
	Case tek_m=6
		tek_name = '����'
	Case tek_m=7
		tek_name = '����'
	Case tek_m=8
		tek_name = '������'
	Case tek_m=9
		tek_name = '��������'
	Case tek_m=10
		tek_name = '�������'
	Case tek_m=11
		tek_name = '������'
	Case tek_m=12
		tek_name = '�������'
	Endcase
	Return tek_name
Endfunc
**
Function nom_mes
	Parameter Month
	Do Case
	Case Month=1 .Or. Month=3 .Or. Month=5 .Or. Month=7 .Or. Month=8 .Or. Month=10 .Or. Month=12
		kol_ch = 31
	Case Month=2
		If Mod(Val(_year), 4)=0
			kol_ch = 29
		Else
			kol_ch = 28
		Endif
	Otherwise
		kol_ch = 30
	Endcase
	Return kol_ch
Endfunc
**
Procedure set_filter_bath
	Parameter Filter
	Select bath_view
	Set Filter To &Filter
	t_filtr = Filter
	Sum sbath To filtr_summa
	Sum sbath For fl_repl=.T. To filtr_summa_r
	Sum sbath For fl_repl<>.T. To filtr_summa_nr
	Count To filtr_count
* GOTO TOP

	Return
Endproc
**

Function sum_kvit
	Parameters npach

	Select cur_kvit
	Set Filter To nbath=npach
	Count To kol_kvit

	If Empty(kol_kvit)
		kol_kvit=''
	Endif
	Select cur_kvit
	Set Filter To

	Return kol_kvit
Endproc

Procedure control_bath
	Parameter kod
	rsum = bath_view.sbath
	Do usefl With 'cur_kvit'
	Sum Summa To dosum For nbath=kod
	If rsum=dosum
		m.lcTextWait = '�� ����� �'+Alltrim(kod)+' ������� ('+Alltrim(Str(rsum, 10, 2))+'='+Alltrim(Str(dosum, 10, 2))+')'
		Wait Window  m.lcTextWait Nowait At Srows()/2, Scols()/2-Len(m.lcTextWait)/2
	Else
		m.lcTextWait = '�� ����� �'+Alltrim(kod)+' �� ������� ('+Alltrim(Str(rsum, 10, 2))+'<>'+Alltrim(Str(dosum, 10, 2))+') �� ������� '+Alltrim(Str(rsum-dosum, 10, 2))
		Wait Window  m.lcTextWait Nowait At Srows()/2, Scols()/2-Len(m.lcTextWait)/2
	Endif

	Select bath_view
	Return
Endproc
**
Procedure usefl
	Parameter filename
	If  .Not. Used(filename)
		If File(filename+'.dbf')=.T.
			Use &filename In 0 Shared
			Select &filename
		Else
			m.lcTextWait = '���� '+filename+' �� ������!'
			Wait Window  m.lcTextWait Nowait At Srows()/2, Scols()/2-Len(m.lcTextWait)/2
			Return
		Endif
	Else
		Select &filename
	Endif
	Return
Endproc
**
Function isCloseMonth
	Lparameters cur_mon

	tek_mon='M'+Alltrim(Str(cur_mon))
	Select monthes_lock
	tek_month_cl = monthes_lock.&tek_mon

	Select bath_view
	Return tek_month_cl
Endproc



Procedure otmena_raznoski
	Parameter DATA_B, DATA_E
******
*�������� ������ � NAS.DBF, ������� �� KVITREF.BDF, ������� ������� �������� �� BATH.DBF � CUR_KVIT.DBF.

*data_b='2022-08-01'
*data_e='2022-08-20'

	MES=Alltrim(Str(Val(Substr(DATA_B,6,2))))

	mes_m = 'M'+Alltrim(Str(Val(Substr(DATA_B,6,2))))


	Select monthes_lock
	Go Top
	If monthes_lock.&mes_m = .F.
		Messagebox("���� ����� ������! �������� �������� ������!",48,'��������')
		Return
	Endif

	Select nbath, sbath From bath_view Where  bath_view.fl_repl=.T. And dbath>={^&DATA_B} And dbath<={^&DATA_E} And ! Deleted() Into Cursor find_razn

	If _Tally=0
		Messagebox("��� ���������� ����� � ���� ������",48,'��������')
		Return
	Endif


	If Messagebox("�������� �������� �� "+MES+"-� �����",36)=7
		Return
	Endif

	m.lcTextWait = '���� ������...'
	Wait Window  m.lcTextWait Nowait At Srows()/2, Scols()/2-Len(m.lcTextWait)/2


	OPLATA='OP'+MES
	ZC1='ZC1_'+MES
	ZC2='ZC2_'+MES
	ZC3='ZC3_'+MES
	ZC4='ZC4_'+MES
	ZC5='ZC5_'+MES

	Update cur_kvit Set fl_repl=.F. Where dbath>={^&DATA_B} And dbath<={^&DATA_E} And ! Deleted()
*DELETE from cur_kvit WHERE dbath>={^&data_b} and dbath<={^&data_e}


	Update bath_view Set fl_repl=.F. Where dbath>={^&DATA_B} And dbath<={^&DATA_E} And ! Deleted()
*delete from bath WHERE dbath>={^&data_b} and dbath<={^&data_e}

*UPDATE pas set fl_repl=.F. WHERE dbath>={^&data_b} and dbath<={^&data_e} and ! DELETED()
*delete from pas WHERE dbath>={^&data_b} and dbath<={^&data_e}

	Delete From kvitref Where dbath>={^&DATA_B} And dbath<={^&DATA_E}

	Update nas;
		SET &OPLATA=0, &ZC1=0, &ZC2=0, &ZC3=0, &ZC4=0, &ZC5=0;
		WHERE ! Deleted()
******

*----������ � ���-----*
	Select find_razn
	Sum(sbath) To find_raznsbath
	Count To kolpa4

	mess_all = '�������� �������� '+Alltrim(Str(kolpa4))+' ����� �� ����� '+Alltrim(Str(find_raznsbath,10,2))+' �� '+MES+'-� �����'
	mess_all_2=mess_all
	If Len(Alltrim(mess_all))>97
		mess_all = Left(Alltrim(mess_all),97)+'...'
	Endif

	Insert Into log_view (datelog, Name, Month,ev_id, mesage) Values (Datetime(), mess_all, tek_month,5, mess_all_2)

	m.lcTextWait = '������'
	Wait Window  m.lcTextWait Nowait At Srows()/2, Scols()/2-Len(m.lcTextWait)/2

	Return
Endproc

Procedure GetBegEndMes
	tb_data = Ctod('01.'+Iif(tek_month<10, '0'+Alltrim(Str(tek_month)), Alltrim(Str(tek_month)))+'.'+Alltrim(Str(Year(Date()))))
	te_data = Ctod(Alltrim(Str(nom_mes(tek_month)))+'.'+Iif(tek_month<10, '0'+Alltrim(Str(tek_month)), Alltrim(Str(tek_month)))+'.'+Alltrim(Str(Year(Date()))))
Endproc

Procedure MonBack
	_Screen.ActiveForm.command1.Click
	On Key Label CTRL+RIGHTARROW Do MonForw
	If tek_month=1
		On Key Label CTRL+LEFTARROW mmm=''
	Else
		On Key Label CTRL+LEFTARROW Do MonBack
	Endif

Endproc

Procedure MonForw
	_Screen.ActiveForm.command2.Click
	On Key Label CTRL+LEFTARROW Do MonBack

	If tek_month=12
		On Key Label CTRL+RIGHTARROW mmm=''
	Else
		On Key Label CTRL+RIGHTARROW Do MonForw
	Endif

Endproc

Procedure MonCur
	_Screen.ActiveForm.button_curmon.Click
Endproc


Procedure RefreshButton
	_Screen.ActiveForm.refresh_button.Click
Endproc

Function ping
	Parameters pHOST
	Local I,J,K,K_OK,K_ERR
	If Parameters()<1
		pHOST='192.168.0.1'
	Endif
	Declare Integer IcmpCreateFile In icmp
	Declare Integer IcmpSendEcho In icmp Integer ID_ICMP, Integer IP_ADDR,;
		string @ReqData, Integer ReqSize, String @ReqOptions,;
		string @RepBuffer, Integer RepSize, Integer WaitTime
	Declare Integer IcmpCloseHandle In icmp Integer ID_icmp

	Declare Integer inet_addr In Ws2_32 String IPHOST

*********************************************************
	Store 0 To K_OK,K_ERR
	K=1

* set alternate to ping.log
* set alternate on
* set console off

* ? '�������� ����� c',pHOST,'������ �',datetime()
* ? replicate('-',70)
	For I=1 To K
*	Wait Window Str(I)+' / '+Str(K) Nowait
		J=hostping(pHOST)
		If J
			K_OK=K_OK+1
		Else
			K_ERR=K_ERR+1
		Endif
		J=Seconds()
		Do While Seconds()-J<0.1
		Enddo
	Next
*Wait Clear
* ? replicate('-',70)
* ? '�������� ����� c',pHOST,'�������� �',datetime()
* ? '   ���������� �������',K,'�� ��� ��������',K_OK,'��������',K_ERR
* ? replicate('-',70)
* ?

* close alternate
* set console on
	Return K_OK
Endfunc

Function getSett
	Parameters setName

	Select settings_v
	Locate For Name=setName
	If Found()
		STORE ALLTRIM(body) TO rez
	ELSE
		rez = '-NULL-'
	Endif
	Return rez
ENDFUNC

FUNCTION nextCode
	SET DELETED off
	SELECT MAX(code) as code FROM db_servers_view iNTO CURSOR maxcodes READWRITE
	INSERT INTO maxcodes SELECT MAX(code) FROM kass_view 
	SET DELETED on
	rez=0
	select maxcodes
	scan
		 rez = MAX(rez, code)
	endscan
	
	RETURN rez+1
	
ENDfunc

FUNCTION getEvModeName 
LPARAMETERS kod
*evMode - ��� �������: 0 - �����, 1 -  ��������, 2 - ������
	RETURN Icase(kod=1,'��������', kod=2,'������',kod=0,'')
ENDFUNC

FUNCTION retDateCountDays
	LPARAMETERS ddate
	IF EMPTY(ddate)
		RETURN ''
	else
		RETURN DTOC(ddate)+' ('+ALLTRIM(str(DATE()-ddate))+')'
	endif
	
ENDFUNC

FUNCTION DateTimeNumeric()
	ttime=TIME()
	dt=DTOC(DATETIME())
	RETURN VAL(ALLTRIM(SUBSTR(dt,7,4)+SUBSTR(dt,4,2)+SUBSTR(dt,1,2)+STRTRAN(ttime,':','')))
ENDFUNC


FUNCTION DateTimeChar()
	ttime=TIME()
	dt=DTOC(DATETIME())

	RETURN ALLTRIM(SUBSTR(dt,7,4)+SUBSTR(dt,4,2)+SUBSTR(dt,1,2)+STRTRAN(ttime,':',''))
ENDFUNC


FUNCTION TransformDateTimeChar()
	PARAMETERS dt
	RETURN LEFT(dt,4)+'-'+SUBSTR(dt,5,2)+'-'+SUBSTR(dt,7,2)+' '+SUBSTR(dt,9,2)+':'+SUBSTR(dt,11,2)+':'+SUBSTR(dt,13,2)
ENDFUNC


FUNCTION get_point_name()
	LPARAMETERS ppointkod
	
	SELECT sprPointsDepts_v
	LOCATE FOR pointkod=ppointkod

	RETURN sprPointsDepts_v.point
ENDFUNC 

FUNCTION checkStampFormat()
	LPARAMETERS thisStamp
	
	thisStamp=ALLTRIM(thisStamp)
	
	IF LEN(thisStamp)<>10 
		RETURN 0
	endif
		
	f4=LEFT(thisStamp,4)
	f6=right(thisStamp,6)
	
	FOR i=1 TO 4
		ch1=SUBSTR(f4,i,1)
		IF  BETWEEN(ASC(ch1),192,223) OR  BETWEEN(ASC(ch1),65,90)
		ELSE	
			RETURN 0
		endif
	ENDFOR
	
	FOR i=1 TO 6
		ch1=SUBSTR(f6,i,1)
		IF ! ISDIGIT(ch1)
			RETURN 0
		endif
	ENDFOR

	RETURN 1
		
ENDFUNC 

FUNCTION _PlayWave(lcWaveFile,lnPlayType) 

lnPlayType = IIF(TYPE("lnPlayType")="N",lnPlayType,1) 
DECLARE INTEGER PlaySound ; 
IN WINMM.dll ; 
STRING cWave, ; 
INTEGER nModule, ; 
INTEGER nType 
RETURN IIF(PlaySound(lcWaveFile,0,lnPlayType) = 1, .T., .F.) 


PROCEDURE expSettToXLS
	SELECT settings_v
	EXPORT TO settings TYPE xls
endproc