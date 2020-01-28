create table prueba_ws(
data_ws varchar(255)
)

select * from prueba_ws

insert into prueba_ws values ('qwe')

alter procedure sp_insertar_data_tba2018
	-- sp_insertar_data_tba2018 'ASD'
	@data_ws varchar(255)
as
begin
	insert into prueba_ws values (@data_ws)
	select 1
end

create table ciops_tba_top_brand_awards(
	tba_codigo int primary key identity(1, 1),
	tba_anio int,
	tba_descripcion varchar(255),
	tba_detalle varchar(1025),
	tba_fecha_creacion datetime default getdate()
);
insert into ciops_tba_top_brand_awards(tba_anio, tba_descripcion, tba_detalle) values(2018, 'Top Brands Awards', 'Este fue el primer registro del TBA, los datos se almacenaron en una base de datos en mysql'), (2019, 'Top Brands Awards', 'Primer a�o que se guardaron los datos en SQL Server, se normalizaron las tablas')
-- select * from ciops_tba_top_brand_awards
/*
dropp table tba_resa_respuestas_abiertas
dropp table tba_res_respuestas
dropp table tba_enc_encuestas
dropp table tba_opc_opciones
dropp table tba_pre_preguntas
dropp table tba_cat_categorias
dropp table ciops_tba_top_brand_awards
*/

create table tba_cat_categorias(
	cat_codigo int primary key identity(0,1), 
	cat_categoria varchar(105),
	cat_codtba int foreign key references ciops_tba_top_brand_awards,
	cat_fecha_creacion datetime default getdate()
);
-- select * from tba_cat_categorias
INSERT INTO tba_cat_categorias(cat_categoria, cat_codtba) VALUES 
('CATEGORIA PERFIL', 2),
('CATEGORIA GASEOSAS', 2),
('CATEGORIA AGUA ENVASADA', 2),
('CATEGORIA QUESOS', 2),
('CATEGORIA LECHE LIQUIDA', 2),
('CATEGORIA PAN DE CAJA EMPACADO', 2),
('CATEGORIA YOGURT', 2),
('CATEGORIA POLLO FRESCO', 2),
('CATEGORIA PANADERIA', 2),
('CATEGORIA PAN DULCE EMPACADO', 2),
('CATEGORIA ARROZ', 2),
('CATEGORIA SOPAS', 2),
('CATEGORIA ACEITE COMESTIBLE', 2),
('CATEGORIA CENTROS COMERCIALES', 2),
('CATEGORIA ESTACIONES DE CAF�', 2),
('CATEGORIA COMIDA R�PIDA POLLO', 2),
('CATEGORIA HAMBURGUESAS', 2),
('CATEGORIA PIZZAS', 2),
('CATEGORIA RESTAURANTES DE COMIDA A LA CARTA', 2),
('CATEGOR�A PERIODICOS IMPRESOS', 2),
('CATEGORIA PERIODICO DIGITAL', 2),
('CATEGORIA DE TIENDAS DE ELECTRODOMESTICOS', 2),
('CATEGORIA SUPERMERCADOS', 2),
('CATEGORIA ALMACEN POR DEPARTAMENTO', 2),
('CATEGORIA FERRETERIAS', 2),
('CATEGORIA FARMACIAS', 2),
('CATEGORIA TIENDAS DE TECNOLOG�A', 2),
('CATEGORIA TIENDAS EN LINEA', 2),
('CATEGORIA FINANCIERAS', 2),
('CATEGORIA DESODORANTE', 2),
('CATEGORIA CHAMP�', 2),
('CATEGORIA COMPA��AS TELEFONICAS', 2),
('CATEGORIA SMARTPHONE', 2),
('CATEGORIA DETERGENTES EN POLVO', 2),
('CATEGORIA JAB�N PARA LAVAR ROPA', 2),
('CATEGORIA MOTOCICLETAS', 2),
('CATEGORIA TIENDA DE ROPA', 2),
('CATEGOR�A ANTRIGIPALES', 2),
('CATEGOR�A MAYONESAS ', 2),
('CATEGOR�A HIERBAS, ESPECIAS Y SAZONADORES', 2);
-- dropp table tba_pre_preguntas
create table tba_pre_preguntas(
	pre_cod int identity(1,1),
	pre_codigo varchar(125)  primary key,
	pre_pregunta varchar(1250),
	pre_codcat int foreign key references tba_cat_categorias,
	pre_orden int,
	pre_fecha_creacion datetime default getdate()
);
-- select * from tba_pre_preguntas order by pre_cod
insert into tba_pre_preguntas(pre_codigo, pre_pregunta, pre_codcat, pre_orden) values
('0', 'Tipo instrumento', 0, 0),
('1', 'Departamento:', 0, 0),
('2', 'G�nero', 0, 0),
('3', '�Cu�l es su estado civil?', 0, 0),
('4', ' �Cu�l es su grado de escolaridad?', 0, 0),
('5', '�Cu�l es su edad cumplida? ', 0, 0),
('6', '�Cu�l es su ocupaci�n actual?', 0, 0),
('6_1', 'Si contest� 1. Empleado: �En qu� Sector trabaja? ', 0, 0),
('6_2', '�Qu� posici�n desempe�a dentro de la empresa?', 0, 0),
('7', '�Cu�l es el ingreso promedio mensual en su familia? (Incluyen los ingresos por labores y remesas) ', 0, 0),
('8', '�Tiene hijos? ', 0, 0),
('8_1', 'Si contest� s�, �Cu�ntos hijos tiene? ', 0, 0),
('9', '�Qu� medio utiliza para transportarse con m�s frecuencia?  ', 0, 0),
('9_1', 'Si contest� veh�culo, �Qu� marca de veh�culo es? ', 0, 0),
('9_2', 'Si contest� veh�culo, �Qu� a�o es? ', 0, 0),
('10', '�Qu� redes sociales utiliza con m�s frecuencia? (Nivel de memoria, SELECCIONE 3 opciones)', 0, 0),
('11', 'Cuando realiza b�squedas en internet; �Cu�l motor de b�squeda utiliza principalmente? (Nivel de memoria)', 0, 0),
('12', 'De los siguientes productos financieros, �Cu�les posee? (OPCI�N MULTIPLE)', 0, 0),
('12_1', 'Si contesto alg�n producto, �Qu� tipo de instituci�n se lo ha otorgado? ', 0, 0),
('C_1', 'CATEGORIA GASEOSAS', 0, 0),
('C_2', 'CATEGORIA AGUA ENVASADA', 0, 0),
('C_3', 'CATEGORIA QUESOS', 0, 0),
('C_4', 'CATEGORIA LECHE LIQUIDA', 0, 0),
('C_5', 'CATEGORIA PAN DE CAJA EMPACADO', 0, 0),
('C_6', 'CATEGORIA YOGURT', 0, 0),
('C_7', 'CATEGORIA POLLO FRESCO', 0, 0),
('C_8', 'CATEGORIA PANADERIA', 0, 0),
('C_9', 'CATEGORIA PAN DULCE EMPACADO', 0, 0),
('C_10', 'CATEGORIA ARROZ', 0, 0),
('C_11', 'CATEGORIA SOPAS', 0, 0),
('C_12', 'CATEGORIA ACEITE COMESTIBLE', 0, 0),
('C_13', 'CATEGORIA CENTROS COMERCIALES', 0, 0),
('C_14', 'CATEGORIA ESTACIONES DE CAF�', 0, 0),
('C_15', 'CATEGORIA COMIDA R�PIDA POLLO', 0, 0),
('C_16', 'CATEGORIA HAMBURGUESAS', 0, 0),
('C_17', 'CATEGORIA PIZZAS', 0, 0),
('C_18', 'CATEGORIA RESTAURANTES DE COMIDA A LA CARTA', 0, 0),
('C_19', 'CATEGOR�A PERIODICOS IMPRESOS', 0, 0),
('C_20', 'CATEGORIA PERIODICO DIGITAL', 0, 0),
('C_21', 'CATEGORIA DE TIENDAS DE ELECTRODOMESTICOS', 0, 0),
('C_22', 'CATEGORIA SUPERMERCADOS', 0, 0),
('C_23', 'CATEGORIA ALMACEN POR DEPARTAMENTO', 0, 0),
('C_24', 'CATEGORIA FERRETERIAS', 0, 0),
('C_25', 'CATEGORIA FARMACIAS', 0, 0),
('C_26', 'CATEGORIA TIENDAS DE TECNOLOG�A', 0, 0),
('C_27', 'CATEGORIA TIENDAS EN LINEA', 0, 0),
('C_28', 'CATEGORIA FINANCIERAS', 0, 0),
('C_29', 'CATEGORIA DESODORANTE', 0, 0),
('C_30', 'CATEGORIA CHAMP�', 0, 0),
('C_31', 'CATEGORIA COMPA��AS TELEFONICAS', 0, 0),
('C_32', 'CATEGORIA SMARTPHONE', 0, 0),
('C_33', 'CATEGORIA DETERGENTES EN POLVO', 0, 0),
('C_34', 'CATEGORIA JAB�N PARA LAVAR ROPA', 0, 0),
('C_35', 'CATEGORIA MOTOCICLETAS', 0, 0),
('C_36', 'CATEGORIA TIENDA DE ROPA', 0, 0),
('C_37', 'CATEGOR�A ANTRIGIPALES', 0, 0),
('C_38', 'CATEGOR�A MAYONESAS ', 0, 0),
('C_39', 'CATEGOR�A HIERBAS, ESPECIAS Y SAZONADORES', 0, 0);
insert into tba_pre_preguntas(pre_codigo, pre_pregunta, pre_codcat, pre_orden) values
('13', '�Cu�l es la marca de gaseosa o soda que considera tiene la mejor calidad?', 1, 1),
('14', '�Cu�l es la marca de gaseosa o soda que tiene el mejor precio?', 1, 2),
('15', '�Cu�l es la marca de gaseosa o soda que considera tiene la mejor presentaci�n?', 1, 3),
('16', '�Cu�l es la marca de gaseosa o soda que considera tiene el mejor sabor?', 1, 4),
('17', '�Cu�l es la marca de gaseosa o soda que compr� por �ltima vez?', 1, 5),
('18', '�Cu�l marca de gaseosa o soda que piensa comprar la pr�xima vez?', 1, 6),
('19', '�Cu�l es la marca de agua envasada que considera tiene la mejor calidad?', 2, 1),
('20', '�Cu�l es la marca de agua envasada que tiene el mejor precio?', 2, 2),
('21', '�Cu�l es la marca de agua envasada que considera tiene la mejor presentaci�n?', 2, 3),
('22', '�Cu�l es la marca de agua envasada que considera tiene el mejor sabor?', 2, 4),
('23', '�Cu�l es la marca de agua envasada que compr� por �ltima vez?', 2, 5),
('24', '�Cu�l es la marca de agua envasada que piensa comprar la pr�xima vez?', 2, 6),
('25', '�Cu�l es la marca de quesos que considera tiene la mejor calidad?', 3, 1),
('26', '�Cu�l es la marca de quesos que tiene el mejor precio?', 3, 2),
('27', '�Cu�l es la marca de quesos que considera tiene la mejor presentaci�n?', 3, 3),
('28', '�Cu�l es la marca de quesos que considera tiene el mejor sabor?', 3, 4),
('29', '�Cu�l es la marca de quesos que compr� por �ltima vez?', 3, 5),
('30', '�Cu�l es la marca de quesos que piensa comprar la pr�xima vez?', 3, 6),
('31', '�Cu�l es la marca de leche l�quida que considera tiene la mejor calidad?', 4, 1),
('32', '�Cu�l es la marca de leche l�quida que tiene el mejor precio?', 4, 2),
('33', '�Cu�l es la marca de leche l�quida que considera tiene la mejor presentaci�n?', 4, 3),
('34', '�Cu�l es la marca de leche l�quida que considera tiene el mejor sabor?', 4, 4),
('35', '�Cu�l es la marca de leche l�quida que compr� por �ltima vez?', 4, 5),
('36', '�Cu�l es la marca de leche l�quida que piensa comprar la pr�xima vez?', 4, 6),
('37', '�Cu�l es la marca de pan de caja que considera tiene la mejor calidad?', 5, 1),
('38', '�Cu�l es la marca de pan de caja que tiene el mejor precio?', 5, 2),
('39', '�Cu�l es la marca de pan de caja que considera tiene la mejor presentaci�n?', 5, 3),
('40', '�Cu�l es la marca de pan de caja que considera tiene el mejor sabor?', 5, 4),
('41', '�Cu�l es la marca de pan de caja que compr� por �ltima vez?', 5, 5),
('42', '�Cu�l es la marca de pan de caja que piensa comprar la pr�xima vez?', 5, 6),
('43', '�Cu�l es la marca de yogurt que considera tiene la mejor calidad?', 6, 1),
('44', '�Cu�l es la marca de yogurt que tiene el mejor precio?', 6, 2),
('45', '�Cu�l es la marca de yogurt que considera tiene la mejor presentaci�n?', 6, 3),
('46', '�Cu�l es la marca de yogurt que considera tiene el mejor sabor?', 6, 4),
('47', '�Cu�l es la marca de yogurt que compr� por �ltima vez?', 6, 5),
('48', '�Cu�l es la marca de yogurt que piensa comprar la pr�xima vez?', 6, 6),
('49', '�Cu�l es la marca de pollo fresco que considera tiene la mejor calidad?', 7, 1),
('50', '�Cu�l es la marca de pollo fresco que tiene el mejor precio?', 7, 2),
('51', '�Cu�l es la marca de pollo fresco que considera tiene la mejor presentaci�n?', 7, 3),
('52', '�Cu�l es la marca de pollo fresco que considera tiene el mejor sabor?', 7, 4),
('53', '�Cu�l es la marca de pollo fresco que compr� por �ltima vez?', 7, 5),
('54', '�Cu�l es la marca de pollo fresco que piensa comprar la pr�xima vez?', 7, 6),
('55', '�Cu�l es la panader�a que considera tiene la mejor calidad?', 8, 1),
('56', '�Cu�l es la panader�a que considera tiene el mejor precio?', 8, 2),
('57', '�Cu�l es la panader�a que considera tiene la mejor presentaci�n?', 8, 3),
('58', '�Cu�l es la panader�a que considera tiene el mejor sabor?', 8, 4),
('59', '�Cu�l es la panader�a que visit� por �ltima vez?', 8, 5),
('60', '�Cu�l es la panader�a que piensa visitar la pr�xima vez?', 8, 6),
('61', '�Cu�l es la marca de pan dulce empacado que considera tiene la mejor calidad?', 9, 1),
('62', '�Cu�l es la marca de pan dulce empacado que tiene el mejor precio?', 9, 2),
('63', '�Cu�l es la marca de pan dulce empacado que considera tiene la mejor presentaci�n?', 9, 3),
('64', '�Cu�l es la marca de pan dulce empacado que considera tiene el mejor sabor?', 9, 4),
('65', '�Cu�l es la marca de pan dulce empacado que compr� por �ltima vez?', 9, 5),
('66', '�Cu�l es la marca de pan dulce empacado que piensa comprar la pr�xima vez?', 9, 6),
('67', '�Cu�l es la marca de arroz que considera tiene la mejor calidad?', 10, 1),
('68', '�Cu�l es la marca de arroz que tiene el mejor precio?', 10, 2),
('69', '�Cu�l es la marca de arroz que considera tiene la mejor presentaci�n?', 10, 3),
('70', '�Cu�l es la marca de arroz que considera tiene el mejor sabor?', 10, 4),
('71', '�Cu�l es la marca de arroz que compr� por �ltima vez?', 10, 5),
('72', '�Cu�l es la marca de arroz que piensa comprar la pr�xima vez?', 10, 6),
('73', '�Cu�l es la marca de sopas que considera tiene la mejor calidad?', 11, 1),
('74', '�Cu�l es la marca de sopas que tiene el mejor precio?', 11, 2),
('75', '�Cu�l es la marca de sopas que considera tiene la mejor presentaci�n?', 11, 3),
('76', '�Cu�l es la marca de sopas que considera tiene el mejor sabor?', 11, 4),
('77', '�Cu�l es la marca de sopa que compr� por �ltima vez?', 11, 5),
('78', '�Cu�l es la marca de sopas que piensa comprar la pr�xima vez?', 11, 6),
('79', '�Cu�l es la marca de aceite que considera tiene la mejor calidad?', 12, 1),
('80', '�Cu�l es la marca de aceite que tiene el mejor precio?', 12, 2),
('81', '�Cu�l es la marca de aceite que considera tiene la mejor presentaci�n?', 12, 3),
('82', '�Cu�l es la marca de aceite que considera tiene el mejor sabor?', 12, 4),
('83', '�Cu�l es la marca de aceite que compr� por �ltima vez?', 12, 5),
('84', '�Cu�l es la marca de aceite que piensa comprar la pr�xima vez?', 12, 6),
('85', '�Cu�l es el centro comercial que le brinda los mejores horarios de atenci�n?', 13, 1),
('86', '�Cu�l es el centro comercial que le ofrece mejor variedad de tiendas?', 13, 2),
('87', '�Cu�l es el centro comercial que ofrece mayor accesibilidad de estacionamiento?', 13, 3),
('88', '�Cu�l es el centro comercial que considera que tiene las mejores instalaciones?', 13, 4),
('89', '�Cu�l es el centro comercial que visit� la �ltima vez?', 13, 5),
('90', '�Cu�l es el centro comercial que piensa visitar la pr�xima vez?', 13, 6),
('91', '�Cu�l es la estaci�n o lugar de caf� le brinda un mejor servicio al cliente?', 14, 1),
('92', '�Cu�l es la estaci�n o lugar de caf� considera le ofrece los mejores precios?', 14, 2),
('93', '�Cu�l es la estaci�n o lugar de caf� le ofrece mejor calidad?', 14, 3),
('94', '�Cu�l es la estaci�n o lugar de caf� considera que tiene las mejores instalaciones?', 14, 4),
('95', '�Cu�l es la estaci�n o lugar de caf� que visit� por �ltima vez?', 14, 5),
('96', '�Cu�l es la estaci�n de caf� que piensa visitar la pr�xima vez?', 14, 6),
('97', '�Cu�l restaurante de pollo le brinda un mejor servicio al cliente?', 15, 1),
('98', '�Cu�l restaurante de pollo le ofrece los mejores precios?', 15, 2),
('99', '�Cu�l restaurante de pollo le ofrece mejor calidad?', 15, 3),
('100', '�Cu�l restaurante de pollo considera que tiene las mejores instalaciones?', 15, 4),
('101', '�Cu�l restaurante de pollo visit� por �ltima vez?', 15, 5),
('102', '�Cu�l es el restaurante de pollo que piensa visitar la pr�xima vez?', 15, 6),
('103', '�Cu�l restaurante de Hamburguesas le brinda un mejor servicio al cliente?', 16, 1),
('104', '�Cu�l restaurante de Hamburguesas le ofrece los mejores precios?', 16, 2),
('105', '�Cu�l restaurante de Hamburguesas le ofrece mejor calidad?', 16, 3),
('106', '�Cu�l restaurante de Hamburguesas considera que tiene las mejores instalaciones?', 16, 4),
('107', '�Cu�l restaurante de Hamburguesas visit� por �ltima vez?', 16, 5),
('108', '�Cu�l es el restaurante de hamburguesas que piensa visitar la pr�xima vez?', 16, 6),
('109', '�Cu�l restaurante de pizza le brinda un mejor servicio al cliente?', 17, 1),
('110', '�Cu�l restaurante de pizza le ofrece los mejores precios?', 17, 2),
('111', '�Cu�l restaurante de pizza le ofrece mejor calidad?', 17, 3),
('112', '�Cu�l restaurante de pizza considera que tiene las mejores instalaciones?', 17, 4),
('113', '�Cu�l restaurante de pizza visit� por �ltima vez?', 17, 5),
('114', '�Cu�l es el restaurante de pizza que piensa visitar la pr�xima vez?', 17, 6),
('115', '�Cu�l es el restaurante de comida a la carta le brinda una mejor atenci�n al cliente?', 18, 1),
('116', '�Cu�l es el restaurante de comida a la carta le ofrece los mejores precios?', 18, 2),
('117', '�Cu�l es el restaurante de comida a la carta le ofrece mejor calidad?', 18, 3),
('118', '�Cu�l es el restaurante de comida a la carta considera que tiene las mejores instalaciones?', 18, 4),
('119', '�Cu�l es el restaurante de comida a la carta visit� por �ltima vez?', 18, 5),
('120', '�Cu�l es el restaurante de comida a la carta que piensa visitar la pr�xima vez?', 18, 6),
('121', '�Cu�l es el peri�dico impreso que considera le ofrece un mejor precio?', 19, 1),
('122', '�Cu�l es el peri�dico que considera es el que tiene m�s puntos de venta?', 19, 2),
('123', '�Cu�l es el peri�dico que considera es el que le ofrece mejor contenido?', 19, 3),
('124', '�Cu�l es el peri�dico que considera es el que tiene informaci�n actualizada?', 19, 4),
('125', '�Cu�l es el peri�dico impreso que compr� por �ltima vez?', 19, 5),
('126', '�Cu�l es el peri�dico impreso que piensa comprar la pr�xima vez?', 19, 6),
('127', '�Cu�l es el peri�dico digital le ofrece una plataforma f�cil de utilizar?', 20, 1),
('128', '�Cu�l es el peri�dico digital es m�s accesible online?', 20, 2),
('129', '�Cu�l es el peri�dico digital le ofrece un mejor contenido?', 20, 3),
('130', '�Cu�l es el peri�dico digital considera que tiene la informaci�n m�s actualizada?', 20, 4),
('131', '�Cu�l es el peri�dico digital ley� la �ltima vez?', 20, 5),
('132', '�Cu�l es el peri�dico digital que piensa leer la pr�xima vez?', 20, 6),
('133', '�Cu�l es la tienda de electrodom�sticos que le brinda los mejores horarios de atenci�n?', 21, 1),
('134', '�Cu�l es la tienda de electrodom�sticos que le brinda el mejor servicio al cliente?', 21, 2),
('135', '�Cu�l es la tienda de electrodom�sticos que tiene los mejores precios?', 21, 3),
('136', '�Cu�l es la tienda de electrodom�sticos que considera que tiene las mejores instalaciones?', 21, 4),
('137', '�Cu�l es la tienda de electrodom�sticos donde compr� por �ltima vez?', 21, 5),
('138', '�Cu�l es la tienda de electrodom�sticos en piensa comprar la pr�xima vez?', 21, 6),
('139', '�Cu�l es el supermercado le brinda los mejores horarios de atenci�n?', 22, 1),
('140', '�Cu�l es el supermercado le brinda el mejor servicio al cliente?', 22, 2),
('141', '�Cu�l es el supermercado tiene los mejores precios?', 22, 3),
('142', '�Cu�l es el supermercado considera que tiene las mejores instalaciones?', 22, 4),
('143', '�Cu�l es el supermercado donde compr� por �ltima vez?', 22, 5),
('144', '�Cu�l es el supermercado en donde piensa comprar la pr�xima vez?', 22, 6),
('145', '�Cu�l es el almac�n por departamento le brinda los mejores horarios de atenci�n?', 23, 1),
('146', '�Cu�l es el almac�n por departamento le brinda el mejor servicio al cliente?', 23, 2),
('147', '�Cu�l es el almac�n por departamento tiene los mejores precios?', 23, 3),
('148', '�Cu�l es el almac�n por departamento considera que tiene las mejores instalaciones?', 23, 4),
('149', '�Cu�l es el almac�n por departamento donde compr� por �ltima vez?', 23, 5),
('150', '�Cu�l es el almac�n por departamento en donde piensa comprar la pr�xima vez?', 23, 6),
('151', '�Cu�l es la ferreter�a le brinda los mejores horarios de atenci�n?', 24, 1),
('152', '�Cu�l es la ferreter�a le brinda el mejor servicio al cliente?', 24, 2),
('153', '�Cu�l es la ferreter�a tiene los mejores precios?', 24, 3),
('154', '�Cu�l es la ferreter�a considera que tiene las mejores instalaciones?', 24, 4),
('155', '�Cu�l es la ferreter�a donde compr� por �ltima vez?', 24, 5),
('156', '�Cu�l es la ferreter�a en donde piensa comprar la pr�xima vez?', 24, 6),
('157', '�Cu�l es la farmacia le brinda los mejores horarios de atenci�n?', 25, 1),
('158', '�Cu�l es la farmacia le brinda el mejor servicio al cliente?', 25, 2),
('159', '�Cu�l es la farmacia tiene los mejores precios?', 25, 3),
('160', '�Cu�l es la farmacia considera que tiene las mejores instalaciones?', 25, 4),
('161', '�Cu�l es la farmacia donde compr� por �ltima vez?', 25, 5),
('162', '�Cu�l es la farmacia en donde piensa comprar la pr�xima vez?', 25, 6),
('163', '�Cu�l es la tienda de tecnolog�a que le brinda los mejores horarios de atenci�n?', 26, 1),
('164', '�Cu�l es la tienda de tecnolog�a que le brinda el mejor servicio al cliente?', 26, 2),
('165', '�Cu�l es la tienda de tecnolog�a que tiene los mejores precios?', 26, 3),
('166', '�Cu�l es la tienda de tecnolog�a considera que tiene las mejores instalaciones?', 26, 4),
('167', '�Cu�l es la tienda de tecnolog�a donde compr� por �ltima vez?', 26, 5),
('168', '�Cu�l es la tienda de tecnolog�a en donde piensa comprar la pr�xima vez?', 26, 6),
('169', '�Cu�l es la tienda en l�nea le ofrece los mejores precios?', 27, 1),
('170', '�Cu�l es la tienda en l�nea le ofrece mayor variedad de categor�as de productos?', 27, 2),
('171', '�Cu�l es la tienda en l�nea que considera tiene la plataforma m�s amigable o sencilla para comprar?', 27, 3),
('172', '�Cu�l es la tienda en l�nea que le brinda mayor confianza y un mejor servicio de entrega?', 27, 4),
('173', '�Cu�l es la tienda en l�nea donde compr� por �ltima vez?', 27, 5),
('174', '�Cu�l es la tienda en l�nea en donde piensa comprar la pr�xima vez?', 27, 6),
('175', '�De cu�l instituci�n financiera (que no sea banco) ha escuchado o ha experimentado que tiene una mejor atenci�n al cliente?', 28, 1),
('176', '�De cu�l instituci�n financiera (que no sea banco) ha escuchado o ha experimentado que ofrece las mejores tasas de inter�s?', 28, 2),
('177', '�De cu�l instituci�n financiera (que no sea banco) ha escuchado o ha experimentado que ofrece los mejores horarios de atenci�n?', 28, 3),
('178', '�De cu�l instituci�n financiera (que no sea banco) ha escuchado o ha experimentado que tiene las mejores instalaciones?', 28, 4),
('179', '�En cu�l instituci�n financiera (que no sea banco) donde le otorgaron su �ltimo cr�dito?', 28, 5),
('180', 'En caso de realizar otro cr�dito con una instituci�n financiera (que no sea banco), �En cu�l instituci�n realizar�a el tr�mite?', 28, 6),
('181', '�Cu�l es la marca de desodorante considera que tiene la mejor calidad?', 29, 1),
('182', '�Cu�l es la marca de desodorante considera tiene el mejor precio?', 29, 2),
('183', '�Cu�l es la marca de desodorante considera que tiene la mejor presentaci�n?', 29, 3),
('184', '�Cu�l es la marca de desodorante que le da mayor protecci�n y duraci�n?', 29, 4),
('185', '�Cu�l es la marca de desodorante que compr� por �ltima vez?', 29, 5),
('186', '�Cu�l es la marca de desodorante que piensa comprar la pr�xima vez?', 29, 6),
('187', '�Cu�l es la marca de champ� considera que tiene la mejor calidad?', 30, 1),
('188', '�Cu�l es la marca de champ� considera tiene mejor precio?', 30, 2),
('189', '�Cu�l es la marca de champ� considera que tiene la mejor presentaci�n?', 30, 3),
('190', '�Cu�l es la marca de champ� que cuida y limpia su cabello seg�n sus necesidades?', 30, 4),
('191', '�Cu�l es la marca de champ� que compr� por �ltima vez?', 30, 5),
('192', '�Cu�l es la marca de champ� que piensa comprar la pr�xima vez?', 30, 6),
('193', '�Cu�l es la compa��a de telefon�a que le brinda el mejor servicio al cliente?', 31, 1),
('194', '�Cu�l es la compa��a de telefon�a que tiene los mejores precios?', 31, 2),
('195', '�Cu�l es la compa��a de telefon�a le brinda los mejores horarios?', 31, 3),
('196', '�Cu�l es la compa��a de telefon�a que considera que tiene las mejores instalaciones?', 31, 4),
('197', '�Cu�l compa��a de telefon�a le est� brindando servicios en estos momentos?', 31, 5),
('198', 'En caso que decidiera cambiarse de compa��a de telefon�a, �A cu�l cambiar�a?', 31, 6),
('199', '�Cu�l es la marca de Smartphone que considera tiene la mejor calidad?', 32, 1),
('200', '�Cu�l es la marca de Smartphone que considera tiene mejor precio?', 32, 2),
('201', '�Cu�l es la marca de Smartphone que considera tiene la mejor presentaci�n?', 32, 3),
('202', '�Cu�l es la marca de Smartphone que tiene la mejor tecnolog�a?', 32, 4),
('203', '�Cu�l es la marca de Smartphone que compr� por �ltima vez?', 32, 5),
('204', 'Si usted adquiere otro Smartphone y no adquiere la �ltima marca que compr�, �Cu�l otra marca comprar�a?', 32, 6),
('205', '�Cu�l es el detergente en polvo que tiene la mejor calidad?', 33, 1),
('206', '�Cu�l es el detergente en polvo que tiene mejor precio?', 33, 2),
('207', '�Cu�l es el detergente en polvo que considera tiene la mejor presentaci�n?', 33, 3),
('208', '�Cu�l es el detergente en polvo que le genera m�s confianza?', 33, 4),
('209', '�Cu�l es el detergente en polvo que compr� por �ltima vez?', 33, 5),
('210', '�Cu�l es el detergente en polvo que piensa comprar la pr�xima vez?', 33, 6),
('211', '�Cu�l es el jab�n de lavar ropa que tiene la mejor calidad?', 34, 1),
('212', '�Cu�l es el jab�n de lavar ropa que tiene mejor precio?', 34, 2),
('213', '�Cu�l es el jab�n de lavar ropa considera que tiene la mejor presentaci�n?', 34, 3),
('214', '�Cu�l es el jab�n de lavar ropa que le genera m�s confianza?', 34, 4),
('215', '�Cu�l es la marca de jab�n de lavar ropa que compr� por �ltima vez?', 34, 5),
('216', '�Cu�l es la marca de jab�n de lavar ropa que piensa comprar la pr�xima vez?', 34, 6),
('217', '�Cu�l es la marca de motocicletas que tiene la mejor calidad?', 35, 1),
('218', '�Cu�l es la marca de motocicletas que tiene mejor precio?', 35, 2),
('219', '�Cu�l es la marca de motocicletas considera que tiene la mejor presentaci�n?', 35, 3),
('220', '�Cu�l es la marca de motocicletas con el que m�s se identifica?', 35, 4),
('221', '�Cu�l marca de motocicletas que compr� por �ltima vez?', 35, 5),
('222', '�Cu�l es la marca de motocicletas que piensa comprar la pr�xima vez?', 35, 6),
('223', '�Cu�l es la tienda de ropa que le brinda los mejores horarios de atenci�n?', 36, 1),
('224', '�Cu�l es la tienda de ropa que le brinda el mejor servicio al cliente?', 36, 2),
('225', '�Cu�l es la tienda de ropa que tiene los mejores precios?', 36, 3),
('226', '�Cu�l es la tienda de ropa que considera que tiene las mejores instalaciones?', 36, 4),
('227', '�Cu�l es la tienda de ropa donde compr� por �ltima vez?', 36, 5),
('228', '�Cu�l es la tienda de ropa donde piensa comprar la pr�xima vez?', 36, 6),
('229', '�Cu�l antigripal considera que tiene la mejor calidad?', 37, 1),
('230', '�Cu�l antigripal considera tiene el mejor precio?', 37, 2),
('231', '�Cu�l antigripal considera que tiene la mejor presentaci�n?', 37, 3),
('232', '�Cu�l antigripal considera que es m�s efectivo?', 37, 4),
('233', '�Cu�l antigripal compr� por �ltima vez?', 37, 5),
('234', '�Cu�l es el antigripal que piensa comprar la pr�xima vez?', 37, 6),
('235', '�Cu�l es la marca de mayonesa que considera tiene la mejor calidad?', 38, 1),
('236', '�Cu�l es la marca de mayonesa que tiene el mejor precio?', 38, 2),
('237', '�Cu�l es la marca de mayonesa que considera tiene la mejor presentaci�n?', 38, 3),
('238', '�Cu�l es la marca de mayonesa que considera tiene el mejor sabor?', 38, 4),
('239', '�Cu�l es la marca de mayonesa que compr� por �ltima vez?', 38, 5),
('240', '�Cu�l es la marca de mayonesa que piensa comprar la pr�xima vez?', 38, 6),
('241', '�Cu�l es la marca de hierbas, especias y sazonadores que considera tiene la mejor calidad?', 39, 1),
('242', '�Cu�l es la marca de hierbas, especias y sazonadores que tiene el mejor precio?', 39, 2),
('243', '�Cu�l es la marca de hierbas, especias y sazonadores que considera tiene la mejor presentaci�n?', 39, 3),
('244', '�Cu�l es la marca de hierbas, especias y sazonadores que considera tiene el mejor sabor?', 39, 4),
('245', '�Cu�l es la marca de hierbas, especias y sazonadores que compr� por �ltima vez?', 39, 5),
('246', '�Cu�l es la marca de hierbas, especias y sazonadores que piensa comprar la pr�xima vez?', 39, 6),
--PREGUNTAS DE DESODORATE DE MUJER
('247', '�Cu�l es la marca de desodorante considera que tiene la mejor calidad?', 29, 1),
('248', '�Cu�l es la marca de desodorante considera tiene el mejor precio?', 29, 2),
('249', '�Cu�l es la marca de desodorante considera que tiene la mejor presentaci�n?', 29, 3),
('250', '�Cu�l es la marca de desodorante que le da mayor protecci�n y duraci�n?', 29, 4),
('251', '�Cu�l es la marca de desodorante que compr� por �ltima vez?', 29, 5),
('252', '�Cu�l es la marca de desodorante que piensa comprar la pr�xima vez?', 29, 6);

-- dropp table tba_opc_opciones
create table tba_opc_opciones(
	opc_codigo int /*varchar(125) */PRIMARY key,
	opc_opcion varchar(255),
	opc_fecha_creacion datetime default getdate()
);
-- select * from tba_opc_opciones order by opc_codigo

insert into tba_opc_opciones(opc_codigo, opc_opcion) values
(1, 'San Salvador'),
(2, 'Santa Ana'),
(3, 'Sonsonate'),
(4, 'San Miguel'),
(5, 'Masculino'),
(6, 'Femenino'),
(7, 'Soltero'),
(8, 'Casado'),
(9, 'Acompa�ado'),
(10, 'Divorciado'),
(11, 'Viudo'),
(12, '1�- 3� '),
(13, '4� -6�'),
(14, '7� - 9�'),
(15, 'Estudiante de bachillerato'),
(16, 'Bachiller'),
(17, 'T�cnico'),
(18, 'Estudiante Universitario'),
(19, 'Graduado Universitario'),
(20, 'Empleado'),
(21, 'Estudiante'),
(22, 'Comerciante'),
(23, 'Pensionado'),
(24, 'Ama de casa'),
(25, 'Desempleado '),
(26, 'Empresario '),
(27, 'P�blico'),
(28, 'Privado'),
(29, 'Personal operativo '),
(30, 'Asistente, T�cnico, Secretaria/o, etc.'),
(31, 'Jefe, Supervisor, Coordinador, etc.'),
(32, 'Gerente/Director, etc.'),
(33, 'Menos del salario m�nimo  '),
(34, 'Entre el m�nimo ($251.70) y $300.00. '),
(35, 'De $301.00 a $600.00     '),
(36, 'De $601.00 a $900.00'),
(37, 'De $901.00 a $1,200.00   '),
(38, 'De $1,201.00 a $1,500.00'),
(39, 'M�s de $1,501.00'),
(40, 'Si '),
(41, 'No'),
(42, 'Transporte colectivo'),
(43, 'Veh�culo Propio'),
(44, 'Veh�culo (familiar/amigo) '),
(45, 'Motocicleta'),
(46, 'Nissan'),
(47, 'Toyota'),
(48, 'Kia'),
(49, 'Mazda'),
(50, 'Hyundai '),
(51, 'Honda'),
(52, 'Chevrolet'),
(53, 'Facebook'),
(54, 'Twitter'),
(55, 'MySpace '),
(56, 'YouTube'),
(57, 'Tagged'),
(58, 'Instagram'),
(59, 'Flickr'),
(60, 'Bebo'),
(61, 'Wayne'),
(62, 'LinkedIn'),
(63, 'Whatsapp  '),
(64, 'Snapchat '),
(65, 'TikTok'),
(66, 'Google'),
(67, 'Yahoo!'),
(68, 'OLX'),
(69, 'Bing'),
(70, 'Foofind'),
(71, 'Ask Jeeves'),
(72, 'Terra'),
(73, 'Tarjeta de cr�dito'),
(74, 'Cuenta de ahorro'),
(75, 'Remesa familiar '),
(76, 'Seguros'),
(77, 'Cr�ditos personales'),
(78, 'Cr�ditos Productivos'),
(79, 'Cr�ditos para Vivienda'),
(80, 'Cr�dito Automotriz'),
(81, 'Cr�ditos comercios'),
(82, 'Cr�ditos MYPE'),
(83, 'Sistemas bancarios'),
(84, 'Cajas de cr�dito  (FEDECREDITO)'),
(85, 'Sociedades de Ahorro y Cr�dito, y otras Micro financieras'),
(86, 'Cooperativas de Ahorro y Cr�dito (FEDECACES)'),
(87, 'Personas particulares (prestamistas) '),
(88, 'Big-cola'),
(89, 'Fanta'),
(90, 'Salva-cola'),
(91, 'Mirinda'),
(92, 'Coca-cola'),
(93, 'Fresca'),
(94, 'Sprite'),
(95, 'Grapette'),
(96, 'Kolashampan'),
(97, 'Pepsi-cola'),
(98, 'Tropical'),
(99, '7UP'),
(100, 'Alpina'),
(101, 'El Jord�n'),
(102, 'La Miguele�a'),
(103, 'Salud'),
(104, 'Salvavidas'),
(105, 'Aquapura'),
(106, 'El Lim�n'),
(107, 'La Roca'),
(108, 'Zen'),
(109, 'Cielo'),
(110, 'Gotita'),
(111, 'Las Perlitas'),
(112, 'Dany'),
(113, 'Cristal'),
(114, 'La Cascada'),
(115, 'Pe�a Fresca'),
(116, 'Evian'),
(117, 'Oasis'),
(118, 'Primavera'),
(119, 'Ecoagua'),
(120, 'La fuente'),
(121, 'Filtrada'),
(122, 'Dos Pinos'),
(123, 'Los quesos de Oriente'),
(124, 'Parmalat'),
(125, 'Petacones'),
(126, 'San Juli�n'),
(127, 'L�cteos de Metap�n'),
(128, 'Sula'),
(129, 'Valle Blanco'),
(130, 'El Jobo'),
(131, 'Eskimo'),
(132, 'Kraft'),
(133, 'Lactolac'),
(134, 'La villita l�ctea'),
(135, 'El recreo'),
(136, 'Farm House'),
(137, 'Salud'),
(138, 'Queso Artesanal/Mercado'),
(139, 'Los 3 quesos'),
(140, 'Las joyitas'),
(141, 'Do�a Laura'),
(142, 'Dos Pinos'),
(143, 'Sveltty'),
(144, 'Sula'),
(145, 'Centrolac'),
(146, 'Salud'),
(147, 'Eskimo'),
(148, 'Los quesos de oriente'),
(149, 'El Jobo'),
(150, 'Valle Blanco'),
(151, 'Parmalat'),
(152, 'Lala'),
(153, 'Milk'),
(154, 'Suli'),
(155, 'Foremost'),
(156, 'Pan Bimbo'),
(157, 'Aladino'),
(158, 'Pan Monarca'),
(159, 'San Martin'),
(160, 'Pan Rey'),
(161, 'Pan Rosvill'),
(162, 'Pan Lido'),
(163, 'Pan Sina�'),
(164, 'Pan Dany'),
(165, 'Pan Marinela'),
(166, 'Pan Suli'),
(167, 'Europa'),
(168, 'Selectos'),
(169, 'Salud'),
(170, 'Yes'),
(171, 'Gaymonts'),
(172, 'Activia (Dannon)'),
(173, 'Vital�nea'),
(174, 'Yoplait'),
(175, 'Valle Blanco'),
(176, 'Svelty'),
(177, 'Vanilla Spoon'),
(178, 'Dos pinos'),
(179, 'Pollo indio'),
(180, 'Pollo sello de oro'),
(181, 'Pollo Americano'),
(182, 'Rico pollo'),
(183, 'Selectos fresh'),
(184, 'Granja/Mercado'),
(185, 'El rosario'),
(186, 'Lido'),
(187, 'La never�a'),
(188, 'La tecle�a'),
(189, 'M�ster donut'),
(190, 'Ooh la la'),
(191, 'Lorena'),
(192, 'Le caf�'),
(193, 'Elsys cakes'),
(194, 'La holandesa'),
(195, 'Lilian'),
(196, 'Chez Andr�'),
(197, 'Antonys'),
(198, 'Shaws'),
(199, 'Ban ban'),
(200, 'Florence'),
(201, 'Bakery selectos'),
(202, 'The coffee cup'),
(203, 'San Mart�n'),
(204, 'Samsil'),
(205, 'Santa Eduvigs'),
(206, 'Lorena'),
(207, 'Bom Bom'),
(208, 'Sina�'),
(209, 'Lido'),
(210, 'Twins'),
(211, 'G�nesis'),
(212, 'Bah�a'),
(213, 'Santa Eduviges'),
(214, 'Almago'),
(215, 'Bimbo'),
(216, 'Family Oven'),
(217, 'Rossvill'),
(218, 'Mam� Chela'),
(219, 'Granada'),
(220, 'Marisela'),
(221, 'Cinco estrellas'),
(222, 'Selectos'),
(223, 'Dany'),
(224, 'San Francisco'),
(225, 'Az de oro'),
(226, 'Omoa'),
(227, 'Risoto'),
(228, 'Arrozal'),
(229, 'Dilosa'),
(230, 'Do�a Blanca'),
(231, 'Americano'),
(232, 'Suli'),
(233, 'Mercado'),
(234, 'San Pedro'),
(235, 'Gallo dorado'),
(236, 'Gumarsal'),
(237, 'Maruchan'),
(238, 'Laky men'),
(239, 'Campells'),
(240, 'Mi zopita'),
(241, 'Maggi'),
(242, 'Knorr'),
(243, 'Continental'),
(244, 'Malher'),
(245, 'Bonella'),
(246, 'El Dorado'),
(247, 'Mazola'),
(248, 'Orisol'),
(249, 'Wesson'),
(250, 'Borges'),
(251, 'Ideal'),
(252, 'Selectos'),
(253, 'Santa Clara'),
(254, 'Dany'),
(255, 'Issima'),
(256, 'Olitalia'),
(257, 'Sasso'),
(258, 'Galer�as Escal�n'),
(259, 'La Gran V�a'),
(260, 'Plaza Metr�polis'),
(261, 'Plaza Merliot'),
(262, 'San Luis'),
(263, 'Las Cascadas'),
(264, 'Plaza Mundo'),
(265, 'Multiplaza'),
(266, 'Metrocentro'),
(267, 'Plaza Centro (Ex-Siman C.)'),
(268, 'El encuentro'),
(269, 'Pericentro Apopa'),
(270, 'Cofee Cup'),
(271, 'La Panetiere'),
(272, 'Mc Caf�'),
(273, 'Ben�s Cofee'),
(274, 'Florence'),
(275, 'Le Croissant'),
(276, 'Viva Espresso'),
(277, 'Macchtiato caf�'),
(278, 'San Mart�n'),
(279, 'Starbucks'),
(280, 'The house of coffee'),
(281, 'Sucre�'),
(282, 'Mister Donut'),
(283, 'Juan Vald�z'),
(284, 'Pollo Campero'),
(285, 'Pollo KFC'),
(286, 'Pollo Campestre'),
(287, 'Don Pollo'),
(288, 'Pollo de supermercado'),
(289, 'Pollo Real'),
(290, 'Bonanza'),
(291, 'Burger King'),
(292, 'Gourmet Burger Company'),
(293, 'Rustico Bistro'),
(294, 'Charlie Boy'),
(295, 'Smash burger'),
(296, 'McDonalds'),
(297, 'Pollo Campero hamburguesa'),
(298, 'Wendy�s'),
(299, 'Don Pollo hamburguesa'),
(300, 'Papa John�s'),
(301, 'Pizza Hut'),
(302, 'Pizza Nova'),
(303, 'Pizza Boom'),
(304, 'Pizza Krisppy'),
(305, 'Domino�s'),
(306, 'Telepizza'),
(307, 'La Pizzeria'),
(308, 'Little Ceasar�s'),
(309, 'Charlie Boy'),
(310, 'Tony Roma�s'),
(311, 'El lomo y aguja'),
(312, 'Asia Grill'),
(313, 'La Herradura'),
(314, 'Bennigan�s'),
(315, 'El Arriero'),
(316, 'Hunan'),
(317, 'Beto�s'),
(318, 'Benihanna'),
(319, 'Los Ranchos'),
(320, 'El Z�calo'),
(321, 'La Curva'),
(322, 'Olive Garden'),
(323, 'Royal'),
(324, 'Inka Grill28'),
(325, 'El Charr�a'),
(326, 'Tucson'),
(327, 'Kreef'),
(328, 'La Calaca'),
(329, 'Denny�s'),
(330, 'Se�or Tenedor'),
(331, 'Las Alitas'),
(332, 'La Pampa Argentina'),
(333, 'Faisca do Brasil'),
(334, 'Caliche�s'),
(335, 'Paradise'),
(336, 'Los Cebollines'),
(337, 'Puerto Marisco'),
(338, 'La Prensa Gr�fica'),
(339, 'Diario El Mundo'),
(340, 'Mi Chero'),
(341, 'El Diario de Hoy'),
(342, 'Diario Colatino'),
(343, 'M�s'),
(344, 'El Gr�fico'),
(345, 'La Prensa Gr�fica'),
(346, 'El Mundo'),
(347, 'El Faro'),
(348, 'Voces'),
(349, 'El Diario de Hoy'),
(350, 'La P�gina'),
(351, 'El blog'),
(352, 'Marca'),
(353, 'Contrapunto'),
(354, 'Sim�n'),
(355, 'Prado'),
(356, 'Way'),
(357, 'Sanborns'),
(358, 'Wallmart'),
(359, 'La Curacao'),
(360, 'Sears'),
(361, 'Radio Shack'),
(362, 'Omnisport'),
(363, 'Almacenes Tropigas'),
(364, 'La Despensa de Don juan'),
(365, 'Despensa Familiar'),
(366, 'S�per Selectos'),
(367, 'Maxi Despensa'),
(368, 'Walmart'),
(369, 'PriceSmart'),
(370, 'Sim�n'),
(371, 'Sears'),
(372, 'Sanborns'),
(373, 'Freund'),
(374, 'Vidr�'),
(375, 'Epa'),
(376, 'Lemus'),
(377, 'La Palma'),
(378, 'Castella Sagarra'),
(379, 'Ferrominera'),
(380, 'El baratillo'),
(381, 'Viduc'),
(382, 'Beethoven'),
(383, 'Farma-Value'),
(384, 'Sagrado Coraz�n'),
(385, 'San Nicol�s'),
(386, 'Camila'),
(387, 'Guadalupe'),
(388, 'San Benito'),
(389, 'Econ�micas'),
(390, 'La buena'),
(391, 'Uno'),
(392, 'Cefafa'),
(393, 'Las am�ricas'),
(394, 'Virgen de Guadalupe'),
(395, 'San Rafael'),
(396, 'Divina Providencia'),
(397, 'San Roque'),
(398, 'Intelmax'),
(399, 'Omnisport'),
(400, 'Sanborns'),
(401, 'Sony'),
(402, 'Almacenes Siman'),
(403, 'Tecno Avance'),
(404, 'PriceSmart'),
(405, 'Computer Max'),
(406, 'RG Nieto'),
(407, 'La Curacao'),
(408, 'RadioShack'),
(409, 'Equipos Electr�nicos Vald�s'),
(410, 'Office Depot'),
(411, 'Cyber Games Store'),
(412, 'Kodak'),
(413, 'Office depot'),
(414, 'Amazon'),
(415, 'Ebay'),
(416, 'Pricemart'),
(417, 'Wallmart'),
(418, 'Super selectos'),
(419, 'Siman'),
(420, 'Curacao'),
(421, 'Aliexpress'),
(422, 'Speed Stick'),
(423, 'Gillette'),
(424, 'Dove'),
(425, 'Rexona'),
(426, 'Old Spice'),
(427, 'Degree'),
(428, 'Axe'),
(429, 'Nivea'),
(430, 'Catalogo'),
(431, 'Head&Shoul'),
(432, 'Dove'),
(433, 'Sedal'),
(434, 'Pert'),
(435, 'Pantene'),
(436, 'Elvive Loreal'),
(437, 'Palmolive'),
(438, 'Suave'),
(439, 'Tresemme'),
(440, 'Tio Nacho'),
(441, 'Biotin'),
(442, 'Finnesse'),
(443, 'EGO'),
(444, 'Frutics'),
(445, 'Wellapon'),
(446, 'Artesanal'),
(447, 'Claro'),
(448, 'Telef�nica'),
(449, 'Red'),
(450, 'Tigo'),
(451, 'Digicel'),
(452, 'Apple'),
(453, 'BlackBerry'),
(454, 'Lenovo'),
(455, 'Huawei'),
(456, 'Alcatel'),
(457, 'Acer'),
(458, 'LG'),
(459, 'HTC'),
(460, 'ZTE'),
(461, 'Samsung'),
(462, 'Motorola'),
(463, 'Sony'),
(464, 'Nokia'),
(465, 'Rinso'),
(466, 'Ajax'),
(467, 'Maxxi espuma'),
(468, 'Woolite'),
(469, 'Xedex'),
(470, 'Ace'),
(471, 'Rendidor'),
(472, 'Ariel'),
(473, 'Fab'),
(474, 'Tide'),
(475, 'M�s'),
(476, 'Irex'),
(477, 'Maxx'),
(478, 'Casablanca'),
(479, 'Surf'),
(480, 'Ultraclean'),
(481, 'Unox'),
(482, 'Xtra'),
(483, 'Unox'),
(484, 'Max'),
(485, 'Rinso'),
(486, 'Casa Blanca'),
(487, '123'),
(488, 'Espumil'),
(489, 'Ambar'),
(490, 'Centella'),
(491, 'BMW'),
(492, 'G�nesis'),
(493, 'Honda'),
(494, 'Kawasaki'),
(495, 'Scooters India'),
(496, 'Suzuki'),
(497, 'Triumph'),
(498, 'Vespa'),
(499, 'Voxman'),
(500, 'Yamaha'),
(501, 'Freedom'),
(502, 'Hero'),
(503, 'Sim�n'),
(504, 'Sears'),
(505, 'Sanborns'),
(506, 'Zara'),
(507, 'Bershka'),
(508, 'Pull and Bear'),
(509, 'Keneth'),
(510, 'Bomba'),
(511, 'Cole Fabios'),
(512, 'Forever twenty one'),
(513, 'Artuto Calle'),
(514, 'Pierre Cardine'),
(515, 'Prisma Moda'),
(516, 'Stradivarius'),
(517, 'St. Jacks'),
(518, 'Expose'),
(519, 'Ropa Usada, �Cu�l?'),
(520, 'Sudagrip'),
(521, 'Virogrip'),
(522, 'Palagrip'),
(523, 'Palatos'),
(524, 'Panadol multisintomas'),
(525, 'Tabcin antigripal'),
(526, 'Hellmann�s'),
(527, 'Kraft'),
(528, 'McCormick'),
(529, 'Maggi'),
(530, 'Regia'),
(531, 'Del Chef'),
(532, 'Selectos'),
(533, 'Dany'),
(534, 'Premiun Member Selection'),
(535, 'McCormick'),
(536, 'Maggi'),
(537, 'Continental'),
(538, 'Selectos'),
(539, 'Badia'),
(540, 'Sasson'),
(541, 'Burriac'),
(542, 'Hermel'),
(543, 'Ninguna'),
(544, 'NR/SO'),
(545, 'Otra, �Cu�l?'),
(546, 'NS/NR'),
(547, 'No consume'),
(548, 'No visita'),
(549, 'No lo compran'),
(550, 'No lee'),
(551, 'No utilizo'),
(552, 'Instrumento 1'),
(553, 'Instrumento 2'),
(554, 'Lady Speed Stick'),
(555, 'Rexona'),
(556, 'Degree'),
(557, 'Nivea'),
(558, 'Old Spice'),
(559, 'Axe'),
(560, 'Dove'),
(561, 'Catalogo'),
(562, 'Bancos de los trabajadores'),
(563, 'Caja de Cr�dito de San Salvador'),
(564, 'Caja de cr�dito de Soyapango'),
(565, 'Caja de cr�dito de Lourdes'),
(566, 'Caja de cr�dito de Zacatecoluca,'),
(567, 'Credicomer'),
(568, 'Integral'),
(569, 'Constelaci�n'),
(570, 'Multivalores'),
(571, '�ptima'),
(572, 'Asei'),
(573, 'Padecoms'),
(574, 'AMC'),
(575, 'H�bitat'),
(576, 'Fusai'),
(577, 'ACACCIBA DE R.L.'),
(578, 'ACACCIBA DE R.L.'),
(579, 'ACACEMIHA DE R.L.'),
(580, 'ACACEMIHA DE R.L.'),
(581, 'ACACES DE R.L.'),
(582, 'ACOPACTO DE R.L.'),
(583, 'ACACESPRO DE R.L.'),
(584, 'ACACESPRO DE R.L.'),
(585, 'ACACESPSA DE R.L.'),
(586, 'ACACESPSA DE R.L.'),
(587, 'ACACI DE R.L.'),
(588, 'ACACI DE R.L.'),
(589, 'ACACME DE R.L.'),
(590, 'ACACME DE R.L.'),
(591, 'ACACRECOSC DE R.L.'),
(592, 'ACACRECOSC DE R.L.'),
(593, 'ACACSEMERSA DE R.L.'),
(594, 'ACACSEMERSA DE R.L.'),
(595, 'ACACU DE R.L.'),
(596, 'ACACU DE R.L.'),
(597, 'ACACYPAC DE R.L.'),
(598, 'ACACYPAC DE R.L.'),
(599, 'ACAPRODUSCA DE R.L.'),
(600, 'ACAPRODUSCA DE R.L.'),
(601, 'ACAYCCOMAC DE R.L.'),
(602, 'ACAYCCOMAC DE R.L.'),
(603, 'ACECENTA DE R.L.'),
(604, 'ACECENTA DE R.L.'),
(605, 'ACOCOMET DE R.L.'),
(606, 'ACOCOMET DE R.L.'),
(607, 'ACODEZO DE R.L.'),
(608, 'ACODEZO DE R.L.'),
(609, 'ACODJAR DE R.L.'),
(610, 'ACODJAR DE R.L.'),
(611, 'ACOPACC DE R.L'),
(612, 'ACOPACC DE R.L'),
(613, 'ACOPUS DE R.L.'),
(614, 'ACOPUS DE R.L.'),
(615, 'CODEZA DE R.L.'),
(616, 'CODEZA DE R.L.'),
(617, 'FEDECACES'),
(618, 'SIHUACOOP DE R.L.'),
(619, 'ACACES DE R.L.');

-- dropp table tba_enc_encuestas
create table tba_enc_encuestas(
	enc_codigo int primary key identity(1,1), 
	enc_carnet varchar(15),
	enc_fecha_ingreso datetime,
	enc_tiempo_realizacion varchar(16),
	enc_fecha_creacion datetime default getdate(),
	enc_codtba int foreign key references ciops_tba_top_brand_awards,
	enc_campo_hombre tinyint default 0, --CAMPO DEL SEXO HOMBRE
	enc_campo_mujer tinyint default 0, --CAMPO DEL SEXO MUJER
	enc_campo_depar varchar(10),--CAMPO DEL DEPARTAMENTO
	enc_contador int default 1
);
-- select * from tba_enc_encuestas
select distinct enc_carnet from tba_enc_encuestas

select * from tba_opc_opciones where opc_codigo in (552, 553)

-- dropp table tba_res_respuestas
create table tba_res_respuestas(
	res_codpre varchar(125) foreign key references tba_pre_preguntas,
	res_codopc int /* varchar(125)*/ foreign key references tba_opc_opciones,
	res_codenc int foreign key references tba_enc_encuestas,
	res_contador int default 1
);
-- select * from tba_res_respuestas

-- dropp table tba_resa_respuestas_abiertas
create table tba_resa_respuestas_abiertas(
	resa_codpre varchar(125) foreign key references tba_pre_preguntas, 
	resa_detalle_respuesta varchar(125),
	resa_codenc int foreign key references tba_enc_encuestas,
	resa_contador int default 1
);
-- select * from tba_resa_respuestas_abiertas
/*
dropp table tba_enc_encuestas
dropp table tba_res_respuestas
dropp table tba_resa_respuestas_abiertas

select * from tba_cat_categorias
select * from tba_pre_preguntas
select * from tba_opc_opciones

select * from tba_enc_encuestas
select count(1) from tba_res_respuestas
select count(1) from tba_resa_respuestas_abiertas
*/

/*
dropp table tba_resa_respuestas_abiertas
dropp table tba_res_respuestas
dropp table tba_enc_encuestas
dropp table tba_opc_opciones
dropp table tba_pre_preguntas
dropp table tba_cat_categorias
dropp table ciops_tba_top_brand_awards
*/

/*
dropp table tba_enc_encuestas
dropp table tba_res_respuestas
dropp table tba_resa_respuestas_abiertas
*/

alter procedure sp_tba_insertar_respuestas
	-- sp_tba_insertar_respuestas 1, 0, '', 0, '', '25-1565-2015',  '2019-08-29 16:32:49', '00:00:24:85', 2
	@opcion int = 0,
	--@data_preguntas varchar(max) = '',
	@codenc int = 0,
	@codpre varchar(10) = '',
	@codopc int = 0,
	@detalle varchar(125) = '',
	@enc_carnet varchar(16) = '',
	@enc_fecha_ingreso datetime = null,
	@enc_tiempo_realizacion varchar(16) = '',
	@codtba int = 2,
	@enc_campo1 varchar(10) = '',--SEXO
	@enc_campo2 varchar(10) = ''--DEPARTAMENTO
as

3
begin
	if @opcion = 0 --ESTE CAMPO ACTUALIZA LOS CAMPOS "enc_campo1" (DEPARTAMENTO) y "enc_campo2" (SEXO) QUE SIRVEN PARA SACAR EL REPORTE POR CATEGORIAS
	begin
		if @enc_campo1 <> ''
		begin
			if @enc_campo1 = '5' --ES HOMBRE
			begin
				update tba_enc_encuestas set enc_campo_hombre = 1 where enc_codigo = @codenc
			end
			else
			begin
				update tba_enc_encuestas set enc_campo_mujer = 1 where enc_codigo = @codenc
			end
		end
		if @enc_campo2 <> ''
		begin
			update tba_enc_encuestas set enc_campo_depar = @enc_campo2 where enc_codigo = @codenc
		end
	end

	if @opcion = 1 --Inserta una encuesta
	begin
		insert into tba_enc_encuestas (enc_carnet, enc_fecha_ingreso, enc_tiempo_realizacion, enc_codtba)
		values (@enc_carnet, @enc_fecha_ingreso, @enc_tiempo_realizacion, @codtba)
		select @@identity
	end

	if @opcion = 2 --Inserta las respuesta de la encuesta @codenc
	begin
		insert into tba_res_respuestas (res_codpre, res_codopc, res_codenc)
		values (@codpre, @codopc, @codenc)
	end

	if @opcion = 3 --Inserta las respuesta ABIERTAS de la encuesta @codenc
	begin
		insert into tba_resa_respuestas_abiertas(resa_codpre, resa_detalle_respuesta, resa_codenc)
		values (@codpre, @detalle, @codenc)
	end
end
--deelete from tba_res_respuestas where res_codenc in (select enc_codigo from tba_enc_encuestas where enc_carnet = '00-0000-0000')
--deelete from tba_enc_encuestas where enc_carnet = '00-0000-0000'
select * from tba_enc_encuestas where convert(date, enc_fecha_creacion, 103) = '2019-10-01'
select * from tba_res_respuestas where res_codenc in (select * from tba_enc_encuestas where enc_carnet = '00-0000-0000')
select * from tba_res_respuestas

/*
	1	San Salvador -- 2019-09-28 y 2019-10-01
	2	Santa Ana    -- 2019-09-30
	3	Sonsonate    -- 2019-09-29
	4	San Miguel   -- 2019-10-02
*/

select * from tba_enc_encuestas where convert(date, enc_fecha_ingreso, 103) in('2019-10-01', '2019-09-28') and enc_campo_depar = 1 --309
select * from tba_enc_encuestas where convert(date, enc_fecha_ingreso, 103) = '2019-09-30' and enc_campo_depar = 2 --301
select * from tba_enc_encuestas where convert(date, enc_fecha_ingreso, 103) = '2019-09-29' and enc_campo_depar = 3 --300
select * from tba_enc_encuestas where convert(date, enc_fecha_ingreso, 103) = '2019-10-02' and enc_campo_depar = 4 --312

-- drop table tba_encu_encuestadores
create table tba_encu_encuestadores(
	encu_codigo int primary key identity (1,1),
	encu_carnet varchar(16),
	encu_nombre_completo varchar(125),
	encu_telefono varchar(20)
)
-- select * from tba_encu_encuestadores
insert into tba_encu_encuestadores(encu_carnet, encu_nombre_completo, encu_telefono)
values ('00-0000-0000', 'encuestador_generico', ''), 
('00-0000-0001', 'Tania Juarez Gamero', '7666-1744'), ('00-0000-0002', 'Cristina del Rosario Orellana Gomez', '7008-0166'), 
('00-0000-0003', 'Ana Elena Rodriguez', '6138-0154'), ('00-0000-0004', 'Gloria Mercedez Cartagena', '7182-4185'), 
('00-0000-0005', 'Ana Veronica Alvarenga', '7797-3288'), ('00-0000-0006', 'Jessica Ivon Perez Velasco', ''), 
('00-0000-0007', 'Griselda', ''), ('00-0000-0008', 'Joyce Yessenia Velasco', ''), 
('00-0000-0009', 'Ana Guadalupe', ''), ('00-0000-0010', 'Tatiana Jeanette Cruz Lemus', '7379-0566'), 
('00-0000-0011', 'Edith del Carmen Ramos Polanco', '7779-4183'), ('00-0000-0012', 'Kenia Esthefany Coreas Rivas', '6189-7421'), 
('00-0000-0013', 'Gloria Gisselle Lopez', ''), ('00-0000-0014', 'Karen Maritza Medrano Mejia', '6014-6813'),
('22-3045-2018', 'Nelson Vladimir Monterrosa Arteaga', '7662-5320'), ('00-0000-0017', 'Karla', ''),
('22-3042-2018', 'Christian Aldair Reyes Dominguez', '7619-1271'), ('25-0064-2018', 'Andy Ernesto Mart�nez Mejia', '7906-7324')
 
select  sexo, enc_campo_depar, case enc_campo_depar when 1 then 'San Salvador' when 2 then 'Santa Ana' when 3 then 'Sonsonate' when 4 then 'San Miguel' end 'Departamento', count(1) 'Total' from (
	select case enc_campo_hombre when 1 then 'M' else 'F' end 'sexo', enc_campo_depar from tba_enc_encuestas
) as tab
group by sexo, enc_campo_depar
order by enc_campo_depar

select fecha, enc_carnet, encu_nombre_completo, encu_telefono/*, sexo*/,case enc_campo_depar when 1 then 'San Salvador' when 2 then 'Santa Ana' when 3 then 'Sonsonate' when 4 then 'San Miguel' end 'Departamento', count(1) 'Total' from (
	select case enc_campo_hombre when 1 then 'M' else 'F' end 'sexo', enc_campo_depar, enc_carnet, encu_nombre_completo, encu_telefono,  convert(date, enc_fecha_ingreso, 103) 'fecha'
	from tba_enc_encuestas 
	left join tba_encu_encuestadores on encu_carnet = enc_carnet
	--where  enc_campo_depar = 4 and convert(date, enc_fecha_ingreso, 103) = '2019-10-02'
) as tab
group by enc_carnet, enc_campo_depar, encu_nombre_completo, encu_telefono, fecha--, sexo
order by fecha, enc_carnet

select  * from tba_enc_encuestas where convert(date, enc_fecha_ingreso, 103) = '2019-10-01'

select convert(date, enc_fecha_ingreso, 103) 'fecha', count(1) 'total' from tba_enc_encuestas group by convert(date, enc_fecha_ingreso, 103) order by convert(date, enc_fecha_ingreso, 103) asc

select ROW_NUMBER() over(order by enc_carnet asc) , * from tba_enc_encuestas where enc_carnet = '22-2222-2205'

select * from tba_res_respuestas where res_codenc in ((select enc_codigo  from tba_enc_encuestas)) and res_codpre = '1' AND res_codopc <> 4



ALTER procedure [dbo].[sp_resultados_tba]
	-- sp_resultados_tba 1, 2 --Cantidad de encuestas segun @codtba
	-- sp_resultados_tba 2, 2 --Cantidad de respuestas por categorias de @codtba
	-- sp_resultados_tba 4, 2 --winners de @codtba
	-- sp_resultados_tba 5, 2 --Tablas de frecuenia de todas las preguntas "cerradas" de @codtba
	-- sp_resultados_tba 6, 2 --Tablas de frecuenia de todas las preguntas "abiertas" de @codtba
	-- sp_resultados_tba 7, 2 --Base de datos pivoteada de preguntas "cerradas" del @codtba
	-- sp_resultados_tba 8, 2 --Base de datos pivoteada de preguntas "abiertas" del @codtba
	-- sp_resultados_tba 9, 2 --Reporte de tiempos de los encuestadores segun el @codtba
	@opcion int,
	@codtba int
as
begin
	-----------------DESDE AQUI SE SACAN LAS QUERYS PARA LOS RESULTADOS-----------------
	if @opcion = 1--Encuestas total
	begin
		declare @cont int
		select @cont = count(1) from tba_enc_encuestas where enc_codtba = @codtba
		select isnull(@cont, 0)
	end

	if @opcion = 2 --Respuestas por categorias
	begin
		/*
			1	San Salvador
			2	Santa Ana
			3	Sonsonate
			4	San Miguel
		*/
		declare @recuento_general_h_m as table (pre_cod tinyint, pre_codigo varchar(6), pre_pregunta varchar(255), enc_campo_depar int,	cont_homb int, cont_muj int)
		insert into @recuento_general_h_m
		select pre_cod, pre_codigo, pre_pregunta, enc_campo_depar, sum(enc_campo_hombre) 'cont_homb', sum(enc_campo_mujer) 'cont_muj' 
		from (
			select enc_codigo, pre_cod, pre_codigo, pre_pregunta, res_codopc, enc_campo_hombre, enc_campo_mujer, enc_campo_depar
			from tba_res_respuestas as res
			inner join tba_pre_preguntas on pre_codigo = res_codpre
			inner join tba_cat_categorias on cat_codigo = pre_codcat and cat_codtba = 2
			inner join tba_enc_encuestas on enc_codigo = res_codenc
			where res_codpre in (select concat('C_', cat_codigo) from tba_cat_categorias where cat_codigo > 0) and res_codopc = 40
			/*union all
			select enc_codigo, pre_cod, pre_codigo, pre_pregunta, res_codopc, enc_campo_hombre, enc_campo_mujer, enc_campo_depar
			from tba_res_respuestas as res
			inner join tba_pre_preguntas on pre_codigo = res_codpre
			inner join tba_cat_categorias on cat_codigo = pre_codcat and cat_codtba = 2
			inner join tba_enc_encuestas on enc_codigo = res_codenc
			where res_codpre in (select concat('C_', cat_codigo) from tba_cat_categorias where cat_codigo > 0 and cat_codigo = 28)*/
		) as datos
		group by pre_cod, pre_codigo, pre_pregunta, enc_campo_depar

		declare @recuento_categorias_mujeres as table (pre_cod int, pre_codigo varchar(10), pre_pregunta varchar(50), muj_san_salvador int, muj_santaana int, muj_sonsonate int, muj_san_miguel int)
		insert into @recuento_categorias_mujeres
		select pre_cod, pre_codigo, pre_pregunta, sum(isnull([1], 0)) 'san sa', sum(isnull([2], 0)) 'san mi', sum(isnull([3], 0)) 'sonso', sum(isnull([4], 0)) 'chi' from (
			select pre_cod, pre_codigo, pre_pregunta, [1], [2], [3], [4] from (
				select pre_cod, pre_codigo, pre_pregunta, enc_campo_depar, cont_muj from @recuento_general_h_m
				--order by pre_cod asc
			) as dat
			pivot (sum(cont_muj) for enc_campo_depar in ([1], [2], [3], [4])) p
		) as da
		group by pre_cod, pre_codigo, pre_pregunta
		
		declare @recuento_categorias_hombres as table (pre_cod int, pre_codigo varchar(10), pre_pregunta varchar(50), hom_san_salvador int, hom_santaana int, hom_sonsonate int, hom_san_miguel int)
		insert into @recuento_categorias_hombres
		select pre_cod, pre_codigo, pre_pregunta, sum(isnull([1], 0)), sum(isnull([2], 0)), sum(isnull([3], 0)), sum(isnull([4], 0)) from (
			select pre_cod, pre_codigo, pre_pregunta, [1], [2], [3], [4] from (
				select pre_cod, pre_codigo, pre_pregunta, enc_campo_depar, cont_homb from @recuento_general_h_m
			) as dat
			pivot (sum(cont_homb) for enc_campo_depar in ([1], [2], [3], [4])) p
		) as da
		group by pre_cod, pre_codigo, pre_pregunta

		select row_number() over(order by h.pre_cod) 'N!'/*, h.pre_codigo,*/, h.pre_pregunta 'Categoria', 
		(h.hom_san_salvador + h.hom_santaana + h.hom_sonsonate + h.hom_san_miguel + m.muj_san_salvador + m.muj_santaana + m.muj_sonsonate + m.muj_san_miguel) 'Tot.general',
		(h.hom_san_salvador + h.hom_santaana + h.hom_sonsonate + h.hom_san_miguel)'Tot.H',
		(m.muj_san_salvador + m.muj_santaana + m.muj_sonsonate + m.muj_san_miguel)'Tot.M',
		h.hom_san_salvador 'H. San Salvador', m.muj_san_salvador 'M. San Salvador',
		h.hom_santaana 'H. Santa Ana', m.muj_santaana 'M. Santa Ana',
		h.hom_sonsonate 'H. Sonsonate', m.muj_sonsonate 'M. Sonsonate', 
		h.hom_san_miguel 'H. San Miguel', m.muj_san_miguel 'M. San Miguel'
		from @recuento_categorias_hombres as h 
		inner join @recuento_categorias_mujeres as m on h.pre_cod = m.pre_cod
	end
	--select * from tba_res_respuestas where res_codpre in ('37','38','39','40','41','42') and res_codopc in ('11', '12', '13')
	--update tba_res_respuestas set res_codopc = '543' where res_codpre in ('37','38','39','40','41','42') and res_codopc in ('14')
	--update tba_res_respuestas set res_codopc = '544' where res_codpre in ('37','38','39','40','41','42') and res_codopc in ('12')
	--update tba_res_respuestas set res_codopc = '545' where res_codpre in ('37','38','39','40','41','42') and res_codopc in ('13')
	-- select * from tba_res_respuestas where res_codpre in ('37','38','39','40','41','42') and res_codopc in ('14')
	--update tba_res_respuestas set res_codopc = '543' where res_codpre in ('37','38','39','40','41','42') and res_codopc in ('14')
	--update tba_res_respuestas set res_codopc = '544' where res_codpre in ('37','38','39','40','41','42') and res_codopc in ('12')
	--update tba_res_respuestas set res_codopc = '545' where res_codpre in ('37','38','39','40','41','42') and res_codopc in ('13')
	if @opcion = 3--Encuestas por realizadas por encuestador
	begin
		select enc_carnet 'Codigo encuestador', encu_nombre_completo, encu_telefono, count(1) 'Encuestas realizadas' 
		from tba_enc_encuestas
		left join tba_encu_encuestadores on encu_carnet = enc_carnet
		where enc_codtba = @codtba
		group by enc_carnet, encu_nombre_completo, encu_telefono
	end

	if @opcion = 4--Winners TBA2019
	begin
		declare @tb_totales as table(tb_categoria varchar(55), tom1 int, tom2 int, tom3 int, tom4 int, TOM INT, pm int, icf int, total int)
		insert into @tb_totales
		select totales.Categoria, sum(totales.[TOM 1]) 'TOM 1', sum(totales.[TOM 2]) 'TOM 2', sum(totales.[TOM 3]) 'TOM 3', sum(totales.[TOM 4]) 'TOM 4', 
		(sum(totales.[TOM 1]) + sum(totales.[TOM 2]) + sum(totales.[TOM 3]) + sum(totales.[TOM 4]) ) 'tom',
		sum(totales.[PM]) 'PM', sum(totales.[ICF]) 'ICF', sum(totales.TOTAL) 'total' from (
		select [1] 'TOM 1', [2] 'TOM 2', [3] 'TOM 3', [4] 'TOM 4', [5] 'PM', [6] 'ICF', [1] + [2] + [3] + [4] + [5] + [6] 'TOTAL', cat_categoria 'Categoria' from (
			select cat_codigo ,cat_categoria, opc_opcion, opc_codigo, pre_orden, 1 contador from tba_res_respuestas
			inner join tba_pre_preguntas on pre_codigo = res_codpre
			inner join tba_cat_categorias on cat_codigo = pre_codcat and cat_codtba = 2
			inner join tba_opc_opciones on opc_codigo = res_codopc
			where pre_codigo in (select pre_codigo from tba_cat_categorias inner join tba_pre_preguntas on pre_codcat = cat_codigo and cat_codigo > 0 and cat_codtba = 2)
			and res_codopc not in ('543', '544', '545', '546', '547', '548', '549', '550', '551', '519')
		) as datos
		pivot (count(contador) for pre_orden in ([1], [2], [3], [4], [5], [6])) p
		) totales
		group by totales.Categoria

		select opc_opcion 'Marca', 
		[1] 'TOM 1',  cast((cast([1] as real) / cast((select tom1 from @tb_totales as tb where tb.tb_categoria = cat_categoria) as real)) as real) 'TOM 1 %',
		[2] 'TOM 2', cast((cast([2] as real)  / (select tom2 from @tb_totales as tb where tb.tb_categoria = cat_categoria)) as real) 'TOM 2 %',
		[3] 'TOM 3',  cast(((cast([3] as real)  / (select tom3 from @tb_totales as tb where tb.tb_categoria = cat_categoria))) as real) 'TOM 3 %',
		[4] 'TOM 4', cast(((cast([4] as real)  / (select tom4 from @tb_totales as tb where tb.tb_categoria = cat_categoria))) as real) 'TOM 4 %',
		[1] + [2] + [3] + [4] 'TOM', cast(((cast(([1] + [2] + [3] + [4]) as real)  / (select tom from @tb_totales as tb where tb.tb_categoria = cat_categoria))) as real) 'TOM %',
		[5] 'PM',  cast(((cast([5] as real)  / (select pm from @tb_totales as tb where tb.tb_categoria = cat_categoria))) as real) 'PM %',
		[6] 'ICF',  cast(((cast([6] as real)  / (select icf from @tb_totales as tb where tb.tb_categoria = cat_categoria))) as real) 'ICF %',
		[1] + [2] + [3] + [4] + [5] + [6] 'TOTAL', 
		cat_categoria 'Categoria' from (
			select cat_codigo ,cat_categoria, opc_opcion, opc_codigo, pre_orden, 1 contador from tba_res_respuestas
			inner join tba_pre_preguntas on pre_codigo = res_codpre
			inner join tba_cat_categorias on cat_codigo = pre_codcat and cat_codtba = 2
			inner join tba_opc_opciones on opc_codigo = res_codopc
			
			where pre_codigo in (select pre_codigo from tba_cat_categorias inner join tba_pre_preguntas on pre_codcat = cat_codigo and cat_codigo > 0 and cat_codtba = 2)
			and res_codopc not in ('543', '544', '545', '546', '547', '548', '549', '550', '551', '519') --and opc_opcion = 'Sudagrip'
		) as datos
		pivot (count(contador) for pre_orden in ([1], [2], [3], [4], [5], [6])) p
		order by cat_codigo, [total] desc
	end

	if @opcion = 5 --Tablas de frecuencias preguntas cerradas
	begin
		declare @tabla_detalle as table (pre_codigo varchar(5), num_opc_total int, Total int)
		insert into @tabla_detalle
		select pre_codigo, count(distinct opc_opcion) 'num_opc_total', count(1) 'Total'
		from tba_res_respuestas
			inner join tba_pre_preguntas on pre_codigo = res_codpre
			inner join tba_cat_categorias on cat_codigo = pre_codcat and cat_codtba = 2
			inner join tba_opc_opciones on opc_codigo = res_codopc 
			inner join tba_enc_encuestas on enc_codigo = res_codenc
		--where res_codenc in (select enc_codigo  from tba_enc_encuestas where enc_campo_depar = 4)
		group by pre_cod, cat_codigo, cat_categoria, pre_codigo , pre_pregunta, pre_orden,enc_campo_depar
		--order by cat_codigo, pre_cod, pre_orden asc

		select pre_cod, cat_codigo, cat_categoria, pre_codigo, pre_pregunta, row_number() over (partition by pre_pregunta order by opc_opcion) opc_num,  num_opc_total, opc_opcion, pre_orden, sum(isnull([1], 0)) 'San_Salvador', sum(isnull([2], 0)) 'Santa_Ana', sum(isnull([3], 0)) 'Sonsonate', sum(isnull([4], 0)) 'San_Miguel', 
		sum(isnull([1], 0)) + sum(isnull([2], 0)) + sum(isnull([3], 0))  + sum(isnull([4], 0)) 'Cantidad',
		Total 
		from (
			select pre_cod, cat_codigo, cat_categoria, pre_codigo, pre_pregunta, 1 'opc_num',  num_opc_total, opc_opcion, pre_orden, [1], [2], [3], [4], Total from (
			select enc_campo_depar, pre_cod,cat_codigo, cat_categoria, p.pre_codigo , p.pre_pregunta, row_number() over (partition by pre_pregunta order by opc_opcion) opc_num, t.num_opc_total, opc_opcion, p.pre_orden, count(1) 'Cantidad', t.Total
			from tba_res_respuestas
				inner join tba_pre_preguntas as p on pre_codigo = res_codpre
				inner join tba_cat_categorias on cat_codigo = pre_codcat and cat_codtba = 2
				inner join tba_opc_opciones on opc_codigo = res_codopc
				inner join @tabla_detalle as t on t.pre_codigo = p.pre_codigo
				inner join tba_enc_encuestas on enc_codigo = res_codenc
			where p.pre_codigo not in('0') --and res_codenc in (select enc_codigo  from tba_enc_encuestas where enc_campo_depar = 4)
			group by pre_cod, cat_codigo, cat_categoria, p.pre_codigo , pre_pregunta, opc_opcion, pre_orden, t.Total, t.num_opc_total, enc_campo_depar
			--order by cat_codigo, pre_cod, pre_orden, opc_opcion asc
			) x pivot (sum(Cantidad) for enc_campo_depar in ([1], [2], [3], [4])) p
			--order by cat_codigo, pre_cod, pre_orden, opc_opcion asc
		) tab
		group by pre_cod, cat_codigo, cat_categoria, pre_codigo, pre_pregunta,  num_opc_total, opc_opcion, pre_orden, Total
		order by pre_cod asc
	end

	if @opcion =  6 --Tablas de frecuencias preguntas abiertas
	begin
		declare @tabla_detalle_abiertas as table (pre_codigo varchar(5), num_opc_total int, Total int)
		insert into @tabla_detalle_abiertas
		select pre_codigo, count(distinct resa_detalle_respuesta) 'num_opc_total', count(1) 'Total' --pre_cod, cat_codigo, cat_categoria, pre_codigo , pre_pregunta, opc_opcion, pre_orden,  count(1) 'Cantidad' 
		from tba_resa_respuestas_abiertas
			inner join tba_pre_preguntas on pre_codigo = resa_codpre
			inner join tba_cat_categorias on cat_codigo = pre_codcat and cat_codtba = 2
			
		--where pre_codigo in (select pre_codigo from tba_cat_categorias inner join tba_pre_preguntas on pre_codcat = cat_codigo and cat_codigo > 0 and cat_codtba = 2)
		--where pre_codigo in('1', '2', '3')
		where resa_codenc in (select enc_codigo  from tba_enc_encuestas where enc_campo_depar = 4)--pre_cod < 50 --not in('5', '10')--and p.pre_codigo in('53''54','55')
		group by pre_cod, cat_codigo, cat_categoria, pre_codigo , pre_pregunta, pre_orden
		order by cat_codigo, pre_cod, pre_orden asc

		select p.pre_cod, p.pre_codigo,cat_codigo, cat_categoria, p.pre_pregunta, row_number() over (partition by pre_pregunta order by resa_detalle_respuesta) opc_num, t.num_opc_total, resa_detalle_respuesta 'opc_opcion', p.pre_orden, count(1) 'Cantidad', t.Total 
		from tba_resa_respuestas_abiertas
			inner join tba_pre_preguntas as p on pre_codigo = resa_codpre
			inner join tba_cat_categorias on cat_codigo = pre_codcat and cat_codtba = 2
			inner join @tabla_detalle_abiertas as t on t.pre_codigo = p.pre_codigo
		--where pre_codigo in (select pre_codigo from tba_cat_categorias inner join tba_pre_preguntas on pre_codcat = cat_codigo and cat_codigo > 0 and cat_codtba = 2)
		--where p.pre_codigo in ('1', '2', '3')
		where resa_codenc in (select enc_codigo  from tba_enc_encuestas where enc_campo_depar = 4)--pre_cod < 50 --not in('5', '10')--and p.pre_codigo in('53''54','55')
		group by p.pre_cod, cat_codigo, cat_categoria, resa_detalle_respuesta, p.pre_orden, p.pre_pregunta, t.Total, t.num_opc_total, p.pre_codigo
		order by cat_codigo, pre_cod, pre_orden asc
	end

	if @opcion = 7--Base de datos pivoteada
	begin
		--PREGUNTAS CERRADAS
		DECLARE @cols nvarchar(MAX);
		SET @cols = stuff((select  concat('|',pre_codigo , '. ', pre_pregunta)   from tba_pre_preguntas inner join tba_cat_categorias  on pre_codcat = cat_codigo and cat_codtba = @codtba and pre_codigo not in('0', '10', '12', '12_1'/*, 'C_11'*/) order by pre_cod for xml path(''), type).value('.', 'nvarchar(max)'), 1, 1, '');
		select '0' 'codenc',concat('|',@cols, '|enc_carnet','|enc_fecha_ingreso',  '|enc_tiempo_realizacion', '|enc_fecha_creacion') 'cols'
		union
		select cast(enc.enc_codigo  as varchar(25)), 
		 concat('|',stuff((select concat('|',isnull(opc_opcion, 'NULL')) from tba_pre_preguntas
		 left join tba_res_respuestas on res_codpre = pre_codigo and res_codenc = enc.enc_codigo
		 left join tba_opc_opciones on opc_codigo = res_codopc
		 left join tba_cat_categorias on cat_codigo = pre_codcat and cat_codtba = @codtba
		 where pre_codigo not in('0', '10', '12', '12_1'/*, 'C_11'*/)
		 order by pre_cod
		 for xml path('')),1,1, ''), '|'+cast(enc.enc_carnet as varchar(12)), '|'+cast(enc.enc_fecha_ingreso as varchar(25)), '|'+cast(enc.enc_tiempo_realizacion  as varchar(12)), '|'+cast(enc.enc_fecha_creacion as varchar(25))) 'cols'
		from tba_enc_encuestas as enc
		
		order by 'codenc'
	end
	if @opcion = 8--Base de datos pivoteada
	begin
		--PREGUNTAS ABIERTAS
		DECLARE @cols_ nvarchar(MAX);
		SET @cols_ = stuff((select  concat('|',pre_codigo , '. ', pre_pregunta)   from tba_pre_preguntas inner join tba_cat_categorias  on pre_codcat = cat_codigo and cat_codtba = 2 and pre_codigo not in('0', '10', '12', '12_1'/*, 'C_11'*/) order by pre_cod for xml path(''), type).value('.', 'nvarchar(max)'), 1, 1, '');
		select '0' 'codenc',concat('|',@cols_, '|enc_carnet','|enc_fecha_ingreso',  '|enc_tiempo_realizacion', '|enc_fecha_creacion') 'cols'
		union
		select cast(enc.enc_codigo  as varchar(25)), 
		 concat('|',stuff((select concat('|',isnull(resa_detalle_respuesta, 'NULL')) from tba_pre_preguntas
		 left join tba_resa_respuestas_abiertas on resa_codpre = pre_codigo and resa_codenc = enc.enc_codigo
		 --left join tba_opc_opciones on opc_codigo = res_codopc
		 left join tba_cat_categorias on cat_codigo = pre_codcat and cat_codtba = @codtba
		 where pre_codigo not in('0', '10', '12', '12_1'/*, 'C_11'*/)
		 order by pre_cod
		 for xml path('')),1,1, ''), '|'+cast(enc.enc_carnet as varchar(12)), '|'+cast(enc.enc_fecha_ingreso as varchar(25)), '|'+cast(enc.enc_tiempo_realizacion  as varchar(12)), '|'+cast(enc.enc_fecha_creacion as varchar(25))) 'cols'
		from tba_enc_encuestas as enc
		order by 'codenc'
	end
	
	if @opcion = 9
	begin
		select enc_codigo 'codenc', row_number() over (partition by enc_carnet order by enc_carnet) 'Enc. realizada Numero', enc_carnet 'Codigo encuestador', enc_fecha_ingreso 'Fecha/Hora realizo encuesta', 
		enc_tiempo_realizacion 'Tiempo demorado', SUBSTRING(enc_tiempo_realizacion, 1, 2) 'Horas', SUBSTRING(enc_tiempo_realizacion, 4, 2) 'Minutos', SUBSTRING(enc_tiempo_realizacion, 7, 2) 'Segundos', concat(SUBSTRING(enc_tiempo_realizacion, 10, 2), 0) 'Milisegundos ',
		enc_fecha_creacion 'Fecha sincronizacion', concat(tba_descripcion, ' ', tba_anio) 'Encuesta', enc_contador 'contador'
		from tba_enc_encuestas
		inner join ciops_tba_top_brand_awards on tba_codigo = enc_codtba
		where enc_codtba = 2
		order by enc_carnet, enc_fecha_ingreso
	end
end

--CREATE TABLE [dbo].[tba_enc_encuestas_backup](
--	[enc_codigo] [int] NOT NULL,
--	[enc_carnet] [varchar](15) NULL,
--	[enc_fecha_ingreso] [datetime] NULL,
--	[enc_tiempo_realizacion] [varchar](16) NULL,
--	[enc_fecha_creacion] [datetime] NULL,
--	[enc_codtba] [int] NULL,
--	[enc_campo_hombre] [tinyint] NULL,
--	[enc_campo_mujer] [tinyint] NULL,
--	[enc_campo_depar] [varchar](10) NULL,
--	[enc_contador] [int] NULL
--)

--CREATE TABLE [dbo].[tba_res_respuestas_backup](
--	[res_codpre] [varchar](125) NULL,
--	[res_codopc] [int] NULL,
--	[res_codenc] [int] NULL,
--	[res_contador] [int] NULL
--) ON [PRIMARY]
--GO
--ALTER TABLE [dbo].[tba_res_respuestas_backup] ADD  DEFAULT ((1)) FOR [res_contador]
--GO
--ALTER TABLE [dbo].[tba_res_respuestas_backup]  WITH CHECK ADD FOREIGN KEY([res_codpre])
--REFERENCES [dbo].[tba_pre_preguntas] ([pre_codigo])
--GO
--ALTER TABLE [dbo].[tba_res_respuestas_backup]  WITH CHECK ADD FOREIGN KEY([res_codopc])
--REFERENCES [dbo].[tba_opc_opciones] ([opc_codigo])
--GO
--ALTER TABLE [dbo].[tba_res_respuestas_backup]  WITH CHECK ADD FOREIGN KEY([res_codenc])
--REFERENCES [dbo].[tba_enc_encuestas] ([enc_codigo])
--GO

--CREATE TABLE [dbo].[tba_resa_respuestas_abiertas_backup](
--	[resa_codpre] [varchar](125) NULL,
--	[resa_detalle_respuesta] [varchar](125) NULL,
--	[resa_codenc] [int] NULL,
--	[resa_contador] [int] NULL
--) ON [PRIMARY]
--GO
--ALTER TABLE [dbo].[tba_resa_respuestas_abiertas_backup] ADD  DEFAULT ((1)) FOR [resa_contador]
--GO
--ALTER TABLE [dbo].[tba_resa_respuestas_abiertas_backup]  WITH CHECK ADD FOREIGN KEY([resa_codpre])
--REFERENCES [dbo].[tba_pre_preguntas] ([pre_codigo])
--GO
--ALTER TABLE [dbo].[tba_resa_respuestas_abiertas_backup]  WITH CHECK ADD FOREIGN KEY([resa_codenc])
--REFERENCES [dbo].[tba_enc_encuestas] ([enc_codigo])
--GO

/*
	1	San Salvador -- 2019-09-28 y 2019-10-01
	2	Santa Ana    -- 2019-09-30
	3	Sonsonate    -- 2019-09-29
	4	San Miguel   -- 2019-10-02
*/

select opc_opcion, count(1) from tba_res_respuestas
inner join tba_pre_preguntas on pre_codigo = res_codpre
inner join tba_opc_opciones on opc_codigo = res_codopc
where res_codpre = '1'
group by opc_opcion 

select  case enc_campo_depar when 1 then 'San Salvador' when 2 then 'Santa Ana' when 3 then 'Sonsonate' when 4 then 'San Miguel' end 'Departamento', count(1) 'Total' from (
	select case enc_campo_hombre when 1 then 'M' else 'F' end 'sexo', enc_campo_depar from tba_enc_encuestas
) as tab
group by enc_campo_depar
order by enc_campo_depar

select * from tba_res_respuestas
inner join tba_pre_preguntas on pre_codigo = res_codpre
inner join tba_opc_opciones on opc_codigo = res_codopc
where res_codpre = '1' and res_codopc = '1'

select * from  tba_res_respuestas where res_codpre = '6' and res_codopc = '20'
select distinct res_codenc from  tba_res_respuestas 
inner join tba_pre_preguntas on pre_codigo = res_codpre
inner join tba_opc_opciones on opc_codigo = res_codopc
where res_codpre in('13', '14', '15', '16', '17', '18') and res_codopc not in(543, 544, 545, 547)