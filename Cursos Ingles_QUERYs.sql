select * from ra_plm_planes_materias where plm_codpla = 622
select * from ra_mat_materias where mat_codigo = 'A1-1' order by mat_fechahora desc
select * from ra_hpl_horarios_planificacion where hpl_codcil = 135 and hpl_codmat = 'A1-1'
update ra_hpl_horarios_planificacion set hpl_codemp = 4775 where hpl_codcil = 135 and hpl_codmat = 'A1-1'
--4775, jocelyn.bonilla, JIBM.2024
--select * from ra_vac_valor_cuotas where vac_codigo = 21
insert into ra_vac_valor_cuotas (vac_codigo, vac_ValorCuota, vac_Tipo, vac_ValorMatricula, vac_CantCuota, vac_Fecha_Registro, vac_codcar, vac_activo, vac_tipo_carrera)
values (21, 40, 'PREGRADO-IDIOMAS', 40, 2, getdate(), null, 1, 'Presencial')
--alter table ra_per_personas add per_codper_padre int null
alter table ra_plm_planes_materias add plm_cantidad_notas int null default 5
update ra_plm_planes_materias  set plm_cantidad_notas = 5
select * from ra_plm_planes_materias

--select * from ra_cil_ciclo
select * from ra_plac_plan_ciclo where plac_codpla = 622
select * from ra_per_personas where per_codigo = 168640
select * from ra_alc_alumnos_carrera where alc_codper = 168640

select max(per_codigo) + 1 from ra_per_personas --where per_codigo = 254277
select * from ra_per_personas where per_codigo = 254280
update ra_per_personas set per_carnet = 'CE-6322-2024', per_correo_institucional = 'CE63222024@mail.utec.edu.sv', per_codvac = 21, per_codper_padre = 168640
where per_codigo = 254305
select * from ra_per_personas where per_carnet = 'CE-6322-2024'
select max(alc_codigo) + 1 from ra_alc_alumnos_carrera where alc_codper = 254273
insert into ra_alc_alumnos_carrera (alc_codigo, alc_codper, alc_codpla) values (249800, 254305, 622)
--update ra_per_personas set per_codper_padre = 168640 where per_codigo = 254273

select * from ra_cil_ciclo
select * from col_fel_fechas_limite where fel_codcil = 135 and fel_codvac = 21
select * from col_art_archivo_tal_mora where per_codigo = 254273
insert into col_fel_fechas_limite (fel_codreg, fel_codcil, fel_mes, fel_anio, fel_fecha, fel_codtmo, fel_tipo, fel_fecha_gracia, fel_codigo_barra, fel_valor, fel_global, fel_valor_mora, fel_fecha_mora, fel_tipo_alumno, fel_codvac, fel_codtipmen, fel_fechahora, fel_codtad, fel_coddip)
values (1, 135, 7, 2024, '2024-06-16', 4488, 'N', NULL, 1, 40.0, 0, 40.0, '2023-06-16', 'U', 21, NULL, getdate(), NULL, NULL)

-- exec dbo.tal_GenerarDataTalonarioPreGrado_porAlumno 1, 1, 135, 135, 254305 -- Bien
select * from ra_ins_inscripcion where ins_codper = 254277
select * from ra_mai_mat_inscritas where mai_codins = 1397854
select * from ra_pom_ponderacion_materia where pom_codmat = 'A1-1'
select * from ra_not_notas where not_codmai = 5839406
select * from ra_hpl_horarios_planificacion where hpl_codigo = 60176

--exec ra_cpn_crear_ponderaciones_notas @opcion = 1, @codcil = 135, @codper = 254273
--drop procedure sp_docente_academia_idiomas
--drop type tbl_npro
create type tbl_npro as table(
	npro_evaluado int null,
	npro_nota real null,
	npro_alumno int null,
	npro_codinnot varchar(50) null,
	npro_codmai int null
	--,npro_codnot int null
)

declare @carnet varchar(25) = 'CE-6322-2024', @ciclo int = 135
SELECT p1.per_codigo, isnull(p2.per_carnet, p1.per_carnet) 'per_carnet', isnull(p2.per_nombres_apellidos, p1.per_nombres_apellidos) 'per_nombres_apellidos', ra_pla_planes.pla_alias_carrera, ra_pla_planes.pla_nombre, 
ins_fecha, rtrim(cic_nombre)+'-'+rtrim(cast(cil_anio as varchar)) as ciclo, 
p1.per_tipo_ingreso_fijo,
isnull(replace(p2.per_carnet,'-',''), replace(p1.per_carnet,'-','')) usuario,
replace(convert(varchar,p1.per_fecha_nac,103),'/','') clave,p1.per_tipo_ingreso, iif(car_nombre LIKE '%NO PRESENCIAL%', 'Virtual', 'Presencial') Modalidad
FROM ra_per_personas p1
	INNER JOIN ra_alc_alumnos_carrera ON p1.per_codigo = alc_codper 
	INNER JOIN ra_pla_planes ON alc_codpla = pla_codigo 
	INNER JOIN ra_car_carreras ON pla_codcar = car_codigo 
	INNER JOIN ra_ins_inscripcion ON p1.per_codigo = ins_codper 
	JOIN ra_cil_ciclo on cil_codigo = ins_codcil JOIN ra_cic_ciclos on cil_codcic = cic_codigo 
	left join ra_per_personas p2 on p1.per_codper_padre = p2.per_codigo
WHERE p1.per_carnet = @carnet and ra_ins_inscripcion.ins_codcil = @ciclo

select * from web_ra_not_penot_periodonotas where getdate() >= penot_fechaini and getdate() <= penot_fechafin

insert into web_ra_not_penot_periodonotas (penot_tipo, penot_eval, penot_fechaini, penot_fechafin, penot_periodo)
values ('Pregrado-idiomas', 1, '2024-05-01 00:00:00.000', '2024-05-28 00:00:00.000', 'Ordinario')

select * from web_ra_not_penot_periodonotas_maes

declare @codcil int = 135, @codhpl int = 60184, @penot_tipo varchar(50) = 'Pregrado-idiomas'

select penot_codigo, penot_tipo, penot_eval, penot_fechaini, penot_fechafin, penot_periodo, innot_Fecha 'fecha_proceso_notas', (count(1) - 1) 'notas_procesadas'
from web_ra_not_penot_periodonotas 
inner join ra_hpl_horarios_planificacion on hpl_codigo = @codhpl
left join web_ra_innot_ingresosdenotas on innot_codpenot = penot_codigo and innot_codcil = @codcil and innot_codmai = hpl_codmat and hpl_descripcion = innot_seccion
left join web_ra_npro_notasprocesadas on innot_codingre = npro_codinnot
where penot_tipo = @penot_tipo and getdate() >= penot_fechaini and getdate() <= penot_fechafin
group by penot_codigo, penot_tipo, penot_eval, penot_fechaini, penot_fechafin, penot_periodo, innot_Fecha

--select top 10 * from web_ra_innot_ingresosdenotas order by innot_Fecha desc
--ADM1-V,134,04,3,2340,7
--ADM1-V,134,04,3,2340,7
--EXOE-H,134,08,3,3852,7
--ANAD-V,134,02,3,233,7
--MERC-V,134,03,3,4723,7
--ADM2-V,134,01,3,758,7
--STCD-V,134,01,3,236,5
select top 2000 * from web_ra_npro_notasprocesadas order by npro_codigo desc

delete from web_ra_innot_ingresosdenotas where innot_codingre = 'A1-1135011477525'
delete from web_ra_npro_notasprocesadas where npro_codinnot = 'A1-1135011477525'

select * from ra_mai_mat_inscritas where mai_codigo = 5839428
select * from ra_not_notas where not_codmai = 5839428
update ra_not_notas set not_nota = null where not_codmai = 5839428
select *
from ra_not_notas n
	--inner join @tbl_npro t on n.not_codmai = t.npro_codmai
	inner join ra_pom_ponderacion_materia on not_codpom = pom_codigo
	inner join ra_pon_ponderacion on pom_codpon = pon_codigo and pon_orden = 1
where n.not_codmai = 5839428 

select top 1000 * from ra_not_notas order by not_codigo desc



	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2024-05-09 16:26:11.687>
	-- Description: <Realiza el matenimiento a lo relacionado a los docentes de la academia de idiomas>
	-- =============================================
	-- exec dbo.sp_docente_academia_idiomas 0
create or alter procedure sp_docente_academia_idiomas
	@opcion int = 0,
	@codcil int = 0,
	@codemp int = 0,
	@codhpl int = 0,
	@codpenot int = 0,
	@penot_tipo varchar(20) = '',
	@codingre varchar(35) = '',
	@tbl_npro as tbl_npro readonly
as
begin
	
	if @opcion = 0
	begin
		select top 10 cil_codigo, concat('0', cil_codcic, '-', cil_anio) ciclo 
		from ra_cil_ciclo
		order by cil_anio desc, cil_codcic desc
	end

	if @opcion = 1
	begin
		-- exec dbo.sp_docente_academia_idiomas @opcion = 1, @codcil = 135, @codemp = 4775
		select 100000 'codhpl', '*Seleccione*' 'materia'
			union all
		select hpl_codigo 'codhpl' , concat('“', trim(hpl_codmat), ' ', trim(mat_nombre), ' ', trim(hpl_descripcion), '” de ', trim(man_nomhor), ' en ', trim(aul_nombre_corto), ' los días ', 
		(case when isnull(hpl_lunes,'N') = 'S' then 'Lu-' else '' end+
		case when isnull(hpl_martes,'N') = 'S' then 'Ma-' else '' end+
		case when isnull(hpl_miercoles,'N') = 'S' then 'Mie-' else '' end+
		case when isnull(hpl_jueves,'N') = 'S' then 'Ju-' else '' end+
		case when isnull(hpl_viernes,'N') = 'S' then 'Vi-' else '' end+
		case when isnull(hpl_sabado,'N') = 'S' then 'Sab-' else '' end+
		case when isnull(hpl_domingo,'N') = 'S' then 'Dom-' else '' end
		)) 'materia'
		from ra_hpl_horarios_planificacion
			inner join pla_emp_empleado on hpl_codemp = emp_codigo
			inner join ra_mat_materias on hpl_codmat = mat_codigo
			inner join ra_plm_planes_materias on plm_codmat = hpl_codmat and plm_cantidad_notas = 1
			inner join ra_man_grp_hor on hpl_codman = man_codigo
			inner join ra_aul_aulas on hpl_codaul = aul_codigo
		where hpl_codemp = @codemp and hpl_codcil = @codcil
	end

	if @opcion = 2 -- devuelve los periodos activos actualmente junto con el detalle de las notas procesadas
	begin
		-- exec dbo.sp_docente_academia_idiomas @opcion = 2, @codhpl = 60184, @penot_tipo = 'Pregrado-idiomas'
		select penot_codigo, penot_tipo, penot_eval, 
		format(penot_fechaini, 'dd/MM/yyy HH:mm:ss') 'penot_fechaini', 
		format(penot_fechafin, 'dd/MM/yyy HH:mm:ss') 'penot_fechafin', 
		penot_periodo, 
		isnull(format(innot_Fecha, 'dd/MM/yyy HH:mm:ss'), '-') 'fecha_proceso_notas', 
		(select count(1) from web_ra_npro_notasprocesadas where innot_codingre = npro_codinnot) 'notas_procesadas'
		from web_ra_not_penot_periodonotas 
			inner join ra_hpl_horarios_planificacion on hpl_codigo = @codhpl
			left join web_ra_innot_ingresosdenotas on innot_codpenot = penot_codigo and innot_codcil = hpl_codcil and innot_codmai = hpl_codmat and hpl_descripcion = innot_seccion
		where penot_tipo = @penot_tipo and getdate() >= penot_fechaini and getdate() <= penot_fechafin
		group by penot_codigo, penot_tipo, penot_eval, penot_fechaini, penot_fechafin, penot_periodo, innot_Fecha, innot_codingre
	end

	if @opcion = 3
	begin
		-- exec dbo.sp_docente_academia_idiomas @opcion = 3, @codhpl = 60184, @codpenot = 25
		select ciclo, mat_codigo, mat_nombre, row_number() over(order by per_apellidos_nombres) 'numero', per_codigo, per_carnet, carnet_ce, per_codper_padre, per_apellidos_nombres, 
			round(sum([Eval 1]), 2) as 'Eval_1', sum([Eval 2]) as 'Eval_2', sum([Eval 3]) as 'Eval_3', sum([Eval 4]) as 'Eval_4', sum([Eval 5]) as 'Eval_5', 
			max(pon_orden) 'cantidad_evaluaciones', solvente, cuotas_pagas, mai_codigo
		from (
			select concat('0', cil_codcic, '-', cil_anio) 'ciclo', p1.per_codigo, isnull(p2.per_carnet, p1.per_carnet) 'per_carnet', p1.per_carnet 'carnet_ce', 
				p1.per_codigo 'per_codigo_ce', isnull(p2.per_apellidos_nombres, p1.per_apellidos_nombres) 'per_apellidos_nombres', 
				p1.per_codper_padre, pon_codigo, pon_nombre, not_codigo, not_nota, pon_orden, mat_codigo, mat_nombre,
				1 'cuotas_pagas', 1 'solvente', mai_codigo
			from ra_mai_mat_inscritas
				inner join ra_hpl_horarios_planificacion on mai_codhpl = hpl_codigo
				inner join ra_ins_inscripcion on mai_codins = ins_codigo
				inner join ra_per_personas p1 on per_codigo = ins_codper
				left join ra_per_personas p2 on p1.per_codper_padre = p2.per_codigo
				inner join ra_not_notas on not_codmai = mai_codigo
				inner join ra_pom_ponderacion_materia on not_codpom = pom_codigo
				inner join ra_pon_ponderacion on pom_codpon = pon_codigo
				inner join ra_mat_materias on hpl_codmat = mat_codigo
				inner join ra_cil_ciclo on ins_codcil = cil_codigo
			where mai_codhpl = @codhpl-- and p1.per_codigo = 168640 
		) l
		PIVOT (
			sum(not_nota)
			for pon_nombre in ([Eval 1], [Eval 2], [Eval 3], [Eval 4], [Eval 5])
		) as pivo
		group by per_codigo, per_carnet, carnet_ce, per_apellidos_nombres, per_codper_padre, mat_codigo, mat_nombre, solvente, cuotas_pagas, ciclo, mai_codigo
		order by per_apellidos_nombres
	end

	if @opcion = 4--Inserta el encabezado
	begin
		-- exec dbo.sp_docente_academia_idiomas @opcion = 4, @codhpl = 60184, @codpenot = 25, @codemp = 4775, @codcil = 135, @penot_tipo = 'Pregrado-idiomas'
		declare @cabecera int = 0
		declare @codmat varchar(25) = '', @seccion varchar(5) = ''

		select @codingre = concat(trim(hpl_codmat), @codcil, hpl_descripcion, penot_eval, @codemp, penot_codigo), 
			@codmat = trim(hpl_codmat), @seccion = hpl_descripcion
		from web_ra_not_penot_periodonotas 
		inner join ra_hpl_horarios_planificacion on hpl_codigo = @codhpl
		where penot_codigo = @codpenot

		select @cabecera = count(1) from web_ra_innot_ingresosdenotas where innot_codingre = @codingre

		if (@cabecera = 0)
		begin
			insert into web_ra_innot_ingresosdenotas 
			(innot_codpenot,innot_codemp,innot_codmai,innot_seccion,innot_Fecha,innot_codcil,innot_codingre,innot_tipo)
			select @codpenot, @codemp, @codmat, @seccion, getdate(), @codcil,@codingre, @penot_tipo
			select 1 'estado', @codingre 'codingre', 'Encabezado insertado' 'texto_estado'
		end
		else
		begin
			select -1 'estado', @codingre 'codingre', 'Encabezado ya existe' 'texto_estado'
		end
	end
	
	if @opcion = 5
	begin
		-- declare @tbl_npro as tbl_npro
		-- insert into @tbl_npro (npro_evaluado, npro_nota, npro_alumno, npro_codinnot, npro_codmai)
		-- values ('1', 8, 254277, 'A1-1135011477525', 5839428)
		-- exec dbo.sp_docente_academia_idiomas @opcion = 5, @codingre = 'A1-1135011477525', @tbl_npro = @tbl_npro, @codpenot = 25

		declare @cantidad_notas int = 0, @pon_orden int = 0
		select @cantidad_notas = isnull(count(1), 0) from dbo.web_ra_npro_notasprocesadas  where npro_codinnot = @codingre
		select @pon_orden = penot_eval from web_ra_not_penot_periodonotas where penot_codigo = @codpenot

		if @cantidad_notas = 0
		begin
			insert into web_ra_npro_notasprocesadas (npro_evaluado,npro_nota,npro_alumno,npro_codinnot)
			select t.npro_evaluado, t.npro_nota, t.npro_alumno, @codingre from @tbl_npro t

			--select * 
			update n set n.not_nota = t.npro_nota, bandera = 1
			from ra_not_notas n
				inner join @tbl_npro t on n.not_codmai = t.npro_codmai
				inner join ra_pom_ponderacion_materia on not_codpom = pom_codigo
				inner join ra_pon_ponderacion on pom_codpon = pon_codigo and pon_orden = @pon_orden

			select count(1) 'insertados', @codingre 'codingre', 'Detalle insertado' 'texto_estado' from @tbl_npro
		end
		else
		begin
			select @cantidad_notas 'insertados', @codingre 'codingre', 'Detalle no insertado, ya existe' 'texto_estado'
		end
	end

end