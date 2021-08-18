select * from ra_alc_alumnos_carrera where alc_codper = 181134
select * from Inscripcion.dbo.ra_ins_inscripcion
--inner join Inscripcion.dbo.ra_mai_mat_inscritas on mai_codins = ins_codigo
where ins_codper = 232271

select * from ra_per_personas 
inner join Inscripcion.dbo.ra_ins_inscripcion on ins_codper = per_codigo
where per_codcil_ingreso = 126 and ins_codcil = 126
union all
select * from ra_per_personas 
inner join dbo.ra_ins_inscripcion on ins_codper = per_codigo
where per_codcil_ingreso = 126 and ins_codcil = 126
-- Cuantos inscritos de nuevo ingreso
-- Y quienes no han inscrito el curso de induccion o setaco
select distinct per_codigo, per_carnet, per_nombres, per_telefono, per_celular, per_email, per_email_opcional, per_correo_institucional, 'SETACO' 'No inscribio' from (
select * from ra_per_personas 
inner join Inscripcion.dbo.ra_ins_inscripcion on ins_codper = per_codigo
inner join Inscripcion.dbo.ra_mai_mat_inscritas on mai_codins = ins_codigo
inner join ra_mat_materias on mai_codmat = mat_codigo
where per_codcil_ingreso = 126 and ins_codcil = 126
union all 
select * from ra_per_personas 
inner join Inscripcion.dbo.ra_ins_inscripcion on ins_codper = per_codigo
inner join Inscripcion.dbo.ra_mai_mat_inscritas on mai_codins = ins_codigo
inner join ra_mat_materias on mai_codmat = mat_codigo
where per_codcil_ingreso = 126 and ins_codcil = 126
) t
where t.per_codigo not in (
select per_codigo from ra_per_personas 
inner join Inscripcion.dbo.ra_ins_inscripcion on ins_codper = per_codigo
inner join Inscripcion.dbo.ra_mai_mat_inscritas on mai_codins = ins_codigo
inner join ra_mat_materias on mai_codmat = mat_codigo
where per_codcil_ingreso = 126 and ins_codcil = 126 and mat_nombre like '%semina%'
union all
select per_codigo from ra_per_personas 
inner join dbo.ra_ins_inscripcion on ins_codper = per_codigo
inner join dbo.ra_mai_mat_inscritas on mai_codins = ins_codigo
inner join ra_mat_materias on mai_codmat = mat_codigo
where per_codcil_ingreso = 126 and ins_codcil = 126 and mat_nombre like '%semina%'
)

	union all

select distinct per_codigo, per_carnet, per_nombres, per_telefono, per_celular, per_email, per_email_opcional, per_correo_institucional, 'INDUCCIÓN' from (
select * from ra_per_personas 
inner join Inscripcion.dbo.ra_ins_inscripcion on ins_codper = per_codigo
inner join Inscripcion.dbo.ra_mai_mat_inscritas on mai_codins = ins_codigo
inner join ra_mat_materias on mai_codmat = mat_codigo
where per_codcil_ingreso = 126 and ins_codcil = 126
union all 
select * from ra_per_personas 
inner join Inscripcion.dbo.ra_ins_inscripcion on ins_codper = per_codigo
inner join Inscripcion.dbo.ra_mai_mat_inscritas on mai_codins = ins_codigo
inner join ra_mat_materias on mai_codmat = mat_codigo
where per_codcil_ingreso = 126 and ins_codcil = 126
) t
where t.per_codigo not in (
select per_codigo from ra_per_personas 
inner join Inscripcion.dbo.ra_ins_inscripcion on ins_codper = per_codigo
inner join Inscripcion.dbo.ra_mai_mat_inscritas_especial on mai_codins = ins_codigo
inner join ra_mat_materias on mai_codmat = mat_codigo
where per_codcil_ingreso = 126 and ins_codcil = 126 and mat_nombre like '%curs%'
union all
select per_codigo from ra_per_personas 
inner join dbo.ra_ins_inscripcion on ins_codper = per_codigo
inner join dbo.ra_mai_mat_inscritas_especial on mai_codins = ins_codigo
inner join ra_mat_materias on mai_codmat = mat_codigo
where per_codcil_ingreso = 126 and ins_codcil = 126 and mat_nombre like '%curs%'
)


--NO INSCRIBIERON
select per_codigo, per_carnet, per_nombres, per_telefono, per_celular, per_email, per_email_opcional, per_correo_institucional from ra_per_personas 
where per_codcil_ingreso = 126
and per_codigo not in (
select per_codigo from ra_per_personas 
inner join Inscripcion.dbo.ra_ins_inscripcion on ins_codper = per_codigo
inner join Inscripcion.dbo.ra_mai_mat_inscritas on mai_codins = ins_codigo
inner join ra_mat_materias on mai_codmat = mat_codigo
where per_codcil_ingreso = 126 and ins_codcil = 126
union all
select per_codigo from ra_per_personas 
inner join dbo.ra_ins_inscripcion on ins_codper = per_codigo
inner join dbo.ra_mai_mat_inscritas on mai_codins = ins_codigo
inner join ra_mat_materias on mai_codmat = mat_codigo
where per_codcil_ingreso = 126 and ins_codcil = 126
) and per_tipo = 'U' and per_estado = 'A'