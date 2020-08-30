select * from col_tipmen_tipo_mensualidad

--drop table col_dpd_definicion_politica_descuento
create table col_dpd_definicion_politica_descuento(
	dpd_codigo int primary key identity (1, 1),
	dpd_tipo varchar(250),
	dpd_permanente bit,
	dpd_cant_ciclos_max int,
	dpd_codusr int,
	dpd_fecha_creacion datetime default getdate()
)
--select * from col_dpd_definicion_politica_descuento
insert into col_dpd_definicion_politica_descuento (dpd_tipo, dpd_permanente, dpd_cant_ciclos_max)
values ('Descuento permanente para alumnos de SEGUNDA CARRERA', 1, -1), 
('Descuento para alumnos del 20% de descuento por ciclos', 0, 2),
('Descuento para alumnos del 30% de descuento por ciclos', 0, 4)

--drop table col_tmp_tipo_mensualidad_con_politicas
create table col_tmp_tipo_mensualidad_con_politicas(
	tmp_codigo int primary key identity(1, 1),
	tmp_codtipmen int,
	tmp_coddpd int,
	tmp_codusr int,
	tmp_fecha_creacion datetime default getdate()
)
--select * from col_tmp_tipo_mensualidad_con_politicas
--inner join col_tipmen_tipo_mensualidad on tmp_codtipmen = tipmen_codigo
--inner join col_dpd_definicion_politica_descuento  on dpd_codigo = tmp_coddpd
insert into col_tmp_tipo_mensualidad_con_politicas(tmp_codtipmen, tmp_coddpd)
values (2, 1), (23, 1), (24, 1), (25, 1),
(9, 2), (10, 2), (11, 2),
(12, 3), (13, 3), (14, 3)


-- =============================================
-- Author:		<Adones,Calles>
-- Create date: <03/07/2020>
-- Description:	<inserta registro de segundas carreras>
-- =============================================
ALTER PROCEDURE [dbo].[sp_inserta_segunda_carrera]
	@opcion int,
	@codper_nuevo int,
	@codper_ant int,
	@coduser int,
	@codcil int
AS
BEGIN
	if @opcion = 1
	begin
		declare @tipmen int

		if not exists(select 1 from ra_sca_segunda_carrera where sca_codper_nuevacarrera = @codper_nuevo and sca_codper_anterior = @codper_ant)
		begin
			declare @codvac int, @codtipmen int
			insert into ra_sca_segunda_carrera(sca_codper_nuevacarrera, sca_codper_anterior, sca_coduser)
			values(@codper_nuevo, @codper_ant, @coduser)
			
			select @codvac = per_codvac from ra_per_personas where per_codigo = @codper_nuevo

			select @codtipmen = tipmen_codigo from col_tipmen_tipo_mensualidad 
			inner join col_tmp_tipo_mensualidad_con_politicas on tmp_codtipmen = tipmen_codigo
			inner join col_dpd_definicion_politica_descuento on dpd_codigo = tmp_coddpd
			where tipmen_codvac = @codvac and dpd_codigo = 1--DESCUENTO POR SEGUNDA CARRERA

			--select @codcil = cil_codigo from ra_cil_ciclo where cil_vigente = 'S'

			if not exists (select 1 from col_detmen_detalle_tipo_mensualidad where detmen_codper = @codper_nuevo and detmen_codcil = @codcil)
			begin
				insert into col_detmen_detalle_tipo_mensualidad (detmen_codper, detmen_codtpmenara, detmen_codcil, detmen_coduser)
				select @codper_nuevo, tpmenara_codigo, @codcil, @coduser 
				from col_tpmenara_tipo_mensualidad_aranceles where tpmenara_codtipmen = @codtipmen
			end
		end
	end
end



--**RESTRICCIONES A LAS MENSUIALIDADES CON POLITICAS**--
--TRABAJADO EL 05/07/2020, *****REPLICAR DESDE AQUI*****
--alter table col_dpd_definicion_politica_descuento add dpd_codusr int
--update col_dpd_definicion_politica_descuento set dpd_codusr = 378 

-- alter table col_tmp_tipo_mensualidad_con_politicas add tmp_codusr int
--update col_tmp_tipo_mensualidad_con_politicas set tmp_codusr = 378 

--insert into adm_opm_opciones_menu (opm_codigo, opm_nombre, opm_link, opm_opcion_padre, opm_orden, opm_sistema)
--values (1086, 'Políticas de descuentos', 'logo.html', 926, 5, 'U'),
--(1087, 'Definición política de mensualidades', 'definicion_politica_descuento.aspx', 1086, 1, 'U')

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_col_dfal_descuentos_futuro_alumnos]    Script Date: 3/7/2020 21:44:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-06-30 14:52:36.627>
	-- Description: <Realiza el mantenimiento a la tabla "col_dfal_descuentos_futuro_alumnos">
	-- =============================================
ALTER procedure [dbo].[sp_col_dfal_descuentos_futuro_alumnos]
	@opcion int = 0,
	@codper int = 0,
	@codcild int = 0,
	@codtipmen int = 0,
	@codusr int = 0,
	@habilitado bit = 0
as
begin

	if @opcion = 1
	begin
		-- sp_col_dfal_descuentos_futuro_alumnos @opcion = 1, @codper = 225358
		select cild_codigo, concat('0', cild_numciclo, '-', cild_anio) 'ciclo_descuento', isnull(dfal_codper, 0) 'posee_descuento', 
		tipmen_codigo, tipmen_tipo, dfal_codigo, isnull(cild_codcil, 0) cild_codcil
		from ra_cild_ciclos_descuentos
		left join col_dfal_descuentos_futuro_alumnos on dfal_codcild = cild_codigo and dfal_codper = @codper
		left join col_tipmen_tipo_mensualidad on tipmen_codigo = dfal_codtipmen
		--where cild_anio >= year(getdate()) 
		order by cild_codigo asc
	end

	if @opcion = 2
	begin
		if (@habilitado = 1) --Inserta un nuevo tipo de descuento
		begin
			-- select * from col_dfal_descuentos_futuro_alumnos
			if not exists (select 1 from col_dfal_descuentos_futuro_alumnos where dfal_codcild = @codcild and dfal_codper = @codper)
			begin
				declare @permite_descuento bit = 1
				select @permite_descuento = dbo.fn_permite_alumno_descuento(@codtipmen, @codper)
				if @permite_descuento = 1
				begin
					insert into col_dfal_descuentos_futuro_alumnos (dfal_codcild, dfal_codper, dfal_codtipmen, dfal_coduser) 
					values (@codcild, @codper, @codtipmen, @codusr)
					select 1
				end
				else
					select 0
			end
			else
				select 0
		end
		else if (@habilitado = 0) --Borra el tipo de descuento
		begin
			delete from col_dfal_descuentos_futuro_alumnos where dfal_codcild = @codcild and dfal_codper = @codper
			select -1
		end
	end

	if @opcion = 3 --Devuelve la leyenda @res con la descripción del @tipmen si posee política, devuelve vacío '' si no posee política definida el @tipmen
	begin
		-- sp_col_dfal_descuentos_futuro_alumnos @opcion = 3, @codtipmen = 9, @codper = 225358
		declare @res varchar(250) = ''
		declare @dpd_cant_ciclos_max int = 0, @dpd_codigo int, @dpd_permanente int, @cantidad_ciclos_descuento int

		select @dpd_cant_ciclos_max = isnull(dpd_cant_ciclos_max, -1), @dpd_codigo = dpd_codigo, @dpd_permanente = dpd_permanente 
			from col_tmp_tipo_mensualidad_con_politicas
			inner join col_tipmen_tipo_mensualidad on tmp_codtipmen = tipmen_codigo
			inner join col_dpd_definicion_politica_descuento  on dpd_codigo = tmp_coddpd
			where tmp_codtipmen = @codtipmen

		select @cantidad_ciclos_descuento = count(distinct dfal_codcild)  
		from col_tmp_tipo_mensualidad_con_politicas
		inner join col_dfal_descuentos_futuro_alumnos on tmp_codtipmen = dfal_codtipmen
		inner join col_dpd_definicion_politica_descuento  on dpd_codigo = tmp_coddpd
		where dpd_codigo = @dpd_codigo and dfal_codper = @codper

		select @res = concat('<b>*POLÍTICA* Descuento permanente: ', case dpd_permanente when 1 then 'Si' else 'No' end, 
		', Máximo número ciclos con el descuento: ', 
		case @dpd_cant_ciclos_max when -1 then 'Toda la carrera' else cast (@cantidad_ciclos_descuento as varchar(52))+'/'+cast(@dpd_cant_ciclos_max as varchar(52)) end,
		'</b>') 
		from col_tmp_tipo_mensualidad_con_politicas
		inner join col_tipmen_tipo_mensualidad on tmp_codtipmen = tipmen_codigo
		inner join col_dpd_definicion_politica_descuento  on dpd_codigo = tmp_coddpd
		where tmp_codtipmen = @codtipmen
		select @res 'res'
	end

end

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[tal_GeneraDataTalonario_alumnos_tipo_mensualidad_especial]    Script Date: 3/7/2020 22:39:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Fabio>
-- Create date: <2020-03-12 14:27:36.347>
-- Description: <Generar la data de las boletas de pago de alumnos con mensualidad especiales en el 
-- mismo momento de inserción del alumno en la tabla "col_detmen_detalle_tipo_mensualidad">
-- =============================================

-- tal_GeneraDataTalonario_alumnos_tipo_mensualidad_especial 1, 1, 122, 181324 --pregrado
-- tal_GeneraDataTalonario_alumnos_tipo_mensualidad_especial 1, 1, 122, 180168 --preespecialidad

ALTER procedure [dbo].[tal_GeneraDataTalonario_alumnos_tipo_mensualidad_especial]
	@opcion int = 0,
	@codreg int = 0,
	@codcilGenerar int = 0,
	@codper int = 0,

	@codtipmen int = 0,
	@codusr int = 0,
	@habilitado bit = 0
as
begin

	if @opcion = 1 --Genera la data talonario alumno mensualidades especiales, la crea en el mismo momento de ingreso del alumno
	begin
		declare @per_estado varchar(5)
		select @per_estado = per_estado from ra_per_personas where per_codigo = @codper

		if @per_estado = 'E' --Es egresado
		begin
			print 'Es egresado'
			delete from col_art_archivo_tal_preesp_mora where per_codigo = @codper
			exec tal_GenerarDataTalonarioPreEspecialidad_PorAlumno_Especial 2, 1, @codcilGenerar, @codper -- Inserta la data para los talonarios preespecialidad
		end

		if @per_estado = 'A' --Es de pregrado
		begin
			print 'Es de pregrado'
			delete from col_art_archivo_tal_mora where per_codigo = @codper
			exec tal_GenerarDataTalonarioPreGrado_porAlumno_Especial 2, 1, @codcilGenerar, @codcilGenerar, @codper-- Inserta la data para los talonarios pregrado
		end
	end

	if @opcion = 2
	begin
		delete from col_detmen_detalle_tipo_mensualidad where detmen_codper = @codper and detmen_codcil = @codcilGenerar
	end

	if @opcion = 3--Inserta el tipo de mensualidad @codtipmen para el alumno
	begin
		-- tal_GeneraDataTalonario_alumnos_tipo_mensualidad_especial @opcion = 3, @codcilGenerar = 123, @codper = 225358, @codusr = 407, @codtipmen = 9, @habilitado = 1
		delete from col_detmen_detalle_tipo_mensualidad where detmen_codper = @codper and detmen_codcil = @codcilGenerar
		if (@habilitado = 1) --Inserta un nuevo tipo de descuento
		begin
			declare @dpd_cant_ciclos_max int = 0, @dpd_codigo int, @dpd_permanente int, @cantidad_ciclos_descuento int, @permite_descuento bit = 1

			select @permite_descuento = dbo.fn_permite_alumno_descuento(@codtipmen, @codper)
			select @permite_descuento
			if @permite_descuento = 1
			begin
				insert into col_detmen_detalle_tipo_mensualidad (detmen_codper, detmen_codtpmenara, detmen_codcil, detmen_coduser)
				select @codper, tpmenara_codigo, @codcilGenerar, @codusr 
				from col_tipmen_tipo_mensualidad
				inner join col_tpmenara_tipo_mensualidad_aranceles on tpmenara_codtipmen = tipmen_codigo
				where tipmen_codigo = @codtipmen
			end
		end
	end

end

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-07-04 23:06:28>
	-- Description: <Retorna 1 si el alumno @codper se le permite el descuento @codtipmen en base a las políticas de descuentos>
	-- =============================================
	-- select dbo.fn_permite_alumno_descuento(9, 225358)
alter function fn_permite_alumno_descuento (@codtipmen int, @codper int)
returns int
begin
	--declare @codtipmen int = 9, @codper int = 225358
	declare @dpd_cant_ciclos_max int = 0, @dpd_codigo int, @dpd_permanente int, @cantidad_ciclos_descuento int, @permite_descuento bit = 1

	select @dpd_cant_ciclos_max = isnull(dpd_cant_ciclos_max, -1), @dpd_codigo = dpd_codigo, @dpd_permanente = dpd_permanente 
	from col_tmp_tipo_mensualidad_con_politicas
	inner join col_tipmen_tipo_mensualidad on tmp_codtipmen = tipmen_codigo
	inner join col_dpd_definicion_politica_descuento  on dpd_codigo = tmp_coddpd
	where tmp_codtipmen = @codtipmen

	if @dpd_permanente = 0
	begin
		select @cantidad_ciclos_descuento = count(distinct dfal_codcild)  
		from col_tmp_tipo_mensualidad_con_politicas
			inner join col_dfal_descuentos_futuro_alumnos on tmp_codtipmen = dfal_codtipmen
			inner join col_dpd_definicion_politica_descuento  on dpd_codigo = tmp_coddpd
			where dpd_codigo = @dpd_codigo and dfal_codper = @codper

		--select @dpd_permanente, @dpd_cant_ciclos_max, @cantidad_ciclos_descuento
		if (@cantidad_ciclos_descuento + 1) > @dpd_cant_ciclos_max
			set @permite_descuento = 0
	end	
	--select @permite_descuento
	return @permite_descuento --1: Si se le permite el descuento, 0: No se le permite el descuento
end


	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-07-05 01:20:34>
	-- Description: <Realiza el mantenimiento a la tabla “col_dpd_definicion_politica_descuento” y "col_tmp_tipo_mensualidad_con_politicas">
	-- =============================================
alter procedure sp_col_dpd_definicion_politica_descuento
	@opcion int = 0,
	@dpd_codigo int = 0,
	@dpd_tipo varchar(250) = '',
	@dpd_permanente bit = 0,
	@dpd_cant_ciclos_max int = 0,
	@dpd_codusr int = 0,

	@codtipmen int = 0,
	@codtmp int = 0
as
begin
	if @opcion = 1--Muesta todas las políticas
	begin
		select dpd_codigo, dpd_tipo, cast(dpd_permanente as varchar(5)) dpd_permanente,
		case when dpd_permanente = 1 then 'Si' else 'No' end permanente, 
		case when dpd_cant_ciclos_max = -1 then 'N/A' else cast(dpd_cant_ciclos_max as varchar(5)) end cantidad_ciclos,
		dpd_cant_ciclos_max
		from col_dpd_definicion_politica_descuento
	end
	
	if @opcion = 2--Inserta la política
	begin
		insert into col_dpd_definicion_politica_descuento (dpd_tipo, dpd_permanente, dpd_cant_ciclos_max, dpd_codusr)
		values (@dpd_tipo, @dpd_permanente, @dpd_cant_ciclos_max, @dpd_codusr)
	end

	if @opcion = 3--Actualiza la política
	begin
		update col_dpd_definicion_politica_descuento set dpd_tipo = @dpd_tipo, dpd_permanente = @dpd_permanente, 
		dpd_cant_ciclos_max = case when @dpd_permanente = 1 then -1 else @dpd_cant_ciclos_max end,
		dpd_codusr = @dpd_codusr where dpd_codigo = @dpd_codigo
	end

	if @opcion = 4 --Muestra los tipos de mensuialidades que no estan en una politica
	begin
		select tipmen_codigo, tipmen_tipo from col_tipmen_tipo_mensualidad
		where tipmen_codigo not in (select distinct tmp_codtipmen from col_tmp_tipo_mensualidad_con_politicas) and tipmen_estado = 1
	end

	if @opcion = 5 --Muestra las cuotas definidas en la politicas @coddpd
	begin
		-- sp_col_dpd_definicion_politica_descuento @opcion = 5, @dpd_codigo = 4
		select tmp_codigo, tipmen_codigo, dpd_codigo, tipmen_tipo from col_tmp_tipo_mensualidad_con_politicas
		inner join col_dpd_definicion_politica_descuento  on dpd_codigo = tmp_coddpd
		inner join col_tipmen_tipo_mensualidad on tipmen_codigo = tmp_codtipmen
		--inner join ra_vac_valor_cuotas on vac_codigo = tipmen_codvac
		where dpd_codigo = @dpd_codigo
	end

	if @opcion = 6--Inserta una mensualidad a la política
	begin
		insert into col_tmp_tipo_mensualidad_con_politicas (tmp_coddpd, tmp_codtipmen, tmp_codusr)
		values (@dpd_codigo, @codtipmen, @dpd_codusr)
	end

	if @opcion = 7 --Botta una mensualidad de la política
	begin
		delete from col_tmp_tipo_mensualidad_con_politicas
		where tmp_codigo = @codtmp
	end
end
