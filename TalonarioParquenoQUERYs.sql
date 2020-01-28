
--drop table col_parq_parqueo
create table col_parq_parqueo(
	parq_codigo int identity(1,1),
	parq_codtmo int primary key,
	parq_fechahora datetime default getdate()
)
--select  parq_codigo 'codparq', tmo_codigo, tmo_descripcion, tmo_arancel, parq_fechahora from col_parq_parqueo 
--inner join col_tmo_tipo_movimiento on tmo_codigo = parq_codtmo 
--declare @res varchar(5)
--select @res = 1 from col_parq_parqueo 
--inner join col_tmo_tipo_movimiento on tmo_codigo = parq_codtmo and tmo_arancel in('T-04')
--select isnull(@res, 0)
--insert into col_parq_parqueo(parq_codtmo)
--select * from col_tmo_tipo_movimiento where tmo_descripcion like '%talonario%'

create procedure sp_col_parq_parqueo
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-07-19 15:20:50.140>
	-- Description: <Realiza el mantenimento a la tabla col_parq_parqueo que se usa en el formulario col_definicion_aranceles_parqueo.aspx> select getdate()
	-- =============================================
	--sp_col_parq_parqueo 1, 'parque'
	--sp_col_parq_parqueo 2
	@opcion int = 1,
	@arancel varchar(255) = '',
	@codparq int = 0,
	@parq_codtmo int = 0
as
begin
	if @opcion = 1--Devuelve la data de los aranceles que no estan ingresados en la tabla "col_parq_parqueo"
	begin
		select * from (
		select tmo_codigo, tmo_descripcion, tmo_arancel from col_tmo_tipo_movimiento 
		where tmo_arancel like '%'+@arancel+'%' or tmo_descripcion like '%'+@arancel+'%'
		) as t
		where t.tmo_codigo not in (select parq_codtmo from col_parq_parqueo)
	end

	if @opcion = 2 --Devuelve la data de los aranceles de parqueo ingresados
	begin
		select  parq_codigo 'codparq', tmo_codigo, tmo_descripcion, tmo_arancel, parq_fechahora from col_parq_parqueo 
		inner join col_tmo_tipo_movimiento on tmo_codigo = parq_codtmo 
		order by parq_codigo desc
	end

	if @opcion = 3 --Inserta el arancel a la tabla col_parq_parqueo
	begin
		insert into col_parq_parqueo(parq_codtmo) values (@parq_codtmo)
	end

	if @opcion = 4
	begin
		delete from col_parq_parqueo where parq_codigo = @codparq
	end
end

--exec sp_rango_Fechas_talonario_parqueo 119,'22/07/2019','23/07/2019'
alter proc [dbo].[sp_rango_Fechas_talonario_parqueo]
       @ciclo varchar(12),
	   @fechaini varchar(12),
	   @fechafin varchar(12)
as 
begin
	set dateformat ymd
    select per_carnet, per_nombres_apellidos, 
	--(select '0' + (SELECT CAST(cil_codcic AS varchar) + ' - ' + CAST(cil_anio as varchar)) from ra_cil_ciclo join ra_cic_ciclos on cic_codigo = cil_codcic where cil_codigo = @ciclo) Ciclo
	concat(' 0', cil_codcic, ' - ', cil_anio) Ciclo
	,dmo_valor as valorTalonario,	
	mov_recibo, mov_lote, tmo_arancel, tal_num_talonario as Num_Talonario, 
	convert(datetime,tal_Fecha,103) fechaIni, convert(datetime,tal_Fecha,103) fechaFin,	
	mov_usuario as Usuario 
	from col_mov_movimientos
	inner join col_dmo_det_mov on dmo_codmov = mov_codigo
	inner join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
	inner join col_tal_dmo_talonario on  tal_coddmo = dmo_codigo
	inner join ra_per_personas on per_codigo=mov_codper
	inner join ra_cil_ciclo on mov_codcil = cil_codigo
	where --dmo_codcil=@ciclo and
	--and convert(datetime,tal_Fecha,103) between convert(datetime,@fechaini,103) and convert(datetime,@fechafin,103)
	--and convert(date, tal_fecha , 103) >= convert(date,@fechaini,103) and convert(date, tal_fecha , 103) <= convert(date,@fechafin,103)
	convert(date, tal_Fecha, 103) >= convert(date,@fechaini,103) and convert(date, tal_Fecha, 103) <= convert(date,@fechafin,103)     
    --select convert(datetime,'15/11/2017',103)
	--tal_num_talonario in(20001, 20002)
    order by fechaIni,fechaFin desc
end