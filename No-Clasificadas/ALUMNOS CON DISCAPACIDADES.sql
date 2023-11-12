select 'PREGRADO' 'estatus', SUBSTRING(per_carnet, 9, 4) 'anio_inscripcion', CONCAT('0', cil_codcic, '-', cil_anio) 'ciclo_inscripcion', 
per_discapacidad 'discapacidad', per_sexo 'sexo', (YEAR(GETDATE())-YEAR(per_fecha_nac)) 'edad', MUN_NOMBRE 'departamento_residencia', per_carnet, per_nombres_apellidos, pla_alias_carrera 
from ra_per_personas 
inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
inner join ra_pla_planes on alc_codpla = pla_codigo
inner join ra_mun_municipios on MUN_CODIGO = per_codmun_nac
inner join ra_ins_inscripcion on ins_codper = alc_codper
inner join ra_cil_ciclo on cil_codigo = ins_codcil
where per_discapacidad != '' and SUBSTRING(per_carnet, 9, 4) in ('2018', '2019', '2020') and per_discapacidad not in ('NINGUNO', 'no', '-', 'NINGUNA', 'N/A', 'no posee', 'NO', 'na', ' no', '|', ' ', 'NO ', ' ')
and per_discapacidad not like '%ning%' and cil_codcic not in (3)

union all

select 'GRADUADO' 'estatus', SUBSTRING(per_carnet, 9, 4) 'anio_inscripcion', CONCAT('0', cil_codcic, '-', cil_anio) 'ciclo_inscripcion', 
per_discapacidad 'discapacidad', per_sexo 'sexo', (YEAR(GETDATE())-YEAR(per_fecha_nac)) 'edad', MUN_NOMBRE 'departamento_residencia', per_carnet, per_nombres_apellidos, pla_alias_carrera 
from ra_per_personas 
inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
inner join ra_pla_planes on alc_codpla = pla_codigo
inner join ra_mun_municipios on MUN_CODIGO = per_codmun_nac
inner join ra_ins_inscripcion on ins_codper = alc_codper
inner join ra_cil_ciclo on cil_codigo = ins_codcil
where per_discapacidad != '' and per_discapacidad not in ('NINGUNO', 'no', '-', 'NINGUNA', 'N/A', 'no posee', 'NO', 'na', ' no', '|', ' ', 'NO ', ' ')
and per_discapacidad not like '%ning%' and cil_codcic not in (3)
and per_codigo in (
select gra_codper from ra_gra_graduados
where year(gra_fecha_graduacion) in ('2018', '2019', '2020')
)
order by 1, per_nombres_apellidos