declare @codcil_inscribieron int = 123
declare @codcil_no_inscribieron int = 125
select fac_nombre 'Facultad', v.car_nombre 'Carrera', per.per_carnet 'Carnet', per.per_nombres 'Nombres', per.per_apellidos 'Apellidos', 
per.per_email 'Correo personal', per.per_email_opcional 'Correo opcional', per.per_correo_institucional 'Correo institucional',
per.per_telefono 'Telefono', per.per_telefono_oficina 'Telefono oficina', per.per_celular 'Celular', 1 contador
from ra_vst_aptde_AlumnoPorTipoDeEstudio v
inner join ra_per_personas per on per.per_codigo = v.per_codigo
inner join ra_car_carreras c on c.car_codigo = v.car_codigo
inner join ra_fac_facultades on fac_codigo = car_codfac
where ins_codcil = @codcil_inscribieron and per.per_estado not in ('E', 'G')
--and per_codigo = 180168
and per.per_codigo not in (
	select distinct v2.per_codigo from ra_vst_aptde_AlumnoPorTipoDeEstudio v2 where v2.ins_codcil = @codcil_no_inscribieron
)
and per.per_tipo = 'U'
order by fac_nombre, v.car_nombre, per.per_apellidos