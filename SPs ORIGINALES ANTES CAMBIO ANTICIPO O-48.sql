USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[tal_GenerarDataOtrosAranceles]    Script Date: 22/11/2021 21:43:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:		<Juan Carlos Campos>
	-- Create date: <Martes 25 Mayo 2019>
	-- Description:	<Generar NPE de pago y codigo de barra de otros aranceles que no son matriculas ni cuotas>
	-- =============================================
ALTER PROCEDURE [dbo].[tal_GenerarDataOtrosAranceles]
	@opcion int,
	@dao_codigo int	--	correlativo de la tabla "col_dao_data_otros_aranceles"
AS
BEGIN
	set nocount on;
	set dateformat dmy;
	declare @npe nvarchar(40), @cod_barra nvarchar(80)

	declare @carnet nvarchar(12), @alumno nvarchar(60), @tmo_arancel nvarchar(15), @arancel nvarchar(75), @carrera nvarchar(80), @correlativo_tabla_npe nvarchar(8)
	declare @codhpl int, @codpon int, @codper int, @dpboa_codigo int, @codcil int


	select @codper = dao_codper, @codhpl = isnull(dao_codhpl,-1),  @codpon = isnull(dao_codpon,-1), @codcil = dao_codcil, @dpboa_codigo = dao_coddpboa
	from col_dao_data_otros_aranceles 
	where dao_codigo = @dao_codigo


	declare @codtmo int, @afecta_materia int, @cupo_vencimiento int, @periodo int, @fecha_vencimiento nvarchar(10), @fecha_desde nvarchar(10), @fecha_hasta nvarchar(10),
		@afecta_evaluacion int, @per_tipo nvarchar(10)

	select @codtmo = dpboa_codtmo,  @afecta_materia = dpboa_afecta_materia, @cupo_vencimiento = dpboa_cupo_vencimiento, @fecha_vencimiento = dpboa_fecha_vencimiento,
		@periodo = dpboa_periodo, @fecha_desde = dpboa_fecha_desde, @fecha_hasta = dpboa_fecha_hasta, @afecta_evaluacion = dpboa_afecta_evaluacion
	from col_dpboa_definir_parametro_boleta_otros_aranceles 
	where dpboa_codigo = @dpboa_codigo


	declare @Monto float

	select @Monto = tmo_valor, @tmo_arancel = tmo_arancel, @arancel = tmo_descripcion
	from col_tmo_tipo_movimiento where tmo_codigo = @codtmo

	declare @ParteEnteraMonto int, @ParteDecimalEntera int
	declare @MontoString nvarchar(10), @ParteEnteraString nvarchar(10), @ParteDecimalString nvarchar(10) 
	set @MontoString = cast(@Monto as nvarchar(10))
	select @ParteEnteraMonto = cast(CHARINDEX('.',@MontoString) as int) 
	set @ParteEnteraString = case when @ParteEnteraMonto >=1 then substring(@MontoString, 1, @ParteEnteraMonto -1 ) else @MontoString end
	

	set @ParteDecimalString = case when @ParteEnteraMonto >=1  then substring(@MontoString, @ParteEnteraMonto+1, 2) else '00' end

	-- select @ParteEnteraString, @ParteDecimalString

	select @carnet = per_carnet, @alumno = per_nombres_apellidos, @per_tipo = per_tipo
	from ra_per_personas 
	where per_codigo = @codper

	print '@carnet : ' + @carnet
	print '@tmo_arancel : ' + cast(@tmo_arancel as nvarchar(10))
	print '@arancel : ' + @arancel
	print '@codtmo : ' + cast(@codtmo as nvarchar(8))
	print '@Monto : ' + cast(@Monto as nvarchar(10))
	print '@dao_codigo : ' + cast(@dao_codigo as nvarchar(8))

	if @per_tipo = 'D'
	begin
		select @carrera = dip_nombre
		from ra_per_personas 
			inner join dip_ped_personas_dip on per_codigo = ped_codper
			inner join dip_dip_diplomados on ped_coddip = dip_codigo
		where ped_codper = @codper
	end
	else
	begin
		select @carrera = pla_alias_carrera 
		from ra_alc_alumnos_carrera 
			inner join ra_pla_planes on pla_codigo = alc_codpla 
			inner join ra_car_carreras on car_codigo = pla_codcar
		where alc_codper = @codper
	end

	declare @ciclo nvarchar(6)
	declare @ciclo_quion nvarchar(8)

	select @ciclo = right('00'+cast(cil_codcic as varchar),2)+cast(cil_anio as varchar), 
		@ciclo_quion = right('0'+cast(cil_codcic as varchar),2)+'-'+cast(cil_anio as varchar)
	from ra_cil_ciclo inner join ra_cic_ciclos on cic_codigo = cil_codcic
	where cil_codigo = @codcil


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
		ciclo nvarchar(10)
	) 

	insert into @data (carnet, alumno, tmo_arancel, Monto, arancel, carrera, barra, npe, ciclo)
	select @carnet as carnet, @alumno as alumno, @tmo_arancel as tmo_arancel, @Monto as Monto, @arancel as Arancel, @carrera as carrera,
		 --c415, cc415, c3902, cc3902, c96, cc96, c8020, cc8020,
			c415 + cc415 + c3902 + cc3902 + c96 + cc96 + c8020 + cc8020 barra, 
			npe + dbo.fn_verificador_npe(NPE) NPE, @ciclo_quion
	from
	(
		select '415' c415, 
			'7419700003137' cc415,
			'3902' c3902,
			--right('0000000'+cast(floor(@Monto) as varchar),6) + right('00'+cast((@Monto  - floor(@Monto)) as varchar),2) cc3902,
			right('00000000'+cast(floor(@ParteEnteraString) as varchar),8) + right('00'+ cast(floor(@ParteDecimalString) as varchar),2) cc3902,
			'96' c96,	
			--case when @periodo = 1 and @cupo_vencimiento = 1 then substring(@fecha_hasta,1,2) + substring(@fecha_hasta,4,2) + substring(@fecha_hasta,7,4)
			--	 when @periodo = 0 then '99999999'
			--	 when @cupo_vencimiento = 1 then substring(@fecha_vencimiento,1,2) + substring(@fecha_vencimiento,4,2) + substring(@fecha_vencimiento,7,4)
			--end	cc96,
			right('0000000'+cast(floor(@dao_codigo) as varchar),7) as cc96,
			'8020' c8020,
			--substring(@carnet,1,2)+substring(@carnet,4,4)+substring(@carnet,9,4) + /* '*' + */ '9' + @ciclo as cc8020,
			--REPLICATE('0',10-len(cast(@codper as nvarchar(10)))) + cast(@codper as nvarchar(10)) + /* '*' +  '9' +*/ @ciclo as cc8020,
			REPLICATE('0',10-len(cast(@codper as nvarchar(10)))) + cast(@codper as nvarchar(10)) + '9'+ @ciclo as cc8020,
			
			'0313'+right('0000'+cast(floor(@ParteEnteraString) as varchar),4) + right('00'+cast(floor(@ParteDecimalString) as varchar),2) +
			--REPLICATE('0',10-len(cast(@codper as nvarchar(10)))) + cast(@codper as nvarchar(10)) + '9' + @ciclo as  NPE
			REPLICATE('0',10-len(cast(@codper as nvarchar(10)))) + cast(@codper as nvarchar(10)) + right('0000000'+cast(floor(@dao_codigo) as varchar),7) as  NPE
			
	) as data

	if @opcion = 1
	begin
		select @npe = npe, @cod_barra = barra
		from @data

		print '----------------------------------------------------------------------------------------'
		print '@npe : ' + @npe
		print '@cod_barra : ' + @cod_barra

		update col_dao_data_otros_aranceles set dao_npe = @npe, dao_barra = @cod_barra
		where dao_codigo = @dao_codigo

		print 'Actualizacion finalizada del NPE y Codigo de Barra'
	end

	if @opcion = 2
	begin
		select * from @data
	end
end
go



USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_col_dao_data_otros_aranceles]    Script Date: 22/11/2021 21:44:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-05-27 09:29:42.293>
	-- Description: <Realiza el mantenimiento a la tabla col_dao_data_otros_aranceles> 2019-05-27 11:31:08.130
	-- =============================================
	-- exec.dbo.sp_col_dao_data_otros_aranceles 3, 179747, 123, 146, 407
	-- sp_col_dao_data_otros_aranceles @opcion = 7, @codper = 173322
ALTER procedure [dbo].[sp_col_dao_data_otros_aranceles]
	@opcion int = 0,
	@codtao int = 0,--TIPIFICACION DE ARANCELES
	@codper int = 0,
	@codhpl int = 0,
	@codpon int = 0,
	@codcil int = 0,
	@codpboa int = 0,
	@codtmo int = 0,

	@codusr int = 378,
	@coddao int = 0
as
begin
	set dateformat dmy

	if @opcion = -1 --Regresa las tipificacion de aranceles activos desde el portal UTEC
	begin
		select 0 'ta_codigo', ' Seleccione' 'ta_nombre'
		union
		select ta_codigo, ta_nombre from col_ta_tipificacion_arancel where ta_estado = 1
		and ta_codigo not in (4)
		order by 1
	end

	if @opcion = 0 --Regresa las tipificacion de aranceles activos
	begin
		select 0 'ta_codigo', ' Seleccione' 'ta_nombre'
		union
		select ta_codigo, ta_nombre from col_ta_tipificacion_arancel where ta_estado = 1
		order by 1
	end

	if @opcion = 1 --Regresa los aranceles correspondientes al @codtao
	begin 
		-- exec sp_col_dao_data_otros_aranceles  @opcion = 1, @codper = 173322, @codtao = 6
		declare @detalle_tipo_estudio as table(coddtde int, valor varchar(25))

		insert into @detalle_tipo_estudio
		exec sp_detalle_tipo_estudio_alumno @codper

		declare @detalle_tipo_estudio_xml varchar(max)
		set @detalle_tipo_estudio_xml = (select coddtde, valor from @detalle_tipo_estudio for xml path(''))
		print '@detalle_tipo_estudio_xml ' + cast(@detalle_tipo_estudio_xml as varchar(max))

		 if exists (select 1 from col_dpboa_definir_parametro_boleta_otros_aranceles inner join col_tmo_tipo_movimiento on tmo_codigo = dpboa_codtmo inner join col_ta_tipificacion_arancel on ta_codigo = dpboa_codta where dpboa_estado = 1 and ta_estado = 1 and ta_codigo = @codtao /*AGREGADO EL 16/08/2019 21:55:00 PARA PODER REALIZAR FILTROS MAS DETALLOS SEGUN CADA TIPO ALUMNO*/ and dpboa_coddtde = (select coddtde from @detalle_tipo_estudio) )
            select 0 'dpboa_codigo', ' Seleccione' 'texto',  '' dpboa_afecta_materia
			union
			select dpboa_codigo, concat(tmo_arancel, ' ', tmo_descripcion) 'texto', dpboa_afecta_materia from col_dpboa_definir_parametro_boleta_otros_aranceles 
            inner join col_tmo_tipo_movimiento on tmo_codigo = dpboa_codtmo 
            inner join col_ta_tipificacion_arancel on ta_codigo = dpboa_codta
            where dpboa_estado = 1 and ta_estado = 1 and ta_codigo = @codtao  
			and dpboa_coddtde = (select coddtde from @detalle_tipo_estudio)--AGREGADO EL 16/08/2019 21:55:00 PARA PODER REALIZAR FILTROS MAS DETALLOS SEGUN CADA TIPO ALUMNO
			and 1 = 
			case when dpboa_periodo = 1 then 
				case when (convert(date, getdate(), 103) between convert(date, dpboa_fecha_desde, 103) and convert(date, dpboa_fecha_hasta, 103)) then 1
				else 0
				end
			else 1 end
			--(dpboa_periodo = 1 and (convert(date, getdate(), 103) between convert(date, dpboa_fecha_desde, 103) and convert(date, dpboa_fecha_hasta, 103)))
			order by 1
        else 
			select '-1' 'dpboa_codigo', 'No hay aranceles' 'texto'
	end
	
	if @opcion = 2 --Devuelve si la tipificacion afecta materia
	begin
		select dpboa_afecta_materia, tmo_valor 
		from col_dpboa_definir_parametro_boleta_otros_aranceles inner join col_tmo_tipo_movimiento on dpboa_codtmo = tmo_codigo 
		where dpboa_codigo = @codpboa 
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
		
		declare @tmo_codigo int
		select @tmo_codigo = dpboa_codtmo from col_dpboa_definir_parametro_boleta_otros_aranceles 
		inner join col_ta_tipificacion_arancel on ta_codigo = dpboa_codta
		where dpboa_codigo = @codpboa and ta_aplica_boleta = 'SI'

		if (isnull(@tmo_codigo, 0) != 0)
		begin
			declare @montoAbono float
			select @montoAbono = Monto from @data			

			if not exists(select 1 from col_abp_anticipo_boleta_pago where abp_codper = @codper and abp_codcil = @codcil and abp_cuota = 0)--0: Cuando se crea genera la boleta desde la interfaz de "GENERAR BOLETAS ARANCELES ESPECIALES" por defecto toma el valor de 0
			begin
				insert into col_abp_anticipo_boleta_pago (abp_codper, abp_codcil, abp_codtmoAbono, abp_montoAbono, abp_codusr)
				values (@codper, @codcil, @tmo_codigo, @montoAbono, @codusr)

				exec tal_GenerarDataTalonarioPreGrado_porAlumno -1, 1, @codcil, @codcil, @codper	--	Elimina la data	
				exec tal_GenerarDataTalonarioPreGrado_porAlumno 2, 1, @codcil, @codcil, @codper		--	Inserta la data
			end
		end
	end

	if @opcion = 4
	begin
		-- exec dbo.sp_col_dao_data_otros_aranceles @opcion = 4, @codpboa = 149, @codcil = 125, @codper = 173322
		select dbo.fn_cumple_parametros_boleta_otros_aranceles(@codpboa, @codcil, -1, @codper)
	end

	if @opcion = 5 
	begin
		select abp_codper, per_carnet as Carnet, per_apellidos_nombres as Alumno, tmo.tmo_arancel ArancelAbono, 
			tmo.tmo_descripcion DescripcionAbono, abp_codtmoAbono, tmo2.tmo_arancel ArancelDescuento, 
			tmo2.tmo_descripcion DescripcionDescuento, abp_codtmoDescuento, cil_codigo, 
			cic_nombre + '-' + cast(cil_anio as nvarchar(4)) as ciclo
		from col_abp_anticipo_boleta_pago inner join 
			ra_per_personas on per_codigo = abp_codper left join 
			col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = abp_codtmoAbono left join
			col_tmo_tipo_movimiento as tmo2 on tmo2.tmo_codigo = abp_codtmoDescuento inner join
			ra_cil_ciclo on cil_codigo = abp_codcil inner join 
			ra_cic_ciclos on cic_codigo = cil_codcic
	end

	if @opcion = 6 --Devuelve la data para generar la boleta a cancelar de un codigo @coddao
	begin
		-- sp_col_dao_data_otros_aranceles @opcion = 6, @coddao = 3

		declare @data_dao table (
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
			fecha_creacion datetime default getdate()
		);
		insert into @data_dao (carnet, alumno, tmo_arancel, Monto, arancel, carrera, barra, npe, ciclo)
		exec tal_GenerarDataOtrosAranceles 2, @coddao

		select * from @data_dao
	end

	if @opcion = 7 --Regresa los aranceles correspondientes para el alumno en el portal
	begin 
		-- exec sp_col_dao_data_otros_aranceles  @opcion = 7, @codper = 173322
		--declare @detalle_tipo_estudio as table(coddtde int, valor varchar(25))

		insert into @detalle_tipo_estudio
		exec sp_detalle_tipo_estudio_alumno @codper

		--declare @detalle_tipo_estudio_xml varchar(max)
		set @detalle_tipo_estudio_xml = (select coddtde, valor from @detalle_tipo_estudio for xml path(''))
		print '@detalle_tipo_estudio_xml ' + cast(@detalle_tipo_estudio_xml as varchar(max))

		 if exists (select 1 from col_dpboa_definir_parametro_boleta_otros_aranceles inner join col_tmo_tipo_movimiento on tmo_codigo = dpboa_codtmo inner join col_ta_tipificacion_arancel on ta_codigo = dpboa_codta where dpboa_estado = 1 and ta_estado = 1 and dpboa_coddtde = (select coddtde from @detalle_tipo_estudio) )
            select 0 'dpboa_codigo', ' Seleccione' 'texto', 0 dpboa_afecta_materia
			union
			select dpboa_codigo, concat(ltrim(rtrim(tmo_descripcion)), ' ', tmo_arancel, ' ($', tmo_valor, ')') 'texto', dpboa_afecta_materia from col_dpboa_definir_parametro_boleta_otros_aranceles 
            inner join col_tmo_tipo_movimiento on tmo_codigo = dpboa_codtmo 
            inner join col_ta_tipificacion_arancel on ta_codigo = dpboa_codta
            where dpboa_estado = 1 and ta_estado = 1-- and ta_codigo = @codtao  
			and ta_codigo not in (4)
			and dpboa_coddtde = (select coddtde from @detalle_tipo_estudio)--AGREGADO EL 16/08/2019 21:55:00 PARA PODER REALIZAR FILTROS MAS DETALLOS SEGUN CADA TIPO ALUMNO
			and 1 = 
			case when dpboa_periodo = 1 then 
				case when (convert(datetime, getdate(), 103) between convert(datetime, dpboa_fecha_desde, 103) and convert(datetime, dpboa_fecha_hasta, 103)) then 1
				else 0
				end
			else 1 end
			--(dpboa_periodo = 1 and (convert(date, getdate(), 103) between convert(date, dpboa_fecha_desde, 103) and convert(date, dpboa_fecha_hasta, 103)))
			order by 2
        else 
			select '-1' 'dpboa_codigo', 'No hay aranceles' 'texto'
	end
end
go

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_col_daapl_datos_alu_pago_linea_estructurado]    Script Date: 22/11/2021 21:47:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	-- exec sp_col_daapl_datos_alu_pago_linea_estructurado '0313007500000023178800010208'

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

	declare @len int, @npe2 varchar(100)
	select @len = isnull(len(@npe), 0)
	print '@npe len: ' +cast(@len as varchar(10))
	if @len > 28 --Es BARRA el parametro @npe
	begin
		print 'se ingreso el codigo de BARRA'
		select @npe2 = dao_npe from col_dao_data_otros_aranceles where dao_barra = @npe
		set @npe = @npe2
	end
	--print '@barra: ' + cast(@barra as varchar(66))

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
				if @per_tipo = 'D'
				begin
					select top 1 per_nombres_apellidos alumno, per_carnet carnet, 
					dip_nombre carrera, 
					tmo_valor Monto, tmo_descripcion descripcion, 1 estado, @npe_original NPE 
					from col_dao_data_otros_aranceles 
						inner join ra_per_personas on per_codigo = dao_codper
						inner join col_dpboa_definir_parametro_boleta_otros_aranceles on dpboa_codigo = dao_coddpboa
						inner join col_tmo_tipo_movimiento on tmo_codigo = dpboa_codtmo
					
						inner join dip_ped_personas_dip on per_codigo = ped_codper
						inner join dip_dip_diplomados on ped_coddip = dip_codigo
						left join ra_fac_facultades on fac_codigo = dip_codfac
					where dao_npe = @npe_original order by dao_fecha_creacion desc
				end
				else
				begin
					select top 1 per_nombres_apellidos alumno, per_carnet carnet, pla_alias_carrera carrera, 
					tmo_valor Monto, tmo_descripcion descripcion, 1 estado, @npe_original NPE 
					from col_dao_data_otros_aranceles 
						inner join ra_per_personas on per_codigo = dao_codper
						inner join ra_alc_alumnos_carrera on per_codigo = alc_codper
						inner join ra_pla_planes on pla_codigo = alc_codpla
						inner join col_dpboa_definir_parametro_boleta_otros_aranceles on dpboa_codigo = dao_coddpboa
						inner join col_tmo_tipo_movimiento on tmo_codigo = dpboa_codtmo
					where dao_npe = @npe_original order by dao_fecha_creacion desc
				end
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
go


USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_insertar_encabezado_pagos_online_otros_aranceles_estructurado]    Script Date: 22/11/2021 21:48:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_insertar_encabezado_pagos_online_otros_aranceles_estructurado]
	-- =============================================
	-- Author:		<Juan Carlos Campos Rivera>
	-- Create date: <Viernes 31 Mayo 2019>
	-- Description:	<Aplicar pagos de otros aranceles en linea, es invocado en WS: realizarPagoRef(string codigo_barra, string referencia)>
	-- =============================================
	--	exec sp_insertar_encabezado_pagos_online_otros_aranceles_estructurado '0313002000000018028700204521', 12, '34788j78ssu25414'
	@barra varchar(180),
	@tipo int,
	@referencia varchar(50),
	@mov_codigo_generado int = 0 output --Si no se altera el valor de igual a 0, retorna el select 'IdGenerado', de lo contrario se toma como el retorno de un parametro de salida
as
begin
	set nocount on;
	set dateformat dmy

	declare @len int
	set @barra = replace(@barra, ' ', '')
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
	--select * from @data
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

			if (select per_estado from ra_per_personas where per_codigo = @codper) = 'E'
			begin
				print 'Es de la pre'
				--select @dmo_eval = 1
				select @dmo_eval = eval, @dmo_codmat = codmat from (
					select mpr_orden as eval, mpr_codigo as codmat from pg_mpr_modulo_preespecializacion where mpr_codigo = @codhpl
					union all
					select hm_modulo eval, hm_codigo codmat from pg_hm_horarios_mod where hm_codigo = @codhpl
				) t
			end


			if @exento = 'S'
			begin
				print '@exento = S'
				set @dmo_abono = @Monto
				set @dmo_cargo = @Monto
				set @dmo_valor = @Monto
				set @dmo_iva = 0

				if @cargo_abono = 1
				begin
					set @dmo_cargo = 0--@Monto
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
go


USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_insertar_pagos_x_carnet_estructurado]    Script Date: 22/11/2021 21:49:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:      <>
	-- Create date: <>
	-- Last modify: <Fabio, 2021-05-25 15:13:11.367, se agrego insert a BD Rinnovo>
	-- Description: <Inserta los pagos de banco en linea>
	-- =============================================
	-- exec sp_insertar_pagos_x_carnet_estructurado  '0313006300000022673760120216', 1, 'qqqq12354'

	-- exec sp_insertar_pagos_x_carnet_estructurado  '0313006300000023170360120216', 1, 'qqqq12357'

ALTER procedure [dbo].[sp_insertar_pagos_x_carnet_estructurado]
	@npe varchar(100),
	@tipo int,
	@referencia varchar(50)
as
begin
	set dateformat dmy

	declare @IdGeneradoPreviaPagoOnLine int	
	set @npe = replace(@npe, ' ', '')
	declare @codper_previo int
	select @codper_previo = cast(substring(@npe,11,10) as int) --	El codper inicia en la posicion 11 del npe
	
	declare @len int, @npe2 varchar(100)
	select @len = isnull(len(@npe), 0)
	print '@npe len: ' +cast(@len as varchar(10))
	if @len > 28 --Es BARRA el parametro @npe
	begin
		print 'se ingreso el codigo de BARRA'
		select @npe2 = dao_npe from col_dao_data_otros_aranceles where dao_barra = @npe
		if isnull(@npe2, 0) <> 0
			set @npe = @npe2
	end
	--print '@barra: ' + cast(@barra as varchar(66))

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
						--I-73: Inscripción al Seminario de Graduación Técnicos
						--I-74 o C-90: pago de la primera cuota
						--I-75 o C-91: pago de la segunda cuota
						--I-76 o C-92: pago de la tercera cuota
						--I-77 o C-93: pago de la cuarta cuota
						--I-78 o C-94: pago de la quinta cuota
						--E-03: Examen de seminario de graduacion
						PRINT 'alumno de CARRERA TECNICO diference de Diseño de de la pre especializacion'

						if (@arancel = 'I-73' or @arancel = 'I-74' or @arancel = 'C-90')
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

							if (@arancel = 'C-90')
							begin
								print 'pago de la primer cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'C-90'
								set @dmo_valor = @portafolio_tecnicos_pre
								set @dmo_abono = @portafolio_tecnicos_pre
								select @dmo_cargo = 0
							end --	if (@arancel = 'C-90')

						end	--	if (@arancel = 'I-73' or @arancel = 'I-74' or @arancel = 'C-90')
						else	--	--	if (@arancel = 'I-73' or @arancel = 'I-74' or @arancel = 'C-90')
						begin
							print 'pago de la segunda cuota en adelante, se verifica si hay recargo por mora'
							set @verificar_recargo_mora = 1
							set @dmo_valor = @portafolio_tecnicos_pre
							set @dmo_abono = @portafolio_tecnicos_pre
							set @dmo_cargo = 0

							--if (@arancel = 'I-75')
							--begin
							--	print 'pago de la segunda cuota'
							--	select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-75'
							--	--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-58'
							--end --	if (@arancel = 'I-75')
							--if (@arancel = 'I-76')
							--begin
							--	print 'pago de la tercera cuota'
							--	select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-76'
							--	--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-59'
							--end --	if (@arancel = 'I-76')
							--if (@arancel = 'I-77')
							--begin
							--	print 'pago de la cuarta cuota'
							--	select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-77'
							--	--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-60'
							--end --	if (@arancel = 'I-77')
							--if (@arancel = 'I-78')
							--begin
							--	print 'pago de la quinta cuota'
							--	select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-78'
							--	--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-61'
							--end --	if (@arancel = 'I-78')
							--if (@arancel = 'E-03')
							--begin
							--	print 'Examen de seminario de graduacion'
							--	select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'E-03'
							--end --	if (@arancel = 'E-03')

							select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel

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

						if (@arancel <> 'I-73') -- Si no es la matricula
						begin
							select  @dmo_cargo = tpmenara_monto_descuento * -1 from col_detmen_detalle_tipo_mensualidad
							inner join col_tpmenara_tipo_mensualidad_aranceles on detmen_codtpmenara = tpmenara_codigo
							where tpmenara_arancel = @arancel AND detmen_codper = @codper and detmen_codcil = @codcil
							set @dmo_cargo = isnull(@dmo_cargo, 0)
						end

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
							select @dmo_cargo = sum(isnull(tmo_valor,0)) + sum(isnull(monto_descuento, 0)) 
							from col_art_archivo_tal_proc_grad_tec_mora
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
				-- exec sp_insertar_pagos_x_carnet_estructurado  '0313004000000023178800012800', 1, 'xxxxx'
				declare @coddip int = 0, @per_carnet_anterior varchar(32) = '', @graduado_utec int = 0, @cil_codigo_vigente int = 0

				select @coddip = ped_coddip, @per_carnet_anterior = per_carnet_anterior 
				from dip_ped_personas_dip 
					inner join ra_per_personas on per_codigo = ped_codper
				where per_carnet = @carnet

				if (isnull(@per_carnet_anterior, '') != '')
				begin
					set @graduado_utec = 1
				end

				print 'Matricula de diplomados'
				select @dmo_cargo = sum(tmo_valor)
				from cil_cpd_cuotas_pagar_diplomado
					inner join col_tmo_tipo_movimiento on tmo_codigo = cpd_codtmo
					inner join col_dpboa_definir_parametro_boleta_otros_aranceles on dpboa_codtmo = cpd_codtmo
				where cpd_coddip = @coddip and cpd_graduado_utec = @graduado_utec

				select top 1 @cil_codigo_vigente = cil_codigo from ra_cil_ciclo where cil_vigente = 'S' order by cil_codigo desc
				set @dmo_valor = 0
				set @dmo_abono = 0
				set @dmo_codtmo = 162

				select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

				print 'if @arancel_especial = 1 '
				print '@npe_original: ' + cast(@npe_original as varchar(64))
				print '@tipo: ' + cast(@tipo as varchar(20))
				print '@referencia: ' + cast(@referencia as varchar(20))
				
				declare @codmov_generado int;  
				execute dbo.sp_insertar_encabezado_pagos_online_otros_aranceles_estructurado @npe_original, @tipo, @referencia, @mov_codigo_generado = @codmov_generado output

				if not exists (
					select 1 from col_mov_movimientos 
					inner join col_dmo_det_mov on dmo_codmov = mov_codigo 
					where mov_codper = @codper and dmo_codcil = @cil_codigo_vigente and dmo_codtmo = @dmo_codtmo
					and (@coddip > 0)
				) and @per_tipo = 'D'
				begin --Si no existe el C-30
					print 'Matricula de diplomados, no tiene asignado el C-30'
					select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
					exec dbo.col_dfpc_DetalleFacturaPagoCuotas 1,
					1, @codmov_generado, @dmo_codigo, @dmo_codtmo, 1, @dmo_valor, '', 0, 0, 
						0, @cil_codigo_vigente, @dmo_cargo, @dmo_abono, 0
				end
				--select @codmov_generado
				select '1' resultado, @codmov_generado Correlativo, 'Transacción generada de forma satisfactoria' as Descripcion
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
		values(@per_codigo, @npe, @cil_codigo, concat(error_message(), ' ,' , @mensaje), error_number(), 
		error_severity(), error_state(), error_procedure(), error_line())
		
		select '2' resultado, -1 as Correlativo, 'No se pudo generar la transacción' as Descripcion
		-- 2: Error algun dato incorrecto no guardo ningun cambio

	END CATCH

	--Inicio: Insert a Rinnovo 25/05/2021, ALTER 01/09/2021 09:15 a.m, SEGUNDA PRUEBA ALTER 12/10/2021 08:47 a.m.
	exec [192.168.1.132].UTEC_DBPRD.UTEC_COLLECTOR.SP_TEMP_PAGO_ONLINE
		@IDESTUDIANTE = @codper,  @IDFACTURA = @CorrelativoGenerado, @IDCICLO = @codcil
	--Fin: Insert a Rinnovo 25/05/2021, ALTER 01/09/2021 09:15 a.m, SEGUNDA PRUEBA ALTER 12/10/2021 08:47 a.m.

end

--select top 10 * from col_ert_error_transaccion order by ert_codigo desc
go


USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_anticipo_boleta_pago]    Script Date: 22/11/2021 21:50:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	-- =============================================
	-- Author:		<Adones Calles>
	-- Create date: <09/06/2020>
	-- Description:	<Definicion de anticipos de boletas de pago nuevo ingreso>
	-- =============================================
ALTER PROCEDURE [dbo].[sp_anticipo_boleta_pago]
	@opcion int = 0,
	@abp_codper int = 0,
	@abp_codcil int = 0,
	@arcAbono nvarchar(5) = '',
	@arcDesc nvarchar(5) = '',
	@abp_codusr int = 0,
	@abp_cuota int = 0,
	@abp_codigo int = 0,
	@busqueda nvarchar(50) = ''
as
begin
	set nocount on

	declare @abp_codtmoAbono int, @abp_montoAbono float, @abp_codtmoDescuento int, @abp_montoDescuento float

	if @opcion = 1
	begin
		select abp_codigo,per_codigo,abp_codcil,per_carnet,per_apellidos_nombres,tA.tmo_arancel arcAbono,isnull(tA.tmo_descripcion,'Sin Asignar') arcD_abono,abp_montoAbono,
			tD.tmo_arancel arcDesc,isnull(tD.tmo_descripcion,'Sin Asignar') arcD_desc,abp_montoDescuento,usr_usuario,abp_fecha_creacion
		from col_abp_anticipo_boleta_pago 
			inner join ra_per_personas on per_codigo = abp_codper
			left join col_tmo_tipo_movimiento tA on tA.tmo_codigo = abp_codtmoAbono
			left join col_tmo_tipo_movimiento tD on tD.tmo_codigo = abp_codtmoDescuento
			inner join adm_usr_usuarios on usr_codigo = abp_codusr
		where abp_codcil = @abp_codcil and (per_carnet like '%' + case when isnull(ltrim(rtrim(@busqueda)), '') = '' then ''                        
				else ltrim(rtrim(@busqueda)) + '%' end                        
				or per_apellidos_nombres like '%' + case when isnull(ltrim(rtrim(@busqueda)), '') = '' then '' 
				else ltrim(rtrim(@busqueda)) + '%' end                    
				or tA.tmo_arancel like '%' + case when isnull(ltrim(rtrim(@busqueda)), '') = '' then '' 
				else ltrim(rtrim(@busqueda)) + '%' end
				or tD.tmo_arancel like '%' + case when isnull(ltrim(rtrim(@busqueda)), '') = '' then ''
				else ltrim(rtrim(@busqueda)) + '%' end
				or abp_cuota like '%' + case when isnull(ltrim(rtrim(@busqueda)), '') = '' then ''
				else ltrim(rtrim(@busqueda)) + '%' end
				)
		order by abp_codigo desc
	end

	if @opcion = 2
	begin
		-- exec dbo.sp_anticipo_boleta_pago 2, 179747, 123, 'A-254', '', 407, 0, 1, ''
		-- delete from col_abp_anticipo_boleta_pago where abp_codper = 179747
		select @abp_codtmoAbono = tmo_codigo,@abp_montoAbono = round(tmo_valor,2) from col_tmo_tipo_movimiento where tmo_arancel = @arcAbono
		select @abp_codtmoDescuento = tmo_codigo, @abp_montoDescuento = round(tmo_valor,2) from col_tmo_tipo_movimiento where tmo_arancel = @arcDesc

		if not exists(select 1 from col_abp_anticipo_boleta_pago where abp_codper = @abp_codper and abp_codcil = @abp_codcil and abp_cuota = @abp_cuota)
		begin
			insert into col_abp_anticipo_boleta_pago (abp_codper, abp_codcil, abp_codtmoAbono, abp_montoAbono, abp_codtmoDescuento, abp_montoDescuento, abp_codusr, abp_cuota)
			values(@abp_codper, @abp_codcil, @abp_codtmoAbono, abs(@abp_montoAbono), @abp_codtmoDescuento, abs(@abp_montoDescuento), @abp_codusr, @abp_cuota)

			exec tal_GenerarDataTalonarioPreGrado_porAlumno -1, 1, @abp_codcil, @abp_codcil, @abp_codper	--	Elimina la data	
			exec tal_GenerarDataTalonarioPreGrado_porAlumno 2, 1, @abp_codcil, @abp_codcil, @abp_codper		--	Inserta la data

			/* Validando que sea el codigo del arancel de Abono de Matricula de $50. 00* y de anticipo de mensualidad */
			declare @dpoa_codigo int = 0
			select @dpoa_codigo = dpboa_codigo from col_dpboa_definir_parametro_boleta_otros_aranceles 
			inner join col_ta_tipificacion_arancel on ta_codigo = dpboa_codta
			where dpboa_codtmo = 3586 and ta_codigo = 4

			--exec dbo.sp_col_dao_data_otros_aranceles 3, @abp_codper, @abp_codcil, @dpoa_codigo, @abp_codusr
			exec dbo.sp_col_dao_data_otros_aranceles @opcion = 3, @codper = @abp_codper, @codcil = @abp_codcil, @codpboa = @dpoa_codigo, @codusr = @abp_codusr
		end
	end

	if @opcion = 3
	begin
		select @abp_codper = abp_codper, @abp_codcil = abp_codcil from col_abp_anticipo_boleta_pago where abp_codigo = @abp_codigo

		select @abp_codtmoAbono = tmo_codigo, @abp_montoAbono = round(tmo_valor,2) from col_tmo_tipo_movimiento where tmo_arancel = @arcAbono
		select @abp_codtmoDescuento = tmo_codigo, @abp_montoDescuento = round(tmo_valor,2) from col_tmo_tipo_movimiento where tmo_arancel = @arcDesc

		update col_abp_anticipo_boleta_pago set abp_codtmoAbono = @abp_codtmoAbono, abp_montoAbono = abs(@abp_montoAbono), 
				abp_codtmoDescuento = @abp_codtmoDescuento,
				abp_montoDescuento =abs(@abp_montoDescuento), abp_cuota = @abp_cuota
		where abp_codigo = @abp_codigo

		exec tal_GenerarDataTalonarioPreGrado_porAlumno -1, 1, @abp_codcil, @abp_codcil, @abp_codper	--	Elimina la data	
		exec tal_GenerarDataTalonarioPreGrado_porAlumno 2, 1, @abp_codcil, @abp_codcil, @abp_codper		--	Inserta la data
	end 

	if @opcion = 4
	begin
		select @abp_codper = abp_codper, @abp_codcil = abp_codcil from col_abp_anticipo_boleta_pago where abp_codigo = @abp_codigo
		delete from col_abp_anticipo_boleta_pago where abp_codigo = @abp_codigo
		
		exec tal_GenerarDataTalonarioPreGrado_porAlumno -1, 1, @abp_codcil, @abp_codcil, @abp_codper	--	Elimina la data	
		exec tal_GenerarDataTalonarioPreGrado_porAlumno 2, 1, @abp_codcil, @abp_codcil, @abp_codper		--	Inserta la data
	end

	if @opcion = 5
	begin
		select * from col_art_archivo_tal_mora where  ciclo = 123 and per_codigo in (173322, 181324, 182420) and fel_codigo_barra = 1
		select * from col_abp_anticipo_boleta_pago
		select * from col_art_archivo_tal_mora where monto_descuento <> 0 -- ciclo = 123 and per_codigo in (173322, 181324, 182420) and fel_codigo_barra = 1
		--update col_art_archivo_tal_mora set codtmo_descuento = abp_codtmoDescuento, 
		--	monto_descuento = 0,
		--	monto_arancel_descuento = abs(abp_montoDescuento)
		--from col_art_archivo_tal_mora inner join col_abp_anticipo_boleta_pago on
		--abp_codcil = ciclo and abp_codper = per_codigo
		--where fel_codigo_barra = 1 and abp_codcil = 123
	end

	if @opcion = 6
	begin
		-- sp_anticipo_boleta_pago @opcion = 6, @abp_codigo = 5
		declare @dao_codigo int = 0

		select top 1 @dao_codigo = dao_codigo from col_dao_data_otros_aranceles 
		inner join col_abp_anticipo_boleta_pago on dao_codper = dao_codper
		inner join col_dpboa_definir_parametro_boleta_otros_aranceles on dpboa_codigo = dao_coddpboa
		where abp_codigo = @abp_codigo and dpboa_codtmo = 3586 and dpboa_codta = 4 and abp_codper = dao_codper and isnull(abp_codtmoAbono, 0) <> 0
		order by dao_codigo desc

		exec dbo.sp_col_dao_data_otros_aranceles @opcion = 6, @coddao = @dao_codigo
	end
end
go


USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[tal_GenerarDataTalonarioPreGrado_porAlumno]    Script Date: 22/11/2021 21:51:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:		<Author,,Name>
	-- Create date: <Create Date,,>
	-- Description:	<Generar Data de Talonario de PreGrado>
	-- =============================================
	--	exec tal_GenerarDataTalonarioPreGrado_porAlumno -1, 1, 123, 123, 173322	--	Elimina la data de los talonarios
	--	exec tal_GenerarDataTalonarioPreGrado_porAlumno  0, 1, 120, 119, 227533	--	Verifica si existe la data generada
	--	exec tal_GenerarDataTalonarioPreGrado_porAlumno  1, 1, 126, 126, 208529	--	Datos previos
	--	exec tal_GenerarDataTalonarioPreGrado_porAlumno  2, 1, 123, 123, 173322	--	Inserta la data para los talonarios

ALTER PROCEDURE [dbo].[tal_GenerarDataTalonarioPreGrado_porAlumno]
	@Opcion int,
	@codreg int,
	@codcilGenerar int,
	@codcilBaseParaGenerar int,
	--@fecha nvarchar(10),
	@codper int
AS
BEGIN
	SET NOCOUNT ON;
	declare @cantidad int
	declare @carnet nvarchar(15)
	declare @anio_carnet nvarchar(4)


	set dateformat dmy

	if @opcion = -1
	begin
		--	select * from col_art_archivo_tal_mora where per_codigo = @Codper and ciclo = @CodCilGenerar
		delete from col_art_archivo_tal_mora where per_codigo = @Codper and ciclo = @CodCilGenerar
		print 'Registro eliminado'
	end

	if @opcion = 0
	begin
		--Select @cantidad = count(per_codigo) from col_art_archivo_tal_mora where per_codigo = @codper and ciclo = @codcilGenerar
		--if @cantidad = 0
		if not exists(Select 1 from col_art_archivo_tal_mora where per_codigo = @Codper and ciclo = @CodCilGenerar)
		begin
			print 'El alumno NO posee data generada de los talonarios'
		end
		else
		begin
			print 'El alumno YA posee data generada de los talonarios'
		end
	end	--	if @opcion = 0

	if (@opcion = 1 or @opcion = 2)
	begin
		select @carnet = per_carnet 
		from ra_per_personas where per_codigo = @codper and per_tipo = 'U'
		
		set @anio_carnet = substring(@carnet, 9 , 4)

		print @carnet
		print @anio_carnet

		if exists (select 1 from ra_per_personas join col_detmen_detalle_tipo_mensualidad on per_codigo = detmen_codper 
					where detmen_codcil = @CodCilGenerar and per_carnet = @carnet)
		begin
			--GENERA DATA POR ALUMNO DE PREGRADO ESPECIAL(BECADO)
			print 'Alumno posee mensualidad especial'
			exec tal_GenerarDataTalonarioPreGrado_porAlumno_Especial @Opcion, @codreg, @codcilGenerar, @codcilGenerar, @codper
								
		end	--	if exists (select 1 from ra_per_personas join col_detmen_detalle_tipo_mensualidad on per_codigo = detmen_codper where detmen_codcil = @CodCilGenerar and per_carnet = @carnet)
		else--	if exists (select 1 from ra_per_personas join col_detmen_detalle_tipo_mensualidad on per_codigo = detmen_codper where detmen_codcil = @CodCilGenerar and per_carnet = @carnet)
		begin
			print 'Alumno no posee mensualidad especial'

			declare @mtipo int ,@mglobal int --,@cod_arancel1 int, @cod_arancel2 int
			--con pagos o sin pagos
			set @codreg = 1 
			set @mtipo = 0 
			set @mglobal = 0
			set @mtipo =0

			declare @corr int
			select @corr = isnull(max(art_codigo),0)
			from col_art_archivo_tal_mora

			Declare @Datos TABLE (
				[per_codigo] [int] NOT NULL,
				[per_carnet] [varchar](50) NOT NULL,
				[ciclo] [int] NULL,
				[pla_alias_carrera] [varchar](100) NULL,
				[per_nombres_apellidos] [varchar](201) NOT NULL,
				[c415] [varchar](3) NOT NULL,
				[cc415] [varchar](13) NOT NULL,
				[c3902] [varchar](4) NOT NULL,
				[cc3902] [varchar](10) NULL,
				[c96] [varchar](2) NOT NULL,
				[cc96] [varchar](34) NULL,
				[c8020] [varchar](4) NOT NULL,
				[cc8020] [varchar](72) NULL,
				[barra] [varchar](142) NULL,
				[NPE] [varchar](83) NULL,
				[c415M] [varchar](3) NOT NULL,
				[cc415M] [varchar](13) NOT NULL,
				[c3902M] [varchar](4) NOT NULL,
				[cc3902M] [varchar](10) NULL,
				[c96M] [varchar](2) NOT NULL,
				[cc96M] [varchar](34) NULL,
				[c8020M] [varchar](4) NOT NULL,
				[cc8020M] [varchar](72) NULL,
				[BARRA_MORA] [varchar](142) NULL,
				[NPE_MORA] [varchar](83) NULL,
				[tmo_valor] [numeric](19, 2) NULL,
				[fel_fecha] [datetime] NOT NULL,
				[tmo_arancel] [varchar](5) NULL,
				[fel_fecha_mora] [datetime] NOT NULL,
				[fel_codigo_barra] [int] NULL,
				[papeleria] [numeric](3, 2)  NULL,
				[tmo_valor_mora] [numeric](19, 2) NULL,
				[matricula] [numeric](18, 2) NULL,
				[mciclo] [varchar](62) NULL,				
				cod_carrera nvarchar(4),
				codtmo_descuento int,
				monto_descuento numeric(19,2),
				monto_arancel_descuento numeric(18, 2)
			) 

			Declare @Datos2 TABLE (
				[art_codigo] [bigint] NULL,
				[fecha] [datetime] NOT NULL,
				[limite] [datetime] NULL,
				[per_codigo] [int] NOT NULL,
				[per_carnet] [varchar](50) NOT NULL,
				[ciclo] [int] NULL,
				[pla_alias_carrera] [varchar](100) NULL,
				[per_nombres_apellidos] [varchar](201) NOT NULL,
				[c415] [varchar](3) NOT NULL,
				[cc415] [varchar](13) NOT NULL,
				[c3902] [varchar](4) NOT NULL,
				[cc3902] [varchar](10) NULL,
				[c96] [varchar](2) NOT NULL,
				[cc96] [varchar](34) NULL,
				[c8020] [varchar](4) NOT NULL,
				[cc8020] [varchar](72) NULL,
				[barra] [varchar](142) NULL,
				[NPE] [varchar](83) NULL,
				[c415M] [varchar](3) NOT NULL,
				[cc415M] [varchar](13) NOT NULL,
				[c3902M] [varchar](4) NOT NULL,
				[cc3902M] [varchar](10) NULL,
				[c96M] [varchar](2) NOT NULL,
				[cc96M] [varchar](34) NULL,
				[c8020M] [varchar](4) NOT NULL,
				[cc8020M] [varchar](72) NULL,
				[BARRA_MORA] [varchar](142) NULL,
				[NPE_MORA] [varchar](83) NULL,
				[tmo_valor] [numeric](19, 2) NULL,
				[fel_fecha] [datetime] NOT NULL,
				[tmo_arancel] [varchar](5) NULL,
				[fel_fecha_mora] [datetime] NOT NULL,
				[fel_codigo_barra] [int] NULL,
				[papeleria] [numeric](3, 2)  NULL,
				[tmo_valor_mora] [numeric](19, 2) NULL,
				[matricula] [numeric](18, 2) NULL,
				[mciclo] [varchar](62) NULL
			) 


			declare @tipo_carrera nvarchar(25)
			declare @codvac int

			select @tipo_carrera =
			--car_nombre,
				--per_carnet, per_codigo, per_nombres_apellidos, per_codvac, 
			--car_nombre--car_tipo, car_identificador, per_tipo_ingreso, 
				case when car_nombre not like '%no presencial%' then 'Presencial' 
					when car_nombre like '%no presencial%' then 'No Presencial'
				end
			from ra_per_personas inner join ra_car_carreras on
				car_identificador = substring(per_carnet,1,2) 
			where per_tipo = 'U' and per_codigo = @codper

			print '@tipo_carrera : ' + @tipo_carrera


			IF exists ( Select 1
						from tal_tp_anio_virtual_data
						where tp_tipo = 'PREGRADO' and @tipo_carrera = 'No Presencial' and tp_anio = @anio_carnet and tp_codvac = 2
					)
			begin
				select @codvac = tp_codvac from tal_tp_anio_virtual_data
				where tp_tipo = 'PREGRADO' and tp_anio = @anio_carnet

				print 'asignando @codvac = ' + cast(@codvac as nvarchar(5))

				update ra_per_personas set per_codvac = @codvac
				where per_codigo = @codper and per_tipo = 'U'		
			end

			--select * from tal_tp_anio_virtual_data

			--if @tipo_carrera = 'Presencial'
			--begin
			--	update ra_per_personas set per_codvac = 1 where per_codigo = @codper and @tipo_carrera = 'Presencial'
			--end

			--if @tipo_carrera = 'No Presencial'
			--begin
			--	update ra_per_personas set per_codvac = 2 where per_codigo = @codper and @tipo_carrera = 'No Presencial'
			--end	


			--If @Opcion = 1	-- Data que sirve de base para generar el siguiente ciclo
			--Begin

				--****************************************************GENERACION DE TALONARIOS MORA******************************************************************--
				--**********************************************************************************************************************************************--

			Insert Into @Datos (per_codigo, per_carnet, ciclo, pla_alias_carrera, per_nombres_apellidos, c415, cc415, c3902, cc3902, c96,
				cc96, c8020, cc8020, barra, NPE, c415M, cc415M, c3902M, cc3902M, c96M, cc96M, c8020M, cc8020M, BARRA_MORA, NPE_MORA, tmo_valor, fel_fecha, tmo_arancel,
				fel_fecha_mora, fel_codigo_barra, ---papeleria, 
				tmo_valor_mora, matricula, mciclo, cod_carrera, codtmo_descuento, monto_descuento, monto_arancel_descuento)

				select per_codigo , per_carnet, ciclo,
						 pla_alias_carrera, per_nombres_apellidos,
						 c415,cc415,c3902,cc3902,c96,cc96,c8020,cc8020,
						 c415+cc415+c3902+cc3902+c96+cc96+c8020+cc8020 barra,
						 npe+dbo.fn_verificador_npe(NPE) NPE,

						 c415M,cc415M,c3902M,cc3902M,c96M,cc96M,c8020M,cc8020M,
						 c415M+cc415M+c3902M+cc3902M+c96M+cc96M+c8020M+cc8020M BARRA_MORA,
						 npe_mora+dbo.fn_verificador_npe(NPE_MORA) NPE_MORA,

						 tmo_valor, fel_fecha,tmo_arancel,fecha_mora,fel_codigo_barra,--papeleria,
						 CASE  WHEN fel_codigo_barra <= 2 THEN  tmo_valor_mora ELSE tmo_valor_mora END tmo_valor_mora,matricula, mciclo, substring(per_carnet,1,2) as carrera,
						 codtmo_descuento, monto_descuento, monto_arancel_descuento
						 --,per_codvac , fel_codvac
						 --into migraciondata
			from
				(
					select per_codigo, per_carnet, @codcilGenerar ciclo,
					--substring(pla_alias_carrera,1,55) pla_alias_carrera,per_nombres_apellidos,'415' c415,
					--le agrego mas longitud al substring de alias de carrera
					substring(pla_alias_carrera,1,100) pla_alias_carrera,per_nombres_apellidos,
					'415' c415, 
					'7419700003137' cc415,
					'3902' c3902,
					right('00000000'+cast(floor(CASE fel_codigo_barra WHEN 1 THEN fel_valor - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																		from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = per_codigo and abp_codcil =  @codcilGenerar and abp_cuota = 0),0)
																			ELSE fel_valor END ) as varchar),8) + 
					right('00'+cast((CASE fel_codigo_barra WHEN 1 
																THEN fel_valor - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																		from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = per_codigo and abp_codcil =  @codcilGenerar and abp_cuota = 0),0)
																ELSE fel_valor END  - floor(CASE fel_codigo_barra 
					WHEN 1 
						THEN fel_valor - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																		from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = per_codigo and abp_codcil =  @codcilGenerar and abp_cuota = 0),0)
						ELSE fel_valor END )) as varchar),2) cc3902,	
					'96' c96,	
					cast(year(fel_fecha) as varchar)+right('00'+cast(month(fel_fecha) as varchar),2)+right('00'+cast(day(fel_fecha) as varchar),2) cc96,
					'8020' c8020,
					REPLICATE('0',10-len(cast(ra_per_personas.per_codigo as nvarchar(10)))) + cast(ra_per_personas.per_codigo as nvarchar(10)) +cast(fel_codigo_barra as varchar)+
					right('00'+cast(cil_codcic as varchar),2)+cast(cil_anio as varchar) cc8020,
					'0313'+right('0000'+cast(floor(CASE fel_codigo_barra WHEN 1 
																			THEN fel_valor - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																				from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = per_codigo and abp_codcil =  @codcilGenerar and abp_cuota = 0),0)
																			ELSE fel_valor END ) as varchar),4) + 
					right('00'+cast((CASE fel_codigo_barra WHEN 1 
															THEN fel_valor - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																		from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = per_codigo and abp_codcil =  @codcilGenerar and abp_cuota = 0),0) 
															ELSE fel_valor END  - floor(CASE fel_codigo_barra WHEN 1 
																												THEN fel_valor - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																														from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = per_codigo and abp_codcil =  @codcilGenerar and abp_cuota = 0),0)
																												ELSE fel_valor END )) as varchar),2)+ 
					REPLICATE('0',10-len(cast(ra_per_personas.per_codigo as nvarchar(10)))) + cast(ra_per_personas.per_codigo as nvarchar(10)) + cast(fel_codigo_barra as varchar)+
					right('00'+cast(cil_codcic as varchar),2)+cast(cil_anio as varchar) NPE,
			----************************************************************************************************************************************************************
			---																		VALORES CON MORA
			----************************************************************************************************************************************************************
					'415' c415M, 
					'7419700003137' cc415M,
					'3902' c3902M,	
					right('00000000'+cast(floor(CASE fel_codigo_barra WHEN 1 
																			THEN fel_valor_mora - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																					from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = per_codigo and abp_codcil =  @codcilGenerar and abp_cuota = 0),0) 
																			ELSE fel_valor_mora END ) as varchar),8) + 
					right('00'+cast((CASE fel_codigo_barra WHEN 1 
																THEN fel_valor_mora - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																		from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = per_codigo and abp_codcil =  @codcilGenerar and abp_cuota = 0),0) 
																ELSE fel_valor_mora END  - floor(CASE fel_codigo_barra 
					WHEN 1 THEN fel_valor_mora - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																		from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = per_codigo and abp_codcil =  @codcilGenerar and abp_cuota = 0),0)
							ELSE fel_valor_mora END )) as varchar),2) cc3902M,
					'96' c96M,
					cast(year(fel_fecha_mora) as varchar)+right('00'+cast(month(fel_fecha_mora) as varchar),2)+right('00'+cast(day(fel_fecha_mora) as varchar),2) cc96M,
					'8020' c8020M,
					REPLICATE('0',10-len(cast(ra_per_personas.per_codigo as nvarchar(10)))) + cast(ra_per_personas.per_codigo as nvarchar(10)) + cast(fel_codigo_barra as varchar)+
					right('00'+cast(cil_codcic as varchar),2)+cast(cil_anio as varchar) cc8020M,
					'0313'+right('0000'+cast(floor(CASE fel_codigo_barra WHEN 1 
																			THEN fel_valor_mora - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																					from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = per_codigo and abp_codcil =  @codcilGenerar and abp_cuota = 0),0) 
																			ELSE fel_valor_mora END ) as varchar),4) + 
					right('00'+cast((CASE fel_codigo_barra WHEN 1 
																THEN fel_valor_mora - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																		from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = per_codigo and abp_codcil =  @codcilGenerar and abp_cuota = 0),0)
																ELSE fel_valor_mora END  - floor(CASE fel_codigo_barra WHEN 1 
																															THEN fel_valor_mora - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																																	from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = per_codigo and abp_codcil =  @codcilGenerar and abp_cuota = 0),0)
																															ELSE fel_valor_mora END )) as varchar),2) + 
					REPLICATE('0',10-len(cast(ra_per_personas.per_codigo as nvarchar(10)))) + cast(ra_per_personas.per_codigo as nvarchar(10)) 
					+cast(fel_codigo_barra as varchar)+
					right('00'+cast(cil_codcic as varchar),2)+cast(cil_anio as varchar) NPE_MORA,
					CASE fel_codigo_barra WHEN 1 
												THEN fel_valor - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																		from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = per_codigo and abp_codcil =  @codcilGenerar and abp_cuota = 0),0)
												ELSE fel_valor END tmo_valor 
					,fel_fecha,tmo_arancel,fel_fecha_mora fecha_mora,fel_codigo_barra,
					--CASE fel_codigo_barra WHEN 1 THEN  5.75 ELSE 0.0 END papeleria,
					CASE fel_codigo_barra WHEN 1 
												THEN fel_valor_mora - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																		from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = per_codigo and abp_codcil =  @codcilGenerar and abp_cuota = 0),0) 
												ELSE fel_valor_mora END tmo_valor_mora, 
					CASE fel_codigo_barra WHEN 1 
												THEN  fel_valor - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																		from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = per_codigo and abp_codcil =  @codcilGenerar and abp_cuota = 0),0) 
												ELSE 0.0 END matricula,
					'0'+cast(cil_codcic as varchar)+'-'+cast(cil_anio as varchar) mciclo,
						NULL as codtmo_descuento, NULL as monto_descuento, NULL as monto_arancel_descuento
					--,ra_per_personas.per_codvac , col_fel_fechas_limite.fel_codvac
					from ra_per_personas
					--join @mov on mov_codper = per_codigo
					join ra_alc_alumnos_carrera on alc_codper = per_codigo
					join ra_pla_planes on pla_codigo = alc_codpla
					join ra_car_carreras on car_codigo = pla_codcar
					join col_fel_fechas_limite on fel_codcil = @CodCilGenerar 


					join col_tmo_tipo_movimiento on tmo_codigo = fel_codtmo
					join ra_cil_ciclo on cil_codigo = fel_codcil and ra_per_personas.per_codvac = col_fel_fechas_limite.fel_codvac

					where -- fel_global=@mglobal and 
						per_codigo = @Codper --in (146532, 153330, 187161, 186636,186715, 146352, 187071)
						and @codper not in (select distinct per_codigo from col_art_archivo_tal_mora where per_codigo = @codper and ciclo = @codcilGenerar)
					--and fel_codcil = @codcilGenerar 
					and per_tipo = 'U' and fel_codtipmen is null
				) q

			--order by per_carnet, fel_codigo_barra asc

						--select * from col_fel_fechas_limite where fel_codcil = 119 and fel_codvac = 2

			--End	--	If @Opcion = 1	-- Data que sirve de base para generar el siguiente ciclo
			--select * from col_tipmen_tipo_mensualidad
			--select tmo_codigo,* from col_tpmenara_tipo_mensualidad_aranceles, col_tmo_tipo_movimiento where tmo_arancel = tpmenara_arancel
			/*select tmo_codigo,tmo_arancel from col_tmo_tipo_movimiento where tmo_arancel like 'V-%' group by tmo_arancel, tmo_codigo 

			select * from col_fel_fechas_limite where fel_codcil = 119 and fel_codvac = 2 and isnull(fel_codtipmen, 0) = 0 order by fel_Valor asc
			select * from ra_vac_valor_cuotas
			select * from col_fel_fechas_limite where fel_codcil = 119 and fel_codvac = 2
		
			select * from col_tpmenara_tipo_mensualidad_aranceles where tpmenara_codtipmen = 5
			alter table col_fel_fechas_limite add fel_codtipmen int foreign key references col_tipmen_tipo_mensualidad
			*/
			update @Datos Set pla_alias_carrera =  car_nombre 
			From ra_car_carreras inner join @Datos on cod_carrera = car_identificador
		
			--	Validando para determinar si la matricula posee descuentos
			if exists(select 1 from col_abp_anticipo_boleta_pago where abp_codcil = @codcilGenerar and abp_codper = @codper and abp_cuota = 0)
			begin
				update @Datos set codtmo_descuento = abp_codtmoDescuento, 
					monto_descuento = 0,
					monto_arancel_descuento = abs(abp_montoDescuento)
				from @Datos inner join col_abp_anticipo_boleta_pago on
					abp_codcil = ciclo and abp_codper = per_codigo
				where fel_codigo_barra = 1 and abp_codcil = @codcilGenerar
				and abp_codper = @codper
			end	--	if exists(select 1 from col_abp_anticipo_boleta_pago where abp_codcil = @codcilGenerar and abp_codper = @codper and abp)
		

			--select * from @Datos

			if @opcion = 1
			begin
				select per_codigo, per_carnet, ciclo, pla_alias_carrera, per_nombres_apellidos, c415, cc415, c3902, cc3902, c96, cc96, c8020,
					cc8020, barra, NPE, c415M, cc415M, c3902M, cc3902M, c96M, cc96M, c8020M, cc8020M, BARRA_MORA, NPE_MORA, tmo_valor, fel_fecha, tmo_arancel, fel_fecha_mora,
					fel_codigo_barra, tmo_valor_mora, matricula, mciclo, codtmo_descuento, monto_descuento, monto_arancel_descuento
				from @Datos
			end	--	if @opcion = 1

			if @opcion = 2
			begin
				Insert into col_art_archivo_tal_mora (per_codigo, per_carnet, ciclo, pla_alias_carrera, per_nombres_apellidos, 
				--c415, cc415, c3902, cc3902, c96, cc96, c8020, cc8020, 
				barra, NPE,-- c415M, cc415M, c3902M, cc3902M, c96M, cc96M, c8020M, cc8020M, 
				BARRA_MORA, NPE_MORA, tmo_valor, fel_fecha, tmo_arancel, fel_fecha_mora,
					fel_codigo_barra, tmo_valor_mora, matricula, mciclo, codtmo_descuento, monto_descuento, monto_arancel_descuento)
				select per_codigo, per_carnet, ciclo, pla_alias_carrera, per_nombres_apellidos, 
				--c415, cc415, c3902, cc3902, c96, cc96, c8020, cc8020, 
				barra, NPE,-- c415M, cc415M, c3902M, cc3902M, c96M, cc96M, c8020M, cc8020M, 
				BARRA_MORA, NPE_MORA, tmo_valor, fel_fecha, tmo_arancel, fel_fecha_mora,
					fel_codigo_barra, tmo_valor_mora, matricula, mciclo, codtmo_descuento, monto_descuento, monto_arancel_descuento
				from  @Datos

				--select * from col_art_archivo_tal_mora where art_codigo > @corr
			end	--	if @opcion = 2
		end	--	if exists (select 1 from ra_per_personas join col_detmen_detalle_tipo_mensualidad on per_codigo = detmen_codper where detmen_codcil = @CodCilGenerar and per_carnet = @carnet)
	end	--	--	if (@opcion = 1 or @opcion = 2)

END

