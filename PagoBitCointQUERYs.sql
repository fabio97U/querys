-- drop table col_tipcp_tipos_controversia_pago
create table col_tipcp_tipos_controversia_pago (
	tipcp_codigo int primary key identity (1, 1),
	tipcp_nombre_controversia varchar(255) not null,
	tipcp_descripcion varchar(255) not null,
	tipcp_cantidad_archivos_permitidos int not null,
	tipcp_tamanio_maximo_archivos_mb float not null,
	tipcp_fecha_creacion datetime default getdate()
)
-- select * from col_tipcp_tipos_controversia_pago
insert into col_tipcp_tipos_controversia_pago 
(tipcp_nombre_controversia, tipcp_descripcion, tipcp_cantidad_archivos_permitidos, tipcp_tamanio_maximo_archivos_mb)
values ('Pago con Bitcoin', 'Todas solicitudes de pagar con Bitcoin', 5, 5)

-- drop table col_cons_controversia_solicitado
create table col_cons_controversia_solicitado (
	cons_codigo int primary key identity (1, 1),
	cons_codcil int foreign key references ra_cil_ciclo not null,
	cons_codper int foreign key references ra_per_personas not null,
	cons_codtipcp int foreign key references col_tipcp_tipos_controversia_pago not null,
	cons_arancel_concepto varchar(1024) not null,
	cons_razon_solictud varchar(5000) not null,
	cons_fecha_creacion datetime default getdate(),
	cons_codusr_creacion int,

	cons_estado varchar(2) default 'R'/*R: registrado, A: Aprobado, D: Denegado*/,
	cons_observaciones varchar(1024),
	cons_codusr_aprobacion int,
	cons_fecha_aprobacion datetime,
	cons_codusr_denegado int,
	cons_fecha_denegado datetime,
	cons_recibo_asignado varchar(20),
	cons_lote varchar(15)
)
-- select * from col_cons_controversia_solicitado
insert into col_cons_controversia_solicitado (cons_codcil, cons_codper, cons_codtipcp, cons_arancel_concepto, cons_razon_solictud, cons_codusr_creacion)
values (126, 216644, 1, 'Pago 3° cuota', 'Abono a la wallet bitcoin de la UTEC', 378)

-- drop table col_doccon_documentos_controversia
create table col_doccon_documentos_controversia (
	doccon_codigo int primary key identity (1, 1),
	doccon_codcons int foreign key references col_cons_controversia_solicitado,
	doccon_ruta_archivo varchar(1024),
	doccon_extension_archivo varchar(25),
	doccon_fecha_creacion datetime default getdate(),
	doccon_codusr_creacion int
)
-- select * from col_doccon_documentos_controversia
insert into col_doccon_documentos_controversia (doccon_codcons, doccon_ruta_archivo, doccon_extension_archivo, doccon_codusr_creacion)
values (1, 'https://cs7100320012416ed73.blob.core.windows.net/documentos-por-ddtde/d6564377-e4fa-4541-929a-c5697e412aa1.PNG', 'PNG', 378)
go


	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2021-09-08 09:46:31.630>
	-- Description: <Matenimiento a la tabla "col_cons" y "col_doccon">
	-- =============================================
	-- exec dbo.sp_matenimiento_col_cons_doccon 1, '07/09/2021', '13/09/2021', ''
	-- exec dbo.sp_matenimiento_col_cons_doccon @opcion = 2, @codcons = 1
create procedure sp_matenimiento_col_cons_doccon
	@opcion int = 0,
	@fecha_desde nvarchar(12) = '', 
	@fecha_hasta nvarchar(12) = '',
	@txt_buscar varchar(500) = '',
	@codcons int = 0,
	@codusr int = 0
as
begin
	
	if @opcion = 1
	begin
		select * from (
			select cons_codigo, tipcp_nombre_controversia, cons_codcil, CONCAT('0', cil_codcic, '-', cil_anio) ciclo, cons_codper, per_carnet, per_nombres_apellidos, 
			cons_arancel_concepto, cons_razon_solictud, cons_fecha_creacion, cons_estado,
			case cons_estado when 'R' then 'Registrado' when 'A' then 'Aprobado' when 'D' then 'Denegado' else '' end estado_tramite,
			cons_recibo_asignado, cons_lote
			from col_cons_controversia_solicitado
				inner join ra_cil_ciclo on cil_codigo = cons_codcil
				inner join ra_per_personas on per_codigo = cons_codper
				inner join col_tipcp_tipos_controversia_pago on tipcp_codigo = cons_codtipcp
			where convert(date, cons_fecha_creacion, 103) between convert(date, @fecha_desde, 103) and convert(date, @fecha_hasta, 103)
		) t where (
			(ltrim(rtrim(per_carnet)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
					else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(per_nombres_apellidos)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(cons_arancel_concepto)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(tipcp_nombre_controversia)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		) order by cons_codigo desc

	end

	if @opcion = 2
	begin
		select * from (
			select cons_codigo, cons_codcil, CONCAT('0', cil_codcic, '-', cil_anio) ciclo, cons_codper, per_carnet, per_nombres_apellidos, 
			cons_arancel_concepto, cons_razon_solictud, cons_fecha_creacion, cons_estado,
			case cons_estado when 'R' then 'Registrado' when 'A' then 'Aprobado' when 'D' then 'Denegado' else '' end estado_tramite,
			cons_recibo_asignado, cons_lote, cons_observaciones, 
			cons_codusr_aprobacion, (select u1.usr_usuario from adm_usr_usuarios u1 where u1.usr_codigo = cons_codusr_aprobacion) usuario_aprobacion, cons_fecha_aprobacion, 
			cons_codusr_denegado, (select u2.usr_usuario from adm_usr_usuarios u2 where u2.usr_codigo = cons_codusr_denegado) usuario_denego, cons_fecha_denegado,
			tipcp_nombre_controversia
			from col_cons_controversia_solicitado
				inner join ra_cil_ciclo on cil_codigo = cons_codcil
				inner join ra_per_personas on per_codigo = cons_codper
				inner join col_tipcp_tipos_controversia_pago on tipcp_codigo = cons_codtipcp
			where cons_codigo = @codcons
		) t
		select * from col_doccon_documentos_controversia where doccon_codcons = @codcons
	end

end