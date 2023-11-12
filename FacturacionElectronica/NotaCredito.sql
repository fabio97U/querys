--SELECT * FROM col_fac_facturas WHERE fac_negativo = 1
--UPDATE col_fac_facturas SET fac_tipo = 'NC' WHERE fac_negativo = 1

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-06-23 22:05:21.923>
	-- Description: <Realiza el matenimiento para la creacion de Notas de credito>
	-- =============================================
	-- exec dbo.sp_nota_credito 1
	-- exec dbo.sp_nota_credito 2, 8478
create or alter procedure sp_nota_credito
	@opcion int = 0,
	@codfac int = 0,
	@fecha varchar(12) = '',
	@codtd002 varchar(3) = 0,
	@codtgd007 int = 0,
	@codusr int = 0
as
begin

	set dateformat dmy

	if @opcion = 1-- Lista de creditos fiscal a los que se les puede realizar Nota de credito
	begin
		--Inicio: Quitar este select cuando ya todas los creditos fiscal sean electronicos, 3.5 meses despues de la salida a produccion
		select fac_codigo, CONCAT('Fecha: ', CONVERT(varchar(12), fac_fecha_registro, 103), ' Lote: ', fac_lote, ' Recibo: ', fac_factura, ' Cliente: ', cli_apellidos, ' ', cli_nombres, ' ', cli_nit ) 'credito_fiscal', 'fac' 'origen'
		from col_fac_facturas 
			inner join col_cli_clientes on fac_codcli = cli_codigo
		where fac_tipo = 'C' and fac_estado not in ('A') and fac_codigo_generacion is null
			and fac_fecha_registro > dateadd(mm, -3, getdate())

			union all
		--Fin: Quitar este select cuando ya todas los creditos fiscal sean electronicos, 3.5 meses despues de la salida a produccion

		select codigo_origen, concat('Fecha: ', CONVERT(varchar(12), fecha_registro_origen, 103), ' Codigo generacion: ', codigo_generacion, ' Cliente: ', nombre_receptor), 'vst_encabezado' 'origen'
		from vst_mh_encabezado_facturas 
		where tipo_dte_numero = 3 and codigo_generacion is not null
		and estado_origen not in ('A') and fecha_registro_origen > dateadd(mm, -3, getdate()) 
		order by fac_codigo desc

	end

	if @opcion = 2 -- Detalle del credito fiscal
	begin
		select fac_codigo, dfa_codigo, fac_fecha, fac_fecha_registro, 
			tmo_codigo 'codigo_arancel', tmo_arancel 'arancel', fac_descripcion/*tmo_descripcion*/ 'descripcion_arancel', tmo_valor 'valor_arancel', 
			dfa_valor 'valor', dfa_iva 'iva', 
			case when tmo_medida_mh = 99 then dfa_valor + dfa_iva else 0 end 'venta_exenta',
			case when tmo_medida_mh = 59 then dfa_valor + dfa_iva else 0 end 'venta_gravada',
			dfa_iva 'iva_item', cil_codigo 'codcil', concat('0', cil_codcic, '-', cil_anio) 'ciclo'
		from col_fac_facturas 
			inner join col_dfa_det_fac on dfa_codfac = fac_codigo
			inner join col_tmo_tipo_movimiento on dfa_codtmo = tmo_codigo
			inner join ra_cil_ciclo on dfa_codcil = cil_codigo
			left join col_cli_clientes on fac_codcli = cli_codigo
		where dfa_codfac = @codfac

	end

	if @opcion = 3 -- Inserta el credito fiscal en una nota de credito
	begin
		-- exec dbo.sp_nota_credito @opcion = 3, @codfac = 1, @fecha='26/06/2023', @codtd002 = '03', @codtgd007 = 2, @codusr = 1
		if not exists (select 1 from col_fac_facturas where fac_codfac_referencia_relacionado = @codfac)
		begin
			declare @codfac_nuevo int = 0, @coddfa_nuevo int = 0, @usuario varchar(100) = ''
			select @usuario = usr_usuario from adm_usr_usuarios where usr_codigo = @codusr

			select @codfac_nuevo = isnull(max(fac_codigo),0) + 1 from col_fac_facturas
			select @coddfa_nuevo = isnull(max(dfa_codigo),0) from col_dfa_det_fac
			--Insertar tal cual el @codfac en tabla col_fac insertarlo como nota de creidto fac_tipo NC, tanto encabezado como detalle (detalle va en negativo)
			--select * from col_fac_facturas where fac_codigo = 7763
			--select * from col_fac_facturas where fac_codigo = 7743
			--select @codfac_nuevo '@codfac_nuevo', @coddfa_nuevo '@coddfa_nuevo'

			insert into col_fac_facturas
			(fac_codreg,fac_tipo,fac_codigo, fac_factura, fac_fecha,
			fac_codcli,fac_descripcion, fac_tipo_pago,fac_cheque, fac_estado,fac_tarjeta, fac_usuario, fac_fecha_registro,
			fac_tipo_credito,fac_lote, fac_co016, fac_fp017, fac_referencia_pos, fac_p018, fac_periodo_plazo, fac_codtd002, fac_codtgd007, fac_codfac_referencia_relacionado, fac_documento, fac_negativo)
			select fac_codreg, 'NC' fac_tipo, @codfac_nuevo fac_codigo, fac_factura, cast(@fecha as date) fac_fecha,
			fac_codcli, fac_descripcion, fac_tipo_pago, fac_cheque, fac_estado, fac_tarjeta, @usuario fac_usuario, getdate() fac_fecha_registro,
			fac_tipo_credito, fac_lote, fac_co016, fac_fp017, fac_referencia_pos, fac_p018, fac_periodo_plazo, @codtd002 'codtd002', @codtgd007 'codtgd007', @codfac 'codfac', 'NC', 1
			from col_fac_facturas 
			where fac_codigo = @codfac

			insert into col_dfa_det_fac
			(dfa_codreg, dfa_codfac,dfa_codigo, dfa_codtmo,dfa_cantidad,dfa_valor, dfa_iva, dfa_retencion, dfa_fecha_registro, dfa_mes,dfa_codcil)
			select dfa_codreg, @codfac_nuevo dfa_codfac, 
			row_number() over(order by dfa_codigo) + @coddfa_nuevo 'codfac_nuevo', 
			dfa_codtmo, dfa_cantidad, 
			abs(dfa_valor) * -1 'dfa_valor', abs(dfa_iva) * -1 'dfa_iva', dfa_retencion, getdate() dfa_fecha_registro, dfa_mes, dfa_codcil  
			from col_dfa_det_fac 
			where dfa_codfac = @codfac
			order by dfa_codigo
			--select * from cat_tgd007_tipo_generacion_documento_007

			--alter table col_fac_facturas add fac_codtd002 varchar(3)
			--alter table col_fac_facturas add fac_codtgd007 int
			--alter table col_fac_facturas add fac_codfac_referencia_relacionado int
			select 1 respuesta -- Insertado con exito
		end
		else
		begin
			print 'Ya existe una nota de credito relacionada al credito fiscal ' + cast(@codfac as varchar(10))
			select 0 respuesta -- Ya existe esta nota de credito
		end
	end


end
