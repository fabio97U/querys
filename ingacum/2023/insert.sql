select * from pla_emp_empleado where emp_dui like '%0180517%'
select * from pla_emp_empleado where emp_dui = '01799298-3'
select * from pla_emp_empleado where emp_nombres_apellidos like '%ENIT%' and emp_nombres_apellidos like '%MENL%'
--MEDRANO MEJIA KAREN MARITZA
--ANGULO BENITEZ ERIKA CARMENLINA
 
-- drop table ingacum_borrar
create table ingacum_borrar (num int, dui_nit varchar(50), empleado varchar(150), codigoingreso varchar(10), Suma_Aguinaldo_exento_910 real, Suma_de_Aguinaldo_Gravado_910 real, Monto_devengado real, Indemnizacion real,Suma_de_AFP_CONFIA real, Suma_de_ISSS_910 real, Suma_de_AFP_CRECER real, Suma_Renta real, Suma_de_IPSFA_910 real, Suma_de_PENSIÓN_ISSS_910 real)

update ingacum_borrar set dui_nit = replace(dui_nit, '''', '')

--update ingacum_borrar set dui_nit = replace(dui_nit, '-', '')
-- select * from ingacum_borrar
select * from pla_emp_empleado where emp_dui = '01937631-1'
--Con este JOIN TIENE QUE DAR LA MISMA CANTIDAD DE 
select i.*, emp_codigo from ingacum_borrar i--1,429
	left join pla_emp_empleado on --1,429
		replace(emp_dui , '-', '') = replace(dui_nit, '-', '') or replace(emp_nit , '-', '') = replace(dui_nit, '-', '')
where isnull(emp_codigo, 0) not in (2987, 768, 2942, 48, 2987, 2089)
order by num

--Problemas:
--1: Empleados con mas de un registro en BD
----Este select tiene que devolver vacio, sino varificar los registros que salen con "num"
select num, dui_nit, count(1) from ingacum_borrar--1,786
	left join pla_emp_empleado on --emp_apellidos_nombres = empleado--No encontrados 616
		replace(emp_dui , '-', '') = dui_nit or replace(emp_nit , '-', '') = dui_nit --and emp_apellidos_nombres not like '%utili%'
			--and emp_codigo not in (2345, 2942, 706, 2089, 2987, 768, 48, 4370)
where isnull(emp_codigo, 0) not in (768, 2942, 48, 2089, 1852, 2119, 4369)/*empleados con registros multiples en la emp*/
group by num, dui_nit
having count(1) > 1

--2: Empleados no encontrados
--select emp_codigo, i.*
--from ingacum_borrar i--1,428
--	left join pla_emp_empleado on --1,428
--		replace(emp_dui , '-', '') = replace(dui_nit, '-', '') or replace(emp_nit , '-', '') = replace(dui_nit, '-', '')
--where isnull(emp_codigo, 0) not in (768, 2942, 48, 2089, 1852, 2119, 4369)/*empleados con registros multiples en la emp*/
--and emp_codigo is null
--order by num
--Fin

-- select * from plan_ingacum where anio = 2023 and indemnizacion > 0
declare @anio int = 2023
--insert into plan_ingacum 
--(uniNombre, codreg, planilla, codemp, nit, nombre, salario, aguinaldo, vacacion, indemnizacion, bonificacion, renta, isss, afp, ipsfa, 
--ivm, anio, codtpl, mes, pla_codtpl, pla_codigo, pla_frecuencia, aguinaldog, otros, codigoingreso, excedente, otrosgrava, 
--montogravado1, renta1, afp1, montogravado2, renta2, afp2, montogravado3, renta3, afp3, montogravado4, renta4, afp4, 
--montogravado5, renta5, afp5, montogravado6, renta6, afp6, montogravado7, renta7, afp7, montogravado8, renta8, afp8, 
--montogravado9, renta9, afp9, montogravado10, renta10, afp10, montogravado11, renta11, afp11, montogravado12, renta12, afp12, fechahora)

select 'UNIVERSIDAD TECNOLOGICA DE EL SALVADOR', 1, null, 
emp_codigo, dui_nit, i.empleado, Monto_devengado, Suma_de_Aguinaldo_Gravado_910, 0, Indemnizacion,  0, Suma_Renta, Suma_de_ISSS_910, 
Suma_de_AFP_CONFIA + Suma_de_AFP_CRECER, Suma_de_IPSFA_910, Suma_de_PENSIÓN_ISSS_910, @anio, 0, NULL, NULL, NULL, NULL, Suma_Aguinaldo_exento_910, 0, codigoingreso, NULL, NULL, 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',  '0', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',  '0', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',  '0',  getdate()
from ingacum_borrar i--1,428
	left join pla_emp_empleado on --1,428
		replace(emp_dui , '-', '') = replace(dui_nit, '-', '') or replace(emp_nit , '-', '') = replace(dui_nit, '-', '')
where isnull(emp_codigo, 0) not in (768, 2942, 48, 2089, 1852, 2119, 4369)/*empleados con registros multiples en la emp*/
and emp_codigo =2
order by num

