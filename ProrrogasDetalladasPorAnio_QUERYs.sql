--select * from ra_poo_prorroga_otorgar where poo_codcil = @codcil
--select * from ra_pon_ponderacion
--select * from ra_pra_prorroga_acad
--inner join ra_poo_prorroga_otorgar on poo_codigo = pra_codpoo
--inner join ra_per_personas on per_codigo = pra_codper
--where poo_codcil = @codcil and pra_codpoo = 113
--order by per_anio_ingreso
--select * from ra_pproac_parametros_prorrogas_anio_carnet
--drop table ra_pproac_parametros_prorrogas_anio_carnet
create table ra_pproac_parametros_prorrogas_anio_carnet
(
    pproac_codigo int primary key identity(1,1),
    pproac_codcil int,
    pproac_anio_carnet int,
    pproac_anio_carnet_fin int,  -- '<='
    pproac_numero_cuota int,
    pproac_cantidad int,
    pproac_cum_minimo float,
    pproac_mensaje_afirmativo nvarchar(200),
    pproac_mensaje_negativo nvarchar(200),
    pproac_prorroga_sucesiva int,
    pproac_fecha_inicio nvarchar(10),
    pproac_fecha_fin nvarchar(10),
    pproac_activo int default 1,  -- 0 es inactivo
    pproac_codtde int,
    pproac_coduser int,
    pproac_fechahora datetime default getdate()
)

insert into ra_pproac_parametros_prorrogas_anio_carnet 
(pproac_codcil, pproac_anio_carnet, pproac_anio_carnet_fin, pproac_numero_cuota, pproac_cantidad, pproac_cum_minimo, 
pproac_mensaje_afirmativo, pproac_mensaje_negativo, pproac_prorroga_sucesiva, pproac_fecha_inicio, pproac_fecha_fin, 
pproac_activo, pproac_codtde, pproac_coduser)
values
(122, 2020, 2020, 3, 375, 7.0, 
'Prorroga solicitada con exito', 'Lo sentimos mucho, pero ya se agotó la cantidad de prórrogas autorizadas', 1, '31/03/2020', '23/04/2020',
1, 1, 407),
(122, 2019, 2019, 3, 375, 7.0, 
'Prorroga solicitada con exito', 'Lo sentimos mucho, pero ya se agotó la cantidad de prórrogas autorizadas', 1, '31/03/2020', '23/04/2020',
1, 1, 407),
(122, 2018, 2018, 3, 188, 7.0, 
'Prorroga solicitada con exito', 'Lo sentimos mucho, pero ya se agotó la cantidad de prórrogas autorizadas', 1, '31/03/2020', '23/04/2020',
1, 1, 407),
(122, 2017, 2017, 3, 187, 7.0, 
'Prorroga solicitada con exito', 'Lo sentimos mucho, pero ya se agotó la cantidad de prórrogas autorizadas', 1, '31/03/2020', '23/04/2020',
1, 1, 407),
(122, 1980, 2016, 3, 375, 7.0, 
'Prorroga solicitada con exito', 'Lo sentimos mucho, pero ya se agotó la cantidad de prórrogas autorizadas', 1, '31/03/2020', '23/04/2020',
1, 1, 407),

(122, 2020, 2020, 4, 375, 7.0, 
'Prorroga solicitada con exito', 'Lo sentimos mucho, pero ya se agotó la cantidad de prórrogas autorizadas', 1, '15/05/2020', '22/05/2020',
1, 1, 407),
(122, 2019, 2019, 4, 375, 7.0, 
'Prorroga solicitada con exito', 'Lo sentimos mucho, pero ya se agotó la cantidad de prórrogas autorizadas', 1, '15/05/2020', '22/05/2020',
1, 1, 407),
(122, 2018, 2018, 4, 188, 7.0, 
'Prorroga solicitada con exito', 'Lo sentimos mucho, pero ya se agotó la cantidad de prórrogas autorizadas', 1, '15/05/2020', '22/05/2020',
1, 1, 407),
(122, 2017, 2017, 4, 187, 7.0, 
'Prorroga solicitada con exito', 'Lo sentimos mucho, pero ya se agotó la cantidad de prórrogas autorizadas', 1, '15/05/2020', '22/05/2020',
1, 1, 407),
(122, 1980, 2016, 4, 375, 7.0, 
'Prorroga solicitada con exito', 'Lo sentimos mucho, pero ya se agotó la cantidad de prórrogas autorizadas', 1, '15/05/2020', '22/05/2020',
1, 1, 407),

(122, 2020, 2020, 5, 375, 7.0, 
'Prorroga solicitada con exito', 'Lo sentimos mucho, pero ya se agotó la cantidad de prórrogas autorizadas', 1, '28/05/2020', '08/06/2020',
1, 1, 407),
(122, 2019, 2019, 5, 375, 7.0, 
'Prorroga solicitada con exito', 'Lo sentimos mucho, pero ya se agotó la cantidad de prórrogas autorizadas', 1, '28/05/2020', '08/06/2020',
1, 1, 407),
(122, 2018, 2018, 5, 188, 7.0, 
'Prorroga solicitada con exito', 'Lo sentimos mucho, pero ya se agotó la cantidad de prórrogas autorizadas', 1, '28/05/2020', '08/06/2020',
1, 1, 407),
(122, 2017, 2017, 5, 187, 7.0, 
'Prorroga solicitada con exito', 'Lo sentimos mucho, pero ya se agotó la cantidad de prórrogas autorizadas', 1, '28/05/2020', '08/06/2020',
1, 1, 407),
(122, 1980, 2016, 5, 375, 7.0, 
'Prorroga solicitada con exito', 'Lo sentimos mucho, pero ya se agotó la cantidad de prórrogas autorizadas', 1, '28/05/2020', '08/06/2020',
1, 1, 407);

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_ra_pproac_parametros_prorrogas_anio_carnet]    Script Date: 15/4/2020 18:01:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Fabio y Angel>
-- Create date: <2020-04-14 17:44:56.413>
-- Description: <Realiza el CRUD a la tabla ra_pproac_parametros_prorrogas_anio_carnet y validaciones para el portal UTEC>
-- =============================================
ALTER procedure [dbo].[sp_ra_pproac_parametros_prorrogas_anio_carnet]
(
	@opcion int = 0,
	@pproac_codigo int = 0,
	@pproac_codcil int = 0,
	@pproac_anio_carnet int = 0,
	@pproac_anio_carnet_fin int = 0,
	@pproac_numero_cuota int = 0,
	@pproac_cantidad int = 0,
	@pproac_cum_minimo float = 0.0,
	@pproac_mensaje_afirmativo nvarchar(200) = '',
	@pproac_mensaje_negativo nvarchar(200) = '',
	@pproac_prorroga_sucesiva int = 0,
	@pproac_fecha_inicio nvarchar(10) = '',
	@pproac_fecha_fin nvarchar(10) = '',
	@pproac_activo int = 0,
	@pproac_codtde int = 0,
	@pproac_coduser int = 0,
	@txt_buscar nvarchar(1024) = '',

	@codper int = 0,
	@codcil int = 0,
	@eval int = 0
)
as
begin
	
	if @opcion = 0
	begin
		select pproac_codigo codpproac, concat('"0', cil_codcic, '-', cil_anio, '"') ciclo,
		pproac_anio_carnet 'Carnets del año', 
		pproac_anio_carnet_fin 'Carnets del año fin', 
		pproac_numero_cuota 'Numero de cuota mínima cancelada', pproac_cantidad 'Cantidad de prórrogas a otorgar', 
		pproac_cum_minimo 'CUM mínimo para solicitar prórroga', pproac_mensaje_afirmativo 'Mensaje prórroga otorgada con éxito', 
		pproac_mensaje_negativo 'Mensaje prórroga agotadas', 
		case pproac_prorroga_sucesiva when 1 then 'Si' else 'No' end 'Permitir prórrogas sucesivas', 
		pproac_fecha_inicio 'Fecha INICIO periodo solicitud prórrogas', pproac_fecha_fin 'Fecha FIN periodo solicitud prórroga', 
		case pproac_activo when 1 then 'Si' else 'No' end 'Activo',
		tde_nombre 'Parametrización para los alumnos de', pproac_coduser 'usuario_creacion', usr_nombre , pproac_fechahora 'fecha_creacion'
		from ra_pproac_parametros_prorrogas_anio_carnet
		inner join ra_cil_ciclo on cil_codigo = pproac_codcil
		inner join ra_tde_TipoDeEstudio on tde_codigo = pproac_codtde
		left join adm_usr_usuarios on usr_codigo = pproac_coduser
		where pproac_codcil = @pproac_codcil
	end

	if @opcion = 1 --select
	begin
		select * from (
			select pproac_codigo, pproac_codcil, concat('0', cil_codcic, '-', cil_anio) ciclo,
			pproac_anio_carnet, pproac_anio_carnet_fin, pproac_numero_cuota, pproac_cantidad, pproac_cum_minimo,
			pproac_mensaje_afirmativo, pproac_mensaje_negativo, pproac_prorroga_sucesiva, pproac_fecha_inicio, pproac_fecha_fin, pproac_activo,
			pproac_codtde, tde_nombre, pproac_coduser, usr_nombre ,pproac_fechahora
			from ra_pproac_parametros_prorrogas_anio_carnet
			inner join ra_cil_ciclo on cil_codigo = pproac_codcil
			inner join ra_tde_TipoDeEstudio on tde_codigo = pproac_codtde
			left join adm_usr_usuarios on usr_codigo = pproac_coduser
			where pproac_codcil = @pproac_codcil
		) t
		where ( 
			(ltrim(rtrim(pproac_codigo)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(ciclo)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(pproac_anio_carnet)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(pproac_anio_carnet_fin)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(pproac_numero_cuota)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(pproac_cantidad)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(pproac_cum_minimo)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(ciclo)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(pproac_mensaje_afirmativo)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(pproac_mensaje_negativo)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(pproac_fecha_inicio)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(pproac_fecha_fin)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(tde_nombre)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		)
               
	end

	if @opcion = 2 --inserta
	begin
		insert into ra_pproac_parametros_prorrogas_anio_carnet 
		(pproac_codcil, pproac_anio_carnet, pproac_anio_carnet_fin, pproac_numero_cuota, pproac_cantidad, pproac_cum_minimo, 
		pproac_mensaje_afirmativo, pproac_mensaje_negativo, pproac_prorroga_sucesiva, pproac_fecha_inicio, pproac_fecha_fin, 
		pproac_activo, pproac_codtde, pproac_coduser)
		values (@pproac_codcil, @pproac_anio_carnet, @pproac_anio_carnet_fin, @pproac_numero_cuota, @pproac_cantidad, @pproac_cum_minimo, 
		@pproac_mensaje_afirmativo, @pproac_mensaje_negativo, @pproac_prorroga_sucesiva, @pproac_fecha_inicio, @pproac_fecha_fin, 
		@pproac_activo, @pproac_codtde, @pproac_coduser)
	end
	
	if @opcion = 3 --actualiza
	begin
		update ra_pproac_parametros_prorrogas_anio_carnet 
		set pproac_codcil = @pproac_codcil, pproac_anio_carnet = @pproac_anio_carnet, 
		pproac_anio_carnet_fin = @pproac_anio_carnet_fin, pproac_numero_cuota = @pproac_numero_cuota, 
		pproac_cantidad = @pproac_cantidad, pproac_cum_minimo = @pproac_cum_minimo, 
		pproac_mensaje_afirmativo = @pproac_mensaje_afirmativo, pproac_mensaje_negativo = @pproac_mensaje_negativo, 
		pproac_prorroga_sucesiva = @pproac_prorroga_sucesiva, pproac_fecha_inicio = @pproac_fecha_inicio, 
		pproac_fecha_fin = @pproac_fecha_fin, pproac_activo = @pproac_activo, 
		pproac_codtde = @pproac_codtde
		where pproac_codigo = @pproac_codigo
	end

	if @opcion = 4 --elimina
	begin
		update ra_pproac_parametros_prorrogas_anio_carnet set pproac_activo = 0 where pproac_codigo = @pproac_codigo
	end

	if @opcion = 5 --valida que el alumno pueda pedir prorroga
	begin
		declare @per_carnet_anio int, @codtde int, @cum real, @cuotas_canceladas int, @ultima_eva_con_prorroga int, @per_tipo_ingreso int
		select @per_carnet_anio = substring(per_carnet, 9, 4), @codtde = tde_codigo,
		@per_tipo_ingreso = isnull(per_tipo_ingreso, 0)
		from ra_per_personas 
		inner join ra_tde_TipoDeEstudio on tde_tipo = per_tipo where per_codigo = @codper

		select @cuotas_canceladas = (count(mov_codper) - 1)-- -1 para descartar la matricula
		from col_mov_movimientos 
			inner join col_dmo_det_mov on dmo_codmov = mov_codigo and dmo_codcil = mov_codcil
			inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo_codtmo 
			inner join vst_Aranceles_x_Evaluacion as vst on vst.are_codtmo = tmo.tmo_codigo and vst.tmo_arancel = tmo.tmo_arancel
		where mov_codcil = @codcil and mov_codper = @codper  

		select top 1 @ultima_eva_con_prorroga = isnull(pon_orden, 0) from ra_pra_prorroga_acad
		inner join ra_poo_prorroga_otorgar on poo_codigo = pra_codpoo
		inner join ra_per_personas on per_codigo = pra_codper
		inner join ra_pon_ponderacion on pon_codigo = poo_codpon
		where poo_codcil = @codcil and pra_codper = @codper
		order by pon_orden desc
		set @ultima_eva_con_prorroga = isnull(@ultima_eva_con_prorroga, -1)

		declare @codpproac int, @anio_carnet int, @anio_carnet_fin int, @numero_cuota int, @cantidad int, @cum_minimo real, 
		@mensaje_afirmativo varchar(400), @mensaje_negativo varchar(400), @prorroga_sucesiva int

		select @codpproac = pproac_codigo, @anio_carnet = pproac_anio_carnet, @anio_carnet_fin = pproac_anio_carnet_fin, 
		@numero_cuota = pproac_numero_cuota,
		@cantidad = pproac_cantidad, @cum_minimo = pproac_cum_minimo, @mensaje_afirmativo = pproac_mensaje_afirmativo,
		@mensaje_negativo = pproac_mensaje_negativo, @prorroga_sucesiva = pproac_prorroga_sucesiva
		from ra_pproac_parametros_prorrogas_anio_carnet
		where pproac_codcil = @codcil 
		and convert(date, getdate(), 103) between convert(date, pproac_fecha_inicio, 103) and convert(date, pproac_fecha_fin, 103)
		and @per_carnet_anio between pproac_anio_carnet and pproac_anio_carnet_fin and pproac_codtde = @codtde
		and pproac_activo = 1
		print '@codpproac ' + cast(@codpproac as varchar(5))
	
		if ((isnull(@anio_carnet, 0)) <> 0)--Si devuelve algo el select anterior es porque esta en el periodo
		begin
			if not exists (select 1 from ra_pra_prorroga_acad
					inner join ra_poo_prorroga_otorgar on poo_codigo = pra_codpoo
					inner join ra_per_personas on per_codigo = pra_codper 
					inner join ra_pon_ponderacion on pon_codigo = poo_codpon 
					where poo_codcil = @codcil and pra_codper = @codper and poo_codpon = @eval)-- Si no a pedido prorroga
			begin
				declare @alumnos_han_solicitado_prorroga int
				select @alumnos_han_solicitado_prorroga = count(1) from ra_pra_prorroga_acad
				inner join ra_poo_prorroga_otorgar on poo_codigo = pra_codpoo
				inner join ra_per_personas on per_codigo = pra_codper
				inner join ra_pon_ponderacion on pon_codigo = poo_codpon
				where poo_codcil = @codcil and pon_orden = @eval and per_anio_ingreso between @anio_carnet and @anio_carnet_fin

				if (@cuotas_canceladas > @numero_cuota)
					select -6 res, 'No puede solicitar prórroga porque estas solvente' texto
				else
				begin
					if @per_tipo_ingreso = 1
						set @cum = dbo.fn_cum_ciclo_notas(@codper, @codcil)--dbo.fn_cum_ciclo(@codper, @codcil)--223299
					else
						set @cum = dbo.fn_cum_limpio(@codper, 1)

					print '@alumnos_han_solicitado_prorroga: ' + cast(@alumnos_han_solicitado_prorroga as varchar(25)) +'/' +cast(@cantidad as varchar(5)) + ', con carnet entre los años ' + cast(@anio_carnet as varchar(5)) + ' al ' + cast(@anio_carnet_fin as varchar(5))
					print '@cum: ' + cast(@cum as varchar(25)) + ' @cum_minimo: ' + cast(@cum_minimo as varchar(10))
					print '@cuotas_canceladas: ' + cast(@cuotas_canceladas as varchar(5)) + ' @numero_cuota: ' + cast(@numero_cuota as varchar(10))
					print '@prorroga_sucesiva: ' + cast(@prorroga_sucesiva as varchar(5)) + ' @eval - 1: ' + cast((@eval - 1) as varchar(10)) + ' @ultima_eva_con_prorroga: ' + cast(@ultima_eva_con_prorroga as varchar(10))

					if (@alumnos_han_solicitado_prorroga >= @cantidad)
						select -1 res, @mensaje_negativo texto
					else if (@cum < @cum_minimo)
						select -2 res, 'Lo sentimos, pero no posee el CUM mínimo para este proceso' texto
					else if (@cuotas_canceladas < @numero_cuota)
						select -3 res, 'Lo sentimos, pero no se encuentra solvente con la cuota requisito para este proceso' texto
					else if (@prorroga_sucesiva = 0 and (((@eval - 1) = (@ultima_eva_con_prorroga ))))
						select -4 res, 'Lo sentimos, ya ha solicitado prórroga en la evaluación anterior' texto
					else
						select 0 res, @mensaje_afirmativo texto
				end
			end
			else
			begin
				select -5 res, 'Ya tienes prórroga solicitada para la evaluación' texto
			end
		end
		else
		begin
			select -2 res, 'No esta activa la prórroga' texto
		end
	end

	if @opcion = 6
	begin
		declare @poo_cod int = 0, @codtmo int = 0

		select 
		@codtmo = case	when @eval = 1 then 134 
						when @eval = 2 then 135 
						when @eval = 3 then 136 
						when @eval = 4 then 137 
						when @eval = 5 then 943 
					end 

		--Select @codtmo = tmo_codigo
		--from col_mov_movimientos 
		--	inner join col_dmo_det_mov on dmo_codmov = mov_codigo and dmo_codcil = mov_codcil
		--	inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo_codtmo 
		--	inner join vst_Aranceles_x_Evaluacion as vst on vst.are_codtmo = tmo.tmo_codigo and vst.tmo_arancel = tmo.tmo_arancel
		--where mov_codcil = @codcil and mov_codper = @codper and spaet_codigo = (@eval -1)

		select @poo_cod = poo_codigo from ra_poo_prorroga_otorgar where poo_codcil = @codcil and poo_codpon = @eval
		insert into ra_pra_prorroga_acad (pra_codreg, pra_codigo, pra_codper, pra_codcil, pra_codtmo, pra_codpoo, pra_codusr) 
			select 1, isnull(max(pra_codigo),0)+1, @codper, @codcil, @codtmo/*(@codtmo + 1)*/, @poo_cod, 378 
			from ra_pra_prorroga_acad
	end
end


-- =============================================
-- Author:      <Fabio>
-- Create date: <2020-04-15 23:27:08.793>
-- Description: <Devuelve el consolidado de las prórrogas otorgadas por restricción de año>
-- =============================================
alter procedure sp_prorrogas_otorgadas_por_anio
	-- sp_prorrogas_otorgadas_por_anio 1, 122, 3
	@opcion int = 0,
	@codcil int = 0,
	@eva int = 0
as
begin
	if @opcion = 1
	begin
		declare /*@codcil int = 122, @eva int = 3, */@codpoo int = 0
		declare @pra_codigo_inicial int = 174831--Indica el código de la primera prórroga solicitada ya con las restricciones de año
		select @codpoo = poo_codigo from ra_poo_prorroga_otorgar where poo_codcil = @codcil and poo_codpon = @eva
		declare @tbl_data as table (anio int, cantidad int, solicitado_prorrogas_detalladas_anio int)
		insert into @tbl_data (anio, cantidad, solicitado_prorrogas_detalladas_anio)
		select anio, count(1) cantidad, sum(solicitado_prorrogas_detalladas_anio) solicitado_prorrogas_detalladas_anio from (
			select SUBSTRING(per_carnet, 9, 4) anio, case when pra_codigo >= @pra_codigo_inicial then 1 else 0 end solicitado_prorrogas_detalladas_anio
			from ra_pra_prorroga_acad
			inner join ra_poo_prorroga_otorgar on poo_codigo = pra_codpoo
			inner join ra_per_personas on per_codigo = pra_codper
			where poo_codcil = @codcil and pra_codpoo = @codpoo --and pra_codigo >= 174831
		) t
		group by anio

		declare @tbl_data_res as table (anio_desde varchar(10), anio_hasta varchar(10), cantidad int, cantidad_prorrogas int, solicitado_prorrogas_detalladas_anio int)

		declare @pproac_codigo int, @pproac_anio_carnet int, @pproac_anio_carnet_fin int, @pproac_cantidad int
		declare mcursor cursor 
		for
		select pproac_codigo, pproac_anio_carnet, pproac_anio_carnet_fin, pproac_cantidad from ra_pproac_parametros_prorrogas_anio_carnet where pproac_numero_cuota = @eva--sera de asumir que el numero de cuota minima es igual a la evaluacion

		open mcursor 
		fetch next from mcursor into @pproac_codigo, @pproac_anio_carnet, @pproac_anio_carnet_fin, @pproac_cantidad
		while @@FETCH_STATUS = 0 
		begin
			insert into @tbl_data_res (anio_desde, anio_hasta, cantidad, cantidad_prorrogas, solicitado_prorrogas_detalladas_anio)
			select @pproac_anio_carnet, @pproac_anio_carnet_fin, @pproac_cantidad, 
			(select sum(cantidad) from @tbl_data where anio between @pproac_anio_carnet and @pproac_anio_carnet_fin),

			(select sum(solicitado_prorrogas_detalladas_anio) from @tbl_data where anio between @pproac_anio_carnet and @pproac_anio_carnet_fin)
			fetch next from mcursor into @pproac_codigo, @pproac_anio_carnet, @pproac_anio_carnet_fin, @pproac_cantidad
		end      
		close mcursor  
		deallocate mcursor
						
		select isnull(anio_desde, '') 'Desde años de carnet', isnull(anio_hasta, 'TOTALES.') 'Hasta años de carnet', 
		[Otorgadas con restricciones de años], 
		[Otorgadas sin restricción de años], [Total de prorrogas otorgadas], 
		[Cantidad definidas por años], [Prorrogas disponibles por años]  
		from (
			select [t], anio_desde, anio_hasta,
			sum(solicitado_prorrogas_detalladas_anio) 'Otorgadas con restricciones de años',
			sum(sin_restriccion) 'Otorgadas sin restricción de años',
			sum(total_otorgadas) 'Total de prorrogas otorgadas',
			sum(cantidad) 'Cantidad definidas por años',
			sum(disponibles_por_anio) 'Prorrogas disponibles por años'
			from (
				select 'TOTALES' 't', anio_desde, anio_hasta,
				solicitado_prorrogas_detalladas_anio,
				(cantidad_prorrogas - solicitado_prorrogas_detalladas_anio) sin_restriccion,
				cantidad_prorrogas total_otorgadas,
				cantidad,
				(cantidad - cantidad_prorrogas) disponibles_por_anio
				from @tbl_data_res
			) dat
			group by grouping sets((anio_desde, anio_hasta), ([t]))
		) tabla
		order by anio_desde desc
	end
end