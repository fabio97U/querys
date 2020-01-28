-- drop table ra_fec_fallo_envio_correos
create table ra_fec_fallo_envio_correos(
	fec_codigo int primary key identity(1, 1),
	fec_excepcion_mensaje varchar(1024),
	fec_de varchar(255),
	fec_para varchar(255),
	fec_formulario varchar(255),
	fec_sistema varchar(125),
	fec_fecha_hora datetime default getdate()
)
go
-- select * from ra_fec_fallo_envio_correos

alter procedure sp_fallo_correos
	@opcion int = 0,
	@fec_excepcion_mensaje varchar(1024) = '',
	@fec_de varchar(255) = '',
	@fec_para varchar(255) = '',
	@fec_formulario varchar(255) = '',
	@fec_sistema varchar(125) = ''
as
begin
	
	if @opcion = 1 --Inserta el fallo capturado
	begin
		insert into ra_fec_fallo_envio_correos (fec_excepcion_mensaje, fec_de, fec_para, fec_formulario, fec_sistema)
		values (@fec_excepcion_mensaje, @fec_de, @fec_para, @fec_formulario, @fec_sistema)
	end
end
go

select * from ra_fec_fallo_envio_correos

select * from ra_pra_prorroga_acad 
where pra_codper in (
select per_codigo from ra_fec_fallo_envio_correos 
inner join ra_per_personas on per_correo_institucional = fec_para
) and pra_codcil = 120 and pra_codpoo = 110
