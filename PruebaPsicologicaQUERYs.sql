select * from prb_daa_datos_alumno order by daa_fecha_ing desc
--sp_help prb_daa_datos_alumno
select * from codigo_psico order by daa_fecha_ing desc
--sp_help codigo_psico
select * from prb_daa_datos_alumno_psico 
order by daa_fecha_ing desc

select * from prb_esc_escalas
select * from prb_pre_peguntas where pre_codesc = 2
select * from prb_resp_respuestas
select count(1) from prb_pop_respuesta_cont_psico where pop_coddaa = 'jZWctFEmySQ'

select * from prb_daa_datos_alumno_psico 
order by daa_fecha_ing desc
select top 10 * from prb_crd_carrera_decision_psico inner join prb_res_resultados_psico on res_coddaa = crd_coddaa 
order by crd_fecha desc
select top 10 * from prb_res_resultados_psico order by fecha_
select * from prb_res_psicor_resultados  order by res_psico_fecha desc


select * from prb_crd_carrera_decision_psico where convert(date, crd_fecha , 103) >= '2019-01-01' and convert(date, crd_fecha , 103) <= '2019-06-28'

