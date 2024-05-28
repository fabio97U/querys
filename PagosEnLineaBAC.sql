-- select * from adm_ban_bancos
insert into adm_ban_bancos (ban_codigo, ban_nombre, ban_codcuc, ban_tarjetaCredito)
values (62, 'Banco de america central (BAC)', 17/*preguntar a Lic. Rivas*/, 0)
-- select * from col_pal_pagos_linea
insert into col_pal_pagos_linea (pal_nombre, pal_usuario, pal_banco, pal_descripcion_pago)
values ('Pagos de Bac NPE', 'pagobacnpe', 46, 'Pagos en linea Bac con NPE')

select * from col_pal_pagos_linea where pal_nombre like '%agr%'

--Para cuando se cree una nueva forma de pago se tiene que modificar los siguientes SP´s
-- exec rep_col_conrnpp_consultas_recibos_no_procesados_pagonenlinea '05/01/2024', '05/01/2024', 19 -- Rep: “Reporte de pagos en linea”
-- exec rep_partida_contable_colecturia 1, '05/01/2024','05/01/2024', 1-- Rep: “Partida contable”

SELECT * FROM col_art_archivo_tal_mora where per_codigo = 168640
select top 10 * from col_mov_movimientos order by mov_codigo desc
select top 10 * from col_dmo_det_mov order by dmo_codigo desc