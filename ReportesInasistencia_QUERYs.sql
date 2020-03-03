--=============================================
--Author:      <Fabio>
--Create date: <2020-02-18 16:54:40.200>
--Description: <Devuelve la cantidad de dias comprendidos en un rango de fechas>
--=============================================
-- select dbo.fn_dias_comprendidos_rango('2020-01-21', '2020-02-16', 7)
ALTER function [dbo].[fn_dias_comprendidos_rango]
(
	@inicio nvarchar(10),--fecha inicio
	@fin nvarchar(10),--fecha fin
	@dia tinyint--0: Cantidad de dias entre @inicio - @fin, 1: Lunes, 2: Martes, 3: Miercoles, 4: Jueves, 5: Viernes, 6: Sabado, 7: Domingo
)
returns int as
begin
	declare @cantidad_dias smallint = 0
	if @dia = 0--Indica que se quiere conocer solo la cantida de dias que separan desde @inicio hasta @fin
	begin
		set @cantidad_dias = datediff(day,@inicio,@fin)
	end
	else
		--set @cantidad_dias = 
		--((datediff(day,@inicio,@fin)+iif(datepart(dw,@inicio)>((@dia)), 
		--datepart(dw,@inicio)-((@dia))-7, datepart(dw,@inicio)-((@dia))))/7)+1
		declare @tablafechas table (fecha date, dia int)
		declare @fecha date, @fecha_fin date = @fin

		set @fecha = @inicio

		while(@fecha <= @fecha_fin)
		begin
			insert into @tablafechas (fecha, dia)
			select @fecha,  
				case 
					when datename(dw,@fecha) = 'Lunes' or datename(dw,@fecha) = 'Monday' then 1
					when datename(dw,@fecha) = 'Martes' or datename(dw,@fecha) = 'Tuesday' then 2
					when datename(dw,@fecha) = 'Miércoles' or datename(dw,@fecha) = 'Wednesday' then 3
					when datename(dw,@fecha) = 'Jueves' or datename(dw,@fecha) = 'Thursday' then 4
					when datename(dw,@fecha) = 'Viernes' or datename(dw,@fecha) = 'Friday' then 5
					when datename(dw,@fecha) = 'Sábado' or datename(dw,@fecha) = 'Saturday' then 6
					when datename(dw,@fecha) = 'Domingo' or datename(dw,@fecha) = 'Sunday' then 7
				end
			set @fecha = dateadd(dd, 1, @fecha)
		end    --     while(@fecha <= cast(@FechaFinal as date))

		select @cantidad_dias = count(1) from @tablafechas 
		where dia = @dia
		group by dia

	return @cantidad_dias
end

-- =============================================
-- Author:      <Fabio>
-- Create date: <2020-02-19 17:17:42.183>
-- Description: <Reporte de inasistencia ingresadas por el docente>
-- =============================================
-- sp_asis_control_asistencias_docente 1, '21/01/2020', '16/02/2020', '122', '8'
ALTER procedure [dbo].[sp_asis_control_asistencias_docente]
	@opcion int, 
	@fecha_desde_ nvarchar(12),
	@fecha_hasta_ nvarchar(12),
	@codcil_ nvarchar(3), 
	@codfac_ nvarchar(2)
as
begin
	set language Spanish  --us_english, Spanish
	set dateformat dmy

	if @opcion = 1
	begin
		declare /*@fecha_desde nvarchar(12) = '21/01/2020', 
		@fecha_hasta nvarchar(12) = '16/02/2020',
		@codcil nvarchar(3) = '122', @codfac nvarchar(2) = '8', */
		@fecha_desde nvarchar(12) = @fecha_desde_, 
		@fecha_hasta nvarchar(12) = @fecha_hasta_,
		@codcil nvarchar(3) = @codcil_, @codfac nvarchar(2) = @codfac_, 
		@fac_nombre varchar(55)

		print @fecha_desde
		print @fecha_hasta
		print @codcil
		print @codfac

		select @fac_nombre = fac_nombre from ra_fac_facultades where fac_codigo = @codfac

		create table #tbl_ns_num_sesiones (
			ns_codhpl int, ns_sesiones smallint, 
			ns_emp_nombres_apellidos varchar(125), ns_mat_codigo varchar(55), 
			ns_mat_nombre varchar(50), ns_hpl_descripcion varchar(5), ns_dias varchar(25), ns_facultad varchar(55), ns_hpl_codemp int
		)
		create table #tbl_nap_num_asis_proc (nap_codhpl int, nap_numero_veces smallint)

		select distinct @fac_nombre as facultad, hpl_codigo, asis_fecha, 
		emp_nombres_apellidos, hpl_codmat, mat_codigo, mat_nombre, hpl_descripcion,
		(
			case when isnull(hpl_lunes, 'N') = 'S' then 'L-' else '' end +
			case when isnull(hpl_martes, 'N') = 'S' then 'M-' else '' end +
			case when isnull(hpl_miercoles, 'N') = 'S' then 'Mi-' else '' end +
			case when isnull(hpl_jueves, 'N') = 'S' then 'J-' else '' end +
			case when isnull(hpl_viernes, 'N') = 'S' then 'V-' else '' end +
			case when isnull(hpl_sabado, 'N') = 'S' then 'S-' else '' end +
			case when isnull(hpl_domingo, 'N') = 'S' then 'D-' else '' end
		) dias,
		hpl_lunes, hpl_martes, hpl_miercoles, hpl_jueves, hpl_viernes, hpl_sabado, hpl_domingo, hpl_tipo_materia, hpl_codemp
		into #tbl_data 
		from ra_hpl_horarios_planificacion 
			inner join ra_esc_escuelas on esc_codigo = hpl_codesc
			inner join ra_fac_facultades on fac_codigo = esc_codfac
			inner join pla_emp_empleado on emp_codigo = hpl_codemp
			inner join ra_mat_materias on mat_codigo = hpl_codmat
			left join web_tut_asistencia on asis_codtut = hpl_codemp and asis_codmat = hpl_codmat and asis_seccion = hpl_descripcion and asis_codcil = hpl_codcil
			inner join ra_plm_planes_materias on plm_codmat = hpl_codmat and plm_ciclo = 1 
		where hpl_codcil = @codcil and fac_codigo = @codfac
		and asis_fecha >= @fecha_desde and asis_fecha <= @fecha_hasta

		declare @codhpl int, @hpl_lunes char(1), @hpl_martes char(1), 
		@hpl_miercoles char(1), @hpl_jueves char(1), 
		@hpl_viernes char(1), @hpl_sabado char(1), @hpl_domingo char(1), @hpl_tipo_materia varchar(5), @contador_dias_sesiones smallint = 0,
		@emp_nombres_apellidos varchar(125), @mat_codigo varchar(55), @mat_nombre varchar(50), @hpl_descripcion varchar(5), @dias varchar(25), @hpl_codemp int

		set @fecha_desde = convert(date, convert(nvarchar(10), @fecha_desde_, 103))
		set @fecha_hasta = convert(date, convert(nvarchar(10), @fecha_hasta_, 103))

		declare m_cursor cursor 
		for

		select hpl_codigo, hpl_lunes, hpl_martes, hpl_miercoles, hpl_jueves, hpl_viernes, hpl_sabado, hpl_domingo, hpl_tipo_materia, 
		emp_nombres_apellidos, mat_codigo, mat_nombre, hpl_descripcion,
		(
			case when isnull(hpl_lunes, 'N') = 'S' then 'L-' else '' end +
			case when isnull(hpl_martes, 'N') = 'S' then 'M-' else '' end +
			case when isnull(hpl_miercoles, 'N') = 'S' then 'Mi-' else '' end +
			case when isnull(hpl_jueves, 'N') = 'S' then 'J-' else '' end +
			case when isnull(hpl_viernes, 'N') = 'S' then 'V-' else '' end +
			case when isnull(hpl_sabado, 'N') = 'S' then 'S-' else '' end +
			case when isnull(hpl_domingo, 'N') = 'S' then 'D-' else '' end
		) dias, hpl_codemp
		from ra_hpl_horarios_planificacion 
			inner join ra_esc_escuelas on esc_codigo = hpl_codesc
			inner join ra_fac_facultades on fac_codigo = esc_codfac
			inner join pla_emp_empleado on emp_codigo = hpl_codemp
			inner join ra_mat_materias on mat_codigo = hpl_codmat
			inner join ra_plm_planes_materias on plm_codmat = hpl_codmat and plm_ciclo = 1
			where hpl_codcil = @codcil and fac_codigo = @codfac
		open m_cursor 
 
		fetch next from m_cursor into @codhpl, @hpl_lunes, @hpl_martes, @hpl_miercoles, @hpl_jueves, @hpl_viernes, @hpl_sabado, @hpl_domingo, @hpl_tipo_materia, @emp_nombres_apellidos, @mat_codigo, @mat_nombre, @hpl_descripcion, @dias, @hpl_codemp

		while @@FETCH_STATUS = 0 
		begin
			set @contador_dias_sesiones = 0
			if @hpl_tipo_materia <> 'V'
			begin
				if @hpl_domingo = 'S'
					select @contador_dias_sesiones += dbo.fn_dias_comprendidos_rango(@fecha_desde, @fecha_hasta, 7)
				if @hpl_lunes = 'S'
					select @contador_dias_sesiones += dbo.fn_dias_comprendidos_rango(@fecha_desde, @fecha_hasta, 1)
				if @hpl_martes = 'S'
					select @contador_dias_sesiones += dbo.fn_dias_comprendidos_rango(@fecha_desde, @fecha_hasta, 2)
				if @hpl_miercoles = 'S'
					select @contador_dias_sesiones += dbo.fn_dias_comprendidos_rango(@fecha_desde, @fecha_hasta, 3)
				if @hpl_jueves = 'S'
					select @contador_dias_sesiones += dbo.fn_dias_comprendidos_rango(@fecha_desde, @fecha_hasta, 4)
				if @hpl_viernes = 'S'
					select @contador_dias_sesiones += dbo.fn_dias_comprendidos_rango(@fecha_desde, @fecha_hasta, 5)
				if @hpl_sabado = 'S'
					select @contador_dias_sesiones += dbo.fn_dias_comprendidos_rango(@fecha_desde, @fecha_hasta, 6)
			end
			else
			begin
				select @contador_dias_sesiones += dbo.fn_dias_comprendidos_rango(@fecha_desde, @fecha_hasta, 0)
			end
			insert into #tbl_ns_num_sesiones(ns_codhpl, ns_sesiones, ns_emp_nombres_apellidos, ns_mat_codigo, ns_mat_nombre, ns_hpl_descripcion, ns_dias, ns_facultad, ns_hpl_codemp)
			values(@codhpl, @contador_dias_sesiones, @emp_nombres_apellidos, @mat_codigo, @mat_nombre, @hpl_descripcion, @dias, @fac_nombre, @hpl_codemp)
			fetch next from m_cursor into @codhpl, @hpl_lunes, @hpl_martes, @hpl_miercoles, @hpl_jueves, @hpl_viernes, @hpl_sabado, @hpl_domingo, @hpl_tipo_materia, @emp_nombres_apellidos, @mat_codigo, @mat_nombre, @hpl_descripcion, @dias, @hpl_codemp
		end      
		close m_cursor  
		deallocate m_cursor
		set @fecha_desde = @fecha_desde_
		set @fecha_hasta = @fecha_hasta_

		insert into #tbl_nap_num_asis_proc (nap_codhpl, nap_numero_veces)
		select hpl_codigo, sum(contador) '#Veces' from (
			select distinct hpl_codigo, asis_fecha, 1 contador 
			from #tbl_data
		) t
		group by hpl_codigo

		declare @cols nvarchar(MAX), @query nvarchar(MAX);
		SET @cols = stuff(
			(
				select distinct ','+--QUOTENAME(convert(date, asis_fecha, 103)) 
				QUOTENAME(concat(convert(date, asis_fecha, 103), ' ', substring(datename(dw, asis_fecha), 1, 3))) 
				from #tbl_data
				for xml path(''), type
			).value('.', 'nvarchar(max)'), 1, 1, '');

		SET @query = '
			select distinct
			isnull(data.facultad, ns.ns_facultad) facultad,
			isnull(data.hpl_codemp, ns.ns_hpl_codemp) codemp,
			isnull(data.emp_nombres_apellidos, ns.ns_emp_nombres_apellidos) docente, 
			isnull(data.mat_codigo, ns.ns_mat_codigo) codmat, isnull(data.mat_nombre, ns.ns_mat_nombre) materia,
			isnull(data.hpl_descripcion, ns.ns_hpl_descripcion) seccion, '+@cols+', isnull(ns.ns_sesiones, 0) sesiones, 
			isnull(data.nap_numero_veces, 0) veces, 
			isnull(data.dif, (ns.ns_sesiones - 0)) veces_no_subio
			from #tbl_ns_num_sesiones as ns
			left join (
				select *, (ns_sesiones - nap_numero_veces) ''dif'' from (
					select * from (
						select facultad, hpl_codemp, hpl_codigo, emp_nombres_apellidos, mat_codigo, mat_nombre, hpl_descripcion, dias, '+@cols+' 
							from (
							select distinct facultad, hpl_codemp, hpl_codigo, emp_nombres_apellidos, hpl_codmat,mat_codigo, mat_nombre, hpl_descripcion, dias,
							concat(convert(date, asis_fecha, 103), '' '', substring(datename(dw, asis_fecha), 1, 3)) asis_fecha
							, 1 contador
							from #tbl_data
						) t pivot (count(contador) for asis_fecha in ('+@cols+')) p
					) ta
					left join #tbl_ns_num_sesiones on ns_codhpl = hpl_codigo
					left join #tbl_nap_num_asis_proc on nap_codhpl = hpl_codigo
				) tab
			) as data
			on ns.ns_codhpl = data.hpl_codigo
			order by 4, 3 asc';

		exec (@query);

		drop table #tbl_ns_num_sesiones
		drop table #tbl_nap_num_asis_proc
		drop table #tbl_data
	end
end