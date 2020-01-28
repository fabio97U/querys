--NPE: 0313006300251565201570120192
--CODIGO BARRA: 4157419700003137390200000063009620190616802025156520157012019

--NPE: 0313007300251565201570120190
--CODIGO BARRA: 4157419700003137390200000063009620190616802025156520157012019

--41574197000031373902--00000080009620190116802025156520151012019
--select right('00000000'+cast(floor(1) as varchar),8)

--exec tal_generarCodigoBarraPagoBacoAzul 1, '25-1565-2015', 119, 35755, 5, 852, ''									--Crea el codigo de barra
--exec tal_generarCodigoBarraPagoBacoAzul 2, '', 0, 0, 0, 0, '25156520150000001200012019103575505000852'			--Lee el codigo de barra
create procedure tal_generarCodigoBarraPagoBacoAzul
	@opcion int,
	@carnet varchar(50) = '',
	@codcil int = 0,
	@codhpl int = 0,
	@evaluacion int = 0,
	@codtmo int = 0,
	@codigobarra varchar(255)
as
begin
	begin tran
	begin try
		if @opcion = 1--Crea el codigo de barra
		begin
			set @carnet = replace(@carnet,'-', '')
			declare @ciclo varchar(8)
			declare @codper int
			select @ciclo = concat('0',cil_codcic, cil_anio) from ra_cil_ciclo where cil_codigo = @codcil
			--set @ciclo varchar(12) = '012019'
			--declare @codhpl int = 35755
			--declare @evaluacion int = 5

			--declare @codtmo int = 852--'R-03' RETIRO DE MATERIA
			declare @afecta_materia int
			declare @tipoficacion_arancel int--1:PERMANENTE, 2: TEMPORAL
			declare @monto real 

			select @afecta_materia = case tmo_afecta_materia when 'S' then 1 when 'N' then 0 else -1 end, @tipoficacion_arancel = ta_codigo, @monto = tmo_valor * 100
			from col_tmo_tipo_movimiento inner join col_ta_tipificacion_arancel on tmo_codta = ta_codigo  
			where tmo_codigo = @codtmo
			print '@afecta_materia ' + cast(@afecta_materia as varchar)
			print '@tipoficacion_arancel ' + cast(@tipoficacion_arancel as varchar) 

			select 
			concat(@carnet, '-') 'carnet', 
			concat(RIGHT('0000000000' + convert(varchar, @monto,128), 10), '-') 'monto',
			concat(@ciclo,'-') 'ciclo',
			concat(@afecta_materia , convert(varchar, RIGHT('000000' + cast(floor(@codhpl) as varchar), 6)), '-') 'hpl',
			concat(RIGHT('00' + convert(varchar, @evaluacion), 2), '-') 'unidad',
			concat(RIGHT('000000' + convert(varchar, @codtmo), 6), '-') 'codtmo'

			set @codigobarra = 
					concat(
						(@carnet), 
						(RIGHT('0000000000' + convert(varchar, @monto,128), 10)),
						(@ciclo),
						concat(@afecta_materia , convert(varchar, RIGHT('000000' + cast(floor(@codhpl) as varchar), 6))),
						(RIGHT('00' + convert(varchar, @evaluacion), 2)),
						(RIGHT('000000' + convert(varchar, @codtmo), 6))
					)
			print '@codigobarra ' + cast(@codigobarra as varchar(255))
			--insert into col_tbl_codigo_barra (codper, codigobarra) values(@codper, @codigobarra)
		end--if @opcion = 1

		if @opcion = 2 --Lee el codigo de barra
		begin
			select @codigobarra

		end--if @opcion = 2

		commit tran
	end try
	begin catch
		rollback tran 
		select '00000000000000000000000000000000000000000'

		SELECT error_number() AS 'error_numero', error_procedure() AS 'error_procedure', error_line() AS 'error_linea', error_message() AS 'error';  
	end catch
	--select top 10 * from col_tmo_tipo_movimiento where tmo_arancel like '%R-03%'
	--select * from col_ta_tipificacion_arancel
end