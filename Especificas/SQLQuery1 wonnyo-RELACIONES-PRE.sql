exec web_ptl_notas_pre_esp 181324
exec web_ptl_notas_pre_esp 173047

--181324
--173047

select *--@pre_nombre = pre_nombre 
from ra_per_personas 
inner join pg_imp_ins_especializacion ON imp_codper = per_codigo 
inner join pg_mpr_modulo_preespecializacion ON imp_codmpr=mpr_codigo 
inner join pg_pre_preespecializacion ON pre_codigo = mpr_codpre 
WHERE ra_per_personas.per_codigo = 181324 and imp_estado <> 'R'











select * from pg_imp_ins_especializacion where imp_codper = 181324--FABIO
select * from pg_imp_ins_especializacion where imp_codper = 173047--WONNYO

select * from pg_mpr_modulo_preespecializacion where mpr_codigo = 4266

select * from pg_apr_aut_preespecializacion where apr_codigo = 586

select * from ra_pgc_pre_esp_carrera where pgc_codpre = 682