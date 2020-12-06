--drop table soft_con_cus_cuentas_uonline_softland
create table soft_con_cus_cuentas_uonline_softland
(
	cus_codigo int primary key identity (1, 1),
	cus_Cuenta_uonline varchar(50),
	cus_Descripción_uonline varchar(1024),
	cus_Nivel_uonline varchar(50),
	cus_Clase_uonline varchar(50),
	cus_Tipo_uonline varchar(50),
	cus_Grupo_uonline varchar(50),
	cus_Cuenta_Padre_uonline varchar(50),
	cus_CC_Softland varchar(50),
	cus_Cuenta_Sofland varchar(50),
	cus_fecha_hora_creacion datetime default getdate()
)
select * from soft_con_cus_cuentas_uonline_softland --where cus_Cuenta_uonline = '417010564'

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <Create Date>
	-- Description: <Generar la data de la partidad contable para migrarla a softland> select getdate()
	-- =============================================
	-- soft_sp_datos_migracion_excel_softland_partida_cc 1, 1, '15/09/2020', ''--EXISTE
	-- soft_sp_datos_migracion_excel_softland_partida_cc 1, 1, '16/09/2020', ''--NO EXISTE

	-- soft_sp_datos_migracion_excel_softland_partida_cc 2, 1, '10/09/2020', '17/09/2020'--POR RANGO EXISTE
	-- soft_sp_datos_migracion_excel_softland_partida_cc 2, 1, '17/09/2020', '18/09/2020'--POR RANGO NO EXISTE
alter procedure soft_sp_datos_migracion_excel_softland_partida_cc
	@opcion int = 0,
	@codtip int = 0,
	@par_fecha varchar(10) = '',
	@par_fecha_hasta varchar(10) = ''
as
begin
	
	set dateformat dmy

	declare @codpar int
	if @opcion = 1
	begin
		select @codpar = par_codigo from con_par_partidas where par_codtip = @codtip and par_fecha = @par_fecha
		if isnull(@codpar, 0) <> 0
		begin
			select 1 'existe'
			select par_partida 'ASIENTO', ROW_NUMBER() over(order by pad_codigo) 'CONSECUTIVO', 'ND' 'NIT', 
			cus_CC_Softland 'CENTRO_COSTO', cus_Cuenta_Sofland 'CUENTA_CONTABLE',
			'' 'FUENTE', pad_concepto 'REFERENCIA', pad_debe 'DEBITO_LOCAL', pad_haber 'CREDITO_LOCAL'
			from con_pad_partidas_det 
				inner join con_cuc_cuentas_contables on pad_codcuc = cuc_codigo
				inner join soft_con_cus_cuentas_uonline_softland on cus_Cuenta_uonline = cuc_cuenta
				inner join con_par_partidas on par_codigo = pad_codpar
			where pad_codpar = @codpar
		end
		else
		begin
			select 0 'existe'
		end
	end

	if @opcion = 2
	begin
		select @codpar = par_codigo from con_par_partidas where par_codtip = @codtip 
		and convert(date, par_fecha, 103) between convert(date, @par_fecha, 103) and convert(date, @par_fecha_hasta, 103)
		if isnull(@codpar, 0) <> 0
		begin
			select 1 'existe'
			select par_partida 'ASIENTO', row_number() over(order by pad_codigo) 'CONSECUTIVO', 'ND' 'NIT', 
			cus_CC_Softland 'CENTRO_COSTO', cus_Cuenta_Sofland 'CUENTA_CONTABLE',
			'' 'FUENTE', pad_concepto 'REFERENCIA', pad_debe 'DEBITO_LOCAL', pad_haber 'CREDITO_LOCAL'
			from con_pad_partidas_det 
				inner join con_cuc_cuentas_contables on pad_codcuc = cuc_codigo
				inner join soft_con_cus_cuentas_uonline_softland on cus_Cuenta_uonline = cuc_cuenta
				inner join con_par_partidas on par_codigo = pad_codpar
			where 
			--pad_codpar = @codpar
			--and 
			convert(date, par_fecha, 103) between convert(date, @par_fecha, 103) and convert(date, @par_fecha_hasta, 103)
			and par_codtip in (1, 2, 3)
		end
		else
		begin
			select 0 'existe'
		end
	end

end