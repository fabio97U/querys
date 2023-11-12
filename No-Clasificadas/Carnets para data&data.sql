select celular, per_nombres, per_apellidos, per_email, carnet, per_direccion from (
select per_codigo, replace(per_carnet, '-', '') 'carnet', per_nombres, per_apellidos, per_email, per_direccion,
ISNULL(replace(replace(per_celular, '-', ''), '_', ''), replace(replace(per_telefono, '-', ''), '_', '')) 'celular' 
from ra_per_personas--241515
where len(per_carnet) = 12 
--and per_codigo = 181324
) t
where len(celular) = 8 and SUBSTRING(celular, 1, 1) in ('6', '7', '2')
order by per_codigo