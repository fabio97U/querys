	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2021-04-12 21:34:07.217>
	-- Description: <Determina si el @codper tiene ciclos consecutivos de estudio>
	-- =============================================
	-- select dbo.fn_validar_ciclos_consecutivos(181324, 2, 2015, 2019)
create function dbo.fn_validar_ciclos_consecutivos(
    @codper int,
	@codcic_hasta int,
	@anio_hasta int,
	@anio_desde int
)
returns int
as
begin
	declare @tiene_ciclos_consecutivos int = 0 -- 1: si tiene ciclos consecutivos, 0: no tiene ciclos consecutivos
	declare @suma_anios int
    declare @tbl_ciclos as table (cil_anio int, sum_codcic int)
	insert into @tbl_ciclos(cil_anio, sum_codcic)
	select cil_anio, sum(cil_codcic) sum_codcic  from ra_cil_ciclo
		inner join ra_ins_inscripcion on ins_codcil = cil_codigo and ins_codper = @codper
	where cil_codcic <> 3
	group by cil_anio
	order by cil_anio

	if (@codcic_hasta % 2) = 1
	begin
		set @anio_hasta = @anio_hasta - 1
	end

	--suma de Gauss
	select @suma_anios = ((@anio_hasta * (@anio_hasta + 1)) / 2) - (((@anio_desde - 1) * ((@anio_desde - 1) + 1)) / 2)

	if not exists (select 1 from @tbl_ciclos where cil_anio <= @anio_hasta and sum_codcic < 3) 
	and @suma_anios = (select sum(cil_anio) from @tbl_ciclos where cil_anio <= @anio_hasta) 
	begin
		set @tiene_ciclos_consecutivos = 1
	end
	
    return @tiene_ciclos_consecutivos
end


	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2021-04-12 16:41:18.539>
	-- Description: <Genera la data para el reporte "Constancia de Nivel Académico" -> "rep_constancia_nivel_academico.rpt">
	-- =============================================
	-- exec dbo.rep_constancia_nivel_academico 1, '25-3203-2014', 'LIC. CARLOS VALENCIA', '12/04/2021', 'Fabio Ramos'
	-- exec dbo.rep_constancia_nivel_academico 1, '25-2574-2015', 'LIC. CARLOS VALENCIA', '12/04/2021', 'Fabio Ramos'
alter procedure rep_constancia_nivel_academico
	@opcion int = 0,
	@carnet varchar(16) = '',
	@administrador varchar(75) = '',
	@fecha_generacion varchar(12) = '',
	@elaborado_por varchar(255) = ''
as
begin
	
	set dateformat dmy
	set language 'Spanish'

	declare @codper int = 0, @per_nombres_apellidos varchar(255), @codpla int = 0, @carrera varchar(255), 
	@codcil_desde int = 0, @ciclo_desde varchar(15) = '', @codcil_hasta int = 0, @ciclo_hasta varchar(15) = '', @codcil_penultimo int = 0,
	@anio_desde int = 0, @codcic_desde int = 0, @anio_hasta int = 0, @codcic_hasta int = 0, @suma_anios int = 0, @per_estado varchar(5),
	@comprendido varchar(100) = 'comprendido del 21 de enero al 10 de junio del presente año'--FECHAS DEL ULTIMO CICLO DE ESTUDIO
	, @materias_aprobadas int = 0, @materias_aprobadas_texto varchar(50) = ''--, -1 ciclo de estudio
	, @materias_total_plan int = 0, @materias_total_plan_texto varchar(50) = '',
	@fecha_se_extiende varchar(255) = 'a los veintiocho días del mes de enero del año dos mil veinte'

	declare @dias int = day(@fecha_generacion), @mes int = month(@fecha_generacion), @anio int = year(@fecha_generacion)

	if @opcion = 1
	begin
		select @codper = per_codigo, @per_nombres_apellidos = per_nombres_apellidos, @carrera = pla_alias_carrera,
		@materias_total_plan = pla_n_mat, @codpla = alc_codpla, @per_estado = per_estado
		from ra_per_personas 
			inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
			inner join ra_pla_planes on alc_codpla = pla_codigo
		where per_carnet = @carnet
		
		declare @tbl_ciclos_estudio as table (cil_codigo int, cil_anio int, cil_codcic int)
		insert into @tbl_ciclos_estudio (cil_codigo, cil_anio, cil_codcic)
		select cil_codigo, cil_anio, cil_codcic
		from ra_cil_ciclo
			inner join ra_ins_inscripcion on ins_codcil = cil_codigo and ins_codper = @codper
		where cil_codcic <> 3
		and --Valida que no haya retirado el ciclo
		(select count(1) from ra_ins_inscripcion inner join ra_mai_mat_inscritas on mai_codins = ins_codigo 
		where ins_codcil = cil_codigo and ins_codper = @codper and mai_codpla = @codpla and mai_estado <> 'R') > 0
		order by cil_anio

		select top 1 @codcil_desde = cil_codigo, @anio_desde = cil_anio, @codcic_desde = cil_codcic from @tbl_ciclos_estudio
		order by cil_anio, cil_codcic -- PRIMER CICLO DE ESTUDIO

		select top 1 @codcil_hasta = cil_codigo, @anio_hasta = cil_anio, @codcic_hasta = cil_codcic from @tbl_ciclos_estudio
		order by cil_anio desc, cil_codcic desc -- ULTIMO CICLO ESTUDIO
		
		-- Inicio: Validar ciclos consecutivos
		-- Si no tiene ciclos consecutivos return
		if dbo.fn_validar_ciclos_consecutivos(@codper, @codcic_hasta, @anio_hasta, @anio_desde) = 0
		begin
			print '**NO TIENE CICLOS CONSECUTIVOS, SE TERMINA LA CONSULTA**'
			select @per_nombres_apellidos 'per_nombres_apellidos', '' 'carnet', '' 'carrera', '' 'ciclo_desde', 
			'' 'ciclo_hasta', '' 'comprendido', '' 'materias_aprobadas_texto', 
			'' 'materias_aprobadas', '' 'materias_total_plan_texto', '' 'materias_total_plan',
			'' 'fecha_se_extiende'
			, @administrador 'administrador', @elaborado_por 'elaborado_por'
			
			return
		end
		-- Fin: Validar ciclos consecutivos

		select @ciclo_desde = concat('0', cil_codcic, '-', cil_anio) from ra_cil_ciclo where cil_codigo = @codcil_desde
		select @ciclo_hasta = concat('0', cil_codcic, '-', cil_anio) from ra_cil_ciclo where cil_codigo = @codcil_hasta

		select @comprendido = concat('comprendido del ', day(cil_inicio) ,' de ', lower(DATENAME(MONTH, cil_inicio)), 
									' al ', day(cil_fin), ' de ', lower(DATENAME(MONTH, cil_fin)),' del presente año') 
		from ra_cil_ciclo where cil_codigo = @codcil_hasta

		select @materias_aprobadas = count(distinct mai_codmat)
		from ra_cil_ciclo
			inner join ra_ins_inscripcion on ins_codcil = cil_codigo and ins_codper = @codper
			inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
		where mai_estado <> 'R' and mai_codpla = @codpla and ins_codcil not in(@codcil_hasta)
		
		if @per_estado in ('E', 'G')
			set @materias_aprobadas = @materias_total_plan

		set @materias_aprobadas_texto = dbo.MateriasALetras (@materias_aprobadas)
		set @materias_total_plan_texto = dbo.MateriasALetras (@materias_total_plan)

		set @fecha_se_extiende = 
		replace(
			(concat('a los ', dbo.MateriasALetras (@dias), ' días del mes de ', 
				lower(DATENAME(MONTH, cast(@fecha_generacion as date))), ' del año ', dbo.MateriasALetras (@anio))), ',', ''
		)
		
		select @per_nombres_apellidos 'per_nombres_apellidos', @carnet 'carnet', @carrera 'carrera', @ciclo_desde 'ciclo_desde', 
		@ciclo_hasta 'ciclo_hasta', @comprendido 'comprendido', @materias_aprobadas_texto 'materias_aprobadas_texto', 
		@materias_aprobadas 'materias_aprobadas', @materias_total_plan_texto 'materias_total_plan_texto', @materias_total_plan 'materias_total_plan',
		@fecha_se_extiende 'fecha_se_extiende'
		, @administrador 'administrador', @elaborado_por 'elaborado_por'
	end

end