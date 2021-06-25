select ciclo, orden, fac_nombre, sum(1) cantidad from (
select alc_codper, concat('*0', cil_codcic, '-', cil_anio) 'ciclo', max(plm_ciclo) orden, fac_nombre, 1 cantidad
from ra_vst_aptde_AlumnoPorTipoDeEstudio v
--inner join ra_ins_inscripcion i on i.ins_codper = per_codigo and i.ins_codcil = 125
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
inner join ra_plm_planes_materias on alc_codpla = plm_codpla and mai_codmat = plm_codmat
inner join ra_car_carreras c on c.car_codigo = v.car_codigo
inner join ra_fac_facultades on fac_codigo = car_codfac
inner join ra_cil_ciclo on cil_codigo = 125
where tde_codigo = 1
and ins_codcil = 125 --and per_codigo in (173322, 229406, 4412)
and per_estado = 'A'
group by alc_codper, cil_codcic, cil_anio, fac_nombre
)t
group by ciclo, orden, fac_nombre