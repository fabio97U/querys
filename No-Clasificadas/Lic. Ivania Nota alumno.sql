select top 10 * from web_pg_innot_ingresosdenotas 
where innot_codemp = 4472 --and innot_codingre = '59712201344725'
order by innot_Fecha desc

select * from web_pg_npro_notasprocesadas where npro_codinnot = '59712201344725'
 
 select * from pg_imp_ins_especializacion where imp_codper in (163932, 118027)
 select * from pg_nmp_notas_mod_especializacion where nmp_codimp = 26691
 select * from pg_nmp_notas_mod_especializacion where nmp_codimp = 26910
 --update pg_nmp_notas_mod_especializacion set nmp_nota = 8.2 where nmp_codigo = 214572

--insert into web_pg_npro_notasprocesadas (npro_evaluado, npro_nota, npro_alumno, npro_codinnot)
--values (1, 8.2, 118027, '59712201344725')

select * from pla_emp_empleado where emp_codigo = 4472      
--norma.marroquin@mail.utec.edu.sv