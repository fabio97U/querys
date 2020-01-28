ALTER procedure [dbo].[web_ptl_pensum_]
	-- =============================================
	-- Author:      <Erik>
	-- Create date: <2019-12-10 10:23:25.187>
	-- Description: <Devuelve el pensum del alumno> 
	-- =============================================
	@cuenta_codigo int
as
begin
		declare @bloque int
	select @bloque = plm_bloque_electiva
	from ra_ins_inscripcion 
		inner join ra_mai_mat_inscritas on mai_codins = ins_codigo 
		inner join ra_alc_alumnos_carrera on alc_codper = ins_codper
		inner join ra_plm_planes_materias on plm_codmat = mai_codmat and plm_codpla = alc_codpla
	where ins_codper = @cuenta_codigo and plm_electiva = 'S'
	order by ins_codcil
	--declare @cuenta_codigo int = 187470 -- 221155 --180168
	select mai_codmat, matnom, ciclo, max(round(nf,1)) nf from
	(
		select distinct mat_codigo mai_codmat, mat_nombre matnom, plm_ciclo ciclo, case when isnull(max(nota),0) <=5.95 then 0 else isnull(max(nota),0) end nf
			--per_codigo, per_carnet, per_nombres_apellidos, pla_codigo, pla_nombre, pla_codcar, pla_alias_carrera, plm_codmat, mat_nombre, plm_ciclo, plm_uv, nota, mai_matricula, plm_bloque_electiva
		from ra_per_personas 
			inner join ra_alc_alumnos_carrera on  alc_codper = per_codigo
			inner join ra_pla_planes on pla_codigo = alc_codpla
			inner join ra_plm_planes_materias on plm_codpla = pla_codigo
			inner join ra_mat_materias on mat_codigo = plm_codmat
			left outer join notas on ins_codper = per_codigo and mai_codmat = plm_codmat
		where per_codigo = @cuenta_codigo and mat_tipo = 'N' and plm_electiva = 'N' --and nota > 5.96
		group by mat_codigo, mat_nombre, plm_ciclo
		union all
		select distinct mat_codigo mai_codmat, mat_nombre matnom, plm_ciclo ciclo, case when isnull(max(nota),0) <=5.95 then 0 else isnull(max(nota),0) end nf
			--per_codigo, per_carnet, per_nombres_apellidos, pla_codigo, pla_nombre, pla_codcar, pla_alias_carrera, plm_codmat, mat_nombre, plm_ciclo, plm_uv, nota, mai_matricula, plm_bloque_electiva
		from ra_per_personas 
			inner join ra_alc_alumnos_carrera on  alc_codper = per_codigo
			inner join ra_pla_planes on pla_codigo = alc_codpla
			inner join ra_plm_planes_materias on plm_codpla = pla_codigo
			inner join ra_mat_materias on mat_codigo = plm_codmat
			left outer join notas on ins_codper = per_codigo and mai_codmat = plm_codmat
		where per_codigo = @cuenta_codigo  and plm_electiva = 'S' and plm_bloque_electiva = case when isnull(@bloque,0) = 0 then 1 else @bloque end --and nota > 5.96
		group by mat_codigo, mat_nombre, plm_ciclo

		union all
		select distinct mat_codigo mai_codmat, mat_nombre matnom, plm_ciclo ciclo, case when isnull(max(eqn_nota),0) <=5.95 then 0 else isnull(max(eqn_nota),0) end nf
			--per_codigo, per_carnet, per_nombres_apellidos, pla_codigo, pla_nombre, pla_codcar, pla_alias_carrera, plm_codmat, mat_nombre, plm_ciclo, plm_uv, nota, mai_matricula, plm_bloque_electiva
		from ra_per_personas 
			inner join ra_alc_alumnos_carrera on  alc_codper = per_codigo
			inner join ra_pla_planes on pla_codigo = alc_codpla
			inner join ra_plm_planes_materias on plm_codpla = pla_codigo
			inner join ra_mat_materias on mat_codigo = plm_codmat
			inner join ra_equ_equivalencia_universidad on equ_codper = per_codigo and equ_codpla = plm_codpla
			inner join ra_eqn_equivalencia_notas on eqn_codequ = equ_codigo and eqn_codmat = plm_codmat
		where per_codigo = @cuenta_codigo and mat_tipo = 'N' and plm_electiva = 'N' --and nota > 5.96
		group by mat_codigo, mat_nombre, plm_ciclo
	)t
	group by mai_codmat, matnom, ciclo
	order by ciclo asc
end
go

create procedure sp_detalle_pesum_requisitos
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-12-10 10:34:06.737>
	-- Description: <Devuelve el pesum con las materias aprobadas o reprobadas del alumno>
	-- =============================================
	-- sp_detalle_pesum_requisitos 221799
	-- sp_detalle_pesum_requisitos 181324--25-4018-2018
	@codper int
	--,@codpla int
as
begin
	declare @codpla int
	select @codpla = pla_codigo 
	from ra_per_personas
	inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
	inner join ra_pla_Planes on  pla_codigo = alc_codpla
	inner join ra_car_carreras on car_codigo = pla_codcar
	where per_codigo = @codper
	--select per_carnet,per_codigo,pla_codigo,per_nombres_apellidos,car_nombre,pla_nombre from ra_per_personas, ra_alc_alumnos_carrera,ra_pla_Planes, ra_car_carreras where alc_codper = per_codigo and pla_codigo = alc_codpla and car_codigo = pla_codcar and per_codigo = @codper
	declare @pensum_resultado_final as table (n int, mai_codmat varchar(55), matnom varchar(100), ciclo int, nf real, estado varchar(5), requisitos varchar(10), uv int, orden_ciclo int, requisitos_class varchar(125))
	declare @pensum as table (mai_codmat varchar(25), matnom varchar(125), ciclo int, nf real)

	insert into @pensum (mai_codmat, matnom, ciclo, nf)
	exec web_ptl_pensum @codper


	insert into @pensum_resultado_final(n, mai_codmat, matnom, ciclo, nf, estado, requisitos, uv, orden_ciclo, requisitos_class)
	select n, mai_codmat, matnom, ciclo, nf, estado, requisitos, uv, orden_ciclo, requisitos_class
	from (
		select n, rtrim(ltrim(mai_codmat)) mai_codmat, 
		case when nf > 0 then concat(rtrim(ltrim(matnom)), ' (',nf,')') else matnom end matnom, 
		ciclo, nf, estado, ltrim(rtrim(requisitos)) requisitos, uv, row_number() over (partition by ciclo order by n) 'orden_ciclo', requisitos_class
		from (
			select 
			(select plm_num_mat from ra_plm_planes_materias where plm_codmat = p.mai_codmat and plm_codpla = @codpla) 'n'
			, 
			mai_codmat, matnom, ciclo, nf,
			case when nf > 5.96 then 'APR' else 'REP' end 'estado', 
			isnull(
				stuff(
					(
						select concat(',', plm_num_mat, ''/*, rtrim(ltrim(req_codmat_req))*/)
						from ra_req_requisitos 
						inner join ra_plm_planes_materias on req_codmat_req = plm_codmat 
						where req_codmat = p.mai_codmat and req_codpla = @codpla and plm_codpla = @codpla for xml path('')
					),1,1,''
				), 'Br.'
			) 'requisitos',
			isnull(
				stuff(
					(
						select concat(' materia_padre_', plm_num_mat, ''/*, rtrim(ltrim(req_codmat_req))*/)
						from ra_req_requisitos 
						inner join ra_plm_planes_materias on req_codmat_req = plm_codmat 
						where req_codmat = p.mai_codmat and req_codpla = @codpla and plm_codpla = @codpla for xml path('')
					),1,1,''
				), 'Br.'
			) 'requisitos_class',
			(select plm_uv from ra_plm_planes_materias where plm_codmat = p.mai_codmat and plm_codpla = @codpla) 'uv'
			from @pensum as p
		) tabl
	) t
	order by ciclo, n, orden_ciclo

	select n, mai_codmat, matnom, ciclo, nf, estado, requisitos, uv, orden_ciclo, requisitos_class
	from @pensum_resultado_final

	select max(ciclo) 'ciclos' from @pensum_resultado_final
end
--select * from ra_car_carreras
--select top 100 * from ra_per_personas where SUBSTRING(per_carnet, 1, 2) = '22' and per_estado = 'A' order by per_codigo desc
-- select * from ra_req_requisitos where req_codmat in ('MAT2-T') and req_codpla = 217
/*
select * from ra_req_requisitos where req_codmat in (select mai_codmat from @pensum) and req_codpla = 217
select * from ra_mat_materias where mat_codigo in ('ETPS1-T', 'ETPS2-T', 'ETPS3-T', 'ETPS4-T', 'E1', 'E2', 'BAS1-I')
select * from ra_plm_planes_materias where /*plm_codmat in ('ETPS1-T', 'ETPS2-T', 'ETPS3-T', 'ETPS4-T', 'E1', 'E2', 'BAS1-I') and*/ plm_codpla = 217 order by plm_num_mat
*/