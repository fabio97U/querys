set dateformat dmy
declare @tbl_resultado as table (
	pad_codcia int, ASIENTO varchar(20),
	CONSECUTIVO real, pad_codcuc int,
	letra varchar(1), DEBITO_LOCAL float,
	CREDITO_LOCAL float, concepto varchar(261),
	REFERENCIA varchar(261), select_num int,
	mov_recibo varchar(20), mov_lote varchar(2),
	mov_codigo int, per_codigo int,
	cuc_cuenta varchar(33), NIT varchar(2),
	CENTRO_COSTO varchar(50), CUENTA_CONTABLE varchar(50), FUENTE varchar(1)
)

declare @select_cursor as table (fecha varchar(10))
insert into @select_cursor (fecha) values
('01/04/2021'), ('02/04/2021'), ('03/04/2021'), ('04/04/2021'), ('05/04/2021'), ('06/04/2021'), ('07/04/2021'), ('08/04/2021'), 
('09/04/2021'), ('10/04/2021'), ('11/04/2021'), ('12/04/2021'), ('13/04/2021'), ('14/04/2021'), ('15/04/2021'), ('16/04/2021'), 
('17/04/2021'), ('18/04/2021'), ('19/04/2021'), ('20/04/2021'), ('21/04/2021'), ('22/04/2021'), ('23/04/2021'), ('24/04/2021'), 
('25/04/2021'), ('26/04/2021'), ('27/04/2021'), ('28/04/2021'), ('29/04/2021'), ('30/04/2021')

declare @fecha varchar(10)--Variables del select
declare m_cursor cursor 
for
	select fecha from @select_cursor ---Colocar el select
                
open m_cursor
 
fetch next from m_cursor into @fecha
while @@FETCH_STATUS = 0 
begin
    print @fecha
	insert into @tbl_resultado
	exec dbo.genera_partida_tesoreria2 1, 1, @fecha, @fecha, @fecha, 343
    fetch next from m_cursor into @fecha
end      
close m_cursor  
deallocate m_cursor

select * from @tbl_resultado