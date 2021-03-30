--select * from ra_Tramites_academicos_online


--145	 C-13 	Constancia de Horario.
--146	 C-14 	Constancia de Estudiante
--862	 R-13 	Rep. de Hoja de Inscripcion
--877	 R-28 	Reporte de Notas
--1435   R-70	Informe de Notas por Evaluación

----drop table col_arpuu_aranceles_pago_unico_uso
--create table col_arpuu_aranceles_pago_unico_uso (
--	arpuu_codigo int primary key identity (1, 1),
--	arpuu_codtmo int,
--	arpuu_cantidad_usos int default 1,
--	arpuu_codtrao int null,
--	apuu_fecha_creacion datetime default getdate()
--)
---- select * from col_arpuu_aranceles_pago_unico_uso
--insert into col_arpuu_aranceles_pago_unico_uso 
--(arpuu_codtmo, arpuu_cantidad_usos, arpuu_codtrao) 
--values (3, 1, null), (141, 1, null), (852, 1, null),
--(145, 1, 11), (146, 1, 11), (862, 1, 11), (877, 1, 11), (1435, 1, 11)

-- drop table ra_sea_solicitudes_efectuadas_alumno
create table ra_sea_solicitudes_efectuadas_alumno (
	sea_codigo int primary key identity (1, 1),
	sea_codtmo int,
	sea_codcil_ingreso int,
	sea_codcil_solicita int,
	sea_codper int,
	sea_descripcion varchar(max),
	sea_es_fantel bit default 0,
	sea_forma_envio varchar(125),
	sea_generado char(1) default 'N',
	sea_codusr_genero int,
	sea_fecha_generado datetime,
	sea_fecha_hora_creacion datetime default getdate()
)
-- select * from ra_sea_solicitudes_efectuadas_alumno

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2021-02-06 20:50:56.721>
	-- Description: <Realiza el manteamiento de la tabla "ra_sea" para las solicitudes de constancias>
	-- =============================================
alter procedure sp_ra_sea_solicitudes_efectuadas_alumno
	@opcion int = 0,
	@codcil int = 0,
	@codper int = 0, 

	@sea_codigo int = 0,
	@sea_codtmo int = 0,
	@sea_codcil_solicita int = 0,
	@sea_descripcion varchar(max) = '',
	@sea_es_fantel bit = 0,
	@sea_forma_envio varchar(125) = '',
	@sea_generado char(1) = '',
	@sea_codusr_genero int = 0,

	@fecha_desde nvarchar(12) = '', 
    @fecha_hasta nvarchar(12) = '',
	@txt_buscar varchar(125) = ''
as
begin
	
	set dateformat dmy

	declare  @tbl_aranceles_pagados_uso as table (
		tmo_codigo int, tmo_arancel varchar(5),
		tmo_descripcion varchar(100), pagos_realizados int, 
		utilizados int
	)
	
	if @opcion = 0 -- Ciclos de estudio del alumno
	begin
		select cil_codigo, concat('0', cil_codcic, '-', cil_anio) ciclo from ra_ins_inscripcion 
			inner join ra_cil_ciclo on cil_codigo = ins_codcil
		where ins_codper = @codper --and ins_estado = 'A'
		order by cil_anio desc, cil_codcic desc
	end

	if @opcion = 1 --Devuelve los arancles pagados y que fue solicitar el tramite
	begin
		-- exec dbo.sp_ra_sea_solicitudes_efectuadas_alumno 1, 125, 173322
		insert into @tbl_aranceles_pagados_uso (tmo_codigo, tmo_arancel, tmo_descripcion, pagos_realizados, utilizados)
		exec dbo.sp_tramites_efecturado_inscripcion 1, @codcil, @codper

		--select * from @tbl_aranceles_pagados_uso
		select 0 arpuu_codtmo, '*Selecciona la constancia*' descripcion
		union all
		select arpuu_codtmo, concat(tbl.tmo_descripcion, ' (', tbl.tmo_arancel,')') descripcion  
		from col_arpuu_aranceles_pago_unico_uso
			inner join ra_Tramites_academicos_online on arpuu_codtrao = trao_codigo
			inner join col_tmo_tipo_movimiento tmo on tmo_codigo = arpuu_codtmo
			inner join @tbl_aranceles_pagados_uso tbl on arpuu_codtmo = tbl.tmo_codigo
		where trao_estado = 'Activo'

	end

	if @opcion = 2 -- Inserta la solicitud a tabla "sea"
	begin
		insert into ra_sea_solicitudes_efectuadas_alumno 
		(sea_codtmo, sea_codcil_ingreso, sea_codcil_solicita, sea_codper, sea_descripcion, sea_es_fantel, sea_forma_envio)
		values (@sea_codtmo, @codcil, @sea_codcil_solicita, @codper, @sea_descripcion, @sea_es_fantel, @sea_forma_envio)
		select scope_identity()

	end

	if @opcion = 3 -- Detalle de las solicitudes por @codper por @ciclo
	begin
		-- exec dbo.sp_ra_sea_solicitudes_efectuadas_alumno 3, 125, 173322
		select sea_codigo, concat(tmo_descripcion, ' (', tmo_arancel,')') tramite_descripcion, 
		concat('0', cil_codcic, '-', cil_anio) ciclo_solicita, sea_descripcion, sea_forma_envio,
		case when sea_generado = 'S' then 'Si' else 'No' end constancia_generada, sea_fecha_hora_creacion
		from ra_sea_solicitudes_efectuadas_alumno
			inner join col_arpuu_aranceles_pago_unico_uso on arpuu_codtmo = sea_codtmo
			inner join ra_Tramites_academicos_online on arpuu_codtrao = trao_codigo
			inner join col_tmo_tipo_movimiento tmo on tmo_codigo = arpuu_codtmo
			inner join ra_cil_ciclo on cil_codigo = sea_codcil_solicita
		where sea_codper = @codper and sea_codcil_ingreso = @codcil
		order by sea_codigo desc
	end

	if @opcion = 4 -- Detalle de las solicitudes por rango de fechas
	begin
		-- exec dbo.sp_ra_sea_solicitudes_efectuadas_alumno @opcion = 4, @fecha_desde = '07/02/2021', @fecha_hasta = '07/02/2021', @txt_buscar = ''
		select 
			sea_codigo, per_carnet, per_apellidos_nombres, tramite_descripcion, sea_codcil_solicita, ciclo_solicita, sea_es_fantel_texto, sea_es_fantel, 
			sea_descripcion, sea_forma_envio, constancia_generada, sea_fecha_hora_creacion, fecha_cancelo, sea_codusr_genero, 
			sea_fecha_generado, usr_usuario
		from (
			select sea_codigo, per_carnet, per_apellidos_nombres, concat(tmo_descripcion, ' (', tmo_arancel,')') tramite_descripcion, 
			concat('0', cil_codcic, '-', cil_anio) ciclo_solicita, sea_codcil_solicita,
			case when sea_es_fantel = 1 then 'Si' else 'No' end sea_es_fantel_texto, sea_es_fantel, sea_descripcion, sea_forma_envio,
			case when sea_generado = 'S' then 'Si' else 'No' end constancia_generada, sea_fecha_hora_creacion,
			'' fecha_cancelo , sea_codusr_genero, sea_fecha_generado, usr_usuario
			from ra_sea_solicitudes_efectuadas_alumno
				inner join col_arpuu_aranceles_pago_unico_uso on arpuu_codtmo = sea_codtmo
				inner join ra_Tramites_academicos_online on arpuu_codtrao = trao_codigo
				inner join col_tmo_tipo_movimiento tmo on tmo_codigo = arpuu_codtmo
				inner join ra_cil_ciclo on cil_codigo = sea_codcil_solicita
				inner join ra_per_personas on per_codigo = sea_codper
				left join adm_usr_usuarios on sea_codusr_genero = usr_codigo
			where convert(date, sea_fecha_hora_creacion, 103) between convert(date, @fecha_desde, 103) and convert(date, @fecha_hasta, 103)
			) t
		where (ltrim(rtrim(per_carnet)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
        else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
        or
        (ltrim(rtrim(per_apellidos_nombres)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
        else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		or
        (ltrim(rtrim(sea_codigo)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
        else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		or
        (ltrim(rtrim(tramite_descripcion)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
        else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		or
        (ltrim(rtrim(sea_descripcion)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
        else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		order by sea_codigo desc
	end

	if @opcion = 5
	begin
		update ra_sea_solicitudes_efectuadas_alumno set sea_es_fantel = @sea_es_fantel, sea_codcil_solicita = @sea_codcil_solicita
		where sea_codigo = @sea_codigo
	end
	
	if @opcion = 6
	begin
		-- exec dbo.sp_ra_sea_solicitudes_efectuadas_alumno @opcion = 6, @sea_codigo = 13
		select sea_codigo, per_codigo, per_carnet, per_apellidos_nombres, tmo_codigo, concat(tmo_descripcion, ' (', tmo_arancel,')') tramite_descripcion, 
		sea_codcil_solicita, concat('0', cil_codcic, '-', cil_anio) ciclo_solicita, 
		case when sea_es_fantel = 1 then 'Si' else 'No' end sea_es_fantel_texto, sea_es_fantel, sea_descripcion, sea_forma_envio,
		case when sea_generado = 'S' then 'Si' else 'No' end constancia_generada, sea_fecha_hora_creacion,
		'' fecha_cancelo , sea_codusr_genero, sea_fecha_generado, usr_usuario
		from ra_sea_solicitudes_efectuadas_alumno
			inner join col_arpuu_aranceles_pago_unico_uso on arpuu_codtmo = sea_codtmo
			inner join ra_Tramites_academicos_online on arpuu_codtrao = trao_codigo
			inner join col_tmo_tipo_movimiento tmo on tmo_codigo = arpuu_codtmo
			inner join ra_cil_ciclo on cil_codigo = sea_codcil_solicita
			inner join ra_per_personas on per_codigo = sea_codper
			left join adm_usr_usuarios on sea_codusr_genero = usr_codigo
		where sea_codigo = @sea_codigo
	end

	if @opcion = 7
	begin
		if exists (select 1 from ra_sea_solicitudes_efectuadas_alumno where sea_codigo = @sea_codigo and sea_codusr_genero is null)
		begin
			update ra_sea_solicitudes_efectuadas_alumno set sea_codusr_genero = @sea_codusr_genero, sea_fecha_generado = getdate(),
			sea_generado = 'S'
			where sea_codigo = @sea_codigo	
		end
	end
	
end