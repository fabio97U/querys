/*select top 10 tmo_arancel + '-' + tmo_descripcion, tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel <> ''

select * from col_tmo_tipo_movimiento
select top 10 * from col_tmo_tipo_movimiento where tmo_arancel = 'A-01'
update col_tmo_tipo_movimiento set tmo_afecta_materia = 'S', tmo_cupo = '100', tmo_fecha_desde = '2019-05-15', tmo_fecha_hasta = '2019-05-25' where tmo_codigo = '1'

select count(1) as cantidad, dmo_codtmo, tmo_arancel, tmo_descripcion from col_dmo_det_mov inner join col_tmo_tipo_movimiento on dmo_codtmo = tmo_codigo
where year(dmo_fecha_registro) in(2016,2017,2018,2019) group by dmo_codtmo,  tmo_arancel, tmo_descripcion
order by cantidad desc

select 'N' 'value', 'No' 'texto' union select 'S', 'Si'
select ta_codigo, concat(ta_nombre, ' (', case ta_estado when 1 then 'activa' else 'inactiva' end, ')') 'texto' from col_ta_tipificacion_arancel
select * from col_ta_tipificacion_arancel
select 'N', 'No' union select 'S', 'Si'

update col_tmo_tipo_movimiento set tmo_cupo = '{2}' where tmo_codigo = '{0}'
select * from col_ta_tipificacion_arancel*/

-- drop table col_dtde_detalle_tipo_estudio
create table col_dtde_detalle_tipo_estudio(
	dtde_codigo int primary key identity(1,1),
	dtde_codtde int foreign key references ra_tde_TipoDeEstudio,
	dtde_nombre varchar(155),
	dtde_valor varchar(5),
	dtde_descripcion varchar(255),
	dtde_fecha_creacion datetime default getdate()
)
-- select * from col_dtde_detalle_tipo_estudio
-- select * from ra_tde_TipoDeEstudio
insert into col_dtde_detalle_tipo_estudio(dtde_codtde, dtde_nombre, dtde_valor, dtde_descripcion)
values (1, 'Pregrado', 'P', 'Estos son los alumnos NO TECNICOS que estan cursando materias del pensum'), (1, 'Pregrado-Tecnico', 'PT', 'Estos son los alumnos TECNICOS que estan cursando materias del pensum'), (1, 'Pregrado-Preespecialidad', 'PP', 'Estos son los alumnos NO TECNICOS que estan en el proceso de preespecialidad'), (1, 'Pregrado-Preespecialidad-Tecnico', 'PPT', 'Estos son los alumnos TECNICOS que estan en el proceso de preespecialidad'), 
(2,'Maestrias', 'M', 'Estos son los alumnos de maestrias que estan cursando materias del pensum'), (2,'Maestrias-Preespecialidad', 'MP', 'Estos son los alumnos de maestrias que estan cursando el proceso de graduacion'), 
(6, 'CursosEspecializados', 'CE', 'Estos son los alumnos de cursos especializados'), (3, 'Postgrado', 'O', 'Estos son los alumnos de postgrado')
-- sp_col_dao_data_otros_aranceles 1, 1, 221782, 0, 0, 0, 0 --

ALTER procedure [dbo].[sp_detalle_tipo_estudio_alumno]
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-08-16 16:50:51.747>
	-- Description: <Devuelve el codigo y valor de la tabla "col_dtde_detalle_tipo_estudio"(la tabla almacena de forma mas detallada los diferentes procesos de cada tipo de estudio) >
	-- =============================================
	-- sp_detalle_tipo_estudio_alumno 221782
	@codper int
as
begin
	/*
	LOS VALORES QUE CONCATENA tipo_alumno_compuesto: concat(per_tipo+'_'+per_estado+':'+car_tipo)
	{
		"U_A:C": "PREGRADO CARRERA NO TECNICA					181324 25-1565-2015",
		"U_A:T": "PREGRADO CARRERA TECNICA						221782 60-5229-2019",
		"U_E:C": "PREGRADO Egresado CARRERA NO TECNICA			170327 25-0809-2014",
		"U_E:T": "PREGRADO Egresado TECNICO PREESPECIALIDAD		 47661 06-0854-2016",
		"M_A:M": "MAESTRIAS										210824 43-0055-2018",
		"M_E:M": "MAESTRIAS EGRESADO							202330 43-0132-2017",
		"CE": "CURSO ESPECIALIZADOS								SIN DEFINIR			",
		"O": "POSTGRADO											SIN DEFINIR			"
	}*/	
	declare @tbl_posibles_resultados as table(tipo_alumno_compuesto varchar(25), dtde_valor varchar(5))
	--ESTA TABLA ALMANCENA LOS UNICOS VALORES POSIBLES DEL ESTADO QUE PUEDE TENER UN ALUMNO, ADEMAS ALAMCENA EL VALOR dtde_valor(REFERENTE A LA TABLA col_dtde_detalle_tipo_estudio)
	insert into @tbl_posibles_resultados (tipo_alumno_compuesto, dtde_valor)
	values	('U_A:C', 'P'), ('U_A:T', 'PT'), ('U_E:C', 'PP'), ('U_E:T', 'PPT'), 
			('M_A:M', 'M'), ('M_E:M', 'MP'), 
			('CE', 'CE'), ('O', 'O')

	declare @tipo_alumno_compuesto varchar(50) = '0'
	if exists (select per_tipo from ra_per_personas where per_codigo = @codper) 
	begin
		select  @tipo_alumno_compuesto = (per_tipo+'_'+per_estado+':'+car_tipo)
		from ra_per_personas, ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras 
		where per_codigo = @codper and per_codigo = alc_codper 
		and alc_codpla = pla_codigo and pla_codcar = car_codigo 
	end

	print '@tipo_alumno_compuesto ' + cast(@tipo_alumno_compuesto as varchar(50))

	select t.dtde_codigo, r.dtde_valor from @tbl_posibles_resultados as r
	inner join col_dtde_detalle_tipo_estudio as t on  r.dtde_valor = t.dtde_valor
	where tipo_alumno_compuesto = @tipo_alumno_compuesto
end

-- drop table col_dpboa_definir_parametro_boleta_otros_aranceles
create table col_dpboa_definir_parametro_boleta_otros_aranceles(
	dpboa_codigo int primary key identity(1,1),
	dpboa_codtmo int foreign key references col_tmo_tipo_movimiento,
	dpboa_afecta_materia int,
	dpboa_cupo_vencimiento int,
	dpboa_fecha_vencimiento nvarchar(12),
	dpboa_periodo int,
	dpboa_fecha_desde nvarchar(12),
	dpboa_fecha_hasta nvarchar(12),
	dpboa_estado int,
	dpboa_afecta_evaluacion int, --REGIERE EVALUACION O NO
	dpboa_codta int foreign key references col_ta_tipificacion_arancel,
	dpboa_coddtde int foreign key references col_dtde_detalle_tipo_estudio,
	dpboa_fecha_creacion datetime default getdate()
)
-- select * from col_dpboa_definir_parametro_boleta_otros_aranceles

/*
dpboa_codigo dpboa_codtmo dpboa_afecta_materia dpboa_cupo_vencimiento dpboa_fecha_vencimiento dpboa_periodo dpboa_fecha_desde dpboa_fecha_hasta dpboa_estado dpboa_afecta_evaluacion dpboa_codta dpboa_fecha_creacion
------------ ------------ -------------------- ---------------------- ----------------------- ------------- ----------------- ----------------- ------------ ----------------------- ----------- -----------------------
1            852          1                    1                      07/06/2019              1             16/01/2019        08/06/2019        1            0                       1           2019-05-30 09:40:26.550
2            909          1                    0                      NULL                    1             01/02/2019        31/05/2019        1            0                       2           2019-05-30 09:41:08.213
3            1043         0                    0                      NULL                    0             NULL              NULL              1            0                       1           2019-05-30 09:41:31.763
4            128          0                    0                      NULL                    1             29/05/2019        31/05/2019        1            0                       2           2019-05-30 09:42:52.873
5            3245         0                    1                      05/06/2019              1             28/05/2019        08/06/2019        1            0                       2           2019-05-30 09:43:36.347

*/
insert into col_dpboa_definir_parametro_boleta_otros_aranceles (dpboa_codtmo, dpboa_afecta_materia, dpboa_cupo_vencimiento, dpboa_fecha_vencimiento, dpboa_periodo, dpboa_fecha_desde, dpboa_fecha_hasta, dpboa_estado, dpboa_afecta_evaluacion, dpboa_codta, dpboa_coddtde)
values 
(852 , 1,  1, '07/06/2019', 1, '16/01/2019', '13/12/2019', 1, 0, 1, 1),
(909 , 1,  0, '', 1, '01/02/2019', '31/12/2019', 1, 0, 2, 1),
(1043, 0,  0, '', 0, '', '', 1, 0, 1, 1),
(128 , 0,  0, '' , 1, '29/05/2019', '31/12/2019', 1, 0, 2, 1),
(3245, 0,  1, '05/06/2019', 1 ,'28/11/2019', '08/12/2019', 1, 0, 2, 1)
--select * from col_dpboa_definir_parametro_boleta_otros_aranceles

ALTER PROCEDURE [dbo].[tal_GenerarDataOtrosAranceles]
	------------*-------------
	-- =============================================
	-- Author:		<Juan Carlos Campos>
	-- Create date: <Martes 25 Mayo 2019>
	-- Description:	<Generar NPE de pago y codigo de barra de otros aranceles que no son matriculas ni cuotas>
	-- =============================================

	--	exec tal_GenerarDataOtrosAranceles 1, 9
	--update col_tmo_tipo_movimiento set tmo_valor = 125.87
	--where tmo_codigo = 1043
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
		@afecta_evaluacion int

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

	select @carnet = per_carnet, @alumno = per_nombres_apellidos 
	from ra_per_personas 
	where per_codigo = @codper

	print '@carnet : ' + @carnet
	print '@tmo_arancel : ' + cast(@tmo_arancel as nvarchar(10))
	print '@arancel : ' + @arancel
	print '@codtmo : ' + cast(@codtmo as nvarchar(8))
	print '@Monto : ' + cast(@Monto as nvarchar(10))
	print '@dao_codigo : ' + cast(@dao_codigo as nvarchar(8))

	select @carrera = pla_alias_carrera 
	from ra_alc_alumnos_carrera inner join ra_pla_planes on 
		pla_codigo = alc_codpla inner join ra_car_carreras on 
		car_codigo = pla_codcar
	where alc_codper = @codper

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
			right('0000000'+cast(floor(@dao_codigo) as varchar),8) as cc96,
			'8020' c8020,
			--substring(@carnet,1,2)+substring(@carnet,4,4)+substring(@carnet,9,4) + /* '*' + */ '9' + @ciclo as cc8020,
			REPLICATE('0',10-len(cast(@codper as nvarchar(10)))) + cast(@codper as nvarchar(10)) + /* '*' +  '9' +*/ @ciclo as cc8020,
			
			'0313'+right('0000'+cast(floor(@ParteEnteraString) as varchar),4) + right('00'+cast(floor(@ParteDecimalString) as varchar),2) + 
			--substring(@carnet,1,2)+substring(@carnet,4,4)+substring(@carnet,9,4) + '9' + @ciclo as  NPE
			REPLICATE('0',10-len(cast(@codper as nvarchar(10)))) + cast(@codper as nvarchar(10)) + '9' + @ciclo as  NPE
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

ALTER function [dbo].[fn_cumple_parametros_boleta_otros_aranceles]
(
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-05-28 15:57:36.870>
	-- Description: <Esta funcion devuelve una respuesta entera(detalladas en la funcion abajo) segun el @codpboa>
	-- =============================================
	-- select dbo.fn_cumple_parametros_boleta_otros_aranceles(1, 119, -1)
	@codpboa int, 
	@codcil int,
	@parametro int
)
returns int as
begin
    declare @respuesta int = 0-- -1:NO EXISTE EL ARANCEL, 0: todo bien, 1: cupo acabado, 2: fecha vencimiento vencio, 3: fuera del periodo (fecha_desde a fecha_hasta)

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
				@cupo = isnull(tmo_cupo, -1)
		from col_dpboa_definir_parametro_boleta_otros_aranceles 
		inner join col_tmo_tipo_movimiento on tmo_codigo = dpboa_codtmo
		where dpboa_codigo = @codpboa and dpboa_estado = 1
		                                             
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
	return @respuesta-- -1:NO EXISTE EL ARANCEL, 0: todo bien, 1: cupo acabado, 2: fecha vencimiento vencio, 3: fuera del periodo (fecha_desde a fecha_hasta)
end

-- drop table col_dao_data_otros_aranceles
create table col_dao_data_otros_aranceles(
	dao_codigo int primary key identity(1,1),
	dao_codper int foreign key references ra_per_personas ,
	dao_codhpl int foreign key references ra_hpl_horarios_planificacion,
	dao_codpon int foreign key references ra_pon_ponderacion,
	dao_codcil int foreign key references ra_cil_ciclo,
	dao_coddpboa int  foreign key references col_dpboa_definir_parametro_boleta_otros_aranceles,
	dao_npe	 nvarchar(40),
	dao_barra nvarchar(80),
	dao_fecha_creacion datetime default getdate()
);
-- select * from col_dao_data_otros_aranceles
-- insert into col_dao_data_otros_aranceles (dao_codper, dao_codhpl, dao_codpon, dao_codcil, dao_coddpboa)values (181324, 35592, 4, 119, 2),(181324, null, null, 119, 4), (181324, null, null, 119, 3), (180168, 35755, 4, 119, 2), (182420, 35755, 4, 119, 1), (182420, 36304, 4, 119, 1)

ALTER procedure [dbo].[sp_col_dao_data_otros_aranceles]
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-05-27 09:29:42.293>
	-- Description: <Realiza el mantenimiento a la tabla col_dao_data_otros_aranceles> 2019-05-27 11:31:08.130
	-- =============================================
	--sp_col_dao_data_otros_aranceles 0, 1, 0, 0, 0, 0, 0 --
	--sp_col_dao_data_otros_aranceles 1, 1, 221782, 0, 0, 0, 0 --
	--sp_col_dao_data_otros_aranceles 3, 1, 181324, 35755, 0, 119, 1 --INSERTA EL NPE Y CODIGO DE BARRA
	--sp_col_dao_data_otros_aranceles 4, 1, 181324, 35755, 0, 119, 5, 0 --VALIDA SI CUMPLE LOS PARAMETROS 
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
		/*declare @respuesta int = 0--0: todo bien, 1: cupo acabado, 2: fecha vencimiento vencio, 3: fuera del periodo (fecha_desde a fecha_hasta)

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

		--select * from col_dpboa_definir_parametro_boleta_otros_aranceles
		select	@dpboa_codtmo = isnull(dpboa_codtmo, -1),
				@dpboa_afecta_materia = isnull(dpboa_afecta_materia, -1),
				@dpboa_cupo_vencimiento = isnull(dpboa_cupo_vencimiento, -1),
				@dpboa_fecha_vencimiento = isnull(dpboa_fecha_vencimiento, -1),
				@dpboa_periodo = isnull(dpboa_periodo, -1),
				@dpboa_fecha_desde = isnull(dpboa_fecha_desde, -1),
				@dpboa_fecha_hasta = isnull(dpboa_fecha_hasta, -1),
				@cupo = isnull(tmo_cupo, -1)
		from col_dpboa_definir_parametro_boleta_otros_aranceles 
		inner join col_tmo_tipo_movimiento on tmo_codigo = dpboa_codtmo
		where dpboa_codigo = @codpboa and dpboa_estado = 1
		        
		print '@dpboa_codtmo ' + cast(@dpboa_codtmo as varchar(20))
		print '@dpboa_afecta_materia ' + cast(@dpboa_afecta_materia as varchar(20))
		print '@dpboa_cupo_vencimiento ' + cast(@dpboa_cupo_vencimiento as varchar(20))
		print '@dpboa_fecha_vencimiento ' + cast(@dpboa_fecha_vencimiento as varchar(20))
		print '@dpboa_periodo ' + cast(@dpboa_periodo as varchar(20))
		print '@dpboa_fecha_desde ' + cast(@dpboa_fecha_desde as varchar(20))
		print '@dpboa_fecha_hasta ' + cast(@dpboa_fecha_hasta as varchar(20))
		print '@dpboa_estado ' + cast(@dpboa_estado as varchar(20))
		print '@cupo ' + cast(@cupo as varchar(20))                                     
		if @dpboa_cupo_vencimiento = 1 and @cupo > 0--CUPO > 0 por que tuvieron que poner una cantidad > 0 si tiene cupo, si tiene cupo = 0 el dato esta mal ingresado
		begin
			select @asistencias = isnull(count(1), 0) from col_dmo_det_mov 
			inner join col_mov_movimientos on dmo_codmov = mov_codigo
			inner join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
			where dmo_codcil = @codcil and dmo_codtmo in(@dpboa_codtmo) and mov_estado <> 'A'
			
			print '@asistencias ' + cast(@asistencias as varchar(20))  
			if @asistencias >= @cupo
				set @respuesta = 1

			if not (convert(date,getdate(), 103) <= convert(date, @dpboa_fecha_vencimiento, 103))
				set @respuesta = 2
		end

		if @dpboa_periodo = 1
			if not(convert(date,getdate(), 103) >= convert(date, @dpboa_fecha_desde, 103) and convert(date,getdate(), 103) <= convert(date, @dpboa_fecha_hasta, 103))
				set @respuesta = 3*/
		--Se cambio todo lo anterior por la funcion
		select dbo.fn_cumple_parametros_boleta_otros_aranceles(@codpboa, @codcil,-1)
		--select @respuesta
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
				dbo.fn_cumple_parametros_boleta_otros_aranceles(dpboa_codigo,dao_codcil,-1) estado, per_carnet, per_apellidos_nombres,
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
			select dbo.fn_cumple_parametros_boleta_otros_aranceles(dpboa_codigo,dao_codcil,-1) estado
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
 
ALTER procedure [dbo].[sp_reversion_pago_codigo_barra]
	-- =============================================
	-- Author:		<Adones>
	-- Create date: <29/05/2019>
	-- Description:	<Es invocado en el WS: revertirPagoRef(string codigo_barra, string referencia)>
	-- =============================================
	-- sp_reversion_pago_codigo_barra '4157419700003137390200000007009600001002802000001813249022019', 11, '2287193'
	-- sp_reversion_pago_codigo_barra '0313004500000018242090220192', 11, '2287193'
	@barra varchar(100),
	@tipo int,
	@referencia varchar(100)
 as
 begin
	declare @n_valor varchar(6),
	@n_carnet varchar(12),
	@n_cuota varchar(5),
	@n_ciclo varchar(6),
	@fecha datetime,
	@pal_usuario nvarchar(50),
	@npe varchar(255),
	@codper int,
	@tipo_pago varchar(6),
	@dao_codigo int
	
	declare @existe_npe_o_barra int = 0

	declare @len int
	select @len = isnull(len(@barra), 0)
	if @len = 28 --Es NPE el parametro @codigo_barra
	begin
		print 'NPE'
		select @dao_codigo = dao_codigo, @codper = dao_codper, @tipo_pago = 'NPE' from col_dao_data_otros_aranceles where dao_npe = @barra
	end
	else if @len = 60
	begin
		print 'Codigo Barra'
		select @dao_codigo =  substring(@barra,33,8), @codper = cast(SUBSTRING(@barra, 45, 10) as bigint), @tipo_pago = 'BARRA'
	end
	print '@dao_codigo ' + cast(@dao_codigo as varchar)

	--select @npe = dao_npe, @n_carnet = per_carnet, @per_codigo = per_codigo 
	--from col_dao_data_otros_aranceles 
	--inner join ra_per_personas on dao_codper = per_codigo
	--where dao_barra = @barra

	select @pal_usuario = pal_usuario from col_pal_pagos_linea where pal_codigo = @tipo
	select @n_valor = substring(@npe,5,6) ,  @n_cuota = substring(@npe,21,1), @n_ciclo = substring(@npe,22,6)

	update col_mov_movimientos
	set mov_estado = 'A', mov_usuario_anula = @pal_usuario, mov_fecha_anula = getdate()
	where mov_codper = @codper
		  and mov_puntoxpress = @tipo
		  and mov_recibo_puntoxpress = @referencia

	if @@ROWCOUNT > 0
		select 1 'estado'
	else
		select 0 'estado'
end

--select penot_eval from web_ra_not_penot_periodonotas where getdate() >= penot_fechaini and GETDATE()<= penot_fechafin and penot_periodo = 'Ordinario'
--select * from ra_pon_ponderacion
select * from web_ra_not_penot_periodonotas order by penot_eval asc, penot_periodo desc

select 0 pon_codigo, 'Seleccione la evaluacion' pon_nombre  union all  select *  from ra_pon_ponderacion  where pon_aplica = 'U'  and pon_codigo <> 8
/*select '0' codigo, 'Seleccione la materia' materia  union all  
select mai_codhpl codigo, isnull(CAST(hpl_materia as varchar(5)), '') + ' '+isnull(plm_alias, mat_nombre) + isnull(hor_descripcion,'') materia
from ra_ins_inscripcion   join ra_mai_mat_inscritas on mai_codins = ins_codigo  
join ra_mat_materias on mat_codigo = mai_codmat  join ra_alc_alumnos_carrera on alc_codper = ins_codper  
join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
join ra_plm_planes_materias on plm_codpla = alc_codpla and plm_codmat = mai_codmat  
left outer join ra_hor_horarios on hor_codigo = mai_codhor  
where mai_estado = 'I'  and ins_codper = 181324 and ins_codcil in (select cil_codigo from ra_cil_ciclo  where cil_vigente = 'S') 
order by codigo asc;

select 0 pon_codigo, 'Seleccione la evaluacion' pon_nombre  union all  select pon_codigo, pon_nombre  from ra_pon_ponderacion  where pon_aplica = 'U'  and pon_codigo <> 8*/

select top 10 * from col_mov_movimientos
select top 100 dmo_codmov from col_dmo_det_mov where isnull(dmo_eval, '0') <>'0' and dmo_eval <> '' and dmo_eval not in ('1', '2') 
group by dmo_codmov
having count(dmo_codmov)>3

select * from col_mov_movimientos where mov_codigo = 5759823
select * from col_dmo_det_mov where dmo_codmov = 5759823
select * from ra_hpl_horarios_planificacion where hpl_codigo = 3685
select * from col_dao_data_otros_aranceles

ALTER procedure [dbo].[sp_encabezado_detalle]
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-06-01 10:31:02.196>
	-- Description: <Devuelve el encabezado o el detalle de un pago para el webservice del banco azul, es invocado en el WS: 
	--																														encabezadoFactura(string codigo_movimiento)
	--																														detalleFactura(string codigo_movimiento)> 
	-- =============================================
	-- sp_encabezado_detalle 1, 5763987 --ENCABEZADO
	-- sp_encabezado_detalle 2, 5940913 --DETALLE DE FACTURA -- 4784193, 5759823, 5763987
	@opcion int, 
	@codmov int
as
begin
	if @opcion = 1--ENCABEZADO
	begin	
		select ltrim(rtrim(per_apellidos_nombres)) 'alumno', per_carnet 'carnet', mov_fecha_registro 'fecha_registro', concat('0',cil_codcic, '-',cil_anio) 'ciclo', car_nombre 'carrera'
		from col_mov_movimientos 
		inner join ra_per_personas on mov_codper = per_codigo 
		inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
		inner join ra_pla_planes on alc_codpla = pla_codigo
		inner join ra_car_carreras on car_codigo = pla_codcar
		inner join ra_cil_ciclo on cil_codigo = mov_codcil 
		where mov_codigo = @codmov
	end

	if @opcion = 2 --detalle
	begin
		select ltrim(rtrim(tmo_arancel)) 'arancel', ltrim(rtrim(tmo_descripcion)) 'descripcion_arancel', tmo_valor 'valor_arancel',  dmo_cantidad 'cantidad', 
		mat_nombre 'materia_afectada', dmo_eval 'evaluacion_afectada'
		from col_dmo_det_mov 
		inner join col_mov_movimientos on dmo_codmov = mov_codigo
		inner join ra_per_personas on mov_codper = per_codigo
		inner join ra_cil_ciclo on cil_codigo = mov_codcil
		inner join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
		--inner join adm_ban_bancos
		left join ra_mat_materias on dmo_codmat = mat_codigo
		left join ra_pon_ponderacion on pon_codigo = dmo_eval
		where dmo_codmov = @codmov
	end
end

--drop table col_pagos_en_linea_estructurado_OtrosAranceles
create table col_pagos_en_linea_estructurado_OtrosAranceles(
	Id int identity, 
	codper int, 
	carnet nvarchar(12), 
	NumFactura int, 
	formapago int, 
	lote int, 
	MontoFactura float,  
	npe nvarchar(36), 
	codigo_barra nvarchar(64), 
	TipoEstudiante nvarchar(50), 
	fechahora datetime default getdate()
);
-- select * from col_pagos_en_linea_estructurado_OtrosAranceles

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
	@referencia varchar(50)
as
begin
	set nocount on;
	set dateformat dmy

	declare @len int
	select @len = isnull(len(@barra), 0)
	if @len = 28 --Es NPE el parametro @codigo_barra
	begin
		print 'NPE'
		select @barra = dao_barra from col_dao_data_otros_aranceles where dao_npe = @barra
	end
	print '@barra ' + cast(@barra as varchar(66))

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

			select @corr_mov as IdGenerado

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
			select 0 IdGenerado

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
		select 0 IdGenerado
	end
end