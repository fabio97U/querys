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
('01/05/2021'), ('02/05/2021'), ('03/05/2021'), ('04/05/2021'), ('05/05/2021'), ('06/05/2021'), ('07/05/2021'), ('08/05/2021'), 
('09/05/2021'), ('10/05/2021'), ('11/05/2021'), ('12/05/2021'), ('13/05/2021'), ('14/05/2021'), ('15/05/2021'), ('16/05/2021'), 
('17/05/2021'), ('18/05/2021'), ('19/05/2021'), ('20/05/2021'), ('21/05/2021'), ('22/05/2021'), ('23/05/2021'), ('24/05/2021'), 
('25/05/2021'), ('26/05/2021'), ('27/05/2021'), ('28/05/2021'), ('29/05/2021'), ('30/05/2021'), ('31/05/2021'), ('01/06/2021'), 
('02/06/2021'), ('03/06/2021'), ('04/06/2021'), ('05/06/2021'), ('06/06/2021'), ('07/06/2021'), ('08/06/2021'), ('09/06/2021'), 
('10/06/2021'), ('11/06/2021'), ('12/06/2021'), ('13/06/2021'), ('14/06/2021'), ('15/06/2021'), ('16/06/2021'), ('17/06/2021'), 
('18/06/2021'), ('19/06/2021'), ('20/06/2021'), ('21/06/2021'), ('22/06/2021'), ('23/06/2021'), ('24/06/2021'), ('25/06/2021'), 
('26/06/2021'), ('27/06/2021'), ('28/06/2021'), ('29/06/2021'), ('30/06/2021')

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