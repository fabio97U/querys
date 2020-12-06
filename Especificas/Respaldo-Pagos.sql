select * from user_rpe_resumen_pago_enlinea where rpe_autorizacion in
('486965', '498725', '044258', '034584')
--and rpe_codigo not in (61001)
order by rpe_autorizacion asc

--EXISTE: '498725', '044258', '034584'
-- NO EXISTE: '486965'

select per_carnet 'CARNET', rpe_codigo codrpe, per_apellidos_nombres 'Alumno', 
rpe_comercio 'Comercio', rpe_terminal, rpe_autorizacion 'Autorizacion', rpe_tarjeta_enmascarada 'Mascara tarjeta', rpe_monto 'Monto', 
 rpe_boleta 'Boleta', rpe_num_referencia 'Referncia', rpe_descripcion 'Descripcion', 
rpe_fecha_registro 'Fecha transaccion', rpe_npe 'NPE'
from user_rpe_resumen_pago_enlinea 
inner join ra_per_personas on per_codigo = rpe_codper
where rpe_autorizacion in
('486965', '498725', '044258', '034584')
--and rpe_codigo not in (61001)
order by rpe_autorizacion asc
