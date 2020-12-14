-- rpe_num_referencia es el bueno, pero hay que recortar las ultimos 12 caracteres
select *, SUBSTRING(rpe_num_referencia, 12, 24) from user_rpe_resumen_pago_enlinea where rpe_autorizacion in
('061896', '036621', '093580', '041825', '086300', '002712', '067468', '025317', '012376', '013881', '073819', '003500', '080690', '038207', '092391', '023933', '007633', '017894', '066111', '038013', '009532', '064365', '071965')
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
--('061896', '036621', '093580', '041825', '086300', '002712', '067468', '025317', '012376', '013881', '073819', '003500', '080690', '038207', '092391', '023933', '007633', '017894', '066111', '038013', '009532', '064365', '071965')
('007633', '017894')
--and rpe_codigo not in (61001)
order by rpe_autorizacion asc
