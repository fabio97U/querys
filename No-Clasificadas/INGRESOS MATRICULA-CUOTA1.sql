select * from ra_cil_ciclo
--116	1	2018
--119	1	2019
--122	1	2020
select concat('0', cil_codcic, '-', cil_anio) 'Ciclo', tmo_descripcion 'Arancel', count(distinct dmo_codigo) 'Cantidad', round(sum(dmo_valor), 2) 'Total'
from col_mov_movimientos
inner join col_dmo_det_mov on dmo_codmov = mov_codigo
inner join ra_per_personas on per_codigo = mov_codper
inner join vst_Aranceles_x_Evaluacion v on dmo_codtmo = v.are_codtmo
inner join ra_cil_ciclo on dmo_codcil = cil_codigo
where mov_fecha_registro between '20171201' and '20171231' and mov_estado not in ('A') and dmo_codcil = 116 and per_tipo = 'U'
and v.nucuo_numcuota in (0, 1) and v.are_tipo in ('PREGRADO')
group by cil_codcic, cil_anio, tmo_descripcion
order by tmo_descripcion desc
--402,208.12

select concat('0', cil_codcic, '-', cil_anio) 'Ciclo', tmo_descripcion 'Arancel', count(distinct dmo_codigo) 'Cantidad', round(sum(dmo_valor), 2) 'Total'
from col_mov_movimientos
inner join col_dmo_det_mov on dmo_codmov = mov_codigo
inner join ra_per_personas on per_codigo = mov_codper
inner join vst_Aranceles_x_Evaluacion v on dmo_codtmo = v.are_codtmo
inner join ra_cil_ciclo on dmo_codcil = cil_codigo
where mov_fecha_registro between '20181201' and '20181231' and mov_estado not in ('A') and dmo_codcil = 119 and per_tipo = 'U'
and v.nucuo_numcuota in (0, 1) and v.are_tipo in ('PREGRADO')
group by cil_codcic, cil_anio, tmo_descripcion
order by tmo_descripcion desc

select concat('0', cil_codcic, '-', cil_anio) 'Ciclo', tmo_descripcion 'Arancel', count(distinct dmo_codigo) 'Cantidad', round(sum(dmo_valor), 2) 'Total'
from col_mov_movimientos
inner join col_dmo_det_mov on dmo_codmov = mov_codigo
inner join ra_per_personas on per_codigo = mov_codper
inner join vst_Aranceles_x_Evaluacion v on dmo_codtmo = v.are_codtmo
inner join ra_cil_ciclo on dmo_codcil = cil_codigo
where mov_fecha_registro between '20191201' and '20191231' and mov_estado not in ('A') and dmo_codcil = 122 and per_tipo = 'U'
and v.nucuo_numcuota in (0, 1) and v.are_tipo in ('PREGRADO')
group by cil_codcic, cil_anio, tmo_descripcion
order by tmo_descripcion desc

select * from vst_Aranceles_x_Evaluacion