USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[web_ptl_login_info_fqdn]    Script Date: 29/07/2019 10:32:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----  web_ptl_login_info_fqdn '1229262009'

----  web_ptl_login_info_fqdn 'ernesto.gonzalez'
----  web_ptl_login_info_fqdn 'marcos.martinez'

ALTER procedure[dbo].[web_ptl_login_info_fqdn]
@cuenta varchar(50)
as
begin
	declare @codper int,
	@carnet varchar(12), 
	@codcil int,
	@carnet_sin_guiones varchar(12) = @cuenta

	--select @codcil = egr_codcil from ra_egr_egresados join ra_per_personas on per_codigo = egr_codper where egr_codper = per_codigo and REPLACE(per_carnet,'-','') = @cuenta
	select @codcil = cil_codigo from ra_cil_ciclo where cil_vigente = 'S'
	--if substring(@cuenta,1,1) in ('0','1','2','3','4','5','6','7','8','9') 
	-- Se modifico por los alumnos de maestrias que ingresaran con el usuario  (primer nombre . primer apellidos) y no con su numero de carnet
	-- Fecha de modificacion: 13/10/2014  
	if exists(
		select 1 from ra_per_personas 
		where (per_correo_institucional=(@carnet_sin_guiones+'@mail.utec.edu.sv') 
		or substring(@carnet_sin_guiones,1,1) in ('0','1','2','3','4','5','6','7','8','9') ) 
		and not exists (select 1 from  pla_emp_empleado where emp_email_institucional = @carnet_sin_guiones+'@mail.utec.edu.sv') 
	)
	begin
		set @carnet =substring(@carnet_sin_guiones,1,2)+'-'+substring(@carnet_sin_guiones,3,4)+'-'+substring(@carnet_sin_guiones,7,4)
		select top 1 @codper = per_codigo from ra_per_personas where( per_carnet = @carnet  or per_correo_institucional=(@carnet_sin_guiones+'@mail.utec.edu.sv') )
		if	(
			select count(1) from pg_imp_ins_especializacion join pg_apr_aut_preespecializacion on apr_codigo = imp_codapr join ra_cil_ciclo on cil_codigo = apr_codcil
			where cil_vigente_pre = 'S' and imp_codper = @codper
			) > 0 
			or 
			(
			select count(1) from ra_egr_egresados join ra_cil_ciclo on cil_codigo = egr_codcil 
			join ra_per_personas on per_codigo = egr_codper where egr_codper = @codper and per_tipo <> 'M'
			and not exists(select 1 from ra_ins_inscripcion where ins_codcil = @codcil and ins_codper = @codper and not exists (select 1 from ra_mai_mat_inscritas_especial where mai_codins = ins_codigo))
			) > 0
		begin
			print 'Es de la pre especialidad'
			select 'Estudiantes' tipo,'Pre Especialidad' facultad, '' carrera, ltrim(rtrim(car_tipo)) tc
			from ra_per_personas --join ra_ins_inscripcion on ins_codper = per_codigo
			join ra_alc_alumnos_carrera on alc_codper = per_codigo
			join ra_pla_planes on pla_codigo = alc_codpla
			join ra_car_carreras on car_codigo = pla_codcar
			join ra_fac_facultades on fac_codigo = car_codfac
			where per_codigo = @codper 
		end
		else
		begin
			print 'No es de la pre especialidad'
			select distinct 'Estudiantes' tipo,fac_nombre facultad,car_identificador carrera, ltrim(rtrim(car_tipo)) tc from ra_per_personas --join ra_ins_inscripcion on ins_codper = per_codigo
			join ra_alc_alumnos_carrera on alc_codper = per_codigo
			join ra_pla_planes on pla_codigo = alc_codpla
			join ra_car_carreras on car_codigo = pla_codcar
			join ra_fac_facultades on fac_codigo = car_codfac
			where per_codigo = @codper
		end
	end
	else
	begin
		select 'Docentes' as tipo,'' facultad, '' carrera, '' tc
		from pla_emp_empleado where emp_email_institucional = @carnet_sin_guiones+'@mail.utec.edu.sv' and emp_estado in ('A', 'J')
	end
end
