USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_libro_ventas_cf]    Script Date: 21/11/2023 15:44:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	-- exec dbo.rep_libro_ventas_cf 1, '01/10/2023', '31/10/2023'
ALTER proc [dbo].[rep_libro_ventas_cf] 
	@regional int = 1,
	@fecha_del varchar(10) = '',
	@fecha_al varchar(10) = ''
as
begin

	set dateformat dmy
	declare @facultad int = 0, @carrera int = 0

	declare @col_mov_Movimientos TABLE (
		[mov_codreg] [int], [mov_codigo] [int] primary key, [mov_recibo] [varchar](20), [mov_fecha] [datetime], [mov_codper] [int], 
		[mov_codcil] [int], [mov_descripcion] [varchar](200), [mov_tipo_pago] [varchar](5), [mov_cheque] [varchar](50), 
		[mov_estado] [varchar](5), [mov_tarjeta] [varchar](50), [mov_usuario] [varchar](50), [mov_fecha_registro] [datetime], 
		[mov_usuario_anula] [varchar](50), [mov_fecha_anula] [datetime], [mov_codmod] [int], [mov_historia] [varchar](5), 
		[mov_tipo] [varchar](5), [mov_codban] [int], [mov_forma_pago] [varchar](5), [mov_coddip] [int], [mov_codmdp] [int], 
		[mov_codfea] [int], [mov_lote] [varchar](5), [mov_fecha_cobro] [datetime], [mov_cliente] [varchar](200), [mov_codfac] [int], 
		[mov_puntoxpress] [int], [mov_recibo_puntoxpress] [nvarchar](50), [mov_fecha_real_pago] [datetime], 
		correlativo_anual int, mov_numero_control varchar(35)
	)

	declare @MiTabla table (
		fecha_del nvarchar(10), fecha_al nvarchar(10), uni_nombre nvarchar(100), uni_nit nvarchar(20), uni_iniciales nvarchar(25), 
		uni_direccion nvarchar(200), uni_registro nvarchar(20), dia nvarchar(2), tipo nvarchar(50), documento_del nvarchar(35), 
		documento_al nvarchar (35), exportacion float, ventas_exentas float, neto float, iva float, ventas_gravadas float, 
		total_ventas float, del date, cheque float, efectivo float, tarjeta float, lote float, TipoDocumento nvarchar(5), 
		tipo_factura varchar(15)--, numero_control varchar(35)
	)

	insert into @col_mov_Movimientos
	select mov_codreg, mov_codigo, mov_recibo, mov_fecha, mov_codper, mov_codcil, mov_descripcion, mov_tipo_pago, mov_cheque, 
		mov_estado, mov_tarjeta, mov_usuario, mov_fecha_registro, mov_usuario_anula, mov_fecha_anula, mov_codmod, mov_historia, 
		mov_tipo, mov_codban, mov_forma_pago, mov_coddip, mov_codmdp, mov_codfea, mov_lote, mov_fecha_cobro, mov_cliente, mov_codfac, 
		mov_puntoxpress, mov_recibo_puntoxpress, mov_fecha_real_pago, mov_correlativo_anual, mov_numero_control
	from col_mov_Movimientos 
	where convert(date, mov_fecha, 103) >= convert(datetime, @fecha_del, 103) and convert(date, mov_fecha, 103) <= convert(datetime, @fecha_al, 103)
	AND mov_tipo not in ('X')

	Insert into @MiTabla (fecha_del, fecha_al, uni_nombre, uni_nit, uni_iniciales, uni_direccion, 
	uni_registro, dia, tipo, documento_del, documento_al, exportacion, ventas_exentas, neto, iva, ventas_gravadas, 
	total_ventas, del, cheque, efectivo, tarjeta, lote, TipoDocumento, tipo_factura)

	select @fecha_del fecha_del, @fecha_al fecha_al, uni_nombre, uni_nit, uni_iniciales, uni_direccion, 
		uni_registro, right('0' + cast(day(del) as varchar), 2) dia, tipo, (
			select min(recibo)
			from (
				SELECT TOP 1 recibo FROM (
				select case when w.tipo_factura = 'dte' and correlativo_anual > 0 then mov_numero_control else TRY_CAST(mov_recibo AS VARCHAR) end 'recibo',
					case when w.tipo_factura = 'dte' and correlativo_anual > 0 then correlativo_anual else mov_recibo end 'correlativo'
				from @col_mov_Movimientos join col_dmo_det_mov on dmo_codmov = mov_codigo where mov_fecha = w.del
				--and mov_recibo <> 0 
				and dmo_valor >= 0 -- Permite omitir las facturas en negativo del caso de los seminarios 2013
				and mov_lote = lote --and dmo_codtmo in (2156) --Z-59 EN NEGATIVO
				and case when correlativo_anual > 0 then 'DTE' when mov_recibo <> 0 then 'Factura' else '-' end = w.tipo_factura
				group by mov_recibo, correlativo_anual, mov_numero_control
					union
				select case when w.tipo_factura = 'dte' and fac_correlativo_anual > 0 then fac_numero_control else TRY_CAST(fac_factura AS VARCHAR) end 'recibo',
					case when w.tipo_factura = 'dte' and fac_correlativo_anual > 0 then fac_correlativo_anual else fac_factura end 'correlativo'
				from col_fac_facturas
				left outer join col_dfa_det_fac on fac_codigo=dfa_codfac -- Agregado por omitir facturas en negativo 31/10/2014
				where fac_fecha = w.del and fac_tipo = 'F' and fac_lote = lote and dfa_valor>=0 -- Agregado   por omitir facturas en negativo 31/10/2014
				and fac_negativo<>1
				and case when fac_correlativo_anual > 0 then 'DTE' when fac_factura <> 0 then 'Factura' else '-' end = w.tipo_factura
				group by fac_factura, fac_correlativo_anual, fac_numero_control
					union
				select case when w.tipo_factura = 'dte' and fac_correlativo_anual > 0 then fac_numero_control else TRY_CAST(fac_factura AS VARCHAR) end 'recibo',
					case when w.tipo_factura = 'dte' and fac_correlativo_anual > 0 then fac_correlativo_anual else fac_factura end 'correlativo'
				from col_fac_facturas
				left outer join col_dfa_det_fac on fac_codigo=dfa_codfac -- Agregado   por omitir facturas en negativo 31/10/2014
				where fac_fecha = w.del and fac_tipo = 'F' and fac_lote = lote and dfa_valor<=0 -- Agregado   por omitir facturas en negativo 31/10/2014
				and fac_negativo=1
				and case when fac_correlativo_anual > 0 then 'DTE' when fac_factura <> 0 then 'Factura' else '-' end = w.tipo_factura
				group by fac_factura, fac_correlativo_anual, fac_numero_control
					union
				select case when w.tipo_factura = 'dte' and fac_correlativo_anual > 0 then fac_numero_control else TRY_CAST(fac_factura AS VARCHAR) end 'recibo',
					case when w.tipo_factura = 'dte' and fac_correlativo_anual > 0 then fac_correlativo_anual else fac_factura end 'correlativo'
				from col_fac_facturas
				left outer join col_dfa_det_fac on fac_codigo=dfa_codfac -- Agregado   por omitir facturas en negativo 31/10/2014
				where fac_fecha = w.del and fac_tipo = 'F' and fac_lote = lote and dfa_valor > 0 -- Agregado 07/12/2017, no mostraba facturas con fac_negativo is null
				and fac_negativo is null
				and case when fac_correlativo_anual > 0 then 'DTE' when fac_factura <> 0 then 'Factura' else '-' end = w.tipo_factura
				group by fac_factura, fac_correlativo_anual, fac_numero_control
				) tt order by correlativo ASC
			) t
		) documento_del, (
			select max(recibo)
			from (
				SELECT TOP 1 recibo FROM (
				select case when w.tipo_factura = 'dte' and correlativo_anual > 0 then mov_numero_control else TRY_CAST(mov_recibo AS VARCHAR) end 'recibo',
					case when w.tipo_factura = 'dte' and correlativo_anual > 0 then correlativo_anual else mov_recibo end 'correlativo'
				from @col_mov_Movimientos join col_dmo_det_mov on dmo_codmov = mov_codigo where mov_fecha = w.del --and mov_recibo <> 0
				--quitar comentario cuando ya halla pasado el mes de marzo 2021
				--and dmo_valor >= 0 -- Permite omitir las facturas en negativo del caso de los seminarios 2013
				and mov_lote = lote
				and case when correlativo_anual > 0 then 'DTE' when mov_recibo <> 0 then 'Factura' else '-' end = w.tipo_factura
				group by mov_recibo, correlativo_anual, mov_numero_control
					union
				select case when w.tipo_factura = 'dte' and fac_correlativo_anual > 0 then fac_numero_control else TRY_CAST(fac_factura AS VARCHAR) end 'recibo',
					case when w.tipo_factura = 'dte' and fac_correlativo_anual > 0 then fac_correlativo_anual else fac_factura end 'correlativo'
				from col_fac_facturas
				left outer join col_dfa_det_fac on fac_codigo=dfa_codfac -- Agregado   por omitir facturas en negativo 31/10/2014
				where fac_fecha = w.del and fac_tipo = 'F' and fac_lote = lote
				and dfa_valor>=0 -- Agregado   por omitir facturas en negativo 31/10/2014
				and fac_negativo<>1
				and case when fac_correlativo_anual > 0 then 'DTE' when fac_factura <> 0 then 'Factura' else '-' end = w.tipo_factura
				group by fac_factura, fac_correlativo_anual,fac_numero_control
					union
				select case when w.tipo_factura = 'dte' and fac_correlativo_anual > 0 then fac_numero_control else TRY_CAST(fac_factura AS VARCHAR) end 'recibo',
					case when w.tipo_factura = 'dte' and fac_correlativo_anual > 0 then fac_correlativo_anual else fac_factura end 'correlativo'
				from col_fac_facturas
				left outer join col_dfa_det_fac on fac_codigo=dfa_codfac -- Agregado   por omitir facturas en negativo 31/10/2014
				where fac_fecha = w.del and fac_tipo = 'F' and fac_lote = lote
				and dfa_valor <= 0 -- Agregado   por omitir facturas en negativo 31/10/2014
				and fac_negativo = 1
				and case when fac_correlativo_anual > 0 then 'DTE' when fac_factura <> 0 then 'Factura' else '-' end = w.tipo_factura
				group by fac_factura, fac_correlativo_anual, fac_numero_control
					union
				select case when w.tipo_factura = 'dte' and fac_correlativo_anual > 0 then fac_numero_control else TRY_CAST(fac_factura AS VARCHAR) end 'recibo',
					case when w.tipo_factura = 'dte' and fac_correlativo_anual > 0 then fac_correlativo_anual else fac_factura end 'correlativo'
				from col_fac_facturas
				left outer join col_dfa_det_fac on fac_codigo=dfa_codfac -- Agregado   por omitir facturas en negativo 31/10/2014
				where fac_fecha = w.del and fac_tipo = 'F' and fac_lote = lote
				and dfa_valor > 0 -- Agregado 07/12/2017, no mostraba facturas con fac_negativo is null
				and fac_negativo is null
				and case when fac_correlativo_anual > 0 then 'DTE' when fac_factura <> 0 then 'Factura' else '-' end = w.tipo_factura
				group by fac_factura, fac_correlativo_anual, fac_numero_control
				) tt order by correlativo DESC
			) t
		) documento_al, sum(expo) exportacion, sum(exento) ventas_exentas, sum(suma/1.13) neto, sum((suma/1.13) * 0.13) iva, 
		sum(suma) ventas_gravadas, sum(cantidad) total_ventas, w.del, sum(cheque) cheque, sum(efectivo) efectivo, sum(tarjeta) tarjeta, 
		lote, 'F' as TipoDocumento, tipo_factura--, mov_numero_control
	from (
		select uni_nombre, uni_nit, uni_iniciales, uni_direccion, uni_registro, Numero_Registro, Numero_Documento, tipo, 
			sum(expo) expo, sum(exento) exento, sum(neto) neto, sum(iva) iva, sum(suma) suma, sum(cantidad) Cantidad, estado, del, 
			sum(cheque) cheque, sum(efectivo) efectivo, sum(tarjeta) tarjeta, lote, tipo_factura--, mov_numero_control
		from (
			select uni_nombre, uni_nit, uni_iniciales, uni_direccion, uni_registro, convert(varchar,mov_codigo) Numero_Registro, 
				ltrim(rtrim(cast(mov_recibo as int))) Numero_Documento, 'Factura' tipo, 0 expo, 
				case when mov_estado = 'A' then 0 else case when isnull(dmo_iva, 0) > 0 then 0 else round(isnull(dmo_valor, 0), 2) end end exento, 
				case when mov_estado = 'A' then 0 else  case when isnull(dmo_iva,0) > 0 then isnull(/*dmo_valor*/((dmo_valor+dmo_iva)/1.13),0) else 0 end end neto, 
				case when mov_estado = 'A' then 0 else isnull(dmo_iva,0) end iva, 
				case when mov_estado = 'A' then 0 else case when isnull(dmo_iva,0) <> 0 then isnull(dmo_valor+dmo_iva,0) else 0 end end suma,
				case when mov_estado = 'A' then 0 else isnull((round(dmo_valor,2) + round(isnull(dmo_iva,0),2)),0) end "Cantidad", 
				case when mov_estado = 'A' then 0 else case when mov_tipo_pago = 'T' then isnull((round(dmo_valor,2) + round(isnull(dmo_iva,0),2)),0) else 0 end end tarjeta, 
				case when mov_estado = 'A' then 0 else case when mov_tipo_pago = 'E' then isnull((round(dmo_valor,2) + round(isnull(dmo_iva,0),2)),0) else 0 end end efectivo, 
				case when mov_estado = 'A' then 0 else case when mov_tipo_pago = 'C' then isnull((round(dmo_valor,2) + round(isnull(dmo_iva,0),2)),0) else 0 end end cheque, 
				mov_estado estado, mov_fecha del, mov_lote lote, 
				case when correlativo_anual > 0 then 'DTE' when mov_recibo <> 0 then 'Factura' else '-' end 'tipo_factura', mov_recibo, correlativo_anual--, mov_numero_control
			from @col_mov_Movimientos
				join col_dmo_det_mov on dmo_codmov = mov_codigo
				join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
				join ra_per_personas on per_codigo = mov_codper
				join ra_reg_regionales on reg_codigo = per_codreg
				join ra_uni_universidad on uni_codigo = reg_coduni 
			where mov_tipo not in ('X') AND mov_lote NOT IN ('5')

				union all

			select uni_nombre, uni_nit, uni_iniciales, uni_direccion, uni_registro, convert(varchar,fac_codigo) Numero_Registro, 
				ltrim(rtrim(cast(case when isnumeric(fac_factura) = 0 then 0 else fac_factura end as int))) Numero_Documento,
				'Factura' tipo, 0 expo, 
				case when fac_estado = 'A' then 0 else case when isnull(dfa_iva,0) > 0 or isnull(dfa_iva,0) < 0 then 0 else round (isnull(dfa_valor,0),2) end end exento, 
				case when fac_estado = 'A' then 0 else case when isnull(dfa_iva,0) > 0 or isnull(dfa_iva,0) < 0 then isnull(/*dmo_valor*/((dfa_valor)/1.13),0) else 0 end end neto, 
				case when fac_estado = 'A' then 0 else isnull(dfa_iva,0) end iva, 
				case when fac_estado = 'A' then 0 else case when isnull(dfa_iva,0) > 0 or isnull(dfa_iva,0) < 0 then isnull(dfa_valor,0) else 0 end end suma,
				case when fac_estado = 'A' then 0 else isnull((round(dfa_valor,2)),0) end "Cantidad", 
				case when fac_estado = 'A' then 0 else case when fac_tipo_pago = 'T' then isnull((round(dfa_valor,2) + round(isnull(dfa_iva,0),2)),0) else 0 end end tarjeta, 
				case when fac_estado = 'A' then 0 else case when fac_tipo_pago = 'E' then isnull((round(dfa_valor,2) + round(isnull(dfa_iva,0),2)),0) else 0 end end efectivo, 
				case when fac_estado = 'A' then 0 else case when fac_tipo_pago = 'C' then isnull((round(dfa_valor,2) + round(isnull(dfa_iva,0),2)),0) else 0 end end cheque, 
				fac_estado, fac_fecha del, fac_lote lote,
				case when fac_correlativo_anual > 0 then 'DTE' when fac_factura <> 0 then 'Factura' else '-' end 'tipo_factura', fac_factura, fac_correlativo_anual--, fac_numero_control
			from col_fac_facturas
				left outer join col_dfa_det_fac on dfa_codfac = fac_codigo
				left outer join col_tmo_tipo_movimiento on tmo_codigo = dfa_codtmo
				join col_cli_clientes on cli_codigo = fac_codcli
				join ra_reg_regionales on reg_codigo = @regional
				join ra_uni_universidad on uni_codigo = reg_coduni 
			where fac_fecha >= convert(datetime, @fecha_del) and fac_fecha <= convert(datetime, @fecha_al) and fac_tipo = 'F'
			--and fac_estado not in ('A')
			and fac_lote not in ('5')
		) t
		group by uni_nombre, uni_nit, uni_iniciales, uni_direccion, uni_registro, Numero_Registro, Numero_Documento, tipo, estado, del, lote, tipo_factura--, mov_numero_control
	) w 
	group by uni_nombre, uni_nit, uni_iniciales, uni_direccion, uni_registro, tipo, del, lote, tipo_factura--, mov_numero_control
	
	select fecha_del, fecha_al, uni_nombre, uni_nit, uni_iniciales, uni_direccion, uni_registro, dia, tipo, 
		isnull(documento_del, documento_al) documento_del, 
		documento_al, exportacion, ventas_exentas, neto, iva, ventas_gravadas, total_ventas, del, cheque, efectivo, tarjeta, 
		lote, TipoDocumento, tipo_factura--, ISNULL(numero_control, '-') numero_control
	from @MiTabla
	where lote not in ('5')
	order by TipoDocumento, lote, del, tipo desc, documento_del, documento_al

end
