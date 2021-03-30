select distinct per.per_codigo, per.per_carnet, per.per_apellidos_nombres, per.per_codvac
from ra_vst_aptde_AlumnoPorTipoDeEstudio as vst
inner join col_mov_movimientos on mov_codper = per_codigo
inner join col_dmo_det_mov on dmo_codmov = mov_codigo
inner join vst_Aranceles_x_Evaluacion on are_codtmo = dmo_codtmo
inner join ra_per_personas as per on per.per_codigo = vst.per_codigo
where tde_codigo = 1 and ins_codcil = 123--15,485
and per.per_codigo not in (
	select distinct per_codigo from col_art_archivo_tal_mora
	where ciclo = 125--16,199
)
--and mov_codper = 173322 
and mov_codcil = 123
and are_tipo = 'PREGRADO' and are_cuota = 6 and per_codvac not in (17, 18)


declare @contador int = 0
declare @codper varchar(12)--Variables del select
declare m_cursor cursor 
for
	select distinct per.per_codigo--, per.per_carnet, per.per_apellidos_nombres, per.per_codvac
	from ra_vst_aptde_AlumnoPorTipoDeEstudio as vst
	inner join col_mov_movimientos on mov_codper = per_codigo
	inner join col_dmo_det_mov on dmo_codmov = mov_codigo
	inner join vst_Aranceles_x_Evaluacion on are_codtmo = dmo_codtmo
	inner join ra_per_personas as per on per.per_codigo = vst.per_codigo
	where tde_codigo = 1 and ins_codcil = 123--15,485
	and per.per_codigo not in (
		select distinct per_codigo from col_art_archivo_tal_mora
		where ciclo = 125--16,199
	)
	--and mov_codper = 173322 
	and mov_codcil = 123
	and are_tipo = 'PREGRADO' and are_cuota = 6 and per_codvac not in (17, 18)
open m_cursor
 
fetch next from m_cursor into @codper
while @@FETCH_STATUS = 0 
begin
	print '@codper: ' + cast(@codper as varchar(12))
	exec tal_GenerarDataTalonarioPreGrado_porAlumno  -1, 1, 123, 123, @codper
    exec tal_GenerarDataTalonarioPreGrado_porAlumno  2, 1, 125, 125, @codper
	set @contador = @contador + 1
    fetch next from m_cursor into @codper
end      
close m_cursor  
deallocate m_cursor

select @contador 'boletas_generadas'





--exec tal_GenerarDataTalonarioPreGrado_porAlumno  2, 1, 125, 125, 200969

--select * from col_mov_movimientos
--inner join col_dmo_det_mov on dmo_codmov = mov_codigo
--inner join vst_Aranceles_x_Evaluacion on are_codtmo = dmo_codtmo
--where mov_codper = 173322 and mov_codcil = 123
--and are_tipo = 'PREGRADO' and are_cuota = 6