SELEct * from ra_plm_planes_materias
select * from ra_req_requisitos

select * from (
select dbo.paso_requisito(mai_codpla, 121,ins_codper) 'Paso prerrequisitos', per_codigo, per_carnet, per_apellidos_nombres, mai_codmat 'codmat', mat_nombre 'Materia inscrita', mai_codpla, pla_nombre, pla_alias_carrera 'Carrera'
from ra_ins_inscripcion 
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
inner join ra_per_personas on per_codigo = ins_codper
inner join ra_pla_planes on pla_codigo = mai_codpla
inner join ra_mat_materias on mat_codigo = mai_codmat

where ins_codcil = 121 and ins_estado <> 'R'
) as tabla 
where tabla.[Paso prerrequisitos] = 0

--select * from ra_pla_planes where pla_alias_carrera like '%arqui%'

--select dbo.paso_requisito(382, 121,216184)

alter function dbo.paso_requisito (
	@codpla int,
	@codcil int,
	@codper int
)
returns int
as
begin
	/*declare @codpla int = 382,
	@codcil int = 121,
	@codper int = 216184*/

	declare @requisitos_pasados int =0 
	declare @requisitos int

	declare @carnet varchar(25)
	select @carnet = per_carnet from ra_per_personas where per_codigo = @codper
	declare @paso_requisito int
	declare @pensum as table (mai_codmat varchar(105) null, nf real null)
	insert into @pensum (mai_codmat, nf) 
	--exec web_ptl_pensum @codper
	 select mai_codmat, nota from notas inner join ra_pla_planes on pla_codigo = mai_codpla
								   inner join ra_car_carreras on car_codigo = pla_codcar 
								   where ins_codper = @codper and nota >= 5.96 and car_identificador = SUBSTRING(@carnet,1,2) 
								   and pla_codigo = (select alc_codpla from ra_alc_alumnos_carrera where alc_codper = @codper)	   
					union
	select distinct eqn_codmat, eqn_nota
			from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,
			ra_alc_alumnos_carrera, ra_plm_planes_materias
			where equ_codigo = eqn_codequ
			and equ_codper = @codper
			and eqn_nota > 0
			and alc_codper = equ_codper
			and plm_codpla = alc_codpla
			and plm_codmat = eqn_codmat

	declare @tabla_requisitos as table (req_codmat_req varchar(105) null)
	insert into @tabla_requisitos (req_codmat_req) 
	select req_codmat_req from ra_ins_inscripcion 
	inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
	inner join ra_req_requisitos on req_codmat = mai_codmat
	where ins_codcil = @codcil and ins_codper = @codper and req_codpla = @codpla

	declare @table_materia_inscrita as table (req_codmat_req varchar(105) null)
	insert into @table_materia_inscrita (req_codmat_req)
	select mai_codmat from ra_ins_inscripcion 
	inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
	where ins_codcil = @codcil and ins_codper = @codper

	--select * from @pensum 
	--select * from @tabla_requisitos
	--select * from @table_materia_inscrita

	--select * from @pensum where mai_codmat in( 'CEDC-I', 'HISI-I')
	select @requisitos_pasados = isnull(count(1),0) from @pensum where mai_codmat in (select req_codmat_req from @tabla_requisitos) and nf > 5.96

	select @requisitos = isnull(count(1),0) from @tabla_requisitos

	if @requisitos_pasados >= @requisitos
	set @paso_requisito = 1 --'Paso requisitos'
	else 
	set  @paso_requisito = 0--'No paso requisitos'

	return @paso_requisito
end