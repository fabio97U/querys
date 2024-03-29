USE [uonline]
GO
/****** Object:  Trigger [dbo].[tr_col_mov_insert]    Script Date: 11/6/2020 18:37:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter trigger [dbo].[tr_ra_cil_insert]
on [dbo].[ra_cil_ciclo] after insert
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-06-11 18:47:44.4624>
	-- Description: <Trigger cuando se realiza un insert a la tabla "ra_cil_ciclo">
	-- =============================================
as
begin
	print 'tr_ra_cil_insert'
	declare @codcil int

	select @codcil = cil_codigo from inserted

	--Se inserta el registro del ciclo creado a la tabla "ra_reqpassol_requisitos_pasantias_solicitud"
	insert into ra_reqpassol_requisitos_pasantias_solicitud 
	(reqpassol_por_hor_soc, reqpassol_por_mat_pas, reqpassol_cum_min, reqpassol_codcil)
	select top 1 reqpassol_por_hor_soc, reqpassol_por_mat_pas, reqpassol_cum_min, @codcil 
	from ra_reqpassol_requisitos_pasantias_solicitud
	order by reqpassol_codigo desc
end
go

USE [uonline]
GO
/****** Object:  Trigger [dbo].[tr_col_mov_delete]    Script Date: 11/6/2020 18:37:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter trigger [dbo].[tr_ra_cil_delete]
on [dbo].[ra_cil_ciclo] after delete
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-06-11 18:47:41.543>
	-- Description: <Trigger cuando se realiza un delete a  la tabla "ra_cil_ciclo">
	-- =============================================
as
begin
	print 'tr_ra_cil_delete'
	declare @codcil int

	select @codcil = cil_codigo from inserted
	delete from ra_reqpassol_requisitos_pasantias_solicitud where reqpassol_codcil = @codcil
end
go

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[web_dec_pas_sol]    Script Date: 11/6/2020 18:26:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[web_dec_pas_sol]
	-- =============================================
	-- Author:		<Fabio>
	-- Create date: <06/11/2018>
	-- Description:	<Devuelve los requisitos(CUM, %H.Sociales, %M.Pasadas) de pasantia del ciclo junto con los datos propios(CUM, %H.Sociales, %M.Pasadas) del alumno>
	-- =============================================
	--web_dec_pas_sol '227506', '120'
	--web_dec_pas_sol 161227, 117
	--web_dec_pas_sol '150353', '119'
	@codper int, 
	@codcil int
as 
begin
	declare @carnet nvarchar(12)
	select @carnet = per_carnet from ra_per_personas where per_codigo = @codper
	declare @aprobadas table(total_aprobadas int)
	insert into @aprobadas(total_aprobadas)

	select (select count(1) from notas inner join ra_pla_planes on pla_codigo = mai_codpla
	inner join ra_car_carreras on car_codigo = pla_codcar 
	where ins_codper = @codper and nota >= 5.96 and car_identificador = SUBSTRING(@carnet,1,2) 
	and pla_codigo = (select alc_codpla from ra_alc_alumnos_carrera where alc_codper = @codper)) 
	+
	(
		select count(distinct eqn_codmat) 
		from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,
		ra_alc_alumnos_carrera, ra_plm_planes_materias
		where equ_codigo = eqn_codequ
		and equ_codper = @codper
		and eqn_nota > 0
		and alc_codper = equ_codper
		and plm_codpla = alc_codpla
		and plm_codmat = eqn_codmat
	)

	select pla.pla_alias_carrera 'carrera',
		pla.pla_anio, 
		isnull((select * from @aprobadas),0) as 'materias_pasadas', 
		isnull((select pla_n_mat from ra_pla_planes where pla_codigo = alc.alc_codpla),0) 'total_materias',
		isnull((select sum(hsp_horas) from ra_hsp_horas_sociales_personas where hsp_codper = @codper), 0) as 'horas_realizadas',
		(select car_horas_soc from ra_car_carreras where car_codigo = (select pla_codcar from ra_pla_planes where pla_codigo = alc.alc_codpla)) as 'total_horas',
		--round(dbo.cum(@codper),1) as 'cum', QUITADO EL 23/07/2019 PORQUE SE CREO LA FUNCION  fn_cum_limpio
		isnull(round(dbo.fn_cum_limpio(@codper, 1),1), 0) 'cum',
		reqpassol.reqpassol_por_hor_soc,
		reqpassol.reqpassol_por_mat_pas,
		reqpassol.reqpassol_cum_min
	from ra_alc_alumnos_carrera as alc 
		inner join ra_pla_planes as pla on pla.pla_codigo = alc.alc_codpla
		inner join ra_reqpassol_requisitos_pasantias_solicitud as reqpassol on reqpassol.reqpassol_codcil = @codcil
	where alc.alc_codper = @codper
	
end
go

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[ra_regr_inserta_reg]    Script Date: 12/6/2020 09:55:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[ra_regr_inserta_reg]
	-- =============================================
	-- Author:      <Author, Name>
	-- Create date: <Create Date>
	-- Last modify: Fabio, 2020-06-12 10:08:37.263
	-- Description: <Inserta la solicitud de la carta de egreso para los alumnos de pregrado y maestrías>
	-- =============================================

	@codper int, 
	@codusr int, 
	@codcil_ing int
as
begin
	set dateformat dmy
	declare @cum real, @codcil int, @documentos char(1), @observaciones varchar(100)
	--Asignacion de CUM limpio del Alumno
	set @cum = (select dbo.cum_todos_los_ciclos(@codper))
	--set @cum = (select dbo.cum(@codper))		--	Comentariado el 14/06/2018 por Juan Carlos Campos debido a que tiene que mostrar el cum de las materias aunque el ci

	--Asignacion de ciclo de egreso del Alumno
	-- ANTERIOR
	--select @codcil = max(ins_codcil) from ra_ins_inscripcion join ra_mai_mat_inscritas on mai_codins = ins_codigo 
	--where ins_codper =@codper 
	declare @Max_ciclo table(fecha nvarchar(10), ins_codcil int)

	insert into @Max_ciclo (fecha, ins_codcil)
	select top 1 max(ins_fecha)fecha, ins_codcil
	--into #Max_ciclo
	from ra_per_personas
		join ra_alc_alumnos_carrera on alc_codper = per_codigo
		join dbo.ra_ins_inscripcion on ins_codper = per_codigo
		join ra_mai_mat_inscritas on mai_codins = ins_codigo
		join ra_cil_ciclo on cil_codigo = ins_codcil
	where per_codigo = @codper and mai_estado = 'I'
	group by ins_codcil
	order by 1 desc

	select @codcil = ins_codcil
	from @Max_ciclo

	----Verificamos el tipo de ingreso del alumno
	--select isnull (per_tipo_ingreso_fijo, 1) from ra_per_personas where per_codigo=@codper

	--Verificamos los documentos de acuerdo al tipo de ingreso del alumno
	--select * from ra_doc_documentos where doc_coding=1 and doc_origen='N'
	--select * from ra_dop_doc_per where dop_codper=107408

	if ((select per_tipo from ra_per_personas where per_codigo = @codper) = 'M') --SON ALUMNOS DE MAESTRIAS, AGREGADO POR FABIO 2019-02-08
	begin
		
		select @codcil_ing = persolcareg_codcil from ma_persolcareg_periodo_solicitud_carta_egresado
		where getdate() >= persolcareg_fecha_inicio and getdate() <= persolcareg_fecha_fin

		if exists(select 1 from ra_dop_doc_per where dop_codper=@codper and dop_coddoc in (40))
		begin
			set @documentos= 'C'
			set @observaciones = 'Documentos Completos'
		end
		else if(select count(1) from ra_dop_doc_per where dop_codper=@codper) >= 8
		begin
			set @documentos = 'C'
			set @observaciones = 'Documentos Completos'
		end
		else 
		begin
			set @documentos = 'I'
			set @observaciones = 'Documentos Incompletos'
		end
	end
	else
	begin--SON ALUMNOS DE PREGRADO
		if exists(select 1 from ra_dop_doc_per where dop_codper=@codper and dop_coddoc in (10, 18))
		begin
			set @documentos= 'C'
			set @observaciones = 'Documentos Completos'
		end
		else if(select count(1) from ra_dop_doc_per where dop_codper=@codper) >= 4
		begin
			set @documentos = 'C'
			set @observaciones = 'Documentos Completos'
		end
		else 
		begin
			set @documentos = 'I'
			set @observaciones = 'Documentos Incompletos'
		end
	end

	--Inserta registro de Alumno egresado
	insert into ra_regr_registro_egresados (regr_codper, regr_fecha, regr_documentos, regr_observaciones, regr_estado, regr_cum, regr_codcil, regr_codusr, regr_codcil_ing)
	select @codper, GETDATE(), @documentos, @observaciones, 'A', @cum, @codcil, @codusr, @codcil_ing
end
go


USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[web_dec_pas_sol]    Script Date: 11/6/2020 18:26:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter procedure [dbo].[web_cum_mat_hor_almumno]
	-- =============================================
	-- Author:		<Fabio>
	-- Create date: <2020-06-11 18:52:25.978>
	-- Description:	<Devuelve las materias_pasadas, total_materias, horas_realizadas, total_horas, cum_limpio de un alumno>
	-- =============================================
	--web_cum_mat_hor_almumno '227506'
	@codper int
as 
begin
	declare @carnet nvarchar(12)
	select @carnet = per_carnet from ra_per_personas where per_codigo = @codper
	declare @aprobadas table(total_aprobadas int)
	insert into @aprobadas(total_aprobadas)

	select (select count(1) from notas inner join ra_pla_planes on pla_codigo = mai_codpla
	inner join ra_car_carreras on car_codigo = pla_codcar 
	where ins_codper = @codper and nota >= 5.96 and car_identificador = SUBSTRING(@carnet,1,2) 
	and pla_codigo = (select alc_codpla from ra_alc_alumnos_carrera where alc_codper = @codper)) 
	+
	(
		select count(distinct eqn_codmat) 
		from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,
		ra_alc_alumnos_carrera, ra_plm_planes_materias
		where equ_codigo = eqn_codequ
		and equ_codper = @codper
		and eqn_nota > 0
		and alc_codper = equ_codper
		and plm_codpla = alc_codpla
		and plm_codmat = eqn_codmat
	)

	select pla.pla_alias_carrera 'carrera',
		pla.pla_anio, 
		isnull((select * from @aprobadas),0) as 'materias_pasadas', 
		isnull((select pla_n_mat from ra_pla_planes where pla_codigo = alc.alc_codpla),0) 'total_materias',
		isnull((select sum(hsp_horas) from ra_hsp_horas_sociales_personas where hsp_codper = @codper), 0) as 'horas_realizadas',
		(select car_horas_soc from ra_car_carreras where car_codigo = (select pla_codcar from ra_pla_planes where pla_codigo = alc.alc_codpla)) as 'total_horas',
		isnull(round(dbo.fn_cum_limpio(@codper, 1),1), 0) 'cum'
	from ra_alc_alumnos_carrera as alc 
		inner join ra_pla_planes as pla on pla.pla_codigo = alc.alc_codpla
	where alc.alc_codper = @codper
	
end
go

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_ma_persolcareg_periodo_solicitud_carta_egresado]    Script Date: 12/6/2020 09:49:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[sp_ma_persolcareg_periodo_solicitud_carta_egresado]
	----------------------*----------------------
	-- =============================================
	-- Author:      <Fabio, Ramos>
	-- Create date: <2019-02-11 14:29:33.430>
	-- Description: <Realiza el mantenimento para la tabla ma_persolcareg_periodo_solicitud_carta_egresado en la cual se guardar los requisitos por ciclo para solicitar la carta de egresado>
	-- =============================================
	--sp_ma_persolcareg_periodo_solicitud_carta_egresado 2, 120, 202014
	--sp_ma_persolcareg_periodo_solicitud_carta_egresado 2, 117, 201951
	@opcion int,
	@codcil int = -1,--EN DESUSO
	@codper int
as
begin

	if @opcion = 1 --Devuelve la fecha inicio y fin de solicitud de carta de egresado en maestrias en un ciclo
	begin
		select persolcareg_fecha_inicio, persolcareg_fecha_fin from ma_persolcareg_periodo_solicitud_carta_egresado where persolcareg_codcil = @codcil
	end

	if @opcion = 2 --Devuelve si el estudiante cumple los requisitos(documentos completos y pago completos) de la tabla ma_persolcareg_periodo_solicitud_carta_egresado
	begin
		declare @documentos varchar(12), @pagos varchar(12), @persolcareg_pago_completos int, @persolcareg_documentos_completos int
		select @persolcareg_pago_completos = persolcareg_pago_completos, @persolcareg_documentos_completos= persolcareg_documentos_completos from ma_persolcareg_periodo_solicitud_carta_egresado where persolcareg_codcil = @codcil
		print @persolcareg_pago_completos
		print @persolcareg_documentos_completos
		if(@persolcareg_pago_completos = 1)
		begin
			declare @per_codcil int = 0
			select @per_codcil = persolcareg_codcil from ma_persolcareg_periodo_solicitud_carta_egresado
               where GETDATE() >= persolcareg_fecha_inicio and GETDATE() <= persolcareg_fecha_fin

			declare @Tabla Table (art_codigo int,cil_codigo int, per_codigo int, per_carnet nvarchar(12), carrera nvarchar(75), Alumno Nvarchar(60), fechaf nvarchar(8), /*referencia nvarchar(20),*/
					barra_f nvarchar(75), barra nvarchar(75), NPE nvarchar (30), barra_m_f nvarchar(75), barra_mora nvarchar(75), NPE_m nvarchar(30), Valor float, fecha date,
					fecha_v date, Orden int, papeleria float, portafolio float, valor_m float, matriculo float, ciclo nvarchar(7), per_estado nvarchar(3), per_tipo int, texto nvarchar(100),
					Estado Nvarchar(15), cuota_pagar float, cuota_pagar_mora float, Beca Float)
					insert into @Tabla
			exec web_col_art_archivo_tal_mae 4, @codper, @per_codcil, ''

			declare @total_pagos int, @pagos_realizados int

			select @total_pagos = count(1) from @Tabla
			select @pagos_realizados = count(1) from @Tabla where Estado = 'Cancelado'

			if (@total_pagos-@pagos_realizados) = 0
			begin
				print 'Tiene todos los pagos'
				set @pagos = 'Completos'
			end
			else
			begin
				print 'Le faltan pagos'
				set @pagos = 'Incompletos'
			end
		end
		else if(@persolcareg_pago_completos = 0)
		begin
			set @pagos = 'Completos'
		end

		if(@persolcareg_documentos_completos = 1)
		begin
			if exists(select 1 from ra_dop_doc_per where dop_codper=@codper and dop_coddoc in (40))
			begin
				set @documentos= 'Completos'
			end
			else if(select count(1) from ra_dop_doc_per where dop_codper=@codper) >= 8
			begin
				set @documentos = 'Completos'
			end
			else 
			begin
				set @documentos = 'Incompletos'
			end
		end
		else if(@persolcareg_documentos_completos = 0)
		begin
			set @documentos = 'Completos'
		end

		select 'Pagos: ', @pagos
		union
		select 'Documentos: ', @documentos
	end

end