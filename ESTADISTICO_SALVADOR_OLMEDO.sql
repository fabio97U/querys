alter procedure sp
	-- sp 2, 120
	@opcion smallint,
	@codcil int
as
begin
	if @opcion = 1
	begin
		-- Total de grupos de clases por escuela y ciclo
		select hpl_codmat, mat_nombre, esc_nombre, count(1) 'Total de grupos' from ra_hpl_horarios_planificacion 
		inner join ra_mat_materias on mat_codigo = hpl_codmat
		inner join ra_esc_escuelas on hpl_codesc = esc_codigo
		where hpl_codcil = @codcil
		group by hpl_codmat, mat_nombre, esc_nombre
		order by esc_nombre, mat_nombre
	end

	if @opcion = 2
	begin
		---	Grupos de materias nuevas que se han abierto por ciclo (en el caso de los ingleses de negocios hay que diferenciar con las unidades	valorativas que para el plan 2018 son de 6)
		select esc.esc_codigo, esc.esc_nombre,  dbo.cantidad_inscritos_escuela_ciclo(esc.esc_codigo, @codcil) 'Cant. Grupos', isnull(res.[01], 0) [01], isnull(res.[Cant. Sec.], 0) [Cant. Sec.]
		from ra_esc_escuelas as esc
		left join (
			select tab.esc_codigo, tab.esc_nombre,count(distinct mai_codmat) '01', count(1) 'Cant. Sec.'
			from (select distinct hpl_tipo_materia, mai_codmat, mat_nombre, esc_codigo, esc_nombre, mai_uv, hpl_descripcion--, count(1) 'cant sec'
			from ra_hpl_horarios_planificacion
			inner join ra_mat_materias on mat_codigo = hpl_codmat
			inner join ra_mai_mat_inscritas on mai_codmat = mat_codigo
			inner join ra_esc_escuelas on esc_codigo = mat_codesc
			where hpl_codcil = @codcil and hpl_codesc <> 10
			and hpl_codmat not in 
			(select distinct hpl_codmat from ra_hpl_horarios_planificacion inner join ra_mai_mat_inscritas on mai_codhpl = hpl_codigo where hpl_codcil <> @codcil and hpl_codcil < @codcil)
			) as tab
			group by /*hpl_tipo_materia, mai_codmat, mat_nombre, mai_uv, */tab.esc_codigo, tab.esc_nombre
		) as res on res.esc_codigo = esc.esc_codigo
		where esc.esc_codigo not in( 10, 13)
		order by  esc.esc_nombre
	end

	if @opcion = 3 
	begin
		--- Cantidad de secciones de estos grupos.
		select hpl_codmat, isnull(mat_nombre, 'N/A') 'materia', count(1) 'Cantidad de secciones' from ra_hpl_horarios_planificacion 
		inner join ra_mat_materias on mat_codigo = hpl_codmat
		where hpl_codcil = @codcil
		group by hpl_codmat, mat_nombre
		order by mat_nombre
	end
end
select 
select * from ra_esc_escuelas 

select * from ra_hpl_horarios_planificacion 
inner join ra_mai_mat_inscritas on mai_codmat = hpl_codmat
inner join ra_pla_planes on pla_codigo = mai_codpla
where hpl_codmat ='TAI1-AC' and hpl_codcil = 116
order by mai_uv desc

--SELECT distinct hpl_codmat, hpl_codcil, concat('0', cil_codcic, '-', cil_anio) 'ciclo'
--from ra_hpl_horarios_planificacion 
--inner join ra_cil_ciclo on cil_codigo = hpl_codcil
--where hpl_codmat in ('AUDS-V')
--select * from ra_hpl_horarios_planificacion 
--inner join ra_esc_escuelas on esc_codigo = hpl_codesc
--where hpl_codmat = 'AUIN-V'
--select * from ra_ins_inscripcion 
--inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
--where ins_codcil = 78 and mai_codmat in ('AUIN-V')

ALTER function [dbo].[cantidad_inscritos_escuela_ciclo]
 (@codesc int, @codcil int)
returns int as
begin
	declare @cantidad int = 1
	select @cantidad = count(1) from (
	select distinct hpl_codmat, hpl_descripcion from ra_hpl_horarios_planificacion 
	inner join ra_mai_mat_inscritas on mai_codhpl = hpl_codigo
	where hpl_codesc = @codesc and hpl_codcil = @codcil
	) as t
	return @cantidad
end