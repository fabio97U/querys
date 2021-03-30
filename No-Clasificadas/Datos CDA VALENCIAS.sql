--select * from (
select year(isnull(per_anio_graduacion, 0)) per_anio_graduacion, case when isnull(equ_codigo, 0) > 0 then 1 else 0 end equ_codigo, 
case when year(isnull(per_anio_graduacion, 0)) = 2019 then 1 else 0 end graduado_2019,
case when year(isnull(per_anio_graduacion, 0)) <> 2019 then 1 else 0 end graduado_antes_2019,
concat('0', cil_codcic , '-', cil_anio) ciclo--, per_carnet, per_codigo
from ra_per_personas
	left join ra_equ_equivalencia_universidad on equ_codper = per_codigo
	inner join ra_cil_ciclo on per_codcil_ingreso = cil_codigo
where per_codcil_ingreso in (122, 123) and per_tipo = 'U'
--) t
--where t.graduado_2019 = 0 and graduado_antes_2019 = 0




--EQUIVALENCIAS
--select * from col_tmo_tipo_movimiento where tmo_arancel = 'S-02'
select * from col_mov_movimientos
inner join col_dmo_det_mov on dmo_codmov = mov_codigo
inner join ra_per_personas on mov_codper = per_codigo
where dmo_codtmo = 907 and dmo_codcil = 122
