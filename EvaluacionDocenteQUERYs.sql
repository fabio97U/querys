--drop table emer_enc_encuestas
create table emer_enc_encuestas (
	enc_codigo int primary key identity(1, 1),
	enc_nombre varchar(255),
	enc_codpon int,
	enc_codcil int,
	enc_codtde int, --tipo de estudio dirigida
	enc_objetivo varchar(1024),
	enc_fecha_inicio date,
	enc_fecha_fin date,
	enc_fecha_creacion datetime default getdate()
)
insert into emer_enc_encuestas
(enc_nombre, enc_codpon, enc_codcil, enc_codtde, enc_objetivo, enc_fecha_inicio, enc_fecha_fin)
values ('Cuestionario para evaluaci�n del desempe�o docente Ciclo 01-2020', 5, 122, 1, 'Evaluar la metodolog�a implementada por la universidad para adaptar el proceso educativo durante la cuarentena.', '2020-05-24', '2020-06-10')

select * from emer_enc_encuestas

--drop table emer_grupe_grupos_estudio
create table emer_grupe_grupos_estudio(
	grupe_codigo int primary key identity(1, 1),
	grupe_nombre varchar(255),
	grupe_codenc int,
	grupe_orden int,
	grupe_fecha_creacion datetime default getdate()
)
insert into emer_grupe_grupos_estudio (grupe_nombre, grupe_orden, grupe_codenc) values
('INDICADOR  CONECTIVIDAD Y SERVICIOS WEB', 1, 1), ('INDICADOR CALIDAD DOCENTE', 2, 1), ('INDICADOR ORGANIZACI�N DEL PROCESO DE ENSE�ANZA APRENDIZAJE', 3, 1), ('INDICADOR METODOLOG�A', 4, 1), ('INDICADOR EVALUACI�N DE LOS APRENDIZAJES', 5, 1)
select * from emer_grupe_grupos_estudio

--drop table emer_tipp_tipo_preguntas
create table emer_tipp_tipo_preguntas (
	tipp_codigo int primary key identity(1, 1),
	tipp_tipo varchar(50),--C: cerrada, M: multiple, A: abierta, CC: con cascada
	tipp_descripcion varchar(255),
	tipp_fecha_creacion datetime default getdate()
)
insert into emer_tipp_tipo_preguntas (tipp_tipo, tipp_descripcion) values ('C', 'Es una pregunta con respuestas cerradas'), ('M', 'Es una pregunta con respuestas multiples'), ('A', 'Es una pregunta con respuesta abierta')
select * from emer_tipp_tipo_preguntas

--drop table emer_pre_preguntas
create table emer_pre_preguntas (
	pre_codigo int primary key identity(1, 1),
	pre_codtipp int,
	pre_codgrupe int,
	pre_orden_general int, -- numero de pregunta en la encuesta
	pre_orden int, -- numero de pregunta en el grupo
	pre_pregunta varchar(1024),
	pre_fecha_creacion datetime default getdate()
)
insert into emer_pre_preguntas (pre_codtipp, pre_codgrupe, pre_orden_general, pre_orden, pre_pregunta) values
(1, 1, 1, 1, '�Desde qu� dispositivo (s) accede a sus clases?'),
(1, 1, 2, 2, '�Desde qu� lugar accede con m�s frecuencia a sus clases?'),
(1, 1, 3, 3, '�Qu� tipo de internet posee para conectarse a sus clases? (responda si es internet residencial la velocidad que posee y si es a trav�s de m�vil que tipo)'),
(1, 1, 4, 4, '�Qu� plataforma utiliza su maestro para la continuidad de sus clases?'),
(1, 1, 5, 5, '�La calidad de la conectividad que usted utiliza, es adecuada para el uso de los recursos digitales?.'),
(1, 1, 6, 6, '�Tiene dificultades para el ingreso a la plataforma y a los recursos que esta ofrece?:'),
(1, 1, 7, 7, '�Cu�l plataforma considera  id�nea para recibir sus clases?'),

(1, 2, 8, 1,'�El contenido de las clases est� acorde en cuanto a la cantidad de actividades o tareas asignadas?'),
(1, 2, 9, 2,'Hasta el momento �C�mo eval�a el desempe�o del docente?'),
(1, 2, 10, 3, '�El nivel de exigencia acad�mica del docente est� acorde a los contenidos de la materia?'),
(1, 2, 11, 4, '�C�mo considera la carga acad�mica que el docente le asigna en esta materia?'),
(1, 2, 12, 5, '�El docente muestra dominio en el uso de tecnolog�a o plataformas para impartir la clase?'),
(2, 2, 13, 6, '�Por qu� medio de comunicaci�n digital o plataforma recibe apoyo o retroalimentaci�n del docente? (puede marcar m�s de una opci�n)'),
(2, 2, 14, 7, 'De las siguientes opciones, marque aquellas que el docente necesita mejorar en la forma de impartir sus clases:'),

(1, 3, 15, 1, '�Su docente desarrolla la clase en l�nea en el horario asignado?'),

(1, 4, 16, 1, 'Si el recurso lo permite, �con qu� frecuencia el docente deja grabada su clase en las diferentes plataformas que utiliza?'),

(1, 5, 17, 1, '�Qu� plataforma o medio utiliza su docente para realizar las evaluaciones?')
select * from emer_pre_preguntas

--drop table emer_tipo_tipo_opciones
create table emer_tipo_tipo_opciones (
	tipo_codigo int primary key identity(1, 1),
	tipo_tipo varchar(50),--c: cerrada, a: abierta, 
	tipo_descripcion varchar(255),
	tipo_fecha_creacion datetime default getdate()
)
insert into emer_tipo_tipo_opciones (tipo_tipo, tipo_descripcion) values ('c', 'Es una opci�n de respuesta cerrada'), ('a', 'Es una opci�n de respuesta abierta')
select * from emer_tipo_tipo_opciones

--drop table emer_opc_opciones
create table emer_opc_opciones (
	opc_codigo int primary key identity(1, 1),
	opc_codenc int,
	opc_opcion varchar(255),
	opc_fecha_creacion datetime default getdate()
)
insert into emer_opc_opciones (opc_codenc, opc_opcion) values
(1, 'Laptop'), (1, 'PC de escritorio'), (1, 'Tel�fono celular'), (1, 'Tablet'), (1, 'Otro:  �Cu�l?'), (1, 'Hogar'), (1, 'Cyber caf�'), (1, 'Trabajo'), (1, 'Vecinos'), (1, 'Otra:  �Cu�l?'), (1, 'Internet residencial'), (1, 'Datos M�viles'), (1, 'Moodle'), (1, 'Blackboard'), (1, 'Zoom'), (1, 'Google meet'), (1, 'Google class'), (1, 'Office 365 - Teams'), (1, 'Si'), (1, 'No'), (1, 'Siempre'), (1, 'A veces'), (1, 'Nunca'), (1, 'Excelente'), (1, 'Muy bueno'), (1, 'Bueno'), (1, 'Regular'), (1, 'Necesita mejorar'), (1, 'Mucha'), (1, 'Adecuada'), (1, 'Poca'), (1, 'Correo electr�nico'), (1, 'Foro'), (1, 'Chat'), (1, 'Aula de apoyo'), (1, 'Metodolog�a'), (1, 'Uso de recursos'), (1, 'Sistema de evaluaci�n'), (1, 'Interacci�n con el estudiante'), (1, 'Office Forms'), (1, 'Google Forms'), (1, 'Cuestionario en aula virtual'), (1, 'Cuestionario o gu�as de trabajo enviadas por correo electr�nico')
select * from emer_opc_opciones

--drop table emer_preopc_preguntas_opciones
create table emer_preopc_preguntas_opciones (
	preopc_codigo int primary key identity(1, 1),
	preopc_codpre int,
	preopc_codopc int,
	preopc_codtipo int,
	preopc_opc_orden int,
	preopc_fecha_creacion datetime default getdate()
)
insert into emer_preopc_preguntas_opciones (preopc_codpre, preopc_codopc, preopc_codtipo, preopc_opc_orden) values
(1, 1, 1, 1), 
(1, 2, 1, 2), 
(1, 3, 1, 3), 
(1, 4, 1, 4), 
(1, 5, 2, 5), 
(2, 6, 1, 1), 
(2, 7, 1, 2), 
(2, 8, 1, 3), 
(2, 9, 1, 4), 
(2, 10, 2, 5), 
(3, 11, 2, 1), 
(3, 12, 2, 2), 
(4, 13, 1, 1), 
(4, 14, 1, 2), 
(4, 15, 1, 3), 
(4, 16, 1, 4), 
(4, 17, 1, 5), 
(4, 18, 1, 6), 
(4, 10, 2, 7), 
(5, 19, 1, 1), 
(5, 20, 1, 2), 
(6, 21, 1, 1), 
(6, 22, 1, 2), 
(6, 23, 1, 3), 
(7, 13, 1, 1), 
(7, 14, 1, 2), 
(7, 15, 1, 3), 
(7, 16, 1, 4), 
(7, 17, 1, 5), 
(7, 18, 1, 6), 
(7, 10, 2, 7), 
(8, 21, 1, 1), 
(8, 22, 1, 2), 
(8, 23, 1, 3), 
(9, 24, 1, 1), 
(9, 25, 1, 2), 
(9, 26, 1, 3), 
(9, 27, 1, 4), 
(9, 28, 1, 5), 
(10, 19, 1, 1), 
(10, 20, 1, 2), 
(11, 29, 1, 1), 
(11, 30, 1, 2), 
(11, 31, 1, 3), 
(12, 19, 1, 1), 
(12, 20, 1, 2), 
(13, 32, 1, 1), 
(13, 33, 1, 2), 
(13, 34, 1, 3), 
(13, 35, 1, 4), 
(13, 5, 2, 5), 
(14, 36, 1, 1), 
(14, 37, 1, 2), 
(14, 38, 1, 3), 
(14, 39, 1, 4), 
(14, 10, 2, 5), 
(15, 19, 1, 1), 
(15, 20, 1, 2), 
(16, 21, 1, 1), 
(16, 22, 1, 2), 
(16, 23, 1, 3), 
(17, 40, 1, 1), 
(17, 41, 1, 2), 
(17, 42, 1, 3), 
(17, 43, 1, 4), 
(17, 5, 2, 5)
select * from emer_preopc_preguntas_opciones

--drop table emer_encenc_encabezado_encuesta
create table emer_encenc_encabezado_encuesta (
	encenc_codigo int primary key identity(1, 1),
	encenc_codenc int,
	encenc_codper int,
	encenc_codhpl int,
	encenc_codcil int,
	encenc_fecha_creacion datetime default getdate()
)
select * from emer_encenc_encabezado_encuesta

--drop table emer_detenc_detalle_encuesta
create table emer_detenc_detalle_encuesta(
	detenc_codigo int primary key identity(1, 1),
	detenc_codencenc int,
	detenc_codpre int,
	detenc_codopc int,
	detenc_detalle varchar(1024)--Si es abierta se llenara
)
select * from emer_detenc_detalle_encuesta
USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_data_emer_encuestas]    Script Date: 18/3/2022 15:39:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Fabio>
-- Create date: <2020-05-26 00:00:15.267>
-- Description: <Devuelve la data para las encuestas emergencia>
-- =============================================
-- sp_data_emer_encuestas 1, 1, 0, 0, 0
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
			opc_codigo, opc_opcion, preopc_opc_orden, tipo_tipo
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


--drop type tbl_detenc
create type tbl_detenc as table(codpre int, codopc int, detalle varchar(1024));

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_emer_encuestas]    Script Date: 18/3/2022 15:39:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Fabio>
-- Create date: <2020-05-25 23:45:09.797>
-- Description: <Inserta la data para las encuestas hechas para la emergencia>
-- =============================================
-- sp_emer_encuestas 1, 1, default
ALTER procedure [dbo].[sp_emer_encuestas] 
	@opcion int = 0,
	@codenc int = 0,
	@codper int = 0,
	@codhpl int = 0,
	@codcil int = 0,
	--@codpre int = 0,
	--@codopc int = 0,
	--@detalle varchar(1024) = ''
	@tbl_detenc tbl_detenc readonly
as
begin
	if @opcion = 1
	begin
		declare @codencenc int
		insert into emer_encenc_encabezado_encuesta (encenc_codenc, encenc_codper, encenc_codhpl, encenc_codcil)
		values (@codenc, @codper, @codhpl, @codcil)
		select @codencenc = scope_identity()
		
		insert into emer_detenc_detalle_encuesta (detenc_codencenc, detenc_codpre, detenc_codopc, detenc_detalle)
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


USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_resultados_evaluacion]    Script Date: 18/3/2022 15:40:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- rep_resultados_evaluacion 1, 4, 1, 126, 0
ALTER procedure [dbo].[rep_resultados_evaluacion]
	@opcion int = 0,
	@codesc int = 0,
	@codenc int = 0,
	@codcil int = 0,
	@codemp int = 0
as
begin
	if @opcion = 1 --Resultados de las preguntas cerradas
	begin

		declare @nota_hpl as table(
			codhpl int,
			nota float
		)

		insert into @nota_hpl
		select v.hpl_codigo, v.nota from v_emer_notas_docentes v 
		where v.hpl_codcil = @codcil 
		and v.hpl_codesc = case when @codesc <> 0 then @codesc else v.hpl_codesc end

		select concat('0', cil_codcic, '-', cil_anio) 'ciclo', h.hpl_codigo, hpl_codmat, mat_nombre, hpl_descripcion,
			h.hpl_codemp, emp_nombres_apellidos, esc_nombre, fac_nombre,
			grupe_orden, grupe_nombre, pre_orden_general, pre_pregunta, opc_opcion, count(1) cant,
			(select COUNT(encenc_codper) from emer_encenc_encabezado_encuesta em where h.hpl_codigo = em.encenc_codhpl ) tot,--, '%' 'porcentaje'
			(select count(ins_codper) from ra_ins_inscripcion
					inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
					inner join ra_hpl_horarios_planificacion p on p.hpl_codigo = mai_codhpl
					where p.hpl_codigo = h.hpl_codigo and mai_estado = 'I'
			) ins, (select isnull(max(nota),0) from @nota_hpl where codhpl = h.hpl_codigo) nota
		from emer_encenc_encabezado_encuesta
			inner join ra_hpl_horarios_planificacion h on hpl_codigo = encenc_codhpl
			inner join ra_esc_escuelas on esc_codigo = hpl_codesc
			inner join ra_fac_facultades on fac_codigo = esc_codfac
			inner join ra_mat_materias on mat_codigo = hpl_codmat
			inner join pla_emp_empleado on emp_codigo = hpl_codemp
			inner join ra_cil_ciclo on cil_codigo = hpl_codcil
			inner join emer_detenc_detalle_encuesta on detenc_codencenc = encenc_codigo
			inner join emer_pre_preguntas on pre_codigo = detenc_codpre
			inner join emer_grupe_grupos_estudio on grupe_codigo = pre_codgrupe
			inner join emer_opc_opciones on opc_codigo = detenc_codopc
			inner join emer_enc_encuestas on enc_codigo = encenc_codenc
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
		from emer_encenc_encabezado_encuesta
			inner join ra_hpl_horarios_planificacion on hpl_codigo = encenc_codhpl
			inner join ra_esc_escuelas on esc_codigo = hpl_codesc
			inner join ra_fac_facultades on fac_codigo = esc_codfac
			inner join ra_mat_materias on mat_codigo = hpl_codmat
			inner join pla_emp_empleado on emp_codigo = hpl_codemp
			inner join ra_cil_ciclo on cil_codigo = hpl_codcil
			inner join emer_detenc_detalle_encuesta on detenc_codencenc = encenc_codigo
			inner join emer_pre_preguntas on pre_codigo = detenc_codpre
			inner join emer_grupe_grupos_estudio on grupe_codigo = pre_codgrupe
			inner join emer_opc_opciones on opc_codigo = detenc_codopc
			inner join emer_enc_encuestas on enc_codigo = encenc_codenc
			inner join emer_preopc_preguntas_opciones on preopc_codpre = pre_codigo and preopc_codopc = opc_codigo
		where hpl_codesc = @codesc and enc_codcil = @codcil
				and((case when(hpl_codemp > 0 and @codemp > 0) then hpl_codemp else 0 end) = (case when @codemp > 0 then @codemp else 0 end))
				and preopc_codtipo = 2--RESPUESTAS ABIERTAS
		group by cil_codcic, cil_anio, hpl_codigo, hpl_codmat, mat_nombre, 
			hpl_descripcion, hpl_codemp ,emp_nombres_apellidos, fac_nombre, esc_nombre, 
			grupe_orden, grupe_nombre, pre_orden_general, pre_pregunta, opc_opcion, detenc_detalle
		order by mat_nombre, pre_orden_general asc
	end

end





USE [uonline]
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
		
		if not exists (select 1 from emer_enc_encuestas where enc_codcil = @codcil_encuesta_destino and enc_codtde = @codtde)--Si el ciclo destino no tiene encuesta para el @codtde
		begin
			--select * from emer_enc_encuestas where enc_codcil = @codcil_encuesta_origen and enc_codtde = @codtde
			--select * from emer_grupe_grupos_estudio
			--select * from emer_pre_preguntas
			--select * from emer_opc_opciones
			--select * from emer_preopc_preguntas_opciones
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
			select @codenc_origen = enc_codigo from emer_enc_encuestas
			where enc_codcil = @codcil_encuesta_origen and enc_codtde = @codtde
			if (isnull(@codenc_origen, 0) <> 0) -- Si el ciclo origen tiene encuesta para el @codtde
			begin
				select @max_codenc = max(enc_codigo) + 1 from emer_enc_encuestas
				select @max_grupe = max(grupe_codigo) from emer_grupe_grupos_estudio
				select @max_pre = max(pre_codigo) from emer_pre_preguntas
				select @max_opc = max(opc_codigo) from emer_opc_opciones

				insert into @tbl_grupe
				(grupe_nuevo_codigo, grupe_codigo, grupe_nombre, grupe_nuevo_codenc, grupe_orden)
				select @max_grupe +  row_number() over(order by grupe_codigo),
				grupe_codigo, grupe_nombre, @max_codenc, grupe_orden 
				from emer_grupe_grupos_estudio
				where grupe_codenc = @codenc_origen
				--select * from @tbl_grupe

				--Preguntas
				insert into @tbl_pre (pre_nuevo_codigo, pre_codigo, pre_codtipp, pre_nuevo_codgrupe, pre_codgrupe, pre_orden_general, pre_orden, pre_pregunta)
				select  @max_pre +  row_number() over(order by pre_codigo), 
				pre.pre_codigo 'pre_codigo', pre.pre_codtipp 'pre_codtipp', tbl_grupe.grupe_nuevo_codigo 'grupe_nuevo_codigo', pre.pre_codgrupe 'pre_codgrupe', pre.pre_orden_general 'pre_orden_general', pre.pre_orden 'pre_orden', pre.pre_pregunta 'pre_pregunta'
				from emer_grupe_grupos_estudio as grupe
				inner join emer_pre_preguntas as pre on pre_codgrupe = grupe.grupe_codigo
				inner join @tbl_grupe as tbl_grupe on tbl_grupe.grupe_codigo = grupe.grupe_codigo
				where grupe.grupe_codenc = @codenc_origen
				--select * from @tbl_pre
				
				----Opciones
				insert into @tbl_opc (opc_nuevo_codigo, opc_codigo, opc_nueva_codenc, opc_codenc, opc_opcion)
				select @max_opc +  row_number() over(order by opc_codigo), 
				opc_codigo, @max_codenc, opc_codenc, opc_opcion
				from emer_enc_encuestas
				inner join emer_opc_opciones as opc on opc_codenc = enc_codigo
				where opc_codenc = @codenc_origen
				--select * from @tbl_opc

				--Preguntas-Opciones
				insert into @tbl_preopc(preopc_nueva_codpre, preopc_nueva_codopc, preopc_codtipo, preopc_opc_orden)
				select tbl_p.pre_nuevo_codigo, tbl_o.opc_nuevo_codigo, preopc_codtipo, preopc_opc_orden 
				from emer_preopc_preguntas_opciones
				inner join @tbl_pre tbl_p on tbl_p.pre_codigo = preopc_codpre
				inner join @tbl_opc tbl_o on tbl_o.opc_codigo = preopc_codopc

				--Insertando en las tablas
				insert into emer_enc_encuestas (enc_nombre, enc_codpon, enc_codcil, enc_codtde, enc_objetivo, enc_fecha_inicio, enc_fecha_fin)
				select enc_nombre, enc_codpon, @codcil_encuesta_destino 'enc_codcil', @codtde 'enc_codtde', enc_objetivo, enc_fecha_inicio, enc_fecha_fin 
				from emer_enc_encuestas
				where enc_codigo = @codenc_origen

				insert into emer_grupe_grupos_estudio (grupe_nombre, grupe_codenc, grupe_orden)
				select grupe_nombre, grupe_nuevo_codenc, grupe_orden 
				from @tbl_grupe

				insert into emer_pre_preguntas (pre_codtipp, pre_codgrupe, pre_orden_general, pre_orden, pre_pregunta)
				select pre_codtipp, pre_nuevo_codgrupe, pre_orden_general, pre_orden, pre_pregunta 
				from @tbl_pre

				insert into emer_opc_opciones (opc_codenc, opc_opcion)
				select opc_nueva_codenc, opc_opcion from @tbl_opc
					
				insert into emer_preopc_preguntas_opciones (preopc_codpre, preopc_codopc, preopc_codtipo, preopc_opc_orden)
				select preopc_nueva_codpre, preopc_nueva_codopc, preopc_codtipo, preopc_opc_orden 
				from @tbl_preopc
					
				select concat('Codigo de la encuesta: ', @max_codenc) res
			end
		end
		else
		begin
			--print ('Ya existe una encuesta en el ciclo ', @codcil_encuesta_destino, ' para el tipo de estudio ', @codtde)
			declare @enc_codigo int = 0
			select @enc_codigo = enc_codigo from emer_enc_encuestas where enc_codcil = @codcil_encuesta_destino and enc_codtde = @codtde
			exec sp_data_emer_encuestas @opcion = 1, @codenc = @enc_codigo
		end
	end
end