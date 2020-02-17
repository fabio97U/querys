
create table web_caav_calendario_acad_virtual(
	caav_codigo int primary key identity(1,1),
	caav_codmat nvarchar(15),
	caav_codpla int,
	caav_evaluacion int,
	caav_fecha_limite datetime,
	caav_usuario int,
	caav_fecha_registro datetime default getdate()
)
