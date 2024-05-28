--select * from col_tmo_tipo_movimiento where tmo_arancel = 'C-301'

select per_codigo, per_carnet, per_nombres_apellidos, 
concat(/*car_identificador,  */'',pla_alias_carrera) 'carrera_actual' 
, (
select top 1 concat(/*car_identificador,  */'',pla_alias_carrera) 'carrera_anterior' 
from ra_hac_his_alm_car 
	inner join ra_pla_planes on hac_codpla = pla_codigo
	inner join ra_car_carreras on pla_codcar = car_codigo
where hac_codper = mov_codper --and hac_codcil = 134
and pla_alias_carrera not like '%no pres%'
order by hac_codigo
) 'carrera_anterior' from col_dmo_det_mov 
	inner join col_mov_movimientos on dmo_codmov = mov_codigo
	inner join ra_per_personas on per_codigo = mov_codper
	inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
	inner join ra_pla_planes on alc_codpla = pla_codigo
	inner join ra_car_carreras on pla_codcar = car_codigo
	--inner join ra_hac_his_alm_car on hac_codper = per_codigo
where dmo_codtmo = 4283 and mov_estado not in ('A') and pla_alias_carrera like '%no pres%'--225
--and mov_codper = 226463
and dmo_codcil = 134
order by mov_codigo--285
