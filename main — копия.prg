CLEAR

SET DATE GERMAN
SET CENTURY on
SET HOURS TO 24 

Declare Integer GetPrivateProfileString In Win32API  As GetPrivStr ;    
	  	String cSection, ;		&& ��� �������  
	  	String cKey, ;		&& ��� ���������  
	  	String cDefault, ;		&& �������� �� ���������, ���� ��� ���������� ������� ��� ���������  
	  	String @cBuffer, ;		&& ���������� ��������� �������� ���������  
	  	Integer nBufferSize, ;	&& ������������ ���������� �������� � ��������� ���������  
	  	String posfile		&& ��� ini-����� � ������ ����� �������  
	    
	 
	lcBuffer1 = SPACE(200)
	lcbf='lcBuffer1 = SPACE(200)'

	
	nn = GetPrivStr("���������", "server", "��� ��������", @lcBuffer1,100, Fullpath("SQL_CONNECTION.ini"))
	lcBuffer1 = left( lcBuffer1, m.nn )
	srvr=lcBuffer1
	&lcbf
	
	
	nn = GetPrivStr("���������", "user", "��� ��������", @lcBuffer1,100, Fullpath("SQL_CONNECTION.ini"))
	lcBuffer1 = left( lcBuffer1, m.nn )
	usr=lcBuffer1
	&lcbf
	
	nn = GetPrivStr("���������", "pass", "��� ��������", @lcBuffer1,100, Fullpath("SQL_CONNECTION.ini"))
	lcBuffer1 = left( lcBuffer1, m.nn )
	pswd=lcBuffer1
	&lcbf



IF ! FILE('log.txt')
	= FCREATE('log.txt',0)
	= FCLOSE('log.txt')  
ELSE
	= FCLOSE('log.txt')  
ENDIF


For i = 1 to ALines(lines_, FileToStr('sql_databases.txt'), 4, Chr(10), Chr(13))
	strToConnect = "Driver=SQL Server;Server="+srvr+";Database="+lines_[i]+";Uid="+usr+";Pwd="+pswd+";"
	
	gncn_sql = SQLSTRINGCONNECT(strToConnect)

	IF gncn_sql < 0
	   = MESSAGEBOX('�� ���� ����������� � MSSQL SERVER', 16, '��������!!!')
	   RETURN
	ENDIF
	*MESSAGEBOX('OK')
	
*!*			?'��� ����� '+lines_[i]+' ��������� ��������� �������:'
*!*			sizedbSTEP=1 
*!*			For j = 1 to ALines(line_, FileToStr('sql_commands.txt'), 4, Chr(10), Chr(13))
*!*				komanda=STRTRAN(line_[j],'d-b-x',lines_[i])
*!*			    IF ALLTRIM(LEFT(komanda,1))<>'*'
				    = SQLEXEC(gncn_sql,'SELECT * FROM ART', 'gett')
				    select * from gett
				    *SELECT * FROM gett_inf
*!*					?komanda
*!*					IF LIKE('*EXEC sp_helpdb*',komanda)
*!*						IF sizedbSTEP=1 
*!*							ART=" �� "
*!*						ELSE
*!*							ART=" ����� "
*!*						ENDIF
*!*						SELECT VAL(GETWORDNUM(size,1))/1024 AS size FROM Sqlresult1 INTO CURSOR sizedb
*!*						sizedbsize = " - ������ ��"+ART+STR(sizedb.size)+" ��"
*!*						=strtofile(ttoc(DATETIME())+ sizedbsize + CHR(13) + CHR(10), 'log.txt',1)
*!*						?sizedbsize
*!*						sizedbSTEP=sizedbSTEP+1  
*!*						
*!*					ENdif
*!*					=strtofile(ttoc(DATETIME())+' - '+lines_[i]+ ' - '+komanda + CHR(13) + CHR(10), 'log.txt',1)

*!*	    		endif
*!*			    
*!*			EndFor 
*!*			sizedbSTEP=0
		= SQLDISCONNECT(gncn_sql)
		
EndFor 

