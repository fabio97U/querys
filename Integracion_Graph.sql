--select * from ra_hpl_horarios_planificacion where hpl_codcil = 129 and hpl_codemp in (4375, 2012)

alter table ra_hpl_horarios_planificacion add hpl_requiere_ms_teams int default 0 not null
alter table ra_hpl_horarios_planificacion add hpl_ms_teams_id varchar(40) default '' not null
--update ra_hpl_horarios_planificacion set hpl_ms_teams_id = ''
--update ra_hpl_horarios_planificacion set hpl_requiere_ms_teams = 0
--update ra_hpl_horarios_planificacion set hpl_requiere_ms_teams = 1 where hpl_codigo in (50023, 50092)

--select * from ra_esc_escuelas
--alter table ra_esc_escuelas add esc_correos_responsables_ms_teams varchar(2048) default ''
--update ra_esc_escuelas set esc_correos_responsables_ms_teams = 'wilfredo.marroquin@mail.utec.edu.sv,ana.huezo@mail.utec.edu.sv' where esc_codigo = 1
--update ra_esc_escuelas set esc_correos_responsables_ms_teams = 'rene.paniagua@mail.utec.edu.sv' where esc_codigo = 2
update ra_esc_escuelas set esc_correos_responsables_ms_teams = 'domingo.alfaro@mail.utec.edu.sv,aldo.maldonado@mail.utec.edu.sv,antonio.herrera@mail.utec.edu.sv' where esc_codigo = 3
--update ra_esc_escuelas set esc_correos_responsables_ms_teams = 'edwin.callejas@mail.utec.edu.sv' where esc_codigo = 4
update ra_esc_escuelas set esc_correos_responsables_ms_teams = 'patricia.alfaro@mail.utec.edu.sv,manuel.rodriguez@mail.utec.edu.sv,jaime.canas@mail.utec.edu.sv,karen.guerra@mail.utec.edu.sv,carolina.moran@mail.utec.edu.sv' where esc_codigo = 5
update ra_esc_escuelas set esc_correos_responsables_ms_teams = 'jose.cornejo@mail.utec.edu.sv,karen.hernandez@mail.utec.edu.sv,augusto.villalta@mail.utec.edu.sv,sandra.cantarero@mail.utec.edu.sv,genaro.hernandez@mail.utec.edu.sv' where esc_codigo = 6
--update ra_esc_escuelas set esc_correos_responsables_ms_teams = 'wilfredo.marroquin@mail.utec.edu.sv,laura.romagoza@mail.utec.edu.sv' where esc_codigo = 7
--update ra_esc_escuelas set esc_correos_responsables_ms_teams = 'wilfredo.marroquin@mail.utec.edu.sv,fatima.argueta@mail.utec.edu.sv' where esc_codigo = 8
update ra_esc_escuelas set esc_correos_responsables_ms_teams = 'jose.cornejo@mail.utec.edu.sv,karen.hernandez@mail.utec.edu.sv,victor.rivas@mail.utec.edu.sv,cecilia.mendez@mail.utec.edu.sv' where esc_codigo = 9
--update ra_esc_escuelas set esc_correos_responsables_ms_teams = 'adriana.baires@mail.utec.edu.sv' where esc_codigo = 10
--update ra_esc_escuelas set esc_correos_responsables_ms_teams = 'ligia.henriquez@mail.utec.edu.sv' where esc_codigo = 13

--delete from ra_tae_tramites_academicos_efectuados where tae_codmai in (
--select mai_codigo from ra_mai_mat_inscritas 
--where mai_codhpl in (49693) and mai_codigo not in (5403184,5403199,5403269)
--)
--delete from ra_not_notas where not_codmai in (
--select mai_codigo from ra_mai_mat_inscritas 
--where mai_codhpl in (49693) and mai_codigo not in (5403184,5403199,5403269)
--)
--delete from ra_mai_mat_inscritas 
--where mai_codhpl in (49693) and mai_codigo not in (5403184,5403199,5403269)

--select * from ra_ins_inscripcion where ins_codigo in (
--select mai_codins from ra_mai_mat_inscritas 
--where mai_codhpl in (49693) and mai_codigo in (5403184,5403199,5403269)
--)

-- drop table graph_hth_historico_teams_hpl
create table graph_hth_historico_teams_hpl(
	hth_codigo int primary key identity (1, 1),
	hth_codhpl int,
	--hth_codper int,
	--hth_codemp int,
	hth_ms_teams_id varchar(40) not null,
	hth_displayname_teams varchar(200) not null,
	hth_estado varchar(10) default 'creado'/*creado, eliminado*/,

	hth_codusr int,
	hth_fecha_creacion datetime default getdate()
)
-- select * from graph_hth_historico_teams_hpl

-- drop table graph_rmt_responsable_materia_teams
create table graph_rmt_responsable_materia_teams (
	rmt_codigo int primary key identity (1, 1),
	rmt_codmat varchar(30),
	rmt_correo_responsables varchar(1024),
	rmt_codusr int,
	rmt_fecha_creacion datetime default getdate()
)
-- select * from graph_rmt_responsable_materia_teams where rmt_codmat = 'CYCO-E'

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2022-10-22 23:06:48.107>
	-- Description: <Vista que retorna las materias que requieren teams>
	-- =============================================
	-- select * from vst_graph_materias_msteams where codhpl in (52556, 52557, 52558, 52560, 52561, 52562, 52563, 52978) order by codmat
	-- select * from vst_graph_materias_msteams where codhpl in (52548, 52549, 52550, 52551, 52552, 52553, 52554, 52555) order by codmat
create view vst_graph_materias_msteams
as
	select codhpl, codcil, ciclo, codmat, materia, seccion, man_nomhor, dias, hpl_tipo_materia, codemp, 
		emp_nombres_apellidos, hpl_requiere_ms_teams, hpl_ms_teams_id, 
		concat(ciclo, '_', codmat, '_', seccion, '_', dias, man_nomhor) 'displayname_teams',
		concat(ciclo, '_', materia, '_', seccion, '_', dias, man_nomhor) 'description_teams',
		codesc, escuela, codfac, facultad, esc_correos_responsables_ms_teams
	from (
		select hpl_codigo 'codhpl', hpl_codcil codcil, concat('0', cil_codcic, cil_anio) 'ciclo', ltrim(rtrim(hpl_codmat)) codmat, 
			ltrim(rtrim(mat_nombre)) materia, hpl_descripcion seccion, man_nomhor, 
			case when isnull(hpl_lunes,'N') = 'S' then 'Lu-' else '' end+
			case when isnull(hpl_martes,'N') = 'S' then 'Ma-' else '' end+
			case when isnull(hpl_miercoles,'N') = 'S' then 'Mie-' else '' end+
			case when isnull(hpl_jueves,'N') = 'S' then 'Ju-' else '' end+
			case when isnull(hpl_viernes,'N') = 'S' then 'Vi-' else '' end+
			case when isnull(hpl_sabado,'N') = 'S' then 'Sab-' else '' end+
			case when isnull(hpl_domingo,'N') = 'S' then 'Dom-' else '' end dias,
			hpl_tipo_materia, hpl_codemp 'codemp', emp_nombres_apellidos, hpl_requiere_ms_teams, hpl_ms_teams_id,
			esc_codigo codesc, esc_nombre escuela, fac_codigo codfac, fac_nombre facultad, 
			case when rmt_codigo is not null then rmt_correo_responsables else esc_correos_responsables_ms_teams end
			esc_correos_responsables_ms_teams
		from ra_hpl_horarios_planificacion 
			inner join ra_cil_ciclo on hpl_codcil = cil_codigo
			inner join ra_man_grp_hor on hpl_codman = man_codigo
			inner join ra_mat_materias on hpl_codmat = mat_codigo
			left join pla_emp_empleado on hpl_codemp = emp_codigo
			inner join ra_esc_escuelas on mat_codesc = esc_codigo
			inner join ra_fac_facultades on esc_codfac = fac_codigo
			
			left join graph_rmt_responsable_materia_teams on rmt_codmat = hpl_codmat

		where hpl_requiere_ms_teams = 1 and hpl_estado = 'A' and hpl_tipo_materia in ('P', 'V')
			and hpl_codmat not like 'INDUC%'
	) t
go

-- drop table graph_umt_usuarios_miembros_teams
create table graph_umt_usuarios_miembros_teams(
	umt_codigo int primary key identity(1, 1),
	umt_codhpl int not null,
	umt_codper int,
	umt_codemp int,
	umt_httpheaders_response varchar(max) not null,
	umt_conversationmember_id varchar(200),
	umt_user_teams varchar(50) not null,
	umt_ms_teams_id varchar(40) default '' not null,
	umt_tipo varchar(12) not null default 'student'/*owner: docentes-miembros facultad, student*/,
	umt_codumt_referencia_removido int,

	umt_estado varchar(30) not null default 'agregado'/*agregado, removido, removido_manual*/,
	umt_codusr int,
	umt_fecha_creacion datetime default getdate()
)
-- select * from graph_umt_usuarios_miembros_teams
insert into graph_umt_usuarios_miembros_teams (umt_codhpl, umt_codper, umt_user_teams, umt_ms_teams_id, umt_codusr)
values (49693, 181324, '2515652015@mail.utec.edu.sv', '168154cc-d69f-4b36-85c5-18d09e0c44a9', 407)

insert into graph_umt_usuarios_miembros_teams (umt_codhpl, umt_codemp, umt_user_teams, umt_ms_teams_id, umt_tipo, umt_codusr)
values (49693, 3719, 'hernan.cabezas@mail.utec.edu.sv', '168154cc-d69f-4b36-85c5-18d09e0c44a9', 'owner', 407)
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2022-10-22 23:06:48.107>
	-- Description: <Vista que retorna los miembros x materia inscritos/eliminados en teams>
	-- =============================================
	-- select * from vst_graph_materias_miembros_msteams where codhpl = 50023 and codper = 236598
create view vst_graph_materias_miembros_msteams
as

	select 'student' 'rol', '' 'rol_teams', v.codhpl, v.codcil, v.hpl_ms_teams_id, v.displayname_teams, 
		ins_codigo codins, ins_fecha_creacion, ins_usuario_creacion, ins_estado, mai_estado, mai_codigo codmain, mai_fecha, per_codigo codper, 0 codemp,
		per_nombres 'nombres', per_apellidos 'apellidos', per_estado 'estado_persona', per_correo_institucional 'correo_institucional', 

		umt.umt_codigo, umt.umt_codper, umt.umt_user_teams, umt.umt_ms_teams_id, umt.umt_tipo, umt.umt_estado, umt.umt_codusr, umt.umt_fecha_creacion, umt.umt_conversationmember_id,
		
		t_removido.umt_codigo 'codumt_removido', t_removido.umt_codper 'codper_removido', t_removido.umt_user_teams 'user_teams_removido', 
		t_removido.umt_ms_teams_id 'id_teams_removido', 
		t_removido.umt_tipo 'tipo_usuario', t_removido.umt_estado 'estado_removido', t_removido.umt_codusr 'codusr_removio', t_removido.umt_fecha_creacion 'fecha_removido'
		, t_removido.umt_codumt_referencia_removido
	from vst_graph_materias_msteams v
		inner join ra_mai_mat_inscritas on codhpl = mai_codhpl
		inner join ra_ins_inscripcion on mai_codins = ins_codigo
		inner join ra_per_personas on per_codigo = ins_codper
		left join graph_umt_usuarios_miembros_teams umt on ins_codper = umt.umt_codper and umt.umt_codhpl = codhpl
			and umt_estado = 'Agregado'
		left join (
			select * from graph_umt_usuarios_miembros_teams r_umt where r_umt.umt_estado in ('removido', 'removido_manual')
		) t_removido on ins_codper = t_removido.umt_codper 
			and t_removido.umt_codumt_referencia_removido = umt.umt_codigo

		and t_removido.umt_codhpl = codhpl 
		--	and t_removido.umt_codumt_referencia_removido = umt.S and t_removido.umt_codigo = (
		--	select max(rumt_max.umt_codigo) from graph_umt_usuarios_miembros_teams rumt_max where rumt_max.umt_estado in ('removido', 'removido_manual')
		--	and rumt_max.umt_codper = ins_codper and rumt_max.umt_codhpl = codhpl 
		--)
	where hpl_requiere_ms_teams = 1

		union all

	select 'teacher' 'rol', 'owner' 'rol_teams', v.codhpl, v.codcil, v.hpl_ms_teams_id, v.displayname_teams, 
		0 codins, getdate() ins_fecha_creacion, '' ins_usuario_creacion, '' ins_estado, '' mai_estado, 0 codmain, getdate() mai_fecha, 0 codper, codemp,
		concat(ltrim(rtrim(emp_primer_nom)), ' ', ltrim(rtrim(emp_segundo_nom))) 'nombres', concat(ltrim(rtrim(emp_primer_ape)), ' ', ltrim(rtrim(emp_segundo_ape))) 'apellidos', emp_estado 'estado_persona', emp_email_institucional 'correo_institucional', 

		umt.umt_codigo, umt.umt_codemp, umt.umt_user_teams, umt.umt_ms_teams_id, umt.umt_tipo, umt.umt_estado, umt.umt_codusr, umt.umt_fecha_creacion, umt.umt_conversationmember_id,
		
		t_removido.umt_codigo 'codumt_removido', t_removido.umt_codemp 'codper_removido', t_removido.umt_user_teams 'user_teams_removido', 
		t_removido.umt_ms_teams_id 'id_teams_removido', 
		t_removido.umt_tipo 'tipo_usuario', t_removido.umt_estado 'estado_removido', t_removido.umt_codusr 'codusr_removio', t_removido.umt_fecha_creacion 'fecha_removido'
		, t_removido.umt_codumt_referencia_removido
	from vst_graph_materias_msteams v
		inner join pla_emp_empleado on codemp = emp_codigo
		left join graph_umt_usuarios_miembros_teams umt on codemp = umt.umt_codemp and umt.umt_codhpl = codhpl
			and umt_estado = 'Agregado'
		left join (
			select * from graph_umt_usuarios_miembros_teams r_umt where r_umt.umt_estado in ('removido', 'removido_manual')
		) t_removido on codemp = t_removido.umt_codemp and t_removido.umt_codhpl = codhpl 
			and t_removido.umt_codumt_referencia_removido = umt.umt_codigo
	where hpl_requiere_ms_teams = 1
go