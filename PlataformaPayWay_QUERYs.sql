--select * from dbo.vst_pw_trans_denegadas
--select * from dbo.vst_pw_trans_aprobadas

select * from col_mov_movimientos 
where mov_usuario = 'payway_cuscatlan'
order by mov_codigo desc
update col_mov_movimientos set mov_codper = mov_codper * -1 where mov_usuario = 'payway_cuscatlan'

select * from col_dmo_det_mov
where dmo_codmov in (
	select mov_codigo from col_mov_movimientos 
	where mov_usuario = 'payway_cuscatlan'
)

select * from con_cuc_cuentas_contables where cuc_descripcion like '%enseñ%'
select * from adm_ban_bancos
select * from col_pal_pagos_linea

insert into col_pal_pagos_linea(pal_nombre, pal_usuario, pal_banco, pal_descripcion_pago)
values ('Pagos PayWay Banco Cuscatlan', 'payway_cuscatlan', 9, 'Pago en Linea plataforma PayWay Cuscatlan')--16
--LIC. Rivas
--select * from adm_ban_bancos--AMARAR A CODIGO 9********
--inner join col_pal_pagos_linea on pal_banco = ban_codigo
--where ban_codigo = 9

-- drop table pw_tcrp_tabla_codigos_retorno_payway
create table pw_tcrp_tabla_codigos_retorno_payway
(
	tcrp_codigo_retorno varchar(10) primary key,
	tcrp_descripcion varchar(255),
	tcrp_fecha_creacion datetime default getdate()
)
-- select * from pw_tcrp_tabla_codigos_retorno_payway where tcrp_descripcion like '%apro%'
--insert into pw_tcrp_tabla_codigos_retorno_payway (tcrp_codigo_retorno, tcrp_descripcion)
--values
--('050', 'EL TARJETAHABIENTE NO CUENTA CON DISPONIBILIDAD PARA LA TRANSACCION O EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('051', 'LA TARJETA HA VENCIDO'), ('055', 'LA TARJETA NO TIENE AUTORIZACION PARA UTILIZARSE EN PAGO ELECTRONICO O EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('056', 'EL TARJETAHABIENTE PRESENTA PROBLEMAS DE MORA, SOBREGIRO, ETC., O EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('057', 'LA TARJETA HA SIDO REEMPLAZADA, PERDIDA O ROBADA'), ('059', 'EL TARJETAHABIENTE PRESENTA RESTRICCION EN LA CUENTA, O EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('060', 'LA TARJETA HA SIDO CANCELADA O NO EXISTE LA CUENTA'), ('073', 'LA TARJETA NO TIENE AUTORIZACION PARA UTILIZARSE EN PAGO ELECTRONICO O EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('074', 'LA TARJETA NO TIENE AUTORIZACION POR PARTE DEL EMISOR O EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('076', 'EL TARJETAHABIENTE NO CUENTA CON DISPONIBILIDAD PARA LA TRANSACCION'), ('082', 'LA TARJETA HA ALCANZADO EL MAXIMO DE TRANSACCIONES PERMITIDO'), ('086', 'EL EMISOR NO RESPONDE A LA SOLICITUD DE TRANSACCION O EL TARJETAHABIENTE NO ESTA AUTORIZADO PARA REALIZAR LA TRANSACCION POR EL MONTO SOLICITADO'), ('089', 'LA TARJETA HA SIDO INACTIVADA, CERRADA O EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('095', 'EL MONTO DE LA TRANSACCION SUPERA EL MAXIMO PERMITIDO PARA LA TARJETA'), ('097', 'LA TARJETA PRESENTA PROBLEMAS EN LA COMPOSICION DE SUS DIGITOS, HA SIDO MAL DIGITADA O EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('101', 'EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('107', 'LA TARJETA HA ALCANZADO EL MAXIMO DE TRANSACCIONES DIARIAS PERMITIDAS'), ('200', 'LA TARJETA HA SIDO INVALIDADA'), ('204', 'EL MONTO DE LA TRANSACCION SUPERA EL MAXIMO PERMITIDO PARA LA TARJETA O EL MONTO SUPERA EL MAXIMO PERMITIDO AL COMERCIO'), ('205', 'EL TARJETAHABIENTE NO ESTA AUTORIZADO PARA REALIZAR LA TRANSACCION POR EL MONTO SOLICITADO O EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('206', 'LA TARJETA HA SIDO CANCELADA'), ('810', 'EL EMISOR DE LA TARJETA NO AUTORIZO LA TRANSACCION EN EL TIEMPO ESTIPULADO'), ('901', 'LA TARJETA HA VENCIDO O LA FECHA DE EXPIRACION PROPORCIONADA NO ES LA CORRECTA'), ('903', 'LA TARJETA HA SIDO ROBADA'), ('909', 'LA TARJETA HA SIDO REEMPLAZADA O PRESENTA PROBLEMAS QUE DEBEN SER ACLARADOS CON EL EMISOR'), ('97', 'NO SE OBTUVO UNA RESPUESTA DE PARTE DEL EMISOR Y/O PROCESADOR EN EL TIEMPO ESTABLECIDO. LA TRANSACCION SERA CONFIRMADA SI FUE APLICADA O NO'), ('98', 'LA TARJETA FUE DENEGADA Y REPORTADA PREVIAMENTE DEBIDO A UNA TRANSACCION DENEGADA QUE NO PUEDE REINTENTARSE. ES NECESARIO CAMBIO DE TARJETA'), ('99', 'ERROR COMUNICANDOSE CON EL EMISOR Y/O PROCESADOR. LA TRANSACCION SERA REPROGRAMADA EN LAS SIGUIENTES HORAS'), ('208', 'EL FORMATO DE FECHA DE EXPIRACION PROPORCIONADO ES INCORRECTO'), ('01', 'EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('02', 'LA TARJETA NO TIENE AUTORIZACION POR PARTE DEL EMISOR O EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('03', 'EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('04', 'LA TARJETA HA SIDO BLOQUEADA'), ('05', 'EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('07', 'LA TARJETA HA SIDO BLOQUEADA'), ('12', 'LA TARJETA NO TIENE AUTORIZACION PARA UTILIZARSE EN PAGO ELECTRONICO O EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('13', 'EL TARJETAHABIENTE NO ESTA AUTORIZADO PARA REALIZAR LA TRANSACCION POR EL MONTO SOLICITADO O EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('14', 'LA TRANSACCION PRESENTA PROBLEMAS EN EL PROCESAMIENTO O EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('15', 'EL EMISOR DE LA TARJETA NO RESPONDE A LA SOLICITUD DE TRANSACCION'), ('25', 'EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('30', 'LA TRANSACCION PRESENTA PROBLEMAS O EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('31', 'LA TARJETA NO PUEDE SER AUTORIZADA POR EL EMISOR'), ('39', 'LA TRANSACCION NO PUEDE COMPLETARSE'), ('41', 'LA TARJETA HA SIDO PERDIDA'), ('43', 'LA TARJETA HA SIDO ROBADA'), ('50', 'EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('51', 'EL TARJETAHABIENTE NO CUENTA CON DISPONIBILIDAD PARA LA TRANSACCION'), ('52', 'LA TRANSACCION NO PUEDE COMPLETARSE'), ('53', 'LA TRANSACCION NO PUEDE COMPLETARSE'), ('54', 'LA TARJETA HA VENCIDO'), ('55', 'EL PIN INGRESADO NO ES CORRECTO. LA TRANSACCION NO PUEDE PROCESARSE'), ('57', 'LA TRANSACCION NO PUEDE PROCESARSE'), ('58', 'LA TRANSACCION NO ESTA AUTORIZADA'), ('59', 'LA TARJETA PRESENTA SOSPECHA DE FRAUDE'), ('61', 'EL MONTO DE LA TRANSACCION SUPERA EL MAXIMO PERMITIDO PARA LA TARJETA'), ('62', 'EL TARJETAHABIENTE PRESENTA PROBLEMAS EN LA CUENTA O EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('83', 'LA TRANSACCION NO PUEDE PROCESARSE'), ('85', 'EL CODIGO DE SEGURIDAD DE LA TARJETA ES INVALIDO'), ('87', 'EL CODIGO DE SEGURIDAD DE LA TARJETA ES INVALIDO'), ('89', 'LA TRANSACCION NO ESTA AUTORIZADA PARA EL COMERCIO'), ('91', 'EL EMISOR DE LA TARJETA NO RESPONDE A LA SOLICITUD DE TRANSACCION'), ('92', 'EL EMISOR DE LA TARJETA NO RESPONDE A LA SOLICITUD DE TRANSACCION'), ('93', 'LA TRANSACCION NO PUEDE PROCESARSE'), ('94', 'LA TRANSACCION HA SIDO DUPLICADA'), ('96', 'LA TRANSACCION NO PUEDE INICIARSE'), ('19', 'LA TRANSACCION DEBE REINTENTARSE NUEVAMENTE'), ('76', 'EL PRODUCTO NO ESTA AUTORIZADO PARA EL COMERCIO'), ('77', 'EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('78', 'EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('80', 'EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS'), ('95', 'EL EMISOR HA DENEGADO LA TRANSACCION POR POLITICAS')

-- drop table pw_transa_transaccion_aprobada
create table pw_transa_transaccion_aprobada (
	transa_codigo int primary key identity (1, 1),
	transa_codper int,
	transa_codcil int,
	transa_npe varchar(32),
	transa_monto real,
	transa_pwoAuthorizationNumber varchar(40),-- Número de autorización de la transacción.
	transa_pwoReferenceNumber varchar(50),-- Número de referencia de la transacción.
	transa_pwoPayWayNumber varchar(50),-- Número PayWay para seguimiento de transacción.
	transa_pwoCustomerCCHolder varchar(60),-- Nombre del Tarjetahabiente.
	transa_pwoCustomerCCLastD varchar(24),-- Últimos cuatro dígitos de la tarjeta utilizada.
	transa_pwoCustomerCCBrand varchar(60),-- Marca de la tarjeta Utilizada
	transa_fecha_creacion datetime default getdate()
)
-- select * from pw_transa_transaccion_aprobada

-- drop table pw_transd_transaccion_denegada
create table pw_transd_transaccion_denegada (
	transd_codigo int primary key identity (1, 1),
	transd_codper int,
	transd_codcil int,
	transd_npe varchar(32),
	transd_monto real,
	transd_tmo_arancel varchar(5),
	transd_codtcrp varchar(10) foreign key references pw_tcrp_tabla_codigos_retorno_payway, -- Código de retorno por parte del autorizador
	transd_pwoReturnMessageTrx varchar(255), -- Mensaje de retorno por parte del autorizador
	transd_pwoReferenceNumber varchar(50), -- Número de referencia de la transacción.
	transd_pwoTransactionDate varchar(22), -- Fecha en que se ha realizado la transacción
	transd_pwoPayWayNumber varchar(20), -- Número PayWay para seguimiento de transacción.
	transd_pwoCustomerCCHolder varchar(60), -- Nombre del Tarjetahabiente.
	transd_pwoCustomerCCLastD varchar(24), -- Últimos cuatro dígitos de la tarjeta utilizada.
	transd_pwoCustomerCCBrand varchar(60), -- Marca de la tarjeta Utilizada
	transd_fecha_creacion datetime default getdate()
)
-- select * from pw_transd_transaccion_denegada
	
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-11-13 13:02:26.953>
	-- Description: <Devuelve las transacciones aprobadas de PayWay>
	-- =============================================
	-- select * from dbo.vst_pw_trans_aprobadas where transa_codper = 173322
create VIEW dbo.vst_pw_trans_aprobadas
AS
	select 
		transa_codigo, transa_codper, transa_codcil, transa_npe, transa_monto, transa_pwoAuthorizationNumber, transa_pwoReferenceNumber, 
		transa_pwoPayWayNumber, transa_pwoCustomerCCHolder, transa_pwoCustomerCCLastD, transa_pwoCustomerCCBrand, transa_fecha_creacion,
		per_carnet, per_apellidos_nombres, cil_codigo, concat('0', cil_codcic, '-', cil_anio) ciclo,
		tmo.tmo_arancel, tmo.tmo_descripcion, dmo_abono
	from pw_transa_transaccion_aprobada as trans
		inner join ra_per_personas on per_codigo = transa_codper
		inner join ra_cil_ciclo on cil_codigo = transa_codcil
		inner join col_mov_movimientos on mov_codper = per_codigo
		inner join col_dmo_det_mov on mov_codigo = dmo_codmov and dmo_codcil = transa_codcil 
			and mov_recibo_puntoxpress = transa_pwoReferenceNumber
		inner join col_tmo_tipo_movimiento tmo on tmo_codigo = dmo_codtmo
		inner join vst_Aranceles_x_Evaluacion vst on vst.are_codtmo = dmo_codtmo

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-11-13 13:09:41.017>
	-- Description: <Devuelve las transacciones denegadas de PayWay>
	-- =============================================
	-- select * from dbo.vst_pw_trans_denegadas where transd_codper = 173322
create VIEW dbo.vst_pw_trans_denegadas
AS
	select 
		transd_codigo, transd_codper, transd_codcil, transd_npe, transd_monto, transd_codtcrp, transd_pwoReturnMessageTrx, 
		transd_pwoReferenceNumber, transd_pwoTransactionDate, transd_pwoPayWayNumber, transd_pwoCustomerCCHolder, transd_pwoCustomerCCLastD, 
		transd_pwoCustomerCCBrand, transd_fecha_creacion, transd_tmo_arancel, tmo_arancel, tmo_descripcion,
		per_carnet, per_apellidos_nombres, cil_codigo, concat('0', cil_codcic, '-', cil_anio) ciclo,
		tcrp_codigo_retorno, tcrp_descripcion
	from pw_transd_transaccion_denegada as trans
		inner join ra_per_personas on per_codigo = transd_codper
		inner join ra_cil_ciclo on cil_codigo = transd_codcil
		inner join pw_tcrp_tabla_codigos_retorno_payway on transd_codtcrp = tcrp_codigo_retorno
		left join col_tmo_tipo_movimiento on tmo_arancel = transd_tmo_arancel

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-11-12 00:09:25.140>
	-- Description: <Realiza el proceso de los pagos utilizando la plataforma de PayWay>
	-- =============================================
	-- exec sp_pagos_payway 1, 181324, 0, '', 0/*16*/
create procedure sp_pagos_payway 
	@opcion int = 0,
	@codper int = 0,
	@codtde int = 0,
	@npe varchar(32) = '',
	@codpal int = 0/*@tipo en sp estructurado*/,
	@referencia varchar(50) = ''
as
begin

	if @opcion = 1 -- Datos generales del @codper
	begin
		-- exec sp_pagos_payway @opcion = 1, @codper= 181324
		select per_codigo,per_nombres_apellidos per_apellidos_nombres, 
			fac_nombre, car_nombre,per_estado, isnull(car_codtde, 0) as car_codtde
		from ra_per_personas 
			inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
			inner join ra_pla_planes on pla_codigo = alc_codpla 
			inner join ra_car_carreras on car_codigo = pla_codcar 
			inner join ra_fac_facultades on fac_codigo = car_codfac
		where per_codigo = @codper /*prees 181324, pre 173322, maes 227896, postgrado 223130*/
	end

	if @opcion = 2 -- Cuotas pendientes del @codper
	begin
		-- exec sp_pagos_payway @opcion = 2, @codper= 173322, @codtde = 1
		-- select * from pw_transa_transaccion_aprobada
		exec sp_cuotas_estudiantes_maestrias @codtde, @codper--CAMBIO SP, SE RETORNA COLUMNA NPE
	end

	if @opcion = 3 -- Inserta el pago utilizando el SP estructurado
	begin
		-- exec sp_pagos_payway @opcion = 3, @npe = '0313012000000018132450120207', @codpal = 16, @referencia = 'XXSAxX'
		exec sp_insertar_pagos_x_carnet_estructurado @npe, @codpal, @referencia
	end

end
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-11-12 01:10:45.416>
	-- Description: <Realiza la inserción/muestra de la respuesta de PayWay cuando el pago es aprobado o denegado>
	-- =============================================
create procedure sp_insertar_respuesta_payway
	@opcion int = 0,
	@codper int = 0,
	@codcil int = 0,
	@npe varchar(32) = '',
	@monto real = 0.0,
	/*Campos aprobacion*/
	@transa_pwoAuthorizationNumber varchar(40) = '',-- Número de autorización de la transacción.
	@transa_pwoReferenceNumber varchar(50) = '',-- Número de referencia de la transacción.
	@transa_pwoPayWayNumber varchar(50) = '',-- Número PayWay para seguimiento de transacción.
	@transa_pwoCustomerCCHolder varchar(60) = '',-- Nombre del Tarjetahabiente.
	@transa_pwoCustomerCCLastD varchar(24) = '',-- Últimos cuatro dígitos de la tarjeta utilizada.
	@transa_pwoCustomerCCBrand varchar(60) = '',-- Marca de la tarjeta Utilizada
	/*Campos denegado*/
	@transd_codtcrp varchar(10) = '',
	@transd_pwoReturnMessageTrx varchar(255) = '',
	@transd_pwoReferenceNumber varchar(50) = '', 
	@transd_pwoTransactionDate varchar(22) = '', 
	@transd_pwoPayWayNumber varchar(20) = '',
	@transd_pwoCustomerCCHolder varchar(60) = '',
	@transd_pwoCustomerCCLastD varchar(24) = '', 
	@transd_pwoCustomerCCBrand varchar(60) = '',
	@tmo_arancel varchar(30) = ''
as
begin
	
	if @opcion = 1 -- Inserta transacción aprobada
	begin
		insert into  pw_transa_transaccion_aprobada 
		(transa_codper, transa_codcil, transa_npe, transa_monto, transa_pwoAuthorizationNumber, transa_pwoReferenceNumber, 
		transa_pwoPayWayNumber, transa_pwoCustomerCCHolder, transa_pwoCustomerCCLastD, transa_pwoCustomerCCBrand)
		values(@codper, @codcil, @npe, @monto, @transa_pwoAuthorizationNumber, @transa_pwoReferenceNumber, 
		@transa_pwoPayWayNumber, @transa_pwoCustomerCCHolder, @transa_pwoCustomerCCLastD, @transa_pwoCustomerCCBrand)
		select scope_identity()
	end

	if @opcion = 2 -- Inserta transacción denegeda
	begin
		insert into pw_transd_transaccion_denegada 
		(transd_codper, transd_codcil, transd_npe, transd_monto, transd_codtcrp, transd_pworeturnmessagetrx, transd_pworeferencenumber, 
		transd_pwotransactiondate, transd_pwopaywaynumber, transd_pwocustomerccholder, transd_pwocustomercclastd, transd_pwocustomerccbrand, transd_tmo_arancel)
		values(@codper, @codcil, @npe, @monto, @transd_codtcrp, @transd_pwoReturnMessageTrx, @transd_pwoReferenceNumber, 
		@transd_pwoTransactionDate, @transd_pwoPayWayNumber, @transd_pwoCustomerCCHolder, @transd_pwoCustomerCCLastD, @transd_pwoCustomerCCBrand, @tmo_arancel)
		select scope_identity()
	end

	if @opcion = 3 -- Devuelve los datos de la transaccion aprobadas con numero de referencia por alumno
	begin
		-- sp_insertar_respuesta_payway @opcion = 3, @transa_pwoReferenceNumber = '7372841253', @codper = 173322
		select * from dbo.vst_pw_trans_aprobadas
		where transa_pwoReferenceNumber = @transa_pwoReferenceNumber and transa_codper = @codper
	end

	if @opcion = 4 -- Devuelve los datos de las transacciones aprobadas por alumno
	begin
		-- sp_insertar_respuesta_payway @opcion = 4, @codper = 173322
		select * from dbo.vst_pw_trans_aprobadas
		where transa_codper = @codper order by transa_codigo desc
	end

	if @opcion = 5 -- Devuelve los datos de las transacciónes denegadas con numero de referencia por alumno
	begin
		-- sp_insertar_respuesta_payway @opcion = 5, @transd_pwoReferenceNumber = '112364', @codper = 173322
		select * from dbo.vst_pw_trans_denegadas
		where transd_pwoReferenceNumber = @transd_pwoReferenceNumber and transd_codper = @codper
	end

	if @opcion = 6 --Devuelve los datos de las transacciónes denegadas por referencia por alumno
	begin
		-- sp_insertar_respuesta_payway @opcion = 6, @codper = 173322
		select * from dbo.vst_pw_trans_denegadas
		where transd_codper = @codper order by transd_codigo desc
	end

end
go









































--select * from ra_per_personas where per_carnet = '18-4846-2011' -- '10-0457-2015'
--	EXEC sp_cuotas_estudiantes_maestrias 2,219646
-- EXEC sp_cuotas_estudiantes_maestrias 3,193759
--	EXEC sp_cuotas_estudiantes_maestrias 1,211646
--	EXEC sp_cuotas_estudiantes_maestrias 1,170319
--	EXEC sp_cuotas_estudiantes_maestrias 1,181324
--	EXEC sp_cuotas_estudiantes_maestrias 1, 164819

ALTER PROCEDURE [dbo].[sp_cuotas_estudiantes_maestrias]
	@car_codtde int,
	@codper int
AS
BEGIN
	set dateformat dmy
	declare @a int

	declare @validador_pregrado int
	set @validador_pregrado = 1
	--ULTIMO CICLO DE INSCRIPCIÓN
	DECLARE @codcil int
	


	SELECT @codcil = MAX(ins_codcil) FROM ra_ins_inscripcion
	WHERE ins_codper = @codper

	set @codcil = @codcil 
	PRINT '@codcil : ' + CAST(@codcil AS NVARCHAR(10))
	--PRE GRADO y PRE ESPECIALIDAD

	IF @car_codtde = 1
	BEGIN
		print	'Verificando si es de pregrado o pre especializacion el alumno'
		--	PRE GRADO
		
		if exists(select 1 from col_art_archivo_tal_preesp_mora where per_codigo = @codper) -- and ciclo > @codcil)
		begin
			set @validador_pregrado = 0
			print 'alumno de pre Especializacion'
			--select * from col_art_archivo_tal_preesp_mora where per_codigo = @codper and ciclo > @codcil
			--	PRE ESPECIALIDAD

			select @codcil = max(ciclo) from col_art_archivo_tal_preesp_mora where per_codigo = @codper 


			  --declare @pendientes table (arancel nvarchar(25), codper int, cantidad int, Estado nvarchar(25),descripcion nvarchar(150), cuota int, codcil int, fecha date)

			   --insert into @pendientes (arancel, codper, cantidad, Estado, descripcion, cuota, codcil, fecha)
			   --select tmo.tmo_arancel, t.per_codigo as codper, 1 as cantidad, 
			   --      'Pendiente' as Estado, tmo.tmo_descripcion, vst.are_cuota, t.ciclo, t.fel_fecha_mora
			   select art.per_codigo, art.per_carnet, art.per_nombres_apellidos, art.tmo_arancel, art.fel_fecha_mora, art.ciclo, art.mciclo, 
					tmo.tmo_descripcion, 
					case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end as Monto, NPE
			   from col_tmo_tipo_movimiento as tmo inner join vst_Aranceles_x_Evaluacion as vst
					 on vst.tmo_arancel = tmo.tmo_arancel and vst.are_codtmo = tmo.tmo_codigo inner join col_art_archivo_tal_preesp_mora as art 
					 on art.tmo_arancel = tmo.tmo_arancel inner join ra_per_personas as p 
					 on p.per_codigo = art.per_codigo

			   where art.per_codigo = @codper and art.ciclo = @codcil and vst.are_tipo = 'PREESPECIALIDAD'
			   and are_cuota not in
			   (
					 select vst.are_cuota
					 from col_mov_movimientos as mov inner join col_dmo_det_mov as dmo
							on dmo.dmo_codmov = mov.mov_codigo inner join col_tmo_tipo_movimiento as tmo
							on tmo.tmo_codigo =  dmo.dmo_codtmo inner join vst_Aranceles_x_Evaluacion as vst
							on vst.tmo_arancel = tmo.tmo_arancel and vst.are_codtmo = tmo.tmo_codigo 
					 where mov_codper = @codper and dmo_codcil = @codcil and vst.are_tipo = 'PREESPECIALIDAD' and mov_estado <> 'A'       
			   )
			   order by art.fel_fecha_mora asc
		end	--	if exists(select 1 from col_art_archivo_tal_preesp_mora where per_codigo = @codper and ciclo > @codcil)


		if exists(select 1 from col_art_archivo_tal_proc_grad_tec_dise_mora where per_codigo = @codper and ciclo > @codcil)
		begin
			set @validador_pregrado = 0
			print 'alumno de pre Especializacion Tecnico Diseño Grafico'

			select @codcil = max(ciclo) from col_art_archivo_tal_proc_grad_tec_dise_mora where per_codigo = @codper 

			--select * from col_art_archivo_tal_proc_grad_tec_dise_mora where per_codigo = @codper and ciclo > @codcil
			--	PRE ESPECIALIDAD TECNICOS
			select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
				art.tmo_arancel, art.fel_fecha_mora as fel_fecha_mora, art.ciclo as ciclo, art.mciclo, tmo.tmo_descripcion, 
				case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end as Monto, NPE			
			from col_art_archivo_tal_proc_grad_tec_dise_mora as art
				--inner join alumnos_por_arancel_maestria as apama on apama.codcil = art.ciclo and apama.per_codigo = art.per_codigo
				inner join col_fel_fechas_limite_tecnicos_dise as fel on fel.fel_codcil = art.ciclo --and fel.fel_codtmo = apama.tmo_codigo --and fel.origen = art.origen
				inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_arancel = art.tmo_arancel
			where art.per_codigo = @codper 
			and tmo.tmo_arancel not in (
					SELECT tmo_arancel 
					FROM col_mov_movimientos 
					join col_dmo_det_mov on dmo_codmov = mov_codigo
					join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
					WHERE 
					mov_codper = @codper 
					and dmo_codcil >= @codcil--ciclo--MAX(art.ciclo)
					and mov_estado <> 'A'
				)
			and art.ciclo >= @codcil
			---- EXEC sp_cuotas_estudiantes_maestrias 3,188459
			--GROUP BY art.per_codigo, art.per_carnet, art.per_nombres_apellidos, art.tmo_arancel,
			--art.fecha, art.mciclo, tmo.tmo_descripcion, art.tmo_valor
			order by art.fel_fecha_mora asc
		end	--	if exists(select 1 from col_art_archivo_tal_preesp_mora where per_codigo = @codper and ciclo > @codcil)

		if exists(select 1 from col_art_archivo_tal_proc_grad_tec_mora where per_codigo = @codper and ciclo > @codcil)
		begin
			set @validador_pregrado = 0
			print 'alumno de pre Especializacion Tecnico '

			select @codcil = max(ciclo) from col_art_archivo_tal_proc_grad_tec_mora where per_codigo = @codper 

			--select * from col_art_archivo_tal_proc_grad_tec_dise_mora where per_codigo = @codper and ciclo > @codcil
			--	PRE ESPECIALIDAD TECNICOS
			select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
				art.tmo_arancel, art.fel_fecha_mora, --MAX(art.ciclo) as ciclo, 
				art.ciclo as ciclo, art.mciclo, tmo.tmo_descripcion, 
				case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end as Monto, NPE
			--art.tmo_valor as Monto
			from col_art_archivo_tal_proc_grad_tec_mora as art
				--inner join alumnos_por_arancel_maestria as apama on apama.codcil = art.ciclo and apama.per_codigo = art.per_codigo
				inner join col_fel_fechas_limite_tecnicos as fel on fel.fel_codcil = art.ciclo --and fel.fel_codtmo = apama.tmo_codigo --and fel.origen = art.origen
				inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_arancel = art.tmo_arancel
			where art.per_codigo = @codper 
			and tmo.tmo_arancel not in (
					SELECT tmo_arancel 
					FROM col_mov_movimientos 
					join col_dmo_det_mov on dmo_codmov = mov_codigo
					join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
					WHERE 
					mov_codper = @codper 
					and dmo_codcil >= @codcil--ciclo--MAX(art.ciclo)
					and mov_estado <> 'A'
				)
			and art.ciclo >= @codcil
			---- EXEC sp_cuotas_estudiantes_maestrias 3,188459
			--GROUP BY art.per_codigo, art.per_carnet, art.per_nombres_apellidos, art.tmo_arancel,
			--	art.fecha, art.mciclo, tmo.tmo_descripcion, 
			--	case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end
			order by art.fel_fecha_mora asc
		end	--	if exists(select 1 from col_art_archivo_tal_preesp_mora where per_codigo = @codper and ciclo > @codcil)
		--select * from col_fel_fechas_limite_tecnicos
		--select * from col_art_archivo_tal_proc_grad_tec_mora
		--if exists(select 1 from col_art_archivo_tal_proc_grad_tec_mora where per_codigo = @codper and ciclo > @codcil)
		--begin
		--	set @validador_pregrado = 0
		--	print 'alumno de pre Especializacion Tecnicos'
		--	--select * from col_art_archivo_tal_proc_grad_tec_mora where per_codigo = @codper and ciclo > @codcil
		--	--	PRE ESPECIALIDAD TECNICOS
		--	select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
		--	art.tmo_arancel, art.fecha, MAX(art.ciclo) as ciclo, art.mciclo, tmo.tmo_descripcion
		--	from col_art_archivo_tal_proc_grad_tec_mora as art
		--		--inner join alumnos_por_arancel_maestria as apama on apama.codcil = art.ciclo and apama.per_codigo = art.per_codigo
		--		inner join col_fel_fechas_limite_tecnicos as fel on fel.fel_codcil = art.ciclo --and fel.fel_codtmo = apama.tmo_codigo --and fel.origen = art.origen
		--		inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_arancel = art.fel_codtmo
		--	where art.per_codigo = @codper 
		--	and tmo.tmo_arancel not in (
		--			SELECT tmo_arancel 
		--			FROM col_mov_movimientos 
		--			join col_dmo_det_mov on dmo_codmov = mov_codigo
		--			join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
		--			WHERE 
		--			mov_codper = @codper 
		--			and dmo_codcil > @codcil--ciclo--MAX(art.ciclo)
		--		)
		--	and art.ciclo > @codcil
		--	---- EXEC sp_cuotas_estudiantes_maestrias 3,188459
		--	GROUP BY art.per_codigo, art.per_carnet, art.per_nombres_apellidos, art.tmo_arancel,
		--	art.fecha, art.mciclo, tmo.tmo_descripcion
		--end	--	if exists(select 1 from col_art_archivo_tal_preesp_mora where per_codigo = @codper and ciclo > @codcil)
		
		if (@validador_pregrado = 1)
		begin
			print 'el alumno es de pregrado'
			select @codcil = min(ciclo) from col_art_archivo_tal_mora where per_codigo = @codper
			print '@codcil : ' + cast(@codcil as nvarchar(10))



			--select tmo.tmo_arancel, t.per_codigo as codper, 1 as cantidad, 
			--	'Pendiente' as Estado, tmo.tmo_descripcion, vst.are_cuota, t.ciclo
			select art.per_codigo, art.per_carnet, art.per_nombres_apellidos, art.tmo_arancel, art.fel_fecha_mora, art.ciclo, art.mciclo, tmo.tmo_descripcion, 
				case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end as Monto, NPE
				--t.tmo_valor as Monto
			from col_tmo_tipo_movimiento as tmo inner join vst_Aranceles_x_Evaluacion as vst
				on vst.tmo_arancel = tmo.tmo_arancel and vst.are_codtmo = tmo.tmo_codigo inner join col_art_archivo_tal_mora as art 
				on art.tmo_arancel = tmo.tmo_arancel inner join ra_per_personas as p 
				on p.per_codigo = art.per_codigo

			where art.per_codigo = @codper and art.ciclo = @codcil and vst.are_tipo = 'PREGRADO'
			and are_cuota not in
			(
				select vst.are_cuota
				from col_mov_movimientos as mov inner join col_dmo_det_mov as dmo
					on dmo.dmo_codmov = mov.mov_codigo -- and dmo.dmo_codcil = mov.mov_codcil 
					inner join col_tmo_tipo_movimiento as tmo
					on tmo.tmo_codigo =  dmo.dmo_codtmo inner join vst_Aranceles_x_Evaluacion as vst
					on vst.tmo_arancel = tmo.tmo_arancel and vst.are_codtmo = tmo.tmo_codigo 
				where mov_codper = @codper and dmo_codcil = @codcil and vst.are_tipo = 'PREGRADO' and mov_estado <> 'A'		
			)
			order by art.fel_fecha_mora asc
			--select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
			--art.tmo_arancel, art.fel_fecha_mora,-- MAX(art.ciclo) as ciclo, 
			--art.ciclo,
			--art.mciclo, t.tmo_descripcion, art.tmo_valor as Monto
			--from col_art_archivo_tal_mora as art inner join col_tmo_tipo_movimiento as t on t.tmo_arancel = art.tmo_arancel
			--where cast(art.ciclo as nvarchar(10)) + '-' + t.tmo_arancel not in 
			--(
			--		SELECT cast(dmo_codcil as nvarchar(10)) + '-' + vst.tmo_arancel
			--		FROM col_mov_movimientos 
			--		join col_dmo_det_mov on dmo_codmov = mov_codigo
			--		join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
			--		join vst_Aranceles_x_Evaluacion as vst on vst.are_codtmo = dmo_codtmo
			--		WHERE mov_codper = @codper 
			--		and dmo_codcil >= @codcil--ciclo--MAX(art.ciclo)
			--		and tde_nombre = 'Pre grado' and mov_estado <> 'A'
			--	)
			--and per_codigo = @codper 
			--order by art.fel_fecha_mora asc
		end	--	if (@validador_pregrado = 1)




		--select * from col_art_archivo_tal_preesp_mora WHERE per_codigo = @codper
	END


	--MAESTRIAS
	IF @car_codtde = 2
	BEGIN
		print 'Maestrias'
		declare @codcil_mae_mora int
		--select * from col_art_archivo_tal_mae_mora
		select @codcil_mae_mora = min(ciclo) from col_art_archivo_tal_mae_mora where per_codigo = @codper
		--select @codcil_mae_mora = min(ciclo) from col_art_archivo_tal_mae_mora where per_codigo = @codper
		if (@codcil <> @codcil_mae_mora)
		begin
			print 'El estudiante es de graduacion, ya que no inscribio materias en el ciclo que paga las cuotas'
			set @codcil = @codcil_mae_mora
		end

		--select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
		--art.tmo_arancel, art.fel_fecha_mora, Min(art.ciclo) as ciclo, art.mciclo, tmo.tmo_descripcion
		--from col_art_archivo_tal_mae_mora as art
		--inner join alumnos_por_arancel_maestria as apama on apama.codcil = art.ciclo and apama.per_codigo = art.per_codigo
		--inner join col_fel_fechas_limite_mae_mora as fel on fel.fel_codcil = apama.codcil and fel.fel_codtmo = apama.tmo_codigo and fel.origen = art.origen
		--inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_arancel = art.tmo_arancel
		--where apama.per_codigo = @codper 
		--and tmo.tmo_arancel not in (
		--		SELECT tmo_arancel 
		--		FROM col_mov_movimientos 
		--		join col_dmo_det_mov on dmo_codmov = mov_codigo
		--		join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
		--		WHERE 
		--		mov_codper = @codper 
		--		and dmo_codcil >= @codcil--ciclo--MAX(art.ciclo)
		--	)
		--and apama.codcil >= @codcil
		---- EXEC sp_cuotas_estudiantes_maestrias 3,188459
		--GROUP BY art.per_codigo, art.per_carnet, art.per_nombres_apellidos, art.tmo_arancel,
		--art.fel_fecha_mora, art.mciclo, tmo.tmo_descripcion

		

			select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
				art.tmo_arancel, art.fel_fecha_mora,-- MAX(art.ciclo) as ciclo, 
				art.ciclo, art.mciclo, t.tmo_descripcion, --art.tmo_valor as Monto
				case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end as Monto, NPE
			from col_art_archivo_tal_mae_mora as art inner join alumnos_por_arancel_maestria as apama on apama.codcil = art.ciclo and apama.per_codigo = art.per_codigo
				inner join col_fel_fechas_limite_mae_mora as fel on fel.fel_codcil = apama.codcil and fel.fel_codtmo = apama.tmo_codigo and fel.origen = art.origen
				inner join col_tmo_tipo_movimiento as t on t.tmo_arancel = art.tmo_arancel
			where cast(art.ciclo as nvarchar(10)) + '-' + t.tmo_arancel not in 
			(
					SELECT cast(dmo_codcil as nvarchar(10)) + '-' + vst.tmo_arancel
					FROM col_mov_movimientos 
					join col_dmo_det_mov on dmo_codmov = mov_codigo
					join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
					join vst_Aranceles_x_Evaluacion as vst on vst.are_codtmo = dmo_codtmo
					WHERE mov_codper = @codper 
					and dmo_codcil >= @codcil--ciclo--MAX(art.ciclo)
					and tde_nombre = 'Maestrias' and mov_estado <> 'A'
				)
			and art.per_codigo = @codper 
			order by art.mciclo asc, art.fel_fecha_mora asc

	END

	
	--POSTGRADO
	IF @car_codtde = 3 or @car_codtde = 6
	BEGIN
		print 'El Alumno es de postgrado - Curso Especializado'
		select @codcil = min(ciclo) from col_art_archivo_tal_mae_posgrado where per_codigo = @codper
		print '@codcil : ' + cast(@codcil as nvarchar(10))

		select distinct art.per_codigo, art.per_carnet, art.per_nombres_apellidos,
			art.tmo_arancel, art.fel_fecha_mora, art.ciclo as ciclo, art.mciclo, tmo.tmo_descripcion, --art.tmo_valor as Monto
			case when art.fel_fecha_mora >= getdate() then art.tmo_valor else art.tmo_valor_mora end as Monto, NPE
		from col_art_archivo_tal_mae_posgrado as art
		inner join alumnos_por_arancel_maestria_posgrado as apamp on apamp.codcil = art.ciclo and apamp.per_codigo = art.per_codigo
		inner join col_fel_fechas_limite_mae_pg as fel on fel.fel_codcil = apamp.codcil and fel.fel_codtmo = apamp.tmo_codigo --and fel.origen = art.origen
		inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_arancel = art.tmo_arancel
		--inner join col_mov_movimientos as mov on mov.mov_codper = apamp.per_codigo 
		--inner join col_dmo_det_mov as dmo on dmo.dmo_codmov = mov.mov_codigo
		where 
		apamp.per_codigo = @codper
		and tmo.tmo_arancel not in (
				SELECT tmo_arancel 
				FROM col_mov_movimientos 
				join col_dmo_det_mov on dmo_codmov = mov_codigo
				join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
				WHERE 
				mov_codper = @codper 
				and dmo_codcil = @codcil and mov_estado <> 'A'
		)
		and apamp.codcil = @codcil
		order BY art.fel_fecha_mora asc

		--select * from alumnos_por_arancel_maestria_posgrado where per_codigo = 193884
	END
END