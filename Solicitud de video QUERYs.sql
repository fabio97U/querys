--SOLICITADO POR: MIGUEL UTEC VIRTUAL
--DESCRIPCION: SOLICITAR DESDE EL PORTAL DEL DOCENTE EL SALON DE APOYO DE VIDEO DE UTECVIRTUAL Y APROBAR O PREOBAR LA SOLICITUD DESDE DEL PORTAL EMPRESARIAL
--DESARROLLADORES INVOLUCRADOS: FABIO

create table vid_tvid_tipo_video(
	tvid_codigo int primary key identity(1,1),
	tvid_nombre nvarchar(100),
	tvid_fecha_creacion datetime default getdate()
);
go
insert into vid_tvid_tipo_video(tvid_nombre) 
values('Bienvenida'),('Introducctorio'),('Instrucciones'),('Clases'),('Desarrollo de ejercicio');
go

create table vid_tesc_tipo_escenario(
	tesc_codigo int primary key identity(1,1),
	tesc_nombre nvarchar(100),
	tesc_fecha_creacion datetime default getdate()
);
go
insert into vid_tesc_tipo_escenario(tesc_nombre) values('Escenario Croma'),('Pizarra acrilica'),('Pizarra transparente o Lightboard'),('Captura de video desde iMac');
go

create table vid_trec_tipo_recurso(
	trec_codigo int primary key identity(1,1),
	trec_nombre nvarchar(100),
	trec_fecha_creacion datetime default getdate()
);
go
insert into vid_trec_tipo_recurso (trec_nombre) values('Presentacion de Power Point'),('Documentos PDF'),('Documento de Word'),('Libro de excel'),('Videos');
go

create table vid_hhab_horarios_habiles(
	hhab_codigo int primary key identity(1,1),
	hhab_horario nvarchar(100),
	hhab_do tinyint,
	hhab_lu tinyint,
	hhab_ma tinyint,
	hhab_mi tinyint,
	hhab_ju tinyint,
	hhab_vi tinyint,
	hhab_sa tinyint,
	hhab_fecha_creacion datetime default getdate()
);
go
insert into vid_hhab_horarios_habiles (hhab_horario, hhab_do, hhab_lu, hhab_ma, hhab_mi, hhab_ju, hhab_vi, hhab_sa)
values
('08:00-08:50', 1,1,1,1,1,1,1),('09:00-09:50', 1,1,1,1,1,1,1),
('10:00-10:50', 1,1,1,1,1,1,1),('11:00-11:50', 1,1,1,1,1,1,1),
('14:00-14:50', 0,1,1,1,1,1,0),('15:00-15:50', 0,1,1,1,1,1,0),
('16:00-16:50', 0,1,1,1,1,1,0),('17:00-17:50', 0,1,1,1,1,1,0);
go

create table vid_solc_solicitudes(
	solc_codigo int primary key identity(1,1),
	solc_codhpl int foreign key references ra_hpl_horarios_planificacion,
	solc_tema_video varchar(150),
	solc_codtvid int foreign key references vid_tvid_tipo_video,
	solc_codtesc int foreign key references vid_tesc_tipo_escenario,
	solc_codtrec int foreign key references vid_trec_tipo_recurso,
	solc_fecha datetime,
	solc_codhhab int foreign key references vid_hhab_horarios_habiles,
	solc_fecha_solicitud datetime default getdate(),
	solc_activa bit,
	solc_estado varchar(25),
	solc_codcil int foreign key references ra_cil_ciclo
);
go

alter procedure vid_proc_solc 
	-- =============================================
	-- Author:                           <Fabio>
	-- Create date: <30/10/2018>
	-- Description:   <Matenimiento a la tabla vid_solc_solicitudes, se utiliza en la solicitud del salon de video de UTECVirtual>
	-- =============================================
	--vid_proc_solc  5,0,'',1,1,1,'',1,1,'',1,117,1
	@opcion int, -- 1: Inserta, 2:Muestra las solicitudes pendientes, 3:Confirma la solicitud, 4:Muestra las solicitudes del empleado por ciclo
	@solc_codhpl int = 0, 
	@solc_tema_video varchar(150)= 0, 
	@solc_codtvid int= 0, 
	@solc_codtesc int= 0, 
	@solc_codtrec int= 0, 
	@solc_fecha varchar(45)= '', 
	@solc_codhhab int= 0,
	@solc_activa bit= 0,
	@solc_estado varchar(25) = '',
	@solc_codigo int = 0,
	@hpl_codcil int = 0,
	@hpl_codemp int = 0

as
begin
	set dateformat dmy;
	if @opcion = 1
	begin
		insert into vid_solc_solicitudes(solc_codhpl,
		solc_tema_video,
		solc_codtvid,
		solc_codtesc,
		solc_codtrec,
		solc_fecha,
		solc_codhhab, solc_activa, solc_estado, solc_codcil) values(
		@solc_codhpl,
		@solc_tema_video,
		@solc_codtvid,
		@solc_codtesc,
		@solc_codtrec,
		cast(@solc_fecha as date),
		@solc_codhhab, @solc_activa, @solc_estado, @hpl_codcil);

		select @@IDENTITY;
	end
	if @opcion = 2
	begin
		select solc.solc_codigo as 'Codigo de solicitud', solc_codhpl, hpl.hpl_codmat as 'Codigo Materia', mat.mat_nombre as 'Materia', hpl.hpl_descripcion as 'Sec', 
				emp.emp_apellidos_nombres as 'Docente', emp.emp_email_institucional as 'Email',  
				tvid.tvid_nombre as 'T.Video', tesc.tesc_nombre as 'T.Escenario', trec.trec_nombre as 'T.Recurso',  solc.solc_tema_video as 'Tema',
				hhab.hhab_horario as 'Horario',solc.solc_fecha as 'Dia solicitud', solc.solc_fecha_solicitud as 'Fecha que lo solicito', solc.solc_estado as 'Estado'
		from vid_solc_solicitudes as solc 
		inner join ra_hpl_horarios_planificacion as hpl on solc.solc_codhpl = hpl.hpl_codigo
		inner join pla_emp_empleado as emp on hpl.hpl_codemp = emp.emp_codigo
		inner join ra_mat_materias as mat on hpl.hpl_codmat = mat.mat_codigo
		inner join vid_tvid_tipo_video as tvid on tvid.tvid_codigo = solc.solc_codtvid
		inner join vid_tesc_tipo_escenario as tesc on tesc.tesc_codigo = solc.solc_codtesc
		inner join vid_trec_tipo_recurso as trec on trec.trec_codigo = solc.solc_codtrec
		inner join vid_hhab_horarios_habiles as hhab on hhab.hhab_codigo = solc.solc_codhhab
		WHERE solc.solc_activa = 1
	end
	if @opcion = 3
	begin
		update vid_solc_solicitudes set solc_estado = 'Aprobada', solc_activa = 0 where solc_codigo = @solc_codigo
		select emp.emp_email_institucional  from ra_hpl_horarios_planificacion as hpl inner join pla_emp_empleado as emp on hpl.hpl_codemp = emp.emp_codigo inner join ra_mat_materias as mat on hpl.hpl_codmat = mat.mat_codigo where hpl.hpl_codigo = @solc_codhpl
	end
	if @opcion = 4
	begin
		select solc.solc_codigo as 'Cod.Solicitud', mat.mat_nombre as 'Materia', hpl.hpl_descripcion as 'Sec', 
				tvid.tvid_nombre as 'Video', tesc.tesc_nombre as 'Escenario', trec.trec_nombre as 'Recurso',  solc.solc_tema_video as 'Tema',
				hhab.hhab_horario as 'Horario',solc.solc_fecha as 'Dia solicitud', solc.solc_fecha_solicitud as 'Fecha que lo solicito', solc.solc_estado as 'Estado'
		from vid_solc_solicitudes as solc 
		inner join ra_hpl_horarios_planificacion as hpl on solc.solc_codhpl = hpl.hpl_codigo
		inner join pla_emp_empleado as emp on hpl.hpl_codemp = emp.emp_codigo
		inner join ra_mat_materias as mat on hpl.hpl_codmat = mat.mat_codigo
		inner join vid_tvid_tipo_video as tvid on tvid.tvid_codigo = solc.solc_codtvid
		inner join vid_tesc_tipo_escenario as tesc on tesc.tesc_codigo = solc.solc_codtesc
		inner join vid_trec_tipo_recurso as trec on trec.trec_codigo = solc.solc_codtrec
		inner join vid_hhab_horarios_habiles as hhab on hhab.hhab_codigo = solc.solc_codhhab
		WHERE hpl.hpl_codcil = @hpl_codcil and hpl.hpl_codemp = @hpl_codemp
	end

	if @opcion = 5
	begin
		select solc.solc_codigo as 'Codigo de solicitud', solc_codhpl, hpl.hpl_codmat as 'Codigo Materia', mat.mat_nombre as 'Materia', hpl.hpl_descripcion as 'Sec', 
				emp.emp_apellidos_nombres as 'Docente', emp.emp_email_institucional as 'Email',  
				tvid.tvid_nombre as 'T.Video', tesc.tesc_nombre as 'T.Escenario', trec.trec_nombre as 'T.Recurso',  solc.solc_tema_video as 'Tema',
				hhab.hhab_horario as 'Horario',solc.solc_fecha as 'Dia solicitud', solc.solc_fecha_solicitud as 'Fecha que lo solicito', solc.solc_estado as 'Estado'
		from vid_solc_solicitudes as solc 
		inner join ra_hpl_horarios_planificacion as hpl on solc.solc_codhpl = hpl.hpl_codigo
		inner join pla_emp_empleado as emp on hpl.hpl_codemp = emp.emp_codigo
		inner join ra_mat_materias as mat on hpl.hpl_codmat = mat.mat_codigo
		inner join vid_tvid_tipo_video as tvid on tvid.tvid_codigo = solc.solc_codtvid
		inner join vid_tesc_tipo_escenario as tesc on tesc.tesc_codigo = solc.solc_codtesc
		inner join vid_trec_tipo_recurso as trec on trec.trec_codigo = solc.solc_codtrec
		inner join vid_hhab_horarios_habiles as hhab on hhab.hhab_codigo = solc.solc_codhhab
		where solc.solc_codcil = @hpl_codcil
	end

end
go


alter procedure vid_proc_horas_habiles 
	--vid_proc_horas_habiles '2018-11-01 00:00:00.000','Thursday'
	-- =============================================
	-- Author:                           <Fabio>
	-- Create date: <30/10/2018>
	-- Description:   <Muestra los horarios disponibles segun el dia, se utiliza en la solicitud del salon de video de UTECVirtual>
	-- =============================================
	@solc_fecha varchar(45),
	@dia varchar(25)
as
begin
	create table #horarios(hhab_codigo int)
	if @dia = 'Sunday' begin
		insert into #horarios select hhab_codigo from vid_hhab_horarios_habiles where hhab_do = 1
	end 
	if @dia = 'Monday' begin
		insert into #horarios select hhab_codigo from vid_hhab_horarios_habiles where hhab_lu = 1
	end 
	if @dia = 'Tuesday' begin
		insert into #horarios select hhab_codigo from vid_hhab_horarios_habiles where hhab_ma = 1
	end 
	if @dia = 'Wednesday' begin
		insert into #horarios select hhab_codigo from vid_hhab_horarios_habiles where hhab_mi = 1
	end 
	if @dia = 'Thursday' begin
		insert into #horarios select hhab_codigo from vid_hhab_horarios_habiles where hhab_ju = 1
	end 
	if @dia = 'Friday' begin
		insert into #horarios select hhab_codigo from vid_hhab_horarios_habiles where hhab_vi = 1
	end 
	if @dia = 'Saturday' begin
		insert into #horarios select hhab_codigo from vid_hhab_horarios_habiles where hhab_sa = 1
	end 

	set dateformat dmy;
	if((select count(1) from vid_hhab_horarios_habiles where hhab_codigo  not in (select distinct solc_codhhab from vid_solc_solicitudes where solc_fecha = cast(@solc_fecha as date) and hhab_codigo in(select * from #horarios))) > 0)
		begin
			select hhab_codigo,	hhab_horario, hhab_fecha_creacion from vid_hhab_horarios_habiles where hhab_codigo not in (select distinct solc_codhhab from vid_solc_solicitudes where  solc_fecha = cast(@solc_fecha as date)) and hhab_codigo in(select * from #horarios)
		end
	else
		begin
			select 0 as hhab_codigo, 'No hay horarios disponibles' as hhab_horario,	0 as hhab_fecha_creacion
		end

	drop table #horarios
end
go

create procedure vid_proc_tvid
	-- =============================================
	-- Author:                           <Manrrique>
	-- Create date: <26/10/2018>
	-- Description:   <Matenimiento a las la tabla tipo de video que se utiliza en la solicitud del salon de video de UTECVirtual>
	-- =============================================
    @opcion int,
    @tvid_codigo int,
    @tvid_nombre nvarchar(100)
AS
Begin
    if @opcion = 1
    begin
                    select tvid_codigo as Codigo, tvid_nombre as Nombre, tvid_fecha_creacion as FechaCreacion from vid_tvid_tipo_video
    end
    if @opcion = 2
    begin
                    insert into vid_tvid_tipo_video(tvid_nombre)
                    values(@tvid_nombre)
    end
    if @opcion = 3
    begin
                    update vid_tvid_tipo_video set tvid_nombre = @tvid_nombre where tvid_codigo = @tvid_codigo
    end
End
go

create procedure vid_proc_tesc_tipo_escenario
	-- =============================================
	-- Author:                           <Manrrique>
	-- Create date: <26/10/2018>
	-- Description:   <Matenimiento a las la tabla tipo de escenario que se utiliza en la solicitud del salon de video de UTECVirtual>
	-- =============================================
    @opcion int,
    @tesc_codigo int,
    @tesc_nombre nvarchar(100)
AS
Begin
    if @opcion = 1
    begin
                    select tesc_codigo as Codigo, tesc_nombre as Nombre, tesc_fecha_creacion as FechaCreacion from vid_tesc_tipo_escenario
    end
    if @opcion = 2
    begin
                    insert into vid_tesc_tipo_escenario(tesc_nombre)
                    values(@tesc_nombre)
    end
    if @opcion = 3
    begin
                    update vid_tesc_tipo_escenario set tesc_nombre = @tesc_nombre where tesc_codigo = @tesc_codigo
    end
End
go


create procedure vid_proc_trec_tipo_recurso
	-- =============================================
	-- Author:                           <Manrrique>
	-- Create date: <26/10/2018>
	-- Description:   <Matenimiento a las la tabla tipo de recurso que se utiliza en la solicitud del salon de video de UTECVirtual>
	-- =============================================
    @opcion int,
    @trec_codigo int,
    @trec_nombre nvarchar(100)
AS
Begin
    if @opcion = 1
    begin
                    select trec_codigo as Codigo, trec_nombre as Nombre, trec_fecha_creacion as FechaCreacion from vid_trec_tipo_recurso
    end
    if @opcion = 2
    begin
                    insert into vid_trec_tipo_recurso(trec_nombre)
                    values(@trec_nombre)
    end
    if @opcion = 3
    begin
                    update vid_trec_tipo_recurso set trec_nombre = @trec_nombre where trec_codigo = @trec_codigo
    end
End
GO


alter procedure vid_proc_hhab_horarios_habiles
	-- =============================================
	-- Author:                           <Manrrique>
	-- Create date: <26/10/2018>
	-- Description:   <Matenimiento a las la tabla horarios habiles que se utiliza en la solicitud del salon de video de UTECVirtual>
	-- =============================================
    @opcion int,
    @hhab_codigo int,
    @hhab_horario nvarchar(100),
	@hhab_do int,
	@hhab_lu int,
	@hhab_ma int,
	@hhab_mi int,
	@hhab_ju int,
	@hhab_vi int,
	@hhab_sa int
AS
Begin
    if @opcion = 1
    begin
        select hhab_codigo as Codigo, hhab_horario as Nombre,
		hhab_do,
		hhab_lu,
		hhab_ma,
		hhab_mi,
		hhab_ju,
		hhab_vi,
		hhab_sa 
		from vid_hhab_horarios_habiles
    end
    if @opcion = 2
    begin
        insert into vid_hhab_horarios_habiles(hhab_horario,
											hhab_do,
											hhab_lu,
											hhab_ma,
											hhab_mi,
											hhab_ju,
											hhab_vi,
											hhab_sa)
        values(@hhab_horario,@hhab_do,
							@hhab_lu,
							@hhab_ma,
							@hhab_mi,
							@hhab_ju,
							@hhab_vi,
							@hhab_sa)
    end
    if @opcion = 3
    begin
                    update vid_hhab_horarios_habiles 
					set hhab_horario = @hhab_horario,
					hhab_do = @hhab_do,	
					hhab_lu = @hhab_lu,	
					hhab_ma = @hhab_ma,	
					hhab_mi = @hhab_mi,	
					hhab_ju = @hhab_ju,	
					hhab_vi = @hhab_vi,	
					hhab_sa = @hhab_sa	 
					where hhab_codigo = @hhab_codigo
                end
End
go




--select * from vid_solc_solicitudes
/*insert into adm_opm_opciones_menu(opm_codigo,	opm_nombre,	opm_link,	opm_opcion_padre,	opm_orden,	opm_sistema)
values	('853',	'Solicitud video',	'logo.html',	'663',	'12',	'U'),
		('854',	'Tipo de video',	'vid_tvid_tipo_video.aspx',	'853',	'1',	'U'),
		('855',	'Tipo de escenario',	'vid_tesc_tipo_escenario.aspx',	'853',	'2',	'U'),
		('856',	'Tipo de recurso',	'vid_trec_tipo_recurso.aspx',	'853',	'3',	'U'),
		('857',	'Horarios habiles',	'vid_hhab_horarios_habiles.aspx',	'853',	'4',	'U'),
		('858',	'Solicitudes',	'vid_solc_solicitudes.aspx',	'853',	'5',	'U');*/


		select * from adm_opm_opciones_menu where opm_codigo = 858
		update adm_opm_opciones_menu set opm_nombre = 'Solicitudes pendientes de aprobar' where opm_codigo = 859

		insert into adm_opm_opciones_menu(opm_codigo,	opm_nombre,	opm_link,	opm_opcion_padre,	opm_orden,	opm_sistema) values('862',	'Solicitudes aprobadas', 'vid_solc_solicitudes_aprobadas.aspx',	'854',	'5', 'U');





