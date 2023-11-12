--drop table col_transest_transferencias_estudiantes
create table col_transest_transferencias_estudiantes (
	transest_codigo int primary key identity (1, 1),
	transest_codper int,
	transest_coddmo int,
	transest_codcil_original int,
	transest_codcil_transferir int,
	transest_motivo_transferencia varchar(2048),

	transest_aprobado_decanato bit default 1,
	transest_estado_decanato varchar(50) default 'Creado',
	transest_codusr_aprobado_decanato int,
	transest_fecha_creado_decanato datetime default getdate(),

	transest_aprobado_colecturia bit default null,
	transest_estado_colecturia varchar(50),-- 'Aprobado', 'Rechazado'
	transest_codusr_aprobado_colecturia int,
	transest_fecha_aprobado_colecturia datetime,

	transest_aprobado_administracion_academica bit default null,
	transest_estado_administracion_academica varchar(50),-- 'Transferido', 'Rechazado'
	transest_codusr_aprobado_administracion_academica int,
	transest_fecha_aprobado_administracion_academica datetime
)
go
-- select * from col_transest_transferencias_estudiantes
-- delete from col_transest_transferencias_estudiantes
--Crear SP que cambien el ciclo


	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-01-04 18:19:12.533>
	-- Description: <Verifica si un usuario se encuentra en los roles permitidos, se usa en el proceso de revision de transferencias privado/col_transest_transferencias_estudiantes.aspx>
	-- =============================================
	-- exec sp_verificar_rol_usuario 281
create procedure sp_verificar_rol_usuario
	@codusr int
as
begin
	declare @tbl_roles_permitidos as table (nombre_rol varchar(35))
	declare @rol varchar(50)
	insert into @tbl_roles_permitidos (nombre_rol) values ('ADMINISTRADORES'), ('Decanato'), ('Colecturia'), ('Administracion academica')
	select top 1 @rol = rol_role from adm_rus_role_usuarios 
		inner join adm_usr_usuarios on rus_codusr = usr_codigo
		inner join adm_rol_roles on rus_role = rol_codigo
	where rus_codusr = @codusr and rol_role in (select nombre_rol from @tbl_roles_permitidos)
	select isnull(@rol, 'NoEncontrado') 'rol'
end


	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-01-04 14:26:58.730>
	-- Description: <Vista con los datos de las transferencias de ciclo solicitadas>
	-- =============================================
	-- select * from vst_transferencias_ciclo where codper = 168640
create view vst_transferencias_ciclo
as
select transest_codigo 'codtransest',
	case 
		when transest_aprobado_decanato = 1 
			and transest_aprobado_colecturia = 1 
			and transest_aprobado_administracion_academica = 1 
		then 'Transferido'
		else 'No Transferido'
	end 'estado',

	transest_aprobado_decanato, transest_estado_decanato, transest_codusr_aprobado_decanato, transest_fecha_creado_decanato, transest_motivo_transferencia,
	
	transest_aprobado_colecturia, transest_estado_colecturia, transest_codusr_aprobado_colecturia, transest_fecha_aprobado_colecturia, 
	
	transest_aprobado_administracion_academica, transest_estado_administracion_academica, transest_codusr_aprobado_administracion_academica, 
	transest_fecha_aprobado_administracion_academica,

	per_codigo 'codper', per_carnet 'carnet', per_nombres_apellidos 'estudiante', mov_codigo 'codmov', mov_recibo 'recibo', mov_lote 'lote', mov_usuario, mov_fecha_real_pago, 
	transest_codcil_original 'codcil_original', concat('0', cil_codcic, '-', cil_anio) 'ciclo_academico_original', 
	transest_codcil_transferir 'codcil_transferir', (select concat('0', c.cil_codcic, '-', c.cil_anio) from ra_cil_ciclo c where c.cil_codigo = transest_codcil_transferir) 'ciclo_academico_transferir',
	dmo_codigo 'coddmo', dmo_codtmo 'codtmo', tmo_arancel 'arancel', tmo_descripcion, dmo_valor 'valor'
from col_transest_transferencias_estudiantes transest
	inner join col_dmo_det_mov on dmo_codigo = transest_coddmo
	inner join col_mov_movimientos on dmo_codmov = mov_codigo
	inner join ra_per_personas on per_codigo = transest_codper
	inner join ra_cil_ciclo on transest_codcil_original = cil_codigo
	inner join col_tmo_tipo_movimiento on dmo_codtmo = tmo_codigo

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2022-12-16 09:46:41.727>
	-- Description: <Realiza el CRUD a la tabla "col_transest_transferencias_estudiantes" y realiza las transferencia>
	-- =============================================
	-- exec dbo.sp_col_transest_transferencias_estudiantes 1, 168640
	-- exec dbo.sp_col_transest_transferencias_estudiantes @opcion = 1, @carnet = '32-6322-2013'
	-- exec dbo.sp_col_transest_transferencias_estudiantes 1, 241355
create procedure sp_col_transest_transferencias_estudiantes
	@opcion int = 0,
	@codper int = 0,
	@carnet varchar(30) = '',
	@codusr int = 0,

	@coddmo int = 0,
	@codcil_transferir int = 0,
	@motivo_transferencia varchar(2048) = '',
	
	@codtransest int = 0,
	@estado_colecturia varchar(50) = '', 

	@estado_administracion varchar(50) = '', 

	@fecha_desde nvarchar(12) = '', 
    @fecha_hasta nvarchar(12) = '',
	@txt_buscar varchar(125) = ''
as
begin
	
	set dateformat dmy
	declare @codcil_original int = 0
	select @codcil_original = dmo_codcil from col_dmo_det_mov where dmo_codigo = @coddmo

	if @carnet <> ''
	begin
		select @codper = per_codigo from ra_per_personas where per_carnet = @carnet
	end

	if @opcion = 1 -- Devuelve los pagos de los ultimos 3 meses por @codper
	begin
		select per_codigo, per_carnet, per_nombres_apellidos, mov_codigo, mov_recibo, mov_lote, mov_usuario, mov_fecha_real_pago, 
			concat('0', cil_codcic, '-', cil_anio) 'ciclo_academico_original', dmo_codigo, dmo_codtmo, tmo_arancel, tmo_descripcion, dmo_valor,
			(select 1 from vst_transferencias_ciclo where coddmo = dmo_codigo and (transest_aprobado_colecturia not in (0) or transest_aprobado_administracion_academica not in (0))) 'existe_transest'
		from col_mov_movimientos 
			inner join col_dmo_det_mov on dmo_codmov = mov_codigo
			inner join ra_per_personas on per_codigo = mov_codper
			inner join ra_cil_ciclo on dmo_codcil = cil_codigo
			inner join col_tmo_tipo_movimiento on dmo_codtmo = tmo_codigo
		where mov_codper = @codper 
			and mov_fecha_real_pago between DATEADD(m, -12, getdate()) and getdate() and mov_estado not in ('A')
		order by mov_fecha_real_pago desc
	end

	if @opcion = 2 -- DECANATO, Inserta la solicitud del decanato
	begin
		--if not exists (select 1 from vst_transferencias_ciclo where coddmo = @coddmo)
		--begin
			insert into col_transest_transferencias_estudiantes 
			(transest_codper, transest_coddmo, transest_codcil_original, transest_codcil_transferir, transest_motivo_transferencia, 
			transest_codusr_aprobado_decanato)
			values (@codper, @coddmo, @codcil_original, @codcil_transferir, @motivo_transferencia, 
			@codusr)
		--end

	end

	if @opcion = 3
	begin
		-- exec dbo.sp_col_transest_transferencias_estudiantes @opcion = 3, @carnet = '32-6322-2013'
		select 
		codtransest, estado, transest_aprobado_decanato, transest_aprobado_colecturia, transest_aprobado_administracion_academica, 
		ciclo_academico_original, ciclo_academico_transferir, arancel, tmo_descripcion, valor, transest_fecha_creado_decanato, transest_motivo_transferencia
		from vst_transferencias_ciclo where codper = @codper
		order by codtransest desc
	end

	--Inicio: Colecturia
	if @opcion = 4
	begin
		-- exec dbo.sp_col_transest_transferencias_estudiantes @opcion = 4
		select 
		codtransest, estado, transest_aprobado_decanato, transest_aprobado_colecturia, transest_aprobado_administracion_academica, 
		ciclo_academico_original, ciclo_academico_transferir, arancel, tmo_descripcion, valor, transest_fecha_creado_decanato, transest_motivo_transferencia, 
		codmov, carnet, estudiante, recibo, lote
		from vst_transferencias_ciclo 
		where transest_aprobado_decanato = 1 and transest_aprobado_colecturia is null
			and transest_aprobado_administracion_academica is null
		order by codtransest desc
	end

	if @opcion = 5
	begin
		-- exec dbo.sp_col_transest_transferencias_estudiantes @opcion = 5, @fecha_desde = '05/01/2023', @fecha_hasta = '05/01/2023', @txt_buscar = ''
		select 
		codtransest, estado, transest_aprobado_decanato, transest_aprobado_colecturia, transest_aprobado_administracion_academica, 
		ciclo_academico_original, ciclo_academico_transferir, arancel, tmo_descripcion, valor, transest_fecha_creado_decanato, transest_motivo_transferencia, 
		codmov, carnet, estudiante, recibo, lote, transest_fecha_aprobado_colecturia
		from vst_transferencias_ciclo 
		where transest_aprobado_decanato = 1 and transest_aprobado_colecturia in (1, 0)
			and convert(date, transest_fecha_aprobado_colecturia, 103) between convert(date, @fecha_desde, 103) and convert(date, @fecha_hasta, 103)
			
			and (
				ltrim(rtrim(carnet)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end
				or ltrim(rtrim(codtransest)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end
			)

		order by codtransest desc
	end

	if @opcion = 6 -- COLECTURIA, Actualiza la solicitud por colecturia
	begin
		declare @aprobado_colecturia bit
		set @aprobado_colecturia = case when @estado_colecturia = 'Aprobado' then 1 else 0 end

		update col_transest_transferencias_estudiantes set transest_aprobado_colecturia = @aprobado_colecturia, 
			transest_codusr_aprobado_colecturia = @codusr, transest_estado_colecturia = @estado_colecturia, transest_fecha_aprobado_colecturia = getdate()
		where transest_codigo = @codtransest
		select 1 'respuesta'
	end
	--Fin: Colecturia
	
	--Inicio: Administracion academica
	if @opcion = 7
	begin
		-- exec dbo.sp_col_transest_transferencias_estudiantes @opcion = 7
		select 
		codtransest, estado, transest_aprobado_decanato, transest_aprobado_colecturia, transest_aprobado_administracion_academica, 
		ciclo_academico_original, ciclo_academico_transferir, arancel, tmo_descripcion, valor, transest_fecha_creado_decanato, transest_motivo_transferencia, 
		codmov, carnet, estudiante, recibo, lote, transest_fecha_aprobado_colecturia
		from vst_transferencias_ciclo 
		where transest_aprobado_decanato = 1 and transest_aprobado_colecturia = 1
			and transest_aprobado_administracion_academica is null
		order by codtransest desc
	end

	if @opcion = 8
	begin
		-- exec dbo.sp_col_transest_transferencias_estudiantes @opcion = 8, @fecha_desde = '06/01/2023', @fecha_hasta = '05/01/2023', @txt_buscar = ''
		select 
		codtransest, estado, transest_aprobado_decanato, transest_aprobado_colecturia, transest_aprobado_administracion_academica, 
		ciclo_academico_original, ciclo_academico_transferir, arancel, tmo_descripcion, valor, transest_fecha_creado_decanato, transest_motivo_transferencia, 
		codmov, carnet, estudiante, recibo, lote, transest_fecha_aprobado_colecturia, transest_fecha_aprobado_administracion_academica, coddmo
		from vst_transferencias_ciclo 
		where transest_aprobado_decanato = 1 and transest_aprobado_administracion_academica in (1, 0)
			and convert(date, transest_fecha_aprobado_administracion_academica, 103) between convert(date, @fecha_desde, 103) and convert(date, @fecha_hasta, 103)
			
			and (
				ltrim(rtrim(carnet)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end
				or ltrim(rtrim(codtransest)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end
			)
		order by codtransest desc
	end

	if @opcion = 9 -- Administracion, Actualiza la solicitud por administracion
	begin
		declare @aprobado_administracion bit
		set @aprobado_administracion = case when @estado_administracion = 'Transferido' then 1 else 0 end
		
		select @codcil_transferir = transest_codcil_transferir, @coddmo = transest_coddmo 
		from col_transest_transferencias_estudiantes where transest_codigo = @codtransest

		update col_transest_transferencias_estudiantes set transest_aprobado_administracion_academica = @aprobado_administracion, 
			transest_codusr_aprobado_administracion_academica = @codusr, transest_estado_administracion_academica = @estado_administracion, 
			transest_fecha_aprobado_administracion_academica = getdate()
		where transest_codigo = @codtransest

		update col_dmo_det_mov set dmo_codcil = @codcil_transferir where dmo_codigo = @coddmo

		select 1 'respuesta'
	end
	--Fin: Administracion academica
end
