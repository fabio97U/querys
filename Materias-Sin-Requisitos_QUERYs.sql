create table ra_matsrc_materias_sin_requistos_por_carrera (
	matsrc_codigo int primary key identity (1, 1),
	matsrc_codcar int,
	matsrc_descripcion varchar(250),
	matsrc_fecha_creacion datetime default getdate()
)
insert into ra_matsrc_materias_sin_requistos_por_carrera 
(matsrc_codcar, matsrc_descripcion) values
(260, 'Carrera universitaria'),--MAESTRÍA EN INGENIERÍA PARA LA INDUSTRIA, CON ESPECIALIDAD EN ROBÓTICA
(107, 'Carrera universitaria'), 
(41, 'Carrera universitaria'), 
(42, 'Carrera universitaria'), 
(43, 'Carrera universitaria'), 
(44, 'Carrera universitaria'), 
(96, 'Carrera universitaria'), 
(47, 'Carrera universitaria'), 
(117, 'Carrera universitaria'), 
(49, 'Carrera universitaria'), 
(55, 'Carrera universitaria'), 
(62, 'Carrera universitaria'), 
(72, 'Carrera universitaria'), 
(208, 'Carrera universitaria'), 
(233, 'Carrera universitaria'), 
(247, 'Carrera universitaria'), 
(78, 'Carrera universitaria'), 
(79, 'Carrera universitaria'), 
(217, 'Carrera universitaria'), 
(218, 'Carrera universitaria'), 
(219, 'Carrera universitaria'), 
(89, 'Carrera universitaria'), 
(90, 'Carrera universitaria')
--select * from ra_matsrc_materias_sin_requistos_por_carrera






USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rpe_datgenerales]    Script Date: 23/10/2020 10:13:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:      <>
	-- Last modify: <Fabio>
	-- Create date: <2020-10-23 09:47:15.800>
	-- Description: <Devuelve la data de los planes>
	-- =============================================
	-- exec rpe_datgenerales 10, 478--Maes Industrial
	-- exec rpe_datgenerales 10, 371--Maes ing. campos

ALTER proc [dbo].[rpe_datgenerales]	
	@campo0 int, --codfac
	@campo1 int --codpla
as
begin
	
	declare @requisitos as table (
		codpla int,
		codmat varchar(10) collate Modern_Spanish_CI_AS,
		codmat_req varchar(10) collate Modern_Spanish_CI_AS,
		num int
	)

	declare @nums_ciclos as table (ciclo_cardinal int, ciclo_romano varchar(5))
	insert into @nums_ciclos (ciclo_cardinal, ciclo_romano) values 
	(1, 'I'), (2, 'II'), (3, 'III'), (4, 'IV'), (5, 'V'), (6, 'VI'), (7, 'VII'), (8, 'VIII'), (9, 'IX'), (10, 'X'), 
	(11, 'XI'), (12, 'XII'), (13, 'XIII'), (14, 'XIV'), (15, 'XV')

	declare @tbl_codmat_induc as table (codmat_induc varchar(15))
	insert into @tbl_codmat_induc (codmat_induc) values ('INDUC-C'), ('INDUC-E'), ('INDUC-I'), ('INDUC-J'), ('INDUCI-V'), ('INDUC-V')

	insert into @requisitos (codpla, codmat, codmat_req, num)
	select req_codpla, req_codmat, req_codmat_req,
		ROW_NUMBER() OVER (PARTITION BY req_codmat ORDER BY req_codmat) num
	from ra_req_requisitos
	where req_codpla = @campo1
	order by req_codmat

	select pla_codigo,car_codigo,carrera,facultad,universidad,anio,ciclo,numero,"Codigo Materia",
	Nombre,"Codigo Requisito",
	case when uv_req > 0 then cast(uv_req as varchar) + ' UV' else '' end + ' ' + 
	case when porc_req > 0 then cast(porc_req as varchar)+ '%' else '' end + ' ' + 
	isnull(requisito,'') requisito,
	"U.V.",plm_horas_practicas,plm_horas_semanales,laboratorio,
	pla_nombre,pla_acuerdo, pla_desde, pla_hasta, 
	tot_uv,tot_ma, max_cic, uv_req, porc_req, tot_ht,tot_hp,pla_ciclo_desde, pla_ciclo_hasta,
	num
	from (
		select pla_codigo,car_codigo,Carrera Carrera, Facultad, Universidad, isnull(anio,0)Anio,Ciclo, 
		isnull(numero,0)Numero,"Codigo Materia",
		Nombre,
		isnull(Requisito,'') "Codigo Requisito",
		isnull(Requisito,'') + case when isnull(Requisito,'') <> '' then ' ' else '' end + 
		isnull(isnull(plm_alias,mat_nombre),
		case when pla_tipo = 'P' then '' else case when isnull((select reu_uv
		from ra_reu_requisitos_uv
		where reu_codpla = @campo1
		and reu_codmat = "Codigo Materia"
		and reu_uv > 0),0) > 0 then '' else 
		case when isnull(
		(select reo_porcentaje
		from ra_reo_requisitos_porc
		where reo_codpla = @campo1
		and reo_codmat = "Codigo Materia"
		and reo_porcentaje > 0),0) > 0 then '' 

		when isnull(matsrc_descripcion, '') <> '' then upper(matsrc_descripcion)

		else 'BACHILLERATO' end end end) requisito,
		"U.V.", 
		isnull(practicas,0) plm_horas_practicas,
		isnull(semanales,0) plm_horas_semanales,laboratorio,
		pla_nombre, pla_acuerdo, pla_desde, pla_hasta, pla_ciclo_desde, pla_ciclo_hasta,
		plm.tot_uv tot_uv, plm.tot_ma tot_ma, plm.max_cic max_cic, 
		isnull((
			select reu_uv
			from ra_reu_requisitos_uv
			where reu_codpla = @campo1
			and reu_codmat = "Codigo Materia"
			and reu_uv > 0)
		,'') uv_req,

		isnull((
			select reo_porcentaje
			from ra_reo_requisitos_porc
			where reo_codpla = @campo1
			and reo_codmat = "Codigo Materia"
			and reo_porcentaje > 0)
		,'') porc_req,

		plm.tot_ht tot_ht,
		plm.tot_hp tot_hp,num
		from 
			(
			select car_codigo,pla_alias_carrera as Carrera, fac_nombre as Facultad, fac_codigo,
			uni_nombre as Universidad, plm_anio_carrera as Anio,
			
			ciclo_romano as Ciclo, 

			plm_num_mat as Numero, 
			mat_codigo 'Codigo Materia', 
			mat_codigo + ' ' + isnull(plm_alias,mat_nombre) as Nombre, 
			codmat_req as Requisito, 
			plm_uv as 'U.V.',plm_horas_practicas practicas,plm_horas_semanales semanales,
			case when plm_laboratorio = 'S' then 'Si' else 'No' end laboratorio,pla_nombre,
			pla_acuerdo, pla_desde, pla_hasta, pla_codigo,pla_tipo,pla_ciclo_desde, pla_ciclo_hasta,
			num,

			matsrc_descripcion
			from ra_plm_planes_materias
				join ra_pla_planes on pla_codigo = plm_codpla
				join ra_mat_materias on mat_codigo = plm_codmat
				join @requisitos on codpla = pla_codigo and codmat = mat_codigo
				join ra_car_carreras on car_codigo = pla_codcar
				join ra_fac_facultades on fac_codigo = car_codfac
				join ra_uni_universidad on uni_codigo = 1

				join @nums_ciclos on plm_ciclo = ciclo_cardinal

				left join ra_matsrc_materias_sin_requistos_por_carrera on car_codigo = matsrc_codcar
			where plm_codpla = @campo1
		
			union all

			select car_codigo,pla_alias_carrera as Carrera, fac_nombre as Facultad, fac_codigo,
			uni_nombre as Universidad, plm_anio_carrera as Año, 

			ciclo_romano Ciclo, 

			plm_num_mat as Numero,mat_codigo 'Codigo Materia', 
			mat_codigo + ' ' +isnull(plm_alias,mat_nombre) as Nombre,  
			null as Requisito, 
			plm_uv as 'U.V.',plm_horas_practicas,plm_horas_semanales,
			case when plm_laboratorio = 'S' then 'Si' else 'No' end laboratorio, pla_nombre,
			pla_acuerdo, pla_desde, pla_hasta, pla_codigo,pla_tipo,pla_ciclo_desde, pla_ciclo_hasta,0,

			matsrc_descripcion
			from ra_plm_planes_materias
				join ra_pla_planes on pla_codigo = plm_codpla
				join ra_mat_materias on mat_codigo = plm_codmat
				join ra_car_carreras on car_codigo = pla_codcar
				join ra_fac_facultades on fac_codigo = car_codfac 
				join ra_uni_universidad on uni_codigo = 1
				join @nums_ciclos on plm_ciclo = ciclo_cardinal

				left join ra_matsrc_materias_sin_requistos_por_carrera on car_codigo = matsrc_codcar
			where plm_codpla = @campo1
			and mat_codigo not in (
					select req_codmat
					from ra_req_requisitos
					where req_codpla = plm_codpla
				)
			) t 
			join (
				select plm_codpla codpla,sum(plm_horas_practicas) tot_hp,sum(plm_horas_semanales) tot_ht,
				count(distinct plm_codmat) tot_ma,  max(plm_ciclo) max_cic,sum(plm_uv) tot_uv
				from ra_plm_planes_materias
				where plm_codpla = @campo1
				and plm_anio_carrera <> 0 and plm_codmat not in (select codmat_induc from @tbl_codmat_induc)
				group by plm_codpla
			) plm on plm.codpla = @campo1
			left outer join ra_plm_planes_materias on plm_codpla = pla_codigo and plm_codmat = requisito
			left outer join ra_mat_materias on requisito = mat_codigo
		where anio is not null and numero is not null 
		---and requisito is not null
	) z
	where anio<>0 and [Codigo Materia] not in (select codmat_induc from @tbl_codmat_induc)
	order by numero---,anio,ciclo,isnull(requisito,0),requisito

end