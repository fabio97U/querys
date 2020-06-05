--select * from ra_hpc_hpl_car--15190
--select * from adm_opm_opciones_menu where opm_opcion_padre = 324
--630 Asignaturas Por Carrera Interciclo	placagen_interciclo.aspx	

--update adm_opm_opciones_menu set opm_link = 'logo.html', opm_nombre = 'Planificación interciclo' where opm_codigo = 630
--insert into adm_opm_opciones_menu (opm_codigo, opm_nombre, opm_link, opm_opcion_padre, opm_orden, opm_sistema)
--values (1062, 'Asignaturas Por Carrera Interciclo', 'placagen_interciclo.aspx', 630, 1, 'U'),
--(1063, 'Mover materias masivas interciclo', 'placagen_mover_interciclo.aspx', 630, 2, 'U')

-- =============================================
-- Author:      <>
-- Create date: <>
-- Last modify: Fabio, 2020-04-24 21:16:30.203
-- Description: <Realiza el mantenimiento a tabla que almacena las materias para interciclo "ra_hpc_hpl_car", invocado por sis UTEC form: placagen_interciclo.aspx> select getdate()
-- =============================================
-- ra_Asignaturas_Hoja_Asesoria 3, 121, 0, 0, 0, 0, 0, ''
-- ra_Asignaturas_Hoja_Asesoria 4, 121, 'BAS1-I', 42327, 0, 0, 0, ''
-- ra_Asignaturas_Hoja_Asesoria 5, 0, 0, 0, 0, 118, 121, ''		
alter PROCEDURE [dbo].[ra_Asignaturas_Hoja_Asesoria]
	@opcion int = 0,
	@codcil int = 0,
	@codmat nvarchar(15) = '',
	@codpla int = 0,

	@codhpl int = 0,--CODHPL DE LA MATERIA NUEVA INGRESADA DESDE LA PLANIFICACION
	@codcil_origen int = 0,
	@codcil_destino int = 0,
	@busqueda nvarchar(255) = ''
AS
begin
	set nocount on;
	
	if @opcion = 1 --INSERTA la materia para interciclo para la carrera con plan @codpla
	begin
		if not exists (
			select 1 from ra_hpc_hpl_car where hpc_codhpl in (
				select distinct hpl_codigo
				from ra_hpl_horarios_planificacion
				where hpl_codcil = @codcil and hpl_codmat in 
				(
					select distinct hpl_codmat from ra_hpl_horarios_planificacion 
					where hpl_codcil = @codcil and hpl_codmat = @codmat and hpl_estado = 'A'
				)
			) and hpc_codpla = @codpla
		)
		begin
			insert into ra_hpc_hpl_car (hpc_codhpl, hpc_codpla)				
			select distinct hpl_codigo, @codpla --hpl_codmat, hpl_descripcion, 
			from ra_hpl_horarios_planificacion
			where hpl_codcil = @codcil and hpl_codmat in 
			(
				select distinct hpl_codmat from ra_hpl_horarios_planificacion 
				where hpl_codcil = @codcil and hpl_codmat = @codmat and hpl_estado = 'A'
			)
			select @@rowcount
		end
		else
			select 0
	end

	if @opcion = 2  -- elimina la materia para el ciclo
	begin
		delete from ra_hpc_hpl_car where hpc_codhpl in (
		--insert into ra_hpc_hpl_car (hpc_codhpl, hpc_codpla)				
				select distinct hpl_codigo --hpl_codmat, hpl_descripcion, 
				from ra_hpl_horarios_planificacion
				where hpl_codcil = @codcil and hpl_codmat in 
				(
					select distinct hpl_codmat from ra_hpl_horarios_planificacion 
					where hpl_codcil = @codcil and hpl_codmat = @codmat and hpl_estado = 'A'
				)
			) and hpc_codpla = @codpla
			select @@rowcount
	end

	if @opcion = 3 -- Select de materias de interciclo definidas para las carreras
	begin
		select ciclo 'Ciclo', row_number() over (partition by mat_codigo order by mat_codigo, mat_nombre) 'Num', mat_codigo 'codmat', 
		mat_nombre 'Materia definida', pla_alias_carrera 'Para la carrera', pla_nombre 'Plan'
		from(
			select distinct concat('"0', cil_codcic, '-', cil_anio, '"') ciclo,
			mat_codigo, mat_nombre, hpl_codcil, pla_nombre, pla_alias_carrera
			from ra_hpl_horarios_planificacion
			inner join ra_mat_materias on mat_codigo = hpl_codmat 
			inner join ra_hpc_hpl_car on hpc_codhpl = hpl_codigo
			inner join ra_pla_planes on pla_codigo = hpc_codpla
			inner join ra_cil_ciclo on cil_codigo = hpl_codcil
			where (hpl_estado = 'A') 
			and (hpl_codcil = @codcil)
		) t
		order by mat_codigo, mat_nombre, pla_alias_carrera
	end

	if @opcion = 4 --Ejecutado cuando unicamente se le hace insert a la tabla "ra_hpl_horarios_planificacion"
	begin
		--valida si @codmat ingresada desde la planificacion este definida en la tabla "ra_hpc_hpl_car" para el interciclo
		declare @hpl_codigo int 
		select distinct top 1 @hpl_codigo = hpl_codigo 
		--Solo interesa la primera seccion de la @codmat por todas las demas secciones estan definidas para los mismo planes de estudio 
		from ra_hpc_hpl_car
		inner join ra_hpl_horarios_planificacion on hpl_codigo = hpc_codhpl
		inner join ra_cil_ciclo on cil_codigo = hpl_codcil
		where hpl_codmat = @codmat and hpl_codcil = @codcil and cil_codcic = 3 and hpc_codhpl not in (@codhpl)--hpc_codhpl in(38713, 38714)

		-- ra_Asignaturas_Hoja_Asesoria 4, 121, 'ET2Q-T', 0, 42332, 0, 0, ''
		--create table tbl_ra_Asignaturas_Hoja_Asesoria (opcion int, codcil int, codmat varchar(150), codhpl int, fechahora datetime default getdate())
		insert into tbl_ra_Asignaturas_Hoja_Asesoria (opcion, codcil, codmat, codhpl) values (@opcion, @codcil, @codmat, @codhpl)
		--select * from tbl_ra_Asignaturas_Hoja_Asesoria

		if (isnull(@hpl_codigo, 0) <> 0) and not exists (select 1 from ra_hpc_hpl_car where hpc_codhpl in (@codhpl))
		begin
			print 'La materia esta definidad como parte de interciclo, es interciclo'
			declare @row_count int = 0
			insert into ra_hpc_hpl_car (hpc_codhpl, hpc_codpla)
			select @codhpl, hpc_codpla from ra_hpc_hpl_car where hpc_codhpl = @hpl_codigo
			select @row_count = @@ROWCOUNT
			print 'El @codhpl se registro en ' + cast(@row_count as varchar(5)) + ' planes'
		end
		else
		begin
			print 'La materia *NO* esta definidad como parte de interciclo, o no es interciclo, o ya esta definida en la tabla ra_hpc_hpl_car'
		end
	end

	if @opcion = 5 --Se dio en el ciclo @codcil_origen pero no se esta ofreciendo en el @codcil_destino
	begin
		select row_number() over(order by mat_codigo, mat_nombre, pla_alias_carrera) num, 
		mat_codigo, mat_nombre, pla_nombre, pla_alias_carrera, pla_codigo, 
		ofrecida_en 'codcil_ofrecida_en', (select concat('"0', cil_codcic, '-', cil_anio, '"') from ra_cil_ciclo where cil_codigo = ofrecida_en) ofrecida_en, 
		no_ofrecida_en 'codcil_no_ofrecida_en', (select concat('"0', cil_codcic, '-', cil_anio, '"') from ra_cil_ciclo where cil_codigo =  no_ofrecida_en) no_ofrecida_en, 
		planificada_ciclo_destino
		from (
			select distinct mat_codigo, mat_nombre, pla_nombre, pla_alias_carrera, pla_codigo, @codcil_origen 'ofrecida_en', @codcil_destino 'no_ofrecida_en', 
			case when isnull(hpl_codmat, '') = '' then 0 else 1 end 'planificada_ciclo_destino'
			from (
				--data de las materias que se impartieron el @codcil_origen pero no se estan ofreciendo en el @codcil_destino
				select distinct mat_codigo, mat_nombre, pla_nombre, pla_alias_carrera, pla_codigo
				from ra_hpl_horarios_planificacion
				inner join ra_mat_materias on mat_codigo = hpl_codmat 
				inner join ra_hpc_hpl_car on hpc_codhpl = hpl_codigo
				inner join ra_pla_planes on pla_codigo = hpc_codpla
				inner join ra_cil_ciclo on cil_codigo = hpl_codcil
				where (hpl_estado = 'A') 
				and (hpl_codcil = @codcil_origen)
				except
				select distinct mat_codigo, mat_nombre, pla_nombre, pla_alias_carrera, pla_codigo
				from ra_hpl_horarios_planificacion
				inner join ra_mat_materias on mat_codigo = hpl_codmat 
				inner join ra_hpc_hpl_car on hpc_codhpl = hpl_codigo
				inner join ra_pla_planes on pla_codigo = hpc_codpla
				inner join ra_cil_ciclo on cil_codigo = hpl_codcil
				where (hpl_estado = 'A') 
				and (hpl_codcil = @codcil_destino)
			) dat
			left join ra_hpl_horarios_planificacion as hpl on hpl.hpl_codmat = dat.mat_codigo and hpl.hpl_codcil = @codcil_destino
		) t
		where ( 
			(ltrim(rtrim(mat_codigo)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(mat_nombre)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(pla_nombre)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
			or
			(ltrim(rtrim(pla_alias_carrera)) like '%' + case when isnull(ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
			else ltrim(rtrim(@busqueda))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
		)
		order by mat_codigo, mat_nombre, pla_alias_carrera
	end

end

alter trigger [dbo].[tr_ra_hpl_insert]
on [dbo].[ra_hpl_horarios_planificacion] after insert
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-02-13 10:56:52.367>
	-- Description: <Trigger cuando se realiza un insert a  la tabla "ra_hpl_horarios_planificacion", 
	--				Se creó para insertar las materias nuevas ingresadas para interciclo a la tabla “ra_hpc_hpl_car”>
	-- =============================================
as
begin
	print 'tr_ra_hpl_insert'
	declare @codhpl int, @codmat varchar(125), @codcil int

	select @codhpl = hpl_codigo, @codmat = hpl_codmat, @codcil = hpl_codcil from inserted
	
	--Valida si la materia ingresada es para interciclo, si es correcto la inseta en la tabla "ra_hpc_hpl_car" si ya tiene algun plan definido
	exec dbo.ra_Asignaturas_Hoja_Asesoria 4, @codcil, @codmat, 0, @codhpl, 0, 0, ''
end

--select *--distinct mat_codigo, mat_nombre, pla_nombre, pla_alias_carrera, pla_codigo
--from ra_hpl_horarios_planificacion
--inner join ra_mat_materias on mat_codigo = hpl_codmat 
--inner join ra_hpc_hpl_car on hpc_codhpl = hpl_codigo
--inner join ra_pla_planes on pla_codigo = hpc_codpla
--inner join ra_cil_ciclo on cil_codigo = hpl_codcil
--where (hpl_estado = 'A') 
--and (hpl_codcil = 121) and hpl_codmat = 'ET2Q-T'
