*~* пример использования класса с собственным SQL соединением

SET CLASSLIB TO classlib.vcx

oForm = CREATEOBJECT('turbo_mssql_upload')
oForm.Visible=.T.
READ EVENTS
