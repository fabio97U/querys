	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-05-14 11:43:06.520>
	-- Description: <Muestra los logs de las facturas electronicas> select getdate()
	-- =============================================
	-- exec dbo.sp_logs_facturacion_electronica 1, 0, '01', '28/06/2023', '28/08/2023'
	-- exec dbo.sp_logs_facturacion_electronica 2, 0, '00', '01/05/2023', '14/05/2023'
create or alter procedure sp_logs_facturacion_electronica
	@opcion int = 0,
	@estado_dte int = 0,--0: Todos los estados
	@tipo_dte_numero int = 0,
	@fecha_desde varchar(12) = '',
	@fecha_hasta varchar(12) = '',
	@documento_recptor varchar(50) = '',
	@busqueda varchar(100) = '',
	@codusr int = 0,
	@codigo_origen int = 0
as
begin
	
	if @opcion = 1 or @opcion = 2
	begin
		declare @tbl as table (
			codfe int, tipo_dte varchar(5), documento varchar(5), fecha_registro_origen datetime, codigo_origen int, origen varchar(10), 
			codigo_receptor int, estado_origen varchar(5), tipo_documento_receptor varchar(5), 
			numero_documento_receptor varchar(50), correo_receptor varchar(50), 
			modelo_invalido bit, rechazos_modelo_invalido int, rechazado_por_mh bit, rechazos_por_mh int, 
			estado int, estado_texto varchar(50), numero_control varchar(36), fe_fecha_generacion_dte datetime, 
			fe_url_reporte varchar(1024), fe_url_codigo_qr varchar(1024), controller varchar(50), correlativo_anual int
		)
		insert into @tbl

		select t.fe_codigo, tipo_dte, documento, v.fecha_registro_origen, v.codigo_origen, v.origen, v.codigo_receptor, 
			v.estado_origen, 
			v.tipo_documento_receptor, v.numero_documento_receptor, v.correo_receptor, 
			v.modelo_invalido, v.rechazos_modelo_invalido, 
			v.rechazado_por_mh, v.rechazos_por_mh, estado, estado_texto, v.numero_control,
			fe_fecha_generacion_dte, fe_url_reporte, fe_url_codigo_qr, controller, v.correlativo_anual
		from vst_mh_encabezado_facturas v
			
			left join (
				select fe_codigo, fe_codigo_origen, fe_origen, fe_tipo_dte, fe_fecha_generacion_dte, fe_url_reporte, fe_url_codigo_qr, fe_aprobado_mh 
				from col_fe_factura_electronica fe where fe_aprobado_mh = 1
			) t on t.fe_codigo_origen = v.codigo_origen and t.fe_tipo_dte = v.tipo_dte--and t.fe_aprobado_mh = 1

		where convert(date, v.fecha_registro_origen, 103) between convert(date, @fecha_desde, 103) and convert(date, @fecha_hasta, 103)
			and v.tipo_dte_numero = case when @tipo_dte_numero = 0 then v.tipo_dte_numero else @tipo_dte_numero end
			--and codigo_origen = 12562
			and estado = case when @estado_dte = 0 then estado else @estado_dte end
			and (
				ltrim(rtrim(correo_receptor)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end
				or
				ltrim(rtrim(numero_documento_receptor)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end
				or
				ltrim(rtrim(codigo_origen)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end
				or
				ltrim(rtrim(recibo_punto_express)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end
			)
		order by fecha_registro_origen desc

		if @opcion = 1
		begin
			select * from @tbl
			order by fecha_registro_origen desc
		end

		if @opcion = 2
		begin
			select estado_texto, count(1) 'cantidad' from @tbl
			group by estado_texto
				
				union all

			select 'TOTAL' estado_texto, count(1) 'cantidad' from @tbl
		end

	end

	if @opcion = 3 -- Logs
	begin
		-- exec dbo.sp_logs_facturacion_electronica @opcion = 3, @tipo_dte_numero = 14, @codigo_origen = 6323
		select fe_codigo, fe_modelo_invalido, fe_rechazos_modelo_invalido, fe_aprobado_mh, fe_rechazo_mh_numero, 
			fe_fecha_creacion, fe_request, fe_response,
			case 
				when fe_modelo_invalido = 1 then 'DTE invalido' 
				when fe_aprobado_mh = 0 then 'Rechazado por hacienda'
				when fe_aprobado_mh = 1 then 'Aprobado por hacienda'
				else 'Pendiente de envió'
			end estado_texto 
		from col_fe_factura_electronica 
		where fe_tipo_dte = @tipo_dte_numero and fe_codigo_origen = @codigo_origen
		order by fe_codigo desc
	end

end
go

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_invalidar_DTE]    Script Date: 29/9/2023 09:26:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-06-28 21:14:04.093>
	-- Description: <Sp para realizar la anulacion de DTE>
	-- =============================================
	-- exec dbo.sp_invalidar_DTE 1, 423, 407
create or ALTER procedure [dbo].[sp_invalidar_DTE]
	@opcion int = 0,
	@codfe int = 0,
	@codusr int = 0,
	@ife_codcat024 int = 0,
	@ife_MotivoAnulacion varchar(500) = '',
	@ife_NombreResponsable varchar(250) = '',
	@ife_codcat022_TipDocResponsable int = 0,
	@ife_NumDocResponsable varchar(250) = '',
	@ife_NombreSolicita varchar(250) = '',
	@ife_codcat022_TipDocSolicita int = '',
	@ife_NumDocSolicita varchar(250) = '',
	@ife_codigo_generacion_reemplaza varchar(60) = '',
	@codife int = 0,
	@ife_telefono_receptor varchar(12) = ''
as
begin
	declare @tde_numero int = 0, @codigo_origen int = 0, @codigo_receptor int = 0, @codigo_generacion varchar(50) = ''
	declare @nombre_responsable varchar(250) = '', @documento_Responsable varchar(50) = ''
	
	select @nombre_responsable = emp_nombres_apellidos, @documento_Responsable = emp_dui from adm_usr_usuarios 
		inner join pla_emp_empleado on usr_codemp = emp_codigo
	where usr_codigo = @codusr
	select @tde_numero = fe_tipo_dte, @codigo_origen = fe_codigo_origen, @codigo_receptor = fe_codigo_receptor, @codigo_generacion = fe_codigo_generacion from col_fe_factura_electronica where fe_codigo = @codfe

	if @opcion = 1--Datos encabezado previos para la anulacion
	begin
		-- exec dbo.sp_invalidar_DTE @opcion = 1, @codfe = 662
		select @codfe 'codfe', documento, codigo_generacion, numero_control, sello_recepcion, fecha_registro_origen, fecha_generacion_fe, usuario_origen, nombrentrega, 
		codigo_receptor, nombre_receptor, isnull(tipo_documento_receptor , '0') tipo_documento_receptor, numero_documento_receptor, telefono_receptor, correo_receptor, estado_texto, controller, estado_origen,
		@nombre_responsable 'nombre_responsable', @documento_Responsable 'documento_responsable',
		flmf_fecha_limite 'modificar_antes_de',
		case when (fecha_registro_origen <= flmf_fecha_limite and getdate() <= flmf_fecha_limite) then 'Si' else 'No' end 'permitido_modificar', telefono_receptor
		from vst_mh_encabezado_facturas 
			left join col_flmf_fechas_limite_modificacion_facturas on month(fecha_registro_origen) = flmf_mes and year(fecha_registro_origen) = flmf_anio and day(fecha_registro_origen) = flmf_dia
		where tipo_dte_numero = @tde_numero and codigo_origen = @codigo_origen
	end
	
	if @opcion = 2--Datos detalle previos para la anulacion
	begin
		select codigo_origen, arancel, descripcion_arancel, valor_arancel, numero_documento, um14_valores 'unidad', cantidad, valor, iva, venta_exenta, 
		venta_gravada, tributos, venta_nosuj, monto_descuento, psv, no_gravado, iva_item, iva_retenido, procentaje_retencion, depreciacion, ciclo
		from vst_mh_detalle_facturas
			left join cat_um014_unidad_medida_014 on unidad_medida = um14_codigo
		where tipo_dte_numero = @tde_numero and codigo_encabezado_origen = @codigo_origen
	end

	if @opcion = 3--Inserta en la tabla de anulacion
	begin
		insert into col_ife_invalidacion_factura_electronica
		(ife_codfe, ife_tipo_dte_numero, ife_codigo_origen, ife_codcat024, ife_MotivoAnulacion, ife_NombreResponsable, 
		ife_codcat022_TipDocResponsable, ife_NumDocResponsable, ife_NombreSolicita, ife_codcat022_TipDocSolicita, ife_NumDocSolicita, ife_usuario_creacion, ife_codigo_generacion_reemplaza, ife_telefono_receptor)
		values (@codfe, @tde_numero, @codigo_origen, @ife_codcat024, @ife_MotivoAnulacion, @ife_NombreResponsable, 
		@ife_codcat022_TipDocResponsable, @ife_NumDocResponsable, @ife_NombreSolicita, @ife_codcat022_TipDocSolicita, @ife_NumDocSolicita, @codusr, 
		IIF(@ife_codigo_generacion_reemplaza = '', null, @ife_codigo_generacion_reemplaza), @ife_telefono_receptor)
		select SCOPE_IDENTITY() respuesta --Insertado
	end

	if @opcion = 4 -- Respuesta de mh de la invalidacion
	begin
		-- exec dbo.sp_invalidar_DTE 4, 423, 407
		select ife_codigo, ife_response_mh, ife_estado_mh, ife_request_mh, ife_fecha_respuesta_mh, ife_fecha_creacion from col_ife_invalidacion_factura_electronica where ife_codfe = @codfe
		order by ife_codigo desc
	end

	if @opcion = 5
	begin
		-- exec dbo.sp_invalidar_DTE @opcion = 5, @codfe = 638
		select '' 'codigo_generacion', '*Seleccione el nuevo DTE*' 'dte_generado', getdate() 'fecha_generacion_fe'
			union all
		select codigo_generacion, concat(documento, ' ', codigo_generacion, ', ', fecha_generacion_fe) 'dte_generado', fecha_generacion_fe 
		from vst_mh_encabezado_facturas 
		where codigo_receptor = @codigo_receptor and tipo_dte_numero = @tde_numero and codigo_generacion is not null
		and codigo_generacion not in (@codigo_generacion)
		order by fecha_generacion_fe desc
	end

end
