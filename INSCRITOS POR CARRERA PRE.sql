--15, 14, 14, 49, 15
select row_number() over (partition by mpr_nombre order by per_carnet) num,
per_carnet, per_apellidos, per_nombres, mpr_nombre
from pg_imp_ins_especializacion
inner join pg_apr_aut_preespecializacion on apr_codigo = imp_codapr
inner join ra_per_personas on per_codigo = imp_codper
inner join pg_mpr_modulo_preespecializacion on mpr_codigo = imp_codmpr
where apr_codcil = 122 and substring(per_carnet, 1, 2) = '25'--and imp_codmpr = 4263
--and imp_codper = 182844
--order by mpr_nombre, per_apellidos