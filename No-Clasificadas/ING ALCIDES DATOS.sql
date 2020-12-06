select replace (per_carnet, '-', '') from ra_per_personas 
inner join pg_imp_ins_especializacion on imp_codper = per_codigo
inner join pg_apr_aut_preespecializacion on apr_codigo = imp_codapr
where per_estado in ('E') and per_tipo = 'U'
and substring (per_carnet, 1, 2) in ('60','61','22','38','36','09','34','56')
and apr_codcil in (122, 123)
order by replace (per_carnet, '-', '')

select * from pg_imp_ins_especializacion 
inner join pg_apr_aut_preespecializacion on apr_codigo = imp_codapr
where imp_codper = 181324

select * from ra_car_carreras where car_identificador = '09'