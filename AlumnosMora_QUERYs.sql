--select * from col_tmo_tipo_movimiento where tmo_arancel in ('C-30', 'E-04', 'A-14')

--select * from col_mov_movimientos 
--	inner join col_dmo_det_mov on dmo_codmov = mov_codigo --and dmo_codcil = mov_codcil
--	inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo_codtmo 
--	inner join ra_per_personas on mov_codper = per_codigo
--	inner join graduados_BORRAME on per_carnet = carnet_excel
--where dmo_codtmo = 162 and dmo_abono < 0 

----drop table graduados_BORRAME
--create table graduados_BORRAME(
--	ID int primary key identity (1, 1),
--	numero_excel int,
--	carnet_excel varchar(16),
--	nombres_excel varchar(255),
--	FECHA_HORA_CREACION datetime default getdate()
--)
----select * from graduados_BORRAME


	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-10-02T18:25:29.7216918-06:00>
	-- Description: <Indica si un alumno tiene cuotas pendientes en alguno de sus ciclos de estudio, 
	-- tanto en pregrado como en la preespecialidad, Columna respuesta: /*0: no debe, 1: debe alguna cuota*/>
	-- =============================================
	-- exec sp_alumno_debe_cuotas 1, 182268	--debe cuotas
	-- exec sp_alumno_debe_cuotas 1, 170784	--no debe cuotas
	-- exec sp_alumno_debe_cuotas 1, 197851 --debe cuotas pregrado
alter procedure sp_alumno_debe_cuotas 
	@opcion int = 0,
	@codper int = 0
as
begin

	set dateformat dmy

	if @opcion = 1
	begin
		declare @codcils_estudiados as table (codcil int)
		declare @codcil_pre int 

		declare @ciclos_cuotas_pagadas as table (
			codcil int, ciclo varchar(16), 
			cant_cuotas_pagadas int, retiro_ciclo int, 
			valor_cuotas real, cant_cuotas_debe int,
			tipo varchar(16),
			exoneracion_ciclo int, c_30_negativo int,
			pago_a14 real
		)

		declare @respuesta int = 0 /*0: no debe, 1: debe alguna cuota*/, @observaciones varchar(1024) = 'No debe ninguna cuota', @saldo_pendiente real = 0
		declare @hasta_la_cuota varchar(50) = '', @del_ciclo varchar(16) = ''

		declare @carnet varchar(16), @per_nombres_apellidos varchar(255)
		select @carnet = per_carnet, @per_nombres_apellidos = per_nombres_apellidos 
		from ra_per_personas where per_codigo = @codper

		insert into @codcils_estudiados (codcil)
		select distinct ins_codcil from ra_ins_inscripcion
		inner join ra_cil_ciclo on cil_codigo = ins_codcil
		inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
		where ins_codper = @codper and cil_codcic <> 3 and mai_estado = 'I'
		
		select distinct @codcil_pre = apr_codcil 
		from pg_imp_ins_especializacion 
			inner join pg_apr_aut_preespecializacion on apr_codigo = imp_codapr
		where imp_codper = @codper and imp_estado = 'I'
		print '@codcil_pre: ' + cast (@codcil_pre as varchar(5))
		
		insert into @ciclos_cuotas_pagadas 
		(codcil, ciclo, cant_cuotas_pagadas, retiro_ciclo, valor_cuotas, cant_cuotas_debe, tipo, exoneracion_ciclo, c_30_negativo, pago_a14)
		select dmo_codcil, ciclo, cant_cuotas_pagadas, pago_retiro_ciclo, valor_cuotas, cant_cuotas - cant_cuotas_pagadas, tipo,
		exoneracion_ciclo, c_30_negativo, pago_a14
		from (
			select dmo_codcil, concat('0', cil_codcic, '-', cil_anio) 'ciclo', count(1) 'cant_cuotas_pagadas',
			(
				select count(1) from col_mov_movimientos 
					inner join col_dmo_det_mov on dmo_codmov = mov_codigo --and dmo_codcil = mov_codcil
					inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo_codtmo 
				where mov_codper = @codper
				and dmo_codcil in (dmo.dmo_codcil) and dmo_codtmo = 854
			) 'pago_retiro_ciclo',
			isnull((
				select max(dmo_abono) from col_mov_movimientos 
					inner join col_dmo_det_mov on dmo_codmov = mov_codigo --and dmo_codcil = mov_codcil
					inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo_codtmo 
					inner join vst_Aranceles_x_Evaluacion as vst on vst.are_codtmo = tmo.tmo_codigo and vst.tmo_arancel = tmo.tmo_arancel
				where mov_codper = @codper
				and dmo_codcil in (dmo.dmo_codcil) and tmo.tmo_descripcion like '%cuota%' and dmo_abono > 0  and mov_estado <> 'A'
			), 0) 'valor_cuotas',
			'PREGRADO' 'tipo',
			7 cant_cuotas,
			(
				select count(1) from col_mov_movimientos 
					inner join col_dmo_det_mov on dmo_codmov = mov_codigo --and dmo_codcil = mov_codcil
					inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo_codtmo 
				where mov_codper = @codper
				and dmo_codcil in (dmo.dmo_codcil) and dmo_codtmo = 335  and mov_estado <> 'A'
			) 'exoneracion_ciclo',
			(
				select count(1) from col_mov_movimientos 
					inner join col_dmo_det_mov on dmo_codmov = mov_codigo --and dmo_codcil = mov_codcil
					inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo_codtmo 
				where mov_codper = @codper
				and dmo_codcil in (dmo.dmo_codcil) and dmo_codtmo = 162 and dmo_abono < 0  and mov_estado <> 'A'
			) 'c_30_negativo',
			(
				select isnull(sum(dmo_abono), 0) from col_mov_movimientos 
					inner join col_dmo_det_mov on dmo_codmov = mov_codigo --and dmo_codcil = mov_codcil
					inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo_codtmo 
				where mov_codper = @codper
				and dmo_codcil in (dmo.dmo_codcil) and dmo_codtmo = 14
			) 'pago_a14'
			from col_mov_movimientos 
				inner join col_dmo_det_mov as dmo on dmo_codmov = mov_codigo --and dmo_codcil = mov_codcil
				inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo_codtmo 
				inner join vst_Aranceles_x_Evaluacion as vst on vst.are_codtmo = tmo.tmo_codigo and vst.tmo_arancel = tmo.tmo_arancel
				inner join ra_cil_ciclo on cil_codigo = dmo_codcil
			where dmo_codcil in (select codcil from @codcils_estudiados) and mov_codper = @codper and mov_estado <> 'A'
			group by dmo_codcil, cil_codcic, cil_anio

			union all 

			select dmo_codcil, concat('0', cil_codcic, '-', cil_anio) 'ciclo', count(1) 'cant_cuotas_pagadas',
			-1 'pago_retiro_ciclo',
			isnull((
				select max(dmo_abono) from col_mov_movimientos 
					inner join col_dmo_det_mov on dmo_codmov = mov_codigo --and dmo_codcil = mov_codcil
					inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo_codtmo 
					inner join vst_Aranceles_x_Evaluacion as vst on vst.are_codtmo = tmo.tmo_codigo and vst.tmo_arancel = tmo.tmo_arancel
				where mov_codper = @codper
				and dmo_codcil in (@codcil_pre) and tmo.tmo_descripcion like '%cuota%' and dmo_abono > 0  and mov_estado <> 'A'
			), 0) 'valor_cuotas',
			'PREESPECIALIDAD' 'tipo',
			11 cant_cuotas,
			-1 'exoneracion_ciclo', -1 'c_30_negativo',
			(
				-1
			) 'pago_a14'
			from col_mov_movimientos 
				inner join col_dmo_det_mov on dmo_codmov = mov_codigo --and dmo_codcil = mov_codcil
				inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo_codtmo 
				inner join vst_Aranceles_x_Evaluacion as vst on vst.are_codtmo = tmo.tmo_codigo and vst.tmo_arancel = tmo.tmo_arancel
				inner join ra_cil_ciclo on cil_codigo = dmo_codcil
			where dmo_codcil in (@codcil_pre) and mov_codper = @codper and mov_estado <> 'A'
			group by dmo_codcil, cil_codcic, cil_anio
		) t
		order by dmo_codcil asc

		--Inicio: Se asignan las variables @hasta_la_cuota y @del_ciclo
		select @hasta_la_cuota = cant_cuotas_pagadas - 1, @del_ciclo = ciclo 
		from @ciclos_cuotas_pagadas-- where pago_a14 > 0
		if exists (select 1 from @ciclos_cuotas_pagadas where cant_cuotas_debe > 0 and exoneracion_ciclo = 0)
		begin
			select top 1 @hasta_la_cuota = cant_cuotas_pagadas - 1, @del_ciclo = ciclo 
			from @ciclos_cuotas_pagadas where cant_cuotas_debe > 0 and exoneracion_ciclo = 0
		end
		--Fin: Se asignan las variables @hasta_la_cuota y @del_ciclo

		 --select * from @ciclos_cuotas_pagadas-- where pago_a14 > 0

		if exists (select 1 from @ciclos_cuotas_pagadas where cant_cuotas_pagadas < 7 and tipo = 'PREGRADO' and (exoneracion_ciclo  = 0 /*or c_30_negativo = 0*/))
		begin
			set @respuesta = 1
			begin --Se buscan las cuotas pendientes y se coloca la observacion
				select 
				@observaciones = stuff((
					select 
					concat(
						', ', cant_cuotas_debe, ' cuotas por un valor de $', 
						((cant_cuotas_debe * valor_cuotas) - (pago_a14)), ' en el ciclo ', ciclo
					)
					from @ciclos_cuotas_pagadas 
					where cant_cuotas_pagadas < 7 and retiro_ciclo = 0 and tipo = 'PREGRADO'
					and (exoneracion_ciclo  = 0 /*or c_30_negativo = 0*/)
					order by codcil 
					for xml path('')
				, type
				).value('.', 'nvarchar(max)'), 1, 1, '')

				select @saldo_pendiente = sum(cant_cuotas_debe * valor_cuotas) - sum(pago_a14) --- pago_a14
				from @ciclos_cuotas_pagadas
				where cant_cuotas_pagadas < 7 and retiro_ciclo = 0 and tipo = 'PREGRADO'
				and (exoneracion_ciclo  = 0 /*or c_30_negativo = 0*/)

				if @saldo_pendiente = 0
				begin
					set @respuesta = 0
					set @observaciones = 'No debe ninguna cuota'
				end

			end
			--333	E-02 	Equivalencia por Asignatura.
		end
		
		if exists (select 1 from @ciclos_cuotas_pagadas where cant_cuotas_pagadas < 11 and tipo = 'PREESPECIALIDAD')
		begin
			set @respuesta = 1
			begin --Se buscan las cuotas pendientes y se coloca la observacion
				select 
				@observaciones = stuff((
					select 
					concat(
						', ', cant_cuotas_debe, ' cuotas por un valor de $', 
						(cant_cuotas_debe * valor_cuotas), ' en el ciclo ', ciclo
					)
					from @ciclos_cuotas_pagadas 
					where cant_cuotas_pagadas < 11 and tipo = 'PREESPECIALIDAD'
					order by codcil 
					for xml path('')
				, type
				).value('.', 'nvarchar(max)'), 1, 1, '')

				select @saldo_pendiente = sum(cant_cuotas_debe * valor_cuotas)
				from @ciclos_cuotas_pagadas
				where cant_cuotas_pagadas < 11 and tipo = 'PREESPECIALIDAD'
			end
		end
		
		select @codper 'codper', @carnet 'carnet', @per_nombres_apellidos 'per_nombres_apellidos', @respuesta 'respuesta', 
		@observaciones 'observaciones', @saldo_pendiente 'saldo_pendiente', @hasta_la_cuota 'hasta_la_cuota', @del_ciclo 'del_ciclo',
		convert(varchar, getdate(), 103) 'fecha'
		
		--if exists (select 1 from @ciclos_cuotas_pagadas where pago_a14 > 0)
		--begin
		--	select * from @ciclos_cuotas_pagadas --where pago_a14 > 0
		--end

	end

end

	
	

-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-10-05T16:56:25.4588641-06:00>
	-- Description: <Retorna los alumnos solventes (no deben ninguna cuota) o insolventes (deben alguna cuota en toda su carrera)>
	-- =============================================
	-- exec sp_alumnos_mora 1, 120, 1 -- Deben cuotas
	-- exec sp_alumnos_mora 1, 120, 0 -- No Deben cuotas
ALTER procedure [dbo].[sp_alumnos_mora]
	@opcion int = 0,
	@codcil int = 0,
	@respuesta int = 0/*0: muestra todos los no debe, 1: muestra todos lo debe alguna cuota*/
as
begin

	if @opcion = 1
	begin

		declare @tbl_res as table (
			codper int, carnet varchar(16), per_nombres_apellidos varchar(255), 
			respuesta int, observaciones varchar(1024), saldo_pendiente real,
			hasta_la_cuota varchar(50), del_ciclo varchar(16),
			fecha varchar(12)
		)

		declare @codper varchar(12)
		declare m_cursor cursor 
		for
			select per_codigo
			from pg_imp_ins_especializacion
				inner join pg_apr_aut_preespecializacion on imp_codapr = apr_codigo
				inner join pg_mpr_modulo_preespecializacion on mpr_codigo = imp_codmpr
				inner join ra_per_personas on per_codigo = imp_codper

				inner join ra_alc_alumnos_carrera on alc_codper = imp_codper
				inner join ra_pla_planes on pla_codigo = alc_codpla
				inner join ra_car_carreras on car_codigo = pla_codcar
				inner join ra_fac_facultades on fac_codigo = car_codfac
			where apr_codcil = @codcil and imp_estado = 'I' and per_estado = 'E'
			order by fac_nombre, car_nombre, mpr_nombre, per_apellidos

			--select per_codigo from graduados_BORRAME
			--inner join ra_per_personas on per_carnet = carnet_excel --and per_codigo = 196314
			--order by ID

		open m_cursor 
 
		fetch next from m_cursor into @codper
		print '@codper: ' + cast(@codper as varchar(12))
		while @@FETCH_STATUS = 0 
		begin
			insert into @tbl_res 
			(codper, carnet, per_nombres_apellidos, respuesta, observaciones, saldo_pendiente, hasta_la_cuota, del_ciclo, fecha)
			exec sp_alumno_debe_cuotas 1, @codper
			fetch next from m_cursor into @codper
		end      
		close m_cursor  
		deallocate m_cursor

		select * from @tbl_res where respuesta = @respuesta
	end
	
end