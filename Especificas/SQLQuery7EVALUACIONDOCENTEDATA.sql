	select * from web_evte_evaluacion_tipo_eval_nueva where evte_codigo in (25, 26, 27, 28)
	select * from web_evru_evaluacion_rubros_nueva where evru_codevte in (select evte_codigo from web_evte_evaluacion_tipo_eval_nueva where evte_codigo in (25)) and evru_codcil = 119
	
	select * from web_evtr_evaluacion_tipo_respuesta_nueva
	select * from web_evdr_evaluacion_det_res_nueva
	

	select * from web_evp_evaluacion_preguntas_nueva where evp_codevru in(select evru_codigo from web_evru_evaluacion_rubros_nueva where evru_codevte in (select evte_codigo from web_evte_evaluacion_tipo_eval_nueva where evte_codigo in (25)) and evru_codcil = 119)
	
	select * from web_evr_evaluacion_respuestas_nueva where evr_codeva in(select eva_codigo from web_eva_evaluacion_nueva where eva_cod_cuenta = 181324)
	select top 5 * from web_evc_evaluacion_comentarios where evc_codeva in(select eva_codigo from web_eva_evaluacion_nueva where eva_cod_cuenta = 181324)


	select top 3 * from web_evru_evaluacion_rubros_nueva
	select top 3 * from web_evp_evaluacion_preguntas_nueva
	select fac_nombre, fac_codigo from ra_fac_facultades where fac_codigo not in(0,10,16) order by fac_nombre asc

	--Almacena el encabezadp de la encuesta
	select /* eva_codhpl, */ hpl_codmat, hpl_descripcion, /*eva_ctot,*/ evte_descripcion/*, eva_cod_cuenta*/, emp_apellidos_nombres, per_carnet, per_apellidos_nombres, fac_nombre, esc_nombre, car_nombre, evru_codigo, evru_rubro, evp_pregunta, evdr_detalle, concat('( 0',cil_codcic, ' - ', cil_anio, ' )') 'ciclo'
	from web_eva_evaluacion_nueva 
	inner join web_evr_evaluacion_respuestas_nueva on eva_codigo = evr_codeva
	inner join web_evp_evaluacion_preguntas_nueva on evp_codigo = evr_codevp
	inner join web_evdr_evaluacion_det_res_nueva on evdr_codigo = evr_codevdr
	inner join web_evru_evaluacion_rubros_nueva on evru_codigo = evr_codevru
	inner join web_evte_evaluacion_tipo_eval_nueva on evte_codigo = eva_codevte
	inner join ra_per_personas on per_codigo = eva_cod_cuenta
	inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
	inner join ra_pla_planes on pla_codigo = alc_codpla
	inner join ra_car_carreras on car_codigo = pla_codcar
	inner join ra_esc_escuelas on esc_codigo = car_codesc
	inner join ra_fac_facultades on fac_codigo = esc_codfac
	inner join ra_hpl_horarios_planificacion on hpl_codigo = eva_codhpl
	inner join ra_mat_materias on mat_codigo = hpl_codmat
	inner join pla_emp_empleado on emp_codigo = hpl_codemp
	inner join ra_cil_ciclo on cil_codigo = eva_codcil
	where/* eva_cod_cuenta = 181324 and */eva_codcil = 119 and fac_codigo = 6  --107
	and evte_codigo = 25
	order by emp_apellidos_nombres asc, hpl_codmat asc, evru_rubro asc, evp_pregunta asc

	select '*Seleccione*' 'fac_nombre', 0 'fac_codigo' union select fac_nombre, fac_codigo from ra_fac_facultades where fac_codigo not in(0,10,16) order by fac_codigo asc

select top 25 cil_codigo, '0' + (SELECT CAST(cil_codcic AS varchar) + ' - ' + CAST(cil_anio as varchar)) AS Ciclo from ra_cil_ciclo join ra_cic_ciclos on cic_codigo = cil_codcic order by cil_vigente desc, cil_anio desc
	select * from web_evc_evaluacion_comentarios_nueva 
	where evc_codeva in(select eva_codigo from web_eva_evaluacion_nueva where eva_cod_cuenta = 182420/* and eva_codhpl = 20243*/)

	select top 3 * from web_evdr_evaluacion_det_res_nueva
	select top 3 * from web_evtr_evaluacion_tipo_respuesta_nueva