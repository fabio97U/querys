-- Cuotas de Alumnos 162 C-30 458.00
-- 21,641
declare @ultimo_codcil int, @sum_cargo money, @sum_abono money, @diferencia money, 
@contador int = 0, @mayor_0 int = 0, @menor_0 int = 0
declare @codper varchar(12), @saldo money
declare m_cursor cursor 
for
    select per_codigo, per_saldo from ra_ins_inscripcion 
	inner join ra_per_personas on per_codigo = ins_codper
    where ins_codcil = 122 and per_tipo = 'U' and per_estado = 'A' 
	and per_anio_ingreso > 2008 and per_codcil_ingreso = 122
	order by per_codigo asc
open m_cursor 
 
fetch next from m_cursor into @codper, @saldo
print '@codper: ' + cast(@codper as varchar(12))
while @@FETCH_STATUS = 0 
begin
	--select @codper, @saldo
	select @ultimo_codcil = 122/*= max(cil_codigo) 
	from ra_ins_inscripcion 
	inner join ra_cil_ciclo on cil_codigo = ins_codcil
	where cil_codcic <> 3 and ins_codper = @codper and cil_codigo <> 122*/

	select @sum_cargo = sum(dmo_cargo), @sum_abono = sum(dmo_abono) from col_mov_movimientos 
	inner join col_dmo_det_mov on dmo_codmov = mov_codigo
	where mov_codper = @codper and mov_codcil = @ultimo_codcil and dmo_codcil = @ultimo_codcil
	--select @sum_cargo, @sum_abono
	set @diferencia = @sum_cargo-@sum_abono
	if (@diferencia = 0)
	begin
		--select 'Esta limpio el ciclo anterior'
		print 'limpio'
	end
	else
	begin
		-- 5288 Alumnos con el saldo no limpio
		-- 354 > 0 --DEBE EL ALUMNO
		-- 4934 < 0 --A FAVOR DEL ALUMNO
		if @diferencia > 0
			set @mayor_0 = @mayor_0 + 1
		else
			set @menor_0 = @menor_0 + 1
		--select @ultimo_codcil
		--select concat(@codper, ' $', @diferencia,' No esta limpio el ciclo anterior'), @saldo 'per_saldo', * from col_mov_movimientos 
		--	inner join col_dmo_det_mov on dmo_codmov = mov_codigo
		--	inner join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
		--where mov_codper = @codper and mov_codcil = @ultimo_codcil and dmo_codcil = @ultimo_codcil
		set @contador = @contador +1
	end
	--select per_saldo, * from ra_ins_inscripcion 
	--inner join ra_per_personas on per_codigo = ins_codper
	--inner join col_mov_movimientos on mov_codper = per_codigo and mov_codcil = 122
	--inner join col_dmo_det_mov on dmo_codmov = mov_codigo and dmo_codtmo = 162
	--inner join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
	--where ins_codcil = 122 and per_tipo = 'U'
	--and per_codigo = 222241
    fetch next from m_cursor into @codper, @saldo
end      
close m_cursor  
deallocate m_cursor
select @contador
select @mayor_0
select @menor_0