declare @inscritos_022020 as table 
(
codper int, carnet varchar(16), 
nombre varchar(125),
num_materias_carrera int, num_materias_apro int, 
inscritas int, carrera varchar(255),
car_identificador varchar(5)
)
insert into @inscritos_022020 
(codper, carnet, nombre, num_materias_carrera, num_materias_apro, inscritas, carrera, car_identificador)
select --distinct 
--top 30
per.per_codigo, per.per_carnet, per.per_nombres_apellidos, pla.pla_n_mat 'num_materias_carrera', dbo.mat_gral_apro(per.per_codigo) 'num_materias_apro', 
count(1) 'inscritas',
car_nombre, substring(per.per_carnet, 1, 2)
from ra_vst_aptde_AlumnoPorTipoDeEstudio as vst
inner join ra_per_personas per on per.per_codigo = vst.per_codigo
join ra_mai_mat_inscritas on mai_codins = ins_codigo 

join ra_alc_alumnos_carrera on alc_codper = per.per_codigo
join ra_pla_planes pla on pla.pla_codigo = alc_codpla

where tde_codigo = 1 and ins_codcil = 123 and vst.per_tipo = 'U' and per.per_estado = 'A' and mai_estado <> 'R'
--and per.per_codigo = 173386
group by per.per_codigo, per.per_carnet, per.per_nombres_apellidos, pla.pla_n_mat, car_nombre

select codper, car_identificador 'Cód', carrera 'Carrera', carnet 'Carnet', nombre 'Alumno', 
num_materias_apro 'Materias aprobadas', inscritas 'Inscritas 02-2020', num_materias_carrera 'Materias-Carrera'
from @inscritos_022020 --where codper = 173057
where (num_materias_apro + inscritas) >= num_materias_carrera
order by car_identificador, carrera, nombre