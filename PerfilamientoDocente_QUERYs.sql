--use BD_RRHH
--go
--create schema perfil
--go
drop procedure perfil.sp_insertar_respuestas_perfilamiento
drop procedure perfil.sp_insertar_encabezado_perfilamiento
drop procedure perfil.sp_respuestas_perfilamiento
drop type perfil.tbl_detperf
drop table perfil.detperf_detalle_perfil
drop table perfil.encperf_encabezado_perfil
drop table perfil.pregopc_preguntas_opciones
drop table perfil.opc_opciones
drop table perfil.tipopc_tipopc_opciones
drop table perfil.preg_preguntas
drop table perfil.tippreg_tipo_pregunta
drop table perfil.gruperf_grupos_perfilamiento
drop table perfil.respperf_responsables_perfilamiento
drop table perfil.perfesc_perfiles_escuela

-- drop table perfil.perfesc_perfiles_escuela
create table perfil.perfesc_perfiles_escuela (
	perfesc_codigo int primary key identity (1, 1) not null,
	perfesc_nombre varchar(100) not null,
	perfesc_codesc int,
	perfesc_nota_minima real not null default 0.0,
	perfesc_fecha_creacion datetime default getdate()
)
go
-- select * from perfil.perfesc_perfiles_escuela
insert into perfil.perfesc_perfiles_escuela (perfesc_nombre, perfesc_codesc, perfesc_nota_minima)
values ('Escuela de Derecho', 5, 6),
('ANTROPOLOGIA año 2023', 7, 6),
('CCAA', 6, 6),
('COMUNICACIONES', 3, 6),
('Coord. Administración', 2, 6),
('Coord. Contaduria', 2, 6),
('Coord. Mercadeo', 2, 6),
('Coord. Negocios', 2, 6),
('Coord. Turismo', 2, 6),
('IDIOMAS', 1, 6),
('Informática', 4, 6),
('PSICOLOGIA 2023 24 mayo', 8, 6)
go

-- drop table perfil.respperf_responsables_perfilamiento
create table perfil.respperf_responsables_perfilamiento (
	respperf_codigo int primary key identity (1, 1) not null,
	respperf_codperfesc int foreign key references perfil.perfesc_perfiles_escuela not null,
	respperf_codemp_responsable int not null,
	respperf_fecha_creacion datetime default getdate()
)
-- select * from perfil.respperf_responsables_perfilamiento
insert into perfil.respperf_responsables_perfilamiento (respperf_codperfesc, respperf_codemp_responsable) 
values (1, 4291), (2, 4291), (3, 4291), (4, 4291), (5, 4291), (6, 4291),
(7, 4291), (8, 4291), (9, 4291), (10, 4291), (11, 4291), (12, 4291)
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-10-29 17:03:11.743>
	-- Description: <Devuelve los perfiles docentes activos>
	-- =============================================
	-- select * from perfil.vst_perfiles_escuelas_disponibles order by escuela
create or alter view perfil.vst_perfiles_escuelas_disponibles
as
	select perfesc_codigo 'codperfesc', perfesc_nombre 'nombre_perfil', perfesc_codesc 'codesc', esc_nombre 'escuela', perfesc_fecha_creacion 'fecha_creacion',
	(
		(select stuff(
		(
			select  concat(';', emp_email_empresarial)  from perfil.respperf_responsables_perfilamiento 
			inner join uonline.dbo.pla_emp_empleado on respperf_codemp_responsable = emp_codigo
			where respperf_codperfesc = perfesc_codigo
			for xml path('')
		)
		,1, 1, ''))
	) 'correos_responsables_escuela'
	from perfil.perfesc_perfiles_escuela
		inner join uonline.dbo.ra_esc_escuelas on perfesc_codesc = esc_codigo
go

-- drop table perfil.gruperf_grupos_perfilamiento
create table perfil.gruperf_grupos_perfilamiento(
	gruperf_codigo int primary key identity(1, 1),
	gruperf_nombre varchar(255),
	gruperf_descripcion varchar(1024) null,
	gruperf_icono varchar(30) null,
	gruperf_codperfesc int foreign key references perfil.perfesc_perfiles_escuela not null,
	gruperf_orden int,
	gruperf_orden_general int,
	gruperf_puntos_maximos float,
	gruperf_padre int,
	gruperf_peso_grupo int default 0, --Entre menor peso es elevado, es para solventar los sub-grupos, los peso 0 son los princiaples
	gruperf_fecha_creacion datetime default getdate()
)
go
-- select * from perfil.gruperf_grupos_perfilamiento order by gruperf_orden_general
insert into perfil.gruperf_grupos_perfilamiento 
(gruperf_codperfesc, gruperf_nombre, gruperf_orden_general, gruperf_orden, gruperf_puntos_maximos, gruperf_peso_grupo, gruperf_padre, gruperf_icono) values
(1, 'DATOS GENERALES', 0, 0, 0, 0, null, 'ri-user-line'),
(1, 'FORMACIÓN y  PRODUCCION ACADEMICA/ FORMATIVA', 1, 1, 3.0, 0, null, 'ri-contacts-book-2-line'), 
	(1, 'Doctorado en derecho ', 2, 1, 0, 1, 2, null),
	(1, 'Posgrado:', 3, 2, 0, 1, 2, null),
	(1, 'Diplomados ', 4, 3, 0, 1, 2, null),
	(1, 'Seminarios (mínimo de tiempo 20 horas  y que dada la especialidad no requiera una actualizacion en la materia.', 5, 4, 0, 1, 2, null),
	(1, 'Cursos  ( minimo 30 horas  y que dada la especialidad no requiera una actualizacion de la materia )', 6, 5, 0, 1, 2, null),
(1, 'EXPERIENCIA DOCENTE  y PRODUCCION ACADEMICA', 7, 2, 3.0, 0, null, 'ri-pencil-ruler-line'), 
	(1, 'experiencia docente internacional pregrado o maestria', 8, 1, 0, 1, 8, null),
	(1, 'EXPERIENCIA ACADEMICA DIVERSA', 9, 2, 0, 1, 8, null),
(1, 'EXPERIENCIA PROFESIONAL', 10, 3, 4.0, 0, null, 'ri-profile-line'),
	(1, 'CARGOS DE DESEMPEÑADOS', 11, 1, 0, 1, 11, null),
	(1, 'PARTICIPACIÓN EN ORGANIZACIONES', 12, 2, 0, 1, 11, null),
	(1, 'PROYECCION SOCIAL', 13, 3, 0, 1, 11, null),
	(1, 'ESPECIALISTA EN AREA DEL DERECHO', 14, 4, 0, 1, 11, null)
go

-- drop table perfil.tippreg_tipo_pregunta
create table perfil.tippreg_tipo_pregunta (
	tippreg_codigo int primary key identity(1, 1),
	tippreg_tipo varchar(50),--C: cerrada, M: multiple, A: abierta, CC: con cascada
	tippreg_descripcion varchar(255),

	--tippreg_multiples_respuestas bit default 0 not null,
	--tippreg_adjuntar_atestados bit default 1 not null,
	--tippreg_rango_de_fechas bit default 0 not null,
	--tippreg_fecha_sola bit default 0 not null,	
	--tippreg_valor_numerico bit default 0 not null,

	tippreg_fecha_creacion datetime default getdate()
)
go
-- select * from perfil.tippreg_tipo_pregunta
insert into perfil.tippreg_tipo_pregunta (tippreg_tipo, tippreg_descripcion) 
values ('C', 'Es una pregunta con respuestas cerradas con atestados'), ('M', 'Es una pregunta con respuestas multiples'), 
('A', 'Es una pregunta con respuesta abierta')
go
insert into perfil.tippreg_tipo_pregunta (tippreg_tipo, tippreg_descripcion, tippreg_adjuntar_atestados, tippreg_rango_de_fechas, tippreg_fecha_sola) 
values ('C', 'Es una pregunta con respuestas cerradas con atestados y rango de fechas', 1, 1, 0),
('C', 'Es una pregunta con respuestas cerradas con atestados y fecha unica', 1, 0, 1)
insert into perfil.tippreg_tipo_pregunta (tippreg_tipo, tippreg_descripcion, tippreg_adjuntar_atestados, tippreg_rango_de_fechas, tippreg_fecha_sola, tippreg_valor_numerico) 
values ('C', 'Es una pregunta con respuestas cerradas con atestados y valor numerico', 1, 0, 0, 1)
go

-- select * from perfil.tippreg_tipo_pregunta
-- drop table perfil.preg_preguntas
create table perfil.preg_preguntas (
	preg_codigo int primary key identity(1, 1),
	preg_codtippreg int foreign key references perfil.tippreg_tipo_pregunta not null,
	preg_codgruperf int foreign key references perfil.gruperf_grupos_perfilamiento not null,
	preg_orden_general int, -- numero de pregunta en la encuesta
	preg_orden int, -- numero de pregunta en el grupo
	preg_pregunta varchar(1024),

	preg_multiples_respuestas bit default 0 not null,
	preg_adjuntar_atestados bit default 1 not null,
	preg_rango_de_fechas bit default 0 not null,
	preg_fecha_sola bit default 0 not null,	
	preg_valor_numerico bit default 0 not null,

	preg_valor_minimo_permitido varchar(10) null,
	preg_valor_maximo_permitido varchar(10) null,
	preg_medida_tiempo varchar(5) null,--h: hora, d: dia, m: mes, y: año

	preg_fecha_creacion datetime default getdate()
)
go
-- select * from perfil.preg_preguntas
insert into perfil.preg_preguntas (preg_codtippreg, preg_codgruperf, preg_orden_general, preg_orden, preg_pregunta) values
(3, 1, 1, 1, 'Grado académico:'),
(3, 1, 2, 2, 'Universidad en que se graduó:'),
(3, 1, 3, 3, 'Año de graduación:'),
(3, 1, 4, 4, 'Fecha de autozación ejercer la abogacia:'),
(3, 1, 5, 5, 'Fecha de autorización para ejercer el noriado:')

insert into perfil.preg_preguntas (preg_codtippreg, preg_codgruperf, preg_orden_general, preg_orden, preg_pregunta) values
(1, 3, 6, 1, 'a) general'), 
(1, 3, 7, 2, 'b) en especialidad'), 
(1, 3, 8, 3, 'Maestria en especialidad de derecho'), 
(1, 3, 9, 4, 'Maestria en educación'), 
(1, 3, 10, 5, 'dos maestrias ( siempre y cuando no se cuente con maestria en educacion , si se cuenta la ponderacion seria de 0.50'), 
 
(1, 4, 11, 1, 'a) general'), 
(1, 4, 12, 2, 'b) competencias virtuales'), 
(1, 4, 13, 3, 'c) especialidad de derecho'), 
(1, 4, 14, 4, 'd)  dos o mas  postgrados de especialidad'), 
 
(1, 5, 15, 1, 'a) general'), 
(1, 5, 16, 2, 'b) especialidad'), 
(1, 5, 17, 3, 'c) internacional')

 insert into perfil.preg_preguntas 
 (preg_codtippreg, preg_codgruperf, preg_orden_general, preg_orden, preg_pregunta, preg_valor_minimo_permitido, preg_valor_maximo_permitido, preg_medida_tiempo, preg_multiples_respuestas) values
(6, 6, 18, 1, 'a) general', 20, 2048, 'h', 1), 
(6, 6, 19, 2, 'b) especialidad', 20, 1024, 'h', 1), 
 
(6, 7, 20, 1, 'a) general', 30, 2048, 'h', 1), 
(6, 7, 21, 2, 'b) especialidad', 30, 2048, 'h', 1)

insert into perfil.preg_preguntas 
(preg_codtippreg, preg_codgruperf, preg_orden_general, preg_orden, preg_pregunta, preg_valor_minimo_permitido, preg_valor_maximo_permitido, preg_medida_tiempo, preg_fecha_sola, preg_multiples_respuestas) values
(5, 7, 22, 3, 'b)extranjero', -5, 0, 'y', 1, 1)

insert into perfil.preg_preguntas (preg_codtippreg, preg_codgruperf, preg_orden_general, preg_orden, preg_pregunta) values
(1, 8, 23, 1, 'Docente universitario adjunto por mas de 1 año'), 
(1, 8, 24, 2, 'Experiencia docente universitario menor a 2 años'), 
(1, 8, 25, 3, 'Experiencia docente universitario de  2 años a 4 años'), 
(1, 8, 26, 4, 'Experiencia docente universitario de 4 años a 8 años'), 
(1, 8, 27, 5, 'Experiencia docente universitario > a 8 años'), 
 
(1, 9, 28, 1, 'menos de un año ( al menos un curso, modulo o su equivalente completo'), 
(1, 9, 29, 2, 'menos de tres  años'), 
(1, 9, 30, 3, 'experiencia docente en preespecialidad/ equivalente o maestria > de 1 año'), 
(1, 9, 31, 4, 'experiencia docente en preespecialidad / equivalente o maestrias > de 3 años'), 
(1, 9, 32, 5, 'experiencia docente en preespecialidad / equivalente o maestrias> de 5 años'), 
 
(1, 10, 33, 1, 'capacitador juridico publico o privado'), 
(1, 10, 34, 2, 'conferencista/ disertador/ expositor/ ponente invitado por ente privado  / publico /  educacion  superior internacional'), 
(1, 10, 35, 3, 'conferencista/ disertador/ expositor/ ponente  invitado por ente privado  / publico /  educacion superior'), 
(1, 10, 36, 4, 'webinarios / coloquios impartidos nacionales'), 
(1, 10, 37, 5, 'webinarios / coloquios impartidos internacionales'), 
(1, 10, 38, 6, 'consultor externo/ interno/ en la materia en sector publico o privado'), 
(1, 10, 39, 7, 'Coautoria y autoria de libros, revistas, ensayos, articulos de Derecho'), 
(1, 10, 40, 8, 'autoria /coautoria de revistas indexadas de derecho'), 
(1, 10, 41, 9, 'participacion en proyectos de ley / investigaciones/ mesas de trabajo en materia de derecho'), 
(1, 10, 42, 10, 'material educativo creado para entes publicos o privados'), 
(1, 10, 43, 11, 'material educativo creado para educacion superior'), 
(1, 10, 44, 12, 'Asesor de tesis, jurado pregrado'), 
(1, 10, 45, 13, 'Asesor de tesis, jurado maestria o equivalente'), 
(1, 10, 46, 14, 'Docente investigador'), 
(1, 10, 47, 15, 'Reconocimiento, mencion hororifica por su labor educativa/ premios o participacion academica'), 
 
(1, 11, 48, 1, 'Tarjeta y sellos de Abogado'), 
(1, 11, 49, 2, 'Sellos de Notario'), 
 
(1, 12, 50, 1, 'Decano, Vicedecano o Director de Escuela'), 
(1, 12, 51, 2, 'Magistrado'), 
(1, 12, 52, 3, 'juez de primera instancia'), 
(1, 12, 53, 4, 'Juez de paz'), 
(1, 12, 54, 5, 'juez suplente'), 
(1, 12, 55, 6, 'secretario de sala'), 
(1, 12, 56, 7, 'secretario de camara'), 
(1, 12, 57, 8, 'Secretario de Juzgado'), 
(1, 12, 58, 9, 'colaborador de sala/ asistente de magistrado'), 
(1, 12, 59, 10, 'colaborador de camara'), 
(1, 12, 60, 11, 'Colaborador de Juzgado'), 
(1, 12, 61, 12, 'Procurado o Fiscal'), 
(1, 12, 62, 13, 'Registrador'), 
(1, 12, 63, 14, 'Jefatura de area juridica especializada ( publica o privada'), 
(1, 12, 64, 15, 'Asesor de instituciones publicas o privadas'), 
(1, 12, 65, 16, 'capacitador CNJ, CSJ u ente afin'), 
(1, 12, 66, 17, 'Agente diplomatico'), 
(1, 12, 67, 18, 'Ejercicio libre de prosesión por mas de 3 años'), 
 
(1, 13, 68, 1, 'Humanitarias'), 
(1, 13, 69, 2, 'profesionales de derecho internacionales'), 
(1, 13, 70, 3, 'Profesionales de derecho'), 
(1, 13, 71, 4, 'Académicas'), 
 
(1, 14, 72, 1, 'participacion en proyeccion social utec < de 1 año'), 
(1, 14, 73, 2, 'participacion en proyeccion social utec < de 2 años'), 
(1, 14, 74, 3, 'participacion en proyeccion social utec > de 3  años'), 
(1, 14, 75, 4, 'participacion en proyectos externos de proyeccion social o afin'), 
 
(1, 15, 76, 1, 'abogado en area de especialidad del derecho ( registral, corporativo, aduanero, bancario, civil y mercantil, penal, financiero , etc) de mas de 2 años'), 
(1, 15, 77, 2, 'abogado en area de especialidad del derecho ( registral, corporativo, aduanero, bancario, civil y mercantil, penal, financiero , etc) de mas de 5 años'), 
(1, 15, 78, 3, 'abogado en area de especialidad del derecho ( registral, corporativo, aduanero, bancario, civil y mercantil, penal, financiero , etc) de mas de 10 años')
go

-- drop table perfil.tipopc_tipopc_opciones
create table perfil.tipopc_tipopc_opciones (
	tipopc_codigo int primary key identity(1, 1),
	tipopc_tipo varchar(50),--c: cerrada, a: abierta, m: multiple
	tipopc_descripcion varchar(255),

	tipopc_fecha_creacion datetime default getdate()
)
go
-- select * from perfil.tipopc_tipopc_opciones
insert into perfil.tipopc_tipopc_opciones (tipopc_tipo, tipopc_descripcion) 
values ('c', 'Es una opcion de respuesta cerrada con atestados'), 
('a', 'Es una opcion de respuesta abierta'), ('af', 'Es una opcion de respuesta abierta con fecha'), ('an', 'Es una opcion de respuesta abierta solo NUMERO'), 
('m', 'Es un opcion de respuesta multiple')
go

-- drop table perfil.opc_opciones
create table perfil.opc_opciones (
	opc_codigo int primary key identity(1, 1),
	opc_opcion varchar(255),
	opc_valor real,
	opc_fecha_creacion datetime default getdate()
)
go
-- select * from perfil.opc_opciones
insert into perfil.opc_opciones (opc_opcion, opc_valor) values
('Escriba: ', 0.0), ('0.2', 0.2), ('0.25', 0.25), ('0.3', 0.3), ('0.35', 0.35), ('0.4', 0.4), ('0.45', 0.45), 
('0.5', 0.5), ('0.55', 0.55), ('0.65', 0.65), ('0.75', 0.75), ('0.8', 0.8), ('1', 1), ('1.25', 1.25), 
('1.4', 1.4), ('1.5', 1.5), ('1.6', 1.6), ('2', 2), ('2.5', 2.5)
, ('0.0', 0.0)
go

-- drop table perfil.pregopc_preguntas_opciones
create table perfil.pregopc_preguntas_opciones (
	pregopc_codigo int primary key identity(1, 1),
	pregopc_codpreg int foreign key references perfil.preg_preguntas not null,
	pregopc_codopc int foreign key references perfil.opc_opciones not null,
	pregopc_codtipopc int foreign key references perfil.tipopc_tipopc_opciones not null,
	pregopc_opc_orden int,

	pregopc_fecha_creacion datetime default getdate()
)
go
-- select * from perfil.pregopc_preguntas_opciones
insert into perfil.pregopc_preguntas_opciones 
(pregopc_codpreg, pregopc_codopc, pregopc_codtipopc, pregopc_opc_orden) 
values
(1, 1, 2, 1), 
(2, 1, 2, 1), 
(3, 1, 4, 1), 
(4, 1, 3, 1), 
(5, 1, 3, 1)
go

insert into perfil.pregopc_preguntas_opciones (pregopc_codpreg, pregopc_codopc, pregopc_codtipopc, pregopc_opc_orden) values
(6, (select opc_codigo from perfil.opc_opciones where opc_valor = 2.00), 1, 1), 
(7, (select opc_codigo from perfil.opc_opciones where opc_valor = 2.50), 1, 1), 
(8, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.00), 1, 1), 
(9, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.00), 1, 1), 
(10, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.00), 1, 1), 
(11, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.50), 1, 1), 
(12, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.55), 1, 1), 
(13, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.75), 1, 1), 
(14, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.50), 1, 1), 
(15, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.50), 1, 1), 
(16, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.75), 1, 1), 
(17, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.80), 1, 1), 
(18, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.25), 1, 1), 
(19, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.50), 1, 1), 
(20, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.20), 1, 1), 
(21, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.40), 1, 1), 
(22, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.65), 1, 1), 
(23, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.25), 1, 1), 
(24, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.50), 1, 1), 
(25, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.00), 1, 1), 
(26, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.50), 1, 1), 
(27, (select opc_codigo from perfil.opc_opciones where opc_valor = 2.00), 1, 1), 
(28, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.00), 1, 1), 
(29, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.50), 1, 1), 
(30, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.00), 1, 1), 
(31, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.50), 1, 1), 
(32, (select opc_codigo from perfil.opc_opciones where opc_valor = 2.50), 1, 1), 
(33, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.25), 1, 1), 
(34, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.45), 1, 1), 
(35, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.40), 1, 1), 
(36, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.20), 1, 1), 
(37, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.25), 1, 1), 
(38, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.25), 1, 1), 
(39, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.50), 1, 1), 
(40, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.65), 1, 1), 
(41, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.50), 1, 1), 
(42, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.25), 1, 1), 
(43, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.35), 1, 1), 
(44, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.50), 1, 1), 
(45, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.65), 1, 1), 
(46, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.50), 1, 1), 
(47, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.50), 1, 1), 
(48, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.50), 1, 1), 
(49, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.50), 1, 1), 
(50, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.50), 1, 1), 
(51, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.50), 1, 1), 
(52, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.25), 1, 1), 
(53, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.00), 1, 1), 
(54, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.75), 1, 1), 
(55, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.00), 1, 1), 
(56, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.00), 1, 1), 
(57, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.75), 1, 1), 
(58, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.00), 1, 1), 
(59, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.00), 1, 1), 
(60, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.50), 1, 1), 
(61, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.25), 1, 1), 
(62, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.75), 1, 1), 
(63, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.00), 1, 1), 
(64, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.75), 1, 1), 
(65, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.25), 1, 1), 
(66, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.50), 1, 1), 
(67, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.00), 1, 1), 
(68, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.25), 1, 1), 
(69, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.30), 1, 1), 
(70, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.25), 1, 1), 
(71, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.25), 1, 1), 
(72, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.25), 1, 1), 
(73, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.35), 1, 1), 
(74, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.40), 1, 1), 
(75, (select opc_codigo from perfil.opc_opciones where opc_valor = 0.20), 1, 1), 
(76, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.25), 1, 1), 
(77, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.40), 1, 1), 
(78, (select opc_codigo from perfil.opc_opciones where opc_valor = 1.60), 1, 1) 
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-10-26 20:36:05.700>
	-- Description: <Devuelve la estructura del instrumento de perfilamiento "codperesc">
	-- =============================================
	-- select * from perfil.vst_estructura_perfilamiento where codperfesc = 1 order by orden_general_grupo, orden_general_pregunta
create or alter view perfil.vst_estructura_perfilamiento
as
	select perfesc_codigo 'codperfesc', perfesc_nombre 'perfilamiento', perfesc_codesc 'codesc', perfesc_fecha_creacion 'fecha_creacion_instrumento', 
		gruperf_codigo 'codgruperf', gruperf_nombre 'nombre_grupo',  gruperf_descripcion 'descripcion_grupo', gruperf_icono 'icono_grupo',
		gruperf_orden 'orden_grupo', gruperf_orden_general 'orden_general_grupo', gruperf_puntos_maximos 'puntos_maximos_grupo', 
		gruperf_padre 'codgruperf_padre', gruperf_peso_grupo 'peso_grupo', 
		preg_codigo 'codpreg', preg_codtippreg 'codtippreg', preg_orden_general 'orden_general_pregunta', preg_orden 'orden_pregunta', 
		preg_pregunta 'pregunta', tippreg_tipo 'tipo_pregunta', tippreg_descripcion 'descripcion_tipo_pregunta', 
		tippreg_adjuntar_atestados 'adjuntar_atestados', tippreg_rango_de_fechas 'rango_de_fechas', tippreg_fecha_sola 'fecha_sola', tippreg_multiples_respuestas 'multiples_respuestas', tippreg_valor_numerico 'valor_numerico',
		preg_valor_minimo_permitido 'valor_minimo_permitido', preg_valor_maximo_permitido 'valor_maximo_permitido', preg_medida_tiempo 'medida_tiempo',
		pregopc_codigo 'codpregopc', 
		pregopc_opc_orden 'opcion_pregunta_orden', opc_codigo 'codopc', opc_opcion 'opcion', opc_valor 'valor_opcion', 
		tipopc_codigo 'codtipopc', tipopc_tipo 'tipo_opcion'
	from perfil.perfesc_perfiles_escuela
		inner join perfil.gruperf_grupos_perfilamiento on gruperf_codperfesc = perfesc_codigo
		left join perfil.preg_preguntas on preg_codgruperf = gruperf_codigo
		left join perfil.tippreg_tipo_pregunta on preg_codtippreg = tippreg_codigo
		left join perfil.pregopc_preguntas_opciones on pregopc_codpreg = preg_codigo
		left join perfil.opc_opciones on pregopc_codopc = opc_codigo
		left join perfil.tipopc_tipopc_opciones on pregopc_codtipopc = tipopc_codigo
go

-- drop table perfil.encperf_encabezado_perfil
create table perfil.encperf_encabezado_perfil (
	encperf_codigo int primary key identity(1, 1),
	encperf_codperfesc int foreign key references perfil.perfesc_perfiles_escuela not null,
	encperf_codemp int,
	encperf_codigo_asipirante int,

	encperf_estado_escuela varchar(3) default 'PEN' not null, --PEN: Pendiente, APR: Aprobado, DEN: Denegado
	encperf_aprobado_escuela bit default null,
	encperf_codemp_revisor_escuela int default null,
	encperf_fecha_revision_escuela datetime null,
	encperf_comentario_general_escuela varchar(1024) default null,
	encperf_documento_adjunto_escuela varchar(1024) default null,

	encperf_estado_rrhh varchar(3) default 'PEN' not null, --PEN: Pendiente, APR: Aprobado, DEN: Denegado
	encperf_aprobado_rrhh bit default null,
	encperf_codemp_revisor_rrhh int default null,
	encperf_fecha_revision_rrhh datetime null,
	encperf_comentario_general_rrhh varchar(1024) default null,
	encperf_documento_adjunto_rrhh varchar(1024) default null,

	encperf_nota_obtenida real default null,
	encperf_fecha_creacion datetime default getdate() not null,
	encperf_fecha_ultima_actualizacion_nota datetime null,
	encperf_ultima_actualizacion_al_perfil_por_persona datetime null,
	encperf_ultima_actualizacion_al_perfil_por_escuela datetime null
)
go
-- select * from perfil.encperf_encabezado_perfil
--insert into perfil.encperf_encabezado_perfil (encperf_codperfesc, encperf_codemp) values (1, 276), (1, 4291)

-- drop table perfil.detperf_detalle_perfil
create table perfil.detperf_detalle_perfil(
	detperf_codigo int primary key identity(1, 1),
	detperf_codencperf int foreign key references perfil.encperf_encabezado_perfil not null,
	detperf_codpregopc int foreign key references perfil.pregopc_preguntas_opciones not null,
		  
	detperf_link_atestado varchar(150) not null default '',
	detperf_fecha_desde date default null,
	detperf_fecha_hasta date default null, 
	
	detperf_estado_escuela varchar(3) default 'PEN' not null, --PEN: Pendiente, APR: Aprobado, DEN: Denegado
	detperf_codemp_revisado_por varchar(100) default null,
	detperf_fecha_revisado_por datetime null,

	detperf_detalle varchar(2048) null,--Si es abierta se llenara
	detperf_fecha_creacion datetime default getdate(),
	
	detperf_comentario_persona varchar(1024) null,
	detperf_comentario_revisor varchar(1024) null,
	detperf_ultima_version bit default 1
)
go
-- select * from perfil.detperf_detalle_perfil
--insert into perfil.detperf_detalle_perfil (detperf_codencperf, detperf_codpregopc, detperf_link_atestado, detperf_fecha_desde, detperf_fecha_hasta, detperf_detalle) 
--values (1, 6, 'www.google.com', null, null, null), (2, 6, 'www.titter.com', null, null, null)
--go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-10-26 22:25:55.813>
	-- Description: <Devuelve el encabezado del perfilamiento docente>
	-- =============================================
	-- select * from perfil.vst_encabezado_perfilamiento where codperfesc = 1 and codigo_empleado = 4291
create or alter view perfil.vst_encabezado_perfilamiento
as
	select encperf_codigo 'codencperf', 
		case 
		when encperf_estado_escuela = 'APR' and encperf_estado_rrhh = 'APR' then 'APR' 
		when encperf_estado_escuela = 'DEN' or encperf_estado_rrhh = 'DEN' then 'DEN' 
		when encperf_estado_escuela = 'PEN' or encperf_estado_rrhh = 'PEN' then 'PEN' 
		else '-'
		END 'estado_general',  
		case 
		when encperf_estado_escuela = 'APR' and encperf_estado_rrhh = 'APR' then '¡Perfilamiento docente aprobado!' 
		when encperf_estado_escuela = 'DEN' or encperf_estado_rrhh = 'DEN' then 'Denegado' 
		when encperf_estado_escuela = 'PEN' then 'En revision por responsable de escuela' 
		when encperf_estado_escuela = 'APR' or encperf_estado_rrhh = 'PEN' then 'En revision por recursos humanos' 
		else '-'
		END 'estado_general_texto', 
		encperf_codperfesc 'codperfesc', v.escuela, perfesc_codesc 'codesc', 
		perfesc_nombre 'nombre_perfilamiento', perfesc_nota_minima 'nota_minima', isnull(emp.emp_codigo, aspirante.emp_codigo) 'codigo_empleado', 
		trim(isnull(emp.emp_apellidos_nombres, aspirante.emp_apellidos_nombres)) 'nombre', isnull(emp.emp_sexo, aspirante.emp_sexo) 'sexo',
		isnull(emp.emp_email_institucional, aspirante.emp_email_institucional)'correo_empleado',
		encperf_nota_obtenida 'nota_obtenida', 
		encperf_estado_escuela 'estado_escuela', 
		v.correos_responsables_escuela 'correos_responsables_escuela',
		encperf_aprobado_escuela 'aprobado_escuela', encperf_fecha_revision_escuela 'fecha_revision_escuela', escuela.emp_codigo 'codemp_revisor_escuela', escuela.emp_nombres_apellidos 'revisor_escuela',
		encperf_estado_rrhh 'estado_rrhh',
		encperf_aprobado_rrhh 'aprobado_rrhh', encperf_fecha_revision_rrhh 'fecha_revision_rrhh', rrhh.emp_codigo 'codemp_revisor_rrhh', rrhh.emp_nombres_apellidos 'revisor_rrhh',
		encperf_fecha_creacion 'fecha_creacion', encperf_fecha_ultima_actualizacion_nota 'fecha_ultima_actualizacion_nota', 
		encperf_ultima_actualizacion_al_perfil_por_persona 'ultima_actualizacion_al_perfil_por_persona', encperf_ultima_actualizacion_al_perfil_por_escuela 'ultima_actualizacion_al_perfil_por_escuela',
		encperf_comentario_general_escuela 'comentario_general_escuela', encperf_documento_adjunto_escuela 'documento_adjunto_escuela', encperf_comentario_general_rrhh 'comentario_general_rrhh', encperf_documento_adjunto_rrhh 'documento_adjunto_rrhh'
	from perfil.encperf_encabezado_perfil
		inner join perfil.perfesc_perfiles_escuela on encperf_codperfesc = perfesc_codigo
		left join perfil.vst_perfiles_escuelas_disponibles v on v.codperfesc = perfesc_codigo
		left join uonline.dbo.pla_emp_empleado emp on emp.emp_codigo = encperf_codemp
		--left join a tabla de aspirantes
		left join uonline.dbo.pla_emp_empleado aspirante on aspirante.emp_codigo = encperf_codigo_asipirante

		left join uonline.dbo.pla_emp_empleado escuela on escuela.emp_codigo = encperf_codemp_revisor_escuela
		left join uonline.dbo.pla_emp_empleado rrhh on rrhh.emp_codigo = encperf_codemp_revisor_rrhh
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-10-26 21:18:34.273>
	-- Description: <Devuelve el detalle del perfilamiento docente>
	-- =============================================
	-- select * from perfil.vst_respuestas_perfilamiento where codperfesc = 1 and codigo_empleado = 4291
create or alter view perfil.vst_respuestas_perfilamiento
as
	select v.codperfesc, v2.codencperf, v.codpregopc, v2.codigo_empleado, v2.nombre, v2.sexo 'sexo', v2.correo_empleado 'correo_empleado',
		v.nombre_grupo, v.puntos_maximos_grupo, v.codpreg, v.pregunta, v.codopc, v.opcion, v.valor_opcion,
		detperf_codigo 'coddetperf', detperf_link_atestado 'link_atestado', 
		detperf_fecha_desde 'validez_fecha_desde', detperf_fecha_hasta 'validez_fecha_hasta', 
		detperf_estado_escuela 'estado_escuela',
		revisor.emp_codigo 'detalle_codemp_revisado_por', revisor.emp_nombres_apellidos 'detalle_revisando_por', revisor.emp_email_empresarial, detperf_detalle 'detalle_respuesta',
		v2.nota_obtenida, v2.fecha_ultima_actualizacion_nota, detperf_ultima_version 'ultima_version', detperf_comentario_persona 'comentario_persona', detperf_comentario_revisor 'comentario_revisor',
		detperf_fecha_revisado_por 'fecha_revisado_por', detperf_codemp_revisado_por 'codemp_revisado_por'
	from perfil.vst_estructura_perfilamiento v
		left join perfil.detperf_detalle_perfil on detperf_codpregopc = v.codpregopc
		left join perfil.vst_encabezado_perfilamiento v2 on detperf_codencperf = v2.codencperf
		left join uonline.dbo.pla_emp_empleado revisor on revisor.emp_codigo = detperf_codemp_revisado_por
go

-- drop type perfil.tbl_detperf
create type perfil.tbl_detperf as table(
	detperf_codigo int,
	detperf_codencperf int,
	detperf_codpregopc int,
		  
	detperf_link_atestado varchar(150) not null,
	detperf_fecha_desde date default null,
	detperf_fecha_hasta date default null, 
	detperf_detalle varchar(2048) null,--Si es abierta se llenara
	
	detperf_estado_escuela varchar(3) null,
	detperf_codemp_revisado_por varchar(100) default null,
	detperf_fecha_revisado_por datetime null,

	detperf_comentario_persona varchar(1024) null,
	detperf_comentario_revisor varchar(1024) null,
	detperf_ultima_version bit
)
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-10-26 22:00:55.190>
	-- Description: <Devuelve la data de de las respuestas del perfilamiento>
	-- =============================================
	-- exec perfil.sp_respuestas_perfilamiento @opcion = 1, @codperfesc = 1, @codigo_empleado = 4291, @codencperf = 1
create or alter procedure perfil.sp_respuestas_perfilamiento
	@opcion int = 0,
	@codperfesc int = 0,
	@codigo_empleado int = 0,
	@codencperf int = 0
as
begin
	
	if @opcion = 1 -- Respuestas realizadas al perfilamiento por el docente
	begin
		declare @yaRespondio bit
		select @yaRespondio = count(1) from perfil.vst_encabezado_perfilamiento where codencperf = @codencperf

		select v2.orden_general_grupo, v2.orden_general_pregunta, v2.codgruperf, v2.nombre_grupo, v2.puntos_maximos_grupo, v2.tipo_pregunta, 
			v2.adjuntar_atestados, v2.fecha_sola, v2.rango_de_fechas, v2.multiples_respuestas, v2.valor_numerico,
			v2.valor_minimo_permitido, v2.valor_maximo_permitido, v2.medida_tiempo,
			v2.codpreg, v2.codgruperf_padre, v2.icono_grupo, v2.descripcion_grupo,
			v2.pregunta, v2.tipo_opcion, v2.codopc, v2.opcion, v2.valor_opcion, v2.codpregopc, 
			case when isnull(coddetperf, 0) <> 0 then 'Si' when @yaRespondio = 1 then 'No' else null end 'seleccionada', v1.codigo_empleado, v1.codencperf, 
			v1.coddetperf, v1.link_atestado, v1.validez_fecha_desde, v1.validez_fecha_hasta, v1.estado_escuela, v1.detalle_respuesta, 
			v1.detalle_codemp_revisado_por, v1.detalle_revisando_por, v1.nota_obtenida, v1.fecha_ultima_actualizacion_nota,
			v1.ultima_version, comentario_persona, comentario_revisor, fecha_revisado_por
		from perfil.vst_estructura_perfilamiento v2
			left join perfil.vst_respuestas_perfilamiento v1  on v1.codpregopc = v2.codpregopc and v2.codperfesc = @codperfesc and v1.codigo_empleado = @codigo_empleado
				and codencperf = @codencperf and ultima_version = 1
		order by v2.orden_general_grupo, v2.orden_general_pregunta
	end

end
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-10-30 09:28:23.017>
	-- Description: <Inserta la data del perfilamiento>
	-- =============================================
	-- exec perfil.sp_insertar_encabezado_perfilamiento @opcion = 1, @codperfesc = 1, @codigo_empleado = 4291
create or alter procedure perfil.sp_insertar_encabezado_perfilamiento
	@opcion int = 0,
	@codperfesc int = 0,
	@codigo_empleado int = 0,

	@codencperf int = 0
as
begin
	
	if @opcion = 1 -- Inserta el detalle de las respuestas
	begin
		select @codencperf = codencperf from perfil.vst_encabezado_perfilamiento where codigo_empleado = @codigo_empleado and codperfesc = @codperfesc
		if isnull(@codencperf, '') = ''
		begin
			insert into perfil.encperf_encabezado_perfil (encperf_codperfesc, encperf_codemp) values (@codperfesc, @codigo_empleado)
			set @codencperf = @@IDENTITY

			select 1 'res', 'Perfil insertado, código: ' + cast(@codencperf as varchar(5)) 'msj', @codencperf 'codencperf'
			return
		end
		
		update perfil.encperf_encabezado_perfil set encperf_ultima_actualizacion_al_perfil_por_persona = getdate() where encperf_codigo = @codencperf
		select -1 'res', 'Ya existe un perfil creado para el empleado código ' + cast(@codigo_empleado as varchar(6)) 
		+ ' solicitud número: ' + cast(@codencperf as varchar(5)) 'msj', @codencperf 'codencperf'
		return

	end

end
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-11-02 20:55:53.9263767-06:00>
	-- Description: <Inserta la data del perfilamiento>
	-- =============================================
	-- exec perfil.sp_insertar_respuestas_perfilamiento @opcion = 1, @codperfesc = 1, @codigo_empleado = 276
create or alter procedure perfil.sp_insertar_respuestas_perfilamiento
	@opcion int = 0,
	@codperfesc int = 0,
	@codigo_empleado int = 0,

	@codencperf int = 0
	,@tbl_detperf perfil.tbl_detperf readonly
as
begin
	
	if @opcion = 1 -- Inserta el detalle de las respuestas
	begin
		if (select count(1) from @tbl_detperf) = 0
		begin
			select -2 'res', 'El detalle de perfilamiento no puede ser vacio' 'msj', @codencperf 'codencperf'
		end
		else
		begin
			
			update detperf set detperf.detperf_ultima_version = 0
			from perfil.detperf_detalle_perfil detperf
				inner join perfil.encperf_encabezado_perfil encperf on detperf.detperf_codencperf = encperf.encperf_codigo
				inner join @tbl_detperf tbl on tbl.detperf_codpregopc = detperf.detperf_codpregopc
			where encperf.encperf_codigo = @codencperf
			
			update perfil.encperf_encabezado_perfil set encperf_ultima_actualizacion_al_perfil_por_persona = getdate() where encperf_codigo = @codencperf

			insert into perfil.detperf_detalle_perfil 
			(detperf_codencperf, detperf_codpregopc, detperf_link_atestado, detperf_fecha_desde, detperf_fecha_hasta, detperf_detalle, detperf_ultima_version, detperf_comentario_persona, detperf_estado_escuela)
			select @codencperf, t.detperf_codpregopc, t.detperf_link_atestado, t.detperf_fecha_desde, t.detperf_fecha_hasta, t.detperf_detalle, 1, t.detperf_comentario_persona, t.detperf_estado_escuela from @tbl_detperf t

			select 1 'res', 'Detalle de perfilamiento guardado con éxito' 'msj', @codencperf 'codencperf'
		end
	end
	
	if @opcion = 2 -- Actualiza el detalle de las respuestas, usado por la escuela
	begin
		if (select count(1) from @tbl_detperf) = 0
		begin
			select -2 'res', 'El detalle de perfilamiento no puede ser vacio' 'msj', @codencperf 'codencperf'
		end
		else
		begin
			
			update detperf set detperf.detperf_estado_escuela = tbl.detperf_estado_escuela, 
			detperf.detperf_codemp_revisado_por = tbl.detperf_codemp_revisado_por,
			detperf.detperf_fecha_revisado_por = getdate(),
			detperf.detperf_comentario_revisor = tbl.detperf_comentario_revisor
			from perfil.detperf_detalle_perfil detperf
				inner join perfil.encperf_encabezado_perfil encperf on detperf.detperf_codencperf = encperf.encperf_codigo
				inner join @tbl_detperf tbl on tbl.detperf_codigo = detperf.detperf_codigo
			where encperf.encperf_codigo = @codencperf

			update perfil.encperf_encabezado_perfil set encperf_ultima_actualizacion_al_perfil_por_escuela = getdate() where encperf_codigo = @codencperf

			select 1 'res', '¡Estados de perfilamiento actualizados con éxito!, actualizados: ' + cast((select count(1) from @tbl_detperf) as varchar(5)) 'msj', @codencperf 'codencperf'
		end
	end
end
go

