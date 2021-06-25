drop table pagosPW_BORRAME
create table pagosPW_BORRAME (
	codper int, 
	carnet varchar(15), 
	alumno varchar(1250), 
	estado varchar(25),
	concepto varchar(50),
	monto real,
	numero int
)
select * from pagosPW_BORRAME
delete from pagosPW_BORRAME


select * from pagosPW_BORRAME where 
--codper in (
--select mov_codper from col_mov_movimientos
--inner join col_dmo_det_mov on dmo_codmov = mov_codigo
--where cast(mov_fecha_registro as date) = '2021-05-15'
--and mov_usuario = 'payway_cuscatlan' 
----order by mov_codper
--) and 
estado = 'APROBADA'
and codper in (150003, 167626, 214944)
order by codper 
select * from col_mov_movimientos
inner join col_dmo_det_mov on dmo_codmov = mov_codigo
where cast(mov_fecha_registro as date) = '2021-05-15'
and mov_usuario = 'payway_cuscatlan'
order by mov_codper