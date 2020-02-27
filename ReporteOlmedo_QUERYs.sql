declare @mat_no_ofertadas table (
	plm_codmat varchar(125), mat_nombre varchar(125), req_codmat varchar(125), 
	plm_ciclo int, plm_anio_carrera int, pla_nombre varchar(125), 
	pla_alias_carrera varchar(125), pla_ciclo_desde varchar(125), pla_ciclo_hasta varchar(125),
	pla_codigo int, esc_nombre varchar(255)
)

insert into @mat_no_ofertadas (plm_codmat, mat_nombre, req_codmat, plm_ciclo, plm_anio_carrera, pla_nombre, pla_alias_carrera, pla_ciclo_desde, pla_ciclo_hasta, pla_codigo, esc_nombre)
select distinct plm_codmat, mat_nombre, req_codmat, plm_ciclo, plm_anio_carrera, pla_nombre, pla_alias_carrera, pla_ciclo_desde, pla_ciclo_hasta, pla_codigo, esc_nombre
from ra_plm_planes_materias as plm
inner join ra_pla_planes as pla on pla_codigo = plm_codpla
left join ra_req_requisitos as req on req.req_codmat_req = plm.plm_codmat
left join ra_mat_materias on mat_codigo = plm_codmat
left join ra_esc_escuelas on esc_codigo = mat_codesc
where pla_estado = 'A' and pla_tipo = 'U'
and plm_codmat not in (
	select hpl_codmat from ra_hpl_horarios_planificacion
)
and pla_anio > 2015 and not pla_alias_carrera like '%maestr%'

declare @plm_codmat varchar(50),  @req_codmat varchar(50), @cantidad_requisitos int
declare @tbl_estatus_mat as table (mat_posible_oferta varchar(50), req_necesario tinyint, req_ofertados tinyint, requisitos varchar(1024))
declare m_cursor cursor 
for

select distinct plm_codmat from @mat_no_ofertadas where req_codmat != ''
open m_cursor 
 
fetch next from m_cursor into @plm_codmat
while @@FETCH_STATUS = 0 
begin
	--select *
	--plm_codmat 'materia', req_codmat 'requisitos' 
	--from @mat_no_ofertadas where req_codmat != '' and plm_codmat = @plm_codmat
	insert into @tbl_estatus_mat (mat_posible_oferta, req_necesario, req_ofertados, requisitos)
	select @plm_codmat 'mat_posible_oferta', 
	(select count(1) from ra_req_requisitos where req_codmat_req = mno.plm_codmat and req_codpla = mno.pla_codigo) 'req_necesario', 
	(
		select count(distinct hpl_codmat) 'req_ofertados' from ra_hpl_horarios_planificacion where hpl_codmat in (
			select req_codmat from @mat_no_ofertadas where req_codmat != '' and plm_codmat = @plm_codmat
		)
	) 'req_ofertados',
	isnull(
		stuff(
			(
			select distinct concat(',', 
			case isnull(hpl_codmat, '') when '' then 'No ofertada: ' else '' end, rtrim(ltrim(mat.req_codmat)), ' ',rtrim(ltrim(rmat.mat_nombre))) 
			from @mat_no_ofertadas as mat
			inner join ra_mat_materias as rmat on rmat.mat_codigo = mat.req_codmat
			left join ra_hpl_horarios_planificacion on hpl_codmat = mat.req_codmat
			where req_codmat != '' and plm_codmat = @plm_codmat for xml path('')
			),1,1,''
		), 'N/A'
	) 'requisitos'
	from @mat_no_ofertadas as mno
	where req_codmat != '' and plm_codmat = @plm_codmat

    fetch next from m_cursor into @plm_codmat
end      
close m_cursor  
deallocate m_cursor

select pla_codigo, pla_nombre, pla_alias_carrera, pla_ciclo_desde, pla_ciclo_hasta, plm_codmat 'CodMat. Nunca ofertada', mat_nombre 'Mat. Nunca ofertada', plm_ciclo, plm_anio_carrera, esc_nombre,
'Nunca ofertada y no tiene requisito' 'Estado',
'' as 'CodMat. Posible Oferta', '' as 'Cant. Req. Necesarios', '' as 'Cant. Req. Ofertados', '' as 'Detalle Requisitos'
from @mat_no_ofertadas where isnull(req_codmat, '')  = ''
union
select distinct --mat_posible_oferta, req_necesario, req_ofertados, requisitos,
pla_codigo, pla_nombre, pla_alias_carrera, pla_ciclo_desde, pla_ciclo_hasta, plm_codmat 'CodMat. Nunca ofertada', mat_nombre 'Mat. Nunca ofertada', plm_ciclo, plm_anio_carrera, esc_nombre,
'Nunca ofertada y tiene requisito' 'Estado',
mat_posible_oferta 'CodMat. Posible Oferta', req_necesario 'Cant. Req. Necesarios', req_ofertados 'Cant. Req. Ofertados', requisitos 'Detalle Requisitos'
from @tbl_estatus_mat as tbl
inner join  @mat_no_ofertadas as mat on tbl.mat_posible_oferta = mat.plm_codmat
where req_codmat != ''

--declare @codper varchar(12), @codpla int
--declare m_cursor cursor 
--for
--select alc_codper, alc_codpla from ra_alc_alumnos_carrera where alc_codpla 
--in (select pla_codigo from @mat_no_ofertadas where req_codmat != '') and alc_codper = 100669
--open m_cursor 
 
--fetch next from m_cursor into @codper, @codpla
--while @@FETCH_STATUS = 0 
--begin
--	select per_carnet, mai_codmat from ra_alc_alumnos_carrera 
--		inner join ra_per_personas on per_codigo = alc_codper
--		inner join ra_ins_inscripcion on ins_codper = per_codigo
--		inner join ra_mai_mat_inscritas on mai_codins = ins_codigo and mai_codpla = alc_codpla
--		inner join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
--		inner join ra_mat_materias on mat_codigo = mai_codmat
--	where alc_codpla in (
--	select pla_codigo from @mat_no_ofertadas where req_codmat != ''
--	)
--	and per_codigo = @codper
--	and mai_estado <> 'R'
--	select * from @mat_no_ofertadas where pla_codigo = @codpla and req_codmat != ''
--    fetch next from m_cursor into @codper, @codpla
--end      
--close m_cursor  
--deallocate m_cursor

---	Número de alumnos que llevan en orden  el pensum (desde el ciclo que ingreso a la universidad)
---	Número de alumnos que no llevan en orden el pensum
---	Identificar la cantidad de materias que se van a servir por primera vez en el ciclo 02-2020 y así sucesivamente. (por escuela)