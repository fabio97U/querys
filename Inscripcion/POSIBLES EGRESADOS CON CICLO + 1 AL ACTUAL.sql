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

declare @mvar varchar(12)--Variables del select
declare m_cursor cursor 
for
	select ins_codper from ra_ins_inscripcion
	inner join ra_per_personas on per_codigo = ins_codper
	where ins_codcil = 126 and per_tipo = 'U' and per_estado in ('A')
	order by ins_codper -- 16904
open m_cursor
 
fetch next from m_cursor into @mvar
while @@FETCH_STATUS = 0 
begin
	print '******* ' + cast(@mvar as varchar(30)) + ' *******'
	insert into @tbl_hoja_asesoria
	exec dbo.web_ins_genasesoria 128, @mvar
    fetch next from m_cursor into @mvar
end      
close m_cursor  
deallocate m_cursor

declare @tbl_consolidado as table (carnet varchar(20), mat_aprobadas int, 
posibles_inscritas_01_02022 int, posibles_inscritas_limitadas_01_02022 int, materias_aprobadas int)

insert into @tbl_consolidado (carnet, mat_aprobadas, posibles_inscritas_01_02022, posibles_inscritas_limitadas_01_02022, materias_aprobadas)
select *, (mat_aprobadas + posibles_inscritas_limitadas_01_02022) 'materias_aprobadas' from (
	select *, IIF(posibles_inscritas_01_02022 > 5, 5, posibles_inscritas_01_02022) 'posibles_inscritas_limitadas_01_02022' from (
		select carnet, mat_aprobadas, count(distinct codigo) 'posibles_inscritas_01_02022' from @tbl_hoja_asesoria
		group by carnet, mat_aprobadas
	) t
) t2

select a.carnet, per_nombres_apellidos, pla_alias_carrera, a.* from @tbl_consolidado a
	inner join ra_per_personas on carnet = per_carnet
	inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
	inner join ra_pla_planes on alc_codpla = pla_codigo
where a.materias_aprobadas >= pla_n_mat