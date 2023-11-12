select * from pg_pre_preespecializacion where pre_nombre like '%arquitec%'
select * from pg_mpr_modulo_preespecializacion where mpr_codpre = 682
select * from pg_apr_aut_preespecializacion where apr_codpre in (682)
SELECT * FROM pg_hmp_horario_modpre where hmp_codmpr in (4279, 4280)

select * from pg_imp_ins_especializacion where imp_codper = 181324
select * from pg_pmp_ponderacion
select * from pg_nmp_notas_mod_especializacion where nmp_codimp = 26381 order by nmp_codpmp

select * from pg_mpr_modulo_preespecializacion where mpr_visible = 'N'


	-- exec dbo.rep_pg_notas_por_carrera 1, 122
alter procedure rep_pg_notas_por_carrera
	@opcion int = 1,
	@codcil int = 0
as
begin
	
	if @opcion = 1
	begin
		select 
		row_number() over(order by pla_alias_carrera, per_apellidos_nombres) row_num,
		ROW_NUMBER() OVER (PARTITION BY pre_nombre ORDER BY pla_alias_carrera, per_apellidos_nombres) correlativo_pre,
		ROW_NUMBER() OVER (PARTITION BY pla_alias_carrera ORDER BY pla_alias_carrera, per_apellidos_nombres) correlativo_carrera,
		*, round((([Modulo 1] + [Modulo Comun 1] + [Modulo 2] + [Modulo Comun 2] + [Modulo 3] + [Modulo 4] + [Modulo 5] + [Modulo 6]) / 8), 1) 'Nota Final'
		from (
			select ciclo, pla_alias_carrera, concat(pla_alias_carrera, ' - ', pre_nombre) carrera_pre, per_carnet, per_apellidos_nombres, pre_nombre, mpr_nombre, 
			isnull([Modulo 1], 0) [Modulo 1], isnull([Modulo Comun 1], 0) [Modulo Comun 1], isnull([Modulo 2], 0) [Modulo 2],
			isnull([Modulo Comun 2], 0) [Modulo Comun 2], isnull([Modulo 3], 0) [Modulo 3], isnull([Modulo 4], 0) [Modulo 4], 
			isnull([Modulo 5], 0) [Modulo 5], isnull([Modulo 6], 0) [Modulo 6]
			from (
				select distinct concat('0', cil_codcic, '-', cil_anio) 'ciclo', pla_alias_carrera, per_codigo, per_carnet, per_apellidos_nombres, pre_nombre, mpr_nombre,
				round(nmp_nota, 2) nmp_nota, pmp_nombre
				from pg_pre_preespecializacion 
					inner join pg_mpr_modulo_preespecializacion on mpr_codpre = pre_codigo
					inner join pg_apr_aut_preespecializacion on apr_codpre = pre_codigo
					inner join pg_hmp_horario_modpre on hmp_codmpr = mpr_codigo
					inner join pg_imp_ins_especializacion on imp_codapr = apr_codigo and imp_codmpr = mpr_codigo
					inner join ra_cil_ciclo on pre_codcil = cil_codigo
					inner join ra_per_personas on per_codigo = imp_codper
					inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
					inner join ra_pla_planes on alc_codpla = pla_codigo
					inner join ra_car_carreras on car_codigo = pla_codcar
					inner join ra_fac_facultades on fac_codigo = car_codfac

					inner join pg_nmp_notas_mod_especializacion on nmp_codimp = imp_codigo
					inner join pg_pmp_ponderacion on nmp_codpmp = pmp_codigo
				where --pre_codigo = 682 --and 
				pre_codcil = @codcil
				--and mpr_visible = 'S'
				and imp_estado in ('I') and pmp_codigo in (1, 2, 3, 4, 5, 6, 9, 10)
				--and imp_codper = 181324
				--order by per_apellidos_nombres, pla_alias_carrera, RIGHT(pmp_nombre, 1), pmp_nombre
			) t
			PIVOT (
				sum(nmp_nota)
				for pmp_nombre in ([Modulo 1], [Modulo Comun 1], [Modulo 2], [Modulo Comun 2], [Modulo 3], [Modulo 4], [Modulo 5], [Modulo 6])
			) as pivo
		) t2
		order by pla_alias_carrera, per_apellidos_nombres
	end
end
