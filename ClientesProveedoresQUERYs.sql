/*
drop table gc_docclihi_documentos_clientes_historico
drop table gc_doccli_documentos_clientes
drop table gc_cli_clientes
drop table gc_docprovhi_documentos_proveedores_historico
drop table gc_docprov_documentos_proveedores
drop table gc_prov_proveedores
drop table gc_doctper_documentos_tipo_persona 
drop table gc_tper_tipo_persona 
*/
--drop table gc_tper_tipo_persona 
create table gc_tper_tipo_persona(
	tper_codigo int primary key identity(1,1),
	tper_persona varchar(125),
	tper_fecha_creacion datetime default getdate()
)
go
insert into gc_tper_tipo_persona (tper_persona) values('Persona Natural'), ('Persona Juridica')
go
--select * from gc_tper_tipo_persona
go

--drop table gc_doctper_documentos_tipo_persona
--select * from gc_doctper_documentos_tipo_persona

drop table gc_doctper_documentos_tipo_persona
create table gc_doctper_documentos_tipo_persona(
	doctper_codigo int primary key identity(1,1),
	doctper_codtper int foreign key references gc_tper_tipo_persona,
	doctper_documento varchar(255),
	doctper_fecha_creacion datetime default getdate()
)
go
insert into gc_doctper_documentos_tipo_persona (doctper_codtper, doctper_documento)
values(1, 'PEP'),(1, 'DUI Y NIT'),(1, 'REPRESENTANTE LEGAL'),(1, 'DUI Y NIT REP. LEGAL O APODERADO'),(1, 'CREDENCIAL DE REP. LEGAL O APODERADO'),(1, 'NUMERO DE REGISTRO FISCAL (NRC)'),(1, 'RESOLUCIÓN DEL MINISTERIO DE HACIENDA PARA EMISIÓN DE FACTURAS Y CCF.'),(1, 'DECLARACION RENTA, PAGO A CUENTA, IVA'),(1, 'COMPROBANTE DEL DOMICILIO')
,(2, 'PEP'), (2, 'REPRESENTANTE LEGAL'), (2, 'ESCRITURA PUBLICA Y DE MODIFICACION'), (2, 'DUI Y NIT REP. LEGAL O APODERADO'), (2, 'CREDENCIAL DE REP. LEGAL O APODERADO'), (2, 'NIT'), (2, 'NUMERO DE REGISTRO FISCAL (NRC)'), (2, 'RESOLUCIÓN DEL MINISTERIO DE HACIENDA PARA EMISIÓN DE FACTURAS Y CCF.'), (2, 'DECLARACION DE RENTA'), (2, 'ESTADOS FINANCIEROS CNR'), (2, 'COMPROBANTE DEL DOMICILIO');
go
--select * from gc_doctper_documentos_tipo_persona
--select * from gc_doctper_documentos_tipo_persona, gc_tper_tipo_persona where doctper_codtper = tper_codigo

------------------------------*------------------------------
--PERSONA CLIENTES
------------------------------*------------------------------
--drop table gc_docclihi_documentos_clientes_historico
--drop table gc_doccli_documentos_clientes
--drop table gc_cli_clientes

create table gc_cli_clientes(
	cli_codigo int primary key identity(1,1),
	cli_nombre varchar(255),
	cli_nombre_comercial varchar(255),
	cli_codtper int foreign key references gc_tper_tipo_persona,--N: Natural, J: Juridico
	cli_representante_legal varchar(255),
	cli_giro varchar(255),
	cli_fecha_creacion datetime default getdate()
)
go
--alter table gc_cli_clientes add cli_vigencia_credenciales date

--select doctper_codigo, doctper_documento from gc_doctper_documentos_tipo_persona where doctper_codtper = 1
--insert into gc_cli_clientes(cil_nombre, cil_nombre_comercial, cil_codtper, cli_representante_legal) values ('Carlos Morales', 'Las Carnitas', 'Carlos Morales Callejas'), ('Karina Hernandez','Tipicos Arce', 'Karina sosa')
--select * from gc_cli_clientes
update gc_cli_clientes set cli_vigencia_credenciales = null where cli_codigo = 1
go

--drop table gc_doccil_documentos_clientes
--select * from  gc_doccli_documentos_clientes
create table gc_doccli_documentos_clientes(
	doccli_codigo int primary key identity(1,1),
	doccli_codcli int foreign key references gc_cli_clientes,
	doccli_coddoctper int foreign key references gc_doctper_documentos_tipo_persona,
	doccli_codusr int foreign key references adm_usr_usuarios,
	doccli_fecha_creacion datetime default getdate()
)
go
--select * from gc_doccli_documentos_clientes

--select * from gc_doctper_documentos_tipo_persona, gc_tper_tipo_persona where doctper_codtper = 1 and doctper_codtper = tper_codigo
--insert into gc_doccli_documentos_clientes(doccli_codperna, doccli_coddoctper, doccli_codusr) values (1,1,407),(1,2,407),(1,3,407)
create table gc_docclihi_documentos_clientes_historico(
	docclihi_codigo int primary key identity(1,1),
	docclihi_codcli int,
	docclihi_coddoctper int,
	docclihi_codusr int,
	docclihi_fecha_movimiento datetime default getdate(),
	docclihi_movimiento varchar(2)--E: Elimino, A: Agrego
)
go
--select * from gc_docclihi_documentos_clientes_historico

--ENTREGADOS
select doccli_coddoctper, doctper_documento, 1 'doctper_entrego', doccli_codusr from gc_doccli_documentos_clientes, gc_doctper_documentos_tipo_persona where doccli_codcli = 1  and doctper_codigo = doccli_coddoctper
--PENDIENTES
union
select doctper_codigo, doctper_documento,0, 0 from gc_doctper_documentos_tipo_persona where doctper_codigo not in(
select doccli_coddoctper from gc_doccli_documentos_clientes, gc_doctper_documentos_tipo_persona where doccli_codcli = 1  and doctper_codigo = doccli_coddoctper
) and doctper_codtper = 1
--HISTORICO
union all
select docclihi_coddoctper, doctper_documento, docclihi_codcli, docclihi_codusr/*, docclihi_movimiento, docclihi_fecha_movimiento */ from gc_docclihi_documentos_clientes_historico, gc_doctper_documentos_tipo_persona where docclihi_codcli = 1  and doctper_codigo = docclihi_coddoctper
order by doccli_coddoctper


------------------------------*------------------------------
--PERSONA PROVEEDORES
------------------------------*------------------------------
--drop table gc_docprovhi_documentos_proveedores_historico
--drop table gc_docprov_documentos_proveedores
--drop table gc_prov_proveedores
create table gc_prov_proveedores(
	prov_codigo int primary key identity(1,1),
	prov_razon_social varchar(255),
	prov_nombre_comercial varchar(255),
	prov_representante_legal varchar(255),
	prov_codtper int foreign key references gc_tper_tipo_persona,--N: Natural, J: Juridico
	prov_giro varchar(255),
	prov_fecha_creacion datetime default getdate()
)
go
--select * from gc_prov_proveedores
--alter table gc_prov_proveedores add prov_vigencia_credenciales date


create table gc_docprov_documentos_proveedores(
	docprov_codigo int primary key identity(1,1),
	docprov_codprov int foreign key references gc_prov_proveedores,
	docprov_coddoctper int foreign key references gc_doctper_documentos_tipo_persona,
	docprov_codusr int foreign key references adm_usr_usuarios,
	docprov_fecha_creacion datetime default getdate()
)
go
--select * from gc_docprov_documentos_proveedores

create table gc_docprovhi_documentos_proveedores_historico(
	docprovhi_codigo int primary key identity(1,1),
	docprovhi_codprov int,
	docprovhi_coddoctper int,
	docprovhi_codusr int,
	docprovhi_fecha_eliminacion datetime default getdate(),
	docprovhi_movimiento varchar(2)--E: Elimino, A: Agrego
)
go
--select * from gc_docprovhi_documentos_proveedores_historico
/*
--ENTREGADOS
select docprov_coddoctper, doctper_documento, 1 'doctper_entrego', docprov_codusr from gc_docprov_documentos_proveedores, gc_doctper_documentos_tipo_persona where docprov_codprov = 1  and doctper_codigo = docprov_coddoctper
--PENDIENTES
union
select doctper_codigo, doctper_documento,0, 0 from gc_doctper_documentos_tipo_persona where doctper_codigo not in(
select docprov_coddoctper from gc_docprov_documentos_proveedores, gc_doctper_documentos_tipo_persona where docprov_codprov = 1  and doctper_codigo = docprov_coddoctper
) and doctper_codtper = 1
--HISTORICO
union all
select docprovhi_coddoctper, doctper_documento, docprovhi_codprov, docprovhi_codusr/*, docclihi_movimiento, docclihi_fecha_movimiento */ from gc_docprovhi_documentos_proveedores_historico, gc_doctper_documentos_tipo_persona where docprovhi_codprov = 1  and doctper_codigo = docprovhi_coddoctper
--order by docprovhi_coddoctper*/


ALTER procedure [dbo].[gc_mto_doc_per]
	----------------------*----------------------
	-- =============================================
	-- Author:      <Erik>
	-- Create date: <2019-03-13 10:34:13.817>
	-- Description: <Realiza los mantemientos a las tablas gc_tper_tipo_persona y gc_doctper_documentos_tipo_persona>
	-- =============================================
	@opcion int = 0,
	@tper_codigo int = 0,
	@tper_persona nvarchar(125) = '',

	@doctper_codigo int = 0,
    @doctper_codtper int = 0,
    @doctper_documento varchar(255) = ''
as
begin
	--gc_tper_tipo_persona
	if @opcion = 1--Actualiza
	begin
		update gc_tper_tipo_persona set tper_persona = @tper_persona where tper_codigo = @tper_codigo
	end
	if @opcion = 2--Elimina
	begin
		delete from gc_tper_tipo_persona where tper_codigo = @tper_codigo
	end
	if @opcion = 6--Inserta los tipos de persona
	begin
		if not exists (select 1 from gc_tper_tipo_persona where tper_persona = @tper_persona)
		begin
			insert into gc_tper_tipo_persona (tper_persona)
			values (@tper_persona)
		end
	end

	--gc_doctper_documentos_tipo_persona
	if @opcion = 3--Actualiza documentos
	begin
		update gc_doctper_documentos_tipo_persona set doctper_documento = @doctper_documento where @doctper_codigo = @doctper_codigo
	end
	if @opcion = 4 --Borra los documentos 
	begin
		delete from gc_doctper_documentos_tipo_persona where doctper_codigo = @doctper_codigo
	end
	if @opcion = 5--Muestra los datos de los ducumentos
	begin
		select doctper_codigo, tper_persona, doctper_documento, doctper_fecha_creacion 
		from gc_doctper_documentos_tipo_persona inner join gc_tper_tipo_persona
			on tper_codigo = doctper_codtper
	end

	if @opcion = 7--Inserta los ducumentos por el tipo de persona
	begin
		if not exists (select 1 from gc_doctper_documentos_tipo_persona where doctper_codtper = @doctper_codtper and doctper_documento = @doctper_documento)
		begin
			insert into gc_doctper_documentos_tipo_persona (doctper_codtper, doctper_documento)
			values (@doctper_codtper, @doctper_documento)
		end
	end
end