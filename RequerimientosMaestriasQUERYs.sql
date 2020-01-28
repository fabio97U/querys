--SOLICITADO POR: ADRIANA, TANIA
--DESCRIPCION: SOLICITAR DESDE EL PORTAL DE MAESTRIAS CARTA DE ERGRESADO, DESDE LA PARTE DE FACTURACION PODER VALIDAR Y RESTRINGIR LOS EXAMENES DIFERIDOS Y EXTRAODRINARIOS
--DESARROLLADORES INVOLUCRADOS: FABIO, ADONES


--insert into adm_usr_usuarios ( usr_codigo, usr_usuario, usr_password, usr_nombre, usr_codemp, usr_codcue) values (412, 'user.online.maestria', '123', 'Usuario tramites online maestria',0,0)
--go

insert into adm_opm_opciones_menu (opm_codigo,	opm_nombre,	opm_link, opm_opcion_padre, opm_orden, opm_sistema)
values
	(914, 'Examen diferidos', 'logo.html', 305, 58, 'U'),
		(915, 'Requisitos examen diferidos', 'ma_reqexd_requisitos_examen_diferido.aspx', 914, 1, 'U'),
		(916, 'Solicitudes examen diferidos', 'ma_solicitudes_tramites_online_maestrias.aspx', 914, 2, 'U'),
	(917, 'Examen extraordinarios', 'logo.html', 305, 59, 'U'),
		(918, 'Solicitudes examen extraordinarios', 'ma_solicitudes_maestrias_extraordinario.aspx', 917, 1, 'U'),
	(919, 'Carta egregsado', 'logo.html', 305, 60, 'U'),
		(920, 'Fechas solicitar carta', 'ma_persolcareg_periodo_solicitud_carta_egresado.aspx', 919, 1, 'U'),
		(921, 'Solicitudes carta egresado', 'ma_solicitud_carta_egresado_maestrias.aspx', 919, 2, 'U')
	--(922, 'Fechas cancelar tramite', 'fechas_cancelar_tramites.aspx', 305, 61, 'U'),

update col_tmo_tipo_movimiento set tmo_afecta_materia = 'S' where tmo_arancel in('E-20', 'E-21')


/*-------------------------------------DIFERIDOS-------------------------------------*/
create table ma_reqexd_requisitos_examen_diferido (--ma_reqexd_requisitos_examen_diferido.aspx
	reqexd_codigo int primary key identity(1,1),
	reqexd_max_diferidos int,
	reqexd_diferente_materia varchar(1), 
	reqexd_codtde int foreign key references ra_tde_TipoDeEstudio,
	reqexd_codcil_vigencia int foreign key references ra_cil_ciclo,
	reqexd_fecha_creacion datetime default getdate(),
	reqexd_usuario_creacion varchar(55)
);
go
insert into ma_reqexd_requisitos_examen_diferido(reqexd_max_diferidos, reqexd_diferente_materia, reqexd_codcil_vigencia,reqexd_codtde,reqexd_usuario_creacion) values(2, 'S',117,2, 'fabio.ramos'),(2,'S',119,2,'fabio.ramos')
--select  * from ma_reqexd_requisitos_examen_diferido



create procedure sp_ma_reqexd_requisitos_examen_diferido
	----------------------*----------------------
	-- =============================================
	-- Author:      <Fabio, Ramos>
	-- Create date: <2019-02-14 15:09:12.303>
	-- Description: <Realiza el matenimiento a la tabla ma_reqexd_requisitos_examen_diferido>
	-- =============================================
	--sp_ma_reqexd_requisitos_examen_diferido 1, 202330, 117, 4 --43-0132-2017
	--sp_ma_reqexd_requisitos_examen_diferido 1, 201951, 117, 4 --43-0033-2017
	--sp_ma_reqexd_requisitos_examen_diferido 1, 202330, 117, 4, 0, 0, 0, 0, 0, 0 --43-0033-2017
	--sp_ma_reqexd_requisitos_examen_diferido 1, 202330, 117, 4
	@opcion int = 0, 
	@codper int = 0,
	@codcil int = 0,
	@TipoTramiteAcademico int = 0,

	--Campos de la tabla
	@reqexd_codigo int = 0,
	@reqexd_max_diferidos int = 0, 
	@reqexd_diferente_materia varchar(2) = '', 
	@reqexd_codtde int = 0,
	@reqexd_codcil_vigencia int = 0,
	@reqexd_usuario_creacion varchar(25) = '' 
as
begin
	declare @maximo_diferidos int, @diferidos_solicitados int
	select @maximo_diferidos = reqexd_max_diferidos from ma_reqexd_requisitos_examen_diferido where reqexd_codcil_vigencia = @codcil
	if @opcion = 1--Devuelve la cantidad de diferidos el ciclo 
	begin
		select  @diferidos_solicitados = count(1) --'Diferidos solicitados', (@maximo_diferidos) 'Diferitos permitidos'
			from col_dmo_det_mov inner join col_mov_movimientos on mov_codigo = dmo_codmov 
			inner join ra_traar_tramites_aranceles_online on traar_codtmo = dmo_codtmo
			inner join ra_per_personas on per_codigo = mov_codper 
			inner join ra_ins_inscripcion on ins_codper = per_codigo 
			inner join ra_mai_mat_inscritas on  mai_codins = ins_codigo 
			inner join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl 
			inner join ra_mat_materias on dmo_codmat = mat_codigo
			where mov_estado <> 'A' and mov_codcil = @codcil  and traar_codtrao  = @TipoTramiteAcademico and mov_codper = @codper and rtrim(ltrim (dmo_codmat)) = hpl_codmat 
			and ins_codcil = @codcil and mai_estado = 'I' and traar_codtmo 
			in(--arancel que necesita haber pagado
			select traar_codtmo from ra_traar_tramites_aranceles_online, col_tmo_tipo_movimiento where traar_codtrao in (select trao_codigo from ra_Tramites_academicos_online where trao_codigo = @TipoTramiteAcademico) and tmo_codigo = traar_codtmo)

			if(@maximo_diferidos = @diferidos_solicitados)
			begin
				print 'YA SOLICITO EL MAXIMO DE DIFERIDOS EN ESTE CICLO'
				select 0
			end
			else
			begin
				print 'Diferidos tiene que ser en diferente materia'
				select reqexd_diferente_materia  from ma_reqexd_requisitos_examen_diferido where reqexd_codcil_vigencia = @codcil
			end

			print 'Diferidos pagados'
			select  mat_nombre as Nombre, rtrim(ltrim(dmo_codmat)) as Codigo,hpl_descripcion as Seccion, hpl_codigo
			from col_dmo_det_mov inner join col_mov_movimientos on mov_codigo = dmo_codmov 
			inner join ra_traar_tramites_aranceles_online on traar_codtmo = dmo_codtmo
			inner join ra_per_personas on per_codigo = mov_codper 
			inner join ra_ins_inscripcion on ins_codper = per_codigo 
			inner join ra_mai_mat_inscritas on  mai_codins = ins_codigo 
			inner join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl 
			inner join ra_mat_materias on dmo_codmat = mat_codigo
			where mov_estado <> 'A' and mov_codcil = @codcil  and traar_codtrao  = @TipoTramiteAcademico and mov_codper = @codper and rtrim(ltrim (dmo_codmat)) = hpl_codmat --and dmo_eval = @evaluacion
			and ins_codcil = @codcil and mai_estado = 'I' and traar_codtmo 
			in(--arancel que necesita haber pagado
			select traar_codtmo from ra_traar_tramites_aranceles_online, col_tmo_tipo_movimiento where traar_codtrao in (select trao_codigo from ra_Tramites_academicos_online where trao_codigo = @TipoTramiteAcademico) and tmo_codigo = traar_codtmo)

			--ARANCELES NECESARIOS PARA EL TRAMITE
			select tmo_arancel, tmo_descripcion from ra_traar_tramites_aranceles_online, col_tmo_tipo_movimiento where traar_codtrao = @TipoTramiteAcademico and tmo_codigo = traar_codtmo
			--select * from ra_Tramites_academicos_online where trao_codigo in(select traar_codtrao from ra_traar_tramites_aranceles_online where traar_codtmo = (select tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'E-21'))
	end

	if @opcion = 2--Muestra 
	begin
		select reqexd_codigo, 
		reqexd_max_diferidos 'Maximo de diferidos', 
		case reqexd_diferente_materia when 'S' then 'Si' else 'No' end 'Diferidos en diferentes materias', 
		(select tde_nombre from ra_tde_TipoDeEstudio where tde_codigo = reqexd_codtde) 'Tipo estudio', 
		(select CONCAT('0', cil_codcic, '-', cil_anio) from ra_cil_ciclo where cil_codigo = reqexd_codcil_vigencia) 'Ciclo vigencia' from ma_reqexd_requisitos_examen_diferido
	end
	if @opcion = 3--Inserta
	begin
		if not exists (select 1 from ma_reqexd_requisitos_examen_diferido where reqexd_codcil_vigencia = @reqexd_codcil_vigencia and reqexd_codtde = @reqexd_codtde)
		begin
			insert into ma_reqexd_requisitos_examen_diferido (reqexd_max_diferidos, reqexd_diferente_materia, reqexd_codtde,reqexd_codcil_vigencia, reqexd_usuario_creacion)
			values(@reqexd_max_diferidos, @reqexd_diferente_materia, @reqexd_codtde,@reqexd_codcil_vigencia, @reqexd_usuario_creacion)
		end
	end
	if @opcion = 4--Actualiza
	begin
		update ma_reqexd_requisitos_examen_diferido set reqexd_max_diferidos = @reqexd_max_diferidos, reqexd_diferente_materia = @reqexd_diferente_materia, reqexd_codtde = @reqexd_codtde,reqexd_codcil_vigencia = @reqexd_codcil_vigencia
		where reqexd_codigo = @reqexd_codigo
	end
end

--drop table ma_soltraam_solicitudes_tramites_academicos_maestrias 

delete from col_dmo_det_mov where dmo_codmov in (select mov_codigo from col_mov_movimientos where /*mov_codper = 202330 and mov_codcil = 119 and*/  mov_usuario = 'fabio.ramos') 
delete from col_mov_movimientos where mov_codigo in (select mov_codigo from col_mov_movimientos where /*mov_codper = 202330 and and mov_codcil = 119 and*/  mov_usuario = 'fabio.ramos') 
delete from ra_aan_activar_alumno_notas where aan_codper = 202330 

drop table ma_soltraam_solicitudes_tramites_academicos_maestrias 
create table ma_soltraam_solicitudes_tramites_academicos_maestrias (
	soltraam_codigo int primary key identity (1,1),
	soltraam_codper int foreign key references ra_per_personas,
	soltraam_codmov int,
	soltraam_coddmo int,
	soltraam_codpon int,--foreign key references ra_pon_ponderacion_mae,
	soltraam_materia_numero int,
	soltraam_pago_arancel datetime default getdate(),--FECHA SOLICITO
	--soltraam_fecha_solicito datetime,
	soltraam_codhpl int,
	soltraam_codusr int,
	soltraam_codcil int,
	soltraam_tipo varchar(55),
	soltraam_estado varchar(25) default 'Solicitado'
);
go
select * from ma_soltraam_solicitudes_tramites_academicos_maestrias 
SELECT top 2 * FROM col_mov_movimientos order by mov_codigo desc
select top 2 * from col_dmo_det_mov  order by dmo_codigo desc
(select * from adem_activar_desactivar_evaluaciones_maes where adem_estado = 'A')
SELECT * FROM ra_hpl_horarios_planificacion where hpl_codigo = 34176

alter procedure sp_ma_soltraam_solicitudes_tramites_academicos_maestrias
--sp_ma_soltraam_solicitudes_tramites_academicos_maestrias 2, 119, 2, 4
	@opcion int,
	@codcil int = 0,
	@soltraam_codpon int = 0,
	@soltraam_materia_numero int = 0
as
begin
	if @opcion = 1--MUESTRA LAS SOLICITUDES DE EXAMEN DIFERIDO
	begin
		select soltraam_codigo, per_nombres_apellidos 'Estudiante', per_correo_institucional 'Correo',
			hpl_codmat 'CodMat', mat_nombre 'Materia', hpl_descripcion 'Seccion', emp_nombres_apellidos 'Docente', emp_email_institucional 'Correo-Docente', soltraam_codpon 'Evaluacion', soltraam_materia_numero 'Nª Materia',
			concat('0', cil_codcic,'-',cil_anio) 'Ciclo', 
			 soltraam_pago_arancel 'Fecha Pago Examen', 
			 soltraam_tipo 'Tipo', soltraam_estado 'Estado', '' 'Firma'
		from ma_soltraam_solicitudes_tramites_academicos_maestrias, 
			ra_hpl_horarios_planificacion, 
			ra_mat_materias,
			adm_usr_usuarios, 
			ra_cil_ciclo,
			ra_per_personas,
			pla_emp_empleado
		where hpl_codigo = soltraam_codhpl 
			and hpl_codmat = mat_codigo 
			and usr_codigo = soltraam_codusr 
			and soltraam_codcil = cil_codigo
			and per_codigo = soltraam_codper
			and emp_codigo = hpl_codemp
			and soltraam_codcil = @codcil 
			and soltraam_codpon = @soltraam_codpon
			and soltraam_materia_numero = @soltraam_materia_numero
			and soltraam_tipo = 'Diferido'
	end
	if @opcion = 2--MUESTRA LAS SOLICITUDES DE EXAMEN EXTRAORDINARIO
	begin
		select soltraam_codigo, per_nombres_apellidos 'Estudiante', per_correo_institucional 'Correo',
				hpl_codmat 'CodMat', mat_nombre 'Materia',hpl_descripcion 'Seccion', emp_nombres_apellidos 'Docente', emp_email_institucional 'Correo-Docente', soltraam_materia_numero 'Nª Materia',
				concat('0', cil_codcic,'-',cil_anio) 'Ciclo', 
				soltraam_pago_arancel 'Fecha Pago Examen',
				soltraam_tipo 'Tipo', soltraam_estado 'Estado', '' 'Firma'
		from ma_soltraam_solicitudes_tramites_academicos_maestrias, 
			ra_hpl_horarios_planificacion, 
			ra_mat_materias,
			adm_usr_usuarios, 
			ra_cil_ciclo,
			ra_per_personas,
			pla_emp_empleado
		where hpl_codigo = soltraam_codhpl 
			and hpl_codmat = mat_codigo 
			and usr_codigo = soltraam_codusr 
			and soltraam_codcil = cil_codigo
			and per_codigo = soltraam_codper
			and emp_codigo = hpl_codemp
			and soltraam_codcil = @codcil 
			and soltraam_materia_numero = @soltraam_materia_numero
			and soltraam_tipo = 'Examen-Extraordinario'
	end
end

/*-------------------------------------CARTA EGREGSADO-------------------------------------*/
--select * from ma_persolcareg_periodo_solicitud_carta_egresado
create table ma_persolcareg_periodo_solicitud_carta_egresado (--ma_persolcareg_periodo_solicitud_carta_egresado.aspx
	persolcareg_codigo int primary key identity(1,1),
	persolcareg_codcil int foreign key references ra_cil_ciclo,
	persolcareg_fecha_inicio datetime,
	persolcareg_fecha_fin datetime,
	persolcareg_pago_completos int default 1,
	persolcareg_documentos_completos int default 1,
	persolcareg_fecha_creacion datetime default getdate()
)
go
insert into ma_persolcareg_periodo_solicitud_carta_egresado (persolcareg_codcil, persolcareg_fecha_inicio, persolcareg_fecha_fin) 
values(117, '2019-02-15 14:48:52.333', '2019-03-15 14:48:52.333'),(119, '2019-02-15 14:48:52.333', '2019-03-15 14:48:52.333')
go

create procedure sp_ma_persolcareg_periodo_solicitud_carta_egresado
	----------------------*----------------------
	-- =============================================
	-- Author:      <Fabio, Ramos>
	-- Create date: <2019-02-11 14:29:33.430>
	-- Description: <Realiza el mantenimento para la tabla ma_persolcareg_periodo_solicitud_carta_egresado en la cual se guardar los requisitos por ciclo para solicitar la carta de egresado>
	-- =============================================
	--sp_ma_persolcareg_periodo_solicitud_carta_egresado 1, 117, 0
	--sp_ma_persolcareg_periodo_solicitud_carta_egresado 2, 117, 196586
	--sp_ma_persolcareg_periodo_solicitud_carta_egresado 2, 117, 201951
	@opcion int,
	@codcil int,
	@codper int
as
begin
	if @opcion = 1 --Devuelve la fecha inicio y fin de solicitud de carta de egresado en maestrias en un ciclo
	begin
		select persolcareg_fecha_inicio, persolcareg_fecha_fin from ma_persolcareg_periodo_solicitud_carta_egresado where persolcareg_codcil = @codcil
	end
	if @opcion = 2 --Devuelve si el estudiante cumple los requisitos(documentos completos y pago completos) de la tabla ma_persolcareg_periodo_solicitud_carta_egresado
	begin
		declare @documentos varchar(12), @pagos varchar(12), @persolcareg_pago_completos int, @persolcareg_documentos_completos int
		select @persolcareg_pago_completos = persolcareg_pago_completos, @persolcareg_documentos_completos= persolcareg_documentos_completos from ma_persolcareg_periodo_solicitud_carta_egresado where persolcareg_codcil = @codcil
		print @persolcareg_pago_completos
		print @persolcareg_documentos_completos
		if(@persolcareg_pago_completos = 1)
		begin
			declare @Tabla Table (cil_codigo int, per_codigo int, per_carnet nvarchar(12), carrera nvarchar(75), Alumno Nvarchar(60), fechaf nvarchar(8), referencia nvarchar(20),
					barra_f nvarchar(75), barra nvarchar(75), NPE nvarchar (30), barra_m_f nvarchar(75), barra_mora nvarchar(75), NPE_m nvarchar(30), Valor float, fecha date,
					fecha_v date, Orden int, papeleria float, portafolio float, valor_m float, matriculo float, ciclo nvarchar(7), per_estado nvarchar(3), per_tipo int, texto nvarchar(75),
					Estado Nvarchar(15), cuota_pagar float, cuota_pagar_mora float, Beca Float)
					insert into @Tabla
			exec web_col_art_archivo_tal_mae 4, @codper, @codcil, ''

			declare @total_pagos int, @pagos_realizados int

			select @total_pagos = count(1) from @Tabla
			select @pagos_realizados = count(1) from @Tabla where Estado = 'Cancelado'

			if (@total_pagos-@pagos_realizados) = 0
			begin
				print 'Tiene todos los pagos'
				set @pagos = 'Completos'
			end
			else
			begin
				print 'Le faltan pagos'
				set @pagos = 'Incompletos'
			end
		end
		else if(@persolcareg_pago_completos = 0)
		begin
			set @pagos = 'Completos'
		end

		if(@persolcareg_documentos_completos = 1)
		begin
			if exists(select 1 from ra_dop_doc_per where dop_codper=@codper and dop_coddoc in (40))
			begin
				set @documentos= 'Completos'
			end
			else if(select count(1) from ra_dop_doc_per where dop_codper=@codper) >= 8
			begin
				set @documentos = 'Completos'
			end
			else 
			begin
				set @documentos = 'Incompletos'
			end
		end
		else if(@persolcareg_documentos_completos = 0)
		begin
			set @documentos = 'Completos'
		end

		select 'Pagos: ', @pagos
		union
		select 'Documentos: ', @documentos
	end
end
go

alter procedure [dbo].[ra_regr_inserta_reg]
	@codper int, 
	@codusr int, 
	@codcil_ing int
as
begin
	set dateformat dmy
	declare @cum real, @codcil int, @documentos char(1), @observaciones varchar(100)
	--Asignación de CUM limpio del Alumno
	set @cum = (select dbo.cum_todos_los_ciclos(@codper))
	--set @cum = (select dbo.cum(@codper))		--	Comentariado el 14/06/2018 por Juan Carlos Campos debido a que tiene que mostrar el cum de las materias aunque el ci

	--Asignación de ciclo de egreso del Alumno
	-- ANTERIOR
	--select @codcil = max(ins_codcil) from ra_ins_inscripcion join ra_mai_mat_inscritas on mai_codins = ins_codigo 
	--where ins_codper =@codper 
	declare @Max_ciclo table(fecha nvarchar(10), ins_codcil int)

	insert into @Max_ciclo (fecha, ins_codcil)
	select top 1 max(ins_fecha)fecha, ins_codcil
	--into #Max_ciclo
	from ra_per_personas
		join ra_alc_alumnos_carrera on alc_codper = per_codigo
		join dbo.ra_ins_inscripcion on ins_codper = per_codigo
		join ra_mai_mat_inscritas on mai_codins = ins_codigo
		join ra_cil_ciclo on cil_codigo = ins_codcil
	where per_codigo = @codper and mai_estado = 'I'
	group by ins_codcil
	order by 1 desc

	select @codcil = ins_codcil
	from @Max_ciclo

	----Verificamos el tipo de ingreso del alumno
	--select isnull (per_tipo_ingreso_fijo, 1) from ra_per_personas where per_codigo=@codper

	--Verificamos los documentos de acuerdo al tipo de ingreso del alumno
	--select * from ra_doc_documentos where doc_coding=1 and doc_origen='N'
	--select * from ra_dop_doc_per where dop_codper=107408

	if ((select per_tipo from ra_per_personas where per_codigo = @codper) = 'M') --SON ALUMNOS DE MAESTRIAS, AGREGADO POR FABIO 2019-02-08
	begin
		if exists(select 1 from ra_dop_doc_per where dop_codper=@codper and dop_coddoc in (40))
		begin
			set @documentos= 'C'
			set @observaciones = 'Documentos Completos'
		end
		else if(select count(1) from ra_dop_doc_per where dop_codper=@codper) >= 8
		begin
			set @documentos = 'C'
			set @observaciones = 'Documentos Completos'
		end
		else 
		begin
			set @documentos = 'I'
			set @observaciones = 'Documentos Incompletos'
		end
	end
	else
	begin--SON ALUMNOS DE PREGRADO
		if exists(select 1 from ra_dop_doc_per where dop_codper=@codper and dop_coddoc in (10, 18))
		begin
			set @documentos= 'C'
			set @observaciones = 'Documentos Completos'
		end
		else if(select count(1) from ra_dop_doc_per where dop_codper=@codper) >= 4
		begin
			set @documentos = 'C'
			set @observaciones = 'Documentos Completos'
		end
		else 
		begin
			set @documentos = 'I'
			set @observaciones = 'Documentos Incompletos'
		end
	end

	--Inserta registro de Alumno egresado
	insert into ra_regr_registro_egresados (regr_codper, regr_fecha, regr_documentos, regr_observaciones, regr_estado, regr_cum, regr_codcil, regr_codusr, regr_codcil_ing)
	select @codper, GETDATE(), @documentos, @observaciones, 'A', @cum, @codcil, @codusr, @codcil_ing
end
go



--web_pagos_alumno_ciclo 1, 202330, 117
--web_pagos_alumno_ciclo 1, 181324, 107
ALTER proc [dbo].[web_pagos_alumno_ciclo]
	@regional int,
	@codper int,
	@codcil int

as
set dateformat dmy
--set @codcil = 99--temporal para el interciclo
declare @valor_inicial real, @saldo real
set @saldo = 0.0
select @saldo = per_saldo from ra_per_personas where per_codigo = @codper

select mov_codper,mov_codigo, mov_fecha, dmo_valor, dmo_iva,dmo_codtmo,
case when mov_recibo_puntoxpress is not null then 'PX' else cast(mov_codban as varchar(3)) end mov_codban, 
mov_recibo,dmo_cargo,
dmo_abono,mov_fecha_cobro,dmo_codcil, mov_estado, dmo_codmat, mov_puntoxpress
into #mov
from col_mov_movimientos
join col_dmo_det_mov on dmo_codmov = mov_codigo
where mov_codper = @codper
and dmo_codcil = @codcil
and mov_estado <> 'A'


select "Universidad", "Carnet", "Alumno", 
tipo,"Carrera", "Regional", 
ciclo,cil_anio, cil_codcic,
mov_recibo,tmo_arancel,mov_fecha,mov_codban,
tmo_descripcion+' '+case when tmo_arancel = 'S-04 ' then (select '('+mat_nombre+')' from ra_mat_materias where mat_codigo = dmo_codmat) when tmo_arancel = 'E-21' then (select '('+mat_nombre+')' from ra_mat_materias where mat_codigo = dmo_codmat) else '' end tmo_descripcion,
cargo, abono,saldo,mov_fecha_cobro,@saldo saldo_imp ,nombre

from
(
select uni_nombre "Universidad", per_carnet "Carnet", per_apellidos_nombres "Alumno", 
'Factura' tipo,car_nombre "Carrera", reg_nombre "Regional", 
'0'+cast(cil_codcic as varchar) + '-' + cast(cil_anio as varchar) ciclo,cil_anio, cil_codcic,
mov_recibo,tmo_arancel,mov_fecha,mov_codban,
 tmo_descripcion,
dmo_cargo cargo, 
dmo_abono abono,
isnull(dmo_valor,0)+isnull(dmo_iva,0) valor, mov_codban banco,(dmo_cargo - dmo_abono) saldo,
mov_fecha_cobro, dmo_codmat , 
case when mov_codban = '0' then 'UTEC' when mov_codban = 'PX' and mov_puntoxpress=1 then 'Puntoxpress' when mov_codban = 'PX' and mov_puntoxpress=3 then 'Pago en Línea' else ban_nombre end nombre
from ra_per_personas 
left outer join ra_alc_alumnos_carrera on alc_codper = per_codigo
left outer join ra_pla_planes on pla_codigo = alc_codpla
left outer join ra_car_carreras on car_codigo = pla_codcar
left outer join ra_fac_facultades on fac_codigo = car_codfac
join ra_reg_regionales on reg_codigo = @regional
join ra_uni_universidad on uni_codigo = reg_coduni
join #mov on mov_codper = per_codigo
join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
join ra_cil_ciclo on cil_codigo = dmo_codcil
join ra_cic_ciclos on cic_codigo = cil_codcic
left join adm_ban_bancos on cast(ban_codigo as varchar(2))=mov_codban     -- cast(ban_codigo as varchar(2)) = cast(mov_codban as varchar(2)) 
where per_codigo = @codper
) t
order by substring(ciclo,4,4),substring(ciclo,1,2),mov_fecha,mov_fecha_cobro asc
drop table #mov

return