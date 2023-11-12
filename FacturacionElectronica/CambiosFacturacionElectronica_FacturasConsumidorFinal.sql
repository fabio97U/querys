select count(1) from col_mov_movimientos--6,733,700
alter table col_mov_movimientos add mov_npe varchar(80) null
select top 1 * from col_mov_movimientos order by mov_codigo desc
select * from col_art_archivo_tal_mora where per_codigo = 168640

alter table col_mov_movimientos add mov_co016 int--Condicion de operacion
alter table col_mov_movimientos add mov_fp017 varchar(5)-- Forma de pago
alter table col_mov_movimientos add mov_referencia_pos varchar(60)
alter table col_mov_movimientos add mov_p018 varchar(5)--Plazos
alter table col_mov_movimientos add mov_periodo_plazo int--Plazos

alter table col_mov_movimientos add mov_codigo_generacion varchar(60)
alter table col_mov_movimientos add mov_numero_control varchar(35)
alter table col_mov_movimientos add mov_sello_recepcion varchar(60)
alter table col_mov_movimientos add mov_fecha_generacion_fe datetime
alter table col_mov_movimientos add mov_rechazado_por_mh bit null
alter table col_mov_movimientos add mov_rechazos_por_mh int null

alter table col_mov_movimientos add mov_modelo_invalido bit null
alter table col_mov_movimientos add mov_rechazos_modelo_invalido int null

alter table col_mov_movimientos add mov_correlativo_anual int not null default 0

update col_mov_movimientos set mov_correlativo_anual = 0
ALTER TABLE col_mov_movimientos ALTER column mov_correlativo_anual int not null
ALTER TABLE col_mov_movimientos ADD CONSTRAINT default_mov_correlativo_anual DEFAULT 0 FOR mov_correlativo_anual;

update col_mov_movimientos set mov_co016 = 1
update col_mov_movimientos set mov_fp017 = '01'	

--alter table col_dmo_det_mov add dmo_concepto_arancel varchar(2048) null

select top 8 * from col_mov_movimientos order by mov_codigo desc
select top 1 * from col_fac_facturas order by fac_codigo desc
select top 5 * from col_dmo_det_mov order by dmo_codigo desc


SELECT dmo_codigo, [dmo_codtmo], [dmo_cantidad], dmo_valor+ isnull(dmo_iva,0) dmo_valor,dmo_cargo, dmo_abono, [dmo_codmat],  
ISNULL(dmo_descripcion, tmo_descripcion) tmo_descripcion, dmo_descuento, cic_nombre+'-'+cast(cil_anio as varchar) ciclo 
FROM [col_dmo_det_mov] 
	join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo 
	join ra_cil_ciclo on cil_codigo = dmo_codcil 
	join ra_cic_ciclos on cic_codigo = cil_codcic 
WHERE dmo_codmov = @codigo_mov 

select * from col_tmo_tipo_movimiento where tmo_arancel = 'T-02'