-- 3318 carlos.campos
-- 4108 rene.rodriguez
-- 246 carlos.pineda
--https://dinpruebas.utec.edu.sv/uonlinetres/privado/reportes.aspx?reporte=rep_pg_list_alum_solv_insol&filas=5&campo0=119&campo1=612&campo2=01&campo3=3&campo4=S
select pre_codigo as precod, pre_nombre as prenom, apr_codigo as codmpre, mpr_codigo, mpr_nombre as materia, emp_nombres_apellidos as emple, ra_cil_ciclo.cil_codigo,hmp_descripcion as seccion,
concat(cic_nombre, '-', cil_anio) as ciclo, 0 'comun'
from pg_apr_aut_preespecializacion 
inner join pg_hmp_horario_modpre on apr_codigo = hmp_codapr 
inner join pla_emp_empleado on hmp_codcat = emp_codigo 
inner join pg_pre_preespecializacion on apr_codpre = pre_codigo 
inner join pg_mpr_modulo_preespecializacion on pre_codigo = mpr_codpre and hmp_codmpr = mpr_codigo 
inner join ra_cil_ciclo on pre_codcil = ra_cil_ciclo.cil_codigo 
inner join ra_cic_ciclos on cil_codcic = cic_codigo
where cil_vigente_pre = 'S' and hmp_codcat = 4108
union all
select 0 precod,'general' as prenom,hm_codigo as codmpre, hm_codigo, hm_nombre_mod as materia,emp_nombres_apellidos as emple, cil_codigo,hm_descripcion as seccion,
concat(cic_nombre, '-', cil_anio) as ciclo, 1 'comun'
from pg_hm_horarios_mod 
join pla_emp_empleado on hm_codemp = emp_codigo
join ra_cil_ciclo on cil_codigo = hm_codcil
join ra_cic_ciclos on cic_codigo = cil_codcic
where cil_vigente_pre = 'S' and hm_codemp = 4108




alter procedure[dbo].[rep_pg_list_alum_solvinsol] 
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-09-10 16:08:44.440>
	-- Description: <Devuelve el listado de alumnos solventes o insolventes de los modulos comunes o especializes de la pre especialidad>
	-- =============================================
	-- rep_pg_list_alum_solvinsol 119, 612, '01', 3, 'S', 0 --Habilidades Gerenciales
	-- rep_pg_list_alum_solvinsol 119, 495, '', 0, 'S', 1 --Liderazgo basado en principios
	@codcil int,
	@codpre int,
	@seccion varchar(2),
	@evaluacion int,
	@tipo_listado char(1),
	@comun int
as
begin
	set dateformat dmy
	--declare @conteo_pre int
	--select @conteo_pre = count(1) from pg_hm_horarios_mod where hm_codigo = @codpre and hm_descripcion = @seccion  and hm_codcil = @codcil

	if(@comun = 0) -- NO SON MODULOS COMUNES
	begin
		print 'NO SON MODULOS COMUNES O ESPECIALES'

		select top 1 concat('0', cil_codcic, '-', cil_anio), stuff(
			(
			select concat(case dhm_dia when 1 then '-Lu' when 2 then '-Ma' when 3 then '-Mi' when 4 then '-Ju' when 5 then '-Vi' when 6 then '-Sa' when 7 then '-Do' end, '')
			from pg_apr_aut_preespecializacion
				join  pg_hmp_horario_modpre on hmp_codapr = apr_codigo
				join pg_mpr_modulo_preespecializacion on mpr_codigo = hmp_codmpr
				join ra_cil_ciclo on apr_codcil = cil_codigo
				join pg_dhm_det_hor_hmp on dhm_codhmp = hmp_codigo
				join ra_man_grp_hor on man_codigo = dhm_codman
			where apr_codpre = 612 and apr_codcil = 119 and  /*mpr_orden = 3 and*/ hmp_descripcion = '01' --and mpr_visible = 'S'
			for xml path('')
			)
		, 1, 1, '') 'dias', '' 'escuela', apr_codpre 'codigo', man_nomhor, aul_nombre_corto, hmp_descripcion, emp_nombres_apellidos, mpr_codigo, mpr_nombre, *
		--select *
		from pg_apr_aut_preespecializacion
			join pg_hmp_horario_modpre on hmp_codapr = apr_codigo
			join pg_mpr_modulo_preespecializacion on mpr_codigo = hmp_codmpr
			join ra_cil_ciclo on apr_codcil = cil_codigo
			join pg_dhm_det_hor_hmp on dhm_codhmp = hmp_codigo
			join ra_man_grp_hor on man_codigo = dhm_codman
			join ra_aul_aulas on aul_codigo = dhm_aula
			join pg_pre_preespecializacion on pre_codigo = mpr_codpre
			left join pla_emp_empleado on emp_codigo = hmp_codcat
		where apr_codpre = 612 and apr_codcil = 119 and  /*mpr_orden = 3 and*/ hmp_descripcion = '01' --and mpr_visible = 'S'
		
		select * from pg_pre_preespecializacion
		inner join pg_mpr_modulo_preespecializacion on pre_codigo = mpr_codpre
		inner join pg_apr_aut_preespecializacion on pre_codigo = apr_codpre
		join pg_hmp_horario_modpre on hmp_codapr = apr_codigo

		where pre_codigo = 612 and apr_codcil = 119 and hmp_descripcion = '01'

		/*
		select * from pg_mpr_modulo_preespecializacion where mpr_codpre = 612
		select * from pg_dhm_det_hor_hmp
		select * from pg_hm_horarios_mod*/
		--where apr_codpre = @codpre and apr_codcil = @codcil and  mpr_orden = @evaluacion and hmp_descripcion = @seccion and mpr_visible = 'S'

		declare @orden int, @proceso int, @cantidad int, @fecha date, @codhmp int
		select @fecha = convert(date,femp_fecha), @codhmp = femp_codhmp from prees_femp_fechasExamenes_ModuloPrees 
		where femp_codhmp = (
		select hmp_codigo from pg_apr_aut_preespecializacion
			join  pg_hmp_horario_modpre on hmp_codapr = apr_codigo
			join pg_mpr_modulo_preespecializacion on mpr_codigo = hmp_codmpr
		where apr_codpre = @codpre and apr_codcil = @codcil and  mpr_orden = @evaluacion and hmp_descripcion = @seccion and mpr_visible = 'S'
		) and femp_codcil = @codcil

		print '@fecha: ' + cast(@fecha as nvarchar(20))
		print '@codhmp: ' + cast(@codhmp as nvarchar(20))
		print '------------------------------------------------------'

		select @proceso = cil_codcic from ra_cil_ciclo where cil_codigo = @codcil
		print '@proceso: '+cast(@proceso as nvarchar(10))
		print '------------------------------------------------------'

		select @orden = orar_orden from pg_orar_orden_aracenles 
		where orar_codtmo = (select top 1 arev_codtmo from pg_arev_aranceles_x_evaluacion where arev_evaluacion = @evaluacion and arev_proceso = @proceso)
		print '@orden: '+cast(@orden as nvarchar(10)) 
		print '------------------------------------------------------'

		select @cantidad =  count(1) from pg_orar_orden_aracenles where orar_orden < @orden and orar_beca = 0
		print '@cantidad: '+cast(@cantidad as nvarchar(10)) 
		print '------------------------------------------------------'

		--select * from pg_orar_orden_aracenles where orar_orden < @orden and orar_beca = 0

		declare  @cuotaeval table (codper int)

		insert into @cuotaeval(codper)
		select distinct per_codigo 
		from (
				select distinct per_codigo from ra_per_personas
				join pg_imp_ins_especializacion on imp_codper = per_codigo
				join pg_apr_aut_preespecializacion on apr_codigo = imp_codapr
				join pg_pre_preespecializacion on pre_codigo = apr_codpre
				join pg_hmp_horario_modpre on hmp_codapr = apr_codigo and hmp_codigo = imp_codhmp
				join ra_cil_ciclo on cil_codigo = apr_codcil 
				join ra_cic_ciclos on cic_codigo = cil_codcic
				join col_mov_movimientos on mov_codper = per_codigo
				join col_dmo_det_mov on dmo_codmov = mov_codigo
				join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
				join pg_arev_aranceles_x_evaluacion on arev_codtmo = tmo_codigo
				where  apr_codcil = @codcil and pre_codigo = @codpre and hmp_descripcion = @seccion and dmo_codcil = @codcil
				and  arev_evaluacion = @evaluacion and arev_proceso = @proceso and 
				mov_estado <> 'A' and (CONVERT(date,mov_fecha_cobro) <= @fecha) 
				union
				select distinct per_codigo
				from vst_alumnos_prorroga_prees
					join pg_arev_aranceles_x_evaluacion on arev_codtmo = tmo_codigo
				where arev_evaluacion = @evaluacion and arev_proceso = @proceso
					and cil_codigo = @codcil and pre_codigo = @codpre and hmp_descripcion = @seccion
		)b

		declare @solventes table (
			per_codigo int,per_carnet nvarchar(12),per_apellidos_nombres nvarchar(150),
			cuotasc int,ciclo nvarchar(25), pre_nombre nvarchar(200),
			hmp_descripcion nvarchar(4), estado nvarchar(20)
		)

		insert into @solventes(per_codigo,per_carnet,per_apellidos_nombres,cuotasc,ciclo,pre_nombre,hmp_descripcion, estado)
		select  per_codigo,per_carnet,per_apellidos_nombres,1 cuotasc,ciclo,pre_nombre,hmp_descripcion,estado
		from (
			select distinct per_codigo,per_carnet,per_apellidos_nombres,cic_nombre+'-'+cast(cil_anio as varchar(4)) ciclo,
				pre_nombre,hmp_descripcion,'Solventes' estado
				, tmo_codigo, tmo.tmo_arancel, tmo.tmo_descripcion
			from
			ra_per_personas
			join pg_imp_ins_especializacion on imp_codper = per_codigo
			join pg_apr_aut_preespecializacion on apr_codigo = imp_codapr
			join pg_pre_preespecializacion on pre_codigo = apr_codpre
			join pg_hmp_horario_modpre on hmp_codapr = apr_codigo and hmp_codigo = imp_codhmp
			join ra_cil_ciclo on cil_codigo = apr_codcil 
			join ra_cic_ciclos on cic_codigo = cil_codcic
			join col_mov_movimientos on mov_codper = per_codigo
			join col_dmo_det_mov on dmo_codmov = mov_codigo
			join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
			join vst_Aranceles_x_Evaluacion as tmo on tmo.are_codtmo = tmo_codigo
			where  apr_codcil = @codcil and pre_codigo = @codpre and hmp_descripcion = @seccion 
				--and per_codigo = 172983
		) a
		where per_codigo in(select codper from @cuotaeval)
		group by per_codigo,per_carnet,per_apellidos_nombres,ciclo,estado,pre_nombre,hmp_descripcion
		having count(per_codigo) >= @cantidad 
		--select * from @cuotaeval
		print '@codcil: '+ cast(@codcil as varchar(50))+ ', @codpre: ' + cast(@codpre as varchar(50)) + ', @seccion: ' + cast(@seccion as varchar(50))-- + ', @codcil: ' + cast(@codcil as varchar(50))
		--rep_pg_list_alum_solv_insol 117, 597, '01', 1, 'S'

		if(@tipo_listado = 'S')
		begin
			PRINT 'ENTRA SOLVENTES'
			select * from @solventes
		end -- if(@tipo_listado = 'S')

		if(@tipo_listado = 'I')
		begin
			PRINT 'ENTRA INSOLVENTES'
			select distinct per_codigo,per_carnet,per_apellidos_nombres,0 cuotasc,cic_nombre+'-'+cast(cil_anio as varchar(4)) ciclo,
				pre_nombre,hmp_descripcion,'Insolventes' estado 
			from
				col_mov_movimientos 
				join col_dmo_det_mov ON col_dmo_det_mov.dmo_codmov = col_mov_movimientos.mov_codigo 
				join col_tmo_tipo_movimiento ON col_tmo_tipo_movimiento.tmo_codigo = col_dmo_det_mov.dmo_codtmo 
				join ra_per_personas ON col_mov_movimientos.mov_codper = ra_per_personas.per_codigo 
				join pg_imp_ins_especializacion on imp_codper = per_codigo
				join pg_apr_aut_preespecializacion on apr_codigo = imp_codapr
				join pg_pre_preespecializacion on pre_codigo = apr_codpre
				join pg_hmp_horario_modpre on hmp_codapr = apr_codigo and hmp_codigo = imp_codhmp
				join ra_cil_ciclo on cil_codigo = apr_codcil 
				join ra_cic_ciclos on cic_codigo = cil_codcic
			where per_codigo not in(select sol.per_codigo from @solventes sol) 
				and apr_codcil = @codcil and pre_codigo = @codpre and hmp_descripcion = @seccion
			order by per_apellidos_nombres
		end -- if(@tipo_listado = 'I')

		if(@tipo_listado = 'D')--D: Los que han pagado el diferido
		begin
			PRINT 'ENTRA DIFERIDOS'
			select distinct per_codigo,per_carnet,per_apellidos_nombres,0 cuotasc,cic_nombre+'-'+cast(cil_anio as varchar(4)) ciclo,
				pre_nombre,hmp_descripcion, col_tmo_tipo_movimiento.tmo_arancel--,'Insolventes' estado 
			from
				col_mov_movimientos 
				join col_dmo_det_mov ON col_dmo_det_mov.dmo_codmov = col_mov_movimientos.mov_codigo 
				join col_tmo_tipo_movimiento ON col_tmo_tipo_movimiento.tmo_codigo = col_dmo_det_mov.dmo_codtmo 
				join ra_per_personas ON col_mov_movimientos.mov_codper = ra_per_personas.per_codigo 
				join pg_imp_ins_especializacion on imp_codper = per_codigo
				join pg_apr_aut_preespecializacion on apr_codigo = imp_codapr
				join pg_pre_preespecializacion on pre_codigo = apr_codpre
				join pg_hmp_horario_modpre on hmp_codapr = apr_codigo and hmp_codigo = imp_codhmp
				join ra_cil_ciclo on cil_codigo = apr_codcil 
				join ra_cic_ciclos on cic_codigo = cil_codcic
			where per_codigo not in(select sol.per_codigo from @solventes sol) 
				and apr_codcil = @codcil and pre_codigo = @codpre and hmp_descripcion = @seccion
				and col_tmo_tipo_movimiento.tmo_arancel = 'S-05' and dmo_eval <> 0--S-05: Examen Extraordinario
			union all
			select distinct per_codigo,per_carnet,per_apellidos_nombres,0 cuotasc,cic_nombre+'-'+cast(cil_anio as varchar(4)) ciclo,
				pre_nombre,hmp_descripcion, col_tmo_tipo_movimiento.tmo_arancel--,'Insolventes' estado 
			from
				col_mov_movimientos 
				join col_dmo_det_mov ON col_dmo_det_mov.dmo_codmov = col_mov_movimientos.mov_codigo 
				join col_tmo_tipo_movimiento ON col_tmo_tipo_movimiento.tmo_codigo = col_dmo_det_mov.dmo_codtmo 
				join ra_per_personas ON col_mov_movimientos.mov_codper = ra_per_personas.per_codigo 
				join pg_imp_ins_especializacion on imp_codper = per_codigo
				join pg_apr_aut_preespecializacion on apr_codigo = imp_codapr
				join pg_pre_preespecializacion on pre_codigo = apr_codpre
				join pg_hmp_horario_modpre on hmp_codapr = apr_codigo and hmp_codigo = imp_codhmp
				join ra_cil_ciclo on cil_codigo = apr_codcil 
				join ra_cic_ciclos on cic_codigo = cil_codcic
			where per_codigo in(select sol.per_codigo from @solventes sol) 
				and apr_codcil = @codcil and pre_codigo = @codpre and hmp_descripcion = @seccion
				and col_tmo_tipo_movimiento.tmo_arancel = 'S-05' and dmo_eval <> 0 --S-05: Examen Extraordinario
			order by per_apellidos_nombres
			end
	end
	else if (@comun = 1) -- SON MODULOS COMUNES
	begin
		--MOSTRAR LOS SOLVENTES O INSOLVENTES DE LOS MODULOS COMUNES
		print 'SON MODULOS COMUNES O ESPECIALES'
		select distinct per_carnet as carnet,per_nombres,per_apellidos,'General' as pre_nombre,hm_descripcion,hm_nombre_mod as nombremat,hm_codigo as pre_codigo, hm_codemp,
		emp_nombres_apellidos as profe,hm_descripcion as hpl_descripcion,
		'0'+CAST(cil_codcic AS varchar(2)) + ' - ' + cast(cil_anio as varchar(4)) AS ciclo,
		case when hm_lunes = 'S' then 'Lu-' ELSE '' END + 
		case when hm_martes = 'S' then 'Ma-' ELSE '' END + 
		case when hm_miercoles = 'S' then 'Mie-' ELSE '' END + 
		case when hm_jueves = 'S' then 'Jue-' ELSE '' END + 
		case when hm_viernes = 'S' then 'Vie-' ELSE '' END + 
		case when hm_sabado = 'S' then 'Sab-' ELSE '' END + 
		case when hm_domingo = 'S' then 'Dom-' ELSE '' END dias,
		man_nomhor as hora, aul_nombre_corto as aula, cil_codcic as ciclo, cil_anio as anio
		from pg_insm_inscripcion_mod join ra_per_personas on per_codigo = insm_codper
		join pg_hm_horarios_mod on hm_codigo = insm_codhm
		join ra_cil_ciclo on cil_codigo = insm_codcil
		join ra_aul_aulas on aul_codigo = hm_codaul
		join ra_man_grp_hor on man_codigo = hm_codman
		left outer join pla_emp_empleado on emp_codigo = hm_codemp
		where insm_codcil = @codcil and hm_codigo = @codpre 
		order by per_apellidos
	end
end