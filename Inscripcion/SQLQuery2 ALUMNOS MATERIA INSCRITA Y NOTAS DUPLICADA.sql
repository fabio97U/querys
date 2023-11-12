declare @codper int, @codmat varchar(60), @cantidad int
declare @min int, @max int, @notas_de_minima float, @notas_de_maxima float, @codmai_notin int 

declare m_cursor cursor 
for

select ins_codper, mai_codmat, count(1) 'cantidad' from ra_ins_inscripcion
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
where ins_codcil = 126 and mai_estado = 'I'-- and ins_codper = 202714
group by ins_codper, mai_codmat
having count(1) > 1
order by ins_codper

open m_cursor 

fetch next from m_cursor into @codper, @codmat, @cantidad
while @@FETCH_STATUS = 0 
begin
	select @min = min(mai_codigo), @max = max(mai_codigo)  from ra_ins_inscripcion
	inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
	where ins_codper = @codper and mai_codmat in (@codmat) and ins_codcil = 126


	select @notas_de_minima = SUM(not_nota) 
	from ra_not_notas where not_codmai in (
	select mai_codigo from ra_ins_inscripcion
	inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
	where ins_codper = @codper and mai_codmat in (@codmat) and ins_codcil = 126) and not_codmai in (@min)
	--SELECT @notas_de_minima
	select @notas_de_maxima = SUM(not_nota) 
	from ra_not_notas where not_codmai in (
	select mai_codigo from ra_ins_inscripcion
	inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
	where ins_codper = @codper and mai_codmat in (@codmat) and ins_codcil = 126) and not_codmai in (@max)
	--SELECT @notas_de_maxima
	if (@notas_de_minima > @notas_de_maxima or @notas_de_minima = @notas_de_maxima)
		set @codmai_notin = @min

	--delete
	select * 
	from ra_not_notas where not_codmai in (
	select mai_codigo from ra_ins_inscripcion
	inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
	where ins_codper = @codper and mai_codmat in (@codmat) and ins_codcil = 126) and not_codmai not in (@codmai_notin)
	order by not_codmai

	--delete
	select * 
	from ra_mai_mat_inscritas where mai_codigo in (
		select mai_codigo from ra_mai_mat_inscritas
		where mai_codigo in (select mai_codigo from ra_ins_inscripcion
		inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
		where ins_codper = @codper and mai_codmat in (@codmat) and ins_codcil = 126) and mai_codigo not in (@codmai_notin)
	)
	order by mai_codigo

    fetch next from m_cursor into @codper, @codmat, @cantidad
end      
close m_cursor  
deallocate m_cursor