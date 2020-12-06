--Entre 5 a 10 asignaturas
--Entre 11 a 15 asignaturas
--Entre 16 a 20 asignaturas
--Entre 21 a 25 asignaturas
--Más de 26 asignaturas
select *, 
case 
when num_materias_apro >= 0 and num_materias_apro < 5 then 'Entre 0 a 4 asignaturas'
when num_materias_apro >= 5 and num_materias_apro <=10 then 'Entre 5 a 10 asignaturas'
when num_materias_apro >= 11 and num_materias_apro <=15 then 'Entre 11 a 15 asignaturas'
when num_materias_apro >= 16 and num_materias_apro <=20 then 'Entre 16 a 20 asignaturas'
when num_materias_apro >= 21 and num_materias_apro <=25 then 'Entre 21 a 25 asignaturas'
else 'Más de 26 asignaturas'
end 'Rango de materias'
from (
select car_identificador 'Cod', car_nombre 'Carrera', per_carnet 'Carnet',  
dbo.mat_gral_apro(per_codigo)  'num_materias_apro', 
pla_n_mat 'Materias-Carrera',
per_apellidos 'Apellidos', per_nombres 'Nombres', per_est_civil 'Estado civil', 
per_sexo 'Sexo', per_direccion 'Direccion', convert(nvarchar, per_fecha_nac, 103) 'Fecha nacimiento', 
per_telefono 'Telefono', per_celular 'Celular', per_tel_trabajo 'Telefono trabajo', per_telefono_oficina, 
per_emergencia 'En caso de emergencia', per_emer_tel, per_sangre 'Sangre',
per_email 'Correo personal', per_correo_institucional 'Correo institucional',
ist_nombre 'Instituto graduacion', per_nota_paes 'Nota PAES',
MUN_NOMBRE 'Municipio nacimiento', DEP_NOMBRE 'Departamento nacimiento', pai_nombre 'Pais'
from ra_per_personas
inner join ra_mun_municipios on  per_codmun_nac = MUN_CODIGO
inner join ra_dep_departamentos on MUN_CODDEP = DEP_CODIGO
inner join ra_pai_paises on pai_codigo = DEP_CODPAI
inner join adm_ist_instituciones on ist_codigo = per_colegio_graduacion
inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
inner join ra_pla_planes on alc_codpla = pla_codigo
inner join ra_car_carreras on car_codigo = pla_codcar
where substring(per_carnet, 9, 4) in ('2015', '2016', '2017', '2018', '2019')
and per_estado = 'I' and per_tipo in ('U')--11586
--and per_codigo = 183327
) t
where num_materias_apro < [Materias-Carrera]
order by [Cod], [Apellidos]