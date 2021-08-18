----INICIO: se añade el valor -/+ 15 a la tpmenara
----Primera cuota se le quita los $15 de descuento
--update col_tpmenara_tipo_mensualidad_aranceles 
--set tpmenara_monto_pagar = tpmenara_monto_pagar + 15, 
--tpmenara_monto_arancel_descuento = tpmenara_monto_arancel_descuento - 15,
--tpmenara_arancel_descuento = 0
----select * from col_tpmenara_tipo_mensualidad_aranceles 
--where tpmenara_codtipmen in (5, 6, 7) and tpmenara_arancel in ('C-01','V-51','V-101')

----Segunta cuota se le añade los $15 de descuento
--update col_tpmenara_tipo_mensualidad_aranceles 
--set tpmenara_monto_pagar = tpmenara_monto_pagar - 15, 
--tpmenara_monto_arancel_descuento = tpmenara_monto_arancel_descuento + 15
----select * from col_tpmenara_tipo_mensualidad_aranceles 
--where tpmenara_codtipmen in (5, 6, 7) and tpmenara_arancel in ('C-02','V-52','V-102')
----FIN: se añade el valor -/+ 15 a la tpmenara

--INICIO: borrar alumnos ya con el descuento
--DELETE
declare @codcil int = 126
select * 
from col_detmen_detalle_tipo_mensualidad where detmen_codtpmenara in (
select tpmenara_codigo from col_tpmenara_tipo_mensualidad_aranceles where tpmenara_codtipmen in (5, 6, 7)
) and detmen_codcil = @codcil
--FIN: borrar alumnos ya con el descuento

--INICIO: selects de la data a generar
declare @inscribieron_una as table (codper int, carnet varchar(16), codvac int)
declare @alumnos_generar_descuento as table (codper int, carnet varchar(16), codvac int, codtipmen int, aplica_descuento_a_cuota int, posee_detmen int)
insert into @inscribieron_una (codper, carnet, codvac)
select ins_codper, per_carnet, per_codvac from (
	select ins_codper, per_carnet, per_codvac, count(1) inscritas from ra_ins_inscripcion
	inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
	inner join ra_per_personas on per_codigo = ins_codper
	where ins_codcil = @codcil and mai_estado = 'I' and per_tipo = 'U' and per_estado in ('A')-- and ins_codper = 45929
	group by ins_codper, per_carnet, per_codvac
	having count(1) = 1
) t

insert into @alumnos_generar_descuento (codper, carnet, codvac, codtipmen, aplica_descuento_a_cuota, posee_detmen)
select codper, carnet, codvac, (select tipmen_codigo from col_tipmen_tipo_mensualidad where tipmen_codigo in (5, 6, 7) and tipmen_codvac = a.codvac) codtipmen, (
	select max(n) + 1 from (
		select distinct per_codigo, per_carnet, tmo.tmo_arancel,
		tmo.tmo_codigo, case substring(tmo.tmo_descripcion,1,1) when 'M' then '0' else substring(tmo.tmo_descripcion,1,1) end n, tmo.tmo_descripcion,
		case substring(tmo.tmo_arancel,1,1)
		when 'C' then 'U'
		when 'S' then 'U'
		else substring(tmo.tmo_arancel,1,1) end tipo, mov_fecha_real_pago 
		from col_mov_movimientos
		join col_dmo_det_mov on dmo_codmov=mov_codigo
		join ra_per_personas on per_codigo=mov_codper
		join ra_ins_inscripcion on ins_codper=per_codigo
		join col_tmo_tipo_movimiento as tmo on dmo_codtmo = tmo.tmo_codigo
		join vst_aranceles_x_evaluacion as v on v.are_codtmo = tmo.tmo_codigo
		where dmo_codcil = @codcil and per_tipo='U' and mov_estado <> 'A'
		and are_tipo = 'PREGRADO' and mov_codper = a.codper
	) t 
) 'aplica_descuento_a_cuota',
isnull((select top 1 1 from col_detmen_detalle_tipo_mensualidad where detmen_codcil = @codcil and detmen_codper = a.codper), 0) 'posee_detmen'
from @inscribieron_una as a

--select * from @alumnos_generar_descuento
--FIN: selects de la data a generar

--INICIO: GENERA LA DATA CON DESCUENTO
declare @per_codper int, @tipmen_codigo int, @aplica_descuento_a_cuota int, @posee_detmen int
declare m_cursor cursor 
for
	select codper, codtipmen, aplica_descuento_a_cuota, posee_detmen from @alumnos_generar_descuento
open m_cursor 
 
fetch next from m_cursor into @per_codper, @tipmen_codigo, @aplica_descuento_a_cuota, @posee_detmen
while @@FETCH_STATUS = 0 
begin
	--if (@aplica_descuento_a_cuota = 3 or @aplica_descuento_a_cuota = 4 and @posee_detmen = 0)
	if (@aplica_descuento_a_cuota = 2 and @posee_detmen = 0)
	begin
		select 'descuento'
		--Inserta a la tipmen
		exec tal_GeneraDataTalonario_alumnos_tipo_mensualidad_especial @opcion = 4, @codcilGenerar = @codcil, @codper = @per_codper, @codusr = 378, @codtipmen = @tipmen_codigo

		----Genera la data al talonario con descuento
		exec tal_GeneraDataTalonario_alumnos_tipo_mensualidad_especial @opcion = 1, @codcilGenerar = @codcil, @codper = @per_codper
	end
    fetch next from m_cursor into @per_codper, @tipmen_codigo, @aplica_descuento_a_cuota, @posee_detmen
end      
close m_cursor  
deallocate m_cursor
--FIN: GENERA LA DATA CON DESCUENTO

select * from col_mov_movimientos 
inner join col_dmo_det_mov on dmo_codmov = mov_codigo
where mov_codigo = 6352849