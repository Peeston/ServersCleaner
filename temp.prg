*!*	If ! Used('czn')=.T.
*!*		Use czn.Dbf Alias czn In 0 Shared Again
*!*	Endif

*!*	Select czn
*!*	*COPY TO czn
*!*	Count To kol_zap
*!*	scale_code1=""
*!*	scale_code2=""
*!*	i=0
*!*	f=0

*!*	Select czn
*!*	For i=1 To kol_zap
*!*		Select czn
*!*		
*!*		GO top
*!*		Go i
*!*		Store czn.����� To scale_code1

*!*		If scale_code2<>scale_code1 AND i<>1
*!*			Append Blank
*!*			f=0
*!*		ENDIF
*!*		f=f+1

*!*		Insert Into czn(���������,�����, �����, ����, �����, �����, �����, ���, ���������_, ����������, ����� ,����_�����, firstStamp, inPack, ����������);
*!*		 Select ���������,�����, �����, ����, �����, �����, �����, ���, ���������_, ����������, �����, ����_�����, IIF(f=1 AND EMPTY(����_�����),1,0), inPack,;
*!*		  IIF(f=1,(SELECT SUM(VAL(�����)) FROM  czn WHERE NVL(firstStamp,0)=0 AND �����=m.scale_code1 AND ! EMPTY(���������) AND NVL(inPack,0)>0),0) From czn Where Recno()=i
*!*		
*!*		Select czn
*!*		GO top
*!*		Go i
*!*		Store czn.����� To scale_code2
*!*		
*!*	Endfor

*!*	SELECT * FROM czn

CLOSE DATABASES 

Public curUserProf, nrecno_sett 

thisAppPath = JUSTPATH(sys(16))+'\'


curUserProf = thisAppPath +'users\'+ GETENV("USERNAME")

If ! Directory(curUserProf)
	Md '&curUserProf'
ENDIF



file1=thisAppPath+'\settings.dbf'
file2=curUserProf +'\settings.dbf'

IF ! FILE(curUserProf+'\settings.dbf')
	COPY FILE &file1 TO  &file2 
endif


If Used('settings_v')=.T.
	Select settings_v
	Use
	Use &file2 Alias settings_v In 0 Shared EXCLUSIVE
 
Else
	Use &file2 Alias settings_v In 0 EXCLUSIVE  
Endif

SELECT settings_v 
INDEX ON byhand TAG bbhand OF curUserProf+'\settings.cdx' ADDITIVE


SELECT * FROM settings_v