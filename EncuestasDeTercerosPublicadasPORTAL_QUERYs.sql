--drop table ni_etpa_encuesta_terceros_publicadas_a_alumnos
create table ni_etpa_encuesta_terceros_publicadas_a_alumnos(
	etpa_codigo int primary key identity(1, 1),
	etpa_nombre_encuesta varchar(125),
	etpa_link_publicado varchar(1024),
	etpa_mensaje_publicacion varchar(1024),
	etpa_fecha_desde date,
	etpa_fecha_hasta date,
	etpa_fecha_creacion datetime default getdate()
)
--select * from ni_etpa_encuesta_terceros_publicadas_a_alumnos
insert into ni_etpa_encuesta_terceros_publicadas_a_alumnos 
(etpa_nombre_encuesta, etpa_link_publicado, etpa_mensaje_publicacion, etpa_fecha_desde, etpa_fecha_hasta)
values ('Nuevo ingreso encuesta "Typerform conectividad "', 'https://utec2.typeform.com/to/U2dgIH', 'Por favor completa la siguiente encuesta que servirá de insumo para el ministerio de educación, no te llevará más de 3 minutos', '2020-09-08', '2020-12-24')

--drop table ni_acet_alumnos_clic_encuestas_terceros
create table ni_acet_alumnos_clic_encuestas_terceros (
	acet_codigo int primary key identity(1, 1),
	acet_codper int,
	acet_codcil int,
	acet_codetpa int,
	acet_fecha_creacion datetime default getdate()
)
--select * from ni_acet_alumnos_clic_encuestas_terceros


	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-09-28 13:24:06.2603716-06:00>
	-- Description: <Realiza el mantenimiento a la "ni_acet", que es para saber si el alumno dio clic a la encuesta publicada> select getdate()
	-- =============================================
ALTER procedure [dbo].[sp_ni_acet_alumnos_clic_encuestas_terceros]
	@opcion int = 0, 
	@codper int = 0,
	@codcil int = 0,
	@codetpa int = 0
as
begin
	set dateformat dmy

	if @opcion = 1 --Valida que el alumno no haya llenado la encuesta
	begin
		if exists (select 1 from ni_acet_alumnos_clic_encuestas_terceros 
					where acet_codper = @codper and acet_codcil = @codcil and acet_codetpa = @codetpa)
			select 1 'res'
		else 
			select 0 'res'
	end

	if @opcion = 2 --Inserta el registro que el alumno dio clic en la encuesta @codepa
	begin
		if not exists (select 1 from ni_acet_alumnos_clic_encuestas_terceros where acet_codper = @codper and acet_codcil = @codcil and acet_codetpa = @codetpa)
		begin
			insert into ni_acet_alumnos_clic_encuestas_terceros (acet_codper, acet_codcil, acet_codetpa)
			values (@codper, @codcil, @codetpa)
		end
	end

	if @opcion = 3 --Valida si existe una encuesta de terceros habilitada, y retorna el codigo de la misma
	begin	
		-- exec sp_ni_acet_alumnos_clic_encuestas_terceros @opcion = 3
		declare @etpa_codigo int
		select @etpa_codigo = etpa_codigo from ni_etpa_encuesta_terceros_publicadas_a_alumnos
		where convert(date, GETDATE(), 103) between convert(date, etpa_fecha_desde, 103) and convert(date, etpa_fecha_hasta, 103)
		select isnull(@etpa_codigo, 0) 'res'--Si es 0 es que no hay encuestas de terceros habilitadas
	end

	if @opcion = 4 --Devuelve los datos de la encuesta @codepa
	begin
		select * from ni_etpa_encuesta_terceros_publicadas_a_alumnos where etpa_codigo = @codetpa
	end

end