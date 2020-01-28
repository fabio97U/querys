USE [uonline]
GO
/****** Object:  UserDefinedFunction [dbo].[MateriasALetras]    Script Date: 26/11/2019 16:59:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTifIER ON
GO

alter function [dbo].[fn_NumerosALetras]
(
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-11-25 14:33:42.440>
	-- Description: <Devuelve el nombre en letras del numero de materias apribadas>
	-- =============================================
	-- select dbo.fn_NumerosALetras(1)
	@numero money
)
returns varchar(500) as
begin
    declare @cLetras varchar(500),
            @cociente int,
            @resto    money
    if @numero > 999999999.99 
       set @cLetras= 'OVERFLOW:  Valor > 9e8'
    
    if @numero < 0 
       begin
          set @numero = Abs(@numero)
          set @cLetras = '(-) '
       end
    else
        set @cLetras = ''
    
    if @numero = 0
        set @cLetras= 'cero ' 
        
	else if Round(@numero, 2) = 1
        set @cLetras= 'una ' 
    else
	begin
		set @cociente = floor(@numero / 1000000.00)
		set @resto = @numero - @cociente * 1000000.00
		if @cociente > 0 
		begin      	
		if @cociente > 1 
		begin
			set @cLetras = dbo.fn_crufl_Cientos(@cociente)            
			if right(@cociente,1) = 1
				set @cLetras = left(@cLetras,len(@cLetras) - 1)
     
			set @cLetras = @cLetras + ' millones,'
		end
		else
			set @cLetras = 'un millón,'
		end 	        
		set @cociente = floor(@resto / 1000.00)
		set @resto = @resto - (@cociente * 1000.00)
   	        
		if @cociente > 0 
		begin
			if Len(@cLetras) > 0 
				set @cLetras = @cLetras + ' '

			if @cociente > 1 
			begin
				set @cLetras = @cLetras + dbo.fn_crufl_Cientos(@cociente) 
				if right(@cociente,1) = 1
					set @cLetras = left(@cLetras,len(@cLetras) - 1)
				set @cLetras =  @cLetras + ' mil,'
			end
			else
				set @cLetras = @cLetras + 'un mil,'
		end

		set @cociente = floor(@resto)
		set @resto = @resto - @cociente
   	        
		if @cociente > 0 
		begin
		if Len(@cLetras) > 0 
			set @cLetras = @cLetras + ' '

		if @cociente > 1                
		begin
			set @cLetras = @cLetras + dbo.fn_crufl_Cientos(@cociente)
			if right(@cociente, 1) = 1
				set @cLetras = left(@cLetras,len(@cLetras))-- - 1)
		end
		else
			set @cLetras = @cLetras + 'un'
		end
		else 
		begin
			if Len(@cLetras) = 0 
				set @cLetras = 'cero'
		end

		if Len(@cLetras) > 0 
		begin
			if (@numero - cast(@numero / 1000000 as int) * 1000000.00) = 0 
			begin
				set @cLetras = Left(@cLetras, Len(@cLetras) - 1)
				set @cLetras = @cLetras 
			end
			else
			begin
				if @cLetras = 'cero' or @numero >= 2
					set @cLetras = @cLetras 
				else
					set @cLetras = @cLetras 
			end
		end 
   	        
		if @resto > 0 
		set @cLetras = @cLetras 
		else
		set @cLetras = @cLetras 
	end
  return @cLetras
end

create table ra_pct_periodo_ciclos_tde(
    pct_codigo int identity(1,1) primary key,
    pct_codcil int not null,
    pct_coddtde int not null foreign key references col_dtde_detalle_tipo_estudio,
    pct_fecha_inicio datetime not null,
    pct_fecha_fin datetime not null,
    pct_fecha_registro datetime default getdate()
)
--select * from ra_pct_periodo_ciclos_tde
--insert into ra_pct_periodo_ciclos_tde (pct_codcil, pct_coddtde, pct_fecha_inicio, pct_fecha_fin) values (119, 1, '2019-01-20', '2019-06-10'), (119, 2, '2019-01-20', '2019-06-10'), (119, 3, '2019-03-01', '2020-01-10'), (119, 4, '2019-08-01', '2020-06-10')

create procedure mto_ra_pct_periodo_ciclos_tde
	-- =============================================
	-- Author:      <Erik>
	-- Create date: <2019-11-16 15:18:40.130>
	-- Description: <Realiza el mantenimiento a la tabla "ra_pct_periodo_ciclos_tde">
	-- =============================================
	-- mto_ra_pct_periodo_ciclos_tde 3, 0, 0, '', ''
	-- mto_ra_pct_periodo_ciclos_tde 2, 4, 1, 0, '01/10/2019', '10/06/2020'
    @opcion int = 0,
	@pct_codigo int = 0,
    @pct_codcil int = 0,
    @pct_coddtde int = 0,
    @pct_fecha_inicio nvarchar(12) = '',
    @pct_fecha_fin nvarchar(12) = ''
as
begin
	set dateformat dmy;
    if @opcion = 1
    begin
        if not exists (select 1 from ra_pct_periodo_ciclos_tde where pct_codcil = @pct_codcil and pct_coddtde = @pct_coddtde)
        begin
            insert into ra_pct_periodo_ciclos_tde(pct_codcil,pct_coddtde,pct_fecha_inicio,pct_fecha_fin)
            values (@pct_codcil,@pct_coddtde,@pct_fecha_inicio,@pct_fecha_fin)
			select @@identity
        end
		else
			select 0
    end

    if @opcion = 2
    begin
        update ra_pct_periodo_ciclos_tde set-- pct_coddtde = @pct_coddtde,
		pct_fecha_inicio = convert(varchar(10), @pct_fecha_inicio, 103),
		pct_fecha_fin= convert(varchar(10), @pct_fecha_fin, 103)
        where pct_codigo = @pct_codigo
    end

    if @opcion = 3
    begin
        select pct_codigo, dtde_nombre, pct_codcil, pct_coddtde, convert(varchar(10), pct_fecha_inicio, 103) pct_fecha_inicio, 
		convert(varchar(10), pct_fecha_fin, 103) pct_fecha_fin, concat('0', cil_codcic, '-',cil_anio) 'ciclo'
		from ra_pct_periodo_ciclos_tde
		inner join col_dtde_detalle_tipo_estudio on dtde_codigo = pct_coddtde
		inner join ra_cil_ciclo on cil_codigo = pct_codcil
		-- where pct_codcil = @pct_codcil
		order by pct_codigo desc
    end

	if @opcion = 4
	begin
		delete from ra_pct_periodo_ciclos_tde where pct_codigo = @pct_codigo
	end
end

use [uonline]
go
/****** object:  storedprocedure [dbo].[rep_boleta_notas_pre_esp]    script date: 19/11/2019 16:22:37 ******/
set ansi_nulls on
go
set quoted_identifier on
go
use [uonline]
go
/****** object:  storedprocedure [dbo].[rep_boleta_notas_pre_esp]    script date: 19/11/2019 16:22:37 ******/
set ansi_nulls on
go
set quoted_identifier on
go

alter procedure [dbo].[rep_boleta_notas_pre_esp] 
	-- =============================================
	-- Author:      <>
	-- Create date: <>
	-- Last modify: Fabio 2019-11-25 11:03:42.008
	-- Description: <Devuelve la data para la generacion de la constacia de notas de la preespecialidad, es invocado por el reporte "rep_boleta_notas_pre_esp.rpt">
	-- =============================================
	--	rep_boleta_notas_pre_esp 1,120, '25-0809-2014'--Henry
	--	rep_boleta_notas_pre_esp 1,120, '25-5067-2014'--Daniela
	--	rep_boleta_notas_pre_esp 1,119, '11-0034-2013'
	@codreg int,
	@codcil int,
	@codper varchar(12) 
as
begin
	set language spanish;
	declare @codigo int ,@codper_cod int
	declare @sexo char(2), @reg_nombre varchar(50)

	select @codper_cod = per_codigo, @sexo = per_sexo from ra_per_personas where per_carnet = @codper
	print '@codper_cod : ' + cast(@codper_cod as nvarchar(10))

	select @reg_nombre = reg_nombre from ra_reg_regionales where reg_codigo = @codreg

	select @codigo = max(imp_codigo) from pg_imp_ins_especializacion where imp_codper = @codper_cod
	print '@codigo: ' + cast(@codigo as nvarchar(10))

	declare @tbl_resultado as table (uni_nombre varchar(125), reg_nombre varchar(50), fac_nombre varchar(125), car_nombre varchar(125), ciclo varchar(25), per_carnet varchar(12), per_nombres_apellidos varchar(60), per_codigo int, pre_nombre varchar(125), mpr_nombre varchar(125), nota float, mpr_orden smallint/*, modulos_aprobados smallint, modulos_reprobados smallint, periodo_comprendido_pre_especialidad varchar(100), promedio float*/, nmp_bandera varchar(10))
	declare @tbl_detalle_tipo_alumno as table (dtde_codigo int, dtde_valor varchar(10))

	if(select count(1) from pg_insm_inscripcion_mod where insm_codper = @codper_cod and insm_codcil = @codcil) > 0
	begin
		print 'if(select count(1) from pg_insm_inscripcion_mod where insm_codper = @codper_cod and insm_codcil = @codcil)>0'

		insert into @tbl_resultado (uni_nombre, reg_nombre, fac_nombre, car_nombre, 
		ciclo, per_carnet, 
		per_nombres_apellidos, per_codigo, pre_nombre, mpr_nombre, nota, mpr_orden, nmp_bandera)
		select ra_uni_universidad.uni_nombre, ra_reg_regionales.reg_nombre, ra_fac_facultades.fac_nombre, pla_alias_carrera as car_nombre, 
			ra_cic_ciclos.cic_nombre + ' - ' + CAST(ra_cil_ciclo.cil_anio AS varchar) AS ciclo, ra_per_personas.per_carnet, 
			ra_per_personas.per_nombres_apellidos, ra_per_personas.per_codigo, pg_pre_preespecializacion.pre_nombre, d.mpr_nombre, ISNULL(b.nmp_nota,0) AS nota,mpr_orden
			--,0 modulos_aprobados, 0 modulos_reprobados, '' periodo_comprendido_pre_especialidad
			,nmp_bandera
		--into #Tbl
		from ra_per_personas inner join
			ra_alc_alumnos_carrera on ra_alc_alumnos_carrera.alc_codper = ra_per_personas.per_codigo inner join
			ra_pla_planes on ra_pla_planes.pla_codigo = ra_alc_alumnos_carrera.alc_codpla inner join
			ra_car_carreras on ra_car_carreras.car_codigo = ra_pla_planes.pla_codcar inner join
			ra_fac_facultades on ra_fac_facultades.fac_codigo = ra_car_carreras.car_codfac inner join
			ra_reg_regionales on ra_reg_regionales.reg_codigo = ra_per_personas.per_codreg inner join
			ra_uni_universidad on ra_uni_universidad.uni_codigo = ra_reg_regionales.reg_coduni inner join
			ra_pgc_pre_esp_carrera on ra_pgc_pre_esp_carrera.pgc_codcar = ra_car_carreras.car_codigo inner join
			pg_pre_preespecializacion on pg_pre_preespecializacion.pre_codigo = ra_pgc_pre_esp_carrera.pgc_codpre inner join
			pg_mpr_modulo_preespecializacion as d on d.mpr_codpre = pg_pre_preespecializacion.pre_codigo inner join
			pg_apr_aut_preespecializacion on pg_apr_aut_preespecializacion.apr_codpre = pg_pre_preespecializacion.pre_codigo inner join
			pg_imp_ins_especializacion as a on a.imp_codapr = pg_apr_aut_preespecializacion.apr_codigo and 
			a.imp_codper = ra_per_personas.per_codigo left outer join
			pg_nmp_notas_mod_especializacion as b on b.nmp_codimp = a.imp_codigo inner join
			ra_cil_ciclo on ra_cil_ciclo.cil_codigo = pg_apr_aut_preespecializacion.apr_codcil inner join
			ra_cic_ciclos on ra_cic_ciclos.cic_codigo = ra_cil_ciclo.cil_codcic inner join
			pg_pmp_ponderacion on pg_pmp_ponderacion.pmp_codigo = b.nmp_codpmp and d.mpr_orden = pg_pmp_ponderacion.pmp_orden
		where (ra_per_personas.per_carnet = @codper) and (pg_apr_aut_preespecializacion.apr_codcil = @codcil) and (d.mpr_visible = 'S')
		--order bY ra_cil_ciclo.cil_anio, ra_cil_ciclo.cil_codcic
		union all
		select '' as uni_nombre, '' as reg_nombre, '' fac_nombre, pla_alias_carrera as car_nombre, 
			ra_cic_ciclos.cic_nombre + ' - ' + CAST(ra_cil_ciclo.cil_anio AS varchar) AS ciclo, ra_per_personas.per_carnet, 
			ra_per_personas.per_nombres_apellidos, ra_per_personas.per_codigo,'General'  as pre_nombre, hm_nombre_mod as mpr_nombre,round(ISNULL(nmp_nota, 
			0),2) AS nota,pmp_orden mpr_orden
			--,0 modulos_aprobados, 0 modulos_reprobados, '' periodo_comprendido_pre_especialidad
			,nmp_bandera
		from (select  * from (select * from  pg_pmp_ponderacion left join (select * from pg_nmp_notas_mod_especializacion where  nmp_codimp = @codigo) t
			on pmp_codigo = t.nmp_codpmp ) a , pg_imp_ins_especializacion where imp_codper=@codper_cod) as r 
			join pg_insm_inscripcion_mod on insm_codper = r.imp_codper and insm_codpmp = r.pmp_orden
			join pg_hm_horarios_mod on hm_codigo = insm_codhm
			join ra_alc_alumnos_carrera on alc_codper = r.imp_codper
			join ra_pla_planes on pla_codigo = alc_codpla
			join ra_car_carreras on car_codigo = pla_codcar
			join ra_cil_ciclo on cil_codigo = insm_codcil
			join ra_cic_ciclos on cil_codcic = cic_codigo
			join ra_per_personas on per_codigo = insm_codper
		where insm_codper = @codper_cod and insm_codcil = @codcil and imp_codigo = @codigo
		union all
		select '' uni_nombre, '' reg_nombre, '' fac_nombre, '' car_nombre, 
			'' ciclo, per_carnet, 
			per_nombres_apellidos, per_codigo, '' pre_nombre,'Promedio' mpr_nombre, round(sum(nota)/8,1) nota,mpr_orden
			--,0 modulos_aprobados, 0 modulos_reprobados, '' periodo_comprendido_pre_especialidad
			,nmp_bandera
		from(
			select distinct ra_uni_universidad.uni_nombre, ra_reg_regionales.reg_nombre,  pla_alias_carrera as car_nombre, 
				ra_cic_ciclos.cic_nombre + ' - ' + CAST(ra_cil_ciclo.cil_anio AS varchar) AS ciclo, ra_per_personas.per_carnet, 
				ra_per_personas.per_nombres_apellidos, ra_per_personas.per_codigo,pg_pre_preespecializacion.pre_codigo as precod, pg_pre_preespecializacion.pre_nombre as codpre, mpr_nombre as mat_nombre,hmp_descripcion hpl_descripcion, round(ISNULL(nmp_nota, 
				0),2) AS nota,(rtrim(imp_codmpr)+ ltrim(pg_hmp_horario_modpre.hmp_descripcion)) as codigotot, mpr_orden
				--,0 modulos_aprobados, 0 modulos_reprobados, '' periodo_comprendido_pre_especialidad
				,nmp_bandera
			from  (select  * from (select * from  pg_pmp_ponderacion left join (select * from pg_nmp_notas_mod_especializacion where  nmp_codimp = @codigo) t
			 on pmp_codigo = t.nmp_codpmp ) a , pg_imp_ins_especializacion where imp_codper=@codper_cod)  r
				inner join pg_apr_aut_preespecializacion on apr_codigo = r.imp_codapr 
				inner join pg_hmp_horario_modpre on hmp_codapr = apr_codigo and hmp_codigo = imp_codhmp
				inner join pg_pre_preespecializacion on pre_codigo = apr_codpre
				inner join pg_pmp_ponderacion on pg_pmp_ponderacion.pmp_codigo = r.pmp_codigo
				inner join pg_mpr_modulo_preespecializacion on mpr_codpre=pre_codigo and mpr_orden = pg_pmp_ponderacion.pmp_orden
				inner join ra_pgc_pre_esp_carrera on pre_codigo=pgc_codpre
				inner join ra_car_carreras on car_codigo = pgc_codcar
				inner join ra_fac_facultades on fac_codigo=car_codfac
				inner join ra_per_personas on per_codigo = imp_codper
				inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
				inner join ra_pla_planes on pla_codigo = alc_codpla
				inner join ra_reg_regionales on per_codreg = reg_codigo
				inner join ra_uni_universidad on uni_codigo = reg_coduni
				inner join ra_cil_ciclo on cil_codigo = apr_codcil
				inner join ra_cic_ciclos on cic_codigo = cil_codcic
			where (ra_per_personas.per_codigo = @codper_cod) and (pg_apr_aut_preespecializacion.apr_codcil  = @codcil) and (mpr_visible = 'S')
			union
			select '' as uni_nombre, '' as reg_nombre, pla_alias_carrera as car_nombre, 
				ra_cic_ciclos.cic_nombre + ' - ' + CAST(ra_cil_ciclo.cil_anio AS varchar) AS ciclo, ra_per_personas.per_carnet, 
				ra_per_personas.per_nombres_apellidos, ra_per_personas.per_codigo,0 as precod,'General'  as codpre, hm_nombre_mod as mat_nombre,hm_descripcion hpl_descripcion, round(ISNULL(nmp_nota, 
				0),2) AS nota,(rtrim(hm_codigo)+ ltrim(hm_descripcion)) as codigotot, pmp_orden mpr_orden
				--,0 modulos_aprobados, 0 modulos_reprobados, '' periodo_comprendido_pre_especialidad
				,nmp_bandera
			from (select  * from (select * from  pg_pmp_ponderacion left join (select * from pg_nmp_notas_mod_especializacion where  nmp_codimp = @codigo) t
			 on pmp_codigo = t.nmp_codpmp ) a , pg_imp_ins_especializacion where imp_codper=@codper_cod) as r 
			join pg_insm_inscripcion_mod on insm_codper = r.imp_codper and insm_codpmp = r.pmp_orden
			join pg_hm_horarios_mod on hm_codigo = insm_codhm
			join ra_alc_alumnos_carrera on alc_codper = r.imp_codper
			join ra_pla_planes on pla_codigo = alc_codpla
			join ra_car_carreras on car_codigo = pla_codcar
			join ra_cil_ciclo on cil_codigo = insm_codcil
			join ra_cic_ciclos on cil_codcic = cic_codigo
			join ra_per_personas on per_codigo = insm_codper
			where insm_codper = @codper_cod and insm_codcil = @codcil 
		) as T
		group by per_carnet, per_nombres_apellidos, per_codigo,mpr_orden,nmp_bandera
		--select * from #Tbl
		--declare @Promedio float, @sumanotas float

		--select @sumanotas = Isnull(sum(nota),0) from @tbl_resultado where pre_nombre <> ''
		--declare @cantidad int
		--declare @nota_final_reporte float
		--declare @promedio_final_reporte float
		--select @nota_final_reporte = sum(nota) from @tbl_resultado where pre_nombre <> '' and nota != 0
		--select @promedio_final_reporte = @nota_final_reporte/(select count(1) from @tbl_resultado where pre_nombre <> '' and nota != 0)

		--set @Promedio = Round(Isnull(@sumanotas / (select count(1) from @tbl_resultado where pre_nombre <> ''),0),1)

		--update @tbl_resultado set nota = @Promedio where mpr_nombre = 'Promedio' and pre_nombre = ''
		--select *,round(@promedio_final_reporte,1) as promedio from @tbl_resultado where pre_nombre <> ''
		--order by mpr_orden
		--	agragado el 24/01/2018 para mostrar solamente el promedio de las asignaturas mayores a cero
		---------------------------------------------------------------------------------------------------------
	end
	else
	begin
	
		insert into @tbl_resultado (uni_nombre, reg_nombre, fac_nombre, car_nombre, 
		ciclo, per_carnet, 
		per_nombres_apellidos, per_codigo, pre_nombre, mpr_nombre, nota, mpr_orden,nmp_bandera)

		select ra_uni_universidad.uni_nombre, ra_reg_regionales.reg_nombre, ra_fac_facultades.fac_nombre, pla_alias_carrera as car_nombre, 
			ra_cic_ciclos.cic_nombre + ' - ' + CAST(ra_cil_ciclo.cil_anio AS varchar) AS ciclo, ra_per_personas.per_carnet, 
			ra_per_personas.per_nombres_apellidos, ra_per_personas.per_codigo, pg_pre_preespecializacion.pre_nombre, d.mpr_nombre, ISNULL(b.nmp_nota, 0) AS nota,mpr_orden
			--,0 modulos_aprobados, 0 modulos_reprobados, '' periodo_comprendido_pre_especialidad
			,nmp_bandera
		from ra_per_personas inner join
			ra_alc_alumnos_carrera on ra_alc_alumnos_carrera.alc_codper = ra_per_personas.per_codigo inner join
			ra_pla_planes on ra_pla_planes.pla_codigo = ra_alc_alumnos_carrera.alc_codpla inner join
			ra_car_carreras on ra_car_carreras.car_codigo = ra_pla_planes.pla_codcar inner join
			ra_fac_facultades on ra_fac_facultades.fac_codigo = ra_car_carreras.car_codfac inner join
			ra_reg_regionales on ra_reg_regionales.reg_codigo = ra_per_personas.per_codreg inner join
			ra_uni_universidad on ra_uni_universidad.uni_codigo = ra_reg_regionales.reg_coduni inner join
			ra_pgc_pre_esp_carrera on ra_pgc_pre_esp_carrera.pgc_codcar = ra_car_carreras.car_codigo inner join
			pg_pre_preespecializacion on pg_pre_preespecializacion.pre_codigo = ra_pgc_pre_esp_carrera.pgc_codpre inner join
			pg_mpr_modulo_preespecializacion as d on d.mpr_codpre = pg_pre_preespecializacion.pre_codigo inner join
			pg_apr_aut_preespecializacion on pg_apr_aut_preespecializacion.apr_codpre = pg_pre_preespecializacion.pre_codigo inner join
			pg_imp_ins_especializacion as a on a.imp_codapr = pg_apr_aut_preespecializacion.apr_codigo and 
			a.imp_codper = ra_per_personas.per_codigo left outer join
			pg_nmp_notas_mod_especializacion as b on b.nmp_codimp = a.imp_codigo inner join
			ra_cil_ciclo on ra_cil_ciclo.cil_codigo = pg_apr_aut_preespecializacion.apr_codcil inner join
			ra_cic_ciclos on ra_cic_ciclos.cic_codigo = ra_cil_ciclo.cil_codcic inner join
			pg_pmp_ponderacion on pg_pmp_ponderacion.pmp_codigo = b.nmp_codpmp and d.mpr_orden = pg_pmp_ponderacion.pmp_orden
		where (ra_per_personas.per_carnet = @codper) and (pg_apr_aut_preespecializacion.apr_codcil = @codcil) and (d.mpr_visible = 'S')

		union all

		select '' as uni_nombre, '' as reg_nombre, '' fac_nombre, pla_alias_carrera as car_nombre, 
			ra_cic_ciclos.cic_nombre + ' - ' + CAST(ra_cil_ciclo.cil_anio AS varchar) AS ciclo, ra_per_personas.per_carnet, 
			ra_per_personas.per_nombres_apellidos, ra_per_personas.per_codigo,'General'  as pre_nombre, hm_nombre_mod as mpr_nombre,round(ISNULL(nmp_nota, 
			0),2) AS nota,pmp_orden mpr_orden
			--,0 modulos_aprobados, 0 modulos_reprobados, '' periodo_comprendido_pre_especialidad
			,nmp_bandera
		from (select  * from (select * from  pg_pmp_ponderacion left join (select * from pg_nmp_notas_mod_especializacion where  nmp_codimp = @codigo) t
			 on pmp_codigo = t.nmp_codpmp ) a , pg_imp_ins_especializacion where imp_codper=@codper_cod) as r 
			join pg_insm_inscripcion_mod on insm_codper = r.imp_codper and insm_codpmp = r.pmp_orden
			join pg_hm_horarios_mod on hm_codigo = insm_codhm
			join ra_alc_alumnos_carrera on alc_codper = r.imp_codper
			join ra_pla_planes on pla_codigo = alc_codpla
			join ra_car_carreras on car_codigo = pla_codcar
			join ra_cil_ciclo on cil_codigo = insm_codcil
			join ra_cic_ciclos on cil_codcic = cic_codigo
			join ra_per_personas on per_codigo = insm_codper
		where insm_codper = @codper_cod and insm_codcil = @codcil and imp_codigo = @codigo
		union all
		select  '' uni_nombre, '' reg_nombre, '' fac_nombre, '' car_nombre, 
			'' ciclo, per_carnet, 
				per_nombres_apellidos, per_codigo, '' pre_nombre,'Promedio' mpr_nombre, round(sum(nota)/6,1) nota,mpr_orden
				--,0 modulos_aprobados, 0 modulos_reprobados, '' periodo_comprendido_pre_especialidad
				,nmp_bandera
		from(
			select distinct ra_uni_universidad.uni_nombre, ra_reg_regionales.reg_nombre,  pla_alias_carrera as car_nombre, 
				ra_cic_ciclos.cic_nombre + ' - ' + CAST(ra_cil_ciclo.cil_anio AS varchar) AS ciclo, ra_per_personas.per_carnet, 
				ra_per_personas.per_nombres_apellidos, ra_per_personas.per_codigo,pg_pre_preespecializacion.pre_codigo as precod, pg_pre_preespecializacion.pre_nombre as codpre, mpr_nombre as mat_nombre,hmp_descripcion hpl_descripcion, round(ISNULL(nmp_nota, 
				0),2) AS nota,(rtrim(imp_codmpr)+ ltrim(pg_hmp_horario_modpre.hmp_descripcion)) as codigotot, mpr_orden
				--,0 modulos_aprobados, 0 modulos_reprobados, '' periodo_comprendido_pre_especialidad
				,nmp_bandera
			from (select  * from (select * from  pg_pmp_ponderacion left join (select * from pg_nmp_notas_mod_especializacion where  nmp_codimp = @codigo) t
				 on pmp_codigo = t.nmp_codpmp ) a , pg_imp_ins_especializacion where imp_codper=@codper_cod)  r
				inner join pg_apr_aut_preespecializacion on apr_codigo = r.imp_codapr 
				inner join pg_hmp_horario_modpre on hmp_codapr = apr_codigo and hmp_codigo = imp_codhmp
				inner join pg_pre_preespecializacion on pre_codigo = apr_codpre
				inner join pg_pmp_ponderacion on pg_pmp_ponderacion.pmp_codigo = r.pmp_codigo
				inner join pg_mpr_modulo_preespecializacion on mpr_codpre=pre_codigo and mpr_orden = pg_pmp_ponderacion.pmp_orden
				inner join ra_pgc_pre_esp_carrera on pre_codigo=pgc_codpre
				inner join ra_car_carreras on car_codigo = pgc_codcar
				inner join ra_fac_facultades on fac_codigo=car_codfac
				inner join ra_per_personas on per_codigo = imp_codper
				inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
				inner join ra_pla_planes on pla_codigo = alc_codpla
				inner join ra_reg_regionales on per_codreg = reg_codigo
				inner join ra_uni_universidad on uni_codigo = reg_coduni
				inner join ra_cil_ciclo on cil_codigo = apr_codcil
				inner join ra_cic_ciclos on cic_codigo = cil_codcic
			where (ra_per_personas.per_codigo = @codper_cod) and (pg_apr_aut_preespecializacion.apr_codcil  = @codcil) and (mpr_visible = 'S')
			union
			select '' as uni_nombre, '' as reg_nombre,  pla_alias_carrera as car_nombre, 
				ra_cic_ciclos.cic_nombre + ' - ' + CAST(ra_cil_ciclo.cil_anio AS varchar) AS ciclo, ra_per_personas.per_carnet, 
				ra_per_personas.per_nombres_apellidos, ra_per_personas.per_codigo,0 as precod,'General'  as codpre, hm_nombre_mod as mat_nombre,hm_descripcion hpl_descripcion, round(ISNULL(nmp_nota, 
				0),2) AS nota,(rtrim(hm_codigo)+ ltrim(hm_descripcion)) as codigotot, pmp_orden mpr_orden
				--,0 modulos_aprobados, 0 modulos_reprobados, '' periodo_comprendido_pre_especialidad
				,nmp_bandera
			from (select  * from (select * from  pg_pmp_ponderacion left join (select * from pg_nmp_notas_mod_especializacion where  nmp_codimp = @codigo) t
			 on pmp_codigo = t.nmp_codpmp ) a , pg_imp_ins_especializacion where imp_codper=@codper_cod) as r 
			join pg_insm_inscripcion_mod on insm_codper = r.imp_codper and insm_codpmp = r.pmp_orden
			join pg_hm_horarios_mod on hm_codigo = insm_codhm
			join ra_alc_alumnos_carrera on alc_codper = r.imp_codper
			join ra_pla_planes on pla_codigo = alc_codpla
			join ra_car_carreras on car_codigo = pla_codcar
			join ra_cil_ciclo on cil_codigo = insm_codcil
			join ra_cic_ciclos on cil_codcic = cic_codigo
			join ra_per_personas on per_codigo = insm_codper
			where insm_codper = @codper_cod and insm_codcil = @codcil
		) as T
		group by per_carnet, per_nombres_apellidos, per_codigo,mpr_orden,nmp_bandera
	end


	declare @Promedio float, @sumanotas float

	select @sumanotas = Isnull(sum(nota),0) from @tbl_resultado where pre_nombre <> ''
	declare @cantidad int
	declare @nota_final_reporte float
	declare @promedio_final_reporte float
	select @nota_final_reporte = sum(nota) from @tbl_resultado where pre_nombre <> '' and nota != 0
	select @promedio_final_reporte = @nota_final_reporte/(select count(1) from @tbl_resultado where pre_nombre <> '' and nota != 0)

	if exists (select 1 from @tbl_resultado where pre_nombre <> '') --Si existe materias inscritas
	begin
		set @Promedio = Round(Isnull(@sumanotas / (select count(1) from @tbl_resultado where pre_nombre <> ''),0),1)

		update @tbl_resultado set nota = @Promedio where mpr_nombre = 'Promedio' and pre_nombre = ''

		declare @mod_reprobados int, @mod_aprobados int, @periodo_comprendido varchar(150)
		declare @mod_reprobados_letras varchar(30), @mod_aprobados_letras varchar(30)
		select @mod_aprobados = count(1) from @tbl_resultado where nota >= 7 and pre_nombre <> '' and nmp_bandera != 0
		select @mod_reprobados = count(1) from @tbl_resultado where nota < 7 and pre_nombre <> '' and nmp_bandera != 0
		
		select @mod_reprobados_letras = dbo.fn_NumerosALetras(@mod_reprobados), @mod_aprobados_letras = dbo.fn_NumerosALetras(@mod_aprobados)
		--select * from ra_pct_periodo_ciclos_tde
		--select * from col_dtde_detalle_tipo_estudio
		insert into @tbl_detalle_tipo_alumno
		exec sp_detalle_tipo_estudio_alumno @codper_cod

		declare @pct_fecha_inicio datetime, @pct_fecha_fin datetime
		select @pct_fecha_inicio = pct_fecha_inicio,
		@pct_fecha_fin = pct_fecha_fin
		from ra_pct_periodo_ciclos_tde where pct_coddtde in (select dtde_codigo from @tbl_detalle_tipo_alumno) and pct_codcil in (@codcil)

		declare @graduado_a varchar(25)
		select @graduado_a = case @sexo when 'F' then 'matriculada' else 'matriculado' end

		select @periodo_comprendido = lower(concat(datename(month, @pct_fecha_inicio), ' ', year(@pct_fecha_inicio))  + ' a ' + concat(datename(month, @pct_fecha_fin), ' ', year(@pct_fecha_fin)))
		--select uni_nombre, reg_nombre, fac_nombre, car_nombre, ciclo, per_carnet, per_nombres_apellidos, per_codigo, 
		--		pre_nombre, mpr_nombre, nota, mpr_orden,round(@promedio_final_reporte,1) as promedio,
		--		sum(aprobo), sum(reprobo), '' periodo_comprendido_pre_especialidad
		--from (
			select * from (
				select uni_nombre, @reg_nombre reg_nombre, fac_nombre, car_nombre, ciclo, per_carnet, per_nombres_apellidos, per_codigo, 
				pre_nombre, mpr_nombre, nota, mpr_orden, round(@promedio_final_reporte,1) as promedio
				, @mod_aprobados modulos_aprobados, @mod_aprobados_letras mod_aprobados_letras, @mod_reprobados modulos_reprobados, @mod_reprobados_letras modulos_reprobados_letras, @periodo_comprendido periodo_comprendido_pre_especialidad,
				case nmp_bandera when 0 then 'No cursada' else case when nota >= 7 then 'Aprobado' else 'Reprobado' end end 'resultado', 
				dbo.fn_crufl_FechaALetras(getdate(), 1, 1) 'fecha_letra', @graduado_a 'res_hom_muj',
				(
					case mpr_orden 
					when '1' then 1 
					when '9' then 2
					when '2' then 3
					when '10' then 4
					when '3' then 5
					when '4' then 6
					when '5' then 7
					when '6' then 8
					end
				)
				'orden_cursado'
				from @tbl_resultado where pre_nombre <> ''
			) t
			order by orden_cursado
			--order by mpr_orden
		--) as tab
	end
end

ALTER proc [dbo].[actnotalumn_gp]
	-- =============================================
	-- Author:      <>
	-- Create date: <>
	-- Last Modify: Fabio 2019-11-28 10:28:20.223
	-- Description: <Realiza la insercion o modificacion de las notas de una seccion de la preespecialidad> select getdate()
	-- =============================================
	 @codapr int,                      
	 @codmpr int,      
	 @codper int,                    
	 @n1 real,      
	 @n2 real,                        
	 @n3 real,                       
	 @n4 real,                        
	 @n5 real,    
	 @n6 real,
	 @nr real,  
	 @ns real,
	 @n9 real,
	 @n10 real,                   
	 @usuario varchar(20)                        
as                   
begin
	begin transaction 
	if @n1 <> 0
	begin
		update pg_nmp_notas_mod_especializacion                        
		set nmp_nota = case when @n1 < 0 then 0 when @n1 > 10 then 0  else @n1 end, nmp_bandera = 1                    
		where nmp_codpmp = 1 
		and   nmp_codimp in (select imp_codigo from pg_imp_ins_especializacion           
		where imp_codapr = @codapr and imp_codhmp = @codmpr and imp_codper = @codper)
	end
	else
	begin
		update pg_nmp_notas_mod_especializacion                        
		set nmp_nota = case when @n1 < 0 then 0 when @n1 > 10 then 0  else @n1 end                
		where nmp_codpmp = 1 
		and   nmp_codimp in (select imp_codigo from pg_imp_ins_especializacion           
		where imp_codapr = @codapr and imp_codhmp = @codmpr and imp_codper = @codper)
	end
           
	if @n2 <> 0
	begin	   
		update pg_nmp_notas_mod_especializacion                        
		set nmp_nota = case when @n2 < 0 then 0 when @n2 > 10 then 0  else @n2 end, nmp_bandera = 1                     
		where nmp_codpmp = 2 
		and   nmp_codimp in (select imp_codigo from pg_imp_ins_especializacion           
		where imp_codapr = @codapr and imp_codhmp = @codmpr and imp_codper = @codper)     
    end
	else
	begin
		update pg_nmp_notas_mod_especializacion                        
		set nmp_nota = case when @n2 < 0 then 0 when @n2 > 10 then 0  else @n2 end                    
		where nmp_codpmp = 2 
		and   nmp_codimp in (select imp_codigo from pg_imp_ins_especializacion           
		where imp_codapr = @codapr and imp_codhmp = @codmpr and imp_codper = @codper)     
	end

	if @n3 <> 0
	begin
		update pg_nmp_notas_mod_especializacion                        
		set nmp_nota = case when @n3 < 0 then 0 when @n3 > 10 then 0  else @n3 end, nmp_bandera = 1                      
		where nmp_codpmp = 3 
		and   nmp_codimp in (select imp_codigo from pg_imp_ins_especializacion           
		where imp_codapr = @codapr and imp_codhmp = @codmpr and imp_codper = @codper)    
	end
	else
	begin
		update pg_nmp_notas_mod_especializacion                        
		set nmp_nota = case when @n3 < 0 then 0 when @n3 > 10 then 0  else @n3 end                        
		where nmp_codpmp = 3 
		and   nmp_codimp in (select imp_codigo from pg_imp_ins_especializacion           
		where imp_codapr = @codapr and imp_codhmp = @codmpr and imp_codper = @codper)  
    end

	if @n4 <> 0
	begin
		update pg_nmp_notas_mod_especializacion                        
		set nmp_nota = case when @n4 < 0 then 0 when @n4 > 10 then 0  else @n4 end, nmp_bandera = 1                        
		where nmp_codpmp = 4 
		and   nmp_codimp in (select imp_codigo from pg_imp_ins_especializacion           
		where imp_codapr = @codapr and imp_codhmp = @codmpr and imp_codper = @codper)   
    end
	else
	begin
		update pg_nmp_notas_mod_especializacion                        
		set nmp_nota = case when @n4 < 0 then 0 when @n4 > 10 then 0  else @n4 end                        
		where nmp_codpmp = 4 
		and   nmp_codimp in (select imp_codigo from pg_imp_ins_especializacion           
		where imp_codapr = @codapr and imp_codhmp = @codmpr and imp_codper = @codper)
	end

	if @n5 <> 0
	begin
		update pg_nmp_notas_mod_especializacion                        
		set nmp_nota = case when @n5 < 0 then 0 when @n5 > 10 then 0  else @n5 end, nmp_bandera = 1                        
		where nmp_codpmp = 5 
		and   nmp_codimp in (select imp_codigo from pg_imp_ins_especializacion           
		where imp_codapr = @codapr and imp_codhmp = @codmpr and imp_codper = @codper)
	end
	else
	begin
		update pg_nmp_notas_mod_especializacion                        
		set nmp_nota = case when @n5 < 0 then 0 when @n5 > 10 then 0  else @n5 end                        
		where nmp_codpmp = 5 
		and   nmp_codimp in (select imp_codigo from pg_imp_ins_especializacion           
		where imp_codapr = @codapr and imp_codhmp = @codmpr and imp_codper = @codper)
	end

	if @n6 <> 0
	begin
		update pg_nmp_notas_mod_especializacion                        
		set nmp_nota = case when @n6 < 0 then 0 when @n6 > 10 then 0  else @n6 end, nmp_bandera = 1                     
		where nmp_codpmp = 6
		and   nmp_codimp in (select imp_codigo from pg_imp_ins_especializacion           
		where imp_codapr = @codapr and imp_codhmp = @codmpr and imp_codper = @codper)
	end
	else
	begin
		update pg_nmp_notas_mod_especializacion                        
		set nmp_nota = case when @n6 < 0 then 0 when @n6 > 10 then 0  else @n6 end                        
		where nmp_codpmp = 6
		and   nmp_codimp in (select imp_codigo from pg_imp_ins_especializacion           
		where imp_codapr = @codapr and imp_codhmp = @codmpr and imp_codper = @codper) 
	end

	if @n9 <> 0
	begin
		update pg_nmp_notas_mod_especializacion                        
		set nmp_nota = case when @n9 < 0 then 0 when @n9 > 10 then 0  else @n9 end, nmp_bandera = 1                        
		where nmp_codpmp = 9
		and   nmp_codimp in (select imp_codigo from pg_imp_ins_especializacion           
		where imp_codapr = @codapr and imp_codhmp = @codmpr and imp_codper = @codper) 
	end
	else
	begin
		update pg_nmp_notas_mod_especializacion                        
		set nmp_nota = case when @n9 < 0 then 0 when @n9 > 10 then 0  else @n9 end                        
		where nmp_codpmp = 9
		and   nmp_codimp in (select imp_codigo from pg_imp_ins_especializacion           
		where imp_codapr = @codapr and imp_codhmp = @codmpr and imp_codper = @codper) 
	end

	if @n10 <> 0
	begin
		update pg_nmp_notas_mod_especializacion                        
		set nmp_nota = case when @n10 < 0 then 0 when @n10 > 10 then 0  else @n10 end, nmp_bandera = 1                        
		where nmp_codpmp = 10
		and   nmp_codimp in (select imp_codigo from pg_imp_ins_especializacion           
		where imp_codapr = @codapr and imp_codhmp = @codmpr and imp_codper = @codper)
	end
	else
	begin
		update pg_nmp_notas_mod_especializacion                        
		set nmp_nota = case when @n10 < 0 then 0 when @n10 > 10 then 0  else @n10 end                        
		where nmp_codpmp = 10
		and   nmp_codimp in (select imp_codigo from pg_imp_ins_especializacion           
		where imp_codapr = @codapr and imp_codhmp = @codmpr and imp_codper = @codper) 
	end

	declare @registro varchar(100), @fecha datetime
	set @fecha = getdate()

	select @registro = cast(@codper as varchar) + ' ' + cast(@n1 as varchar) + ' ' +
	cast(@n2 as varchar) + ' ' +
	cast(@n3 as varchar) + ' ' +
	cast(@n4 as varchar) + ' ' +
	cast(@n5 as varchar) + ' ' +
	cast(@n6 as varchar) + ' '


	exec auditoria_del_sistema 'pg_nmp_notas_mod_especializacion','A',@usuario,@fecha,@registro            
	commit transaction             
	return
end