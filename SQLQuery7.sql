--select * from pg_imp_ins_especializacion
--inner join pg_apr_aut_preespecializacion on apr_codigo = imp_codapr
--inner join pg_mpr_modulo_preespecializacion on mpr_codigo = imp_codmpr
--inner join ra_per_personas on per_codigo = imp_codper
--inner join pg_hmp_horario_modpre on hmp_codigo = imp_codhmp
--where apr_codcil = 123


select * from (
	select *, case when (hs_carrera - hs_realizadas) > 0 then 'NO' else 'SI' end 'COMPLETO HS'  from (
		select 
		per_carnet Carnet, per_nombres Nombres, per_apellidos Apellidos, per_email 'Correo personal', 
		per_email_opcional 'Correo opcional', per_correo_institucional 'Correo institucional', per_telefono 'Telefono', per_telefono_oficina 'Telefono oficina', per_celular 'Celular', 
		(select car_horas_soc from ra_car_carreras where car_codigo = (select pla_codcar from ra_pla_planes where pla_codigo = alc.alc_codpla)) 'hs_carrera',
		(
			select ISNULL((select sum(hsp_horas) from ra_hsp_horas_sociales_personas where hsp_codper = alc.alc_codper), 0)
			from ra_alc_alumnos_carrera 
			inner join ra_pla_planes on pla_codigo = alc_codpla
			where alc_codper = alc.alc_codper
		) 'hs_realizadas' ,
		regr_cum,
		regr_observaciones
		from ra_regr_registro_egresados
		inner join ra_per_personas on per_codigo = regr_codper
		inner join ra_alc_alumnos_carrera alc on per_codigo = alc_codper
		inner join ra_pla_planes as pla on pla.pla_codigo = alc.alc_codpla
		inner join ra_car_carreras as car on car_codigo = pla_codcar
		where regr_codcil_ing = 122
		and regr_codper not in (
			select imp_codper from pg_imp_ins_especializacion
			inner join pg_apr_aut_preespecializacion on apr_codigo = imp_codapr
			inner join pg_mpr_modulo_preespecializacion on mpr_codigo = imp_codmpr
			inner join ra_per_personas on per_codigo = imp_codper
			inner join pg_hmp_horario_modpre on hmp_codigo = imp_codhmp
			where apr_codcil = 123
		) and per_tipo = 'U' and car_tipo = 'C'
	) t
) t2
where t2.[COMPLETO HS] = 'NO'