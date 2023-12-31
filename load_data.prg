Public curUserProf, nrecno_sett 

IF _Vfp.StartMode=0
	thisAppPath = Addbs(Justpath(Sys(16)))
ELSE
	thisAppPath = Addbs(Justpath(Sys(16,0)))
endif


nrecno_sett=1

curUserProf = thisAppPath +'users\'+ GETENV("USERNAME")+'\'

If ! Directory(curUserProf)
*	Md '&curUserProf'
	Md (curUserProf)
ENDIF

*MESSAGEBOX(curUserProf)
Create Cursor gr2_src (del_mark L, artcode I(5), artname C(50), price N(20,2), artnum I(4), packid I(4), updatenum I(4), grp N(1))
*Create Cursor gr2_src (del_mark L, artcode I(5), artname C(50), price N(20,2), artnum I(4), packid I(4), grp N(1))


 SELECT gr2_src 
 INDEX ON STR(artnum)+''+STR(packid) TAG ipackid OF curUserProf+'\my_packid.cdx' ADDITIVE
 INDEX ON STR(artnum)+''+STR(updatenum) TAG iupdaten OF curUserProf+'\my_updatenum.cdx' ADDITIVE
 INDEX ON artcode TAG iartcode OF curUserProf+'\my_updatenum.cdx' ADDITIVE


Create Cursor p2gr3_src (del_mark L, artid I(5), artname C(50), price N(20,2), barcode C(15), barcode1c C(15), exbarcid I(4), packid I(4), updatenum I(4), grp N(1))

CREATE CURSOR sdept_src (sdeptid I(4), sdeptname C(50), sareaid I(4), cur_sdept L)


CREATE cursor revision_t (state I(4), nbath I(4), dbath C(14),  point C(30), dept C(30), artname C(50), countrec I(4), countdubl i(4), counteject I(4), pdid I(4), delflag I(4)) 
*CREATE cursor revisionext_t (drec C(14), artid I(4), artname C(50), barcode C(30), stamp C(20), byhand I(4), isdubl I(4), delflag I(4), nrec I(4), nbath I(4), iseject I(4))  
*(			 drec , 	   artid ,         artname, barcode,    stamp ,  byhand, isdubl, delflag,    nrec,        nbath, iseject) VALUES ;
*t1.state, t1.nbath, t1.dbath, t2.point, t2.dept, t1.artname, t1.countrec, t1.countdubl, t1.pdid, t1.delflag

*  m.lcTextWait = '�������� ��� ������...'
*WAIT WINDOW  m.lcTextWait NOWAIT AT SROWS()/2, SCOLS()/2-LEN(m.lcTextWait)/2

*!*	 	IF USED('monthes_lock')=.T.
*!*		    SELECT monthes_lock
*!*	    	USE
*!*		    USE mounts ALIAS monthes_lock IN 0 SHARED
*!*		 ELSE
*!*		    USE mounts ALIAS monthes_lock IN 0 SHARED
*!*		 ENDIF

If Used('db_servers_view')=.T.
	Select db_servers_view
	Use
	Use spr_ds Alias db_servers_view In 0 Shared
Else
	Use spr_ds Alias db_servers_view In 0 Shared
ENDIF

SELECT db_servers_view
INDEX ON ALLTRIM(name) TAG nname OF curUserProf+'\db_serv_ind_name.cdx' ADDITIVE

Update db_servers_view Set DoSt=2, cur_conn=.F.


If Used('db_queries_view')=.T.
	Select db_queries_view
	Use
	Use queries Alias db_queries_view In 0 Shared
Else
	Use queries Alias db_queries_view In 0 Shared
Endif

If Used('kass_view')=.T.
	Select kass_view
	Use
	Use spr_kass Alias kass_view In 0 Shared
Else
	Use spr_kass Alias kass_view In 0 Shared
Endif
Update kass_view Set DoSt=2, cur_conn=.F.

SELECT kass_view 
INDEX ON ALLTRIM(name) TAG nname OF curUserProf+'\db_kassa_ind_name.cdx' ADDITIVE


file1=thisAppPath+'\settings.dbf'
file2=curUserProf +'\settings.dbf'

IF ! FILE(curUserProf+'\settings.dbf')
	COPY FILE &file1 TO  &file2
endif


If Used('settings_v')=.T.
	Select settings_v
	Use
	Use (file2) Alias settings_v In 0 EXCLUSIVE
Else
	Use (file2) Alias settings_v In 0 EXCLUSIVE 
Endi

SELECT settings_v 
INDEX ON byhand TAG bbhand OF curUserProf+'\settings.cdx' ADDITIVE

If Used('history_v')=.T.
	Select history_v
	Use
	Use history Alias history_v In 0 Shared
Else
	Use history Alias history_v In 0 Shared
Endif





Return

**
