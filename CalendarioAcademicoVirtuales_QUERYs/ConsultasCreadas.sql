--SELECT caa_codigo, caa_dias, caa_hora, CONVERT(VARCHAR,caa_fecha,103) caa_fecha, 
--caa_evaluacion, caa_grupo 
--from web_ra_caa_calendario_acad
----SELECT [caa_codigo], [caa_dias], [caa_hora], CONVERT(VARCHAR,[caa_fecha],103) caa_fecha, [caa_evaluacion], [caa_grupo] 
----FROM [web_ra_caa_calendario_acad]

----order by caa_grupo asc, caa_evaluacion asc
select * from web_caav_calendario_acad_virtual
--create table web_caav_calendario_acad_virtual(
--	caav_codigo int primary key identity(1,1),
--	caav_codmat nvarchar(15),
--	caav_codpla int,
--	caav_evaluacion int,
--	caav_codcil int ,
--	caav_fecha_limite datetime,
--	caav_usuario int,
--	caav_fecha_registro datetime default getdate()
--)
--select * from ra_hpl_horarios_planificacion where hpl_codmat = 'FIS1-V' and hpl_codcil = 122
create procedure sp_fecha_limite_prorroga
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-02-17 14:25:18.043>
	-- Description: <Devuelve la fecha limite para solicitar prorroga de la materia @codmat para la evaluacion @ev>
	-- =============================================
	-- sp_fecha_limite_prorroga 1, 'INT2-E', '01', 122, 1
	-- sp_fecha_limite_prorroga 1, 'ALG1-V', '01', 122, 1
	@opcion int,
	@codmat varchar(125),
	@seccion varchar(50),
	@codcil int,
	@ev varchar(5)
as
begin
	declare @dias varchar(25), @tipo_materia varchar(5), 
	@man_nomhor varchar(25), @fecha_limite datetime

	if @opcion = 1
	begin
		set @seccion = right('00'+cast(@seccion as varchar),2)
		print '@opcion ' + cast(@opcion as varchar(125))
		print '@codmat ' + cast(@codmat as varchar(125))
		print '@seccion ' + cast(@seccion as varchar(125))
		print '@codcil ' + cast(@codcil as varchar(125))
		print '@ev ' + cast(@ev as varchar(125))

		select @dias = (
					case when isnull(hpl_lunes, 'N') = 'S' then 'L-' else '' end +
					case when isnull(hpl_martes, 'N') = 'S' then 'M-' else '' end +
					case when isnull(hpl_miercoles, 'N') = 'S' then 'Mi-' else '' end +
					case when isnull(hpl_jueves, 'N') = 'S' then 'J-' else '' end +
					case when isnull(hpl_viernes, 'N') = 'S' then 'V-' else '' end +
					case when isnull(hpl_sabado, 'N') = 'S' then 'S-' else '' end +
					case when isnull(hpl_domingo, 'N') = 'S' then 'D-' else '' end
				), 
			@tipo_materia = hpl_tipo_materia,
			@man_nomhor = man_nomhor
		from ra_hpl_horarios_planificacion 
		inner join ra_man_grp_hor as man on hpl_codman = man.man_codigo 
		where hpl_codmat = @codmat and hpl_descripcion = @seccion and hpl_codcil = @codcil
		print '@tipo_materia ' + cast(@tipo_materia as varchar(25))

		if @tipo_materia != 'V' --No es materia virtual, se va buscar la fecha limite a la tabla "web_ra_caa_calendario_acad"
		begin
			select @fecha_limite = convert(datetime, caa_fecha, 103)
			from web_ra_caa_calendario_acad 
			where caa_dias = @dias and caa_hora = substring(@man_nomhor, 1, 5) and caa_evaluacion = @ev
		end
		else if @tipo_materia = 'V'--Es una materia virtual, se va buscar la fecha limite a la tabla "web_caav_calendario_acad_virtual"
		begin
			select @fecha_limite = convert(datetime, caav_fecha_limite, 103) 
			from web_caav_calendario_acad_virtual
			where caav_codmat = @codmat and caav_evaluacion = @ev
		end
		print '@fecha_limite' 
		print @fecha_limite
		select @fecha_limite
	end

end