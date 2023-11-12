--leydi.dominguez
--kevin.rosa
--stefanie.miranda
--select * from ra_tde_TipoDeEstudio
select row_number() over(PARTITION BY ins_usuario_creacion order by ins_codigo) 'Num', v.tde_nombre 'Tipo estudio', CONCAT('0', cil_codcic, '-', cil_anio) 'Ciclo', 
convert(nvarchar(10), ins_fecha_creacion, 103) 'Fecha Matriculación', 
v.per_carnet 'Carnet', v.per_nombres 'Nombres', v.per_apellidos 'Apellidos', car_nombre 'Programa', 
case when v.per_estado = '0' then 'I' else v.per_estado end 'Estado',
ins_usuario_creacion 'usuario_matriculo'
from ra_vst_aptde_AlumnoPorTipoDeEstudio v
inner join ra_cil_ciclo on ins_codcil = cil_codigo
inner join ra_per_personas p on p.per_codigo = v.per_codigo
where v.tde_codigo in (2, 3, 4)
--and ins_usuario_creacion in (/*'leydi.dominguez',*/ 'kevin.rosa', 'stefanie.miranda')
and ins_usuario_creacion not in ('ins_enlinea')
--and year(ins_fecha_creacion) = 2020 and MONTH(ins_fecha_creacion) in (1,2,3,4,5,6)
and convert(date, ins_fecha_creacion, 103) between '20210601' and '20220130'
and convert(date, per_fecha_ingreso, 103) between '20210601' and '20220130'
and p.per_codcil_ingreso = ins_codcil
--and per_codigo = 231898
--and ins_codcil = 125
order by ins_usuario_creacion, ins_codigo