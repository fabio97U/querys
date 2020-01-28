--SOLICITADO POR: ADRIANA
--DESCRIPCION: PODER CONTROLAR A LAS PERSONAS QUE TIENEN BECA EN MAESTRIAS
--DESARROLLADORES INVOLUCRADOS: FABIO


--drop table ra_autb_autoriza_beca
create table ra_autb_autoriza_beca(
	autb_codigo int identity(1,1) primary key,
	autb_nombre_autoriza varchar(125),
	autb_usuario_creacion varchar(125),
	autb_fecha datetime default getdate()
);
go
--select * from ra_autb_autoriza_beca
ALTER procedure [dbo].[sp_ra_autb_autoriza_beca]
	----------------------*----------------------
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-02-05 10:09:03.977>
	-- Description: <Mantinimento a la tabla ra_autb_autoriza_beca>
	-- =============================================
	--sp_ra_autb_autoriza_beca 2, 0, 'JUAN CARLOS CAMPOS RIVERA'
	@opcion int,
	@autb_codigo int,
	@autb_nombre_autoriza varchar(125),
	@autb_usuario_creacion varchar(125)
as
begin
	if @opcion = 1 --muestra
	begin
		select * from ra_autb_autoriza_beca
	end
	if @opcion = 2 --inserta 
	begin
		if not exists(select 1 from ra_autb_autoriza_beca where autb_nombre_autoriza = @autb_nombre_autoriza)
		begin
			insert into ra_autb_autoriza_beca(autb_nombre_autoriza, autb_fecha, autb_usuario_creacion) values(@autb_nombre_autoriza, getdate(),@autb_usuario_creacion)
			print 'Insertado'
		end
		else
		begin
			print 'Registro ya existe'
		end
	end
	if @opcion = 3  --modifica
	begin
		update ra_autb_autoriza_beca set autb_nombre_autoriza = @autb_nombre_autoriza where autb_codigo = @autb_codigo
	end
	if @opcion = 4  --elimina
	begin
		delete from  ra_autb_autoriza_beca where autb_codigo = @autb_codigo
	end
end

--drop table ra_albe_alumno_beca
create table ra_albe_alumno_beca(
	albe_codigo int primary key identity(1,1),
	albe_codper int foreign key references ra_per_personas,
	albe_ponderacion real,
	albe_codautb int foreign key references ra_autb_autoriza_beca,
	albe_codcil_obtuvo_beca int, 
	albe_codtpb int foreign key references ra_tpb_tipo_beca,
	albe_codtde int foreign key references ra_tde_TipoDeEstudio,
	albe_activa int default 1, 
	albe_usuario_creacion varchar(125),
	albe_fecha datetime default getdate()
)
go
--select * from ra_albe_alumno_beca
--select * from ra_tpb_tipo_beca
--select * from ra_tde_TipoDeEstudio

alter procedure sp_ra_albe_alumno_beca
	----------------------*----------------------
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-02-05 10:09:03.977>
	-- Description: <Mantinimento a la tabla ra_albe_alumno_beca>
	-- =============================================
	--sp_ra_albe_alumno_beca 1, 0, 0, 0, 0, 0,0,0,'', '', '', 0 --Muestra
	--sp_ra_albe_alumno_beca 2, 0, 213705, 50, 1, 119, 2,2,'', 'fabio.ramos', '',0  --Inserta
	--sp_ra_albe_alumno_beca 3, 2, 213705, 50, 1, 119, 3,1,'','rossy.quezada', '',1 --Actualiza
	--sp_ra_albe_alumno_beca 4, 1, 213705, 50, 1, 119, 3,1,'','rossy.quezada', '',0 --Desactiva la beca
	--sp_ra_albe_alumno_beca 5, 1, 213705, 90, 1, 119, 2,2,'','', '',0 --Muestra todos los alumnos de un tipo de estudio
	--sp_ra_albe_alumno_beca 6, 1, 213705, 90, 1, 119, 2,1, '41-0154-2018','', '',0 --Muestra los datos de un alumno
	--sp_ra_albe_alumno_beca 7, 1, 213705, 50, 1, 119, 3,1,'','rossy.quezada', '',1 --Activa la beca
	@opcion int = 0,
	@albe_codigo int = 0,
	@albe_codper int = 0,
	@albe_ponderacion real = 0,
	@albe_codautb int = 0,
	@albe_codcil_obtuvo_beca int = 0,
	@albe_codtpb int = 0,
	@albe_codtde int = 0,
	@per_carnet varchar(12) = '',
	@albe_usuario_creacion varchar(125) = '',
	@tde_tipo varchar(25) = '',
	@albe_activa int = 0
as
begin

	declare @albe_codcil_actual int 
	set @albe_codcil_actual = (select cil_codigo from ra_cil_ciclo where cil_vigente_mae = 'S' and getdate() between cil_inicio and cil_fin)
	print '@albe_codcil_actual ' + cast(@albe_codcil_actual as varchar(12))

	if(@tde_tipo <> '' and @albe_codtde = 0)--LE ESTAN MANDANDO EL tde_tipo y NO el tde_codigo, por lo que se optiene el tde_codigo
	begin
		set @albe_codtde = (select tde_codigo from ra_tde_TipoDeEstudio where tde_tipo = @tde_tipo)
		print '@albe_codtde: ' + cast(@albe_codtde as varchar(12))
	end
	if @opcion = 1 --muestra
	begin
		select * from ra_albe_alumno_beca
	end
	
	if @opcion = 2 --inserta 
	begin
		if not exists(select 1 from ra_albe_alumno_beca where albe_codper = @albe_codper)--ALUMNO NO POSEE BECA
		begin
			insert into ra_albe_alumno_beca(albe_codper, albe_ponderacion, albe_codautb, albe_codcil_obtuvo_beca,albe_codtpb,albe_fecha,albe_codtde,albe_usuario_creacion) values(@albe_codper, @albe_ponderacion, @albe_codautb, @albe_codcil_actual,@albe_codtpb, getdate(),@albe_codtde, @albe_usuario_creacion)
			select 'Beca agregada'
		end
		else --ALUMNO POSEE BECA
		begin
			if(@albe_activa = 0)--LE DESACTIVARON LA BECA
			begin
				update ra_albe_alumno_beca set  albe_activa = 0 where albe_codper = @albe_codper
			end
			else--TENIA DESACTIVADA LA BECA, SE ACTIVO NUEVAMENTE
			begin
				update ra_albe_alumno_beca set albe_ponderacion = @albe_ponderacion,  albe_codautb = @albe_codautb,albe_codtpb =@albe_codtpb, albe_codtde = @albe_codtde, albe_activa = 1 where albe_codper = @albe_codper
			end
			--select 'Alumno ya posee beca'
		end
	end

	if @opcion = 3 --modifica
	begin
		update ra_albe_alumno_beca set albe_ponderacion = @albe_ponderacion,  albe_codautb = @albe_codautb,albe_codtpb =@albe_codtpb, albe_codtde = @albe_codtde where albe_codper = @albe_codper
	end

	if @opcion = 4  --elimina
	begin
		update ra_albe_alumno_beca set albe_activa = 0 where albe_codper = @albe_codper
		select 'Beca quitada'
	end

	if @opcion = 5--Muestra todos los alumnos con beca
	begin
		select albe.albe_codigo 'Codigo', per.per_carnet 'Carnet', per_nombres_apellidos 'Apellidos Nombre', albe_ponderacion 'Ponderacion',  autb_nombre_autoriza 'Persona Autorizo Beca', (select concat('0',cil_codcic, '-',cil_anio) from ra_cil_ciclo where cil_codigo = albe.albe_codcil_obtuvo_beca) as 'Ciclo Obtuvo Beca', tpb_nombre 'Tipo Beca', tde_nombre 'Tipo Estudio', albe_fecha 'Fecha', albe_usuario_creacion 'Usuario registro', albe_activa
		from ra_albe_alumno_beca as albe 
		inner join ra_per_personas as per on albe.albe_codper = per.per_codigo
		inner join ra_autb_autoriza_beca on autb_codigo = albe_codautb
		inner join ra_tpb_tipo_beca on albe_codtpb = tpb_codigo
		inner join ra_tde_TipoDeEstudio on albe_codtde = tde_codigo
		where albe_codcil_obtuvo_beca = @albe_codcil_obtuvo_beca and albe_codtde = @albe_codtde
	end

	if @opcion = 6--Muestra los datos de un unico alumno
	begin
		declare @codper int = (select per_codigo from ra_per_personas where per_carnet = @per_carnet)
		if exists(select 1 from ra_albe_alumno_beca where albe_codper = @codper)
		begin
			select isnull(albe.albe_codigo,0) 'Codigo', per.per_carnet 'Carnet', per_nombres_apellidos 'Apellidos Nombre', albe_ponderacion 'Ponderacion',  autb_nombre_autoriza 'Persona Autorizo Beca', (select concat('0',cil_codcic, '-',cil_anio) from ra_cil_ciclo where cil_codigo = albe.albe_codcil_obtuvo_beca) as 'Ciclo Obtuvo Beca', tpb_nombre 'Tipo Beca', tde_nombre 'Tipo Estudio', albe_fecha 'Fecha', albe_usuario_creacion 'Usuario registro', albe_activa
			from ra_albe_alumno_beca as albe 
			inner join ra_per_personas as per on albe.albe_codper = per.per_codigo
			inner join ra_autb_autoriza_beca on autb_codigo = albe_codautb
			inner join ra_tpb_tipo_beca on albe_codtpb = tpb_codigo
			inner join ra_tde_TipoDeEstudio on albe_codtde = tde_codigo
			where albe_codper = @codper
		end
		else
		begin
			select 0 'Codigo'
		end
	end

	if @opcion = 7  --Activa la beca
	begin
		update ra_albe_alumno_beca set albe_activa = 1 where albe_codper = @albe_codper
		select 'Beca activada'
	end

end