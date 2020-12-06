declare @data as table (anio_ingreso int, identificador_carrera int, carrera varchar(255), cantidad int)
insert into @data
select SUBSTRING(per_carnet, 9, 4) 'anio_ingreso', 
SUBSTRING(per_carnet, 1, 2) 'identificador_carrera', car_nombre, 1 'cantidad' 
from ra_vst_aptde_AlumnoPorTipoDeEstudio as vst
where tde_codigo = 1 and ins_codcil = 122 and vst.per_tipo = 'U'
--735
--select concat('Año ', anio_ingreso) anio_ingreso, identificador_carrera, carrera, sum(cantidad) 'inscritos' 
--from @data
--where anio_ingreso >= 2015
--group by anio_ingreso, identificador_carrera, carrera
--order by anio_ingreso desc
--union all
select 'Antes de 2015' anio_ingreso, identificador_carrera, carrera, sum(cantidad) 'inscritos' 
from @data
where anio_ingreso < 2015
group by identificador_carrera, carrera