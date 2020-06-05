--select * from adm_opm_opciones_menu where opm_codigo = 334

--alter table ra_rei_reingreso_personas add rei_fecha_creacion datetime default getdate()

--update adm_opm_opciones_menu set opm_link = 'logo.html', opm_nombre = 'Reingresos' where opm_codigo = 334

--insert into adm_opm_opciones_menu (opm_codigo, opm_nombre, opm_link, opm_opcion_padre, opm_orden, opm_sistema)
--values (1064, 'Re - Ingreso', 'reingreso.aspx', 334, 1, 'U'),
--(1065, 'Contactar Alumno de Reingreso', 'Reingreso_Contactar_Alumno.aspx', 334, 2, 'U'),
--(1066, 'Solicitudes de Reingreso', 'rei_solicitud_reingreso.aspx', 334, 3, 'U')

--create type tbl_mat_pensum as table (mai_codmat varchar(50), matnom varchar(150), ciclo int, nf float)

-- =============================================
-- Author:      <Fabio>
-- Create date: <2020-05-14 10:06:59.000>
-- Description: <Function para determinar si un alumno tiene que cambiar de plan>
-- =============================================
alter function fn_cambiar_plan_alumno (
	@codper int,
	@tbl_mat_aprobadas tbl_mat_pensum readonly
)
returns int as
begin
	declare @cambiar_plan bit = 0--0: No tiene que cambiar de plan, 1: Tiene que cambiar de plan
	declare /*@codper int,*/ @per_anio_ingreso int, @codpla int, @mat_no_aprobadas int = 0

	select @per_anio_ingreso = per_anio_ingreso, @codpla = alc_codpla
	from ra_per_personas 
	inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
	where per_codigo = @codper
	if (@per_anio_ingreso < 2016)
	begin
		select @mat_no_aprobadas = count(1) from @tbl_mat_aprobadas where ciclo <= 5 and isnull(nf, 0) = 0 --Si el count(1) da 0, No tiene que cambiar de plan
		if @mat_no_aprobadas > 0
			set @cambiar_plan = 1
	end
	return @cambiar_plan
end
go

--drop table ra_rei_contactar_alumno
create table ra_rei_contactar_alumno(
	rei_codigo int identity(1,1) primary key,
	rei_nombre nvarchar(75) not null,
	rei_apellido nvarchar(75) not null,
	rei_correo nvarchar(150) not null,
	rei_codcil int,
	rei_fecha datetime not null default getdate()
)
select * from ra_rei_contactar_alumno

--drop table ra_ttrei_tipo_tramite_reingreso
create table ra_ttrei_tipo_tramite_reingreso(
	ttrei_codigo int identity(1,1) primary key,
	ttrei_descripcion varchar(125),
	ttrei_fecha_creacion datetime default getdate()
)
insert into ra_ttrei_tipo_tramite_reingreso (ttrei_descripcion) values ('Quiero continuar en la misma carrera'), ('Deseo hacer cambio de carrera')
select * from ra_ttrei_tipo_tramite_reingreso

--drop table ra_csrei_contactar_solicitud_reingreso
create table ra_csrei_contactar_solicitud_reingreso(
	csrei_codigo int identity(1,1) primary key,
	csrei_carnet varchar(16),
	csrei_dui varchar(16),
	csrei_codcil int,
	csrei_codttrei int,
	csrei_codcar int,
	csrei_estado_solicitud varchar(1) default 'P',--P: Pendiente,
	csrei_descripcion_caso varchar(max),
	csrei_fecha_creacion datetime default getdate(),
	csrei_codusr_reviso_tramite int
)
select * from ra_csrei_contactar_solicitud_reingreso

--drop table ra_disr_datos_inmutables_solicitud_reingreso
create table ra_disr_datos_inmutables_solicitud_reingreso(
	disr_codigo int primary key identity (1, 1),
	disr_codcsrei int
	, dia int, mes varchar(12), anio int, per_apellidos_nombres varchar(125), carnet varchar(14), per_direccion varchar(255), per_telefono varchar(25), per_celular varchar(25), facultad varchar(50), carrera varchar(150), ciclo_retiro varchar(14), per_correo_electronico varchar(50), motivo_retiro_ciclo varchar(50)
	, saldo_pendiente_ciclo float, saldo_pendientes_anteriores float, matricula float, cuota float, num_cuotas int, biblioteca float, otros float
	, tot_mat_apro int, tot_mat_ins_ultimo_ciclo int, tot_mat_repro_ciclo int, tot_mat_apro_ciclo int, num_eva_realizadas_ultimo_ciclo int
	, titulo_bachiller varchar(12), partida_nacimiento varchar(12), fotografia varchar(12), paes varchar(12)
	, a_aprobado_reingreso char(1), f_retiro_extemporaneo__ciclo char(1), b_exoneracion_mora char(1), g_cambio_plan char(1), c_pago_por_abandono_ciclo char(1), h_descuento_cuotas char(1), porcentaje_ float, num_ciclos int, d_cambio_carrera char(1), j_pago_mora_regresar_su_carrera char(1), e_plan_pago char(1), resolucion_num_cuotas char(1), ciclo varchar(12)
	, resolucion_leyenda varchar(500)
)
select * from ra_disr_datos_inmutables_solicitud_reingreso

-- =============================================
-- Author:      <Fabio, Angel>
-- Create date: <2020-05-11 23:41:28.170>
-- Description: <Realiza el mantenimiento a la tabla "ra_rei_contactar_alumno" y muestra los datos de las solicitudes>
-- =============================================
-- sp_ra_rei_contactar_alumno 8, '11-0902-2015'
ALTER procedure [dbo].[sp_ra_rei_contactar_alumno]
	@opcion int = 0,
	@csrei_carnet varchar(16) = '',
	@rei_codigo int = '',
	@rei_nombre nvarchar(75) = '',
	@rei_apellido nvarchar(75) = '',
	@rei_correo nvarchar(150) = '',
	@rei_codcil int = '',
	@rei_fecha datetime = '',
	
	@csrei_dui varchar(16) = '',
	@csrei_codcil int = '',
	@csrei_codttrei int = '',
	@csrei_codcar int = '',
	@fecha_desde nvarchar(12) = '', 
	@fecha_hasta nvarchar(12) = '',
	
	@csrei_codigo int = 0,
	@csrei_descripcion_caso varchar(max) = '',
	@csrei_estado_solicitud varchar(1) = '',

	@txt_buscar varchar(500) = '',
	@csrei_codusr_reviso_tramite int = 0
as
begin
	set dateformat dmy
	declare @codper int

	if @opcion = 1 --Muestra las solicitudes echas por alumnos que no se recuerdan del carnet o dui
	begin
		select * from ra_rei_contactar_alumno
	end

	if @opcion = 2 -- Inserta la solicitud de reingreso si no recuerda el carnet o dui el estudiante, para la API
	begin
		if not exists (select 1 from ra_rei_contactar_alumno where rei_correo = @rei_correo and rei_codcil = @rei_codcil)
		begin
			insert into ra_rei_contactar_alumno (rei_nombre, rei_apellido, rei_correo, rei_codcil)
			values (@rei_nombre, @rei_apellido, @rei_correo, @rei_codcil)
			select scope_identity()
		end
		else
			select -1 -- Ya tiene la solicitud de reingreso
	end

	if @opcion = 3 --Devuelve la data de las carreras activas, para la API
	begin
		select car_codigo, car_nombre, 
		isnull((select 1 from ra_car_carreras c where c.car_codigo = car.car_codigo and car_nombre like '%no presencial%'), 0) 'car_virtual'
		from ra_car_carreras as car 
		inner join rei_mipc_materias_impartir_por_ciclo on mipc_codcar = car_codigo
		where car_estado = 'A' and car_codtde = 1 and mipc_codcil = @csrei_codcil and mipc_mostrar = 1
		order by 3, 2
	end

	if @opcion = 4 --Inserta la solicitud de reingreso del estudiante luego de realizar todos los pasos en el portal de reingresos, para la API
	begin
		if @csrei_carnet != ''
			select @codper = per_codigo from ra_per_personas  where per_carnet = @csrei_carnet
		else if @csrei_dui != ''
			select @codper = per_codigo from ra_per_personas  where per_dui = @csrei_dui

		if not exists (select 1 from ra_csrei_contactar_solicitud_reingreso 
		where ((csrei_carnet = @csrei_carnet and csrei_carnet != '') or (csrei_dui = @csrei_dui and csrei_dui != '')) 
		and csrei_codcil = @csrei_codcil and csrei_codttrei = @csrei_codttrei and csrei_codcar = @csrei_codcar)
		begin
			declare @codcsrei int
			insert into ra_csrei_contactar_solicitud_reingreso (csrei_carnet, csrei_dui, csrei_codcil, csrei_codttrei, csrei_codcar)
			values (@csrei_carnet, @csrei_dui, @csrei_codcil, @csrei_codttrei, @csrei_codcar)
			select @codcsrei = scope_identity()

			exec dbo.rep_generar_reporte_reingreso 2, @codcsrei, @codper, 1
			select @codcsrei
		end
		else
		begin
			select -1 -- Ya tiene la solicitud de reingreso
		end
	end

	if @opcion = 5
	Begin
		select a.est_estado,a.est_descripcion,b.rei_apellido,b.rei_nombre,b.rei_correo,
		'0'+cast(cil_codcic as varchar)+'-'+cast(cil_anio as varchar) as Ciclo,a.est_fecha 
		from ra_est_contactar_reingreso a
		inner join ra_rei_contactar_alumno b
		on b.rei_codigo = a.est_reicod
		inner join ra_cil_ciclo c
		on b.rei_codcil = c.cil_codigo
		order by a.est_reicod,a.est_fecha desc

	End

	if @opcion = 6 -- Devuelve la data de las solicitudes de reingreso realizadas desde @fecha_desde hasta @fecha_hasta
	begin
		select * from (
			select csrei_codigo, csrei_carnet, csrei_dui, per_carnet, per_apellidos_nombres, csrei_codcil, ciclo, csrei_codttrei, 
			ttrei_descripcion, csrei_codcar, car_nombre, car_antigua, plan_antiguo, csrei_estado_solicitud, 
			case csrei_estado_solicitud when 'P' then 'Pendiente' when 'R' then 'Revisado' else 'Finalizada' end estado, 
			csrei_descripcion_caso, csrei_fecha_creacion, usuario
			from (
				select csrei_codigo, csrei_carnet, csrei_dui, per_carnet, per_apellidos_nombres, 
				csrei_codcil, concat(' 0', cil_codcic,cil_anio, ' ') 'ciclo',
				csrei_codttrei, ttrei_descripcion, 
				csrei_codcar, car_nombre, 
				(select pla_alias_carrera from ra_alc_alumnos_carrera left join ra_pla_planes on pla_codigo = alc_codpla where alc_codper = per.per_codigo) 'car_antigua',
				(select pla_nombre from ra_alc_alumnos_carrera left join ra_pla_planes on pla_codigo = alc_codpla where alc_codper = per.per_codigo) 'plan_antiguo',
				csrei_estado_solicitud, csrei_descripcion_caso, convert(nvarchar(12), csrei_fecha_creacion, 103) csrei_fecha_creacion,
				usr_usuario 'usuario'
				from ra_csrei_contactar_solicitud_reingreso
				left join ra_per_personas as per on ((per_carnet = csrei_carnet and csrei_carnet != '') or (per_dui = csrei_dui and csrei_dui != ''))
				inner join ra_cil_ciclo on cil_codigo = csrei_codcil
				inner join ra_ttrei_tipo_tramite_reingreso on ttrei_codigo = csrei_codttrei
				left join ra_car_carreras on car_codigo = csrei_codcar
				left join adm_usr_usuarios on usr_codigo = csrei_codusr_reviso_tramite
				where convert(nvarchar(12), csrei_fecha_creacion, 103) between @fecha_desde and @fecha_hasta
			) t2
		) t
		where (
			ltrim(rtrim(csrei_carnet)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(csrei_dui)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(per_apellidos_nombres)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(ttrei_descripcion)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(car_nombre)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(car_antigua)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(plan_antiguo)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(estado)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(usuario)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(csrei_fecha_creacion)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		order by csrei_codigo
	end

	if @opcion = 7 -- Realiza el update a la tabla "ra_csrei_contactar_solicitud_reingreso", se activa cuando cambian el estado de la solicitud
	begin
		update ra_csrei_contactar_solicitud_reingreso set csrei_estado_solicitud = @csrei_estado_solicitud, csrei_descripcion_caso = @csrei_descripcion_caso,
		csrei_codusr_reviso_tramite = @csrei_codusr_reviso_tramite
		where csrei_codigo = @csrei_codigo

		declare @usuario varchar(25)
		select @usuario = usr_usuario from adm_usr_usuarios where usr_codigo = @csrei_codusr_reviso_tramite
		declare @fecha_aud datetime,@registro varchar(200)
		set @fecha_aud = getdate()
		select @registro = concat('codcsrei:',@csrei_codigo,',estado:', @csrei_estado_solicitud, ',descripcion:', @csrei_descripcion_caso)
		exec auditoria_del_sistema 'ra_csrei_contactar_solicitud_reingreso','U', @usuario, @fecha_aud, @registro
	end

	if @opcion = 8 --Retorna 1 si tiene que cambiar de plan, 0 si no tiene que cambiar de plan, para la API
	begin
		declare @per_anio_ingreso int, @codpla int, @mat_no_aprobadas int = 0
		declare @tbl_mat_aprobadas as tbl_mat_pensum
		if @csrei_carnet != ''
		begin
			select @codper = per_codigo, @per_anio_ingreso = per_anio_ingreso, @codpla = alc_codpla
			from ra_per_personas 
			inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
			where per_carnet = @csrei_carnet
		end
		else if @csrei_dui != ''
		begin
			select @codper = per_codigo, @per_anio_ingreso = per_anio_ingreso, @codpla = alc_codpla
			from ra_per_personas 
			inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
			where per_dui = @csrei_dui
		end
		insert into @tbl_mat_aprobadas (mai_codmat, matnom, ciclo, nf)
		exec dbo.web_ptl_pensum @codper
		select dbo.fn_cambiar_plan_alumno(@codper, @tbl_mat_aprobadas)
	end

end
GO
select * from ra_rei_reingreso_personas order by rei_codigo desc

-- =============================================
-- Author:      <Fabio>
-- Create date: <2020-05-13 22:32:10.847>
-- Description: <Genera el reporte "Solicitud de Reingreso">
-- =============================================
-- rep_generar_reporte_reingreso 1, 1, 0, 0, 0		-- Devuelve los datos del reporte originales de la solicitud
-- rep_generar_reporte_reingreso 2, 1, 0, 0, 0		-- Devuelve los datos del reporte dinamicamente, llamado desde "rei_solicitud_reingreso.aspx"
-- rep_generar_reporte_reingreso 2, 0, 177470, 0, 123	-- Devuelve los datos del reporte dinamicamente, llamado desde "Formareingreso.aspx"
ALTER procedure [dbo].[rep_generar_reporte_reingreso]
	@opcion int = 0,
	@csrei_codigo int = 0,
	@codper int = 0,
	@insertar_datos_inmutables int = 0,
	@codcil_reingreso int = 0
as
begin
	set language Spanish
	set dateformat dmy
	 if @opcion = 1 -- Genera el reporte original "Solicitud de Reingreso" que el alumno creo en la solicitud reingreso
	 begin
		select disr_codigo, disr_codcsrei csrei_codigo, dia, mes, anio, per_apellidos_nombres, carnet, per_direccion, per_telefono, per_celular, facultad, 
		carrera, ciclo_retiro, per_correo_electronico, motivo_retiro_ciclo, saldo_pendiente_ciclo, saldo_pendientes_anteriores, 
		matricula, cuota, num_cuotas, biblioteca, otros, tot_mat_apro, tot_mat_ins_ultimo_ciclo, tot_mat_repro_ciclo, tot_mat_apro_ciclo, 
		num_eva_realizadas_ultimo_ciclo, titulo_bachiller, partida_nacimiento, fotografia, paes, a_aprobado_reingreso, f_retiro_extemporaneo__ciclo,
		b_exoneracion_mora, g_cambio_plan, c_pago_por_abandono_ciclo, h_descuento_cuotas, porcentaje_, num_ciclos, d_cambio_carrera, j_pago_mora_regresar_su_carrera, 
		e_plan_pago, resolucion_num_cuotas, ciclo, resolucion_leyenda,
		'' concepto
		from ra_disr_datos_inmutables_solicitud_reingreso where disr_codcsrei = @csrei_codigo
	 end

	 if @opcion = 2 -- Genera el reporte "Solicitud de Reingreso" ya con las revisiones correspondientes
	 begin
		--11-7033-2014, 199388 tiene que cambiar de plan
		--11-0902-2015, 180592 no tiene que cambiar de plan
		--set @codper = 180592
		declare @codcil_solicito_reingreso int = 0
		
		if @codper = 0 and @codcil_reingreso = 0 -- se esta llamando desde el formulario "rei_solicitud_reingreso.aspx"
			select @codper = per_codigo, @codcil_solicito_reingreso = csrei_codcil from ra_csrei_contactar_solicitud_reingreso inner join ra_per_personas on ((per_carnet = csrei_carnet and csrei_carnet != '') or (per_dui = csrei_dui and csrei_dui != '')) where csrei_codigo = @csrei_codigo
		else if @codper <> 0 and @insertar_datos_inmutables = 0 -- Se esta llamando desde el formulario "Formareingreso.aspx"
			set @codcil_solicito_reingreso = @codcil_reingreso

		declare @carnet varchar(14) --= '11-0902-2015'

		-- Encabezado reporte
		declare /*@codper int = 0, */  @per_apellidos_nombres varchar(125), @per_direccion varchar(255), 
		@per_telefono varchar(25), @per_celular varchar(25), @facultad varchar(50), @carrera varchar(150), 
		@codcil_retiro int,@ciclo_retiro varchar(14),
		@per_correo_electronico varchar(50), @motivo_retiro_ciclo varchar(50), @per_saldo float/*SaldoPendienteGeneral*/, @per_saldo_ciclo float, /*SaldoPendienteCiclo*/@per_codvac int,
		@fecha_registro datetime = getdate(), @dia int, @mes varchar(12), @anio int

		/**/select @carnet = per_carnet, @per_apellidos_nombres= per_apellidos_nombres, @per_direccion = isnull(per_direccion, ''), 
		@per_telefono = per_telefono, @per_celular = per_celular, @facultad = fac_nombre, @carrera = car_nombre,
		@per_correo_electronico = isnull(per_email, per_email_opcional), @per_saldo = per_saldo, @per_codvac = per_codvac
		from ra_per_personas 
		inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
		inner join ra_pla_planes on pla_codigo = alc_codpla
		inner join ra_car_carreras on car_codigo = pla_codcar
		inner join ra_fac_facultades on fac_codigo = car_codfac
		where per_codigo = @codper

		select @codcil_retiro = max(ins_codcil) from ra_ins_inscripcion 
			inner join ra_cil_ciclo on cil_codigo = ins_codcil
			where ins_codper = @codper and cil_codcic <> 3

		/**/select @ciclo_retiro = concat('0', cil_codcic, '-', cil_anio) from ra_cil_ciclo
		where cil_codigo = @codcil_retiro

		/**/select top 1 @motivo_retiro_ciclo = pmr_motivo from ra_pmr_personas_motivo_re where pmr_codper = @codper and pmr_ciclo = @codcil_retiro

		-- Estado financiero
		/**/declare @saldo_pendiente_ciclo float = 0.0, @saldo_pendientes_anteriores float = @per_saldo,
		@matricula float = 0.0, @cuota float = 0.0, @num_cuotas int = 0, @biblioteca float = 0.0, @otros float = 0.0

		select @matricula = vac_ValorMatricula, @cuota = vac_ValorCuota, @num_cuotas = vac_CantCuota from ra_vac_valor_cuotas where vac_codigo = @per_codvac
		--INICIO: Sacar saldo pendiente
		declare @pagosRealizados float,  @pagosPendientes float, @cuotas float
		--exec web_coeca_consulta_estado_cuenta_alumnos 114949, 111
		declare @Pagos table (mov_fecha date, dmo_valor float, dmo_codcil int, tmo_arancel nvarchar(15), tmo_descripcion nvarchar(100), mov_codban int, 
			ban_nombre nvarchar(75), mov_lote int, mov_recibo int, mov_recibo_puntxpress nvarchar(50), mov_usuario nvarchar(50))
		insert into @Pagos (mov_fecha, dmo_valor, dmo_codcil, tmo_arancel, tmo_descripcion, mov_codban, ban_nombre, mov_lote, mov_recibo, mov_recibo_puntxpress, mov_usuario)
		exec web_coeca_consulta_estado_cuenta_alumnos @codper, @codcil_retiro
		if not exists(select 1 from @Pagos where tmo_arancel = 'R-05')
			set @pagosPendientes = 0
		else
		begin
			select @cuotas = dmo_valor, @pagosRealizados = count(1) from @Pagos 
			where tmo_descripcion like '%Cuota%' and tmo_arancel not in ('C-30') and dmo_valor > 0 and dmo_valor in (61, 75)
			group by dmo_valor

			set @pagosPendientes = (5 * @cuotas) - (@cuotas * @pagosRealizados)
		end
		set @saldo_pendiente_ciclo = @pagosPendientes
		--FIN: Sacar saldo pendiente

		-- Estado academico
		/**/declare @tot_mat_apro int = 0, @tot_mat_repro_ciclo int = 0, @tot_mat_apro_ciclo int = 0, @tot_mat_ins_ultimo_ciclo int = 0, @num_eva_realizadas_ultimo_ciclo int = 0,
		@ins_codigo int
		select @ins_codigo = ins_codigo from ra_ins_inscripcion
		inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
		where ins_codper = @codper and ins_codcil = @codcil_retiro

		select @tot_mat_ins_ultimo_ciclo = count(1) from ra_ins_inscripcion 
		inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
		where ins_codigo = @ins_codigo --and mai_estado = 'I'

		select @num_eva_realizadas_ultimo_ciclo = isnull(max(pom_codpon), 0) from ra_not_notas
		inner join ra_mai_mat_inscritas on mai_codins = @ins_codigo and mai_codigo = not_codmai
		inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
		where not_nota > 0 and bandera = 1

		declare @mat_apro_repro as table(estado char(1), cant int)
		insert into @mat_apro_repro (estado, cant)
		select estado, count(1) 'cant' from (
			select ltrim(rtrim(mai_codmat)) mai_codmat, nota, case when nota > 5.96 then 'A' else 'R' end estado
			from notas where ins_codper = @codper and estado = 'I' 
			union
			select ltrim(rtrim(eqn_codmat)), eqn_nota, case when eqn_nota > 5.96 then 'A' else 'R' end estado
			from ra_eqn_equivalencia_notas where eqn_codequ in(
			select equ_codigo from ra_equ_equivalencia_universidad where equ_codper = @codper
			) and eqn_nota > 0
		) t
		group by estado
		select @tot_mat_apro = cant from @mat_apro_repro where estado = 'A'

		delete from @mat_apro_repro

		insert into @mat_apro_repro (estado, cant)
		select estado, count(1) from (
		select case when nota > 5.96 then 'A' else 'R' end estado from notas where ins_codigo = @ins_codigo and estado <> 'R'
		) t
		group by estado
		select @tot_mat_repro_ciclo = cant from @mat_apro_repro  where estado = 'R'
		select @tot_mat_apro_ciclo = cant from @mat_apro_repro  where estado = 'A'

		-- Documentos pendientes
		/**/ declare @tbl_documentos_persona as table(ch int, dop_codigo int, doc_codigo int, dop_coddoc varchar(40), dop_fecha varchar(16), estado varchar(12), nombre varchar(15), cantidad_pendiente int)
		declare @titulo_bachiller varchar(12), @partida_nacimiento varchar(12), @fotografia varchar(12), @paes varchar(12)
		-- rep_generar_reporte_reingreso 1, 0, 0
		insert into @tbl_documentos_persona
		exec dbo.ra_documentos_por_alumno 1, @codper

		select @titulo_bachiller = estado from @tbl_documentos_persona where dop_coddoc = 'Título de bachiller'
		select @partida_nacimiento = estado from @tbl_documentos_persona where dop_coddoc = 'Partida de nacimiento'
		select @fotografia = estado from @tbl_documentos_persona where dop_coddoc = 'Fotografía'
		select @paes = estado from @tbl_documentos_persona where dop_coddoc = 'PAES'

		-- Resolucion
		declare @a_aprobado_reingreso	char(1) = '', @f_retiro_extemporaneo__ciclo			char(1)='',
		@b_exoneracion_mora				char(1) = '', @g_cambio_plan						char(1)='',
		@c_pago_por_abandono_ciclo		char(1) = '', @h_descuento_cuotas					char(1)='', @porcentaje_ float = 0, @num_ciclos int = 0,
		@d_cambio_carrera				char(1) = '', @j_pago_mora_regresar_su_carrera		char(1)='',
		@e_plan_pago					char(1) = '', @resolucion_num_cuotas				int = 0, @ciclo			varchar(12) = '',
		@resolucion_leyenda varchar(500) = 'Debido a que tienes procesos pendientes, debes presentarte a Nuevo Ingreso o al Centro de Atención ubicado en Metrocentro para finalizar tu reingreso.',
		@concepto varchar(5000) = ''
		--rep_generar_reporte_reingreso 2, 1, 0, 0	-- Devuelve los datos del reporte dinamicamente
		
		declare @cambiar_plan int
		declare @tbl_mat_aprobadas as tbl_mat_pensum

		insert into @tbl_mat_aprobadas (mai_codmat, matnom, ciclo, nf)
		exec dbo.web_ptl_pensum @codper
		select @cambiar_plan = dbo.fn_cambiar_plan_alumno(@codper, @tbl_mat_aprobadas)
		
	
		if (@codcil_solicito_reingreso != 0)
		begin --Se esta consultando los datos dinamicamente por medio del "csrei_codigo"
			select top 1 @a_aprobado_reingreso = case rei_re1 when 'S' then 'X' else '' end, @b_exoneracion_mora = case rei_re2 when 'S' then 'X' else '' end,
			@c_pago_por_abandono_ciclo = case rei_re3 when 'S' then 'X' else '' end, @d_cambio_carrera = case rei_re4 when 'S' then 'X' else '' end,
			@e_plan_pago = case rei_re5 when 'S' then 'X' else '' end, @resolucion_num_cuotas = rei_cuotas_pp, @ciclo = (select concat('0', cil_codcic, '-', cil_anio) from ra_cil_ciclo where cil_codigo = rei_codcil_pp),
			@f_retiro_extemporaneo__ciclo = case rei_re6 when 'S' then 'X' else '' end,
			@g_cambio_plan = case rei_re7 when 'S' then 'X' else '' end, 
			@h_descuento_cuotas = case rei_re8 when 'S' then 'X' else '' end, @porcentaje_ = rei_descuento, @num_ciclos = rei_cuotas,
			@fecha_registro = rei_fecha,
			@saldo_pendiente_ciclo = isnull(rei_saldo_ciclo_anterior, 0), @saldo_pendientes_anteriores = isnull(rei_saldo_general, 0),
			@concepto = isnull(rei_concepto, '')
			from ra_rei_reingreso_personas where rei_codper = @codper and rei_codcil = @codcil_solicito_reingreso order by rei_codigo desc
			--select * from ra_rei_reingreso_personas where rei_codper = @codper --and rei_codcil_pp = @codcil_solicito_reingreso
			-- rep_generar_reporte_reingreso 2, 1, 0, 0, 0		-- Devuelve los datos del reporte dinamicamente, llamado desde "rei_solicitud_reingreso.aspx"
			if @e_plan_pago <> 'X'
			begin
				set @resolucion_num_cuotas = ''
				set @ciclo = ''
			end
			
			--@if(ViewBag.SaldoEstudiante == 0 && ViewBag.cambioPlan == 0 && ViewBag.docsPendientes == 0) {
			if (@saldo_pendientes_anteriores = 0 and ((@g_cambio_plan = 'N' or @g_cambio_plan = '') and ((select count(1) from @tbl_documentos_persona where estado = 'Pendiente') = 0)))
				set @resolucion_leyenda = 'Puedes presentarte a cancelar la matricula y primera mensualidad para el ciclo 02-2020, en Colecturía o al Centro de Atención ubicado en Metrocentro, para finalizar su proceso de reingreso.'
		end

		--ViewBag.SaldoEstudiante == 0 && ViewBag.cambioPlan == 0 && ViewBag.docsPendientes == 0
		if (@saldo_pendientes_anteriores = 0 and ((@cambiar_plan/*select cambiar_plan from @tbl_cambio_plan*/) = 0) and ((select count(1) from @tbl_documentos_persona where estado = 'Pendiente') = 0))
			set @a_aprobado_reingreso = 'X'

		--ViewBag.cambioPlan == 1
		if ((@cambiar_plan/*select cambiar_plan from @tbl_cambio_plan*/) = 1)
			set @g_cambio_plan = 'X'

		select @dia = day(@fecha_registro), @mes = datename(M, @fecha_registro), @anio = year(getdate())

		if @insertar_datos_inmutables = 1
		begin
			insert into ra_disr_datos_inmutables_solicitud_reingreso
			select @csrei_codigo 'csrei_codigo', @dia 'dia', @mes 'mes', @anio 'anio', @per_apellidos_nombres 'per_apellidos_nombres', @carnet 'carnet', @per_direccion 'per_direccion', @per_telefono 'per_telefono', @per_celular 'per_celular', @facultad 'facultad', @carrera 'carrera', @ciclo_retiro 'ciclo_retiro', @per_correo_electronico 'per_correo_electronico', @motivo_retiro_ciclo 'motivo_retiro_ciclo'
			, @saldo_pendiente_ciclo 'saldo_pendiente_ciclo', @saldo_pendientes_anteriores 'saldo_pendientes_anteriores', @matricula 'matricula', @cuota 'cuota', @num_cuotas 'num_cuotas', @biblioteca 'biblioteca', @otros 'otros'
			, @tot_mat_apro 'tot_mat_apro', @tot_mat_ins_ultimo_ciclo 'tot_mat_ins_ultimo_ciclo', @tot_mat_repro_ciclo 'tot_mat_repro_ciclo', @tot_mat_apro_ciclo 'tot_mat_apro_ciclo', @num_eva_realizadas_ultimo_ciclo 'num_eva_realizadas_ultimo_ciclo'
			, @titulo_bachiller 'titulo_bachiller', @partida_nacimiento 'partida_nacimiento', @fotografia 'fotografia', @paes 'paes'
			, @a_aprobado_reingreso 'a_aprobado_reingreso', @f_retiro_extemporaneo__ciclo 'f_retiro_extemporaneo__ciclo', @b_exoneracion_mora 'b_exoneracion_mora', @g_cambio_plan 'g_cambio_plan', @c_pago_por_abandono_ciclo 'c_pago_por_abandono_ciclo', @h_descuento_cuotas 'h_descuento_cuotas', @porcentaje_ 'porcentaje_', @num_ciclos 'num_ciclos', @d_cambio_carrera 'd_cambio_carrera', @j_pago_mora_regresar_su_carrera 'j_pago_mora_regresar_su_carrera', @e_plan_pago 'e_plan_pago', @resolucion_num_cuotas 'resolucion_num_cuotas', @ciclo 'ciclo'
			, @resolucion_leyenda 'resolucion_leyenda'
		end
		else
		begin
			select 0 'disr_codigo', @csrei_codigo 'csrei_codigo', @dia 'dia', @mes 'mes', @anio 'anio', @per_apellidos_nombres 'per_apellidos_nombres', @carnet 'carnet', @per_direccion 'per_direccion', @per_telefono 'per_telefono', @per_celular 'per_celular', @facultad 'facultad', @carrera 'carrera', @ciclo_retiro 'ciclo_retiro', @per_correo_electronico 'per_correo_electronico', @motivo_retiro_ciclo 'motivo_retiro_ciclo'
			, @saldo_pendiente_ciclo 'saldo_pendiente_ciclo', @saldo_pendientes_anteriores 'saldo_pendientes_anteriores', @matricula 'matricula', @cuota 'cuota', @num_cuotas 'num_cuotas', @biblioteca 'biblioteca', @otros 'otros'
			, @tot_mat_apro 'tot_mat_apro', @tot_mat_ins_ultimo_ciclo 'tot_mat_ins_ultimo_ciclo', @tot_mat_repro_ciclo 'tot_mat_repro_ciclo', @tot_mat_apro_ciclo 'tot_mat_apro_ciclo', @num_eva_realizadas_ultimo_ciclo 'num_eva_realizadas_ultimo_ciclo'
			, @titulo_bachiller 'titulo_bachiller', @partida_nacimiento 'partida_nacimiento', @fotografia 'fotografia', @paes 'paes'
			, @a_aprobado_reingreso 'a_aprobado_reingreso', @f_retiro_extemporaneo__ciclo 'f_retiro_extemporaneo__ciclo', @b_exoneracion_mora 'b_exoneracion_mora', @g_cambio_plan 'g_cambio_plan', @c_pago_por_abandono_ciclo 'c_pago_por_abandono_ciclo', @h_descuento_cuotas 'h_descuento_cuotas', case @porcentaje_ when 0 then '' else @porcentaje_ end 'porcentaje_', case @num_ciclos  when 0 then '' else @num_ciclos  end 'num_ciclos', @d_cambio_carrera 'd_cambio_carrera', @j_pago_mora_regresar_su_carrera 'j_pago_mora_regresar_su_carrera', @e_plan_pago 'e_plan_pago', case @resolucion_num_cuotas  when 0 then '' else @resolucion_num_cuotas  end 'resolucion_num_cuotas', @ciclo 'ciclo'
			, @resolucion_leyenda 'resolucion_leyenda'
			, @concepto 'concepto'
		end
	 end

end

ALTER procedure [dbo].[reingreso_alumnos]
	@regional int,/** Regional **/
	@codper int,/** Codigo **/
	@fecha varchar(10),/**Fecha**/
	@motivo int,/**Dropdowlist motivos**/
	@ciclo int,/**Ciclo**/
	@ch1 varchar(1),/** Checkbox Aprobado Reingreso***/
	@ch2 varchar(1),/** Checkbox Exoneracion de Mora***/
	@ch3 varchar(1),/** Checkbox Pago por Abandono de Ciclo***/
	@ch4 varchar(1),/** Checkbox Cambio de Carrera***/
	@ch5 varchar(1),/** Checkbox Plan de Pago***/
	@ch6 varchar(1),/** Checkbox Retiro Extemporaneo de Ciclo***/
	@ch7 varchar(1),/** Checkbox Cambio de Plan***/
	@ch8 varchar(1),/** Checkbox Descuento en cuotas***/
	@cuotas_pp int,/**cuotas de resolucion  **/
	@ciclo_pp int,/** ciclo de resolucion  **/
	@descuento real,/** descuento de resolucion **/
	@cuotas int,/**Cuotas de resolucion **/
	@universidad int,/** Listado de universidades **/
	@usuario varchar(20),/** Usuario realizo el reingreso **/
	@bandera int,/** 0 **/
	@per_codvac int /**codigo de valor de cuota **/
	,@rei_saldo_ciclo_anterior float = 0
	,@rei_saldo_general float = 0
	,@rei_concepto varchar(50) = ''
as
begin

	begin transaction
	set dateformat dmy

	if (select count(1) from ra_rei_reingreso_personas where rei_codper = @codper and datediff(d,rei_fecha,convert(datetime,@fecha,103))=0) = 0
	begin
		print 'No Encontrado en la tabla "ra_rei_reingreso_personas"'

		insert into ra_rei_reingreso_personas(rei_codreg, rei_codigo, rei_codper, rei_fecha,
		rei_motivo, rei_codcil, rei_re1, rei_re2, rei_re3, rei_re4 ,rei_re5, rei_re6,
		rei_re7, rei_re8, rei_cuotas_pp, rei_codcil_pp, rei_descuento, rei_cuotas, rei_codist, rei_usuario, rei_saldo_ciclo_anterior, rei_saldo_general, rei_concepto)
		select 1,isnull(max(rei_codigo),0)+1,@codper,
		convert(datetime,@fecha,103), @motivo, @ciclo, @ch1,
		@ch2, @ch3, @ch4, @ch5, @ch6, @ch7, @ch8, @cuotas_pp, @ciclo_pp, @descuento, @cuotas,
		@universidad, @usuario, @rei_saldo_ciclo_anterior, @rei_saldo_general, @rei_concepto
		from ra_rei_reingreso_personas

		--Actualiza tipo ingreso en tabla ra per persona
		update ra_per_personas set per_tipo_ingreso = 6 where per_codigo = @codper
		update ra_per_personas set per_codvac = @per_codvac where per_codigo = @codper
	end
	else
	begin
		print 'SI encontrado en la tabla "ra_rei_reingreso_personas"'
		update ra_rei_reingreso_personas
		set rei_fecha = @fecha,
		rei_motivo = @motivo, rei_codcil = @ciclo,
		rei_re1 = @ch1, rei_re2 = @ch2,
		rei_re3 = @ch3, rei_re4 = @ch4,
		rei_re5 = @ch5, rei_re6 = @ch6,
		rei_re7 = @ch7, rei_re8 = @ch8,
		rei_cuotas_pp = @cuotas_pp, rei_codcil_pp = @ciclo_pp,
		rei_descuento = @descuento, rei_cuotas = @cuotas--,
		--rei_usuario = @usuario
		,rei_saldo_ciclo_anterior = @rei_saldo_ciclo_anterior
		,rei_saldo_general = @rei_saldo_general
		,rei_concepto = @rei_concepto
		where rei_codper = @codper
		and datediff(d,rei_fecha,convert(datetime,@fecha,103))=0

		update ra_per_personas set per_tipo_ingreso = 6 where per_codigo = @codper
		update ra_per_personas set per_codvac = @per_codvac where per_codigo = @codper
	end

	if @bandera = 1
	begin
		update ra_per_personas
		set per_estado = 'A', per_codvac = @per_codvac
		where per_codigo = @codper
	end 

	update ra_per_personas set per_correo_institucional = replace(per_carnet,'-','') + '@mail.utec.edu.sv'
	where per_codigo = @codper and per_tipo = 'U'

	declare @fecha_aud datetime,@registro varchar(200)
	set @fecha_aud = getdate()
	select @registro = cast(@codper as varchar) + '$' + cast(@ciclo as varchar)
	exec auditoria_del_sistema 'ra_rei_reingreso_personas','I', @usuario, @fecha_aud, @registro

	commit transaction

end