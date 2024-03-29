USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_col_daapl_datos_alu_pago_linea_estructurado]    Script Date: 13/1/2021 19:08:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec sp_col_daapl_datos_alu_pago_linea_estructurado '0313 0030 0000 0017 3322 9012 0215'

ALTER procedure [dbo].[sp_col_daapl_datos_alu_pago_linea_estructurado]
--declare
	@npe varchar(100)
as
begin
	set dateformat dmy
	declare @monto_npe float
	set @monto_npe = 0
	declare @alumno_encontrado tinyint
	set @alumno_encontrado = 0
	declare @CorrelativoGenerado int
	set @CorrelativoGenerado = 0

	set @npe = replace(@npe, ' ', '')

	declare @npe_valido int
	set @npe_valido = 0

	declare @portafolio_tecnicos_pre float
	set @portafolio_tecnicos_pre = 0

	declare @arancel_especial int = 0, @npe_original varchar(64) = @npe
	if exists (select 1 from col_dao_data_otros_aranceles where dao_npe = @npe)
	begin
		print '****es arancel especial****'
		set @arancel_especial = 1
	end

	declare @codper_previo int
	select @codper_previo = cast(substring(@npe,11,10) as int) --	El codper inicia en la posicion 11 del npe
	print '@codper_previo : ' + cast(@codper_previo as nvarchar(10))

	declare @carnet_previa nvarchar(15), @carnet nvarchar(15), @per_tipo nvarchar(10)


	declare --@carnet nvarchar(15), 
		@npe_mas_antiguo nvarchar(100)

	select @carnet = per_carnet,
		@per_tipo = per_tipo
	from ra_per_personas 
	where per_codigo = @codper_previo

	--select @carnet = substring(@npe,11,2) + '-' + substring(@npe,13,4) + '-' + substring(@npe,17,4)  	
	
	print 'NPE Ingresado : ' + @npe

	-- Tabla donde se obtiene el NPE mas antiguo, para evitar que el estudiante pague cuotas "salteadas"
	declare @temp table (
		alumno varchar(150),
		carnet varchar(20),
		carrera varchar(150),
		npe nvarchar(50),
		monto varchar(15),
		descripcion varchar(250),
		estado varchar(2),
		tmo_arancel nvarchar(10),
		fel_fecha_mora nvarchar(10),
		ciclo int,
		mciclo nvarchar(10)
	)
	insert into @temp 
	exec sp_consulta_pago_x_carnet_estructurado 2, @carnet

	print '----- NPE Obtenido mas antiguo segun la fecha de pago : ' 
	select @npe_mas_antiguo = npe from @temp
	print @npe_mas_antiguo

	if @npe = @npe_mas_antiguo
	begin
		print 'Es el mismo NPE que quiere pagar el estudiante'
	end
	else
	begin
		set @npe = @npe_mas_antiguo
		print 'Es NPE es diferente, se asigno el mas antiguo para que se pague por el estudiante'
	end
	print '---------------------------------------------------------'


	BEGIN TRANSACTION -- O solo BEGIN TRAN
	BEGIN TRY
		
		if @arancel_especial = 1
		begin
			print '****goto saltar_validaciones****'
			goto saltar_validaciones
		end

		declare @verificar_recargo_mora int
		set @verificar_recargo_mora = 0	--	0 no paga mora
		declare @monto float
		set @monto = 0
			-- *********************************************************************************************************************************
			-- Definimos quien hara los pagos segun configuracion de tabla
		declare @opcion tinyint

		declare @fecha_vencimiento datetime
		--set @referencia = '000003'
		--set @opcion = 1	--	Verifica si el pago se realizo
		set @opcion = 2	--	Inserta el pago

		--declare @validar_mora int
		--set @validar_mora = 0	--	0 = no paga mora, 1 = paga mora

		declare @paga_mora tinyint
		set @paga_mora = 0	--	no paga mora es CERO
		declare @dias_vencido int

		set dateformat dmy

			--set @npe = '0313012000410230201600120178'
		--set @npe = '0313010000430272201630120173'
		 --set @npe = '0313010000430272201640120171'
		 --set @npe = '0313012000000268031610220161'
		--set @npe = '0313012000000242031610220162'
		--set @npe = '0313010000000270031670220168'
		--set @npe = '0313007100311996201060120174'
		--set @npe = '0313012000115749199990120171'  -- pre especialidad
		--set @npe = '0313011075600687200510120175' -- pre tecnico DISENIO
		--set @npe = '0313010000000123031730120175' -- posgrado
		--set @npe = '0313010000000123031720120177'-- posgrado
		--set @npe = '0313007500293126201670220173' --	pregrado guillermo

		declare @corr int, @cil_codigo int, @per_codigo int
		declare @codper int, @codtmo int, @codcil int, @origen int, @codvac int
		declare @carrera nvarchar(100), @arancel_beca nvarchar(10), @nombre nvarchar(100), @descripcion_arancel nvarchar(100), 
			@npe_sin_mora nvarchar(75), @npe_con_mora nvarchar(75)
		declare @fecha_sin_mora DATE, @fecha_con_mora DATE, @monto_con_mora float, @monto_sin_mora float, @tmo_valor_mora float, @tmo_valor float

		declare @DatosPago table (alumno nvarchar(80), carnet nvarchar(15), carrera nvarchar(125), npe nvarchar(30), monto float, descripcion nvarchar(125), estado int)

		declare @pago_realizado int
		set @pago_realizado = 0

		declare @verificar_cuota_pagada int	--	Almacena si la cuota se encuentra pagada
		set @verificar_cuota_pagada = 0
		declare @arancel nvarchar(10)
		declare @TipoEstudiante nvarchar(50)

		--select @carnet = substring(@npe,11,2) + '-' + substring(@npe,13,4) + '-' + substring(@npe,17,4)  

		print 'Verificando el tipo de estudiante'
		select @per_tipo = per_tipo from ra_per_personas where per_carnet = @carnet

		if (@per_tipo = 'M')
		begin
			print 'Alumno es de MAESTRIAS'
			set @TipoEstudiante = 'Maestrias'
			if exists(select 1 from col_art_archivo_tal_mae_mora where npe = @npe or npe_mora = @npe)
			begin
				set @alumno_encontrado = 1
				select @codper = data.per_codigo, @codtmo = tmo.tmo_codigo, @arancel = tmo.tmo_arancel, @codcil = data.ciclo, @carnet = data.per_carnet,
					@carrera = data.pla_alias_carrera, @nombre = data.per_nombres_apellidos, @monto_con_mora = data.cuota_pagar_mora,
					@monto_sin_mora = data.cuota_pagar, @fecha_sin_mora = data.fel_fecha, @fecha_con_mora = data.fel_fecha_mora, @descripcion_arancel = tmo.tmo_descripcion,
					@npe_sin_mora = npe, @npe_con_mora = npe_mora, @origen = origen, @arancel_beca = isnull(tmo_arancel_beca,'-1'), @codvac = isnull(fel_codvac,-1),
					@tmo_valor = data.tmo_valor, @tmo_valor_mora = data.tmo_valor_mora
				from col_art_archivo_tal_mae_mora as data inner join col_tmo_tipo_movimiento as tmo on 
					tmo.tmo_arancel = data.tmo_arancel
				where npe = @npe or npe_mora = @npe
				set @npe_valido = 1
			end	--	if exists(select 1 from col_art_archivo_tal_mae_mora where npe = @npe or npe_mora = @npe)
		end	--	if (@per_tipo = 'M')

		if (@per_tipo = 'O') or (@per_tipo = 'CE')
		begin
			if @per_tipo = 'O'
			begin
				set @TipoEstudiante = 'POST GRADOS de MAESTRIAS'
			end
			if @per_tipo = 'CE'
			begin
				set @TipoEstudiante = 'CURSO ESPECIALIZADO de MAESTRIAS'
			end

			if exists(select 1 from col_art_archivo_tal_mae_posgrado where npe = @npe or npe_mora = @npe)
			begin
				set @alumno_encontrado = 1
				select @codper = data.per_codigo, @codtmo = tmo.tmo_codigo, @arancel = tmo.tmo_arancel, @codcil = data.ciclo, @carnet = data.per_carnet,
					@carrera = data.pla_alias_carrera, @nombre = data.per_nombres_apellidos, @monto_con_mora = data.cuota_pagar_mora,
					@monto_sin_mora = data.cuota_pagar, @fecha_sin_mora = data.fel_fecha, @fecha_con_mora = data.fel_fecha_mora, @descripcion_arancel = tmo.tmo_descripcion,
					@npe_sin_mora = npe, @npe_con_mora = npe_mora, @origen = -1, @arancel_beca = '-1', @codvac = -1,
					@tmo_valor = data.tmo_valor, @tmo_valor_mora = data.tmo_valor_mora
				from col_art_archivo_tal_mae_posgrado as data inner join col_tmo_tipo_movimiento as tmo on 
					tmo.tmo_arancel = data.tmo_arancel
				where npe = @npe or npe_mora = @npe
				set @npe_valido = 1
			end	--	if exists(select 1 from col_art_archivo_tal_mae_posgrado where npe = @npe or npe_mora = @npe)
		end	--	if (@per_tipo = 'O') or (@per_tipo = 'CE')

		if (@per_tipo = 'U')
		begin
			print 'Alumno es de PRE-GRADO'
	
			if exists(select 1 from col_art_archivo_tal_mora where npe = @npe or npe_mora = @npe)
			begin
				set @npe_valido = 1
				set @alumno_encontrado = 1
				set @TipoEstudiante = 'PRE GRADO'
				select @codper = data.per_codigo, @codtmo = tmo.tmo_codigo, @arancel = tmo.tmo_arancel, @codcil = data.ciclo, @carnet = data.per_carnet,
					@carrera = data.pla_alias_carrera, @nombre = data.per_nombres_apellidos, @monto_con_mora = data.tmo_valor_mora,
					@monto_sin_mora = data.tmo_valor, @fecha_sin_mora = data.fel_fecha, @fecha_con_mora = data.fel_fecha_mora, @descripcion_arancel = tmo.tmo_descripcion,
					@npe_sin_mora = npe, @npe_con_mora = npe_mora, @origen = -1, @arancel_beca = '-1', @codvac = -1,
					@tmo_valor = data.tmo_valor, @tmo_valor_mora = data.tmo_valor_mora
				from col_art_archivo_tal_mora as data inner join col_tmo_tipo_movimiento as tmo on 
					tmo.tmo_arancel = data.tmo_arancel
				where npe = @npe or npe_mora = @npe
			end	--	if exists(select 1 from col_art_archivo_tal_mora where npe = @npe or npe_mora = @npe)

			if @alumno_encontrado = 0
			begin
				if exists(select 1 from col_art_archivo_tal_preesp_mora where npe = @npe or npe_mora = @npe)
				begin
					set @npe_valido = 1
					set @alumno_encontrado = 1
					set @TipoEstudiante = 'PRE ESPECIALIDAD CARRERA'
					select @codper = data.per_codigo, @codtmo = tmo.tmo_codigo, @arancel = tmo.tmo_arancel, @codcil = data.ciclo, @carnet = data.per_carnet,
						@carrera = data.pla_alias_carrera, @nombre = data.per_nombres_apellidos, @monto_con_mora = data.tmo_valor_mora,
						@monto_sin_mora = data.tmo_valor, @fecha_sin_mora = data.fel_fecha, @fecha_con_mora = data.fel_fecha_mora, @descripcion_arancel = tmo.tmo_descripcion,
						@npe_sin_mora = npe, @npe_con_mora = npe_mora, @origen = -1, @arancel_beca = '-1', @codvac = -1,
						@tmo_valor = data.tmo_valor, @tmo_valor_mora = data.tmo_valor_mora
					from col_art_archivo_tal_preesp_mora as data inner join col_tmo_tipo_movimiento as tmo on 
						tmo.tmo_arancel = data.tmo_arancel
					where npe = @npe or npe_mora = @npe
				end	--	if exists(select 1 from col_art_archivo_tal_preesp_mora where npe = @npe or npe_mora = @npe)
			end	--	if @alumno_encontrado = 0

			if @alumno_encontrado = 0
			begin
				if exists(select 1 from col_art_archivo_tal_proc_grad_tec_dise_mora where npe = @npe or npe_mora = @npe)
				begin
					set @npe_valido = 1
					set @alumno_encontrado = 1
					set @TipoEstudiante = 'PRE TECNICO DE CARRERA DE DISENIO'
					select @codper = data.per_codigo, @codtmo = tmo.tmo_codigo, @arancel = tmo.tmo_arancel, @codcil = data.ciclo, @carnet = data.per_carnet,
						@carrera = data.pla_alias_carrera, @nombre = data.per_nombres_apellidos, @monto_con_mora = data.tmo_valor_mora,
						@monto_sin_mora = data.tmo_valor, @fecha_sin_mora = data.fel_fecha, @fecha_con_mora = data.fel_fecha_mora , @descripcion_arancel = tmo.tmo_descripcion,
						@npe_sin_mora = npe, @npe_con_mora = npe_mora, @origen = -1, @arancel_beca = '-1', @codvac = -1,
						@tmo_valor = data.tmo_valor, @tmo_valor_mora = data.tmo_valor_mora,

						@portafolio_tecnicos_pre = isnull(portafolio,0)
					from col_art_archivo_tal_proc_grad_tec_dise_mora as data inner join col_tmo_tipo_movimiento as tmo on 
						tmo.tmo_arancel = data.tmo_arancel
					where npe = @npe or npe_mora = @npe
				end	--	if exists(select 1 from col_art_archivo_tal_proc_grad_tec_dise_mora where npe = @npe or npe_mora = @npe)
			end	--	if @alumno_encontrado = 0		

			if @alumno_encontrado = 0
			begin
				if exists(select 1 from col_art_archivo_tal_proc_grad_tec_mora where npe = @npe or npe_mora = @npe)
				begin
					set @npe_valido = 1
					set @alumno_encontrado = 1
					set @TipoEstudiante = 'PRE TECNICO DE CARRERA diferente de disenio'
					select @codper = data.per_codigo, @codtmo = tmo.tmo_codigo, @arancel = tmo.tmo_arancel, @codcil = data.ciclo, @carnet = data.per_carnet,
						@carrera = data.pla_alias_carrera, @nombre = data.per_nombres_apellidos, @monto_con_mora = data.tmo_valor_mora,
						@monto_sin_mora = data.tmo_valor, @fecha_sin_mora = data.fel_fecha, @fecha_con_mora = data.fel_fecha_mora, @descripcion_arancel = tmo.tmo_descripcion,
						@npe_sin_mora = npe, @npe_con_mora = npe_mora, @origen = -1, @arancel_beca = '-1', @codvac = -1,
						@tmo_valor = data.tmo_valor, @tmo_valor_mora = data.tmo_valor_mora,

						@portafolio_tecnicos_pre = 0
					from col_art_archivo_tal_proc_grad_tec_mora as data inner join col_tmo_tipo_movimiento as tmo on 
						tmo.tmo_arancel = data.tmo_arancel
					where npe = @npe or npe_mora = @npe
				end	--	if exists(select 1 from col_art_archivo_tal_proc_grad_tec_dise_mora where npe = @npe or npe_mora = @npe)
			end	--	if @alumno_encontrado = 0	

			--select top 3 * from col_art_archivo_tal_mora
		end	--	if per_tipo = 'U'

		print '@codper : ' + cast(@codper as nvarchar(10))
		print '@carnet : ' + @carnet
		print '@codtmo : ' + cast(@codtmo as nvarchar(10))
		print '@codcil : ' + cast(@codcil as nvarchar(10))
		print '@arancel : ' + @arancel
		print '@arancel_beca : ' + @arancel_beca
		print '@nombre : ' + @nombre
		print '@monto_con_mora : ' + cast(@monto_con_mora as nvarchar(15))
		print '@monto_sin_mora : ' + cast(@monto_sin_mora as nvarchar(15))
		print '@fecha_sin_mora  : ' + cast(@fecha_sin_mora  as nvarchar(15))
		print '@fecha_con_mora  : ' + cast(@fecha_con_mora  as nvarchar(15))
		print '@descripcion_arancel  : ' + @descripcion_arancel
		print '@npe_sin_mora :' + @npe_sin_mora
		print '@npe_con_mora :' + @npe_con_mora
		print '@origen : ' + cast(@origen as nvarchar(4))
		print '@codvac : ' + cast(@codvac as nvarchar(4))
		print '@TipoEstudiante : ' + @TipoEstudiante
		print '@per_tipo : ' + @per_tipo
		print '------------------------------------------'
		set @dias_vencido = DATEDIFF(dd, CONVERT(CHAR(10), @fecha_sin_mora, 103) , CONVERT(CHAR(10), getdate(), 103))
		print '@dias_vencido: ' + cast(@dias_vencido as nvarchar(10))

		select @monto_npe = case when @dias_vencido > 0 then @monto_con_mora
								when @dias_vencido < 0 then @monto_sin_mora
								else @monto_sin_mora
		end

		select @npe = 
			case when @dias_vencido > 0 then @npe_con_mora
								when @dias_vencido < 0 then @npe_sin_mora
								else @npe_sin_mora
			end

		if exists(select 1 from col_mov_movimientos inner join col_dmo_det_mov on mov_codigo = dmo_codmov 
					where mov_codper = @codper and dmo_codcil = @codcil and dmo_codtmo = @codtmo and mov_estado <> 'A')
		begin
			print '....... El pago ya existe para el estudiante en el ciclo para el arancel respectivo'
			select 'Pago antes efectuado' as alumno, '' as carnet, 'Pago antes efectuado' as carrera,  0 as Monto, 'Pago antes efectuado' as descripcion, 0 as estado
		end		--	if exists(select 1 from col_mov_movimientos inner join col_dmo_det_mov on mov_codigo = dmo_codmov where mov_codper = @codper and dmo_codcil = @codcil and dmo_codtmo = @codtmo and mov_estado <> 'A')
		else	--	if exists(select 1 from col_mov_movimientos inner join col_dmo_det_mov on mov_codigo = dmo_codmov where mov_codper = @codper and dmo_codcil = @codcil and dmo_codtmo = @codtmo and mov_estado <> 'A')
		begin
			saltar_validaciones: 
			if @arancel_especial = 1
			begin
				print '****if @arancel_especial = 1****'
				select top 1 per_nombres_apellidos alumno, per_carnet carnet, pla_alias_carrera carrera, 
				tmo_valor Monto, tmo_descripcion descripcion, 1 estado, @npe_original NPE from col_dao_data_otros_aranceles 
				inner join ra_per_personas on per_codigo = dao_codper
				inner join ra_alc_alumnos_carrera on per_codigo = alc_codper
				inner join ra_pla_planes on pla_codigo = alc_codpla
				inner join col_dpboa_definir_parametro_boleta_otros_aranceles on dpboa_codigo = dao_coddpboa
				inner join col_tmo_tipo_movimiento on tmo_codigo = dpboa_codtmo
				where dao_npe = @npe_original order by dao_fecha_creacion desc
			end
			else
			begin
				if @alumno_encontrado = 1
				begin 
					select @nombre as alumno, @carnet as carnet, @carrera as carrera, @monto_npe as Monto, @descripcion_arancel as descripcion, 1 as estado, @npe as NPE
				end
				else
				begin
					if @npe_valido = 0
					begin
						select 'NPE no Existe' as alumno, @carnet as carnet, 'NPE no Existe' as carrera,  0 as Monto, 'NPE no Existe' as descripcion, -1 as estado, @npe as NPE
					end	--	if @npe_valido = 0
				end
			end
		end
	COMMIT TRANSACTION -- O solo COMMIT

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION -- O solo ROLLBACK 
		select 'No se pudo generar' as alumno, '' as carnet, 'No se pudo generar' as carrera,  0 as Monto, 'No se pudo generar' as descripcion, -2 as estado, @npe as NPE
	END CATCH
end