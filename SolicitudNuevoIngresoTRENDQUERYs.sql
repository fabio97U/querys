--drop table ni_sni_solicitud_nuevo_ingreso
create table ni_sni_solicitud_nuevo_ingreso (
	sni_codigo int primary key identity (1, 1),
	sni_estado_solicitud varchar(1) default 'P',--P: Pendiente,
	sni_descripcion_caso varchar(max),
	sni_codusr_reviso_tramite int,
	sni_id_user int, 
	sni_per_codigo_asignado int,
	sni_equivalencia varchar(20), 
	sni_Universidad_de_procedencia varchar(1024), 
	sni_Carrera_preferencia varchar(100), 
	sni_Facultad varchar(60), 
	sni_Primer_apellido varchar(255), 
	sni_Segundo_apellido varchar(255), 
	sni_Nombres varchar(255), 
	sni_Sexo varchar(15), 
	sni_Estado_civil varchar(25), 
	sni_Direccion_actual varchar(500), 
	sni_Pais varchar(1024), 
	sni_Deprt varchar(1024), 
	sni_municipio varchar(255), 
	sni_Telefono varchar(50), 
	sni_Celular varchar(50), 
	sni_Email varchar(255), 
	sni_Fecha date, 
	sni_Lugar varchar(125), 
	sni_Nacimiento varchar(125), 
	sni_Dui varchar(30), 
	sni_Nit varchar(30), 
	sni_Pasaporte varchar(50), 

	sni_nom_madre varchar(100),
	sni_nom_padre varchar(100),
	sni_direc_madre varchar(100),
	sni_direc_padre varchar(100),
	sni_tel_madre varchar(50),
	sni_tel_padre varchar(50),
	sni_oc_madre varchar(100),
	sni_oc_padre varchar(100),
	sni_lt_madre varchar(100),
	sni_lt_padre varchar(100),

	sni_Nombre_e varchar(255), 
	sni_Parentezco_e varchar(50), 
	sni_Direccion_e varchar(1024), 
	sni_Telefono_e varchar(30), 
	sni_Comentario_d varchar(1024), 
	sni_Parentezco_r varchar(50), 
	sni_Nombre_r varchar(255), 
	sni_Telefono_r varchar(30), 
	sni_Institucion_b varchar(255), 
	sni_tipo_Institucion_b varchar(100), 
	sni_Nota_paes varchar(25), 
	sni_Gracuacion_n varchar(6), 
	sni_Bachillerato_opt varchar(255), 
	sni_grado_academico_previo varchar(100), 
	sni_Grado_obtenido varchar(100), 
	sni_Universidad_w varchar(100), 
	sni_Nombre_t varchar(255), 
	sni_Direccion_t varchar(1024), 
	sni_Telefono_t varchar(30), 
	sni_Fax_t varchar(50), 
	sni_Email_t varchar(125), 
	sni_Jefe_t varchar(125), 
	sni_cargo_t varchar(125),
	sni_sector varchar(100),

	sni_Padres_f varchar(30), 
	sni_Tias_f varchar(30), 
	sni_Padres_e_f varchar(30), 
	sni_Familia_e_f varchar(30), 
	sni_Usted_f varchar(30), 
	sni_Otros_f varchar(100), 
	sni_Veiculo_tran_p varchar(30), 
	sni_Publico_tran varchar(30), 
	sni_Veiculo_tran_pp varchar(30), 
	sni_d1 varchar(25), 
	sni_d2 varchar(25), 
	sni_d3 varchar(25), 
	sni_d4 varchar(25), 
	sni_d5 varchar(25), 
	sni_d6 varchar(25), 
	sni_d7 varchar(25), 
	sni_d8 varchar(25), 
	sni_a1 varchar(25), 
	sni_a2 varchar(25), 
	sni_a3 varchar(25), 
	sni_a4 varchar(25), 
	sni_extra_img1 varchar(1024), 
	sni_extra_img1_valido bit default 0, 
	sni_extra_img2 varchar(1024), 
	sni_extra_img2_valido bit default 0, 
	sni_extra_img3 varchar(1024), 
	sni_extra_img3_valido bit default 0, 
	
	sni_extra_img4 varchar(1024), 
	sni_extra_img4_valido bit default 0, 
	sni_no_doc varchar(100),

	sni_Pref_hor varchar(75),
	sni_posee_veh varchar(75),
	sni_posee_cel varchar(75),
	sni_razon_ma varchar(75),
	sni_razon_ma_otros varchar(75),
	sni_dhoy varchar(75),
	sni_dpre varchar(75),
	sni_valla varchar(75),
	sni_ccom varchar(75),
	sni_cine varchar(75),
	sni_fnue varchar(75),
	sni_funi varchar(75),
	sni_sweb varchar(75),
	sni_twit varchar(75),
	sni_inst varchar(75),
	sni_pdh varchar(75),
	sni_ppgi varchar(75),
	sni_forma_consul varchar(75),
	sni_resiberemesa varchar(75),
	sni_fb_inf varchar(75),
	sni_ins_inf varchar(75),
	sni_tw_inf varchar(75),
	sni_sna_inf varchar(75),
	sni_tik_inf varchar(75),
	sni_pin_inf varchar(75),
	sni_lin_inf varchar(75),
	sni_otr_inf varchar(75),

	sni_yo varchar(255), 
	sni_de varchar(10), 
	sni_domicilio varchar(255), 
	sni_i_num varchar(50), 
	sni_carnet_min varchar(50), 
	sni_Fecha_creacion date, 
	sni_traking_num varchar(100), 
	sni_Ciclo int,
	sni_fecha_hora_creacion datetime default getdate()
)
GO
--select * from ni_sni_solicitud_nuevo_ingreso

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_sni_solicitud_nuevo_ingreso]    Script Date: 25/6/2020 16:41:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-06-06 01:16:16.480>
	-- Description: <Realiza la inserción de los datos de la solicitud de nuevo ingreso, y muestra los datos de solicitudes>
	-- =============================================
	-- sp_sni_solicitud_nuevo_ingreso 1
ALTER procedure [dbo].[sp_sni_solicitud_nuevo_ingreso]
	@opcion int = 0,
	@sni_id_user int = 0,
	@sni_equivalencia varchar(20) = '',
	@sni_Universidad_de_procedencia varchar(1024) = '',
	@sni_Carrera_preferencia varchar(100) = '',
	@sni_Facultad varchar(60) = '',
	@sni_Primer_apellido varchar(255) = '',
	@sni_Segundo_apellido varchar(255) = '',
	@sni_Nombres varchar(255) = '',
	@sni_Sexo varchar(15) = '',
	@sni_Estado_civil varchar(25) = '',
	@sni_Direccion_actual varchar(500) = '',
	@sni_Pais varchar(1024) = '',
	@sni_Deprt varchar(1024) = '',
	@sni_Telefono varchar(50) = '',
	@sni_Celular varchar(50) = '',
	@sni_Email varchar(255) = '',
	@sni_Fecha date = '',
	@sni_Lugar varchar(125) = '',
	@sni_Nacimiento varchar(125) = '',
	@sni_Dui varchar(30) = '',
	@sni_Nit varchar(30) = '',
	@sni_Pasaporte varchar(50) = '',
	@sni_Nombre_e varchar(255) = '',
	@sni_Parentezco_e varchar(50) = '',
	@sni_Direccion_e varchar(1024) = '',
	@sni_Telefono_e varchar(30) = '',
	@sni_Comentario_d varchar(1024) = '',
	@sni_Parentezco_r varchar(50) = '',
	@sni_Nombre_r varchar(255) = '',
	@sni_Telefono_r varchar(30) = '',
	@sni_Institucion_b varchar(255) = '',
	@sni_tipo_Institucion_b varchar(100) = '',
	@sni_Nota_paes varchar(25) = '',
	@sni_Gracuacion_n varchar(6) = '',
	@sni_Bachillerato_opt varchar(255) = '',
	@sni_grado_academico_previo varchar(100) = '',
	@sni_Grado_obtenido varchar(100) = '',
	@sni_Universidad_w varchar(100) = '',
	@sni_Nombre_t varchar(255) = '',
	@sni_Direccion_t varchar(1024) = '',
	@sni_Telefono_t varchar(30) = '',
	@sni_Fax_t varchar(50) = '',
	@sni_Email_t varchar(125) = '',
	@sni_Jefe_t varchar(125) = '',
	@sni_cargo_t varchar(125) = '',
	@sni_Padres_f varchar(30) = '',
	@sni_Tias_f varchar(30) = '',
	@sni_Padres_e_f varchar(30) = '',
	@sni_Familia_e_f varchar(30) = '',
	@sni_Usted_f varchar(30) = '',
	@sni_Otros_f varchar(100) = '',
	@sni_Veiculo_tran_p varchar(30) = '',
	@sni_Publico_tran varchar(30) = '',
	@sni_Veiculo_tran_pp varchar(30) = '',
	@sni_d1 varchar(25) = '',
	@sni_d2 varchar(25) = '',
	@sni_d3 varchar(25) = '',
	@sni_d4 varchar(25) = '',
	@sni_d5 varchar(25) = '',
	@sni_d6 varchar(25) = '',
	@sni_d7 varchar(25) = '',
	@sni_d8 varchar(25) = '',
	@sni_a1 varchar(25) = '',
	@sni_a2 varchar(25) = '',
	@sni_a3 varchar(25) = '',
	@sni_a4 varchar(25) = '',
	@sni_extra_img1 varchar(1024) = '',
	@sni_extra_img2 varchar(1024) = '',
	@sni_extra_img3 varchar(1024) = '',
	@sni_yo varchar(255) = '',
	@sni_de varchar(10) = '',
	@sni_domicilio varchar(255) = '',
	@sni_i_num varchar(50) = '',
	@sni_carnet_min varchar(50) = '',
	@sni_Fecha_creacion date = '',
	@sni_traking_num varchar(100) = '',
	@sni_municipio varchar(255) = '',
	@sni_Ciclo int = 0,

	@txt_buscar varchar(500) = '',
	@fecha_desde nvarchar(12) = '', 
	@fecha_hasta nvarchar(12) = '',
	@codsni int = 0,

	--Los siguientes campos corresponde a los ultimos cambios solicitados el 19/06/2020
	@sni_nom_madre varchar(100) = '',
	@sni_nom_padre varchar(100) = '',
	@sni_direc_madre varchar(100) = '',
	@sni_direc_padre varchar(100) = '',
	@sni_tel_madre varchar(50) = '',
	@sni_tel_padre varchar(50) = '',
	@sni_oc_madre varchar(100) = '',
	@sni_oc_padre varchar(100) = '',
	@sni_lt_madre varchar(100) = '',
	@sni_lt_padre varchar(100) = '',
	@sni_sector varchar(100) = '',
	@sni_extra_img4 varchar(1024) = '',
	@sni_no_doc varchar(100) = '',
	@sni_Pref_hor varchar(75) = '',
	@sni_posee_veh varchar(75) = '',
	@sni_posee_cel varchar(75) = '',
	@sni_razon_ma varchar(75) = '',
	@sni_razon_ma_otros varchar(75) = '',
	@sni_dhoy varchar(75) = '',
	@sni_dpre varchar(75) = '',
	@sni_valla varchar(75) = '',
	@sni_ccom varchar(75) = '',
	@sni_cine varchar(75) = '',
	@sni_fnue varchar(75) = '',
	@sni_funi varchar(75) = '',
	@sni_sweb varchar(75) = '',
	@sni_twit varchar(75) = '',
	@sni_inst varchar(75) = '',
	@sni_pdh varchar(75) = '',
	@sni_ppgi varchar(75) = '',
	@sni_forma_consul varchar(75) = '',
	@sni_resiberemesa varchar(75) = '',
	@sni_fb_inf varchar(75) = '',
	@sni_ins_inf varchar(75) = '',
	@sni_tw_inf varchar(75) = '',
	@sni_sna_inf varchar(75) = '',
	@sni_tik_inf varchar(75) = '',
	@sni_pin_inf varchar(75) = '',
	@sni_lin_inf varchar(75) = '',
	@sni_otr_inf varchar(75) = '',
	
	@sni_codigo int = 0,
	@sni_descripcion_caso varchar(max) = '',
	@sni_estado_solicitud varchar(1) = '',
	@sni_codusr_reviso_tramite int = 0,

	@snival_columna_tabla_sni varchar(75) = '',
	@sni_fecha_nacimiento nvarchar(12) = '',
	@sni_extra_img1_valido int = 0,
	@sni_extra_img2_valido int = 0,
	@sni_extra_img3_valido int = 0,
	@sni_extra_img4_valido int = 0,
	@snival_columna_tabla_valor varchar(255) = ''
as
begin
	
	if @opcion = 1 --Inserta los datos a la tabla "sni_solicitud_nuevo_ingreso", desde la API, https://portalpag.utec.edu.sv/webapi/api/SolicitudNI
	begin
		insert into ni_sni_solicitud_nuevo_ingreso (sni_id_user, sni_equivalencia, sni_Universidad_de_procedencia, sni_Carrera_preferencia, sni_Facultad, sni_Primer_apellido, sni_Segundo_apellido, sni_Nombres, sni_Sexo, sni_Estado_civil, sni_Direccion_actual, sni_Pais, sni_Deprt, sni_Telefono, sni_Celular, sni_Email, sni_Fecha, sni_Lugar, sni_Nacimiento, sni_Dui, sni_Nit, sni_Pasaporte, sni_Nombre_e, sni_Parentezco_e, sni_Direccion_e, sni_Telefono_e, sni_Comentario_d, sni_Parentezco_r, sni_Nombre_r, sni_Telefono_r, sni_Institucion_b, sni_Nota_paes, sni_Gracuacion_n, sni_Bachillerato_opt, sni_grado_academico_previo, sni_Grado_obtenido, sni_Universidad_w, sni_Nombre_t, sni_Direccion_t, sni_Telefono_t, sni_Fax_t, sni_Email_t, sni_Jefe_t, sni_Padres_f, sni_Tias_f, sni_Padres_e_f, sni_Familia_e_f, sni_Usted_f, sni_Otros_f, sni_Veiculo_tran_p, sni_Publico_tran, sni_Veiculo_tran_pp, sni_d1, sni_d2, sni_d3, sni_d4, sni_d5, sni_d6, sni_d7, sni_d8, sni_a1, sni_a2, sni_a3, sni_a4, sni_extra_img1, sni_extra_img2, sni_extra_img3, sni_yo, sni_de, sni_domicilio, sni_i_num, sni_carnet_min, sni_Fecha_creacion, sni_traking_num, sni_municipio, sni_Ciclo
		
		,sni_nom_madre, sni_nom_padre, sni_direc_madre, sni_direc_padre, sni_tel_madre, sni_tel_padre, sni_oc_madre, sni_oc_padre, sni_lt_madre, sni_lt_padre, sni_sector, sni_extra_img4, sni_no_doc, sni_Pref_hor, sni_posee_veh, sni_posee_cel, sni_razon_ma, sni_dhoy, sni_dpre, sni_valla, sni_ccom, sni_cine, sni_fnue, sni_funi, sni_sweb, sni_twit, sni_inst, sni_pdh, sni_ppgi, sni_forma_consul, sni_resiberemesa, sni_fb_inf, sni_ins_inf, sni_tw_inf, sni_sna_inf, sni_tik_inf, sni_pin_inf, sni_lin_inf, sni_otr_inf
		)
		values (@sni_id_user, @sni_equivalencia, @sni_Universidad_de_procedencia, 
		case @sni_Facultad when 'Virtuales'  then concat(@sni_Carrera_preferencia, ' ', 'Virtual') else @sni_Carrera_preferencia end, 
		@sni_Facultad, @sni_Primer_apellido, @sni_Segundo_apellido, @sni_Nombres, @sni_Sexo, @sni_Estado_civil, @sni_Direccion_actual, @sni_Pais, @sni_Deprt, @sni_Telefono, @sni_Celular, @sni_Email, @sni_Fecha, @sni_Lugar, @sni_Nacimiento, @sni_Dui, @sni_Nit, @sni_Pasaporte, @sni_Nombre_e, @sni_Parentezco_e, @sni_Direccion_e, @sni_Telefono_e, @sni_Comentario_d, @sni_Parentezco_r, @sni_Nombre_r, @sni_Telefono_r, @sni_Institucion_b, @sni_Nota_paes, @sni_Gracuacion_n, @sni_Bachillerato_opt, @sni_grado_academico_previo, @sni_Grado_obtenido, @sni_Universidad_w, @sni_Nombre_t, @sni_Direccion_t, @sni_Telefono_t, @sni_Fax_t, @sni_Email_t, @sni_Jefe_t, @sni_Padres_f, @sni_Tias_f, @sni_Padres_e_f, @sni_Familia_e_f, @sni_Usted_f, @sni_Otros_f, @sni_Veiculo_tran_p, @sni_Publico_tran, @sni_Veiculo_tran_pp, @sni_d1, @sni_d2, @sni_d3, @sni_d4, @sni_d5, @sni_d6, @sni_d7, @sni_d8, @sni_a1, @sni_a2, @sni_a3, @sni_a4, @sni_extra_img1, @sni_extra_img2, @sni_extra_img3, @sni_yo, @sni_de, @sni_domicilio, @sni_i_num, @sni_carnet_min, @sni_Fecha_creacion, @sni_traking_num, @sni_municipio, @sni_Ciclo
		
		,@sni_nom_madre, @sni_nom_padre, @sni_direc_madre, @sni_direc_padre, @sni_tel_madre, @sni_tel_padre, @sni_oc_madre, @sni_oc_padre, @sni_lt_madre, @sni_lt_padre, @sni_sector, @sni_extra_img4, @sni_no_doc, @sni_Pref_hor, @sni_posee_veh, @sni_posee_cel, @sni_razon_ma, @sni_dhoy, @sni_dpre, @sni_valla, @sni_ccom, @sni_cine, @sni_fnue, @sni_funi, @sni_sweb, @sni_twit, @sni_inst, @sni_pdh, @sni_ppgi, @sni_forma_consul, @sni_resiberemesa, @sni_fb_inf, @sni_ins_inf, @sni_tw_inf, @sni_sna_inf, @sni_tik_inf, @sni_pin_inf, @sni_lin_inf, @sni_otr_inf
		)
		select scope_identity()
	end

	if @opcion = 2 -- Devuelve la data de las solicitudes de nuevo ingreso realizadas desde @fecha_desde hasta @fecha_hasta
	begin
		-- sp_sni_solicitud_nuevo_ingreso @opcion = 2, @fecha_desde = '18/06/2020', @fecha_hasta = '23/06/2020', @txt_buscar = '', @sni_codusr_reviso_tramite = 407
		select * from (
			select sni_codigo, sni_Carrera_preferencia, sni_Primer_apellido, sni_Segundo_apellido, sni_Nombres, sni_Sexo, sni_Telefono, sni_Celular, sni_Email,
			sni_estado_solicitud, case sni_estado_solicitud when 'P' then 'Pendiente' when 'R' then 'Revisado' else 'Finalizada' end estado, sni_descripcion_caso, usr_usuario 'usuario',
			sni_fecha_hora_creacion, sni_equivalencia,
			(case when isnull(sni_per_codigo_asignado, 0) = 0 then '' else (select per_carnet from ra_per_personas where per_codigo = sni_per_codigo_asignado) end ) per_carnet,
			(case when isnull(sni_per_codigo_asignado, 0) = 0 then null else (select per_fecha from ra_per_personas where per_codigo = sni_per_codigo_asignado) end ) per_fecha
			from ni_sni_solicitud_nuevo_ingreso
			left join adm_usr_usuarios on usr_codigo = sni_codusr_reviso_tramite
			--inner join ni_asigsni_asignacion_solcitud_nuevo_ingreso on asigsni_codsni_asginado = sni_codigo
			where convert(date, sni_fecha_hora_creacion, 103) between convert(date, @fecha_desde, 103) and convert(date, @fecha_hasta, 103)
			--and asigsni_codusr_asignado = @sni_codusr_reviso_tramite
		) t2
		where (
			ltrim(rtrim(sni_Primer_apellido)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(sni_Nombres)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(per_carnet)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			-----
			or
			(ltrim(rtrim(sni_Segundo_apellido)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(sni_Celular)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(sni_Telefono)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )

			or
			(ltrim(rtrim(sni_Email)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(sni_equivalencia)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(sni_Carrera_preferencia)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(estado)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(sni_Sexo)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )

			or
			(ltrim(rtrim(usuario)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		order by sni_codigo
	end

	if @opcion = 3
	begin
		-- sp_sni_solicitud_nuevo_ingreso @opcion = 3, @codsni = 1
		select * from ni_sni_solicitud_nuevo_ingreso where sni_codigo = @codsni
	end
	
	if @opcion = 4
	begin
		-- sp_sni_solicitud_nuevo_ingreso @opcion = 4, @codsni = 1
		update ni_sni_solicitud_nuevo_ingreso set sni_estado_solicitud = @sni_estado_solicitud, sni_descripcion_caso = @sni_descripcion_caso,
		sni_codusr_reviso_tramite = @sni_codusr_reviso_tramite
		where sni_codigo = @sni_codigo

		declare @usuario varchar(25)
		select @usuario = usr_usuario from adm_usr_usuarios where usr_codigo = @sni_codusr_reviso_tramite
		declare @fecha_aud datetime, @registro varchar(200)
		set @fecha_aud = getdate()
		select @registro = concat('codsni:',@sni_codigo,',estado:', @sni_estado_solicitud, ',descripcion:', @sni_descripcion_caso)
		exec auditoria_del_sistema 'ni_sni_solicitud_nuevo_ingreso','U', @usuario, @fecha_aud, @registro
	end

	if @opcion = 5 --Devuelve la data para los selects
	begin
		-- sp_sni_solicitud_nuevo_ingreso @opcion = 5, @snival_columna_tabla_sni = ''
		select snival_columna_tabla_valor valor,  snival_columna_tabla_valor texto
		from ni_snival_solicitud_nuevo_ingreo_valores where snival_columna_tabla_sni = @snival_columna_tabla_sni
		order by snival_columna_tabla_valor
	end

	if @opcion = 6
	begin
		update ni_sni_solicitud_nuevo_ingreso set 
			sni_equivalencia = @sni_equivalencia, sni_Universidad_de_procedencia = @sni_Universidad_de_procedencia, 
			sni_Carrera_preferencia = @sni_Carrera_preferencia, sni_Primer_apellido = @sni_Primer_apellido, 
			sni_Segundo_apellido = @sni_Segundo_apellido, sni_Nombres = @sni_Nombres, sni_Sexo = @sni_Sexo, 
			sni_Estado_civil = @sni_Estado_civil, sni_Direccion_actual = @sni_Direccion_actual, sni_Pais = @sni_Pais, 
			sni_Deprt = @sni_Deprt, sni_municipio = @sni_municipio, sni_Telefono = @sni_Telefono, sni_Celular = @sni_Celular, 
			sni_Email = @sni_Email, sni_Fecha = @sni_fecha_nacimiento, sni_Lugar = @sni_Lugar, sni_Nacimiento = @sni_Nacimiento, sni_Dui = @sni_Dui, 
			sni_Nit = @sni_Nit, sni_Pasaporte = @sni_Pasaporte, sni_Nombre_e = @sni_Nombre_e, sni_Parentezco_e = @sni_Parentezco_e, 
			sni_Direccion_e = @sni_Direccion_e, sni_Telefono_e = @sni_Telefono_e, sni_Comentario_d = @sni_Comentario_d, 
			sni_Parentezco_r = @sni_Parentezco_r, sni_Nombre_r = @sni_Nombre_r, sni_Telefono_r = @sni_Telefono_r, 
			sni_Institucion_b = @sni_Institucion_b, sni_tipo_Institucion_b = @sni_tipo_Institucion_b,
			sni_Nota_paes = @sni_Nota_paes, sni_Gracuacion_n = @sni_Gracuacion_n, 
			sni_Bachillerato_opt = @sni_Bachillerato_opt, sni_grado_academico_previo = @sni_grado_academico_previo, 
			sni_Grado_obtenido = @sni_Grado_obtenido, sni_Universidad_w = @sni_Universidad_w, sni_Nombre_t = @sni_Nombre_t, 
			sni_Direccion_t = @sni_Direccion_t, sni_Telefono_t = @sni_Telefono_t, sni_Fax_t = @sni_Fax_t, sni_Email_t = @sni_Email_t, 
			sni_Jefe_t = @sni_Jefe_t, sni_cargo_t = @sni_cargo_t, sni_Padres_f = @sni_Padres_f, sni_Tias_f = @sni_Tias_f, sni_Padres_e_f = @sni_Padres_e_f, 
			sni_Familia_e_f = @sni_Familia_e_f, sni_Usted_f = @sni_Usted_f, sni_Otros_f = @sni_Otros_f, 
			sni_Veiculo_tran_p = @sni_Veiculo_tran_p, sni_Publico_tran = @sni_Publico_tran, sni_Veiculo_tran_pp = @sni_Veiculo_tran_pp, 
			sni_d1 = @sni_d1, sni_d2 = @sni_d2, sni_d3 = @sni_d3, sni_d4 = @sni_d4, sni_d5 = @sni_d5, sni_d6 = @sni_d6, 
			sni_d7 = @sni_d7, sni_d8 = @sni_d8, sni_a1 = @sni_a1, sni_a2 = @sni_a2, sni_a3 = @sni_a3, sni_a4 = @sni_a4, 
			sni_nom_madre = @sni_nom_madre, sni_nom_padre = @sni_nom_padre, sni_direc_madre = @sni_direc_madre, 
			sni_direc_padre = @sni_direc_padre, sni_tel_madre = @sni_tel_madre, sni_tel_padre = @sni_tel_padre, 
			sni_oc_madre = @sni_oc_madre, sni_oc_padre = @sni_oc_padre, sni_lt_madre = @sni_lt_madre, sni_lt_padre = @sni_lt_padre, 
			sni_sector = @sni_sector, 
			sni_Pref_hor = @sni_Pref_hor, sni_posee_veh = @sni_posee_veh, sni_posee_cel = @sni_posee_cel, sni_razon_ma = @sni_razon_ma, 
			sni_razon_ma_otros = @sni_razon_ma_otros,
			sni_dhoy = @sni_dhoy, sni_dpre = @sni_dpre, sni_valla = @sni_valla, sni_ccom = @sni_ccom, sni_cine = @sni_cine, 
			sni_fnue = @sni_fnue, sni_funi = @sni_funi, sni_sweb = @sni_sweb, sni_twit = @sni_twit, sni_inst = @sni_inst, 
			sni_pdh = @sni_pdh, sni_ppgi = @sni_ppgi, sni_forma_consul = @sni_forma_consul, sni_resiberemesa = @sni_resiberemesa, 
			sni_fb_inf = @sni_fb_inf, sni_ins_inf = @sni_ins_inf, sni_tw_inf = @sni_tw_inf, sni_sna_inf = @sni_sna_inf, 
			sni_tik_inf = @sni_tik_inf, sni_pin_inf = @sni_pin_inf, sni_lin_inf = @sni_lin_inf, sni_otr_inf = @sni_otr_inf,
			sni_extra_img1_valido = @sni_extra_img1_valido, sni_extra_img2_valido = @sni_extra_img2_valido, sni_extra_img3_valido = @sni_extra_img3_valido, sni_extra_img4_valido = @sni_extra_img4_valido
		where sni_codigo = @sni_codigo
		select @sni_codigo

		--select top 5 * from adm_aud_auditoria order by aud_codigo desc
	end

	if @opcion = 7
	begin
		-- sp_sni_solicitud_nuevo_ingreso @opcion = 7, @snival_columna_tabla_sni = 'sni_Carrera_preferencia', @snival_columna_tabla_valor = 'Ingeniería en Sistemas y Computación'
		select snival_columna_tabla_apunta_valor from ni_snival_solicitud_nuevo_ingreo_valores 
		where snival_columna_tabla_sni = @snival_columna_tabla_sni and snival_columna_tabla_valor = @snival_columna_tabla_valor
	end

	if @opcion = 8 -- Solicitudes pendientes
	begin
		-- sp_sni_solicitud_nuevo_ingreso @opcion = 8, @fecha_desde = '18/06/2020', @fecha_hasta = '23/06/2020', @txt_buscar = ''
		select * from (
			select sni_codigo, sni_Carrera_preferencia, sni_Primer_apellido, sni_Segundo_apellido, sni_Nombres, sni_Sexo, sni_Telefono, sni_Celular, sni_Email,
			sni_estado_solicitud, case sni_estado_solicitud when 'P' then 'Pendiente' when 'R' then 'Revisado' else 'Finalizada' end estado, sni_descripcion_caso, --usr_usuario 'usuario',
			sni_fecha_hora_creacion, sni_equivalencia,
			(case when isnull(sni_per_codigo_asignado, 0) = 0 then '' else (select per_carnet from ra_per_personas where per_codigo = sni_per_codigo_asignado) end ) per_carnet,
			(case when isnull(sni_per_codigo_asignado, 0) = 0 then '' else (select per_fecha from ra_per_personas where per_codigo = sni_per_codigo_asignado) end ) per_fecha
			from ni_sni_solicitud_nuevo_ingreso
			--left join adm_usr_usuarios on usr_codigo = sni_codusr_reviso_tramite
			where convert(date, sni_fecha_hora_creacion, 103) between convert(date, @fecha_desde, 103) and convert(date, @fecha_hasta, 103)
			and isnull(sni_codusr_reviso_tramite, 0) = 0
			--and sni_codigo not in (select asigsni_codsni_asginado from ni_asigsni_asignacion_solcitud_nuevo_ingreso)
		) t2
		where (
			ltrim(rtrim(sni_Primer_apellido)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(sni_Nombres)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(per_carnet)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		order by sni_codigo
	end

	if @opcion = 9 -- Solicitudes asignadas al usuario
	begin
		-- sp_sni_solicitud_nuevo_ingreso @opcion = 9, @fecha_desde = '18/06/2020', @fecha_hasta = '23/06/2020', @txt_buscar = '', @sni_codusr_reviso_tramite = 153
		select * from (
			select sni_codigo, sni_Carrera_preferencia, sni_Primer_apellido, sni_Segundo_apellido, sni_Nombres, sni_Sexo, sni_Telefono, sni_Celular, sni_Email,
			sni_estado_solicitud, case sni_estado_solicitud when 'P' then 'Pendiente' when 'R' then 'Revisado' else 'Finalizada' end estado, sni_descripcion_caso, usr_usuario 'usuario',
			sni_fecha_hora_creacion, sni_equivalencia,
			(case when isnull(sni_per_codigo_asignado, 0) = 0 then '-' else (select per_carnet from ra_per_personas where per_codigo = sni_per_codigo_asignado) end ) per_carnet,
			(case when isnull(sni_per_codigo_asignado, 0) = 0 then null else (select per_fecha from ra_per_personas where per_codigo = sni_per_codigo_asignado) end ) per_fecha
			--,asigsni_fecha_hora_creacion, (select top 1 usr_usuario from adm_usr_usuarios where usr_codigo = asigsni_codusr_asigno) asigsni_codusr_asigno
			from ni_sni_solicitud_nuevo_ingreso
			---inner join ni_asigsni_asignacion_solcitud_nuevo_ingreso on asigsni_codsni_asginado = sni_codigo
			left join adm_usr_usuarios on usr_codigo = sni_codusr_reviso_tramite
			where convert(date, sni_fecha_hora_creacion, 103) between convert(date, @fecha_desde, 103) and convert(date, @fecha_hasta, 103)
			and isnull(sni_codusr_reviso_tramite, 0) = 0 --and 
			--and asigsni_codusr_asignado = @sni_codusr_reviso_tramite
		) t2
		where (
			ltrim(rtrim(sni_Primer_apellido)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(sni_Nombres)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(per_carnet)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		order by sni_codigo
	end

	if @opcion = 10 -- Solicitudes generales
	begin
		-- sp_sni_solicitud_nuevo_ingreso @opcion = 10, @fecha_desde = '18/06/2020', @fecha_hasta = '23/06/2020'
		select * from (
			select sni_codigo codsni, sni_equivalencia 'tipo', sni_Carrera_preferencia 'carrera-preferencia', sni_Primer_apellido 'primer-apellido', 
			sni_Segundo_apellido 'segundo-apellido', 
			sni_Nombres 'nombre', sni_Sexo 'sexo', sni_Telefono 'telefono', sni_Celular 'celular', sni_Email 'email',
			sni_estado_solicitud 'estado-solicitud', 
			case sni_estado_solicitud when 'P' then 'Pendiente' when 'R' then 'Revisado' else 'Finalizada' end estado, 
			sni_descripcion_caso 'descripcion-caso', 
			usr_usuario 'usuario-asignado',
			sni_fecha_hora_creacion 'fecha-hora-lleno-solicitud', 
			(case when isnull(sni_per_codigo_asignado, 0) = 0 then '-' else (select per_carnet from ra_per_personas where per_codigo = sni_per_codigo_asignado) end ) 'carnet-asignado',
			(case when isnull(sni_per_codigo_asignado, 0) = 0 then null else (select per_fecha from ra_per_personas where per_codigo = sni_per_codigo_asignado) end ) 'fecha-hora-carnet-asignacion'
			--,asigsni_fecha_hora_creacion 'fecha-hora-asigno-caso', (select top 1 usr_usuario from adm_usr_usuarios where usr_codigo = asigsni_codusr_asigno) 'usuario-asigno-el-caso'
			from ni_sni_solicitud_nuevo_ingreso
			--left join ni_asigsni_asignacion_solcitud_nuevo_ingreso on asigsni_codsni_asginado = sni_codigo
			left join adm_usr_usuarios on usr_codigo = sni_codusr_reviso_tramite
			where convert(date, sni_fecha_hora_creacion, 103) between convert(date, @fecha_desde, 103) and convert(date, @fecha_hasta, 103)
		) t2
		order by codsni
	end
end

--drop table ni_snival_solicitud_nuevo_ingreo_valores
--create table ni_snival_solicitud_nuevo_ingreo_valores(
--	snival_codigo int primary key identity (1, 1),
--	snival_columna_tabla_sni varchar(75),
--	snival_columna_tabla_valor varchar(255),
--	snival_tabla_apunta varchar(50),
--	snival_columna_tabla_apunta varchar(50),
--	snival_columna_tabla_apunta_valor varchar(10),
--	snival_guardar_texto_crudo bit default 0,
--	snival_fecha_creacion datetime default getdate()
--)
--select * from ni_snival_solicitud_nuevo_ingreo_valores

--insert into ni_snival_solicitud_nuevo_ingreo_valores 
--(snival_columna_tabla_sni, snival_columna_tabla_valor, snival_tabla_apunta, snival_columna_tabla_apunta, snival_columna_tabla_apunta_valor) values
--('sni_equivalencia', 'Nuevo ingreso', 'ra_ing_ingreso', 'ing_codigo', '1'), ('sni_equivalencia', 'Equivalencia', 'ra_ing_ingreso', 'ing_codigo', '4'),
--('sni_Carrera_preferencia', 'Ingeniería en Sistemas y Computación Virtual', 'ra_car_carreras', 'car_identificador', '29'), ('sni_Carrera_preferencia', 'Ingeniería Industrial Virtual', 'ra_car_carreras', 'car_identificador', '46'), ('sni_Carrera_preferencia', 'Licenciatura en Administración de Empresas Virtual', 'ra_car_carreras', 'car_identificador', '03'), ('sni_Carrera_preferencia', 'Licenciatura en Administración de Empresas con Énfasis en Computación Virtual', 'ra_car_carreras', 'car_identificador', '53'), ('sni_Carrera_preferencia', 'Licenciatura en Contaduría Pública Virtual', 'ra_car_carreras', 'car_identificador', '54'), ('sni_Carrera_preferencia', 'Licenciatura en Mercadeo Virtual', 'ra_car_carreras', 'car_identificador', '02'), ('sni_Carrera_preferencia', 'Licenciatura en Idioma Inglés Virtual', 'ra_car_carreras', 'car_identificador', '64'), ('sni_Carrera_preferencia', 'Técnico en Mercadeo y Ventas Virtual', 'ra_car_carreras', 'car_identificador', '58'), ('sni_Carrera_preferencia', 'Licenciatura en Diseño Gráfico Virtual', 'ra_car_carreras', 'car_identificador', '68'), ('sni_Carrera_preferencia', 'Ingeniería en Sistemas y Computación', 'ra_car_carreras', 'car_identificador', '25'), ('sni_Carrera_preferencia', 'Ingeniería Industrial', 'ra_car_carreras', 'car_identificador', '22'), ('sni_Carrera_preferencia', 'Ingeniería Industrial con Énfasis en Inglés', 'ra_car_carreras', 'car_identificador', '66'), ('sni_Carrera_preferencia', 'Licenciatura en Informática', 'ra_car_carreras', 'car_identificador', '17'), ('sni_Carrera_preferencia', 'Arquitectura', 'ra_car_carreras', 'car_identificador', '38'), ('sni_Carrera_preferencia', 'Licenciatura en Diseño Gráfico', 'ra_car_carreras', 'car_identificador', '61'), ('sni_Carrera_preferencia', 'Técnico en Diseño Gráfico', 'ra_car_carreras', 'car_identificador', '60'), ('sni_Carrera_preferencia', 'Técnico en Ingeniería de Redes Computacionales', 'ra_car_carreras', 'car_identificador', '26'), ('sni_Carrera_preferencia', 'Técnico en Ingeniería de Software', 'ra_car_carreras', 'car_identificador', '27'), ('sni_Carrera_preferencia', 'Licenciatura en Comunicaciones', 'ra_car_carreras', 'car_identificador', '34'), ('sni_Carrera_preferencia', 'Licenciatura en Comunicaciones con Énfasis en Inglés', 'ra_car_carreras', 'car_identificador', '56'), ('sni_Carrera_preferencia', 'Licenciatura en Idioma Inglés', 'ra_car_carreras', 'car_identificador', '31'), ('sni_Carrera_preferencia', 'Licenciatura en Psicología', 'ra_car_carreras', 'car_identificador', '32'), ('sni_Carrera_preferencia', 'Técnico en Relaciones Públicas', 'ra_car_carreras', 'car_identificador', '09'), ('sni_Carrera_preferencia', 'Licenciatura en Ciencias Jurídicas', 'ra_car_carreras', 'car_identificador', '51'), ('sni_Carrera_preferencia', 'Licenciatura en Administración de Empresas', 'ra_car_carreras', 'car_identificador', '11'), ('sni_Carrera_preferencia', 'Licenciatura en Administración de Empresas con Énfasis en Computación', 'ra_car_carreras', 'car_identificador', '15'), ('sni_Carrera_preferencia', 'Licenciatura en Administración de Empresas con Énfasis en Inglés', 'ra_car_carreras', 'car_identificador', '18'), ('sni_Carrera_preferencia', 'Técnico en Administración Turística', 'ra_car_carreras', 'car_identificador', '06'), ('sni_Carrera_preferencia', 'Licenciatura en Administración de Empresas Turísticas', 'ra_car_carreras', 'car_identificador', '05'), ('sni_Carrera_preferencia', 'Licenciatura en Administración de Empresas Turísticas con Énfasis en Inglés', 'ra_car_carreras', 'car_identificador', '67'), ('sni_Carrera_preferencia', 'Licenciatura en Contaduría Pública', 'ra_car_carreras', 'car_identificador', '12'), ('sni_Carrera_preferencia', 'Licenciatura en Mercadeo', 'ra_car_carreras', 'car_identificador', '13'), ('sni_Carrera_preferencia', 'Licenciatura en Mercadeo en con Énfasis en Inglés', 'ra_car_carreras', 'car_identificador', '10'), ('sni_Carrera_preferencia', 'Licenciatura en Negocios Internacionales', 'ra_car_carreras', 'car_identificador', '20'), ('sni_Carrera_preferencia', 'Técnico en Mercadeo y Ventas', 'ra_car_carreras', 'car_identificador', '08'), 
--('sni_Sexo', 'm', 'ra_per_personas', 'per_sexo', 'M'), ('sni_Sexo', 'f', 'ra_per_personas', 'per_sexo', 'F'),
--('sni_Estado_civil', 'Soltero/a', 'ra_per_personas', 'per_est_civil', 'S'), ('sni_Estado_civil', 'Acompañado/a', 'ra_per_personas', 'per_est_civil', 'A'), ('sni_Estado_civil', 'Comprometido/a', 'ra_per_personas', 'per_est_civil', 'A'), ('sni_Estado_civil', 'Casado/a', 'ra_per_personas', 'per_est_civil', 'C'), ('sni_Estado_civil', 'Divorciado/a', 'ra_per_personas', 'per_est_civil', 'D'), ('sni_Estado_civil', 'Viudo/a', 'ra_per_personas', 'per_est_civil', 'V'),
--('sni_Pais', 'Argentina', 'ra_per_personas', 'per_nacionalidad', '12'), ('sni_Pais', 'Bahamas', 'ra_per_personas', 'per_nacionalidad', '15'), ('sni_Pais', 'Barbados', 'ra_per_personas', 'per_nacionalidad', '17'), ('sni_Pais', 'Belice', 'ra_per_personas', 'per_nacionalidad', '19'), ('sni_Pais', 'Bolivia', 'ra_per_personas', 'per_nacionalidad', '22'), ('sni_Pais', 'Brasil', 'ra_per_personas', 'per_nacionalidad', '24'), ('sni_Pais', 'Canadá', 'ra_per_personas', 'per_nacionalidad', '33'), ('sni_Pais', 'Chile', 'ra_per_personas', 'per_nacionalidad', '37'), ('sni_Pais', 'Colombia', 'ra_per_personas', 'per_nacionalidad', '41'), ('sni_Pais', 'Costa Rica', 'ra_per_personas', 'per_nacionalidad', '45'), ('sni_Pais', 'Cuba', 'ra_per_personas', 'per_nacionalidad', '46'), ('sni_Pais', 'Ecuador', 'ra_per_personas', 'per_nacionalidad', '49'), ('sni_Pais', 'El Salvador', 'ra_per_personas', 'per_nacionalidad', '1'), ('sni_Pais', 'Estados Unidos', 'ra_per_personas', 'per_nacionalidad', '53'), ('sni_Pais', 'Guatemala', 'ra_per_personas', 'per_nacionalidad', '2'), ('sni_Pais', 'Honduras', 'ra_per_personas', 'per_nacionalidad', '3'), ('sni_Pais', 'Jamaica', 'ra_per_personas', 'per_nacionalidad', '99'), ('sni_Pais', 'México', 'ra_per_personas', 'per_nacionalidad', '119'), ('sni_Pais', 'Nicaragua', 'ra_per_personas', 'per_nacionalidad', '123'), ('sni_Pais', 'Panamá', 'ra_per_personas', 'per_nacionalidad', '136'), ('sni_Pais', 'Paraguay', 'ra_per_personas', 'per_nacionalidad', '139'), ('sni_Pais', 'Perú', 'ra_per_personas', 'per_nacionalidad', '141'), ('sni_Pais', 'Uruguay', 'ra_per_personas', 'per_nacionalidad', '183'), ('sni_Pais', 'Venezuela', 'ra_per_personas', 'per_nacionalidad', '184'), ('sni_Pais', 'Andorra', 'ra_per_personas', 'per_nacionalidad', '7'), ('sni_Pais', 'Austria', 'ra_per_personas', 'per_nacionalidad', '14'), ('sni_Pais', 'Bulgaria', 'ra_per_personas', 'per_nacionalidad', '26'), ('sni_Pais', 'Chipre', 'ra_per_personas', 'per_nacionalidad', '39'), ('sni_Pais', 'Ciudad del Vaticano', 'ra_per_personas', 'per_nacionalidad', '40'), ('sni_Pais', 'Dinamarca', 'ra_per_personas', 'per_nacionalidad', '48'), ('sni_Pais', 'España', 'ra_per_personas', 'per_nacionalidad', '52'), ('sni_Pais', 'Finlandia', 'ra_per_personas', 'per_nacionalidad', '57'), ('sni_Pais', 'Francia', 'ra_per_personas', 'per_nacionalidad', '58'), ('sni_Pais', 'Grecia', 'ra_per_personas', 'per_nacionalidad', '63'), ('sni_Pais', 'Irlanda', 'ra_per_personas', 'per_nacionalidad', '82'), ('sni_Pais', 'Islandia', 'ra_per_personas', 'per_nacionalidad', '83'), ('sni_Pais', 'Italia', 'ra_per_personas', 'per_nacionalidad', '98'), ('sni_Pais', 'Luxemburgo', 'ra_per_personas', 'per_nacionalidad', '109'), ('sni_Pais', 'Malta', 'ra_per_personas', 'per_nacionalidad', '113'), ('sni_Pais', 'Noruega', 'ra_per_personas', 'per_nacionalidad', '127'), ('sni_Pais', 'Polonia', 'ra_per_personas', 'per_nacionalidad', '142'), ('sni_Pais', 'Portugal', 'ra_per_personas', 'per_nacionalidad', '143'), ('sni_Pais', 'Rusia', 'ra_per_personas', 'per_nacionalidad', '155'), ('sni_Pais', 'Suecia', 'ra_per_personas', 'per_nacionalidad', '170'), ('sni_Pais', 'Suiza', 'ra_per_personas', 'per_nacionalidad', '171'), 
--	('sni_Deprt', 'Ahuachapán', 'ra_per_personas', 'per_coddep_nac', '4'), ('sni_Deprt', 'Santa Ana', 'ra_per_personas', 'per_coddep_nac', '3'), ('sni_Deprt', 'Sonsonate', 'ra_per_personas', 'per_coddep_nac', '14'), ('sni_Deprt', 'Usulután', 'ra_per_personas', 'per_coddep_nac', '15'), ('sni_Deprt', 'San Miguel', 'ra_per_personas', 'per_coddep_nac', '6'), ('sni_Deprt', 'Morazán', 'ra_per_personas', 'per_coddep_nac', '12'), ('sni_Deprt', 'La Unión', 'ra_per_personas', 'per_coddep_nac', '11'), ('sni_Deprt', 'La Libertad', 'ra_per_personas', 'per_coddep_nac', '9'), ('sni_Deprt', 'Chalatenango', 'ra_per_personas', 'per_coddep_nac', '8'), ('sni_Deprt', 'Cuscatlán', 'ra_per_personas', 'per_coddep_nac', '7'), ('sni_Deprt', 'San Salvador', 'ra_per_personas', 'per_coddep_nac', '2'), ('sni_Deprt', 'La Paz', 'ra_per_personas', 'per_coddep_nac', '10'), ('sni_Deprt', 'Cabañas', 'ra_per_personas', 'per_coddep_nac', '5'), ('sni_Deprt', 'San Vicente', 'ra_per_personas', 'per_coddep_nac', '13'), 
--	('sni_Deprt', 'Alabama', 'ra_per_personas', 'per_coddep_nac', '115'), ('sni_Deprt', 'Alaska', 'ra_per_personas', 'per_coddep_nac', '116'), ('sni_Deprt', 'Arizona', 'ra_per_personas', 'per_coddep_nac', '117'), ('sni_Deprt', 'Arkansas', 'ra_per_personas', 'per_coddep_nac', '118'), ('sni_Deprt', 'California', 'ra_per_personas', 'per_coddep_nac', '70'), ('sni_Deprt', 'Carolina del Norte', 'ra_per_personas', 'per_coddep_nac', '97'), ('sni_Deprt', 'Carolina del Sur', 'ra_per_personas', 'per_coddep_nac', '104'), ('sni_Deprt', 'Colorado', 'ra_per_personas', 'per_coddep_nac', '71'), ('sni_Deprt', 'Connecticut', 'ra_per_personas', 'per_coddep_nac', '72'), ('sni_Deprt', 'Dakota del Norte', 'ra_per_personas', 'per_coddep_nac', '98'), ('sni_Deprt', 'Dakota del Sur', 'ra_per_personas', 'per_coddep_nac', '105'), ('sni_Deprt', 'Delaware', 'ra_per_personas', 'per_coddep_nac', '73'), ('sni_Deprt', 'Florida', 'ra_per_personas', 'per_coddep_nac', '74'), ('sni_Deprt', 'Georgia', 'ra_per_personas', 'per_coddep_nac', '75'), ('sni_Deprt', 'Hawái', 'ra_per_personas', 'per_coddep_nac', '76'), ('sni_Deprt', 'Idaho', 'ra_per_personas', 'per_coddep_nac', '77'), ('sni_Deprt', 'Illinois', 'ra_per_personas', 'per_coddep_nac', '78'), ('sni_Deprt', 'Indiana', 'ra_per_personas', 'per_coddep_nac', '79'), ('sni_Deprt', 'Iowa', 'ra_per_personas', 'per_coddep_nac', '80'), ('sni_Deprt', 'Kansas', 'ra_per_personas', 'per_coddep_nac', '81'), ('sni_Deprt', 'Kentucky', 'ra_per_personas', 'per_coddep_nac', '82'), ('sni_Deprt', 'Luisiana', 'ra_per_personas', 'per_coddep_nac', '83'), ('sni_Deprt', 'Maine', 'ra_per_personas', 'per_coddep_nac', '84'), ('sni_Deprt', 'Maryland', 'ra_per_personas', 'per_coddep_nac', '85'), ('sni_Deprt', 'Massachusetts', 'ra_per_personas', 'per_coddep_nac', '86'), ('sni_Deprt', 'Míchigan', 'ra_per_personas', 'per_coddep_nac', '87'), ('sni_Deprt', 'Minnesota', 'ra_per_personas', 'per_coddep_nac', '88'), ('sni_Deprt', 'Misisipi', 'ra_per_personas', 'per_coddep_nac', '89'), ('sni_Deprt', 'Misuri', 'ra_per_personas', 'per_coddep_nac', '119'), ('sni_Deprt', 'Montana', 'ra_per_personas', 'per_coddep_nac', '90'), ('sni_Deprt', 'Nebraska', 'ra_per_personas', 'per_coddep_nac', '91'), ('sni_Deprt', 'Nevada', 'ra_per_personas', 'per_coddep_nac', '92'), ('sni_Deprt', 'Nueva Jersey', 'ra_per_personas', 'per_coddep_nac', '94'), ('sni_Deprt', 'Nueva York', 'ra_per_personas', 'per_coddep_nac', '69'), ('sni_Deprt', 'Nuevo Hampshire', 'ra_per_personas', 'per_coddep_nac', '93'), ('sni_Deprt', 'Nuevo México', 'ra_per_personas', 'per_coddep_nac', '95'), ('sni_Deprt', 'Ohio', 'ra_per_personas', 'per_coddep_nac', '99'), ('sni_Deprt', 'Oklahoma', 'ra_per_personas', 'per_coddep_nac', '100'), ('sni_Deprt', 'Oregón', 'ra_per_personas', 'per_coddep_nac', '101'), ('sni_Deprt', 'Pensilvania', 'ra_per_personas', 'per_coddep_nac', '102'), ('sni_Deprt', 'Rhode Island', 'ra_per_personas', 'per_coddep_nac', '103'), ('sni_Deprt', 'Tennessee', 'ra_per_personas', 'per_coddep_nac', '106'), ('sni_Deprt', 'Texas', 'ra_per_personas', 'per_coddep_nac', '107'), ('sni_Deprt', 'Utah', 'ra_per_personas', 'per_coddep_nac', '108'), ('sni_Deprt', 'Vermont', 'ra_per_personas', 'per_coddep_nac', '109'), ('sni_Deprt', 'Virginia', 'ra_per_personas', 'per_coddep_nac', '110'), ('sni_Deprt', 'Virginia Occidental', 'ra_per_personas', 'per_coddep_nac', '112'), ('sni_Deprt', 'Washington', 'ra_per_personas', 'per_coddep_nac', '111'), ('sni_Deprt', 'Wisconsin', 'ra_per_personas', 'per_coddep_nac', '113'), ('sni_Deprt', 'Wyoming', 'ra_per_personas', 'per_coddep_nac', '114'), 

--	('sni_municipio', 'Ahuachapán', 'ra_per_personas', 'per_codmun_nac', '45'), ('sni_municipio', 'Apaneca', 'ra_per_personas', 'per_codmun_nac', '46'), ('sni_municipio', 'Atiquizaya', 'ra_per_personas', 'per_codmun_nac', '47'), ('sni_municipio', 'Concepción de Ataco', 'ra_per_personas', 'per_codmun_nac', '50'), ('sni_municipio', 'El Refugio', 'ra_per_personas', 'per_codmun_nac', '52'), ('sni_municipio', 'Guaymango', 'ra_per_personas', 'per_codmun_nac', '53'), ('sni_municipio', 'Jujutla', 'ra_per_personas', 'per_codmun_nac', '54'), ('sni_municipio', 'San Francisco Menéndez', 'ra_per_personas', 'per_codmun_nac', '60'), ('sni_municipio', 'San Lorenzo', 'ra_per_personas', 'per_codmun_nac', '61'), ('sni_municipio', 'San Pedro Puxtla', 'ra_per_personas', 'per_codmun_nac', '62'), ('sni_municipio', 'Tacuba', 'ra_per_personas', 'per_codmun_nac', '63'), ('sni_municipio', 'Turín', 'ra_per_personas', 'per_codmun_nac', '64'), ('sni_municipio', 'Santa Ana', 'ra_per_personas', 'per_codmun_nac', '24'), ('sni_municipio', 'Candelaria de la Frontera', 'ra_per_personas', 'per_codmun_nac', '27'), ('sni_municipio', 'Coatepeque', 'ra_per_personas', 'per_codmun_nac', '28'), ('sni_municipio', 'Chalchuapa', 'ra_per_personas', 'per_codmun_nac', '29'), ('sni_municipio', 'El Congo', 'ra_per_personas', 'per_codmun_nac', '31'), ('sni_municipio', 'El Porvenir', 'ra_per_personas', 'per_codmun_nac', '33'), ('sni_municipio', 'Masahuat', 'ra_per_personas', 'per_codmun_nac', '37'), ('sni_municipio', 'Metapan', 'ra_per_personas', 'per_codmun_nac', '38'), ('sni_municipio', 'San Antonio Pajonal', 'ra_per_personas', 'per_codmun_nac', '39'), ('sni_municipio', 'San Sebastián Salitrillo', 'ra_per_personas', 'per_codmun_nac', '42'), ('sni_municipio', 'Santa Rosa Guachipilín', 'ra_per_personas', 'per_codmun_nac', '43'), ('sni_municipio', 'Santiago de la Frontera', 'ra_per_personas', 'per_codmun_nac', '43'), ('sni_municipio', 'Texistepeque', 'ra_per_personas', 'per_codmun_nac', '44'), ('sni_municipio', 'Sonsonate', 'ra_per_personas', 'per_codmun_nac', '263'), ('sni_municipio', 'Acajutla', 'ra_per_personas', 'per_codmun_nac', '264'), ('sni_municipio', 'Armenia', 'ra_per_personas', 'per_codmun_nac', '265'), ('sni_municipio', 'Caluco', 'ra_per_personas', 'per_codmun_nac', '268'), ('sni_municipio', 'Cuisnahuat', 'ra_per_personas', 'per_codmun_nac', '269'), ('sni_municipio', 'Izalco', 'ra_per_personas', 'per_codmun_nac', '271'), ('sni_municipio', 'Juayúa', 'ra_per_personas', 'per_codmun_nac', '272'), ('sni_municipio', 'Nahuizalco', 'ra_per_personas', 'per_codmun_nac', '276'), ('sni_municipio', 'Nahuilingo', 'ra_per_personas', 'per_codmun_nac', '277'), ('sni_municipio', 'Salcoatitán', 'ra_per_personas', 'per_codmun_nac', '278'), ('sni_municipio', 'San Antonio del Monte', 'ra_per_personas', 'per_codmun_nac', '279'), ('sni_municipio', 'San Julián', 'ra_per_personas', 'per_codmun_nac', '281'), ('sni_municipio', 'Santa Catarina Masahuat', 'ra_per_personas', 'per_codmun_nac', '282'), ('sni_municipio', 'Santa Isabel Ishuatán', 'ra_per_personas', 'per_codmun_nac', '977'), ('sni_municipio', 'Santo Domingo de Guzmán', 'ra_per_personas', 'per_codmun_nac', '260'), ('sni_municipio', 'Sonzacate', 'ra_per_personas', 'per_codmun_nac', '284'), ('sni_municipio', 'Usulután', 'ra_per_personas', 'per_codmun_nac', '286'), ('sni_municipio', 'Alegría', 'ra_per_personas', 'per_codmun_nac', '287'), ('sni_municipio', 'Berlín', 'ra_per_personas', 'per_codmun_nac', '288'), ('sni_municipio', 'California', 'ra_per_personas', 'per_codmun_nac', '289'), ('sni_municipio', 'Concepción Batres', 'ra_per_personas', 'per_codmun_nac', '290'), ('sni_municipio', 'El Triunfo', 'ra_per_personas', 'per_codmun_nac', '300'), ('sni_municipio', 'Ereguayquín', 'ra_per_personas', 'per_codmun_nac', '291'), ('sni_municipio', 'Estanzuelas', 'ra_per_personas', 'per_codmun_nac', '292'), ('sni_municipio', 'Jiquilisco', 'ra_per_personas', 'per_codmun_nac', '293'), ('sni_municipio', 'Jucuapa', 'ra_per_personas', 'per_codmun_nac', '294'), ('sni_municipio', 'Jucuarán', 'ra_per_personas', 'per_codmun_nac', '295'), ('sni_municipio', 'Mercedes Umaña', 'ra_per_personas', 'per_codmun_nac', '296'), ('sni_municipio', 'Nueva Granada', 'ra_per_personas', 'per_codmun_nac', '297'), ('sni_municipio', 'Ozatlan', 'ra_per_personas', 'per_codmun_nac', '298'), ('sni_municipio', 'Puerto El Triunfo', 'ra_per_personas', 'per_codmun_nac', '300'), ('sni_municipio', 'San Agustín', 'ra_per_personas', 'per_codmun_nac', '301'), ('sni_municipio', 'San Buenaventura', 'ra_per_personas', 'per_codmun_nac', '302'), ('sni_municipio', 'San Dionisio', 'ra_per_personas', 'per_codmun_nac', '286'), ('sni_municipio', 'San Francisco Javier', 'ra_per_personas', 'per_codmun_nac', '304'), ('sni_municipio', 'Santa Elena', 'ra_per_personas', 'per_codmun_nac', '307'), ('sni_municipio', 'Santa María', 'ra_per_personas', 'per_codmun_nac', '196'), ('sni_municipio', 'Santiago de María', 'ra_per_personas', 'per_codmun_nac', '309'), ('sni_municipio', 'Tecapán', 'ra_per_personas', 'per_codmun_nac', '310'), ('sni_municipio', 'San Miguel', 'ra_per_personas', 'per_codmun_nac', '74'), ('sni_municipio', 'Carolina', 'ra_per_personas', 'per_codmun_nac', '75'), ('sni_municipio', 'Ciudad Barrios', 'ra_per_personas', 'per_codmun_nac', '76'), ('sni_municipio', 'Comacarán', 'ra_per_personas', 'per_codmun_nac', '77'), ('sni_municipio', 'Chapeltique', 'ra_per_personas', 'per_codmun_nac', '78'), ('sni_municipio', 'Chinameca', 'ra_per_personas', 'per_codmun_nac', '79'), ('sni_municipio', 'Chirilagua', 'ra_per_personas', 'per_codmun_nac', '80'), ('sni_municipio', 'El Tránsito', 'ra_per_personas', 'per_codmun_nac', '82'), ('sni_municipio', 'Lolotique', 'ra_per_personas', 'per_codmun_nac', '85'), ('sni_municipio', 'Moncagua', 'ra_per_personas', 'per_codmun_nac', '86'), ('sni_municipio', 'Nueva Guadalupe', 'ra_per_personas', 'per_codmun_nac', '87'), ('sni_municipio', 'Nuevo Eden de San Juan', 'ra_per_personas', 'per_codmun_nac', '88'), ('sni_municipio', 'Quelepa', 'ra_per_personas', 'per_codmun_nac', '90'), ('sni_municipio', 'San Antonio del Mosco', 'ra_per_personas', 'per_codmun_nac', '91'), ('sni_municipio', 'San Gerardo', 'ra_per_personas', 'per_codmun_nac', '93'), ('sni_municipio', 'San Jorge', 'ra_per_personas', 'per_codmun_nac', '862'), ('sni_municipio', 'San Luis de la Reina', 'ra_per_personas', 'per_codmun_nac', '94'), ('sni_municipio', 'San Rafael Oriente', 'ra_per_personas', 'per_codmun_nac', '95'), ('sni_municipio', 'Sesori', 'ra_per_personas', 'per_codmun_nac', '96'), ('sni_municipio', 'Uiuazapa', 'ra_per_personas', 'per_codmun_nac', '9'), ('sni_municipio', 'San Francisco Gotera', 'ra_per_personas', 'per_codmun_nac', '222'), ('sni_municipio', 'Arambala', 'ra_per_personas', 'per_codmun_nac', '223'), ('sni_municipio', 'Cacaopera', 'ra_per_personas', 'per_codmun_nac', '224'), ('sni_municipio', 'Chilanga', 'ra_per_personas', 'per_codmun_nac', '227'), ('sni_municipio', 'Corinto', 'ra_per_personas', 'per_codmun_nac', '226'), ('sni_municipio', 'Delicias de Concepción', 'ra_per_personas', 'per_codmun_nac', '228'), ('sni_municipio', 'El Divisadero', 'ra_per_personas', 'per_codmun_nac', '229'), ('sni_municipio', 'El Rosario', 'ra_per_personas', 'per_codmun_nac', '103'), ('sni_municipio', 'Gualococti', 'ra_per_personas', 'per_codmun_nac', '4'), ('sni_municipio', 'Guatajiagua', 'ra_per_personas', 'per_codmun_nac', '232'), ('sni_municipio', 'Joateca', 'ra_per_personas', 'per_codmun_nac', '233'), ('sni_municipio', 'Jocoaitique', 'ra_per_personas', 'per_codmun_nac', '234'), ('sni_municipio', 'Jocoro', 'ra_per_personas', 'per_codmun_nac', '235'), ('sni_municipio', 'Lolotique', 'ra_per_personas', 'per_codmun_nac', '85'), ('sni_municipio', 'Meanguera', 'ra_per_personas', 'per_codmun_nac', '209'), ('sni_municipio', 'Osicala', 'ra_per_personas', 'per_codmun_nac', '239'), ('sni_municipio', 'Perquín', 'ra_per_personas', 'per_codmun_nac', '240'), ('sni_municipio', 'San Carlos', 'ra_per_personas', 'per_codmun_nac', '241'), ('sni_municipio', 'San Fernando', 'ra_per_personas', 'per_codmun_nac', '141'), ('sni_municipio', 'San Isidro', 'ra_per_personas', 'per_codmun_nac', '70'), ('sni_municipio', 'San Simón', 'ra_per_personas', 'per_codmun_nac', '243'), ('sni_municipio', 'Sesembra', 'ra_per_personas', 'per_codmun_nac', '244'), ('sni_municipio', 'Sociedad', 'ra_per_personas', 'per_codmun_nac', '245'), 
--	('sni_municipio', 'Torola', 'ra_per_personas', 'per_codmun_nac', '246'), ('sni_municipio', 'Yamabal', 'ra_per_personas', 'per_codmun_nac', '247'), ('sni_municipio', 'Yoloiaquín', 'ra_per_personas', 'per_codmun_nac', '248'), ('sni_municipio', 'La Unión', 'ra_per_personas', 'per_codmun_nac', '199'), ('sni_municipio', 'Anamorós', 'ra_per_personas', 'per_codmun_nac', '200'), ('sni_municipio', 'Bolivar', 'ra_per_personas', 'per_codmun_nac', '201'), ('sni_municipio', 'Concepción de Oriente', 'ra_per_personas', 'per_codmun_nac', '202'), ('sni_municipio', 'Conchagua', 'ra_per_personas', 'per_codmun_nac', '203'), ('sni_municipio', 'El Carmen', 'ra_per_personas', 'per_codmun_nac', '116'), ('sni_municipio', 'El Sauce', 'ra_per_personas', 'per_codmun_nac', '205'), ('sni_municipio', 'Intipucá', 'ra_per_personas', 'per_codmun_nac', '207'), ('sni_municipio', 'Lislique', 'ra_per_personas', 'per_codmun_nac', '208'), ('sni_municipio', 'Meanguera del Golfo', 'ra_per_personas', 'per_codmun_nac', '209'), ('sni_municipio', 'Nueva Esparta', 'ra_per_personas', 'per_codmun_nac', '210'), ('sni_municipio', 'Pasaquina', 'ra_per_personas', 'per_codmun_nac', '212'), ('sni_municipio', 'Polorós', 'ra_per_personas', 'per_codmun_nac', '213'), ('sni_municipio', 'San Alejo', 'ra_per_personas', 'per_codmun_nac', '215'), ('sni_municipio', 'San José la Fuente', 'ra_per_personas', 'per_codmun_nac', '216'), ('sni_municipio', 'Santa Rosa de Lima', 'ra_per_personas', 'per_codmun_nac', '217'), ('sni_municipio', 'Yayantique', 'ra_per_personas', 'per_codmun_nac', '218'), ('sni_municipio', 'Yucuaiquín', 'ra_per_personas', 'per_codmun_nac', '219'), ('sni_municipio', 'Nueva San Salvador', 'ra_per_personas', 'per_codmun_nac', '151'), ('sni_municipio', 'Antiguo Cuscatlán', 'ra_per_personas', 'per_codmun_nac', '152'), ('sni_municipio', 'Ciudad Arce', 'ra_per_personas', 'per_codmun_nac', '153'), ('sni_municipio', 'Colón', 'ra_per_personas', 'per_codmun_nac', '173'), ('sni_municipio', 'Comasagua', 'ra_per_personas', 'per_codmun_nac', '154'), ('sni_municipio', 'Chiltiupán', 'ra_per_personas', 'per_codmun_nac', '975'), ('sni_municipio', 'Huizúcar', 'ra_per_personas', 'per_codmun_nac', '156'), ('sni_municipio', 'Jayaque', 'ra_per_personas', 'per_codmun_nac', '157'), ('sni_municipio', 'Jicalapa', 'ra_per_personas', 'per_codmun_nac', '981'), ('sni_municipio', 'La Libertad', 'ra_per_personas', 'per_codmun_nac', '158'), ('sni_municipio', 'Nuevo Cuscatlán', 'ra_per_personas', 'per_codmun_nac', '160'), ('sni_municipio', 'San Juan Opico', 'ra_per_personas', 'per_codmun_nac', '164'), ('sni_municipio', 'Quezaltepeque', 'ra_per_personas', 'per_codmun_nac', '124'), ('sni_municipio', 'Sacacoyo', 'ra_per_personas', 'per_codmun_nac', '162'), ('sni_municipio', 'San José Villanueva', 'ra_per_personas', 'per_codmun_nac', '163'), ('sni_municipio', 'San Matías', 'ra_per_personas', 'per_codmun_nac', '165'), ('sni_municipio', 'San Pablo Tacachico', 'ra_per_personas', 'per_codmun_nac', '166'), ('sni_municipio', 'Tamanique', 'ra_per_personas', 'per_codmun_nac', '170'), ('sni_municipio', 'Teotepeque', 'ra_per_personas', 'per_codmun_nac', '171'), ('sni_municipio', 'Tepecoyo', 'ra_per_personas', 'per_codmun_nac', '172'), ('sni_municipio', 'Zaragoza', 'ra_per_personas', 'per_codmun_nac', '174'), ('sni_municipio', 'Chalatenango', 'ra_per_personas', 'per_codmun_nac', '117'), ('sni_municipio', 'Agua Caliente', 'ra_per_personas', 'per_codmun_nac', '118'), ('sni_municipio', 'Arcatao', 'ra_per_personas', 'per_codmun_nac', '119'), ('sni_municipio', 'Azacualpa', 'ra_per_personas', 'per_codmun_nac', '120'), ('sni_municipio', 'San José Cancasque', 'ra_per_personas', 'per_codmun_nac', '121'), ('sni_municipio', 'Citalá', 'ra_per_personas', 'per_codmun_nac', '122'), ('sni_municipio', 'Comalapa', 'ra_per_personas', 'per_codmun_nac', '123'), ('sni_municipio', 'Concepcion Quezaltepeque', 'ra_per_personas', 'per_codmun_nac', '124'), ('sni_municipio', 'Dulce Nombre de María', 'ra_per_personas', 'per_codmun_nac', '126'), ('sni_municipio', 'El Carrizal', 'ra_per_personas', 'per_codmun_nac', '127'), ('sni_municipio', 'El Paraíso', 'ra_per_personas', 'per_codmun_nac', '129'), ('sni_municipio', 'La Laguna', 'ra_per_personas', 'per_codmun_nac', '131'), ('sni_municipio', 'La Palma', 'ra_per_personas', 'per_codmun_nac', '132'), ('sni_municipio', 'La Reina', 'ra_per_personas', 'per_codmun_nac', '94'), ('sni_municipio', 'Las Flores', 'ra_per_personas', 'per_codmun_nac', '145'), ('sni_municipio', 'Las Vueltas', 'ra_per_personas', 'per_codmun_nac', '134'), ('sni_municipio', 'Nombre de Jesús', 'ra_per_personas', 'per_codmun_nac', '125'), ('sni_municipio', 'Nueva Concepción', 'ra_per_personas', 'per_codmun_nac', '135'), ('sni_municipio', 'Nueva Trinidad', 'ra_per_personas', 'per_codmun_nac', '980'), ('sni_municipio', 'Ojos de Agua', 'ra_per_personas', 'per_codmun_nac', '136'), ('sni_municipio', 'Potonico', 'ra_per_personas', 'per_codmun_nac', '137'), ('sni_municipio', 'San Antonio de la Cruz', 'ra_per_personas', 'per_codmun_nac', '978'), ('sni_municipio', 'San Antonio los Ranchos', 'ra_per_personas', 'per_codmun_nac', '140'), ('sni_municipio', 'San Fernando', 'ra_per_personas', 'per_codmun_nac', '141'), ('sni_municipio', 'San Francisco Lempa', 'ra_per_personas', 'per_codmun_nac', '142'), ('sni_municipio', 'San Francisco Morazán', 'ra_per_personas', 'per_codmun_nac', '143'), ('sni_municipio', 'San Ignancio', 'ra_per_personas', 'per_codmun_nac', '144'), ('sni_municipio', 'San Isidro Labrador', 'ra_per_personas', 'per_codmun_nac', '144'), ('sni_municipio', 'San Luis del Carmen', 'ra_per_personas', 'per_codmun_nac', '146'), ('sni_municipio', 'San Miguel de Mercedes', 'ra_per_personas', 'per_codmun_nac', '147'), ('sni_municipio', 'San Rafael', 'ra_per_personas', 'per_codmun_nac', '95'), ('sni_municipio', 'Santa Rita', 'ra_per_personas', 'per_codmun_nac', '149'), ('sni_municipio', 'Tejutla', 'ra_per_personas', 'per_codmun_nac', '150'), ('sni_municipio', 'Cojutepeque', 'ra_per_personas', 'per_codmun_nac', '101'), ('sni_municipio', 'San Cristóbal', 'ra_per_personas', 'per_codmun_nac', '40'), ('sni_municipio', 'Monte San Juan', 'ra_per_personas', 'per_codmun_nac', '104'), ('sni_municipio', 'Candelaria', 'ra_per_personas', 'per_codmun_nac', '27'), ('sni_municipio', 'Tenancingo', 'ra_per_personas', 'per_codmun_nac', '115'), ('sni_municipio', 'San Pedro Perulapán', 'ra_per_personas', 'per_codmun_nac', '109'), ('sni_municipio', 'El carmen', 'ra_per_personas', 'per_codmun_nac', '116'), ('sni_municipio', 'El Rosario', 'ra_per_personas', 'per_codmun_nac', '103'), ('sni_municipio', 'Oratorio de Concepción', 'ra_per_personas', 'per_codmun_nac', '105'), ('sni_municipio', 'San Bartolomé Perulapía', 'ra_per_personas', 'per_codmun_nac', '974'), ('sni_municipio', 'San José Guayabal', 'ra_per_personas', 'per_codmun_nac', '108'), ('sni_municipio', 'San Rafael Cedros', 'ra_per_personas', 'per_codmun_nac', '110'), ('sni_municipio', 'San Ramón', 'ra_per_personas', 'per_codmun_nac', '111'), ('sni_municipio', 'Santa Cruz Analquito', 'ra_per_personas', 'per_codmun_nac', '112'), ('sni_municipio', 'Santa Cruz Michapa', 'ra_per_personas', 'per_codmun_nac', '113'), ('sni_municipio', 'Suchitoto', 'ra_per_personas', 'per_codmun_nac', '114'), ('sni_municipio', 'San Salvador', 'ra_per_personas', 'per_codmun_nac', '3'), ('sni_municipio', 'Aguilares', 'ra_per_personas', 'per_codmun_nac', '22'), ('sni_municipio', 'Apopa', 'ra_per_personas', 'per_codmun_nac', '23'), ('sni_municipio', 'Ayutuxtepeque', 'ra_per_personas', 'per_codmun_nac', '4'), ('sni_municipio', 'Cuscatancingo', 'ra_per_personas', 'per_codmun_nac', '6'), ('sni_municipio', 'Delgado', 'ra_per_personas', 'per_codmun_nac', '5'), ('sni_municipio', 'El Paisnal', 'ra_per_personas', 'per_codmun_nac', '7'), ('sni_municipio', 'Guazapa', 'ra_per_personas', 'per_codmun_nac', '9'), ('sni_municipio', 'Ilopango', 'ra_per_personas', 'per_codmun_nac', '10'), ('sni_municipio', 'Mejicanos', 'ra_per_personas', 'per_codmun_nac', '11'), ('sni_municipio', 'Nejapa', 'ra_per_personas', 'per_codmun_nac', '12'), ('sni_municipio', 'Panchimalco', 'ra_per_personas', 'per_codmun_nac', '13'), ('sni_municipio', 'Rosario de Mora', 'ra_per_personas', 'per_codmun_nac', '15'), ('sni_municipio', 'San Marcos', 'ra_per_personas', 'per_codmun_nac', '16'), ('sni_municipio', 'San Martín', 'ra_per_personas', 'per_codmun_nac', '17'), ('sni_municipio', 'Santiago Texacuangos', 'ra_per_personas', 'per_codmun_nac', '18'), ('sni_municipio', 'Santo Tomás', 'ra_per_personas', 'per_codmun_nac', '19'), ('sni_municipio', 'Soyapango', 'ra_per_personas', 'per_codmun_nac', '20'), ('sni_municipio', 'Tonacatepeque', 'ra_per_personas', 'per_codmun_nac', '21'), ('sni_municipio', 'Zacatecoluca', 'ra_per_personas', 'per_codmun_nac', '175'), ('sni_municipio', 'Cuyultitán', 'ra_per_personas', 'per_codmun_nac', '176'), ('sni_municipio', 'El Rosario', 'ra_per_personas', 'per_codmun_nac', '103'), ('sni_municipio', 'Jerusalén', 'ra_per_personas', 'per_codmun_nac', '178'), ('sni_municipio', 'Mercedes La Ceiba', 'ra_per_personas', 'per_codmun_nac', '181'), ('sni_municipio', 'Olocuilta', 'ra_per_personas', 'per_codmun_nac', '182'), ('sni_municipio', 'Paraiso de Osorio', 'ra_per_personas', 'per_codmun_nac', '183'), ('sni_municipio', 'San Antonio Masahuat', 'ra_per_personas', 'per_codmun_nac', '184'), ('sni_municipio', 'San Emigdio', 'ra_per_personas', 'per_codmun_nac', '185'), ('sni_municipio', 'San Francisco Chinameca', 'ra_per_personas', 'per_codmun_nac', '186'), ('sni_municipio', 'San Juan Nonualco', 'ra_per_personas', 'per_codmun_nac', '188'), ('sni_municipio', 'San Juan Talpa', 'ra_per_personas', 'per_codmun_nac', '189'), ('sni_municipio', 'San Juan Tepezontes', 'ra_per_personas', 'per_codmun_nac', '190'), ('sni_municipio', 'San Luis la Herradura', 'ra_per_personas', 'per_codmun_nac', '191'), ('sni_municipio', 'San Luis Talpa', 'ra_per_personas', 'per_codmun_nac', '191'), 
--	('sni_municipio', 'San Miguel Tepezontes', 'ra_per_personas', 'per_codmun_nac', '192'), ('sni_municipio', 'San Pedro Masahuat', 'ra_per_personas', 'per_codmun_nac', '193'), ('sni_municipio', 'San Pedro Nonualco', 'ra_per_personas', 'per_codmun_nac', '194'), ('sni_municipio', 'San Rafael Obrajuelo', 'ra_per_personas', 'per_codmun_nac', '195'), ('sni_municipio', 'Santa María Ostuma', 'ra_per_personas', 'per_codmun_nac', '196'), ('sni_municipio', 'Santiago Nonualco', 'ra_per_personas', 'per_codmun_nac', '197'), ('sni_municipio', 'Tapalhuaca', 'ra_per_personas', 'per_codmun_nac', '198'), ('sni_municipio', 'Ilobasco', 'ra_per_personas', 'per_codmun_nac', '68'), ('sni_municipio', 'San Isidro', 'ra_per_personas', 'per_codmun_nac', '70'), ('sni_municipio', 'Cinquera', 'ra_per_personas', 'per_codmun_nac', '66'), ('sni_municipio', 'Sensuntepeque', 'ra_per_personas', 'per_codmun_nac', '65'), ('sni_municipio', 'Dolores', 'ra_per_personas', 'per_codmun_nac', '72'), ('sni_municipio', 'Guacotecti', 'ra_per_personas', 'per_codmun_nac', '67'), ('sni_municipio', 'Jutiapa', 'ra_per_personas', 'per_codmun_nac', '69'), ('sni_municipio', 'Tejutepeque', 'ra_per_personas', 'per_codmun_nac', '71'), ('sni_municipio', 'Victoria', 'ra_per_personas', 'per_codmun_nac', '73'), ('sni_municipio', 'San Vicente', 'ra_per_personas', 'per_codmun_nac', '249'), ('sni_municipio', 'San Sebastian', 'ra_per_personas', 'per_codmun_nac', '42'), ('sni_municipio', 'Tepetitán', 'ra_per_personas', 'per_codmun_nac', '252'), ('sni_municipio', 'Apastepeque', 'ra_per_personas', 'per_codmun_nac', '250'), ('sni_municipio', 'Guadalupe', 'ra_per_personas', 'per_codmun_nac', '87'), ('sni_municipio', 'San Cayatano Istepeque', 'ra_per_personas', 'per_codmun_nac', '253'), ('sni_municipio', 'San Esteban Catarina', 'ra_per_personas', 'per_codmun_nac', '254'), ('sni_municipio', 'San Idelfonso', 'ra_per_personas', 'per_codmun_nac', '255'), ('sni_municipio', 'San Lorenzo', 'ra_per_personas', 'per_codmun_nac', '61'), ('sni_municipio', 'Santa Clara', 'ra_per_personas', 'per_codmun_nac', '258'), ('sni_municipio', 'Santo Domingo', 'ra_per_personas', 'per_codmun_nac', '260'), ('sni_municipio', 'Tecoluca', 'ra_per_personas', 'per_codmun_nac', '175'), ('sni_municipio', 'Verapaz', 'ra_per_personas', 'per_codmun_nac', '262')

insert into ra_med_medios (med_codigo, med_nombre, med_tipo, med_estado) values (91, 'Instagram', 'M', 1)

select TOP 3 per_direccion, /*per_nacionalidad, per_coddep_nac, per_codmun_nac, per_dui, per_anio_graduacion, per_paes, per_nota_paes, per_nit, per_emergencia, per_nit
, */* from ra_per_personas 
--where per_codigo in (181324, 227580)
order by per_codigo desc

--select sni_fecha_hora_creacion, sni_id_user, sni_Veiculo_tran_p, sni_Publico_tran, sni_Veiculo_tran_pp, sni_posee_veh, sni_posee_cel, sni_extra_img1, 
--* from ni_sni_solicitud_nuevo_ingreso

--exec dbo.sp_sni_solicitud_nuevo_ingreso @opcion = 7, @snival_columna_tabla_sni = 'sni_municipio', @snival_columna_tabla_valor = 'Mejicanos'

declare @codper int = 227598
SELECT * from ra_alc_alumnos_carrera where alc_codper = @codper
SELECT * from ra_equ_equivalencia_universidad where equ_codper = @codper
SELECT * from ra_cap_car_per where cap_codper = @codper
SELECT * from ra_ina_indicador_alumno where ina_codper = @codper
SELECT * from ra_trp_trabajos_per where trp_codper = @codper
SELECT * from ra_mep_medios_persona where mep_codper = @codper
SELECT * from ra_hap_habilidades_per where hap_codper = @codper
SELECT * from ra_dop_doc_per where dop_codper = @codper
SELECT * from ra_moa_movimiento_auditoria where moa_codper = @codper
SELECT * from ra_parsol_pariente_solicitud where parsol_codper = @codper
SELECT * from ra_hac_his_alm_car where hac_codper = @codper
SELECT * from col_cua_cuotas_alumnos where cua_codper = @codper--guarda la "Forma de Pago"
select * from ra_emr_emergencias where emr_codper = @codper
select * from ra_esp_est_sup where esp_codper = @codper
select * from ra_sca_segunda_carrera where sca_codper_nuevacarrera = @codper
select * from adm_cead_cuentas_error_ad where cead_codper = @codper
select * from ma_alppabe_alumno_plan_pago where alppabe_codper = @codper
select sni_per_codigo_asignado, * from ni_sni_solicitud_nuevo_ingreso where sni_per_codigo_asignado = @codper 
select * from dip_ped_personas_dip where ped_codper = @codper --POR SI TIENE DIPLOMADO
SELECT * from ra_per_personas where per_codigo = @codper

select * from ni_snival_solicitud_nuevo_ingreo_valores

--drop table ni_asigsni_asignacion_solcitud_nuevo_ingreso
--create table ni_asigsni_asignacion_solcitud_nuevo_ingreso(
--	asigsni_codigo int primary key identity(1, 1),
--	asigsni_codsni_asginado int,
--	asigsni_codusr_asignado int,
--	asigsni_codusr_asigno int,
--	asigsni_fecha_hora_creacion datetime default getdate()
--)
--select * from ni_asigsni_asignacion_solcitud_nuevo_ingreso

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-06-22 20:38:57.062>
	-- Description: <Realiza el mantenimiento a la tabla de asignación de solicitudes de nuevo ingreso>
	-- =============================================
	-- sp_ni_asigsni_asignacion_solcitud_nuevo_ingreso 1
alter procedure sp_ni_asigsni_asignacion_solcitud_nuevo_ingreso
	@opcion int = 0,
	@asigsni_codsni_asginado int = 0, 
	@asigsni_codusr_asignado int = 0, 
	@asigsni_codusr_asigno int = 0
as
begin

	if @opcion = 1
	begin
		-- select * from adm_rol_roles where rol_codigo in (9, 30)
		--select 407 rus_codusr, 'fabio' usr_usuario union
		select distinct rus_codusr, concat(usr_usuario, '  (', usr_nombre, ')') usr_usuario
		from adm_rus_role_usuarios, adm_usr_usuarios, adm_rol_roles where rus_role in (9, 30) and usr_codigo = rus_codusr and rus_role = rol_codigo
		order by usr_usuario
	end

	if @opcion = 2
	begin
		insert into ni_asigsni_asignacion_solcitud_nuevo_ingreso (asigsni_codsni_asginado, asigsni_codusr_asignado, asigsni_codusr_asigno)
		values (@asigsni_codsni_asginado, @asigsni_codusr_asignado, @asigsni_codusr_asigno)
		select @@rowcount
	end
end

--insert into adm_opm_opciones_menu (opm_codigo, opm_nombre, opm_link, opm_opcion_padre, opm_orden, opm_sistema)
--values (1080, 'Solicitudes ingreso-trend', 'logo.html', 347, 1, 'U'),
--(1081, 'Solicitudes nuevo ingreso', 'NI_solicitud_ingreso.aspx', 1080, 1, 'U'),
--(1082, 'Asignación usuarios-solicitudes NI', 'NI_asigsni_asignacion_soli.aspx', 1080, 2, 'U')


-- =============================================
-- Author:        <Manrrique Arita>
-- Create date: <23/06/2020>
-- Description:    <Inserta los documentos de la solicitud de ingreso de los datos enviados por trend al empresarial>
-- =============================================
-- inserta_documentos_alumno_trend 1, 'fabio.r', 227587, 2
ALTER procedure [dbo].[inserta_documentos_alumno_trend]
    @opcion int,
    @usuario nvarchar(50),
    @dop_codper int,
    @dop_coddoc int
as
begin
    if @opcion = 1
    begin
        insert into ra_dop_doc_per (dop_codigo, dop_codper, dop_coddoc, dop_fecha)
        select (isnull(max(dop_codigo),0)+1), @dop_codper, @dop_coddoc, getdate() from ra_dop_doc_per

		declare @moa_codigo int = 0
		--select @moa_codigo = (isnull(max(moa_codigo),0)+1) from ra_moa_movimiento_auditoria
        insert into ra_moa_movimiento_auditoria (moa_usuario, moa_codper, moa_movimiento, moa_fecha, moa_tipo, moa_coddoc)
        select @usuario, @dop_codper, 'Registra_Alumno', getdate(), 'E', @dop_coddoc
    end
end

--alter table ra_ina_indicador_alumno add ina_paga_estudio varchar(50)
ALTER proc [dbo].[sp_insertar_indicador]
       @ina_codprh int,
       @ina_automovil char(2),
       @ina_razon_matricula varchar(15),
       @ina_codmun int,
       @ina_anio_gradubachiller int,
       @ina_remesas char(2),
       @ina_paga_estudio varchar(50),
       @ina_codper int,
       @ina_responsable_estu varchar(200),
       @ina_responsable_tel varchar(15)
as
begin
	insert into ra_ina_indicador_alumno 
	values(@ina_codprh,@ina_automovil,@ina_razon_matricula,@ina_codmun,@ina_anio_gradubachiller,@ina_remesas,@ina_paga_estudio,getdate(),@ina_codper,@ina_responsable_estu,@ina_responsable_tel)
	if(@ina_anio_gradubachiller<>0)
	begin
		update ra_per_personas set per_codmun_nac=@ina_codmun,per_anio_graduacion=cast(cast(@ina_anio_gradubachiller as varchar)+'-01-01' as datetime) 
		where per_codigo=@ina_codper  
	end
end