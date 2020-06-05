select * from ra_ing_ingreso
select * from ra_doc_documentos

select * from (
	select per_codigo, per_carnet, per_nombres_apellidos, per_correo_institucional, per_email, 
	per_telefono, per_celular,
	(select count(1) from ra_dop_doc_per 
	inner join ra_doc_documentos on doc_codigo = dop_coddoc-- and dop_codper = 181324
	where dop_codper in (per.per_codigo) and dop_coddoc in (2, 6)) 'entrego_titulo'
	from ra_per_personas as per
	where per_codcil_ingreso = 122 and per_tipo = 'U' and per_estado = 'A'
) t
where t.entrego_titulo = 0
order by per_codigo