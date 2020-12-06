--199504, 26-2263-2017
--select * from col_tipmen_tipo_mensualidad
--select * from col_dtde_detalle_tipo_estudio

--insert into col_tipmen_tipo_mensualidad (tipmen_tipo, tipmen_estado, tipmen_coddtde, tipmen_codvac) values
--('Media beca preespecializacion ($57.14) PRESENCIAL-TECNICO', 1, 4, 1),
--('Media beca preespecializacion ($57.14) VIRTUAL-TECNICO', 1, 4, 2)

--TECNICOS PRESENCIALES
--insert into col_tpmenara_tipo_mensualidad_aranceles 
--(tpmenara_arancel, tpmenara_monto_pagar, tpmenara_arancel_descuento, tpmenara_monto_arancel_descuento, 
--tpmenara_codtipmen,tpmenara_monto_descuento, tpmenara_valor_mora)
--select 
--tpmenara_arancel, tpmenara_monto_pagar - 31.43, tpmenara_arancel_descuento, tpmenara_monto_arancel_descuento, 
--35, tpmenara_monto_descuento - 31.43, tpmenara_valor_mora
--from col_tpmenara_tipo_mensualidad_aranceles where tpmenara_codtipmen = 22 and tpmenara_codigo <= 161
--union
--select 'E-03', 50, 0, 0, 35, 50, 0
--update col_tpmenara_tipo_mensualidad_aranceles set tpmenara_monto_pagar = 105, tpmenara_monto_descuento = 0, tpmenara_arancel = 'I-73'
--where tpmenara_codtipmen = 35 and tpmenara_arancel = 'I-03'
--update col_tpmenara_tipo_mensualidad_aranceles set tpmenara_monto_pagar = 100, tpmenara_monto_descuento = 0
--where tpmenara_codtipmen = 35 and tpmenara_arancel = 'E-03'

--TECNICOS VIRTUALES
--insert into col_tpmenara_tipo_mensualidad_aranceles 
--(tpmenara_arancel, tpmenara_monto_pagar, tpmenara_arancel_descuento, tpmenara_monto_arancel_descuento, 
--tpmenara_codtipmen,tpmenara_monto_descuento, tpmenara_valor_mora)
--select 
--tpmenara_arancel, tpmenara_monto_pagar - 31.43, tpmenara_arancel_descuento, tpmenara_monto_arancel_descuento, 
--36, tpmenara_monto_descuento - 31.43, tpmenara_valor_mora
--from col_tpmenara_tipo_mensualidad_aranceles where tpmenara_codtipmen = 22 and tpmenara_codigo <= 161
--union
--select 'E-03', 50, 0, 0, 36, 50, 0
--update col_tpmenara_tipo_mensualidad_aranceles set tpmenara_monto_pagar = 105, tpmenara_monto_descuento = 0, tpmenara_arancel = 'I-73'
--where tpmenara_codtipmen = 36 and tpmenara_arancel = 'I-03'
--update col_tpmenara_tipo_mensualidad_aranceles set tpmenara_monto_pagar = 100, tpmenara_monto_descuento = 0
--where tpmenara_codtipmen = 36 and tpmenara_arancel = 'E-03'

select * from col_tpmenara_tipo_mensualidad_aranceles where tpmenara_codtipmen IN (35, 36)

select * from col_art_archivo_tal_proc_grad_tec_mora where per_codigo = 199504
--alter table col_art_archivo_tal_proc_grad_tec_mora add fel_orden int
--alter table col_art_archivo_tal_proc_grad_tec_mora add codtmo_descuento int
--alter table col_art_archivo_tal_proc_grad_tec_mora add monto_descuento numeric(18, 2)
--alter table col_art_archivo_tal_proc_grad_tec_mora add monto_arancel_descuento numeric(18, 2)
--alter table col_art_archivo_tal_proc_grad_tec_mora add fel_codvac int

--alter table col_fel_fechas_limite_tecnicos add fel_codtipmen int
--alter table col_fel_fechas_limite_tecnicos add fel_codvac int
--alter table col_fel_fechas_limite_tecnicos add fel_orden int

select * from vst_para_boleta_mensualidades where detmen_codper in (199504, 195376)
select * from col_detmen_detalle_tipo_mensualidad where detmen_codper in (199504, 195376)

select * from ra_per_personas where per_codigo = 199504

select * from vst_Aranceles_x_Evaluacion
select * from aranceles_x_evaluacion where are_tipo = 'PREESPECIALIDAD'
--insert into aranceles_x_evaluacion (are_codtmo, are_codtde, are_spaet_codigo, are_tipoarancel, are_tipo, are_cuota)
--values (334, 1, 6, 'Men', 'PREESPECIALIDAD', 6),
--(555, 1, 0, 'Mat', 'PREESPECIALIDAD', 0)

select tpmenara_codigo, concat(tmo_arancel, ' ',tmo_descripcion, ' (monto a pagar: $', tpmenara_monto_pagar, ')') 'descripcion'
from col_tpmenara_tipo_mensualidad_aranceles, vst_Aranceles_x_Evaluacion
where tpmenara_arancel = tmo_arancel and tpmenara_codtipmen = 36

select * from col_art_archivo_tal_mora where per_codigo = 199504
select * from col_art_archivo_tal_proc_grad_tec_mora where per_codigo in (199504, 195376)


--insert into col_fel_fechas_limite_tecnicos 
--(fel_codreg, fel_codcil, fel_mes, fel_anio, fel_fecha, fel_codtmo, fel_tipo, fel_fecha_gracia, fel_codigo_barra, 
--fel_valor, fel_global, fel_valor_mora, fel_fecha_mora, fel_tipo_alumno, fel_codtipmen, fel_codvac, fel_orden) values
----CODCIL 122 PRESENCIALES
--(1, 122, 2, 2020, '2020-02-16 00:00:00.000', 555, 'N', '1900-01-01 00:00:00.000', 1, 105, 0, 105, '2020-02-17 00:00:00.000', 'E', 35, 1, 0),
--(1, 122, 2, 2020, '2020-02-16 00:00:00.000', 222, 'N', '1900-01-01 00:00:00.000', 2, 57.14, 0, 57.14, '2020-02-17 00:00:00.000', 'E', 35, 1, 2),
--(1, 122, 3, 2020, '2020-03-16 00:00:00.000', 223, 'N', '1900-01-01 00:00:00.000', 3, 57.14, 0, 57.14, '2020-03-17 00:00:00.000', 'E', 35, 1, 3),
--(1, 122, 4, 2020, '2020-08-16 00:00:00.000', 224, 'N', '1900-01-01 00:00:00.000', 4, 57.14, 0, 57.14, '2020-08-17 00:00:00.000', 'E', 35, 1, 4),
--(1, 122, 5, 2020, '2020-09-16 00:00:00.000', 225, 'N', '1900-01-01 00:00:00.000', 5, 57.14, 0, 57.14, '2020-09-17 00:00:00.000', 'E', 35, 1, 5),
--(1, 122, 6, 2020, '2020-10-16 00:00:00.000', 226, 'N', '1900-01-01 00:00:00.000', 6, 57.14, 0, 57.14, '2020-10-17 00:00:00.000', 'E', 35, 1, 6),
--(1, 122, 7, 2020, '2020-10-30 00:00:00.000', 334, 'N', '1900-01-01 00:00:00.000', 7, 100, 0, 100, '2020-10-30 00:00:00.000', 'E', 35, 1, 7),
----CODCIL 122 VIRTUALES
--(1, 122, 2, 2020, '2020-02-16 00:00:00.000', 555, 'N', '1900-01-01 00:00:00.000', 1, 105, 0, 105, '2020-02-17 00:00:00.000', 'E', 36, 2, 0),
--(1, 122, 2, 2020, '2020-02-16 00:00:00.000', 222, 'N', '1900-01-01 00:00:00.000', 2, 57.14, 0, 57.14, '2020-02-17 00:00:00.000', 'E', 36, 2, 2),
--(1, 122, 3, 2020, '2020-03-16 00:00:00.000', 223, 'N', '1900-01-01 00:00:00.000', 3, 57.14, 0, 57.14, '2020-03-17 00:00:00.000', 'E', 36, 2, 3),
--(1, 122, 4, 2020, '2020-08-16 00:00:00.000', 224, 'N', '1900-01-01 00:00:00.000', 4, 57.14, 0, 57.14, '2020-08-17 00:00:00.000', 'E', 36, 2, 4),
--(1, 122, 5, 2020, '2020-09-16 00:00:00.000', 225, 'N', '1900-01-01 00:00:00.000', 5, 57.14, 0, 57.14, '2020-09-17 00:00:00.000', 'E', 36, 2, 5),
--(1, 122, 6, 2020, '2020-10-16 00:00:00.000', 226, 'N', '1900-01-01 00:00:00.000', 6, 57.14, 0, 57.14, '2020-10-17 00:00:00.000', 'E', 36, 2, 6),
--(1, 122, 7, 2020, '2020-10-30 00:00:00.000', 334, 'N', '1900-01-01 00:00:00.000', 7, 100, 0, 100, '2020-10-30 00:00:00.000', 'E', 36, 2, 7),
----CODCIL 123 PRESENCIALES
--(1, 123, 2, 2020, '2020-07-16 00:00:00.000', 555, 'N', '1900-01-01 00:00:00.000', 1, 105, 0, 105, '2020-07-17 00:00:00.000', 'E', 35, 1, 0),
--(1, 123, 2, 2020, '2020-07-16 00:00:00.000', 222, 'N', '1900-01-01 00:00:00.000', 2, 57.14, 0, 57.14, '2020-07-17 00:00:00.000', 'E', 35, 1, 2),
--(1, 123, 3, 2020, '2020-08-16 00:00:00.000', 223, 'N', '1900-01-01 00:00:00.000', 3, 57.14, 0, 57.14, '2020-08-17 00:00:00.000', 'E', 35, 1, 3),
--(1, 123, 4, 2020, '2020-09-16 00:00:00.000', 224, 'N', '1900-01-01 00:00:00.000', 4, 57.14, 0, 57.14, '2020-09-17 00:00:00.000', 'E', 35, 1, 4),
--(1, 123, 5, 2020, '2020-10-16 00:00:00.000', 225, 'N', '1900-01-01 00:00:00.000', 5, 57.14, 0, 57.14, '2020-10-17 00:00:00.000', 'E', 35, 1, 5),
--(1, 123, 6, 2020, '2020-11-16 00:00:00.000', 226, 'N', '1900-01-01 00:00:00.000', 6, 57.14, 0, 57.14, '2020-11-17 00:00:00.000', 'E', 35, 1, 6),
--(1, 123, 7, 2020, '2020-11-30 00:00:00.000', 334, 'N', '1900-01-01 00:00:00.000', 7, 100, 0, 100, '2020-11-30 00:00:00.000', 'E', 35, 1, 7),
----CODCIL 123 VIRTUALES
--(1, 123, 2, 2020, '2020-07-16 00:00:00.000', 555, 'N', '1900-01-01 00:00:00.000', 1, 105, 0, 105, '2020-07-17 00:00:00.000', 'E', 36, 2, 0),
--(1, 123, 2, 2020, '2020-07-16 00:00:00.000', 222, 'N', '1900-01-01 00:00:00.000', 2, 57.14, 0, 57.14, '2020-07-17 00:00:00.000', 'E', 36, 2, 2),
--(1, 123, 3, 2020, '2020-08-16 00:00:00.000', 223, 'N', '1900-01-01 00:00:00.000', 3, 57.14, 0, 57.14, '2020-08-17 00:00:00.000', 'E', 36, 2, 3),
--(1, 123, 4, 2020, '2020-09-16 00:00:00.000', 224, 'N', '1900-01-01 00:00:00.000', 4, 57.14, 0, 57.14, '2020-09-17 00:00:00.000', 'E', 36, 2, 4),
--(1, 123, 5, 2020, '2020-10-16 00:00:00.000', 225, 'N', '1900-01-01 00:00:00.000', 5, 57.14, 0, 57.14, '2020-10-17 00:00:00.000', 'E', 36, 2, 5),
--(1, 123, 6, 2020, '2020-11-16 00:00:00.000', 226, 'N', '1900-01-01 00:00:00.000', 6, 57.14, 0, 57.14, '2020-11-17 00:00:00.000', 'E', 36, 2, 6),
--(1, 123, 7, 2020, '2020-11-30 00:00:00.000', 334, 'N', '1900-01-01 00:00:00.000', 7, 100, 0, 100, '2020-11-30 00:00:00.000', 'E', 36, 2, 7)

--ACTUALIZANDO fel_codvac Y fel_orden CODCIL 123 PRESENCIALES
--update col_fel_fechas_limite_tecnicos set fel_codvac = 1 where fel_codigo in (126, 127, 128, 129, 130, 131, 132)
--update col_fel_fechas_limite_tecnicos set fel_orden = 0 where fel_codigo = 126
--update col_fel_fechas_limite_tecnicos set fel_orden = 2 where fel_codigo = 127
--update col_fel_fechas_limite_tecnicos set fel_orden = 3 where fel_codigo = 128
--update col_fel_fechas_limite_tecnicos set fel_orden = 4 where fel_codigo = 129
--update col_fel_fechas_limite_tecnicos set fel_orden = 5 where fel_codigo = 130
--update col_fel_fechas_limite_tecnicos set fel_orden = 6 where fel_codigo = 131
--update col_fel_fechas_limite_tecnicos set fel_orden = 7 where fel_codigo = 132

--INSERTANDO fechas limites para el ciclo 122 y 123 para el CODVAC 2
--insert into col_fel_fechas_limite_tecnicos 
--(fel_codreg, fel_codcil, fel_mes, fel_anio, fel_fecha, fel_codtmo, fel_tipo, fel_fecha_gracia, fel_codigo_barra, 
--fel_valor, fel_global, fel_valor_mora, fel_fecha_mora, fel_tipo_alumno, fel_codtipmen, fel_codvac, fel_orden)
--select fel_codreg, fel_codcil, fel_mes, fel_anio, fel_fecha, fel_codtmo, fel_tipo, fel_fecha_gracia, fel_codigo_barra, 
--fel_valor, fel_global, fel_valor_mora, fel_fecha_mora, fel_tipo_alumno, fel_codtipmen, 2, fel_orden from col_fel_fechas_limite_tecnicos where fel_codigo in (119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132)

select * from col_fel_fechas_limite_tecnicos where fel_codcil in (122, 123)--56
--fel_codtipmen in (35, 36)

--SPs replicar de desarrollo a produccion
--create: tal_GenerarDataTalonarioPreEspecialidad_Tecnicos_Especial
--alter: tal_GeneraDataTalonario_alumnos_tipo_mensualidad_especial
--alter: web_col_art_archivo_tal_pre_tecnicos
--alter: sp_insertar_pagos_x_carnet_estructurado

select * from col_detmen_detalle_tipo_mensualidad where detmen_codper in (199504, 195376)
select * from col_art_archivo_tal_proc_grad_tec_mora where per_codigo in (199504, 195376)