----set dateformat dmy
select rtrim(ltrim(per_nombres)) per_nombres,rtrim(ltrim(per_apellidos)) per_apellidos,
replace(Convert(varchar,per_fecha_nac,103),'/','') fecha_nac,replace(per_carnet,'-','') per_carnet, 
per_fecha_nac,
per_correo_institucional,per_tipo from ra_per_personas where per_codigo in(181324, 182420, 196586)

--drop table TEMP_CAMBIOS_FECHAS_NAC_INVERTIDAS
create table TEMP_CAMBIOS_FECHAS_NAC_INVERTIDAS (
	codigo int identity(1, 1), 
	FECHA_NACIMIENTO nvarchar(12),
	per_fecha_nac date,
	per_codigo int,
	per_carnet varchar(16),
	per_nombres_apellidos varchar(150),
	per_estado varchar (3),
	per_tipo varchar (3),
	fecha_nac_original varchar(10),
	fecha_nac_actual varchar(10),
	len_fecha_nac_original int,
	fecha_nac_original_es_numerica varchar(3),
	dia_original varchar(3),
	mes_original varchar(3),
	anio_original varchar(4),
	dia_actual varchar(3),
	mes_actual varchar(3),
	anio_actual varchar(4),
	fecha_hora_creacion datetime default getdate()
)
--select * from TEMP_CAMBIOS_FECHAS_NAC_INVERTIDAS

insert into TEMP_CAMBIOS_FECHAS_NAC_INVERTIDAS
(FECHA_NACIMIENTO, per_fecha_nac, per_codigo, per_carnet, per_nombres_apellidos, per_estado, per_tipo, fecha_nac_original, 
fecha_nac_actual, len_fecha_nac_original, fecha_nac_original_es_numerica, dia_original, mes_original, anio_original, dia_actual, mes_actual, anio_actual)
select concat(
substring(fecha_nac_original,1,2), '/',
substring(fecha_nac_original,3,2), '/',
substring(fecha_nac_original,5,4)
) 'FECHA_NACIMIENTO', * from (
	select *, 
	substring(fecha_nac_original,1,2) 'dia_original',
	substring(fecha_nac_original,3,2) 'mes_original',
	substring(fecha_nac_original,5,4) 'anio_original',
	substring(fecha_nac_actual,1,2) 'dia_actual',
	substring(fecha_nac_actual,3,2) 'mes_actual',
	substring(fecha_nac_actual,5,4) 'anio_actual'
	from (
		select * from (
			select *, len(fecha_nac_original) 'len_fecha_nac_original', ISNUMERIC(fecha_nac_original) 'fecha_nac_original_es_numerica' from (
				select 
				per_fecha_nac, per_codigo, per_carnet, per_nombres_apellidos, per_estado, per_tipo
				--distinct per_estado
				,ISNULL((
					select 
					top 1 esp_pass 
					from web_esp_estadisticas_portal
					where esp_cuenta_codigo = per.per_codigo
					order by esp_codigo
				), 0) fecha_nac_original
				,replace(Convert(varchar,per_fecha_nac,103),'/','') fecha_nac_actual
				from ra_per_personas as per
				--inner join ra_ins_inscripcion on ins_codper = per_codigo and ins_codcil = 122
				where per_estado not in ('I', 'G', 'X', 'F', '0') and per_tipo in ('U', 'M')
				--and per_codigo = 181324
			) t
		)t2
		where t2.len_fecha_nac_original = 8 and t2.fecha_nac_original_es_numerica = 1 and t2.fecha_nac_original != '0'
		and t2.fecha_nac_original != t2.fecha_nac_actual
	) t3
)t4
where t4.anio_original = t4.anio_actual 
and t4.dia_original = t4.mes_actual 
and t4.mes_original = t4.dia_actual
--and t4.per_codigo = 181324
order by per_codigo


--update ra_per_personas set per_fecha_nac = a.FECHA_NACIMIENTO
--from TEMP_CAMBIOS_FECHAS_NAC_INVERTIDAS as a
--inner join ra_per_personas as b on a.per_codigo = b.per_codigo