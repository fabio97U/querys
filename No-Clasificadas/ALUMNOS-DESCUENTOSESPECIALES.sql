USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[tal_GenerarDataTalonariosPreGrado_TomandoMensualidadConDescuentos]    Script Date: 17/11/2020 21:57:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:		<Fabio Ramos, Juan Campos>
	-- Create date: <Lunes 6 de Julio de 2020>
	-- Description:	<Migra los descuentos especiales hacia otros ciclo y le genera la data de boleta de pago>
	-- =============================================

	-- exec tal_GenerarDataTalonariosPreGrado_TomandoMensualidadConDescuentos 2, 125, 0 --(cambiar codvac a los alumnos prebio a ejecutar) 
		 																			    --Migra los alumnos con segunda carrera a la tabla dfal
	-- exec tal_GenerarDataTalonariosPreGrado_TomandoMensualidadConDescuentos 1, 125, 0 --Genera la data de los alumnos con mensualidades especiales
	   
	-- exec tal_GenerarDataTalonariosPreGrado_TomandoMensualidadConDescuentos 4, 125, 189701 --Migra el alumno con segunda carrera a la tabla dfal
	-- exec tal_GenerarDataTalonariosPreGrado_TomandoMensualidadConDescuentos 3, 125, 189701 --Genera la data del alumno con mensualidades especiales


ALTER PROCEDURE [dbo].[tal_GenerarDataTalonariosPreGrado_TomandoMensualidadConDescuentos]
	@opcion int = 0,
	@codcil_generarboleta int = 0,
	@codper int = 0
AS
BEGIN
	set dateformat dmy

	declare @cil_codigo int, @per_codigo int, @tipmen_codigo int
	declare @usr_codigo int = 378
	
	declare @codper_nuevacarrera int, @codvac int, @cild_codigo int

	--INICIO: Para VARIOS alumnos
	if @opcion = 1	-- Alumnos con Descuentos a futuro
	begin
		declare m_cursor cursor 
		for
			select cil_codigo, dfal_codper, dfal_codtipmen 
			from ra_cild_ciclos_descuentos 
				inner join ra_cil_ciclo on cil_codigo = cild_codcil 
				inner join col_dfal_descuentos_futuro_alumnos on cild_codigo = dfal_codcild
			where cil_codigo = @codcil_generarboleta-- and dfal_codper = 111587
			and dfal_codper not in (
				--select art.per_codigo from col_art_archivo_tal_mora art where art.per_codigo = dfal_codper and art.ciclo = @codcil_generarboleta
				--union all
				select art2.per_codigo from col_art_archivo_tal_preesp_mora art2 where art2.per_codigo = dfal_codper
				union all
				select art3.per_codigo from col_art_archivo_tal_proc_grad_tec_dise_mora art3 where art3.per_codigo = dfal_codper
				union all
				select art4.per_codigo from col_art_archivo_tal_proc_grad_tec_mora art4 where art4.per_codigo = dfal_codper
			)
			order by dfal_codper
		open m_cursor 
 
		fetch next from m_cursor into @cil_codigo, @per_codigo, @tipmen_codigo

 		while @@FETCH_STATUS = 0 
		begin
			--select @cil_codigo, @per_codigo, @tipmen_codigo
			print '--------------------------'
			print '@per_codigo : ' + cast(@per_codigo as nvarchar(12))

			--Inserta a la detmen
			exec dbo.tal_GeneraDataTalonario_alumnos_tipo_mensualidad_especial @opcion = 4, @codcilGenerar = @cil_codigo, 
			@codper = @per_codigo, @codusr = @usr_codigo, @codtipmen = @tipmen_codigo

			--Genera las boletas
			exec dbo.tal_GeneraDataTalonario_alumnos_tipo_mensualidad_especial @opcion = 1, @codcilGenerar = @cil_codigo, @codper = @per_codigo

			fetch next from m_cursor into @cil_codigo, @per_codigo, @tipmen_codigo
		end      
		close m_cursor  
		deallocate m_cursor
	end	--	if @opcion = 1

	if @opcion = 2	-- Migra a la dfal los alumnos con descuento de segunda carrera
	begin
		select @cild_codigo = cild_codigo from ra_cild_ciclos_descuentos where cild_codcil = @codcil_generarboleta and cild_codcil > 0

		if (isnull(@cild_codigo, 0) <> 0)--Si ya existe un ciclo "codcil" definido para la tabla cild
		begin
			declare @tbl_res as table (res int)
			declare m_cursor cursor 
			for
				select sca_codper_nuevacarrera, per_codvac/*, per_carnet*/ 
				from ra_sca_segunda_carrera
				inner join ra_per_personas per on per_codigo = sca_codper_nuevacarrera
				where per_estado not in ('G', 'I') and per_tipo = 'U'
				and per.per_codigo not in (
					--select art.per_codigo from col_art_archivo_tal_mora art where art.per_codigo = per.per_codigo and art.ciclo = @codcil_generarboleta
					--union all
					select art2.per_codigo from col_art_archivo_tal_preesp_mora art2 where art2.per_codigo = per.per_codigo
					union all
					select art3.per_codigo from col_art_archivo_tal_proc_grad_tec_dise_mora art3 where art3.per_codigo = per.per_codigo
					union all
					select art4.per_codigo from col_art_archivo_tal_proc_grad_tec_mora art4 where art4.per_codigo = per.per_codigo
				)
				order by sca_codper_nuevacarrera
			open m_cursor 
 
			fetch next from m_cursor into @codper_nuevacarrera, @codvac

 			while @@FETCH_STATUS = 0 
			begin
				--select @codper_nuevacarrera, @codvac
				print '--------------------------'
				print '@codper_nuevacarrera : ' + cast(@codper_nuevacarrera as nvarchar(12))
			
				select @tipmen_codigo = tipmen_codigo from col_tipmen_tipo_mensualidad 
				inner join col_tmp_tipo_mensualidad_con_politicas on tmp_codtipmen = tipmen_codigo
				inner join col_dpd_definicion_politica_descuento on dpd_codigo = tmp_coddpd
				inner join ra_vac_valor_cuotas on vac_codigo = tipmen_codvac
				where tipmen_codvac = @codvac and dpd_codigo = 1--DESCUENTO POR SEGUNDA CARRERA
				--select @codper_nuevacarrera, @codvac, @tipmen_codigo
				
				--Borra de la tabla dfal
				insert into @tbl_res (res)
				exec sp_col_dfal_descuentos_futuro_alumnos @opcion = 2, @habilitado = 0, @codcild = @cild_codigo, @codper = @codper_nuevacarrera

				--Inserta en dfal
				insert into @tbl_res (res)
				exec dbo.sp_col_dfal_descuentos_futuro_alumnos @opcion = 2, @codcild = @cild_codigo, @codper = @codper_nuevacarrera,
				@codtipmen = @tipmen_codigo, @codusr = @usr_codigo, @habilitado = 1
				-- 1: Insertado a la dfal, 0: No insertado en dfal porque ya existe o ya no se le permite el descuento

				fetch next from m_cursor into @codper_nuevacarrera, @codvac
			end      
			close m_cursor  
			deallocate m_cursor
		end
		select sum(res) 'migrados_a_dfal' from @tbl_res where res >= 0
	end--if @opcion = 2
	--FIN: Para VARIOS alumnos
	

	--INICIO: Para un alumno

	if @opcion = 3	-- Alumno con Descuento a futuro
	begin
		declare m_cursor cursor 
		for
			select cil_codigo, dfal_codper, dfal_codtipmen 
			from ra_cild_ciclos_descuentos inner join ra_cil_ciclo on
				cil_codigo = cild_codcil inner join col_dfal_descuentos_futuro_alumnos on
				cild_codigo = dfal_codcild 
			where cil_codigo = @codcil_generarboleta  and dfal_codper = @codper
			order by dfal_codper
		open m_cursor 

		fetch next from m_cursor into @cil_codigo, @per_codigo, @tipmen_codigo

 		while @@FETCH_STATUS = 0 
		begin
			--select @cil_codigo, @per_codigo, @tipmen_codigo
			print '--------------------------'
			print '@per_codigo : ' + cast(@per_codigo as nvarchar(12))

			exec dbo.tal_GeneraDataTalonario_alumnos_tipo_mensualidad_especial @opcion = 4, @codcilGenerar = @cil_codigo, 
			@codper = @per_codigo, @codusr = @usr_codigo, @codtipmen = @tipmen_codigo

			exec dbo.tal_GeneraDataTalonario_alumnos_tipo_mensualidad_especial @opcion = 1, @codcilGenerar = @cil_codigo, @codper = @per_codigo

			fetch next from m_cursor into @cil_codigo, @per_codigo, @tipmen_codigo
		end      
		close m_cursor  
		deallocate m_cursor
	end	--	if @opcion = 1

	if @opcion = 4	-- Migra a la dfal el alumno con descuento de segunda carrera
	begin
		select @cild_codigo = cild_codigo from ra_cild_ciclos_descuentos where cild_codcil = @codcil_generarboleta and cild_codcil > 0

		if (isnull(@cild_codigo, 0) <> 0)--Si ya existe un ciclo "codcil" definido para la tabla cild
		begin
			declare m_cursor cursor 
			for
				select  sca_codper_nuevacarrera, per_codvac/*, per_carnet*/ 
				from ra_sca_segunda_carrera
				inner join ra_per_personas on per_codigo = sca_codper_nuevacarrera
					where per_estado not in ('G', 'I') and per_tipo = 'U' and sca_codper_nuevacarrera = @codper
				order by sca_codper_nuevacarrera
			open m_cursor 
 
			fetch next from m_cursor into @codper_nuevacarrera, @codvac

 			while @@FETCH_STATUS = 0 
			begin
				--select @codper_nuevacarrera, @codvac
				print '--------------------------'
				print '@codper_nuevacarrera : ' + cast(@codper_nuevacarrera as nvarchar(12))
			
				select @tipmen_codigo = tipmen_codigo from col_tipmen_tipo_mensualidad 
				inner join col_tmp_tipo_mensualidad_con_politicas on tmp_codtipmen = tipmen_codigo
				inner join col_dpd_definicion_politica_descuento on dpd_codigo = tmp_coddpd
				inner join ra_vac_valor_cuotas on vac_codigo = tipmen_codvac
				where tipmen_codvac = @codvac and dpd_codigo = 1--DESCUENTO POR SEGUNDA CARRERA

				delete from col_dfal_descuentos_futuro_alumnos where dfal_codper = @codper and dfal_codcild in (
					select isnull(cild_codigo, 0) from ra_cild_ciclos_descuentos where cild_codcil = @codcil_generarboleta
				)

				--Inserta en dfal
				exec dbo.sp_col_dfal_descuentos_futuro_alumnos @opcion = 2, @codcild = @cild_codigo, @codper = @codper_nuevacarrera,
				@codtipmen = @tipmen_codigo, @codusr = @usr_codigo, @habilitado = 1
				-- 1: Insertado a la dfal, 0: No insertado en dfal porque ya existe o ya no se le permite el descuento

				fetch next from m_cursor into @codper_nuevacarrera, @codvac
			end      
			close m_cursor  
			deallocate m_cursor
		end
	end--if @opcion = 4
	--FIN: Para un alumno
END
