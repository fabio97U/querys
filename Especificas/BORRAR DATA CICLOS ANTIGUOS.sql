declare @codcil_solvente int = 126, @codcil_generar int = 128
declare @tbl_pagos as table (
	per_codigo int, per_carnet varchar(50),
	per_nombres_apellidos varchar(201), Matricula int,
	Cuota1 int, Cuota2 int, Cuota3 int, Cuota4 int, Cuota5 int, Cuota6 int,
	ing_nombre varchar(50), carrera varchar(250), fac_nombre varchar(70), contador int
)
DECLAre @aptos as table (codper int)

insert into @tbl_pagos
exec dbo.col_pagos_por_alumno_pivot2 2, @codcil_solvente

-- Borrar la data vieja a los estudiantes solventes con boletas el ciclo a @codcil_generar
--DELETE
select * from col_art_archivo_tal_mora where per_codigo in (
	select per_codigo from @tbl_pagos
	where (Matricula + Cuota1 + Cuota2 + Cuota3 + Cuota4 + Cuota5 + Cuota6) >= 7 and per_codigo in (
		select distinct a.per_codigo from col_art_archivo_tal_mora a where a.ciclo = @codcil_generar
	)
) and ciclo not in (@codcil_generar)

-- Borra la data vieja de los estudiantes con data en el @codcil_solvente
--DELETE
select * from col_art_archivo_tal_mora where per_codigo in (
	select per_codigo from @tbl_pagos
) and ciclo not in (@codcil_solvente, @codcil_generar)