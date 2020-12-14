select distinct man_nomhor, man_codigo from ra_hpl_horarios_planificacion
inner join ra_man_grp_hor on man_codigo = hpl_codman
where hpl_codcil = 125 and man_codigo in (243,249,281)

select * from ra_hpl_horarios_planificacion
inner join ra_mat_materias on mat_codigo = hpl_codmat
where hpl_codman in (243,249,281) and hpl_codcil = 125

select tpm_tipo_materia, tpm_descripcion from ra_tpm_tipo_materias

select * from ra_hpl_horarios_planificacion 
inner join ra_mat_materias on mat_codigo = hpl_codmat
where hpl_codigo in (45406, 44720)

select * from ra_plm_planes_materias
inner join ra_pla_planes on pla_codigo = plm_codpla
where plm_codmat in ('IB1-H', 'TAI1-AC')
--INGLES BASICO I
--TALLER INTEGRAL I
select * from ra_per_personas
inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
where substring(per_carnet, 1, 2) in ('31', '38') and per_estado = 'A' and per_anio_ingreso = 2020
and alc_codpla in (312, 382)







select @rvg_mensaje = rvg_mensaje from ra_validaciones_globales where rvg_codper = @codper

if not exists (select 1 from ra_ins_inscripcion where ins_codper = @codper and ins_codcil = @codcil)
begin    
--select @rvg_mensaje prob 
if @rvg_mensaje = '4'
    exec dbo.web_ins_verificainscripcion @codper, @codcil
else 
    select @rvg_mensaje prob2
end
else
select '1' prob

select * from ra_validaciones_globales
	where rvg_codper = 228582
	update ra_validaciones_globales set rvg_mensaje = 0 









select * from ra_pla_planes
WHERE pla_codcar in (11, 34, 22) and pla_nombre = 'PLAN 2021'
--11	LICENCIATURA EN ADMINISTRACIÓN DE EMPRESAS, codpla 2021 485
--34	LICENCIATURA EN COMUNICACIONES, codpla 2021 479
--22	INGENIERÍA INDUSTRIAL, codpla 2021 486

select * from ra_alc_alumnos_carrera
inner join ra_per_personas on per_codigo = alc_codper
where alc_codpla in (485, 479, 486)

exec dbo.web_ins_matinscritas_nodjs 228534, 125
exec dbo.web_ins_genasesoria_con_matins_nodjs 125, 228534
exec dbo.web_ins_genasesoria 125, 226374
--11-0193-2021

select * from ra_validaciones_globales where rvg_codper = 228582

declare @codper int = 226374, @codcil int = 125
delete from ra_not_notas where not_codmai in (
select mai_codigo from ra_ins_inscripcion 
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
where ins_codper = @codper
)
delete from ra_mai_mat_inscritas_especial where mai_codins in (
select ins_codigo from ra_ins_inscripcion where ins_codper = @codper and ins_codcil = @codcil
)
delete from ra_mai_mat_inscritas 
where mai_codigo in (
select mai_codigo from ra_ins_inscripcion 
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
where ins_codper = @codper
)
delete from ra_ins_inscripcion where ins_codper = @codper and ins_codcil = @codcil
delete from ra_dpipg_detalle_pre_inscripcion_pre_grado where dpipg_codpipg in (
	select pipg_codigo from ra_pipg_pre_inscripcion_pre_grado where pipg_codper = @codper and pipg_codcil = @codcil
)
delete from ra_pipg_pre_inscripcion_pre_grado where pipg_codper = @codper and pipg_codcil = @codcil
update ra_validaciones_globales set rvg_mensaje = '0' where rvg_codper = @codper
--insert into ra_validaciones_globales (rvg_carnet, rvg_codper, rvg_mensaje) values ('1101932021',228582,0)



create type tbl_preins as table
(
	dpipg_codpipg int,
	dpipg_codmat varchar(10),
	dpipg_codhpl int,
	dppig_lunes nvarchar(1),
	dppig_martes nvarchar(1),
	dppig_miercoles nvarchar(1),
	dppig_jueves nvarchar(1),
	dppig_viernes nvarchar(1),
	dppig_sabado nvarchar(1),
	dppig_domingo nvarchar(1),
	dppig_codman int,
	dppig_comentario nvarchar(500)
)

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-12-11 21:34:05.296>
	-- Description: <Realiza procesos para preinscripción pregrado>
	-- =============================================
	-- exec sp_pre_inscripcion_nodjs 1
alter procedure sp_pre_inscripcion_nodjs
	@opcion int = 0,
	@codper int = 0,
	@codcil int = 0,
	@tbl_preins as tbl_preins readonly
as
begin
	if @opcion = 1 --Devuelve la data de la tabla "ra_man_grp_hor"
	begin
		select man_codigo, man_nomhor 
		from ra_man_grp_hor
		where man_codigo in (select distinct hpl_codman from ra_hpl_horarios_planificacion where hpl_codcil = @codcil)
		order by man_nomhor
	end

	if @opcion = 2 --inserta la preinscripcion
	begin
		if not exists (select 1 from ra_pipg_pre_inscripcion_pre_grado where pipg_codper = @codper and pipg_codcil = @codcil)
		begin
			--inserta el encabezado
			--select * from ra_pipg_pre_inscripcion_pre_grado
			declare @codpipg int
			insert into ra_pipg_pre_inscripcion_pre_grado (pipg_codper, pipg_codcil)
			values (@codper, @codcil)
			select @codpipg = scope_identity()

			--inserta el detalle
			--select * from ra_dpipg_detalle_pre_inscripcion_pre_grado
			insert into ra_dpipg_detalle_pre_inscripcion_pre_grado 
			(dpipg_codpipg, dpipg_codmat, dpipg_codhpl, 
			dppig_lunes, dppig_martes, dppig_miercoles, dppig_jueves, dppig_viernes, dppig_sabado, dppig_domingo,
			dppig_codman, dppig_comentario)
			select @codpipg, dpipg_codmat, dpipg_codhpl, 
			dppig_lunes, dppig_martes, dppig_miercoles, dppig_jueves, dppig_viernes, dppig_sabado, dppig_domingo, 
			dppig_codman, dppig_comentario
			from @tbl_preins
		end
		select 1 res
	end

	if @opcion = 3 --Valida si el @codper ya hizo la preinscripcion en el @codcil
	begin
		if not exists (select 1 from ra_pipg_pre_inscripcion_pre_grado where pipg_codper = @codper and pipg_codcil = @codcil)
			select 0 res--No ha realizado la pre inscripcion
		else
			select 1 res--Ya realizo la pre inscripcion
	end

	if @opcion = 4--Devuelve la data de las materias preinscritas
	begin
		-- sp_pre_inscripcion_nodjs @opcion = 4, @codper = 226374, @codcil = 125
		select per_carnet, per_nombres_apellidos nombre_ape, pla_alias_carrera, pla_anio,
		concat('Codigo de preinscripción: ', pipg_codigo,', Fecha de preinscripción: ', Convert(varchar, pipg_fecha_creacion))as fecha_ins,
		concat('0', cil_codcic,'-', cil_anio) cicloins
		from ra_pipg_pre_inscripcion_pre_grado
			inner join ra_per_personas on per_codigo = pipg_codper
			inner join ra_cil_ciclo on cil_codigo = pipg_codcil
			inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
			inner join ra_pla_planes ON pla_codigo = alc_codpla 
		where pipg_codper = @codper and pipg_codcil = @codcil

		select mat_codigo, materia, hpl_descripcion, estado, mai_matricula, horas, dias, aul_nombre_corto
		from vst_detalle_preinscripcion
		where pipg_codper = @codper and pipg_codcil = @codcil
		order by dpipg_codmat, tpm_tipo_materia desc
	end
end
go


	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-12-12 20:41:52.262>
	-- Description: <Vista que retorna la data de las preinscripciones registradas>
	-- =============================================
	-- select * from dbo.vst_detalle_preinscripcion
alter VIEW dbo.vst_detalle_preinscripcion
AS
select pipg_codigo, dpipg_codigo, mat_codigo, pipg_codper, pipg_codcil,
	case when tpm_tipo_materia = 'P' then mat_nombre else concat(mat_nombre, ' (', tpm_descripcion, ')') end materia, 
	hpl_descripcion, 'PreIns' estado, 0 mai_matricula,
	isnull(man_nomhor,'sin Asignar')as horas
	, dppig_codman,
	case when dppig_lunes = 'S' then 'LUNES-' ELSE '' END + 
	case when dppig_martes = 'S' then 'MARTES-' ELSE '' END + 
	case when dppig_miercoles = 'S' then 'MIERCOLES-' ELSE '' END + 
	case when dppig_jueves = 'S' then 'JUEVES-' ELSE '' END + 
	case when dppig_viernes = 'S' then 'VIERNES-' ELSE '' END + 
	case when dppig_sabado = 'S' then 'SABADO-' ELSE '' END + 
	case when dppig_domingo = 'S' then 'DOMINGO-' ELSE '' END dias, aul_nombre_corto, dppig_comentario
	, hpl_codman, 
	case when hpl_lunes = 'S' then 'LUNES-' ELSE '' END + 
	case when hpl_martes = 'S' then 'MARTES-' ELSE '' END + 
	case when hpl_miercoles = 'S' then 'MIERCOLES-' ELSE '' END + 
	case when hpl_jueves = 'S' then 'JUEVES-' ELSE '' END + 
	case when hpl_viernes = 'S' then 'VIERNES-' ELSE '' END + 
	case when hpl_sabado = 'S' then 'SABADO-' ELSE '' END + 
	case when hpl_domingo = 'S' then 'DOMINGO-' ELSE '' END dias_hpl,
	pipg_fecha_creacion, dpipg_fecha,
	dpipg_codmat, tpm_tipo_materia
from ra_pipg_pre_inscripcion_pre_grado
	inner join ra_dpipg_detalle_pre_inscripcion_pre_grado on dpipg_codpipg = pipg_codigo
	inner join ra_hpl_horarios_planificacion on dpipg_codhpl = hpl_codigo
	inner join ra_per_personas on per_codigo = pipg_codper
	inner join ra_cil_ciclo on cil_codigo = pipg_codcil
	inner join ra_mat_materias on mat_codigo = hpl_codmat

	join ra_man_grp_hor on man_codigo = dppig_codman
	left join ra_aul_aulas on aul_codigo = hpl_codaul

	inner join ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia




--#region CAMBIOS SP´S POR LAS INSTRUCTORIAS hpl_tipo_materia = 'A'


-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-01-31 17:56:07.210>
	-- Description: <Devuelve la data de las materias inscritas segun la misma forma de retorno del 
	--					procedimiento: web_ins_genasesoria_azure>
	-- =============================================
	-- exec web_ins_matinscritas_data_nodjs 228534, 125
ALTER procedure [dbo].[web_ins_matinscritas_data_nodjs]
	@codper int,
	@codcil int 
as
begin
	declare @cicloins nvarchar(10)

	select carnet, codigo, materia, matricula, hor_descripcion, man_nomhor,
		case when dias <> '' then substring(dias,1,len(dias)-1) else dbo.fechas_materias_especiales(hpl_codigo) end as dias,
		plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, especial, hpl_tipo_materia, plm_uv
	from (
		select per_carnet 'carnet', mai_codmat 'codigo', 
		--rtrim(isnull(plm_alias,'')) 'materia', 
		rtrim(Isnull(plm_alias,'')) + case when tpm_mostrar_descripcion = 1 then ' (' + tpm_descripcion + ')' when tpm_mostrar_descripcion = 0 then ' ' end as materia,
		--(
		--	select count(1)
		--	from ra_mai_mat_inscritas, ra_ins_inscripcion
		--	where ins_codper = per_codigo
		--	and mai_codins = ins_codigo and ins_codcil <> @codcil
		--	and mai_codpla = plm.plm_codpla and mai_estado = 'I'
		--	and mai_codmat = mat_codigo and ins_codper = @codper
		--) + 1 
		mai_matricula
		'matricula', hpl_descripcion 'hor_descripcion', man_nomhor,
		case when hpl_lunes = 'S' then 'Lu-' ELSE '' END + 
		case when hpl_martes = 'S' then 'Ma-' ELSE '' END + 
		case when hpl_miercoles = 'S' then 'Mie-' ELSE '' END + 
		case when hpl_jueves = 'S' then 'Ju-' ELSE '' END + 
		case when hpl_viernes = 'S' then 'Vi-' ELSE '' END + 
		case when hpl_sabado = 'S' then 'Sab-' ELSE '' END + 
		case when hpl_domingo = 'S' then 'Dom-' ELSE '' END dias,
		plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, mat_tipo 'especial', hpl_tipo_materia, plm_uv
		from ra_ins_inscripcion
			inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
			inner join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
			join ra_man_grp_hor on man_codigo = hpl_codman
			left join ra_aul_aulas on aul_codigo = hpl_codaul
			join ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia
			join ra_mat_materias on mat_codigo = mai_codmat
			join ra_per_personas on per_codigo = ins_codper
			join ra_alc_alumnos_carrera on alc_codper = per_codigo
			join ra_plm_planes_materias as plm on plm.plm_codpla = alc_codpla and plm.plm_codmat = mai_codmat
		where ins_codcil = @codcil and ins_codper = @codper

		union

		select per_carnet, case when hpl_tipo_materia in('A', 'I') then rtrim(ltrim(hpl_codmat)) + hpl_tipo_materia else hpl_codmat end, 
		--case hpl_tipo_materia when 'A' then rtrim(ltrim(mat_nombre)) + ' ('+ tpm_descripcion+')' else mat_nombre end,
		rtrim(Isnull(plm_alias,'')) + case when tpm_mostrar_descripcion = 1 then ' (' + tpm_descripcion + ')' when tpm_mostrar_descripcion = 0 then ' ' end as materia,
		(
			select count(1)
			from ra_mai_mat_inscritas, ra_ins_inscripcion
			where ins_codper = per_codigo
			and mai_codins = ins_codigo and ins_codcil <> @codcil
			and mai_codpla = plm.plm_codpla and mai_estado = 'I'
			and mai_codmat = mat_codigo and ins_codper = @codper
		) + 1 matricula, hpl_descripcion, man_nomhor,
		case when hpl_lunes = 'S' then 'Lu-' ELSE '' END + 
		case when hpl_martes = 'S' then 'Ma-' ELSE '' END + 
		case when hpl_miercoles = 'S' then 'Mie-' ELSE '' END + 
		case when hpl_jueves = 'S' then 'Ju-' ELSE '' END + 
		case when hpl_viernes = 'S' then 'Vi-' ELSE '' END + 
		case when hpl_sabado = 'S' then 'Sab-' ELSE '' END + 
		case when hpl_domingo = 'S' then 'Dom-' ELSE '' END dias,
		plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, case when hpl_tipo_materia in ('A', 'I') then 'S' else mat_tipo end mat_tipo, hpl_tipo_materia, plm_uv
		from ra_ins_inscripcion
			inner join ra_mai_mat_inscritas_especial on mai_codins = ins_codigo
			inner join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhor
			left join ra_aul_aulas on aul_codigo = hpl_codaul
			join ra_man_grp_hor on man_codigo = hpl_codman
			join ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia
			join ra_mat_materias on mat_codigo = mai_codmat
			join ra_per_personas on per_codigo = ins_codper
			join ra_alc_alumnos_carrera on alc_codper = per_codigo
			join ra_plm_planes_materias as plm on plm.plm_codpla = alc_codpla and plm.plm_codmat = mai_codmat
		where ins_codcil = @codcil and ins_codper = @codper
	) t
end


	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-01-31 17:56:07.210>
	-- Description: <Devuelve la data de las materias inscritas segun la misma forma de retorno del 
	--					procedimiento: web_ins_genasesoria_azure>
	-- =============================================
	-- exec web_ins_matinscritas_data_nodjs_azure 190505, 122
	-- exec web_ins_matinscritas_data_nodjs_azure 222914, 123
ALTER procedure [dbo].[web_ins_matinscritas_data_nodjs_azure]
	@codper int,
	@codcil int 
as
begin
	declare @cicloins nvarchar(10)

		select carnet, codigo, materia, matricula, hor_descripcion, man_nomhor,
		case when dias <> '' then substring(dias,1,len(dias)-1) else dbo.fechas_materias_especiales(hpl_codigo) end as dias,
		plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, especial, hpl_tipo_materia, plm_uv
		from (
			select per_carnet 'carnet', mai_codmat 'codigo', 
			--rtrim(isnull(plm_alias,'')) 'materia', 
			rtrim(Isnull(plm_alias,'')) + case when tpm_mostrar_descripcion = 1 then ' (' + tpm_descripcion + ')' when tpm_mostrar_descripcion = 0 then ' ' end as materia,
			--(
			--	select count(1)
			--	from Inscripcion.dbo.ra_mai_mat_inscritas, Inscripcion.dbo.ra_ins_inscripcion
			--	where ins_codper = per_codigo
			--	and mai_codins = ins_codigo --and ins_codcil = @codcil
			--	and mai_codpla = plm.plm_codpla and mai_estado = 'I'
			--	and mai_codmat = mat_codigo and ins_codper = @codper
			--) + 1 
			mai_matricula 
			'matricula', hpl_descripcion 'hor_descripcion', man_nomhor,
			case when hpl_lunes = 'S' then 'Lu-' ELSE '' END + 
			case when hpl_martes = 'S' then 'Ma-' ELSE '' END + 
			case when hpl_miercoles = 'S' then 'Mie-' ELSE '' END + 
			case when hpl_jueves = 'S' then 'Ju-' ELSE '' END + 
			case when hpl_viernes = 'S' then 'Vi-' ELSE '' END + 
			case when hpl_sabado = 'S' then 'Sab-' ELSE '' END + 
			case when hpl_domingo = 'S' then 'Dom-' ELSE '' END dias,
			plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, mat_tipo 'especial', hpl_tipo_materia, plm_uv
			from Inscripcion.dbo.ra_ins_inscripcion
				inner join Inscripcion.dbo.ra_mai_mat_inscritas on mai_codins = ins_codigo
				inner join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
				join ra_man_grp_hor on man_codigo = hpl_codman
				left join ra_aul_aulas on aul_codigo = hpl_codaul
				join ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia
				join ra_mat_materias on mat_codigo = mai_codmat
				join ra_per_personas on per_codigo = ins_codper
				join ra_alc_alumnos_carrera on alc_codper = per_codigo
				join ra_plm_planes_materias as plm on plm.plm_codpla = alc_codpla and plm.plm_codmat = mai_codmat
			where ins_codcil = @codcil and ins_codper = @codper

			union

			select per_carnet, case when hpl_tipo_materia in('A', 'I') then rtrim(ltrim(hpl_codmat)) + hpl_tipo_materia else hpl_codmat end, 
			--case hpl_tipo_materia when 'A' then rtrim(ltrim(mat_nombre)) + ' ('+ tpm_descripcion+')' else mat_nombre end,
			rtrim(Isnull(plm_alias,'')) + case when tpm_mostrar_descripcion = 1 then ' (' + tpm_descripcion + ')' when tpm_mostrar_descripcion = 0 then ' ' end as materia,
			(
				select count(1)
				from Inscripcion.dbo.ra_mai_mat_inscritas, Inscripcion.dbo.ra_ins_inscripcion
				where ins_codper = per_codigo
				and mai_codins = ins_codigo and ins_codcil <> @codcil
				and mai_codpla = plm.plm_codpla and mai_estado = 'I'
				and mai_codmat = mat_codigo and ins_codper = @codper
			) + 1 matricula, hpl_descripcion, man_nomhor,
			case when hpl_lunes = 'S' then 'Lu-' ELSE '' END + 
			case when hpl_martes = 'S' then 'Ma-' ELSE '' END + 
			case when hpl_miercoles = 'S' then 'Mie-' ELSE '' END + 
			case when hpl_jueves = 'S' then 'Ju-' ELSE '' END + 
			case when hpl_viernes = 'S' then 'Vi-' ELSE '' END + 
			case when hpl_sabado = 'S' then 'Sab-' ELSE '' END + 
			case when hpl_domingo = 'S' then 'Dom-' ELSE '' END dias,
			plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, case when hpl_tipo_materia in ('A', 'I') then 'S' else mat_tipo end mat_tipo, hpl_tipo_materia, plm_uv
			from Inscripcion.dbo.ra_ins_inscripcion
				inner join Inscripcion.dbo.ra_mai_mat_inscritas_especial on mai_codins = ins_codigo
				inner join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhor
				left join ra_aul_aulas on aul_codigo = hpl_codaul
				join ra_man_grp_hor on man_codigo = hpl_codman
				join ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia
				join ra_mat_materias on mat_codigo = mai_codmat
				join ra_per_personas on per_codigo = ins_codper
				join ra_alc_alumnos_carrera on alc_codper = per_codigo
				join ra_plm_planes_materias as plm on plm.plm_codpla = alc_codpla and plm.plm_codmat = mai_codmat
			where ins_codcil = @codcil and ins_codper = @codper
	) t2

	union

	select carnet, codigo, materia, matricula, hor_descripcion, man_nomhor,
		case when dias <> '' then substring(dias,1,len(dias)-1) else dbo.fechas_materias_especiales(hpl_codigo) end as dias,
		plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, especial, hpl_tipo_materia, plm_uv
		from (
			select per_carnet 'carnet', mai_codmat 'codigo', 
			--rtrim(isnull(plm_alias,'')) 'materia', 
			rtrim(Isnull(plm_alias,'')) + case when tpm_mostrar_descripcion = 1 then ' (' + tpm_descripcion + ')' when tpm_mostrar_descripcion = 0 then ' ' end as materia,
			(
				select count(1)
				from ra_mai_mat_inscritas, ra_ins_inscripcion
				where ins_codper = per_codigo
				and mai_codins = ins_codigo and ins_codcil <> @codcil
				and mai_codpla = plm.plm_codpla and mai_estado = 'I'
				and mai_codmat = mat_codigo and ins_codper = @codper
			) + 1 'matricula', hpl_descripcion 'hor_descripcion', man_nomhor,
			case when hpl_lunes = 'S' then 'Lu-' ELSE '' END + 
			case when hpl_martes = 'S' then 'Ma-' ELSE '' END + 
			case when hpl_miercoles = 'S' then 'Mie-' ELSE '' END + 
			case when hpl_jueves = 'S' then 'Ju-' ELSE '' END + 
			case when hpl_viernes = 'S' then 'Vi-' ELSE '' END + 
			case when hpl_sabado = 'S' then 'Sab-' ELSE '' END + 
			case when hpl_domingo = 'S' then 'Dom-' ELSE '' END dias,
			plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, mat_tipo 'especial', hpl_tipo_materia, plm_uv
			from ra_ins_inscripcion
				inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
				inner join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
				join ra_man_grp_hor on man_codigo = hpl_codman
				left join ra_aul_aulas on aul_codigo = hpl_codaul
				join ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia
				join ra_mat_materias on mat_codigo = mai_codmat
				join ra_per_personas on per_codigo = ins_codper
				join ra_alc_alumnos_carrera on alc_codper = per_codigo
				join ra_plm_planes_materias as plm on plm.plm_codpla = alc_codpla and plm.plm_codmat = mai_codmat
			where ins_codcil = @codcil and ins_codper = @codper

			union

			select per_carnet, case when hpl_tipo_materia in('A', 'I') then rtrim(ltrim(hpl_codmat)) + hpl_tipo_materia else hpl_codmat end, 
			--case hpl_tipo_materia when 'A' then rtrim(ltrim(mat_nombre)) + ' ('+ tpm_descripcion+')' else mat_nombre end,
			rtrim(Isnull(plm_alias,'')) + case when tpm_mostrar_descripcion = 1 then ' (' + tpm_descripcion + ')' when tpm_mostrar_descripcion = 0 then ' ' end as materia,
			(
				select count(1)
				from ra_mai_mat_inscritas, ra_ins_inscripcion
				where ins_codper = per_codigo
				and mai_codins = ins_codigo and ins_codcil <> @codcil
				and mai_codpla = plm.plm_codpla and mai_estado = 'I'
				and mai_codmat = mat_codigo and ins_codper = @codper
			) + 1 matricula, hpl_descripcion, man_nomhor,
			case when hpl_lunes = 'S' then 'Lu-' ELSE '' END + 
			case when hpl_martes = 'S' then 'Ma-' ELSE '' END + 
			case when hpl_miercoles = 'S' then 'Mie-' ELSE '' END + 
			case when hpl_jueves = 'S' then 'Ju-' ELSE '' END + 
			case when hpl_viernes = 'S' then 'Vi-' ELSE '' END + 
			case when hpl_sabado = 'S' then 'Sab-' ELSE '' END + 
			case when hpl_domingo = 'S' then 'Dom-' ELSE '' END dias,
			plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, case when hpl_tipo_materia in ('A', 'I') then 'S' else mat_tipo end mat_tipo, hpl_tipo_materia, plm_uv
			from ra_ins_inscripcion
			inner join ra_mai_mat_inscritas_especial on mai_codins = ins_codigo
			inner join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhor
			left join ra_aul_aulas on aul_codigo = hpl_codaul
			join ra_man_grp_hor on man_codigo = hpl_codman
			join ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia
			join ra_mat_materias on mat_codigo = mai_codmat
			join ra_per_personas on per_codigo = ins_codper
			join ra_alc_alumnos_carrera on alc_codper = per_codigo
			join ra_plm_planes_materias as plm on plm.plm_codpla = alc_codpla and plm.plm_codmat = mai_codmat
			where ins_codcil = @codcil and ins_codper = @codper
	) t
end


-- =============================================
	-- Author:      <Todos>
	-- Create date: <Miercoles 20 Mayo 2020>
	-- Description: <Retorna el encabezado (ra_ins) y el detalle (ra_mai) de las materias inscritas>
	-- =============================================
	-- exec web_ins_matinscritas_nodjs 228534, 125
ALTER procedure [dbo].[web_ins_matinscritas_nodjs]
	@codper int,
	@codcil int 
as
begin
	declare @cicloins nvarchar(10)

	declare @tbl_inicio_clases as table (InicioCiclo varchar(125))

	insert into @tbl_inicio_clases (InicioCiclo)
	exec dbo.ra_fic_fecha_inicio_ciclo @codcil
	
	select @cicloins =concat('0', cil_codcic,'-', cil_anio) from ra_cil_ciclo where cil_codigo = @codcil

	declare @ins table (ins_codigo int, ins_codper int, mai_codmat nvarchar(12), mai_codhpl int, mai_matricula int, mai_estado nvarchar(5))
	declare @insesp table (codigo int, codper int, mai_codmat nvarchar(12), mai_codhor int, mai_matricula int, mai_estado nvarchar(5))

	SELECT per_carnet, rtrim(per_nombres) +' '+ltrim(per_apellidos) as nombre_ape,pla_alias_carrera, pla_anio,
	concat('Clave de inscripción: ', isnull(ins_clave,'PRESENCIAL'),', Fecha de inscripción: ', Convert(varchar,ins_fecha))as fecha_ins,
	@cicloins cicloins, ins_codigo, (select top 1 InicioCiclo from @tbl_inicio_clases) InicioCiclo
	from ra_pla_planes 
	inner join ra_alc_alumnos_carrera ON ra_pla_planes.pla_codigo = ra_alc_alumnos_carrera.alc_codpla 
	inner join ra_per_personas ON ra_alc_alumnos_carrera.alc_codper = ra_per_personas.per_codigo 
	inner join ra_ins_inscripcion with (nolock) on ins_codper = per_codigo and ins_codcil = @codcil
	where ra_per_personas.per_codigo = @codper

	insert into @ins(ins_codigo, ins_codper, mai_codmat, mai_codhpl, mai_matricula, mai_estado)
	select ins_codigo, ins_codper, mai_codmat, mai_codhpl, mai_matricula, mai_estado
	from ra_ins_inscripcion with (nolock)
	join ra_mai_mat_inscritas with (nolock) on mai_codins = ins_codigo
	where ins_codcil = @codcil and ins_codper = @codper

	insert into @insesp(codigo, codper, mai_codmat, mai_codhor, mai_matricula, mai_estado)
	select ins_codigo codigo, ins_codper codper, mai_codmat, mai_codhor, mai_matricula, mai_estado
	from ra_ins_inscripcion with (nolock)
	join ra_mai_mat_inscritas_especial with (nolock) on mai_codins = ins_codigo
	where ins_codcil = @codcil and ins_codper = @codper
	
	select rtrim(mat_codigo) mat_codigo,materia, hpl_descripcion,estado, mai_matricula, horas,
	case when dias <> '' then dias else dbo.fechas_materias_especiales(hpl_codigo) 
	end as dias,aul_nombre_corto
	from
	(
		select mat_codigo, rtrim(Isnull(plm_alias,'')) + 
		case when tpm_mostrar_descripcion = 1 then ' (' + tpm_descripcion + ')'
			when tpm_mostrar_descripcion = 0 then ' '
		end as Materia, hpl_descripcion, hpl_codigo,
		case when mai_estado = 'I' then 'Ins' else 'Ret' end estado, mai_matricula,
		isnull(man_nomhor,'sin Asignar')as horas,
		case when hpl_lunes = 'S' then 'LUNES-' ELSE '' END + 
		case when hpl_martes = 'S' then 'MARTES-' ELSE '' END + 
		case when hpl_miercoles = 'S' then 'MIERCOLES-' ELSE '' END + 
		case when hpl_jueves = 'S' then 'JUEVES-' ELSE '' END + 
		case when hpl_viernes = 'S' then 'VIERNES-' ELSE '' END + 
		case when hpl_sabado = 'S' then 'SABADO-' ELSE '' END + 
		case when hpl_domingo = 'S' then 'DOMINGO-' ELSE '' END DIAS,aul_nombre_corto
		from @ins
		join ra_per_personas on per_codigo = ins_codper
		join ra_alc_alumnos_carrera on alc_codper = per_codigo
		join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
		join dbo.ra_man_grp_hor on man_codigo = hpl_codman
		join ra_mat_materias on mat_codigo = mai_codmat
		join ra_plm_planes_materias on plm_codpla = alc_codpla and plm_codmat = mai_codmat
		left join ra_aul_aulas on aul_codigo = hpl_codaul
		join ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia

		union 

		select case when hpl_tipo_materia in ('A', 'I') then concat(ltrim(rtrim(mat_codigo)), hpl_tipo_materia)
		else ltrim(rtrim(mat_codigo)) end mat_codigo,
		--concat(ltrim(rtrim(mat_codigo)), hpl_tipo_materia) mat_codigo, 
		rtrim(Isnull(mat_nombre,'')) + 
		case when tpm_mostrar_descripcion = 1 then ' (' + tpm_descripcion + ')'
			when tpm_mostrar_descripcion = 0 then ' '
		end as Materia, hpl_descripcion, hpl_codigo,
		case when mai_estado = 'I' then 'Ins' else 'Ret' end estado, mai_matricula,
		isnull(man_nomhor,'sin Asignar')as horas,
		case when hpl_lunes = 'S' then 'LUNES-' ELSE '' END + 
		case when hpl_martes = 'S' then 'MARTES-' ELSE '' END + 
		case when hpl_miercoles = 'S' then 'MIERCOLES-' ELSE '' END + 
		case when hpl_jueves = 'S' then 'JUEVES-' ELSE '' END + 
		case when hpl_viernes = 'S' then 'VIERNES-' ELSE '' END + 
		case when hpl_sabado = 'S' then 'SABADO-' ELSE '' END + 
		case when hpl_domingo = 'S' then 'DOMINGO-' ELSE '' END DIAS,aul_nombre_corto
		from @insesp
		join ra_per_personas on per_codigo = codper
		join ra_alc_alumnos_carrera on alc_codper = per_codigo
		join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhor
		join dbo.ra_man_grp_hor on man_codigo = hpl_codman
		join ra_mat_materias on mat_codigo = mai_codmat
		left join ra_aul_aulas on aul_codigo = hpl_codaul
		join ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia
	) t
end


-- =============================================
	-- Author:      <Todos>
	-- Create date: <Miercoles 20 Mayo 2020>
	-- Description: <Retorna el encabezado (ra_ins) y el detalle (ra_mai) de las materias inscritas>
	-- =============================================
	-- exec web_ins_matinscritas_nodjs_azure 228534, 125

ALTER procedure [dbo].[web_ins_matinscritas_nodjs_azure]
	@codper int,
	@codcil int 
as
begin
	declare @cicloins nvarchar(10)

	declare @tbl_inicio_clases as table (InicioCiclo varchar(125))

	insert into @tbl_inicio_clases (InicioCiclo)
	exec dbo.ra_fic_fecha_inicio_ciclo @codcil
	
	select @cicloins =concat('0', cil_codcic,'-', cil_anio) from ra_cil_ciclo where cil_codigo = @codcil

	declare @ins table (ins_codigo int, ins_codper int, mai_codmat nvarchar(12), mai_codhpl int, mai_matricula int, mai_estado nvarchar(5))
	declare @insesp table (codigo int, codper int, mai_codmat nvarchar(12), mai_codhor int, mai_matricula int, mai_estado nvarchar(5))

	SELECT per_carnet, rtrim(per_nombres) +' '+ltrim(per_apellidos) as nombre_ape,pla_alias_carrera, pla_anio,
	concat('Clave de inscripción: ', isnull(ins_clave,'PRESENCIAL'),', Fecha de inscripción: ', Convert(varchar,ins_fecha))as fecha_ins,
	@cicloins cicloins, ins_codigo, (select top 1 InicioCiclo from @tbl_inicio_clases) InicioCiclo
	from ra_pla_planes 
	inner join ra_alc_alumnos_carrera ON ra_pla_planes.pla_codigo = ra_alc_alumnos_carrera.alc_codpla 
	inner join ra_per_personas ON ra_alc_alumnos_carrera.alc_codper = ra_per_personas.per_codigo 
	inner join Inscripcion.dbo.ra_ins_inscripcion with (nolock) on ins_codper = per_codigo and ins_codcil = @codcil
	where ra_per_personas.per_codigo = @codper

	insert into @ins(ins_codigo, ins_codper, mai_codmat, mai_codhpl, mai_matricula, mai_estado)
	select ins_codigo, ins_codper, mai_codmat, mai_codhpl, mai_matricula, mai_estado
	from Inscripcion.dbo.ra_ins_inscripcion with (nolock)
	join Inscripcion.dbo.ra_mai_mat_inscritas with (nolock) on mai_codins = ins_codigo
	where ins_codcil = @codcil and ins_codper = @codper

	insert into @insesp(codigo, codper, mai_codmat, mai_codhor, mai_matricula, mai_estado)
	select ins_codigo codigo, ins_codper codper, mai_codmat, mai_codhor, mai_matricula, mai_estado
	from Inscripcion.dbo.ra_ins_inscripcion with (nolock)
	join Inscripcion.dbo.ra_mai_mat_inscritas_especial with (nolock) on mai_codins = ins_codigo
	where ins_codcil = @codcil and ins_codper = @codper

	select rtrim(mat_codigo) mat_codigo,materia, hpl_descripcion,estado, mai_matricula, horas,
	case when dias <> '' then dias else dbo.fechas_materias_especiales(hpl_codigo) 
	end as dias,aul_nombre_corto
	from
	(
		select mat_codigo, rtrim(Isnull(plm_alias,'')) + 
		case when tpm_mostrar_descripcion = 1 then ' (' + tpm_descripcion + ')'
			when tpm_mostrar_descripcion = 0 then ' '
		end as Materia, hpl_descripcion, hpl_codigo,
		case when mai_estado = 'I' then 'Ins' else 'Ret' end estado, mai_matricula,
		isnull(man_nomhor,'sin Asignar')as horas,
		case when hpl_lunes = 'S' then 'LUNES-' ELSE '' END + 
		case when hpl_martes = 'S' then 'MARTES-' ELSE '' END + 
		case when hpl_miercoles = 'S' then 'MIERCOLES-' ELSE '' END + 
		case when hpl_jueves = 'S' then 'JUEVES-' ELSE '' END + 
		case when hpl_viernes = 'S' then 'VIERNES-' ELSE '' END + 
		case when hpl_sabado = 'S' then 'SABADO-' ELSE '' END + 
		case when hpl_domingo = 'S' then 'DOMINGO-' ELSE '' END DIAS,aul_nombre_corto
		from @ins
		join ra_per_personas on per_codigo = ins_codper
		join ra_alc_alumnos_carrera on alc_codper = per_codigo
		join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
		join dbo.ra_man_grp_hor on man_codigo = hpl_codman
		join ra_mat_materias on mat_codigo = mai_codmat
		join ra_plm_planes_materias on plm_codpla = alc_codpla and plm_codmat = mai_codmat
		left join ra_aul_aulas on aul_codigo = hpl_codaul
		join ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia

		union 

		select 
		case when hpl_tipo_materia in ('A', 'I') then concat(ltrim(rtrim(mat_codigo)), hpl_tipo_materia)
		else ltrim(rtrim(mat_codigo)) end mat_codigo,
		--concat(ltrim(rtrim(mat_codigo)), hpl_tipo_materia) mat_codigo, 
		rtrim(Isnull(mat_nombre,'')) + 
		case when tpm_mostrar_descripcion = 1 then ' (' + tpm_descripcion + ')'
			when tpm_mostrar_descripcion = 0 then ' '
		end as Materia, hpl_descripcion, hpl_codigo,
		case when mai_estado = 'I' then 'Ins' else 'Ret' end estado, mai_matricula,
		isnull(man_nomhor,'sin Asignar')as horas,
		case when hpl_lunes = 'S' then 'LUNES-' ELSE '' END + 
		case when hpl_martes = 'S' then 'MARTES-' ELSE '' END + 
		case when hpl_miercoles = 'S' then 'MIERCOLES-' ELSE '' END + 
		case when hpl_jueves = 'S' then 'JUEVES-' ELSE '' END + 
		case when hpl_viernes = 'S' then 'VIERNES-' ELSE '' END + 
		case when hpl_sabado = 'S' then 'SABADO-' ELSE '' END + 
		case when hpl_domingo = 'S' then 'DOMINGO-' ELSE '' END DIAS,aul_nombre_corto
		from @insesp
		join ra_per_personas on per_codigo = codper
		join ra_alc_alumnos_carrera on alc_codper = per_codigo
		join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhor
		join dbo.ra_man_grp_hor on man_codigo = hpl_codman
		join ra_mat_materias on mat_codigo = mai_codmat
		left join ra_aul_aulas on aul_codigo = hpl_codaul
		join ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia
	) t
end



--#endregion CAMBIOS SP´S POR LAS INSTRUCTORIAS hpl_tipo_materia = 'A'