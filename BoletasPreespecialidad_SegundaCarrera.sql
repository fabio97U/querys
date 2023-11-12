declare @codcil int = 131
declare @codper int = 0
declare cursordescuen cursor 
for
	select distinct per_codigo from col_art_archivo_tal_preesp_mora where ciclo = @codcil and 
	per_codigo in (
		select distinct detmen_codper from col_detmen_detalle_tipo_mensualidad
			inner join col_tpmenara_tipo_mensualidad_aranceles on detmen_codtpmenara = tpmenara_codigo
			inner join col_tipmen_tipo_mensualidad on tipmen_codigo = tpmenara_codtipmen and tipmen_tipo like '%segund%'
	) --and per_codigo = 148802

open cursordescuen
 
fetch next from cursordescuen into @codper
while @@FETCH_STATUS = 0 
begin
	print '@codper: ' + cast(@codper as varchar(12))
    exec tal_GenerarDataTalonariosPreGrado_TomandoMensualidadConDescuentos 3, @codcil, @codper
	exec tal_GenerarDataTalonariosPreGrado_TomandoMensualidadConDescuentos 4, @codcil, @codper
    fetch next from cursordescuen into @codper
end      
close cursordescuen  
deallocate cursordescuen

--select * from ra_per_personas where per_codigo = 148802
--select * from ra_sca_segunda_carrera where sca_codper_nuevacarrera = 208285

--insert into ra_sca_segunda_carrera (sca_codper_nuevacarrera, sca_coduser) values (208285, 407)

select * from ra_sca_segunda_carrera where sca_codper_nuevacarrera in (

	select distinct per_codigo from col_art_archivo_tal_preesp_mora where ciclo = @codcil and 
	per_codigo in (
		select distinct detmen_codper from col_detmen_detalle_tipo_mensualidad
			inner join col_tpmenara_tipo_mensualidad_aranceles on detmen_codtpmenara = tpmenara_codigo
			inner join col_tipmen_tipo_mensualidad on tipmen_codigo = tpmenara_codtipmen and tipmen_tipo like '%segund%'
	) --and per_codigo = 148802
)
