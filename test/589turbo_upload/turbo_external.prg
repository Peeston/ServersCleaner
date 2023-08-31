*~* пример использования класса с "внешним" SQL соединением

SET CLASSLIB TO classlib.vcx

nConn = SQLSTRINGCONNECT("DRIVER=SQL Server;SERVER=(local);Trusted_Connection=Yes;network=dbmssocn")
oForm = CREATEOBJECT('turbo_mssql_upload',nConn)
oForm.Visible=.T.
READ EVENTS
SQLDISCONNECT(nConn)
