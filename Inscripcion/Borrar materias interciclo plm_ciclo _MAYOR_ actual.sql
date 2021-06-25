--select * from ra_pla_planes where pla_anio = 2018 and pla_estado = 'A' AND pla_tipo = 'U'
select * from ra_hpc_hpl_car
	inner join ra_hpl_horarios_planificacion on hpc_codhpl = hpl_codigo
	inner join ra_pla_planes on hpc_codpla = pla_codigo--1806
	inner join ra_plm_planes_materias on hpc_codpla = plm_codpla and hpl_codmat = plm_codmat
where hpl_codcil = 127 and pla_anio = 2018 and pla_estado = 'A' AND pla_tipo = 'U'
and plm_ciclo > 7  --and plm_codpla = 304
and plm_codmat not in (
	'ING1-H', 'ING1-V', 'ING2-H', 'ING2-V', 'DEIN-H', 'DEIN-V', 'FILO-H', 'EXOE-H','EXOE-V', 'EPRO-AC', 'EPRO-V', 'DEME-D', 'ECOE-B', 'ECOE-E', 'ESCO-V', 'CDLA-E', 'METI-A', 'METI-H'
)
order by hpc_fechahora desc

select * from ra_alc_alumnos_carrera where alc_codper = 208961