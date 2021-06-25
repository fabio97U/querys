select * from web_evf_evaluacion_fechas_nueva where evf_codigo in (177, 178)

select * from web_eva_evaluacion_nueva where eva_codcil = 125 order by eva_codigo desc
select top 25 * from web_evru_evaluacion_rubros_nueva order by evru_codigo desc
select top 25 * from web_evac_evaluacion_cuestionario_nueva order by evac_codigo desc
select top 25 * from web_evp_evaluacion_preguntas_nueva where evp_pregunta like '%clim%' order by evp_codigo desc

select top 25 * from web_evpc_evaluacion_preguntas_cuestionario_nueva order by evpc_codigo desc

select top 10 * from web_eva_evaluacion_nueva order by eva_codigo desc
select top 10 * from web_evr_evaluacion_respuestas_nueva order by evr_codigo desc
select top 10 * from web_evc_evaluacion_comentarios_nueva where evc_comentario != '' order by evc_codigo desc

--insert into web_evf_evaluacion_fechas_nueva (evf_codcil, evf_fechaini, evf_fechafin, evf_tipo)
--values (125, '2021-04-21', '2021-05-02', 'P')
--insert into web_evf_evaluacion_fechas_nueva (evf_codcil, evf_fechaini, evf_fechafin, evf_tipo)
--values (125, '2021-04-21', '2021-05-02', '13')