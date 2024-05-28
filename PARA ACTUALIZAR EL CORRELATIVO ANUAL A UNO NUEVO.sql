--select * from vst_mh_encabezado_facturas 
--where numero_control is null and tipo_dte_numero = 1 and estado = 1
--and codigo_origen >= 7396477
--order by codigo_origen asc


declare @correlativo_anual int = 0
select @correlativo_anual = isnull(max(correlativo_anual), 0)
from vst_mh_encabezado_facturas 
where tipo_dte_numero = 1 and year(fecha_registro_origen) = year(getdate())
select @correlativo_anual 'correlativo'--32532

declare @correlativo_maximo int = @correlativo_anual
declare @codmov int, @mov_correlativo_anual int = 0, @nuevo_correlativo int = 0--Variables del select
declare m_cursor cursor 
for
select mov_codigo, mov_correlativo_anual, @correlativo_maximo + (row_number() over(order by mov_codigo))'nuevo_correlativo' 
from col_mov_movimientos 
where mov_codigo in (7557614)

order by mov_codigo
                
open m_cursor
 
fetch next from m_cursor into @codmov, @mov_correlativo_anual, @nuevo_correlativo
while @@FETCH_STATUS = 0 
begin
	print '@codmov: ' + cast(@codmov as varchar(12))
    select @codmov, @mov_correlativo_anual, @nuevo_correlativo
	UPDATE col_mov_movimientos set mov_correlativo_anual = @nuevo_correlativo where mov_codigo = @codmov
    fetch next from m_cursor into @codmov, @mov_correlativo_anual, @nuevo_correlativo
end      
close m_cursor  
deallocate m_cursor
