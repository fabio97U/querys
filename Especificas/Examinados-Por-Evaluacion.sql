select --fac_nombre, pon_nombre, count(distinct per_codigo) 'Examinados' 
distinct per_codigo, per_carnet, car_nombre, fac_nombre
, case when car_nombre like '%NO PRE%' then 1 else 0 end virtual
, case when hpl_codaul = 160 then 1 else 0 end materia_virtual
, case when hpl_codaul <> 160 then 1 else 0 end materia_persencial
from ra_ins_inscripcion
inner join ra_per_personas on per_codigo = ins_codper
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
inner join ra_not_notas on not_codmai = mai_codigo
inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
inner join ra_pon_ponderacion on pon_codigo = pom_codpon
inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
inner join ra_pla_planes on mai_codpla = pla_codigo 
inner join ra_car_carreras on car_codigo = pla_codcar
inner join ra_fac_facultades on fac_codigo = car_codfac
inner join ra_hpl_horarios_planificacion on mai_codhpl = hpl_codigo
where --ins_codper = 216644 and 
ins_codcil = 126 and per_tipo = 'U'
and pon_codigo in (1) and mai_estado = 'I' and bandera = 1
--group by fac_nombre, pon_nombre, car_nombre, hpl_codaul
order by per_codigo

select * from ra_vst_aptde_AlumnoPorTipoDeEstudio 
where ins_codcil = 126 and tde_codigo = 1--17391