--OPU-H
--SEMI-H
--select * from pla_tpl_tipo_planilla
--select * from ra_hpl_horarios_planificacion WHERE hpl_codmat = 'SEMI-H' AND hpl_codcil = 125--01
--select * from ra_hpl_horarios_planificacion WHERE hpl_codmat = 'OPPU-H' AND hpl_codcil = 125--02
--select * from pla_hort_emp_trabajadas where HorT_codpla = 202106 AND hort_codmat IN ('OPU-H', 'SEMI-H')

insert into pla_hort_emp_trabajadas 
(HorT_codigo, HorT_codreg, HorT_codemp, HorT_codtpl, HorT_codpla, HorT_codcil, HorT_horastrabajadas, HorT_horasreales, hort_codmat, 
hort_valor_hora, hort_codtdc, hort_valor_descuento, hort_codfac, hort_valor_hora_practica, hort_horasreales_practica, 
hort_solvencia_normal, hort_solvencia_extraordinaria, hort_codhpl, hort_fecha_crea, hort_codusr_crea, hort_codmod)
values ((select max(hort_codigo) + 1 from pla_hort_emp_trabajadas), 1, 3164, 27, 202106, 125, 0, 0, 'DENO-D', 
0, NULL, NULL, NULL, NULL, NULL, 0, 0, 45774, getdate(), 407, NULL)