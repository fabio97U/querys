select * from col_fac_facturas where fac_tipo = 'E'

alter table col_fac_facturas add fac_tipo_dte_numero int NOT null default 0
alter table col_fac_facturas add fac_tipo_dte varchar(5) not null default ''
alter table col_fac_facturas add fac_documento varchar(5) not null default ''


alter table col_fac_facturas add fac_co016 int--Condicion de operacion
alter table col_fac_facturas add fac_fp017 varchar(5)-- Forma de pago
alter table col_fac_facturas add fac_referencia_pos varchar(60)
alter table col_fac_facturas add fac_p018 varchar(5)--Plazos
alter table col_fac_facturas add fac_periodo_plazo int--Plazos

alter table col_fac_facturas add fac_codigo_generacion varchar(60)
alter table col_fac_facturas add fac_numero_control varchar(35)
alter table col_fac_facturas add fac_sello_recepcion varchar(60)
alter table col_fac_facturas add col_fecha_generacion_fe datetime

alter table col_fac_facturas add fac_rechazado_por_mh bit null
alter table col_fac_facturas add fac_rechazos_por_mh int null
alter table col_fac_facturas add fac_modelo_invalido bit null
alter table col_fac_facturas add fac_rechazos_modelo_invalido int null

alter table col_fac_facturas add fac_correlativo_anual int default 0
update col_fac_facturas set fac_correlativo_anual = 0
alter table col_fac_facturas add fac_correlativo_anual int not null default 0

update col_fac_facturas set fac_co016 = 1
update col_fac_facturas set fac_fp017 = '01'
--update col_fac_facturas set fac_fp018 = '01' 
select co016_codigo 'codigo', co016_valores 'valor' from cat_co016_condicion_operacion_016
select p018_codigo 'codigo', p018_valores 'valor' from cat_p018_plazo_018
select fp017_codigo 'codigo', fp017_valores 'valor' from cat_fp017_forma_pago_017 

select * from col_fac_facturas where fac_codigo >= 8274
select * from col_dfa_det_fac where dfa_codfac >= 8274

