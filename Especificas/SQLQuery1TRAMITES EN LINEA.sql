--Retiro de Asignaturas	43
--Retiro de Ciclo	24
select distinct per_carnet, per_nombres_apellidos,trao_nombre, trao_tipo, concat('0', cil_codcic, '-', cil_anio) ciclo
, tae_fecha_creacreacion, mai_codmat, mat_nombre, hpl_descripcion, usr_usuario
from ra_tae_tramites_academicos_efectuados
inner join ra_per_personas on per_codigo = tae_codper
inner join ra_Tramites_academicos_online on tae_codtrao = trao_codigo
left join adm_usr_usuarios on usr_codigo = tae_codusr
inner join ra_cil_ciclo on cil_codigo = tae_codcil
left join ra_ins_inscripcion on ins_codigo = tae_codins and ins_codcil = tae_codcil
left join ra_mai_mat_inscritas on mai_codins = ins_codigo and mai_codigo = tae_codmai
left join ra_mat_materias on mat_codigo = mai_codmat
left join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl 
--where mai_codhpl = 41394
order by tae_fecha_creacreacion desc

select trao_nombre, count(distinct tae_codper) 'cantidad'
from ra_tae_tramites_academicos_efectuados
inner join ra_per_personas on per_codigo = tae_codper
inner join ra_Tramites_academicos_online on tae_codtrao = trao_codigo
left join adm_usr_usuarios on usr_codigo = tae_codusr
inner join ra_cil_ciclo on cil_codigo = tae_codcil
left join ra_ins_inscripcion on ins_codigo = tae_codins and ins_codcil = tae_codcil
left join ra_mai_mat_inscritas on mai_codins = ins_codigo and mai_codigo = tae_codmai
left join ra_mat_materias on mat_codigo = mai_codmat
left join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
group by trao_nombre
union
select 'TOTAL', (select count(distinct tae_codper)
from ra_tae_tramites_academicos_efectuados
inner join ra_per_personas on per_codigo = tae_codper
inner join ra_Tramites_academicos_online on tae_codtrao = trao_codigo
left join adm_usr_usuarios on usr_codigo = tae_codusr
inner join ra_cil_ciclo on cil_codigo = tae_codcil
left join ra_ins_inscripcion on ins_codigo = tae_codins and ins_codcil = tae_codcil
left join ra_mai_mat_inscritas on mai_codins = ins_codigo and mai_codigo = tae_codmai
left join ra_mat_materias on mat_codigo = mai_codmat
left join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl)

select top 1 * from err_errores_sistema order by err_codigo desc--1062