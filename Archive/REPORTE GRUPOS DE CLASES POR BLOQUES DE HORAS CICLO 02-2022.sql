--select * from ra_esc_escuelas

declare @tbl_materias_por_ciclo as table 
(codhpl int, facultad varchar(125), escuela varchar(125), codmat varchar(125), seccion varchar(10), horario varchar(60), dias varchar(125), Inscritos int, tipo_materia varchar(5), paralela varchar(10))

insert into @tbl_materias_por_ciclo 
(codhpl, facultad, escuela, codmat, seccion, horario, dias, Inscritos, tipo_materia, paralela)
select h.hpl_codigo, fac_nombre, esc_nombre, h.hpl_codmat, h.hpl_descripcion,
	case when man_codigo = 0 then 'Sin Definir' else isnull(man_nomhor, 'Sin Definir') end man_nomhor,
	case when isnull(h.hpl_lunes,'N') = 'S' then 'Lu-' else '' end+
	case when isnull(h.hpl_martes,'N') = 'S' then 'Ma-' else '' end+
	case when isnull(h.hpl_miercoles,'N') = 'S' then 'Mie-' else '' end+
	case when isnull(h.hpl_jueves,'N') = 'S' then 'Ju-' else '' end+
	case when isnull(h.hpl_viernes,'N') = 'S' then 'Vi-' else '' end+
	case when isnull(h.hpl_sabado,'N') = 'S' then 'Sab-' else '' end+
	case when isnull(h.hpl_domingo,'N') = 'S' then 'Dom-' else '' end dias, v.Inscritos, h.hpl_tipo_materia, hpl_paralela
from ra_hpl_horarios_planificacion h
	inner join ra_man_grp_hor on hpl_codman = man_codigo
	inner join ra_mat_materias on hpl_codmat = mat_codigo
	inner join ra_esc_escuelas on hpl_codesc = esc_codigo
	inner join ra_fac_facultades on esc_codfac = fac_codigo
	left join ra_hpl_horarios_planificacion_v_din v on v.hpl_codigo = h.hpl_codigo and v.hpl_codcil = h.hpl_codcil
where h.hpl_codesc not in (10, 13) and h.hpl_codcil = 129 and h.hpl_tipo_materia not in ('I')

--select * from @tbl_materias_por_ciclo--1292, 70903
--where paralela = 'N'

declare @tbl_paralelas as table (pr_codhpl int, pr_codmat varchar(125), pr_seccion varchar(30), pr_horario varchar(125), pr_dias varchar(125), pr_Inscritos int, pr_paralela varchar(10))
insert into @tbl_paralelas (pr_codhpl, pr_codmat, pr_seccion, pr_horario, pr_dias, pr_Inscritos, pr_paralela)
select codhpl, codmat, horario, seccion, '01' 'dias', sum(Inscritos) 'inscritos', 'S' 'paralela'
from @tbl_materias_por_ciclo
where paralela = 'S'
group by codhpl, codmat, horario, seccion, dias
--select * from @tbl_paralelas

update a set a.Inscritos = (a.Inscritos + b.pr_Inscritos)
from @tbl_materias_por_ciclo a
LEFT join @tbl_paralelas b on a.codmat = b.pr_codmat and a.seccion = '01' /*la paralela se le suma*/
--and a.dias = b.pr_dias and b.pr_horario = a.horario --and b.pr_paralela = 'S'
where b.pr_codmat is not null


select facultad, escuela, horario, dias, count(1) 'grupos', sum(Inscritos) 'inscripciones' 
--escuela, count(1)
from (
	select * from @tbl_materias_por_ciclo
	where paralela = 'N'
	--and mat_codesc = 5 
	--and h.hpl_codmat not like '%-V%'
) t
group by facultad, escuela, horario, dias
--order by horario

--select * from ra_hpl_horarios_planificacion where hpl_codcil = 129

--select * from ra_hpl_horarios_planificacion where hpl_paralela = 'N' AND hpl_codcil = 129
--En las paralelas solo contar la inscripcion, no la cantidad de grupos...
--90 minutos y 