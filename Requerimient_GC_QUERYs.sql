--drop table col_hismov_historico_movimientos
create table col_hismov_historico_movimientos(
	hismov_codigo int primary key identity(1, 1),
	hismov_codmov int,
	hismov_XML_original nvarchar(max),
	hismov_XML nvarchar(max),
	hismov_accion char(1), --U: Update, D: Delete, I: Insert
	hismov_fecha_creacion datetime default getdate()
)
--select * from col_hismov_historico_movimientos

--drop table col_hisdmo_historico_detalle_movimientos
create table col_hisdmo_historico_detalle_movimientos(
	hisdmo_codigo int primary key identity(1, 1),
	hisdmo_codmov int,
	hisdmo_XML_original nvarchar(max),
	hisdmo_XML nvarchar(max),
	hisdmo_accion char(1), --U: Update, D: Delete, I: Insert
	hisdmo_fecha_creacion datetime default getdate()
)
--select * from col_hisdmo_historico_detalle_movimientos

alter trigger tr_col_mov_update
on [dbo].[col_mov_movimientos] after update
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-02-13 10:56:52.367>
	-- Description: <Trigger cuando se realiza un update a  la tabla col_mov_movimientos, se creo para auditar todos los cambios a los movimientos>
	-- =============================================
as
begin
	print 'tr_col_mov_update'
	declare @old_codcil int, @new_codcil int, 
	@codmov int, @campos_cambiados nvarchar(1024) = ''

	select @codmov = mov_codigo from inserted

	select * into #inserted from inserted
	select * into #deleted from deleted
	
	if exists(select 1 from  inserted i inner join deleted d on i.mov_codigo= d.mov_codigo and i.mov_codreg <> d.mov_codreg)
		set @campos_cambiados = @campos_cambiados + ',' + 'mov_codreg'
	if exists(select 1 from  inserted i inner join deleted d on i.mov_codigo= d.mov_codigo and i.mov_recibo <> d.mov_recibo)
		set @campos_cambiados = @campos_cambiados + ',' + 'mov_recibo'
	if exists(select 1 from  inserted i inner join deleted d on i.mov_codigo= d.mov_codigo and i.mov_codper <> d.mov_codper)
		set @campos_cambiados = @campos_cambiados + ',' + 'mov_codper, per_carnet, per_nombres, per_apellidos'
	if exists(select 1 from  inserted i inner join deleted d on i.mov_codigo= d.mov_codigo and i.mov_codcil <> d.mov_codcil)
		set @campos_cambiados = @campos_cambiados + ',' + 'mov_codcil, concat(''0'',cil_codcic, cil_anio) ciclo'
	if exists(select 1 from  inserted i inner join deleted d on i.mov_codigo= d.mov_codigo and i.mov_estado <> d.mov_estado)
		set @campos_cambiados = @campos_cambiados + ',' + 'mov_estado'
	if exists(select 1 from  inserted i inner join deleted d on i.mov_codigo= d.mov_codigo and i.mov_forma_pago <> d.mov_forma_pago)
		set @campos_cambiados = @campos_cambiados + ',' + 'mov_forma_pago'
	if exists(select 1 from  inserted i inner join deleted d on i.mov_codigo= d.mov_codigo and i.mov_lote <> d.mov_lote)
		set @campos_cambiados = @campos_cambiados + ',' + 'mov_lote'
	if exists(select 1 from  inserted i inner join deleted d on i.mov_codigo= d.mov_codigo and i.mov_fecha_real_pago <> d.mov_fecha_real_pago)
		set @campos_cambiados = @campos_cambiados + ',' + 'mov_fecha_real_pago'
	if exists(select 1 from  inserted i inner join deleted d on i.mov_codigo= d.mov_codigo and i.mov_fecha_cobro <> d.mov_fecha_cobro)
		set @campos_cambiados = @campos_cambiados + ',' + 'mov_fecha_cobro'
	if exists(select 1 from  inserted i inner join deleted d on i.mov_codigo= d.mov_codigo and i.mov_usuario <> d.mov_usuario)
		set @campos_cambiados = @campos_cambiados + ',' + 'mov_usuario'
	if exists(select 1 from  inserted i inner join deleted d on i.mov_codigo= d.mov_codigo and i.mov_usuario_anula <> d.mov_usuario_anula)
		set @campos_cambiados = @campos_cambiados + ',' + 'mov_usuario_anula'
	if exists(select 1 from  inserted i inner join deleted d on i.mov_codigo= d.mov_codigo and i.mov_puntoxpress <> d.mov_puntoxpress)
		set @campos_cambiados = @campos_cambiados + ',' + 'mov_puntoxpress'
	if exists(select 1 from  inserted i inner join deleted d on i.mov_codigo= d.mov_codigo and i.mov_recibo_puntoxpress <> d.mov_recibo_puntoxpress)
		set @campos_cambiados = @campos_cambiados + ',' + 'mov_recibo_puntoxpress'

	if len(@campos_cambiados) > 0
	begin
		print 'if len(@campos_cambiados) > 0'
		declare @texto_sql nvarchar(1024), @texto_sql_original nvarchar(1024),
		@hismov_XML_original nvarchar(max), @hismov_XML nvarchar(max)
		select @texto_sql = concat('select @salida = concat(''<modificado>'', 
		cast((select ',stuff((@campos_cambiados),1, 1, ''), 
		' from #inserted as i 
		inner join ra_per_personas as per on i.mov_codper = per.per_codigo
		inner join ra_cil_ciclo as cil on cil.cil_codigo = i.mov_codcil
		for xml path('''')) as nvarchar(max)), ''</modificado>'')')

		exec sp_executesql @texto_sql, N'@salida nvarchar(max) out', @hismov_XML out
		select @texto_sql_original = concat('select @salida = concat(''<original>'', 
		cast((select ',stuff((@campos_cambiados),1, 1, ''), 
		' from #deleted as d 
		inner join ra_per_personas as per on d.mov_codper = per.per_codigo
		inner join ra_cil_ciclo as cil on cil.cil_codigo = d.mov_codcil
		for xml path('''')) as nvarchar(max)), ''</original>'')')
		exec sp_executesql @texto_sql_original, N'@salida nvarchar(max) out', @hismov_XML_original out
		insert into col_hismov_historico_movimientos (hismov_codmov, hismov_XML_original, hismov_XML, hismov_accion)
		values (@codmov, @hismov_XML_original, @hismov_XML, 'U')
	end
	else
	begin
		print 'if len(@campos_cambiados) < 0'
		--select * from deleted
	end
	drop table #inserted
	drop table #deleted
end
go

create trigger tr_col_mov_delete
on [dbo].[col_mov_movimientos] after delete
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-02-13 10:56:52.367>
	-- Description: <Trigger cuando se realiza un delete a  la tabla col_mov_movimientos, se creo para auditar todos los cambios a los movimientos>
	-- =============================================
as
begin
	print 'tr_col_mov_del'
	declare @old_codcil int, @new_codcil int, 
	@codmov int, @campos_cambiados nvarchar(1024) = ''

	select @codmov = mov_codigo from deleted

	select * into #deleted from deleted
	
	declare @texto_sql_original nvarchar(1024),
	@hismov_XML_original nvarchar(max)
	select @texto_sql_original = concat('select @salida = concat(''<original-delete>'', cast((
	select ','d.mov_codigo, mov_recibo, mov_fecha, mov_codper, per_nombres, per_apellidos, per_carnet, 
	concat(''0'',cil_codcic, cil_anio) ciclo, mov_descripcion, mov_tipo_pago, mov_cheque, mov_estado, mov_tarjeta, mov_usuario,
	mov_fecha_registro, mov_usuario_anula, mov_fecha_anula, mov_historia, mov_tipo, ban_nombre, mov_forma_pago, dip_nombre, mdp_nombre, 
	mov_lote, mov_fecha_cobro, mov_puntoxpress, mov_recibo_puntoxpress, mov_fecha_real_pago', ' 
	from #deleted as d 
	inner join ra_per_personas as per on d.mov_codper = per.per_codigo
	inner join ra_cil_ciclo as cil on cil.cil_codigo = d.mov_codcil
	left join adm_ban_bancos as ban on ban.ban_codigo = d.mov_codban
	left join dip_dip_diplomados as dip on dip.dip_codigo = d.mov_coddip
	left join dip_mdp_modulos_diplomado as mdp on mdp.mdp_codigo = d.mov_codmdp','
	for xml path(''''))  as nvarchar(max)), ''</original-delete>'')')
	exec sp_executesql @texto_sql_original, N'@salida nvarchar(max) out', @hismov_XML_original out
	insert into col_hismov_historico_movimientos (hismov_codmov, hismov_XML_original, hismov_XML, hismov_accion)
	values (@codmov, @hismov_XML_original, '', 'D')

	drop table #deleted
end
go

--insert into col_mov_movimientos (mov_codreg,mov_codigo, mov_codper, mov_recibo, mov_fecha, mov_codcil, mov_descripcion,mov_tipo_pago, mov_cheque, mov_estado, mov_tarjeta, mov_usuario, mov_fecha_registro, mov_usuario_anula, mov_fecha_anula, mov_codmod, mov_historia, mov_tipo, mov_codban, mov_forma_pago, mov_coddip,  mov_codmdp, mov_codfea, mov_lote, mov_fecha_cobro, mov_cliente, mov_codfac, mov_puntoxpress, mov_recibo_puntoxpress, mov_fecha_real_pago) 
--values (1, 9999999, 181324, 100, getdate(), 122, '', '', '', '','','',getdate(),'','','','','','','','','', '', '', getdate(), '', '', '','',getdate())
create trigger tr_col_mov_insert
on [dbo].[col_mov_movimientos] after insert
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-02-13 10:56:52.367>
	-- Description: <Trigger cuando se realiza un insert a  la tabla col_mov_movimientos, se creo para auditar todos los cambios a los movimientos>
	-- =============================================
as
begin
	print 'tr_col_mov_insert'
	declare @old_codcil int, @new_codcil int, 
	@codmov int, @campos_cambiados nvarchar(1024) = ''

	select @codmov = mov_codigo from inserted

	select * into #inserted from inserted

	declare @texto_sql_original nvarchar(1024),
	@hismov_XML_original nvarchar(max)

	select @texto_sql_original = concat('select @salida = concat(''<original>'', cast((
	select ','d.mov_codreg, d.mov_codigo, mov_recibo, mov_fecha, mov_codper, per_nombres, per_apellidos, per_carnet, 
	concat(''0'',cil_codcic, cil_anio) ciclo, mov_descripcion, mov_tipo_pago, mov_cheque, mov_estado, mov_tarjeta, mov_usuario,
	mov_fecha_registro, mov_usuario_anula, mov_fecha_anula, mov_historia, mov_tipo, ban_nombre, mov_forma_pago, dip_nombre, mdp_nombre, 
	mov_lote, mov_fecha_cobro, mov_puntoxpress, mov_recibo_puntoxpress, mov_fecha_real_pago', ' 
	from #inserted as d 
	inner join ra_per_personas as per on d.mov_codper = per.per_codigo
	inner join ra_cil_ciclo as cil on cil.cil_codigo = d.mov_codcil
	left join adm_ban_bancos as ban on ban.ban_codigo = d.mov_codban
	left join dip_dip_diplomados as dip on dip.dip_codigo = d.mov_coddip
	left join dip_mdp_modulos_diplomado as mdp on mdp.mdp_codigo = d.mov_codmdp','
	for xml path(''''))  as nvarchar(max)), ''</original>'')')

	exec sp_executesql @texto_sql_original, N'@salida nvarchar(max) out', @hismov_XML_original out
	insert into col_hismov_historico_movimientos (hismov_codmov, hismov_XML_original, hismov_XML, hismov_accion)
	values (@codmov, @hismov_XML_original, '', 'I')

	drop table #inserted
end
go

create trigger tr_col_dmov_update
on [dbo].[col_dmo_det_mov] after update
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-02-13 10:56:52.367>
	-- Description: <Trigger cuando se realiza un update a  la tabla col_dmo_det_mov, se creo para auditar todos los cambios a los movimientos>
	-- =============================================
as
begin
	print 'tr_col_dmov_update'
	declare @old_codcil int, @new_codcil int, 
	@codmov int, @campos_cambiados nvarchar(1024) = ''

	select @codmov = dmo_codmov from inserted

	select * into #inserted from inserted
	select * into #deleted from deleted
	
	if exists(select 1 from  inserted i inner join deleted d on i.dmo_codmov= d.dmo_codmov and i.dmo_codtmo <> d.dmo_codtmo)
		set @campos_cambiados = @campos_cambiados + ',' + 'dmo_codtmo, tmo_descripcion, tmo_arancel, tmo_valor'
	if exists(select 1 from  inserted i inner join deleted d on i.dmo_codmov= d.dmo_codmov and i.dmo_cantidad <> d.dmo_cantidad)
		set @campos_cambiados = @campos_cambiados + ',' + 'dmo_cantidad'
	if exists(select 1 from  inserted i inner join deleted d on i.dmo_codmov= d.dmo_codmov and i.dmo_valor <> d.dmo_valor)
		set @campos_cambiados = @campos_cambiados + ',' + 'dmo_valor'
	if exists(select 1 from  inserted i inner join deleted d on i.dmo_codmov= d.dmo_codmov and i.dmo_iva <> d.dmo_iva)
		set @campos_cambiados = @campos_cambiados + ',' + 'dmo_iva'
	if exists(select 1 from  inserted i inner join deleted d on i.dmo_codmov= d.dmo_codmov and i.dmo_descuento <> d.dmo_descuento)
		set @campos_cambiados = @campos_cambiados + ',' + 'dmo_descuento'
	if exists(select 1 from  inserted i inner join deleted d on i.dmo_codmov= d.dmo_codmov and i.dmo_mes <> d.dmo_mes)
		set @campos_cambiados = @campos_cambiados + ',' + 'dmo_mes'
	if exists(select 1 from  inserted i inner join deleted d on i.dmo_codmov= d.dmo_codmov and i.dmo_codcil <> d.dmo_codcil)
		set @campos_cambiados = @campos_cambiados + ',' + 'dmo_codcil, concat(''0'',cil_codcic, cil_anio) ciclo'
	if exists(select 1 from  inserted i inner join deleted d on i.dmo_codmov= d.dmo_codmov and i.dmo_cargo <> d.dmo_cargo)
		set @campos_cambiados = @campos_cambiados + ',' + 'dmo_cargo'
	if exists(select 1 from  inserted i inner join deleted d on i.dmo_codmov= d.dmo_codmov and i.dmo_abono <> d.dmo_abono)
		set @campos_cambiados = @campos_cambiados + ',' + 'dmo_abono'
	if exists(select 1 from  inserted i inner join deleted d on i.dmo_codmov= d.dmo_codmov and i.dmo_eval <> d.dmo_eval)
		set @campos_cambiados = @campos_cambiados + ',' + 'dmo_eval'
	if exists(select 1 from  inserted i inner join deleted d on i.dmo_codmov= d.dmo_codmov and i.dmo_descripcion <> d.dmo_descripcion)
		set @campos_cambiados = @campos_cambiados + ',' + 'dmo_descripcion'

	if len(@campos_cambiados) > 0
	begin
		print 'if len(@campos_cambiados) > 0'
		declare @texto_sql nvarchar(1024), @texto_sql_original nvarchar(1024),
		@hisdmo_XML_original nvarchar(max), @hisdmo_XML nvarchar(max)
		select @texto_sql = concat('select @salida = concat(''<modificado>'', 
		cast((select ',stuff((@campos_cambiados),1, 1, ''), ' from #inserted as i
		inner join ra_cil_ciclo as cil on cil.cil_codigo = i.dmo_codcil
		left join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = i.dmo_codtmo
		for xml path('''')) as nvarchar(max)), ''</modificado>'')')
		exec sp_executesql @texto_sql, N'@salida nvarchar(max) out', @hisdmo_XML out
		select @texto_sql_original = concat('select @salida = concat(''<original>'', 
		cast((select ',stuff((@campos_cambiados),1, 1, ''), ' from #deleted as d 
		inner join ra_cil_ciclo as cil on cil.cil_codigo = d.dmo_codcil
		left join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = d.dmo_codtmo
		for xml path('''')) as nvarchar(max)), ''</original>'')')
		exec sp_executesql @texto_sql_original, N'@salida nvarchar(max) out', @hisdmo_XML_original out
		insert into col_hisdmo_historico_detalle_movimientos (hisdmo_codmov, hisdmo_XML_original, hisdmo_XML, hisdmo_accion)
		values (@codmov, @hisdmo_XML_original, @hisdmo_XML, 'U')
	end
	else
	begin
		print 'if len(@campos_cambiados) < 0'
		--select * from deleted
	end
	drop table #inserted
	drop table #deleted
end
go

create trigger tr_col_dmov_delete
on [dbo].[col_dmo_det_mov] after delete
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-02-13 10:56:52.367>
	-- Description: <Trigger cuando se realiza un delete a  la tabla col_dmo_det_mov, se creo para auditar todos los cambios a los movimientos>
	-- =============================================
as
begin
	print 'tr_col_dmov_delete'
	declare @old_codcil int, @new_codcil int, 
	@codmov int, @campos_cambiados nvarchar(1024) = ''

	select @codmov = dmo_codmov from deleted

	select * into #deleted from deleted

	declare @texto_sql_original nvarchar(1024),
	@hisdmo_XML_original nvarchar(max)
	select @texto_sql_original = concat('select @salida = concat(''<original-delete>'', cast((
	select ','d.dmo_codreg, d.dmo_codmov, d.dmo_codigo, d.dmo_codtmo, tmo_arancel, tmo_descripcion, tmo_valor, dmo_cantidad, dmo_valor, dmo_codmat, dmo_iva, 
	per_nombres, per_apellidos, per_carnet, 
	dmo_fecha_registro, dmo_descuento, dmo_mes, dmo_codcil, concat(''0'',cil_codcic, cil_anio) ciclo, dmo_cargo, dmo_abono, dmo_eval, 
	dmo_descripcion', ' 
	from #deleted as d 
	inner join col_mov_movimientos as mov on mov.mov_codigo = d.dmo_codmov
	inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = d.dmo_codtmo
	inner join ra_per_personas as per on mov.mov_codper = per.per_codigo
	inner join ra_cil_ciclo as cil on cil.cil_codigo = d.dmo_codcil ','
	for xml path(''''))  as nvarchar(max)), ''</original-delete>'')')
	select @texto_sql_original
	--select @texto_sql_original = concat('select @salida = concat(''<original-delete>'', cast((select ','*', ' from #deleted for xml path(''''))  as nvarchar(max)), ''</original-delete>'')')
	--select @texto_sql_original
	exec sp_executesql @texto_sql_original, N'@salida nvarchar(max) out', @hisdmo_XML_original out
	insert into col_hisdmo_historico_detalle_movimientos (hisdmo_codmov, hisdmo_XML_original, hisdmo_XML, hisdmo_accion)
	values (@codmov, @hisdmo_XML_original, '', 'D')

	drop table #deleted
end
go

create trigger tr_col_dmov_insert
on [dbo].[col_dmo_det_mov] after insert
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-02-13 10:56:52.367>
	-- Description: <Trigger cuando se realiza un insert a la tabla col_dmo_det_mov, se creo para auditar todos los cambios a los movimientos>
	-- =============================================
as
begin
	print 'tr_col_dmov_insert'
	declare @old_codcil int, @new_codcil int, 
	@codmov int, @campos_cambiados nvarchar(1024) = ''

	select @codmov = dmo_codmov from inserted

	select * into #inserted from inserted

	declare @texto_sql_original nvarchar(1024),
	@hisdmo_XML_original nvarchar(max)

	select @texto_sql_original = concat('select @salida = concat(''<original-insert>'', cast((select ',
	'dmo_codreg, dmo_codmov, dmo_codigo, dmo_codtmo, tmo_descripcion, tmo_arancel, tmo_valor, dmo_cantidad, dmo_valor, dmo_codmat, dmo_iva, dmo_fecha_registro, 
	dmo_descuento, dmo_mes, dmo_codcil, concat(''0'',cil_codcic, cil_anio) ciclo, dmo_cargo, dmo_abono, dmo_eval, dmo_descripcion', 
	' from #inserted as i
	inner join ra_cil_ciclo as cil on cil.cil_codigo = i.dmo_codcil
	left join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = i.dmo_codtmo
	for xml path(''''))  as nvarchar(max)), ''</original-insert>'')')
	exec sp_executesql @texto_sql_original, N'@salida nvarchar(max) out', @hisdmo_XML_original out
	insert into col_hisdmo_historico_detalle_movimientos (hisdmo_codmov, hisdmo_XML_original, hisdmo_XML, hisdmo_accion)
	values (@codmov, @hisdmo_XML_original, '', 'I')

	drop table #inserted
end
go

create procedure sp_delete_tr_mov_dmo
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-02-18 08:05:16.138>
	-- Description: <Borra todos los triggers de las tablas col_mov_movimientos, col_dmo_det_mov creados para la auditoria de pagos>
	-- =============================================
as
begin
	drop trigger tr_col_mov_update
	drop trigger tr_col_mov_delete
	drop trigger tr_col_mov_insert
	drop trigger tr_col_dmov_update
	drop trigger tr_col_dmov_delete
	drop trigger tr_col_dmov_insert
end
go

--select * from col_mov_movimientos where mov_codper = 181324 and mov_codcil = 122
--select tmo_descripcion, tmo_arancel, tmo_valor from col_tmo_tipo_movimiento
--select * from col_dmo_det_mov 
--where dmo_codmov = 6210319
--select * from col_mov_movimientos where mov_recibo = 2 order by mov_codigo asc
--delete col_mov_movimientos where mov_codigo = 10000001
--delete col_dmo_det_mov where dmo_codmov = 10000001
--update col_mov_movimientos set mov_lote = 20 where mov_codigo = 6207706

--select * from col_tmo_tipo_movimiento where tmo_codigo = 50
--update col_dmo_det_mov set dmo_codtmo = 50 where dmo_codmov = 6207706

--DELETE from col_dmo_det_mov where dmo_codigo = 46330

alter procedure sp_auditoria_pagos
	-- sp_auditoria_pagos 1, 6210349 --Devuelve historico de los cambios realizados al encabezado del pago @codmov
	-- sp_auditoria_pagos 2, 0, 1, 21 --Devuelve historico de los cambios realizados al encabezado del recibo @recibo para el lote @lote

	-- sp_auditoria_pagos 3, 6210349 --Devuelve historico de los cambios realizados al detalle del pago @codmov
	-- sp_auditoria_pagos 4, 0, 2, 21 --Devuelve historico de los cambios realizados al detalle del recibo @recibo para el lote @lote
	
	-- sp_auditoria_pagos 5, 0, 2, 21, '17/02/2020' --Devuelve la lista de historico de los cambios realizados a los pagos el dia @fecha_auditoria
	@opcion int = 0,
	@codmov int = 0,
	@recibo int = 0,
	@lote int = 0,
	@fecha_auditoria nvarchar(12) = ''
as
begin
	set dateformat dmy

	if @opcion = 1
	begin
		select * from col_hismov_historico_movimientos where hismov_codmov = @codmov
	end

	if @opcion = 2
	begin
		select * from col_hismov_historico_movimientos where hismov_codmov in(
			select mov_codigo from col_mov_movimientos where mov_recibo = @recibo and mov_lote = @lote
		)
	end

	if @opcion = 3
	begin
		select * from col_hisdmo_historico_detalle_movimientos where hisdmo_codmov = @codmov
	end

	if @opcion = 4
	begin
		select * from col_hisdmo_historico_detalle_movimientos where hisdmo_codmov in(select mov_codigo from col_mov_movimientos where mov_recibo = @recibo and mov_lote = @lote)
	end

	if @opcion = 5
	begin
		select distinct hismov_codmov, mov_recibo, mov_lote, 
		(select distinct concat('.',case hismov_accion when 'D' then 'E' when 'I' then 'I' else 'A' end, '') from col_hismov_historico_movimientos where hismov_codmov = hismov.hismov_codmov  for xml path('')) 'Encabezado',
		(select distinct concat('.',case hisdmo_accion when 'D' then 'E' when 'I' then 'I' else 'A' end, '') from col_hisdmo_historico_detalle_movimientos where hisdmo_codmov = hismov.hismov_codmov  for xml path('')) 'Detalle'
		from col_hismov_historico_movimientos as hismov
			left join col_mov_movimientos on mov_codigo = hismov_codmov
		where 
		convert(date, hismov_fecha_creacion, 103) = convert(nvarchar, @fecha_auditoria, 103)
		--and hismov_accion <> 'I'
	end

end
--select * from col_mov_movimientos 
--inner join ra_per_personas on per_codigo = mov_codper AND mov_codper = 181324 and mov_codcil = 122
--where mov_recibo = 333388 and mov_lote = 20

--update col_mov_movimientos set mov_lote = 21 where mov_codigo = 6216654