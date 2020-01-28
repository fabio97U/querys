drop table gc_fies_financiar_estudio
create table gc_fies_financiar_estudio
(
	fies_codigo int identity(1,1) primary key,
	fies_financiamiento varchar(150),
	fies_opcion_abierta int default 0,
	fies_fecha_creacion datetime default getdate()
)
go
insert into gc_fies_financiar_estudio(fies_financiamiento, fies_opcion_abierta) values('Fondos propios',0), ('Prestado',0), ('Otros',1)
select * from gc_fies_financiar_estudio
go

drop table gc_fipn_fies_persona_nativo
go
create table gc_fipn_fies_persona_nativo
(
	fipn_codigo int identity(1,1) primary key,
	fipn_codper int,
	fipn_codfies int,
	fipn_otros nvarchar(300),

	fipn_codpai_residencia int,
	fipn_codpaie_residencia int,
	fipn_codpainacionalidad int,

	fipn_fecha_creacion datetime default getdate()
)
go
select * from gc_fipn_fies_persona_nativo

drop table gc_giro_economico
create table gc_giro_economico
(
	giro_codigo int identity(1,1) primary key,
	giro_nombre nvarchar(100),
	giro_fecha_creacion datetime default getdate()
)
go
insert into gc_giro_economico (giro_nombre) values ('No Aplica'),('Industriales'), ('Comerciales'), ('De Servicios'), ('Mayoristas')
select * from gc_giro_economico

drop table gc_clt_clasificacion_tributaria
create table gc_clt_clasificacion_tributaria
(
	clt_codigo int identity(1,1) primary key,
	clt_nombre nvarchar(100),
	clt_fecha_creacion datetime default getdate()
)
go
insert into gc_clt_clasificacion_tributaria (clt_nombre) values ('No Aplica'),('Sujeto Activo'), ('Sujeto Pasivo'), ('Hecho generador')
select * from gc_clt_clasificacion_tributaria
	
drop table gc_aeco_actividad_economica
create table gc_aeco_actividad_economica
(
	aeco_codigo int identity(1,1) primary  key,
	aeco_actividad nvarchar(300),
	aeco_fecha_creacion datetime default getdate()
)
go
insert into gc_aeco_actividad_economica(aeco_actividad) values ('No Aplica'), ('Primaria'), ('Secundaria'), ('Tercearia')
select * from gc_aeco_actividad_economica

drop table gc_carp_cargo_pep
create table gc_carp_cargo_pep
(
	carp_codigo int identity(1,1) primary key,
	carp_cargo nvarchar(100),
	carp_fecha_creacion datetime default getdate()
)
go
insert into gc_carp_cargo_pep (carp_cargo) values ('Diputado'), ('Alcalde'), ('Presidente'), ('Cenador')
select * from gc_carp_cargo_pep

-----------*-----------
--Almacena los datos digitados
-----------*-----------
drop table gc_pemp_persona_empresa
go
create table gc_pemp_persona_empresa
(
	pemp_codigo int identity(1,1) primary key,
	pemp_codper int,
	pemp_codgiro int,
	pemp_codclt int,
	pemp_sucursales nvarchar(10),
	pemp_anios_operar nvarchar(10),
	pemp_codaeco int,
	pemp_ingresos nvarchar(10),
	pemp_ncr nvarchar(25),
	pemp_empresa nvarchar(15),
	pmep_telefono nvarchar(30),
	pemp_direccion nvarchar(300),
	pemp_codpais int,
	pemp_coddepartamento int,
	pemp_codnacionalidad int
)
go
select * from gc_pemp_persona_empresa
go

drop table gc_pep_persona_politicamente_expuesta
go
create table gc_pep_persona_politicamente_expuesta
(
	pep_codigo int identity(1,1) primary key,
	pep_codper int,
	pep_operaciones_guber nvarchar(300),
	pep_fecha_creacion datetime default getdate()
)
go
select * from gc_pep_persona_politicamente_expuesta
go

drop table gc_fpr_funcionario_publico_relacion
go
create table gc_fpr_funcionario_publico_relacion
(
	fpr_codigo int identity(1,1) primary key,
	fpr_codper int,
	fpr_nombre nvarchar(100),
	fpr_parentesco int,
	fpr_codcarp int,
	fpr_dependencia_cargo varchar(300),
	fpr_fecha_ejercer_cargo_inicio varchar(12),
	fpr_fecha_ejercer_cargo_fin varchar(12),
	fpr_administra_fondos_publicos char(1),
	fpr_fondos_descripcion nvarchar(300),
	fpr_fecha_creacion datetime default getdate()
)
go
select * from gc_fpr_funcionario_publico_relacion
go

drop table gc_fuip_fuente_ingreso_pep
go
create table gc_fuip_fuente_ingreso_pep
(
	fuip_codigo int identity(1,1) primary key,
	fuip_codper int,
	fuip_profesion nvarchar(50),
	fuip_empleador nvarchar(50),
	fuip_accionista_empresa nvarchar(300),
	fuip_fecha_creacion datetime default getdate()
)
go
select * from gc_fuip_fuente_ingreso_pep
go

drop table gc_fap_familia_pep
go
create table gc_fap_familia_pep
(
	fap_codigo int identity(1,1) primary key,
	fap_codper int,
	fap_nombre nvarchar(100),
	fap_codprt int,
	fap_nacionalidad int,
	fap_fecha_creacion datetime default getdate()
)
go
--select * from gc_rpobs_registro_pep_observaciones
--drop table gc_rpobs_registro_pep_observaciones
create table gc_rpobs_registro_pep_observaciones(
	rpobs_codigo int primary key identity(1,1),
	rpobs_observacion varchar(555),
	rpobs_fecha_registro datetime default getdate()
)
go
insert into gc_rpobs_registro_pep_observaciones(rpobs_observacion) values ('Sin observaciones'), ('Nit faltante'), ('Falto firmar'), ('DUI Incompleto'), ('Direccion incorrecta')
go
--select rpobs_codigo, rpobs_observacion from gc_rpobs_registro_pep_observaciones
-----------*--------
drop table gc_rpep_registro_pep
create table gc_rpep_registro_pep
(
	rpep_codigo int identity(1,1) primary key,
	rpep_codper int,
	rpep_codigo_tipo_pep int,--0: NO ES PEP, 1: ES PEP, 2: TIENE FAMILIARES PEP, 3: ES Y TIENE FAMILIARES PEP
	rpep_codcil int,
	rpep_subio_archivo int default 0,--0: No a subido archivo, 1: Subio archivo, 2: Resubio archivo
	rpep_fecha_subio_archivo datetime,
	rpep_fecha_resubio_archivo datetime,
	rpep_estado varchar(2) DEFAULT '0', --0: Seleccione, A: APROBADO, D: DENEGADO
	rpep_codrpobs int foreign key references gc_rpobs_registro_pep_observaciones default 1,
	--rpep_se_envio_correo bit default 0, --1: Se envio correo, 0: No se envio correo
	rpep_fecha_creacion datetime default getdate(),
	rpep_nombre_archivo varchar(125)
)
go
select * from gc_rpep_registro_pep

declare @codcil int = '{0}'
declare @no_son_pep int, @no_son_pep_no_subio_archivo int, @no_son_pep_subio_archivo int,@no_son_pep_re_subio_archivo int, @no_son_pep_en_revision int, @no_son_pep_aprobado int,  @no_son_pep_denegado int, 
@son_pep int, @son_pep_no_subio_archivo int, @son_pep_subio_archivo int,@son_pep_re_subio_archivo int, @son_pep_en_revision int, @son_pep_aprobado int,  @son_pep_denegado int, 
@tiene_familiares_pep int, @tiene_familiares_pep_no_subio_archivo int, @tiene_familiares_pep_subio_archivo int,@tiene_familiares_pep_re_subio_archivo int, @tiene_familiares_pep_en_revision int, @tiene_familiares_pep_aprobado int,  @tiene_familiares_pep_denegado int,  
@es_tiene_pep int, @es_tiene_pep_no_subio_archivo int, @es_tiene_pep_subio_archivo int,@es_tiene_pep_re_subio_archivo int, @es_tiene_pep_en_revision int, @es_tiene_pep_aprobado int,  @es_tiene_pep_denegado int

select @no_son_pep =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 0
select @no_son_pep_no_subio_archivo =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 0 and rpep_subio_archivo = 0
select @no_son_pep_subio_archivo =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 0 and rpep_subio_archivo = 1
select @no_son_pep_re_subio_archivo =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 0 and rpep_subio_archivo = 2
select @no_son_pep_en_revision =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 0 and rpep_subio_archivo = 1 and rpep_estado = '0'
select @no_son_pep_aprobado =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 0 and rpep_subio_archivo = 1 and rpep_estado = 'A'
select @no_son_pep_denegado =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 0 and rpep_subio_archivo = 1 and rpep_estado = 'D'

select @son_pep = count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 1
select @son_pep_no_subio_archivo =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 1 and rpep_subio_archivo = 0
select @son_pep_subio_archivo =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 1 and rpep_subio_archivo = 1
select @son_pep_re_subio_archivo =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 1 and rpep_subio_archivo = 2
select @son_pep_en_revision =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 1 and rpep_subio_archivo = 1 and rpep_estado = '0'
select @son_pep_aprobado =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 1 and rpep_subio_archivo = 1 and rpep_estado = 'A'
select @son_pep_denegado =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 1 and rpep_subio_archivo = 1 and rpep_estado = 'D'

select @tiene_familiares_pep = count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 2
select @tiene_familiares_pep_no_subio_archivo =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 2 and rpep_subio_archivo = 0
select @tiene_familiares_pep_subio_archivo =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 2 and rpep_subio_archivo = 1
select @tiene_familiares_pep_re_subio_archivo =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 2 and rpep_subio_archivo = 2
select @tiene_familiares_pep_en_revision =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 2 and rpep_subio_archivo = 1 and rpep_estado = '0'
select @tiene_familiares_pep_aprobado =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 2 and rpep_subio_archivo = 1 and rpep_estado = 'A'
select @tiene_familiares_pep_denegado =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 2 and rpep_subio_archivo = 1 and rpep_estado = 'D'

select @es_tiene_pep = count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 3
select @es_tiene_pep_no_subio_archivo =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 3 and rpep_subio_archivo = 0
select @es_tiene_pep_subio_archivo =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 3 and rpep_subio_archivo = 1
select @es_tiene_pep_re_subio_archivo =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 3 and rpep_subio_archivo = 2
select @es_tiene_pep_en_revision =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 3 and rpep_subio_archivo = 1 and rpep_estado = '0'
select @es_tiene_pep_aprobado =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 3 and rpep_subio_archivo = 1 and rpep_estado = 'A'
select @es_tiene_pep_denegado =  count(1) from gc_rpep_registro_pep where rpep_codcil = @codcil and rpep_codigo_tipo_pep = 3 and rpep_subio_archivo = 1 and rpep_estado = 'D'

select 'No son PEP' 'Tipo', @no_son_pep 'Cantidad', @no_son_pep_no_subio_archivo 'No subio PDF', @no_son_pep_subio_archivo 'Subio PDF', @no_son_pep_re_subio_archivo 'Resubio PDF', @no_son_pep_en_revision 'En Revision', @no_son_pep_aprobado 'Aprobados', @no_son_pep_denegado 'Denegados' union
select 'Son PEP', @son_pep, @son_pep_no_subio_archivo,@son_pep_subio_archivo, @son_pep_re_subio_archivo, @son_pep_en_revision, @son_pep_aprobado, @son_pep_denegado union
select 'Tiene familiares PEP', @tiene_familiares_pep, @tiene_familiares_pep_no_subio_archivo,@tiene_familiares_pep_subio_archivo, @tiene_familiares_pep_re_subio_archivo, @tiene_familiares_pep_en_revision, @tiene_familiares_pep_aprobado, @tiene_familiares_pep_denegado union
select 'Es y tiene familiares PEP', @es_tiene_pep, @es_tiene_pep_no_subio_archivo,@es_tiene_pep_subio_archivo, @es_tiene_pep_re_subio_archivo, @es_tiene_pep_en_revision, @es_tiene_pep_aprobado, @es_tiene_pep_denegado 
--select 'Total', cast(count(1)as varchar(5))  from gc_rpep_registro_pep where rpep_codcil = @codcil

select rpep_codigo_tipo_pep, count(1) from gc_rpep_registro_pep where rpep_codcil = 119 group by rpep_codigo_tipo_pep
having count(1) >= 0


select * from gc_rpep_registro_pep

drop table gc_fefopep_fecha_formulario_pep
create table gc_fefopep_fecha_formulario_pep(
	fefopep_codigo int primary key identity(1,1),
	fefopep_codcil int foreign key references ra_cil_ciclo,
	fefopep_activar_restricciones int default 0,--0: No estan activadas las restricciones, 1: Estan activadas las restricciones
	fefopep_fecha_inicio datetime,
	fefopep_fecha_fin datetime,
	fefopep_fecha_creacion datetime default getdate()
);
insert into gc_fefopep_fecha_formulario_pep(fefopep_codcil, fefopep_fecha_inicio, fefopep_fecha_fin, fefopep_activar_restricciones) values(119, '2019-03-30 00:00:00.000', '2019-06-01 00:00:00.000', 0)
select * from gc_fefopep_fecha_formulario_pep 

--select * from gc_rpep_registro_pep
/*
select rpep_codigo , per_carnet, substring(replace(per_carnet, '-', ''), 1, 10) 'carnet', rpep_codper,  per_nombres_apellidos,
rpep_codigo_tipo_pep, case rpep_codigo_tipo_pep when 0 then 'No es PEP' when 1 then 'Es PEP' when 2 then 'Tiene Familiares PEP' when 3 then 'Es y tiene familiares PEP' end 'Tipo_PEP',
rpep_codcil, CONCAT('0', cil_codcic, '-', cil_anio) 'Ciclo_registro', 
rpep_codcil, CONCAT('0', cil_codcic,cil_anio) 'Ciclo_registro',
rpep_subio_archivo, case rpep_subio_archivo when 0 then 'No a subido PDF' when 1 then 'Subio PDF' when 2 then 'Resubio PDF' end 'Subio PDF',
rpep_fecha_subio_archivo 'Fecha subio archivo', rpep_fecha_resubio_archivo 'Fecha resubio archivo', 
rpep_estado, case rpep_estado when 'D' then 'Denegado' when 'A' then 'Aprobado'end 'Estado',
rpep_observaciones, rpep_fecha_creacion 'Fecha lleno formulario'
from gc_rpep_registro_pep, ra_per_personas, ra_cil_ciclo where rpep_codper = per_codigo and rpep_codcil = cil_codigo and rpep_codcil = 119*/
 

--update gc_rpep_registro_pep set rpep_fecha_subio_archivo = getdate(), rpep_subio_archivo = 1 where rpep_codper = 181324 and rpep_codcil = 119; select 0

--select rpep_subio_archivo from gc_rpep_registro_pep where rpep_codper = 181324 and rpep_codcil = 119

select rpep_codigo , per_carnet, substring(replace(per_carnet, '-', ''), 1, 10) 'carnet', rpep_codper,  per_nombres_apellidos,
                    rpep_codigo_tipo_pep, case rpep_codigo_tipo_pep when 0 then 'No es PEP' when 1 then 'Es PEP' when 2 then 'Tiene Familiares PEP' when 3 then 'Es y tiene familiares PEP' end 'Tipo_PEP',
                    rpep_codcil, CONCAT('0', cil_codcic, '-', cil_anio) 'Ciclo_registro', 
                    rpep_subio_archivo, case rpep_subio_archivo when 0 then 'No a subido PDF' when 1 then 'Subio PDF' when 2 then 'Resubio PDF' end 'Subio_PDF',
                    rpep_fecha_subio_archivo, rpep_fecha_resubio_archivo , 
                    rpep_estado, case rpep_estado when 'D' then 'Denegado' when 'A' then 'Aprobado'end 'Estado',
                    rpep_codrpobs, rpep_fecha_creacion
                    from gc_rpep_registro_pep, ra_per_personas, ra_cil_ciclo where rpep_codper = per_codigo and rpep_codcil = cil_codigo and rpep_codcil = 119 
                and ((ltrim(rtrim(rpep_codigo_tipo_pep)) like '%' + case when isnull(ltrim(rtrim(' '))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
                                        else ltrim(rtrim(' '))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end ))

				and ((ltrim(rtrim(rpep_subio_archivo)) like '%' + case when isnull(ltrim(rtrim(' '))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
                                        else ltrim(rtrim(' '))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end ))

				and ((ltrim(rtrim(rpep_estado)) like '%' + case when isnull(ltrim(rtrim(' '))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
                                        else ltrim(rtrim(' '))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end ))

select 3 as opcion, per.per_nombres_apellidos, per.per_direccion, 
			fipn.fipn_codpai_residencia, fipn.fipn_codpaie_residencia, fipn.fipn_codpainacionalidad, --LUGARES
			per.per_telefono, per.per_celular, per.per_email,
			 
			fipn.fipn_codfies, fies.fies_opcion_abierta, fipn.fipn_otros,
			
			per_nit, pemp.pemp_ncr, pemp.pemp_codgiro, pemp.pemp_ingresos, pemp.pemp_codclt, 
			pemp.pemp_sucursales, pemp.pemp_anios_operar, pemp.pemp_codaeco, pemp.pemp_empresa,
			pemp.pmep_telefono, pemp.pemp_direccion, pemp.pemp_codpais, pemp.pemp_coddepartamento,
			pemp.pemp_codnacionalidad,
			
			

			per.per_nombres_apellidos, pep.pep_operaciones_guber,
			 
			fpr.fpr_nombre, fpr_parentesco, fpr_codcarp, fpr_dependencia_cargo, fpr_fecha_ejercer_cargo_inicio, 
			fpr_fecha_ejercer_cargo_fin, fpr.fpr_administra_fondos_publicos, fpr.fpr_fondos_descripcion,

			pep.pep_codigo,fuip.fuip_profesion, fuip.fuip_empleador, fuip_accionista_empresa

			,fap.fap_nombre, fap.fap_codprt, fap.fap_nacionalidad
		from ra_per_personas as per
		left join gc_fipn_fies_persona_nativo as fipn on per_codigo = fipn_codper
		left join gc_fies_financiar_estudio as fies on fies_codigo = fipn_codfies
		left join gc_pemp_persona_empresa as pemp on pemp_codper = per_codigo

		left join gc_pep_persona_politicamente_expuesta as pep on pep_codper = per_codigo
		left join gc_fpr_funcionario_publico_relacion as fpr on fpr_codper = per_codigo
		left join gc_fuip_fuente_ingreso_pep as fuip on fuip_codper = per_codigo
		left join gc_fap_familia_pep as fap on fap_codper = per_codigo
		where per_codigo = 181324 --180168

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_mostrar_info_pep]    Script Date: 02/02/2019 8:12:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--drop procedure sp_mostrar_info_pep
alter procedure [dbo].[gc_sp_mostrar_info_pep]
--gc_sp_mostrar_info_pep 1, '25-1565-2015', 119
----------------------*----------------------
-- =============================================
-- Author:      <Fabio>
-- Create date: <02/04/2019 10:31:39>
-- Description: <Muestra la informacion utlizada en el formulario de PEP del portalutec>
-- =============================================
	@opcion int,
	@per_carnet varchar(14),
	@codcil int
	
as
begin
	declare @codper int
	set @codper = (select per_codigo from ra_per_personas where per_carnet = @per_carnet)
	
	if @opcion = 1
	begin 
	select 1 as opcion, rpep.rpep_codigo_tipo_pep, per.per_nombres_apellidos, per.per_direccion, 
			fipn.fipn_codpai_residencia, fipn.fipn_codpaie_residencia, fipn.fipn_codpainacionalidad, --LUGARES
			per.per_telefono, per.per_celular, per.per_email,
			 
			fipn.fipn_codfies, fies.fies_opcion_abierta, fipn.fipn_otros,
			
			per_nit, pemp.pemp_ncr, pemp.pemp_codgiro, pemp.pemp_ingresos, pemp.pemp_codclt, 
			pemp.pemp_sucursales, pemp.pemp_anios_operar, pemp.pemp_codaeco, pemp.pemp_empresa,
			pemp.pmep_telefono, pemp.pemp_direccion, pemp.pemp_codpais, pemp.pemp_coddepartamento,
			pemp.pemp_codnacionalidad,
			
			per.per_nombres_apellidos, pep.pep_operaciones_guber,
			 
			fpr.fpr_nombre, fpr_parentesco, fpr_codcarp, fpr_dependencia_cargo, fpr_fecha_ejercer_cargo_inicio, 
			fpr_fecha_ejercer_cargo_fin, fpr.fpr_administra_fondos_publicos, fpr.fpr_fondos_descripcion,

			pep.pep_codigo,fuip.fuip_profesion, fuip.fuip_empleador, fuip_accionista_empresa

			--,fap.fap_nombre, fap.fap_parentesco, fap.fap_nacionalidad
		from ra_per_personas as per
		left join gc_fipn_fies_persona_nativo as fipn on per_codigo = fipn_codper
		left join gc_fies_financiar_estudio as fies on fies_codigo = fipn_codfies
		left join gc_pemp_persona_empresa as pemp on pemp_codper = per_codigo
		left join gc_pep_persona_politicamente_expuesta as pep on pep_codper = per_codigo
		left join gc_fpr_funcionario_publico_relacion as fpr on fpr_codper = per_codigo
		left join gc_fuip_fuente_ingreso_pep as fuip on fuip_codper = per_codigo
		left join gc_rpep_registro_pep as rpep on rpep_codper = per_codigo
		--left join gc_fap_familia_pep as fap on fap_codpep = pep_codigo
		where per_codigo = @codper-- and rpep_codcil = 119--180168
	end
end
go

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[mto_giro_tributaria]    Script Date: 02/02/2019 8:14:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 

--drop procedure mto_giro_tributaria
alter procedure [dbo].[gc_mto_giro_tributaria]
----------------------*----------------------
-- =============================================
-- Author:      <Erik,>
-- Create date: <02/04/2019 10:31:39>
-- Description: <Realiza el mantenimiento a las tablas gc_giro_economico, gc_clt_clasificacion_tributaria, fies_financiamientogc_aeco_actividad_economica, gc_rpobs_registro_pep_observaciones>
-- =============================================
	--gc_mto_giro_tributaria 17, '', '', '', '', '', '', 0, '', '', '', '', 1, 119, 1, '2019-03-29', '2019-06-01'
	@opcion int = 0,

	@giro_nombre nvarchar(100) = '',
	@giro_nombre_anterior nvarchar(100) = '',

	@clt_nombre nvarchar(100) = '',
	@clt_nombre_anterior nvarchar(100) = '',

	@fies_financiamiento nvarchar(100) = '',
	@fies_financiamiento_anterior nvarchar(100) = '',
	@fies_opcion_abierta int = '',

	@aeco_actividad nvarchar(300) = '',
	@aeco_actividad_anterior nvarchar(300) = '',

	@rpobs_observacion varchar(255) = '',
	@rpobs_observacion_anterior varchar(255) = '',

	@fefopep_codigo int = 0,
	@fefopep_codcil int = 0,
	@fefopep_activar_restricciones int = 0,
	@fefopep_fecha_inicio nvarchar(12) = '',
	@fefopep_fecha_fin nvarchar(12) = ''
as

begin
	--Inserts a las tablas gc_giro_economico, gc_clt_clasificacion_tributaria, fies_financiamientogc_aeco_actividad_economica, gc_rpobs_registro_pep_observaciones
	if @opcion = 1
	begin
		if not exists(select giro_nombre from gc_giro_economico where giro_nombre = @giro_nombre)
		begin
			insert into gc_giro_economico (giro_nombre)
			values (@giro_nombre)
		end
	end

	if @opcion = 2
	begin
		if not exists(select clt_nombre from gc_clt_clasificacion_tributaria where clt_nombre = @clt_nombre)
		begin
			insert into gc_clt_clasificacion_tributaria (clt_nombre)
			values (@clt_nombre)
		end
	end
			
	if @opcion = 3
	begin
		if not exists(select fies_financiamiento from gc_fies_financiar_estudio where fies_financiamiento = @fies_financiamiento)
		begin
			insert into gc_fies_financiar_estudio (fies_financiamiento, fies_opcion_abierta)
			values (@fies_financiamiento, @fies_opcion_abierta)
		end
	end

	if @opcion = 4
	begin
		if not exists(select aeco_actividad from gc_aeco_actividad_economica where aeco_actividad = @aeco_actividad)
		begin
			insert into gc_aeco_actividad_economica (aeco_actividad)
			values (@aeco_actividad)
		end
	end
	if @opcion = 13
	begin
		if not exists(select 1 from gc_rpobs_registro_pep_observaciones where rpobs_observacion = @rpobs_observacion)
		begin
			insert into gc_rpobs_registro_pep_observaciones (rpobs_observacion)
			values (@rpobs_observacion)
		end
	end
	if @opcion = 16
	begin
		set dateformat dmy
		if not exists(select 1 from gc_fefopep_fecha_formulario_pep where fefopep_codcil = @fefopep_codcil)
		begin
			insert into gc_fefopep_fecha_formulario_pep (fefopep_codcil, fefopep_fecha_inicio, fefopep_fecha_fin, fefopep_activar_restricciones)
			values (@fefopep_codcil, cast(@fefopep_fecha_inicio as date), cast(@fefopep_fecha_fin as date), @fefopep_activar_restricciones)
		end
	end
	--Updates a las tablas gc_giro_economico, gc_clt_clasificacion_tributaria
	if @opcion = 5
	begin
		update gc_giro_economico set giro_nombre = @giro_nombre 
		where giro_codigo = (select giro_codigo from gc_giro_economico where giro_nombre = @giro_nombre_anterior)
	end

	if @opcion = 6
	begin
		update gc_clt_clasificacion_tributaria set clt_nombre = @clt_nombre
		where clt_codigo = (select clt_codigo from gc_clt_clasificacion_tributaria where clt_nombre = @clt_nombre_anterior)
	end

	if @opcion = 7
	begin
		update gc_fies_financiar_estudio set fies_financiamiento = @fies_financiamiento, fies_opcion_abierta = @fies_opcion_abierta
		where fies_codigo = (select fies_codigo from gc_fies_financiar_estudio where fies_financiamiento = @fies_financiamiento_anterior)
	end

	if @opcion = 8
	begin
		update gc_aeco_actividad_economica set aeco_actividad = @aeco_actividad
		where aeco_codigo = (select aeco_codigo from gc_aeco_actividad_economica where aeco_actividad = @aeco_actividad_anterior)
	end

	if @opcion = 14
	begin
		update gc_rpobs_registro_pep_observaciones set rpobs_observacion = @rpobs_observacion
		where rpobs_codigo =  @rpobs_observacion_anterior
	end
	if @opcion = 17
	begin
		set dateformat dmy
		update gc_fefopep_fecha_formulario_pep set fefopep_fecha_inicio = cast(@fefopep_fecha_inicio as date), fefopep_fecha_fin = cast(@fefopep_fecha_fin as date), fefopep_codcil = @fefopep_codcil, fefopep_activar_restricciones = @fefopep_activar_restricciones
		where fefopep_codigo = @fefopep_codigo
	end
	
	--Deletes a las tablas gc_giro_economico, gc_clt_clasificacion_tributaria
	if @opcion = 9
	begin
		delete from gc_giro_economico
		where giro_codigo = (select giro_codigo from gc_giro_economico where giro_nombre = @giro_nombre)
	end

	if @opcion = 10
	begin
		delete from gc_clt_clasificacion_tributaria
		where clt_codigo = (select clt_codigo from gc_clt_clasificacion_tributaria where clt_nombre = @clt_nombre)
	end

	if @opcion = 11
	begin
		delete from gc_fies_financiar_estudio
		where fies_codigo = (select fies_codigo from gc_fies_financiar_estudio where fies_financiamiento = @fies_financiamiento)
	end

	if @opcion = 12
	begin
		delete from gc_aeco_actividad_economica
		where aeco_codigo = (select aeco_codigo from gc_aeco_actividad_economica where aeco_actividad = @aeco_actividad)
	end
	if @opcion = 15
	begin
		delete from gc_rpobs_registro_pep_observaciones
		where rpobs_codigo = @rpobs_observacion_anterior
	end
	if @opcion = 18
	begin
		set dateformat dmy
		delete from gc_fefopep_fecha_formulario_pep 
		where fefopep_codcil = @fefopep_codcil
	end
end
go


USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_carp_cargo_pep]    Script Date: 02/02/2019 8:14:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--drop PROCEDURE sp_carp_cargo_pep
create procedure [dbo].[gc_sp_carp_cargo_pep]
----------------------*----------------------
-- =============================================
-- Author:      <Erik,>
-- Create date: <02/02/2019 8:14:46>
-- Description: <Realiza el mantenimiento a la tabla(gc_carp_cargo_pep) donde se guardan los tipos de cargo que puede tener un PEP >
-- =============================================
	@opcion int,
	@carp_codigo int,
	@carp_cargo nvarchar(100)
as
begin
	if @opcion = 1--inserta
	begin
		if not exists(select carp_cargo from gc_carp_cargo_pep where carp_cargo = @carp_cargo)
		begin
			insert into gc_carp_cargo_pep (carp_cargo)
			values (@carp_cargo)
		end
	end
	if @opcion = 2--actualiza
	begin
		update gc_carp_cargo_pep set carp_cargo = @carp_cargo
		where carp_codigo = @carp_codigo
	end
	if @opcion = 3--borra
	begin
		delete from gc_carp_cargo_pep where carp_codigo = @carp_codigo
	end
end
go
--drop PROCEDURE sp_rpep_registro_pep

/* ALMNOS FALTANTES LLENAR FORMULARIO PEP
select distinct  per_carnet 'Carnet', ltrim(per_apellidos_nombres) 'Estudiante', per_correo_institucional 'Correo institucional', per_email 'Correo personal', fac_nombre 'Facultad' from ra_per_personas, ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras, ra_fac_facultades 
where per_estado = 'A' and per_codigo in(
    select distinct ins_codper from ra_ins_inscripcion where ins_codcil = 119 and ins_codper in (select alc_codper from ra_alc_alumnos_carrera where alc_codpla in 
		(
			select pla_codigo from ra_pla_planes where pla_estado = 'A' and pla_tipo = 'U'
		)
    )
) and  per_tipo = 'U'and per_codigo = alc_codper and alc_codpla = pla_codigo and pla_codcar = car_codigo and car_codfac = fac_codigo and per_estado = 'A' and per_codigo not in (select rpep_codper from gc_rpep_registro_pep where rpep_codcil = 119)
order by 2
*/