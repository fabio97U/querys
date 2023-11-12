-------------QUERY 1
select * from ra_ins_inscripcion
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
where ins_codper = 178347 and mai_codpla = 215
select * from ra_not_notas where not_codmai in (
3768768, 3768770, 3768771, 3768772
)
select * from ra_ins_inscripcion
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
where ins_codper = 178347 and mai_codpla = 329
select * from ra_not_notas where not_codmai in (
5039355, 5039357, 5039358, 5039362
)

select * from ra_mat_materias where mat_codigo = 'PCIN-C'
select * from ra_plm_planes_materias WHERE plm_codpla = 221
select * from ra_plq_planes_equivalencias where plq_codpla_del = 311
select round(avg(not_nota), 2) from ra_not_notas where not_codmai = 3768771

declare @codpla int = 329, @codpla1 int = 311, @codper int = 178347
select distinct mai_codreg, mai_codins, plq_codmat_al codmat, mai_uv, @codpla1 codpla1, mai_estado, mai_matricula, 
mai_codhor, mai_codhpl, getdate() fecha, mai_tipo, mai_codigo, ins_codper, ins_codcil codcil,
case when (select round(avg(not_nota), 2) from ra_not_notas where not_codmai = m.mai_codigo) >= 5.96 then 0 else iif(m.mai_estado = 'R', 0, 1) end 'reprobada'
from ra_mai_mat_inscritas m with (nolock)
	join ra_ins_inscripcion with (nolock) on ins_codigo = mai_codins
	join ra_plq_planes_equivalencias on plq_codpla_del = mai_codpla and plq_codmat_del = mai_codmat and plq_codpla_al = @codpla1 
where ins_codper = @codper and mai_codpla = @codpla

	--union all

select distinct mai_codreg, mai_codins, mai_codmat, mai_uv, @codpla1 codpla1, mai_estado, mai_matricula, 
	mai_codhor, mai_codhpl, getdate() fecha, mai_tipo, mai_codigo, ins_codper, ins_codcil,
	case when (select round(avg(not_nota), 2) from ra_not_notas where not_codmai = m.mai_codigo) >= 5.96 then 0 else iif(m.mai_estado = 'R', 0, 1) end 'reprobada'
from ra_mai_mat_inscritas m with (nolock)
	join ra_ins_inscripcion with (nolock) on ins_codigo = mai_codins
	join ra_plm_planes_materias on plm_codpla = @codpla1
		and plm_codmat = mai_codmat 
where ins_codper = @codper and mai_codpla = @codpla

-------------QUERY 2
USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[act_car]    Script Date: 20/7/2021 19:53:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	-- act_car2 1, 178347, 329, 215, 126,'fabio.ramos'
alter proc [dbo].[act_car2] 
	@codreg int,
	@codper int,
	@codpla int,--PLAN ANTIGUO
	@codpla1 int,--PLAN NUEVO
	@codcil int,--CICLO
	@usuario varchar(20)
as
begin
    declare @corr int, @var int, @carrera int,
            @carnet varchar(12), @carrera_new int, @carrera_old int,
            @nota_minima real, @carnet_anterior varchar(12), @equ_codigo int, @corr_eq int

    select @carrera_old = right('00'+cast(car_identificador as varchar),2)
    from ra_car_carreras
        join ra_pla_planes on pla_codcar = car_codigo where pla_codigo = @codpla

    select @carrera_new = right('00'+cast(car_identificador as varchar),2)
    from ra_car_carreras
        join ra_pla_planes on pla_codcar = car_codigo where pla_codigo = @codpla1

    begin transaction

    declare @tbl_mats_equivalentes table(
		mai_codreg int, codmai int, mai_codins int, codmat varchar(10), mai_uv int, codpla1 int, mai_estado varchar(1), 
		mai_matricula int, mai_codhor int, mai_codhpl int, fecha datetime, mai_tipo varchar(1), mai_codigo int, desde varchar(25)
	)

    select @corr = isnull(max(mai_codigo),0) from ra_mai_mat_inscritas

    insert into @tbl_mats_equivalentes
    select mai_codreg, (@corr + (row_number() OVER(ORDER BY ins_codper ASC))) codmai, mai_codins, codmat, 
	mai_uv, codpla1, mai_estado, mai_matricula + reprobada, mai_codhor, mai_codhpl, fecha, mai_tipo, mai_codigo, desde
    from (
		select distinct mai_codreg, mai_codins, plq_codmat_al codmat, mai_uv, @codpla1 codpla1, mai_estado, mai_matricula, 
		mai_codhor, mai_codhpl, getdate() fecha, mai_tipo, mai_codigo, ins_codper, ins_codcil codcil,
		case when (select round(avg(not_nota), 2) from ra_not_notas where not_codmai = m.mai_codigo) >= 5.96 then 0 else iif(m.mai_estado = 'R', 0, 1) end 'reprobada',
		'ra_plq_planes_equivalencias' desde
		from ra_mai_mat_inscritas m with (nolock)
			join ra_ins_inscripcion with (nolock) on ins_codigo = mai_codins
			join ra_plq_planes_equivalencias on plq_codpla_del = mai_codpla and plq_codmat_del = mai_codmat and plq_codpla_al = @codpla1 
		where ins_codper = @codper and mai_codpla = @codpla

			union all

		select distinct mai_codreg, mai_codins, mai_codmat, mai_uv, @codpla1 codpla1, mai_estado, mai_matricula, 
			mai_codhor, mai_codhpl, getdate() fecha, mai_tipo, mai_codigo, ins_codper, ins_codcil,
			case when (select round(avg(not_nota), 2) from ra_not_notas where not_codmai = m.mai_codigo) >= 5.96 then 0 else iif(m.mai_estado = 'R', 0, 1) end 'reprobada',
			'ra_plm_planes_materias' desde
		from ra_mai_mat_inscritas m with (nolock)
			join ra_ins_inscripcion with (nolock) on ins_codigo = mai_codins
			join ra_plm_planes_materias on plm_codpla = @codpla1
				and plm_codmat = mai_codmat 
		where ins_codper = @codper and mai_codpla = @codpla
    ) t 
	where not exists (select 1
    from ra_mai_mat_inscritas with (nolock)
        join ra_ins_inscripcion with (nolock) on ins_codigo = mai_codins 
	where mai_codmat = codmat and mai_codpla = @codpla1
    and ins_codper = @codper and ins_codcil = codcil)

	select *, 'ln66' from @tbl_mats_equivalentes--BORRAR

    delete from @tbl_mats_equivalentes where codmat = ''

    declare @tbl_notas table(codmai int, not_codmai int, not_codpom int, not_nota real, not_estado varchar(1), bandera bit)

    insert into @tbl_notas
    select codmai, not_codmai, not_codpom, not_nota, not_estado, bandera 
	from @tbl_mats_equivalentes
        join ra_not_notas on not_codmai = mai_codigo 
	where ltrim(rtrim(codmat)) not in (
			select ltrim(rtrim(mai_codmat))
			from ra_ins_inscripcion with (nolock) 
				join ra_mai_mat_inscritas with (nolock) on mai_codins = ins_codigo 
				join ra_hpl_horarios_planificacion on mai_codhpl = hpl_codigo 
			where ins_codper = @codper and mai_codpla = @codpla1
		)
	select * from @tbl_notas
	--insert into ra_mai_mat_inscritas (mai_codreg, mai_codigo, mai_codins, mai_codmat, mai_uv, mai_codpla, mai_estado, mai_matricula, 
	--mai_codhor, mai_codhpl, mai_fecha, mai_tipo)--ln 84
    select mai_codreg, codmai, mai_codins, codmat, mai_uv, codpla1, mai_estado, mai_matricula, 
	mai_codhor, mai_codhpl, fecha, mai_tipo, 'ln 88'
    from @tbl_mats_equivalentes 
	where ltrim(rtrim(codmat)) not in (
		select ltrim(rtrim(mai_codmat))
		from ra_ins_inscripcion with (nolock) 
			join ra_mai_mat_inscritas with (nolock) on mai_codins = ins_codigo 
			join ra_hpl_horarios_planificacion on mai_codhpl = hpl_codigo 
		where ins_codper = @codper and mai_codpla = @codpla1
    )

    select @corr = isnull(max(not_codigo),0) from ra_not_notas

    --insert into ra_not_notas (not_codigo, not_codpom, not_codmai, not_nota, not_estado, not_fecha, bandera)--ln 98
    select (@corr + (row_number() OVER(ORDER BY not_codmai ASC))), not_codpom, codmai, not_nota, not_estado, getdate(), bandera
    from @tbl_notas

    ---verifica si es alumno de equivalencias e inserta materias otorgadas por equivalencias
    if exists(select equ_codper
        from ra_equ_equivalencia_universidad where equ_codper = @codper )
    begin
        declare @seleccion as TABLE (id_codigo int, equ_codigo int)

        insert into @seleccion
        select row_number() Over (ORDER BY equ_codigo) as id_codigo, equ_codigo
        from ra_equ_equivalencia_universidad where equ_codper = @codper

        declare @num int = 1, @total int
        select @total = count(1) from @seleccion
        while (@num <= @total )
        begin
            select @corr_eq = isnull(max(eqn_codigo),0) from ra_eqn_equivalencia_notas

            --insert into ra_eqn_equivalencia_notas (eqn_codigo, eqn_codreg, eqn_codmat, eqn_nota, eqn_codequ)--ln 116
            select (@corr_eq + (row_number() OVER(ORDER BY equ_codper ASC))) eqn_codigo, 1 eqn_codreg, plq_codmat_al as eqn_codmat, eqn_nota, (select equ_codigo
                from @seleccion where id_codigo = @num) eqn_codequ
            from ra_plq_planes_equivalencias
                join ra_eqn_equivalencia_notas on eqn_codmat = plq_codmat_del
                join ra_equ_equivalencia_universidad on equ_codigo = eqn_codequ 
			where equ_codigo in (select equ_codigo from @seleccion where id_codigo = @num)
            and plq_codpla_del = @codpla and plq_codpla_al = @codpla1

            --update ra_equ_equivalencia_universidad set equ_codpla = @codpla1 
			--where equ_codigo in (select equ_codigo from @seleccion where id_codigo = @num)--ln 126
            set @num = @num + 1
        end

    end
	
    select @carrera = car_identificador
    from ra_car_carreras
        join ra_pla_planes on pla_codcar = car_codigo where pla_codigo = @codpla1

    select @carnet = right('00'+cast(@carrera as varchar),2) + substring(per_carnet,3,len(per_carnet)), @carnet_anterior = per_carnet
    from ra_per_personas where per_codigo = @codper

    --update ra_alc_alumnos_carrera set alc_codpla = @codpla1 where alc_codper = @codper--ln 139

	--update ra_per_personas set per_carnet = @carnet, per_correo_institucional = replace(@carnet,'-','')+'@mail.utec.edu.sv' 
	--where per_codigo = @codper and per_tipo in ('U', 'M')--ln 142

    if exists(select 1
        from ra_per_personas
            inner join ra_car_carreras on car_identificador = SUBSTRING(per_carnet, 1, 2) where per_tipo = 'U'
        and per_codigo = @codper)
    begin
        print 'Alumno de pregrado'

        if exists(select 1
            from ra_per_personas
                inner join ra_car_carreras on car_identificador = SUBSTRING(per_carnet, 1, 2) where per_tipo = 'U'
            and per_codigo = @codper
            and car_nombre like '%NO PRESENCIAL%')
        begin
            print 'Alumno virtual'
            --update ra_per_personas set per_codvac = 2 where per_codigo = @codper and per_tipo = 'U'--ln 158
        END 
		ELSE 
		BEGIN
            print 'Alumno Presencial'
            --update ra_per_personas set per_codvac = 1 where per_codigo = @codper and per_tipo = 'U'--ln 163
        END
    END 
	else 
	begin
        print 'no es alumno de pregrado'
    end

    --insert into ra_hac_his_alm_car (hac_codigo, hac_codper, hac_codpla, hac_fecha_creacion, hac_usuario, hac_carnet, hac_ingreso, hac_codcil)--ln 171
    select isnull(max(hac_codigo), 0) + 1, @codper, @codpla, getdate(), @usuario, @carnet_anterior, 'N', @codcil from ra_hac_his_alm_car

    declare @registro varchar(500), @fecha_reg datetime = getdate()

    select @registro = 'Cambio de carrera ' + cast(@codper as varchar) + cast(@carnet as varchar)

    --exec auditoria_del_sistema 'ra_per_personas', 'A', @usuario, @fecha_reg, @registro --ln 178
   
    if (@carrera_old <> @carrera_new)
    begin
        --insert into ra_cpa_pla_absorcion (cpa_codigo, cpa_codper, cpa_codpla_old, cpa_codpla_new, cpa_fecha, cpa_usuario, cpa_tipo, cpa_codcil, cpa_carnet)--ln 182
        select isnull(max(cpa_codigo),0)+1, @codper, @codpla, @codpla1, getdate(), @usuario, 'C', @codcil, @carnet_anterior
        from ra_cpa_pla_absorcion
    end else begin
        --insert into ra_cpa_pla_absorcion (cpa_codigo, cpa_codper, cpa_codpla_old, cpa_codpla_new, cpa_fecha, cpa_usuario, cpa_tipo, cpa_codcil, cpa_carnet)--ln 186
        select isnull(max(cpa_codigo),0)+1, @codper, @codpla, @codpla1, getdate(), @usuario, 'A', @codcil, @carnet_anterior
        from ra_cpa_pla_absorcion
    end

    commit transaction
end

-------------QUERY 3
select * from adm_usr_usuarios where usr_codigo in ('302', '302', '109', '14')
select * from ra_cpa_pla_absorcion where cpa_codper = 178347
select * from ra_pla_planes where pla_codigo in (215, 215, 221, 311, 329)
select * from ra_hac_his_alm_car where hac_codper = 178347
select * from ra_ins_inscripcion
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
where ins_codper = 178347
order by mai_codpla, mai_codigo
select *--row_number() Over (ORDER BY equ_codigo) as id_codigo, equ_codigo
from ra_equ_equivalencia_universidad where equ_codper = 178347
select * from ra_eqn_equivalencia_notas where eqn_codequ = 9371
select * from ra_plq_planes_equivalencias where plq_codpla_del = 329
select row_number() Over (ORDER BY equ_codigo) as id_codigo, equ_codigo
from ra_equ_equivalencia_universidad where equ_codper = 178347

-------------QUERY 4