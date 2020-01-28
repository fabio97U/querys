--select 0 col_IdColegio, 'Seleccione' col_Colegio union select col_IdColegio, upper(col_Colegio) from prb_col_colegios order by 1 asc, 2 desc
--select opc_IdOpcion, opc_Opcion from prb_opc_opciones

--select upper(mun_nombre) mun_nombre from (
--select distinct mun_nombre from uonline.dbo.ra_mun_municipios inner join uonline.dbo.ra_dep_departamentos on MUN_CODDEP = DEP_CODIGO and DEP_CODPAI = 1
--) as tab
-- order by mun_nombre

--select 0 num, 0 col_IdColegio, 'Seleccione' col_Colegio union 
--select row_number() over(order by col_Colegio) num, col_IdColegio, col_Colegio from prb_col_colegios 
--order by num

--select 0 num, 0 opc_IdOpcion, 'Seleccione' opc_Opcion union 
--select row_number() over(order by opc_Opcion), opc_IdOpcion, opc_Opcion from prb_opc_opciones
--order by num

-- Este campo almacenara los valores 1: TourUTEC, 2: Otro, 3: PruebaEscala6
--****alter table prb_adat_dat_alumno add adat_TipoEvaluacion int****--

USE PruebaVocacional
GO
/****** Object:  StoredProcedure dbo.sp_pv_inserta_datos_alumnos    Script Date: 08/08/2019 18:04:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE dbo.sp_pv_inserta_datos_alumnos
	-- =============================================
	-- Author:      <DESCONOCIDO>
	-- Create date: <DESCONOCIDO>
	-- Description: <Este procedimiento inserta los datos generales del alumnos solicitados en la prueba vocacional, al final retorna el codigo del alumno que esta haciendo la prueba>
	-- =============================================
	--exec sp_pv_inserta_datos_alumnos 'Fabio','Ramos','7343-4797','fabio.ramos@outlook.es','65','2','Ingeneria'
	@Nombres varchar(50),
	@Apellidos varchar(50),
	@Telefono varchar(10),
	@Correo varchar(150),
	@codcol int,--codigo del colegio, tbl: prb_col_colegios
	@codopc int,--codigo del tipo de estudio, tbl: prb_opc_opciones
	@Carrera varchar(50), --Carrera que quiere estudiar
	@Edad int,
	@Sexo nchar(1),
	@codmun varchar(100),--Codigo del municipio donde esta su colegio, tbl: uonline.dbo.ra_mun_municipios
	@Entidad nchar(2),--Publica Pu o Privada Pri
	@ContinuarEstudios nchar(2),
	@PosibilidadesEconomicas nchar(2),
	--NO SE ALMACENA EL CAMPO "Tipo de Evaluación:" y  es solicitado en el formulario
	--2019-08-12 08:34:11.813: SE AGREGO EL CAMPO @TipoEvaluacion para poder identificar los alumnos que llenaron la evaluacion unicamente con la escala6
	@TipoEvaluacion int = 1 -- Valores { 1: TourUTEC, 2: Otro, 3: PruebaEscala6 }
AS
BEGIN
	--Ultima modificacion hecha por Fabio, se ordeno de una forma mas clara el procedimiento y se documento, 2019-08-08 21:30:13.480
	set nocount on;
	insert into dbo.prb_adat_dat_alumno
           (adat_Nombres, adat_Apellidos, adat_Telefono, adat_Correo, adat_codcol, adat_Icodopc, adat_Carrera, adat_Edad, adat_Sexo, adat_codmun, adat_Entidad, adat_ContinuarEstudios, adat_PosibilidadesEconomicas, adat_TipoEvaluacion)
     values (@Nombres, @Apellidos, @Telefono, @Correo, @codcol, @codopc, @Carrera, @Edad, @Sexo, @codmun, @Entidad, @ContinuarEstudios, @PosibilidadesEconomicas, @TipoEvaluacion)
	
	select adat_IdAlumno 
	from prb_adat_dat_alumno 
	where adat_Nombres=@Nombres and adat_Apellidos=@Apellidos and 
	adat_Telefono=@Telefono and adat_Correo=@Correo and 
	adat_codcol=@codcol and adat_Icodopc=@codopc and adat_Carrera=@Carrera;
END

USE [PruebaVocacional]
GO
/****** Object:  StoredProcedure [dbo].[sp_pv_consultar_preguntas_escalas]    Script Date: 08/08/2019 21:28:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_pv_consultar_preguntas_escalas]
	-- =============================================
	-- Author:      <DESCONOCIDO>
	-- Create date: <DESCONOCIDO>
	-- Description: <Este procedimiento devuelve las preguntas de la @Escala segun la @categoria>
	-- =============================================
	--sp_pv_consultar_preguntas_escalas 6, 1 --DEVUELVE LA PREGUNTA JUNTO LAS OPCIONES DE LA ESCALA 6 PARTE 1
	@Escala int,
	@categoria int
AS
BEGIN
	--Ultima modificacion hecha por Fabio, se ordeno de una forma mas clara el procedimiento se elimino codigo redundante con la ayuda de la funcion dbo.fn_pre_categori_res y se documento, 2019-08-08 21:38:10.143

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@Escala=1 or @Escala=3 or @Escala=4 or @Escala=6)
	begin
		select distinct p.pre_Numeracion,p.pre_pregunta, p.pre_categorias--, p.pre_IdPregunta
		,
		--(select rs.res_Respuesta
		--from prb_pre_preguntas pr inner join prb_prer_preguntas_respuestas prs on pr.pre_IdPregunta=prs.prer_codpre 
		--inner join prb_res_respuestas rs on prs.prer_codres=rs.res_IdRespuesta
		--where prs.prer_codpre=p.pre_IdPregunta and prs.prer_Numero=1
		--) as Respuesta1,
		dbo.fn_pre_categori_res(p.pre_IdPregunta, 1, 1) Respuesta1
		, 
		--(select rs.res_Respuesta
		--from prb_pre_preguntas pr inner join prb_prer_preguntas_respuestas prs on pr.pre_IdPregunta=prs.prer_codpre 
		--inner join prb_res_respuestas rs on prs.prer_codres=rs.res_IdRespuesta
		--where prs.prer_codpre=p.pre_IdPregunta and prs.prer_Numero=2
		--) as Respuesta2,
		dbo.fn_pre_categori_res(p.pre_IdPregunta, 2, 1) Respuesta2
		,
		--(select rs.res_Respuesta
		--from prb_pre_preguntas pr inner join prb_prer_preguntas_respuestas prs on pr.pre_IdPregunta=prs.prer_codpre 
		--inner join prb_res_respuestas rs on prs.prer_codres=rs.res_IdRespuesta
		--where prs.prer_codpre=p.pre_IdPregunta and prs.prer_Numero=3
		--) as Respuesta3,
		dbo.fn_pre_categori_res(p.pre_IdPregunta, 3, 1) Respuesta3
		,
		--(select rs.res_Respuesta
		--from prb_pre_preguntas pr inner join prb_prer_preguntas_respuestas prs on pr.pre_IdPregunta=prs.prer_codpre 
		--inner join prb_res_respuestas rs on prs.prer_codres=rs.res_IdRespuesta
		--where prs.prer_codpre=p.pre_IdPregunta and prs.prer_Numero=4
		--) as Respuesta4,
		dbo.fn_pre_categori_res(p.pre_IdPregunta, 4, 1) Respuesta4
		,
		--(select rs.res_Respuesta
		--from prb_pre_preguntas pr inner join prb_prer_preguntas_respuestas prs on pr.pre_IdPregunta=prs.prer_codpre 
		--inner join prb_res_respuestas rs on prs.prer_codres=rs.res_IdRespuesta
		--where prs.prer_codpre=p.pre_IdPregunta and prs.prer_Numero=5
		--) as Respuesta5,
		dbo.fn_pre_categori_res(p.pre_IdPregunta, 5, 1) Respuesta5
		,
		--(select rs.res_Respuesta
		--from prb_pre_preguntas pr inner join prb_prer_preguntas_respuestas prs on pr.pre_IdPregunta=prs.prer_codpre 
		--inner join prb_res_respuestas rs on prs.prer_codres=rs.res_IdRespuesta
		--where prs.prer_codpre=p.pre_IdPregunta and prs.prer_Numero=6
		--) as Respuesta6,
		dbo.fn_pre_categori_res(p.pre_IdPregunta, 6, 1) Respuesta6
		,
		--(select pr.pre_categorias
		--from prb_pre_preguntas pr inner join prb_prer_preguntas_respuestas prs on pr.pre_IdPregunta=prs.prer_codpre 
		--inner join prb_res_respuestas rs on prs.prer_codres=rs.res_IdRespuesta
		--where prs.prer_codpre=p.pre_IdPregunta and prs.prer_Numero=2
		--) as Respuesta7,
		dbo.fn_pre_categori_res(p.pre_IdPregunta, 2, 0) Respuesta7
		from prb_esc_escalas e 
		inner join prb_pre_preguntas p on e.esc_codesc=p.pre_codesc 
		inner join prb_prer_preguntas_respuestas pr on pr.prer_codpre=p.pre_IdPregunta 
		inner join prb_res_respuestas r on pr.prer_codres=r.res_IdRespuesta
		where e.esc_codesc=@Escala and p.pre_categorias=@categoria
		group by p.pre_categorias, p.pre_pregunta, p.pre_Numeracion,r.res_Respuesta,p.pre_IdPregunta
		order by p.pre_categorias, p.pre_Numeracion
	end
	else if (@Escala=2)
	begin
		select  p.pre_Numeracion,p.pre_pregunta
		,p.pre_url2
		 as Solucion, pr.prer_Numero  as Respuesta
		from prb_esc_escalas e 
		inner join prb_pre_preguntas p on e.esc_codesc=p.pre_codesc 
		inner join prb_prer_preguntas_respuestas pr on pr.prer_codpre=p.pre_IdPregunta 
		inner join prb_res_respuestas r on pr.prer_codres=r.res_IdRespuesta
		where e.esc_codesc=@Escala
		group by  p.pre_pregunta, p.pre_Numeracion,r.res_Respuesta,p.pre_IdPregunta,p.pre_url2,pr.prer_Numero
		order by p.pre_Numeracion
	end
	else if(@Escala=7)
	begin
		select distinct p.pre_Numeracion,p.pre_pregunta, p.pre_categorias
		,
		--(select rs.res_Respuesta
		--from prb_pre_preguntas pr inner join prb_prer_preguntas_respuestas prs on pr.pre_IdPregunta=prs.prer_codpre 
		--inner join prb_res_respuestas rs on prs.prer_codres=rs.res_IdRespuesta
		--where prs.prer_codpre=p.pre_IdPregunta and prs.prer_Numero=1
		--) as Respuesta1,
		dbo.fn_pre_categori_res(p.pre_IdPregunta, 1, 1) Respuesta1
		,
		--(select rs.res_Respuesta
		--from prb_pre_preguntas pr inner join prb_prer_preguntas_respuestas prs on pr.pre_IdPregunta=prs.prer_codpre 
		--inner join prb_res_respuestas rs on prs.prer_codres=rs.res_IdRespuesta
		--where prs.prer_codpre=p.pre_IdPregunta and prs.prer_Numero=2
		--) as Respuesta2,
		dbo.fn_pre_categori_res(p.pre_IdPregunta, 2, 1) Respuesta2
		,
		--(select rs.res_Respuesta
		--from prb_pre_preguntas pr inner join prb_prer_preguntas_respuestas prs on pr.pre_IdPregunta=prs.prer_codpre 
		--inner join prb_res_respuestas rs on prs.prer_codres=rs.res_IdRespuesta
		--where prs.prer_codpre=p.pre_IdPregunta and prs.prer_Numero=3
		--) as Respuesta3,
		dbo.fn_pre_categori_res(p.pre_IdPregunta, 3, 1) Respuesta3
		,
		--(select rs.res_Respuesta
		--from prb_pre_preguntas pr inner join prb_prer_preguntas_respuestas prs on pr.pre_IdPregunta=prs.prer_codpre 
		--inner join prb_res_respuestas rs on prs.prer_codres=rs.res_IdRespuesta
		--where prs.prer_codpre=p.pre_IdPregunta and prs.prer_Numero=4
		--) as Respuesta4,
		dbo.fn_pre_categori_res(p.pre_IdPregunta, 4, 1) Respuesta4
		,
		--(select rs.res_Respuesta
		--from prb_pre_preguntas pr inner join prb_prer_preguntas_respuestas prs on pr.pre_IdPregunta=prs.prer_codpre 
		--inner join prb_res_respuestas rs on prs.prer_codres=rs.res_IdRespuesta
		--where prs.prer_codpre=p.pre_IdPregunta and prs.prer_Numero=5
		--) as Respuesta5,
		dbo.fn_pre_categori_res(p.pre_IdPregunta, 5, 1) Respuesta5
		,
		--(select rs.res_Respuesta
		--from prb_pre_preguntas pr inner join prb_prer_preguntas_respuestas prs on pr.pre_IdPregunta=prs.prer_codpre 
		--inner join prb_res_respuestas rs on prs.prer_codres=rs.res_IdRespuesta
		--where prs.prer_codpre=p.pre_IdPregunta and prs.prer_Numero=6
		--) as Respuesta6,
		dbo.fn_pre_categori_res(p.pre_IdPregunta, 6, 1) Respuesta6
		,
		--(select pr.pre_categorias
		--from prb_pre_preguntas pr inner join prb_prer_preguntas_respuestas prs on pr.pre_IdPregunta=prs.prer_codpre 
		--inner join prb_res_respuestas rs on prs.prer_codres=rs.res_IdRespuesta
		--where prs.prer_codpre=p.pre_IdPregunta and prs.prer_Numero=2
		--) as Respuesta7,
		dbo.fn_pre_categori_res(p.pre_IdPregunta, 7, 0) Respuesta7
		from prb_esc_escalas e 
		inner join prb_pre_preguntas p on e.esc_codesc=p.pre_codesc 
		inner join prb_prer_preguntas_respuestas pr on pr.prer_codpre=p.pre_IdPregunta 
		inner join prb_res_respuestas r on pr.prer_codres=r.res_IdRespuesta
		where e.esc_codesc=@Escala
		group by p.pre_categorias, p.pre_pregunta, p.pre_Numeracion,r.res_Respuesta,p.pre_IdPregunta
		order by  p.pre_Numeracion
	end
END

USE [PruebaVocacional]
GO
/****** Object:  StoredProcedure [dbo].[sp_pv_respuestas_preguntas]    Script Date: 08/08/2019 21:42:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[sp_pv_respuestas_preguntas]
	-- =============================================
	-- Author:      <DESCONOCIDO>
	-- Create date: <DESCONOCIDO>
	-- Description: <Este procedimiento devuelve las opciones de la pregunta @Numeracionp de la @Escala segun la @categoria>
	-- =============================================
	-- exec [sp_pv_respuestas_preguntas] 1,6,1
	@Numeracionp int,
	@Escala int,
	@categoria int
as
begin
	--Ultima modificacion hecha por Fabio, se ordeno de una forma mas clara el procedimiento y se documento, 2019-08-08 21:45:27.463

	if(@Escala=1 or @Escala=2 or @Escala=3 or @Escala=4 or @Escala=6)
	begin
		select p.pre_Numeracion,pr.prer_Numero,r.res_Respuesta,r.res_IdRespuesta, p.pre_pregunta
			from prb_pre_preguntas p 
			inner join prb_prer_preguntas_respuestas pr on p.pre_IdPregunta=pr.prer_codpre 
			inner join prb_res_respuestas r on pr.prer_codres=r.res_IdRespuesta
		where p.pre_codesc=@Escala and p.pre_Numeracion=@Numeracionp and p.pre_categorias=@categoria
		order by p.pre_categorias,p.pre_Numeracion, pr.prer_Numero
	end
	else if(@Escala=7)
	begin
		select p.pre_Numeracion,pr.prer_Numero,r.res_Respuesta,r.res_IdRespuesta, p.pre_pregunta
			from prb_pre_preguntas p 
			inner join prb_prer_preguntas_respuestas pr on p.pre_IdPregunta=pr.prer_codpre 
			inner join prb_res_respuestas r on pr.prer_codres=r.res_IdRespuesta
		where p.pre_codesc=@Escala and p.pre_Numeracion=@Numeracionp 
		order by p.pre_categorias,p.pre_Numeracion, pr.prer_Numero
	end
end

use pruebavocacional
go
/****** object:  storedprocedure dbo.ps_pv_respuestas_alumnos_escala_6_7    script date: 08/08/2019 22:01:09 ******/
set ansi_nulls on
go
set quoted_identifier on
go
alter procedure dbo.ps_pv_respuestas_alumnos_escala_6_7
	-- =============================================
	-- Author:      <DESCONOCIDO>
	-- Create date: <DESCONOCIDO>
	-- Description: <Este procedimiento INSERTA las respuestas para la escala 6 y 7>
	-- =============================================
	-- ps_pv_respuestas_alumnos_escala_6_7 63114, '673,673,673,673,673,673,673,673,673,673,673,673,673,673,673,673', '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16', 6, 1
	-- ps_pv_respuestas_alumnos_escala_6_7 63114, '670,670,670,670,670,670,670,670,670,670,670,670,670,670,670,670', '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16', 6, 2
	@idalumno int,
	@Numero_r varchar(3000),
	@Numero_p varchar(3000),
	@Escala int,
	@Categoria int
as
begin
	--Ultima modificacion hecha por Fabio, se ordeno de una forma mas clara el procedimiento y se documento, 2019-08-08 22:11:33.953
	set nocount on;
	declare @numer_p varchar(3000)--codigos de las preguntas
	declare @numer_r varchar(3000)--codigos de las respuestas
	declare @dat_p varchar(7)
	declare @dat_r varchar(7)
	declare @lg_p int
	declare @lg_r int
	declare @prueba int
	set @numer_r =@numero_r+',0' --cadena de ejemplo.
	set @numer_p=@numero_p+',0'  --cadena de numeracion de pregunta  de la escala 6 o 7
	set @prueba=len(@numer_r)
	if(@escala=6)
	begin
		while  len(@numer_r)> 1
		begin
			set @lg_p = charindex(',', @numer_p) -- buscado el caracter separador
			set @lg_r =charindex(',', @numer_r)
			if (@lg_r=0 )
			begin
				set @dat_p = ''
				set @dat_r = ''
			end
			else
			begin
			set @dat_p = substring(@numer_p, 1, @lg_p-1)
			set @numer_p = substring(@numer_p, @lg_p + 1, len(@numer_p))
			set @dat_r = substring(@numer_r, 1, @lg_r-1)
			set @numer_r = substring(@numer_r, @lg_r + 1, len(@numer_r))
			end
			insert into dbo.prb_resa_respuestas_alumnos(resa_codadat, resa_codpre, resa_numero)
			select cast(@idalumno as varchar),pr.prer_codpre,@dat_r
				from prb_pre_preguntas p 
				inner join prb_prer_preguntas_respuestas pr on p.pre_idpregunta=pr.prer_codpre 
				inner join prb_res_respuestas r on pr.prer_codres=r.res_idrespuesta  
			where p.pre_numeracion = (@dat_p) and p.pre_codesc=@escala and p.pre_categorias=@categoria and pr.prer_codres=@dat_r
		end
		update dbo.prb_adat_dat_alumno set adat_escala=6 where adat_idalumno=@idalumno
	end--if(@escala=6)
	else if(@escala=7)
	begin
		while  len(@numer_r)> 1
		begin
			set @lg_p = charindex(',', @numer_p) -- buscado el caracter separador
			set @lg_r =charindex(',', @numer_r)
			if (@lg_r=0 )
			begin
				set @dat_p = ''
				set @dat_r = ''
			end
			else
			begin
			set @dat_p = substring(@numer_p, 1, @lg_p-1)
			set @numer_p = substring(@numer_p, @lg_p + 1, len(@numer_p))
			set @dat_r = substring(@numer_r, 1, @lg_r-1)
			set @numer_r = substring(@numer_r, @lg_r + 1, len(@numer_r))
			end
			insert into dbo.prb_resa_respuestas_alumnos (resa_codadat, resa_codpre, resa_numero)
			select cast(@idalumno as varchar),pr.prer_codpre,@dat_r
				from prb_pre_preguntas p 
				inner join prb_prer_preguntas_respuestas pr on p.pre_idpregunta=pr.prer_codpre 
				inner join prb_res_respuestas r on pr.prer_codres=r.res_idrespuesta  
			where p.pre_numeracion = (@dat_p) and p.pre_codesc=@escala and pr.prer_codres=@dat_r
		end--while  len(@numer_r)> 1
		update dbo.prb_adat_dat_alumno set  adat_estado = 1, adat_escala = 7 where adat_idalumno = @idalumno
	end--else if(@escala=7)
	else if(@escala=4)
	begin
		while len(@numer_r)> 1
		begin
			set @lg_p = charindex(',', @numer_p) -- buscado el caracter separador
			set @lg_r =charindex(',', @numer_r)
			if (@lg_r=0 )
			begin
				set @dat_p = ''
				set @dat_r = ''
			end
			else
			begin
			set @dat_p = substring(@numer_p, 1, @lg_p-1)
			set @numer_p = substring(@numer_p, @lg_p + 1, len(@numer_p))
			set @dat_r = substring(@numer_r, 1, @lg_r-1)
			set @numer_r = substring(@numer_r, @lg_r + 1, len(@numer_r))
			end
			insert into dbo.prb_resa_respuestas_alumnos(resa_codadat, resa_codpre, resa_numero)
			select cast(@idalumno as varchar),pr.prer_codpre,@dat_r
				from prb_pre_preguntas p 
				inner join prb_prer_preguntas_respuestas pr on p.pre_idpregunta=pr.prer_codpre 
				inner join prb_res_respuestas r on pr.prer_codres=r.res_idrespuesta  
			where p.pre_numeracion = (@dat_p) and p.pre_codesc = @escala and pr.prer_codres = @dat_r
		end--while len(@numer_r)> 1
		update dbo.prb_adat_dat_alumno set adat_escala = 4 where adat_idalumno=@idalumno
	end--else if(@escala=4)
	select 1
end

-- ESTO ES PARA SACAR LAS CARRERAS QUE EL ALUMNO PUEDE LLEVAR SEGUN SUS INTERESES PROFESIONALES
-- sp_help prb_cat_categorias
-- drop table prb_car_carreras
-- Estas carreras son las que le salen al alumno como opciones en base a sus intereses
create table prb_car_carreras(
	car_codigo int primary key identity(1, 1),
	car_nombre varchar(255),
	car_oferta_utec bit, --{ 1: Carrera si es dada en la UTEC, 0: Carrera no es dada en la UTEC}
	car_fecha_creacion datetime default getdate()
)
-- select * from prb_car_carreras
/*
insert into prb_car_carreras(car_nombre, car_oferta_utec)
values ('Ingeniería Industrial', 1),
('Ingeniería en Sistemas y Computación', 1),
('Técnico en Informática', 0),
('Ingeniería Mecánica', 0),
('Licenciatura en Ciencias Jurídicas', 1),
('Licenciatura en Relaciones Internacionales', 0),
('Licenciatura en Ciencias Políticas', 0),
('Doctorado en Medicina', 0),
('Odontología', 0),
('Técnico en Enfermería', 0),
('Licenciatura en Enfermería', 0),
('Técnico Electricista', 0),
('Técnico en Administración de Restaurantes', 0),
('Técnico en Mecánica Automotriz', 0),
('Licenciatura en Psicología', 1),
('Licenciatura en Antropología', 1),
('Licenciatura en Arqueología', 1),
('Licenciatura en Biología', 0),
('Medicina Veterinaria', 0),
('Ingeniería Agronómica', 0),
('Técnico en Periodismo', 1),
('Licenciatura en Periodismo', 1),
('Licenciatura en Idioma Ingles', 1),
('Licenciatura en Letras', 0),
('Licenciatura en Comunicaciones', 1),
('Técnico en Relaciones Publicas', 0),
('Técnico en Publicidad', 0),
('Licenciatura en Publicidad', 0),
('Arquitectura', 1),
('Técnico en Diseño Grafico', 1),
('Licenciatura en Diseño Grafico', 1),
('Licenciatura en Artes Plásticas', 0),
('Relaciones Públicas', 1),
('Licenciatura en Negocios Internacionales', 1),
('Licenciatura en Administración de Empresas', 1),
('Licenciatura en Ciencias de la Educación', 0),
('Licenciatura en Educación Parvulario', 0),
('Profesorado en Educación Básica', 0),
('Administración Turística', 1),
('Licenciatura en Contaduría Pública', 1),
('Licenciatura en Mercadeo', 1),
('Técnico en Mercadeo', 0)
*/

select *
--cat_no, cat_categoria 
from prb_cat_categorias where cat_idesc = 6
select car_codigo, car_nombre from uonline.dbo.ra_car_carreras where car_estado = 'A' and car_codtde = 1 and car_nombre not like '%NO PRESENCIAL%'
select * from prb_adat_dat_alumno where adat_IdAlumno = 63114

-- drop table prb_carcat_carreras_categoria
create table prb_carcat_carreras_categoria(
	carcat_codigo int primary key identity(1, 1),
	carcat_cat_no int /*foreign key references prb_cat_categorias*/, 
	carcat_codcar int foreign key references prb_car_carreras,--references uonline.dbo.ra_car_carreras,
	carcat_fecha_creacion datetime default getdate()
)
-- select * from prb_carcat_carreras_categoria
-- insert into prb_carcat_carreras_categoria(carcat_cat_no, carcat_codcar) values (11, 2), (11, 1), (11, 3), (11, 4), (13, 5), (13, 6), (13, 7), (14, 8), (14, 9), (14, 10), (14, 11), (15, 12), (15, 13), (15, 14), (16, 15), (16, 16), (16, 17), (17, 18), (17, 19), (17, 20), (21, 22), (21, 21), (21, 23), (21, 24), (22, 25), (22, 26), (22, 27), (22, 28), (23, 31), (23, 29), (23, 30), (23, 32), (24, 1), (24, 33), (24, 22), (24, 34), (24, 35), (25, 36), (25, 37), (25, 38), (26, 35), (26, 39), (26, 40), (26, 41), (26, 42)

select carcat_codigo, cat_categoria, car_nombre 
from prb_carcat_carreras_categoria
inner join prb_cat_categorias on cat_no = carcat_cat_no
inner join prb_car_carreras /*uonline.dbo.ra_car_carreras*/ on car_codigo = carcat_codcar

-- rpe_prueba_vocacional_general '08/08/2019', '08/08/2019'

select * from prb_adat_dat_alumno 
where convert(date, adat_Fecha, 103) = '08/08/2019'
order by adat_Fecha desc

select * from prb_usu_usuarios
USE [PruebaVocacional]
GO
/****** Object:  StoredProcedure [dbo].[rpe_prueba_vocacional_general]    Script Date: 10/08/2019 8:24:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter procedure [dbo].[rpe_prueba_vocacional_general_escala6_por_estudiante]
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-08-10 09:08:16.543>
	-- Description: <Este procedimiento se realizo exclusivanete para mostrar los resultados de la escala 6, se usa en .29/prueba_vocacional/escala6/Escala6.aspx>
	-- =============================================
	-- rpe_prueba_vocacional_general_escala6_por_estudiante 1, 63114, '', '' --Devuelve los resultados de la escala 6 del alumno @IdAlumno
	-- rpe_prueba_vocacional_general_escala6_por_estudiante 2, 0, '08/08/2019', '08/08/2019' --Devuelve los resultados de la escala 6 de todos los alumnos segun el rango @fecha_inicio - @fehca_fin
	-- rpe_prueba_vocacional_general '08/08/2019', '08/08/2019'
	@opcion int = 1, --{1: por alumnos segun @IdAlumno, 2: todos los alumnos que realizaron la prueba segun el rango @fecha_inicio - @fehca_fin}
	@IdAlumno int = 0,
	@fecha_inicio varchar(12) = '',
	@fehca_fin varchar(12) = ''
as 
begin
	--TABLA DONDE SE ALMACENAN LAS RESPUESTAS DEL ALUMNO
	-- SELECT * from prb_resa_respuestas_alumnos where resa_codadat = 63114
	-- delete from prb_resa_respuestas_alumnos where resa_codadat = 63114
	--select * from prb_resa_respuestas_alumnos 
	--inner join prb_pre_preguntas p on resa_codpre=pre_IdPregunta
	--inner join prb_prer_preguntas_respuestas on prer_codpre=resa_codpre 
	--	--inner join prb_pre_preguntas p on prer_codpre=pre_IdPregunta
	--where resa_codadat = 63114 and pre_codesc=6

	--******************************************************************************************************************************************
	--  Creando tablas temporales
	--******************************************************************************************************************************************
	-- Encabezado de alumno
	set dateformat dmy
	declare @Alumnos as table(
		Codigo int, 
		Nombres varchar(50), 
		Apellidos varchar(50), 
		Colegio varchar(150), 
		Bachillerato varchar(50), 
		Telefono varchar(10), 
		Correo varchar(150), 
		Carrera varchar(50), 
		carrera1 varchar(50), 
		carrera2 varchar(50), 
		carrera3 varchar(50), 
		Fecha datetime
	)
	if @opcion = 1 --Solo se mostrar los resultados del alumno @IdAlumno
	begin
		insert into @Alumnos
		select  adat_IdAlumno as [Codigo], adat_Nombres as [Nombres], adat_Apellidos as [Apellidos], col_Colegio as [Colegio], opc_Opcion as [Bachillerato], adat_Telefono as [Telefono], adat_Correo as [Correo], adat_Carrera as [Carrera],'carrera1' as [Carrera1],'carrera2' as [Carrera2],'carrera3' as [Carrera3], dat.adat_Fecha as Fecha
		from dbo.prb_adat_dat_alumno dat  
			inner join	dbo.prb_opc_opciones opc on opc.opc_IdOpcion = dat.adat_Icodopc 
			inner join	dbo.prb_col_colegios col on col.col_IdColegio = dat.adat_codcol
		where adat_IdAlumno = @IdAlumno
	end
	else if @opcion = 2 --Se mostrar los resultados del rango de fecha @fecha_inicio - @fehca_fin
	begin
		insert into @Alumnos
		select  adat_IdAlumno as [Codigo], adat_Nombres as [Nombres], adat_Apellidos as [Apellidos], col_Colegio as [Colegio], opc_Opcion as [Bachillerato], adat_Telefono as [Telefono], adat_Correo as [Correo], adat_Carrera as [Carrera],'carrera1' as [Carrera1],'carrera2' as [Carrera2],'carrera3' as [Carrera3], dat.adat_Fecha as Fecha
		from dbo.prb_adat_dat_alumno dat  
			inner join	dbo.prb_opc_opciones opc on opc.opc_IdOpcion = dat.adat_Icodopc 
			inner join	dbo.prb_col_colegios col on col.col_IdColegio = dat.adat_codcol
		where Convert(date,adat_Fecha,103) >=@fecha_inicio and  Convert(date,adat_Fecha,103) <=@fehca_fin
	end
	
	declare @Resultados_G as table(
	--create table #Resultados_G(
		Id int  identity(1,1) primary key,
		Codigo int,
		Nombres varchar(50),
		Apellidos varchar(50),
		Colegio varchar(100),
		Bachillerato varchar(20),
		Telefono varchar(12),
		Correo varchar(50),
		Carrera varchar(max),
		Carrera1 varchar(max),
		Carrera2 varchar(max),
		Carrera3 varchar(max),
		R_Comprension_Verbal int,Comprension_Verbal varchar(20),	-- Escala 1
		R_Concepcion_Espacial int,Concepcion_Espacial varchar(20),	-- Escala 2
		R_Razonamiento int,Razonamiento varchar(20),				-- Escala 3
		R_Calculo_Numerico int,Calculo_Numerico varchar(20),		-- Escala 4
		R_Fluidez_Verbal int,Fluidez_Verbal varchar(20),			-- Escala 5
														
		Es1_1 int,Es1_2 int,Es1_3 int,Es1_4 int,		-- Escala 6
		Es2_1 int,Es2_2 int,Es2_3 int,Es2_4 int,
		Es3_1 int,Es3_2 int,Es3_3 int,Es3_4 int,
		Es4_1 int,Es4_2 int,Es4_3 int,Es4_4 int,
		Es5_1 int,Es5_2 int,Es5_3 int,Es5_4 int,
		Es6_1 int,Es6_2 int,Es6_3 int,Es6_4 int,
		Es7_1 int,Es7_2 int,Es7_3 int,Es7_4 int,
		Es8_1 int,Es8_2 int,Es8_3 int,Es8_4 int,
		Es9_1 int,Es9_2 int,Es9_3 int,Es9_4 int,
		Es10_1 int,Es10_2 int,Es10_3 int,Es10_4 int,
		Es11_1 int,Es11_2 int,Es11_3 int,Es11_4 int,
		Es12_1 int,Es12_2 int,Es12_3 int,Es12_4 int,
		EsS_1 int,EsS_2 int,EsS_3 int,EsS_4 int,		-- Sumatoria de resultados escala 6
																					-- Escala 7
		R_Ambiente_Material int, Ambiente_Material varchar(20),						-- Escala 7-1[Ambiente Material]
		R_Estado_Habitos_Fisiologicos int, Estado_Habitos_Fisiologicos varchar(20),	-- Escala 7-2[Estado y Hábitos Fisiológicos]
		R_Distribucion_Tiempo int,Distribucion_Tiempo varchar(20),					-- Escala 7-3[Distribución del Tiempo]
		R_Tecnicas_Toma_Notas_Apuntes int,Tecnicas_Toma_Notas_Apuntes varchar(20),	-- Escala 7-4[Técnicas de Toma de Notas y Apuntes]
		R_Habitos_Lectura int,Habitos_Lectura varchar(20),							-- Escala 7-5[Hábitos de Lectura]
		R_Tecnicas_Lectura int,Tecnicas_Lectura varchar(20),						-- Escala 7-6[Técnicas de Lectura]
		R_Habitos_Concentracion int,Habitos_Concentracion varchar(20),				-- Escala 7-7 [Hábitos de Concentración]
		R_Actitud_Estudio int,Actitud_Estudio varchar(20),							-- Escala 7-8[Actitud hacia el Estudio]
		R_Informes_Escritos int,Informes_Escritos varchar(20),						-- Escala 7-9[Informes Escritos]
		R_Informes_Orales int,Informes_Orales varchar(20), 							-- Escala 7-10							
		Fecha datetime,															-- Fecha
		RI1 int,I1 varchar(50),														-- Intereces escala 6 resultados
		RI2 int,I2 varchar(50),
		RI3 int,I3 varchar(50)
	)
	--drop table #Resultados_G
	declare 
	@Codigo int, @Nombres varchar(50), @Apellidos varchar(50), @Colegio varchar(100), @Bachillerato varchar(20), 
	@Telefono varchar(12), @Correo varchar(50), @Carrera varchar(100), @Carrera1 varchar(20), @Carrera2 varchar(20), 
	@Carrera3 varchar(20), @Fecha datetime

	--******************VARIABLES PARA EL CURSOR******************--
	declare 
	@resa_numero varchar(300),
	@R_Comprension_Verbal int,@Comprension_Verbal varchar(20),		-- Escala 1
	@R_Concepcion_Espacial int,@Concepcion_Espacial varchar(20),	-- Escala 2
	@R_Razonamiento int,@Razonamiento varchar(20),					-- Escala 3
	@R_Calculo_Numerico int,@Calculo_Numerico varchar(20),			-- Escala 4
	@R_Fluidez_Verbal int,@Fluidez_Verbal varchar(20)				-- Escala 5
	declare -- Escala 6
	@Es1_1 int,@Es1_2 int,@Es1_3 int,@Es1_4 int,
	@Es2_1 int,@Es2_2 int,@Es2_3 int,@Es2_4 int,
	@Es3_1 int,@Es3_2 int,@Es3_3 int,@Es3_4 int,
	@Es4_1 int,@Es4_2 int,@Es4_3 int,@Es4_4 int,
	@Es5_1 int,@Es5_2 int,@Es5_3 int,@Es5_4 int,
	@Es6_1 int,@Es6_2 int,@Es6_3 int,@Es6_4 int,
	@Es7_1 int,@Es7_2 int,@Es7_3 int,@Es7_4 int,
	@Es8_1 int,@Es8_2 int,@Es8_3 int,@Es8_4 int,
	@Es9_1 int,@Es9_2 int,@Es9_3 int,@Es9_4 int
	declare
	@Es10_1 int,@Es10_2 int,@Es10_3 int,@Es10_4 int,
	@Es11_1 int,@Es11_2 int,@Es11_3 int,@Es11_4 int,
	@Es12_1 int,@Es12_2 int,@Es12_3 int,@Es12_4 int,
	-- Sumatoria de resultados escala 6
	@EsS_1 int,@EsS_2 int,@EsS_3 int,@EsS_4 int

	declare -- Escala 7
	@R_Ambiete_Material int, @Ambiete_Material varchar(20),							-- Escala 7-1[Ambiente Material]
	@R_Estado_Habitos_Fisiologicos int, @Estado_Habitos_Fisiologicos varchar(20),	-- Escala 7-2[Estado y Hábitos Fisiológicos]
	@R_Distribucion_Tiempo int,@Distribucion_Tiempo varchar(20),					-- Escala 7-3[Distribución del Tiempo]
	@R_Tecnicas_Toma_Notas_Apuntes int,@Tecnicas_Toma_Notas_Apuntes varchar(20),	-- Escala 7-4[Técnicas de Toma de Notas y Apuntes]
	@R_Habitos_Lectura int,@Habitos_Lectura varchar(20),							-- Escala 7-5[Hábitos de Lectura]
	@R_Tecnicas_Lectura int,@Tecnicas_Lectura varchar(20),							-- Escala 7-6[Técnicas de Lectura]
	@R_Habitos_Concentracion int,@Habitos_Concentracion varchar(20),				-- Escala 7-7 [Hábitos de Concentración]
	@R_Actitud_Estudio int,@Actitud_Estudio varchar(20)
	declare																			-- Escala 7-8[Actitud hacia el Estudio]
	@R_Informes_Escritos int,@Informes_Escritos varchar(20),						-- Escala 7-9[Informes Escritos]
	@R_Informes_Orales int,@Informes_Orales varchar(20), 							-- Escala 7-10[Informes Orales]
	-- Intereces escala 6 resultados
	@RI1 int,@I1 varchar(50),
	@RI2 int,@I2 varchar(50),
	@RI3 int,@I3 varchar(50),
	-- VARIABLES PARA DETERMINAR LA CARRERA SEGUN EL INTERES PROFESIONAL
	@carcat_cat_no1 int, @carcat_cat_no2 int, @carcat_cat_no3 int, 
	@CAR_1 varchar(max) = '', @CAR_2 varchar(max) = '', @CAR_3 varchar(max) = ''
	--******************VARIABLES PARA EL CURSOR******************--

	-- Declaración del cursor
	declare Alumnos_r cursor for
	select Codigo,Nombres,Apellidos,Colegio,Bachillerato,Telefono,Correo,Carrera,Carrera1,Carrera2,Carrera3,Fecha from @Alumnos
	open Alumnos_r 
	fetch Alumnos_r into  @Codigo,@Nombres ,@Apellidos ,@Colegio ,@Bachillerato ,@Telefono ,@Correo ,@Carrera ,@Carrera1 ,@Carrera2 ,@Carrera3,@Fecha
	while (@@FETCH_STATUS = 0 )
	begin
		-- Respuestas generales de alumnos
		select resa_Numero into #respuestas_alumnos 
		from prb_resa_respuestas_alumnos  where resa_codadat=@Codigo

		-- Respuestas correctas por escala 1-5
		--DESCOMENTAREAR para los resultados de las escalas 1-5
		------print '@Codigo ' + cast(@Codigo as varchar(5))
		------select Correctas,Escala
		------into #Correctas_x_escala
		------from(

		------	select count(prer_correcta) as Correctas, pre_codesc as Escala
		------	from prb_resa_respuestas_alumnos join prb_prer_preguntas_respuestas on prer_codpre=resa_codpre
		------	join prb_pre_preguntas on prer_codpre=pre_Idpregunta
		------	where prer_codpre=resa_codpre and prer_codres=resa_numero and resa_codadat=@Codigo and  prer_correcta=1  
		------	group by pre_codesc
		------	union
		------	select count(prer_correcta) as Correctas,pre_codesc as Escala
		------	from prb_resa_respuestas_alumnos join prb_prer_preguntas_respuestas on prer_codpre=resa_codpre
		------	join prb_pre_preguntas on prer_codpre=pre_Idpregunta
		------	where prer_codpre=resa_codpre and prer_numero=resa_numero and resa_codadat=@Codigo and  prer_correcta=1  and pre_codesc=2
		------	group by pre_codesc
		------	union
		------	--select isnull(resa.resa_Numero,0) as Correctas,5 Escala
		------	--from prb_adat_dat_alumno alum inner join prb_resa_respuestas_alumnos resa on alum.adat_IdAlumno=resa.resa_codadat
		------	--where resa.resa_codpre=218 and  alum.adat_IdAlumno=@Codigo
		------	select count([resp_palabra]) as Correctas, 5 Escala
		------	FROM [PruebaVocacional].[dbo].[prb_resp_respuesta_palabras]
		------	where resp_codAlumno=@Codigo
		------) t

		-- Respuestas Numero Escala 6
		--select 'PREGUNTAS CONTESTADAS', 'ESCALA', 'CATEGORIA', 'RESPUESTA DADAS'
		select count(resa.resa_Numero) Correctas, pre_codesc Escala,pre_categorias Categoria,prer_Numero Numeracion
		into #Resultados_Numero_Escala_6
		from prb_adat_dat_alumno alum
			inner join prb_resa_respuestas_alumnos resa on alum.adat_IdAlumno=resa.resa_codadat
			inner join prb_prer_preguntas_respuestas prer on prer.prer_codpre=resa.resa_codpre 
			inner join prb_pre_preguntas p on prer.prer_codpre=p.pre_IdPregunta
		where prer.prer_codpre=p.pre_IdPregunta  and resa.resa_Numero=prer.prer_codres and alum.adat_IdAlumno=@Codigo and p.pre_codesc=6
		group by pre_codesc,pre_categorias,prer_Numero 
		order by pre_codesc,pre_categorias

		-- Respuestas Correctas Escala  6 ordenado de mayor a menor
		select row_number() over(order by count(prer.prer_Correcta) desc) as Id, cat_no, count(prer.prer_Correcta) Correctas, pre_codesc Escala, pre_categorias Categoria, prer_Numero Numeracion, cat.cat_categoria Descripcion
		into #Resultados_Correctas_Escala_6
		from prb_adat_dat_alumno alum 
			inner join prb_resa_respuestas_alumnos resa on alum.adat_IdAlumno = resa.resa_codadat
			inner join prb_prer_preguntas_respuestas prer on prer.prer_codpre = resa.resa_codpre 
			inner join prb_pre_preguntas p on prer.prer_codpre = p.pre_IdPregunta
			inner join prb_cat_categorias cat on cat.cat_codcat = p.pre_categorias
		where prer.prer_codpre = p.pre_IdPregunta and resa.resa_Numero = prer.prer_codres and alum.adat_IdAlumno = @Codigo and p.pre_codesc = 6 
		and prer_Numero = 4 and p.pre_codesc = cat.cat_idesc and p.pre_categorias = cat.cat_codcat
		group by pre_codesc,pre_categorias,prer_Numero,cat.cat_categoria, cat_no
		order by count(resa.resa_Numero) desc, pre_codesc,pre_categorias
		
		-- Respuestas Correctas Escala  7 
		--DESCOMENTAREAR para los resultados de las escalas 7
		------select	count(prer.prer_Correcta) Correctas,pre_codesc Escala,pre_categorias Categoria,prer_Numero Numeracion
		------into #Resultados_Correctas_Escala_7
		------from prb_adat_dat_alumno alum 
		------	inner join prb_resa_respuestas_alumnos resa on alum.adat_IdAlumno=resa.resa_codadat
		------	inner join prb_prer_preguntas_respuestas prer on prer.prer_codpre=resa.resa_codpre 
		------	inner join prb_pre_preguntas p on prer.prer_codpre=p.pre_IdPregunta
		------where prer.prer_codpre=p.pre_IdPregunta  and resa.resa_Numero=prer.prer_codres and alum.adat_IdAlumno=@Codigo and p.pre_codesc=7 and prer_Numero=1
		------group by pre_codesc,pre_categorias,prer_Numero 
		------order by  pre_codesc,pre_categorias

		--*************************************************************************************************************************************************
		--                                                 Escala 1-5
		--*************************************************************************************************************************************************
		--DESCOMENTAREAR para los resultados de las escalas 1-5
		/*
		select @R_Comprension_Verbal=(select Correctas from #Correctas_x_escala where Escala=1) 
		select @Comprension_Verbal=(select r.ran_Rango from prb_ran_rango r where r.ran_IdEscala=1 and r.ran_Inicio<=@R_Comprension_Verbal  and r.ran_Fin> @R_Comprension_Verbal)
		
		select @R_Concepcion_Espacial=isnull((select Correctas from #Correctas_x_escala where Escala=2),0)
		select @Concepcion_Espacial=(select r.ran_Rango from prb_ran_rango r where r.ran_IdEscala=2 and r.ran_Inicio<=@R_Concepcion_Espacial  and r.ran_Fin> @R_Concepcion_Espacial)

		select @R_Razonamiento=(select Correctas from #Correctas_x_escala where Escala=3) 
		select @Razonamiento=(select r.ran_Rango from prb_ran_rango r where r.ran_IdEscala=3 and r.ran_Inicio<=@R_Razonamiento  and r.ran_Fin> @R_Razonamiento)

		select @R_Calculo_Numerico=(select Correctas from #Correctas_x_escala where Escala=4) 
		select @Calculo_Numerico=(select r.ran_Rango from prb_ran_rango r where r.ran_IdEscala=4 and r.ran_Inicio<=@R_Calculo_Numerico  and r.ran_Fin> @R_Calculo_Numerico)
		
		select @R_Fluidez_Verbal=(select Correctas from #Correctas_x_escala where Escala=5) 
		select @Fluidez_Verbal=(select r.ran_Rango from prb_ran_rango r where r.ran_IdEscala=5 and r.ran_Inicio<=@R_Fluidez_Verbal  and r.ran_Fin> @R_Fluidez_Verbal)
		*/
		--*************************************************************************************************************************************************
		--                                                 Escala 6
		--*************************************************************************************************************************************************
		select @Es1_1 = (select Correctas from #Resultados_Numero_Escala_6 where Categoria=1 and Numeracion=1) --as [Fisico Quimico Desconocida],
		select @Es1_2 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=1 and Numeracion=2) --as [Fisico Quimico Indiferente],
		select @Es1_3 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=1 and Numeracion=3) --as [Fisico Quimico Rechazada],
		select @Es1_4 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=1 and Numeracion=4) --as [Fisico Quimico Escoger],
		select @Es2_1 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=2 and Numeracion=1) --as [Derecho-Legislación Desconocida],
		select @Es2_2 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=2 and Numeracion=2) --as [Derecho-Legislación Indiferente],
		select @Es2_3 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=2 and Numeracion=3) --as [Derecho-Legislación Rechazada],
		select @Es2_4 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=2 and Numeracion=4) --as [Derecho-Legislación Escoger],
		select @Es3_1 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=3 and Numeracion=1) --as [Medicina-Sanidad Desconocida],
		select @Es3_2 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=3 and Numeracion=2) --as [Medicina-Sanidad Indiferente],
		select @Es3_3 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=3 and Numeracion=3) --as [Medicina-Sanidad Rechazada],
		select @Es3_4 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=3 and Numeracion=4) --as [Medicina-Sanidad Escoger],
		select @Es4_1 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=4 and Numeracion=1) --as [Servicios Desconocida],
		select @Es4_2 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=4 and Numeracion=2) --as [Servicios Indiferente],
		select @Es4_3 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=4 and Numeracion=3) --as [Servicios Rechazada],
		select @Es4_4 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=4 and Numeracion=4) --as [Servicios Escoger],
		select @Es5_1 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=5 and Numeracion=1) --as [Ciencias Humanas Desconocida],
		select @Es5_2 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=5 and Numeracion=2) --as [Ciencias Humanas Indiferente],
		select @Es5_3 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=5 and Numeracion=3) --as [Ciencias Humanas Rechazada],
		select @Es5_4 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=5 and Numeracion=4) --as [Ciencias Humanas Escoger],
		select @Es6_1 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=6 and Numeracion=1) --as [Ciencias Biologicas Desconocida],
		select @Es6_2 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=6 and Numeracion=2) --as [Ciencias Biologicas Indiferente],
		select @Es6_3 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=6 and Numeracion=3) --as [Ciencias Biologicas Rechazada],
		select @Es6_4 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=6 and Numeracion=4) --as [Ciencias Biologicas Escoger],
		select @Es7_1 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=7 and Numeracion=1) --as [Leterarias Desconocida],
		select @Es7_2 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=7 and Numeracion=2) --as [Leterarias Indiferente],
		select @Es7_3 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=7 and Numeracion=3) --as [Leterarias Rechazada],
		select @Es7_4 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=7 and Numeracion=4) --as [Leterarias Escoger],
		select @Es8_1 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=8 and Numeracion=1) --as [Publicidad y Comunicaciones Desconocida],
		select @Es8_2 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=8 and Numeracion=2) --as [Publicidad y Comunicaciones Indiferente],
		select @Es8_3 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=8 and Numeracion=3) --as [Publicidad y Comunicaciones Rechazada],
		select @Es8_4 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=8 and Numeracion=4) --as [Publicidad y Comunicaciones Escoger],
		select @Es9_1 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=9 and Numeracion=1) --as [Artes Plásticas y Musica Desconocida],
		select @Es9_2 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=9 and Numeracion=2) --as [Artes Plásticas y Musica Indiferente],
		select @Es9_3 = (select	Correctas from #Resultados_Numero_Escala_6 where Categoria=9 and Numeracion=3) --as [Artes Plásticas y Musica Rechazada],
		select @Es9_4 = (select	Correctas from #Resultados_Numero_Escala_6  where Categoria=9 and Numeracion=4) --as [Artes Plásticas y Musica Escoger],
		select @Es10_1 = (select Correctas from #Resultados_Numero_Escala_6 where Categoria=10 and Numeracion=1) --as [Organizacion y mando  Desconocida],
		select @Es10_2 = (select Correctas from #Resultados_Numero_Escala_6 where Categoria=10 and Numeracion=2) --as [Organizacion y mando Indiferente],
		select @Es10_3 = (select Correctas from #Resultados_Numero_Escala_6 where Categoria=10 and Numeracion=3) --as [Organizacion y mando Rechazada],
		select @Es10_4 = (select Correctas from #Resultados_Numero_Escala_6 where Categoria=10 and Numeracion=4) --as [Organizacion y mando Escoger],
		select @Es11_1 = (select Correctas from #Resultados_Numero_Escala_6 where Categoria=11 and Numeracion=1) --as [Enseñanza Desconocida],
		select @Es11_2 = (select Correctas from #Resultados_Numero_Escala_6 where Categoria=11 and Numeracion=2) --as [Enseñanza Indiferente],
		select @Es11_3 = (select Correctas from #Resultados_Numero_Escala_6 where Categoria=11 and Numeracion=3) --as [Enseñanza Rechazada],
		select @Es11_4 = (select Correctas from #Resultados_Numero_Escala_6 where Categoria=11 and Numeracion=4) --as [Enseñanza Escoger],
		select @Es12_1 = (select Correctas from #Resultados_Numero_Escala_6 where Categoria=12 and Numeracion=1) --as [Relaciones Economicas y empresariales Desconocida],
		select @Es12_2 = (select Correctas from #Resultados_Numero_Escala_6 where Categoria=12 and Numeracion=2) --as [Relaciones Economicas y empresariales Indiferente],
		select @Es12_3 = (select Correctas from #Resultados_Numero_Escala_6 where Categoria=12 and Numeracion=3) --as [Relaciones Economicas y empresariales Rechazada],
		select @Es12_4 = (select Correctas from #Resultados_Numero_Escala_6 where Categoria=12 and Numeracion=4) --as [Relaciones Economicas y empresariales Escoger],
		------------------------------------------------------------------------------------------------------------------------
		-- Sumatoria de E,R,I,D
		------------------------------------------------------------------------------------------------------------------------
		select @EsS_4 = (select	sum(Correctas) from #Resultados_Numero_Escala_6 where Numeracion=4) --as [Resultado de suma letra E],
		select @EsS_3 = (select	sum(Correctas) from #Resultados_Numero_Escala_6 where Numeracion=3) --as [Resultado de suma letra R],
		select @EsS_2 =(select	sum(Correctas) from #Resultados_Numero_Escala_6 where Numeracion=2) --as [Resultado de suma letra I],
		select @EsS_1 = (select	sum(Correctas) from #Resultados_Numero_Escala_6 where Numeracion=1) --as [Resultado de suma letra D],
		--*************************************************************************************************************************************************
		--                                                 Escala 7
		--*************************************************************************************************************************************************		
		--DESCOMENTAREAR para los resultados de las escalas 7	
		------select @R_Ambiete_Material=(select Correctas from #Resultados_Correctas_Escala_7 where Categoria=1) --as  [Resultado Ambiete Material],
		------select @Ambiete_Material=(select r.ran_Rango from prb_ran_rango r where r.ran_IdEscala=7 and r.ran_Inicio<=@R_Ambiete_Material  and	r.ran_Fin>@R_Ambiete_Material) --as [Ambiente Material],
		------select @R_Estado_Habitos_Fisiologicos=(select Correctas from #Resultados_Correctas_Escala_7 where Categoria=2) --as  [Resultado Estado y Hábitos Fisiológicos],
		------select @Estado_Habitos_Fisiologicos=(select r.ran_Rango from prb_ran_rango r where r.ran_IdEscala=7 and r.ran_Inicio<=@R_Estado_Habitos_Fisiologicos and r.ran_Fin>@R_Estado_Habitos_Fisiologicos) --as [Estado y Hábitos Fisiológicos],
		------select @R_Distribucion_Tiempo=(select Correctas from #Resultados_Correctas_Escala_7 where Categoria=3) --as  [Resultado Distribución del Tiempo],
		------select @Distribucion_Tiempo=(select r.ran_Rango from prb_ran_rango r where 	r.ran_IdEscala=7 and r.ran_Inicio<=@R_Distribucion_Tiempo  and	r.ran_Fin>@R_Distribucion_Tiempo) --as [Distribución del Tiempo],
		------select @R_Tecnicas_Toma_Notas_Apuntes=(select Correctas from #Resultados_Correctas_Escala_7 where Categoria=4) --as  [Resultado Técnicas de Toma de Notas y Apuntes],
		------select @Tecnicas_Toma_Notas_Apuntes=(select r.ran_Rango from prb_ran_rango r where r.ran_IdEscala=7 and r.ran_Inicio<=@R_Tecnicas_Toma_Notas_Apuntes  and r.ran_Fin>@R_Tecnicas_Toma_Notas_Apuntes) --as [Técnicas de Toma de Notas y Apuntes],
		------select @R_Habitos_Lectura=(select Correctas from #Resultados_Correctas_Escala_7 where Categoria=5) --as  [Resultado Hábitos de Lectura],
		------select @Habitos_Lectura=(select r.ran_Rango from prb_ran_rango r where r.ran_IdEscala=7 and r.ran_Inicio<=@R_Habitos_Lectura  and	r.ran_Fin>@R_Habitos_Lectura) --as [Hábitos de Lectura],
		------select @R_Tecnicas_Lectura=(select Correctas from #Resultados_Correctas_Escala_7 where Categoria=6) --as  [Resultado Hábitos de Lectura],
		------select @Tecnicas_Lectura=(select r.ran_Rango from prb_ran_rango r where r.ran_IdEscala=7 and r.ran_Inicio<=@R_Habitos_Lectura  and	r.ran_Fin>@R_Habitos_Lectura) --as [Hábitos de Lectura],
		------select @R_Habitos_Concentracion=(select Correctas from #Resultados_Correctas_Escala_7 where Categoria=7) --as  [Resultado Hábitos de Concentración],
		------select @Habitos_Concentracion=(select r.ran_Rango from prb_ran_rango r where r.ran_IdEscala=7 and r.ran_Inicio<=@R_Habitos_Concentracion  and	r.ran_Fin>@R_Habitos_Concentracion) --as [Hábitos de Concentración],
		------select @R_Actitud_Estudio=(select Correctas from #Resultados_Correctas_Escala_7 where Categoria=8) --as  [Resultado Actitud hacia el Estudio],
		------select @Actitud_Estudio=(select r.ran_Rango from prb_ran_rango r where r.ran_IdEscala=7 and r.ran_Inicio<=@R_Actitud_Estudio  and	r.ran_Fin>@R_Actitud_Estudio)--as [Actitud hacia el Estudio],
		------select @R_Informes_Escritos=(select Correctas from #Resultados_Correctas_Escala_7 where Categoria=9) --as  [Resultado Informes Escritos],
		------select @Informes_Escritos=(select r.ran_Rango from prb_ran_rango r where r.ran_IdEscala=7 and r.ran_Inicio<=@R_Informes_Escritos  and	r.ran_Fin>@R_Informes_Escritos) --as [Informes Escritos],
		------select @R_Informes_Orales=(select Correctas from #Resultados_Correctas_Escala_7 where Categoria=10)--as  [Resultado Informes Orales],
		------select @Informes_Orales=(select r.ran_Rango from prb_ran_rango r where r.ran_IdEscala=7 and r.ran_Inicio<=@R_Informes_Orales  and	r.ran_Fin>@R_Informes_Orales) --as [Informes Orales],

		--*************************************************************************************************************************************************
		--                                                 Intereses - Carrera
		--*************************************************************************************************************************************************

		--SOLO MOSTRAR LAS MARCADAS EN LA PAGINA
		select @RI1 = (select Correctas from #Resultados_Correctas_Escala_6 where Id=1) -- as [Resultado Interes1],
		select @I1 = (select Descripcion from #Resultados_Correctas_Escala_6 where Id=1) -- as [Interes1],
		select @carcat_cat_no1 = (select cat_no from #Resultados_Correctas_Escala_6 where Id=1) -- as [cat_no],
		select @CAR_1 = stuff(
		(
			select top 1 concat(' - ', car_nombre) from prb_carcat_carreras_categoria 
			inner join prb_car_carreras /*uonline.dbo.ra_car_carreras*/ on car_codigo = carcat_codcar
			where carcat_cat_no = @carcat_cat_no1
			order by carcat_codigo
			for xml path('')
		)
		,1, 2, '')
		
		select @RI2 = (select Correctas from #Resultados_Correctas_Escala_6 where Id=2) -- as [Resultado Interes2],
		select @I2 = (select Descripcion from #Resultados_Correctas_Escala_6 where Id=2) -- as  [Interes2],
		select @carcat_cat_no2 = (select cat_no from #Resultados_Correctas_Escala_6 where Id=2) -- as [cat_no],
		select @CAR_2 = stuff(
		(
			select top 1 concat(' - ', car_nombre) from prb_carcat_carreras_categoria 
			inner join prb_car_carreras /*uonline.dbo.ra_car_carreras*/ on car_codigo = carcat_codcar
			where carcat_cat_no = @carcat_cat_no2
			and car_codigo not in(
				select top 1 car_codigo from prb_carcat_carreras_categoria 
				inner join prb_car_carreras /*uonline.dbo.ra_car_carreras*/ on car_codigo = carcat_codcar
				where carcat_cat_no in(@carcat_cat_no1)
				order by carcat_codigo--PARA QUE EL TOP 1 DE LA @carcat_cat_no1 NO APARESCA
			)
			order by carcat_codigo
			for xml path('')
		)
		,1, 2, '')

		select @RI3 = (select Correctas from #Resultados_Correctas_Escala_6 where Id = 3) -- as [Resultado Interes3],
		select @I3 = (select Descripcion from #Resultados_Correctas_Escala_6 where Id = 3) --  as [Interes3]
		select @carcat_cat_no3 = (select cat_no from #Resultados_Correctas_Escala_6 where Id=3) -- as [cat_no],
		select @CAR_3 = stuff(
		(
			select  top 1 concat(' - ', car_nombre) from prb_carcat_carreras_categoria 
			inner join prb_car_carreras /*uonline.dbo.ra_car_carreras*/ on car_codigo = carcat_codcar
			where carcat_cat_no = @carcat_cat_no3 
			and car_codigo not in(
				select top 1 car_codigo from prb_carcat_carreras_categoria 
				inner join prb_car_carreras /*uonline.dbo.ra_car_carreras*/ on car_codigo = carcat_codcar
				where carcat_cat_no in(@carcat_cat_no1, @carcat_cat_no2)
				order by carcat_codigo--PARA QUE EL TOP 1 DE LA @carcat_cat_no1 Y @carcat_cat_no2 NO APARESCA
			)
			order by carcat_codigo
			for xml path('')
		)
		,1, 2, '')

		--*************************************************************************************************************************************************
		--                                                 Insertando Valores a tabla temporal de Resultado General
		--*************************************************************************************************************************************************
		insert into @Resultados_G(
			Codigo ,Nombres ,Apellidos,Colegio ,Bachillerato ,Telefono ,Correo ,Carrera ,Carrera1 	,Carrera2 ,Carrera3 ,R_Comprension_Verbal ,Comprension_Verbal ,R_Concepcion_Espacial 
			,Concepcion_Espacial ,R_Razonamiento  ,Razonamiento ,R_Calculo_Numerico ,Calculo_Numerico ,R_Fluidez_Verbal ,Fluidez_Verbal ,									
			Es1_1 ,Es1_2 ,Es1_3 ,Es1_4 ,Es2_1 ,Es2_2 ,Es2_3 ,Es2_4 ,Es3_1 ,Es3_2 ,Es3_3 ,Es3_4 ,Es4_1 ,Es4_2 ,Es4_3 ,Es4_4 ,Es5_1 ,Es5_2 ,Es5_3 ,Es5_4 ,Es6_1 ,Es6_2 ,Es6_3 ,Es6_4 ,
			Es7_1 ,Es7_2 ,Es7_3 ,Es7_4 ,Es8_1 ,Es8_2 ,Es8_3 ,Es8_4 ,Es9_1 ,Es9_2 ,Es9_3 ,Es9_4 ,Es10_1 ,Es10_2 ,Es10_3 ,Es10_4 ,Es11_1 ,Es11_2 ,Es11_3 ,Es11_4 ,Es12_1 ,Es12_2 
			,Es12_3 ,Es12_4 ,EsS_1 ,EsS_2 ,EsS_3 ,EsS_4 ,
			R_Ambiente_Material , Ambiente_Material ,	R_Estado_Habitos_Fisiologicos , Estado_Habitos_Fisiologicos ,R_Distribucion_Tiempo ,Distribucion_Tiempo ,
			R_Tecnicas_Toma_Notas_Apuntes ,Tecnicas_Toma_Notas_Apuntes ,R_Habitos_Lectura ,Habitos_Lectura ,R_Tecnicas_Lectura ,Tecnicas_Lectura ,
			R_Habitos_Concentracion ,Habitos_Concentracion ,R_Actitud_Estudio ,Actitud_Estudio ,R_Informes_Escritos, Informes_Escritos ,
			R_Informes_Orales ,Informes_Orales,Fecha,RI1 ,I1 ,RI2 ,I2 ,RI3 ,I3 
		)
		values (
			@Codigo ,@Nombres ,@Apellidos,@Colegio ,@Bachillerato ,@Telefono ,@Correo, @Carrera, @CAR_1, @CAR_2, @CAR_3, --,@Carrera ,@Carrera1 	,@Carrera2 ,@Carrera3 ,
			isnull(@R_Comprension_Verbal,0) ,isnull(@Comprension_Verbal,'-') ,isnull(@R_Concepcion_Espacial,0) 
			,isnull(@Concepcion_Espacial,'') ,isnull(@R_Razonamiento,0)  ,isnull(@Razonamiento,'') ,isnull(@R_Calculo_Numerico,0) ,isnull(@Calculo_Numerico,'') ,
			isnull(@R_Fluidez_Verbal,0) ,isnull(@Fluidez_Verbal,0),
			isnull(@Es1_1,0) ,isnull(@Es1_2,0) ,isnull(@Es1_3 ,0),isnull(@Es1_4 ,0),isnull(@Es2_1 ,0),isnull(@Es2_2 ,0),isnull(@Es2_3 ,0),isnull(@Es2_4 ,0),isnull(@Es3_1 ,0),
			isnull(@Es3_2 ,0),isnull(@Es3_3 ,0),isnull(@Es3_4 ,0),isnull(@Es4_1 ,0),isnull(@Es4_2 ,0),isnull(@Es4_3 ,0),
			isnull(@Es4_4 ,0),isnull(@Es5_1 ,0),isnull(@Es5_2 ,0),isnull(@Es5_3 ,0),isnull(@Es5_4 ,0),isnull(@Es6_1 ,0),isnull(@Es6_2 ,0),isnull(@Es6_3 ,0),isnull(@Es6_4 ,0),
			isnull(@Es7_1 ,0),isnull(@Es7_2 ,0),isnull(@Es7_3 ,0),isnull(@Es7_4 ,0),isnull(@Es8_1 ,0),isnull(@Es8_2 ,0),isnull(@Es8_3 ,0),isnull(@Es8_4 ,0),isnull(@Es9_1 ,0),
			isnull(@Es9_2 ,0),isnull(@Es9_3 ,0),isnull(@Es9_4 ,0),isnull(@Es10_1,0),isnull(@Es10_2 ,0),isnull(@Es10_3 ,0),isnull(@Es10_4 ,0),isnull(@Es11_1 ,0),isnull(@Es11_2 ,0),
			isnull(@Es11_3 ,0),isnull(@Es11_4 ,0),isnull(@Es12_1 ,0),isnull(@Es12_2,0),isnull(@Es12_3 ,0),isnull(@Es12_4 ,0),isnull(@EsS_1 ,0),isnull(@EsS_2,0),isnull(@EsS_3,0),
			isnull(@EsS_4,0),
			isnull(@R_Ambiete_Material ,0),isnull(@Ambiete_Material ,''),isnull(@R_Estado_Habitos_Fisiologicos ,0),isnull(@Estado_Habitos_Fisiologicos ,''),
			isnull(@R_Distribucion_Tiempo ,0),isnull(@Distribucion_Tiempo,''),isnull(@R_Tecnicas_Toma_Notas_Apuntes ,0),isnull(@Tecnicas_Toma_Notas_Apuntes,''),
			isnull(@R_Habitos_Lectura ,0),isnull(@Habitos_Lectura ,''),isnull(@R_Tecnicas_Lectura ,0),isnull(@Tecnicas_Lectura,''),
			isnull(@R_Habitos_Concentracion ,0),isnull(@Habitos_Concentracion ,''),isnull(@R_Informes_Escritos ,0),isnull(@Informes_Escritos ,''),
			isnull(@R_Informes_Escritos ,0),isnull(@Informes_Escritos ,''),isnull(@R_Informes_Orales ,0),isnull(@Informes_Orales,''),isnull(@Fecha,''),
			isnull(@RI1 ,0),isnull(@I1 ,''),isnull(@RI2 ,0),isnull(@I2 ,''),isnull(@RI3 ,0),isnull(@I3,'')
		)

		--DESCOMENTAREAR cuando se ocupe las escalas 1-5
		--drop table #Correctas_x_escala

		drop table #Resultados_Numero_Escala_6
		drop table #Resultados_Correctas_Escala_6

		--DESCOMENTAREAR cuando se ocupe la escala 7
		--table #Resultados_Correctas_Escala_7

		drop table #respuestas_alumnos
		fetch Alumnos_r into  @Codigo, @Nombres, @Apellidos, @Colegio, @Bachillerato, @Telefono, @Correo, @Carrera, @Carrera1, @Carrera2, @Carrera3, @Fecha
	end--while (@@FETCH_STATUS = 0)

	select 
	Id,
	concat(Nombres, ' ', Apellidos) 'alumno'
	,Codigo  'codigo_prueba'
	,Colegio 'colegio'
	,Fecha 'fecha'
	,Bachillerato 'bachillerato'
	--,Telefono 
	--,Correo 
	--,Carrera 
	--,Carrera1 
	--,Carrera2 
	--,Carrera3 
	--,R_Comprension_Verbal 
	--,Comprension_Verbal 						
	--,R_Concepcion_Espacial 
	--,Concepcion_Espacial 
	--,R_Razonamiento 
	--,Razonamiento 							
	--,R_Calculo_Numerico 
	--,Calculo_Numerico 			
	--,R_Fluidez_Verbal 
	--,Fluidez_Verbal ,							
																					
	--Es1_1 as [Fisico Quimico Desconocida],							Es1_2 as [Fisico Quimico Indiferente],						Es1_3  as [Fisico Quimico Rechazada],							Es1_4 as [Fisico Quimico Escoger],
	--Es2_1 as [Derecho-Legislación Desconocida],					Es2_2 as [Derecho-Legislación Indiferente],					Es2_3 as [Derecho-Legislación Rechazada],						Es2_4 as [Derecho-Legislación Escoger],
	--Es3_1 as [Medicina-Sanidad Desconocida],						Es3_2 as [Medicina-Sanidad Indiferente],					Es3_3 as [Medicina-Sanidad Rechazada],							Es3_4 as [Medicina-Sanidad Escoger],
	--Es4_1 as [Servicios Desconocida],								Es4_2 as [Servicios Indiferente],							Es4_3 as [Servicios Rechazada],									Es4_4 as [Servicios Escoger],
	--Es5_1 as [Ciencias Humanas Desconocida],						Es5_2 as [Ciencias Humanas Indiferente],					Es5_3 as [Ciencias Humanas Rechazada],							Es5_4 as [Ciencias Humanas Escoger],
	--Es6_1 as [Ciencias Biologicas Desconocida],					Es6_2 as [Ciencias Biologicas Indiferente],					Es6_3 as [Ciencias Biologicas Rechazada],						Es6_4 as [Ciencias Biologicas Escoger],
	--Es7_1 as [Literarias Desconocida],								Es7_2 as [Literarias Indiferente],							Es7_3 as [Literarias Rechazada],								Es7_4 as [Literarias Escoger],
	--Es8_1 as [Publicidad y Comunicaciones Desconocida],			Es8_2 as [Publicidad y Comunicaciones Indiferente],			Es8_3 as [Publicidad y Comunicaciones Rechazada],				Es8_4 as [Publicidad y Comunicaciones Escoger],
	--Es9_1 as [Artes Plásticas y Musica Desconocida],				Es9_2 as [Artes Plásticas y Musica Indiferente],			Es9_3 as [Artes Plásticas y Musica Rechazada],					Es9_4 as [Artes Plásticas y Musica Escoger],
	--Es10_1 as [Organizacion y mando  Desconocida],					Es10_2 as [Organizacion y mando  Indiferente],				Es10_3 as [Organizacion y mando  Rechazada],					Es10_4 as [Organizacion y mando  Escoger],
	--Es11_1 as [Enseñanza Desconocida],								Es11_2 as [Enseñanza Indiferente],							Es11_3 as [Enseñanza Rechazada],								Es11_4 as [Enseñanza Escoger],
	--Es12_1 as [Relaciones Economicas y empresariales Desconocida],	Es12_2 as [Relaciones Economicas y empresariales Indiferente],Es12_3 as [Relaciones Economicas y empresariales Rechazada],	Es12_4 as [Relaciones Economicas y empresariales Escoger],
		
	--EsS_4  as [Resultado de suma letra E] ,EsS_3 as [Resultado de suma letra R] ,EsS_2 as [Resultado de suma letra I],EsS_1 as 	[Resultado de suma letra D],								-- Sumatoria de resultados escala 6

	---- Escala 7
	--R_Ambiente_Material as[Resul Ambiente Material] ,								Ambiente_Material as[Ambiente Material] ,							-- Escala 7-1[Ambiente Material]
	--R_Estado_Habitos_Fisiologicos  as [Resul Estado y Hábitos Fisiológicos],		Estado_Habitos_Fisiologicos as[Estado y Hábitos Fisiológicos] ,	-- Escala 7-2[Estado y Hábitos Fisiológicos]
	--R_Distribucion_Tiempo as[Resul Distribución del Tiempo] ,						Distribucion_Tiempo as [Distribución del Tiempo],					-- Escala 7-3[Distribución del Tiempo]
	--R_Tecnicas_Toma_Notas_Apuntes  as [Resul Técnicas de Toma de Notas y Apuntes],	Tecnicas_Toma_Notas_Apuntes as [Técnicas de Toma de Notas y Apuntes] ,	-- Escala 7-4[Técnicas de Toma de Notas y Apuntes]
	--R_Habitos_Lectura as [Resul Hábitos de Lectura],								Habitos_Lectura as [Hábitos de Lectura] ,							-- Escala 7-5[Hábitos de Lectura]
	--R_Tecnicas_Lectura as [Resul Técnicas de Lectura],								Tecnicas_Lectura as [Técnicas de Lectura] ,						-- Escala 7-6[Técnicas de Lectura]
	--R_Habitos_Concentracion [Resul Hábitos de Concentración],						Habitos_Concentracion as [Hábitos de Concentración],				-- Escala 7-7 [Hábitos de Concentración]
	--R_Actitud_Estudio as [Resul Actitud hacia el Estudio],							Actitud_Estudio as [Actitud hacia el Estudio],							-- Escala 7-8[Actitud hacia el Estudio]																		
	--R_Informes_Escritos as[Resul Informes Escritos] ,								Informes_Escritos as [Informes Escritos],						-- Escala 7-9[Informes Escritos]
	--R_Informes_Orales as [Resul Informes Orales],									Informes_Orales as [Informes Orales], 							-- Escala 7-10		
	
	-- ereces escala 6 resultados
	,RI1 as [Resultado Interes 1]
	,case I1 when '' then 'Sin interés' else I1 end 'interes_1',														
	RI2 as [Resultado Interes 2],
	case I2 when '' then 'Sin interés' else I2 end  'interes_2',
	RI3 as [Resultado Interes 3],
	case I3 when '' then 'Sin interés' else I3 end  as 'interes_3',
	--@CAR_1 'carrera_1',
	Carrera1,
	--@CAR_2 'carrera_2',
	Carrera2,
	--@CAR_3 'carrera_3'
	Carrera3
	from @Resultados_G

	close Alumnos_r
	deallocate Alumnos_r
end