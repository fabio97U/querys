select hpl_codigo,
'Materia: ' + ltrim(rtrim(mat_codigo)) + ' - ' + ltrim(rtrim(isnull(plm_alias,mat_nombre))) + 
'<br>Seccion: ' + ltrim(rtrim(replace(hpl_descripcion,'seccion','')))  + 
'<br>Aula: ' + ltrim(rtrim(isnull(aul_nombre_corto,'Sin aula'))) +
'<br>Ciclo: ' + concat('0', cil_codcic, '-', cil_anio)
descripcion 
from ra_hpl_horarios_planificacion
join ra_cil_ciclo on cil_codigo = hpl_codcil
left outer join ra_aul_aulas on aul_codigo = hpl_codaul
left outer join pla_emp_empleado on emp_codigo = hpl_codemp
left outer join ra_plm_planes_materias on plm_codpla = hpl_codpla and plm_codmat = hpl_codmat
join ra_mat_materias on mat_codigo = hpl_codmat
where hpl_codigo = 53311

select * from ra_pla_planes
-- drop table ra_prha_planificacion_restriccion_hoja_asesoria
create table ra_prha_planificacion_restriccion_hoja_asesoria (
	prha_codigo int primary key identity (1, 1),
	prha_codcil int foreign key references ra_cil_ciclo,
	prha_codhpl int foreign key references ra_hpl_horarios_planificacion,
	prha_codpla int foreign key references ra_pla_planes,
	prha_codusr_creacion int,
	prha_fecha_creacion datetime default getdate()
)
go
-- select * from ra_prha_planificacion_restriccion_hoja_asesoria


	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-06-14 14:09:22.467>
	-- Description: <Realiza el matenimiento a la tabla ra_prha_planificacion_restriccion_hoja_asesoria>
	-- =============================================
	-- exec dbo.sp_planificacion_restriccion_hoja_asesoria 1, 53311
create or alter procedure sp_planificacion_restriccion_hoja_asesoria
	@opcion int = 0,
	@codhpl int = 0,
	@codpla int = 0,
	@codusr int = 0
as
begin
	
	declare @codmat varchar(30) = '', @codcil int = 0, @ciclo varchar(30) = '', @usuario varchar(80) = '', @codprha int = 0
	select @codmat = hpl_codmat, @codcil = hpl_codcil, @ciclo = concat('0', cil_codcic, '-', cil_anio)
	from ra_hpl_horarios_planificacion 
		inner join ra_cil_ciclo on hpl_codcil = cil_codigo
	where hpl_codigo = @codhpl
	select @usuario = usr_usuario from adm_usr_usuarios where usr_codigo = @codusr
	
	declare @fecha_aud datetime,@registro varchar(200)
	set @fecha_aud = getdate()
	
	--select @codmat
	if @opcion = 1--Muestra los planes
	begin
		-- exec dbo.sp_planificacion_restriccion_hoja_asesoria @opcion = 1, @codhpl = 53311
		select pla_codigo, pla_alias_carrera, pla_anio, plm_codmat, mat_nombre, @codcil 'codcil', @ciclo 'ciclo', 
		prha_codigo 'codprha'
		from ra_plm_planes_materias
			inner join ra_pla_planes on plm_codpla = pla_codigo
			inner join ra_mat_materias on plm_codmat = mat_codigo
			left join ra_prha_planificacion_restriccion_hoja_asesoria on plm_codmat = @codmat 
				and prha_codpla = plm_codpla and prha_codcil = @codcil
		where plm_codmat = @codmat
		order by pla_anio desc, pla_alias_carrera
	end

	select @registro = '@codhpl: ' + CAST(@codhpl AS varchar(10)) + ' @codcil: ' + CAST(@codcil AS varchar(10))+ ' @codpla: ' + CAST(@codpla AS varchar(10))

	if @opcion = 2 --Inserta el registro
	begin
		-- exec dbo.sp_planificacion_restriccion_hoja_asesoria @opcion = 2, @codhpl = 53311, @codpla = 502, @codusr = 407
		if not exists (select 1 from ra_prha_planificacion_restriccion_hoja_asesoria 
		where prha_codhpl = @codhpl and prha_codpla = @codpla and prha_codcil = @codcil)
		begin
			insert into ra_prha_planificacion_restriccion_hoja_asesoria (prha_codcil, prha_codhpl, prha_codpla, prha_codusr_creacion)
			values (@codcil, @codhpl, @codpla, @codusr)
			select 1 'respuesta'
			select @codprha = @@IDENTITY
			set @registro = @registro + ' @codprha ' + CAST(@codprha AS varchar(10))
			exec auditoria_del_sistema 'ra_prha_planificacion_restriccion_ho', 'I', @usuario, @fecha_aud, @registro
		end
		else
		begin
			select 0 'respuesta'
		end
	end

	if @opcion = 3
	begin
		select @codprha = prha_codigo from ra_prha_planificacion_restriccion_hoja_asesoria where prha_codhpl = @codhpl and prha_codpla = @codpla and prha_codcil = @codcil
		delete from ra_prha_planificacion_restriccion_hoja_asesoria where prha_codhpl = @codhpl and prha_codpla = @codpla and prha_codcil = @codcil
		select 1 'respuesta'
		set @registro = @registro + ' @codprha ' + CAST(@codprha AS varchar(10))
		exec auditoria_del_sistema 'ra_prha_planificacion_restriccion_ho', 'D', @usuario, @fecha_aud, @registro
	end

end