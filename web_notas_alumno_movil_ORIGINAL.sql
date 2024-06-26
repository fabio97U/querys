USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[web_notas_alumno_movil]    Script Date: 18/3/2022 14:40:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--	[web_notas_alumno_movil] '1148302014'
ALTER  PROCEDURE [dbo].[web_notas_alumno_movil]
      @carnet varchar(12)
as
begin      
	declare @ev int, 
	@fech datetime,
	@codcil int,
	@codper int

	-- Ciclo
	select @codcil = cil_codigo from ra_cil_ciclo where cil_vigente = 'S'

	print 'CICLO VIGENTE : '+cast(@codcil as varchar(50))

	-- Carnet
	select @codper = per_codigo from ra_per_personas where  replace(per_carnet,'-','') = @carnet

	declare @carrera varchar(200), 
			@anio_plan varchar(200),
			@fecha_inscripcion varchar(200)

	set @ev=0
	select @ev=count(1), @fech=getdate() from web_evf_evaluacion_fechas_nueva where getdate()>=evf_fechaini and getdate()<= evf_fechafin  and evf_tipo='P'

	select  @carrera = pla_alias_carrera,
			@anio_plan = pla_anio,
			@fecha_inscripcion = (select 'Fecha de inscripción: '+Convert(varchar,ins_fecha) from ra_ins_inscripcion where ins_codper = per_codigo and ins_codcil = @codcil)
	from ra_pla_planes 
		INNER JOIN ra_alc_alumnos_carrera ON ra_pla_planes.pla_codigo = ra_alc_alumnos_carrera.alc_codpla 
		INNER JOIN ra_per_personas ON ra_alc_alumnos_carrera.alc_codper = ra_per_personas.per_codigo
	WHERE ra_per_personas.per_codigo = @codper

	--convert(varchar,getdate(),111)

	declare @Notas as table(carrera nvarchar(max), pla_anio int, fecha_ins nvarchar(max), per_carnet nvarchar(max),per_nombres_apellidos nvarchar(max), per_codigo int, mat_codigo nvarchar(max), mat_nombre nvarchar(max), mat_cod_nombre nvarchar(max), EVALUACION1 real,	EVALUACION2 real, EVALUACION3 real, EVALUACION4 real, EVALUACION5 real, EVALUACION7 real, NOTAFINAL real, mai_estado nvarchar(max), hpl_descripcion nvarchar(max), codigotot nvarchar(max), tipom nvarchar(max), plm_ciclo int, nombre_docente nvarchar(max), correo_docente nvarchar(max), aula nvarchar(max), dias nvarchar(max), horario nvarchar(max), evd int)
	--declare @Notas as table(carrera varchar(255), pla_anio int, fecha_ins varchar(255), per_carnet varchar(16),per_nombres_apellidos varchar(255), per_codigo int, mat_codigo varchar(55), mat_nombre varchar(255), mat_cod_nombre varchar(555), EVALUACION1 real,	EVALUACION2 real, EVALUACION3 real, EVALUACION4 real, EVALUACION5 real, EVALUACION7 real, NOTAFINAL real, mai_estado varchar(12), hpl_descripcion varchar(8), codigotot varchar(55), tipom varchar(6), plm_ciclo int, nombre_docente varchar(255), correo_docente varchar(125), aula varchar(25), dias varchar(25), horario varchar(55), evd int)

	insert into @Notas 
	select @carrera carrera, @anio_plan pla_anio, @fecha_inscripcion fecha_ins,per_carnet, per_nombres_apellidos,per_codigo,mat_codigo,mat_nombre,mat_cod_nombre,
	round(n1,1) EVALUACION1,
	round(n2,1) EVALUACION2,
	round(n3,1) EVALUACION3,
	round(n4,1) EVALUACION4,
	round(n5,1) EVALUACION5,
	round(n7,1) EVALUACION7,
	round(n8,1) NOTAFINAL, 
	mai_estado, 
	hpl_descripcion,
	codigotot,
	tipom,
	plm_ciclo, 
	emp_nombres_apellidos nombre_docente, 
	emp_email_institucional correo_docente,
	aula,
	dias,
	horario,
	1 /*COMENTAREADO PARA PODER LAS NOTAS LOS ALUMNOS EN LA 3ra EVA: case when @ev<>0 then(select count(1) from web_eva_evaluacion_nueva where eva_cod_cuenta=per_codigo and eva_codcil=@codcil and eva_ctot=codigotot) else 1 end*/  evd
	from
	(
		select per_carnet, per_nombres_apellidos, per_codigo,mat_codigo,mat_nombre,mat_cod_nombre,
		sum(n1) n1,
		sum(n2) n2,
		sum(n3) n3,
		sum(n4) n4,
		sum(n5) n5,
		sum(n7) n7,
		round(sum(np1+np2+np3+np4+np5),1) n8, 
		mai_estado, 
		hpl_descripcion,
		codigotot,
		tipom,
		plm_ciclo, 
		emp_nombres_apellidos, 
		emp_email_institucional,

		aula,
		dias,
		horario
		from
		(
			select per_carnet,per_apellidos_nombres per_nombres_apellidos,not_codmai,pon_codigo, pon_nombre,per_codigo,per_codreg,
			mat_codigo + ' ' + isnull(plm_alias,mat_nombre) mat_cod_nombre,round(pon_porcentaje/100,2) pon_porcentaje,
			case when pon_codigo = 1 then round(not_nota,1) else 0 end n1,
			case when pon_codigo = 2 then round(not_nota,1) else 0 end n2,
			case when pon_codigo = 3 then round(not_nota,1) else 0 end n3,
			case when pon_codigo = 4 then round(not_nota,1) else 0 end n4,
			case when pon_codigo = 5 then round(not_nota,1) else 0 end n5,
			case when pon_codigo = 7 then round(not_nota,1) else 0 end n7,
			case when pon_codigo = 1 then round(not_nota*round(pon_porcentaje/100,2),2) else 0 end np1,

			case when pon_codigo = 2 then round(not_nota*round(pon_porcentaje/100,2),2) else 0 end np2,
			case when pon_codigo = 3 then round(not_nota*round(pon_porcentaje/100,2),2) else 0 end np3,
			case when pon_codigo = 4 then round(not_nota*round(pon_porcentaje/100,2),2) else 0 end np4,
			case when pon_codigo = 5 then round(not_nota*round(pon_porcentaje/100,2),2) else 0 end np5,
			case when pon_codigo = 7 then round(not_nota*round(pon_porcentaje/100,2),2) else 0 end np7,
			case when mai_estado = 'I' then 'Ins.' else 'Ret.' end mai_estado, hpl_descripcion,mat_codigo,isnull(plm_alias,mat_nombre) as mat_nombre,
			replace(mat_codigo,' ','')+ replace(hpl_descripcion,' ','') as codigotot,
			hpl_tipo_materia as tipom, 
			plm_ciclo,
			emp_nombres_apellidos, 
			emp_email_institucional ,
			-- Añadido para mostrar Aula, Dias, Hora
			aul_nombre_corto aula,
			case when hpl_lunes = 'S' then 'LU-' ELSE '' END + 
			case when hpl_martes = 'S' then 'MAR-' ELSE '' END + 
			case when hpl_miercoles = 'S' then 'MIE-' ELSE '' END + 
			case when hpl_jueves = 'S' then 'JUE-' ELSE '' END + 
			case when hpl_viernes = 'S' then 'VIE-' ELSE '' END + 
			case when hpl_sabado = 'S' then 'SAB-' ELSE '' END + 
			case when hpl_domingo = 'S' then 'DOM-' ELSE '' END  dias,
			man_nomhor horario

			from ra_per_personas
			join ra_ins_inscripcion on ins_codper = per_codigo
			join ra_mai_mat_inscritas on mai_codins = ins_codigo
			join ra_not_notas on not_codmai = mai_codigo
			join ra_pom_ponderacion_materia on pom_codigo = not_codpom
			join ra_pon_ponderacion on pon_codigo = pom_codpon
			join ra_mat_materias on mat_codigo = mai_codmat
			join ra_alc_alumnos_carrera on alc_codper = per_codigo
			join ra_plm_planes_materias on plm_codpla = alc_codpla and plm_codmat = mat_codigo
			-------------aqui-----
			join ra_esc_escuelas on esc_codigo = mat_codesc
			----------fin----
			left outer join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
			left outer join pla_emp_empleado on emp_codigo = hpl_codemp
			-------------obtener aulas-----
			JOIN ra_aul_aulas ON hpl_codaul = aul_codigo 
			JOIN ra_man_grp_hor ON hpl_codman = man_codigo
			where ins_codcil = @codcil ---case when @codcil = '0' then ins_codcil else @codcil end
			and per_codigo = @codper
			and mai_codpla = alc_codpla 
			and mai_estado = 'I' --se quito para evaluacion estudiantil
		) t
		group by per_carnet, 
		per_nombres_apellidos, 
		per_codigo,
		mat_codigo, 
		mat_nombre,
		mat_cod_nombre, 
		mai_estado, 
		hpl_descripcion,
		codigotot,
		tipom,
		plm_ciclo,  
		emp_nombres_apellidos, 
		emp_email_institucional,
		aula,
		dias,
		horario
	) z
	order by plm_ciclo desc


	select  carrera,  pla_anio,  fecha_ins,per_carnet, per_nombres_apellidos,per_codigo,mat_codigo,mat_nombre,mat_cod_nombre,
	 EVALUACION1,
	 EVALUACION2,
	 case when evd>0  then EVALUACION3 else 0  end EVALUACION3,
	 EVALUACION4,
	 EVALUACION5,
	 EVALUACION7,
	 NOTAFINAL, 
	mai_estado, 
	hpl_descripcion,
	codigotot,
	tipom,
	plm_ciclo, 
	case when evd>0  then nombre_docente  else 'Evaluar Docente en el Portal' end nombre_docente, 
	case when evd>0  then correo_docente else 'Evaluar Docente en el Portal' end correo_docente,
	aula,
	case when evd>0  then dias else 'Evaluar Docente en el Portal' end dias,
	case when evd>0  then  horario else '' end horario,
	evd
	from @Notas

	--drop table  #Notas

end
--insert into movil_ingresos_usuarios(usuario, sp, NombreWS) values (@carnet, 'web_notas_alumno_movil', 'ServiciosAlumnos.asmx')
