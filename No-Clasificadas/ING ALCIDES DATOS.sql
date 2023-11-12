--PREGRADO
select distinct replace (per_carnet, '-', '') from ra_per_personas 
inner join ra_ins_inscripcion on ins_codper = per_codigo
where per_estado in ('A') and per_tipo = 'U'
and substring (per_carnet, 1, 2) in ('60','61','22','38','36','09','34','56')
and ins_codcil in (131)
order by replace (per_carnet, '-', '')
--PRE
select distinct replace (per_carnet, '-', '') from ra_per_personas 
inner join pg_imp_ins_especializacion on imp_codper = per_codigo
inner join pg_apr_aut_preespecializacion on apr_codigo = imp_codapr
where per_estado in ('E') and per_tipo = 'U'
and substring (per_carnet, 1, 2) in ('60','61','22','38','36','09','34','56')
and apr_codcil in (130)
order by replace (per_carnet, '-', '')

--Docentes pregrado
select distinct emp_email_institucional from ra_hpl_horarios_planificacion 
inner join ra_esc_escuelas on hpl_codesc = esc_codigo
inner join pla_emp_empleado on hpl_codemp = emp_codigo
where hpl_codcil = 131 and hpl_codesc in (9,6,4)

--Docentes preespecialidad
select distinct emp_email_institucional from pg_pre_preespecializacion 
inner join pg_mpr_modulo_preespecializacion on mpr_codpre = pre_codigo
inner join pg_hmp_horario_modpre on hmp_codmpr = mpr_codigo
inner join pla_emp_empleado on hmp_codcat = emp_codigo
where pre_codcil in (130, 131) and hmp_codfac = 8

select * from pg_imp_ins_especializacion 
inner join pg_apr_aut_preespecializacion on apr_codigo = imp_codapr
where imp_codper = 181324

select * from ra_car_carreras where car_identificador in ('60','61','22','38','36','09','34','56')