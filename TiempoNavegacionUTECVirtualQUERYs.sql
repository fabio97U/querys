--select * from fppe_FechaPagarPre

----PRE
--select distinct A.pre_codigo, A.pre_nombre
--from
--(
--	select cast(cic_nombre as varchar)+' - '+cast(cil_anio as varchar) cil_nombre, pre_nombre, pre_codigo, 
--		mpr_codigo, mpr_codpre, apr_codigo,
--		[hmp_codigo], mpr_nombre, [hmp_codcat], isnull(emp_apellidos_nombres, 'No Aplica') emp_apellidos_nombres, 
--		hmp_codmpr
--	from pg_apr_aut_preespecializacion 
--		join ra_cil_ciclo on cil_codigo = apr_codcil 
--		join ra_cic_ciclos on cic_codigo = cil_codcic 
--		join pg_pre_preespecializacion on pre_codigo = apr_codpre 
--		join pg_mpr_modulo_preespecializacion on pre_codigo = mpr_codpre
--		join pg_hmp_horario_modpre on mpr_codigo = hmp_codmpr
--		left outer join pla_emp_empleado on emp_codigo = hmp_codcat
--	where cil_estado = 'A' and apr_codcil = 120
--) as A

----MODULOS
--select distinct /*A.pre_codigo, A.pre_nombre, */ hmp_codigo, mpr_nombre as modulo, hmp_codmpr, hmp_codcat as codDocente, 
--	emp_apellidos_nombres as Docente, hpre_seccion as Seccion, mpr_orden as orden, pre_codigo
--from
--(
--	select cast(cic_nombre as varchar)+' - '+cast(cil_anio as varchar) cil_nombre, pre_nombre, pre_codigo, 
--		mpr_codigo, mpr_codpre, apr_codigo, mpr_orden,
--		[hmp_codigo], mpr_nombre, [hmp_codcat], isnull(emp_apellidos_nombres, 'No Aplica') emp_apellidos_nombres, 
--		hmp_codmpr, hmp_descripcion as hpre_seccion
--	from pg_apr_aut_preespecializacion 
--		join ra_cil_ciclo on cil_codigo = apr_codcil 
--		join ra_cic_ciclos on cic_codigo = cil_codcic 
--		join pg_pre_preespecializacion on pre_codigo = apr_codpre 
--		join pg_mpr_modulo_preespecializacion on pre_codigo = mpr_codpre
--		join pg_hmp_horario_modpre on mpr_codigo = hmp_codmpr
--		left outer join pla_emp_empleado on emp_codigo = hmp_codcat
--	where cil_estado = 'A' and hmp_codigo = 3167
--) as A
--order by modulo, Seccion, orden

----PRE COMUNES
--exec rlm_definir_grupos_pagar_en_planilla_PreEspecialidad_Comunes 1, 120, 0, ''

----PRE MODULOS COMUNES
--exec rlm_definir_grupos_pagar_en_planilla_PreEspecialidad_Comunes 2, 120, 0, 'Teambuilding: Creación de equipos de alto desempeño'

--drop table pg_tndvp_tiempo_navegacion_docente_virtual_pre
create table pg_tndvp_tiempo_navegacion_docente_virtual_pre(
	tndvp_codigo int primary key identity(1, 1),
	tndvp_codcil int foreign key references ra_cil_ciclo,
	tndvp_codfppe int foreign key references fppe_FechaPagarPre,
	tndvp_codhmp int foreign key references pg_hmp_horario_modpre,
	tndvp_tiempo_navegacion int, --ENTERO QUE REPRESENTA LOS MINUTOS
	tndvp_fecha_creacion datetime default getdate(),
	tndvp_codusr int foreign key references adm_usr_usuarios
);
--select * from pg_tndvp_tiempo_navegacion_docente_virtual_pre

--drop table pg_tndvpc_tiempo_navegacion_docente_virtual_pre_comunes
create table pg_tndvpc_tiempo_navegacion_docente_virtual_pre_comunes(
	tndvpc_codigo int primary key identity(1, 1),
	tndvpc_codcil int foreign key references ra_cil_ciclo,
	tndvpc_codfppe int foreign key references fppe_FechaPagarPre,
	tndvpc_codhm int foreign key references pg_hm_horarios_mod,
	tndvpc_tiempo_navegacion int, --ENTERO QUE REPRESENTA LOS MINUTOS
	tndvpc_fecha_creacion datetime default getdate(),
	tndvpc_codusr int foreign key references adm_usr_usuarios
);
--select * from pg_tndvpc_tiempo_navegacion_docente_virtual_pre_comunes

alter procedure [dbo].[rlm_definir_grupos_pagar_en_planilla_PreEspecialidad_Comunes]
	--	exec rlm_definir_grupos_pagar_en_planilla_PreEspecialidad_Comunes 1, 120, 0, ''	--	Muestra los Modulos
	--	exec rlm_definir_grupos_pagar_en_planilla_PreEspecialidad_Comunes 2, 120, 0, 'Liderazgo basado en principios'	--	Busca por Modulos
	--	exec rlm_definir_grupos_pagar_en_planilla_PreEspecialidad_Comunes 3, 119, 0, 'Liderazgo basado en principios'	--	Busca el @Modulo
	--	exec rlm_definir_grupos_pagar_en_planilla_PreEspecialidad_Comunes 4, 119, 0, ''	--	Muestra todos los Modulos
	@opcion int,
	@codcil int,
	@codmodulo int,
	@Modulo nvarchar(150)
as
begin
	set nocount on;
	declare @ins table (insm_codper int, insm_codhm int)

	insert into @ins (insm_codper, insm_codhm)
	select insm_codper,insm_codhm
	--into #ins
	from pg_insm_inscripcion_mod
	join pg_hm_horarios_mod on hm_codigo = insm_codhm
	where insm_codcil = @codcil

	select hm_codigo,hm_nombre_mod,
	replace(hm_descripcion,'seccion','') hm_descripcion, hm_capacidad,
	hm_lunes, hm_martes, hm_miercoles, hm_jueves, hm_viernes, hm_sabado,
	hm_domingo,isnull(hm_codaul,0) hm_codaul,isnull(hm_codman,0) hm_codman,
	isnull(aul_nombre_corto,'Sin aula') aul_nombre_corto, aul_capacidad,
	case when cil_estado = 'C' then 0 else 1 end estado, man_codigo, man_nomhor,
	(
		select count(1)
		from @ins
		where insm_codhm = hm_codigo
	)  inscritos,
	isnull(hm_codemp,0) hm_codemp, isnull(hm_modulo,9) hm_modulo, isnull(hm_max_alumnos,0) hm_max_alumnos-- , hm_tipo_modulo
	,hm_tpm_tipo_materia, tpm_descripcion
	into #horariosComunes
	from pg_hm_horarios_mod
	join ra_cil_ciclo on cil_codigo = hm_codcil
	left outer join ra_aul_aulas on aul_codigo = hm_codaul 
	inner join ra_man_grp_hor on man_codigo = hm_codman
	inner join ra_tpm_tipo_materias on tpm_tipo_materia = hm_tpm_tipo_materia
	where hm_codcil = @codcil --and aul_nombre_corto <> 'AULA VIRTUAL' --and rtrim(ltrim(hm_tipo_modulo)) = 'P'
	and hm_codigo > 0 --and hm_codemp = 777
	order by hm_nombre_mod,hm_descripcion

	--select * from  #horariosComunes
	declare @ModuloComun table (hm_codigo int, Modulo nvarchar(150), seccion nvarchar(5), codemp int, dia int, Docente nvarchar(75), hm_tpm_tipo_materia varchar(5), tpm_descripcion varchar(55))

	insert into @ModuloComun (hm_codigo, Modulo, Seccion, codemp, dia, Docente, hm_tpm_tipo_materia, tpm_descripcion)
	select A.hm_codigo, concat(A.hm_nombre_mod, ' (', tpm_descripcion, ')'), A.hm_descripcion, a.hm_codemp, A.dia, emp_nombres_apellidos, hm_tpm_tipo_materia, tpm_descripcion
	from
	(
		select hm_codigo, hm_nombre_mod, hm_descripcion, hm_codemp,	case when hm_lunes='S' then 1 end as dia, hm_tpm_tipo_materia, tpm_descripcion
		from #horariosComunes 
		union
		select hm_codigo, hm_nombre_mod, hm_descripcion, hm_codemp,	case when hm_martes='S' then 2 end as dia, hm_tpm_tipo_materia, tpm_descripcion
		from #horariosComunes 
		union
		select hm_codigo, hm_nombre_mod, hm_descripcion, hm_codemp,	case when hm_miercoles='S' then 3 end as dia, hm_tpm_tipo_materia, tpm_descripcion
		from #horariosComunes 
		union
		select hm_codigo, hm_nombre_mod, hm_descripcion, hm_codemp,	case when hm_jueves='S' then 4 end as dia, hm_tpm_tipo_materia, tpm_descripcion
		from #horariosComunes 
		union
		select hm_codigo, hm_nombre_mod, hm_descripcion, hm_codemp,	case when hm_viernes='S' then 5 end as dia, hm_tpm_tipo_materia, tpm_descripcion
		from #horariosComunes 
		union
		select hm_codigo, hm_nombre_mod, hm_descripcion, hm_codemp,	case when hm_sabado='S' then 6 end as dia, hm_tpm_tipo_materia, tpm_descripcion
		from #horariosComunes 
		union
		select hm_codigo, hm_nombre_mod, hm_descripcion, hm_codemp,	case when hm_domingo='S' then 7 end as dia, hm_tpm_tipo_materia, tpm_descripcion
		from #horariosComunes 
	) as A inner join pla_emp_empleado on emp_codigo = hm_codemp
	--select * from @ModuloComun
	delete from @ModuloComun where dia is null
	--select * from @ModuloComun
	if @opcion = 1
	begin
		select distinct Modulo from @ModuloComun
		--select * from @ModuloComun
	end	--	if @opcion = 1

	if @opcion = 2
	begin
		select distinct hm_codigo, Modulo, seccion, codemp, Docente 
		from @ModuloComun where Modulo = @Modulo
		order by seccion
	end	--	if @opcion = 2

	if @opcion = 3--MUESTRA UN SELECT QUE SE USA en portalempresarial "tiempos_navegacion_virtuales_pre_comunes.aspx", sirve para llenar un DropDownList
	begin
		select distinct hm_codigo, concat(Modulo, ' (sec ',seccion, ') ', ', docente: ',Docente) Modulo, seccion, Modulo 'modulo_nombre', Docente
		from @ModuloComun where Modulo = @Modulo
		order by hm_codigo, seccion
	end	--	if @opcion = 3

	if @opcion = 4--Se usa en el procedimiento "pg_tiempo_navegacion_docente_virtuales" en @opcion = 5
	begin
		select distinct hm_codigo, concat(Modulo, ' (sec ',seccion, ') ', ', docente: ',Docente) Modulo, seccion, Modulo 'modulo_nombre', codemp,Docente, hm_tpm_tipo_materia
		from @ModuloComun-- where Modulo = @Modulo
		order by hm_codigo, seccion
	end	--	if @opcion = 4
end

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[pg_tiempo_navegacion_docente_virtuales]    Script Date: 01/11/2019 8:37:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[pg_tiempo_navegacion_docente_virtuales]
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-10-17 10:29:08.477>
	-- Description: <Realiza el mantenimiento a las tablas("pg_tndvp_tiempo_navegacion_docente_virtual_pre" y "pg_tndvpc_tiempo_navegacion_docente_virtual_pre_comunes") 
	--				que almacenan el tiempo de navegacion de los docentes de UTECVirtual>
	-- =============================================
	-- pg_tiempo_navegacion_docente_virtuales 0, 0, 119, 21, 0, 0, 0, 0, 0, 119, 0, 0, 0, 0, ''
	@opcion int = 0,
	@tndvp_codigo int = 0, 
	@tndvp_codcil int = 0,
	@tndvp_codfppe int = 0,
	@tndvp_codhmp int = 0,
	@tndvp_tiempo_navegacion int = 0,
	@tndvp_codusr int = 0,

	@mpr_ordern varchar(5) = '',

	@tndvpc_codigo int = 0, 
	@tndvpc_codcil int = 0, 
	@tndvpc_codfppe int = 0, 
	@tndvpc_codhm int = 0, 
	@tndvpc_tiempo_navegacion int = 0, 
	@tndvpc_codusr int = 0,

	@busqueda varchar(255) = ''
as
begin

	declare @tbl_modulos_comunes as table (hm_codigo int, Modulo varchar(555), seccion varchar(10), modulo_nombre varchar(255), codemp int, docente varchar(255), hm_tpm_tipo_materia varchar(55))
	declare @tbl_modulos_especiales as table (hmp_codigo int, Modulo varchar(555), seccion varchar(10), modulo_nombre varchar(255), codemp int, docente varchar(255), hmp_tpm_tipo_materia varchar(55), pre_nombre varchar(255), mpr_orden varchar(12))

	-- returns
	-- 0: registro ya existe
	-- > 0: registro insertado, el numero representa el codigo unico de la tabla
	if @opcion = 0 --Muestra los modulos ESPECIALES que NO tiene minutos ingresados ingresados segun el @tndvp_codcil y @tndvp_codfppe de la tabla "pg_tndvpc_tiempo_navegacion_docente_virtual_pre_comunes"
	begin
		print '@mpr_ordern' + cast(@mpr_ordern as varchar)
		--declare @tbl_modulos_especiales as table (hmp_codigo int, Modulo varchar(555), seccion varchar(10), modulo_nombre varchar(255), codemp int, docente varchar(255), hmp_tpm_tipo_materia varchar(55), pre_nombre varchar(255))
		insert into @tbl_modulos_especiales (hmp_codigo, Modulo, seccion, modulo_nombre, codemp, docente, hmp_tpm_tipo_materia, pre_nombre, mpr_orden)
		select hmp_codigo, mpr_nombre, hmp_descripcion, mpr_nombre, hmp_codcat, isnull(emp_apellidos_nombres, 'Sin docente') emp_apellidos_nombres, hmp_tpm_tipo_materia, pre_nombre, mpr_orden
		from pg_apr_aut_preespecializacion 
			join ra_cil_ciclo on cil_codigo = apr_codcil 
			join ra_cic_ciclos on cic_codigo = cil_codcic 
			join pg_pre_preespecializacion on pre_codigo = apr_codpre 
			join pg_mpr_modulo_preespecializacion on pre_codigo = mpr_codpre
			join pg_hmp_horario_modpre on mpr_codigo = hmp_codmpr
			left outer join pla_emp_empleado on emp_codigo = hmp_codcat
			--inner join rlm_dmppe_Definir_Modulos_Pagar_PreEspecialidad on dmppe_hmp_codigo = hmp_codigo and dmppe_codpla = (select fppe_codpla from fppe_FechaPagarPre where fppe_codigo = @tndvp_codfppe) and dmppe_codcil_inscri = @tndvp_codcil
		where apr_codcil = @tndvp_codcil and hmp_tpm_tipo_materia = 'V'
		
		select *, 'Sin Tiempo de navegacion' 'Estado', concat('Mod. ',mpr_orden)  from (
			select 0 tndvp_codigo, (select concat('0',cil_codcic, '-', cil_anio) from ra_cil_ciclo where cil_codigo = @tndvp_codcil) 'ciclo', hmp_codigo tndvp_codhmp, modulo_nombre, seccion, codemp, docente, hmp_tpm_tipo_materia, 0 tndvp_tiempo_navegacion, pre_nombre, mpr_orden--, concat('Mod. ',mpr_orden) Mod_Num
			from @tbl_modulos_especiales where hmp_tpm_tipo_materia = 'V'
			except
			select 0 tndvp_codigo, (select concat('0',cil_codcic, '-', cil_anio) from ra_cil_ciclo where cil_codigo = @tndvp_codcil) 'ciclo', hmp_codigo tndvp_codhmp, modulo_nombre, seccion, codemp, docente, hmp_tpm_tipo_materia, 0 tndvp_tiempo_navegacion, pre_nombre, mpr_orden--, ''
			from @tbl_modulos_especiales as hmp
			join pg_tndvp_tiempo_navegacion_docente_virtual_pre on tndvp_codhmp = hmp.hmp_codigo
			where hmp.hmp_tpm_tipo_materia = 'V' and tndvp_codcil = @tndvp_codcil and tndvp_codfppe = @tndvp_codfppe
		 ) t 
		 where (
		((ltrim(rtrim(t.pre_nombre)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end ))
		or
		((ltrim(rtrim(t.modulo_nombre)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end ))
		or
		((ltrim(rtrim(t.seccion)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end ))
		or
		((ltrim(rtrim(t.docente)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end ))
		or
		((ltrim(rtrim(t.tndvp_tiempo_navegacion)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end ))
		--or
		--((ltrim(rtrim(t.Mod_Num)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end ))
		or
		((ltrim(rtrim(t.tndvp_codhmp)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end ))
		)
		and
		((ltrim(rtrim(t.mpr_orden)) like '%' + case when isnull(ltrim(rtrim(@mpr_ordern))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@mpr_ordern))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end ))
	end

	if @opcion = 1 --Muestra los modulos ESPECIALES que tiene minutos ingresados segun el @tndvpc_codcil y @tndvpc_codfppe de la tabla "pg_tndvp_tiempo_navegacion_docente_virtual_pre"
	begin
		--declare @tbl_modulos_comunes as table (hm_codigo int, Modulo varchar(555), seccion varchar(10), modulo_nombre varchar(255), codemp int, docente varchar(255), hm_tpm_tipo_materia varchar(55))
		insert into @tbl_modulos_especiales (hmp_codigo, Modulo, seccion, modulo_nombre, codemp, docente, hmp_tpm_tipo_materia, pre_nombre, mpr_orden)
		select hmp_codigo, mpr_nombre, hmp_descripcion, mpr_nombre, hmp_codcat, isnull(emp_apellidos_nombres, 'No Aplica') emp_apellidos_nombres, hmp_tpm_tipo_materia, pre_nombre, concat('Mod. ',mpr_orden) mpr_orden
		from pg_apr_aut_preespecializacion 
			join ra_cil_ciclo on cil_codigo = apr_codcil 
			join ra_cic_ciclos on cic_codigo = cil_codcic 
			join pg_pre_preespecializacion on pre_codigo = apr_codpre 
			join pg_mpr_modulo_preespecializacion on pre_codigo = mpr_codpre
			join pg_hmp_horario_modpre on mpr_codigo = hmp_codmpr
			left outer join pla_emp_empleado on emp_codigo = hmp_codcat
		where apr_codcil = @tndvp_codcil and hmp_tpm_tipo_materia = 'V'

		select *, 'Con Tiempo de navegacion' 'Estado' from (
			select tndvp_codigo, tndvp_codhmp, concat('0',cil_codcic, '-', cil_anio) 'Ciclo', modulo_nombre 'Modulo', tndvp_tiempo_navegacion, t.docente 'Docente', 
			t.seccion as Seccion, fppe_FechaInicio 'Fecha Desde', fppe_FechaFin 'Fecha Hasta', fppe_codpla 'Planilla', 'Mod. Espec' 'Tipo', pre_nombre, mpr_orden
			from pg_tndvp_tiempo_navegacion_docente_virtual_pre
			join ra_cil_ciclo on tndvp_codcil = cil_codigo
			join fppe_FechaPagarPre on tndvp_codfppe = fppe_codigo
			inner join pg_hmp_horario_modpre on hmp_codigo = tndvp_codhmp
			inner join (
				select * from @tbl_modulos_especiales
			) as t on t.hmp_codigo = tndvp_codhmp
			where tndvp_codcil = @tndvp_codcil and fppe_codigo = @tndvp_codfppe
		) t
		where 
		(ltrim(rtrim(t.pre_nombre)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		or
		(ltrim(rtrim(t.Modulo)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		or
		(ltrim(rtrim(t.seccion)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		or
		(ltrim(rtrim(t.docente)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		or
		(ltrim(rtrim(t.tndvp_tiempo_navegacion)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		or
		((ltrim(rtrim(t.mpr_orden)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end ))
		order by t.tndvp_codigo
	end
										
	if @opcion = 2--inserta a la tabla de tiempo docente virtuales pre, tabla "pg_tndvp_tiempo_navegacion_docente_virtual_pre"
	begin
		if not exists (select 1 from pg_tndvp_tiempo_navegacion_docente_virtual_pre where tndvp_codcil = @tndvp_codcil and  tndvp_codfppe = @tndvp_codfppe and tndvp_codhmp = @tndvp_codhmp)
		begin
			insert into pg_tndvp_tiempo_navegacion_docente_virtual_pre (tndvp_codcil, tndvp_codfppe, tndvp_codhmp, tndvp_tiempo_navegacion, tndvp_codusr)
			values (@tndvp_codcil, @tndvp_codfppe, @tndvp_codhmp, @tndvp_tiempo_navegacion, @tndvp_codusr);
			select @@IDENTITY
		end
		else
			select 0
	end

	if @opcion = 3 --update la tabla "pg_tndvp_tiempo_navegacion_docente_virtual_pre"
	begin
		update pg_tndvp_tiempo_navegacion_docente_virtual_pre set tndvp_tiempo_navegacion = @tndvp_tiempo_navegacion where tndvp_codigo = @tndvp_codigo 
	end
	
	if @opcion = 4--delete la tabla "pg_tndvp_tiempo_navegacion_docente_virtual_pre"
	begin
		delete pg_tndvp_tiempo_navegacion_docente_virtual_pre where tndvp_codigo = @tndvp_codigo
	end
	
	if @opcion = 5 --Muestra los modulos COMUNES que NO tiene minutos ingresados ingresados segun el @tndvpc_codcil y @tndvpc_codfppe de la tabla "pg_tndvpc_tiempo_navegacion_docente_virtual_pre_comunes"
	begin
		--declare @tbl_modulos_comunes as table (hm_codigo int, Modulo varchar(555), seccion varchar(10), modulo_nombre varchar(255), codemp int, docente varchar(255), hm_tpm_tipo_materia varchar(55))
		insert into @tbl_modulos_comunes (hm_codigo, Modulo, seccion, modulo_nombre, codemp, docente, hm_tpm_tipo_materia)
		exec rlm_definir_grupos_pagar_en_planilla_PreEspecialidad_Comunes 4, @tndvpc_codcil, 0, ''

		select *, 'Sin Tiempo de navegacion' 'Estado' from (
			select 0 tndvpc_codigo, (select concat('0',cil_codcic, '-', cil_anio) from ra_cil_ciclo where cil_codigo = @tndvpc_codcil) 'ciclo', hm_codigo tndvpc_codhm, modulo_nombre, seccion, codemp, docente, hm_tpm_tipo_materia, 0 tndvpc_tiempo_navegacion 
			from @tbl_modulos_comunes 
			join rlm_dmppc_Definir_Modulos_Pagar_PreComunes on dmppc_hm_codigo = hm_codigo-- and dmppc_codpla = (select fppe_codigo from fppe_FechaPagarPre where fppe_codigo = @tndvpc_codfppe) and dmppc_codcil_inscri = @tndvpc_codcil
			where hm_tpm_tipo_materia = 'V'
			except
			select 0 tndvpc_codigo, (select concat('0',cil_codcic, '-', cil_anio) from ra_cil_ciclo where cil_codigo = @tndvpc_codcil) 'ciclo', hm_codigo tndvpc_codhm, modulo_nombre, seccion, codemp, docente, hm_tpm_tipo_materia, 0 tndvpc_tiempo_navegacion
			from @tbl_modulos_comunes as hm
			join pg_tndvpc_tiempo_navegacion_docente_virtual_pre_comunes on tndvpc_codhm = hm.hm_codigo
			--join rlm_dmppc_Definir_Modulos_Pagar_PreComunes on dmppc_hm_codigo = hm_codigo and dmppc_codpla = (select fppe_codpla from fppe_FechaPagarPre where fppe_codigo = @tndvpc_codfppe) and dmppc_codcil_inscri = @tndvpc_codcil
			where hm.hm_tpm_tipo_materia = 'V' and tndvpc_codcil = @tndvpc_codcil and tndvpc_codfppe = @tndvpc_codfppe
		) t
		where 
		(ltrim(rtrim(t.modulo_nombre)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		or
		(ltrim(rtrim(t.seccion)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		or
		(ltrim(rtrim(t.docente)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		or
		(ltrim(rtrim(t.tndvpc_tiempo_navegacion)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
	end

	if @opcion = 6 --inserta a la tabla de tiempo docente virtuales pre, tabla "pg_tndvpc_tiempo_navegacion_docente_virtual_pre_comunes"
	begin
		if not exists (select 1 from pg_tndvpc_tiempo_navegacion_docente_virtual_pre_comunes where tndvpc_codcil = @tndvpc_codcil and  tndvpc_codfppe = @tndvpc_codfppe and tndvpc_codhm = @tndvpc_codhm)
		begin
			insert into pg_tndvpc_tiempo_navegacion_docente_virtual_pre_comunes (tndvpc_codcil, tndvpc_codfppe, tndvpc_codhm, tndvpc_tiempo_navegacion, tndvpc_codusr)
			values (@tndvpc_codcil, @tndvpc_codfppe, @tndvpc_codhm, @tndvpc_tiempo_navegacion, @tndvpc_codusr);
			select @@IDENTITY
		end
		else
			update pg_tndvpc_tiempo_navegacion_docente_virtual_pre_comunes set tndvpc_tiempo_navegacion = @tndvpc_tiempo_navegacion where tndvpc_codigo = @tndvpc_codigo 
	end

	if @opcion = 7 --update la tabla "pg_tndvpc_tiempo_navegacion_docente_virtual_pre_comunes"
	begin
		update pg_tndvpc_tiempo_navegacion_docente_virtual_pre_comunes set tndvpc_tiempo_navegacion = @tndvpc_tiempo_navegacion where tndvpc_codigo = @tndvpc_codigo 
	end
	
	if @opcion = 8--delete la tabla "pg_tndvpc_tiempo_navegacion_docente_virtual_pre_comunes"
	begin
		delete pg_tndvpc_tiempo_navegacion_docente_virtual_pre_comunes where tndvpc_codigo = @tndvpc_codigo
	end
	
	if @opcion = 9 --Muestra los modulos COMUNES que tiene minutos ingresados segun el @tndvpc_codcil y @tndvpc_codfppe de la tabla "pg_tndvpc_tiempo_navegacion_docente_virtual_pre_comunes"
	begin
		--declare @tbl_modulos_comunes as table (hm_codigo int, Modulo varchar(555), seccion varchar(10), modulo_nombre varchar(255), codemp int, docente varchar(255), hm_tpm_tipo_materia varchar(55))
		insert into @tbl_modulos_comunes (hm_codigo, Modulo, seccion, modulo_nombre, codemp, docente, hm_tpm_tipo_materia)
		exec rlm_definir_grupos_pagar_en_planilla_PreEspecialidad_Comunes 4, @tndvpc_codcil, 0, ''
		
		select *, 'Con Tiempo de navegacion' 'Estado' from (
			select tndvpc_codigo, tndvpc_codhm, concat('0',cil_codcic, '-', cil_anio) 'Ciclo', modulo_nombre 'Modulo', tndvpc_tiempo_navegacion, t.docente 'Docente', 
			t.seccion as Seccion, fppe_FechaInicio 'Fecha Desde', fppe_FechaFin 'Fecha Hasta', fppe_codpla 'Planilla', 'Mod. Comun' 'Tipo'
			from pg_tndvpc_tiempo_navegacion_docente_virtual_pre_comunes
			join ra_cil_ciclo on tndvpc_codcil = cil_codigo
			join fppe_FechaPagarPre on tndvpc_codfppe = fppe_codigo
			inner join pg_hmp_horario_modpre on hmp_codigo = tndvpc_codhm
			inner join (
				select * from @tbl_modulos_comunes
			) as t on t.hm_codigo = tndvpc_codhm
			where tndvpc_codcil = @tndvpc_codcil and fppe_codigo = @tndvpc_codfppe
		) t
		where 
		(ltrim(rtrim(t.Modulo)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		or
		(ltrim(rtrim(t.seccion)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		or
		(ltrim(rtrim(t.docente)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		or
		(ltrim(rtrim(t.tndvpc_tiempo_navegacion)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		order by t.tndvpc_codigo
	end
end