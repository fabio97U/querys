--drop table ma_enc_encuestas
create table ma_enc_encuestas(
	enc_codigo int primary key identity(1,1),
	enc_nombre varchar(1024),
	enc_codtde int foreign key references ra_tde_TipoDeEstudio,
	enc_activa int default 1,
	enc_fecha_creacion datetime default getdate()
)
--select * from ma_enc_encuestas
--insert into ma_enc_encuestas(enc_nombre, enc_codtde) values('Evaluacion docente', 2)

--drop table ma_edocgru_evaluacion_docente_grupos
create table ma_edocgru_evaluacion_docente_grupos(
	edocgru_codigo int primary key identity(1,1),
	edocgru_grupo varchar(255),
	edocgru_codenc int foreign key references ma_enc_encuestas,
	edocgru_fecha_creacion datetime default getdate()
)
--select * from ma_edocgru_evaluacion_docente_grupos
--insert into ma_edocgru_evaluacion_docente_grupos(edocgru_grupo, edocgru_codenc) values('Importancia y conocimiento de las Temáticas',1), ('Planeamiento Didáctico', 1), ('Características del Docente', 1), ('Escala', 1), ( 'Comentario', 1)

--drop table ma_edocpre_evaluacion_docente_preguntas
create table ma_edocpre_evaluacion_docente_preguntas(
	edocpre_codigo int primary key identity(1,1),
	edocpre_pregunta varchar(1024),
	edocpre_codedocgru int foreign key references ma_edocpre_evaluacion_docente_preguntas,
	edocpre_escerrada int default 1,
	edocpre_fecha_creacion datetime default getdate()
)
--select * from ma_edocpre_evaluacion_docente_preguntas
insert into ma_edocpre_evaluacion_docente_preguntas (edocpre_pregunta, edocpre_codedocgru, edocpre_escerrada) 
values('Relevantes a la realidad salvadoreña',1,1),('Aplicables a las problemáticas de la carrera profesional',1,1), ('Contenidos actualizados',1,1), ('Material de estudio y/o lectura acorde a las temáticas expuestas', 1,1), ('Los conocimientos recibidos en clase tienen aplicación práctica',1,1),
('El desarrollo de las clases muestran preparación y planificación',2,1), ('El desarrollo de las clases son de acuerdo al programa y contenido',2,1), ('Se profundiza en el desarrollo de los contenidos',2,1), ('Utiliza ejemplos orientados a la realidad nacional',2,1), ('Utiliza diversos métodos didácticos y técnicas participativas para facilitar el aprendizaje',2,1), ('Utiliza adecuadamente los medios o recursos didácticos disponibles en la Universidad',2,1),
('Demuestra liderazgo con el grupo',3,1),('Su lenguaje verbal y corporal logra el dominio del grupo',3,1),('Despierta motivación e interés en el aprendizaje de los participantes ',3,1),('Inspira confianza y respeto en la interacción con los participantes',3,1),('Fomenta principios y valores',3,1),('Muestra capacidad para escuchar los diferentes puntos de vista',3,1),('Demuestra seguridad y ética profesional',3,1),
('En una escala de 1 a 10, cuál es su opinión general de la clase',4,1),
('Comentario',5,0)

--drop table ma_edocopc_evaluacion_docente_opciones
create table ma_edocopc_evaluacion_docente_opciones(
	edocopc_codigo int primary key identity(1,1),
	edocopc_opcion varchar(30),
	edocopc_valor varchar(5),
	edocopc_calificacion real,--Calificacion
	edocopc_codenc int foreign key references ma_enc_encuestas, --OPCIONES PARA LA ENCUENSTA
	edocopc_fecha_creacion datetime default getdate()
)
--select * from ma_edocopc_evaluacion_docente_opciones
insert into ma_edocopc_evaluacion_docente_opciones(edocopc_opcion, edocopc_valor, edocopc_codenc, edocopc_calificacion) values ('Excelente','E',1, 10),('Muy Bueno','MB', 1, 9), ('Bueno','B',1, 8),('Regular','R',1,7)

--drop table ma_edf_evaluacion_docente_fechas
create table ma_edf_evaluacion_docente_fechas(
	edf_codigo int primary key identity(1,1),
	--edf_codcil int foreign key references ra_cil_ciclo,
	edf_fecha_inicio datetime,
	edf_fecha_fin datetime,
	edf_codtde int foreign key references ra_tde_TipoDeEstudio,
	edf_codenc int foreign key references ma_enc_encuestas,
	edf_codusr_creacion int foreign key references adm_usr_usuarios,
	edf_codhpl int foreign key references ra_hpl_horarios_planificacion,
	edf_fecha_creacion datetime default getdate()
)
--select * from ma_edf_evaluacion_docente_fechas
--@DEPRECATED insert into ma_edf_evaluacion_docente_fechas (edf_codcil, edf_fecha_inicio, edf_fecha_fin, edf_codtde, edf_codenc, edf_codusr_creacion)  values (120, '2019-07-08 16:41:25.327', '2019-07-16 16:41:25.327', 2, 1, 407)
go

--drop table ma_encres_encuestas_respuestas
create table ma_encres_encuestas_respuestas(
	encres_codigo int primary key identity(1,1),
	encres_codenc int foreign key references ma_enc_encuestas,
	encres_codper int foreign key references ra_per_personas,
	encres_codhpl int foreign key references ra_hpl_horarios_planificacion,
	encres_fecha_creacion datetime default getdate()
)
delete from ma_encres_encuestas_respuestas
--select * from  ma_encres_encuestas_respuestas

--drop table ma_encdetres_encuestas_detalle_respuestas
create table ma_encdetres_encuestas_detalle_respuestas(
	encdetres_codigo int primary key identity(1,1),
	encdetres_codencres int foreign key references ma_encres_encuestas_respuestas,
	encdetres_codedocpre int foreign key references ma_edocpre_evaluacion_docente_preguntas,
	encdetres_codedocopc varchar(125), --ma_edocopc_evaluacion_docente_opciones
	encdetres_detalle varchar(1024)
)
go
--select * from  ma_encdetres_encuestas_detalle_respuestas
USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[ma_evaluacion_docente_maestrias]    Script Date: 17/09/2019 17:37:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[ma_evaluacion_docente_maestrias]
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-06-20 10:12:32.433>
	-- Description: <Realiza el mantemiento a los reportes de la evaluacion docente de postgrados y maestrias>
	-- =============================================
	--ma_evaluacion_docente_maestrias 1, 1, 0, 0, 0, 0, 0, 0, ''
	--ma_evaluacion_docente_maestrias 2, 1, 0, 0, 0, 0, 0, 0, ''
	--ma_evaluacion_docente_maestrias 3, 1, 40466, 0, 0, 0, 0, 0, 'a'
	--ma_evaluacion_docente_maestrias 7, 1, 0, 0, 107, 0, 0, 0, ''
	--ma_evaluacion_docente_maestrias 9, 1, 0, 0, 107, 0, 0, 0, ''
	--ma_evaluacion_docente_maestrias 8, 1, 38258, 0, 117, 0, 0, 0, '' --Devuelve los datos de la materia y docente segun el @codhpl
	--ma_evaluacion_docente_maestrias 9, 1, 0, 0, 107, 0, 0, 0, '' --Resultados generales por ciclo
	--ma_evaluacion_docente_maestrias 10, 0, 38258, 0, 0, 0, 0, 0, '' --Resultados de los comentarios segun el @codhpl
	@opcion int = 0,
	@codenc int = 0,
	@codhpl int = 0,
	@codper int = 0,
	@codcil int = 0,
	--Estos parametros son para el detalle de la encuesta
	@codencres int = 0,--ENCABEZADO DE LA ENCUESTA
	@codedocpre int = 0,--PREGUNTA DE RESPUESTA
	@codedocopc varchar(125) = 0,--OPCION DE RESPUESTA, SI LA PREGUNTA ES CERRADA ESTE SERA UN NUMERO ENTERO
	@detalle varchar(1024) = ''--DETALLE DE PREGUNTA ABIERTA, SI LA PREGUNTA ES ABIERTA ESTE CAMPO LLEVARA EL DETALLE
as
begin
	declare @encuestas as table (codencres int) --Encuestas hechas

	if @opcion = 1 --Devuelve la data de preguntas para encuesta @codenc
	begin
		select row_number() over(order by enc_nombre), enc_nombre, edocgru_grupo, edocpre_pregunta, edocpre_escerrada from ma_enc_encuestas 
			inner join ma_edocgru_evaluacion_docente_grupos on edocgru_codenc = enc_codigo
			inner join ma_edocpre_evaluacion_docente_preguntas on edocpre_codedocgru = edocgru_codigo
		where enc_codigo = @codenc
	end

	if @opcion = 2 --Devuelve la data de opciones para encuesta @codenc
	begin
		select edocopc_opcion, edocopc_valor from ma_edocopc_evaluacion_docente_opciones where edocopc_codenc = @codenc
	end

	if @opcion = 3 --Verifica si la encuesta @codenc esta el periodo habilitado
	begin
		if exists (select 1 from ma_edf_evaluacion_docente_fechas where edf_codenc = @codenc and edf_codhpl = @codhpl)
		begin
			if exists(select 1 from ma_edf_evaluacion_docente_fechas inner join ma_enc_encuestas on enc_codigo = edf_codenc where edf_codenc = @codenc and enc_activa = 1 and edf_codhpl = @codhpl)
			begin
				if exists(select 1 from ma_edf_evaluacion_docente_fechas inner join ma_enc_encuestas on enc_codigo = edf_codenc where edf_codenc = @codenc and getdate() >= edf_fecha_inicio and getdate() <=  edf_fecha_fin and edf_codhpl = @codhpl)
					select 1 --@codenc esta en el periodo 
				else 
					select 0 --@codenc NO esta en el periodo 
			end
			else
				print 'Encuesta no esta activada'
		end
		else 
			print 'Encuesta no existe'
	end
	-- web_pnw_notas_alumnos_postgrado 219954
	if @opcion = 4 --Valida si el alumno ya lleno la @codenc para la materia @codhpl en el ciclo @codcil
	begin
		if exists (select 1 from ma_encres_encuestas_respuestas where encres_codhpl = @codhpl and encres_codenc = @codenc and encres_codper = @codper)
			select 1 --Lleno encuesta
		else
			select 0 --No lleno encuesta
	end

	if @opcion = 5 --Inserta el registro del encabezado(ma_encres_encuestas_respuestas) de la @codenc
	begin
		if not exists(select 1 from ma_encres_encuestas_respuestas where encres_codhpl = @codhpl and encres_codenc = @codenc and encres_codper = @codper)
		begin
			insert into ma_encres_encuestas_respuestas (encres_codenc, encres_codper, encres_codhpl) values (@codenc, @codper, @codhpl)
			select scope_identity() 'res'
		end
		else 
			select -1 'res' --Ya hay un registro de la encuesta para el alumno @codper en la materia @codhpl
	end--if @opcion = 5
	
	if @opcion = 6 --Inserta el registro del detalle(ma_encdetres_encuestas_detalle_respuestas) de la @codenc
	begin
		insert into ma_encdetres_encuestas_detalle_respuestas (encdetres_codencres, encdetres_codedocpre, encdetres_codedocopc, encdetres_detalle) 
		values (@codencres, @codedocpre, @codedocopc, @detalle)
		select @@identity 'res'
	end--if @opcion = 6
	
	if @opcion = 7 --Devuelve los resultados de la encuesta
	begin
		
		
		insert into @encuestas (codencres)
		select encres_codigo from ma_encres_encuestas_respuestas
		inner join ra_hpl_horarios_planificacion on hpl_codigo = encres_codhpl and hpl_codcil = @codcil 

		--select * from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres in (select codencres from @encuestas)

		select encres_codigo 'codencres'/*, enc_nombre*/, per_carnet 'Carnet', per_apellidos_nombres 'Alumno', mat_nombre 'Materia', concat('0',cil_codcic, '-',cil_anio) 'ciclo', encres_fecha_creacion 'Fecha creacion',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 1) 'Pre1',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 2) 'Pre2',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 3) 'Pre3',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 4) 'Pre4',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 5) 'Pre5',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 6) 'Pre6',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 7) 'Pre7',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 8) 'Pre8',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 9) 'Pre9',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 10) 'Pre10',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 11) 'Pre11',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 12) 'Pre12',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 13) 'Pre13',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 14) 'Pre14',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 15) 'Pre15',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 16) 'Pre16',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 17) 'Pre17',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 18) 'Pre18',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 19) 'Pre19',
		(select encdetres_detalle from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 20) 'Pre20'
		from ma_encres_encuestas_respuestas as encres
		inner join ra_per_personas on per_codigo = encres_codper
		inner join ra_hpl_horarios_planificacion on  hpl_codigo = encres_codhpl and hpl_codcil = @codcil
		inner join ra_mat_materias on hpl_codmat = mat_codigo
		inner join ra_cil_ciclo on cil_codigo = hpl_codcil
		inner join ma_enc_encuestas on enc_codigo = encres_codenc
		--inner join ma_encdetres_encuestas_detalle_respuestas on encdetres_codencres = encres_codigo
	end--if @opcion = 7		
	
	if @opcion = 8 --Devuelve los datos(empleado y materia) segun el @codhpl
	begin
		--TOP 1 Porque algunos docentes tienen mas de un titulo y se muestra el ultimo titulo que se le registro
		select  top 1/*emp_codigo, tti_descripcion,*/concat(ltrim(rtrim(upper(tti_abreviatura))), '. ', ltrim(rtrim(emp_apellidos_nombres))) 'docente', mat_nombre 'materia'
		from ra_hpl_horarios_planificacion 
		inner join ra_mat_materias on mat_codigo = hpl_codmat
		left join pla_emp_empleado on emp_codigo = hpl_codemp
		left join pla_tie_titulo_empleado on tie_codemp = emp_codigo
		left join pla_tit_titulo on tit_codigo = tie_codtit
		left join pla_tti_tipo_titulo on tti_codigo = tit_codtti
		where hpl_codigo = @codhpl
		order by tie_codigo desc
	end--if @opcion = 8		
	
	if @opcion = 9 --Devuelve los resultados optenidos en la evaluacion por @codcil
	begin
		--ma_evaluacion_docente_maestrias 9, 1, 0, 0, 107, 0, 0, 0, ''
		insert into @encuestas (codencres)
		select encres_codigo from ma_encres_encuestas_respuestas
		inner join ra_hpl_horarios_planificacion on hpl_codigo = encres_codhpl and hpl_codcil = @codcil 

		declare @data_respuestas as table(encres_codigo int, materia varchar(255), codhpl int, pre1 int, pre2 int, pre3 int, pre4 int, pre5 int, pre6 int, pre7 int, pre8 int, pre9 int, pre10 int, pre11 int, pre12 int, pre13 int, pre14 int, pre15 int, pre16 int, pre17 int, pre18 int, pre19 int, docente varchar(1024))
		
		insert into @data_respuestas
		select encres_codigo 'codencres', mat_nombre 'Materia', hpl.hpl_codigo, 
		-- ,/*, enc_nombre*/ per_carnet 'Carnet', per_apellidos_nombres 'Alumno', mat_nombre 'Materia', concat('0',cil_codcic, '-',cil_anio) 'ciclo', encres_fecha_creacion 'Fecha creacion',
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 1),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 2),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 3),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 4),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 5),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 6),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 7),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 8),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 9),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 10),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 11),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 12),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 13),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 14),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 15),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 16),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 17),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 18)
		,(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 19),
		--,(select encdetres_detalle from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 20) 'Pre20'
		/*emp_codigo, tti_descripcion,*/
		(
			select  top 1/*emp_codigo, tti_descripcion,*/concat(ltrim(rtrim(upper(tti_abreviatura))), '. ', ltrim(rtrim(emp_apellidos_nombres))) 'docente'
			from ra_hpl_horarios_planificacion 
			inner join ra_mat_materias on mat_codigo = hpl_codmat
			left join pla_emp_empleado on emp_codigo = hpl_codemp
			left join pla_tie_titulo_empleado on tie_codemp = emp_codigo
			left join pla_tit_titulo on tit_codigo = tie_codtit
			left join pla_tti_tipo_titulo on tti_codigo = tit_codtti
			where hpl_codigo = hpl.hpl_codigo
			order by tie_codigo desc
		) 'docente'
		from ma_encres_encuestas_respuestas as encres
		inner join ra_per_personas on per_codigo = encres_codper
		inner join ra_hpl_horarios_planificacion as hpl on  hpl.hpl_codigo = encres_codhpl and /*hpl_codigo = @codhpl */ hpl_codcil = @codcil
		inner join ra_mat_materias on hpl_codmat = mat_codigo
		inner join ra_cil_ciclo on cil_codigo = hpl.hpl_codcil
		inner join ma_enc_encuestas on enc_codigo = encres_codenc

		order by hpl_codigo

		select /*@codcil 'ciclo',*/ codhpl, materia, count(1) 'Evaluaciones', 
		round(avg(cast(pre1 as real)), 2) 'Pre1',
		round(avg(cast(pre2 as real)), 2) 'Pre2',
		round(avg(cast(pre3 as real)), 2) 'Pre3',
		round(avg(cast(pre4 as real)), 2) 'Pre4',
		round(avg(cast(pre5 as real)), 2) 'Pre5',
		round(avg(cast(pre6 as real)), 2) 'Pre6',
		round(avg(cast(pre7 as real)), 2) 'Pre7',
		round(avg(cast(pre8 as real)), 2) 'Pre8',
		round(avg(cast(pre9 as real)), 2) 'Pre9',
		round(avg(cast(pre10 as real)), 2) 'Pre10',
		round(avg(cast(pre11 as real)), 2) 'Pre11',
		round(avg(cast(pre12 as real)), 2) 'Pre12',
		round(avg(cast(pre13 as real)), 2) 'Pre13',
		round(avg(cast(pre14 as real)), 2) 'Pre14',
		round(avg(cast(pre15 as real)), 2) 'Pre15',
		round(avg(cast(pre16 as real)), 2) 'Pre16',
		round(avg(cast(pre17 as real)), 2) 'Pre17',
		round(avg(cast(pre18 as real)), 2) 'Pre18',
		round(avg(cast(pre19 as real)), 2) 'Pre19',
		--,pre20
		docente, 10 'opc_comen'--10: PORQUE SE INVOCARA LA OPCION  10 DE ESTE PROCEDIMIENTO EN EL REPORTE, NO CAMBIAR
		from @data_respuestas
		group by codhpl, materia, docente--, pre20

	end--if @opcion = 9		
	
	if @opcion = 10 --Devuelve los COMENTARIOS optenidos POR @hpl
	begin
		--ma_evaluacion_docente_maestrias 10, 0, 20242, 0, 0, 0, 0, 0, ''
		insert into @encuestas (codencres)
		select encres_codigo from ma_encres_encuestas_respuestas
		inner join ra_hpl_horarios_planificacion on hpl_codigo = encres_codhpl and hpl_codcil = @codcil 

		declare @data_respuestas_comentarios as table(encres_codigo int, materia varchar(255), codhpl int, pre20 varchar(1024))
		
		insert into @data_respuestas_comentarios
		select encres_codigo 'codencres', mat_nombre 'Materia', hpl_codigo,-- ,/*, enc_nombre*/ per_carnet 'Carnet', per_apellidos_nombres 'Alumno', mat_nombre 'Materia', concat('0',cil_codcic, '-',cil_anio) 'ciclo', encres_fecha_creacion 'Fecha creacion',
		(select encdetres_detalle from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 20) 'Pre20'

		from ma_encres_encuestas_respuestas as encres
		inner join ra_per_personas on per_codigo = encres_codper
		inner join ra_hpl_horarios_planificacion on  hpl_codigo = encres_codhpl and hpl_codigo = @codhpl 
		inner join ra_mat_materias on hpl_codmat = mat_codigo
		inner join ra_cil_ciclo on cil_codigo = hpl_codcil
		inner join ma_enc_encuestas on enc_codigo = encres_codenc
		order by hpl_codigo

		select /*@codcil 'ciclo',*/ codhpl, materia,
		pre20
		from @data_respuestas_comentarios
		where rtrim(ltrim([Pre20])) != ''
		--group by codhpl, materia--, pre20
	end--if @opcion = 10			
end

--select * from pla_tie_titulo_empleado left join pla_tit_titulo on tit_codigo = tie_codtit where tie_codemp = 310
--select * from pla_tie_titulo_empleado where tie_codemp = 310
--select * from pla_tit_titulo
----sp_help ra_cat_catedraticos
--select * from ra_ins_inscripcion inner join ra_mai_mat_inscritas on mai_codins = ins_codigo and ins_codper = 182420

alter procedure [dbo].[ma_evaluacion_docente_maestrias]
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-06-20 10:12:32.433>
	-- Description: <Realiza el mantemiento a los reportes de la evaluacion docente de postgrados y maestrias>
	-- =============================================
	--ma_evaluacion_docente_maestrias 1, 1, 0, 0, 0, 0, 0, 0, ''
	--ma_evaluacion_docente_maestrias 2, 1, 0, 0, 0, 0, 0, 0, ''
	--ma_evaluacion_docente_maestrias 3, 1, 0, 0, 0, 0, 0, 0, 'a'
	--ma_evaluacion_docente_maestrias 7, 1, 0, 0, 107, 0, 0, 0, ''
	--ma_evaluacion_docente_maestrias 9, 1, 0, 0, 107, 0, 0, 0, ''
	--ma_evaluacion_docente_maestrias 8, 1, 38258, 0, 117, 0, 0, 0, '' --Devuelve los datos de la materia y docente segun el @codhpl
	--ma_evaluacion_docente_maestrias 9, 1, 0, 0, 107, 0, 0, 0, '' --Resultados generales por ciclo
	--ma_evaluacion_docente_maestrias 10, 0, 38258, 0, 0, 0, 0, 0, '' --Resultados de los comentarios segun el @codhpl
	@opcion int = 0,
	@codenc int = 0,
	@codhpl int = 0,
	@codper int = 0,
	@codcil int = 0,
	--Estos parametros son para el detalle de la encuesta
	@codencres int = 0,--ENCABEZADO DE LA ENCUESTA
	@codedocpre int = 0,--PREGUNTA DE RESPUESTA
	@codedocopc varchar(125) = 0,--OPCION DE RESPUESTA, SI LA PREGUNTA ES CERRADA ESTE SERA UN NUMERO ENTERO
	@detalle varchar(1024) = ''--DETALLE DE PREGUNTA ABIERTA, SI LA PREGUNTA ES ABIERTA ESTE CAMPO LLEVARA EL DETALLE
as
begin
	declare @encuestas as table (codencres int) --Encuestas hechas

	if @opcion = 1 --Devuelve la data de preguntas para encuesta @codenc
	begin
		select row_number() over(order by enc_nombre), enc_nombre, edocgru_grupo, edocpre_pregunta, edocpre_escerrada from ma_enc_encuestas 
			inner join ma_edocgru_evaluacion_docente_grupos on edocgru_codenc = enc_codigo
			inner join ma_edocpre_evaluacion_docente_preguntas on edocpre_codedocgru = edocgru_codigo
		where enc_codigo = @codenc
	end

	if @opcion = 2 --Devuelve la data de opciones para encuesta @codenc
	begin
		select edocopc_opcion, edocopc_valor from ma_edocopc_evaluacion_docente_opciones where edocopc_codenc = @codenc
	end

	if @opcion = 3 --Verifica si la encuesta @codenc esta el periodo habilitado
	begin
		if exists (select 1 from ma_edf_evaluacion_docente_fechas where edf_codenc = @codenc and edf_codhpl = @codhpl)
		begin
			if exists(select 1 from ma_edf_evaluacion_docente_fechas inner join ma_enc_encuestas on enc_codigo = edf_codenc where edf_codenc = @codenc and enc_activa = 1 and edf_codhpl = @codhpl)
			begin
				if exists(select 1 from ma_edf_evaluacion_docente_fechas inner join ma_enc_encuestas on enc_codigo = edf_codenc where edf_codenc = @codenc and getdate() >= edf_fecha_inicio and getdate() <=  edf_fecha_fin and edf_codhpl = @codhpl)
					select 1 --@codenc esta en el periodo 
				else 
					select 1 --@codenc NO esta en el periodo 
			end
			else
				print 'Encuesta no esta activada'
		end
		else 
			print 'Encuesta no existe'
	end

	if @opcion = 4 --Valida si el alumno ya lleno la @codenc para la materia @codhpl en el ciclo @codcil
	begin
		if exists (select 1 from ma_encres_encuestas_respuestas where encres_codhpl = @codhpl and encres_codenc = @codenc and encres_codper = @codper)
			select 1 --Lleno encuesta
		else
			select 0 --No lleno encuesta
	end

	if @opcion = 5 --Inserta el registro del encabezado(ma_encres_encuestas_respuestas) de la @codenc
	begin
		if not exists(select 1 from ma_encres_encuestas_respuestas where encres_codhpl = @codhpl and encres_codenc = @codenc and encres_codper = @codper)
		begin
			insert into ma_encres_encuestas_respuestas (encres_codenc, encres_codper, encres_codhpl) values (@codenc, @codper, @codhpl)
			select scope_identity() 'res'
		end
		else 
			select -1 'res' --Ya hay un registro de la encuesta para el alumno @codper en la materia @codhpl
	end--if @opcion = 5
	
	if @opcion = 6 --Inserta el registro del detalle(ma_encdetres_encuestas_detalle_respuestas) de la @codenc
	begin
		insert into ma_encdetres_encuestas_detalle_respuestas (encdetres_codencres, encdetres_codedocpre, encdetres_codedocopc, encdetres_detalle) 
		values (@codencres, @codedocpre, @codedocopc, @detalle)
		select @@identity 'res'
	end--if @opcion = 6
	
	if @opcion = 7 --Devuelve los resultados de la encuesta
	begin
		
		
		insert into @encuestas (codencres)
		select encres_codigo from ma_encres_encuestas_respuestas
		inner join ra_hpl_horarios_planificacion on hpl_codigo = encres_codhpl and hpl_codcil = @codcil 

		--select * from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres in (select codencres from @encuestas)

		select encres_codigo 'codencres'/*, enc_nombre*/, per_carnet 'Carnet', per_apellidos_nombres 'Alumno', mat_nombre 'Materia', concat('0',cil_codcic, '-',cil_anio) 'ciclo', encres_fecha_creacion 'Fecha creacion',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 1) 'Pre1',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 2) 'Pre2',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 3) 'Pre3',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 4) 'Pre4',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 5) 'Pre5',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 6) 'Pre6',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 7) 'Pre7',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 8) 'Pre8',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 9) 'Pre9',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 10) 'Pre10',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 11) 'Pre11',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 12) 'Pre12',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 13) 'Pre13',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 14) 'Pre14',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 15) 'Pre15',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 16) 'Pre16',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 17) 'Pre17',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 18) 'Pre18',
		(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 19) 'Pre19',
		(select encdetres_detalle from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 20) 'Pre20'
		from ma_encres_encuestas_respuestas as encres
		inner join ra_per_personas on per_codigo = encres_codper
		inner join ra_hpl_horarios_planificacion on  hpl_codigo = encres_codhpl and hpl_codcil = @codcil
		inner join ra_mat_materias on hpl_codmat = mat_codigo
		inner join ra_cil_ciclo on cil_codigo = hpl_codcil
		inner join ma_enc_encuestas on enc_codigo = encres_codenc
		--inner join ma_encdetres_encuestas_detalle_respuestas on encdetres_codencres = encres_codigo
	end--if @opcion = 7		
	
	if @opcion = 8 --Devuelve los datos(empleado y materia) segun el @codhpl
	begin
		--TOP 1 Porque algunos docentes tienen mas de un titulo y se muestra el ultimo titulo que se le registro
		select  top 1/*emp_codigo, tti_descripcion,*/concat(ltrim(rtrim(upper(tti_abreviatura))), '. ', ltrim(rtrim(emp_apellidos_nombres))) 'docente', mat_nombre 'materia'
		from ra_hpl_horarios_planificacion 
		inner join ra_mat_materias on mat_codigo = hpl_codmat
		left join pla_emp_empleado on emp_codigo = hpl_codemp
		left join pla_tie_titulo_empleado on tie_codemp = emp_codigo
		left join pla_tit_titulo on tit_codigo = tie_codtit
		left join pla_tti_tipo_titulo on tti_codigo = tit_codtti
		where hpl_codigo = @codhpl
		order by tie_codigo desc
	end--if @opcion = 8		
	
	if @opcion = 9 --Devuelve los resultados optenidos en la evaluacion por @codcil
	begin
		--ma_evaluacion_docente_maestrias 9, 1, 0, 0, 107, 0, 0, 0, ''
		insert into @encuestas (codencres)
		select encres_codigo from ma_encres_encuestas_respuestas
		inner join ra_hpl_horarios_planificacion on hpl_codigo = encres_codhpl and hpl_codcil = @codcil 

		declare @data_respuestas as table(encres_codigo int, materia varchar(255), codhpl int, pre1 int, pre2 int, pre3 int, pre4 int, pre5 int, pre6 int, pre7 int, pre8 int, pre9 int, pre10 int, pre11 int, pre12 int, pre13 int, pre14 int, pre15 int, pre16 int, pre17 int, pre18 int, pre19 int, docente varchar(1024))
		
		insert into @data_respuestas
		select encres_codigo 'codencres', mat_nombre 'Materia', hpl.hpl_codigo, 
		-- ,/*, enc_nombre*/ per_carnet 'Carnet', per_apellidos_nombres 'Alumno', mat_nombre 'Materia', concat('0',cil_codcic, '-',cil_anio) 'ciclo', encres_fecha_creacion 'Fecha creacion',
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 1),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 2),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 3),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 4),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 5),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 6),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 7),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 8),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 9),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 10),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 11),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 12),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 13),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 14),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 15),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 16),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 17),
		(select edocopc_calificacion from ma_encdetres_encuestas_detalle_respuestas inner join ma_edocopc_evaluacion_docente_opciones on encdetres_codedocopc = edocopc_valor where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 18)
		,(select encdetres_codedocopc from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 19),
		--,(select encdetres_detalle from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 20) 'Pre20'
		/*emp_codigo, tti_descripcion,*/
		(
			select  top 1/*emp_codigo, tti_descripcion,*/concat(ltrim(rtrim(upper(tti_abreviatura))), '. ', ltrim(rtrim(emp_apellidos_nombres))) 'docente'
			from ra_hpl_horarios_planificacion 
			inner join ra_mat_materias on mat_codigo = hpl_codmat
			left join pla_emp_empleado on emp_codigo = hpl_codemp
			left join pla_tie_titulo_empleado on tie_codemp = emp_codigo
			left join pla_tit_titulo on tit_codigo = tie_codtit
			left join pla_tti_tipo_titulo on tti_codigo = tit_codtti
			where hpl_codigo = hpl.hpl_codigo
			order by tie_codigo desc
		) 'docente'
		from ma_encres_encuestas_respuestas as encres
		inner join ra_per_personas on per_codigo = encres_codper
		inner join ra_hpl_horarios_planificacion as hpl on  hpl.hpl_codigo = encres_codhpl and /*hpl_codigo = @codhpl */ hpl_codcil = @codcil
		inner join ra_mat_materias on hpl_codmat = mat_codigo
		inner join ra_cil_ciclo on cil_codigo = hpl.hpl_codcil
		inner join ma_enc_encuestas on enc_codigo = encres_codenc

		order by hpl_codigo

		select /*@codcil 'ciclo',*/ codhpl, materia, count(1) 'Evaluaciones', 
		round(avg(cast(pre1 as real)), 2) 'Pre1',
		round(avg(cast(pre2 as real)), 2) 'Pre2',
		round(avg(cast(pre3 as real)), 2) 'Pre3',
		round(avg(cast(pre4 as real)), 2) 'Pre4',
		round(avg(cast(pre5 as real)), 2) 'Pre5',
		round(avg(cast(pre6 as real)), 2) 'Pre6',
		round(avg(cast(pre7 as real)), 2) 'Pre7',
		round(avg(cast(pre8 as real)), 2) 'Pre8',
		round(avg(cast(pre9 as real)), 2) 'Pre9',
		round(avg(cast(pre10 as real)), 2) 'Pre10',
		round(avg(cast(pre11 as real)), 2) 'Pre11',
		round(avg(cast(pre12 as real)), 2) 'Pre12',
		round(avg(cast(pre13 as real)), 2) 'Pre13',
		round(avg(cast(pre14 as real)), 2) 'Pre14',
		round(avg(cast(pre15 as real)), 2) 'Pre15',
		round(avg(cast(pre16 as real)), 2) 'Pre16',
		round(avg(cast(pre17 as real)), 2) 'Pre17',
		round(avg(cast(pre18 as real)), 2) 'Pre18',
		round(avg(cast(pre19 as real)), 2) 'Pre19',
		--,pre20
		docente, 10 'opc_comen'--10: PORQUE SE INVOCARA LA OPCION  10 DE ESTE PROCEDIMIENTO EN EL REPORTE, NO CAMBIAR
		from @data_respuestas
		group by codhpl, materia, docente--, pre20

	end--if @opcion = 9		
	
	if @opcion = 10 --Devuelve los COMENTARIOS optenidos POR @hpl
	begin
		--ma_evaluacion_docente_maestrias 10, 0, 20242, 0, 0, 0, 0, 0, ''
		insert into @encuestas (codencres)
		select encres_codigo from ma_encres_encuestas_respuestas
		inner join ra_hpl_horarios_planificacion on hpl_codigo = encres_codhpl and hpl_codcil = @codcil 

		declare @data_respuestas_comentarios as table(encres_codigo int, materia varchar(255), codhpl int, pre20 varchar(1024))
		
		insert into @data_respuestas_comentarios
		select encres_codigo 'codencres', mat_nombre 'Materia', hpl_codigo,-- ,/*, enc_nombre*/ per_carnet 'Carnet', per_apellidos_nombres 'Alumno', mat_nombre 'Materia', concat('0',cil_codcic, '-',cil_anio) 'ciclo', encres_fecha_creacion 'Fecha creacion',
		(select encdetres_detalle from ma_encdetres_encuestas_detalle_respuestas where encdetres_codencres = encres.encres_codigo and encdetres_codedocpre = 20) 'Pre20'

		from ma_encres_encuestas_respuestas as encres
		inner join ra_per_personas on per_codigo = encres_codper
		inner join ra_hpl_horarios_planificacion on  hpl_codigo = encres_codhpl and hpl_codigo = @codhpl 
		inner join ra_mat_materias on hpl_codmat = mat_codigo
		inner join ra_cil_ciclo on cil_codigo = hpl_codcil
		inner join ma_enc_encuestas on enc_codigo = encres_codenc
		order by hpl_codigo

		select /*@codcil 'ciclo',*/ codhpl, materia,
		pre20
		from @data_respuestas_comentarios
		--group by codhpl, materia--, pre20
	end--if @opcion = 10			
end	