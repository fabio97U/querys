USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_pagos_alumno_sencillo]    Script Date: 3/10/2023 14:42:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- exec dbo.rep_pagos_alumno_sencillo 1, '32-4567-2022', 131
ALTER proc [dbo].[rep_pagos_alumno_sencillo]
	@campo0 int,--codreg
	@campo1 varchar(12),--carnet
	@campo2 int --codcil
as
begin

	set dateformat dmy

	declare @codper int, @valor_inicial real, @saldo real

	declare @mov as table (
		mov_codper int,mov_codigo int,  mov_fecha datetime, dmo_valor real, dmo_iva real, dmo_codtmo int, 
		mov_codban int, mov_recibo varchar(20),dmo_cargo real, dmo_abono real,mov_fecha_registro datetime, 
		dmo_codcil int, mov_estado varchar(1) , dmo_codmat varchar(50), mov_puntoxpress int, dmo_eval int, 
		lote int, factura int, mov_fecha_real_pago datetime, mov_usuario varchar(255), numero_control varchar(50), ban_nombre varchar(80)
	)

	select @codper = per_codigo, @saldo = per_saldo from ra_per_personas where per_carnet = @campo1

	print '@codper : ' + cast(@codper as nvarchar(25))

	insert into @mov (mov_codper,mov_codigo,mov_fecha, dmo_valor, dmo_iva,dmo_codtmo,mov_codban, mov_recibo,dmo_cargo,
	dmo_abono,mov_fecha_registro,dmo_codcil, mov_estado, dmo_codmat, mov_puntoxpress, dmo_eval, lote, factura, mov_fecha_real_pago, mov_usuario, numero_control, ban_nombre)

	select mov_codper,mov_codigo, mov_fecha_cobro mov_fecha, dmo_valor, dmo_iva,dmo_codtmo,mov_codban, mov_recibo,dmo_cargo,
	dmo_abono,mov_fecha_registro,dmo_codcil, mov_estado, dmo_codmat, mov_puntoxpress, dmo_eval, mov_lote, mov_recibo, mov_fecha_real_pago, mov_usuario, mov_numero_control, 
	case when mov_codban <> 0 then concat(mov_codban, '') else 'Efectivo' end 'ban_nombre'
	
	from col_mov_movimientos
		join col_dmo_det_mov on dmo_codmov = mov_codigo
		left join adm_ban_bancos on mov_codban = ban_codigo
	where mov_codper = @codper and dmo_codcil = case when @campo2 = 0 then dmo_codcil else @campo2 end and mov_estado <> 'A'

	select "Universidad", "Carnet", "Alumno", tipo,"Carrera", "Regional", 
		ciclo,cil_anio, cil_codcic, mov_recibo, tmo_arancel, mov_fecha,
		case when mov_puntoxpress = 1 then 'PX-'+cast(mov_codban as varchar(10)) else cast(mov_codban as varchar(10)) end mov_codban,
		tmo_descripcion,cargo, abono,saldo,mov_fecha_registro,@saldo saldo_imp, 
		case when tmo_arancel = 'S-04 ' then (select mat_nombre from ra_mat_materias where mat_codigo = dmo_codmat)
		when tmo_arancel = 'S-05 ' then (select dbo.fx_nombre_pre_especializacion_modulo_persona(dmo_eval, per_codigo, dmo_codcil))
		else null end materia, lote, factura, mov_fecha_real_pago, mov_usuario, dmo_eval, numero_control, ban_nombre

	into #Datos

	from (
		select  uni_nombre "Universidad", per_carnet "Carnet", per_apellidos_nombres "Alumno", 
		'Factura' tipo,car_nombre "Carrera", reg_nombre "Regional", 
		'0'+cast(cil_codcic as varchar) + '-' + cast(cil_anio as varchar) ciclo,cil_anio, cil_codcic,
		mov_recibo, tmo_arancel, mov_fecha, mov_codban, tmo_descripcion,
		dmo_cargo cargo, dmo_abono abono,
		isnull(dmo_valor,0)+isnull(dmo_iva,0) valor, codigo as banco,(dmo_cargo - dmo_abono) saldo,
		mov_fecha_registro, dmo_codmat, mov_puntoxpress,  dmo_eval, dmo_codcil, lote, factura, mov_fecha_real_pago, mov_usuario, per_codigo, numero_control, ban_nombre
		from ra_per_personas 
			left outer join ra_alc_alumnos_carrera on alc_codper = per_codigo
			left outer join ra_pla_planes on pla_codigo = alc_codpla
			left outer join ra_car_carreras on car_codigo = pla_codcar
			left outer join ra_fac_facultades on fac_codigo = car_codfac
			join ra_reg_regionales on reg_codigo = @campo0
			join ra_uni_universidad on uni_codigo = reg_coduni
			join @mov on mov_codper = per_codigo
			join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
			join ra_cil_ciclo on cil_codigo = dmo_codcil
			join ra_cic_ciclos on cic_codigo = cil_codcic
			join (
				select 0 codigo, 'COLECTURIA' nombre
					union all
				select ban_codigo, ban_nombre from adm_ban_bancos
			) y on codigo = mov_codban
		where per_codigo = @codper
             
			union all

		select  uni_nombre "Universidad", per_carnet "Carnet", per_apellidos_nombres "Alumno", 
		'Factura' tipo,car_nombre "Carrera", reg_nombre "Regional", 
		'0'+cast(cil_codcic as varchar) + '-' + cast(cil_anio as varchar) ciclo,cil_anio, cil_codcic,
		'' as mov_recibo, tmo_arancel,cas_fecha as mov_fecha,0 as mov_codban,
		tmo_descripcion,isnull(dcs_valor,0) cargo, 0 abono, 0 valor, '' banco,isnull(dcs_valor*-1,0) as saldo,
		cas_fecha as mov_fecha_registro, '' as dmo_codmat, null as mov_puntoxpress, null as dmo_eval, null as dmo_codcil, '' as lote, 
		'' as factura, cas_fecha as mov_fecha_real_pago, '' mov_usuario, per_codigo, '' 'numero_control', '' 'ban_nombre'
		from ra_per_personas 
			left outer join ra_alc_alumnos_carrera on alc_codper = per_codigo
			left outer join ra_pla_planes on pla_codigo = alc_codpla
			left outer join ra_car_carreras on car_codigo = pla_codcar
			left outer join ra_fac_facultades on fac_codigo = car_codfac
			join ra_reg_regionales on reg_codigo = @campo0
			join ra_uni_universidad on uni_codigo = reg_coduni
			join col_cas_cargos_saldos on cas_codper = per_codigo
			join col_dcs_det_cas on dcs_codcas = cas_codigo
			join col_tmo_tipo_movimiento on tmo_codigo = dcs_codtmo
			join ra_cil_ciclo on cil_codigo = dcs_codcil
			join ra_cic_ciclos on cic_codigo = cil_codcic
		where (per_carnet = @campo1 or replace(per_carnet,'-','') = @campo1)
		and cil_codigo = case when @campo2 = 0 then cil_codigo else @campo2 end
	) t

	if (select count(1) from #Datos) > 0
	begin
		select Universidad, Carnet, Alumno, tipo, Carrera, Regional, ciclo, cil_anio, cil_codcic, mov_recibo, tmo_arancel, 
		mov_fecha, mov_codban, tmo_descripcion, cargo, abono, saldo, mov_fecha_registro, saldo_imp, materia, factura, lote, mov_fecha_real_pago, mov_usuario, dmo_eval, numero_control, ban_nombre
		from #Datos 
		order by substring(ciclo,4,4), substring(ciclo,1,2), mov_fecha, mov_fecha_registro asc
	end
	else
	begin
		select '' Universidad, @campo1 as carnet, '' as Alumno, '' as Tipo, '' as Carrera, '' as Regional, '' as ciclo, 0 as cil_anio, 
		0 as cil_codcic, '0' as mov_recibo, '' as tmo_arancel, '' as mov_fecha, 0 as mov_codban, '' as tmo_descripcion, 
		0 as cargo, 0 as abono, 0 as saldo, '' as mov_fecha_registro, 0 as saldo_imp, '' as materia, '' as factura, '' as lote, '' as mov_fecha_real_pago, '' mov_usuario, '' dmo_eval, '' 'numero_control', '' 'ban_nombre'
	end

end
go



USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_anuladas]    Script Date: 3/10/2023 15:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- exec rep_anuladas 1, '01/10/2023', '03/10/2023'
ALTER proc [dbo].[rep_anuladas]
    @regional int,
    @fecha1 varchar(10),
    @fecha2 varchar(10)
as
begin
	set dateformat dmy

    select uni_nombre,'FACTURAS' TIPO,
    mov_recibo, per_carnet,per_apellidos_nombres,
    sum(isnull((dmo_valor + isnull(dmo_iva,0)),0)) "Cantidad",@fecha1  del, @fecha2 al, usr_usuario usr_nombre,mov_usuario as sol_anulacion,
	mov_fecha, mov_fecha_anula, mov_lote, mov_recibo_puntoxpress, mov_codigo, 

	vst.codigo_generacion_inva, vst.numero_control_inva, vst.razon_ti024, vst.motivo_anulacion, vst.responsable_anulacion, vst.solicitante_inva, vst.fecha_creacion, vst.codigo_generacion_nuevo_dte, ban_codigo

    from col_mov_movimientos 
		join col_dmo_det_mov on dmo_codmov = mov_codigo
		join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
		join ra_per_personas on per_codigo = mov_codper
		join ra_reg_regionales on reg_codigo = mov_codreg
		join ra_uni_universidad on uni_codigo = reg_coduni
		join adm_usr_usuarios on usr_usuario = mov_usuario_anula

		left join vst_mh_invalidaciones_dte vst on vst.codigo_origen = mov_codigo and vst.tipo_dte_numero = 1
		left join adm_ban_bancos on mov_codban = ban_codigo
    where mov_codreg = @regional
    and cast(mov_fecha_anula as date) between cast(@fecha1 as date) and cast(@fecha2 as date)
    and mov_estado = 'A'

    group by uni_nombre,mov_recibo, per_carnet, usr_nombre,
    per_apellidos_nombres,mov_usuario,mov_usuario, mov_fecha, mov_fecha_anula, mov_lote, mov_recibo_puntoxpress, usr_usuario, mov_codigo,

	vst.codigo_generacion_inva, vst.numero_control_inva, vst.razon_ti024, vst.motivo_anulacion, vst.responsable_anulacion, vst.solicitante_inva, vst.fecha_creacion, vst.codigo_generacion_nuevo_dte, ban_codigo

		union all

    select uni_nombre,case when fac_tipo = 'F' then 'Facturas' else 'Credito Fiscal' end tipo,
    CASE WHEN isnumeric(fac_factura) = 0 then '0' else fac_factura end fac_factura, 
    cast(cli_codigo as varchar) cli_codigo, cli_apellidos + ' ' + cli_nombres,
    sum(isnull((dfa_valor + isnull(dfa_iva,0)),0)) "Cantidad",
    @fecha1 del, @fecha2 al, usr_usuario usr_nombre,mov_usuario as sol_anulacion,
	''mov_fecha, ''mov_fecha_anula,'' mov_lote, '' mov_recibo_puntoxpress, fac_codigo, 

	vst.codigo_generacion_inva, vst.numero_control_inva, vst.razon_ti024, vst.motivo_anulacion, vst.responsable_anulacion, vst.solicitante_inva, vst.fecha_creacion, vst.codigo_generacion_nuevo_dte, 0 ban_codigo
    from col_fac_facturas
		join col_dfa_det_fac on dfa_codfac = fac_codigo
		join col_tmo_tipo_movimiento on tmo_codigo = dfa_codtmo
		join col_cli_clientes on cli_codigo = fac_codcli
		join ra_reg_regionales on reg_codigo = @regional
		join ra_uni_universidad on uni_codigo = reg_coduni
		join adm_usr_usuarios on usr_usuario = fac_usuario_anula
		join col_mov_movimientos on mov_codigo=tmo_codigo

		left join vst_mh_invalidaciones_dte vst on vst.codigo_origen = fac_codigo
    where fac_codreg = @regional
    and fac_fecha between convert(datetime,@fecha1) and convert(datetime,@fecha2)
    and fac_estado = 'A'

    group by uni_nombre,fac_tipo, cli_codigo, cli_apellidos + ' ' + cli_nombres, fac_factura, usr_nombre,mov_usuario, mov_recibo_puntoxpress, usr_usuario, fac_codigo,

	vst.codigo_generacion_inva, vst.numero_control_inva, vst.razon_ti024, vst.motivo_anulacion, vst.responsable_anulacion, vst.solicitante_inva, vst.fecha_creacion, vst.codigo_generacion_nuevo_dte
    order by 4,5

end
go







USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_facturas_emitidas]    Script Date: 3/10/2023 16:47:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec rep_facturas_emitidas 1,'03/10/2023','03/10/2023'
ALTER proc [dbo].[rep_facturas_emitidas]
	@campo0 int,
	@campo1 varchar(10),
	@campo2 varchar(10)
as
set dateformat dmy

declare @regional varchar(100)

select @regional = reg_nombre
from ra_reg_regionales
where reg_codigo = @campo0


select re_tipo_documento, re_numero_documento_id, re_correo, re_telefono, re_direccion, re_municipio,uni_nombre,@regional regional, cast(mov_recibo as int) mov_recibo,
per_carnet,fecha,case when estado = 'ANULADA' then 0 else sum(exentas) end exentas, 
case when estado = 'ANULADA' then 0 else sum(afectas) end afectas,
case when estado = 'ANULADA' then 0 else sum(suma) end suma, 
convert(datetime,@campo1,103) del, 
convert(datetime,@campo2,103) al,estado, mov_lote, per_apellidos_nombres as alumno, re_responsable_nombre, re_responsable_dui, mov_usuario,
re_mov_descripcion, mov_codban, re_fecha_nac, re_edad, mov_ciclo, mov_referencia_pos, per_codigo, mov_fecha_real_pago, numero_control, codigo_generacion, correlativo_anual
from
(
	select  case when isnull(per_dui, '') <> '' then 'DUI' else 'NIT' end re_tipo_documento,
			case when isnull(per_dui, '') <> '' then per_dui else per_nit end re_numero_documento_id, per_correo_institucional re_correo,
			per_direccion re_direccion, m013_valores re_municipio, replace(per_telefono, '-', '') re_telefono,
			uni_nombre, mov_recibo, per_carnet,mov_fecha fecha,
		sum(case when isnull(dmo_iva,0) = 0 then round(isnull(dmo_valor,0),2) else 0 end) exentas,
		sum(case when isnull(dmo_iva,0) > 0 then round(isnull(dmo_valor,0),2)+ round(isnull(dmo_iva,0),2) else 0 end) afectas,
		sum(round(isnull(dmo_valor,0),2)+ round(isnull(dmo_iva,0),2)) suma,
		case when mov_estado = 'A' then 'ANULADA' else '' end estado,
		mov_lote, per_apellidos_nombres, 
		(select ina_responsable_estu from ra_ina_indicador_alumno 
				where ina_codigo = (select MAX(ina_codigo) ina_responsable_estu from ra_ina_indicador_alumno 
					where ina_codper = per_codigo and ina_dui_responsable is not null)) re_responsable_nombre,
		(select ina_dui_responsable from ra_ina_indicador_alumno 
			where ina_codigo = (select MAX(ina_codigo) ina_responsable_estu from ra_ina_indicador_alumno 
				where ina_codper = per_codigo and ina_dui_responsable is not null)) re_responsable_dui, mov_usuario,
		mov_descripcion re_mov_descripcion, convert(varchar(12), per_fecha_nac, 103) re_fecha_nac,
		(CASE WHEN MONTH(per_fecha_nac) < MONTH(GETDATE()) OR (MONTH(per_fecha_nac) = MONTH(GETDATE()) AND DAY(per_fecha_nac) <= DAY(GETDATE()))
			THEN DATEDIFF(YEAR, per_fecha_nac, GETDATE()) ELSE DATEDIFF(YEAR, per_fecha_nac, GETDATE()) - 1 END ) re_edad,
		CONCAT('0',cil_codcic,'-',cil_anio) mov_ciclo,
		tmo_arancel, tmo_descripcion, mov_referencia_pos, per_codigo, mov_fecha_real_pago,
		case when mov_puntoxpress = 1 then cast(mov_codban as varchar(10))+'-PX' 
		when mov_tipo_pago = 'R' then cast(mov_codban as varchar(10))+'-CR' 
		else cast(mov_codban as varchar(10)) end mov_codban, mov_numero_control 'numero_control', mov_codigo_generacion 'codigo_generacion', mov_correlativo_anual 'correlativo_anual'
	from col_mov_movimientos 
		join col_dmo_det_mov on dmo_codmov = mov_codigo
		join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
		join ra_cil_ciclo on cil_codigo = mov_codcil
		join ra_per_personas on per_codigo = mov_codper
		left join dbo.ra_mun_municipios on MUN_CODIGO = per_codmun_nac
		left join dbo.cat_m013_municipio_013 on mun_codm013mundep = m013_mundep
		left join adm_ban_bancos on ban_codigo = mov_codban
		join ra_reg_regionales on reg_codigo = per_codreg
		join ra_uni_universidad on uni_codigo = reg_coduni
	where mov_codreg = @campo0
		and mov_fecha between convert(datetime,@campo1) and convert(datetime,@campo2)
		and mov_tipo = 'F'
		and mov_recibo <> 0
	--and mov_estado <> 'A'
	group by uni_nombre, mov_recibo, per_dui, per_nit, per_correo_institucional, per_direccion, m013_valores, per_telefono,
		per_carnet,mov_fecha,mov_estado, mov_lote, per_apellidos_nombres, mov_usuario, mov_descripcion, ban_nombre, per_fecha_nac,
		cil_codcic, cil_anio, tmo_arancel, tmo_descripcion, mov_referencia_pos, per_codigo, mov_fecha_real_pago, mov_puntoxpress, mov_tipo_pago, mov_codban, mov_numero_control, mov_codigo_generacion, mov_correlativo_anual
	union all
	select case when isnull(cli_nit, '') <> '' then 'NIT' else 'DUI' end,
	case when isnull(cli_nit, '') <> '' then replace(cli_nit, '-', '') else replace(cli_dui, '-', '') end,
	cli_correo, cli_direccion, m013_valores, replace(cli_telefono, '-', ''), uni_nombre, fac_factura, 
	cast(cli_codigo as varchar),fac_fecha,
	sum(case when  isnull(dfa_iva,0) = 0 then round(isnull(dfa_valor,0),2) else 0.00 end) exentos,
	sum(case when  isnull(dfa_iva,0) > 0 then round(isnull(dfa_valor,0),2) + round(isnull(dfa_iva,0),2) else 0.00 end) afectos,
	sum(round(isnull(dfa_valor,0),2) + round(isnull(dfa_iva,0),2)) total,
	case when fac_estado = 'A' then 'ANULADA' else '' end estado, fac_lote, fac_descripcion,
	'', fac_usuario, fac_descripcion , '', '', '','', tmo_arancel, tmo_descripcion, fac_referencia_pos, cli_codigo, fac_fecha, '', fac_numero_control, fac_codigo_generacion, fac_correlativo_anual
	from col_fac_facturas
	join col_dfa_det_fac on dfa_codfac = fac_codigo
	join col_tmo_tipo_movimiento on tmo_codigo = dfa_codtmo
	join col_cli_clientes on cli_codigo = fac_codcli
	left join dbo.cat_m013_municipio_013 on m013_mundep = cli_codm013mundep
	join ra_reg_regionales on reg_codigo = @campo0
	join ra_uni_universidad on uni_codigo = reg_coduni
	where fac_codreg = @campo0
	and fac_fecha between convert(datetime,@campo1) and convert(datetime,@campo2)
	and fac_tipo = 'F' and fac_factura <> 0
	group by uni_nombre, fac_factura, cli_nit, cli_dui, cli_correo, cli_direccion, m013_valores, cli_telefono,
	cast(cli_codigo as varchar),fac_fecha,fac_estado, fac_lote, fac_descripcion, tmo_arancel, tmo_descripcion, fac_referencia_pos,
	cli_codigo, fac_fecha, fac_usuario, fac_numero_control, fac_codigo_generacion, fac_correlativo_anual
	union all
	select case when isnull(cli_nit, '') <> '' then 'NIT' else 'DUI' end,
	case when isnull(cli_nit, '') <> '' then replace(cli_nit, '-', '') else replace(cli_dui, '-', '') end,
	cli_correo, cli_direccion, m013_valores, replace(cli_telefono, '-', ''),
	uni_nombre, fac_factura, 
	cast(cli_codigo as varchar),fac_fecha,
	0 exentos,
	sum(case when  isnull(dfa_iva,0) > 0 then round(isnull(dfa_valor,0),2) + round(isnull(dfa_iva,0),2) else 0.00 end) afectos,
	sum(round(isnull(dfa_valor,0),2) + round(isnull(dfa_iva,0),2)) total,
	case when fac_estado = 'A' then 'ANULADA' else '' end estado, fac_lote, fac_descripcion,
	'','', fac_usuario, fac_descripcion, '', '','', tmo_arancel, tmo_descripcion, fac_referencia_pos, cli_codigo, fac_fecha, '', fac_numero_control, fac_codigo_generacion, fac_correlativo_anual
	from col_fac_facturas
	join col_dfa_det_fac on dfa_codfac = fac_codigo
	join col_tmo_tipo_movimiento on tmo_codigo = dfa_codtmo
	join col_cli_clientes on cli_codigo = fac_codcli
	left join dbo.cat_m013_municipio_013 on m013_mundep = cli_codm013mundep
	join ra_reg_regionales on reg_codigo = @campo0
	join ra_uni_universidad on uni_codigo = reg_coduni
	where fac_codreg = @campo0
	and fac_fecha between convert(datetime,@campo1) and convert(datetime,@campo2)
	and fac_tipo = 'E' and fac_factura <> 0
	group by uni_nombre, fac_factura, cli_nit, cli_dui, cli_correo, cli_direccion, m013_valores, cli_telefono,
	cast(cli_codigo as varchar),fac_fecha,fac_estado, fac_lote, fac_descripcion, tmo_arancel, tmo_descripcion, fac_referencia_pos,
	cli_codigo, fac_fecha, fac_usuario, fac_numero_control, fac_codigo_generacion, fac_correlativo_anual
) t
group by re_tipo_documento, re_numero_documento_id, re_correo, re_telefono, re_direccion, re_municipio,uni_nombre, mov_recibo,
per_carnet,fecha,estado, mov_lote, per_apellidos_nombres, re_responsable_nombre, re_responsable_dui, mov_usuario,
re_mov_descripcion, mov_codban, re_fecha_nac, re_edad, mov_ciclo, mov_referencia_pos, per_codigo, mov_fecha_real_pago, numero_control, codigo_generacion, correlativo_anual
order by mov_lote, fecha ,cast(mov_recibo as int)

return


USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_libro_ventas_cf_ccf_colecturia]    Script Date: 4/10/2023 09:11:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


	-- exec rep_libro_ventas_cf_ccf_colecturia 1, '01/10/2023', '04/10/2023' -- 4 lineas
ALTER proc [dbo].[rep_libro_ventas_cf_ccf_colecturia]
	@regional int,
	@fecha_inicio varchar(10) = '',
	@fecha_fin varchar(10) = ''
as
begin
	set dateformat dmy

	select re_correo, re_direccion, re_documento, re_municipio, re_numero_documento, re_telefono, month(convert(datetime,del,103)) mes, dbo.fn_crufl_NombreMes(month(convert(datetime,del,103))) nombre_mes,
		year(convert(datetime,del,103)) anio, convert(datetime,del,103) fecha, 
		uni_nombre, uni_nit, uni_iniciales, uni_direccion, uni_registro,
		convert(varchar(12),del,103) dia, 
		tipo, Numero_Documento, nombre_cliente, cli_nombre_comercial, re_actividad_eco, re_tipo_persona, no_registro_cliente,
		sum(exento) ventas_exentas, sum(neto) neto, sum(iva) iva, sum(suma) ventas_gravadas, 
		sum(cantidad) total_ventas, del, fac_lote, fac_usuario, fac_codigo_generacion, fac_numero_control, fac_sello_recepcion, fac_correlativo_anual
	from (
	select re_correo, re_direccion, re_documento, re_municipio, re_numero_documento, re_telefono, uni_nombre, uni_nit, uni_iniciales,  uni_direccion, uni_registro, Numero_Registro, Numero_Documento, 
			nombre_cliente, cli_nombre_comercial, no_registro_cliente, re_actividad_eco, re_tipo_persona,
			tipo, sum(exento) exento, sum(neto) neto, sum(iva) iva, sum(suma) suma, 
			sum(cantidad) Cantidad, estado, del, fac_fecha_registro, fac_lote, fac_usuario, fac_codigo_generacion, fac_numero_control, fac_sello_recepcion, fac_correlativo_anual
		from (
			select 'NIT' re_documento, replace(cli_nit, '-', '') re_numero_documento,
				   cli_correo re_correo, cli_direccion re_direccion, m013_valores re_municipio, replace(cli_telefono, '-', '') re_telefono, 
				   cae019_valores re_actividad_eco, tp029_valores re_tipo_persona,
				   uni_nombre, uni_nit, uni_iniciales, uni_direccion, uni_registro,
				convert(varchar,fac_codigo) Numero_Registro, ltrim(rtrim(fac_factura)) Numero_Documento,
				case when fac_estado = 'A' then 'Anulada' else dbo.initcap(cli_nombres + ' ' + cli_apellidos) end nombre_cliente,
				cli_nombre_comercial,
				case when fac_estado = 'A' then 'N/D'
				else case when cli_registro is null then 'N/D'
				when cli_registro = '' then 'N/D'
				else cli_registro end end no_registro_cliente,  
				'CCF' tipo,
				case when fac_estado = 'A' then 0 else
				case when isnull(dfa_iva,0) <> 0 then 0 else round(isnull(dfa_valor,0),2) end end exento,
				case when fac_estado = 'A' then 0 else
				case when isnull(dfa_iva,0) <> 0 then round(isnull(dfa_valor,0),2) else 0 end end neto,
				case when fac_estado = 'A' then 0 else isnull(dfa_iva,0) end iva, 
				case when fac_estado = 'A' then 0 else
				case when isnull(dfa_iva,0) > 0 then round(isnull(dfa_valor,0),2)+ round(isnull(dfa_iva,0),2) 
				else 0 end end suma,
				case when fac_estado = 'A' then 0
				else isnull((round(dfa_valor,2) + round(isnull(dfa_iva,0),2)),0) end "Cantidad",
				fac_estado estado,fac_fecha del, fac_fecha_registro, fac_lote, fac_usuario, fac_codigo_generacion, fac_numero_control, fac_sello_recepcion, fac_correlativo_anual
			from col_fac_facturas
				join col_dfa_det_fac on dfa_codfac = fac_codigo
				join col_tmo_tipo_movimiento on tmo_codigo = dfa_codtmo
				join col_cli_clientes on cli_codigo = fac_codcli
				left join dbo.cat_m013_municipio_013 on m013_mundep = cli_codm013mundep
				left join cat_cae019_codigo_actividad_economica_019 on cae019_codigo = cli_codcae019
				left join cat_tp029_tipo_persona_029 on tp029_codigo = cli_codtp029
				join ra_reg_regionales on reg_codigo = @regional
				join ra_uni_universidad on uni_codigo = reg_coduni
			where --datediff(d,fac_fecha,convert(datetime,@fecha_inicio,103)) = 0
				convert(date,fac_fecha,103) between convert(date,@fecha_inicio,103) and convert(date,@fecha_fin,103)
				and fac_tipo = 'C' --* Comprobantes de Credito Fiscal
				--and fac_estado not in ('A')
		) t
		group by re_correo, re_direccion, re_documento, re_municipio, re_numero_documento, re_telefono,uni_nombre, uni_nit, uni_iniciales,  uni_direccion, uni_registro, Numero_Registro, Numero_Documento, 
			tipo, estado, del, nombre_cliente, no_registro_cliente, fac_fecha_registro, fac_lote, fac_usuario, cli_nombre_comercial, re_actividad_eco,
			re_tipo_persona, fac_codigo_generacion, fac_numero_control, fac_sello_recepcion, fac_correlativo_anual
	) w
	group by re_correo, re_direccion, re_documento, re_municipio, re_numero_documento, re_telefono, uni_nombre, uni_nit, uni_iniciales,  uni_direccion, uni_registro, tipo, numero_documento, del,
		nombre_cliente, no_registro_cliente, fac_fecha_registro, fac_lote, fac_usuario, cli_nombre_comercial, re_actividad_eco, re_tipo_persona, fac_codigo_generacion, fac_numero_control, fac_sello_recepcion, fac_correlativo_anual
	order by del, tipo desc, numero_documento, dbo.fn_crufl_nombremes(month(del)) + cast(year(del) as varchar)
end
go


USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_libro_ventas_cf_colecturia]    Script Date: 4/10/2023 08:59:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


	-- exec dbo.rep_libro_ventas_cf_colecturia 1, '01/10/2023', '04/10/2023', 'N'--852
ALTER proc [dbo].[rep_libro_ventas_cf_colecturia]
	@regional int,
	@fecha_inicio varchar(10) = '',
	@fecha_fin varchar(10) = '',
	@dia_final varchar(1)
as
begin
  
	set dateformat dmy

	declare 
		@facultad int = 0, @carrera int = 0,
		@total_exentas_mes numeric(18,2), @total_gravadas_mes numeric(18,2), 
		@total_exportacion_mes numeric(18,2), @total_mes numeric(18,2),  
		@total_exentas_mes_antes numeric(18,2), @total_gravadas_mes_antes numeric(18,2), 
		@total_exportacion_mes_antes numeric(18,2), @total_mes_antes numeric(18,2),  
		@fecha_ant datetime

	--if @fecha = '0' set @fecha = ''  
  
	--select @fecha_ant = max(mov_fecha)  
	--from col_mov_movimientos  
	--where month(mov_fecha) = month(@fecha) and year(mov_fecha) = year(@fecha) 
	--and mov_fecha < convert(datetime,@fecha,103)  
  
  
	select @total_exportacion_mes =sum(expor),
		@total_exentas_mes = sum(exento), @total_gravadas_mes = sum(suma), @total_mes = sum(cantidad)
	from (  
		select 0 expor,
		sum(case when mov_estado = 'A' then 0 else case when isnull(dmo_iva,0) > 0 then 0 else round(isnull(dmo_valor,0),2) end end) exento,  
		--sum(case when mov_estado = 'A' then 0 else case when tmo_exento = 'S' then 0 else round(isnull(dmo_valor,0),2) end end) exento,  
		sum(case when mov_estado = 'A' then 0 else case when isnull(dmo_iva,0) > 0 or isnull(dmo_iva,0) = 0 then round(isnull(dmo_valor,0),2)+ round(isnull(dmo_iva,0),2) else 0 end end) suma,  
		--sum(case when mov_estado = 'A' then 0 else case when tmo_exento = 'N' then round(isnull(dmo_valor,0),2)+ round(isnull(dmo_iva,0),2) else 0 end end) suma,  
		sum(case when mov_estado = 'A' then 0 else isnull((round(dmo_valor,2) + round(isnull(dmo_iva,0),2)),0) end) cantidad  
		from col_mov_movimientos   
		join col_dmo_det_mov on dmo_codmov = mov_codigo  
		left outer join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo  
		where 
		--month(mov_fecha) = month(@fecha)  
		--and year(mov_fecha) = year(@fecha)  
		--and mov_fecha <= convert(datetime,@fecha,103)
		convert(date,mov_fecha,103) between convert(date,@fecha_inicio,103) and convert(date,@fecha_fin,103)
		and mov_recibo <> 0

			union all

		select 
		0 expor,
		sum(case when fac_estado = 'A' then 0 else  
		case when isnull(dfa_iva,0) > 0  or isnull(dfa_iva,0) < 0  then 0 else round(isnull(dfa_valor,0),2) end end),  
		sum(case when fac_estado = 'A' then 0 else  
		--case when isnull(dfa_iva,0) > 0  or isnull(dfa_iva,0) < 0  then round(isnull(dfa_valor,0),2)+ round(isnull(dfa_iva,0),2)  --Modificado el 07/12/2012
		case when isnull(dfa_iva,0) > 0  or isnull(dfa_iva,0) < 0  then round(isnull(dfa_valor,0),2)
		else 0 end end),  
		sum(case when fac_estado = 'A' then 0  
		--else isnull((round(dfa_valor,2) + round(isnull(dfa_iva,0),2)),0) end)  --Modificado el 07/12/2012
		else isnull((round(dfa_valor,2)),0) end)
		from col_fac_facturas  
			join col_dfa_det_fac on dfa_codfac = fac_codigo  
		where --month(fac_fecha) = month(@fecha) and year(fac_fecha) = year(@fecha) and fac_fecha <= convert(datetime,@fecha,103)  
		convert(date,fac_fecha,103) between convert(date,@fecha_inicio,103) and convert(date,@fecha_fin,103)
		and fac_tipo = 'F' and fac_factura <> 0

			union all --Exportacion

		select sum(case when fac_estado = 'A' then 0 else  
			case when isnull(dfa_iva,0) > 0  or isnull(dfa_iva,0) < 0  then 0 else round(isnull(dfa_valor,0),2) end end), 0,  
			sum(case when fac_estado = 'A' then 0 else  
			--case when isnull(dfa_iva,0) > 0  or isnull(dfa_iva,0) < 0  then round(isnull(dfa_valor,0),2)+ round(isnull(dfa_iva,0),2)  --Modificado el 07/12/2012
			case when isnull(dfa_iva,0) > 0  or isnull(dfa_iva,0) < 0  then round(isnull(dfa_valor,0),2)
			else 0 end end),  
			sum(case when fac_estado = 'A' then 0  
			--else isnull((round(dfa_valor,2) + round(isnull(dfa_iva,0),2)),0) end)  --Modificado el 07/12/2012
		else isnull((round(dfa_valor,2)),0) end)
		from col_fac_facturas  
			join col_dfa_det_fac on dfa_codfac = fac_codigo  
		where --month(fac_fecha) = month(@fecha )and year(fac_fecha) = year(@fecha) and fac_fecha <= convert(datetime,@fecha,103)
		convert(date,fac_fecha,103) between convert(date,@fecha_inicio,103) and convert(date,@fecha_fin,103)
		 and fac_tipo = 'E' and fac_factura <> 0
	) t
  
	select @total_exportacion_mes_antes =sum(expor),
	@total_exentas_mes_antes = sum(exento), @total_gravadas_mes_antes = sum(suma), @total_mes_antes = sum(cantidad)  
	from (  
		select 0 expor,
			sum(case when mov_estado = 'A' then 0 else case when isnull(dmo_iva,0) > 0 then 0 else round(isnull(dmo_valor,0),2) end end) exento,
			--sum(case when mov_estado = 'A' then 0 else case when tmo_exento = 'S' then 0 else round(isnull(dmo_valor,0),2) end end) exento,  
			sum(case when mov_estado = 'A' then 0 else case when isnull(dmo_iva,0) > 0 or isnull(dmo_iva,0) = 0  then round(isnull(dmo_valor,0),2)+ round(isnull(dmo_iva,0),2) else 0 end end) suma,
			--sum(case when mov_estado = 'A' then 0 else case when tmo_exento = 'N' then round(isnull(dmo_valor,0),2)+ round(isnull(dmo_iva,0),2) else 0 end end) suma,  
			sum(case when mov_estado = 'A' then 0 else isnull((round(dmo_valor,2) + round(isnull(dmo_iva,0),2)),0) end) cantidad
		from col_mov_movimientos   
			join col_dmo_det_mov on dmo_codmov = mov_codigo  
			join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo  
		where --month(mov_fecha) = month(@fecha) and year(mov_fecha) = year(@fecha) and mov_fecha < convert(datetime,@fecha,103)
		convert(date,mov_fecha,103) between convert(date,@fecha_inicio,103) and convert(date,@fecha_fin,103)
		---and datediff(d,mov_fecha,@fecha_ant)=0  
		 and mov_recibo <> 0  
		
			union all
		
		--select 0 expor,sum(case when fac_estado = 'A' then 0 else  
		--case when isnull(dfa_iva,0) > 0  or isnull(dfa_iva,0) < 0 then 0 else round(isnull(dfa_valor,0),2) end end),  
		--sum(case when fac_estado = 'A' then 0 else  
		--case when isnull(dfa_iva,0) > 0  or isnull(dfa_iva,0) < 0 then round(isnull(dfa_valor,0),2)+ round(isnull(dfa_iva,0),2)  
		--else 0 end end),  
		--sum(case when fac_estado = 'A' then 0  
		--else isnull((round(dfa_valor,2) + round(isnull(dfa_iva,0),2)),0) end)  
		--from col_fac_facturas  
		--join col_dfa_det_fac on dfa_codfac = fac_codigo  
		--where month(fac_fecha) = month(@fecha)  
		--and year(fac_fecha) = year(@fecha)  
		--and fac_tipo = 'F' 
		--and fac_factura <> 0  
		--and fac_fecha < convert(datetime,@fecha,103) 

		select 0 expor,
			sum(case when fac_estado = 'A' then 0 else  
			case when isnull(dfa_iva,0) > 0  or isnull(dfa_iva,0) < 0  then 0 else round(isnull(dfa_valor,0),2) end end),  
			sum(case when fac_estado = 'A' then 0 else  
			--case when isnull(dfa_iva,0) > 0  or isnull(dfa_iva,0) < 0  then round(isnull(dfa_valor,0),2)+ round(isnull(dfa_iva,0),2)  --Modificado el 07/12/2012
			case when isnull(dfa_iva,0) > 0  or isnull(dfa_iva,0) < 0  then round(isnull(dfa_valor,0),2)
			else 0 end end),  
			sum(case when fac_estado = 'A' then 0  
			--else isnull((round(dfa_valor,2) + round(isnull(dfa_iva,0),2)),0) end)  --Modificado el 07/12/2012
			else isnull((round(dfa_valor,2)),0) end)
		from col_fac_facturas  
			join col_dfa_det_fac on dfa_codfac = fac_codigo  
		where --month(fac_fecha) = month(@fecha) and year(fac_fecha) = year(@fecha) and fac_fecha < convert(datetime,@fecha,103) 
			convert(date,fac_fecha,103) between convert(date,@fecha_inicio,103) and convert(date,@fecha_fin,103)
			and fac_tipo = 'F' and fac_factura <> 0 

			union all

		select sum(case when fac_estado = 'A' then 0 else  
			case when isnull(dfa_iva,0) > 0  or isnull(dfa_iva,0) < 0 then 0 else round(isnull(dfa_valor,0),2) end end),0,  
			sum(case when fac_estado = 'A' then 0 else  
			case when isnull(dfa_iva,0) > 0  or isnull(dfa_iva,0) < 0 then round(isnull(dfa_valor,0),2)+ round(isnull(dfa_iva,0),2)  
			else 0 end end),  
			sum(case when fac_estado = 'A' then 0  
			else isnull((round(dfa_valor,2) + round(isnull(dfa_iva,0),2)),0) end)  
		from col_fac_facturas  
			join col_dfa_det_fac on dfa_codfac = fac_codigo  
		where --month(fac_fecha) = month(@fecha) and year(fac_fecha) = year(@fecha) and fac_fecha < convert(datetime,@fecha,103)
			convert(date,fac_fecha_registro,103) between convert(date,@fecha_inicio,103) and convert(date,@fecha_fin,103)
			and fac_tipo = 'E' and fac_factura <> 0
	) t  

	select month(convert(datetime,del,103) ) mes, dbo.fn_crufl_NombreMes(month(convert(datetime,del,103) )) nombre_mes,  
		year(convert(datetime,del,103))  anio, convert(datetime,del,103) fecha,  
		@total_exportacion_mes exportacion_mes, 
		@total_exentas_mes exentas_mes,@total_gravadas_mes gravadas_mes,@total_mes total_mes,  
		@total_exentas_mes_antes exentas_mes_antes,@total_gravadas_mes_antes gravadas_mes_antes,@total_exportacion_mes_antes exportacion_mes_antes,@total_mes_antes total_mes_antes,  
		 uni_nombre, uni_nit, uni_iniciales, uni_direccion, uni_registro,estado,  
			   right('0' + cast(day(del) as varchar), 2) dia,   
			   tipo, Numero_Documento documento_del,
			   sum(expo) ventas_exportacion ,  
			   sum(exento) ventas_exentas, sum(neto) neto, sum(iva) iva, sum(suma) ventas_gravadas,   
			   sum(cantidad) total_ventas, del, sum(cheque) cheque, sum(efectivo) efectivo, sum(tarjeta) tarjeta ,  
		@dia_final final, mov_codigo, lote, mov_usuario, codigo_generacion, numero_control, sello_recepcion, correlativo_anual
	from (  
		select uni_nombre, uni_nit, uni_iniciales,  uni_direccion, uni_registro, Numero_Registro, Numero_Documento,   
			tipo,sum(expo) expo, sum(exento) exento, sum(neto) neto, sum(iva) iva, sum(suma) suma,   
			sum(cantidad) Cantidad, estado, del, sum(cheque) cheque, sum(efectivo) efectivo, sum(tarjeta) tarjeta ,mov_codigo,lote, mov_usuario, codigo_generacion, numero_control, sello_recepcion, correlativo_anual
		from (  
			select uni_nombre, uni_nit, uni_iniciales,  uni_direccion, uni_registro, convert(varchar,mov_codigo) Numero_Registro,   
				ltrim(rtrim(cast(mov_recibo as int))) Numero_Documento,  
				'Factura' tipo, 0 expo, 
				case when mov_estado = 'A' then 0 else case when isnull(dmo_iva,0) > 0 or tmo_exento = 'N' then 0 else round(isnull(dmo_valor,0),2) end end exento,  
				case when mov_estado = 'A' then 0 else case when isnull(dmo_iva,0) > 0 or tmo_exento = 'S' then round(isnull(dmo_valor/*((dmo_valor+dmo_iva)/1.13)*/,0),2) else 0 end end neto,  
				--case when mov_estado = 'A' then 0 else case when tmo_exento = 'S' then 0 else round(isnull(dmo_valor,0),2) end end exento,  
				--case when mov_estado = 'A' then 0 else case when tmo_exento = 'N' then round(isnull(dmo_valor/*((dmo_valor+dmo_iva)/1.13)*/,0),2) else 0 end end neto,  
				case when mov_estado = 'A' then 0 else isnull(dmo_iva,0) end iva,   
				case when mov_estado = 'A' then 0 else case when isnull(dmo_iva,0) > 0 or tmo_exento = 'N' then round(isnull(dmo_valor,0),2)+ round(isnull(dmo_iva,0),2) else 0 end end suma,  
				--case when mov_estado = 'A' then 0 else case when tmo_exento = 'N'  then round(isnull(dmo_valor,0),2)+ round(isnull(dmo_iva,0),2) else 0 end end suma,  
				case when mov_estado = 'A' then 0 else isnull((round(dmo_valor,2) + round(isnull(dmo_iva,0),2)),0) end "Cantidad",  
				case when mov_estado = 'A' then 0 else case when mov_tipo_pago = 'T' then isnull((round(dmo_valor,2) + round(isnull(dmo_iva,0),2)),0) else 0 end end tarjeta,  
				case when mov_estado = 'A' then 0 else case when mov_tipo_pago = 'E' then isnull((round(dmo_valor,2) + round(isnull(dmo_iva,0),2)),0) else 0 end end efectivo,  
				case when mov_estado = 'A' then 0 else case when mov_tipo_pago = 'C' then isnull((round(dmo_valor,2) + round(isnull(dmo_iva,0),2)),0) else 0 end end cheque,  
				mov_estado estado, mov_fecha del,mov_codigo,mov_lote lote, mov_usuario, mov_codigo_generacion 'codigo_generacion', mov_numero_control 'numero_control', mov_sello_recepcion 'sello_recepcion', mov_correlativo_anual 'correlativo_anual'
			from col_mov_movimientos   
				left outer join col_dmo_det_mov on dmo_codmov = mov_codigo  
				left outer join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo  
				join ra_per_personas on per_codigo = mov_codper  
				join ra_reg_regionales on reg_codigo = per_codreg  
				join ra_uni_universidad on uni_codigo = reg_coduni  
			where --datediff(d,mov_fecha,convert(datetime,@fecha,103)) = 0 and month(mov_fecha) = month(@fecha) and year(mov_fecha) = year(@fecha) 
				convert(date,mov_fecha,103) between convert(date,@fecha_inicio,103) and convert(date,@fecha_fin,103)
				 and mov_recibo <> 0  
				
				union all

			select uni_nombre, uni_nit, uni_iniciales,  uni_direccion, uni_registro,  
				convert(varchar,fac_codigo) Numero_Registro,   
				ltrim(rtrim(cast(case when isnumeric(fac_factura) = 0 then 0 else fac_factura end as int))) Numero_Documento,
				'Factura' tipo,  
				0 expo,
				case when fac_estado = 'A' then 0 else  
				case when isnull(dfa_iva,0) > 0 or isnull(dfa_iva,0) < 0 then 0 else round(isnull(dfa_valor,0),2) end end exento,  
				case when fac_estado = 'A' then 0 else case when isnull(dfa_iva,0) > 0 or isnull(dfa_iva,0) < 0 then round(isnull(dfa_valor,0),2) else 0 end end neto,   
				case when fac_estado = 'A' then 0 else isnull(dfa_iva,0) end iva,   
				case when fac_estado = 'A' then 0 else  
				--case when isnull(dfa_iva,0) > 0 or isnull(dfa_iva,0) < 0 then round(isnull(dfa_valor,0),2)+ round(isnull(dfa_iva,0),2)  
  
				case when isnull(dfa_iva,0) > 0 or isnull(dfa_iva,0) < 0 then round(isnull(dfa_valor,0),2)
				else 0 end end suma,  
				case when fac_estado = 'A' then 0  
				--   else isnull((round(dfa_valor,2) + round(isnull(dfa_iva,0),2)),0) end "Cantidad",
				else isnull((round(dfa_valor,2)),0) end "Cantidad",    
				case when fac_estado = 'A' then 0   
				else case when fac_tipo_pago = 'T' then isnull((round(dfa_valor,2) + round(isnull(dfa_iva,0),2)),0)   
				else 0 end end tarjeta,  
				case when fac_estado = 'A' then 0  
				else case when fac_tipo_pago = 'E' then isnull((round(dfa_valor,2) + round(isnull(dfa_iva,0),2)),0)   
				else 0 end end efectivo,  
				case when fac_estado = 'A' then 0   
				else case when fac_tipo_pago = 'C' then isnull((round(dfa_valor,2) + round(isnull(dfa_iva,0),2)),0)   
				else 0 end end cheque, fac_estado, fac_fecha del ,fac_codigo,fac_lote lote, fac_usuario, fac_codigo_generacion, fac_numero_control, fac_sello_recepcion, fac_correlativo_anual
			from col_fac_facturas  
				join col_dfa_det_fac on dfa_codfac = fac_codigo  
				join col_tmo_tipo_movimiento on tmo_codigo = dfa_codtmo  
				join ra_reg_regionales on reg_codigo = @regional  
				join ra_uni_universidad on uni_codigo = reg_coduni  
			where --datediff(d,fac_fecha,convert(datetime,@fecha,103)) = 0 and month(fac_fecha) = month(@fecha) and year(fac_fecha) = year(@fecha)
				convert(date,fac_fecha,103) between convert(date,@fecha_inicio,103) and convert(date,@fecha_fin,103)
				 and fac_tipo = 'F' and fac_factura <> 0 
  
				--EXPORTACION 03062015
				union all

			select uni_nombre, uni_nit, uni_iniciales,  uni_direccion, uni_registro,  
				convert(varchar,fac_codigo) Numero_Registro,   
				ltrim(rtrim(cast(case when isnumeric(fac_factura) = 0 then 0 else fac_factura end as int))) Numero_Documento,   
				'Factura' tipo,  
				case when fac_estado = 'A' then 0 else  
				case when isnull(dfa_iva,0) > 0 or isnull(dfa_iva,0) < 0 then 0 else round(isnull(dfa_valor,0),2) end end expo,  
				0 exento,
				case when fac_estado = 'A' then 0 else case when isnull(dfa_iva,0) > 0 or isnull(dfa_iva,0) < 0 then round(isnull(dfa_valor,0),2) else 0 end end neto,   
				case when fac_estado = 'A' then 0 else isnull(dfa_iva,0) end iva,   
				case when fac_estado = 'A' then 0 else  
				--case when isnull(dfa_iva,0) > 0 or isnull(dfa_iva,0) < 0 then round(isnull(dfa_valor,0),2)+ round(isnull(dfa_iva,0),2)  
  
				case when isnull(dfa_iva,0) > 0 or isnull(dfa_iva,0) < 0 then round(isnull(dfa_valor,0),2)
				else 0 end end suma,  
				case when fac_estado = 'A' then 0  
				--   else isnull((round(dfa_valor,2) + round(isnull(dfa_iva,0),2)),0) end "Cantidad",
				else isnull((round(dfa_valor,2)),0) end "Cantidad",    
				case when fac_estado = 'A' then 0   
				else case when fac_tipo_pago = 'T' then isnull((round(dfa_valor,2) + round(isnull(dfa_iva,0),2)),0)   
				else 0 end end tarjeta,  
				case when fac_estado = 'A' then 0  
				else case when fac_tipo_pago = 'E' then isnull((round(dfa_valor,2) + round(isnull(dfa_iva,0),2)),0)   
				else 0 end end efectivo,  
				case when fac_estado = 'A' then 0   
				else case when fac_tipo_pago = 'C' then isnull((round(dfa_valor,2) + round(isnull(dfa_iva,0),2)),0)   
				else 0 end end cheque,  
				fac_estado, fac_fecha del, fac_codigo, fac_lote lote, fac_usuario, fac_codigo_generacion, fac_numero_control, fac_sello_recepcion, fac_correlativo_anual
			from col_fac_facturas  
				join col_dfa_det_fac on dfa_codfac = fac_codigo  
				join col_tmo_tipo_movimiento on tmo_codigo = dfa_codtmo  
				join ra_reg_regionales on reg_codigo = 1  
				join ra_uni_universidad on uni_codigo = reg_coduni  
			where --datediff(d,fac_fecha,convert(datetime,@fecha,103)) = 0 and month(fac_fecha) = month(@fecha) and year(fac_fecha) = year(@fecha)
				convert(date,fac_fecha,103) between convert(date,@fecha_inicio,103) and convert(date,@fecha_fin,103)
				 and fac_tipo = 'E' and fac_factura <> 0
		) t  
		group by uni_nombre, uni_nit, uni_iniciales,  uni_direccion, uni_registro, Numero_Registro, Numero_Documento,   
			tipo, estado, del  ,mov_codigo, lote, mov_usuario, codigo_generacion, numero_control, sello_recepcion, correlativo_anual
	) w  
	group by uni_nombre, uni_nit, uni_iniciales,  Numero_Documento,uni_direccion, uni_registro, tipo, del , estado,mov_codigo,lote, mov_usuario
		, codigo_generacion, numero_control, sello_recepcion, correlativo_anual
	order by lote,del, tipo desc, cast(Numero_Documento as int), dbo.fn_crufl_nombremes(month(del)) + cast(year(del) as varchar)

end


