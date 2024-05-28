select * from bkb.vst_bkb_origen where codcil = 134
select * from bkb.ori_origen

select * from bkb.vst_bkb_periodo where codcil = 134
select * from bkb.peri_periodo
Select * from pg_hmp_horario_modpre
select * from bkb.vst_bkb_curso where codcil = 134
select * from bkb.vst_bkb_curso where codcil = 134 and tipo_estudio = 'preespecialidad' and orden in (1, 9) order by codigo_curso
select * from bkb.cur_cursos
--PPla1-02-M24
select * from bkb.usr_usuarios where usr_userName = '4622212016'

select * from bkb.vst_bkb_materiasEst_materiasDoc where materia in (
	select codigo_curso from bkb.vst_bkb_curso where codcil = 134 and tipo_estudio = 'preespecialidad' and codigo_curso = 'PDes1-03-M24'
)

select * from bkb.vst_bkb_curso where codcil = 134 and tipo_estudio = 'preespecialidad' and orden in (1, 9)

select * from bkb.vst_bkb_materiasEst_materiasDoc where materia in (
	select codigo_curso from bkb.vst_bkb_curso where codcil = 134 and tipo_estudio = 'preespecialidad' and orden in (9)
)

select a.cuenta, a.materia, b.table_origen_curso from bkb.vst_bkb_materiasEst_materiasDoc_MALO_BORRAR a
left join 
(
	select * from bkb.vst_bkb_materiasEst_materiasDoc where materia in (
		select codigo_curso from bkb.vst_bkb_curso where codcil = 134 and tipo_estudio = 'preespecialidad' and orden in (1, 9)
	)
	--and cuenta = '5334672019'
) b on a.materia = b.materia and a.cuenta = b.cuenta
where a.materia in (
	select codigo_curso from bkb.vst_bkb_curso where codcil = 134 and tipo_estudio = 'preespecialidad' and orden in (1, 9)
)
and a.cuenta = '034922019'
and b.table_origen_curso is null


select * from bkb.vst_bkb_materiasEst_materiasDoc where materia in (
	select codigo_curso from bkb.vst_bkb_curso where codcil = 134 and tipo_estudio = 'preespecialidad' and orden in (1, 9)
)
and mim_idBkb is null
and tabla_origen_usuario is null

--and cuenta = '0242302018'
--and id_usuario_blackboard is null

select * from bkb.usr_usuarios

select * from bkb.vst_bkb_materiasEst_materiasDoc
select * from bkb.mim_miembros
--NODOS DE BLACKBOARD DE PRODUCCION
/*
insert into bkb.nodo(nodo_id,nodo_externalId,nodo_title,nodo_description,nodo_per_tipo,nodo_per_estado)values('_135_1','18835708-281c-4c7d-9005-9792fda86be4','Pregrado','Pregrado','U','A')
insert into bkb.nodo(nodo_id,nodo_externalId,nodo_title,nodo_description,nodo_per_tipo,nodo_per_estado)values('_8_1','f1c8858e-2b14-4c35-9659-1f97d40bbe26','Preespecialidad','Preespecialidad','U','E')
insert into bkb.nodo(nodo_id,nodo_externalId,nodo_title,nodo_description,nodo_per_tipo,nodo_per_estado)values('_9_1','0f094076-84ef-4ccd-aed1-368d030c7ea3','Maestría','Maestría','M','A')
insert into bkb.nodo(nodo_id,nodo_externalId,nodo_title,nodo_description,nodo_per_tipo,nodo_per_estado)values('_9_1','0f094076-84ef-4ccd-aed1-368d030c7ea3','Maestría','Maestría','M','E')

go

insert into bkb.nodo(nodo_codigo,nodo_id,nodo_externalId,nodo_title,nodo_description,nodo_per_tipo,nodo_per_estado)values(1,'_135_1','18835708-281c-4c7d-9005-9792fda86be4','Pregrado','Pregrado','U','A')
insert into bkb.nodo(nodo_codigo,nodo_id,nodo_externalId,nodo_title,nodo_description,nodo_per_tipo,nodo_per_estado)values(2,'_8_1','f1c8858e-2b14-4c35-9659-1f97d40bbe26','Preespecialidad','Preespecialidad','U','E')
insert into bkb.nodo(nodo_codigo,nodo_id,nodo_externalId,nodo_title,nodo_description,nodo_per_tipo,nodo_per_estado)values(3,'_9_1','0f094076-84ef-4ccd-aed1-368d030c7ea3','Maestría','Maestría','M','A')
insert into bkb.nodo(nodo_codigo,nodo_id,nodo_externalId,nodo_title,nodo_description,nodo_per_tipo,nodo_per_estado)values(4,'_9_1','0f094076-84ef-4ccd-aed1-368d030c7ea3','Maestría','Maestría','M','E')