select * from col_tmo_tipo_movimiento where tmo_arancel = 'O-48'

select per_codigo/*per_carnet, per_apellidos_nombres, 120, mov_fecha, mov_recibo, dmo_valor, tmo_arancel, tmo_descripcion*/ from ra_per_personas 
inner join col_mov_movimientos on mov_codper = per_codigo
inner join col_dmo_det_mov on dmo_codmov = mov_codigo
inner join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo and dmo_codtmo = 1490
where per_codcil_ingreso = 120 and mov_estado = 'I' and per_tipo = 'U'
order by per_carnet

select per_carnet, per_apellidos_nombres, concat('Ciclo 0', cil_codcic, '-',cil_anio) 'Ciclo', mov_fecha, mov_recibo, dmo_valor, tmo_arancel, tmo_descripcion, mov_estado, mov_usuario, mov_usuario_anula
from ra_per_personas 
inner join col_mov_movimientos on mov_codper = per_codigo
inner join col_dmo_det_mov on dmo_codmov = mov_codigo
inner join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
inner join ra_cil_ciclo on cil_codigo = mov_codcil
where per_codigo in(
	select per_codigo/*per_carnet, per_apellidos_nombres, 120, mov_fecha, mov_recibo, dmo_valor, tmo_arancel, tmo_descripcion*/ from ra_per_personas 
	inner join col_mov_movimientos on mov_codper = per_codigo
	inner join col_dmo_det_mov on dmo_codmov = mov_codigo
	inner join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo and dmo_codtmo = 1490
	where per_codcil_ingreso = 120 and mov_estado = 'I' and per_tipo = 'U'
) --and mov_estado = 'I'
order by per_carnet
