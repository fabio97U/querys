declare @codperfesc int = 3
declare @codgruperf int = 0
-- select * from perfil.perfesc_perfiles_escuela where perfesc_codigo = @codperfesc
-- select * from perfil.gruperf_grupos_perfilamiento where gruperf_codperfesc = @codperfesc order by gruperf_orden_general

insert into perfil.gruperf_grupos_perfilamiento 
(gruperf_codperfesc, gruperf_nombre, gruperf_orden_general, gruperf_orden, gruperf_puntos_maximos, gruperf_padre, gruperf_icono) values
(@codperfesc, 'DATOS GENERALES', 0, 0, 0, null, 'ri-user-line')

insert into perfil.gruperf_grupos_perfilamiento 
(gruperf_codperfesc, gruperf_nombre, gruperf_orden_general, gruperf_orden, gruperf_puntos_maximos, gruperf_padre, gruperf_icono) values
(@codperfesc, 'Formación Académica', 1, 1, 3.0, null, 'ri-contacts-book-2-line'); select @codgruperf = @@IDENTITY

insert into perfil.gruperf_grupos_perfilamiento 
(gruperf_codperfesc, gruperf_nombre, gruperf_orden_general, gruperf_orden, gruperf_puntos_maximos, gruperf_padre, gruperf_icono) values
(@codperfesc, 'Experiencia Docente', 2, 2, 3.0, null, 'ri-pencil-ruler-line'); select @codgruperf = @@IDENTITY
insert into perfil.gruperf_grupos_perfilamiento 
(gruperf_codperfesc, gruperf_nombre, gruperf_orden_general, gruperf_orden, gruperf_puntos_maximos, gruperf_padre, gruperf_icono) values
	(@codperfesc, 'Otra experiencia universitaria, elaboración de materiales didácticos, asesor o jurado de proyectos técnicos.', 3, 1, 1.5, @codgruperf, null),
	(@codperfesc, 'Participación como investigador o su participación en proyectos de pasantía o proyección social', 4, 2, 1, @codgruperf, null)

insert into perfil.gruperf_grupos_perfilamiento 
(gruperf_codperfesc, gruperf_nombre, gruperf_orden_general, gruperf_orden, gruperf_puntos_maximos, gruperf_padre, gruperf_icono) values
(@codperfesc, 'Experiencia  Profesional y/o Laboral', 3, 3, 2, null, 'ri-profile-line'); select @codgruperf = @@IDENTITY

insert into perfil.gruperf_grupos_perfilamiento 
(gruperf_codperfesc, gruperf_nombre, gruperf_orden_general, gruperf_orden, gruperf_puntos_maximos, gruperf_padre, gruperf_icono) values
(@codperfesc, 'Especialización', 4, 4, 2, null, 'ri-profile-line'); select @codgruperf = @@IDENTITY
insert into perfil.gruperf_grupos_perfilamiento
(gruperf_codperfesc, gruperf_nombre, gruperf_orden_general, gruperf_orden, gruperf_puntos_maximos, gruperf_padre, gruperf_icono) values
	(@codperfesc, 'Certificaciones, acreditación y agremiados < 5 años', 6, 5, 1, @codgruperf, null),
	(@codperfesc, 'Ponente en seminarios, diplomados ó congresos nacionales o internacionales', 7, 6, 1, @codgruperf, null)


-- select * from perfil.opc_opciones where opc_codperfesc = @codperfesc
insert into perfil.opc_opciones (opc_opcion, opc_valor, opc_es_no, opc_codperfesc) values
('Escriba: ', 0.0, 0, @codperfesc), ('No', 0.0, 1, @codperfesc), ('Si', 0.0, 0, @codperfesc)

insert into perfil.opc_opciones (opc_opcion, opc_valor, opc_codperfesc) values
('0.0', 0.0, @codperfesc), ('0-330 Bajo', 0.3, @codperfesc), ('331 a 660 Intermedio', 0.50, @codperfesc), ('661 - 990 Avanzado', 0.8, @codperfesc)
, ('< a 1 año', 0.15, @codperfesc), ('Entre 1 y 3 años', 0.25, @codperfesc), ('> a 3 años', 0.8, @codperfesc)

insert into perfil.opc_opciones (opc_opcion, opc_valor, opc_codperfesc) values
('1', 1, @codperfesc), ('0.5', 0.5, @codperfesc), ('0.75', 0.75, @codperfesc), ('0.25', 0.25, @codperfesc), 
('1.5', 1.5, @codperfesc), ('2', 2, @codperfesc), ('1.25', 1.25, @codperfesc)

-- select * from perfil.tippreg_tipo_pregunta
-- select * from perfil.preg_preguntas inner join perfil.gruperf_grupos_perfilamiento on preg_codgruperf = gruperf_codigo where gruperf_codperfesc = 3 order by preg_orden_general
insert into perfil.preg_preguntas (preg_codtippreg, preg_codgruperf, preg_orden_general, preg_orden, preg_pregunta, preg_tiene_vencimiento) values
(1, 1, 0, 1, 'Acreditación docente del MINEDCYT (Es de carácter obligatorio para la revision del perfil)', 1),

(1, 2, 1, 1, 'Segunda Carrera (Licenciado, Ingeniero o Arquitecto)', 1),
(1, 2, 2, 2, 'Segunda Carrera en Nivel Técnico Superior Universitario (2años)', 1),
(1, 2, 3, 3, 'Segunda Carrera en Nivel Tecnólogo (4 años)', 1),
(1, 2, 4, 4, 'Maestría en Educación', 1),
(1, 2, 5, 5, 'Maestría Especialidad', 1),
(1, 2, 6, 6, 'Otra Maestría', 1),
(1, 2, 7, 7, 'Doctorado cualquier disciplina', 1),
(1, 2, 8, 8, 'Postgrado en el área de especialidad >a 6 meses (ó un mínimo de 100 horas)', 1),
(1, 2, 9, 9, 'Postgrado en entornos virtuales', 1),
(1, 2, 10, 10, 'Curso de formación pedagógica', 1),
(1, 2, 11, 11, 'Diplomado de formación en valores', 1),

(1, 1, 12, 1, 'Manejo del idioma inglés Dominio basado en prueba  TOEIC  ', 1),
(1, 1, 13, 2, '331 a 660 Intermedi', 1),
(1, 1, 14, 3, 'Lee - Escribe	661-990 Avanzad', 1),

(1, 1, 15, 1, 'Experiencia Docente de 6 meses a 2 años', 1),
(1, 1, 16, 1, 'Experiencia Docente de >2 a < 5 años', 1),
(1, 1, 17, 1, 'Experiencia Docente > a 5 años', 1),

(1, 1, 18, 1, 'Autoría en libros, paquetes didácticos, revision técnica de libros.', 1),
(1, 1, 19, 1, 'Revision técnica de libros, paquetes didácticos, tesinas (impresos o digitales)', 1),
(1, 1, 20, 1, 'Redacción de artículos, papers, tesinas, del área de conocimiento (impresos o digitales).', 1),
(1, 1, 21, 1, 'Publicación de articulos, papers, tesinas del área de concimiento en revistas, períodicos, blog, memorias de congresos, simposios, otros', 1),
(1, 1, 22, 1, 'Escrito de artículos del área de conocimiento en revistas, folletos, periódicos sean estas impresas o digitales ', 1),
(1, 1, 23, 1, 'Asesor de trabajos de graduación a nivel de pre-grado', 1),
(1, 1, 24, 1, 'Asesor de trabajos de graduación a nivel técnico ', 1),
(1, 1, 25, 1, 'Jurado de trabajos de graduación a nivel técnico ', 1),
(1, 1, 26, 1, 'Jurado de trabajos de graduación a nivel  de pre-grado', 1),
(1, 1, 27, 1, 'Docente auxiliar por un año (debera presentar los atestados que evidencien dicha actividad y la validez dada por el coordinador del área o el director de la escuela)', 1),
(1, 1, 28, 1, 'Poseer el escalafón docente por parte de MINEDUCYT en Educación Media (deberá presentar el comprobante que lo evidencie)', 1),
(1, 1, 29, 1, 'Poseer la certificación docente vigente por parte de MINEDUCYT en Educación Superior (deberá presentar el comprobante que lo evidencie)', 1),
(1, 1, 30, 1, 'Ha desarrollado carrera dentro de la Universidad como instructor en todos los niveles establecidos, presentar carta de recomendación del director, coordinador o catedrático', 1),

(1, 1, 31, 1, 'Participación en investigación de cátedra.', 1),
(1, 1, 32, 1, 'Participación en investigación institucional.', 1),
(1, 1, 33, 1, 'Participación en proyectos de proyección social institucional.', 1),
(1, 1, 34, 1, 'Participación en proyectos de pasantía.', 1),

(1, 1, 35, 1, 'Cargo laboral desempeñado, ejerciendo la profesión o no.', 1),
(1, 1, 36, 1, 'Cargo Laboral Ejerciendo jefatura a nivel gerencial (Producción, Mercadeo, Proyecto, Recursos Humano etc.)', 1),
(1, 1, 37, 1, 'Cargo laboral ejerciendo jefatura a nivel de mando medio (coordinadores, analista, contador, etc.).', 1),
(1, 1, 38, 1, 'Cargo Laboral Administrativo o Académico (supervisores, talento humano, docentes, etc.)', 1),
(1, 1, 39, 1, 'Consultor, asesor o empresario independiente ', 1),
(1, 1, 40, 1, 'Gestión en Proyectos estratégicos de su profesión a nivel público, privado, nacional o internacional con beneficio social.', 1),

(1, 1, 41, 1, 'Certificaciones, acreditación y agremiados < 5 años', 1),
(1, 1, 42, 1, 'Certificaciones (Autodesk, Microsoft, Adobe, otras)', 1),
(1, 1, 43, 1, 'Acreditaciones (Sistemas de Gestión de la Calidad, Valuos, impacto ambiental, otros', 1),
(1, 1, 44, 1, 'Asistente a seminarios, diplomados, mesas de trabajo, congresos nacionales o internacionales en área acádemica, de especialidad, tendencia tecnológica, otros', 1),
(1, 1, 45, 1, 'Ponente en seminarios, diplomados ó congresos nacionales o internacionales', 1),
(1, 1, 46, 1, 'Seminarios', 1),
(1, 1, 47, 1, 'Diplomados', 1),
(1, 1, 48, 1, 'Congresos', 1),
(1, 1, 49, 1, 'Agremiado (ASIMEI, ASPROC, CADES, ASIA, otros)', 1),
(1, 1, 50, 1, 'Reconocimiento obtenidos por su notoriedad en el área profesional   (Válido si es otorgado por la institución en la que labora o laboró,ó institución reconocida en el ramo de la especialidad).', 1)

-- select * from perfil.tipopc_tipopc_opciones
-- select * from perfil.pregopc_preguntas_opciones inner join perfil.preg_preguntas on pregopc_codpreg = preg_codigo inner join perfil.gruperf_grupos_perfilamiento on preg_codgruperf = gruperf_codigo where gruperf_codperfesc = 3
-- select * from perfil.opc_opciones where opc_codperfesc = 3
--(select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1)
--(select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.2')

insert into perfil.pregopc_preguntas_opciones 
(pregopc_codpreg, pregopc_codopc, pregopc_codtipopc, pregopc_opc_orden) 
values
(1, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = @codperfesc and opc_valor = '1.00'), 1, 1), 
(1, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = @codperfesc and opc_es_no = 1), 1, 2), 

(2, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = @codperfesc and opc_valor = '0.50'), 1, 1), 
(2, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = @codperfesc and opc_es_no = 1), 1, 2),

(3, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = @codperfesc and opc_valor = '0.75'), 1, 1), 
(3, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = @codperfesc and opc_es_no = 1), 1, 2)
go

insert into perfil.pregopc_preguntas_opciones 
(pregopc_codpreg, pregopc_codopc, pregopc_codtipopc, pregopc_opc_orden) values
(8, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '2.00'), 1, 1), 
(8, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(9, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '2.50'), 1, 1), 
(9, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(10, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.00'), 1, 1), 
(10, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(11, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.00'), 1, 1), 
(11, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(12, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.00'), 1, 1), 
(12, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(13, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.50'), 1, 1), 
(13, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(14, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.55'), 1, 1), 
(14, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(15, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.75'), 1, 1), 
(15, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(16, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.50'), 1, 1), 
(16, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(17, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.50'), 1, 1), 
(17, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(18, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.75'), 1, 1), 
(18, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(19, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.80'), 1, 1), 
(19, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(20, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.25'), 1, 1), 
(20, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(21, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.50'), 1, 1), 
(21, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(22, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.20'), 1, 1), 
(22, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(23, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.40'), 1, 1), 
(23, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(24, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.65'), 1, 1), 
(24, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(25, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.25'), 1, 1), 
(25, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(26, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.50'), 1, 1), 
(26, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(27, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.00'), 1, 1), 
(27, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(28, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.50'), 1, 1), 
(28, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(29, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '2.00'), 1, 1), 
(29, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(30, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.00'), 1, 1), 
(30, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(31, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.50'), 1, 1), 
(31, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(32, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.00'), 1, 1), 
(32, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(33, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.50'), 1, 1), 
(33, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(34, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '2.50'), 1, 1), 
(34, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(35, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.25'), 1, 1), 
(35, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(36, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.45'), 1, 1), 
(36, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(37, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.40'), 1, 1), 
(37, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(38, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.20'), 1, 1), 
(38, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(39, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.25'), 1, 1), 
(39, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(40, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.25'), 1, 1), 
(40, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(41, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.50'), 1, 1), 
(41, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(42, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.65'), 1, 1), 
(42, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(43, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.50'), 1, 1), 
(43, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(44, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.25'), 1, 1), 
(44, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(45, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.35'), 1, 1), 
(45, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(46, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.50'), 1, 1), 
(46, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(47, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.65'), 1, 1), 
(47, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(48, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.50'), 1, 1), 
(48, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(49, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.50'), 1, 1), 
(49, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(50, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.50'), 1, 1), 
(50, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(51, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.50'), 1, 1), 
(51, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(52, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.50'), 1, 1), 
(52, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(53, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.50'), 1, 1), 
(53, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(54, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.25'), 1, 1), 
(54, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(55, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.00'), 1, 1), 
(55, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(56, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.75'), 1, 1), 
(56, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(57, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.00'), 1, 1), 
(57, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(58, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.00'), 1, 1), 
(58, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(59, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.75'), 1, 1), 
(59, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(60, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.00'), 1, 1), 
(60, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(61, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.00'), 1, 1), 
(61, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(62, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.50'), 1, 1), 
(62, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(63, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.25'), 1, 1), 
(63, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(64, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.75'), 1, 1), 
(64, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(65, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.00'), 1, 1), 
(65, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(66, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.75'), 1, 1), 
(66, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(67, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.25'), 1, 1), 
(67, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(68, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.50'), 1, 1), 
(68, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(69, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.00'), 1, 1), 
(69, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(70, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.25'), 1, 1), 
(70, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(71, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.30'), 1, 1), 
(71, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(72, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.25'), 1, 1), 
(72, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(73, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.25'), 1, 1), 
(73, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(74, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.25'), 1, 1), 
(74, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(75, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.35'), 1, 1), 
(75, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(76, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.40'), 1, 1), 
(76, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(77, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '0.20'), 1, 1), 
(77, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(78, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.25'), 1, 1), 
(78, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(79, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.40'), 1, 1), 
(79, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2), 
(80, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_valor = '1.60'), 1, 1), 
(80, (select opc_codigo from perfil.opc_opciones where opc_codperfesc = 3 and opc_es_no = 1), 1, 2)
go

-- exec perfil.sp_respuestas_perfilamiento @opcion = 1, @codperfesc = 3, @codigo_empleado = 4291, @codencperf = 1