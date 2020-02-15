--SELECT [caa_codigo], [caa_dias], [caa_hora], CONVERT(VARCHAR,[caa_fecha],103) caa_fecha, [caa_evaluacion], [caa_grupo] 
--FROM [web_ra_caa_calendario_acad]

--order by caa_grupo asc, caa_evaluacion asc

create table web_caav_calendario_acad_virtual(
	caav_codigo int primary key identity(1,1),
	caav_codmat nvarchar(15),
	caav_codpla int,
	caav_evaluacion int,
	caav_codcil int ,
	caav_fecha_limite datetime,
	caav_usuario int,
	caav_fecha_registro datetime default getdate()
)
