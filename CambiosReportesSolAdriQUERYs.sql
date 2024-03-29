/*
1)
--https://portalempresarial.utec.edu.sv/uonline/privado/reportes.aspx?reporte=rep_postgrado_lisal_listado_alumnos&filas=2&campo0=119&campo1=226 
POSTGRADO: "POSTRGADO"; 
LISTADO DE ALUMNOS INSCRITOS POR MODULO; 
DOCENTE: "DonDETE"; 
MODULO: "MODULO"; 
HORARIO; "HORARIO "
-- exec sp_listado_estudiantes_por_postgrado 119,226

2)
--https://portalempresarial.utec.edu.sv/uonline/privado/reportes.aspx?reporte=rep_inscritos_proces_graduacion_Maest&filas=4&campo0=1,&campo1=119&campo2=16&campo3=01 
abajo de carrera colocar DOCENTE: "DOCENTE"

*/
USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_listado_estudiantes_por_postgrado]    Script Date: 21/08/2019 17:16:03 ******/
SET ANSI_NULLS on
GO
SET QUOTED_IDENTIFIER on
GO

alter PROCEDURE [dbo].[sp_listado_estudiantes_por_postgrado_por_modulo]
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-08-22 10:46:15.233>
	-- Description: <Devuelve los alumnos por postgrado por modulo>
	-- =============================================
	-- exec sp_listado_estudiantes_por_postgrado_por_modulo 1, 119, 231, 'DEHIM-M'
	@opcion int = 1,
	@codcil int = 0,
	@codcar int = 0,
	@modulo varchar(50) = '' --CODMAT
as
begin

	if @opcion = 1
	begin
		declare @nombreciclo varchar(15)
		select @nombreciclo = concat('0',cil_codcic, '-',cil_anio) from ra_cil_ciclo where cil_codigo = @codcil

		select per_codigo,per_carnet,per_apellidos_nombres,car_codigo,car_nombre, @nombreciclo nombreciclo,
		emp_nombres_apellidos 'docente',
		mat_codigo,
		mat_nombre 'modulo',
		concat(case when isnull(hpl_lunes,'N') = 'S' then 'L-' else '' end+
			case when isnull(hpl_martes,'N') = 'S' then 'M-' else '' end+
			case when isnull(hpl_miercoles,'N') = 'S' then 'Mi-' else '' end+
			case when isnull(hpl_jueves,'N') = 'S' then 'J-' else '' end+
			case when isnull(hpl_viernes,'N') = 'S' then 'V-' else '' end+
			case when isnull(hpl_sabado,'N') = 'S' then 'S-' else '' end+
			case when isnull(hpl_domingo,'N') = 'S' then 'D-' else '' end, ' ', man_nomhor) 'horario'
		from ra_vst_aptde_AlumnoPorTipoDeEstudio as vst
		--Joins agregados (por Fabio 2019-08-21 21:33:59.790) para mostrar los campos "docente", "modulo" y "horario"
		inner join ra_mai_mat_inscritas on mai_codins = vst.ins_codigo
		inner join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
		left join pla_emp_empleado on emp_codigo = hpl_codemp
		left join ra_mat_materias on mat_codigo = hpl_codmat
		left join ra_man_grp_hor on man_codigo = hpl_codman
		where tde_codigo in (3, 6, 7) and ins_codcil = @codcil and car_codigo = @codcar-- and per_estado = 'A'
		and mat_codigo = @modulo
		order by 8, 3
	end
end

select *  from ra_pla_planes where pla_codcar in(231, 226)
select * from ra_car_carreras where car_codigo  in(231, 226)

select pla_codigo codpla, car_codigo codcar, concat(car_nombre, ' (', pla_nombre, ')') nombre from ra_car_carreras inner join ra_pla_planes on pla_codcar = car_codigo and pla_estado = 'A' where car_codtde in (3, 6, 7) and car_estado = 'A' order by car_nombre asc
USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_ins_proces_graduacion_maestrias]    Script Date: 22/08/2019 8:37:53 ******/
SET ANSI_NULLS on
GO
SET QUOTED_IDENTIFIER on
GO
-- =============================================
-- Author:		<Adones Calles>
-- Create date: <31/10/2018>
-- Description:	<Lista los alumnos inscritos en el proceso de graduacion de maestrias>
-- =============================================
--	exec sp_ins_proces_graduacion_maestrias 1, 119, 16, '01'
ALTER PROCEDURE [dbo].[sp_ins_proces_graduacion_maestrias] 
	@opcion int,
	@codcil int,
	@modulo int,
	@seccion nvarchar(5)
AS
BEGIN
	if @opcion = 1
	begin
		declare @datos table (id int identity(1,1), codper int, carnet nvarchar(12), Apellido nvarchar(60), Nombre nvarchar(60),
			ciclo nvarchar(15), NombreModulo nvarchar(175), Carrera nvarchar(175), Seccion nvarchar(5), Docente varchar(255))

		if @codcil < 119
		begin
			Insert into @datos (codper, carnet, Apellido, Nombre, ciclo, NombreModulo, Carrera, Seccion, Docente)
			
			select distinct per_codigo, per_carnet, per_apellidos, per_nombres, (cic_nombre + ' - ' + cast(cil_anio as nvarchar)), mmpg_nombre, car_nombre, '01', emp_nombres_apellidos Docente
			from alumnos_por_modulo_carrera_maestrias 
				inner join ma_mpmpg_modulo_por_maestria_proceso_graduacion on mpmpg_codigo = apmcm_codmmpg
				inner join ma_mmpg_modulo_maestria_proceso_graduacion on mmpg_codigo = mpmpg_codmmpg
				inner join ma_inspgm_inscripcion_pgm on inspgm_codper = apmcm_codper
				inner join ma_moipgm_detalle_inscripcion_pgm on detmoi_codinspgm = inspgm_codigo --and detmoi_codmpmpg = mpmpg_codigo
				inner join ra_per_personas on per_codigo = inspgm_codper and per_codigo = apmcm_codper
				inner join ra_cil_ciclo on cil_codigo = mpmpg_codcil and cil_codigo = apmcm_codcil and cil_codigo = inspgm_codcil
				inner join ra_cic_ciclos on cic_codigo = cil_codcic
				inner join ra_car_carreras on car_codigo = mpmpg_codcar 
				inner join pla_emp_empleado on emp_codigo = mpmpg_codemp
			where mpmpg_codcil = @codcil and mmpg_codigo = @modulo
		end
		else
		begin
			Insert into @datos (codper, carnet, Apellido, Nombre, ciclo, NombreModulo, Carrera, Seccion, Docente)
			select distinct codper, carnet, Apellidos, Nombre, ciclo, NombreModulo, Carrera, Seccion, emp_nombres_apellidos Docente
			from vst_MaestriasInscritosProcesoGraduacion as vst
			inner join pla_emp_empleado on  emp_codigo = vst.mpmpg_codemp
			where codcil = @codcil and Modulo = @modulo and Seccion = @seccion
			order by Apellidos, Nombre
		end
		
		select id,codper, carnet, (Apellido + ' ' + Nombre) as Alumno, ciclo, NombreModulo, Carrera, Seccion, Docente from @datos
		Order by id asc
	end

	if @opcion = 2
	begin
		declare @datos2 table (id int identity(1,1), codper int, codmpmpg int, carnet nvarchar(12), Apellido nvarchar(60), Nombre nvarchar(60),
		ciclo nvarchar(15), NombreModulo nvarchar(175), Carrera nvarchar(175), Seccion nvarchar(5), Nota real)

		
		insert into @datos2 (codper, codmpmpg, carnet, Apellido, Nombre, ciclo, NombreModulo, Carrera, Seccion, Nota)
		select distinct codper, mpmpg_codigo, carnet, Apellidos, Nombre, ciclo, NombreModulo, Carrera, Seccion, isnull(npgm_nota,0.0) as Nota
		from vst_MaestriasInscritosProcesoGraduacion left outer join ma_npgm_notas_pgm on npgm_codmoipgm = detmoi_codigo
		where codcil = @codcil and Modulo = @modulo and Seccion = @seccion
		order by Apellidos, Nombre
		
		select id,codper, codmpmpg, carnet, (Apellido + ' ' + Nombre) as Alumno, ciclo, NombreModulo, Carrera, Seccion, Nota from @datos2
		order by id asc
	end
END
