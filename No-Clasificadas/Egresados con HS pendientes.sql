select per_carnet, per_estado, per_apellidos_nombres, realizadas, requeridas from (
select 
ISNULL((select sum(hsp_horas) from ra_hsp_horas_sociales_personas where hsp_codper = per_codigo), 0) 'realizadas',
((select car_horas_soc from ra_car_carreras where car_codigo = (select pla_codcar from ra_pla_planes where pla_codigo = (select alc_codpla from ra_alc_alumnos_carrera where alc_codper = per_codigo)))) 'requeridas',
ra_regr_registro_egresados.*,
ra_per_personas.per_estado, per_carnet, per_apellidos_nombres
from ra_regr_registro_egresados 
inner join ra_per_personas on regr_codper = per_codigo
where regr_codcil_ing = 123-- and regr_codper = 181233
--and per_estado = 'A'
and regr_codper not in (
select distinct imp_codper from pg_imp_ins_especializacion
)
and regr_codper in (184545, 188812, 195680, 216371, 170987)
) t
where realizadas < requeridas
order by regr_codigo asc, per_apellidos_nombres

select * from adm_usr_usuarios where usr_codigo = 391
select * from ra_regr_registro_egresados where regr_codper = 188812
--select * from ra_per_personas where per_codigo in (
--184545, 188812, 195680, 216371, 170987
--)