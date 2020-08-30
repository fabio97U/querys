USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_insertar_pagos_x_carnet_estructurado]    Script Date: 30/8/2020 14:39:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--	exec sp_insertar_pagos_x_carnet_estructurado  '0313004000000022708590220204', 1, '999000001aasd'
ALTER procedure [dbo].[sp_insertar_pagos_x_carnet_estructurado]
--declare
	@npe varchar(50),
	@tipo int,
	@referencia varchar(50)
as
--set @npe = '0313011000000273031740220177' -- '0313011000410001201810120181' --'0313012000410001201800120181' -- '0313012000430272201600120183'-- '' -- '0313010000480015201560220172'
--set @tipo ='8'
--set @referencia='JUVE0004'
begin
	set dateformat dmy

	declare @IdGeneradoPreviaPagoOnLine int	

	declare @codper_previo int
	select @codper_previo = cast(substring(@npe,11,10) as int) --	El codper inicia en la posicion 11 del npe

	declare @arancel_especial int = 0, @npe_original varchar(80) = @npe
	if exists (select 1 from col_dao_data_otros_aranceles where dao_npe = @npe)
	begin
		print '****es arancel especial****'
		set @arancel_especial = 1
	end
	------------- Agregado para corroborar intentos de pago --------------------
    ------------------------------ Inicio --------------------------------------
	declare @carnet_previa nvarchar(15), @carnet nvarchar(15), @per_tipo nvarchar(10)
			
	print 'Verificando el tipo de estudiante'

	-- select @carnet_previa = substring(@npe,11,2) + '-' + substring(@npe,13,4) + '-' + substring(@npe,17,4)  
	select @carnet_previa = per_carnet,
		@per_tipo = per_tipo
	from ra_per_personas 
	where per_codigo = @codper_previo
	
	set @carnet = @carnet_previa

    insert into previa_pago_online (ppo_carnet, ppo_npe, ppo_tipo)
    values(@carnet_previa, @npe, @tipo)

	set @IdGeneradoPreviaPagoOnLine = scope_identity()
	print '@IdGeneradoPreviaPagoOnLine : ' + cast(@IdGeneradoPreviaPagoOnLine as nvarchar(10))
	print '-----------------------------'
    -------------------------------- Fin ---------------------------------------
    ------------- Agregado para corroborar intentos de pago --------------------


	declare @MontoPagado float, @codper_encontrado int
	set @MontoPagado = 0
	set @codper_encontrado = 0
	declare @Mensaje nvarchar(50)

	declare @alumno_encontrado tinyint
	set @alumno_encontrado = 0
	declare @CorrelativoGenerado int
	set @CorrelativoGenerado = 0

	declare @npe_valido int
	set @npe_valido = 0

	declare @portafolio_tecnicos_pre float
	set @portafolio_tecnicos_pre = 0
	
	declare @npe_mas_antiguo nvarchar(100)
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
			print 'goto saltar_validaciones'
			goto saltar_validaciones
		end

		/*Variables para el encabezado de factura */
			declare
			@mov_codreg int,
			@mov_codigo int,
			@mov_recibo int,
			@mov_codcil int,
			@mov_codper int,
			@mov_descripcion nvarchar(50),
			@mov_tipo_pago nvarchar(3),
			@mov_cheque nvarchar(20),
			@mov_estado nvarchar(3),
			@mov_tarjeta nvarchar(25),
			@mov_usuario nvarchar(30),
			@mov_codmod int,
			@mov_tipo nvarchar(3),
			@mov_historia nvarchar(3),
			@mov_codban int,
			@mov_forma_pago nvarchar(5),
			@mov_lote int, 
			@mov_puntoxpress int, 
			@mov_recibo_puntoxpress nvarchar(20),
			@mov_fecha datetime,
			@mov_fecha_registro datetime,
			@mov_fecha_cobro datetime

			declare @tmo_valor_mora float, @tmo_valor float

			set @mov_codreg = 1
			set @mov_recibo = 0
			set @mov_tipo_pago = 'B'
			set @mov_cheque = ''
			set @mov_estado = 'R'
			set @mov_tarjeta = ''
			set @mov_tipo = 'F'
			set @mov_forma_pago = 'E'
			set @mov_fecha = getdate()
			set @mov_fecha_registro = getdate()
			set @mov_fecha_cobro = getdate()
		/*Fin de variables para el encabezado de factura */


		/*Variables para el detalle de factura */
			declare
			@dmo_codreg int,
			@dmo_codmov int,
			@dmo_codigo int,
			@dmo_codtmo int,
			@dmo_cantidad int,
			@dmo_valor float,
			@dmo_codmat nvarchar(10),
			@dmo_iva float,
			@dmo_descuento float, 
			@dmo_mes int,
			@dmo_codcil int,
			@dmo_cargo float,
			@dmo_abono float,
			@dmo_eval int,
			@mov_coddip int,
			@mov_codfea int,
			@mov_codmdp int

			set @dmo_codreg = 1
			set @dmo_codmat = ''
			set @dmo_mes = 0
			set @dmo_eval = 0
			set @dmo_cantidad = 1
			set @dmo_descuento = 0
			set @mov_coddip = 0
			set @mov_codfea = 0
			set @mov_codmdp = 0
			set @mov_historia = 'N'
			set @mov_codmod = 0
		/*Fin de variables para el encabezado de factura */

		declare @corr_mov int
		declare @corr_det int
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
		set @paga_mora = 0	--	0: no paga mora
		declare @dias_vencido int

		set dateformat dmy

		declare @usuario varchar(200), 
			@banco int, @pal_codigo int,
		@descripcion varchar(200)
	
		select	@usuario = pal_usuario, 
				@banco = pal_banco, 
				@descripcion = pal_descripcion_pago, 
				@pal_codigo = pal_codigo
		from col_pal_pagos_linea
		where pal_codigo = @tipo
		set @mov_codban = @banco
		--select	*
		--from col_pal_pagos_linea
		--where pal_codigo = @tipo
		declare @lote nvarchar(10)

		select @lote = tit_lote
		from col_tit_tiraje
		where tit_tpodoc = 'F'
		and tit_mes = month(getdate())
		and tit_anio = year(getdate())
		and tit_codreg = 1 and tit_estado = 1


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
		declare @fecha_sin_mora DATE, @fecha_con_mora DATE, @monto_con_mora float, @monto_sin_mora float

		declare @DatosPago table (alumno nvarchar(80), carnet nvarchar(15), carrera nvarchar(125), npe nvarchar(30), monto float, descripcion nvarchar(125), estado int)

		declare @codtmo_descuento int, @monto_descuento float, @monto_arancel_descuento float 
		declare @pago_realizado int
		set @pago_realizado = 0

		declare @verificar_cuota_pagada int	--	Almacena si la cuota se encuentra pagada
		set @verificar_cuota_pagada = 0
		declare @arancel nvarchar(10)
		declare @TipoEstudiante nvarchar(50)


		if (@per_tipo = 'M')
		begin
			print 'Alumno es de MAESTRIAS'
			set @TipoEstudiante = 'Maestrias'
			if exists(select 1 from col_art_archivo_tal_mae_mora where npe = @npe or npe_mora = @npe)
			begin
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
					@tmo_valor = data.tmo_valor, @tmo_valor_mora = data.tmo_valor_mora, 
					@codtmo_descuento = isnull(codtmo_descuento,-1), @monto_descuento = monto_descuento, @monto_arancel_descuento = monto_arancel_descuento
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
						@tmo_valor = data.tmo_valor, @tmo_valor_mora = data.tmo_valor_mora,
						@codtmo_descuento = isnull(codtmo_descuento,-1), @monto_descuento = monto_descuento, @monto_arancel_descuento = monto_arancel_descuento
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
		end
		--SELECT * FROM col_art_archivo_tal_mora where ciclo = 116 and per_carnet = '25-0713-2016'
		--SELECT tmo_valor, tmo_arancel, tmo_valor_mora, cuota_pagar, cuota_pagar_mora, tmo_arancel_beca 
		--FROM col_art_archivo_tal_mae_mora where ciclo = 116 and per_carnet = @carnet

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
		print '@codtmo_descuento : ' + cast(@codtmo_descuento as nvarchar(15)) 
		print '@monto_descuento : ' + cast(@monto_descuento as nvarchar(15)) 
		print '@monto_arancel_descuento : ' + cast(@monto_arancel_descuento as nvarchar(15)) 
		
		print '------------------------------------------'
		--select * from col_mov_movimientos inner join col_dmo_det_mov on mov_codigo = dmo_codmov where mov_codper = @codper and dmo_codcil = @codcil and dmo_codtmo = @codtmo and mov_estado <> 'A'
		
		if isnull(@codper,0) > 0
		begin
			print 'Se encontro el codper, por lo tanto se aplicara el pago'
			set @codper_encontrado = 1

			if exists(select 1 from col_mov_movimientos inner join col_dmo_det_mov on mov_codigo = dmo_codmov 
						where mov_codper = @codper and dmo_codcil = @codcil and dmo_codtmo = @codtmo and mov_estado <> 'A')
			begin
				print '....... El pago ya existe para el estudiante en el ciclo para el arancel respectivo'
				set @CorrelativoGenerado = 0
			end		--	if exists(select 1 from col_mov_movimientos inner join col_dmo_det_mov on mov_codigo = dmo_codmov where mov_codper = @codper and dmo_codcil = @codcil and dmo_codtmo = @codtmo and mov_estado <> 'A')
			else	--	if exists(select 1 from col_mov_movimientos inner join col_dmo_det_mov on mov_codigo = dmo_codmov where mov_codper = @codper and dmo_codcil = @codcil and dmo_codtmo = @codtmo and mov_estado <> 'A')
			begin
				print '...... El arancel no esta pagado .......'
				declare @codtmo_sinbeca int, @codtmo_conbeca int

				set @mov_puntoxpress = @tipo
				set @mov_recibo_puntoxpress = @referencia

				if (@per_tipo = 'M')
				begin
					if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Maestrias' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula')
					begin
						print 'ES ARANCEL DE Matricula de Maestrias'

						PRINT '*-Almacenando el encabezado de la factura'
						select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
						select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca

						select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
						--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

						/* Insertando el encabezado de la factura*/
						exec col_efpc_EncabezadoFacturaPagoCuotas 1, 
						--select 
							@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
							@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

						PRINT '*-FIN Almacenando el encabezado de la factura'
						/* Insertando el detalle de la factura*/
						/*Almacenando el arancel de la matricula */
						PRINT '**--Almacenando el arancel de la matricula'
						select @CorrelativoGenerado = @corr_mov -- max(mov_codigo) from col_mov_movimientos 
						--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress --and mov_codigo = @corr_mov and mov_lote = @mov_lote


						set @dmo_codtmo = @codtmo_sinbeca
						set @dmo_valor = @monto_con_mora
						set @dmo_iva = 0
						set @dmo_abono = @monto_con_mora
						set @dmo_cargo = 0

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						PRINT '**--FIN Almacenando el arancel de la matricula'

						/* Almacenando el arancel que tiene el cargo del ciclo */
						PRINT '***---Almacenando el cargo del ciclo'
						set @dmo_codtmo = 162
						set @dmo_valor = 0
						--set @dmo_cargo = 825.75
						set @dmo_abono = 0

						--select @dmo_cargo = vac_SaldoAlum from ra_vac_valor_cuotas where vac_codigo = @codvac
						select @dmo_cargo = sum(tmo_valor)
						from col_art_archivo_tal_mae_mora 
						where ciclo = @codcil and per_carnet = @carnet and origen = @origen -- and fel_codvac = @codvac

			
						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						PRINT '***---FIN Almacenando el cargo del ciclo'
					end	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Maestrias' and spaet_codigo = 0 and tmo_arancel = @arancel and spaet_tipo_evaluacion like '%Matr%' and are_tipoarancel like '%Mat%' )
					else	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Maestrias' and spaet_codigo = 0 and tmo_arancel = @arancel and spaet_tipo_evaluacion like '%Matr%' and are_tipoarancel like '%Mat%' )
					begin
						print 'No es arancel de Matricula de Maestrias, son cuotas'

						if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Maestrias' and spaet_codigo > 0 and tmo_arancel = @arancel and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Evalua%')	
						begin
							print 'Pago de segunda cuota en adelante se verifica que tiene que pagar '
							set @verificar_recargo_mora = 1
						end				
						else	--	if exists(select count(1) from vst_Aranceles_x_Evaluacion where tde_nombre = 'Maestrias' and spaet_codigo > 1 and tmo_arancel = @arancel and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Evalua%')	
						begin
							print 'PRIMERA CUOTA, ESTA NO PAGA ARANCEL DE RECARGO'
						end		--	
	
						PRINT '*-Almacenando el encabezado de la factura'
						select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
						select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca
			
						select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
						--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

						/* Insertando el encabezado de la factura*/
						exec col_efpc_EncabezadoFacturaPagoCuotas 1,
						--select 
							@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
							@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

						PRINT '*-FIN Almacenando el encabezado de la factura'
						/* Insertando el detalle de la factura*/
						/*Almacenando el arancel de la matricula */
						PRINT '**--Almacenando el arancel de la cuota'
						--select @CorrelativoGenerado = max(mov_codigo) from col_mov_movimientos 
						--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress --and mov_codigo = @corr_mov and mov_lote = @mov_lote
						set @CorrelativoGenerado = @corr_mov

						set @dmo_codtmo = @codtmo_sinbeca
						set @dmo_valor = @tmo_valor --@monto_con_mora
						set @dmo_iva = 0
						set @dmo_abono = @tmo_valor --@monto_con_mora
						set @dmo_cargo = 0

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						print 'Correlativo generado en el detalle de la factura : ' + cast (@dmo_codigo as nvarchar(10))
						PRINT '**--FIN Almacenando el arancel de la cuota'

						if @arancel_beca = '-1'	--	no paga el descuento de un arancel de beca
						begin
							print 'no paga el descuento de un arancel de beca'
						end
						else	--	if @arancel_beca = '-1'	--	no paga el descuento de un arancel de beca
						begin
							if isnull(@arancel_beca,'') = ''
							begin
								print 'La cuota no posee arancel de beca, por lo tanto no se agrega otro registro en el detalle de la factura'
							end
							else	--	if isnull(@arancel_beca,'') = ''
							begin
							/* Almacenando el arancel que tiene el cargo del ciclo */
								PRINT '***---Almacenando el arancel del descuento de la beca'
								set @dmo_codtmo = @codtmo_conbeca
								set @dmo_valor = -1 * @monto_sin_mora
								set @dmo_iva = 0


								SELECT @dmo_valor = tmo_valor - cuota_pagar FROM col_art_archivo_tal_mae_mora 
								where ciclo = @codcil and per_carnet = @carnet and tmo_arancel = @arancel

								set @dmo_valor = @dmo_valor * -1
								set @dmo_abono = @dmo_valor
								set @dmo_cargo = @dmo_valor

								select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
								exec col_dfpc_DetalleFacturaPagoCuotas 1,
								--select 
								@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								set @MontoPagado = @MontoPagado + @dmo_valor
								PRINT '***---FIN Almacenando descuento de la beca'
							end		--	if isnull(@arancel_beca,'') = ''
						end	--	if @arancel_beca = '-1'	--	no paga el descuento de un arancel de beca
					end	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Maestrias' and spaet_codigo = 0 and tmo_arancel = @arancel)
				end	--	if (@per_tipo = 'M')
											--select 666643
				if @per_tipo = 'U'
				begin
					print 'Alumno de Pre grado'
					if @TipoEstudiante = 'PRE GRADO'
					begin
						if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREGRADO')
						begin
							print 'ES ARANCEL DE Matricula de Pre grado'
							PRINT '*-Almacenando el encabezado de la factura'
							select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
							select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca

							select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
							--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

							/* Insertando el encabezado de la factura*/
							exec col_efpc_EncabezadoFacturaPagoCuotas 1,
							--select 
								@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
								@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

							PRINT '*-FIN Almacenando el encabezado de la factura'
							/* Insertando el detalle de la factura*/
							/*Almacenando el arancel de la matricula */
							PRINT '**--Almacenando el arancel de la matricula'
							set @CorrelativoGenerado = @corr_mov --max(mov_codigo) from col_mov_movimientos 
							--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress --and mov_codigo = @corr_mov and mov_lote = @mov_lote

							set @dmo_codtmo = @codtmo_sinbeca
							set @dmo_valor = @monto_con_mora
							set @dmo_iva = 0
							set @dmo_abono = @monto_con_mora
							set @dmo_cargo = 0

							declare @dmo_codigo_agregar int
							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
							set @dmo_codigo_agregar = @dmo_codigo

							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
							PRINT '**--FIN Almacenando el arancel de la matricula'

							/* Almacenando el arancel que tiene el cargo del ciclo */
							PRINT '***---Almacenando el cargo del ciclo U'
							set @dmo_codtmo = 162
							set @dmo_valor = 0
							--set @dmo_cargo = 825.75
							set @dmo_abono = 0
														--select 666641

							--select @dmo_cargo = sum(vac_SaldoAlum) from ra_vac_valor_cuotas where vac_codigo = @codvac
							if exists (select 1 from ra_per_personas join col_detmen_detalle_tipo_mensualidad on per_codigo = detmen_codper where detmen_codcil = @codcil and per_carnet = @carnet)
							begin
								print 'Alumno posee descuento en las mensualidades de pregrado'
								select @dmo_cargo = sum(ISNUll(tmo_valor,0)) +sum(isnull(matricula,0))+ sum(isnull(monto_descuento,0))+ sum(isnull(monto_arancel_descuento,0))
									from col_art_archivo_tal_mora
								where ciclo = @codcil and per_carnet = @carnet /*and (isnull(monto_descuento,0) > 0 )*/ and fel_codigo_barra >= 2		--	Alumno posee descuento
								
							end
							else
							begin
								print 'Alumno no posee descuento en las mensualidades de pregrado'
								select @dmo_cargo = 
								sum(tmo_valor) + sum(isnull(monto_descuento,0)) + sum(matricula)
									from col_art_archivo_tal_mora
								where ciclo = @codcil and per_carnet = @carnet and isnull(monto_descuento,0) = 0  and fel_codigo_barra >= 2			--	Alumno no posee descuento
							end
							print '@dmo_cargo: ' + cast(@dmo_cargo as varchar)
							--select 66664
							select @dmo_cargo = matricula + @dmo_cargo
							from col_art_archivo_tal_mora
							where ciclo = @codcil and per_carnet = @carnet and fel_codigo_barra = 1

							--print '@dmo_cargo: ' + cast(@dmo_cargo as varchar(15))
							--select  @dmo_cargo
							--select * from ra_vac_valor_cuotas where vac_codigo = @codvac
							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
							PRINT '***---FIN Almacenando el cargo del ciclo U'

							--select 6666
							if exists(select 1 from col_abp_anticipo_boleta_pago where abp_codper = @codper and abp_codcil = @codcil and abp_cuota = 0 and (abp_codtmoDescuento = 408 or abp_codtmoAbono = 3586))
							begin
							
								print '+++ El alumno esta en la tabla "col_abp_anticipo_boleta_pago"'
								declare @valor_tour_utec float
								declare @valor_anticipo_matricula float

								select @valor_tour_utec = isnull(abp_montoDescuento,0), --+ isnull(abp_montoAbono,0), 
										@dmo_codtmo = abp_codtmoDescuento
								from col_abp_anticipo_boleta_pago  
								where abp_codper = @codper and abp_codcil = @codcil and abp_codtmoDescuento in (408)  -- Arancel de tour utec

								select @valor_anticipo_matricula = isnull(abp_montoAbono,0)--, --+ isnull(abp_montoAbono,0), 
										--@dmo_codtmo = abp_codtmoDescuento
								from col_abp_anticipo_boleta_pago  
								where abp_codper = @codper and abp_codcil = @codcil and abp_codtmoAbono in (3586)  -- Anticipo de Reserva de Matricula

								--select @valor_tour_utec tour, @valor_anticipo_matricula abono
								--select * from col_dmo_det_mov where dmo_codigo = @dmo_codigo
								if isnull(@valor_tour_utec,0) > 0
								begin
									--select @dmo_codigo_agregar, @dmo_codigo
									update col_dmo_det_mov set dmo_abono = dmo_abono + abs(@valor_tour_utec), dmo_valor = dmo_valor + abs(@valor_tour_utec) 
																where dmo_codigo = @dmo_codigo_agregar  and isnull(@valor_tour_utec,0) > 0
									update col_dmo_det_mov set dmo_cargo = dmo_cargo + abs(@valor_tour_utec) where dmo_codigo = @dmo_codigo  and isnull(@valor_tour_utec,0) > 0
									--select * from col_dmo_det_mov where dmo_codigo = @dmo_codigo
									set @dmo_cargo = @valor_tour_utec * -1
									set @dmo_valor = @valor_tour_utec * -1
									set @dmo_abono = @valor_tour_utec * -1

								end	--	if isnull(@valor_tour_utec,0) > 0

								if isnull(@valor_anticipo_matricula,0) > 0
								begin								
									update col_dmo_det_mov set dmo_cargo = dmo_cargo + abs(@valor_anticipo_matricula) where dmo_codigo = @dmo_codigo and isnull(@valor_anticipo_matricula,0) > 0
									--select * from col_dmo_det_mov where dmo_codigo = @dmo_codigo
								end	--	if isnull(@valor_anticipo_matricula,0) > 0

								if isnull(@valor_tour_utec,0) > 0
								begin
									select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
									exec col_dfpc_DetalleFacturaPagoCuotas 1,
								--select --* from col_dmo_det_mov
								
									@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								end	--	if isnull(@valor_tour_utec,0) > 0
							end	--	if exists(select 1 from col_abp_anticipo_boleta_pago where abp_codper = @codper and abp_codcil = @codcil and abp_cuota = 0 and (abp_codtmoDescuento = 408 or abp_codtmoAbono = 3586))

						end	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREGRADO')
						else	--	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREGRADO')
						begin
							PRINT 'SON CUOTAS DE MENSUALIDAD'
							--select @arancel
							if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREGRADO')
							begin
								print 'cuota de la segunda a la sexta cuota de pregrado, se verifica si paga recargo de pago tardio'
								set @verificar_recargo_mora = 1
							end	--	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREGRADO')
							else	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREGRADO')
							begin
								print 'Es primera cuota de mensualidad de estudiante de pregrado'
								print 'NO PAGA ARANCEL DE RECARGO'
							end		--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREGRADO')
			
							PRINT '*-Almacenando el encabezado de la factura'
							select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
							select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca
			
							select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
							--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

							/* Insertando el encabezado de la factura*/
							exec col_efpc_EncabezadoFacturaPagoCuotas 1, 
							-- select 
								@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
								@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

							PRINT '*-FIN Almacenando el encabezado de la factura'
							/* Insertando el detalle de la factura*/
							/*Almacenando el arancel de la matricula */
							PRINT '**--Almacenando el arancel de la cuota'
							select @CorrelativoGenerado = @corr_mov -- max(mov_codigo) from col_mov_movimientos 
							--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress --and mov_codigo = @corr_mov and mov_lote = @mov_lote

							set @dmo_codtmo = @codtmo_sinbeca
							set @dmo_valor = @tmo_valor --@monto_con_mora
							set @dmo_iva = 0
							set @dmo_abono = @tmo_valor --@monto_con_mora
							set @dmo_cargo = 0

							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

							declare @bandera_pago int = 0
							if @monto_descuento > 0 and @codtmo_descuento = -1 and @monto_arancel_descuento = 0
							begin
								print 'if @monto_descuento > 0 and @codtmo_descuento = -1 and @monto_arancel_descuento = 0'
								set @dmo_cargo = @monto_descuento * - 1
								set @dmo_abono = @dmo_valor

								exec col_dfpc_DetalleFacturaPagoCuotas 1,
								-- select 
								@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								set @MontoPagado = @MontoPagado + @dmo_valor	
								set @bandera_pago = 1							
							end

							if @monto_descuento = 0 and @codtmo_descuento >0 and @monto_arancel_descuento > 0
							begin
								print 'if @monto_descuento = 0 and @codtmo_descuento >0 and @monto_arancel_descuento > 0'
								set @dmo_valor = @tmo_valor + @monto_arancel_descuento
								set @dmo_cargo = 0
								set @dmo_abono = @dmo_valor

								exec col_dfpc_DetalleFacturaPagoCuotas 1,
								-- select 
								@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								set @MontoPagado = @MontoPagado + @dmo_valor	
								

								set @dmo_codtmo = @codtmo_descuento
								set @dmo_valor = @monto_arancel_descuento * -1 								
								set @dmo_cargo = @dmo_valor
								set @dmo_abono = @dmo_valor

								select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
								exec col_dfpc_DetalleFacturaPagoCuotas 1,
								-- select 
								@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								--set @MontoPagado = @MontoPagado + @dmo_valor															
							end
							else
							begin
								print 'else  if @monto_descuento = 0 and @codtmo_descuento >0 and @monto_arancel_descuento > 0'
								if @bandera_pago = 0-- Si no se a realizado el pago se realiza en este IF
								begin
									print 'if @bandera_pago = 0'
									exec col_dfpc_DetalleFacturaPagoCuotas 1,
									@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
										@dmo_eval
									set @MontoPagado = @MontoPagado + @dmo_valor
								end
							end
							PRINT '**--FIN Almacenando el arancel de la cuota'
						end	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREGRADO')
					end	--	if @TipoEstudiante = 'PRE GRADO'

					if @TipoEstudiante = 'PRE ESPECIALIDAD CARRERA'
					BEGIN
						PRINT 'alumno de la carrera de la pre especializacion'

						if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREESPECIALIDAD')
						begin
							print 'ES ARANCEL DE Matricula de Pre especialidad'
							PRINT '*-Almacenando el encabezado de la factura'
							select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
							select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca

							select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
							--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

							/* Insertando el encabezado de la factura*/
							exec col_efpc_EncabezadoFacturaPagoCuotas 1, 
							--select 
								@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
								@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

							PRINT '*-FIN Almacenando el encabezado de la factura'
							/* Insertando el detalle de la factura*/
							/*Almacenando el arancel de la matricula */
							PRINT '**--Almacenando el arancel de la matricula'
							select @CorrelativoGenerado = @corr_mov -- max(mov_codigo) from col_mov_movimientos 
							--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress --and mov_codigo = @corr_mov and mov_lote = @mov_lote

							set @dmo_codtmo = @codtmo_sinbeca
							set @dmo_valor = @monto_con_mora
							set @dmo_iva = 0
							set @dmo_abono = @monto_con_mora
							set @dmo_cargo = 0

							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
							PRINT '**--FIN Almacenando el arancel de la matricula'
							/* Almacenando el arancel que tiene el cargo del ciclo */
							PRINT '***---Almacenando el cargo del ciclo'
							set @dmo_codtmo = 162
							set @dmo_valor = 0
							--set @dmo_cargo = 825.75
							set @dmo_abono = 0


							if exists (select 1 from ra_per_personas join col_detmen_detalle_tipo_mensualidad on per_codigo = detmen_codper where detmen_codcil = @codcil and per_carnet = @carnet)
							begin
								print 'Alumno posee descuento'
								select @dmo_cargo = sum(ISNUll(tmo_valor,0)) + sum(isnull(matricula,0)) + sum(isnull(monto_descuento,0)) + sum(isnull(monto_arancel_descuento,0))
									from col_art_archivo_tal_preesp_mora
								where ciclo = @codcil and per_carnet = @carnet /*and (isnull(monto_descuento,0) > 0 )*/ and fel_orden >= 2		--	Alumno posee descuento
								
							end
							else
							begin
								print 'Alumno no posee descuento'
								select @dmo_cargo = 
								sum(tmo_valor) + sum(isnull(monto_descuento,0)) + sum(matricula)
									from col_art_archivo_tal_preesp_mora
								where ciclo = @codcil and per_carnet = @carnet and isnull(monto_descuento,0) = 0  and fel_orden >= 2			--	Alumno no posee descuento
							end
							print '@dmo_cargo: ' + cast(@dmo_cargo as varchar)

							--select @dmo_cargo = sum(vac_SaldoAlum) from ra_vac_valor_cuotas where vac_codigo = @codvac
							select @dmo_cargo =
									case when matricula = 0 then tmo_valor else matricula end + @dmo_cargo

							from col_art_archivo_tal_preesp_mora
							where ciclo = @codcil and per_carnet = @carnet and fel_orden = 0

							--select  @dmo_cargo
							--select * from ra_vac_valor_cuotas where vac_codigo = @codvac
							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
							PRINT '***---FIN Almacenando el cargo del ciclo'
						end		--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREESPECIALIDAD')
						else	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREESPECIALIDAD')
						begin
							PRINT 'SON CUOTAS DE MENSUALIDAD'
							--select @arancel
							if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREESPECIALIDAD')
							begin
								print 'cuota de la segunda a la sexta cuota de pregrado, se verifica si paga recargo de pago tardio'
								set @verificar_recargo_mora = 1
							end	--	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREESPECIALIDAD')
							else	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREESPECIALIDAD')
							begin
								print 'Es primera cuota de mensualidad de estudiante de Pre especialidad'
								print 'NO PAGA ARANCEL DE RECARGO'
							end		--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREESPECIALIDAD'))
			
							PRINT '*-Almacenando el encabezado de la factura'
							select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
							select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca
			
							select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
							--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

							/* Insertando el encabezado de la factura*/
							exec col_efpc_EncabezadoFacturaPagoCuotas 1, 
							--select 
								@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
								@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea,@mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

							PRINT '*-FIN Almacenando el encabezado de la factura'
							/* Insertando el detalle de la factura*/
							/*Almacenando el arancel de la matricula */
							PRINT '**--Almacenando el arancel de la cuota'
							select @CorrelativoGenerado = max(mov_codigo) from col_mov_movimientos 
							where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress --and mov_codigo = @corr_mov and mov_lote = @mov_lote

							set @dmo_codtmo = @codtmo_sinbeca
							set @dmo_valor = @tmo_valor --@monto_con_mora
							set @dmo_iva = 0
							set @dmo_abono = @tmo_valor --@monto_con_mora
							set @dmo_cargo = 0

							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

							declare @bandera_pago_preesp int = 0
							if @monto_descuento > 0 and @codtmo_descuento = -1 and @monto_arancel_descuento = 0
							begin
								print 'if @monto_descuento > 0 and @codtmo_descuento = -1 and @monto_arancel_descuento = 0 (cuota normal)'
								set @dmo_cargo = @monto_descuento * - 1
								set @dmo_abono = @dmo_valor

								exec col_dfpc_DetalleFacturaPagoCuotas 1,
								-- select 
								@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								set @MontoPagado = @MontoPagado + @dmo_valor	
								set @bandera_pago_preesp = 1							
							end
							
							if @monto_descuento = 0 and @codtmo_descuento >0 and @monto_arancel_descuento > 0
							begin
								print 'if @monto_descuento = 0 and @codtmo_descuento >0 and @monto_arancel_descuento > 0 (cuota con descuento)'
								set @dmo_valor = @tmo_valor + @monto_arancel_descuento
								set @dmo_cargo = 0
								set @dmo_abono = @dmo_valor

								exec col_dfpc_DetalleFacturaPagoCuotas 1,
								-- select 
								@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								set @MontoPagado = @MontoPagado + @dmo_valor	
								
								set @dmo_codtmo = @codtmo_descuento
								set @dmo_valor = @monto_arancel_descuento * -1 								
								set @dmo_cargo = @dmo_valor
								set @dmo_abono = @dmo_valor

								select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
								exec col_dfpc_DetalleFacturaPagoCuotas 1,
								-- select 
								@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								--set @MontoPagado = @MontoPagado + @dmo_valor															
							end
							else
							begin
								print 'else  if @monto_descuento = 0 and @codtmo_descuento >0 and @monto_arancel_descuento > 0 (cuota normal)'
								if @bandera_pago_preesp = 0-- Si no se a realizado el pago se realiza en este IF
								begin
									print 'if @@bandera_pago_preesp = 0'
									exec col_dfpc_DetalleFacturaPagoCuotas 1,
									@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
										@dmo_eval
									set @MontoPagado = @MontoPagado + @dmo_valor
								end
							end

							/*
							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor*/
							PRINT '**--FIN Almacenando el arancel de la cuota'
						end	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREESPECIALIDAD')
					END	--	if @TipoEstudiante = 'PRE ESPECIALIDAD CARRERA'

					if @TipoEstudiante = 'PRE TECNICO DE CARRERA DE DISENIO' 
					BEGIN
						PRINT 'alumno de CARRERA TECNICO de de la pre especializacion'
						if (@arancel = 'I-73' or @arancel = 'I-74')
						begin
							print 'es pago de matricula y primera cuota, por lo tanto, no paga mora'
							if (@arancel = 'I-73')
							begin
								print 'pago exclusivamente de la matricula'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
								select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca	
								set @dmo_cargo = 0
								set @dmo_valor = @monto_sin_mora
								set @dmo_abono = @monto_sin_mora
							end	--	if (@arancel = 'I-73')
							if (@arancel = 'I-74')
							begin
								print 'pago de la primer cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-74'
								select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-57'
								--select @dmo_valor = @portafolio_tecnicos_pre	
								set @dmo_valor = @portafolio_tecnicos_pre
								set @dmo_abono = @portafolio_tecnicos_pre
								--select @portafolio_tecnicos_pre
								select @dmo_cargo = sum(isnull(portafolio,0)) from col_art_archivo_tal_proc_grad_tec_dise_mora
								where ciclo = @codcil and per_carnet = @carnet
								set @dmo_codtmo = 1633
						--set @dmo_abono 
							end --	if (@arancel = 'I-74')
						end	--	if (@arancel = 'I-73' or @arancel = 'I-74')
						else	--	--	if (@arancel = 'I-73' or @arancel = 'I-74')
						begin
							print 'pago de la segunda cuota en adelante, se verifica si hay recargo por mora'
							set @verificar_recargo_mora = 1
							set @dmo_valor = @portafolio_tecnicos_pre
							set @dmo_abono = @portafolio_tecnicos_pre
							set @dmo_cargo = 0

							if (@arancel = 'I-75')
							begin
								print 'pago de la segunda cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-75'
								select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-58'
							end --	if (@arancel = 'I-75')
							if (@arancel = 'I-76')
							begin
								print 'pago de la tercera cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-76'
								select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-59'
							end --	if (@arancel = 'I-76')
							if (@arancel = 'I-77')
							begin
								print 'pago de la cuarta cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-77'
								select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-60'
							end --	if (@arancel = 'I-77')
							if (@arancel = 'I-78')
							begin
								print 'pago de la quinta cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-78'
								select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-61'
							end --	if (@arancel = 'I-78')
							if (@arancel = 'E-03')
							begin
								print 'Examen de seminario de graduacion'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'E-03'
							end --	if (@arancel = 'E-03')
						end	--	--	if (@arancel = 'I-73' or @arancel = 'I-74')
						--select @dmo_valor, @monto_sin_mora , @portafolio_tecnicos_pre	
						select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
						--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)
						--select @corr_mov, @codtmo_sinbeca, @codtmo_conbeca
						/* Insertando el encabezado de la factura*/

						--select 
						--	@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
						--	@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea

						exec col_efpc_EncabezadoFacturaPagoCuotas 1,
						--select 
							@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
							@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro
						print 'se inserto el encabezado de la factura'

						select @CorrelativoGenerado = @corr_mov --max(mov_codigo) from col_mov_movimientos 
						--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress --and mov_codigo = @corr_mov and mov_lote = @mov_lote

						PRINT '*-Almacenando el encabezado de la factura'

						print 'Almacenando el detalle de la factura'
						--set @dmo_codtmo = @codtmo_sinbeca
						--set @dmo_valor = @monto_con_mora
						set @dmo_iva = 0
						--set @dmo_abono = @monto_con_mora
						--set @dmo_cargo = 0

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						if (@arancel <> 'E-03')
						begin
							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
						end	--	if (@arancel <> 'E-03')
						else
						begin
							set @verificar_recargo_mora = 0
						end

						PRINT '**--FIN Almacenando el arancel de la matricula'

						/* Almacenando el arancel que tiene el cargo del ciclo */
						PRINT '***---Almacenando el cargo del ciclo'
					
						--set @dmo_valor = 0
						--set @dmo_cargo = 825.75
						--set @dmo_abono = 0

						if (@arancel = 'I-73')
						begin
							set @dmo_codtmo = 162
							select @dmo_cargo = sum(isnull(tmo_valor,0)) - sum(isnull(portafolio,0)) 
							from col_art_archivo_tal_proc_grad_tec_dise_mora
							where ciclo = @codcil and per_carnet = @carnet
							--set @dmo_cargo = 0
							set @dmo_abono = 0--@monto_sin_mora 
							set @dmo_valor = 0--@monto_sin_mora
						end

						if (@arancel = 'I-74' or @arancel = 'I-75' or @arancel = 'I-76' or @arancel = 'I-77' or @arancel = 'I-78')
						begin
							select @dmo_valor = (isnull(tmo_valor,0)) - (isnull(portafolio,0)) 
							from col_art_archivo_tal_proc_grad_tec_dise_mora 
							where ciclo = @codcil and per_carnet = @carnet and tmo_arancel = @arancel
							set @dmo_abono = @dmo_valor
							set @dmo_cargo = 0
							set @dmo_codtmo = @codtmo_sinbeca
						end

						if (@arancel = 'E-03')
						begin
							select @dmo_valor = @monto_con_mora 
							set @dmo_abono = @dmo_valor
							set @dmo_cargo = 0
							set @dmo_codtmo = @codtmo_sinbeca						
						end
						----select @dmo_cargo = sum(vac_SaldoAlum) from ra_vac_valor_cuotas where vac_codigo = @codvac
						--select @dmo_cargo = sum(tmo_valor) from col_art_archivo_tal_proc_grad_tec_dise_mora
						--where ciclo = @codcil and per_carnet = @carnet

						--select  @dmo_cargo
						--select * from ra_vac_valor_cuotas where vac_codigo = @codvac
						--set @dmo_cantidad = @portafolio_tecnicos_pre
						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						PRINT '***---FIN Almacenando el cargo del ciclo'
					END	--	if @TipoEstudiante = 'PRE TECNICO DE CARRERA DE DISENIO'
	--***
					if @TipoEstudiante = 'PRE TECNICO DE CARRERA diferente de disenio' 
					BEGIN
						PRINT 'alumno de CARRERA TECNICO diference de Diseño de de la pre especializacion'

						if (@arancel = 'I-73' or @arancel = 'I-74')
						begin
							print 'es pago de matricula y primera cuota, por lo tanto, no paga mora'
							if (@arancel = 'I-73')
							begin
								print 'pago exclusivamente de la matricula'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
								--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca	
								set @dmo_cargo = 0
								set @dmo_valor = @monto_sin_mora
								set @dmo_abono = @monto_sin_mora
							end	--	if (@arancel = 'I-73')
							if (@arancel = 'I-74')
							begin
								print 'pago de la primer cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-74'
								--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-57'
								--select @dmo_valor = @portafolio_tecnicos_pre	
								set @dmo_valor = @portafolio_tecnicos_pre
								set @dmo_abono = @portafolio_tecnicos_pre
								--select @portafolio_tecnicos_pre
								select @dmo_cargo = 0 --sum(isnull(portafolio,0)) from col_art_archivo_tal_proc_grad_tec_mora
								--where ciclo = @codcil and per_carnet = @carnet
								--set @dmo_codtmo = 1633
						--set @dmo_abono 
							end --	if (@arancel = 'I-74')
						end	--	if (@arancel = 'I-73' or @arancel = 'I-74')
						else	--	--	if (@arancel = 'I-73' or @arancel = 'I-74')
						begin
							print 'pago de la segunda cuota en adelante, se verifica si hay recargo por mora'
							set @verificar_recargo_mora = 1
							set @dmo_valor = @portafolio_tecnicos_pre
							set @dmo_abono = @portafolio_tecnicos_pre
							set @dmo_cargo = 0

							if (@arancel = 'I-75')
							begin
								print 'pago de la segunda cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-75'
								--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-58'
							end --	if (@arancel = 'I-75')
							if (@arancel = 'I-76')
							begin
								print 'pago de la tercera cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-76'
								--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-59'
							end --	if (@arancel = 'I-76')
							if (@arancel = 'I-77')
							begin
								print 'pago de la cuarta cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-77'
								--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-60'
							end --	if (@arancel = 'I-77')
							if (@arancel = 'I-78')
							begin
								print 'pago de la quinta cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-78'
								--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-61'
							end --	if (@arancel = 'I-78')
							if (@arancel = 'E-03')
							begin
								print 'Examen de seminario de graduacion'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'E-03'
							end --	if (@arancel = 'E-03')
						end	--	--	if (@arancel = 'I-73' or @arancel = 'I-74')
						--select @dmo_valor, @monto_sin_mora , @portafolio_tecnicos_pre	
						select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
						--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)
						--select @corr_mov, @codtmo_sinbeca, @codtmo_conbeca
						/* Insertando el encabezado de la factura*/

						--select 
						--	@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
						--	@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea

						exec col_efpc_EncabezadoFacturaPagoCuotas 1, 
						--select 
							@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
							@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro
						print 'se inserto el encabezado de la factura'

						select @CorrelativoGenerado = @corr_mov --max(mov_codigo) from col_mov_movimientos 
						--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress --and mov_codigo = @corr_mov and mov_lote = @mov_lote

						PRINT '*-Almacenando el encabezado de la factura'

						print 'Almacenando el detalle de la factura'
						--set @dmo_codtmo = @codtmo_sinbeca
						set @dmo_valor = @monto_sin_mora
						set @dmo_iva = 0
						set @dmo_abono = @dmo_valor
						set @dmo_cargo = 0

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						if (@arancel <> 'E-03')
						begin
							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
						end	--	if (@arancel <> 'E-03')
						else
						begin
							set @verificar_recargo_mora = 0
							set @dmo_valor = @monto_sin_mora
							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
						end

						--PRINT '**--FIN Almacenando el arancel de la matricula'

						--/* Almacenando el arancel que tiene el cargo del ciclo */
						--PRINT '***---Almacenando el cargo del ciclo'
					
						----set @dmo_valor = 0
						----set @dmo_cargo = 825.75
						----set @dmo_abono = 0

						if (@arancel = 'I-73')
						begin
							set @dmo_codtmo = 162
							select @dmo_cargo = sum(isnull(tmo_valor,0)) from col_art_archivo_tal_proc_grad_tec_mora
								where ciclo = @codcil and per_carnet = @carnet
							--set @dmo_cargo = 0
							set @dmo_abono = 0--@monto_sin_mora 
							set @dmo_valor = 0--@monto_sin_mora

							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
						end

						--if (@arancel = 'I-74' or @arancel = 'I-75' or @arancel = 'I-76' or @arancel = 'I-77' or @arancel = 'I-78')
						--begin
						--	select @dmo_valor = (isnull(tmo_valor,0)) from col_art_archivo_tal_proc_grad_tec_mora
						--	where ciclo = @codcil and per_carnet = @carnet
						--	set @dmo_abono = @dmo_valor
						--	set @dmo_cargo = 0
						--	set @dmo_codtmo = @codtmo_sinbeca
						--end

						--if (@arancel = 'E-03')
						--begin
						--	select @dmo_valor = @monto_con_mora 
						--	set @dmo_abono = @dmo_valor
						--	set @dmo_cargo = 0
						--	set @dmo_codtmo = @codtmo_sinbeca	
						--end

						----select @dmo_cargo = sum(vac_SaldoAlum) from ra_vac_valor_cuotas where vac_codigo = @codvac
						--select @dmo_cargo = sum(tmo_valor) from col_art_archivo_tal_proc_grad_tec_dise_mora
						--where ciclo = @codcil and per_carnet = @carnet

						--select  @dmo_cargo
						--select * from ra_vac_valor_cuotas where vac_codigo = @codvac
						--set @dmo_cantidad = @portafolio_tecnicos_pre
						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
						--exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						--@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
						--	@dmo_eval
						--PRINT '***---FIN Almacenando el cargo del ciclo'

					END	--	if @TipoEstudiante = 'PRE TECNICO DE CARRERA diferente de disenio'
					--****
				end		--	if @per_tipo = 'U'

				if @per_tipo = 'CE'
				begin
					print 'Verificando el alumno de Curso Especializado'
					select @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
	
					select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
					--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

					/* Insertando el encabezado de la factura*/
					exec col_efpc_EncabezadoFacturaPagoCuotas 1, 
					--select 
						@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
						@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

					PRINT '*-FIN Almacenando el encabezado de la factura'
					/* Insertando el detalle de la factura*/
					/*Almacenando el arancel de la matricula */
					PRINT '**--Almacenando el arancel de la matricula'
					select @CorrelativoGenerado = @corr_mov				

		
					set @dmo_valor = @monto_sin_mora
					set @dmo_iva = 0
					set @dmo_abono = @monto_sin_mora
					set @dmo_cargo = 0

					select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
					--select @dmo_codtmo, @codtmo
					exec col_dfpc_DetalleFacturaPagoCuotas 1,
					--select 
					@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
						@dmo_eval
					set @MontoPagado = @MontoPagado + @dmo_valor
					PRINT '**--FIN Almacenando el arancel del pago'

					if (@arancel = 'M-101') -- matricula
						begin
							print 'Matricula de curso de especializacion'
							select @dmo_cargo = sum(tmo_valor) from col_art_archivo_tal_mae_posgrado 
							where per_carnet = @carnet and ciclo = @codcil
							set @dmo_valor = 0
							set @dmo_abono = 0
							set @dmo_codtmo = 162

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						--select 999
					end	--	if (@arancel = 'M-101')
				end

				if @per_tipo = 'O'
				BEGIN
					PRINT 'alumno de los Postgrados impartidos por maestrias'

					if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Postgrados' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'POSTGRADOS MAES')
					begin
						print 'ES ARANCEL DE Matricula de Postgrado de maestrias'
						PRINT '*-Almacenando el encabezado de la factura'
						select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
						select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca

						select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
						--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

						/* Insertando el encabezado de la factura*/
						exec col_efpc_EncabezadoFacturaPagoCuotas 1, 
						--select 
							@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
							@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

						PRINT '*-FIN Almacenando el encabezado de la factura'
						/* Insertando el detalle de la factura*/
						/*Almacenando el arancel de la matricula */
						PRINT '**--Almacenando el arancel de la matricula'
						select @CorrelativoGenerado = @corr_mov --max(mov_codigo) from col_mov_movimientos 
						--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress --and mov_codigo = @corr_mov and mov_lote = @mov_lote

						set @dmo_codtmo = @codtmo_sinbeca
						set @dmo_valor = @monto_con_mora
						set @dmo_iva = 0
						set @dmo_abono = @monto_con_mora
						set @dmo_cargo = 0

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						PRINT '**--FIN Almacenando el arancel de la matricula'

						/* Almacenando el arancel que tiene el cargo del ciclo */
						PRINT '***---Almacenando el cargo del ciclo'
						set @dmo_codtmo = 162
						set @dmo_valor = 0
						--set @dmo_cargo = 825.75
						set @dmo_abono = 0

						--select @dmo_cargo = sum(vac_SaldoAlum) from ra_vac_valor_cuotas where vac_codigo = @codvac
						select @dmo_cargo = sum(tmo_valor) from col_art_archivo_tal_mae_posgrado
						where ciclo = @codcil and per_carnet = @carnet

						--select  @dmo_cargo
						--select * from ra_vac_valor_cuotas where vac_codigo = @codvac
						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						PRINT '***---FIN Almacenando el cargo del ciclo'
					end		--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Postgrados' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'POSTGRADOS MAES')
					else	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Postgrados' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'POSTGRADOS MAES')
					begin
						PRINT 'SON CUOTAS DE MENSUALIDAD'
						--select @arancel
						if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Postgrados' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'POSTGRADOS MAES')			          
						begin
							print 'cuota de la segunda a la sexta cuota de pregrado, se verifica si paga recargo de pago tardio'
							set @verificar_recargo_mora = 1
						end	--	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Postgrados' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'POSTGRADOS MAES')			          
						else	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Postgrados' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'POSTGRADOS MAES')			          
						begin
							print 'Es primera cuota de mensualidad de estudiante de Postgrados de Maestrias'
							print 'NO PAGA ARANCEL DE RECARGO'
						end		--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Postgrados' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'POSTGRADOS MAES')			          
			
						PRINT '*-Almacenando el encabezado de la factura'
						select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
						select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca
			
						select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
						--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

						/* Insertando el encabezado de la factura*/
						exec col_efpc_EncabezadoFacturaPagoCuotas 1, 
						--select 
							@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
							@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

						PRINT '*-FIN Almacenando el encabezado de la factura'
						/* Insertando el detalle de la factura*/
						/*Almacenando el arancel de la matricula */
						PRINT '**--Almacenando el arancel de la cuota'
						select @CorrelativoGenerado = @corr_mov --max(mov_codigo) from col_mov_movimientos 
						--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress --and mov_codigo = @corr_mov and mov_lote = @mov_lote

						set @dmo_codtmo = @codtmo_sinbeca
						set @dmo_valor = @tmo_valor --@monto_con_mora
						set @dmo_iva = 0
						set @dmo_abono = @tmo_valor --@monto_con_mora
						set @dmo_cargo = 0

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						PRINT '**--FIN Almacenando el arancel de la cuota'
					end	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREESPECIALIDAD')
				END	--	if @TipoEstudiante = 'POST GRADOS de MAESTRIAS'

				if @verificar_recargo_mora = 1	--	verifica si pagar recargo
				begin
					print 'de segunda a sexta cuota, se evalua si paga o no recargo'

					set @dias_vencido = 0
					set @dias_vencido = DATEDIFF(dd, CONVERT(CHAR(10), @fecha_sin_mora, 103) , CONVERT(CHAR(10), getdate(), 103))
					print '@dias_vencido : ' + cast(@dias_vencido as nvarchar(10))
					--select @dias_vencido as dias_vencido			

					if (@dias_vencido > 0)
					begin
						print 'esta vencido, por lo tanto, se verifica si las cuotas son las mismas'
						if @monto_sin_mora = @monto_con_mora 
						begin
							print 'las cuotas es lo mismo, por lo tanto no paga mora'
							set @monto = @monto_sin_mora
							set @paga_mora = 0
						end
						else	--	if @monto_sin_mora = @monto_con_mora 
						begin
							print 'la cuota con mora y sin mora es diferente, por lo tanto se paga recargo de mora'
							set @monto = @monto_con_mora
							set @paga_mora = 1
						end	--	if @monto_sin_mora = @monto_con_mora 
					end
					else	--	if (@dias_vencido > 0)
					begin
						print 'No paga el recargo de mora porque no esta vencido'
						set @monto = @monto_sin_mora
						set @paga_mora = 0
					end	--	if (@dias_vencido > 0)	
					--select @paga_mora
					if @paga_mora = 1
					begin
						--	select tmo_codigo, tmo_valor from col_tmo_tipo_movimiento where tmo_arancel = 'A-88'
						set @codtmo = 88
						set @monto = 10 
						/*Almacenando el arancel del recargo de pago extraordinario */
						PRINT '**--Almacenando el arancel del recargo de pago extraordinario '
						select @dmo_codmov = max(mov_codigo) from col_mov_movimientos 
						where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress

						set @dmo_codtmo = @codtmo
						set @dmo_valor = @monto
						set @dmo_iva = 0
						set @dmo_abono = @monto
						set @dmo_cargo = @monto

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						PRINT '**--FIN Almacenando el arancel del recargo de pago extraordinario '
					end	--	if @paga_mora = 1
				end	--	if exists(select count(1) from vst_Aranceles_x_Evaluacion where tde_nombre = 'Maestrias' and spaet_codigo = 1 and tmo_arancel = @arancel)


			end		--	if exists(select 1 from col_mov_movimientos inner join col_dmo_det_mov on mov_codigo = dmo_codmov where mov_codper = @codper and dmo_codcil = @codcil and dmo_codtmo = @codtmo and mov_estado <> 'A')
			print '@codtmo_sinbeca : ' + cast(@codtmo_sinbeca as nvarchar(10))
			print '@codtmo_conbeca : ' + cast(@codtmo_conbeca as nvarchar(10))

			--select * from col_mov_movimientos where mov_codper = 196586 and mov_codcil = 116 and mov_codigo in (5281547, 5269003)
			--select * from col_mov_movimientos where mov_codper = 193592 and mov_codcil = 116-- and mov_codigo in (5281547, 5269003)
		
			print '@MontoPagado: ' + cast(@MontoPagado as nvarchar(10))
			insert into col_pagos_en_linea_estructuradoSP (codper, carnet, NumFactura, formapago, lote, MontoFactura, npe, TipoEstudiante, codppo ) 
			values (@codper, @carnet, @CorrelativoGenerado, @tipo, @lote, @MontoPagado, @npe, @TipoEstudiante, @IdGeneradoPreviaPagoOnLine)
			
			--select * from col_mov_movimientos where mov_codper = @codper
			--select * from col_dmo_det_mov where dmo_codmov in (select mov_codigo from col_mov_movimientos where mov_codper = @codper)
		
		end	--	if isnull(@codper,0) > 0
		else	--	if isnull(@codper,0) > 0
		begin
			set @Mensaje = 'Por alguna razon no se encontro el codper del estudiante'
			print 'Por alguna razon no se encontro el codper del estudiante'
			set @codper_encontrado = 0 
		end	--	if isnull(@codper,0) > 0

	-- 1: Exito registro de forma correcta el pago
		saltar_validaciones: 
		if @arancel_especial = 1 --Es un pago de arancel especial
		begin
			declare @respuesta int = 0, @codpboa int
			select @codpboa = dao_coddpboa, @codcil = dao_codcil, @codper = dao_codper 
			from col_dao_data_otros_aranceles where dao_npe = @npe_original
			select @respuesta = dbo.fn_cumple_parametros_boleta_otros_aranceles(@codpboa, @codcil,-1, @codper)

			if @respuesta = 0--el arancel especial no tiene ninguna restriccion para el pago
			begin
				--select 'IF -;;;;;;;;;;;'
				print 'if @arancel_especial = 1 '
				print '@npe_original: ' + cast(@npe_original as varchar(64))
				print '@tipo: ' + cast(@tipo as varchar(20))
				print '@referencia: ' + cast(@referencia as varchar(20))
				
				declare @codmov_generado int;  
				execute dbo.sp_insertar_encabezado_pagos_online_otros_aranceles_estructurado @npe_original, @tipo, @referencia, @mov_codigo_generado = @codmov_generado output

				--select @codmov_generado
				select '1' resultado, @codmov_generado Correlativo, 'Transacción generada de forma satisfactoria' as Descripcion-- from @tbl_res_inse
			end
			else
			begin
				--select 'ELSE -;;;;;;;;;;;'
				-- @respuesta puede tener los siguientes resultados para aranceles especiales
				-- 1:NO EXISTE EL ARANCEL, 0: todo bien, 1: cupo acabado, 2: fecha vencimiento vencio, 3: fuera del periodo (fecha_desde a fecha_hasta), 4: CUOTAS PENDIENTES
				-- pero se omiten y se manda como resultado 2 que para este procedimiento es igual a 'No se pudo generar la transacción'
				print '***@respuesta de pagos de otros aranceles: ***' + cast(@respuesta as varchar(5))
				-- Como está actualmente el alumno no sabe por qué se rechazó el pago del arancel, contactar con “los puntos en línea” para que estén preparados para recibir dichos resultados de otros aranceles
				select '2' resultado, -1 as Correlativo, 'No se pudo generar la transacción' as Descripcion
			end
		end	--	if @arancel_especial = 1 --Es un pago de arancel especial

		else	--	if @arancel_especial = 1 --Es un pago de arancel especial
		begin
			if @codper_encontrado = 0 
			begin
				set @Mensaje = 'Intentar realizar nuevamente la transacción'
				select '-2' resultado, @CorrelativoGenerado as Correlativo, 'Intentar realizar nuevamente la transacción' as Descripcion
			end		--	if @codper_encontrado = 0 
			else	--	if @codper_encontrado = 0 
			begin
				if @npe_valido = 0
				begin
					set @Mensaje = 'NPE no existe ...' 
					select '-1' resultado, @CorrelativoGenerado as Correlativo, 'NPE no existe ...' as Descripcion
				end	--	if @npe_valido = 0
				else
				begin
					if @CorrelativoGenerado = 0
					begin
						set @Mensaje = 'La cuota ya estaba cancelada con anterioridad' 
						select '0' resultado, @CorrelativoGenerado as Correlativo, 'La cuota ya estaba cancelada con anterioridad' as Descripcion
					end
					else	--	if @CorrelativoGenerado = 0
					begin
						select '1' resultado, @CorrelativoGenerado as Correlativo, 'Transacción generada de forma satisfactoria' as Descripcion
					end		--	if @CorrelativoGenerado = 0
				end
			end	--	if @codper_encontrado = 0 

		end	--	if @arancel_especial = 1 --Es un pago de arancel especial


	COMMIT TRANSACTION -- O solo COMMIT


	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION -- O solo ROLLBACK
    
		insert into col_ert_error_transaccion(ert_codper, ert_npe, ert_ciclo,ert_message,ert_numer,ert_severity,ert_state,ert_procedure,ert_line)
		values(@per_codigo, @npe, @cil_codigo,ERROR_MESSAGE() + ' ,' + @Mensaje,ERROR_NUMBER(),ERROR_severity(),error_state(),ERROR_procedure(),ERROR_line())
		
		select '2' resultado, -1 as Correlativo, 'No se pudo generar la transacción' as Descripcion
		-- 2: Error algun dato incorrecto no guardo ningun cambio

	END CATCH

end