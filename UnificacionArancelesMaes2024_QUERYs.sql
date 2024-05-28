--M-260   Descuento alumno graduado Utec (semipresencial)
--M-261   Descuento alumno graduado Utec (no presencial)
--M-262   Descuento alumno graduado Utec (Robotica)
select * from col_tmo_tipo_movimiento where tmo_arancel in ('M-260', 'M-261', 'M-262')

--IMPORTANTE: Po favor considerar que estas boletas ya deben tener el arancel de $115.00, nuevo arancel para Maestrias a partir del ciclo 01-2024. Adicionalmente recordarles que también debe quedar eliminada la leyenda de beca.
--Agradeceremos que al generar las boletas para el 01-2024 y dado el nuevo arancel NO se realice ninguna modificación a las boletas del 02-2023 ya que el arancel para este último ciclo (02-2023) aún continua con $110.00
--Matricula Abril
--Primera cuta Abril 
--Segunda cuota Mayo 
--Tercera cuota Junio 
--Cuarta cuota Julio
--Quinta cuota Agosto 
--Sexta cuota Septiembre

-- $810.00, MAESTRIA SEMIPRESENCIAL
select * from col_tmo_tipo_movimiento where tmo_arancel in ('M-230', 'M-231', 'M-232', 'M-233', 'M-234', 'M-235', 'M-236')

-- $810.00, MAESTRIA VIRTUAL
select * from col_tmo_tipo_movimiento where tmo_arancel in ('M-240', 'M-241', 'M-242', 'M-243', 'M-244', 'M-245', 'M-246')

-- $1,010.00, MAESTRIA EN ROBOTICA
select * from col_tmo_tipo_movimiento where tmo_arancel in ('M-150', 'M-151', 'M-152', 'M-153', 'M-154', 'M-155', 'M-156')

-- $1,155.00, PROCESO DE GRADUACION (9 MESES)
select * from col_tmo_tipo_movimiento where tmo_arancel in ('M-250', 'M-251', 'M-252', 'M-253', 'M-254', 'M-255', 'M-256', 'M-257', 'M-258', 'M-259')

select * from ra_per_personas where per_tipo = 'M' order by per_codigo desc

select * from ra_ccm_cohorte_campus_maestria where ccm_codigo = 94
select * from col_fel_fechas_limite_mae_mora where fel_codcil = 131
select * from col_fel_fechas_limite_mae_mora where fel_codcil = 134
select distinct origen, ccm_cohorte from col_art_archivo_tal_mae_mora inner join ra_ccm_cohorte_campus_maestria on ccm_codigo = origen where ciclo = 131
select * from col_art_archivo_tal_mae_mora where per_codigo = 249607
select * from tab_tal_maestria_beca where per_codigo = 249607

select * from col_art_archivo_tal_mae_mora a
	inner join ra_per_personas p on a.per_codigo = p.per_codigo
where  pla_alias_carrera like '%semi%'
select * from vst_Aranceles_x_Evaluacion where are_tipo = 'MAESTRIAS' and are_codigo > 178 order by are_codigo
select * from vst_Aranceles_x_Evaluacion where tmo_arancel = 'M-150'
select * from aranceles_x_evaluacion where are_codigo > 178

select * from col_art_archivo_tal_mae_mora where ciclo = 134
select * from ra_per_personas where per_codigo = 253124
select * from tab_tal_maestria_beca where per_codigo = 253124
select * from col_art_archivo_tal_mae_mora where per_codigo = 253124
select * from col_detmen_detalle_tipo_mensualidad 
	inner join col_tpmenara_tipo_mensualidad_aranceles on detmen_codtpmenara = tpmenara_codigo
where detmen_codper = 253124
select distinct per_carnet, per_nombres_apellidos from col_art_archivo_tal_mae_mora WHERE pla_alias_carrera like '%robó%'

--242206, 76-0187-2022, MAESTRÍA EN INGENIERÍA PARA LA INDUSTRIA, CON ESPECIALIDAD EN ROBÓTICA
--249248, 72-0206-2023, MAESTRIA EN CRIMINOLOGIA MODALIDAD SEMIPRESENCIAL
--249607, 74-0249-2023, MAESTRÍA EN ADMINISTRACIÓN DE NEGOCIOS MODALIDAD NO PRESENCIAL
select * from col_art_archivo_tal_mae_mora where per_codigo = 249248