--select * from maestri

select top 25 cil_codigo 'codigo', concat('0', cil_codcic, '-', cil_anio) 'texto' from ra_cil_ciclo order by cil_anio desc, cil_codcic desc

--select * from ra_tde_TipoDeEstudio

drop table cuoestr_cuotas_estudiantes_reingreso
drop table reiest_reingreso_estudiantes
-- drop table reiest_reingreso_estudiantes
create table reiest_reingreso_estudiantes (
	reiest_codigo int primary key identity (1, 1),

	reiest_codtde int foreign key references ra_tde_TipoDeEstudio not null,
	reiest_coding int foreign key references ra_ing_ingreso not null,

	reiest_codcil_reingreso int foreign key references ra_cil_ciclo not null,
	reiest_codper int foreign key references ra_per_personas not null,

	reiest_cantidad_materias_cursar int null,

	reiest_codusr_creacion int null,
	reiest_fecha_creacion datetime default getdate()
)
go
-- select * from reiest_reingreso_estudiantes
--insert into reiest_reingreso_estudiantes(reiest_codtde, reiest_coding, reiest_codcil_reingreso, reiest_codper, reiest_cantidad_materias_cursar, reiest_codusr_creacion)
--values(2, 6, 134, 253185, 2, 407)
--go

-- drop table cuoestr_cuotas_estudiantes_reingreso
create table cuoestr_cuotas_estudiantes_reingreso (
	cuoestr_codigo int primary key identity (1, 1),
	cuoestr_codreiest int foreign key references reiest_reingreso_estudiantes not null,
	
	cuoestr_codtmo int,
	cuoestr_fecha_limite_pago date,
	cuoestr_valor numeric (18, 2),
	cuoestr_valor_mora numeric (18, 2),
	cuoestr_codigo_barra int,

	cuoestr_codusr_creacion int null,
	cuoestr_fecha_creacion datetime default getdate()
)
go
-- select * from cuoestr_cuotas_estudiantes_reingreso
--insert into cuoestr_cuotas_estudiantes_reingreso 
--(cuoestr_codreiest, cuoestr_codtmo, cuoestr_fecha_limite_pago, cuoestr_valor, cuoestr_valor_mora, cuoestr_codigo_barra, cuoestr_codusr_creacion)
--values (1, 4290, '2024-04-16 00:00:00.000', 120, 10, 0, 407), 
--(1, 4291, '2024-04-16 00:00:00.000', 115, 10, 1, 407)
--go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2024-03-04 10:01:04.890>
	-- Description: <Devuelve los datos los estudiantes que han reingresado>
	-- =============================================
	-- select * from vst_rei_reingresos_estudiantes where codcil = 134
create or alter view vst_rei_reingresos_estudiantes
as
	select reiest_codigo 'codreiest', tde_codigo 'codtde', tde_nombre 'tipo_estudio', ing_codigo 'coding', ing_nombre 'tipo_ingreso', cil_codigo 'codcil', 
		concat('0', cil_codcic, '-', cil_anio) 'ciclo', per_codigo 'codper', per_carnet 'carnet', per_nombres_apellidos 'estudiante', pla_alias_carrera 'carrera', reiest_cantidad_materias_cursar 'cantidad_materias_cursar',
		reiest_codusr_creacion 'codusr', usr_nombre 'usuario_creacion', reiest_fecha_creacion 'fecha_creacion'
	from reiest_reingreso_estudiantes
		inner join ra_tde_TipoDeEstudio on reiest_codtde = tde_codigo
		inner join ra_ing_ingreso on reiest_coding = ing_codigo
		inner join ra_cil_ciclo on reiest_codcil_reingreso = cil_codigo
		inner join ra_per_personas on reiest_codper = per_codigo

		left join ra_alc_alumnos_carrera on alc_codper = per_codigo
		left join ra_pla_planes on alc_codpla = pla_codigo
		left join adm_usr_usuarios on reiest_codusr_creacion = usr_codigo
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2024-03-04 10:12:34.993>
	-- Description: <Devuelve los datos de las cuotas a cancelar por los estudiantes que han reingresado>
	-- =============================================
	-- select * from vst_rei_cuotas_estudiantes_reingresos where codcil = 134
create or alter view dbo.vst_rei_cuotas_estudiantes_reingresos
as
	select cuoestr_codigo 'codcuoestr', v1.codreiest, v1.codcil, v1.ciclo, v1.codper, v1.carnet, v1.estudiante, cuoestr_codtmo 'codtmo', tmo_arancel 'arancel', 
		tmo_descripcion 'descripcion', cuoestr_fecha_limite_pago 'fecha_limite_pago', cuoestr_valor 'valor', cuoestr_valor_mora 'valor_mora', 
		cuoestr_codigo_barra 'codigo_barra', 
		cuoestr_codusr_creacion 'codusr', usr_nombre 'usuario_creacion', cuoestr_fecha_creacion 'fecha_creacion'
	from cuoestr_cuotas_estudiantes_reingreso
		inner join vst_rei_reingresos_estudiantes v1 on v1.codreiest = cuoestr_codreiest
		inner join col_tmo_tipo_movimiento on cuoestr_codtmo = tmo_codigo

		left join adm_usr_usuarios on cuoestr_codusr_creacion = usr_codigo
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2024-03-04 10:12:34.993>
	-- Description: <Realiza el mantenimiento a la tabla "reiest">
	-- =============================================
create or alter procedure sp_reiest_reingreso_estudiantes
	@opcion int = 0,
	@codreiest int = 0,
	@codtde int = 0,
	@coding int = 0,
	@codcil_reingreso int = 0,
	@codper int = 0,
	@cantidad_materias_cursar int = 0,
	@codusr int = 0,

	@codtmo int = 0,
	@arancel varchar(30) = '',
	@fecha_limite_pago nvarchar(30) = '',
	@valor numeric (18, 2) = 0,
	@valor_mora numeric (18, 2) = 0,
	@codigo_barra int = 0,

	@fecha_desde nvarchar(12) = '', 
    @fecha_hasta nvarchar(12) = '',
	@txt_buscar varchar(125) = ''
as
begin
	set dateformat dmy

	if @opcion = 1
	begin
		select codreiest, codtde, tipo_estudio, coding, tipo_ingreso, codcil, ciclo, codper, carnet, estudiante, carrera, 
			cantidad_materias_cursar, codusr, usuario_creacion, fecha_creacion 
		from vst_rei_reingresos_estudiantes 
		where /*codcil = @codcil_reingreso and*/ codtde = @codtde
		and convert(date, fecha_creacion, 103) between convert(date, @fecha_desde, 103) and convert(date, @fecha_hasta, 103)
			
		and (
			ltrim(rtrim(carnet)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end
			or ltrim(rtrim(codreiest)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end
			or ltrim(rtrim(estudiante)) like '%' + case when isnull(ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@txt_buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end
		)
		order by codreiest
	end

	if @opcion = 2--Inserta
	begin
		declare @_codreiest int
		select @_codreiest = codreiest from vst_rei_reingresos_estudiantes where codper = @codper and codcil = @codcil_reingreso
		if isnull(@_codreiest, 0) = 0
		begin
			insert into reiest_reingreso_estudiantes(reiest_codtde, reiest_coding, reiest_codcil_reingreso, reiest_codper, reiest_cantidad_materias_cursar, reiest_codusr_creacion)
			values(@codtde, @coding, @codcil_reingreso, @codper, @cantidad_materias_cursar, @codusr)

			select @@IDENTITY 'codreiest', 1 'respuesta', 'Insertado' 'texto_respuesta'
		end
		else
		begin
			select @_codreiest 'codreiest', -1 'respuesta', 'No insertado, ya existe un reingreso para la persona para el ciclo' 'texto_respuesta'
		end
	end

	if @opcion = 3
	begin
		select @codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel

		insert into cuoestr_cuotas_estudiantes_reingreso 
		(cuoestr_codreiest, cuoestr_codtmo, cuoestr_fecha_limite_pago, cuoestr_valor, cuoestr_valor_mora, cuoestr_codigo_barra, cuoestr_codusr_creacion)
		values (@codreiest, @codtmo, cast(@fecha_limite_pago as date), @valor, @valor_mora, @codigo_barra, @codusr)
		select @@IDENTITY 'codcuoestr', 1 'respuesta', 'Insertado' 'texto_respuesta'
	end

	if @opcion = 4 -- 
	begin
		-- exec dbo.sp_reiest_reingreso_estudiantes @opcion = 4, @codper = 253185, @codtde = 2, @codcil_reingreso = 134, @coding = 6
		delete from col_art_archivo_tal_mae_mora where per_codigo = @codper
		exec dbo.tal_GenerarDataTalonarioMaestrias 2, @codtde, @codcil_reingreso, @codper, 0 -- Maestrias
		
		delete from col_art_archivo_tal_mae_mora where fel_codigo_barra not in (
			select codigo_barra from vst_rei_cuotas_estudiantes_reingresos where codper = @codper and codcil = @codcil_reingreso
		) and per_codigo = @codper

		update ra_per_personas set per_tipo_ingreso_actual = @coding, per_tipo_ingreso = @coding, per_estado = 'A' where per_codigo = @codper
		select 0 'codreiest', 1 'respuesta', 'Proceso realizado con exito' 'texto_respuesta'
	end

end
go

