select *
--per_carnet 'Carnet', per_apellidos 'Apellidos', per_nombres 'Nombres', npro_nota 'Nota'
from web_pg_innot_ingresosdenotas 
--inner join web_pg_npro_notasprocesadas on npro_codinnot = innot_codingre
--inner join ra_per_personas on per_codigo = npro_alumno
where innot_codemp = 1228 --and npro_codinnot = '701123162122814'
order by innot_Fecha desc--, per_apellidos

select *
from web_pg_innot_ingresosdenotas 
where innot_codemp = 1228 and innot_codingre = '701123162122814'


--upda-te web_pg_innot_ingresosdenotas set innot_codpenot = 13/*ORIGINAL: 14*/ where innot_codemp = 1228 and innot_codingre = '701123162122814'
select emp_email_institucional, * from web_pg_innot_ingresosdenotas 
inner join pla_emp_empleado on innot_codemp = emp_codigo
WHERE --innot_codpenot = 14 and innot_codcil = 123 and 
innot_codingre in (
/*canales lider sec 16 022020*/'701123162122814', 
/*magno lider 01 022020*/'68612301224614', 
/*magno lider 07 022020*/'69212307224614',
/*cerna lider 08 022020*/'69312308277714')
--carlos.pineda@mail.utec.edu.sv
--carlos.pineda@mail.utec.edu.sv
--juan.cerna@mail.utec.edu.sv