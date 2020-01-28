select tabla.hpl_codigo 'codhpl', tabla.man_nomhor 'Horario', tabla.aul_nombre_corto 'Aula', tabla.hpl_codmat 'Materia', tabla.hpl_descripcion 'Seccion', tabla.Dias 'Dias'  from (
select /*concat(man_nomhor, ' ', aul_nombre_corto, case when isnull(hpl_lunes,'N') = 'S' then 'L-' else '' end+
		case when isnull(hpl_martes,'N') = 'S' then 'M-' else '' end+
		case when isnull(hpl_miercoles,'N') = 'S' then 'Mi-' else '' end+
		case when isnull(hpl_jueves,'N') = 'S' then 'J-' else '' end+
		case when isnull(hpl_viernes,'N') = 'S' then 'V-' else '' end+
		case when isnull(hpl_sabado,'N') = 'S' then 'S-' else '' end+
		case when isnull(hpl_domingo,'N') = 'S' then 'D-' else '' end)*/
hpl_codigo, man_nomhor, aul_nombre_corto, hpl_codmat, hpl_descripcion, 
case when isnull(hpl_lunes,'N') = 'S' then 'L-' else '' end+
		case when isnull(hpl_martes,'N') = 'S' then 'M-' else '' end+
		case when isnull(hpl_miercoles,'N') = 'S' then 'Mi-' else '' end+
		case when isnull(hpl_jueves,'N') = 'S' then 'J-' else '' end+
		case when isnull(hpl_viernes,'N') = 'S' then 'V-' else '' end+
		case when isnull(hpl_sabado,'N') = 'S' then 'S-' else '' end+
		case when isnull(hpl_domingo,'N') = 'S' then 'D-' else '' end 'Dias' 
from ra_hpl_horarios_planificacion 
inner join ra_man_grp_hor on man_codigo = hpl_codman
inner join ra_aul_aulas on aul_codigo = hpl_codaul 
where hpl_codcil = 120 
--and aul_nombre_corto not in ('AULA VIRTUAL', 'Pendiente') and aul_nombre_corto not like '%INDUC%' and aul_nombre_corto not like '%AUDITORIO%'
) tabla
where tabla.Dias in ('M-J-',
'M-J-',
'M-J-',
'M-J-') and tabla.aul_nombre_corto in ('BJ-505',                   
'FM-506',
'SB-505',                   
'FM-308'                 
) and tabla.man_nomhor in(
'18:40-20:10',                             
'18:40-20:10', 
'06:30-08:00', 
'18:40-20:10'                             
)
order by tabla.man_nomhor, tabla.aul_nombre_corto
intersect

select * from (
select distinct man_nomhor, aul_nombre_corto, 
case when isnull(hpl_lunes,'N') = 'S' then 'L-' else '' end+
		case when isnull(hpl_martes,'N') = 'S' then 'M-' else '' end+
		case when isnull(hpl_miercoles,'N') = 'S' then 'Mi-' else '' end+
		case when isnull(hpl_jueves,'N') = 'S' then 'J-' else '' end+
		case when isnull(hpl_viernes,'N') = 'S' then 'V-' else '' end+
		case when isnull(hpl_sabado,'N') = 'S' then 'S-' else '' end+
		case when isnull(hpl_domingo,'N') = 'S' then 'D-' else '' end 'Dias' 
from ra_hpl_horarios_planificacion 
inner join ra_man_grp_hor on man_codigo = hpl_codman
inner join ra_aul_aulas on aul_codigo = hpl_codaul 
where hpl_codcil = 120 
and aul_nombre_corto not in ('AULA VIRTUAL', 'Pendiente') and aul_nombre_corto not like '%INDUC%' and aul_nombre_corto not like '%AUDITORIO%'
) tabla
where tabla.Dias <> ''












select*from (
select *from (
select hpl_codigo, man_nomhor, aul_nombre_corto, 
	case when isnull(hpl_lunes,'N') = 'S' then 'L-' else '' end+
		case when isnull(hpl_martes,'N') = 'S' then 'M-' else '' end+
		case when isnull(hpl_miercoles,'N') = 'S' then 'Mi-' else '' end+
		case when isnull(hpl_jueves,'N') = 'S' then 'J-' else '' end+
		case when isnull(hpl_viernes,'N') = 'S' then 'V-' else '' end+
		case when isnull(hpl_sabado,'N') = 'S' then 'S-' else '' end+
		case when isnull(hpl_domingo,'N') = 'S' then 'D-' else '' end 'Dias'  
		from ra_hpl_horarios_planificacion
		inner join ra_man_grp_hor on man_codigo = hpl_codman
		inner join ra_aul_aulas on aul_codigo = hpl_codaul 
	where hpl_codcil = 120 
	)t where concat(man_nomhor,man_nomhor,aul_nombre_corto) in (  

select concat(man_nomhor,man_nomhor,aul_nombre_corto) reg from (
select  man_nomhor, aul_nombre_corto, 
case when isnull(hpl_lunes,'N') = 'S' then 'L-' else '' end+
		case when isnull(hpl_martes,'N') = 'S' then 'M-' else '' end+
		case when isnull(hpl_miercoles,'N') = 'S' then 'Mi-' else '' end+
		case when isnull(hpl_jueves,'N') = 'S' then 'J-' else '' end+
		case when isnull(hpl_viernes,'N') = 'S' then 'V-' else '' end+
		case when isnull(hpl_sabado,'N') = 'S' then 'S-' else '' end+
		case when isnull(hpl_domingo,'N') = 'S' then 'D-' else '' end 'Dias' 
from ra_hpl_horarios_planificacion 
inner join ra_man_grp_hor on man_codigo = hpl_codman
inner join ra_aul_aulas on aul_codigo = hpl_codaul 
where hpl_codcil = 120 
and aul_nombre_corto not in ('AULA VIRTUAL', 'Pendiente') and aul_nombre_corto not like '%INDUC%' and aul_nombre_corto not like '%AUDITORIO%'
) tabla
where tabla.Dias <> ''
)
)tt where hpl_codigo not in (




select hpl_codigo from (
select hpl_codigo, man_nomhor, aul_nombre_corto, 
	case when isnull(hpl_lunes,'N') = 'S' then 'L-' else '' end+
		case when isnull(hpl_martes,'N') = 'S' then 'M-' else '' end+
		case when isnull(hpl_miercoles,'N') = 'S' then 'Mi-' else '' end+
		case when isnull(hpl_jueves,'N') = 'S' then 'J-' else '' end+
		case when isnull(hpl_viernes,'N') = 'S' then 'V-' else '' end+
		case when isnull(hpl_sabado,'N') = 'S' then 'S-' else '' end+
		case when isnull(hpl_domingo,'N') = 'S' then 'D-' else '' end 'Dias'  
		from ra_hpl_horarios_planificacion
		inner join ra_man_grp_hor on man_codigo = hpl_codman
		inner join ra_aul_aulas on aul_codigo = hpl_codaul 
	where hpl_codcil = 120 
	)t where concat(man_nomhor,man_nomhor,aul_nombre_corto) in (  

select concat(man_nomhor,man_nomhor,aul_nombre_corto) reg from (
select distinct man_nomhor, aul_nombre_corto, 
case when isnull(hpl_lunes,'N') = 'S' then 'L-' else '' end+
		case when isnull(hpl_martes,'N') = 'S' then 'M-' else '' end+
		case when isnull(hpl_miercoles,'N') = 'S' then 'Mi-' else '' end+
		case when isnull(hpl_jueves,'N') = 'S' then 'J-' else '' end+
		case when isnull(hpl_viernes,'N') = 'S' then 'V-' else '' end+
		case when isnull(hpl_sabado,'N') = 'S' then 'S-' else '' end+
		case when isnull(hpl_domingo,'N') = 'S' then 'D-' else '' end 'Dias' 
from ra_hpl_horarios_planificacion 
inner join ra_man_grp_hor on man_codigo = hpl_codman
inner join ra_aul_aulas on aul_codigo = hpl_codaul 
where hpl_codcil = 120 
and aul_nombre_corto not in ('AULA VIRTUAL', 'Pendiente') and aul_nombre_corto not like '%INDUC%' and aul_nombre_corto not like '%AUDITORIO%'
) tabla
where tabla.Dias <> ''
))