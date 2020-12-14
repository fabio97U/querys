--alter table col_cpbt_carga_pagos_bancos_temporal add cpbt_npe varchar(38)
--select * from col_cpbt_carga_pagos_bancos_temporal
set dateformat dmy

--****************INTENTO 2
declare @tbl_npes as table (tbl_npe varchar(36))
insert into @tbl_npes (tbl_npe) 
values 
--/*23/08/2020 36*/('0313007500000020475030220208'), ('0313006300000019024630220205'), ('0313006300000011626230220209'), ('0313004300000015534330220205'), ('0313007500000015997430220204'), ('0313007500000020082130220201'), ('0313006300000017370430220206'), ('0313006300000011623130220207'), ('0313007500000018509330220205'), ('0313007500000018509340220203'), ('0313006300000021704130220203'), ('0313006300000020189230220207'), ('0313005040000020171330220201'), ('0313007500000022500840220201'), ('0313007500000020436630220204'), ('0313006300000011879430220202'), ('0313007500000020436830220202'), ('0313006300000021577040220202'), ('0313007500000022741240220199'), ('0313003150000022177430220206'), ('0313006300000018979440220201'), ('0313006300000001182130220206'), ('0313006300000018960330220204'), ('0313006300000018960340220202'), ('0313007500000019609330220202'), ('0313007500000022423530220201'), ('0313006300000022303530220209'), ('0313006300000011116830220205'), ('0313006300000021860230220202'), ('0313006300000013453430220204'), ('0313006300000022388130220204'), ('0313006300000018162530220205'), ('0313006300000019581130220209'), ('0313006300000021860130220203'), ('0313006300000020415530220203'), ('0313006300000018027730220208'),
/*24/08/2020 72*/('0313007500000021534730220204'), ('0313006300000014723630220207'), ('0313006300000020018030220200'), ('0313006300000017357430220203'), ('0313006300000020889130220203'), ('0313007500000020686040220208'), ('0313006300000019228130220207'), ('0313004800000016011740220202'), ('0313006300000021494430220208'), ('0313006300000022354950120205'), ('0313006300000022477430220202'), ('0313006300000020855730220208'), ('0313006300000020766130220203'), ('0313006300000022388530220200'), ('0313006300000022233130220202'), ('0313006300000018550440220200'), ('0313006300000018177730220201'), ('0313006300000021599640220200'), ('0313006300000021384130220204'), ('0313009000000020157510220202'), ('0313006300000022505530220209'), ('0313006300000019009430220208'), ('0313006300000019783840220202'), ('0313006300000014385130220200'), ('0313006300000018959730220202'), ('0313006300000019957430220208'), ('0313007500000016739540220206'), ('0313006300000020255930220209'), ('0313006300000020101830220206'), ('0313007500000022629530220203'), ('0313006300000018863630220207'), ('0313006300000022608430220202'), ('0313006300000014337530220207'), ('0313006300000008135430220204'), ('0313006300000018960350220209'), ('0313006300000018960360220207'), ('0313006300000018960370220205'), ('0313007500000020469120220202'), ('0313006300000022633430220200'), ('0313012000000017923920120202'), ('0313006300000022595530220200'), ('0313004725000022134230220203'), ('0313007500000022141730220207'), ('0313006300000008501230220209'), ('0313006300000021647630220209'), ('0313006300000020474530220200'), ('0313007500000022640030220205'), ('0313006300000020798440220201'), ('0313006300000019961030220204'), ('0313012000000018481710220202'), ('0313006300000016278930220207'), ('0313006300000021621930220201'), ('0313006300000021621940220209'), ('0313007500000022159230220204'), ('0313011000000021956120120206'), ('0313006300000017363040220203'), ('0313005714000020349140120200'), ('0313006300000022612440220202'), ('0313006300000021654230220209'), ('0313006300000021660630220202'), ('0313006300000021660640220200'), ('0313012000000020428610120202'), ('0313011000000021391820120209'), ('0313006300000022617530220202'), ('0313006300000022643930220204'), ('0313006300000021587630220207'), ('0313006300000020878130220206'), ('0313007500000021812830220203'), ('0313003300000010465030220202'), ('0313005714000020076730220203'), ('0313006300000020747730220207'), ('0313006300000020747740220205')
/*           108*/

declare @tbl_mov as table(
	codper int, carnet varchar(50),
	nombres_apellidos varchar(201), NPE_Cargado_Agricola varchar(36),
	cuota_del_npe_cargado int, NPE_Existe varchar(83),
	tmo_codigo int, arancel varchar(5),
	tmo_descripcion varchar(100), ciclo int,
	codmov int	
)

insert into @tbl_mov 
	(codper, carnet, nombres_apellidos, [NPE_Cargado_Agricola], [NPE_Existe], tmo_codigo, arancel, 
	tmo_descripcion, ciclo, codmov, cuota_del_npe_cargado)

select 
	case when (per.per_codigo is null) then 'En el NPE no se reconoce el codper' else per.per_codigo end 'codper',
	per.per_carnet, per.per_nombres_apellidos,
	tbl_npe 'NPE-Cargado-Agricola', case when (art_codigo is null) then 'No existe' else NPE end 'NPE-Existe',
	tmo.tmo_codigo, tmo.tmo_arancel, tmo_descripcion, art.ciclo,
	(select mov_codigo from col_mov_movimientos
	inner join col_dmo_det_mov on mov_codigo = dmo_codmov
	where mov_codper = per.per_codigo and dmo_codcil = art.ciclo and dmo_codtmo = tmo.tmo_codigo) mov_codigo,
	(cast(substring(tbl_npe,21,1) as int)) cuota_del_npe_cargado
from @tbl_npes 
	left join col_art_archivo_tal_mora art on NPE = tbl_npe
	left join col_tmo_tipo_movimiento tmo on tmo.tmo_arancel = art.tmo_arancel
	left join ra_per_personas per on per.per_codigo = cast(substring(tbl_npe,11,10) as int)
where tbl_npe not in (
	select npe 
	from col_pagos_en_linea_estructuradoSP
	where npe in (
		select * from @tbl_npes
	) and formapago = 8
	and convert(date, fechahora, 103) in ('20200824')
)

--insert into @tbl_mov2
select 
codper, carnet, nombres_apellidos, [NPE_Cargado_Agricola], [NPE_Existe], m.tmo_codigo, arancel, m.tmo_descripcion, m.ciclo, 
codmov, cuota_del_npe_cargado,
mov_recibo, mov_usuario, mov_lote, mov_estado, mov_recibo_puntoxpress, mov_fecha_registro
,(
	select 
	--concat(
	--	'mov_codigo: ', mov_codigo, ', mov_recibo: ', mov_recibo, ', mov_fecha: ', mov_fecha, ', mov_estado: ', mov_estado, 
	--	', mov_usuario: ', mov_usuario, ', mov_fecha_registro: ', mov_fecha_registro, ', mov_usuario_anula: ', mov_usuario_anula, 
	--	', mov_fecha_anula: ', mov_fecha_anula, ', mov_recibo_puntoxpress: ', mov_recibo_puntoxpress, ', tmo_arancel: ', tmo_arancel, 
	--	', tmo_descripcion: ', tmo_descripcion, ', dmo_abono: ', dmo_abono
	--) trans
	mov_codigo, mov_recibo, mov_fecha, mov_estado, mov_usuario, mov_fecha_registro, 
	mov_usuario_anula, mov_fecha_anula, mov_recibo_puntoxpress, tmo_arancel, tmo_descripcion, dmo_abono
	from col_mov_movimientos
	inner join col_dmo_det_mov on mov_codigo = dmo_codmov
	inner join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
	where mov_codper = m.codper and dmo_codcil = m.ciclo and dmo_codtmo = tmo.tmo_codigo for xml path('')
) 'estado_cuota_ingresada_en_NPE'
from @tbl_mov m
	left join col_mov_movimientos on mov_codigo = codmov
	left join col_art_archivo_tal_mora art on codper = per_codigo and (fel_codigo_barra -1) = cuota_del_npe_cargado
	left join col_tmo_tipo_movimiento tmo on tmo.tmo_arancel = art.tmo_arancel
--for xml path('')