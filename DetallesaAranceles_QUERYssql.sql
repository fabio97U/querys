-- drop table ra_detara_detalle_aranceles
create table ra_detara_detalle_aranceles (
	detara_codigo int primary key identity (1, 1),
	detara_codtmo int,
	detara_descripcion varchar(2048),
	detara_url_modelo varchar(250),
	detara_codusr int,
	detara_fecha_creacion datetime default getdate()
)
-- select * from ra_detara_detalle_aranceles
select detara_codigo, detara_codtmo, concat(ltrim(tmo_arancel), ' ', ltrim(tmo_descripcion)) tmo_descripcion, detara_url_modelo, detara_codusr, detara_fecha_creacion 
from ra_detara_detalle_aranceles
	inner join col_tmo_tipo_movimiento on detara_codtmo = tmo_codigo
	select detara_url_modelo, detara_descripcion from ra_detara_detalle_aranceles where detara_codtmo IN (select dpboa_codtmo from col_dpboa_definir_parametro_boleta_otros_aranceles where dpboa_codtmo = 1)
select tmo_codigo codigo, concat(ltrim(tmo_arancel), ' ', ltrim(tmo_descripcion)) texto 
from col_tmo_tipo_movimiento
if not exists(select 1 from ra_detara_detalle_aranceles where detara_codtmo = @codtmo)
insert into ra_detara_detalle_aranceles (detara_codtmo, detara_descripcion, detara_url_modelo, detara_codusr) values (1, '', '', 378); select '''coddetara'

declare @fecha_aud datetime,@registro varchar(1024), @usuario varchar(50) = ''
set @fecha_aud = getdate()
select @registro = concat('detara_codigo ', detara_codigo, 'detara_codtmo ', detara_codtmo, 'detara_url_modelo ', detara_url_modelo) 
from ra_detara_detalle_aranceles 
where detara_codigo = 1
select @usuario = usr_usuario from adm_usr_usuarios where usr_codigo = 1
exec auditoria_del_sistema 'ra_detara_detalle_aranceles','D', @usuario, @fecha_aud, @registro
delete from ra_detara_detalle_aranceles where detara_codigo = 1



select * from adm_aud_auditoria where aud_tabla = 'ra_detara_detalle_aranceles'

select tmo_codigo codigo, concat(ltrim(tmo_arancel), ' ', ltrim(tmo_descripcion)) texto from col_tmo_tipo_movimiento where tmo_codigo not in (select detara_codtmo from ra_detara_detalle_aranceles)