declare @tbls_referencias as table (tbls_autorizacion varchar(30))
insert into @tbls_referencias (tbls_autorizacion) values 
('537749'), ('878417')

select distinct vst.transa_codigo codtransa, vst.per_carnet 'Carnet', vst.per_apellidos_nombres 'Nombre completo', per.per_dui 'DUI', per.per_nit 'NIT', 
per.per_email 'Correo', per.per_email_opcional 'Correo alterno', per.per_celular 'Celular', per.per_telefono 'Telefono', per.per_direccion 'Direccion',
vst.transa_pwoAuthorizationNumber 'Autorizacion', vst.transa_pwoCustomerCCLastD 'Mascara tarjeta', vst.dmo_abono 'Monto', vst.tmo_arancel 'Arancel', vst.tmo_descripcion 'Concepto',
vst.transa_pwoReferenceNumber 'ReferenceNumber', vst.transa_pwoPayWayNumber 'PayWayNumber',
vst.transa_pwoCustomerCCHolder 'CustomerCCHolder', vst.transa_pwoCustomerCCBrand 'CustomerCCBrand',
vst.transa_npe 'NPE', 'Aprobado' 'Estado', vst.transa_fecha_creacion 'Fecha transaccion'
from vst_pw_trans_aprobadas vst
	inner join ra_per_personas per on per_codigo = transa_codper
where transa_pwoAuthorizationNumber in (select tbls_autorizacion from @tbls_referencias)
order by Autorizacion asc


--select * from pw_transa_transaccion_aprobada where transa_codigo in (
--	15027, 15029, 15030
--)