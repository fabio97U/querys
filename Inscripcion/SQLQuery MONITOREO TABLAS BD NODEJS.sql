exec dbo.web_ptl_login_ldap '2515462018', 123, 123
--web_ins_genasesoria_con_matins_nodjs_azure 123, 192498		--hoja_inscripcion
--web_ins_cuposinserinscripcion_nodjs		--inscribir matererias
--web_mod_ins_cuposinserinscripcion_nodjs	--modificar materias
--web_ins_matinscritas_nodjs_azure 224785, 123				--comprobante de materias
--1222723, 4969582
select top 10 per_carnet, *
--distinct SUBSTRING(per_carnet, 1, 2) 
from dbo.ra_ins_inscripcion 
--inner join dbo.ra_mai_mat_inscritas on ins_codigo = mai_codins
inner join ra_per_personas on per_codigo = ins_codper --AND per_carnet in ('13-1650-2016', '13-1754-2016')
where ins_codcil = 123 and ins_codigo > 1217590-- and ins_fecha_creacion > '2020-07-16 16:00:00.170'
order by ins_codigo desc--1222734, 1227699 2020-07-16 19:52:09.553, 1231245 2020-07-18 19:06:40.557
--1231642 2020-07-19 22:10:13.640

--select top 10 * from ra_ins_bitcam_inscripcion_bitacora_cambios order by bitcam_codigo desc
--28104, 2020-07-15 00:36:11.703, 40638, 2020-07-15 17:10:13.130, 48307 2020-07-16 19:52:09.553
select * from ins_errins_errores_inscrpcion with (nolock) where errins_codcil = 123
order by errins_fecha_creacion
--1, 7 2020-07-16 15:35:51.427
select * from dbo.ra_ins_inscripcion where ins_codigo = 1217864
--select * from ra_per_personas where per_codigo = 224240

--status
----Running: actualmente ejecuta una o más solicitudes. 
----Sleeping: actualmente no ejecuta ninguna solicitud.
-- total_scheduled_time: Tiempo total, en milisegundos, que se programó la ejecución de la sesión
-- total_elapsed_time: Tiempo, en milisegundos, desde que se estableció la sesión
-- lock_timeout: Configuración de LOCK_TIMEOUT para la sesión. El valor está en milisegundos.
select status, cpu_time, memory_usage, total_scheduled_time, total_elapsed_time, lock_timeout, host_process_id, * 
from sys.dm_exec_sessions 
where 
program_name = 'node-mssql'
and status = 'running'--6992
order by login_time desc

-- select * from sys.dm_exec_connections
--select * from  sys.sysprocesses where program_name = 'node-mssql' order by login_time desc

--Encontrar cursores de larga duración
SELECT creation_time ,cursor_id
,name ,c.session_id ,login_name
FROM sys.dm_exec_cursors(0) AS c
JOIN sys.dm_exec_sessions AS s
ON c.session_id = s.session_id AND 
s.session_id in (select session_id from sys.dm_exec_sessions where program_name = 'node-mssql')
WHERE DATEDIFF(MILLISECOND, c.creation_time, GETDATE()) > 1

select * from ra_ins_bitcam_inscripcion_bitacora_cambios where bitcam_codper = 192498
select * from ra_validaciones_globales where rvg_codper  = 192498
--update ra_validaciones_globales set rvg_mensaje = '0' where rvg_codper = 192498
select * from dbo.ra_ins_inscripcion where ins_codper = 192498
--delete from dbo.ra_ins_inscripcion where ins_codper = 192498
select per_tipo_ingreso, * from ra_per_personas where per_codigo = 192498
select * from ra_alc_alumnos_carrera where alc_codper = 192498
select * from dbo.ra_mai_mat_inscritas where mai_codins = 1231246
--delete from dbo.ra_mai_mat_inscritas where mai_codins = 1231246

SELECT fac, count(1) 'pagos_ra_validac', count(ins_codigo) 'inscritos' FROM (
	SELECT case when car_nombre like '%NO PRESENCIAL%' then 'VIRTUAL' else fac_nombre end fac--, count(1) 
	--case when  fac_nombre, count(1)
	, ins_codigo
	FROM ra_validaciones_globales
	inner join ra_per_personas on rvg_codper = per_codigo
	inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
	inner join ra_pla_planes on alc_codpla = pla_codigo
	inner join ra_car_carreras on car_codigo = pla_codcar
	inner join ra_esc_escuelas on esc_codigo = car_codesc
	inner join ra_fac_facultades on esc_codfac = fac_codigo
	left join dbo.ra_ins_inscripcion on ins_codper = per_codigo and ins_codcil = 123
) T
group by fac
--select * from ra_validaciones_globales where rvg_carnet like '02%'


--CON INSCRIPCION DE PLAN DIFERENTE AL DEL ALC
--select * from ra_pla_planes where pla_codigo in (262, 324)
select --distinct ins_codper
alc_codpla, mai_codpla, ins_codper, per_carnet, plm_codmat, mat_codigo, mai_codhpl, bitcam_codhpl, bitcam_codins, rvg_mensaje,  mai_fecha, *  
from dbo.ra_ins_inscripcion--115
inner join dbo.ra_mai_mat_inscritas on mai_codins = ins_codigo
inner join ra_alc_alumnos_carrera on alc_codper = ins_codper
inner join ra_per_personas on per_codigo = ins_codper
inner join ra_mat_materias on mat_codigo = mai_codmat
left join ra_plm_planes_materias on plm_codpla = alc_codpla and mai_codmat = plm_codmat
left join ra_validaciones_globales on rvg_codper = per_codigo
left join ra_ins_bitcam_inscripcion_bitacora_cambios on bitcam_codper = per_codigo and bitcam_codhpl = mai_codhpl
where mai_codpla <> alc_codpla and per_tipo = 'U' and ins_codcil = 123 --and alc_codper = 224535
--and isnull(plm_codmat, '') <> ''--14
--35
order by ins_fecha_creacion asc
--select * from dbo.ra_ins_bitcam_inscripcion_bitacora_cambios where bitcam_codper = 214490
--select * from ra_alc_alumnos_carrera where alc_codper = @codper

select * from ra_alc_alumnos_carrera where alc_codper = 224785
--exec web_ins_genasesoria 123, 209505

select mat_codigo, mat_nombre, hpl_descripcion, * from 
ra_ins_bitcam_inscripcion_bitacora_cambios 
inner join ra_hpl_horarios_planificacion on hpl_codigo = bitcam_codhpl
inner join ra_mat_materias on mat_codigo = hpl_codmat
where bitcam_codper = 209505
--select * from ra_plm_planes_materias where plm_codpla = 217


select * from dbo.ra_ins_inscripcion --where ins_codigo = 1222738
where ins_codigo not in (select mai_codins from dbo.ra_mai_mat_inscritas) and ins_codcil = 123

select * from dbo.ra_mai_mat_inscritas
where mai_codins not in (select ins_codigo from dbo.ra_ins_inscripcion where ins_codcil = 123)