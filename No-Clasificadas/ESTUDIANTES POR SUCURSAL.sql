declare @tbl as table (lugar_proc int, matricula varchar(255))
insert into @tbl
values (1, 'Nuevo Ingreso'), 
(2, 'Metrocentro'), 
(3, 'Plaza Mundo'), 
(4, 'Centro de Soluciones')

select 
pla_alias_carrera, per_carnet, per_nombres_apellidos, per_email, per_correo_institucional, per_telefono, per_celular, per_nota_paes, per_codusr_creacion,
usr_usuario, matricula
from ra_per_personas
inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
inner join ra_pla_planes on alc_codpla = pla_codigo
inner join adm_usr_usuarios on per_codusr_creacion = usr_codigo
inner join @tbl on per_lugar_proc = lugar_proc
where SUBSTRING(per_carnet, 1, 2) in ('02', '03', '29') and per_codcil_ingreso = 128
order by per_codigo

select * from ra_ins_inscripcion
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
where mai_codhpl = 48070
order by mai_codigo
select * from (
select (hpl_max_alumnos - Inscritos) 'Dif', * from ra_hpl_horarios_planificacion_v_din 
where hpl_codcil = 128 and hpl_tipo_materia = 'P' and hpl_codaul not in (160, 260)
) t
where t.Dif != -1

update ra_hpl_horarios_planificacion set hpl_max_alumnos = hpl_max_alumnos - 1
where hpl_codigo in (
47820, 48167, 48919, 49182, 47769, 47775, 48161, 48232, 48257, 48304, 48477, 48679, 48713, 48754, 48826, 48405, 48442, 48484, 48497, 48808, 49004, 49030, 49162, 47827, 48263, 48288, 48433, 47798, 47847, 48172, 48226, 48445, 48491, 48957, 49170, 49280, 47799, 47950, 48014, 48099, 48370, 48409, 48437, 48866, 48985, 49175, 49279, 47752, 47773, 47802, 47810, 48200, 48326, 48391, 47812, 48239, 48301, 48362, 48680, 48691, 48701, 49010, 49056, 49168, 49174, 49281, 47770, 48373, 48378, 48987, 49001, 49019, 49157, 49166, 49277, 47750, 48024, 48076, 48269, 48388, 48676, 48734, 47793, 47965, 48022, 48281, 48340, 48419, 48871, 48963, 49043, 47748, 47749, 47788, 48047, 48107, 48198, 48343, 48853, 48876, 48932, 48947, 48951, 48981, 49046, 49167, 49177, 49179, 47753, 47757, 47801, 47995, 48176, 48217, 48331, 48360, 48436, 48962, 49324, 48371, 48770, 48837, 48965, 48975, 48999, 49088, 49323, 47760, 47768, 47831, 48203, 48492, 48521, 48660, 48756, 49172, 49276, 48165, 48192, 48222, 48398, 48434, 48600, 48978, 48996, 49013, 49178, 48175, 48194, 48223, 48224, 48508, 48989, 49058, 49180, 49181, 49310, 47774, 47822, 47989, 48274, 48422, 48936, 48993, 49025, 49033, 49034, 49173, 49176, 49318, 47751, 47780, 48186, 48254, 48265, 48348, 48352, 48759, 48787, 48933, 48961, 49022, 49169, 47969, 48028, 48081, 48195, 48246, 48474, 49163, 49278
)
