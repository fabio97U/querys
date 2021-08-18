exec dbo.web_ptl_login_ldap '1109022015', 126, 126
exec dbo.web_ptl_login_info_fqdn '1109022015'
-- exec dbo.web_ins_genasesoria_con_matins_nodjs_azure 126, 216122		--hoja_inscripcion
-- exec dbo.web_ins_cuposinserinscripcion_nodjs		--inscribir matererias
-- exec dbo.web_mod_ins_cuposinserinscripcion_nodjs	--modificar materias
-- exec dbo.web_ins_matinscritas_nodjs 228835, 126				--comprobante de materias
--1222723, 4969582
select top 100 per_carnet, *
--distinct SUBSTRING(per_carnet, 1, 2) 
from dbo.ra_ins_inscripcion 
--inner join dbo.ra_mai_mat_inscritas on ins_codigo = mai_codins
inner join ra_per_personas on per_codigo = ins_codper
where ins_codcil = 126 --and ins_codper = 186836
order by ins_codigo desc

--select top 10 * from ra_ins_bitcam_inscripcion_bitacora_cambios order by bitcam_codigo desc
--28104, 2020-07-15 00:36:11.703, 40638, 2020-07-15 17:10:13.130, 48307 2020-07-16 19:52:09.553
select * from ins_errins_errores_inscrpcion with (nolock) where errins_codcil = 126 order by errins_fecha_creacion
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
--and status = 'running'--6992
order by login_time desc

-- select * from sys.dm_exec_connections
--select * from  sys.sysprocesses where program_name = 'node-mssql' order by login_time desc

--Encontrar cursores de larga duración
SELECT creation_time ,cursor_id
,name ,c.session_id ,login_name
FROM sys.dm_exec_cursors(0) AS c
JOIN sys.dm_exec_sessions AS s
ON c.session_id = s.session_id 
AND s.session_id in (select session_id from sys.dm_exec_sessions where program_name = 'node-mssql')
WHERE DATEDIFF(MILLISECOND, c.creation_time, GETDATE()) > 1

select * from ra_ins_bitcam_inscripcion_bitacora_cambios where bitcam_codper = 192498
select * from ra_validaciones_globales where rvg_codper  = 192498
--up-date ra_validaciones_globales set rvg_mensaje = '0' where rvg_codper = 192498
select * from dbo.ra_ins_inscripcion where ins_codper = 192498
--de-lete from dbo.ra_ins_inscripcion where ins_codper = 192498
select per_tipo_ingreso, * from ra_per_personas where per_codigo = 192498
select * from ra_alc_alumnos_carrera where alc_codper = 192498
select * from dbo.ra_mai_mat_inscritas where mai_codins = 1231246
--de-lete from dbo.ra_mai_mat_inscritas where mai_codins = 1231246

select rvg_mensaje, count(1) from ra_validaciones_globales
group by rvg_mensaje

SELECT fac, count(1) 'pagos_ra_validac', count(ins_codigo) 'inscritos', count(1) - count(ins_codigo)  'restantes' FROM (
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
	left join Inscripcion.dbo.ra_ins_inscripcion on ins_codper = per_codigo and ins_codcil = 126
) T
group by fac
--12595
--select * from ra_validaciones_globales where rvg_carnet like '02%'

--CON INSCRIPCION DE PLAN DIFERENTE AL DEL ALC
--select * from ra_pla_planes where pla_codigo in (262, 324)
select --distinct ins_codper
alc_codpla, mai_codpla, ins_codper, per_carnet, plm_codmat, mat_codigo, mai_codhpl, bitcam_codhpl, bitcam_codins, rvg_mensaje,  mai_fecha, *  
from Inscripcion.dbo.ra_ins_inscripcion--115
inner join Inscripcion.dbo.ra_mai_mat_inscritas on mai_codins = ins_codigo
inner join ra_alc_alumnos_carrera on alc_codper = ins_codper
inner join ra_per_personas on per_codigo = ins_codper
inner join ra_mat_materias on mat_codigo = mai_codmat
left join ra_plm_planes_materias on plm_codpla = alc_codpla and mai_codmat = plm_codmat
left join ra_validaciones_globales on rvg_codper = per_codigo
left join ra_ins_bitcam_inscripcion_bitacora_cambios on bitcam_codper = per_codigo and bitcam_codhpl = mai_codhpl
where mai_codpla <> alc_codpla and per_tipo = 'U' and ins_codcil = 126 --and alc_codper = 224535
and ins_usuario_creacion = 'user.online'
--and isnull(plm_codmat, '') <> ''
order by ins_fecha_creacion asc
--select * from dbo.ra_ins_bitcam_inscripcion_bitacora_cambios where bitcam_codper = 214490
--select * from ra_alc_alumnos_carrera where alc_codper = @codper

select * from ra_alc_alumnos_carrera where alc_codper = 224785
--exec web_ins_genasesoria 126, 209505

select mat_codigo, mat_nombre, hpl_descripcion, * from 
ra_ins_bitcam_inscripcion_bitacora_cambios 
inner join ra_hpl_horarios_planificacion on hpl_codigo = bitcam_codhpl
inner join ra_mat_materias on mat_codigo = hpl_codmat
where bitcam_codper = 209505
--select * from ra_plm_planes_materias where plm_codpla = 217

select * from Inscripcion.dbo.ra_ins_inscripcion --where ins_codigo = 1222738
where ins_codigo not in (select mai_codins from Inscripcion.dbo.ra_mai_mat_inscritas) and ins_codcil = 126
--and ins_codper in (228312, 228462, 228467, 228494, 228507, 228646, 228672, 228687, 228696, 228720, 228724, 228781, 228790, 228800, 228818, 228954, 229011, 229031, 229044, 229056, 229069, 229071, 229077, 229110, 229190, 229199, 229207, 229316, 229405, 229546, 229674, 229716, 229717, 229804, 229831, 229884, 229906, 229914, 229918, 229921)
order by ins_fecha_creacion desc

select * from Inscripcion.dbo.ra_mai_mat_inscritas
where mai_codins not in (select ins_codigo from Inscripcion.dbo.ra_ins_inscripcion where ins_codcil = 126)
--
--MAS DE 5 CODMAI INSCRITAS
select ins_codigo, ins_codper, count(1) from Inscripcion.dbo.ra_ins_inscripcion
inner join Inscripcion.dbo.ra_mai_mat_inscritas on mai_codins = ins_codigo
where ins_codcil = 126 and ins_usuario_creacion = 'user.online'
group by ins_codigo, ins_codper
having count(1) > 5


select ins_codigo, ins_codper, count(1) from Inscripcion.dbo.ra_ins_inscripcion
inner join Inscripcion.dbo.ra_mai_mat_inscritas_especial on mai_codins = ins_codigo
where ins_codcil = 126 and ins_usuario_creacion = 'user.online'
group by ins_codigo, ins_codper
having count(1) > 2

select * from Inscripcion.dbo.ra_ins_inscripcion 
inner join ra_per_personas on per_codigo = ins_codper
inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
where ins_codigo in (1263529)
order by ins_codigo

select * from Inscripcion.dbo.ra_mai_mat_inscritas where mai_codins in (1265321)
order by mai_codins, mai_codigo