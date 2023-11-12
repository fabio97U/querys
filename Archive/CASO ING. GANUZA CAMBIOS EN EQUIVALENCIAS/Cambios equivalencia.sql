declare @codper int = 241819
select equ_codigo, equ_codper, equ_codpla, ist_nombre equ_universidad, cae_nombre equ_carrera, 
	equ_codist, equ_codcae, 
	(select count(distinct eqn_codmat) from ra_eqn_equivalencia_notas where eqn_codequ = equ.equ_codigo and eqn_nota > 5.96) 'equivalencias_asignadas'
from ra_equ_equivalencia_universidad equ
	join adm_ist_instituciones on ist_codigo = equ_codist 
	join adm_cae_carrera_externa on cae_codigo = equ_codcae
where equ_codper = @codper and equ_tipo = 'E' 

select distinct eqn_nom_mat_equivalencia from ra_eqn_equivalencia_notas
select equ_universidad, count(1) from ra_equ_equivalencia_universidad group by equ_universidad order by 2




select * from ra_equ_equivalencia_universidad
alter table ra_eqn_equivalencia_notas add eqn_nota_tipo varchar(50)

update a set a.eqn_nota_tipo = (select case 
when equ_universidad = 'UNIV. TECNOLOGICA DE EL SALVADOR' then 'Eq. Interna'
else 'Eq. Externa' end)
from ra_eqn_equivalencia_notas a
inner join ra_equ_equivalencia_universidad b on a.eqn_codequ = b.equ_codigo

select * from ra_eqn_equivalencia_notas

--select case 
--when equ_universidad = 'UNIV. TECNOLOGICA DE EL SALVADOR' then 'Eq. Interna'
--else 'Eq. Externa' end 'nota_tipo', * 
--from ra_eqn_equivalencia_notas--141305
--inner join ra_equ_equivalencia_universidad on eqn_codequ = equ_codigo

declare @equ_universidad varchar(250) = 'UNIV. TECNOLOGICA DE EL SALVADOR'
select case when @equ_universidad = 'UNIV. TECNOLOGICA DE EL SALVADOR' then 'Eq. Interna'
else 'Eq. Externa' end 'nota_tipo'
union all
select 'Suficiencia'  'nota_tipo'


select case 
when equ_universidad = 'UNIV. TECNOLOGICA DE EL SALVADOR' then 'Eq. Interna'
else 'Eq. Externa' end 'nota_tipo', * 
from ra_eqn_equivalencia_notas
inner join ra_equ_equivalencia_universidad on eqn_codequ = equ_codigo
where equ_codper = 241651

declare @codequ int = 12381, @codper int = 241651--25-4979-2022
declare @Busqueda varchar(50) = '', @codpla int = 324

--select eqn_codigo, mat_codigo, isnull(plm_alias,mat_nombre) mat_nombre, 
--	isnull(eqn_nom_mat_equivalencia,'') eqn_nom_mat_equivalencia, isnull(eqn_nota,0) eqn_nota, eqn_fechahora, equ_universidad
--from ra_eqn_equivalencia_notas 
--	join ra_mat_materias on mat_codigo = eqn_codmat
--	join ra_plm_planes_materias on plm_codpla = @codpla and plm_codmat = mat_codigo
--	inner join ra_equ_equivalencia_universidad on eqn_codequ = equ_codigo
--where eqn_codequ = @codequ and (
--	mat_codigo like '%' + 
--	case when isnull(ltrim(rtrim(@Busqueda)), '') = '' then '' else ltrim(rtrim(@Busqueda)) + '%' end or isnull(plm_alias,mat_nombre) like  '%' + 
--	case when isnull(ltrim(rtrim(@Busqueda)), '') = '' then '' else ltrim(rtrim(@Busqueda)) + '%' end
--)  order by 3

select eqn_codigo, mat_codigo, isnull(plm_alias,mat_nombre) mat_nombre, 
	isnull(eqn_nom_mat_equivalencia,'') eqn_nom_mat_equivalencia, isnull(eqn_nota,0) eqn_nota, eqn_fechahora, equ_universidad, eqn_nota_tipo, plm_num_mat
from ra_eqn_equivalencia_notas 
	join ra_mat_materias on mat_codigo = eqn_codmat
	join ra_plm_planes_materias on plm_codpla = @codpla and plm_codmat = mat_codigo
	inner join ra_equ_equivalencia_universidad on eqn_codequ = equ_codigo
where eqn_codequ = @codequ and (
	mat_codigo like '%' + 
	case when isnull(ltrim(rtrim(@Busqueda)), '') = '' then '' else ltrim(rtrim(@Busqueda)) + '%' end or isnull(plm_alias,mat_nombre) like  '%' + 
	case when isnull(ltrim(rtrim(@Busqueda)), '') = '' then '' else ltrim(rtrim(@Busqueda)) + '%' end
)  order by 3


select *, equivalencias_asignadas + suficiencia_asignadas 'total' from (
	select equ_codigo, equ_codper, equ_codpla, ist_nombre equ_universidad, cae_nombre equ_carrera, 
		equ_codist, equ_codcae, 
		(select count(distinct eqn_codmat) from ra_eqn_equivalencia_notas where eqn_codequ = equ.equ_codigo and eqn_nota_tipo not in ('Suficiencia') and eqn_nota between 5.96 and 100) 'equivalencias_asignadas',
		(select count(distinct eqn_codmat) from ra_eqn_equivalencia_notas where eqn_codequ = equ.equ_codigo and eqn_nota_tipo = 'Suficiencia' and eqn_nota between 5.96 and 100) 'suficiencia_asignadas'
	from ra_equ_equivalencia_universidad equ
		join adm_ist_instituciones on ist_codigo = equ_codist 
		join adm_cae_carrera_externa on cae_codigo = equ_codcae
	where equ_codper = @codper and equ_tipo = 'E' 
) t



USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[insnotequi]    Script Date: 4/11/2022 14:43:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:      <Author, Name>
	-- Create date: <Create Date>
	-- Last Modify: <Fabio, 2022-11-04 14:58:43.593>
	-- Description: <Inserta la "plantilla" del plan para asignarle equivalencias>
	-- =============================================
	-- exec insnotequi 1, 4, 627, 0
ALTER proc [dbo].[insnotequi]
	@regional int = 0,
	@codpla int = 0,
	@codper int = 0,
	@codequ int = 0
as
begin

	declare @corr int, @var int, @equ_universidad varchar(250)
	
	select @corr = isnull(max(eqn_codigo),0) from ra_eqn_equivalencia_notas

	select @equ_universidad = equ_universidad from ra_equ_equivalencia_universidad where equ_codigo = @codequ

	insert into ra_eqn_equivalencia_notas
	(eqn_codigo, eqn_codreg, eqn_codmat, eqn_nota, eqn_codequ, eqn_nota_tipo)
	
	select (@corr + (row_number() OVER(ORDER BY per_codigo ASC))) eqn_codigo, @regional,
	mat_codigo,0 eqn_nota,@codequ, (case when @equ_universidad = 'UNIV. TECNOLOGICA DE EL SALVADOR' then 'Eq. Interna'
	else 'Eq. Externa' end)
	from ra_mat_materias, ra_per_personas,
		ra_alc_alumnos_carrera, ra_plm_planes_materias
	where per_codigo = @codper
		and alc_codpla = @codpla and alc_codper = per_codigo and alc_codpla = plm_codpla
		and mat_codigo = plm_codmat and per_codreg = @regional
		and plm_ciclo is not null and plm_anio_carrera is not null
		and plm_codmat not in (
			select eqn_codmat from ra_eqn_equivalencia_notas
			where eqn_codreg = @regional and eqn_codequ = @codequ
		)
end






--cambios SP´s




USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_record_academico_limpio]    Script Date: 4/11/2022 16:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:      <Author, Name>
	-- Last Modify <Fabio, 2022-09-12 18:30:37.793, se modifico el reporte para los estudiantes con carnet <= 2000
				-- para mostrar el formato de I1 e I2 de interciclos en esa epoca>
	-- Create date: <>
	-- Description: <Devuelve la data para el reporte de notas autentica>
	-- =============================================
	-- exec dbo.rep_record_academico_limpio 1, '25-4979-2022', 'N'
ALTER proc [dbo].[rep_record_academico_limpio]
    @campo0 int = 0, --codreg
	@campo1 varchar(12) = '', --Carnet
	@campo2 varchar(1) = '' -- S: CUM Limpio, N: CUM No limpio
as
begin

	--WAITFOR DELAY '00:01'

	declare @nota_minima real, @codigo_persona int, @materias int, @aprobadas int, @reprobadas int,   
	@equivalencias int, @ciclo_vigente int, @estado_persona varchar(20),  
	@tipo_ingreso int, @apellidos_nombres varchar(100), @tipo varchar(1),  
	@codpla_act int,@cum_repro real, @cum real  
  
	declare @record table (  
		cil_codcic int, cil_codigo varchar(80),  
		uni_nombre varchar(250), per_carnet varchar(12),  
		per_nombres_apellidos varchar(200), car_nombre varchar(250),
		pla_alias_carrera varchar(150), fac_nombre varchar(100),  
		pla_nombre varchar(100), reg_nombre varchar(80),  
		cic_nombre varchar(50), cil_anio int,  
		mat_codigo varchar(10), mat_nombre varchar(200),  
		nota real, nota_letras varchar(100),  
		estado varchar(20), cum_parcil real, cum real, materias int,  
		aprobadas int, reprobadas int, matricula int, equivalencias int,  
		ing_nombre varchar(50), estado_a varchar(20),  
		plm_anio_carrera int, plm_ciclo int,   
		absorcion varchar(2), uv int, um float
	)

	declare @ra_mai_mat_inscritas_h_v table (  
		codper int, codcil int,  
		mai_codigo int, mai_codins int,  
		mai_codmat varchar(10) collate Modern_Spanish_CI_AS,  
		mai_absorcion varchar(1), mai_financiada varchar(1),  
		mai_estado varchar(1), mai_codhor int,  
		mai_matricula int, mai_acuerdo varchar(20),  
		mai_fecha_acuerdo datetime, mai_codmat_del varchar(10) collate Modern_Spanish_CI_AS,  
		fechacreacion datetime, mai_codpla int,  
		mai_uv int, mai_tipo varchar(1), mai_codhpl int  
	)
	declare @notas table (  
		ins_codreg int, ins_codigo int,  
		ins_codcil int, ins_codper int,  
		mai_codigo int, mai_codmat varchar(10) collate Modern_Spanish_CI_AS,  
		mai_codhor int, mai_matricula int,  
		estado varchar(1), mai_codpla int,  
		absorcion_notas varchar(1), uv int,  
		nota float, mai_codhpl int  
	)   

	select @nota_minima = uni_nota_minima from ra_reg_regionales, ra_uni_universidad 
	where reg_codigo = @campo0 and uni_codigo = reg_coduni

	select @codigo_persona = per_codigo, @estado_persona = estp_descripcion,  
	@tipo_ingreso = per_tipo_ingreso, @apellidos_nombres = per_apellidos_nombres, @tipo = per_tipo  
	from ra_per_personas 
		inner join  ra_estp_estado_persona on per_estado = estp_estado
	where per_carnet = @campo1  
    print '@codper ' + cast(@codigo_persona as varchar(10))
	declare @ins table (codins int)
	insert into @ins (codins)
	select max(ins_codigo) codins
	from ra_ins_inscripcion  
		join ra_cil_ciclo on cil_codigo = ins_codcil  
	where ins_codper = @codigo_persona  

	select @codpla_act = alc_codpla from ra_alc_alumnos_carrera where alc_codper = @codigo_persona  

	if @tipo = 'U'
	begin
		insert into @ra_mai_mat_inscritas_h_v  
		select *  
		from ra_mai_mat_inscritas_h_v  
		where codper = @codigo_persona  
		and mai_codpla = @codpla_act  
		and codcil not in (
			select cil_codigo from ra_cil_ciclo where cil_vigente = 'S'
			union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S'
		)
	end
	else
	begin
		insert into @ra_mai_mat_inscritas_h_v  
		select *  
		from ra_mai_mat_inscritas_h_v  
		where codper = @codigo_persona and mai_codpla = @codpla_act  
	end

	insert into @notas
	select * from notas  
	where ins_codper = @codigo_persona and mai_codpla = @codpla_act
	select @materias = count(1)   
	from ra_alc_alumnos_carrera, ra_plm_planes_materias  
	where alc_codper = @codigo_persona and plm_codpla = alc_codpla  

	select @aprobadas = sum(a)   
	from (
		select count(1) a   
		from @notas b,ra_alc_alumnos_carrera, ra_plm_planes_materias  
		where b.ins_codper = @codigo_persona and round(b.nota,1) >= @nota_minima  
		and alc_codper = b.ins_codper and plm_codpla = alc_codpla
		and plm_codmat = b.mai_codmat
		and b.ins_codcil not in (
			select cil_codigo from ra_cil_ciclo where cil_vigente = 'S'
			union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S'
		)
			union all  
		select count(distinct eqn_codmat)   
		from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,  
			ra_alc_alumnos_carrera, ra_plm_planes_materias  
		where equ_codigo = eqn_codequ and equ_codper = @codigo_persona 
		and eqn_nota >= @nota_minima and alc_codper = equ_codper  
		and plm_codpla = alc_codpla and plm_codmat = eqn_codmat  
	) t   

	select @reprobadas = sum(a)
	from (
		select count(1) a 
		from @notas b,ra_alc_alumnos_carrera, ra_plm_planes_materias  
		where b.ins_codper = @codigo_persona  
		and b.ins_codcil not in (
			select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' 
			union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S'
		)
		and b.estado = 'I'  
		and round(b.nota,1) < @nota_minima  and alc_codper = b.ins_codper  
		and plm_codpla = alc_codpla and plm_codmat = b.mai_codmat 
			union all  
		select count(distinct eqn_codmat)
		from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,  
		ra_alc_alumnos_carrera, ra_plm_planes_materias  
		where equ_codigo = eqn_codequ and equ_codper = @codigo_persona and eqn_nota > 0 and eqn_nota < @nota_minima
		and alc_codper = equ_codper and plm_codpla = alc_codpla and plm_codmat = eqn_codmat 
	) t
       

    if @campo2 = 'S' 
	begin
		set @reprobadas = 0
	end

	select @equivalencias = count(distinct eqn_codmat)   
	from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,   
	ra_alc_alumnos_carrera, ra_plm_planes_materias  
	where equ_codigo = eqn_codequ and equ_codper = @codigo_persona  
	and eqn_nota > 0 and equ_tipo = 'E'  
	and alc_codper = equ_codper and plm_codpla = alc_codpla and plm_codmat = eqn_codmat

	declare @tot_uv real
	declare @uv_total table(codmat nvarchar(50), uv int, nota real)

	insert into @uv_total
	select a, b, max(c)
	from (
		select plm_codmat as a, plm_uv as b, nota as c
		from @notas b,ra_alc_alumnos_carrera, ra_plm_planes_materias
		where b.ins_codper = @codigo_persona
		and round(b.nota,1) >= @nota_minima and alc_codper = b.ins_codper
		and plm_codpla = alc_codpla and plm_codmat = b.mai_codmat
			union all
		select eqn_codmat, plm_uv, eqn_nota
		from (
			select distinct eqn_codmat, plm_uv, eqn_nota
			from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,
			ra_alc_alumnos_carrera, ra_plm_planes_materias
			where equ_codigo = eqn_codequ
				and equ_codper = @codigo_persona and eqn_nota > 0
				and alc_codper = equ_codper and plm_codpla = alc_codpla and plm_codmat = eqn_codmat
		) z
	) t 
	group by a,b

	select @tot_uv = sum(uv) from @uv_total

	select @cum_repro = dbo.nota_aproximacion(dbo.cum_repro(@codigo_persona))

	select @cum = round(dbo.nota_aproximacion(dbo.cum(@codigo_persona)),1)
   
	if @campo2 = 'N'  
	begin  
		insert into @record  
		(cil_codcic, cil_codigo, uni_nombre, per_carnet, per_nombres_apellidos, car_nombre, pla_alias_carrera, fac_nombre, pla_nombre, 
		reg_nombre, cic_nombre, cil_anio, mat_codigo, mat_nombre, nota, nota_letras, estado, cum_parcil, cum, materias, aprobadas, 
		reprobadas, matricula, equivalencias, ing_nombre, estado_a, plm_anio_carrera, plm_ciclo, absorcion, uv)

		select cil_codcic, cast(cil_anio as varchar) + cic_nombre cil_codigo, uni_nombre, per_carnet, per_nombres_apellidos,   
		car_nombre,x.pla_alias_carrera, fac_nombre, pla_nombre,reg_nombre,   
		cic_nombre, cil_anio, mat_codigo, mat_nombre, round(nota,1) nota,   
		upper(dbo.NotaALetras(round(nota,1))), estado estado, round(cum_ciclo,1) cum_parcial,   
		@cum_repro cum, @materias, @aprobadas, @reprobadas,   
		matricula, @equivalencias,   
		ing_nombre, estado_a, plm_anio_carrera, plm_ciclo, absorcion, uv  
		from (/*ORDENAR AQUI*/
			select cil_codcic,cil_codigo codcil,uni_nombre, codper,per_carnet,   
			per_nombres_apellidos,   
			car_nombre,pla_alias_carrera, fac_nombre,pla_codigo,pla_nombre,  
			reg_nombre,   
			cic_nombre, cil_anio,   
			mat_codigo, mat_nombre, isnull(nota,0) nota,      
			estado =          
			case 
			when (mai_estado)= 'R' THEN 'Retirada'
			when isnull(round(nota,1),0) <  @nota_minima THEN 'Reprobada' 
			else 'Aprobada'
			end,

			dbo.cum_ciclo(cil_codigo,codper) cum_ciclo,0 cum,  
			matricula,ing_nombre, estado_a, plm_anio_carrera, plm_ciclo, absorcion, uv  
			from  
			(  
			select cil_codcic,cil_codigo,uni_nombre, codper codper, @campo1 per_carnet,   
			@apellidos_nombres per_nombres_apellidos,   
			car_nombre,pla_alias_carrera, reg_nombre, mat_codigo,  
			isnull(plm_alias,mat_nombre) +  
			case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre,   
			cic_nombre, cil_anio, mai_estado,mai_codins codins,  
			@campo0 codreg, mai_matricula matricula, fac_nombre, pla_codigo,pla_nombre, ing_nombre,  
			@estado_persona estado_a, plm_anio_carrera, plm_ciclo,   
			mai_absorcion absorcion, mai_codmat_del  
			from @ra_mai_mat_inscritas_h_v, ra_mat_materias,   
			ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras,ra_fac_facultades,  
			ra_cil_ciclo, ra_cic_ciclos, ra_ing_ingreso, ra_plm_planes_materias,  
			ra_uni_universidad, ra_reg_regionales  
			where codper = @codigo_persona  
			and alc_codper = codper  
			and pla_codigo = alc_codpla  
			and car_codigo = pla_codcar  
			and fac_codigo = car_codfac  
			and cil_codigo = codcil  
			and cic_codigo = cil_codcic  
			and mat_codigo = mai_codmat  
			and ing_codigo = @tipo_ingreso  
			and plm_codpla = pla_codigo  
			and plm_codmat = mai_codmat  
			and not exists (select 1 from ra_cca_cambio_carrera 
			where cca_codper = @codigo_persona 
			and cca_codmat_eqn is not null 
			and cca_codmat_eqn <> '0'
			and mai_codmat_del = cca_codmat)   
			and reg_codigo = cil_codreg  
			and uni_codigo = reg_coduni  
			and substring(@tipo,1,1) in('U','M')  
			)j left outer join @notas on ins_codper = codper  
			and mai_codmat = mai_codmat_del  
			and ins_codcil = cil_codigo  
			union all  
			select 0,0,  
			uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera,   
			fac_nombre,pla_codigo,pla_nombre,  
			reg_nombre,uni,car,eqn_codmat, mat_nombre, eqn_nota,   
			case when eqn_nota >= @nota_minima then 'Aprobada' else 'Reprobada' end estado,  
			0, 0,1,ing_nombre,  
			estado, plm_anio_carrera, plm_ciclo,'',plm_uv  
			from  
			(  
			select distinct uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera,   
			reg_nombre, eqn_nota_tipo/*'Eq. Externa '*/ uni, '' car,   
			eqn_codmat, isnull(plm_alias,mat_nombre) +  
			case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre,   
			(select avg(a.eqn_nota)   
			from ra_eqn_equivalencia_notas a, ra_equ_equivalencia_universidad b  
			where a.eqn_codmat = mat_codigo   
			and a.eqn_codequ = b.equ_codigo  
			and a.eqn_codmat is not null   
			and a.eqn_nota > 0  
			and b.equ_codper = per_codigo) eqn_nota, fac_nombre, pla_codigo,pla_nombre,  
			ing_nombre,  estp_descripcion estado, plm_anio_carrera, plm_ciclo,  
			plm_uv  
			from ra_per_personas,ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,  
			ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras, ra_reg_regionales, ra_uni_universidad,  
			ra_mat_materias, ra_fac_facultades, ra_ing_ingreso, ra_plm_planes_materias,ra_estp_estado_persona  
			where per_codigo = @codigo_persona  
			and equ_codper = per_codigo  
			and eqn_codequ = equ_codigo  
			--                  and equ_tipo = 'E'  
			and alc_codper = per_codigo  
			and pla_codigo = alc_codpla  
			and car_codigo = pla_codcar  
			and fac_codigo = car_codfac  
			and mat_codigo = eqn_codmat  
			and reg_codigo = per_codreg  
			and uni_codigo = reg_coduni  
			and eqn_nota > 0  
			and ing_codigo = per_tipo_ingreso  
			and plm_codpla = pla_codigo  
			and plm_codmat = mat_codigo  
			and equ_codist <> 711
			and per_estado = estp_estado
			) t  
			union all  
			select 0,0,  
			uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera,   
			fac_nombre,pla_codigo,pla_nombre,  
			reg_nombre,uni,car,eqn_codmat, mat_nombre, eqn_nota,   
			case when eqn_nota >= @nota_minima then 'Aprobada' else 'Reprobada' end estado, 
			0, 0,1,ing_nombre,  
			estado, plm_anio_carrera, plm_ciclo,'', plm_uv  
			from  
			(  
			select distinct uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera,   
			reg_nombre, eqn_nota_tipo/*'Eq. Interna '*/ uni, '1' car,   
			eqn_codmat, isnull(plm_alias,mat_nombre) +  
			case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre,   
			(select avg(a.eqn_nota)   
			from ra_eqn_equivalencia_notas a, ra_equ_equivalencia_universidad b  
			where a.eqn_codmat = mat_codigo   
			and a.eqn_codequ = b.equ_codigo  
			and a.eqn_codmat is not null  
			and a.eqn_nota > 0  
			and b.equ_codper = per_codigo) eqn_nota, equ_codigo codequ, fac_nombre, pla_codigo,pla_nombre,  
			ing_nombre,estp_descripcion estado, plm_anio_carrera, plm_ciclo,  
			plm_uv  
			from ra_per_personas,ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,  
			ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras, ra_reg_regionales, ra_uni_universidad,  
			ra_mat_materias, ra_fac_facultades, ra_ing_ingreso, ra_plm_planes_materias,ra_estp_estado_persona
       
			where per_codigo = @codigo_persona  
			and equ_codper = per_codigo  
			and eqn_codequ = equ_codigo  
			and alc_codper = per_codigo  
			and pla_codigo = alc_codpla  
			and car_codigo = pla_codcar  
			and fac_codigo = car_codfac  
			and mat_codigo = eqn_codmat  
			and reg_codigo = per_codreg  
			and uni_codigo = reg_coduni  
			and eqn_nota > 0  
			and ing_codigo = per_tipo_ingreso  
			and plm_codpla = pla_codigo  
			and plm_codmat = mat_codigo 
			and equ_codist = 711 
			and per_estado = estp_estado
			) t  
			union all  
			select distinct 1,0,  
			uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,b.pla_alias_carrera, fac_nombre,  
			alc_codpla pla_codigo,b.pla_nombre pla_nombre,  
			reg_nombre,'Eq. Interna ', '1',   
			cca_codmat, isnull(plm_alias,mat_nombre) +  
			case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre, /*cast(*/nota/* as varchar)*/,   
			'Aprobada' estado,0,  0, 1,  
			ing_nombre,  estp_descripcion estado, plm_anio_carrera, plm_ciclo,'',plm_uv  
			from ra_per_personas,ra_cca_cambio_carrera,ra_alc_alumnos_carrera,ra_pla_planes b,  
			ra_pla_planes a, ra_car_carreras, ra_fac_facultades,  
			ra_reg_regionales, ra_uni_universidad,  
			ra_mat_materias, @notas,ra_ing_ingreso, ra_plm_planes_materias, ra_estp_estado_persona
			where per_codigo = @codigo_persona  
			and cca_codper = per_codigo  
			and a.pla_codigo = cca_codpla_eqn  
			and car_codigo = a.pla_codcar  
			and fac_codigo = car_codfac  
			and mat_codigo = cca_codmat_eqn  
			and reg_codigo = per_codreg  
			and uni_codigo = reg_coduni  
			and ins_codper = cca_codper  
			and mai_codmat = cca_codmat  
			and cca_codmat_eqn is not null and cca_codmat_eqn <> '0'  
			and ing_codigo = per_tipo_ingreso  
			and plm_codpla = a.pla_codigo  
			and plm_codmat = mat_codigo  
			and nota >= @nota_minima   
			and alc_codper = per_codigo  
			and b.pla_codigo = alc_codpla 
			and per_estado = estp_estado 
             
		) x
	end
	else
	begin  
	
		insert into @record 
		(cil_codcic, cil_codigo, uni_nombre, per_carnet, per_nombres_apellidos, car_nombre, pla_alias_carrera, fac_nombre, pla_nombre, 
		reg_nombre, cic_nombre, cil_anio, mat_codigo, mat_nombre, nota, nota_letras, estado, cum_parcil, cum, materias, aprobadas, 
		reprobadas, matricula, equivalencias, ing_nombre, estado_a, plm_anio_carrera, plm_ciclo, absorcion, uv) 
		select cil_codcic, cast(cil_anio as varchar) + cic_nombre cil_codigo, uni_nombre, per_carnet, per_nombres_apellidos,   
		car_nombre,x.pla_alias_carrera, fac_nombre, pla_nombre,reg_nombre, cic_nombre, cil_anio,  
		mat_codigo, mat_nombre, round(nota,1) nota,   
		upper(dbo.NotaALetras(round(nota,1))), estado estado, round(cum_ciclo,1) cum_parcial,   
		@cum cum, @materias, @aprobadas, @reprobadas, matricula, @equivalencias,   
		ing_nombre, estado_a, plm_anio_carrera, plm_ciclo, absorcion, uv  
		from (/*ORDENAR AQUI*/
			select cil_codcic,cil_codigo codcil,uni_nombre, codper,per_carnet,   
			per_nombres_apellidos,   
			car_nombre,pla_alias_carrera, fac_nombre,pla_codigo,pla_nombre,  
			reg_nombre,   
			cic_nombre, cil_anio,   
			mat_codigo, mat_nombre, isnull(nota,0) nota,   
			estado =
			CASE WHEN (mai_estado)= 'R' THEN 'Retirada'
			WHEN isnull(round(nota,1),0) <  @nota_minima THEN 'Reprobada' 
			ELSE 'Aprobada' END,
			dbo.cum_ciclo(cil_codigo,codper) cum_ciclo,0 cum,  
			matricula,ing_nombre, estado_a, plm_anio_carrera, plm_ciclo, absorcion, uv  
			from  
			(  
			select cil_codcic,cil_codigo,uni_nombre, codper codper, @campo1 per_carnet,   
			@apellidos_nombres per_nombres_apellidos,   
			car_nombre,pla_alias_carrera, reg_nombre, mat_codigo,  
			isnull(plm_alias,mat_nombre) +  
			case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre,   
			cic_nombre, cil_anio, mai_estado,mai_codins codins,  
			@campo0 codreg, mai_matricula matricula, fac_nombre, pla_codigo,pla_nombre, ing_nombre,  
			@estado_persona estado_a, plm_anio_carrera, plm_ciclo,   
			mai_absorcion absorcion, mai_codmat_del  
			from @ra_mai_mat_inscritas_h_v, ra_mat_materias,   
			ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras,ra_fac_facultades,  
			ra_cil_ciclo, ra_cic_ciclos, ra_ing_ingreso, ra_plm_planes_materias,  
			ra_uni_universidad, ra_reg_regionales  
			where codper = @codigo_persona  
			and alc_codper = codper  
			and pla_codigo = alc_codpla  
			and car_codigo = pla_codcar  
			and fac_codigo = car_codfac  
			and cil_codigo = codcil  
			and cic_codigo = cil_codcic  
			and mat_codigo = mai_codmat  
			and ing_codigo = @tipo_ingreso  
			and plm_codpla = pla_codigo  
			and plm_codmat = mai_codmat  
			and not exists (select 1 from ra_cca_cambio_carrera 
			where cca_codper = @codigo_persona 
			and cca_codmat_eqn is not null 
			and cca_codmat_eqn <> '0'
			and mai_codmat_del = cca_codmat)
			and reg_codigo = cil_codreg  
			and uni_codigo = reg_coduni  
			and substring(@tipo,1,1) in('U','M')  
			)j left outer join @notas on ins_codper = codper  
			and mai_codmat = mai_codmat_del  
			and ins_codcil = cil_codigo  
			union all  
			select 0,0,  
			uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera,   
			fac_nombre,pla_codigo,pla_nombre,  
			reg_nombre,uni,car,eqn_codmat, mat_nombre, eqn_nota,   
			case when eqn_nota >= @nota_minima then 'Aprobada' else 'Reprobada' end estado,  
			0, 0,1,ing_nombre,  
			estado, plm_anio_carrera, plm_ciclo,'',plm_uv  
			from  
			(  
			select distinct uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera,   
			reg_nombre, eqn_nota_tipo/*'Eq. Externa '*/ uni, '' car,   
			eqn_codmat, isnull(plm_alias,mat_nombre) +  
			case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre,   
			(select avg(a.eqn_nota)   
			from ra_eqn_equivalencia_notas a, ra_equ_equivalencia_universidad b  
			where a.eqn_codmat = mat_codigo   
			and a.eqn_codequ = b.equ_codigo  
			and a.eqn_codmat is not null   
			and a.eqn_nota > 0  
			and b.equ_codper = per_codigo) eqn_nota, fac_nombre, pla_codigo,pla_nombre,  
			ing_nombre,  estp_descripcion estado, plm_anio_carrera, plm_ciclo,  
			plm_uv  
			from ra_per_personas,ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,  
			ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras, ra_reg_regionales, ra_uni_universidad,  
			ra_mat_materias, ra_fac_facultades, ra_ing_ingreso, ra_plm_planes_materias, ra_estp_estado_persona 
			where per_codigo = @codigo_persona  
			and equ_codper = per_codigo  
			and eqn_codequ = equ_codigo  
			--                  and equ_tipo = 'E'  
			and alc_codper = per_codigo  
			and pla_codigo = alc_codpla  
			and car_codigo = pla_codcar  
			and fac_codigo = car_codfac  
			and mat_codigo = eqn_codmat  
			and reg_codigo = per_codreg  
			and uni_codigo = reg_coduni  
			and eqn_nota > 0  
			and ing_codigo = per_tipo_ingreso  
			and plm_codpla = pla_codigo  
			and plm_codmat = mat_codigo
			and equ_codist <> 711    
			and per_estado = estp_estado
			) t  
			union all  
			select 0,0,  
			uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera,   
			fac_nombre,pla_codigo,pla_nombre,  
			reg_nombre,uni,car,eqn_codmat, mat_nombre, eqn_nota,   
			case when eqn_nota >= @nota_minima then 'Aprobada' else 'Reprobada' end estado, 
			0, 0,1,ing_nombre,  
			estado, plm_anio_carrera, plm_ciclo,'', plm_uv  
			from  
			(  
			select distinct uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera,   
			reg_nombre, eqn_nota_tipo/*'Eq. Interna '*/ uni, 
			'1' car,   
			eqn_codmat, isnull(plm_alias,mat_nombre) +  
			case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre,   
			(select avg(a.eqn_nota)   
			from ra_eqn_equivalencia_notas a, ra_equ_equivalencia_universidad b  
			where a.eqn_codmat = mat_codigo   
			and a.eqn_codequ = b.equ_codigo  
			and a.eqn_codmat is not null  
			and a.eqn_nota > 0  
			and b.equ_codper = per_codigo) eqn_nota, equ_codigo codequ, fac_nombre, pla_codigo,pla_nombre,  
			ing_nombre, estp_descripcion estado, plm_anio_carrera, plm_ciclo,  
			plm_uv  
			from ra_per_personas,ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,  
			ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras, ra_reg_regionales, ra_uni_universidad,  
			ra_mat_materias, ra_fac_facultades, ra_ing_ingreso, ra_plm_planes_materias,ra_estp_estado_persona 
			where per_codigo = @codigo_persona  
			and equ_codper = per_codigo  
			and eqn_codequ = equ_codigo  
			--                  and equ_tipo = 'I'  
			and alc_codper = per_codigo  
			and pla_codigo = alc_codpla  
			and car_codigo = pla_codcar  
			and fac_codigo = car_codfac  
			and mat_codigo = eqn_codmat  
			and reg_codigo = per_codreg  
			and uni_codigo = reg_coduni  
			and eqn_nota > 0  
			and ing_codigo = per_tipo_ingreso  
			and plm_codpla = pla_codigo  
			and plm_codmat = mat_codigo
			and equ_codist = 711  
			and per_estado = estp_estado
			) t  
			union all  
			select distinct 1,0,  
			uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,b.pla_alias_carrera, fac_nombre,  
			alc_codpla pla_codigo,b.pla_nombre pla_nombre,  
			reg_nombre,'Eq. Interna ', '1',   
			cca_codmat, isnull(plm_alias,mat_nombre) +  
			case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre, nota,   
			'Aprobada' estado,0,  0, 1,  
			ing_nombre, estp_descripcion  estado, plm_anio_carrera, plm_ciclo,'',plm_uv  
			from ra_per_personas,ra_cca_cambio_carrera,ra_alc_alumnos_carrera,ra_pla_planes b,  
			ra_pla_planes a, ra_car_carreras, ra_fac_facultades,  
			ra_reg_regionales, ra_uni_universidad,  
			ra_mat_materias, @notas,ra_ing_ingreso, ra_plm_planes_materias, ra_estp_estado_persona 
			where per_codigo = @codigo_persona  
			and cca_codper = per_codigo  
			and a.pla_codigo = cca_codpla_eqn  
			and car_codigo = a.pla_codcar  
			and fac_codigo = car_codfac  
			and mat_codigo = cca_codmat_eqn  
			and reg_codigo = per_codreg  
			and uni_codigo = reg_coduni  
			and ins_codper = cca_codper  
			and mai_codmat = cca_codmat  
			and cca_codmat_eqn is not null and cca_codmat_eqn <> '0'
			and ing_codigo = per_tipo_ingreso  
			and plm_codpla = a.pla_codigo  
			and plm_codmat = mat_codigo  
			and nota >= @nota_minima   
			and alc_codper = per_codigo  
			and b.pla_codigo = alc_codpla  
			and per_estado = estp_estado
		) x
		where round(nota,1) >= @nota_minima
  
		declare @um float
		select @um = round(sum(isnull(uv,0) * isnull(nota,0)),2) from @uv_total
		update @record set um = @um

		--select cil_codcic, cast(cil_anio as varchar) + ' ' + cic_nombre cil_codigo, uni_nombre, per_carnet, per_nombres_apellidos,
		--car_nombre, pla_alias_carrera, fac_nombre, pla_nombre, reg_nombre, cic_nombre, cil_anio, mat_codigo, mat_nombre, nota,
		--nota_letras, estado, cum_parcil, round((um/@tot_uv),1) cum, materias,
		--case when aprobadas >= materias then materias else aprobadas end aprobadas,
		--reprobadas, matricula, equivalencias, ing_nombre, estado_a, plm_anio_carrera, plm_ciclo, absorcion, uv
		--from @record
		--order by cil_anio, cil_codcic, plm_anio_carrera, plm_ciclo
	end

	--Inicio: Logica para los estudiantes menores al 2000
	declare @anio_ingreso int = 0
	set @anio_ingreso = cast(substring(@campo1, 9, 4) as int)

	if @anio_ingreso <= 2000
	begin
		select
			cil_codcic, cil_codigo, uni_nombre, per_carnet, per_nombres_apellidos, car_nombre, pla_alias_carrera, fac_nombre, pla_nombre, 
			reg_nombre, cic_nombre, cil_anio, mat_codigo, mat_nombre, nota, nota_letras, estado, cum_parcil, cum, materias, aprobadas, 
			reprobadas, matricula, equivalencias, ing_nombre, estado_a, plm_anio_carrera, plm_ciclo, absorcion, uv
			, codcil_real
		from (
			select r.cil_codcic, 
				case when cill_codigo is null then cast(r.cil_anio as varchar) + ' ' + cic_nombre 
				else concat(cill_anio, ' Ciclo ', cill_prefijo, cill_numero) end cil_codigo, 
				uni_nombre, per_carnet, per_nombres_apellidos,
				car_nombre, pla_alias_carrera, fac_nombre, pla_nombre, reg_nombre, 
				case when cill_codigo is null then cic_nombre else concat('Ciclo ', cill_prefijo, cill_numero) end cic_nombre, 
				isnull(cill_anio, r.cil_anio) cil_anio, mat_codigo, mat_nombre, nota, 
				nota_letras, estado, cum_parcil, 
				CASE when @campo2 = 'N' THEN cum else round((um/@tot_uv),1) end cum, 
				materias, 
				case when aprobadas >= materias then materias else aprobadas end aprobadas,
				reprobadas, matricula, equivalencias, ing_nombre, estado_a, plm_anio_carrera, plm_ciclo, absorcion, uv, 
				case when r.cil_codcic = 1 then 2 when r.cil_codcic = 2 then 4 end 'orden_legacy', cill_orden, c.cil_codigo 'codcil_real'
			from @record r
				join ra_cil_ciclo c on concat(c.cil_anio, 'Ciclo 0', c.cil_codcic) = r.cil_codigo/*JOIN con concat*/
				left join ra_mccl_materias_cursadas_ciclo_legacy on mccl_codper = @codigo_persona and mccl_codmat = mat_codigo
					and c.cil_codigo = mccl_codcil

				left join ra_cill_ciclo_legacy on cill_codigo = mccl_codcill
		) t
		order by cil_anio, isnull(cill_orden, orden_legacy), mat_nombre asc--, plm_ciclo

		return
	end
	--Fin: Logica para los estudiantes menores al 2000

	select cil_codcic, cast(cil_anio as varchar) + ' ' + cic_nombre cil_codigo, uni_nombre, per_carnet, per_nombres_apellidos,
		car_nombre, pla_alias_carrera, fac_nombre, pla_nombre, reg_nombre, cic_nombre, cil_anio, mat_codigo, mat_nombre, nota, 
		nota_letras, estado, cum_parcil, 
		CASE when @campo2 = 'N' THEN cum else round((um/@tot_uv),1) end cum, 
		materias, 
		case when aprobadas >= materias then materias else aprobadas end aprobadas,
		reprobadas, matricula, equivalencias, ing_nombre, estado_a, plm_anio_carrera, plm_ciclo, absorcion, uv
	from @record
	order by cil_anio, cil_codcic, plm_anio_carrera, plm_ciclo
	
end
go











USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_certificacion_notas_equ_mod]    Script Date: 4/11/2022 16:25:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- exec dbo.rep_certificacion_notas_equ_mod '25-4979-2022', '1', '', '', '', '', 'N'
ALTER proc [dbo].[rep_certificacion_notas_equ_mod]
	@campo7 varchar(12), --carnet
	@campo8 varchar(12),  --ciudad
	@campo9 varchar(60), --Fecha (dd/mm/yyyy)
	@campo10 varchar(60), --Admon. Academico
	@campo11 varchar(60), --Comprobante
	@campo12 varchar(60), --Elaboro
	@campo13 varchar(1) --Si,No
as
begin  
	declare @campo0 int = cast(@campo8 as int) --ciudad
	declare @campo1 nvarchar(12) = cast(@campo7 as varchar) --carnet
	declare @campo2 nvarchar(1) = cast(@campo13 as varchar) --Si,No
	declare @campo3 nvarchar(60) = cast(@campo9 as varchar) --Fecha (dd/mm/yyyy)
	declare @campo4 nvarchar(60) = cast(@campo10 as varchar) --Admon. Academico
	declare @campo5 nvarchar(60) = cast(@campo11 as varchar) --Comprobante
	declare @campo6 nvarchar(60) = cast(@campo12 as varchar) --Elaboro

	declare @nota_minima real, @codigo_persona int, @materias int, @aprobadas int, @reprobadas int,   
	@equivalencias int, @ciclo_vigente int, @estado_persona varchar(20),  
	@tipo_ingreso int, @apellidos_nombres varchar(100), @tipo varchar(1),  
	@codpla_act int,@cum_repro real, @cum real  , @nmat_plan int, @per_sexo varchar(1)
  
	select @codigo_persona = per_codigo,  
		@estado_persona = estp_descripcion,  
		@tipo_ingreso = per_tipo_ingreso,  
		@apellidos_nombres = per_nombres_apellidos ,  
		@tipo = per_tipo , @per_sexo = per_sexo
	from ra_per_personas 
	inner join  ra_estp_estado_persona on per_estado = estp_estado
	where per_carnet = @campo1  

	SELECT @nmat_plan = pla_n_mat
	FROM ra_per_personas 
		INNER JOIN ra_alc_alumnos_carrera ON ra_per_personas.per_codigo = ra_alc_alumnos_carrera.alc_codper 
		INNER JOIN ra_pla_planes ON ra_alc_alumnos_carrera.alc_codpla = ra_pla_planes.pla_codigo
	where ra_per_personas.per_codigo = @codigo_persona

	declare @record table (  
		cil_codcic int, cil_codigo varchar(80),  
		uni_nombre varchar(250), per_carnet varchar(12),  
		per_nombres_apellidos varchar(200), car_nombre varchar(250),
		pla_alias_carrera varchar(150), fac_nombre varchar(100),  
		pla_nombre varchar(100), reg_nombre varchar(80),  
		cic_nombre varchar(50), cil_anio int,  
		mat_codigo varchar(10), mat_nombre varchar(200),  
		nota real, nota_letras varchar(100),  
		estado varchar(20), cum_parcil real,  
		cum real, materias int,  
		aprobadas int, reprobadas int,  
		matricula int, equivalencias int,  
		ing_nombre varchar(50), estado_a varchar(20),  
		plm_anio_carrera int, plm_ciclo int,   
		absorcion varchar(2), uv int ,
		uni_nota_minima_letras nvarchar(150), uni_nota_minima real,
		matriculado nvarchar(50), total_aprobadas_letras  nvarchar(150),
		total_reprobadas_letras nvarchar(150), cum_n_letras nvarchar(150),
		fecha nvarchar(300), GloPa nvarchar(30), codcil_real int
	)  
  
	--create table #ra_mai_mat_inscritas_h_v
	declare @ra_mai_mat_inscritas_h_v table (  
		codper int, codcil int,  
		mai_codigo int, mai_codins int,  
		mai_codmat varchar(10) collate Modern_Spanish_CI_AS,  
		mai_absorcion varchar(1), mai_financiada varchar(1),  
		mai_estado varchar(1), mai_codhor int,  
		mai_matricula int, mai_acuerdo varchar(20),  
		mai_fecha_acuerdo datetime,  
		mai_codmat_del varchar(10) collate Modern_Spanish_CI_AS,  
		fechacreacion datetime, mai_codpla int,  
		mai_uv int, mai_tipo varchar(1),  
		mai_codhpl int  
	)   

	declare @notas table(  
		ins_codreg int, ins_codigo int,  
		ins_codcil int, ins_codper int,  
		mai_codigo int,  
		mai_codmat varchar(10) collate Modern_Spanish_CI_AS,  
		mai_codhor int, mai_matricula int,  
		estado varchar(1), mai_codpla int,  
		absorcion_notas varchar(1),  
		uv int, nota float, mai_codhpl int  
	)   
  
	select @nota_minima = uni_nota_minima  
	from ra_reg_regionales, ra_uni_universidad  
	where reg_codigo = @campo0  
	and uni_codigo = reg_coduni

	declare @ins table (codins int)
	insert into @ins (codins)
	select max(ins_codigo) codins 
	from ra_ins_inscripcion  
		join ra_cil_ciclo on cil_codigo = ins_codcil  
	where ins_codper = @codigo_persona  

	select @codpla_act = alc_codpla  
	from ra_alc_alumnos_carrera   
	where alc_codper = @codigo_persona  


	if @tipo = 'U'
	begin
		--insert into #ra_mai_mat_inscritas_h_v  
		insert into @ra_mai_mat_inscritas_h_v  
		select *  
		from ra_mai_mat_inscritas_h_v  
		where codper = @codigo_persona  
		and mai_codpla = @codpla_act  
		and codcil not in --(@ciclo_vigente) --, 114) --CAMBIO DE RENY
		(select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
	end
	else
    begin
		--insert into #ra_mai_mat_inscritas_h_v  
		insert into @ra_mai_mat_inscritas_h_v  
		select *  
		from ra_mai_mat_inscritas_h_v  
		where codper = @codigo_persona  
		and mai_codpla = @codpla_act  
    end

	insert into @notas
	select * from notas  
	where ins_codper = @codigo_persona  
	and mai_codpla = @codpla_act
	select @materias = count(1)   
	from ra_alc_alumnos_carrera, ra_plm_planes_materias  
	where alc_codper = @codigo_persona  
	and plm_codpla = alc_codpla  

	select @aprobadas = sum(a)   
	from (
		select count(1) a   
		from @notas b,ra_alc_alumnos_carrera, ra_plm_planes_materias  
		where b.ins_codper = @codigo_persona  
		and round(b.nota,1) >= @nota_minima  
		and alc_codper = b.ins_codper  
		and plm_codpla = alc_codpla  
		and plm_codmat = b.mai_codmat
		and b.ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
			union all  
		select count(distinct eqn_codmat)   
		from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,  
		ra_alc_alumnos_carrera, ra_plm_planes_materias  
		where equ_codigo = eqn_codequ  
		and equ_codper = @codigo_persona 
		and eqn_nota >= @nota_minima
		and alc_codper = equ_codper  
		and plm_codpla = alc_codpla  
		and plm_codmat = eqn_codmat  
	) t   

	select @reprobadas = sum(a)
	from(
		select count(1) a 
		from @notas b,ra_alc_alumnos_carrera, ra_plm_planes_materias  
		where b.ins_codper = @codigo_persona  
		and b.ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
		and b.estado = 'I'  
		and round(b.nota,1) < @nota_minima  
		and alc_codper = b.ins_codper  
		and plm_codpla = alc_codpla  
		and plm_codmat = b.mai_codmat 
			union all  
		select count(distinct eqn_codmat)   
		from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,  
		ra_alc_alumnos_carrera, ra_plm_planes_materias  
		where equ_codigo = eqn_codequ  
		and equ_codper = @codigo_persona 
		and eqn_nota > 0 
		and eqn_nota < @nota_minima
		and alc_codper = equ_codper  
		and plm_codpla = alc_codpla  
		and plm_codmat = eqn_codmat 
	)t
	 
	if @campo2 = 'S' set @reprobadas = 0

	select @equivalencias = count(distinct eqn_codmat)   
	from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,   
	ra_alc_alumnos_carrera, ra_plm_planes_materias  
	where equ_codigo = eqn_codequ  
	and equ_codper = @codigo_persona and eqn_nota > 0   
	and equ_tipo = 'E' and alc_codper = equ_codper  
	and plm_codpla = alc_codpla and plm_codmat = eqn_codmat  

	select @cum_repro = dbo.nota_aproximacion(dbo.cum_repro(@codigo_persona))

	select @cum = dbo.nota_aproximacion(dbo.cum(@codigo_persona))

	-- exec rep_certificacion_notas_equ_mod '29-1870-2020','1','','','','','S'
	if @campo2 = 'N'  
	begin  
		insert into @record  
		select cil_codcic, cast(cil_anio as varchar) + cic_nombre cil_codigo,  
		uni_nombre, per_carnet, per_nombres_apellidos,   
		car_nombre,x.pla_alias_carrera, fac_nombre, pla_nombre,reg_nombre,   
		case when  cic_nombre = 'Eq. Externa ' or cic_nombre = 'Eq. Interna ' or cic_nombre = 'Suficiencia' then cic_nombre else
		(substring(cic_nombre,7,8) + ' - ' + cast(cil_anio as nvarchar)) end cic_nombre,
		cil_anio,  
		mat_codigo, mat_nombre,   
		round(nota,1) nota,   
		upper(dbo.NotaALetras(round(nota,1))),  
		estado estado, round(cum_ciclo,1) cum_parcial,   
		@cum_repro cum,  
		@materias,  
		@aprobadas,  
		@reprobadas,   
		matricula,  
		@equivalencias,   
		ing_nombre,   
		estado_a, plm_anio_carrera, plm_ciclo, absorcion, uv,
		upper(dbo.NotaALetras(@nota_minima)) uni_nota_minima_letras,
		@nota_minima uni_nota_minima,
		case when per_sexo = 'M' then ' matriculado '  else ' matriculada ' end matriculado,
		dbo.MateriasALetras(@aprobadas) total_aprobadas_letras,
		dbo.MateriasALetras(@reprobadas) total_reprobadas_letras,
		dbo.NotaALetras(round(@cum_repro,1)) cum_n_letras,
		dbo.fn_crufl_FechaALetras(convert(datetime,getdate(),103),1,1) fecha,
		case when @aprobadas >= @nmat_plan then 'Global' else 'Parcial' end GloPa, codcil
		from (  
			select cil_codcic,cil_codigo codcil,uni_nombre, codper,per_carnet,   
			per_nombres_apellidos,   
			car_nombre,pla_alias_carrera, fac_nombre,pla_codigo,pla_nombre,  
			reg_nombre,   
			cic_nombre, cil_anio,   
			mat_codigo, mat_nombre, isnull(nota,0) nota,      
			estado =          
		   CASE 
         
			 WHEN (mai_estado)= 'R' THEN 'Retirada'
			 WHEN isnull(round(nota,1),0) <  @nota_minima THEN 'Reprobada' 
			 ELSE 'Aprobada'

		   END,

			dbo.cum_ciclo(cil_codigo,codper) cum_ciclo,0 cum,  
			matricula,ing_nombre, estado_a, plm_anio_carrera, plm_ciclo, absorcion, uv,
			----
			per_sexo
			from  
			(  
				select cil_codcic,cil_codigo,uni_nombre, codper codper, @campo1 per_carnet,   
				@apellidos_nombres per_nombres_apellidos,   
				car_nombre_legal car_nombre,pla_alias_carrera, reg_nombre, mat_codigo,  
				isnull(plm_alias,mat_nombre) +  
				case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre,   
				cic_nombre, cil_anio, mai_estado,mai_codins codins,  
				@campo0 codreg, mai_matricula matricula, fac_nombre, pla_codigo,pla_nombre, ing_nombre,  
				@estado_persona estado_a, plm_anio_carrera, plm_ciclo,   
				mai_absorcion absorcion, mai_codmat_del, @per_sexo as per_sexo
				from @ra_mai_mat_inscritas_h_v, ra_mat_materias,   
				ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras,ra_fac_facultades,  
				ra_cil_ciclo, ra_cic_ciclos, ra_ing_ingreso, ra_plm_planes_materias,  
				ra_uni_universidad, ra_reg_regionales  
				where codper = @codigo_persona  
				and alc_codper = codper  
				and pla_codigo = alc_codpla  
				and car_codigo = pla_codcar  
				and fac_codigo = car_codfac  
				and cil_codigo = codcil  
				and cic_codigo = cil_codcic  
				and mat_codigo = mai_codmat  
				and ing_codigo = @tipo_ingreso  
				and plm_codpla = pla_codigo  
				and plm_codmat = mai_codmat  
				and not exists (select 1 from ra_cca_cambio_carrera 
								where cca_codper = @codigo_persona 
								and cca_codmat_eqn is not null 
								and cca_codmat_eqn <> '0'
								and mai_codmat_del = cca_codmat)   
				and reg_codigo = cil_codreg  
				and uni_codigo = reg_coduni  
				and substring(@tipo,1,1) in('U','M')  
			)j left outer join @notas on ins_codper = codper  
			and mai_codmat = mai_codmat_del  
			and ins_codcil = cil_codigo  
		
			union all 
			
			select 0,0,  
			uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera,   
			fac_nombre,pla_codigo,pla_nombre,  
			reg_nombre,uni,car,eqn_codmat, mat_nombre, eqn_nota,   
			case when eqn_nota >= @nota_minima then 'Aprobada' else 'Reprobada' end estado,  
			0, 0,1,ing_nombre,  
			estado, plm_anio_carrera, plm_ciclo,'',plm_uv  , per_sexo
			from  
			(  
				select distinct uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre_legal car_nombre,pla_alias_carrera,   
				reg_nombre, eqn_nota_tipo/*'Eq. Externa '*/ uni, '' car,   
				eqn_codmat, isnull(plm_alias,mat_nombre) +  
				case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre,   
				(select avg(a.eqn_nota)   
				from ra_eqn_equivalencia_notas a, ra_equ_equivalencia_universidad b  
				where a.eqn_codmat = mat_codigo   
				and a.eqn_codequ = b.equ_codigo  
				and a.eqn_codmat is not null   
				and a.eqn_nota > 0  
				and b.equ_codper = per_codigo) eqn_nota, fac_nombre, pla_codigo,pla_nombre,  
				ing_nombre,  estp_descripcion estado, plm_anio_carrera, plm_ciclo,  
				plm_uv  , per_sexo
				from ra_per_personas,ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,  
				ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras, ra_reg_regionales, ra_uni_universidad,  
				ra_mat_materias, ra_fac_facultades, ra_ing_ingreso, ra_plm_planes_materias,ra_estp_estado_persona  
				where per_codigo = @codigo_persona  
				and equ_codper = per_codigo  
				and eqn_codequ = equ_codigo
				and alc_codper = per_codigo  
				and pla_codigo = alc_codpla  
				and car_codigo = pla_codcar  
				and fac_codigo = car_codfac  
				and mat_codigo = eqn_codmat  
				and reg_codigo = per_codreg  
				and uni_codigo = reg_coduni  
				and eqn_nota > 0  
				and ing_codigo = per_tipo_ingreso  
				and plm_codpla = pla_codigo  
				and plm_codmat = mat_codigo  
				and equ_codist <> 711
				and per_estado = estp_estado
			) t  
			union all  
			select 0,0,  
			uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera,   
			fac_nombre,pla_codigo,pla_nombre,  
			reg_nombre,uni,car,eqn_codmat, mat_nombre, eqn_nota,   
			case when eqn_nota >= @nota_minima then 'Aprobada' else 'Reprobada' end estado, 
			0, 0,1,ing_nombre,  
			estado, plm_anio_carrera, plm_ciclo,'', plm_uv  ,
			-----
		
			per_sexo
			from (  
				select distinct uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre_legal car_nombre,pla_alias_carrera,   
				reg_nombre, eqn_nota_tipo/*'Eq. Interna '*/ uni, '1' car,   
				eqn_codmat, isnull(plm_alias,mat_nombre) +  
				case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre,   
				(select avg(a.eqn_nota)   
				from ra_eqn_equivalencia_notas a, ra_equ_equivalencia_universidad b  
				where a.eqn_codmat = mat_codigo   
				and a.eqn_codequ = b.equ_codigo  
				and a.eqn_codmat is not null  
				and a.eqn_nota > 0  
				and b.equ_codper = per_codigo) eqn_nota, equ_codigo codequ, fac_nombre, pla_codigo,pla_nombre,  
				ing_nombre,estp_descripcion estado, plm_anio_carrera, plm_ciclo,  
				plm_uv  , per_sexo
				from ra_per_personas,ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,  
				ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras, ra_reg_regionales, ra_uni_universidad,  
				ra_mat_materias, ra_fac_facultades, ra_ing_ingreso, ra_plm_planes_materias,ra_estp_estado_persona
	
				where per_codigo = @codigo_persona  
				and equ_codper = per_codigo  
				and eqn_codequ = equ_codigo  
	--			and equ_tipo = 'I'  
				and alc_codper = per_codigo  
				and pla_codigo = alc_codpla  
				and car_codigo = pla_codcar  
				and fac_codigo = car_codfac  
				and mat_codigo = eqn_codmat  
				and reg_codigo = per_codreg  
				and uni_codigo = reg_coduni  
				and eqn_nota > 0  
				and ing_codigo = per_tipo_ingreso  
				and plm_codpla = pla_codigo  
				and plm_codmat = mat_codigo 
				and equ_codist = 711 
				and per_estado = estp_estado
			) t  
			union all  
			select distinct 1,0,  
			uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre_legal car_nombre,b.pla_alias_carrera, fac_nombre,  
			alc_codpla pla_codigo,b.pla_nombre pla_nombre,  
			reg_nombre,'Eq. Interna ', '1',   
			cca_codmat, isnull(plm_alias,mat_nombre) +  
			case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre, /*cast(*/nota/* as varchar)*/,   
			'Aprobada' estado,0 , 0, 1,  
			ing_nombre,  estp_descripcion estado, plm_anio_carrera, plm_ciclo,'',plm_uv  , per_sexo
			from ra_per_personas,ra_cca_cambio_carrera,ra_alc_alumnos_carrera,ra_pla_planes b,  
			ra_pla_planes a, ra_car_carreras, ra_fac_facultades,  
			ra_reg_regionales, ra_uni_universidad,  
			ra_mat_materias, @notas,ra_ing_ingreso, ra_plm_planes_materias, ra_estp_estado_persona
			where per_codigo = @codigo_persona  
			and cca_codper = per_codigo  
			and a.pla_codigo = cca_codpla_eqn  
			and car_codigo = a.pla_codcar  
			and fac_codigo = car_codfac  
			and mat_codigo = cca_codmat_eqn  
			and reg_codigo = per_codreg  
			and uni_codigo = reg_coduni  
			and ins_codper = cca_codper  
			and mai_codmat = cca_codmat  
			and cca_codmat_eqn is not null and cca_codmat_eqn <> '0'  
			and ing_codigo = per_tipo_ingreso  
			and plm_codpla = a.pla_codigo  
			and plm_codmat = mat_codigo  
			and nota >= @nota_minima   
			and alc_codper = per_codigo  
			and b.pla_codigo = alc_codpla 
			and per_estado = estp_estado 
		
		) x  
	end  
	else   
	begin
		insert into @record  
		select cil_codcic, cast(cil_anio as varchar) + cic_nombre cil_codigo,  
		uni_nombre, per_carnet, per_nombres_apellidos,   
		car_nombre,x.pla_alias_carrera, fac_nombre, pla_nombre,reg_nombre,  
		case when  cic_nombre = 'Eq. Externa ' or cic_nombre = 'Eq. Interna ' or cic_nombre = 'Suficiencia' then cic_nombre else
		(substring(cic_nombre,7,8) + ' - ' + cast(cil_anio as nvarchar)) end cic_nombre, cil_anio,  
		mat_codigo, mat_nombre,   
		round(nota,1) nota,   
		upper(dbo.NotaALetras(round(nota,1))),  
		estado estado, round(cum_ciclo,1) cum_parcial,   
		@cum cum,  
		@materias,  
		@aprobadas,  
		@reprobadas,   
		matricula,  
		@equivalencias,   
		ing_nombre,   
		estado_a, plm_anio_carrera, plm_ciclo, absorcion, uv,
		upper(dbo.NotaALetras(@nota_minima)) uni_nota_minima_letras,
		@nota_minima uni_nota_minima,
		case when per_sexo = 'M' then ' matriculado '  else ' matriculada ' end matriculado,
		dbo.MateriasALetras(@aprobadas) total_aprobadas_letras,
		dbo.MateriasALetras(@reprobadas) total_reprobadas_letras,
		dbo.NotaALetras(round(@cum,1)) cum_n_letras,
		dbo.fn_crufl_FechaALetras(convert(datetime,getdate(),103),1,1) fecha,
		case when @aprobadas >= @nmat_plan then 'Global' else 'Parcial' end GloPa
		, codcil
		from (
			select cil_codcic,cil_codigo codcil,uni_nombre, codper,per_carnet,   
			per_nombres_apellidos,   
			car_nombre,pla_alias_carrera, fac_nombre,pla_codigo,pla_nombre,  
			reg_nombre,   
			cic_nombre, cil_anio,   
			mat_codigo, mat_nombre, isnull(nota,0) nota,   
			estado =
			CASE 
				 WHEN (mai_estado)= 'R' THEN 'Retirada'
				 WHEN isnull(round(nota,1),0) <  @nota_minima THEN 'Reprobada' 
				 ELSE 'Aprobada'
			END,
			dbo.cum_ciclo(cil_codigo,codper) cum_ciclo,0 cum,  
			matricula,ing_nombre, estado_a, plm_anio_carrera, plm_ciclo, absorcion, uv  , per_sexo
			from (  
				select cil_codcic,cil_codigo,uni_nombre, codper codper, @campo1 per_carnet,   
				@apellidos_nombres per_nombres_apellidos,   
				car_nombre_legal car_nombre,pla_alias_carrera, reg_nombre, mat_codigo,  
				isnull(plm_alias,mat_nombre) +  
				case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre,   
				cic_nombre, cil_anio, mai_estado,mai_codins codins,  
				@campo0 codreg, mai_matricula matricula, fac_nombre, pla_codigo,pla_nombre, ing_nombre,  
				@estado_persona estado_a, plm_anio_carrera, plm_ciclo,   
				mai_absorcion absorcion, mai_codmat_del  , per_sexo
				from @ra_mai_mat_inscritas_h_v, ra_mat_materias,   
				ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras,ra_fac_facultades,  
				ra_cil_ciclo, ra_cic_ciclos, ra_ing_ingreso, ra_plm_planes_materias,  
				ra_uni_universidad, ra_reg_regionales, ra_per_personas
				where codper = @codigo_persona
				and per_codigo = @codigo_persona  
				and alc_codper = codper  
				and pla_codigo = alc_codpla  
				and car_codigo = pla_codcar  
				and fac_codigo = car_codfac  
				and cil_codigo = codcil  
				and cic_codigo = cil_codcic  
				and mat_codigo = mai_codmat  
				and ing_codigo = @tipo_ingreso  
				and plm_codpla = pla_codigo  
				and plm_codmat = mai_codmat  
				and not exists (select 1 from ra_cca_cambio_carrera 
								where cca_codper = @codigo_persona 
								and cca_codmat_eqn is not null 
								and cca_codmat_eqn <> '0'
								and mai_codmat_del = cca_codmat)
				and reg_codigo = cil_codreg  
				and uni_codigo = reg_coduni  
				and substring(@tipo,1,1) in('U','M')  
			)j left outer join @notas on ins_codper = codper  
			and mai_codmat = mai_codmat_del  
			and ins_codcil = cil_codigo  
			union all  
			select 0,0,  
			uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera,   
			fac_nombre,pla_codigo,pla_nombre,  
			reg_nombre,uni,car,eqn_codmat, mat_nombre, eqn_nota,   
			case when eqn_nota >= @nota_minima then 'Aprobada' else 'Reprobada' end estado,  
			0, 0,1,ing_nombre,  
			estado, plm_anio_carrera, plm_ciclo,'',plm_uv  , per_sexo
			from  
			(  
				select distinct uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre_legal car_nombre,pla_alias_carrera,   
				reg_nombre, eqn_nota_tipo/*'Eq. Externa '*/ uni, '' car,   
				eqn_codmat, isnull(plm_alias,mat_nombre) +  
				case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre,   
				(select avg(a.eqn_nota)   
				from ra_eqn_equivalencia_notas a, ra_equ_equivalencia_universidad b  
				where a.eqn_codmat = mat_codigo   
				and a.eqn_codequ = b.equ_codigo  
				and a.eqn_codmat is not null   
				and a.eqn_nota > 0  
				and b.equ_codper = per_codigo) eqn_nota, fac_nombre, pla_codigo,pla_nombre,  
				ing_nombre,  estp_descripcion estado, plm_anio_carrera, plm_ciclo,  
				plm_uv  , per_sexo
				from ra_per_personas,ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,  
				ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras, ra_reg_regionales, ra_uni_universidad,  
				ra_mat_materias, ra_fac_facultades, ra_ing_ingreso, ra_plm_planes_materias, ra_estp_estado_persona 
				where per_codigo = @codigo_persona  
				and equ_codper = per_codigo  
				and eqn_codequ = equ_codigo  
	--			and equ_tipo = 'E'  
				and alc_codper = per_codigo  
				and pla_codigo = alc_codpla  
				and car_codigo = pla_codcar  
				and fac_codigo = car_codfac  
				and mat_codigo = eqn_codmat  
				and reg_codigo = per_codreg  
				and uni_codigo = reg_coduni  
				and eqn_nota > 0  
				and ing_codigo = per_tipo_ingreso  
				and plm_codpla = pla_codigo  
				and plm_codmat = mat_codigo
				and equ_codist <> 711    
				and per_estado = estp_estado
			) t  
			union all  
			select 0,0,  
			uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera,   
			fac_nombre,pla_codigo,pla_nombre,  
			reg_nombre,uni,car,eqn_codmat, mat_nombre, eqn_nota,   
			case when eqn_nota >= @nota_minima then 'Aprobada' else 'Reprobada' end estado, 
			0, 0,1,ing_nombre,  
			estado, plm_anio_carrera, plm_ciclo,'', plm_uv  , per_sexo
			from  
			(  
				select distinct uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre_legal car_nombre,pla_alias_carrera,   
				reg_nombre, eqn_nota_tipo/*'Eq. Interna '*/ uni, '1' car,   
				eqn_codmat, isnull(plm_alias,mat_nombre) +  
				case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre,   
				(select avg(a.eqn_nota)   
				from ra_eqn_equivalencia_notas a, ra_equ_equivalencia_universidad b  
				where a.eqn_codmat = mat_codigo   
				and a.eqn_codequ = b.equ_codigo  
				and a.eqn_codmat is not null  
				and a.eqn_nota > 0  
				and b.equ_codper = per_codigo) eqn_nota, equ_codigo codequ, fac_nombre, pla_codigo,pla_nombre,  
				ing_nombre, estp_descripcion estado, plm_anio_carrera, plm_ciclo,  
				plm_uv  , per_sexo
				from ra_per_personas,ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,  
				ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras, ra_reg_regionales, ra_uni_universidad,  
				ra_mat_materias, ra_fac_facultades, ra_ing_ingreso, ra_plm_planes_materias,ra_estp_estado_persona 
				where per_codigo = @codigo_persona  
				and equ_codper = per_codigo  
				and eqn_codequ = equ_codigo  
	--			and equ_tipo = 'I'  
				and alc_codper = per_codigo  
				and pla_codigo = alc_codpla  
				and car_codigo = pla_codcar  
				and fac_codigo = car_codfac  
				and mat_codigo = eqn_codmat  
				and reg_codigo = per_codreg  
				and uni_codigo = reg_coduni  
				and eqn_nota > 0  
				and ing_codigo = per_tipo_ingreso  
				and plm_codpla = pla_codigo  
				and plm_codmat = mat_codigo
				and equ_codist = 711  
				and per_estado = estp_estado
			) t  
			union all  
			select distinct 1,0,  
			uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre_legal car_nombre,b.pla_alias_carrera, fac_nombre,  
			alc_codpla pla_codigo,b.pla_nombre pla_nombre,  
			reg_nombre,'Eq. Interna ', '1',   
			cca_codmat, isnull(plm_alias,mat_nombre) +  
			case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre, nota,   
			'Aprobada' estado,0 , 0, 1,  
			ing_nombre, estp_descripcion  estado, plm_anio_carrera, plm_ciclo,'',plm_uv , per_sexo 
			from ra_per_personas,ra_cca_cambio_carrera,ra_alc_alumnos_carrera,ra_pla_planes b,  
			ra_pla_planes a, ra_car_carreras, ra_fac_facultades,  
			ra_reg_regionales, ra_uni_universidad,  
			ra_mat_materias, @notas,ra_ing_ingreso, ra_plm_planes_materias, ra_estp_estado_persona 
			where per_codigo = @codigo_persona  
			and cca_codper = per_codigo  
			and a.pla_codigo = cca_codpla_eqn  
			and car_codigo = a.pla_codcar  
			and fac_codigo = car_codfac  
			and mat_codigo = cca_codmat_eqn  
			and reg_codigo = per_codreg  
			and uni_codigo = reg_coduni  
			and ins_codper = cca_codper  
			and mai_codmat = cca_codmat  
			and cca_codmat_eqn is not null and cca_codmat_eqn <> '0'
			and ing_codigo = per_tipo_ingreso  
			and plm_codpla = a.pla_codigo  
			and plm_codmat = mat_codigo  
			and nota >= @nota_minima   
			and alc_codper = per_codigo  
			and b.pla_codigo = alc_codpla  
			and per_estado = estp_estado
		) x  
		where round(nota,1) >= @nota_minima  
	end

	--update @record set car_nombre = pla_alias_carrera where per_carnet = @campo7



	--Inicio: Logica para los estudiantes menores al 2000
	declare @anio_ingreso int = 0
	set @anio_ingreso = cast(substring(@campo1, 9, 4) as int)

	if @anio_ingreso <= 2000
	begin
		declare @record_legacy table (  
			cil_codcic int, cil_codigo varchar(80),  
			uni_nombre varchar(250), per_carnet varchar(12),  
			per_nombres_apellidos varchar(200), car_nombre varchar(250),
			pla_alias_carrera varchar(150), fac_nombre varchar(100),  
			pla_nombre varchar(100), reg_nombre varchar(80),  
			cic_nombre varchar(50), cil_anio int,  
			mat_codigo varchar(10), mat_nombre varchar(200),  
			nota real, nota_letras varchar(100),  
			estado varchar(20), cum_parcil real, cum real, materias int,  
			aprobadas int, reprobadas int, matricula int, equivalencias int,  
			ing_nombre varchar(50), estado_a varchar(20),  
			plm_anio_carrera int, plm_ciclo int,   
			absorcion varchar(2), uv int, um float, codcil_real int
		)
		insert into @record_legacy (
			cil_codcic, cil_codigo, uni_nombre, per_carnet, per_nombres_apellidos, car_nombre, pla_alias_carrera, fac_nombre, pla_nombre, 
			reg_nombre, cic_nombre, cil_anio, mat_codigo, mat_nombre, nota, nota_letras, estado, cum_parcil, cum, materias, aprobadas, 
			reprobadas, matricula, equivalencias, ing_nombre, estado_a, plm_anio_carrera, plm_ciclo, absorcion, uv, codcil_real
		)
		exec dbo.rep_record_academico_limpio 1, @campo7, @campo13

		select 
			rl.cil_codcic, rl.cil_codigo, r.uni_nombre, r.per_carnet, r.per_nombres_apellidos, r.car_nombre, r.pla_alias_carrera, r.fac_nombre, 
			r.pla_nombre, r.reg_nombre, concat(replace(rl.cic_nombre, 'Ciclo ', ''), ' - ', rl.cil_anio) cic_nombre, r.cil_anio, r.mat_codigo, r.mat_nombre, r.nota, r.nota_letras, 
			r.estado, r.cum_parcil, r.cum, r.materias, r.aprobadas, r.reprobadas, r.matricula, r.equivalencias, r.ing_nombre, 
			r.estado_a, r.plm_anio_carrera, r.plm_ciclo, r.absorcion, r.uv, r.uni_nota_minima_letras, r.uni_nota_minima, r.matriculado, 
			r.total_aprobadas_letras, r.total_reprobadas_letras, r.cum_n_letras, r.fecha, r.GloPa, @campo5 confronto, @campo6 elaboro
		from @record_legacy rl
			inner join @record r on rl.mat_codigo = r.mat_codigo and rl.codcil_real = r.codcil_real 
		
		return
	end
	--Fin: Logica para los estudiantes menores al 2000
	

	select *,@campo5 confronto, @campo6 elaboro from @record  
	order by cil_anio, cil_codcic, plm_anio_carrera, plm_ciclo

end















USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_certificacion_notas]    Script Date: 4/11/2022 16:31:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- exec dbo.rep_certificacion_notas '25-4979-2022', '', '', '', '', '', 'S'

ALTER proc [dbo].[rep_certificacion_notas]
	@campo0 varchar(12),
	@campo1 varchar(25),
	@campo2 varchar(10),
	@campo3 varchar(60),
	@campo4 varchar(60),
	@campo5 varchar(60),
	@campo6 varchar(1)
as
BEGIN
	declare @codper int, @aprobadas int, @reprobadas int, @tipo_alumno nvarchar(5),
	@equivalencias int, @nota_minima real, @unidades int, @uv_plan int, @codpla_act int, @cum_n real, @cum real,@car_nombre varchar(100), @incripciones int, @cil_codigo int, @nmat_plan int

	if (select cic_orden from ra_cic_ciclos join ra_cil_ciclo on cil_codcic = cic_codigo where cil_vigente = 'S') = 3
	BEGIN
		if (select count(1) from ra_ins_inscripcion join ra_cil_ciclo on cil_codigo = ins_codcil join ra_cic_ciclos on cic_codigo = cil_codcic join ra_per_personas on per_codigo = ins_codper where per_carnet = @campo0 and cic_orden = 2 and year(ins_fecha)=year(getdate())) >= 1
		BEGIN
			select @cil_codigo = cil_codigo from ra_ins_inscripcion join ra_cil_ciclo on cil_codigo = ins_codcil join ra_cic_ciclos on cic_codigo = cil_codcic join ra_per_personas on per_codigo = ins_codper where per_carnet = @campo0 and cic_orden = 2 and year(ins_fecha)=year(getdate())
		END
		else
		BEGIN
			set @cil_codigo = 0
		END
	END
	ELSE
	BEGIN
		set @cil_codigo = 0	
	END

	select @codper = per_codigo,
		@codpla_act = alc_codpla
	from ra_per_personas
	join ra_alc_alumnos_carrera on alc_codper = per_codigo
	where per_carnet = @campo0

	declare @alias_carrera nvarchar(300)
	select @alias_carrera = replace(pla_alias_carrera,'NO PRESENCIAL', '')
	from ra_pla_planes where pla_codigo = @codpla_act

	--SELECT @alias_carrera = car_nombre_legal FROM ra_alc_alumnos_carrera 
	--inner join ra_pla_planes on alc_codpla = pla_codigo
	--inner join ra_car_carreras on pla_codcar = car_codigo
	--where alc_codper = @codper

	SELECT    @nmat_plan = pla_n_mat
	FROM         ra_per_personas INNER JOIN
						  ra_alc_alumnos_carrera ON ra_per_personas.per_codigo = ra_alc_alumnos_carrera.alc_codper INNER JOIN
						  ra_pla_planes ON ra_alc_alumnos_carrera.alc_codpla = ra_pla_planes.pla_codigo
	where ra_per_personas.per_codigo = @codper

	print '@nmat_plan : ' 
	print cast(@nmat_plan as nvarchar(10))

	select @cum_n = dbo.cum_repro(@codper)
	select @cum = dbo.cum(@codper)

	select @tipo_alumno = per_tipo 
	from ra_per_personas where per_codigo = @codper

	select @nota_minima = iif(@tipo_alumno = 'U',uni_nota_minima, uni_pnota_minima)
	from ra_reg_regionales, ra_uni_universidad
	where reg_codigo = 1
	and uni_codigo = reg_coduni

	--create table #ra_mai_mat_inscritas_h_v(
	declare @ra_mai_mat_inscritas_h_v table(
		codper int,
		codcil int,
		mai_codigo int,
		mai_codins int,
		mai_codmat varchar(10) collate Modern_Spanish_CI_AS,
		mai_absorcion varchar(1),
		mai_financiada varchar(1),
		mai_estado varchar(1),
		mai_codhor int,
		mai_matricula int,
		mai_acuerdo varchar(20),
		mai_fecha_acuerdo datetime,
		mai_codmat_del varchar(10) collate Modern_Spanish_CI_AS,
		fechacreacion datetime, 
		mai_codpla int,
		mai_uv int,
		mai_tipo varchar(1),
		mai_codhpl int
	) 

	--create table #notas(
	declare @notas table(
		ins_codreg int,
		ins_codigo int,
		ins_codcil int,
		ins_codper int,
		mai_codigo int,
		mai_codmat varchar(10) collate Modern_Spanish_CI_AS,
		mai_codhor int,
		mai_matricula int,
		estado varchar(1),
		mai_codpla int,
		absorcion_notas varchar(1),
		uv int,
		nota float, mai_codhpl int
	) 


	insert into @ra_mai_mat_inscritas_h_v (codper, codcil, mai_codigo, mai_codins, mai_codmat, mai_absorcion, mai_financiada, mai_estado, mai_codhor, mai_matricula,
		mai_acuerdo, mai_fecha_acuerdo, mai_codmat_del, fechacreacion, mai_codpla, mai_uv, mai_tipo, mai_codhpl)
	select codper, codcil, mai_codigo, mai_codins, mai_codmat, mai_absorcion, mai_financiada, mai_estado, mai_codhor, mai_matricula,
		mai_acuerdo, mai_fecha_acuerdo, mai_codmat_del, fecha_creacion, mai_codpla, mai_uv, mai_tipo, mai_codhpl
	from ra_mai_mat_inscritas_h_v
	where codper = @codper and mai_codpla = @codpla_act

	insert into @notas (ins_codreg, ins_codigo, ins_codcil, ins_codper, mai_codigo, mai_codmat, mai_codhor, mai_matricula, estado, mai_codpla, 
		absorcion_notas, uv, nota)
	select ins_codreg, ins_codigo, ins_codcil, ins_codper, mai_codigo, mai_codmat, mai_codhor, mai_matricula, estado, mai_codpla, 
		absorcion_notas, uv, nota 
	from notas
	where ins_codper = @codper and mai_codpla = @codpla_act

					
	select @aprobadas = sum(a) 
	from 
	(
		select count(distinct b.mai_codmat) a 
		from @notas b,ra_alc_alumnos_carrera, ra_plm_planes_materias
		where b.ins_codper = @codper
		and round(b.nota,1) >= @nota_minima
		and alc_codper = b.ins_codper
		and plm_codpla = alc_codpla
		and plm_codmat = b.mai_codmat
		and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S'  union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
		and not exists (select 1 from ra_equ_equivalencia_universidad
						join ra_eqn_equivalencia_notas on eqn_codequ = equ_codigo
						where equ_codper = alc_codper
						and eqn_codmat = plm_codmat
						and eqn_nota > 0)
		union all
		select count(distinct eqn_codmat) 
		from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,
		ra_alc_alumnos_carrera, ra_plm_planes_materias
		where equ_codigo = eqn_codequ
		and equ_codper = @codper
		and eqn_nota > 0
	--					and equ_tipo = 'E'
		and alc_codper = equ_codper
		and plm_codpla = alc_codpla
		and plm_codmat = eqn_codmat
	) t 

	select @reprobadas = count(1)
	from @notas b,ra_alc_alumnos_carrera, ra_plm_planes_materias
	where b.ins_codper = @codper
	and b.ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S'  union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
	and b.estado = 'I'
	and round(b.nota,1) < @nota_minima
	and alc_codper = b.ins_codper
	and plm_codpla = alc_codpla
	and plm_codmat = b.mai_codmat

	if @campo6 = 'S' set @reprobadas = 0
					  

	select @equivalencias = count(distinct eqn_codmat) 
	from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas, 
	ra_alc_alumnos_carrera, ra_plm_planes_materias
	where equ_codigo = eqn_codequ
	and equ_codper = @codper
	and eqn_nota > 0 
	and equ_tipo = 'E'
	and alc_codper = equ_codper
	and plm_codpla = alc_codpla
	and plm_codmat = eqn_codmat


	select @uv_plan = sum(plm_uv)
	from ra_plm_planes_materias, ra_alc_alumnos_carrera
	where plm_ciclo <> 0
	and plm_anio_carrera <> 0
	and plm_codpla = alc_codpla
	and alc_codper = @codper

	select @unidades = sum(uv)
	from 
	(
		select plm_uv uv
		from @notas b,
		ra_alc_alumnos_carrera, ra_plm_planes_materias
		where b.ins_codper = @codper
		and round(b.nota,1) >= @nota_minima
		and alc_codper = b.ins_codper
		and plm_codpla = alc_codpla
		and plm_codmat = b.mai_codmat
		and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')

		union all
		select plm_uv
		from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,
		ra_alc_alumnos_carrera, ra_plm_planes_materias
		where equ_codigo = eqn_codequ
		and equ_codper = @codper
		and eqn_nota > 0
		and alc_codper = equ_codper
		and plm_codpla = alc_codpla
		and plm_codmat = eqn_codmat
	) t


	if @unidades > @uv_plan set @unidades = @uv_plan

	declare @record table (
		Lugar varchar(150),fecha varchar(200),lee_firma varchar(10),fac_nombre varchar(100),confronto varchar(150),
		elaboro varchar(150),Secretaria varchar(150),Rector varchar(150),cil_codigo int,uni_nombre varchar(150),per_carnet varchar(15),
		per_nombres_apellidos varchar(200),car_nombre varchar(150),reg_nombre varchar(100),UV int,equ_codist int,cic_nombre varchar(50),
		mat_codigo varchar(50),mat_nombre varchar(150),nota real,estado varchar(50),nota_letras varchar(100),ciclo_min varchar(150),
		ciclo_max varchar(150),uni_nota_minima real,uni_nota_minima_letras varchar(100),total_aprobadas int,materias_aprobadas varchar(100),
		materias_reprobadas int,total_aprobadas_letras varchar(200),materias_aprobadas_letras varchar(200),
		materias_reprobadas_letras varchar(200), not_num real,cum_n real,cum_n_letras varchar(200),equ varchar(100),
		equ_concedidas varchar(200),plm_uv int,matriculado varchar(50),GloPa varchar(20),
		cil_anio int, cil_codcic int, plm_anio_carrera int, plm_ciclo int, codcil_real int
	)

	if @campo6 = 'N'
	begin
		/*INSERTA MATERIAS GENERALES (APROBADAS Y REPROBADAS)*/
		insert into @record (Lugar, fecha, lee_firma, fac_nombre, confronto, elaboro, Secretaria, Rector, cil_codigo, uni_nombre, per_carnet,
		per_nombres_apellidos, car_nombre, reg_nombre, UV, equ_codist, cic_nombre, mat_codigo, mat_nombre, nota, estado, nota_letras, ciclo_min,
		ciclo_max, uni_nota_minima, uni_nota_minima_letras, total_aprobadas, materias_aprobadas, materias_reprobadas, total_aprobadas_letras,
		materias_aprobadas_letras, materias_reprobadas_letras, not_num, cum_n, cum_n_letras, equ, equ_concedidas, plm_uv, matriculado, GloPa,
		
		cil_anio, cil_codcic, plm_anio_carrera, plm_ciclo, codcil_real)

		select @campo1 Lugar,dbo.fn_crufl_FechaALetras(convert(datetime,@campo2,103),1,1) fecha,
		'' lee_firma,fac_nombre,@campo4 confronto, @campo5 elaboro,
		'' Secretaria,@campo3 Rector,cil_codigo,uni_nombre, per_carnet, per_nombres_apellidos, 
		car_nombre as car_nombre, reg_nombre, @unidades UV,equ_codist,
		--case 
		--when cil_codigo = 0 and equ_codist <> 711 then 'Eq. Externa' 
		--when cil_codigo = 0 and equ_codist = 711 then 'Eq. Interna'
		--else
		--substring(cic_nombre,7,8) + ' - ' + CAST(cil_anio as varchar) end cic_nombre,

		/*case when  cic_nombre = 'Eq. Externa ' or cic_nombre = 'Eq. Interna ' or cic_nombre = 'Suficiencia' then cic_nombre else
		(substring(cic_nombre,7,8) + ' - ' + cast(cil_anio as nvarchar)) end*/ cic_nombre,
		mat_codigo, mat_nombre, nota nota, estado estado, '(' + upper(dbo.NotaALetras(nota)) + ')' nota_letras,
		ciclo_min, ciclo_max, iif(@tipo_alumno = 'U',uni_nota_minima, uni_pnota_minima) uni_nota_minima, 
		upper(dbo.NotaALetras(iif(@tipo_alumno = 'U',uni_nota_minima, uni_pnota_minima))) uni_nota_minima_letras,
		materias_aprobadas total_aprobadas,
		case when materias_equivalencia > 0 then 
		'('+cast(materias_aprobadas as varchar) + ') aprobadas ' + 'En esta Institucion ' 
		else
		'' end materias_aprobadas, 
		materias_reprobadas,
		dbo.MateriasALetras(materias_aprobadas) total_aprobadas_letras,
		case when materias_equivalencia > 0 then 
		dbo.MateriasALetras(materias_aprobadas) + '('+cast(materias_aprobadas as varchar) + ') aprobadas ' + 'En esta Institucion ' 
		else
		'' end materias_aprobadas_letras, 
		dbo.MateriasALetras(materias_reprobadas) materias_reprobadas_letras, not_num,round(cum_n,1) cum_n,
		dbo.NotaALetras(round(cum_n,1)) cum_n_letras,
		case when cil_codigo = 0 then 'EQUIVALENCIAS' else '' end equ,
		case when materias_equivalencia > 0 then
		dbo.MateriasALetras(materias_equivalencia) + '(' + cast(materias_equivalencia as varchar) + ')' +
		' asignaturas concedidas por equivalencia ' else '' end equ_concedidas,
		plm_uv, matriculado, case when materias_aprobadas >= @nmat_plan then 'global' else 'parcial' end GloPa,

		cil_anio, cil_codcic, plm_anio_carrera, plm_ciclo, cil_codigo
		from
		/*SUBCONSULTA GENERAL PARA OBTENER TODOS LAS CONDICIONES DE LA CONSULTA*/
		(
			select plm_anio_carrera, plm_ciclo, cil_codcic,cil_codigo,uni_nombre, per_carnet, per_nombres_apellidos, uni_nota_minima, uni_pnota_minima,
			fac_nombre, car_nombre as car_nombre, reg_nombre, cic_nombre, cil_anio, per_acta_equivalencia,
			mat_codigo, mat_nombre, per_resolucion_equivalencia, per_fecha_equivalencia,plm_uv, equ_codist,
			case when per_sexo = 'M' then ' matriculado '  else ' matriculada ' end matriculado,
			round(isnull((select sum(nota)
		/*SUBCONSULTA EXCLUSIÓN EQUIVALENCIAS*/
		from
		(
			(select isnull(nota,0) nota 
			from @notas 
			where ins_codper = codper
			and mai_codmat = codmat_del
			and ins_codcil = cil_codigo
			and mat_codigo not in  (select eqn_codmat
							from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
							where eqn_codequ = equ_codigo
							and equ_codper = @codper
							and eqn_nota > 0)
			union all
			/*UNION CON OTRA CONSULTA PARA OBTENER LAS EQUIVALENCIAS*/
			select isnull(round(avg(eqn_nota),1),0)
			from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad
			where eqn_codequ = equ_codigo
			and eqn_codmat = mat_codigo
			and equ_codper = codper
			and eqn_nota > 0
			)
		) t)
		,0),1) nota, 

		isnull((select sum(nota)
		from
		/*CONSICION PARA EQUIVALENCIAS*/
		(
		(select isnull(nota,0)  nota
		from @notas 
		where ins_codper = codper
		and mai_codmat = codmat_del
		and ins_codcil = cil_codigo
		and mat_codigo not in  (select eqn_codmat
						from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
						where eqn_codequ = equ_codigo
						and equ_codper = @codper
						and eqn_nota > 0)
					
		union all
		/*UNION CON OTRA CONSULTA*/
		select isnull(round(avg(eqn_nota),1),0)
		from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad
		where eqn_codequ = equ_codigo
		and eqn_codmat = mat_codigo
		and equ_codper = codper
		and eqn_nota > 0
		))t ),0) not_num,

		CASE WHEN mai_estado = 'I' then case when isnull((select sum(nota)
		from
		(
		(select isnull(nota,0) nota
		from @notas 
		where ins_codper = codper
		and mai_codmat = codmat_del
		and ins_codcil = cil_codigo
		and mat_codigo not in  (select eqn_codmat
						from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
						where eqn_codequ = equ_codigo
						and equ_codper = @codper
						and eqn_nota > 0)
		union all
		select isnull(round(avg(eqn_nota),1),0)
		from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad
		where eqn_codequ = equ_codigo
		and eqn_codmat = mat_codigo
		and equ_codper = codper
		and eqn_nota > 0
		)) t ),0) < 
		(select cast(iif(@tipo_alumno = 'U',uni_nota_minima, uni_pnota_minima) as real) 
		from ra_uni_universidad 
		join ra_reg_regionales on uni_codigo = reg_coduni 
		join ra_per_personas on reg_codigo = per_codreg 
		where per_codigo = codper) 
		THEN 'Reprobada' ELSE 'Aprobada' END else 'Retirada' end estado, 

		(select cic_nombre + ' del año academico ' + cast(cil_anio as varchar) 
		from ra_cil_ciclo, ra_cic_ciclos
		where cic_codigo = cil_codcic
		and cast(cil_anio as varchar) + cast(cil_codigo as varchar) =
		(select min(cast(cil_anio as varchar) + cast(cil_codigo as varchar))
		from ra_cil_ciclo, ra_ins_inscripcion
		where ins_codper = codper
		and cil_codigo = ins_codcil)) ciclo_min,
		(select cic_nombre + ' del año academico ' + cast(cil_anio as varchar) 
		from ra_cil_ciclo, ra_cic_ciclos
		where cic_codigo = cil_codcic
		and cast(cil_anio as varchar) + cast(cil_codigo as varchar) = 
		(select max(cast(cil_anio as varchar) + cast(cil_codigo as varchar))
		from ra_cil_ciclo, ra_ins_inscripcion
		where ins_codper = codper
		and cil_codigo = ins_codcil)) ciclo_max,

		@equivalencias  materias_equivalencia,

		@aprobadas materias_aprobadas,

		@reprobadas materias_reprobadas,

		@cum_n cum_n
		from
		(
			select cil_codcic,cil_codigo,uni_nombre, ins_codper codper, per_carnet, 
			per_nombres_apellidos, per_sexo,
			--car_nombre_legal as car_nombre, 
			@alias_carrera as car_nombre, reg_nombre, mat_codigo, isnull(plm_alias,mat_nombre) mat_nombre, cic_nombre, cil_anio, fac_nombre, 
			uni_nota_minima, uni_pnota_minima,
			pla_codigo codpla, per_codreg codreg,  per_resolucion_equivalencia, per_fecha_equivalencia,0 equ_codist,
			plm_uv, mai_codmat_del codmat_del,per_acta_equivalencia, mai_estado,

			plm_anio_carrera, plm_ciclo
			from @ra_mai_mat_inscritas_h_v, ra_mat_materias, ra_per_personas,
			ra_uni_universidad, ra_reg_regionales, ra_ins_inscripcion, 
			ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras,
			ra_cil_ciclo, ra_cic_ciclos, ra_fac_facultades, ra_plm_planes_materias
			where per_carnet = @campo0
			and ins_codper = per_codigo
			and reg_codigo = per_codreg
			and uni_codigo = reg_coduni
			and alc_codper = per_codigo
			and alc_codpla = pla_codigo
			and car_codigo = pla_codcar
			and cil_codigo = ins_codcil
			and cic_codigo = cil_codcic
			and mai_codins = ins_codigo
			and mai_codmat = mat_codigo
			--and mai_estado = 'I'
			and fac_codigo = car_codfac
			and plm_codpla = alc_codpla
			and plm_codmat = mat_codigo
			and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_CODIGO = @cil_codigo) and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente ='S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
			and mai_codmat not in  (select eqn_codmat
							from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
							where eqn_codequ = equ_codigo
							and equ_codper = @codper
							and eqn_nota > 0)
			union all
			select distinct 0,0,uni_nombre, equ_codper codper, per_carnet, per_nombres_apellidos per_nombres_apellidos, per_sexo,
					--car_nombre_legal as car_nombre, 
			@alias_carrera as car_nombre, reg_nombre, eqn_codmat, isnull(plm_alias,mat_nombre) mat_nombre, eqn_nota_tipo/*''*/ cic_nombre, 0 cil_anio, fac_nombre, 
			uni_nota_minima, uni_pnota_minima,
			pla_codigo codpla, per_codreg codreg, per_resolucion_equivalencia, per_fecha_equivalencia, equ_codist,plm_uv, 
			eqn_codmat, per_acta_equivalencia,'I', 
			
			plm_anio_carrera, plm_ciclo
			from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas,
			ra_mat_materias, ra_per_personas,ra_uni_universidad, ra_reg_regionales, 
			ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras, ra_fac_facultades,
			ra_plm_planes_materias
			where per_carnet = @campo0
			and equ_codper = per_codigo
			and eqn_codequ = equ_codigo
			and reg_codigo = per_codreg
			and uni_codigo = reg_coduni
			and alc_codper = per_codigo
			and alc_codpla = pla_codigo
			and car_codigo = pla_codcar
			and eqn_codmat = mat_codigo
			and fac_codigo = car_codfac
			and eqn_nota > 0
			and plm_codpla = alc_codpla
			and plm_codmat = mat_codigo
			) j 
		) t
		--order by cil_anio, cil_codcic
		print 'fin N'
	end
	else
	begin
		print 'inicio S'
		insert into @record (Lugar, fecha, lee_firma, fac_nombre, confronto, elaboro, Secretaria, Rector, cil_codigo, uni_nombre, per_carnet,
		per_nombres_apellidos, car_nombre, reg_nombre, UV, equ_codist, cic_nombre, mat_codigo, mat_nombre, nota, estado, nota_letras, ciclo_min,
		ciclo_max, uni_nota_minima, uni_nota_minima_letras, total_aprobadas, materias_aprobadas, materias_reprobadas, total_aprobadas_letras,
		materias_aprobadas_letras, materias_reprobadas_letras, not_num, cum_n, cum_n_letras, equ, equ_concedidas, plm_uv, matriculado, GloPa,
		
		cil_anio, cil_codcic, plm_anio_carrera, plm_ciclo, codcil_real)

		select @campo1 Lugar,dbo.fn_crufl_FechaALetras(convert(datetime,@campo2,103),1,1) fecha, '' lee_firma,fac_nombre, @campo4 confronto, @campo5 elaboro,
		'' Secretaria,@campo3 Rector,cil_codigo,uni_nombre, per_carnet, per_nombres_apellidos, 
		car_nombre as car_nombre, reg_nombre,@unidades UV,equ_codist,
		--case when cil_codigo = 0 and equ_codist <> 711 then 'Eq.Externa' 
		--when  cil_codigo = 0 and equ_codist = 711 then 'Eq. Interna'
		--else
		--substring(cic_nombre,7,8) + ' - ' + CAST(cil_anio as varchar) end cic_nombre,

		/*case when  cic_nombre = 'Eq. Externa ' or cic_nombre = 'Eq. Interna ' or cic_nombre = 'Suficiencia' then cic_nombre else
		(substring(cic_nombre,7,8) + ' - ' + cast(cil_anio as nvarchar)) end*/ cic_nombre,

		mat_codigo, mat_nombre, nota nota, estado estado, '(' + upper(dbo.NotaALetras(nota)) + ')' nota_letras,
		ciclo_min, ciclo_max, iif(@tipo_alumno = 'U',uni_nota_minima, uni_pnota_minima) uni_nota_minima, 
		upper(dbo.NotaALetras(iif(@tipo_alumno = 'U',uni_nota_minima, uni_pnota_minima))) uni_nota_minima_letras,
		materias_aprobadas total_aprobadas,
		case when materias_equivalencia > 0 then 
		'('+cast(materias_aprobadas as varchar) + ') aprobadas ' + 'En esta Institucion ' 
		else
		'' end materias_aprobadas, 
		materias_reprobadas,
		dbo.MateriasALetras(materias_aprobadas) total_aprobadas_letras,
		case when materias_equivalencia > 0 then 
		dbo.MateriasALetras(materias_aprobadas) + '('+cast(materias_aprobadas as varchar) + ') aprobadas ' + 'En esta Institucion ' 
		else
		'' end materias_aprobadas_letras,
		dbo.MateriasALetras(materias_reprobadas) materias_reprobadas_letras,not_num,round(@cum,1) cum_n,
		dbo.NotaALetras(round(cum_n,1)) cum_n_letras,
		case when cil_codigo = 0 then 'EQUIVALENCIAS' else '' end equ,
		case when materias_equivalencia > 0 then dbo.MateriasALetras(materias_equivalencia) + '(' + cast(materias_equivalencia as varchar) + ')' + ' asignaturas concedidas por equivalencia ' else '' end equ_concedidas, 
		plm_uv, matriculado, case when materias_aprobadas >= @nmat_plan then 'global' else 'parcial' end GloPa,
		
		cil_anio, cil_codcic, plm_anio_carrera, plm_ciclo, cil_codigo
		from (
			select plm_anio_carrera, plm_ciclo, cil_codcic,cil_codigo,uni_nombre, per_carnet, per_nombres_apellidos, uni_nota_minima, uni_pnota_minima,
			fac_nombre, car_nombre as car_nombre, reg_nombre, cic_nombre, cil_anio, per_acta_equivalencia,
			mat_codigo, mat_nombre, per_resolucion_equivalencia, per_fecha_equivalencia,plm_uv, equ_codist,
			case when per_sexo = 'M' then ' matriculado '  else ' matriculada ' end matriculado,
			round(isnull((select sum(nota)
			/*SUBCONSULTA EXCLUSIÓN EQUIVALENCIAS*/
			from
			(
			(select isnull(nota,0) nota 
			from @notas 
			where ins_codper = codper
			and mai_codmat = codmat_del
			and ins_codcil = cil_codigo
			and mat_codigo not in  (select eqn_codmat
							from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
							where eqn_codequ = equ_codigo
							and equ_codper = @codper
							and eqn_nota > 0)
			union all
			/*UNION CON OTRA CONSULTA PARA OBTENER LAS EQUIVALENCIAS*/
			select isnull(round(avg(eqn_nota),1),0)
			from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad
			where eqn_codequ = equ_codigo
			and eqn_codmat = mat_codigo
			and equ_codper = codper
			and eqn_nota > 0
			)
			) t)
			,0),1) nota, 

			isnull((select sum(nota)
			from
			/*CONSICION PARA EQUIVALENCIAS*/
			(
			(select isnull(nota,0)  nota
			from @notas 
			where ins_codper = codper
			and mai_codmat = codmat_del
			and ins_codcil = cil_codigo
			and mat_codigo not in  (select eqn_codmat
							from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
							where eqn_codequ = equ_codigo
							and equ_codper = @codper
							and eqn_nota > 0)
					
			union all
			/*UNION CON OTRA CONSULTA*/
			select isnull(round(avg(eqn_nota),1),0)
			from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad
			where eqn_codequ = equ_codigo
			and eqn_codmat = mat_codigo
			and equ_codper = codper
			and eqn_nota > 0
			))t ),0) not_num,

			CASE WHEN isnull((select sum(nota)
			from (
			(select isnull(nota,0) nota
			from @notas 
			where ins_codper = codper
			and mai_codmat = codmat_del
			and ins_codcil = cil_codigo
			and mat_codigo not in  (select eqn_codmat
							from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
							where eqn_codequ = equ_codigo
							and equ_codper = @codper
							and eqn_nota > 0)
			
				union all

			select isnull(round(avg(eqn_nota),1),0)
			from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad
			where eqn_codequ = equ_codigo
			and eqn_codmat = mat_codigo
			and equ_codper = codper
			and eqn_nota > 0
			)) t ),0) < 
			(select cast(iif(@tipo_alumno = 'U',uni_nota_minima, uni_pnota_minima) as real) 
			from ra_uni_universidad 
			join ra_reg_regionales on uni_codigo = reg_coduni 
			join ra_per_personas on reg_codigo = per_codreg 
			where per_codigo = codper) 
			THEN 'Reprobada' ELSE 'Aprobada' END estado,

			(select cic_nombre + ' del año academico ' + cast(cil_anio as varchar) 
			from ra_cil_ciclo, ra_cic_ciclos
			where cic_codigo = cil_codcic
			and cast(cil_anio as varchar) + cast(cil_codigo as varchar) =
			(select min(cast(cil_anio as varchar) + cast(cil_codigo as varchar))
			from ra_cil_ciclo, ra_ins_inscripcion
			where ins_codper = codper
			and cil_codigo = ins_codcil)) ciclo_min,

			(select cic_nombre + ' del año academico ' + cast(cil_anio as varchar) 
			from ra_cil_ciclo, ra_cic_ciclos
			where cic_codigo = cil_codcic
			and cast(cil_anio as varchar) + cast(cil_codigo as varchar) = 
			(select max(cast(cil_anio as varchar) + cast(cil_codigo as varchar))
			from ra_cil_ciclo, ra_ins_inscripcion
			where ins_codper = codper
			and cil_codigo = ins_codcil)) ciclo_max, @equivalencias  materias_equivalencia, @aprobadas materias_aprobadas, @reprobadas materias_reprobadas, @cum cum_n
			from
			(
				select cil_codcic,cil_codigo,uni_nombre, ins_codper codper, per_carnet, 
					per_nombres_apellidos, per_sexo,
							--car_nombre_legal as car_nombre, 
						@alias_carrera as car_nombre, reg_nombre, mat_codigo, isnull(plm_alias,mat_nombre) mat_nombre, cic_nombre, cil_anio, fac_nombre,
						uni_nota_minima, uni_pnota_minima,
					pla_codigo codpla, per_codreg codreg,  per_resolucion_equivalencia, per_fecha_equivalencia,0 equ_codist,
					plm_uv, mai_codmat_del codmat_del,per_acta_equivalencia, mai_estado,

					plm_anio_carrera, plm_ciclo
				from @ra_mai_mat_inscritas_h_v, ra_mat_materias, ra_per_personas,
				ra_uni_universidad, ra_reg_regionales, ra_ins_inscripcion, 
				ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras,
				ra_cil_ciclo, ra_cic_ciclos, ra_fac_facultades, ra_plm_planes_materias
				where per_carnet = @campo0 and ins_codper = per_codigo
				and reg_codigo = per_codreg and uni_codigo = reg_coduni
				and alc_codper = per_codigo and alc_codpla = pla_codigo
				and car_codigo = pla_codcar and cil_codigo = ins_codcil
				and cic_codigo = cil_codcic and mai_codins = ins_codigo
				and mai_codmat = mat_codigo and mai_estado = 'I'
				and fac_codigo = car_codfac and plm_codpla = alc_codpla
				and plm_codmat = mat_codigo
				and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
				and mai_codmat not in (select eqn_codmat
								from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
								where eqn_codequ = equ_codigo
								and equ_codper = @codper
								and eqn_nota > 0)
					union all

				select distinct 0,0,uni_nombre, equ_codper codper, per_carnet, per_nombres_apellidos per_nombres_apellidos, per_sexo,
					@alias_carrera as car_nombre, reg_nombre, eqn_codmat, isnull(plm_alias,mat_nombre) mat_nombre, eqn_nota_tipo/*''*/ cic_nombre, 0 cil_anio, fac_nombre,
					uni_nota_minima, uni_pnota_minima,
					pla_codigo codpla, per_codreg codreg, per_resolucion_equivalencia, per_fecha_equivalencia, equ_codist,plm_uv, 
					eqn_codmat, per_acta_equivalencia,'I',

					plm_anio_carrera, plm_ciclo
				from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas,
					ra_mat_materias, ra_per_personas,ra_uni_universidad, ra_reg_regionales, 
					ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras, ra_fac_facultades,
					ra_plm_planes_materias
				where per_carnet = @campo0 and equ_codper = per_codigo
					and eqn_codequ = equ_codigo and reg_codigo = per_codreg
					and uni_codigo = reg_coduni and alc_codper = per_codigo
					and alc_codpla = pla_codigo and car_codigo = pla_codcar
					and eqn_codmat = mat_codigo and fac_codigo = car_codfac
					and eqn_nota > 0 and plm_codpla = alc_codpla and plm_codmat = mat_codigo
			) j 
		) t
		where nota >= @nota_minima
	end
		--Inicio: Logica para los estudiantes menores al 2000
		declare @anio_ingreso int = 0
		set @anio_ingreso = cast(substring(@campo0, 9, 4) as int)

		if @anio_ingreso <= 2000
		begin
			print concat('record legacy ', @anio_ingreso)
			declare @record_legacy table (  
				cil_codcic int, cil_codigo varchar(80),  
				uni_nombre varchar(250), per_carnet varchar(12),  
				per_nombres_apellidos varchar(200), car_nombre varchar(250),
				pla_alias_carrera varchar(150), fac_nombre varchar(100),  
				pla_nombre varchar(100), reg_nombre varchar(80),  
				cic_nombre varchar(50), cil_anio int,  
				mat_codigo varchar(10), mat_nombre varchar(200),  
				nota real, nota_letras varchar(100),  
				estado varchar(20), cum_parcil real, cum real, materias int,  
				aprobadas int, reprobadas int, matricula int, equivalencias int,  
				ing_nombre varchar(50), estado_a varchar(20),  
				plm_anio_carrera int, plm_ciclo int,   
				absorcion varchar(2), uv int, um float, codcil_real int
			)
			insert into @record_legacy (
				cil_codcic, cil_codigo, uni_nombre, per_carnet, per_nombres_apellidos, car_nombre, pla_alias_carrera, fac_nombre, pla_nombre, 
				reg_nombre, cic_nombre, cil_anio, mat_codigo, mat_nombre, nota, nota_letras, estado, cum_parcil, cum, materias, aprobadas, 
				reprobadas, matricula, equivalencias, ing_nombre, estado_a, plm_anio_carrera, plm_ciclo, absorcion, uv, codcil_real
			)
			exec dbo.rep_record_academico_limpio 1, @campo0, @campo6

			select 
				r.Lugar, r.fecha, r.lee_firma, r.fac_nombre, r.confronto, r.elaboro, r.Secretaria, r.Rector, rl.cil_codigo, r.uni_nombre,
				r.per_carnet, r.per_nombres_apellidos, r.car_nombre, r.reg_nombre, r.UV, r.equ_codist, concat(replace(rl.cic_nombre, 'Ciclo ', ''), ' - ', rl.cil_anio) cic_nombre,
				r.mat_codigo, r.mat_nombre,r.nota, r.estado, r.nota_letras, r.ciclo_min, r.ciclo_max, r.uni_nota_minima, r.uni_nota_minima_letras,
				r.total_aprobadas, r.materias_aprobadas, r.materias_reprobadas, r.total_aprobadas_letras, r.materias_aprobadas_letras, r.materias_reprobadas_letras,
				r.not_num, r.cum_n, r.cum_n_letras, r.equ, r.equ_concedidas, r.plm_uv, r.matriculado, r.GloPa
			from @record_legacy rl
				inner join @record r on rl.mat_codigo = r.mat_codigo and rl.codcil_real = r.codcil_real 
		
			return
		end
		--Fin: Logica para los estudiantes menores al 2000

		select Lugar, fecha, lee_firma, fac_nombre, confronto, elaboro, Secretaria, Rector, cil_codigo, uni_nombre, per_carnet,
			per_nombres_apellidos, car_nombre, reg_nombre, UV, equ_codist, cic_nombre, mat_codigo, mat_nombre, nota, estado, nota_letras, ciclo_min,
			ciclo_max, uni_nota_minima, uni_nota_minima_letras, total_aprobadas, materias_aprobadas, materias_reprobadas, total_aprobadas_letras,
			materias_aprobadas_letras, materias_reprobadas_letras, not_num, cum_n, cum_n_letras, equ, equ_concedidas, plm_uv, matriculado, GloPa 
		from @record
		order by cil_anio, cil_codcic, plm_anio_carrera, plm_ciclo

	--drop table #ra_mai_mat_inscritas_h_v
	--drop table #notas
END
