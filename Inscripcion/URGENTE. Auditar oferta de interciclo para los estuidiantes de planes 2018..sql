begin

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

	declare @tbl as table (per_codigo int, carnet varchar(50), nombres_apellidos varchar(255), 
	carrera varchar(255), pla_nombre varchar(255), materias_pasadas int, tiene_hoja int)
	
	print 'planes 2018'
	insert into @tbl (per_codigo, carnet, nombres_apellidos, carrera, pla_nombre, materias_pasadas)
	select v.per_codigo, per_carnet, per_nombres_apellidos, car_nombre, v.pla_nombre, count(distinct mai_codmat) 'materias_aprobadas' 
	from ra_vst_aptde_AlumnoPorTipoDeEstudio v
		inner join notas n on v.per_codigo = n.ins_codper AND V.pla_codigo = N.mai_codpla
	where v.ins_codcil = 128 and v.per_estado = 'A'	and v.pla_nombre like '%2018%' 
	and nota > 6.0
	group by v.per_codigo, per_carnet, per_nombres_apellidos, car_nombre, v.pla_nombre

	print 'planes 2011'
	insert into @tbl (per_codigo, carnet, nombres_apellidos, carrera, pla_nombre, materias_pasadas)
	select v.per_codigo, per_carnet, per_nombres_apellidos, car_nombre, v.pla_nombre, count(distinct mai_codmat) 'materias_aprobadas' 
	from ra_vst_aptde_AlumnoPorTipoDeEstudio v
		inner join notas n on v.per_codigo = n.ins_codper AND V.pla_codigo = N.mai_codpla
	where v.ins_codcil = 128 and v.per_estado = 'A'	and v.pla_nombre like '%2011%' 
	and nota > 6.0
	group by v.per_codigo, per_carnet, per_nombres_apellidos, car_nombre, v.pla_nombre

	SELECT * FROM @tbl

	declare @mvar varchar(12)--Variables del select
	declare m_cursor cursor 
	for
		select per_codigo from @tbl where materias_pasadas >= 16
	open m_cursor
 
	fetch next from m_cursor into @mvar
	while @@FETCH_STATUS = 0 
	begin
		print '******* ' + cast(@mvar as varchar(30)) + ' *******'
		delete from @tbl_hoja_asesoria

		insert into @tbl_hoja_asesoria
		exec dbo.web_ins_genasesoria 132, @mvar

		update @tbl set tiene_hoja = (select count(1) from @tbl_hoja_asesoria) where per_codigo = @mvar

		fetch next from m_cursor into @mvar
	end      
	close m_cursor  
	deallocate m_cursor

	select * from @tbl




end