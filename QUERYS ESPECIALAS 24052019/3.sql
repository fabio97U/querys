USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[tal_GenerarDataTalonarioPreEspecialidad_PorAlumno_Especial]    Script Date: 24/05/2019 18:26:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--	Exec tal_GenerarDataTalonarioPreEspecialidad_PorAlumno_Especial -1, 1, 119, 79276	-- Elimina la data de los talonarios
--	Exec tal_GenerarDataTalonarioPreEspecialidad_PorAlumno_Especial 0, 1, 119, 79276	-- Verifica si existe la data generada
--	Exec tal_GenerarDataTalonarioPreEspecialidad_PorAlumno_Especial 1, 1, 119, 79276	-- Datos previos
--	Exec tal_GenerarDataTalonarioPreEspecialidad_PorAlumno_Especial 2, 1, 119, 79276	-- Inserta la data para los talonarios

--	select *  from col_art_archivo_tal_preesp_mora where per_codigo = 160989 and art_codigo >= 171120 order by art_codigo

ALTER PROCEDURE [dbo].[tal_GenerarDataTalonarioPreEspecialidad_PorAlumno_Especial]	
	@opcion int,
	@codreg int,
	@codcilGenerar int,
	@codper int
AS
BEGIN
	SET NOCOUNT ON;
	set dateformat dmy
	declare @cantidad int

	if @opcion = -1
	begin
		--select * from col_art_archivo_tal_preesp_mora where per_codigo = @codper and ciclo = @CodCilGenerar
		delete from col_art_archivo_tal_preesp_mora where per_codigo = @codper and ciclo = @CodCilGenerar
		if @@ROWCOUNT = 0
			print 'No se encontro data'
		else
			print 'Registro eliminado'
	end
	if @opcion = 0
	begin
		--Select @cantidad = count(per_codigo) from col_art_archivo_tal_preesp_mora where per_codigo = @codper and ciclo = @codcilGenerar
		if exists(Select 1 from col_art_archivo_tal_preesp_mora where per_codigo = @Codper and ciclo = @codcilGenerar)
		--if @cantidad = 0
		begin
			print 'El alumno YA posee data generada de los talonarios'
		end
		else
		begin
			print 'El alumno NO posee data generada de los talonarios'
		end
	end	--	if @opcion = 0

	if (@opcion = 1 or @opcion = 2)
	begin
		--if exists (select 1 from ra_per_personas join col_detmen_detalle_tipo_mensualidad on per_codigo = detmen_codper where detmen_codcil = @CodCilGenerar and per_codigo = @codper)
		--begin
		--	--GENERA DATA POR ALUMNO DE PRESPECIALIDAD ESPECIAL(BECADO)
		--	print 'Alumno posee mensualidad especial'
		--	Exec tal_GenerarDataTalonarioPreEspecialidad_PorAlumno_Especial @opcion, @codreg, @codcilGenerar, @codper
		--end
		--else
		--begin
		--	print 'Alumno no posee mensualidad especial'
			declare @corr int
			set @corr= (select max(art_codigo)+1 from col_art_archivo_tal_preesp_mora)
			print '@corr : ' + cast (@corr as nvarchar(12))

			declare @tabla_cuotas_normales table (art_codigo int, fecha datetime, limite date, per_codigo int, per_carnet nvarchar(12), ciclo int, pla_alias_carrera nvarchar(100), per_nombres_apellidos nvarchar(100), c415 nvarchar(3), cc415 nvarchar(13), c3902 nvarchar(4),
				cc3902 nvarchar(10), c96 nvarchar(2), cc96 nvarchar(8), c8020 nvarchar(4), cc8020 nvarchar(17), barra nvarchar(61), npe nvarchar(28), c415M nvarchar(3), cc415M nvarchar(13), c3902m nvarchar(12), cc3902m nvarchar(10), fecha_banco datetime,
				c96m nvarchar(2), cc96m nvarchar(8), c8020M nvarchar(4), cc8020M nvarchar(17), barra_mora nvarchar(61), npe_mora nvarchar(28), tmo_valor float, fel_fecha datetime, tmo_arancel nvarchar(10), fecha_mora datetime, fel_codigo_barra int, papeleria float,
				tmo_valor_mora float, matricula float, fel_orden int, mciclo nvarchar(7), fechahora datetime)

			declare @tabla table (art_codigo int, fecha datetime, limite date, per_codigo int, per_carnet nvarchar(12), ciclo int, pla_alias_carrera nvarchar(100), per_nombres_apellidos nvarchar(100), c415 nvarchar(3), cc415 nvarchar(13), c3902 nvarchar(4),
			cc3902 nvarchar(10), c96 nvarchar(2), cc96 nvarchar(8), c8020 nvarchar(4), cc8020 nvarchar(17), barra nvarchar(61), npe nvarchar(28), c415M nvarchar(3), cc415M nvarchar(13), c3902m nvarchar(12), cc3902m nvarchar(10), fecha_banco datetime,
			c96m nvarchar(2), cc96m nvarchar(8), c8020M nvarchar(4), cc8020M nvarchar(17), barra_mora nvarchar(61), npe_mora nvarchar(28), tmo_valor float, fel_fecha datetime, tmo_arancel nvarchar(10), fecha_mora datetime, fel_codigo_barra int, papeleria float,
			tmo_valor_mora float, matricula float, fel_orden int, mciclo nvarchar(7), fechahora datetime)

			insert into @tabla(art_codigo, fecha, per_codigo, per_carnet, ciclo, pla_alias_carrera, per_nombres_apellidos, c415, cc415, c3902, cc3902, c96, cc96, c8020, cc8020, barra, npe, c415M, cc415m, c3902m, cc3902m,
				c96m, cc96m, c8020m, cc8020m, barra_mora, npe_mora, tmo_valor, fel_fecha, tmo_arancel, fecha_mora, fel_codigo_barra, fecha_banco, papeleria, tmo_valor_mora, matricula, fel_orden, mciclo, fechahora)
			select @corr+ row_number() over (order by per_codigo) as art_codigo,
			fecha, --limite, 
			per_codigo , per_carnet, ciclo,
				pla_alias_carrera, per_nombres_apellidos,
				c415,cc415,c3902,cc3902,c96,cc96,c8020,cc8020,
				c415+cc415+c3902+cc3902+c96+cc96+c8020+cc8020 barra,
				npe+dbo.fn_verificador_npe(NPE) NPE,

				c415M,cc415M,c3902M,cc3902M, c96M,cc96M,c8020M,cc8020M,
				c415M+cc415M+c3902M+cc3902M+c96M+cc96M+c8020M+cc8020M BARRA_MORA,
				npe_mora+dbo.fn_verificador_npe(NPE_MORA) NPE_MORA,
		 
				tmo_valor, fel_fecha, tmo_arancel, fecha_mora,fel_codigo_barra, fecha_mora, 
				papeleria,
				CASE  WHEN fel_codigo_barra <= 2 THEN  tmo_valor_mora ELSE tmo_valor_mora END tmo_valor_mora,matricula, fel_orden,mciclo, getdate() 
		 
			from
			(
				select getdate() fecha, --convert(datetime,@fecha,103) limite, 
				ra_per_personas.per_codigo, per_carnet, @codcilGenerar ciclo,
				--substring(pla_alias_carrera,1,55) pla_alias_carrera,per_nombres_apellidos,'415' c415,
				--le agrego mas longitud al substring de alias de carrera
				substring(pla_alias_carrera,1,100) pla_alias_carrera,per_nombres_apellidos,
				'415' c415, 
				'7419700003137' cc415,
				'3902' c3902,
				right('00000000'+cast(floor(CASE fel_orden WHEN 1 THEN fel_valor+ 0 ELSE fel_valor END ) as varchar),8) + 
				right('00'+cast((CASE fel_orden WHEN 1 THEN fel_valor+ 0 ELSE fel_valor END  - floor(CASE fel_orden 
				WHEN 1 THEN fel_valor+ 0 ELSE fel_valor END )) as varchar),2) cc3902,	
				'96' c96,	
				cast(year(fel_fecha) as varchar)+right('00'+cast(month(fel_fecha) as varchar),2)+right('00'+cast(day(fel_fecha) as varchar),2) cc96,
				'8020' c8020,
				substring(per_carnet,1,2)+substring(per_carnet,4,4)+substring(per_carnet,9,4)+cast(fel_codigo_barra as varchar)+
				right('00'+cast(cil_codcic as varchar),2)+cast(cil_anio as varchar) cc8020,
				'0313'+right('0000'+cast(floor(CASE fel_orden WHEN 1 THEN fel_valor+ 0 ELSE fel_valor END ) as varchar),4) + 
				right('00'+cast((CASE fel_orden WHEN 1 THEN fel_valor+ 0 ELSE fel_valor END  - floor(CASE fel_orden WHEN 1 THEN fel_valor+ 
				0 ELSE fel_valor END )) as varchar),2)+ substring(per_carnet,1,2)+substring(per_carnet,4,4)+substring(per_carnet,9,4)+cast(fel_codigo_barra as varchar)+
				right('00'+cast(cil_codcic as varchar),2)+cast(cil_anio as varchar) NPE,
		--************************************************************************************************************************************************************
		---																		VALORES CON MORA
		--************************************************************************************************************************************************************
				'415' c415M, 
				'7419700003137' cc415M,
				'3902' c3902M,	
				right('00000000'+cast(floor(CASE fel_orden WHEN 1 THEN fel_valor_mora+ 0 ELSE fel_valor_mora END ) as varchar),8) + 
				right('00'+cast((CASE fel_orden WHEN 1 THEN fel_valor_mora+ 0 ELSE fel_valor_mora END  - floor(CASE fel_orden 
				WHEN 1 THEN fel_valor_mora+ 0 ELSE fel_valor_mora END )) as varchar),2) cc3902M,
				'96' c96M,
				cast(year(fel_fecha_mora) as varchar)+right('00'+cast(month(fel_fecha_mora) as varchar),2)+right('00'+cast(day(fel_fecha_mora) as varchar),2) cc96M,
				'8020' c8020M,
				substring(per_carnet,1,2)+substring(per_carnet,4,4)+substring(per_carnet,9,4)+cast(fel_codigo_barra as varchar)+
				right('00'+cast(cil_codcic as varchar),2)+cast(cil_anio as varchar) cc8020M,
				'0313'+right('0000'+cast(floor(CASE fel_orden WHEN 1 THEN fel_valor_mora+ 0 ELSE fel_valor_mora END ) as varchar),4) + 
				right('00'+cast((CASE fel_orden WHEN 1 THEN fel_valor_mora+ 0 ELSE fel_valor_mora END  - floor(CASE fel_orden WHEN 1 THEN fel_valor_mora+ 
				0 ELSE fel_valor_mora END )) as varchar),2)+ substring(per_carnet,1,2)+substring(per_carnet,4,4)+substring(per_carnet,9,4)+cast(fel_codigo_barra as varchar)+
				right('00'+cast(cil_codcic as varchar),2)+cast(cil_anio as varchar) NPE_MORA,
				CASE fel_orden WHEN 1 THEN fel_valor+ 0 ELSE fel_valor END tmo_valor 
				,fel_fecha,tmo_arancel,fel_fecha_mora fecha_mora,fel_codigo_barra,
				CASE fel_orden WHEN 1 THEN  0 ELSE 0.0 END papeleria,
				CASE fel_orden WHEN 1 THEN fel_valor_mora+ 0 ELSE fel_valor_mora END tmo_valor_mora, 
				CASE fel_orden WHEN 1 THEN  fel_valor ELSE 0.0 END matricula,fel_orden,
				'0'+cast(cil_codcic as varchar)+'-'+cast(cil_anio as varchar) mciclo
				from  ra_per_personas 		
				join ra_alc_alumnos_carrera on alc_codper = ra_per_personas.per_codigo
				join ra_pla_planes on pla_codigo = alc_codpla
				join ra_car_carreras on car_codigo = pla_codcar
				join col_fel_fechas_limite_preesp on fel_codcil = @codcilGenerar --@codcil
				join col_tmo_tipo_movimiento on tmo_codigo = fel_codtmo
				join ra_cil_ciclo on cil_codigo = fel_codcil
				join vst_para_boleta_mensualidades as vst on vst.detmen_codcil = cil_codigo and vst.detmen_codcil = fel_codcil --Vista agregada
				and vst.detmen_codper = alc_codper and vst.detmen_codper = per_codigo and vst.tpmenara_arancel = tmo_arancel
				--join TEMP_EGRESADOS on codper = per_codigo
				where fel_global=0 --and apr_codcil = @codcil
				and ra_per_personas.per_codigo = @codper 
				and car_tipo = 'C' and ra_per_personas.per_codigo not in (select distinct per_codigo from col_art_archivo_tal_preesp_mora where ciclo = @codcilGenerar and per_codigo = @codper)
				and fel_codcil = @codcilGenerar and per_codigo not in (select distinct per_codigo from col_art_archivo_tal_mora where ciclo = @codcilGenerar and per_codigo = @codper)
			   --order by per_carnet
			   --select *from col_fel_fechas_limite_preesp where fel_codcil = 119
			   --select *from col_fel_fechas_limite where fel_codcil = 119
			) q
			order by per_carnet,fel_orden

			declare @numero_affect int = cast(@@rowcount as int)

			print 'Numero de cuotas especiales(afectados) ' +cast(@numero_affect as varchar)
			if @@rowcount < 11 --TIENE ALGUNA CUOTA NORMAL
			begin
				insert into @tabla_cuotas_normales(art_codigo, fecha, per_codigo, per_carnet, ciclo, pla_alias_carrera, per_nombres_apellidos, c415, cc415, c3902, cc3902, c96, cc96, c8020, cc8020, barra, npe, c415M, cc415m, c3902m, cc3902m,
					c96m, cc96m, c8020m, cc8020m, barra_mora, npe_mora, tmo_valor, fel_fecha, tmo_arancel, fecha_mora, fel_codigo_barra, fecha_banco, papeleria, tmo_valor_mora, matricula, fel_orden, mciclo, fechahora)
				select (@numero_affect+@corr)+ row_number() over (order by per_codigo) as art_codigo,
				fecha, --limite, 
				per_codigo , per_carnet, ciclo,
				pla_alias_carrera, per_nombres_apellidos,
				c415,cc415,c3902,cc3902,c96,cc96,c8020,cc8020,
				c415+cc415+c3902+cc3902+c96+cc96+c8020+cc8020 barra,
				npe+dbo.fn_verificador_npe(NPE) NPE,

				c415M,cc415M,c3902M,cc3902M, c96M,cc96M,c8020M,cc8020M,
				c415M+cc415M+c3902M+cc3902M+c96M+cc96M+c8020M+cc8020M BARRA_MORA,
				npe_mora+dbo.fn_verificador_npe(NPE_MORA) NPE_MORA,
		 
				tmo_valor, fel_fecha, tmo_arancel, fecha_mora,fel_codigo_barra, fecha_mora, 
				papeleria,
				CASE  WHEN fel_codigo_barra <= 2 THEN  tmo_valor_mora ELSE tmo_valor_mora END tmo_valor_mora,matricula, fel_orden,mciclo, getdate() 
		 
				from
				(
					select getdate() fecha, --convert(datetime,@fecha,103) limite, 
					ra_per_personas.per_codigo, per_carnet, @codcilGenerar ciclo,
					--substring(pla_alias_carrera,1,55) pla_alias_carrera,per_nombres_apellidos,'415' c415,
					--le agrego mas longitud al substring de alias de carrera
					substring(pla_alias_carrera,1,100) pla_alias_carrera,per_nombres_apellidos,
					'415' c415, 
					'7419700003137' cc415,
					'3902' c3902,
					right('00000000'+cast(floor(CASE fel_orden WHEN 1 THEN fel_valor+ 0 ELSE fel_valor END ) as varchar),8) + 
					right('00'+cast((CASE fel_orden WHEN 1 THEN fel_valor+ 0 ELSE fel_valor END  - floor(CASE fel_orden 
					WHEN 1 THEN fel_valor+ 0 ELSE fel_valor END )) as varchar),2) cc3902,	
					'96' c96,	
					cast(year(fel_fecha) as varchar)+right('00'+cast(month(fel_fecha) as varchar),2)+right('00'+cast(day(fel_fecha) as varchar),2) cc96,
					'8020' c8020,
					substring(per_carnet,1,2)+substring(per_carnet,4,4)+substring(per_carnet,9,4)+cast(fel_codigo_barra as varchar)+
					right('00'+cast(cil_codcic as varchar),2)+cast(cil_anio as varchar) cc8020,
					'0313'+right('0000'+cast(floor(CASE fel_orden WHEN 1 THEN fel_valor+ 0 ELSE fel_valor END ) as varchar),4) + 
					right('00'+cast((CASE fel_orden WHEN 1 THEN fel_valor+ 0 ELSE fel_valor END  - floor(CASE fel_orden WHEN 1 THEN fel_valor+ 
					0 ELSE fel_valor END )) as varchar),2)+ substring(per_carnet,1,2)+substring(per_carnet,4,4)+substring(per_carnet,9,4)+cast(fel_codigo_barra as varchar)+
					right('00'+cast(cil_codcic as varchar),2)+cast(cil_anio as varchar) NPE,
			--************************************************************************************************************************************************************
			---																		VALORES CON MORA
			--************************************************************************************************************************************************************
					'415' c415M, 
					'7419700003137' cc415M,
					'3902' c3902M,	
					right('00000000'+cast(floor(CASE fel_orden WHEN 1 THEN fel_valor_mora+ 0 ELSE fel_valor_mora END ) as varchar),8) + 
					right('00'+cast((CASE fel_orden WHEN 1 THEN fel_valor_mora+ 0 ELSE fel_valor_mora END  - floor(CASE fel_orden 
					WHEN 1 THEN fel_valor_mora+ 0 ELSE fel_valor_mora END )) as varchar),2) cc3902M,
					'96' c96M,
					cast(year(fel_fecha_mora) as varchar)+right('00'+cast(month(fel_fecha_mora) as varchar),2)+right('00'+cast(day(fel_fecha_mora) as varchar),2) cc96M,
					'8020' c8020M,
					substring(per_carnet,1,2)+substring(per_carnet,4,4)+substring(per_carnet,9,4)+cast(fel_codigo_barra as varchar)+
					right('00'+cast(cil_codcic as varchar),2)+cast(cil_anio as varchar) cc8020M,
					'0313'+right('0000'+cast(floor(CASE fel_orden WHEN 1 THEN fel_valor_mora+ 0 ELSE fel_valor_mora END ) as varchar),4) + 
					right('00'+cast((CASE fel_orden WHEN 1 THEN fel_valor_mora+ 0 ELSE fel_valor_mora END  - floor(CASE fel_orden WHEN 1 THEN fel_valor_mora+ 
					0 ELSE fel_valor_mora END )) as varchar),2)+ substring(per_carnet,1,2)+substring(per_carnet,4,4)+substring(per_carnet,9,4)+cast(fel_codigo_barra as varchar)+
					right('00'+cast(cil_codcic as varchar),2)+cast(cil_anio as varchar) NPE_MORA,
					CASE fel_orden WHEN 1 THEN fel_valor+ 0 ELSE fel_valor END tmo_valor 
					,fel_fecha,tmo_arancel,fel_fecha_mora fecha_mora,fel_codigo_barra,
					CASE fel_orden WHEN 1 THEN  0 ELSE 0.0 END papeleria,
					CASE fel_orden WHEN 1 THEN fel_valor_mora+ 0 ELSE fel_valor_mora END tmo_valor_mora, 
					CASE fel_orden WHEN 1 THEN  fel_valor ELSE 0.0 END matricula,fel_orden,
					'0'+cast(cil_codcic as varchar)+'-'+cast(cil_anio as varchar) mciclo
					from  ra_per_personas 		
					join ra_alc_alumnos_carrera on alc_codper = ra_per_personas.per_codigo
					join ra_pla_planes on pla_codigo = alc_codpla
					join ra_car_carreras on car_codigo = pla_codcar
					join col_fel_fechas_limite_preesp on fel_codcil = @codcilGenerar --@codcil
					join col_tmo_tipo_movimiento on tmo_codigo = fel_codtmo
					join ra_cil_ciclo on cil_codigo = fel_codcil
					--join TEMP_EGRESADOS on codper = per_codigo
					where fel_global=0 --and apr_codcil = @codcil
					and ra_per_personas.per_codigo = @codper 
					and car_tipo = 'C' and ra_per_personas.per_codigo not in (select distinct per_codigo from col_art_archivo_tal_preesp_mora where ciclo = @codcilGenerar and per_codigo = @codper)
					and fel_codcil = @codcilGenerar and per_codigo not in (select distinct per_codigo from col_art_archivo_tal_mora where ciclo = @codcilGenerar and per_codigo = @codper)
					and fel_codtipmen is null
				   --order by per_carnet
				) q
				order by per_carnet,fel_orden
			end
			if @Opcion = 1
			Begin
				select art_codigo, fecha,limite, per_codigo, per_carnet, ciclo, pla_alias_carrera, per_nombres_apellidos, c415, cc415, c3902, cc3902,
					c96, cc96, c8020, cc8020, barra, NPE, c415M, cc415M, c3902M, cc3902M, c96M, cc96M, c8020M, cc8020M, BARRA_MORA, NPE_MORA, tmo_valor, fel_fecha, tmo_arancel, CONVERT(CHAR(10), fecha_banco, 103) fecha_banco, 
					fel_codigo_barra, papeleria, tmo_valor_mora, matricula, fel_orden, mciclo, fechahora from @tabla
				union
				select art_codigo, fecha,limite, per_codigo, per_carnet, ciclo, pla_alias_carrera, per_nombres_apellidos, c415, cc415, c3902, cc3902,
					c96, cc96, c8020, cc8020, barra, NPE, c415M, cc415M, c3902M, cc3902M, c96M, cc96M, c8020M, cc8020M, BARRA_MORA, NPE_MORA, tmo_valor, fel_fecha, tmo_arancel, CONVERT(CHAR(10), fecha_banco, 103) fecha_banco, 
					fel_codigo_barra, papeleria, tmo_valor_mora, matricula, fel_orden, mciclo, fechahora from @tabla_cuotas_normales where fel_codigo_barra not in (select fel_codigo_barra from @tabla)
				order by fel_codigo_barra asc

			end

			if @opcion = 2
			Begin
				insert into col_art_archivo_tal_preesp_mora (art_codigo, fecha,limite, per_codigo, per_carnet, ciclo, pla_alias_carrera, per_nombres_apellidos, c415, cc415, c3902, cc3902,
					c96, cc96, c8020, cc8020, barra, NPE, c415M, cc415M, c3902M, cc3902M, c96M, cc96M, c8020M, cc8020M, BARRA_MORA, NPE_MORA, tmo_valor, fel_fecha, tmo_arancel, fecha_banco,
					fel_codigo_barra, papeleria, tmo_valor_mora, matricula, fel_orden, mciclo, fechahora)
				--	select * from @tabla

				select art_codigo, fecha,limite, per_codigo, per_carnet, ciclo, pla_alias_carrera, per_nombres_apellidos, c415, cc415, c3902, cc3902,
					c96, cc96, c8020, cc8020, barra, NPE, c415M, cc415M, c3902M, cc3902M, c96M, cc96M, c8020M, cc8020M, BARRA_MORA, NPE_MORA, tmo_valor, fel_fecha, tmo_arancel, CONVERT(CHAR(10), fecha_banco, 103) fecha_banco, 
					fel_codigo_barra, papeleria, tmo_valor_mora, matricula, fel_orden, mciclo, fechahora from @tabla
				union
				select art_codigo, fecha,limite, per_codigo, per_carnet, ciclo, pla_alias_carrera, per_nombres_apellidos, c415, cc415, c3902, cc3902,
					c96, cc96, c8020, cc8020, barra, NPE, c415M, cc415M, c3902M, cc3902M, c96M, cc96M, c8020M, cc8020M, BARRA_MORA, NPE_MORA, tmo_valor, fel_fecha, tmo_arancel, CONVERT(CHAR(10), fecha_banco, 103) fecha_banco, 
					fel_codigo_barra, papeleria, tmo_valor_mora, matricula, fel_orden, mciclo, fechahora from @tabla_cuotas_normales where fel_codigo_barra not in (select fel_codigo_barra from @tabla)
				order by fel_codigo_barra asc
				

				select * from @tabla
				union
				select * from @tabla_cuotas_normales where fel_codigo_barra not in (select fel_codigo_barra from @tabla)
				order by fel_codigo_barra asc
				--select * from @tabla

				--select * from col_art_archivo_tal_preesp_mora where ciclo = 110
			End	--	if @Opcion = 2
	
		
	End	--	--	if (@opcion = 1 or @opcion = 2)

END
----	select * from col_art_archivo_tal_preesp_mora where per_carnet = '12-1998-2011'
--		select * from col_art_archivo_tal_mora where per_carnet = '12-1998-2011'
--select * from col_fel_fechas_limite_preesp where fel_codcil = 117