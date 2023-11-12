select * from faex_facturacion_sujeto_excluido where faex_codigo = 4451
select * from faexde_facturacion_sujeto_excluido_detalle
update faex_facturacion_sujeto_excluido set faex_codusr_creacion = 102

alter table faex_facturacion_sujeto_excluido add faex_fp017 varchar(5)-- Forma de pago
update faex_facturacion_sujeto_excluido set faex_fp017 = '05'
alter table faexde_facturacion_sujeto_excluido_detalle add faexde_um014 varchar(5)-- Unida de medida
update faexde_facturacion_sujeto_excluido_detalle set faexde_um014 = '99'
alter table faexde_facturacion_sujeto_excluido_detalle add faexde_codti011 int-- Tipo Item
update faexde_facturacion_sujeto_excluido_detalle set faexde_codti011 = 2


alter table faex_facturacion_sujeto_excluido add faex_referencia varchar(60)

alter table faex_facturacion_sujeto_excluido add faex_codigo_generacion varchar(60)
alter table faex_facturacion_sujeto_excluido add faex_numero_control varchar(35)
alter table faex_facturacion_sujeto_excluido add faex_sello_recepcion varchar(60)
alter table faex_facturacion_sujeto_excluido add faex_fecha_generacion_fe datetime
alter table faex_facturacion_sujeto_excluido add faex_rechazado_por_mh bit null
alter table faex_facturacion_sujeto_excluido add faex_rechazos_por_mh int null

alter table faex_facturacion_sujeto_excluido add faex_modelo_invalido bit null
alter table faex_facturacion_sujeto_excluido add faex_rechazos_modelo_invalido int null

alter table faex_facturacion_sujeto_excluido add faex_correlativo_anual int not null default 0

update faex_facturacion_sujeto_excluido set faex_correlativo_anual = 0
ALTER TABLE faex_facturacion_sujeto_excluido ALTER column faex_correlativo_anual int not null
ALTER TABLE faex_facturacion_sujeto_excluido ADD CONSTRAINT default_faex_correlativo_anual DEFAULT 0 FOR faex_correlativo_anual;



select 14 tipo_dte_numero, '14' 'tipo_dte', 'FSE' 'documento', faex_codigo_generacion 'codigo_generacion', faex_numero_control 'numero_control', 
	faex_sello_recepcion 'sello_recepcion', faex_fecha_generacion_fe 'fecha_generacion_fe', '1234' 'codigo_establecimiento', '5678' 'codigo_punto_venta', 
	'faex' 'origen', faex_codigo 'codigo_origen', faex_fecha  'fecha_origen', faex_fecha_registro 'fecha_registro_origen', faex_estado 'estado_origen', 
	usr_usuario 'usuario_origen', emp_dui 'docuentrega', usr_nombre 'nombrentrega', 

	'Universidad Tecnologica de El Salvador' 'nombre_comercial_emisor',
	'01' 'tipo_establecimiento_emisor', '06' 'departamento_emisor', '14' 'municipio_emisor', 'entre 17 y, 1ra. calle poniente, San Salvador' 'direccion_emisor',
	'22758888' 'telefono_emisor',

	pro_codigo 'codigo_receptor',
	case when isnull(pro_dui, '') <> '' then '13' else '36' end 'tipo_documento_receptor', 
	case when isnull(pro_dui, '') <> '' then pro_dui else pro_nit end 'numero_documento_receptor', 
	pro_email 'correo_receptor', 
	m013_codigo 'municipio_receptor', d012_codigo 'departamento_receptor', pro_direccion 'direccion_receptor', 
	pro_nombre_corto 'nombre_receptor', replace(pro_telefono, '-', '') 'telefono_receptor', replace(pro_num_iva, '-', '') 'nrc_receptor', 
	cae019_codigo 'actividad_economica_receptor', cae019_valores 'descripcion_economica_receptor',
		
	null 'npe', null 'recibo_punto_express', faex_referencia 'referencia_banco', fp017_codigo 'forma_pago', '01' 'plazo', 1 'periodo', 
	null 'domiciliado', null 'codpais',

	faex_rechazado_por_mh 'rechazado_por_mh', faex_rechazos_por_mh 'rechazos_por_mh',
	faex_modelo_invalido 'modelo_invalido', faex_rechazos_modelo_invalido 'rechazos_modelo_invalido',
			
	faex_correlativo_anual 'correlativo_anual',

	'SujetoExcluido' 'controller'
	, '5' 'select_n'
from dbo.faex_facturacion_sujeto_excluido 
	inner join dbo.con_pro_proveedores on faex_codpro = pro_codigo--433
	inner join dbo.adm_usr_usuarios on usr_codigo = faex_codusr_creacion
	inner join dbo.pla_emp_empleado on usr_codemp = emp_codigo
	--left join cat_df032_domicilio_fiscal_032 on df032_codigo = pro_coddf032
	left join cat_m013_municipio_013 on pro_codm013 = m013_mundep
	left join cat_d012_departamento_012 on m013_departamento = d012_codigo
	--left join cat_p020_pais_020 on p020_codigo = d012_pais_codp020
	left join cat_cae019_codigo_actividad_economica_019 on pro_codcae019 = cae019_codigo
	left join cat_fp017_forma_pago_017 on fp017_codigo = faex_fp017

union all

select 14 tipo_dte_numero, '14' 'tipo_dte', 'FSE' 'documento', faex_codigo_generacion 'codigo_generacion', faex_numero_control 'numero_control', 
	faex_sello_recepcion 'sello_recepcion', faex_fecha_generacion_fe 'fecha_generacion_fe', '1234' 'codigo_establecimiento', '5678' 'codigo_punto_venta', 
	'faex' 'origen', faex_codigo 'codigo_origen', faex_fecha  'fecha_origen', faex_fecha_registro 'fecha_registro_origen', faex_estado 'estado_origen', 
	usr_usuario 'usuario_origen', e2.emp_dui 'docuentrega', usr_nombre 'nombrentrega', 

	'Universidad Tecnologica de El Salvador' 'nombre_comercial_emisor',
	'01' 'tipo_establecimiento_emisor', '06' 'departamento_emisor', '14' 'municipio_emisor', 'entre 17 y, 1ra. calle poniente, San Salvador' 'direccion_emisor',
	'22758888' 'telefono_emisor',

	e1.emp_codigo 'codigo_receptor',
	case when isnull(e1.emp_dui, '') <> '' then '13' else '36' end 'tipo_documento_receptor', 
	case when isnull(e1.emp_dui, '') <> '' then e1.emp_dui else e1.emp_nit end 'numero_documento_receptor', 
	e1.emp_email_institucional 'correo_receptor', 
	m013_codigo 'municipio_receptor', d012_codigo 'departamento_receptor', e1.emp_direccion 'direccion_receptor', 
	e1.emp_nombres_apellidos 'nombre_receptor', replace(e1.emp_telefono, '-', '') 'telefono_receptor', e1.emp_NRC 'nrc_receptor', 
	cae019_codigo 'actividad_economica_receptor', cae019_valores 'descripcion_economica_receptor',
		
	null 'npe', null 'recibo_punto_express', faex_referencia 'referencia_banco', fp017_codigo 'forma_pago', '01' 'plazo', 1 'periodo', 
	null 'domiciliado', null 'codpais',

	faex_rechazado_por_mh 'rechazado_por_mh', faex_rechazos_por_mh 'rechazos_por_mh',
	faex_modelo_invalido 'modelo_invalido', faex_rechazos_modelo_invalido 'rechazos_modelo_invalido',
			
	faex_correlativo_anual 'correlativo_anual',

	'SujetoExcluido' 'controller'
	, '6' 'select_n'
from dbo.faex_facturacion_sujeto_excluido 
	inner join dbo.pla_emp_empleado e1 on emp_codigo = faex_codemp--2440
	inner join dbo.adm_usr_usuarios on usr_codigo = faex_codusr_creacion
	inner join dbo.pla_emp_empleado e2 on usr_codemp = e2.emp_codigo
	--left join cat_df032_domicilio_fiscal_032 on df032_codigo = pro_coddf032
	left join ra_mun_municipios on e1.emp_codmun = MUN_CODIGO
	left join cat_m013_municipio_013 on m013_mundep = mun_codm013mundep
	left join cat_d012_departamento_012 on m013_departamento = d012_codigo
	--left join cat_p020_pais_020 on p020_codigo = d012_pais_codp020
	left join cat_cae019_codigo_actividad_economica_019 on e1.emp_codcae019 = cae019_codigo
	left join cat_fp017_forma_pago_017 on fp017_codigo = faex_fp017
	


select fecha, isnull(dui, nit) 'dui_nit', Proveedor 'nombre', faex_recibo 'numero_factura', telefono, upper(departamento) departamento, municipio, direccion, correo, monto 'monto_op'
from (
		--PROVEEDORES
      	select faex_codigo,faexde_codigo,faex_recibo,pro_descripcion Proveedor,faex_condicion_pago,faexde_descripcion,faexde_cantidad, 
            faexde_precio precio, (faexde_precio*faexde_cantidad) monto ,faex_aplica_renta,
            case faex_aplica_renta when 1 then 'Si' else 'No' end aplica_renta_desc,isnull(faex_estado,'A')faex_estado,
            case when faex_estado = 'R' then 'Registrado' else 'Anulado' end estadoDesc, 'Proveedor' tipo,
            faex_fecha fecha, faex_aplica_iva,
            case faex_aplica_iva when 1 then 'Si' else 'No' end aplica_iva_desc, pro_dui dui, 
            pro_nit nit, pro_telefono 'telefono', pro_direccion 'direccion', pro_email correo, m013_valores 'municipio', d012_valores 'departamento'
      	from faex_facturacion_sujeto_excluido     
            --join faexde_facturacion_sujeto_excluido_detalle on faexde_codfaex = faex_codigo
            join con_pro_proveedores on pro_codigo = faex_codpro
            left join cat_m013_municipio_013 on m013_mundep = pro_codm013
            left join cat_d012_departamento_012 on d012_codigo = m013_departamento
      	--where faex_estado not in ('A')

      	union

      	-- DOCENTES HORA CLASE
      	select faex_codigo,faexde_codigo,faex_recibo,emp_nombres_apellidos,faex_condicion_pago,faexde_descripcion,faexde_cantidad,
            faexde_precio precio, (faexde_precio*faexde_cantidad) monto ,faex_aplica_renta,
            case faex_aplica_renta when 1 then 'Si' else 'No' end aplica_renta_desc,isnull(faex_estado,'A') faex_estado,
            case when faex_estado = 'R' then 'Registrado' else 'Anulado' end estadoDesc, 'DHC',
            faex_fecha fecha, faex_aplica_iva,
            case faex_aplica_iva when 1 then 'Si' else 'No' end aplica_iva_desc, emp_dui, emp_nit, emp_telefono, emp_direccion 'direccion', emp_email_institucional, m013_valores, d012_valores
      	from faex_facturacion_sujeto_excluido     
            --join faexde_facturacion_sujeto_excluido_detalle on faexde_codfaex = faex_codigo
            join pla_emp_empleado on emp_codigo = faex_codemp
            left join ra_mun_municipios on emp_codmun = MUN_CODIGO
            left join cat_m013_municipio_013 on m013_mundep = mun_codm013mundep
            left join cat_d012_departamento_012 on d012_codigo = m013_departamento
      	--where faex_estado not in ('A')
) t
order by numero_factura, fecha asc