--use BD_RRHH
--go
--create schema contratos
--go

drop table contratos.detcon_detalle_contrato
drop table contratos.enccon_encabezado_contrato
drop view contratos.vst_materias_asignadas_docente
drop view contratos.ffce_fecha_firmar_contrato_escuela

-- drop table contratos.ffce_fecha_firmar_contrato_escuela
create table contratos.ffce_fecha_firmar_contrato_escuela(
	ffce_codigo int primary key identity (1, 1),
	ffce_codcil int,
	ffce_codesc int,

	ffce_fecha_desde datetime not null,
	ffce_fecha_hasta datetime not null,
	ffce_fecha_congreso datetime not null,
	ffce_fecha_firmar_contrato datetime not null,
	ffce_duracion_contrato decimal not null,
	ffce_fecha_inicio_clases datetime not null,

	ffce_fecha_creacion datetime default getdate()
)
-- select * from contratos.ffce_fecha_firmar_contrato_escuela
insert into contratos.ffce_fecha_firmar_contrato_escuela 
(ffce_codcil, ffce_codesc, ffce_fecha_desde, ffce_fecha_hasta, ffce_fecha_congreso, ffce_duracion_contrato, ffce_fecha_firmar_contrato, ffce_fecha_inicio_clases)
values (134, 1, '2023-12-10 16:00:00', '2024-12-31 10:10:00', '2024-01-12', 5, '2024-01-25', '2024-01-19'), 
(134, 2, '2023-12-10 16:00:00', '2024-12-31 10:10:00', '2024-01-12', 5, '2024-01-25', '2024-01-19'), 
(134, 3, '2023-12-10 16:00:00', '2024-12-31 10:10:00', '2024-01-12', 5, '2024-01-25', '2024-01-19'), 
(134, 4, '2023-12-10 16:00:00', '2024-12-31 10:10:00', '2024-01-12', 5, '2024-01-25', '2024-01-19'), 
(134, 5, '2023-12-10 16:00:00', '2024-12-31 10:10:00', '2024-01-12', 5, '2024-01-25', '2024-01-19'), 
(134, 6, '2023-12-10 16:00:00', '2024-12-31 10:10:00', '2024-01-12', 5, '2024-01-25', '2024-01-19'), 
(134, 7, '2023-12-10 16:00:00', '2024-12-31 10:10:00', '2024-01-12', 5, '2024-01-25', '2024-01-19'), 
(134, 8, '2023-12-10 16:00:00', '2024-12-31 10:10:00', '2024-01-12', 5, '2024-01-25', '2024-01-19'), 
(134, 9, '2023-12-10 16:00:00', '2024-12-31 10:10:00', '2024-01-12', 5, '2024-01-25', '2024-01-19'), 
(134, 10, '2023-12-10 16:00:00', '2024-12-31 10:10:00', '2024-01-12', 5, '2024-01-25', '2024-01-19'), 
(134, 13, '2023-12-10 16:00:00', '2024-12-31 10:10:00', '2024-01-12', 5, '2024-01-25', '2024-01-19');

-- drop table contratos.enccon_encabezado_contrato
create table contratos.enccon_encabezado_contrato (
	enccon_codigo int primary key identity (1, 1),
	enccon_codesc int not null/*foreign key references uonline.dbo.ra_esc_escuela not null*/,
	enccon_codencperf int not null/*foreign key references perfil.encperf_encabezado_perfil not null*/,
	enccon_nota_actual decimal not null,
	enccon_valor_hora_actual decimal not null,
	enccon_codemp int null,
	enccon_codcil int not null,
	enccon_periodo varchar(5) default 'MEN',--SEM: Semanal, MEN: Mensual
	enccon_duracion_contrato decimal not null,
	enccon_horas_totales_impartir decimal not null,
	enccon_valor_total_contrato decimal not null,
	enccon_fecha_congreso datetime not null,
	enccon_fecha_inicio_clases datetime not null,

	enccon_estado_escuela varchar(3) default 'APR' not null, --PEN: Pendiente, APR: Aprobado, DEN: Denegado
	enccon_codemp_creacion_escuela int not null,
	enccon_fecha_revision_escuela datetime not null,

	enccon_estado_secretaria varchar(3) default 'PEN' not null, --PEN: Pendiente, APR: Aprobado, DEN: Denegado
	enccon_codemp_secretaria int null,
	enccon_hora_y_dia_firmara_contrato_secretaria datetime null,
	enccon_numero_hojas_contrato_secretaria int null,
	enccon_fecha_revision_secretaria datetime null,
	enccon_comentario_secretaria varchar(1024) default null,

	enccon_estado_rrhh varchar(3) default 'PEN' not null, --PEN: Pendiente, APR: Aprobado, DEN: Denegado
	enccon_codemp_rrhh int null,
	enccon_fecha_revision_rrhh datetime null,
	enccon_comentario_rrhh varchar(1024) default null,

	enccon_link_contrato varchar(1024) default null,
	enccon_link_contrato_firmado varchar(1024) default null,
	enccon_fecha_carga_archivo_firmado datetime null,
	enccon_codemp_cargo_archivo int null,

	enccon_guid varchar(36) not null,
	enccon_fecha_creacion datetime not null default getdate()
)
go
-- select * from contratos.enccon_encabezado_contrato
--insert into contratos.enccon_encabezado_contrato 
--(enccon_codencperf, enccon_nota_actual, enccon_codemp, enccon_codcil, enccon_periodo, enccon_duracion_contrato, enccon_horas_totales_impartir, enccon_fecha_congreso, enccon_estado_escuela, enccon_codemp_creacion_escuela, enccon_fecha_revision_escuela)
--values (1, 2.5, 4291, 131, 'MEN', 5.0, 500, '2024-01-10', 'APR', 4291, GETDATE())

-- drop table contratos.detcon_detalle_contrato
create table contratos.detcon_detalle_contrato (
	detcon_codigo int primary key identity (1, 1),
	detcon_codenccon int foreign key references contratos.enccon_encabezado_contrato not null,
	detcon_origen varchar(10) not null, -- tabla origen donde esta la planificacion de la materia
	detcon_codigo_origen int not null, -- codigo tabla origen donde esta la planificacion de la materia

	detcon_fecha_creacion datetime not null default getdate()
)
go
-- select * from contratos.detcon_detalle_contrato

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-12-08 08:40:00.650>
	-- Description: <Devuelve los ciclos disponibles para contratos>
	-- =============================================
	-- select * from contratos.vst_ciclos_disponibles
create or alter view contratos.vst_ciclos_disponibles
as
	select cil_codigo 'codcil', cil_codcic, cil_anio, concat('0', cil_codcic, '-', cil_anio) 'ciclo'
	--case when cil_codigo = 131 then cast('2023-12-24 00:00:00.000' as datetime) else null end 'fecha_congreso'
	from uonline.dbo.ra_cil_ciclo
	where cil_estado = 'A'
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-12-14 22:26:00.000>
	-- Description: <Devuelve las materias con aranceles especiales>
	-- =============================================
	-- select * from contratos.vst_materias_aranceles_especiales where codcil = 131
create or alter view contratos.vst_materias_aranceles_especiales
as
	select distinct pam_codigo, hpl_codigo 'codhpl', pam_codmat, pam_descripcion, pam_codcil 'codcil', pam_arancel 'valor', pam_tipo_materia 
	from uonline.dbo.pla_pam_pago_arancel_materias
		inner join uonline.dbo.ra_hpl_horarios_planificacion on hpl_codmat = pam_codmat and hpl_codcil = pam_codcil and hpl_descripcion = pam_descripcion
go


	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-12-06 11:17:52.930>
	-- Description: <Devuelve las materias que tienen asignados los docentes>
	-- =============================================
	-- select * from contratos.vst_contratos_docentes where codemp = 4291 and guid = '0cab2cae-4fac-44e0-aead-aae8b3ea1769'
create or alter view contratos.vst_contratos_docentes
as
	select 
		case 
		when enccon_estado_secretaria = 'APR' and enccon_estado_rrhh = 'APR' then 'APR' 
		when enccon_estado_secretaria = 'DEN' or enccon_estado_rrhh = 'DEN' then 'DEN' 
		when enccon_estado_secretaria = 'PEN' or enccon_estado_rrhh = 'PEN' then 'PEN' 
		else '-'
		END 'estado_general', 
		case 
		when enccon_estado_secretaria = 'APR' and enccon_estado_rrhh = 'APR' and isnull(enccon_link_contrato_firmado, '') = '' then '¡Contrato aprobado!, pendiente la carga del archivo PDF firmado' 
		when enccon_estado_secretaria = 'APR' and enccon_estado_rrhh = 'APR' then '¡Contrato aprobado!' 
		when enccon_estado_secretaria = 'DEN' or enccon_estado_rrhh = 'DEN' then 'Denegado' 
		when enccon_estado_secretaria = 'PEN' then 'En revision por secretaria' 
		when enccon_estado_secretaria = 'APR' or enccon_estado_rrhh = 'PEN' then 'Contrato en revision por recursos humanos' 
		else '-'
		END 'estado_general_texto', enccon_codigo 'codenccon', enccon_codemp/*codigo_empleado*/ 'codemp', enccon_codcil 'codcil', concat('0', cil_codcic, '-', cil_anio) 'ciclo', 
		enccon_codemp, enccon_codcil, 
		enccon_periodo, case when enccon_periodo = 'MEN' then 'meses' when enccon_periodo = 'SEM' then 'semanas' else '-' end 'periodo_texto', 
		enccon_duracion_contrato, enccon_horas_totales_impartir, 
		enccon_fecha_congreso, enccon_estado_escuela, enccon_codemp_creacion_escuela, enccon_fecha_revision_escuela, encperf_codperfesc,
		isnull(encperf_nota_obtenida, vst.nota_obtenida) 'nota_obtenida', isnull(vst.nombre_perfilamiento, esc_nombre) 'nombre_perfilamiento', isnull(vst.nombre, emp_apellidos_nombres) 'nombre_docente', codencperf,
		enccon_codemp_secretaria, enccon_codemp_rrhh, enccon_fecha_creacion 'fecha_creacion', enccon_guid 'guid', isnull(vst.codesc, enccon_codesc) 'codesc',
		isnull(vst.escuela, esc_nombre) 'escuela', 
		CONVERT(date, enccon_hora_y_dia_firmara_contrato_secretaria, 103)  'fecha_firma_contrato', 
		CONVERT(CHAR(5), enccon_hora_y_dia_firmara_contrato_secretaria, 108)  'hora_firma_contrato', 
		enccon_numero_hojas_contrato_secretaria 'numero_hojas_contrato_secretaria',
		enccon_link_contrato 'link_contrato', enccon_link_contrato_firmado 'link_contrato_firmado',
		enccon_fecha_revision_secretaria 'fecha_revision_secretaria', enccon_fecha_revision_rrhh 'fecha_revision_rrhh',
		isnull(enccon_valor_hora_actual, vst.valor_hora_actual) 'valor_hora', vst.aga_descripcion, enccon_valor_total_contrato 'valor_total_contrato',
		enccon_fecha_carga_archivo_firmado 'fecha_carga_archivo_firmado', enccon_codemp_cargo_archivo 'codemp_cargo_archivo',
		vst.ultimo_titulo, vst.correos_responsables_escuela, isnull(correo_empleado, emp_email_institucional) 'correo_empleado', encperf_link_resumen_perfil, enccon_fecha_inicio_clases
	from contratos.enccon_encabezado_contrato
		left join perfil.vst_encabezado_perfilamiento vst on vst.codigo_empleado = enccon_codemp and vst.codperfesc = codperfesc
		left join perfil.encperf_encabezado_perfil on enccon_codencperf = encperf_codigo		
		left join uonline.dbo.ra_cil_ciclo on enccon_codcil = cil_codigo

		left join uonline.dbo.ra_esc_escuelas on enccon_codesc = esc_codigo
		left join uonline.dbo.pla_emp_empleado on enccon_codemp = emp_codigo
		left join perfil.perfesc_perfiles_escuela on encperf_codperfesc = perfesc_codigo
go

update uonline.dbo.ra_hpl_horarios_planificacion set hpl_codemp = 4291 where hpl_codigo in (54437,54438, 53978, 53982)
update uonline.dbo.ra_hpl_horarios_planificacion set hpl_codesc = 4, hpl_pagada = 1 where hpl_codigo in (54437,54438, 53978, 53982)
update uonline.dbo.pla_emp_empleado set emp_gacademico = 'E', emp_trabajo_actual = 'Desarrollador', emp_titulo_dui = 'Estudiante', emp_codmun_dui = 3 where emp_codigo = 4291

go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2024-01-20 15:25:36.323>
	-- Description: <docentes con carga academica asignada pero sin incluir la materia>
	-- =============================================
	-- select * from contratos.vst_empleados_con_carga_academica where codcil = 134 and codesc = 4 and codemp = 17 order by codemp
create or alter view contratos.vst_empleados_con_carga_academica
as
	select distinct hpl_codcil 'codcil', concat('0', cil_codcic, '-', cil_anio) 'ciclo',  'hpl' 'origen', emp_codigo 'codemp', 
		emp_nombres_apellidos 'docente', hpl_codesc 'codesc', esc_nombre 'escuela', fac_codigo 'codfac', fac_nombre 'facultad',
		aga_hora_normal 'valor_hora_actual', aga_descripcion,
		(select top 1 titulo from uonline.dbo.vst_titulos_empleados v where v.codemp = emp.emp_codigo order by tti_prioridad) 'ultimo_titulo',
		(select ISNULL(count(1), 0) from uonline.dbo.ra_hpl_horarios_planificacion hpl2 where hpl.hpl_codemp = hpl2.hpl_codemp and hpl.hpl_codcil = hpl2.hpl_codcil and hpl2.hpl_pagada = 1) 'pagadas',
		'DHC' 'tipo', emp.emp_perfil_profesional, (select isnull(count(1), 0) from contratos.enccon_encabezado_contrato where enccon_codemp = hpl_codemp and hpl_codcil = enccon_codcil) 'posee_contrato'
	from uonline.dbo.ra_hpl_horarios_planificacion hpl
		inner join uonline.dbo.pla_emp_empleado emp on hpl_codemp = emp_codigo
		inner join uonline.dbo.ra_cil_ciclo on hpl_codcil = cil_codigo
		inner join uonline.dbo.ra_mat_materias on hpl_codmat = mat_codigo
		inner join uonline.dbo.ra_esc_escuelas on hpl_codesc = esc_codigo
		inner join uonline.dbo.ra_fac_facultades on esc_codfac = fac_codigo
		inner join uonline.dbo.ra_man_grp_hor on hpl_codman = man_codigo
		inner join uonline.dbo.ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia
		inner join uonline.dbo.ra_aul_aulas on hpl_codaul = aul_codigo

		left join uonline.dbo.pla_aga_arancel_grado_acad on aga_grado = emp.emp_gacademico 
	where hpl_codigo >= 51550--01-2023
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-12-06 11:17:52.930>
	-- Description: <Devuelve las materias que tienen asignados los docentes>
	-- =============================================
	-- select * from contratos.vst_materias_asignadas_docente where codemp = 4291 and codcil = 131 and pagada = 1
create or alter view contratos.vst_materias_asignadas_docente
as
	select codcil, ciclo, origen, codigo_origen, codmat, materia, seccion, codigo_tipo_materia, tipo_materia, horario, dias, aula, 
		proyeccion, inscritos, pagada, codemp, docente, codesc, escuela, codfac, facultad, 
		detcon_codenccon 'codenccon', detcon_codigo 'coddetcon', detcon_fecha_creacion
	from (
		select hpl_codcil 'codcil', concat('0', cil_codcic, '-', cil_anio) 'ciclo', 
			'hpl' 'origen', hpl_codigo 'codigo_origen', 
			hpl_codmat 'codmat', mat_nombre 'materia', 
			hpl_descripcion 'seccion', hpl_tipo_materia 'codigo_tipo_materia', tpm_descripcion 'tipo_materia', 
			(case when man_codigo = 0 then 'Sin Definir' else isnull(man_nomhor, 'Sin Definir') end) 'horario', 
			(case when isnull(hpl_lunes,'N') = 'S' then 'Lu-' else '' end+
			case when isnull(hpl_martes,'N') = 'S' then 'Ma-' else '' end+
			case when isnull(hpl_miercoles,'N') = 'S' then 'Mie-' else '' end+
			case when isnull(hpl_jueves,'N') = 'S' then 'Ju-' else '' end+
			case when isnull(hpl_viernes,'N') = 'S' then 'Vi-' else '' end+
			case when isnull(hpl_sabado,'N') = 'S' then 'Sab-' else '' end+
			case when isnull(hpl_domingo,'N') = 'S' then 'Dom-' else '' end) 'dias', aul_nombre_corto 'aula',
			hpl_proyeccion 'proyeccion', 0 'inscritos', hpl_pagada 'pagada',
			emp_codigo 'codemp', emp_nombres_apellidos 'docente', hpl_codesc 'codesc', esc_nombre 'escuela', fac_codigo 'codfac', fac_nombre 'facultad'
		from uonline.dbo.ra_hpl_horarios_planificacion
			inner join uonline.dbo.pla_emp_empleado on hpl_codemp = emp_codigo
			inner join uonline.dbo.ra_cil_ciclo on hpl_codcil = cil_codigo
			inner join uonline.dbo.ra_mat_materias on hpl_codmat = mat_codigo
			inner join uonline.dbo.ra_esc_escuelas on hpl_codesc = esc_codigo
			inner join uonline.dbo.ra_fac_facultades on esc_codfac = fac_codigo
			inner join uonline.dbo.ra_man_grp_hor on hpl_codman = man_codigo
			inner join uonline.dbo.ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia
			inner join uonline.dbo.ra_aul_aulas on hpl_codaul = aul_codigo
		where hpl_codigo >= 51550--01-2023
		--Union all: Pree, pree comun
		--Union all: posgrados, proceso graduacion maes
		--Union all: ...
	) t
		left join contratos.detcon_detalle_contrato on detcon_origen = origen and detcon_codigo_origen = codigo_origen
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-12-19 20:24:51.570>
	-- Description: <Devuelve la hora de la proxima fima de contrato>
	-- =============================================
	-- exec perfil.sp_hora_firma_contrato @codcil = 131, @codesc = 4
create or alter procedure perfil.sp_hora_firma_contrato
	@codcil int = 0, 
	@codesc int = 0
as
begin
	declare @hora_inicio_firma_contratos time = '06:00', @hora_fin_firma_contratos time = '20:00'
	declare @contratos_procesados int = 0
		
	select @contratos_procesados = count(1) from contratos.vst_contratos_docentes 
	where codcil = @codcil and codesc = @codesc
	--set @contratos_procesados = 840--limite de contratos por dia, falta logica para reiniciar al siguiente y aumentar un dia a 'hora_actual_firma'

	select hora_inicio_firma_contratos, hora_fin_firma_contratos, contratos_procesados, hora_actual_firma, ffce_fecha_firmar_contrato
	from (
		select @hora_inicio_firma_contratos 'hora_inicio_firma_contratos', @hora_fin_firma_contratos 'hora_fin_firma_contratos', 
		@contratos_procesados 'contratos_procesados', DATEADD(MI, @contratos_procesados, @hora_inicio_firma_contratos) 'hora_actual_firma',
		*
		from contratos.ffce_fecha_firmar_contrato_escuela 
		where ffce_codcil = @codcil and ffce_codesc = @codesc
	) t
end
GO

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_contrato_prestacion_servicios_prof]    Script Date: 19/12/2023 08:34:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:		<Adones C.>
	-- Create date: <06/12/2023>
	-- Description:	<Contrato prestacion de servicios profecionales.>
	-- =============================================
	-- exec dbo.rep_contrato_prestacion_servicios_prof 4291, '00ed6cb9-ad3e-4bb1-abfe-4086760e2a48'
ALTER PROCEDURE [dbo].[rep_contrato_prestacion_servicios_prof]
	@codemp int,
	@guid_contrato varchar(36)
AS
BEGIN
	SET NOCOUNT ON;
	
	declare @tbl_materias as table (tipo_materia varchar(50), materia varchar(150), seccion varchar(10))
	declare @codcil int = 0, @periodo_texto varchar(50) = '', @codenccon int = 0

	declare @tipo_documento varchar(100) = ''

	select @codcil = vst.codcil, @periodo_texto = periodo_texto, @codenccon = codenccon
	from BD_RRHH.contratos.vst_contratos_docentes vst where vst.codemp = @codemp and vst.guid = @guid_contrato
		insert into @tbl_materias (tipo_materia, materia, seccion)
	select v.tipo_materia, concat(trim(v.codmat), ' ', trim(v.materia)) 'materia', seccion
	from BD_RRHH.contratos.vst_materias_asignadas_docente v
		inner join BD_RRHH.contratos.detcon_detalle_contrato on coddetcon = detcon_codigo
	where codemp = @codemp and codcil = @codcil and detcon_codenccon = @codenccon

	select vst.codemp emp_codigo, emp.emp_nombres_apellidos,
		dbo.fn_crufl_NumerosALetras_normal(datediff(year, emp.emp_fecha_nac, getdate()), 0) edad_letras,
		MUN_NOMBRE municipio, DEP_NOMBRE departamento,
		emp_trabajo_actual puesto, 
		vst.escuela escuela, fac_nombre facultad,
		ultimo_titulo titulo,
		
		trim((
			select stuff((select distinct concat('y ', t.tipo_materia, ' ') from @tbl_materias t for xml path('')), 1, 1, '')
		)) modalidad,

		trim((
			select stuff((select concat('y ', t.materia, ' Sec. ', t.seccion, ' ') from @tbl_materias t for xml path('')), 1, 1, '')
		)) materia,

		case 
			when emp.emp_codtdia022 = 13 then 'Documento Único de Identidad ' 
			when emp.emp_codtdia022 = 2 then 'Carnet de residente' 
			when emp.emp_codtdia022 = 3 then 'Pasaporte' 
			else '*' 
		end 'tipo_documento',
		case 
			when isnull(emp.emp_dui, '') <> '' then emp.emp_dui
			when emp.emp_nit like '9%' then emp.emp_dui
			else emp.emp_nit
		end 'numero_documento',
		case 
			when isnull(emp.emp_dui, '') <> '' then dbo.fn_documentoALetras(emp.emp_dui)
			when emp.emp_nit like '9%' then dbo.fn_documentoALetras(emp.emp_dui)
			else dbo.fn_documentoALetras(emp.emp_nit)
		end 'documento_letras',

		case when ((select count(1) from @tbl_materias) > 1) then 'de las materias' else 'de la materia' end 'de_la',

		upper(@periodo_texto) 'periodo',
		upper(dbo.fn_crufl_NumerosALetras_normal(vst.enccon_duracion_contrato, 0)) plazo_meses,
		vst.valor_total_contrato honorario,
		dbo.fn_numero_a_letras(vst.valor_total_contrato) honorario_letras,

		dbo.fn_crufl_FechaALetras(vst.fecha_firma_contrato, 0, 1) fecha_letras,
		dbo.fn_crufl_FechaALetras(vst.enccon_fecha_inicio_clases, 0, 1) fecha_inicio_clases_letras,
		dbo.fn_crufl_FechaALetras(vst.enccon_fecha_inicio_clases, 1, 1) fecha_inicio_clases_letras_dias,
		

		dbo.fn_crufl_FechaALetras(vst.enccon_fecha_congreso, 0, 1) fecha_congreso_letras,

		--dbo.fn_fechaAHoraLetras(vst.hora_firma_contrato) hora_letras,
		dbo.fn_crufl_FechaALetras(vst.fecha_firma_contrato, 1, 1) fecha_firma_contrato_letras_dias,
		concat(
		dbo.fn_crufl_NumerosALetras_normal (DATEPART(HOUR, vst.hora_firma_contrato), 0), ' horas y ',
		dbo.fn_crufl_NumerosALetras_normal (DATEPART(minute, vst.hora_firma_contrato), 0), 

		case when DATEPART(minute, vst.hora_firma_contrato) = 0 then ' minutos'
		when DATEPART(minute, vst.hora_firma_contrato) = 1 then ' un minuto'
		else 'minutos' end
		) hora_firma_contrato_letras,

		vst.fecha_creacion,
		'HÉCTOR MAURICIO DUQUE LOUCEL' 'director_rrhh',
		'LUCÌA DEL CARMEN ZELAYA DE SOTO' 'secretaria_general',
		numero_hojas_contrato_secretaria, guid, vst.valor_hora, UPPER(dbo.fn_crufl_NumerosALetras_normal(vst.valor_hora, 0)) 'valor_hora_letras'
	from BD_RRHH.contratos.vst_contratos_docentes vst
		inner join pla_emp_empleado emp on emp.emp_codigo = vst.codemp
		left join ra_mun_municipios on emp_codmun_dui = MUN_CODIGO
		left join ra_dep_departamentos on MUN_CODDEP = DEP_CODIGO
		inner join ra_esc_escuelas on vst.codesc = esc_codigo
		inner join ra_fac_facultades on esc_codfac = fac_codigo
	where vst.codemp = @codemp and vst.guid = @guid_contrato
	
END
go
use BD_RRHH
go

use uonline
go
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-12-20 09:52:44.777>
	-- Description: <Devuelve los docentes que aun no tienen contrato asignado>
	-- =============================================
	-- exec uonline.dbo.rep_docentes_sin_contrato @opcion = 1, @codcil = 131, @codesc = 4 --Detalle de materias con o sin contrato
	-- exec uonline.dbo.rep_docentes_sin_contrato @opcion = 2, @codcil = 131, @codesc = 4 --Resumen de contratos
create or alter procedure dbo.rep_docentes_sin_contrato
	@opcion int = 0,
	@codcil int = 0, -- 0: Todos
	@codesc int = 0--0: Todos
as
begin
	
	if @opcion = 1 -- detalle
	begin
		select row_number() over (partition by ciclo, facultad, v.escuela order by codcil, facultad, v.escuela, v.detcon_fecha_creacion, docente, materia) num, 
		ciclo, facultad, v.escuela, codmat, materia, seccion, tipo_materia, v.codemp, docente, detcon_fecha_creacion 'fecha_hora_asignacion_contrato',
		case when isnull(detcon_fecha_creacion, '') <> '' then 1 else 0 end 'asignado', 
		
		(select top 1 v2.nota_obtenida from BD_RRHH.perfil.vst_encabezado_perfilamiento v2 where v2.codigo_empleado = v.codemp and v2.codesc = v.codesc)nota_obtenida, 
		(select top 1 v2.fecha_ultima_actualizacion_nota from BD_RRHH.perfil.vst_encabezado_perfilamiento v2 where v2.codigo_empleado = v.codemp and v2.codesc = v.codesc) fecha_ultima_actualizacion_nota
		from bd_rrhh.contratos.vst_materias_asignadas_docente v
		where v.codcil = case when @codcil = 0 then v.codcil else @codcil end 
			and v.codesc = case when @codesc = 0 then v.codesc else @codesc end and v.pagada = 1
		order by codcil, facultad, v.escuela, v.detcon_fecha_creacion, docente, materia
	end

	if @opcion = 2 -- resumen
	begin
		select codcil, ciclo, facultad, codesc, escuela, pagadas, con_contrato, diferencia 'contratos_faltantes', 
		con_perfilamiento, (total_docentes-con_perfilamiento) 'docentes_sin_perfilamiento', total_docentes
		from (
			select codcil, ciclo, facultad, codesc, escuela, count(1) 'pagadas', sum(con_contrato) 'con_contrato', (count(1) - sum(con_contrato)) 'diferencia',
			(select count(distinct codemp) from BD_RRHH.contratos.vst_materias_asignadas_docente v2 where v2.codcil = t.codcil and v2.codesc = t.codesc and v2.pagada = 1 and isnull(codenccon, '') <> '') 'con_perfilamiento',
			(select count(distinct codemp) from BD_RRHH.contratos.vst_materias_asignadas_docente v2 where v2.codcil = t.codcil and v2.codesc = t.codesc and v2.pagada = 1) 'total_docentes' 
			from (
				select codcil, ciclo, facultad, v.codemp, codesc, escuela, case when isnull(detcon_fecha_creacion, '') <> '' then 1 else 0 end 'con_contrato'
				from bd_rrhh.contratos.vst_materias_asignadas_docente v
				where v.codcil = case when @codcil = 0 then v.codcil else @codcil end 
					and v.codesc = case when @codesc = 0 then v.codesc else @codesc end and v.pagada = 1
			) t
			group by codcil, ciclo, facultad, codesc, escuela
		) t2
	end

end
go