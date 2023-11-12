--Para el sistema empresarial UTEC no existe un scenario de contingencia por el tipo de sistema que tiene, solo se puede presentar por una caida en el servicio de MH, esperemos nunca pase...
--LA CONTINGENCIA SOLO LA ACTIVA TI MANUALMENTE CON LOS SIGUIENTES PASOS, ESTAS TABLAS DEBERIA TENER UN MATENIMIENTO...

-- Paso 1. Inserta en el encabezado de contigencia
-- drop table col_econdte_encabezado_contigencia_dte
create table col_econdte_encabezado_contigencia_dte (
	econdte_codigo int primary key identity (1, 1),
	econdte_FInicio date not null,
	econdte_HFin varchar(8) not null,
	econdte_FFin date not null,
	econdte_HInicio varchar(8) not null,
	econdte_TipoContingencia_codcat005 int not null,
	econdte_MotivoContingencia varchar(1000),
	
	econdte_telefono_emisor varchar(50) not null,
	econdte_tipo_establecimiento_emisor_codte009 varchar(3) not null,

	econdte_nombre_responsable varchar(125) not null,
	econdte_codcodcat022_responsable varchar(3) not null,
	econdte_numero_documento_responsable varchar(50) not null,

	econdte_CodEstableMH varchar(30) null,
	econdte_CodPuntoVenta varchar(30) null,

	econdte_request_mh varchar(max) null,
	econdte_response_mh varchar(max) null,
	econdte_fecha_response_mh datetime null,
	econdte_estado varchar(30) default 'Pendiente',

	condte_codusr_creacion int not null,
	condte_fecha_creacion datetime default getdate()
)
-- select * from col_econdte_encabezado_contigencia_dte
--Los datos del responsable son los datos de la persona de TI que activa la contigencia
insert into col_econdte_encabezado_contigencia_dte 
(econdte_FInicio, econdte_HInicio, econdte_FFin, econdte_HFin, econdte_TipoContingencia_codcat005, econdte_MotivoContingencia, 
condte_codusr_creacion, econdte_telefono_emisor, econdte_tipo_establecimiento_emisor_codte009,
econdte_nombre_responsable, econdte_codcodcat022_responsable, econdte_numero_documento_responsable)
values ('2023-07-03', '21:20:00', '2023-07-03', '22:00:00', 5, 'Prueba de contigencia MH 1', 407, '2275-8888', '02',
'Fabio Ernesto Ramos Reyes', '13', '05567057-5'), 
('2023-07-03', '22:20:00', '2023-07-03', '23:00:00', 5, 'Prueba de contigencia MH 2', 407, '2275-8888', '02',
'Fabio Ernesto Ramos Reyes', '13', '05567057-5'), 
('2023-07-03', '23:00:00', '2023-07-03', '23:10:00', 5, 'Prueba de contigencia MH 3', 407, '2275-8888', '02',
'Fabio Ernesto Ramos Reyes', '13', '05567057-5')

-- drop table col_dcondte_detalle_contingencia_dte
create table col_dcondte_detalle_contingencia_dte (
	dcondte_codigo int primary key identity (1, 1),
	dcondte_codecondte int foreign key references col_econdte_encabezado_contigencia_dte,
	dcondte_origen varchar(10) not null,
	dcondte_codigo_origen int not null,
	dcondte_tipo_documento_codcat023 varchar(3),
	dcondte_codigo_generacion varchar(36) default newid(),
	dcondte_codusr_creacion int,
	dcondte_fecha_creacion datetime default getdate()
)
-- select * from col_dcondte_detalle_contingencia_dte
-- Paso 2. Inserta los detalles de las facturas que fueron emitidas pero sin el sello
insert into col_dcondte_detalle_contingencia_dte (dcondte_codecondte, dcondte_origen, dcondte_codigo_origen, dcondte_tipo_documento_codcat023, dcondte_codusr_creacion)
values (1, 'mov', 7275102, '01', 407)
insert into col_dcondte_detalle_contingencia_dte (dcondte_codecondte, dcondte_origen, dcondte_codigo_origen, dcondte_tipo_documento_codcat023, dcondte_codusr_creacion)
values (2, 'mov', 7275101, '01', 407)
insert into col_dcondte_detalle_contingencia_dte (dcondte_codecondte, dcondte_origen, dcondte_codigo_origen, dcondte_tipo_documento_codcat023, dcondte_codusr_creacion)
values (3, 'mov', 7275099, '01', 407), (3, 'mov', 7275098, '01', 407), (3, 'mov', 7275097, '01', 407)

-- Paso 3. Se realiza la asignacion masiva del codigo de generacion, ESTA CARGA MASIVA DEBERIA SER UNA OPCION Y CARGAR UN EXCEL MASIVO...
--select mov_codigo_generacion, * from col_mov_movimientos where mov_codigo in (7275102,7275101,7275099,7275098,7275097)
declare @codecondte int = 1
declare @dcondte_origen varchar(10) = 1, @dcondte_codigo_origen int = 0, @dcondte_tipo_documento_codcat023 varchar(3)= '', @dcondte_codigo_generacion varchar(36) = ''
declare m_cursor cursor 
for
	select dcondte_origen, dcondte_codigo_origen, dcondte_tipo_documento_codcat023, dcondte_codigo_generacion  from col_dcondte_detalle_contingencia_dte where dcondte_codecondte = 1 order by dcondte_codigo
                
open m_cursor
 
fetch next from m_cursor into @dcondte_origen, @dcondte_codigo_origen, @dcondte_tipo_documento_codcat023, @dcondte_codigo_generacion
while @@FETCH_STATUS = 0 
begin

	if @dcondte_origen = 'mov'
	begin
		print 'update en col_mov_movimientos'
		update col_mov_movimientos set mov_codigo_generacion = @dcondte_codigo_generacion where mov_codigo = @dcondte_codigo_origen
	end
	if @dcondte_origen = 'fac'
	begin
		print 'update en col_fac_facturas'
		update col_fac_facturas set fac_codigo_generacion = @dcondte_codigo_generacion where fac_codigo = @dcondte_codigo_origen
	end

	if @dcondte_origen = 'faex'
	begin
		print 'update en faex_facturacion_sujeto_excluidos'
		update faex_facturacion_sujeto_excluido set faex_codigo_generacion = @dcondte_codigo_generacion where faex_codigo = @dcondte_codigo_origen
	end

    fetch next from m_cursor into @dcondte_origen, @dcondte_codigo_origen, @dcondte_tipo_documento_codcat023, @dcondte_codigo_generacion
end      
close m_cursor  
deallocate m_cursor

-- Paso 4. Ejecutar [POST] https://femhdemo.utec.edu.sv/Contingencia/Contingencia con el @codecondte 
	-- Paso 4. Ejecutar [POST] https://femh.utec.edu.sv/Contingencia/Contingencia con el @codecondte 
-- Paso 5. Enviar nuevamente los DTEs que se les asigno el @dcondte_codigo_generacion, ASEGURARSE QUE SE ENVIAN PORQUE SOLO SE TIENE MAXIMO 3 DIAS PARA ENVIAR LOS DTEs LUEGO DE LA CONTINGENCIA
