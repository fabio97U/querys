--SOLICITADO POR: REBECA GANUZA
--DESCRIPCION: PODER CAMBIAR LAS FECHAS DE LOS EXAMENES DE UNA FORMAS MAS AUTOMATICA, SE AGRUPO POR BLOQUES SEGUN EL HORARIO DE EXAMENES DEL INSTRUCTIVO ACADEMICO
--DESARROLLADORES INVOLUCRADOS: FABIO, ADONES


alter table dbo.web_ra_caa_calendario_acad add caa_grupo int;  

update web_ra_caa_calendario_acad set caa_grupo = 1 where caa_codigo in(230,231,232,233,234,245,246,247,248,249,146,147,148,149,150,151,152,153,154,155,276,277,278,279,280,487,488,489,490,491,355,356,357,358,359,91,92,93,94,95,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170)
update web_ra_caa_calendario_acad set caa_grupo = 2 where caa_codigo in(271,272,273,274,275,366,367,368,369,370,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,393,394,395,396,397,141,142,143,144,145,121,122,123,124,125)
update web_ra_caa_calendario_acad set caa_grupo = 3 where caa_codigo in(255,256,257,258,259,361,362,363,364,365,111,112,113,114,115,116,117,118,119,120,16,17,18,19,20,21,22,23,24,25,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,224,226,227,228,229,240,241,242,243,244,371,372,373,376,377)
update web_ra_caa_calendario_acad set caa_grupo = 4 where caa_codigo in(51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,284,285,286,287,288,378,379,380,381,382)
update web_ra_caa_calendario_acad set caa_grupo = 5 where caa_codigo in(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,335,336,337,338,339,413,414,415,416,417,26,27,28,29,30,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,294,295,296,297,298,383,384,385,386,387)
update web_ra_caa_calendario_acad set caa_grupo = 6 where caa_codigo in(171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,345,346,347,348,349)
update web_ra_caa_calendario_acad set caa_grupo = 7 where caa_codigo in(201,202,203,204,205,350,351,352,353,354)

--select distinct caa_dias, caa_hora from web_ra_caa_calendario_acad where ISNULL(caa_grupo, 10) = 10
--select * from web_ra_caa_calendario_acad where caa_grupo in (1,2,3,4,5,6,7,8,9)

alter procedure sp_ra_caa_calendario_acad 
	----------------------*----------------------
	-- =============================================
	-- Author:      <Fabio, Adones>
	-- Create date: 2019-02-01 15:37:38.530
	-- Description: <Actualiza los horarios de los examenes por evaluacion por grupo>
	-- =============================================
	--sp_ra_caa_calendario_acad 1, 499, 1, '10/06/2019'
	--sp_ra_caa_calendario_acad 1, 497, 1, 3, '10/06/2019'
	--sp_ra_caa_calendario_acad @opcion, @caa_evaluacion, @caa_grupo, @caa_fecha
	@opcion int,
	@caa_codigo int,
	@caa_evaluacion int,
	@caa_grupo int,--NUEVO
	--@caa_grupo_anterior int,--ANTERIOR
	@caa_fecha varchar(20)
as
begin
	set dateformat dmy;
	declare @caa_fecha_ varchar(20) = case @caa_fecha when '' then null else convert(varchar(10),@caa_fecha,103) end

	if (select isnull(caa_grupo, 0) from web_ra_caa_calendario_acad where caa_codigo = @caa_codigo) = 0 --SI NO TIENE GRUPO SE LE INGRESA UNO
	begin
		--select 'NO TIENE GRUPO'
		update web_ra_caa_calendario_acad set  caa_grupo = @caa_grupo, caa_fecha = @caa_fecha_, caa_evaluacion = @caa_evaluacion  where caa_codigo = @caa_codigo
	end
	/*else if(@caa_grupo <> @caa_grupo_anterior) --SI LE CAMBIO EL GRUPO SE LE ACTUALIZA 
	begin
		update web_ra_caa_calendario_acad set caa_fecha = @caa_fecha_,caa_grupo = @caa_grupo where caa_codigo = @caa_codigo
	end
	*/

	update web_ra_caa_calendario_acad set caa_fecha = @caa_fecha_,caa_grupo = @caa_grupo, caa_evaluacion = @caa_evaluacion where caa_codigo = @caa_codigo

	declare @registros_actualizados int 
	if @opcion = 1 --ACTUALIZA GRUPO
	begin	
		select @registros_actualizados = count(1) from web_ra_caa_calendario_acad where caa_grupo = @caa_grupo and caa_evaluacion = @caa_evaluacion
		update web_ra_caa_calendario_acad set caa_fecha = @caa_fecha_,caa_grupo = @caa_grupo where caa_grupo = @caa_grupo and caa_evaluacion = @caa_evaluacion
		select 'Se actualizaron "' + cast(@registros_actualizados as varchar(5)) +'" fechas de examenes para la evaluacion "'+ cast(@caa_evaluacion as varchar(5))+'" en grupo ' + cast(@caa_grupo as varchar(5))
	end
end

SELECT * from web_ra_caa_calendario_acad where caa_codigo = 497

select * from web_ra_caa_calendario_acad where caa_grupo in (1) and caa_evaluacion = 2