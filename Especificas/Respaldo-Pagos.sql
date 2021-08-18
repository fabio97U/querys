declare @tbls_referencias as table (tbls_rpe_num_referencia varchar(30))
insert into @tbls_referencias (tbls_rpe_num_referencia) values 
('74406751136113616547007')
-- rpe_num_referencia es el bueno, pero hay que recortar las ultimos 12 caracteres

--select * from user_rpe_resumen_pago_enlinea 
--	inner join @tbls_referencias on rpe_num_referencia = substring(tbls_rpe_num_referencia, 12, len(tbls_rpe_num_referencia))
--order by tbls_rpe_num_referencia asc

select per_carnet 'CARNET', rpe_codigo codrpe, per_apellidos_nombres 'Alumno', 
rpe_comercio 'Comercio', rpe_terminal, rpe_autorizacion 'Autorizacion', rpe_tarjeta_enmascarada 'Mascara tarjeta', rpe_monto 'Monto', 
 rpe_boleta 'Boleta', tbls_rpe_num_referencia 'Referencia', rpe_descripcion 'Descripcion', 
rpe_fecha_registro 'Fecha transaccion', rpe_npe 'NPE'
from user_rpe_resumen_pago_enlinea 
	inner join ra_per_personas on per_codigo = rpe_codper
	inner join @tbls_referencias on rpe_num_referencia = substring(tbls_rpe_num_referencia, 12, len(tbls_rpe_num_referencia))
order by Autorizacion asc