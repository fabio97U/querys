select * from ni_sni_solicitud_nuevo_ingreso
-- drop table ni_snim_solicitud_nuevo_ingreso_maestrias
create table ni_snim_solicitud_nuevo_ingreso_maestrias (
	snim_codigo int primary key identity (1, 1),
	snim_codusr_reviso int,
	snim_estado_solicitud varchar(5) default 'P',
	snim_descripcion_caso varchar(150), 
	snim_codper_asignado int,

	snim_tipo int,--1: NUEVO INGRESO, 4: POR EQUIVALENCIA
	snim_programa int, --CODPLA
	snim_sexo char(1),--M, F
	snim_primer_apellido varchar(50),
	snim_segundo_apellido varchar(50),
	snim_nombres varchar(50),
	snim_direccion_actual varchar(255),
	snim_telefono varchar(30),
	snim_departamento varchar(125),--CONSERVAR EL MISMO FORMATO DEL ACTUAL
	snim_municipio varchar(125),--CONSERVAR EL MISMO FORMATO DEL ACTUAL
	snim_celular varchar(50),
	snim_fecha_nacimiento date,--YYYY-MM-DD
	snim_nacionalidad varchar(125),--CONSERVAR EL MISMO FORMATO DEL ACTUAL
	snim_estado_civil varchar(50),--CONSERVAR EL MISMO FORMATO DEL ACTUAL: ACOMPAÑADO/A, VIUDO/A, DIVORCIADO/A, COMPROMETIDO/A, CASADO/A, SOLTERO/A
	snim_dui varchar(30), 
	snim_nit varchar(30),
	snim_tipo_sangre varchar(30), 
	snim_isss varchar(30), 
	snim_email varchar(30), 
	
	snim_en_caso_emergencia varchar(100), 
	snim_parentesco varchar(50),
	snim_telefono_parentesco varchar(20),
	snim_direccion_parentesco varchar(125),
	
	snim_titulo_pregreado varchar(125),
	snim_institucion_titulo varchar(125),
	snim_anio_graduacion int,
	snim_estudios_postgrado varchar(125),
	snim_nivel_idioma_ingles varchar(50),
	snim_otro_idioma varchar(50),

	snim_empresa_labora varchar(100),
	snim_direccion_empresa varchar(125),
	snim_cargo_desempenia varchar(125),
	snim_telefono_empresa varchar(50),
	snim_email_empresa varchar(125), 

	snim_link_fotografia_reciente varchar(500),
	snim_link_titulo_universitario varchar(500),
	snim_link_dui varchar(500),
	snim_link_certificado_titulo varchar(500),
	snim_link_partida_nacimiento varchar(500),
	snim_link_certificado_notas varchar(500),
	snim_link_fotografia_cedula varchar(500),
	snim_link_certificado_notas_mined varchar(500),
	snim_link_cv varchar(500),

	snim_traking_num varchar(30), -- Identificador de trend

	snim_fecha_creacion datetime default getdate()
)
-- select * from ni_snim_solicitud_nuevo_ingreso_maestrias
select tde_nombre, car_estado, car_nombre, car_identificador, pla_estado, pla_codigo, pla_alias_carrera, pla_nombre from ra_pla_planes 
inner join ra_car_carreras on pla_codcar = car_codigo 
inner join ra_tde_TipoDeEstudio on car_codtde = tde_codigo 
where car_codtde = 2 and pla_estado = 'A' --AND car_estado = 'A' --and pla_tipo = 'P'
order by car_nombre






USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_sni_solicitud_nuevo_ingreso_maestrias]    Script Date: 09/12/2021 18:56:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2021-12-09T18:57:21.6234446-06:00>
	-- Description: <Realiza la inserción de los datos de la solicitud de nuevo ingreso, y muestra los datos de solicitudes>
	-- =============================================
	-- sp_sni_solicitud_nuevo_ingreso_maestrias 1
create procedure dbo.sp_sni_solicitud_nuevo_ingreso_maestrias
	@opcion int = 0,
	
	@snim_tipo int = 0,
	@snim_programa int = 0,
	@snim_sexo char(1) = '',
	@snim_primer_apellido varchar(50) = '',
	@snim_segundo_apellido varchar(50) = '',
	@snim_nombres varchar(50) = '',
	@snim_direccion_actual varchar(255) = '',
	@snim_telefono varchar(30) = '',
	@snim_departamento varchar(125) = '',
	@snim_municipio varchar(125) = '',
	@snim_celular varchar(50) = '',
	@snim_fecha_nacimiento date = '',
	@snim_nacionalidad varchar(125) = '',
	@snim_estado_civil varchar(50) = '',
	@snim_dui varchar(30) = '',
	@snim_nit varchar(30) = '',
	@snim_tipo_sangre varchar(30) = '',
	@snim_isss varchar(30) = '',
	@snim_email varchar(30) = '',
	@snim_en_caso_emergencia varchar(100) = '',
	@snim_parentesco varchar(50) = '',
	@snim_telefono_parentesco varchar(20) = '',
	@snim_direccion_parentesco varchar(125) = '',
	@snim_titulo_pregreado varchar(125) = '',
	@snim_institucion_titulo varchar(125) = '',
	@snim_anio_graduacion int = '',
	@snim_estudios_postgrado varchar(125) = '',
	@snim_nivel_idioma_ingles varchar(50) = '',
	@snim_otro_idioma varchar(50) = '',
	@snim_empresa_labora varchar(100) = '',
	@snim_direccion_empresa varchar(125) = '',
	@snim_cargo_desempenia varchar(125) = '',
	@snim_telefono_empresa varchar(50) = '',
	@snim_email_empresa varchar(125) = '',
	@snim_link_fotografia_reciente varchar(500) = '',
	@snim_link_titulo_universitario varchar(500) = '',
	@snim_link_dui varchar(500) = '',
	@snim_link_certificado_titulo varchar(500) = '',
	@snim_link_partida_nacimiento varchar(500) = '',
	@snim_link_certificado_notas varchar(500) = '',
	@snim_link_fotografia_cedula varchar(500) = '',
	@snim_link_certificado_notas_mined varchar(500) = '',
	@snim_link_cv varchar(500) = '',
	@snim_traking_num varchar(30) = '',

	@txt_buscar varchar(500) = '',
	@fecha_desde nvarchar(12) = '', 
	@fecha_hasta nvarchar(12) = '',
	@codsnim int = 0,
	@codusr int = 0,
	@estado_solicitud varchar(5) = '',
	@descripcion_caso varchar(150) = '', 
	@codper_asignado int = 0
as
begin
	
	if @opcion = 1 --Inserta los datos a la tabla "sni_solicitud_nuevo_ingreso", desde la API, https://portalpag.utec.edu.sv/webapi/api/SolicitudNiMaestrias
	begin
		insert into ni_snim_solicitud_nuevo_ingreso_maestrias (
			snim_tipo, snim_programa, snim_sexo, snim_primer_apellido, snim_segundo_apellido, snim_nombres, snim_direccion_actual, snim_telefono, snim_departamento, snim_municipio, snim_celular, snim_fecha_nacimiento, snim_nacionalidad, snim_estado_civil, snim_dui, snim_nit, snim_tipo_sangre, snim_isss, snim_email, snim_en_caso_emergencia, snim_parentesco, snim_telefono_parentesco, snim_direccion_parentesco, snim_titulo_pregreado, snim_institucion_titulo, snim_anio_graduacion, snim_estudios_postgrado, snim_nivel_idioma_ingles, snim_otro_idioma, snim_empresa_labora, snim_direccion_empresa, snim_cargo_desempenia, snim_telefono_empresa, snim_email_empresa, snim_link_fotografia_reciente, snim_link_titulo_universitario, snim_link_dui, snim_link_certificado_titulo, snim_link_partida_nacimiento, snim_link_certificado_notas, snim_link_fotografia_cedula, snim_link_certificado_notas_mined, snim_link_cv, snim_traking_num
		)
		values (
			@snim_tipo, @snim_programa, @snim_sexo, @snim_primer_apellido, @snim_segundo_apellido, @snim_nombres, @snim_direccion_actual, @snim_telefono, @snim_departamento, @snim_municipio, @snim_celular, @snim_fecha_nacimiento, @snim_nacionalidad, @snim_estado_civil, @snim_dui, @snim_nit, @snim_tipo_sangre, @snim_isss, @snim_email, @snim_en_caso_emergencia, @snim_parentesco, @snim_telefono_parentesco, @snim_direccion_parentesco, @snim_titulo_pregreado, @snim_institucion_titulo, @snim_anio_graduacion, @snim_estudios_postgrado, @snim_nivel_idioma_ingles, @snim_otro_idioma, @snim_empresa_labora, @snim_direccion_empresa, @snim_cargo_desempenia, @snim_telefono_empresa, @snim_email_empresa, @snim_link_fotografia_reciente, @snim_link_titulo_universitario, @snim_link_dui, @snim_link_certificado_titulo, @snim_link_partida_nacimiento, @snim_link_certificado_notas, @snim_link_fotografia_cedula, @snim_link_certificado_notas_mined, @snim_link_cv, @snim_traking_num
		)
		select scope_identity()
	end

	if @opcion = 2 -- Devuelve la data de las solicitudes de nuevo ingreso realizadas desde @fecha_desde hasta @fecha_hasta
	begin
		-- sp_sni_solicitud_nuevo_ingreso_maestrias @opcion = 2, @fecha_desde = '18/06/2020', @fecha_hasta = '23/06/2020', @txt_buscar = '', @sni_codusr_reviso_tramite = 407
		select * from (
			select snim_codigo, snim_primer_apellido
			--sni_codigo, sni_Carrera_preferencia, sni_Primer_apellido, sni_Segundo_apellido, sni_Nombres, sni_Sexo, sni_Telefono, sni_Celular, sni_Email,
			--sni_estado_solicitud, case sni_estado_solicitud when 'P' then 'Pendiente' when 'R' then 'Revisado' else 'Finalizada' end estado, sni_descripcion_caso, usr_usuario 'usuario',
			--sni_fecha_hora_creacion, sni_equivalencia,
			--(case when isnull(sni_per_codigo_asignado, 0) = 0 then '' else (select per_carnet from ra_per_personas where per_codigo = sni_per_codigo_asignado) end ) per_carnet,
			--(case when isnull(sni_per_codigo_asignado, 0) = 0 then null else (select per_fecha from ra_per_personas where per_codigo = sni_per_codigo_asignado) end ) per_fecha,
			--sni_Deprt
			from ni_snim_solicitud_nuevo_ingreso_maestrias
			left join adm_usr_usuarios on usr_codigo = snim_codusr_reviso
			--inner join ni_asigsni_asignacion_solcitud_nuevo_ingreso on asigsni_codsni_asginado = sni_codigo
			where convert(date, snim_fecha_creacion, 103) between convert(date, @fecha_desde, 103) and convert(date, @fecha_hasta, 103)
			--and asigsni_codusr_asignado = @sni_codusr_reviso_tramite
		) t2
		where (
			ltrim(rtrim(snim_primer_apellido)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		order by snim_codigo
	end

	if @opcion = 3
	begin
		-- sp_sni_solicitud_nuevo_ingreso_maestrias @opcion = 3, @codsni = 1
		select * from ni_snim_solicitud_nuevo_ingreso_maestrias where snim_codigo = @codsnim
	end
	
	if @opcion = 4
	begin
		-- sp_sni_solicitud_nuevo_ingreso_maestrias @opcion = 4, @codsni = 1
		update ni_snim_solicitud_nuevo_ingreso_maestrias set snim_estado_solicitud = @estado_solicitud, snim_descripcion_caso = @descripcion_caso,
		snim_codusr_reviso = @codusr
		where snim_codigo = @codsnim

		declare @usuario varchar(25)
		select @usuario = usr_usuario from adm_usr_usuarios where usr_codigo = @codusr
		declare @fecha_aud datetime, @registro varchar(200)
		set @fecha_aud = getdate()
		select @registro = concat('codsnim:',@codsnim,',estado:', @estado_solicitud, ',descripcion:', @descripcion_caso)
		exec auditoria_del_sistema 'ni_snim_solicitud_nuevo_ingreso_maestrias','U', @usuario, @fecha_aud, @registro
	end

	if @opcion = 6
	begin
		update ni_snim_solicitud_nuevo_ingreso_maestrias set 
			snim_tipo = @snim_tipo, snim_programa = @snim_programa, snim_sexo = @snim_sexo, snim_primer_apellido = @snim_primer_apellido, snim_segundo_apellido = @snim_segundo_apellido, snim_nombres = @snim_nombres, snim_direccion_actual = @snim_direccion_actual, snim_telefono = @snim_telefono, snim_departamento = @snim_departamento, snim_municipio = @snim_municipio, snim_celular = @snim_celular, snim_fecha_nacimiento = @snim_fecha_nacimiento, snim_nacionalidad = @snim_nacionalidad, snim_estado_civil = @snim_estado_civil, snim_dui = @snim_dui, snim_nit = @snim_nit, snim_tipo_sangre = @snim_tipo_sangre, snim_isss = @snim_isss, snim_email = @snim_email, snim_en_caso_emergencia = @snim_en_caso_emergencia, snim_parentesco = @snim_parentesco, snim_telefono_parentesco = @snim_telefono_parentesco, snim_direccion_parentesco = @snim_direccion_parentesco, snim_titulo_pregreado = @snim_titulo_pregreado, snim_institucion_titulo = @snim_institucion_titulo, snim_anio_graduacion = @snim_anio_graduacion, snim_estudios_postgrado = @snim_estudios_postgrado, snim_nivel_idioma_ingles = @snim_nivel_idioma_ingles, snim_otro_idioma = @snim_otro_idioma, snim_empresa_labora = @snim_empresa_labora, snim_direccion_empresa = @snim_direccion_empresa, snim_cargo_desempenia = @snim_cargo_desempenia, snim_telefono_empresa = @snim_telefono_empresa, snim_email_empresa = @snim_email_empresa, snim_link_fotografia_reciente = @snim_link_fotografia_reciente, snim_link_titulo_universitario = @snim_link_titulo_universitario, snim_link_dui = @snim_link_dui, snim_link_certificado_titulo = @snim_link_certificado_titulo, snim_link_partida_nacimiento = @snim_link_partida_nacimiento, snim_link_certificado_notas = @snim_link_certificado_notas, snim_link_fotografia_cedula = @snim_link_fotografia_cedula, snim_link_certificado_notas_mined = @snim_link_certificado_notas_mined, snim_link_cv = @snim_link_cv, snim_traking_num = @snim_traking_num
		where snim_codigo = @codsnim
		select @codsnim

		--select top 5 * from adm_aud_auditoria order by aud_codigo desc
	end

	if @opcion = 8 -- Solicitudes pendientes
	begin
		-- sp_sni_solicitud_nuevo_ingreso_maestrias @opcion = 8, @fecha_desde = '18/06/2020', @fecha_hasta = '23/06/2020', @txt_buscar = ''
		select * from (
			select snim_codigo, snim_primer_apellido
			--sni_codigo, sni_Carrera_preferencia, sni_Primer_apellido, sni_Segundo_apellido, sni_Nombres, sni_Sexo, sni_Telefono, sni_Celular, sni_Email,
			--sni_estado_solicitud, case sni_estado_solicitud when 'P' then 'Pendiente' when 'R' then 'Revisado' else 'Finalizada' end estado, sni_descripcion_caso, --usr_usuario 'usuario',
			--sni_fecha_hora_creacion, sni_equivalencia,
			--(case when isnull(sni_per_codigo_asignado, 0) = 0 then '' else (select per_carnet from ra_per_personas where per_codigo = sni_per_codigo_asignado) end ) per_carnet,
			--(case when isnull(sni_per_codigo_asignado, 0) = 0 then '' else (select per_fecha from ra_per_personas where per_codigo = sni_per_codigo_asignado) end ) per_fecha
			from ni_snim_solicitud_nuevo_ingreso_maestrias
			--left join adm_usr_usuarios on usr_codigo = sni_codusr_reviso_tramite
			where convert(date, snim_fecha_creacion, 103) between convert(date, @fecha_desde, 103) and convert(date, @fecha_hasta, 103)
			and isnull(snim_codusr_reviso, 0) = 0
			--and sni_codigo not in (select asigsni_codsni_asginado from ni_asigsni_asignacion_solcitud_nuevo_ingreso)
		) t2
		where (
			ltrim(rtrim(snim_primer_apellido)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		order by snim_codigo
	end
	
	if @opcion = 10 -- Solicitudes generales
	begin
		-- sp_sni_solicitud_nuevo_ingreso_maestrias @opcion = 10, @fecha_desde = '18/06/2020', @fecha_hasta = '23/06/2020'
		select * from (
			select snim_codigo
			--sni_codigo codsni, sni_equivalencia 'tipo', sni_Carrera_preferencia 'carrera-preferencia', sni_Primer_apellido 'primer-apellido', 
			--sni_Segundo_apellido 'segundo-apellido', 
			--sni_Nombres 'nombre', sni_Sexo 'sexo', sni_Telefono 'telefono', sni_Celular 'celular', sni_Email 'email',
			--sni_estado_solicitud 'estado-solicitud', 
			--case sni_estado_solicitud when 'P' then 'Pendiente' when 'R' then 'Revisado' else 'Finalizada' end estado, 
			--sni_descripcion_caso 'descripcion-caso', 
			--usr_usuario 'usuario-asignado',
			--sni_fecha_hora_creacion 'fecha-hora-lleno-solicitud', 
			--(case when isnull(sni_per_codigo_asignado, 0) = 0 then '-' else (select per_carnet from ra_per_personas where per_codigo = sni_per_codigo_asignado) end ) 'carnet-asignado',
			--(case when isnull(sni_per_codigo_asignado, 0) = 0 then null else (select per_fecha from ra_per_personas where per_codigo = sni_per_codigo_asignado) end ) 'fecha-hora-carnet-asignacion'
			from ni_snim_solicitud_nuevo_ingreso_maestrias
			left join adm_usr_usuarios on usr_codigo = snim_codusr_reviso
			where convert(date, snim_fecha_creacion, 103) between convert(date, @fecha_desde, 103) and convert(date, @fecha_hasta, 103)
		) t2
		order by snim_codigo
	end
end