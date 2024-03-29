USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[genera_partida_tesoreria]    Script Date: 3/3/2021 20:11:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:      <>
	-- Create date: <>
	-- Last modify: <Fabio, 2021-03-03 20:46:14.874>
	-- Description: <Realiza la carga de la partida contable de tesoreria a contabilidad>
	-- =============================================
	-- exec dbo.genera_partida_tesoreria2 1, 1, '25/02/2021', '25/02/2021', '25/02/2021', 343
	-- debe - haber = 46182.55 - 43982.55 = 2200

alter proc [dbo].[genera_partida_tesoreria2]
	@coduni int,
	@codreg int,
	@fecha varchar(10),
	@fecha_cobro varchar(10),
	@fecha_partida varchar(10),
	@usuario_audita varchar(200)

as
begin

	set dateformat dmy

	declare @codcia int, @partida int,
	@total float, @corr real,
	@cuenta int, @partida_mes varchar(15),
	@usuario varchar(1), @periodo int,
	@total_debe float, @total_haber float,
	@contador int, @tmp_par_partida varchar(10),
	@tmp_par_codigo int, @desc_codtpl varchar(100),
	@fecha_pago datetime, @no_cheque varchar(10),
	@proveedor int, @valor_cheque float,
	@no_partida int, @fecha_cheque varchar(10),
	@contador_cheque int, @prefijo varchar(3),

	@tipo_partida int, @concepto_partida varchar(100),
	@numero_cheque int, @max_partida varchar(5),
	@nombre_universidad varchar(100), @titulo varchar(250),
	@posicion int, @pec_codigo int,
	@anio int, @mes int,
	@fecha_al varchar(10), @max_codpar int

	begin transaction

	declare @cuenta_banco int,
	@cuenta_ban varchar(20), @desc_cuenta_ban varchar(60),
	@cuenta_iva int, @codcuc_ban int,
	@cta_cobrar varchar(20), @desc_cuenta_cobrar varchar(60)

	set @fecha_al = @fecha
	set @anio = year(@fecha_partida)
	set @mes = month(@fecha_partida)

	set @cuenta_banco = 4
	set @cuenta_iva = 567

	select @codcuc_ban = cuc_codigo, @cuenta_ban = cuc_cuenta, @desc_cuenta_ban = cuc_descripcion
	from con_cuc_cuentas_contables where cuc_codigo = @cuenta_banco

	select @cta_cobrar = cuc_cuenta, @desc_cuenta_cobrar = cuc_descripcion
	from con_cuc_cuentas_contables where cuc_cuenta = '1130101'

	select @tipo_partida = 1
	select @codcia = @coduni

	select @concepto_partida = 'Ingresos Tesorería ' + @fecha

	select @contador = count(1), @tmp_par_partida = par_partida, @tmp_par_codigo = par_codigo
	from con_par_partidas where par_concepto = @concepto_partida
	and par_anio = year(@fecha_partida) and par_mes = month(@fecha_partida)
	group by par_partida, par_codigo

	--If @contador = 1
	--Begin
	--	delete from con_pad_partidas_det where pad_codcia = @codcia
	--	and pad_codpar in (
	--		select par_codigo
	--		from con_par_partidas
	--		where par_concepto = @concepto_partida
	--		and par_codigo = @tmp_par_codigo
	--	)

	--	delete from con_par_partidas where par_codcia = @codcia
	--	and par_concepto = @concepto_partida
	--	and par_codigo = @tmp_par_codigo

	--	declare @fecha_aud datetime, @descripcion_aud varchar(500)
	--	select @descripcion_aud = ('Se elimino partida Codigo: ' + cast(@tmp_par_codigo as varchar(20)) 
	--	+ ' Con el Concepto:' + @concepto_partida + ' de la opcion Interfaz Tesoreria')
	--	select @fecha_aud = getdate()
	
	--	exec auditoria_del_sistema 'con_par_partidas', 'E', @usuario_audita, @fecha_aud, @descripcion_aud
	--End

	set @contador = isnull(@contador, 0)
	set @tmp_par_partida = isnull(@tmp_par_partida, 'X')
	set @tmp_par_codigo = isnull(@tmp_par_codigo, 0)

	select @partida = isnull(max(par_codigo), 0) from con_par_partidas

	select @prefijo = tip_prefijo, @posicion = len(tip_prefijo)
	from con_tip_tipo_partidas where tip_codigo = @tipo_partida

	select @pec_codigo = pec_codigo from con_pec_per_contable
	where pec_codcia = @codcia and pec_anio = @anio and pec_mes_desde = @mes and pec_estado = 'A'

	select @max_codpar = max(par_codigo) from con_par_partidas
	where par_codcia = @codcia and par_mes = @mes and par_anio = @anio

	select @max_partida = cast(isnull(max(CONVERT(INT, 
		substring(par_partida, @posicion + 1 + 4, len(par_partida))
	)), 0) + 1 as varchar)
	from con_par_partidas 
	where par_codcia = @codcia and par_mes = @mes and par_anio = @anio and par_codigo = @max_codpar

	select @partida_mes = @prefijo + right('0' + cast(@mes as varchar), 2) + substring(cast(@anio as varchar), 3, 2) 
						+ right('000' + @max_partida, 4)

	select per_tipo,mov_codper, dmo_codtmo, dmo_valor, dmo_iva, mov_codban, mov_tipo_pago,per_carnet,
		per_codigo,tmo_arancel,tmo_cuenta,mov_usuario, mov_recibo
	into #mov
	from ra_per_personas 
		join col_mov_movimientos on per_codigo = mov_codper
		join col_dmo_det_mov on dmo_codmov = mov_codigo
		join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
	where mov_codreg = @codreg
	and mov_fecha between convert(datetime, @fecha, 103) and convert(datetime, @fecha_al, 103)
	and mov_estado <> 'A' and mov_codban = 0

	select per_tipo,mov_codper, dmo_codtmo, dmo_valor, dmo_iva, mov_codban, mov_tipo_pago,per_carnet,
		per_codigo,tmo_arancel,tmo_cuenta, isnull(mov_puntoxpress,0) mov_puntoxpress
	into #mov_bancos
	from col_mov_movimientos 
		join ra_per_personas on per_codigo = mov_codper
		join col_dmo_det_mov on dmo_codmov = mov_codigo
		join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
	where mov_codreg = 1
	and convert(varchar(20),mov_fecha_cobro,103) between @fecha and @fecha_al
	and mov_estado <> 'A' and mov_codban <> 0

	select uni_nombre, reg_nombre, cuenta, descripcion, concepto, tipo, debe, haber,
	convert(datetime,@fecha,103) del, convert(datetime,@fecha_al,103) al, select_num
	into #partida_colecturia
	from (
		select @cuenta_ban cuenta, @desc_cuenta_ban descripcion,
		'Ingreso Tesoreria E/C '+ dbo.fn_fecha_caracter(@fecha) concepto, 'D' tipo,
		sum(round(isnull(dmo_valor,0),2)+ round(isnull(dmo_iva,0),2)) debe, 0 haber, 1 orden, 1 select_num
		from #mov
		where mov_recibo <> '0' 
		or dmo_codtmo = 410 or dmo_codtmo = 913
			
			union all

		select isnull(cuc_cuenta,'S/C') cuenta,isnull(cuc_descripcion,'Sin Cuenta ' + convert(varchar,dmo_codtmo) + ' ' + mov_usuario) descripcion,
		'Faltantes de Efectivo ' + dbo.fn_fecha_caracter(@fecha) concepto,'D' tipo, sum(round(isnull(dmo_valor*-1,0),2)) debe,
		0 haber, 2 orden
		, 2 select_num
		from #mov
			left outer join (
				select * from dbo.adm_usr_usuarios 
					left join con_cuc_cuentas_contables  on usr_codcue =cuc_codigo
			) m on mov_usuario = usr_usuario
		where exists (select 1
		from col_tmo_tipo_movimiento
		where tmo_codigo = dmo_codtmo
		and tmo_cuenta is not null) and  dmo_codtmo=410
		group by isnull(cuc_cuenta,'S/C'),isnull(cuc_descripcion,'Sin Cuenta ' + convert(varchar,dmo_codtmo) + ' ' + mov_usuario)--, tmo_arancel

			union all

		select cuc_cuenta cuenta, cuc_descripcion descripcion,
		ban_nombre + ' ' + cuc_cuenta concepto, 'D' tipo,
		sum(round(isnull(dmo_valor, 0), 2) + round(isnull(dmo_iva, 0), 2)) debe, 0 haber, 1 orden
		, 3 select_num
		from #mov_bancos 
			join adm_ban_bancos on ban_codigo = mov_codban 
			join con_cuc_cuentas_contables on cuc_codigo = ban_codcuc
		where mov_puntoxpress = 0 -- Pagos Normales
		group by cuc_cuenta, cuc_descripcion, ban_nombre + ' ' + cuc_cuenta

			union all

		select cuc_cuenta cuenta, cuc_descripcion descripcion,
		'PUNTOXPRESS ' + ban_nombre + ' ' + cuc_cuenta concepto, 'D' tipo,
		sum(round(isnull(dmo_valor, 0), 2) + round(isnull(dmo_iva, 0), 2)) debe, 0 haber, 1 orden
		, 4 select_num
		from #mov_bancos 
			join adm_ban_bancos on ban_codigo = mov_codban 
			join con_cuc_cuentas_contables on cuc_codigo = ban_codcuc
		where mov_puntoxpress = 1 -- Pagos Puntoxpress
		group by cuc_cuenta, cuc_descripcion, 'PUNTOXPRESS ' + ban_nombre + ' ' + cuc_cuenta

			union all

		select cuc_cuenta cuenta, cuc_descripcion descripcion,
		'POSTVIRTUAL ' + ban_nombre + ' ' + cuc_cuenta concepto, 'D' tipo,
		sum(round(isnull(dmo_valor, 0), 2) + round(isnull(dmo_iva, 0), 2)) debe, 0 haber, 1 orden
		, 5 select_num
		from #mov_bancos 
			join adm_ban_bancos on ban_codigo = mov_codban 
			join con_cuc_cuentas_contables on cuc_codigo = ban_codcuc
		where mov_puntoxpress = 3 -- Pagos POSTVIRTUAL
		group by cuc_cuenta, cuc_descripcion, 'POSTVIRTUAL ' + ban_nombre + ' ' + cuc_cuenta
		
			union all

		select cuc_cuenta cuenta, cuc_descripcion descripcion,
		'PAGO CARNET ' + ban_nombre + ' ' + cuc_cuenta concepto, 'D' tipo,
		sum(round(isnull(dmo_valor, 0), 2) + round(isnull(dmo_iva, 0), 2)) debe, 0 haber, 1 orden
		, 6 select_num
		from #mov_bancos 
			join adm_ban_bancos on ban_codigo = mov_codban 
			join con_cuc_cuentas_contables on cuc_codigo = ban_codcuc
		where mov_puntoxpress = 4 -- Pagos PAGO CARNET
		group by cuc_cuenta, cuc_descripcion, 'PAGO CARNET ' + ban_nombre + ' ' + cuc_cuenta

			union all

		select cuc_cuenta cuenta, cuc_descripcion descripcion,
		'Cuscatlan Carnet ' + ban_nombre + ' ' + cuc_cuenta concepto, 'D' tipo,
		sum(round(isnull(dmo_valor, 0), 2) + round(isnull(dmo_iva, 0), 2)) debe, 0 haber, 1 orden
		, 7 select_num
		from #mov_bancos 
			join adm_ban_bancos on ban_codigo = mov_codban 
			join con_cuc_cuentas_contables on cuc_codigo = ban_codcuc
		where mov_puntoxpress = 5 -- Pagos con carnet Banco Cuscatlan
		group by cuc_cuenta, cuc_descripcion, 'Cuscatlan Carnet ' + ban_nombre + ' ' + cuc_cuenta

			union all

		select cuc_cuenta cuenta, cuc_descripcion descripcion,
		'PAGO Pagadito ' + ban_nombre + ' ' + cuc_cuenta concepto, 'D' tipo,
		sum(round(isnull(dmo_valor, 0), 2) + round(isnull(dmo_iva, 0), 2)) debe, 0 haber, 1 orden
		, 8 select_num
		from #mov_bancos 
				join adm_ban_bancos on ban_codigo = mov_codban 
				join con_cuc_cuentas_contables on cuc_codigo = ban_codcuc
		where mov_puntoxpress = 6 -- PuntoXpress Carnet
		group by cuc_cuenta, cuc_descripcion, 'PAGO Pagadito ' + ban_nombre + ' ' + cuc_cuenta

			union all

		select cuc_cuenta cuenta, cuc_descripcion descripcion,
		'PuntoXpress Carnet ' + ban_nombre + ' ' + cuc_cuenta concepto, 'D' tipo,
		sum(round(isnull(dmo_valor, 0), 2) + round(isnull(dmo_iva, 0), 2)) debe, 0 haber, 1 orden
		, 9 select_num
		from #mov_bancos 
			join adm_ban_bancos on ban_codigo = mov_codban 
			join con_cuc_cuentas_contables on cuc_codigo = ban_codcuc
		where mov_puntoxpress = 7 -- Pagos Pagadito
		group by cuc_cuenta, cuc_descripcion, 'PuntoXpress Carnet ' + ban_nombre + ' ' + cuc_cuenta

			union all

		select cuc_cuenta cuenta, cuc_descripcion descripcion,
		'NPE online ' + ban_nombre + ' ' + cuc_cuenta concepto, 'D' tipo,
		sum(round(isnull(dmo_valor, 0), 2) + round(isnull(dmo_iva, 0), 2)) debe, 0 haber, 1 orden
		, 10 select_num
		from #mov_bancos 
			join adm_ban_bancos on ban_codigo = mov_codban 
			join con_cuc_cuentas_contables on cuc_codigo = ban_codcuc
		where mov_puntoxpress = 8 -- Pagos NPE Banco Agricola
		group by cuc_cuenta, cuc_descripcion, 'NPE online ' + ban_nombre + ' ' + cuc_cuenta

			union all

		select cuc_cuenta cuenta, cuc_descripcion descripcion,
		'Momo carnet ' + ban_nombre + ' ' + cuc_cuenta concepto, 'D' tipo,
		sum(round(isnull(dmo_valor, 0), 2) + round(isnull(dmo_iva, 0), 2)) debe, 0 haber, 1 orden
		, 11 select_num
		from #mov_bancos 
			join adm_ban_bancos on ban_codigo = mov_codban 
			join con_cuc_cuentas_contables on cuc_codigo = ban_codcuc
		where mov_puntoxpress = 9 -- Pagos Momo Carnet
		group by cuc_cuenta, cuc_descripcion, 'Momo carnet ' + ban_nombre + ' ' + cuc_cuenta 

			union all

		select cuc_cuenta cuenta, cuc_descripcion descripcion,
		'Davivienda Carnet ' + ban_nombre + ' ' + cuc_cuenta concepto, 'D' tipo,
		sum(round(isnull(dmo_valor, 0), 2) + round(isnull(dmo_iva, 0), 2)) debe, 0 haber, 1 orden
		, 12 select_num
		from #mov_bancos 
			join adm_ban_bancos on ban_codigo = mov_codban 
			join con_cuc_cuentas_contables on cuc_codigo = ban_codcuc
		where mov_puntoxpress = 10 -- Pagos Davivienda Carnet
		group by cuc_cuenta, cuc_descripcion, 'Davivienda Carnet ' + ban_nombre + ' ' + cuc_cuenta 

			union all

		select cuc_cuenta cuenta, cuc_descripcion descripcion,
		'Banco Azul Carnet ' + ban_nombre + ' ' + cuc_cuenta concepto, 'D' tipo,
		sum(round(isnull(dmo_valor, 0), 2) + round(isnull(dmo_iva, 0), 2)) debe, 0 haber, 1 orden
		, 13 select_num
		from #mov_bancos
			join adm_ban_bancos on ban_codigo = mov_codban 
			join con_cuc_cuentas_contables on cuc_codigo = ban_codcuc
		where mov_puntoxpress = 11 -- Pagos Azul Carnet
		group by cuc_cuenta, cuc_descripcion, 'Banco Azul Carnet ' + ban_nombre + ' ' + cuc_cuenta 

			union all

		select cuc_cuenta cuenta, cuc_descripcion descripcion,
		'Banco Agricola Carnet ' + ban_nombre + ' ' + cuc_cuenta concepto, 'D' tipo,
		sum(round(isnull(dmo_valor, 0), 2) + round(isnull(dmo_iva, 0), 2)) debe, 0 haber, 1 orden
		, 14 select_num
		from #mov_bancos 
			join adm_ban_bancos on ban_codigo = mov_codban 
			join con_cuc_cuentas_contables on cuc_codigo = ban_codcuc
		where mov_puntoxpress = 12 -- Pagos Agricola Carnet
		group by cuc_cuenta, cuc_descripcion, 'Banco Agricola Carnet ' + ban_nombre + ' ' + cuc_cuenta 

			union all

		select cuc_cuenta cuenta, cuc_descripcion descripcion,
		'Banco Scotiabank Carnet ' + ban_nombre + ' ' + cuc_cuenta concepto, 'D' tipo,
		sum(round(isnull(dmo_valor, 0), 2) + round(isnull(dmo_iva, 0), 2)) debe, 0 haber, 1 orden
		, 15 select_num
		from #mov_bancos 
			join adm_ban_bancos on ban_codigo = mov_codban 
			join con_cuc_cuentas_contables on cuc_codigo = ban_codcuc
		where mov_puntoxpress = 13 -- Pagos Scotiabank Carnet
		group by cuc_cuenta, cuc_descripcion, 'Banco Scotiabank Carnet ' + ban_nombre + ' ' + cuc_cuenta 

			union all

		select cuc_cuenta cuenta, cuc_descripcion descripcion,
		'Banco Atlantida Carnet ' + ban_nombre + ' ' + cuc_cuenta concepto, 'D' tipo,
		sum(round(isnull(dmo_valor, 0), 2) + round(isnull(dmo_iva, 0), 2)) debe, 0 haber, 1 orden
		, 16 select_num
		from #mov_bancos 
			join adm_ban_bancos on ban_codigo = mov_codban 
			join con_cuc_cuentas_contables on cuc_codigo = ban_codcuc
		where mov_puntoxpress = 14 -- Pagos Agricola Carnet
		group by cuc_cuenta, cuc_descripcion, 'Banco Atlantida Carnet ' + ban_nombre + ' ' + cuc_cuenta 

		union all

		select cuc_cuenta cuenta, cuc_descripcion descripcion,
		'Banco Azul otros aranceles ' + ban_nombre + ' ' + cuc_cuenta concepto, 'D' tipo,
		sum(round(isnull(dmo_valor, 0), 2) + round(isnull(dmo_iva, 0), 2)) debe, 0 haber, 1 orden
		, 17 select_num
		from #mov_bancos 
		join adm_ban_bancos on ban_codigo = mov_codban 
		join con_cuc_cuentas_contables on cuc_codigo = ban_codcuc
		where mov_puntoxpress = 15 -- Pagos Banco Azul otros aranceles
		group by cuc_cuenta, cuc_descripcion, 'Banco Azul otros aranceles ' + ban_nombre + ' ' + cuc_cuenta 

			union all

		--Incio: PW
		select cuc_cuenta cuenta, cuc_descripcion descripcion,
		'Banco Cuscatlan PayWay ' + ban_nombre + ' ' + cuc_cuenta concepto, 'D' tipo,
		sum(round(isnull(dmo_valor, 0), 2) + round(isnull(dmo_iva, 0), 2)) debe, 0 haber, 1 orden
		, 18 select_num
		from #mov_bancos 
			join adm_ban_bancos on ban_codigo = mov_codban 
			join con_cuc_cuentas_contables on cuc_codigo = ban_codcuc
		where mov_puntoxpress = 16 -- Pagos Banco Agricola
		group by cuc_cuenta, cuc_descripcion, 'Banco Cuscatlan PayWay ' + ban_nombre + ' ' + cuc_cuenta 
		--Fin: PW

			union all

		select cuc_cuenta, cuc_descripcion,
		cast(row_number() over (order by reb_codigo) as varchar) + '. ' + 'Remesa Ingreso ' + dbo.fn_fecha_caracter(reb_fecha_cobro) concepto, 'D' tipo,
		reb_monto debe, 0 haber, 2 orden
		, 19 select_num
		from dbo.col_reb_remesas_banco 
			join adm_ban_bancos on ban_codigo = reb_codban 
			join con_cuc_cuentas_contables on cuc_codigo = ban_codcuc
		where reb_fecha_banco = convert(datetime,@fecha,103)
		
			union all

		select cuc_cuenta, cuc_descripcion,
		'Remesa a Bancos' concepto, 'H' tipo, 0 debe, sum(reb_monto) haber, 3 orden
		, 20 select_num
		from dbo.col_reb_remesas_banco 
			join con_cuc_cuentas_contables on cuc_codigo = @cuenta_banco
		where reb_fecha_banco = convert(datetime,@fecha,103)
		group by cuc_cuenta, cuc_descripcion
			
			union all
			
		select isnull(cuc_cuenta, 'S/C'), isnull(cuc_descripcion, 'Sin Cuenta'),
		'Ingreso Tesoreria ' + dbo.fn_fecha_caracter(@fecha) concepto, 'H' tipo, 0, sum(round(isnull(dmo_iva, 0), 2)) haber, 4 orden
		, 21 select_num
		from #mov 
			join con_cuc_cuentas_contables on cuc_codigo = @cuenta_iva
		group by isnull(cuc_cuenta,'S/C'), isnull(cuc_descripcion, 'Sin Cuenta')

			union all

		--- Iva cobrado en los bancos
		select isnull(cuc_cuenta,'S/C'),isnull(cuc_descripcion,'Sin Cuenta'),
		'Ingreso Bancos '+ dbo.fn_fecha_caracter(@fecha) concepto,'H' tipo,0, 
		sum(round(isnull(dmo_iva,0),2)) haber, 4 orden
		, 22 select_num
		from #mov_bancos
			join con_cuc_cuentas_contables on cuc_codigo = @cuenta_iva
		group by isnull(cuc_cuenta,'S/C'),isnull(cuc_descripcion,'Sin Cuenta')

			union all

		select isnull((cuc_cuenta), 'S/C') cuenta, isnull(cuc_descripcion,'Sin Cuenta ' + tmo_arancel + ' ' + per_carnet),
		'Ingresos en Diplomados ' + dbo.fn_fecha_caracter(@fecha) concepto, 'H' tipo, 0 debe,
		sum(round(isnull(dmo_valor, 0), 2)) haber, 5 orden
		, 23 select_num
		from #mov 
			join con_cuc_cuentas_contables on tmo_cuenta = cuc_cuenta
		where exists (select 1
		from col_tmo_tipo_movimiento
		where tmo_codigo = dmo_codtmo
		and tmo_cuenta is not null) and  dmo_codtmo <> 410
		group by isnull((cuc_cuenta), 'S/C'), isnull(cuc_descripcion,'Sin Cuenta ' + tmo_arancel + ' ' + per_carnet)--, tmo_arancel

			union all

		select isnull((cuc_cuenta), 'S/C') cuenta, isnull(cuc_descripcion, 'Sin Cuenta ' + c.tmo_arancel + ' ' + per_carnet),
		'Ingresos en Diplomados Bancos ' + dbo.fn_fecha_caracter(@fecha) concepto, 'H' tipo, 0 debe,
		sum(round(isnull(dmo_valor, 0), 2)) haber, 5 orden
		, 24 select_num
		from #mov_bancos 
			join col_tmo_tipo_movimiento c on tmo_codigo = dmo_codtmo 
			left outer join con_cuc_cuentas_contables on c.tmo_cuenta = cuc_cuenta
		where exists ( select 1
		from col_tmo_tipo_movimiento
		where tmo_codigo = dmo_codtmo
		and tmo_cuenta is not null)
		group by isnull((cuc_cuenta), 'S/C'), isnull(cuc_descripcion,'Sin Cuenta ' + c.tmo_arancel + ' ' + per_carnet)--, tmo_arancel

			union all

		select isnull(cuc_cuenta,'S/C'),isnull(cuc_descripcion,'Sin Cuenta ' + tmo_arancel + ' ' + per_carnet),
		'Ingreso Tesoreria ' + dbo.fn_fecha_caracter(@fecha) concepto,'H' tipo,0,
		sum(round(isnull(dmo_valor,0),2)), 5 orden
		, 25 select_num
		from #mov
			left outer join col_moc_movimientos_cuenta on moc_codtmo = dmo_codtmo
			and right('00'+ moc_id_carrera,2) = substring(per_carnet,1,2)
			left outer join con_cuc_cuentas_contables on rtrim(ltrim(moc_cuenta)) = cuc_cuenta
			left outer join ra_car_carreras on car_codigo=moc_codcar
		where not exists (select 1
		from col_tmo_tipo_movimiento
		where tmo_codigo = dmo_codtmo
		and tmo_cuenta is not null)
		and moc_id_carrera_cop <> '0'
		and per_tipo <> 'O'
		group by isnull(cuc_cuenta,'S/C'),isnull(cuc_descripcion,'Sin Cuenta ' + tmo_arancel + ' ' + per_carnet)

			union all

		select isnull(cuc_cuenta,'S/C'),isnull(cuc_descripcion,'Sin Cuenta ' + tmo_arancel + ' ' + per_carnet),
		'Ingreso Tesoreria ' + dbo.fn_fecha_caracter(@fecha) concepto,'H' tipo,0,
		sum(round(isnull(dmo_valor,0),2)), 5 orden
		, 26 select_num
		from #mov
			left outer join ra_alc_alumnos_carrera on alc_codper = per_codigo
			left outer join ra_pla_planes on pla_codigo = alc_codpla
			left outer join col_moc_movimientos_cuenta on moc_codtmo = dmo_codtmo and moc_codcar = pla_codcar
			left outer join con_cuc_cuentas_contables on rtrim(ltrim(moc_cuenta)) = cuc_cuenta
		where not exists (select 1
		from col_tmo_tipo_movimiento
		where tmo_codigo = dmo_codtmo
		and tmo_cuenta is not null)
		and moc_id_carrera_cop <> '0' and per_tipo='O'
		group by isnull(cuc_cuenta,'S/C'),isnull(cuc_descripcion,'Sin Cuenta ' + tmo_arancel + ' ' + per_carnet)
			
			union all 

		select isnull(cuc_cuenta,'S/C'),isnull(cuc_descripcion,'Sin Cuenta ' + tmo_arancel + ' ' + per_carnet),
		'Ingreso Tesoreria ' + dbo.fn_fecha_caracter(@fecha) concepto,'H' tipo,0,
		sum(round(isnull(dmo_valor,0),2)), 5 orden
		, 27 select_num
		from #mov
		left outer join col_moc_movimientos_cuenta on moc_codtmo = dmo_codtmo
			and right('00'+ moc_id_carrera,2) = substring(per_carnet,1,2)
		left outer join con_cuc_cuentas_contables on rtrim(ltrim(moc_cuenta)) = cuc_cuenta
		where not exists (select 1
		from col_tmo_tipo_movimiento
		where tmo_codigo = dmo_codtmo
		and tmo_cuenta is not null)
		and moc_id_carrera_cop <> '0' and substring(per_carnet,1,2) in('PA','DI','CL','PO')
		group by isnull(cuc_cuenta, 'S/C'),isnull(cuc_descripcion, 'Sin Cuenta ' + tmo_arancel + ' ' + per_carnet)

			union all

		select isnull(cuc_cuenta,'S/C'),isnull(cuc_descripcion,'Sin Cuenta ' + tmo_arancel + ' ' + per_carnet),
		'Ingreso Bancos ' + dbo.fn_fecha_caracter(@fecha) concepto,'H' tipo,0,
		sum(round(isnull(dmo_valor,0),2)), 5 orden
		, 28 select_num
		from #mov_bancos
		left outer join col_moc_movimientos_cuenta on moc_codtmo = dmo_codtmo
		and right('00'+ moc_id_carrera,2) = substring(per_carnet,1,2)
		left outer join con_cuc_cuentas_contables on moc_cuenta = cuc_cuenta
		left outer join ra_car_carreras on car_codigo=moc_codcar
		where not exists (select 1
		from col_tmo_tipo_movimiento
		where tmo_codigo = dmo_codtmo
		and tmo_cuenta is not null)
		and moc_id_carrera_cop <> '0' and per_tipo <> 'O'
		group by isnull(cuc_cuenta,'S/C'),isnull(cuc_descripcion,'Sin Cuenta ' + tmo_arancel + ' ' + per_carnet)
		
			union all

		select isnull(cuc_cuenta,'S/C'),isnull(cuc_descripcion,'Sin Cuenta ' + tmo_arancel + ' ' + per_carnet),
		'Ingreso Bancos ' + dbo.fn_fecha_caracter(@fecha) concepto,'H' tipo,0,
		sum(round(isnull(dmo_valor,0),2)), 5 orden
		, 29 select_num
		from #mov_bancos
			left outer join ra_alc_alumnos_carrera on alc_codper = per_codigo
			left outer join ra_pla_planes on pla_codigo = alc_codpla
			left outer join col_moc_movimientos_cuenta on moc_codtmo = dmo_codtmo and moc_codcar = pla_codcar
			left outer join con_cuc_cuentas_contables on moc_cuenta = cuc_cuenta
			left outer join ra_car_carreras on car_codigo=moc_codcar
		where not exists (select 1
		from col_tmo_tipo_movimiento
		where tmo_codigo = dmo_codtmo
		and tmo_cuenta is not null)
		and moc_id_carrera_cop <> '0'
		and per_tipo = 'O'
		group by isnull(cuc_cuenta,'S/C'),isnull(cuc_descripcion,'Sin Cuenta ' + tmo_arancel + ' ' + per_carnet)
		
			union all
			
		select isnull(cuc_cuenta,'S/C'),isnull(cuc_descripcion,'Sin Cuenta ' + tmo_arancel + ' ' + per_carnet),
		'Ingreso Bancos ' + dbo.fn_fecha_caracter(@fecha) concepto,'H' tipo,0,
		sum(round(isnull(dmo_valor,0),2)), 5 orden
		, 30 select_num
		from #mov_bancos
		left outer join col_moc_movimientos_cuenta on moc_codtmo = dmo_codtmo ---and moc_codcar = pla_codcar
			and right('00'+ moc_id_carrera,2) = substring(per_carnet,1,2)
		left outer join con_cuc_cuentas_contables on moc_cuenta = cuc_cuenta
		where not exists (select 1
		from col_tmo_tipo_movimiento
		where tmo_codigo = dmo_codtmo
		and tmo_cuenta is not null)
		and substring(per_carnet,1,2) in('PA','DI','CL','PO')
		and moc_id_carrera_cop <> '0'
		group by isnull(cuc_cuenta,'S/C'),isnull(cuc_descripcion,'Sin Cuenta ' + tmo_arancel + ' ' + per_carnet)

			union all

		select cuc_cuenta, cuc_descripcion,'Ingreso Tes. Clientes '+dbo.fn_fecha_caracter(@fecha) concepto, 'H' tipo,
		0 debe,
		case when tmo_exento = 'S' then round(sum(round(isnull(dfa_valor,0),2)),2) when tmo_exento = 'N' then
		case when fac_tipo = 'C' then round(sum(round(isnull(dfa_valor,0),2)),2) 
		when fac_tipo = 'F' then round(sum(round(isnull(dfa_valor,0),2))/1.13,2) 
		when fac_tipo = 'E' then round(sum(round(isnull(dfa_valor,0),2))/1.13,2)
		end end haber, 23 orden
		, 31 select_num
		from col_fac_facturas
			join col_dfa_det_fac on dfa_codfac = fac_codigo
			join col_tmo_tipo_movimiento on tmo_codigo = dfa_codtmo
			join col_cli_clientes on fac_codcli = cli_codigo -- Linea nueva
			join col_gtm_grupo_movimiento on gtm_codigo = tmo_codgtm
			join ra_reg_regionales on reg_codigo = fac_codreg
			join ra_uni_universidad on uni_codigo = reg_coduni
			left outer join con_cuc_cuentas_contables on tmo_cuenta = cuc_cuenta
			left outer join ra_fac_facultades on fac_cuenta = substring(cuc_cuenta,1,3)
		where exists (select 1
		from col_tmo_tipo_movimiento
		where tmo_codigo = dfa_codtmo
		and isnull(tmo_cuenta,'') <> '')
		and fac_estado <> 'A'
		and fac_fecha between convert(datetime,@fecha,103) and convert(datetime,@fecha_al,103)
		and fac_codcli in (select cli_codigo from col_cli_clientes where cli_alumnos = 'N' ) 
		group by cuc_cuenta,cuc_descripcion,fac_tipo,tmo_exento
			
			union all

		select cuc_cuenta, cuc_descripcion,'Ingreso Tes. Clientes '+dbo.fn_fecha_caracter(@fecha) concepto, 'D' tipo,
		case when tmo_exento = 'S' then 
		sum(round(isnull(dfa_valor,0),2)) 
		when tmo_exento = 'N' then
		case when fac_tipo = 'C' then 
		case when cli_desiva = 'S' then  
		sum(round(isnull(dfa_valor,0),2)+round(isnull(dfa_iva,0),2)-round(isnull(dfa_retencion,0),2))
		when cli_desiva = 'N' then 
		sum(round(isnull(dfa_valor,0),2)+round(isnull(dfa_iva,0),2))
		end
		when fac_tipo = 'F' then 
		case when cli_desiva = 'S' then  
		sum(round(isnull(dfa_valor,0),2)-round(isnull(dfa_retencion,0),2))
		when cli_desiva = 'N' then 
		sum(round(isnull(dfa_valor,0),2))
		end
		when fac_tipo = 'E' then 
		case when cli_desiva = 'S' then  
		sum(round(isnull(dfa_valor,0), 2) - round(isnull(dfa_retencion,0),2))
		when cli_desiva = 'N' then 
		sum(round(isnull(dfa_valor,0), 2))
		end else 0 end end debe, 0 haber, 2 orden
		, 32 select_num
		from col_fac_facturas
			join col_dfa_det_fac on dfa_codfac = fac_codigo
			join col_tmo_tipo_movimiento on tmo_codigo = dfa_codtmo
			join col_cli_clientes on fac_codcli = cli_codigo
			join con_cuc_cuentas_contables on cuc_codigo = cli_codcuc
		where fac_estado <> 'A'
		and fac_fecha between convert(datetime,@fecha,103) and convert(datetime,@fecha_al,103)
		group by  cuc_cuenta,cuc_descripcion,tmo_exento,fac_tipo,cli_desiva

			union all

		---Iva retino por los  clientes
		select cuc_cuenta, cuc_descripcion,'Iva Reten. Clientes '+dbo.fn_fecha_caracter(@fecha) concepto, 'D' tipo,
		sum(CASE cli_desiva
		WHEN 'N' THEN 0.00
		ELSE round(isnull(dfa_retencion,0),2)
		END) debe,
		0 haber,2 orden
		, 33 select_num
		from col_fac_facturas
		join col_dfa_det_fac on dfa_codfac = fac_codigo
		join col_cli_clientes on fac_codcli = cli_codigo
		join con_cuc_cuentas_contables on cuc_codigo = 5162 --222
		where fac_estado <> 'A'
		and fac_fecha between convert(datetime,@fecha,103) and convert(datetime,@fecha_al,103)
		group by cuc_cuenta, cuc_descripcion

			union all

		Select cuc_cuenta, cuc_descripcion,'Ingreso Tes. Cli iva '+dbo.fn_fecha_caracter(@fecha) concepto, 'H' tipo,
		0 debe, sum(round(isnull(dfa_iva,0),2)) haber, 4 orden
		, 34 select_num
		from col_fac_facturas
		join col_dfa_det_fac on dfa_codfac = fac_codigo
		join col_cli_clientes on fac_codcli = cli_codigo
		join con_cuc_cuentas_contables on cuc_codigo = 567
		where fac_estado <> 'A'
		and fac_fecha between convert(datetime,@fecha,103) and convert(datetime,@fecha_al,103) 
		and fac_codcli in (select cli_codigo from col_cli_clientes where cli_alumnos = 'N' ) 
		group by cuc_cuenta, cuc_descripcion
	) t
	join ra_reg_regionales on reg_codigo = @codreg
	join ra_uni_universidad on uni_codigo = reg_coduni
	where (debe + haber) <> 0
	order by orden, cuenta

	PRINT 'PASO 1'

	select @corr = isnull(max(pad_codigo), 0) from con_pad_partidas_det
	where pad_codcia = @codcia
	and pad_codpar = case when @contador = 1 then @tmp_par_codigo else @partida + 1 end

	--insert into con_par_partidas
	--(par_codcia, par_codigo, par_partida, par_fecha, par_codtip, par_total_h, par_total_d,par_estado,
	--par_codpec, par_concepto,par_anio,par_mes, par_usuario, par_fecha_crea, par_concepto_general, par_codreg)
	--select @codcia,
	--case when @contador = 1 then @tmp_par_codigo else @partida + 1 end,
	--case when @contador = 1 then @tmp_par_partida else cast(@partida_mes as varchar) end,
	--@fecha_partida, @tipo_partida,
	--@total,@total,'A',@pec_codigo,
	--@concepto_partida ,
	--@anio, @mes, user,
	--getdate(),
	--@concepto_partida + ' - Interfaz Tesorería', @codreg

	--*
	--* Ingresos
	--*

	--insert into con_pad_partidas_det
	--(pad_codcia,pad_codpar, pad_codigo, pad_codcuc, pad_tipo,pad_debe, pad_haber, pad_cuenta, pad_concepto)
	--select @codcia, case when @contador = 1 then @tmp_par_codigo else @partida + 1 end,
	--row_number() over(order by pad_codcuc) + @corr,
	--pad_codcuc, letra, case letra when 'D' then sum(isnull(cargo,0)) else 0 end debe, 
	--case letra when 'H' then sum(isnull(abono,0)) else 0 end haber,
	--concepto, concepto
	--from (
	--	select cuc_codigo pad_codcuc, cuc_cuenta, cuc_descripcion, concepto, tipo letra, debe cargo, haber abono, select_num
	--	from (
	--		select uni_nombre, reg_nombre, cuc_codigo, cuc_cuenta, cuenta,
	--		cuc_descripcion, descripcion, concepto, tipo, debe, haber, del, al
	--		, select_num
	--		from #partida_colecturia 
	--		join con_cuc_cuentas_contables on cuc_cuenta = cuenta
	--	) s
	--) t
	--where pad_codcuc is not null
	--group by pad_codcuc, concepto, letra, select_num

	select cuc_codigo pad_codcuc, cuc_cuenta, cuc_descripcion, concepto, tipo letra, debe cargo, haber abono, select_num
	from (
		select uni_nombre, reg_nombre, cuc_codigo, cuc_cuenta, cuenta,
		cuc_descripcion, descripcion, concepto, tipo, debe, haber, del, al, select_num
		from #partida_colecturia 
		join con_cuc_cuentas_contables on cuc_cuenta = cuenta
	) s
	order by select_num

	drop table #mov
	drop table #mov_bancos
	drop table #partida_colecturia

	select @total_debe = sum(isnull(round(pad_debe, 5),0)),
	@total_haber = sum(isnull(round(pad_haber, 5),0))
	from con_pad_partidas_det
	where pad_codcia = @codcia
	and pad_codpar = case when @contador = 1 then @tmp_par_codigo else @partida + 1 end --* @partida+1

	--update con_par_partidas set par_total_d = @total_debe, par_total_h = @total_haber
	--where par_codcia = @codcia
	--and par_codigo = case when @contador = 1 then @tmp_par_codigo else @partida + 1 end --* @partida+1

	print 'finalizado satisfactoriamente'
	commit transaction

end