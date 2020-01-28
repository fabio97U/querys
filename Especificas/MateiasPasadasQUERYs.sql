--02-4295-2009
select * from ra_per_personas where per_codigo = 130686
select * from ra_regr_registro_egresados where regr_codigo = 7033
select * from ra_regr_registro_egresados where regr_codigo = 7033
update ra_regr_registro_egresados set regr_codper =181324 where regr_codigo = 7033

select * from ra_egr_egresados where egr_codigo = 31224
select * from ra_egr_egresados where egr_codigo = 31224
update ra_egr_egresados set egr_codper =181324 where egr_codigo = 31224

select * from notas, ra_pla_planes where ins_codper = 130686 and nota > 6 and pla_codigo = mai_codpla and ins_codcil = 119


select per_codigo, per_carnet, per_apellidos_nombres, per_correo_institucional, per_telefono, per_celular, per_sexo, per_email, per_direccion,   
				(select count(1)  from notas inner join ra_pla_planes on pla_codigo = mai_codpla
				inner join ra_car_carreras on car_codigo = pla_codcar where ins_codper = per_codigo and nota >= 5.96 and car_identificador = SUBSTRING(per_carnet,1,2) and pla_codigo = (select alc_codpla from ra_alc_alumnos_carrera where alc_codper = per_codigo)) 
					+
	(
	select count(distinct eqn_codmat) 
	from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,
	ra_alc_alumnos_carrera, ra_plm_planes_materias
	where equ_codigo = eqn_codequ
	and equ_codper = per_codigo
	and eqn_nota > 0
	and alc_codper = equ_codper
	and plm_codpla = alc_codpla
	and plm_codmat = eqn_codmat
	) as 'materias_pasadas'
	,isnull((select pla_n_mat from ra_pla_planes where pla_codigo = alc.alc_codpla ),0) 'total_materias',
				
				
		car_nombre
	from ra_ins_inscripcion 
	inner join ra_per_personas on per_codigo = ins_codper 
	inner join ra_alc_alumnos_carrera as alc on alc.alc_codper = per_codigo
	inner join ra_pla_planes AS pla  ON pla.pla_codigo = alc.alc_codpla 
	inner join ra_car_carreras on car_codigo = pla_codcar
	where  per_estado = 'A' and per_tipo = 'U' and per_carnet = '02-4295-2009'

	(select count(1)  from notas inner join ra_pla_planes on pla_codigo = mai_codpla
				inner join ra_car_carreras on car_codigo = pla_codcar where ins_codper = 130686 and nota >= 5.96 and car_identificador = SUBSTRING('02-4295-2009',1,2) and pla_codigo = (select alc_codpla from ra_alc_alumnos_carrera where alc_codper = 130686)) 



			if (select count(1) from pg_imp_ins_especializacion 
		join pg_apr_aut_preespecializacion on apr_codigo = imp_codapr 
		join ra_cil_ciclo on cil_codigo = apr_codcil
			where cil_vigente_pre = 'S' and imp_codper = 130686)>0  or 
			(
				select count(1) 
				from ra_egr_egresados 
				join ra_cil_ciclo on cil_codigo = egr_codcil 
				where egr_codper = 130686 
				and not exists
				(
					select 1 from ra_ins_inscripcion 
					inner join ra_cil_ciclo on
							cil_codigo = ins_codcil
							where ins_codcil = 121 and ins_codper = 130686 and cil_codcic <> 3
					--where ins_codcil = @cil_codigo and ins_codper = @cuenta_codigo 
					and not exists 
					(select 1 from ra_mai_mat_inscritas_especial where mai_codins = ins_codigo)
				) 
		)>0
		begin
				select 'Preespecialidad' 
		end		