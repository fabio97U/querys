--[] Correcciones de notas RA
--    El estudiante realiza la solicitud de correcion desde el portal educativo, por periodo (ordinario, diferidos, actividades)
--        El director de escuela revisa que todo esta bien
--            Docente
--                Administracion academica autoriza el paso de la correcion

--    Duracion de documentos (hasta que se gradue), dimensionar?, POR ESTIMAR FECHA DE SALIDA,
--        Analizarlo y definir HU

--select * from web_ra_not_penot_periodonotas
--insert into web_ra_not_penot_periodonotas (penot_codigo, penot_tipo, penot_eval, penot_fechaini, penot_fechafin, penot_periodo)
--values 
--(25, 'Pregrado', 1, '2023-06-26 00:00:00.000', '2023-06-28 00:00:00.000', 'Correcion de Notas'),
--(26, 'Pregrado', 2, '2023-06-26 00:00:00.000', '2023-06-28 00:00:00.000', 'Correcion de Notas'),
--(27, 'Pregrado', 3, '2023-06-26 00:00:00.000', '2023-06-28 00:00:00.000', 'Correcion de Notas'),
--(28, 'Pregrado', 4, '2023-06-26 00:00:00.000', '2023-06-28 00:00:00.000', 'Correcion de Notas'),
--(29, 'Pregrado', 5, '2023-06-26 00:00:00.000', '2023-06-28 00:00:00.000', 'Correcion de Notas')

-- drop table ra_pcnot_periodo_correccion_notas
create table ra_pcnot_periodo_correccion_notas(
	pcnot_codigo int primary key identity (1, 1),
	pcnot_codtde int foreign key references ra_tde_TipoDeEstudio, 
	pcnot_codcil int foreign key references ra_cil_ciclo, 
	pcnot_codpon int foreign key references ra_pon_ponderacion, 

	pcnot_fecha_inicio datetime,
	pcnot_fecha_fin datetime,

	pcnot_fecha_creacion datetime default getdate(),
	pcnot_codusr_creacion int
)
go
-- select * from ra_pcnot_periodo_correccion_notas
insert into ra_pcnot_periodo_correccion_notas 
(pcnot_codtde, pcnot_codcil, pcnot_codpon, pcnot_fecha_inicio, pcnot_fecha_fin, pcnot_codusr_creacion)
values (1, 131, 1, '2023-09-18 12:30:00', '2023-09-30 23:00', 407), 
(1, 131, 2, '2023-09-18 12:30:00', '2023-10-07 23:00', 407)
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-10-08 15:30:09.891>
	-- Description: <Realiza el mantenimiento a la tabla "ra_pcnot_periodo_correccion_notas">
	-- =============================================
create or alter procedure sp_ra_pcnot_periodo_correccion_notas
	@opcion int = 0,
	@codpcnot int = 0,
	@codtde int = 0,
	@codcil int = 0,
	@codpon int = 0,
	@pcnot_fecha_inicio nvarchar(20) = '',
	@pcnot_fecha_fin nvarchar(20) = '',
	@codusr int = 0
as
begin
	
	set dateformat dmy

	DECLARE @usuario varchar(50) = '', @registro varchar(1000) = ''
	select @usuario = usr_usuario from adm_usr_usuarios where usr_codigo = @codusr
	declare @fecha_aud datetime = getdate()

	if @opcion = 0
	begin
		-- exec dbo.sp_ra_pcnot_periodo_correccion_notas @opcion = 0, @codtde = 1
		select pcnot_codigo 'codpcnot', tde_nombre, concat('0', cil_codcic, '-', cil_anio) 'ciclo', pcnot_codpon 'evaluacion', pcnot_fecha_inicio, pcnot_fecha_fin
		from ra_pcnot_periodo_correccion_notas p
			inner join ra_cil_ciclo on pcnot_codcil = cil_codigo
			inner join ra_tde_TipoDeEstudio on pcnot_codtde = tde_codigo
		where getdate() between pcnot_fecha_inicio and pcnot_fecha_fin and pcnot_codtde = @codtde
	end

	if @opcion = 1
	begin
		-- exec dbo.sp_ra_pcnot_periodo_correccion_notas @opcion = 1, @codtde = 1, @codcil = 131
		select pcnot_codigo 'codpcnot', tde_nombre, concat('0', cil_codcic, '-', cil_anio) 'ciclo', pcnot_codpon 'evaluacion', pcnot_fecha_inicio, pcnot_fecha_fin
		from ra_pcnot_periodo_correccion_notas p
			inner join ra_cil_ciclo on pcnot_codcil = cil_codigo
			inner join ra_tde_TipoDeEstudio on pcnot_codtde = tde_codigo
		where pcnot_codtde = @codtde and pcnot_codcil = @codcil
		order by pcnot_codigo desc
	end

	if @opcion = 2
	begin
		
		if (@pcnot_fecha_inicio >= @pcnot_fecha_fin)
		begin
			select 0 'codpcnot', 'La fecha de hasta no puede ser mayor o igual a la desde: ' + cast(@pcnot_fecha_inicio as varchar(30)) + ' > ' + cast(@pcnot_fecha_fin as varchar(30))  'res'
		end

		if not exists (select 1 from ra_pcnot_periodo_correccion_notas where pcnot_codcil = @codcil and pcnot_codtde = @codtde and pcnot_codpon = @codpon)
		begin
			insert into ra_pcnot_periodo_correccion_notas (pcnot_codtde, pcnot_codcil, pcnot_codpon, pcnot_fecha_inicio, pcnot_fecha_fin, pcnot_codusr_creacion)
			values (@codtde, @codcil, @codpon, @pcnot_fecha_inicio, @pcnot_fecha_fin, @codusr)
			select @registro = concat('@codtde ', @codtde, '@codcil ', @codcil, '@codpon ', @codpon, '@pcnot_fecha_inicio ', @pcnot_fecha_inicio, '@pcnot_fecha_fin ', @pcnot_fecha_fin, '@codusr ', @codusr)
			
			exec auditoria_del_sistema 'ra_pcnot_periodo_correccion_notas','I', @usuario, @fecha_aud, @registro
			select @@IDENTITY 'codpcnot', 'Creado' 'res'
		end
		else
		begin
			select 0 'codpcnot', 'Periodo ya existe' 'res'
		end
	end

	if @opcion = 3
	begin
		if (@pcnot_fecha_inicio >= @pcnot_fecha_fin)
		begin
			select 0 'codpcnot', 'La fecha de hasta no puede ser mayor o igual a la desde: ' + cast(@pcnot_fecha_inicio as varchar(30)) + ' > ' + cast(@pcnot_fecha_fin as varchar(30))  'res'
			return
		end

		select @registro = '@codpcnot ' + cast(@codpcnot as varchar(30))+ ' @pcnot_fecha_inicio ' + cast(@pcnot_fecha_inicio as varchar(30)) + ', @pcnot_fecha_fin ' + cast(@pcnot_fecha_inicio as varchar(30))

		update ra_pcnot_periodo_correccion_notas set pcnot_fecha_inicio = @pcnot_fecha_inicio, pcnot_fecha_fin = @pcnot_fecha_fin
		where pcnot_codigo = @codpcnot

		exec auditoria_del_sistema 'ra_pcnot_periodo_correccion_notas','U', @usuario, @fecha_aud, @registro
	end

end

-- drop table ra_scornot_solictud_correccion_nota
create table ra_scornot_solictud_correccion_nota (
	scornot_codigo int primary key identity (1, 1),
	scornot_codpcnot int foreign key references ra_pcnot_periodo_correccion_notas,
	scornot_codper int foreign key references ra_per_personas,
	scornot_codnot int foreign key references ra_not_notas,
	scornot_nota_actual real,
	scornot_nota_solicitada real,
	scornot_comentario_estudiante varchar(2048) null,

	scornot_estado_director_escuela varchar(5) not null default 'PEN',-- 'DEN': denegado, 'PEN': Pendiente, 'APR': Aprobado
	scornot_fecha_revision_director_escuela datetime null,
	scornot_codusr_director_escuela int null,
	scornot_comentario_director_escuela varchar(2048) null,

	scornot_estado_docente varchar(5) not null default 'PEN',-- 'DEN': denegado, 'PEN': Pendiente, 'APR': Aprobado
	scornot_fecha_revision_docente datetime null,
	scornot_codemp_docente int null,
	scornot_comentario_docente varchar(2048) null,

	scornot_estado_administracion_academica varchar(5) not null default 'PEN',-- 'DEN': denegado, 'PEN': Pendiente, 'APR': Aprobado
	scornot_fecha_revision_administracion_academica datetime null,
	scornot_codusr_administracion_academica int null,
	scornot_comentario_administracion_academica varchar(2048) null,

	scornot_activo bit default 1,

	scornot_fecha_creacion datetime default getdate(),
	scornot_codusr_creacion int
)
go
-- select * from ra_scornot_solictud_correccion_nota

-- drop table ra_doccornot_documentos_correccion_nota
create table ra_doccornot_documentos_correccion_nota (
	doccornot_codigo int primary key identity (1, 1),
	doccornot_codscornot int foreign key references ra_scornot_solictud_correccion_nota,
	doccornot_link_documento varchar(500),
	doccornot_estado varchar(5) not null default 'PEN',-- 'DEN': denegado, 'PEN': Pendiente, 'APR': Aprobado
	doccornot_cargado_por varchar(5) not null default 'EST',--EST: Estudiante, DIR: Director, DOC: Docente, AA: Administracion Academica
	doccornot_comentario_documento varchar(1024) null,

	doccornot_fecha_creacion datetime default getdate()
)
go
-- select * from ra_doccornot_documentos_correccion_nota

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-09-20 13:50:01.657>
	-- Description: <Realiza el mantenimiento a todo el flujo de correcion de notas>
	-- =============================================
	-- exec dbo.sp_correccion_notas 1, 168640
create or alter procedure sp_correccion_notas
	@opcion int = 0,
	@codper int = 0,
	@codcil int = 0,
	@codtde int = 1,--pregrado por defecto
	@codmai int = 0,
	@codpon int = 0, 
	@codnot int = 0,
	@codpcnot int = 0,
	@codscornot int = 0,
	@nota_actual real = 0,
	@nota_solicitada real = 0,
	@comentario varchar(2048) = '',
	@url_evidencias varchar(500) = '',
	@codusr int = 0,
	@cargado_por varchar(5) = '',--EST: Estudiante, DIR: Director, DOC: Docente, AA: Administracion Academica
	@estado varchar(6) = '',--'DEN': denegado, 'PEN': Pendiente, 'APR': Aprobado

	@fecha_desde nvarchar(12) = '', 
    @fecha_hasta nvarchar(12) = '',
	@txt_buscar varchar(125) = ''
as
begin
	
	set dateformat dmy
	select @codpcnot = pcnot_codigo
	from ra_pcnot_periodo_correccion_notas where pcnot_codigo in (
		select p.pcnot_codigo from ra_pcnot_periodo_correccion_notas p
		where getdate() between pcnot_fecha_inicio and pcnot_fecha_fin
			and pcnot_codtde = @codtde and pcnot_codpon = @codpon
	)
	declare @correo_para varchar(200) = ''

	if @opcion = 0 --periodo de correcion de notas activo
	begin
		-- exec dbo.sp_correccion_notas @opcion = 0, @codtde = 1
		select pcnot_codigo, pcnot_codtde, pcnot_codcil, pcnot_codpon, pcnot_fecha_inicio, pcnot_fecha_fin, 
			pcnot_fecha_creacion, pcnot_codusr_creacion 
		from ra_pcnot_periodo_correccion_notas where pcnot_codigo in (
			select p.pcnot_codigo from ra_pcnot_periodo_correccion_notas p
			where getdate() between pcnot_fecha_inicio and pcnot_fecha_fin
				and pcnot_codtde = @codtde
		)
	end

	if @opcion = 1
	begin
		-- exec dbo.sp_correccion_notas @opcion = 1, @codper = 168640
		select per_carnet, per_nombres_apellidos from ra_per_personas where per_codigo = @codper
	end

	if @opcion = 2 -- Materias inscritas del estudiante
	begin
		-- exec dbo.sp_correccion_notas @opcion = 2, @codper = 168640, @codcil = 131
		select 0 'mai_codigo', '*Seleccione*' 'materia'
		union all
		select mai_codigo, concat(rtrim(mat_codigo), ' ', rtrim(mat_nombre), ' Sec. ',hpl_descripcion) 'materia'
		from ra_ins_inscripcion
			inner join ra_mai_mat_inscritas on mai_codins = ins_codigo 
			inner join ra_per_personas on per_codigo = ins_codper
			inner join ra_hpl_horarios_planificacion on mai_codhpl = hpl_codigo
			inner join ra_mat_materias on mat_codigo = hpl_codmat
			inner join ra_alc_alumnos_carrera on alc_codper = per_codigo and mai_codpla = alc_codpla
		where ins_codper = @codper and ins_codcil = @codcil and mai_estado = 'I'
	end

	if @opcion = 3 -- Nota actual de la materia
	begin
		-- exec dbo.sp_correccion_notas @opcion = 3, @codper = 168640, @codmai = 5643892, @codpon = 5
		declare @tbl_aranceles table (codtmo int)
		declare @not_codigo int = 0, @not_nota real = 0.0, @bandera bit, @codhpl int = 0
		declare @estaba_solvente bit = 0, @tiene_autorizacion_aa bit = 0, @tiene_prorroga bit = 0, @permitido bit = 1
		declare @msj varchar(100) = 'ok'
		
		insert into @tbl_aranceles (codtmo)
		select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO' and are_cuota = (@codpon + 1) and tde_nombre = 'Pre grado'

		select @not_codigo = not_codigo, @not_nota = not_nota, @bandera = bandera, @codhpl = mai_codhpl, @codcil = pom_codcil
		from ra_not_notas
			inner join ra_pom_ponderacion_materia on not_codpom = pom_codigo
			inner join ra_mai_mat_inscritas on not_codmai = mai_codigo
		where not_codmai = @codmai and pom_codpon = @codpon

		declare @dias_val nvarchar(20) = '', @hora_val nvarchar(10) = '', @fecha_limite_pago datetime
		select @dias_val=(CASE WHEN isnull(hpl_lunes, 'N') = 'S' THEN 'L-' ELSE '' END + CASE WHEN isnull(hpl_martes,'N') = 'S' THEN 'M-' ELSE '' END + CASE WHEN isnull(hpl_miercoles, 'N') = 'S' THEN 'Mi-' ELSE '' END + CASE WHEN isnull(hpl_jueves, 'N') 
		= 'S' THEN 'J-' ELSE '' END + CASE WHEN isnull(hpl_viernes, 'N') = 'S' THEN 'V-' ELSE '' END + CASE WHEN isnull(hpl_sabado, 'N') = 'S' THEN 'S-' ELSE '' END + CASE WHEN isnull(hpl_domingo, 'N') = 'S' THEN 'D-' ELSE '' END),
		@hora_val=substring(man_nomhor,1,5)
		from ra_hpl_horarios_planificacion 
			join ra_man_grp_hor on man_codigo = hpl_codman
		where hpl_codigo = @codhpl

		select @fecha_limite_pago = caa_fecha from dbo.web_ra_caa_calendario_acad where caa_dias = @dias_val and caa_hora = @hora_val and caa_evaluacion = @codpon
		print '@fecha_limite_pago ' + cast(@fecha_limite_pago as varchar(12))

		select @estaba_solvente = count (1) from col_dmo_det_mov inner join col_mov_movimientos on dmo_codmov = mov_codigo where mov_codper = @codper and dmo_codcil = @codcil and dmo_codtmo in (select codtmo from @tbl_aranceles) and convert(varchar(10), mov_fecha_real_pago ,103) <= @fecha_limite_pago and mov_estado <> 'A'
		select @tiene_prorroga = count(1) from ra_pra_prorroga_acad  inner join ra_poo_prorroga_otorgar on pra_codpoo = poo_codigo where pra_codper = @codper and pra_codcil = @codcil and poo_codpon = @codpon
		select @tiene_autorizacion_aa = count(1) from ra_aan_activar_alumno_notas where aan_codper = @codper and aan_codhpl = @codhpl and aan_periodo = @codpon

		if (@estaba_solvente = 0 and @tiene_autorizacion_aa = 0 and @tiene_prorroga = 0)
		begin
			set @msj = 'Corrección no permitida porque no estaba solvente o no tenía prorroga'
			set @permitido = 0
		end

		select @codhpl 'codhpl', @not_codigo 'not_codigo', @not_nota 'not_nota', @tiene_prorroga 'tiene_prorroga', @tiene_autorizacion_aa 'tiene_autorizacion_aa', 
			@estaba_solvente 'estaba_solvente', @bandera 'bandera', @msj 'msj', @permitido 'permitido'
	end

	if @opcion = 4 -- Inserta la solicitud del estudiante, pasa 
	begin
		-- exec dbo.sp_correccion_notas @opcion = 4, @codper = 168640, @codtde = 1, @codpon = 2, @codnot = 18190204, @nota_actual = 3, @nota_solicitada = 10, @comentario = 'por favor corregir', @codusr = 378
		if @codpcnot = 0
		begin
			select -1 'res', 'El periodo de corrección de notas no está habilitado' 'texto', 0 'codigo', '' 'correo_para'
			return
		end

		if exists(select 1 from vst_correciones_nota where codnot = @codnot and estado_general not like '%DENEGADO%' and activo = 1)
		begin
			select -1 'res', 'Ya existe una solicitud de corrección de nota (solicitado el ' 
				+ convert(varchar(12), scornot_fecha_creacion, 103) + ' ' + convert(varchar, scornot_fecha_creacion, 8) + ', de ' 
				+ cast(scornot_nota_actual as varchar(3)) + ' a ' 
				+ cast(scornot_nota_solicitada as varchar(5)) +') para la materia en la evaluacion seleccionada' 'texto', scornot_codigo 'codigo', '' 'correo_para'
			from ra_scornot_solictud_correccion_nota where scornot_codnot = @codnot
			return
		end

		insert into ra_scornot_solictud_correccion_nota 
		(scornot_codpcnot, scornot_codper, scornot_codnot, scornot_nota_actual, scornot_nota_solicitada, scornot_comentario_estudiante, scornot_codusr_creacion)
		select @codpcnot, @codper, @codnot, @nota_actual, @nota_solicitada, @comentario, @codusr

		select @codscornot = @@IDENTITY
		insert into ra_doccornot_documentos_correccion_nota (doccornot_codscornot, doccornot_link_documento)
		values (@codscornot, @url_evidencias)

		select @correo_para = responsables_escuela from vst_correciones_nota where codscornot = @codscornot
		
		set @correo_para = 'william.colocho@utec.edu.sv'
		select 1 'res', 'Solicitud de corrección de notas registrada con éxito' 'texto', @codscornot 'codigo', @correo_para 'correo_para'

	end

	if @opcion = 5 -- solicitudes por rango de fecha, usado desde empresarial
	begin
		-- exec dbo.sp_correccion_notas @opcion = 5, @fecha_desde = '01/10/2023', @fecha_hasta = '08/10/2023', @txt_buscar = '', @codusr = 407
		declare @tbl_rol table (rol varchar(50))
		declare @codesc_revisor int = 0, @rol varchar(50)
		insert into @tbl_rol (rol)
		exec dbo.sp_verificar_rol_usuario @codusr
		select @rol = rol from @tbl_rol

		select * from vst_correciones_nota 
		where convert(date, fecha_solicitud, 103) between convert(date, @fecha_desde, 103) and convert(date, @fecha_hasta, 103)
			and (
				ltrim(rtrim(carnet)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end
				or ltrim(rtrim(codscornot)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end
			)
			--and codesc = case when @rol = 'ADMINISTRADORES'then codesc else @codesc_revisor end
		order by codscornot desc
	end

	if @opcion = 6 -- actualizacion de director, docente y administracion academica
	begin
		-- exec dbo.sp_correccion_notas @opcion = 6, @codscornot = 1, @estado = 'APR', @codusr = 378, @comentario = 'Aprobado', @url_evidencias = '', @cargado_por = 'DOC'
		-- exec dbo.sp_correccion_notas @opcion = 6, @codscornot = 2, @estado = 'APR', @codusr = 378, @comentario = 'Aprobado', @url_evidencias = '', @cargado_por = 'AA', @nota_solicitada = 10, @codnot = 1

		-- DIR: Director, DOC: Docente, AA: Administracion Academica
		if @cargado_por = 'DIR'
		begin
			update ra_scornot_solictud_correccion_nota set 
				scornot_estado_director_escuela = @estado,
				scornot_fecha_revision_director_escuela = getdate(),
				scornot_codusr_director_escuela = @codusr,
				scornot_comentario_director_escuela = @comentario
			where scornot_codigo = @codscornot
		end

		if @cargado_por = 'DOC'
		begin
			update ra_scornot_solictud_correccion_nota set 
				scornot_estado_docente = @estado,
				scornot_fecha_revision_docente = getdate(),
				scornot_codemp_docente = @codusr,
				scornot_comentario_docente = @comentario
			where scornot_codigo = @codscornot
		end

		if @cargado_por = 'AA'
		begin
			update ra_scornot_solictud_correccion_nota set 
				scornot_estado_administracion_academica = @estado,
				scornot_fecha_revision_administracion_academica = getdate(),
				scornot_codusr_administracion_academica = @codusr,
				scornot_comentario_administracion_academica = @comentario
			where scornot_codigo = @codscornot

			update ra_not_notas set not_nota = @nota_solicitada where not_codigo = @codnot
		end

		insert into  ra_doccornot_documentos_correccion_nota(doccornot_codscornot, doccornot_link_documento, doccornot_estado, doccornot_cargado_por, doccornot_comentario_documento)
		values (@codscornot, @url_evidencias, @estado, @cargado_por, @comentario)

		declare @estado_actual varchar(50) = ''
		select @estado_actual = estado_general, @correo_para = responsables_escuela from vst_correciones_nota where codscornot = @codscornot

		set @correo_para = 'william.colocho@utec.edu.sv'
		select 1 'res', 'Solicitud de corrección de notas actualizada con éxito' 'texto', @codscornot 'codigo', @estado_actual 'estado_actual', @correo_para 'correo_para'
	end

end
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-10-01 09:50:43.343>
	-- Description: <Vista de correciones de nota>
	-- =============================================
	-- select * from vst_correciones_nota where codper = 168640
create or alter view dbo.vst_correciones_nota
as
	select scornot_codigo 'codscornot', 
		case when scornot_activo = 0 then 'CANCELADO' 
		when scornot_estado_director_escuela = 'APR' and scornot_estado_docente = 'APR' and scornot_estado_administracion_academica = 'APR' then 'APROBADO NOTA CORREGIDA'
		when scornot_estado_director_escuela = 'DEN' then 'DENEGADO POR DIRECTOR'
		when scornot_estado_docente = 'DEN' then 'DENEGADO POR DOCENTE'
		when scornot_estado_administracion_academica = 'DEN' then 'DENEGADO POR ADMINISTRACION'
		when scornot_estado_director_escuela = 'PEN' then 'EN REVISION POR DIRECTOR'
		when scornot_estado_docente = 'PEN' then 'EN REVISION POR DOCENTE'
		when scornot_estado_administracion_academica = 'PEN' then 'EN REVISION POR ADMINISTRACION'
		else 'EN REVISION' end 'estado_general', 

		case when scornot_estado_director_escuela = 'APR' and scornot_estado_docente = 'APR' and scornot_estado_administracion_academica = 'APR' then 'APROBADO NOTA CORREGIDA' 
		when scornot_estado_director_escuela = 'APR' and scornot_estado_docente = 'PEN' then 'PENDIENTE REVISION DOCENTE'
		when scornot_estado_director_escuela = 'APR' and scornot_estado_docente = 'APR' then 'APROBADO POR DOCENTE'
		else 'EN REVISION POR OTRA UNIDAD' end 'estado_docente_texto',

		tde_nombre 'tipo_estudio', pcnot_codigo 'codpcnot', cil_codigo 'codcil', concat('0', cil_codcic, '-', cil_anio) 'ciclo', 
		fac_codigo 'codfac', fac_nombre 'facultad', esc_codigo 'codesc', esc_nombre 'escuela', hpl_codigo 'codhpl',  mat_codigo 'codmat',mat_nombre 'materia', hpl_descripcion 'seccion',
		emp_codigo 'codemp', emp_nombres_apellidos 'docente', emp_email_institucional 'correo_docente', pla_alias_carrera 'carrera', per_codigo 'codper', per_carnet 'carnet', per_nombres_apellidos 'estudiante', 
		pcnot_codpon 'evaluacion', scornot_codnot 'codnot' , scornot_nota_actual 'nota_original', scornot_nota_solicitada 'nota_solicitada', not_nota 'nota_actual',
		scornot_comentario_estudiante 'comentario_estudiante', (select doccornot_link_documento from ra_doccornot_documentos_correccion_nota where doccornot_codscornot = scornot.scornot_codigo and doccornot_cargado_por = 'EST') 'evidencia_estudiante',

		esc_correos_responsables_ms_teams 'responsables_escuela',
		scornot_estado_director_escuela 'estado_director_escuela', scornot_comentario_director_escuela 'comentario_director_escuela', scornot_fecha_revision_director_escuela 'fecha_revision_director_escuela', (select top 1 doccornot_link_documento from ra_doccornot_documentos_correccion_nota where doccornot_codscornot = scornot.scornot_codigo and doccornot_cargado_por = 'DIR') 'evidencia_director_escuela',
		scornot_estado_docente 'estado_docente', scornot_comentario_docente 'comentario_docente', scornot_fecha_revision_docente 'fecha_revision_docente', (select top 1 doccornot_link_documento from ra_doccornot_documentos_correccion_nota where doccornot_codscornot = scornot.scornot_codigo and doccornot_cargado_por = 'DOC') 'evidencia_docente',
		scornot_estado_administracion_academica 'estado_administracion_academica', scornot_comentario_administracion_academica 'comentario_administracion_academica', scornot_fecha_revision_administracion_academica 'fecha_revision_administracion_academica', (select top 1 doccornot_link_documento from ra_doccornot_documentos_correccion_nota where doccornot_codscornot = scornot.scornot_codigo and doccornot_cargado_por = 'AA') 'evidencia_administracion_academica',
	
		scornot_activo 'activo', scornot_fecha_creacion 'fecha_solicitud',
		case 
		when scornot_fecha_revision_director_escuela is not null then scornot_fecha_revision_director_escuela 
		when scornot_fecha_revision_docente is not null then scornot_fecha_revision_docente
		when scornot_fecha_revision_administracion_academica is not null then scornot_fecha_revision_administracion_academica
		else scornot_fecha_creacion end 'ultima_fecha_revision'
	from ra_scornot_solictud_correccion_nota scornot
		inner join ra_pcnot_periodo_correccion_notas on pcnot_codigo = scornot_codpcnot
		inner join ra_cil_ciclo on pcnot_codcil = cil_codigo
		inner join ra_per_personas on per_codigo = scornot_codper
		inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
		inner join ra_pla_planes on alc_codpla = pla_codigo
		inner join ra_tde_TipoDeEstudio on pcnot_codtde = tde_codigo
		inner join ra_not_notas on scornot_codnot = not_codigo
		inner join ra_mai_mat_inscritas on not_codmai = mai_codigo
		inner join ra_hpl_horarios_planificacion on mai_codhpl = hpl_codigo
		inner join ra_mat_materias on hpl_codmat = mat_codigo
		inner join ra_esc_escuelas on hpl_codesc = esc_codigo
		inner join ra_fac_facultades on esc_codfac = fac_codigo
		inner join pla_emp_empleado on hpl_codemp = emp_codigo
