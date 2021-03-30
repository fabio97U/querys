exec web_ptl_notas_pre_esp 182844

select * from pg_imp_ins_especializacion where imp_codper = 182844
select * from pg_nmp_notas_mod_especializacion where nmp_codimp =26688
select * from pg_nmp_notas_mod_especializacion where nmp_codigo = 213355
update pg_nmp_notas_mod_especializacion set nmp_codimp = 26688 /*ORIGINAL: 26688*/ where nmp_codigo = 213355

select * from pg_ih_imp_hmp where ih_codimp = 26688