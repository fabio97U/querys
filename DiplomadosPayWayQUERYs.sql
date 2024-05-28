select top 5 * from dip_dip_diplomados order by ped_codigo desc
select top 5 * from dip_amd_alm_modulo order by amd_codigo desc

delete from dip_ped_personas_dip where ped_codigo >= 12022
select top 5 per_codcil_ingreso, * from ra_per_personas where per_tipo = 'D' order by per_codigo desc
update user_pago_online set upo_codper = null where upo_codusc = 1
delete from ra_per_personas where per_codigo >= 254062
select * from ra_mun_municipios where MUN_CODIGO = 272
select * from col_art_archivo_tal_mora where per_codigo = 254064
select * from col_mov_movimientos where mov_codper = 254062

alter table ra_per_personas add per_codupo int
alter table dip_dip_diplomados add dip_vigencia_desde date
alter table dip_dip_diplomados add dip_vigencia_hasta date
alter table dip_dip_diplomados add dip_link_brochure varchar(2048)
alter table dip_dip_diplomados add dip_correos_responsables varchar(1024)
alter table dip_dip_diplomados add dip_telefonos_responsables varchar(1024)
alter table ra_fac_facultades add fac_telefono_facultad varchar(50) null
alter table col_fel_fechas_limite add fel_codtad int
alter table col_fel_fechas_limite add fel_coddip int
alter table col_art_archivo_tal_mora add art_codusc int
alter table col_art_archivo_tal_mora add art_coddip int
alter table dip_ped_personas_dip add ped_codper_cuenta_original int
alter table dip_amd_alm_modulo add amd_codper_cuenta_original int

select top 10 * from ra_fac_facultades

update ra_fac_facultades set fac_telefono_facultad = '2275-8941' where fac_codigo = 6
update ra_fac_facultades set fac_telefono_facultad = '2275-8915' where fac_codigo = 7
update ra_fac_facultades set fac_telefono_facultad = '2275-8841' where fac_codigo = 8
update ra_fac_facultades set fac_telefono_facultad = '2275-2707' where fac_codigo = 10
update ra_fac_facultades set fac_telefono_facultad = '2275-0000' where fac_codigo = 13
update ra_fac_facultades set fac_telefono_facultad = '2275-8807' where fac_codigo = 15

--select top 10 * from dip_dip_diplomados order by dip_codigo desc
--select top 10 * from dip_dip_diplomados where dip_nombre like '%expo%' order by dip_codigo desc
select top 10 * from dip_dip_diplomados where dip_codigo = 1524--DIPLOMADOS
select top 10 * from dip_ped_personas_dip where ped_coddip = 1524--ESTUDIANTES INSCRITOS

update dip_dip_diplomados set dip_vigencia_desde = '2024-03-10', dip_vigencia_hasta = '2024-04-30', dip_link_brochure = 'https://portal.utec.edu.sv/publicidad/calendario.pdf', dip_necesita_cuenta_AD = 1,
dip_telefonos_responsables = '2275-8941'
where dip_codigo in (1524, 1523, 1522, 1521, 1520, 1519, 1518, 1517, 1516, 1515, 1503)
go
--select * from dip_dip_diplomados where dip_codigo in (1524, 1523, 1522, 1521, 1520, 1519, 1518, 1517, 1516, 1515, 1503)

select * from user_pago_online
inner join usc_user_datos_sin_carnet on usc_usuario = upo_usuario
left join ra_per_personas on upo_codper = per_codigo

--select distinct cpd_tipo_alumno from cil_cpd_cuotas_pagar_diplomado
-- drop table tad_tipo_alumno_diplomado
create table tad_tipo_alumno_diplomado (
	tad_codigo int primary key identity (1, 1),
	tad_tipo_alumno varchar(100),
	tad_fecha_creacion datetime default getdate()
)
-- select * from tad_tipo_alumno_diplomado
insert into tad_tipo_alumno_diplomado (tad_tipo_alumno) values ('Estudiante UTEC'), ('Graduado UTEC'), ('Persona Externa')
go
select * from col_tmo_tipo_movimiento where tmo_arancel = 'D-124'

--Definicion de aranceles diplomados, CRUD
	--Ciclo: <..>
	--Tipo alumno: <select * from tad_tipo_alumno_diplomado>
	--Diplomado: <select * from dip_dip_diplomados>
		--Fecha de pago:
		--Fecha de mora: <Fecha de pago + 1 dia>
		--Arancel a cancelar: <select * from col_tmo..>
		--Valor: [edite]
		--Valor mora: [Valor, editar]
	--*Fel_codigo_barra + 1

--Grid:
	--{select * from col_fel_fechas_limite where fel_codcil = 134-- and fel_codtad = 3 and fel_coddip is not null}

declare @codigo_usuario int = 1, @codcil_generar_boleta int = 134, @codtad int = 3
select *
from usc_user_datos_sin_carnet
	join col_fel_fechas_limite on fel_codcil = @codcil_generar_boleta and fel_codtad = @codtad
	join col_tmo_tipo_movimiento on tmo_codigo = fel_codtmo
	join ra_cil_ciclo on cil_codigo = fel_codcil
	join user_pago_online on usc_usuario = upo_usuario

	left join ra_per_personas on upo_codper = per_codigo
	left join ra_alc_alumnos_carrera on alc_codper = per_codigo
	left join ra_pla_planes on pla_codigo = alc_codpla
	left join ra_car_carreras on car_codigo = pla_codcar
where usc_codigo = @codigo_usuario 
	and @codigo_usuario not in (select distinct per_codigo from col_art_archivo_tal_mora where (per_codigo = @codigo_usuario or art_codusc = @codigo_usuario) and ciclo = @codcil_generar_boleta)

insert into col_fel_fechas_limite 
(fel_codreg, fel_codcil, fel_mes, fel_anio, fel_fecha, fel_codtmo, fel_tipo, fel_fecha_gracia, fel_codigo_barra, fel_valor, fel_global, fel_valor_mora, fel_fecha_mora, fel_tipo_alumno, fel_codvac, fel_codtipmen, fel_fechahora, fel_codtad, fel_coddip)
values 
(1, 134, 3, 2024, '2024-03-16', 2866, 'N', null, 0, 40, 0, 40, '2024-03-17', null, null, null, getdate(), 3, 1524),
(1, 134, 3, 2024, '2024-03-16', 2867, 'N', null, 1, 65, 1, 65, '2024-03-17', null, null, null, getdate(), 3, 1524),
(1, 134, 3, 2024, '2024-04-16', 2867, 'N', null, 2, 65, 2, 65, '2024-04-17', null, null, null, getdate(), 3, 1524),

(1, 134, 3, 2024, '2024-03-16', 2866, 'N', null, 0, 40, 0, 40, '2024-03-17', null, null, null, getdate(), 1, 1524),
(1, 134, 3, 2024, '2024-03-16', 2867, 'N', null, 1, 65, 1, 65, '2024-03-17', null, null, null, getdate(), 1, 1524),
(1, 134, 3, 2024, '2024-04-16', 2867, 'N', null, 2, 65, 2, 65, '2024-04-17', null, null, null, getdate(), 1, 1524),

(1, 134, 3, 2024, '2024-03-16', 2866, 'N', null, 0, 40, 0, 40, '2024-03-17', null, null, null, getdate(), 2, 1524),
(1, 134, 3, 2024, '2024-03-16', 2867, 'N', null, 1, 65, 1, 65, '2024-03-17', null, null, null, getdate(), 2, 1524),
(1, 134, 3, 2024, '2024-04-16', 2867, 'N', null, 2, 65, 2, 65, '2024-04-17', null, null, null, getdate(), 2, 1524),

(1, 134, 3, 2024, '2024-03-16', 4396, 'N', null, 0, 80, 0, 80, '2024-03-17', null, null, null, getdate(), 3, 1523),
(1, 134, 3, 2024, '2024-03-16', 4438, 'N', null, 1, 100, 1, 100, '2024-03-17', null, null, null, getdate(), 3, 1523),
(1, 134, 3, 2024, '2024-04-16', 4438, 'N', null, 2, 100, 2, 100, '2024-04-17', null, null, null, getdate(), 3, 1523),

(1, 134, 3, 2024, '2024-03-16', 4396, 'N', null, 0, 80, 0, 80, '2024-03-17', null, null, null, getdate(), 2, 1523),
(1, 134, 3, 2024, '2024-03-16', 4438, 'N', null, 1, 100, 1, 100, '2024-03-17', null, null, null, getdate(), 2, 1523),
(1, 134, 3, 2024, '2024-04-16', 4438, 'N', null, 2, 100, 2, 100, '2024-04-17', null, null, null, getdate(), 2, 1523),

(1, 134, 3, 2024, '2024-03-16', 4411, 'N', null, 0, 80, 0, 100, '2024-03-17', null, null, null, getdate(), 3, 1522),
(1, 134, 3, 2024, '2024-03-16', 4414, 'N', null, 1, 150, 1, 150, '2024-03-17', null, null, null, getdate(), 3, 1522),
(1, 134, 3, 2024, '2024-04-16', 4414, 'N', null, 2, 150, 2, 150, '2024-04-17', null, null, null, getdate(), 3, 1522),
(1, 134, 3, 2024, '2024-05-16', 4414, 'N', null, 3, 150, 3, 150, '2024-05-17', null, null, null, getdate(), 3, 1522)
go

delete from col_fel_fechas_limite where fel_codigo >= 767
delete from col_fel_fechas_limite where fel_codtad in (1, 2, 3)

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_diplomados_payway]    Script Date: 19/4/2024 08:40:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2024-03-12 15:34:11.450>
	-- Description: <Procedimiento usado para el proceso de diplomados en payway>
	-- =============================================
	-- exec dbo.sp_diplomados_payway @opcion = 1
	-- exec dbo.sp_diplomados_payway @opcion = 2, @coddip = 1524, @codupo = 42530, @codcil_generar = 134, @codtad = 3
create or alter procedure [dbo].[sp_diplomados_payway]
	@opcion int = 0,
	@coddip int = 0,
	@codigo_usuario int = 0,
	@codcil_generar int = 134,
	@codtad int  = 3,
	@referencia_pago varchar(50) = '',
	@npe_cancelado varchar(50) = '',
	@codupo int = 0,
	@codhrm int = 0
as
begin

	--select * from usc_user_datos_sin_carnet where usc_codigo = @codigo_usuario
	--select * from ra_per_personas where per_codigo = @codigo_usuario
	
	declare @codusc int, @codper int, @usuario varchar(50) = '', @carnet varchar(30)  = '', @per_tipo varchar(10), @per_estado varchar(10), @nombres varchar(250), @apellidos varchar(250)
		declare @correo_institucional varchar(50) = ''

	declare @fecha_ varchar(10) = format(getdate(), 'dd/MM/yyyy'), @email_ varchar(50) = '', --@nombres_ varchar(125) = '', @apellidos_ varchar(125) = '',
		@sexo_ varchar(1) = '', @telefonos_ varchar(30) = '', @celular_ varchar(30) = '', @fecha_nac_ varchar(10) = '', @dui_ varchar(30) = '', @direccion_ varchar(100) = '',
		@per_codmun_nac_ int = 0, @per_dui_fecha_vnto_ varchar(10) = ''

	select @codusc = usc_codigo, @codper = upo_codper, @usuario = upo_usuario, @carnet = per_carnet, @per_tipo = per_tipo, @per_estado = per_estado,
		@correo_institucional = per_correo_institucional, @nombres = upper(isnull(per_nombres, usc_nombres)), @apellidos = upper(isnull(per_apellidos, usc_apellidos)),
		@email_ = isnull(usc_email, per_email),
		@sexo_ = case when isnull(per_sexo, '') = '' then case when usc_sexo = 'Masculino' then 'M' else 'F' end else per_sexo end,
		@telefonos_ = isnull(usc_telefono_fijo, per_telefono), @celular_ = isnull(usc_celular, per_celular), 
		@fecha_nac_ = format(isnull(usc_fecha_nacimiento, per_fecha_nac), 'dd/MM/yyyy'), @dui_ = isnull(usc_dui, per_dui), @direccion_ = isnull(usc_direccion, per_direccion),
		@per_codmun_nac_ = isnull(usc_id_municipio, per_codmun_nac), @per_dui_fecha_vnto_ = format(isnull(usc_fecha_vencimiento_dui, per_dui_fecha_vnto), 'dd/MM/yyyy')
	from upo_user_pago_online
		left join ra_per_personas on upo_codper = per_codigo
		left join dip_ped_personas_dip on ped_codper = per_codigo and isnull(ped_coddip, 0) = @coddip

		left join usc_user_datos_sin_carnet on upo_codusc = usc_codigo
	where upo_id = @codupo

	select @codtad = case 
		when @codusc is not null then 3 
		when @codper is not null then 
			case when @per_estado = 'G' then 2
			when @per_estado in ('A', 'E') then 1
			end
		end
	print '@codtad: ' + cast(isnull(@codtad, '') as varchar(10))
	print '@per_estado: ' + cast(isnull(@per_estado, '') as varchar(10))
	print '@codper: ' + cast(isnull(@codper, '') as varchar(10))

	if @opcion = 1
	begin
		select dip_codigo, dip_nombre, dip_necesita_cuenta_AD, dip_vigencia_desde, dip_vigencia_hasta, dip_link_brochure 
		from dip_dip_diplomados
		where getdate() between dip_vigencia_desde and dip_vigencia_hasta
		order by dip_codigo desc
	end

	if @opcion = 6
	begin
		-- exec dbo.sp_diplomados_payway @opcion = 6, @coddip = 1524
		select mdp_coddip, mdp_nombre, hrm_codigo, hrm_codfea, hrm_descripcion 
		from dip_mdp_modulos_diplomado 
			inner join dip_fea_fechas_autorizadas on fea_codmdp = mdp_codigo 
			inner join dip_hrm_horarios on hrm_codfea = fea_codigo
		where mdp_coddip = @coddip
	end

	if @opcion = 2
	begin
		-- exec dbo.sp_diplomados_payway @opcion = 2, @coddip = 1522, @codupo = 42778, @codcil_generar = 134
		exec dbo.tal_GenerarDataTalonariosDiplomados_masivo @opcion = 1, @codcil_generar_boleta = @codcil_generar, @codtad = @codtad, @coddip = @coddip, @codupo = @codupo
	end

	if @opcion = 3 -- crear el registro del alumno
	begin
		-- select * from upo_user_pago_online order by upo_id desc
		-- exec dbo.sp_diplomados_payway @opcion = 3, @coddip = 1522, @codupo = 42778, @codcil_generar = 134, @codhrm = 2183
		--select * from ra_per_personas inner join dip_ped_personas_dip on ped_codper = per_codigo and per_codcil_ingreso = @codcil_generar where per_codupo = @codupo and ped_coddip = @coddip
		if not exists (select 1 from ra_per_personas inner join dip_ped_personas_dip on ped_codper = per_codigo and per_codcil_ingreso = @codcil_generar where per_codupo = @codupo and ped_coddip = @coddip)
		begin
			
			exec dbo.Registra_Alumno @regional = 1, @codcil = @codcil_generar, @fecha = @fecha_, @tipo = 'D', @ingreso = 1, @procedencia = 'N'/*S y N??*/, 
				@email = @email_, @universidad = '', @carrera = '', @nombres = @nombres, @apellidos = @apellidos, @sexo = @sexo_, 
				@telefonos = @telefonos_, @celular = @celular_, @movimiento = 0, @colegio = 0, @bachillerato = 0, 
				@medio = 0, @discapacidad = '', @diplomado = @coddip, @fecha_nac = @fecha_nac_, 
				@usuario = 378, @lugar_matr = 1, @per_virtual_especial = 'N', 
				@per_codvac = 0, @per_carnet_anterior = ''/*diff '' then tiene carrera anterior*/, @dui = @dui_, @nit = @dui_, @direccion = @direccion_, 
				@tipoalumno = ''/*es per_tipo_alumno*/, @per_pasaporte = '', @per_documento_otros = '', @per_origen = 'N', @per_codmun_nac = @per_codmun_nac_, 
				@per_coddep_nac = 0, @per_nacionalidad = 1, @per_dui_fecha_vnto = @per_dui_fecha_vnto_
			
			declare @codper_diplomado int
			select top 1 @codper_diplomado = per_codigo, @correo_institucional = per_correo_institucional from ra_per_personas where per_tipo = 'D' order by per_codigo desc

			if @codper is null
			begin
				update user_pago_online set upo_codper = @codper_diplomado where upo_id = @codupo
			end
			update ra_per_personas set per_codupo = @codupo where per_codigo = @codper_diplomado
			update dip_ped_personas_dip set ped_codper_cuenta_original = isnull(@codper, @codper_diplomado) where ped_codper = @codper_diplomado

			--exec dbo.tal_GenerarDataTalonariosDiplomados_masivo @opcion = 1, @codcil_generar_boleta = @codcil_generar, @codtad = @codtad, @coddip = @coddip, @codupo = @codupo
			exec dbo.tal_GenerarDataTalonariosDiplomados_masivo @opcion = 2, @codcil_generar_boleta = @codcil_generar, @codtad = @codtad, @coddip = @coddip, @codupo = @codupo

			declare @codamd int = 0
			select @codamd = max(amd_codigo) + 1 from dip_amd_alm_modulo

			insert into dip_amd_alm_modulo (amd_codigo, amd_codper, amd_codfea, amd_fecha_ingreso, amd_estado, amd_codhrm, amd_usuario, amd_codper_cuenta_original)
			select @codamd, @codper_diplomado, hrm_codfea, getdate(), 'I', hrm.hrm_codigo, 'user.online', isnull(@codper, @codper_diplomado)
			from dip_mdp_modulos_diplomado 
				inner join dip_fea_fechas_autorizadas on fea_codmdp = mdp_codigo 
				inner join dip_hrm_horarios hrm on hrm_codfea = fea_codigo
			where mdp_coddip = @coddip and hrm.hrm_codigo = @codhrm
			--and hrm.hrm_descripcion = '01'

			select 1 'codigo_respuesta', 'Estudiante creado' 'texto_respuesta', isnull(@codper, @codper_diplomado) 'codper', @codper_diplomado 'codper_diplomado', @correo_institucional 'correo_institucional'
		end
		else
		begin
			select -1 'codigo_respuesta', concat('Usuario de pago ', @usuario, ' ya esta registrado en el diplomado ', @carnet) 'texto_respuesta', @codper 'codper', @correo_institucional 'correo_institucional'
		end

	end

	if @opcion = 4-- realiza el pago y autializa las boletas de pago
	begin
		-- exec dbo.sp_diplomados_payway @opcion = 4, @coddip = 1522, @codcil_generar = 134, @npe_cancelado = '2', @referencia_pago = 'eeesdxc', @codigo_usuario = 254177
		declare @fel_codigo_barra int = 0
		select @fel_codigo_barra = fel_codigo_barra from col_art_archivo_tal_mora where per_codigo = @codigo_usuario and ciclo = @codcil_generar and fel_codigo_barra = @npe_cancelado and art_coddip = @coddip
		
		declare @tbl_aranceles as table (per_codigo int, fel_codigo_barra varchar(50))
		insert into @tbl_aranceles (per_codigo, fel_codigo_barra)
		select per_codigo, fel_codigo_barra from col_art_archivo_tal_mora where per_codigo = @codigo_usuario and ciclo = @codcil_generar and art_coddip = @coddip and fel_codigo_barra <= @npe_cancelado
		
		--select * from col_art_archivo_tal_mora where per_codigo = @codigo_usuario
		--select * from @tbl_aranceles
		--select * from col_mov_movimientos mov where mov.mov_codper = @codigo_usuario and mov.mov_estado not in ('A')
		--select NPE from col_art_archivo_tal_mora a where a.per_codigo = @codigo_usuario --and a.fel_codigo_barra in (0, 1) 
		--	and art_coddip = @coddip
		--	and a.fel_codigo_barra in (select t.fel_codigo_barra from @tbl_aranceles t)
		--	and isnull(a.NPE, '') not in (select isnull(mov.mov_npe, '') from col_mov_movimientos mov where mov.mov_codper = @codigo_usuario and mov.mov_estado not in ('A'))
		--order by fel_codigo_barra

		declare @npe varchar(60)--Variables del select
		declare m_cursor cursor 
		for
			select NPE from col_art_archivo_tal_mora a where a.per_codigo = @codigo_usuario --and a.fel_codigo_barra in (0, 1) 
				and a.fel_codigo_barra in (select t.fel_codigo_barra from @tbl_aranceles t)
				and art_coddip = @coddip
				and isnull(a.NPE, '') not in (select isnull(mov.mov_npe, '') from col_mov_movimientos mov where mov.mov_codper = @codigo_usuario and mov.mov_estado not in ('A'))
			order by fel_codigo_barra
                
		open m_cursor
		
		fetch next from m_cursor into @npe
		while @@FETCH_STATUS = 0 
		begin
			print '@npe: ' + cast(@npe as varchar(60))
			exec sp_insertar_pagos_x_carnet_estructurado @npe, 16, @referencia_pago
			fetch next from m_cursor into @npe
		end
		close m_cursor  
		deallocate m_cursor
	end

	if @opcion = 5 -- datos para envio de correo de la persona inscrita en seminario/diplomado
	begin
		-- exec dbo.sp_diplomados_payway @opcion = 5, @coddip = 1522, @codigo_usuario = 254180
		-- exec dbo.sp_diplomados_payway @opcion = 5, @coddip = 1523, @codigo_usuario = 254180
		-- exec dbo.sp_diplomados_payway @opcion = 5, @coddip = 1524, @codigo_usuario = 254180
		declare @url_comprobante_inscripcion varchar(1024) = ''
		
		declare @codhrm_ varchar(10), @codcil_ varchar(10)

		select @codhrm_ = hrm_codigo, @codcil_ = fea_codcil
		from dip_mdp_modulos_diplomado 
			inner join dip_fea_fechas_autorizadas on fea_codmdp = mdp_codigo 
			inner join dip_hrm_horarios on hrm_codfea = fea_codigo
			inner join dip_amd_alm_modulo on amd_codfea = fea_codigo and amd_codhrm = hrm_codigo
		where (amd_codper = @codigo_usuario or amd_codper_cuenta_original = @codigo_usuario)
			and mdp_coddip = @coddip

		set @url_comprobante_inscripcion = 
			'https://reportes.utec.edu.sv/reporte.aspx?reporte=rep_alm_diplomado_autoenroll&filas=NQ=='+
			'&campo0='+dbo.fx_encode_base64('1')+--codreg
			'&campo1='+dbo.fx_encode_base64(cast(@codigo_usuario as varchar(10)))+--codper
			'&campo2='+dbo.fx_encode_base64(@codhrm_)+--codhrm
			'&campo3='+dbo.fx_encode_base64('1')+--opcion
			'&campo4='+dbo.fx_encode_base64(cast(@codcil_ as varchar(10)))+--codcil
			'&tipo_archivo=P'
		--https://reportes.utec.edu.sv/reporte.aspx?reporte=rep_alm_diplomado&filas=NQ==&campo0=MQ==&campo1=MTMzMDYw&campo2=NjA4&campo3=MQ==&campo4=MA==&tipo_archivo=P

		select distinct dip_codigo, dip_nombre, p2.per_carnet, p.per_nombres_apellidos, p.per_email, 'https://office.com/' 'sitio_correo', 
			case when p2.per_correo_institucional = p.per_correo_institucional then concat(p.per_correo_institucional, ',', p.per_email) else concat(p2.per_correo_institucional, ',', p.per_correo_institucional, ',', p.per_email) end 'per_correo_institucional', 
			format(p.per_fecha_nac, 'ddMMyyyy') 'fecha_nacimiento', 
			format(dip_vigencia_desde, 'dd/MM/yyyy') dip_vigencia_desde, format(dip_vigencia_hasta, 'dd/MM/yyyy') dip_vigencia_hasta, dip_link_brochure,
			--dip_correos_responsables 'correo_responsable_diplomado'
			'fabio.ramos@utec.edu.sv' 'correo_responsable_diplomado',
			@url_comprobante_inscripcion 'url_comprobante_inscripcion',
			fac_nombre, dip_telefonos_responsables 'telefono_facultad', dip_necesita_cuenta_AD
		from ra_per_personas p
			inner join dip_ped_personas_dip on isnull(ped_codper_cuenta_original, ped_codper) = p.per_codigo and ped_coddip = @coddip
			left join ra_per_personas p2 on ped_codper = p2.per_codigo
			inner join dip_dip_diplomados on ped_coddip = dip_codigo

			join ra_fac_facultades on dip_codfac = fac_codigo
		where p.per_codigo = @codigo_usuario
	end

end

/****** Object:  StoredProcedure [dbo].[tal_GenerarDataTalonariosDiplomados_masivo]    Script Date: 18/4/2024 12:33:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2024-03-14 13:28:23.327>
	-- Description: <Genera la data de las boletas externos de diplomados>
	-- =============================================
	-- exec dbo.tal_GenerarDataTalonariosDiplomados_masivo @opcion = 1, @codcil_generar_boleta = 134, @codtad = 3, @codigo_usuario = 1, @coddip = 1503, @codupo = 1
	-- exec dbo.tal_GenerarDataTalonariosDiplomados_masivo @opcion = 1, @codcil_generar_boleta = 134, @codtad = 3, @coddip = 1524, @codupo = 42554
create or alter     PROCEDURE [dbo].[tal_GenerarDataTalonariosDiplomados_masivo]
	@opcion int = 0,
	@codcil_generar_boleta int = 0,
	@codtad int = 0,
	@codigo_usuario int = 0,
	@coddip int = 0,
	@codupo int = 0
as
begin

	set nocount on
	set dateformat dmy

	declare @cantidad int
	
	declare @codusc int, @codper int
	select @codusc = upo_codusc, @codper = upo_codper from upo_user_pago_online where upo_id = @codupo
	--select @codusc '@codusc', @codper 'codper'
	print '@codper ' + cast(isnull(@codper, '') as varchar(30))
	print '@codusc ' + cast(isnull(@codusc, '') as varchar(30))

	if (@opcion = 1 or @opcion = 2)
	begin
	
		print 'Alumno no posee mensualidad especial'
		set @codigo_usuario = case when @codusc is not null then @codusc else @codper end

		declare @mtipo int, @mglobal int --,@cod_arancel1 int, @cod_arancel2 int
		--con pagos o sin pagos
		set @mtipo = 0 
		set @mglobal = 0
		set @mtipo =0

		declare @corr int
		select @corr = isnull(max(art_codigo),0) from col_art_archivo_tal_mora

		Declare @Datos TABLE (
			[per_codigo] [int] NOT NULL, [per_carnet] [varchar](50) NOT NULL, [ciclo] [int] NULL, [pla_alias_carrera] [varchar](100) NULL, [per_nombres_apellidos] [varchar](201) NOT NULL, [c415] [varchar](3) NOT NULL, [cc415] [varchar](13) NOT NULL, [c3902] [varchar](4) NOT NULL, [cc3902] [varchar](10) NULL, [c96] [varchar](2) NOT NULL, [cc96] [varchar](34) NULL, [c8020] [varchar](4) NOT NULL, [cc8020] [varchar](72) NULL, [barra] [varchar](142) NULL, [NPE] [varchar](83) NULL, [c415M] [varchar](3) NOT NULL, [cc415M] [varchar](13) NOT NULL, [c3902M] [varchar](4) NOT NULL, [cc3902M] [varchar](10) NULL, [c96M] [varchar](2) NOT NULL, [cc96M] [varchar](34) NULL, [c8020M] [varchar](4) NOT NULL, [cc8020M] [varchar](72) NULL, [BARRA_MORA] [varchar](142) NULL, [NPE_MORA] [varchar](83) NULL, [tmo_valor] [numeric](19, 2) NULL, [fel_fecha] [datetime] NOT NULL, [tmo_arancel] [varchar](5) NULL, [fel_fecha_mora] [datetime] NOT NULL, [fel_codigo_barra] [int] NULL, [papeleria] [numeric](3, 2)  NULL, [tmo_valor_mora] [numeric](19, 2) NULL, [matricula] [numeric](18, 2) NULL, [mciclo] [varchar](62) NULL,				 cod_carrera nvarchar(4), codtmo_descuento int, monto_descuento numeric(19,2), monto_arancel_descuento numeric(18, 2) 
		)
		Declare @Datos2 TABLE (
			[art_codigo] [bigint] NULL, [fecha] [datetime] NOT NULL, [limite] [datetime] NULL, [per_codigo] [int] NOT NULL, [per_carnet] [varchar](50) NOT NULL, [ciclo] [int] NULL, [pla_alias_carrera] [varchar](100) NULL, [per_nombres_apellidos] [varchar](201) NOT NULL, [c415] [varchar](3) NOT NULL, [cc415] [varchar](13) NOT NULL, [c3902] [varchar](4) NOT NULL, [cc3902] [varchar](10) NULL, [c96] [varchar](2) NOT NULL, [cc96] [varchar](34) NULL, [c8020] [varchar](4) NOT NULL, [cc8020] [varchar](72) NULL, [barra] [varchar](142) NULL, [NPE] [varchar](83) NULL, [c415M] [varchar](3) NOT NULL, [cc415M] [varchar](13) NOT NULL, [c3902M] [varchar](4) NOT NULL, [cc3902M] [varchar](10) NULL, [c96M] [varchar](2) NOT NULL, [cc96M] [varchar](34) NULL, [c8020M] [varchar](4) NOT NULL, [cc8020M] [varchar](72) NULL, [BARRA_MORA] [varchar](142) NULL, [NPE_MORA] [varchar](83) NULL, [tmo_valor] [numeric](19, 2) NULL, [fel_fecha] [datetime] NOT NULL, [tmo_arancel] [varchar](5) NULL, [fel_fecha_mora] [datetime] NOT NULL, [fel_codigo_barra] [int] NULL, [papeleria] [numeric](3, 2)  NULL, [tmo_valor_mora] [numeric](19, 2) NULL, [matricula] [numeric](18, 2) NULL, [mciclo] [varchar](62) NULL 
		)

		declare @codvac int

		declare @abonos_dinamicos_o48 numeric(9, 2) = 0.00

		Insert Into @Datos (per_codigo, per_carnet, ciclo, pla_alias_carrera, per_nombres_apellidos, c415, cc415, c3902, cc3902, c96,
			cc96, c8020, cc8020, barra, NPE, c415M, cc415M, c3902M, cc3902M, c96M, cc96M, c8020M, cc8020M, BARRA_MORA, NPE_MORA, tmo_valor, fel_fecha, tmo_arancel,
			fel_fecha_mora, fel_codigo_barra, ---papeleria, 
			tmo_valor_mora, matricula, mciclo, cod_carrera, codtmo_descuento, monto_descuento, monto_arancel_descuento)

		select codigo_usuario , per_carnet, ciclo,
			pla_alias_carrera, per_nombres_apellidos,
			c415,cc415,c3902,cc3902,c96,cc96,c8020,cc8020,
			c415+cc415+c3902+cc3902+c96+cc96+c8020+cc8020 barra,
			npe+dbo.fn_verificador_npe(NPE) NPE,

			c415M,cc415M,c3902M,cc3902M,c96M,cc96M,c8020M,cc8020M,
			c415M+cc415M+c3902M+cc3902M+c96M+cc96M+c8020M+cc8020M BARRA_MORA,
			npe_mora+dbo.fn_verificador_npe(NPE_MORA) NPE_MORA,

			tmo_valor, fel_fecha,tmo_arancel,fecha_mora,fel_codigo_barra,--papeleria,
			CASE  WHEN fel_codigo_barra <= 2 THEN  tmo_valor_mora ELSE tmo_valor_mora END tmo_valor_mora,matricula, mciclo, substring(per_carnet,1,2) as carrera,
			codtmo_descuento, monto_descuento, monto_arancel_descuento
		from
			(
				select codigo_usuario, per_carnet, @codcil_generar_boleta ciclo,
				substring(pla_alias_carrera,1,100) pla_alias_carrera,per_nombres_apellidos,
				'415' c415, 
				'7419700003137' cc415,
				'3902' c3902,
				right('00000000'+cast(floor(CASE fel_codigo_barra WHEN 1 THEN fel_valor - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																	from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = codigo_usuario and abp_codcil =  @codcil_generar_boleta and abp_cuota = 0 and abp_codtmoAbono != 1490),0)
																		
																	- isnull(@abonos_dinamicos_o48, 0)

																		ELSE fel_valor END ) as varchar),8) + 
				right('00'+cast((CASE fel_codigo_barra WHEN 1 
															THEN fel_valor - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																	from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = codigo_usuario and abp_codcil =  @codcil_generar_boleta and abp_cuota = 0 and abp_codtmoAbono != 1490),0)
															ELSE fel_valor END  - floor(CASE fel_codigo_barra 
				WHEN 1 
					THEN fel_valor - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																	from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = codigo_usuario and abp_codcil =  @codcil_generar_boleta and abp_cuota = 0 and abp_codtmoAbono != 1490),0)
					ELSE fel_valor END )) as varchar),2) cc3902,	
				'96' c96,	
				cast(year(fel_fecha) as varchar)+right('00'+cast(month(fel_fecha) as varchar),2)+right('00'+cast(day(fel_fecha) as varchar),2) cc96,
				'8020' c8020,
				REPLICATE('0',10-len(cast(codigo_usuario as nvarchar(10)))) + cast(codigo_usuario as nvarchar(10)) +cast(fel_codigo_barra as varchar)+
				right('00'+cast(cil_codcic as varchar),2)+cast(cil_anio as varchar) cc8020,
				'0313'+right('0000'+cast(floor(CASE fel_codigo_barra WHEN 1 
																		THEN fel_valor - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																			from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = codigo_usuario and abp_codcil =  @codcil_generar_boleta and abp_cuota = 0 and abp_codtmoAbono != 1490),0)
																				
																			- isnull(@abonos_dinamicos_o48, 0)

																		ELSE fel_valor END ) as varchar),4) + 
				right('00'+cast((CASE fel_codigo_barra WHEN 1 
														THEN fel_valor - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																	from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = codigo_usuario and abp_codcil =  @codcil_generar_boleta and abp_cuota = 0 and abp_codtmoAbono != 1490),0) 
														ELSE fel_valor END  - floor(CASE fel_codigo_barra WHEN 1 
																											THEN fel_valor - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																													from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = codigo_usuario and abp_codcil =  @codcil_generar_boleta and abp_cuota = 0 and abp_codtmoAbono != 1490),0)
																											ELSE fel_valor END )) as varchar),2)+ 
				REPLICATE('0',10-len(cast(codigo_usuario as nvarchar(10)))) + cast(codigo_usuario as nvarchar(10)) + cast(fel_codigo_barra as varchar)+
				right('00'+cast(cil_codcic as varchar),2)+cast(cil_anio as varchar) NPE,
		----************************************************************************************************************************************************************
		---																		VALORES CON MORA
		----************************************************************************************************************************************************************
				'415' c415M, 
				'7419700003137' cc415M,
				'3902' c3902M,	
				right('00000000'+cast(floor(CASE fel_codigo_barra WHEN 1 
																		THEN fel_valor_mora - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																				from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = codigo_usuario and abp_codcil =  @codcil_generar_boleta and abp_cuota = 0 and abp_codtmoAbono != 1490),0) 
																		ELSE fel_valor_mora END ) as varchar),8) + 
				right('00'+cast((CASE fel_codigo_barra WHEN 1 
															THEN fel_valor_mora - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																	from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = codigo_usuario and abp_codcil =  @codcil_generar_boleta and abp_cuota = 0 and abp_codtmoAbono != 1490),0) 
															ELSE fel_valor_mora END  - floor(CASE fel_codigo_barra 
				WHEN 1 THEN fel_valor_mora - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																	from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = codigo_usuario and abp_codcil =  @codcil_generar_boleta and abp_cuota = 0 and abp_codtmoAbono != 1490),0)
						ELSE fel_valor_mora END )) as varchar),2) cc3902M,
				'96' c96M,
				cast(year(fel_fecha_mora) as varchar)+right('00'+cast(month(fel_fecha_mora) as varchar),2)+right('00'+cast(day(fel_fecha_mora) as varchar),2) cc96M,
				'8020' c8020M,
				REPLICATE('0',10-len(cast(codigo_usuario as nvarchar(10)))) + cast(codigo_usuario as nvarchar(10)) + cast(fel_codigo_barra as varchar)+
				right('00'+cast(cil_codcic as varchar),2)+cast(cil_anio as varchar) cc8020M,
				'0313'+right('0000'+cast(floor(CASE fel_codigo_barra WHEN 1 
																		THEN fel_valor_mora - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																				from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = codigo_usuario and abp_codcil =  @codcil_generar_boleta and abp_cuota = 0 and abp_codtmoAbono != 1490),0) 

																				- isnull(@abonos_dinamicos_o48, 0)


																		ELSE fel_valor_mora END ) as varchar),4) + 
				right('00'+cast((CASE fel_codigo_barra WHEN 1 
															THEN fel_valor_mora - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																	from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = codigo_usuario and abp_codcil =  @codcil_generar_boleta and abp_cuota = 0 and abp_codtmoAbono != 1490),0)

																		

															ELSE fel_valor_mora END  - floor(CASE fel_codigo_barra WHEN 1 
																														THEN fel_valor_mora - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																																from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = codigo_usuario and abp_codcil =  @codcil_generar_boleta and abp_cuota = 0 and abp_codtmoAbono != 1490),0)
																														ELSE fel_valor_mora END )) as varchar),2) + 
				REPLICATE('0',10-len(cast(codigo_usuario as nvarchar(10)))) + cast(codigo_usuario as nvarchar(10)) 
				+cast(fel_codigo_barra as varchar)+
				right('00'+cast(cil_codcic as varchar),2)+cast(cil_anio as varchar) NPE_MORA,
				CASE fel_codigo_barra WHEN 1 
											THEN fel_valor - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																	from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = codigo_usuario and abp_codcil =  @codcil_generar_boleta and abp_cuota = 0 and abp_codtmoAbono != 1490),0)
											ELSE fel_valor END tmo_valor 
				,fel_fecha,tmo_arancel,fel_fecha_mora fecha_mora,fel_codigo_barra,
				--CASE fel_codigo_barra WHEN 1 THEN  5.75 ELSE 0.0 END papeleria,
				CASE fel_codigo_barra WHEN 1 
											THEN fel_valor_mora - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																	from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = codigo_usuario and abp_codcil =  @codcil_generar_boleta and abp_cuota = 0 and abp_codtmoAbono != 1490),0) 
											ELSE fel_valor_mora END tmo_valor_mora, 
				CASE fel_codigo_barra WHEN 1 
											THEN  fel_valor - isnull((select isnull(abp_montoAbono,0) + isnull(abp_montoDescuento,0) 
																	from col_abp_anticipo_boleta_pago where abp_codcil = fel_codcil and abp_codper = codigo_usuario and abp_codcil =  @codcil_generar_boleta and abp_cuota = 0 and abp_codtmoAbono != 1490),0) 
											ELSE 0.0 END matricula,
				'0'+cast(cil_codcic as varchar)+'-'+cast(cil_anio as varchar) mciclo,
					NULL as codtmo_descuento, NULL as monto_descuento, NULL as monto_arancel_descuento
				from (
				select isnull(per_codigo, usc.usc_codigo) 'codigo_usuario', isnull(per_carnet, '') 'per_carnet', fel_codcil, fel_valor_mora, fel_codigo_barra, fel_fecha_mora, tmo_arancel, fel_valor, cil_codcic, cil_anio, fel_fecha,
					isnull(per_nombres_apellidos, concat(usc.usc_nombres, ' ', usc.usc_apellidos)) 'per_nombres_apellidos', dip_nombre 'pla_alias_carrera'
				from (
						select usc_codigo, usc_nombres, usc_apellidos, usc_usuario from usc_user_datos_sin_carnet where usc_codigo = @codusc
						union all
						select per_codigo, per_nombres_apellidos, per_apellidos, '' 'usc_usuario' from ra_per_personas where per_codigo = @codper
					) usc
					join col_fel_fechas_limite on fel_codcil = @codcil_generar_boleta and fel_codtad = @codtad
					join col_tmo_tipo_movimiento on tmo_codigo = fel_codtmo
					join ra_cil_ciclo on cil_codigo = fel_codcil
					join user_pago_online on upo_id = @codupo--usc.usc_usuario
					inner join dip_dip_diplomados on dip_codigo = @coddip and fel_coddip = @coddip
					left join ra_per_personas on upo_codper = per_codigo
					left join ra_alc_alumnos_carrera on alc_codper = per_codigo
					left join ra_pla_planes on pla_codigo = alc_codpla
					left join ra_car_carreras on car_codigo = pla_codcar
				where usc_codigo = @codigo_usuario 
					--and @codigo_usuario not in (select distinct per_codigo from col_art_archivo_tal_mora where (per_codigo = @codigo_usuario or art_codusc = @codigo_usuario) and ciclo = @codcil_generar_boleta and art_coddip = @coddip)
				) t
			) q

		if @opcion = 1
		begin
			select per_codigo, per_carnet, ciclo, pla_alias_carrera, per_nombres_apellidos, barra, barra_mora, npe, npe_mora, d.tmo_valor, fel_fecha, d.tmo_arancel, fel_fecha_mora,
				fel_codigo_barra, tmo_valor_mora, matricula, mciclo, tmo_descripcion, fel_codigo_barra 'cpd_orden'
			from @Datos d
				inner join col_tmo_tipo_movimiento t on d.tmo_arancel = t.tmo_arancel
		end

		if @opcion = 2
		begin
			Insert into col_art_archivo_tal_mora 
			(per_codigo, per_carnet, ciclo, pla_alias_carrera, per_nombres_apellidos, barra, NPE, BARRA_MORA, NPE_MORA, tmo_valor, fel_fecha, tmo_arancel, fel_fecha_mora, fel_codigo_barra, tmo_valor_mora, matricula, mciclo, codtmo_descuento, monto_descuento, monto_arancel_descuento, art_coddip)
			select per_codigo, per_carnet, ciclo, pla_alias_carrera, per_nombres_apellidos, barra, NPE, BARRA_MORA, NPE_MORA, tmo_valor, fel_fecha, tmo_arancel, fel_fecha_mora, fel_codigo_barra, tmo_valor_mora, matricula, mciclo, codtmo_descuento, monto_descuento, monto_arancel_descuento, @coddip
			from @Datos d
			where d.per_codigo not in (select a.per_codigo from col_art_archivo_tal_mora a where ciclo = @codcil_generar_boleta and art_coddip = @coddip)
		end
	end

END
go

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_estudiantes_diplomado]    Script Date: 16/4/2024 10:58:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2024-04-09 10:59:39.590>
	-- Description: <Devuelve la data de los pagos de alumnos de diplomados>
	-- =============================================
	-- exec dbo.rep_estudiantes_diplomado 8, 1524
ALTER procedure [dbo].[rep_estudiantes_diplomado]
	@fac_codigo int,
	@dip_codigo int--0: Todos, N: ese diplomado en especifico
as 
begin

	select distinct fac_codigo, fac_nombre, dip_codigo, dip_nombre,
		per_codigo, per_carnet, per_nombres_apellidos, isnull(sum([0]), 0) as 'matricula', isnull(sum([1]), 0) as 'cuota_1', isnull(sum([2]), 0) as 'cuota_2',
		isnull(sum([3]), 0) as 'cuota_3', isnull(sum([4]), 0) as 'cuota_4', isnull(sum([5]), 0) as 'cuota_5', isnull(sum([6]), 0) as 'cuota_6', isnull(sum([7]), 0) as 'cuota_7', 
		isnull(sum([8]), 0) as 'cuota_8', isnull(sum([9]), 0) as 'cuota_9', isnull(sum([10]), 0) as 'cuota_10', isnull(total_pagos, 0) total_pagos, isnull(cuota_pago_actual, 0) cuota_pago_actual, 
		fel_fecha, 
		npe_pago, correo
	from (
		select fac_codigo, fac_nombre, dip_codigo, dip_nombre, per_codigo, per_carnet, per_nombres_apellidos, fel_codigo_barra, pagado, 
		total_pagos, cuota_pago_actual, fel_fecha, npe_pago, correo
		from (
			select fac_codigo, fac_nombre, dip_codigo, dip.dip_nombre,
				per.per_codigo, per.per_carnet,per.per_nombres_apellidos, art.fel_codigo_barra, 
				(select count(1) from col_mov_movimientos mov where mov.mov_codper = per.per_codigo and mov.mov_npe = art.NPE and mov.mov_estado not in ('A')) 'pagado', 
				(select max(fel_codigo_barra) from col_art_archivo_tal_mora art2 where art2.per_codigo = art.per_codigo and art2.art_coddip = art.art_coddip) total_pagos, 
				fel.fel_codigo_barra cuota_pago_actual, fel.fel_fecha,

				(select art2.NPE from col_art_archivo_tal_mora art2 where art2.per_codigo = art.per_codigo and art2.art_coddip = art.art_coddip and art2.fel_codigo_barra = fel.fel_codigo_barra) npe_pago,
				per_email 'correo'
				--concat(per_email, ',', per_correo_institucional) 'correo'
			from dip_ped_personas_dip ped
				inner join ra_per_personas per on (/*per_codigo = ped.ped_codper or */ped.ped_codper_cuenta_original = per_codigo)
				inner join dip_dip_diplomados dip on dip_codigo= ped_coddip
				inner join dr_facultades fac on fac_codigo = dip_codfac

				left join col_art_archivo_tal_mora art on (art.per_codigo = per.per_codigo or art.per_codigo = ped.ped_codper_cuenta_original) and art_coddip = dip_codigo

				left join col_fel_fechas_limite fel on fel.fel_codigo = (select top 1 fel2.fel_codigo from col_fel_fechas_limite fel2 where fel2.fel_coddip = art.art_coddip and fel2.fel_codtad = 3 and GETDATE() between DATEADD(d, -10, fel2.fel_Fecha) and fel2.fel_Fecha order by fel2.fel_codigo_barra desc)
			where dip_codfac = @fac_codigo and dip_codigo = case when @dip_codigo = 0 then dip_codigo else @dip_codigo end
		) t2
	) l
	pivot (
		sum(pagado)
		for fel_codigo_barra in ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10])
	) as pivo
	group by fac_codigo, fac_nombre, dip_codigo, dip_nombre, per_codigo, per_carnet, per_nombres_apellidos, total_pagos, cuota_pago_actual, fel_fecha, npe_pago, correo
	order by dip_nombre, per_nombres_apellidos

end
go





USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_insertar_pagos_x_carnet_estructurado]    Script Date: 16/4/2024 10:59:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	-- =============================================
	-- Author:      <>
	-- Create date: <>
	-- Last modify: <Fabio, 2021-05-25 15:13:11.367, se agrego insert a BD Rinnovo>
	-- Description: <Inserta los pagos de banco en linea>
	-- =============================================
	-- exec sp_insertar_pagos_x_carnet_estructurado  '0313006500000025336310120244', 16, 'xxssxxxsxxx'
ALTER procedure [dbo].[sp_insertar_pagos_x_carnet_estructurado]
	@npe varchar(100),
	@tipo int,
	@referencia varchar(50)
as
begin
	set dateformat dmy

	declare @IdGeneradoPreviaPagoOnLine int	
	set @npe = replace(@npe, ' ', '')
	declare @codper_previo int
	select @codper_previo = cast(substring(@npe,11,10) as int) --	El codper inicia en la posicion 11 del npe
	
	declare @len int, @npe2 varchar(100)
	select @len = isnull(len(@npe), 0)
	print '@npe len: ' +cast(@len as varchar(10))
	if @len > 28 --Es BARRA el parametro @npe
	begin
		print 'se ingreso el codigo de BARRA'
		select @npe2 = dao_npe from col_dao_data_otros_aranceles where dao_barra = @npe
		if isnull(@npe2, 0) <> 0
			set @npe = @npe2
	end
	--print '@barra: ' + cast(@barra as varchar(66))

	declare @arancel_especial int = 0, @npe_original varchar(80) = @npe
	if exists (select 1 from col_dao_data_otros_aranceles where dao_npe = @npe)
	begin
		print '****es arancel especial****'
		set @arancel_especial = 1
	end
	------------- Agregado para corroborar intentos de pago --------------------
    ------------------------------ Inicio --------------------------------------
	declare @carnet_previa nvarchar(15), @carnet nvarchar(15), @per_tipo nvarchar(10)
			
	print 'Verificando el tipo de estudiante'

	-- select @carnet_previa = substring(@npe,11,2) + '-' + substring(@npe,13,4) + '-' + substring(@npe,17,4)  
	select @carnet_previa = per_carnet,
		@per_tipo = per_tipo
	from ra_per_personas 
	where per_codigo = @codper_previo
	
	set @carnet = @carnet_previa

    insert into previa_pago_online (ppo_carnet, ppo_npe, ppo_tipo)
    values(@carnet_previa, @npe, @tipo)

	set @IdGeneradoPreviaPagoOnLine = scope_identity()
	print '@IdGeneradoPreviaPagoOnLine : ' + cast(@IdGeneradoPreviaPagoOnLine as nvarchar(10))
	print '-----------------------------'
    -------------------------------- Fin ---------------------------------------
    ------------- Agregado para corroborar intentos de pago --------------------


	declare @MontoPagado float, @codper_encontrado int
	set @MontoPagado = 0
	set @codper_encontrado = 0
	declare @Mensaje nvarchar(50)

	declare @alumno_encontrado tinyint
	set @alumno_encontrado = 0
	declare @CorrelativoGenerado int
	set @CorrelativoGenerado = 0

	declare @npe_valido int
	set @npe_valido = 0

	declare @portafolio_tecnicos_pre float
	set @portafolio_tecnicos_pre = 0
	
	declare @npe_mas_antiguo nvarchar(100)
	--select @carnet = substring(@npe,11,2) + '-' + substring(@npe,13,4) + '-' + substring(@npe,17,4)  

	

	-- Tabla donde se obtiene el NPE mas antiguo, para evitar que el estudiante pague cuotas "salteadas"
	declare @temp table (
		alumno varchar(150),
		carnet varchar(20),
		carrera varchar(150),
		npe nvarchar(50),
		monto varchar(15),
		descripcion varchar(250),
		estado varchar(2),
		tmo_arancel nvarchar(10),
		fel_fecha_mora nvarchar(10),
		ciclo int,
		mciclo nvarchar(10)
	)
	insert into @temp 
	exec sp_consulta_pago_x_carnet_estructurado 2, @carnet

	



	BEGIN TRANSACTION -- O solo BEGIN TRAN
	BEGIN TRY
		
		print 'NPE Ingresado : ' + @npe
		declare @es_npe_diplomado int
		select @es_npe_diplomado = count(1) from col_art_archivo_tal_mora where NPE = @npe and art_coddip is not null
		if @es_npe_diplomado > 0
		begin
			declare @codmov_ int, @coddmo_ int, @codper_ int, @coddip_ int, @codcil_ int
			select @codmov_ = max(mov_codigo) + 1 from col_mov_movimientos
			declare @tmo_descripcion_ varchar(500), @mov_usario_ varchar(500), @mov_codban_ varchar(10), @pal_codigo_ varchar(10)
			select @codper_ = per_codigo, @coddip_ = art_coddip, @codcil_ = ciclo from col_art_archivo_tal_mora where NPE = @npe and art_coddip is not null
			select @tmo_descripcion_ = pal_descripcion_pago, @mov_usario_ = pal_usuario, @mov_codban_ = pal_banco, @pal_codigo_ = pal_codigo from col_pal_pagos_linea where pal_codigo = @tipo
			
			if not exists (select 1 from col_mov_movimientos where mov_codper = @codper_ and mov_estado not in ('A') and mov_npe = @npe)
			begin
				insert into col_mov_movimientos (mov_codreg, mov_codigo, mov_recibo, mov_fecha, mov_codper, mov_codcil, mov_descripcion, 
				mov_tipo_pago, mov_cheque, mov_estado, mov_tarjeta, mov_usuario, mov_fecha_registro, mov_usuario_anula, mov_fecha_anula, 
				mov_codmod, mov_historia, mov_tipo, mov_codban, mov_forma_pago, mov_coddip, mov_codmdp, mov_codfea, mov_lote, 
				mov_fecha_cobro, mov_cliente, mov_codfac, mov_puntoxpress, mov_recibo_puntoxpress, mov_fecha_real_pago, mov_paga_estudiante, 
				mov_npe, mov_co016, mov_fp017, mov_referencia_pos)
			
				select 1, @codmov_, 0, cast(getdate() as date), @codper_, art.ciclo, @tmo_descripcion_, 'B', '', 'I', '', @mov_usario_, GETDATE(), null, null,
					0, 'N', 'F', @mov_codban_, 'E', art_coddip, 0, 0, NULL,
					getdate(), NULL, NULL, @pal_codigo_, @referencia, getdate(), null,
					NPE, 1, '05', @referencia
				from col_art_archivo_tal_mora art where art.NPE = @npe
			
				select @coddmo_ = max(dmo_codigo) + 1 from col_dmo_det_mov
			
				if not exists (select 1 from col_mov_movimientos inner join col_dmo_det_mov on dmo_codmov = mov_codigo where mov_codper = @codper_ and mov_coddip = @coddip_ and dmo_codtmo = 162/*c-30*/ and dmo_codcil = @codcil_ and mov_estado not in ('A'))
				begin
					print 'No tiene el C-30 se inserta'
					insert into col_dmo_det_mov (dmo_codreg, dmo_codmov, dmo_codigo, dmo_codtmo, dmo_cantidad, dmo_valor, dmo_codmat, dmo_iva, 
					dmo_fecha_registro, dmo_descuento, dmo_mes, dmo_codcil, dmo_cargo, dmo_abono, dmo_eval, dmo_descripcion, dmo_valor_no_sujeto)
					select 1, @codmov_, @coddmo_,  162 tmo_codigo, 1, sum(art.tmo_valor), '', 0, getdate(), 0, 0, ciclo, sum(art.tmo_valor), 0, 0, null, null
					from col_art_archivo_tal_mora art 
						inner join col_tmo_tipo_movimiento tmo on art.tmo_arancel = tmo.tmo_arancel
					where art.per_codigo = @codper_ and art.art_coddip = @coddip_ and ciclo = @codcil_
					group by ciclo
				end

				select @coddmo_ = max(dmo_codigo) + 1 from col_dmo_det_mov

				insert into col_dmo_det_mov (dmo_codreg, dmo_codmov, dmo_codigo, dmo_codtmo, dmo_cantidad, dmo_valor, dmo_codmat, dmo_iva, 
				dmo_fecha_registro, dmo_descuento, dmo_mes, dmo_codcil, dmo_cargo, dmo_abono, dmo_eval, dmo_descripcion, dmo_valor_no_sujeto)
				select 1, @codmov_, @coddmo_, tmo.tmo_codigo, 1, art.tmo_valor, '', 0, getdate(), 0, 0, ciclo, 0, art.tmo_valor, 0, null, null
				from col_art_archivo_tal_mora art 
					inner join col_tmo_tipo_movimiento tmo on art.tmo_arancel = tmo.tmo_arancel
				where art.NPE = @npe

				set @CorrelativoGenerado = @codmov_
			end
			else
			begin
				print 'El NPE ' + cast(@npe as varchar(50)) + ' ya esta cancelado'
				set @CorrelativoGenerado = 0
			end
			goto salto_por_diplomado
		end

		print '----- NPE Obtenido mas antiguo segun la fecha de pago : ' 
		select @npe_mas_antiguo = npe from @temp
		print @npe_mas_antiguo

		if @npe = @npe_mas_antiguo
		begin
			print 'Es el mismo NPE que quiere pagar el estudiante'
		end
		else
		begin
			set @npe = @npe_mas_antiguo
			print 'Es NPE es diferente, se asigno el mas antiguo para que se pague por el estudiante'
		end
		print '---------------------------------------------------------'

		if @arancel_especial = 1
		begin
			print 'goto saltar_validaciones'
			goto saltar_validaciones
		end

		/*Variables para el encabezado de factura */
			declare
			@mov_codreg int,
			@mov_codigo int,
			@mov_recibo int,
			@mov_codcil int,
			@mov_codper int,
			@mov_descripcion nvarchar(50),
			@mov_tipo_pago nvarchar(3),
			@mov_cheque nvarchar(20),
			@mov_estado nvarchar(3),
			@mov_tarjeta nvarchar(25),
			@mov_usuario nvarchar(30),
			@mov_codmod int,
			@mov_tipo nvarchar(3),
			@mov_historia nvarchar(3),
			@mov_codban int,
			@mov_forma_pago nvarchar(5),
			@mov_lote int, 
			@mov_puntoxpress int, 
			@mov_recibo_puntoxpress nvarchar(20),
			@mov_fecha datetime,
			@mov_fecha_registro datetime,
			@mov_fecha_cobro datetime

			declare @tmo_valor_mora float, @tmo_valor float

			set @mov_codreg = 1
			set @mov_recibo = 0
			set @mov_tipo_pago = 'B'
			set @mov_cheque = ''
			set @mov_estado = 'R'
			set @mov_tarjeta = ''
			set @mov_tipo = 'F'
			set @mov_forma_pago = 'E'
			set @mov_fecha = getdate()
			set @mov_fecha_registro = getdate()
			set @mov_fecha_cobro = getdate()
		/*Fin de variables para el encabezado de factura */


		/*Variables para el detalle de factura */
			declare
			@dmo_codreg int,
			@dmo_codmov int,
			@dmo_codigo int,
			@dmo_codtmo int,
			@dmo_cantidad int,
			@dmo_valor float,
			@dmo_codmat nvarchar(10),
			@dmo_iva float,
			@dmo_descuento float, 
			@dmo_mes int,
			@dmo_codcil int,
			@dmo_cargo float,
			@dmo_abono float,
			@dmo_eval int,
			@mov_coddip int,
			@mov_codfea int,
			@mov_codmdp int

			set @dmo_codreg = 1
			set @dmo_codmat = ''
			set @dmo_mes = 0
			set @dmo_eval = 0
			set @dmo_cantidad = 1
			set @dmo_descuento = 0
			set @mov_coddip = 0
			set @mov_codfea = 0
			set @mov_codmdp = 0
			set @mov_historia = 'N'
			set @mov_codmod = 0
		/*Fin de variables para el encabezado de factura */

		declare @corr_mov int
		declare @corr_det int
		declare @verificar_recargo_mora int
		set @verificar_recargo_mora = 0	--	0 no paga mora
		declare @monto float
		set @monto = 0
			-- *********************************************************************************************************************************
			-- Definimos quien hara los pagos segun configuracion de tabla
		declare @opcion tinyint

		declare @fecha_vencimiento datetime
		--set @referencia = '000003'
		--set @opcion = 1	--	Verifica si el pago se realizo
		set @opcion = 2	--	Inserta el pago

		--declare @validar_mora int
		--set @validar_mora = 0	--	0 = no paga mora, 1 = paga mora

		declare @paga_mora tinyint
		set @paga_mora = 0	--	0: no paga mora
		declare @dias_vencido int

		set dateformat dmy

		declare @usuario varchar(200), 
			@banco int, @pal_codigo int,
		@descripcion varchar(200)
	
		select	@usuario = pal_usuario, 
				@banco = pal_banco, 
				@descripcion = pal_descripcion_pago, 
				@pal_codigo = pal_codigo
		from col_pal_pagos_linea
		where pal_codigo = @tipo
		set @mov_codban = @banco
		--select	*
		--from col_pal_pagos_linea
		--where pal_codigo = @tipo
		declare @lote nvarchar(10)

		select @lote = tit_lote
		from col_tit_tiraje
		where tit_tpodoc = 'F'
		and tit_mes = month(getdate())
		and tit_anio = year(getdate())
		and tit_codreg = 1 and tit_estado = 1


		--set @npe = '0313012000410230201600120178'
		--set @npe = '0313010000430272201630120173'
		 --set @npe = '0313010000430272201640120171'
		 --set @npe = '0313012000000268031610220161'
		--set @npe = '0313012000000242031610220162'
		--set @npe = '0313010000000270031670220168'
		--set @npe = '0313007100311996201060120174'
		--set @npe = '0313012000115749199990120171'  -- pre especialidad
		--set @npe = '0313011075600687200510120175' -- pre tecnico DISENIO
		--set @npe = '0313010000000123031730120175' -- posgrado
		--set @npe = '0313010000000123031720120177'-- posgrado
		--set @npe = '0313007500293126201670220173' --	pregrado guillermo

		declare @corr int, @cil_codigo int, @per_codigo int
		declare @codper int, @codtmo int, @codcil int, @origen int, @codvac int
		declare @carrera nvarchar(100), @arancel_beca nvarchar(10), @nombre nvarchar(100), @descripcion_arancel nvarchar(100), 
			@npe_sin_mora nvarchar(75), @npe_con_mora nvarchar(75)
		declare @fecha_sin_mora DATE, @fecha_con_mora DATE, @monto_con_mora float, @monto_sin_mora float

		declare @DatosPago table (alumno nvarchar(80), carnet nvarchar(15), carrera nvarchar(125), npe nvarchar(30), monto float, descripcion nvarchar(125), estado int)

		declare @codtmo_descuento int, @monto_descuento float, @monto_arancel_descuento float 
		declare @pago_realizado int
		set @pago_realizado = 0

		declare @verificar_cuota_pagada int	--	Almacena si la cuota se encuentra pagada
		set @verificar_cuota_pagada = 0
		declare @arancel nvarchar(10)
		declare @TipoEstudiante nvarchar(50)
		set @codper = @codper_previo

		if (@per_tipo = 'M')
		begin
			print 'Alumno es de MAESTRIAS'
			set @TipoEstudiante = 'Maestrias'
			if exists(select 1 from col_art_archivo_tal_mae_mora where npe = @npe or npe_mora = @npe)
			begin
				select @codper = data.per_codigo, @codtmo = tmo.tmo_codigo, @arancel = tmo.tmo_arancel, @codcil = data.ciclo, @carnet = data.per_carnet,
					@carrera = data.pla_alias_carrera, @nombre = data.per_nombres_apellidos, @monto_con_mora = data.cuota_pagar_mora,
					@monto_sin_mora = data.cuota_pagar, @fecha_sin_mora = data.fel_fecha, @fecha_con_mora = data.fel_fecha_mora, @descripcion_arancel = tmo.tmo_descripcion,
					@npe_sin_mora = npe, @npe_con_mora = npe_mora, @origen = origen, @arancel_beca = isnull(tmo_arancel_beca,'-1'), @codvac = isnull(fel_codvac,-1),
					@tmo_valor = data.tmo_valor, @tmo_valor_mora = data.tmo_valor_mora, 
					@codtmo_descuento = isnull(codtmo_descuento,0), @monto_descuento = isnull(monto_descuento, 0), @monto_arancel_descuento = isnull(monto_arancel_descuento, 0)
				from col_art_archivo_tal_mae_mora as data inner join col_tmo_tipo_movimiento as tmo on 
					tmo.tmo_arancel = data.tmo_arancel
				where npe = @npe or npe_mora = @npe
				set @npe_valido = 1
			end	--	if exists(select 1 from col_art_archivo_tal_mae_mora where npe = @npe or npe_mora = @npe)
		end	--	if (@per_tipo = 'M')

		if (@per_tipo = 'O') or (@per_tipo = 'CE')
		begin
			if @per_tipo = 'O'
			begin
				set @TipoEstudiante = 'POST GRADOS de MAESTRIAS'
			end
			if @per_tipo = 'CE'
			begin
				set @TipoEstudiante = 'CURSO ESPECIALIZADO de MAESTRIAS'
			end

			if exists(select 1 from col_art_archivo_tal_mae_mora where npe = @npe or npe_mora = @npe)
			begin
				select @codper = data.per_codigo, @codtmo = tmo.tmo_codigo, @arancel = tmo.tmo_arancel, @codcil = data.ciclo, @carnet = data.per_carnet,
					@carrera = data.pla_alias_carrera, @nombre = data.per_nombres_apellidos, @monto_con_mora = data.cuota_pagar_mora,
					@monto_sin_mora = data.cuota_pagar, @fecha_sin_mora = data.fel_fecha, @fecha_con_mora = data.fel_fecha_mora, @descripcion_arancel = tmo.tmo_descripcion,
					@npe_sin_mora = npe, @npe_con_mora = npe_mora, @origen = -1, @arancel_beca = '-1', @codvac = -1,
					@tmo_valor = data.tmo_valor, @tmo_valor_mora = data.tmo_valor_mora
				from col_art_archivo_tal_mae_mora as data inner join col_tmo_tipo_movimiento as tmo on 
					tmo.tmo_arancel = data.tmo_arancel
				where npe = @npe or npe_mora = @npe
				set @npe_valido = 1
			end	--	if exists(select 1 from col_art_archivo_tal_mae_mora where npe = @npe or npe_mora = @npe)
		end	--	if (@per_tipo = 'O') or (@per_tipo = 'CE')
		
		if (@per_tipo = 'U' or exists (select 1 from dip_ped_personas_dip where ped_codper = @codper))
		begin
			print 'Alumno es de PRE-GRADO o diplomados/seminarios'
	
			if exists(select 1 from col_art_archivo_tal_mora where npe = @npe or npe_mora = @npe)
			begin
				set @npe_valido = 1
				set @alumno_encontrado = 1
				set @TipoEstudiante = 'PRE GRADO'
				select @codper = data.per_codigo, @codtmo = tmo.tmo_codigo, @arancel = tmo.tmo_arancel, @codcil = data.ciclo, @carnet = data.per_carnet,
					@carrera = data.pla_alias_carrera, @nombre = data.per_nombres_apellidos, @monto_con_mora = data.tmo_valor_mora,
					@monto_sin_mora = data.tmo_valor, @fecha_sin_mora = data.fel_fecha, @fecha_con_mora = data.fel_fecha_mora, @descripcion_arancel = tmo.tmo_descripcion,
					@npe_sin_mora = npe, @npe_con_mora = npe_mora, @origen = -1, @arancel_beca = '-1', @codvac = -1,
					@tmo_valor = data.tmo_valor, @tmo_valor_mora = data.tmo_valor_mora, 
					@codtmo_descuento = isnull(codtmo_descuento,-1), @monto_descuento = monto_descuento, @monto_arancel_descuento = monto_arancel_descuento
				from col_art_archivo_tal_mora as data inner join col_tmo_tipo_movimiento as tmo on 
					tmo.tmo_arancel = data.tmo_arancel
				where npe = @npe or npe_mora = @npe
			end	--	if exists(select 1 from col_art_archivo_tal_mora where npe = @npe or npe_mora = @npe)

			if @alumno_encontrado = 0
			begin
				if exists(select 1 from col_art_archivo_tal_preesp_mora where npe = @npe or npe_mora = @npe)
				begin
					set @npe_valido = 1
					set @alumno_encontrado = 1
					set @TipoEstudiante = 'PRE ESPECIALIDAD CARRERA'
					select @codper = data.per_codigo, @codtmo = tmo.tmo_codigo, @arancel = tmo.tmo_arancel, @codcil = data.ciclo, @carnet = data.per_carnet,
						@carrera = data.pla_alias_carrera, @nombre = data.per_nombres_apellidos, @monto_con_mora = data.tmo_valor_mora,
						@monto_sin_mora = data.tmo_valor, @fecha_sin_mora = data.fel_fecha, @fecha_con_mora = data.fel_fecha_mora, @descripcion_arancel = tmo.tmo_descripcion,
						@npe_sin_mora = npe, @npe_con_mora = npe_mora, @origen = -1, @arancel_beca = '-1', @codvac = -1,
						@tmo_valor = data.tmo_valor, @tmo_valor_mora = data.tmo_valor_mora,
						@codtmo_descuento = isnull(codtmo_descuento,-1), @monto_descuento = monto_descuento, @monto_arancel_descuento = monto_arancel_descuento
					from col_art_archivo_tal_preesp_mora as data inner join col_tmo_tipo_movimiento as tmo on 
						tmo.tmo_arancel = data.tmo_arancel
					where npe = @npe or npe_mora = @npe
				end	--	if exists(select 1 from col_art_archivo_tal_preesp_mora where npe = @npe or npe_mora = @npe)
			end	--	if @alumno_encontrado = 0

			if @alumno_encontrado = 0
			begin
				if exists(select 1 from col_art_archivo_tal_proc_grad_tec_dise_mora where npe = @npe or npe_mora = @npe)
				begin
					set @npe_valido = 1
					set @alumno_encontrado = 1
					set @TipoEstudiante = 'PRE TECNICO DE CARRERA DE DISENIO'
					select @codper = data.per_codigo, @codtmo = tmo.tmo_codigo, @arancel = tmo.tmo_arancel, @codcil = data.ciclo, @carnet = data.per_carnet,
						@carrera = data.pla_alias_carrera, @nombre = data.per_nombres_apellidos, @monto_con_mora = data.tmo_valor_mora,
						@monto_sin_mora = data.tmo_valor, @fecha_sin_mora = data.fel_fecha, @fecha_con_mora = data.fel_fecha_mora , @descripcion_arancel = tmo.tmo_descripcion,
						@npe_sin_mora = npe, @npe_con_mora = npe_mora, @origen = -1, @arancel_beca = '-1', @codvac = -1,
						@tmo_valor = data.tmo_valor, @tmo_valor_mora = data.tmo_valor_mora,

						@portafolio_tecnicos_pre = isnull(portafolio,0)
					from col_art_archivo_tal_proc_grad_tec_dise_mora as data inner join col_tmo_tipo_movimiento as tmo on 
						tmo.tmo_arancel = data.tmo_arancel
					where npe = @npe or npe_mora = @npe
				end	--	if exists(select 1 from col_art_archivo_tal_proc_grad_tec_dise_mora where npe = @npe or npe_mora = @npe)
			end	--	if @alumno_encontrado = 0		

			if @alumno_encontrado = 0
			begin
				if exists(select 1 from col_art_archivo_tal_proc_grad_tec_mora where npe = @npe or npe_mora = @npe)
				begin
					set @npe_valido = 1
					set @alumno_encontrado = 1
					set @TipoEstudiante = 'PRE TECNICO DE CARRERA diferente de disenio'
					select @codper = data.per_codigo, @codtmo = tmo.tmo_codigo, @arancel = tmo.tmo_arancel, @codcil = data.ciclo, @carnet = data.per_carnet,
						@carrera = data.pla_alias_carrera, @nombre = data.per_nombres_apellidos, @monto_con_mora = data.tmo_valor_mora,
						@monto_sin_mora = data.tmo_valor, @fecha_sin_mora = data.fel_fecha, @fecha_con_mora = data.fel_fecha_mora, @descripcion_arancel = tmo.tmo_descripcion,
						@npe_sin_mora = npe, @npe_con_mora = npe_mora, @origen = -1, @arancel_beca = '-1', @codvac = -1,
						@tmo_valor = data.tmo_valor, @tmo_valor_mora = data.tmo_valor_mora,

						@portafolio_tecnicos_pre = 0
					from col_art_archivo_tal_proc_grad_tec_mora as data inner join col_tmo_tipo_movimiento as tmo on 
						tmo.tmo_arancel = data.tmo_arancel
					where npe = @npe or npe_mora = @npe
				end	--	if exists(select 1 from col_art_archivo_tal_proc_grad_tec_dise_mora where npe = @npe or npe_mora = @npe)
			end	--	if @alumno_encontrado = 0	

			--select top 3 * from col_art_archivo_tal_mora
		end
		--SELECT * FROM col_art_archivo_tal_mora where ciclo = 116 and per_carnet = '25-0713-2016'
		--SELECT tmo_valor, tmo_arancel, tmo_valor_mora, cuota_pagar, cuota_pagar_mora, tmo_arancel_beca 
		--FROM col_art_archivo_tal_mae_mora where ciclo = 116 and per_carnet = @carnet

		print '@codper : ' + cast(@codper as nvarchar(10))
		print '@carnet : ' + @carnet
		print '@codtmo : ' + cast(@codtmo as nvarchar(10))
		print '@codcil : ' + cast(@codcil as nvarchar(10))
		print '@arancel : ' + @arancel
		print '@arancel_beca : ' + @arancel_beca
		print '@nombre : ' + @nombre
		print '@monto_con_mora : ' + cast(@monto_con_mora as nvarchar(15))
		print '@monto_sin_mora : ' + cast(@monto_sin_mora as nvarchar(15))
		print '@fecha_sin_mora  : ' + cast(@fecha_sin_mora  as nvarchar(15))
		print '@fecha_con_mora  : ' + cast(@fecha_con_mora  as nvarchar(15))
		print '@descripcion_arancel  : ' + @descripcion_arancel
		print '@npe_sin_mora :' + @npe_sin_mora
		print '@npe_con_mora :' + @npe_con_mora
		print '@origen : ' + cast(@origen as nvarchar(4))
		print '@codvac : ' + cast(@codvac as nvarchar(4))
		print '@TipoEstudiante : ' + @TipoEstudiante
		--print '@per_tipo : ' + @per_tipo
		print '@codtmo_descuento : ' + cast(@codtmo_descuento as nvarchar(15)) 
		print '@monto_descuento : ' + cast(@monto_descuento as nvarchar(15)) 
		print '@monto_arancel_descuento : ' + cast(@monto_arancel_descuento as nvarchar(15)) 
		print '------------------------------------------'
		--select * from col_mov_movimientos inner join col_dmo_det_mov on mov_codigo = dmo_codmov where mov_codper = @codper and dmo_codcil = @codcil and dmo_codtmo = @codtmo and mov_estado <> 'A'
		
		if isnull(@codper,0) > 0
		begin
			print 'Se encontro el codper, por lo tanto se aplicara el pago'
			set @codper_encontrado = 1

			if exists(select 1 from col_mov_movimientos inner join col_dmo_det_mov on mov_codigo = dmo_codmov 
						where mov_codper = @codper and dmo_codcil = @codcil and dmo_codtmo = @codtmo and mov_estado <> 'A')
				and not exists (select 1 from dip_ped_personas_dip where ped_codper = @codper)--Y no exista en diplomados, porque ellos si pueden pagar varias veces el mismo arancel, 08/04/2024 11:37, Fabio
			begin
				print '....... El pago ya existe para el estudiante en el ciclo para el arancel respectivo'
				set @CorrelativoGenerado = 0
			end		--	if exists(select 1 from col_mov_movimientos inner join col_dmo_det_mov on mov_codigo = dmo_codmov where mov_codper = @codper and dmo_codcil = @codcil and dmo_codtmo = @codtmo and mov_estado <> 'A')
			else	--	if exists(select 1 from col_mov_movimientos inner join col_dmo_det_mov on mov_codigo = dmo_codmov where mov_codper = @codper and dmo_codcil = @codcil and dmo_codtmo = @codtmo and mov_estado <> 'A')
			begin
				print '...... El arancel no esta pagado .......'
				declare @codtmo_sinbeca int, @codtmo_conbeca int

				set @mov_puntoxpress = @tipo
				set @mov_recibo_puntoxpress = @referencia

				if (@per_tipo = 'M')
				begin
					if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Maestrias' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula')
					begin
						print 'ES ARANCEL DE Matricula de Maestrias'

						PRINT '*-Almacenando el encabezado de la factura'
						select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
						select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca

						select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
						--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

						/* Insertando el encabezado de la factura*/
						exec col_efpc_EncabezadoFacturaPagoCuotas 1, 
						--select 
							@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
							@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

						PRINT '*-FIN Almacenando el encabezado de la factura'
						/* Insertando el detalle de la factura*/
						/*Almacenando el arancel de la matricula */
						PRINT '**--Almacenando el arancel de la matricula'
						select @CorrelativoGenerado = @corr_mov -- max(mov_codigo) from col_mov_movimientos 
						--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress --and mov_codigo = @corr_mov and mov_lote = @mov_lote


						set @dmo_codtmo = @codtmo_sinbeca
						set @dmo_valor = @monto_con_mora
						set @dmo_iva = 0
						set @dmo_abono = @monto_con_mora
						set @dmo_cargo = 0

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						set @dmo_valor = @dmo_valor + @monto_arancel_descuento
						set @dmo_abono = @dmo_abono + @monto_arancel_descuento

						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						PRINT '**--FIN Almacenando el arancel de la matricula'

						/* Almacenando el arancel que tiene el cargo del ciclo */
						PRINT '***---Almacenando el cargo del ciclo'
						set @dmo_codtmo = 162
						set @dmo_valor = 0
						--set @dmo_cargo = 825.75
						set @dmo_abono = 0

						--select @dmo_cargo = vac_SaldoAlum from ra_vac_valor_cuotas where vac_codigo = @codvac
						select @dmo_cargo = sum(tmo_valor) + sum(ISNULL(monto_arancel_descuento, 0))
						from col_art_archivo_tal_mae_mora 
						where ciclo = @codcil and per_carnet = @carnet and origen = @origen -- and fel_codvac = @codvac

			
						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor


						if @monto_descuento = 0 and @codtmo_descuento >0 and @monto_arancel_descuento > 0
						begin
							print 'MAESTRIAS if @monto_descuento = 0 and @codtmo_descuento >0 and @monto_arancel_descuento > 0'
							
							set @dmo_codtmo = @codtmo_descuento
							set @dmo_valor = @monto_arancel_descuento * -1 								
							set @dmo_cargo = @dmo_valor
							set @dmo_abono = @dmo_valor

							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							-- select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							--set @MontoPagado = @MontoPagado + @dmo_valor															
						end

						PRINT '***---FIN Almacenando el cargo del ciclo'
					end	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Maestrias' and spaet_codigo = 0 and tmo_arancel = @arancel and spaet_tipo_evaluacion like '%Matr%' and are_tipoarancel like '%Mat%' )
					else	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Maestrias' and spaet_codigo = 0 and tmo_arancel = @arancel and spaet_tipo_evaluacion like '%Matr%' and are_tipoarancel like '%Mat%' )
					begin
						print 'No es arancel de Matricula de Maestrias, son cuotas'

						if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Maestrias' and spaet_codigo > 0 and tmo_arancel = @arancel and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Evalua%')	
						begin
							print 'Pago de segunda cuota en adelante se verifica que tiene que pagar '
							set @verificar_recargo_mora = 1
						end				
						else	--	if exists(select count(1) from vst_Aranceles_x_Evaluacion where tde_nombre = 'Maestrias' and spaet_codigo > 1 and tmo_arancel = @arancel and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Evalua%')	
						begin
							print 'PRIMERA CUOTA, ESTA NO PAGA ARANCEL DE RECARGO'
						end		--	
	
						PRINT '*-Almacenando el encabezado de la factura'
						select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
						select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca
			
						select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
						--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

						/* Insertando el encabezado de la factura*/
						exec col_efpc_EncabezadoFacturaPagoCuotas 1,
						--select 
							@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
							@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

						PRINT '*-FIN Almacenando el encabezado de la factura'
						/* Insertando el detalle de la factura*/
						/*Almacenando el arancel de la matricula */
						PRINT '**--Almacenando el arancel de la cuota'
						--select @CorrelativoGenerado = max(mov_codigo) from col_mov_movimientos 
						--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress --and mov_codigo = @corr_mov and mov_lote = @mov_lote
						set @CorrelativoGenerado = @corr_mov

						set @dmo_codtmo = @codtmo_sinbeca
						set @dmo_valor = @tmo_valor --@monto_con_mora
						set @dmo_iva = 0
						set @dmo_abono = @tmo_valor --@monto_con_mora
						set @dmo_cargo = 0

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						print '@dmo_codtmo: ' + cast (@dmo_codtmo as nvarchar(10))
						print 'Correlativo generado en el detalle de la factura MAES: ' + cast (@dmo_codigo as nvarchar(10))
						PRINT '**--FIN Almacenando el arancel de la cuota'

						if @arancel_beca = '-1'	--	no paga el descuento de un arancel de beca
						begin
							print 'no paga el descuento de un arancel de beca'
						end
						else	--	if @arancel_beca = '-1'	--	no paga el descuento de un arancel de beca
						begin
							if isnull(@arancel_beca,'') = '' or @arancel_beca = '0'
							begin
								print 'La cuota no posee arancel de beca, por lo tanto no se agrega otro registro en el detalle de la factura'
							end
							else	--	if isnull(@arancel_beca,'') = ''
							begin
							/* Almacenando el arancel que tiene el cargo del ciclo */
								PRINT '***---Almacenando el arancel del descuento de la beca'
								set @dmo_codtmo = @codtmo_conbeca
								set @dmo_valor = -1 * @monto_sin_mora
								set @dmo_iva = 0


								SELECT @dmo_valor = tmo_valor - cuota_pagar FROM col_art_archivo_tal_mae_mora 
								where ciclo = @codcil and per_carnet = @carnet and tmo_arancel = @arancel

								set @dmo_valor = @dmo_valor * -1
								set @dmo_abono = @dmo_valor
								set @dmo_cargo = @dmo_valor

								select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
								exec col_dfpc_DetalleFacturaPagoCuotas 1,
								--select 
								@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								set @MontoPagado = @MontoPagado + @dmo_valor
								PRINT '***---FIN Almacenando descuento de la beca MES'
							end		--	if isnull(@arancel_beca,'') = ''
						end	--	if @arancel_beca = '-1'	--	no paga el descuento de un arancel de beca
					end	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Maestrias' and spaet_codigo = 0 and tmo_arancel = @arancel)

					

				end	--	if (@per_tipo = 'M')
											--select 666643
				if @per_tipo = 'U' or @per_tipo = 'D'
				begin
					print 'Alumno de Pre grado'
					if @TipoEstudiante = 'PRE GRADO'
					begin
						if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREGRADO')
						begin
							print 'ES ARANCEL DE Matricula de Pre grado'
							PRINT '*-Almacenando el encabezado de la factura'
							select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
							select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca

							select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
							--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

							/* Insertando el encabezado de la factura*/
							exec col_efpc_EncabezadoFacturaPagoCuotas 1,
							--select 
								@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
								@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

							PRINT '*-FIN Almacenando el encabezado de la factura'
							/* Insertando el detalle de la factura*/
							/*Almacenando el arancel de la matricula */
							PRINT '**--Almacenando el arancel de la matricula'
							set @CorrelativoGenerado = @corr_mov --max(mov_codigo) from col_mov_movimientos 
							--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress --and mov_codigo = @corr_mov and mov_lote = @mov_lote

							set @dmo_codtmo = @codtmo_sinbeca
							set @dmo_valor = @monto_con_mora
							set @dmo_iva = 0
							set @dmo_abono = @monto_con_mora
							set @dmo_cargo = 0

							declare @dmo_codigo_agregar int
							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
							set @dmo_codigo_agregar = @dmo_codigo

							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
							PRINT '**--FIN Almacenando el arancel de la matricula'

							/* Almacenando el arancel que tiene el cargo del ciclo */
							PRINT '***---Almacenando el cargo del ciclo U'
							set @dmo_codtmo = 162
							set @dmo_valor = 0
							--set @dmo_cargo = 825.75
							set @dmo_abono = 0
														--select 666641

							--select @dmo_cargo = sum(vac_SaldoAlum) from ra_vac_valor_cuotas where vac_codigo = @codvac
							if exists (select 1 from ra_per_personas join col_detmen_detalle_tipo_mensualidad on per_codigo = detmen_codper where detmen_codcil = @codcil and per_carnet = @carnet)
							begin
								print 'Alumno posee descuento en las mensualidades de pregrado'
								select @dmo_cargo = sum(ISNUll(tmo_valor,0)) +sum(isnull(matricula,0))+ sum(isnull(monto_descuento,0))+ sum(isnull(monto_arancel_descuento,0))
									from col_art_archivo_tal_mora
								where ciclo = @codcil and per_carnet = @carnet /*and (isnull(monto_descuento,0) > 0 )*/ and fel_codigo_barra >= 2		--	Alumno posee descuento
								
							end
							else
							begin
								print 'Alumno no posee descuento en las mensualidades de pregrado'
								select @dmo_cargo = 
								sum(tmo_valor) + sum(isnull(monto_descuento,0)) + sum(matricula)
									from col_art_archivo_tal_mora
								where ciclo = @codcil and per_carnet = @carnet and isnull(monto_descuento,0) = 0  and fel_codigo_barra >= 2			--	Alumno no posee descuento
							end
							print '@dmo_cargo: ' + cast(@dmo_cargo as varchar)
							--select 66664
							select @dmo_cargo = matricula + @dmo_cargo
							from col_art_archivo_tal_mora
							where ciclo = @codcil and per_carnet = @carnet and fel_codigo_barra = 1

							--print '@dmo_cargo: ' + cast(@dmo_cargo as varchar(15))
							--select  @dmo_cargo
							--select * from ra_vac_valor_cuotas where vac_codigo = @codvac
							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
							
							if exists(select 1 from col_abp_anticipo_boleta_pago where abp_codper = @codper and abp_codcil = @codcil and abp_cuota = 0 and (abp_codtmoDescuento = 408 or abp_codtmoAbono = 3586 or abp_codtmoAbono = 1490))
							begin
							
								print '+++ El alumno esta en la tabla "col_abp_anticipo_boleta_pago"'
								declare @valor_tour_utec float
								declare @valor_anticipo_matricula float

								select @valor_tour_utec = isnull(abp_montoDescuento,0), --+ isnull(abp_montoAbono,0), 
										@dmo_codtmo = abp_codtmoDescuento
								from col_abp_anticipo_boleta_pago  
								where abp_codper = @codper and abp_codcil = @codcil and abp_codtmoDescuento in (408)  -- Arancel de tour utec

								select @valor_anticipo_matricula = isnull(abp_montoAbono,0)--, --+ isnull(abp_montoAbono,0), 
										--@dmo_codtmo = abp_codtmoDescuento
								from col_abp_anticipo_boleta_pago  
								where abp_codper = @codper and abp_codcil = @codcil and abp_codtmoAbono in (3586)  -- Anticipo de Reserva de Matricula

								--select @valor_tour_utec tour, @valor_anticipo_matricula abono
								--select * from col_dmo_det_mov where dmo_codigo = @dmo_codigo
								if isnull(@valor_tour_utec,0) > 0
								begin
									--select @dmo_codigo_agregar, @dmo_codigo
									update col_dmo_det_mov set dmo_abono = dmo_abono + abs(@valor_tour_utec), dmo_valor = dmo_valor + abs(@valor_tour_utec) 
																where dmo_codigo = @dmo_codigo_agregar  and isnull(@valor_tour_utec,0) > 0
									update col_dmo_det_mov set dmo_cargo = dmo_cargo + abs(@valor_tour_utec) where dmo_codigo = @dmo_codigo  and isnull(@valor_tour_utec,0) > 0
									set @dmo_cargo = @valor_tour_utec * -1
									set @dmo_valor = @valor_tour_utec * -1
									set @dmo_abono = @valor_tour_utec * -1

								end	--	if isnull(@valor_tour_utec,0) > 0

								if isnull(@valor_anticipo_matricula,0) > 0
								begin								
									update col_dmo_det_mov set dmo_cargo = dmo_cargo + abs(@valor_anticipo_matricula) where dmo_codigo = @dmo_codigo and isnull(@valor_anticipo_matricula,0) > 0
								end	--	if isnull(@valor_anticipo_matricula,0) > 0



								if isnull(@valor_tour_utec,0) > 0
								begin
									select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
									exec col_dfpc_DetalleFacturaPagoCuotas 1,
								--select --* from col_dmo_det_mov
								
									@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								end	--	if isnull(@valor_tour_utec,0) > 0



								print 'Es Anticipo de materias dinamico O-48'
								declare @abonos_dinamicos_o48 real = 0.0

								select @abonos_dinamicos_o48 = sum(dmo_abono) 
								from col_mov_movimientos 
								inner join col_dmo_det_mov on dmo_codmov = mov_codigo
								where mov_codper = @codper and dmo_codcil = @codcil and dmo_codtmo = 1490
								if isnull(@abonos_dinamicos_o48, 0) > 0
								begin								
									update col_dmo_det_mov set dmo_cargo = dmo_cargo + abs(@abonos_dinamicos_o48) where dmo_codigo = @dmo_codigo
								end	--	if isnull(@valor_anticipo_matricula,0) > 0



							end	--	if exists(select 1 from col_abp_anticipo_boleta_pago where abp_codper = @codper and abp_codcil = @codcil and abp_cuota = 0 and (abp_codtmoDescuento = 408 or abp_codtmoAbono = 3586))
							PRINT '***---FIN Almacenando el cargo del ciclo U'

						end	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREGRADO')
						else	--	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREGRADO')
						begin
							PRINT 'SON CUOTAS DE MENSUALIDAD'
							--select @arancel
							if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREGRADO')
							begin
								print 'cuota de la segunda a la sexta cuota de pregrado, se verifica si paga recargo de pago tardio'
								set @verificar_recargo_mora = 1
							end	--	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREGRADO')
							else	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREGRADO')
							begin
								print 'Es primera cuota de mensualidad de estudiante de pregrado'
								print 'NO PAGA ARANCEL DE RECARGO'
							end		--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREGRADO')
			
							PRINT '*-Almacenando el encabezado de la factura'
							select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
							select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca
			
							select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
							--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

							/* Insertando el encabezado de la factura*/
							exec col_efpc_EncabezadoFacturaPagoCuotas 1, 
							-- select 
								@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
								@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

							PRINT '*-FIN Almacenando el encabezado de la factura'
							/* Insertando el detalle de la factura*/
							/*Almacenando el arancel de la matricula */
							PRINT '**--Almacenando el arancel de la cuota'
							select @CorrelativoGenerado = @corr_mov -- max(mov_codigo) from col_mov_movimientos 
							--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress --and mov_codigo = @corr_mov and mov_lote = @mov_lote

							set @dmo_codtmo = @codtmo_sinbeca
							set @dmo_valor = @tmo_valor --@monto_con_mora
							set @dmo_iva = 0
							set @dmo_abono = @tmo_valor --@monto_con_mora
							set @dmo_cargo = 0

							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

							declare @bandera_pago int = 0
							if @monto_descuento > 0 and @codtmo_descuento = -1 and @monto_arancel_descuento = 0
							begin
								print 'if @monto_descuento > 0 and @codtmo_descuento = -1 and @monto_arancel_descuento = 0'
								set @dmo_cargo = @monto_descuento * - 1
								set @dmo_abono = @dmo_valor

								exec col_dfpc_DetalleFacturaPagoCuotas 1,
								-- select 
								@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								set @MontoPagado = @MontoPagado + @dmo_valor	
								set @bandera_pago = 1							
							end

							if @monto_descuento = 0 and @codtmo_descuento >0 and @monto_arancel_descuento > 0
							begin
								print 'if @monto_descuento = 0 and @codtmo_descuento >0 and @monto_arancel_descuento > 0'
								set @dmo_valor = @tmo_valor + @monto_arancel_descuento
								set @dmo_cargo = 0
								set @dmo_abono = @dmo_valor

								exec col_dfpc_DetalleFacturaPagoCuotas 1,
								-- select 
								@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								set @MontoPagado = @MontoPagado + @dmo_valor	
								

								set @dmo_codtmo = @codtmo_descuento
								set @dmo_valor = @monto_arancel_descuento * -1 								
								set @dmo_cargo = @dmo_valor
								set @dmo_abono = @dmo_valor

								select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
								exec col_dfpc_DetalleFacturaPagoCuotas 1,
								-- select 
								@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								--set @MontoPagado = @MontoPagado + @dmo_valor															
							end
							else
							begin
								print 'else  if @monto_descuento = 0 and @codtmo_descuento >0 and @monto_arancel_descuento > 0'
								if @bandera_pago = 0-- Si no se a realizado el pago se realiza en este IF
								begin
									print 'if @bandera_pago = 0'
									exec col_dfpc_DetalleFacturaPagoCuotas 1,
									@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
										@dmo_eval
									set @MontoPagado = @MontoPagado + @dmo_valor
								end
							end
							PRINT '**--FIN Almacenando el arancel de la cuota'
						end	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREGRADO')
					end	--	if @TipoEstudiante = 'PRE GRADO'

					if @TipoEstudiante = 'PRE ESPECIALIDAD CARRERA'
					BEGIN
						PRINT 'alumno de la carrera de la pre especializacion'

						if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREESPECIALIDAD')
						begin
							print 'ES ARANCEL DE Matricula de Pre especialidad'
							PRINT '*-Almacenando el encabezado de la factura'
							select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
							select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca

							select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
							--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

							/* Insertando el encabezado de la factura*/
							exec col_efpc_EncabezadoFacturaPagoCuotas 1, 
							--select 
								@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
								@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

							PRINT '*-FIN Almacenando el encabezado de la factura'
							/* Insertando el detalle de la factura*/
							/*Almacenando el arancel de la matricula */
							PRINT '**--Almacenando el arancel de la matricula'
							select @CorrelativoGenerado = @corr_mov -- max(mov_codigo) from col_mov_movimientos 
							--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress --and mov_codigo = @corr_mov and mov_lote = @mov_lote

							set @dmo_codtmo = @codtmo_sinbeca
							set @dmo_valor = @monto_con_mora
							set @dmo_iva = 0
							set @dmo_abono = @monto_con_mora
							set @dmo_cargo = 0

							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
							PRINT '**--FIN Almacenando el arancel de la matricula'
							/* Almacenando el arancel que tiene el cargo del ciclo */
							PRINT '***---Almacenando el cargo del ciclo'
							set @dmo_codtmo = 162
							set @dmo_valor = 0
							--set @dmo_cargo = 825.75
							set @dmo_abono = 0


							if exists (select 1 from ra_per_personas join col_detmen_detalle_tipo_mensualidad on per_codigo = detmen_codper where detmen_codcil = @codcil and per_carnet = @carnet)
							begin
								print 'Alumno posee descuento'
								select @dmo_cargo = sum(ISNUll(tmo_valor,0)) + sum(isnull(matricula,0)) + sum(isnull(monto_descuento,0)) + sum(isnull(monto_arancel_descuento,0))
									from col_art_archivo_tal_preesp_mora
								where ciclo = @codcil and per_carnet = @carnet /*and (isnull(monto_descuento,0) > 0 )*/ and fel_orden >= 2		--	Alumno posee descuento
								
							end
							else
							begin
								print 'Alumno no posee descuento'
								select @dmo_cargo = 
								sum(tmo_valor) + sum(isnull(monto_descuento,0)) + sum(matricula)
									from col_art_archivo_tal_preesp_mora
								where ciclo = @codcil and per_carnet = @carnet and isnull(monto_descuento,0) = 0  and fel_orden >= 2			--	Alumno no posee descuento
							end
							print '@dmo_cargo: ' + cast(@dmo_cargo as varchar)

							--select @dmo_cargo = sum(vac_SaldoAlum) from ra_vac_valor_cuotas where vac_codigo = @codvac
							select @dmo_cargo =
									case when matricula = 0 then tmo_valor else matricula end + @dmo_cargo

							from col_art_archivo_tal_preesp_mora
							where ciclo = @codcil and per_carnet = @carnet and fel_orden = 0

							--select  @dmo_cargo
							--select * from ra_vac_valor_cuotas where vac_codigo = @codvac
							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
							PRINT '***---FIN Almacenando el cargo del ciclo'
						end		--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREESPECIALIDAD')
						else	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREESPECIALIDAD')
						begin
							PRINT 'SON CUOTAS DE MENSUALIDAD'
							--select @arancel
							if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREESPECIALIDAD')
							begin
								print 'cuota de la segunda a la sexta cuota de pregrado, se verifica si paga recargo de pago tardio'
								set @verificar_recargo_mora = 1
							end	--	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREESPECIALIDAD')
							else	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREESPECIALIDAD')
							begin
								print 'Es primera cuota de mensualidad de estudiante de Pre especialidad'
								print 'NO PAGA ARANCEL DE RECARGO'
							end		--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREESPECIALIDAD'))
			
							PRINT '*-Almacenando el encabezado de la factura'
							select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
							select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca
			
							select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
							--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

							/* Insertando el encabezado de la factura*/
							exec col_efpc_EncabezadoFacturaPagoCuotas 1, 
							--select 
								@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
								@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea,@mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

							PRINT '*-FIN Almacenando el encabezado de la factura'
							/* Insertando el detalle de la factura*/
							/*Almacenando el arancel de la matricula */
							PRINT '**--Almacenando el arancel de la cuota'
							select @CorrelativoGenerado = max(mov_codigo) from col_mov_movimientos 
							where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress --and mov_codigo = @corr_mov and mov_lote = @mov_lote

							set @dmo_codtmo = @codtmo_sinbeca
							set @dmo_valor = @tmo_valor --@monto_con_mora
							set @dmo_iva = 0
							set @dmo_abono = @tmo_valor --@monto_con_mora
							set @dmo_cargo = 0

							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

							declare @bandera_pago_preesp int = 0
							if @monto_descuento > 0 and @codtmo_descuento = -1 and @monto_arancel_descuento = 0
							begin
								print 'if @monto_descuento > 0 and @codtmo_descuento = -1 and @monto_arancel_descuento = 0 (cuota normal)'
								set @dmo_cargo = @monto_descuento * - 1
								set @dmo_abono = @dmo_valor

								exec col_dfpc_DetalleFacturaPagoCuotas 1,
								-- select 
								@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								set @MontoPagado = @MontoPagado + @dmo_valor	
								set @bandera_pago_preesp = 1							
							end
							
							if @monto_descuento = 0 and @codtmo_descuento >0 and @monto_arancel_descuento > 0
							begin
								print 'if @monto_descuento = 0 and @codtmo_descuento >0 and @monto_arancel_descuento > 0 (cuota con descuento)'
								set @dmo_valor = @tmo_valor + @monto_arancel_descuento
								set @dmo_cargo = 0
								set @dmo_abono = @dmo_valor

								exec col_dfpc_DetalleFacturaPagoCuotas 1,
								-- select 
								@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								set @MontoPagado = @MontoPagado + @dmo_valor	
								
								set @dmo_codtmo = @codtmo_descuento
								set @dmo_valor = @monto_arancel_descuento * -1 								
								set @dmo_cargo = @dmo_valor
								set @dmo_abono = @dmo_valor

								select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
								exec col_dfpc_DetalleFacturaPagoCuotas 1,
								-- select 
								@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								--set @MontoPagado = @MontoPagado + @dmo_valor															
							end
							else
							begin
								print 'else  if @monto_descuento = 0 and @codtmo_descuento >0 and @monto_arancel_descuento > 0 (cuota normal)'
								if @bandera_pago_preesp = 0-- Si no se a realizado el pago se realiza en este IF
								begin
									print 'if @@bandera_pago_preesp = 0'
									exec col_dfpc_DetalleFacturaPagoCuotas 1,
									@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
										@dmo_eval
									set @MontoPagado = @MontoPagado + @dmo_valor
								end
							end

							/*
							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor*/
							PRINT '**--FIN Almacenando el arancel de la cuota'
						end	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREESPECIALIDAD')
					END	--	if @TipoEstudiante = 'PRE ESPECIALIDAD CARRERA'

					if @TipoEstudiante = 'PRE TECNICO DE CARRERA DE DISENIO' 
					BEGIN
						PRINT 'alumno de CARRERA TECNICO de de la pre especializacion'
						if (@arancel = 'I-73' or @arancel = 'I-74')
						begin
							print 'es pago de matricula y primera cuota, por lo tanto, no paga mora'
							if (@arancel = 'I-73')
							begin
								print 'pago exclusivamente de la matricula'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
								select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca	
								set @dmo_cargo = 0
								set @dmo_valor = @monto_sin_mora
								set @dmo_abono = @monto_sin_mora
							end	--	if (@arancel = 'I-73')
							if (@arancel = 'I-74')
							begin
								print 'pago de la primer cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-74'
								select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-57'
								--select @dmo_valor = @portafolio_tecnicos_pre	
								set @dmo_valor = @portafolio_tecnicos_pre
								set @dmo_abono = @portafolio_tecnicos_pre
								--select @portafolio_tecnicos_pre
								select @dmo_cargo = sum(isnull(portafolio,0)) from col_art_archivo_tal_proc_grad_tec_dise_mora
								where ciclo = @codcil and per_carnet = @carnet
								set @dmo_codtmo = 1633
						--set @dmo_abono 
							end --	if (@arancel = 'I-74')
						end	--	if (@arancel = 'I-73' or @arancel = 'I-74')
						else	--	--	if (@arancel = 'I-73' or @arancel = 'I-74')
						begin
							print 'pago de la segunda cuota en adelante, se verifica si hay recargo por mora'
							set @verificar_recargo_mora = 1
							set @dmo_valor = @portafolio_tecnicos_pre
							set @dmo_abono = @portafolio_tecnicos_pre
							set @dmo_cargo = 0

							if (@arancel = 'I-75')
							begin
								print 'pago de la segunda cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-75'
								select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-58'
							end --	if (@arancel = 'I-75')
							if (@arancel = 'I-76')
							begin
								print 'pago de la tercera cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-76'
								select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-59'
							end --	if (@arancel = 'I-76')
							if (@arancel = 'I-77')
							begin
								print 'pago de la cuarta cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-77'
								select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-60'
							end --	if (@arancel = 'I-77')
							if (@arancel = 'I-78')
							begin
								print 'pago de la quinta cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-78'
								select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-61'
							end --	if (@arancel = 'I-78')
							if (@arancel = 'E-03')
							begin
								print 'Examen de seminario de graduacion'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'E-03'
							end --	if (@arancel = 'E-03')
						end	--	--	if (@arancel = 'I-73' or @arancel = 'I-74')
						--select @dmo_valor, @monto_sin_mora , @portafolio_tecnicos_pre	
						select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
						--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)
						--select @corr_mov, @codtmo_sinbeca, @codtmo_conbeca
						/* Insertando el encabezado de la factura*/

						--select 
						--	@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
						--	@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea

						exec col_efpc_EncabezadoFacturaPagoCuotas 1,
						--select 
							@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
							@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro
						print 'se inserto el encabezado de la factura'

						select @CorrelativoGenerado = @corr_mov --max(mov_codigo) from col_mov_movimientos 
						--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress --and mov_codigo = @corr_mov and mov_lote = @mov_lote

						PRINT '*-Almacenando el encabezado de la factura'

						print 'Almacenando el detalle de la factura'
						--set @dmo_codtmo = @codtmo_sinbeca
						--set @dmo_valor = @monto_con_mora
						set @dmo_iva = 0
						--set @dmo_abono = @monto_con_mora
						--set @dmo_cargo = 0

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						if (@arancel <> 'E-03')
						begin
							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
						end	--	if (@arancel <> 'E-03')
						else
						begin
							set @verificar_recargo_mora = 0
						end

						PRINT '**--FIN Almacenando el arancel de la matricula'

						/* Almacenando el arancel que tiene el cargo del ciclo */
						PRINT '***---Almacenando el cargo del ciclo'
					
						--set @dmo_valor = 0
						--set @dmo_cargo = 825.75
						--set @dmo_abono = 0

						if (@arancel = 'I-73')
						begin
							set @dmo_codtmo = 162
							select @dmo_cargo = sum(isnull(tmo_valor,0)) - sum(isnull(portafolio,0)) 
							from col_art_archivo_tal_proc_grad_tec_dise_mora
							where ciclo = @codcil and per_carnet = @carnet
							--set @dmo_cargo = 0
							set @dmo_abono = 0--@monto_sin_mora 
							set @dmo_valor = 0--@monto_sin_mora
						end

						if (@arancel = 'I-74' or @arancel = 'I-75' or @arancel = 'I-76' or @arancel = 'I-77' or @arancel = 'I-78')
						begin
							select @dmo_valor = (isnull(tmo_valor,0)) - (isnull(portafolio,0)) 
							from col_art_archivo_tal_proc_grad_tec_dise_mora 
							where ciclo = @codcil and per_carnet = @carnet and tmo_arancel = @arancel
							set @dmo_abono = @dmo_valor
							set @dmo_cargo = 0
							set @dmo_codtmo = @codtmo_sinbeca
						end

						if (@arancel = 'E-03')
						begin
							select @dmo_valor = @monto_con_mora 
							set @dmo_abono = @dmo_valor
							set @dmo_cargo = 0
							set @dmo_codtmo = @codtmo_sinbeca						
						end
						----select @dmo_cargo = sum(vac_SaldoAlum) from ra_vac_valor_cuotas where vac_codigo = @codvac
						--select @dmo_cargo = sum(tmo_valor) from col_art_archivo_tal_proc_grad_tec_dise_mora
						--where ciclo = @codcil and per_carnet = @carnet

						--select  @dmo_cargo
						--select * from ra_vac_valor_cuotas where vac_codigo = @codvac
						--set @dmo_cantidad = @portafolio_tecnicos_pre
						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						PRINT '***---FIN Almacenando el cargo del ciclo'
					END	--	if @TipoEstudiante = 'PRE TECNICO DE CARRERA DE DISENIO'
	--***
					if @TipoEstudiante = 'PRE TECNICO DE CARRERA diferente de disenio' 
					BEGIN
						--I-73: Inscripción al Seminario de Graduación Técnicos
						--I-74 o C-90: pago de la primera cuota
						--I-75 o C-91: pago de la segunda cuota
						--I-76 o C-92: pago de la tercera cuota
						--I-77 o C-93: pago de la cuarta cuota
						--I-78 o C-94: pago de la quinta cuota
						--E-03: Examen de seminario de graduacion
						PRINT 'alumno de CARRERA TECNICO diference de Diseño de de la pre especializacion'

						if (@arancel = 'I-73' or @arancel = 'I-74' or @arancel = 'C-90')
						begin
							print 'es pago de matricula y primera cuota, por lo tanto, no paga mora'
							if (@arancel = 'I-73')
							begin
								print 'pago exclusivamente de la matricula'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
								--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca	
								set @dmo_cargo = 0
								set @dmo_valor = @monto_sin_mora
								set @dmo_abono = @monto_sin_mora
							end	--	if (@arancel = 'I-73')
							if (@arancel = 'I-74')
							begin
								print 'pago de la primer cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-74'
								--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-57'
								--select @dmo_valor = @portafolio_tecnicos_pre	
								set @dmo_valor = @portafolio_tecnicos_pre
								set @dmo_abono = @portafolio_tecnicos_pre
								--select @portafolio_tecnicos_pre
								select @dmo_cargo = 0 --sum(isnull(portafolio,0)) from col_art_archivo_tal_proc_grad_tec_mora
								--where ciclo = @codcil and per_carnet = @carnet
								--set @dmo_codtmo = 1633
						--set @dmo_abono 
							end --	if (@arancel = 'I-74')

							if (@arancel = 'C-90')
							begin
								print 'pago de la primer cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'C-90'
								set @dmo_valor = @portafolio_tecnicos_pre
								set @dmo_abono = @portafolio_tecnicos_pre
								select @dmo_cargo = 0
							end --	if (@arancel = 'C-90')

						end	--	if (@arancel = 'I-73' or @arancel = 'I-74' or @arancel = 'C-90')
						else	--	--	if (@arancel = 'I-73' or @arancel = 'I-74' or @arancel = 'C-90')
						begin
							print 'pago de la segunda cuota en adelante, se verifica si hay recargo por mora'
							set @verificar_recargo_mora = 1
							set @dmo_valor = @portafolio_tecnicos_pre
							set @dmo_abono = @portafolio_tecnicos_pre
							set @dmo_cargo = 0

							--if (@arancel = 'I-75')
							--begin
							--	print 'pago de la segunda cuota'
							--	select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-75'
							--	--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-58'
							--end --	if (@arancel = 'I-75')
							--if (@arancel = 'I-76')
							--begin
							--	print 'pago de la tercera cuota'
							--	select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-76'
							--	--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-59'
							--end --	if (@arancel = 'I-76')
							--if (@arancel = 'I-77')
							--begin
							--	print 'pago de la cuarta cuota'
							--	select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-77'
							--	--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-60'
							--end --	if (@arancel = 'I-77')
							--if (@arancel = 'I-78')
							--begin
							--	print 'pago de la quinta cuota'
							--	select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-78'
							--	--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-61'
							--end --	if (@arancel = 'I-78')
							--if (@arancel = 'E-03')
							--begin
							--	print 'Examen de seminario de graduacion'
							--	select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'E-03'
							--end --	if (@arancel = 'E-03')

							select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel

						end	--	--	if (@arancel = 'I-73' or @arancel = 'I-74')
						
						--select @dmo_valor, @monto_sin_mora , @portafolio_tecnicos_pre	
						select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
						--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)
						--select @corr_mov, @codtmo_sinbeca, @codtmo_conbeca
						/* Insertando el encabezado de la factura*/

						--select 
						--	@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
						--	@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea

						exec col_efpc_EncabezadoFacturaPagoCuotas 1, 
						--select 
							@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
							@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro
						print 'se inserto el encabezado de la factura'

						select @CorrelativoGenerado = @corr_mov --max(mov_codigo) from col_mov_movimientos 
						--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress --and mov_codigo = @corr_mov and mov_lote = @mov_lote

						PRINT '*-Almacenando el encabezado de la factura'

						print 'Almacenando el detalle de la factura'
						--set @dmo_codtmo = @codtmo_sinbeca
						set @dmo_valor = @monto_sin_mora
						set @dmo_iva = 0
						set @dmo_abono = @dmo_valor
						set @dmo_cargo = 0

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						if (@arancel <> 'I-73') -- Si no es la matricula
						begin
							select  @dmo_cargo = tpmenara_monto_descuento * -1 from col_detmen_detalle_tipo_mensualidad
							inner join col_tpmenara_tipo_mensualidad_aranceles on detmen_codtpmenara = tpmenara_codigo
							where tpmenara_arancel = @arancel AND detmen_codper = @codper and detmen_codcil = @codcil
							set @dmo_cargo = isnull(@dmo_cargo, 0)
						end

						if (@arancel <> 'E-03')
						begin
							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
						end	--	if (@arancel <> 'E-03')
						else
						begin
							set @verificar_recargo_mora = 0
							set @dmo_valor = @monto_sin_mora
							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
						end

						--PRINT '**--FIN Almacenando el arancel de la matricula'

						--/* Almacenando el arancel que tiene el cargo del ciclo */
						--PRINT '***---Almacenando el cargo del ciclo'
					
						----set @dmo_valor = 0
						----set @dmo_cargo = 825.75
						----set @dmo_abono = 0

						if (@arancel = 'I-73')
						begin
							set @dmo_codtmo = 162
							select @dmo_cargo = sum(isnull(tmo_valor,0)) + sum(isnull(monto_descuento, 0)) 
							from col_art_archivo_tal_proc_grad_tec_mora
							where ciclo = @codcil and per_carnet = @carnet
							--set @dmo_cargo = 0
							set @dmo_abono = 0--@monto_sin_mora 
							set @dmo_valor = 0--@monto_sin_mora

							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
						end

						--if (@arancel = 'I-74' or @arancel = 'I-75' or @arancel = 'I-76' or @arancel = 'I-77' or @arancel = 'I-78')
						--begin
						--	select @dmo_valor = (isnull(tmo_valor,0)) from col_art_archivo_tal_proc_grad_tec_mora
						--	where ciclo = @codcil and per_carnet = @carnet
						--	set @dmo_abono = @dmo_valor
						--	set @dmo_cargo = 0
						--	set @dmo_codtmo = @codtmo_sinbeca
						--end

						--if (@arancel = 'E-03')
						--begin
						--	select @dmo_valor = @monto_con_mora 
						--	set @dmo_abono = @dmo_valor
						--	set @dmo_cargo = 0
						--	set @dmo_codtmo = @codtmo_sinbeca	
						--end

						----select @dmo_cargo = sum(vac_SaldoAlum) from ra_vac_valor_cuotas where vac_codigo = @codvac
						--select @dmo_cargo = sum(tmo_valor) from col_art_archivo_tal_proc_grad_tec_dise_mora
						--where ciclo = @codcil and per_carnet = @carnet

						--select  @dmo_cargo
						--select * from ra_vac_valor_cuotas where vac_codigo = @codvac
						--set @dmo_cantidad = @portafolio_tecnicos_pre
						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
						--exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						--@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
						--	@dmo_eval
						--PRINT '***---FIN Almacenando el cargo del ciclo'

					END	--	if @TipoEstudiante = 'PRE TECNICO DE CARRERA diferente de disenio'
					--****
				end		--	if @per_tipo = 'U'

				if @per_tipo = 'CE'
				begin
					print 'Verificando el alumno de Curso Especializado'
					select @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
	
					select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
					--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

					/* Insertando el encabezado de la factura*/
					exec col_efpc_EncabezadoFacturaPagoCuotas 1, 
					--select 
						@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
						@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

					PRINT '*-FIN Almacenando el encabezado de la factura'
					/* Insertando el detalle de la factura*/
					/*Almacenando el arancel de la matricula */
					PRINT '**--Almacenando el arancel de la matricula'
					select @CorrelativoGenerado = @corr_mov				

		
					set @dmo_valor = @monto_sin_mora
					set @dmo_iva = 0
					set @dmo_abono = @monto_sin_mora
					set @dmo_cargo = 0

					select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
					--select @dmo_codtmo, @codtmo
					exec col_dfpc_DetalleFacturaPagoCuotas 1,
					--select 
					@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
						@dmo_eval
					set @MontoPagado = @MontoPagado + @dmo_valor
					PRINT '**--FIN Almacenando el arancel del pago'

					if (@arancel = 'M-101') -- matricula
					begin
						print 'Matricula de curso de especializacion'
						select @dmo_cargo = sum(tmo_valor) from col_art_archivo_tal_mae_mora 
						where per_carnet = @carnet and ciclo = @codcil
						set @dmo_valor = 0
						set @dmo_abono = 0
						set @dmo_codtmo = 162

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						--select 999
					end	--	if (@arancel = 'M-101')
				end

				if @per_tipo = 'O'
				BEGIN
					PRINT 'alumno de los Postgrados impartidos por maestrias'

					if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Postgrados' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'POSTGRADOS MAES')
					begin
						print 'ES ARANCEL DE Matricula de Postgrado de maestrias'
						PRINT '*-Almacenando el encabezado de la factura'
						select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
						select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca

						select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
						--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

						/* Insertando el encabezado de la factura*/
						exec col_efpc_EncabezadoFacturaPagoCuotas 1, 
						--select 
							@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
							@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

						PRINT '*-FIN Almacenando el encabezado de la factura'
						/* Insertando el detalle de la factura*/
						/*Almacenando el arancel de la matricula */
						PRINT '**--Almacenando el arancel de la matricula'
						select @CorrelativoGenerado = @corr_mov --max(mov_codigo) from col_mov_movimientos 
						--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress --and mov_codigo = @corr_mov and mov_lote = @mov_lote

						set @dmo_codtmo = @codtmo_sinbeca
						set @dmo_valor = @monto_con_mora
						set @dmo_iva = 0
						set @dmo_abono = @monto_con_mora
						set @dmo_cargo = 0

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						PRINT '**--FIN Almacenando el arancel de la matricula'

						/* Almacenando el arancel que tiene el cargo del ciclo */
						PRINT '***---Almacenando el cargo del ciclo'
						set @dmo_codtmo = 162
						set @dmo_valor = 0
						--set @dmo_cargo = 825.75
						set @dmo_abono = 0

						--select @dmo_cargo = sum(vac_SaldoAlum) from ra_vac_valor_cuotas where vac_codigo = @codvac
						select @dmo_cargo = sum(tmo_valor) from col_art_archivo_tal_mae_mora
						where ciclo = @codcil and per_carnet = @carnet

						--select  @dmo_cargo
						--select * from ra_vac_valor_cuotas where vac_codigo = @codvac
						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						PRINT '***---FIN Almacenando el cargo del ciclo'
					end		--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Postgrados' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'POSTGRADOS MAES')
					else	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Postgrados' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'POSTGRADOS MAES')
					begin
						PRINT 'SON CUOTAS DE MENSUALIDAD'
						--select @arancel
						if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Postgrados' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'POSTGRADOS MAES')			          
						begin
							print 'cuota de la segunda a la sexta cuota de pregrado, se verifica si paga recargo de pago tardio'
							set @verificar_recargo_mora = 1
						end	--	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Postgrados' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'POSTGRADOS MAES')			          
						else	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Postgrados' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'POSTGRADOS MAES')			          
						begin
							print 'Es primera cuota de mensualidad de estudiante de Postgrados de Maestrias'
							print 'NO PAGA ARANCEL DE RECARGO'
						end		--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Postgrados' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'POSTGRADOS MAES')			          
			
						PRINT '*-Almacenando el encabezado de la factura'
						select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
						select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca
			
						select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
						--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

						/* Insertando el encabezado de la factura*/
						exec col_efpc_EncabezadoFacturaPagoCuotas 1, 
						--select 
							@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
							@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

						PRINT '*-FIN Almacenando el encabezado de la factura'
						/* Insertando el detalle de la factura*/
						/*Almacenando el arancel de la matricula */
						PRINT '**--Almacenando el arancel de la cuota'
						select @CorrelativoGenerado = @corr_mov --max(mov_codigo) from col_mov_movimientos 
						--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress --and mov_codigo = @corr_mov and mov_lote = @mov_lote

						set @dmo_codtmo = @codtmo_sinbeca
						set @dmo_valor = @tmo_valor --@monto_con_mora
						set @dmo_iva = 0
						set @dmo_abono = @tmo_valor --@monto_con_mora
						set @dmo_cargo = 0

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						PRINT '**--FIN Almacenando el arancel de la cuota'
					end	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREESPECIALIDAD')
				END	--	if @TipoEstudiante = 'POST GRADOS de MAESTRIAS'

				if @verificar_recargo_mora = 1	--	verifica si pagar recargo
				begin
					print 'de segunda a sexta cuota, se evalua si paga o no recargo'

					set @dias_vencido = 0
					set @dias_vencido = DATEDIFF(dd, CONVERT(CHAR(10), @fecha_sin_mora, 103) , CONVERT(CHAR(10), getdate(), 103))
					print '@dias_vencido : ' + cast(@dias_vencido as nvarchar(10))
					--select @dias_vencido as dias_vencido			

					if (@dias_vencido > 0)
					begin
						print 'esta vencido, por lo tanto, se verifica si las cuotas son las mismas'
						if @monto_sin_mora = @monto_con_mora 
						begin
							print 'las cuotas es lo mismo, por lo tanto no paga mora'
							set @monto = @monto_sin_mora
							set @paga_mora = 0
						end
						else	--	if @monto_sin_mora = @monto_con_mora 
						begin
							print 'la cuota con mora y sin mora es diferente, por lo tanto se paga recargo de mora'
							set @monto = @monto_con_mora
							set @paga_mora = 1
						end	--	if @monto_sin_mora = @monto_con_mora 
					end
					else	--	if (@dias_vencido > 0)
					begin
						print 'No paga el recargo de mora porque no esta vencido'
						set @monto = @monto_sin_mora
						set @paga_mora = 0
					end	--	if (@dias_vencido > 0)	
					--select @paga_mora
					if @paga_mora = 1
					begin
						--	select tmo_codigo, tmo_valor from col_tmo_tipo_movimiento where tmo_arancel = 'A-88'
						set @codtmo = 88
						set @monto = 10 
						/*Almacenando el arancel del recargo de pago extraordinario */
						PRINT '**--Almacenando el arancel del recargo de pago extraordinario '
						select @dmo_codmov = max(mov_codigo) from col_mov_movimientos 
						where mov_codper = @codper and mov_codcil = @codcil and mov_recibo_puntoxpress = @mov_recibo_puntoxpress

						set @dmo_codtmo = @codtmo
						set @dmo_valor = @monto
						set @dmo_iva = 0
						set @dmo_abono = @monto
						set @dmo_cargo = @monto

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						PRINT '**--FIN Almacenando el arancel del recargo de pago extraordinario '
					end	--	if @paga_mora = 1
				end	--	if exists(select count(1) from vst_Aranceles_x_Evaluacion where tde_nombre = 'Maestrias' and spaet_codigo = 1 and tmo_arancel = @arancel)


			end		--	if exists(select 1 from col_mov_movimientos inner join col_dmo_det_mov on mov_codigo = dmo_codmov where mov_codper = @codper and dmo_codcil = @codcil and dmo_codtmo = @codtmo and mov_estado <> 'A')
			print '@codtmo_sinbeca : ' + cast(@codtmo_sinbeca as nvarchar(10))
			print '@codtmo_conbeca : ' + cast(@codtmo_conbeca as nvarchar(10))

			--select * from col_mov_movimientos where mov_codper = 196586 and mov_codcil = 116 and mov_codigo in (5281547, 5269003)
			--select * from col_mov_movimientos where mov_codper = 193592 and mov_codcil = 116-- and mov_codigo in (5281547, 5269003)
		
			print '@MontoPagado: ' + cast(@MontoPagado as nvarchar(10))
			insert into col_pagos_en_linea_estructuradoSP (codper, carnet, NumFactura, formapago, lote, MontoFactura, npe, TipoEstudiante, codppo ) 
			values (@codper, @carnet, @CorrelativoGenerado, @tipo, @lote, @MontoPagado, @npe, @TipoEstudiante, @IdGeneradoPreviaPagoOnLine)
			
			--select * from col_mov_movimientos where mov_codper = @codper
			--select * from col_dmo_det_mov where dmo_codmov in (select mov_codigo from col_mov_movimientos where mov_codper = @codper)
		
		end	--	if isnull(@codper,0) > 0
		else	--	if isnull(@codper,0) > 0
		begin
			set @Mensaje = 'Por alguna razon no se encontro el codper del estudiante'
			print 'Por alguna razon no se encontro el codper del estudiante'
			set @codper_encontrado = 0 
		end	--	if isnull(@codper,0) > 0

		-- 1: Exito registro de forma correcta el pago
		saltar_validaciones: 
		if @arancel_especial = 1 --Es un pago de arancel especial
		begin
			print '***if @arancel_especial = 1***'

			declare @respuesta int = 0, @codpboa int
			select @codpboa = dao_coddpboa, @codcil = dao_codcil, @codper = dao_codper 
			from col_dao_data_otros_aranceles where dao_npe = @npe_original
			select @respuesta = dbo.fn_cumple_parametros_boleta_otros_aranceles(@codpboa, @codcil,-1, @codper)

			if @respuesta = 0--el arancel especial no tiene ninguna restriccion para el pago
			begin
				-- exec sp_insertar_pagos_x_carnet_estructurado  '0313004000000023178800012800', 1, 'xxxxx'
				declare @coddip int = 0, @per_carnet_anterior varchar(32) = '', @graduado_utec int = 0, @cil_codigo_vigente int = 0

				select @coddip = ped_coddip, @per_carnet_anterior = per_carnet_anterior 
				from dip_ped_personas_dip 
					inner join ra_per_personas on per_codigo = ped_codper
				where per_carnet = @carnet

				if (isnull(@per_carnet_anterior, '') != '')
				begin
					set @graduado_utec = 1
				end

				select @dmo_cargo = sum(tmo_valor)
				from cil_cpd_cuotas_pagar_diplomado
					inner join col_tmo_tipo_movimiento on tmo_codigo = cpd_codtmo
					inner join col_dpboa_definir_parametro_boleta_otros_aranceles on dpboa_codtmo = cpd_codtmo
				where cpd_coddip = @coddip and cpd_graduado_utec = @graduado_utec

				select top 1 @cil_codigo_vigente = cil_codigo from ra_cil_ciclo where cil_vigente = 'S' order by cil_codigo desc
				set @dmo_valor = 0
				set @dmo_abono = 0
				set @dmo_codtmo = 162

				select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

				print 'if @arancel_especial = 1 '
				print '@npe_original: ' + cast(@npe_original as varchar(64))
				print '@tipo: ' + cast(@tipo as varchar(20))
				print '@referencia: ' + cast(@referencia as varchar(20))
				
				declare @codmov_generado int;  
				execute dbo.sp_insertar_encabezado_pagos_online_otros_aranceles_estructurado @npe_original, @tipo, @referencia, @mov_codigo_generado = @codmov_generado output

				if not exists (
					select 1 from col_mov_movimientos 
					inner join col_dmo_det_mov on dmo_codmov = mov_codigo 
					where mov_codper = @codper and dmo_codcil = @cil_codigo_vigente and dmo_codtmo = @dmo_codtmo
					and (@coddip > 0)
				) and @per_tipo = 'D'
				begin --Si no existe el C-30
					print 'Matricula de diplomados, no tiene asignado el C-30'
					select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
					
					if @dmo_valor > 0--Si valor del C-30 es mayor a 0, se inserta, sino queda sin C-30
					begin
						exec dbo.col_dfpc_DetalleFacturaPagoCuotas 1,
						1, @codmov_generado, @dmo_codigo, @dmo_codtmo, 1, @dmo_valor, '', 0, 0, 
						0, @cil_codigo_vigente, @dmo_cargo, @dmo_abono, 0
					end
				end
				--select @codmov_generado

				update col_mov_movimientos set mov_npe = @npe, mov_co016 = 1, mov_fp017 = '05', 
					mov_referencia_pos = @referencia, mov_p018 = null, mov_periodo_plazo = null, mov_estado = 'I'
				where mov_codigo = @codmov_generado

				select '1' resultado, @codmov_generado Correlativo, 'Transacción generada de forma satisfactoria' as Descripcion
			end
			else
			begin
				--select 'ELSE -;;;;;;;;;;;'
				-- @respuesta puede tener los siguientes resultados para aranceles especiales
				-- 1:NO EXISTE EL ARANCEL, 0: todo bien, 1: cupo acabado, 2: fecha vencimiento vencio, 3: fuera del periodo (fecha_desde a fecha_hasta), 4: CUOTAS PENDIENTES
				-- pero se omiten y se manda como resultado 2 que para este procedimiento es igual a 'No se pudo generar la transacción'
				print '***@respuesta de pagos de otros aranceles: ***' + cast(@respuesta as varchar(5))
				-- Como está actualmente el alumno no sabe por qué se rechazó el pago del arancel, contactar con “los puntos en línea” para que estén preparados para recibir dichos resultados de otros aranceles
				select '2' resultado, -1 as Correlativo, 'No se pudo generar la transacción' as Descripcion
			end
		end	--	if @arancel_especial = 1 --Es un pago de arancel especial

		else	--	if @arancel_especial = 1 --Es un pago de arancel especial
		begin
			if @codper_encontrado = 0 
			begin
				set @Mensaje = 'Intentar realizar nuevamente la transacción'
				select '-2' resultado, @CorrelativoGenerado as Correlativo, 'Intentar realizar nuevamente la transacción' as Descripcion
			end		--	if @codper_encontrado = 0 
			else	--	if @codper_encontrado = 0 
			begin
				if @npe_valido = 0
				begin
					set @Mensaje = 'NPE no existe ...' 
					select '-1' resultado, @CorrelativoGenerado as Correlativo, 'NPE no existe ...' as Descripcion
				end	--	if @npe_valido = 0
				else
				begin
					if @CorrelativoGenerado = 0
					begin
						set @Mensaje = 'La cuota ya estaba cancelada con anterioridad' 
						select '0' resultado, @CorrelativoGenerado as Correlativo, 'La cuota ya estaba cancelada con anterioridad' as Descripcion
					end
					else	--	if @CorrelativoGenerado = 0
					begin
						
						update col_mov_movimientos set mov_npe = @npe, mov_co016 = 1, mov_fp017 = '05', 
							mov_referencia_pos = @referencia, mov_p018 = null, mov_periodo_plazo = null, mov_estado = 'I'
						where mov_codigo = @CorrelativoGenerado

						select '1' resultado, @CorrelativoGenerado as Correlativo, 'Transacción generada de forma satisfactoria' as Descripcion

					end		--	if @CorrelativoGenerado = 0
				end
				
				salto_por_diplomado:
				if @CorrelativoGenerado > 0
				begin
					select '1' resultado, @CorrelativoGenerado as Correlativo, 'Transacción generada de forma satisfactoria' as Descripcion
				end
				else
				begin
					select '0' resultado, @CorrelativoGenerado as Correlativo, 'La cuota ya estaba cancelada con anterioridad' as Descripcion
				end
			end	--	if @codper_encontrado = 0 

		end	--	if @arancel_especial = 1 --Es un pago de arancel especial


	COMMIT TRANSACTION -- O solo COMMIT


	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION -- O solo ROLLBACK
    
		insert into col_ert_error_transaccion(ert_codper, ert_npe, ert_ciclo,ert_message,ert_numer,ert_severity,ert_state,ert_procedure,ert_line)
		values(@per_codigo, @npe, @cil_codigo, concat(error_message(), ' ,' , @mensaje), error_number(), 
		error_severity(), error_state(), error_procedure(), error_line())
		
		select '2' resultado, -1 as Correlativo, 'No se pudo generar la transacción' as Descripcion
		-- 2: Error algun dato incorrecto no guardo ningun cambio

	END CATCH

	--Inicio: Insert a Rinnovo 25/05/2021, ALTER 01/09/2021 09:15 a.m, SEGUNDA PRUEBA ALTER 12/10/2021 08:47 a.m.
	--declare @tb_correlativo as table (codmov int)
	--insert into @tb_correlativo (codmov)
	--exec [192.168.1.132].UTEC_DBPRD.UTEC_COLLECTOR.SP_TEMP_PAGO_ONLINE
	--	@IDESTUDIANTE = @codper,  @IDFACTURA = @CorrelativoGenerado, @IDCICLO = @codcil
	--Fin: Insert a Rinnovo 25/05/2021, ALTER 01/09/2021 09:15 a.m, SEGUNDA PRUEBA ALTER 12/10/2021 08:47 a.m.

end
go


USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_cuotas_estudiantes_maestrias]    Script Date: 16/4/2024 11:03:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	-- exec dbo.sp_cuotas_estudiantes_maestrias 0, 254062
ALTER PROCEDURE [dbo].[sp_cuotas_estudiantes_maestrias]
	@car_codtde int,
	@codper int
AS
BEGIN
	set dateformat dmy
	declare @a int

	declare @validador_pregrado int
	set @validador_pregrado = 1
	--ULTIMO CICLO DE INSCRIPCIÓN
	DECLARE @codcil int
	


	SELECT @codcil = MAX(ins_codcil) FROM ra_ins_inscripcion
	WHERE ins_codper = @codper

	set @codcil = @codcil 
	PRINT '@codcil : ' + CAST(@codcil AS NVARCHAR(10))
	--PRE GRADO y PRE ESPECIALIDAD

	if exists (select 1 from dip_ped_personas_dip where ped_codper = @codper)
	begin
		print 'Alumno es de PRE-GRADO DIPLOMADOS/SEMINARIOS'

		select art.per_codigo, art.per_carnet, art.per_nombres_apellidos, art.tmo_arancel, art.fel_fecha_mora, art.ciclo, art.mciclo, tmo.tmo_descripcion, 
			case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end as Monto, NPE
			--t.tmo_valor as Monto
		from col_tmo_tipo_movimiento as tmo 
			--inner join vst_Aranceles_x_Evaluacion as vst on vst.tmo_arancel = tmo.tmo_arancel and vst.are_codtmo = tmo.tmo_codigo 
			inner join col_art_archivo_tal_mora as art on art.tmo_arancel = tmo.tmo_arancel 
			inner join ra_per_personas as p on p.per_codigo = art.per_codigo

		where art.per_codigo = @codper-- and art.ciclo = @codcil-- and vst.are_tipo = 'PREGRADO'
		and art.NPE not in (
			select distinct mov_npe from col_mov_movimientos where mov_codper = @codper and mov_estado not in ('A')
		)
		order by fel_codigo_barra, art.fel_fecha_mora asc

		return
	end

	IF @car_codtde = 1
	BEGIN
		print	'Verificando si es de pregrado o pre especializacion el alumno'
		--	PRE GRADO
		
		if exists(select 1 from col_art_archivo_tal_preesp_mora where per_codigo = @codper) -- and ciclo > @codcil)
		begin
			set @validador_pregrado = 0
			print 'alumno de pre Especializacion'
			--select * from col_art_archivo_tal_preesp_mora where per_codigo = @codper and ciclo > @codcil
			--	PRE ESPECIALIDAD

			select @codcil = max(ciclo) from col_art_archivo_tal_preesp_mora where per_codigo = @codper 


			  --declare @pendientes table (arancel nvarchar(25), codper int, cantidad int, Estado nvarchar(25),descripcion nvarchar(150), cuota int, codcil int, fecha date)

			   --insert into @pendientes (arancel, codper, cantidad, Estado, descripcion, cuota, codcil, fecha)
			   --select tmo.tmo_arancel, t.per_codigo as codper, 1 as cantidad, 
			   --      'Pendiente' as Estado, tmo.tmo_descripcion, vst.are_cuota, t.ciclo, t.fel_fecha_mora
			   select art.per_codigo, art.per_carnet, art.per_nombres_apellidos, art.tmo_arancel, art.fel_fecha_mora, art.ciclo, art.mciclo, 
					tmo.tmo_descripcion, 
					case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end as Monto, NPE
			   from col_tmo_tipo_movimiento as tmo inner join vst_Aranceles_x_Evaluacion as vst
					 on vst.tmo_arancel = tmo.tmo_arancel and vst.are_codtmo = tmo.tmo_codigo inner join col_art_archivo_tal_preesp_mora as art 
					 on art.tmo_arancel = tmo.tmo_arancel inner join ra_per_personas as p 
					 on p.per_codigo = art.per_codigo

			   where art.per_codigo = @codper and art.ciclo = @codcil and vst.are_tipo = 'PREESPECIALIDAD'
			   and are_cuota not in
			   (
					 select vst.are_cuota
					 from col_mov_movimientos as mov inner join col_dmo_det_mov as dmo
							on dmo.dmo_codmov = mov.mov_codigo inner join col_tmo_tipo_movimiento as tmo
							on tmo.tmo_codigo =  dmo.dmo_codtmo inner join vst_Aranceles_x_Evaluacion as vst
							on vst.tmo_arancel = tmo.tmo_arancel and vst.are_codtmo = tmo.tmo_codigo 
					 where mov_codper = @codper and dmo_codcil = @codcil and vst.are_tipo = 'PREESPECIALIDAD' and mov_estado <> 'A'       
			   )
			   order by vst.are_cuota, art.fel_fecha_mora asc
		end	--	if exists(select 1 from col_art_archivo_tal_preesp_mora where per_codigo = @codper and ciclo > @codcil)


		if exists(select 1 from col_art_archivo_tal_proc_grad_tec_dise_mora where per_codigo = @codper/* and ciclo > @codcil*/)
		begin
			set @validador_pregrado = 0
			print 'alumno de pre Especializacion Tecnico Diseño Grafico'

			select @codcil = max(ciclo) from col_art_archivo_tal_proc_grad_tec_dise_mora where per_codigo = @codper 

			--select * from col_art_archivo_tal_proc_grad_tec_dise_mora where per_codigo = @codper and ciclo > @codcil
			--	PRE ESPECIALIDAD TECNICOS
			select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
				art.tmo_arancel, art.fel_fecha_mora as fel_fecha_mora, art.ciclo as ciclo, art.mciclo, tmo.tmo_descripcion, 
				case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end as Monto, NPE			
			from col_art_archivo_tal_proc_grad_tec_dise_mora as art
				--inner join alumnos_por_arancel_maestria as apama on apama.codcil = art.ciclo and apama.per_codigo = art.per_codigo
				inner join col_fel_fechas_limite_tecnicos_dise as fel on fel.fel_codcil = art.ciclo --and fel.fel_codtmo = apama.tmo_codigo --and fel.origen = art.origen
				inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_arancel = art.tmo_arancel
			where art.per_codigo = @codper 
			and tmo.tmo_arancel not in (
					SELECT tmo_arancel 
					FROM col_mov_movimientos 
					join col_dmo_det_mov on dmo_codmov = mov_codigo
					join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
					WHERE 
					mov_codper = @codper 
					and dmo_codcil >= @codcil--ciclo--MAX(art.ciclo)
					and mov_estado <> 'A'
				)
			and art.ciclo >= @codcil
			---- EXEC sp_cuotas_estudiantes_maestrias 3,188459
			--GROUP BY art.per_codigo, art.per_carnet, art.per_nombres_apellidos, art.tmo_arancel,
			--art.fecha, art.mciclo, tmo.tmo_descripcion, art.tmo_valor
			order by art.fel_fecha_mora asc
		end	--	if exists(select 1 from col_art_archivo_tal_preesp_mora where per_codigo = @codper and ciclo > @codcil)

		if exists(select 1 from col_art_archivo_tal_proc_grad_tec_mora where per_codigo = @codper/* and ciclo > @codcil*/)
		begin
			set @validador_pregrado = 0
			print 'alumno de pre Especializacion Tecnico '

			select @codcil = max(ciclo) from col_art_archivo_tal_proc_grad_tec_mora where per_codigo = @codper 

			--select * from col_art_archivo_tal_proc_grad_tec_dise_mora where per_codigo = @codper and ciclo > @codcil
			--	PRE ESPECIALIDAD TECNICOS
			select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
				art.tmo_arancel, art.fel_fecha_mora, --MAX(art.ciclo) as ciclo, 
				art.ciclo as ciclo, art.mciclo, tmo.tmo_descripcion, 
				case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end as Monto, NPE
			--art.tmo_valor as Monto
			from col_art_archivo_tal_proc_grad_tec_mora as art
				--inner join alumnos_por_arancel_maestria as apama on apama.codcil = art.ciclo and apama.per_codigo = art.per_codigo
				inner join col_fel_fechas_limite_tecnicos as fel on fel.fel_codcil = art.ciclo --and fel.fel_codtmo = apama.tmo_codigo --and fel.origen = art.origen
				inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_arancel = art.tmo_arancel
			where art.per_codigo = @codper 
			and tmo.tmo_arancel not in (
					SELECT tmo_arancel 
					FROM col_mov_movimientos 
					join col_dmo_det_mov on dmo_codmov = mov_codigo
					join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
					WHERE 
					mov_codper = @codper 
					and dmo_codcil >= @codcil--ciclo--MAX(art.ciclo)
					and mov_estado <> 'A'
				)
			and art.ciclo >= @codcil
			---- EXEC sp_cuotas_estudiantes_maestrias 3,188459
			--GROUP BY art.per_codigo, art.per_carnet, art.per_nombres_apellidos, art.tmo_arancel,
			--	art.fecha, art.mciclo, tmo.tmo_descripcion, 
			--	case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end
			order by art.fel_fecha_mora asc
		end	--	if exists(select 1 from col_art_archivo_tal_preesp_mora where per_codigo = @codper and ciclo > @codcil)
		--select * from col_fel_fechas_limite_tecnicos
		--select * from col_art_archivo_tal_proc_grad_tec_mora
		--if exists(select 1 from col_art_archivo_tal_proc_grad_tec_mora where per_codigo = @codper and ciclo > @codcil)
		--begin
		--	set @validador_pregrado = 0
		--	print 'alumno de pre Especializacion Tecnicos'
		--	--select * from col_art_archivo_tal_proc_grad_tec_mora where per_codigo = @codper and ciclo > @codcil
		--	--	PRE ESPECIALIDAD TECNICOS
		--	select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
		--	art.tmo_arancel, art.fecha, MAX(art.ciclo) as ciclo, art.mciclo, tmo.tmo_descripcion
		--	from col_art_archivo_tal_proc_grad_tec_mora as art
		--		--inner join alumnos_por_arancel_maestria as apama on apama.codcil = art.ciclo and apama.per_codigo = art.per_codigo
		--		inner join col_fel_fechas_limite_tecnicos as fel on fel.fel_codcil = art.ciclo --and fel.fel_codtmo = apama.tmo_codigo --and fel.origen = art.origen
		--		inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_arancel = art.fel_codtmo
		--	where art.per_codigo = @codper 
		--	and tmo.tmo_arancel not in (
		--			SELECT tmo_arancel 
		--			FROM col_mov_movimientos 
		--			join col_dmo_det_mov on dmo_codmov = mov_codigo
		--			join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
		--			WHERE 
		--			mov_codper = @codper 
		--			and dmo_codcil > @codcil--ciclo--MAX(art.ciclo)
		--		)
		--	and art.ciclo > @codcil
		--	---- EXEC sp_cuotas_estudiantes_maestrias 3,188459
		--	GROUP BY art.per_codigo, art.per_carnet, art.per_nombres_apellidos, art.tmo_arancel,
		--	art.fecha, art.mciclo, tmo.tmo_descripcion
		--end	--	if exists(select 1 from col_art_archivo_tal_preesp_mora where per_codigo = @codper and ciclo > @codcil)
		
		if (@validador_pregrado = 1)
		begin
			print 'el alumno es de pregrado'
			select @codcil = min(ciclo) from col_art_archivo_tal_mora where per_codigo = @codper
			print '@codcil : ' + cast(@codcil as nvarchar(10))



			--select tmo.tmo_arancel, t.per_codigo as codper, 1 as cantidad, 
			--	'Pendiente' as Estado, tmo.tmo_descripcion, vst.are_cuota, t.ciclo
			select art.per_codigo, art.per_carnet, art.per_nombres_apellidos, art.tmo_arancel, art.fel_fecha_mora, art.ciclo, art.mciclo, tmo.tmo_descripcion, 
				case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end as Monto, NPE
				--t.tmo_valor as Monto
			from col_tmo_tipo_movimiento as tmo inner join vst_Aranceles_x_Evaluacion as vst
				on vst.tmo_arancel = tmo.tmo_arancel and vst.are_codtmo = tmo.tmo_codigo inner join col_art_archivo_tal_mora as art 
				on art.tmo_arancel = tmo.tmo_arancel inner join ra_per_personas as p 
				on p.per_codigo = art.per_codigo

			where art.per_codigo = @codper and art.ciclo = @codcil and vst.are_tipo = 'PREGRADO'
			and are_cuota not in
			(
				select vst.are_cuota
				from col_mov_movimientos as mov inner join col_dmo_det_mov as dmo
					on dmo.dmo_codmov = mov.mov_codigo -- and dmo.dmo_codcil = mov.mov_codcil 
					inner join col_tmo_tipo_movimiento as tmo
					on tmo.tmo_codigo =  dmo.dmo_codtmo inner join vst_Aranceles_x_Evaluacion as vst
					on vst.tmo_arancel = tmo.tmo_arancel and vst.are_codtmo = tmo.tmo_codigo 
				where mov_codper = @codper and dmo_codcil = @codcil and vst.are_tipo = 'PREGRADO' and mov_estado <> 'A'		
			)
			order by vst.are_cuota, art.fel_fecha_mora asc
			--select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
			--art.tmo_arancel, art.fel_fecha_mora,-- MAX(art.ciclo) as ciclo, 
			--art.ciclo,
			--art.mciclo, t.tmo_descripcion, art.tmo_valor as Monto
			--from col_art_archivo_tal_mora as art inner join col_tmo_tipo_movimiento as t on t.tmo_arancel = art.tmo_arancel
			--where cast(art.ciclo as nvarchar(10)) + '-' + t.tmo_arancel not in 
			--(
			--		SELECT cast(dmo_codcil as nvarchar(10)) + '-' + vst.tmo_arancel
			--		FROM col_mov_movimientos 
			--		join col_dmo_det_mov on dmo_codmov = mov_codigo
			--		join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
			--		join vst_Aranceles_x_Evaluacion as vst on vst.are_codtmo = dmo_codtmo
			--		WHERE mov_codper = @codper 
			--		and dmo_codcil >= @codcil--ciclo--MAX(art.ciclo)
			--		and tde_nombre = 'Pre grado' and mov_estado <> 'A'
			--	)
			--and per_codigo = @codper 
			--order by art.fel_fecha_mora asc
		end	--	if (@validador_pregrado = 1)




		--select * from col_art_archivo_tal_preesp_mora WHERE per_codigo = @codper
	END


	-- MAESTRIAS
	IF @car_codtde = 2
	BEGIN
		print 'Maestrias'
		declare @codcil_mae_min int, @codcil_mae_max int

		select @codcil_mae_min = min(ciclo) from col_art_archivo_tal_mae_mora where per_codigo = @codper
		select @codcil_mae_max = max(ciclo) from col_art_archivo_tal_mae_mora where per_codigo = @codper


		--select @codcil_mae_min = min(ciclo) from col_art_archivo_tal_mae_mora where per_codigo = @codper
		if (@codcil <> @codcil_mae_min)
		begin
			print 'El estudiante es de graduacion, ya que no inscribio materias en el ciclo que paga las cuotas'
			set @codcil = @codcil_mae_min
		end

		declare @tbl_cuotas_pagadas table (per_codigo int, matricula int, cuota_1 int, cuota_2 int, cuota_3 int, cuota_4 int, cuota_5 int, cuota_6 int)
		insert into @tbl_cuotas_pagadas
		select distinct per_codigo,sum([0]) as [Matricula],sum([1])  as [1° Cuota],sum([2]) as [2° Cuota],
		sum([3])  as [3 Cuota],sum([4]) as [4° Cuota],sum([5])   as [5° Cuota],sum([6]) as [6° Cuota]
		from (
			select
			per_codigo,tmo_codigo,case n when 'M' then '0' else n end n,tmo_descripcion,t.tipo
			from (
				select distinct per_codigo, per_carnet, tmo.tmo_arancel,
				tmo.tmo_codigo, substring(tmo.tmo_descripcion,1,1) n, tmo.tmo_descripcion,
				case substring(tmo.tmo_arancel,1,1)
				when 'C' then 'U'
				when 'S' then 'U'
				else substring(tmo.tmo_arancel,1,1) end tipo
				from col_mov_movimientos
					join col_dmo_det_mov on dmo_codmov=mov_codigo
					join ra_per_personas on per_codigo=mov_codper
					join ra_ins_inscripcion on ins_codper=per_codigo
					join col_tmo_tipo_movimiento as tmo on dmo_codtmo = tmo.tmo_codigo
					join vst_aranceles_x_evaluacion as v on v.are_codtmo = tmo.tmo_codigo
				where per_tipo='M' and dmo_codcil = @codcil_mae_min 
					and mov_estado <> 'A' and tde_nombre = 'Maestrias' and are_tipo = 'MAESTRIAS'
					and mov_codper = @codper
			) t
		) l
		PIVOT (
			count(tmo_Codigo)
			FOR n IN ([0],[1],[2],[3],[4],[5],[6])
		) AS pivo
		group by per_codigo
		order by per_codigo

		if not exists (select 1 from @tbl_cuotas_pagadas where (matricula + cuota_1 + cuota_2 + cuota_3 + cuota_4 + cuota_5 + cuota_6) >= 7)
		begin
			print 'Debe cuotas del ciclo anterior'
			set @codcil = @codcil_mae_min
		end
		else
		begin
			print 'No debe cuotas del ciclo anterior'
			set @codcil = @codcil_mae_max
		end

		if (@codcil is null) -- si no a inscrito
		begin
			print 'El estudiante no a inscrito'
			set @codcil = @codcil_mae_min
		end

		print '@codcil_mae_min : ' + cast(@codcil_mae_min as nvarchar(10))
		print '@codcil_mae_max : ' + cast(@codcil_mae_max as nvarchar(10))
		print '@codcil: ' + cast(@codcil as nvarchar(10))

		select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
			art.tmo_arancel, art.fel_fecha_mora,-- MAX(art.ciclo) as ciclo, 
			art.ciclo, art.mciclo, t.tmo_descripcion, --art.tmo_valor as Monto
			--case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end as Monto, 
			case when art.fel_fecha_mora >= getdate() then art.cuota_pagar else art.cuota_pagar_mora end as Monto, 
			NPE
		from col_art_archivo_tal_mae_mora as art 
			--inner join alumnos_por_arancel_maestria as apama on apama.codcil = art.ciclo and apama.per_codigo = art.per_codigo
			--inner join col_fel_fechas_limite_mae_mora as fel on fel.fel_codcil = apama.codcil and fel.fel_codtmo = apama.tmo_codigo and fel.origen = art.origen
			--inner join col_tmo_tipo_movimiento as t on t.tmo_arancel = art.tmo_arancel

			inner join col_tmo_tipo_movimiento as t on t.tmo_arancel = art.tmo_arancel
			inner join col_fel_fechas_limite_mae_mora as fel on fel.fel_codcil = @codcil and fel.fel_codtmo = t.tmo_codigo 
				--and fel.origen = art.origen--quitado el 31/01/2024 16:15, Fabio

		where concat(cast(art.ciclo as nvarchar(10)), '-', t.tmo_arancel) not in (
			SELECT concat(cast(dmo_codcil as nvarchar(10)), '-', vst.tmo_arancel)
			FROM col_mov_movimientos 
				join col_dmo_det_mov on dmo_codmov = mov_codigo
				join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
				join vst_Aranceles_x_Evaluacion as vst on vst.are_codtmo = dmo_codtmo
			WHERE mov_codper = @codper and dmo_codcil >= @codcil and tde_nombre = 'Maestrias' and mov_estado <> 'A'
		) and art.per_codigo = @codper 
		and ciclo = @codcil
		order by art.mciclo asc, art.fel_fecha_mora asc

	END

	
	--POSTGRADO
	IF @car_codtde = 3 or @car_codtde = 6
	BEGIN
		print 'El Alumno es de postgrado - Curso Especializado'
		--select @codcil = min(ciclo) from col_art_archivo_tal_mae_posgrado where per_codigo = @codper
		select @codcil = min(ciclo) from col_art_archivo_tal_mae_mora where per_codigo = @codper
		print '@codcil : ' + cast(@codcil as nvarchar(10))

		select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
			art.tmo_arancel, art.fel_fecha_mora, art.ciclo as ciclo, art.mciclo, tmo.tmo_descripcion, --art.tmo_valor as Monto
			case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end as Monto, NPE
		from col_art_archivo_tal_mae_mora as art
			inner join col_fel_fechas_limite_mae_mora as fel on fel.fel_codcil = art.ciclo 
			inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_arancel = art.tmo_arancel and fel.fel_codtmo = tmo.tmo_codigo
		--select @codcil = min(ciclo) from col_art_archivo_tal_mae_posgrado where per_codigo = @codper
		--print '@codcil : ' + cast(@codcil as nvarchar(10))

		--select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
		--	art.tmo_arancel, art.fel_fecha_mora, art.ciclo as ciclo, art.mciclo, tmo.tmo_descripcion, --art.tmo_valor as Monto
		--	case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end as Monto, NPE
		--from col_art_archivo_tal_mae_posgrado as art
		--inner join alumnos_por_arancel_maestria_posgrado as apamp on apamp.codcil = art.ciclo and apamp.per_codigo = art.per_codigo
		--inner join col_fel_fechas_limite_mae_pg as fel on fel.fel_codcil = apamp.codcil and fel.fel_codtmo = apamp.tmo_codigo --and fel.origen = art.origen
		--inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_arancel = art.tmo_arancel
		where 
		--apamp.per_codigo = @codper
		art.per_codigo = @codper
		and tmo.tmo_arancel not in (
				SELECT tmo_arancel 
				FROM col_mov_movimientos 
				join col_dmo_det_mov on dmo_codmov = mov_codigo
				join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
				WHERE 
				mov_codper = @codper 
				and dmo_codcil = @codcil and mov_estado <> 'A'
		)
		--and apamp.codcil = @codcil
		and art.ciclo = @codcil
		order BY art.fel_fecha_mora asc

		--select * from alumnos_por_arancel_maestria_posgrado where per_codigo = 193884
	END

END
go

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[web_ptl_login_info_fqdn]    Script Date: 16/4/2024 11:04:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	-- exec web_ptl_login_info_fqdn 'SE01182024'
	-- exec web_ptl_login_info_fqdn '2515652015'
ALTER procedure[dbo].[web_ptl_login_info_fqdn]
	@cuenta varchar(50) = ''
as
begin
	declare @cuenta_codigo int,@carnet varchar(12), @cil_codigo int

	set @cuenta = replace(@cuenta, '-', '')

	select @cil_codigo = cil_codigo from ra_cil_ciclo where cil_vigente = 'S'
	print '@cil_codigo ' + cast(@cil_codigo as varchar(5)) 

	if exists(
		select 1 from ra_per_personas 
		where (per_correo_institucional=(@cuenta+'@mail.utec.edu.sv') or substring(@cuenta,1,1) in ('0','1','2','3','4','5','6','7','8','9')) 
			and not exists (select 1 from  pla_emp_empleado where emp_email_institucional = @cuenta+'@mail.utec.edu.sv')
	)
	begin
		print 'alumno'
		set @carnet = substring(@cuenta,1,2)+'-'+substring(@cuenta,3,4)+'-'+substring(@cuenta,7,4)
		select top 1 @cuenta_codigo = per_codigo from ra_per_personas where( per_carnet = @carnet  or per_correo_institucional=(@cuenta+'@mail.utec.edu.sv'))

		if (select count(1) from pg_imp_ins_especializacion join pg_apr_aut_preespecializacion on apr_codigo = imp_codapr join ra_cil_ciclo on cil_codigo = apr_codcil
					where cil_vigente_pre = 'S' and imp_codper = @cuenta_codigo and apr_codcil = @cil_codigo)>0 or (select count(1) from ra_egr_egresados join ra_cil_ciclo on cil_codigo = egr_codcil 
					join ra_per_personas on per_codigo = egr_codper 
						inner join ra_alc_alumnos_carrera on alc_codper = egr_codper and alc_codpla = egr_codpla--AGREGADO EL 04/07/2020 PARA VALIDAR QUE EGRESO CON EL MISMO PLAN ACTUAL
					where egr_codper = @cuenta_codigo and per_tipo <> 'M'
					and not exists(select 1 from ra_ins_inscripcion where ins_codcil = @cil_codigo and ins_codper = @cuenta_codigo and not exists (select 1 from ra_mai_mat_inscritas_especial where mai_codins = ins_codigo)) )>0

					or (@cuenta_codigo = 230997)
		begin
			print 'es de la pre'
			select 'Estudiantes' tipo,'Pre Especialidad' facultad, '' carrera, ltrim(rtrim(car_tipo)) tc
			from ra_per_personas --join ra_ins_inscripcion on ins_codper = per_codigo
				join ra_alc_alumnos_carrera on alc_codper = per_codigo
				join ra_pla_planes on pla_codigo = alc_codpla
				join ra_car_carreras on car_codigo = pla_codcar
				join ra_fac_facultades on fac_codigo = car_codfac
			where per_codigo = @cuenta_codigo 
		end
		else
		begin
			print 'es de pregrado'

			if exists (select 1 from dip_ped_personas_dip where ped_codper = @cuenta_codigo)
			begin
				select distinct 'Estudiantes' tipo,fac_nombre facultad, per_tipo carrera, ltrim(rtrim(dip_prefijo)) tc 
					from ra_per_personas
					join dip_ped_personas_dip on ped_codper = per_codigo
					join dip_dip_diplomados on ped_coddip = dip_codigo
					--join ra_car_carreras on car_codigo = pla_codcar
					join ra_fac_facultades on fac_codigo = dip_codfac
				where per_codigo = @cuenta_codigo
			end
			else
			begin
				select distinct 'Estudiantes' tipo,fac_nombre facultad,car_identificador carrera, ltrim(rtrim(car_tipo)) tc from ra_per_personas --join ra_ins_inscripcion on ins_codper = per_codigo
					join ra_alc_alumnos_carrera on alc_codper = per_codigo
					join ra_pla_planes on pla_codigo = alc_codpla
					join ra_car_carreras on car_codigo = pla_codcar
					join ra_fac_facultades on fac_codigo = car_codfac
				where per_codigo = @cuenta_codigo
			end
		end
	end
	else
	begin
		select 'Docentes' as tipo,'' facultad, '' carrera, '' tc from pla_emp_empleado where emp_email_institucional = @cuenta+'@mail.utec.edu.sv' and emp_estado in ('A', 'J')
	end

end
go

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_consulta_pago_x_carnet_estructurado]    Script Date: 16/4/2024 11:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:		<Juan Carlos Campos>
	-- Create date: <Lunes 21 Mayo 2018>
	-- Last Modify: <Fabio, 2022-03-08 08:51:13>
	-- Description:	<Mostrar la informacion de la cuota a pagar segun el carnet del estudiante>
	-- =============================================
	-- exec sp_consulta_pago_x_carnet_estructurado 2, '3263222013'				-- Por carnet
	-- exec sp_consulta_pago_x_carnet_estructurado 2, '0313010000000023995310220210' -- Por NPE

ALTER PROCEDURE [dbo].[sp_consulta_pago_x_carnet_estructurado]
	@opcion int,			--	1: Mostrar todos, 2: mostrar la proxima cuota
	@carnet nvarchar(64)	-- Carnet o NPE
AS
BEGIN
	
	set nocount on;
	set dateformat dmy

	declare @codcil_maximo int, @codcil_minimo int, @alumno_encontrado int, @TipoEstudiante nvarchar(50)
	declare @codcil_cursor int
	
	set @alumno_encontrado = 0
	set @TipoEstudiante = ''

	DECLARE 
			@per_tipo nvarchar(5),
			@estado char(1),
			@codper int,
			@codcil int,
			@orden int,
			@NPE varchar(28),
			@codper_de_NPE int

	select @codper = per_codigo, @per_tipo = per_tipo, @estado = per_estado, @carnet = per_carnet from ra_per_personas
	where replace(per_carnet, '-', '') = replace(@carnet, '-', '')
	
	if len(@carnet) > 16 -- ES NPE
	begin
		select @codper_de_NPE = cast(substring(@carnet, 11, 10) as int) --	El codper inicia en la posicion 11 del npe
		select @codper = per_codigo, @per_tipo = per_tipo, @estado = per_estado, @carnet = per_carnet from ra_per_personas
		where per_codigo = @codper_de_NPE
	end

	declare @temp table (
		alumno varchar(150),
		carnet varchar(20),
		carrera varchar(150),
		npe nvarchar(50),
		monto varchar(15),
		descripcion varchar(250),
		estado varchar(2),
		tmo_arancel nvarchar(10),
		fel_fecha_mora nvarchar(10),
		ciclo int,
		mciclo nvarchar(10),
		orden int
	)
	PRINT 'codper: '+cast(@codper as varchar)+' carnet: '+@carnet+' tipo: '+@per_tipo+' estado: '+@estado



		--print 'Verificando el tipo de estudiante'
		--select @per_tipo = per_tipo from ra_per_personas where per_carnet = @carnet
		--select * from col_art_archivo_tal_mae_mora where per_carnet = '43-0272-2016'
		if (@per_tipo = 'M')
		begin
			print 'Alumno es de MAESTRIAS'
			set @TipoEstudiante = 'Maestrias'
			if exists(select 1 from col_art_archivo_tal_mae_mora where per_carnet = @carnet)
			begin
				select @codcil_maximo = max(ciclo) from col_art_archivo_tal_mae_mora where per_codigo = @codper 
				select @codcil_minimo = min(ciclo) from col_art_archivo_tal_mae_mora where per_codigo = @codper

				Insert into @temp (alumno, carnet, carrera, npe, monto, descripcion, estado, tmo_arancel, fel_fecha_mora, ciclo, mciclo, orden)
				select art.per_nombres_apellidos as alumno, art.per_carnet as carnet, art.pla_alias_carrera as carrera,					
					case when (DATEDIFF(day, getdate(), fel_fecha) < 0)  
						then art.NPE_mora 
						else art.npe 
					end as npe,
					case when (DATEDIFF(day, getdate(), fel_fecha) < 0)  
						then art.cuota_pagar_mora 
						else art.cuota_pagar 
					end as monto,
					tmo.tmo_descripcion as descripcion, 1 as estado, tmo.tmo_arancel, 
					case when (DATEDIFF(day, getdate(), fel_fecha) < 0) 
						then CONVERT(VarChar(12), art.fel_fecha_mora, 103) 
						else CONVERT(VarChar(12), art.fel_fecha, 103) 
					end as fel_fecha_mora,
					art.ciclo, art.mciclo, art.fel_codigo_barra
				from col_art_archivo_tal_mae_mora as art inner join col_tmo_tipo_movimiento as tmo on
					art.tmo_arancel = tmo.tmo_arancel
				where art.tmo_arancel + cast(ciclo as nvarchar(5)) in
				(
					select tmo_arancel + cast(ciclo as nvarchar(5)) as arancel  
					from col_art_archivo_tal_mae_mora 
					where per_codigo = @codper and ciclo >= @codcil_minimo --  @codcil_maximo
					except
					select tmo.tmo_arancel + cast(dmo_codcil as nvarchar(5)) from col_mov_movimientos
					join col_dmo_det_mov on dmo_codmov=mov_codigo
					join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo_codtmo
					--join col_art_archivo_tal_mora as tal on tal.tmo_arancel = tmo.tmo_arancel and tal.ciclo = mov_codcil and tal.per_codigo = mov_codper
					where mov_codper = @codper and mov_estado<>'A' and dmo_codcil >= @codcil_minimo -- @codcil_maximo 
				) 
				and art.per_codigo = @codper and art.ciclo >= @codcil_minimo -- @codcil_maximo
				order by fel_fecha asc, fel_codigo_barra asc
			end	--	if exists(select 1 from col_art_archivo_tal_mae_mora where per_carnet = @carnet)
		end	--	if (@per_tipo = 'M')

		if (@per_tipo = 'O') or (@per_tipo = 'CE')
		begin
			if @per_tipo = 'O'
			begin
				set @TipoEstudiante = 'POST GRADOS de MAESTRIAS'
			end
			if @per_tipo = 'CE'
			begin
				set @TipoEstudiante = 'CURSO ESPECIALIZADO de MAESTRIAS'
			end
			print @TipoEstudiante
			if exists(select 1 from col_art_archivo_tal_mae_mora where per_carnet = @carnet)
			begin
				select @codcil_maximo = max(ciclo) from col_art_archivo_tal_mae_mora where per_codigo = @codper 

				Insert into @temp (alumno, carnet, carrera, npe, monto, descripcion, estado, tmo_arancel, fel_fecha_mora, ciclo, mciclo, orden)
				select art.per_nombres_apellidos as alumno, art.per_carnet as carnet, art.pla_alias_carrera as carrera,
					case when (DATEDIFF(day, getdate(), fel_fecha) < 0)  
						then art.NPE_mora 
						else art.npe 
					end as npe,
					case when (DATEDIFF(day, getdate(), fel_fecha) < 0)  
						then art.tmo_valor_mora 
						else art.tmo_valor 
					end as monto,
					tmo.tmo_descripcion as descripcion, 1 as estado, tmo.tmo_arancel, 
					case when (DATEDIFF(day, getdate(), fel_fecha) < 0) 
						then CONVERT(VarChar(12), art.fel_fecha_mora, 103) 
						else CONVERT(VarChar(12), art.fel_fecha, 103) 
					end as fel_fecha_mora,
					art.ciclo, art.mciclo, art.fel_codigo_barra
				from col_art_archivo_tal_mae_mora as art inner join col_tmo_tipo_movimiento as tmo on
					art.tmo_arancel = tmo.tmo_arancel
				where art.tmo_arancel in
				(
					select tmo_arancel as arancel from col_art_archivo_tal_mae_mora 
					where per_codigo = @codper and ciclo >= @codcil_maximo
					except
					select tmo.tmo_arancel from col_mov_movimientos
					join col_dmo_det_mov on dmo_codmov=mov_codigo
					join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo_codtmo
					--join col_art_archivo_tal_mora as tal on tal.tmo_arancel = tmo.tmo_arancel and tal.ciclo = mov_codcil and tal.per_codigo = mov_codper
					where mov_codper = @codper and mov_estado<>'A' and dmo_codcil >= @codcil_maximo 
				) 
				and art.per_codigo = @codper and art.ciclo >= @codcil_maximo
				order by fel_fecha asc, fel_codigo_barra asc
			end	--	if exists(select 1 from col_art_archivo_tal_mae_mora where per_carnet = @carnet)
		end	--	if (@per_tipo = 'O') or (@per_tipo = 'CE')

		if (@per_tipo = 'U')
		begin
			print 'Alumno es de PRE-GRADO'
	
			if exists(select 1 from col_art_archivo_tal_mora where per_carnet = @carnet)
			begin
				set @alumno_encontrado = 1
				set @TipoEstudiante = 'PRE GRADO'
				print @TipoEstudiante
					
				DECLARE cursor_codcil CURSOR FOR 
					select distinct ciclo from col_art_archivo_tal_mora 
					where per_codigo = @codper order by ciclo asc

				OPEN cursor_codcil 
				FETCH NEXT FROM cursor_codcil INTO @codcil_cursor
				WHILE @@FETCH_STATUS = 0 
				BEGIN
					PRINT '@codcil_cursor :' + cast(@codcil_cursor as nvarchar(10))

					Insert into @temp (alumno, carnet, carrera, npe, monto, descripcion, estado, tmo_arancel, fel_fecha_mora, ciclo, mciclo, orden)
					select art.per_nombres_apellidos as alumno, art.per_carnet as carnet, art.pla_alias_carrera as carrera,
						case when (DATEDIFF(day, getdate(), art.fel_fecha) < 0) 
							then art.NPE_mora 
							else art.npe 
						end as npe,
						case when (DATEDIFF(day, getdate(), art.fel_fecha) < 0) 
							then art.tmo_valor_mora 
							else art.tmo_valor 
						end as monto,
						tmo.tmo_descripcion as descripcion, 1 as estado, tmo.tmo_arancel, 
						case when (DATEDIFF(day, getdate(), art.fel_fecha) < 0) 
							then CONVERT(VarChar(12), art.fel_fecha_mora, 103) 
							else CONVERT(VarChar(12), art.fel_fecha, 103) 
						end as fel_fecha_mora,
						art.ciclo, art.mciclo, art.fel_codigo_barra
					from col_art_archivo_tal_mora as art inner join col_tmo_tipo_movimiento as tmo on
						art.tmo_arancel = tmo.tmo_arancel
					where art.tmo_arancel in
					(
						select art.tmo_arancel	
						from col_art_archivo_tal_mora as art join 
						col_tmo_tipo_movimiento as tmo on tmo.tmo_arancel = art.tmo_arancel join 
						vst_Aranceles_x_Evaluacion on are_codtmo = tmo.tmo_codigo
						where nucuo_numcuota  in

						(
							select --art.tmo_arancel, 
							nucuo_numcuota 
							from col_art_archivo_tal_mora as art join 
							col_tmo_tipo_movimiento as tmo on tmo.tmo_arancel = art.tmo_arancel join 
							vst_Aranceles_x_Evaluacion on are_codtmo = tmo.tmo_codigo and are_tipo = 'PREGRADO'
							where per_codigo = @codper and ciclo = @codcil_cursor

						--select tmo_arancel as arancel from col_art_archivo_tal_mora where per_codigo = @codper and ciclo = @codcil_cursor
							except
							select --tmo.tmo_arancel, 
							nucuo_numcuota from col_mov_movimientos
							join col_dmo_det_mov on dmo_codmov=mov_codigo
							join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo_codtmo
							join vst_Aranceles_x_Evaluacion on are_codtmo = dmo_codtmo
							where mov_codper = @codper and mov_estado<>'A' and dmo_codcil = @codcil_cursor  and are_tipo = 'PREGRADO'
						
						--select tmo.tmo_arancel from col_mov_movimientos
						--join col_dmo_det_mov on dmo_codmov=mov_codigo
						--join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo_codtmo
						----join col_art_archivo_tal_mora as tal on tal.tmo_arancel = tmo.tmo_arancel and tal.ciclo = mov_codcil and tal.per_codigo = mov_codper
						--where mov_codper = @codper and mov_estado<>'A' and dmo_codcil = @codcil_cursor
						)  and are_tipo = 'PREGRADO'
					) 
					and art.per_codigo = @codper and art.ciclo = @codcil_cursor
					order by fel_fecha asc, fel_codigo_barra asc

					FETCH NEXT FROM cursor_codcil INTO @codcil_cursor
				END 
				CLOSE cursor_codcil 
				DEALLOCATE cursor_codcil

				select @codcil_maximo = max(ciclo) from col_art_archivo_tal_mora where per_codigo = @codper 
			end	--	if exists(select 1 from col_art_archivo_tal_mora where per_carnet = @carnet)

			if @alumno_encontrado = 0
			begin
				if exists(select 1 from col_art_archivo_tal_preesp_mora where per_carnet = @carnet)
				begin
					set @alumno_encontrado = 1
					set @TipoEstudiante = 'PRE ESPECIALIDAD CARRERA'
					print @TipoEstudiante
					select @codcil_maximo = max(ciclo) from col_art_archivo_tal_preesp_mora where per_codigo = @codper 
					print  '@codcil_maximo ' + cast(@codcil_maximo as nvarchar(6))

					Insert into @temp (alumno, carnet, carrera, npe, monto, descripcion, estado, tmo_arancel, fel_fecha_mora, ciclo, mciclo, orden)				
					select art.per_nombres_apellidos as alumno, art.per_carnet as carnet, art.pla_alias_carrera as carrera,
						case when (DATEDIFF(day, getdate(), art.fel_fecha) < 0) 
							then art.NPE_mora 
							else art.npe 
						end as npe,
						case when (DATEDIFF(day, getdate(), art.fel_fecha) < 0) 
							then art.tmo_valor_mora 
							else art.tmo_valor 
						end as monto,
						tmo.tmo_descripcion as descripcion, 1 as estado, tmo.tmo_arancel, 
						case when (DATEDIFF(day, getdate(), art.fel_fecha) < 0) 
							then CONVERT(VarChar(12), art.fel_fecha_mora, 103) 
							else CONVERT(VarChar(12), art.fel_fecha, 103) 
						end as fel_fecha_mora,
						art.ciclo, art.mciclo, /*art.fel_codigo_barra */ fel_orden
					from col_art_archivo_tal_preesp_mora as art inner join col_tmo_tipo_movimiento as tmo on
						art.tmo_arancel = tmo.tmo_arancel
					where art.tmo_arancel in
					(
						select art.tmo_arancel	
						from col_art_archivo_tal_preesp_mora as art join 
						col_tmo_tipo_movimiento as tmo on tmo.tmo_arancel = art.tmo_arancel join 
						vst_Aranceles_x_Evaluacion on are_codtmo = tmo.tmo_codigo
						where nucuo_numcuota  in
						(
							select --art.tmo_arancel, 
							nucuo_numcuota 
							from col_art_archivo_tal_preesp_mora as art join 
							col_tmo_tipo_movimiento as tmo on tmo.tmo_arancel = art.tmo_arancel join 
							vst_Aranceles_x_Evaluacion on are_codtmo = tmo.tmo_codigo
							where per_codigo = @codper and ciclo = @codcil_maximo and are_tipo = 'PREESPECIALIDAD'

							except
							select --tmo.tmo_arancel, 
							nucuo_numcuota from col_mov_movimientos
							join col_dmo_det_mov on dmo_codmov=mov_codigo
							join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo_codtmo
							join vst_Aranceles_x_Evaluacion on are_codtmo = dmo_codtmo
							where mov_codper = @codper and mov_estado<>'A' and dmo_codcil=@codcil_maximo and are_tipo = 'PREESPECIALIDAD'
						) and are_tipo = 'PREESPECIALIDAD' 
					)  
					and art.per_codigo = @codper and art.ciclo = @codcil_maximo
					order by fel_fecha asc, fel_orden asc
				end	--	if exists(select 1 from col_art_archivo_tal_mora where per_carnet = @carnet)
			end	--	if @alumno_encontrado = 0
			
			if @alumno_encontrado = 0
			begin
				if exists(select 1 from col_art_archivo_tal_proc_grad_tec_dise_mora where per_carnet = @carnet)
				begin
					set @alumno_encontrado = 1
					set @TipoEstudiante = 'PRE TECNICO DE CARRERA DE DISENIO'
					print @TipoEstudiante
					select @codcil_maximo = max(ciclo) from col_art_archivo_tal_proc_grad_tec_dise_mora 
					where per_codigo = @codper 
					 
					Insert into @temp (alumno, carnet, carrera, npe, monto, descripcion, estado, tmo_arancel, fel_fecha_mora, ciclo, mciclo, orden)				
					select art.per_nombres_apellidos as alumno, art.per_carnet as carnet, art.pla_alias_carrera as carrera,
						case when (DATEDIFF(day, getdate(), art.fel_fecha) < 0) 
							then art.NPE_mora 
							else art.npe 
						end as npe,
						case when (DATEDIFF(day, getdate(), art.fel_fecha) < 0) 
							then art.tmo_valor_mora 
							else art.tmo_valor 
						end as monto,
						tmo.tmo_descripcion as descripcion, 1 as estado, tmo.tmo_arancel, 
						case when (DATEDIFF(day, getdate(), art.fel_fecha) < 0) 
							then CONVERT(VarChar(12), art.fel_fecha_mora, 103) 
							else CONVERT(VarChar(12), art.fel_fecha, 103) 
						end as fel_fecha_mora,
						art.ciclo, art.mciclo, art.fel_codigo_barra
					from col_art_archivo_tal_proc_grad_tec_dise_mora as art inner join col_tmo_tipo_movimiento as tmo on
						art.tmo_arancel = tmo.tmo_arancel
					where art.tmo_arancel in
					(
						select tmo_arancel as arancel from col_art_archivo_tal_proc_grad_tec_dise_mora where per_codigo = @codper and ciclo = @codcil_maximo
						except
						select tmo.tmo_arancel from col_mov_movimientos
						join col_dmo_det_mov on dmo_codmov=mov_codigo
						join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo_codtmo
						where mov_codper = @codper and mov_estado<>'A' and dmo_codcil=@codcil_maximo 
					) 
						and art.per_codigo = @codper and art.ciclo = @codcil_maximo
					order by fel_fecha asc, fel_codigo_barra asc
				end	--	if exists(select 1 from col_art_archivo_tal_proc_grad_tec_dise_mora where per_carnet = @carnet)
			end	--	if @alumno_encontrado = 0		

			if @alumno_encontrado = 0
			begin
				if exists(select 1 from col_art_archivo_tal_proc_grad_tec_mora where per_carnet = @carnet)
				begin
					set @alumno_encontrado = 1
					set @TipoEstudiante = 'PRE TECNICO DE CARRERA diferente de disenio'
					print @TipoEstudiante
					select @codcil_maximo = max(ciclo) from col_art_archivo_tal_proc_grad_tec_mora where per_codigo = @codper 

					Insert into @temp (alumno, carnet, carrera, npe, monto, descripcion, estado, tmo_arancel, fel_fecha_mora, ciclo, mciclo, orden)
					select art.per_nombres_apellidos as alumno, art.per_carnet as carnet, art.pla_alias_carrera as carrera,
						case when (DATEDIFF(day, getdate(), art.fel_fecha) < 0) 
							then art.NPE_mora 
							else art.npe 
							end as npe,
						case when (DATEDIFF(day, getdate(), art.fel_fecha) < 0) 
							then art.tmo_valor_mora 
							else art.tmo_valor 
						end as monto,
						tmo.tmo_descripcion as descripcion, 1 as estado, tmo.tmo_arancel, 
						case when (DATEDIFF(day, getdate(), art.fel_fecha) < 0) 
							then CONVERT(VarChar(12), art.fel_fecha_mora, 103) 
							else CONVERT(VarChar(12), art.fel_fecha, 103) 
						end as fel_fecha_mora,
						art.ciclo, art.mciclo, art.fel_codigo_barra
					from col_art_archivo_tal_proc_grad_tec_mora as art inner join col_tmo_tipo_movimiento as tmo on
						art.tmo_arancel = tmo.tmo_arancel
					where art.tmo_arancel in
					(
						select tmo_arancel as arancel from col_art_archivo_tal_proc_grad_tec_mora where per_codigo = @codper and ciclo = @codcil_maximo
						except
						select tmo.tmo_arancel from col_mov_movimientos
						join col_dmo_det_mov on dmo_codmov=mov_codigo
						join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo_codtmo
						where mov_codper = @codper and mov_estado<>'A' and dmo_codcil=@codcil_maximo 
					) 
						and art.per_codigo = @codper and art.ciclo = @codcil_maximo
					order by fel_fecha asc, fel_codigo_barra asc
				end	--	if exists(select 1 from col_art_archivo_tal_proc_grad_tec_dise_mora where per_carnet = @carnet)
			end	--	if @alumno_encontrado = 0	

			--select top 3 * from col_art_archivo_tal_mora
		end

		if exists (select 1 from dip_ped_personas_dip where ped_codper = @codper)
		begin
			print 'Alumno es de PRE-GRADO DIPLOMADOS/SEMINARIOS'
	
			if exists(select 1 from col_art_archivo_tal_mora where per_carnet = @carnet)
			begin
				set @alumno_encontrado = 1
				set @TipoEstudiante = 'DIPLOMADOS/SEMINARIOS'
				print @TipoEstudiante
					
				DECLARE cursor_codcil CURSOR FOR 
					select distinct ciclo from col_art_archivo_tal_mora 
					where per_codigo = @codper order by ciclo asc

				OPEN cursor_codcil 
				FETCH NEXT FROM cursor_codcil INTO @codcil_cursor
				WHILE @@FETCH_STATUS = 0 
				BEGIN
					PRINT '@codcil_cursor :' + cast(@codcil_cursor as nvarchar(10))

					Insert into @temp (alumno, carnet, carrera, npe, monto, descripcion, estado, tmo_arancel, fel_fecha_mora, ciclo, mciclo, orden)
					select art.per_nombres_apellidos as alumno, art.per_carnet as carnet, art.pla_alias_carrera as carrera,
						case when (DATEDIFF(day, getdate(), art.fel_fecha) < 0) 
							then art.NPE_mora 
							else art.npe 
						end as npe,
						case when (DATEDIFF(day, getdate(), art.fel_fecha) < 0) 
							then art.tmo_valor_mora 
							else art.tmo_valor 
						end as monto,
						tmo.tmo_descripcion as descripcion, 1 as estado, tmo.tmo_arancel, 
						case when (DATEDIFF(day, getdate(), art.fel_fecha) < 0) 
							then CONVERT(VarChar(12), art.fel_fecha_mora, 103) 
							else CONVERT(VarChar(12), art.fel_fecha, 103) 
						end as fel_fecha_mora,
						art.ciclo, art.mciclo, art.fel_codigo_barra
					from col_art_archivo_tal_mora as art inner join col_tmo_tipo_movimiento as tmo on
						art.tmo_arancel = tmo.tmo_arancel
					where art.per_codigo = @codper and art.ciclo = @codcil_cursor
					and art.NPE not in (
						select distinct mov_npe from col_mov_movimientos where mov_codper = @codper and mov_estado not in ('A')
					)
					order by fel_fecha asc, fel_codigo_barra asc

					FETCH NEXT FROM cursor_codcil INTO @codcil_cursor
				END 
				CLOSE cursor_codcil 
				DEALLOCATE cursor_codcil

				select @codcil_maximo = max(ciclo) from col_art_archivo_tal_mora where per_codigo = @codper 
			END 
		end

		--SELECT * FROM col_art_archivo_tal_mora where ciclo = 116 and per_carnet = '25-0713-2016'
		--SELECT tmo_valor, tmo_arancel, tmo_valor_mora, cuota_pagar, cuota_pagar_mora, tmo_arancel_beca 
		--FROM col_art_archivo_tal_mae_mora where ciclo = 116 and per_carnet = @carnet

		--select * from @temp
		print '@codper : ' + cast(@codper as nvarchar(10))
		print '@carnet : ' + @carnet
	
		print '@codcil : ' + cast(@codcil as nvarchar(10))

		print '@per_tipo : ' + @per_tipo
		print '------------------------------------------'
		--select * from col_mov_movimientos inner join col_dmo_det_mov on mov_codigo = dmo_codmov where mov_codper = @codper and dmo_codcil = @codcil and dmo_codtmo = @codtmo and mov_estado <> 'A'

		if @opcion = 1
		begin
			if @per_tipo = 'M'
			begin
				select alumno, carnet, carrera, npe, monto, descripcion, estado, tmo_arancel, fel_fecha_mora, ciclo, mciclo 
				from @temp order by ciclo, convert(date, fel_fecha_mora) asc, orden asc
			end
			else
			begin
				select alumno, carnet, carrera, npe, monto, descripcion, estado, tmo_arancel, fel_fecha_mora, ciclo, mciclo 
				from @temp order by convert(date, fel_fecha_mora) asc, orden asc
			end
		end	
		if @opcion = 2
		begin
			if @per_tipo = 'M'
			begin
				select top 1 alumno, carnet, carrera, npe, monto, descripcion, estado, tmo_arancel, fel_fecha_mora, ciclo, mciclo 
				from @temp order by ciclo, convert(date, fel_fecha_mora) asc, orden asc
			end
			else
			begin
				select top 1 alumno, carnet, carrera, npe, monto, descripcion, estado, tmo_arancel, fel_fecha_mora, ciclo, mciclo  
				from @temp order by convert(date, fel_fecha_mora) asc, orden asc
			end
		end
END
go

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_alm_diplomado]    Script Date: 19/4/2024 13:40:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	-- exec dbo.rep_alm_diplomado @codreg= 1, @codper = 181324, @codhrm = 2183, @opcion = 1, @codcil = 134
ALTER proc [dbo].[rep_alm_diplomado]
	@opcion int = 0,
	@codreg int = 0,
	@codper int = 0,
	@codhrm int = 0,
	@codcil int = 0
as
begin
	if @opcion = 1
	begin
		select uni_nombre,per_carnet,per_nombres_apellidos,dip_nombre,mdp_nombre,mes_nombre,pei_anio,fea_fecha,
			hrm_descripcion,fecha_actual,
			isnull(man_nomhor,'No Definido') man_nomhor,
			isnull(aul_nombre_corto,'No Definido') aul_nombre_corto,
			case when dias = '' then 'No Definido' else substring(dias,1,len(dias)-1) end dias,
			isnull(upper(usr_nombre), 'PROMOTOR') promotor--,fea_codcil
			, fac_codigo, fac_nombre, telefono_facultad, dip_necesita_cuenta_AD
		from
		(
			select uni_nombre,per_carnet,per_nombres_apellidos,dip_nombre,mdp_nombre,mes_nombre,pei_anio,fea_fecha,
				hrm_descripcion,usr_nombre,fecha_actual,
				max(man_nomhor) man_nomhor, 
				max(aul_nombre_corto) aul_nombre_corto,
				max(lu) + max(ma) + max(mie) + max(ju) + max(vi) + max(sa) + max(do) dias--,fea_codcil
				, fac_codigo, fac_nombre, telefono_facultad, dip_necesita_cuenta_AD
			from
			(
				select uni_nombre,per_carnet,per_nombres_apellidos,dip_nombre,mdp_nombre,mes_nombre,pei_anio,fea_fecha,
					hrm_descripcion,man_nomhor, aul_nombre_corto,(convert(varchar,getdate(),103)) as fecha_actual,
					case when dhr_dia = 1 then 'Lunes-' else '' end lu,
					case when dhr_dia = 2 then 'Martes-' else '' end ma,
					case when dhr_dia = 3 then 'Miercoles-' else '' end mie,
					case when dhr_dia = 4 then 'Jueves-' else '' end ju,
					case when dhr_dia = 5 then 'Viernes-' else '' end vi,
					case when dhr_dia = 6 then 'Sabado-' else '' end sa,
					case when dhr_dia = 7 then 'Domingo-' else '' end do, amd_usuario--,fea_codcil
					, fac_codigo, fac_nombre, '2275-8941' 'telefono_facultad', dip_necesita_cuenta_AD
				from dip_amd_alm_modulo
					join ra_per_personas on per_codigo = amd_codper
					join dip_fea_fechas_autorizadas on fea_codigo = amd_codfea
					join dbo.dip_hrm_horarios on hrm_codigo = amd_codhrm
					left outer join dbo.dip_dhr_det_horarios on dhr_codhrm = hrm_codigo
					left outer join ra_man_grp_hor on man_codigo = dhr_codman
					left outer join ra_aul_aulas on aul_codigo = dhr_aula
					join dip_pei_periodos_inscripcion on pei_codigo = fea_codpei
					join col_mes_meses on mes_codigo = pei_mes
					join dip_mdp_modulos_diplomado on mdp_codigo = fea_codmdp
					join dip_dip_diplomados on dip_codigo = mdp_coddip
					join ra_fac_facultades on dip_codfac = fac_codigo
					join ra_reg_regionales on reg_codigo = per_codreg
					join ra_uni_universidad on uni_codigo = reg_coduni
				where per_codreg = @codreg
				and (amd_codper = @codper or amd_codper_cuenta_original = @codper)
				and amd_codhrm = @codhrm
			) t
			left outer join adm_usr_usuarios on usr_usuario = amd_usuario
			group by uni_nombre,per_carnet,per_nombres_apellidos,dip_nombre,mdp_nombre,mes_nombre,pei_anio,fea_fecha,
			hrm_descripcion,usr_nombre,fecha_actual--,fea_codcil
			, fac_codigo, fac_nombre, telefono_facultad, dip_necesita_cuenta_AD
		) r
	end

	if @opcion = 2
	begin
	  
		declare @tbl_inicio_clases as table (InicioCiclo varchar(125))  
		insert into @tbl_inicio_clases (InicioCiclo)  
		exec dbo.ra_fic_fecha_inicio_ciclo @codcil  

		declare @ciclo_texto varchar(40) = ''
		select @ciclo_texto = concat('0', cil_codcic, '-', cil_anio) from ra_cil_ciclo where cil_codigo = @codcil
		select uni_nombre,per_carnet,per_nombres_apellidos,dip_nombre,mdp_nombre,mes_nombre,pei_anio,fea_fecha,
			hrm_descripcion,fecha_actual,
			isnull(man_nomhor,'No Definido') man_nomhor,
			isnull(aul_nombre_corto,'No Definido') aul_nombre_corto,
			case when dias = '' then 'No Definido' else substring(dias,1,len(dias)-1) end dias,
			case when dias2 = '' then 'No Definido' else substring(dias2,1,len(dias2)-1) end dias2,
			isnull(upper(usr_nombre), 'PROMOTOR') promotor, @ciclo_texto 'ciclo_texto', (select top 1 InicioCiclo from @tbl_inicio_clases) 'inicio_clases'
			, dip_diplomado
		from
		(
			select uni_nombre,per_carnet,per_nombres_apellidos,dip_nombre,mdp_nombre,mes_nombre,pei_anio,fea_fecha,
				hrm_descripcion,usr_nombre,fecha_actual,
				max(man_nomhor) man_nomhor, 
				max(aul_nombre_corto) aul_nombre_corto,
				max(lu) + max(ma) + max(mie) + max(ju) + max(vi) + max(sa) + max(do) dias,
				max(lu2) + max(ma2) + max(mie2) + max(ju2) + max(vi2) + max(sa2) + max(do2) dias2
				, dip_diplomado

			from
			(
				select uni_nombre,per_carnet,per_nombres_apellidos,dip_nombre,mdp_nombre,mes_nombre,pei_anio,fea_fecha,
					hrm_descripcion,man_nomhor, aul_nombre_corto,(convert(varchar,getdate(),103)) as fecha_actual,
					case when dhr_dia = 1 then 'Lunes-' else '' end lu,
					case when dhr_dia = 2 then 'Martes-' else '' end ma,
					case when dhr_dia = 3 then 'Miercoles-' else '' end mie,
					case when dhr_dia = 4 then 'Jueves-' else '' end ju,
					case when dhr_dia = 5 then 'Viernes-' else '' end vi,
					case when dhr_dia = 6 then 'Sabado-' else '' end sa,
					case when dhr_dia = 7 then 'Domingo-' else '' end do,amd_usuario

					, case when dhr_dia = 1 then 'Lu-' else '' end lu2,  
					case when dhr_dia = 2 then 'Ma-' else '' end ma2,  
					case when dhr_dia = 3 then 'Mie-' else '' end mie2,  
					case when dhr_dia = 4 then 'Ju-' else '' end ju2,  
					case when dhr_dia = 5 then 'Vi-' else '' end vi2,  
					case when dhr_dia = 6 then 'Sab-' else '' end sa2,  
					case when dhr_dia = 7 then 'Dom-' else '' end do2
					, dip_diplomado
				from dip_amd_alm_modulo with (nolock)
					join ra_per_personas on per_codigo = amd_codper
					join dip_fea_fechas_autorizadas on fea_codigo = amd_codfea
					join dbo.dip_hrm_horarios on hrm_codigo = amd_codhrm
					left outer join dbo.dip_dhr_det_horarios on dhr_codhrm = hrm_codigo
					left outer join ra_man_grp_hor on man_codigo = dhr_codman
					left outer join ra_aul_aulas on aul_codigo = dhr_aula
					join dip_pei_periodos_inscripcion on pei_codigo = fea_codpei
					join col_mes_meses on mes_codigo = pei_mes
					join dip_mdp_modulos_diplomado on mdp_codigo = fea_codmdp
					join dip_dip_diplomados with (nolock) on dip_codigo = mdp_coddip
					join ra_reg_regionales on reg_codigo = per_codreg
					join ra_uni_universidad on uni_codigo = reg_coduni
				where per_codreg = @codreg
				and amd_codper = @codper
				--and amd_codhrm = @codhrm
				and fea_codcil = @codcil
			) t
			left outer join adm_usr_usuarios on usr_usuario = amd_usuario
			group by uni_nombre,per_carnet,per_nombres_apellidos,dip_nombre,mdp_nombre,mes_nombre,pei_anio,fea_fecha,
			hrm_descripcion,usr_nombre,fecha_actual
			, dip_diplomado
		) r
	end
end
