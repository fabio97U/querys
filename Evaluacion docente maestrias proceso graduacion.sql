select * from ra_tde_TipoDeEstudio
-- select * from emer_enc_encuestas where enc_codigo = 3
insert into emer_enc_encuestas 
(enc_nombre, enc_codpon, enc_codcil, enc_codtde, enc_objetivo, enc_fecha_inicio, enc_fecha_fin)
values ('EVALUACION PROCESO DE GRADUACI�N', 1, 125, 2, 'Conocer su opini�n sobre importantes aspectos en relaci�n a su proceso de graduaci�n. Por lo anterior, solicitamos su colaboraci�n para que conteste en forma objetiva el presente instrumento de evaluaci�n que eval�a aspectos orientados al desarrollo de los m�dulos, metodolog�a y desempe�o docente.', '2021-06-28', '2021-06-30')

-- select * from emer_grupe_grupos_estudio where grupe_codenc = 3
insert into emer_grupe_grupos_estudio (grupe_nombre, grupe_codenc, grupe_orden)
values ('Importancia y conocimiento de las Tem�ticas.', 3, 1),
('Metodolog�a.', 3, 2),
('Caracter�sticas del Docente', 3, 3),
('Inicio y fin de clases', 3, 4),
('Comentarios o sugerencias ', 3, 5)

-- select * from emer_pre_preguntas where pre_codgrupe in (11, 12, 13, 14, 15)
insert into emer_pre_preguntas (pre_codtipp, pre_codgrupe, pre_orden_general, pre_orden, pre_pregunta)
values
(1, 11, 1, 1, 'Relevantes a la realidad salvadore�a'), 
(1, 11, 2, 2, 'Aplicables a las problem�ticas de la carrera profesional'), 
(1, 11, 3, 3, 'Contenidos actualizados'), 
(1, 11, 4, 4, 'Material de estudio y/o lectura acorde a las tem�ticas expuestas'), 
(1, 11, 5, 5, 'Los conocimientos recibidos en los m�dulos tienen aplicaci�n pr�ctica'), 

(1, 12, 6, 1, 'El desarrollo de las clases muestran preparaci�n y planificaci�n'),
(1, 12, 7, 2, 'El desarrollo de las clases son de acuerdo al programa y contenido'),
(1, 12, 8, 3, 'Se profundiza en el desarrollo de los contenidos'),
(1, 12, 9, 4, 'Cita ejemplos pr�cticos en el desarrollo de cada tema'),
(1, 12, 10, 5, 'Se utilizan diversos m�todos did�cticos y t�cnicas participativas para facilitar el aprendizaje'),
(1, 12, 11, 6, 'Se utilizan diferentes formas de evaluaci�n'),
(1, 12, 12, 7, 'Se refuerzan los objetivos que no fueron logrados por los estudiantes'),

(1, 13, 13, 1, 'Demuestra liderazgo con el grupo'),
(1, 13, 14, 2, 'Su lenguaje verbal y corporal logra el dominio del grupo'),
(1, 13, 15, 3, 'Despierta motivaci�n e inter�s en el aprendizaje de los estudiantes'),
(1, 13, 16, 4, 'Inspira confianza y respeto en la interacci�n con los estudiantes'),
(1, 13, 17, 5, 'Fomenta principios y valores'),
(1, 13, 18, 6, 'Muestra capacidad para escuchar los diferentes puntos de vista'),
(1, 13, 19, 7, 'Demuestra seguridad y �tica profesional'),

(1, 14, 20, 1, 'Inicia y Finaliza la clase de acuerdo al horario establecido'),
(1, 14, 21, 2, 'Entrega notas de acuerdo a tiempo establecido (8 d�as despu�s de finalizado el m�dulo)'),
(1, 14, 22, 3, 'Es adecuado el tiempo de respuesta a las consultas realizadas por correo o plataforma virtual'),

(1, 15, 23, 1, 'Comentarios o sugerencias generales del m�dulo')

-- select * from emer_opc_opciones where opc_codenc = 3
insert into emer_opc_opciones (opc_codenc, opc_opcion)
values (3, 'Excelente'), (3, 'Muy bueno'), (3, 'Bueno'), (3, 'Regular'), (3, 'Dejar un comentario'), (3, 'Sin comentario')

select * from emer_preopc_preguntas_opciones where preopc_codpre in (35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57)
insert into emer_preopc_preguntas_opciones (preopc_codpre, preopc_codopc, preopc_codtipo, preopc_opc_orden)
values 
(35, 87, 1, 1),
(35, 88, 1, 2),
(35, 89, 1, 3),
(35, 90, 1, 4),
(36, 87, 1, 1),
(36, 88, 1, 2),
(36, 89, 1, 3),
(36, 90, 1, 4),
(37, 87, 1, 1),
(37, 88, 1, 2),
(37, 89, 1, 3),
(37, 90, 1, 4),
(38, 87, 1, 1),
(38, 88, 1, 2),
(38, 89, 1, 3),
(38, 90, 1, 4),
(39, 87, 1, 1),
(39, 88, 1, 2),
(39, 89, 1, 3),
(39, 90, 1, 4),
(40, 87, 1, 1),
(40, 88, 1, 2),
(40, 89, 1, 3),
(40, 90, 1, 4),
(41, 87, 1, 1),
(41, 88, 1, 2),
(41, 89, 1, 3),
(41, 90, 1, 4),
(42, 87, 1, 1),
(42, 88, 1, 2),
(42, 89, 1, 3),
(42, 90, 1, 4),
(43, 87, 1, 1),
(43, 88, 1, 2),
(43, 89, 1, 3),
(43, 90, 1, 4),
(44, 87, 1, 1),
(44, 88, 1, 2),
(44, 89, 1, 3),
(44, 90, 1, 4),
(45, 87, 1, 1),
(45, 88, 1, 2),
(45, 89, 1, 3),
(45, 90, 1, 4),
(46, 87, 1, 1),
(46, 88, 1, 2),
(46, 89, 1, 3),
(46, 90, 1, 4),
(47, 87, 1, 1),
(47, 88, 1, 2),
(47, 89, 1, 3),
(47, 90, 1, 4),
(48, 87, 1, 1),
(48, 88, 1, 2),
(48, 89, 1, 3),
(48, 90, 1, 4),
(49, 87, 1, 1),
(49, 88, 1, 2),
(49, 89, 1, 3),
(49, 90, 1, 4),
(50, 87, 1, 1),
(50, 88, 1, 2),
(50, 89, 1, 3),
(50, 90, 1, 4),
(51, 87, 1, 1),
(51, 88, 1, 2),
(51, 89, 1, 3),
(51, 90, 1, 4),
(52, 87, 1, 1),
(52, 88, 1, 2),
(52, 89, 1, 3),
(52, 90, 1, 4),
(53, 87, 1, 1),
(53, 88, 1, 2),
(53, 89, 1, 3),
(53, 90, 1, 4),
(54, 87, 1, 1),
(54, 88, 1, 2),
(54, 89, 1, 3),
(54, 90, 1, 4),
(55, 87, 1, 1),
(55, 88, 1, 2),
(55, 89, 1, 3),
(55, 90, 1, 4),
(56, 87, 1, 1),
(56, 88, 1, 2),
(56, 89, 1, 3),
(56, 90, 1, 4),
(57, 91, 2, 1),
(57, 92, 1, 2)