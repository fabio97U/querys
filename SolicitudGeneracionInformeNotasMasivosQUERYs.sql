use [uonline]
go
/****** object:  storedprocedure [dbo].[rep_constancia_notas_carrera]    script date: 14/11/2019 16:51:14 ******/
set ansi_nulls on
go
set quoted_identifier on
go

alter procedure [dbo].[rep_constancia_notas_carrera] 
	-- =============================================
	-- Author:      <DESCONOCIDO>
	-- Create date: <DESCONOCIDO>
	-- Last Modify: 2019-11-14 16:59:26.750 por Fabio
	-- Description: <>
	-- =============================================
	-- rep_constancia_notas_carrera 1, 117, 25
	@campo0 int, --codreg
	@campo1 int, --codcil
	@campo2 int --codcar
as
begin
	declare @nota_minima real/*, @uv real, @aprobadas int, @reprobadas real, @retiradas real, @codper int,
	@cum real, @cum_ciclo real, @carnet varchar(12)*/

	declare @boletas as table (
		cil_codcic int, cil_codigo int,
		uni_nombre varchar(100), codper int, 
		per_carnet varchar(12), per_nombres_apellidos varchar(150), 
		car_nombre varchar(100), pla_alias_carrera varchar(100), 
		reg_nombre varchar(100), mat_codigo varchar(10), 
		mat_nombre varchar(100), cic_nombre varchar(100), 
		cil_anio int, mai_estado varchar(20), 
		plm_uv int, nota real, 
		cum_ciclo real, cum real,
		nota_letras varchar(100), ciclo varchar(20),
		tot_uv real, estado varchar(20),
		aprobadas real, reprobadas real,
		retiradas real
	)

	--declare @boletas_final as table (
	--	correlativo int, cil_codcic int,
	--	cil_codigo int, uni_nombre varchar(100), 
	--	codper int,  per_carnet varchar(12), 
	--	per_nombres_apellidos varchar(150), car_nombre varchar(100),
	--	pla_alias_carrera varchar(100), reg_nombre varchar(100), 
	--	mat_codigo varchar(10), mat_nombre varchar(100), 
	--	cic_nombre varchar(100), cil_anio int, 
	--	mai_estado varchar(20), plm_uv int,
	--	nota real, cum_ciclo real, 
	--	cum real, nota_letras varchar(100),
	--	ciclo varchar(20), tot_uv real,
	--	estado varchar(20), aprobadas real,
	--	reprobadas real, retiradas real
	--)
	select @nota_minima = uni_nota_minima from ra_reg_regionales, ra_uni_universidad where reg_codigo = @campo0 and uni_codigo = reg_coduni

	declare @notas as table (carnet varchar(25),codper int, anio_ingreso int, correlativo_alumno int, ins_codcil int, mai_codmat varchar(35), nota float, nota_round float,estado varchar(5), uv int, tot_nota_por_uv float,aprobada smallint, retirada smallint, aprobadas smallint, reprobadas smallint, retiradas smallint, tot_uv smallint, total_inscritas smallint)
	
	insert into @notas (carnet, codper, anio_ingreso, correlativo_alumno, ins_codcil, mai_codmat, nota, nota_round, estado, uv, tot_nota_por_uv, aprobada, retirada, aprobadas, reprobadas, retiradas, tot_uv, total_inscritas)
	select  per.per_carnet,per.per_codigo, tab.anio_ingreso, tab.correlativo_alumno, @campo1 ins_codcil/*, ins_codper,*/, mai_codmat, nota, isnull(round(nota,1), 0) nota_round , estado, uv, nota_por_uv,
	case  when nota >= @nota_minima then 1 else 0 end 'aprobada', case when estado = 'R' then 1 else 0 end 'retirada', tab.aprobadas, tab.reprobadas, tab.retiradas, tab.tot_uv, tab.total_inscritas
	from notas
	join ra_per_personas as per on per_codigo = ins_codper
	--join ra_alc_alumnos_carrera on alc_codper = per_codigo
	--join ra_pla_planes on pla_codigo = alc_codpla
	inner join (
		select per_codigo, correlativo_alumno, anio_ingreso, sum(aprobado) 'aprobadas', sum (reprobada) 'reprobadas', sum(retirada) 'retiradas', sum(uv) 'tot_uv', sum(nota_por_uv) 'nota_por_uv',count(1) 'total_inscritas' 
		from (
			select distinct per_carnet,per_codigo, cast(substring(per_carnet, 4, 4) as int) 'correlativo_alumno', cast(substring(per_carnet, 9, 4) as int) /*isnull(per_anio_ingreso, 0)*/ 'anio_ingreso', 
			case  when nota >= @nota_minima then 1 else 0 end 'aprobado', case  when nota < @nota_minima then 1 else 0 end 'reprobada', case when estado = 'R' then 1 else 0 end 'retirada', uv, (nota*uv) 'nota_por_uv', mai_codmat
			from notas
			join ra_per_personas as per on per_codigo = ins_codper
			join ra_alc_alumnos_carrera on alc_codper = per_codigo
			join ra_pla_planes on pla_codigo = alc_codpla
			where ins_codcil = @campo1 and per_tipo = 'U' 
			and ins_codper not in(193078)
			--and pla_codcar = 25
		) as t
		group by per_carnet,per_codigo, correlativo_alumno, anio_ingreso--, aprobado, reprobada, retirada
	) as tab on tab.per_codigo = per.per_codigo
	where ins_codcil = @campo1 and per_tipo = 'U' /*and ins_codper = 181324 and*/-- and pla_codcar = 25
		
	--select * from @notas as n 
	--order by n.anio_ingreso, n.correlativo_alumno

	/*declare @personas as table(per_codigo int, per_carnet varchar(16))

	insert into @personas (per_codigo, per_carnet)
	select per_codigo, per_carnet
	from ra_per_personas
		join ra_alc_alumnos_carrera on alc_codper = per_codigo
		join ra_pla_planes on pla_codigo = alc_codpla
	where/* pla_codcar = @campo2 and */exists (select 1 from @notas where ins_codper = per_codigo)*/

	--set @uv = 0
	--set @aprobadas = 0
	--set @reprobadas = 0
	--set @retiradas = 0
	--set @cum = 0
	--set @cum_ciclo = 0

	--insert into @boletas(cil_codcic,cil_codigo,uni_nombre,codper,per_carnet, per_nombres_apellidos,car_nombre,pla_alias_carrera,reg_nombre,mat_codigo,mat_nombre, cic_nombre,cil_anio,mai_estado,plm_uv,nota,cum_ciclo,cum,nota_letras, ciclo,tot_uv,estado,aprobadas,reprobadas,retiradas)
	select anio_ingreso, correlativo_alumno, correlativo, cil_codcic,cil_codigo,uni_nombre, codper, per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera, reg_nombre, mat_codigo, mat_nombre, cic_nombre, cil_anio, mai_estado, plm_uv, nota, cum_ciclo, cum, nota_letras,ciclo,tot_uv,estado,aprobadas,reprobadas,retiradas from (
		select row_number() over (partition by per_carnet order by per_carnet) 'correlativo', cil_codcic,cil_codigo,uni_nombre, codper, per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera, reg_nombre, mat_codigo, mat_nombre, cic_nombre, cil_anio, mai_estado, plm_uv, nota, cum_ciclo, cum, nota_letras,ciclo,tot_uv,estado,aprobadas,reprobadas,retiradas, anio_ingreso, correlativo_alumno
		from
		(
			select --/*row_number() over (order by codper) row*/ row_,
				cil_codcic,cil_codigo,uni_nombre, codper, per_carnet, per_nombres_apellidos, 
				car_nombre,pla_alias_carrera, reg_nombre, mat_codigo, mat_nombre, cic_nombre, cil_anio, mai_estado, plm_uv,
				nota, 
				cum_ciclo, cum,
				nota_letras,
				ciclo,tot_uv,estado,aprobadas,reprobadas,retiradas, anio_ingreso, correlativo_alumno
			from
			(
				select cil_codcic,cil_codigo,uni_nombre, codper, per_carnet, per_nombres_apellidos, 
					car_nombre,pla_alias_carrera, reg_nombre, mat_codigo, mat_nombre, cic_nombre, cil_anio, mai_estado, plm_uv,
					nota_round nota, 0 cum,
					(/*(select sum(isnull(round(nota,1)*uv,0)) from @notas where ins_codper = codper and ins_codcil = @campo1)*/tot_nota_por_uv/
					/*(select sum(isnull(uv,0)) from @notas  where ins_codper = codper and ins_codcil = @campo1)*/ tot_uv) cum_ciclo,
					upper(dbo.NotaALetras(nota_round)) nota_letras,  concat('0',cil_codcic, '-', cil_anio) ciclo,
					/*(select sum(isnull(uv,0)) from @notas where ins_codper = codper and ins_codcil = @campo1)*/ tot_uv,
					estado,
					/*(select count(mai_codmat) from @notas where ins_codper = codper and ins_codcil = @campo1 and isnull(nota,0) >= @nota_minima and estado = 'I')*/ aprobadas,
					/*(select count(mai_codmat) from @notas where ins_codper = codper and ins_codcil = @campo1 and isnull(nota,0) < @nota_minima and estado = 'I')*/ reprobadas,
					/*(select count(mai_codmat) from @notas where ins_codper = codper and ins_codcil = @campo1 and estado = 'R')*/ retiradas, anio_ingreso, correlativo_alumno
				from
				(
					select cil_codcic,cil_codigo,uni_nombre,a.codper ins_codper, a.codper, per_carnet, 
						per_apellidos_nombres per_nombres_apellidos, 
						car_nombre,pla_alias_carrera, reg_nombre, mat_codigo, isnull(plm_alias, mat_nombre) mat_nombre, 
						cic_nombre, cil_anio, a.estado mai_estado, plm_uv
						,nota_round,
						case when a.retirada = 1 then 'RETIRADA' when a.aprobada = 1 then 'APROBADA' else 'REPROBADA' end estado, a.aprobadas, a.reprobadas, a.retiradas, tot_nota_por_uv, tot_uv, anio_ingreso, correlativo_alumno,
						reg_coduni
					from @notas a
						left join ra_per_personas on per_codigo = a.codper
						left join ra_mat_materias on mat_codigo = a.mai_codmat
						left join ra_cil_ciclo on cil_codigo = a.ins_codcil
						left join ra_cic_ciclos on cic_codigo = cil_codcic
						left join ra_alc_alumnos_carrera on alc_codper = per_codigo
						left join ra_pla_planes on pla_codigo = alc_codpla
						left join ra_car_carreras on car_codigo = pla_codcar
						left join ra_plm_planes_materias on plm_codpla = pla_codigo and plm_codmat = a.mai_codmat
						left join ra_reg_regionales on reg_codigo = per_codreg
						left join ra_uni_universidad on uni_codigo = reg_coduni
					--where per_codigo = @codper
				) t
				----union all
				--select '' cil_codcic,@campo1 cil_codigo,'' uni_nombre, per_codigo codper, per_carnet, '' per_nombres_apellidos, 
				--'' car_nombre,'' pla_alias_carrera, '' reg_nombre, '' mat_codigo, '' mat_nombre, '' cic_nombre, '' cil_anio, '' mai_estado, '' plm_uv,
				--'' nota, 
				--(select sum(isnull(round(nota,1)*uv,0)) from @notas where ins_codper = per_codigo and ins_codcil = @campo1)/
				--(select sum(isnull(uv,0)) from @notas where ins_codper = per_codigo and ins_codcil = @campo1)  cum_ciclo, 
				--0 cum,
				--'' nota_letras,'' ciclo,
				--(select sum(isnull(uv,0)) from @notas where ins_codper = per_codigo and ins_codcil = @campo1) tot_uv,
				--'' estado,
				--(select count(mai_codmat) from @notas where ins_codper = per_codigo and ins_codcil = @campo1 and isnull(nota,0) >= @nota_minima and estado = 'I') aprobadas,
				--(select count(mai_codmat) from @notas where ins_codper = per_codigo and ins_codcil = @campo1 and isnull(nota,0) < @nota_minima and estado = 'I') reprobadas,
				--(select count(mai_codmat) from @notas where ins_codper = per_codigo and ins_codcil = @campo1 and estado = 'R') retiradas
				--from syscolumns, @personas
				--where id = object_id('ra_per_personas')
				--and (colorder - 1) <= 5
			) r
			--and mai_estado = 'I'
		) z
	) as tab where tab.correlativo <= 6
	order by anio_ingreso asc, correlativo_alumno asc

	--declare 
	--@c_cil_codcic int,@c_cil_codigo int,
	--@c_uni_nombre varchar(100), @c_codper int, 
	--@c_per_carnet varchar(12), @c_per_nombres_apellidos varchar(150), 
	--@c_car_nombre varchar(100),@c_pla_alias_carrera varchar(100), 
	--@c_reg_nombre varchar(100), @c_mat_codigo varchar(10), 
	--@c_mat_nombre varchar(100), @c_cic_nombre varchar(100), 
	--@c_cil_anio int, @c_mai_estado varchar(20), 
	--@c_plm_uv int, @c_nota real, 
	--@c_cum_ciclo real, @c_cum real, 
	--@c_nota_letras varchar(100), @c_ciclo varchar(20),
	--@c_tot_uv real, @c_estado varchar(20),
	--@c_aprobadas real, @c_reprobadas real,
	--@c_retiradas real, @correlativo int, 
	--@c_codper_ant int

	--declare c_act cursor for

	--select * from @boletas
	--order by per_carnet, cil_anio desc

	--select @correlativo = 0
	--set @c_codper_ant = 0

	--open c_act

	--fetch next from c_act
	--into @c_cil_codcic,@c_cil_codigo,@c_uni_nombre, @c_codper, @c_per_carnet,  @c_per_nombres_apellidos, @c_car_nombre,@c_pla_alias_carrera, @c_reg_nombre, @c_mat_codigo, @c_mat_nombre, @c_cic_nombre, @c_cil_anio,  @c_mai_estado, @c_plm_uv,@c_nota, @c_cum_ciclo, @c_cum,@c_nota_letras, @c_ciclo,@c_tot_uv,@c_estado,@c_aprobadas,@c_reprobadas,@c_retiradas

	--while @@FETCH_STATUS = 0	
	--begin
	--	if @c_codper <> @c_codper_ant 
	--		set @correlativo = 1
	--	else 
	--		set @correlativo = @correlativo + 1

	--	insert into @boletas_final
	--	select @correlativo,@c_cil_codcic,@c_cil_codigo,@c_uni_nombre, @c_codper, @c_per_carnet, @c_per_nombres_apellidos, @c_car_nombre,@c_pla_alias_carrera, @c_reg_nombre, @c_mat_codigo, @c_mat_nombre, @c_cic_nombre, @c_cil_anio, @c_mai_estado, @c_plm_uv,@c_nota, @c_cum_ciclo, @c_cum,@c_nota_letras, @c_ciclo,@c_tot_uv,@c_estado,@c_aprobadas,@c_reprobadas,@c_retiradas

	--	set @c_codper_ant = @c_codper

	--	fetch next from c_act
	--	into @c_cil_codcic,@c_cil_codigo,@c_uni_nombre, @c_codper, @c_per_carnet,  @c_per_nombres_apellidos, @c_car_nombre,@c_pla_alias_carrera, @c_reg_nombre, @c_mat_codigo, @c_mat_nombre, @c_cic_nombre, @c_cil_anio, @c_mai_estado, @c_plm_uv,@c_nota, @c_cum_ciclo, @c_cum,@c_nota_letras, @c_ciclo,@c_tot_uv,@c_estado,@c_aprobadas,@c_reprobadas,@c_retiradas
	--end
	--close c_act
	--deallocate c_act

	--select * from @boletas_final where correlativo <= 6
	--order by per_carnet, cil_anio desc
	--select * from @boletas order by per_carnet, cil_anio

	--select * from (
	--select row_number() over (partition by per_carnet order by per_carnet) 'correlativo', * from @boletas 
	
	--) as t where t.correlativo <= 6
	--order by per_carnet, cil_anio desc

	--select * from @boletas_final where correlativo <= 6
	--order by per_carnet, cil_anio desc
	--drop table #boletas
	--drop table #boletas_final
	--drop table #notas
	--drop table #personas
end