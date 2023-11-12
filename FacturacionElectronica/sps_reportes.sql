	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-05-07 14:04:53.097>
	-- Description: <Sp que retorna la data de la factura electronica>
	-- =============================================
	-- exec dbo.rep_mh_fe 1, '2023CC67E29E129E497A89A564708D1D6188XJJ1', 'DTE-01-00000000-000000000001912'--Encabezado
	-- exec dbo.rep_mh_fe 2, '2023CC67E29E129E497A89A564708D1D6188XJJ1', 'DTE-01-00000000-000000000001912'--Detalle
create or alter procedure rep_mh_fe
	@opcion int = 0,
	@selloRecibido varchar(50) = 0,
	@numero_control varchar(35) = ''
as
begin
	declare @request NVARCHAR(MAX), @url_imagen_codigo_qr varchar(1024) = '', @codfe int = 0

	declare @fe_anulado bit = 0

	--SELECT * FROM col_fe_factura_electronica where fe_aprobado_mh = 1
	select @request = fe_request, @url_imagen_codigo_qr = fe_url_imagen_codigo_qr, @fe_anulado = fe_anulado, @codfe = fe_codigo 
	from col_fe_factura_electronica 
	where fe_sello_recepcion = @selloRecibido and fe_numero_control = @numero_control and fe_tipo_dte = '01'
	--select @response

	if @opcion = 1
	begin
		SELECT t.*, @url_imagen_codigo_qr 'url_imagen_codigo_qr', @selloRecibido 'selloRecibido',
		case when tipoModelo = 1 then 'Modelo Facturación previo' else 'Modelo Facturación diferido' end 'tipoModelo_texto',
		case when tipoOperacion = 1 then 'Transmisión normal' else 'Transmisión por contingencia' end 'tipotransmisio_texto',
		per_carnet 'carnet', per_codigo 'ID', pla_alias_carrera 'carrera', 'Contado' 'condicionOperacion_texto',
		case when tipoEstablecimiento = '01' then 'Sucursal / Agencia'  when tipoEstablecimiento = '02' then 'Casa matriz' end 'tipoEstablecimiento_texto',
		fp017_valores 'forma_pago', 
		@fe_anulado 'fe_anulado', vi.solicitante_inva 'inva_nombre_solicitante', vi.solicitante_documento 'inva_documento_solicitante', 
		vi.razon_ti024 'inva_motivo', vi.codigo_generacion_nuevo_dte 'inva_dte_nuevo', 
		(select v.codigo_generacion from vst_mh_encabezado_facturas v where codigo_generacion = vi.codigo_generacion_nuevo_dte) 'inva_fecha_nuevo_dte', vi.fecha_respuesta_mh 'inva_fecha_creacion'
		FROM OPENJSON ( @request )  
		WITH (   
			codActividad varchar(20) '$.emisor.codActividad',
			correo_emisor varchar(50) '$.emisor.correo',
			descActividad varchar(150) '$.emisor.descActividad',
			complemento_emisor varchar(500) '$.emisor.direccion.complemento',
			departamento_emisor varchar(5) '$.emisor.direccion.departamento',
			municipio_emisor varchar(5) '$.emisor.direccion.municipio',
			nit_emisor varchar(20) '$.emisor.nit',
			nombre varchar(50) '$.emisor.nombre',
			nombreComercial varchar(50) '$.emisor.nombreComercial',
			nrc varchar(10) '$.emisor.nrc',
			telefono varchar(15) '$.emisor.telefono',
			tipoEstablecimiento varchar(5) '$.emisor.tipoEstablecimiento',

			docuEntrega varchar(20) '$.extension.docuEntrega',
			nombEntrega varchar(100) '$.extension.nombEntrega',
			docuRecibe varchar(20) '$.extension.docuRecibe',
			nombRecibe varchar(100) '$.extension.nombRecibe',

			ambiente varchar(2) '$.identificacion.ambiente',
			codigo_establecimiento varchar(5) '$.identificacion.codigo_establecimiento',
			codigo_origen varchar(10) '$.identificacion.codigo_origen',
			codigo_punto_venta varchar(5) '$.identificacion.codigo_punto_venta',
			codigoGeneracion varchar(50) '$.identificacion.codigoGeneracion',
			fecEmi date '$.identificacion.fecEmi',
			fecha_generacion_dte varchar(30) '$.identificacion.fecha_generacion_dte',
			horEmi varchar(8) '$.identificacion.horEmi',
			numeroControl varchar(35) '$.identificacion.numeroControl',
			origen varchar(10) '$.identificacion.origen',
			tipoDte varchar(3) '$.identificacion.tipoDte',
			tipoModelo int '$.identificacion.tipoModelo',
			tipoMoneda varchar(5) '$.identificacion.tipoMoneda',
			tipoOperacion int '$.identificacion.tipoOperacion',
			version int '$.identificacion.version',
			codigo_receptor int '$.identificacion.codigo_receptor',
			correo varchar(50) '$.receptor.correo',
			complemento_receptor varchar(500) '$.receptor.direccion.complemento',
			departamento_receptor varchar(5) '$.receptor.direccion.departamento',
			municipio_receptor varchar(5) '$.receptor.direccion.municipio',
			nombre_receptor varchar(150) '$.receptor.nombre',
			numDocumento_receptor varchar(30) '$.receptor.numDocumento',
			ciclo varchar(15) '$.identificacion.ciclo',
			telefono_receptor varchar(30) '$.receptor.telefono',
			tipoDocumento_receptor varchar(3) '$.receptor.tipoDocumento',
			condicionOperacion varchar(2) '$.resumen.condicionOperacion',

			descuExenta float '$.resumen.descuExenta',
			descuGravada float '$.resumen.descuGravada',
			descuNoSuj float '$.resumen.descuNoSuj',
			ivaRete1 float '$.resumen.ivaRete1',
			montoTotalOperacion float '$.resumen.montoTotalOperacion',
			numPagoElectronico varchar(60) '$.resumen.numPagoElectronico',
			codigo_resumen varchar(2) '$.resumen.pagos[0].codigo',
			montoPago_resumen float '$.resumen.pagos[0].montoPago',
			referencia_resumen varchar(60) '$.resumen.pagos[0].referencia',
			porcentajeDescuento_resumen float '$.resumen.porcentajeDescuento',
			reteRenta float '$.resumen.reteRenta',
			saldoFavor float '$.resumen.saldoFavor',
			subTotal float '$.resumen.subTotal',
			subTotalVentas float '$.resumen.subTotalVentas',
			totalDescu float '$.resumen.totalDescu',
			totalExenta float '$.resumen.totalExenta',
			totalGravada float '$.resumen.totalGravada',
			totalIva float '$.resumen.totalIva',
			totalLetras varchar(100) '$.resumen.totalLetras',
			totalNoGravado float '$.resumen.totalNoGravado',
			totalNoSuj float '$.resumen.totalNoSuj',
			totalPagar float '$.resumen.totalPagar'
		) t
			left join ra_per_personas on per_codigo = codigo_receptor
			left join ra_alc_alumnos_carrera on alc_codper = per_codigo
			left join ra_pla_planes on alc_codpla = pla_codigo
			left join cat_fp017_forma_pago_017 on fp017_codigo = t.codigo_resumen
			left join vst_mh_invalidaciones_dte vi on vi.codfe = @codfe --and vi.estado_mh = 'Aprobado'
		return
	end

	if @opcion = 2
	begin
		declare @tbl as table (_key varchar(50), _value varchar(max), _type int)
		insert into @tbl
		SELECT * FROM OPENJSON ( @request )
		declare @_cuerpo_documento varchar(max)
		select @_cuerpo_documento = _value from @tbl where _key = 'cuerpoDocumento'

		set @request = @_cuerpo_documento
		SELECT * FROM OPENJSON ( @request )
		WITH  (
			numItem int '$.numItem',
			cantidad int '$.cantidad',
			codigo varchar(15) '$.codigo',
			descripcion varchar(1024) '$.descripcion',
			ivaItem float '$.ivaItem',
			montoDescu float '$.montoDescu',
			noGravado float '$.noGravado',
			precioUni float '$.precioUni',
			psv float '$.psv',
			tipoItem float '$.tipoItem',
			uniMedida float '$.uniMedida',
			ventaExenta float '$.ventaExenta',
			ventaGravada float '$.ventaGravada',
			ventaNoSuj float '$.ventaNoSuj'
		)
	end

end
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-06-04 13:27:13.437>
	-- Description: <Sp que retorna la data del comprobante de retencion>
	-- =============================================
	-- exec dbo.rep_mh_cre 1, '20237A16ED1D63994A929564AD44321F44DDQR7Y', 'DTE-07-12345678-000000000000006'--Encabezado
	-- exec dbo.rep_mh_cre 2, '20237A16ED1D63994A929564AD44321F44DDQR7Y', 'DTE-07-12345678-000000000000006'--Detalle
create or alter procedure rep_mh_cre
	@opcion int = 0,
	@selloRecibido varchar(50) = 0,
	@numero_control varchar(35) = ''
as
begin
	declare @request NVARCHAR(MAX), @url_imagen_codigo_qr varchar(1024) = '', @fe_anulado bit = 0, @codfe int = 0
	--SELECT * FROM col_fe_factura_electronica where fe_aprobado_mh = 1
	select @request = fe_request, @url_imagen_codigo_qr = fe_url_imagen_codigo_qr, @fe_anulado = fe_anulado, @codfe = fe_codigo 
	from col_fe_factura_electronica 
	where fe_sello_recepcion = @selloRecibido and fe_numero_control = @numero_control and fe_tipo_dte = '07'

	--select @request
	if @opcion = 1
	begin
		SELECT t.*, @url_imagen_codigo_qr 'url_imagen_codigo_qr', @selloRecibido 'selloRecibido',
		case when tipoModelo = 1 then 'Modelo Facturación previo' else 'Modelo Facturación diferido' end 'tipoModelo_texto',
		case when tipoOperacion = 1 then 'Transmisión normal' else 'Transmisión por contingencia' end 'tipotransmisio_texto',
		pro_codigo 'pro_codigo', pro_nit 'pro_nit', pro_nombre_contacto 'carrera', 'Contado' 'condicionOperacion_texto',
		case when tipoEstablecimiento = '01' then 'Sucursal / Agencia'  when tipoEstablecimiento = '02' then 'Casa matriz' end 'tipoEstablecimiento_texto',
		cae019_valores 'actividadEconomicaReceptor', 
		@fe_anulado 'fe_anulado', vi.solicitante_inva 'inva_nombre_solicitante', vi.solicitante_documento 'inva_documento_solicitante', 
		vi.razon_ti024 'inva_motivo', vi.codigo_generacion_nuevo_dte 'inva_dte_nuevo', 
		(select v.codigo_generacion from vst_mh_encabezado_facturas v where codigo_generacion = vi.codigo_generacion_nuevo_dte) 'inva_fecha_nuevo_dte', vi.fecha_respuesta_mh 'inva_fecha_creacion'
		FROM OPENJSON ( @request )  
		WITH (   
			codActividad varchar(20) '$.emisor.codActividad',
			correo_emisor varchar(50) '$.emisor.correo',
			descActividad varchar(150) '$.emisor.descActividad',
			complemento_emisor varchar(500) '$.emisor.direccion.complemento',
			departamento_emisor varchar(5) '$.emisor.direccion.departamento',
			municipio_emisor varchar(5) '$.emisor.direccion.municipio',
			nit_emisor varchar(20) '$.emisor.nit',
			nombre varchar(50) '$.emisor.nombre',
			nombreComercial varchar(50) '$.emisor.nombreComercial',
			nrc varchar(10) '$.emisor.nrc',
			telefono varchar(15) '$.emisor.telefono',
			tipoEstablecimiento varchar(5) '$.emisor.tipoEstablecimiento',

			docuEntrega varchar(20) '$.extension.docuEntrega',
			nombEntrega varchar(100) '$.extension.nombEntrega',
			docuRecibe varchar(20) '$.extension.docuRecibe',
			nombRecibe varchar(100) '$.extension.nombRecibe',

			ambiente varchar(2) '$.identificacion.ambiente',
			codigo_establecimiento varchar(5) '$.identificacion.codigo_establecimiento',
			codigo_origen varchar(10) '$.identificacion.codigo_origen',
			codigo_punto_venta varchar(5) '$.identificacion.codigo_punto_venta',
			codigoGeneracion varchar(50) '$.identificacion.codigoGeneracion',
			fecEmi date '$.identificacion.fecEmi',
			fecha_generacion_dte varchar(30) '$.identificacion.fecha_generacion_dte',
			horEmi varchar(8) '$.identificacion.horEmi',
			numeroControl varchar(35) '$.identificacion.numeroControl',
			origen varchar(10) '$.identificacion.origen',
			tipoDte varchar(3) '$.identificacion.tipoDte',
			tipoModelo int '$.identificacion.tipoModelo',
			tipoMoneda varchar(5) '$.identificacion.tipoMoneda',
			tipoOperacion int '$.identificacion.tipoOperacion',
			version int '$.identificacion.version',
			codigo_receptor int '$.identificacion.codigo_receptor',
			correo varchar(50) '$.receptor.correo',
			complemento_receptor varchar(500) '$.receptor.direccion.complemento',
			departamento_receptor varchar(5) '$.receptor.direccion.departamento',
			municipio_receptor varchar(5) '$.receptor.direccion.municipio',
			nombre_receptor varchar(150) '$.receptor.nombre',
			numDocumento_receptor varchar(30) '$.receptor.numDocumento',
			telefono_receptor varchar(30) '$.receptor.telefono',
			tipoDocumento_receptor varchar(3) '$.receptor.tipoDocumento',
			nombreComercial varchar(50) '$.receptor.nombreComercial',
			nrcReceptor varchar(15) '$.receptor.nrc',
			condicionOperacion varchar(2) '$.resumen.condicionOperacion',

			totalSujetoRetencion float '$.resumen.totalSujetoRetencion',
			totalIVAretenido float '$.resumen.totalIVAretenido',
			totalLetras varchar(100) '$.resumen.totalIVAretenidoLetras'
		) t
			left join con_pro_proveedores on pro_codigo = codigo_receptor
			left join cat_cae019_codigo_actividad_economica_019 on cae019_codigo = pro_codcae019
			left join vst_mh_invalidaciones_dte vi on vi.codfe = @codfe
		return
	end

	if @opcion = 2
	begin
		declare @tbl as table (_key varchar(50), _value varchar(max), _type int)
		insert into @tbl
		SELECT * FROM OPENJSON ( @request )
		declare @_cuerpo_documento varchar(max)
		select @_cuerpo_documento = _value from @tbl where _key = 'cuerpoDocumento'

		set @request = @_cuerpo_documento
		--select @_cuerpo_documento
		SELECT numItem, tipoDte, tipoDoc, numDocumento, 1 cantidad, format(fechaEmision, 'dd/MM/yyyy') fechaEmision, montoSujetoGrav, codigoRetencionMH, ivaRetenido, descripcion, 
			tgd007_valores 'tipoGeneracionDocumento', td002_valores 'tipoDocumento'
		FROM OPENJSON ( @request )
		WITH  (
			numItem int '$.numItem',
			tipoDte varchar(15) '$.tipoDte',
			tipoDoc varchar(25) '$.tipoDoc',
			numDocumento varchar(50) '$.numDocumento',
			fechaEmision date '$.fechaEmision',

			montoSujetoGrav float '$.montoSujetoGrav',
			codigoRetencionMH varchar(5) '$.codigoRetencionMH',
			ivaRetenido float '$.ivaRetenido',
			descripcion varchar(500) '$.descripcion'
		)
			left join cat_tgd007_tipo_generacion_documento_007 on tgd007_codigo = tipoDoc
			left join cat_td002_tipo_documento_002 on td002_codigo = tipoDte
	end

end
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-06-05 20:59:02.107>
	-- Description: <Sp que retorna la data del comprobante de donacion>
	-- =============================================
	-- exec dbo.rep_mh_cde 1, '2023BCCD97A59166474CB7E5ED1C7F052F47XXXX', 'DTE-15-12345678-000000000000001'--Encabezado
	-- exec dbo.rep_mh_cde 2, '2023BCCD97A59166474CB7E5ED1C7F052F47XXXX', 'DTE-15-12345678-000000000000001'--Detalle
create or alter procedure rep_mh_cde
	@opcion int = 0,
	@selloRecibido varchar(50) = 0,
	@numero_control varchar(35) = ''
as
begin
	declare @request NVARCHAR(MAX), @url_imagen_codigo_qr varchar(1024) = '', @fe_anulado bit = 0, @codfe int = 0
	select @request = fe_request, @url_imagen_codigo_qr = fe_url_imagen_codigo_qr, @fe_anulado = fe_anulado, @codfe = fe_codigo from col_fe_factura_electronica 
	where fe_sello_recepcion = @selloRecibido and fe_numero_control = @numero_control and fe_tipo_dte = '15'

	--select @request
	if @opcion = 1
	begin
		SELECT t.*, @url_imagen_codigo_qr 'url_imagen_codigo_qr', @selloRecibido 'selloRecibido',
		case when tipoModelo = 1 then 'Modelo Facturación previo' else 'Modelo Facturación diferido' end 'tipoModelo_texto',
		case when tipoOperacion = 1 then 'Transmisión normal' else 'Transmisión por contingencia' end 'tipotransmisio_texto',
		pro_codigo 'pro_codigo', pro_nit 'pro_nit', pro_nombre_contacto 'carrera', 'Contado' 'condicionOperacion_texto',
		case when tipoEstablecimiento = '01' then 'Sucursal / Agencia'  when tipoEstablecimiento = '02' then 'Casa matriz' end 'tipoEstablecimiento_texto',
		cae019_valores 'actividadEconomicadonante', tdia022_valores 'tipoDocumentoDonanante', 
		@fe_anulado 'fe_anulado', vi.solicitante_inva 'inva_nombre_solicitante', vi.solicitante_documento 'inva_documento_solicitante', 
		vi.razon_ti024 'inva_motivo', vi.codigo_generacion_nuevo_dte 'inva_dte_nuevo', 
		(select v.codigo_generacion from vst_mh_encabezado_facturas v where codigo_generacion = vi.codigo_generacion_nuevo_dte) 'inva_fecha_nuevo_dte', vi.fecha_respuesta_mh 'inva_fecha_creacion'
		FROM OPENJSON ( @request )  
		WITH (   
			codActividad varchar(20) '$.donatario.codActividad',
			correo_donatario varchar(50) '$.donatario.correo',
			descActividad varchar(150) '$.donatario.descActividad',
			complemento_donatario varchar(500) '$.donatario.direccion.complemento',
			departamento_donatario varchar(5) '$.donatario.direccion.departamento',
			municipio_donatario varchar(5) '$.donatario.direccion.municipio',
			numDocumento varchar(20) '$.donatario.numDocumento',
			nombre varchar(50) '$.donatario.nombre',
			nombreComercial varchar(50) '$.donatario.nombreComercial',
			nrc varchar(10) '$.donatario.nrc',
			telefono varchar(15) '$.donatario.telefono',
			tipoEstablecimiento varchar(5) '$.donatario.tipoEstablecimiento',

			ambiente varchar(2) '$.identificacion.ambiente',
			codigo_establecimiento varchar(5) '$.identificacion.codigo_establecimiento',
			codigo_origen varchar(10) '$.identificacion.codigo_origen',
			codigo_punto_venta varchar(5) '$.identificacion.codigo_punto_venta',
			codigoGeneracion varchar(50) '$.identificacion.codigoGeneracion',
			fecEmi date '$.identificacion.fecEmi',
			fecha_generacion_dte varchar(30) '$.identificacion.fecha_generacion_dte',
			horEmi varchar(8) '$.identificacion.horEmi',
			numeroControl varchar(35) '$.identificacion.numeroControl',
			origen varchar(10) '$.identificacion.origen',
			tipoDte varchar(3) '$.identificacion.tipoDte',
			tipoModelo int '$.identificacion.tipoModelo',
			tipoMoneda varchar(5) '$.identificacion.tipoMoneda',
			tipoOperacion int '$.identificacion.tipoOperacion',
			version int '$.identificacion.version',
			codigo_donante int '$.identificacion.codigo_donante',
			correo varchar(50) '$.donante.correo',
			complemento_donante varchar(500) '$.donante.direccion.complemento',
			departamento_donante varchar(5) '$.donante.direccion.departamento',
			municipio_donante varchar(5) '$.donante.direccion.municipio',
			nombre_donante varchar(150) '$.donante.nombre',
			numDocumento_donante varchar(30) '$.donante.numDocumento',
			telefono_donante varchar(30) '$.donante.telefono',
			tipoDocumento_donante varchar(3) '$.donante.tipoDocumento',
			nombreComercial varchar(3) '$.donante.nombreComercial',
			nrcdonante varchar(10) '$.donante.nrc',
			condicionOperacion varchar(2) '$.resumen.condicionOperacion',

			valorTotal float '$.resumen.valorTotal',
			totalLetras varchar(100) '$.resumen.totalLetras'
		) t
			left join con_pro_proveedores on pro_codigo = codigo_donante
			left join cat_cae019_codigo_actividad_economica_019 on cae019_codigo = pro_codcae019
			left join cat_tdia022_tipo_documento_identificacion_asociado_022 on tdia022_codigo = tipoDocumento_donante
			left join vst_mh_invalidaciones_dte vi on vi.codfe = @codfe
		return
	end

	if @opcion = 2
	begin
		declare @tbl as table (_key varchar(50), _value varchar(max), _type int)
		insert into @tbl
		SELECT * FROM OPENJSON ( @request )
		declare @_cuerpo_documento varchar(max)
		select @_cuerpo_documento = _value from @tbl where _key = 'cuerpoDocumento'

		set @request = @_cuerpo_documento
		SELECT numItem, tipoDonacion 'codigoTipoDonacion', td026_valores 'tipoDonacion', cantidad, 
		uniMedida, um14_valores 'unidad', descripcion, depreciacion, valorUni, valor
		FROM OPENJSON ( @request )
		WITH  (
			numItem int '$.numItem',
			tipoDonacion varchar(25) '$.tipoDonacion',
			cantidad varchar(25) '$.cantidad',
			uniMedida varchar(25) '$.uniMedida',
			descripcion varchar(500) '$.descripcion',

			depreciacion float '$.depreciacion',
			valorUni float '$.valorUni',
			valor float '$.valor'
		)
			left join cat_um014_unidad_medida_014 on um14_codigo = uniMedida
			inner join cat_td026_tipo_donacion_026 on tipoDonacion = td026_codigo
	end

end
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-06-15 21:16:32.633>
	-- Description: <Sp que retorna la data del sujeto excluido>
	-- =============================================
	-- exec dbo.rep_mh_fse 1, '2023A2CB0A672F814EDA9977B64CBA370F6DP7WE', 'DTE-14-00000000-000000000000010'--Encabezado
	-- exec dbo.rep_mh_fse 2, '2023A2CB0A672F814EDA9977B64CBA370F6DP7WE', 'DTE-14-00000000-000000000000010'--Detalle
create or alter procedure rep_mh_fse
	@opcion int = 0,
	@selloRecibido varchar(50) = 0,
	@numero_control varchar(35) = ''
as
begin
	declare @request NVARCHAR(MAX), @url_imagen_codigo_qr varchar(1024) = '', @fe_anulado bit = 0, @codfe int = 0
	select @request = fe_request, @url_imagen_codigo_qr = fe_url_imagen_codigo_qr, @fe_anulado = fe_anulado, @codfe = fe_codigo from col_fe_factura_electronica 
	where fe_sello_recepcion = @selloRecibido and fe_numero_control = @numero_control and fe_tipo_dte = '14'

	--select @request
	if @opcion = 1
	begin
		SELECT t.*, @url_imagen_codigo_qr 'url_imagen_codigo_qr', @selloRecibido 'selloRecibido',
		case when tipoModelo = 1 then 'Modelo Facturación previo' else 'Modelo Facturación diferido' end 'tipoModelo_texto',
		case when tipoOperacion = 1 then 'Transmisión normal' else 'Transmisión por contingencia' end 'tipotransmisio_texto',
		pro_codigo 'pro_codigo', pro_nit 'pro_nit', 'Contado' 'condicionOperacion_texto',
		case when tipoEstablecimiento = '01' then 'Sucursal / Agencia'  when tipoEstablecimiento = '02' then 'Casa matriz' end 'tipoEstablecimiento_texto',
		cae019_valores 'actividadEconomicareceptor', tdia022_valores 'tipoDocumentoReceptor', @fe_anulado 'fe_anulado', vi.solicitante_inva 'inva_nombre_solicitante', vi.solicitante_documento 'inva_documento_solicitante', 
		vi.razon_ti024 'inva_motivo', vi.codigo_generacion_nuevo_dte 'inva_dte_nuevo', 
		(select v.codigo_generacion from vst_mh_encabezado_facturas v where codigo_generacion = vi.codigo_generacion_nuevo_dte) 'inva_fecha_nuevo_dte', vi.fecha_respuesta_mh 'inva_fecha_creacion'
		FROM OPENJSON ( @request )  
		WITH (   
			codActividad varchar(20) '$.emisor.codActividad',
			correo_emisor varchar(50) '$.emisor.correo',
			descActividad varchar(150) '$.emisor.descActividad',
			complemento_emisor varchar(500) '$.emisor.direccion.complemento',
			departamento_emisor varchar(5) '$.emisor.direccion.departamento',
			municipio_emisor varchar(5) '$.emisor.direccion.municipio',
			numDocumento varchar(20) '$.emisor.nit',
			nombre varchar(50) '$.emisor.nombre',
			nombreComercial varchar(50) '$.emisor.nombre',
			nrc varchar(10) '$.emisor.nrc',
			telefono varchar(15) '$.emisor.telefono',
			tipoEstablecimiento varchar(5) '$.emisor.tipoEstablecimiento',

			ambiente varchar(2) '$.identificacion.ambiente',
			codigo_establecimiento varchar(5) '$.identificacion.codigo_establecimiento',
			codigo_origen varchar(10) '$.identificacion.codigo_origen',
			codigo_punto_venta varchar(5) '$.identificacion.codigo_punto_venta',
			codigoGeneracion varchar(50) '$.identificacion.codigoGeneracion',
			fecEmi date '$.identificacion.fecEmi',
			fecha_generacion_dte varchar(30) '$.identificacion.fecha_generacion_dte',
			horEmi varchar(8) '$.identificacion.horEmi',
			numeroControl varchar(35) '$.identificacion.numeroControl',
			origen varchar(10) '$.identificacion.origen',
			tipoDte varchar(3) '$.identificacion.tipoDte',
			tipoModelo int '$.identificacion.tipoModelo',
			tipoMoneda varchar(5) '$.identificacion.tipoMoneda',
			tipoOperacion int '$.identificacion.tipoOperacion',
			version int '$.identificacion.version',
			codigo_receptor int '$.identificacion.codigo_receptor',
			correo varchar(50) '$.sujetoExcluido.correo',
			complemento_receptor varchar(500) '$.sujetoExcluido.direccion.complemento',
			departamento_receptor varchar(5) '$.sujetoExcluido.direccion.departamento',
			municipio_receptor varchar(5) '$.sujetoExcluido.direccion.municipio',
			nombre_receptor varchar(150) '$.sujetoExcluido.nombre',
			numDocumento_receptor varchar(30) '$.sujetoExcluido.numDocumento',
			telefono_receptor varchar(30) '$.sujetoExcluido.telefono',
			tipoDocumento_receptor varchar(3) '$.sujetoExcluido.tipoDocumento',
			nombreComercial varchar(3) '$.sujetoExcluido.nombreComercial',
			nrcreceptor varchar(10) '$.sujetoExcluido.nrc',

			condicionOperacion varchar(2) '$.resumen.condicionOperacion',

			totalCompra float '$.resumen.totalCompra',
			descu float '$.resumen.descu',
			totalDescu float '$.resumen.totalDescu',
			subTotal float '$.resumen.subTotal',
			ivaRete1 float '$.resumen.ivaRete1',
			reteRenta float '$.resumen.reteRenta',
			totalPagar float '$.resumen.totalPagar',
			totalLetras varchar(100) '$.resumen.totalLetras'

		) t
			left join con_pro_proveedores on pro_codigo = codigo_receptor
			left join cat_cae019_codigo_actividad_economica_019 on cae019_codigo = pro_codcae019
			left join cat_tdia022_tipo_documento_identificacion_asociado_022 on tdia022_codigo = tipoDocumento_receptor
			left join vst_mh_invalidaciones_dte vi on vi.codfe = @codfe
		return
	end

	if @opcion = 2
	begin
		declare @tbl as table (_key varchar(50), _value varchar(max), _type int)
		insert into @tbl
		SELECT * FROM OPENJSON ( @request )
		declare @_cuerpo_documento varchar(max)
		select @_cuerpo_documento = _value from @tbl where _key = 'cuerpoDocumento'

		set @request = @_cuerpo_documento
		SELECT numItem, cantidad, 
		uniMedida, um14_valores 'unidad', descripcion, precioUni, montoDescu, compra
		FROM OPENJSON ( @request )
		WITH  (
			numItem int '$.numItem',
			cantidad varchar(25) '$.cantidad',
			uniMedida varchar(25) '$.uniMedida',
			descripcion varchar(250) '$.descripcion',

			precioUni float '$.precioUni',
			montoDescu float '$.montoDescu',
			compra float '$.compra'
		)
			left join cat_um014_unidad_medida_014 on um14_codigo = uniMedida
	end

end
go


	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-06-19 15:32:40.607>
	-- Description: <Sp que retorna la data de la factura de exportacion>
	-- =============================================
	-- exec dbo.rep_mh_fexe 1, '20237B7EE07C76ED43798E585ECC7ECB17A7NGBS', 'DTE-11-12345678-000000000000003'--Encabezado
	-- exec dbo.rep_mh_fexe 2, '20237B7EE07C76ED43798E585ECC7ECB17A7NGBS', 'DTE-11-12345678-000000000000003'--Detalle
create or alter procedure rep_mh_fexe
	@opcion int = 0,
	@selloRecibido varchar(50) = 0,
	@numero_control varchar(35) = ''
as
begin
	declare @request NVARCHAR(MAX), @url_imagen_codigo_qr varchar(1024) = '', @fe_anulado bit = 0, @codfe int = 0
	select @request = fe_request, @url_imagen_codigo_qr = fe_url_imagen_codigo_qr, @fe_anulado = fe_anulado, @codfe = fe_codigo from col_fe_factura_electronica 
	where fe_sello_recepcion = @selloRecibido and fe_numero_control = @numero_control and fe_tipo_dte = '11'

	--select @request
	if @opcion = 1
	begin
		SELECT t.*, @url_imagen_codigo_qr 'url_imagen_codigo_qr', @selloRecibido 'selloRecibido',
		case when tipoModelo = 1 then 'Modelo Facturación previo' else 'Modelo Facturación diferido' end 'tipoModelo_texto',
		case when tipoOperacion = 1 then 'Transmisión normal' else 'Transmisión por contingencia' end 'tipotransmisio_texto',
		'Contado' 'condicionOperacion_texto',
		case when tipoEstablecimiento = '01' then 'Sucursal / Agencia'  when tipoEstablecimiento = '02' then 'Casa matriz' end 'tipoEstablecimiento_texto',
		cae019_valores 'actividadEconomicareceptor', tdia022_valores 'tipoDocumentoReceptor', '' 'recintoFiscal', '' 'regimenExportacion',
		cli_telefono 'telefono_receptor', cli_codigo 'codcli', '' 'descripcionIncoterms', '' 'observaciones', @fe_anulado 'fe_anulado', vi.solicitante_inva 'inva_nombre_solicitante', vi.solicitante_documento 'inva_documento_solicitante', 
		vi.razon_ti024 'inva_motivo', vi.codigo_generacion_nuevo_dte 'inva_dte_nuevo', 
		(select v.codigo_generacion from vst_mh_encabezado_facturas v where codigo_generacion = vi.codigo_generacion_nuevo_dte) 'inva_fecha_nuevo_dte', vi.fecha_respuesta_mh 'inva_fecha_creacion'
		FROM OPENJSON ( @request )  
		WITH (   
			codActividad varchar(20) '$.emisor.codActividad',
			correo_emisor varchar(50) '$.emisor.correo',
			descActividad varchar(150) '$.emisor.descActividad',
			complemento_emisor varchar(500) '$.emisor.direccion.complemento',
			departamento_emisor varchar(5) '$.emisor.direccion.departamento',
			municipio_emisor varchar(5) '$.emisor.direccion.municipio',
			numDocumento varchar(20) '$.emisor.nit',
			nombre varchar(50) '$.emisor.nombre',
			nombreComercial varchar(50) '$.emisor.nombre',
			nrc varchar(10) '$.emisor.nrc',
			telefono varchar(15) '$.emisor.telefono',
			tipoEstablecimiento varchar(5) '$.emisor.tipoEstablecimiento',

			ambiente varchar(2) '$.identificacion.ambiente',
			codigo_establecimiento varchar(5) '$.identificacion.codigo_establecimiento',
			codigo_origen varchar(10) '$.identificacion.codigo_origen',
			codigo_punto_venta varchar(5) '$.identificacion.codigo_punto_venta',
			codigoGeneracion varchar(50) '$.identificacion.codigoGeneracion',
			fecEmi date '$.identificacion.fecEmi',
			fecha_generacion_dte varchar(30) '$.identificacion.fecha_generacion_dte',
			horEmi varchar(8) '$.identificacion.horEmi',
			numeroControl varchar(35) '$.identificacion.numeroControl',
			origen varchar(10) '$.identificacion.origen',
			tipoDte varchar(3) '$.identificacion.tipoDte',
			tipoModelo int '$.identificacion.tipoModelo',
			tipoMoneda varchar(5) '$.identificacion.tipoMoneda',
			tipoOperacion int '$.identificacion.tipoOperacion',
			version int '$.identificacion.version',
			codigo_receptor int '$.identificacion.codigo_receptor',
			correo varchar(50) '$.receptor.correo',
			complemento_receptor varchar(500) '$.receptor.complemento',
			departamento_receptor varchar(5) '$.receptor.direccion.departamento',
			municipio_receptor varchar(5) '$.receptor.direccion.municipio',
			nombre_receptor varchar(150) '$.receptor.nombre',
			numDocumento_receptor varchar(30) '$.receptor.numDocumento',
			descActividad_receptor varchar(150) '$.receptor.descActividad',
			nombrePais varchar(80) '$.receptor.nombrePais',
			--telefono_receptor varchar(30) '$.receptor.telefono',
			tipoDocumento_receptor varchar(3) '$.receptor.tipoDocumento',
			nombreComercial_receptor varchar(150) '$.receptor.nombreComercial',
			nrcreceptor varchar(10) '$.receptor.nrc',

			condicionOperacion varchar(2) '$.resumen.condicionOperacion',

			totalCompra float '$.resumen.totalCompra',
			descu float '$.resumen.descu',
			totalDescu float '$.resumen.totalDescu',
			subTotal float '$.resumen.subTotal',
			ivaRete1 float '$.resumen.ivaRete1',
			reteRenta float '$.resumen.reteRenta',
			totalPagar float '$.resumen.totalPagar',
			seguro float '$.resumen.seguro',
			flete float '$.resumen.flete',
			montoTotalOperacion float '$.resumen.montoTotalOperacion',
			totalNoGravado float '$.resumen.totalNoGravado',
			totalLetras varchar(100) '$.resumen.totalLetras'

		) t
			left join col_cli_clientes on cli_codigo = codigo_receptor
			left join cat_cae019_codigo_actividad_economica_019 on cae019_codigo = cli_codcae019
			left join cat_tdia022_tipo_documento_identificacion_asociado_022 on tdia022_codigo = tipoDocumento_receptor
			left join vst_mh_invalidaciones_dte vi on vi.codfe = @codfe
		return
	end

	if @opcion = 2
	begin
		declare @tbl as table (_key varchar(50), _value varchar(max), _type int)
		insert into @tbl
		SELECT * FROM OPENJSON ( @request )
		declare @_cuerpo_documento varchar(max)
		select @_cuerpo_documento = _value from @tbl where _key = 'cuerpoDocumento'

		set @request = @_cuerpo_documento
		SELECT numItem, cantidad, 
		uniMedida, um14_valores 'unidad', descripcion, precioUni, montoDescu, ventaGravada, noGravado
		FROM OPENJSON ( @request )
		WITH  (
			numItem int '$.numItem',
			cantidad varchar(25) '$.cantidad',
			uniMedida varchar(25) '$.uniMedida',
			descripcion varchar(250) '$.descripcion',

			precioUni float '$.precioUni',
			montoDescu float '$.montoDescu',
			ventaGravada float '$.ventaGravada',
			noGravado float '$.noGravado'
		)
			left join cat_um014_unidad_medida_014 on um14_codigo = uniMedida
	end

end
go


	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-06-19 21:26:35.057>
	-- Description: <Sp que retorna la data del comprobante credito fiscal>
	-- =============================================
	-- exec dbo.rep_mh_ccfe 1, '2023A76E429EAC2443E384807E503E5609F3WAPV', 'DTE-03-00000000-000000000000008'--Encabezado
	-- exec dbo.rep_mh_ccfe 2, '2023A76E429EAC2443E384807E503E5609F3WAPV', 'DTE-03-00000000-000000000000008'--Detalle
create or alter procedure rep_mh_ccfe
	@opcion int = 0,
	@selloRecibido varchar(50) = 0,
	@numero_control varchar(35) = ''
as
begin
	declare @request NVARCHAR(MAX), @url_imagen_codigo_qr varchar(1024) = '', @fe_anulado bit = 0, @codfe int = 0
	--SELECT * FROM col_fe_factura_electronica where fe_aprobado_mh = 1
	select @request = fe_request, @url_imagen_codigo_qr = fe_url_imagen_codigo_qr, @fe_anulado = fe_anulado, @codfe = fe_codigo from col_fe_factura_electronica 
	where fe_sello_recepcion = @selloRecibido and fe_numero_control = @numero_control and fe_tipo_dte = '03'
	
	--select @request

	if @opcion = 1
	begin
		SELECT t.*, @url_imagen_codigo_qr 'url_imagen_codigo_qr', @selloRecibido 'selloRecibido',
		case when tipoModelo = 1 then 'Modelo Facturación previo' else 'Modelo Facturación diferido' end 'tipoModelo_texto',
		case when tipoOperacion = 1 then 'Transmisión normal' else 'Transmisión por contingencia' end 'tipotransmisio_texto',
		'Contado' 'condicionOperacion_texto',
		case when tipoEstablecimiento = '01' then 'Sucursal / Agencia'  when tipoEstablecimiento = '02' then 'Casa matriz' end 'tipoEstablecimiento_texto',
		fp017_valores 'forma_pago', @fe_anulado 'fe_anulado', vi.solicitante_inva 'inva_nombre_solicitante', vi.solicitante_documento 'inva_documento_solicitante', 
		vi.razon_ti024 'inva_motivo', vi.codigo_generacion_nuevo_dte 'inva_dte_nuevo', 
		(select v.codigo_generacion from vst_mh_encabezado_facturas v where codigo_generacion = vi.codigo_generacion_nuevo_dte) 'inva_fecha_nuevo_dte', vi.fecha_respuesta_mh 'inva_fecha_creacion'
		FROM OPENJSON ( @request )  
		WITH (   
			codActividad varchar(20) '$.emisor.codActividad',
			correo_emisor varchar(50) '$.emisor.correo',
			descActividad varchar(150) '$.emisor.descActividad',
			complemento_emisor varchar(500) '$.emisor.direccion.complemento',
			departamento_emisor varchar(5) '$.emisor.direccion.departamento',
			municipio_emisor varchar(5) '$.emisor.direccion.municipio',
			nit_emisor varchar(20) '$.emisor.nit',
			nombre varchar(50) '$.emisor.nombre',
			nombreComercial varchar(50) '$.emisor.nombreComercial',
			nrc varchar(10) '$.emisor.nrc',
			telefono varchar(15) '$.emisor.telefono',
			tipoEstablecimiento varchar(5) '$.emisor.tipoEstablecimiento',

			docuEntrega varchar(20) '$.extension.docuEntrega',
			nombEntrega varchar(100) '$.extension.nombEntrega',
			docuRecibe varchar(20) '$.extension.docuRecibe',
			nombRecibe varchar(100) '$.extension.nombRecibe',

			ambiente varchar(2) '$.identificacion.ambiente',
			codigo_establecimiento varchar(5) '$.identificacion.codigo_establecimiento',
			codigo_origen varchar(10) '$.identificacion.codigo_origen',
			codigo_punto_venta varchar(5) '$.identificacion.codigo_punto_venta',
			codigoGeneracion varchar(50) '$.identificacion.codigoGeneracion',
			fecEmi date '$.identificacion.fecEmi',
			fecha_generacion_dte varchar(30) '$.identificacion.fecha_generacion_dte',
			horEmi varchar(8) '$.identificacion.horEmi',
			numeroControl varchar(35) '$.identificacion.numeroControl',
			origen varchar(10) '$.identificacion.origen',
			tipoDte varchar(3) '$.identificacion.tipoDte',
			tipoModelo int '$.identificacion.tipoModelo',
			tipoMoneda varchar(5) '$.identificacion.tipoMoneda',
			tipoOperacion int '$.identificacion.tipoOperacion',
			version int '$.identificacion.version',
			codigo_receptor int '$.identificacion.codigo_receptor',
			correo varchar(50) '$.receptor.correo',
			complemento_receptor varchar(500) '$.receptor.direccion.complemento',
			departamento_receptor varchar(5) '$.receptor.direccion.departamento',
			municipio_receptor varchar(5) '$.receptor.direccion.municipio',
			nombre_receptor varchar(150) '$.receptor.nombre',
			numDocumento_receptor varchar(30) '$.receptor.nit',
			ciclo varchar(15) '$.identificacion.ciclo',
			telefono_receptor varchar(30) '$.receptor.telefono',
			tipoDocumento_receptor varchar(3) '$.receptor.tipoDocumento',
			condicionOperacion varchar(2) '$.resumen.condicionOperacion',

			nrc_receptor varchar(30) '$.receptor.nrc',
			descActividad_receptor varchar(250) '$.receptor.descActividad',

			descuExenta float '$.resumen.descuExenta',
			descuGravada float '$.resumen.descuGravada',
			descuNoSuj float '$.resumen.descuNoSuj',
			ivaRete1 float '$.resumen.ivaRete1',
			montoTotalOperacion float '$.resumen.montoTotalOperacion',
			numPagoElectronico varchar(60) '$.resumen.numPagoElectronico',
			codigo_resumen varchar(2) '$.resumen.pagos[0].codigo',
			montoPago_resumen float '$.resumen.pagos[0].montoPago',
			referencia_resumen varchar(60) '$.resumen.pagos[0].referencia',
			porcentajeDescuento_resumen float '$.resumen.porcentajeDescuento',
			reteRenta float '$.resumen.reteRenta',
			saldoFavor float '$.resumen.saldoFavor',
			subTotal float '$.resumen.subTotal',
			subTotalVentas float '$.resumen.subTotalVentas',
			totalDescu float '$.resumen.totalDescu',
			totalExenta float '$.resumen.totalExenta',
			totalGravada float '$.resumen.totalGravada',
			totalIva float '$.resumen.totalIva',
			totalLetras varchar(100) '$.resumen.totalLetras',
			totalNoGravado float '$.resumen.totalNoGravado',
			totalNoSuj float '$.resumen.totalNoSuj',
			totalPagar float '$.resumen.totalPagar',
			iva float '$.identificacion.personalizado_iva'
		) t
			left join col_cli_clientes on cli_codigo = codigo_receptor
			left join cat_fp017_forma_pago_017 on fp017_codigo = t.codigo_resumen
			left join vst_mh_invalidaciones_dte vi on vi.codfe = @codfe
		return
	end

	if @opcion = 2
	begin
		declare @tbl as table (_key varchar(50), _value varchar(max), _type int)
		insert into @tbl
		SELECT * FROM OPENJSON ( @request )
		declare @_cuerpo_documento varchar(max)
		select @_cuerpo_documento = _value from @tbl where _key = 'cuerpoDocumento'

		set @request = @_cuerpo_documento
		SELECT * FROM OPENJSON ( @request )
		WITH  (
			numItem int '$.numItem',
			cantidad int '$.cantidad',
			codigo varchar(15) '$.codigo',
			descripcion varchar(1024) '$.descripcion',
			ivaItem float '$.ivaItem',
			montoDescu float '$.montoDescu',
			noGravado float '$.noGravado',
			precioUni float '$.precioUni',
			psv float '$.psv',
			tipoItem float '$.tipoItem',
			uniMedida float '$.uniMedida',
			ventaExenta float '$.ventaExenta',
			ventaGravada float '$.ventaGravada',
			ventaNoSuj float '$.ventaNoSuj'
		)
	end

end
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-06-20 16:40:32.573>
	-- Description: <Sp que retorna la data de nota de credito>
	-- =============================================
	-- exec dbo.rep_mh_nce 1, '20233E83DB85A10F480FBC5CA428DABDD5B1RUEU', 'DTE-05-00000000-000000000000003'--Encabezado
	-- exec dbo.rep_mh_nce 2, '20233E83DB85A10F480FBC5CA428DABDD5B1RUEU', 'DTE-05-00000000-000000000000003'--Detalle
	-- exec dbo.rep_mh_nce 3, '20233E83DB85A10F480FBC5CA428DABDD5B1RUEU', 'DTE-05-00000000-000000000000003'--DocumentoRelacionado
create or alter procedure rep_mh_nce
	@opcion int = 0,
	@selloRecibido varchar(50) = 0,
	@numero_control varchar(35) = ''
as
begin
	declare @request NVARCHAR(MAX), @url_imagen_codigo_qr varchar(1024) = '', @fe_anulado bit = 0, @codfe int = 0
	--SELECT * FROM col_fe_factura_electronica where fe_aprobado_mh = 1
	select @request = fe_request, @url_imagen_codigo_qr = fe_url_imagen_codigo_qr, @fe_anulado = fe_anulado, @codfe = fe_codigo from col_fe_factura_electronica 
	where fe_sello_recepcion = @selloRecibido and fe_numero_control = @numero_control and fe_tipo_dte = '05'
		
	--select @request

	if @opcion = 1
	begin
		SELECT 
			t.codActividad, t.correo_emisor, t.descActividad, t.complemento_emisor, t.departamento_emisor, t.municipio_emisor, 
			t.nit_emisor, t.nombre, t.nombreComercial, t.nrc, t.telefono, t.tipoEstablecimiento, t.docuEntrega, t.nombEntrega, 
			t.docuRecibe, t.nombRecibe, t.ambiente, t.codigo_establecimiento, t.codigo_origen, t.codigo_punto_venta, 
			t.codigoGeneracion, t.fecEmi, t.fecha_generacion_dte, t.horEmi, t.numeroControl, t.origen, 
			t.tipoDte, t.tipoModelo, t.tipoMoneda, t.tipoOperacion, t.version, t.codigo_receptor, 
			t.correo, t.codActividad_receptor, t.nrc_receptor, t.complemento_receptor, t.departamento_receptor, 
			t.municipio_receptor, t.nombre_receptor, t.numDocumento_receptor, t.ciclo, t.telefono_receptor, 
			t.tipoDocumento_receptor, t.condicionOperacion, t.descuExenta, t.descuGravada, t.descuNoSuj, t.ivaRete1, 
			t.montoTotalOperacion, t.numPagoElectronico, t.codigo_resumen, t.montoPago_resumen, t.referencia_resumen, 
			t.porcentajeDescuento_resumen, t.reteRenta, t.saldoFavor, t.subTotal 'subTotal', t.subTotalVentas, t.totalDescu, t.totalExenta, 
			t.totalGravada, t.totalIva, t.totalLetras, t.totalNoGravado, t.totalNoSuj, t.totalPagar, t.iva
			, @url_imagen_codigo_qr 'url_imagen_codigo_qr', @selloRecibido 'selloRecibido',
			case when tipoModelo = 1 then 'Modelo Facturación previo' else 'Modelo Facturación diferido' end 'tipoModelo_texto',
			case when tipoOperacion = 1 then 'Transmisión normal' else 'Transmisión por contingencia' end 'tipotransmisio_texto',
			'Contado' 'condicionOperacion_texto',
			case when tipoEstablecimiento = '01' then 'Sucursal / Agencia'  when tipoEstablecimiento = '02' then 'Casa matriz' end 'tipoEstablecimiento_texto',
			fp017_valores 'forma_pago', cae019_valores 'actividadEconomica_receptor', @fe_anulado 'fe_anulado', vi.solicitante_inva 'inva_nombre_solicitante', vi.solicitante_documento 'inva_documento_solicitante', 
		vi.razon_ti024 'inva_motivo', vi.codigo_generacion_nuevo_dte 'inva_dte_nuevo', 
		(select v.codigo_generacion from vst_mh_encabezado_facturas v where codigo_generacion = vi.codigo_generacion_nuevo_dte) 'inva_fecha_nuevo_dte', vi.fecha_respuesta_mh 'inva_fecha_creacion'
		FROM OPENJSON ( @request )  
		WITH (   
			codActividad varchar(20) '$.emisor.codActividad',
			correo_emisor varchar(50) '$.emisor.correo',
			descActividad varchar(150) '$.emisor.descActividad',
			complemento_emisor varchar(500) '$.emisor.direccion.complemento',
			departamento_emisor varchar(5) '$.emisor.direccion.departamento',
			municipio_emisor varchar(5) '$.emisor.direccion.municipio',
			nit_emisor varchar(20) '$.emisor.nit',
			nombre varchar(50) '$.emisor.nombre',
			nombreComercial varchar(50) '$.emisor.nombreComercial',
			nrc varchar(10) '$.emisor.nrc',
			telefono varchar(15) '$.emisor.telefono',
			tipoEstablecimiento varchar(5) '$.emisor.tipoEstablecimiento',

			docuEntrega varchar(20) '$.extension.docuEntrega',
			nombEntrega varchar(100) '$.extension.nombEntrega',
			docuRecibe varchar(20) '$.extension.docuRecibe',
			nombRecibe varchar(100) '$.extension.nombRecibe',

			ambiente varchar(2) '$.identificacion.ambiente',
			codigo_establecimiento varchar(5) '$.identificacion.codigo_establecimiento',
			codigo_origen varchar(10) '$.identificacion.codigo_origen',
			codigo_punto_venta varchar(5) '$.identificacion.codigo_punto_venta',
			codigoGeneracion varchar(50) '$.identificacion.codigoGeneracion',
			fecEmi date '$.identificacion.fecEmi',
			fecha_generacion_dte varchar(30) '$.identificacion.fecha_generacion_dte',
			horEmi varchar(8) '$.identificacion.horEmi',
			numeroControl varchar(35) '$.identificacion.numeroControl',
			origen varchar(10) '$.identificacion.origen',
			tipoDte varchar(3) '$.identificacion.tipoDte',
			tipoModelo int '$.identificacion.tipoModelo',
			tipoMoneda varchar(5) '$.identificacion.tipoMoneda',
			tipoOperacion int '$.identificacion.tipoOperacion',
			version int '$.identificacion.version',
			codigo_receptor int '$.identificacion.codigo_receptor',
			correo varchar(50) '$.receptor.correo',
			codActividad_receptor varchar(10) '$.receptor.codActividad',
			nrc_receptor varchar(50) '$.receptor.nrc',
			complemento_receptor varchar(500) '$.receptor.direccion.complemento',
			departamento_receptor varchar(5) '$.receptor.direccion.departamento',
			municipio_receptor varchar(5) '$.receptor.direccion.municipio',
			nombre_receptor varchar(150) '$.receptor.nombre',
			numDocumento_receptor varchar(30) '$.receptor.nit',
			ciclo varchar(15) '$.identificacion.ciclo',
			telefono_receptor varchar(30) '$.receptor.telefono',
			tipoDocumento_receptor varchar(3) '$.receptor.tipoDocumento',
			condicionOperacion varchar(2) '$.resumen.condicionOperacion',

			descuExenta float '$.resumen.descuExenta',
			descuGravada float '$.resumen.descuGravada',
			descuNoSuj float '$.resumen.descuNoSuj',
			ivaRete1 float '$.resumen.ivaRete1',
			montoTotalOperacion float '$.resumen.montoTotalOperacion',
			numPagoElectronico varchar(60) '$.resumen.numPagoElectronico',
			codigo_resumen varchar(2) '$.resumen.pagos[0].codigo',
			montoPago_resumen float '$.resumen.pagos[0].montoPago',
			referencia_resumen varchar(60) '$.resumen.pagos[0].referencia',
			porcentajeDescuento_resumen float '$.resumen.porcentajeDescuento',
			reteRenta float '$.resumen.reteRenta',
			saldoFavor float '$.resumen.saldoFavor',
			subTotal float '$.resumen.subTotal',
			subTotalVentas float '$.resumen.subTotalVentas',
			totalDescu float '$.resumen.totalDescu',
			totalExenta float '$.resumen.totalExenta',
			totalGravada float '$.resumen.totalGravada',
			totalIva float '$.resumen.totalIva',
			totalLetras varchar(100) '$.resumen.totalLetras',
			totalNoGravado float '$.resumen.totalNoGravado',
			totalNoSuj float '$.resumen.totalNoSuj',
			totalPagar float '$.resumen.totalPagar',
			iva float '$.identificacion.personalizado_iva'
		) t
			left join col_cli_clientes on cli_codigo = codigo_receptor
			left join cat_fp017_forma_pago_017 on fp017_codigo = t.codigo_resumen
			left join cat_cae019_codigo_actividad_economica_019 on cae019_codigo = t.codActividad_receptor
			left join vst_mh_invalidaciones_dte vi on vi.codfe = @codfe
		return
	end
	
	declare @tbl as table (_key varchar(50), _value varchar(max), _type int)
	declare @_cuerpo_documento varchar(max)

	if @opcion = 2
	begin
		insert into @tbl
		SELECT * FROM OPENJSON ( @request )
		select @_cuerpo_documento = _value from @tbl where _key = 'cuerpoDocumento'

		set @request = @_cuerpo_documento
		SELECT * FROM OPENJSON ( @request )
		WITH  (
			numItem int '$.numItem',
			cantidad int '$.cantidad',
			codigo varchar(15) '$.codigo',
			descripcion varchar(1024) '$.descripcion',
			ivaItem float '$.ivaItem',
			montoDescu float '$.montoDescu',
			noGravado float '$.noGravado',
			precioUni float '$.precioUni',
			psv float '$.psv',
			tipoItem float '$.tipoItem',
			uniMedida float '$.uniMedida',
			ventaExenta float '$.ventaExenta',
			ventaGravada float '$.ventaGravada',
			ventaNoSuj float '$.ventaNoSuj'
		)
	end

	if @opcion = 3
	begin
		insert into @tbl
		SELECT * FROM OPENJSON ( @request )
		select @_cuerpo_documento = _value from @tbl where _key = 'documentoRelacionado'

		set @request = @_cuerpo_documento
		SELECT tipoDocumento, tipoGeneracion, numeroDocumento, format (fechaEmision, 'dd/MM/yyyy') fechaEmision, td002_valores 'tipoDocumento_texto', tgd007_valores 'tipoGeneracion_texto' FROM OPENJSON ( @request )
		WITH  (
			tipoDocumento varchar(5) '$.tipoDocumento',
			tipoGeneracion int '$.tipoGeneracion',
			numeroDocumento varchar(100) '$.numeroDocumento',
			fechaEmision date '$.fechaEmision'
		) t
			left join cat_td002_tipo_documento_002 on t.tipoDocumento = td002_codigo
			left join cat_tgd007_tipo_generacion_documento_007 on t.tipoGeneracion = tgd007_codigo
	end

end
go
