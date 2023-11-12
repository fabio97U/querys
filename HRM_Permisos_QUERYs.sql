-- drop table fper_frecuencia_permiso
create table fper_frecuencia_permiso (
	fper_codigo int primary key identity (1, 1) not null,
	fper_frecuencia_permiso varchar(50) not null,
	fper_dias int not null,
	fper_fecha_creacion datetime default getdate()
)
-- select * from fper_frecuencia_permiso
insert into fper_frecuencia_permiso (fper_frecuencia_permiso, fper_dias) 
values ('Diario', 1), ('Semanal', 7), ('Mensual', 30), ('Trimestral', 90), ('Anual', 365)

-- drop table tper_tipo_permiso
create table tper_tipo_permiso (
	tper_codigo int primary key identity (1, 1) not null,
	tper_nombre_tipo_permiso varchar(80) not null,
	tper_activo bit not null,

	tper_usuario_creacion varchar(50),
	tper_fecha_creacion datetime default getdate()
)
-- select * from tper_tipo_permiso
insert into tper_tipo_permiso (tper_nombre_tipo_permiso, tper_activo, tper_usuario_creacion)
values ('1. FALTA DE MARCACIÓN', 1, 4291), ('2. ENFERMEDAD', 1, 4291), ('3. DUELO', 1, 4291), ('4. PERSONAL (1)', 1, 4291), 
	('5. CUMPLEAÑOS', 1, 4291), ('6. LACTANCIA (2)', 1, 4291), ('7. PATERNIDAD', 1, 4291), ('8. CASAMIENTO', 1, 4291), ('9. MISION INSTITUCIONAL', 1, 4291), 
	('10. TIEMPO COMPENSATORIO', 1, 4291)

-- drop table dtper_detalle_tipo_permiso
create table dtper_detalle_tipo_permiso (
	dtper_codigo int primary key identity (1, 1) not null,
	
	dtper_codfper int not null foreign key references fper_frecuencia_permiso,
	dtper_codtper int not null foreign key references tper_tipo_permiso,
	dtper_nombre_detalle_tipo_permiso varchar(125) not null,
	dtper_cantidad_permitidos int null,
	dtper_dias_maximo_solicitados int default 1 not null,
	dtper_horas_maximas int null,
	dtper_requiere_adjuntar_evidencias bit default 0 not null,
	dtper_es_otrosespecifique bit not null default 0,

	dtper_requiere_revision bit not null default 1,

	dtper_dias_antes int not null,
	dtper_dias_despues int not null,
	dtper_referencia_softland int,

	dtper_usuario_creacion varchar(50),
	dtper_fecha_creacion datetime default getdate()
)
-- select * from dtper_detalle_tipo_permiso
insert into dtper_detalle_tipo_permiso 
(dtper_codfper, dtper_codtper, dtper_nombre_detalle_tipo_permiso, dtper_cantidad_permitidos, 
dtper_dias_maximo_solicitados, dtper_horas_maximas, dtper_requiere_adjuntar_evidencias, dtper_requiere_revision, dtper_dias_antes, dtper_dias_despues, dtper_referencia_softland, dtper_usuario_creacion)
values 
(1, 1, 'Falla de Reloj', 1, 1, NULL, 0, 1, 3, 0, 17, 4291), 
(3, 1, 'Olvido de marcación, Se permiten 2 al mes', 2, 1, NULL, 0, 1, 3, 0, 19, 4291), 
(1, 2, 'ISSS - Cita - Del empleado', 1, 1, NULL, 1, 1, 7, 3, 20, 4291), 
(1, 2, 'Incapacidad - Del empleado', 1, 3, NULL, 1, 1, 0, 3, 9, 4291), 
(1, 2, 'PARTICULAR - Del empleado', 1, 1, NULL, 1, 1, 7, 3, 21, 4291), 
(1, 2, 'ISSS ó PARTICULAR - Cónyuge', 1, 2, NULL, 1, 1, 7, 3, 20, 4291), 
(1, 2, 'ISSS ó PARTICULAR - Hijo', 1, 2, NULL, 1, 1, 7, 3, 20, 4291), 
(1, 2, 'ISSS ó PARTICULAR - Madre ó padre', 1, 2, NULL, 1, 1, 7, 3, 20, 4291), 
(1, 3, 'Cónyuge', 1, 5, NULL, 1, 1, 7, 3, 22, 4291), 
(1, 3, 'Madre ó padre', 1, 5, NULL, 1, 1, 7, 3, 22, 4291), 
(1, 3, 'Hijo', 1, 5, NULL, 1, 1, 7, 3, 22, 4291), 
(1, 3, 'Hermano', 1, 2, NULL, 0, 1, 7, 3, 22, 4291), 
(5, 4, 'Empleado', NULL, 3, 120, 0, 1, 7, 30, 18, 4291), 
(5, 5, 'Empleado', 1, 1, NULL, 0, 0, 7, 3, 28, 4291), 
(1, 6, 'Mañana', 1, 1, NULL, 0, 1, 7, 3, 23, 4291), 
(1, 7, 'Del empleado', 1, 1, NULL, 0, 1, 7, 3, 33, 4291), 
(1, 8, 'Empleado', 1, 1, NULL, 0, 1, 7, 3, 32, 4291), 
(1, 9, 'Capacitación (mision)', 1, 1, NULL, 0, 1, 7, 3, 24, 4291), 
(1, 10, 'Empleado', 1, 1, NULL, 0, 1, 7, 7, 0, 4291)
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-02-08 21:07:29.973>
	-- Description: <Devuelve todos los tipos de permisos disponibles a solicitar por los empleados>
	-- =============================================
	-- select * from vst_permisos_disponibles
alter view vst_permisos_disponibles
as
	select tper_codigo, tper_nombre_tipo_permiso, tper_activo, fper_frecuencia_permiso, fper_dias, dtper_codigo, 
		dtper_nombre_detalle_tipo_permiso, dtper_cantidad_permitidos, dtper_dias_maximo_solicitados,
		dtper_horas_maximas, dtper_requiere_adjuntar_evidencias, dtper_requiere_revision, dtper_dias_antes, dtper_dias_despues, dtper_referencia_softland,
		dtper_es_otrosespecifique
	from dtper_detalle_tipo_permiso
		inner join tper_tipo_permiso on dtper_codtper = tper_codigo
		inner join fper_frecuencia_permiso on dtper_codfper = fper_codigo
	where tper_activo = 1 
go

-- drop table sper_solicitd_permiso
create table sper_solicitd_permiso (
	sper_codigo int primary key identity (1, 1) not null,
	sper_codemp int not null,
	sper_coduni int not null,
	sper_coddtper int foreign key references dtper_detalle_tipo_permiso not null,
	sper_horas_descanso_empleado int default 1 not null,

	--Inicio: Solo cuando es tiempo compesatorio
	sper_fecha_hora_loboro varchar(512) null,
	sper_actividad_realizada varchar(512) null, 
	sper_otros varchar(512) null, 
	--Fin: Solo cuando es tiempo compesatorio

	sper_tiempo_desde varchar(5) not null,
	sper_tiempo_hasta varchar(5) not null,
	
	sper_horas real,
	sper_total_horas real,

	sper_total_dias_laborales int,
	sper_total_dias real,
	
	sper_fecha_desde date not null,
	sper_fecha_hasta date not null,

	sper_horasOdias_restantes real,

	sper_codemp_jefe int not null,
	sper_autorizado_jefe bit default 0 not null,
	sper_estado_jefe varchar(3) default 'PEN' not null, --PEN: Pendiente, APR: Aprobado, DEN: Denegado
	sper_fecha_reviso_jefe datetime null,
	sper_con_goce_sueldo_jefe bit null,
	sper_comentario_jefe varchar(1024) null,

	sper_codemp_rrhh int null,
	sper_autorizado_rrhh bit  default 0 not null,
	sper_estado_rrhh varchar(3) default 'PEN' not null, --PEN: Pendiente, APR: Aprobado, DEN: Denegado
	sper_fecha_reviso_rrhh datetime null,
	sper_con_goce_sueldo_rrhh bit null,
	sper_comentario_rrhh varchar(1024) null,

	sper_activo bit default 1 not null,
	sper_fecha_inactivo datetime null,
	sper_comentario_inactivo_rrhh varchar(1024) null,

	sper_usuario_creacion varchar(50), 
	sper_fecha_creacion datetime default getdate() not null
)
-- select * from sper_solicitd_permiso

insert into sper_solicitd_permiso 
(sper_codemp, sper_coduni, sper_coddtper, sper_horas_descanso_empleado, sper_tiempo_desde, sper_tiempo_hasta, 
sper_fecha_desde, sper_fecha_hasta, sper_codemp_jefe, sper_usuario_creacion, sper_total_horas, sper_total_dias, sper_otros, sper_fecha_hora_loboro, sper_actividad_realizada)
values (3724, 13, 1, 1, '08:00', '12:00', '2023-02-08', '2023-02-09', 3724, 4291, 4, 0.5, '', '', ''),
(276, 8, 1, 1, '08:00', '12:00', '2023-02-08', '2023-02-09', 3724, 4291, 4, 0.5, '', '', '')
go

-- drop table evsper_evidencia_solicitd_permiso
create table evsper_evidencia_solicitd_permiso (
	evsper_codigo int primary key identity (1, 1) not null,
	evsper_codsper int foreign key references sper_solicitd_permiso,
	evsper_nombre_archivo varchar(1024),
	evsper_link_evidencia varchar(1024),
	evsper_fecha_creacion datetime default getdate() not null
)
go

-- select * from evsper_evidencia_solicitd_permiso
select * from adm_aud_auditoria
select * from uonline.dbo.vst_empleados_x_unidad where CODUNI = 133
select * from uonline.dbo.vst_empleados_x_unidad where CODUNI = 13
select * from uonline.dbo.vst_empleados_x_unidad where EMPRESARIAL <> ''


select * from uonline.dbo.vst_empleados_x_unidad order by NOMBREUNIDAD
--Decanos: Ventura
---En rrhh puede autorizar Hector y Xiomara
--Todos los permisos del rector enviar al Dr. Ventura
-- A los que dependen de presidencia que Hector los pueda aprobar tambien
-- loucelm@utec.edu.sv -> jmloucel@utec.edu.sv

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-02-08 21:26:18.687>
	-- Description: <Devuelve todos los permisos solicitados por los empleados>
	-- =============================================
	-- select * from vst_solicitud_permisos order by codsper desc
alter view vst_solicitud_permisos
as
	select sper_codigo 'codsper', 
		sper_activo,
		case 
			when sper_activo = 0 then 'Cancelado por empleado'
			when sper_estado_jefe = 'PEN' then 'Pendiente por jefe'
			when sper_estado_rrhh = 'PEN' then 'Pendiente RRHH'
			when sper_estado_jefe = 'DEN' then 'Denegado por jefe'
			when sper_estado_rrhh = 'DEN' then 'Denegado por RRHH' 
			when sper_estado_jefe = 'APR' then 'Aprobado por jefe'
			when sper_estado_rrhh = 'APR' then 'Aprobado por RRHH'
		end 'estado_texto', 

		case 
			when sper_activo = 0 then 'CANCELADO'
			when sper_estado_jefe = 'DEN' or sper_estado_rrhh = 'DEN' then 'DEN'
			when sper_estado_jefe = 'APR' and sper_estado_rrhh = 'APR' then 'APR'
			else 'PEN'
		end 'estado_general', 

		case when emp1.emp_nombres_apellidos = emp4.emp_nombres_apellidos then 'Empleado' else emp4.emp_nombres_apellidos end 'solicitado_por', 
		case when emp1.emp_nombres_apellidos = emp4.emp_nombres_apellidos then '' else vst2.PLAZA end 'cargo_solicitado_por',

		tper_codigo 'codtper', tper_nombre_tipo_permiso, dtper_codigo 'coddtper', dtper_nombre_detalle_tipo_permiso, fper_frecuencia_permiso,
		sper_horas_descanso_empleado,
		vst1.PLAZA 'plaza_empleado',
		emp1.emp_codigo 'codemp_permiso', emp1.emp_primer_nom, emp1.emp_nombres_apellidos 'empleado_permiso', 
		
		case when emp1.emp_nombres_apellidos = emp4.emp_nombres_apellidos then emp1.emp_email_empresarial else emp4.emp_email_empresarial end
		 'correo_empleado_permiso', 

		sper_coduni 'coduni', uni_nombre 'unidad', sper_fecha_creacion 'fecha_solicitud',
		sper_fecha_hora_loboro, sper_actividad_realizada, sper_otros,
		sper_tiempo_desde, sper_tiempo_hasta, sper_horas /*DATEDIFF(HH, sper_tiempo_desde, sper_tiempo_hasta)*/ 'horas', 
		
		sper_fecha_desde, sper_fecha_hasta, 
		sper_total_dias /*DATEDIFF(DD, sper_fecha_desde, sper_fecha_hasta)*/ 'total_dias', sper_total_dias_laborales,
		sper_total_horas 'total_horas',
		case when sper_fecha_desde = sper_fecha_hasta then FORMAT(sper_fecha_hasta, 'dd/MM/yyyy') else 
		concat(FORMAT(sper_fecha_desde, 'dd/MM/yyyy'), ' a ', FORMAT(sper_fecha_hasta, 'dd/MM/yyyy')) end fecha_desde_hasta_junto,
		sper_horasOdias_restantes, 
		emp2.emp_codigo 'codemp_jefe', emp2.emp_nombres_apellidos 'jefe', sper_autorizado_jefe, 
		
		case when sper_activo = 0 then 'CANCELADO' else sper_estado_jefe end sper_estado_jefe, 

		sper_con_goce_sueldo_jefe, case when sper_con_goce_sueldo_jefe = 1 then 'Si' when sper_con_goce_sueldo_jefe = 0 then 'No' else '-' end 'goce_sueldo_jefe',
		sper_comentario_jefe, sper_fecha_reviso_jefe, 
		vst1.CORREO_JEFE/* emp2.emp_email_empresarial*/ 'correo_jefe',
		emp3.emp_codigo 'codemp_rrhh', emp3.emp_nombres_apellidos 'rrhh_empleado_reviso', sper_autorizado_rrhh, 
		
		case when sper_activo = 0 then 'CANCELADO' else sper_estado_rrhh end sper_estado_rrhh, 

		sper_fecha_reviso_rrhh, emp3.emp_email_empresarial 'correo_rrhh', 
		sper_con_goce_sueldo_rrhh, case when sper_con_goce_sueldo_rrhh = 1 then 'Si' when sper_con_goce_sueldo_rrhh = 0 then 'No' else '-' end 'goce_sueldo_rrhh', sper_comentario_rrhh,
		'-' 'goce_sueldo', sper_comentario_inactivo_rrhh
	from sper_solicitd_permiso
		inner join uonline.dbo.pla_emp_empleado emp1 on sper_codemp = emp1.emp_codigo
		inner join uonline.dbo.vst_empleados_x_unidad vst1 on vst1.CODIGO = emp1.emp_codigo
		
		inner join dtper_detalle_tipo_permiso on sper_coddtper = dtper_codigo
		inner join tper_tipo_permiso on tper_codigo = dtper_codtper 
		inner join fper_frecuencia_permiso on dtper_codfper = fper_codigo
		inner join uonline.dbo.pla_emp_empleado emp2 on sper_codemp_jefe = emp2.emp_codigo
		left join uonline.dbo.pla_emp_empleado emp3 on sper_codemp_rrhh = emp3.emp_codigo
		
		inner join uonline.dbo.pla_emp_empleado emp4 on sper_usuario_creacion = emp4.emp_codigo
		inner join uonline.dbo.vst_empleados_x_unidad vst2 on vst2.CODIGO = emp4.emp_codigo

		inner join uonline.dbo.pla_uni_unidad uni on sper_coduni = uni.uni_codigo
go

USE [BD_RRHH]
GO
/****** Object:  StoredProcedure [dbo].[sp_validar_permitir_solicitud_permiso]    Script Date: 25/3/2023 10:48:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

USE [BD_RRHH]
GO
/****** Object:  StoredProcedure [dbo].[sp_validar_permitir_solicitud_permiso]    Script Date: 29/3/2023 11:34:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-02-08 22:13:51.810>
	-- Description: <Valida si un empleado puede solicitar un permiso, 
				-- res: {1: si es permitido solicitar permiso, 0: no es permitido el permiso}>
	-- =============================================
	-- exec dbo.sp_validar_permitir_solicitud_permiso 1, 13, 276, '29/03/2023', '29/03/2023', 1
ALTER proc [dbo].[sp_validar_permitir_solicitud_permiso]
	@opcion int = 0,
	@coddtper int = 0,
	@codemp int = 0,
	 
	@fechadesde varchar(12) = '',
	@fechahasta varchar(12) = '',
	@horassolicitadas float = 0.0
as
begin
	set dateformat dmy
	set language Spanish

	declare @permisos_disponibles int = 0, @permisos_solicitados int = 0, @horas_solicitadas float = 0.0,
		@codigo_respuesta int = 0, @msj varchar(1024)= '', @frecuencia_permiso varchar(20) = '',
		@cantidad_permitidos int = 0, @dias_maximo_solicitados int = 0, @horas_maximas float = 0.0,
		
		@permiso varchar(500) = '', @horasOdias_restantes float = 0.0
		
	declare @fechaDesde_ date = cast(@fechadesde as date), @fechahasta_ date = cast(@fechahasta as date)

	declare @cantidad_dias_solicitados real = 0.0
	select @cantidad_dias_solicitados = dbo.fn_total_dias_rangofechas(@fechadesde, @fechahasta)

	print '@cantidad_dias_solicitados: ' + cast(@cantidad_dias_solicitados as varchar(3))
	
	if @opcion = 1 -- Valida si el @codemp puede solicitar el permiso @coddtper
	begin
		--select * from fper_frecuencia_permiso
		select @frecuencia_permiso = fper_frecuencia_permiso, 
			@cantidad_permitidos = dtper_cantidad_permitidos, @dias_maximo_solicitados = dtper_dias_maximo_solicitados,
			@horas_maximas = dtper_horas_maximas,
			@permiso = tper_nombre_tipo_permiso + ' - ' + dtper_nombre_detalle_tipo_permiso
		from vst_permisos_disponibles where dtper_codigo = @coddtper

		print '@frecuencia_permiso: ' + cast(@frecuencia_permiso as varchar(20))
		print '@cantidad_permitidos: ' + cast(@cantidad_permitidos as varchar(20))
		print '@dias_maximo_solicitados: ' + cast(@dias_maximo_solicitados as varchar(20))
		print '@horas_maximas: ' + cast(isnull(@horas_maximas, '') as varchar(20)) 
		print '@permiso: ' + cast(@permiso as varchar(500))
		
		if @cantidad_dias_solicitados > @dias_maximo_solicitados
		begin
			set @codigo_respuesta = -1
			if @dias_maximo_solicitados = 1
				set @msj = 'Solo es permitido solicitar un día, mis días solicitados: '+cast(@cantidad_dias_solicitados as varchar(3))
			else
				set @msj = 'La cantidad máxima de días solicitados es: '+cast(@dias_maximo_solicitados as varchar(3))+', mis días solicitados: '+cast(@cantidad_dias_solicitados as varchar(3))
			
			select @codigo_respuesta codigo_respuesta, @msj 'msj', @horasOdias_restantes 'horasOdias_restantes'
			return
		end

		if @coddtper = 14 -- Cumpleaños
		begin
			declare @fecha_cumpleano_empleado date
			select @fecha_cumpleano_empleado = emp_fecha_nac from uonline.dbo.pla_emp_empleado where emp_codigo = @codemp
			print '@fecha_cumpleano_empleado: ' + cast(@fecha_cumpleano_empleado as varchar(16))

			if month(@fecha_cumpleano_empleado) <> MONTH(@fechaDesde_)
			begin
				set @codigo_respuesta = -1
				set @msj = 'El permiso de cumpleaños solo se puede solicitar el mismo mes del cumpleaños (' + DATENAME(MONTH, @fecha_cumpleano_empleado) + ')'
				select @codigo_respuesta codigo_respuesta, @msj 'msj', @horasOdias_restantes 'horasOdias_restantes'
				return
			end
		end

		if (@frecuencia_permiso = 'Diario')
		begin
			select @permisos_solicitados = count(1), @horas_solicitadas = sum(total_horas) + @horassolicitadas from vst_solicitud_permisos 
			where sper_fecha_desde >= @fechadesde_ and sper_fecha_hasta <= @fechahasta_ and codemp_permiso = @codemp
			and coddtper = @coddtper and estado_general not in ('DEN') and sper_activo = 1
		end

		if (@frecuencia_permiso = 'Mensual')
		begin
			declare @mes_desde int = month(@fechadesde_), @mes_hasta int = month(@fechahasta_)

			select @permisos_solicitados = count(1), @horas_solicitadas = sum(total_horas) + @horassolicitadas from vst_solicitud_permisos
			where month(sper_fecha_desde) = @mes_desde and codemp_permiso = @codemp and coddtper = @coddtper and sper_activo = 1
			and estado_general not in ('DEN')
		end

		if (@frecuencia_permiso = 'Anual')
		begin
			declare @anio int = year(@fechadesde_)

			select @permisos_solicitados = count(1), @horas_solicitadas = sum(total_horas) + @horassolicitadas from vst_solicitud_permisos
			where year(sper_fecha_desde) = @anio and codemp_permiso = @codemp and coddtper = @coddtper and sper_activo = 1
			and estado_general not in ('DEN')

		end

		print '@permisos_solicitados: ' + cast(@permisos_solicitados as varchar(10)) + ' @cantidad_permitidos: ' + cast(@cantidad_permitidos as varchar(10))
		print '@horas_maximas: ' + cast(isnull(@horas_maximas, '') as varchar(20)) + ' @horas_solicitadas: ' + cast(isnull(@horas_solicitadas, 0) as varchar(10))
		
		if @horas_maximas is not null--Es permiso por horas
		begin
			print 'El permiso valida por horas'--aqui
			if @horas_solicitadas >= @horas_maximas
			begin
				set @codigo_respuesta = -1
				set @msj = 'Para el permiso “'+@permiso+'” solo es permitido solicitar ' + cast(@horas_maximas as varchar(10)) + ' hora/s “'+@frecuencia_permiso+'”, mi cantidad de horas: “' + cast(@horas_solicitadas as varchar(10)) + '”'
			end
			else
			begin
				set @codigo_respuesta = 1
				set @msj = 'Ok'
				set @horasOdias_restantes = @horas_maximas - ISNULL(@horas_solicitadas, 0)
			end
		end
		else
		begin--El permiso es por dias
			if @permisos_solicitados >= @cantidad_permitidos
			begin
				set @codigo_respuesta = -1
				set @msj = 'Para el permiso “'+@permiso+'” solo es permitido solicitar ' + cast(@cantidad_permitidos as varchar(10)) + ' permiso/s “'+@frecuencia_permiso+'”, mi cantidad de permisos hechos: “' + cast(@permisos_solicitados as varchar(10)) + '”'
			end
			else
			begin
				set @codigo_respuesta = 1
				set @msj = 'Ok'
				set @horasOdias_restantes = (@cantidad_permitidos - ISNULL(@permisos_solicitados, 0))
			end
		end
		
		select @codigo_respuesta codigo_respuesta, @msj 'msj', @horasOdias_restantes 'horasOdias_restantes'
	end
end
GO