--ALUMNOS QUE TIENE EL PROBLEMA
select * from ra_ins_inscripcion
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
inner join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
inner join ra_per_personas on per_codigo = ins_codper
where ins_codcil = 122 and per_tipo = 'M' and mai_codmat <> hpl_codmat and mai_estado = 'I' AND ins_codper = 227630
order by mai_codigo
------------


select * from pla_emp_empleado where emp_codigo = 2767
--luis.alvarez@mail.utec.edu.sv
select * from ra_hpl_horarios_planificacion
where hpl_codmat = 'AFDL-M' and hpl_codcil = 122 and hpl_codigo = 40989

select * from ra_ins_inscripcion
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
inner join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
where ins_codper = 227630
order by mai_codigo
--4946081	INEC-M, 7.4   
--4946082	AFDL-M, tenia que tener la nota, 0
--4946083	MEFI-M, no tenia que tener la nota, pero se le proceso aqui, 6.7 
--4946084	MEVA-M    

select * from ra_not_notas 
where not_codmai in (
4946082,
4946081,
4946083,
4946084
)
order by not_codmai


select * from ra_ins_inscripcion
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
inner join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
where ins_codper = 227630
order by mai_codigo

--4946083, 40990
select * from ra_hpl_horarios_planificacion where hpl_codmat = 'MEFI-M' and hpl_codcil = 122

select * from ra_pom_ponderacion_materia where pom_codmat = 'MEVA-M' and pom_codcil = 122
select * from ra_not_notas 
inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
where not_codmai in (
4946082,
4946081,
4946083,
4946084
)
order by not_codmai

select max(not_codigo) from ra_not_notas
--up-date ra_not_notas set not_nota = 0 where not_codigo = 15202504
--up-date ra_mai_mat_inscritas set mai_codhpl = 40989  where mai_codigo = 4946082
--up-date ra_mai_mat_inscritas set mai_codhpl = 40990  where mai_codigo = 4946083
select * from ra_not_notas where not_codigo = 15202504