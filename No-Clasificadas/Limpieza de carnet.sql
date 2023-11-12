create table alumnos_BORRAME (numero int, correo varchar(50))

select a.*, p.per_carnet, alc_codpla,
p.per_sexo, 2022-year(per_fecha_nac) 'edad', year(per_anio_graduacion) 'Año graduacion', per_direccion,
	dbo.fx_MateriasAprobadas(p.per_carnet) 'Materias pasadas', pla.pla_n_mat, MUN_NOMBRE, DEP_NOMBRE, p.per_lugar_trabajo, p.per_direccion_trabajo, p.per_tel_trabajo
from alumnos_BORRAME a--4709
	left join ra_per_personas p on substring(replace(replace(replace(replace(LOWER(a.correo), ';', ''), '-', ''), '_', ''), '!', ''), 0, 11)= replace(p.per_carnet, '-', '')
	left join ra_alc_alumnos_carrera on alc_codper = per_codigo
	left join ra_pla_planes pla on alc_codpla = pla_codigo
	left join ra_mun_municipios on per_codmun_nac = MUN_CODIGO
	left join ra_dep_departamentos on MUN_CODDEP = DEP_CODIGO
--where p.per_codigo = 199047
order by numero

select * from ra_mun_municipios where per_codigo = 181324
select * from ra_vst_aptde_AlumnoPorTipoDeEstudio where per_codigo = 199047
