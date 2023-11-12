USE BD_RRHH
go
-- drop table rrhh_detenc_detalle_encuesta
-- drop table rrhh_encenc_encabezado_encuesta
-- drop table rrhh_preopc_preguntas_opciones
-- drop table rrhh_opc_opciones
-- drop table rrhh_tipo_tipo_opciones
-- drop table rrhh_pre_preguntas
-- drop table rrhh_tipp_tipo_preguntas
-- drop table rrhh_subgru_sub_grupo
-- drop table rrhh_grupe_grupos_estudio
-- drop table rrhh_enc_encuestas

-- drop table rrhh_enc_encuestas
create table rrhh_enc_encuestas (
	enc_codigo int primary key identity(1, 1),
	enc_nombre_unidad_encargada varchar(50),
	enc_nombre_encuesta varchar(255),
	
	enc_correo_encargado_encuesta varchar(255),
	enc_encargado_encuesta varchar(255),

	--enc_codpon int,
	enc_codcil int,
	enc_objetivo varchar(max),
	enc_indicaciones varchar(max),
	enc_forma_contestar varchar(max),
	enc_fecha_inicio datetime,
	enc_fecha_fin datetime,
	enc_fecha_creacion datetime default getdate()
)

-- select * from rrhh_enc_encuestas
insert into rrhh_enc_encuestas
(enc_nombre_unidad_encargada, enc_nombre_encuesta, enc_codcil, 
enc_objetivo, 
enc_indicaciones, enc_forma_contestar, enc_fecha_inicio, enc_fecha_fin, enc_correo_encargado_encuesta, enc_encargado_encuesta)
values 
--E1
('DIRECCIÓN DE RECURSOS HUMANOS', 'INSTRUMENTO DE EVALUACIÓN DEL DESEMPEÑO Vicerrectores', 128, 
null, 
'1. Este instrumento permitirá la apreciación del desempeño de los señores <strong>Vicerrectores</strong><br>2. Si las respuestas no son objetivas, el personal responsable de la elaboración del informe, invertirá tiempo y esfuerzo en plantear interpretaciones que no existen o que no son muy importantes y dejar de lado otras de mayor importancia<br>',
'Por favor indique con una equis (X) el grado en el cual usted está de acuerdo con cada pregunta o proposición conforme a la siguiente escala:<br><center>S = siempre</center><center>MV = Muchas veces</center><center>AV = a veces</center><center>PV = pocas veces</center><center>N = nunca</center><br>', '2022-03-20 00:00:00.000', '2022-06-22 08:48:00.173'
, 'jorge.loucel@utec.edu.sv', 'Jorge Mauricio Loucel Dominguez'),
--E2
('DIRECCIÓN DE RECURSOS HUMANOS', 'INSTRUMENTO DE EVALUACIÓN DEL DESEMPEÑO Decanos y Directores de Escuela', 128, 
null, 
'1. Este instrumento permitirá la apreciación del desempeño de los <strong>Decanos y Directores de Escuela</strong>.<br>2. La evaluación del desempeño conducirá a la superación y desarrollo en el campo laboral y personal, así como a la mejorar del desempeño institucional.<br>3. Si las respuestas no son objetivas, el personal responsable de la elaboración del informe, invertirá tiempo y esfuerzo en plantear interpretaciones que no existen o que no son muy importantes y dejar de lado otras de mayor importancia.<br>',
'Por favor indique con una equis (X) el grado en el cual usted está de acuerdo con cada pregunta o proposición conforme a la siguiente escala:<br><center>S = siempre</center><center>MV = Muchas veces</center><center>AV = a veces</center><center>PV = pocas veces</center><center>N = nunca</center><br>', '2022-03-20 00:00:00.000', '2022-06-22 08:48:00.173'
, 'jorge.loucel@utec.edu.sv', 'Jorge Mauricio Loucel Dominguez'),
--E3
('DIRECCIÓN DE RECURSOS HUMANOS', 'INSTRUMENTO DE EVALUACIÓN DEL DESEMPEÑO Directores Administrativos', 128, 
null, 
'1. Este instrumento permitirá la apreciación del desempeño de los <strong>Directores Administrativos</strong><br>2. La evaluación del desempeño conducirá a la superación y desarrollo en el campo laboral y personal, así como a la mejorar del desempeño institucional<br>3. Si las respuestas no son objetivas, el personal responsable de la elaboración del informe, invertirá tiempo y esfuerzo en plantear interpretaciones que no existen o que no son muy importantes y dejar de lado otras de mayor importancia<br>',
'Por favor indique con una equis (X) el grado en el cual usted está de acuerdo con cada pregunta o proposición conforme a la siguiente escala:<br><center>S = siempre</center><center>MV = Muchas veces</center><center>AV = a veces</center><center>PV = pocas veces</center><center>N = nunca</center><br>', '2022-03-20 00:00:00.000', '2022-06-22 08:48:00.173'
, 'jorge.loucel@utec.edu.sv', 'Jorge Mauricio Loucel Dominguez'),
--E4
('DIRECCIÓN DE RECURSOS HUMANOS', 'INSTRUMENTO DE EVALUACIÓN DEL DESEMPEÑO coordinadores y jefes', 128, 
null, 
'1. Este instrumento permitirá la apreciación del desempeño de <strong>los coordinadores y jefes</strong><br>2. La evaluación del desempeño conducirá a la superación y desarrollo en el campo laboral y personal, así como a la mejora del desempeño institucional<br>3. Si las respuestas no son objetivas, el personal responsable de la elaboración del informe, invertirá tiempo y esfuerzo en plantear interpretaciones que no existen o que no son muy importantes y dejar de lado otras de mayor importancia<br>',
'Por favor indique con una equis (X) el grado en el cual usted está de acuerdo con cada pregunta o proposición conforme a la siguiente escala:<br><center>S = siempre</center><center>MV = Muchas veces</center><center>AV = a veces</center><center>PV = pocas veces</center><center>N = nunca</center><br>', '2022-03-20 00:00:00.000', '2022-06-22 08:48:00.173'
, 'jorge.loucel@utec.edu.sv', 'Jorge Mauricio Loucel Dominguez'),
--E5
('DIRECCIÓN DE RECURSOS HUMANOS', 'INSTRUMENTO DE EVALUACIÓN DEL DESEMPEÑO colaboradores a jefes', 128, 
null, 
'1. Este instrumento permitirá la apreciación del desempeño de los <strong>colaboradores a jefes</strong><br>2. La evaluación del desempeño conducirá a la superación y desarrollo en el campo laboral y personal, así como a la mejorar del desempeño institucional<br>3. Si las respuestas no son objetivas, el personal responsable de la elaboración del informe, invertirá tiempo y esfuerzo en plantear interpretaciones que no existen o que no son muy importantes y dejar de lado otras de mayor importancia<br>',
'Por favor indique con una equis (X) el grado en el cual usted está de acuerdo con cada pregunta o proposición conforme a la siguiente escala:<br><center>S = siempre</center><center>MV = Muchas veces</center><center>AV = a veces</center><center>PV = pocas veces</center><center>N = nunca</center><br>', '2022-03-20 00:00:00.000', '2022-06-22 08:48:00.173'
, 'jorge.loucel@utec.edu.sv', 'Jorge Mauricio Loucel Dominguez'),
--E6
('DIRECCIÓN DE RECURSOS HUMANOS', 'INSTRUMENTO DE EVALUACIÓN DEL DESEMPEÑO personal administrativo', 128, 
null, 
'1. Este instrumento permitirá la apreciación del desempeño del <strong>personal administrativo</strong><br>2. La evaluación del desempeño conducirá a la superación y desarrollo en el campo laboral y personal, así como a la mejora del desempeño institucional<br>3. Si las respuestas no son objetivas, el personal responsable de la elaboración del informe, invertirá tiempo y esfuerzo en plantear interpretaciones que no existen o que no son muy importantes y dejar de lado otras de mayor importancia<br>',
'Por favor indique con una equis (X) el grado en el cual usted está de acuerdo con cada pregunta o proposición conforme a la siguiente escala:<br><center>S = siempre</center><center>MV = Muchas veces</center><center>AV = a veces</center><center>PV = pocas veces</center><center>N = nunca</center><br>', '2022-03-20 00:00:00.000', '2022-06-22 08:48:00.173'
, 'jorge.loucel@utec.edu.sv', 'Jorge Mauricio Loucel Dominguez'),
--E7
('DIRECCIÓN DE RECURSOS HUMANOS', 'INSTRUMENTO DE EVALUACIÓN DEL DESEMPEÑO personal de mantenimiento y servicios generales', 128, 
null, 
'1. Este instrumento permitirá la apreciación del desempeño del <strong>personal de mantenimiento y servicios generales</strong><br>2. La evaluación del desempeño conducirá a la superación y desarrollo en el campo laboral y personal, así como a la mejora del desempeño institucional<br>3. Si las respuestas no son objetivas, el personal responsable de la elaboración del informe, invertirá tiempo y esfuerzo en plantear interpretaciones que no existen o que no son muy importantes y dejar de lado otras de mayor importancia<br>',
'Por favor indique con una equis (X) el grado en el cual usted está de acuerdo con cada pregunta o proposición conforme a la siguiente escala:<br><center>S = siempre</center><center>MV = Muchas veces</center><center>AV = a veces</center><center>PV = pocas veces</center><center>N = nunca</center><br>', '2022-03-20 00:00:00.000', '2022-06-22 08:48:00.173'
, 'jorge.loucel@utec.edu.sv', 'Jorge Mauricio Loucel Dominguez')

-- drop table rrhh_grupe_grupos_estudio
create table rrhh_grupe_grupos_estudio(
	grupe_codigo int primary key identity(1, 1),
	grupe_nombre varchar(255),
	grupe_codenc int foreign key references rrhh_enc_encuestas,
	grupe_orden int,
	grupe_fecha_creacion datetime default getdate()
)
-- select * from rrhh_grupe_grupos_estudio
insert into rrhh_grupe_grupos_estudio (grupe_nombre, grupe_orden, grupe_codenc) values
--E1
('I. HABILIDADES GERENCIALES', 1, 1), ('II. HABILIDADES DE LIDERAZGO', 2, 1), ('III. HABILIDADES DE TRABAJO EN EQUIPO', 3, 1), ('IV. INTELIGENCIA EMOCIONAL', 4, 1),
--E2
('I. HABILIDADES GERENCIALES', 1, 2), ('II. HABILIDADES DE LIDERAZGO', 2, 2), ('III. HABILIDADES DE TRABAJO EN EQUIPO', 3, 2), ('IV. INTELIGENCIA EMOCIONAL', 4, 2),
--E3
('I. HABILIDADES GERENCIALES', 1, 3), ('II. HABILIDADES DE LIDERAZGO', 2, 3), ('III. HABILIDADES DE TRABAJO EN EQUIPO', 3, 3), ('IV. INTELIGENCIA EMOCIONAL', 4, 3),
--E4
('I. HABILIDADES GERENCIALES', 1, 4), ('II. HABILIDADES DE LIDERAZGO', 2, 4), ('III. HABILIDADES DE TRABAJO EN EQUIPO', 3, 4), ('IV. INTELIGENCIA EMOCIONAL', 4, 4),
--E5
('I. HABILIDADES GERENCIALES', 1, 5), ('II. HABILIDADES DE LIDERAZGO', 2, 5), ('III. HABILIDADES DE TRABAJO EN EQUIPO', 3, 5), ('IV. INTELIGENCIA EMOCIONAL', 4, 5),
--E6
('I. HABILIDADES PARA EL DESARROLLO EFECTIVO DEL TRABAJO', 1, 6), ('II. HABILIDADES RELACIONALES', 2, 6), ('III. HABILIDADES DE TRABAJO EN EQUIPO', 3, 6), ('IV. INTELIGENCIA EMOCIONAL', 4, 6),
--E7
('I. HABILIDADES PARA EL DESARROLLO EFECTIVO DEL TRABAJO', 1, 7), ('II. HABILIDADES RELACIONALES', 2, 7), ('III. HABILIDADES DE TRABAJO EN EQUIPO', 3, 7)

-- drop table rrhh_subgru_sub_grupo
create table rrhh_subgru_sub_grupo(
	subgru_codigo int primary key identity(1, 1),
	subgru_nombre varchar(255),
	subgru_orden int,
	subgru_codgrupe int foreign key references rrhh_grupe_grupos_estudio,
	subgru_fecha_creacion datetime default getdate()
)
-- select * from rrhh_subgru_sub_grupo
insert into rrhh_subgru_sub_grupo (subgru_nombre, subgru_orden, subgru_codgrupe) values
--E1
('A. Convertir la misión en acción', 1, 1), ('B. Sentido de propósito', 2, 1), ('C. Concentración en los alumnos/calidad', 3, 1), 
('D. Adaptación al cambio', 4, 1), ('E. Ejes de vigilancia', 5, 1)
,
('A. Motivación y comunicación', 1, 2), ('B. Delegación y toma de decisiones', 2, 2), ('C. Relaciones  interpersonales', 3, 2)
,
('A. Gestión de conflictos dentro del equipo', 1, 3), ('B. Trabajo en equipo y solución de problemas', 2, 3)
,
('A. Equilibrio emocional', 1, 4), ('B. Cumplimiento de compromisos', 2, 4), ('C. Adaptación', 2, 4), ('D. Tolerancia a la diversidad', 2, 4)
,
--E2
('A. Convertir la misión en acción', 1, 5), ('B. Sentido de propósito', 2, 5), ('C. Concentración en los alumnos/calidad', 3, 5), 
('D. Adaptación al cambio', 4, 5), ('E. Ejes de vigilancia', 5, 5)
,
('A. Motivación y comunicación', 1, 6), ('B. Flexibilidad', 2, 6), ('C. Delegación y toma de decisiones', 2, 6), ('D. Relaciones interpersonales', 3, 6)
,
('A. Gestión de conflictos dentro del equipo', 1, 7), ('B. Trabajo en equipo y solución de problemas', 2, 7)
,
('A. Equilibrio emocional', 1, 8), ('B. Cumplimiento de compromisos', 2, 8), ('C. Adaptación', 2, 8), ('D. Tolerancia a la diversidad', 2, 8),

--E3
('A. Convertir la misión en acción', 1, 9), ('B. Sentido de propósito', 2, 9), ('C. Adaptación al cambio', 3, 9), 
('D. Ejes de vigilancia', 4, 9)
,
('A. Motivación y comunicación', 1, 10), ('B. Flexibilidad', 2, 10), ('C. Delegación y toma de decisiones', 2, 10), ('D. Relaciones interpersonales', 3, 10)
,
('A. Gestión de conflictos dentro del equipo', 1, 11), ('B. Trabajo en equipo y solución de problemas', 2, 11)
,
('A. Equilibrio emocional', 1, 12), ('B. Cumplimiento de compromisos', 2, 12), ('C. Adaptación', 2, 12), ('D. Tolerancia a la diversidad', 2, 12),

--E4
('A. PLANEAMIENTO Y ORGANIZACIÓN ', 1, 13), ('B. ORIENTACIÓN AL LOGRO DE METAS', 2, 13), ('C. INICIATIVA', 3, 13)
,
('A. Toma de decisiones', 1, 14), ('B. Comunicación', 2, 14), ('C. Relaciones interpersonales', 2, 14), ('D. Discrecionalidad', 3, 14)
,
('A. Participación del equipo', 1, 15)
,
('A. Equilibrio emocional', 1, 16), ('B. Cumplimiento de compromisos', 2, 16), ('C. Adaptación', 2, 16),

--E5
('A. Convertir la misión en acción', 1, 17), ('B. Sentido de propósito', 2, 17), ('C. Adaptación al cambio', 3, 17), ('D. Ejes de vigilancia', 3, 17)
,
('A. Motivación y comunicación', 1, 18), ('B. Flexibilidad', 2, 18), ('C. Delegación y toma de decisiones', 2, 18), ('D. Relaciones  interpersonales', 3, 18)
,
('A. Gestión de conflictos dentro del equipo', 1, 19), ('B. Trabajo en equipo y solución de problemas', 1, 19)
,
('A. Equilibrio emocional', 1, 20), ('B. Cumplimiento de compromisos', 2, 20), ('C. Adaptación', 2, 20), ('B. Tolerancia a la diversidad', 2, 20),

--E6
('A. Conocimiento y ejecución del trabajo', 1, 21), ('B. Logro de metas', 2, 21), ('C. Iniciativa', 3, 21), ('D. Responsabilidad', 3, 21), ('E. Exactitud y Calidad de trabajo', 3, 21)
,
('A. Comunicación', 1, 22), ('B. Relaciones interpersonales', 2, 22), ('C. Discrecionalidad', 2, 22)
,
('A. Participación del equipo', 1, 23)
,
('A. Equilibrio emocional', 1, 24), ('B. Cumplimiento de compromisos', 2, 24), ('C. Adaptación', 2, 24),

--E7
('A. Conocimiento y ejecución del trabajo', 1, 25), ('B. Logro de metas', 2, 25), ('C. Iniciativa', 3, 25), ('D. Responsabilidad', 3, 25)
,
('A. Comunicación', 1, 26), ('B. Relaciones interpersonales', 2, 26)
,
('A. Participación del equipo', 1, 27), ('B. Equilibrio emocional', 1, 27)

-- drop table rrhh_tipp_tipo_preguntas
create table rrhh_tipp_tipo_preguntas (
	tipp_codigo int primary key identity(1, 1),
	tipp_tipo varchar(50),--C: cerrada, M: multiple, A: abierta, CC: con cascada
	tipp_descripcion varchar(255),
	tipp_fecha_creacion datetime default getdate()
)
-- select * from rrhh_tipp_tipo_preguntas
insert into rrhh_tipp_tipo_preguntas (tipp_tipo, tipp_descripcion) values ('C', 'Es una pregunta con respuestas cerradas'), ('M', 'Es una pregunta con respuestas multiples'), ('A', 'Es una pregunta con respuesta abierta')

-- drop table rrhh_pre_preguntas
create table rrhh_pre_preguntas (
	pre_codigo int primary key identity(1, 1),
	pre_codtipp int foreign key references rrhh_tipp_tipo_preguntas,
	pre_codsubgru int foreign key references rrhh_subgru_sub_grupo,
	pre_orden_general int, -- numero de pregunta en la encuesta
	pre_orden int, -- numero de pregunta en el grupo
	pre_pregunta varchar(1024),
	pre_fecha_creacion datetime default getdate()
)
-- select * from rrhh_pre_preguntas
--E1
insert into rrhh_pre_preguntas (pre_codtipp, pre_codsubgru, pre_orden_general, pre_orden, pre_pregunta) values
(1, 1, 1, 1, '1. Muestra determinación para el logro de las metas'), 
(1, 1, 2, 2, '2. Compromete a otros para alcanzar la misión a través de los planes operativos'), 
(1, 1, 3, 3, '3. Busca oportunidades desafiantes para cambiar, crecer, innovar y mejorar las actividades de las unidades que conforman la  Vicerrectoría'), 
(1, 2, 4, 1, '1. Orienta las acciones para lograr objetivos y superar los estándares de desempeño y los plazos fijados'), 
(1, 2, 5, 2, '2. Planifica el trabajo a partir de objetivos claramente definidos y realistas'), 
(1, 2, 6, 3, '3. Establece relación entre los resultados obtenidos y los recursos invertidos en términos de calidad, costo y oportunidad'), 
(1, 3, 7, 1, '1. Ve el servicio educativo desde la perspectiva del alumno'), 
(1, 3, 8, 2, '2. Dedica tiempo importante para observar por sí mismo el desarrollo de las operaciones y verifica si están satisfaciendo a los diferentes públicos de interés'), 
(1, 3, 9, 3, '3. Dirige su atención hacia las fallas en el alcance de los estándares de calidad'), 
(1, 4, 10, 1, '1. Sugiere métodos sencillos para proveer mejores servicios educativos a los alumnos'), 
(1, 4, 11, 2, '2. Actúa como agente de cambio y hace realidad los proyectos'), 
(1, 4, 12, 3, '3. Busca oportunidades en el cambio y no excusas para evitarlo'), 
(1, 5, 13, 1, '1. Identifica y escucha las principales variables del entorno relacionados con el quehacer de la Universidad'), 
(1, 5, 14, 2, '2. Actúa rápidamente ante temas de alerta temprana como: posibles iniciativas de la competencia, cambios y sus implicaciones, modificaciones en leyes y reglamentos que haya que cumplir'), 
(1, 5, 15, 3, '3. Identifica y evalúa las oportunidades y amenazas en relación a otras instituciones de educación superior'),
(1, 6, 16, 1, '1. Anima a expresar ideas y opiniones de sus colaboradores y mantiene una buena comunicación'), 
(1, 6, 17, 2, '2. Escucha atentamente las preocupaciones de sus colaboradores'), 
(1, 6, 18, 3, '3. Refuerza el sentido de la autoestima y la autovaloración de sus colaboradores'), 
(1, 7, 19, 1, '1. Delega poder y autoridad a sus colaboradores'), 
(1, 7, 20, 2, '2. Fortalece a los demás compartiendo poder e información'), 
(1, 7, 21, 3, '3. Analiza, evalúa y reúne alternativas  para encontrar soluciones'), 
(1, 7, 22, 4, '4. Toma en cuenta la experiencia, el buen juicio y las habilidades en la toma de decisiones'), 
(1, 7, 23, 5, '5. Prevé los efectos en el futuro sobre las decisiones tomadas'), 
(1, 8, 24, 1, '1. Cuenta con habilidades necesarias para manejar equipos de trabajo'), 
(1, 8, 25, 2, '2. Permite a los colaboradores contar con toda la capacidad para el ejercicio de sus actividades'), 
(1, 8, 26, 3, '3. Conoce nuevas técnicas y tendencias de gerenciamiento (coaching, empowerment, etc.)'), 
(1, 8, 27, 4, '4. Aporta con su trabajo a una mayor satisfacción de todos los públicos de interés de la Universidad (alumnos, docentes, ejecutivos, instituciones normativas de educación, público externo)'), 
(1, 8, 28, 5, '5. Fomenta la colaboración, promoviendo un ambiente colaborativo, compartiendo y generando confianza'), 
(1, 9, 29, 1, '1. Permite las discrepancias en el equipo, para considerar nuevas ideas o nuevos puntos de vista'),
(1, 9, 30, 2, '2. Propicia que los miembros del equipo expresen los conflictos de forma abierta y discutiendo las diferencias'),
(1, 9, 31, 3, '3. Genera un clima en donde las personas del grupo aceptan las críticas de forma positiva'),
(1, 9, 32, 4, '4. Encauza los conflictos sobre las ideas y los métodos y no sobre las personas'),
(1, 9, 33, 5, '5. Favorece un clima de trabajo agradable, sin olvidar los objetivos del equipo'),
(1, 10, 34, 1, '1. Procura la utilización de datos y métodos para la solución de problemas plateados'),
(1, 10, 35, 2, '2. Potencia la creatividad para la solución de los problemas o propuestas'),
(1, 10, 36, 3, '3. Fomenta la genera alternativas de solución ante los problemas'),
(1, 10, 37, 4, '4. Permite que los miembros participen en las tareas del equipo'),
(1, 10, 38, 5, '5. Sugiere el uso de razonamiento y pensamiento crítico en la solución de problemas'),			   
(1, 11, 39, 1, '1. Mantiene el  equilibrio  aun en momentos  críticos'),
(1, 11, 40, 2, '2. Piensa con claridad y permanece centrado a pesar de las presiones'),
(1, 11, 41, 3, '3. Genera confianza en los demás por su actitud positiva  y franqueza'),
(1, 11, 42, 4, '4. Admite sus errores y se afana en corregirlos'),
(1, 11, 43, 5, '5. Es una persona optimista'),
(1, 12, 44, 1, '1. Cumple sus compromisos y sus promesas'),
(1, 12, 45, 2, '2. Gestiona su tiempo según prioridades'),
(1, 12, 46, 3, '3. Muestra iniciativa, empuje y energía hacia el logro de resultados'),
(1, 12, 47, 4, '4. Busca siempre nuevas ideas a partir de diferentes fuentes'),
(1, 12, 48, 5, '5. Mantiene la ecuanimidad frente a las demandas de trabajo'),
(1, 13, 49, 1, '1. Se adapta rápidamente a los cambios'),
(1, 13, 50, 2, '2. Inspira a otras personas a emprender esfuerzos desacostumbrados'),
(1, 13, 51, 3, '3. Considera que los errores son oportunidades de aprendizaje'),
(1, 13, 52, 4, '4. Escucha y muestra empatía  con las emociones de los demás'),
(1, 13, 53, 5, '5. Fortalece a los demás,  alentando al máximo sus habilidades'),
(1, 14, 54, 1, '1. Afronta los prejuicios y la intolerancia'),
(1, 14, 55, 2, '2. Alienta cualidades grupales como el respeto, la disponibilidad y la cooperación'),
(1, 14, 56, 3, '3. Maneja a las personas difíciles y las situaciones tensas con diplomacia y tacto'),
(1, 14, 57, 4, '4. Evita comentarios nocivos e inconfidentes hacia otras personas'),
(1, 14, 58, 5, '5. Considera la diversidad como una oportunidad para desarrollarse')
--E2
insert into rrhh_pre_preguntas (pre_codtipp, pre_codsubgru, pre_orden_general, pre_orden, pre_pregunta) values
(1, 15, 1, 1, '1. Muestra determinación para el logro de las metas'),
(1, 15, 2, 2, '2. Enfatiza la importancia de tener una misión compartida y alinea el desempeño de su colaboradores con la misión'),
(1, 15, 3, 3, '3. Compromete a otros para alcanzar la misión a través de los planes operativos'),
(1, 15, 4, 4, '4. Transforma la estrategia en resultado'),
(1, 15, 5, 5, '5. Busca oportunidades desafiantes para cambiar, crecer, innovar y mejora la Facultad/Escuela'),
(1, 16, 6, 1, '1. Orienta las acciones para lograr objetivos y superar los estándares de desempeño y los plazos fijados'),
(1, 16, 7, 2, '2. Planifica el trabajo a partir de objetivos claramente definidos y realistas'),
(1, 16, 8, 3, '3. Establece relación entre los resultados obtenidos y los recursos invertidos en términos de calidad, costo y oportunidad'),
(1, 16, 9, 4, '4. Expone en forma clara a sus colaboradores, la Visión, Misión y propósitos de la Universidad'),
(1, 16, 10, 5, '5. Crea un ambiente de trabajo positivo sustentado en los valores de la universidad'),
(1, 17, 11, 1, '1. Ve el servicio educativo desde la perspectiva del alumno'),
(1, 17, 12, 2, '2. Escucha al alumno y da prioridad a esclarecer sus dudas'),
(1, 17, 13, 3, '3. Dirige su atención hacia las fallas en el alcance de los estándares de calidad'),
(1, 17, 14, 4, '4. Promueve el uso de mejores procesos de atención a los alumnos'),
(1, 17, 15, 5, '5. Inspira y demuestra pasión por la excelencia en cada aspecto del trabajo'),
(1, 18, 16, 1, '1. Se muestra firme creyente en el cambio continuo'),
(1, 18, 17, 2, '2. Demuestra fuerza emocional para manejar la angustia causada por el cambio'),
(1, 18, 18, 3, '3. Busca métodos sencillos para proveer mejores productos o servicios educativos a los alumnos'),
(1, 18, 19, 4, '4. Actúa como agente de cambio y hace realidad los proyectos'),
(1, 18, 20, 5, '5. Busca oportunidades en el cambio y no excusas para evitarlo'),
(1, 19, 21, 1, '1. Identifica y escucha las principales variables del entorno relacionados con el quehacer de la Facultad/escuela'),
(1, 19, 22, 2, '2. Actúa rápidamente ante los cambios en la demanda de los alumnos potenciales y reales por sus productos y servicios educativos'),
(1, 19, 23, 3, '3. Identifica y evalúa las oportunidades y amenazas en relación a otras instituciones de educación superior'),
(1, 19, 24, 4, '4. Estudia sistemáticamente las fuerzas del mercado, alrededor del sistema de educación superior'),
(1, 19, 25, 5, '5. Permanece en constante atención de la tecnología que ofrece el mercado para su Facultad'),
(1, 20, 26, 1, '1. Trata a sus colaboradores como personas con diferentes necesidades, habilidades, metas y expectativas'),
(1, 20, 27, 2, '2. Anima a expresar ideas y opiniones de sus colaboradores y mantiene una buena comunicación'),
(1, 20, 28, 3, '3. Escucha atentamente las preocupaciones de sus colaboradores'),
(1, 20, 29, 4, '4. Reconoce un trabajo bien realizado y motiva hacia el logro del éxito'),
(1, 20, 30, 5, '5. Refuerza el sentido de la autoestima y la autovaloración de sus colaboradores'),
(1, 21, 31, 1, '1. Rectifica cuando es preciso, sus opiniones y actitudes'),
(1, 21, 32, 2, '2. Adopta nuevas ideas y acepta el desafío'),
(1, 21, 33, 3, '3. Anima a pensar en forma no tradicional para tratar problemas tradicionales'),
(1, 21, 34, 4, '4. Experimenta y corre riesgos'),
(1, 21, 35, 5, '5. Posee actitudes de adaptación al cambio para garantizar la sobrevivencia de la Facultad/escuela'),
(1, 22, 36, 1, '1. Delega poder y autoridad a sus colaboradores'),
(1, 22, 37, 2, '2. Fortalece a los demás compartiendo poder e información'),
(1, 22, 38, 3, '3. Analiza, evalúa y reúne alternativas  para encontrar soluciones'),
(1, 22, 39, 4, '4. Toma en cuenta la experiencia, el buen juicio y las habilidades en la toma de decisiones'),
(1, 22, 40, 5, '5. Prevé los efectos en el futuro sobre las decisiones tomadas'),
(1, 23, 41, 1, '1. Cuenta con habilidades necesarias para manejar equipos de trabajo'),
(1, 23, 42, 2, '2. Permite a los colaboradores contar con toda la capacidad para el ejercicio de sus actividades'),
(1, 23, 43, 3, '3. Conoce nuevas técnicas y tendencias de gerenciamiento (coaching, empowerment, etc.)'),
(1, 23, 44, 4, '4. Aporta con su trabajo a una mayor satisfacción de todos sus públicos de interés (alumnos, docentes, ejecutivos, público externo)'),
(1, 23, 45, 5, '5. Fomenta la colaboración, promoviendo un ambiente colaborativo, compartiendo y generando confianza'),
(1, 24, 46, 1, '1. Permite las discrepancias en el equipo, para considerar nuevas ideas o nuevos puntos de vista'),
(1, 24, 47, 2, '2. Propicia que los miembros del equipo expresen los conflictos de forma abierta y discutiendo las diferencias'),
(1, 24, 48, 3, '3. Genera un clima en donde las personas del grupo aceptan las críticas de forma positiva'),
(1, 24, 49, 4, '4. Encauza los conflictos sobre las ideas y los métodos y no sobre las personas'),
(1, 24, 50, 5, '5. Favorece un clima de trabajo agradable, sin olvidar los objetivos del equipo'),
(1, 25, 51, 1, '1. Utiliza  datos y métodos para la solución de problemas plateados'),
(1, 25, 52, 2, '2. Potencia la creatividad para la solución de los problemas o propuestas'),
(1, 25, 53, 3, '3. Genera alternativas de solución ante los problemas'),
(1, 25, 54, 4, '4. Permite que los miembros participen en las tareas del equipo'),
(1, 25, 55, 5, '5. Sugiere el uso de razonamiento y pensamiento crítico en la solución de problemas'),
(1, 26, 56, 1, '1. Mantiene el  equilibrio  aun en momentos  críticos'),
(1, 26, 57, 2, '2. Piensa con claridad y permanece centrado a pesar de las presiones'),
(1, 26, 58, 3, '3. Genera confianza en los demás por su actitud positiva  y franqueza'),
(1, 26, 59, 4, '4. Admite sus errores y se afana en corregirlos'),
(1, 26, 60, 5, '5. Es una persona optimista'),
(1, 27, 61, 1, '1. Cumple sus compromisos y sus promesas'),
(1, 27, 62, 2, '2. Gestiona su tiempo según prioridades'),
(1, 27, 63, 3, '3. Muestra iniciativa, empuje y energía hacia el logro de resultados'),
(1, 27, 64, 4, '4. Busca siempre nuevas ideas a partir de diferentes fuentes'),
(1, 27, 65, 5, '5. Mantiene la ecuanimidad frente a las demandas de trabajo'),
(1, 28, 66, 1, '1. Se adapta rápidamente a los cambios'),
(1, 28, 67, 2, '2. Inspira a otras personas a emprender esfuerzos desacostumbrados'),
(1, 28, 68, 3, '3. Considera que los errores son oportunidades de aprendizaje'),
(1, 28, 69, 4, '4. Escucha y muestra empatía  con las emociones de los demás'),
(1, 28, 70, 5, '5. Fortalece a los demás,  alentando al máximo sus habilidades'),
(1, 29, 71, 1, '1. Afronta los prejuicios y la intolerancia'),
(1, 29, 72, 2, '2. Alienta cualidades grupales como el respeto, la disponibilidad y la cooperación'),
(1, 29, 73, 3, '3. Maneja a las personas difíciles y las situaciones tensas con diplomacia y tacto'),
(1, 29, 74, 4, '4. Evita comentarios nocivos e inconfidentes hacia otras personas'),
(1, 29, 75, 5, '5. Considera la diversidad como una oportunidad para desarrollarse')
--E3
insert into rrhh_pre_preguntas (pre_codtipp, pre_codsubgru, pre_orden_general, pre_orden, pre_pregunta) values
(1, 30, 1, 1, '1. Muestra determinación para el logro de las metas'),
(1, 30, 2, 2, '2. Enfatiza la importancia de tener una misión compartida y alinea el desempeño de su colaboradores con la misión'),
(1, 30, 3, 3, '3. Compromete a otros para alcanzar la misión a través de los planes operativos'),
(1, 30, 4, 4, '4. Transforma la estrategia en resultado'),
(1, 30, 5, 5, '5. Busca oportunidades desafiantes para cambiar, crecer, innovar y mejora su Dirección'),
(1, 31, 6, 1, '1. Orienta las acciones para lograr objetivos y superar los estándares de desempeño y los plazos fijados'),
(1, 31, 7, 2, '2. Planifica el trabajo a partir de objetivos claramente definidos y realistas'),
(1, 31, 8, 3, '3. Establece relación entre los resultados obtenidos y los recursos invertidos en términos de calidad, costo y oportunidad'),
(1, 31, 9, 4, '4. Expone en forma clara a sus colaboradores, la Visión, Misión y propósitos de la Universidad'),
(1, 31, 10, 5, '5. Crea un ambiente de trabajo positivo sustentado en los valores de la universidad'),
(1, 32, 11, 1, '1. Se muestra firme creyente en el cambio continuo'),
(1, 32, 12, 2, '2. Demuestra fuerza emocional para manejar la angustia causada por el cambio'),
(1, 32, 13, 3, '3. Valora las ventajas de los cambios y se adapta y ajusta a la nueva realidad'),
(1, 32, 14, 4, '4. Actúa como agente de cambio y hace realidad los proyectos'),
(1, 32, 15, 5, '5. Busca oportunidades en el cambio y no excusas para evitarlo'),
(1, 33, 16, 1, '1. Identifica y escucha las principales variables del entorno relacionados con el quehacer de la Dirección'),
(1, 33, 17, 2, '2. Proporciona a la Administración Superior, un marco de referencia de los diferentes acontecimientos externos y de interés para la universidad'),
(1, 33, 18, 3, '3. Identifica y evalúa las oportunidades y amenazas y presenta prospectivas a la Administración Superior'),
(1, 33, 19, 4, '4. Potencia la generación de ideas innovadoras con su equipo de trabajo'),
(1, 33, 20, 5, '5. Identifica oportunidades de desarrollo para la Dirección que dirige'),
(1, 34, 21, 1, '1. Trata a sus colaboradores como personas con diferentes necesidades, habilidades, metas y expectativas'),
(1, 34, 22, 2, '2. Anima a expresar ideas y opiniones de sus colaboradores y mantiene una buena comunicación'),
(1, 34, 23, 3, '3. Escucha atentamente las preocupaciones de sus colaboradores'),
(1, 34, 24, 4, '4. Reconoce un trabajo bien realizado y motiva hacia el logro del éxito'),
(1, 34, 25, 5, '5. Refuerza el sentido de la autoestima y la autovaloración de sus colaboradores'),
(1, 35, 26, 1, '1. Rectifica cuando es preciso, sus opiniones y actitudes'),
(1, 35, 27, 2, '2. Adopta nuevas ideas y acepta el desafío'),
(1, 35, 28, 3, '3. Anima a pensar en forma no tradicional para tratar problemas tradicionales'),
(1, 35, 29, 4, '4. Experimenta y corre riesgos'),
(1, 35, 30, 5, '5. Posee actitudes de adaptación al cambio para garantizar la sobrevivencia de la Facultad/escuela'),
(1, 36, 31, 1, '1. Delega poder y autoridad a sus colaboradores'),
(1, 36, 32, 2, '2. Fortalece a los demás compartiendo poder e información'),
(1, 36, 33, 3, '3. Analiza, evalúa y reúne alternativas  para encontrar soluciones'),
(1, 36, 34, 4, '4. Toma en cuenta la experiencia, el buen juicio y las habilidades en la toma de decisiones'),
(1, 36, 35, 5, '5. Prevé los efectos en el futuro sobre las decisiones tomadas'),
(1, 37, 36, 1, '1. Cuenta con habilidades necesarias para manejar equipos de trabajo'),
(1, 37, 37, 2, '2. Permite a los colaboradores contar con toda la capacidad para el ejercicio de sus actividades'),
(1, 37, 38, 3, '3. Conoce nuevas técnicas y tendencias de gerenciamiento (coaching, empowerment, etc.)'),
(1, 37, 39, 4, '4. Aporta con su trabajo a una mayor satisfacción de todos sus públicos de interés (alumnos, docentes, ejecutivos, público externo)'),
(1, 37, 40, 5, '5. Fomenta la colaboración, promoviendo un ambiente colaborativo, compartiendo y generando confianza'),
(1, 38, 41, 1, '1. Permite las discrepancias en el equipo, para considerar nuevas ideas o nuevos puntos de vista'),
(1, 38, 42, 2, '2. Propicia que los miembros del equipo expresen los conflictos de forma abierta y discutiendo las diferencias'),
(1, 38, 43, 3, '3. Genera un clima en donde las personas del grupo aceptan las críticas de forma positiva'),
(1, 38, 44, 4, '4. Encauza los conflictos sobre las ideas y los métodos y no sobre las personas'),
(1, 38, 45, 5, '5. Favorece un clima de trabajo agradable, sin olvidar los objetivos del equipo'),
(1, 39, 46, 1, '1. Utiliza  datos y métodos para la solución de problemas plateados'),
(1, 39, 47, 2, '2. Potencia la creatividad para la solución de los problemas o propuestas'),
(1, 39, 48, 3, '3. Genera alternativas de solución ante los problemas'),
(1, 39, 49, 4, '4. Permite que los miembros participen en las tareas del equipo'),
(1, 39, 50, 5, '5. Sugiere el uso de razonamiento y pensamiento crítico en la solución de problemas'),
(1, 40, 51, 1, '1. Mantiene el  equilibrio  aun en momentos  críticos'),
(1, 40, 52, 2, '2. Piensa con claridad y permanece centrado a pesar de las presiones'),
(1, 40, 53, 3, '3. Genera confianza en los demás por su actitud positiva  y franqueza'),
(1, 40, 54, 4, '4. Admite sus errores y se afana en corregirlos'),
(1, 40, 55, 5, '5. Es una persona optimista'),
(1, 41, 56, 1, '1. Cumple sus compromisos y sus promesas'),
(1, 41, 57, 2, '2. Gestiona su tiempo según prioridades'),
(1, 41, 58, 3, '3. Muestra iniciativa, empuje y energía hacia el logro de resultados'),
(1, 41, 59, 4, '4. Busca siempre nuevas ideas a partir de diferentes fuentes'),
(1, 41, 60, 5, '5. Mantiene la ecuanimidad frente a las demandas de trabajo'),
(1, 42, 61, 1, '1. Se adapta rápidamente a los cambios'),
(1, 42, 62, 2, '2. Inspira a otras personas a emprender esfuerzos desacostumbrados'),
(1, 42, 63, 3, '3. Considera que los errores son oportunidades de aprendizaje'),
(1, 42, 64, 4, '4. Escucha y muestra empatía  con las emociones de los demás'),
(1, 42, 65, 5, '5. Fortalece a los demás,  alentando al máximo sus habilidades'),
(1, 43, 66, 1, '1. Afronta los prejuicios y la intolerancia'),
(1, 43, 67, 2, '2. Alienta cualidades grupales como el respeto, la disponibilidad y la cooperación'),
(1, 43, 68, 3, '3. Maneja a las personas difíciles y las situaciones tensas con diplomacia y tacto'),
(1, 43, 69, 4, '4. Evita comentarios nocivos e inconfidentes hacia otras personas'),
(1, 43, 70, 5, '5. Considera la diversidad como una oportunidad para desarrollarse')
--E4
insert into rrhh_pre_preguntas (pre_codtipp, pre_codsubgru, pre_orden_general, pre_orden, pre_pregunta) values
(1, 44, 1, 1, '1. Aporta con ideas, cursos de acción, entre otros, para la formulación de la planificación operativa'), 
(1, 44, 2, 2, '2. Muestra una adecuada organización en su área de trabajo'), 
(1, 44, 3, 3, '3. Establece prioridades y administra el tiempo en basa a estas'), 
(1, 44, 4, 4, '4. Da seguimiento sistemático para cumplir el plan de trabajo'), 
(1, 44, 5, 5, '5. Maneja adecuadamente los  imprevistos de su área, que puedan afectar el cumplimiento del Plan de trabajo'), 
(1, 45, 6, 1, '1. Cumple con las tareas, procesos o proyectos encomendados'), 
(1, 45, 7, 2, '2. Orienta las acciones para lograr objetivos y superar los estándares de desempeño y los plazos fijados'), 
(1, 45, 8, 3, '3. Prioriza las metas para evitar la dispersión'), 
(1, 45, 9, 4, '4. Informa oportunamente a su jefe inmediato, de los obstáculos (técnicos, documentales o de otra índole) que pudiesen afectar el cumplimiento de las metas'), 
(1, 45, 10, 5, '5. Adopta un compromiso en la consecución de las metas propuestas para su unidad'), 
(1, 46, 11, 1, '1. Ejecuta sus actividades de rutina, sin esperar que se las estén recordando'), 
(1, 46, 12, 2, '2. Expresa soluciones asertivas ante eventos de su trabajo cotidiano'), 
(1, 46, 13, 3, '3. Es una persona proactiva y puede buscar información novedosa y oportuna'), 
(1, 46, 14, 4, '4. En situaciones extraordinarias, logra establecer nuevas estrategias para resolver de manera efectiva sus tareas'), 
(1, 46, 15, 5, '5. Anticipa problemas y actúa con prontitud'), 
(1, 47, 16, 1, '1. Atiende y resuelve en forma apropiada las diferentes situaciones que se presentan en su puesto de trabajo'), 
(1, 47, 17, 2, '2. Reúne los elementos necesarios para responder oportunamente ante situaciones que afectan su trabajo'), 
(1, 47, 18, 3, '3. Asume las causas y consecuencias de la toma de decisiones, según el grado de responsabilidad de su puesto'), 
(1, 47, 19, 4, '4. Toma en cuenta, en la toma de decisiones,  riesgos, recursos, calidad, normas, según el puesto que desempeña'), 
(1, 47, 20, 5, '5. Prevé los efectos en el futuro sobre la decisiones tomadas'), 
(1, 48, 21, 1, '1. Muestra atención y escucha activa en el intercambio comunicacional con otras personas'), 
(1, 48, 22, 2, '2. Maneja una comunicación asertiva, respetando valores y principios'), 
(1, 48, 23, 3, '3. Expresa a las personas relacionadas con su trabajo, sus ideas, necesidades o acciones'), 
(1, 48, 24, 4, '4. Acepta las ideas, necesidades y acciones de las personas, sean estos alumnos, compañeros, jefes, evitando lesionar los derechos de  todos los involucrados'), 
(1, 48, 25, 5, '5. Evita difundir mensaje  mal intencionados que dañen la dignidad de las personas'), 
(1, 49, 26, 1, '1. Atiende con cordialidad las dudas y necesidades de las personas con las que tiene relaciones de trabajo'), 
(1, 49, 27, 2, '2. Respeta la diversidad  en los comportamientos  de las personas'), 
(1, 49, 28, 3, '3. Entabla relaciones de trabajo cordiales y respetuosas'), 
(1, 49, 29, 4, '4. Explica sus decisiones y líneas de pensamiento a las personas con las que se relaciona en el trabajo'), 
(1, 49, 30, 5, '5. Es sensible a las necesidades de sus compañeros'), 
(1, 50, 31, 1, '1. Canaliza la información a las personas indicadas, guardando la discreción requerida'), 
(1, 50, 32, 2, '2. Realiza trámites y seguimientos asignados, con la reserva que amerite'), 
(1, 50, 33, 3, '3. No comenta con terceros, información que maneja y  que podría afectar los programas o proyectos propios de la institución'), 
(1, 50, 34, 4, '4. Es prudente y sensible. No arriesga a personas por develar información'), 
(1, 50, 35, 5, '5. Mantiene una postura de lealtad  y confidencialidad hacia la institución'), 
(1, 51, 36, 1, '1. Posee  iniciativa y una actitud positiva ante los integrantes del equipo'), 
(1, 51, 37, 2, '2. Su comunicación es   clara y  genera trabajo efectivo'), 
(1, 51, 38, 3, '3. Trabaja de manera coordinada con sus compañeros de equipo'), 
(1, 51, 39, 4, '4. Plantea nuevas ideas, cuando trabaja en equipo'), 
(1, 51, 40, 5, '5. Se interesa en los planteamientos de los miembros del equipo, para fortalecer la capacidad de análisis y solución de problemas'), 
(1, 52, 41, 1, '1. Mantiene el  equilibrio aun en momentos  críticos'), 
(1, 52, 42, 2, '2. Piensa con claridad y permanece centrado a pesar de las presiones'), 
(1, 52, 43, 3, '3. Genera confianza en los demás por su honradez y franqueza'), 
(1, 52, 44, 4, '4. Admite sus errores y se afana por corregirlos'), 
(1, 52, 45, 5, '5. Es una persona optimista'), 
(1, 53, 46, 1, '1. Cumple sus compromisos y sus promesas'), 
(1, 53, 47, 2, '2. Gestiona su tiempo según prioridades'), 
(1, 53, 48, 3, '3. Muestra iniciativa hacia el logro de metas'), 
(1, 53, 49, 4, '4. Busca siempre nuevas ideas a partir de diferentes fuentes'), 
(1, 53, 50, 5, '5. Mantiene la ecuanimidad frente a las  demandas del trabajo'), 
(1, 54, 51, 1, '1. Se adapta rápidamente a los cambios'), 
(1, 54, 52, 2, '2. Inspira a otras personas a emprender esfuerzos desacostumbrados'), 
(1, 54, 53, 3, '3. Considera que los errores son oportunidades de aprendizaje'), 
(1, 54, 54, 4, '4. Escucha y muestra empatía  con las emociones de los demás'), 
(1, 54, 55, 5, '5. Fortalece a los demás,  alentando al máximo sus habilidades')
--E5
insert into rrhh_pre_preguntas (pre_codtipp, pre_codsubgru, pre_orden_general, pre_orden, pre_pregunta) values
(1, 55, 1, 1, '1. Muestra determinación para el logro de las metas'), 
(1, 55, 2, 2, '2. Enfatiza la importancia de tener una misión compartida y alinea el desempeño de su colaboradores con la misión'), 
(1, 55, 3, 3, '3. Compromete a sus colaboradores para alcanzar la misión a través de los planes operativos'), 
(1, 55, 4, 4, '4. Transforma la estrategia en resultado'), 
(1, 55, 5, 5, '5. Busca oportunidades desafiantes para cambiar, crecer, innovar y mejora su Dirección'), 
(1, 56, 6, 1, '1. Orienta las acciones para lograr objetivos y superar los estándares de desempeño y los plazos fijados'), 
(1, 56, 7, 2, '2. Planifica el trabajo a partir de objetivos claramente definidos y realistas'), 
(1, 56, 8, 3, '3. Establece relación entre los resultados obtenidos y los recursos invertidos en términos de calidad, costo y oportunidad'), 
(1, 56, 9, 4, '4. Expone en forma clara a sus colaboradores, la Visión, Misión y propósitos de la Universidad'), 
(1, 56, 10, 5, '5. Crea un ambiente de trabajo positivo sustentado en los valores de la universidad'), 
(1, 57, 11, 1, '1. Se muestra firme creyente en el cambio continuo'), 
(1, 57, 12, 2, '2. Demuestra fuerza emocional para manejar la angustia causada por el cambio'), 
(1, 57, 13, 3, '3. Valora las ventajas de los cambios y se adapta y ajusta a la nueva realidad'), 
(1, 57, 14, 4, '4. Actúa como agente de cambio y hace realidad los proyectos'), 
(1, 57, 15, 5, '5. Busca oportunidades en el cambio y no excusas para evitarlo'), 
(1, 58, 16, 1, '1. Identifica y escucha las principales variables del entorno relacionados con el quehacer de la Dirección'), 
(1, 58, 17, 2, '2. Proporciona a la Administración Superior, un marco de referencia de los diferentes acontecimientos externos y de interés para la universidad'), 
(1, 58, 18, 3, '3. Identifica y evalúa las oportunidades y amenazas y presenta prospectivas a la Administración Superior'), 
(1, 58, 19, 4, '4. Potencia la generación de ideas innovadoras con su equipo de trabajo'), 
(1, 58, 20, 5, '5. Identifica oportunidades de desarrollo para la Dirección que dirige'), 
(1, 59, 21, 1, '1. Trata a sus colaboradores como personas con diferentes necesidades, habilidades, metas y expectativas'), 
(1, 59, 22, 2, '2. Anima a expresar ideas y opiniones de sus colaboradores y mantiene una buena comunicación'), 
(1, 59, 23, 3, '3. Escucha atentamente las preocupaciones de sus colaboradores'), 
(1, 59, 24, 4, '4. Reconoce un trabajo bien realizado y motiva hacia el logro del éxito'), 
(1, 59, 25, 5, '5. Refuerza el sentido de la autoestima y la autovaloración de sus colaboradores'), 
(1, 60, 26, 1, '1. Rectifica cuando es preciso, sus opiniones y actitudes'), 
(1, 60, 27, 2, '2. Adopta nuevas ideas y acepta el desafío'), 
(1, 60, 28, 3, '3. Anima a pensar en forma no tradicional para tratar problemas tradicionales'), 
(1, 60, 29, 4, '4. Experimenta y corre riesgos'), 
(1, 60, 30, 5, '5. Posee actitudes de adaptación al cambio para garantizar la sobrevivencia de la Facultad/escuela'), 
(1, 61, 31, 1, '1. Delega poder y autoridad a sus colaboradores'), 
(1, 61, 32, 2, '2. Fortalece a los demás compartiendo poder e información'), 
(1, 61, 33, 3, '3. Analiza, evalúa y reúne alternativas  para encontrar soluciones'), 
(1, 61, 34, 4, '4. Toma en cuenta la experiencia, el buen juicio y las habilidades en la toma de decisiones'), 
(1, 61, 35, 5, '5. Prevé los efectos en el futuro sobre las decisiones tomadas'), 
(1, 62, 36, 1, '1. Cuenta con habilidades necesarias para manejar equipos de trabajo'), 
(1, 62, 37, 2, '2. Permite a los colaboradores contar con toda la capacidad para el ejercicio de sus actividades'), 
(1, 62, 38, 3, '3. Conoce nuevas técnicas y tendencias de gerenciamiento (coaching, empowerment, etc.)'), 
(1, 62, 39, 4, '4. Aporta con su trabajo a una mayor satisfacción de todos sus públicos de interés (alumnos, docentes, ejecutivos, público externo)'), 
(1, 62, 40, 5, '5. Fomenta la colaboración, promoviendo un ambiente colaborativo, compartiendo y generando confianza'), 
(1, 63, 41, 1, '1. Permite las discrepancias en el equipo, para considerar nuevas ideas o nuevos puntos de vista'), 
(1, 63, 42, 2, '2. Propicia que los miembros del equipo expresen los conflictos de forma abierta y discutiendo las diferencias'), 
(1, 63, 43, 3, '3. Genera un clima en donde las personas del grupo aceptan las críticas de forma positiva'), 
(1, 63, 44, 4, '4. Encauza los conflictos sobre las ideas y los métodos y no sobre las personas'), 
(1, 63, 45, 5, '5. Favorece un clima de trabajo agradable, sin olvidar los objetivos del equipo'), 
(1, 64, 46, 1, '1. Utiliza  datos y métodos para la solución de problemas plateados'), 
(1, 64, 47, 2, '2. Potencia la creatividad para la solución de los problemas o propuestas'), 
(1, 64, 48, 3, '3. Genera alternativas de solución ante los problemas'), 
(1, 64, 49, 4, '4. Permite que los miembros participen en las tareas del equipo'), 
(1, 64, 50, 5, '5. Sugiere el uso de razonamiento y pensamiento crítico en la solución de problemas'), 
(1, 65, 51, 1, '1. Mantiene el  equilibrio  aun en momentos  críticos'), 
(1, 65, 52, 2, '2. Piensa con claridad y permanece centrado a pesar de las presiones'), 
(1, 65, 53, 3, '3. Genera confianza en los demás por su actitud positiva  y franqueza'), 
(1, 65, 54, 4, '4. Admite sus errores y se afana en corregirlos'), 
(1, 65, 55, 5, '5. Es una persona optimista'), 
(1, 66, 56, 1, '1. Cumple sus compromisos y sus promesas'), 
(1, 66, 57, 2, '2. Gestiona su tiempo según prioridades'), 
(1, 66, 58, 3, '3. Muestra iniciativa, empuje y energía hacia el logro de resultados'), 
(1, 66, 59, 4, '4. Busca siempre nuevas ideas a partir de diferentes fuentes'), 
(1, 66, 60, 5, '5. Mantiene la ecuanimidad frente a las demandas de trabajo'), 
(1, 67, 61, 1, '1. Se adapta rápidamente a los cambios'), 
(1, 67, 62, 2, '2. Inspira a otras personas a emprender esfuerzos desacostumbrados'), 
(1, 67, 63, 3, '3. Considera que los errores son oportunidades de aprendizaje'), 
(1, 67, 64, 4, '4. Escucha y muestra empatía  con las emociones de los demás'), 
(1, 67, 65, 5, '5. Fortalece a los demás,  alentando al máximo sus habilidades'), 
(1, 68, 66, 1, '1. Afronta los prejuicios y la intolerancia'), 
(1, 68, 67, 2, '2. Alienta cualidades grupales como el respeto, la disponibilidad y la cooperación'), 
(1, 68, 68, 3, '3. Maneja a las personas difíciles y las situaciones tensas con diplomacia y tacto'), 
(1, 68, 69, 4, '4. Evita comentarios nocivos e inconfidentes hacia otras personas'), 
(1, 68, 70, 5, '5. Considera la diversidad como una oportunidad para desarrollarse')
--E6
insert into rrhh_pre_preguntas (pre_codtipp, pre_codsubgru, pre_orden_general, pre_orden, pre_pregunta) values
(1, 69, 1, 1, '1. Ejecuta las tareas y procedimientos de trabajo, en forma efectiva'),
(1, 69, 2, 2, '2. Muestra  precisión y esmero en los resultados del trabajo que realiza'),
(1, 69, 3, 3, '3. Da seguimiento adecuado a las tareas asignadas'),
(1, 69, 4, 4, '4. Maneja adecuadamente los  imprevistos que se presentan en el desarrollo de sus tareas'),
(1, 69, 5, 5, '5. Mantiene la productividad aun en situaciones de presión'),
(1, 70, 6, 1, '1. Cumple con las tareas y procesos  encomendados'),
(1, 70, 7, 2, '2. Realiza acciones para lograr las metas y cumplir con los plazos fijados'),
(1, 70, 8, 3, '3. Prioriza las metas para evitar la dispersión'),
(1, 70, 9, 4, '4. Informa oportunamente a su jefe inmediato, de los obstáculos (técnicos, documentales o de otra índole) que pudiesen afectar el cumplimiento del trabajo'),
(1, 70, 10, 5, '5. Se interesa  en el mejoramiento de su trabajo'),
(1, 71, 11, 1, '1. Ejecuta sus actividades de rutina, sin esperar que se las estén recordando'),
(1, 71, 12, 2, '2. Expresa soluciones asertivas ante eventos de su trabajo cotidiano'),
(1, 71, 13, 3, '3. Es una persona proactiva y puede buscar información novedosa y oportuna'),
(1, 71, 14, 4, '4. En situaciones extraordinarias logra establecer nuevas acciones para resolver de manera efectiva sus tareas'),
(1, 71, 15, 5, '5. Anticipa problemas y actúa con prontitud'),
(1, 72, 16, 1, '1. Atiende y resuelve en forma apropiada y  oportuna las diferentes situaciones que se presentan en su puesto de trabajo'),
(1, 72, 17, 2, '2. Considera riesgos, recursos, calidad, en las tareas que lleva a cabo'),
(1, 72, 18, 3, '3. Al tener conocimiento de una situación que afecta su trabajo, reúne los elementos necesarios y lo comunica oportunamente a su jefe inmediato'),
(1, 72, 19, 4, '4. Asume las causas y consecuencias de su trabajo, según el grado de responsabilidad de su puesto'),
(1, 72, 20, 5, '5. Cumple con los compromisos, las normas, los horarios y demás lineamientos propios de su puesto de trabajo'),
(1, 73, 21, 1, '1. Reporta con la frecuencia y calidad requerida el avance de las tareas asignada'),
(1, 73, 22, 2, '2. Posee rapidez y exactitud en la creación de documentos (procesador de texto, hojas de cálculo)'),
(1, 73, 23, 3, '3. Posee capacidad de extraer información relevante, al presentar informes a su jefe inmediato'),
(1, 73, 24, 4, '4. Maneja equipo común de oficina (fotocopiadora, calculadora y otros)'),
(1, 73, 25, 5, '5. Tiene dominio de internet, Outlook, sistemas contables,  bibliotecarios, planillas, según el trabajo que desarrolla'),
(1, 74, 26, 1, '1. Muestra atención y escucha activa en el intercambio comunicacional con otras personas'),
(1, 74, 27, 2, '2. Maneja una comunicación asertiva, respetando valores y principios'),
(1, 74, 28, 3, '3. Expresa a las personas relacionadas con su trabajo, sus ideas, necesidades o acciones'),
(1, 74, 29, 4, '4. Acepta las ideas, necesidades y acciones de las personas sean estos alumnos, compañeros, jefes, evitando lesionar los derechos de  todos los involucrados'),
(1, 74, 30, 5, '5. Evita difundir mensajes mal intencionados que dañen la dignidad de las personas'),
(1, 75, 31, 1, '1. Atiende con cordialidad las dudas y necesidades de las personas con las que tiene relaciones de trabajo'),
(1, 75, 32, 2, '2. Respeta la diversidad  en los comportamientos  de las personas'),
(1, 75, 33, 3, '3. Entabla relaciones de trabajo cordiales y respetuosas'),
(1, 75, 34, 4, '4. Explica sus decisiones y líneas de pensamiento a las personas con las que se relaciona en el trabajo'),
(1, 75, 35, 5, '5. Es sensible a las necesidades de sus compañeros'),
(1, 76, 36, 1, '1. Canaliza la información a las personas indicadas, guardando la discreción requerida'),
(1, 76, 37, 2, '2. Realiza trámites y seguimientos asignados, con la reserva que amerite'),
(1, 76, 38, 3, '3. No comenta con terceros, información que maneja, y  que podría afectar los programas o proyectos propios de la unidad organizativa'),
(1, 76, 39, 4, '4. Es prudente y sensible. No arriesga a personas por develar información'),
(1, 76, 40, 5, '5. Mantiene una postura de lealtad  y confidencialidad hacia la institución'),
(1, 77, 41, 1, '1. Posee  iniciativa y una actitud positiva ante los integrantes del equipo'),
(1, 77, 42, 2, '2. Su comunicación es   clara y  genera trabajo efectivo'),
(1, 77, 43, 3, '3. Trabaja de manera coordinada con sus compañeros de equipo'),
(1, 77, 44, 4, '4. Plantea nuevas ideas, cuando trabaja en equipo'),
(1, 77, 45, 5, '5. Se interesa en los planteamientos de los miembros del equipo, para fortalecer la capacidad de análisis y solución de problemas'),
(1, 78, 46, 1, '1. Es una persona  equilibrada aun en momentos críticos'),
(1, 78, 47, 2, '2. Piensa con claridad y permanece centrado a pesar de las presiones'),
(1, 78, 48, 3, '3. Genera confianza en los demás por su honradez y franqueza'),
(1, 78, 49, 4, '4. Admite sus errores y se afana por corregirlos'),
(1, 78, 50, 5, '5. Es una persona optimista'),
(1, 79, 51, 1, '1. Cumple sus compromisos y sus promesas'),
(1, 79, 52, 2, '2. Gestiona su tiempo según prioridades'),
(1, 79, 53, 3, '3. Muestra iniciativa en el cumplimiento de sus tareas'),
(1, 79, 54, 4, '4. Busca siempre nuevas ideas a partir de diferentes fuentes'),
(1, 79, 55, 5, '5. Mantiene la ecuanimidad frente a las demandas del trabajo'),
(1, 80, 56, 1, '1. Se adapta rápidamente a los cambios'),
(1, 80, 57, 2, '2. Emprende esfuerzos desacostumbrados'),
(1, 80, 58, 3, '3. Considera que los errores son oportunidades de aprendizaje'),
(1, 80, 59, 4, '4. Escucha y muestra empatía  con las emociones de los demás'),
(1, 80, 60, 5, '5. Fortalece al máximo sus habilidades')
--E7
insert into rrhh_pre_preguntas (pre_codtipp, pre_codsubgru, pre_orden_general, pre_orden, pre_pregunta) values
(1, 81, 1, 1, '1. Ejecuta las tareas y procesos de trabajo, en forma efectiva'), 
(1, 81, 2, 2, '2. Muestra  esmero en los resultados del trabajo que realiza'), 
(1, 81, 3, 3, '3. Da seguimiento adecuado a las tareas asignadas'), 
(1, 81, 4, 4, '4. Realiza sus actividades en el tiempo estimado para la misma'), 
(1, 81, 5, 5, '5. Mantiene la productividad aun en situaciones de presión'), 
(1, 82, 6, 1, '1. Cumple con las tareas y procedimientos  encomendados'), 
(1, 82, 7, 2, '2. Trata de  realizar sus tareas  en el menor tiempo posible'), 
(1, 82, 8, 3, '3. Posee alta capacidad de servicio'), 
(1, 82, 9, 4, '4. Informa oportunamente a su jefe inmediato, de los obstáculos que pudiesen afectar el cumplimiento del trabajo'), 
(1, 82, 10, 5, '5. Se interesa  en el mejoramiento de su trabajo'), 
(1, 83, 11, 1, '1. Ejecuta sus actividades de rutina, sin esperar que se las estén recordando'), 
(1, 83, 12, 2, '2. Recomienda soluciones  a los trabajos cotidianos  que realiza'), 
(1, 83, 13, 3, '3. Ofrece colaboración en el trabajo'), 
(1, 83, 14, 4, '4. Es espontáneo para dar a la institución tiempo extraordinario'), 
(1, 83, 15, 5, '5. Anticipa problemas y actúa con prontitud'), 
(1, 84, 16, 1, '1. Mantiene excelente orden y aseo en el área o equipo de trabajo asignado'), 
(1, 84, 17, 2, '2. Siempre guarda y limpia sus instrumentos de trabajo'), 
(1, 84, 18, 3, '3. Al tener conocimiento de una situación que afecta el trabajo, lo comunica oportunamente a su jefe inmediato'), 
(1, 84, 19, 4, '4. Asume las causas y consecuencias de su trabajo, según el grado de responsabilidad de su puesto'), 
(1, 84, 20, 5, '5. Cumple con los compromisos, las normas, los horarios y demás lineamientos propios de su puesto de trabajo'), 
(1, 85, 21, 1, '1. Muestra atención cuando se comunica  con otras personas'), 
(1, 85, 22, 2, '2. Maneja una comunicación de respeto  hacia valores y principios'), 
(1, 85, 23, 3, '3. Mantiene buenas relaciones de coordinación y trabajo en equipo con el personal de la unidad y otras unidades que requieren de sus servicios'), 
(1, 85, 24, 4, '4. Acepta las ideas de las personas, evitando lesionar los derechos de  los demás'), 
(1, 85, 25, 5, '5. Evita difundir mensajes mal intencionado que dañen la dignidad de las personas'), 
(1, 86, 26, 1, '1. Es  amigable  y de buen trato'), 
(1, 86, 27, 2, '2. Respeta la diversidad  en los comportamientos  de las personas'), 
(1, 86, 28, 3, '3. Entabla relaciones de trabajo cordiales y respetuosas'), 
(1, 86, 29, 4, '4. Siempre muestra colaboración espontánea'), 
(1, 86, 30, 5, '5. Es sensible a las necesidades de sus compañeros'), 
(1, 87, 31, 1, '1. Posee  iniciativa y una actitud positiva ante los integrantes del equipo de trabajo'), 
(1, 87, 32, 2, '2. Coopera con el trabajo del equipo'), 
(1, 87, 33, 3, '3. Trabaja de manera coordinada con sus compañeros de trabajo'), 
(1, 87, 34, 4, '4. Propone nuevas ideas, cuando trabaja en equipo'), 
(1, 87, 35, 5, '5. Mantiene la ecuanimidad frente a las demandas del trabajo'), 
(1, 88, 36, 1, '1. Es una persona  equilibrada aun en momentos críticos'), 
(1, 88, 37, 2, '2. Piensa con claridad y permanece centrado a pesar de las presiones'), 
(1, 88, 38, 3, '3. Genera confianza en los demás por su honradez y franqueza'), 
(1, 88, 39, 4, '4. Admite sus errores y se afana por corregirlos'), 
(1, 88, 40, 5, '5. Es una persona optimista')

-- drop table rrhh_tipo_tipo_opciones
create table rrhh_tipo_tipo_opciones (
	tipo_codigo int primary key identity(1, 1),
	tipo_tipo varchar(50),--c: cerrada, a: abierta, 
	tipo_descripcion varchar(255),
	tipo_fecha_creacion datetime default getdate()
)
-- select * from rrhh_tipo_tipo_opciones
insert into rrhh_tipo_tipo_opciones (tipo_tipo, tipo_descripcion) values ('c', 'Es una opción de respuesta cerrada'), ('a', 'Es una opción de respuesta abierta')

-- drop table rrhh_opc_opciones
create table rrhh_opc_opciones (
	opc_codigo int primary key identity(1, 1),
	opc_codenc int foreign key references rrhh_enc_encuestas,
	opc_opcion varchar(255),
	opc_abreviado varchar(30),
	opc_opcion_orden int,
	opc_fecha_creacion datetime default getdate()
)
-- select * from rrhh_opc_opciones
insert into rrhh_opc_opciones (opc_codenc, opc_abreviado, opc_opcion, opc_opcion_orden) values
(1, 'S', 'Siempre', 1), (1, 'AV', 'A veces', 3), (1, 'PV', 'Pocas veces', 4), (1, 'N', 'Nunca', 5), (1, 'MV', 'Muchas veces', 2),
(2, 'S', 'Siempre', 1), (2, 'AV', 'A veces', 3), (2, 'PV', 'Pocas veces', 4), (2, 'N', 'Nunca', 5), (2, 'MV', 'Muchas veces', 2),
(3, 'S', 'Siempre', 1), (3, 'AV', 'A veces', 3), (3, 'PV', 'Pocas veces', 4), (3, 'N', 'Nunca', 5), (3, 'MV', 'Muchas veces', 2),
(4, 'S', 'Siempre', 1), (4, 'AV', 'A veces', 3), (4, 'PV', 'Pocas veces', 4), (4, 'N', 'Nunca', 5), (4, 'MV', 'Muchas veces', 2),
(5, 'S', 'Siempre', 1), (5, 'AV', 'A veces', 3), (5, 'PV', 'Pocas veces', 4), (5, 'N', 'Nunca', 5), (5, 'MV', 'Muchas veces', 2),
(6, 'S', 'Siempre', 1), (6, 'AV', 'A veces', 3), (6, 'PV', 'Pocas veces', 4), (6, 'N', 'Nunca', 5), (6, 'MV', 'Muchas veces', 2),
(7, 'S', 'Siempre', 1), (7, 'AV', 'A veces', 3), (7, 'PV', 'Pocas veces', 4), (7, 'N', 'Nunca', 5), (7, 'MV', 'Muchas veces', 2)

-- drop table rrhh_preopc_preguntas_opciones
create table rrhh_preopc_preguntas_opciones (
	preopc_codigo int primary key identity(1, 1),
	preopc_codpre int foreign key references rrhh_pre_preguntas,
	preopc_codopc int foreign key references rrhh_opc_opciones,
	preopc_codtipo int foreign key references rrhh_tipo_tipo_opciones,
	preopc_opc_orden int,
	preopc_fecha_creacion datetime default getdate()
)
-- select * from rrhh_preopc_preguntas_opciones

--E1
insert into rrhh_preopc_preguntas_opciones (preopc_codpre, preopc_codopc, preopc_codtipo, preopc_opc_orden) values
(1, 1, 1, 1), (1, 2, 1, 2), (1, 3, 1, 3), (1, 4, 1, 4), (1, 5, 1, 5), (2, 1, 1, 1), (2, 2, 1, 2), (2, 3, 1, 3), (2, 4, 1, 4), (2, 5, 1, 5), (3, 1, 1, 1), (3, 2, 1, 2), (3, 3, 1, 3), (3, 4, 1, 4), (3, 5, 1, 5), (4, 1, 1, 1), (4, 2, 1, 2), (4, 3, 1, 3), (4, 4, 1, 4), (4, 5, 1, 5), (5, 1, 1, 1), (5, 2, 1, 2), (5, 3, 1, 3), (5, 4, 1, 4), (5, 5, 1, 5), (6, 1, 1, 1), (6, 2, 1, 2), (6, 3, 1, 3), (6, 4, 1, 4), (6, 5, 1, 5), (7, 1, 1, 1), (7, 2, 1, 2), (7, 3, 1, 3), (7, 4, 1, 4), (7, 5, 1, 5), (8, 1, 1, 1), (8, 2, 1, 2), (8, 3, 1, 3), (8, 4, 1, 4), (8, 5, 1, 5), (9, 1, 1, 1), (9, 2, 1, 2), (9, 3, 1, 3), (9, 4, 1, 4), (9, 5, 1, 5), (10, 1, 1, 1), (10, 2, 1, 2), (10, 3, 1, 3), (10, 4, 1, 4), (10, 5, 1, 5), (11, 1, 1, 1), (11, 2, 1, 2), (11, 3, 1, 3), (11, 4, 1, 4), (11, 5, 1, 5), (12, 1, 1, 1), (12, 2, 1, 2), (12, 3, 1, 3), (12, 4, 1, 4), (12, 5, 1, 5), (13, 1, 1, 1), (13, 2, 1, 2), (13, 3, 1, 3), (13, 4, 1, 4), (13, 5, 1, 5), (14, 1, 1, 1), (14, 2, 1, 2), (14, 3, 1, 3), (14, 4, 1, 4), (14, 5, 1, 5), (15, 1, 1, 1), (15, 2, 1, 2), (15, 3, 1, 3), (15, 4, 1, 4), (15, 5, 1, 5), (16, 1, 1, 1), (16, 2, 1, 2), (16, 3, 1, 3), (16, 4, 1, 4), (16, 5, 1, 5), (17, 1, 1, 1), (17, 2, 1, 2), (17, 3, 1, 3), (17, 4, 1, 4), (17, 5, 1, 5), (18, 1, 1, 1), (18, 2, 1, 2), (18, 3, 1, 3), (18, 4, 1, 4), (18, 5, 1, 5), (19, 1, 1, 1), (19, 2, 1, 2), (19, 3, 1, 3), (19, 4, 1, 4), (19, 5, 1, 5), (20, 1, 1, 1), (20, 2, 1, 2), (20, 3, 1, 3), (20, 4, 1, 4), (20, 5, 1, 5), (21, 1, 1, 1), (21, 2, 1, 2), (21, 3, 1, 3), (21, 4, 1, 4), (21, 5, 1, 5), (22, 1, 1, 1), (22, 2, 1, 2), (22, 3, 1, 3), (22, 4, 1, 4), (22, 5, 1, 5), (23, 1, 1, 1), (23, 2, 1, 2), (23, 3, 1, 3), (23, 4, 1, 4), (23, 5, 1, 5), (24, 1, 1, 1), (24, 2, 1, 2), (24, 3, 1, 3), (24, 4, 1, 4), (24, 5, 1, 5), (25, 1, 1, 1), (25, 2, 1, 2), (25, 3, 1, 3), (25, 4, 1, 4), (25, 5, 1, 5), (26, 1, 1, 1), (26, 2, 1, 2), (26, 3, 1, 3), (26, 4, 1, 4), (26, 5, 1, 5), (27, 1, 1, 1), (27, 2, 1, 2), (27, 3, 1, 3), (27, 4, 1, 4), (27, 5, 1, 5), (28, 1, 1, 1), (28, 2, 1, 2), (28, 3, 1, 3), (28, 4, 1, 4), (28, 5, 1, 5), (29, 1, 1, 1), (29, 2, 1, 2), (29, 3, 1, 3), (29, 4, 1, 4), (29, 5, 1, 5), (30, 1, 1, 1), (30, 2, 1, 2), (30, 3, 1, 3), (30, 4, 1, 4), (30, 5, 1, 5), (31, 1, 1, 1), (31, 2, 1, 2), (31, 3, 1, 3), (31, 4, 1, 4), (31, 5, 1, 5), (32, 1, 1, 1), (32, 2, 1, 2), (32, 3, 1, 3), (32, 4, 1, 4), (32, 5, 1, 5), (33, 1, 1, 1), (33, 2, 1, 2), (33, 3, 1, 3), (33, 4, 1, 4), (33, 5, 1, 5), (34, 1, 1, 1), (34, 2, 1, 2), (34, 3, 1, 3), (34, 4, 1, 4), (34, 5, 1, 5), (35, 1, 1, 1), (35, 2, 1, 2), (35, 3, 1, 3), (35, 4, 1, 4), (35, 5, 1, 5), (36, 1, 1, 1), (36, 2, 1, 2), (36, 3, 1, 3), (36, 4, 1, 4), (36, 5, 1, 5), (37, 1, 1, 1), (37, 2, 1, 2), (37, 3, 1, 3), (37, 4, 1, 4), (37, 5, 1, 5), (38, 1, 1, 1), (38, 2, 1, 2), (38, 3, 1, 3), (38, 4, 1, 4), (38, 5, 1, 5), (39, 1, 1, 1), (39, 2, 1, 2), (39, 3, 1, 3), (39, 4, 1, 4), (39, 5, 1, 5), (40, 1, 1, 1), (40, 2, 1, 2), (40, 3, 1, 3), (40, 4, 1, 4), (40, 5, 1, 5), (41, 1, 1, 1), (41, 2, 1, 2), (41, 3, 1, 3), (41, 4, 1, 4), (41, 5, 1, 5), (42, 1, 1, 1), (42, 2, 1, 2), (42, 3, 1, 3), (42, 4, 1, 4), (42, 5, 1, 5), (43, 1, 1, 1), (43, 2, 1, 2), (43, 3, 1, 3), (43, 4, 1, 4), (43, 5, 1, 5), (44, 1, 1, 1), (44, 2, 1, 2), (44, 3, 1, 3), (44, 4, 1, 4), (44, 5, 1, 5), (45, 1, 1, 1), (45, 2, 1, 2), (45, 3, 1, 3), (45, 4, 1, 4), (45, 5, 1, 5), (46, 1, 1, 1), (46, 2, 1, 2), (46, 3, 1, 3), (46, 4, 1, 4), (46, 5, 1, 5), (47, 1, 1, 1), (47, 2, 1, 2), (47, 3, 1, 3), (47, 4, 1, 4), (47, 5, 1, 5), (48, 1, 1, 1), (48, 2, 1, 2), (48, 3, 1, 3), (48, 4, 1, 4), (48, 5, 1, 5), (49, 1, 1, 1), (49, 2, 1, 2), (49, 3, 1, 3), (49, 4, 1, 4), (49, 5, 1, 5), (50, 1, 1, 1), (50, 2, 1, 2), (50, 3, 1, 3), (50, 4, 1, 4), (50, 5, 1, 5), (51, 1, 1, 1), (51, 2, 1, 2), (51, 3, 1, 3), (51, 4, 1, 4), (51, 5, 1, 5), (52, 1, 1, 1), (52, 2, 1, 2), (52, 3, 1, 3), (52, 4, 1, 4), (52, 5, 1, 5), (53, 1, 1, 1), (53, 2, 1, 2), (53, 3, 1, 3), (53, 4, 1, 4), (53, 5, 1, 5), (54, 1, 1, 1), (54, 2, 1, 2), (54, 3, 1, 3), (54, 4, 1, 4), (54, 5, 1, 5), (55, 1, 1, 1), (55, 2, 1, 2), (55, 3, 1, 3), (55, 4, 1, 4), (55, 5, 1, 5), (56, 1, 1, 1), (56, 2, 1, 2), (56, 3, 1, 3), (56, 4, 1, 4), (56, 5, 1, 5), (57, 1, 1, 1), (57, 2, 1, 2), (57, 3, 1, 3), (57, 4, 1, 4), (57, 5, 1, 5), (58, 1, 1, 1), (58, 2, 1, 2), (58, 3, 1, 3), (58, 4, 1, 4), (58, 5, 1, 5)

--E2
insert into rrhh_preopc_preguntas_opciones (preopc_codpre, preopc_codopc, preopc_codtipo, preopc_opc_orden) values
(59, 6, 1, 1), (59, 7, 1, 2), (59, 8, 1, 3), (59, 9, 1, 4), (59, 10, 1, 5), (60, 6, 1, 1), (60, 7, 1, 2), (60, 8, 1, 3), (60, 9, 1, 4), (60, 10, 1, 5), (61, 6, 1, 1), (61, 7, 1, 2), (61, 8, 1, 3), (61, 9, 1, 4), (61, 10, 1, 5), (62, 6, 1, 1), (62, 7, 1, 2), (62, 8, 1, 3), (62, 9, 1, 4), (62, 10, 1, 5), (63, 6, 1, 1), (63, 7, 1, 2), (63, 8, 1, 3), (63, 9, 1, 4), (63, 10, 1, 5), (64, 6, 1, 1), (64, 7, 1, 2), (64, 8, 1, 3), (64, 9, 1, 4), (64, 10, 1, 5), (65, 6, 1, 1), (65, 7, 1, 2), (65, 8, 1, 3), (65, 9, 1, 4), (65, 10, 1, 5), (66, 6, 1, 1), (66, 7, 1, 2), (66, 8, 1, 3), (66, 9, 1, 4), (66, 10, 1, 5), (67, 6, 1, 1), (67, 7, 1, 2), (67, 8, 1, 3), (67, 9, 1, 4), (67, 10, 1, 5), (68, 6, 1, 1), (68, 7, 1, 2), (68, 8, 1, 3), (68, 9, 1, 4), (68, 10, 1, 5), (69, 6, 1, 1), (69, 7, 1, 2), (69, 8, 1, 3), (69, 9, 1, 4), (69, 10, 1, 5), (70, 6, 1, 1), (70, 7, 1, 2), (70, 8, 1, 3), (70, 9, 1, 4), (70, 10, 1, 5), (71, 6, 1, 1), (71, 7, 1, 2), (71, 8, 1, 3), (71, 9, 1, 4), (71, 10, 1, 5), (72, 6, 1, 1), (72, 7, 1, 2), (72, 8, 1, 3), (72, 9, 1, 4), (72, 10, 1, 5), (73, 6, 1, 1), (73, 7, 1, 2), (73, 8, 1, 3), (73, 9, 1, 4), (73, 10, 1, 5), (74, 6, 1, 1), (74, 7, 1, 2), (74, 8, 1, 3), (74, 9, 1, 4), (74, 10, 1, 5), (75, 6, 1, 1), (75, 7, 1, 2), (75, 8, 1, 3), (75, 9, 1, 4), (75, 10, 1, 5), (76, 6, 1, 1), (76, 7, 1, 2), (76, 8, 1, 3), (76, 9, 1, 4), (76, 10, 1, 5), (77, 6, 1, 1), (77, 7, 1, 2), (77, 8, 1, 3), (77, 9, 1, 4), (77, 10, 1, 5), (78, 6, 1, 1), (78, 7, 1, 2), (78, 8, 1, 3), (78, 9, 1, 4), (78, 10, 1, 5), (79, 6, 1, 1), (79, 7, 1, 2), (79, 8, 1, 3), (79, 9, 1, 4), (79, 10, 1, 5), (80, 6, 1, 1), (80, 7, 1, 2), (80, 8, 1, 3), (80, 9, 1, 4), (80, 10, 1, 5), (81, 6, 1, 1), (81, 7, 1, 2), (81, 8, 1, 3), (81, 9, 1, 4), (81, 10, 1, 5), (82, 6, 1, 1), (82, 7, 1, 2), (82, 8, 1, 3), (82, 9, 1, 4), (82, 10, 1, 5), (83, 6, 1, 1), (83, 7, 1, 2), (83, 8, 1, 3), (83, 9, 1, 4), (83, 10, 1, 5), (84, 6, 1, 1), (84, 7, 1, 2), (84, 8, 1, 3), (84, 9, 1, 4), (84, 10, 1, 5), (85, 6, 1, 1), (85, 7, 1, 2), (85, 8, 1, 3), (85, 9, 1, 4), (85, 10, 1, 5), (86, 6, 1, 1), (86, 7, 1, 2), (86, 8, 1, 3), (86, 9, 1, 4), (86, 10, 1, 5), (87, 6, 1, 1), (87, 7, 1, 2), (87, 8, 1, 3), (87, 9, 1, 4), (87, 10, 1, 5), (88, 6, 1, 1), (88, 7, 1, 2), (88, 8, 1, 3), (88, 9, 1, 4), (88, 10, 1, 5), (89, 6, 1, 1), (89, 7, 1, 2), (89, 8, 1, 3), (89, 9, 1, 4), (89, 10, 1, 5), (90, 6, 1, 1), (90, 7, 1, 2), (90, 8, 1, 3), (90, 9, 1, 4), (90, 10, 1, 5), (91, 6, 1, 1), (91, 7, 1, 2), (91, 8, 1, 3), (91, 9, 1, 4), (91, 10, 1, 5), (92, 6, 1, 1), (92, 7, 1, 2), (92, 8, 1, 3), (92, 9, 1, 4), (92, 10, 1, 5), (93, 6, 1, 1), (93, 7, 1, 2), (93, 8, 1, 3), (93, 9, 1, 4), (93, 10, 1, 5), (94, 6, 1, 1), (94, 7, 1, 2), (94, 8, 1, 3), (94, 9, 1, 4), (94, 10, 1, 5), (95, 6, 1, 1), (95, 7, 1, 2), (95, 8, 1, 3), (95, 9, 1, 4), (95, 10, 1, 5), (96, 6, 1, 1), (96, 7, 1, 2), (96, 8, 1, 3), (96, 9, 1, 4), (96, 10, 1, 5), (97, 6, 1, 1), (97, 7, 1, 2), (97, 8, 1, 3), (97, 9, 1, 4), (97, 10, 1, 5), (98, 6, 1, 1), (98, 7, 1, 2), (98, 8, 1, 3), (98, 9, 1, 4), (98, 10, 1, 5), (99, 6, 1, 1), (99, 7, 1, 2), (99, 8, 1, 3), (99, 9, 1, 4), (99, 10, 1, 5), (100, 6, 1, 1), (100, 7, 1, 2), (100, 8, 1, 3), (100, 9, 1, 4), (100, 10, 1, 5), (101, 6, 1, 1), (101, 7, 1, 2), (101, 8, 1, 3), (101, 9, 1, 4), (101, 10, 1, 5), (102, 6, 1, 1), (102, 7, 1, 2), (102, 8, 1, 3), (102, 9, 1, 4), (102, 10, 1, 5), (103, 6, 1, 1), (103, 7, 1, 2), (103, 8, 1, 3), (103, 9, 1, 4), (103, 10, 1, 5), (104, 6, 1, 1), (104, 7, 1, 2), (104, 8, 1, 3), (104, 9, 1, 4), (104, 10, 1, 5), (105, 6, 1, 1), (105, 7, 1, 2), (105, 8, 1, 3), (105, 9, 1, 4), (105, 10, 1, 5), (106, 6, 1, 1), (106, 7, 1, 2), (106, 8, 1, 3), (106, 9, 1, 4), (106, 10, 1, 5), (107, 6, 1, 1), (107, 7, 1, 2), (107, 8, 1, 3), (107, 9, 1, 4), (107, 10, 1, 5), (108, 6, 1, 1), (108, 7, 1, 2), (108, 8, 1, 3), (108, 9, 1, 4), (108, 10, 1, 5), (109, 6, 1, 1), (109, 7, 1, 2), (109, 8, 1, 3), (109, 9, 1, 4), (109, 10, 1, 5), (110, 6, 1, 1), (110, 7, 1, 2), (110, 8, 1, 3), (110, 9, 1, 4), (110, 10, 1, 5), (111, 6, 1, 1), (111, 7, 1, 2), (111, 8, 1, 3), (111, 9, 1, 4), (111, 10, 1, 5), (112, 6, 1, 1), (112, 7, 1, 2), (112, 8, 1, 3), (112, 9, 1, 4), (112, 10, 1, 5), (113, 6, 1, 1), (113, 7, 1, 2), (113, 8, 1, 3), (113, 9, 1, 4), (113, 10, 1, 5), (114, 6, 1, 1), (114, 7, 1, 2), (114, 8, 1, 3), (114, 9, 1, 4), (114, 10, 1, 5), (115, 6, 1, 1), (115, 7, 1, 2), (115, 8, 1, 3), (115, 9, 1, 4), (115, 10, 1, 5), (116, 6, 1, 1), (116, 7, 1, 2), (116, 8, 1, 3), (116, 9, 1, 4), (116, 10, 1, 5), (117, 6, 1, 1), (117, 7, 1, 2), (117, 8, 1, 3), (117, 9, 1, 4), (117, 10, 1, 5), (118, 6, 1, 1), (118, 7, 1, 2), (118, 8, 1, 3), (118, 9, 1, 4), (118, 10, 1, 5), (119, 6, 1, 1), (119, 7, 1, 2), (119, 8, 1, 3), (119, 9, 1, 4), (119, 10, 1, 5), (120, 6, 1, 1), (120, 7, 1, 2), (120, 8, 1, 3), (120, 9, 1, 4), (120, 10, 1, 5), (121, 6, 1, 1), (121, 7, 1, 2), (121, 8, 1, 3), (121, 9, 1, 4), (121, 10, 1, 5), (122, 6, 1, 1), (122, 7, 1, 2), (122, 8, 1, 3), (122, 9, 1, 4), (122, 10, 1, 5), (123, 6, 1, 1), (123, 7, 1, 2), (123, 8, 1, 3), (123, 9, 1, 4), (123, 10, 1, 5), (124, 6, 1, 1), (124, 7, 1, 2), (124, 8, 1, 3), (124, 9, 1, 4), (124, 10, 1, 5), (125, 6, 1, 1), (125, 7, 1, 2), (125, 8, 1, 3), (125, 9, 1, 4), (125, 10, 1, 5), (126, 6, 1, 1), (126, 7, 1, 2), (126, 8, 1, 3), (126, 9, 1, 4), (126, 10, 1, 5), (127, 6, 1, 1), (127, 7, 1, 2), (127, 8, 1, 3), (127, 9, 1, 4), (127, 10, 1, 5), (128, 6, 1, 1), (128, 7, 1, 2), (128, 8, 1, 3), (128, 9, 1, 4), (128, 10, 1, 5), (129, 6, 1, 1), (129, 7, 1, 2), (129, 8, 1, 3), (129, 9, 1, 4), (129, 10, 1, 5), (130, 6, 1, 1), (130, 7, 1, 2), (130, 8, 1, 3), (130, 9, 1, 4), (130, 10, 1, 5), (131, 6, 1, 1), (131, 7, 1, 2), (131, 8, 1, 3), (131, 9, 1, 4), (131, 10, 1, 5), (132, 6, 1, 1), (132, 7, 1, 2), (132, 8, 1, 3), (132, 9, 1, 4), (132, 10, 1, 5), (133, 6, 1, 1), (133, 7, 1, 2), (133, 8, 1, 3), (133, 9, 1, 4), (133, 10, 1, 5)

--E3
insert into rrhh_preopc_preguntas_opciones (preopc_codpre, preopc_codopc, preopc_codtipo, preopc_opc_orden) values
(134, 11, 1, 1), (134, 12, 1, 2), (134, 13, 1, 3), (134, 14, 1, 4), (134, 15, 1, 5), (135, 11, 1, 1), (135, 12, 1, 2), (135, 13, 1, 3), (135, 14, 1, 4), (135, 15, 1, 5), (136, 11, 1, 1), (136, 12, 1, 2), (136, 13, 1, 3), (136, 14, 1, 4), (136, 15, 1, 5), (137, 11, 1, 1), (137, 12, 1, 2), (137, 13, 1, 3), (137, 14, 1, 4), (137, 15, 1, 5), (138, 11, 1, 1), (138, 12, 1, 2), (138, 13, 1, 3), (138, 14, 1, 4), (138, 15, 1, 5), (139, 11, 1, 1), (139, 12, 1, 2), (139, 13, 1, 3), (139, 14, 1, 4), (139, 15, 1, 5), (140, 11, 1, 1), (140, 12, 1, 2), (140, 13, 1, 3), (140, 14, 1, 4), (140, 15, 1, 5), (141, 11, 1, 1), (141, 12, 1, 2), (141, 13, 1, 3), (141, 14, 1, 4), (141, 15, 1, 5), (142, 11, 1, 1), (142, 12, 1, 2), (142, 13, 1, 3), (142, 14, 1, 4), (142, 15, 1, 5), (143, 11, 1, 1), (143, 12, 1, 2), (143, 13, 1, 3), (143, 14, 1, 4), (143, 15, 1, 5), (144, 11, 1, 1), (144, 12, 1, 2), (144, 13, 1, 3), (144, 14, 1, 4), (144, 15, 1, 5), (145, 11, 1, 1), (145, 12, 1, 2), (145, 13, 1, 3), (145, 14, 1, 4), (145, 15, 1, 5), (146, 11, 1, 1), (146, 12, 1, 2), (146, 13, 1, 3), (146, 14, 1, 4), (146, 15, 1, 5), (147, 11, 1, 1), (147, 12, 1, 2), (147, 13, 1, 3), (147, 14, 1, 4), (147, 15, 1, 5), (148, 11, 1, 1), (148, 12, 1, 2), (148, 13, 1, 3), (148, 14, 1, 4), (148, 15, 1, 5), (149, 11, 1, 1), (149, 12, 1, 2), (149, 13, 1, 3), (149, 14, 1, 4), (149, 15, 1, 5), (150, 11, 1, 1), (150, 12, 1, 2), (150, 13, 1, 3), (150, 14, 1, 4), (150, 15, 1, 5), (151, 11, 1, 1), (151, 12, 1, 2), (151, 13, 1, 3), (151, 14, 1, 4), (151, 15, 1, 5), (152, 11, 1, 1), (152, 12, 1, 2), (152, 13, 1, 3), (152, 14, 1, 4), (152, 15, 1, 5), (153, 11, 1, 1), (153, 12, 1, 2), (153, 13, 1, 3), (153, 14, 1, 4), (153, 15, 1, 5), (154, 11, 1, 1), (154, 12, 1, 2), (154, 13, 1, 3), (154, 14, 1, 4), (154, 15, 1, 5), (155, 11, 1, 1), (155, 12, 1, 2), (155, 13, 1, 3), (155, 14, 1, 4), (155, 15, 1, 5), (156, 11, 1, 1), (156, 12, 1, 2), (156, 13, 1, 3), (156, 14, 1, 4), (156, 15, 1, 5), (157, 11, 1, 1), (157, 12, 1, 2), (157, 13, 1, 3), (157, 14, 1, 4), (157, 15, 1, 5), (158, 11, 1, 1), (158, 12, 1, 2), (158, 13, 1, 3), (158, 14, 1, 4), (158, 15, 1, 5), (159, 11, 1, 1), (159, 12, 1, 2), (159, 13, 1, 3), (159, 14, 1, 4), (159, 15, 1, 5), (160, 11, 1, 1), (160, 12, 1, 2), (160, 13, 1, 3), (160, 14, 1, 4), (160, 15, 1, 5), (161, 11, 1, 1), (161, 12, 1, 2), (161, 13, 1, 3), (161, 14, 1, 4), (161, 15, 1, 5), (162, 11, 1, 1), (162, 12, 1, 2), (162, 13, 1, 3), (162, 14, 1, 4), (162, 15, 1, 5), (163, 11, 1, 1), (163, 12, 1, 2), (163, 13, 1, 3), (163, 14, 1, 4), (163, 15, 1, 5), (164, 11, 1, 1), (164, 12, 1, 2), (164, 13, 1, 3), (164, 14, 1, 4), (164, 15, 1, 5), (165, 11, 1, 1), (165, 12, 1, 2), (165, 13, 1, 3), (165, 14, 1, 4), (165, 15, 1, 5), (166, 11, 1, 1), (166, 12, 1, 2), (166, 13, 1, 3), (166, 14, 1, 4), (166, 15, 1, 5), (167, 11, 1, 1), (167, 12, 1, 2), (167, 13, 1, 3), (167, 14, 1, 4), (167, 15, 1, 5), (168, 11, 1, 1), (168, 12, 1, 2), (168, 13, 1, 3), (168, 14, 1, 4), (168, 15, 1, 5), (169, 11, 1, 1), (169, 12, 1, 2), (169, 13, 1, 3), (169, 14, 1, 4), (169, 15, 1, 5), (170, 11, 1, 1), (170, 12, 1, 2), (170, 13, 1, 3), (170, 14, 1, 4), (170, 15, 1, 5), (171, 11, 1, 1), (171, 12, 1, 2), (171, 13, 1, 3), (171, 14, 1, 4), (171, 15, 1, 5), (172, 11, 1, 1), (172, 12, 1, 2), (172, 13, 1, 3), (172, 14, 1, 4), (172, 15, 1, 5), (173, 11, 1, 1), (173, 12, 1, 2), (173, 13, 1, 3), (173, 14, 1, 4), (173, 15, 1, 5), (174, 11, 1, 1), (174, 12, 1, 2), (174, 13, 1, 3), (174, 14, 1, 4), (174, 15, 1, 5), (175, 11, 1, 1), (175, 12, 1, 2), (175, 13, 1, 3), (175, 14, 1, 4), (175, 15, 1, 5), (176, 11, 1, 1), (176, 12, 1, 2), (176, 13, 1, 3), (176, 14, 1, 4), (176, 15, 1, 5), (177, 11, 1, 1), (177, 12, 1, 2), (177, 13, 1, 3), (177, 14, 1, 4), (177, 15, 1, 5), (178, 11, 1, 1), (178, 12, 1, 2), (178, 13, 1, 3), (178, 14, 1, 4), (178, 15, 1, 5), (179, 11, 1, 1), (179, 12, 1, 2), (179, 13, 1, 3), (179, 14, 1, 4), (179, 15, 1, 5), (180, 11, 1, 1), (180, 12, 1, 2), (180, 13, 1, 3), (180, 14, 1, 4), (180, 15, 1, 5), (181, 11, 1, 1), (181, 12, 1, 2), (181, 13, 1, 3), (181, 14, 1, 4), (181, 15, 1, 5), (182, 11, 1, 1), (182, 12, 1, 2), (182, 13, 1, 3), (182, 14, 1, 4), (182, 15, 1, 5), (183, 11, 1, 1), (183, 12, 1, 2), (183, 13, 1, 3), (183, 14, 1, 4), (183, 15, 1, 5), (184, 11, 1, 1), (184, 12, 1, 2), (184, 13, 1, 3), (184, 14, 1, 4), (184, 15, 1, 5), (185, 11, 1, 1), (185, 12, 1, 2), (185, 13, 1, 3), (185, 14, 1, 4), (185, 15, 1, 5), (186, 11, 1, 1), (186, 12, 1, 2), (186, 13, 1, 3), (186, 14, 1, 4), (186, 15, 1, 5), (187, 11, 1, 1), (187, 12, 1, 2), (187, 13, 1, 3), (187, 14, 1, 4), (187, 15, 1, 5), (188, 11, 1, 1), (188, 12, 1, 2), (188, 13, 1, 3), (188, 14, 1, 4), (188, 15, 1, 5), (189, 11, 1, 1), (189, 12, 1, 2), (189, 13, 1, 3), (189, 14, 1, 4), (189, 15, 1, 5), (190, 11, 1, 1), (190, 12, 1, 2), (190, 13, 1, 3), (190, 14, 1, 4), (190, 15, 1, 5), (191, 11, 1, 1), (191, 12, 1, 2), (191, 13, 1, 3), (191, 14, 1, 4), (191, 15, 1, 5), (192, 11, 1, 1), (192, 12, 1, 2), (192, 13, 1, 3), (192, 14, 1, 4), (192, 15, 1, 5), (193, 11, 1, 1), (193, 12, 1, 2), (193, 13, 1, 3), (193, 14, 1, 4), (193, 15, 1, 5), (194, 11, 1, 1), (194, 12, 1, 2), (194, 13, 1, 3), (194, 14, 1, 4), (194, 15, 1, 5), (195, 11, 1, 1), (195, 12, 1, 2), (195, 13, 1, 3), (195, 14, 1, 4), (195, 15, 1, 5), (196, 11, 1, 1), (196, 12, 1, 2), (196, 13, 1, 3), (196, 14, 1, 4), (196, 15, 1, 5), (197, 11, 1, 1), (197, 12, 1, 2), (197, 13, 1, 3), (197, 14, 1, 4), (197, 15, 1, 5), (198, 11, 1, 1), (198, 12, 1, 2), (198, 13, 1, 3), (198, 14, 1, 4), (198, 15, 1, 5), (199, 11, 1, 1), (199, 12, 1, 2), (199, 13, 1, 3), (199, 14, 1, 4), (199, 15, 1, 5), (200, 11, 1, 1), (200, 12, 1, 2), (200, 13, 1, 3), (200, 14, 1, 4), (200, 15, 1, 5), (201, 11, 1, 1), (201, 12, 1, 2), (201, 13, 1, 3), (201, 14, 1, 4), (201, 15, 1, 5), (202, 11, 1, 1), (202, 12, 1, 2), (202, 13, 1, 3), (202, 14, 1, 4), (202, 15, 1, 5), (203, 11, 1, 1), (203, 12, 1, 2), (203, 13, 1, 3), (203, 14, 1, 4), (203, 15, 1, 5)

--E4
insert into rrhh_preopc_preguntas_opciones (preopc_codpre, preopc_codopc, preopc_codtipo, preopc_opc_orden) values
(204, 16, 1, 1),(204, 17, 1, 2),(204, 18, 1, 3),(204, 19, 1, 4),(204, 20, 1, 5),(205, 16, 1, 1),(205, 17, 1, 2),(205, 18, 1, 3),(205, 19, 1, 4),(205, 20, 1, 5),(206, 16, 1, 1),(206, 17, 1, 2),(206, 18, 1, 3),(206, 19, 1, 4),(206, 20, 1, 5),(207, 16, 1, 1),(207, 17, 1, 2),(207, 18, 1, 3),(207, 19, 1, 4),(207, 20, 1, 5),(208, 16, 1, 1),(208, 17, 1, 2),(208, 18, 1, 3),(208, 19, 1, 4),(208, 20, 1, 5),(209, 16, 1, 1),(209, 17, 1, 2),(209, 18, 1, 3),(209, 19, 1, 4),(209, 20, 1, 5),(210, 16, 1, 1),(210, 17, 1, 2),(210, 18, 1, 3),(210, 19, 1, 4),(210, 20, 1, 5),(211, 16, 1, 1),(211, 17, 1, 2),(211, 18, 1, 3),(211, 19, 1, 4),(211, 20, 1, 5),(212, 16, 1, 1),(212, 17, 1, 2),(212, 18, 1, 3),(212, 19, 1, 4),(212, 20, 1, 5),(213, 16, 1, 1),(213, 17, 1, 2),(213, 18, 1, 3),(213, 19, 1, 4),(213, 20, 1, 5),(214, 16, 1, 1),(214, 17, 1, 2),(214, 18, 1, 3),(214, 19, 1, 4),(214, 20, 1, 5),(215, 16, 1, 1),(215, 17, 1, 2),(215, 18, 1, 3),(215, 19, 1, 4),(215, 20, 1, 5),(216, 16, 1, 1),(216, 17, 1, 2),(216, 18, 1, 3),(216, 19, 1, 4),(216, 20, 1, 5),(217, 16, 1, 1),(217, 17, 1, 2),(217, 18, 1, 3),(217, 19, 1, 4),(217, 20, 1, 5),(218, 16, 1, 1),(218, 17, 1, 2),(218, 18, 1, 3),(218, 19, 1, 4),(218, 20, 1, 5),(219, 16, 1, 1),(219, 17, 1, 2),(219, 18, 1, 3),(219, 19, 1, 4),(219, 20, 1, 5),(220, 16, 1, 1),(220, 17, 1, 2),(220, 18, 1, 3),(220, 19, 1, 4),(220, 20, 1, 5),(221, 16, 1, 1),(221, 17, 1, 2),(221, 18, 1, 3),(221, 19, 1, 4),(221, 20, 1, 5),(222, 16, 1, 1),(222, 17, 1, 2),(222, 18, 1, 3),(222, 19, 1, 4),(222, 20, 1, 5),(223, 16, 1, 1),(223, 17, 1, 2),(223, 18, 1, 3),(223, 19, 1, 4),(223, 20, 1, 5),(224, 16, 1, 1),(224, 17, 1, 2),(224, 18, 1, 3),(224, 19, 1, 4),(224, 20, 1, 5),(225, 16, 1, 1),(225, 17, 1, 2),(225, 18, 1, 3),(225, 19, 1, 4),(225, 20, 1, 5),(226, 16, 1, 1),(226, 17, 1, 2),(226, 18, 1, 3),(226, 19, 1, 4),(226, 20, 1, 5),(227, 16, 1, 1),(227, 17, 1, 2),(227, 18, 1, 3),(227, 19, 1, 4),(227, 20, 1, 5),(228, 16, 1, 1),(228, 17, 1, 2),(228, 18, 1, 3),(228, 19, 1, 4),(228, 20, 1, 5),(229, 16, 1, 1),(229, 17, 1, 2),(229, 18, 1, 3),(229, 19, 1, 4),(229, 20, 1, 5),(230, 16, 1, 1),(230, 17, 1, 2),(230, 18, 1, 3),(230, 19, 1, 4),(230, 20, 1, 5),(231, 16, 1, 1),(231, 17, 1, 2),(231, 18, 1, 3),(231, 19, 1, 4),(231, 20, 1, 5),(232, 16, 1, 1),(232, 17, 1, 2),(232, 18, 1, 3),(232, 19, 1, 4),(232, 20, 1, 5),(233, 16, 1, 1),(233, 17, 1, 2),(233, 18, 1, 3),(233, 19, 1, 4),(233, 20, 1, 5),(234, 16, 1, 1),(234, 17, 1, 2),(234, 18, 1, 3),(234, 19, 1, 4),(234, 20, 1, 5),(235, 16, 1, 1),(235, 17, 1, 2),(235, 18, 1, 3),(235, 19, 1, 4),(235, 20, 1, 5),(236, 16, 1, 1),(236, 17, 1, 2),(236, 18, 1, 3),(236, 19, 1, 4),(236, 20, 1, 5),(237, 16, 1, 1),(237, 17, 1, 2),(237, 18, 1, 3),(237, 19, 1, 4),(237, 20, 1, 5),(238, 16, 1, 1),(238, 17, 1, 2),(238, 18, 1, 3),(238, 19, 1, 4),(238, 20, 1, 5),(239, 16, 1, 1),(239, 17, 1, 2),(239, 18, 1, 3),(239, 19, 1, 4),(239, 20, 1, 5),(240, 16, 1, 1),(240, 17, 1, 2),(240, 18, 1, 3),(240, 19, 1, 4),(240, 20, 1, 5),(241, 16, 1, 1),(241, 17, 1, 2),(241, 18, 1, 3),(241, 19, 1, 4),(241, 20, 1, 5),(242, 16, 1, 1),(242, 17, 1, 2),(242, 18, 1, 3),(242, 19, 1, 4),(242, 20, 1, 5),(243, 16, 1, 1),(243, 17, 1, 2),(243, 18, 1, 3),(243, 19, 1, 4),(243, 20, 1, 5),(244, 16, 1, 1),(244, 17, 1, 2),(244, 18, 1, 3),(244, 19, 1, 4),(244, 20, 1, 5),(245, 16, 1, 1),(245, 17, 1, 2),(245, 18, 1, 3),(245, 19, 1, 4),(245, 20, 1, 5),(246, 16, 1, 1),(246, 17, 1, 2),(246, 18, 1, 3),(246, 19, 1, 4),(246, 20, 1, 5),(247, 16, 1, 1),(247, 17, 1, 2),(247, 18, 1, 3),(247, 19, 1, 4),(247, 20, 1, 5),(248, 16, 1, 1),(248, 17, 1, 2),(248, 18, 1, 3),(248, 19, 1, 4),(248, 20, 1, 5),(249, 16, 1, 1),(249, 17, 1, 2),(249, 18, 1, 3),(249, 19, 1, 4),(249, 20, 1, 5),(250, 16, 1, 1),(250, 17, 1, 2),(250, 18, 1, 3),(250, 19, 1, 4),(250, 20, 1, 5),(251, 16, 1, 1),(251, 17, 1, 2),(251, 18, 1, 3),(251, 19, 1, 4),(251, 20, 1, 5),(252, 16, 1, 1),(252, 17, 1, 2),(252, 18, 1, 3),(252, 19, 1, 4),(252, 20, 1, 5),(253, 16, 1, 1),(253, 17, 1, 2),(253, 18, 1, 3),(253, 19, 1, 4),(253, 20, 1, 5),(254, 16, 1, 1),(254, 17, 1, 2),(254, 18, 1, 3),(254, 19, 1, 4),(254, 20, 1, 5),(255, 16, 1, 1),(255, 17, 1, 2),(255, 18, 1, 3),(255, 19, 1, 4),(255, 20, 1, 5),(256, 16, 1, 1),(256, 17, 1, 2),(256, 18, 1, 3),(256, 19, 1, 4),(256, 20, 1, 5),(257, 16, 1, 1),(257, 17, 1, 2),(257, 18, 1, 3),(257, 19, 1, 4),(257, 20, 1, 5),(258, 16, 1, 1),(258, 17, 1, 2),(258, 18, 1, 3),(258, 19, 1, 4),(258, 20, 1, 5)

--E5
insert into rrhh_preopc_preguntas_opciones (preopc_codpre, preopc_codopc, preopc_codtipo, preopc_opc_orden) values
(259, 21, 1, 1), (259, 22, 1, 2), (259, 23, 1, 3), (259, 24, 1, 4), (259, 25, 1, 5), (260, 21, 1, 1), (260, 22, 1, 2), (260, 23, 1, 3), (260, 24, 1, 4), (260, 25, 1, 5), (261, 21, 1, 1), (261, 22, 1, 2), (261, 23, 1, 3), (261, 24, 1, 4), (261, 25, 1, 5), (262, 21, 1, 1), (262, 22, 1, 2), (262, 23, 1, 3), (262, 24, 1, 4), (262, 25, 1, 5), (263, 21, 1, 1), (263, 22, 1, 2), (263, 23, 1, 3), (263, 24, 1, 4), (263, 25, 1, 5), (264, 21, 1, 1), (264, 22, 1, 2), (264, 23, 1, 3), (264, 24, 1, 4), (264, 25, 1, 5), (265, 21, 1, 1), (265, 22, 1, 2), (265, 23, 1, 3), (265, 24, 1, 4), (265, 25, 1, 5), (266, 21, 1, 1), (266, 22, 1, 2), (266, 23, 1, 3), (266, 24, 1, 4), (266, 25, 1, 5), (267, 21, 1, 1), (267, 22, 1, 2), (267, 23, 1, 3), (267, 24, 1, 4), (267, 25, 1, 5), (268, 21, 1, 1), (268, 22, 1, 2), (268, 23, 1, 3), (268, 24, 1, 4), (268, 25, 1, 5), (269, 21, 1, 1), (269, 22, 1, 2), (269, 23, 1, 3), (269, 24, 1, 4), (269, 25, 1, 5), (270, 21, 1, 1), (270, 22, 1, 2), (270, 23, 1, 3), (270, 24, 1, 4), (270, 25, 1, 5), (271, 21, 1, 1), (271, 22, 1, 2), (271, 23, 1, 3), (271, 24, 1, 4), (271, 25, 1, 5), (272, 21, 1, 1), (272, 22, 1, 2), (272, 23, 1, 3), (272, 24, 1, 4), (272, 25, 1, 5), (273, 21, 1, 1), (273, 22, 1, 2), (273, 23, 1, 3), (273, 24, 1, 4), (273, 25, 1, 5), (274, 21, 1, 1), (274, 22, 1, 2), (274, 23, 1, 3), (274, 24, 1, 4), (274, 25, 1, 5), (275, 21, 1, 1), (275, 22, 1, 2), (275, 23, 1, 3), (275, 24, 1, 4), (275, 25, 1, 5), (276, 21, 1, 1), (276, 22, 1, 2), (276, 23, 1, 3), (276, 24, 1, 4), (276, 25, 1, 5), (277, 21, 1, 1), (277, 22, 1, 2), (277, 23, 1, 3), (277, 24, 1, 4), (277, 25, 1, 5), (278, 21, 1, 1), (278, 22, 1, 2), (278, 23, 1, 3), (278, 24, 1, 4), (278, 25, 1, 5), (279, 21, 1, 1), (279, 22, 1, 2), (279, 23, 1, 3), (279, 24, 1, 4), (279, 25, 1, 5), (280, 21, 1, 1), (280, 22, 1, 2), (280, 23, 1, 3), (280, 24, 1, 4), (280, 25, 1, 5), (281, 21, 1, 1), (281, 22, 1, 2), (281, 23, 1, 3), (281, 24, 1, 4), (281, 25, 1, 5), (282, 21, 1, 1), (282, 22, 1, 2), (282, 23, 1, 3), (282, 24, 1, 4), (282, 25, 1, 5), (283, 21, 1, 1), (283, 22, 1, 2), (283, 23, 1, 3), (283, 24, 1, 4), (283, 25, 1, 5), (284, 21, 1, 1), (284, 22, 1, 2), (284, 23, 1, 3), (284, 24, 1, 4), (284, 25, 1, 5), (285, 21, 1, 1), (285, 22, 1, 2), (285, 23, 1, 3), (285, 24, 1, 4), (285, 25, 1, 5), (286, 21, 1, 1), (286, 22, 1, 2), (286, 23, 1, 3), (286, 24, 1, 4), (286, 25, 1, 5), (287, 21, 1, 1), (287, 22, 1, 2), (287, 23, 1, 3), (287, 24, 1, 4), (287, 25, 1, 5), (288, 21, 1, 1), (288, 22, 1, 2), (288, 23, 1, 3), (288, 24, 1, 4), (288, 25, 1, 5), (289, 21, 1, 1), (289, 22, 1, 2), (289, 23, 1, 3), (289, 24, 1, 4), (289, 25, 1, 5), (290, 21, 1, 1), (290, 22, 1, 2), (290, 23, 1, 3), (290, 24, 1, 4), (290, 25, 1, 5), (291, 21, 1, 1), (291, 22, 1, 2), (291, 23, 1, 3), (291, 24, 1, 4), (291, 25, 1, 5), (292, 21, 1, 1), (292, 22, 1, 2), (292, 23, 1, 3), (292, 24, 1, 4), (292, 25, 1, 5), (293, 21, 1, 1), (293, 22, 1, 2), (293, 23, 1, 3), (293, 24, 1, 4), (293, 25, 1, 5), (294, 21, 1, 1), (294, 22, 1, 2), (294, 23, 1, 3), (294, 24, 1, 4), (294, 25, 1, 5), (295, 21, 1, 1), (295, 22, 1, 2), (295, 23, 1, 3), (295, 24, 1, 4), (295, 25, 1, 5), (296, 21, 1, 1), (296, 22, 1, 2), (296, 23, 1, 3), (296, 24, 1, 4), (296, 25, 1, 5), (297, 21, 1, 1), (297, 22, 1, 2), (297, 23, 1, 3), (297, 24, 1, 4), (297, 25, 1, 5), (298, 21, 1, 1), (298, 22, 1, 2), (298, 23, 1, 3), (298, 24, 1, 4), (298, 25, 1, 5), (299, 21, 1, 1), (299, 22, 1, 2), (299, 23, 1, 3), (299, 24, 1, 4), (299, 25, 1, 5), (300, 21, 1, 1), (300, 22, 1, 2), (300, 23, 1, 3), (300, 24, 1, 4), (300, 25, 1, 5), (301, 21, 1, 1), (301, 22, 1, 2), (301, 23, 1, 3), (301, 24, 1, 4), (301, 25, 1, 5), (302, 21, 1, 1), (302, 22, 1, 2), (302, 23, 1, 3), (302, 24, 1, 4), (302, 25, 1, 5), (303, 21, 1, 1), (303, 22, 1, 2), (303, 23, 1, 3), (303, 24, 1, 4), (303, 25, 1, 5), (304, 21, 1, 1), (304, 22, 1, 2), (304, 23, 1, 3), (304, 24, 1, 4), (304, 25, 1, 5), (305, 21, 1, 1), (305, 22, 1, 2), (305, 23, 1, 3), (305, 24, 1, 4), (305, 25, 1, 5), (306, 21, 1, 1), (306, 22, 1, 2), (306, 23, 1, 3), (306, 24, 1, 4), (306, 25, 1, 5), (307, 21, 1, 1), (307, 22, 1, 2), (307, 23, 1, 3), (307, 24, 1, 4), (307, 25, 1, 5), (308, 21, 1, 1), (308, 22, 1, 2), (308, 23, 1, 3), (308, 24, 1, 4), (308, 25, 1, 5), (309, 21, 1, 1), (309, 22, 1, 2), (309, 23, 1, 3), (309, 24, 1, 4), (309, 25, 1, 5), (310, 21, 1, 1), (310, 22, 1, 2), (310, 23, 1, 3), (310, 24, 1, 4), (310, 25, 1, 5), (311, 21, 1, 1), (311, 22, 1, 2), (311, 23, 1, 3), (311, 24, 1, 4), (311, 25, 1, 5), (312, 21, 1, 1), (312, 22, 1, 2), (312, 23, 1, 3), (312, 24, 1, 4), (312, 25, 1, 5), (313, 21, 1, 1), (313, 22, 1, 2), (313, 23, 1, 3), (313, 24, 1, 4), (313, 25, 1, 5), (314, 21, 1, 1), (314, 22, 1, 2), (314, 23, 1, 3), (314, 24, 1, 4), (314, 25, 1, 5), (315, 21, 1, 1), (315, 22, 1, 2), (315, 23, 1, 3), (315, 24, 1, 4), (315, 25, 1, 5), (316, 21, 1, 1), (316, 22, 1, 2), (316, 23, 1, 3), (316, 24, 1, 4), (316, 25, 1, 5), (317, 21, 1, 1), (317, 22, 1, 2), (317, 23, 1, 3), (317, 24, 1, 4), (317, 25, 1, 5), (318, 21, 1, 1), (318, 22, 1, 2), (318, 23, 1, 3), (318, 24, 1, 4), (318, 25, 1, 5), (319, 21, 1, 1), (319, 22, 1, 2), (319, 23, 1, 3), (319, 24, 1, 4), (319, 25, 1, 5), (320, 21, 1, 1), (320, 22, 1, 2), (320, 23, 1, 3), (320, 24, 1, 4), (320, 25, 1, 5), (321, 21, 1, 1), (321, 22, 1, 2), (321, 23, 1, 3), (321, 24, 1, 4), (321, 25, 1, 5), (322, 21, 1, 1), (322, 22, 1, 2), (322, 23, 1, 3), (322, 24, 1, 4), (322, 25, 1, 5), (323, 21, 1, 1), (323, 22, 1, 2), (323, 23, 1, 3), (323, 24, 1, 4), (323, 25, 1, 5), (324, 21, 1, 1), (324, 22, 1, 2), (324, 23, 1, 3), (324, 24, 1, 4), (324, 25, 1, 5), (325, 21, 1, 1), (325, 22, 1, 2), (325, 23, 1, 3), (325, 24, 1, 4), (325, 25, 1, 5), (326, 21, 1, 1), (326, 22, 1, 2), (326, 23, 1, 3), (326, 24, 1, 4), (326, 25, 1, 5), (327, 21, 1, 1), (327, 22, 1, 2), (327, 23, 1, 3), (327, 24, 1, 4), (327, 25, 1, 5), (328, 21, 1, 1), (328, 22, 1, 2), (328, 23, 1, 3), (328, 24, 1, 4), (328, 25, 1, 5)

--E6
insert into rrhh_preopc_preguntas_opciones (preopc_codpre, preopc_codopc, preopc_codtipo, preopc_opc_orden) values
(329, 26, 1, 1), (329, 27, 1, 2), (329, 28, 1, 3), (329, 29, 1, 4), (329, 30, 1, 5), (330, 26, 1, 1), (330, 27, 1, 2), (330, 28, 1, 3), (330, 29, 1, 4), (330, 30, 1, 5), (331, 26, 1, 1), (331, 27, 1, 2), (331, 28, 1, 3), (331, 29, 1, 4), (331, 30, 1, 5), (332, 26, 1, 1), (332, 27, 1, 2), (332, 28, 1, 3), (332, 29, 1, 4), (332, 30, 1, 5), (333, 26, 1, 1), (333, 27, 1, 2), (333, 28, 1, 3), (333, 29, 1, 4), (333, 30, 1, 5), (334, 26, 1, 1), (334, 27, 1, 2), (334, 28, 1, 3), (334, 29, 1, 4), (334, 30, 1, 5), (335, 26, 1, 1), (335, 27, 1, 2), (335, 28, 1, 3), (335, 29, 1, 4), (335, 30, 1, 5), (336, 26, 1, 1), (336, 27, 1, 2), (336, 28, 1, 3), (336, 29, 1, 4), (336, 30, 1, 5), (337, 26, 1, 1), (337, 27, 1, 2), (337, 28, 1, 3), (337, 29, 1, 4), (337, 30, 1, 5), (338, 26, 1, 1), (338, 27, 1, 2), (338, 28, 1, 3), (338, 29, 1, 4), (338, 30, 1, 5), (339, 26, 1, 1), (339, 27, 1, 2), (339, 28, 1, 3), (339, 29, 1, 4), (339, 30, 1, 5), (340, 26, 1, 1), (340, 27, 1, 2), (340, 28, 1, 3), (340, 29, 1, 4), (340, 30, 1, 5), (341, 26, 1, 1), (341, 27, 1, 2), (341, 28, 1, 3), (341, 29, 1, 4), (341, 30, 1, 5), (342, 26, 1, 1), (342, 27, 1, 2), (342, 28, 1, 3), (342, 29, 1, 4), (342, 30, 1, 5), (343, 26, 1, 1), (343, 27, 1, 2), (343, 28, 1, 3), (343, 29, 1, 4), (343, 30, 1, 5), (344, 26, 1, 1), (344, 27, 1, 2), (344, 28, 1, 3), (344, 29, 1, 4), (344, 30, 1, 5), (345, 26, 1, 1), (345, 27, 1, 2), (345, 28, 1, 3), (345, 29, 1, 4), (345, 30, 1, 5), (346, 26, 1, 1), (346, 27, 1, 2), (346, 28, 1, 3), (346, 29, 1, 4), (346, 30, 1, 5), (347, 26, 1, 1), (347, 27, 1, 2), (347, 28, 1, 3), (347, 29, 1, 4), (347, 30, 1, 5), (348, 26, 1, 1), (348, 27, 1, 2), (348, 28, 1, 3), (348, 29, 1, 4), (348, 30, 1, 5), (349, 26, 1, 1), (349, 27, 1, 2), (349, 28, 1, 3), (349, 29, 1, 4), (349, 30, 1, 5), (350, 26, 1, 1), (350, 27, 1, 2), (350, 28, 1, 3), (350, 29, 1, 4), (350, 30, 1, 5), (351, 26, 1, 1), (351, 27, 1, 2), (351, 28, 1, 3), (351, 29, 1, 4), (351, 30, 1, 5), (352, 26, 1, 1), (352, 27, 1, 2), (352, 28, 1, 3), (352, 29, 1, 4), (352, 30, 1, 5), (353, 26, 1, 1), (353, 27, 1, 2), (353, 28, 1, 3), (353, 29, 1, 4), (353, 30, 1, 5), (354, 26, 1, 1), (354, 27, 1, 2), (354, 28, 1, 3), (354, 29, 1, 4), (354, 30, 1, 5), (355, 26, 1, 1), (355, 27, 1, 2), (355, 28, 1, 3), (355, 29, 1, 4), (355, 30, 1, 5), (356, 26, 1, 1), (356, 27, 1, 2), (356, 28, 1, 3), (356, 29, 1, 4), (356, 30, 1, 5), (357, 26, 1, 1), (357, 27, 1, 2), (357, 28, 1, 3), (357, 29, 1, 4), (357, 30, 1, 5), (358, 26, 1, 1), (358, 27, 1, 2), (358, 28, 1, 3), (358, 29, 1, 4), (358, 30, 1, 5), (359, 26, 1, 1), (359, 27, 1, 2), (359, 28, 1, 3), (359, 29, 1, 4), (359, 30, 1, 5), (360, 26, 1, 1), (360, 27, 1, 2), (360, 28, 1, 3), (360, 29, 1, 4), (360, 30, 1, 5), (361, 26, 1, 1), (361, 27, 1, 2), (361, 28, 1, 3), (361, 29, 1, 4), (361, 30, 1, 5), (362, 26, 1, 1), (362, 27, 1, 2), (362, 28, 1, 3), (362, 29, 1, 4), (362, 30, 1, 5), (363, 26, 1, 1), (363, 27, 1, 2), (363, 28, 1, 3), (363, 29, 1, 4), (363, 30, 1, 5), (364, 26, 1, 1), (364, 27, 1, 2), (364, 28, 1, 3), (364, 29, 1, 4), (364, 30, 1, 5), (365, 26, 1, 1), (365, 27, 1, 2), (365, 28, 1, 3), (365, 29, 1, 4), (365, 30, 1, 5), (366, 26, 1, 1), (366, 27, 1, 2), (366, 28, 1, 3), (366, 29, 1, 4), (366, 30, 1, 5), (367, 26, 1, 1), (367, 27, 1, 2), (367, 28, 1, 3), (367, 29, 1, 4), (367, 30, 1, 5), (368, 26, 1, 1), (368, 27, 1, 2), (368, 28, 1, 3), (368, 29, 1, 4), (368, 30, 1, 5), (369, 26, 1, 1), (369, 27, 1, 2), (369, 28, 1, 3), (369, 29, 1, 4), (369, 30, 1, 5), (370, 26, 1, 1), (370, 27, 1, 2), (370, 28, 1, 3), (370, 29, 1, 4), (370, 30, 1, 5), (371, 26, 1, 1), (371, 27, 1, 2), (371, 28, 1, 3), (371, 29, 1, 4), (371, 30, 1, 5), (372, 26, 1, 1), (372, 27, 1, 2), (372, 28, 1, 3), (372, 29, 1, 4), (372, 30, 1, 5), (373, 26, 1, 1), (373, 27, 1, 2), (373, 28, 1, 3), (373, 29, 1, 4), (373, 30, 1, 5), (374, 26, 1, 1), (374, 27, 1, 2), (374, 28, 1, 3), (374, 29, 1, 4), (374, 30, 1, 5), (375, 26, 1, 1), (375, 27, 1, 2), (375, 28, 1, 3), (375, 29, 1, 4), (375, 30, 1, 5), (376, 26, 1, 1), (376, 27, 1, 2), (376, 28, 1, 3), (376, 29, 1, 4), (376, 30, 1, 5), (377, 26, 1, 1), (377, 27, 1, 2), (377, 28, 1, 3), (377, 29, 1, 4), (377, 30, 1, 5), (378, 26, 1, 1), (378, 27, 1, 2), (378, 28, 1, 3), (378, 29, 1, 4), (378, 30, 1, 5), (379, 26, 1, 1), (379, 27, 1, 2), (379, 28, 1, 3), (379, 29, 1, 4), (379, 30, 1, 5), (380, 26, 1, 1), (380, 27, 1, 2), (380, 28, 1, 3), (380, 29, 1, 4), (380, 30, 1, 5), (381, 26, 1, 1), (381, 27, 1, 2), (381, 28, 1, 3), (381, 29, 1, 4), (381, 30, 1, 5), (382, 26, 1, 1), (382, 27, 1, 2), (382, 28, 1, 3), (382, 29, 1, 4), (382, 30, 1, 5), (383, 26, 1, 1), (383, 27, 1, 2), (383, 28, 1, 3), (383, 29, 1, 4), (383, 30, 1, 5), (384, 26, 1, 1), (384, 27, 1, 2), (384, 28, 1, 3), (384, 29, 1, 4), (384, 30, 1, 5), (385, 26, 1, 1), (385, 27, 1, 2), (385, 28, 1, 3), (385, 29, 1, 4), (385, 30, 1, 5), (386, 26, 1, 1), (386, 27, 1, 2), (386, 28, 1, 3), (386, 29, 1, 4), (386, 30, 1, 5), (387, 26, 1, 1), (387, 27, 1, 2), (387, 28, 1, 3), (387, 29, 1, 4), (387, 30, 1, 5), (388, 26, 1, 1), (388, 27, 1, 2), (388, 28, 1, 3), (388, 29, 1, 4), (388, 30, 1, 5)

--E7
insert into rrhh_preopc_preguntas_opciones (preopc_codpre, preopc_codopc, preopc_codtipo, preopc_opc_orden) values
(389, 31, 1, 1), (389, 32, 1, 2), (389, 33, 1, 3), (389, 34, 1, 4), (389, 35, 1, 5), (390, 31, 1, 1), (390, 32, 1, 2), (390, 33, 1, 3), (390, 34, 1, 4), (390, 35, 1, 5), (391, 31, 1, 1), (391, 32, 1, 2), (391, 33, 1, 3), (391, 34, 1, 4), (391, 35, 1, 5), (392, 31, 1, 1), (392, 32, 1, 2), (392, 33, 1, 3), (392, 34, 1, 4), (392, 35, 1, 5), (393, 31, 1, 1), (393, 32, 1, 2), (393, 33, 1, 3), (393, 34, 1, 4), (393, 35, 1, 5), (394, 31, 1, 1), (394, 32, 1, 2), (394, 33, 1, 3), (394, 34, 1, 4), (394, 35, 1, 5), (395, 31, 1, 1), (395, 32, 1, 2), (395, 33, 1, 3), (395, 34, 1, 4), (395, 35, 1, 5), (396, 31, 1, 1), (396, 32, 1, 2), (396, 33, 1, 3), (396, 34, 1, 4), (396, 35, 1, 5), (397, 31, 1, 1), (397, 32, 1, 2), (397, 33, 1, 3), (397, 34, 1, 4), (397, 35, 1, 5), (398, 31, 1, 1), (398, 32, 1, 2), (398, 33, 1, 3), (398, 34, 1, 4), (398, 35, 1, 5), (399, 31, 1, 1), (399, 32, 1, 2), (399, 33, 1, 3), (399, 34, 1, 4), (399, 35, 1, 5), (400, 31, 1, 1), (400, 32, 1, 2), (400, 33, 1, 3), (400, 34, 1, 4), (400, 35, 1, 5), (401, 31, 1, 1), (401, 32, 1, 2), (401, 33, 1, 3), (401, 34, 1, 4), (401, 35, 1, 5), (402, 31, 1, 1), (402, 32, 1, 2), (402, 33, 1, 3), (402, 34, 1, 4), (402, 35, 1, 5), (403, 31, 1, 1), (403, 32, 1, 2), (403, 33, 1, 3), (403, 34, 1, 4), (403, 35, 1, 5), (404, 31, 1, 1), (404, 32, 1, 2), (404, 33, 1, 3), (404, 34, 1, 4), (404, 35, 1, 5), (405, 31, 1, 1), (405, 32, 1, 2), (405, 33, 1, 3), (405, 34, 1, 4), (405, 35, 1, 5), (406, 31, 1, 1), (406, 32, 1, 2), (406, 33, 1, 3), (406, 34, 1, 4), (406, 35, 1, 5), (407, 31, 1, 1), (407, 32, 1, 2), (407, 33, 1, 3), (407, 34, 1, 4), (407, 35, 1, 5), (408, 31, 1, 1), (408, 32, 1, 2), (408, 33, 1, 3), (408, 34, 1, 4), (408, 35, 1, 5), (409, 31, 1, 1), (409, 32, 1, 2), (409, 33, 1, 3), (409, 34, 1, 4), (409, 35, 1, 5), (410, 31, 1, 1), (410, 32, 1, 2), (410, 33, 1, 3), (410, 34, 1, 4), (410, 35, 1, 5), (411, 31, 1, 1), (411, 32, 1, 2), (411, 33, 1, 3), (411, 34, 1, 4), (411, 35, 1, 5), (412, 31, 1, 1), (412, 32, 1, 2), (412, 33, 1, 3), (412, 34, 1, 4), (412, 35, 1, 5), (413, 31, 1, 1), (413, 32, 1, 2), (413, 33, 1, 3), (413, 34, 1, 4), (413, 35, 1, 5), (414, 31, 1, 1), (414, 32, 1, 2), (414, 33, 1, 3), (414, 34, 1, 4), (414, 35, 1, 5), (415, 31, 1, 1), (415, 32, 1, 2), (415, 33, 1, 3), (415, 34, 1, 4), (415, 35, 1, 5), (416, 31, 1, 1), (416, 32, 1, 2), (416, 33, 1, 3), (416, 34, 1, 4), (416, 35, 1, 5), (417, 31, 1, 1), (417, 32, 1, 2), (417, 33, 1, 3), (417, 34, 1, 4), (417, 35, 1, 5), (418, 31, 1, 1), (418, 32, 1, 2), (418, 33, 1, 3), (418, 34, 1, 4), (418, 35, 1, 5), (419, 31, 1, 1), (419, 32, 1, 2), (419, 33, 1, 3), (419, 34, 1, 4), (419, 35, 1, 5), (420, 31, 1, 1), (420, 32, 1, 2), (420, 33, 1, 3), (420, 34, 1, 4), (420, 35, 1, 5), (421, 31, 1, 1), (421, 32, 1, 2), (421, 33, 1, 3), (421, 34, 1, 4), (421, 35, 1, 5), (422, 31, 1, 1), (422, 32, 1, 2), (422, 33, 1, 3), (422, 34, 1, 4), (422, 35, 1, 5), (423, 31, 1, 1), (423, 32, 1, 2), (423, 33, 1, 3), (423, 34, 1, 4), (423, 35, 1, 5), (424, 31, 1, 1), (424, 32, 1, 2), (424, 33, 1, 3), (424, 34, 1, 4), (424, 35, 1, 5), (425, 31, 1, 1), (425, 32, 1, 2), (425, 33, 1, 3), (425, 34, 1, 4), (425, 35, 1, 5), (426, 31, 1, 1), (426, 32, 1, 2), (426, 33, 1, 3), (426, 34, 1, 4), (426, 35, 1, 5), (427, 31, 1, 1), (427, 32, 1, 2), (427, 33, 1, 3), (427, 34, 1, 4), (427, 35, 1, 5), (428, 31, 1, 1), (428, 32, 1, 2), (428, 33, 1, 3), (428, 34, 1, 4), (428, 35, 1, 5)

-- drop table rrhh_encenc_encabezado_encuesta
create table rrhh_encenc_encabezado_encuesta (
	encenc_codigo int primary key identity(1, 1),
	encenc_codenc int foreign key references rrhh_enc_encuestas,
	encenc_codemp int,-- foreign key references uonline.dbo.pla_emp_empleado,
	encenc_codemp_evaluado int,
	--encenc_codhpl int,
	--encenc_codcil int,
	encenc_fecha_creacion datetime default getdate()
)
-- select * from rrhh_encenc_encabezado_encuesta

-- drop table rrhh_detenc_detalle_encuesta
create table rrhh_detenc_detalle_encuesta(
	detenc_codigo int primary key identity(1, 1),
	detenc_codencenc int foreign key references rrhh_encenc_encabezado_encuesta,
	detenc_codpre int foreign key references rrhh_pre_preguntas,
	detenc_codopc int foreign key references rrhh_opc_opciones,
	detenc_detalle varchar(1024),--Si es abierta se llenara
	detenc_fecha_creacion datetime default getdate()
)
-- select * from rrhh_detenc_detalle_encuesta

USE [BD_RRHH]
GO
/****** Object:  StoredProcedure [dbo].[sp_data_rrhh_encuestas]    Script Date: 18/3/2022 15:39:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2022-03-21 10:03:46.7080133-06:00>
	-- Description: <Devuelve la data para las encuestas RRHH>
	-- =============================================
	-- exec dbo.sp_data_rrhh_encuestas @opcion = 1, @codenc = 8
	-- exec dbo.sp_data_rrhh_encuestas @opcion = 2, @codenc = 1
alter procedure [dbo].[sp_data_rrhh_encuestas] 
	@opcion int = 0,
	@codenc int = 0,
	--@codpon int = 0,
	@codemp int = 0

	--, @codhpl int = 0
as
begin
	if @opcion = 1 -- Data de la encuesta @codenc
	begin
		select enc_nombre_encuesta, enc_objetivo,
			grupe_codigo, grupe_orden, grupe_nombre,
			subgru_codigo, subgru_nombre,
			pre_codigo, pre_orden, pre_orden_general, pre_pregunta, tipp_tipo,
			opc_codigo, opc_opcion, opc_opcion_orden preopc_opc_orden, tipo_tipo
		from rrhh_preopc_preguntas_opciones -- 232
			inner join rrhh_pre_preguntas on pre_codigo = preopc_codpre
			inner join rrhh_opc_opciones on opc_codigo = preopc_codopc
			inner join rrhh_subgru_sub_grupo on subgru_codigo = pre_codsubgru
			inner join rrhh_grupe_grupos_estudio on grupe_codenc = @codenc and subgru_codgrupe = grupe_codigo
	
			inner join rrhh_tipp_tipo_preguntas on tipp_codigo = pre_codtipp
			inner join rrhh_tipo_tipo_opciones on tipo_codigo = preopc_codtipo
			inner join rrhh_enc_encuestas on enc_codigo = @codenc
		where @codenc in (opc_codenc, grupe_codenc)
		order by pre_orden_general asc, opc_opcion_orden asc 
	end

	if @opcion = 2 -- Data para el encabezado de la encuesta a que se esta evaluando
	begin
		select * from rrhh_enc_encuestas where enc_codigo = @codenc
	end
end

-- drop type tbl_detenc
create type tbl_detenc as table(codpre int, codopc int, detalle varchar(1024));

USE [BD_RRHH]
GO
/****** Object:  StoredProcedure [dbo].[sp_rrhh_encuestas]    Script Date: 18/3/2022 15:39:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2022-03-21 10:17:36.8246364-06:00>
	-- Description: <Inserta la data para las encuestas RRHH>
	-- =============================================
	-- sp_rrhh_encuestas 1, 1, default
alter procedure [dbo].[sp_rrhh_encuestas] 
	@opcion int = 0,
	@codenc int = 0,
	@codemp int = 0,
	@codemp_evaluado int = 0,
	--@codhpl int = 0,
	--@codcil int = 0,
	--@codpre int = 0,
	--@codopc int = 0,
	--@detalle varchar(1024) = ''
	@tbl_detenc tbl_detenc readonly
as
begin

	if @opcion = 1
	begin
		declare @codencenc int
		insert into rrhh_encenc_encabezado_encuesta (encenc_codenc, encenc_codemp, encenc_codemp_evaluado)
		values (@codenc, @codemp, @codemp_evaluado)
		select @codencenc = scope_identity()
		
		insert into rrhh_detenc_detalle_encuesta (detenc_codencenc, detenc_codpre, detenc_codopc, detenc_detalle)
		select @codencenc, * from @tbl_detenc
		select @codencenc res
	end

end



--SE AGREGO LA COLUMNA HPL_CODIGO EN EL SEGUNDO SELECT
--web_ptl_consultanotas 173322, 122

--Reporte 1:
	--datos solicitados
	--codcil: 
	--codesc:
	--codemp:
		--Codigo y nombre del docente
		--Ciclo, materia, seccion, facultad de la materia, escuela
		--Desgloze de cada uno de los rubros 
		--[preguntas cerradas]Tabla de frecuencias por cada pregunta, (con porcentaje y cantidades)
		--[preguntas multiples]

--Reporte 2(OTRO REPORTE DE SOLO COMENTARIOS):
	--datos solicitados
	--codcil: 
	--codesc:
	--codemp:
		--[respuestas de las preguntas cerradas (comentarios)]


--****************LOS RESULTADOS: EN DESARROLLO****************--, 

USE [BD_RRHH]
GO
/****** Object:  StoredProcedure [dbo].[rep_resultados_evaluacion]    Script Date: 18/3/2022 15:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2022-03-21 10:17:36.8246364-06:00>
	-- Description: <Devuelve los resultados optenidos en las encuestas RRHH>
	-- =============================================
	-- exec dbo.rep_resultados_evaluacion @opcion = 1, @codenc = 1, @codemp = 126
ALTER procedure [dbo].[rep_resultados_evaluacion]
	@opcion int = 0,
	@codenc int = 0,
	@codemp int = 0
as
begin
	if @opcion = 1 --Resultados de las preguntas cerradas
	begin

		select concat('0', cil_codcic, '-', cil_anio) 'ciclo', h.hpl_codigo, hpl_codmat, mat_nombre, hpl_descripcion,
			h.hpl_codemp, emp_nombres_apellidos, esc_nombre, fac_nombre,
			grupe_orden, grupe_nombre, pre_orden_general, pre_pregunta, opc_opcion, count(1) cant,
			(select COUNT(encenc_codper) from rrhh_encenc_encabezado_encuesta em where h.hpl_codigo = em.encenc_codhpl ) tot,--, '%' 'porcentaje'
			(select count(ins_codper) from ra_ins_inscripcion
					inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
					inner join ra_hpl_horarios_planificacion p on p.hpl_codigo = mai_codhpl
					where p.hpl_codigo = h.hpl_codigo and mai_estado = 'I'
			) ins
		from rrhh_encenc_encabezado_encuesta
			inner join ra_hpl_horarios_planificacion h on hpl_codigo = encenc_codhpl
			inner join ra_esc_escuelas on esc_codigo = hpl_codesc
			inner join ra_fac_facultades on fac_codigo = esc_codfac
			inner join ra_mat_materias on mat_codigo = hpl_codmat
			inner join pla_emp_empleado on emp_codigo = hpl_codemp
			inner join ra_cil_ciclo on cil_codigo = hpl_codcil
			inner join rrhh_detenc_detalle_encuesta on detenc_codencenc = encenc_codigo
			inner join rrhh_pre_preguntas on pre_codigo = detenc_codpre
			inner join rrhh_grupe_grupos_estudio on grupe_codigo = pre_codgrupe
			inner join rrhh_opc_opciones on opc_codigo = detenc_codopc
			inner join rrhh_enc_encuestas on enc_codigo = encenc_codenc
		where h.hpl_codesc = @codesc and enc_codcil = @codcil-- and emp_codigo = 4357
				and((case when(h.hpl_codemp > 0 and @codemp > 0) then h.hpl_codemp else 0 end) = (case when @codemp > 0 then @codemp else 0 end))
		group by cil_codcic, cil_anio, h.hpl_codigo, hpl_codmat, mat_nombre, hpl_descripcion, h.hpl_codemp ,emp_nombres_apellidos, esc_nombre, fac_nombre, 			
			grupe_orden, grupe_nombre, pre_orden_general, pre_pregunta, opc_opcion
		order by mat_nombre, pre_orden_general asc

	end

	if @opcion = 2--Resultados de las preguntas abiertas
	begin
		select concat('0', cil_codcic, '-', cil_anio) 'ciclo', hpl_codigo, hpl_codmat, mat_nombre, 
			hpl_descripcion, hpl_codemp ,emp_nombres_apellidos, fac_nombre, esc_nombre, 		
			grupe_orden, grupe_nombre, pre_orden_general, pre_pregunta, opc_opcion, detenc_detalle, count(1) cant
		from rrhh_encenc_encabezado_encuesta
			inner join ra_hpl_horarios_planificacion on hpl_codigo = encenc_codhpl
			inner join ra_esc_escuelas on esc_codigo = hpl_codesc
			inner join ra_fac_facultades on fac_codigo = esc_codfac
			inner join ra_mat_materias on mat_codigo = hpl_codmat
			inner join pla_emp_empleado on emp_codigo = hpl_codemp
			inner join ra_cil_ciclo on cil_codigo = hpl_codcil
			inner join rrhh_detenc_detalle_encuesta on detenc_codencenc = encenc_codigo
			inner join rrhh_pre_preguntas on pre_codigo = detenc_codpre
			inner join rrhh_grupe_grupos_estudio on grupe_codigo = pre_codgrupe
			inner join rrhh_opc_opciones on opc_codigo = detenc_codopc
			inner join rrhh_enc_encuestas on enc_codigo = encenc_codenc
			inner join rrhh_preopc_preguntas_opciones on preopc_codpre = pre_codigo and preopc_codopc = opc_codigo
		where hpl_codesc = @codesc and enc_codcil = @codcil
				and((case when(hpl_codemp > 0 and @codemp > 0) then hpl_codemp else 0 end) = (case when @codemp > 0 then @codemp else 0 end))
				and preopc_codtipo = 2--RESPUESTAS ABIERTAS
		group by cil_codcic, cil_anio, hpl_codigo, hpl_codmat, mat_nombre, 
			hpl_descripcion, hpl_codemp ,emp_nombres_apellidos, fac_nombre, esc_nombre, 
			grupe_orden, grupe_nombre, pre_orden_general, pre_pregunta, opc_opcion, detenc_detalle
		order by mat_nombre, pre_orden_general asc
	end

end


USE [BD_RRHH]
GO
/****** Object:  StoredProcedure [dbo].[web_ceed_crear_evaluacion_estudiantil_docente_emergencia]    Script Date: 18/3/2022 15:40:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-10-08 16:45:38.107>
	-- Description: <Migra la encuesta de "emergencia" de un ciclo a otro>
	-- =============================================
	-- web_ceed_crear_evaluacion_estudiantil_docente_emergencia 1, 1, 122, 123 -- Migra encuesta  de presencial pregrado del ciclo "@codcil_encuesta_origen" al "@codcil_encuesta_destino"
ALTER procedure [dbo].[web_ceed_crear_evaluacion_estudiantil_docente_emergencia]
	@opcion int = 0,
	@codtde int = 0,
	@codcil_encuesta_origen int = 0,
	@codcil_encuesta_destino int = 0
as
begin

	if @opcion = 1
	begin
		
		if not exists (select 1 from rrhh_enc_encuestas where enc_codcil = @codcil_encuesta_destino and enc_codtde = @codtde)--Si el ciclo destino no tiene encuesta para el @codtde
		begin
			--select * from rrhh_enc_encuestas where enc_codcil = @codcil_encuesta_origen and enc_codtde = @codtde
			--select * from rrhh_grupe_grupos_estudio
			--select * from rrhh_pre_preguntas
			--select * from rrhh_opc_opciones
			--select * from rrhh_preopc_preguntas_opciones
			declare @codenc_origen int
			declare @max_codenc int, @max_grupe int, @max_pre int, @max_opc int

			declare @tbl_grupe as table (grupe_nuevo_codigo int, grupe_codigo int, grupe_nombre varchar(255), grupe_nuevo_codenc int, grupe_orden int)
			declare @tbl_pre as table (
				pre_nuevo_codigo int,
				pre_codigo int,
				pre_codtipp int,
				pre_nuevo_codgrupe int,
				pre_codgrupe int,
				pre_orden_general int, -- numero de pregunta en la encuesta
				pre_orden int, -- numero de pregunta en el grupo
				pre_pregunta varchar(1024)
			)
			declare @tbl_opc as table (opc_nuevo_codigo int, opc_codigo int, opc_nueva_codenc int, opc_codenc int, opc_opcion varchar(255))
			declare @tbl_preopc as table (
				preopc_nueva_codpre int,
				preopc_nueva_codopc int,
				preopc_codtipo int,
				preopc_opc_orden int

			)
			select @codenc_origen = enc_codigo from rrhh_enc_encuestas
			where enc_codcil = @codcil_encuesta_origen and enc_codtde = @codtde
			if (isnull(@codenc_origen, 0) <> 0) -- Si el ciclo origen tiene encuesta para el @codtde
			begin
				select @max_codenc = max(enc_codigo) + 1 from rrhh_enc_encuestas
				select @max_grupe = max(grupe_codigo) from rrhh_grupe_grupos_estudio
				select @max_pre = max(pre_codigo) from rrhh_pre_preguntas
				select @max_opc = max(opc_codigo) from rrhh_opc_opciones

				insert into @tbl_grupe
				(grupe_nuevo_codigo, grupe_codigo, grupe_nombre, grupe_nuevo_codenc, grupe_orden)
				select @max_grupe +  row_number() over(order by grupe_codigo),
				grupe_codigo, grupe_nombre, @max_codenc, grupe_orden 
				from rrhh_grupe_grupos_estudio
				where grupe_codenc = @codenc_origen
				--select * from @tbl_grupe

				--Preguntas
				insert into @tbl_pre (pre_nuevo_codigo, pre_codigo, pre_codtipp, pre_nuevo_codgrupe, pre_codgrupe, pre_orden_general, pre_orden, pre_pregunta)
				select  @max_pre +  row_number() over(order by pre_codigo), 
				pre.pre_codigo 'pre_codigo', pre.pre_codtipp 'pre_codtipp', tbl_grupe.grupe_nuevo_codigo 'grupe_nuevo_codigo', pre.pre_codgrupe 'pre_codgrupe', pre.pre_orden_general 'pre_orden_general', pre.pre_orden 'pre_orden', pre.pre_pregunta 'pre_pregunta'
				from rrhh_grupe_grupos_estudio as grupe
				inner join rrhh_pre_preguntas as pre on pre_codgrupe = grupe.grupe_codigo
				inner join @tbl_grupe as tbl_grupe on tbl_grupe.grupe_codigo = grupe.grupe_codigo
				where grupe.grupe_codenc = @codenc_origen
				--select * from @tbl_pre
				
				----Opciones
				insert into @tbl_opc (opc_nuevo_codigo, opc_codigo, opc_nueva_codenc, opc_codenc, opc_opcion)
				select @max_opc +  row_number() over(order by opc_codigo), 
				opc_codigo, @max_codenc, opc_codenc, opc_opcion
				from rrhh_enc_encuestas
				inner join rrhh_opc_opciones as opc on opc_codenc = enc_codigo
				where opc_codenc = @codenc_origen
				--select * from @tbl_opc

				--Preguntas-Opciones
				insert into @tbl_preopc(preopc_nueva_codpre, preopc_nueva_codopc, preopc_codtipo, preopc_opc_orden)
				select tbl_p.pre_nuevo_codigo, tbl_o.opc_nuevo_codigo, preopc_codtipo, preopc_opc_orden 
				from rrhh_preopc_preguntas_opciones
				inner join @tbl_pre tbl_p on tbl_p.pre_codigo = preopc_codpre
				inner join @tbl_opc tbl_o on tbl_o.opc_codigo = preopc_codopc

				--Insertando en las tablas
				insert into rrhh_enc_encuestas (enc_nombre, enc_codpon, enc_codcil, enc_codtde, enc_objetivo, enc_fecha_inicio, enc_fecha_fin)
				select enc_nombre, enc_codpon, @codcil_encuesta_destino 'enc_codcil', @codtde 'enc_codtde', enc_objetivo, enc_fecha_inicio, enc_fecha_fin 
				from rrhh_enc_encuestas
				where enc_codigo = @codenc_origen

				insert into rrhh_grupe_grupos_estudio (grupe_nombre, grupe_codenc, grupe_orden)
				select grupe_nombre, grupe_nuevo_codenc, grupe_orden 
				from @tbl_grupe

				insert into rrhh_pre_preguntas (pre_codtipp, pre_codgrupe, pre_orden_general, pre_orden, pre_pregunta)
				select pre_codtipp, pre_nuevo_codgrupe, pre_orden_general, pre_orden, pre_pregunta 
				from @tbl_pre

				insert into rrhh_opc_opciones (opc_codenc, opc_opcion)
				select opc_nueva_codenc, opc_opcion from @tbl_opc
					
				insert into rrhh_preopc_preguntas_opciones (preopc_codpre, preopc_codopc, preopc_codtipo, preopc_opc_orden)
				select preopc_nueva_codpre, preopc_nueva_codopc, preopc_codtipo, preopc_opc_orden 
				from @tbl_preopc
					
				select concat('Codigo de la encuesta: ', @max_codenc) res
			end
		end
		else
		begin
			--print ('Ya existe una encuesta en el ciclo ', @codcil_encuesta_destino, ' para el tipo de estudio ', @codtde)
			declare @enc_codigo int = 0
			select @enc_codigo = enc_codigo from rrhh_enc_encuestas where enc_codcil = @codcil_encuesta_destino and enc_codtde = @codtde
			exec sp_data_rrhh_encuestas @opcion = 1, @codenc = @enc_codigo
		end
	end
end