alter procedure rep_planilla_dhc_preespecialidad
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-11-06 09:53:36.050>
	-- Description: <Reporte de los tiempo de los docente pre>
	-- =============================================
	-- rep_planilla_dhc_preespecialidad 1, 201910
	@opcion int = 0,
	--@codcil int = 0,
	@codpla int = 0
as
begin
	set nocount on

	if @opcion = 1
	begin
	/*select * from pla_hort_emp_trabajadas_pre_pre
	select * from pla_hort_emp_trabajadas_pre_mc*/
		select /*hort.Id codhort, pre.pre_codigo, pre_nombre, */mpr_codigo codigo, hort.mpr_nombre modulo, hort.seccion, hort.codemp, emp_apellidos_nombres, 
		hort.horas, hort.codtpl,/* tpl_nombre, */hort.codcil_inscri, concat('0', cil_codcic, '-', cil_anio) ciclo_inscri, hort.codpla, 
		/*hort.tipo_materia, hmp_tpm_tipo_materia, hort.MontoHora,  */
		--hort.codcilPagar, --(select concat('0', mcil.cil_codcic, '-', mcil.cil_anio) from ra_cil_ciclo as mcil where cil_codigo = hort.codcilPagar) ciclo_pagar, 
		hort.Monto, hort.tipo_materia, hort.MontoHora
		/*hort.tipo hort.codusr, usr_nombre, hort.fechahora*/
		from pla_hort_emp_trabajadas_pre_pre as hort
			inner loop join pg_hmp_horario_modpre as hmp on hmp.hmp_codigo = hort.hmp_codigo
			inner join pg_mpr_modulo_preespecializacion as mpr on mpr.mpr_codigo = hort.hmp_codmpr
			inner join pg_pre_preespecializacion as pre on pre.pre_codigo = hort.pre_codigo
			left join pla_emp_empleado on emp_codigo = hort.codemp
			left join pla_tpl_tipo_planilla on tpl_codigo = hort.codtpl
			inner join ra_cil_ciclo on cil_codigo = hort.codcil_inscri
			left join adm_usr_usuarios on usr_codigo = hort.codusr
		where hort.codpla = @codpla --and hort.codcil_inscri = @codcil 

		union 

		select /*hort.Id codhort, */hm.hm_codigo, hm.hm_nombre_mod, hort.seccion, hort.codemp, emp_apellidos_nombres, hort.horas, hort.codtpl,-- tpl_nombre,
		hort.codcil_inscri, concat('0', cil_codcic, '-', cil_anio) ciclo_inscri, hort.codpla, 
		/*hort.tipo_materia, hm_tpm_tipo_materia, hort.MontoHora, */
		--hort.codcilPagar,-- (select concat('0', mcil.cil_codcic, '-', mcil.cil_anio) from ra_cil_ciclo as mcil where cil_codigo = hort.codcilPagar) ciclo_pagar, 
		hort.Monto, hort.tipo_materia, hort.MontoHora /*hort.tipo hort.codusr, usr_nombre, hort.fechahora*/
		from pla_hort_emp_trabajadas_pre_mc as hort
			inner hash join pg_hm_horarios_mod as hm on hm.hm_codigo = hort.hm_codigo
			left join pla_emp_empleado on emp_codigo = hort.codemp
			left join pla_tpl_tipo_planilla on tpl_codigo = hort.codtpl
			inner join ra_cil_ciclo on cil_codigo = hort.codcil_inscri
			left join adm_usr_usuarios on usr_codigo = hort.codusr
		where hort.codpla = @codpla --and hort.codcil_inscri = @codcil 

		order by modulo asc
	end

end