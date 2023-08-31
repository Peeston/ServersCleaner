CLEAR

SET DATE GERMAN
SET CENTURY on
SET HOURS TO 24 

Declare Integer GetPrivateProfileString In Win32API  As GetPrivStr ;    
	  	String cSection, ;		&& Имя раздела  
	  	String cKey, ;		&& Имя реквизита  
	  	String cDefault, ;		&& Значение по умолчанию, если нет указанного раздела или реквизита  
	  	String @cBuffer, ;		&& Собственно считанное значение реквизита  
	  	Integer nBufferSize, ;	&& Максимальное количество символов в считанном реквизите  
	  	String posfile		&& имя ini-файла с полным путем доступа  
	    
	 
	lcBuffer1 = SPACE(200)
	lcbf='lcBuffer1 = SPACE(200)'

	
	nn = GetPrivStr("Параметры", "server", "Нет значения", @lcBuffer1,100, Fullpath("SQL_CONNECTION.ini"))
	lcBuffer1 = left( lcBuffer1, m.nn )
	srvr=lcBuffer1
	&lcbf
	
	
	nn = GetPrivStr("Параметры", "user", "Нет значения", @lcBuffer1,100, Fullpath("SQL_CONNECTION.ini"))
	lcBuffer1 = left( lcBuffer1, m.nn )
	usr=lcBuffer1
	&lcbf
	
	nn = GetPrivStr("Параметры", "pass", "Нет значения", @lcBuffer1,100, Fullpath("SQL_CONNECTION.ini"))
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
	   = MESSAGEBOX('Не могу соединиться с MSSQL SERVER', 16, 'Внимание!!!')
	   RETURN
	ENDIF
	*MESSAGEBOX('OK')
	
*!*			?'Над базой '+lines_[i]+' выполнены следующие команды:'
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
*!*							ART=" ДО "
*!*						ELSE
*!*							ART=" ПОСЛЕ "
*!*						ENDIF
*!*						SELECT VAL(GETWORDNUM(size,1))/1024 AS size FROM Sqlresult1 INTO CURSOR sizedb
*!*						sizedbsize = " - Размер БД"+ART+STR(sizedb.size)+" МБ"
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

