--select vac_codigo, concat(vac_ValorCuota, ' ', vac_tipo_carrera) from ra_vac_valor_cuotas where vac_Tipo = 'MAESTRIAS' order by vac_ValorCuota asc

--drop table ma_tpgra_tipo_pago_graduado
create table ma_tpgra_tipo_pago_graduado(
	tpgra_codigo int primary key identity(1, 1),
	tpgra_valor varchar(10),
	tpgra_descripcion varchar(150),
	tpgra_monto_pagar float,
	tpgra_monto_descuento float,
	tpgra_activo int default 1,
	tpgra_fecha_creacion datetime default getdate()
)
--select * from ma_tpgra_tipo_pago_graduado
insert into ma_tpgra_tipo_pago_graduado (tpgra_valor, tpgra_descripcion, tpgra_monto_pagar, tpgra_monto_descuento)
values ('I', 'Graduado UTEC', 150, 40), ('E', 'Externo', 175, 0)

select tpgra_valor 'codigo', concat(tpgra_descripcion, ' ', '(', tpgra_monto_pagar, ')') 'valor' from ma_tpgra_tipo_pago_graduado