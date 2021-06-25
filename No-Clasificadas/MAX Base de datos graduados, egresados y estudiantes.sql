select 'GRADUADO' 'Estado',pai_nombre,
case when MUN_NOMBRE = 'NUEVA SAN SALVADOR' then 'SANTA TECLA' else MUN_NOMBRE end Municipio, 
per_carnet, pla_alias_carrera, per_nombres Nombres, per_apellidos Apellidos, per_direccion Direccion, per_correo_institucional 'Correo institucional', per_email 'Correo personal', per_telefono, per_celular
from ra_gra_graduados
inner join ra_per_personas on per_codigo = gra_codper
inner join ra_mun_municipios on per_codmun_nac = MUN_CODIGO
inner join ra_dep_departamentos on DEP_CODIGO = MUN_CODDEP
inner join ra_pai_paises on pai_codigo = DEP_CODPAI
INNER Join ra_alc_alumnos_carrera ON alc_codper = per_codigo
inner join ra_pla_planes on alc_codpla = pla_codigo
--order by pai_nombre, Municipio, pla_alias_carrera, per_apellidos
	
	union all

select 'EGRESADO' 'Estado', pai_nombre,
case when MUN_NOMBRE = 'NUEVA SAN SALVADOR' then 'SANTA TECLA' else MUN_NOMBRE end Municipio, 
per_carnet, pla_alias_carrera, per_nombres Nombres, per_apellidos Apellidos, per_direccion Direccion, per_correo_institucional 'Correo institucional', per_email 'Correo personal', per_telefono, per_celular
from ra_per_personas 
inner join ra_mun_municipios on per_codmun_nac = MUN_CODIGO
inner join ra_dep_departamentos on DEP_CODIGO = MUN_CODDEP
inner join ra_pai_paises on pai_codigo = DEP_CODPAI
INNER Join ra_alc_alumnos_carrera ON alc_codper = per_codigo
inner join ra_pla_planes on alc_codpla = pla_codigo
where per_estado = 'E' --and per_tipo = 'U'
--order by pai_nombre, Municipio, pla_alias_carrera, per_apellidos
	
	union all

select 'ESTUDIANTE ACTIVO' 'Estado', pai_nombre,
case when MUN_NOMBRE = 'NUEVA SAN SALVADOR' then 'SANTA TECLA' else MUN_NOMBRE end Municipio, 
per_carnet, pla_alias_carrera, per_nombres Nombres, per_apellidos Apellidos, per_direccion Direccion, per_correo_institucional 'Correo institucional', per_email 'Correo personal', per_telefono, per_celular
from ra_per_personas
inner join ra_mun_municipios on per_codmun_nac = MUN_CODIGO
inner join ra_dep_departamentos on DEP_CODIGO = MUN_CODDEP
inner join ra_pai_paises on pai_codigo = DEP_CODPAI
INNER Join ra_alc_alumnos_carrera ON alc_codper = per_codigo
inner join ra_pla_planes on alc_codpla = pla_codigo
where per_estado = 'A' and per_codigo in (
	select distinct ins_codper from ra_ins_inscripcion
	where ins_codcil in (123, 124, 125, 126, 127)
)
order by Estado, pai_nombre, Municipio, pla_alias_carrera, per_apellidos