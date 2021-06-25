select per_codigo, per_carnet carnet, per_nombres_apellidos alumno, mov_codigo, mov_recibo recibo,
case when mov_estado = 'A' then 'Anulada' when mov_estado = 'I' then 'Impresa' else 'Registrada' end estadoFactura
, mov_tipo_pago, '' Cheque, mov_usuario 'Usuario', mov_fecha_registro, mov_fecha, mov_fecha_real_pago, 
year(mov_fecha_registro) 'AnioPago', month(mov_fecha_registro) 'MesPago', day(mov_fecha_registro) 'DiaPago', 'F' 'TipoDocumento'
,case when mov_forma_pago = 'E' then 'Efectivo' else 'Tarjeta' end 'FormaPago', mov_lote,
mov_recibo_puntoxpress 'RefencianOnLine', ban_nombre 'banco', mov_usuario_anula 'UsuarioAnula', mov_fecha_anula 'FechaAnula',
dmo_cargo 'cargo', dmo_abono 'abono', 1 'cantidad', dmo_codtmo 'codigoArancel', tmo_arancel 'Arancel', tmo_valor 'ValorRealArancel',
tmo_descripcion 'DescripcionArancel', dmo_valor 'valor', dmo_iva 'iva', concat('Ciclo 0', cil_codcic, '-', cil_anio) 'ciclo',
car_nombre 'carrera', tde_nombre 'TipoDeEstudio', tmo_cuenta 'cuenta'
from col_mov_movimientos 
	inner join ra_per_personas on per_codigo = mov_codper
	inner join col_dmo_det_mov on dmo_codmov = mov_codigo
	inner join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
	left join ra_alc_alumnos_carrera on alc_codper = per_codigo
	left join ra_pla_planes on alc_codpla = pla_codigo
	left join ra_car_carreras on car_codigo = pla_codcar
	left join ra_tde_TipoDeEstudio on tde_codigo = car_codtde
	left join adm_ban_bancos on mov_codban = ban_codigo
	left join ra_cil_ciclo on cil_codigo = dmo_codcil
where mov_fecha_registro between '2020-01-01' and getdate()
--mov_codigo = 5976789
order by mov_codigo