declare @tbl_hoja_asesoria as table (carnet nvarchar(15), codigo nvarchar(20), materia nvarchar(125), matricula nvarchar(2), hor_descripcion nvarchar(2), man_nomhor nvarchar(50), 
	dias nvarchar(50), plm_ciclo int, hpl_codigo int, hpl_codman int, plm_electiva nvarchar(1), plm_bloque_electiva int, especial nvarchar(1), hpl_tipo_materia nvarchar(2), cumgrl float, 
	cumciclo float, per_nombre nvarchar(125), carrera nvarchar(125), aplan nvarchar(25), mat_aprobadas int, mat_reprobadas int, mat_aprobadasciclo int, mat_reprobadasciclo int, uv int)

--create table #tlb_original (codper int)
--create table #tlb_pruebas (codper int)
declare @contador_alumnos_sin_hoja int = 0, @contador_row int = 0

declare @codper int
declare m_cursor cursor 
for
select distinct top 1000 ins_codper from ra_ins_inscripcion
inner join ra_per_personas on per_codigo = ins_codper
where per_tipo = 'U' and per_estado = 'A' and ins_codcil = 122 --20,888
--and ins_codper = 201281
order by ins_codper asc

open m_cursor 
 
fetch next from m_cursor into @codper

while @@fetch_status = 0 
begin
	declare @per_codigo int = @codper

	insert into @tbl_hoja_asesoria (carnet, codigo, materia, matricula, hor_descripcion, man_nomhor, dias, plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, 
	especial, hpl_tipo_materia, cumgrl, cumciclo, per_nombre, carrera, aplan, mat_aprobadas, mat_reprobadas, mat_aprobadasciclo, mat_reprobadasciclo, uv)
	exec web_ins_genasesoria 124, @per_codigo
	--exec web_ins_genasesoria_PRUEBA 124, @per_codigo
	if ((select count(1) from @tbl_hoja_asesoria) = 0)
	begin
		print '*********=*********'
		print @per_codigo
		set @contador_alumnos_sin_hoja = @contador_alumnos_sin_hoja + 1
		--insert into #tlb_original (codper) values (@per_codigo)
		print @contador_alumnos_sin_hoja

	end
	delete from @tbl_hoja_asesoria
	set @contador_row = @contador_row + 1
	print @contador_row
    fetch next from m_cursor into @codper
end
close m_cursor
deallocate m_cursor
select @contador_alumnos_sin_hoja

--select per_codigo, per_carnet from #tlb_original
--inner join ra_per_personas on per_codigo = codper
--order by per_codigo
----delete from #tlb_original

--select per_codigo, per_carnet from #tlb_pruebas
--inner join ra_per_personas on per_codigo = codper
--order by per_codigo
----delete from #tlb_pruebas
--select * from #tlb_original --where codper = 42535
--select * from #tlb_pruebas --where codper = 42535
--select * from #tlb_original where codper not in (select b.codper from #tlb_pruebas as b)
----erik: 
----angel: 2500
----adones: 6000
----ing: 8000
----fabio: 10000
----respuesta: 4988
----tardo 01h:48m:00s 

----maira 

----aalumnos_evaluado		web_ins_genasesoria_ORIGINAL	sin_hoja	web_ins_genasesoria_2	sin_hoja
----100					00:00:26.896					42			00:00:13.566			45
----100					00:00:26.896					42			00:00:13.566			45
----100					00:00:26.896					42			00:00:12.463			45
----100					00:00:26.896					42			00:00:13.566			45
