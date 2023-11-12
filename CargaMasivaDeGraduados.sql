-- drop table temp_carga_graduados
create table temp_carga_graduados (
	carnet varchar(20),
	codper int,
	nombre_completo varchar(500)
)
-- select * from temp_carga_graduados

select per_codigo, carnet, per_carnet, isnull(per_apellidos_nombres, 'Estudiante no encontrado') per_apellidos_nombres, pla_alias_carrera from temp_carga_graduados
	left join ra_per_personas on per_carnet = carnet
	left join ra_alc_alumnos_carrera on alc_codper = per_codigo
	left join ra_pla_planes on alc_codpla = pla_codigo


select * from ra_hia_his_alumnos where hia_codigo > 56042
select * from adm_aud_auditoria where aud_codigo > 4164966
select * from ra_gra_graduados where gra_codigo > 38639

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[cambia_estado_alumno]    Script Date: 27/5/2023 05:59:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- cambia_estado_alumno 1, 109226, '27/09/2019', 'G', 'asd', 407
ALTER proc [dbo].[cambia_estado_alumno]
	@regional int,
	@codper int,
	@fecha varchar(10),
	@estado varchar(1),
	@motivo varchar(150),
	@usuario varchar(20)
as
begin
	declare @cumple_requisitos int, @estado_ant varchar(1), @codpla int
	set dateformat dmy
	begin transaction

	select @estado_ant = per_estado from ra_per_personas where per_codigo = @codper

	if @estado = 'I' or @estado = 'A' or @estado = 'X' or @estado = 'F'
	begin
		insert into ra_hia_his_alumnos
		(hia_codreg, hia_codigo, hia_codper, hia_fecha, hia_estado, hia_motivo, hia_fechahora)
		select @regional,isnull(max(hia_codigo),0)+1, @codper,  convert(datetime,@fecha,103),@estado_ant,@motivo, getdate()
		from ra_hia_his_alumnos
		
		update ra_per_personas
		set per_estado = @estado
		where per_codigo = @codper
	end

	if @estado = 'E' 
	begin
		select @cumple_requisitos = 1
		if @cumple_requisitos = 1 
		begin
			update ra_per_personas
			set per_estado = @estado
			where per_codigo = @codper

			insert into ra_hia_his_alumnos
			select @regional,isnull(max(hia_codigo),0)+1, @codper, 
			convert(datetime,@fecha,103),@estado_ant,@motivo , getdate()
			from ra_hia_his_alumnos
		end 
	end

	if @estado = 'G' 
	begin
		select @cumple_requisitos = 1
		if @cumple_requisitos = 1 
		begin
			select @codpla = alc_codpla
			from ra_alc_alumnos_carrera
			where alc_codper = @codper

			update ra_per_personas
			set per_estado = @estado,
				per_fecha_graduacion = convert(datetime,@fecha,103)
			where per_codigo = @codper

			insert into ra_hia_his_alumnos 
			(hia_codreg, hia_codigo, hia_codper, hia_fecha, hia_estado, hia_motivo, hia_fechahora)
			select @regional, isnull(max(hia_codigo),0)+1, @codper, 
			convert(datetime,@fecha,103), @estado_ant, @motivo, getdate()
			from ra_hia_his_alumnos

			delete from ra_gra_graduados
			where gra_codper = @codper
			and gra_codpla = @codpla

			insert into ra_gra_graduados(gra_codreg, gra_codigo,
			gra_codper, gra_fecha_graduacion,gra_codpla,gra_usuario)
			select @regional,isnull(max(gra_codigo),0)+1,@codper,
			convert(datetime,@fecha,103),@codpla,@usuario
			from ra_gra_graduados
		end 
	end

	declare @registro varchar(100)
	select @registro = 'codper: ' + cast(@codper as varchar) + ' nuevo estado: ' + @estado + ' hecho por: ' + @usuario
	exec auditoria_del_sistema 'ra_per_personas','A',@usuario,@fecha,@registro
	commit transaction
end
