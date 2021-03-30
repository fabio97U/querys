select * from ra_tde_TipoDeEstudio
select * from ma_ppa_plan_pagos
inner join adm_usr_usuarios on usr_codigo = ppa_codusr
select * from adm_usr_usuarios
where usr_nombre like '%tramit%'

select * from col_tmo_tipo_movimiento
select *--tpgra_valor 'codigo', concat(tpgra_descripcion, ' ', '(', tpgra_monto_pagar, ')') 'valor' 
from ma_tpgra_tipo_pago_graduado where tpgra_activo = 1

select vac_codigo, concat(vac_ValorCuota, ' ', vac_tipo_carrera) vac_ValorCuota
from ra_vac_valor_cuotas where vac_Tipo = 'MAESTRIAS' and vac_activo = 1
order by vac_ValorCuota asc

select *--tpgra_valor 'codigo', concat(tpgra_descripcion, ' ', '(', tpgra_monto_pagar, ')') 'valor' 
from ma_tpgra_tipo_pago_graduado where tpgra_activo = 1