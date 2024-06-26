USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_web_spa_solicitud_proceso_academico]    Script Date: 28/9/2022 10:08:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:      <>
	-- Create date: <>
	-- Last Modify: <Fabio, 2022-09-26 21:50:12.972>
	-- Description: <Se usa desde la solictud de examen diferido en el portal, se agrego el parametro @codhpl>
	-- =============================================
	-- exec dbo.sp_web_spa_solicitud_proceso_academico 1, 129, 226589, '01', 'EXOE-V', '1', 0, 0, 0, 0
ALTER PROCEDURE [dbo].[sp_web_spa_solicitud_proceso_academico]
	@opcion int = 0,
	@spa_codcil int = 0,
	@spa_codper int = 0,
	@spa_seccion varchar(50) = '',
	@spa_codmat varchar(10) = '',
	@spa_codspar int = 0,
	@spa_razon_otros varchar(200) = '',
	@spa_codspat int = 0,
	@spa_eva int = 0,
	@codhpl int = 0
as
begin
	declare @es_interciclo int 
	select @es_interciclo = cil_codcic from ra_cil_ciclo where cil_codigo = @spa_codcil

	if @codhpl <> 0 --Se esta enviando el codhpl
	begin
		select @spa_codmat = hpl_codmat, @spa_seccion = hpl_descripcion 
		from ra_hpl_horarios_planificacion where hpl_codigo = @codhpl
	end

	if @es_interciclo = 3
		set @opcion = 3
	--opcion para insertar diferido
	if @opcion = 1
	begin
		declare @contador int
		select @contador= count(1)  
		from web_spa_solicitud_proceso_academico 
		where spa_codper = @spa_codper AND spa_codcil = @spa_codcil AND spa_codspar > 0 and spa_codmat = @spa_codmat and spa_eva = @spa_eva

		declare @existePago int 
		select distinct @existePago = count(1)
		from vst_Aranceles_x_Evaluacion as V 
		inner join col_tmo_tipo_movimiento as T on T.tmo_codigo = V.are_codtmo 
		inner join col_dmo_det_mov on dmo_codtmo = T.tmo_codigo 
		inner join col_mov_movimientos on mov_codigo = dmo_codmov 
		inner join web_spaet_solicitud_proceso_academico_tipoevaluaciones as S on S.spaet_codigo = V.spaet_codigo 
		inner join web_spa_solicitud_proceso_academico on spa_eva = S.spaet_codigo
		where S.spaet_codigo = @spa_eva and mov_codper = @spa_codper and mov_codcil = @spa_codcil

		if (@contador = 0)
		begin
			select 'Insertar'
			if @existePago <> 0
			begin
				insert into web_spa_solicitud_proceso_academico(spa_codcil,spa_codper,spa_seccion,spa_codmat,spa_estatus,spa_codspar ,spa_codspat,spa_razon_otros,spa_eva) 
				values (@spa_codcil ,@spa_codper ,@spa_seccion,@spa_codmat,'solicitado', @spa_codspar,@spa_codspat,@spa_razon_otros,@spa_eva)
				select 'Diferido solicitado con exito' as msj
			end
			else
				select 'Diferido No fue solicitado con exito' as msj
		end
		else
		begin
			select 'No insertar'
		end
	end--if @opcion = 1

	if @opcion = 3 --ES INTERCICLO, SE INGRESA DIRECTAMENTE PORQUE EN EL FORMULARIO SE VALIDO QUE PAGO EL DIFERIDO SIN TOMAR EN CUENTA LAS CUOTAS
	begin
		insert into web_spa_solicitud_proceso_academico(spa_codcil,spa_codper,spa_seccion,spa_codmat,spa_estatus,spa_codspar ,spa_codspat,spa_razon_otros,spa_eva) 
		values (@spa_codcil ,@spa_codper ,@spa_seccion,@spa_codmat,'solicitado', @spa_codspar,@spa_codspat,@spa_razon_otros,@spa_eva)
		select 'Diferido solicitado con exito' as msj
	end --if @opcion = 3
end


USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_ver_ra_aan_activar_alumno_notas]    Script Date: 28/9/2022 10:08:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:      <>
	-- Create date: <>
	-- Last Modify: <Fabio, 2022-09-26 09:11:35.763>
	-- Description: <Devuelve los diferidos solicitados o pagos por estudiante
			-- La @opcion 1 y 2 se dejaron de usar en el portal educativo, ahora se usa solo la @opcion 3>
	-- =============================================
	-- exec sp_ver_ra_aan_activar_alumno_notas 2, '25-1582-2017', 2, 0 -- Opcion vieja @@DEPRECATED
	-- exec sp_ver_ra_aan_activar_alumno_notas 3, '', 2, 198764 -- Opcion refactorizada
ALTER procedure [dbo].[sp_ver_ra_aan_activar_alumno_notas]
	@opcion int = 0,
	@per_carnet nvarchar(25) = '',
	@evaluacion int = 0,
	@codper int = 0
as
begin

    declare @codcil int
    select @codcil = cil_codigo from ra_cil_ciclo where cil_vigente = 'S'

	print '@codcil ' + cast (@codcil as varchar(50))

    if (@opcion = 1) -- Diferidos solicitados @@DEPRECATED
    begin
        select aan_periodo as PERIODO, aan_tipo as TIPO, hpl_descripcion as 'SECCIÓN', mat_nombre as MATERIA, 
		hpl_codmat as 'CÓDIGO DE MATERIA', aan_fecha 'FECHA SOLICITUD'
        from ra_aan_activar_alumno_notas
            inner join ra_hpl_horarios_planificacion on aan_codhpl = hpl_codigo
            inner join ra_mat_materias on mat_codigo = hpl_codmat
            inner join ra_per_personas on per_codigo = aan_codper
            inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
            inner join ra_pla_planes on pla_codigo = alc_codpla 
		where per_carnet = @per_carnet
			and hpl_codcil = @codcil and /*aan_codusr= 378 and*/ aan_periodo = @evaluacion
        order by aan_fecha desc

    end

    if (@opcion = 2) -- Diferidos solicitados  @@DEPRECATED
    begin
        select aan_periodo as PERIODO, aan_tipo as TIPO, hpl_descripcion as 'SECCIÓN', mat_nombre as MATERIA, 
		hpl_codmat as 'CÓDIGO DE MATERIA', per_carnet as CARNET, per_nombres_apellidos as NOMBRE, pla_alias_carrera as CARRERA
		, cast(aan_fecha as varchar(30)) 'FECHA SOLICITUD'
        from ra_aan_activar_alumno_notas
            inner join ra_hpl_horarios_planificacion on aan_codhpl = hpl_codigo
            inner join ra_mat_materias on mat_codigo = hpl_codmat
            inner join ra_per_personas on per_codigo = aan_codper
            inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
            inner join ra_pla_planes on pla_codigo = alc_codpla 
		where per_carnet = @per_carnet
			and hpl_codcil = @codcil and /*aan_codusr= 378 and*/ aan_periodo = @evaluacion
        order by aan_fecha desc

    end

	if @opcion = 3 -- Se apunto a esta opcion desde la solicitud de examen diferido en el portal
	begin
		select evaluacion as PERIODO, 'Extraordinario' as TIPO, seccion as 'SECCIÓN', materia as MATERIA, 
		codmat as 'CÓDIGO DE MATERIA', carnet as CARNET, estudiante as NOMBRE, v.car_nombre as CARRERA
		, cast(v.fecha_pago_o_autorizacion as varchar(30)) 'FECHA SOLICITUD', v.usuario_pago_o_autorizacion, v.codhpl
		from vst_examenes_diferidos v
		where codper = @codper and codcil = @codcil 
			and evaluacion = case when @evaluacion = 0 then evaluacion else @evaluacion end
		order by v.fecha_pago_o_autorizacion desc
	end
end


USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_validar_materia_para_diferido]    Script Date: 28/9/2022 10:09:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:      <Author, Name>
	-- Create date: <2022-09-26 13:58:01.567>
	-- Description: <Determina si una @codmai puede ser solicitada>
	-- =============================================
	-- exec dbo.sp_validar_materia_para_diferido 129, '2', 198764, 5436077
create procedure [dbo].[sp_validar_materia_para_diferido]
	@codcil int = 0,
	@evaluacion varchar(3) = '',
	@codper int = 0,
	@codmai int = 0
as
begin

	select mai_codigo, (mai_codmat + ' - ' + mat_nombre) mat 
	from ra_ins_inscripcion 
		inner join ra_mai_mat_inscritas on mai_codins = ins_codigo 
		inner join ra_mat_materias on mat_codigo = mai_codmat 
	where ins_codper = @codper and ins_codcil = @codcil and mai_estado not in ('R')
	and mai_codigo not in (
		select codmai from dbo.vst_examenes_diferidos 
		where codper = @codper and codcil = @codcil and evaluacion = @evaluacion
	)

	if exists(select 1 from dbo.vst_examenes_diferidos where codper = @codper and codmai = @codmai)
	begin
		select 1--Ya tiene solicitado el examen o ya lo cancelo
	end
	else
	begin
		select 0
	end

end

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_web_validar_aranceles_para_examen_diferido]    Script Date: 28/9/2022 10:09:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	-- =============================================
	-- Author:      <>
	-- Create date: <>
	-- Last Modify: <Fabio, 2022-09-26 09:50:19.110>
	-- Description: <Se usa en la solicitud de examen diferido en el portal, valor 0: No esta solvente, 1: Esta solvente>
	-- =============================================
	-- exec sp_web_validar_aranceles_para_examen_diferido 1, 2, 198764, 129, 1
ALTER procedure [dbo].[sp_web_validar_aranceles_para_examen_diferido]
    @opcion int = 0,
    @evaluacion int = 0,
    @codper int = 0,
    @codcil int = 0,
    @codtde int = 0
as
begin
	
	declare @respuesta varchar(1024);
	declare @valor int, @CuotasCanceladas int, @prorrogas int, @mat_prim int

	if (@opcion = 1)
	begin
		if exists(select 1 from ra_cil_ciclo where cil_codigo = @codcil and cil_codcic = 3)
		begin
			print 'como es interciclo, no se evaluan los pagos'
			set @valor = 1
		end	
		else
		begin
			print 'como es ciclo, entonces se evaluan las cuotas'
			select  @mat_prim = count(distinct tmo_arancel)
			from col_mov_movimientos 
				inner join col_dmo_det_mov on dmo_codmov = mov_codigo 
				inner join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo 
				inner join aranceles_x_evaluacion on are_codtmo = dmo_codtmo
			where mov_codper = @codper and dmo_codcil = @codcil and mov_estado <> 'A' and are_codtde = @codtde and are_spaet_codigo = 0

			if @mat_prim = 2
			begin 
				print 'pago matricula y primer cuota'
				select @CuotasCanceladas = count(distinct tmo_arancel) --as CuotasPagadas
				from col_mov_movimientos 
					inner join col_dmo_det_mov on dmo_codmov = mov_codigo 
					inner join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo 
					inner join aranceles_x_evaluacion on are_codtmo = dmo_codtmo
				where mov_codper = @codper and dmo_codcil = @codcil and mov_estado <> 'A' and are_codtde = @codtde and are_spaet_codigo > 0
				print '@CuotasCanceladas : ' + cast(@CuotasCanceladas as nvarchar(10))

				if (@CuotasCanceladas) >= (@evaluacion) --SE SUMA UNO PARA TOMAR EN CUENTA LA PRIMERA CUOTA
				begin
					set @valor = 1
					print 'solvente, procede'
				end
				else
				begin
					print 'pendiente de pagar cuotas'

					select @prorrogas = count(1) 
					from ra_pra_prorroga_acad 
						inner join aranceles_x_evaluacion on pra_codtmo = are_codtmo
					where pra_codper = @codper and pra_codcil = @codcil and are_spaet_codigo = @evaluacion

					if @prorrogas = 0
					begin
						set @valor = 0
						print 'Estudiante sin prorroga, no procede'
					end
					else
					begin
						set @valor = 1
						print 'Estudiante posee prorroga para el periodo, procede'
					end
				end
			end
			else
			begin
				print 'pendiente de pagar cuotas de inscripcion'
				set @valor = 0
			end
		end

		select @valor as valor  
	end

	if (@opcion = 2)
	begin          
		select  @mat_prim = count(distinct tmo_arancel)
		from col_mov_movimientos 
			inner join col_dmo_det_mov on dmo_codmov = mov_codigo 
			inner join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo 
			inner join aranceles_x_evaluacion on are_codtmo = dmo_codtmo
		where mov_codper = @codper and dmo_codcil = @codcil and mov_estado <> 'A' and are_codtde = @codtde and are_spaet_codigo = 0
                               
		select @CuotasCanceladas = count(distinct tmo_arancel) --as CuotasPagadas
		from col_mov_movimientos 
			inner join col_dmo_det_mov on dmo_codmov = mov_codigo 
			inner join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo 
			inner join aranceles_x_evaluacion on are_codtmo = dmo_codtmo
		where mov_codper = @codper and dmo_codcil = @codcil and mov_estado <> 'A' and are_codtde = @codtde and are_spaet_codigo > 0

		select @prorrogas = count(1) 
		from ra_pra_prorroga_acad 
			inner join aranceles_x_evaluacion on pra_codtmo = are_codtmo
		where pra_codper = @codper and pra_codcil = @codcil and are_spaet_codigo = @evaluacion

		declare @prorrogas_anteriores int
		select @prorrogas_anteriores = count(1) 
		from ra_pra_prorroga_acad 
			inner join aranceles_x_evaluacion on pra_codtmo = are_codtmo
		where pra_codper = @codper and pra_codcil = @codcil and are_spaet_codigo = (@evaluacion -1)

		if(@prorrogas_anteriores = 0)
		begin
			if (@mat_prim = 2)
			begin
				select @respuesta = ''
				print ' Inscripcion cancelada'
				if (@CuotasCanceladas = @evaluacion)
				begin
					select @respuesta = @respuesta + ' Usted no necesita prorroga tiene todas las cuotas canceladas'
					print 'Usted no necesita prorroga tiene todas las cuotas canceladas'
					set @valor = 0
				end
				else
				begin 
					if ((@CuotasCanceladas + 1) = @evaluacion)
					begin
						print ' Verificando prorroga existente...'
						if(@prorrogas = 0)
						begin
							select @respuesta = @respuesta + ' No hay prorrogas activas' + 'Usted puede pedir prorroga'
							print ' No hay prorrogas activas'
							print ' Usted puede pedir prorroga'
							set @valor = 1
						end
						else
						begin
							set @valor = 0
							select        @respuesta = @respuesta + ' Usted tiene prorrogas existentes para esta evaluación'
							print ' Usted tiene prorrogas existentes'
						end                         
					end
					else
					begin
						set @valor = 0
						select @respuesta = @respuesta + ' Usted no ha cancelado todas las cuotas necesarias para solicitar prorroga para esta evaluación'                                                  
					end
				end
			end
			else
			begin
				select @respuesta = @respuesta + ' No ha pagado cuotas de inscripcion'
				print ' No ha pagado cuotas de inscripcion'
				set @valor = 0
			end
		end
		else
		begin
			select @respuesta =' Usted ha solicitado prorroga para la evaluacion anterior por lo que no puede solicitarla nuevamente'
			print ' Usted ha solicitado prorroga para la evaluacion anterior'
			set @valor = 0
		end

		if(@valor = 0)
		begin
			SET @respuesta = ltrim(@respuesta)
			SET @respuesta = LEFT(UPPER(@respuesta),1) + RIGHT(LOWER(@respuesta) , LEN(@respuesta)-1)
			select @respuesta as valor
		end
		else
		begin
			select @valor as valor
		end

	end

end
