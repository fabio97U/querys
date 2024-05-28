declare @carrera varchar(5) = '68', @anio_ingreso varchar(4) = '2022'
select per_codigo, per_carnet, per_nombres_apellidos, '02_2022' 'ciclo', dbo.fn_cum_ciclo(per_codigo, 129) 'cum 022022' 
from ra_per_personas 
where per_carnet like @carrera+'-%' and per_carnet like '%-'+@anio_ingreso 
and per_codigo in (
	select ins_codper from ra_ins_inscripcion where ins_codcil in (129)
)
select per_codigo, per_carnet, per_nombres_apellidos, '01_2023' 'ciclo', dbo.fn_cum_ciclo(per_codigo, 130) 'cum 012023'  
from ra_per_personas 
where per_carnet like @carrera+'-%' and per_carnet like '%-' +@anio_ingreso
and per_codigo in (
	select ins_codper from ra_ins_inscripcion where ins_codcil in (130)
)
--carnet, ciclo, cum