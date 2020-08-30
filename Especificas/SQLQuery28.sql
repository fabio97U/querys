select *, 
case 
when materias_aprobadas >= 37 then '5' 
when (materias_aprobadas >= 29 and materias_aprobadas <= 36) then '4' 
when (materias_aprobadas >= 20 and materias_aprobadas <= 28) then '3' 
else '1-2'end 'anio_cursando'  
from (
	select car_nombre, ins_codper, per.per_carnet, per_nombres, per_apellidos, per_telefono, per_correo_institucional, count(1) 'inscritas_012020', dbo.mat_apro_ciclo(ins_codper, 122) 'aprobadas_012020' 
	--, (select ins_codigo from ra_ins_inscripcion where ins_codper = ins.ins_codper and ins_codcil = 123) 'inscribio_022020',
	, 0 'inscribio_022020'
	, (
		select count(1) from (
		select distinct per_codigo, per_carnet, tmo.tmo_arancel,
		tmo.tmo_codigo, case substring(tmo.tmo_descripcion,1,1) when 'M' then '0' else substring(tmo.tmo_descripcion,1,1) end n, tmo.tmo_descripcion,
		case substring(tmo.tmo_arancel,1,1)
		when 'C' then 'U'
		when 'S' then 'U'
		else substring(tmo.tmo_arancel,1,1) end tipo, mov_fecha_real_pago 
		from col_mov_movimientos
		join col_dmo_det_mov on dmo_codmov=mov_codigo
		join ra_per_personas on per_codigo=mov_codper
		join ra_ins_inscripcion on ins_codper=per_codigo
		join col_tmo_tipo_movimiento as tmo on dmo_codtmo = tmo.tmo_codigo
		join vst_aranceles_x_evaluacion as v on v.are_codtmo = tmo.tmo_codigo
		where dmo_codcil = 123 and per_tipo='U' and mov_estado <> 'A'
		and are_tipo = 'PREGRADO' and mov_codper = ins.ins_codper
		) t
		where t.n in ('0', '1')
	) 'cancelo_matricula_cuota_022020',
	(dbo.fx_MateriasAprobadas(per.per_carnet)) 
	'materias_aprobadas'
	from ra_ins_inscripcion as ins
	inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
	inner join ra_per_personas per on per_codigo = ins_codper
	inner join ra_alc_alumnos_carrera on alc_codper = ins_codper
	inner join ra_pla_planes on pla_codigo = alc_codpla
	inner join ra_car_carreras on pla_codcar = car_codigo
	where ins_codcil = 122 
	--and ins_codper = 180168 
	and mai_estado = 'I' 
	and per_estado <> 'E'
	and per_tipo = 'U'
	and per_codigo not in (select distinct ins_codper from dbo.ra_ins_inscripcion where ins_codcil = 123)
	group by car_nombre, ins_codper, per.per_carnet, per_nombres, per_apellidos, per_telefono, per_correo_institucional
) t2
where 
--t2.materias_aprobadas >= 20 and
t2.aprobadas_012020 >= t2.inscritas_012020 
--and isnull(t2.inscribio_022020, 0) = 0
and t2.cancelo_matricula_cuota_022020 < 2--5343