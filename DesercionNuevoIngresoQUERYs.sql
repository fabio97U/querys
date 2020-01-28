/*select * from adm_rep_reportes where rep_nombre like '%deser%'
select * from ra_man_grp_hor
select * from ra_tpm_tipo_materias
select * from ra_hpl_horarios_planificacion where hpl_codcil = 119

select emp_codigo, emp_apellidos_nombres from pla_emp_empleado where emp_imparte_clase = 'S' and emp_estado = 'A' order by emp_nombres_apellidos asc
*/
--drop table ra_mattu_materias_tutoradas
create table ra_mattu_materias_tutoradas(
	mattu_codigo int primary key identity(1,1),
	mattu_codhpl int foreign key references ra_hpl_horarios_planificacion,
	mattu_codcil int foreign key references ra_cil_ciclo,
	mattu_codemp int foreign key references pla_emp_empleado, --TUTOR
	mattu_fecha_creacion datetime default getdate()
)
--select * from ra_mattu_materias_tutoradas
insert into ra_mattu_materias_tutoradas (mattu_codhpl, mattu_codcil) values (34505, 119/*, 354*/),(34506, 119/*, 354*/),(34507, 119/*, 354*/),(34508, 119/*, 354*/),(34509, 119/*, 354*/),(34510, 119/*, 354*/),(34450, 119/*, 354*/),(34451, 119/*, 354*/),(34452, 119/*, 354*/),(34453, 119/*, 354*/),(34454, 119/*, 354*/),(34455, 119/*, 354*/),(34707, 119/*, 354*/),(34708, 119/*, 354*/),(34709, 119/*, 354*/),(34710, 119/*, 354*/),(34333, 119/*, 354*/),(34334, 119/*, 354*/),(34335, 119/*, 354*/),(34336, 119/*, 354*/),(34337, 119/*, 354*/),(34338, 119/*, 354*/),(34339, 119/*, 354*/),(34340, 119/*, 354*/),(34341, 119/*, 354*/),(34712, 119/*, 354*/),(34588, 119/*, 354*/),(34361, 119/*, 354*/),(34362, 119/*, 354*/),(34363, 119/*, 354*/),(34364, 119/*, 354*/),(34365, 119/*, 354*/),(34366, 119/*, 354*/),(34367, 119/*, 354*/),(34368, 119/*, 354*/),(34369, 119/*, 354*/),(34370, 119/*, 354*/),(34371, 119/*, 354*/),(34372, 119/*, 354*/),(34373, 119/*, 354*/),(34374, 119/*, 354*/),(34375, 119/*, 354*/),(34376, 119/*, 354*/),(36439, 119/*, 354*/),(34379, 119/*, 354*/),(34380, 119/*, 354*/),(34381, 119/*, 354*/),(34382, 119/*, 354*/),(34383, 119/*, 354*/),(34384, 119/*, 354*/),(38513, 119/*, 354*/),(34410, 119/*, 354*/),(34411, 119/*, 354*/),(34412, 119/*, 354*/),(34441, 119/*, 354*/),(34442, 119/*, 354*/),(34443, 119/*, 354*/),(34444, 119/*, 354*/),(34618, 119/*, 354*/),(34569, 119/*, 354*/),(34570, 119/*, 354*/),(34571, 119/*, 354*/),(34572, 119/*, 354*/),(34573, 119/*, 354*/),(34574, 119/*, 354*/),(34575, 119/*, 354*/),(34578, 119/*, 354*/),(34579, 119/*, 354*/),(34580, 119/*, 354*/),(34581, 119/*, 354*/),(34582, 119/*, 354*/),(34583, 119/*, 354*/),(34584, 119/*, 354*/),(38404, 119/*, 354*/),(34676, 119/*, 354*/),(34677, 119/*, 354*/),(34678, 119/*, 354*/),(34497, 119/*, 354*/),(34498, 119/*, 354*/),(34585, 119/*, 354*/),(34586, 119/*, 354*/),(34587, 119/*, 354*/),(38517, 119/*, 354*/),(34499, 119/*, 354*/),(34500, 119/*, 354*/),(34501, 119/*, 354*/),(34456, 119/*, 354*/),(34457, 119/*, 354*/),(34458, 119/*, 354*/),(34459, 119/*, 354*/),(34460, 119/*, 354*/),(34461, 119/*, 354*/),(34462, 119/*, 354*/),(34463, 119/*, 354*/),(34464, 119/*, 354*/)
--select * from ra_mattu_materias_tutoradas where mattu_codigo = 30

--drop table ra_mattur_materias_tutoradas_restricciones
create table ra_mattur_materias_tutoradas_restricciones(
	mattur_codigo int primary key identity(1,1),
	mattur_codmat varchar(55),
	mattur_excluir int default 1,--Significa que va excluir un carnet en el anilizis
	mattur_incluir int default 0,--Significa que incluir un carnet en el anilizis
	mattur_fecha_creacion datetime default getdate()
)
insert into ra_mattur_materias_tutoradas_restricciones (mattur_codmat, mattur_excluir, mattur_incluir) values('ALG1-E', 0, 1)
--select * from ra_mattur_materias_tutoradas_restricciones

--drop table ra_matturd_materias_tutoradas_restricciones_detalle
create table ra_matturd_materias_tutoradas_restricciones_detalle(
	matturd_codigo int primary key identity(1,1),
	matturd_codmattur int foreign key references ra_mattur_materias_tutoradas_restricciones,
	matturd_car_identificador varchar(5), --hace referencia al campo car_identificador de la tabla ra_car_carreras
)
insert into ra_matturd_materias_tutoradas_restricciones_detalle(matturd_codmattur, matturd_car_identificador) values (1,'27')
--select * from ra_matturd_materias_tutoradas_restricciones_detalle
select * from ra_matturd_materias_tutoradas_restricciones_detalle
inner join ra_mattur_materias_tutoradas_restricciones on matturd_codmattur = mattur_codigo

alter procedure sp_ra_mattur_materias_tutoradas_restricciones
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-07-28 12:51:38.707>
	-- Description: <Realiza el mantemiento a la tabla de las restricciones de las materias tutoradas(ra_mattur_materias_tutoradas_restricciones)>
	-- =============================================
	--sp_ra_mattur_materias_tutoradas_restricciones 1, 119
	--sp_ra_mattur_materias_tutoradas_restricciones 2, 0
	--sp_ra_mattur_materias_tutoradas_restricciones 3, 0, 'ALG1-E'
	--sp_ra_mattur_materias_tutoradas_restricciones 4, 0, '',0, 0, 1
	@opcion int = 0,
	@codcil int = 0,
	@codmat varchar(125) = '',
	
	@excluir int = 0,
	@incluir int = 0,
	@codmattur int = 0,

	@car_identificador varchar(10) = ''
as
begin
	if @opcion = 1--Muestra las materias tutoradas del @codcil 
	begin
		select '0'hpl_codmat, 'Seleccione' 'materia'union
		select distinct hpl_codmat, case hpl_tipo_materia when 'V' then  concat(hpl_codmat, ' - ', mat_nombre,' (Virtual)') else concat(hpl_codmat, ' - ',mat_nombre) end 'materia'--, case hpl_tipo_materia when 'V' then  concat(mat_nombre, '(Virtual)') else mat_nombre end 'materia' , concat(mat_nombre, ' ', tpm_descripcion)
		from ra_mattu_materias_tutoradas
		inner join ra_hpl_horarios_planificacion on hpl_codigo = mattu_codhpl
		inner join ra_mat_materias on hpl_codmat = mat_codigo --and mat_codigo = 'ADM1-E'
		inner join ra_tpm_tipo_materias on tpm_tipo_materia = hpl_tipo_materia
		where mattu_codcil = @codcil and hpl_codmat not in (select mattur_codmat from ra_mattur_materias_tutoradas_restricciones)
	end

	if @opcion = 2 --Muestra todas las materias tutoradas que tienen restricciones
	begin
		select mattur_codigo, mattur_codmat, ltrim(rtrim(mat_nombre)) mat_nombre, mattur_excluir, mattur_incluir, mattur_fecha_creacion 
		from ra_mattur_materias_tutoradas_restricciones 
		inner join ra_mat_materias on mat_codigo = mattur_codmat
	end

	if @opcion = 3--Muestra las restricciones segun el @codmat
	begin
		select mattur_codigo, mattur_codmat, mattur_excluir, mattur_incluir, ltrim(rtrim(mat_nombre)) mat_nombre 
		from ra_mattur_materias_tutoradas_restricciones 
		inner join ra_mat_materias on mat_codigo = mattur_codmat
		where mattur_codmat = @codmat
	end

	if @opcion = 4 --Muestra las carreras que estan bajo la restricciones de @codmat
	begin
		select matturd_codigo, matturd_codmattur,concat(matturd_car_identificador,'-0000-0000') matturd_car_identificador from ra_mattur_materias_tutoradas_restricciones 
		inner join ra_matturd_materias_tutoradas_restricciones_detalle on matturd_codmattur = mattur_codigo
		where matturd_codmattur = @codmattur
	end

	if @opcion = 5 --Inserta una materia a la tabla mattur
	begin
		if not exists (select 1 from ra_mattur_materias_tutoradas_restricciones where mattur_codmat = @codmat)
		begin
			insert into ra_mattur_materias_tutoradas_restricciones(mattur_codmat, mattur_excluir, mattur_incluir)
			values (@codmat, @excluir, @incluir)
			select @@IDENTITY
		end
		else
		begin
			select 0
		end
	end

	if @opcion = 7 --Inserta una carrera a la tabla matturd
	begin
		if not exists (select 1 from ra_matturd_materias_tutoradas_restricciones_detalle where matturd_car_identificador = @car_identificador and matturd_codmattur = @codmattur)
		begin
			insert into ra_matturd_materias_tutoradas_restricciones_detalle(matturd_codmattur, matturd_car_identificador)
			values (@codmattur, @car_identificador)
			select 1
		end
		else
		begin
			select 0
		end
	end
	if @opcion = 6--Devuelve las carreras
	begin
		select car_identificador, concat(car_identificador,'-0000-0000', ' (',car_nombre,')') 'carnet'
		from ra_car_carreras 
		where car_codtde = 1 and car_estado = 'A'
		and car_codigo in(
			 select distinct pla_codcar from ra_plm_planes_materias 
			 inner join ra_pla_planes on pla_codigo = plm_codpla and pla_estado = 'A'
			 where plm_codmat = @codmat
		 )
		 order by car_identificador asc
	end
end



/*
select * from notas 
inner join ra_per_personas on per_codigo = ins_codper and per_codcil_ingreso = 119
where mai_codhpl = 34362
--4547244
--4547426
select dbo.fn_deserto_alumno_materia(4719001, 1)
*/

alter function [dbo].[fn_deserto_alumno_materia] (
	@codmai int,
	@evaluacion int
)
returns int
as
begin
	declare @deserto int = 0
	--declare @n1 real 
	--declare @n2 real 
	--declare @n3 real 
	--declare @n4 real 
	--declare @n5 real
	--declare @prom real
	declare @notas_tiene_0 int
	declare @ceros_maximos_tiene_que_tener int
	set @ceros_maximos_tiene_que_tener = 5 - @evaluacion
	--select --/*not_codmai,*/ 
	----@n1 = round([1],2) /*'1°'*/, 
	----@n2 = round([2],2) /*'2°'*/, 
	----@n3 = round([3],2)/*'3°'*/, 
	----@n4 = round([4],2)/*'4°'*/, 
	----@n5 = round([5],2)/*'5°'*/, 
	----@prom = round(((([1]) +([2])+([3]) +([4])+([5]))/5),2) /*'Prom'*/*/
	--from (
	--	select not_codmai, not_nota, pom_codpon from ra_not_notas 
	--	inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
	--	--inner join ra_mai_mat_inscritas on mai_codigo = not_codmai
	--	where not_codmai in(@codmai)
	--) as l
	--PIVOT(sum(not_nota) FOR pom_codpon IN ( [1], [2], [3], [4], [5] )) as pivo

	select @notas_tiene_0 = count(1) from ra_not_notas 
		inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
		--inner join ra_mai_mat_inscritas on mai_codigo = not_codmai
		where not_codmai in(@codmai) and isnull(not_nota, 0) = 0

		if (@notas_tiene_0 - @ceros_maximos_tiene_que_tener) >= 1
		begin
			set @deserto = 1
		end

	return @deserto
end
/*
select * from ra_plm_planes_materias 
INNER join ra_pla_planes on pla_codigo = plm_codpla
where plm_codmat = 'IED-D'

select * from ra_hpl_horarios_planificacion  
inner join ra_mat_materias on mat_codigo = hpl_codmat
inner join pla_emp_empleado  on hpl_codemp = emp_codigo
where hpl_codcil = 119 and hpl_codmat like '%IED-D%'*/


alter procedure [dbo].[ra_mattu_materias_tutoradas_detalle_general]
    -- =============================================
    -- Author:      <Fabio>
    -- Create date: <2020-01-24>
    -- Description: <Devuele el datelle GENERAL y consolidado de la materia tutorada @codmattu>
    -- =============================================
    -- ra_mattu_materias_tutoradas_detalle_general 191
    @codmattu int = 0
as
begin
	if exists (select 1 from ra_mattu_materias_tutoradas where mattu_codigo = @codmattu)
	begin
		print 'Existe materia tutorada'
		declare @codhpl int = 0
		declare @codcil int = 0
		select @codhpl = mattu_codhpl, @codcil = mattu_codcil from ra_mattu_materias_tutoradas where mattu_codigo = @codmattu
		print '@codhpl ' + cast(@codhpl as varchar(10))
		print '@codcil ' + cast(@codcil as varchar(10))

		---------------------------*---------------------------STRAT *SE REALIZA LAS EXLUCIONES O INCLUSIONES DE CARNETS*
		declare @codmattu_tiene_restriccion int, @excluir int = 0, @incluir int = 0, @codmat varchar(50) = ''
		declare @codcar_restrincciones as table(codcar varchar(10))
		declare @codpers as table (codper int)

		select @codmattu_tiene_restriccion = 1, @excluir = mattur_excluir,  @incluir = mattur_incluir, @codmat = hpl_codmat from ra_mattu_materias_tutoradas
		inner join ra_hpl_horarios_planificacion on hpl_codigo = mattu_codhpl
		inner join ra_mattur_materias_tutoradas_restricciones on mattur_codmat = hpl_codmat
		inner join ra_matturd_materias_tutoradas_restricciones_detalle on mattur_codigo = matturd_codmattur
		--inner join ra_mattur_materias_tutoradas_restricciones on matturd_codmattur = mattur_codigo
		where mattu_codigo = @codmattu--87--@codmattu
		if(isnull(@codmattu_tiene_restriccion, 0) = 0)
		begin
			print '@codmattu: '+cast(@codmattu as varchar(5))+'('+cast(@codmat as varchar(50))+'), NO TIENEN RESTRICCIONES'
			insert into @codpers
			select distinct alc_codper
			from ra_not_notas 
			inner join ra_mai_mat_inscritas on mai_codigo = not_codmai
			inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
			inner join  ra_ins_inscripcion  on ins_codigo = mai_codins
			inner join ra_per_personas on per_codigo = ins_codper and per_codcil_ingreso = @codcil 
			inner join ra_mat_materias on mat_codigo = mai_codmat
			inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
			inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
			inner join ra_car_carreras on car_codigo = pla_codcar
			where ins_codcil = @codcil and mai_codhpl = @codhpl
		end
		else
		begin 
			print '@codmattu: '+cast(@codmattu as varchar(5))+'('+cast(@codmat as varchar(50))+'), TIENEN RESTRICCIONES'
			insert into @codcar_restrincciones
			select matturd_car_identificador from ra_mattu_materias_tutoradas
			inner join ra_hpl_horarios_planificacion on hpl_codigo = mattu_codhpl
			inner join ra_mattur_materias_tutoradas_restricciones on mattur_codmat = hpl_codmat
			inner join ra_matturd_materias_tutoradas_restricciones_detalle on mattur_codigo = matturd_codmattur
			--inner join ra_mattur_materias_tutoradas_restricciones on matturd_codmattur = mattur_codigo
			where mattu_codigo = @codmattu--@codmattu--87
			if @excluir = 1
			begin
				print 'se tiene que excluir las siguientes carreras NOT IN'
				insert into @codpers
				select distinct alc_codper
				from ra_not_notas 
				inner join ra_mai_mat_inscritas on mai_codigo = not_codmai
				inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
				inner join  ra_ins_inscripcion  on ins_codigo = mai_codins
				inner join ra_per_personas on per_codigo = ins_codper and per_codcil_ingreso = @codcil 
				inner join ra_mat_materias on mat_codigo = mai_codmat
				inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
				inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
				inner join ra_car_carreras on car_codigo = pla_codcar
				where ins_codcil = @codcil and mai_codhpl = @codhpl and car_identificador not in (select codcar from @codcar_restrincciones)
			end
			if @incluir = 1
			begin
				print 'se tiene que incluir las siguientes carreras IN'
				insert into @codpers
				select distinct alc_codper
				from ra_not_notas 
				inner join ra_mai_mat_inscritas on mai_codigo = not_codmai
				inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
				inner join  ra_ins_inscripcion  on ins_codigo = mai_codins
				inner join ra_per_personas on per_codigo = ins_codper and per_codcil_ingreso = @codcil 
				inner join ra_mat_materias on mat_codigo = mai_codmat
				inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
				inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
				inner join ra_car_carreras on car_codigo = pla_codcar
				where ins_codcil = @codcil and mai_codhpl = @codhpl and car_identificador in (select codcar from @codcar_restrincciones)
			end
			--select * from @codcar_restrincciones
		end
		---------------------------*---------------------------END *SE REALIZA LAS EXLUCIONES O INCLUSIONES DE CARNETS
		select top 1 @codmattu codmattu, tabla.mai_codmat, tabla.TotalNuevoIngreso 'Inscritos NuevoIngreso', 
		(
		select isnull(count(1),0)
			from ra_ins_inscripcion 
			inner join ra_mai_mat_inscritas on ins_codigo = mai_codins
			inner join ra_per_personas on per_codigo = ins_codper --and per_codcil_ingreso = 119
			inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
			inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
			inner join ra_mattu_materias_tutoradas on mattu_codhpl = mai_codhpl
			where ins_codcil = @codcil and mai_codhpl = @codhpl
		) 'Inscritos totales de la sección'
		from (
			select mai_codmat, count(1) 'TotalNuevoIngreso' from (
				select mai_codmat, case mai_estado when 'R' then 1 else 0 end as ret_mat
				from 
				(
					select distinct per_carnet, per_apellidos_nombres, mai_estado, mai_codmat
					from ra_ins_inscripcion 
					inner join ra_mai_mat_inscritas on ins_codigo = mai_codins
					inner join ra_per_personas on per_codigo = ins_codper and per_codcil_ingreso = @codcil
					inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
					inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
					inner join ra_mattu_materias_tutoradas on mattu_codhpl = mai_codhpl
					where ins_codcil = @codcil and mai_codhpl = @codhpl  and per_codigo in (select codper from @codpers)
				) 
				ta group by per_carnet, per_apellidos_nombres, mai_estado,mai_codmat
			) as x
			group by mai_codmat
		)  as tabla
		order by [Inscritos NuevoIngreso] desc
	end--if exists (select 1 from ra_mattu_materias_tutoradas where mattu_codigo = @codmattu)
	else
		print 'Materia tutorada no existe'
end

ALTER procedure [dbo].[sp_ra_mattu_materias_tutoradas]
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-07-02>
	-- Description: <Realiza el mantenimiento a la tabla ra_mattu_materias_tutoradas >
	-- =============================================
	--sp_ra_mattu_materias_tutoradas 1, 0, 34318, 122, 3, ''	--Muestra las materias tutoradas del @codcil
	--sp_ra_mattu_materias_tutoradas 2, 30, 34318, 122, 3, ''	--Inserta a la tabla ra_mattu_materias_tutoradas
	--sp_ra_mattu_materias_tutoradas 3, 0, 34318, 122, 3, ''	--Muestra las data para exportar a excel de las materias tutoradas del @codcil
	@opcion int = 0,
	@codmattu int = 0,
	@codhpl int = 0,
	@codcil int = 0,
	@codemp int = 0, --TUTOR
	@buscar varchar(1024) = ''
as
begin
	declare @tbl_detalle_inscritos as table(codmattu int, mai_codmat varchar(36), Inscritos_NuevoIngreso int, Inscritos_totales int)
	declare @mattu_codigo int

	if @opcion = 1--Muestra
	begin
		declare mcursor cursor 
		for
		select mattu_codigo from ra_mattu_materias_tutoradas where mattu_codcil = @codcil
		open mcursor 
		fetch next from mcursor into @mattu_codigo
		while @@FETCH_STATUS = 0 
		begin
			insert into @tbl_detalle_inscritos (codmattu, mai_codmat, Inscritos_NuevoIngreso, Inscritos_totales)
			exec ra_mattu_materias_tutoradas_detalle_general @mattu_codigo
			fetch next from mcursor into @mattu_codigo
		end      
		close mcursor  
		deallocate mcursor

		select codmattu, codhpl, codmat, isnull(Inscritos_NuevoIngreso, 0) Inscritos_NuevoIngreso, isnull(Inscritos_totales, 0) Inscritos_totales, Materia, Seccion, codemp_titular, Docente_titular, codemp_tutor, Docente_tutor, mattu_codemp, [Tipo materia], Aula, Facultad, 
		case dias when 'Lu-Mar-Mie-Jue-Vie-Sab-Dom-' then 'Virtual' else dias end dias, horario
		from (
				select distinct mattu_codigo 'codmattu', hpl_codigo 'codhpl', hpl_codmat 'codmat', mat_nombre 'Materia', hpl_descripcion 'Seccion',emp_codigo 'codemp_titular', 
				emp_apellidos_nombres 'Docente_titular',isnull(mattu_codemp,0) codemp_tutor,  
				isnull((select emp_apellidos_nombres from pla_emp_empleado where emp_codigo =mattu_codemp), 'Sin asignar') 'Docente_tutor',
				mattu_codemp, tpm_descripcion 'Tipo materia', aul_nombre_corto 'Aula', fac_nombre 'Facultad',
					(case when hpl_lunes = 'S' then 'Lu-' ELSE '' END + 
					case when hpl_martes = 'S' then 'Mar-' ELSE '' END + 
					case when hpl_miercoles = 'S' then 'Mie-' ELSE '' END + 
					case when hpl_jueves = 'S' then 'Jue-' ELSE '' END + 
					case when hpl_viernes = 'S' then 'Vie-' ELSE '' END + 
					case when hpl_sabado = 'S' then 'Sab-' ELSE '' END + 
					case when hpl_domingo = 'S' then 'Dom-' ELSE '' END) dias, man_nomhor horario,
					
					Inscritos_NuevoIngreso, Inscritos_totales
				from ra_hpl_horarios_planificacion  
				inner join ra_mat_materias on mat_codigo = hpl_codmat
				inner join ra_esc_escuelas  on esc_codigo = mat_codesc 
				inner join ra_fac_facultades on fac_codigo = esc_codfac
				inner join ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia
				inner join ra_man_grp_hor on hpl_codman = man_codigo
				inner join ra_aul_aulas on aul_codigo = hpl_codaul
				left join pla_emp_empleado on emp_codigo = hpl_codemp
				inner join ra_plm_planes_materias on hpl_codmat = plm_codmat and plm_ciclo = 1
				inner join ra_pla_planes  on pla_codigo = plm_codpla and pla_estado = 'A'
				inner join ra_mattu_materias_tutoradas on mattu_codhpl = hpl_codigo
				left join @tbl_detalle_inscritos as tbl on tbl.codmattu = mattu_codigo
				where hpl_codcil = @codcil and
				(
					(ltrim(rtrim(mattu_codigo)) like '%' + case when isnull(ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' else ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )          
						or          
					(ltrim(rtrim(mat_nombre)) like '%' + case when isnull(ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
						or          
					(ltrim(rtrim(hpl_codmat)) like '%' + case when isnull(ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
						or          
					(ltrim(rtrim(hpl_descripcion)) like '%' + case when isnull(ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
						or           
					(ltrim(rtrim(emp_apellidos_nombres)) like '%' + case when isnull(ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
						or           
					(ltrim(rtrim(tpm_descripcion)) like '%' + case when isnull(ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
						or           
					(ltrim(rtrim(man_nomhor)) like '%' + case when isnull(ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
						or           
					(ltrim(rtrim(aul_nombre_corto)) like '%' + case when isnull(ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
						or           
					(ltrim(rtrim(fac_nombre)) like '%' + case when isnull(ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
				)
			
			) as t
			order by Materia
	end

	if @opcion = 2--Inserta
	begin
		if not exists (select 1 from ra_mattu_materias_tutoradas where mattu_codhpl = @codhpl and mattu_codcil = @codcil)
		begin
			insert ra_mattu_materias_tutoradas (mattu_codhpl, mattu_codcil, mattu_codemp) values (@codhpl, @codcil, @codemp)
			select 1
		end
		else
			select -1
	end

	if @opcion = 3 --data para el excel
	begin
		declare mcursor cursor 
		for
		select mattu_codigo from ra_mattu_materias_tutoradas where mattu_codcil = @codcil
		open mcursor 
		fetch next from mcursor into @mattu_codigo
		while @@FETCH_STATUS = 0 
		begin
			insert into @tbl_detalle_inscritos (codmattu, mai_codmat, Inscritos_NuevoIngreso, Inscritos_totales)
			exec ra_mattu_materias_tutoradas_detalle_general @mattu_codigo
			fetch next from mcursor into @mattu_codigo
		end      
		close mcursor  
		deallocate mcursor

		select 
		case dias when 'Lu-Mar-Mie-Jue-Vie-Sab-Dom-' then 'Virtual' else dias end Dias, Horario, codmat 'Codigo de materia', isnull(Inscritos_NuevoIngreso, 0) Inscritos_NuevoIngreso, isnull(Inscritos_totales, 0) Inscritos_totales
		, Materia, Seccion, Docente_titular 'Docente titular', Docente_tutor 'Docente tutor', [Tipo materia]
		from (
				select distinct mattu_codigo 'codmattu', hpl_codigo 'codhpl', hpl_codmat 'codmat', mat_nombre 'Materia', hpl_descripcion 'Seccion',emp_codigo 'codemp_titular', 
				emp_apellidos_nombres 'Docente_titular',isnull(mattu_codemp,0) codemp_tutor,  
				isnull((select emp_apellidos_nombres from pla_emp_empleado where emp_codigo =mattu_codemp), 'Sin asignar') 'Docente_tutor',
				mattu_codemp, tpm_descripcion 'Tipo materia', aul_nombre_corto 'Aula', fac_nombre 'Facultad',
					(case when hpl_lunes = 'S' then 'Lu-' ELSE '' END + 
					case when hpl_martes = 'S' then 'Mar-' ELSE '' END + 
					case when hpl_miercoles = 'S' then 'Mie-' ELSE '' END + 
					case when hpl_jueves = 'S' then 'Jue-' ELSE '' END + 
					case when hpl_viernes = 'S' then 'Vie-' ELSE '' END + 
					case when hpl_sabado = 'S' then 'Sab-' ELSE '' END + 
					case when hpl_domingo = 'S' then 'Dom-' ELSE '' END) dias, man_nomhor horario,
					Inscritos_NuevoIngreso, Inscritos_totales
				from ra_hpl_horarios_planificacion  
				inner join ra_mat_materias on mat_codigo = hpl_codmat
				inner join ra_esc_escuelas  on esc_codigo = mat_codesc 
				inner join ra_fac_facultades on fac_codigo = esc_codfac
				inner join ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia
				inner join ra_man_grp_hor on hpl_codman = man_codigo
				inner join ra_aul_aulas on aul_codigo = hpl_codaul
				left join pla_emp_empleado on emp_codigo = hpl_codemp
				inner join ra_plm_planes_materias on hpl_codmat = plm_codmat and plm_ciclo = 1
				inner join ra_pla_planes  on pla_codigo = plm_codpla and pla_estado = 'A'
				inner join ra_mattu_materias_tutoradas on mattu_codhpl = hpl_codigo
				left join @tbl_detalle_inscritos as tbl on tbl.codmattu = mattu_codigo
				where hpl_codcil = @codcil and
				(
					(ltrim(rtrim(mattu_codigo)) like '%' + case when isnull(ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' else ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )          
						or          
					(ltrim(rtrim(mat_nombre)) like '%' + case when isnull(ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
						or          
					(ltrim(rtrim(hpl_codmat)) like '%' + case when isnull(ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
						or          
					(ltrim(rtrim(hpl_descripcion)) like '%' + case when isnull(ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
						or           
					(ltrim(rtrim(emp_apellidos_nombres)) like '%' + case when isnull(ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
						or           
					(ltrim(rtrim(tpm_descripcion)) like '%' + case when isnull(ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
						or           
					(ltrim(rtrim(man_nomhor)) like '%' + case when isnull(ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
						or           
					(ltrim(rtrim(aul_nombre_corto)) like '%' + case when isnull(ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
						or           
					(ltrim(rtrim(fac_nombre)) like '%' + case when isnull(ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''  else ltrim(rtrim(@buscar))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end )
				)
			
			) as t
			order by Materia
	end
end

select distinct hpl_codigo, concat(ltrim(rtrim(mat_nombre)),  ' sec ', hpl_descripcion, ' (',tpm_descripcion, ')') 'materia'
                                    from ra_hpl_horarios_planificacion  
                                    inner join ra_mat_materias on mat_codigo = hpl_codmat
                                    inner join ra_esc_escuelas  on esc_codigo = mat_codesc 
                                    inner join ra_fac_facultades on fac_codigo = esc_codfac
                                    inner join ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia
                                    inner join ra_man_grp_hor on hpl_codman = man_codigo
                                    inner join ra_aul_aulas on aul_codigo = hpl_codaul
                                    left join pla_emp_empleado on emp_codigo = hpl_codemp
                                    inner join ra_plm_planes_materias on hpl_codmat = plm_codmat and plm_ciclo = 1
                                    inner join ra_pla_planes  on pla_codigo = plm_codpla and pla_estado = 'A'
                                    where hpl_codcil = 119 and hpl_codigo not in (select mattu_codhpl from ra_mattu_materias_tutoradas where mattu_codcil = 119)
									order by 2
/*
select * from ra_mattu_materias_tutoradas 
inner join ra_hpl_horarios_planificacion on mattu_codhpl = hpl_codigo
inner join ra_cil_ciclo on mattu_codcil = cil_codigo
left join pla_emp_empleado on emp_codigo = mattu_codemp
where mattu_codcil = 119

select distinct mattu_codigo 'codmattu', hpl_codigo 'codhpl', hpl_codmat 'codmat', mat_nombre 'Materia', hpl_descripcion 'Seccion',emp_codigo 'codemp_titular', emp_apellidos_nombres 'Docente titular', isnull((select emp_apellidos_nombres from pla_emp_empleado where emp_codigo =mattu_codemp), 'Sin asignar') 'Docente tutor', tpm_descripcion 'Tipo materia', man_nomhor 'Horario', aul_nombre_corto 'Aula', fac_nombre 'Facultad'
from ra_hpl_horarios_planificacion  
inner join ra_mat_materias on mat_codigo = hpl_codmat
inner join ra_esc_escuelas  on esc_codigo = mat_codesc 
inner join ra_fac_facultades on fac_codigo = esc_codfac
inner join ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia
inner join ra_man_grp_hor on hpl_codman = man_codigo
inner join ra_aul_aulas on aul_codigo = hpl_codaul
left join pla_emp_empleado on emp_codigo = hpl_codemp
inner join ra_plm_planes_materias on hpl_codmat = plm_codmat and plm_ciclo = 1
inner join ra_pla_planes  on pla_codigo = plm_codpla and pla_estado = 'A'
inner join ra_mattu_materias_tutoradas on mattu_codhpl = hpl_codigo
where mattu_codigo = 28
order by mat_nombre*/
/*
select distinct hpl_codigo, concat(mat_nombre,  ' sec ', hpl_descripcion)
from ra_hpl_horarios_planificacion  
inner join ra_mat_materias on mat_codigo = hpl_codmat
inner join ra_esc_escuelas  on esc_codigo = mat_codesc 
inner join ra_fac_facultades on fac_codigo = esc_codfac
inner join ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia
inner join ra_man_grp_hor on hpl_codman = man_codigo
inner join ra_aul_aulas on aul_codigo = hpl_codaul
left join pla_emp_empleado on emp_codigo = hpl_codemp
inner join ra_plm_planes_materias on hpl_codmat = plm_codmat and plm_ciclo = 1
inner join ra_pla_planes  on pla_codigo = plm_codpla and pla_estado = 'A'
where hpl_codcil = 119 and hpl_codcil not in (select mattu_codhpl from ra_mattu_materias_tutoradas where mattu_codcil = 119)*/

ALTER procedure [dbo].[ra_mattu_materias_tutoradas_detalle]
    -- =============================================
    -- Author:      <Fabio>
    -- Create date: <2019-07-03>
    -- Description: <Devuele el datelle y consolidado de la materia tutorada @codmattu>
    -- =============================================
    --ra_mattu_materias_tutoradas_detalle 1, 97
    @evaluacion int = 0,
    --@codcil int = 0,
    @codmattu int = 0
as
begin
	if exists (select 1 from ra_mattu_materias_tutoradas where mattu_codigo = @codmattu)
	begin
		print 'Existe materia tutorada'
		declare @codhpl int = 0
		declare @codcil int = 0
		select @codhpl = mattu_codhpl, @codcil = mattu_codcil from ra_mattu_materias_tutoradas where mattu_codigo = @codmattu
		print '@codhpl ' + cast(@codhpl as varchar(10))
		print '@codcil ' + cast(@codcil as varchar(10))

		---------------------------*---------------------------STRAT *SE REALIZA LAS EXLUCIONES O INCLUSIONES DE CARNETS*
		declare @codmattu_tiene_restriccion int, @excluir int = 0, @incluir int = 0, @codmat varchar(50) = ''
		declare @codcar_restrincciones as table(codcar varchar(10))
		declare @codpers as table (codper int)

		select @codmattu_tiene_restriccion = 1, @excluir = mattur_excluir,  @incluir = mattur_incluir, @codmat = hpl_codmat from ra_mattu_materias_tutoradas
		inner join ra_hpl_horarios_planificacion on hpl_codigo = mattu_codhpl
		inner join ra_mattur_materias_tutoradas_restricciones on mattur_codmat = hpl_codmat
		inner join ra_matturd_materias_tutoradas_restricciones_detalle on mattur_codigo = matturd_codmattur
		--inner join ra_mattur_materias_tutoradas_restricciones on matturd_codmattur = mattur_codigo
		where mattu_codigo = @codmattu--87--@codmattu
		if(isnull(@codmattu_tiene_restriccion, 0) = 0)
		begin
			print '@codmattu: '+cast(@codmattu as varchar(5))+'('+cast(@codmat as varchar(50))+'), NO TIENEN RESTRICCIONES'
			insert into @codpers
			select distinct alc_codper
			from ra_not_notas 
			inner join ra_mai_mat_inscritas on mai_codigo = not_codmai
			inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
			inner join  ra_ins_inscripcion  on ins_codigo = mai_codins
			inner join ra_per_personas on per_codigo = ins_codper and per_codcil_ingreso = @codcil 
			inner join ra_mat_materias on mat_codigo = mai_codmat
			inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
			inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
			inner join ra_car_carreras on car_codigo = pla_codcar
			where ins_codcil = @codcil and mai_codhpl = @codhpl
		end
		else
		begin 
			print '@codmattu: '+cast(@codmattu as varchar(5))+'('+cast(@codmat as varchar(50))+'), TIENEN RESTRICCIONES'
			insert into @codcar_restrincciones
			select matturd_car_identificador from ra_mattu_materias_tutoradas
			inner join ra_hpl_horarios_planificacion on hpl_codigo = mattu_codhpl
			inner join ra_mattur_materias_tutoradas_restricciones on mattur_codmat = hpl_codmat
			inner join ra_matturd_materias_tutoradas_restricciones_detalle on mattur_codigo = matturd_codmattur
			--inner join ra_mattur_materias_tutoradas_restricciones on matturd_codmattur = mattur_codigo
			where mattu_codigo = @codmattu--@codmattu--87
			if @excluir = 1
			begin
				print 'se tiene que excluir las siguientes carreras NOT IN'
				insert into @codpers
				select distinct alc_codper
				from ra_not_notas 
				inner join ra_mai_mat_inscritas on mai_codigo = not_codmai
				inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
				inner join  ra_ins_inscripcion  on ins_codigo = mai_codins
				inner join ra_per_personas on per_codigo = ins_codper and per_codcil_ingreso = @codcil 
				inner join ra_mat_materias on mat_codigo = mai_codmat
				inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
				inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
				inner join ra_car_carreras on car_codigo = pla_codcar
				where ins_codcil = @codcil and mai_codhpl = @codhpl and car_identificador not in (select codcar from @codcar_restrincciones)
			end
			if @incluir = 1
			begin
				print 'se tiene que incluir las siguientes carreras IN'
				insert into @codpers
				select distinct alc_codper
				from ra_not_notas 
				inner join ra_mai_mat_inscritas on mai_codigo = not_codmai
				inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
				inner join  ra_ins_inscripcion  on ins_codigo = mai_codins
				inner join ra_per_personas on per_codigo = ins_codper and per_codcil_ingreso = @codcil 
				inner join ra_mat_materias on mat_codigo = mai_codmat
				inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
				inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
				inner join ra_car_carreras on car_codigo = pla_codcar
				where ins_codcil = @codcil and mai_codhpl = @codhpl and car_identificador in (select codcar from @codcar_restrincciones)
			end
			--select * from @codcar_restrincciones
		end
		---------------------------*---------------------------END *SE REALIZA LAS EXLUCIONES O INCLUSIONES DE CARNETS*

		select distinct row_number() over(order by per_apellidos, per_nombres) 'N°', mai_codmat 'codmat',/*@evaluacion 'Evaluacion',  mat_nombre 'Materia',*/ per_carnet 'Carnet', per_apellidos 'Apellidos', per_nombres 'Nombres',case mai_estado when 'I' then 'Inscrita' when 'R' then 'Retirada' else 'Desconocido' end 'Estado', case [deserto] when 0 then 'No' when 1 then 'Si' end 'Deserto',
		round((case when @evaluacion >= 1 then isnull([1],0) else 0 end),2) '1°', 
		round((case when @evaluacion >= 2 then isnull([2],0) else 0 end),2) '2°', 
		round((case when @evaluacion >= 3 then isnull([3],0) else 0 end),2) '3°', 
		round((case when @evaluacion >= 4 then isnull([4],0) else 0 end),2) '4°', 
		round((case when @evaluacion >= 5 then isnull([5],0) else 0 end),2) '5°', 
		round(isnull((
			(
				((case when @evaluacion >= 1 then isnull([1],0) else 0 end))+
				((case when @evaluacion >= 2 then isnull([2],0) else 0 end))+
				((case when @evaluacion >= 3 then isnull([3],0) else 0 end))+
				((case when @evaluacion >= 4 then isnull([4],0) else 0 end))+
				((case when @evaluacion >= 5 then isnull([5],0) else 0 end))
			)/5),0),2) 'Prom',  per_telefono 'Telefono', per_email 'Correo'
		from (
			select distinct mai_codigo, per_carnet, per_apellidos, per_nombres, mai_estado, dbo.fn_deserto_alumno_materia(mai_codigo, @evaluacion) as 'deserto',mai_codmat, mat_nombre, not_codmai, not_nota, pom_codpon, per_telefono, per_email
			from ra_not_notas 
				inner join ra_mai_mat_inscritas on mai_codigo = not_codmai
				inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
				inner join  ra_ins_inscripcion  on ins_codigo = mai_codins
				inner join ra_per_personas on per_codigo = ins_codper and per_codcil_ingreso = @codcil 
				inner join ra_mat_materias on mat_codigo = mai_codmat
				inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
				inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
			where ins_codcil = @codcil and mai_codhpl = @codhpl and per_codigo in (select codper from @codpers)
		) as l
		PIVOT(sum(not_nota) FOR pom_codpon IN ( [1], [2], [3], [4], [5] )) as pivo
		order by per_apellidos, per_nombres, per_telefono, per_email

		select @evaluacion 'Evaluacion', tabla.mai_codmat, tabla.Retirados, round((cast(tabla.Retirados as real) / cast(tabla.TotalNuevoIngreso as real))*100,2) '%Retirados', tabla.Desertados 'No Evaluados', round((cast(tabla.Desertados as real)/ cast(tabla.TotalNuevoIngreso as real))*100,2) '%No Evaluados', tabla.TotalNuevoIngreso 'Inscritos NuevoIngreso', 
		(
		select isnull(count(1),0)
			from ra_ins_inscripcion 
			inner join ra_mai_mat_inscritas on ins_codigo = mai_codins
			inner join ra_per_personas on per_codigo = ins_codper --and per_codcil_ingreso = 119
			inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
			inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
			inner join ra_mattu_materias_tutoradas on mattu_codhpl = mai_codhpl
			where ins_codcil = @codcil and mai_codhpl = @codhpl
		) 'Inscritos totales de la sección'
		from (
			select mai_codmat, sum(ret_mat) 'Retirados', sum(des_alm) 'Desertados', count(1) 'TotalNuevoIngreso' from (
				select mai_codmat, case mai_estado when 'R' then 1 else 0 end as ret_mat, case deserto when 1 then 1 else 0 end as des_alm
				from 
				(
					select distinct per_carnet, per_apellidos_nombres, mai_estado, dbo.fn_deserto_alumno_materia(mai_codigo, @evaluacion) as 'deserto', mai_codmat
					from ra_ins_inscripcion 
					inner join ra_mai_mat_inscritas on ins_codigo = mai_codins
					inner join ra_per_personas on per_codigo = ins_codper and per_codcil_ingreso = @codcil
					inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
					inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
					inner join ra_mattu_materias_tutoradas on mattu_codhpl = mai_codhpl
					where ins_codcil = @codcil and mai_codhpl = @codhpl  and per_codigo in (select codper from @codpers)
				) 
				ta group by per_carnet, per_apellidos_nombres, mai_estado, deserto, mai_codmat
			) as x
			group by mai_codmat
		)  as tabla

		select distinct mattu_codigo 'codmattu', hpl_codmat 'codmat', mat_nombre 'Materia', hpl_descripcion 'Seccion', emp_apellidos_nombres 'Docente titular', isnull((select emp_apellidos_nombres from pla_emp_empleado where emp_codigo =mattu_codemp), 'Sin asignar') 'Docente tutor', tpm_descripcion 'Tipo materia', man_nomhor 'Horario', aul_nombre_corto 'Aula', 
		case when isnull(hpl_lunes,'N') = 'S' then 'L-' else '' end+
		case when isnull(hpl_martes,'N') = 'S' then 'M-' else '' end+
		case when isnull(hpl_miercoles,'N') = 'S' then 'Mi-' else '' end+
		case when isnull(hpl_jueves,'N') = 'S' then 'J-' else '' end+
		case when isnull(hpl_viernes,'N') = 'S' then 'V-' else '' end+
		case when isnull(hpl_sabado,'N') = 'S' then 'S-' else '' end+
		case when isnull(hpl_domingo,'N') = 'S' then 'D-' else '' end 'Dias'
		,fac_nombre 'Facultad'
		from ra_hpl_horarios_planificacion  
		inner join ra_mat_materias on mat_codigo = hpl_codmat
		inner join ra_esc_escuelas  on esc_codigo = mat_codesc 
		inner join ra_fac_facultades on fac_codigo = esc_codfac
		inner join ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia
		inner join ra_man_grp_hor on hpl_codman = man_codigo
		inner join ra_aul_aulas on aul_codigo = hpl_codaul
		left join pla_emp_empleado on emp_codigo = hpl_codemp
		inner join ra_plm_planes_materias on hpl_codmat = plm_codmat and plm_ciclo = 1
		inner join ra_pla_planes  on pla_codigo = plm_codpla and pla_estado = 'A'
		inner join ra_mattu_materias_tutoradas on mattu_codhpl = hpl_codigo
		where mattu_codigo = @codmattu 
		order by mat_nombre
		--where deserto = 1

		if @incluir = 1
		begin
			select concat('Carrera: ', codcar, '-0000-0000') as'Solo se incluyeron los alumnos de las carreras' from @codcar_restrincciones
		end
		else if @excluir = 1
		begin
			select concat('Carrera: ', codcar, '-0000-0000') as'Se excluyeron los alumnos las carreras' from @codcar_restrincciones
		end
		else
		begin
			select 'Se tomaron TODAS las carreras de la materia para este reporte' 'Detalle'  
		end

		select distinct row_number() over(order by per_apellidos, per_nombres) 'N°', mai_codmat 'codmat',/*@evaluacion 'Evaluacion',  mat_nombre 'Materia',*/ per_carnet 'Carnet', per_apellidos 'Apellidos', per_nombres 'Nombres',case mai_estado when 'I' then 'Inscrita' when 'R' then 'Retirada' else 'Desconocido' end 'Estado', case [deserto] when 0 then 'No' when 1 then 'Si' end 'Deserto',
		round((case when @evaluacion >= 1 then isnull([1],0) else 0 end),2) '1°', 
		round((case when @evaluacion >= 2 then isnull([2],0) else 0 end),2) '2°', 
		round((case when @evaluacion >= 3 then isnull([3],0) else 0 end),2) '3°', 
		round((case when @evaluacion >= 4 then isnull([4],0) else 0 end),2) '4°', 
		round((case when @evaluacion >= 5 then isnull([5],0) else 0 end),2) '5°', 
		round(isnull((
			(
				((case when @evaluacion >= 1 then isnull([1],0) else 0 end))+
				((case when @evaluacion >= 2 then isnull([2],0) else 0 end))+
				((case when @evaluacion >= 3 then isnull([3],0) else 0 end))+
				((case when @evaluacion >= 4 then isnull([4],0) else 0 end))+
				((case when @evaluacion >= 5 then isnull([5],0) else 0 end))
			)/5),0),2) 'Prom',  per_telefono 'Telefono', per_email 'Correo'
		from (
			select distinct mai_codigo, per_carnet, per_apellidos, per_nombres, mai_estado, dbo.fn_deserto_alumno_materia(mai_codigo, @evaluacion) as 'deserto',mai_codmat, mat_nombre, not_codmai, not_nota, pom_codpon, per_telefono, per_email
			from ra_not_notas 
				inner join ra_mai_mat_inscritas on mai_codigo = not_codmai
				inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
				inner join  ra_ins_inscripcion  on ins_codigo = mai_codins
				inner join ra_per_personas on per_codigo = ins_codper and per_codcil_ingreso = @codcil 
				inner join ra_mat_materias on mat_codigo = mai_codmat
				inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
				inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
			where ins_codcil = @codcil and mai_codhpl = @codhpl and per_codigo in (select codper from @codpers)
		) as l
		pivot(sum(not_nota) FOR pom_codpon in ( [1], [2], [3], [4], [5] )) as pivo
		where [deserto] = 1
		order by per_apellidos, per_nombres, per_telefono, per_email
	end--if exists (select 1 from ra_mattu_materias_tutoradas where mattu_codigo = @codmattu)
	else
		print 'Materia tutorada no existe'
end

alter procedure ra_mattu_materias_tutoradas_detalle_total_alumnos
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-07-30>
	-- Description: <Devuele el datelle general de los alumnos de la materia tutorada @codmattu>
	-- =============================================
	--ra_mattu_materias_tutoradas_detalle_total_alumnos 5,28
	@evaluacion int = 0,
	--@codcil int = 0,
	@codmattu int = 0
as
begin
	if exists (select 1 from ra_mattu_materias_tutoradas where mattu_codigo = @codmattu)
	begin
		print 'Existe materia tutorada'
		declare @codhpl int = 0
		declare @codcil int = 0
		select @codhpl = mattu_codhpl, @codcil = mattu_codcil from ra_mattu_materias_tutoradas where mattu_codigo = @codmattu
		print '@codhpl ' + cast(@codhpl as varchar(10))
		print '@codcil ' + cast(@codcil as varchar(10))

		select distinct row_number() over(order by per_apellidos, per_nombres) 'N°',mai_codmat 'codmat',/*@evaluacion 'Evaluacion',  mat_nombre 'Materia',*/ per_carnet 'Carnet', per_apellidos 'Apellidos', per_nombres 'Nombres',case mai_estado when 'I' then 'Inscrita' when 'R' then 'Retirada' else 'Desconocido' end 'Estado', case [deserto] when 0 then 'No' when 1 then 'Si' end 'Deserto',
		round((case when @evaluacion >= 1 then isnull([1],0) else 0 end),2) '1°', 
		round((case when @evaluacion >= 2 then isnull([2],0) else 0 end),2) '2°', 
		round((case when @evaluacion >= 3 then isnull([3],0) else 0 end),2) '3°', 
		round((case when @evaluacion >= 4 then isnull([4],0) else 0 end),2) '4°', 
		round((case when @evaluacion >= 5 then isnull([5],0) else 0 end),2) '5°', 
		round(isnull((
						(
							((case when @evaluacion >= 1 then isnull([1],0) else 0 end))+
							((case when @evaluacion >= 2 then isnull([2],0) else 0 end))+
							((case when @evaluacion >= 3 then isnull([3],0) else 0 end))+
							((case when @evaluacion >= 4 then isnull([4],0) else 0 end))+
							((case when @evaluacion >= 5 then isnull([5],0) else 0 end))
						)/5
					),0),2) 'Prom',  per_telefono 'Telefono', per_email 'Correo'
		from (
			select distinct mai_codigo, per_carnet, per_apellidos, per_nombres, mai_estado, dbo.fn_deserto_alumno_materia(mai_codigo, @evaluacion) as 'deserto',mai_codmat, mat_nombre, not_codmai, not_nota, pom_codpon, per_telefono, per_email
			from ra_not_notas 
				inner join ra_mai_mat_inscritas on mai_codigo = not_codmai
				inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
				inner join  ra_ins_inscripcion  on ins_codigo = mai_codins
				inner join ra_per_personas on per_codigo = ins_codper
				inner join ra_mat_materias on mat_codigo = mai_codmat
					inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
					inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
			where ins_codcil = @codcil and mai_codhpl = @codhpl 
		) as l
		PIVOT(sum(not_nota) FOR pom_codpon IN ( [1], [2], [3], [4], [5] )) as pivo
		order by per_apellidos, per_nombres, per_telefono, per_email

	end--if exists (select 1 from ra_mattu_materias_tutoradas where mattu_codigo = @codmattu)
	else
		print 'Materia tutorada no existe'
end

alter procedure [dbo].[rep_alumnos_nuevo_ingreso_desertados]
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-07-03>
	-- Description: <Procedimiento que devuelve la data para el reporte general de las materias tutoradas(algunas pueden tener una restriccion de incluir o excluir carnets de la lista de alumnos) en el ciclo por evaluacion>
	-- =============================================
	-- rep_alumnos_nuevo_ingreso_desertados 120, 5
	@campo0 int = 0, --codcil
	@campo1 int = 0	 --evaluacion
as
begin
	declare @datos as table(hpl_codigo int, hpl_codmat varchar(15),hpl_descripcion varchar(100), mat_nombre varchar(100), emp_apellidos_nombres varchar(105), tpm_descripcion varchar(100), man_nomhor varchar(50), aul_nombre_corto  varchar(60), retirados int, retirados_porcentaje real, desertados int, desertados_porcentaje real, total_nuevo_ingreso int, fac_nombre varchar(60), dias varchar(25), tutor varchar(105), mattu_codigo int, hpl_codcil int)
	declare @hpl_codigo varchar(12)
	declare @hpl_codmat varchar(15)
	declare @hpl_descripcion varchar(100)
	declare @mat_nombre varchar(100)
	declare @emp_apellidos_nombres varchar(105)
	declare @tpm_descripcion varchar(100)
	declare @man_nomhor varchar(50)
	declare @aul_nombre_corto  varchar(60)
	declare @fac_nombre varchar(60)
	declare @dias varchar(25)
	declare @tutor varchar (105)
	declare @mattu_codigo int
	declare @hpl_codcil int

	declare @retirados int = 0
	declare @retirados_porcentaje real = 0.0
	declare @desertados int = 0
	declare @desertados_porcentaje real = 0.0
	declare @total_nuevo_ingreso int = 0

	declare cursor_datos cursor 
	for
		select distinct hpl_codigo, hpl_codmat, hpl_descripcion, mat_nombre, isnull(emp_apellidos_nombres, 'Sin asignar'), tpm_descripcion, man_nomhor, aul_nombre_corto, fac_nombre,
		case when isnull(hpl_lunes,'N') = 'S' then 'L-' else '' end+
		case when isnull(hpl_martes,'N') = 'S' then 'M-' else '' end+
		case when isnull(hpl_miercoles,'N') = 'S' then 'Mi-' else '' end+
		case when isnull(hpl_jueves,'N') = 'S' then 'J-' else '' end+
		case when isnull(hpl_viernes,'N') = 'S' then 'V-' else '' end+
		case when isnull(hpl_sabado,'N') = 'S' then 'S-' else '' end+
		case when isnull(hpl_domingo,'N') = 'S' then 'D-' else '' end dias,
		(select emp_apellidos_nombres from pla_emp_empleado where emp_codigo =mattu_codemp) 'tutor', mattu_codigo, hpl_codcil
		from ra_hpl_horarios_planificacion  
		inner join ra_mat_materias on mat_codigo = hpl_codmat
		inner join ra_esc_escuelas  on esc_codigo = mat_codesc 
		inner join ra_fac_facultades on fac_codigo = esc_codfac
		inner join ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia
		inner join ra_man_grp_hor on hpl_codman = man_codigo
		inner join ra_aul_aulas on aul_codigo = hpl_codaul
		left join pla_emp_empleado on emp_codigo = hpl_codemp
		inner join ra_plm_planes_materias on hpl_codmat = plm_codmat and plm_ciclo = 1
		inner join ra_pla_planes  on pla_codigo = plm_codpla and pla_estado = 'A'
		inner join ra_mattu_materias_tutoradas on mattu_codhpl = hpl_codigo
		where hpl_codcil = @campo0            
	open cursor_datos 
	fetch next from cursor_datos into @hpl_codigo, @hpl_codmat, @hpl_descripcion, @mat_nombre, @emp_apellidos_nombres, @tpm_descripcion, @man_nomhor, @aul_nombre_corto, @fac_nombre, @dias, @tutor, @mattu_codigo, @hpl_codcil
	while @@FETCH_STATUS = 0 
	begin
		---------------------------*---------------------------STRAT *VARIABLES PARA EXLUCIONES O INCLUSIONES DE CARNETS*
		declare @codmattu_tiene_restriccion int = 0, @excluir int = 0, @incluir int = 0, @codmat varchar(50) = ''
		declare @codcar_restrincciones as table(codcar varchar(10))
		declare @codpers as table (codper int)
		---------------------------*---------------------------END *VARIABLES PARA EXLUCIONES O INCLUSIONES DE CARNETS*
		---------------------------*---------------------------STRAT *SE REALIZA LAS EXLUCIONES O INCLUSIONES DE CARNETS*
		select @codmattu_tiene_restriccion = 1, @excluir = mattur_excluir,  @incluir = mattur_incluir, @codmat = hpl_codmat from ra_mattu_materias_tutoradas
		inner join ra_hpl_horarios_planificacion on hpl_codigo = mattu_codhpl
		inner join ra_mattur_materias_tutoradas_restricciones on mattur_codmat = hpl_codmat
		inner join ra_matturd_materias_tutoradas_restricciones_detalle on mattur_codigo = matturd_codmattur
		--inner join ra_mattur_materias_tutoradas_restricciones on matturd_codmattur = mattur_codigo
		where mattu_codigo = @mattu_codigo--87--@codmattu
		if(isnull(@codmattu_tiene_restriccion, 0) = 0)
		begin
			print '@codmattu: '+cast(@mattu_codigo as varchar(5))+'('+cast(@codmat as varchar(50))+'), NO TIENEN RESTRICCIONES'
			insert into @codpers
			select distinct alc_codper
			from ra_not_notas 
			inner join ra_mai_mat_inscritas on mai_codigo = not_codmai
			inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
			inner join  ra_ins_inscripcion  on ins_codigo = mai_codins
			inner join ra_per_personas on per_codigo = ins_codper and per_codcil_ingreso = @hpl_codcil 
			inner join ra_mat_materias on mat_codigo = mai_codmat
			inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
			inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
			inner join ra_car_carreras on car_codigo = pla_codcar
			where ins_codcil = @hpl_codcil and mai_codhpl = @hpl_codigo
		end
		else
		begin 
			print '@codmattu: '+cast(@mattu_codigo as varchar(5))+'('+cast(@codmat as varchar(50))+'), TIENEN RESTRICCIONES'
			insert into @codcar_restrincciones
			select matturd_car_identificador from ra_mattu_materias_tutoradas
			inner join ra_hpl_horarios_planificacion on hpl_codigo = mattu_codhpl
			inner join ra_mattur_materias_tutoradas_restricciones on mattur_codmat = hpl_codmat
			inner join ra_matturd_materias_tutoradas_restricciones_detalle on mattur_codigo = matturd_codmattur
			--inner join ra_mattur_materias_tutoradas_restricciones on matturd_codmattur = mattur_codigo
			where mattu_codigo = @mattu_codigo--@codmattu--87
			if @excluir = 1
			begin
				print 'se tiene que excluir las siguientes carreras NOT IN'
				insert into @codpers
				select distinct alc_codper
				from ra_not_notas 
				inner join ra_mai_mat_inscritas on mai_codigo = not_codmai
				inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
				inner join  ra_ins_inscripcion  on ins_codigo = mai_codins
				inner join ra_per_personas on per_codigo = ins_codper and per_codcil_ingreso = @hpl_codcil 
				inner join ra_mat_materias on mat_codigo = mai_codmat
				inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
				inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
				inner join ra_car_carreras on car_codigo = pla_codcar
				where ins_codcil = @hpl_codcil and mai_codhpl = @hpl_codigo and car_identificador not in (select codcar from @codcar_restrincciones)
			end
			if @incluir = 1
			begin
				print 'se tiene que incluir las siguientes carreras IN'
				insert into @codpers
				select distinct alc_codper
				from ra_not_notas 
				inner join ra_mai_mat_inscritas on mai_codigo = not_codmai
				inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
				inner join  ra_ins_inscripcion  on ins_codigo = mai_codins
				inner join ra_per_personas on per_codigo = ins_codper and per_codcil_ingreso = @hpl_codcil 
				inner join ra_mat_materias on mat_codigo = mai_codmat
				inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
				inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
				inner join ra_car_carreras on car_codigo = pla_codcar
				where ins_codcil = @hpl_codcil and mai_codhpl = @hpl_codigo and car_identificador in (select codcar from @codcar_restrincciones)
			end
			--select * from @codcar_restrincciones
		end
		---------------------------*---------------------------END *SE REALIZA LAS EXLUCIONES O INCLUSIONES DE CARNETS*
		
		set @retirados = 0
		set @retirados_porcentaje = 0.0
		set @desertados = 0
		set @desertados_porcentaje = 0.0
		set @total_nuevo_ingreso = 0
		--SE OPTIONEN LOS RESULTADOS DE LA MATERIA
		select /*tabla.mai_codmat, */top 1 @retirados = tabla.Retirados,
		 @retirados_porcentaje = round(cast(tabla.Retirados as real) / cast(tabla.TotalNuevoIngreso as real),2),
		 @desertados = tabla.Desertados, 
		 @desertados_porcentaje = round(cast(tabla.Desertados as real)/ cast(tabla.TotalNuevoIngreso as real),2), 
		 @total_nuevo_ingreso = tabla.TotalNuevoIngreso from (
		select mai_codmat, sum(ret_mat) 'Retirados', sum(des_alm) 'Desertados', count(1) 'TotalNuevoIngreso' from (
				select mai_codmat, case mai_estado when 'R' then 1 else 0 end as ret_mat, case deserto when 1 then 1 else 0 end as des_alm 
				from 
				(
					select per_carnet, per_apellidos_nombres, mai_estado, dbo.fn_deserto_alumno_materia(mai_codigo, @campo1) as 'deserto', mai_codmat 
					from ra_ins_inscripcion 
					inner join ra_mai_mat_inscritas on ins_codigo = mai_codins
					inner join ra_per_personas on per_codigo = ins_codper --and per_codcil_ingreso = @campo0
					where ins_codcil = @campo0 and mai_codhpl = @hpl_codigo and per_codigo in (select codper from @codpers)
				) 
				ta group by per_carnet,	per_apellidos_nombres,	mai_estado,	deserto, mai_codmat
			) as x
			group by mai_codmat
		)  as tabla
		order by TotalNuevoIngreso desc --PORQUE SI EL ALUMNO SE CAMBIO A VIRTUAL SE CONTARA Y DEVOLVERA DOS ROWS Y LA TOP 1 SERA LA CORRECTA
		--where deserto = 1
		insert into @datos	(hpl_codigo, hpl_codmat, hpl_descripcion, mat_nombre, emp_apellidos_nombres, tpm_descripcion, man_nomhor, aul_nombre_corto, retirados, retirados_porcentaje, desertados, desertados_porcentaje, total_nuevo_ingreso, fac_nombre, dias, tutor, mattu_codigo, hpl_codcil) values
							(@hpl_codigo, @hpl_codmat, @hpl_descripcion, @mat_nombre, @emp_apellidos_nombres, @tpm_descripcion, @man_nomhor, @aul_nombre_corto,@retirados, @retirados_porcentaje * 100, @desertados, @desertados_porcentaje * 100, @total_nuevo_ingreso, @fac_nombre, @dias, isnull(@tutor,'Sin asignar'), @mattu_codigo, @hpl_codcil)

	fetch next from cursor_datos into @hpl_codigo, @hpl_codmat, @hpl_descripcion, @mat_nombre, @emp_apellidos_nombres, @tpm_descripcion, @man_nomhor, @aul_nombre_corto, @fac_nombre, @dias,@tutor, @mattu_codigo, @hpl_codcil
	end        
	close cursor_datos  
	deallocate cursor_datos

	select *, @campo1 'Eva.Nª' from @datos order by mattu_codigo--fac_nombre, mat_nombre
end

alter procedure [dbo].[rep_alumnos_nuevo_ingreso_desertados_detalle_alumnos]
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-08-26>
	-- Description: <Procedimiento que devuelve el detalle general de todos los alumnos de materias tutoradas(algunas pueden tener una restriccion de incluir o excluir carnets de la lista de alumnos) en el ciclo por evaluacion>
	-- =============================================
	-- rep_alumnos_nuevo_ingreso_desertados_detalle_alumnos 120
	@codcil int = 0 --codcil
as
begin
	declare @alumnos_codper as table(codper int, mat_tutoradas varchar(1024), secion varchar(5), codmat varchar(125))

	declare @datos as table(hpl_codigo int, hpl_codmat varchar(15),hpl_descripcion varchar(100), mat_nombre varchar(100), emp_apellidos_nombres varchar(105), tpm_descripcion varchar(100), man_nomhor varchar(50), aul_nombre_corto  varchar(60), retirados int, retirados_porcentaje real, desertados int, desertados_porcentaje real, total_nuevo_ingreso int, fac_nombre varchar(60), dias varchar(25), tutor varchar(105), mattu_codigo int, hpl_codcil int)
	declare @hpl_codigo varchar(12)
	declare @hpl_codmat varchar(15)
	declare @hpl_descripcion varchar(100)
	declare @mat_nombre varchar(100)
	declare @emp_apellidos_nombres varchar(105)
	declare @tpm_descripcion varchar(100)
	declare @man_nomhor varchar(50)
	declare @aul_nombre_corto  varchar(60)
	declare @fac_nombre varchar(60)
	declare @dias varchar(25)
	declare @tutor varchar (105)
	declare @mattu_codigo int
	declare @hpl_codcil int

	declare @retirados int = 0
	declare @retirados_porcentaje real = 0.0
	declare @desertados int = 0
	declare @desertados_porcentaje real = 0.0
	declare @total_nuevo_ingreso int = 0

	declare cursor_datos cursor 
	for
		select distinct hpl_codigo, hpl_codmat, hpl_descripcion, mat_nombre, isnull(emp_apellidos_nombres, 'Sin asignar'), tpm_descripcion, man_nomhor, aul_nombre_corto, fac_nombre,
		case when isnull(hpl_lunes,'N') = 'S' then 'L-' else '' end+
		case when isnull(hpl_martes,'N') = 'S' then 'M-' else '' end+
		case when isnull(hpl_miercoles,'N') = 'S' then 'Mi-' else '' end+
		case when isnull(hpl_jueves,'N') = 'S' then 'J-' else '' end+
		case when isnull(hpl_viernes,'N') = 'S' then 'V-' else '' end+
		case when isnull(hpl_sabado,'N') = 'S' then 'S-' else '' end+
		case when isnull(hpl_domingo,'N') = 'S' then 'D-' else '' end dias,
		(select emp_apellidos_nombres from pla_emp_empleado where emp_codigo =mattu_codemp) 'tutor', mattu_codigo, hpl_codcil
		from ra_hpl_horarios_planificacion  
		inner join ra_mat_materias on mat_codigo = hpl_codmat
		inner join ra_esc_escuelas  on esc_codigo = mat_codesc 
		inner join ra_fac_facultades on fac_codigo = esc_codfac
		inner join ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia
		inner join ra_man_grp_hor on hpl_codman = man_codigo
		inner join ra_aul_aulas on aul_codigo = hpl_codaul
		left join pla_emp_empleado on emp_codigo = hpl_codemp
		inner join ra_plm_planes_materias on hpl_codmat = plm_codmat and plm_ciclo = 1
		inner join ra_pla_planes  on pla_codigo = plm_codpla and pla_estado = 'A'
		inner join ra_mattu_materias_tutoradas on mattu_codhpl = hpl_codigo
		where hpl_codcil = @codcil            
	open cursor_datos 
	fetch next from cursor_datos into @hpl_codigo, @hpl_codmat, @hpl_descripcion, @mat_nombre, @emp_apellidos_nombres, @tpm_descripcion, @man_nomhor, @aul_nombre_corto, @fac_nombre, @dias, @tutor, @mattu_codigo, @hpl_codcil
	while @@FETCH_STATUS = 0 
	begin
		---------------------------*---------------------------STRAT *VARIABLES PARA EXLUCIONES O INCLUSIONES DE CARNETS*
		declare @codmattu_tiene_restriccion int = 0, @excluir int = 0, @incluir int = 0, @codmat varchar(50) = ''
		declare @codcar_restrincciones as table(codcar varchar(10))
		declare @codpers as table (codper int)

		---------------------------*---------------------------END *VARIABLES PARA EXLUCIONES O INCLUSIONES DE CARNETS*
		---------------------------*---------------------------STRAT *SE REALIZA LAS EXLUCIONES O INCLUSIONES DE CARNETS*
		select @codmattu_tiene_restriccion = 1, @excluir = mattur_excluir,  @incluir = mattur_incluir, @codmat = hpl_codmat from ra_mattu_materias_tutoradas
		inner join ra_hpl_horarios_planificacion on hpl_codigo = mattu_codhpl
		inner join ra_mattur_materias_tutoradas_restricciones on mattur_codmat = hpl_codmat
		inner join ra_matturd_materias_tutoradas_restricciones_detalle on mattur_codigo = matturd_codmattur
		--inner join ra_mattur_materias_tutoradas_restricciones on matturd_codmattur = mattur_codigo
		where mattu_codigo = @mattu_codigo--87--@codmattu
		if(isnull(@codmattu_tiene_restriccion, 0) = 0)
		begin
			print '@codmattu: '+cast(@mattu_codigo as varchar(5))+'('+cast(@codmat as varchar(50))+'), NO TIENEN RESTRICCIONES'
			insert into @codpers
			select distinct alc_codper
			from ra_not_notas 
			inner join ra_mai_mat_inscritas on mai_codigo = not_codmai
			inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
			inner join  ra_ins_inscripcion  on ins_codigo = mai_codins
			inner join ra_per_personas on per_codigo = ins_codper and per_codcil_ingreso = @hpl_codcil 
			inner join ra_mat_materias on mat_codigo = mai_codmat
			inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
			inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
			inner join ra_car_carreras on car_codigo = pla_codcar
			where ins_codcil = @hpl_codcil and mai_codhpl = @hpl_codigo
		end
		else
		begin 
			print '@codmattu: '+cast(@mattu_codigo as varchar(5))+'('+cast(@codmat as varchar(50))+'), TIENEN RESTRICCIONES'
			insert into @codcar_restrincciones
			select matturd_car_identificador from ra_mattu_materias_tutoradas
			inner join ra_hpl_horarios_planificacion on hpl_codigo = mattu_codhpl
			inner join ra_mattur_materias_tutoradas_restricciones on mattur_codmat = hpl_codmat
			inner join ra_matturd_materias_tutoradas_restricciones_detalle on mattur_codigo = matturd_codmattur
			--inner join ra_mattur_materias_tutoradas_restricciones on matturd_codmattur = mattur_codigo
			where mattu_codigo = @mattu_codigo--@codmattu--87
			if @excluir = 1
			begin
				print 'se tiene que excluir las siguientes carreras NOT IN'
				insert into @codpers
				select distinct alc_codper
				from ra_not_notas 
				inner join ra_mai_mat_inscritas on mai_codigo = not_codmai
				inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
				inner join  ra_ins_inscripcion  on ins_codigo = mai_codins
				inner join ra_per_personas on per_codigo = ins_codper and per_codcil_ingreso = @hpl_codcil 
				inner join ra_mat_materias on mat_codigo = mai_codmat
				inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
				inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
				inner join ra_car_carreras on car_codigo = pla_codcar
				where ins_codcil = @hpl_codcil and mai_codhpl = @hpl_codigo and car_identificador not in (select codcar from @codcar_restrincciones)
			end
			if @incluir = 1
			begin
				print 'se tiene que incluir las siguientes carreras IN'
				insert into @codpers
				select distinct alc_codper
				from ra_not_notas 
				inner join ra_mai_mat_inscritas on mai_codigo = not_codmai
				inner join ra_pom_ponderacion_materia on pom_codigo = not_codpom
				inner join  ra_ins_inscripcion  on ins_codigo = mai_codins
				inner join ra_per_personas on per_codigo = ins_codper and per_codcil_ingreso = @hpl_codcil 
				inner join ra_mat_materias on mat_codigo = mai_codmat
				inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
				inner join ra_pla_planes on pla_codigo = alc_codpla and mai_codpla = pla_codigo
				inner join ra_car_carreras on car_codigo = pla_codcar
				where ins_codcil = @hpl_codcil and mai_codhpl = @hpl_codigo and car_identificador in (select codcar from @codcar_restrincciones)
			end
			--select * from @codcar_restrincciones
		end
		---------------------------*---------------------------END *SE REALIZA LAS EXLUCIONES O INCLUSIONES DE CARNETS*
		
		insert into @alumnos_codper
		select codper, @mat_nombre, @hpl_descripcion, @hpl_codmat from @codpers
		-- rep_alumnos_nuevo_ingreso_desertados_detalle_alumnos 120, 5
		set @retirados = 0
		set @retirados_porcentaje = 0.0
		set @desertados = 0
		set @desertados_porcentaje = 0.0
		set @total_nuevo_ingreso = 0
		--SE OPTIONEN LOS RESULTADOS DE LA MATERIA
		select /*tabla.mai_codmat, */top 1 @retirados = tabla.Retirados,
		 @retirados_porcentaje = round(cast(tabla.Retirados as real) / cast(tabla.TotalNuevoIngreso as real),2),
		 @desertados = tabla.Desertados, 
		 @desertados_porcentaje = round(cast(tabla.Desertados as real)/ cast(tabla.TotalNuevoIngreso as real),2), 
		 @total_nuevo_ingreso = tabla.TotalNuevoIngreso from (
		select mai_codmat, sum(ret_mat) 'Retirados', sum(des_alm) 'Desertados', count(1) 'TotalNuevoIngreso' from (
				select mai_codmat, case mai_estado when 'R' then 1 else 0 end as ret_mat, case deserto when 1 then 1 else 0 end as des_alm 
				from 
				(
					select per_carnet, per_apellidos_nombres, mai_estado, 0 as 'deserto', mai_codmat 
					from ra_ins_inscripcion 
					inner join ra_mai_mat_inscritas on ins_codigo = mai_codins
					inner join ra_per_personas on per_codigo = ins_codper --and per_codcil_ingreso = @codcil
					where ins_codcil = @codcil and mai_codhpl = @hpl_codigo and per_codigo in (select codper from @codpers) and per_tipo = 'U' 
				) 
				ta group by per_carnet,	per_apellidos_nombres,	mai_estado,	deserto, mai_codmat
			) as x
			group by mai_codmat
		)  as tabla
		order by TotalNuevoIngreso desc
		--where deserto = 1
		insert into @datos	(hpl_codigo, hpl_codmat, hpl_descripcion, mat_nombre, emp_apellidos_nombres, tpm_descripcion, man_nomhor, aul_nombre_corto, retirados, retirados_porcentaje, desertados, desertados_porcentaje, total_nuevo_ingreso, fac_nombre, dias, tutor, mattu_codigo, hpl_codcil) values
							(@hpl_codigo, @hpl_codmat, @hpl_descripcion, @mat_nombre, @emp_apellidos_nombres, @tpm_descripcion, @man_nomhor, @aul_nombre_corto,@retirados, @retirados_porcentaje * 100, @desertados, @desertados_porcentaje * 100, @total_nuevo_ingreso, @fac_nombre, @dias, isnull(@tutor,'Sin asignar'), @mattu_codigo, @hpl_codcil)
		delete from @codpers
	fetch next from cursor_datos into @hpl_codigo, @hpl_codmat, @hpl_descripcion, @mat_nombre, @emp_apellidos_nombres, @tpm_descripcion, @man_nomhor, @aul_nombre_corto, @fac_nombre, @dias,@tutor, @mattu_codigo, @hpl_codcil
	end        
	close cursor_datos  
	deallocate cursor_datos

	select per_codigo 'codper', per_carnet 'Carnet', per_apellidos_nombres 'Apellidos-Nombres',  per_telefono 'Telefono', per_correo_institucional 'Correo institucional', per_email 'Correo Personal', per_email_opcional 'Correo opcional', 'NO ES TUTORADO' 'Estado', '' 'Tuturado en la materia'
	from ra_ins_inscripcion inner join ra_per_personas on per_codigo = ins_codper and ins_codcil = @codcil and per_codcil_ingreso = @codcil and per_codigo not in (select distinct codper from @alumnos_codper) and per_tipo = 'U' 
	union
	select distinct per_codigo, per_carnet, per_apellidos_nombres, per_telefono, per_correo_institucional, per_email, per_email_opcional, 'ES TUTORADO', stuff((
		select concat(',',mat.mat_tutoradas, '(', mat.codmat,')', ',', mat.secion) 
		from @alumnos_codper as mat 
		inner join ra_per_personas as per on per_codigo = p.codper and mat.codper = p.codper and per_codcil_ingreso = @codcil  and per_tipo = 'U' 
		for xml path('')
	),1,1,'')
	from @alumnos_codper as p
	inner join ra_per_personas  on per_codigo = p.codper and per_codcil_ingreso = @codcil  and per_tipo = 'U'
	order by 8 desc, per_apellidos_nombres asc
end