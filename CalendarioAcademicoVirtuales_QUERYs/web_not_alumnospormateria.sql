USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[web_not_alumnospormateria]    Script Date: 15/2/2020 08:38:56 ******/
SET ANSI_NULLS on
GO
SET QUOTED_IDENTIFIER on
GO
	-- =============================================
	-- Author:      <>
	-- Create date: <2010-02-08 14:47:35.373>
	-- Description: <Retorna los alumnos que se le podran subir nota en el portalUTEC>
	-- =============================================
	-- exec dbo.web_not_alumnospormateria 122, 3812, 1, 'INT2-E01', 1, 0
	-- exec dbo.web_not_alumnospormateria 122, 276, 1, 'ALG1-V02', 1, 0
	-- exec dbo.web_not_alumnospormateria 122, 276, 1, 'STCB-V01', 1, 0

ALTER PROCEDURE [dbo].[web_not_alumnospormateria] 
	@cic int,
	@emp int,
	@tip int,
	@tot varchar(100),
	@exdif int,
	@exor int
as
begin
	set dateformat dmy
	declare @ev int = 0, @fech datetime = getdate(),
	@ev1 int = 0, @num int = 0,
	@proc int = 0, @procd int = 0,
	@tipo varchar(50) = '', @periodo varchar(50) = '',
	@ciclo_pre int = 0, @dias_val nvarchar(20) = '',
	@hora_val nvarchar(10) = '', @fecha_limite datetime = getdate(),
	@cuota int = 0, @cuota_beca int = 0, 
	@cuota_virtual int = 0, @codmat_d varchar(10) = '',
	@ev_d int = 0, @codpre int = 0,
	@seccion varchar(2) = '', @codcil int = 0,
	@cuota_virtual_beca int = 0, @codhpl int = 0,
	@are_cuota tinyint = 0

	declare @Aranceles_evaluar table (tmo_codigo int)
	declare @fecha_maxima_prorroga as table (fecha_maxima date)

	if @tip=1--pregrado
	begin
		select @ev_d = penot_eval from web_ra_not_penot_periodonotas where penot_codigo = @exor
		print '@ev_d : ' + cast(@ev_d as nvarchar(5))
		select @ev1=penot_codigo,@ev=penot_eval ,@periodo=penot_periodo,@tipo=penot_tipo  
		from web_ra_not_penot_periodonotas   
		where getdate()>=penot_fechaini and getdate() <= penot_fechafin and penot_tipo='Pregrado'
		print '@ev1 : ' + cast(@ev1 as nvarchar(5))
		declare  @eval nvarchar(20)

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
		print '@eval : ' + @eval

		declare @hplsec varchar(12)
		---*****Buscar dia y hora para validar pagos segun calendario académico
		----Inicia
		select @dias_val=(
			case when isnull(hpl_lunes, 'N') = 'S' then 'L-' else '' end + 
			case when isnull(hpl_martes,'N') = 'S' then 'M-' else '' end + 
			case when isnull(hpl_miercoles, 'N') = 'S' then 'Mi-' else '' end + 
			case when isnull(hpl_jueves, 'N') = 'S' then 'J-' else '' end + 
			case when isnull(hpl_viernes, 'N') = 'S' then 'V-' else '' end + 
			case when isnull(hpl_sabado, 'N') = 'S' then 'S-' else '' end + 
			case when isnull(hpl_domingo, 'N') = 'S' then 'D-' else '' end
		),
		@hora_val=substring(man_nomhor,1,5),@codmat_d = hpl_codmat, @codhpl = hpl_codigo,
		@hplsec = hpl_descripcion
		from ra_hpl_horarios_planificacion as hpl 
		join ra_man_grp_hor on man_codigo = hpl_codman
		where hpl_codcil = @cic and (ltrim(rtrim(hpl.hpl_codmat))+ ltrim(rtrim(hpl.hpl_descripcion))= @tot) and hpl_codemp = @emp
		----Termina 

		--Inicia Busqueda de fecha limite de pago en calendario académico
		--select @fecha_limite = caa_fecha from web_ra_caa_calendario_acad where caa_dias = @dias_val and caa_hora = @hora_val and caa_evaluacion = @ev
		--Agregado 17/02/2020 para conocer la fecha maxima
		insert into @fecha_maxima_prorroga (fecha_maxima)
		exec sp_fecha_limite_prorroga 1, @codmat_d, @hplsec, @cic, @ev
		select @fecha_limite = fecha_maxima from @fecha_maxima_prorroga
		--Agregado 17/02/2020

		--Termina validación
		print '@fecha_limite : ' + cast(@fecha_limite as nvarchar(30))
		select @proc=count(1) from web_ra_innot_ingresosdenotas where (ltrim(rtrim (innot_codmai)) + ltrim(rtrim(innot_seccion))=@tot)and innot_codcil=@cic and innot_codemp=@emp and (innot_codpenot=@ev1)
		select @procd=count(1) from web_ra_innot_ingresosdenotas where (ltrim(rtrim (innot_codmai)) + ltrim(rtrim(innot_seccion))=@tot)and innot_codcil=@cic and (innot_codpenot=@exor)
		
		select @ev1 as codperio, @ev as eval,@periodo as periodo,@num,@proc as procesada,@procd as procesadadif,@tipo as tipo, @codhpl codhpl

		select tpm_tipo_materia  as Tipo, mat.mat_codigo as codmat,
		mat.mat_nombre as materia, hpl.hpl_descripcion as secc, aul.aul_nombre_corto as aula, 
		man_nomhor as horas, case when isnull(hpl_lunes, 'N') = 'S' then 'L-' else '' end + case when isnull(hpl_martes,
		'N') = 'S' then 'M-' else '' end + case when isnull(hpl_miercoles, 'N') = 'S' then 'Mi-' else '' end + case when isnull(hpl_jueves, 'N') 
		= 'S' then 'J-' else '' end + case when isnull(hpl_viernes, 'N') = 'S' then 'V-' else '' end + case when isnull(hpl_sabado, 'N') 
		= 'S' then 'S-' else '' end + case when isnull(hpl_domingo, 'N') = 'S' then 'D-' else '' end as Dias, emp.emp_nombres_apellidos as docente
		from pla_emp_empleado as emp 
			inner join ra_hpl_horarios_planificacion as hpl on hpl.hpl_codemp = emp_codigo 
			inner join ra_tpm_tipo_materias as tpm on hpl_tipo_materia = tpm_tipo_materia 
			inner join ra_mat_materias as mat on mat.mat_codigo = hpl.hpl_codmat 
			inner join ra_esc_escuelas as esc on esc.esc_codigo = mat.mat_codesc 
			inner join ra_fac_facultades as fac on esc.esc_codfac = fac.fac_codigo 
			inner join ra_aul_aulas as aul on aul.aul_codigo = hpl.hpl_codaul 
			inner join ra_man_grp_hor as man on man.man_codigo = hpl.hpl_codman
		where (hpl.hpl_codcil = @cic) and (emp_codigo = @emp) 
			and (ltrim(rtrim(mat.mat_codigo)) + ltrim(rtrim(hpl.hpl_descripcion))= @tot) and hpl_tipo_materia <> 'A'
		--------******Validación para examenes diferidos
		if @ev<>0 and @periodo='Diferido' and @procd=0 and @exor<>0 and @exdif<>0
		begin
			----**********Crear tabla para los alumnos que ya se evaluaron
			print cast(@ev as varchar)
			declare @evaluados table(npro_alumno int)
			insert into @evaluados (npro_alumno)
			select npro_alumno 
			from web_ra_npro_notasprocesadas
			inner join web_ra_innot_ingresosdenotas as innot on web_ra_npro_notasprocesadas.npro_codinnot = innot.innot_codingre
			where ltrim(rtrim (innot_codmai)) + ltrim(rtrim(innot_seccion))=@tot and innot_codcil=@cic
			and innot_tipo='Pregrado' and (innot_codpenot=@exdif or innot_codpenot=@exor)
			-------------------------------------------------------------
			---Crear tabla temporal para evaluar si cancelo el diferido
			declare @SinEvaluarse table(percodigo int, carnet nvarchar(12), nombres nvarchar(201))

			insert into @SinEvaluarse (percodigo, carnet, nombres)
			select distinct per.per_codigo as percodigo, per.per_carnet as carnet, per.per_apellidos_nombres as nombres
			from ra_cil_ciclo as cil
			inner join ra_ins_inscripcion as ins on cil.cil_codigo = ins.ins_codcil 
			inner join ra_per_personas as per on ins.ins_codper = per.per_codigo 
			inner join ra_mai_mat_inscritas as mai on ins.ins_codigo = mai.mai_codins 
			inner join ra_hpl_horarios_planificacion as hpl on mai.mai_codhpl = hpl.hpl_codigo 
			inner join ra_mat_materias as mat on mai.mai_codmat = mat.mat_codigo 
			inner join web_ra_innot_ingresosdenotas as innot on mat.mat_codigo = innot.innot_codmai
			where (cil.cil_codigo =@cic) and (mai.mai_estado = 'I')   and (hpl.hpl_codemp =@emp ) and 
			(ltrim(rtrim(mat.mat_codigo))+ ltrim(rtrim(hpl.hpl_descripcion))= @tot) and 
			not exists (select 1 from @evaluados where npro_alumno = per_codigo)
			order by nombres

			---Evaluando si cancelo examen diferido correspondiente a la materia
			select distinct percodigo,carnet,nombres from (
				select percodigo,carnet,nombres 
				from @SinEvaluarse 
				where exists(select 1 from col_mov_movimientos join col_dmo_det_mov on dmo_codmov = mov_codigo and mov_estado <> 'A'
				and dmo_codcil = @cic and dmo_codtmo = 909 and mov_codper = percodigo and dmo_codmat = @codmat_d and dmo_eval = @ev_d)
				union all
				select aan_codper percodigo, per_carnet carnet, per_apellidos_nombres nombres 
				from ra_aan_activar_alumno_notas
				join ra_ins_inscripcion on ins_codper = aan_codper and ins_codcil = @cic
				join ra_per_personas on per_codigo = ins_codper
				join ra_mai_mat_inscritas on mai_codins = ins_codigo
				join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl and hpl_codigo = aan_codhpl and hpl_codcil = aan_codcil
				where aan_codper=ins_codper and aan_codcil=@cic and aan_periodo=@ev_d and rtrim(ltrim(hpl_codmat))+rtrim(ltrim(hpl_descripcion))=@tot and aan_tipo = 'Extraordinario'
				and aan_codper in (select percodigo from @SinEvaluarse)
			) d
			order by nombres
			-------------****Termina validacion!------------------------------
		end

		if @ev<>0 and @periodo='Actividades'and @proc=0
		begin
		print '@ev: :' + cast(@ev as nvarchar)
			exec web_alumnos_subir_notas_actividades 1, @tot, @cic, @ev, @periodo, 'Pregrado', @ev1
		end

		if  @ev<>0 and @periodo='Ordinario' and @proc=0
		begin
			print 'if  @ev<>0 and @periodo=Ordinario and @proc=0'
			--Creo tabla temporal para obtener los alumnos que cancelaron antes de la fecha del parcial
			declare @ins1 table(percodigo int, carnet nvarchar(12), nombres nvarchar(201))

			print '----------------------------------------------------------'
			if ((select cil_codcic from ra_cil_ciclo where cil_codigo = @cic) = 3)
			begin
				print 'Es Interciclo'
				insert into @ins1 
				select distinct per.per_codigo as percodigo, per.per_carnet as carnet, per.per_apellidos_nombres as nombres
				from ra_cil_ciclo as cil
				inner join ra_ins_inscripcion as ins on cil.cil_codigo = ins.ins_codcil 
				inner join ra_per_personas as per on ins.ins_codper = per.per_codigo 
				inner join ra_mai_mat_inscritas as mai on ins.ins_codigo = mai.mai_codins 
				inner join ra_hpl_horarios_planificacion as hpl on mai.mai_codhpl = hpl.hpl_codigo 
				inner join ra_mat_materias as mat on hpl_codmat = mat_codigo
				--ra_mat_materias on mai.mai_codmat = mat.mat_codigo
				where (cil.cil_codigo = @cic) and(mai.mai_estado = 'I') and (ltrim(rtrim(mat.mat_codigo))+ ltrim(rtrim(hpl.hpl_descripcion))= @tot) and (hpl.hpl_codemp=@emp)
				print 'Fin es Interciclo'
			end
			else
			begin
				print 'Es un ciclo normal'
				insert into @ins1 
				select distinct per.per_codigo as percodigo, per.per_carnet as carnet, per.per_apellidos_nombres as nombres
				from ra_cil_ciclo as cil
					inner join ra_ins_inscripcion as ins on cil.cil_codigo = ins.ins_codcil 
					inner join ra_per_personas as per on ins.ins_codper = per.per_codigo 
					inner join ra_mai_mat_inscritas as mai on ins.ins_codigo = mai.mai_codins 
					inner join ra_hpl_horarios_planificacion as hpl on mai.mai_codhpl = hpl.hpl_codigo 
					inner join ra_mat_materias as mat on hpl_codmat = mat_codigo
					--ra_mat_materias on mai.mai_codmat = mat.mat_codigo
				where (cil.cil_codigo = @cic) and(mai.mai_estado = 'I') and 
				(ltrim(rtrim(mat.mat_codigo))+ ltrim(rtrim(hpl.hpl_descripcion))= @tot) and (hpl.hpl_codemp=@emp)
				and exists
				(
					select 1 from col_mov_movimientos join col_dmo_det_mov on 
					dmo_codmov = mov_codigo 
					where mov_codper = ins_codper and mov_estado <> 'A' and 
					dmo_codcil = @cic and dmo_codtmo in --(@cuota,@cuota_beca,@cuota_virtual, @cuota_virtual_beca) 
					(
						select tmo_codigo from @Aranceles_evaluar
						--select are_codtmo from vst_Aranceles_x_Evaluacion 
						--where are_tipo = 'PREGRADO' and  spaet_codigo = @ev and are_tipoarancel = 'Men'
					)
					--and convert(varchar(10),mov_fecha_cobro,103) <= @fecha_limite)
					and convert(varchar(10),mov_fecha_real_pago ,103) <= @fecha_limite
				)
			end-- else if ((select cil_codcic from ra_cil_ciclo where cil_codigo = @cic) = 3)
			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			--COMENTARIADA SOLO PARA INTERCICLO
			--FIN COMENTARIADA SOLO PARA INTERCICLO

			print '1'
			print '@cuota : ' + cast(@cuota as nvarchar(6))
			print '@cuota_virtual : ' +  cast(@cuota_virtual as nvarchar(6))
			print '@ev : ' + cast(@ev as nvarchar(6))
			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			--creo tabla temporal para obtener los alumnos que tienen prórroga
			declare @ins2 table(percodigo int, carnet nvarchar(12), nombres nvarchar(201))
			insert into @ins2 
			select distinct per.per_codigo as percodigo, per.per_carnet as carnet, per.per_apellidos_nombres as nombres
			from ra_cil_ciclo as cil
				inner join ra_ins_inscripcion as ins on cil.cil_codigo = ins.ins_codcil 
				inner join ra_per_personas as per on ins.ins_codper = per.per_codigo 
				inner join ra_mai_mat_inscritas as mai on ins.ins_codigo = mai.mai_codins 
				inner join ra_hpl_horarios_planificacion as hpl on mai.mai_codhpl = hpl.hpl_codigo 
				inner join ra_mat_materias as mat on mai.mai_codmat = mat.mat_codigo 
				inner join ra_man_grp_hor as man on hpl_codman=man_codigo -- SE AGREGO PARA PODER SACAR LOS SACAR LAS PRORROGAS POR HORA
			where   (cil.cil_codigo = @cic) and(mai.mai_estado = 'I') and 
			(ltrim(rtrim(mat.mat_codigo))+ ltrim(rtrim(hpl.hpl_descripcion))= @tot) and (hpl.hpl_codemp=@emp)
			and exists
			(
				select 1 from ra_pra_prorroga_acad 
				where pra_codper = ins_codper and pra_codcil = @cic and pra_codtmo in -- (@cuota,@cuota_virtual)
				(
					--select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO' and spaet_codigo = @ev and are_tipoarancel = 'Men'
					select tmo_codigo from @Aranceles_evaluar
				)
				--SE AGREGO PARA PODER SACAR LAS PRORROGAS POR HORA  12/12/2014
				-- and  pra_fecha<= (select convert(datetime,caa_fecha,103)+ ' '+caa_hora  -- Para sacar por hora
				and convert(datetime,convert(varchar,pra_fecha,103),103) <= (select fecha_maxima from @fecha_maxima_prorroga)
				/*(select convert(datetime,convert(varchar,caa_fecha,103),103)--+ ' '+caa_hora -- para sacar po dia entero
					from web_ra_caa_calendario_acad 
					where  caa_dias=(
					case when isnull(hpl_lunes, 'N') = 'S' then 'L-' else '' end +
					case when isnull(hpl_martes, 'N') = 'S' then 'M-' else '' end +
					case when isnull(hpl_miercoles, 'N') = 'S' then 'Mi-' else '' end +
					case when isnull(hpl_jueves, 'N') = 'S' then 'J-' else '' end +
					case when isnull(hpl_viernes, 'N') = 'S' then 'V-' else '' end +
					case when isnull(hpl_sabado, 'N') = 'S' then 'S-' else '' end +
					case when isnull(hpl_domingo, 'N') = 'S' then 'D-' else '' end 
					) and caa_hora = substring(man_nomhor,1,5)  and caa_evaluacion=@ev )*/
			)
			print '2'
			--[web_not_alumnospormateria]  119, 1775, 1, 'EPRO-I02', 0, 0
			--Realizo la unión de los alumnos para mostrar el listado
			select distinct a.percodigo, a.carnet, a.nombres 
			from
			(
				select percodigo,carnet,nombres from @ins1
				union
				select percodigo,carnet,nombres from @ins2
				union
				select distinct aan_codper percodigo,per_carnet carnet,per_apellidos_nombres nombres 
				from ra_aan_activar_alumno_notas
				join ra_ins_inscripcion on ins_codper = aan_codper and ins_codcil = @cic
				join ra_per_personas on per_codigo = ins_codper
				join ra_mai_mat_inscritas on mai_codins = ins_codigo
				join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl and hpl_codigo = aan_codhpl  and hpl_codcil = aan_codcil
				where aan_codper=ins_codper and aan_codcil=@cic and aan_periodo=@ev 
				and rtrim(ltrim(hpl_codmat))+rtrim(ltrim(hpl_descripcion))=@tot and aan_tipo = 'Ordinario'
			)as a
			order by a.nombres
		end
	end -- if @tip = 1 -- pregrado
		
	if @tip = 2 -- maestria
	begin
		select @ev1=penot_codigo,@ev=penot_eval ,@periodo=penot_periodo,@tipo=penot_tipo  
		from web_ra_not_penot_periodonotas_maes  
		where((@fech>=penot_fechaini) and (@fech<=penot_fechafin)and(penot_tipo='Maestria'))

		select @proc = count(1) from web_ra_innot_ingresosdenotas where innot_codemp=@emp and (ltrim(rtrim (innot_codmai)) + ltrim(rtrim(innot_seccion))=@tot)and innot_codcil=@cic and innot_codpenot=@ev1
		select @ev1 as codperio, @ev as eval,@periodo as periodo,@num,@proc as procesada,@tipo as tipo
		
		select tpm_tipo_materia  as Tipo, mat.mat_codigo as codmat, 
		mat.mat_nombre as materia, hpl.hpl_descripcion as secc, aul.aul_nombre_corto as aula, 
		RIGHT('0' + CAST(DATEPART(hh, man.man_hor_ini) as varchar), 2) + ':' + RIGHT('0' + CAST(DATEPART(n, man.man_hor_ini) 
		as varchar), 2) + '-' + RIGHT('0' + CAST(DATEPART(hh, man.man_hor_fin) as varchar), 2) + ':' + RIGHT('0' + CAST(DATEPART(n, 
		man.man_hor_fin) as varchar), 2) as horas, case when isnull(hpl_lunes, 'N') = 'S' then 'L-' else '' end + case when isnull(hpl_martes,
		'N') = 'S' then 'M-' else '' end + case when isnull(hpl_miercoles, 'N') = 'S' then 'Mi-' else '' end + case when isnull(hpl_jueves, 'N') 
		= 'S' then 'J-' else '' end + case when isnull(hpl_viernes, 'N') = 'S' then 'V-' else '' end + case when isnull(hpl_sabado, 'N') 
		= 'S' then 'S-' else '' end + case when isnull(hpl_domingo, 'N') = 'S' then 'D-' else '' end as Dias, empleado.emp_nombres_apellidos as docente
		from pla_emp_empleado as empleado 
			inner join ra_hpl_horarios_planificacion as hpl on hpl.hpl_codemp = emp_codigo 
			inner join ra_tpm_tipo_materias as tpm on hpl_tipo_materia = tpm_tipo_materia 
			inner join ra_mat_materias as mat on mat.mat_codigo = hpl.hpl_codmat 
			inner join ra_esc_escuelas as esc on esc.esc_codigo = mat.mat_codesc 
			inner join ra_fac_facultades as fac on esc.esc_codfac = fac.fac_codigo 
			inner join ra_aul_aulas as aul on aul.aul_codigo = hpl.hpl_codaul 
			inner join ra_man_grp_hor as man on man.man_codigo = hpl.hpl_codman
		where (hpl.hpl_codcil = @cic) and (emp_codigo = @emp) and (ltrim(rtrim(mat.mat_codigo))+ ltrim(rtrim(hpl.hpl_descripcion))= @tot) 
		
		if @ev<>0 and @periodo='Diferido' and @proc=0 and @exdif<>0
		begin
			select distinct per.per_codigo as percodigo, per.per_carnet as carnet, per.per_apellidos_nombres as nombres
			from ra_cil_ciclo as cil
			inner join ra_ins_inscripcion as ins on cil.cil_codigo = ins.ins_codcil 
			inner join ra_per_personas as per on ins.ins_codper = per.per_codigo 
			inner join ra_mai_mat_inscritas as mai on ins.ins_codigo = mai.mai_codins 
			inner join ra_hpl_horarios_planificacion as hpl on mai.mai_codhpl = hpl.hpl_codigo 
			inner join ra_mat_materias as mat on mai.mai_codmat = mat.mat_codigo 
			inner join web_ra_innot_ingresosdenotas as innot on mat.mat_codigo = innot.innot_codmai
			where (cil.cil_codigo =@cic) and (mai.mai_estado = 'I') and (ltrim(rtrim(mat.mat_codigo))+ ltrim(rtrim(hpl.hpl_descripcion))= @tot) 
			and (innot.innot_codpenot=@exdif) and (hpl.hpl_codemp =@emp ) and 
			(
				per.per_codigo not in
				(
					select distinct web_ra_npro_notasprocesadas.npro_alumno
					from web_ra_npro_notasprocesadas inner join
					web_ra_innot_ingresosdenotas on web_ra_npro_notasprocesadas.npro_codinnot = innot.innot_codingre 
					where innot_codemp=@emp and (ltrim(rtrim (innot_codmai))+rtrim(ltrim(innot_seccion))=@tot) 
					and innot_codcil=@cic and innot_tipo='Maestria' and innot_codpenot=@exdif
				)
			)
			order by nombres
		end

		if  @ev<>0 and @periodo='Ordinario' and @proc=0
		begin
			select distinct per.per_codigo as percodigo, per.per_carnet as carnet, per.per_apellidos_nombres as nombres
			from ra_cil_ciclo as cil
				inner join ra_ins_inscripcion as ins on cil.cil_codigo = ins.ins_codcil 
				inner join ra_per_personas as per on ins.ins_codper = per.per_codigo 
				inner join ra_mai_mat_inscritas as mai on ins.ins_codigo = mai.mai_codins 
				inner join ra_hpl_horarios_planificacion as hpl on mai.mai_codhpl = hpl.hpl_codigo 
				inner join ra_mat_materias as mat on mai.mai_codmat = mat.mat_codigo
			where (cil.cil_codigo = @cic) and (mai.mai_estado = 'I') 
			and (ltrim(rtrim(mat.mat_codigo))+ ltrim(rtrim(hpl.hpl_descripcion))= @tot) and(hpl.hpl_codemp=@emp)
			order by nombres
		end
	end -- if @tip = 2 -- maestria

	if @tip=3--Especialidad
	begin
		declare @tipMod nvarchar(2), @codhmp int, @d varchar(100), 
		@hor nvarchar(25), @aula nvarchar(30),@codmatpre nvarchar(100), 
		@ordenMod int

		print '@tot: ' + @tot
		print '---------------------------------'

		set @tipMod = right(@tot,2)
		set @tot = replace(@tot,right(@tot,2),'')

		print '@tipMod: '+ @tipMod
		print '@tot: '+ @tot
		print '---------------------------------'

		if @tipMod = 'MP'
		begin
			select top 1 @codmatpre = (cast(hmp_codapr as nvarchar(100))+cast(hmp_descripcion as nvarchar(100))) 
			from pg_hmp_horario_modpre where cast(hmp_codigo as nvarchar(100))=@tot

			select @ordenMod = mpr_orden, @codpre = mpr_codpre, @seccion = hmp_descripcion, @cic = pre_codcil 
			from pg_hmp_horario_modpre
				inner join pg_mpr_modulo_preespecializacion on mpr_codigo = hmp_codmpr
				inner join pg_pre_preespecializacion on pre_codigo = mpr_codpre
			where cast(hmp_codigo as nvarchar(100))=@tot

			print '@codmatpre: ' + @codmatpre
			print '@codpre: ' + cast(@codpre as nvarchar(20))
			print '@seccion: ' + @seccion
			print '@ordenMod: '+ cast(@ordenMod as nvarchar(2))
			print '-------------------------------'

			select @ciclo_pre = max(apr_codcil) 
			from  dbo.pg_hmp_horario_modpre 
				inner join pg_apr_aut_preespecializacion on hmp_codapr=apr_codigo
			where (ltrim(rtrim(pg_hmp_horario_modpre.hmp_codapr)) + ltrim(rtrim(pg_hmp_horario_modpre.hmp_descripcion))= @codmatpre)
			print '@fech: ' + cast(@fech as varchar(25))
			select @ev1 = penot_codigo, @ev = penot_eval, @periodo = penot_periodo,@tipo = penot_tipo  
			from web_pg_not_penot_periodonotas
			where((@fech>=penot_fechaini) and (@fech<=penot_fechafin)and(penot_tipo='Preespecialidad'))
			select @proc=count(1)
			from web_pg_innot_ingresosdenotas 
			where innot_codemp=@emp and (ltrim(rtrim (innot_codmai)) + ltrim(rtrim(innot_seccion))=@codmatpre) 
			and innot_codcil=@ciclo_pre and innot_codpenot=@ev1

			----***Primer Resultado muestra el periodo de evaluacion
			SELECT @ev1 as codperio, @ev as eval,@periodo as periodo,@num,@proc as procesada,@tipo as tipo
			----***Segundo resultado muestra la informacion del docente y los horarios
			-- select * from web_pg_innot_ingresosdenotas where innot_codemp = 3525 and innot_codcil = 116
			select @hor = man_nomhor, @aula = aul_nombre_corto,
			@d = (substring(lunes + martes + miercoles + jueves + viernes + sabado + domingo,1,
			len(lunes + martes + miercoles + jueves + viernes + sabado + domingo) - 1))
			from (
				select max(man_nomhor) man_nomhor,max(aul_nombre_corto) aul_nombre_corto,max(lunes) lunes, max(martes) martes,
				max(miercoles) miercoles, max(jueves) jueves, max(viernes) viernes, max(sabado) sabado, max(domingo) domingo
				from ( 
					select man_nomhor,aul_nombre_corto,dhm_codhmp,case when dhm_dia = 1 then 'Lunes-' else '' end lunes,
					case when dhm_dia = 2 then 'Martes-' else '' end martes,
					case when dhm_dia = 3 then 'Miercoles-' else '' end miercoles,
					case when dhm_dia = 4 then 'Jueves-' else '' end jueves,
					case when dhm_dia = 5 then 'Viernes-' else '' end viernes,
					case when dhm_dia = 6 then 'Sabado-' else '' end sabado,
					case when dhm_dia = 7 then 'Domingo-' else '' end domingo
					from pg_dhm_det_hor_hmp
					inner join ra_aul_aulas on aul_codigo = dhm_aula
					inner join ra_man_grp_hor on man_codigo = dhm_codman
					where dhm_codhmp = (
						select hmp_codigo from pg_hmp_horario_modpre inner join pg_mpr_modulo_preespecializacion on mpr_codigo = hmp_codmpr
						where mpr_visible = 'N' and 
						(cast(hmp_codapr as nvarchar(100))+cast(hmp_descripcion as nvarchar(100))) = @codmatpre
					)
				) ab
			) bc

			select @d Dias, @aula aula, @hor horas, pre_nombre +' ('+ mpr_nombre+')' materia,apr_codigo codmat, 
			hmp_descripcion secc, emp_nombres_apellidos docente,cil_codigo 
			from pg_hmp_horario_modpre 
				inner join pg_mpr_modulo_preespecializacion on mpr_codigo = hmp_codmpr
				inner join pg_pre_preespecializacion on pre_codigo = mpr_codpre
				inner join pg_apr_aut_preespecializacion on apr_codpre = pre_codigo
				inner join pla_emp_empleado on emp_codigo = hmp_codcat
				inner join ra_cil_ciclo on cil_codigo = apr_codcil
			where  cast(hmp_codigo as nvarchar(20))=@tot --and mpr_orden = @ev

			---***** Tercer Resultado donde muestra el listado

			declare @tbl table(
				per_codigo int, per_carnet nvarchar(15), 
				per_apellidos_nombres nvarchar(150), cuotasc int, 
				ciclo nvarchar(20), pre_nombre nvarchar(200), 
				hmp_descripcion nvarchar(5), estado nvarchar(25)
			)

			--[web_not_alumnospormateria]  117, 3525, 3, '2717MP', 1, 3
			print '@periodo: *' + cast(@periodo as varchar(25))
			print '@proc: ' + cast(@proc as varchar(25))
			print '@exdif: ' + cast(@exdif as varchar(25))
			print '@ordenMod: ' + cast(@ordenMod as varchar(25))
			print '@ev: *' + cast(@ev as varchar(25))

			if @ordenMod = @ev
			begin
				if @ev<>0 and @periodo='Diferido' and @proc=0 and @exdif<>0 --and @ordenMod = @ev
				begin
					--[web_not_alumnospormateria]  117, 4083, 3, '2807MP', 1, 3
					print 'DIFERIDO'
					PRINT '@codcil:' + CAST(@cic AS NVARCHAR(15)) +' @codpre'+ CAST(@codpre AS NVARCHAR(15)) +' @ev:' +CAST(@ev AS NVARCHAR(15))
					PRINT '---------------------------------------------------'
					insert into @tbl
					(per_codigo , per_carnet , per_apellidos_nombres , cuotasc , ciclo, pre_nombre, hmp_descripcion, estado)
					exec rep_pg_list_alum_solv_insol @cic,@codpre,@seccion,@ev,'D' --	Agregado por Fabio el 26/11/2018 para los alumnos que realizaran el examen diferido
					-- rep_pg_list_alum_solv_insol 117, 597, '01', 3, 'D'
					print 'rep_pg_list_alum_solv_insol: '+ cast(@cic as varchar(15)) +', '+cast(@codpre as varchar(15)) +', '+cast(@seccion as varchar(15)) +', '+cast(@ev as varchar(15)) +', D'
				end -- if @ev<>0 and @periodo='Diferido' and @proc=0 and @exdif<>0

				if  @ev<>0 and @periodo='Ordinario' and @proc=0  --and @ordenMod = @ev
				begin
							 
					-- [web_not_alumnospormateria]  117, 3525, 3, '2717MP', 0, 0
					--rep_pg_list_alum_solv_insol 117, 597, 01, 1, 'S'
					print 'ORDINARIO'
					PRINT '@codcil:' + CAST(@cic AS NVARCHAR(15)) +', @codpre'+ CAST(@codpre AS NVARCHAR(15)) +', @ev:' +CAST(@ev AS NVARCHAR(15)) +', @seccion:' + @seccion
					PRINT '---------------------------------------------------'
					Print 'Error'
					insert into @tbl
					(per_codigo, per_carnet, per_apellidos_nombres, cuotasc, ciclo, pre_nombre, hmp_descripcion, estado)
										
					exec rep_pg_list_alum_solv_insol @cic,@codpre,@seccion,@ev,'S'
					print 'rep_pg_list_alum_solv_insol: '+ cast(@cic as varchar(15)) +', '+cast(@codpre as varchar(15)) +', '+cast(@seccion as varchar(15)) +', '+cast(@ev as varchar(15)) +', S'
				end -- if  @ev<>0 and @periodo='Ordinario' and @proc=0
			end
						   
			select distinct per_codigo as percodigo , per_carnet as carnet, per_apellidos_nombres as nombres ,
			pre_nombre as mpr_nombre , @cic as cil_codigo
			from @tbl
			order by per_apellidos_nombres
		end

		if @tipMod = 'ME'
		begin
			select @codmatpre = cast(hm_codigo as nvarchar(25))+hm_descripcion 
			from pg_hm_horarios_mod where cast(hm_codigo as nvarchar(20)) = @tot

			print '@codmatpre: '+ @codmatpre

			select @ev1 = penot_codigo, @ev = penot_eval, @periodo = penot_periodo, @tipo = penot_tipo  
			from --web_pg_not_penot_periodonotas  
			web_pg_pnme_per_not_mod_esp 
			where((@fech>=penot_fechaini) and (@fech<=penot_fechafin)and(penot_tipo='Preespecialidad'))

			select @proc=count(1)
			from web_pg_innot_ingresosdenotas 
			where innot_codemp=@emp 
			and (ltrim(rtrim (innot_codmai)) + ltrim(rtrim(innot_seccion))=@codmatpre) --and innot_codcil=@ciclo_pre 
			and innot_codpenot=case when @ev >= 1 then 13 when @ev >= 2 then 14 end

			----***Primer Resultado muestra el periodo de evaluacion
			SELECT @ev1 as codperio, @ev as eval,@periodo as periodo,@num,@proc as procesada,@tipo as tipo

			print '@ev : ' + cast(@ev as nvarchar(5))

			select CASE WHEN Dias <> '' THEN substring(Dias,1,len(Dias)-1) ELSE Dias END Dias, aula, horas, materia, 
				codmat, sec secc, docente, cil_codigo 
			from (
				SELECT CASE WHEN hm_lunes = 'S' then 'Lunes-' else '' end + CASE WHEN hm_martes = 'S' then 'Martes-' else '' end +CASE WHEN hm_miercoles = 'S' then 'Miercoles-'  else '' end +
				CASE WHEN hm_jueves = 'S' then 'Jueves-' else '' end + CASE WHEN hm_viernes = 'S' then 'Viernes-'  else '' end + CASE WHEN hm_sabado = 'S' then 'Sabado-' else '' end +
				CASE WHEN hm_domingo = 'S' then 'Domingo-' else ''  end Dias, aul_nombre_corto aula, man_nomhor horas, 'General '+hm_nombre_mod materia, 
				hm_codigo  codmat, hm_descripcion sec, emp_nombres_apellidos docente, hm_codcil cil_codigo
				FROM pg_hm_horarios_mod 
				join pla_emp_empleado on emp_codigo = hm_codemp
				join ra_aul_aulas on aul_codigo = hm_codaul
				join ra_man_grp_hor on man_codigo = hm_codman
				WHERE cast(hm_codigo as nvarchar(20)) = @tot --and hm_codcil = @cic
			) a

			if  @ev<>0 and @periodo='Diferido' and @proc=0 and @exdif<>0 
			begin
				select per_codigo as percodigo , per_carnet as carnet , per_apellidos_nombres as nombres ,
				hm_nombre_mod as mpr_nombre, hm_codcil as cil_codigo
				from pg_insm_inscripcion_mod 
				join ra_per_personas on per_codigo = insm_codper
				join pg_hm_horarios_mod on hm_codigo = insm_codhm
				where cast(hm_codigo as nvarchar(20)) = @tot --and hm_codcil = @cic 
				and case when hm_modulo = 9 then 1 when hm_modulo = 10 then 2 else 0 end = @ev
				order by per_apellidos_nombres
			end


			if  @ev<>0 and @periodo='Ordinario' and @proc=0
			begin
				select per_codigo as percodigo , per_carnet as carnet , per_apellidos_nombres as nombres ,
				hm_nombre_mod as mpr_nombre, hm_codcil as cil_codigo
				from pg_insm_inscripcion_mod 
				join ra_per_personas on per_codigo = insm_codper
				join pg_hm_horarios_mod on hm_codigo = insm_codhm
				where cast(hm_codigo as nvarchar(20)) = @tot --and hm_codcil = @cic 
				and case when hm_modulo = 9 then 1 when hm_modulo = 10 then 2 else 0 end = @ev
				order by per_apellidos_nombres
			end
		end

	end -- if @tip = 3 -- Especialidad

end