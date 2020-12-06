declare @codper int, @codmat varchar(60), @cantidad int
declare @min int 

declare m_cursor cursor 
for

select ins_codper, mai_codmat, count(1) 'cantidad' from ra_ins_inscripcion
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
where ins_codcil = 123 and mai_estado = 'I'
group by ins_codper, mai_codmat
having count(1) > 1
order by ins_codper

open m_cursor 

fetch next from m_cursor into @codper, @codmat, @cantidad
while @@FETCH_STATUS = 0 
begin
	select @min = min(mai_codigo) from ra_ins_inscripcion
	inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
	where ins_codper = @codper and mai_codmat in (@codmat) and ins_codcil = 123

	--delete
	select * 
	from ra_not_notas where not_codmai in (
	select mai_codigo from ra_ins_inscripcion
	inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
	where ins_codper = @codper and mai_codmat in (@codmat) and ins_codcil = 123) and not_codmai not in (@min)

	--delete
	select * 
	from ra_mai_mat_inscritas where mai_codigo in (
		select mai_codigo from ra_mai_mat_inscritas
		where mai_codigo in (select mai_codigo from ra_ins_inscripcion
		inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
		where ins_codper = @codper and mai_codmat in (@codmat) and ins_codcil = 123) and mai_codigo not in (@min)
	)

    fetch next from m_cursor into @codper, @codmat, @cantidad
end      
close m_cursor  
deallocate m_cursor