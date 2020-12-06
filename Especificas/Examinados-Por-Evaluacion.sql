select car_identificador, car_nombre, pon_nombre, count(distinct per_codigo) 'Examinados' 
from ra_ins_inscripcion
inner join ra_per_personas on per_codigo = ins_codper
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
inner join ra_not_notas on not_codmai = mai_codigo
inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
inner join ra_pon_ponderacion on pon_codigo = pom_codpon
inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
inner join ra_pla_planes on mai_codpla = pla_codigo 
inner join ra_car_carreras on car_codigo = pla_codcar
where --ins_codper = 173322  and 
ins_codcil = 123 and per_tipo = 'U'
and pon_codigo in (1, 2) and mai_estado = 'I' and bandera = 1
group by car_identificador, car_nombre, pon_nombre
order by pon_nombre, car_identificador

