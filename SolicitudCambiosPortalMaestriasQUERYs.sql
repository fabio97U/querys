/*
MAESTRIAS CAMBIOS PORTAL
En la cinta de opciones
 --Maestrias virtuales
"Salon de apoyo" en lugar de "Aula Virtual" identificar si es virtual(https://utds.mrooms.net/login/index.php) o si no es virtual (https://www.utecvirtual.edu.sv/index.php)

Replicar en Maestrias Virtual
Aula Virtual
Correo UTEC
Biblioteca
*Si no queda bien bajar las palabras para que quepa*

*/
use uonline
declare @esvirtual int 
select @esvirtual = 1
from ra_per_personas
inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
inner join ra_pla_planes on pla_codigo = alc_codpla
where per_codigo = 172375 and pla_alias_carrera like '%NO PRESE%'
select isnull(@esvirtual, 0)
 