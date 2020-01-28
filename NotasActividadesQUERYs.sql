
alter PROCEDURE [dbo].[web_ptl_Alum_solventes_actividades]
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-09-12 10:12:15.777>
	-- Description: <Este procedimiento devuelve la data de los alumnos que estan solventes para las actividades>
	-- =============================================
	--	web_ptl_Alum_solventes_actividades 'ETPS4-T','01',2619, 120, 'Actividades', 'Pregrado'
	--	web_ptl_Alum_solventes_actividades 'ALG2-V','01',276, 120, 'Actividades', 'Pregrado'
	@codmat varchar(12), 
	@hplsec int,
	@codemp int,
	@codcil int,
	@penot_periodo varchar(25),
	@penot_tipo varchar(25)
as
begin
	set dateformat dmy
	declare @ev int, @cuota int, @cuota_beca int, @cuota_wallmart int, @cuota_virtual int, @eval varchar(50), @cil_codigo int, @cuota_virtual_beca int
	
	declare @temp_listado_autorizados table(
		per_codigo int,
		carnet varchar(12),
		apellidos varchar(250), 
		nombres varchar(250), 
		ban_nombre varchar(50))

	select @ev=penot_eval from web_ra_not_penot_periodonotas  
	where (cast(getdate() as date) >= cast(penot_fechaini as date)) and (cast(getdate() as date) <= cast(penot_fechafin as date)) and penot_periodo = @penot_periodo and penot_tipo = @penot_tipo

	print '@ev: ' + cast(@ev as varchar(2))
	print '----------'
	set @cuota=0 
	set @cuota_beca=0 
	set @cuota_wallmart=0
	set @cuota_virtual=0
	set @eval=0
	select @cil_codigo = @codcil--cil_codigo from ra_cil_ciclo where ra_cil_ciclo.cil_vigente = 'S'
	declare @Aranceles_evaluar table (tmo_codigo int)

	if @ev in (1)--primera
	begin
		-- set @cuota=134 --Prorroga
		--set @cuota_beca=158 
		--set @cuota_wallmart=1081
		--set @cuota_virtual=2053
		--set @cuota_virtual_beca = 2218
		set @eval='primera'
		insert into @Aranceles_evaluar (tmo_codigo)
		select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO' and are_cuota = 2 and tde_nombre = 'Pre grado'
	end
	if @ev in (2)--segunda
	begin
		--set @cuota=135 --Prorroga
		--set @cuota_beca=159 
		--set @cuota_wallmart=1082
		--set @cuota_virtual=2054
		--set @cuota_virtual_beca = 2219
		set @eval='segunda' 
		insert into @Aranceles_evaluar (tmo_codigo)
		select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO' and are_cuota = 3 and tde_nombre = 'Pre grado'
	end
	if @ev in (3)--tercera
	begin
		--set @cuota=136 
		--set @cuota_beca=160 
		--set @cuota_wallmart=1083
		--set @cuota_virtual=2055
		--set @cuota_virtual_beca = 2220
		set @eval='tercera'
		insert into @Aranceles_evaluar (tmo_codigo)
		select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO' and are_cuota = 4 and tde_nombre = 'Pre grado'
	end

	if @ev in (4)--cuarta
	begin
		--set @cuota=137 
	--set @cuota_beca=161 
	--set @cuota_wallmart=1081
	--set @cuota_virtual=2056
	--set @cuota_virtual_beca = 2221
	set @eval='cuarta'
	insert into @Aranceles_evaluar (tmo_codigo)
	select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO' and are_cuota = 5 and tde_nombre = 'Pre grado'
	end

	if @ev in (5)--quinta
	begin
		--set @cuota=943 
		--set @cuota_beca=944 
		--set @cuota_wallmart=1085
		--set @cuota_virtual=2057
		--set @cuota_virtual_beca = 2222
		set @eval='quinta'
		insert into @Aranceles_evaluar (tmo_codigo)
		select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO' and are_cuota = 6 and tde_nombre = 'Pre grado'
	end

	insert into @temp_listado_autorizados
	select distinct per_codigo, carnet, apellidos, nombres, ban_nombre
	from
	(
		select distinct ra_per_personas.per_codigo, ra_per_personas.per_carnet as carnet, ra_per_personas.per_apellidos as apellidos, 
			ra_per_personas.per_nombres as nombres, substring(ISNULL(ban_nombre,'UTEC'),1,10) ban_nombre
		from ra_ins_inscripcion 
		inner join ra_mai_mat_inscritas 
		inner join ra_mat_materias on ra_mai_mat_inscritas.mai_codmat = ra_mat_materias.mat_codigo on ra_ins_inscripcion.ins_codigo = ra_mai_mat_inscritas.mai_codins 
		inner join col_mov_movimientos 
		inner join col_dmo_det_mov on col_dmo_det_mov.dmo_codmov = col_mov_movimientos.mov_codigo 
		inner join col_tmo_tipo_movimiento on col_tmo_tipo_movimiento.tmo_codigo = col_dmo_det_mov.dmo_codtmo 
		inner join ra_per_personas on col_mov_movimientos.mov_codper = ra_per_personas.per_codigo on  ra_ins_inscripcion.ins_codper = ra_per_personas.per_codigo 
		inner join ra_fac_facultades 
		inner join ra_esc_escuelas on ra_fac_facultades.fac_codigo = ra_esc_escuelas.esc_codfac on ra_mat_materias.mat_codesc = ra_esc_escuelas.esc_codigo 
		inner join ra_hpl_horarios_planificacion on ra_mai_mat_inscritas.mai_codhpl = ra_hpl_horarios_planificacion.hpl_codigo 
		inner join pla_emp_empleado on ra_hpl_horarios_planificacion.hpl_codemp = pla_emp_empleado.emp_codigo 
		inner join ra_cil_ciclo on ra_ins_inscripcion.ins_codcil = ra_cil_ciclo.cil_codigo and col_dmo_det_mov.dmo_codcil = ra_cil_ciclo.cil_codigo 
		inner join ra_man_grp_hor on ra_hpl_horarios_planificacion.hpl_codman = ra_man_grp_hor.man_codigo 
		inner join ra_aul_aulas on ra_hpl_horarios_planificacion.hpl_codaul = ra_aul_aulas.aul_codigo 
		left outer JOIN adm_ban_bancos on ban_codigo = mov_codban 
		where hpl_codcil = @cil_codigo and (col_mov_movimientos.mov_estado <> 'A') and (ra_mai_mat_inscritas.mai_codmat = @codmat) and 
							  (ra_hpl_horarios_planificacion.hpl_descripcion = @hplsec) 
							   and col_tmo_tipo_movimiento.tmo_codigo in ( select are_codtmo from vst_Aranceles_x_Evaluacion 
							   where are_tipo = 'PREGRADO' and  spaet_codigo = @ev and are_tipoarancel = 'Men')
							   and (pla_emp_empleado.emp_codigo = @codemp) and dmo_codcil = @cil_codigo
							  and mai_estado <> 'R'
		union all
		select  per_codigo, per_carnet as carnet,per_apellidos as apellidos,per_nombres as nombres,'Prórroga' ban_nombre
		from ra_per_personas join ra_ins_inscripcion on ins_codper = per_codigo
		join ra_mai_mat_inscritas on mai_codins = ins_codigo
		join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
		join ra_pra_prorroga_acad on pra_codper = per_codigo
		join ra_man_grp_hor on hpl_codman=man_codigo
		where ins_codcil = @cil_codigo and pra_codcil = @cil_codigo-- and pra_codtmo = @cuota
		and hpl_codmat = @codmat and hpl_descripcion = @hplsec and hpl_codemp = @codemp
		and exists  (
		 select 1 from ra_pra_prorroga_acad 
			where pra_codper = ins_codper and pra_codcil = @cil_codigo and pra_codtmo in -- (@cuota,@cuota_virtual)
			(
				select tmo_codigo from @Aranceles_evaluar
			)
		)
		and mai_estado <> 'R'
		and  convert(datetime,convert(varchar,pra_fecha,103),103)<= (select convert(datetime,caa_fecha,103)-- por dias
							from web_ra_caa_calendario_acad 
							where  caa_dias=(case when isnull(hpl_lunes, 'N') = 'S' then 'L-' else '' end +
							case when isnull(hpl_martes, 'N') = 'S' then 'M-' else '' end +
							case when isnull(hpl_miercoles, 'N') = 'S' then 'Mi-' else '' end +
							case when isnull(hpl_jueves, 'N') = 'S' then 'J-' else '' end +
							case when isnull(hpl_viernes, 'N') = 'S' then 'V-' else '' end +
							case when isnull(hpl_sabado, 'N') = 'S' then 'S-' else '' end +
							case when isnull(hpl_domingo, 'N') = 'S' then 'D-' else '' end ) and caa_hora= substring(man_nomhor,1,5) and caa_evaluacion=@ev )

	) T
	order by T.apellidos

	select carnet, apellidos,nombres,ban_nombre from @temp_listado_autorizados
	union all
	select distinct per_carnet as carnet,per_apellidos as apellidos,per_nombres as nombres,'Autorizado' ban_nombre
	from ra_aan_activar_alumno_notas
		join ra_ins_inscripcion on ins_codper = aan_codper and ins_codcil = @cil_codigo
		join ra_per_personas on per_codigo = ins_codper
		join ra_mai_mat_inscritas on mai_codins = ins_codigo
		join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
	where aan_codper=ins_codper and aan_codcil=@cil_codigo and aan_periodo=@ev and hpl_codmat = @codmat and hpl_descripcion=@hplsec and 
		aan_codper not in (select per_codigo from @temp_listado_autorizados)
	order by apellidos
end
go

ALTER procedure [dbo].[web_alumnos_subir_notas_actividades]
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-09-12 14:59:17.230>
	-- Description: <Devuelve los alumnos que se procesaran las notas de las actividades de la material @codhpl en la evaluacion @evaluacion>
	-- =============================================
	-- web_alumnos_subir_notas_actividades 1, 'ETPS4-T01', 120, 2, 'Actividades', 'Pregrado', 2
	@opcion int,
	--@codhpl int,
	@tot varchar(50),
	@codcil int,
	@evaluacion int,
	@periodo varchar(25),--Actividades
	@tipo varchar(25),--Pregrado
	@codpenot int
as 
begin
	if @opcion = 1
	begin
		--declare @codhpl int

		--declare @codmat varchar(55), @seccion varchar(5)
		--set @codmat = substring(@tot, 1, len(@tot) - 2)
		--set @seccion = substring(@tot, len(@tot) - 1, len(@tot))
                               
		--declare /*@codmat varchar(55), @seccion varchar(5), */@codemp int/*, @codcil int, @codhpl int = 39340, @evaluacion int = 1*/, @penot_periodo varchar(25) = @periodo, @penot_tipo varchar(25) = @tipo
		--select /*@codmat = hpl_codmat, @seccion = hpl_descripcion, */@codemp = hpl_codemp, @codcil = hpl_codcil, @codhpl = hpl_codigo from ra_hpl_horarios_planificacion where hpl_codmat = @codmat and hpl_descripcion = @seccion and hpl_codcil = @codcil --hpl_codigo = @codhpl
		--print '@codmat ' + cast(@codmat as varchar(50))
		--print '@seccion ' + cast(@seccion as varchar(50))
		--print '@codemp ' + cast(@codemp as varchar(50))
		--print '@codcil ' + cast(@codcil as varchar(50))
		--print '@codhpl ' + cast(@codhpl as varchar(50))
		--declare @alumnos_pagos_al_dia as table(carnet varchar(16), apellidos varchar(100), nombres varchar(100), ban_nombre varchar(100))

		--insert into @alumnos_pagos_al_dia
		--exec web_ptl_Alum_solventes_actividades @codmat, @seccion, @codemp, @codcil, @penot_periodo, @penot_tipo
                               
		--if not exists (select 1 from web_ra_innot_ingresosdenotas where innot_codmai = @codmat and innot_seccion = @seccion and innot_codcil = @codcil and innot_codpenot = @codpenot and innot_tipo = @periodo)
		--begin
		--	select distinct per_codigo percodigo, per_carnet carnet, per_nombres_apellidos nombres
		--	from ra_not_notas 
		--					inner join ra_mai_mat_inscritas on mai_codigo = not_codmai
		--					inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
		--					inner join ra_ins_inscripcion  on ins_codigo = mai_codins
		--					inner join ra_per_personas on per_codigo = ins_codper 
		--					inner join ra_mat_materias on mat_codigo = mai_codmat
		--					inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
		--					inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
		--	where ins_codcil = @codcil and mai_codhpl = @codhpl and pom_codpon = @evaluacion and isnull(not_nota, 0) = 0 and mai_estado = 'I' and isnull(bandera, 0) = 0
		--	and per_carnet in (select carnet from @alumnos_pagos_al_dia)
		--end
		--else
		--begin
		--				select '' as percodigo, '' as carnet, 'Sus Notas ya han sido procesadas Anteriormente' as nombres
		--end
		declare @codhpl int

		declare @codmat varchar(55), @seccion varchar(5)
		set @codmat = substring(@tot, 1, len(@tot) - 2)
		set @seccion = substring(@tot, len(@tot) - 1, len(@tot))
		
		declare /*@codmat varchar(55), @seccion varchar(5), */@codemp int/*, @codcil int, @codhpl int = 39340, @evaluacion int = 1*/, @penot_periodo varchar(25) = @periodo, @penot_tipo varchar(25) = @tipo
		select /*@codmat = hpl_codmat, @seccion = hpl_descripcion, */@codemp = hpl_codemp, @codcil = hpl_codcil, @codhpl = hpl_codigo from ra_hpl_horarios_planificacion where hpl_codmat = @codmat and hpl_descripcion = @seccion and hpl_codcil = @codcil --hpl_codigo = @codhpl
		print '@codmat ' + cast(@codmat as varchar(50))
		print '@seccion ' + cast(@seccion as varchar(50))
		print '@codemp ' + cast(@codemp as varchar(50))
		print '@codcil ' + cast(@codcil as varchar(50))
		print '@codhpl ' + cast(@codhpl as varchar(50))
		print '@penot_tipo ' + cast(@penot_tipo as varchar(50))
		
		declare @alumnos_pagos_al_dia as table(carnet varchar(16), apellidos varchar(100), nombres varchar(100), ban_nombre varchar(100))

		insert into @alumnos_pagos_al_dia
		exec web_ptl_Alum_solventes_actividades @codmat, @seccion, @codemp, @codcil, @penot_periodo, @penot_tipo

		select distinct ins_codcil, mai_codhpl, mai_codigo, per_carnet, per_apellidos, per_nombres, mai_estado, mai_codmat, mat_nombre, not_codmai, not_nota, pom_codpon--, *
		from ra_not_notas 
			inner join ra_mai_mat_inscritas on mai_codigo = not_codmai
			inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
			inner join ra_ins_inscripcion  on ins_codigo = mai_codins
			inner join ra_per_personas on per_codigo = ins_codper 
			inner join ra_mat_materias on mat_codigo = mai_codmat
			inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
			inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
		where ins_codcil = @codcil and mai_codhpl = @codhpl and pom_codpon = @evaluacion and isnull(not_nota, 0) = 0 and mai_estado = 'I' and isnull(bandera, 0) = 0
		and per_carnet in (select carnet from @alumnos_pagos_al_dia)
	end
end