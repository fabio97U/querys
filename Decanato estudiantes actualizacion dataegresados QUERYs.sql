--SOLICITADO POR: CARLOS MAGNO Y FATIMA ESCOBAR
--DESCRIPCION: REALIZAR UNA ACTUALIZACION DE LOS DATOS DE LA PERSONA QUE EEGRESO MEDIANTE UNOS CAMPOS MAS GENERALES PARA PODER FILTRAR Y TENER LA INFORMACION DE LOS EGRESADOS ACTUALIZADA
--DESARROLLADORES INVOLUCRADOS: FABIO


USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_validar_es_egresado]    Script Date: 15/12/2018 8:19:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_validar_es_egresado]
-- =============================================
-- Author:      <Fabio, Ramos>
-- Create date: <2018-12-14>
-- Description: <Valida si el alumno cumple los requisitos(cum, horas sociales, 100% carrera) para egresar, devuelve 1 si cumple y 0 si no cumple>
-- =============================================
	--sp_validar_es_egresado '03-1216-2002'
	@per_carnet varchar(15)
as
begin
	declare @codper int
	select @codper = per_codigo from ra_per_personas where per_carnet = @per_carnet
	declare @pasadas real
	declare @totalmat real
	declare @materias table (mai_codmat varchar(50), matnom varchar(550), codcil int, nf real)
	declare @horas_realizadas int
	declare @horas_carrera int
	declare @cum real = dbo.cum(@codper)

	select @horas_realizadas = ISNULL((select sum(hsp_horas) from ra_hsp_horas_sociales_personas where hsp_codper = @codper), 0),
	@horas_carrera = (select car_horas_soc from ra_car_carreras where car_codigo = (select pla_codcar from ra_pla_planes where pla_codigo = alc.alc_codpla))
	from ra_alc_alumnos_carrera as alc 
	inner join ra_pla_planes as pla 
	on pla.pla_codigo = alc.alc_codpla
	where alc.alc_codper = @codper;

	insert into  @materias (mai_codmat, matnom, codcil, nf) exec web_ptl_pensum @codper

	select @pasadas = count(1) from @materias where nf > 0
	select @totalmat = count(1) from @materias
		
	if (@totalmat = @pasadas) and (@horas_realizadas >=@horas_carrera) and(@cum > 7) --Es egresado
	begin
		select 1
	end
	else
	begin
		select 0
	end
	print '@totalmat: ' +cast(@totalmat as varchar(5))
	print '@pasadas: ' +cast(@pasadas as varchar(5))
	print '@horas_realizadas: ' +cast(@horas_realizadas as varchar(5))
	print '@horas_carrera: ' +cast(@horas_carrera as varchar(5))
	print '@cum: ' +cast(@cum as varchar(5))
end
go

create table ra_rse_rango_salarios_egresados(rse_codigo int primary key identity(1,1), rse_rango varchar(125), rse_fecha_creacion date)
go
insert into ra_rse_rango_salarios_egresados(rse_rango, rse_fecha_creacion) values('$300 - $500', getdate()),('$501 - $1,000', getdate())
select * from ra_rse_rango_salarios_egresados

ALTER procedure sp_rse_rango_salarios_egresados
	-- =============================================
	-- Author:      <Fabio, Ramos>
	-- Create date: <2018-12-15>
	-- Description: <Realiza el mantenimiento a la tabla ra_rse_rango_salarios_egresados>
	-- =============================================
	--sp_rse_rango_salarios_egresados 0, 3, '$1,001 - $5,000'
	@opcion int,
	@rse_codigo int,
	@rse_rango varchar(125)
as
begin
	if @opcion = 0--MUESTRA PARA EL GRID
	begin
		select rse_codigo,	rse_rango,	rse_fecha_creacion from ra_rse_rango_salarios_egresados
	end
	if @opcion = 1--MUESTRA PARA DROPLIST
	begin
		select 0 rse_codigo, 'Seleccione' rse_rango, ''  rse_fecha_creacion
		union all
		select rse_codigo,	rse_rango,	rse_fecha_creacion from ra_rse_rango_salarios_egresados
	if @opcion = 2--INSERTA
	begin
		insert into ra_rse_rango_salarios_egresados(rse_rango, rse_fecha_creacion) values(@rse_rango, getdate())
	end
	if @opcion = 3--ACTUALIZA
	begin
		update ra_rse_rango_salarios_egresados set rse_rango = @rse_rango where rse_codigo = @rse_codigo
	end
	if @opcion = 4--ELIMINA
	begin
		delete from ra_rse_rango_salarios_egresados where rse_rango = @rse_rango 
	end
end
go

--drop table ra_se_salarios_egresados
create table ra_se_salarios_egresados(se_codigo int primary key identity(1,1), se_codper int foreign key references ra_per_personas, se_codrse int foreign key references ra_rse_rango_salarios_egresados, se_fecha_creacion datetime)
insert into  ra_se_salarios_egresados(se_codper, se_codrse,se_fecha_creacion) values(79276, 2, getdate())
select * from ra_se_salarios_egresados


alter procedure sp_datos_egresado_pruebadiagnostica
-- =============================================
	-- Author:      <Fabio, Ramos>
	-- Create date: <2018-12-14>
	-- Description: <Devuel los datos del egresado antes de realizar la prueba diagnostica>
	-- =============================================
	--sp_datos_egresado_pruebadiagnostica 3, 79276 , '', '', '', '',0, 0,116
	--sp_datos_egresado_pruebadiagnostica 2, 79276 , 'rocio@gmail.com', '+503 7413-4987', 'UTEC2', 'Secretaria',2, 1,0
	@opcion int,
	@codper int,
	@per_email varchar(150),
	@per_celular varchar(20),
	@trp_empresa varchar(150),
	@trp_cargo varchar(150),
	@se_codrse int, --CODIGO DEL SALARIO
	@trabaja int,
	@codcil int
as
begin
	--declare @codper int
	--select @codper = per_codigo from ra_per_personas where per_carnet = @per_carnet
	if @opcion = 1 --MUESTRA LOS DATOS
	begin
		select 
			isnull(per.per_email, '') as 'correo', 
			isnull(per.per_celular, '') as 'telefono',  
			(select count(1) from ra_trp_trabajos_per where trp_codper = per.per_codigo) 'trabaja',
			isnull((select trp_cargo from ra_trp_trabajos_per where trp_codper = per.per_codigo), '') 'cargo',
			isnull((select trp_empresa from ra_trp_trabajos_per where trp_codper = per.per_codigo), '') 'lugar_trabajo',
			isnull((select se_codrse from ra_se_salarios_egresados where se_codper = per.per_codigo), '') as 'salario'
		from ra_per_personas as per
		where per.per_codigo = @codper  
	end

	if @opcion = 2 --ACTUALIZA LOS DATOS
	begin
		update ra_per_personas set per_email = @per_email, per_celular = @per_celular where per_codigo = @codper
		
		if(@trabaja = 1)--VARIABLE QUE INDICA SI TRABAJA
		begin
			declare @trp_codigo int
			select @trp_codigo = max(trp_codigo) from ra_trp_trabajos_per
			print 'Trabaja, @trp_codigo: '+ cast(@trp_codigo as varchar(25))
			if (select count(1) from ra_trp_trabajos_per where trp_codper = @codper )=0 --NO TIENE REGISTRO QUE TRABAJA
			begin
				insert into ra_trp_trabajos_per(trp_codigo, trp_codper, trp_empresa, trp_cargo, trp_trabajo, trp_direccion) 
				values((@trp_codigo+1),@codper, @trp_empresa, @trp_cargo, 'Si', 'Sin direccion')
			end
			else 
			begin
				update ra_trp_trabajos_per set  trp_empresa=@trp_empresa, trp_cargo = @trp_cargo where trp_codper = @codper
			end

			if(select count(1) from ra_se_salarios_egresados where se_codper = @codper) = 0 --NO TIENE REGISTROS EN LA TABLA DE SALARIO
			begin
				insert into ra_se_salarios_egresados(se_codper, se_codrse,se_fecha_creacion) values(@codper, @se_codrse, getdate())
			end
			else
			begin
				update ra_se_salarios_egresados set  se_codrse=@se_codrse where se_codper = @codper
			end
		end

		if(@trabaja = 0)--YA NO TRABAJA
		begin
			print 'No trabaja'
			insert into ra_trp_trabajos_per_historico 
			select trp_codper, trp_codigo, trp_empresa, trp_direccion, trp_jefe, trp_cargo, trp_telefonos, trp_puesto, trp_salario, trp_entidad, trp_trabajo 
			from ra_trp_trabajos_per where trp_codper = @codper    
			delete from ra_trp_trabajos_per where trp_codper = @codper  
 
			delete from ra_se_salarios_egresados where se_codper =  @codper  
		end
	end

	if @opcion = 3 --MUESTRA LOS DATOS DE LOS EGRESADOS POR CICLO
	begin
			select 
			per.per_carnet 'Carnet',
			per.per_apellidos_nombres 'Apellidos Nombre',
			(select car.car_nombre from ra_alc_alumnos_carrera inner join ra_pla_planes on alc_codpla = pla_codigo inner join ra_car_carreras as car on pla_codcar = car.car_codigo where alc_codper =  per.per_codigo ) 'Carrera',
			isnull(per.per_email, '') as 'Correo', 
			case (select count(1) from ra_trp_trabajos_per where trp_codper = per.per_codigo) when 0 then 'No' else 'Si' end 'Trabaja',
			isnull((select distinct trp_cargo from ra_trp_trabajos_per where trp_codper = per.per_codigo), '') 'Cargo',
			isnull((select distinct trp_empresa from ra_trp_trabajos_per where trp_codper = per.per_codigo), '') 'Lugar de trabajo',
			--isnull((select distinct trp_salario from ra_trp_trabajos_per where trp_codper = per.per_codigo), '') 'Salario1',
			isnull((select rse_rango from ra_se_salarios_egresados inner join ra_rse_rango_salarios_egresados on se_codrse = rse_codigo where se_codper = per.per_codigo), '') as 'Salario'
		from ra_per_personas as per
		where per.per_codigo in (select egr_codper from ra_egr_egresados where egr_codcil = @codcil)
	end
end
go

create table eeg_cae_cargos_egresados(cae_codigo int primary key identity(1,1), cae_cargo varchar(255), cae_fecha_creacion date)
insert into eeg_cae_cargos_egresados(cae_cargo, cae_fecha_creacion) values('Programador', getdate()), ('Secretaria', getdate())
select cae_codigo, cae_cargo from eeg_cae_cargos_egresados
go

create procedure sp_eeg_cae_cargos_egresados
	-- =============================================
	-- Author:      <Fabio, Ramos>
	-- Create date: <2018-12-18>
	-- Description: <Realiza el mantenimiento a la tabla eeg_cae_cargos_egresados>
	-- =============================================
	--sp_eeg_cae_cargos_egresados 0, 2, 'Secretaria'
	@opcion int,
	@cae_codigo int,
	@cae_cargo varchar(255)
as
begin
	if @opcion = 0--MUESTRA PARA EL GRID
	begin
		select cae_codigo,	cae_cargo,	cae_fecha_creacion from eeg_cae_cargos_egresados
	end
	/*if @opcion = 1--MUESTRA PARA DROPLIST
	begin
		/*select 0 rse_codigo, 'Seleccione' rse_rango, ''  rse_fecha_creacion
		union all
		select rse_codigo,	rse_rango,	rse_fecha_creacion from ra_rse_rango_salarios_egresados*/
		select 1
	end*/
	if @opcion = 2--INSERTA
	begin
		insert into eeg_cae_cargos_egresados(cae_cargo, cae_fecha_creacion) values(@cae_cargo, getdate())
	end
	if @opcion = 3--ACTUALIZA
	begin
		update eeg_cae_cargos_egresados set cae_cargo = @cae_cargo where cae_codigo = @cae_codigo
	end
	if @opcion = 4--ELIMINA
	begin
		delete from eeg_cae_cargos_egresados where cae_codigo = @cae_codigo
	end
end



--select 0 cae_codigo, 'Seleccione' cae_cargo union select cae_codigo, cae_cargo from (select cae_codigo, cae_cargo from eeg_cae_cargos_egresados )t order by cae_cargo asc 
    


--SELECT * FROM ra_per_personas where per_estado = 'E'

--SELECT * from ra_per_personas where per_codigo not in (select trp_codper from ra_trp_trabajos_per ) and per_estado = 'E'

  