USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[tal_GenerarDataTalonarioPreGrado_porAlumno]    Script Date: 24/05/2019 18:22:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Generar Data de Talonario de PreGrado>
-- =============================================
--	exec tal_GenerarDataTalonarioPreGrado_porAlumno -1, 1, 119, 119, '20/01/2017', 181324	--	Elimina la data de los talonarios
--	exec tal_GenerarDataTalonarioPreGrado_porAlumno 0, 1, 119, 119, '20/01/2017', 181324	--	Verifica si existe la data generada
--	exec tal_GenerarDataTalonarioPreGrado_porAlumno 1, 1, 119, 119, '20/01/2017', 181324	--	Datos previos
--	exec tal_GenerarDataTalonarioPreGrado_porAlumno 2, 1, 119, 119, '20/01/2017', 181324	--	Inserta la data para los talonarios

ALTER PROCEDURE [dbo].[tal_GenerarDataTalonarioPreGrado_porAlumno]
	@Opcion int,
	@codreg int,
	@codcilGenerar int,
	@codcilBaseParaGenerar int,
	@fecha nvarchar(10),
	@codper int
AS
BEGIN
	SET NOCOUNT ON;
	declare @cantidad int
	declare @carnet nvarchar(15)
	declare @anio_carnet nvarchar(4)


	set dateformat dmy

	if @opcion = -1
	begin
		--	select * from col_art_archivo_tal_mora where per_codigo = @Codper and ciclo = @CodCilGenerar
		delete from col_art_archivo_tal_mora where per_codigo = @Codper and ciclo = @CodCilGenerar
		print 'Registro eliminado'
	end

	if @opcion = 0
	begin
		--Select @cantidad = count(per_codigo) from col_art_archivo_tal_mora where per_codigo = @codper and ciclo = @codcilGenerar
		--if @cantidad = 0
		if not exists(Select 1 from col_art_archivo_tal_mora where per_codigo = @Codper and ciclo = @CodCilGenerar)
		begin
			print 'El alumno NO posee data generada de los talonarios'
		end
		else
		begin
			print 'El alumno YA posee data generada de los talonarios'
		end
	end	--	if @opcion = 0

	if (@opcion = 1 or @opcion = 2)
	begin
		select @carnet = per_carnet 
		from ra_per_personas where per_codigo = @codper and per_tipo = 'U'
		
		set @anio_carnet = substring(@carnet, 9 , 4)

		if exists (select 1 from ra_per_personas join col_detmen_detalle_tipo_mensualidad on per_codigo = detmen_codper where detmen_codcil = @CodCilGenerar and per_carnet = @carnet)
		begin
			--GENERA DATA POR ALUMNO DE PREGRADO ESPECIAL(BECADO)
			print '***Alumno posee mensualidad especial***'
			exec tal_GenerarDataTalonarioPreGrado_porAlumno_Especial @Opcion, @codreg, @codcilGenerar, @codcilGenerar, @fecha, @codper			
		end
		else
		begin
			print 'Alumno no posee mensualidad especial'

			declare @mtipo int ,@mglobal int --,@cod_arancel1 int, @cod_arancel2 int
			--con pagos o sin pagos
			set @codreg = 1 
			set @mtipo = 0 
			set @mglobal = 0
			set @mtipo =0

			declare @corr int
			select @corr = isnull(max(art_codigo),0)
			from col_art_archivo_tal_mora

			Declare @Data_cuotas_normales TABLE (
				[art_codigo] [bigint] NULL,
				[fecha] [datetime] NOT NULL,
				[limite] [datetime] NULL,
				[per_codigo] [int] NOT NULL,
				[per_carnet] [varchar](50) NOT NULL,
				[ciclo] [int] NULL,
				[pla_alias_carrera] [varchar](100) NULL,
				[per_nombres_apellidos] [varchar](201) NOT NULL,
				[c415] [varchar](3) NOT NULL,
				[cc415] [varchar](13) NOT NULL,
				[c3902] [varchar](4) NOT NULL,
				[cc3902] [varchar](10) NULL,
				[c96] [varchar](2) NOT NULL,
				[cc96] [varchar](34) NULL,
				[c8020] [varchar](4) NOT NULL,
				[cc8020] [varchar](72) NULL,
				[barra] [varchar](142) NULL,
				[NPE] [varchar](83) NULL,
				[c415M] [varchar](3) NOT NULL,
				[cc415M] [varchar](13) NOT NULL,
				[c3902M] [varchar](4) NOT NULL,
				[cc3902M] [varchar](10) NULL,
				[c96M] [varchar](2) NOT NULL,
				[cc96M] [varchar](34) NULL,
				[c8020M] [varchar](4) NOT NULL,
				[cc8020M] [varchar](72) NULL,
				[BARRA_MORA] [varchar](142) NULL,
				[NPE_MORA] [varchar](83) NULL,
				[tmo_valor] [numeric](19, 2) NULL,
				[fel_fecha] [datetime] NOT NULL,
				[tmo_arancel] [varchar](5) NULL,
				[fecha_banco] [datetime] NOT NULL,
				[fel_codigo_barra] [int] NULL,
				[papeleria] [numeric](3, 2)  NULL,
				[tmo_valor_mora] [numeric](19, 2) NULL,
				[matricula] [numeric](18, 2) NULL,
				[mciclo] [varchar](62) NULL,
				cod_carrera nvarchar(4)
			) 

			declare @tipo_carrera nvarchar(25)
			declare @codvac int

			select @tipo_carrera =
			--car_nombre,
				--per_carnet, per_codigo, per_nombres_apellidos, per_codvac, 
			--car_nombre--car_tipo, car_identificador, per_tipo_ingreso, 
				case when car_nombre not like '%no presencial%' then 'Presencial' 
					when car_nombre like '%no presencial%' then 'No Presencial'
				end
			from ra_per_personas inner join ra_car_carreras on
				car_identificador = substring(per_carnet,1,2) 
			where per_tipo = 'U' and per_codigo = @codper

			print '@tipo_carrera : ' + @tipo_carrera


			IF exists ( Select 1
						from tal_tp_anio_virtual_data
						where tp_tipo = 'PREGRADO' and @tipo_carrera = 'No Presencial' and tp_anio = @anio_carnet and tp_codvac = 2
					)
			begin
				select @codvac = tp_codvac from tal_tp_anio_virtual_data
				where tp_tipo = 'PREGRADO' and tp_anio = @anio_carnet

				print 'asignando @codvac = ' + cast(@codvac as nvarchar(5))

				update ra_per_personas set per_codvac = @codvac
				where per_codigo = @codper and per_tipo = 'U'		
			end

			--select * from tal_tp_anio_virtual_data

			--if @tipo_carrera = 'Presencial'
			--begin
			--	update ra_per_personas set per_codvac = 1 where per_codigo = @codper and @tipo_carrera = 'Presencial'
			--end

			--if @tipo_carrera = 'No Presencial'
			--begin
			--	update ra_per_personas set per_codvac = 2 where per_codigo = @codper and @tipo_carrera = 'No Presencial'
			--end	


			--If @Opcion = 1	-- Data que sirve de base para generar el siguiente ciclo
			--Begin

				--****************************************************GENERACION DE TALONARIOS MORA******************************************************************--
				--**********************************************************************************************************************************************--

			Insert Into @Data_cuotas_normales (art_codigo, 
				fecha, limite, per_codigo, per_carnet, ciclo, pla_alias_carrera, per_nombres_apellidos, c415, cc415, c3902, cc3902, c96,
				cc96, c8020, cc8020, barra, NPE, c415M, cc415M, c3902M, cc3902M, c96M, cc96M, c8020M, cc8020M, BARRA_MORA, NPE_MORA, tmo_valor, fel_fecha, tmo_arancel,
				fecha_banco, fel_codigo_barra, ---papeleria, 
				tmo_valor_mora, matricula, mciclo, cod_carrera)

				select @corr+ row_number() over (order by per_codigo) art_codigo, 
					fecha, limite, per_codigo , per_carnet, ciclo,
						 pla_alias_carrera, per_nombres_apellidos,
						 c415,cc415,c3902,cc3902,c96,cc96,c8020,cc8020,
						 c415+cc415+c3902+cc3902+c96+cc96+c8020+cc8020 barra,
						 npe+dbo.fn_verificador_npe(NPE) NPE,

						 c415M,cc415M,c3902M,cc3902M,c96M,cc96M,c8020M,cc8020M,
						 c415M+cc415M+c3902M+cc3902M+c96M+cc96M+c8020M+cc8020M BARRA_MORA,
						 npe_mora+dbo.fn_verificador_npe(NPE_MORA) NPE_MORA,

						 tmo_valor, fel_fecha,tmo_arancel,fecha_mora,fel_codigo_barra,--papeleria,
						 CASE  WHEN fel_codigo_barra <= 2 THEN  tmo_valor_mora ELSE tmo_valor_mora END tmo_valor_mora,matricula, mciclo, substring(per_carnet,1,2) as carrera
						 --,per_codvac , fel_codvac
						 --into migraciondata
			from
				(
					select getdate() fecha,convert(datetime,@fecha,103) limite, per_codigo, per_carnet, @codcilGenerar ciclo,
					--substring(pla_alias_carrera,1,55) pla_alias_carrera,per_nombres_apellidos,'415' c415,
					--le agrego mas longitud al substring de alias de carrera
					substring(pla_alias_carrera,1,100) pla_alias_carrera,per_nombres_apellidos,
					'415' c415, 
					'7419700003137' cc415,
					'3902' c3902,
					right('00000000'+cast(floor(CASE fel_codigo_barra WHEN 1 THEN fel_valor+ 0 ELSE fel_valor END ) as varchar),8) + 
					right('00'+cast((CASE fel_codigo_barra WHEN 1 THEN fel_valor+ 0 ELSE fel_valor END  - floor(CASE fel_codigo_barra 
					WHEN 1 THEN fel_valor+ 0 ELSE fel_valor END )) as varchar),2) cc3902,	
					'96' c96,	
					cast(year(fel_fecha) as varchar)+right('00'+cast(month(fel_fecha) as varchar),2)+right('00'+cast(day(fel_fecha) as varchar),2) cc96,
					'8020' c8020,
					substring(per_carnet,1,2)+substring(per_carnet,4,4)+substring(per_carnet,9,4)+cast(fel_codigo_barra as varchar)+
					right('00'+cast(cil_codcic as varchar),2)+cast(cil_anio as varchar) cc8020,
					'0313'+right('0000'+cast(floor(CASE fel_codigo_barra WHEN 1 THEN fel_valor+ 0 ELSE fel_valor END ) as varchar),4) + 
					right('00'+cast((CASE fel_codigo_barra WHEN 1 THEN fel_valor+ 0 ELSE fel_valor END  - floor(CASE fel_codigo_barra WHEN 1 THEN fel_valor+ 
					0 ELSE fel_valor END )) as varchar),2)+ substring(per_carnet,1,2)+substring(per_carnet,4,4)+substring(per_carnet,9,4)+cast(fel_codigo_barra as varchar)+
					right('00'+cast(cil_codcic as varchar),2)+cast(cil_anio as varchar) NPE,
			----************************************************************************************************************************************************************
			---																		VALORES CON MORA
			----************************************************************************************************************************************************************
					'415' c415M, 
					'7419700003137' cc415M,
					'3902' c3902M,	
					right('00000000'+cast(floor(CASE fel_codigo_barra WHEN 1 THEN fel_valor_mora+ 0 ELSE fel_valor_mora END ) as varchar),8) + 
					right('00'+cast((CASE fel_codigo_barra WHEN 1 THEN fel_valor_mora+ 0 ELSE fel_valor_mora END  - floor(CASE fel_codigo_barra 
					WHEN 1 THEN fel_valor_mora+ 0 ELSE fel_valor_mora END )) as varchar),2) cc3902M,
					'96' c96M,
					cast(year(fel_fecha_mora) as varchar)+right('00'+cast(month(fel_fecha_mora) as varchar),2)+right('00'+cast(day(fel_fecha_mora) as varchar),2) cc96M,
					'8020' c8020M,
					substring(per_carnet,1,2)+substring(per_carnet,4,4)+substring(per_carnet,9,4)+cast(fel_codigo_barra as varchar)+
					right('00'+cast(cil_codcic as varchar),2)+cast(cil_anio as varchar) cc8020M,
					'0313'+right('0000'+cast(floor(CASE fel_codigo_barra WHEN 1 THEN fel_valor_mora+ 0 ELSE fel_valor_mora END ) as varchar),4) + 
					right('00'+cast((CASE fel_codigo_barra WHEN 1 THEN fel_valor_mora+ 0 ELSE fel_valor_mora END  - floor(CASE fel_codigo_barra WHEN 1 THEN fel_valor_mora+ 
					0 ELSE fel_valor_mora END )) as varchar),2)+ substring(per_carnet,1,2)+substring(per_carnet,4,4)+substring(per_carnet,9,4)+cast(fel_codigo_barra as varchar)+
					right('00'+cast(cil_codcic as varchar),2)+cast(cil_anio as varchar) NPE_MORA,
					CASE fel_codigo_barra WHEN 1 THEN fel_valor+ 0 ELSE fel_valor END tmo_valor 
					,fel_fecha,tmo_arancel,fel_fecha_mora fecha_mora,fel_codigo_barra,
					--CASE fel_codigo_barra WHEN 1 THEN  5.75 ELSE 0.0 END papeleria,
					CASE fel_codigo_barra WHEN 1 THEN fel_valor_mora+ 0 ELSE fel_valor_mora END tmo_valor_mora, 
					CASE fel_codigo_barra WHEN 1 THEN  fel_valor ELSE 0.0 END matricula,
					'0'+cast(cil_codcic as varchar)+'-'+cast(cil_anio as varchar) mciclo
					--,ra_per_personas.per_codvac , col_fel_fechas_limite.fel_codvac
					from ra_per_personas
					--join @mov on mov_codper = per_codigo
					join ra_alc_alumnos_carrera on alc_codper = per_codigo
					join ra_pla_planes on pla_codigo = alc_codpla
					join ra_car_carreras on car_codigo = pla_codcar
					join col_fel_fechas_limite on fel_codcil = @CodCilGenerar 


					join col_tmo_tipo_movimiento on tmo_codigo = fel_codtmo
					join ra_cil_ciclo on cil_codigo = fel_codcil and ra_per_personas.per_codvac = col_fel_fechas_limite.fel_codvac

					where -- fel_global=@mglobal and 
						per_codigo = @Codper --in (146532, 153330, 187161, 186636,186715, 146352, 187071)
						and @codper not in (select distinct per_codigo from col_art_archivo_tal_mora where per_codigo = @codper and ciclo = @codcilGenerar)
					--and fel_codcil = @codcilGenerar 
					and per_tipo = 'U' and fel_codtipmen is null
				) q

			--order by per_carnet, fel_codigo_barra asc

						--select * from col_fel_fechas_limite where fel_codcil = 119 and fel_codvac = 2

			--End	--	If @Opcion = 1	-- Data que sirve de base para generar el siguiente ciclo
			--select * from col_tipmen_tipo_mensualidad
			--select tmo_codigo,* from col_tpmenara_tipo_mensualidad_aranceles, col_tmo_tipo_movimiento where tmo_arancel = tpmenara_arancel
			/*select tmo_codigo,tmo_arancel from col_tmo_tipo_movimiento where tmo_arancel like 'V-%' group by tmo_arancel, tmo_codigo 

			select * from col_fel_fechas_limite where fel_codcil = 119 and fel_codvac = 2 and isnull(fel_codtipmen, 0) = 0 order by fel_Valor asc
			select * from ra_vac_valor_cuotas
			select * from col_fel_fechas_limite where fel_codcil = 119 and fel_codvac = 2
		
			select * from col_tpmenara_tipo_mensualidad_aranceles where tpmenara_codtipmen = 5
			alter table col_fel_fechas_limite add fel_codtipmen int foreign key references col_tipmen_tipo_mensualidad
			*/
			update @Data_cuotas_normales Set pla_alias_carrera =  car_nombre 
			From ra_car_carreras inner join @Data_cuotas_normales on cod_carrera = car_identificador
		
		

			--select * from @Data_cuotas_normales

			if @opcion = 1
			begin
				select art_codigo, fecha, limite, per_codigo, per_carnet, ciclo, pla_alias_carrera, per_nombres_apellidos, c415, cc415, c3902, cc3902, c96, cc96, c8020,
					cc8020, barra, NPE, c415M, cc415M, c3902M, cc3902M, c96M, cc96M, c8020M, cc8020M, BARRA_MORA, NPE_MORA, tmo_valor, fel_fecha, tmo_arancel, fecha_banco,
					fel_codigo_barra, tmo_valor_mora, matricula, mciclo
				from  @Data_cuotas_normales
			end	--	if @opcion = 1

			if @opcion = 2
			begin
				Insert into col_art_archivo_tal_mora (
					art_codigo, fecha, limite, per_codigo, per_carnet, ciclo, pla_alias_carrera, per_nombres_apellidos, c415, cc415, c3902, cc3902, c96, cc96, c8020,
					cc8020, barra, NPE, c415M, cc415M, c3902M, cc3902M, c96M, cc96M, c8020M, cc8020M, BARRA_MORA, NPE_MORA, tmo_valor, fel_fecha, tmo_arancel, fecha_banco,
					fel_codigo_barra, tmo_valor_mora, matricula, mciclo)
				select art_codigo, fecha, limite, per_codigo, per_carnet, ciclo, pla_alias_carrera, per_nombres_apellidos, c415, cc415, c3902, cc3902, c96, cc96, c8020,
					cc8020, barra, NPE, c415M, cc415M, c3902M, cc3902M, c96M, cc96M, c8020M, cc8020M, BARRA_MORA, NPE_MORA, tmo_valor, fel_fecha, tmo_arancel, fecha_banco,
					fel_codigo_barra, tmo_valor_mora, matricula, mciclo
				from  @Data_cuotas_normales

				select * from col_art_archivo_tal_mora where art_codigo > @corr
			end	--	if @opcion = 2
		end
	end	--	--	if (@opcion = 1 or @opcion = 2)

END
