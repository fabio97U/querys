-- drop table col_flmf_fechas_limite_modificacion_facturas
create table col_flmf_fechas_limite_modificacion_facturas(
	flmf_codigo int primary key identity (1, 1),
	flmf_mes int,
	flmf_anio int,
	flmf_fecha_limite date,
	flmf_fecha_creacion datetime default getdate()
)
-- select * from col_flmf_fechas_limite_modificacion_facturas
insert into col_flmf_fechas_limite_modificacion_facturas 
(flmf_mes, flmf_anio, flmf_fecha_limite)
values(5, 2021, '2021-05-03'), (6, 2021, '2021-06-03'), (7, 2021, '2021-07-03')

select flmf_codigo, flmf_mes, flmf_anio, cast(flmf_fecha_limite as date) flmf_fecha_limite, flmf_fecha_creacion from col_flmf_fechas_limite_modificacion_facturas



declare @carnet varchar(15) = '25-1565-2015', @ciclo int = 122

declare @getdate date = cast(getdate() as date)
declare @flmf_mes int, @flmf_anio int, @flmf_fecha_limite date
select @flmf_fecha_limite = flmf_fecha_limite, @flmf_anio = flmf_anio, @flmf_mes = flmf_mes
from col_flmf_fechas_limite_modificacion_facturas
where (month(@getdate)) = flmf_mes and year(@getdate) = flmf_anio
--and cast(getdate() as date)<= flmf_fecha_limite

select mov_codigo, dmo_codigo, mov_codper, per_carnet, mov_recibo, mov_fecha, mov_lote, 
mov_fecha_real_pago,mov_fecha_cobro, per_nombres_apellidos,tmo_arancel, dmo_valor, 
dmo_iva,dmo_cargo, dmo_abono, 
right('00'+cast(cil_codcic as varchar),2) + '-'+cast(cil_anio as varchar) ciclo, 
cil_codigo, mov_usuario, mov_codban, dmo_fecha_registro,
@flmf_fecha_limite 'modificar_antes_de',
case when (@getdate <= @flmf_fecha_limite and (MONTH(mov_fecha_real_pago) = (@flmf_mes-1) and year(mov_fecha_real_pago) = @flmf_anio)) 
then 'Si' else 'No' end 'permitido_modificar'
from col_mov_movimientos 
join col_dmo_det_mov on dmo_codmov = mov_codigo 
join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo 
join ra_cil_ciclo on cil_codigo = dmo_codcil 
join ra_cic_ciclos on cic_codigo = cil_codcic 
join ra_per_personas on per_codigo = mov_codper 
where per_carnet = @carnet and cil_codigo = @ciclo and mov_estado <> 'A' 
order by dmo_fecha_registro asc