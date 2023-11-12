SELECT ROW_NUMBER() OVER(ORDER BY car_identificador ASC) N, car_identificador 'Código de Carrera', car_nombre 'Nombre de Carrera',
	per_apellidos_nombres 'Apellidos, Nombres', per_sexo Sexo, REPLACE(per_dui, '-', '') DUI, 
	--floor(
	--	(cast(convert(varchar(8),getdate(),112) as int)-
	--	cast(convert(varchar(8),per_fecha_nac,112) as int) ) / 10000
	--) EDAD, --
	per_fecha_nac 'Fecha de nacimiento',
	IIF(per_discapacidad = '0', 0, 1) 'Tiene Discapacidad', IIF(per_discapacidad = '0', '', per_discapacidad) 'Tipo de Discapacidad',
	'' Observaciones, per_fecha_ingreso 'Fecha de ingreso IES', 
	CASE WHEN ing_codigo = 1 THEN 1 WHEN ing_codigo = 5 THEN 2 WHEN ing_codigo = 4 THEN 3 ELSE 2 END 'Tipo de Ingreso'--, per_carnet, CONVERT(nvarchar, per_fecha_nac, 103)
	,'Estudiante' 'Tipo', esc_nombre, fac_nombre
FROM
(
	SELECT
		car_identificador, car_nombre,
		per_apellidos_nombres, per_sexo, per_dui, per_fecha_nac, 
		CASE WHEN per_discapacidad like '%INGUN%' THEN '0'
			WHEN per_discapacidad like '%ni una%' THEN '0'
			WHEN UPPER(REPLACE(TRIM(per_discapacidad), '.', '')) = 'NO' or SUBSTRING(per_discapacidad, 1, 3) = 'NO '
				or per_discapacidad = 'N/A' or ISNULL(per_discapacidad, '') = '' or LEN(REPLACE(TRIM(per_discapacidad), '.', '')) <= 3 THEN '0'
			WHEN per_discapacidad like '%POR EL MOMENTO NO%' THEN '0'
			WHEN per_discapacidad like '%NO %POSE%' THEN '0'
			ELSE per_discapacidad 
		END per_discapacidad, ing_codigo, per_carnet, per_fecha_ingreso, '' per_nie, esc_nombre, fac_nombre
	FROM ra_per_personas
		INNER JOIN ra_alc_alumnos_carrera ON alc_codper = per_codigo
		INNER JOIN ra_pla_planes ON pla_codigo = alc_codpla
		INNER JOIN ra_car_carreras ON car_codigo = pla_codcar
		INNER JOIN ra_ing_ingreso ON ing_codigo = per_tipo_ingreso
		--INNER JOIN ra_gra_graduados ON gra_codper = per_codigo
		INNER JOIN ra_ins_inscripcion ON ins_codper = per_codigo
		INNER JOIN ra_fac_facultades ON fac_codigo = car_codfac
		inner join ra_esc_escuelas on car_codesc = esc_codigo
	WHERE ins_codcil = 130-- per_tipo = 'U' and per_estado = 'G'-- and per_codigo = 224036
) T
	
	union all

SELECT ROW_NUMBER() OVER(ORDER BY car_identificador ASC) N, car_identificador 'Código de Carrera', car_nombre 'Nombre de Carrera',
	per_apellidos_nombres 'Apellidos, Nombres', per_sexo Sexo, REPLACE(per_dui, '-', '') DUI, 
	--floor(
	--	(cast(convert(varchar(8),getdate(),112) as int)-
	--	cast(convert(varchar(8),per_fecha_nac,112) as int) ) / 10000
	--) EDAD, --
	per_fecha_nac 'Fecha de nacimiento',
	IIF(per_discapacidad = '0', 0, 1) 'Tiene Discapacidad', IIF(per_discapacidad = '0', '', per_discapacidad) 'Tipo de Discapacidad',
	'' Observaciones, per_fecha_ingreso 'Fecha de ingreso IES', 
	CASE WHEN ing_codigo = 1 THEN 1 WHEN ing_codigo = 5 THEN 2 WHEN ing_codigo = 4 THEN 3 ELSE 2 END 'Tipo de Ingreso'--, per_carnet, CONVERT(nvarchar, per_fecha_nac, 103)
	,'Maestro' 'Tipo', esc_nombre, fac_nombre
FROM
(
	SELECT distinct
		'' car_identificador, '' car_nombre,
		emp_nombres_apellidos per_apellidos_nombres, emp_sexo per_sexo, emp_dui per_dui, emp_fecha_nac per_fecha_nac, 
		'' per_discapacidad, 0 ing_codigo, emp_codigo per_carnet, emp_fecha_ingreso_puesto per_fecha_ingreso, '' per_nie, esc_nombre, fac_nombre
	FROM ra_hpl_horarios_planificacion
		inner join pla_emp_empleado on hpl_codemp = emp_codigo
		inner join ra_esc_escuelas on hpl_codesc = esc_codigo
		inner join ra_fac_facultades on esc_codfac = fac_codigo
	where hpl_codcil = 130
) T

