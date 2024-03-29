USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_copiar_prueba_diagnostica]    Script Date: 22/07/2019 9:15:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter procedure [dbo].[sp_copiar_prueba_diagnostica]
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-07-20 11:50:07.790>
	-- Description: <Este procedimiento se creo para poder copiar las pruebas de egresados de carrera a carrera
	--				ej: se desea copiar la clave A(@codide) para el ciclo 01-2019(@codcil) de la carrera 17(@codcar_copiar_de) 
	--				A LA CARRERA 35(@codcar_n); LO QUE SIGNIFICA QUE PRUEBA DIAGNOSTICA DE LA CARRERA 54 SERA IGUAL A 17>
	-- =============================================
	--sp_copiar_prueba_diagnostica 1, 17, 119, 'A', 46, 0,72  --VISTA PREVIA
	--sp_copiar_prueba_diagnostica 2, 17, 119, 'A', 46, 0, 72 --INSERTA
	--sp_copiar_prueba_diagnostica 3, 17, 119, 'A', 35, 89, 85 --BORRAR EL @codcla
	@opcion int,
	@codcar_copiar_de int,--17, Carrera de la cual se copiara la prueba
	@codcil int,--CODCIL DE LA @codcar_copiar_de
	@codide varchar(5), --clace que se copiara de @codcar_copiar_de
	@codcar_n varchar(5),--35, Carrera a la cual se le creara la misma prueba de @codcar_copiar_de
	@codcla_borrar int, --SI SE CONOCE EL @codcla Y SE INVOCA LA OPCION 3 SE BORRAR LA CLAVE @codcla (SI NO HAY EVALUACIONES LLENADAS PARA la @codcla)
	@codcla_copiar_de int --SI SE CONOCE EL @codcla Y SE INVOCA LA OPCION 3 SE BORRAR LA CLAVE @codcla (SI NO HAY EVALUACIONES LLENADAS PARA la @codcla)
as 
begin
	--select top 10 * from eeg_cla_clave order by cla_codigo desc
	--select top 10 * from eeg_cla_clave where cla_codcar = 120
	declare @codcla int
	declare @t_rubros as table(codrub int)
	declare @t_preguntas as table(codpre int)
	declare @t_respuestas as table(codres int)
	--*--
	declare @codcla_n int
	declare @codrub_n int
	declare @codpre_max_n int
	
	declare @existe_encuesta_codcar_n int 

	--select @existe_encuesta_codcar_n = 1 from eeg_cla_clave 
	--where cla_codcar = (select car_codigo from ra_car_carreras where car_identificador = @codcar_n) 
	--and cla_codcil = @codcil and cla_codide = @codide

	--if  (isnull(@existe_encuesta_codcar_n, 0) = 0)--Si la @codcar_n no tienen insertada una prueba clave @codide para el ciclo @codcil
	--begin
		print 'La prueba para la carrera ''' + cast(@codcar_n as varchar(10)) + ''' que sera igual que ''' + cast(@codcar_copiar_de as varchar(10)) + ''' se procede a copiar la clave ' + cast(@codide as varchar(10))
		if @opcion = 1--VISTA PREVIA DE LO QUE SE VA INSERTAR
		begin
			print 'VISTA PREVIA'
			print 'Clave ' + cast(@codide as varchar(5))
			select @codcla = cla_codigo from eeg_cla_clave where cla_codigo = @codcla_copiar_de--cla_codcar = @codcar_copiar_de and cla_codcil = @codcil and cla_codide = @codide
			select * from eeg_cla_clave where cla_codigo = @codcla_copiar_de--cla_codcar = @codcar_copiar_de and cla_codcil = @codcil and cla_codide = @codide

			print 'Rubros'
			insert into @t_rubros
			select rub_codigo from eeg_rub_rubro where rub_codcla = @codcla
			select * from eeg_rub_rubro where rub_codcla = @codcla

			print 'Preguntas '
			select @codpre_max_n = max(pre_codigo) +1 from eeg_pre_pregunta
			insert into @t_preguntas 
			select pre_codigo from eeg_pre_pregunta where pre_codrub in (select codrub from @t_rubros)
			select *, pre_codigo + @codpre_max_n from eeg_pre_pregunta where pre_codrub in (select codrub from @t_rubros)

			print 'Respuestas'
			insert into @t_respuestas
			select res_codigo from eeg_res_respuesta where res_codpre in (select codpre from @t_preguntas)
			select *, res_codpre + @codpre_max_n from eeg_res_respuesta where res_codpre in (select codpre from @t_preguntas)
		end

		if @opcion = 2 --INSERTA LOS DATOS A LA NUEVA ENCUESTA
		begin
			print 'INSERTANDO '
			print 'Clave ' + cast(@codide as varchar(5))

			select @codcar_n = car_codigo from ra_car_carreras where car_identificador = @codcar_n
			print 'codcar_n ' + cast(@codcar_n as varchar(5))

			select @codcla = cla_codigo from eeg_cla_clave where cla_codigo = @codcla_copiar_de--cla_codcar = @codcar_copiar_de and cla_codcil = @codcil and cla_codide = @codide
			--select * from eeg_cla_clave where cla_codigo = @codcla_copiar_de--cla_codcar = @codcar_copiar_de and cla_codcil = @codcil and cla_codide = @codide
			insert into eeg_cla_clave(cla_codcar, cla_codide, cla_codcil, cla_indicaciones, cla_fecha_crea, cla_fecha_mod,cla_niveles)
			select @codcar_n, cla_codide, cla_codcil, cla_indicaciones, getdate(), getdate(), cla_niveles from eeg_cla_clave where cla_codigo = @codcla_copiar_de--cla_codcar = @codcar_copiar_de and cla_codcil = @codcil and cla_codide = @codide
			select @codcla_n = @@IDENTITY
			print  'codcla_n ' + cast(@codcla_n as varchar(10))

			print 'Rubros'
			insert into @t_rubros
			select rub_codigo from eeg_rub_rubro where rub_codcla = @codcla
			--select * from eeg_rub_rubro where rub_codcla = @codcla
			insert into eeg_rub_rubro (rub_codcla, rub_rubro, rub_ponderacion, rub_indicaciones, rub_nivel) 
			select @codcla_n, rub_rubro, rub_ponderacion, rub_indicaciones, rub_nivel  from eeg_rub_rubro where rub_codcla = @codcla
			select @codrub_n = @@IDENTITY
			print  'codrub_n ' + cast(@codrub_n as varchar(10))

			print 'Preguntas '
			select @codpre_max_n = IDENT_CURRENT( 'eeg_pre_pregunta' )  /*max(pre_codigo) +1*/ from eeg_pre_pregunta
			print  'codpre_max_n ' + cast(@codpre_max_n as varchar(10))
			insert into @t_preguntas 
			select pre_codigo from eeg_pre_pregunta where pre_codrub in (select codrub from @t_rubros)
			--select */*, pre_codigo + @codpre_max_n*/ from eeg_pre_pregunta where pre_codrub in (select codrub from @t_rubros)
			insert into eeg_pre_pregunta (pre_codrub, pre_codtre, pre_numero, pre_pregunta, pre_fecha)
			select @codrub_n, pre_codtre, pre_numero, pre_pregunta, getdate()/*, pre_codigo + @codpre_max_n*/ from eeg_pre_pregunta where pre_codrub in (select codrub from @t_rubros)
			--select *, @codpre_max_n + pre_numero from eeg_pre_pregunta where pre_codrub = @codrub_n

			print 'Respuestas'
			insert into @t_respuestas
			select res_codigo from eeg_res_respuesta where res_codpre in (select codpre from @t_preguntas)
			--select *, res_codpre + @codpre_max_n from eeg_res_respuesta where res_codpre in (select codpre from @t_preguntas)
			insert into eeg_res_respuesta (res_codpre, res_numero, res_respuesta, res_correcta, res_fecha)
			select @codpre_max_n + pre_numero, res_numero, res_respuesta, res_correcta, getdate() from eeg_res_respuesta
			inner join eeg_pre_pregunta on pre_codigo = res_codpre
			 where res_codpre in (select codpre from @t_preguntas)
			
			--SE MUESTRA EL RESULTAOD DE LA ENCUESTA COPIADA
			select cla_codigo, cla_indicaciones, rub_codigo, rub_rubro, rub_ponderacion, 
			pre_codigo, pre_numero,pre_pregunta, res_codigo, res_numero, res_respuesta, res_correcta 
			from eeg_cla_clave 
				inner join eeg_rub_rubro on rub_codcla = cla_codigo
				inner join eeg_pre_pregunta on pre_codrub = rub_codigo
				inner join eeg_res_respuesta on res_codpre = pre_codigo
			where cla_codigo in (
				@codcla_n--select cla_codigo from eeg_cla_clave where cla_codcar = 17 and cla_codcil = 119 and cla_codide = 'A'
			)
		end
	--end--if  (isnull(@existe_encuesta_codcar_n, 0) = 0)
	--else
	--begin
	--	print 'La prueba para la carrera ''' + cast(@codcar_n as varchar(10)) + ''' que sera igual que ''' + cast(@codcar_copiar_de as varchar(10)) + ''' no se procede a copiar porque la prueba ''' + cast(@codcar_n as varchar(10)) + ''' ya tiene clave ' + cast(@codide as varchar(10))
	--	print 'Se procede a mostrar los resultados'

	--	select @codcar_n 'codcar_n', @codide 'calve', cla_codigo, cla_indicaciones, rub_codigo, rub_rubro, rub_ponderacion, 
	--	pre_codigo, pre_numero,pre_pregunta, res_codigo, res_numero, res_respuesta, res_correcta 
	--	from eeg_cla_clave 
	--		inner join eeg_rub_rubro on rub_codcla = cla_codigo
	--		inner join eeg_pre_pregunta on pre_codrub = rub_codigo
	--		inner join eeg_res_respuesta on res_codpre = pre_codigo
	--	where cla_codigo in (
	--		select cla_codigo from eeg_cla_clave where cla_codcar = (select car_codigo from ra_car_carreras where car_identificador = @codcar_n) and cla_codcil = @codcil and cla_codide = @codide
	--	)

	--	select @codcar_copiar_de 'codcar_copiar_de', @codide 'calve', cla_codigo, cla_indicaciones, rub_codigo, rub_rubro, rub_ponderacion, 
	--	pre_codigo, pre_numero,pre_pregunta, res_codigo, res_numero, res_respuesta, res_correcta 
	--	from eeg_cla_clave 
	--		inner join eeg_rub_rubro on rub_codcla = cla_codigo
	--		inner join eeg_pre_pregunta on pre_codrub = rub_codigo
	--		inner join eeg_res_respuesta on res_codpre = pre_codigo
	--	where cla_codigo in (
	--		@codcla_copiar_de--select cla_codigo from eeg_cla_clave where cla_codcar = @codcar_copiar_de and cla_codcil = @codcil and cla_codide = @codide
	--	)
	--end
	
	if @opcion = 3--SE BORRAR LA CLAVE @CODCLA
	begin
		delete from eeg_res_respuesta where res_codpre in(select pre_codigo from eeg_pre_pregunta where pre_codrub in(select rub_codigo from eeg_rub_rubro where rub_codcla = @codcla_borrar))
		delete from eeg_pre_pregunta where pre_codrub in(select rub_codigo from eeg_rub_rubro where rub_codcla = @codcla_borrar)
		delete from eeg_rub_rubro where rub_codcla = @codcla_borrar
		delete from eeg_cla_clave where cla_codigo = @codcla_borrar
	end

	--select * from eeg_pre_pregunta where pre_codrub in(select rub_codigo from eeg_rub_rubro where rub_codcla = 50)

	/*select cla_codigo, cla_indicaciones, rub_codigo, rub_rubro, rub_ponderacion, 
	pre_codigo, pre_numero,pre_pregunta, res_codigo, res_numero, res_respuesta, res_correcta 
	from eeg_cla_clave 
		inner join eeg_rub_rubro on rub_codcla = cla_codigo
		inner join eeg_pre_pregunta on pre_codrub = rub_codigo
		inner join eeg_res_respuesta on res_codpre = pre_codigo
	where cla_codigo in (
		50
	)*/
	
	/*
	SELECT eeg_cla_clave.cla_codigo, ra_car_carreras.car_identificador, eeg_cla_clave.cla_codcar, ra_car_carreras.car_nombre, 
	eeg_cla_clave.cla_codide, eeg_cla_clave.cla_codcil, CONVERT (varchar, ra_cil_ciclo.cil_codcic) + '-' + CONVERT (varchar, ra_cil_ciclo.cil_anio) AS ciclo, 
	eeg_cla_clave.cla_indicaciones, eeg_cla_clave.cla_fecha_crea, eeg_cla_clave.cla_fecha_mod 
	FROM eeg_cla_clave 
	INNER JOIN ra_car_carreras ON eeg_cla_clave.cla_codcar = ra_car_carreras.car_codigo 
	LEFT OUTER JOIN ra_cil_ciclo ON eeg_cla_clave.cla_codcil = ra_cil_ciclo.cil_codigo
	WHERE  (car_identificador = 17 )
	order by  cil_codigo DESC, car_identificador*/
end