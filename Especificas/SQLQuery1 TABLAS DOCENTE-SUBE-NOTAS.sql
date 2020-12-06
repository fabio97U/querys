select emp_email_institucional, * from pla_emp_empleado where emp_nombres_apellidos like '%ROSA PATRICIA VASQUEZ%'
select * from ra_hpl_horarios_planificacion where hpl_codemp in (4242, 3812) and hpl_codcil = 124
select * from web_ra_innot_ingresosdenotas where innot_codemp = 236 and innot_codcil = 124
--innot_codingre = 'INT2-E12401142421'
select mov_fecha_real_pago, * from web_ra_npro_notasprocesadas 
inner join ra_per_personas on per_codigo = npro_alumno

inner join col_mov_movimientos on mov_codper = per_codigo
inner join col_dmo_det_mov on dmo_codmov = mov_codigo and dmo_codcil = 123 and mov_codcil = 123
and dmo_codtmo = 134
where npro_codinnot in (
select */*innot_codingre*/ from web_ra_innot_ingresosdenotas where innot_codemp in (3995, 475, 3112, 1525, 2947) and innot_codcil = 123
order by innot_Fecha
) and npro_alumno = 48954

select * from ra_not_notas

	select distinct mai_codigo, per_carnet, per_apellidos, per_nombres, mai_estado, 0 as 'deserto',mai_codmat, mat_nombre, not_codmai, not_nota, pom_codpon, per_telefono, per_email
	from ra_not_notas 
		inner join ra_mai_mat_inscritas on mai_codigo = not_codmai
		inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
		inner join  ra_ins_inscripcion  on ins_codigo = mai_codins
		inner join ra_per_personas on per_codigo = ins_codper
		inner join ra_mat_materias on mat_codigo = mai_codmat
		inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
		inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
	where ins_codcil = 124 and mai_codhpl = 42513 and per_codigo in (184388)

		select * from ra_ins_inscripcion
		inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
		where ins_codper = 184388 and ins_codcil = 124