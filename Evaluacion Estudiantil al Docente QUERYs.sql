--******Evaluación Estudiantil al Docente Presencial
-- select * from emer_enc_encuestas
alter table emer_enc_encuestas add enc_modalidad int

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: carrera presencial con aula fisica, 2: carrera presencial en linea, ***N..: Agregar mas numeros para filtrar por otros tipos***' , 
	@level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'emer_enc_encuestas', 
	@level2type=N'COLUMN',@level2name=N'enc_modalidad'

insert into emer_enc_encuestas 
(enc_nombre, enc_codpon, enc_codcil, enc_codtde, enc_objetivo, enc_fecha_inicio, enc_fecha_fin, enc_modalidad)
values ('Evaluación Estudiantil al Docente <br><strong>Presencial</strong><br>Ciclo 01-2022', 4, 128, 1, 'Evaluar el desempeño de los docentes, para identificar áreas de mejoras y superarlas con capacitaciones a la planta docente', '2022-05-14', '2022-06-02', 1)

-- select * from emer_grupe_grupos_estudio where grupe_codenc = 5
insert into emer_grupe_grupos_estudio (grupe_nombre, grupe_codenc, grupe_orden)
values ('I. Responsabilidad y puntualidad', 5, 1),
('II. Dominio de la asignatura', 5, 2),
('III. Métodos y recursos didácticos', 5, 3),
('IV. Relaciones Interpersonales y presentación personal', 5, 4),
('V. Evaluación de las competencias', 5, 5),
('VI. Misión, visión y valores', 5, 6)

alter table emer_pre_preguntas add pre_cant_seleccion_max int default -1
update emer_pre_preguntas set pre_cant_seleccion_max = -1
-- select * from emer_pre_preguntas where pre_codgrupe in (21, 22, 23, 24, 25, 26)
insert into emer_pre_preguntas (pre_codtipp, pre_codgrupe, pre_orden_general, pre_orden, pre_pregunta) values
(1, 21, 1, 1, 'Al inicio del ciclo, presentó el diseño instruccional, incluyendo las competencias a lograr'), 
(1, 21, 2, 2, 'Cumple con el horario establecido para iniciar la clase'), 
(1, 21, 3, 3, 'Cumple con el horario establecido para finalizar la clase'), 
(1, 21, 4, 4, 'Entrega los resultados de los trabajos y exámenes en los períodos establecidos por la Universidad'), 
(1, 21, 5, 5, 'Organiza y desarrolla los contenidos de clase de acuerdo con la programación del diseño instruccional'), 
(3, 21, 6, 6, 'Comentarios I'), 

(1, 22, 7, 1, 'Demuestra conocimiento y experiencia de la asignatura'), 
(1, 22, 8, 2, 'Profundiza en el desarrollo de cada temática programada'), 
(1, 22, 9, 3, 'Comparte y explica ejemplos de aplicación práctica'), 
(1, 22, 10, 4, 'Presenta un resumen de cada temática o unidad desarrollada'), 
(1, 22, 11, 5, 'Resuelve las dudas de los estudiantes'), 
(1, 22, 12, 6, 'Tiene facilidad para expresarse en forma oral y por escrito'), 
(3, 22, 13, 7, 'Comentarios II'), 

(1, 23, 14, 1, 'Pizarra'), 
(1, 23, 15, 2, 'Cuadernos de trabajo'), 
(1, 23, 16, 3, 'Películas o videos'), 
(1, 23, 17, 4, 'Retroproyectores'), 
(1, 23, 18, 5, 'Recursos en la nube (One drive, Google Drive, Dropbox)'), 
(1, 23, 19, 6, 'El docente incluye el uso de recursos virtuales para el aprendizaje (Portales educativos correo electrónico, sitios web, aulas de apoyo, blogs, etc.)'), 
(1, 23, 20, 7, 'Promueve la investigación en los estudiantes y el aprendizaje con metodologías activas'), 
(3, 23, 21, 8, 'Comentarios III'), 

(1, 24, 22, 1, 'Inspira confianza y respeta los puntos de vista de los estudiantes'), 
(1, 24, 23, 2, 'Posee paciencia para explicar más de una vez los temas abordados'), 
(1, 24, 24, 3, 'Es accesible y dispuesto para atender inquietudes de los estudiantes'), 
(1, 24, 25, 4, 'Su presentación personal es acorde a su rol de docente'), 
(1, 24, 26, 5, 'Responde consultas por correo o chat'), 
(1, 24, 27, 6, 'Motiva y genera un clima social de aprendizaje en el aula, que facilite el desarrollo estudiante'), 
(1, 24, 28, 7, 'Muestra interés en los estudiantes con bajo rendimiento académico'), 
(1, 24, 29, 8, 'Fomenta la autoconfianza en los estudiantes a través de frases motivadoras o de reflexión'), 
(3, 24, 30, 9, 'Comentarios IV'), 

(1, 25, 31, 1, 'Exámenes escritos'), 
(1, 25, 32, 2, 'Controles de lectura'), 
(1, 25, 33, 3, 'Resolución de estudios de casos'), 
(1, 25, 34, 4, 'Presentación de informes y/o documentos escritos'), 
(1, 25, 35, 5, 'Evaluación oral'), 
(1, 25, 36, 6, 'Participación en clase'), 
(1, 25, 37, 7, 'Exposiciones en grupo'), 
(1, 25, 38, 8, 'Prácticas externas'), 
(1, 25, 39, 9, 'Desarrollo de ejercicios'), 
(1, 25, 40, 10, 'Análisis de videos'), 
(1, 25, 41, 11, 'Entrevistas a profesionales del área'), 
(1, 25, 42, 12, 'Foros'), 
(1, 25, 43, 13, 'Conferencias con especialistas'), 
(1, 25, 44, 14, 'Seminarios'), 
(1, 25, 45, 15, 'Diplomados'), 
(3, 25, 46, 16, 'Comentarios V'), 

(1, 26, 47, 1, 'Presentó al inicio de clases la misión, visión y valores institucionales'), 
(1, 26, 48, 2, 'Promueve entre los estudiantes el conocimiento de la misión, visión y valores'), 
(1, 26, 49, 3, 'Presentó al inicio del ciclo las competencias generales del profesional UTEC'), 
(1, 26, 50, 4, 'Promueve y practica con los estudiantes, los valores institucionales de la Universidad')
insert into emer_pre_preguntas (pre_codtipp, pre_codgrupe, pre_orden_general, pre_orden, pre_pregunta, pre_cant_seleccion_max) values
(2, 26, 51, 5, '¿De los siguientes valores institucionales de la UTEC, elija los tres que más promueve su docente en la asignatura:', 3)
insert into emer_pre_preguntas (pre_codtipp, pre_codgrupe, pre_orden_general, pre_orden, pre_pregunta) values
(3, 26, 52, 6, 'Comentarios o sugerencias generales sobre el docente: ')

select * from emer_opc_opciones where opc_codenc = 5
alter table emer_opc_opciones add opc_valor_de_la_respuesta int default -1
update emer_opc_opciones set opc_valor_de_la_respuesta = -1
insert into emer_opc_opciones (opc_codenc, opc_opcion, opc_valor_de_la_respuesta) values (5, 'Siempre', 100), (5, 'Algunas veces', 50), (5, 'Nunca', 0)
insert into emer_opc_opciones (opc_codenc, opc_opcion) values (5, 'Compromiso agresivo'), (5, 'Innovación permanente'), (5, 'Respeto y pensamiento positivo'), (5, 'Liderazgo institucional'), (5, 'Solidaridad'), (5, 'Integridad'), (5, 'COMENTARIOS')

select * from emer_preopc_preguntas_opciones where preopc_codpre in (35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57)
insert into emer_preopc_preguntas_opciones (preopc_codpre, preopc_codopc, preopc_codtipo, preopc_opc_orden)
values 
(75, 136, 1, 1), 
(75, 137, 1, 2), 
(75, 138, 1, 3), 
(76, 136, 1, 1), 
(76, 137, 1, 2), 
(76, 138, 1, 3), 
(77, 136, 1, 1), 
(77, 137, 1, 2), 
(77, 138, 1, 3), 
(78, 136, 1, 1), 
(78, 137, 1, 2), 
(78, 138, 1, 3), 
(79, 136, 1, 1), 
(79, 137, 1, 2), 
(79, 138, 1, 3), 
(80, 145, 2, 1), 
(81, 136, 1, 1), 
(81, 137, 1, 2), 
(81, 138, 1, 3), 
(82, 136, 1, 1), 
(82, 137, 1, 2), 
(82, 138, 1, 3), 
(83, 136, 1, 1), 
(83, 137, 1, 2), 
(83, 138, 1, 3), 
(84, 136, 1, 1), 
(84, 137, 1, 2), 
(84, 138, 1, 3), 
(85, 136, 1, 1), 
(85, 137, 1, 2), 
(85, 138, 1, 3), 
(86, 136, 1, 1), 
(86, 137, 1, 2), 
(86, 138, 1, 3), 
(87, 145, 2, 1), 
(88, 136, 1, 1), 
(88, 137, 1, 2), 
(88, 138, 1, 3), 
(89, 136, 1, 1), 
(89, 137, 1, 2), 
(89, 138, 1, 3), 
(90, 136, 1, 1), 
(90, 137, 1, 2), 
(90, 138, 1, 3), 
(91, 136, 1, 1), 
(91, 137, 1, 2), 
(91, 138, 1, 3), 
(92, 136, 1, 1), 
(92, 137, 1, 2), 
(92, 138, 1, 3), 
(93, 136, 1, 1), 
(93, 137, 1, 2), 
(93, 138, 1, 3), 
(94, 136, 1, 1), 
(94, 137, 1, 2), 
(94, 138, 1, 3), 
(95, 145, 2, 1), 
(96, 136, 1, 1), 
(96, 137, 1, 2), 
(96, 138, 1, 3), 
(97, 136, 1, 1), 
(97, 137, 1, 2), 
(97, 138, 1, 3), 
(98, 136, 1, 1), 
(98, 137, 1, 2), 
(98, 138, 1, 3), 
(99, 136, 1, 1), 
(99, 137, 1, 2), 
(99, 138, 1, 3), 
(100, 136, 1, 1), 
(100, 137, 1, 2), 
(100, 138, 1, 3), 
(101, 136, 1, 1), 
(101, 137, 1, 2), 
(101, 138, 1, 3), 
(102, 136, 1, 1), 
(102, 137, 1, 2), 
(102, 138, 1, 3), 
(103, 136, 1, 1), 
(103, 137, 1, 2), 
(103, 138, 1, 3), 
(104, 145, 2, 1), 
(105, 136, 1, 1), 
(105, 137, 1, 2), 
(105, 138, 1, 3), 
(106, 136, 1, 1), 
(106, 137, 1, 2), 
(106, 138, 1, 3), 
(107, 136, 1, 1), 
(107, 137, 1, 2), 
(107, 138, 1, 3), 
(108, 136, 1, 1), 
(108, 137, 1, 2), 
(108, 138, 1, 3), 
(109, 136, 1, 1), 
(109, 137, 1, 2), 
(109, 138, 1, 3), 
(110, 136, 1, 1), 
(110, 137, 1, 2), 
(110, 138, 1, 3), 
(111, 136, 1, 1), 
(111, 137, 1, 2), 
(111, 138, 1, 3), 
(112, 136, 1, 1), 
(112, 137, 1, 2), 
(112, 138, 1, 3), 
(113, 136, 1, 1), 
(113, 137, 1, 2), 
(113, 138, 1, 3), 
(114, 136, 1, 1), 
(114, 137, 1, 2), 
(114, 138, 1, 3), 
(115, 136, 1, 1), 
(115, 137, 1, 2), 
(115, 138, 1, 3), 
(116, 136, 1, 1), 
(116, 137, 1, 2), 
(116, 138, 1, 3), 
(117, 136, 1, 1), 
(117, 137, 1, 2), 
(117, 138, 1, 3), 
(118, 136, 1, 1), 
(118, 137, 1, 2), 
(118, 138, 1, 3), 
(119, 136, 1, 1), 
(119, 137, 1, 2), 
(119, 138, 1, 3), 
(120, 145, 2, 1), 
(121, 136, 1, 1), 
(121, 137, 1, 2), 
(121, 138, 1, 3), 
(122, 136, 1, 1), 
(122, 137, 1, 2), 
(122, 138, 1, 3), 
(123, 136, 1, 1), 
(123, 137, 1, 2), 
(123, 138, 1, 3), 
(124, 136, 1, 1), 
(124, 137, 1, 2), 
(124, 138, 1, 3), 

(125, 139, 1, 1), 
(125, 140, 1, 2), 
(125, 141, 1, 3), 
(125, 142, 1, 4), 
(125, 143, 1, 5), 
(125, 144, 1, 6), 

(126, 145, 2, 1)


--******Evaluación Estudiantil al Docente Presencial en Línea
insert into emer_enc_encuestas 
(enc_nombre, enc_codpon, enc_codcil, enc_codtde, enc_objetivo, enc_fecha_inicio, enc_fecha_fin, enc_modalidad)
values ('Evaluación Estudiantil al Docente<br><strong>Presencial en Línea</strong><br>Ciclo 01-2022', 4, 128, 1, 'Evaluar el desempeño de los docentes, para identificar áreas de mejoras y superarlas con capacitaciones a la planta docente.', '2022-05-14', '2022-06-02', 2)

-- select * from emer_grupe_grupos_estudio where grupe_codenc = 6
insert into emer_grupe_grupos_estudio (grupe_nombre, grupe_codenc, grupe_orden)
values ('I. Responsabilidad y puntualidad', 6, 1),
('II. Dominio de la asignatura', 6, 2),
('III. Métodos y recursos tecnológicos didácticos', 6, 3),
('IV. Relaciones Interpersonales y presentación personal', 6, 4),
('V. Evaluación de acuerdo a objetivos de aprendizaje', 6, 5),
('VI. Misión, visión y valores institucionales', 6, 6)


insert into emer_pre_preguntas (pre_codtipp, pre_codgrupe, pre_orden_general, pre_orden, pre_pregunta) values
(1, 27, 1, 1, 'Al inicio del ciclo, presentó el diseño instruccional, incluyendo las competencias a lograr'), 
(1, 27, 2, 2, 'Cumple con el horario establecido para iniciar la clase'), 
(1, 27, 3, 3, 'Cumple con el horario establecido para finalizar la clase'), 
(1, 27, 4, 4, 'Entrega los resultados de los trabajos y exámenes en los períodos establecidos por la Universidad'), 
(1, 27, 5, 5, 'Mantiene el aula de apoyo actualizada con todo el material requerido por la asignatura'), 
(3, 27, 6, 6, 'Comentarios I'), 

(1, 28, 7, 1, 'Demuestra conocimiento y experiencia de la asignatura'), 
(1, 28, 8, 2, 'Profundiza en el desarrollo de cada temática programada'), 
(1, 28, 9, 3, 'Comparte y aplica  ejemplos de aplicación práctica'), 
(1, 28, 10, 4, 'Presenta un resumen de cada temática o unidad desarrollada'), 
(1, 28, 11, 5, 'Resuelve las dudas de los estudiantes'), 
(1, 28, 12, 6, 'Tiene facilidad para expresarse en forma oral y escrita'), 
(3, 28, 13, 7, 'Comentarios II'), 

(1, 29, 14, 1, 'Pizarra virtual'), 
(1, 29, 15, 2, 'Office 365'), 
(1, 29, 16, 3, 'Películas o videos'), 
(1, 29, 17, 4, 'Plataforma de video conferencia: (Zoom, Google meet, MS Teams)'), 
(1, 29, 18, 5, 'Recursos en la Nube: (One drive, Google Drive, Dropbox)'), 
(1, 29, 19, 6, 'Trabajo colaborativo: (Documentos en la nube y aula de apoyo)'), 
(1, 29, 20, 7, 'Tareas en grupo en línea'), 
(1, 29, 21, 8, 'Portales educativos'), 
(1, 29, 22, 9, 'Correo electrónico'), 
(1, 29, 23, 10, 'Sitios web'), 
(1, 29, 24, 11, 'Aula de apoyo'), 
(1, 29, 25, 12, 'Blogs'), 
(1, 29, 26, 13, 'Libros digitales'), 
(1, 29, 27, 14, 'Artículos especializados'), 
(1, 29, 28, 15, 'Videos'), 
(1, 29, 29, 16, 'Promueve la investigación en los estudiantes y el aprendizaje con metodologías activas'), 
(1, 29, 30, 17, 'Otros'), 
(3, 29, 31, 18, 'Comentarios III'), 

(1, 30, 32, 1, 'Inspira confianza y respeta los puntos de vista de los estudiantes'), 
(1, 30, 33, 2, 'Posee paciencia para explicar más de una vez los temas abordados'), 
(1, 30, 34, 3, 'Es accesible y dispuesto para atender inquietudes de los estudiantes'), 
(1, 30, 35, 4, 'Responde consultas por  correos y chats'), 
(1, 30, 36, 5, 'Motiva y genera un clima social de aprendizaje, que facilite el desarrollo académico del estudiante'), 
(1, 30, 37, 6, 'Muestra interés en los estudiantes con bajo rendimiento académico'), 
(1, 30, 38, 7, 'Fomenta la autoconfianza en los estudiantes a través de frases motivadoras o la reflexión'), 
(3, 30, 39, 8, 'Comentarios IV'), 

(1, 31, 40, 1, 'Exámenes en línea'), 
(1, 31, 41, 2, 'Controles de lectura'), 
(1, 31, 42, 3, 'Resolución de estudios de casos'), 
(1, 31, 43, 4, 'Presentación de informes y/o documentos escritos'), 
(1, 31, 44, 5, 'Evaluación oral'), 
(1, 31, 45, 6, 'Participación en clase'), 
(1, 31, 46, 7, 'Exposiciones en grupo'), 
(1, 31, 47, 8, 'Prácticas externas'), 
(1, 31, 48, 9, 'Análisis de videos'), 
(1, 31, 49, 10, 'Entrevistas a profesionales del área'), 
(1, 31, 50, 11, 'Foros (Webinar)'), 
(1, 31, 51, 12, 'Conferencias con especialistas'), 
(1, 31, 52, 13, 'Seminarios'), 
(1, 31, 53, 14, 'Diplomados'), 
(3, 31, 54, 15, 'Comentarios V'), 

(1, 32, 55, 1, 'Presentó al inicio de clases la misión, visión y valores institucionales'), 
(1, 32, 56, 2, 'Promueve entre los estudiantes el conocimiento de la Misión y Visión'), 
(1, 32, 57, 3, 'Presentó al inicio de clases los valores institucionales de la Universidad'), 
(1, 32, 58, 4, 'Promueve y práctica con los estudiantes, los valores institucionales de la Universidad'), 
(1, 32, 59, 5, 'Presentó al inicio del ciclo las competencias generales del profesional UTEC')

insert into emer_pre_preguntas (pre_codtipp, pre_codgrupe, pre_orden_general, pre_orden, pre_pregunta, pre_cant_seleccion_max) values
(2, 32, 60, 6, '¿De los siguientes valores institucionales de la UTEC, elija los tres que más promueve su docente en la asignatura', 3)

insert into emer_pre_preguntas (pre_codtipp, pre_codgrupe, pre_orden_general, pre_orden, pre_pregunta) values
(3, 32, 61, 7, 'Comentarios o sugerencias generales sobre el docente: ')


insert into emer_opc_opciones (opc_codenc, opc_opcion, opc_valor_de_la_respuesta) values (6, 'Siempre', 100), (6, 'Algunas veces', 50), (6, 'Nunca', 0)
insert into emer_opc_opciones (opc_codenc, opc_opcion) values (6, 'Compromiso agresivo'), (6, 'Innovación permanente'), (6, 'Respeto y pensamiento positivo'), (6, 'Liderazgo institucional'), (6, 'Solidaridad'), (6, 'Integridad'), (6, 'COMENTARIOS')

select * from emer_opc_opciones where opc_codenc = 6

select * from emer_grupe_grupos_estudio where grupe_codenc = 6
select * from emer_pre_preguntas where pre_codgrupe in (27,28,29,30,31,32)
insert into emer_preopc_preguntas_opciones (preopc_codpre, preopc_codopc, preopc_codtipo, preopc_opc_orden) 
values
(127, 146, 1, 1), 
(127, 147, 1, 2), 
(127, 148, 1, 3), 
(128, 146, 1, 1), 
(128, 147, 1, 2), 
(128, 148, 1, 3), 
(129, 146, 1, 1), 
(129, 147, 1, 2), 
(129, 148, 1, 3), 
(130, 146, 1, 1), 
(130, 147, 1, 2), 
(130, 148, 1, 3), 
(131, 146, 1, 1), 
(131, 147, 1, 2), 
(131, 148, 1, 3), 
(132, 155, 2, 1),  
(133, 146, 1, 1), 
(133, 147, 1, 2), 
(133, 148, 1, 3), 
(134, 146, 1, 1), 
(134, 147, 1, 2), 
(134, 148, 1, 3), 
(135, 146, 1, 1), 
(135, 147, 1, 2), 
(135, 148, 1, 3), 
(136, 146, 1, 1), 
(136, 147, 1, 2), 
(136, 148, 1, 3), 
(137, 146, 1, 1), 
(137, 147, 1, 2), 
(137, 148, 1, 3), 
(138, 146, 1, 1), 
(138, 147, 1, 2), 
(138, 148, 1, 3), 
(139, 155, 2, 1), 
(140, 146, 1, 1), 
(140, 147, 1, 2), 
(140, 148, 1, 3), 
(141, 146, 1, 1), 
(141, 147, 1, 2), 
(141, 148, 1, 3), 
(142, 146, 1, 1), 
(142, 147, 1, 2), 
(142, 148, 1, 3), 
(143, 146, 1, 1), 
(143, 147, 1, 2), 
(143, 148, 1, 3), 
(144, 146, 1, 1), 
(144, 147, 1, 2), 
(144, 148, 1, 3), 
(145, 146, 1, 1), 
(145, 147, 1, 2), 
(145, 148, 1, 3), 
(146, 146, 1, 1), 
(146, 147, 1, 2), 
(146, 148, 1, 3), 
(147, 146, 1, 1), 
(147, 147, 1, 2), 
(147, 148, 1, 3), 
(148, 146, 1, 1), 
(148, 147, 1, 2), 
(148, 148, 1, 3), 
(149, 146, 1, 1), 
(149, 147, 1, 2), 
(149, 148, 1, 3), 
(150, 146, 1, 1), 
(150, 147, 1, 2), 
(150, 148, 1, 3), 
(151, 146, 1, 1), 
(151, 147, 1, 2), 
(151, 148, 1, 3), 
(152, 146, 1, 1), 
(152, 147, 1, 2), 
(152, 148, 1, 3), 
(153, 146, 1, 1), 
(153, 147, 1, 2), 
(153, 148, 1, 3), 
(154, 146, 1, 1), 
(154, 147, 1, 2), 
(154, 148, 1, 3), 
(155, 146, 1, 1), 
(155, 147, 1, 2), 
(155, 148, 1, 3), 
(156, 146, 1, 1), 
(156, 147, 1, 2), 
(156, 148, 1, 3), 
(157, 155, 2, 1), 
(158, 146, 1, 1), 
(158, 147, 1, 2), 
(158, 148, 1, 3), 
(159, 146, 1, 1), 
(159, 147, 1, 2), 
(159, 148, 1, 3), 
(160, 146, 1, 1), 
(160, 147, 1, 2), 
(160, 148, 1, 3), 
(161, 146, 1, 1), 
(161, 147, 1, 2), 
(161, 148, 1, 3), 
(162, 146, 1, 1), 
(162, 147, 1, 2), 
(162, 148, 1, 3), 
(163, 146, 1, 1), 
(163, 147, 1, 2), 
(163, 148, 1, 3), 
(164, 146, 1, 1), 
(164, 147, 1, 2), 
(164, 148, 1, 3), 
(165, 155, 2, 1), 
(166, 146, 1, 1), 
(166, 147, 1, 2), 
(166, 148, 1, 3), 
(167, 146, 1, 1), 
(167, 147, 1, 2), 
(167, 148, 1, 3), 
(168, 146, 1, 1), 
(168, 147, 1, 2), 
(168, 148, 1, 3), 
(169, 146, 1, 1), 
(169, 147, 1, 2), 
(169, 148, 1, 3), 
(170, 146, 1, 1), 
(170, 147, 1, 2), 
(170, 148, 1, 3), 
(171, 146, 1, 1), 
(171, 147, 1, 2), 
(171, 148, 1, 3), 
(172, 146, 1, 1), 
(172, 147, 1, 2), 
(172, 148, 1, 3), 
(173, 146, 1, 1), 
(173, 147, 1, 2), 
(173, 148, 1, 3), 
(174, 146, 1, 1), 
(174, 147, 1, 2), 
(174, 148, 1, 3), 
(175, 146, 1, 1), 
(175, 147, 1, 2), 
(175, 148, 1, 3), 
(176, 146, 1, 1), 
(176, 147, 1, 2), 
(176, 148, 1, 3), 
(177, 146, 1, 1), 
(177, 147, 1, 2), 
(177, 148, 1, 3), 
(178, 146, 1, 1), 
(178, 147, 1, 2), 
(178, 148, 1, 3), 
(179, 146, 1, 1), 
(179, 147, 1, 2), 
(179, 148, 1, 3), 
(180, 155, 2, 1), 
(181, 146, 1, 1), 
(181, 147, 1, 2), 
(181, 148, 1, 3), 
(182, 146, 1, 1), 
(182, 147, 1, 2), 
(182, 148, 1, 3), 
(183, 146, 1, 1), 
(183, 147, 1, 2), 
(183, 148, 1, 3), 
(184, 146, 1, 1), 
(184, 147, 1, 2), 
(184, 148, 1, 3), 
(185, 146, 1, 1), 
(185, 147, 1, 2), 
(185, 148, 1, 3), 

(186, 149, 1, 1), 
(186, 150, 1, 2), 
(186, 151, 1, 3), 
(186, 152, 1, 4), 
(186, 153, 1, 5), 
(186, 154, 1, 6), 

(187, 155, 2, 1)





USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_data_emer_encuestas]    Script Date: 16/5/2022 11:14:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Fabio>
-- Create date: <2020-05-26 00:00:15.267>
-- Description: <Devuelve la data para las encuestas emergencia>
-- =============================================
-- sp_data_emer_encuestas 1, 5, 0, 0, 0
-- sp_data_emer_encuestas 2, 0, 0, 0, 41405
ALTER procedure [dbo].[sp_data_emer_encuestas] 
	@opcion int = 0,
	@codenc int = 0,
	@codpon int = 0,
	@codper int = 0,

	@codhpl int = 0
as
begin
	if @opcion = 1 --Data de la encuesta @codenc
	begin
		select 
			enc_nombre, enc_objetivo,
			grupe_codigo, grupe_orden, grupe_nombre,
			pre_codigo, pre_orden, pre_orden_general, pre_pregunta, tipp_tipo,
			opc_codigo, opc_opcion, preopc_opc_orden, tipo_tipo, pre_cant_seleccion_max
		from emer_preopc_preguntas_opciones
		inner join emer_pre_preguntas on pre_codigo = preopc_codpre
		inner join emer_opc_opciones on opc_codigo = preopc_codopc
		inner join emer_grupe_grupos_estudio on grupe_codigo = pre_codgrupe
		inner join emer_tipp_tipo_preguntas on tipp_codigo = pre_codtipp
		inner join emer_tipo_tipo_opciones on tipo_codigo = preopc_codtipo
		inner join emer_enc_encuestas on enc_codigo = @codenc
		where @codenc in (opc_codenc, grupe_codenc)
	end

	if @opcion = 2 --Data para el encabezado de la encuesta a que docente se esta evaluando
	begin
		select hpl_codmat, mat_nombre, hpl_descripcion, emp_nombres_apellidos, esc_nombre from ra_hpl_horarios_planificacion
		inner join pla_emp_empleado on emp_codigo = hpl_codemp
		inner join ra_mat_materias on mat_codigo = hpl_codmat
		inner join ra_esc_escuelas on esc_codigo = mat_codesc
		where hpl_codigo = @codhpl
	end

	if @opcion = 3
	begin
		select mpmpg_orden hpl_codmat, mmpg_nombre mat_nombre, mpmpg_seccion hpl_descripcion, emp_nombres_apellidos, 'Maestrias' esc_nombre
		from ma_mpmpg_modulo_por_maestria_proceso_graduacion
			inner join pla_emp_empleado on emp_codigo = mpmpg_codemp
			inner join ma_mmpg_modulo_maestria_proceso_graduacion on mmpg_codigo = mpmpg_codmmpg
		where mpmpg_codigo = @codhpl
	end
end







select * from emer_enc_encuestas

select * from ra_aul_aulas where aul_codigo in (160, 260, 180)
select * from ra_hpl_horarios_planificacion where hpl_codigo = 49182
select * from emer_encenc_encabezado_encuesta where encenc_codenc in (5, 6)
select * from emer_detenc_detalle_encuesta where detenc_codencenc in (66364)


