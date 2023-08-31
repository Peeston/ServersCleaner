*MESSAGEBOX(JUSTPATH(sys(16))+'\')
*SET DEFAULT to  Addbs(Justpath(Sys(16,0)))

PUBLIC mainAppModed ,mainAppModedT

IF _vfp.StartMode=4
	SET STATUS off
	SET STATUS BAR off
	
	SET MENU OFF 
	SET SYSMENU off
	
	mainAppModedD  = DTOC(FDATE(JUSTFNAME(sys(16,1)),0)) 
	mainAppModedT  = FTIME(JUSTFNAME(sys(16,1))) 

*SET PATH TO 
	
*!*		main_formModed
*!*		history.SCT
*!*		classlib.VCT
*!*		edit_sett.SCT
*!*		add_sett.SCT
*!*		edit_serv.SCT
*!*		edit_kassa.SCT
*!*		add_kassa.SCT
*!*		add_serv.SCT
*!*		load_data.prg
*!*		start.prg
*!*		procedures.prg
*!*		load_data.prg
*!*		ServersCleaner.pjx
*!*		ServersCleaner.pjt
	
	
ELSE
	
	SET STATUS on
	SET STATUS BAR on
	
	SET MENU On 
	SET SYSMENU on

ENDIF



 DO FORM _main_form.scx
 

