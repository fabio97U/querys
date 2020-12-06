--select * from ra_tde_TipoDeEstudio
select row_number() over(order by ins_codigo) 'Num', convert(nvarchar(10), ins_fecha_creacion, 103) 'Fecha Matriculación', 
per_carnet 'Carnet', per_nombres 'Nombres', per_apellidos 'Apellidos', car_nombre 'Programa', 
case when per_estado = '0' then 'I' else per_estado end 'Estado'
from ra_vst_aptde_AlumnoPorTipoDeEstudio 
where tde_codigo in (2/*3, 6*/)
and ins_usuario_creacion in (/*'leydi.dominguez',*/ 'leydi.dominguez')
--and year(ins_fecha_creacion) = 2020 and MONTH(ins_fecha_creacion) in (1,2,3,4,5,6)
and convert(date, ins_fecha_creacion, 103) between '20191201' and '20200801'
order by ins_codigo

