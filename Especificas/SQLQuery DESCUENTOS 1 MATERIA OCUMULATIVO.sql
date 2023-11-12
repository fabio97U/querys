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
--select * from col_tpmenara_tipo_mensualidad_aranceles 
--where tpmenara_codtipmen in (5, 6, 7) and tpmenara_arancel in ('C-02','V-52','V-102')
----FIN: se añade el valor -/+ 15 a la tpmenara

--INICIO: borrar alumnos ya con el descuento
--DELETE
declare @codcil int = 131
--select * 
--from col_detmen_detalle_tipo_mensualidad where detmen_codtpmenara in (
--select tpmenara_codigo from col_tpmenara_tipo_mensualidad_aranceles where tpmenara_codtipmen in (5, 6, 7)
--) and detmen_codcil = @codcil
--FIN: borrar alumnos ya con el descuento

declare @inscribieron_una as table (codper int, carnet varchar(16), codvac int, materias_en_hoja int, quinta_matricula int, codtipmen int, aplica_descuento_a_cuota int, posee_detmen int )
--Inicio: Borrar estudiantes que ya tiene una materia cursada, inscribieron mas luego
insert into @inscribieron_una (codper, carnet, codvac, quinta_matricula)
select ins_codper, per_carnet, per_codvac, mai_matricula from (
	select ins_codper, per_carnet, per_codvac, count(1) inscritas, max(mai_matricula) mai_matricula from ra_ins_inscripcion
	inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
	inner join ra_per_personas on per_codigo = ins_codper
	where ins_codcil = @codcil and mai_estado = 'I' and per_tipo = 'U' and per_estado in ('A')-- and ins_codper = 45929
	group by ins_codper, per_carnet, per_codvac
	having count(1) = 1
) t
order by ins_codper

--Inicio: Solo les aparece una materia
declare @tbl_hoja_asesoria as table (carnet nvarchar(15), codigo nvarchar(22),materia nvarchar(125), matricula nvarchar(2),hor_descripcion nvarchar(2), man_nomhor nvarchar(50),dias nvarchar(200), plm_ciclo int,hpl_codigo int, hpl_codman int,plm_electiva nvarchar(1), plm_bloque_electiva int,especial nvarchar(1), hpl_tipo_materia nvarchar(2),cumgrl float, cumciclo float,per_nombre nvarchar(125), carrera nvarchar(125),aplan nvarchar(25), mat_aprobadas int,mat_reprobadas int, mat_aprobadasciclo int,mat_reprobadasciclo int, uv int, aul_nombre_corto varchar(60), mat_codesc int)
 
declare @mvar varchar(12), @codvac int--Variables del select
declare m_cursor cursor 
for
	select codper, codvac from @inscribieron_una-- where codper = 12873
	order by codper
open m_cursor

fetch next from m_cursor into @mvar, @codvac
while @@FETCH_STATUS = 0 
begin
	print '******* codper: ' + cast(@mvar as varchar(30))+ ' *******'

	insert into @tbl_hoja_asesoria
	exec dbo.web_ins_genasesoria @codcil, @mvar
	update @inscribieron_una set materias_en_hoja = (select count(distinct codigo) from @tbl_hoja_asesoria) where codper = @mvar

	update @inscribieron_una set codtipmen = (select tipmen_codigo from col_tipmen_tipo_mensualidad where tipmen_codigo in (5, 6, 7) and tipmen_codvac = @codvac) where codper = @mvar


	update @inscribieron_una set aplica_descuento_a_cuota = 
	(
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
		and are_tipo = 'PREGRADO' and mov_codper = @mvar
	) t 
)
	where codper = @mvar 

	update @inscribieron_una set posee_detmen = isnull((select top 1 1 from col_detmen_detalle_tipo_mensualidad where detmen_codcil = @codcil and detmen_codper = @mvar), 0) where codper = @mvar 


	delete from @tbl_hoja_asesoria
    fetch next from m_cursor into @mvar, @codvac
end      
close m_cursor  
deallocate m_cursor

select * from @inscribieron_una -- 443, 458
--Fin: Solo les aparece una materia

declare @codper_borrar_descuento int, @carnet_borrar_descuento varchar(20)
declare m_cursor cursor 
for
	select distinct detmen_codper, per_carnet from col_detmen_detalle_tipo_mensualidad 
		inner join col_tpmenara_tipo_mensualidad_aranceles on detmen_codtpmenara = tpmenara_codigo
		inner join ra_per_personas on per_codigo = detmen_codper
	where detmen_codcil = @codcil and tpmenara_codtipmen in (5, 6, 7)
	and per_carnet not in (
		select carnet from @inscribieron_una
	)
                
open m_cursor
fetch next from m_cursor into @codper_borrar_descuento, @carnet_borrar_descuento
while @@FETCH_STATUS = 0 
begin
	print '@codper_borrar_descuento: ' + cast(@codper_borrar_descuento as varchar(12))
	print '@carnet_borrar_descuento: ' + cast(@carnet_borrar_descuento as varchar(20))

	exec dbo.tal_GeneraDataTalonario_alumnos_tipo_mensualidad_especial @opcion = 2, @codcilGenerar = @codcil, @codper = @codper_borrar_descuento
	exec dbo.tal_GeneraDataTalonario_alumnos_tipo_mensualidad_especial @opcion = 1, @codreg = 1, @codcilGenerar = @codcil, @codper = @codper_borrar_descuento

    fetch next from m_cursor into @codper_borrar_descuento, @carnet_borrar_descuento
end      
close m_cursor  
deallocate m_cursor
--Fin: Borrar estudiantes que ya tiene una materia cursada, inscribieron mas luego


--INICIO: GENERA LA DATA CON DESCUENTO
declare @per_codper int, @tipmen_codigo int, @aplica_descuento_a_cuota int, @posee_detmen int
declare m_cursor cursor 
for
	select codper, codtipmen, aplica_descuento_a_cuota, posee_detmen from @inscribieron_una where materias_en_hoja in (0, 1)
	union all
	select codper, codtipmen, aplica_descuento_a_cuota, posee_detmen from @inscribieron_una where quinta_matricula >= 5
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

--select * from col_mov_movimientos 
--inner join col_dmo_det_mov on dmo_codmov = mov_codigo
--where mov_codigo = 6352849