USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_cuotas_estudiantes_maestrias]    Script Date: 1/2/2022 10:41:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	-- exec dbo.sp_cuotas_estudiantes_maestrias 1, 181507

ALTER PROCEDURE [dbo].[sp_cuotas_estudiantes_maestrias]
	@car_codtde int,
	@codper int
AS
BEGIN
	set dateformat dmy
	declare @a int

	declare @validador_pregrado int
	set @validador_pregrado = 1
	--ULTIMO CICLO DE INSCRIPCIÓN
	DECLARE @codcil int
	


	SELECT @codcil = MAX(ins_codcil) FROM ra_ins_inscripcion
	WHERE ins_codper = @codper

	set @codcil = @codcil 
	PRINT '@codcil : ' + CAST(@codcil AS NVARCHAR(10))
	--PRE GRADO y PRE ESPECIALIDAD

	IF @car_codtde = 1
	BEGIN
		print	'Verificando si es de pregrado o pre especializacion el alumno'
		--	PRE GRADO
		
		if exists(select 1 from col_art_archivo_tal_preesp_mora where per_codigo = @codper) -- and ciclo > @codcil)
		begin
			set @validador_pregrado = 0
			print 'alumno de pre Especializacion'
			--select * from col_art_archivo_tal_preesp_mora where per_codigo = @codper and ciclo > @codcil
			--	PRE ESPECIALIDAD

			select @codcil = max(ciclo) from col_art_archivo_tal_preesp_mora where per_codigo = @codper 


			  --declare @pendientes table (arancel nvarchar(25), codper int, cantidad int, Estado nvarchar(25),descripcion nvarchar(150), cuota int, codcil int, fecha date)

			   --insert into @pendientes (arancel, codper, cantidad, Estado, descripcion, cuota, codcil, fecha)
			   --select tmo.tmo_arancel, t.per_codigo as codper, 1 as cantidad, 
			   --      'Pendiente' as Estado, tmo.tmo_descripcion, vst.are_cuota, t.ciclo, t.fel_fecha_mora
			   select art.per_codigo, art.per_carnet, art.per_nombres_apellidos, art.tmo_arancel, art.fel_fecha_mora, art.ciclo, art.mciclo, 
					tmo.tmo_descripcion, 
					case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end as Monto, NPE
			   from col_tmo_tipo_movimiento as tmo inner join vst_Aranceles_x_Evaluacion as vst
					 on vst.tmo_arancel = tmo.tmo_arancel and vst.are_codtmo = tmo.tmo_codigo inner join col_art_archivo_tal_preesp_mora as art 
					 on art.tmo_arancel = tmo.tmo_arancel inner join ra_per_personas as p 
					 on p.per_codigo = art.per_codigo

			   where art.per_codigo = @codper and art.ciclo = @codcil and vst.are_tipo = 'PREESPECIALIDAD'
			   and are_cuota not in
			   (
					 select vst.are_cuota
					 from col_mov_movimientos as mov inner join col_dmo_det_mov as dmo
							on dmo.dmo_codmov = mov.mov_codigo inner join col_tmo_tipo_movimiento as tmo
							on tmo.tmo_codigo =  dmo.dmo_codtmo inner join vst_Aranceles_x_Evaluacion as vst
							on vst.tmo_arancel = tmo.tmo_arancel and vst.are_codtmo = tmo.tmo_codigo 
					 where mov_codper = @codper and dmo_codcil = @codcil and vst.are_tipo = 'PREESPECIALIDAD' and mov_estado <> 'A'       
			   )
			   order by vst.are_cuota, art.fel_fecha_mora asc
		end	--	if exists(select 1 from col_art_archivo_tal_preesp_mora where per_codigo = @codper and ciclo > @codcil)


		if exists(select 1 from col_art_archivo_tal_proc_grad_tec_dise_mora where per_codigo = @codper and ciclo > @codcil)
		begin
			set @validador_pregrado = 0
			print 'alumno de pre Especializacion Tecnico Diseño Grafico'

			select @codcil = max(ciclo) from col_art_archivo_tal_proc_grad_tec_dise_mora where per_codigo = @codper 

			--select * from col_art_archivo_tal_proc_grad_tec_dise_mora where per_codigo = @codper and ciclo > @codcil
			--	PRE ESPECIALIDAD TECNICOS
			select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
				art.tmo_arancel, art.fel_fecha_mora as fel_fecha_mora, art.ciclo as ciclo, art.mciclo, tmo.tmo_descripcion, 
				case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end as Monto, NPE			
			from col_art_archivo_tal_proc_grad_tec_dise_mora as art
				--inner join alumnos_por_arancel_maestria as apama on apama.codcil = art.ciclo and apama.per_codigo = art.per_codigo
				inner join col_fel_fechas_limite_tecnicos_dise as fel on fel.fel_codcil = art.ciclo --and fel.fel_codtmo = apama.tmo_codigo --and fel.origen = art.origen
				inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_arancel = art.tmo_arancel
			where art.per_codigo = @codper 
			and tmo.tmo_arancel not in (
					SELECT tmo_arancel 
					FROM col_mov_movimientos 
					join col_dmo_det_mov on dmo_codmov = mov_codigo
					join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
					WHERE 
					mov_codper = @codper 
					and dmo_codcil >= @codcil--ciclo--MAX(art.ciclo)
					and mov_estado <> 'A'
				)
			and art.ciclo >= @codcil
			---- EXEC sp_cuotas_estudiantes_maestrias 3,188459
			--GROUP BY art.per_codigo, art.per_carnet, art.per_nombres_apellidos, art.tmo_arancel,
			--art.fecha, art.mciclo, tmo.tmo_descripcion, art.tmo_valor
			order by art.fel_fecha_mora asc
		end	--	if exists(select 1 from col_art_archivo_tal_preesp_mora where per_codigo = @codper and ciclo > @codcil)

		if exists(select 1 from col_art_archivo_tal_proc_grad_tec_mora where per_codigo = @codper and ciclo > @codcil)
		begin
			set @validador_pregrado = 0
			print 'alumno de pre Especializacion Tecnico '

			select @codcil = max(ciclo) from col_art_archivo_tal_proc_grad_tec_mora where per_codigo = @codper 

			--select * from col_art_archivo_tal_proc_grad_tec_dise_mora where per_codigo = @codper and ciclo > @codcil
			--	PRE ESPECIALIDAD TECNICOS
			select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
				art.tmo_arancel, art.fel_fecha_mora, --MAX(art.ciclo) as ciclo, 
				art.ciclo as ciclo, art.mciclo, tmo.tmo_descripcion, 
				case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end as Monto, NPE
			--art.tmo_valor as Monto
			from col_art_archivo_tal_proc_grad_tec_mora as art
				--inner join alumnos_por_arancel_maestria as apama on apama.codcil = art.ciclo and apama.per_codigo = art.per_codigo
				inner join col_fel_fechas_limite_tecnicos as fel on fel.fel_codcil = art.ciclo --and fel.fel_codtmo = apama.tmo_codigo --and fel.origen = art.origen
				inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_arancel = art.tmo_arancel
			where art.per_codigo = @codper 
			and tmo.tmo_arancel not in (
					SELECT tmo_arancel 
					FROM col_mov_movimientos 
					join col_dmo_det_mov on dmo_codmov = mov_codigo
					join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
					WHERE 
					mov_codper = @codper 
					and dmo_codcil >= @codcil--ciclo--MAX(art.ciclo)
					and mov_estado <> 'A'
				)
			and art.ciclo >= @codcil
			---- EXEC sp_cuotas_estudiantes_maestrias 3,188459
			--GROUP BY art.per_codigo, art.per_carnet, art.per_nombres_apellidos, art.tmo_arancel,
			--	art.fecha, art.mciclo, tmo.tmo_descripcion, 
			--	case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end
			order by art.fel_fecha_mora asc
		end	--	if exists(select 1 from col_art_archivo_tal_preesp_mora where per_codigo = @codper and ciclo > @codcil)
		--select * from col_fel_fechas_limite_tecnicos
		--select * from col_art_archivo_tal_proc_grad_tec_mora
		--if exists(select 1 from col_art_archivo_tal_proc_grad_tec_mora where per_codigo = @codper and ciclo > @codcil)
		--begin
		--	set @validador_pregrado = 0
		--	print 'alumno de pre Especializacion Tecnicos'
		--	--select * from col_art_archivo_tal_proc_grad_tec_mora where per_codigo = @codper and ciclo > @codcil
		--	--	PRE ESPECIALIDAD TECNICOS
		--	select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
		--	art.tmo_arancel, art.fecha, MAX(art.ciclo) as ciclo, art.mciclo, tmo.tmo_descripcion
		--	from col_art_archivo_tal_proc_grad_tec_mora as art
		--		--inner join alumnos_por_arancel_maestria as apama on apama.codcil = art.ciclo and apama.per_codigo = art.per_codigo
		--		inner join col_fel_fechas_limite_tecnicos as fel on fel.fel_codcil = art.ciclo --and fel.fel_codtmo = apama.tmo_codigo --and fel.origen = art.origen
		--		inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_arancel = art.fel_codtmo
		--	where art.per_codigo = @codper 
		--	and tmo.tmo_arancel not in (
		--			SELECT tmo_arancel 
		--			FROM col_mov_movimientos 
		--			join col_dmo_det_mov on dmo_codmov = mov_codigo
		--			join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
		--			WHERE 
		--			mov_codper = @codper 
		--			and dmo_codcil > @codcil--ciclo--MAX(art.ciclo)
		--		)
		--	and art.ciclo > @codcil
		--	---- EXEC sp_cuotas_estudiantes_maestrias 3,188459
		--	GROUP BY art.per_codigo, art.per_carnet, art.per_nombres_apellidos, art.tmo_arancel,
		--	art.fecha, art.mciclo, tmo.tmo_descripcion
		--end	--	if exists(select 1 from col_art_archivo_tal_preesp_mora where per_codigo = @codper and ciclo > @codcil)
		
		if (@validador_pregrado = 1)
		begin
			print 'el alumno es de pregrado'
			select @codcil = min(ciclo) from col_art_archivo_tal_mora where per_codigo = @codper
			print '@codcil : ' + cast(@codcil as nvarchar(10))



			--select tmo.tmo_arancel, t.per_codigo as codper, 1 as cantidad, 
			--	'Pendiente' as Estado, tmo.tmo_descripcion, vst.are_cuota, t.ciclo
			select art.per_codigo, art.per_carnet, art.per_nombres_apellidos, art.tmo_arancel, art.fel_fecha_mora, art.ciclo, art.mciclo, tmo.tmo_descripcion, 
				case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end as Monto, NPE
				--t.tmo_valor as Monto
			from col_tmo_tipo_movimiento as tmo inner join vst_Aranceles_x_Evaluacion as vst
				on vst.tmo_arancel = tmo.tmo_arancel and vst.are_codtmo = tmo.tmo_codigo inner join col_art_archivo_tal_mora as art 
				on art.tmo_arancel = tmo.tmo_arancel inner join ra_per_personas as p 
				on p.per_codigo = art.per_codigo

			where art.per_codigo = @codper and art.ciclo = @codcil and vst.are_tipo = 'PREGRADO'
			and are_cuota not in
			(
				select vst.are_cuota
				from col_mov_movimientos as mov inner join col_dmo_det_mov as dmo
					on dmo.dmo_codmov = mov.mov_codigo -- and dmo.dmo_codcil = mov.mov_codcil 
					inner join col_tmo_tipo_movimiento as tmo
					on tmo.tmo_codigo =  dmo.dmo_codtmo inner join vst_Aranceles_x_Evaluacion as vst
					on vst.tmo_arancel = tmo.tmo_arancel and vst.are_codtmo = tmo.tmo_codigo 
				where mov_codper = @codper and dmo_codcil = @codcil and vst.are_tipo = 'PREGRADO' and mov_estado <> 'A'		
			)
			order by vst.are_cuota, art.fel_fecha_mora asc
			--select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
			--art.tmo_arancel, art.fel_fecha_mora,-- MAX(art.ciclo) as ciclo, 
			--art.ciclo,
			--art.mciclo, t.tmo_descripcion, art.tmo_valor as Monto
			--from col_art_archivo_tal_mora as art inner join col_tmo_tipo_movimiento as t on t.tmo_arancel = art.tmo_arancel
			--where cast(art.ciclo as nvarchar(10)) + '-' + t.tmo_arancel not in 
			--(
			--		SELECT cast(dmo_codcil as nvarchar(10)) + '-' + vst.tmo_arancel
			--		FROM col_mov_movimientos 
			--		join col_dmo_det_mov on dmo_codmov = mov_codigo
			--		join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
			--		join vst_Aranceles_x_Evaluacion as vst on vst.are_codtmo = dmo_codtmo
			--		WHERE mov_codper = @codper 
			--		and dmo_codcil >= @codcil--ciclo--MAX(art.ciclo)
			--		and tde_nombre = 'Pre grado' and mov_estado <> 'A'
			--	)
			--and per_codigo = @codper 
			--order by art.fel_fecha_mora asc
		end	--	if (@validador_pregrado = 1)




		--select * from col_art_archivo_tal_preesp_mora WHERE per_codigo = @codper
	END


	--MAESTRIAS
	IF @car_codtde = 2
	BEGIN
		print 'Maestrias'
		declare @codcil_mae_mora int
		--select * from col_art_archivo_tal_mae_mora
		select @codcil_mae_mora = min(ciclo) from col_art_archivo_tal_mae_mora where per_codigo = @codper
		--select @codcil_mae_mora = min(ciclo) from col_art_archivo_tal_mae_mora where per_codigo = @codper
		if (@codcil <> @codcil_mae_mora)
		begin
			print 'El estudiante es de graduacion, ya que no inscribio materias en el ciclo que paga las cuotas'
			set @codcil = @codcil_mae_mora
		end

		--select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
		--art.tmo_arancel, art.fel_fecha_mora, Min(art.ciclo) as ciclo, art.mciclo, tmo.tmo_descripcion
		--from col_art_archivo_tal_mae_mora as art
		--inner join alumnos_por_arancel_maestria as apama on apama.codcil = art.ciclo and apama.per_codigo = art.per_codigo
		--inner join col_fel_fechas_limite_mae_mora as fel on fel.fel_codcil = apama.codcil and fel.fel_codtmo = apama.tmo_codigo and fel.origen = art.origen
		--inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_arancel = art.tmo_arancel
		--where apama.per_codigo = @codper 
		--and tmo.tmo_arancel not in (
		--		SELECT tmo_arancel 
		--		FROM col_mov_movimientos 
		--		join col_dmo_det_mov on dmo_codmov = mov_codigo
		--		join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
		--		WHERE 
		--		mov_codper = @codper 
		--		and dmo_codcil >= @codcil--ciclo--MAX(art.ciclo)
		--	)
		--and apama.codcil >= @codcil
		---- EXEC sp_cuotas_estudiantes_maestrias 3,188459
		--GROUP BY art.per_codigo, art.per_carnet, art.per_nombres_apellidos, art.tmo_arancel,
		--art.fel_fecha_mora, art.mciclo, tmo.tmo_descripcion

		

			select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
				art.tmo_arancel, art.fel_fecha_mora,-- MAX(art.ciclo) as ciclo, 
				art.ciclo, art.mciclo, t.tmo_descripcion, --art.tmo_valor as Monto
				--case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end as Monto, 
				case when art.fel_fecha_mora >= getdate() then art.cuota_pagar else art.cuota_pagar_mora end as Monto, 
				NPE
			from col_art_archivo_tal_mae_mora as art inner join alumnos_por_arancel_maestria as apama on apama.codcil = art.ciclo and apama.per_codigo = art.per_codigo
				inner join col_fel_fechas_limite_mae_mora as fel on fel.fel_codcil = apama.codcil and fel.fel_codtmo = apama.tmo_codigo and fel.origen = art.origen
				inner join col_tmo_tipo_movimiento as t on t.tmo_arancel = art.tmo_arancel
			where cast(art.ciclo as nvarchar(10)) + '-' + t.tmo_arancel not in 
			(
					SELECT cast(dmo_codcil as nvarchar(10)) + '-' + vst.tmo_arancel
					FROM col_mov_movimientos 
					join col_dmo_det_mov on dmo_codmov = mov_codigo
					join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
					join vst_Aranceles_x_Evaluacion as vst on vst.are_codtmo = dmo_codtmo
					WHERE mov_codper = @codper 
					and dmo_codcil >= @codcil--ciclo--MAX(art.ciclo)
					and tde_nombre = 'Maestrias' and mov_estado <> 'A'
				)
			and art.per_codigo = @codper 
			order by art.mciclo asc, art.fel_fecha_mora asc

	END

	
	--POSTGRADO
	IF @car_codtde = 3 or @car_codtde = 6
	BEGIN
		print 'El Alumno es de postgrado - Curso Especializado'
		--select @codcil = min(ciclo) from col_art_archivo_tal_mae_posgrado where per_codigo = @codper
		select @codcil = min(ciclo) from col_art_archivo_tal_mae_mora where per_codigo = @codper
		print '@codcil : ' + cast(@codcil as nvarchar(10))

		select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
			art.tmo_arancel, art.fel_fecha_mora, art.ciclo as ciclo, art.mciclo, tmo.tmo_descripcion, --art.tmo_valor as Monto
			case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end as Monto, NPE
		from col_art_archivo_tal_mae_mora as art
			inner join col_fel_fechas_limite_mae_pg as fel on fel.fel_codcil = art.ciclo 
			inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_arancel = art.tmo_arancel and fel.fel_codtmo = tmo.tmo_codigo
		--select @codcil = min(ciclo) from col_art_archivo_tal_mae_posgrado where per_codigo = @codper
		--print '@codcil : ' + cast(@codcil as nvarchar(10))

		--select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
		--	art.tmo_arancel, art.fel_fecha_mora, art.ciclo as ciclo, art.mciclo, tmo.tmo_descripcion, --art.tmo_valor as Monto
		--	case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end as Monto, NPE
		--from col_art_archivo_tal_mae_posgrado as art
		--inner join alumnos_por_arancel_maestria_posgrado as apamp on apamp.codcil = art.ciclo and apamp.per_codigo = art.per_codigo
		--inner join col_fel_fechas_limite_mae_pg as fel on fel.fel_codcil = apamp.codcil and fel.fel_codtmo = apamp.tmo_codigo --and fel.origen = art.origen
		--inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_arancel = art.tmo_arancel
		where 
		--apamp.per_codigo = @codper
		art.per_codigo = @codper
		and tmo.tmo_arancel not in (
				SELECT tmo_arancel 
				FROM col_mov_movimientos 
				join col_dmo_det_mov on dmo_codmov = mov_codigo
				join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
				WHERE 
				mov_codper = @codper 
				and dmo_codcil = @codcil and mov_estado <> 'A'
		)
		--and apamp.codcil = @codcil
		and art.ciclo = @codcil
		order BY art.fel_fecha_mora asc

		--select * from alumnos_por_arancel_maestria_posgrado where per_codigo = 193884
	END

END