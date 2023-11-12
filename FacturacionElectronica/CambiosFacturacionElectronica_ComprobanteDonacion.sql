select * from con_don_donaciones
select * from con_ddon_detalle_donaciones
select * from cat_td026_tipo_donacion_026

alter table con_don_donaciones add don_codigo_generacion varchar(60)
alter table con_don_donaciones add don_numero_control varchar(35)
alter table con_don_donaciones add don_estado varchar(2)--R: Registrado, I: Impreso, A: Anulado
alter table con_don_donaciones add don_sello_recepcion varchar(60)
alter table con_don_donaciones add don_fecha datetime
alter table con_don_donaciones add don_codusr_creacion int null
alter table con_don_donaciones add don_fecha_generacion_fe datetime
alter table con_don_donaciones add don_rechazado_por_mh bit null
alter table con_don_donaciones add don_rechazos_por_mh int null

alter table con_don_donaciones add don_modelo_invalido bit null
alter table con_don_donaciones add don_rechazos_modelo_invalido int null

alter table con_don_donaciones add don_correlativo_anual int not null default 0

update con_don_donaciones set don_correlativo_anual = 0
ALTER TABLE con_don_donaciones ALTER column don_correlativo_anual int not null
go

select 15 tipo_dte_numero, '15' 'tipo_dte', 'CDE' 'documento', don_codigo_generacion 'codigo_generacion', don_numero_control 'numero_control', 
	don_sello_recepcion 'sello_recepcion', don_fecha_generacion_fe 'fecha_generacion_fe', '1234' 'codigo_establecimiento', '5678' 'codigo_punto_venta', 
	'rei' 'origen', don_codigo 'codigo_origen', don_fecha  'fecha_origen', don_fecha_creacion 'fecha_registro_origen', don_estado 'estado_origen', 
	usr_usuario 'usuario_origen', emp_dui 'docuentrega', usr_nombre 'nombrentrega', 

	'Universidad Tecnologica de El Salvador' 'nombre_comercial_emisor',
	'01' 'tipo_establecimiento_emisor', '06' 'departamento_emisor', '14' 'municipio_emisor', 'entre 17 y, 1ra. calle poniente, San Salvador' 'direccion_emisor',
	'22758888' 'telefono_emisor',

	pro_codigo 'codigo_receptor',
	case when isnull(pro_dui, '') <> '' then '13' else '36' end 'tipo_documento_receptor', 
	case when isnull(pro_dui, '') <> '' then pro_dui else pro_nit end 'numero_documento_receptor', 
	pro_email 'correo_receptor', 
	null 'municipio_receptor', null 'departamento_receptor', pro_direccion 'direccion_receptor', 
	pro_nombre_corto 'nombre_receptor', replace(pro_telefono, '-', '') 'telefono_receptor', replace(pro_num_iva, '-', '') 'nrc_receptor', 
	cae019_codigo 'actividad_economica_receptor', cae019_valores 'descripcion_economica_receptor',
		
	null 'npe', null 'recibo_punto_express', null 'referencia_banco', null 'forma_pago', null 'plazo', null 'periodo', 
	df032_codigo 'domiciliado', p020_codigo 'codpais',

	don_rechazado_por_mh 'rechazado_por_mh', don_rechazos_por_mh 'rechazos_por_mh',
	don_modelo_invalido 'modelo_invalido', don_rechazos_modelo_invalido 'rechazos_modelo_invalido',
			
	don_correlativo_anual 'correlativo_anual',

	'ComprobanteDonacion' 'controller'
	, '4' 'select_n'
from dbo.con_don_donaciones 
	inner join dbo.con_pro_proveedores on don_codprod = pro_codigo
	inner join dbo.adm_usr_usuarios on usr_codigo = don_codusr_creacion
	inner join dbo.pla_emp_empleado on usr_codemp = emp_codigo
	inner join cat_df032_domicilio_fiscal_032 on df032_codigo = pro_coddf032
	left join cat_m013_municipio_013 on pro_codm013 = m013_mundep
	left join cat_d012_departamento_012 on m013_departamento = d012_codigo
	left join cat_p020_pais_020 on p020_codigo = d012_pais_codp020
	left join cat_cae019_codigo_actividad_economica_019 on pro_codcae019 = cae019_codigo

	select * from cat_cae019_codigo_actividad_economica_019
	select * from cat_p020_pais_020
	select * from cat_m013_municipio_013
	select * from cat_d012_departamento_012
	select * from con_pro_proveedores
	select * from dbo.con_don_donaciones 

	inner join dbo.con_pro_proveedores on don_codprod = pro_codigo
	inner join dbo.adm_usr_usuarios on usr_codigo = don_codusr_creacion
	inner join dbo.pla_emp_empleado on usr_codemp = emp_codigo
	inner join cat_df032_domicilio_fiscal_032 on df032_codigo = pro_coddf032
	inner join cat_m013_municipio_013 on pro_codm013 = m013_mundep
	inner join cat_d012_departamento_012 on m013_departamento = d012_codigo
	left join cat_p020_pais_020 on p020_codigo = d012_pais_codp020