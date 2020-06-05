
-- =============================================
-- Author:      <Author, Name>
-- Create date: <Create Date>
-- Description: <Inserta el encabezado de la inscripcion en la tabla "ra_ins_inscripcion">
-- =============================================
ALTER proc [dbo].[web_Ins_InsInscripcion_azure]
	@ins_codreg int,
	@ins_codper int,
	@ins_codcil int,
	@ins_usuario varchar (50),
	@clave nchar(10),
	@ip nvarchar(25),
	@codins int = 0 output
as
begin
	select @codins = isnull(max(ins_codigo), 0) + 1 from ra_ins_inscripcion with (nolock)
	if (select Count(1) from Inscripcion.dbo.ra_ins_inscripcion with (nolock))=0
	begin 
		insert into Inscripcion.dbo.ra_ins_inscripcion 
		(ins_codreg,ins_codigo,ins_codper,ins_codcil,ins_fecha, ins_estado,ins_fecha_creacion,ins_usuario_creacion,ins_clave,ins_ip)
		select @ins_codreg, @codins, @ins_codper, @ins_codcil, getdate(),'A', getdate(), @ins_usuario, @clave, @ip
	end
	else
	begin
		insert into Inscripcion.dbo.ra_ins_inscripcion 
		(ins_codreg, ins_codigo, ins_codper, ins_codcil, ins_fecha, ins_estado, ins_fecha_creacion, ins_usuario_creacion, ins_clave, ins_ip)
		select @ins_codreg, @codins, @ins_codper, @ins_codcil, getdate(),'A', getdate(), @ins_usuario, @clave, @ip
	end
end
go

-- =============================================
-- Author:      <Author, Name>
-- Create date: <Create Date>
-- Description: <Inserta el detalle de la inscripcion a la tabla "ra_mai_mat_inscritas_especial">
-- =============================================
ALTER procedure [dbo].[web_Ins_detinscripcion_azure]
	@regional int,
	@codins int,
	@codper int,
	@codmat varchar (10),
	@codhor int,
	@acuerdo varchar(20),
	@fecha_acuerdo varchar(10),
	@usuario varchar(20),
	@tipo_ins varchar(1),
	@ins_codcil int,

	@tipo_materia varchar(2) = '',
	@estado smallint = 0,
	--estado:{
	-- -1: "delete",
	--	0: "sin accion",
	--	1: "insertar"
	--}
	@codpla int = 0, 
	@uv int = 0,
	@matricula int = 0
as
begin
	set dateformat dmy
	declare @registros int/*, @codpla int, @uv int*/, @codrr int, @codhpl int

	if (@tipo_materia = 'A')
	begin --Es materia especial
		print 'Es materia especial'
		if (@estado = 1) --Insercion
		begin
			if(select count(1) from Inscripcion.dbo.ra_mai_mat_inscritas_especial)=0
			begin
				insert into Inscripcion.dbo.ra_mai_mat_inscritas_especial
				(mai_codreg, mai_codins, mai_codigo, mai_codmat, mai_codhor,mai_estado, mai_matricula, mai_fecha, 
				mai_acuerdo, mai_fecha_acuerdo, mai_financiada, mai_codpla, mai_uv, mai_tipo)
				select @regional, @codins, isnull(max(mai_codigo),0)+1, 
				@codmat, @codhor, 'I', 1, getdate(), 
				@acuerdo, case when @fecha_acuerdo = '' then null else convert(datetime,@fecha_acuerdo,103) end,'N', 0, 0, @tipo_ins
				from ra_mai_mat_inscritas_especial
			end
			else
			begin								
				insert into Inscripcion.dbo.ra_mai_mat_inscritas_especial
				(mai_codreg, mai_codins, mai_codigo, mai_codmat, mai_codhor, mai_estado, mai_matricula, mai_fecha, mai_acuerdo, 
				mai_fecha_acuerdo, mai_financiada, mai_codpla, mai_uv, mai_tipo)
				select @regional, @codins, isnull(max(mai_codigo),0)+1, 
				@codmat, @codhor, 'I', 1, getdate(), 
				@acuerdo, case when @fecha_acuerdo = '' then null else convert(datetime,@fecha_acuerdo,103) end,'N', 0, 0, @tipo_ins
				from Inscripcion.dbo.ra_mai_mat_inscritas_especial
			end
		end
	end
	else
	begin
		print 'NO es materia especial'
		if (@estado = 1)
		begin
			print '@estado = 1, INSERCION'
			if(select count(1) from Inscripcion.dbo.ra_mai_mat_inscritas)=0
			begin
				insert into Inscripcion.dbo.ra_mai_mat_inscritas
				(mai_codreg, mai_codins, mai_codigo, mai_codmat, mai_codhor, mai_estado, mai_matricula, mai_fecha, 
				mai_acuerdo, mai_fecha_acuerdo, mai_financiada, mai_codpla, mai_uv, mai_tipo, mai_codhpl)
				select @regional, @codins, isnull(max(mai_codigo),0)+1, 
				@codmat, 0, 'I', @matricula + 1, getdate(), 
				@acuerdo, case when @fecha_acuerdo = '' then null else convert(datetime,@fecha_acuerdo,103) end,'N',
				@codpla, @uv, @tipo_ins,@codhor
				from ra_mai_mat_inscritas

				select @codrr = max(not_codigo) from ra_not_notas

				insert into ra_not_notas 
				select row_number() over (order by mai_codigo)+@codrr,pom_codigo,mai_codigo,0,'R',getdate(),'',0
				from Inscripcion.dbo.ra_ins_inscripcion
				join Inscripcion.dbo.ra_mai_mat_inscritas on mai_codins = ins_codigo 
				join ra_pom_ponderacion_materia on pom_codcil = ins_codcil and pom_codmat = mai_codmat
				where pom_codpon in (1,2,3,4,5) and ins_codigo = @codins and mai_codmat = @codmat
			end
			else
			begin
				insert into Inscripcion.dbo.ra_mai_mat_inscritas
				(mai_codreg, mai_codins, mai_codigo, mai_codmat, mai_codhor, mai_estado, mai_matricula, mai_fecha, 
				mai_acuerdo, mai_fecha_acuerdo, mai_financiada, mai_codpla, mai_uv, mai_tipo, mai_codhpl)
				select @regional, @codins, isnull(max(mai_codigo),0)+1, 
				@codmat, 0, 'I', @matricula + 1, getdate(), 
				@acuerdo, case when @fecha_acuerdo = '' then null else convert(datetime,@fecha_acuerdo,103) end,'N',
				@codpla, @uv, @tipo_ins,@codhor
				from Inscripcion.dbo.ra_mai_mat_inscritas

				select @codrr = max(not_codigo) from ra_not_notas

				insert into ra_not_notas 
				select row_number() over (order by mai_codigo)+@codrr,pom_codigo,mai_codigo,0,'R',getdate(),'',0
				from Inscripcion.dbo.ra_ins_inscripcion
				join Inscripcion.dbo.ra_mai_mat_inscritas on mai_codins = ins_codigo 
				join ra_pom_ponderacion_materia on pom_codcil = ins_codcil and pom_codmat = mai_codmat
				where pom_codpon in (1,2,3,4,5) and ins_codigo = @codins and mai_codmat = @codmat
			end
		end
	end

	--declare @registro varchar(100), @fecha datetime
	--set @fecha = getdate()
	--select @registro = cast(@codper as varchar) + ' ' + @codmat + ' ' +
	--cast(@codhor as varchar) + ' ' +
	--cast(@codins as varchar) + ' ' + 'S'
	--	exec auditoria_del_sistema 'ra_mai_mat_inscritas','I',@usuario,@fecha,@registro
	--commit transaction
	return
end
go

--declare @mi_hpl as tbl_hpls
--insert into @mi_hpl (hpl, codmat, seccion, especial, estado) 
--values 
----(41394, 'MAT2-E', '01', 0, 0),
----(41650, 'COF3-E', '02', 0, 0),
----(42018, 'INF1-I', '14', 0, 0),
--(41616, 'DEIN-H   ', '08', 0, 1)
----select * from @mi_hpl
--select dbo.web_ins_fnCupo_azure(@mi_hpl)
--SELECT  hpl_max_alumnos from ra_hpl_horarios_planificacion with (nolock) where hpl_codigo = 41616
--SELECT  count(1) from ra_mai_mat_inscritas with (nolock) where mai_codhpl = 41616 and mai_estado = 'I'
--SELECT count(1) from Inscripcion.dbo.ra_mai_mat_inscritas with (nolock) where mai_codhpl = 41616  and mai_estado = 'I'

-- =============================================
-- Author:      <>
-- Create date: <>
-- Description: <Valida que todas las materias @hpl_codigo[N] tengan cupos, si todas tienen cupo retorna 0>
-- =============================================
alter function [dbo].[web_ins_fnCupo_azure](
	@tbl_hpls tbl_hpls readonly
)
returns int as
begin
	declare @hpl int, @tipo_materia nvarchar(2)
	declare @hpl_max_alumnos tinyint, @hpl_alumnos_inscritos tinyint, @hpl_alumnos_inscritos_azure tinyint

	declare @retorno int = 0
	declare m_cursor cursor fast_forward
	for
		select hpl, tipo_materia from @tbl_hpls
	open m_cursor
	fetch next from m_cursor into @hpl, @tipo_materia
	while @@fetch_status = 0
	begin
		if(@tipo_materia = 'A')--Asesoria
		begin
			select @hpl_max_alumnos = hpl_max_alumnos from ra_hpl_horarios_planificacion with (nolock) where hpl_codigo = @hpl
			select @hpl_alumnos_inscritos = count(1) from ra_mai_mat_inscritas_especial with (nolock) where mai_codhor = @hpl
			select @hpl_alumnos_inscritos_azure = count(1) from Inscripcion.dbo.ra_mai_mat_inscritas_especial with (nolock) where mai_codhor = @hpl
		end
		else --No es asesoria, es materia normal
		begin
			select @hpl_max_alumnos = hpl_max_alumnos from ra_hpl_horarios_planificacion with (nolock) where hpl_codigo = @hpl
			select @hpl_alumnos_inscritos = count(1) from ra_mai_mat_inscritas with (nolock) where mai_codhpl = @hpl
			select @hpl_alumnos_inscritos_azure = count(1) from Inscripcion.dbo.ra_mai_mat_inscritas with (nolock) where mai_codhpl = @hpl
		end
		if ((@hpl_alumnos_inscritos + @hpl_alumnos_inscritos_azure) >= @hpl_max_alumnos)
		begin
			set @retorno = @hpl --'cupos agotados para el @hpl, se retorna el mismo @hpl'
			break
		end
		fetch next from m_cursor
		into @hpl, @tipo_materia
	end
	close m_cursor
	deallocate m_cursor

	return @retorno
end
go

declare @mi_hpl as tbl_hpls
insert into @mi_hpl (hpl, codmat, seccion, especial, estado, tipo_materia, codpla, uv, matricula) 
select 42387, 'ING1-H', '01', 0, 1, 'P', 318, 4, 1
-- select * from @mi_hpl
exec web_ins_cuposinserinscripcion_azure 1, 225358, 124, @mi_hpl, '181.225.132.69'

-- =============================================
-- Author:      <>
-- Create date: <>
-- Last modify: Fabio
-- Description: <Inserta las materias seleccionadas en el proceso de inscripción de materias y valida cupos>
-- =============================================
alter PROCEDURE [dbo].[web_ins_cuposinserinscripcion_azure]
	@regional int,
	@codper int,
	@ins_codcil int,
	@tbl_hpls tbl_hpls readonly,
	@ins_ip nvarchar(25)
AS
begin
	declare @ins_codigo int
	select @ins_codigo = isnull(ins_codigo, 0) from inscripcion.dbo.ra_ins_inscripcion with (nolock) where ins_codcil = @ins_codcil and ins_codper = @codper 

	if (@ins_codigo = 0) -- Si no tiene materias inscritas
	begin
		declare @usuario nvarchar(50) = '', @sincupo int, @clave nvarchar(12)

		select @sincupo = dbo.web_ins_fncupo_azure(@tbl_hpls)

		if @sincupo > 0--Significa que hay una materia que ya no tiene cupos
		begin
			select @sincupo
		end
		else--Todas las materias seleccionadas tienen cupo, se realiza la inscripcion
		begin
			--genera clave aleatoria
			set @clave = substring(cast(newid() as varchar(37)),0, 11)
			--comienza insert de cabezera
			begin transaction 
			
			exec web_ins_insinscripcion_azure @regional, @codper, @ins_codcil, @usuario, @clave, @ins_ip, @codins = @ins_codigo output

			declare @hpl int, @codmat varchar(30), @tipo_materia varchar(2), @estado smallint, @codpla int, @UV int, @matricula int
			declare m_cursor cursor fast_forward
			for
				select hpl, codmat, tipo_materia, estado, codpla, UV, matricula from @tbl_hpls
			open m_cursor
			fetch next from m_cursor into @hpl, @codmat, @tipo_materia, @estado, @codpla, @UV, @matricula
			while @@fetch_status = 0
			begin
				execute dbo.web_ins_detinscripcion_azure @regional, @ins_codigo, @codper, @codmat, @hpl, '', '', @usuario, 'n', @ins_codcil, @tipo_materia, @estado, @codpla, @UV, @matricula
				fetch next from m_cursor
				into @hpl, @codmat, @tipo_materia, @estado, @codpla, @UV, @matricula
			end
			close m_cursor
			deallocate m_cursor

			if @@error <> 0
			begin
				rollback transaction
				select 0
				return
			end
			else
			begin
				update ra_validaciones_globales set rvg_mensaje = '1' where rvg_codper = @codper
				select 1																							  
			end
			commit transaction
		end
	end
	else
	begin
		update ra_validaciones_globales set rvg_mensaje = '1' where rvg_codper = @codper
		select 3
		print '3 ya inscrito'
	end
end
go

-- =============================================
-- Author:      <Author, Name>
-- Create date: <Create Date>
-- Description: <Retorna el encabezado (ra_ins) y el detalle (ra_mai) de las materias inscritas>
-- =============================================
-- web_ins_matinscritas_azure 218291, 122
alter procedure [dbo].[web_ins_matinscritas_azure]
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

	SELECT per_carnet,rtrim(per_nombres) +' '+ltrim(per_apellidos) as nombre_ape,pla_alias_carrera,pla_anio,
	concat('Clave de inscripción: ',isnull(ins_clave,'PRESENCIAL'),', Fecha de inscripción: ', Convert(varchar,ins_fecha))as fecha_ins,
	@cicloins cicloins, ins_codigo, (select top 1 InicioCiclo from @tbl_inicio_clases) InicioCiclo
	from ra_pla_planes 
	inner join ra_alc_alumnos_carrera ON ra_pla_planes.pla_codigo = ra_alc_alumnos_carrera.alc_codpla 
	inner join ra_per_personas ON ra_alc_alumnos_carrera.alc_codper = ra_per_personas.per_codigo 
	inner join ra_ins_inscripcion on ins_codper = per_codigo and ins_codcil = @codcil
	where ra_per_personas.per_codigo = @codper

	insert into @ins(ins_codigo, ins_codper, mai_codmat, mai_codhpl, mai_matricula, mai_estado)
	select ins_codigo, ins_codper, mai_codmat, mai_codhpl, mai_matricula, mai_estado
	from ra_ins_inscripcion
	join ra_mai_mat_inscritas on mai_codins = ins_codigo
	where ins_codcil = @codcil and ins_codper = @codper

	insert into @insesp(codigo, codper, mai_codmat, mai_codhor, mai_matricula, mai_estado)
	select ins_codigo codigo, ins_codper codper, mai_codmat, mai_codhor, mai_matricula, mai_estado
	from ra_ins_inscripcion
	join ra_mai_mat_inscritas_especial on mai_codins = ins_codigo
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
		select mat_codigo, rtrim(Isnull(mat_nombre,'')) + 
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
go

alter procedure web_mod_ins_cuposinserinscripcion_azure
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-02-01 10:11:13.349>
	-- Description: <Realiza la modificacion de los horarios de materias inscritas desde el portal de inscripcion en nodejs>
	-- =============================================
	-- web_mod_ins_cuposinserinscripcion_azure 1, 190505, 122, 1179586, @mi,'192.168.114.69'
	@regional int,
	@codper int,
	@ins_codcil int,
	@codins int,
	@tbl_hpls tbl_hpls readonly,
	@ins_ip nvarchar(16)
as
begin
	declare @hpl int, @codmat varchar(30), @seccion varchar(4), @especial char(1), @estado smallint, @tipo_materia varchar(2),@codpla int, @UV int, @matricula int,
	@cupos_agotados bit = 0, @hpl_cupos_agotados int, @inserto_materia bit
	declare @hpl_max_alumnos tinyint, @hpl_alumnos_inscritos tinyint, @hpl_alumnos_inscritos_azure tinyint, @usuario nvarchar(1)
	begin transaction 

	declare m_cursor cursor fast_forward
	for
		select hpl, codmat, seccion, especial, estado, tipo_materia, codpla, uv, matricula from @tbl_hpls
	open m_cursor
	fetch next from m_cursor into @hpl, @codmat, @seccion, @especial, @estado, @tipo_materia, @codpla, @uv, @matricula
	while @@fetch_status = 0
	begin
		if @estado = -1 --delete materia
		begin
			print 'delete ' + cast(@hpl as varchar(10))
			if @especial = 1
			begin
				delete from ra_mai_mat_inscritas_especial where mai_codins = @codins and mai_codhor = @hpl
			end
			else
			begin
				delete from ra_not_notas where not_codmai in (select mai_codigo from ra_mai_mat_inscritas where mai_codins = @codins and mai_codhpl = @hpl)
				delete from ra_mai_mat_inscritas where mai_codins = @codins and mai_codhpl = @hpl
			end
		end

		if @estado = 1 --inserta la materia, validar cupos
		begin
			print 'insert'
			if @especial = 1
			begin
				select @hpl_max_alumnos = hpl_max_alumnos from ra_hpl_horarios_planificacion with (nolock) where hpl_codigo = @hpl
				select @hpl_alumnos_inscritos = count(1) from ra_mai_mat_inscritas_especial with (nolock) where mai_codhor = @hpl
				select @hpl_alumnos_inscritos_azure = count(1) from Inscripcion.dbo.ra_mai_mat_inscritas_especial with (nolock) where mai_codhor = @hpl
			end
			else
			begin
				select @hpl_max_alumnos = hpl_max_alumnos from ra_hpl_horarios_planificacion with (nolock) where hpl_codigo = @hpl
				select @hpl_alumnos_inscritos = count(1) from ra_mai_mat_inscritas with (nolock) where mai_codhpl = @hpl
				select @hpl_alumnos_inscritos_azure = count(1) from Inscripcion.dbo.ra_mai_mat_inscritas with (nolock) where mai_codhpl = @hpl
			end
			if ((@hpl_alumnos_inscritos + @hpl_alumnos_inscritos_azure) < @hpl_max_alumnos)
			begin --Se procede a inscribir, hay cupos
				print 'cupos disponibles'
				print '@codins: ' + cast(@codins as varchar(50))
				print '@codper: ' + cast(@codper as varchar(50))
				print '@codmat: ' + cast(@codmat as varchar(50))
				print '@hpl: ' + cast(@hpl as varchar(50))
				print '@ins_codcil: ' + cast(@ins_codcil as varchar(50))
				execute web_ins_detinscripcion_azure @regional, @codins, @codper, @codmat, @hpl,'','', @usuario, 'n', @ins_codcil, @tipo_materia, @estado, @codpla, @UV, @matricula
			end
			else
			begin
				print 'cupos agotados'
				set @cupos_agotados = 1
				set @hpl_cupos_agotados = @hpl
				break
			end
		end
		fetch next from m_cursor
		into @hpl, @codmat, @seccion, @especial, @estado, @tipo_materia, @codpla, @uv, @matricula
	end
	close m_cursor
	deallocate m_cursor

	if @cupos_agotados = 0
	begin
		print 'commit tran'
		commit tran
		select 1 res
	end
	else
	begin
		print 'rollback tran'
		rollback tran
		select @hpl_cupos_agotados res
	end
end
go


-- =============================================
-- Author:      <>
-- Create date: <>
-- Description: <Retorna la data la hoja de asesoria en el portal>
-- =============================================
-- web_ins_genasesoria_azure 122, 173322 --00:00:03.808
ALTER procedure [dbo].[web_ins_genasesoria_azure]
	@campo0 int, --codcil
	@codigo int  --codper
as
begin

	declare @nota_minima real = 6.0, @codpla_act int, @cum float = 0.0,
	@aprobadas int = 0, @reprobadas int = 0,
	@aprobadas_ciclo int = 0, @reprobadas_ciclo int = 0, @ciclo_ant int,
	@cum_ciclo float, @bloque int = 0,
	@a smallint = 0, @b smallint = 0, @c smallint = 0, @d smallint = 0, @e smallint = 0,
	@ti int, @mn varchar(1) = 'N', @ms varchar(1) = 'N', @cil_anio int, @cil_codcic int,
	@ciclo_aprobar_notas int, @aprobar_notas bit = 0, @ciclo_vigente int

	select @cil_codcic = cil_codcic, @cil_anio = cil_anio
	from ra_cil_ciclo
	where cil_codigo = @campo0

	print '@cil_codcic : ' + cast(@cil_codcic as nvarchar(10))
	print '@cil_anio : ' + cast(@cil_anio as nvarchar(10))

	--buscar ciclo anterior
	if @cil_codcic = 1
	begin 
		select @ciclo_ant = cil_codigo from ra_cil_ciclo where cil_anio = @cil_anio-1 and cil_codcic = 2
	end

	if @cil_codcic in (2,3)
	begin 
		select @ciclo_ant = cil_codigo from ra_cil_ciclo where cil_anio = @cil_anio and cil_codcic = 1
		select @ciclo_aprobar_notas = cil_codigo 
		from ra_cil_ciclo 
		where cil_anio = @cil_anio and cil_codcic = (case when @cil_codcic = 2 then  3 else 1 end )
		set @aprobar_notas = 1
	end
	print '@ciclo_ant : ' + cast(@ciclo_ant as nvarchar(6))
	print '@ciclo_aprobar_notas : ' + cast(@ciclo_aprobar_notas as nvarchar(6))
	--select @ciclo_ant ant,@ciclo_aprobar_notas cil_apro,@aprobar_notas aprobar

	--DATOS GENERALES
	select @cum = dbo.nota_aproximacion(dbo.cum_repro(@codigo)),
	--recupera el cum de ciclo anterior
	@cum_ciclo = dbo.nota_aproximacion(dbo.fn_cum_ciclo (@codigo, @ciclo_ant)),
	--recupera total general de materias aprobadas
	@aprobadas = dbo.mat_gral_apro(@codigo),
	--recupera total general de materias reprobadas
	@reprobadas = dbo.mat_gral_repro(@codigo),
	--recupera materias aprobadas de ciclo anterior
	@aprobadas_ciclo = dbo.mat_apro_ciclo(@codigo,@ciclo_ant),
	--recupera materias reprobadas de ciclo anterior
	@reprobadas_ciclo = dbo.mat_repro_ciclo(@codigo,@ciclo_ant)
	-----------------

	select @ti = per_tipo_ingreso, @codpla_act = alc_codpla, @ciclo_vigente = plac_ciclo
	from ra_per_personas 
	inner join ra_alc_alumnos_carrera on alc_codper = per_codigo 
	inner join ra_plac_plan_ciclo on plac_codpla = alc_codpla
	where per_codigo = @codigo
	print '@ti : ' + cast(@ti as nvarchar(4))
	print '@codpla_act : ' + cast(@codpla_act as nvarchar(6))
	print '@ciclo_vigente : ' + cast(@ciclo_vigente as nvarchar(10))

	--Evalua si es alumno de nuevo ingreso o equivalencias para mostrar o no materias especiales
 	if @ti = 1 or @ti = 4
		set @ms = 'S'
	print '@mn: ' + @mn
	print '@ms: ' + @ms
	
	--bloque que obtiene materias aprobadas.

	declare @tn_tabla_notas table  (
		tn_ins_codreg int, tn_ins_codigo int, tn_ins_codcil int, tn_ins_codper int, tn_mai_codigo int, tn_mai_codmat nvarchar(20), tn_mai_codhor int, 
		tn_absorcion_notas nvarchar(5), tn_mai_matricula int, tn_estado nvarchar(2), tn_mai_codpla int, tn_uv int, tn_nota float, tn_mai_codhpl int  
	)

	insert into @tn_tabla_notas (tn_ins_codreg, tn_ins_codigo, tn_ins_codcil, tn_ins_codper, tn_mai_codigo, tn_mai_codmat, tn_mai_codhor, tn_absorcion_notas, 
	tn_mai_matricula, tn_estado, tn_mai_codpla, tn_uv, tn_nota, tn_mai_codhpl)
	select ins_codreg, ins_codigo, ins_codcil, ins_codper, mai_codigo, mai_codmat, mai_codhor, absorcion_notas,
	mai_matricula, estado, mai_codpla, uv,
	case when (@aprobar_notas = 1 and ins_codcil = @ciclo_aprobar_notas and estado = 'I') then @nota_minima else nota end as nota, mai_codhpl     
	from notas2
	where ins_codper = @codigo and mai_codpla = @codpla_act
	print '@codpla_act : ' + cast(@codpla_act as nvarchar(10))

	-- inicia bloque de validacion de materias electivas
	select distinct @bloque = isnull(plm_bloque_electiva, 0) from electivas_cursadas 
	where ins_codper = @codigo and elect in ('E1', 'E2') and nota >= @nota_minima and mai_codpla = @codpla_act
	print '@bloque: ' + cast(@bloque as varchar(5))

	if @bloque = 0
	begin
		set @a=1 --Electiva Opcion 1 REDES
		set @b=2 --Electiva Opcion 2 SISTEMAS
		set @c=3 --Electiva Opcion 3 COMERCIO ELEC
		set @d=4 --Electiva Opcion 4 GESTION DE LA TECNO.
		set @e=5 --Electiva Opcion 5 SISTEMAS XPERTOS
	end
	-- fin validacion de electivas

	declare @tbl_hoja_asesoria table(
		carnet nvarchar(15), codigo nvarchar(20), materia nvarchar(125), matricula nvarchar(2), hor_descripcion nvarchar(2), 
		man_nomhor nvarchar(50), dias nvarchar(50), plm_ciclo int, hpl_codigo int, hpl_codman int, plm_electiva nvarchar(1), plm_bloque_electiva int, 
		especial nvarchar(1), hpl_tipo_materia nvarchar(2), cumgrl float, cumciclo float, per_nombre nvarchar(125), carrera nvarchar(125), aplan nvarchar(25), 
		mat_aprobadas int, mat_reprobadas int, mat_aprobadasciclo int, mat_reprobadasciclo int, uv int
	)
	
	insert into @tbl_hoja_asesoria
	(carnet, codigo, materia, matricula, hor_descripcion,  man_nomhor, 
	dias, plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, 
	especial, hpl_tipo_materia, cumgrl, cumciclo, per_nombre, carrera, aplan, 
	mat_aprobadas, mat_reprobadas, mat_aprobadasciclo, mat_reprobadasciclo, uv)

	-- web_ins_genasesoria_azure 122, 190505 --00:00:04.147
	--declare @matalm_materias_alumno as table (matalm_codmat varchar(50), matalm_tipo varchar(5))
	--insert into @matalm_materias_alumno (matalm_codmat, matalm_tipo)
	----MATERIAS CON REQUISITOS
	--select req_codmat, 'MR'
	--from ra_req_requisitos,@tn_tabla_notas
	--where tn_mai_codmat = req_codmat_req and req_codpla = @codpla_act
	--and tn_ins_codcil <> @campo0 and round(tn_nota,1) >= @nota_minima --@nota_minima
	--union -- MATERIAS DEL PENSUM
	--select plm_codmat, 'MP' from ra_plm_planes_materias where plm_codpla = @codpla_act
	--union --MATERIAS EQUIVALENCIAS
	--select req_codmat, 'ME'
	--from ra_req_requisitos,ra_equ_equivalencia_universidad,
	--ra_eqn_equivalencia_notas, ra_per_personas
	--where eqn_codmat = req_codmat_req
	--and equ_codper = per_codigo --
	--and eqn_codequ = equ_codigo---
	--and req_codpla = @codpla_act
	--and eqn_nota >= @nota_minima --@nota_minima
	--and per_codigo = @codigo
	--union --MATERIAS CAMBIO DE CARRERA
	--select req_codmat, 'MCC' from ra_cca_cambio_carrera,ra_req_requisitos 
	--where cca_codmat_eqn = req_codmat_req and cca_codper = @codigo and cca_codpla_eqn = @codpla_act
	--union --MATERIAS CAMBIO DE CARRERA
	--select req_codmat, 'MEA'
	--from ra_plq_planes_equivalencias,@tn_tabla_notas,ra_cpa_pla_absorcion,
	--ra_req_requisitos,ra_reg_regionales,ra_uni_universidad
	--where cpa_codper = @codigo
	--and plq_codpla_del = cpa_codpla_old
	--and plq_codmat_del = tn_mai_codmat
	--and plq_codmat_al = req_codmat_req
	--and isnull(tn_absorcion_notas,'N') = 'S'
	--and req_codpla = @codpla_act
	--and plq_codpla_al = req_codpla
	--and round(tn_nota,1) >= @nota_minima 
	
	select Carnet, codigo, Materia, matricula, hor_descripcion, man_nomhor,
	case when mat_tipo = 'N' then case when dias <> '' then substring(dias, 1, len(dias)-1) else dias end else dias end dias, 
	plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, 
	especial, hpl_tipo_materia, @cum as cumgrl, @cum_ciclo as cumciclo, per_nombre, carrera, aplan,
	@aprobadas as mat_aprobadas, @reprobadas as mat_reprobadas, @aprobadas_ciclo as mat_aprobadasciclo , @reprobadas_ciclo as mat_reprobadasciclo, plm_uv
	from(
		select per_carnet Carnet,
		mat_codigo Codigo,
		rtrim(Isnull(plm_alias,'')) + case when tpm_mostrar_descripcion = 1 then ' (' + tpm_descripcion + ')' when tpm_mostrar_descripcion = 0 then ' ' end as Materia, 
		(
			select count(1) from ra_mai_mat_inscritas, ra_ins_inscripcion
			where ins_codper = per_codigo and mai_codins = ins_codigo
			and ins_codcil <> @campo0 and mai_codpla = @codpla_act 
			and mai_estado = 'I' and mai_codmat = mat_codigo
			and ins_codper = @codigo
		) + 1 matricula,
		hpl_descripcion hor_descripcion,
		case when man_codigo = 0 then 'Sin Definir' else isnull(man_nomhor, 'Sin Definir') end man_nomhor,
		case when isnull(hpl_lunes,'N') = 'S' then 'Lu-' else '' end+
		case when isnull(hpl_martes,'N') = 'S' then 'Ma-' else '' end+
		case when isnull(hpl_miercoles,'N') = 'S' then 'Mie-' else '' end+
		case when isnull(hpl_jueves,'N') = 'S' then 'Ju-' else '' end+
		case when isnull(hpl_viernes,'N') = 'S' then 'Vi-' else '' end+
		case when isnull(hpl_sabado,'N') = 'S' then 'Sab-' else '' end+
		case when isnull(hpl_domingo,'N') = 'S' then 'Dom-' else '' end dias,
		plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, mat_tipo as especial, hpl_tipo_materia, 
		per_nombres_apellidos as per_nombre, pla_alias_carrera as carrera, pla_nombre as aplan, plm_uv, mat_tipo
		from ra_per_personas, ra_alc_alumnos_carrera,ra_pla_planes,
		ra_car_carreras, ra_reg_regionales, ra_uni_universidad, ra_mat_materias,
		ra_cil_ciclo, ra_cic_ciclos, ra_plm_planes_materias, ra_tpm_tipo_materias,
		ra_fac_facultades, ra_hpl_horarios_planificacion_v_din_azure, ra_man_grp_hor, ra_plac_plan_ciclo
		/*********DESCOMENTAREAR SOLO EN INTERCICLO*********/
		--,ra_hpc_hpl_car 
		/***************************************************/
		where per_codigo = @codigo	and alc_codper = per_codigo
		and reg_codigo = per_codreg and pla_codigo = alc_codpla
		and car_codigo = pla_codcar and fac_codigo = car_codfac
		and hpl_codcil = @campo0	and mat_codigo = hpl_codmat
		and cil_codigo = hpl_codcil and cic_codigo = cil_codcic
		and man_codigo = hpl_codman and pla_codigo = plac_codpla
		and hpl_tipo_materia = tpm_tipo_materia
		and plm_codpla = alc_codpla and plm_codmat = mat_codigo
		---ciclos
		-----------------------------------------------------
		and plm_ciclo <= @ciclo_vigente--Ciclos normales se muestra las materias por ciclo
		-----------------------------------------------------
		--interciclos
		-----------------------------------------------------
		--and hpl_codigo = hpc_codhpl
		--and hpc_codpla = @codpla_act--Interciclos se agrega para mostrar asesoria de acuerdo a su plan de estudio
		-----------------------------------------------------
		and estado = 1
		and plm_bloque_electiva in(0, @bloque, @a, @b, @c)
		and mat_tipo in(@mn, @ms)
		--and mat_codigo in (select distinct matalm_codmat from @matalm_materias_alumno)
		and isnull((select sum(a)
		from
		(
			select count(1) a
			from @tn_tabla_notas, ra_req_requisitos
			where tn_mai_codmat = req_codmat_req
			and tn_ins_codcil <> @campo0
			and req_codmat = mat_codigo
			and req_codpla = alc_codpla
			and isnull(tn_absorcion_notas,'N') in ('N','C')
			and not exists (select 1 from ra_cca_cambio_carrera where cca_codper = tn_ins_codper
			and cca_codmat_eqn = req_codmat_req)
			and round(tn_nota,1) >= @nota_minima 
			union
			select count(distinct eqn_codmat)
			from ra_equ_equivalencia_universidad,
			ra_eqn_equivalencia_notas, ra_req_requisitos
			where equ_codper = per_codigo
			and eqn_codequ = equ_codigo
			and eqn_codmat = req_codmat_req
			and req_codmat = mat_codigo
			and req_codpla = alc_codpla
			and eqn_nota >= @nota_minima
			union
			select count(distinct tn_mai_codmat) a 
			from @tn_tabla_notas, ra_req_requisitos, ra_cca_cambio_carrera
			where cca_codmat = tn_mai_codmat
			and cca_codmat_eqn = req_codmat_req
			and cca_codper = per_codigo
			and req_codmat = mat_codigo
			and req_codpla = alc_codpla
			and isnull(tn_absorcion_notas, 'N') = 'N'
			and tn_nota >= @nota_minima
			union
			select count(1)
			from ra_plq_planes_equivalencias, @tn_tabla_notas, ra_req_requisitos, ra_cpa_pla_absorcion
			where cpa_codper = per_codigo
			and plq_codpla_del = cpa_codpla_old
			and plq_codmat_del = tn_mai_codmat
			and plq_codmat_al = req_codmat_req
			and req_codmat = mat_codigo
			and isnull(tn_absorcion_notas,'N') = 'S'
			and req_codpla = alc_codpla
			and plq_codpla_al = req_codpla
			and round(tn_nota,1) >= @nota_minima
		) t
		), 0) = isnull((select count(1) from ra_req_requisitos where req_codmat = mat_codigo and req_codpla = alc_codpla), 0)
		and not exists (
			select n
			from(              
				select 1 n
				from @tn_tabla_notas
				where tn_ins_codcil <> @campo0
				and tn_mai_codmat = mat_codigo
				and isnull(tn_absorcion_notas,'N') = 'N'
				and round(tn_nota,1) >= @nota_minima
				union
				select 1 n
				from ra_equ_equivalencia_universidad,
				ra_eqn_equivalencia_notas, ra_per_personas
				where equ_codper = per_codigo
				and eqn_codequ = equ_codigo
				and eqn_codmat = mat_codigo
				and per_codigo = @codigo
				and eqn_nota >= @nota_minima
				union
				select 1
				from ra_cca_cambio_carrera, @tn_tabla_notas
				where cca_codper = per_codigo
				and tn_mai_codmat = cca_codmat
				and cca_codmat_eqn = mat_codigo
				and tn_nota >= @nota_minima
				union
				select 1 n
				from ra_per_personas, ra_plq_planes_equivalencias, @tn_tabla_notas, ra_cpa_pla_absorcion
				where plq_codmat_del = tn_mai_codmat
				and isnull(tn_absorcion_notas, 'N') = 'S'
				and plq_codpla_al = plm_codpla
				and plq_codmat_al = mat_codigo
				and cpa_codper = per_codigo
				and plq_codpla_del = cpa_codpla_old
				and round(tn_nota, 1) >= @nota_minima
			) t
		)
		and 
		isnull((select reu_uv from ra_reu_requisitos_uv where reu_codpla = alc_codpla and reu_codmat = mat_codigo), 0) <= 
		isnull(
			(
				select sum(tn_uv) 
				from(
					select tn_uv from @tn_tabla_notas
					where round(tn_nota,1) >= @nota_minima
					union all
					select plm_uv from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,
					ra_alc_alumnos_carrera, ra_plm_planes_materias
					where equ_codper = per_codigo and eqn_codequ = equ_codigo
					and alc_codper = equ_codper and plm_codpla = alc_codpla
					and plm_codmat = eqn_codmat and eqn_nota >= @nota_minima
				) t
			)
		,0)
	) data_hi
	----Inter ciclo CURSOS LIBRES
	/*---------------------------------------------------------*/
	--union 
	--select per_carnet Carnet,mat_codigo codigo,mat_nombre+case when hpl_tipo_materia = 'A' then ' (Curso Libre)' else '' end Materia,1 matricula,hpl_descripcion hor_descripcion,man_nomhor,
	--case when isnull(hpl_lunes,'N') = 'S' then 'L-' else '' end+
	--case when isnull(hpl_martes,'N') = 'S' then 'M-' else '' end+
	--case when isnull(hpl_miercoles,'N') = 'S' then 'Mi-' else '' end+
	--case when isnull(hpl_jueves,'N') = 'S' then 'J-' else '' end+
	--case when isnull(hpl_viernes,'N') = 'S' then 'V-' else '' end+
	--case when isnull(hpl_sabado,'N') = 'S' then 'S-' else '' end+
	--case when isnull(hpl_domingo,'N') = 'S' then 'D-' else '' end dias,
	--0 plm_ciclo,hpl_codigo,hpl_codman,'N' plm_electiva,0 plm_bloque_electiva,'N' especial,
	--hpl_tipo_materia,@cum  as cumgrl,@cum_ciclo as cumciclo,rtrim(per_nombres)+' '+ltrim(per_apellidos) as per_nombre,pla_alias_carrera as carrera,pla_nombre as aplan,
	--@aprobadas as mat_aprobadas , @reprobadas as mat_reprobadas,@aprobadas_ciclo as mat_aprobadasciclo , @reprobadas_ciclo as mat_reprobadasciclo from ra_hpl_horarios_planificacion_v_din_azure join ra_man_grp_hor on man_codigo = hpl_codman
	--join ra_aul_aulas on aul_codigo = hpl_codaul
	--join ra_mat_materias on mat_codigo = hpl_codmat
	--join ra_per_personas on per_codigo = @codigo
	--join ra_alc_alumnos_carrera on alc_codper = per_codigo
	--join ra_pla_planes on pla_codigo = alc_codpla
	--where hpl_codcil = @campo0 and hpl_tipo_materia = 'A' and hpl_codmat = 'PASV-H' and estado = 1 
	/*---------------------------------------------------------*/
	order by plm_ciclo, codigo,Materia,hor_descripcion

	if @cil_codcic = 3
	begin
		select carnet, case hpl_tipo_materia when 'A' then rtrim(ltrim(codigo)) + 'A' else codigo end codigo, materia, matricula, hor_descripcion, man_nomhor, 
		case when dias <> '' then dias else dbo.fechas_materias_especiales(hpl_codigo) end as dias, 
		plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva,
		especial, hpl_tipo_materia, cumgrl, cumciclo, per_nombre, carrera, aplan, mat_aprobadas, mat_reprobadas, mat_aprobadasciclo, mat_reprobadasciclo, uv
		from @tbl_hoja_asesoria where matricula <= 2 
		order by plm_ciclo, codigo, Materia, hor_descripcion
	end
	else
	begin
		select carnet, case hpl_tipo_materia when 'A' then rtrim(ltrim(codigo)) + 'A' else codigo end codigo, materia, matricula, hor_descripcion, man_nomhor, 
		case when dias <> '' then dias else dbo.fechas_materias_especiales(hpl_codigo) end as dias, 
		plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva,
		especial, hpl_tipo_materia, cumgrl, cumciclo, per_nombre, carrera, aplan, mat_aprobadas, mat_reprobadas, mat_aprobadasciclo, mat_reprobadasciclo, uv
		from @tbl_hoja_asesoria 
		order by plm_ciclo, codigo, Materia, hor_descripcion
	end--if @cil_codcic = 3

end
go

alter procedure [dbo].[web_ins_matinscritas_data]
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-01-31 17:56:07.210>
	-- Description: <Devuelve la data de las materias inscritas segun la misma forma de retorno del 
	--					procedimiento: web_ins_genasesoria_azure>
	-- =============================================
	-- exec web_ins_matinscritas_data 190505, 122
	@codper int,
	@codcil int 
as
begin
	declare @cicloins nvarchar(10)
	select carnet, codigo, materia, matricula, hor_descripcion, man_nomhor,
	case when dias <> '' then substring(dias,1,len(dias)-1) else dbo.fechas_materias_especiales(hpl_codigo) end as dias,
	plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, especial, hpl_tipo_materia, plm_uv
	from (
	select per_carnet 'carnet', mai_codmat 'codigo', rtrim(isnull(plm_alias,'')) 'materia', (
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
	select per_carnet, case hpl_tipo_materia when 'A' then rtrim(ltrim(hpl_codmat)) + 'A' else hpl_codmat end, 
	case hpl_tipo_materia when 'A' then rtrim(ltrim(mat_nombre)) + ' ('+ tpm_descripcion+')' else mat_nombre end,(
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
	plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, mat_tipo, hpl_tipo_materia, plm_uv
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
go

alter procedure web_ins_genasesoria_con_matins_azure
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-02-01 11:24:10.537>
	-- Description: <Devuelve la data de la hoja de asesoria al igual que el procedimiento "web_ins_genasesoria_azure" 
	--				a diferencia que este retorna la misma data del proc "web_ins_genasesoria_azure" MAS la data de 
	--				las materias inscritas("web_ins_matinscritas_data") >
	-- =============================================
	-- exec web_ins_genasesoria_con_matins_azure 225358, 124
	-- exec web_ins_genasesoria_con_matins_azure 226737, 124
	@codper int,
	@codcil int
as
begin
	declare @tbl_hoja_asesoria as table (carnet nvarchar(15), codigo nvarchar(20), materia nvarchar(125), matricula nvarchar(2), hor_descripcion nvarchar(2), man_nomhor nvarchar(50), 
	dias nvarchar(50), plm_ciclo int, hpl_codigo int, hpl_codman int, plm_electiva nvarchar(1), plm_bloque_electiva int, especial nvarchar(1), hpl_tipo_materia nvarchar(2), cumgrl float, 
	cumciclo float, per_nombre nvarchar(125), carrera nvarchar(125), aplan nvarchar(25), mat_aprobadas int, mat_reprobadas int, mat_aprobadasciclo int, mat_reprobadasciclo int, uv int)

	insert into @tbl_hoja_asesoria (carnet, codigo, materia, matricula, hor_descripcion, man_nomhor, dias, plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, 
	especial, hpl_tipo_materia, cumgrl, cumciclo, per_nombre, carrera, aplan, mat_aprobadas, mat_reprobadas, mat_aprobadasciclo, mat_reprobadasciclo, uv)
	exec web_ins_genasesoria_azure @codcil, @codper --optimizar
	declare @cumgrl float,
		@cumciclo float,
		@per_nombre varchar(125),
		@carrera varchar(125),
		@aplan varchar(25),
		@mat_aprobadas tinyint,
		@mat_reprobadas tinyint,
		@mat_aprobadasciclo tinyint,
		@mat_reprobadasciclo tinyint
	select top 1 @cumgrl = cumgrl, @cumciclo = cumciclo, @per_nombre = per_nombre,
	@carrera = carrera, @aplan = aplan, @mat_aprobadas = mat_aprobadas, 
	@mat_reprobadas = mat_reprobadas, @mat_aprobadasciclo = mat_aprobadasciclo, 
	@mat_reprobadasciclo = mat_reprobadasciclo
	from @tbl_hoja_asesoria

	declare @tbl_mat_ins as table(carnet nvarchar(15), codigo nvarchar(20), materia nvarchar(125), matricula nvarchar(2), hor_descripcion nvarchar(2), man_nomhor nvarchar(50), 
	dias nvarchar(50), plm_ciclo int, hpl_codigo int, hpl_codman int, plm_electiva nvarchar(1), plm_bloque_electiva int, especial nvarchar(1), hpl_tipo_materia nvarchar(2), uv int)
	insert into @tbl_mat_ins 
	(carnet, codigo, materia, matricula, hor_descripcion, man_nomhor, dias, plm_ciclo, hpl_codigo, 
	hpl_codman, plm_electiva, plm_bloque_electiva, especial, hpl_tipo_materia, uv)
	exec web_ins_matinscritas_data @codper, @codcil --optimizar

	select *,  row_number() over(order by plm_ciclo, codigo,Materia,hor_descripcion) 'num' from (
		select distinct * from (
			select carnet, codigo, materia, matricula, hor_descripcion, man_nomhor, dias, plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, 
			especial, hpl_tipo_materia, cumgrl, cumciclo, per_nombre, carrera, aplan, mat_aprobadas, mat_reprobadas, mat_aprobadasciclo, mat_reprobadasciclo, uv 
			from @tbl_hoja_asesoria
			union 
			select carnet, codigo, materia, matricula, hor_descripcion, man_nomhor, dias, plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, 
			especial, hpl_tipo_materia, @cumgrl, @cumciclo, @per_nombre, 
			@carrera, @aplan, @mat_aprobadas, @mat_reprobadas, @mat_aprobadasciclo, @mat_reprobadasciclo, uv
			from @tbl_mat_ins
		) t
	) t2
	order by plm_ciclo, codigo, materia, hor_descripcion
end
go

-- =============================================
-- Author:      <>
-- Create date: <>
-- Description: <Devuelve la data de las boletas de pago>
-- =============================================
-- web_col_art_archivo_tal_azure 218291, 122, ''
alter procedure [dbo].[web_col_art_archivo_tal_azure]
	@codper int = 0, 
	@ciclo int = 0,
	@cuota varchar(50) = ''
as 
begin
	declare @resul TABLE (
		[cil_codigo] [int] NULL,
       [per_codigo] [int] NOT NULL,
       [per_carnet] [varchar](50) NOT NULL,
       [carrera] [varchar](100) NULL,
       [alumno] [varchar](201) NOT NULL,
       [fechaf] [varchar](34) NULL,
       [referencia] [varchar](72) NULL,
       [barra_f] [varchar](150) NULL,
       [barra] [varchar](142) NULL,
       [NPE] [varchar](83) NULL,
       [barra_m_f] [varchar](150) NULL,
       [barra_mora] [varchar](142) NULL,
       [NPE_m] [varchar](83) NULL,
       [Valor] [numeric](20, 2) NULL,
       [fecha] [varchar](30) NULL,
       [fecha_v] [varchar](30) NULL,
       [orden] [int] NULL,
       [papeleria] [numeric](3, 2) NULL,
       [portafolio] [numeric](2, 2) NOT NULL,
       [valor_m] [numeric](19, 2) NULL,
       [matricula] [numeric](18, 2) NULL,
       [ciclo] [varchar](62) NULL,
       [per_estado] [varchar](1) NOT NULL,
       [per_tipo] [int] NOT NULL,
       [Texto] [varchar](37) NULL,
       [Estado] [varchar](9) NOT NULL,
	   [are_cuota] [int] NULL
	) 

	insert into @resul 
	(cil_codigo, per_codigo, per_carnet, carrera, alumno, barra, npe,
	barra_mora, NPE_m, valor, fecha, fecha_v, orden, papeleria, portafolio, valor_m, matricula, 
	ciclo, per_estado, per_tipo, Texto, Estado, are_cuota)
	select * 
	from (
		select ciclo cil_codigo,
			t.per_codigo,
			t.per_carnet, 
			t.pla_alias_carrera carrera,
			t.per_nombres_apellidos alumno,
			t.barra barra,
			t.npe NPE,
			t.barra_mora,
			t.npe_mora NPE_m,
			CASE WHEN LEN(t.tmo_valor)=2 THEN  t.tmo_valor+'.00' ELSE t.tmo_valor END Valor,
			convert(varchar,t.fel_fecha,103) fecha,
			convert(varchar,t.fel_fecha_mora,103) fecha_v,
			t.fel_codigo_barra orden,
			t.papeleria papeleria,
			00.00 portafolio,
			t.tmo_valor_mora valor_m,
			t.matricula matricula,
			t.mciclo ciclo,
			p.per_estado,
			1 per_tipo,
			(case when (t.fel_codigo_barra=1 ) then 'Matricula' else cast((t.fel_codigo_barra-1) as varchar)+'a Cuota' end) Texto,
			(Case When pagos.Estado = 'Cancelado' then 'Cancelado' else 'Pendiente' end) as Estado,
			pagos.are_cuota
		from col_art_archivo_tal_mora as t inner join ra_per_personas as p on
		p.per_codigo = t.per_codigo Inner join col_tmo_tipo_movimiento as c on
		c.tmo_arancel = t.tmo_arancel
		left join
		(
			select t.tmo_arancel, mov_codper, count(mov_codigo) as cantidad, 'Cancelado' as Estado, v.are_cuota 
			from col_mov_movimientos
				join col_dmo_det_mov on mov_codigo = dmo_codmov
				join col_tmo_tipo_movimiento r on dmo_codtmo = r.tmo_codigo 
				join col_art_archivo_tal_mora as t on t.ciclo = dmo_codcil and t.per_codigo = mov_codper
				join vst_Aranceles_x_Evaluacion as v on v.are_codtmo = dmo_codtmo 
			where mov_codper = @codper and dmo_codcil = @ciclo and t.tmo_arancel = r.tmo_arancel and v.are_tipo = 'PREGRADO' and mov_estado <> 'A'  
			group by t.tmo_arancel, mov_codper, v.are_cuota
		) as pagos
		on pagos.tmo_arancel = t.tmo_arancel and pagos.mov_codper = p.per_codigo
		where p.per_codigo = @codper and t.ciclo = @ciclo
	) a

	declare @pendientes table (arancel nvarchar(25), codper int, cantidad int, Estado nvarchar(25),descripcion nvarchar(150), cuota int, codcil int)

	insert into @pendientes (arancel, codper, cantidad, Estado, descripcion, cuota, codcil)
	select tmo.tmo_arancel, t.per_codigo as codper, 1 as cantidad, 
		'Pendiente' as Estado, tmo.tmo_descripcion, vst.are_cuota, t.ciclo
	from col_tmo_tipo_movimiento as tmo 
	inner join vst_Aranceles_x_Evaluacion as vst on vst.tmo_arancel = tmo.tmo_arancel 
	inner join col_art_archivo_tal_mora as t on t.tmo_arancel = tmo.tmo_arancel 
	inner join ra_per_personas as p on p.per_codigo = t.per_codigo
	where t.per_codigo = @codper and t.ciclo = @ciclo and vst.are_tipo = 'PREGRADO' and vst.are_codtmo = tmo.tmo_codigo 
	and are_cuota not in
	(
		select vst.are_cuota from col_mov_movimientos as mov
		inner join col_dmo_det_mov as dmo on dmo.dmo_codmov = mov.mov_codigo
		inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo =  dmo.dmo_codtmo
		inner join vst_Aranceles_x_Evaluacion as vst on vst.tmo_arancel = tmo.tmo_arancel
		where mov_codper = @codper and mov_codcil = @ciclo and vst.are_tipo = 'PREGRADO' and mov.mov_estado <> 'A' and vst.are_codtmo = tmo.tmo_codigo 
	)
	
	update @resul set Estado = 'Cancelado' 
	where substring(texto,1,1) not in (select substring(descripcion,1,1) from @pendientes)

	if (@cuota <> '')
		select * from @resul where texto = @cuota order by orden
	else
		select * from @resul order by orden
end
go

--select * from ins_errins_errores_inscrpcion
--drop table ins_errins_errores_inscrpcion
--create table ins_errins_errores_inscrpcion (
--	errins_codigo int primary key identity(1,1),
--	--errins_codper int,
--	errins_codcil smallint,
--	errins_proc_invocado varchar(255),
--	errins_consulta_invocado varchar(max),
--	errins_mensaje_error varchar(max),
--	errins_parametros varchar(max),
--	errins_fecha_creacion datetime default getdate()
--)

-- =============================================
-- Author:      <Fabio>
-- Create date: <2020-04-21 20:14:34.127>
-- Description: <Inserta los errores producidos en las inscripciones en la tabla “ins_errins_errores_inscrpcion”>
-- =============================================
alter procedure sp_ins_errins_errores_inscrpcion
	@opcion int = 0,
	--@errins_codper int, 
	@errins_codcil int = 0, 
	@errins_proc_invocado varchar(255) = '', 
	@errins_consulta_invocado varchar(max) = '', 
	@errins_mensaje_error varchar(max) = '', 
	@errins_parametros varchar(max) = ''
as
begin
	if @opcion = 1
	begin
		insert into ins_errins_errores_inscrpcion (errins_codcil, errins_proc_invocado, errins_mensaje_error, errins_parametros, errins_consulta_invocado)
		values (@errins_codcil, @errins_proc_invocado, @errins_mensaje_error, @errins_parametros, @errins_consulta_invocado)
		select SCOPE_IDENTITY() 'coderrins'
	end
end
go