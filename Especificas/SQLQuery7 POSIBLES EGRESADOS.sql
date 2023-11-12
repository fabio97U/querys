
declare @tabla_posibles_egresados as table(
	per_codigo int,
	facultad varchar(50),
	car_carrera varchar(500),
	per_carnet varchar(50),	
	per_apellidos_nombres varchar(201),	
	per_correo_institucional varchar(400),	
	per_telefono varchar(40), 
	per_celular varchar(40), 
	per_sexo varchar(1), 
	per_email varchar(80), 
	per_direccion varchar(200),	
	materias_pasadas int,	
	total_materias int,	
	cum_limpio real,
	horas_sociales int,
	inscribio_inter_ciclo varchar(1024), per_estado varchar(10)
)
declare @car_codigo varchar(12)
declare m_cursor cursor 
for
--select car_codigo  from ra_car_carreras where car_estado = 'A' and car_codfac = 8 -- and car_codigo = 25
select car_codigo  from ra_car_carreras where car_estado = 'A' and car_codtde = 1-- and car_codigo = 25
open m_cursor 
 
fetch next from m_cursor into @car_codigo
while @@FETCH_STATUS = 0 
begin
    --select @car_codigo
	print '@car_codigo: ' + cast(@car_codigo as varchar(12))
	insert into @tabla_posibles_egresados 
	(per_codigo,facultad, car_carrera, per_carnet, per_apellidos_nombres, per_correo_institucional, per_telefono, per_celular, per_sexo,
	per_email, per_direccion, materias_pasadas, total_materias, cum_limpio, horas_sociales, inscribio_inter_ciclo, per_estado)
	exec sp_estimado_egresados 1, 129, @car_codigo
    fetch next from m_cursor into @car_codigo
end      
close m_cursor
deallocate m_cursor

select case when (horas_sociales >= (case when car_carrera like '%tecni%' then 250 else 500 end)) then 'SI' else 'NO' end 'HS_completas', * from @tabla_posibles_egresados
--where materias_pasadas >= total_materias
order by car_carrera, per_apellidos_nombres