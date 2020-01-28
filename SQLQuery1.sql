declare @tabla as table (mov_codigo int, mov_recibo int, mov_codper int, mov_codban int)
insert into @tabla
select top 23 mov_codigo, mov_recibo, mov_codper, mov_codban from col_mov_movimientos where mov_codper in (select ttpcb_codper from col_ttpcb_tabla_temporal_carga_bancos) order by mov_codigo desc
--select * from @tabla
select distinct t.*, per_carnet, ta.mov_codper, ta.mov_codigo from col_ttpcb_tabla_temporal_carga_bancos  as t
inner join ra_per_personas on per_codigo = ttpcb_codper
inner join (
select * from @tabla
) as ta on ta.mov_codper = t.ttpcb_codper
order by ttpcb_codigo desc -- 1 - 23 ingreso Rivas y no se ve en la partida contable


select * from col_mov_movimientos 
inner join col_dmo_det_mov on dmo_codmov = mov_codigo
inner join ra_per_personas on per_codigo = mov_codper
where mov_codigo in (6116998, 6116999)

select * from col_datb_data_bancos
select top 25 * from col_mov_movimientos order by mov_codigo desc

select top 10 * from previa_pago_online order by ppo_codigo desc
select top 10 * from col_pagos_en_linea_estructuradoSP order by Id desc
select * from col_ttpcb_tabla_temporal_carga_bancos order by ttpcb_codigo desc