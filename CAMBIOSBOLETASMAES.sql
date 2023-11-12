select * from ra_cohorte_campus_maestria
select * from col_fel_fechas_limite_mae_mora where fel_codcil = 128 and origen = 58
select * from col_art_archivo_tal_mae_mora where ciclo = 128
select * from ma_abe_aranceles_boleta_estudiante
select * from tab_tal_maestria_beca where per_codigo = 216640
select * from apam_alumnos_por_arancel_maestria where per_codigo = 216640

select * from vst_Aranceles_x_Evaluacion where 
--are_tipo = 'MAESTRIAS'
--and 
codtde = 3

IdMaestriaBeca
3424
216640
SELECT * FROM col_tmo_tipo_movimiento
select per_tipo_graduado, per_estado, * from ra_per_personas 
join ra_alc_alumnos_carrera on alc_codper = per_codigo 
		inner join ra_pla_planes on pla_codigo = alc_codpla 
		inner join ra_car_carreras on car_codigo = pla_codcar 
where per_codigo = 235516


select per_tipo_graduado, * from ra_ins_inscripcion
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
inner join ra_hpl_horarios_planificacion on mai_codhpl = hpl_codigo
inner join ra_alc_alumnos_carrera on alc_codper = ins_codper
inner join ra_pla_planes on alc_codpla = pla_codigo
inner join ra_car_carreras on pla_codcar = car_codigo
INNER JOIN ra_per_personas on per_codigo = ins_codper
where ins_codcil = 128 --and mai_codmat like '%-M' 
and hpl_codesc = 10
and car_tipo = 'M'

select * from ra_car_carreras
inner join ra_pla_planes on pla_codcar = car_codigo
where pla_alias_carrera like '%rob%'

select * from ra_alc_alumnos_carrera 
inner join tab_tal_maestria_beca on alc_codper = per_codigo
where alc_codpla = 478









-------------------

select * from col_fel_fechas_limite_mae_mora 
where fel_codtde = 3 and fel_codcil = 126 and origen = 69
--alter table col_fel_fechas_limite_mae_mora add fel_codusr_creacion int

insert into col_fel_fechas_limite_mae_mora 
(fel_codreg, fel_codcil, fel_anio, fel_mes, fel_fecha, fel_codtmo, fel_tipo, fel_fecha_gracia, fel_codigo_barra, 
fel_valor, fel_global, fel_orden, fel_fecha_mora, fel_valor_mora, fel_modulo, fel_tipo_alumno, fel_cuota_pagar, fel_cuota_pagar_mora, 
origen, tmo_arancel, fel_codvac, tmo_arancel_beca, fel_fechahora, fel_codtde, fel_codusr_creacion)

select fel_codreg, fel_codcil, fel_anio, fel_mes, fel_fecha, fel_codtmo, fel_tipo, fel_fecha_gracia, fel_codigo_barra, 
fel_valor, fel_global, fel_orden, fel_fecha_mora, fel_valor_mora, fel_modulo, fel_tipo_alumno, fel_cuota_pagar, fel_cuota_pagar_mora,
origen, tmo_arancel, null, null, getdate(), tde_codigo, 407
from col_fel_fechas_limite_mae_pg 
inner join ra_tde_TipoDeEstudio on tde_tipo = fel_per_tipo
inner join col_tmo_tipo_movimiento on fel_codtmo = tmo_codigo
where fel_codcil = 126

select * from col_fel_fechas_limite_mae_pg 
inner join ra_tde_TipoDeEstudio on tde_tipo = fel_per_tipo
inner join col_tmo_tipo_movimiento on fel_codtmo = tmo_codigo
where fel_codcil = 126

select * from col_art_archivo_tal_mae_mora where ciclo = 126 AND per_codigo = 235952
select * from col_art_archivo_tal_mae_posgrado where ciclo = 126 AND per_codigo = 235952
select * from tab_tal_maestria_beca where per_codigo = 235952
select * from vst_Aranceles_x_Evaluacion where codtde = 3
insert into tal_maestria_beca (per_codigo, codcil, beca, origen) values
(235952, 126, 1, 69)
select * from col_art_archivo_tal_mae_mora where ciclo = 126 and per_codigo = 227603

select * from ra_cohorte_campus_maestria
select * from alumnos_por_arancel_maestria_posgrado







----------------

select distinct per_codigo from col_art_archivo_tal_mae_mora where ciclo = 128

select v.per_codigo, per_carnet, per_estado, origen from ra_vst_aptde_AlumnoPorTipoDeEstudio v 
inner join tab_tal_maestria_beca t on v.per_codigo = t.per_codigo
where ins_codcil = 128 and tde_codigo = 2
and v.per_codigo not in (
	select distinct per_codigo from col_art_archivo_tal_mae_mora where ciclo = 128
)
and t.IdMaestriaBeca = (select max(IdMaestriaBeca) from tab_tal_maestria_beca t2 where t2.per_codigo = v.per_codigo)

select distinct per_codigo from col_art_archivo_tal_mae_mora where ciclo = 128 and per_codigo = 238789
union all 
select distinct per_codigo from col_art_archivo_tal_mae_posgrado where ciclo = 128 and per_codigo = 238789

select * from tab_tal_maestria_beca where per_codigo in (
238789
) and codcil = 128
select * from col_fel_fechas_limite_mae_mora where fel_codcil = 128 and origen in (70, 55, 32)
select per_tipo_graduado, * from ra_per_personas where per_codigo IN (
227601
)