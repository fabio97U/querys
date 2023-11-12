alter table ra_per_personas add per_tipo_alumno varchar(50) null--AdministrativoUtec, ProfesorHoraClaseUtec, ProfesionalExterno
select * from dip_dip_diplomados where dip_nombre like '%cohor%'
select top 2 per_tipo_alumno, per_carnet_anterior, per_correo_institucional, * from ra_per_personas order by per_codigo desc
select top 2 * from dip_ped_personas_dip order by ped_codigo desc

insert into col_cuo_cuotas (col_codreg, col_codigo, col_descripcion, col_valor, col_aplica, col_estado)
values (1, 130, 'Postgrado en campus virtuales para la práctica educativa', 0, 'D', 'A')

alter table cil_cpd_cuotas_pagar_diplomado add cpd_tipo_alumno varchar(50) null--AdministrativoUtec, ProfesorHoraClaseUtec, ProfesionalExterno
select * from cil_cpd_cuotas_pagar_diplomado where cpd_codigo >= 29

insert into cil_cpd_cuotas_pagar_diplomado (cpd_coddip, cpd_codtmo, cpd_orden, cpd_graduado_utec, cpd_tipo_alumno)
values (1335, 4154, 0, null, 'AdministrativoUtec'), (1335, 4154, 1, null, 'AdministrativoUtec'), (1335, 4154, 2, null, 'AdministrativoUtec'), (1335, 4154, 3, null, 'AdministrativoUtec'), (1335, 4154, 4, null, 'AdministrativoUtec'), (1335, 4154, 5, null, 'AdministrativoUtec'), (1335, 4154, 6, null, 'AdministrativoUtec'), (1335, 4154, 7, null, 'AdministrativoUtec'), (1335, 4154, 8, null, 'AdministrativoUtec'), (1335, 4154, 9, null, 'AdministrativoUtec'), (1335, 4154, 10, null, 'AdministrativoUtec'), (1335, 4154, 11, null, 'AdministrativoUtec')

insert into cil_cpd_cuotas_pagar_diplomado (cpd_coddip, cpd_codtmo, cpd_orden, cpd_graduado_utec, cpd_tipo_alumno)
values (1335, 4155, 0, 1, null), (1335, 4155, 1, 1, null), (1335, 4155, 2, 1, null), (1335, 4155, 3, 1, null), (1335, 4155, 4, 1, null), (1335, 4155, 5, 1, null)

insert into cil_cpd_cuotas_pagar_diplomado (cpd_coddip, cpd_codtmo, cpd_orden, cpd_graduado_utec, cpd_tipo_alumno)
values (1335, 4156, 0, null, 'ProfesorHoraClaseUtec'), (1335, 4156, 1, null, 'ProfesorHoraClaseUtec'), (1335, 4156, 2, null, 'ProfesorHoraClaseUtec'), (1335, 4156, 3, null, 'ProfesorHoraClaseUtec'), (1335, 4156, 4, null, 'ProfesorHoraClaseUtec'), (1335, 4156, 5, null, 'ProfesorHoraClaseUtec')

insert into cil_cpd_cuotas_pagar_diplomado (cpd_coddip, cpd_codtmo, cpd_orden, cpd_graduado_utec, cpd_tipo_alumno)
values (1335, 4157, 0, null, 'ProfesionalExterno'), (1335, 4157, 1, null, 'ProfesionalExterno'), (1335, 4157, 2, null, 'ProfesionalExterno'), (1335, 4157, 3, null, 'ProfesionalExterno'), (1335, 4157, 4, null, 'ProfesionalExterno'), (1335, 4157, 5, null, 'ProfesionalExterno')

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[Registra_Alumno]    Script Date: 6/3/2023 20:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:      <>
	-- Last modify: <Erik, 2022-09-09 15:04:50.122>
	-- Last modify: <Fabio, 2022-12-21T13:30:15.7133645-06:00>
	-- Description: <Realiza la inserción de expediente y generacion de un nuevo carnet>
	-- =============================================
	-- exec dbo.Registra_Alumno
ALTER procedure [dbo].[Registra_Alumno] 
	@regional int,
	@codcil int,
	@fecha varchar(10),
	@tipo varchar(1),
	@ingreso int,
	@procedencia varchar(1),
	@email varchar(60),
	@universidad int,
	@carrera nvarchar(5), -----==================
	@nombres varchar(60),
	@apellidos varchar(60),
	@sexo varchar(1),
	@telefonos varchar(40),
	@celular varchar(40),
	@movimiento int,
	@colegio int,
	@bachillerato int,
	@medio int,
	@discapacidad varchar(1000),
	@diplomado int,
	@fecha_nac varchar(10),
	@usuario int ,
	@lugar_matr int,
	@per_virtual_especial nvarchar(1),
	@per_codvac int,
	@per_carnet_anterior varchar(30) = '',
	@dui varchar(50) = '',
	@nit varchar(17) = '',
	@direccion varchar(200) = '',
	@tipoalumno varchar(50) = ''--PARA CATEGORIZAR PAGOS DE DIPLOMADOS: , AdministrativoUtec, ProfesorHoraClaseUtec, ProfesionalExterno
 as
begin
	
	set dateformat dmy;

	declare @corr int, @alumno int, 
	@carnet varchar(12), @plan int, 
	@potencial int,@registro varchar(500), 
	@fecha_aud datetime, @anio int,
	@codigo_dip int, @prefijo varchar(2)

	select @prefijo = isnull(dip_prefijo,'DI') from dip_dip_diplomados where dip_codigo = @diplomado

	if @prefijo is null
	begin
		set @prefijo = 'DI'
	end
	if @prefijo = '' 
	begin
		set @prefijo = 'DI'
	end
	if @tipo = 'E' 
	begin
		set @tipo = 'U'
	end

	select @anio = cil_anio from ra_cil_ciclo where cil_codigo = @codcil

	select @alumno = max(isnull(per_codigo,0))+1 from ra_per_personas
	
	if (@ingreso <> 0)
	begin
		declare @pla_anio int 

		select @pla_anio = max(pla_anio) from ra_pla_planes
			join ra_car_carreras on car_codigo = pla_codcar
		where car_identificador = right('00'+cast(@carrera as varchar), 2)
			and pla_estado = 'A' and pla_tipo = 'U'

		select @plan = max(pla_codigo)
		from ra_pla_planes
			join ra_car_carreras on car_codigo = pla_codcar
		where car_identificador = right('00'+cast(@carrera as varchar), 2)
			and pla_estado = 'A' and pla_tipo = 'U'
			and pla_anio = @pla_anio

		--Inicio: Caso plan 2023 por equivalencia mover a plan 2018
		if @pla_anio = 2023 and @ingreso = 4
		begin
			print 'Caso plan 2023 por equivalencia mover a plan 2018'
			select @plan = max(pla_codigo)
			from ra_pla_planes
				join ra_car_carreras on car_codigo = pla_codcar
			where car_identificador = right('00'+cast(@carrera as varchar), 2)
				and pla_estado = 'A' and pla_tipo = 'U'
				and pla_anio = 2018
		end
		--Fin: Caso plan 2023 por equivalencia mover a plan 2018
	end
	print '@plan: ' + cast(@plan as varchar(5))

	select @corr = cast(max(SUBSTRING(per_carnet,4,4)) as int)
	from ra_per_personas where per_codreg = @regional and per_anio_ingreso = @anio and per_tipo = @tipo

	if @corr is null 
		set @corr = 0

	set @corr = @corr + 1

	if @tipo = 'U'
	begin
		select @carnet = right('00'+cast(@carrera as varchar),2) + '-'+ right('0000'+cast(@corr as varchar),4)+'-'+ cast(@anio as varchar)
	end
	if @tipo = 'D'
	begin
		select @carnet = @prefijo +  '-' + right('0000'+cast(@corr as varchar),4)+ '-'+ cast(@anio as varchar)
	end
	if @tipo = 'P'
	begin
		select @carnet = 'PA' +  '-' + right('0000'+cast(@corr as varchar),4)+ '-' + cast(@anio as varchar)
	end

	insert into ra_per_personas
	(per_codigo, per_codreg, per_nombres, per_apellidos,
	per_tipo, per_estado,per_carnet,per_fecha_ingreso,per_est_civil, per_sexo,
	per_tipo_ingreso, per_fecha,per_medio, per_codcil_ingreso, per_telefono,per_anio_ingreso,per_email,
	per_colegio_graduacion,per_codtib,per_discapacidad, per_celular,per_fecha_nac,per_tipo_ingreso_fijo,per_lugar_proc,		
	per_virtual_especial, per_codvac,per_origen, per_codusr_creacion, per_dui, per_nit, per_direccion, per_tipo_alumno)
	select isnull(max(per_codigo),0)+1,@regional,@nombres, @apellidos,@tipo,'A',@carnet,
	convert(datetime,@fecha,103),'S',@sexo,@ingreso, getdate(),
	@medio,@codcil, @telefonos,@anio,@email, @colegio, @bachillerato, @discapacidad, @celular,
	convert(datetime,@fecha_nac,103),@ingreso,@lugar_matr, @per_virtual_especial, @per_codvac,
	case when @per_virtual_especial ='N' then 'N' 
	when @per_virtual_especial='S' then 'S' 
	end, @usuario, @dui, @nit, @direccion, @tipoalumno
	from ra_per_personas

	if @ingreso = 4
	begin
		insert into dbo.ra_equ_equivalencia_universidad(equ_codreg,equ_codigo,
		equ_codper,equ_codpla,equ_codist,equ_usuario,equ_fecha,equ_tipo)
		select @regional,isnull(max(equ_codigo),0)+1,@alumno,@plan,
		@universidad,@usuario,getdate(),'E'
		from ra_equ_equivalencia_universidad
	end

	if @tipo = 'U'
	begin
		insert into ra_cap_car_per
		select @alumno,isnull(max(cap_codigo),0) + 1,1,(select car_codigo from ra_car_carreras where car_identificador = @carrera) ---======
		from ra_cap_car_per

		insert into dbo.ra_hac_his_alm_car(hac_codigo,hac_codper,hac_codpla,hac_fecha_creacion,hac_usuario,
		hac_carnet,hac_ingreso)
		select isnull(max(hac_codigo),0) + 1, @alumno, @plan, getdate(), @usuario, @carnet,'S'
		from ra_hac_his_alm_car

		insert into ra_alc_alumnos_carrera
		select isnull(max(alc_codigo),0) + 1, @alumno, @plan, getdate()
		from ra_alc_alumnos_carrera

		insert into dbo.col_cua_cuotas_alumnos
		select 1, isnull(max(cua_codigo),0)+1, @alumno, @codcil, @movimiento
		from col_cua_cuotas_alumnos
	end

	if @tipo = 'U' or @tipo = 'D'
	begin
		print 'Se agrego el correo institucional de forma automatica'
		update ra_per_personas 
		set per_correo_institucional = replace(per_carnet,'-','') + '@mail.utec.edu.sv'
		where per_carnet = @carnet
	end

	if @tipo = 'D'
	begin
		select @codigo_dip = isnull(max(ped_codigo),0) + 1 from dip_ped_personas_dip
		insert into dip_ped_personas_dip(ped_codreg, ped_codigo, ped_coddip,ped_codper,ped_procedencia)
		select @regional,@codigo_dip,@diplomado,@alumno,@procedencia
		
		if (@per_carnet_anterior != '') -- tiene carrera anterior
		begin
			update ra_per_personas 
			set per_carnet_anterior = @per_carnet_anterior
			where per_carnet = @carnet
		end
	end

	set @fecha_aud = getdate()

	select @registro = cast(@alumno as varchar) + cast(@carnet as varchar) + isnull(@nombres,'') + isnull(@apellidos,'') 

	exec auditoria_del_sistema 'ra_per_personas', 'I', @usuario, @fecha_aud, @registro

	----registro_alumno
	--exec dbo.TEMP_ESTUDIANTE_RINNOVO @alumno
	--exec dbo.TEMP_ALUMNO_CARRERA_RINNOVO @alumno

end

--Alterar
--dbo.sp_boletas_diplomados

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2021-02-26 21:33:03.551>
	-- Description: <Realiza el proceso de generacion de la data para boletas de pago de diplomados>
	-- =============================================
ALTER procedure [dbo].[sp_boletas_diplomados]
	@opcion int = 0,
	--@codper int = 0, 
	@per_carnet varchar(16) = '',
	@pboa_codigo int = 0
as
begin
	declare @per_codigo int = 0, @coddip int = 0, @per_carnet_anterior varchar(32) = '',
	@graduado_utec int = 0, @cil_codigo_vigente int = 0, @per_tipo_alumno varchar(50)

	declare @tbl_data as table (
		carnet nvarchar(15), alumno nvarchar(75),
		tmo_arancel nvarchar(15), Monto float,
		arancel nvarchar(125), carrera nvarchar(150),
		barra nvarchar(80), npe nvarchar(40),
		ciclo nvarchar(10), coddao int,
		fecha_creacion datetime
	)

	select top 1 @cil_codigo_vigente = cil_codigo from ra_cil_ciclo where cil_vigente = 'S' order by cil_codigo desc

	select @per_codigo = per_codigo, @coddip = ped_coddip, @per_carnet_anterior = per_carnet_anterior, 
		@per_tipo_alumno = case when per_carnet_anterior is null then per_tipo_alumno else null end
	from dip_ped_personas_dip 
		inner join ra_per_personas on per_codigo = ped_codper
	where per_carnet = @per_carnet

	if (isnull(@per_carnet_anterior, '') != '')
	begin
		set @graduado_utec = 1
	end

	if @opcion = 1
	begin
		-- exec dbo. sp_boletas_diplomados @opcion = 1, @per_carnet = 'DI-0110-2023'
		select per_carnet, per_nombres_apellidos, dip_nombre, fac_nombre
		from dip_ped_personas_dip 
			inner join ra_per_personas on per_codigo = ped_codper
			inner join dip_dip_diplomados on ped_coddip = dip_codigo
			left join ra_fac_facultades on fac_codigo = dip_codfac
		where ped_codper = @per_codigo
		
		print '@graduado_utec: ' + cast(@graduado_utec as varchar(2))
		print '@per_tipo_alumno: ' + cast(@per_tipo_alumno as varchar(50))

		select dpboa_codigo, cpd_codtmo, cpd_orden, tmo_arancel, tmo_descripcion, tmo_valor, cpd_graduado_utec, cpd_tipo_alumno
		from cil_cpd_cuotas_pagar_diplomado
			inner join col_tmo_tipo_movimiento on tmo_codigo = cpd_codtmo
			inner join col_dpboa_definir_parametro_boleta_otros_aranceles on dpboa_codtmo = cpd_codtmo
		where cpd_coddip = @coddip and cpd_graduado_utec = @graduado_utec
		
			union all

		select dpboa_codigo, cpd_codtmo, cpd_orden, tmo_arancel, tmo_descripcion, tmo_valor, cpd_graduado_utec, cpd_tipo_alumno
		from cil_cpd_cuotas_pagar_diplomado
			inner join col_tmo_tipo_movimiento on tmo_codigo = cpd_codtmo
			inner join col_dpboa_definir_parametro_boleta_otros_aranceles on dpboa_codtmo = cpd_codtmo
		where cpd_coddip = @coddip and cpd_tipo_alumno = @per_tipo_alumno
		order by cpd_orden
		--select * from cil_cpd_cuotas_pagar_diplomado where cpd_tipo_alumno = 'ProfesionalExterno'
	end

	if @opcion = 2
	begin
		-- exec dbo. sp_boletas_diplomados @opcion = 2, @per_carnet = 'DI-0110-2023', @pboa_codigo = 156
		exec dbo.sp_col_dao_data_otros_aranceles @opcion = 3, @codper = @per_codigo, 
			@codcil = @cil_codigo_vigente, @codpboa = @pboa_codigo
	end

end


