--select compatibility_level, * from sys.databases

--ALTER DATABASE uonline SET COMPATIBILITY_LEVEL = 160;--Para poder usar OPENJSON

-- drop table mh_tk_token
create table mh_tk_token (
	tk_codigo int primary key identity (1, 1),
	tk_response varchar(3072),
	tk_token_generado varchar(1024),
	tk_fecha_expiracion datetime,
	tk_fecha_creacion datetime default getdate()
)
go
-- select * from mh_tk_token

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-03-03 11:50:18.060>
	-- Description: <Devuel los tokens activos>
	-- =============================================
	-- select * from vst_mh_tk_tokens
create or alter view vst_mh_tk_tokens
as
	select tk_codigo, tk_response, tk_token_generado, tk_fecha_expiracion, tk_fecha_creacion,  
	case when getdate() > dateadd(hour, -1, tk_fecha_expiracion) then 1 else 0 end vencido
	from mh_tk_token