declare @codper int = 224673, @codcil int = 122
--select top 5 * from col_mov_movimientos where mov_codper = @codper and mov_codcil = @codcil order by mov_fecha_registro desc
--select top 2 * from col_pagos_en_linea_estructuradoSP where codper = @codper order by fechahora desc
--select * from user_rpe_resumen_pago_enlinea where rpe_codper = @codper

select * from user_aud_auditoria where aud_codper = @codper order by aud_codigo desc
select * from col_ert_error_transaccion where ert_codper = @codper



--select * from col_pagos_en_linea_estructuradoSP where codper = @codper and Id = 379715 order by fechahora desc
--select mov_codigo, mov_fecha_cobro, mov_lote, mov_recibo, mov_recibo_puntoxpress, mov_descripcion, mov_estado  
--, mov_usuario_anula, mov_fecha_anula, tmo_descripcion, tmo_arancel
--from col_mov_movimientos 
--inner join col_dmo_det_mov on dmo_codmov = mov_codigo
--inner join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
--where mov_codigo = 6147800
--select CONCAT('0',cil_codcic, '-', cil_anio), pon_nombre, pra_fecha from ra_pra_prorroga_acad 
--inner join ra_cil_ciclo on cil_codigo = pra_codcil
--inner join ra_poo_prorroga_otorgar on poo_codigo = pra_codpoo
--inner join ra_pon_ponderacion on pon_codigo = poo_codpon
--where pra_codper = @codper --and pra_codcil = @codcil