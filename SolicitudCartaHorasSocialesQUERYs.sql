use uonline
--drop table eeg_solicarhs_solicitud_carta_horas_sociales
create table eeg_solicarhs_solicitud_carta_horas_sociales(
	solicarhs_codigo int primary key identity(1, 1),
	solicarhs_codper int foreign key references ra_per_personas,
	solicarhs_codcil int foreign key references ra_cil_ciclo,
	solicarhs_cantidad_hs int,--CANTIDAD DE HORAS SOCIALES AL MOMENTO DE LA SOLICITUD
	solicarhs_fecha_creacion datetime default getdate(),--FECHA SOLICITUD CARTA HS
	solicarhs_id int
);
--select * from eeg_solicarhs_solicitud_carta_horas_sociales
--insert into eeg_solicarhs_solicitud_carta_horas_sociales(solicarhs_codper, solicarhs_codcil, solicarhs_cantidad_hs) values (181324, 120, 510)

alter procedure sp_eeg_solicarhs_solicitud_carta_horas_sociales
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-07-25 15:46:48.907>
	-- Description: <Realiza el mantemiento y validaciones para solicitar la carta de horas sociales que se almacena en la tabla "eeg_solicarhs_solicitud_carta_horas_sociales">
	-- =============================================
	-- sp_eeg_solicarhs_solicitud_carta_horas_sociales 1, 120 --Solicitudes segun @codcil
	-- sp_eeg_solicarhs_solicitud_carta_horas_sociales 2, 120, 181324 --Solicitud segun @codper
	-- sp_eeg_solicarhs_solicitud_carta_horas_sociales 3, 120, 182420 --Inserta la solicitud
	-- sp_eeg_solicarhs_solicitud_carta_horas_sociales 4, 0, 182420 -- Devuelve los datos de horas sociales segun @codper
	@opcion int = 0,
	@codcil int = 0,
	@codper int = 0
as
begin
	if @opcion = 1 --Muestra las solicitudes de carta de horas sociales en el ciclo @codcil
	begin
		select solicarhs_id 'numero', per_carnet 'Carnet', per_apellidos_nombres 'Alumno', per_telefono 'Telefono', per_correo_institucional 'Correo', 
		concat('0',cil_codcic, ' - ', cil_anio) 'Ciclo solicito', car_nombre_legal 'Carrera', pla_nombre 'Plan', car_horas_soc 'HS requeridas', 
		solicarhs_cantidad_hs 'HS hechas', solicarhs_fecha_creacion 'Fecha/hora solicitud' 
		from eeg_solicarhs_solicitud_carta_horas_sociales 
		inner join ra_per_personas on per_codigo = solicarhs_codper 
		inner join ra_cil_ciclo on cil_codigo = solicarhs_codcil
		inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
		inner join ra_pla_planes on pla_codigo = alc_codpla
		inner join ra_car_carreras on car_codigo = pla_codcar
		where solicarhs_codcil = @codcil
	end

	if @opcion = 2 --Muestra la solicitude de carta de horas sociales segun el @codper
	begin
		select solicarhs_id 'numero', per_apellidos_nombres, per_telefono, per_correo_institucional, 
		concat('0',cil_codcic, ' - ', cil_anio) 'ciclo_solicitud', car_nombre_legal, pla_nombre, car_horas_soc 'hs_requeridas', 
		solicarhs_cantidad_hs 'hs_hechas', solicarhs_fecha_creacion 'Fecha/hora solicitud' 
		from eeg_solicarhs_solicitud_carta_horas_sociales 
		inner join ra_per_personas on per_codigo = solicarhs_codper 
		inner join ra_cil_ciclo on cil_codigo = solicarhs_codcil
		inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
		inner join ra_pla_planes on pla_codigo = alc_codpla
		inner join ra_car_carreras on car_codigo = pla_codcar
		where solicarhs_codper = @codper
	end

	if @opcion = 3 --Inserta a la tabla "eeg_solicarhs_solicitud_carta_horas_sociales"
	begin
		if not exists (select 1 from eeg_solicarhs_solicitud_carta_horas_sociales where solicarhs_codper = @codper)
		begin
			declare @solicarhs_id int 
			select @solicarhs_id = count(1) + 1 from eeg_solicarhs_solicitud_carta_horas_sociales
			insert into eeg_solicarhs_solicitud_carta_horas_sociales(solicarhs_codper, solicarhs_codcil, solicarhs_cantidad_hs, solicarhs_id) 
			values (@codper, @codcil, (select sum(hsp_horas) from ra_hsp_horas_sociales_personas where hsp_codper = @codper), @solicarhs_id)
			select 1 'res' --SE INSERTO LA SOLICITUD
		end
		else
		begin
			select 0 'res'--YA REALIZO LA SOLICITUD
		end
	end

	if @opcion = 4 --Devuelve la cantidad de horas sociales por alumno
	begin
		declare @hs int, @hs_carrera int

		select @hs = sum(hsp_horas) from ra_hsp_horas_sociales_personas where hsp_codper = @codper
		select @hs_carrera = isnull(car_horas_soc, 0) from ra_per_personas
		inner join ra_alc_alumnos_carrera on alc_codper = per_codigo and per_codigo = @codper
		inner join ra_pla_planes on pla_codigo = alc_codpla
		inner join ra_car_carreras on car_codigo = pla_codcar

		select @codper 'codper', @hs_carrera 'hs_carrera', isnull(@hs, 0) 'hs_realizadas'
	end
end

select concat(isnull(1, 0), '-', solicarhs_fecha_creacion) from eeg_solicarhs_solicitud_carta_horas_sociales where solicarhs_codper = 181324
select per_correo_institucional from ra_per_personas where per_codigo = 181324


ALTER proc [dbo].[rep_ficha_ser_social]
	-- =============================================
	-- Author:      <DESCONOCIDO>
	-- Create date: <DESCONOCIDO>
	-- Last Modify: 2019-11-13 17:01:04.807 por Fabio
	-- Description: <Realiza los reportes de constancia de horas sociales y actividades por alumno o por rango (@codigo_inicio - @codigo_fin)>
	-- =============================================
	-- exec rep_ficha_ser_social 1, 1, '25-1565-2015', 0, 0, 0 -- Devuelve la constacia de hs por alumno
	-- exec rep_ficha_ser_social 2, 1, '', 1, 3, 0 -- Devuelve la constacia de hs por rango de codigo de la tabla de "solicarhs"
	-- exec rep_ficha_ser_social 3, 1, '', 1, 20, 0  -- Devuelve la constancia de actividades por rango  @codigo_inicio - @codigo_fin
	-- exec rep_ficha_ser_social 4, 1, '', 0, 0, 180168 -- Devuelve la constancia de actividades por alumno
	@opcion int = 0,
	@campo0 int = 0,
	@campo1 varchar(12) = '',
	@codigo_inicio int = 0,
	@codigo_fin int = 0,
	@codper int = 0
as
begin
	-- *******************************************************************************************************
	-- Obenermos el numero de horas del alumno
	if @opcion = 1
	begin
		declare @horas_sociales int
		select @horas_sociales = sum(hsp_horas)
		from ra_hsp_horas_sociales_personas join ra_per_personas on hsp_codper = per_codigo
		where per_carnet = @campo1

		-- *******************************************************************************************************
		select uni_nombre,uni_nit, uni_iniciales,'* '+ act as uni_direccion, 
		'EL INFRASCRITO DECANO DE ESTUDIANTES DE LA '+ uni_nombre +' HACE CONSTAR QUE:' P1,
		 nombre +', con carnet No. ' + Carnet +' Matriculado en la Carrera de ' + ltrim(rtrim(carrera)) + ' de  la Facultad de ' + ltrim(rtrim(fac_nombre)) + 
		', ha completado  un total de ' + horas_letras + ' horas (' + horas_soc + '). ' + 
		'requeridas del servicio social desarrollando las siguientes actividades:'  par1,
		'-'+ proyecto +' ' pro ,
		'Y para los usos que estime conveniente se le extiende presente CONSTANCIA DE HORAS SOCIALES en San Salvador' + ', ' + lower(dbo.fn_crufl_FechaALetras(convert(datetime,getdate(),103),1,1)) +'.' par2,
		'Lic. Carlos Alfredo Loucel ' firma, 'Decano' cargo_firma
		from
		(
			select distinct 
				upper(ra_uni_universidad.uni_nombre) as uni_nombre, ra_fac_facultades.fac_nombre, ra_uni_universidad.uni_nit, ra_uni_universidad.uni_iniciales, 
				ra_uni_universidad.uni_direccion, ra_per_personas.per_carnet as carnet, upper(ra_per_personas.per_nombres_apellidos) as nombre, 
				ra_fac_facultades.fac_nombre as facultad, upper(ra_pla_planes.pla_alias_carrera) as carrera, ra_pry_proyectos.pry_nombre as proyecto, 
				ra_pry_proyectos.pry_lugar as lugar, ra_pry_proyectos.pry_actividades as actividades, 
				-- cast(ra_car_carreras.car_horas_soc as varchar) as horas_soc, 
				cast(@horas_sociales as varchar) as horas_soc, 
				--replace(dbo.fn_crufl_numerosaletras_normal(ra_car_carreras.car_horas_soc, 1), 'dólares', '') as horas_letras, 
				replace(dbo.fn_crufl_numerosaletras_normal(@horas_sociales, 1), 'dólares', '') as horas_letras, 
				ra_hsp_horas_sociales_personas.hsp_actividades as act
			from ra_hsp_horas_sociales_personas 
			inner join ra_pry_proyectos on ra_hsp_horas_sociales_personas.hsp_codpry = ra_pry_proyectos.pry_codigo 
			inner join ra_per_personas 
			inner join ra_alc_alumnos_carrera on ra_alc_alumnos_carrera.alc_codper = ra_per_personas.per_codigo 
			inner join ra_pla_planes on ra_pla_planes.pla_codigo = ra_alc_alumnos_carrera.alc_codpla 
			inner join ra_car_carreras on ra_car_carreras.car_codigo = ra_pla_planes.pla_codcar 
			inner join ra_fac_facultades on ra_fac_facultades.fac_codigo = ra_car_carreras.car_codfac 
			inner join ra_reg_regionales on ra_reg_regionales.reg_codigo = ra_per_personas.per_codreg 
			inner join ra_uni_universidad on ra_uni_universidad.uni_codigo = ra_reg_regionales.reg_coduni on 
						ra_hsp_horas_sociales_personas.hsp_codper = ra_per_personas.per_codigo
			where (ra_per_personas.per_carnet = @campo1) and (ra_per_personas.per_codreg = @campo0)
		) t
	end
	
	if @opcion = 2 -- Devuelve la constancia de horas sociales del rango @codigo_inicio - @codigo_fin
	begin
		select uni_nombre,uni_nit, uni_iniciales,'* '+ act as uni_direccion, 
			'EL INFRASCRITO DECANO DE ESTUDIANTES DE LA '+ uni_nombre +' HACE CONSTAR QUE:' P1,
				nombre +', con carnet No. ' + Carnet +' Matriculado en la Carrera de ' + ltrim(rtrim(carrera)) + ' de  la Facultad de ' + ltrim(rtrim(fac_nombre)) + 
			', ha completado  un total de ' + horas_letras + ' horas (' + horas_soc + '). ' + 
			'requeridas del servicio social desarrollando las siguientes actividades:'  par1,
			'-'+ proyecto +' ' pro ,
			'Y para los usos que estime conveniente se le extiende presente CONSTANCIA DE HORAS SOCIALES en San Salvador' + ', ' + lower(dbo.fn_crufl_FechaALetras(convert(datetime,getdate(),103),1,1)) +'.' par2,
			'Lic. Carlos Alfredo Loucel ' firma, 'Decano' cargo_firma
		from
		(
			select solicarhs_id, upper(ra_uni_universidad.uni_nombre) as uni_nombre, ra_fac_facultades.fac_nombre, ra_uni_universidad.uni_nit, ra_uni_universidad.uni_iniciales, 
					ra_uni_universidad.uni_direccion, ra_per_personas.per_carnet as carnet, upper(ra_per_personas.per_nombres_apellidos) as nombre, 
					ra_fac_facultades.fac_nombre as facultad, upper(ra_pla_planes.pla_alias_carrera) as carrera, ra_pry_proyectos.pry_nombre as proyecto, 
					ra_pry_proyectos.pry_lugar as lugar, ra_pry_proyectos.pry_actividades as actividades, 
					cast(solicarhs_cantidad_hs as varchar) as horas_soc, 
					replace(dbo.fn_crufl_numerosaletras_normal(solicarhs_cantidad_hs, 1), 'dólares', '') as horas_letras, 
					ra_hsp_horas_sociales_personas.hsp_actividades as act 
			from eeg_solicarhs_solicitud_carta_horas_sociales
			inner join ra_per_personas on per_codigo = solicarhs_codper
			inner join ra_hsp_horas_sociales_personas on hsp_codper = solicarhs_codper
			inner join ra_pry_proyectos on ra_hsp_horas_sociales_personas.hsp_codpry = ra_pry_proyectos.pry_codigo 
			inner join ra_uni_universidad on ra_uni_universidad.uni_codigo = 1 and ra_hsp_horas_sociales_personas.hsp_codper = ra_per_personas.per_codigo
			inner join ra_alc_alumnos_carrera on ra_alc_alumnos_carrera.alc_codper = ra_per_personas.per_codigo
			inner join ra_pla_planes on ra_pla_planes.pla_codigo = ra_alc_alumnos_carrera.alc_codpla 
			inner join ra_car_carreras on ra_car_carreras.car_codigo = ra_pla_planes.pla_codcar 
			inner join ra_fac_facultades on ra_fac_facultades.fac_codigo = ra_car_carreras.car_codfac 
			where solicarhs_id between @codigo_inicio and @codigo_fin
		) t
		order by t.solicarhs_id asc
	end

	if @opcion = 3 --Devuelve el reporte de actividades del rango @codigo_inicio - @codigo_fin
	begin
		select per_carnet as carnet, upper(per_nombres_apellidos) as alumno, upper(pla_alias_carrera) as carrera, per_direccion direccion, per_telefono telefono, 
		/*fac_nombre, */row_number() over (partition by per_carnet order by hsp_codigo) correlativo, pry_nombre as proyecto, pry_actividades as actividades, 
		hsp_horas, hsp_usuario, hsp_fechareg,
		pry_lugar as lugar, solicarhs_cantidad_hs, 
		replace(dbo.fn_crufl_numerosaletras_normal(solicarhs_cantidad_hs, 1), 'dólares', '') as horas_letras, 
		hsp_actividades as act 
		from eeg_solicarhs_solicitud_carta_horas_sociales
		inner join ra_per_personas on per_codigo = solicarhs_codper
		inner join ra_hsp_horas_sociales_personas on hsp_codper = solicarhs_codper
		inner join ra_pry_proyectos on ra_hsp_horas_sociales_personas.hsp_codpry = ra_pry_proyectos.pry_codigo 
		inner join ra_uni_universidad on ra_uni_universidad.uni_codigo = 1 and ra_hsp_horas_sociales_personas.hsp_codper = ra_per_personas.per_codigo
		inner join ra_alc_alumnos_carrera on ra_alc_alumnos_carrera.alc_codper = ra_per_personas.per_codigo
		inner join ra_pla_planes on ra_pla_planes.pla_codigo = ra_alc_alumnos_carrera.alc_codpla 
		inner join ra_car_carreras on ra_car_carreras.car_codigo = ra_pla_planes.pla_codcar 
		inner join ra_fac_facultades on ra_fac_facultades.fac_codigo = ra_car_carreras.car_codfac 
		where solicarhs_id between @codigo_inicio and @codigo_fin
		order by per_nombres_apellidos -- solicarhs_codigo, hsp_codigo
	end

	if @opcion = 4 --Devuelve el reporte de actividades del rango @codigo_inicio - @codigo_fin
	begin
		select per_carnet as carnet, upper(per_nombres_apellidos) as alumno, upper(pla_alias_carrera) as carrera, per_direccion direccion, per_telefono telefono, 
		/*fac_nombre, */row_number() over (partition by per_carnet order by hsp_codigo) correlativo, pry_nombre as proyecto, pry_actividades as actividades, 
		hsp_horas, hsp_usuario, hsp_fechareg,
		pry_lugar as lugar, solicarhs_cantidad_hs, 
		replace(dbo.fn_crufl_numerosaletras_normal(solicarhs_cantidad_hs, 1), 'dólares', '') as horas_letras, 
		hsp_actividades as act 
		from eeg_solicarhs_solicitud_carta_horas_sociales
		inner join ra_per_personas on per_codigo = solicarhs_codper
		inner join ra_hsp_horas_sociales_personas on hsp_codper = solicarhs_codper
		inner join ra_pry_proyectos on ra_hsp_horas_sociales_personas.hsp_codpry = ra_pry_proyectos.pry_codigo 
		inner join ra_uni_universidad on ra_uni_universidad.uni_codigo = 1 and ra_hsp_horas_sociales_personas.hsp_codper = ra_per_personas.per_codigo
		inner join ra_alc_alumnos_carrera on ra_alc_alumnos_carrera.alc_codper = ra_per_personas.per_codigo
		inner join ra_pla_planes on ra_pla_planes.pla_codigo = ra_alc_alumnos_carrera.alc_codpla 
		inner join ra_car_carreras on ra_car_carreras.car_codigo = ra_pla_planes.pla_codcar 
		inner join ra_fac_facultades on ra_fac_facultades.fac_codigo = ra_car_carreras.car_codfac 
		where solicarhs_codper = @codper
		order by solicarhs_id, hsp_codigo
	end
end