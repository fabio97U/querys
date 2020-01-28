--dropp table enc_enc_encuesta
create table enc_enc_encuesta(
	enc_codigo int primary key identity(1,1),
	enc_nombre varchar(50),
	enc_descripcion varchar(1024),
	enc_fecha_creacion datetime default getdate()
);
--select * from enc_enc_encuesta
insert into enc_enc_encuesta (enc_nombre, enc_descripcion) values ('CUESTIONARIO PARA EXPLORAR EL CLIMA ORGANIZACIONAL', 'Cuestionario sobre el clima laboral');

--dropp table enc_dim_dimensiones
create table enc_dim_dimensiones(
	dim_codigo int primary key identity(1,1),
	dim_nombre varchar(50),
	dim_descripcion varchar(1024),
	dim_codenc  int foreign key references enc_enc_encuesta,
	dim_fecha_creacion datetime default getdate()
);
--select * from enc_dim_dimensiones
insert into enc_dim_dimensiones(dim_nombre, dim_descripcion, dim_codenc) values
('I. ESTRUCTURA', 'Representa la percepción que tienen los miembros de la organización acerca de la cantidad de reglas, procedimientos, trámites y otras limitaciones a que se ven enfrentados en el desarrollo de su trabajo.   La medida  en  que la  organización pone  énfasis  en la burocracia, versus el  énfasis puesto en un ambiente de trabajo ágil y funcional.', 1), 
('II. RESPONSABILIDAD', 'Es el sentimiento de los miembros de la organización acerca de su autonomía en la toma de decisiones relacionadas a su trabajo.  La medida en que la supervisión que reciben es de tipo general y no estrecha, es decir, el sentimiento de ser el propio jefe y no tener sobre chequeo en el trabajo.', 1), 
('III. RECOMPENSA', 'Corresponde a la percepción de los miembros sobre la adecuación de la recompensa recibida por el trabajo bien hecho. Es la medida en que la organización utiliza más el premio que el castigo.', 1), 
('IV. DESAFIO', 'Corresponde al sentimiento que tienen los miembros de la organización acerca de los desafíos que impone el trabajo La medida en que la organización promueve la aceptación de riesgos calculados a fin de lograr los objetivos propuestos', 1), 
('V. RELACIONES', 'Es la percepción por parte de los miembros de la empresa acerca de la existencia de un ambiente de trabajo grato y de buenas relaciones sociales, tanto entre pares como entre jefes y subordinados', 1), 
('VI. COOPERACION', 'Es el sentimiento de los miembros de la empresa sobre la existencia de un espíritu de ayuda por parte de los directivos y de otros empleados del grupo. Énfasis puesto en el apoyo mutuo, tanto de niveles superiores como operativos. Trabajo en equipo.', 1), 
('VII. ESTANDARES', 'Es la percepción de los miembros acerca del énfasis que se pone en la empresa sobre las normas de rendimiento.', 1), 
('VIII. CONFLICTOS', 'Es el sentimiento de los miembros de la organización, tanto colegas como superiores, de que se aceptan las opiniones discrepantes y no temen enfrentar y solucionar los problemas tan pronto surjan', 1), 
('IX. IDENTIDAD', 'Es el sentimiento de pertenencia a la organización y que se es un elemento importante y valioso dentro del grupo de trabajo. En general, la sensación de compartir los objetivos personales con los de la organización.', 1), 
('X. PUESTO DE TRABAJO', 'Esta dimensión trata de diversos aspectos relacionados con el puesto de trabajo, el soporte  administrativo que se le brinda para el desarrollo normal de las actividades bajo su cargo, y en qué medida se siente satisfecho y contento con lo que hace.', 1), 
('XI. LIDERAZGO Y SOPORTE', 'Se evalúan los estilos de liderazgo practicados en la organización, el tipo de relación y trato, el soporte y orientación que brindan los líderes y demás coordinadores al resto del personal. También se evalúa el interés y preocupación que brindan los líderes y coordinadores por escuchar y atender los problemas de los subalternos, resolviéndolos  oportunamente', 1), 
('XII. CALIDAD EN EL SERVICIO', 'Esta dimensión evalúa la satisfacción que sienten los empleados con respecto al servicio que brindan a los clientes, tanto internos como externos, y la motivación que se tiene para ofrecer un servicio de calidad.', 1), 
('XIII. PRACTICA DE RECURSOS HUMANOS', 'Esta dimensión evalúa la calidad de la administración de recursos humanos que se practica en la  universidad, programas  existentes  que   apoyan  el   desarrollo   del personal, los  sistemas  de compensación y beneficios y programas de capacitación.', 1), 
('XIV. AMBIENTE FISICO DE TRABAJO', 'Hace referencia al nivel de satisfacción que tienen los empleados con relación a las instalaciones en su puesto de trabajo, áreas recreativas, comedores, servicios sanitarios, etc. Evalúa la adecuada distribución del espacio físico, ventilación, iluminación y temperatura', 1),
('XV. VALORES Y PRINCIPIOS', 'Se evalúan diferentes tipos de valores y principios que son practicados dentro de la organización', 1), 
('XVI. COMUNICACIÓN', 'Se evalúa la comunicación que acontece en el contexto laboral, tanto formal como informal. Se pone énfasis en la existencia de canales formales ascendentes y descendentes', 1)

--dropp table enc_pre_preguntas
create table enc_pre_preguntas(
	pre_codigo int primary key identity(1,1),
	pre_coddim int foreign key references enc_dim_dimensiones,
	pre_pregunta varchar(1024),
	pre_fecha_creacion datetime default getdate()
);
--select * from enc_pre_preguntas
insert into enc_pre_preguntas (pre_coddim, pre_pregunta) values
(1, '1. El equipo consigue mejores decisiones  porque a sus  miembros se les permite tomar la iniciativa.'),
(1, '2. El personal de la universidad   hace su trabajo sin   dificultades debido a que la cantidad de normas, procesos y demás lineamientos es la adecuada.'),
(1, '3. Las normas y procedimientos en la empresa son  realistas.'),
(1, '4. La institución  no es burocrática, sus trámites son ágiles.'),
(1, '5. Mi percepción es que  las  reglas y procedimientos que hay que cumplir en el trabajo, son  ordenados  y nos facilitan el desarrollo de las actividades.'),
(2, '1. Los jefes  delegan. Ellos  empoderan a sus colaboradores.'),
(2, '2. Las decisiones importantes se toman de acuerdo al nivel de responsabilidad que tienen los empleados y jefes.'),
(2, '3. A los empleados  se les da la oportunidad para que contribuyan con ideas de cómo hacer las cosas mejor.'),
(2, '4. Muchos miembros de la unidad sugieren nuevas ideas.'),
(2, '5. En mi unidad tenemos autonomia, solo se consulta lo excepcional.'),
(3, '1. En la Universidad existen políticas para premiar a un empleado que hace algo excepcional.'),
(3, '2. Me siento satisfecho con el salario que tengo.'),
(3, '3. En la universidad hay buenos incentivos para mejorar la productividad.'),
(3, '4. La Utec es una opción para una calidad de vida laboral.'),
(3, '5. Nuestras prestaciones laborales son superiores a las prestaciones de otras empresas semejantes.'),
(4, '1. Se aceptan las nuevas ideas.'),
(4, '2. Mi trabajo permite desarrollar mi creatividad personal.'),
(4, '3. Las decisiones importantes se toman en consulta con los colaboradores.'),
(4, '4. Se aceptan más las nuevas  ideas que  las rutinarias.'),
(4, '5. En general se percibe que en  la universidad se aceptan  a los cambios.  '),
(5, '1. En la universidad conocemos a los compañeros que trabajan en otras unidades organizativas.'),
(5, '2. Los compañeros de trabajo nos conocemos bien, y comprendemos que esto es importante para nuestras relaciones humanas.'),
(5, '3. La competencia entre los empleados es leal, se potencia el trabajo y los logros del equipo.'),
(5, '4. En la universidad  hay  trabajo en equipos lo que evita la manipulación.'),
(5, '5. El ambiente de trabajo se siente cordial y amigable. En verdad  hay armonía.'),
(6, '1. En la unidad hay reuniones de equipo para resolver los problemas entre todos.'),
(6, '2. Nosotros trabajamos muy bien con otros equipos, esto nos ayuda a todos a ser más efectivos.'),
(6, '3. En la universidad, los equipos y departamentos tienden a colaborar bastante.'),
(6, '4. Las unidades organizativas de la universdiad  trabajamos unidos, buscando siempre el cumplimiento de nuestra visión y misión.'),
(6, '5. En la universidad uno se siente acompañado y apoyado, especialmente cuando hay problemas.'),
(7, '1. En la universidad  se tienen estándares de desempeño para todos los puestos de trabajo.'),
(7, '2. En la universidad se sabe la productividad de cada empleado.'),
(7, '3. A los empleados  se les explica como se les va a calificar su trabajo.'),
(7, '4. En la unidad hay que hacer  reportes del trabajo a los jefes'),
(7, '5. Trabajamos en una organización en donde  hay cultura de medición'),
(8, '1. La gente dice lo que piensa sin temor'),
(8, '2. Los empleados son valorados y  premiados por su participación crítica'),
(8, '3. Las diferencias entre los miembros del equipo  se manejan adecuadamente.'),
(8, '4. En las reuniones de trabajo los problemas dificiles se discuten objetivamente y con respeto hacia todos los miembros.'),
(8, '5. Los desacuerdos entre los miembros del equipo  a menudo son solucionados'),
(9, '1. Lo que cada empleado quiere lograr para sí mismo  se relaciona con lo que la universidad quiere lograr'),
(9, '2. La mayoría de los miembros sienten que los fines de la universidad sí valen la pena'),
(9, '3. Yo siento mucho deseo de pertenecer al equipo'),
(9, '4. Los miembros del equipo se dedican al logro de metas organizacionales'),
(9, '5. Sería justo decir que el equipo  trabaja con una visión y  guías estratégicas claras'),
(10, '1. En la universidad nos  gusta el trabajo, por que lo consideramos interesente.'),
(10, '2. Siempre esta claro que es lo que uno tiene que hacer primero, por ser lo más importante.'),
(10, '3. Para desarrollar el trabajo  contamos  con los recursos necesarios.'),
(10, '4. Consideramos que el trabajo que hacemos es fuente de satisfacción.'),
(10, '5. En general, me siento muy satisfecho con lo que hago.'),
(11, '1. Cada jefe es responsable del trabajo de su propio departamento, sin embargo, comparten con sus colegas a fin de tener mejores perspectivas.'),
(11, '2. Los jefes  dan  entrenamiento al personal a su cargo.'),
(11, '3. Nuestros jefes  son francos, directos, abiertos y  escuchan nuestras inquietudes o problemas.'),
(11, '4. Los jefes inspiran confianza para realizar el trabajo sin dificultades.'),
(11, '5. Nuestro jefe representa muy bien al equipo de trabajo, en los niveles superiores.'),
(12, '1. La calidad del servicio que reciben nuestros clientes (internos y externos) es excelente.'),
(12, '2. En nuestra universidad existe una verdadera cultura de servicio al cliente.'),
(12, '3. Los empleados (incluyendo jefes)  ponen a los clientes en primer lugar.'),
(12, '4. En nuestra institución hay una clara orientación al cliente.'),
(12, '5. En la universidad  hacemos un buen manejo de las quejas que presentan los clientes.'),
(13, '1. Nuestro sistema de selección es eficiente, se contrata a gente competente.'),
(13, '2. En la institución se cree  que  a los nuevos empleados se les da los puestos de trabajo de acuerdo a su capacidad y experiencia'),
(13, '3. La universidad tiene un programa de capacitación y actualización permanente.'),
(13, '4. En la universidad se estimula, y se premia a los empleados para que se superen en sus estudios.'),
(13, '5. Existen programas de prevención y seguridad laboral. '),
(14, '1. Las instalaciones  en mi puesto de trabajo son cómodas'),
(14, '2. Generalmente los sanitarios de la empresa se encuentran limpios y en buenas condiciones de uso.'),
(14, '3. Existen áreas apropiadas para que los empleados tomen sus alimentos.'),
(14, '4. En la Utec todas  las unidades  tienen el espacio que realmente necesitan.'),
(14, '5. Las  oficinas de la Utec son agradables en cuanto a su ambientación, aspecto, color, temperatura e iluminación.'),
(15, '1. La empresa posee  un sistema de valores corporativos claros'),
(15, '2. La Utec, posee un proceso de divulgación de sus valores'),
(15, '3. Nuestros superiores ponen en práctica  los  valores de los que hablan.'),
(15, '4. Los valores de  la Utec los considero muy importantes, y conozco  como ponerlos en práctica.'),
(15, '5. En la Utec, el sistema de  valores es considerado por las diferentes unidades organizativas como un todo.'),
(16, '1. En general, la comunicación desde los niveles superiores es clara y continua.'),
(16, '2. Poseemos  canales formales de comunicación para hacer llegar  nuestras ideas hasta el nivel superior.'),
(16, '3. La comunicación entre compañeros es cordial.'),
(16, '4. Cuando mi equipo se reúne, la gente puede decir lo que piensa.'),
(16, '5. Se evitan los chambres y rumores circulando por toda la organización.')

select * from enc_pre_preguntas inner join enc_dim_dimensiones on dim_codigo = pre_coddim

--dropp table enc_opc_opciones
create table enc_opc_opciones(
	opc_codigo int primary key identity(1,1),
	opc_opcion varchar(125),
	opc_codenc  int foreign key references enc_enc_encuesta,
	opc_fecha_creacion datetime default getdate()
)
--select * from enc_opc_opciones
insert into enc_opc_opciones (opc_opcion, opc_codenc) values('TOTALMENTE EN DESACUERDO', 1), ('EN DESACUERDO', 1), ('DE ACUERDO', 1), ('TOTALMENTE DE ACUERDO', 1)

select * from uonline.dbo.pla_emp_empleado

-- dropp table enc_res_respuestas
create table enc_res_respuestas(
	res_codigo int primary key identity(1,1),
	res_codenc int foreign key references enc_enc_encuesta,
	res_codemp int /*foreign key references uonline.dbo.pla_emp_empleado*/,
	res_fecha_creacion datetime default getdate(),
	res_contador int default 1
)
-- select * from enc_res_respuestas
select * from cal_calendario where cal_AnioNum = 2016

select * from enc_res_respuestas
inner join enc_detres_detalle_respuestas on detres_codres = res_codigo
select * from pla_emp_empleado where emp_codigo in(1416, 58, 1484)
select emp_codafp,* from uonline.dbo.pla_emp_empleado where emp_codigo in(215, 1484)

select *,  (select emp_nombres from pla_emp_empleado as emp where emp.emp_codigo = res_codemp) from enc_res_respuestas inner join pla_emp_empleado on emp_codigo = res_codemp order by res_codigo asc
-- select * from enc_res_respuestas inner join uonline.dbo.pla_emp_empleado on emp_codigo = res_codemp order by res_codigo desc
-- select * from enc_detres_detalle_respuestas 
-- select * from enc_res_respuestas inner join pla_emp_empleado on emp_codigo = res_codemp order by res_codigo desc
select * from uonline.dbo.pla_emp_empleado where emp_codigo = 58

select * from pla_emp_empleado
inner join enc_res_respuestas on emp_codigo = res_codemp 
inner join enc_enc_encuesta on enc_codigo = res_codenc
inner join esci_estado_civil on emp_codesci = esci_id
inner join esem_estado_empleado on esem_id = emp_codesem
inner join gen_genero on gen_id = emp_codgen
inner join plz_plaza on plz_codigo = emp_codplz
inner join pue_puesto on pue_codigo = plz_codpue
--inner join tit_titulo on tit_codigo = emp_codtit
--inner join tti_tipo_titulo on tti_codigo = tit__codtti
inner join uni_unidad on uni_codigo = plz_coduni
inner join afp on afp_id = emp_codafp
inner join mun_municipios on mun_codigo = emp_codmun
inner join dep_departamento on dep_codigo = mun_coddep
inner join pai_pais on pai_codigo = dep_codpai
inner join fc_firmo_contrato on fc_id = emp_firmo_contrato
inner join grac_grado_academico on grac_id = emp_codgrac
inner join ic_imparte_clase on ic_id = emp_imparte_clase
inner join tpc_tipo_contrato on tpc_codigo = emp_codtpc
inner join tpl_tipo_planilla on tpl_codigo = emp_codtpl
inner join enc_detres_detalle_respuestas on detres_codres = res_codigo
order by res_codigo

select emp_codigo, emp_primer_nom, emp_primer_ape, emp_fecha_nac, emp_fecha_ingreso, emp_salario, emp_codplz, emp_sexo, emp_salario_inicial, emp_perfil_profesional, emp_codmun, emp_est_civil, emp_codtpl, emp_tipo_cuenta, emp_estado, emp_codafp, emp_codtit, emp_firma_contrato, emp_gacademico, emp_imparte_clase from uonline.dbo.pla_emp_empleado where emp_codigo = 268

select *--emp_nombres, emp_, emp_apellidos, dim_nombre, pre_pregunta, opc_opcion, res_fecha_creacion, plz_descripcion, uni_descripcion
from enc_res_respuestas 
inner join pla_emp_empleado on emp_codigo = res_codemp --and emp_codigo in( 374, 740, 3318)
inner join enc_detres_detalle_respuestas on detres_codres = res_codigo
inner join enc_pre_preguntas on pre_codigo = detres_codpre
inner join enc_opc_opciones on opc_codigo = detres_codopc
inner join enc_dim_dimensiones on dim_codigo = pre_coddim
inner join plz_plaza on plz_codigo = emp_codplz
inner join uni_unidad on uni_codigo = plz_coduni and uni_codigo = 13
and res_codigo = 124

--dropp table enc_detres_detalle_respuestas
create table enc_detres_detalle_respuestas(
	detres_codigo int primary key identity(1,1),
	detres_codres int foreign key references enc_res_respuestas,
	detres_codpre int foreign key references enc_pre_preguntas,
	detres_codopc int foreign key references enc_opc_opciones,
	detres_contador int default 1
)
go

-- select * from enc_detres_detalle_respuestas
select t.enc 'encuestas', t.res 'respuestas', round(cast(t.res as real)/cast(t.enc as real),2) 'razon' from (select (select count(1) from enc_res_respuestas) 'enc', (select count(1) from enc_detres_detalle_respuestas) 'res') as t
select * from enc_res_respuestas  inner join uonline.dbo.pla_emp_empleado on emp_codigo = res_codemp where res_codigo not in (select detres_codres from enc_detres_detalle_respuestas)
select * from enc_detres_detalle_respuestas inner join enc_res_respuestas on res_codigo = detres_codres and detres_codres = 1220
select * from enc_res_respuestas where res_codemp = 9
-- deletee enc_res_respuestas where res_codigo = 1201
-- deletee enc_detres_detalle_respuestas where detres_codres = 1201

alter procedure sp_rrhh_enc_encuesta_clima_organizacional
	--sp_rrhh_enc_encuesta_clima_organizacional 1, 1, 0 --Grupos de la encuesta
	--sp_rrhh_enc_encuesta_clima_organizacional 2, 1, 1 --Preguntas de la encuesta
	--sp_rrhh_enc_encuesta_clima_organizacional 3, 1, 0 --Opciones de respuesta de la encuesta
	--sp_rrhh_enc_encuesta_clima_organizacional 6, 1, 0 --Correos 
	@opcion int = 0,
	@codenc int = 0,
	@coddim int = 0,
	@codemp int = 0,

	@codres int = 0,
	@codpre int = 0,
	@codopc int = 0
as
begin
	if @opcion = 1 --Devuelve las dimensiones de la encuesta segun @codenc
	begin
		select dim_codigo, dim_nombre, dim_descripcion
		from enc_dim_dimensiones
		inner join enc_enc_encuesta on enc_codigo = dim_codenc
		where enc_codigo = @codenc
	end

	if @opcion = 2 --Devuelve las preguntas de la encuesta segun el @coddim
	begin
		select dim_codigo, dim_nombre, dim_descripcion, pre_codigo, pre_pregunta 
		from enc_pre_preguntas 
		inner join enc_dim_dimensiones on dim_codigo = pre_coddim 
		inner join enc_enc_encuesta on enc_codigo = dim_codenc
		where dim_codigo = @coddim
	end

	if @opcion = 3 --Devuelve las opciones pregunta de la encuesta @codenc
	begin
		select opc_codigo, opc_opcion from enc_opc_opciones
		inner join enc_enc_encuesta on enc_codigo = opc_codenc
		where enc_codigo = @codenc
	end

	if @opcion = 4 --Inserta el registro del encabezado(enc_res_respuestas) de la @codenc en el año
	begin
		if not exists(select 1 from enc_res_respuestas where res_codemp = @codemp and res_codenc = @codenc and year(res_fecha_creacion) = year(getdate()))
		begin
			insert into enc_res_respuestas (res_codenc, res_codemp) values (@codenc, @codemp)
			select scope_identity() 'res'
		end
		else 
			select -1 'res' --Ya hay un registro de la encuesta para el empleado @codemp
	end--if @opcion = 4
	
	if @opcion = 5 --Inserta el registro del detalle(enc_res_respuestas) de la @codenc
	begin
		insert into enc_detres_detalle_respuestas (detres_codres, detres_codpre, detres_codopc) 
		values (@codres, @codpre, @codopc)
		select @@identity 'res'
	end--if @opcion = 5

	if @opcion = 6--Devuelve los correos de los empleados que se les enviara el correo de la evaluacion clima labora
	begin
		/*select emp_codigo,emp_email_empresarial 'a', emp_apellidos_nombres, 'juan.aguilar@utec.edu.sv' 'de' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4289) union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'salvador.franco@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4289) union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'juan.campos@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4289) union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'dany.chacon@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4289) union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'guillermo.jimenez@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4289) union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'maria.mercado@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4290) union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'karen.hernandez@mail.utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4291) union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'mirna.rosa@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4290) union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'rosa.rodriguez@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4291) union

		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'candida.velasco@utec.edu.sv' 'de' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4290) union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'carlos.rivas@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4290) union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres ,'mario.miranda@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4072) union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'nazario.mariona@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4072)union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'ana.rivera@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4072)  union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'isidro.romero@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4072) union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'fatima.argueta@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4072) union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'manuel.rodriguez@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4072) union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'jenny.sanchez@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4072) union

		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'rebeca.martinez@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4291) union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'ernesto.canas@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4291) union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'christopher.flores@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4291) union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'josue.flores@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4252) union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'shelly.torres@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4252)union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'cesar.najarro@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4252) union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'oscar.pineda@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4252) union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'rafael.loucel@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4252) union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'griselda.aparicio@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4290) union

		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'fredy.pineda@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4252)union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'miriam.martinez@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4252)union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'mloucelduque7@gmail.com' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4252)union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'clara.mejia@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(3724)union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'guillermo.hasbun@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(3724)union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'juan.cerna@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(3724)union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'tania.hernandez@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(3724)union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'adriana.baires@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(3724)union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'rossy.quezada@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(3724)union

		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'cloucel@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4252)union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'carlos.pineda@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4252)union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'william.colocho@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4252)union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'claudia.zuniga@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4252)union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'juan.montano@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4252)union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'claudia.zuniga@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4252)union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'daniel.ramirez@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4252)union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'claudia.gomez@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4252)union
		select emp_codigo,emp_email_empresarial, emp_apellidos_nombres, 'krissia.canas@utec.edu.sv' from uonline.dbo.pla_emp_empleado as emp where emp.emp_estado = 'A' and emp_codigo IN(4252)*/
		--select * from uonline.dbo.pla_uni_unidad 
		
		--Se excluirán al personal ejecutivo siguiente
		----2 Dr. José Mauricio Loucel
		----181 Lic. José Mauricio Loucel Funes
		----207 Lic. Carlos Reynaldo López Nuila
		----184 Ing. Nelson Zárate Sánchez
		----202 Lic. Rafael Rodríguez Loucel
		----4 Dr. José Enrique Burgos Martínez
		----199 Ing. José Adolfo Araujo Romagoza
		--Se excluirán al personal que no cumple con el mínimo de 6 meses de laborar en la universidad
		----4375 Ing. Willian Alexis Palacios
		----4373 Licda. Claribel América Batres Rivas
		----4352 Téc. Henry Adalberto Pinto Cristino
		----4362 Ing. Manuel Antonio Mendieta López
		----4363 Téc. Gerson Josué Amaya Ponce
		----4345 Srita. Gabriela Yasmin Guzmán Escamilla
		----24 Licda. Silvia Elena Regalado Blanco
		----4297 Lic. René Armando Sigüenza
		----4326 Licda. Soledad Irene Barillas
		----4329 Srita. Xenia Elvira Quiteño
		----4340 Sr. Kevin Bryan Rosa Beltrán
		----4344 Sr. Josué Flores Carias 
		-- ultimo 374	A	celeste.jaen@utec.edu.sv	JAEN DE  RUIZ CELESTE 	AREA DE PROCESOS INDUSTRIALES
		select * from(
		select row_number() over(order by emp_codigo asc) n, emp_codigo, emp.emp_estado,
		--ltrim(rtrim((case  when isnull(emp_email_empresarial, '0') <> '0' then emp_email_empresarial  when emp_email_empresarial = '' then emp_email_institucional else emp_email_empresarial end))) as
		emp_email_empresarial as 
		emp_email, 
		emp_apellidos_nombres, uni_nombre
		from uonline.dbo.pla_emp_empleado as emp
		inner join uonline.dbo.pla_plz_plaza on plz_codigo = emp.emp_codplz
		inner join uonline.dbo.pla_uni_unidad on uni_codigo = plz_coduni
		inner join uonline.dbo.pla_pue_puesto on pue_codigo = plz_codpue
		where emp.emp_estado in( 'A', 'J') 
		and emp_email_empresarial like '%@utec.edu.s%'
		--and emp_fecha_ingreso <= '2019-02-16'
		and emp_codigo not in(2,181,207,184,202 ,4,199,4375,4373,4352,4362,4363,4345, 24, 4297,4326, 4329, 4340, 4344)
		and emp_codigo not in (select res_codemp from enc_res_respuestas)
		and emp_codigo = 4116
		--and emp_codigo in(4291, 4290, 4289)
		--and pue_codigo <> 68
		--and uni_codigo = 13
		--order by emp_codigo asc
		)t 
		--where t.n >119 and t.n < 180

		--guadalupe marisol
		--nelson ivan saldaña

		-- and datediff(day, emp_fecha_ingreso, getdate()) > 180
		-- and emp_codigo in(4291 , 4205)
		-- and (isnull(emp_email_empresarial, '0') = '0' or emp_email_empresarial = '')  
		-- and emp_codigo IN(2402/*3367,3496,2171,3067*/)

		--select emp_email_empresarial, emp_email, emp_email_institucional, * from uonline.dbo.pla_emp_empleado where emp_codigo = 26
		/*select * from uonline.dbo.pla_emp_empleado where emp_apellidos_nombres like '%avila%'

		select * from uonline.dbo.pla_uni_unidad
		select emp_salario, emp_codigo, emp_apellidos_nombres, plz_codigo,plz_nombre, uni_codigo, uni_nombre, emp_codtit, emp_email_empresarial, emp_email_institucional, * from uonline.dbo.pla_emp_empleado 
		inner join uonline.dbo.pla_plz_plaza on plz_codigo = emp_codplz
		inner join uonline.dbo.pla_uni_unidad on uni_codigo = plz_coduni
		where uni_codigo = 13 and emp_estado = 'A'*/

		/*

		select emp_codigo, emp_apellidos_nombres, emp_salario, plz_codigo,plz_nombre, uni_codigo, uni_nombre, emp_codtit, emp_email_empresarial, emp_email_institucional 
		from uonline.dbo.pla_emp_empleado 
		inner join uonline.dbo.pla_plz_plaza on plz_codigo = emp_codplz
		inner join uonline.dbo.pla_uni_unidad on uni_codigo = plz_coduni
		where uni_codigo = 13 and emp_estado = 'A'-- emp_codigo = 4291 */

		--select * from uonline.dbo.pla_plz_plaza where plz_codigo = 4290
		--select * from uonline.dbo.pla_tit_titulo where uni_nombre like '%infor%' uni_codigo = 13
		--select * from uonline.dbo.pla_pue_puesto where uni_nombre like '%infor%' uni_codigo = 13
		/*select * from uonline.dbo.pla_uni_unidad where uni_codigo = 13

select plz_codigo, plz_nombre, plz_codpue, plz_coduni, 
isnull(plz_padre,'') plz_padre, isnull(plz_cen_costo,'') plz_cen_costo 
from uonline.dbo.pla_plz_plaza where plz_codigo = (select emp_codplz from uonline.dbo.pla_emp_empleado where emp_codigo=4290)

SELECT [uni_codigo], [uni_nombre] FROM uonline.dbo.pla_uni_unidad ORDER BY [uni_nombre]*/

	end

	if @opcion = 7--REALIZA EL LLENADO DE LAS TABLAS DESDE UONLINE HASTA BD_RRHH
	begin
		SELECT 0
	end
end

SELECT * from uni_unidad
select uni_descripcion, * from pla_emp_empleado 
inner join plz_plaza on plz_codigo = emp_codplz
inner join uni_unidad on uni_codigo = plz_coduni
where emp_codigo = 3542
---*******DESDE AQUI SE EMPIEZA A DEFINIR LAS TABLAS PARA EL DIAGRAMA DE VIRGILIO*******---

--dropp table gen_genero
create table gen_genero(
	gen_id int identity(1,1),
	gen_codigo varchar(2) primary key,
	gen_descripcion varchar(10)
)
--select * from gen_genero
insert into gen_genero (gen_codigo, gen_descripcion)
select distinct emp_sexo, case emp_sexo when 'F' then 'Femenino' else 'Masculino' end 'desc' from uonline.dbo.pla_emp_empleado 

--dropp table esci_estado_civil
create table esci_estado_civil(
	esci_id int  identity(1,1),
	esci_codigo varchar(2)  primary key,
	esci_descripcion varchar(40)
)
--select * from esci_estado_civil
insert into esci_estado_civil(esci_codigo, esci_descripcion) 
select distinct emp_est_civil ,case emp_est_civil when 'A' then 'Acompañado' when 'S' then 'Soltero' when 'D' then 'Divorciado' when 'C' then 'Casado' when 'V' then 'Viudo' end from uonline.dbo.pla_emp_empleado

--dropp table pai_pais
create table pai_pais(
	pai_codigo int primary key identity(1,1),
	pai_descripcion varchar(40)
)
--select * from pai_pais

--dropp table dep_departamento
create table dep_departamento(
	dep_codigo int ,  
	dep_descripcion varchar(40),
	dep_codpai int
)
--select * from dep_departamento

--dropp table mun_municipios
create table mun_municipios(
	mun_codigo int primary key identity(1,1),
	mun_descripcion varchar(150),
	mun_coddep int 
)
--select * from mun_municipios

--dropp table uni_unidad
create table uni_unidad(
	uni_codigo int,
	uni_descripcion varchar(50)
)
--select * from uni_unidad

--dropp table plz_plaza
create table plz_plaza(
	pla_codigo int ,
	pla_descripcion varchar(50),
	pla_coduni int,
	pla_codpue int
)
--select * from plz_plaza

--dropp table pla_emp_empleado
create table pla_emp_empleado(
    emp_codigo int,
    emp_nombres varchar(40),
    emp_apeliidos varchar(40),
    emp_fecha_nacimiento datetime, 
    emp_fecha_ingreso datetime,
    emp_salario real, 
    emp_codplz int,
	emp_codgen varchar(2),
	emp_salario_inicial real,
	emp_perfil real,
	emp_codmun int,
	emp_codesci nvarchar(2),
	emp_codtpl int,
	emp_codtpc int,
	emp_codesem nvarchar(2),
	emp_codafp int
)
--select * from pla_emp_empleado

--dropp table 
create table tpl_tipo_planilla(
	tpl_codigo int,
	tpl_descripcion nvarchar(50)
)
--select * from 

--dropp table 
create table tpc_tipo_contrato(
    tpc_codigo int,
    tpc_descripcion nvarchar(50)
)
--select * from 

--dropp table esem_estado_empleado
create table esem_estado_empleado(
	esem_id int identity(1,1),
	esem_estado nvarchar(2) primary key,
	esem_descripcion nvarchar(25)
)
--select * from esem_estado_empleado

--dropp table afp
create table afp(
	afp_id int identity(1,1),
	afp_codigo int primary key,
	afp_descripcion nvarchar(25),
	afp_abreviatura nvarchar(5)
)
--select * from afp
insert into afp (afp_codigo, afp_descripcion, afp_abreviatura) values (0, 'No aplica', 'N/A')

--dropp table tit_titulo
create table tit_titulo(
	tit_codigo int primary key,
	tit_descripcion nvarchar(50),
	tit__codtti int
)
--select * from tit_titulo

--dropp table tti_tipo_titulo
create table tti_tipo_titulo(
	tti_codigo int primary key,
	tti_descripcion nvarchar(50),
	tti_abreviatura nvarchar(5)
)
--select * from tti_tipo_titulo

--dropp table grac_grado_academico
create table grac_grado_academico(
    grac_id int identity(1,1),
    grac_codigo nvarchar(2) primary key,
    grac_descripcion nvarchar(50),
    grac_abreviatura nvarchar(5)
)
--select * from grac_grado_academico

--dropp table ic_imparte_clase
create table ic_imparte_clase(
    ic_id int identity (1,1),
    ic_codigo nvarchar(2),
    ic_descripcion nvarchar(15)
)
--select * from ic_imparte_clase

--dropp table fc_firmo_contrato
create table fc_firmo_contrato
(
       fc_id int identity (1,1),
       fc_codigo nvarchar(2),
       fc_descripcion nvarchar(15)
)
--select * from fc_firmo_contrato

--dropp table pue_puesto
create table pue_puesto(
	pue_codigo int primary key,
	pue_descripcion nvarchar(200)
)
--select * from pue_puesto