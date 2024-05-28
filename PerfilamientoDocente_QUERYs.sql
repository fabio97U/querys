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
('PSICOLOGIA 2023 24 mayo', 8, 6),
('PERFIL DOCENTE - Facultad de Maestrías', 10, 6)
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
values (1, 268), (2, 2356), (3, 759), (4, 315), --(4, 4291), 

(5, 1228), (6, 1228),(7, 1228), (8, 1228), (9, 1228), 
(5, 3379), (6, 3379),(7, 3379), (8, 3379), (9, 3379), 

(10, 315), (11, 759), (12, 315), (13, 2340), (13, 777)
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
	--gruperf_peso_grupo int default 0, --Entre menor peso es elevado, es para solventar los sub-grupos, los peso 0 son los princiaples
	gruperf_fecha_creacion datetime default getdate()
)
go
-- select * from perfil.gruperf_grupos_perfilamiento order by gruperf_orden_general
--insert into perfil.gruperf_grupos_perfilamiento 
--(gruperf_codperfesc, gruperf_nombre, gruperf_orden_general, gruperf_orden, gruperf_puntos_maximos, gruperf_peso_grupo, gruperf_padre, gruperf_icono) values
--(1, 'DATOS GENERALES', 0, 0, 0, 0, null, 'ri-user-line'),
--(1, 'FORMACIÓN y  PRODUCCION ACADEMICA/ FORMATIVA', 1, 1, 3.0, 0, null, 'ri-contacts-book-2-line'), 
--	(1, 'Doctorado en derecho ', 2, 1, 0, 1, 2, null),
--	(1, 'Posgrado:', 3, 2, 0, 1, 2, null),
--	(1, 'Diplomados ', 4, 3, 0, 1, 2, null),
--	(1, 'Seminarios (mínimo de tiempo 20 horas  y que dada la especialidad no requiera una actualizacion en la materia.', 5, 4, 0, 1, 2, null),
--	(1, 'Cursos  ( minimo 30 horas  y que dada la especialidad no requiera una actualizacion de la materia )', 6, 5, 0, 1, 2, null),
--	(1, 'Capacitaciones de especialidad (5 años de vigencia )', 7, 6, 0, 1, 2, null),
--(1, 'EXPERIENCIA DOCENTE  y PRODUCCION ACADEMICA', 8, 2, 3.0, 0, null, 'ri-pencil-ruler-line'), 
--	(1, 'experiencia docente internacional pregrado o maestria', 9, 1, 0, 1, 9, null),
--	(1, 'EXPERIENCIA ACADEMICA DIVERSA', 10, 2, 0, 1, 9, null),
--(1, 'EXPERIENCIA PROFESIONAL', 11, 3, 4.0, 0, null, 'ri-profile-line'),
--	(1, 'CARGOS DE DESEMPEÑADOS', 12, 1, 0, 1, 12, null),
--	(1, 'PARTICIPACIÓN EN ORGANIZACIONES', 13, 2, 0, 1, 12, null),
--	(1, 'PROYECCION SOCIAL', 14, 3, 0, 1, 12, null),
--	(1, 'ESPECIALISTA EN AREA DEL DERECHO', 15, 4, 0, 1, 12, null)
--go

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
--insert into perfil.tippreg_tipo_pregunta (tippreg_tipo, tippreg_descripcion, tippreg_adjuntar_atestados, tippreg_rango_de_fechas, tippreg_fecha_sola) 
--values ('C', 'Es una pregunta con respuestas cerradas con atestados y rango de fechas', 1, 1, 0),
--('C', 'Es una pregunta con respuestas cerradas con atestados y fecha unica', 1, 0, 1)
--insert into perfil.tippreg_tipo_pregunta (tippreg_tipo, tippreg_descripcion, tippreg_adjuntar_atestados, tippreg_rango_de_fechas, tippreg_fecha_sola, tippreg_valor_numerico) 
--values ('C', 'Es una pregunta con respuestas cerradas con atestados y valor numerico', 1, 0, 0, 1)
--go

-- select * from perfil.tippreg_tipo_pregunta
-- drop table perfil.preg_preguntas
create table perfil.preg_preguntas (
	preg_codigo int primary key identity(1, 1),
	preg_codtippreg int foreign key references perfil.tippreg_tipo_pregunta not null,
	preg_codgruperf int foreign key references perfil.gruperf_grupos_perfilamiento not null,
	preg_orden_general real, -- numero de pregunta en la encuesta, en el resultado esto es dinamico por las preguntas extras que puede agregar el usuarios
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

	preg_tiene_vencimiento bit default 1 not null,

	preg_fecha_creacion datetime default getdate()
)
go
-- select * from perfil.preg_preguntas
--insert into perfil.preg_preguntas (preg_codtippreg, preg_codgruperf, preg_orden_general, preg_orden, preg_pregunta) values
--(3, 1, 1, 1, 'Grado académico:'),
--(3, 1, 2, 2, 'Universidad en que se graduó:'),

--insert into perfil.preg_preguntas (preg_codtippreg, preg_codgruperf, preg_orden_general, preg_orden, preg_pregunta) values
--(1, 3, 6, 1, 'Nivel de ingles'), 
--(1, 3, 7, 2, 'b) en especialidad'), 
--(1, 3, 8, 3, 'Maestria en especialidad de derecho'), 

--insert into perfil.preg_preguntas 
--(preg_codtippreg, preg_codgruperf, preg_orden_general, preg_orden, preg_pregunta, preg_valor_minimo_permitido, preg_valor_maximo_permitido, preg_medida_tiempo, preg_multiples_respuestas, preg_valor_numerico) values
--(1, 6, 18, 1, 'a) general', 20, 2048, 'h', 1, 1), 
--(1, 6, 19, 2, 'b) especialidad', 20, 2048, 'h', 1, 1), 

--insert into perfil.preg_preguntas 
--(preg_codtippreg, preg_codgruperf, preg_orden_general, preg_orden, preg_pregunta, preg_valor_minimo_permitido, preg_valor_maximo_permitido, preg_medida_tiempo, preg_fecha_sola, preg_multiples_respuestas) values
--(1, 7, 22, 3, 'b)extranjero', -5, 0, 'y', 1, 1)

--insert into perfil.preg_preguntas (preg_codtippreg, preg_codgruperf, preg_orden_general, preg_orden, preg_pregunta) values
--(1, 8, 23, 1, 'Docente universitario adjunto por mas de 1 año'), 
--(1, 8, 24, 2, 'Experiencia docente universitario menor a 2 años'), 
--go

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
	opc_es_no bit not null default 0, 
	opc_codperfesc int foreign key references perfil.perfesc_perfiles_escuela,
	opc_fecha_creacion datetime default getdate()
)
go
-- select * from perfil.opc_opciones
--insert into perfil.opc_opciones (opc_opcion, opc_valor, opc_es_no, opc_codperfesc) values
--('Escriba: ', 0.0, 0, 1), ('No', 0.0, 1, 1)
--go
--insert into perfil.opc_opciones (opc_opcion, opc_valor, opc_codperfesc) values
--('0.2', 0.2, 1), ('0.25', 0.25, 1), ('0.3', 0.3, 1), ('0.35', 0.35, 1), ('0.4', 0.4, 1), ('0.45', 0.45, 1), 
--('0.5', 0.5, 1), ('0.55', 0.55, 1), ('0.65', 0.65, 1), ('0.75', 0.75, 1), ('0.8', 0.8, 1), ('1', 1, 1), ('1.25', 1.25, 1), 
--('1.4', 1.4, 1), ('1.5', 1.5, 1), ('1.6', 1.6, 1), ('2', 2, 1), ('2.5', 2.5, 1)
--, ('0.0', 0.0, 1), ('0.330 Bajo', 0.25, 1), ('331 a 660 Intermedio', 0.50, 1), ('661 a 990 Avanzado', 0.75, 1)
--go

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
--insert into perfil.pregopc_preguntas_opciones 
--(pregopc_codpreg, pregopc_codopc, pregopc_codtipopc, pregopc_opc_orden) 
--values
--(1, 1, 2, 1), 
--(2, 1, 2, 1), 
--(3, 1, 4, 1), 
--(4, 1, 3, 1), 
--(5, 1, 3, 1)
--go

--insert into perfil.pregopc_preguntas_opciones (pregopc_codpreg, pregopc_codopc, pregopc_codtipopc, pregopc_opc_orden) values
----(6, (select opc_codigo from perfil.opc_opciones where opc_valor = 2.00), 1, 1), 
--(6, (select top 1 opc_codigo from perfil.opc_opciones where opc_opcion = '0.330 Bajo'), 1, 1), 
--(6, (select top 1 opc_codigo from perfil.opc_opciones where opc_opcion = '331 a 660 Intermedio'), 1, 2), 
--(6, (select top 1 opc_codigo from perfil.opc_opciones where opc_opcion = '661 a 990 Avanzado'), 1, 3), 
--(6, (select top 1 opc_codigo from perfil.opc_opciones where opc_opcion = 'No'), 1, 4), 

--(7, (select top 1 opc_codigo from perfil.opc_opciones where opc_valor = 2.50), 1, 1), 
--(7, (select top 1 opc_codigo from perfil.opc_opciones where opc_opcion = 'No'), 1, 2)
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
		gruperf_padre 'codgruperf_padre', /*gruperf_peso_grupo 'peso_grupo', */
		preg_codigo 'codpreg', preg_codtippreg 'codtippreg', preg_orden_general 'orden_general_pregunta', preg_orden 'orden_pregunta', preg_tiene_vencimiento 'tiene_vencimiento',
		preg_pregunta 'pregunta', tippreg_tipo 'tipo_pregunta', tippreg_descripcion 'descripcion_tipo_pregunta', 
		preg_adjuntar_atestados 'adjuntar_atestados', preg_rango_de_fechas 'rango_de_fechas', preg_fecha_sola 'fecha_sola', preg_multiples_respuestas 'multiples_respuestas', preg_valor_numerico 'valor_numerico',
		preg_valor_minimo_permitido 'valor_minimo_permitido', preg_valor_maximo_permitido 'valor_maximo_permitido', preg_medida_tiempo 'medida_tiempo',
		pregopc_codigo 'codpregopc', 
		pregopc_opc_orden 'opcion_pregunta_orden', opc_codigo 'codopc', opc_opcion 'opcion', opc_valor 'valor_opcion', opc_es_no 'es_no',
		tipopc_codigo 'codtipopc', tipopc_tipo 'tipo_opcion', 'ri-message-line' 'class_icono_comentarios'
	from perfil.perfesc_perfiles_escuela
		inner join perfil.gruperf_grupos_perfilamiento on gruperf_codperfesc = perfesc_codigo
		left join perfil.preg_preguntas on preg_codgruperf = gruperf_codigo
		left join perfil.tippreg_tipo_pregunta on preg_codtippreg = tippreg_codigo
		left join perfil.pregopc_preguntas_opciones on pregopc_codpreg = preg_codigo
		left join perfil.opc_opciones on pregopc_codopc = opc_codigo and opc_codperfesc = perfesc_codigo
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
	encperf_ultima_actualizacion_al_perfil_por_escuela datetime null,
	encperf_guid varchar(36) not null,
	encperf_link_resumen_perfil varchar(255) not null
)
go
-- select * from perfil.encperf_encabezado_perfil
--insert into perfil.encperf_encabezado_perfil (encperf_codperfesc, encperf_codemp) values (1, 276), (1, 4291)
-- delete from perfil.encperf_encabezado_perfil

-- drop table perfil.detperf_detalle_perfil
create table perfil.detperf_detalle_perfil(
	detperf_codigo int primary key identity(1, 1),
	detperf_codencperf int foreign key references perfil.encperf_encabezado_perfil not null,
	detperf_codpreg int foreign key references perfil.preg_preguntas not null,
	detperf_codopc int foreign key references perfil.opc_opciones not null,
	detperf_codpregopc int foreign key references perfil.pregopc_preguntas_opciones not null,
		  
	detperf_link_atestado varchar(150) not null default '',
	detperf_fecha_desde date default null,
	detperf_fecha_hasta date default null, 
	
	detperf_estado_escuela varchar(3) default 'PEN' not null, --PEN: Pendiente, APR: Aprobado, DEN: Denegado
	detperf_codemp_revisado_por varchar(100) default null,
	detperf_fecha_revisado_por datetime null,

	detperf_detalle varchar(2048) null,--Si es abierta se llenara
	detperf_fecha_creacion datetime default getdate(),
	detperf_orden_general_pregunta real null, -- numero de pregunta en la encuesta, es dinamico por las preguntas extras que añade el usuario
	detperf_comentario_persona varchar(1024) null,
	detperf_comentario_revisor varchar(1024) null,
	detperf_ultima_version bit default 1,
	detperf_tiene_vencimiento bit default 1 not null
)
go
-- select * from perfil.detperf_detalle_perfil
-- delete from perfil.detperf_detalle_perfil

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
		encperf_comentario_general_escuela 'comentario_general_escuela', encperf_documento_adjunto_escuela 'documento_adjunto_escuela', encperf_comentario_general_rrhh 'comentario_general_rrhh', encperf_documento_adjunto_rrhh 'documento_adjunto_rrhh',
		aga_hora_normal 'valor_hora_actual', aga_descripcion,
		(select top 1 titulo from uonline.dbo.vst_titulos_empleados v where v.codemp = emp.emp_codigo order by tti_prioridad) 'ultimo_titulo',
		encperf_guid,
		encperf_link_resumen_perfil 'link_resumen_perfil', 0 'posee_contrato'
	from perfil.encperf_encabezado_perfil
		inner join perfil.perfesc_perfiles_escuela on encperf_codperfesc = perfesc_codigo
		left join perfil.vst_perfiles_escuelas_disponibles v on v.codperfesc = perfesc_codigo
		left join uonline.dbo.pla_emp_empleado emp on emp.emp_codigo = encperf_codemp
		--left join a tabla de aspirantes
		left join uonline.dbo.pla_emp_empleado aspirante on aspirante.emp_codigo = encperf_codigo_asipirante

		left join uonline.dbo.pla_emp_empleado escuela on escuela.emp_codigo = encperf_codemp_revisor_escuela
		left join uonline.dbo.pla_emp_empleado rrhh on rrhh.emp_codigo = encperf_codemp_revisor_rrhh

		left join uonline.dbo.pla_aga_arancel_grado_acad on aga_grado = emp.emp_gacademico 
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-10-26 21:18:34.273>
	-- Description: <Devuelve el detalle del perfilamiento docente>
	-- =============================================
	-- select * from perfil.vst_respuestas_perfilamiento where codperfesc = 11 and codigo_empleado = 4352 order by detperf_orden_general_pregunta
create or alter view perfil.vst_respuestas_perfilamiento
as
	select v.codperfesc, v2.codencperf, v.codpregopc, v2.codigo_empleado, v2.nombre, v2.sexo 'sexo', v2.correo_empleado 'correo_empleado',
		v.nombre_grupo, v.puntos_maximos_grupo, v.codpreg, v.pregunta, v.tiene_vencimiento, v.codopc, v.opcion_pregunta_orden, v.opcion, v.valor_opcion, es_no,
		detperf_codigo 'coddetperf', detperf_link_atestado 'link_atestado', 
		detperf_fecha_desde 'validez_fecha_desde', detperf_fecha_hasta 'validez_fecha_hasta', 
		detperf_estado_escuela 'estado_escuela',
		revisor.emp_codigo 'detalle_codemp_revisado_por', revisor.emp_nombres_apellidos 'detalle_revisando_por', revisor.emp_email_empresarial, detperf_detalle 'detalle_respuesta',
		v2.nota_obtenida, v2.fecha_ultima_actualizacion_nota, detperf_ultima_version 'ultima_version', detperf_comentario_persona 'comentario_persona', detperf_comentario_revisor 'comentario_revisor',
		detperf_fecha_revisado_por 'fecha_revisado_por', detperf_codemp_revisado_por 'codemp_revisado_por', detperf_orden_general_pregunta, v2.encperf_guid,
		detperf_fecha_creacion 'fecha_creacion_detalle', v.codgruperf_padre, v.codgruperf
	from perfil.vst_estructura_perfilamiento v
		left join perfil.detperf_detalle_perfil on detperf_codpregopc = v.codpregopc-- and orden_general_grupo = v.orden_general_pregunta
		left join perfil.vst_encabezado_perfilamiento v2 on detperf_codencperf = v2.codencperf
		left join uonline.dbo.pla_emp_empleado revisor on revisor.emp_codigo = detperf_codemp_revisado_por
go

-- drop type perfil.tbl_detperf
create type perfil.tbl_detperf as table(
	detperf_codigo int,
	detperf_codencperf int,
	detperf_codpreg int,
	detperf_codopc int,
	detperf_codpregopc int,
		  
	detperf_link_atestado varchar(150) not null,
	detperf_fecha_desde nvarchar(19) default null,
	detperf_fecha_hasta nvarchar(19) default null, 
	detperf_detalle varchar(2048) null,--Si es abierta se llenara
	
	detperf_estado_escuela varchar(3) null,
	detperf_codemp_revisado_por varchar(100) default null,
	detperf_fecha_revisado_por nvarchar(19) null,

	detperf_comentario_persona varchar(1024) null,
	detperf_comentario_revisor varchar(1024) null,
	detperf_ultima_version bit,
	detperf_orden_general_pregunta real null,
	detperf_tiene_vencimiento bit default 1 not null
)
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-10-26 22:00:55.190>
	-- Description: <Devuelve la data de de las respuestas del perfilamiento>
	-- =============================================
	-- exec perfil.sp_respuestas_perfilamiento @opcion = 1, @codperfesc = 3, @codigo_empleado = 4739, @codencperf = 3
create or alter procedure perfil.sp_respuestas_perfilamiento
	@opcion int = 0,
	@codperfesc int = 0,
	@codigo_empleado int = 0,
	@codencperf int = 0
as
begin

	if @opcion = 1 -- Respuestas realizadas al perfilamiento por el docente
	begin
		declare @yaRespondio bit, @mostrarComentarios bit = 0
		select @yaRespondio = count(1) from perfil.vst_encabezado_perfilamiento where codencperf = @codencperf and codperfesc = @codperfesc

		select v2.codperfesc, v2.orden_general_grupo, isnull(v1_res.detperf_orden_general_pregunta, v2.orden_general_pregunta) 'orden_general_pregunta', v2.codgruperf, v2.nombre_grupo, v2.puntos_maximos_grupo, v2.tipo_pregunta, 
			v2.adjuntar_atestados, v2.fecha_sola, v2.rango_de_fechas, v2.multiples_respuestas, v2.valor_numerico,
			v2.valor_minimo_permitido, v2.valor_maximo_permitido, v2.medida_tiempo,
			v2.codpreg, v2.codgruperf_padre, v2.icono_grupo, v2.descripcion_grupo,
			v2.pregunta, v2.tiene_vencimiento, v2.tipo_opcion, v2.codopc, v2.opcion_pregunta_orden, v2.opcion, v2.valor_opcion, v2.es_no 'es_no', v2.codpregopc 'codpregopc', 
			case when isnull(coddetperf, 0) <> 0 then cast(v2.codopc as varchar(5)) when @yaRespondio = 1 then 'No' else null end 'seleccionada', v1_res.codigo_empleado, v1_res.codencperf, 
			v1_res.coddetperf, v1_res.link_atestado, v1_res.validez_fecha_desde, v1_res.validez_fecha_hasta, v1_res.estado_escuela, v1_res.detalle_respuesta, 
			v1_res.detalle_codemp_revisado_por, v1_res.detalle_revisando_por, v1_res.nota_obtenida, v1_res.fecha_ultima_actualizacion_nota,
			v1_res.ultima_version, comentario_persona, comentario_revisor, fecha_revisado_por, v1_res.detperf_orden_general_pregunta,
			isnull(@mostrarComentarios, 0) 'mostrar_comentarios', class_icono_comentarios, encperf_guid
		from perfil.vst_estructura_perfilamiento v2
			left join perfil.vst_respuestas_perfilamiento v1_res  on v1_res.codpregopc = v2.codpregopc and v1_res.codperfesc = @codperfesc 
				and v1_res.codigo_empleado = @codigo_empleado and v1_res.codperfesc = @codperfesc and codencperf = @codencperf and ultima_version = 1
		where v2.codperfesc = @codperfesc
		order by v2.orden_general_grupo, v2.orden_general_pregunta, v1_res.coddetperf desc, v2.opcion_pregunta_orden
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
			declare @guid varchar(50) = newid()
			declare @link_resumen varchar(255) = ''
			set @link_resumen = 
			concat('https://reportes.utec.edu.sv/demo/reporte.aspx?reporte=rep_perfil_llenado&filas=', dbo.uFnStringToBase64('4'),
				'&campo0=', dbo.uFnStringToBase64('1'),'&campo1=', dbo.uFnStringToBase64(@codigo_empleado),'&campo2=', dbo.uFnStringToBase64(@guid),'&campo3=', dbo.uFnStringToBase64('0'),'&tipo_archivo=P')

			insert into perfil.encperf_encabezado_perfil (encperf_codperfesc, encperf_codemp, encperf_guid, encperf_link_resumen_perfil) values (@codperfesc, @codigo_empleado, @guid, @link_resumen)
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

	set dateformat dmy

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
				inner join @tbl_detperf tbl on tbl.detperf_codpreg = detperf.detperf_codpreg
			where encperf.encperf_codigo = @codencperf and detperf.detperf_orden_general_pregunta = tbl.detperf_orden_general_pregunta
			
			update perfil.encperf_encabezado_perfil set encperf_ultima_actualizacion_al_perfil_por_persona = getdate() where encperf_codigo = @codencperf

			insert into perfil.detperf_detalle_perfil 
			(detperf_codencperf, detperf_codpreg, detperf_codopc, detperf_codpregopc, detperf_link_atestado, detperf_fecha_desde, detperf_fecha_hasta, detperf_detalle, detperf_ultima_version, detperf_comentario_persona, detperf_estado_escuela, detperf_orden_general_pregunta, detperf_tiene_vencimiento)
			select @codencperf, t.detperf_codpreg, t.detperf_codopc, pregopc_codigo/*t.detperf_codpregopc*/, t.detperf_link_atestado, t.detperf_fecha_desde, t.detperf_fecha_hasta, t.detperf_detalle, 1, t.detperf_comentario_persona, t.detperf_estado_escuela, t.detperf_orden_general_pregunta, t.detperf_tiene_vencimiento
				from @tbl_detperf t
					inner join perfil.pregopc_preguntas_opciones on pregopc_codpreg = t.detperf_codpreg and pregopc_codopc = t.detperf_codopc

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
				detperf.detperf_fecha_revisado_por = getdate()/*tbl.detperf_fecha_revisado_por*/,
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

USE [uonline]
GO
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-10-26 22:00:55.190>
	-- Description: <Devuelve la data de de las respuestas del perfilamiento>
	-- =============================================
	-- exec uonline.dbo.rep_perfil_llenado @opcion = 1, @codigo_empleado = 4291, @encperf_guid = 'EE935DD7-906F-4804-9B39-AAF8EEE03221'
create or alter procedure dbo.rep_perfil_llenado
	@opcion int = 0,
	@codigo_empleado int = 0,
	@encperf_guid varchar(36) = '',
	@codperfs int = 0
as
begin

	if @opcion = 1
	begin
		select v2.codencperf, v1.coddetperf, v1.estado_escuela 'estado_detalle_escuela', v2.estado_general, v2.estado_general_texto, v1.codperfesc, v2.nombre_perfilamiento, v2.escuela, v2.correos_responsables_escuela, v2.nota_obtenida, v2.fecha_creacion,
			v2.nombre, v2.correo_empleado, v2.codigo_empleado, v1.nombre_grupo, v1.puntos_maximos_grupo, v1.detperf_orden_general_pregunta, v1.pregunta, v1.opcion, v1.valor_opcion, v1.link_atestado,
			v1.validez_fecha_desde, v1.validez_fecha_desde, v1.detalle_respuesta, v1.estado_escuela, v1.fecha_creacion_detalle, v1.codgruperf, isnull(v1.codgruperf_padre, 0) codgruperf_padre,
			v2.fecha_ultima_actualizacion_nota, case when v2.estado_escuela = 'APR' then v1.valor_opcion else 0 end 'nota_pregunta'
		from BD_RRHH.perfil.vst_respuestas_perfilamiento v1
			inner join BD_RRHH.perfil.vst_encabezado_perfilamiento v2 on v1.codencperf = v2.codencperf
		where v1.encperf_guid = @encperf_guid and es_no = 0
			and v1.codigo_empleado = @codigo_empleado
		order by detperf_orden_general_pregunta

	end

end
go

USE BD_RRHH
go