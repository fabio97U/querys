declare @art_codpers as table (codper int)

insert into @art_codpers (codper)
select distinct per.per_codigo
from col_art_archivo_tal_mora art
inner join ra_per_personas per on art.per_codigo = per.per_codigo
where --per_estado = 'I' and 
ciclo = 123 
--and ins_codper is null

--delete
select *
from col_art_archivo_tal_mora
where per_codigo in (
	select codper from (
		select *, (select ins_codigo from ra_ins_inscripcion where ins_codper = codper and ins_codcil = 123) inscribio 
		from @art_codpers
	) t 
	inner join ra_per_personas on per_codigo = codper
	where inscribio is null--3855
) and ciclo = 123

