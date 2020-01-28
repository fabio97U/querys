declare @codtut int = 3724
declare @codmat nvarchar(255) = 'INEG-M'
declare @seccion nvarchar(5) = '02'
declare @fecha_desde date = '2019-05-11'
declare @fecha_hasta date = '2019-05-21'

create table #asistencia_consolidad (per_carnet nvarchar(14), per_apellidos_nombres varchar(201), asistencia int, fecha_asistencia date)

declare @fechas_columna_pivot as table (id int identity, fecha datetime)
insert into @fechas_columna_pivot(fecha)
select distinct asis_fecha from web_tut_asistencia where asis_codtut = @codtut and asis_fecha between @fecha_desde and @fecha_hasta and asis_codmat = @codmat and asis_seccion = @seccion order by asis_fecha

declare @i as int = 1
declare @fechas as int
declare @fecha date

select @fechas = count(1) from @fechas_columna_pivot
while @i <= @fechas
begin
	select @fecha = fecha from @fechas_columna_pivot where id = @i
	insert into #asistencia_consolidad
	select asis_per_carnet, per_apellidos_nombres, case asis_asistencia when 0 then 1 else 0 end,  @fecha 
	from web_tut_asistencia inner join ra_per_personas on per_carnet = asis_per_carnet
	where asis_codtut = @codtut and asis_fecha = @fecha and asis_codmat = @codmat and asis_seccion = @seccion
	set @i = @i + 1
end
declare @SQLQUERYParteUno as nvarchar(max) = 'select per_carnet, per_apellidos_nombres, '
declare @SQLQueryCOLUMNAS as nvarchar(MAX) = ''
declare @SQLQUERYParteTRES as nvarchar(555) = ' from #asistencia_consolidad as t where fecha_asistencia = \''' + cast(@fecha as nvarchar)+'\'''

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