
	select
	emp_nombres_apellidos, isnull(emp_email_institucional, '') 'emp_email_institucional', 
	isnull(emp_email_empresarial, '') emp_email_empresarial, isnull(emp_email, '') emp_email
	,  isnull(plz_nombre, 'Sin Contratar') plaza,
	tem_nombre, tem_codigo
	emp_codigo,emp_codigo_anterior, emp_apellidos_nombres emp_nombres_apellidos,
	case when emp_estado = 'A' then 'Activo' 
	when emp_estado = 'O' then 'Oferente' 
	when emp_estado = 'S' then 'Suspendido'
	when emp_estado = 'R' then 'Retirado' end estado,
	isnull(dbo.fn_fecha_caracter(emp_fecha_ingreso),'') fecha_ingreso,
	plz_codigo, isnull(uni_nombre,'') uni_nombre
	, emp_tmp_cargo_formal, tem_nombre, tem_codigo
	from pla_emp_empleado
	left outer join pla_plz_plaza on plz_codigo = emp_codplz
	left outer join pla_uni_unidad on uni_codigo = plz_coduni
	left join pla_tem_tipo_empleado on tem_codigo = emp_codtem
	where emp_codreg = 1 and emp_estado in ('A', 'J') and tem_codigo in (1, 3, 4) --and emp_codigo in(3318, 2012, 1156, 14)
	
--1326
--1	Administrativo
--3	DTC
--4	DHC