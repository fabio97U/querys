select fac_nombre, count(1) 
from dbo.ra_hpl_horarios_planificacion
	inner join ra_esc_escuelas on esc_codigo = hpl_codesc
	inner join ra_fac_facultades on fac_codigo = esc_codfac
where hpl_codcil = 125 and hpl_tipo_materia not in('I', 'A')
and fac_codigo <> 10--1326
group by fac_nombre
order by fac_nombre

select fac_nombre, per_carnet, per_apellidos, per_nombres, emp_codigo, emp_nombres_apellidos, 
hpl_codmat, isnull(not_nota, 0) not_nota, 
case when isnull(not_nota, 0) > 5.96 then 1 else 0 end aprobado,
case when isnull(not_nota, 0) < 5.96 then 1 else 0 end reprobado
from dbo.ra_hpl_horarios_planificacion
	inner join ra_esc_escuelas on esc_codigo = hpl_codesc
	inner join ra_fac_facultades on fac_codigo = esc_codfac
	inner join ra_mai_mat_inscritas on mai_codhpl = hpl_codigo
	inner join ra_ins_inscripcion on ins_codigo = mai_codins
	inner join ra_per_personas on per_codigo = ins_codper
	inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
	inner join ra_not_notas on not_codmai = mai_codigo
	inner join ra_pom_ponderacion_materia on not_codpom = pom_codigo
	inner join pla_emp_empleado on hpl_codemp = emp_codigo
where hpl_codcil = 125 and hpl_tipo_materia not in('I', 'A')
and fac_codigo <> 10--1326
--and ins_codper = 228622
and pom_codpon = 1
and mai_codpla = alc_codpla
--group by fac_nombre
order by fac_nombre