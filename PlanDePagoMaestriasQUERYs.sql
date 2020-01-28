--drop table ma_ppa_plan_pagos
create table ma_ppa_plan_pagos(
	ppa_codigo int primary key identity(1,1),
	ppa_plan varchar(125),
	ppa_codtde int foreign key references ra_tde_TipoDeEstudio,
	ppa_estado int default 1,
	ppa_codusr int foreign key references adm_usr_usuarios,
	ppa_fecha_creacion datetime default getdate()
)
select tde_codigo from ra_tde_TipoDeEstudio where tde_tipo = 'M'
	select ppa_codigo, concat(ppa_plan, case ppa_estado when 0 then ' - (PLAN INACTIVO)' else '' end) ppa_plan from ma_ppa_plan_pagos where ppa_codtde = (select tde_codigo from ra_tde_TipoDeEstudio where tde_tipo = 'M')
--select ppa_plan, ppa_codigo from ma_ppa_plan_pagos tpb_codtde = (select tde_codigo from ra_tde_TipoDeEstudio where tde_tipo = @tde_tipo)
--insert into ma_ppa_plan_pagos (ppa_plan, ppa_codtde, ppa_codusr, ppa_estado) values ('Plan de prueba', 2, 407, 1), ('Recerba de matricula', 2, 407,1), ('Pago completo', 2, 407,0), ('Plan de prueba', 3, 407,1), ('Plan de pagos prueba', 3, 407,1)

--drop table ma_alppabe_alumno_plan_pago
create table ma_alppabe_alumno_plan_pago(
	alppabe_codigo int primary key identity(1,1),
	alppabe_codper int foreign key references ra_per_personas,
	alppabe_codcil_obtuvo_plan_pago int, 
	alppabe_codppa int foreign key references ma_ppa_plan_pagos,
	alppabe_codtde int foreign key references ra_tde_TipoDeEstudio,--TIPO DE ESTUDIO ALUMNO
	alppabe_activa int default 1, 
	alppabe_codusr int foreign key references adm_usr_usuarios,
	alppabe_fecha_creacion datetime default getdate()
)
go
--select * from ma_alppabe_alumno_plan_pago where 
select * from ra_per_personas where per_codigo = 220802

select alppabe_codigo 'codalppabe', per_carnet 'Carnet', per_apellidos_nombres 'Alumno', car_nombre 'Carrera', ppa_plan 'Plan de pago', 
concat('0',cil_codcic,'-', cil_anio) 'Ciclo obtuvo plan', tde_nombre 'Tipo de estudio', tde_tipo 'Tipo', case alppabe_activa when 0 then 'Inactivo' else 'Activo' end 'Plan activo', usr_usuario 'Usuario brindo plan'
from ma_alppabe_alumno_plan_pago 
inner join ra_per_personas on alppabe_codper = per_codigo
inner join ra_cil_ciclo on alppabe_codcil_obtuvo_plan_pago = cil_codigo
inner join ma_ppa_plan_pagos on alppabe_codppa = ppa_codigo
inner join ra_tde_TipoDeEstudio on alppabe_codtde = tde_codigo 
inner join adm_usr_usuarios on alppabe_codusr = usr_codigo
left join ra_alc_alumnos_carrera on alc_codper = per_codigo
left join ra_pla_planes on alc_codpla = pla_codigo 
left join ra_car_carreras on pla_codcar = car_codigo
where  alppabe_codcil_obtuvo_plan_pago = 120


select * from adm_opm_opciones_menu where opm_codigo = 22
select * from adm_opm_opciones_menu where opm_codigo = 874

