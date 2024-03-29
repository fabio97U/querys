USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[web_ptl_Alum_solventes_actividades]    Script Date: 15/2/2020 20:04:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[web_ptl_Alum_solventes_actividades]
    -- =============================================
    -- Author:      <Fabio>
    -- Create date: <2019-09-12 10:12:15.777>
    -- Description: <Este procedimiento devuelve la data de los alumnos que estan solventes para las actividades>
    -- =============================================
    --web_ptl_Alum_solventes_actividades 'INT2-E', '01', 3812, 122, 'Actividades', 'Pregrado'
    --web_ptl_Alum_solventes_actividades 'FIS1-V', '01', 2436, 122, 'Actividades', 'Pregrado'

    --web_ptl_Alum_solventes_actividades 'ALG1-V', '02', 276, 122, 'Actividades', 'Pregrado'
    --web_ptl_Alum_solventes_actividades 'STCB-V', '02', 276, 122, 'Actividades', 'Pregrado'
    @codmat varchar(12), 
    @hplsec int,
    @codemp int,
    @codcil int,
    @penot_periodo varchar(25),
    @penot_tipo varchar(25)
as
begin
    set dateformat dmy
    declare @ev int = 0, @cuota int = 0, @cuota_beca int, @eval varchar(50) = 0,
	@are_cuota tinyint

    declare @temp_listado_autorizados table(
		per_codigo int, carnet varchar(12),
		apellidos varchar(250), nombres varchar(250), 
		ban_nombre varchar(50)
	)

	declare @fecha_maxima_prorroga as table (fecha_maxima date)

    select @ev=penot_eval from web_ra_not_penot_periodonotas  
    where (cast(getdate() as date) >= cast(penot_fechaini as date)) 
	and (cast(getdate() as date) <= cast(penot_fechafin as date)) and penot_periodo = @penot_periodo and penot_tipo = @penot_tipo

    print '@ev: ' + cast(@ev as varchar(2))
    print '----------'

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

    insert into @temp_listado_autorizados
    select distinct per_codigo, carnet, apellidos, nombres, ban_nombre
    from
    (
		select distinct per.per_codigo, per.per_carnet as carnet, per.per_apellidos as apellidos, 
						per.per_nombres as nombres, substring(isnull(ban_nombre,'UTEC'),1,10) ban_nombre
		from ra_ins_inscripcion 
			inner join ra_mai_mat_inscritas as mai
			inner join ra_mat_materias as mat on mai.mai_codmat = mat.mat_codigo on ra_ins_inscripcion.ins_codigo = mai.mai_codins 
			inner join col_mov_movimientos as mov
			inner join col_dmo_det_mov as dmo on dmo.dmo_codmov = mov.mov_codigo 
			inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo.dmo_codtmo 
			inner join ra_per_personas as per on mov.mov_codper = per.per_codigo on  ra_ins_inscripcion.ins_codper = per.per_codigo 
			inner join ra_fac_facultades as fac
			inner join ra_esc_escuelas as esc on fac.fac_codigo = esc.esc_codfac on mat.mat_codesc = esc.esc_codigo 
			inner join ra_hpl_horarios_planificacion as hpl on mai.mai_codhpl = hpl.hpl_codigo 
			inner join pla_emp_empleado as emp on hpl.hpl_codemp = emp.emp_codigo 
			inner join ra_cil_ciclo as cil on ra_ins_inscripcion.ins_codcil = cil.cil_codigo and dmo.dmo_codcil = cil.cil_codigo 
			inner join ra_man_grp_hor as man on hpl.hpl_codman = man.man_codigo 
			inner join ra_aul_aulas as aul on hpl.hpl_codaul = aul.aul_codigo 
			left outer JOIN adm_ban_bancos as ban on ban_codigo = mov_codban 
		where hpl_codcil = @codcil and (mov.mov_estado <> 'A') 
		and (mai.mai_codmat = @codmat) and 
		(hpl.hpl_descripcion = @hplsec) 
			and tmo.tmo_codigo in ( select are_codtmo from vst_Aranceles_x_Evaluacion 
			where are_tipo = 'PREGRADO' and  spaet_codigo = @ev and are_tipoarancel = 'Men')
			and (emp.emp_codigo = @codemp) and dmo_codcil = @codcil
		and mai_estado <> 'R'
		union all

		select per_codigo, per_carnet as carnet,per_apellidos as apellidos,per_nombres as nombres,'Prórroga' ban_nombre
		from ra_per_personas 
			join ra_ins_inscripcion on ins_codper = per_codigo
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
		and  convert(datetime,convert(varchar,pra_fecha,103),103)<= (select fecha_maxima from @fecha_maxima_prorroga)

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
    where aan_codper=ins_codper and aan_codcil = @codcil and aan_periodo = @ev and hpl_codmat = @codmat and hpl_descripcion=@hplsec and 
		aan_codper not in (select per_codigo from @temp_listado_autorizados)
    order by apellidos
end
