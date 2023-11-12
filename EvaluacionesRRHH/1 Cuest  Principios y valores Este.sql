select * from rrhh_enc_encuestas

insert into rrhh_enc_encuestas
(enc_nombre_unidad_encargada, enc_nombre_encuesta, enc_codcil, 
enc_objetivo, 
enc_indicaciones, enc_forma_contestar, enc_fecha_inicio, enc_fecha_fin, enc_correo_encargado_encuesta, enc_encargado_encuesta)
values 
--E8
('DIRECCIÓN DE RECURSOS HUMANOS', 'INSTRUMENTO DE EVALUACIÓN DE PRINCIPIOS Y VALORES', 129, 
null, 
'<strong>INDICACIONES GENERALES</strong><br>1. Este instrumento permitirá conocer la valoración de los principios y valores por parte del personal.<br>2. Agradeceremos la objetividad en sus respuestas, recordemos que el personal responsable de la elaboración del informe, invertirá tiempo y esfuerzo en plantear interpretaciones que no existen o que no son muy importantes y dejar de lado otras de mayor importancia.<br>',
'<strong>FORMA DE CONTESTAR</strong>Por favor indique con una equis (X) el grado en el cual usted está de acuerdo con cada pregunta o proposición conforme a la siguiente escala:<br><center>S = siempre</center><center>MV = Muchas veces</center><center>AV = a veces</center><center>PV = pocas veces</center><center>N = nunca</center><br>', '2022-08-15 00:00:00.000', '2022-08-23 10:30:00.000'
, 'vilma.flores@utec.edu.sv', 'Vilma Elena Flores de Avila')

select * from rrhh_grupe_grupos_estudio

alter table rrhh_grupe_grupos_estudio add grupe_descripcion varchar(max)

insert into rrhh_grupe_grupos_estudio (grupe_nombre, grupe_orden, grupe_codenc, grupe_descripcion) values
--E8
('I. PRINCIPIO JUSTICIA', 1, 8, 'Principio moral que inclina a obrar y juzgar respetando la verdad y dando a cada uno lo que le corresponde; siendo su conjunto de valores esenciales.'), --28
('II. PRINCIPIO INTEGRIDAD', 2, 8, 'La integridad, se refiere a la entereza moral, rectitud y honradez en la conducta y en el comportamiento. En general, una persona o institución integra es alguien en quien se puede confiar.'), --29
('III. PRINCIPIO DILIGENCIA', 3, 8, 'Se refiere a la actitud de cuidado, prontitud, agilidad y eficiencia con la que se lleva a cabo una gestión. Es el esmero y cuidado en realizar algo.'), --30
('IV. PRINCIPIO GRATITUD', 4, 8, 'Reconocer que los demás han hecho algo por nosotros, así como apreciar las pequeñas cosas que forman parte de nuestro entorno.'), --31
('V. PRINCIPIO COMPROMISO', 5, 8, 'Actitud fundamental que se manifiesta en la identificación con la misión y visión institucional, el esfuerzo realizado para lograrlas y la responsabilidad que nos compete.')--32

select * from rrhh_subgru_sub_grupo
alter table rrhh_subgru_sub_grupo add subgru_descripcion varchar(max)
insert into rrhh_subgru_sub_grupo (subgru_nombre, subgru_orden, subgru_codgrupe, subgru_descripcion) values
--E8
('A. Respeto', 1, 28, 'Mostrar respeto por los empleados y usuarios de nuestra institución, implica cumplir lo que prometemos y ofrecer disculpas sinceras si algo no se cumple. En la Institución:'), ('B. Equidad', 2, 28, 'Imparcialidad para reconocer el derecho de otro, ofrecer a compañeros y usuarios las mismas oportunidades y tratamientos Aplicación de los derechos y obligaciones de manera justa y equitativa a las personas. En la Institución:'), ('C. Dignidad', 3, 28, 'Indica el respeto y la estima que todas las personas merecen y se afirma de quien posee un nivel de calidad humana irreprochable. En la Institución:'), 
('D. Honradez', 1, 29, 'Ser fiel a las propias creencias y valores y actuar de modo coherente con ellas. En la Institución:'), ('E. Rectitud', 2, 29, 'Actuar haciendo lo correcto, comportamiento correcto y justo en todos los ámbitos de la vida. En la Institución:'), ('F. Entereza moral ', 3, 29, 'Facultad para tomar decisiones sobre el comportamiento de sí mismo, fortaleza para mantener sus propias decisiones y severa observancia de la disciplina. En la Institución:'), 
('G. Vocación de servicio', 1, 30, 'Estar atentos en anticiparnos a las necesidades de los demás y otorgar satisfacción con rapidez y calidad. En la Institución:'), ('H. Competencia de acción', 2, 30, 'Conjunto de conocimientos, habilidades, comportamientos y actitudes necesarias para la gestión. En la Institución:'), ('I. Formalidad', 3, 30, 'Ser responsables y cumplir nuestros compromisos; realizar el trabajo con orden y disciplina. En la Institución:'), 
('J. Reconocimiento del otro', 1, 31, 'Reconocer, aceptar, aprobar y valorar a otros. Es un acto de respeto y agradecimiento. En la Institución:'), ('K. Solidaridad', 2, 31, 'Profesar los mismos valores y principios, trabajar unidos para lograr nuestras metas. Capacidad de ser generoso y comprometido en nuestro entorno laboral. En la Institución:'), ('L. Lealtad', 3, 31, 'Guardar fidelidad, identificación, dedicación y transparencia a la institución, así como al personal que la conforma, aplicando los valores que nos rigen. En la Institución:'), 
('M. Responsabilidad', 1, 32, 'Responsabilidad es dar cumplimiento a las obligaciones y ser cuidadoso al tomar decisiones el trabajo se realiza de manera oportuna y eficiente. En la Institución:'), ('N. Disciplina', 2, 32, 'Capacidad de actuar forma coordinada, ordenada y sistemática poniendo en práctica los principios relativos al orden y la constancia, tanto para la ejecución de tareas y actividades cotidianas, como en la vida. En la Institución:'), ('O. Sentido de pertenencia', 3, 32, 'Vínculo entre un trabajador y la empresa, estar identificado con los valores y objetivos de la Institución. En la Institución:')


select * from rrhh_pre_preguntas
--E8
insert into rrhh_pre_preguntas (pre_codtipp, pre_codsubgru, pre_orden_general, pre_orden, pre_pregunta) values
(1, 89, 1, 1, '1 Mostramos tolerancia social, es decir aprecio las diferencias individuales'), 
(1, 89, 2, 2, '2 Nos comprometemos con el respeto a leyes, reglamentos internos, lineamientos y directrices institucionales.'), 
(1, 89, 3, 3, '3 Fomentamos un ambiente de escucha respetuosa con todos los públicos'), 
(1, 89, 4, 4, '4 Damos opiniones sin herir a los demás'), 
(1, 89, 5, 5, '5 Valoramos el esfuerzo  de los otros y se atienden  sus contribuciones'), 
(1, 90, 6, 1, '1 Actuamos de manera consistente con todas las personas y en todo momento'), 
(1, 90, 7, 2, '2 Procedemos de acuerdo a los principios éticos de justicia'), 
(1, 90, 8, 3, '3 Somos equitativos en la interacción con los demás'), 
(1, 90, 9, 4, '4 Somos  razonables e imparciales en la solución de problemas con las personas'), 
(1, 90, 10, 5, '5 Ofrecemos el mismo trato tanto a los hombros como a las mujeres'), 
(1, 91, 11, 1, '1 El trato hacia compañeros y usuarios es sin ninguna discriminación.'), 
(1, 91, 12, 2, '2 Fomentamos el comportamiento según parámetros de ética, rectitud  y honestidad.'), 
(1, 91, 13, 3, '3 Promovemos  la sana convivencia por el respeto de la persona.'), 
(1, 91, 14, 4, '4 Permitimos al personal mejorar sus capacidades y valoramos el esfuerzo por el crecimiento personal.'), 
(1, 91, 15, 5, '5 Alentamos cualidades grupales como el respeto, y la colaboración.'), 
(1, 92, 16, 1, '1 Actuamos con honestidad'), 
(1, 92, 17, 2, '2 Cumplimos de forma responsable y transparente con nuestras obligaciones'), 
(1, 92, 18, 3, '3 Observamos el respeto a las normas'), 
(1, 92, 19, 4, '4 Somos celosos de nuestra reputación'), 
(1, 92, 20, 5, '5 Tenemos especial cuidado en el manejo de los bienes económicos y materiales'), 
(1, 93, 21, 1, '1 Evitamos las habladurías malsanas'), 
(1, 93, 22, 2, '2 Cumplimos  con los compromisos adquiridos'), 
(1, 93, 23, 3, '3 Damos  los mejores esfuerzos en el trabajo'), 
(1, 93, 24, 4, '4 Realizamos nuestro trabajo a consciencia y con honestidad'), 
(1, 93, 25, 5, '5 Respetamos los principios y valores'), 
(1, 94, 26, 1, '1 Observamos la rectitud en los procesos que ejecutamos'), 
(1, 94, 27, 2, '2 Mostramos fortaleza al enfrentar los problemas'), 
(1, 94, 28, 3, '3 Afrontamos  la adversidad con confianza y serenidad'), 
(1, 94, 29, 4, '4 Poseemos firmeza en nuestras  acciones y actuamos de manera correcta'), 
(1, 94, 30, 5, '5 Poseemos Valor y fuerza necesarios para hacer frente a las dificultades'), 
(1, 95, 31, 1, '1 Mantenemos una actitud empática con nuestros compañeros y usuarios'), 
(1, 95, 32, 2, '2 Atendemos amablemente y de manera honesta a todos nuestros públicos'), 
(1, 95, 33, 3, '3 Realizamos nuestras  laborales con la mayor eficacia posible'), 
(1, 95, 34, 4, '4 Poseemos disposición para servir, porque comprendemos el compromiso hacia nuestras actividades.'), 
(1, 95, 35, 5, '5 Nos interesa la satisfacción de todos nuestros públicos'), 
(1, 96, 36, 1, '1 Usamos un lenguaje apropiado, escuchamos, informamos y fomentamos eficientes canales de comunicación.'), 
(1, 96, 37, 2, '2 Poseemos redes activas de relaciones para fomentar el trabajo en equipo'), 
(1, 96, 38, 3, '3 Llevamos a cabo actividades de formación, para desarrollar habilidades técnicas'), 
(1, 96, 39, 4, '4 Tenemos la capacidad de adaptarnos a las circunstancias y los cambios'), 
(1, 96, 40, 5, '5 Utilizamos la información para identificar problemas y las posibles alternativas de solución.'), 
(1, 97, 41, 1, '1 Nos comprometemos con las actividades que realizamos'), 
(1, 97, 42, 2, '2 Poseemos actitudes de atención, empeño y participación activa en la solución de problemas'), 
(1, 97, 43, 3, '3 Tenemos un trato solidario y respetuoso con los compañeros de trabajo'), 
(1, 97, 44, 4, '4 Poseemos Visión, Misión y cultura basada en Valores'), 
(1, 97, 45, 5, '5 Alineamos las: conductas, las relaciones entre las personas y los resultados deseados'), 
(1, 98, 46, 1, '1 Usamos un lenguaje apropiado, sin recurrir a palabras altisonantes de mal gusto '), 
(1, 98, 47, 2, '2 Evitamos encontrar problemas y dificultades donde no los hay'), 
(1, 98, 48, 3, '3 Permitimos que las personas manifiesten sus opiniones'), 
(1, 98, 49, 4, '4 Tenemos la capacidad de adaptarnos a las circunstancias y los cambios'), 
(1, 98, 50, 5, '5 Entendemos que siempre existen diferentes puntos de vista y mucha formas de  resolver problemas'), 
(1, 99, 51, 1, '1 Procuramos fijar reglas de trabajo justas para todos, las dudas y opiniones son compartidas. '), 
(1, 99, 52, 2, '2 Entendemos que la generosidad y el compromiso con los demás brindan grandes aprendizajes.'), 
(1, 99, 53, 3, '3 Practicamos la colaboración y el compañerismo y con ello contribuimos al crecimiento personal e institucional.'), 
(1, 99, 54, 4, '4 Reconocemos que para lograr cualquier objetivo los esfuerzos combinados logran más que los esfuerzos individuales. '), 
(1, 99, 55, 5, '5 Aceptamos las diferencias en nuestras formas de trabajar, relacionarnos, entender el negocio, etc. Porque esto facilita que tengamos una mayor predisposición a apoyar a otros.'), 
(1, 100, 56, 1, '1 Existen actitudes de compromiso  hacia la institución'), 
(1, 100, 57, 2, '2 Las relaciones sociales y de trabajo del personal, han creado vínculos sólidos de confianza y respeto'), 
(1, 100, 58, 3, '3 La forma en que se asumen los roles, demuestra la incondicionalidad hacia la institución.'), 
(1, 100, 59, 4, '4 Se proponen mejoras, se resuelven conflictos, se ayuda a los compañeros y se ahorran recursos'), 
(1, 100, 60, 5, '5 Se acompaña al personal ofreciendo opciones y herramientas para que hagan mejor su trabajo'), 
(1, 101, 61, 1, '1 Se da cumplimiento a las obligaciones y se es cuidadoso al tomar decisiones'), 
(1, 101, 62, 2, '2 Realizamos nuestros deberes de manera oportuna y eficiente'), 
(1, 101, 63, 3, '3 Asumimos las consecuencias de nuestras acciones.'), 
(1, 101, 64, 4, '4 Se ejercen los derechos y se desempeñan las obligaciones de manera comprometida'), 
(1, 101, 65, 5, '5 Se muestra iniciativa, empuje y energía hacia el logro de resultados'), 
(1, 102, 66, 1, '1 Ejecutamos nuestras actividades con orden y constancia'), 
(1, 102, 67, 2, '2 Organizamos el tiempo y actividades como garantía de credibilidad '), 
(1, 102, 68, 3, '3 Aprendemos a reconocer el apoyo que se tiene de otros, de tal manera que esto ayude a la consecución de las metas.'), 
(1, 102, 69, 4, '4 Se aprecia la capacidad de actuar con energía en un momento determinado. '), 
(1, 102, 70, 5, '5 Somos realistas y nos esforzamos por desarrollar más las habilidades y destrezas.'), 
(1, 103, 71, 1, '1 Estamos comprometidos para generar un mejor desempeño'), 
(1, 103, 72, 2, '2 Sentimos como propios  los objetivos de la institución y compartimos sus valores'), 
(1, 103, 73, 3, '3 Se identifica qué motiva a los empleados y les hace sentir parte de la empresa.'), 
(1, 103, 74, 4, '4 Nos sentimos cómodos, bienvenidos y aceptados'), 
(1, 103, 75, 5, '5 Se hacen  esfuerzos  por fomentar los sentimientos de pertenencia')

select * from rrhh_opc_opciones

insert into rrhh_opc_opciones (opc_codenc, opc_abreviado, opc_opcion, opc_opcion_orden, opc_nota) values
(8, 'S', 'Siempre', 1, 10), (8, 'MV', 'Muchas veces', 2, 7.5), (8, 'AV', 'A veces', 3, 5), (8, 'PV', 'Pocas veces', 4, 2.5), (8, 'N', 'Nunca', 5, 0)

select * from rrhh_preopc_preguntas_opciones
--E8
insert into rrhh_preopc_preguntas_opciones (preopc_codpre, preopc_codopc, preopc_codtipo, preopc_opc_orden) values
(429, 36, 1, 1), 
(429, 37, 1, 2), 
(429, 38, 1, 3), 
(429, 39, 1, 4), 
(429, 40, 1, 5), 

(430, 36, 1, 1), 
(430, 37, 1, 2), 
(430, 38, 1, 3), 
(430, 39, 1, 4), 
(430, 40, 1, 5), 

(431, 36, 1, 1), 
(431, 37, 1, 2), 
(431, 38, 1, 3), 
(431, 39, 1, 4), 
(431, 40, 1, 5), 

(432, 36, 1, 1), 
(432, 37, 1, 2), 
(432, 38, 1, 3), 
(432, 39, 1, 4), 
(432, 40, 1, 5), 

(433, 36, 1, 1), 
(433, 37, 1, 2), 
(433, 38, 1, 3), 
(433, 39, 1, 4), 
(433, 40, 1, 5), 

(434, 36, 1, 1), 
(434, 37, 1, 2), 
(434, 38, 1, 3), 
(434, 39, 1, 4), 
(434, 40, 1, 5), 

(435, 36, 1, 1), 
(435, 37, 1, 2), 
(435, 38, 1, 3), 
(435, 39, 1, 4), 
(435, 40, 1, 5), 

(436, 36, 1, 1), 
(436, 37, 1, 2), 
(436, 38, 1, 3), 
(436, 39, 1, 4), 
(436, 40, 1, 5), 

(437, 36, 1, 1), 
(437, 37, 1, 2), 
(437, 38, 1, 3), 
(437, 39, 1, 4), 
(437, 40, 1, 5), 

(438, 36, 1, 1), 
(438, 37, 1, 2), 
(438, 38, 1, 3), 
(438, 39, 1, 4), 
(438, 40, 1, 5), 

(439, 36, 1, 1), 
(439, 37, 1, 2), 
(439, 38, 1, 3), 
(439, 39, 1, 4), 
(439, 40, 1, 5), 

(440, 36, 1, 1), 
(440, 37, 1, 2), 
(440, 38, 1, 3), 
(440, 39, 1, 4), 
(440, 40, 1, 5), 

(441, 36, 1, 1), 
(441, 37, 1, 2), 
(441, 38, 1, 3), 
(441, 39, 1, 4), 
(441, 40, 1, 5), 

(442, 36, 1, 1), 
(442, 37, 1, 2), 
(442, 38, 1, 3), 
(442, 39, 1, 4), 
(442, 40, 1, 5), 

(443, 36, 1, 1), 
(443, 37, 1, 2), 
(443, 38, 1, 3), 
(443, 39, 1, 4), 
(443, 40, 1, 5), 

(444, 36, 1, 1), 
(444, 37, 1, 2), 
(444, 38, 1, 3), 
(444, 39, 1, 4), 
(444, 40, 1, 5), 

(445, 36, 1, 1), 
(445, 37, 1, 2), 
(445, 38, 1, 3), 
(445, 39, 1, 4), 
(445, 40, 1, 5), 

(446, 36, 1, 1), 
(446, 37, 1, 2), 
(446, 38, 1, 3), 
(446, 39, 1, 4), 
(446, 40, 1, 5), 

(447, 36, 1, 1), 
(447, 37, 1, 2), 
(447, 38, 1, 3), 
(447, 39, 1, 4), 
(447, 40, 1, 5), 

(448, 36, 1, 1), 
(448, 37, 1, 2), 
(448, 38, 1, 3), 
(448, 39, 1, 4), 
(448, 40, 1, 5), 

(449, 36, 1, 1), 
(449, 37, 1, 2), 
(449, 38, 1, 3), 
(449, 39, 1, 4), 
(449, 40, 1, 5), 

(450, 36, 1, 1), 
(450, 37, 1, 2), 
(450, 38, 1, 3), 
(450, 39, 1, 4), 
(450, 40, 1, 5), 

(451, 36, 1, 1), 
(451, 37, 1, 2), 
(451, 38, 1, 3), 
(451, 39, 1, 4), 
(451, 40, 1, 5), 

(452, 36, 1, 1), 
(452, 37, 1, 2), 
(452, 38, 1, 3), 
(452, 39, 1, 4), 
(452, 40, 1, 5), 

(453, 36, 1, 1), 
(453, 37, 1, 2), 
(453, 38, 1, 3), 
(453, 39, 1, 4), 
(453, 40, 1, 5), 

(454, 36, 1, 1), 
(454, 37, 1, 2), 
(454, 38, 1, 3), 
(454, 39, 1, 4), 
(454, 40, 1, 5), 

(455, 36, 1, 1), 
(455, 37, 1, 2), 
(455, 38, 1, 3), 
(455, 39, 1, 4), 
(455, 40, 1, 5), 

(456, 36, 1, 1), 
(456, 37, 1, 2), 
(456, 38, 1, 3), 
(456, 39, 1, 4), 
(456, 40, 1, 5), 

(457, 36, 1, 1), 
(457, 37, 1, 2), 
(457, 38, 1, 3), 
(457, 39, 1, 4), 
(457, 40, 1, 5), 

(458, 36, 1, 1), 
(458, 37, 1, 2), 
(458, 38, 1, 3), 
(458, 39, 1, 4), 
(458, 40, 1, 5), 

(459, 36, 1, 1), 
(459, 37, 1, 2), 
(459, 38, 1, 3), 
(459, 39, 1, 4), 
(459, 40, 1, 5), 

(460, 36, 1, 1), 
(460, 37, 1, 2), 
(460, 38, 1, 3), 
(460, 39, 1, 4), 
(460, 40, 1, 5), 

(461, 36, 1, 1), 
(461, 37, 1, 2), 
(461, 38, 1, 3), 
(461, 39, 1, 4), 
(461, 40, 1, 5), 

(462, 36, 1, 1), 
(462, 37, 1, 2), 
(462, 38, 1, 3), 
(462, 39, 1, 4), 
(462, 40, 1, 5), 

(463, 36, 1, 1), 
(463, 37, 1, 2), 
(463, 38, 1, 3), 
(463, 39, 1, 4), 
(463, 40, 1, 5), 

(464, 36, 1, 1), 
(464, 37, 1, 2), 
(464, 38, 1, 3), 
(464, 39, 1, 4), 
(464, 40, 1, 5), 

(465, 36, 1, 1), 
(465, 37, 1, 2), 
(465, 38, 1, 3), 
(465, 39, 1, 4), 
(465, 40, 1, 5), 

(466, 36, 1, 1), 
(466, 37, 1, 2), 
(466, 38, 1, 3), 
(466, 39, 1, 4), 
(466, 40, 1, 5), 

(467, 36, 1, 1), 
(467, 37, 1, 2), 
(467, 38, 1, 3), 
(467, 39, 1, 4), 
(467, 40, 1, 5), 

(468, 36, 1, 1), 
(468, 37, 1, 2), 
(468, 38, 1, 3), 
(468, 39, 1, 4), 
(468, 40, 1, 5), 

(469, 36, 1, 1), 
(469, 37, 1, 2), 
(469, 38, 1, 3), 
(469, 39, 1, 4), 
(469, 40, 1, 5), 

(470, 36, 1, 1), 
(470, 37, 1, 2), 
(470, 38, 1, 3), 
(470, 39, 1, 4), 
(470, 40, 1, 5), 

(471, 36, 1, 1), 
(471, 37, 1, 2), 
(471, 38, 1, 3), 
(471, 39, 1, 4), 
(471, 40, 1, 5), 

(472, 36, 1, 1), 
(472, 37, 1, 2), 
(472, 38, 1, 3), 
(472, 39, 1, 4), 
(472, 40, 1, 5), 

(473, 36, 1, 1), 
(473, 37, 1, 2), 
(473, 38, 1, 3), 
(473, 39, 1, 4), 
(473, 40, 1, 5), 

(474, 36, 1, 1), 
(474, 37, 1, 2), 
(474, 38, 1, 3), 
(474, 39, 1, 4), 
(474, 40, 1, 5), 

(475, 36, 1, 1), 
(475, 37, 1, 2), 
(475, 38, 1, 3), 
(475, 39, 1, 4), 
(475, 40, 1, 5), 

(476, 36, 1, 1), 
(476, 37, 1, 2), 
(476, 38, 1, 3), 
(476, 39, 1, 4), 
(476, 40, 1, 5), 

(477, 36, 1, 1), 
(477, 37, 1, 2), 
(477, 38, 1, 3), 
(477, 39, 1, 4), 
(477, 40, 1, 5), 

(478, 36, 1, 1), 
(478, 37, 1, 2), 
(478, 38, 1, 3), 
(478, 39, 1, 4), 
(478, 40, 1, 5), 

(479, 36, 1, 1), 
(479, 37, 1, 2), 
(479, 38, 1, 3), 
(479, 39, 1, 4), 
(479, 40, 1, 5), 

(480, 36, 1, 1), 
(480, 37, 1, 2), 
(480, 38, 1, 3), 
(480, 39, 1, 4), 
(480, 40, 1, 5), 

(481, 36, 1, 1), 
(481, 37, 1, 2), 
(481, 38, 1, 3), 
(481, 39, 1, 4), 
(481, 40, 1, 5), 

(482, 36, 1, 1), 
(482, 37, 1, 2), 
(482, 38, 1, 3), 
(482, 39, 1, 4), 
(482, 40, 1, 5), 

(483, 36, 1, 1), 
(483, 37, 1, 2), 
(483, 38, 1, 3), 
(483, 39, 1, 4), 
(483, 40, 1, 5), 

(484, 36, 1, 1), 
(484, 37, 1, 2), 
(484, 38, 1, 3), 
(484, 39, 1, 4), 
(484, 40, 1, 5), 

(485, 36, 1, 1), 
(485, 37, 1, 2), 
(485, 38, 1, 3), 
(485, 39, 1, 4), 
(485, 40, 1, 5), 

(486, 36, 1, 1), 
(486, 37, 1, 2), 
(486, 38, 1, 3), 
(486, 39, 1, 4), 
(486, 40, 1, 5), 

(487, 36, 1, 1), 
(487, 37, 1, 2), 
(487, 38, 1, 3), 
(487, 39, 1, 4), 
(487, 40, 1, 5), 

(488, 36, 1, 1), 
(488, 37, 1, 2), 
(488, 38, 1, 3), 
(488, 39, 1, 4), 
(488, 40, 1, 5), 

(489, 36, 1, 1), 
(489, 37, 1, 2), 
(489, 38, 1, 3), 
(489, 39, 1, 4), 
(489, 40, 1, 5), 

(490, 36, 1, 1), 
(490, 37, 1, 2), 
(490, 38, 1, 3), 
(490, 39, 1, 4), 
(490, 40, 1, 5), 

(491, 36, 1, 1), 
(491, 37, 1, 2), 
(491, 38, 1, 3), 
(491, 39, 1, 4), 
(491, 40, 1, 5), 

(492, 36, 1, 1), 
(492, 37, 1, 2), 
(492, 38, 1, 3), 
(492, 39, 1, 4), 
(492, 40, 1, 5), 

(493, 36, 1, 1), 
(493, 37, 1, 2), 
(493, 38, 1, 3), 
(493, 39, 1, 4), 
(493, 40, 1, 5), 

(494, 36, 1, 1), 
(494, 37, 1, 2), 
(494, 38, 1, 3), 
(494, 39, 1, 4), 
(494, 40, 1, 5), 

(495, 36, 1, 1), 
(495, 37, 1, 2), 
(495, 38, 1, 3), 
(495, 39, 1, 4), 
(495, 40, 1, 5), 

(496, 36, 1, 1), 
(496, 37, 1, 2), 
(496, 38, 1, 3), 
(496, 39, 1, 4), 
(496, 40, 1, 5), 

(497, 36, 1, 1), 
(497, 37, 1, 2), 
(497, 38, 1, 3), 
(497, 39, 1, 4), 
(497, 40, 1, 5), 

(498, 36, 1, 1), 
(498, 37, 1, 2), 
(498, 38, 1, 3), 
(498, 39, 1, 4), 
(498, 40, 1, 5), 

(499, 36, 1, 1), 
(499, 37, 1, 2), 
(499, 38, 1, 3), 
(499, 39, 1, 4), 
(499, 40, 1, 5), 

(500, 36, 1, 1), 
(500, 37, 1, 2), 
(500, 38, 1, 3), 
(500, 39, 1, 4), 
(500, 40, 1, 5), 

(501, 36, 1, 1), 
(501, 37, 1, 2), 
(501, 38, 1, 3), 
(501, 39, 1, 4), 
(501, 40, 1, 5), 

(502, 36, 1, 1), 
(502, 37, 1, 2), 
(502, 38, 1, 3), 
(502, 39, 1, 4), 
(502, 40, 1, 5), 

(503, 36, 1, 1), 
(503, 37, 1, 2), 
(503, 38, 1, 3), 
(503, 39, 1, 4), 
(503, 40, 1, 5)