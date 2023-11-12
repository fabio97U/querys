select * from col_tmo_tipo_movimiento where tmo_descripcion like '%carre%'
select * from col_dmo_det_mov
inner join col_mov_movimientos on dmo_codmov = mov_codigo
where dmo_codtmo = 143 and dmo_codcil = 126
select * from col_dpboa_definir_parametro_boleta_otros_aranceles where dpboa_codtmo = 143

--tmo_codigo	tmo_arancel		tmo_descripcion
--143			C-11 			Cambio de Carrera.
-- drop table pac_planes_activos_ciclo
create table pac_planes_activos_ciclo (
	pac_codigo int primary key identity (1, 1),
	pac_codpla int,
	pac_codcil int,
	pac_fecha_creacion datetime default getdate(),
	pac_codusr_creacion int
)
-- select * from pac_planes_activos_ciclo where pac_codcil = 128

insert into pac_planes_activos_ciclo (pac_codpla, pac_codcil, pac_codusr_creacion)
values (324, 128, 1), (327, 128, 1)


select * from ni_snim_solicitud_nuevo_ingreso_maestrias

select 1 resp from gc_fefopep_fecha_formulario_pep where convert(date, GETDATE(), 103) >= convert(date, fefopep_fecha_inicio, 103) and convert(date, GETDATE(), 103) <= convert(date, fefopep_fecha_fin, 103) and fefopep_codcil = 126