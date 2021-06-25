declare @tbl_resultado table (
	per_codigo int,
	per_carnet varchar(50),
	per_nombres_apellidos varchar(201),
	pla_alias_carrera varchar(255),
	pla_anio varchar(50),
	tiene_hoja int
)
declare @tbl as table (
	carnet nvarchar(15), codigo nvarchar(22),
	materia nvarchar(125), matricula nvarchar(2),
	hor_descripcion nvarchar(2), man_nomhor nvarchar(50),
	dias nvarchar(200), plm_ciclo int,
	hpl_codigo int, hpl_codman int,
	plm_electiva nvarchar(1), plm_bloque_electiva int,
	especial nvarchar(1), hpl_tipo_materia nvarchar(2),
	cumgrl float, cumciclo float,
	per_nombre nvarchar(125), carrera nvarchar(125),
	aplan nvarchar(25), mat_aprobadas int,
	mat_reprobadas int, mat_aprobadasciclo int,
	mat_reprobadasciclo int, uv int
)

declare @per_codigo int = 0,
	@per_carnet varchar(50) = '',
	@per_nombres_apellidos varchar(201) = '',
	@pla_alias_carrera varchar(255) = '',
	@pla_anio varchar(50) = ''

declare @tiene_hoja int = 0
declare m_cursor cursor 
for
	select per_codigo, per_carnet, per_nombres_apellidos, pla_alias_carrera, pla_anio from ra_alc_alumnos_carrera
	inner join ra_per_personas on alc_codper = per_codigo
	inner join ra_pla_planes on alc_codpla = pla_codigo
	where pla_anio = 2018 and per_estado = 'A' and per_tipo = 'U' 
	and alc_codper in (select distinct ins_codper from ra_ins_inscripcion where ins_codcil = 125) --and alc_codper in (207519, 207443)
                
open m_cursor
 
fetch next from m_cursor into @per_codigo, @per_carnet, @per_nombres_apellidos, @pla_alias_carrera, @pla_anio
while @@FETCH_STATUS = 0 
begin
	insert into @tbl
    exec dbo.web_ins_genasesoria 127, @per_codigo

	set @tiene_hoja= 0
	if (select count(1) from @tbl) > 0
		set @tiene_hoja = 1

	insert into @tbl_resultado (per_codigo, per_carnet, per_nombres_apellidos, pla_alias_carrera, pla_anio, tiene_hoja)
	values (@per_codigo, @per_carnet, @per_nombres_apellidos, @pla_alias_carrera, @pla_anio, @tiene_hoja)
	
	delete from @tbl

    fetch next from m_cursor into @per_codigo, @per_carnet, @per_nombres_apellidos, @pla_alias_carrera, @pla_anio
end      
close m_cursor  
deallocate m_cursor

select * from @tbl_resultado