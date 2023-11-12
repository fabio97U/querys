select * from web_evf_evaluacion_fechas_nueva
select * from web_emm_materias_maes
select * from web_evac_evaluacion_cuestionario
select * from ra_hpl_horarios_planificacion where hpl_codigo = 47576
select GETDATE()
SELECT        evac_codigo, evac_codreg, evac_codevte, evac_codcil, evac_fechacrea, evac_estado
FROM            web_evac_evaluacion_cuestionario


SELECT *--evp_codigo, evp_pregunta, evpc_numero, evte_codigo                     
		FROM web_evp_evaluacion_preguntas 
			JOIN web_evpc_evaluacion_preguntas_cuestionario ON evp_codigo = evpc_codevp
			JOIN web_evac_evaluacion_cuestionario ON evac_codigo = evpc_codevac 
			JOIN web_evte_evaluacion_tipo_eval ON evp_codevte = evte_codigo AND evac_codevte = evte_codigo
		where  --evpc_codevru = @j and 
		evte_codigo = 8 and evac_codcil = 126

		--HECHO
		insert into web_evpc_evaluacion_preguntas_cuestionario (evpc_codreg, evpc_codevp, evpc_codevtr, evpc_codevac, evpc_codevru, evpc_numero)
		SELECT evpc_codreg, evpc_codevp, evpc_codevtr, 19, evpc_codevru, evpc_numero
		FROM web_evp_evaluacion_preguntas 
			JOIN web_evpc_evaluacion_preguntas_cuestionario ON evp_codigo = evpc_codevp
			JOIN web_evac_evaluacion_cuestionario ON evac_codigo = evpc_codevac 
			JOIN web_evte_evaluacion_tipo_eval ON evp_codevte = evte_codigo AND evac_codevte = evte_codigo
		where  --evpc_codevru = @j and 
		evte_codigo = 8 --and evac_codcil = @cil

		select * from web_evpc_evaluacion_preguntas_cuestionario

		--Encabezado
		SELECT * FROM web_eva_evaluacion where eva_cod_cuenta = 227606 and eva_codhpl = 47576
		--Detalle
		select * from web_evr_evaluacion_respuestas where evr_codeva = 233040