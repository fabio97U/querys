sp_databases
go

SELECT SERVERPROPERTY('COLLATION')

sp_helpsort


SELECT SERVERPROPERTY('EDITION')


SELECT SERVERPROPERTY('IsIntegratedSecurityOnly')
--* SOLO EN EL MODO SQLCMD
:ListVar
go

:SETVAR DATA_BASENAME 'pruebas_sqlcmd'
select $(DATA_BASENAME) as 'DATA_BASENAME'
--SOLO EN EL MODO SQLCMD *
select DB_NAME()
