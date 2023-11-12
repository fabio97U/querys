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
where mov_codigo in (7396477, 7396478, 7396480, 7396481, 7396483, 7396484, 7396485, 7396486, 7396487, 7396488, 7396489, 7396490, 7396491, 7396492, 7396493, 7396494, 7396495, 7396496, 7396497, 
7396498, 7396499, 7396501, 7396502, 7396503, 7396504, 7396505, 7396506, 7396507, 7396508, 7396509, 7396511, 7396512, 7396513, 7396514, 7396515, 7396516, 7396517, 7396518, 7396519, 7396521, 7396522, 7396523, 7396524, 7396525, 7396526, 7396527)

order by mov_codigo
                
open m_cursor
 
fetch next from m_cursor into @codmov, @mov_correlativo_anual, @nuevo_correlativo
while @@FETCH_STATUS = 0 
begin
	print '@codmov: ' + cast(@codmov as varchar(12))
    select @codmov, @mov_correlativo_anual, @nuevo_correlativo
	--UPDATE col_mov_movimientos set mov_correlativo_anual = @nuevo_correlativo where mov_codigo = @codmov
    fetch next from m_cursor into @codmov, @mov_correlativo_anual, @nuevo_correlativo
end      
close m_cursor  
deallocate m_cursor
