select * from Tbl_Alumnos_Aptos_Inscribir

declare @tbl_pagos as table (
	per_codigo int,
	per_carnet varchar(50),
	per_nombres_apellidos varchar(201),
	Matricula int,
	Cuota1 int,
	Cuota2 int,
	Cuota3 int,
	Cuota4 int,
	Cuota5 int,
	Cuota6 int)
insert into @tbl_pagos
exec dbo.col_pagos_por_alumno_pivot2 2, 125

insert into Tbl_Alumnos_Aptos_Inscribir (codper)
select per_codigo from @tbl_pagos
where (Matricula + Cuota1 + Cuota2 + Cuota3 + Cuota4 + Cuota5 + Cuota6) >= 7
AND per_codigo not in (select codper from Tbl_Alumnos_Aptos_Inscribir)

--select * from PAGOS_125_BORRAME