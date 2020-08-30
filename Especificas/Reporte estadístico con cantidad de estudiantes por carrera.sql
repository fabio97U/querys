select per_codigo, per_carnet, per_nombres, per_apellidos, car_nombre
--,dbo.cum_repro(per_codigo), dbo.mat_gral_repro(per_codigo)
,(
isnull(
	stuff(
		(
			select concat (',',convert (date, mov_fecha_real_pago, 103), ',', case when pago_complementario = 0 then '-1' else pago_complementario end,'')
			from 
			(
			select distinct per_codigo, per_carnet, tmo.tmo_arancel,
			tmo.tmo_codigo, substring(tmo.tmo_descripcion,1,1) n, tmo.tmo_descripcion,
			case substring(tmo.tmo_arancel,1,1)
			when 'C' then 'U'
			when 'S' then 'U'
			else substring(tmo.tmo_arancel,1,1) end tipo, mov_fecha_real_pago, 
			/*(select top 1 dmo_codigo from col_dmo_det_mov where dmo_codmov = mov_codigo and dmo_codtmo = 88)*/0 'pago_complementario'
			from col_mov_movimientos
			join col_dmo_det_mov on dmo_codmov=mov_codigo
			join ra_per_personas on per_codigo=mov_codper
			join ra_ins_inscripcion on ins_codper=per_codigo
			join col_tmo_tipo_movimiento as tmo on dmo_codtmo = tmo.tmo_codigo
			join vst_aranceles_x_evaluacion as v on v.are_codtmo = tmo.tmo_codigo
			where dmo_codcil = 122 and per_tipo='U' and mov_estado <> 'A'
			and are_tipo = 'PREGRADO' and mov_codper = per.per_codigo --and ins_codper in (4756, 4412)
			) t
			where n in ('3')
			for xml path('')
		),1,1,''
	), ''
) --'requisitos'
)
from ra_per_personas as per
inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
inner join ra_pla_planes on pla_codigo = alc_codpla
inner join ra_ins_inscripcion on ins_codper = per_codigo and ins_codcil = 122
inner join ra_car_carreras on car_codigo = pla_codcar
where per_tipo = 'U' --and per_estado = 'A' 
--and per_codigo in (4756, 4412)
order by per_codigo asc








--1.	Número de alumnos que realizaron evaluaciones diferidas sin pago de arancel.
--S-04	EXAMEN DIFERIDO (Pregrado)
select * from web_spat_solicitud_proceso_academico_tramite
select * from web_spar_solicitud_proceso_academico_razon

select spa_eva, count(1) from web_spa_solicitud_proceso_academico
where spa_codcil = 122 and spa_fecha > '2020-04-01' and not spa_codmat like '%-V' and spa_eva > 2
group by spa_eva
--2.	Número  de alumnos de la pre especialización que realizaron examen extraordinario y de suficiencia sin pago de arancel.
--S-05	EXAMEN EXTRAORDINARIO (Preespecialidad)
--E-01	EXAMEN DE SUFICIENCIA (Preespecialidad)

--3.	Número de alumnos con pagos extemporáneos de cuota sin cobro de arancel
--A-88	PAGO COMPLEMENTARIO $10.00


--4.	Número de constancias de notas sin cobro de arancel.
--N-03	CONSTANCIA DE NOTAS CORRIENTES $15.00

--5.	Otros servicios brindados sin cobro de arancel.
select trao_nombre, count(1) from (
select distinct tae_codper, trao_nombre, 1 coun from ra_tae_tramites_academicos_efectuados 
inner join ra_Tramites_academicos_online on trao_codigo = tae_codtrao
where tae_fecha_creacreacion > '2020-04-01'
and tae_codcil = 122
) t
group by trao_nombre