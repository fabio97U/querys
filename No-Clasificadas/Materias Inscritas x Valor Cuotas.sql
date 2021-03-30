select case 
when materias_inscritas = 1 then 'Una'
when materias_inscritas = 2 then 'Dos'
when materias_inscritas = 3 then 'Tres'
when materias_inscritas = 4 then 'Cuatro'
when materias_inscritas = 5 then 'Cinco'
else 'Cinco'
end 'inscritas', concat('0', cil_codcic, '-', cil_anio) 'ciclo', 1 contador,
case when per_codvac = 1 then '$63' else '$75' end cuota
from (
	select distinct ins_codcil, ins_codper, count(1) 'materias_inscritas', 
	per_codvac
	from ra_ins_inscripcion
		inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
		inner join ra_per_personas on per_codigo = ins_codper
	where ins_codcil in (122, 123, 125) and mai_estado = 'I'
	--and ins_codper = 173322
	and per_tipo = 'U'
	group by ins_codcil, ins_codper, per_codvac
) t
inner join ra_cil_ciclo on cil_codigo = ins_codcil