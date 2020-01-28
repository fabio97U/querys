--create table dep_departamentos (dep_codigo int primary key identity (1, 1), dep_departamento varchar(125))
--insert into dep_departamentos (dep_departamento) values ('Ahuachap�n'), ('Santa Ana'), ('Sonsonate'), ('Chalatenango'), ('Cuscatl�n'), ('San Salvador'), ('Libertad'), ('San Vicente'), ('Caba�as'), ('La Paz'), ('Usulut�n'), ('San Miguel'), ('Moraz�n'), ('La Uni�n')

--create table mun_municipios(mun_codigo int primary key identity (1, 1), mun_coddep int foreign key references dep_departamentos, mun_municipios varchar(125))
--insert into mun_municipios (mun_coddep, mun_municipios) values (1, 'Ahuachap�n'), (1, 'Apaneca'), (1, 'Atiquizaya'), (1, 'Concepci�n de Ataco'), (1, 'El Refugio'), (1, 'Guaymango'), (1, 'Jujutla'), (1, 'San Francisco Men�ndez'), (1, 'San Lorenzo'), (1, 'San Pedro Puxtla'), (1, 'Tacuba'), (1, 'Tur�n'), (2, 'Candelaria de la Frontera'), (2, 'Chalchuapa'), (2, 'Coatepeque'), (2, 'El Congo'), (2, 'El Porvenir'), (2, 'Masahuat'), (2, 'Metap�n'), (2, 'San Antonio Pajonal'), (2, 'San Sebasti�n Salitrillo'), (2, 'Santa Ana'), (2, 'Santa Rosa Guachipil�n'), (2, 'Santiago de la Frontera'), (2, 'Texistepeque'), (3, 'Acajutla'), (3, 'Armenia'), (3, 'Caluco'), (3, 'Cuisnahuat'), (3, 'Izalco'), (3, 'Juay�a'), (3, 'Nahuizalco'),(3, 'Nahulingo'), (3, 'Salcoatit�n'), (3, 'San Antonio del Monte'), (3, 'San Juli�n'), (3, 'Santa Catarina Masahuat'), (3, 'Santa Isabel Ishuat�n'), (3, 'Santo Domingo Guzm�n'), (3, 'Sonsonate'), (3, 'Sonzacate'), (4, 'Agua Caliente'), (4, 'Arcatao'), (4, 'Azacualpa'), (4, 'Chalatenango (ciudad)'), (4, 'Comalapa'), (4, 'Cital�'), (4, 'Concepci�n Quezaltepeque'), (4, 'Dulce Nombre de Mar�a'), (4, 'El Carrizal'), (4, 'El Para�so'), (4, 'La Laguna'), (4, 'La Palma'), (4, 'La Reina'), (4, 'Las Vueltas'), (4, 'Nueva Concepci�n'), (4, 'Nueva Trinidad'), (4, 'Nombre de Jes�s'), (4, 'Ojos de Agua'), (4, 'Potonico'), (4, 'San Antonio de la Cruz'), (4, 'San Antonio Los Ranchos'), (4, 'San Fernando'), (4, 'San Francisco Lempa'), (4, 'San Francisco Moraz�n'), (4, 'San Ignacio'), (4, 'San Isidro Labrador'), (4, 'San Jos� Cancasque'), (4, 'San Jos� Las Flores'), (4, 'San Luis del Carmen'), (4, 'San Miguel de Mercedes'), (4, 'San Rafael'), (4, 'Santa Rita'), (4, 'Tejutla'), (5, 'Candelaria'), (5, 'Cojutepeque'), (5, 'El Carmen'), (5, 'El Rosario'), (5, 'Monte San Juan'), (5, 'Oratorio de Concepci�n'), (5, 'San Bartolom� Perulap�a'), (5, 'San Crist�bal'), (5, 'San Jos� Guayabal'), (5, 'San Pedro Perulap�n'), (5, 'San Rafael Cedros'), (5, 'San Ram�n'), (5, 'Santa Cruz Analquito'), (5, 'Santa Cruz Michapa'), (5, 'Suchitoto'), (5, 'Tenancingo'), (6, 'Aguilares'), (6, 'Apopa'), (6, 'Ayutuxtepeque'), (6, 'Cuscatancingo'), (6, 'Ciudad Delgado'), (6, 'El Paisnal'), (6, 'Guazapa'), (6, 'Ilopango'), (6, 'Mejicanos'), (6, 'Nejapa'), (6, 'Panchimalco'), (6, 'Rosario de Mora'), (6, 'San Marcos'), (6, 'San Mart�n'), (6, 'San Salvador'), (6, 'Santiago Texacuangos'), (6, 'Santo Tom�s'), (6, 'Soyapango'), (6, 'Tonacatepeque'), (7, 'Antiguo Cuscatl�n'), (7, 'Chiltiup�n'), (7, 'Ciudad Arce'), (7, 'Col�n'), (7, 'Comasagua'), (7, 'Huiz�car'), (7, 'Jayaque'), (7, 'Jicalapa'), (7, 'La Libertad'), (7, 'Nueva San Salvador (Santa Tecla)'), (7, 'Nuevo Cuscatl�n'), (7, 'San Juan Opico'), (7, 'Quezaltepeque'), (7, 'Sacacoyo'), (7, 'San Jos� Villanueva'), (7, 'San Mat�as'), (7, 'San Pablo Tacachico'), (7, 'Talnique'), (7, 'Tamanique'), (7, 'Teotepeque'), (7, 'Tepecoyo'), (7, 'Zaragoza'), (8, 'Apastepeque'), (8, 'Guadalupe'), (8, 'San Cayetano Istepeque'), (8, 'San Esteban Catarina'), (8, 'San Ildefonso'), (8, 'San Lorenzo'), (8, 'San Sebasti�n'), (8, 'San Vicente'), (8, 'Santa Clara'), (8, 'Santo Domingo'), (8, 'Tecoluca'), (8, 'Tepetit�n'), (8, 'Verapaz'), (9, 'Cinquera'), (9, 'Dolores'), (9, 'Guacotecti'), (9, 'Ilobasco'), (9, 'Jutiapa'), (9, 'San Isidro'), (9, 'Sensuntepeque'), (9, 'Tejutepeque'), (9, 'Victoria'), (10, 'Cuyultit�n'), (10, 'El Rosario'), (10, 'Jerusal�n'), (10, 'Mercedes La Ceiba'), (10, 'Olocuilta'), (10, 'Para�so de Osorio'), (10, 'San Antonio Masahuat'), (10, 'San Emigdio'), (10, 'San Francisco Chinameca'), (10, 'San Juan Nonualco'), (10, 'San Juan Talpa'), (10, 'San Juan Tepezontes'), (10, 'San Luis Talpa'), (10, 'San Luis La Herradura'), (10, 'San Miguel Tepezontes'), (10, 'San Pedro Masahuat'), (10, 'San Pedro Nonualco'), (10, 'San Rafael Obrajuelo'), (10, 'Santa Mar�a Ostuma'), (10, 'Santiago Nonualco'), (10, 'Tapalhuaca'), (10, 'Zacatecoluca'), (11, 'Alegr�a'), (11, 'Berl�n'), (11, 'California'), (11, 'Concepci�n Batres'), (11, 'El Triunfo'), (11, 'Ereguayqu�n'), (11, 'Estanzuelas'), (11, 'Jiquilisco'), (11, 'Jucuapa'), (11, 'Jucuar�n'), (11, 'Mercedes Uma�a'), (11, 'Nueva Granada'), (11, 'Ozatl�n'), (11, 'Puerto El Triunfo'), (11, 'San Agust�n'), (11, 'San Buenaventura'), (11, 'San Dionisio'), (11, 'San Francisco Javier'), (11, 'Santa Elena'), (11, 'Santa Mar�a'), (11, 'Santiago de Mar�a'), (11, 'Tecap�n'), (11, 'Usulut�n'), (12, 'Carolina'), (12, 'Chapeltique'), (12, 'Chinameca'), (12, 'Chirilagua'), (12, 'Ciudad Barrios'), (12, 'Comacar�n'), (12, 'El Tr�nsito'), (12, 'Lolotique'), (12, 'Moncagua'), (12, 'Nueva Guadalupe'), (12, 'Nuevo Ed�n de San Juan'), (12, 'Quelepa'), (12, 'San Antonio del Mosco'), (12, 'San Gerardo'), (12, 'San Jorge'), (12, 'San Luis de la Reina'), (12, 'San Miguel'), (12, 'San Rafael Oriente'), (12, 'Sesori'), (12, 'Uluazapa'), (13, 'Arambala'), (13, 'Cacaopera'), (13, 'Chilanga'), (13, 'Corinto'), (13, 'Delicias de Concepci�n'), (13, 'El Divisadero'), (13, 'El Rosario'), (13, 'Gualococti'), (13, 'Guatajiagua'), (13, 'Joateca'), (13, 'Jocoaitique'), (13, 'Jocoro'), (13, 'Lolotiquillo'), (13, 'Meanguera'), (13, 'Osicala'), (13, 'Perqu�n'), (13, 'San Carlos'), (13, 'San Fernando'), (13, 'San Francisco Gotera'), (13, 'San Isidro'), (13, 'San Sim�n'), (13, 'Sensembra'), (13, 'Sociedad'), (13, 'Torola'), (13, 'Yamabal'), (13, 'Yoloaiqu�n'), (14, 'Anamor�s'), (14, 'Bolivar'), (14, 'Concepci�n de Oriente'), (14, 'Conchagua'), (14, 'El Carmen'), (14, 'El Sauce'), (14, 'Intipuc�'), (14, 'La Uni�n'), (14, 'Lislique'), (14, 'Meanguera del Golfo'), (14, 'Nueva Esparta'), (14, 'Pasaquina'), (14, 'Polor�s'), (14, 'San Alejo'), (14, 'San Jos�'), (14, 'Santa Rosa de Lima'), (14, 'Yayantique'), (14, 'Yucuaiqu�n')

--create table ciops_enc_encuestas (enc_codigo int primary key identity (1, 1), enc_nombre varchar(255), enc_fecha_campo date, enc_fecha_creacion datetime default getdate())
--insert into ciops_enc_encuestas  (enc_nombre, enc_fecha_campo) values ('Encuesta de Opini�n P�blica RUNNERS2019', '2019-10-23')

-- drop table ciops_pre_preguntas
create table ciops_pre_preguntas (
	pre_codigo int primary key identity (1, 1), --Codigo unico de la pregunta en la BD
	pre_identificar_encuesta varchar(55), --Codigo unico de la pregunta en la BD pero segun la encuesta, eje: pueden haber muchos "pre_identificar_encuesta" = 1, ya que representa la primera pregunta de la encuesta
	pre_pregunta varchar(1024), --Texto de la pregunta
	pre_codenc int foreign key references ciops_enc_encuestas, --Indica a cual encuesta se alimentara con la pregunta
	pre_fecha_creacion datetime default getdate()--Fecha y hora de creacion de la pregunta
)
-- select * from ciops_pre_preguntas
insert into ciops_pre_preguntas (pre_identificar_encuesta, pre_pregunta, pre_codenc) values
('1', 'DEPARTAMENTO:', 1), 
('1_1', 'MUNICIPIO QUE RESIDE:', 1), 
('2', 'G�NERO:', 1), 
('3', 'ESTADO CIVIL:', 1), 
('4', '�CU�L ES SU GRADO DE ESCOLARIDAD?', 1), 
('5', '�Cu�l es su edad cumplida?', 1), 
('6', '�Cu�l es su ocupaci�n actual?', 1), 
('6_1', 'SI CONTEST� EMPLEADO, �En qu� sector trabaja?', 1), 
('6_2', '�Qu� posici�n desempe�a dentro de la empresa?', 1), 
('7', '�Cu�l es el ingreso promedio mensual en su familia? (Incluyen los ingresos por labores y remesas)', 1), 
('8', '�Posee veh�culo?', 1), 
('8_1', 'Si su respuesta es s�, �Cu�l es el a�o de su veh�culo?', 1), 
('9', '�Tiene empleada dom�stica?', 1), 
('10', '�Tiene hijos?', 1), 
('10_1', 'Si contest� s�, �Cu�ntos hijos tiene?', 1), 
('11', '�Con qu� frecuencia acostumbra comer fuera de casa en restaurantes de comida r�pida?', 1), 
('12', '�Con qu� frecuencia acostumbra comer fuera de casa en restaurantes a la carta?', 1), 
('13_1', '�Qui�n es su proveedor en los siguientes servicios (Cable)?', 1), 
('13_2', '�Qui�n es su proveedor en los siguientes servicios (Internet)?', 1), 
('13_3', '�Qui�n es su proveedor en los siguientes servicios (Telefon�a fija)?', 1), 
('13_4', '�Qui�n es su proveedor en los siguientes servicios (Telefon�a Celular)?', 1), 
('14', '�Qu� redes sociales utiliza con m�s frecuencia? (NIVEL DE MEMORIA, 3 OPCIONES)', 1), 
('15', 'Cuando realiza b�squedas en internet; �Cu�l motor de b�squeda utiliza principalmente? (NIVEL DE MEMORIA)', 1), 
('16', '�Usted realiza compras por internet?', 1), 
('16_1', 'Si su respuesta es s�, �Qu� tipo de art�culo ha comprado?', 1), 
('17', 'De las siguientes razones, �Cu�les son las 2 m�s importantes que le impulsaron a iniciar la pr�ctica de este deporte?', 1), 
('18', '�Cu�nto tiempo lleva practicando este deporte?', 1), 
('19', '�Con qu� frecuencia practica este deporte?', 1), 
('20', '�Qu� ambiente prefiere al momento de realizar este deporte?', 1), 
('21', '�Cu�ntos kil�metros en promedio corre al d�a?', 1), 
('22', '�Con qui�n acostumbra a practicar este deporte?', 1), 
('22_1', 'Si contest� la opci�n grupo deportivo, �Cu�l es el nombre del grupo con el que realiza este deporte? (Nivel de memoria)', 1), 
('23_1', '�Cu�l es el Departamento y municipio a donde acostumbra correr (Departamento)?', 1), 
('23_2', '�Cu�l es el Departamento y municipio a donde acostumbra correr (municipio)?', 1), 
('24', '�En qu� momento del d�a prefiere salir a correr?', 1), 
('25', '�Qu� tipo de bebida prefiere para hidratarse?', 1), 
('25_1', '�Qu� tipo de bebida isot�nica prefiere para hidratarse?', 1), 
('25_2', '�Cu�l es el lugar en el que adquiere con mayor frecuencia este hidratante?', 1), 
('25_3', '�Cu�l es la ubicaci�n de este lugar?', 1), 
('26', '�Qu� marca de ropa deportiva es la que prefiere?', 1), 
('26_1', '�Cu�nto gasta al a�o en ropa deportiva?', 1), 
('26_2', '�En qu� lugar adquiere con mayor frecuencia la ropa deportiva?', 1), 
('26_3', 'Si respondi� 2. Almac�n, mencione cu�l', 1), 
('26_4', '�Cu�l es la ubicaci�n de este lugar?', 1), 
('27', '�Cu�l es su marca preferida en zapatos deportivos?', 1), 
('27_1', '�Qu� es lo que busca en un zapato para correr? (Elija las 3 m�s importantes)', 1), 
('27_2', '�Cu�ntos pares de zapatos deportivos, espec�ficamente para correr, compra al a�o?', 1), 
('27_3', '�Cu�nto gasta al a�o en zapatos deportivos?', 1), 
('27_4', '�En qu� lugar adquiere con mayor frecuencia zapatos deportivos?', 1), 
('27_5', 'Si respondi� 2. Almac�n, mencione cu�l', 1), 
('27_6', '�Cu�l es la ubicaci�n de este lugar?', 1), 
('28', '�Utiliza alg�n tipo de accesorios especializados al momento de practicar este deporte?', 1), 
('28_1', 'Si contest� s�, �Qu� tipo de accesorio utiliza?', 1), 
('28_2', '�En qu� lugar adquiere el producto con mayor frecuencia?', 1), 
('28_3', 'Si respondi� 2. Almac�n, mencione cu�l', 1), 
('28_4', '�Cu�l es la ubicaci�n de este lugar?', 1), 
('29', '�Adem�s del running practica otro deporte?', 1), 
('29_1', 'Si contest� s�, �Qu� otro deporte practica?', 1), 
('30', '�En cu�ntas carreras se inscribe en el a�o?', 1), 
('30_1', '�Cu�nto gasta en inscripciones de carreras al a�o?', 1), 
('30_2', '�Cu�l es su distancia preferida para correr en una carrera?', 1), 
('30_3', '�Cu�les son las 3 carreras que m�s le gusta correr? Elija 3 opciones', 1), 
('30_4', '�Por qu� razones la prefiere?', 1), 
('31', '�Toma alg�n suplemento para recuperarse cuando practica el running?', 1), 
('31_1', 'Si responde que s�, �Podr�a mencionarme qu� suplemento toma?', 1), 
('31_2', '�En qu� lugar adquiere con mayor frecuencia �ste suplemento?', 1), 
('31_3', 'Si respondi� 2. Almac�n, mencione cu�l', 1), 
('31_4', '�Cu�l es la ubicaci�n de este lugar?', 1), 
('32', '�Consume alg�n tipo de alimento antes de iniciar la carrera?', 1), 
('32_1_1', 'Si contest� s�, �Qu� tipo de alimento consume?', 1), 
('32_1_2', 'Si contest� s�, �Qu� tipo de alimento consume? (Prote�nas bajas en grasa) DESCARTADA', 1), 
('32_1_3', 'Si contest� s�, �Qu� tipo de alimento consume? (Alimento de Digesti�n R�pida) DESCARTADA', 1), 
('33', '�Ha cambiado sus h�bitos alimenticios por practicar este deporte?', 1), 
('33_1', 'Si contest� s�, �Cu�nto gasta en su nuevo r�gimen alimenticio mensualmente?', 1), 
('34', '�Tiene un r�gimen alimenticio especialmente elaborado por un nutricionista deportivo?', 1), 
('34_1', 'Si contest� S�, �Qu� tipo de dieta tiene?', 1), 
('35', '�Tiene entrenador o una gu�a espec�fica cuando realiza su entrenamiento?', 1), 
('35_1', 'Si contesto S�, �Qu� es?', 1), 
('36', '�Ha sufrido alguna lesi�n durante este a�o por practicar el running?', 1), 
('36_1', 'Si contest� s�, �Qu� tipo de lesi�n ha sufrido?', 1), 
('37', '�Por qu� medios de comunicaci�n se mantiene enterado sobre temas de running?', 1), 
('37_1', 'Si contest� redes sociales, mencione �Cu�les?', 1), 
('38', '�Conoce el programa deportivo Runners 503?', 1), 
('38_1', 'Si contest� s�, �C�mo eval�a la calidad de la programaci�n que Runners 503 le ofrece?', 1), 
('38_2', '�Qu� otra informaci�n le gustar�a que el programa transmitiera?', 1), 
('39', '�Cu�l es la meta personal que desea alcanzar en el running?', 1)

-- drop table ciops_opc_opciones
create table ciops_opc_opciones (
	opc_codigo int primary key identity (1, 1), --Codigo unico de la opcion en la BD
	opc_opcion varchar(1024), --Texto de la opcion
	--AQUI NO SE NECESITA UN CAMPO "pre_identificar_encuesta" como en la preguntas, ya que todos los valores de la opciones se manejan internamente
	opc_codenc int foreign key references ciops_enc_encuestas, --Representa a que encuesta se alimentara con la opcion
	opc_fecha_creacion datetime default getdate()--Fecha y hora de creacion de la opcion
)
-- select * from ciops_opc_opciones

insert into ciops_opc_opciones (opc_opcion, opc_codenc) values
('Masculino', 1), 
('Femenino', 1), 
('Soltero/a', 1), 
('Casado/a', 1), 
('Acompa�ado/a', 1), 
('Divorciado/a', 1), 
('Viudo/a', 1), 
('NS/SO', 1), 
('Ninguna', 1), 
('NR/SO', 1), 
('Otro, �Cu�l?', 1), 
('Ninguno', 1), 
('S�', 1), 
('No', 1), 
('1� - 3�', 1), 
('4� - 6�', 1), 
('7� - 9�', 1), 
('Estudiante de Bachiller', 1), 
('Bachiller', 1), 
('T�cnico', 1), 
('Estudiante Universitario', 1), 
('Graduado Universitario', 1), 
('Empleado', 1), 
('Estudiante', 1), 
('Comerciante', 1), 
('Pensionado', 1), 
('Ama de casa', 1), 
('Desempleado', 1), 
('Empresario', 1), 
('P�blico', 1), 
('Privado', 1), 
('Personal operativo', 1), 
('Asistente, T�cnico, Secretaria/o, etc.', 1), 
('Jefe, Supervisor, Coordinador, etc.', 1), 
('Gerente/Director, etc.', 1), 
('Menos del salario m�nimo', 1), 
('Entre el m�nimo ($251.70) y $300.00.', 1), 
('De $301.00 a $600.00', 1), 
('De $601.00 a $900.00', 1), 
('De $901.00 a $1,200.00', 1), 
('De $1,201.00 a $1,500.00', 1), 
('M�s de $1,501.00', 1), 
('Diario', 1), 
('Fin de semana', 1), 
('De vez en cuando', 1), 
('Dos o tres veces por semana', 1), 
('Tigo', 1), 
('Claro', 1), 
('Movistar', 1), 
('Digicel', 1), 
('Red', 1), 
('Japi', 1), 
('Sky', 1), 
('No tiene', 1), 
('Facebook', 1), 
('Twitter', 1), 
('MySpace', 1), 
('YouTube', 1), 
('Tagged', 1), 
('Instagram', 1), 
('Flickr', 1), 
('Bebo', 1), 
('Wayne', 1), 
('LinkedIn', 1), 
('Whatsapp', 1), 
('Snapchat', 1), 
('Google', 1), 
('Yahoo!', 1), 
('OLX', 1), 
('Bing', 1), 
('Foofind', 1), 
('AskJeeves', 1), 
('Terra', 1), 
('Ropa', 1), 
('Zapatos', 1), 
('Cosm�ticos', 1), 
('Alimentos / Comida r�pida', 1), 
('Joyer�a', 1), 
('Electrodom�sticos', 1), 
('Electr�nicos', 1), 
('Pagos de servicios', 1), 
('Entradas de cine', 1), 
('Comenzar un estilo de vida saludable', 1), 
('Recomendaci�n m�dica', 1), 
('Sedentarismo', 1), 
('Mejorar mi apariencia f�sica/estar en forma', 1), 
('Perder peso', 1), 
('Mejorar el estado de �nimo', 1), 
('Mantener/aumentar flexibilidad', 1), 
('Para tonificar mis m�sculos', 1), 
('V�lvula de escape al estr�s', 1), 
('Menos de 6 meses', 1), 
('De 6 meses a 1 a�o', 1), 
('De 1 a 2 a�os', 1), 
('De 2 a 3 a�os', 1), 
('De 3 a 4 a�os', 1), 
('De 4 a 5 a�os', 1), 
('M�s de 5 a�os', 1), 
('Todos los d�as (L-D)', 1), 
('Dos veces por semana', 1), 
('Tres veces por semana', 1), 
('Cuatro veces por semana', 1), 
('Cinco veces por semana', 1), 
('Seis veces por semana', 1), 
('Asfalto', 1), 
('Trail', 1), 
('1 a 3 Km.', 1), 
('4 a 6 Km.', 1), 
('7 a 10 Km.', 1), 
('M�s de 10 Km.', 1), 
('Solo', 1), 
('Con su pareja', 1), 
('Con amigos', 1), 
('Con familia', 1), 
('Con su mascota', 1), 
('Grupo deportivo', 1), 
('Active Runners', 1), 
('Trail Runners', 1), 
('Addict Runners', 1), 
('Fondistas Salvadore�os', 1), 
('San Jacinto Runners', 1), 
('Santa Ana Runners', 1), 
('Run to Live', 1), 
('Aleros Runners', 1), 
('Entr�nate', 1), 
('Cojute Activo', 1), 
('Ahuachap�n Runners', 1), 
('Caleros Runners', 1), 
('Cojute Runners', 1), 
('El Congo Runners', 1), 
('Entre Runners', 1), 
('Ma�ana', 1), 
('Mediod�a', 1), 
('Tarde', 1), 
('Noche', 1), 
('Le es indiferente', 1), 
('Hidratante/ Isot�nico', 1), 
('Suero', 1), 
('Agua', 1), 
('Gatorade', 1), 
('Powerade', 1), 
('Xtrade', 1), 
('Supermercado', 1), 
('Gasolinera', 1), 
('Farmacia', 1), 
('Nike', 1), 
('Under Armour', 1), 
('Adidas', 1), 
('Puma', 1), 
('Northface', 1), 
('Reebok', 1), 
('Umbro', 1), 
('FILA', 1), 
('$20.00 a $ 50.00', 1), 
('$51.00 a $100.00', 1), 
('$101.00 a $150.00', 1), 
('$151.00 a $200.00', 1), 
('$201.00 a m�s', 1), 
('Tienda de la marca', 1), 
('Almac�n', 1), 
('Compra en l�nea', 1), 
('Asics', 1), 
('New Balance', 1), 
('Saucony', 1), 
('Brooks', 1), 
('Turbo', 1), 
('Comodidad', 1), 
('Protecci�n', 1), 
('Durabilidad', 1), 
('Calidad', 1), 
('Precio', 1), 
('Dise�o', 1), 
('Seguridad', 1), 
('Tipo de pisada', 1), 
('Dos pares', 1), 
('Tres pares', 1), 
('Cuatro pares', 1), 
('Cinco pares', 1), 
('M�s de cinco pares', 1), 
('Reloj', 1), 
('Squeeze', 1), 
('Monitor card�aco', 1), 
('Aud�fonos', 1), 
('Celulares', 1), 
('F�tbol', 1), 
('B�squetbol', 1), 
('Tenis', 1), 
('Volley Ball', 1), 
('Nataci�n', 1), 
('Ciclismo', 1), 
('Karate', 1), 
('Funcional', 1), 
('Baseball', 1), 
('Pesas', 1), 
('Spinning', 1), 
('1 a 3', 1), 
('4 a 6', 1), 
('7 a 10', 1), 
('M�s de 10', 1), 
('Menos de 4K', 1), 
('5K', 1), 
('10K', 1), 
('21K', 1), 
('42K', 1), 
('M�s de 42K', 1), 
('No participo en carreras', 1), 
('Coes', 1), 
('Reto Powerade', 1), 
('Beach Run', 1), 
('Night Run', 1), 
('Marat�n Coes', 1), 
('21k San Salvador', 1), 
('Utap (Ultra Trail Atiquizaya)', 1), 
('Utcom', 1), 
('Reto Volc�n Ilamatepc Yo Amo ES', 1), 
('Jayaque Trail', 1), 
('Reto Al Boquer�n', 1), 
('21k Yo Amo ES', 1), 
('Organizaci�n', 1), 
('Ruta', 1), 
('GU', 1), 
('GNC', 1), 
('Herbalife', 1), 
('Nutrilite', 1), 
('ACCEL', 1), 
('Para Gorilas Creatine Powder', 1), 
('Opti-Men', 1), 
('Arroz', 1), 
('Pan', 1), 
('Patata', 1), 
('Legumbre', 1), 
('Cereales Integrales', 1), 
('Pescado', 1), 
('Carne de pollo o pavo', 1), 
('leche', 1), 
('Queso', 1), 
('Yogurt', 1), 
('Pasta con jam�n de pavo', 1), 
('At�n', 1), 
('Patatas', 1), 
('Menos de $40.00', 1), 
('$41.00 a $60.00', 1), 
('$61.00 a $80.00', 1), 
('$81.00 a $100.00', 1), 
('M�s de $100.00', 1), 
('Dieta rica en prote�nas', 1), 
('Dieta de trigo, arroz y avena', 1), 
('L�cteos', 1), 
('Dieta de frutas y verduras', 1), 
('Grasas saludables', 1), 
('Un coach', 1), 
('Un plan por internet', 1), 
('Su propio plan', 1), 
('Desgarre muscular', 1), 
('Rotura Muscular', 1), 
('Fascitis plantar', 1), 
('Periostitis', 1), 
('Banda Iliotibial', 1), 
('Tendinitis', 1), 
('Esguince', 1), 
('Fractura', 1), 
('Televisi�n', 1), 
('Radio', 1), 
('Prensa', 1), 
('Redes sociales', 1), 
('Publicidad Exterior', 1), 
('Muy buena', 1), 
('Buena', 1), 
('Regular', 1), 
('Mala', 1), 
('Muy Mala', 1), 
('Tener un estilo de vida saludable', 1), 
('Combatir el sedentarismo', 1), 
('Eliminar el estr�s', 1), 
('Mejorar mi desempe�o (tiempo/distancia)', 1), 
('Tonificar mis m�sculos', 1), 
('Aumentar la resistencia', 1), 
('Ahuachap�n', 1), 
('Santa Ana', 1), 
('Sonsonate', 1), 
('Chalatenango', 1), 
('Cuscatl�n', 1), 
('San Salvador', 1), 
('Libertad', 1), 
('San Vicente', 1), 
('Caba�as', 1), 
('La Paz', 1), 
('Usulut�n', 1), 
('San Miguel', 1), 
('Moraz�n', 1), 
('La Uni�n', 1), 
('Ahuachap�n', 1), 
('Apaneca', 1), 
('Atiquizaya', 1), 
('Concepci�n de Ataco', 1), 
('El Refugio', 1), 
('Guaymango', 1), 
('Jujutla', 1), 
('San Francisco Men�ndez', 1), 
('San Lorenzo', 1), 
('San Pedro Puxtla', 1), 
('Tacuba', 1), 
('Tur�n', 1), 
('Candelaria de la Frontera', 1), 
('Chalchuapa', 1), 
('Coatepeque', 1), 
('El Congo', 1), 
('El Porvenir', 1), 
('Masahuat', 1), 
('Metap�n', 1), 
('San Antonio Pajonal', 1), 
('San Sebasti�n Salitrillo', 1), 
('Santa Ana', 1), 
('Santa Rosa Guachipil�n', 1), 
('Santiago de la Frontera', 1), 
('Texistepeque', 1), 
('Acajutla', 1), 
('Armenia', 1), 
('Caluco', 1), 
('Cuisnahuat', 1), 
('Izalco', 1), 
('Juay�a', 1), 
('Nahuizalco', 1), 
('Nahulingo', 1), 
('Salcoatit�n', 1), 
('San Antonio del Monte', 1), 
('San Juli�n', 1), 
('Santa Catarina Masahuat', 1), 
('Santa Isabel Ishuat�n', 1), 
('Santo Domingo Guzm�n', 1), 
('Sonsonate', 1), 
('Sonzacate', 1), 
('Agua Caliente', 1), 
('Arcatao', 1), 
('Azacualpa', 1), 
('Chalatenango (ciudad)', 1), 
('Comalapa', 1), 
('Cital�', 1), 
('Concepci�n Quezaltepeque', 1), 
('Dulce Nombre de Mar�a', 1), 
('El Carrizal', 1), 
('El Para�so', 1), 
('La Laguna', 1), 
('La Palma', 1), 
('La Reina', 1), 
('Las Vueltas', 1), 
('Nueva Concepci�n', 1), 
('Nueva Trinidad', 1), 
('Nombre de Jes�s', 1), 
('Ojos de Agua', 1), 
('Potonico', 1), 
('San Antonio de la Cruz', 1), 
('San Antonio Los Ranchos', 1), 
('San Fernando', 1), 
('San Francisco Lempa', 1), 
('San Francisco Moraz�n', 1), 
('San Ignacio', 1), 
('San Isidro Labrador', 1), 
('San Jos� Cancasque', 1), 
('San Jos� Las Flores', 1), 
('San Luis del Carmen', 1), 
('San Miguel de Mercedes', 1), 
('San Rafael', 1), 
('Santa Rita', 1), 
('Tejutla', 1), 
('Candelaria', 1), 
('Cojutepeque', 1), 
('El Carmen', 1), 
('El Rosario', 1), 
('Monte San Juan', 1), 
('Oratorio de Concepci�n', 1), 
('San Bartolom� Perulap�a', 1), 
('San Crist�bal', 1), 
('San Jos� Guayabal', 1), 
('San Pedro Perulap�n', 1), 
('San Rafael Cedros', 1), 
('San Ram�n', 1), 
('Santa Cruz Analquito', 1), 
('Santa Cruz Michapa', 1), 
('Suchitoto', 1), 
('Tenancingo', 1), 
('Aguilares', 1), 
('Apopa', 1), 
('Ayutuxtepeque', 1), 
('Cuscatancingo', 1), 
('Ciudad Delgado', 1), 
('El Paisnal', 1), 
('Guazapa', 1), 
('Ilopango', 1), 
('Mejicanos', 1), 
('Nejapa', 1), 
('Panchimalco', 1), 
('Rosario de Mora', 1), 
('San Marcos', 1), 
('San Mart�n', 1), 
('San Salvador', 1), 
('Santiago Texacuangos', 1), 
('Santo Tom�s', 1), 
('Soyapango', 1), 
('Tonacatepeque', 1), 
('Antiguo Cuscatl�n', 1), 
('Chiltiup�n', 1), 
('Ciudad Arce', 1), 
('Col�n', 1), 
('Comasagua', 1), 
('Huiz�car', 1), 
('Jayaque', 1), 
('Jicalapa', 1), 
('La Libertad', 1), 
('Nueva San Salvador (Santa Tecla)', 1), 
('Nuevo Cuscatl�n', 1), 
('San Juan Opico', 1), 
('Quezaltepeque', 1), 
('Sacacoyo', 1), 
('San Jos� Villanueva', 1), 
('San Mat�as', 1), 
('San Pablo Tacachico', 1), 
('Talnique', 1), 
('Tamanique', 1), 
('Teotepeque', 1), 
('Tepecoyo', 1), 
('Zaragoza', 1), 
('Apastepeque', 1), 
('Guadalupe', 1), 
('San Cayetano Istepeque', 1), 
('San Esteban Catarina', 1), 
('San Ildefonso', 1), 
('San Lorenzo', 1), 
('San Sebasti�n', 1), 
('San Vicente', 1), 
('Santa Clara', 1), 
('Santo Domingo', 1), 
('Tecoluca', 1), 
('Tepetit�n', 1), 
('Verapaz', 1), 
('Cinquera', 1), 
('Dolores', 1), 
('Guacotecti', 1), 
('Ilobasco', 1), 
('Jutiapa', 1), 
('San Isidro', 1), 
('Sensuntepeque', 1), 
('Tejutepeque', 1), 
('Victoria', 1), 
('Cuyultit�n', 1), 
('El Rosario', 1), 
('Jerusal�n', 1), 
('Mercedes La Ceiba', 1), 
('Olocuilta', 1), 
('Para�so de Osorio', 1), 
('San Antonio Masahuat', 1), 
('San Emigdio', 1), 
('San Francisco Chinameca', 1), 
('San Juan Nonualco', 1), 
('San Juan Talpa', 1), 
('San Juan Tepezontes', 1), 
('San Luis Talpa', 1), 
('San Luis La Herradura', 1), 
('San Miguel Tepezontes', 1), 
('San Pedro Masahuat', 1), 
('San Pedro Nonualco', 1), 
('San Rafael Obrajuelo', 1), 
('Santa Mar�a Ostuma', 1), 
('Santiago Nonualco', 1), 
('Tapalhuaca', 1), 
('Zacatecoluca', 1), 
('Alegr�a', 1), 
('Berl�n', 1), 
('California', 1), 
('Concepci�n Batres', 1), 
('El Triunfo', 1), 
('Ereguayqu�n', 1), 
('Estanzuelas', 1), 
('Jiquilisco', 1), 
('Jucuapa', 1), 
('Jucuar�n', 1), 
('Mercedes Uma�a', 1), 
('Nueva Granada', 1), 
('Ozatl�n', 1), 
('Puerto El Triunfo', 1), 
('San Agust�n', 1), 
('San Buenaventura', 1), 
('San Dionisio', 1), 
('San Francisco Javier', 1), 
('Santa Elena', 1), 
('Santa Mar�a', 1), 
('Santiago de Mar�a', 1), 
('Tecap�n', 1), 
('Usulut�n', 1), 
('Carolina', 1), 
('Chapeltique', 1), 
('Chinameca', 1), 
('Chirilagua', 1), 
('Ciudad Barrios', 1), 
('Comacar�n', 1), 
('El Tr�nsito', 1), 
('Lolotique', 1), 
('Moncagua', 1), 
('Nueva Guadalupe', 1), 
('Nuevo Ed�n de San Juan', 1), 
('Quelepa', 1), 
('San Antonio del Mosco', 1), 
('San Gerardo', 1), 
('San Jorge', 1), 
('San Luis de la Reina', 1), 
('San Miguel', 1), 
('San Rafael Oriente', 1), 
('Sesori', 1), 
('Uluazapa', 1), 
('Arambala', 1), 
('Cacaopera', 1), 
('Chilanga', 1), 
('Corinto', 1), 
('Delicias de Concepci�n', 1), 
('El Divisadero', 1), 
('El Rosario', 1), 
('Gualococti', 1), 
('Guatajiagua', 1), 
('Joateca', 1), 
('Jocoaitique', 1), 
('Jocoro', 1), 
('Lolotiquillo', 1), 
('Meanguera', 1), 
('Osicala', 1), 
('Perqu�n', 1), 
('San Carlos', 1), 
('San Fernando', 1), 
('San Francisco Gotera', 1), 
('San Isidro', 1), 
('San Sim�n', 1), 
('Sensembra', 1), 
('Sociedad', 1), 
('Torola', 1), 
('Yamabal', 1), 
('Yoloaiqu�n', 1), 
('Anamor�s', 1), 
('Bolivar', 1), 
('Concepci�n de Oriente', 1), 
('Conchagua', 1), 
('El Carmen', 1), 
('El Sauce', 1), 
('Intipuc�', 1), 
('La Uni�n', 1), 
('Lislique', 1), 
('Meanguera del Golfo', 1), 
('Nueva Esparta', 1), 
('Pasaquina', 1), 
('Polor�s', 1), 
('San Alejo', 1), 
('San Jos�', 1), 
('Santa Rosa de Lima', 1), 
('Yayantique', 1), 
('Yucuaiqu�n', 1),
('Everlast', 1),--554
('Carbohidratos de absorci�n lenta', 1),
('Prote�nas bajas en grasa', 1),
('Alimento de Digesti�n R�pida', 1),
('Runners 2019', 1);

--drop table ciops_eenc_encabezados_encuestas
create table ciops_eenc_encabezados_encuestas (
	eenc_codigo int primary key identity (1, 1), 
	eenc_carnet varchar(25), --Codigo encuestador
	eenc_fecha_ingreso datetime, --Fecha en que el encuestador realizo la encuesta
	eenc_tiempo_realizacion varchar(30), --Tiempo en que el encuestador tardo en la encuesta
	eenc_fecha_creacion datetime default getdate(), --Fecha y hora en que se ingreso el registro a la BD
	eenc_campo_hombre int, --Indica si la persona encuestada es hombre
	eenc_campo_mujer int, --Indica si la persona encuestada es mujer
	eenc_campo_departamento int,  --Campo que almacena el codigo de departamento donde se realizo la encuesta
	eenc_codenc int foreign key references ciops_enc_encuestas, --Indica de que encuesta es el registro
	eenc_contador int default 1
)
-- select * from ciops_eenc_encabezados_encuestas

--drop table ciops_resenc_respuestas_encuestas
create table ciops_resenc_respuestas_encuestas (
	resenc_codpre varchar(10),-- foreign key references ciops_pre_preguntas, 
	resenc_codopc int foreign key references ciops_opc_opciones,
	resenc_codeenc int foreign key references ciops_eenc_encabezados_encuestas,--YA CON EL CAMPO "resenc_codpre" SE CONOCE DE QUE ENCUESTA ES, PERO POR EFECTOS DE OMITIR JOINS SE COLOCA ACA
	resenc_contador int default 1
)
-- select * from ciops_resenc_respuestas_encuestas

--drop table ciops_resaenc_respuestas_abiertas_encuestas
create table ciops_resaenc_respuestas_abiertas_encuestas (
	resaenc_codpre varchar(10),-- foreign key references ciops_pre_preguntas, 
	resaenc_detalle varchar(max),
	resaenc_codeenc int foreign key references ciops_eenc_encabezados_encuestas,
	resaenc_contador int default 1
)
--select * from ciops_resaenc_respuestas_abiertas_encuestas

alter procedure [dbo].[sp_ciops_insertar_respuestas_enc]
	-- sp_ciops_insertar_respuestas_enc 1, 0, '', 0, '', '25-1565-2015',  '2019-08-29 16:32:49', '00:00:24:85', 2
	@opcion int = 0,
	@codenc int = 0,
	@codpre varchar(10) = '',
	@codopc int = 0,
	@detalle varchar(125) = '',
	@enc_carnet varchar(16) = '',
	@enc_fecha_ingreso datetime = null,
	@enc_tiempo_realizacion varchar(16) = '',
	@eenc_codenc int = 1
as
begin

	if @opcion = 1 --Inserta una encabezado de encuesta
	begin
		insert into ciops_eenc_encabezados_encuestas (eenc_carnet, eenc_fecha_ingreso, eenc_tiempo_realizacion, eenc_codenc)
		values (@enc_carnet, @enc_fecha_ingreso, @enc_tiempo_realizacion, @eenc_codenc)
		select @@identity
	end

	if @opcion = 2 --Inserta las respuesta de la encuesta @codenc
	begin
		insert into ciops_resenc_respuestas_encuestas (resenc_codpre, resenc_codopc, resenc_codeenc)
		values (@codpre, @codopc, @codenc)
	end

	if @opcion = 3 --Inserta las respuesta ABIERTAS de la encuesta @codenc
	begin
		insert into ciops_resaenc_respuestas_abiertas_encuestas(resaenc_codpre, resaenc_detalle, resaenc_codeenc)
		values (@codpre, rtrim(ltrim(@detalle)), @codenc)
	end
end

alter procedure [dbo].[sp_ciops_resultados_encuestas]
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-10-22 13:47:32.567>
	-- Description: <Muestra los resultados de las encuestas segun el @codenc>
	-- =============================================
	-- sp_ciops_resultados_encuestas 1, 1 --Cantidad de encuestas segun @codenc
	-- sp_ciops_resultados_encuestas 2, 1 --Cantidad de respuestas por encuestador de @codenc
	-- sp_ciops_resultados_encuestas 3, 1 --Tablas de frecuencias preguntas cerradas-abiertas segun @codenc
	-- sp_ciops_resultados_encuestas 7, 1 --Base de datos pivoteada de preguntas "cerradas" del @codenc
	-- sp_ciops_resultados_encuestas 8, 1 --Base de datos pivoteada de preguntas "abiertas" del @codenc
	-- sp_ciops_resultados_encuestas 9, 1 --Reporte de tiempos de las encuestadoras segun el @codenc
	@opcion int,
	@codenc int
as
begin
	if @opcion = 0 --MUESTRA CUANTAS ENCUESTAS VA POR SEXO
	begin
		select opc_opcion 'Sexo', count(1) 'Cantidad' 
		from ciops_resenc_respuestas_encuestas 
			inner join ciops_opc_opciones on opc_codigo = resenc_codopc
		where resenc_codpre in ('2') and opc_codenc = @codenc
		group by opc_opcion
		union all
		select 'Total encuestados' 'Sexo', count(1) 'Cantidad' 
		from ciops_resenc_respuestas_encuestas 
			inner join ciops_opc_opciones on opc_codigo = resenc_codopc
		where resenc_codpre in ('2') and opc_codenc = @codenc
	end

	if @opcion = 1--Encuestas total
	begin
		declare @cont int
		select @cont = count(1) from ciops_eenc_encabezados_encuestas where eenc_codenc = @codenc
		select isnull(@cont, 0)
	end

	if @opcion = 2--Encuestas por realizadas por encuestador
	begin
		select enc_nombre 'Encuesta', eenc_carnet 'Codigo encuestador', encu_nombre_completo 'Encuestad@r',/*, encu_telefono,*/ count(1) 'Encuestas realizadas' 
		from ciops_eenc_encabezados_encuestas
			left join tba_encu_encuestadores on encu_carnet = eenc_carnet
			inner join ciops_enc_encuestas on enc_codigo = eenc_codenc
		where eenc_codenc = @codenc
		group by enc_nombre, eenc_carnet, encu_nombre_completo
	end

	if @opcion =  3 --Tablas de frecuencias preguntas cerradas-abiertas
	begin
		----INICIA TABLAS PREGUNTAS CERRADAS
		declare @tabla_detalle as table (pre_codigo varchar(5), num_opc_total int, Total int)
		insert into @tabla_detalle
		select pre_codigo, count(distinct opc_opcion) 'num_opc_total', count(1) 'Total'
		from ciops_resenc_respuestas_encuestas
			inner join ciops_pre_preguntas on pre_identificar_encuesta = resenc_codpre
			inner join ciops_opc_opciones on opc_codigo = resenc_codopc 
			inner join ciops_eenc_encabezados_encuestas on eenc_codigo = resenc_codeenc and eenc_codenc = @codenc
		group by pre_identificar_encuesta, pre_codigo , pre_pregunta, eenc_campo_departamento
		----TERMINA TABLAS PREGUNTAS CERRADAS

		----INICIA TABLAS PREGUNTAS ABIERTAS
		declare @tabla_detalle_abiertas as table (pre_codigo varchar(5), num_opc_total int, Total int)
		insert into @tabla_detalle_abiertas
		select pre_codigo, count(distinct resaenc_detalle) 'num_opc_total', count(1) 'Total'
		from ciops_resaenc_respuestas_abiertas_encuestas
			inner join ciops_pre_preguntas on pre_identificar_encuesta = resaenc_codpre and pre_codenc = @codenc
		group by pre_codigo, pre_codigo , pre_pregunta
		order by pre_codigo
		----TERMINA TABLAS PREGUNTAS ABIERTAS
		--MUESTRA PREGUNTAS CERRADAS
		select pre_identificar_encuesta, pre_codigo, pre_pregunta, row_number() over (partition by pre_pregunta order by opc_opcion) opc_num,  num_opc_total, opc_opcion, Cantidad,
		Total , 'cerrada' 'tipo'
		from (
			select pre_identificar_encuesta, pre_codigo, pre_pregunta, Cantidad 'opc_num',  num_opc_total, opc_opcion, Total, Cantidad
			from (
				select eenc_campo_departamento, pre_identificar_encuesta, p.pre_codigo , p.pre_pregunta, 
				row_number() over (partition by pre_pregunta order by opc_opcion) opc_num, 
				t.num_opc_total, opc_opcion, count(1) 'Cantidad', t.Total
				from ciops_resenc_respuestas_encuestas
					inner join ciops_pre_preguntas as p on pre_identificar_encuesta = resenc_codpre
					inner join ciops_opc_opciones on opc_codigo = resenc_codopc
					inner join @tabla_detalle as t on t.pre_codigo = p.pre_codigo
					inner join ciops_eenc_encabezados_encuestas on eenc_codigo = resenc_codeenc
				group by pre_identificar_encuesta, p.pre_codigo , pre_pregunta, opc_opcion, t.Total, t.num_opc_total, eenc_campo_departamento
			) p
		) tab
		group by pre_identificar_encuesta, pre_codigo, pre_codigo, pre_pregunta,  num_opc_total, opc_opcion, Cantidad, Total
		
		union all
		--MUESTRA PREGUNTAS ABIERTAS
		select p.pre_identificar_encuesta,p.pre_codigo,p.pre_pregunta, 
		row_number() over (partition by p.pre_codigo order by resaenc_detalle) opc_num, 
		t.num_opc_total, resaenc_detalle 'opc_opcion', count(1) 'Cantidad', t.Total, 'abierta' 'tipo'
		from ciops_resaenc_respuestas_abiertas_encuestas
			inner join ciops_pre_preguntas as p on pre_identificar_encuesta = resaenc_codpre
			inner join @tabla_detalle_abiertas as t on t.pre_codigo = p.pre_codigo
		group by p.pre_codigo,  resaenc_detalle,  p.pre_pregunta, t.Total, t.num_opc_total, p.pre_codigo, pre_identificar_encuesta

		order by 2, 1, tipo desc
	end
	
	DECLARE @cols nvarchar(MAX);
	if @opcion = 7--Base de datos pivoteada--PREGUNTAS CERRADAS
	begin
		SET @cols = stuff(
		(
			select  concat('|',pre_identificar_encuesta , '. ', pre_pregunta)   
			from ciops_pre_preguntas 
			where pre_identificar_encuesta not in('14', '17', '27_1', '30_3', '37_1')
			order by pre_codigo for xml path(''), type
		).value('.', 'nvarchar(max)'), 1, 1, ''
		);
		select '0' 'codenc',concat('|',@cols, '|enc_carnet','|enc_fecha_ingreso',  '|enc_tiempo_realizacion', '|enc_fecha_creacion') 'cols'
		union
		select cast(enc.eenc_codigo  as varchar(25)), 
		concat(
			'|',
			stuff(
				(
					select concat('|',isnull(opc_opcion, 'NULL')) from ciops_pre_preguntas
					left join ciops_resenc_respuestas_encuestas on resenc_codpre = pre_identificar_encuesta and resenc_codeenc = enc.eenc_codigo and eenc_codenc = @codenc
					left join ciops_opc_opciones on opc_codigo = resenc_codopc
					where pre_identificar_encuesta not in('14', '17', '27_1', '30_3', '37_1')
					order by pre_codigo
					for xml path('')
				),1,1, ''
			), 
			'|'+cast(enc.eenc_carnet as varchar(12)), 
			'|'+cast(enc.eenc_fecha_ingreso as varchar(25)), 
			'|'+cast(enc.eenc_tiempo_realizacion  as varchar(12)), 
			'|'+cast(enc.eenc_fecha_creacion as varchar(25))
		) 'cols'
		from ciops_eenc_encabezados_encuestas as enc
		order by 'codenc'
	end
	if @opcion = 8--Base de datos pivoteada --PREGUNTAS ABIERTAS
	begin
		SET @cols = stuff(
		(
			select  concat('|',pre_identificar_encuesta , '. ', pre_pregunta)   
			from ciops_pre_preguntas 
			where pre_identificar_encuesta not in('14', '17', '27_1', '30_3', '37_1')
			order by pre_codigo for xml path(''), type
		).value('.', 'nvarchar(max)'), 1, 1, ''
		);
		select '0' 'codenc',concat('|',@cols, '|enc_carnet','|enc_fecha_ingreso',  '|enc_tiempo_realizacion', '|enc_fecha_creacion') 'cols'
		union
		select cast(enc.eenc_codigo  as varchar(25)), 
		concat(
			'|',
			stuff(
				(
					select concat('|',isnull(resaenc_detalle, 'NULL')) from ciops_pre_preguntas
					left join ciops_resaenc_respuestas_abiertas_encuestas on resaenc_codpre = pre_identificar_encuesta and resaenc_codeenc = enc.eenc_codigo and eenc_codenc = @codenc
					where pre_identificar_encuesta not in('14', '17', '27_1', '30_3', '37_1')
					order by pre_codigo
					for xml path('')
				),1,1, ''
			), 
			'|'+cast(enc.eenc_carnet as varchar(12)), 
			'|'+cast(enc.eenc_fecha_ingreso as varchar(25)), 
			'|'+cast(enc.eenc_tiempo_realizacion  as varchar(12)), 
			'|'+cast(enc.eenc_fecha_creacion as varchar(25))
		) 'cols'
		from ciops_eenc_encabezados_encuestas as enc
		order by 'codenc'
	end
	
	if @opcion = 9
	begin
		select enc_codigo 'codenc', row_number() over (partition by eenc_carnet order by eenc_carnet) 'Enc. realizada Numero', eenc_carnet 'Codigo encuestador', eenc_fecha_ingreso 'Fecha/Hora realizo encuesta', 
		eenc_tiempo_realizacion 'Tiempo demorado', SUBSTRING(eenc_tiempo_realizacion, 1, 2) 'Horas', SUBSTRING(eenc_tiempo_realizacion, 4, 2) 'Minutos', SUBSTRING(eenc_tiempo_realizacion, 7, 2) 'Segundos', concat(SUBSTRING(eenc_tiempo_realizacion, 10, 2), 0) 'Milisegundos',
		enc_fecha_creacion 'Fecha sincronizacion', enc_nombre 'Encuesta', eenc_contador 'contador'
		from ciops_eenc_encabezados_encuestas
		inner join ciops_enc_encuestas on enc_codigo = eenc_codenc
		where enc_codigo = @codenc
		order by eenc_carnet, eenc_fecha_ingreso
	end
end