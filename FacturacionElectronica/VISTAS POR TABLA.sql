
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-04-20 22:15:26.450>
	-- Description: <Vista encargada del control de todos los encabezados de las facturas emitidas para la asignacion y registro en hacienda>
	-- La fecha "" es porque solo se toman en cuenta las facturas posteriores a esa fecha
	-- =============================================
	-- select * from vst_mh_encabezado_facturas_fac
create or alter view vst_mh_encabezado_facturas_fac
with schemabinding
as
	select 1 tipo_dte_numero, '01' 'tipo_dte', 'FE' 'documento', fac_codigo_generacion 'codigo_generacion', fac_numero_control 'numero_control', fac_sello_recepcion 'sello_recepcion',
		col_fecha_generacion_fe 'fecha_generacion_fe', '1234' 'codigo_establecimiento', '5678' 'codigo_punto_venta',
		'fac' 'origen', fac_codigo 'codigo_origen', fac_fecha 'fecha_origen', fac_fecha_registro 'fecha_registro_origen', fac_estado 'estado_origen',
		fac_usuario 'usuario_origen', replace(emp_dui, '-', '') 'docuentrega', emp_apellidos_nombres 'nombrentrega', 

		'Universidad Tecnologica de El Salvador' 'nombre_comercial_emisor',
		'01' 'tipo_establecimiento_emisor', '06' 'departamento_emisor', '14' 'municipio_emisor', 'entre 17 y, 1ra. calle poniente, San Salvador' 'direccion_emisor',
		'22758888' 'telefono_emisor',

		cli_codigo 'codigo_receptor',
		case when isnull(cli_nit, '') <> '' then '36' else '13' end 'tipo_documento_receptor', 
		case when isnull(cli_nit, '') <> '' then replace(cli_nit, '-', '') else replace(cli_dui, '-', '') end 'numero_documento_receptor', 
		cli_correo 'correo_receptor', 
		m013_codigo 'municipio_receptor', m013_departamento 'departamento_receptor', cli_direccion 'direccion_receptor', cli_nombres 'nombre_receptor', 
		cli_telefono 'telefono_receptor', cli_nrc 'nrc_receptor', cae019_codigo 'actividad_economica_receptor', cae019_valores 'descripcion_economica_receptor',

		null 'npe', null 'recibo_punto_express', null 'referencia_banco', fac_fp017 'forma_pago', fac_p018 'plazo', fac_periodo_plazo 'periodo',

		fac_rechazado_por_mh 'rechazado_por_mh', fac_rechazos_por_mh 'rechazos_por_mh',
		fac_modelo_invalido 'modelo_invalido', fac_rechazos_modelo_invalido 'rechazos_modelo_invalido',
			
		fac_correlativo_anual 'correlativo_anual', 

		'Facturas' 'controller'
		, 1 'select_n'
	from dbo.col_fac_facturas 
		inner join dbo.col_cli_clientes on fac_codcli = cli_codigo
		inner join dbo.cat_m013_municipio_013 on cli_codm013mundep = m013_mundep
		left join dbo.cat_cae019_codigo_actividad_economica_019 on cae019_codigo = cli_codcae019
		left join dbo.adm_usr_usuarios on usr_usuario = fac_usuario
		left join dbo.pla_emp_empleado on usr_codemp = emp_codigo
	where fac_codigo >= 8274
go
	select * from col_cli_clientes
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-04-20 22:15:26.450>
	-- Description: <Vista encargada del control de todos los encabezados de las facturas emitidas para la asignacion y registro en hacienda>
	-- La fecha "" es porque solo se toman en cuenta las facturas posteriores a esa fecha
	-- =============================================
	-- select * from vst_mh_encabezado_facturas_mov
create or alter view vst_mh_encabezado_facturas_mov
with schemabinding
as
	select 1 tipo_dte_numero, '01' 'tipo_dte', 'FE' 'documento', mov_codigo_generacion 'codigo_generacion', mov_numero_control 'numero_control', 
		mov_sello_recepcion 'sello_recepcion', mov_fecha_generacion_fe 'fecha_generacion_fe', '1234' 'codigo_establecimiento', '5678' 'codigo_punto_venta', 
		'mov' 'origen', mov_codigo 'codigo_origen', mov_fecha 'fecha_origen', mov_fecha_registro 'fecha_registro_origen', mov_estado 'estado_origen', 
		mov_usuario 'usuario_origen', null 'docuentrega', usr_nombre 'nombrentrega', 

		'Universidad Tecnologica de El Salvador' 'nombre_comercial_emisor',
		'01' 'tipo_establecimiento_emisor', '06' 'departamento_emisor', '14' 'municipio_emisor', 'entre 17 y, 1ra. calle poniente, San Salvador' 'direccion_emisor',
		'22758888' 'telefono_emisor',

		per_codigo 'codigo_receptor',
		case when isnull(per_dui, '') <> '' then '13' else '36' end 'tipo_documento_receptor', 
		case when isnull(per_dui, '') <> '' then per_dui else per_nit end 'numero_documento_receptor', 
		per_correo_institucional 'correo_receptor', 
		m013_codigo 'municipio_receptor', m013_departamento 'departamento_receptor', per_direccion 'direccion_receptor', 
		per_nombres_apellidos 'nombre_receptor', replace(per_telefono, '-', '') 'telefono_receptor', null 'nrc_receptor', 
		null 'actividad_economica_receptor', null 'descripcion_economica_receptor',
		
		mov_npe 'npe', mov_recibo_puntoxpress 'recibo_punto_express', mov_referencia_pos 'referencia_banco', mov_fp017 'forma_pago', mov_p018 'plazo', mov_periodo_plazo 'periodo',

		mov_rechazado_por_mh 'rechazado_por_mh', mov_rechazos_por_mh 'rechazos_por_mh',
		mov_modelo_invalido 'modelo_invalido', mov_rechazos_modelo_invalido 'rechazos_modelo_invalido',
			
		mov_correlativo_anual 'correlativo_anual',

		'Facturas' 'controller'
		, '2' 'select_n'
	from dbo.col_mov_movimientos 
		inner join dbo.ra_per_personas on per_codigo = mov_codper
		inner join dbo.ra_mun_municipios on per_codmun_nac = MUN_CODIGO
		inner join dbo.cat_m013_municipio_013 on mun_codm013mundep = m013_mundep

		inner join dbo.adm_usr_usuarios on usr_usuario = mov_usuario
		--left join dbo.pla_emp_empleado on usr_codemp = emp_codigo
	where mov_codigo >= 7216488