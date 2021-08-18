
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

select a.*, (
select count(1) from ra_ins_inscripcion 
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
inner join ra_not_notas on not_codmai = mai_codigo
inner join ra_pom_ponderacion_materia on not_codpom = pom_codigo
where ins_codper = a.per_codigo and ins_codcil = 125 and pom_codpon = 5 and not_nota = 0
) 'sin_nota_5ta' from @tbl_pagos a
inner join ra_per_personas p on p.per_codigo = a.per_codigo
where Cuota5 = 0 or Cuota6 = 0 and per_estado not in ('E')