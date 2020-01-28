create function fn_alumno_realizo_evaluacion
(
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-07-24 10:35:19.680>
	-- Description: <Esta funcion retorna 1 si el alumno realizo la evaluacion y 0 sino la realizo, se invoca en el procedimiento "sp_consolidado_alumnos_materia">
	-- =============================================
	--select dbo.fn_alumno_realizo_evaluacion (4640355, 5)
	@codmai int, --codigo de inscripcion de la materia del alumno
	@evaluacion int--codpon, 1-5: evaluacion del 1 al 5, 8: evaluacion final NF
)
returns int
begin
	declare @realizo_evaluacion int 
	select @realizo_evaluacion = 1 from ra_not_notas 
	inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
	--inner join ra_mai_mat_inscritas on mai_codigo = not_codmai
	where not_codmai in(@codmai) and pom_codpon = @evaluacion and isnull(not_nota, 0) <> 0
	return isnull(@realizo_evaluacion, 0)
end
/*
create procedure sp_estadisticos_aprorepro_docente
	-- sp_estadisticos_aprorepro_docente 1, 119, 8, 9, 'X'
	@codreg int,
	@codcil int,
	@computo int, -- EVALUACION
	@codesc int, --@facultad int,
	@tipo nvarchar(1)  -- P=Presencial, V=Virtual, S=Semi presencial, X=Todos
as
begin
	declare @consolidado_materias as table (codhpl int, inscritos int, retirados int, reprobados int, aprobados int, no_ex int, desertados int, computo varchar(22), uni_nombre varchar(125), reg_nombre varchar(125))
	declare @data as table(cil_codcic int, cil_codigo int, uni_nombre varchar(125), reg_nombre varchar(125), mat_codigo varchar(50), mat_nombre	varchar(125), cic_nombre varchar(25), cil_anio varchar(25),	emp_apellidos_nombres varchar(100),	hor_descripcion varchar(5),car_nombre varchar(10), fac_nombre varchar(100), inscritos int, retirados int, reprobados int, aprobados int, no_ex int,	desertados int,	computo varchar(22), hpl_tipo_materia varchar(2))

	declare @codhpl varchar(12)
	declare cursor_hpl cursor 
	for
	select hpl_codigo from ra_hpl_horarios_planificacion where hpl_codesc in(@codesc) and hpl_codcil = @codcil and hpl_tipo_materia like case when @tipo = 'X' then '%%' else @tipo end
	open cursor_hpl 
 
	fetch next from cursor_hpl into @codhpl
	print '@codhpl: ' + cast(@codhpl as varchar(12))
	while @@FETCH_STATUS = 0 
	begin
		insert into @consolidado_materias
		exec sp_consolidado_alumnos_materia @codhpl, @computo
		--select @codhpl
		fetch next from cursor_hpl INTO @codhpl
	end
                
	close cursor_hpl  
	deallocate cursor_hpl
	
	insert into @data
	select /*hpl_codigo, */cil_codcic, cil_codigo, c.uni_nombre, c.reg_nombre, mat_codigo,
	mat_nombre, concat('0',cil_codcic, '-', cil_anio) 'cic_nombre', cil_anio, emp_apellidos_nombres, hpl_descripcion 'hor_descripcion', 
	'' 'car_nombre', fac_nombre, 
	c.inscritos 'inscritos', c.retirados 'retirados', c.reprobados 'reprobados', c.aprobados 'aprobados', c.no_ex 'no_ex', c.desertados 'desertados', c.computo 'computo', hpl_tipo_materia 
	from ra_hpl_horarios_planificacion
	inner join ra_cil_ciclo on cil_codigo = hpl_codcil 
	inner join ra_mat_materias on mat_codigo = hpl_codmat
	inner join pla_emp_empleado on emp_codigo = hpl_codemp
	inner join ra_esc_escuelas on esc_codigo = hpl_codesc
	inner join ra_fac_facultades on fac_codigo = esc_codfac
	inner join @consolidado_materias as c on c.codhpl = hpl_codigo
	where hpl_codesc in(@codesc) and hpl_codcil = @codcil
	order by mat_nombre asc

	select * from @data order by mat_codigo asc, hor_descripcion asc
end*/


alter procedure sp_consolidado_alumnos_materia
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-07-24 14:41:21.139>
	-- Description: <Retorna el consolidado(inscritos, retirados, reprobados, aprobados, no_examinadaso, desertados) por @codhpl en la evaluacion >
	-- =============================================
	-- sp_consolidado_alumnos_materia 34654, 8
	@codhpl int,
	@evaluacion int--codpon, 1-5: evaluacion del 1 al 5, 8: nota final(NF)
as
begin
	declare @codcil int
	select @codcil = hpl_codcil from ra_hpl_horarios_planificacion where hpl_codigo = @codhpl

	if @evaluacion <> 8--Si no es la NF
	begin
		select top 1/*@evaluacion 'Evaluacion', */@codhpl codhpl, /*tabla.mai_codmat,*/ tabla.inscritos, tabla.retirados, (tabla.reprobados - tabla.retirados) 'reprobados', tabla.aprobados, no_examinado 'no_ex', (tabla.desertados) 'desertados', concat('Evaluación ' , @evaluacion) 'computo', uni_nombre, reg_nombre
		from (
			select mai_codmat, sum(ret_mat) 'retirados', sum(des_alm) 'desertados', count(1) 'inscritos', sum(aprobo) 'aprobados' , sum(reprobo) 'reprobados', sum(no_ex)  'no_examinado', uni_nombre, reg_nombre
			from (
				select mai_codmat, case mai_estado when 'R' then 1 else 0 end as ret_mat, case deserto when 1 then 1 else 0 end as des_alm, case when not_nota > 5.96 then 1 else 0 end aprobo, case when not_nota < 5.96 then 1 else 0 end reprobo, case when realizo_eva = 1 then 0 else 1 end no_ex, uni_nombre, reg_nombre
				from 
				(
					select distinct per_carnet, per_apellidos_nombres, m.mai_estado, dbo.fn_deserto_alumno_materia(m.mai_codigo, @evaluacion) as 'deserto', m.mai_codmat, not_nota, m.mai_codigo, dbo.fn_alumno_realizo_evaluacion(m.mai_codigo, @evaluacion) 'realizo_eva', uni_nombre, reg_nombre
					from ra_ins_inscripcion 
					inner join ra_mai_mat_inscritas as m on ins_codigo = mai_codins
					inner join ra_per_personas on per_codigo = ins_codper
					inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
					inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
					inner join notas as n on n.ins_codper = alc_codper and n.mai_codhpl = m.mai_codhpl
					
					inner join ra_not_notas on not_codmai = m.mai_codigo
					inner join ra_pom_ponderacion_materia on not_codpom = pom_codigo and pom_codpon = @evaluacion

					join ra_reg_regionales on reg_codigo = per_codreg
					join ra_uni_universidad on uni_codigo = reg_coduni
					where  m.mai_codhpl = @codhpl 
				) 
				ta 
				group by per_carnet, per_apellidos_nombres,	mai_estado,	deserto, mai_codmat, not_nota, realizo_eva, uni_nombre, reg_nombre
			) as x
			group by mai_codmat, uni_nombre, reg_nombre
		)  as tabla
	end
	else if @evaluacion = 8--Si es la NF
	begin
		--SI ES LA NOTA FINA NF(8) SOLO ES NECESARIO HACER JOIN CON LA TABLA "notas"
		set @evaluacion = 5 --PARA PODER SACAR LOS DESERTADOS, YA QUE LA FUNCION 
		select top 1/*@evaluacion 'Evaluacion', */@codhpl codhpl, /*tabla.mai_codmat,*/ tabla.inscritos, tabla.retirados, (tabla.reprobados - tabla.retirados) 'reprobados', tabla.aprobados, no_examinado 'no_ex', (tabla.desertados) 'desertados', 'NF' 'computo', uni_nombre, reg_nombre
		from (
			select mai_codmat, sum(ret_mat) 'retirados', sum(des_alm) 'desertados', count(1) 'inscritos', sum(aprobo) 'aprobados' , sum(reprobo) 'reprobados', sum(no_ex)  'no_examinado', uni_nombre, reg_nombre
			from (
				select mai_codmat, case mai_estado when 'R' then 1 else 0 end as ret_mat, case deserto when 1 then 1 else 0 end as des_alm, case when nota > 5.96 then 1 else 0 end aprobo, case when nota < 5.96 then 1 else 0 end reprobo, case when realizo_eva = 1 then 0 else 1 end no_ex, uni_nombre, reg_nombre
				from 
				(
					select distinct per_carnet, per_apellidos_nombres, m.mai_estado, dbo.fn_deserto_alumno_materia(m.mai_codigo, @evaluacion) as 'deserto', m.mai_codmat, nota, m.mai_codigo, dbo.fn_alumno_realizo_evaluacion(m.mai_codigo, @evaluacion) 'realizo_eva', uni_nombre, reg_nombre
					from ra_ins_inscripcion 
					inner join ra_mai_mat_inscritas as m on ins_codigo = mai_codins
					inner join ra_per_personas on per_codigo = ins_codper
					inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
					inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
					inner join notas as n on n.ins_codper = alc_codper and n.mai_codhpl = m.mai_codhpl

					join ra_reg_regionales on reg_codigo = per_codreg
					join ra_uni_universidad on uni_codigo = reg_coduni
					where  m.mai_codhpl = @codhpl 
				) 
				ta 
				group by per_carnet, per_apellidos_nombres,	mai_estado,	deserto, mai_codmat, nota, realizo_eva, uni_nombre, reg_nombre
			) as x
			group by mai_codmat, uni_nombre, reg_nombre
		)  as tabla
	end
end




-- exec rep_estadisticas_computo_doc 1,119, 8 ,6, 'X'
--https://dinpruebas.utec.edu.sv/uonlinetres/privado/reportes.aspx?reporte=rep_estadisticas_computo_doc&filas=5&campo0=1&campo1=119&campo2=5&campo3=6&campo4=X