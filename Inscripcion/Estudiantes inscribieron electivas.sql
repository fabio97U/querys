select distinct per_carnet, per_apellidos_nombres, mai_codhpl, hpl_codmat from ra_ins_inscripcion
inner join uonline.dbo.ra_alc_alumnos_carrera as alc on alc.alc_codper = ins_codper and alc.alc_codpla = 80
inner join uonline.dbo.ra_per_personas as per on per.per_codigo = ins_codper
inner join ra_mai_mat_inscritas as mai on mai_codins = ins_codigo
inner join uonline.dbo.ra_hpl_horarios_planificacion as hpl on hpl.hpl_codigo = mai_codhpl
inner join uonline.dbo.ra_plm_planes_materias as plm on plm.plm_codmat = mai_codmat and plm.plm_electiva = 'S'
order by per_apellidos_nombres
--select * from uonline.dbo.ra_alc_alumnos_carrera where alc_codper = 187572

select count(distinct per_carnet) from ra_ins_inscripcion
inner join uonline.dbo.ra_alc_alumnos_carrera as alc on alc.alc_codper = ins_codper and alc.alc_codpla = 80
inner join uonline.dbo.ra_per_personas as per on per.per_codigo = ins_codper
inner join ra_mai_mat_inscritas as mai on mai_codins = ins_codigo
inner join uonline.dbo.ra_hpl_horarios_planificacion as hpl on hpl.hpl_codigo = mai_codhpl
inner join uonline.dbo.ra_plm_planes_materias as plm on plm.plm_codmat = mai_codmat and plm.plm_electiva = 'S'



select * from uonline.dbo.ra_plm_planes_materias where plm_codpla = 80

select plm_codpla, plm_codmat, plm_uv, plm_horas_semanales, plm_horas_practicas, plm_ciclo, 
plm_anio_carrera, plm_num_mat, plm_laboratorio, plm_alias, plm_electiva, plm_bloque_electiva
from uonline.dbo.ra_plm_planes_materias
where (plm_codmat LIKE 'ETS2%')
