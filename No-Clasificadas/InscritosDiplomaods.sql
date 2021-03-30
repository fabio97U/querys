select * from dip_dip_diplomados where dip_codigo = 1031
-- 1032, DIPLOMADO: COACHING PARA LA GESTION DEL TALENTO HUMANO
-- 1031, DIPLOMADO: EXPORTACIONES E IMPORTACIONES VIRTUAL

select per_carnet 'Carnet', per_nombres 'Nombres', per_apellidos 'Apellidos', per_email 'Correo', per_telefono 'Telefono', per_celular 'Celular',
case when isnull(per_carnet_anterior, '') = '' then 'Externo UTEC' else 'Graduado UTEC' end 'Tipo'
from dip_ped_personas_dip 
inner join ra_per_personas on per_codigo = ped_codper
where ped_coddip = 1031