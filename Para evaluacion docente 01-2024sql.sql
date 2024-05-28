
-- exec web_ceed_crear_evaluacion_estudiantil_docente_emergencia 1, 1, 0, 134, 11 -- Copia la encuesta "@codenc_copiar" para el ciclo "@codcil_encuesta_destino"
-- exec web_ceed_crear_evaluacion_estudiantil_docente_emergencia 1, 1, 0, 134, 12 -- Copia la encuesta "@codenc_copiar" para el ciclo "@codcil_encuesta_destino"
-- exec web_ceed_crear_evaluacion_estudiantil_docente_emergencia 1, 1, 0, 134, 13 -- Copia la encuesta "@codenc_copiar" para el ciclo "@codcil_encuesta_destino"

exec dbo.sp_data_emer_encuestas 1, 14--carrera presencial con aula fisica
exec dbo.sp_data_emer_encuestas 1, 15--carrera presencial en TEAMS
exec dbo.sp_data_emer_encuestas 1, 16--carrera presencial en BLACKBOARD

select * from emer_enc_encuestas

select * from emer_encenc_encabezado_encuesta where encenc_codenc in (14, 15, 16)
select * from emer_detenc_detalle_encuesta where detenc_codencenc in (183316)

select * from emer_enc_encuestas where enc_fecha_creacion > '2024-05-14'
--dbcc checkident (emer_enc_encuestas, reseed, 9)

select * from emer_grupe_grupos_estudio where grupe_fecha_creacion > '2024-05-14'
--dbcc checkident (emer_grupe_grupos_estudio, reseed, 44)

select * from emer_pre_preguntas where pre_fecha_creacion > '2024-05-14'
--dbcc checkident (emer_pre_preguntas, reseed, 300)

select * from emer_opc_opciones where opc_fecha_creacion > '2024-05-14'
--dbcc checkident (emer_opc_opciones, reseed, 175)

select * from emer_preopc_preguntas_opciones where preopc_fecha_creacion > '2024-05-14'
--dbcc checkident (emer_preopc_preguntas_opciones, reseed, 930)

select * from web_evte_evaluacion_tipo_eval_nueva
select *  from web_eva_evaluacion_nueva