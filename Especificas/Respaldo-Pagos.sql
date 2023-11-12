declare @tbls_referencias as table (tbls_rpe_num_referencia varchar(30))
insert into @tbls_referencias (tbls_rpe_num_referencia) values 
('74406750324032400375215'), ('74406751009100905107068'), ('74406751012101205001717'), ('74406751012101205002103'), 
('74406751012101205002442'), ('74406751013101315141550'), ('74406751013101317220428'), ('74406751015101517600773'), 
('74406751015101517602498'), ('74406751015101522982158'), ('74406751026102622277009'), ('74406751026102622280482'), 
('74406751046104616325626'), ('74406751066106620655257'), ('74406751066106621705523'), ('74406751066106621706968'), 
('74406751105110504990460'), ('74406751105110504990478'), ('74406751105110519418556'), ('74406751105110519419174'), 
('74406751121112115433492'), ('74406751134113404322177'), ('74406751134113415696874'), ('74406751134113415697260'), 
('74406751136113602939358'), ('74406751136113616547007'), ('74406751151115115144756'), ('74406751151115115145399'), 
('74406751151115115145456'), ('74406751154115400114305'), ('74406751157115723179313'), ('75383960310031022258747'), 
('75383960310031022259182'), ('75383960310031022273019'), ('75383961012101200848046'), ('75383961030103023225236'), 
('75383961030103023228271'), ('75383961031103121873696'), ('75383961044104417966819'), ('75383961096109603588498'), 
('75383961096109603594017'), ('75383961100110006733990'), ('75383961124112403908656'), ('75383961124112403909688'), 
('75383961124112403910652')
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
order by rpe_num_referencia asc