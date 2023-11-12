--1.	Enlistar con número de carnet, nombre completo, carrera  y correo electrónico de los 278 estudiantes que poseen menos de 250 horas sociales.
-- exec dbo.sp_estimado_egresados 2, 129, 0 -- Posibles egresados incluyendo el inter ciclo si es ciclo impar
--2.	Enlistar cuántos alumnos solicitaron carta de egresado en el 01 y 02-2022 y que no se han inscrito en la pre especialización (los mismos datos del numeral 1).
select pla_alias_carrera 'Carrera', per_carnet 'Carnet', per_apellidos_nombres 'Estudiante', per_correo_institucional 'Correo institucional', per_email 'Correo personal' 
from ra_regr_registro_egresados 
	inner join ra_per_personas on per_codigo = regr_codper
	inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
	inner join ra_pla_planes on alc_codpla = pla_codigo
where year(regr_fecha) = 2022
and per_codigo not in (
select distinct imp_codper from pg_imp_ins_especializacion
union all
select distinct rte_codper from ra_rte_registro_tecnicos_egresados
)

--3.	Detalle de alumnos egresados en el 2021 y que no se han inscrito en la pree especialización o técnicos (los mismos datos del numeral 1).
select pla_alias_carrera 'Carrera', per_carnet 'Carnet', per_apellidos_nombres 'Estudiante', per_correo_institucional 'Correo institucional', per_email 'Correo personal' 
from ra_regr_registro_egresados 
	inner join ra_per_personas on per_codigo = regr_codper
	inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
	inner join ra_pla_planes on alc_codpla = pla_codigo
where year(regr_fecha) = 2021
and per_codigo not in (
select distinct imp_codper from pg_imp_ins_especializacion
union all
select distinct rte_codper from ra_rte_registro_tecnicos_egresados
)

--4.	Detalle de alumnos que se inscribieron en la pre de marzo y agosto 2022 y que se hayan retirado (los mismos datos del numeral 1).
select pla_alias_carrera 'Carrera', per_carnet 'Carnet', per_apellidos_nombres 'Estudiante', per_correo_institucional 'Correo institucional', per_email 'Correo personal' from pg_imp_ins_especializacion
	inner join ra_per_personas on per_codigo = imp_codper
	inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
	inner join ra_pla_planes on alc_codpla = pla_codigo
where year(imp_fecha_ingreso) = 2022 and imp_estado not in ('I')