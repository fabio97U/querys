USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_boleta_notas_pre_esp]    Script Date: 16/2/2023 11:12:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	-- exec dbo.rep_boleta_notas_pre_esp 1, 122, '25-2574-2015', '', '' -- Por estudiante
	-- exec dbo.rep_boleta_notas_pre_esp 1, 122, '0', '', '', @cuotas_pagadas = 10, @modulos_aprobados = 8 -- Masivo
ALTER procedure [dbo].[rep_boleta_notas_pre_esp] 
	@codreg int = 1,
	@codcil int = 0,
	@carnet varchar(12) = '', -- vacio: es masivo por @codcil, lleno: es individual por estudiante
	@firma varchar(100) = '',
	@cargofirma varchar(100) = '',
	
	@cuotas_pagadas int = 0,--0: No importa, 1...10: "x" cuotas pagadas
	@modulos_aprobados int = 0--0: No importa, 1...8: "x" modulos aprobados
as
begin
	set language spanish;
	declare @codi3mp int , @codper int
	declare @sexo2 char(2), @reg_nombre varchar(50)
	select @reg_nombre = reg_nombre from ra_reg_regionales where reg_codigo = @codreg

	declare @tbl_estudiantes_evaluar as table(codimp int, sexo varchar(5), codper int, carnet varchar(20), codcil int, cuotas_pagadas int, modulos_aprobados int)
	
	if (@carnet = '0') set @carnet = ''

	if @carnet <> '' -- Es solo un estudiante
		select @codper = per_codigo from ra_per_personas where per_carnet = @carnet

	insert into @tbl_estudiantes_evaluar (codimp, sexo, codper, carnet, codcil, cuotas_pagadas, modulos_aprobados)
	select codimp, sexo, codper, carnet, codcil, 
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
		select max(imp_codigo) 'codimp', imp_codper 'codper', per_carnet 'carnet', max(apr_codcil) 'codcil', per_sexo 'sexo'
		from pg_imp_ins_especializacion 
			inner join pg_apr_aut_preespecializacion on imp_codapr = apr_codigo
			inner join ra_per_personas on imp_codper = per_codigo
		where apr_codcil = @codcil--1,379 
			--and imp_codper in (181324, 182420)--and imp_estado = 'I'
			--and imp_codper in (5549, 6968)
			and imp_codper = case when @carnet = '' then imp_codper else @codper end
		group by imp_codigo, apr_codcil, imp_codper, per_carnet, per_sexo
	) t

	if (@cuotas_pagadas <> 0)
	begin
		delete from @tbl_estudiantes_evaluar where cuotas_pagadas < @cuotas_pagadas
	end

	if (@modulos_aprobados <> 0)
	begin
		delete from @tbl_estudiantes_evaluar where modulos_aprobados < @modulos_aprobados
	end
	
	--select * from @tbl_estudiantes_evaluar

	declare @c_codimp int = 0, @c_sexo varchar(5), @c_codper int = 0, @c_carnet varchar(20) = '', 
		@c_codcil int = 0, @c_cuotas_pagadas int = 0, @c_modulos_aprobados int = 0, @contador int = 1, @total int = 0
	select @total = count(1) from @tbl_estudiantes_evaluar
	
	declare @tbl_resultado_final as table (uni_nombre varchar(125), reg_nombre varchar(50), fac_nombre varchar(125), car_nombre varchar(125), 
	ciclo varchar(25), per_carnet varchar(12), per_nombres_apellidos varchar(60), per_codigo int, pre_nombre varchar(125), 
	mpr_nombre varchar(125), nota float, mpr_orden smallint, 

	promedio float, modulos_aprobados int, mod_aprobados_letras varchar(30), modulos_reprobados int, modulos_reprobados_letras varchar(30),
	periodo_comprendido_pre_especialidad varchar(150), resultado varchar(25), fecha_letra varchar(255), res_hom_muj varchar(25), 
	orden_cursado int, firma varchar(100), cargofirma varchar(100), nombre_preesp varchar(125))

	declare @tbl_resultado_uno_a_uno as table (uni_nombre varchar(125), reg_nombre varchar(50), fac_nombre varchar(125), car_nombre varchar(125), 
	ciclo varchar(25), per_carnet varchar(12), per_nombres_apellidos varchar(60), per_codigo int, pre_nombre varchar(125), 
	mpr_nombre varchar(125), nota float, mpr_orden smallint, nmp_bandera varchar(10))

	declare @tbl_detalle_tipo_alumno as table (dtde_codigo int, dtde_valor varchar(10))

	declare m_cursor cursor 
	for
		select * from @tbl_estudiantes_evaluar   
	open m_cursor
 
	fetch next from m_cursor into @c_codimp, @c_sexo, @c_codper, @c_carnet, @c_codcil, @c_cuotas_pagadas, @c_modulos_aprobados
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
		


		begin --Proceso de uno a uno
			-- Inicio: Proceso original de uno a uno, se uso el mismo proceso de uno a uno para no alterar ningun resultado
			--print 'Es por carnet'
			--select @codper = per_codigo, @sexo = per_sexo from ra_per_personas where per_carnet = @carnet
			--print '@codper : ' + cast(@codper as nvarchar(10))
		
			--select @codimp = max(imp_codigo), @codcil = max(apr_codcil) from pg_imp_ins_especializacion 
			--	inner join pg_apr_aut_preespecializacion on imp_codapr = apr_codigo
			--where imp_codper = @codper
			--group by imp_codigo, apr_codcil
			--print '@codimp: ' + cast(@codimp as nvarchar(10))
			--print '@codcil: ' + cast(@codcil as nvarchar(10))

			if(select count(1) from pg_insm_inscripcion_mod where insm_codper = @c_codper and insm_codcil = @c_codcil) > 0
			begin
				print 'if(select count(1) from pg_insm_inscripcion_mod where insm_codper = @codper and insm_codcil = @codcil)>0'

				insert into @tbl_resultado_uno_a_uno (uni_nombre, reg_nombre, fac_nombre, car_nombre, 
					ciclo, per_carnet, 
					per_nombres_apellidos, per_codigo, pre_nombre, mpr_nombre, nota, mpr_orden, nmp_bandera)

				select uni_nombre, reg_nombre, fac_nombre, pla_alias_carrera as car_nombre, 
					ra_cic_ciclos.cic_nombre + ' - ' + CAST(ra_cil_ciclo.cil_anio AS varchar) AS ciclo, per_carnet, 
					per_nombres_apellidos, per_codigo, pre_nombre, d.mpr_nombre, ISNULL(b.nmp_nota,0) AS nota, mpr_orden, nmp_bandera
				from ra_per_personas 
					inner join ra_alc_alumnos_carrera on alc_codper = per_codigo 
					inner join ra_pla_planes on pla_codigo = alc_codpla 
					inner join ra_car_carreras on car_codigo = pla_codcar 
					inner join ra_fac_facultades on fac_codigo = car_codfac 
					inner join ra_reg_regionales on reg_codigo = per_codreg 
					inner join ra_uni_universidad on uni_codigo = reg_coduni 
					inner join ra_pgc_pre_esp_carrera on pgc_codcar = car_codigo 
					inner join pg_pre_preespecializacion on pre_codigo = pgc_codpre 
					inner join pg_mpr_modulo_preespecializacion as d on d.mpr_codpre = pre_codigo 
					inner join pg_apr_aut_preespecializacion on apr_codpre = pre_codigo 
					inner join pg_imp_ins_especializacion as a on a.imp_codapr = apr_codigo and a.imp_codper = per_codigo 
					left outer join pg_nmp_notas_mod_especializacion as b on b.nmp_codimp = a.imp_codigo 
					inner join ra_cil_ciclo on ra_cil_ciclo.cil_codigo = apr_codcil 
					inner join ra_cic_ciclos on ra_cic_ciclos.cic_codigo = ra_cil_ciclo.cil_codcic 
					inner join pg_pmp_ponderacion on pmp_codigo = b.nmp_codpmp and d.mpr_orden = pmp_orden
				where per_carnet = @c_carnet and apr_codcil = @c_codcil and d.mpr_visible = 'S'
			
					union all

				select '' as uni_nombre, '' as reg_nombre, '' fac_nombre, pla_alias_carrera as car_nombre, 
					ra_cic_ciclos.cic_nombre + ' - ' + CAST(ra_cil_ciclo.cil_anio AS varchar) AS ciclo, per_carnet, 
					per_nombres_apellidos, per_codigo, 'General' as pre_nombre, hm_nombre_mod as mpr_nombre,round(ISNULL(nmp_nota, 
					0),2) AS nota, pmp_orden mpr_orden, nmp_bandera
				from (select  * from (select * from  pg_pmp_ponderacion left join (select * from pg_nmp_notas_mod_especializacion where nmp_codimp = @c_codimp) t
					on pmp_codigo = t.nmp_codpmp ) a , pg_imp_ins_especializacion where imp_codper=@c_codper) as r 
					join pg_insm_inscripcion_mod on insm_codper = r.imp_codper and insm_codpmp = r.pmp_orden
					join pg_hm_horarios_mod on hm_codigo = insm_codhm
					join ra_alc_alumnos_carrera on alc_codper = r.imp_codper
					join ra_pla_planes on pla_codigo = alc_codpla
					join ra_car_carreras on car_codigo = pla_codcar
					join ra_cil_ciclo on cil_codigo = insm_codcil
					join ra_cic_ciclos on cil_codcic = cic_codigo
					join ra_per_personas on per_codigo = insm_codper
				where insm_codper = @c_codper and insm_codcil = @c_codcil and imp_codigo = @c_codimp
		
					union all

				select '' uni_nombre, '' reg_nombre, '' fac_nombre, '' car_nombre, '' ciclo, per_carnet, 
					per_nombres_apellidos, per_codigo, '' pre_nombre,'Promedio' mpr_nombre, round(sum(nota)/8,1) nota, mpr_orden
					, nmp_bandera
				from(
					select distinct uni_nombre, reg_nombre,  pla_alias_carrera as car_nombre, 
						ra_cic_ciclos.cic_nombre + ' - ' + CAST(ra_cil_ciclo.cil_anio AS varchar) AS ciclo, per_carnet, 
						per_nombres_apellidos, per_codigo,pre_codigo as precod, pre_nombre as codpre, mpr_nombre as mat_nombre,hmp_descripcion hpl_descripcion, round(ISNULL(nmp_nota, 
						0),2) AS nota,(rtrim(imp_codmpr)+ ltrim(pg_hmp_horario_modpre.hmp_descripcion)) as codigotot, mpr_orden, nmp_bandera
					from  (select  * from (select * from  pg_pmp_ponderacion left join (select * from pg_nmp_notas_mod_especializacion where nmp_codimp = @c_codimp) t
					 on pmp_codigo = t.nmp_codpmp ) a , pg_imp_ins_especializacion where imp_codper=@c_codper)  r
						inner join pg_apr_aut_preespecializacion on apr_codigo = r.imp_codapr 
						inner join pg_hmp_horario_modpre on hmp_codapr = apr_codigo and hmp_codigo = imp_codhmp
						inner join pg_pre_preespecializacion on pre_codigo = apr_codpre
						inner join pg_pmp_ponderacion p on p.pmp_codigo = r.pmp_codigo
						inner join pg_mpr_modulo_preespecializacion on mpr_codpre=pre_codigo and mpr_orden = p.pmp_orden
						inner join ra_pgc_pre_esp_carrera on pre_codigo=pgc_codpre
						inner join ra_car_carreras on car_codigo = pgc_codcar
						inner join ra_fac_facultades on fac_codigo=car_codfac
						inner join ra_per_personas on per_codigo = imp_codper
						inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
						inner join ra_pla_planes on pla_codigo = alc_codpla
						inner join ra_reg_regionales on per_codreg = reg_codigo
						inner join ra_uni_universidad on uni_codigo = reg_coduni
						inner join ra_cil_ciclo on cil_codigo = apr_codcil
						inner join ra_cic_ciclos on cic_codigo = cil_codcic
					where (per_codigo = @c_codper) and (apr_codcil  = @c_codcil) and (mpr_visible = 'S')
			
						union

					select '' as uni_nombre, '' as reg_nombre, pla_alias_carrera as car_nombre, 
						ra_cic_ciclos.cic_nombre + ' - ' + CAST(ra_cil_ciclo.cil_anio AS varchar) AS ciclo, per_carnet, 
						per_nombres_apellidos, per_codigo,0 as precod,'General'  as codpre, hm_nombre_mod as mat_nombre,hm_descripcion hpl_descripcion, round(ISNULL(nmp_nota, 
						0),2) AS nota,(rtrim(hm_codigo)+ ltrim(hm_descripcion)) as codigotot, pmp_orden mpr_orden, nmp_bandera
					from (select  * from (select * from  pg_pmp_ponderacion left join (select * from pg_nmp_notas_mod_especializacion where nmp_codimp = @c_codimp) t
					 on pmp_codigo = t.nmp_codpmp ) a , pg_imp_ins_especializacion where imp_codper=@c_codper) as r 
						join pg_insm_inscripcion_mod on insm_codper = r.imp_codper and insm_codpmp = r.pmp_orden
						join pg_hm_horarios_mod on hm_codigo = insm_codhm
						join ra_alc_alumnos_carrera on alc_codper = r.imp_codper
						join ra_pla_planes on pla_codigo = alc_codpla
						join ra_car_carreras on car_codigo = pla_codcar
						join ra_cil_ciclo on cil_codigo = insm_codcil
						join ra_cic_ciclos on cil_codcic = cic_codigo
						join ra_per_personas on per_codigo = insm_codper
					where insm_codper = @c_codper and insm_codcil = @c_codcil 
				) as T
				group by per_carnet, per_nombres_apellidos, per_codigo,mpr_orden,nmp_bandera
			end
			else
			begin
	
				insert into @tbl_resultado_uno_a_uno (uni_nombre, reg_nombre, fac_nombre, car_nombre, 
				ciclo, per_carnet, 
				per_nombres_apellidos, per_codigo, pre_nombre, mpr_nombre, nota, mpr_orden,nmp_bandera)

				select uni_nombre, reg_nombre, fac_nombre, pla_alias_carrera as car_nombre, 
					ra_cic_ciclos.cic_nombre + ' - ' + CAST(ra_cil_ciclo.cil_anio AS varchar) AS ciclo, per_carnet, 
					per_nombres_apellidos, per_codigo, pre_nombre, d.mpr_nombre, ISNULL(b.nmp_nota, 0) AS nota,mpr_orden
					, nmp_bandera
				from ra_per_personas 
					inner join ra_alc_alumnos_carrera on alc_codper = per_codigo 
					inner join ra_pla_planes on pla_codigo = alc_codpla 
					inner join ra_car_carreras on car_codigo = pla_codcar 
					inner join ra_fac_facultades on fac_codigo = car_codfac 
					inner join ra_reg_regionales on reg_codigo = per_codreg 
					inner join ra_uni_universidad on uni_codigo = reg_coduni 
					inner join ra_pgc_pre_esp_carrera on pgc_codcar = car_codigo 
					inner join pg_pre_preespecializacion on pre_codigo = pgc_codpre 
					inner join pg_mpr_modulo_preespecializacion as d on d.mpr_codpre = pre_codigo 
					inner join pg_apr_aut_preespecializacion on apr_codpre = pre_codigo 
					inner join pg_imp_ins_especializacion as a on a.imp_codapr = apr_codigo and a.imp_codper = per_codigo 
					left outer join pg_nmp_notas_mod_especializacion as b on b.nmp_codimp = a.imp_codigo 
					inner join ra_cil_ciclo on ra_cil_ciclo.cil_codigo = apr_codcil 
					inner join ra_cic_ciclos on ra_cic_ciclos.cic_codigo = ra_cil_ciclo.cil_codcic 
					inner join pg_pmp_ponderacion on pmp_codigo = b.nmp_codpmp and d.mpr_orden = pmp_orden
				where (per_carnet = @c_carnet) and (apr_codcil = @c_codcil) and (d.mpr_visible = 'S')

				union all

				select '' as uni_nombre, '' as reg_nombre, '' fac_nombre, pla_alias_carrera as car_nombre, 
					ra_cic_ciclos.cic_nombre + ' - ' + CAST(ra_cil_ciclo.cil_anio AS varchar) AS ciclo, per_carnet, 
					per_nombres_apellidos, per_codigo,'General'  as pre_nombre, hm_nombre_mod as mpr_nombre,round(ISNULL(nmp_nota, 
					0),2) AS nota,pmp_orden mpr_orden, nmp_bandera
				from (select  * from (select * from  pg_pmp_ponderacion left join (select * from pg_nmp_notas_mod_especializacion where nmp_codimp = @c_codimp) t
					 on pmp_codigo = t.nmp_codpmp ) a , pg_imp_ins_especializacion where imp_codper=@c_codper) as r 
					join pg_insm_inscripcion_mod on insm_codper = r.imp_codper and insm_codpmp = r.pmp_orden
					join pg_hm_horarios_mod on hm_codigo = insm_codhm
					join ra_alc_alumnos_carrera on alc_codper = r.imp_codper
					join ra_pla_planes on pla_codigo = alc_codpla
					join ra_car_carreras on car_codigo = pla_codcar
					join ra_cil_ciclo on cil_codigo = insm_codcil
					join ra_cic_ciclos on cil_codcic = cic_codigo
					join ra_per_personas on per_codigo = insm_codper
				where insm_codper = @codper and insm_codcil = @codcil and imp_codigo = @c_codimp
		
					union all

				select  '' uni_nombre, '' reg_nombre, '' fac_nombre, '' car_nombre, '' ciclo, per_carnet, 
					per_nombres_apellidos, per_codigo, '' pre_nombre, 'Promedio' mpr_nombre, round(sum(nota)/6, 1) nota, mpr_orden, nmp_bandera
				from(
					select distinct uni_nombre, reg_nombre,  pla_alias_carrera as car_nombre, 
						ra_cic_ciclos.cic_nombre + ' - ' + CAST(ra_cil_ciclo.cil_anio AS varchar) AS ciclo, per_carnet, 
						per_nombres_apellidos, per_codigo,pre_codigo as precod, pre_nombre as codpre, mpr_nombre as mat_nombre,hmp_descripcion hpl_descripcion, round(ISNULL(nmp_nota, 
						0),2) AS nota,(rtrim(imp_codmpr)+ ltrim(pg_hmp_horario_modpre.hmp_descripcion)) as codigotot, mpr_orden, nmp_bandera
					from (select  * from (select * from  pg_pmp_ponderacion left join (select * from pg_nmp_notas_mod_especializacion where nmp_codimp = @c_codimp) t
						 on pmp_codigo = t.nmp_codpmp ) a , pg_imp_ins_especializacion where imp_codper=@c_codper)  r
						inner join pg_apr_aut_preespecializacion on apr_codigo = r.imp_codapr 
						inner join pg_hmp_horario_modpre on hmp_codapr = apr_codigo and hmp_codigo = imp_codhmp
						inner join pg_pre_preespecializacion on pre_codigo = apr_codpre
						inner join pg_pmp_ponderacion p on p.pmp_codigo = r.pmp_codigo
						inner join pg_mpr_modulo_preespecializacion on mpr_codpre=pre_codigo and mpr_orden = p.pmp_orden
						inner join ra_pgc_pre_esp_carrera on pre_codigo=pgc_codpre
						inner join ra_car_carreras on car_codigo = pgc_codcar
						inner join ra_fac_facultades on fac_codigo=car_codfac
						inner join ra_per_personas on per_codigo = imp_codper
						inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
						inner join ra_pla_planes on pla_codigo = alc_codpla
						inner join ra_reg_regionales on per_codreg = reg_codigo
						inner join ra_uni_universidad on uni_codigo = reg_coduni
						inner join ra_cil_ciclo on cil_codigo = apr_codcil
						inner join ra_cic_ciclos on cic_codigo = cil_codcic
					where per_codigo = @c_codper and apr_codcil  = @c_codcil and mpr_visible = 'S'
				
						union

					select '' as uni_nombre, '' as reg_nombre,  pla_alias_carrera as car_nombre, 
						ra_cic_ciclos.cic_nombre + ' - ' + CAST(ra_cil_ciclo.cil_anio AS varchar) AS ciclo, per_carnet, 
						per_nombres_apellidos, per_codigo,0 as precod,'General'  as codpre, hm_nombre_mod as mat_nombre,hm_descripcion hpl_descripcion, round(ISNULL(nmp_nota, 
						0),2) AS nota,(rtrim(hm_codigo)+ ltrim(hm_descripcion)) as codigotot, pmp_orden mpr_orden, nmp_bandera
					from (select  * from (select * from  pg_pmp_ponderacion left join (select * from pg_nmp_notas_mod_especializacion where nmp_codimp = @c_codimp) t
					 on pmp_codigo = t.nmp_codpmp ) a , pg_imp_ins_especializacion where imp_codper=@c_codper) as r 
						join pg_insm_inscripcion_mod on insm_codper = r.imp_codper and insm_codpmp = r.pmp_orden
						join pg_hm_horarios_mod on hm_codigo = insm_codhm
						join ra_alc_alumnos_carrera on alc_codper = r.imp_codper
						join ra_pla_planes on pla_codigo = alc_codpla
						join ra_car_carreras on car_codigo = pla_codcar
						join ra_cil_ciclo on cil_codigo = insm_codcil
						join ra_cic_ciclos on cil_codcic = cic_codigo
						join ra_per_personas on per_codigo = insm_codper
					where insm_codper = @c_codper and insm_codcil = @c_codcil
				) as T
				group by per_carnet, per_nombres_apellidos, per_codigo,mpr_orden,nmp_bandera
			end

			declare @Promedio float, @sumanotas float

			select @sumanotas = Isnull(sum(nota),0) from @tbl_resultado_uno_a_uno where pre_nombre <> ''
			declare @cantidad int, @nota_final_reporte float, @promedio_final_reporte float
			select @nota_final_reporte = sum(nota) from @tbl_resultado_uno_a_uno where pre_nombre <> '' and nota != 0
			select @promedio_final_reporte = @nota_final_reporte/(select count(1) from @tbl_resultado_uno_a_uno where pre_nombre <> '' and nota != 0)

			if exists (select 1 from @tbl_resultado_uno_a_uno where pre_nombre <> '') --Si existe modulos inscritas
			begin
				set @Promedio = Round(Isnull(@sumanotas / (select count(1) from @tbl_resultado_uno_a_uno where pre_nombre <> ''),0),1)

				update @tbl_resultado_uno_a_uno set nota = @Promedio where mpr_nombre = 'Promedio' and pre_nombre = ''

				declare @mod_reprobados int, @mod_aprobados int, @periodo_comprendido varchar(150)
				declare @mod_reprobados_letras varchar(30), @mod_aprobados_letras varchar(30)
				select @mod_aprobados = count(1) from @tbl_resultado_uno_a_uno where nota >= 7 and pre_nombre <> '' and (nmp_bandera <> 0 or nota <> 0)
				select @mod_reprobados = count(1) from @tbl_resultado_uno_a_uno where nota < 7 and pre_nombre <> '' and (nmp_bandera <> 0 or nota <> 0)

				select @mod_reprobados_letras = dbo.fn_NumerosALetras(@mod_reprobados), @mod_aprobados_letras = dbo.fn_NumerosALetras(@mod_aprobados)

				insert into @tbl_detalle_tipo_alumno
				exec sp_detalle_tipo_estudio_alumno @c_codper
		
				declare @pct_fecha_inicio datetime, @pct_fecha_fin datetime
				select @pct_fecha_inicio = pct_fecha_inicio, @pct_fecha_fin = pct_fecha_fin
				from ra_pct_periodo_ciclos_tde where pct_coddtde in (select dtde_codigo from @tbl_detalle_tipo_alumno) and pct_codcil in (@c_codcil)

				declare @graduado_a varchar(25)
				select @graduado_a = case @c_sexo when 'F' then 'matriculada' else 'matriculado' end

				select @periodo_comprendido = lower(concat(datename(month, @pct_fecha_inicio), ' ', year(@pct_fecha_inicio))  + ' a ' 
					+ concat(datename(month, @pct_fecha_fin), ' ', year(@pct_fecha_fin)))
				
				declare @prenombre varchar(255) = '', @fac_nombre varchar(100) = ''
				select @prenombre = pre_nombre, @fac_nombre = fac_nombre from @tbl_resultado_uno_a_uno where mpr_orden = 1 and pre_nombre <> ''

				insert into @tbl_resultado_final
				select *, @firma 'firma', @cargofirma 'cargofirma', @prenombre 'nombre_preesp' 
				from (
					select uni_nombre, @reg_nombre reg_nombre, @fac_nombre fac_nombre, car_nombre, ciclo, per_carnet, per_nombres_apellidos, per_codigo, 
					pre_nombre, mpr_nombre, nota, mpr_orden, round(@promedio_final_reporte,1) as promedio
					, @mod_aprobados modulos_aprobados, @mod_aprobados_letras mod_aprobados_letras, @mod_reprobados modulos_reprobados, 
					@mod_reprobados_letras modulos_reprobados_letras, @periodo_comprendido periodo_comprendido_pre_especialidad,
					case when nmp_bandera = 0 and nota = 0 then 'No cursada' else case when nota >= 7 then 'Aprobado' else 'Reprobado' end end 'resultado', 
					dbo.fn_crufl_FechaALetras(getdate(), 1, 1) 'fecha_letra', @graduado_a 'res_hom_muj', 
					(
						case mpr_orden  when '1' then 1  when '9' then 2 when '2' then 3 when '10' then 4 when '3' then 5 when '4' then 6 when '5' then 7 when '6' then 8 end
					) 'orden_cursado'
					from @tbl_resultado_uno_a_uno 
					where pre_nombre <> ''
				) t
				order by orden_cursado--, per_carnet, pre_nombre
			end
			-- Fin: Proceso original de uno a uno, se uso el mismo proceso de uno a uno para no alterar ningun resultado
		end
		
		delete from @tbl_resultado_uno_a_uno
		delete from @tbl_detalle_tipo_alumno

		print '*** --- ***'
		set @contador = @contador + 1

		fetch next from m_cursor into @c_codimp, @c_sexo, @c_codper, @c_carnet, @c_codcil, @c_cuotas_pagadas, @c_modulos_aprobados
	end      
	close m_cursor  
	deallocate m_cursor

	select uni_nombre, reg_nombre, fac_nombre, car_nombre, ciclo, per_carnet, per_nombres_apellidos, per_codigo, pre_nombre, 
		mpr_nombre, nota, mpr_orden, promedio, modulos_aprobados, mod_aprobados_letras, modulos_reprobados, modulos_reprobados_letras, 
		periodo_comprendido_pre_especialidad, resultado, fecha_letra, res_hom_muj, orden_cursado, firma, cargofirma 
	from @tbl_resultado_final
	order by fac_nombre, nombre_preesp, per_nombres_apellidos, orden_cursado

end
