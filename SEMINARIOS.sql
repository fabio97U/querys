declare @tbl_ table (codtmos int)
insert into @tbl_ (codtmos)
select tmo_codigo from col_tmo_tipo_movimiento 
where tmo_arancel in ('F-347')

select tmo_arancel 'Arancel', tmo_descripcion 'Descripcion', per_carnet 'Carnet', per_apellidos 'Apellidos', 
	per_nombres 'Nombres', mov_fecha_registro 'fecha_pago', (
		select count(1) from web_ise_inscripcion_seminario
		inner join web_sem_seminarios on ise_codsem = sem_codigo
		where sem_arancel = t.tmo_arancel and ise_codper = m.mov_codper
	) 'se_inscribio' 
from col_dmo_det_mov 
	inner join col_mov_movimientos m on dmo_codmov = mov_codigo
	inner join ra_per_personas on per_codigo = mov_codper
	inner join col_tmo_tipo_movimiento t on dmo_codtmo = tmo_codigo
where dmo_codtmo in (select codtmos from @tbl_)
order by tmo_arancel, per_apellidos