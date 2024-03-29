USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[web_ptl_Alum_solventes]    Script Date: 15/2/2020 08:38:07 ******/
SET ANSI_NULLS on
GO
SET QUOTED_IDENTIFIER on
GO

	-- =============================================
	-- Author:      <>
	-- Create date: <>
	-- Description: <Retorna los alumnos solventes de la materia @codmat seccion @hplsec en el portalUTEC>
	-- =============================================
	-- exec dbo.web_ptl_Alum_solventes 'INT2-E', '01', 3812
	-- exec dbo.web_ptl_Alum_solventes 'FIS1-V', '01', 2436
	-- exec dbo.web_ptl_Alum_solventes 'ALG1-V', '02', 276
	-- exec dbo.web_ptl_Alum_solventes 'STCB-V', '01', 276

ALTER PROCEDURE [dbo].[web_ptl_Alum_solventes]
	@codmat varchar(12), 
	@hplsec int,
	@codemp int 
as
begin
	set dateformat dmy
	declare @ev int, @cuota int,
	@eval varchar(50),
	@codcil int, @cuota_virtual_beca int,
	@are_cuota tinyint
	
	declare @fecha_maxima_prorroga as table (fecha_maxima date)

	declare @temp_listado_autorizados table (
		per_codigo int, carnet varchar(12),
		apellidos varchar(250), nombres varchar(250), 
		ban_nombre varchar(50)
	)

	select @ev = pel_eval from web_ra_pel_periodo_listados  
	where (cast(getdate() as date) >= cast(pel_fechaini as date)) and (cast(getdate() as date) <= cast(pel_fechafin as date))
	print '@ev : '
	print @ev
	print '----------'
	set @cuota=0 
	set @eval=0
   
	select @codcil = cil_codigo from ra_cil_ciclo where cil_vigente = 'S'

	declare @Aranceles_evaluar table (tmo_codigo int)
	set @are_cuota = @ev + 1

	if @ev in (1)
		set @eval='primera'

	if @ev in (2)
		set @eval='segunda'

	if @ev in (3)
		set @eval='tercera'

	if @ev in (4)
		set @eval='cuarta'

	if @ev in (5)
		set @eval='quinta'

	insert into @Aranceles_evaluar (tmo_codigo)
	select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO' and are_cuota = @are_cuota and tde_nombre = 'Pre grado'
	
	--Agregado 17/02/2020 para conocer la fecha maxima
	insert into @fecha_maxima_prorroga (fecha_maxima)
	exec sp_fecha_limite_prorroga 1, @codmat, @hplsec, @codcil, @ev
	--Agregado 17/02/2020

	select top 1 @eval as eval, per.per_carnet as carnet,                    
		hpl.hpl_descripcion as secc, 
		mai.mai_codmat as codmat, 
		emp.emp_apellidos_nombres as empleado, mat.mat_nombre as nommat, 
		esc.esc_nombre as escuela, fac.fac_nombre as facultad, cil.cil_codcic as codcic, 
		cil.cil_anio as anio, aul.aul_nombre_corto as aula, man.man_nomhor as horario, 
		hpl.hpl_lunes as lunes, hpl.hpl_martes as martes, 
		hpl.hpl_miercoles as miercoles, hpl.hpl_jueves as jueves, 
		hpl.hpl_viernes as viernes, hpl.hpl_sabado as sabado, 
		hpl.hpl_domingo as domingo
	from ra_fac_facultades as fac
		inner join ra_esc_escuelas as esc on fac.fac_codigo = esc.esc_codfac 
		inner join ra_per_personas as per
		inner join ra_ins_inscripcion as ins on per.per_codigo = ins.ins_codper 
		inner join ra_mai_mat_inscritas as mai on ins.ins_codigo = mai.mai_codins 
		inner join ra_hpl_horarios_planificacion as hpl on mai.mai_codhpl = hpl.hpl_codigo 
		inner join ra_cil_ciclo as cil on ins.ins_codcil = cil.cil_codigo 
		inner join ra_aul_aulas as aul on hpl.hpl_codaul = aul.aul_codigo 
		inner join ra_man_grp_hor as man on hpl.hpl_codman = man.man_codigo 
		inner join ra_mat_materias as mat on mai.mai_codmat = mat.mat_codigo on esc.esc_codigo = mat.mat_codesc 
		inner join pla_emp_empleado as emp on hpl.hpl_codemp = emp.emp_codigo
	where hpl_codcil = @codcil and (hpl.hpl_codmat = @codmat) 
	and (hpl.hpl_descripcion = @hplsec) and (hpl.hpl_codemp = @codemp)

	insert into @temp_listado_autorizados
	select distinct per_codigo, carnet, apellidos, nombres, ban_nombre
	from (
		select distinct per.per_codigo, per.per_carnet as carnet, per.per_apellidos as apellidos, 
			per.per_nombres as nombres, substring(isnull(ban_nombre, 'UTEC'), 1, 10) ban_nombre
		from ra_ins_inscripcion as ins
			inner join ra_mai_mat_inscritas as mai
			inner join ra_mat_materias as mat on mai.mai_codmat = mat.mat_codigo on  ins.ins_codigo = mai.mai_codins 
			inner join col_mov_movimientos as mov
			inner join col_dmo_det_mov as dmo on dmo.dmo_codmov = mov.mov_codigo 
			inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo.dmo_codtmo 
			inner join ra_per_personas as per on mov.mov_codper = per.per_codigo on ins.ins_codper = per.per_codigo 
			inner join ra_fac_facultades as fac
			inner join ra_esc_escuelas as esc on fac.fac_codigo = esc.esc_codfac on mat.mat_codesc = esc.esc_codigo 
			inner join ra_hpl_horarios_planificacion as hpl on mai.mai_codhpl = hpl.hpl_codigo 
			inner join pla_emp_empleado as emp on hpl.hpl_codemp = emp.emp_codigo 
			inner join ra_cil_ciclo as cil on ins.ins_codcil = cil.cil_codigo and dmo.dmo_codcil = cil.cil_codigo 
			inner join ra_man_grp_hor as man on hpl.hpl_codman = man.man_codigo 
			inner join ra_aul_aulas as aul on hpl.hpl_codaul = aul.aul_codigo 
			left outer join adm_ban_bancos on ban_codigo = mov_codban 
		where hpl_codcil = @codcil and (mov.mov_estado <> 'A') and (mai.mai_codmat = @codmat) 
		and (hpl.hpl_descripcion = @hplsec)  
		and tmo.tmo_codigo in 
		(select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO' and  spaet_codigo = @ev and are_tipoarancel = 'Men')
		and (emp.emp_codigo = @codemp) and dmo_codcil = @codcil and mai_estado <> 'R'

		union all

		select per_codigo, per_carnet as carnet,per_apellidos as apellidos,per_nombres as nombres,'Prórroga' ban_nombre
		from ra_per_personas join ra_ins_inscripcion on ins_codper = per_codigo
		join ra_mai_mat_inscritas on mai_codins = ins_codigo
		join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
		join ra_pra_prorroga_acad on pra_codper = per_codigo
		join ra_man_grp_hor on hpl_codman=man_codigo
		where ins_codcil = @codcil and pra_codcil = @codcil
		and hpl_codmat = @codmat and hpl_descripcion = @hplsec and hpl_codemp = @codemp
		and exists  (
			select 1 from ra_pra_prorroga_acad 
			where pra_codper = ins_codper and pra_codcil = @codcil and pra_codtmo in
			(select tmo_codigo from @Aranceles_evaluar)
		)
		and mai_estado <> 'R'
		and convert(datetime, convert(varchar,pra_fecha,103),103)<= (select fecha_maxima from @fecha_maxima_prorroga)
	) T
	order by T.apellidos
	select carnet, apellidos,nombres,ban_nombre from @temp_listado_autorizados
	union all
	select distinct per_carnet as carnet,per_apellidos as apellidos,per_nombres as nombres,'Autorizado' ban_nombre
	from ra_aan_activar_alumno_notas
		join ra_ins_inscripcion on ins_codper = aan_codper and ins_codcil = @codcil
		join ra_per_personas on per_codigo = ins_codper
		join ra_mai_mat_inscritas on mai_codins = ins_codigo
		join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
	where aan_codper=ins_codper and aan_codcil=@codcil and aan_periodo=@ev and hpl_codmat = @codmat 
	and hpl_descripcion=@hplsec and aan_codper not in (select per_codigo from @temp_listado_autorizados)
	order by apellidos
end