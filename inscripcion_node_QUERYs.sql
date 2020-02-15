-- web_ins_genasesoria_azure  122, 190505
select * from ra_hpl_horarios_planificacion

-- 51-1943-2016 {190505, 5119432016, 26101991}		--CARNET DE PRUEBA PARA LAS PRACTICAS DE MATERIAS
-- 25-5866-2014 {176427, 2558662014, 31121986}		--CARNET DE PRUEBAS PARA ELECTIVAS
-- 29-2550-2015 {182391, 2925502015, L@r07031994}	--CARNET DE PRUEBAS VIRTUAL
-- 29-1027-2009 {200018, 2927572017, 17061994}		--CARNET DE PRUEBAS VIRTUAL 4ta matricula
-- 29-3333-2017 {200603, 2933332017, 26091991}		--CARNET DE PRUEBAS VIRTUAL
-- 29-1160-2015 {180873, 2911602015, Trunks2394}	--CARNET DE PRUEBAS PARA ELECTIVAS VIRTUAL
-- 22-0707-2016 {189130, 2207072016, 07031997}		--CARNET DE PRUEBAS PARA ELECTIVAS
-- 22-3583-2015 {183429, 2235832015, Edgardo1996@}	--CARNET DE PRUEBAS PARA ELECTIVAS
-- 31-1697-2018 {207471, 3116972018, 14051999} --TIENE HORARIO DOBLE(RARRO), 243(13:45-16:00/10:00-12:15)
-- 31-2755-2017 {200016, 3127552017, 28071996} --TIENE HORARIO DOBLE(RARRO), 243
-- 38-0823-2017 {196704, 3808232017, Menjivar0131*} --TIENE HORARIO DOBLE(RARRO), 270

-- 12-4116-2017 {150727, 1241162017, 24071992} --ES PRESENCIAL Y TIENE HORARIOS VIRTUALES Y SEMIPRESENCIAL

-- 66-4104-2018 {210049, 6641042018, 03101998} --TIENE HORARIO DOBLE CON DIAS
select * from adm_opm_opciones_menu
--update ra_man_grp_hor set man_nomhor = ltrim(rtrim(man_nomhor))
select matp_codigo, matp_codmat, matp_codmat_prac from ra_matp_mat_practicas where matp_estado = 1

select top 10 * from ra_ins_inscripcion where ins_codper = 173322 and ins_codcil = 122 order by ins_codigo desc

select * from ra_ins_inscripcion where ins_codper = 173322 and ins_codcil = 122

select * from ra_per_personas 
inner join ra_ins_inscripcion on ins_codper = per_codigo and ins_codcil = 120
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo and mai_codmat like '%SINF-%'
where SUBSTRING(per_carnet, 1, 2) = '29' and per_estado = 'A'

select * from ra_per_personas where SUBSTRING(per_carnet, 1, 2) = '25' and per_estado = 'A'
select * from ra_per_personas where per_codigo = 150727
select * from ra_man_grp_hor
declare @codins int
select @codins = ins_codigo from ra_ins_inscripcion where ins_codper = 1171854

delete from ra_mai_mat_inscritas where mai_codins = @codins
delete from ra_mai_mat_inscritas_especial where mai_codins = @codins
delete from ra_ins_inscripcion where ins_codigo = @codins

create table tbl_contador (id int, cantidad int)
insert into tbl_contador values (1, 10)
update tbl_contador set cantidad = 10
select * from ra_cola_espera



-- 83033 4632312002 10071982	--0
-- 173322 2532032014 Resident7	--1
-- 180168 2505272015 13021997	--1
-- 221719 1151772019 14071993	--15
-- 47898 5151971996	16081976 -- 0	

select * from ra_ins_inscripcion 
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
where ins_codper = 47898 and ins_codcil =122

select * from ra_ins_inscripcion where ins_codper = 47898 and ins_codcil = 122
select * from ra_mai_mat_inscritas where mai_codins = 1187811
web_ins_matinscritas 47898, 122
declare @codins int, @codper int = 47898, @codcil int = 122, @carnet varchar(12) = '5151971996'
select @codins = ins_codigo from ra_ins_inscripcion where ins_codper = @codper and ins_codcil = @codcil
delete from ra_not_notas where not_codmai in (
select mai_codigo from ra_mai_mat_inscritas where mai_codins = @codins
)
delete from ra_mai_mat_inscritas where mai_codins = @codins
delete from ra_ins_inscripcion where ins_codigo = @codins

--rvg_codper = @codper
if exists(select rvg_mensaje from ra_validaciones_globales where rvg_carnet = @carnet) 
begin 
	select distinct rvg_mensaje from ra_validaciones_globales where rvg_carnet = @carnet 
end 
else 
begin 
	select '4' as rvg_mensaje 
end
--select * from ra_validaciones_globales where rvg_carnet = '1219521982'
select per_codigo from ra_per_personas where per_codigo = 181324

--waitfor delay '23:01:02'

-- web_ins_matinscritas_azure 180168, 122
-- web_ins_matinscritas_azure 173322, 122

if exists (select rvg_mensaje from ra_validaciones_globales where rvg_carnet = '2505272015') 
begin 
select * from ra_validaciones_globales where rvg_mensaje = '0' 
end 
else 
begin 
select '4' as rvg_mensaje 
end


ALTER procedure [dbo].[web_ptl_login_ldap] 
	-- web_ptl_login_ldap '1161802013', 118, 93
	-- web_ptl_login_ldap '2515652015', 122, 93
       @cuenta varchar(50),
       @cil_codigo int, 
       @cil_codmae int
as
begin
       declare @cuenta_codigo int,@carnet varchar(12)

       if substring(@cuenta,1,1) in ('0','1','2','3','4','5','6','7','8','9')
       begin
             print 'if'
             set @carnet =substring(@cuenta,1,2)+'-'+substring(@cuenta,3,4)+'-'+substring(@cuenta,7,4)

             select @cuenta_codigo = per_codigo from ra_per_personas where per_carnet = @carnet
             
             if (select count(1) from pg_imp_ins_especializacion 
             join pg_apr_aut_preespecializacion on apr_codigo = imp_codapr 
             join ra_cil_ciclo on cil_codigo = apr_codcil
                    where cil_vigente_pre = 'S' and imp_codper = @cuenta_codigo)>0  or 
                    (
                           select count(1) 
                           from ra_egr_egresados 
                           join ra_cil_ciclo on cil_codigo = egr_codcil 
                           where egr_codper = @cuenta_codigo 
                           and not exists
                           (
                                  select 1 from ra_ins_inscripcion 
                                  inner join ra_cil_ciclo on
                                               cil_codigo = ins_codcil
                                               where ins_codcil = @cil_codigo and ins_codper = @cuenta_codigo and cil_codcic <> 3
                                  --where ins_codcil = @cil_codigo and ins_codper = @cuenta_codigo 
                                  and not exists 
                                  (select 1 from ra_mai_mat_inscritas_especial where mai_codins = ins_codigo)
                    ) 
             )>0
             begin
                select 'Preespecialidad' as tipo, per_nombres_apellidos as nombres, per_carnet, 
					per_codigo as codigo, pla_alias_carrera 
                from ra_per_personas 
				inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
				inner join ra_pla_planes on pla_codigo = alc_codpla
				where per_codigo = @cuenta_codigo And per_estado <> 'I'
             end          
             else 
             begin
                select case when per_tipo = 'U' then 'Alumno' 
                                    when per_tipo = 'M' then 'Maestria' 
                                    else per_tipo end as tipo,
                        per_nombres_apellidos as nombres,per_carnet,per_codigo as codigo, per_estado, pla_alias_carrera
                from ra_per_personas 
				inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
				inner join ra_pla_planes on pla_codigo = alc_codpla
				where per_codigo = @cuenta_codigo And per_estado = 'A'
             end
       end
       else 
       begin
             select 'Docente' as tipo,emp_nombres_apellidos as nombres,'' as per_carnet, emp_codigo as codigo, '' as per_estado
             from pla_emp_empleado 
             where emp_email_institucional = @cuenta+'@mail.utec.edu.sv' and emp_estado in ('A', 'J')
       end
end

--
--select Replace(per_tipo,'U','Alumno') as tipo,per_nombres_apellidos as nombres,per_carnet,per_codigo as codigo from ra_per_personas 
--where replace(per_carnet,'-','') = @cuenta AND per_tipo = 'U'
--union
--select replace(per_tipo,'M','Maestria')as tipo,per_nombres_apellidos as nombres,per_carnet,per_codigo as codigo from ra_per_personas 
--where replace(per_carnet,'-','') = @cuenta and per_tipo = 'M'
--union
--select 'Docente' as tipo,emp_nombres_apellidos as nombres,'' as per_carnet, emp_codigo as codigo from pla_emp_empleado where emp_email_institucional = @cuenta+'@mail.utec.edu.sv' and emp_estado in ('A', 'J')
--union
--select 'Preespecialidad' as tipo, per_nombres_apellidos as nombres, per_carnet, per_codigo as codigo from ra_per_personas join pg_imp_ins_especializacion
--join pg_apr_aut_preespecializacion on apr_codigo = imp_codapr join ra_cil_ciclo on cil_codigo = apr_codcil
--on imp_codper=per_codigo where replace(per_carnet,'-','') = @cuenta and cil_vigente_pre = 'S'
--end

ALTER PROCEDURE [dbo].[web_ins_cuposinserinscripcion_azure]
	@regional int,
	@codper int,
	@ins_codcil int,
	@hpl_codigo1 int,
	@hpl_codigo2 int,
	@hpl_codigo3 int,
	@hpl_codigo4 int,
	@hpl_codigo5 int,
	@hpl_codigo6 int,
	@hpl_codigo7 int,
	@hpl_codigo8 int,
	@hpl_codigo9 int,
	@hpl_codigo10 int,
	@ins_ip nvarchar(25)
AS
begin
	if(
	select count(1) from inscripcion.dbo.ra_ins_inscripcion inner join inscripcion.dbo.ra_mai_mat_inscritas on ins_codigo = mai_codins
	where ins_codcil = @ins_codcil and ins_codper = @codper
	) = 0
	begin --verifica si no tiene inscripcion.
		declare  @ins_codigo int,@usuario nvarchar(50),@codmat nvarchar(10),
		@continuar int, @total int,@hpl_codigo int,@sincupo int,@clave nvarchar(10),@i int
                                                               
		--ingresa en variable las materias seleccionadas
		declare @seleccion table (id int identity(1,1), hpl_codigo int)

		insert into @seleccion (hpl_codigo)
		values (@hpl_codigo1), (@hpl_codigo2),(@hpl_codigo3),(@hpl_codigo4),(@hpl_codigo5),
		(@hpl_codigo6),(@hpl_codigo7),(@hpl_codigo8),(@hpl_codigo9),(@hpl_codigo10)
		
		select @sincupo =  dbo.web_ins_fncupo_azure(@ins_codcil,@hpl_codigo1,@hpl_codigo2,@hpl_codigo3,@hpl_codigo4,@hpl_codigo5,@hpl_codigo6,@hpl_codigo7,@hpl_codigo8,@hpl_codigo9,@hpl_codigo10)

		if @sincupo > 0--Significa que hay una materia que ya no tiene cupos
		begin
			select @sincupo
		end
		else--Todas las materias seleccionadas tienen cupo, se realiza la inscripcion
		begin
			--genera clave aleatoria
			set @i = 1
			set @clave = ''
			while @i <=10
			begin
				select  @clave = @clave+char(convert(real,substring(convert(char(18),rand()),8,1)) /10 *25 + 65)
				set @i = @i + 1
			end                                            
			--comienza insert de cabezera
			begin transaction 
			if exists(select 1 from inscripcion.dbo.ra_ins_inscripcion with (nolock) where ins_codper = @codper and ins_codcil = @ins_codcil)--apuntar a bd 2
			begin
				select @ins_codigo = ins_codigo from inscripcion.dbo.ra_ins_inscripcion with (nolock) where ins_codcil = @ins_codcil and ins_codper = @codper --apuntar a bd 2
			end
			else
			begin
				exec web_ins_insinscripcion_azure @regional,@codper,@ins_codcil,@usuario,@clave,@ins_ip --sp --apuntar a bd 2
				select @ins_codigo = ins_codigo
				from inscripcion.dbo.ra_ins_inscripcion with (nolock) --apuntar a bd 2
				where ins_codcil  = @ins_codcil and ins_codper = @codper
			end
			set @continuar = 1
			select  @total = count(1) from @seleccion where hpl_codigo <> 0
			--inserta todas las materias seleccionadas
			while (@continuar <=  @total)
			begin
				select @hpl_codigo = hpl_codigo from @seleccion where id = @continuar
				select @codmat = hpl_codmat from ra_hpl_horarios_planificacion with (nolock) where hpl_codcil = @ins_codcil and hpl_codigo = @hpl_codigo
				execute web_ins_detinscripcion_azure @regional,@ins_codigo,@codper,@codmat,@hpl_codigo,'','',@usuario,'n',@ins_codcil  --apuntar a bd 2
				set @continuar = @continuar + 1
			end 
			if @@error <> 0
			begin
				rollback transaction
				select 0
				return
			end
			else
			begin
				--rollback transaction
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

ALTER function [dbo].[web_ins_fnCupo_azure](
	@codcil int,
	@hpl_codigo1 int,
	@hpl_codigo2 int,
	@hpl_codigo3 int,
	@hpl_codigo4 int,
	@hpl_codigo5 int,
	@hpl_codigo6 int,
	@hpl_codigo7 int,
	@hpl_codigo8 int,
	@hpl_codigo9 int,
	@hpl_codigo10 int
)
returns int as
begin
	declare @tot int, @tipo_mat nvarchar(1),@continuar int,@hpl_codigo int,@conteo_asesorias int,@conteo_materias int
	declare @azure int , @produc int

	declare @seleccion table (id int identity(1,1), hpl_codigo int)

	insert into @seleccion (hpl_codigo)
	values (@hpl_codigo1), (@hpl_codigo2),(@hpl_codigo3),(@hpl_codigo4),(@hpl_codigo5),
		(@hpl_codigo6),(@hpl_codigo7),(@hpl_codigo8),(@hpl_codigo9),(@hpl_codigo10)

	set @conteo_asesorias = 0
	set @conteo_materias = 0

	set @continuar = 1
	select  @tot = count(1) from @seleccion where hpl_codigo <> 0

	while (@continuar <=  @tot)
	begin
		select @hpl_codigo = hpl_codigo from @seleccion where id = @continuar
		select @tipo_mat = hpl_tipo_materia from ra_hpl_horarios_planificacion where hpl_codigo = @hpl_codigo

		if(@tipo_mat = 'A')--Asesoria
		begin
			select @azure=count(1) from inscripcion.dbo.ra_mai_mat_inscritas_especial with (nolock) where mai_codhor = @hpl_codigo
			select @produc=count(1) from ra_mai_mat_inscritas_especial with (nolock) where mai_codhor = @hpl_codigo
			set @conteo_asesorias = @conteo_asesorias+(select case when (hpl_max_alumnos -(@azure+@produc)) <=0 then 1 else 0 end as verifica
			from ra_hpl_horarios_planificacion 
			where hpl_codcil = @codcil and hpl_codigo =@hpl_codigo)   
			if @conteo_asesorias > 0
			begin
				set @conteo_asesorias = @hpl_codigo
				set @continuar =  @tot
			end
		end
		else --No es asesoria, es materia normal
		begin
			select @azure=count(1) from inscripcion.dbo.ra_mai_mat_inscritas with (nolock) where mai_codhpl = @hpl_codigo
			select @produc=count(1) from ra_mai_mat_inscritas with (nolock) where mai_codhpl = @hpl_codigo
			set @conteo_materias = @conteo_materias+(select case when (hpl_max_alumnos -(@azure+@produc)) <=0 then 1 else 0 end as verifica
			from ra_hpl_horarios_planificacion 
			where hpl_codcil = @codcil and hpl_codigo =@hpl_codigo)
			if @conteo_materias > 0
			begin
			set @conteo_materias = @hpl_codigo
			set @continuar =  @tot
			end
		end
		set @continuar = @continuar + 1
	end 

	declare @retorno int
	if @conteo_asesorias > 0
	begin
		set @retorno = @conteo_asesorias
	end
	else if @conteo_materias > 0
	begin
		set @retorno = @conteo_materias
	end
	else
	begin
		set @retorno = @conteo_materias+@conteo_asesorias
	end

	return @retorno
end

ALTER procedure [dbo].[web_ins_matinscritas]
	@codper int,
	@codcil int 
as
begin
	declare @cicloins nvarchar(10)

	select @cicloins = '0'+convert(varchar(2),cil_codcic)+'-'+convert(varchar(4),cil_anio) 
	from ra_cil_ciclo where cil_codigo = @codcil

	declare @ins table (ins_codigo int, ins_codper int, mai_codmat nvarchar(12), mai_codhpl int, mai_matricula int, mai_estado nvarchar(5))
	declare @insesp table (codigo int, codper int, mai_codmat nvarchar(12), mai_codhor int, mai_matricula int, mai_estado nvarchar(5))

	SELECT per_carnet,rtrim(per_nombres) +' '+ltrim(per_apellidos) as nombre_ape,pla_alias_carrera,pla_anio,
	concat('Clave de inscripción: ',isnull(ins_clave,'PRESENCIAL'),', Fecha de inscripción: ', Convert(varchar,ins_fecha))as fecha_ins,
	@cicloins cicloins
	, ins_codigo
	FROM ra_pla_planes INNER JOIN
		ra_alc_alumnos_carrera ON ra_pla_planes.pla_codigo = ra_alc_alumnos_carrera.alc_codpla INNER JOIN
		ra_per_personas ON ra_alc_alumnos_carrera.alc_codper = ra_per_personas.per_codigo inner join 
		ra_ins_inscripcion on ins_codper = per_codigo and ins_codcil = @codcil
	WHERE ra_per_personas.per_codigo = @codper

	insert into @ins(ins_codigo, ins_codper, mai_codmat, mai_codhpl, mai_matricula, mai_estado)
	select ins_codigo, ins_codper, mai_codmat, mai_codhpl, mai_matricula, mai_estado
	--into #ins
	from ra_ins_inscripcion
	join ra_mai_mat_inscritas on mai_codins = ins_codigo
	where ins_codcil = @codcil
	and mai_codpla = (select alc_codpla from ra_alc_alumnos_carrera where alc_codper = ins_codper)
	and ins_codper in (select per_codigo
	from ra_per_personas
	where ins_codper = @codper)

	insert into @insesp(codigo, codper, mai_codmat, mai_codhor, mai_matricula, mai_estado)
	select ins_codigo codigo, ins_codper codper, mai_codmat, mai_codhor, mai_matricula, mai_estado
	--into #insesp
	from ra_ins_inscripcion
	join ra_mai_mat_inscritas_especial on mai_codins = ins_codigo
	where ins_codcil = @codcil
	and ins_codper in (select per_codigo
	from ra_per_personas
	where ins_codper = @codper)

	select mat_codigo,materia, hpl_descripcion,estado, mai_matricula, horas,
	--substring(dias,1,len(dias)-1) 
	case when dias <> '' then dias 
		else dbo.fechas_materias_especiales(hpl_codigo) 
	end as dias,aul_nombre_corto
	from
	(
			select mat_codigo ,
			--mat_nombre + ltrim(case when hpl_tipo_materia = 'P' then '' 
		--										   when hpl_tipo_materia = 'S' then '(Semi-presencial)' 
		--										   when hpl_tipo_materia = 'V' then '(Virtual)' 
		--										   when hpl_tipo_materia = 'A' then '(Práctica)' 
		--										   else hpl_tipo_materia 
		--									end)  as Materia,
		rtrim(Isnull(plm_alias,'')) + 
			case when tpm_mostrar_descripcion = 1 then ' (' + tpm_descripcion + ')'
				 when tpm_mostrar_descripcion = 0 then ' '
			end as Materia,
		hpl_descripcion, hpl_codigo,
		case when mai_estado = 'I' then 'Ins' else 'Ret' end estado, mai_matricula,
		isnull(man_nomhor,'sin Asignar')as horas,
		case when hpl_lunes = 'S' then 'LUNES-' ELSE '' END + 
		case when hpl_martes = 'S' then 'MARTES-' ELSE '' END + 
		case when hpl_miercoles = 'S' then 'MIERCOLES-' ELSE '' END + 
		case when hpl_jueves = 'S' then 'JUEVES-' ELSE '' END + 
		case when hpl_viernes = 'S' then 'VIERNES-' ELSE '' END + 
		case when hpl_sabado = 'S' then 'SABADO-' ELSE '' END + 
		case when hpl_domingo = 'S' then 'DOMINGO-' ELSE '' END DIAS,aul_nombre_corto
		--from #ins
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
		select mat_codigo ,
			--mat_nombre + ltrim(case when hpl_tipo_materia = 'P' then '' 
		--										   when hpl_tipo_materia = 'S' then '(Semi-presencial)' 
		--										   when hpl_tipo_materia = 'V' then '(Virtual)' 
		--										   when hpl_tipo_materia = 'A' then '(Práctica)' 
		--										   else hpl_tipo_materia 
		--									end)  as Materia,
		rtrim(Isnull(mat_nombre,'')) + 
			case when tpm_mostrar_descripcion = 1 then ' (' + tpm_descripcion + ')'
				 when tpm_mostrar_descripcion = 0 then ' '
			end as Materia,
		hpl_descripcion, hpl_codigo,
		case when mai_estado = 'I' then 'Ins' else 'Ret' end estado, mai_matricula,
		isnull(man_nomhor,'sin Asignar')as horas,
		case when hpl_lunes = 'S' then 'LUNES-' ELSE '' END + 
		case when hpl_martes = 'S' then 'MARTES-' ELSE '' END + 
		case when hpl_miercoles = 'S' then 'MIERCOLES-' ELSE '' END + 
		case when hpl_jueves = 'S' then 'JUEVES-' ELSE '' END + 
		case when hpl_viernes = 'S' then 'VIERNES-' ELSE '' END + 
		case when hpl_sabado = 'S' then 'SABADO-' ELSE '' END + 
		case when hpl_domingo = 'S' then 'DOMINGO-' ELSE '' END DIAS,aul_nombre_corto
		--from #insesp
		from @insesp
		join ra_per_personas on per_codigo = codper
		join ra_alc_alumnos_carrera on alc_codper = per_codigo
		join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhor
		join dbo.ra_man_grp_hor on man_codigo = hpl_codman
		join ra_mat_materias on mat_codigo = mai_codmat
		--join ra_plm_planes_materias on plm_codpla = alc_codpla and plm_codmat = mai_codmat
		left join ra_aul_aulas on aul_codigo = hpl_codaul
		join ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia
	) t
	--drop table #ins
end


drop type tbl_hpls
create type tbl_hpls as table(hpl int, codmat varchar(30), seccion varchar(4), especial char(1), estado smallint);
go
--estado:{
-- -1: "delete",
--	0: "sin accion",
--	1: "insertar"
--}
--especial{
--	1: "se busca en ra_mai_mat_inscritas_especial",
--	0: "se busca en ra_mai_mat_inscritas"
--}

declare @mi_hpl as tbl_hpls
insert into @mi_hpl (hpl, codmat, seccion, especial, estado) 
values(41692, 'COF1-E   ', '11', 0, -1),
(41733, 'DPCM2-DA', '03', 1, 0),
(41809, 'DEBAP11-D', '01', 0, 0),
(41889, 'PRIPU-D  ', '01', 0, 0),
(41965, 'DPCM2-D', '01', 0, 0)

select * from @mi_hpl

create procedure sp_prueba_tvp
	@tbl tbl_hpls readonly
as
begin
	select hpl, especial, estado from @tbl
end

declare @mi_hpl as tbl_hpls
insert into @mi_hpl (hpl, estado) values (11, 0)

select * from ra_ins_inscripcion inner join ra_mai_mat_inscritas on mai_codins = ins_codigo 
where ins_codper = 173322 and ins_codcil = 122

declare @mi_hpl as tbl_hpls
insert into @mi_hpl (hpl, codmat, seccion, especial, estado) 
values (41659, 'SIOP-I   ', '02', 0, 0), 
(41301, 'ASEM-I   ', '01', 0, 1)

exec web_mod_ins_cuposinserinscripcion_azure 1, 173322, 122, 1178757, @mi_hpl,'192.168.114.69'

create procedure web_mod_ins_cuposinserinscripcion_azure
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-02-01 10:11:13.349>
	-- Description: <Realiza la modificacion de horarios de los horarios de materias inscritas desde el portal de inscripcion en nodejs>
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
	declare @hpl int, @codmat varchar(30), @seccion varchar(4), @especial char(1), @estado smallint, @cupos_agotados bit = 0, @hpl_cupos_agotados int, @inserto_materia bit
	declare @hpl_max_alumnos tinyint, @hpl_alumnos_inscritos tinyint, @hpl_alumnos_inscritos_azure tinyint, @usuario nvarchar(1)
	begin transaction 

	declare m_cursor cursor fast_forward
	for
		select hpl, codmat, seccion, especial, estado from @tbl_hpls
	open m_cursor
	fetch next from m_cursor into @hpl, @codmat, @seccion, @especial, @estado
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
				select @hpl_max_alumnos = hpl_max_alumnos from ra_hpl_horarios_planificacion where hpl_codigo = @hpl
				select @hpl_alumnos_inscritos = count(1) from ra_mai_mat_inscritas_especial where mai_codhor = @hpl
				select @hpl_alumnos_inscritos_azure = count(1) from Inscripcion.dbo.ra_mai_mat_inscritas_especial where mai_codhor = @hpl
			end
			else
			begin
				select @hpl_max_alumnos = hpl_max_alumnos from ra_hpl_horarios_planificacion where hpl_codigo = @hpl
				select @hpl_alumnos_inscritos = count(1) from ra_mai_mat_inscritas where mai_codhpl = @hpl
				select @hpl_alumnos_inscritos_azure = count(1) from Inscripcion.dbo.ra_mai_mat_inscritas where mai_codhpl = @hpl
			end
			if ((@hpl_alumnos_inscritos + @hpl_alumnos_inscritos_azure) < @hpl_max_alumnos)
			begin --Se procede a inscribir, hay cupos
				print 'cupos disponibles'
				execute web_ins_detinscripcion_azure @regional, @codins, @codper, @codmat, @hpl,'','', @usuario, 'n', @ins_codcil  --apuntar a bd 2
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
		into @hpl, @codmat, @seccion, @especial, @estado
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

create procedure [dbo].[web_ins_matinscritas_data]
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-01-31 17:56:07.210>
	-- Description: <Devuelve la data de las materias inscritas segun la misma forma de retorno del procedimiento: web_ins_genasesoria_azure>
	-- =============================================
	-- exec web_ins_matinscritas_data 190505, 122
	@codper int,
	@codcil int 
as
begin
	declare @cicloins nvarchar(10)
	select carnet, codigo, materia, matricula, hor_descripcion, man_nomhor,
	case when dias <> '' then substring(dias,1,len(dias)-1) else dbo.fechas_materias_especiales(hpl_codigo) end as dias,
	plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, especial, hpl_tipo_materia
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
	plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, mat_tipo 'especial', hpl_tipo_materia
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
	plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, mat_tipo, hpl_tipo_materia
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

create procedure web_ins_genasesoria_azure_2
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-02-01 11:24:10.537>
	-- Description: <Devuelve la data de la hoja de asesoria al igual que el procedimiento "web_ins_genasesoria_azure" 
	--				a diferencia que este retorna la misma data del proc "web_ins_genasesoria_azure" MAS la data de 
	--				las materias inscritas("web_ins_matinscritas_data") >
	-- =============================================
	-- web_ins_genasesoria_azure_2 190505, 122
	-- web_ins_genasesoria_azure 122, 190505
	@codper int,
	@codcil int
as
begin
	declare @tbl_hoja_asesoria as table (carnet nvarchar(15), codigo nvarchar(20), materia nvarchar(125), matricula nvarchar(2), hor_descripcion nvarchar(2), man_nomhor nvarchar(50), 
	dias nvarchar(50), plm_ciclo int, hpl_codigo int, hpl_codman int, plm_electiva nvarchar(1), plm_bloque_electiva int, especial nvarchar(1), hpl_tipo_materia nvarchar(2), cumgrl float, 
	cumciclo float, per_nombre nvarchar(125), carrera nvarchar(125), aplan nvarchar(25), mat_aprobadas int, mat_reprobadas int, mat_aprobadasciclo int, mat_reprobadasciclo int)

	insert into @tbl_hoja_asesoria (carnet, codigo, materia, matricula, hor_descripcion, man_nomhor, dias, plm_ciclo, hpl_codigo, hpl_codman, plm_electiva, plm_bloque_electiva, 
	especial, hpl_tipo_materia, cumgrl, cumciclo, per_nombre, carrera, aplan, mat_aprobadas, mat_reprobadas, mat_aprobadasciclo, mat_reprobadasciclo)
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
	dias nvarchar(50), plm_ciclo int, hpl_codigo int, hpl_codman int, plm_electiva nvarchar(1), plm_bloque_electiva int, especial nvarchar(1), hpl_tipo_materia nvarchar(2))
	insert into @tbl_mat_ins 
	(carnet, codigo, materia, matricula, hor_descripcion, man_nomhor, dias, plm_ciclo, hpl_codigo, 
	hpl_codman, plm_electiva, plm_bloque_electiva, especial, hpl_tipo_materia)
	exec web_ins_matinscritas_data @codper, @codcil
	select *,  row_number() over(order by plm_ciclo, codigo,Materia,hor_descripcion) 'num' from (
		select distinct * from (
			select * from @tbl_hoja_asesoria
			union 
			select *, @cumgrl, @cumciclo, @per_nombre, 
			@carrera, @aplan, @mat_aprobadas, @mat_reprobadas, @mat_aprobadasciclo, @mat_reprobadasciclo 
			from @tbl_mat_ins
		) t
	) t2
	order by plm_ciclo, codigo, materia, hor_descripcion
end

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
	@ins_codcil int
as
begin
	set dateformat dmy
	declare @registros int, @codpla int, @uv int, @codrr int, @codhpl int, @tipo_materia varchar(2)
	--APUNTAR BD 2
	if ((select count(1)from ra_hpl_horarios_planificacion where hpl_codigo = @codhor and hpl_tipo_materia = 'A')>0 
	or (select count(1) from ra_mat_materias where mat_codigo = @codmat and mat_tipo = 'S') > 0)
	begin --Es materia especial
		print 'Es materia especial'
		select @registros = count(1) from Inscripcion.dbo.ra_mai_mat_inscritas_especial  
		where mai_codmat = @codmat and mai_codins = @codins

		if (@registros = 0)
		begin
			if(select count(1) from Inscripcion.dbo.ra_mai_mat_inscritas_especial)=0
			begin
				insert into Inscripcion.dbo.ra_mai_mat_inscritas_especial(mai_codreg,mai_codins,mai_codigo,mai_codmat,
				mai_codhor,mai_estado,mai_matricula, mai_fecha, mai_acuerdo, 
				mai_fecha_acuerdo,mai_financiada,mai_codpla,mai_uv, mai_tipo)
				select @regional, @codins, isnull(max(mai_codigo),0)+1, 
				@codmat, @codhor, 'I', 1, getdate(), 
				@acuerdo, case when @fecha_acuerdo = '' then null else convert(datetime,@fecha_acuerdo,103) end,'N',
				0, 0, @tipo_ins
				from ra_mai_mat_inscritas_especial --APUNTAR BD 2
			end
			else
			begin								
				insert into Inscripcion.dbo.ra_mai_mat_inscritas_especial(mai_codreg,mai_codins,mai_codigo,mai_codmat,
				mai_codhor,mai_estado,mai_matricula, mai_fecha, mai_acuerdo, 
				mai_fecha_acuerdo,mai_financiada,mai_codpla,mai_uv, mai_tipo)
				select @regional, @codins, isnull(max(mai_codigo),0)+1, 
				@codmat, @codhor, 'I', 1, getdate(), 
				@acuerdo, case when @fecha_acuerdo = '' then null else convert(datetime,@fecha_acuerdo,103) end,'N',
				0, 0, @tipo_ins
				from Inscripcion.dbo.ra_mai_mat_inscritas_especial --APUNTAR BD 2
			end
		end
	end
	else
	begin
		print 'NO es materia especial'
		select @codpla = alc_codpla from ra_alc_alumnos_carrera where alc_codper = @codper
		select @uv = plm_uv from ra_plm_planes_materias where plm_codpla = @codpla and plm_codmat = @codmat
		select @registros = count(1) from Inscripcion.dbo.ra_mai_mat_inscritas 
		where mai_codmat = @codmat and mai_codins = @codins

		if (@registros = 0)
		begin
			print '@registros = 0'
			declare @matricula int
			select @matricula = isnull(max(mai_matricula),0) 
			from ra_ins_inscripcion
			join ra_mai_mat_inscritas on mai_codins = ins_codigo
			where ins_codper = @codper
			and mai_codmat = @codmat
			and mai_estado = 'I'
			if(select count(1) from Inscripcion.dbo.ra_mai_mat_inscritas)=0
			begin--APUNTAR BD 2
				insert into Inscripcion.dbo.ra_mai_mat_inscritas(mai_codreg,mai_codins,mai_codigo,mai_codmat,
				mai_codhor,mai_estado,mai_matricula, mai_fecha, mai_acuerdo, 
				mai_fecha_acuerdo,mai_financiada,mai_codpla,mai_uv, mai_tipo,mai_codhpl)
				select @regional, @codins, isnull(max(mai_codigo),0)+1, 
				@codmat, 0, 'I', @matricula + 1, getdate(), 
				@acuerdo, case when @fecha_acuerdo = '' then null else convert(datetime,@fecha_acuerdo,103) end,'N',
				@codpla, @uv, @tipo_ins,@codhor
				from ra_mai_mat_inscritas --APUNTAR BD 2

				select @codrr = max(not_codigo) from ra_not_notas

				insert into ra_not_notas 
				select row_number() over (order by mai_codigo)+@codrr,pom_codigo,mai_codigo,0,'R',getdate(),'',0
				from Inscripcion.dbo.ra_ins_inscripcion
				join Inscripcion.dbo.ra_mai_mat_inscritas on mai_codins = ins_codigo 
				join ra_pom_ponderacion_materia on pom_codcil = ins_codcil and pom_codmat = mai_codmat
				where pom_codpon in (1,2,3,4,5)
				and ins_codigo = @codins
				and mai_codmat = @codmat
			end
			else
			begin
				insert into Inscripcion.dbo.ra_mai_mat_inscritas(mai_codreg,mai_codins,mai_codigo,mai_codmat,
				mai_codhor,mai_estado,mai_matricula, mai_fecha, mai_acuerdo, 
				mai_fecha_acuerdo,mai_financiada,mai_codpla,mai_uv, mai_tipo,mai_codhpl)
				select @regional, @codins, isnull(max(mai_codigo),0)+1, 
				@codmat, 0, 'I', @matricula + 1, getdate(), 
				@acuerdo, case when @fecha_acuerdo = '' then null else convert(datetime,@fecha_acuerdo,103) end,'N',
				@codpla, @uv, @tipo_ins,@codhor
				from Inscripcion.dbo.ra_mai_mat_inscritas --APUNTAR BD 2

				select @codrr = max(not_codigo) from ra_not_notas

				insert into ra_not_notas 
				select row_number() over (order by mai_codigo)+@codrr,pom_codigo,mai_codigo,0,'R',getdate(),'',0
				from Inscripcion.dbo.ra_ins_inscripcion
				join Inscripcion.dbo.ra_mai_mat_inscritas on mai_codins = ins_codigo 
				join ra_pom_ponderacion_materia on pom_codcil = ins_codcil and pom_codmat = mai_codmat
				where pom_codpon in (1,2,3,4,5)
				and ins_codigo = @codins
				and mai_codmat = @codmat
			end
		end
	end

	declare @registro varchar(100), @fecha datetime
	set @fecha = getdate()

	select @registro = cast(@codper as varchar) + ' ' + @codmat + ' ' +
	cast(@codhor as varchar) + ' ' +
	cast(@codins as varchar) + ' ' + 'S'
	--	exec auditoria_del_sistema 'ra_mai_mat_inscritas','I',@usuario,@fecha,@registro
	--commit transaction
	return
end

select * from ins_errins_errores_inscrpcion
drop table ins_errins_errores_inscrpcion
create table ins_errins_errores_inscrpcion (
	errins_codigo int primary key identity(1,1),
	errins_codper int,
	errins_codcil smallint,
	errins_proc_invocado varchar(255),
	errins_mensaje_error varchar(max),
	errins_parametros varchar(max),
	errins_fecha_creacion datetime default getdate()
)

create procedure sp_ins_errins_errores_inscrpcion
	@opcion int,
	@errins_codper int, 
	@errins_codcil int, 
	@errins_proc_invocado varchar(255), 
	@errins_mensaje_error varchar(max), 
	@errins_parametros varchar(max)
as
begin
	if @opcion = 1
	begin
		insert into ins_errins_errores_inscrpcion (errins_codper, errins_codcil, errins_proc_invocado, errins_mensaje_error, errins_parametros)
		values (@errins_codper, @errins_codcil, @errins_proc_invocado, @errins_mensaje_error, @errins_parametros)
		select 1
	end
end