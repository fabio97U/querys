USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_certificacion_notas]    Script Date: 16/2/2023 11:04:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	
	-- exec dbo.rep_certificacion_notas '25-2574-2015', '@cuidad', '15/02/2023', '@rector', '@confronto', '@elaboro', 'S', '@cargo_firma' -- Por estudiante
	-- exec dbo.rep_certificacion_notas '0', '@cuidad', '15/02/2023', '@rector', '@confronto', '@elaboro', 'S', '@cargo_firma', @codcil_pre = 122, @cuotas_pagadas = 0, @modulos_aprobados = 0 -- Masivo
ALTER proc [dbo].[rep_certificacion_notas] 
	@carnet varchar(12),
	@cuidad varchar(25),
	@fecha varchar(10),
	@rector varchar(60),
	@confronto varchar(60),
	@elaboro varchar(60),
	@limpio varchar(1), --S: Si, N: No
	@cargo_firma varchar(100) = '',

	@codcil_pre int = 0, --0: No se filtra por ciclo de pre
	@cuotas_pagadas int = 0,--0: No importa, 1...10: "x" cuotas pagadas preespecialidad
	@modulos_aprobados int = 0--0: No importa, 1...8: "x" modulos aprobados preespecialidad
as
BEGIN

	declare @mcodper int = 0
	declare @tbl_estudiantes_evaluar as table(codimp int, pre_nombre varchar(125), sexo varchar(5), codper int, carnet varchar(20), codcil int, cuotas_pagadas int, modulos_aprobados int)
	if (@carnet = '0') set @carnet = ''

	if @carnet <> '' -- Es solo un estudiante
		select @mcodper = per_codigo from ra_per_personas where per_carnet = @carnet

	if @codcil_pre <> 0
	begin
		print 'Es filtro de codcil preespecialidad'

		insert into @tbl_estudiantes_evaluar (codimp, pre_nombre, sexo, codper, carnet, codcil, cuotas_pagadas, modulos_aprobados)
		select codimp, pre_nombre, sexo, codper, carnet, codcil, 
		(
			select COUNT(distinct(are_cuota)) from col_mov_movimientos 
				join col_dmo_det_mov on dmo_codmov = mov_codigo
				join vst_Aranceles_x_Evaluacion v on v.are_codtmo = dmo_codtmo
			where dmo_codcil = t.codcil and mov_codper = t.codper and are_cuota <> 0 and mov_estado <> 'A'
		) cuotas, 
		(
			SELECT isnull(sum(apro),0) apro FROM (
			select iif(round(nmp_nota, 2) >= 6.96, 1, 0) apro from pg_imp_ins_especializacion
				inner join pg_nmp_notas_mod_especializacion on nmp_codimp = imp_codigo
			where imp_codigo = codimp and nmp_bandera = 1
			) t
		) aprobados
		from (
			select max(imp_codigo) 'codimp', imp_codper 'codper', per_carnet 'carnet', max(apr_codcil) 'codcil', per_sexo 'sexo', pre_nombre
			from pg_imp_ins_especializacion 
				inner join pg_apr_aut_preespecializacion on imp_codapr = apr_codigo
				inner join ra_per_personas on imp_codper = per_codigo
				
				inner join pg_pre_preespecializacion on pre_codigo = apr_codpre

			where apr_codcil = @codcil_pre--1,379 
				--and imp_codper in (181324, 182420)--and imp_estado = 'I'
				--and imp_codper in (5549, 6968)--and imp_estado = 'I'
				and imp_codper = case when @carnet = '' then imp_codper else @mcodper end
			group by imp_codigo, apr_codcil, imp_codper, per_carnet, per_sexo, pre_nombre
		) t

		if (@cuotas_pagadas <> 0)
		begin
			delete from @tbl_estudiantes_evaluar where cuotas_pagadas < @cuotas_pagadas
		end

		if (@modulos_aprobados <> 0)
		begin
			delete from @tbl_estudiantes_evaluar where modulos_aprobados < @modulos_aprobados
		end
	end
	else
	begin
		insert into @tbl_estudiantes_evaluar (codimp, pre_nombre, sexo, codper, carnet, codcil, cuotas_pagadas, modulos_aprobados)
		values (0, '', '', @mcodper, @carnet, 0, 0, 0)
	end

	declare @c_codimp int = 0, @c_pre_nombre varchar(125) = '', @c_sexo varchar(5), @c_codper int = 0, @c_carnet varchar(20) = '', 
		@c_codcil int = 0, @c_cuotas_pagadas int = 0, @c_modulos_aprobados int = 0, @contador int = 1, @total int = 0
	select @total = count(1) from @tbl_estudiantes_evaluar

	
	declare @record_final table (
		Lugar varchar(150),fecha varchar(200),lee_firma varchar(10),fac_nombre varchar(100),confronto varchar(150),
		elaboro varchar(150),Secretaria varchar(150),Rector varchar(150),cil_codigo varchar(50),uni_nombre varchar(150),per_carnet varchar(15),
		per_nombres_apellidos varchar(200),car_nombre varchar(150),reg_nombre varchar(100),UV int,equ_codist int,cic_nombre varchar(50),
		mat_codigo varchar(50),mat_nombre varchar(150),nota real,estado varchar(50),nota_letras varchar(100),ciclo_min varchar(150),
		ciclo_max varchar(150),uni_nota_minima real,uni_nota_minima_letras varchar(100),total_aprobadas int,materias_aprobadas varchar(100),
		materias_reprobadas int,total_aprobadas_letras varchar(200),materias_aprobadas_letras varchar(200),
		materias_reprobadas_letras varchar(200), not_num real,cum_n real,cum_n_letras varchar(200),equ varchar(100),
		equ_concedidas varchar(200),plm_uv int,matriculado varchar(50),GloPa varchar(20),
		cil_anio int, cil_codcic int, plm_anio_carrera int, plm_ciclo int, codcil_real int, cargo_firma varchar(125), nombre_preesp varchar(125)
	)

	declare @record_uno_a_uno table (
		Lugar varchar(150),fecha varchar(200),lee_firma varchar(10),fac_nombre varchar(100),confronto varchar(150),
		elaboro varchar(150),Secretaria varchar(150),Rector varchar(150),cil_codigo int,uni_nombre varchar(150),per_carnet varchar(15),
		per_nombres_apellidos varchar(200),car_nombre varchar(150),reg_nombre varchar(100),UV int,equ_codist int,cic_nombre varchar(50),
		mat_codigo varchar(50),mat_nombre varchar(150),nota real,estado varchar(50),nota_letras varchar(100),ciclo_min varchar(150),
		ciclo_max varchar(150),uni_nota_minima real,uni_nota_minima_letras varchar(100),total_aprobadas int,materias_aprobadas varchar(100),
		materias_reprobadas int,total_aprobadas_letras varchar(200),materias_aprobadas_letras varchar(200),
		materias_reprobadas_letras varchar(200), not_num real,cum_n real,cum_n_letras varchar(200),equ varchar(100),
		equ_concedidas varchar(200),plm_uv int,matriculado varchar(50),GloPa varchar(20),
		cil_anio int, cil_codcic int, plm_anio_carrera int, plm_ciclo int, codcil_real int
	)

	declare m_cursor cursor 
	for
		select codimp, pre_nombre, sexo, codper, carnet, codcil, cuotas_pagadas, modulos_aprobados from @tbl_estudiantes_evaluar   
	open m_cursor
 
	fetch next from m_cursor into @c_codimp, @c_pre_nombre, @c_sexo, @c_codper, @c_carnet, @c_codcil, @c_cuotas_pagadas, @c_modulos_aprobados
	while @@FETCH_STATUS = 0 
	begin
		print '*** ' + cast(@contador as varchar(5)) + '/' + cast(@total as varchar(5)) + ' ***' 
		print '@c_codimp: ' + cast(@c_codimp as varchar(20))
		print '@c_sexo: ' + cast(@c_sexo as varchar(20))
		print '@c_codper: ' + cast(@c_codper as varchar(20))
		print '@c_carnet: ' + cast(@c_carnet as varchar(20))
		print '@c_codcil: ' + cast(@c_codcil as varchar(20))
		print '@c_cuotas_pagadas: ' + cast(@c_cuotas_pagadas as varchar(20))
		print '@c_modulos_aprobados: ' + cast(@c_modulos_aprobados as varchar(20))
		set @carnet = @c_carnet

		--Proceso de uno a uno
		begin -- Inicio: Proceso original de uno a uno, se uso el mismo proceso de uno a uno para no alterar ningun resultado
			declare @codper int = @c_codper, @aprobadas int, @reprobadas int, @tipo_alumno nvarchar(5),
			@equivalencias int, @nota_minima real, @unidades int, @uv_plan int, @codpla_act int, @cum_n real, 
			@cum real,@car_nombre varchar(100), @incripciones int, @cil_codigo int, @nmat_plan int
			declare @alias_carrera nvarchar(300) = ''

			if (select cic_orden from ra_cic_ciclos join ra_cil_ciclo on cil_codcic = cic_codigo where cil_vigente = 'S') = 3
			BEGIN
				if (select count(1) from ra_ins_inscripcion join ra_cil_ciclo on cil_codigo = ins_codcil 
				join ra_cic_ciclos on cic_codigo = cil_codcic join ra_per_personas on per_codigo = ins_codper 
				where per_carnet = @carnet and cic_orden = 2 and year(ins_fecha) = year(getdate())) >= 1
				begin
					select @cil_codigo = cil_codigo from ra_ins_inscripcion 
					join ra_cil_ciclo on cil_codigo = ins_codcil 
					join ra_cic_ciclos on cic_codigo = cil_codcic 
					join ra_per_personas on per_codigo = ins_codper 
					where per_carnet = @carnet and cic_orden = 2 and year(ins_fecha)=year(getdate())
				end
				else
				begin
					set @cil_codigo = 0
				end
			end
			else
			begin
				set @cil_codigo = 0	
			end

			select @codper = per_codigo, @codpla_act = alc_codpla, @nmat_plan = pla_n_mat, 
				@alias_carrera = replace(pla_alias_carrera,'NO PRESENCIAL', ''), @tipo_alumno = per_tipo 
			from ra_per_personas
				join ra_alc_alumnos_carrera on alc_codper = per_codigo
				INNER JOIN ra_pla_planes ON ra_alc_alumnos_carrera.alc_codpla = ra_pla_planes.pla_codigo
			where per_codigo = @codper

			print '@nmat_plan: ' + cast(@nmat_plan as nvarchar(10))

			select @cum_n = dbo.cum_repro(@codper)
			select @cum = dbo.cum(@codper)
	
			select @nota_minima = iif(@tipo_alumno = 'U',uni_nota_minima, uni_pnota_minima)
			from ra_reg_regionales, ra_uni_universidad
			where reg_codigo = 1 and uni_codigo = reg_coduni

			declare @ra_mai_mat_inscritas_h_v table(
				codper int, codcil int,
				mai_codigo int, mai_codins int,
				mai_codmat varchar(10) collate Modern_Spanish_CI_AS,
				mai_absorcion varchar(1), mai_financiada varchar(1),
				mai_estado varchar(1), mai_codhor int, mai_matricula int, mai_acuerdo varchar(20), mai_fecha_acuerdo datetime,
				mai_codmat_del varchar(10) collate Modern_Spanish_CI_AS,
				fechacreacion datetime, mai_codpla int, mai_uv int, mai_tipo varchar(1), mai_codhpl int
			) 

			declare @notas table(
				ins_codreg int, ins_codigo int, ins_codcil int, ins_codper int, mai_codigo int,
				mai_codmat varchar(10) collate Modern_Spanish_CI_AS,
				mai_codhor int, mai_matricula int, estado varchar(1), mai_codpla int,
				absorcion_notas varchar(1), uv int, nota float, mai_codhpl int
			)

			insert into @ra_mai_mat_inscritas_h_v 
			(codper, codcil, mai_codigo, mai_codins, mai_codmat, mai_absorcion, mai_financiada, mai_estado, mai_codhor, mai_matricula,
				mai_acuerdo, mai_fecha_acuerdo, mai_codmat_del, fechacreacion, mai_codpla, mai_uv, mai_tipo, mai_codhpl)
			select codper, codcil, mai_codigo, mai_codins, mai_codmat, mai_absorcion, mai_financiada, mai_estado, mai_codhor, mai_matricula,
				mai_acuerdo, mai_fecha_acuerdo, mai_codmat_del, fecha_creacion, mai_codpla, mai_uv, mai_tipo, mai_codhpl
			from ra_mai_mat_inscritas_h_v
			where codper = @codper and mai_codpla = @codpla_act

			insert into @notas (ins_codreg, ins_codigo, ins_codcil, ins_codper, mai_codigo, mai_codmat, mai_codhor, mai_matricula, estado, mai_codpla, 
				absorcion_notas, uv, nota)
			select ins_codreg, ins_codigo, ins_codcil, ins_codper, mai_codigo, mai_codmat, mai_codhor, mai_matricula, estado, mai_codpla, 
				absorcion_notas, uv, nota 
			from notas
			where ins_codper = @codper and mai_codpla = @codpla_act

					
			select @aprobadas = sum(a) 
			from (
				select count(distinct b.mai_codmat) a 
				from @notas b,ra_alc_alumnos_carrera, ra_plm_planes_materias
				where b.ins_codper = @codper and round(b.nota,1) >= @nota_minima
					and alc_codper = b.ins_codper and plm_codpla = alc_codpla and plm_codmat = b.mai_codmat
					and ins_codcil not in (
						select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' 
						union 
						select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S'
					)
					and not exists 
					(select 1 from ra_equ_equivalencia_universidad
						join ra_eqn_equivalencia_notas on eqn_codequ = equ_codigo
					where equ_codper = alc_codper and eqn_codmat = plm_codmat and eqn_nota > 0)
			
					union all
		
				select count(distinct eqn_codmat) 
				from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,
					ra_alc_alumnos_carrera, ra_plm_planes_materias
				where equ_codigo = eqn_codequ and equ_codper = @codper
					and eqn_nota > 0 and alc_codper = equ_codper and plm_codpla = alc_codpla and plm_codmat = eqn_codmat
			) t 

			select @reprobadas = count(1)
			from @notas b,ra_alc_alumnos_carrera, ra_plm_planes_materias
			where b.ins_codper = @codper
				and b.ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S'  union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
				and b.estado = 'I' and round(b.nota,1) < @nota_minima
				and alc_codper = b.ins_codper and plm_codpla = alc_codpla and plm_codmat = b.mai_codmat

			if @limpio = 'S' set @reprobadas = 0

			select @equivalencias = count(distinct eqn_codmat) 
			from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas, 
			ra_alc_alumnos_carrera, ra_plm_planes_materias
			where equ_codigo = eqn_codequ and equ_codper = @codper and eqn_nota > 0 
				and equ_tipo = 'E' and alc_codper = equ_codper and plm_codpla = alc_codpla and plm_codmat = eqn_codmat

			select @uv_plan = sum(plm_uv)
			from ra_plm_planes_materias, ra_alc_alumnos_carrera
			where plm_ciclo <> 0 and plm_anio_carrera <> 0 and plm_codpla = alc_codpla and alc_codper = @codper

			select @unidades = sum(uv)
			from (
				select plm_uv uv
				from @notas b,
					ra_alc_alumnos_carrera, ra_plm_planes_materias
				where b.ins_codper = @codper and round(b.nota,1) >= @nota_minima
				and alc_codper = b.ins_codper and plm_codpla = alc_codpla and plm_codmat = b.mai_codmat
				and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')

					union all

				select plm_uv
				from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,
				ra_alc_alumnos_carrera, ra_plm_planes_materias
				where equ_codigo = eqn_codequ and equ_codper = @codper
				and eqn_nota > 0 and alc_codper = equ_codper and plm_codpla = alc_codpla and plm_codmat = eqn_codmat
			) t

			if @unidades > @uv_plan set @unidades = @uv_plan

			if @limpio = 'N'
			begin
				/*INSERTA MATERIAS GENERALES (APROBADAS Y REPROBADAS)*/
				insert into @record_uno_a_uno (Lugar, fecha, lee_firma, fac_nombre, confronto, elaboro, Secretaria, Rector, cil_codigo, uni_nombre, per_carnet,
				per_nombres_apellidos, car_nombre, reg_nombre, UV, equ_codist, cic_nombre, mat_codigo, mat_nombre, nota, estado, nota_letras, ciclo_min,
				ciclo_max, uni_nota_minima, uni_nota_minima_letras, total_aprobadas, materias_aprobadas, materias_reprobadas, total_aprobadas_letras,
				materias_aprobadas_letras, materias_reprobadas_letras, not_num, cum_n, cum_n_letras, equ, equ_concedidas, plm_uv, matriculado, GloPa,
		
				cil_anio, cil_codcic, plm_anio_carrera, plm_ciclo, codcil_real)

				select @cuidad Lugar,dbo.fn_crufl_FechaALetras(convert(datetime,@fecha,103),1,1) fecha,
				'' lee_firma,fac_nombre,@confronto confronto, @elaboro elaboro,
				'' Secretaria,@rector Rector,cil_codigo,uni_nombre, per_carnet, per_nombres_apellidos, 
				car_nombre as car_nombre, reg_nombre, @unidades UV,equ_codist,
				case when cil_codigo = 0 and equ_codist <> 711 then 'Eq.Externa' when  cil_codigo = 0 and equ_codist = 711 then 'Eq. Interna'  else
				substring(cic_nombre,7,8) + ' - ' + CAST(cil_anio as varchar) end cic_nombre,
				mat_codigo, mat_nombre, nota nota, estado estado, '(' + upper(dbo.NotaALetras(nota)) + ')' nota_letras,
				ciclo_min, ciclo_max, iif(@tipo_alumno = 'U',uni_nota_minima, uni_pnota_minima) uni_nota_minima, 
				upper(dbo.NotaALetras(iif(@tipo_alumno = 'U',uni_nota_minima, uni_pnota_minima))) uni_nota_minima_letras,
				materias_aprobadas total_aprobadas,
				case when materias_equivalencia > 0 then 
				'('+cast(materias_aprobadas as varchar) + ') aprobadas ' + 'En esta Institucion ' 
				else
				'' end materias_aprobadas, 
				materias_reprobadas,
				dbo.MateriasALetras(materias_aprobadas) total_aprobadas_letras,
				case when materias_equivalencia > 0 then 
				dbo.MateriasALetras(materias_aprobadas) + '('+cast(materias_aprobadas as varchar) + ') aprobadas ' + 'En esta Institucion ' 
				else
				'' end materias_aprobadas_letras, 
				dbo.MateriasALetras(materias_reprobadas) materias_reprobadas_letras, not_num,round(cum_n,1) cum_n,
				dbo.NotaALetras(round(cum_n,1)) cum_n_letras,
				case when cil_codigo = 0 then 'EQUIVALENCIAS' else '' end equ,
				case when materias_equivalencia > 0 then
				dbo.MateriasALetras(materias_equivalencia) + '(' + cast(materias_equivalencia as varchar) + ')' +
				' asignaturas concedidas por equivalencia ' else '' end equ_concedidas,
				plm_uv, matriculado, case when materias_aprobadas >= @nmat_plan then 'global' else 'parcial' end GloPa,

				cil_anio, cil_codcic, plm_anio_carrera, plm_ciclo, cil_codigo
				from
				/*SUBCONSULTA GENERAL PARA OBTENER TODOS LAS CONDICIONES DE LA CONSULTA*/
				(
					select plm_anio_carrera, plm_ciclo, cil_codcic,cil_codigo,uni_nombre, per_carnet, per_nombres_apellidos, uni_nota_minima, uni_pnota_minima,
					fac_nombre, car_nombre as car_nombre, reg_nombre, cic_nombre, cil_anio, per_acta_equivalencia,
					mat_codigo, mat_nombre, per_resolucion_equivalencia, per_fecha_equivalencia,plm_uv, equ_codist,
					case when per_sexo = 'M' then ' matriculado '  else ' matriculada ' end matriculado,
					round(isnull((select sum(nota)
				/*SUBCONSULTA EXCLUSIÓN EQUIVALENCIAS*/
				from
				(
					(select isnull(nota,0) nota 
					from @notas 
					where ins_codper = codper
					and mai_codmat = codmat_del
					and ins_codcil = cil_codigo
					and mat_codigo not in  (select eqn_codmat
									from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
									where eqn_codequ = equ_codigo
									and equ_codper = @codper
									and eqn_nota > 0)
					union all
					/*UNION CON OTRA CONSULTA PARA OBTENER LAS EQUIVALENCIAS*/
					select isnull(round(avg(eqn_nota),1),0)
					from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad
					where eqn_codequ = equ_codigo
					and eqn_codmat = mat_codigo
					and equ_codper = codper
					and eqn_nota > 0
					)
				) t)
				,0),1) nota, 

				isnull((select sum(nota)
				from
				/*CONSICION PARA EQUIVALENCIAS*/
				(
				(select isnull(nota,0)  nota
				from @notas 
				where ins_codper = codper
				and mai_codmat = codmat_del
				and ins_codcil = cil_codigo
				and mat_codigo not in  (select eqn_codmat
								from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
								where eqn_codequ = equ_codigo
								and equ_codper = @codper
								and eqn_nota > 0)
					
				union all
				/*UNION CON OTRA CONSULTA*/
				select isnull(round(avg(eqn_nota),1),0)
				from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad
				where eqn_codequ = equ_codigo
				and eqn_codmat = mat_codigo
				and equ_codper = codper
				and eqn_nota > 0
				))t ),0) not_num,

				CASE WHEN mai_estado = 'I' then case when isnull((select sum(nota)
				from
				(
				(select isnull(nota,0) nota
				from @notas 
				where ins_codper = codper
				and mai_codmat = codmat_del
				and ins_codcil = cil_codigo
				and mat_codigo not in  (select eqn_codmat
								from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
								where eqn_codequ = equ_codigo
								and equ_codper = @codper
								and eqn_nota > 0)
				union all
				select isnull(round(avg(eqn_nota),1),0)
				from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad
				where eqn_codequ = equ_codigo
				and eqn_codmat = mat_codigo
				and equ_codper = codper
				and eqn_nota > 0
				)) t ),0) < 
				(select cast(iif(@tipo_alumno = 'U',uni_nota_minima, uni_pnota_minima) as real) 
				from ra_uni_universidad 
				join ra_reg_regionales on uni_codigo = reg_coduni 
				join ra_per_personas on reg_codigo = per_codreg 
				where per_codigo = codper) 
				THEN 'Reprobada' ELSE 'Aprobada' END else 'Retirada' end estado, 

				(select cic_nombre + ' del año academico ' + cast(cil_anio as varchar) 
				from ra_cil_ciclo, ra_cic_ciclos
				where cic_codigo = cil_codcic
				and cast(cil_anio as varchar) + cast(cil_codigo as varchar) =
				(select min(cast(cil_anio as varchar) + cast(cil_codigo as varchar))
				from ra_cil_ciclo, ra_ins_inscripcion
				where ins_codper = codper
				and cil_codigo = ins_codcil)) ciclo_min,
				(select cic_nombre + ' del año academico ' + cast(cil_anio as varchar) 
				from ra_cil_ciclo, ra_cic_ciclos
				where cic_codigo = cil_codcic
				and cast(cil_anio as varchar) + cast(cil_codigo as varchar) = 
				(select max(cast(cil_anio as varchar) + cast(cil_codigo as varchar))
				from ra_cil_ciclo, ra_ins_inscripcion
				where ins_codper = codper
				and cil_codigo = ins_codcil)) ciclo_max,

				@equivalencias  materias_equivalencia,

				@aprobadas materias_aprobadas,

				@reprobadas materias_reprobadas,

				@cum_n cum_n
				from
				(
					select cil_codcic,cil_codigo,uni_nombre, ins_codper codper, per_carnet, 
					per_nombres_apellidos, per_sexo,
					--car_nombre_legal as car_nombre, 
					@alias_carrera as car_nombre, reg_nombre, mat_codigo, isnull(plm_alias,mat_nombre) mat_nombre, cic_nombre, cil_anio, fac_nombre, 
					uni_nota_minima, uni_pnota_minima,
					pla_codigo codpla, per_codreg codreg,  per_resolucion_equivalencia, per_fecha_equivalencia,0 equ_codist,
					plm_uv, mai_codmat_del codmat_del,per_acta_equivalencia, mai_estado,

					plm_anio_carrera, plm_ciclo
					from @ra_mai_mat_inscritas_h_v, ra_mat_materias, ra_per_personas,
					ra_uni_universidad, ra_reg_regionales, ra_ins_inscripcion, 
					ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras,
					ra_cil_ciclo, ra_cic_ciclos, ra_fac_facultades, ra_plm_planes_materias
					where per_carnet = @carnet
					and ins_codper = per_codigo
					and reg_codigo = per_codreg
					and uni_codigo = reg_coduni
					and alc_codper = per_codigo
					and alc_codpla = pla_codigo
					and car_codigo = pla_codcar
					and cil_codigo = ins_codcil
					and cic_codigo = cil_codcic
					and mai_codins = ins_codigo
					and mai_codmat = mat_codigo
					--and mai_estado = 'I'
					and fac_codigo = car_codfac
					and plm_codpla = alc_codpla
					and plm_codmat = mat_codigo
					and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_CODIGO = @cil_codigo) and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente ='S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
					and mai_codmat not in  (select eqn_codmat
									from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
									where eqn_codequ = equ_codigo
									and equ_codper = @codper
									and eqn_nota > 0)
					union all
					select distinct 0,0,uni_nombre, equ_codper codper, per_carnet, per_nombres_apellidos per_nombres_apellidos, per_sexo,
							--car_nombre_legal as car_nombre, 
					@alias_carrera as car_nombre, reg_nombre, eqn_codmat, isnull(plm_alias,mat_nombre) mat_nombre, '' cic_nombre, 0 cil_anio, fac_nombre, 
					uni_nota_minima, uni_pnota_minima,
					pla_codigo codpla, per_codreg codreg, per_resolucion_equivalencia, per_fecha_equivalencia, equ_codist,plm_uv, 
					eqn_codmat, per_acta_equivalencia,'I', 
			
					plm_anio_carrera, plm_ciclo
					from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas,
					ra_mat_materias, ra_per_personas,ra_uni_universidad, ra_reg_regionales, 
					ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras, ra_fac_facultades,
					ra_plm_planes_materias
					where per_carnet = @carnet
					and equ_codper = per_codigo
					and eqn_codequ = equ_codigo
					and reg_codigo = per_codreg
					and uni_codigo = reg_coduni
					and alc_codper = per_codigo
					and alc_codpla = pla_codigo
					and car_codigo = pla_codcar
					and eqn_codmat = mat_codigo
					and fac_codigo = car_codfac
					and eqn_nota > 0
					and plm_codpla = alc_codpla
					and plm_codmat = mat_codigo
					) j 
				) t
				--order by cil_anio, cil_codcic
				print 'fin N ln 468'
			end
			else
			begin
				print 'inicio S'
				insert into @record_uno_a_uno (Lugar, fecha, lee_firma, fac_nombre, confronto, elaboro, Secretaria, Rector, cil_codigo, uni_nombre, per_carnet,
				per_nombres_apellidos, car_nombre, reg_nombre, UV, equ_codist, cic_nombre, mat_codigo, mat_nombre, nota, estado, nota_letras, ciclo_min,
				ciclo_max, uni_nota_minima, uni_nota_minima_letras, total_aprobadas, materias_aprobadas, materias_reprobadas, total_aprobadas_letras,
				materias_aprobadas_letras, materias_reprobadas_letras, not_num, cum_n, cum_n_letras, equ, equ_concedidas, plm_uv, matriculado, GloPa,
		
				cil_anio, cil_codcic, plm_anio_carrera, plm_ciclo, codcil_real)

				select @cuidad Lugar,dbo.fn_crufl_FechaALetras(convert(datetime,@fecha,103),1,1) fecha, '' lee_firma,fac_nombre, @confronto confronto, @elaboro elaboro,
				'' Secretaria,@rector Rector,cil_codigo,uni_nombre, per_carnet, per_nombres_apellidos, 
				car_nombre as car_nombre, reg_nombre,@unidades UV,equ_codist,
				case when cil_codigo = 0 and equ_codist <> 711 then 'Eq.Externa' when  cil_codigo = 0 and equ_codist = 711 then 'Eq. Interna'  else
				substring(cic_nombre,7,8) + ' - ' + CAST(cil_anio as varchar) end cic_nombre,
				mat_codigo, mat_nombre, nota nota, estado estado, '(' + upper(dbo.NotaALetras(nota)) + ')' nota_letras,
				ciclo_min, ciclo_max, iif(@tipo_alumno = 'U',uni_nota_minima, uni_pnota_minima) uni_nota_minima, 
				upper(dbo.NotaALetras(iif(@tipo_alumno = 'U',uni_nota_minima, uni_pnota_minima))) uni_nota_minima_letras,
				materias_aprobadas total_aprobadas,
				case when materias_equivalencia > 0 then 
				'('+cast(materias_aprobadas as varchar) + ') aprobadas ' + 'En esta Institucion ' 
				else
				'' end materias_aprobadas, 
				materias_reprobadas,
				dbo.MateriasALetras(materias_aprobadas) total_aprobadas_letras,
				case when materias_equivalencia > 0 then 
				dbo.MateriasALetras(materias_aprobadas) + '('+cast(materias_aprobadas as varchar) + ') aprobadas ' + 'En esta Institucion ' 
				else
				'' end materias_aprobadas_letras,
				dbo.MateriasALetras(materias_reprobadas) materias_reprobadas_letras,not_num,round(@cum,1) cum_n,
				dbo.NotaALetras(round(cum_n,1)) cum_n_letras,
				case when cil_codigo = 0 then 'EQUIVALENCIAS' else '' end equ,
				case when materias_equivalencia > 0 then dbo.MateriasALetras(materias_equivalencia) + '(' + cast(materias_equivalencia as varchar) + ')' + ' asignaturas concedidas por equivalencia ' else '' end equ_concedidas, 
				plm_uv, matriculado, case when materias_aprobadas >= @nmat_plan then 'global' else 'parcial' end GloPa,
		
				cil_anio, cil_codcic, plm_anio_carrera, plm_ciclo, cil_codigo
				from (
					select plm_anio_carrera, plm_ciclo, cil_codcic,cil_codigo,uni_nombre, per_carnet, per_nombres_apellidos, uni_nota_minima, uni_pnota_minima,
					fac_nombre, car_nombre as car_nombre, reg_nombre, cic_nombre, cil_anio, per_acta_equivalencia,
					mat_codigo, mat_nombre, per_resolucion_equivalencia, per_fecha_equivalencia,plm_uv, equ_codist,
					case when per_sexo = 'M' then ' matriculado '  else ' matriculada ' end matriculado,
					round(isnull((select sum(nota)
					/*SUBCONSULTA EXCLUSIÓN EQUIVALENCIAS*/
					from
					(
					(select isnull(nota,0) nota 
					from @notas 
					where ins_codper = codper
					and mai_codmat = codmat_del
					and ins_codcil = cil_codigo
					and mat_codigo not in  (select eqn_codmat
									from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
									where eqn_codequ = equ_codigo
									and equ_codper = @codper
									and eqn_nota > 0)
					union all
					/*UNION CON OTRA CONSULTA PARA OBTENER LAS EQUIVALENCIAS*/
					select isnull(round(avg(eqn_nota),1),0)
					from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad
					where eqn_codequ = equ_codigo
					and eqn_codmat = mat_codigo
					and equ_codper = codper
					and eqn_nota > 0
					)
					) t)
					,0),1) nota, 

					isnull((select sum(nota)
					from
					/*CONSICION PARA EQUIVALENCIAS*/
					(
					(select isnull(nota,0)  nota
					from @notas 
					where ins_codper = codper
					and mai_codmat = codmat_del
					and ins_codcil = cil_codigo
					and mat_codigo not in  (select eqn_codmat
									from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
									where eqn_codequ = equ_codigo
									and equ_codper = @codper
									and eqn_nota > 0)
					
					union all
					/*UNION CON OTRA CONSULTA*/
					select isnull(round(avg(eqn_nota),1),0)
					from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad
					where eqn_codequ = equ_codigo
					and eqn_codmat = mat_codigo
					and equ_codper = codper
					and eqn_nota > 0
					))t ),0) not_num,

					CASE WHEN isnull((select sum(nota)
					from (
					(select isnull(nota,0) nota
					from @notas 
					where ins_codper = codper
					and mai_codmat = codmat_del
					and ins_codcil = cil_codigo
					and mat_codigo not in  (select eqn_codmat
									from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
									where eqn_codequ = equ_codigo
									and equ_codper = @codper
									and eqn_nota > 0)
			
						union all

					select isnull(round(avg(eqn_nota),1),0)
					from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad
					where eqn_codequ = equ_codigo
					and eqn_codmat = mat_codigo
					and equ_codper = codper
					and eqn_nota > 0
					)) t ),0) < 
					(select cast(iif(@tipo_alumno = 'U',uni_nota_minima, uni_pnota_minima) as real) 
					from ra_uni_universidad 
					join ra_reg_regionales on uni_codigo = reg_coduni 
					join ra_per_personas on reg_codigo = per_codreg 
					where per_codigo = codper) 
					THEN 'Reprobada' ELSE 'Aprobada' END estado,

					(select cic_nombre + ' del año academico ' + cast(cil_anio as varchar) 
					from ra_cil_ciclo, ra_cic_ciclos
					where cic_codigo = cil_codcic
					and cast(cil_anio as varchar) + cast(cil_codigo as varchar) =
					(select min(cast(cil_anio as varchar) + cast(cil_codigo as varchar))
					from ra_cil_ciclo, ra_ins_inscripcion
					where ins_codper = codper
					and cil_codigo = ins_codcil)) ciclo_min,

					(select cic_nombre + ' del año academico ' + cast(cil_anio as varchar) 
					from ra_cil_ciclo, ra_cic_ciclos
					where cic_codigo = cil_codcic
					and cast(cil_anio as varchar) + cast(cil_codigo as varchar) = 
					(select max(cast(cil_anio as varchar) + cast(cil_codigo as varchar))
					from ra_cil_ciclo, ra_ins_inscripcion
					where ins_codper = codper
					and cil_codigo = ins_codcil)) ciclo_max, @equivalencias  materias_equivalencia, @aprobadas materias_aprobadas, @reprobadas materias_reprobadas, @cum cum_n
					from
					(
						select cil_codcic,cil_codigo,uni_nombre, ins_codper codper, per_carnet, 
							per_nombres_apellidos, per_sexo,
									--car_nombre_legal as car_nombre, 
								@alias_carrera as car_nombre, reg_nombre, mat_codigo, isnull(plm_alias,mat_nombre) mat_nombre, cic_nombre, cil_anio, fac_nombre,
								uni_nota_minima, uni_pnota_minima,
							pla_codigo codpla, per_codreg codreg,  per_resolucion_equivalencia, per_fecha_equivalencia,0 equ_codist,
							plm_uv, mai_codmat_del codmat_del,per_acta_equivalencia, mai_estado,

							plm_anio_carrera, plm_ciclo
						from @ra_mai_mat_inscritas_h_v, ra_mat_materias, ra_per_personas,
						ra_uni_universidad, ra_reg_regionales, ra_ins_inscripcion, 
						ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras,
						ra_cil_ciclo, ra_cic_ciclos, ra_fac_facultades, ra_plm_planes_materias
						where per_carnet = @carnet and ins_codper = per_codigo
						and reg_codigo = per_codreg and uni_codigo = reg_coduni
						and alc_codper = per_codigo and alc_codpla = pla_codigo
						and car_codigo = pla_codcar and cil_codigo = ins_codcil
						and cic_codigo = cil_codcic and mai_codins = ins_codigo
						and mai_codmat = mat_codigo and mai_estado = 'I'
						and fac_codigo = car_codfac and plm_codpla = alc_codpla
						and plm_codmat = mat_codigo
						and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
						and mai_codmat not in (select eqn_codmat
										from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
										where eqn_codequ = equ_codigo
										and equ_codper = @codper
										and eqn_nota > 0)
							union all

						select distinct 0,0,uni_nombre, equ_codper codper, per_carnet, per_nombres_apellidos per_nombres_apellidos, per_sexo,
							@alias_carrera as car_nombre, reg_nombre, eqn_codmat, isnull(plm_alias,mat_nombre) mat_nombre, '' cic_nombre, 0 cil_anio, fac_nombre,
							uni_nota_minima, uni_pnota_minima,
							pla_codigo codpla, per_codreg codreg, per_resolucion_equivalencia, per_fecha_equivalencia, equ_codist,plm_uv, 
							eqn_codmat, per_acta_equivalencia,'I',

							plm_anio_carrera, plm_ciclo
						from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas,
							ra_mat_materias, ra_per_personas,ra_uni_universidad, ra_reg_regionales, 
							ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras, ra_fac_facultades,
							ra_plm_planes_materias
						where per_carnet = @carnet and equ_codper = per_codigo
							and eqn_codequ = equ_codigo and reg_codigo = per_codreg
							and uni_codigo = reg_coduni and alc_codper = per_codigo
							and alc_codpla = pla_codigo and car_codigo = pla_codcar
							and eqn_codmat = mat_codigo and fac_codigo = car_codfac
							and eqn_nota > 0 and plm_codpla = alc_codpla and plm_codmat = mat_codigo
					) j 
				) t
				where nota >= @nota_minima
			end
		
			--Inicio: Logica para los estudiantes menores al 2000
			declare @anio_ingreso int = 0
			set @anio_ingreso = cast(substring(@carnet, 9, 4) as int)
			print '@anio_ingreso: ' + cast(@anio_ingreso as varchar(5))
			if @anio_ingreso <= 2000 and @codper not in (61656, 69498, 51465, 63075, 25596, 71360, 68810, 71095)/*CASO DE AÑOS ANTIGUOS CON EQUIVALENCIAS, ESTO ESTA PERO DE LA PATA..., SE TIENE CONTINUAR CON EL REQUERIMIENTO: Querys\Archive\CASO ING. GANUZA CAMBIOS EN EQUIVALENCIAS*/
			begin
				print 'Es estudiante con añod de ingreso menor a 2000'
				print concat('record legacy ', @anio_ingreso)
				declare @record_uno_a_uno_legacy table (  
					cil_codcic int, cil_codigo varchar(80),  
					uni_nombre varchar(250), per_carnet varchar(12),  
					per_nombres_apellidos varchar(200), car_nombre varchar(250),
					pla_alias_carrera varchar(150), fac_nombre varchar(100),  
					pla_nombre varchar(100), reg_nombre varchar(80),  
					cic_nombre varchar(50), cil_anio int,  
					mat_codigo varchar(10), mat_nombre varchar(200),  
					nota real, nota_letras varchar(100),  
					estado varchar(20), cum_parcil real, cum real, materias int,  
					aprobadas int, reprobadas int, matricula int, equivalencias int,  
					ing_nombre varchar(50), estado_a varchar(20),  
					plm_anio_carrera int, plm_ciclo int,   
					absorcion varchar(2), uv int, um float, codcil_real int
				)
				insert into @record_uno_a_uno_legacy (
					cil_codcic, cil_codigo, uni_nombre, per_carnet, per_nombres_apellidos, car_nombre, pla_alias_carrera, fac_nombre, pla_nombre, 
					reg_nombre, cic_nombre, cil_anio, mat_codigo, mat_nombre, nota, nota_letras, estado, cum_parcil, cum, materias, aprobadas, 
					reprobadas, matricula, equivalencias, ing_nombre, estado_a, plm_anio_carrera, plm_ciclo, absorcion, uv, codcil_real
				)
				exec dbo.rep_record_academico_limpio 1, @carnet, @limpio

				insert into @record_final (
					Lugar, fecha, lee_firma, fac_nombre, confronto, elaboro, Secretaria, Rector, cil_codigo, uni_nombre, per_carnet, 
					per_nombres_apellidos, car_nombre, reg_nombre, UV, equ_codist, cic_nombre, mat_codigo, mat_nombre, nota, estado, 
					nota_letras, ciclo_min, ciclo_max, uni_nota_minima, uni_nota_minima_letras, total_aprobadas, materias_aprobadas,
					materias_reprobadas, total_aprobadas_letras, materias_aprobadas_letras, materias_reprobadas_letras, not_num, cum_n, 
					cum_n_letras, equ, equ_concedidas, plm_uv, matriculado, GloPa,
					cil_anio, cil_codcic, plm_anio_carrera, plm_ciclo, codcil_real, cargo_firma, nombre_preesp
				)
				select 
					r.Lugar, r.fecha, r.lee_firma, r.fac_nombre, r.confronto, r.elaboro, r.Secretaria, r.Rector, rl.cil_codigo, r.uni_nombre,
					r.per_carnet, r.per_nombres_apellidos, r.car_nombre, r.reg_nombre, r.UV, r.equ_codist, concat(replace(rl.cic_nombre, 'Ciclo ', ''), ' - ', rl.cil_anio) cic_nombre,
					r.mat_codigo, r.mat_nombre,r.nota, r.estado, r.nota_letras, r.ciclo_min, r.ciclo_max, r.uni_nota_minima, r.uni_nota_minima_letras,
					r.total_aprobadas, r.materias_aprobadas, r.materias_reprobadas, r.total_aprobadas_letras, r.materias_aprobadas_letras, r.materias_reprobadas_letras,
					r.not_num, r.cum_n, r.cum_n_letras, r.equ, r.equ_concedidas, r.plm_uv, r.matriculado, r.GloPa, 
					rl.cil_anio, rl.cil_codcic, rl.plm_anio_carrera, rl.plm_ciclo, rl.codcil_real, @cargo_firma cargo, @c_pre_nombre
				from @record_uno_a_uno_legacy rl
					inner join @record_uno_a_uno r on rl.mat_codigo = r.mat_codigo and rl.codcil_real = r.codcil_real 
		
				--return
			end
			--Fin: Logica para los estudiantes menores al 2000
			else
			begin
				print 'Es estudiante con año de ingreso mayor a 2000'
				insert into @record_final (
					Lugar, fecha, lee_firma, fac_nombre, confronto, elaboro, Secretaria, Rector, cil_codigo, uni_nombre, per_carnet, 
					per_nombres_apellidos, car_nombre, reg_nombre, UV, equ_codist, cic_nombre, mat_codigo, mat_nombre, nota, estado, 
					nota_letras, ciclo_min, ciclo_max, uni_nota_minima, uni_nota_minima_letras, total_aprobadas, materias_aprobadas,
					materias_reprobadas, total_aprobadas_letras, materias_aprobadas_letras, materias_reprobadas_letras, not_num, cum_n, 
					cum_n_letras, equ, equ_concedidas, plm_uv, matriculado, GloPa,
					cil_anio, cil_codcic, plm_anio_carrera, plm_ciclo, codcil_real, cargo_firma, nombre_preesp
				)
				select Lugar, fecha, lee_firma, fac_nombre, confronto, elaboro, Secretaria, Rector, cil_codigo, uni_nombre, per_carnet,
					per_nombres_apellidos, car_nombre, reg_nombre, UV, equ_codist, cic_nombre, mat_codigo, mat_nombre, nota, estado, nota_letras, ciclo_min,
					ciclo_max, uni_nota_minima, uni_nota_minima_letras, total_aprobadas, materias_aprobadas, materias_reprobadas, total_aprobadas_letras,
					materias_aprobadas_letras, materias_reprobadas_letras, not_num, cum_n, cum_n_letras, equ, equ_concedidas, plm_uv, matriculado, GloPa,
					cil_anio, cil_codcic, plm_anio_carrera, plm_ciclo, codcil_real, @cargo_firma cargo, @c_pre_nombre
				from @record_uno_a_uno
				order by cil_anio, cil_codcic, plm_anio_carrera, plm_ciclo
			end

		end-- Fin: Proceso original de uno a uno, se uso el mismo proceso de uno a uno para no alterar ningun resultado

		print '*** --- ***'
		set @contador = @contador + 1
		delete from @record_uno_a_uno

		fetch next from m_cursor into @c_codimp, @c_pre_nombre, @c_sexo, @c_codper, @c_carnet, @c_codcil, @c_cuotas_pagadas, @c_modulos_aprobados
	end
	close m_cursor  
	deallocate m_cursor

	select 
		Lugar, fecha, lee_firma, fac_nombre, confronto, elaboro, Secretaria, Rector, cil_codigo, uni_nombre, per_carnet,
		per_nombres_apellidos, car_nombre, reg_nombre, UV, equ_codist, cic_nombre, mat_codigo, mat_nombre, nota, estado, nota_letras, ciclo_min,
		ciclo_max, uni_nota_minima, uni_nota_minima_letras, total_aprobadas, materias_aprobadas, materias_reprobadas, total_aprobadas_letras,
		materias_aprobadas_letras, materias_reprobadas_letras, not_num, cum_n, cum_n_letras, equ, equ_concedidas, plm_uv, matriculado, GloPa,
		cargo_firma cargo
	from @record_final
	order by fac_nombre, nombre_preesp, per_nombres_apellidos, cil_anio, cil_codcic, plm_anio_carrera, plm_ciclo

END
