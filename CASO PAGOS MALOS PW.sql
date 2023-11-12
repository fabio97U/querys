select distinct transa_pwoAuthorizationNumber from vst_pw_trans_aprobadas 
where transa_pwoAuthorizationNumber in ('460040', '979660', '696036', '123523', '404208', '123515', '791685', '791600', '350126', '123452', '123433', '123431', '541154', '123389', '123109', '671325', '537705', '537286', '230506', '230309', '122493', '665575', '665160')
and transa_pwoAuthorizationNumber in ('655678', '435459', '424826', '121556', '654307', '653665', '121522', '121517', '121508', '121506', '454375', '121491', '121490', '381365', '649364', '121334')
order by transa_codigo desc

select * from col_tmo_tipo_movimiento where tmo_descripcion like '%XAMEN  DIFERI%'
select top 30 * from col_mov_movimientos 
where mov_descripcion like '%payw%'
order by mov_codigo desc

create table pagos_pw_BORRAME (fecha datetime, monto float, numero_autorizacion varchar(50), numero_payway varchar(50), numero_referencia varchar(50),
tarjeta varchar(10), nombre_tarjeta varchar(50), concepto varchar(125), codper int, carnet varchar(20), alumno varchar(125), npe varchar(60))

--CURSOR
declare @mcodcil int = 126
declare @fecha datetime, @monto float, @numero_autorizacion varchar(50), @numero_payway varchar(50), @numero_referencia varchar(50),
@tarjeta varchar(10), @nombre_tarjeta varchar(50), @concepto varchar(125), @codper int, @carnet varchar(20), @alumno varchar(125), @npe varchar(60)
declare m_cursor cursor 
for
	select * from pagos_pw_BORRAME where codper not in (216644)
                
open m_cursor
 
fetch next from m_cursor into @fecha, @monto, @numero_autorizacion, @numero_payway, @numero_referencia, @tarjeta, @nombre_tarjeta, @concepto, @codper, @carnet, @alumno, @npe
while @@FETCH_STATUS = 0 
begin
	set @mcodcil = 126
	if @codper = 186860 or @codper = 178307
		set @mcodcil = 125

	exec sp_insertar_respuesta_payway @opcion = 1, @codper = @codper, @codcil = @mcodcil, @npe = @npe, @monto = @monto, @transa_pwoAuthorizationNumber = @numero_autorizacion, 
	@transa_pwoReferenceNumber = @numero_referencia, @transa_pwoPayWayNumber = @numero_payway, @transa_pwoCustomerCCHolder = @nombre_tarjeta, @transa_pwoCustomerCCLastD = @tarjeta, 
	@transa_pwoCustomerCCBrand = 'VISA', @transa_pwoTransactionDate = '2021-10-25', @transa_pwoPaymentNumber = @numero_payway

	exec sp_insertar_pagos_x_carnet_estructurado  @npe, 16, @numero_referencia

    fetch next from m_cursor into @fecha, @monto, @numero_autorizacion, @numero_payway, @numero_referencia, @tarjeta, @nombre_tarjeta, @concepto, @codper, @carnet, @alumno, @npe
end      
close m_cursor  
deallocate m_cursor


SELECT * FROM col_mov_movimientos where mov_codigo in (6716419, 6716418, 6716417, 6716416, 6716415, 6716414, 6716413, 6716412, 6716411, 6716410, 6716409, 6716408, 6716407, 6716406, 6716405, 6716404, 6716403, 6716402, 6716401, 6716400, 6716399, 6716398, 6716397, 6716396)