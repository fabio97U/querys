--select * from ra_cil_ciclo
-- drop table ra_egrpa_egresados_procesos_anterior
create table ra_egrpa_egresados_procesos_anterior (
	egrpa_codigo int primary key identity (1, 1),
	egrpa_codper int not null,
	egrpa_codcil_proceso_original int not null,
	egrpa_codimp_proceso_original int null,
	egrpa_codrte_proceso_original int null,
	egrpa_codcil_nuevo_proceso int not null,
	egrpa_codimp_nuevo_proceso_actual int null,
	egrpa_comentario varchar(2048) null,

	egrpa_codusr int,
	egrpa_fecha_creacion datetime default getdate()
)
-- select * from ra_egrpa_egresados_procesos_anterior
insert into ra_egrpa_egresados_procesos_anterior (egrpa_codper, egrpa_codcil_proceso_original, egrpa_codimp_proceso_original, egrpa_codcil_nuevo_proceso, egrpa_codusr)
values (151612, 119, 23536, 134, 407),
(198465, 129, 32301, 131, 407)

select * from ra_per_personas where per_codigo = 151612
select * from ra_eqn_equivalencia_notas order by eqn_codigo desc
update ra_per_personas set per_estado = 'E' where per_codigo in (151612, 198465)
update ra_equ_equivalencia_universidad set equ_codper = 151612 where equ_codigo = 13109
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2024-03-18 22:00:30.650>
	-- Description: <Realiza el matenimiento a la tabla "ra_egrpa">
	-- =============================================
	-- exec dbo.sp_ra_egrpa_egresados_procesos_anterior 1, 181324
	-- exec dbo.sp_ra_egrpa_egresados_procesos_anterior 1, 168640
create or alter procedure sp_ra_egrpa_egresados_procesos_anterior
	@opcion int = 0,
	@codper int = 0,
	@carnet varchar(30) = ''
as
begin
	
	if @opcion = 1
	begin
		--select * from vst_inscripcion_preespecialidad where codper = @codper and isnull(codegrpa, '') = ''
		if exists (select 1 from vst_inscripcion_preespecialidad where codper = @codper and tipo in ('TESIS'))
		begin
			print 'Es posible de tesis'
			select codegrpa, tipo, carrera, carnet, estudiante, '*TESIS*' preespecialidad, codcil_original, ciclo_original, fecha_inscripcion, codegrpa, codcil_nuevo_proceso, ciclo_nuevo_proceso, 
				codigo_origen_inscripcion, egrpa_fecha_creacion, egrpa_comentario, tabla
			from vst_inscripcion_preespecialidad where codper = @codper and tipo in ('TESIS')
			order by fecha_inscripcion desc
		end
		else
		begin
			print 'Es de preespecialidad o proceso graduacion tecnicos'
			select codegrpa, tipo, carrera, carnet, estudiante, preespecialidad, codcil_original, ciclo_original, fecha_inscripcion, codegrpa, codcil_nuevo_proceso, ciclo_nuevo_proceso, 
				codigo_origen_inscripcion, egrpa_fecha_creacion, egrpa_comentario, tabla
			from vst_inscripcion_preespecialidad where codper = @codper and tipo not in ('TESIS') 
			order by fecha_inscripcion desc
		end
	end
end
go
	
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2024-03-18 15:53:45.740>
	-- Description: <Retorna los inscritos en la preespecialidad unido con los añadidos de procesos anteriores>
	-- =============================================
	-- select * from vst_inscripcion_preespecialidad where codper = 168640 order by carrera, pla_anio, preespecialidad
	-- select * from vst_inscripcion_preespecialidad where codper = 181324 order by carrera, pla_anio, preespecialidad
create or alter view vst_inscripcion_preespecialidad
as
	select tipo 'tipo', carrera, pla_anio, codpla, tabla, codigo_origen_inscripcion,  imp_codmpr, imp_codapr, imp_codhmp, imp_estado,
		codper, carnet, estudiante, estado_alumno, 
		codcil_original, ciclo_original, 
		isnull(codcil_nuevo_proceso, codcil_original) 'codcil', 
		case 
			when codcil_nuevo_proceso is null then ciclo_original 
			when codcil_nuevo_proceso is not null then concat(ciclo_nuevo_proceso, ' (orig: ',  ciclo_original, ')')  
			else '*' 
		end 'ciclo',
		preespecialidad, fecha_inscripcion, clave_inscripcion,
		codegrpa, codcil_nuevo_proceso, ciclo_nuevo_proceso, egrpa_fecha_creacion, egrpa_comentario, correo, facultad, escuela
	from (
		select 'licenciatura' 'tipo', pla_alias_carrera 'carrera', pla_anio, pla_codigo 'codpla', 
			'imp' 'tabla', imp_codigo 'codigo_origen_inscripcion', imp_codmpr, imp_codapr, imp_codhmp, imp_estado,
			imp_codper 'codper',
			per_carnet 'carnet', per_nombres_apellidos 'estudiante', per_estado 'estado_alumno', 
			cil.cil_codigo 'codcil_original', concat('0', cil.cil_codcic, '-', cil.cil_anio) 'ciclo_original', 
			isnull(cil2.cil_codigo, cil.cil_codigo) 'codcil', concat('0', cil.cil_codcic, '-', cil.cil_anio) 'ciclo', 
			mpr.mpr_nombre 'preespecialidad', imp_fecha_ingreso 'fecha_inscripcion', imp_clave 'clave_inscripcion',
			egrpa_codigo 'codegrpa', 
			cil2.cil_codigo 'codcil_nuevo_proceso', concat('0', cil2.cil_codcic, '-', cil2.cil_anio) 'ciclo_nuevo_proceso', egrpa_fecha_creacion, egrpa_comentario
			, per_correo_institucional 'correo', fac_nombre 'facultad', esc_nombre 'escuela'
		from dbo.pg_pre_preespecializacion pre
			inner join pg_mpr_modulo_preespecializacion mpr on mpr.mpr_codpre = pre.pre_codigo
			inner join pg_apr_aut_preespecializacion apr on apr.apr_codpre = mpr.mpr_codpre
			inner join dbo.ra_cil_ciclo cil on apr.apr_codcil = cil.cil_codigo
			inner join pg_imp_ins_especializacion on imp_codapr = apr_codigo
			inner join ra_per_personas on imp_codper = per_codigo
			inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
			inner join ra_pla_planes on alc_codpla = pla_codigo

			inner join ra_car_carreras on pla_codcar = car_codigo
			inner join ra_esc_escuelas on car_codesc = esc_codigo
			inner join ra_fac_facultades on fac_codigo = esc_codfac

			left join ra_egrpa_egresados_procesos_anterior egrpa on imp_codigo = egrpa_codimp_proceso_original
			left join dbo.ra_cil_ciclo cil2 on egrpa.egrpa_codcil_nuevo_proceso = cil2.cil_codigo
		where mpr.mpr_visible = 'N'

			union all

		select 'tecnicos' 'tipo', pla_alias_carrera 'carrera', pla_anio, pla_codigo 'codpla', 
			'rte' 'tabla', rte_codigo 'codigo_origen_inscripcion', null 'imp_codmpr', null 'imp_codapr', null 'imp_codhmp', null 'imp_estado',
			rte_codper 'codper',
			per_carnet 'carnet', per_nombres_apellidos 'estudiante', per_estado, 
			cil.cil_codigo 'codcil_original', concat('0', cil.cil_codcic, '-', cil.cil_anio) 'ciclo_original', 
			isnull(cil2.cil_codigo, cil.cil_codigo) 'codcil', concat('0', cil.cil_codcic, '-', cil.cil_anio) 'ciclo', 
			'Proceso de graduacion tecnicos' 'preespecialidad', rte_fecha_registro 'fecha_inscripcion', null 'clave_inscripcion', egrpa_codigo 'codegrpa', 
			cil2.cil_codigo 'codcil_nuevo_proceso',concat('0', cil2.cil_codcic, '-', cil2.cil_anio) 'ciclo_nuevo_proceso', egrpa_fecha_creacion, egrpa_comentario
			, per_correo_institucional 'correo', fac_nombre 'facultad', esc_nombre 'escuela'
		from dbo.ra_rte_registro_tecnicos_egresados rte
			
			inner join dbo.ra_cil_ciclo cil on rte.rte_codcil = cil.cil_codigo
			inner join ra_per_personas on rte_codper = per_codigo
			inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
			inner join ra_pla_planes on alc_codpla = pla_codigo
			inner join ra_car_carreras on pla_codcar = car_codigo
			inner join ra_esc_escuelas on car_codesc = esc_codigo
			inner join ra_fac_facultades on fac_codigo = esc_codfac

			left join ra_egrpa_egresados_procesos_anterior egrpa on egrpa_codrte_proceso_original = rte_codigo
			left join dbo.ra_cil_ciclo cil2 on egrpa.egrpa_codcil_nuevo_proceso = cil2.cil_codigo

			union all

		select case when egrpa_codigo is null then 'TESIS' else 
			case when car_tipo = 'T' then 'tecnicos (TESIS)' else 'licenciatura (TESIS)' end
			end 'tipo', pla_alias_carrera 'carrera', pla_anio, pla_codigo 'codpla', 
			case when egrpa_codigo is null then '*' else 'egrpa' end 'tabla', 0 'codigo_origen_inscripcion', null 'imp_codmpr', null 'imp_codapr', null 'imp_codhmp', null 'imp_estado',
			alc_codper 'codper',
			per_carnet 'carnet', per_nombres_apellidos 'estudiante', per_estado, 
			0 'codcil_original', 'TESIS' 'ciclo_original', 
			isnull(cil2.cil_codigo, 0) 'codcil', '' 'ciclo', 
			'*' 'preespecialidad', per_fecha_ingreso 'fecha_inscripcion', null 'clave_inscripcion', egrpa_codigo 'codegrpa', 
			cil2.cil_codigo 'codcil_nuevo_proceso',concat('0', cil2.cil_codcic, '-', cil2.cil_anio) 'ciclo_nuevo_proceso', egrpa_fecha_creacion, egrpa_comentario
			, per_correo_institucional 'correo', fac_nombre 'facultad', esc_nombre 'escuela'
		from ra_per_personas 
			inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
			inner join ra_pla_planes on alc_codpla = pla_codigo
			inner join ra_car_carreras on pla_codcar = car_codigo

			inner join ra_esc_escuelas on car_codesc = esc_codigo
			inner join ra_fac_facultades on fac_codigo = esc_codfac

			left join ra_egrpa_egresados_procesos_anterior egrpa on egrpa_codper = per_codigo
			left join dbo.ra_cil_ciclo cil2 on egrpa.egrpa_codcil_nuevo_proceso = cil2.cil_codigo

			left join ra_rte_registro_tecnicos_egresados on rte_codper = per_codigo --and rte_codper is null
			left join pg_imp_ins_especializacion on imp_codper = per_codigo --and imp_codper is null
		where rte_codper is null and imp_codper is null
	) t
go

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_mod_pre_equivalencias]    Script Date: 18/3/2024 19:54:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:		<Fabio>
	-- Create date: <2022-12-04 07:40:55.174>
	-- Description:	<reporte modulos reprobados prees. de los estudiantes con equivalencias, 
				-- es una copia de "exec dbo.rep_mod_reprobados_pre":
					-- No se pudo usar el mismo SP por que aumentaba el tiempo de la consulta hasta 6 minutos y el original solo muestra reprobados>
	-- =============================================
	-- exec dbo.rep_mod_pre_equivalencias 136, 0
ALTER PROCEDURE [dbo].[rep_mod_pre_equivalencias]
	@codcil int,
	@codfac int
AS
BEGIN
	set nocount on;

	select
		pre_nombre, car_nombre, per_carnet, per_apellidos_nombres, imp_codmpr, mpr_nombre, N1, N2, N3, N4, N5, N6, N7, N8, (est - sinNota) est, apro, 
		sinNota, cuotas, nota_final, per_correo_institucional, per_email, cant_equivalencias
	from ( 
		select pre_nombre, car_nombre, per_carnet, per_apellidos_nombres, imp_codmpr, mpr_nombre,
			isnull(sum([1]), 0) N1, isnull(sum([2]), 0) N2, isnull(sum([3]), 0) N3, isnull(sum([4]), 0) N4, 
			isnull(sum([5]), 0) N5, isnull(sum([6]), 0) N6, isnull(sum([9]), 0) N7, isnull(sum([10]), 0) N8, 
			isnull(sum(est),0) est, isnull(sum(sinNota), 0) sinNota, isnull(max(cuotas), 0) cuotas,
			isnull((select nota
			from notas_pre_esp v
			where v.imp_codper = per_codigo
			  and v.imp_codapr = tt.apr_codigo
			  and v.imp_codmpr = tt.mpr_codigo)
			 , 0) nota_final, per_correo_institucional, per_email, isnull(sum(apro),0) apro, cant_equivalencias
		from (
			select per_codigo, 
			per_carnet , per_apellidos_nombres, 
			timp.codigo_origen_inscripcion imp_codigo,nmp_codigo,imp_codmpr,mpr_nombre,
			mpr_codigo, apr_codigo, 
			case when timp.codcil_nuevo_proceso is not null then concat(pre_nombre, ' (Origen: ', timp.ciclo_original, ')') else pre_nombre end pre_nombre
			, 
			car_nombre, per_correo_institucional, per_email, 
			nmp_codpmp, round(nmp_nota,2) nmp_nota, iif((round(nmp_nota,2) < 7 and exists (
				(select 1
				from pg_nmp_notas_mod_especializacion cnmp
				join pg_imp_ins_especializacion cimp on cimp.imp_codigo = cnmp.nmp_codimp
				where cnmp.nmp_bandera = 1 and cimp.imp_codhmp = timp.imp_codhmp and cnmp.nmp_codpmp = tnmp.nmp_codpmp )
			) ), 1, 0) est,

			iif((round(nmp_nota,2) >= 6.96 and exists (
				(select 1
				from pg_nmp_notas_mod_especializacion cnmp
				join pg_imp_ins_especializacion cimp on cimp.imp_codigo = cnmp.nmp_codimp
				where cnmp.nmp_bandera = 1 and cimp.imp_codhmp = timp.imp_codhmp and cnmp.nmp_codpmp = tnmp.nmp_codpmp )
			) ), 1, 0) apro,

			iif((round(nmp_nota,2) = 0 and exists (
				(select 1
				from pg_nmp_notas_mod_especializacion cnmp
				join pg_imp_ins_especializacion cimp on cimp.imp_codigo = cnmp.nmp_codimp
				where cnmp.nmp_bandera = 1 and cimp.imp_codhmp = timp.imp_codhmp and cnmp.nmp_codpmp = tnmp.nmp_codpmp )
			) ), 1, 0) sinNota,
			(
				select COUNT(distinct(are_cuota)) from col_mov_movimientos 
					join col_dmo_det_mov on dmo_codmov = mov_codigo
					join vst_Aranceles_x_Evaluacion v on v.are_codtmo = dmo_codtmo
					where dmo_codcil = apr_codcil and mov_codper = per_codigo 
					and are_cuota <> 0 and mov_estado <> 'A'
			) cuotas,
			(select count(distinct eqn_codmat) from ra_equ_equivalencia_universidad 
			inner join ra_eqn_equivalencia_notas on eqn_codequ = equ_codigo 
			where equ_codper = per.per_codigo and eqn_nota >= 5.96) 'cant_equivalencias'
			from pg_nmp_notas_mod_especializacion tnmp
				--join pg_imp_ins_especializacion timp on imp_codigo = nmp_codimp 
				join vst_inscripcion_preespecialidad timp on codigo_origen_inscripcion = nmp_codimp and tabla = 'imp'
				join pg_mpr_modulo_preespecializacion on mpr_codigo = imp_codmpr
				join pg_apr_aut_preespecializacion on apr_codigo = imp_codapr
				join pg_pre_preespecializacion on pre_codigo = apr_codpre
				join ra_per_personas per on per_codigo = timp.codper
				join ra_alc_alumnos_carrera on alc_codper = per_codigo
				join ra_pla_planes on pla_codigo = alc_codpla
				join ra_car_carreras on car_codigo = pla_codcar
			where nmp_codpmp not in(7,8) and imp_estado <> 'R' and per_estado = 'E' 
				--and apr_codcil = @codcil 
				and codcil = @codcil
				and car_codfac = iif(@codfac = 0, car_codfac, @codfac) 
				
				and alc_codper in (
					select distinct equ_codper from ra_equ_equivalencia_universidad
				)
		) t
		pivot(
			sum(nmp_nota)
			for nmp_codpmp in ([1], [2], [3], [4], [5], [6], [9], [10])
		) as tt
		group by imp_codigo, per_codigo, per_carnet, per_apellidos_nombres, imp_codmpr, mpr_nombre, 
			mpr_codigo, apr_codigo, pre_nombre, car_nombre, per_correo_institucional, per_email, cant_equivalencias
		--having isnull(sum(est), 0) > 0
	) t
	order by pre_nombre, car_nombre, per_apellidos_nombres
end
go

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_mod_reprobados_pre]    Script Date: 18/3/2024 20:42:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:		<Adones C.>
	-- Create date: <24/10/2022>
	-- Last Modify: <Fabio, 2024-03-18 21:06:32.930>
	-- Description:	<reporte modulos reprobados prees.>
	-- =============================================
	-- exec dbo.rep_mod_reprobados_pre 131, 1, 15--96
ALTER PROCEDURE [dbo].[rep_mod_reprobados_pre]
	@codcil int,
	@aprobados int, -- 1: aprobados, 0: reprobados
	@codfac int
AS
BEGIN
	set nocount on;
	
	declare @pre_de varchar(50) = '', @facultad varchar(100) = ''

	select @facultad = fac_nombre from ra_fac_facultades where fac_codigo = @codfac
	select @pre_de = concat(case when cil_codcic = 1 then 'MARZO' else 'AGOSTO' end, ' 0', cil_codcic, '-', cil_anio ) 
	from ra_cil_ciclo where cil_codigo = @codcil

	select 
		pre_nombre, car_nombre, per_carnet, per_apellidos_nombres, imp_codmpr, mpr_nombre, N1, N2, N3, N4, N5, N6, N7, N8, (est - sinNota) est, 
		apro, sinNota, cuotas, nota_final, per_correo_institucional, per_email, 
		case when @aprobados = 1 then 'APROBADOS' else 'REPROBADOS' end 'estado', @pre_de 'pre_de', @facultad 'facultad'
	from ( 
		select pre_nombre, car_nombre, per_carnet, per_apellidos_nombres, imp_codmpr, mpr_nombre,
			isnull(sum([1]), 0) N1, isnull(sum([2]), 0) N2, isnull(sum([3]), 0) N3, isnull(sum([4]), 0) N4, 
			isnull(sum([5]), 0) N5, isnull(sum([6]), 0) N6, isnull(sum([9]), 0) N7, isnull(sum([10]), 0) N8, 
			isnull(sum(est),0) est, isnull(sum(sinNota), 0) sinNota, isnull(max(cuotas), 0) cuotas,
			isnull((select nota
			from notas_pre_esp v
			where v.imp_codper = per_codigo
			  and v.imp_codapr = tt.apr_codigo
			  and v.imp_codmpr = tt.mpr_codigo)
			 , 0) nota_final, per_correo_institucional, per_email, isnull(sum(apro),0) apro
		from (
			select per_codigo,per_carnet, per_apellidos_nombres, codigo_origen_inscripcion imp_codigo,nmp_codigo,imp_codmpr,mpr_nombre,
			mpr_codigo, apr_codigo, 
			case when timp.codcil_nuevo_proceso is not null then concat(pre_nombre, ' (Origen: ', timp.ciclo_original, ')') else pre_nombre end pre_nombre, 
			car_nombre, per_correo_institucional, per_email, 
			nmp_codpmp, round(nmp_nota,2) nmp_nota, iif((round(nmp_nota,2) < 7 and exists (
				(select 1
				from pg_nmp_notas_mod_especializacion cnmp
				join pg_imp_ins_especializacion cimp on cimp.imp_codigo = cnmp.nmp_codimp
				where cnmp.nmp_bandera = 1 and cimp.imp_codhmp = timp.imp_codhmp and cnmp.nmp_codpmp = tnmp.nmp_codpmp )
			) ), 1, 0) est,

			iif((round(nmp_nota,2) >= 6.96 and exists (
				(select 1
				from pg_nmp_notas_mod_especializacion cnmp
				join pg_imp_ins_especializacion cimp on cimp.imp_codigo = cnmp.nmp_codimp
				where cnmp.nmp_bandera = 1 and cimp.imp_codhmp = timp.imp_codhmp and cnmp.nmp_codpmp = tnmp.nmp_codpmp )
			) ), 1, 0) apro,

			iif((round(nmp_nota,2) = 0 and exists (
				(select 1
				from pg_nmp_notas_mod_especializacion cnmp
				join pg_imp_ins_especializacion cimp on cimp.imp_codigo = cnmp.nmp_codimp
				where cnmp.nmp_bandera = 1 and cimp.imp_codhmp = timp.imp_codhmp and cnmp.nmp_codpmp = tnmp.nmp_codpmp )
			) ), 1, 0) sinNota,
			(
				select COUNT(distinct(are_cuota)) from col_mov_movimientos 
					join col_dmo_det_mov on dmo_codmov = mov_codigo
					join vst_Aranceles_x_Evaluacion v on v.are_codtmo = dmo_codtmo
					where dmo_codcil = apr_codcil and mov_codper = per_codigo 
					and are_cuota <> 0 and mov_estado <> 'A'
			) cuotas
			from pg_nmp_notas_mod_especializacion tnmp
				--join pg_imp_ins_especializacion timp on imp_codigo = nmp_codimp 
				join vst_inscripcion_preespecialidad timp on codigo_origen_inscripcion = nmp_codimp and tabla = 'imp'
				join pg_mpr_modulo_preespecializacion on mpr_codigo = imp_codmpr
				join pg_apr_aut_preespecializacion on apr_codigo = imp_codapr
				join pg_pre_preespecializacion on pre_codigo = apr_codpre
				join ra_per_personas on per_codigo = codper
				join ra_alc_alumnos_carrera on alc_codper = per_codigo
				join ra_pla_planes on pla_codigo = alc_codpla
				join ra_car_carreras on car_codigo = pla_codcar
			where nmp_codpmp not in(7,8) and imp_estado <> 'R' and per_estado = 'E' 
				--and apr_codcil = @codcil 
				and codcil = @codcil
				and car_codfac = iif(@codfac = 0, car_codfac, @codfac) 
				--and alc_codper = 199538
		) t
		pivot(
			sum(nmp_nota)
			for nmp_codpmp in ([1], [2], [3], [4], [5], [6], [9], [10])
		) as tt
		group by imp_codigo, per_codigo, per_carnet, per_apellidos_nombres, imp_codmpr, mpr_nombre, 
			mpr_codigo, apr_codigo, pre_nombre, car_nombre, per_correo_institucional, per_email--, apro
	) t
	where iif(est > 0, 0, 1) = @aprobados
	order by pre_nombre, car_nombre, per_apellidos_nombres
end
go

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rpt_rgpe_reporte_graduacion_preespecialidad]    Script Date: 18/3/2024 21:06:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:		<>
	-- Create date: <>
	-- Last Modify: <Fabio, 2024-03-18 21:06:32.930>
	-- Description:	<Devuelve el listado de los estudiantes que se van a graduar>
	-- =============================================
	-- exec rpt_rgpe_reporte_graduacion_preespecialidad 136
ALTER PROCEDURE [dbo].[rpt_rgpe_reporte_graduacion_preespecialidad]
	@codcil int
as
begin
	set nocount on;

	select rank() OVER (Partition BY fac_nombre, car_nombre, pre_nombre, hmp_descripcion order by per_apellidos_nombres) as correlativo,
		'0' + cast(cil_codcic as varchar(1)) + '-' + cast(cil_anio as nvarchar(4)) as ciclo, fac_nombre,
		car_nombre, pre_codigo, hmp_descripcion as seccion, 
		case when codcil_nuevo_proceso is not null then concat(pre_nombre, ' (Origen: ', ciclo_original, ')') else pre_nombre end pre_nombre, 
		codper imp_codper, per_carnet, dbo.mayuscula_inicial(per_nombres_apellidos) as Alumno, per_email
	from vst_inscripcion_preespecialidad--pg_imp_ins_especializacion 
		inner join pg_apr_aut_preespecializacion on apr_codigo = imp_codapr and tabla = 'imp'
		inner join pg_pre_preespecializacion on pre_codigo =  apr_codpre 
		inner join ra_per_personas on per_codigo = codper 
		inner join ra_car_carreras on car_identificador = substring(per_carnet,1,2) 
		inner join ra_cil_ciclo on cil_codigo = apr_codcil 
		inner join ra_cic_ciclos on cil_codcic = cic_codigo 
		inner join ra_fac_facultades on fac_codigo = car_codfac
		inner join pg_hmp_horario_modpre on imp_codapr = hmp_codapr and imp_codmpr = hmp_codmpr and imp_codapr = apr_codigo and imp_codhmp = hmp_codigo
	where codcil = @codcil
		union all
	select rank() OVER (Partition BY fac_nombre, car_nombre, carrera, '01' order by per_apellidos_nombres) as correlativo,
		'0' + cast(cil_codcic as varchar(1)) + '-' + cast(cil_anio as nvarchar(4)) as ciclo, fac_nombre,
		car_nombre, codigo_origen_inscripcion pre_codigo, '01' as seccion, 
		case when codcil_nuevo_proceso is not null then concat(carrera, ' (Origen: ', ciclo_original, ')') else carrera end pre_nombre, 
		codper imp_codper, per_carnet, dbo.mayuscula_inicial(per_nombres_apellidos) as Alumno, per_email
	from vst_inscripcion_preespecialidad--pg_imp_ins_especializacion 
		inner join ra_rte_registro_tecnicos_egresados on codigo_origen_inscripcion = rte_codigo and tipo = 'tecnicos'
		--inner join pg_pre_preespecializacion on pre_codigo =  apr_codpre 
		inner join ra_per_personas on per_codigo = codper 
		inner join ra_car_carreras on car_identificador = substring(per_carnet,1,2) 
		inner join ra_cil_ciclo on cil_codigo = codcil 
		inner join ra_cic_ciclos on cil_codcic = cic_codigo 
		inner join ra_fac_facultades on fac_codigo = car_codfac
		--inner join pg_hmp_horario_modpre on imp_codapr = hmp_codapr and imp_codmpr = hmp_codmpr and imp_codapr = apr_codigo and imp_codhmp = hmp_codigo
	where codcil = @codcil
		union all
	select rank() OVER (Partition BY facultad, carrera, carrera, '01' order by estudiante) as correlativo,
		ciclo as ciclo, facultad fac_nombre,
		carrera car_nombre, codigo_origen_inscripcion pre_codigo, '01' as seccion, 
		case when codcil_nuevo_proceso is not null then concat(carrera, ' (Origen: ', ciclo_original, ')') else carrera end pre_nombre, 
		codper imp_codper, carnet, dbo.mayuscula_inicial(estudiante) as Alumno, correo per_email
	from vst_inscripcion_preespecialidad
	where codcil = @codcil and codegrpa is not null and tabla = 'egrpa'

END
go