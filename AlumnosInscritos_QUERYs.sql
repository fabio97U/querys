--select * from ra_per_personas where per_anio_ingreso between 2014 and 2019 and per_estado = 'I' and per_tipo = 'U'
select * from (
select dbo.fx_MateriasAprobadas(per_carnet) 'apros', pla_n_mat 'requeridas', 
per_carnet, per_apellidos_nombres, per_estado, per_telefono, per_tel_trabajo, 
per_telefono_oficina, per_email, per_email_opcional, per_emer_tel, per_anio_ingreso 
from ra_per_personas 
inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
inner join ra_pla_planes on pla_codigo = alc_codpla
where per_anio_ingreso between 2014 and 2019 and per_estado = 'I' and per_tipo = 'U' and per_codigo 
in (
	select ins_codper from ra_ins_inscripcion 
	where ins_codcil in (select cil_codigo from ra_cil_ciclo where cil_anio in(2014,2015,2016,2017,2018,2019) and cil_codcic <> 3))
) t
where t.apros < t.requeridas

--SELECT * from ra_cil_ciclo 
--select * from (
--select dbo.fx_MateriasAprobadas(per_carnet) 'apros', pla_n_mat 'requeridas', 
--per_carnet, per_apellidos_nombres, per_estado, per_telefono, per_tel_trabajo, 
--per_telefono_oficina, per_email, per_email_opcional, per_emer_tel, per_anio_ingreso 
--from ra_per_personas 
--inner join ra_ins_inscripcion on ins_codper = per_codigo
--inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
--inner join ra_pla_planes on pla_codigo = alc_codpla
--where ins_codcil = 119 and per_tipo = 'U'
----and ins_codper not in (select ins_codper from ra_ins_inscripcion where ins_codcil = 122)
--and per_estado not in ('E', 'G', 'A')
--) t
--where t.apros < t.requeridas


declare @resulta as table (cil_codigo int, ciclo varchar(25), Inscritos int, Antiguo_ingreso int, Nuevo_ingreso int,Egresados int)
declare @cil_codigo varchar(12)
declare cursor_persona cursor 
for
select cil_codigo from ra_cil_ciclo where cil_anio between 2014 and 2020                
open cursor_persona 
 
fetch next from cursor_persona into @cil_codigo
print '@cil_codigo: ' + cast(@cil_codigo as varchar(12))
while @@FETCH_STATUS = 0 
begin
	insert into @resulta
	select cil_codigo, ciclo, sum(contador) 'Inscritos', sum(ANT) 'Antiguo ingreso', 
	sum(NI) 'Nuevo ingreso', sum(egreso) 'Egresados'
	from (
		select distinct cil_codigo, concat(' ("0', cil_codcic, '-', cil_anio,'") ') 'ciclo', per_codigo, 
		case isnull(regr_codigo, 0) when 0 then 0 else 1 end 'egreso',
		case per_codcil_ingreso when @cil_codigo then 1 else 0 end 'NI',
		case when (isnull(per_codcil_ingreso, 0) <> @cil_codigo) then 1 else 0 end 'ANT', 1 contador
		from ra_ins_inscripcion
		inner join ra_per_personas on per_codigo = ins_codper
		left join ra_regr_registro_egresados on per_codigo = regr_codper
		inner join ra_cil_ciclo on cil_codigo = ins_codcil
		where ins_codcil = @cil_codigo and per_tipo = 'U'
	) t
	group by cil_codigo, ciclo
    fetch next from cursor_persona into @cil_codigo
end      
close cursor_persona  
deallocate cursor_persona
select * from @resulta