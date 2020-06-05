--select * from ade_activar_desactivar_evaluaciones
--delete from ade_activar_desactivar_evaluaciones
--dbcc checkident (ade_activar_desactivar_evaluaciones, reseed,0)
--insert into ade_activar_desactivar_evaluaciones (ade_eval, ade_fecha_inicio, ade_fecha_fin) values (1, '2020-01-21 00:00:00.000', '2020-03-09 00:00:00.000'), (2, '2020-03-10 00:00:00.000', '2020-04-16 00:00:00.000'), (3, '2020-04-17 00:00:00.000', '2020-05-09 00:00:00.000'), (4, '2020-05-10 00:00:00.000', '2020-05-31 00:00:00.000'), (5, '2020-06-01 00:00:00.000', '2020-06-14 00:00:00.000')

--select * from ra_Tramites_academicos_online
--insert into ra_Tramites_academicos_online (trao_nombre, trao_tipo, trao_estado, trao_posee_arancel) values ('Retiro de Ciclo', 'Pre grado', 'Activo', 1), ('Retiro de Asignaturas', 'Pre grado', 'Activo', 1)
create table ra_ctao_cuotas_tramites_academicos_online(
    ctao_codigo int identity(1,1) primary key,
    ctao_codtrao int FOREIGN KEY REFERENCES ra_Tramites_academicos_online(trao_codigo),
    ctao_cuotas int,
    ctao_codcil int FOREIGN KEY REFERENCES ra_cil_ciclo(cil_codigo),
    ctao_estado char(1),
    ctao_fecha_creacion datetime default getdate()
)
--select * from ra_ctao_cuotas_tramites_academicos_online
--delete from ra_ctao_cuotas_tramites_academicos_online
--dbcc checkident (ra_ctao_cuotas_tramites_academicos_online, reseed,0)
--insert into ra_ctao_cuotas_tramites_academicos_online (ctao_codtrao, ctao_cuotas, ctao_codcil, ctao_estado) values (7, 3, 122, 'A'), (6, 3, 122, 'A')

--insert into col_dpboa_definir_parametro_boleta_otros_aranceles (dpboa_codtmo, dpboa_afecta_materia, dpboa_cupo_vencimiento, dpboa_fecha_vencimiento, dpboa_periodo, dpboa_fecha_desde, dpboa_fecha_hasta, dpboa_estado, dpboa_afecta_evaluacion, dpboa_codta, dpboa_coddtde, dpboa_cuotas_pendientes, dpbos_solvencia_biblioteca) values
--(854, 0, 0, NULL, 1, '18/03/2020',	'16/04/2020',	1, 0, 2, 1, 1, 1), 
--(854, 0, 0, NULL, 1, '18/03/2020',	'16/04/2020',	1, 0, 2, 2, 1, 1), 
--(853, 0, 0, NULL, 1, '17/03/2020',	'10/05/2020',	1, 0, 2, 1, 1, 0), 
--(853, 0, 0, NULL, 1, '17/03/2020',	'10/05/2020',	1, 0, 2, 2, 1, 0), 
--(909, 0, 0, NULL, 0, 'NULL',       'NULL',         1, 1, 2, 1, 1, 0), 
--(909, 0, 0, NULL, 0, 'NULL',       'NULL',         1, 0, 2, 2, 1, 0)
--select * from col_dpboa_definir_parametro_boleta_otros_aranceles where dpboa_estado = 1

--select * from ra_traar_tramites_aranceles_online
--insert into ra_traar_tramites_aranceles_online (traar_codtrao, traar_codtmo) values(6, 854), (6, 880), (7, 852), (7, 853), (1, 909)

-- =============================================
-- Author:      <Fabio>
-- Create date: <2020-03-12 14:27:36.347>
-- Description: <Generar la data de las boletas de pago de alumnos con mensualidad especiales en el 
-- mismo momento de inserción del alumno en la tabla "col_detmen_detalle_tipo_mensualidad">
-- =============================================
-- tal_GeneraDataTalonario_alumnos_tipo_mensualidad_especial 1, 1, 122, 181324 --pregrado
-- tal_GeneraDataTalonario_alumnos_tipo_mensualidad_especial 1, 1, 122, 180168 --preespecialidad
ALTER procedure [dbo].[tal_GeneraDataTalonario_alumnos_tipo_mensualidad_especial]
	@opcion int = 0,
	@codreg int = 0,
	@codcilGenerar int = 0,
	@codper int = 0
as
begin

	if @opcion = 1 --Genera la data talonario alumno mensualidades especiales, la crea en el mismo momento de ingreso del alumno
	begin
		declare @per_estado varchar(5)
		select @per_estado = per_estado from ra_per_personas where per_codigo = @codper

		if @per_estado = 'E' --Es egresado
		begin
			print 'Es egresado'
			delete from col_art_archivo_tal_preesp_mora where per_codigo = @codper
			exec tal_GenerarDataTalonarioPreEspecialidad_PorAlumno_Especial 2, 1, @codcilGenerar, @codper -- Inserta la data para los talonarios preespecialidad
		end

		else if @per_estado = 'A' --Es de pregrado
		begin
			print 'Es de pregrado'
			delete from col_art_archivo_tal_mora where per_codigo = @codper
			exec tal_GenerarDataTalonarioPreGrado_porAlumno_Especial 2, 1, @codcilGenerar, @codcilGenerar, @codper-- Inserta la data para los talonarios pregrado
		end
	end

	if @opcion = 2
	begin
		delete from col_detmen_detalle_tipo_mensualidad where detmen_codper = @codper
	end
end
go

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
							PRINT '***---Almacenando el cargo del ciclo U'
							set @dmo_codtmo = 162
							set @dmo_valor = 0
							--set @dmo_cargo = 825.75
							set @dmo_abono = 0

							--select @dmo_cargo = sum(vac_SaldoAlum) from ra_vac_valor_cuotas where vac_codigo = @codvac
							if exists (select 1 from ra_per_personas join col_detmen_detalle_tipo_mensualidad on per_codigo = detmen_codper where detmen_codcil = @codcil and per_carnet = @carnet)
							begin
								print 'Alumno posee descuento'
								select @dmo_cargo = sum(ISNUll(tmo_valor,0)) +sum(isnull(matricula,0))+ sum(isnull(monto_descuento,0))+ sum(isnull(monto_arancel_descuento,0))
									from col_art_archivo_tal_mora
								where ciclo = @codcil and per_carnet = @carnet /*and (isnull(monto_descuento,0) > 0 )*/ and fel_codigo_barra >= 2		--	Alumno posee descuento
								
							end
							else
							begin
								print 'Alumno no posee descuento'
								select @dmo_cargo = 
								sum(tmo_valor) + sum(isnull(monto_descuento,0)) + sum(matricula)
									from col_art_archivo_tal_mora
								where ciclo = @codcil and per_carnet = @carnet and isnull(monto_descuento,0) = 0  and fel_codigo_barra >= 2			--	Alumno no posee descuento
							end
							print '@dmo_cargo: ' + cast(@dmo_cargo as varchar)

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
							PRINT '***SON CUOTAS DE MENSUALIDAD'
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

		saltar_validaciones: 
		if @arancel_especial = 1 --Es un pago de arancel especial
		begin
			declare @respuesta int = 0, @codpboa int
			select @codpboa = dao_coddpboa, @codcil = dao_codcil, @codper = dao_codper 
			from col_dao_data_otros_aranceles where dao_npe = @npe_original
			select @respuesta = dbo.fn_cumple_parametros_boleta_otros_aranceles(@codpboa, @codcil,-1, @codper)

			if @respuesta = 0--el arancel especial no tiene ninguna restriccion para el pago
			begin
				print 'if @arancel_especial = 1 '
				print '@npe_original: ' + cast(@npe_original as varchar(64))
				print '@tipo: ' + cast(@tipo as varchar(20))
				print '@referencia: ' + cast(@referencia as varchar(20))
			
				declare @codmov_generado int;  
				execute dbo.sp_insertar_encabezado_pagos_online_otros_aranceles_estructurado @npe_original, @tipo, @referencia, @mov_codigo_generado = @codmov_generado output;  
				--select @codmov_generado
				select '1' resultado, @codmov_generado Correlativo, 'Transacción generada de forma satisfactoria' as Descripcion-- from @tbl_res_inse
			end
			else
			begin
				-- @respuesta puede tener los siguientes resultados para aranceles especiales
				-- 1:NO EXISTE EL ARANCEL, 0: todo bien, 1: cupo acabado, 2: fecha vencimiento vencio, 3: fuera del periodo (fecha_desde a fecha_hasta), 4: CUOTAS PENDIENTES
				-- pero se omiten y se manda como resultado 2 que para este procedimiento es igual a 'No se pudo generar la transacción'
				print '***@respuesta de pagos de otros aranceles: ***' + cast(@respuesta as varchar(5))
				-- Como está actualmente el alumno no sabe por qué se rechazó el pago del arancel, contactar con “los puntos en línea” para que estén preparados para recibir dichos resultados de otros aranceles
				select '2' resultado, -1 as Correlativo, 'No se pudo generar la transacción' as Descripcion
			end
		end
		else
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
		-- 1: Exito registro de forma correcta el pago
		end
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

-- =============================================
-- Author:		<Adones, Calles>
-- Create date: <2019-04-12 16:17:00.750>
-- Description:	<Description,,>
-- =============================================
--sp_mensualidades_descuento_aranceles 1, '', 0, '', 0,0,0,0
ALTER PROCEDURE [dbo].[sp_mensualidades_descuento_aranceles]
	@opcion int,
	@tpmenara_arancel nvarchar(10) = '',
	@tpmenara_monto_pagar numeric(18,2) = 0.0,
	@tpmenara_arancel_descuento nvarchar(10) = '',
	@tpmenara_monto_arancel_descuento numeric(18,2) = 0.0,
	@tpmenara_codtipmen int = 0,
	@tpmenara_codigo int = 0,
	@tpmenara_monto_descuento numeric(18,2) = 0.0,
	@busqueda nvarchar(150) = '',
	@tpmenara_valor_mora numeric(18,2) = 0.0
as
begin

	if @opcion = 1
	begin
		select tpmenara_codigo,rtrim(tpmenara_arancel) tpmenara_arancel,tipmen_tipo,tpmenara_monto_pagar,tpmenara_arancel_descuento,
		tpmenara_monto_arancel_descuento,tpmenara_codtipmen,
		concat(tpmenara_arancel,' - ', tmo_descripcion,' ( ',isnull(tpmenara_monto_pagar,'0.0'),' )') descrip, tpmenara_monto_descuento,
		are_tipo, tpmenara_valor_mora
		from col_tpmenara_tipo_mensualidad_aranceles 
		left join col_tipmen_tipo_mensualidad on tipmen_codigo = tpmenara_codtipmen 
		left join vst_Aranceles_x_Evaluacion on tmo_arancel = tpmenara_arancel
		where tipmen_estado = 1 and (
			tpmenara_codigo like '%' + case when isnull(ltrim(rtrim(@busqueda)), '') = '' then ''                        
			else ltrim(rtrim(@busqueda)) + '%' end                        
			or tpmenara_arancel like '%' + case when isnull(ltrim(rtrim(@busqueda)), '') = '' then '' 
			else ltrim(rtrim(@busqueda)) + '%' end                    
			or tipmen_tipo like '%' + case when isnull(ltrim(rtrim(@busqueda)), '') = '' then '' 
			else ltrim(rtrim(@busqueda)) + '%' end
			or tpmenara_monto_pagar like '%' + case when isnull(ltrim(rtrim(@busqueda)), '') = '' then ''
			else ltrim(rtrim(@busqueda)) + '%' end or
			tpmenara_arancel_descuento like '%' + case when isnull(ltrim(rtrim(@busqueda)), '') = '' then ''
			else ltrim(rtrim(@busqueda)) + '%' end  or
			tmo_descripcion like '%' + case when isnull(ltrim(rtrim(@busqueda)), '') = '' then ''
			else ltrim(rtrim(@busqueda)) + '%' end  or
			are_tipo like '%' + case when isnull(ltrim(rtrim(@busqueda)), '') = '' then ''
			else ltrim(rtrim(@busqueda)) + '%' end
		) --and tpmenara_codigo = 192
	end

	if @opcion = 2
	begin
		if not exists (select 1 from col_tpmenara_tipo_mensualidad_aranceles where tpmenara_arancel= @tpmenara_arancel and tpmenara_codtipmen=@tpmenara_codtipmen )
		begin
			insert into col_tpmenara_tipo_mensualidad_aranceles (tpmenara_arancel,tpmenara_monto_pagar,tpmenara_arancel_descuento,tpmenara_monto_arancel_descuento,tpmenara_codtipmen, tpmenara_monto_descuento, tpmenara_valor_mora)
			values (upper(@tpmenara_arancel),@tpmenara_monto_pagar, upper(@tpmenara_arancel_descuento),@tpmenara_monto_arancel_descuento,@tpmenara_codtipmen, @tpmenara_monto_descuento, @tpmenara_valor_mora)
			select 1 res --agregado
		end
		else
		begin
			select 0 res--ya existe
		end
	end

	if @opcion = 3
		begin
	--	if not exists (select 1 from col_tpmenara_tipo_mensualidad_aranceles where tpmenara_arancel=@tpmenara_arancel and tpmenara_codtipmen=@tpmenara_codtipmen and tpmenara_arancel_descuento = @tpmenara_arancel_descuento )
		--	begin
				update col_tpmenara_tipo_mensualidad_aranceles 
					set tpmenara_arancel =upper(@tpmenara_arancel) ,
					tpmenara_monto_pagar =@tpmenara_monto_pagar,
					tpmenara_arancel_descuento = upper(@tpmenara_arancel_descuento),
					tpmenara_monto_arancel_descuento=@tpmenara_monto_arancel_descuento,
					tpmenara_monto_descuento = @tpmenara_monto_descuento,
					tpmenara_codtipmen=@tpmenara_codtipmen,
					tpmenara_valor_mora = @tpmenara_valor_mora
				where tpmenara_codigo =@tpmenara_codigo
		end
end

-- =============================================
-- Author:      <>
-- Create date: <>
-- Last modify: Fabio, 2020-03-28 12:27:10.037
-- Description: <Realiza la validacion si existe el NPE ingresado por el alumno en el portalpag>
-- =============================================
-- exec validar_NPE_boleta 180168,122,'0313006300000018016850120207' --Cuota
-- exec validar_NPE_boleta 180168,122,'0313001800000018016890120205'-- Arancel especial
ALTER PROCEDURE [dbo].[validar_NPE_boleta]
	@codper int,
	@codcil int,
	@npe nvarchar(28)
AS
BEGIN
	SET NOCOUNT ON;
	
	select c.tmo_codigo,per_codigo, per_carnet, b.tmo_arancel, b.tmo_valor, 'U' as per_tipo, 0 as Mora ,isnull(((select '2' from col_mov_movimientos  
	join col_dmo_det_mov on dmo_codmov=mov_codigo 
	join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
	where mov_codper=@codper and dmo_codcil=@codcil and a.tmo_arancel =b.tmo_arancel and mov_estado <> 'A'
	)),'1') Estado
	from col_art_archivo_tal_mora b
	join col_tmo_tipo_movimiento c on b.tmo_arancel=c.tmo_arancel
	where per_codigo = @codper and ciclo = @codcil and npe = @npe

	union
	select c.tmo_codigo,per_codigo, per_carnet, b.tmo_arancel, b.tmo_valor_mora as tmo_valor, 'U' as per_tipo, 1 as Mora,isnull(((select '2' from col_mov_movimientos  
	join col_dmo_det_mov on dmo_codmov=mov_codigo 
	join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
	where mov_codper=@codper and dmo_codcil=@codcil and a.tmo_arancel =b.tmo_arancel and mov_estado <> 'A'
	)),'1') Estado
	from col_art_archivo_tal_mora b
	join col_tmo_tipo_movimiento c on b.tmo_arancel=c.tmo_arancel
	where per_codigo = @codper and ciclo = @codcil and npe_mora = @npe and not exists(
	select 1 from col_mov_movimientos  
	join col_dmo_det_mov on dmo_codmov=mov_codigo 
	join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
	where mov_codper=@codper and dmo_codcil=@codcil and a.tmo_arancel =b.tmo_arancel and mov_estado <> 'A'
	)

	union
	select c.tmo_codigo,per_codigo, per_carnet, b.tmo_arancel, b.tmo_valor, 'E' as per_tipo, 0 as Mora,isnull(((select '2' from col_mov_movimientos  
	join col_dmo_det_mov on dmo_codmov=mov_codigo 
	join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
	where mov_codper=@codper and dmo_codcil=@codcil and a.tmo_arancel =b.tmo_arancel and mov_estado <> 'A'
	)),'1') Estado
	from col_art_archivo_tal_proc_grad_tec_mora b
	join col_tmo_tipo_movimiento c on b.tmo_arancel=c.tmo_arancel
	where per_codigo = @codper and ciclo = @codcil and npe = @npe 

	union
	select c.tmo_codigo,per_codigo, per_carnet, b.tmo_arancel, b.tmo_valor_mora as tmo_valor, 'E' as per_tipo, 1 as Mora,isnull(((select '2' from col_mov_movimientos  
	join col_dmo_det_mov on dmo_codmov=mov_codigo 
	join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
	where mov_codper=@codper and dmo_codcil=@codcil and a.tmo_arancel =b.tmo_arancel and mov_estado <> 'A'
	)),'1') Estado
	from col_art_archivo_tal_proc_grad_tec_mora b
	join col_tmo_tipo_movimiento c on b.tmo_arancel=c.tmo_arancel
	where per_codigo = @codper and ciclo = @codcil and npe_mora = @npe and not exists(
	select 1 from col_mov_movimientos  
	join col_dmo_det_mov on dmo_codmov=mov_codigo 
	join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
	where mov_codper=@codper and dmo_codcil=@codcil and a.tmo_arancel =b.tmo_arancel and mov_estado <> 'A'
	)

	union
	select c.tmo_codigo,per_codigo, per_carnet, b.tmo_arancel, b.tmo_valor, 'E' as per_tipo, 0 as Mora,isnull(((select '2' from col_mov_movimientos  
	join col_dmo_det_mov on dmo_codmov=mov_codigo 
	join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
	where mov_codper=@codper and dmo_codcil=@codcil and a.tmo_arancel =b.tmo_arancel and mov_estado <> 'A'
	)),'1') Estado
	from col_art_archivo_tal_proc_grad_tec_dise_mora b
	join col_tmo_tipo_movimiento c on b.tmo_arancel=c.tmo_arancel
	where per_codigo = @codper and ciclo = @codcil and npe = @npe 

	union
	select c.tmo_codigo,per_codigo, per_carnet, b.tmo_arancel, b.tmo_valor_mora as tmo_valor, 'E' as per_tipo, 1 as Mora,isnull(((select '2' from col_mov_movimientos  
	join col_dmo_det_mov on dmo_codmov=mov_codigo 
	join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
	where mov_codper=@codper and dmo_codcil=@codcil and a.tmo_arancel =b.tmo_arancel and mov_estado <> 'A'
	)),'1') Estado
	from col_art_archivo_tal_proc_grad_tec_dise_mora b
	join col_tmo_tipo_movimiento c on b.tmo_arancel=c.tmo_arancel
	where per_codigo = @codper and ciclo = @codcil and npe_mora = @npe and not exists(
	select 1 from col_mov_movimientos  
	join col_dmo_det_mov on dmo_codmov=mov_codigo 
	join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
	where mov_codper=@codper and dmo_codcil=@codcil and a.tmo_arancel =b.tmo_arancel and mov_estado <> 'A'
	)

	union
	select c.tmo_codigo,per_codigo, per_carnet, b.tmo_arancel, b.tmo_valor, 'E' as per_tipo, 0 as Mora,isnull(((select '2' from col_mov_movimientos  
	join col_dmo_det_mov on dmo_codmov=mov_codigo 
	join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
	where mov_codper=@codper and dmo_codcil=@codcil and a.tmo_arancel =b.tmo_arancel and mov_estado <> 'A'
	)),'1') Estado
	from col_art_archivo_tal_preesp_mora b
	join col_tmo_tipo_movimiento c on b.tmo_arancel=c.tmo_arancel
	where per_codigo = @codper and ciclo = @codcil and npe = @npe

	union
	select c.tmo_codigo,per_codigo, per_carnet, b.tmo_arancel, b.tmo_valor_mora as tmo_valor, 'E' as per_tipo, 1 as Mora,isnull(((select '2' from col_mov_movimientos  
	join col_dmo_det_mov on dmo_codmov=mov_codigo 
	join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
	where mov_codper=@codper and dmo_codcil=@codcil and a.tmo_arancel =b.tmo_arancel and mov_estado <> 'A'
	)),'1') Estado
	from col_art_archivo_tal_preesp_mora b
	join col_tmo_tipo_movimiento c on b.tmo_arancel=c.tmo_arancel
	where per_codigo = @codper and ciclo = @codcil and npe_mora = @npe and not exists(
	select 1 from col_mov_movimientos  
	join col_dmo_det_mov on dmo_codmov=mov_codigo 
	join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
	where mov_codper=@codper and dmo_codcil=@codcil and a.tmo_arancel =b.tmo_arancel and mov_estado <> 'A'
	)

	union
	select c.tmo_codigo,per_codigo, per_carnet, b.tmo_arancel, cuota_pagar as tmo_valor, 'M' as per_tipo, 0 as Mora,isnull(((select '2' from col_mov_movimientos  
	join col_dmo_det_mov on dmo_codmov=mov_codigo 
	join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
	where mov_codper=@codper and dmo_codcil=@codcil and a.tmo_arancel =b.tmo_arancel and mov_estado <> 'A'
	)),'1') Estado
	from col_art_archivo_tal_mae_mora b
	join col_tmo_tipo_movimiento c on b.tmo_arancel=c.tmo_arancel
	where per_codigo = @codper and ciclo = @codcil and npe = @npe and not exists(
	select 1 from col_mov_movimientos  
	join col_dmo_det_mov on dmo_codmov=mov_codigo 
	join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
	where mov_codper=@codper and dmo_codcil=@codcil and a.tmo_arancel =b.tmo_arancel and mov_estado <> 'A'
	)

	union
	select c.tmo_codigo,per_codigo, per_carnet, b.tmo_arancel, cuota_pagar_mora as tmo_valor, 'M' as per_tipo, 1 as Mora,isnull(((select '2' from col_mov_movimientos  
	join col_dmo_det_mov on dmo_codmov=mov_codigo 
	join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
	where mov_codper=@codper and dmo_codcil=@codcil and a.tmo_arancel =b.tmo_arancel and mov_estado <> 'A'
	)),'1') Estado
	from col_art_archivo_tal_mae_mora b
	join col_tmo_tipo_movimiento c on b.tmo_arancel=c.tmo_arancel
	where per_codigo = @codper and ciclo = @codcil and npe_mora = @npe and not exists(
	select 1 from col_mov_movimientos  
	join col_dmo_det_mov on dmo_codmov=mov_codigo 
	join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
	where mov_codper=@codper and dmo_codcil=@codcil and a.tmo_arancel =b.tmo_arancel and mov_estado <> 'A'
	)

	union
	select c.tmo_codigo,per_codigo, per_carnet, b.tmo_arancel, cuota_pagar as tmo_valor, 'O' as per_tipo, 0 as Mora,isnull(((select '2' from col_mov_movimientos  
	join col_dmo_det_mov on dmo_codmov=mov_codigo 
	join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
	where mov_codper=@codper and dmo_codcil=@codcil and a.tmo_arancel =b.tmo_arancel and mov_estado <> 'A'
	)),'1') Estado
	from col_art_archivo_tal_mae_posgrado b 
	join col_tmo_tipo_movimiento c on b.tmo_arancel=c.tmo_arancel
	where per_codigo = @codper and ciclo = @codcil and npe = @npe and not exists(
	select 1 from col_mov_movimientos  
	join col_dmo_det_mov on dmo_codmov=mov_codigo 
	join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
	where mov_codper=@codper and dmo_codcil=@codcil and a.tmo_arancel =b.tmo_arancel and mov_estado <> 'A'
	)

	union
	select c.tmo_codigo,per_codigo, per_carnet, b.tmo_arancel, cuota_pagar_mora as tmo_valor, 'O' as per_tipo, 1 as Mora,isnull(((select '2' from col_mov_movimientos  
	join col_dmo_det_mov on dmo_codmov=mov_codigo 
	join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
	where mov_codper=@codper and dmo_codcil=@codcil and a.tmo_arancel =b.tmo_arancel and mov_estado <> 'A'
	)),'1') Estado
	from col_art_archivo_tal_mae_posgrado b
	join col_tmo_tipo_movimiento c on b.tmo_arancel=c.tmo_arancel
	where per_codigo = @codper and ciclo = @codcil and npe_mora = @npe and not exists(
	select 1 from col_mov_movimientos  
	join col_dmo_det_mov on dmo_codmov=mov_codigo 
	join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
	where mov_codper=@codper and dmo_codcil=@codcil and a.tmo_arancel =b.tmo_arancel and mov_estado <> 'A'
	)
	union
	--UNION PARA EL PAGO DE OTROS ARANCELES
	select tmo_codigo, per_codigo, per_carnet, tmo_arancel, tmo_valor, per_tipo, Mora, Estado from (
	select top 1 c.tmo_codigo,per_codigo, per_carnet, b.tmo_arancel, b.tmo_valor, 'U' as per_tipo, 0 as Mora
	--,isnull(
	--	(select '2' from col_mov_movimientos  
	--	join col_dmo_det_mov on dmo_codmov=mov_codigo 
	--	join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
	--	where mov_codper=@codper and dmo_codcil=@codcil and a.tmo_arancel =b.tmo_arancel and mov_estado <> 'A'
	--	),
	--'1') Estado
	, 1 Estado, dao_codigo
	from col_dao_data_otros_aranceles --b
	inner join ra_per_personas on per_codigo = dao_codper
	inner join ra_cil_ciclo on cil_codigo = dao_codcil
	inner join col_dpboa_definir_parametro_boleta_otros_aranceles on dpboa_codigo = dao_coddpboa
	inner join col_tmo_tipo_movimiento as b on b.tmo_codigo = dpboa_codtmo
	join col_tmo_tipo_movimiento c on b.tmo_arancel=c.tmo_arancel
	where per_codigo = @codper and cil_codigo = @codcil and dao_npe = @npe
	order by dao_codigo desc
	) t
END


ALTER PROCEDURE [dbo].[sp_insertar_encabezado_pagos_online_otros_aranceles_estructurado]
	-- =============================================
	-- Author:		<Juan Carlos Campos Rivera>
	-- Create date: <Viernes 31 Mayo 2019>
	-- Description:	<Aplicar pagos de otros aranceles en linea, es invocado en WS: realizarPagoRef(string codigo_barra, string referencia)>
	-- =============================================
	--	exec sp_insertar_encabezado_pagos_online_otros_aranceles_estructurado '4157419700003137390200000007009600001002802000001813249022019', 12, '34788j78u25414'
	--	exec sp_insertar_encabezado_pagos_online_otros_aranceles_estructurado '0313000700000018132490220197', 12, '34788j78u25414'
	@barra varchar(80),
	@tipo int,
	@referencia varchar(50),
	@mov_codigo_generado int = 0 output --Si no se altera el valor de igual a 0, retorna el select 'IdGenerado', de lo contrario se toma como el retorno de un parametro de salida
as
begin
	set nocount on;
	set dateformat dmy

	declare @len int
	select @len = isnull(len(@barra), 0)
	print '@len: ' +cast(@len as varchar(10))
	if @len = 28 --Es NPE el parametro @codigo_barra
	begin
		print 'NPE'
		select @barra = dao_barra from col_dao_data_otros_aranceles where dao_npe = @barra
	end
	print '@barra: ' + cast(@barra as varchar(66))

	declare @Data table(codper int, npe nvarchar(50), barra nvarchar(90), codcil int, tmo_descripcion nvarchar(250), monto float, arancel nvarchar(20), estado int,
		carnet nvarchar(15), alumno nvarchar(90), ciclo nvarchar(15), exento nvarchar(5), cargo_abono int, afecta_materia nvarchar(3), dpboa_periodo int, 
		afecta_evaluacion int, codhpl int, codpon int)

	insert into @Data 
	exec sp_datos_alumno_codigo_barra 1, @barra, @tipo
	-- select * from @data
	declare @estado int, @codper int, @corr_mov int, @codcil int, @CorrelativoGenerado int, @monto float, @exento nvarchar(1), 
		@cargo_abono int, @tmo_arancel nvarchar(15), @tmo_descripcion nvarchar(100), @codhpl int, @codpon int, @afecta_materia nvarchar(3),
		@afecta_evaluacion int, @periodo int, @codmat nvarchar(15), @npe nvarchar(50), @carnet nvarchar(15), @MontoPagar float

	select @estado = estado, @codper = codper, @codcil = codcil, @monto = monto, @exento = exento, @cargo_abono = cargo_abono, @tmo_arancel = arancel, 
		@tmo_descripcion = tmo_descripcion, @afecta_materia = afecta_materia, @afecta_evaluacion = afecta_evaluacion, @periodo = dpboa_periodo, 
		@codhpl = codhpl, @codpon = codpon, @npe = npe, @carnet = carnet
	from @data
	-- select * from @data
	print '***********************************'
	print '@afecta_materia : ' + @afecta_materia
	print '@afecta_evaluacion : ' + cast(@afecta_evaluacion as nvarchar(15))
	print '@monto : ' + cast(@monto as nvarchar(15))
	print '@periodo : ' + cast(@periodo as nvarchar(15))
	set @MontoPagar = @Monto
	print '@exento : ' + cast(@exento as nvarchar(15))
	print '@cargo_abono : ' + cast(@cargo_abono as nvarchar(15))
	print '@tmo_arancel : ' + @tmo_arancel
	print '@tmo_descripcion : ' + @tmo_descripcion
	print '@codhpl : ' + cast(@codhpl as nvarchar(15))
	print '@carnet : ' + @carnet
	print '***********************************'
	--select * from @data

	print '@estado : ' + cast(@estado as nvarchar(5))

	if @estado = 0
	begin
		print 'Se inserta el encabezado del pago'

		declare @lote nvarchar(10)

		select @lote = tit_lote
		from col_tit_tiraje
		where tit_tpodoc = 'F'
		and tit_mes = month(getdate())
		and tit_anio = year(getdate())
		and tit_codreg = 1 and tit_estado = 1

		declare @usuario varchar(200), @banco int, @pal_codigo int, @descripcion varchar(200)

		select	@usuario = pal_usuario, 
				@banco = pal_banco, 
				@descripcion = pal_descripcion_pago, 
				@pal_codigo = pal_codigo
		from col_pal_pagos_linea
		where pal_codigo = @tipo
		
		begin transaction 
		begin try

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
			/*Fin de variables para el encabezado de factura */
			set @mov_codban = @banco
			set @mov_codcil = @codcil
			set @mov_codper = @codper

			/*Variables para el detalle de factura */
			declare
			@dmo_codreg int,
			@dmo_codmov int,
			@dmo_codigo int,
			@dmo_codtmo int,
			@dmo_cantidad int,
			@dmo_valor float,
			@dmo_codmat nvarchar(15),
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

			set @mov_puntoxpress = @tipo
			set @mov_recibo_puntoxpress = @referencia
			set @mov_fecha = getdate()
			set @mov_fecha_registro = getdate()
			set @mov_fecha_cobro = getdate()

			select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos

			/* Insertando el encabezado de la factura*/
			exec col_efpc_EncabezadoFacturaPagoCuotas 1,
			--select 
				@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
				@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

			print '*-FIN Almacenando el encabezado de la factura'
			/* Insertando el detalle de la factura*/

			/*Almacenando el arancel de la matricula */
			print '**--Almacenando el arancel de la matricula'
			select @CorrelativoGenerado = @corr_mov -- max(mov_codigo) from col_mov_movimientos 

			declare @codtmo int
			select @codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @tmo_arancel

			--select top 25 * from col_dmo_det_mov where dmo_codtmo = @codtmo order by dmo_fecha_registro desc

			select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
			set @dmo_valor = @monto
			set @dmo_codtmo = @codtmo

			set @dmo_iva = 0

			set @dmo_codmat = case 
								when @afecta_materia = 1 then (select hpl_codmat from ra_hpl_horarios_planificacion where hpl_codigo = @codhpl)
									else ''
							end
			print '@dmo_codmat : ' + cast(@dmo_codmat as nvarchar(10))

			select @dmo_eval = case when @afecta_evaluacion = 1 then @codpon 
									when @afecta_evaluacion = 0 then 0
								end
			print '@dmo_eval : ' + cast(@dmo_eval as nvarchar(5))

			if @exento = 'S'
			begin
				print '@exento = S'
				if @cargo_abono = 2
				begin
					set @dmo_abono = @Monto
					set @dmo_cargo = @Monto
					set @dmo_valor = @Monto
					set @dmo_iva = 0
				end
			end
		
			if @exento = 'N' and @cargo_abono = 2
			begin
				print '@exento = N'
				print '@cargo_abono = ' + cast(@cargo_abono as nvarchar(2))
				set @dmo_abono = @Monto
				set @dmo_cargo = @Monto
				set @dmo_valor = round(@Monto / 1.13, 2)
				set @dmo_iva = @Monto - @dmo_valor
			end	

			exec col_dfpc_DetalleFacturaPagoCuotas	1,				
			--select 
				@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, 
				@dmo_cargo, @dmo_abono, @dmo_eval
			if @mov_codigo_generado = 0
				select @corr_mov as IdGenerado

			set @mov_codigo_generado = @corr_mov
			insert into col_pagos_en_linea_estructurado_OtrosAranceles(codper, carnet, NumFactura, formapago, lote, MontoFactura, npe, codigo_barra)
			values (@codper, @carnet, @CorrelativoGenerado, @tipo, @lote, @MontoPagar, @npe, @barra)
			--select * from col_pagos_en_linea_estructurado_OtrosAranceles
			--select top 500 * from col_dmo_det_mov where dmo_codtmo = @codtmo order by dmo_fecha_registro desc
		commit transaction -- o solo commit

		end try
		begin catch
			rollback transaction -- o solo rollback
    
			insert into col_ert_error_transaccion(ert_codper, ert_npe, ert_ciclo,ert_message,ert_numer,ert_severity,ert_state,ert_procedure,ert_line)
			values(@codper, @npe, @codcil,error_message(),error_number(),error_severity(),error_state(),error_procedure(),error_line())
			--	select '2' resultado, -1 as correlativo, 'no se pudo generar la transacción' as descripcion
			--	-- 2: error algun dato incorrecto no guardo ningun cambio
			if @mov_codigo_generado = 0
				select 0 IdGenerado
			set @mov_codigo_generado = 0

		end catch
	end	--	if @estado = 0
	else
	begin 
		--select --@estado
		--case when @estado = -1 then 'ARANCEL NO EXISTE EN LA TABLA'
		--	when @estado = 1 then 'No hay cupo'
		--	when @estado = 2 then 'Periodo Vencido'
		--	when @estado = 3 then 'No se encuentra en el periodo'
		--End as Mensaje
		if @mov_codigo_generado = 0
			select 0 IdGenerado
		set @mov_codigo_generado = 0
	end
end


--exec sp_col_daapl_datos_alu_pago_linea_estructurado  '0313006300000018016850120207' --4ta cuota
--exec sp_col_daapl_datos_alu_pago_linea_estructurado  '0313001800000018016890120205' --retiro ciclo

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

		select @carnet = substring(@npe,11,2) + '-' + substring(@npe,13,4) + '-' + substring(@npe,17,4)  

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


ALTER procedure [dbo].[sp_col_dao_data_otros_aranceles]
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-05-27 09:29:42.293>
	-- Description: <Realiza el mantenimiento a la tabla col_dao_data_otros_aranceles> 2019-05-27 11:31:08.130
	-- =============================================
	--sp_col_dao_data_otros_aranceles 0, 1, 0, 0, 0, 0, 0 --
	--sp_col_dao_data_otros_aranceles 1, 1, 221782, 0, 0, 0, 0 --
	--sp_col_dao_data_otros_aranceles 3, 1, 218291, 35755, 0, 119, 1 --INSERTA EL NPE Y CODIGO DE BARRA
	--sp_col_dao_data_otros_aranceles 4, 1, 218291, 35755, 0, 122, 128, 0 --VALIDA SI CUMPLE LOS PARAMETROS 
	@opcion int = 0,
	@codtao int = 0,--TIPIFICACION DE ARANCELES
	@codper int = 0,
	@codhpl int = 0,
	@codpon int = 0,
	@codcil int = 0,
	@codpboa int = 0,
	@codtmo int = 0
as
begin
	if @opcion = 0 --Regresa las tipificacion de aranceles activos
	begin
		select 0 'ta_codigo', 'Seleccione' 'ta_nombre'
		union
		select ta_codigo, ta_nombre from col_ta_tipificacion_arancel where ta_estado = 1
		order by 1
	end

	if @opcion = 1 --Regresa los aranceles correspondientes al @codtao
	begin 
		declare @detalle_tipo_estudio as table(coddtde int, valor varchar(25))
		insert into @detalle_tipo_estudio
		exec sp_detalle_tipo_estudio_alumno @codper
		declare @detalle_tipo_estudio_xml varchar(max)
		set @detalle_tipo_estudio_xml = (select coddtde, valor from @detalle_tipo_estudio for xml path(''))
		print '@detalle_tipo_estudio_xml ' + cast(@detalle_tipo_estudio_xml as varchar(max))

		 if exists (select 1 from col_dpboa_definir_parametro_boleta_otros_aranceles inner join col_tmo_tipo_movimiento on tmo_codigo = dpboa_codtmo inner join col_ta_tipificacion_arancel on ta_codigo = dpboa_codta where dpboa_estado = 1 and ta_estado = 1 and ta_codigo = @codtao /*AGREGADO EL 16/08/2019 21:55:00 PARA PODER REALIZAR FILTROS MAS DETALLOS SEGUN CADA TIPO ALUMNO*/ and dpboa_coddtde = (select coddtde from @detalle_tipo_estudio) )
            select 0 'dpboa_codigo', 'Seleccione' 'texto'
			union
			select dpboa_codigo, concat(tmo_arancel, ' ', tmo_descripcion) 'texto' from col_dpboa_definir_parametro_boleta_otros_aranceles 
            inner join col_tmo_tipo_movimiento on tmo_codigo = dpboa_codtmo 
            inner join col_ta_tipificacion_arancel on ta_codigo = dpboa_codta
            where dpboa_estado = 1 and ta_estado = 1 and ta_codigo = @codtao  
			and dpboa_coddtde = (select coddtde from @detalle_tipo_estudio)--AGREGADO EL 16/08/2019 21:55:00 PARA PODER REALIZAR FILTROS MAS DETALLOS SEGUN CADA TIPO ALUMNO
			order by 1
        else 
			select '-1' 'dpboa_codigo', 'No hay aranceles' 'texto'
	end
	
	if @opcion = 2 --Devuelve si la tipificacion afecta materia
	begin
		select dpboa_afecta_materia, tmo_valor from col_dpboa_definir_parametro_boleta_otros_aranceles inner join col_tmo_tipo_movimiento on dpboa_codtmo = tmo_codigo where dpboa_codigo = @codpboa 
	end

	if @opcion = 3 --Inserta el registro a la tabla col_dao_data_otros_aranceles
	begin
		declare @fecha_creacion datetime = getdate();
		insert into col_dao_data_otros_aranceles (dao_codper, dao_codhpl, dao_codpon, dao_codcil, dao_coddpboa, dao_fecha_creacion) 
		values (@codper, @codhpl, 
		--(select penot_eval from web_ra_not_penot_periodonotas where getdate() >= penot_fechaini and GETDATE()<= penot_fechafin and penot_periodo = 'Ordinario'), 
		(select ade_eval from ade_activar_desactivar_evaluaciones where convert(date, getdate(),103) >= convert(date, ade_fecha_inicio,103) and convert(date, getdate(),103)<= convert(date, ade_fecha_fin,103)),
		@codcil, @codpboa, @fecha_creacion);
		declare @Id int
		set @Id = scope_identity()
		
		exec tal_GenerarDataOtrosAranceles 1, @Id --ACTUALIZA EL NPE Y CODIGO DE BARAR

		--SELECT * from col_dao_data_otros_aranceles where dao_codigo = 191
		declare @data table
		(
			carnet nvarchar(15),
			alumno nvarchar(75), 
			tmo_arancel nvarchar(15),
			Monto float, 
			arancel nvarchar(125), 
			carrera nvarchar(150),
			barra nvarchar(80), 
			npe nvarchar(40),
			ciclo nvarchar(10),
			coddao int default 0, 
			fecha_creacion datetime default null
		) ;
		insert into @data (carnet, alumno, tmo_arancel, Monto, arancel, carrera, barra, npe, ciclo)
		exec tal_GenerarDataOtrosAranceles 2, @Id --MUESTRA LA INFORMACION DEL ALUMNO

		update @data set coddao = @Id, fecha_creacion = @fecha_creacion
		select * from @data
	end

	if @opcion = 4
	begin
		select dbo.fn_cumple_parametros_boleta_otros_aranceles(@codpboa, @codcil,-1, @codper)
	end
end

ALTER proc [dbo].[sp_insertar_motivo_retirado]
	@pmr_codper int,
	@pmr_ciclo int,
	@pmr_motivo varchar(100),
	@pmr_codmor int
as
begin
	if not exists(select 1 from ra_pmr_personas_motivo_re where pmr_codmor=@pmr_codmor and pmr_ciclo=@pmr_ciclo and pmr_codper=@pmr_codper)
	begin
		insert into ra_pmr_personas_motivo_re (pmr_codper, pmr_ciclo, pmr_motivo, pmr_codmor, pmr_fecha)
		values(@pmr_codper,@pmr_ciclo,@pmr_motivo,@pmr_codmor,getdate())
	end
	else
	begin
		Select 'El motivo ya se inserto, verifique los motivos' as mensaje
	end
end


ALTER PROCEDURE [dbo].[sp_datos_alumno_codigo_barra]
	-- =============================================
	-- Author:		<Adones>
	-- Create date: <29/05/2019>
	-- Description:	<Es invocado en el WS: consultarPago(string codigo_barra, string usuario, string clave)>
	-- =============================================
	--	exec sp_datos_alumno_codigo_barra 1,'0313001200000018132490220190', 15
	--	exec sp_datos_alumno_codigo_barra 1,'415741970000313739020000001200960000000180200000181324022019', 15
	
	--	sp_datos_alumno_codigo_barra 2,'0313001200000018132490220190', 15
	--	sp_datos_alumno_codigo_barra 2,'415741970000313739020000001200960000000180200000181324022019', 15
	@opcion int = 0,
	@codigo_barra nvarchar(80) = ''--CODIGO DE BARRA Ó NPE
	, @codigo_banco int = 0
as
begin
	declare @codper int
	declare @dao_codigo int
	declare @codcil int
	declare @arancel_codigo int
	declare @len int

	declare @tipo varchar(5) = ''
	declare @existe_npe_o_barra int = 0
	select @len = isnull(len(@codigo_barra), 0)

	if @len = 28 --Es NPE el parametro @codigo_barra
	begin
		print 'NPE'
		select @dao_codigo = dao_codigo, @tipo = 'NPE', @codper = dao_codper 
		from col_dao_data_otros_aranceles where dao_npe = @codigo_barra
	end
	else if @len = 60
	begin
		print 'Codigo Barra'
		select @dao_codigo =  substring(@codigo_barra,33,8), @tipo = 'BARRA', @codper = cast(SUBSTRING(@codigo_barra, 45, 10) as bigint)
	end
	print '@dao_codigo ' + cast(@dao_codigo as varchar)

	if @opcion = 1
	begin
		--select @codper = dao_codper from col_dao_data_otros_aranceles where dao_codigo = @dao_codigo
		select @arancel_codigo = dpboa_codtmo from col_dao_data_otros_aranceles 
		join col_dpboa_definir_parametro_boleta_otros_aranceles on dpboa_codigo = dao_coddpboa
		where dao_codigo = @dao_codigo

		print '@codper: '+cast(@codper as varchar)
		print '@arancel_codigo: '+cast(@arancel_codigo as varchar)
		print '-----------------------------------------'
		print 'Estado : -1 ARANCEL NO EXISTE EN LA TABLA dpboa o dao'
		print 'Estado : 0- Todo bien'
		print 'Estado : 1- No hay cupo'
		print 'Estado : 2- Ya se vencio el periodo'
		print 'Estado : 3- No esta en el periodo'
		print 'Estado : 4- Debe cuotas'
		print 'Estado : 5- Debe mora en biblioteca'

		if @tipo = 'NPE'
		begin
			if exists (select 1 from col_dao_data_otros_aranceles where dao_codigo = @dao_codigo and dao_npe = @codigo_barra)
				select @existe_npe_o_barra = 1
		end
		else if @tipo = 'BARRA'
		begin
			if exists (select 1 from col_dao_data_otros_aranceles where dao_codigo = @dao_codigo and dao_barra = @codigo_barra)
				select @existe_npe_o_barra = 1
		end

		if @existe_npe_o_barra = 1
		begin
			select dao_codper, dao_npe, dao_barra,dao_codcil, tmo_descripcion, tmo_valor, tmo_arancel, 
				dbo.fn_cumple_parametros_boleta_otros_aranceles(dpboa_codigo,dao_codcil,-1, dao_codper) estado, per_carnet, per_apellidos_nombres,
				concat('0',cil_codcic,'-',cil_anio) 'ciclo', tmo_exento, tmo_cargo_abono, dpboa_afecta_materia, dpboa_periodo, 
				dpboa_afecta_evaluacion, isnull(dao_codhpl, -1) as codhpl, isnull(dao_codpon, -1) as codpon
			from col_dao_data_otros_aranceles 
				join col_dpboa_definir_parametro_boleta_otros_aranceles on dpboa_codigo = dao_coddpboa
				join col_tmo_tipo_movimiento on tmo_codigo = dpboa_codtmo
				join ra_per_personas on dao_codper = per_codigo
				join ra_cil_ciclo on cil_codigo = dao_codcil
			where dao_codigo = @dao_codigo
		end
		else
			select -1 'estado'
	 end

	if @opcion = 2--Consulta el npe o codigo de barra
	begin
		select @arancel_codigo = dpboa_codtmo from col_dao_data_otros_aranceles 
		join col_dpboa_definir_parametro_boleta_otros_aranceles on dpboa_codigo = dao_coddpboa
		where dao_codigo = @dao_codigo
		print '@arancel_codigo : ' + cast(@arancel_codigo as nvarchar(10))

		if @tipo = 'NPE'
		begin
			if exists (select 1 from col_dao_data_otros_aranceles where dao_codigo = @dao_codigo and dao_npe = @codigo_barra)
				select @existe_npe_o_barra = 1
		end
		else if @tipo = 'BARRA'
		begin
			if exists (select 1 from col_dao_data_otros_aranceles where dao_codigo = @dao_codigo and dao_barra = @codigo_barra)
				select @existe_npe_o_barra = 1
		end

		if @existe_npe_o_barra = 1
		begin
			select dbo.fn_cumple_parametros_boleta_otros_aranceles(dpboa_codigo,dao_codcil,-1, dao_codper) estado
			from col_dao_data_otros_aranceles 
				join col_dpboa_definir_parametro_boleta_otros_aranceles on dpboa_codigo = dao_coddpboa
				join col_tmo_tipo_movimiento on tmo_codigo = dpboa_codtmo
				join ra_per_personas on dao_codper = per_codigo
				join ra_cil_ciclo on cil_codigo = dao_codcil
			where dao_codigo = @dao_codigo
		end
		else
			select -1 'estado'
	 end
 end


ALTER procedure [dbo].[sp_alumno_cancelo_aranceles_tramites_enlinea]
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-03-23 22:28:29.070>
	-- Description: <>
	-- =============================================
	-- sp_alumno_cancelo_aranceles_tramites_enlinea 1, 6, 180168, 122
	-- sp_alumno_cancelo_aranceles_tramites_enlinea 2, 7, 180168, 122
	-- sp_alumno_cancelo_aranceles_tramites_enlinea 4, 7, 180168, 122
	@opcion int = 0,
	@codtrao int = 0, --tabla ra_Tramites_academicos_online
	@codper int = 0,
	@codcil int = 0,
	@mai_codigo int = 0
as
begin
	if @opcion = 1 --validar si el alumno pago el arancele para realizar el tramite @codtrao
	begin
		if exists (
			select 1 from col_mov_movimientos 
			inner join col_dmo_det_mov on dmo_codmov = mov_codigo --and  mov_codigo = 6262258
			inner join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
			where mov_codper = @codper and mov_codcil = @codcil
			and dmo_codtmo in (
				--aranceles necesarios para el tramite
				select tmo_codigo from ra_traar_tramites_aranceles_online
				inner join ra_Tramites_academicos_online on trao_codigo = traar_codtrao
				inner join col_tmo_tipo_movimiento on tmo_codigo = traar_codtmo
				where trao_codigo = @codtrao
			)
		)
		begin
			select 1 --alumno cancelo arancel para el tramite
		end
		else
		begin
			select 0 --alumno no cancelo arancel para el tramite
		end
	end

	if @opcion = 2 --Datos para e reporte de retiro
	begin
		select per_carnet, per_nombres_apellidos, getdate() 'fecha', fac_nombre, car_nombre,
		 (select UPPER(trao_nombre) from ra_Tramites_academicos_online where trao_codigo = @codtrao) 'tramite',
		 (select concat('0', cil_codcic, '-', cil_anio) from ra_cil_ciclo where cil_codigo = @codcil) ciclo
		from ra_alc_alumnos_carrera
		inner join ra_per_personas on per_codigo = alc_codper
		inner join ra_pla_planes on pla_codigo = alc_codpla
		inner join ra_car_carreras on car_codigo = pla_codcar
		inner join ra_fac_facultades on fac_codigo = car_codfac
		where alc_codper = @codper
	end

	if @opcion = 3 --Todas las materias inscritas del alumno en el ciclo
	begin
		select  distinct per_carnet, hpl_codmat, mat_nombre, hpl_descripcion, (case when hpl_lunes = 'S' then 'Lu-' ELSE '' END + 
					case when hpl_martes = 'S' then 'Mar-' ELSE '' END + 
					case when hpl_miercoles = 'S' then 'Mie-' ELSE '' END + 
					case when hpl_jueves = 'S' then 'Jue-' ELSE '' END + 
					case when hpl_viernes = 'S' then 'Vie-' ELSE '' END + 
					case when hpl_sabado = 'S' then 'Sab-' ELSE '' END + 
					case when hpl_domingo = 'S' then 'Dom-' ELSE '' END) dias, man_nomhor horario, aul_nombre_corto, mai_matricula--, mai_estado, mai_codigo
					, ins_codigo, mai_codigo
		from ra_ins_inscripcion
		inner join ra_per_personas on per_codigo = ins_codper
		inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
		inner join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
		inner join ra_mat_materias on mat_codigo = hpl_codmat
		inner join ra_man_grp_hor on hpl_codman = man_codigo
		inner join ra_aul_aulas on aul_codigo = hpl_codaul
		where ins_codper = @codper and ins_codcil = @codcil and mai_estado <> 'R'
	end

	if @opcion = 4 --Materia Retirada
	begin
		select  distinct per_carnet, hpl_codmat, mat_nombre, hpl_descripcion, (case when hpl_lunes = 'S' then 'Lu-' ELSE '' END + 
					case when hpl_martes = 'S' then 'Mar-' ELSE '' END + 
					case when hpl_miercoles = 'S' then 'Mie-' ELSE '' END + 
					case when hpl_jueves = 'S' then 'Jue-' ELSE '' END +  
					case when hpl_viernes = 'S' then 'Vie-' ELSE '' END + 
					case when hpl_sabado = 'S' then 'Sab-' ELSE '' END + 
					case when hpl_domingo = 'S' then 'Dom-' ELSE '' END) dias, man_nomhor horario, aul_nombre_corto, mai_matricula,
					(select concat('0', cil_codcic, '-', cil_anio) from ra_cil_ciclo where cil_codigo = @codcil) ciclo--, mai_estado, mai_codigo
		from ra_ins_inscripcion
		inner join ra_per_personas on per_codigo = ins_codper
		inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
		inner join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
		inner join ra_mat_materias on mat_codigo = hpl_codmat
		inner join ra_man_grp_hor on hpl_codman = man_codigo
		inner join ra_aul_aulas on aul_codigo = hpl_codaul
		where ins_codper = @codper and ins_codcil = @codcil and mai_estado = 'R'and mai_codigo = @mai_codigo
	end
end

-- =============================================
-- Author:      <Fabio>
-- Create date: <2019-05-28 15:57:36.870>
-- Description: <Esta funcion devuelve una respuesta entera(detalladas en la funcion abajo) segun el @codpboa>
-- =============================================
-- select dbo.fn_cumple_parametros_boleta_otros_aranceles(131, 122, -1, 180168) --Retiro de Materias Extraordinario.
-- select dbo.fn_cumple_parametros_boleta_otros_aranceles(128, 122, -1, 180168) --Retiro de Ciclo.	
ALTER function [dbo].[fn_cumple_parametros_boleta_otros_aranceles]
(
	@codpboa int = 0, 
	@codcil int = 0,
	@parametro int = 0,
	@codper int = 0
)
returns int as
begin
    declare @respuesta int = 0 --1:NO EXISTE EL ARANCEL, 0: todo bien, 1: cupo acabado, 2: fecha vencimiento vencio, 3: fuera del periodo (fecha_desde a fecha_hasta), 4: TIENEN CUOTAS PENDIENTES, 5: TIENE MORA CON BIBLIOTECA

	declare @dpboa_codtmo int
	declare @dpboa_afecta_materia int
	declare @dpboa_cupo_vencimiento	int
	declare @dpboa_fecha_vencimiento nvarchar(24)
	declare @dpboa_periodo int
	declare @dpboa_fecha_desde nvarchar(24)
	declare @dpboa_fecha_hasta nvarchar(24)
	declare @dpboa_estado int
	declare @cupo int
	declare @asistencias int

	declare @dpboa_cuotas_pendientes int
	declare @dpbos_solvencia_biblioteca int

	if exists(select 1 from col_dpboa_definir_parametro_boleta_otros_aranceles where dpboa_codigo = @codpboa)
	begin
		--select * from col_dpboa_definir_parametro_boleta_otros_aranceles
		select	@dpboa_codtmo = isnull(dpboa_codtmo, -1),
				@dpboa_afecta_materia = isnull(dpboa_afecta_materia, -1),
				@dpboa_cupo_vencimiento = isnull(dpboa_cupo_vencimiento, -1),
				@dpboa_fecha_vencimiento = isnull(dpboa_fecha_vencimiento, -1),
				@dpboa_periodo = isnull(dpboa_periodo, -1),
				@dpboa_fecha_desde = isnull(dpboa_fecha_desde, -1),
				@dpboa_fecha_hasta = isnull(dpboa_fecha_hasta, -1),
				@cupo = isnull(tmo_cupo, -1),
				@dpboa_cuotas_pendientes = isnull(dpboa_cuotas_pendientes, -1),
				@dpbos_solvencia_biblioteca = isnull(dpbos_solvencia_biblioteca, -1)
		from col_dpboa_definir_parametro_boleta_otros_aranceles
		inner join col_tmo_tipo_movimiento on tmo_codigo = dpboa_codtmo
		where dpboa_codigo = @codpboa and dpboa_estado = 1
		
		if @dpboa_cuotas_pendientes = 1
		begin
			declare @cuota int
			select @cuota = ctao_cuotas from ra_ctao_cuotas_tramites_academicos_online where ctao_codcil = @codcil and ctao_codtrao in (-- @codtrao
				select traar_codtrao from ra_traar_tramites_aranceles_online
				inner join ra_Tramites_academicos_online on trao_codigo = traar_codtrao
				inner join col_tmo_tipo_movimiento on tmo_codigo = traar_codtmo
				where traar_codtmo in (select dpboa_codtmo from col_dpboa_definir_parametro_boleta_otros_aranceles where dpboa_codigo = @codpboa)
			)
			set @dpboa_cuotas_pendientes = 0
			select @dpboa_cuotas_pendientes = dbo.VerificarPagos(@codper, isnull(@cuota, 0)/*3*/, @codcil)
			if @dpboa_cuotas_pendientes <> 1 --no tiene las cuotas al dia
				set @respuesta = 4
		end

		if @dpbos_solvencia_biblioteca = 1
		begin
			if exists (select 1 from bib_aldebib_alumnos_deudas_biblioteca where aldebib_carnet = (select per_carnet from ra_per_personas where per_codigo = @codper) and aldebib_debe_biblioteca = 1)
				set @respuesta = 5
		end

		if @dpboa_cupo_vencimiento = 1 and @cupo > 0--CUPO > 0 por que tuvieron que poner una cantidad > 0 si tiene cupo, si tiene cupo = 0 el dato esta mal ingresado
		begin
			select @asistencias = isnull(count(1), 0) from col_dmo_det_mov 
			inner join col_mov_movimientos on dmo_codmov = mov_codigo
			inner join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
			where dmo_codcil = @codcil and dmo_codtmo in(@dpboa_codtmo) and mov_estado <> 'A'
			
			if @asistencias >= @cupo
				set @respuesta = 1

			if not (convert(date,getdate(), 103) <= convert(date, @dpboa_fecha_vencimiento, 103))
				set @respuesta = 2
		end

		if @dpboa_periodo = 1
			if not(convert(date,getdate(), 103) >= convert(date, @dpboa_fecha_desde, 103) and convert(date,getdate(), 103) <= convert(date, @dpboa_fecha_hasta, 103))
				set @respuesta = 3
	end
	else
	begin
		set @respuesta = -1
	end
	return @respuesta --1:NO EXISTE EL ARANCEL, 0: todo bien, 1: cupo acabado, 2: fecha vencimiento vencio, 3: fuera del periodo (fecha_desde a fecha_hasta), 4: TIENEN CUOTAS PENDIENTES, 5: TIENE MORA CON BIBLIOTECA
end

-- =============================================
-- Author:		<Manrrique Arita>
-- Create date: <19/03/2020 14:45>
-- Description:	<Verifica los pagos realizados para tramites academicos>
-- =============================================
alter FUNCTION [dbo].[VerificarPagos]
(
	@codper int,
	@cuotas int,
	@codcil int
)
RETURNS int
AS
BEGIN
	DECLARE @result int

	Select @result = count(mov_codper)
	from col_mov_movimientos 
		inner join col_dmo_det_mov on dmo_codmov = mov_codigo and dmo_codcil = mov_codcil
		inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo_codtmo 
		inner join vst_Aranceles_x_Evaluacion as vst on vst.are_codtmo = tmo.tmo_codigo and vst.tmo_arancel = tmo.tmo_arancel
	where are_cuota <= @cuotas and mov_codcil = @codcil and mov_codper = @codper

	RETURN iif(@result >= (@cuotas + 1), 1, 0)
END

--drop table ra_tae_tramites_academicos_efectuados
create table ra_tae_tramites_academicos_efectuados (
	tae_codigo int primary key identity(1, 1),
	tae_codper int foreign key references ra_per_personas,
	tae_codtrao int foreign key references ra_Tramites_academicos_online,
	tae_codcil int foreign key references ra_cil_ciclo, 
	tae_codins int foreign key references ra_ins_inscripcion,  
	tae_codmai int foreign key references ra_mai_mat_inscritas,  
	tae_codusr int foreign key references adm_usr_usuarios,  
	tae_fecha_creacreacion datetime default getdate()
)
--select * from ra_tae_tramites_academicos_efectuados

alter procedure sp_tae_tramites_academicos_efectuados
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-03-26 13:32:16.040>
	-- Description: <Realiza el mantenimiento a la tabla "tae_tramites_academicos_efectuados">
	-- =============================================
	@opcion int = 0, 
	@tae_codigo int = 0,
	@tae_codper int = 0,
	@tae_codtrao int = 0,
	@tae_codcil int = 0,
	@tae_codins int = 0,
	@tae_codmai int = 0,
	@tae_codusr int = 0,

	@fecha_desde nvarchar(10) = '',
	@fecha_hasta nvarchar(10) = ''
as
begin
	if @opcion = 1 --inserta un registro a la tabla "tae_tramites_academicos_efectuados"
	begin
		insert into ra_tae_tramites_academicos_efectuados (tae_codper, tae_codtrao, tae_codcil, tae_codins, tae_codmai, tae_codusr)
		values (@tae_codper, @tae_codtrao, @tae_codcil, @tae_codins, @tae_codmai, @tae_codusr)
	end

	if @opcion = 2 --inserta un registro a la tabla "tae_tramites_academicos_efectuados"
	begin
		select @tae_codins = mai_codins from ra_mai_mat_inscritas where mai_codigo = @tae_codmai
		insert into ra_tae_tramites_academicos_efectuados (tae_codper, tae_codtrao, tae_codcil, tae_codins, tae_codmai, tae_codusr)
		values (@tae_codper, @tae_codtrao, @tae_codcil, @tae_codins, @tae_codmai, @tae_codusr)
	end

	if @opcion = 3  --Muestra los retiros 
	begin
		select distinct per_carnet, per_nombres_apellidos,trao_nombre, trao_tipo, concat('0', cil_codcic, '-', cil_anio) ciclo
		, tae_fecha_creacreacion, mai_codmat, mat_nombre, hpl_descripcion, usr_usuario
		from ra_tae_tramites_academicos_efectuados
		inner join ra_per_personas on per_codigo = tae_codper
		inner join ra_Tramites_academicos_online on tae_codtrao = trao_codigo
		left join adm_usr_usuarios on usr_codigo = tae_codusr
		inner join ra_cil_ciclo on cil_codigo = tae_codcil
		left join ra_ins_inscripcion on ins_codigo = tae_codins and ins_codcil = tae_codcil
		left join ra_mai_mat_inscritas on mai_codins = ins_codigo and mai_codigo = tae_codmai
		left join ra_mat_materias on mat_codigo = mai_codmat
		left join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
		where tae_codtrao = @tae_codtrao --and convert(date, tae_fecha_creacreacion,103) between '2020-03-26' and '2020-03-26'
	end
end
insert into col_dao_data_otros_aranceles
--drop table bib_aldebib_alumnos_deudas_biblioteca--4642
create table bib_aldebib_alumnos_deudas_biblioteca(
	aldebib_codigo int primary key identity (1, 1),
	aldebib_carnet varchar(16), 
	aldebib_debe_biblioteca tinyint default 1,
	aldebib_fecha_creacion datetime default getdate()
)
--select * from bib_aldebib_alumnos_deudas_biblioteca
--insert into bib_aldebib_alumnos_deudas_biblioteca (aldebib_carnet, aldebib_debe_biblioteca) 

select * from col_ta_tipificacion_arancel
insert into col_ta_tipificacion_arancel (ta_nombre, ta_estado) values ('ANTICIPO MATRICULA', 1)

select * from col_tmo_tipo_movimiento where tmo_arancel = 'A-254'
