USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[asis_reportes_asistencias_mae]    Script Date: 27/09/2019 10:00:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Author:	<Adones Calles>
-- Create date: < 09 mayo 2019>
-- Description:	<Asistencia alumnos maestrias>

--[asis_reportes_asistencias_mae] 2,119,0,'01/09/2019','26/09/2019'
--[asis_reportes_asistencias_mae] 1,0,34186,'01/09/2019','26/09/2019'
--[asis_reportes_asistencias_mae] 3,0,0,'01/09/2019','26/09/2019',4358,'CDC1-E','07'


-- exec sp_horario_materia_maes_orden_asignaturas 1, 117, '', '', ''
ALTER procedure [dbo].[asis_reportes_asistencias_mae] 
	@opcion int = 0,
	@codcil int = 0,
	@codhpl int = 0,
	@fecha_inicio varchar(12) = '',
	@fecha_fin varchar(12)='',
	@codemp int=0 ,
	@codmat nvarchar(255)='' ,
	@seccion nvarchar(5)='' 
as
begin

	set dateformat dmy
	declare @AsistenciaEsc table(mat_codigo nvarchar(10),mat_nombre varchar(100),per_codigo int,seccion varchar(3),Docente varchar(80),Asistencia int, Total_dias int,Porcent real)
	declare @inicio as date
	declare @fin as date
	set @inicio = cast(@fecha_inicio as date)
	set @fin = cast(@fecha_fin as date)

	if @opcion = 1 --Asistencia por rango de fechas general por materia 
	begin			
		select mat_codigo,mat_nombre,hpl_descripcion,emp_apellidos_nombres , (1 - round(avg(cast(cast(asis_asistencia as int) as real)),2))*100 Porcent
		from ra_hpl_horarios_planificacion 
			JOIN pla_emp_empleado on emp_codigo = hpl_codemp
			JOIN ra_mat_materias on mat_codigo = hpl_codmat
			JOIN web_tut_asistencia on asis_codmat = hpl_codmat
		where hpl_codigo =@codhpl and convert(varchar,asis_fecha,103) between convert(varchar,@inicio,103) and convert(varchar,@fin,103)
		and asis_seccion = hpl_descripcion and hpl_codcil = asis_codcil
		group by mat_codigo,mat_nombre,hpl_descripcion,emp_apellidos_nombres
	end

	if @opcion = 2 --Asistencia por materias
	begin	
		--*MERCADO DE CAPITALES SEC 01 NO TENIA ACCESO Y TIENE ASISTENCIA FERNANDEZ RODRIGUEZ RICARDO ANTONIO el sabado 21 no tenia acceso
		--*SISTEMAS DE INFORMACION GERENCIAL BANCARIO	01	RODRIGUEZ MEJIA RENE HUMBERTO SOLO REGISTRO 2 Y LE SALE 87% 

		declare @materiasEscuela table (mat_codigo varchar(10),mat_nombre varchar(100),hpl_descripcion varchar(3),emp_apellidos_nombres varchar(80),Porcent real)
		declare @hplMaterias table (hpl_Materias int)

		select * from web_tut_asistencia where asis_codcil = 119 and asis_codmat = 'MERCA-M'
		select distinct asis_fecha from web_tut_asistencia where asis_codcil = 119 and asis_codmat = 'MERCA-M'
		--insert into @hplMaterias
		select * from pla_emp_empleado where emp_codigo in(4392, 2801)
		select hpl_codigo, hpl_codmat, hpl_descripcion, mat_nombre, emp_codigo, emp_nombres_apellidos, count(1)
		from ra_hpl_horarios_planificacion
		inner join ra_mat_materias ON mat_codigo = hpl_codmat 
		inner join pla_emp_empleado on emp_codigo = hpl_codemp
		left join web_tut_asistencia ON asis_codmat= hpl_codmat and asis_seccion = hpl_descripcion and asis_codcil = hpl_codcil
		left join fechas_orden_asignaturas_maes on codhpl = hpl_codigo
        left join ra_man_grp_hor on man_codigo = hpl_codman
		where hpl_codcil = 119 and hpl_codesc = 10 and convert(date,fechaInicio,103) >= convert(date,'01/09/2019',103) and convert(date,fechaFin,103) >= convert(date,'26/09/2019',103)
		and asis_codcil = 119 and asis_codmat = 'MERCA-M'
		group by hpl_codigo, hpl_codmat, hpl_descripcion, mat_nombre, emp_codigo, emp_nombres_apellidos
		order by mat_nombre

		--mat_codesc =10 and hpl_codcil = @codcil and convert(date,fechaInicio,103) >= convert(date,@inicio,103) and convert(date,fechaFin,103) >= convert(date,@fin,103)

		declare @hpl_mat varchar(12)
		DECLARE cursor_mat CURSOR 
		FOR
			select hpl_Materias from @hplMaterias            
		OPEN cursor_mat 
 
		FETCH NEXT FROM cursor_mat INTO @hpl_mat
		WHILE @@FETCH_STATUS = 0 
		BEGIN
			insert into @materiasEscuela
			exec asis_reportes_asistencias_mae 1,0,@hpl_mat,@fecha_inicio,@fecha_fin
		FETCH NEXT FROM cursor_mat INTO @hpl_mat
		END
		CLOSE cursor_mat  
		DEALLOCATE cursor_mat 
		select mat_codigo,mat_nombre,hpl_descripcion,emp_apellidos_nombres ,Porcent from @materiasEscuela 
		order by mat_codigo 
	end 

	if @opcion = 3
	begin

		create table #asistencia_consolidad (per_carnet nvarchar(14), per_apellidos_nombres varchar(201), asistencia int, fecha_asistencia date)

		declare @fechas_columna_pivot as table (id int identity, fecha datetime)
		insert into @fechas_columna_pivot(fecha)
		select distinct asis_fecha from web_tut_asistencia where asis_codtut = @codemp and asis_fecha between @inicio and @fin and asis_codmat = @codmat and asis_seccion = @seccion order by asis_fecha

		declare @i as int = 1
		declare @fechas as int
		declare @fecha date

		select @fechas = count(1) from @fechas_columna_pivot
		while @i <= @fechas
		begin
			select @fecha = fecha from @fechas_columna_pivot where id = @i
			insert into #asistencia_consolidad
			select asis_per_carnet , per_apellidos_nombres , case asis_asistencia when 0 then 1 else 0 end,  @fecha 
			from web_tut_asistencia inner join ra_per_personas on per_carnet = asis_per_carnet
			where asis_codtut = @codemp and asis_fecha = @fecha and asis_codmat = @codmat and asis_seccion = @seccion
			set @i = @i + 1
		end

		declare @SQLQUERYParteUno as nvarchar(max) = 'select per_carnet Carnet, per_apellidos_nombres Estudiante, '
		declare @SQLQueryCOLUMNAS as nvarchar(MAX) = ''
		declare @SQLQUERYParteTRES as nvarchar(555) = ', \'' \'' as \''Porcentaje\'' from #asistencia_consolidad as t where fecha_asistencia = \''' + cast(@fecha as nvarchar)+'\'''

		declare @j int = 1

		select @fechas = count(1) from @fechas_columna_pivot
		while @j <= @fechas
		begin
			select @fecha = fecha from @fechas_columna_pivot where id = @j
			print '@fecha ' + cast(@fecha as nvarchar)
			set @SQLQueryCOLUMNAS = @SQLQueryCOLUMNAS + N'(select asistencia from #asistencia_consolidad where fecha_asistencia = \'''+cast(@fecha as nvarchar)+'\'' and per_carnet = t.per_carnet) as \'''+cast(@fecha as nvarchar)+'\'','
			set @j = @j + 1
		end

		declare @SQLQUERY nvarchar(max) = @SQLQUERYParteUno + substring(replace(@SQLQueryCOLUMNAS, '\', ''), 0, len(replace(@SQLQueryCOLUMNAS, '\', ''))) + replace(@SQLQUERYParteTRES, '\', '')
		print @SQLQUERY

		EXECUTE sp_executesql @SQLQUERY

		drop table #asistencia_consolidad
	end

end


