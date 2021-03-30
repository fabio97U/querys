--5150506
select * from con_cuc_cuentas_contables
where cuc_cuenta = '5150506'
--5150606
select * from col_tmo_tipo_movimiento where tmo_cuenta = '5150506'
select * from col_mov_movimientos 
inner join col_dmo_det_mov on dmo_codmov = mov_codigo
inner join col_tmo_tipo_movimiento on dmo_codtmo = tmo_codigo
where mov_codper = 173322 and dmo_codcil = 125

select * from col_tmo_tipo_movimiento where tmo_arancel = 'T-02'
select * from col_tmo_tipo_movimiento where tmo_codigo = 913


set dateformat dmy
--select *
----cuc_cuenta, cuc_descripcion,
----'Remesa a Bancos' concepto, 'H' tipo, 0 debe, sum(reb_monto) haber, 3 orden
--from dbo.col_reb_remesas_banco 
----join con_cuc_cuentas_contables on cuc_codigo = 4
--where reb_fecha_banco = convert(datetime,'25/02/2021',103)
----group by cuc_cuenta, cuc_descripcion



select isnull(cuc_cuenta, 'S/C'), isnull(cuc_descripcion, 'Sin Cuenta'),
'Ingreso Tesoreria ' + dbo.fn_fecha_caracter('25/02/2021') concepto, 'H' tipo, 0, sum(round(isnull(dmo_iva, 0), 2)) haber, 4 orden
from (
	select per_tipo,mov_codper, dmo_codtmo, dmo_valor, dmo_iva, mov_codban, mov_tipo_pago,per_carnet,
		per_codigo,tmo_arancel,tmo_cuenta,mov_usuario, mov_recibo
	from ra_per_personas 
		join col_mov_movimientos on per_codigo = mov_codper
		join col_dmo_det_mov on dmo_codmov = mov_codigo
		join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
	where mov_codreg = 1
	and mov_fecha between convert(datetime, '25/02/2021', 103) and convert(datetime, '25/02/2021', 103)
	and mov_estado <> 'A' and mov_codban = 0
) t
	join con_cuc_cuentas_contables on cuc_codigo = 567
group by isnull(cuc_cuenta,'S/C'), isnull(cuc_descripcion, 'Sin Cuenta')


select * from con_cuc_cuentas_contables
where cuc_codigo = 567


select * from col_moc_movimientos_cuenta
where moc_codigo in (131518, 86660, 86661, 86662, 86663, 86664, 86665, 86666, 86667, 86668, 86669)


select * from col_moc_movimientos_cuenta

select dmo_valor, *
--isnull(cuc_cuenta,'S/C'),isnull(cuc_descripcion,'Sin Cuenta ' + tmo_arancel + ' ' + per_carnet),
--'Ingreso Tesoreria ' + dbo.fn_fecha_caracter('25/02/2021') concepto,'H' tipo,0,
--sum(round(isnull(dmo_valor,0),2)), 5 orden
--, 25 select_num
from (
	select *
	from ra_per_personas 
		join col_mov_movimientos on per_codigo = mov_codper
		join col_dmo_det_mov on dmo_codmov = mov_codigo
		join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
	where mov_codreg = 1
	and mov_fecha between convert(datetime, '25/02/2021', 103) and convert(datetime, '25/02/2021', 103)
	and mov_estado <> 'A' and mov_codban = 0
) t
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
and cuc_cuenta = '5150506'
group by isnull(cuc_cuenta,'S/C'),isnull(cuc_descripcion,'Sin Cuenta ' + tmo_arancel + ' ' + per_carnet)