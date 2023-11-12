select * from adm_opm_opciones_menu where opm_link like '%recibo_manual2%'
update adm_opm_opciones_menu set opm_link = 'recibo_manual2_DISABLED.aspx' where opm_link like '%recibo_manual2%'
--exec sp_insertar_pagos_x_carnet_estructurado  '0313008000000016864010220230', 8, 'ss12ss3ddd'
--select * from dbo.col_art_archivo_tal_mora where per_codigo = 168640
--select top 10 * from col_mov_movimientos order by mov_codigo desc
--select @contador_anual = isnull(max(correlativo_anual), 0) + 1
--from vst_mh_encabezado_facturas 
--where documento = 'FE' and tipo_dte = '01' and year(fecha_registro_origen) = year(getdate())

-- drop table col_fe_factura_electronica
create table col_fe_factura_electronica (
	fe_codigo int primary key identity (1, 1),
	fe_tipo_dte varchar(3),
	fe_codigo_origen int not null,
	fe_origen varchar(20) not null,
	fe_codigo_receptor int not null,
	fe_request varchar(max),
	fe_response varchar(max),
	fe_codigo_generacion varchar(60),
	fe_numero_control varchar(35),
	fe_sello_recepcion varchar(60),
	fe_correlativo_anual int not null,
	fe_codigo_establecimiento varchar(5),
	fe_codigo_punto_venta varchar(5),
	
	fe_pathfile varchar(1024),
	fe_url_reporte varchar(1024),
	fe_pathfile_qr varchar(1024),
	fe_url_imagen_codigo_qr varchar(1024),
	fe_url_codigo_qr varchar(1024), 

	fe_aprobado_mh bit not null,
	fe_rechazo_mh_numero int not null,

	fe_estado varchar(15),
	
	fe_modelo_invalido bit,
	fe_rechazos_modelo_invalido int,

	fe_anulado bit not null default 0,
	fe_fecha_anulacion datetime, 

	fe_fecha_generacion_dte datetime not null,
	fe_codusr_creacion int,
	fe_fecha_creacion datetime default getdate(),
	fe_version_dte tinyint not null
)
go
-- select * from col_fe_factura_electronica where fe_codigo = 333
--insert into col_fe_factura_electronica (fe_tipo_dte, fe_codigo_origen, fe_origen, fe_request, fe_response, fe_codigo_generacion, fe_numero_control, fe_sello_recepcion, fe_estado, fe_fecha_generacion_dte, fe_correlativo_anual, fe_aprobado_mh, fe_codigo_receptor, fe_rechazo_mh_numero)
--values ('01', 1, 'mov', '{"ambiente": "00","idEnvio": 50,"version": 1,"tipoDte": "01","documento": {"identificacion": {"version": 1,"ambiente": "00","tipoDte": "01","numeroControl": "DTE-01-12345678-000000000000001","codigoGeneracion": "FD2E4826-5802-4D02-BD49-7614FDAF770D","tipoModelo": 1,"tipoOperacion": 1,"tipoContingencia": null,"motivoContin": null,"fecEmi": "2023-04-25","horEmi": "21:16:18","tipoMoneda": "USD"},"documentoRelacionado": null,"emisor": {"nit": "06142005810012","nrc": "74535","nombre": "UNIVERSIDAD TECNOLOGICA DE EL SALVADOR","codActividad": "85301","descActividad": "Enseñanza superior universitaria","nombreComercial": "Universidad Tecnologica de El Salvador","tipoEstablecimiento": "02","direccion": {"departamento": "06","municipio": "14","complemento": "entre 17 y, 1ra. calle poniente, San Salvador"},"telefono": "22758888","correo": "facturacionelectronica@utec.edu.sv","codEstableMH": null,"codEstable": null,"codPuntoVentaMH": null,"codPuntoVenta": null},"receptor": {"tipoDocumento": "13","numDocumento": "1233456789","nrc": null,"nombre": "Fabio Ernesto","codActividad": null,"descActividad": null,"direccion": {"departamento": "14","municipio": "06","complemento": "ntre 17 y, 1ra. calle "},"telefono": "79042696","correo": "fabio.ramos@utec.edu.sv"},"otrosDocumentos": null,"ventaTercero": null,"cuerpoDocumento": [{"numItem": 1,"tipoItem": 2,"numeroDocumento": null,"cantidad": 1.0,"codigo": null,"codTributo": null,"uniMedida": 99,"descripcion": "M-01 Matricula","precioUni": 31.5,"montoDescu": 0.0,"ventaNoSuj": 0.0,"ventaExenta": 31.5,"ventaGravada": 0.0,"tributos": null,"psv": 0.0,"noGravado": 0.0,"ivaItem": 0.0}],"resumen": {"totalNoSuj": 0.0,"totalExenta": 80.0,"totalGravada": 0.0,"subTotalVentas": 80.0,"descuNoSuj": 0.0,"descuExenta": 0.0,"descuGravada": 0.0,"porcentajeDescuento": 0.0,"totalDescu": 0.0,"tributos": null,"subTotal": 80.0,"ivaRete1": 0.0,"reteRenta": 0.0,"montoTotalOperacion": 80.0,"totalNoGravado": 0.0,"totalPagar": 80.0,"totalLetras": "ochenta 00/100","totalIva": 0.0,"saldoFavor": 0.0,"condicionOperacion": 1,"pagos": [{"codigo": "01","montoPago": 80.0,"referencia": null,"plazo": null,"periodo": null}],"numPagoElectronico": null},"extension": {"nombEntrega": "","docuEntrega": null,"nombRecibe": "Fabio Ernesto","docuRecibe": "06141010781234","observaciones": null,"placaVehiculo": null},"apendice": null},"codigoGeneracion": "980b08af-3c59-405c-816c-2acb6c7ee227"}'
--, '{"version": 2,"ambiente": "00","versionApp": 2,"estado": "RECHAZADO","codigoGeneracion": "47340973-60FB-48F6-BCFB-381BB15C51C9","selloRecibido": null,"fhProcesamiento": "25/04/2023 09:05:53","clasificaMsg": "11","codigoMsg": "004","descripcionMsg": "[identificacion.codigoGeneracion] YA EXISTE UN REGISTRO CON ESE VALOR","observaciones": []}',
--'47340973-60FB-48F6-BCFB-381BB15C51C9', 'DTE-01-12345678-000000000000001', '20238AF01CA7435E44ED8B5DE61974D4E3D0DNAL', 'Recibido', getdate(), 85, 1, 0, 0)
--go

-- drop table col_ife_invalidacion_factura_electronica
create table col_ife_invalidacion_factura_electronica(
	ife_codigo int primary key identity (1, 1),
	ife_codfe int foreign key references col_fe_factura_electronica,

	ife_tipo_dte_numero int not null,
	ife_codigo_origen int not null,

	ife_codcat024 int not null,
	ife_MotivoAnulacion varchar(500) not null,

	ife_NombreResponsable varchar(250) not null,
	ife_codcat022_TipDocResponsable int not null,
	ife_NumDocResponsable varchar(250) not null,

	ife_NombreSolicita varchar(250) not null,
	ife_codcat022_TipDocSolicita int not null,
	ife_NumDocSolicita varchar(250) not null,
	ife_telefono_receptor varchar(12) not null,
	ife_codigo_generacion_reemplaza varchar(60) null,
	
	ife_request_mh varchar(max) null,
	ife_response_mh varchar(max) null,
	ife_fecha_respuesta_mh datetime,
	ife_estado_mh varchar(20) null default 'Pendiente',

	ife_fecha_creacion datetime default getdate(),
	ife_usuario_creacion int,
)
go
-- select * from col_ife_invalidacion_factura_electronica

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-09-24 15:13:52.713>
	-- Description: <Vista encargada de mostrar los DTEs anulados en MH>
	-- =============================================
	-- select top 25 * from vst_mh_invalidaciones_dte order by codife desc
create or alter view vst_mh_invalidaciones_dte
as
	select 
	ife_codigo 'codife', ife_codfe 'codfe', fe_codigo_generacion 'codigo_generacion_inva', fe_sello_recepcion 'sello_recepcion_inva', fe_numero_control 'numero_control_inva', ife_tipo_dte_numero 'tipo_dte_numero', ife_codigo_origen 'codigo_origen', 
	ife_codcat024 'codcat024', ti024_valores 'razon_ti024', ife_MotivoAnulacion 'motivo_anulacion', ife_NombreResponsable 'responsable_anulacion', ife_codcat022_TipDocResponsable 'responsable_codcat022', 
	ife_NumDocResponsable 'responsable_documento', ife_NombreSolicita 'solicitante_inva', ife_codcat022_TipDocSolicita 'solicitante_codcat022', ife_NumDocSolicita 'solicitante_documento', 
	ife_telefono_receptor 'solicitante_telefono', ife_codigo_generacion_reemplaza 'codigo_generacion_nuevo_dte', ife_request_mh ' request_mh', 
	ife_response_mh 'response_mh', ife_fecha_creacion 'fecha_respuesta_mh', ife_estado_mh 'estado_mh', ife_fecha_creacion 'fecha_creacion', ife_usuario_creacion 'usuario_creacion'
	from col_ife_invalidacion_factura_electronica
		join cat_ti024_tipo_invalidacion_024 on ti024_codigo = ife_codcat024
		join col_fe_factura_electronica on ife_codfe = fe_codigo
go


select * from cat_te009_tipo_establecimiento_009
-- drop table col_esta_establecimientos
create table col_esta_establecimientos(
	esta_codigo int primary key identity (1, 1),
	esta_nombre varchar(50),
	esta_num_mh int,
	esta_direccion_mh varchar(100),
	esta_cidte009 nvarchar(10),
	esta_telefono varchar(20),
	esta_codigoMH varchar(10),
	esta_fecha_creacion datetime default getdate()
)
-- select * from col_esta_establecimientos
insert into col_esta_establecimientos (esta_nombre, esta_num_mh, esta_direccion_mh, esta_cidte009, esta_codigoMH, esta_telefono)
values 
('Matriz colecturia UTEC', 1, '17° AVENIDA NORTE Y CALLE ARCE, # 131, SAN SALVADOR, SAN SALVADOR', '02', 'M001', '22758888'),
('Plaza mundo', 5, 'BLVD DEL EJERCITO, LOCAL. 141, CTRO. COM. PLAZA MUNDO, SOYAPANGO, SAN SALVADOR', '01', 'S013', '22757566'),
('Maestrias', 7, '3ª CALLE PTE. SCHAFIK HANDAL BLVD CONSTITUCION, COL. ESCALON, SAN SALVADOR, SAN SALVADOR', '01', 'S012', '22752700'),
('Metrocentro', 14, 'LOCAL 311, CTRO.COM. METRO CENTRO 8 ETAPA, SAN SALVADOR, SAN SALVADOR', '01', 'S011', '22610270')

-- drop table col_punven_puntos_ventas
create table col_punven_puntos_ventas (
	punven_codigo int primary key identity (1, 1),
	punven_codesta int foreign key references col_esta_establecimientos,
	punven_codigoMH varchar(10),
	punven_fecha_creacion datetime default getdate()
)
-- select * from col_punven_puntos_ventas
insert into col_punven_puntos_ventas (punven_codesta, punven_codigoMH)
values 
(1, 'P001'), (1, 'P002'), (1, 'P003'), (1, 'P004'), (1, 'P005'), (1, 'P006'),
(2, 'P001'), (2, 'P002'), (2, 'P003'),
(3, 'P001'),
(4, 'P001'), (4, 'P002'), (4, 'P003')

alter table adm_usr_usuarios add usr_codpunven int foreign key references col_punven_puntos_ventas

update adm_usr_usuarios set usr_codpunven = 1 where usr_codigo = 335
update adm_usr_usuarios set usr_codpunven = 1, usr_codemp = 4748 where usr_codigo = 45
update adm_usr_usuarios set usr_codpunven = 2 where usr_codigo = 36
update adm_usr_usuarios set usr_codpunven = 3 where usr_codigo = 398
update adm_usr_usuarios set usr_codpunven = 4 where usr_codigo = 281
update adm_usr_usuarios set usr_codpunven = 5 where usr_codigo = 466
update adm_usr_usuarios set usr_codpunven = 6 where usr_codigo = 422
update adm_usr_usuarios set usr_codpunven = 7 where usr_codigo = 304
update adm_usr_usuarios set usr_codpunven = 8 where usr_codigo = 44
update adm_usr_usuarios set usr_codpunven = 9 where usr_codigo = 460
--Maes
update adm_usr_usuarios set usr_codpunven = 10 where usr_codigo = 351
update adm_usr_usuarios set usr_codpunven = 10 where usr_codigo = 453
--update adm_usr_usuarios set usr_codpunven = 10 where usr_codigo = 351
--Maes

update adm_usr_usuarios set usr_codpunven = 10, usr_codemp = 4709 where usr_codigo = 498
update adm_usr_usuarios set usr_codpunven = 10, usr_codemp = 3441 where usr_codigo = 229

update adm_usr_usuarios set usr_codpunven = 11 where usr_codigo = 331
update adm_usr_usuarios set usr_codpunven = 12 where usr_codigo = 457
update adm_usr_usuarios set usr_codpunven = 13 where usr_codigo = 507

--Pagos en linea
update adm_usr_usuarios set usr_codpunven = 4 where usr_codigo = 485
update adm_usr_usuarios set usr_codpunven = 4 where usr_codigo = 486
update adm_usr_usuarios set usr_codpunven = 4 where usr_codigo = 487
update adm_usr_usuarios set usr_codpunven = 4 where usr_codigo = 488
update adm_usr_usuarios set usr_codpunven = 4 where usr_codigo = 489
update adm_usr_usuarios set usr_codpunven = 4 where usr_codigo = 490
update adm_usr_usuarios set usr_codpunven = 4 where usr_codigo = 491
update adm_usr_usuarios set usr_codpunven = 4 where usr_codigo = 492
update adm_usr_usuarios set usr_codpunven = 4 where usr_codigo = 493
update adm_usr_usuarios set usr_codpunven = 4 where usr_codigo = 494
update adm_usr_usuarios set usr_codpunven = 4 where usr_codigo = 495
update adm_usr_usuarios set usr_codpunven = 4 where usr_codigo = 496
update adm_usr_usuarios set usr_codpunven = 4 where usr_codigo = 497

select * from adm_usr_usuarios where usr_codigo in (407, 335, 422, 36, 466, 281)
select * from adm_usr_usuarios where usr_usuario like '%silvia%'

select * from col_esta_establecimientos
	inner join col_punven_puntos_ventas on esta_codigo = punven_codesta
	left join adm_usr_usuarios on usr_codpunven = punven_codigo
order by esta_codigo, punven_codigo

--CCF	16--fac
--CRE	2--rei, ok
--FC	2203--mov, ok
--FEX	1--fac
--FSE	19--faex, ok
--NC	8--fac
--update col_mov_movimientos set mov_correlativo_anual = 3600 where mov_codigo = 7362199
--update con_rei_retencion_iva set rei_correlativo_anual = 100 where rei_codigo = 13067
--update faex_facturacion_sujeto_excluido set faex_correlativo_anual = 250 where faex_codigo = 6739
--update col_fac_facturas set fac_correlativo_anual = 5 where fac_codigo = 7949 and fac_tipo = 'E'
--update col_fac_facturas set fac_correlativo_anual = 100 where fac_codigo = 8781 and fac_tipo = 'C'
--update col_fac_facturas set fac_correlativo_anual = 20 where fac_codigo = 6730 and fac_tipo = 'NC'

--Codigos maximos a quemar en el where en los encabezado
--select max(fac_codigo) + 1 from col_fac_facturas where fac_tipo = 'E'
--select max(fac_codigo) from col_fac_facturas where fac_tipo = 'C'
--select max(fac_codigo) from col_fac_facturas where fac_tipo = 'NC'
--select max(mov_codigo) + 1 from col_mov_movimientos
--select max(rei_codigo) + 1 from con_rei_retencion_iva
--select max(don_codigo) + 1 from con_don_donaciones
--select max(faex_codigo) + 1 from faex_facturacion_sujeto_excluido

--Codigos maximos a quemar en el where en los detalles
--select max(dfa_codigo) + 1 from col_dfa_det_fac
--select max(dmo_codigo) + 1 from col_dmo_det_mov
--select max(rid_codigo) + 1 from con_rid_retencion_iva_detalle
--select max(ddon_codigo) + 1 from con_ddon_detalle_donaciones
--select max(faexde_codigo) + 1 from faexde_facturacion_sujeto_excluido_detalle

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-04-20 22:15:26.450>
	-- Description: <Vista encargada del control de todos los encabezados de las facturas emitidas para la asignacion y registro en hacienda>
	-- La fecha "" es porque solo se toman en cuenta las facturas posteriores a esa fecha
	-- =============================================
	-- select top 10 * from vst_mh_encabezado_facturas where codigo_origen = 7365264 order by fecha_registro_origen desc
	-- select top 50 * from vst_mh_encabezado_facturas order by fecha_registro_origen desc
create or alter view vst_mh_encabezado_facturas 
--with schemabinding
as
	select 
		tipo_dte_numero, tipo_dte, documento, codigo_generacion, numero_control, sello_recepcion, fecha_generacion_fe, isnull(esta_codigomh, '00000') 'codigo_establecimiento', 
		isnull(punven_codigoMH, '00000') 'codigo_punto_venta', nombre_establecimiento, origen, codigo_origen, fecha_origen, fecha_registro_origen, estado_origen, usuario_origen, docuentrega, 
		nombrentrega, nombre_comercial_emisor, esta_cidte009 'tipo_establecimiento_emisor', departamento_emisor, municipio_emisor, esta_direccion_mh 'direccion_emisor', 
		esta_telefono 'telefono_emisor', codigo_receptor, tipo_documento_receptor, numero_documento_receptor, correo_receptor, correo2_receptor, municipio_receptor, 
		departamento_receptor, direccion_receptor, nombre_receptor, telefono_receptor, nrc_receptor, actividad_economica_receptor, 
		descripcion_economica_receptor, npe, recibo_punto_express, referencia_banco, forma_pago, plazo, periodo, domiciliado, 
		codpais, pais, codigo_tipo_persona, tipo_persona,
		rechazado_por_mh, rechazos_por_mh, modelo_invalido, rechazos_modelo_invalido, isnull(correlativo_anual, 0) correlativo_anual, controller, select_n,

		case 
			when rechazado_por_mh = 1 then 1 
			when modelo_invalido = 1 then 3 
			when rechazado_por_mh = 0 then 2 
			else 4 
		end estado,
		case
			when rechazado_por_mh = 1 then 'Rechazado por hacienda'
			when modelo_invalido = 1 then 'DTE invalido' 
			when rechazado_por_mh = 0 then 'Aprobado por hacienda'
			else 'Pendiente de envió'
		end estado_texto
	from (
		select fac_tipo_dte_numero tipo_dte_numero, fac_tipo_dte 'tipo_dte', fac_documento 'documento', 

			fac_codigo_generacion 'codigo_generacion', fac_numero_control 'numero_control', fac_sello_recepcion 'sello_recepcion',
			col_fecha_generacion_fe 'fecha_generacion_fe', '0000' 'codigo_establecimiento', '0000' 'codigo_punto_venta', 'UTEC' 'nombre_establecimiento',
			'fac' 'origen', fac_codigo 'codigo_origen', fac_fecha 'fecha_origen', fac_fecha_registro 'fecha_registro_origen', fac_estado 'estado_origen',
			usr_codigo 'codusr_facturo', fac_usuario 'usuario_origen', replace(emp_dui, '-', '') 'docuentrega', emp_apellidos_nombres 'nombrentrega', 

			'Universidad Tecnologica de El Salvador' 'nombre_comercial_emisor',
			'01' 'tipo_establecimiento_emisor', '06' 'departamento_emisor', '14' 'municipio_emisor', 'entre 17 y, 1ra. calle poniente, San Salvador' 'direccion_emisor',
			'22758888' 'telefono_emisor',

			cli_codigo 'codigo_receptor',
			case when isnull(cli_nit, '') <> '' then '36' else '13' end 'tipo_documento_receptor', 
			case when isnull(cli_nit, '') <> '' then replace(cli_nit, '-', '') else replace(cli_dui, '-', '') end 'numero_documento_receptor', 
			cli_correo 'correo_receptor', null 'correo2_receptor',
			m013_codigo 'municipio_receptor', m013_departamento 'departamento_receptor', cli_direccion 'direccion_receptor', concat(cli_apellidos, ' ', cli_nombres) 'nombre_receptor', 
			cli_telefono 'telefono_receptor', replace(cli_nrc, '-', '') 'nrc_receptor', cae019_codigo 'actividad_economica_receptor', cae019_valores 'descripcion_economica_receptor',

			null 'npe', null 'recibo_punto_express', null 'referencia_banco', fac_fp017 'forma_pago', fac_p018 'plazo', fac_periodo_plazo 'periodo',
			null 'domiciliado', p020_codigo 'codpais', p020_valores 'pais', tp029_codigo 'codigo_tipo_persona', tp029_valores 'tipo_persona', 

			fac_rechazado_por_mh 'rechazado_por_mh', fac_rechazos_por_mh 'rechazos_por_mh',
			fac_modelo_invalido 'modelo_invalido', fac_rechazos_modelo_invalido 'rechazos_modelo_invalido',
			
			fac_correlativo_anual 'correlativo_anual', 

			case when fac_tipo_dte_numero = 1 then 'Facturas' when fac_tipo_dte_numero = 11 then 'FacturaExportacion' when fac_tipo_dte_numero = 3 then 'ComprobanteCreditoFiscal' when fac_tipo_dte_numero = 5 then 'NotaCredito' else '-' end 'controller'
			, 1 'select_n'
		from dbo.col_fac_facturas 
			left join dbo.col_cli_clientes on fac_codcli = cli_codigo
			left join dbo.cat_m013_municipio_013 on cli_codm013mundep = m013_mundep
			left join cat_d012_departamento_012 on m013_departamento = d012_codigo
			left join dbo.cat_cae019_codigo_actividad_economica_019 on cae019_codigo = cli_codcae019
			left join dbo.adm_usr_usuarios on usr_usuario = fac_usuario
			left join dbo.pla_emp_empleado on usr_codemp = emp_codigo

			left join cat_p020_pais_020 on p020_codigo = cli_codp020
			left join cat_tp029_tipo_persona_029 on tp029_codigo = cli_codtp029
		where fac_codigo >= 8793 --and fac_tipo not in ('E'/*EXPORTACION*/, 'C'/*CREDITO FISCAL*/)--F: Factura

			union all

		select 1 tipo_dte_numero, '01' 'tipo_dte', 'FC' 'documento', mov_codigo_generacion 'codigo_generacion', mov_numero_control 'numero_control', 
			mov_sello_recepcion 'sello_recepcion', mov_fecha_generacion_fe 'fecha_generacion_fe', '0000' 'codigo_establecimiento', '0000' 'codigo_punto_venta', 'UTEC' 'nombre_establecimiento',
			'mov' 'origen', mov_codigo 'codigo_origen', mov_fecha 'fecha_origen', mov_fecha_registro 'fecha_registro_origen', mov_estado 'estado_origen', 
			usr_codigo, mov_usuario 'usuario_origen', emp_dui 'docuentrega', usr_nombre 'nombrentrega', 

			'Universidad Tecnologica de El Salvador' 'nombre_comercial_emisor',
			'01' 'tipo_establecimiento_emisor', '06' 'departamento_emisor', '14' 'municipio_emisor', 'entre 17 y, 1ra. calle poniente, San Salvador' 'direccion_emisor',
			'22758888' 'telefono_emisor',

			per_codigo 'codigo_receptor',
			case 
			when LEN(replace(REPLACE(ISNULL(per_dui, 0), '_', ''), '00000000-0', '')) = 10 then '13' 
			when LEN(REPLACE(ISNULL(per_nit, 0), '_', '')) = 14 then '36' 
			when per_origen = 'E' then null--'3' 
			else null
			end 'tipo_documento_receptor', 

			case 
			when LEN(replace(REPLACE(ISNULL(per_dui, 0), '_', ''), '00000000-0', '')) = 10 then per_dui 
			when LEN(REPLACE(ISNULL(per_nit, 0), '_', '')) = 14 then per_nit
			when per_origen = 'E' then null 
			else null
			end 'numero_documento_receptor', 
			per_correo_institucional 'correo_receptor', per_email 'correo2_receptor',
			case when m013_codigo = '00' then '14' else m013_codigo end  'municipio_receptor', 
			case when m013_departamento = '00' then '06' else m013_departamento end 'departamento_receptor', 
			per_direccion 'direccion_receptor', 
			per_nombres_apellidos 'nombre_receptor', 

			--replace(per_telefono, '-', '') 'telefono_receptor', 
			case 
			when len(rtrim(ltrim(replace(replace(replace(per_telefono, '_', ''), '-', ''), '00000000', '')))) >= 8 then replace(per_telefono, '-', '') 
			when len(rtrim(ltrim(replace(replace(replace(per_celular, '_', ''), '-', ''), '00000000', '')))) >= 8 then replace(per_celular, '-', '')
			else per_telefono end 'telefono_receptor', 

			null 'nrc_receptor', 
			null 'actividad_economica_receptor', null 'descripcion_economica_receptor',
		
			mov_npe 'npe', mov_recibo_puntoxpress 'recibo_punto_express', mov_referencia_pos 'referencia_banco', mov_fp017 'forma_pago', mov_p018 'plazo', 
			mov_periodo_plazo 'periodo', null 'domiciliado', null 'codpais', null 'pais', null 'codigo_tipo_persona', null 'tipo_persona',

			mov_rechazado_por_mh 'rechazado_por_mh', mov_rechazos_por_mh 'rechazos_por_mh',
			mov_modelo_invalido 'modelo_invalido', mov_rechazos_modelo_invalido 'rechazos_modelo_invalido',
			
			mov_correlativo_anual 'correlativo_anual',

			'Facturas' 'controller'
			, 2 'select_n'
		from dbo.col_mov_movimientos 
			left join dbo.ra_per_personas on per_codigo = mov_codper
			inner join dbo.ra_mun_municipios on per_codmun_nac = MUN_CODIGO
			left join dbo.cat_m013_municipio_013 on mun_codm013mundep = m013_mundep

			left join dbo.adm_usr_usuarios on usr_usuario = mov_usuario
			left join dbo.pla_emp_empleado on usr_codemp = emp_codigo

		where mov_codigo >= 7363741
		and mov_codper not in (3) -- OTROS
		AND mov_tipo_pago not in ('X')
		and mov_recibo = '0'
		--col_mov agregar referencia de codfac y no mostrar esas facturas, probar con codfac: 8325 -> 

			union all

		select 7 tipo_dte_numero, '07' 'tipo_dte', 'CRE' 'documento', rei_codigo_generacion 'codigo_generacion', rei_numero_control 'numero_control', 
			rei_sello_recepcion 'sello_recepcion', rei_fecha_generacion_fe 'fecha_generacion_fe', '0000' 'codigo_establecimiento', '0000' 'codigo_punto_venta', 'UTEC' 'nombre_establecimiento',
			'rei' 'origen', rei_codigo 'codigo_origen', rei_fecha  'fecha_origen', rei_fecha_creacion 'fecha_registro_origen', rei_estado 'estado_origen', 
			usr_codigo, usr_usuario 'usuario_origen', emp_dui 'docuentrega', usr_nombre 'nombrentrega', 

			'Universidad Tecnologica de El Salvador' 'nombre_comercial_emisor',
			'01' 'tipo_establecimiento_emisor', '06' 'departamento_emisor', '14' 'municipio_emisor', '17 Avenida Norte y Calle Arce número 131 San Salvador, San Salvador' 'direccion_emisor',
			'22758718' 'telefono_emisor',

			pro_codigo 'codigo_receptor',
			case when isnull(pro_dui, '') <> '' then '13' else '36' end 'tipo_documento_receptor', 
			case when isnull(pro_dui, '') <> '' then replace(pro_dui, '-', '') else replace(pro_nit, '-', '') end 'numero_documento_receptor', 
			pro_email 'correo_receptor',  null 'correo2_receptor', 
			m013_codigo 'municipio_receptor', m013_departamento 'departamento_receptor', pro_direccion 'direccion_receptor', 
			pro_nombre_corto 'nombre_receptor', replace(pro_telefono, '-', '') 'telefono_receptor', replace(pro_num_iva, '-', '') 'nrc_receptor', 
			cae019_codigo 'actividad_economica_receptor', cae019_valores 'descripcion_economica_receptor',
		
			null 'npe', null 'recibo_punto_express', null 'referencia_banco', null 'forma_pago', null 'plazo', null 'periodo', 
			null 'domiciliado', null 'codpais', null 'pais', null 'codigo_tipo_persona', null 'tipo_persona',

			rei_rechazado_por_mh 'rechazado_por_mh', rei_rechazos_por_mh 'rechazos_por_mh',
			rei_modelo_invalido 'modelo_invalido', rei_rechazos_modelo_invalido 'rechazos_modelo_invalido',
			
			rei_correlativo_anual 'correlativo_anual',

			'ComprobanteRetencion' 'controller'
			, 3 'select_n'
		from dbo.con_rei_retencion_iva 
			inner join dbo.con_pro_proveedores on rei_codpro = pro_codigo
			inner join dbo.cat_m013_municipio_013 on pro_codm013 = m013_mundep

			inner join dbo.adm_usr_usuarios on usr_codigo = rei_codusr_creacion
			inner join dbo.pla_emp_empleado on usr_codemp = emp_codigo

			left join cat_cae019_codigo_actividad_economica_019 on pro_codcae019 = cae019_codigo
			--left join cat_df032_domicilio_fiscal_032 on pro_coddf032 = df032_codigo
		where rei_codigo >= 13096 --and rei_de_terceros = 0

			union all

		select 15 tipo_dte_numero, '15' 'tipo_dte', 'CDE' 'documento', don_codigo_generacion 'codigo_generacion', don_numero_control 'numero_control', 
			don_sello_recepcion 'sello_recepcion', don_fecha_generacion_fe 'fecha_generacion_fe', '0000' 'codigo_establecimiento', '0000' 'codigo_punto_venta', 'UTEC' 'nombre_establecimiento',
			'don' 'origen', don_codigo 'codigo_origen', don_fecha  'fecha_origen', don_fecha_creacion 'fecha_registro_origen', don_estado 'estado_origen', 
			usr_codigo, usr_usuario 'usuario_origen', emp_dui 'docuentrega', usr_nombre 'nombrentrega', 

			'Universidad Tecnologica de El Salvador' 'nombre_comercial_emisor',
			'01' 'tipo_establecimiento_emisor', '06' 'departamento_emisor', '14' 'municipio_emisor', '17 Avenida Norte y Calle Arce número 131 San Salvador, San Salvador' 'direccion_emisor',
			'22758718' 'telefono_emisor',

			pro_codigo 'codigo_receptor',
			case when isnull(pro_dui, '') <> '' then '13' else '36' end 'tipo_documento_receptor', 
			case when isnull(pro_dui, '') <> '' then replace(pro_dui, '-', '') else replace(pro_nit, '-', '') end 'numero_documento_receptor', 
			pro_email 'correo_receptor', null 'correo2_receptor', 
			m013_codigo 'municipio_receptor', d012_codigo 'departamento_receptor', pro_direccion 'direccion_receptor', 
			pro_nombre_corto 'nombre_receptor', replace(pro_telefono, '-', '') 'telefono_receptor', replace(pro_num_iva, '-', '') 'nrc_receptor', 
			cae019_codigo 'actividad_economica_receptor', cae019_valores 'descripcion_economica_receptor',
		
			null 'npe', null 'recibo_punto_express', null 'referencia_banco', null 'forma_pago', null 'plazo', null 'periodo', 
			df032_codigo 'domiciliado', p020_codigo 'codpais', null 'pais', null 'codigo_tipo_persona', null 'tipo_persona',

			don_rechazado_por_mh 'rechazado_por_mh', don_rechazos_por_mh 'rechazos_por_mh',
			don_modelo_invalido 'modelo_invalido', don_rechazos_modelo_invalido 'rechazos_modelo_invalido',
			
			don_correlativo_anual 'correlativo_anual',

			'ComprobanteDonacion' 'controller'
			, 4 'select_n'
		from dbo.con_don_donaciones 
			inner join dbo.con_pro_proveedores on don_codprod = pro_codigo
			inner join dbo.adm_usr_usuarios on usr_codigo = don_codusr_creacion
			inner join dbo.pla_emp_empleado on usr_codemp = emp_codigo
			inner join cat_df032_domicilio_fiscal_032 on df032_codigo = pro_coddf032
			left join cat_m013_municipio_013 on pro_codm013 = m013_mundep
			left join cat_d012_departamento_012 on m013_departamento = d012_codigo
			left join cat_p020_pais_020 on p020_codigo = d012_pais_codp020
			left join cat_cae019_codigo_actividad_economica_019 on pro_codcae019 = cae019_codigo

			union all

		select 14 tipo_dte_numero, '14' 'tipo_dte', 'FSE' 'documento', faex_codigo_generacion 'codigo_generacion', faex_numero_control 'numero_control', 
			faex_sello_recepcion 'sello_recepcion', faex_fecha_generacion_fe 'fecha_generacion_fe', '0000' 'codigo_establecimiento', '0000' 'codigo_punto_venta', 'UTEC' 'nombre_establecimiento',
			'faex' 'origen', faex_codigo 'codigo_origen', faex_fecha  'fecha_origen', faex_fecha_registro 'fecha_registro_origen', faex_estado 'estado_origen', 
			usr_codigo, usr_usuario 'usuario_origen', emp_dui 'docuentrega', usr_nombre 'nombrentrega', 

			'Universidad Tecnologica de El Salvador' 'nombre_comercial_emisor',
			'01' 'tipo_establecimiento_emisor', '06' 'departamento_emisor', '14' 'municipio_emisor', '17 Avenida Norte y Calle Arce número 131 San Salvador, San Salvador' 'direccion_emisor',
			'22758718' 'telefono_emisor',

			pro_codigo 'codigo_receptor',
			case when isnull(pro_dui, '') <> '' then '13' else '36' end 'tipo_documento_receptor', 
			case when isnull(pro_dui, '') <> '' then replace(pro_dui, '-', '') else replace(pro_nit, '-', '') end 'numero_documento_receptor', 
			pro_email 'correo_receptor', null 'correo2_receptor', 
			m013_codigo 'municipio_receptor', d012_codigo 'departamento_receptor', pro_direccion 'direccion_receptor', 
			pro_nombre_corto 'nombre_receptor', replace(pro_telefono, '-', '') 'telefono_receptor', replace(pro_num_iva, '-', '') 'nrc_receptor', 
			cae019_codigo 'actividad_economica_receptor', cae019_valores 'descripcion_economica_receptor',
		
			null 'npe', null 'recibo_punto_express', faex_referencia 'referencia_banco', fp017_codigo 'forma_pago', '01' 'plazo', 1 'periodo', 
			null 'domiciliado', null 'codpais', null 'pais', null 'codigo_tipo_persona', null 'tipo_persona',

			faex_rechazado_por_mh 'rechazado_por_mh', faex_rechazos_por_mh 'rechazos_por_mh',
			faex_modelo_invalido 'modelo_invalido', faex_rechazos_modelo_invalido 'rechazos_modelo_invalido',
			
			faex_correlativo_anual 'correlativo_anual',

			'SujetoExcluido' 'controller'
			, 5 'select_n'
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
		where faex_codigo >= 6739
			union all

		select 14 tipo_dte_numero, '14' 'tipo_dte', 'FSE' 'documento', faex_codigo_generacion 'codigo_generacion', faex_numero_control 'numero_control', 
			faex_sello_recepcion 'sello_recepcion', faex_fecha_generacion_fe 'fecha_generacion_fe', '0000' 'codigo_establecimiento', '0000' 'codigo_punto_venta', 'UTEC' 'nombre_establecimiento',
			'faex' 'origen', faex_codigo 'codigo_origen', faex_fecha  'fecha_origen', faex_fecha_registro 'fecha_registro_origen', faex_estado 'estado_origen', 
			usr_codigo, usr_usuario 'usuario_origen', e2.emp_dui 'docuentrega', usr_nombre 'nombrentrega', 

			'Universidad Tecnologica de El Salvador' 'nombre_comercial_emisor',
			'01' 'tipo_establecimiento_emisor', '06' 'departamento_emisor', '14' 'municipio_emisor', '17 Avenida Norte y Calle Arce número 131 San Salvador, San Salvador' 'direccion_emisor',
			'22758718' 'telefono_emisor',

			e1.emp_codigo 'codigo_receptor',
			case 
			when isnull(e1.emp_dui, '') <> '' then '13' 
			when e1.emp_nit like '9%' then '3' 
			else '36' 
			end 'tipo_documento_receptor', 
			case 
			when isnull(e1.emp_dui, '') <> '' then replace(e1.emp_dui, '-', '') 
			when e1.emp_nit like '9%' then e1.emp_dui
			else replace(e1.emp_nit, '-', '') end 'numero_documento_receptor', 
			e1.emp_email_institucional 'correo_receptor', e1.emp_correo_alterno 'correo2_receptor', 
			m013_codigo 'municipio_receptor', d012_codigo 'departamento_receptor', e1.emp_direccion 'direccion_receptor', 

			e1.emp_nombres_apellidos 'nombre_receptor', 
			
			case 
			when len(rtrim(ltrim(replace(replace(replace(e1.emp_telefono, '_', ''), '-', ''), '00000000', '')))) >= 8 then replace(e1.emp_telefono, '-', '') 
			when len(rtrim(ltrim(replace(replace(replace(e1.emp_celular, '_', ''), '-', ''), '00000000', '')))) >= 8 then replace(e1.emp_celular, '-', '')
			else e1.emp_telefono end 'telefono_receptor', e1.emp_NRC 'nrc_receptor', 
			cae019_codigo 'actividad_economica_receptor', cae019_valores 'descripcion_economica_receptor',
		
			null 'npe', null 'recibo_punto_express', faex_referencia 'referencia_banco', fp017_codigo 'forma_pago', '01' 'plazo', 1 'periodo', 
			null 'domiciliado', null 'codpais', null 'pais', null 'codigo_tipo_persona', null 'tipo_persona', 

			faex_rechazado_por_mh 'rechazado_por_mh', faex_rechazos_por_mh 'rechazos_por_mh',
			faex_modelo_invalido 'modelo_invalido', faex_rechazos_modelo_invalido 'rechazos_modelo_invalido',
			
			faex_correlativo_anual 'correlativo_anual',

			'SujetoExcluido' 'controller'
			, 6 'select_n'
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
		where faex_codigo >= 6739
	) t
		left join dbo.adm_usr_usuarios adm on adm.usr_codigo = codusr_facturo
		left join dbo.col_punven_puntos_ventas on usr_codpunven = punven_codigo
		left join dbo.col_esta_establecimientos on punven_codesta = esta_codigo
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-05-02 11:23:26.260>
	-- Description: <Vista encargada del control de todos los detalles de las facturas emitidas para la asignacion y registro en hacienda>
	-- La fecha "" es porque solo se toman en cuenta las facturas posteriores a esa fecha
	-- =============================================
	-- select TOP 10 * from vst_mh_detalle_facturas where tipo_dte_numero = 1 and codigo_encabezado_origen = 7364437 order by fecha_registro_origen desc
create or alter view vst_mh_detalle_facturas 
as
	select tipo_dte_numero, tipo_dte, documento, origen, codigo_encabezado_origen, codigo_origen, fecha_origen, fecha_registro_origen, tipo_item, 
		codigo_arancel, arancel, descripcion_arancel, valor_arancel, 
		numero_documento,
		isnull(unidad_medida, 0) unidad_medida, cantidad, 
		round(isnull(cast(valor as float), 0), 2) valor, 
		round(isnull(cast(isnull(iva, 0) as float), 0), 2) iva, 
		isnull(venta_exenta, 0) venta_exenta, 
		round(isnull(cast(venta_gravada as float), 0), 2) venta_gravada, tributos, 
		isnull(cast(venta_nosuj as float), 0) venta_nosuj, 
		isnull(cast(monto_descuento as float), 0) monto_descuento, 
		isnull(cast(psv as float), 0) psv, 
		isnull(cast(no_gravado as float), 0) no_gravado, 
		round(isnull(cast(iva_item as float), 0), 2) iva_item, 
		round(isnull(cast(iva_retenido as float), 0), 2) iva_retenido,
		procentaje_retencion, depreciacion, referencia, forma_pago,
		codcil, ciclo, controller, select_n
	from (
		select fac_tipo_dte_numero tipo_dte_numero, fac_tipo_dte 'tipo_dte', fac_documento 'documento', 
			'dfa' 'origen', fac_codigo 'codigo_encabezado_origen', dfa_codigo 'codigo_origen', 
			fac_fecha 'fecha_origen', fac_fecha_registro 'fecha_registro_origen', 

			case when dfa_iva > 0 then 2 else 2 end 'tipo_item',
			tmo_codigo 'codigo_arancel', tmo_arancel 'arancel', fac_descripcion/*tmo_descripcion*/ 'descripcion_arancel', tmo_valor 'valor_arancel', 
			tmo_medida_mh 'unidad_medida', 1 'cantidad', 
			case when tmo_medida_mh = 59 and fac_documento = 'FC' then dfa_valor - dfa_iva else dfa_valor end 'valor', 
			dfa_iva 'iva', 
			case when tmo_medida_mh = 99 then dfa_valor + dfa_iva else 0 end 'venta_exenta',
			case when tmo_medida_mh = 59 then 
			case when fac_documento = 'FC' then dfa_valor else dfa_valor + dfa_iva end
			else 0 end 'venta_gravada',
			case when tmo_medida_mh = 59 then '20' else 0 end 'tributos',
			0.0 'venta_nosuj',
			0.0 'monto_descuento',
			0.0 'psv',
			0.0 'no_gravado',
			dfa_iva 'iva_item', cil_codigo 'codcil', concat('0', cil_codcic, '-', cil_anio) 'ciclo', 
			0 'iva_retenido', 0 'procentaje_retencion', null 'numero_documento', null 'depreciacion', null 'referencia', null 'forma_pago',

			case when fac_tipo_dte_numero = 1 then 'Facturas' when fac_tipo_dte_numero = 11 then 'FacturaExportacion' when fac_tipo_dte_numero = 3 then 'ComprobanteCreditoFiscal' when fac_tipo_dte_numero = 5 then 'NotaCredito' else '-' end 'controller'
			, 1 'select_n'
		from col_fac_facturas 
			inner join col_dfa_det_fac on dfa_codfac = fac_codigo
			inner join col_tmo_tipo_movimiento on dfa_codtmo = tmo_codigo
			inner join ra_cil_ciclo on dfa_codcil = cil_codigo
			left join col_cli_clientes on fac_codcli = cli_codigo
		where fac_codigo >= 8793

			union all

		select 1 tipo_dte_numero, '01' 'tipo_dte', 'FE' 'documento', 
			'dmo' 'origen', mov_codigo 'codigo_encabezado_origen', dmo_codigo 'codigo_origen', 
			mov_fecha 'fecha_origen', mov_fecha_registro 'fecha_registro_origen',

			case when dmo_iva > 0 then 2 else 2 end 'tipo_item'
			, tmo_codigo 'codigo_arancel', tmo_arancel 'arancel', tmo_descripcion 'descripcion_arancel', tmo_valor 'valor_arancel', 
			tmo_medida_mh 'unidad_medida', 1 'cantidad', dmo_valor 'valor', dmo_iva 'iva', 
			case when tmo_medida_mh = 99 then dmo_valor + dmo_iva else 0 end 'venta_exenta',
			case when tmo_medida_mh = 59 then dmo_valor + dmo_iva else 0 end 'venta_gravada',
			case when tmo_medida_mh = 59 then '20' else 0 end 'tributos',
			0.0 'venta_nosuj', 0.0 'monto_descuento', 0.0 'psv', 0.0 'no_gravado',
			dmo_iva 'iva_item', cil_codigo 'codcil', concat('0', cil_codcic, '-', cil_anio) 'ciclo', 
			0 'iva_retenido', 0 'procentaje_retencion', null 'numero_documento', null 'depreciacion', null 'referencia', null 'forma_pago',

			'Facturas' 'controller'
			, '2' 'select_n'
		from col_mov_movimientos 
			inner join col_dmo_det_mov on dmo_codmov = mov_codigo
			inner join col_tmo_tipo_movimiento on dmo_codtmo = tmo_codigo
			inner join ra_cil_ciclo on dmo_codcil = cil_codigo
			left join ra_per_personas on per_codigo = mov_codper
		where mov_codigo >= 7353741

			union all

		select 7 tipo_dte_numero, 
			case 
			when rid_tipo = 1 then '03'
			when (rid_tipo = 2 and rid_porcentaje_retencion = '13') then '14'
			when rid_tipo = 2 then '01'
			end /*14, 03, 01*/ 'tipo_dte', 'CRE' 'documento', 
			'rid' 'origen', rei_codigo 'codigo_encabezado_origen', rid_codigo 'codigo_origen', 
			rei_fecha 'fecha_origen', rei_fecha_creacion 'fecha_registro_origen', 

			null 'tipo_item',
			null 'codigo_arancel', null 'arancel', 
			
			case 
				when rid_tipo = 1 then 'Retención de IVA sobre CCF #' + convert(varchar(60), rid_numero_documento)
				when (rid_tipo = 2 and rid_porcentaje_retencion = '13') then 'Retencion 13% IVA factura sujeto excluido # '  + convert(varchar(60), rid_numero_documento)
				when rid_tipo = 2 then 'Retención de IVA sobre Factura #' + convert(varchar(60), rid_numero_documento)
			end 'descripcion_arancel', null 'valor_arancel', 
			null 'unidad_medida', 1 'cantidad', rid_valor 'valor', rid_iva 'iva', 
			null 'venta_exenta', null 'venta_gravada', null 'tributos', null 'venta_nosuj', null 'monto_descuento', null 'psv', null 'no_gravado',
			null 'iva_item', null 'codcil', null 'ciclo', rid_retencion 'iva_retenido', 
			rid_porcentaje_retencion 'procentaje_retencion', rid_numero_documento 'numero_documento', null 'depreciacion', null 'referencia', null 'forma_pago',

			'ComprobanteRetencion' 'controller'
			, 3 'select_n'
		from con_rei_retencion_iva 
			inner join con_rid_retencion_iva_detalle on rid_codrei = rei_codigo
			left join con_pro_proveedores on rei_codpro = pro_codigo

			union all

		select 15 tipo_dte_numero, null 'tipo_dte', 'CDE' 'documento', 
			'ddon' 'origen', don_codigo 'codigo_encabezado_origen', ddon_codigo 'codigo_origen', 
			ddon_fecha_donacion 'fecha_origen', ddon_fecha_creacion 'fecha_registro_origen', 

			td026_codigo 'tipo_item',
			null 'codigo_arancel', null 'arancel', 
			
			ddon_descripcion 'descripcion_arancel', null 'valor_arancel', 
			um14_codigo 'unidad_medida', ddon_cantidad 'cantidad', ddon_valor_unidad 'valor', null 'iva', 
			null 'venta_exenta', null 'venta_gravada', null 'tributos', null 'venta_nosuj', null 'monto_descuento', null 'psv', null 'no_gravado',
			null 'iva_item', null 'codcil', null 'ciclo', null 'iva_retenido', 
			null 'procentaje_retencion', null 'numero_documento', ddon_depreciacion 'depreciacion', ddon_referencia_bancaria 'referencia'
			, fp017_codigo 'forma_pago',

			'ComprobanteDonacion' 'controller'
			, 4 'select_n'
		from con_don_donaciones 
			inner join con_ddon_detalle_donaciones on don_codigo = ddon_coddon
			inner join con_pro_proveedores on don_codprod = pro_codigo
			inner join cat_td026_tipo_donacion_026 on ddon_tipo_codcat026 = td026_codigo
			inner join cat_um014_unidad_medida_014 on ddon_unidad_codcat014 = um14_codigo
			inner join cat_fp017_forma_pago_017 on fp017_codigo = ddon_forma_pago_codcat017

			union all

		select 14 tipo_dte_numero, null 'tipo_dte', 'FSE' 'documento', 
			'faexde' 'origen', faex_codigo 'codigo_encabezado_origen', faexde_codigo 'codigo_origen', 
			faex_fecha 'fecha_origen', faex_fecha_registro 'fecha_registro_origen', 

			ti011_codigo 'tipo_item',
			null 'codigo_arancel', null 'arancel', 
			
			faexde_descripcion 'descripcion_arancel', null 'valor_arancel', 
			um14_codigo 'unidad_medida', faexde_cantidad 'cantidad', faexde_precio 'valor', null 'iva', 
			null 'venta_exenta', null 'venta_gravada', null 'tributos', null 'venta_nosuj', null 'monto_descuento', null 'psv', null 'no_gravado',
			null 'iva_item', null 'codcil', null 'ciclo', null 'iva_retenido', 
			null 'procentaje_retencion', null 'numero_documento', null 'depreciacion', null 'referencia'
			, null 'forma_pago',

			'SujetoExcluido' 'controller'
			, 5 'select_n'
		from faex_facturacion_sujeto_excluido 
			inner join faexde_facturacion_sujeto_excluido_detalle on faexde_codfaex = faex_codigo
			inner join cat_um014_unidad_medida_014 on faexde_um014 = um14_codigo
			inner join cat_ti011_tipo_item_011 on ti011_codigo = faexde_codti011

	) t
go

