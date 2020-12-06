select * from ra_mun_municipios
where MUN_NOMBRE in ('mejicanos', 'san salvador', 'NUEVA SAN SALVADOR '/*'santa tecla'*/)

select 
case when MUN_NOMBRE = 'NUEVA SAN SALVADOR' then 'SANTA TECLA' else MUN_NOMBRE end Municipio, 
per_nombres Nombres, per_apellidos Apellidos, per_direccion Direccion, per_correo_institucional 'Correo institucional', per_email 'Correo personal'
from ra_per_personas
inner join ra_mun_municipios on per_codmun_nac = MUN_CODIGO
where --per_codigo = 181324 and
per_codmun_nac in (3, 11, 151)
and per_tipo = 'U' and per_estado = 'A'
order by MUN_NOMBRE, per_apellidos