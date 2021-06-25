-- aem, feem y adem 
CREATE SYNONYM dbo.ra_ccm_cohorte_campus_maestria FOR dbo.ra_cohorte_campus_maestria
CREATE SYNONYM dbo.apam_alumnos_por_arancel_maestria FOR dbo.alumnos_por_arancel_maestria
CREATE SYNONYM dbo.tab_tal_maestria_beca FOR dbo.tal_maestria_beca

select * from aem_aranceles_evalucion_maes
select * from feem_fecha_exames_evaluacion_maes
select * from adem_activar_desactivar_evaluaciones_maes

select * from web_ra_not_penot_periodonotas_maes where penot_ciclo = 125
select * from ra_mfm_mat_fechas_maes
select * from tab_tal_maestria_beca where origen = 32 and codcil = 125

-- SPs modificados
-- sp_consulta_solvente_insolvente_maes
USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_consulta_solvente_insolvente_maes]    Script Date: 7/4/2021 10:11:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:      <>
	-- Create date: <>
	-- Last modify: <Fabio, 2021-03-21 16:22:11.349>
	-- Description: <Devuelve la data para el listado de alumnos solventes e insolventes en MAES>
	-- =============================================
	-- exec dbo.sp_consulta_solvente_insolvente_maes 125, 'HADI-V03', 'S'

ALTER procedure [dbo].[sp_consulta_solvente_insolvente_maes]
	@codcil int = 0,
	@tot nvarchar(50) = '',
	@tipo nvarchar(10) = '' /*I: insolventes, S: solventes*/
as
begin
	declare @franja nvarchar(100), @fecha_examen date, @eval int, @codemp int

	select @franja = CASE WHEN dias <> '' THEN substring(dias,1,len(dias)-1) ELSE dias END +' ('+rtrim(ltrim(man_nomhor))+')',
	@codemp = hpl_codemp
	from (
		select
			case when hpl_lunes = 'S' then 'Lun-' else '' end +
			case when hpl_martes = 'S' then 'Mar-' else '' end +
			case when hpl_miercoles = 'S' then 'Mie-' else '' end +
			case when hpl_jueves = 'S' then 'Jue-' else '' end +
			case when hpl_viernes = 'S' then 'Vie-' else '' end +
			case when hpl_sabado = 'S' then 'Sab-' else '' end +
			case when hpl_domingo = 'S' then 'Dom' else '' end dias,man_nomhor, hpl_codemp
		from ra_hpl_horarios_planificacion
			join ra_mat_materias on mat_codigo = hpl_codmat
			left join ra_man_grp_hor on man_codigo = hpl_codman
		where hpl_codcil = @codcil and (ltrim(rtrim(hpl_codmat))+ltrim(rtrim(hpl_descripcion))) = @tot
	) a

	print '@franja ' + cast(@franja as varchar(50))
	
	select tpm_descripcion Tipo, ra_mat_materias.mat_codigo as codmat, 
		ra_mat_materias.mat_nombre AS materia, ra_hpl_horarios_planificacion.hpl_descripcion AS secc, ra_aul_aulas.aul_nombre_corto as aula, 
		man_nomhor AS horas, 
		CASE WHEN isnull(hpl_lunes, 'N') = 'S' THEN 'L-' ELSE '' END + 
		CASE WHEN isnull(hpl_martes, 'N') = 'S' THEN 'M-' ELSE '' END +
		CASE WHEN isnull(hpl_miercoles, 'N') = 'S' THEN 'Mi-' ELSE '' END + 
		CASE WHEN isnull(hpl_jueves, 'N') = 'S' THEN 'J-' ELSE '' END + 
		CASE WHEN isnull(hpl_viernes, 'N') = 'S' THEN 'V-' ELSE '' END + 
		CASE WHEN isnull(hpl_sabado, 'N') = 'S' THEN 'S-' ELSE '' END + 
		CASE WHEN isnull(hpl_domingo, 'N') = 'S' THEN 'D-' ELSE '' END AS Dias, 
		emp_nombres_apellidos as docente
	from ra_hpl_horarios_planificacion  
		join ra_mat_materias on mat_codigo = hpl_codmat 
		join pla_emp_empleado on emp_codigo = hpl_codemp
		join ra_aul_aulas on  aul_codigo  = hpl_codaul
		join ra_man_grp_hor on man_codigo = hpl_codman
		inner join ra_tpm_tipo_materias on tpm_tipo_materia = hpl_tipo_materia
	where hpl_codcil = @codcil and (ltrim(rtrim(hpl_codmat))+ltrim(rtrim(hpl_descripcion))) = @tot

	declare @alumnos table (codigo int, carnet nvarchar(25), nombre nvarchar(250), cohorte int)
	insert into @alumnos(codigo, carnet, nombre, cohorte)
	select p.per_codigo codigo,per_carnet carnet, per_apellidos_nombres nombr, b.origen
	from ra_hpl_horarios_planificacion
		join ra_mai_mat_inscritas on mai_codhpl = hpl_codigo
		join ra_ins_inscripcion on ins_codigo = mai_codins
		join ra_per_personas p on p.per_codigo = ins_codper
		join ra_mat_materias ON mat_codigo = hpl_codmat AND mat_codigo = mai_codmat

		inner join tab_tal_maestria_beca b on ins_codper = b.per_codigo and ins_codcil = b.codcil

	where mai_estado = 'I' and hpl_codcil = @codcil  
	and (ltrim(rtrim(hpl_codmat))+ltrim(rtrim(hpl_descripcion))) = @tot
	and per_estado = 'A' and ins_codcil = @codcil
	order by per_apellidos_nombres asc

	select @fecha_examen = feem_fecha_examen, @eval = adeam_n_evaluacion
	from feem_fecha_exames_evaluacion_maes
		join adem_activar_desactivar_evaluaciones_maes on adem_eval = feem_evaluacion and adem_orden = feem_orden_materia
		
		and (select distinct top 1 cohorte from @alumnos) in (adem_codccm, feem_codccm) -- Agreado Fabio 29/03/2021

	where adem_estado = 'A' and feem_fechahora = @franja

	print '@fecha_examen:' + CAST(@fecha_examen as varchar(20))
	print '@eval:' + CAST(@eval as varchar(10))

	declare @solventes table (codper int, carne nvarchar(50), nom nvarchar(250))
	declare @materia_tipo int

	
	select @materia_tipo = hpl_materia
    from ra_hpl_horarios_planificacion
        join ra_mat_materias on mat_codigo = hpl_codmat
    where hpl_codemp = @codemp and hpl_codcil = @codcil
        and (rtrim(mat_codigo)+ ltrim(hpl_descripcion))= @tot

	insert into @solventes(codper, carne, nom)
	select distinct codigo, carnet, nombre 
	from @alumnos
		join col_mov_movimientos on mov_codper = codigo
		join col_dmo_det_mov on dmo_codmov = mov_codigo
		join aem_aranceles_evalucion_maes on aem_codtmo = dmo_codtmo
	where dmo_codcil = @codcil and mov_estado <> 'A' 
		and convert(date, mov_fecha_cobro) <= @fecha_examen 
		and aem_eval = @eval
	group by codigo,carnet, nombre
	--having count(codigo) >= 1
	having count(codigo) >= case when @materia_tipo = 3 then 1 else 2 end

	--select * from @alumnos--ln 101
	if @tipo='S'
	begin		
		select codigo, carnet, nombre from @alumnos where codigo in (select codper from @solventes)
	end
	if @tipo='I'
	begin
		select codigo, carnet, nombre from @alumnos where codigo not in (select codper from @solventes)
	end

end

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[web_not_alumnospormateria_maes]    Script Date: 7/4/2021 10:12:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:      <>
	-- Create date: <>
	-- Last modify: <Fabio, 2021-03-24 20:37:21.878>
	-- Description: <Devuelve la data de alumnos para procesar notas en maestrias>
	-- =============================================
	-- exec dbo.web_not_alumnospormateria_maes 125, 3731, 2, 'HADI-V03', 0, 0
ALTER PROCEDURE [dbo].[web_not_alumnospormateria_maes] 
	@cic int = 0,
	@emp int = 0,
	@tip int = 0,
	@tot varchar(100) = '',
	@exdif int = 0,
	@exor int = 0
as
begin

    set dateformat dmy

    declare @ev int= 0, @fech datetime = getdate(),
		@ev1 int = 0, @num int = 0,
		@proc int = 0, @procd int = 0,
		@tipo varchar(50) = '',  @periodo varchar(50) = '',
		@ciclo_pre int,  @dias_val nvarchar(20) = '',
		@hora_val nvarchar(10) = '', @fecha_limite datetime = getdate(),
		@cuota int = 0,  @cuota_beca int = 0,
		@cuota_virtual int = 0, @codmat_d varchar(10) = '',
		@ev_d int = 0, @materia_tipo int

    if @tip = 2 -- maestria
    begin
        print 'Maestrias'
        select @materia_tipo = hpl_materia
        from ra_hpl_horarios_planificacion
            join ra_mat_materias on mat_codigo=hpl_codmat
        where hpl_codemp=@emp and hpl_codcil=@cic
            and (rtrim(mat_codigo)+ ltrim(hpl_descripcion))= @tot

        print '@materia_tipo: ' + cast(@materia_tipo as nvarchar(10))

        print '@ev1: ' + cast(@ev1 as nvarchar(10))
		
            
		select ins_codcil, ins_codper, mai_codigo, mai_codmat, hpl_descripcion, mai_codhpl
			into [#ins2]
		from ra_ins_inscripcion
			inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
			inner join ra_hpl_horarios_planificacion on mai_codhpl = hpl_codigo
		where (mai_estado = 'I') and (ins_codcil = @cic)
			and (rtrim(mai_codmat) + ltrim(hpl_descripcion) = @tot)
		--select * from [#ins2]--ln 58
		declare @cohorte int = 0
		select distinct @cohorte = origen from [#ins2] -- Agreado Fabio 29/03/2021
			inner join tab_tal_maestria_beca b on ins_codper = b.per_codigo and ins_codcil = b.codcil
		set @cohorte = isnull(@cohorte, 0)

		select @ev1 = penot_codigo, @ev = penot_eval, @periodo = penot_periodo, @tipo = penot_tipo
        from web_ra_not_penot_periodonotas_maes
        where (@fech >= penot_fechaini) and (@fech <= penot_fechafin) 
			and (penot_tipo = 'Maestria') and penot_ciclo = @cic
			and penot_codccm in (@cohorte)

        select @proc = count(1)
        from web_ra_innot_ingresosdenotas
        where innot_codemp = @emp
            and (rtrim (innot_codmai) + ltrim(innot_seccion) = @tot)
            and innot_codcil=@cic and innot_codpenot = @ev1

        print '@proc: ' + cast(@proc as nvarchar(10))

        select @ev1 as codperio, @ev as eval, @periodo as periodo, @num '@num', @proc as procesada, @tipo as tipo

        select tpm_descripcion Tipo, mat_codigo as codmat, mat_nombre as materia, hpl_descripcion as secc, aul_nombre_corto as aula, 
		man_nomhor as horas, 
			CASE WHEN isnull(hpl_lunes, 'N') = 'S' THEN 'L-' ELSE '' END + 
			CASE WHEN isnull(hpl_martes, 'N') = 'S' THEN 'M-' ELSE '' END +
			CASE WHEN isnull(hpl_miercoles, 'N') = 'S' THEN 'Mi-' ELSE '' END + 
			CASE WHEN isnull(hpl_jueves, 'N') = 'S' THEN 'J-' ELSE '' END + 
			CASE WHEN isnull(hpl_viernes, 'N') = 'S' THEN 'V-' ELSE '' END + 
			CASE WHEN isnull(hpl_sabado, 'N') = 'S' THEN 'S-' ELSE '' END + 
			CASE WHEN isnull(hpl_domingo, 'N') = 'S' THEN 'D-' ELSE '' END AS Dias, 
		empleado.emp_nombres_apellidos as docente
        from pla_emp_empleado as empleado
            inner join ra_hpl_horarios_planificacion on hpl_codemp = emp_codigo
            inner join ra_mat_materias on mat_codigo = hpl_codmat
            inner join ra_esc_escuelas on esc_codigo = mat_codesc
            inner join ra_fac_facultades on esc_codfac = ra_fac_facultades.fac_codigo
            inner join ra_aul_aulas on aul_codigo = hpl_codaul
            inner join ra_man_grp_hor on man_codigo = hpl_codman

			inner join ra_tpm_tipo_materias on tpm_tipo_materia = hpl_tipo_materia
        WHERE (hpl_codcil = @cic) and (emp_codigo = @emp)
            and (rtrim(mat_codigo)+ ltrim(hpl_descripcion)= @tot)

        print '@periodo: ' + @periodo

        if @ev<>0 and @periodo='Diferido' and @proc=0 and @exdif<>0
        begin
            print 'Es examen diferido'

            select ins_codcil, ins_codper, mai_codigo, 
			mai_codmat, hpl_descripcion, per_carnet as carne, mai_codhpl
                INTO [#ins]
            from ra_ins_inscripcion
                inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
                inner join ra_hpl_horarios_planificacion on mai_codhpl = hpl_codigo
                inner join ra_per_personas on per_codigo = ins_codper
            WHERE (mai_estado = 'I') and (ins_codcil = @cic)
                and (rtrim(mai_codmat) + ltrim(hpl_descripcion) = @tot) and hpl_codemp=@emp
                and not exists(
					select 1 from web_ra_npro_notasprocesadas_maes
					where npro_alumno = ins_codper and SUBSTRING(npro_codinnot,1,6)=mai_codmat
				)

            select distinct per_codigo, per_carnet as carnet, per_apellidos_nombres nombre
                into #m
            from ra_per_personas
                join #ins on ins_codper = per_codigo
                join ra_mat_materias on mat_codigo = mai_codmat
                join ra_not_notas on not_codmai = mai_codigo
                join ra_pom_ponderacion_materia on pom_codigo = not_codpom
                join ra_pon_ponderacion on pon_codigo = pom_codpon
                join ra_alc_alumnos_carrera on alc_codper = per_codigo
                join ra_pla_planes on alc_codpla = pla_codigo
                join ra_car_carreras on pla_codcar = car_codigo
                join ra_fac_facultades on car_codfac = fac_codigo
                join ra_reg_regionales on reg_codigo = 1
                join ra_uni_universidad on uni_codigo = reg_coduni
                join ra_cil_ciclo on cil_codigo = ins_codcil
                join ra_cic_ciclos on cic_codigo = cil_codcic
                join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
                join ra_plm_planes_materias on plm_codpla = alc_codpla and plm_codmat = mat_codigo
            order by per_apellidos_nombres

            Declare @inicio datetime,
                    @fin datetime

            select @inicio=mfm_fecha_inicio, @fin=mfm_fecha_fin
            from ra_mfm_mat_fechas_maes
            where mfm_materia= case when (@materia_tipo = 3 or @materia_tipo = 4) then 3 else @materia_tipo end

			print '@inicio: '
            print @inicio
            print '@fin: '
            print @fin

            select distinct per_codigo percodigo, carnet, nombre nombres
            from #m a
            where exists (
                select count(tmo_codigo) conteo, s.per_carnet
                from col_mov_movimientos
                    join #m t on mov_codper=per_codigo
                    join ra_per_personas s on s.per_codigo=t.per_codigo
                    join col_dmo_det_mov on dmo_codmov=mov_codigo
                    join col_tmo_tipo_movimiento on tmo_codigo=dmo_codtmo
                where mov_estado <> 'A'
                    and tmo_arancel in(/*Diferidos y extraordinarios*/'E-20','E-21')
                    and dmo_codcil = @cic
                    and a.per_codigo = s.per_codigo
                    and convert(date, mov_fecha, 103) between convert(date, @inicio, 103) and convert(date, @fin, 103)
                group by s.per_carnet
                having count(tmo_codigo) >= 1
            )
            order by nombre
            drop table #m
            drop table #ins
        end -- if @ev<>0 and @periodo='Diferido' and @proc=0 and @exdif<>0

        if @ev <> 0 and @periodo = 'Ordinario' and @proc = 0
        begin
            print 'Periodo Ordinario'

            select distinct per_codigo, per_carnet as carnet, per_apellidos_nombres nombre--, isnull(npro_nota,0) Eval1
                into #m2
            from ra_per_personas
                join #ins2 on ins_codper = per_codigo
                join ra_mat_materias on mat_codigo = mai_codmat
                join ra_not_notas on not_codmai = mai_codigo
                join ra_pom_ponderacion_materia on pom_codigo = not_codpom
                join ra_pon_ponderacion on pon_codigo = pom_codpon
                join ra_alc_alumnos_carrera on alc_codper = per_codigo
                join ra_pla_planes on alc_codpla = pla_codigo
                join ra_car_carreras on pla_codcar = car_codigo
                join ra_fac_facultades on car_codfac = fac_codigo
                join ra_reg_regionales on reg_codigo = 1
                join ra_uni_universidad on uni_codigo = reg_coduni
                join ra_cil_ciclo on cil_codigo = ins_codcil
                join ra_cic_ciclos on cic_codigo = cil_codcic
                join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
                join ra_plm_planes_materias on plm_codpla = alc_codpla
                    and plm_codmat = mat_codigo
            order by per_apellidos_nombres
			--select * from #m2--ln 200

			select distinct per_codigo percodigo, carnet, nombre nombres
            from #m2 a
            where exists (
                select count(tmo_codigo) conteo, s.per_carnet
                from col_mov_movimientos
                    join #m2 t on mov_codper=per_codigo
                    join ra_per_personas s on s.per_codigo=t.per_codigo
                    join col_dmo_det_mov on dmo_codmov=mov_codigo
                    join col_tmo_tipo_movimiento on tmo_codigo=dmo_codtmo
                where tmo_arancel in(
                    select distinct tmo_arancel
                    from feem_fecha_exames_evaluacion_maes
                        inner join adem_activar_desactivar_evaluaciones_maes on adem_orden = feem_orden_materia
                        inner join aem_aranceles_evalucion_maes on aem_eval = adeam_n_evaluacion --and aem_eval = feem_evaluacion
                        inner join vst_Aranceles_x_Evaluacion on aem_codtmo = are_codtmo
                    where adem_orden in (@materia_tipo/*set 1, 2, 3, 4*/)
                        and feem_codcil = @cic

						and @cohorte in (adem_codccm, aem_codccm, feem_codccm)--Agreado Fabio 29/03/2021
                ) and dmo_codcil=@cic and a.per_codigo=s.per_codigo and mov_estado <> 'A'
                group by s.per_carnet
                having count(tmo_codigo) >= case when @materia_tipo = 3 then 1 else 2 end
            )
            order by nombre

            drop table #m2

        end -- if @ev <> 0 and @periodo = 'Ordinario' and @proc = 0

    end -- if @tip = 2 -- maestria

end