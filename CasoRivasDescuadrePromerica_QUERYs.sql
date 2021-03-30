--corregir opcion
--exec rep_col_conrnpp_consultas_recibos_no_procesados_pagonenlinea '11/03/2021','11/03/2021', 3	--	pago en linea banco promerica npe
--5994.92
--Correcto: 5686.42

select *--mov_recibo, sum(dmo_valor + dmo_iva) 
from col_mov_movimientos
	inner join col_dmo_det_mov on dmo_codmov = mov_codigo
	inner join col_tmo_tipo_movimiento on dmo_codtmo = tmo_codigo
where cast(mov_fecha_registro as date) = '2021-03-10' and mov_usuario = 'postvirtual'
--and mov_recibo_puntoxpress = '106919523924'
--and mov_codigo = 6511842
and mov_recibo = 125674
--group by mov_recibo
order by mov_recibo

select * from user_rpe_resumen_pago_enlinea
where cast(rpe_fecha_registro as date) = '2021-03-10' and rpe_codigo_respuesta = '00'
and rpe_num_referencia = '106915380872'
order by rpe_fecha_registro

--select * from user_drp_detalle_pago_enlinea
--where drp_codrpe in (
--82492, 82494, 82495, 82496, 82498, 82499, 82500, 82501, 82503, 82505, 82506, 82507, 82508, 82509, 82510, 82511, 82512, 82514, 82524, 82525, 82526, 82527, 82528, 82529, 82530, 82531, 82532, 82533, 82534, 82535, 82536, 82537, 82538, 82539, 82540, 82544, 82545, 82546, 82547, 82548, 82549, 82550, 82551, 82552, 82553, 82554, 82555, 82556, 82557, 82558, 82559, 82560, 82561, 82562, 82563, 82564, 82565, 82566, 82567, 82568, 82570, 82571, 82572, 82574, 82575, 82576, 82577, 82578, 82581, 82582, 82583, 82584, 82585, 82586, 82587, 82588, 82589, 82590, 82591, 82592, 82593, 82594, 82595
--)
--order by drp_codrpe

select * from user_rpe_resumen_pago_enlinea where rpe_num_referencia = '106916383215'
select * from user_drp_detalle_pago_enlinea where drp_codrpe = 82509
update user_drp_detalle_pago_enlinea set drp_codtmo = 485/*ORIGINAL: 186*/ where drp_codrpe = 82509

select * from col_tmo_tipo_movimiento where tmo_codigo = 186









--CAMBIO EN LA OPCION 3 DEL SP: rep_col_conrnpp_consultas_recibos_no_procesados_pagonenlinea
declare @FechaI nvarchar(10) = '11/03/2021',
	@FechaF nvarchar(10) = '11/03/2021',
	@tipo int = 3,
	@pal_banco varchar(10) = '3', 
	@ban_nombre varchar(10) = 'promerica' , @total_registros int = 0

set dateformat dmy


print 'Pago de Post Virtual promerica'

declare @TablaFinal table (Codigo int, Factura int, carnet nvarchar(15), Nombre_Completo nvarchar(125), Valor float, 
Referencia nvarchar(60), Usuario nvarchar(50), Fecha nvarchar(15), FechaRegistro nvarchar(15), FechaCobro nvarchar(15 ), 
mov_puntoxpress int, ban_nombre nvarchar(100), arancel nvarchar(15))

Insert into @TablaFinal(Codigo, Factura, carnet, Nombre_Completo, Valor, Referencia, arancel, Usuario, Fecha, FechaRegistro, FechaCobro, mov_puntoxpress, ban_nombre)

select t.Codigo, t.Factura, t.per_carnet, t.per_nombres_apellidos, t.Valor, t.rpe_num_referencia, t.arancel, t.mov_usuario, 
t.mov_fecha, t.FechaRegistro, t.FechaCobro, @pal_banco as mov_puntoxpress, @ban_nombre as ban_nombre	
from (
	select distinct per_codigo,
	mov_codigo as Codigo, mov_recibo as Factura, per_carnet, per_nombres_apellidos,
	dmo_codtmo, (cast(rpe_monto as float)/*dmo_valor + dmo_iva*/) AS Valor, rpe_num_referencia, tmo_arancel as Arancel,
	mov_usuario, convert(varchar,mov_fecha,103) as mov_fecha,
	convert(varchar,mov_fecha_registro,103) as FechaRegistro,
	convert(varchar,mov_fecha_cobro,103) as FechaCobro,
	rpe_terminal, rpe_autorizacion, rpe_tarjeta_enmascarada, dmo_codmov, tmo_descripcion, mov_recibo_puntoxpress
	FROM dbo.col_dmo_det_mov 
		inner join dbo.col_mov_movimientos on dmo_codmov = mov_codigo 
		inner join dbo.ra_per_personas on mov_codper = per_codigo 
		inner join dbo.col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo 
		inner join dbo.user_rpe_resumen_pago_enlinea on rpe_codper = per_codigo and rpe_codcil = mov_codcil 
		inner join dbo.user_drp_detalle_pago_enlinea on rpe_codigo = drp_codrpe and drp_codtmo = dmo_codtmo
			and rpe_num_referencia = mov_recibo_puntoxpress
	where (mov_puntoxpress = 3) 
	and convert(varchar, mov_fecha,103) >= cast(@FechaI as date)
	and convert(varchar, mov_fecha,103) <= cast(@FechaF as date) and col_mov_movimientos.mov_recibo <> 0
) as t
where t.Valor <> 0 

--select * from @TablaFinal where Factura = 125674

delete from @TablaFinal where Referencia in (
	select distinct				
	mov_recibo_puntoxpress			
	from dbo.col_dmo_det_mov 
	inner join dbo.col_mov_movimientos on dmo_codmov = mov_codigo 
	inner join dbo.ra_per_personas on mov_codper = per_codigo 
	inner join dbo.col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo 
	inner join dbo.user_rpe_resumen_pago_enlinea on rpe_codper = per_codigo AND 
				rpe_codcil = mov_codcil 
	inner join dbo.user_drp_detalle_pago_enlinea on rpe_codigo = drp_codrpe AND 
				drp_codtmo = dmo_codtmo and mov_recibo_puntoxpress = rpe_num_referencia
	WHERE (mov_puntoxpress = 3)
	and convert(varchar,mov_fecha,103) >= cast(@FechaI as date)
	and convert(varchar,mov_fecha,103) <= cast(@FechaF as date) and col_mov_movimientos.mov_recibo <> 0
)

Insert into @TablaFinal(Codigo, Factura, carnet, Nombre_Completo, Valor, Referencia, arancel, Usuario, Fecha, FechaRegistro, FechaCobro,
mov_puntoxpress, ban_nombre)
select Distinct mov_codigo as Codigo, mov_recibo as Factura, per_carnet, per_nombres_apellidos,
(rpe_monto/*dmo_valor + dmo_iva*/) AS Valor, rpe_num_referencia, tmo_arancel, mov_usuario,
convert(varchar,mov_fecha,103) as mov_fecha, convert(varchar,mov_fecha_registro,103) as FechaRegistro,
convert(varchar,mov_fecha_cobro,103) as FechaCobro,
@pal_banco as mov_puntoxpress, @ban_nombre as ban_nombre				
from dbo.col_dmo_det_mov 
	inner join dbo.col_mov_movimientos on dmo_codmov = mov_codigo 
	inner join dbo.ra_per_personas on mov_codper = per_codigo 
	inner join dbo.col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo 
	inner join dbo.user_rpe_resumen_pago_enlinea on rpe_codper = per_codigo and rpe_codcil = mov_codcil 
	inner join dbo.user_drp_detalle_pago_enlinea on rpe_codigo = drp_codrpe 
		and drp_codtmo = dmo_codtmo and mov_recibo_puntoxpress = rpe_num_referencia

where (mov_puntoxpress = 3) and convert(varchar, mov_fecha, 103) >= cast(@FechaI as date) 
and convert(varchar,mov_fecha,103) <= cast(@FechaF as date)  and col_mov_movimientos.mov_recibo <> 0
--and mov_codper = 116808

select @total_registros = count(1) from @TablaFinal

select Codigo, Factura, carnet, Nombre_Completo, Valor, Referencia, Arancel, Usuario, Fecha, FechaRegistro, FechaCobro,
mov_puntoxpress, ban_nombre, @total_registros as Registros
from @TablaFinal
order by Factura













