select top 100 * from col_fac_facturas 
where fac_fecha = '20200916'
order by fac_codigo desc
--00-0026-0620
select * from col_mov_movimientos where mov_codper = 228235--MAL
select * from col_mov_movimientos where mov_codper = 221677--BIEN

up-date col_fac_facturas set fac_estado = 'A'/*original: I*/ where fac_codigo in (6439, 6438, 6437, 6436)
--select * from col_fac_facturas where fac_codigo in (6439, 6438, 6437, 6436)
upd-ate col_fac_facturas set fac_tipo = 'F'/**original: C*/ where fac_codigo in (6439, 6438, 6437, 6436)
upda-te col_fac_facturas set fac_lote = '05'/**original: 21*/ where fac_codigo in (6439, 6438, 6437, 6436)


select * from col_mov_movimientos where mov_codigo in (6413902, 6413903, 6413904, 6413905)
updat-e col_mov_movimientos set mov_estado = 'A'/*original: R*/  where mov_codigo in (6413902, 6413903, 6413904, 6413905)