select * from (
select per_carnet, CONCAT(aul_nombre_corto, Dias, hora) 'dias', count(1) 'inscri' from (
select distinct per_carnet, aul_nombre_corto, 
case when isnull(hpl_lunes,'N') = 'S' then 'L-' else '' end+
		case when isnull(hpl_martes,'N') = 'S' then 'M-' else '' end+
		case when isnull(hpl_miercoles,'N') = 'S' then 'Mi-' else '' end+
		case when isnull(hpl_jueves,'N') = 'S' then 'J-' else '' end+
		case when isnull(hpl_viernes,'N') = 'S' then 'V-' else '' end+
		case when isnull(hpl_sabado,'N') = 'S' then 'S-' else '' end+
		case when isnull(hpl_domingo,'N') = 'S' then 'D-' else '' end 'Dias', man_nomhor 'hora'
		--, count(1) 'inscritas'
		, hpl_codigo
from ra_ins_inscripcion
	inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
	inner join ra_hpl_horarios_planificacion on mai_codhpl = hpl_codigo
	inner join ra_per_personas on per_codigo = ins_codper
	inner join ra_alc_alumnos_carrera on alc_codper = ins_codper
	inner join ra_pla_planes on alc_codpla = pla_codigo
	inner join ra_man_grp_hor on man_codigo = hpl_codman
	inner join ra_aul_aulas on aul_codigo = hpl_codaul 
where ins_codcil = 134-- and ins_codper =245956 
and pla_alias_carrera not like '%%NO PRES'
) t
GROUP BY per_carnet, aul_nombre_corto, Dias, hora--, inscritas
)t2 
where 
dias not in ('AULA VIRTUALL-M-Mi-J-V-S-D-00:00-23:59') and 
--t2.dias not like '%aula vi%'
--and 
inscri > 1