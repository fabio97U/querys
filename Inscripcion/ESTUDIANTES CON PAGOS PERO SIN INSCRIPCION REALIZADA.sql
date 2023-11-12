declare @tbl_pagos as table 
(per_codigo int, per_carnet varchar(20), per_nombres varchar(125), 
matricula int, cuota1 int, cuota2 int, cuota3 int, cuota4 int, cuota5 int, cuota6 int,
ing_nombre varchar(50), carrera varchar(255), fac_nombre varchar(50), contador int
)
insert into @tbl_pagos
exec col_pagos_por_alumno_pivot2 2, 128	--	util

--TARDA DEMASIADOS
select * from @tbl_pagos t where (matricula + cuota1 + cuota2 + cuota3 + cuota4 + cuota5 + cuota6) >= 2
and t.per_codigo not in (
	select distinct v.per_codigo from ra_vst_aptde_AlumnoPorTipoDeEstudio v where v.ins_codcil = 128
)