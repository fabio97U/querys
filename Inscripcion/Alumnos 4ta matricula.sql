--select * from ra_ins_inscripcion
--inner join ra_per_personas on per_codigo = ins_codper
--where ins_codcil = 123 and per_tipo = 'U' and per_estado not in ('I')
declare @tbl_hoja_asesoria as table (
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
	mat_reprobadasciclo int, uv int, 
	aul_nombre_corto varchar(60), mat_codesc int)

declare @contador int = 1, @total int = 15384 
declare @mvar varchar(12)--Variables del select
declare m_cursor cursor 
for
	select ins_codper from ra_ins_inscripcion
	inner join ra_per_personas on per_codigo = ins_codper
	where ins_codcil = 130 and per_tipo = 'U' and per_estado in ('A')
	order by ins_codper
open m_cursor
 
fetch next from m_cursor into @mvar
while @@FETCH_STATUS = 0 
begin
	print '******* codper: ' + cast(@mvar as varchar(30)) + ', '+ cast(@contador as varchar(30)) + '/'+ cast(@total as varchar(30)) + ' *******'

	insert into @tbl_hoja_asesoria
	exec dbo.web_ins_genasesoria 134, @mvar
	set @contador = @contador + 1
    fetch next from m_cursor into @mvar
end      
close m_cursor  
deallocate m_cursor

select * from @tbl_hoja_asesoria
where matricula >= 4