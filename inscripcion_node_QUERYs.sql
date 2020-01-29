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
select * from ra_cil_ciclo
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
