--drop table pla_nesn_nombre_empleados_segun_nit
create table pla_nesn_nombre_empleados_segun_nit (
	nesn_codigo int primary key identity(1, 1),
	nesn_nit varchar(26),
	nesn_nombre_empleado varchar(255),
	nesn_fecha_creacion datetime default getdate()
)
select * from pla_nesn_nombre_empleados_segun_nit

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2021-01-27 15:10:39.714>
	-- Description: <Generar las inserciones a la tabla ingacum, ejecutar paso a paso opcion por opcion>
	-- =============================================
create procedure sp_migracion_retencion_reten
	@opcion int = 0,
	@anio int = 0
as
begin
	
	if @opcion = 1 -- Llena la tabla ingacum
	begin
		-- exec dbo.sp_migracion_retencion_reten @opcion = 1, @anio = '2020'
		
		--ANTES DE EJECUTAR @opcion = 1
		----AGREGAR LOS CODIGOS 11, con insert into en base al excel proporcionado por conta
			--LIMPIAR EXCEL
			--EJECUTAR EL INSERT INTO DEL EXCEL
			----insert into temp_rep_retenciones_11 (codemp, Nombre, NIT, Monto, Retenido, mes, otros, anio, Codigo) values  ('3610', 'ZURA PERAZA FRANCISCO GUILLERMO', '06141702741046', 180, 18, 6, 0, 2020, 11);

		exec rep_reptencion_impuesto_renta_ingacum 1, @anio--Llena tabla ingacum

		----BORRAR CODIGO 11
		delete from plan_ingacum where anio = @anio and codigoingreso = '11'
		
		delete from temp_rep_retenciones_11 where anio = @anio		
	end

	if @opcion = 2--Inserta codigos 11 a la ingacum
	begin
		-- exec dbo.sp_migracion_retencion_reten @opcion = 2, @anio = '2020'
		declare @tbl_montos as table (
			codemp int, Nombre nvarchar(255), NIT nvarchar(255),
			monto1 float, monto2 float, monto3 float,
			monto4 float, monto5 float, monto6 float,
			monto7 float, monto8 float, monto9 float,
			monto10 float, monto11 float, monto12 float
		)

		declare @tbl_retenidos as table (
			codemp int, Nombre nvarchar(255), NIT nvarchar(255),
			retenido1 float, retenido2 float, retenido3 float,
			retenido4 float, retenido5 float, retenido6 float,
			retenido7 float, retenido8 float, retenido9 float,
			retenido10 float, retenido11 float, retenido12 float
		)
		insert into @tbl_montos (codemp, Nombre, NIT, monto1, monto2, monto3, monto4, monto5, monto6, monto7, monto8, monto9, monto10, monto11, monto12)
		select codemp, Nombre, NIT, sum(isnull([1], 0)) monto1, sum(isnull([2], 0)) monto2, sum(isnull([3], 0)) monto3, sum(isnull([4], 0)) monto4, sum(isnull([5], 0)) monto5, sum(isnull([6], 0)) monto6, sum(isnull([7], 0)) monto7, sum(isnull([8], 0)) monto8, sum(isnull([9], 0)) monto9, sum(isnull([10], 0)) monto10, sum(isnull([11], 0)) monto11, sum(isnull([12], 0)) monto12
		from (
			select Nombre, Codigo, NIT, sum(Monto) monto, sum(Retenido) retenido, otros, anio, mes, codemp 
			from temp_rep_retenciones_11 
			where anio = @anio-- and nit = '06140209640056'
			group by Nombre, Codigo, NIT, otros, anio, mes, codemp
		) l
		PIVOT (
			sum(monto)
			for mes in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
		) as pivo
		group by Nombre, NIT, codemp
		order by Nombre, NIT

		insert into @tbl_retenidos (codemp, Nombre, NIT, retenido1, retenido2, retenido3, retenido4, retenido5, retenido6, retenido7, retenido8, retenido9, retenido10, retenido11, retenido12)
		select codemp,  Nombre, NIT, sum(isnull([1], 0)) retenido1, sum(isnull([2], 0)) retenido2, sum(isnull([3], 0)) retenido3, sum(isnull([4], 0)) retenido4, sum(isnull([5], 0)) retenido5, sum(isnull([6], 0)) retenido6, sum(isnull([7], 0)) retenido7, sum(isnull([8], 0)) retenido8, sum(isnull([9], 0)) retenido9, sum(isnull([10], 0)) retenido10, sum(isnull([11], 0)) retenido11, sum(isnull([12], 0)) retenido12
		from (
			select Nombre, Codigo, NIT, sum(Monto) monto, sum(Retenido) retenido, otros, anio, mes, codemp 
			from temp_rep_retenciones_11 
			where anio = @anio-- and nit = '06140209640056'
			group by Nombre, Codigo, NIT, otros, anio, mes, codemp
		) l
		PIVOT (
			sum(retenido)
			for mes in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
		) as pivo
		group by Nombre, NIT, codemp
		order by Nombre, NIT

		--select *--m.Nombre, m.NIT, count (1) 
		--from @tbl_montos as m
		--inner join @tbl_retenidos as r on r.nit = m.NIT

		--REVISAR DESCUADRES, ROWS 0: TODO BIEN
		--select m.Nombre, m.NIT, count (1) 
		--from @tbl_montos as m
		--inner join @tbl_retenidos as r on r.nit = m.NIT
		----where m.nit = '06140209640056'
		--group by m.Nombre, m.NIT
		--having count(1) > 1

		insert into plan_ingacum 
		(uninombre, codreg, planilla, codemp, nit, nombre, 
		salario, aguinaldo, vacacion, 
		indemnizacion, bonificacion,  
		isss, afp, ipsfa, ivm, 
		anio, codtpl, mes, 
		pla_codtpl, pla_codigo, pla_frecuencia, aguinaldog, 
		otrosgrava, excedente, 
		otros, 
		renta,
		codigoingreso,
		montogravado1, renta1, afp1, 
		montogravado2, renta2, afp2, 
		montogravado3, renta3, afp3, 
		montogravado4, renta4, afp4, 
		montogravado5, renta5, afp5, 
		montogravado6, renta6, afp6, 
		montogravado7, renta7, afp7, 
		montogravado8, renta8, afp8, 
		montogravado9, renta9, afp9, 
		montogravado10, renta10, afp10, 
		montogravado11, renta11, afp11, 
		montogravado12, renta12, afp12)
		select 'UNIVERSIDAD TECNOLOGICA DE EL SALVADOR', 1, null, m.codemp, m.NIT, m.Nombre,
		0, 0, 0, 
		0, 0, 
		0, 0, 0, 0,
		@anio, 0, NULL, 
		NULL, NULL, NULL, 0,
		0, 0, 
		(m.monto1 + m.monto2 + m.monto3 + m.monto4 + m.monto5 + m.monto6 + m.monto7 + m.monto8 + m.monto9 + m.monto10 + m.monto11 + m.monto12),
		(r.retenido1 + r.retenido2 + r.retenido3 + r.retenido4 + r.retenido5 + r.retenido6 + r.retenido7 + r.retenido8 + r.retenido9 + r.retenido10 + r.retenido11 + r.retenido12),
		'11',
		m.monto1, r.retenido1, 0,
		m.monto2, r.retenido2, 0,
		m.monto3, r.retenido3, 0,
		m.monto4, r.retenido4, 0,
		m.monto5, r.retenido5, 0,
		m.monto6, r.retenido6, 0,
		m.monto7, r.retenido7, 0,
		m.monto8, r.retenido8, 0,
		m.monto9, r.retenido9, 0,
		m.monto10, r.retenido10, 0,
		m.monto11, r.retenido11, 0,
		m.monto12, r.retenido12, 0
		from @tbl_montos as m
		inner join @tbl_retenidos as r on r.nit = m.NIT
		order by r.nit
	end

	if @opcion = 3 ---ACTUALIZAR NOMBRES SEGUN BASE INGACUM 2019 A @anio, sino esta NIT en el ingacum 2019 dejar talcual
	begin
		-- exec dbo.sp_migracion_retencion_reten @opcion = 3, @anio = '2020'
		update plan_ingacum set nit = REPLACE(nit, '-', '') where anio = @anio
		update a 
		set a.nombre = b.nombre
		from plan_ingacum a
		inner join
		(
			select b.nesn_nit nit, b.nesn_nombre_empleado nombre from pla_nesn_nombre_empleados_segun_nit b --where anio = '2019'
		) as b on a.nit = b.nit
		where a.anio = @anio and a.nit = b.nit
	end

	if @opcion = 4 --select a la tabla
	begin
		-- exec dbo.sp_migracion_retencion_reten @opcion = 4, @anio = '2020'
		select * from plan_ingacum where anio = @anio--1355
		order by nombre
	end
end


--**INICIO AGREGANDO LOS 11
select replace(nit, '-', '') ,* from plan_ingacum
where anio = 2020 and codigoingreso = '11'
and nit = '0101-220272-101-1'
--and nit in ('06142603671067', '08212708600018')
--codemp: PROVEEDOR

--TODO sobre tabla ingacum:
----BORRAR CODIGO 11
select * from plan_ingacum where anio in ( '2020') 
and nit = '06140202400015'
----AGREGAR LOS CODIGOS 11
----ACTUALIZAR NOMBRES SEGUN BASE INGACUM 2019 a 2020, sino esta NIT en el ingacum 2019 dejar talcual
--**FIN AGREGANDO LOS  11

select * from temp_rep_retenciones_11
--alter table temp_rep_retenciones_11 add codemp int

select * from pla_emp_empleado
--select * from ingacum
select * from plan_ingacum
where codemp in (4289, 4290, 4291
--, 276, 4205
) and anio in (2019, 2020)
order by anio, codemp, renta1

select emp_codtem, emp_codafp, emp_codtpl, * from pla_emp_empleado where emp_codigo in (4289, 4290, 4291)
select * from pla_tem_tipo_empleado

select * from PLA_PGE_PARAMETROS_GEN
select * from pla_dag_detalle_agrupadores
select * from pla_tag_tipo_agrupador
select * from temp_rep_retenciones_01
select * from pla_inn_ingresos
where inn_codemp in (4289, 4290, 4291)

select * from plan_ingacum
where anio = 2020
--and codemp in (4289, 4290, 4291)
order by plan_ingcodigo

--SE MODIFICO, orden y rendimiento, SP´s: 
	--rep_reptencion_impuesto_renta_ingacum
	--ingacum_para_meses_renta


--la tabla: plan_ingacum
--dbo_plan_generarf910 @DEPRECATED, Genera una especie de codigo concatenado las columnas de la tabla
--fn: elimeventuales @DEPRECATED, Eliminar unos registros de la tabla pero esta quemado todo
--plan_generarf910: GENERA UN SELECT DE UNA COLUMNA CON LOS VALORES DE LA TABLA 
--plan_generarf910_con_campos, Se generan los campos de forma independiente NO CONCATEANADOS
--plan_spc_busqueda_ingacum @DEPRECATED, busca por like en algunos campos de la tabla

--plan_spc_ingacum_constancia, genera reporte en base al pla_ingcodigo
--plan_spc_ingacum_constancia_general, genera reporte en base al pla_ingcodigo SI se envia 999999999 los generar para todos por el @anio
--plan_spc_ingacum_constancia_general_por_unidad, genera reporte general por UNIDAD en base al pla_ingcodigo SI se envia 999999999 los generar para todos por el @anio
--plan_spc_ingacum_constancia_individualgenera reporte general por CODEMP en base al pla_ingcodigo SI se envia 999999999 los generar para el empleado por @anio

--rep_reptencion_impuesto_renta_ingacum, LLENA LA TABLA "plan_ingacum"
--rep_reptencion_impuesto_renta_ingacum_mensual @DEPRECATED






USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[ingacum_para_meses_renta]    Script Date: 20/1/2021 21:08:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:		<Juan Carlos Campos>
	-- Create date: <Miercoles 16 Enero 2019>
	-- Last Modify: Fabio, 2021-01-20T17:39:36.608
	-- Description:	<Realizar la estructura requerida por el MH para la declaracion anual de la renta>
	-- =============================================
	--	exec ingacum_para_meses_renta 1, 1, 2018
ALTER PROCEDURE [dbo].[ingacum_para_meses_renta]
	@opcion int,
	@codreg int,
	@anio int
AS
BEGIN
	set nocount on;

	declare @varSql nvarchar(max)
	declare @mes int
	declare @salario_deducible_de_aguinaldo float

	select @salario_deducible_de_aguinaldo = isnull(pge_salario_deducible_de_aguinaldo, 0) 
	from PLA_PGE_PARAMETROS_GEN where pge_codreg = @codreg

	create table #info (
		codemp int, anio int, mes int, ingresos float default 0, aguinaldo float default 0,
		renta float default 0, isss float default 0, afp float default 0, montoGravado float default 0,
		CodigoIngreso nvarchar(5)
	)

	print	'--==Trabajando el codigo "01"==--'
	print 'Obteniendo los ingresos que nos son "Aguinaldos" que se pagaron a los empleados'

	insert into #info (codemp, anio, mes, ingresos, CodigoIngreso)
	select  inn_codemp, pla_anio, month(pla_fecha_pago) as MesPago, round(sum(inn_valor),2) As Ingreso, '01' as codigo
	from pla_inn_ingresos 
		inner join pla_pla_planilla on pla_codigo = inn_codpla and inn_codtpl = pla_codtpl 
		inner join pla_tig_tipo_ingreso on tig_codigo = inn_codtig
	where pla_anio = @anio and /* inn_codemp in (3318, 2906, 2012) and */ inn_codtpl < 15 
		and year(pla_fecha_pago) = @anio and tig_descripcion not in ('Aguinaldos')
	group by inn_codemp, pla_anio, month(pla_fecha_pago)
	
	--	Obteniendo los ingresos en concepto de "Aguinaldos" que se pagaron a los empleados

	update #info set Aguinaldo = round(Monto, 2)
	--Select inn_codemp, pla_anio, MesPago, Monto
	from (
		select inn_codemp, pla_anio, MesPago, codigo,
			case when Aguinaldo <= @salario_deducible_de_aguinaldo then 0 
				 else Aguinaldo - @salario_deducible_de_aguinaldo 
			end As Monto
		from (
			select  inn_codemp, sum(inn_valor) As Aguinaldo, pla_anio, month(pla_fecha_pago) as MesPago, '01' as codigo
			from pla_inn_ingresos inner join pla_pla_planilla on
				pla_codigo = inn_codpla and inn_codtpl = pla_codtpl inner join pla_tig_tipo_ingreso on
				tig_codigo = inn_codtig
			where pla_anio = @anio and /* inn_codemp in (3318, 2906, 2012) and */  inn_codtpl < 15 and year(pla_fecha_pago) = @anio
				and tig_descripcion in ('Aguinaldos')
			group by inn_codemp, pla_anio, month(pla_fecha_pago)
		) As A
	) as B
	inner join #info on codemp = inn_codemp and pla_anio = anio and mes = MesPago and CodigoIngreso = '01'

	--select * from #info where codemp = 273

	print 'Obteniendo los descuentos de Renta, ISSS y AFP aplicados al personal'

	update #info set afp = round(Descuento, 2)
	from #info 
	inner join (
		select dss_codemp, tdc_descripcion, pla_anio, month(pla_fecha_pago) as MesPago, sum(dss_valor) as Descuento
		from pla_dss_descuentos inner join pla_pla_planilla on
			pla_codigo = dss_codpla and dss_codtpl = pla_codtpl inner join pla_tdc_tipo_descuento on
			tdc_codigo = dss_codtdc  
		where pla_anio = @anio and /* inn_codemp in (3318, 2906, 2012) and */  dss_codtpl < 15 and year(pla_fecha_pago) = @anio and dss_codtdc in (2)
		group by dss_codemp, tdc_descripcion, pla_anio, month(pla_fecha_pago) 
	) as A on codemp = dss_codemp and pla_anio = anio and mes = MesPago and CodigoIngreso = '01'

	update #info set isss = round(Descuento, 2)
	from #info 
	inner join (
		select dss_codemp, tdc_descripcion, pla_anio, month(pla_fecha_pago) as MesPago, sum(dss_valor) as Descuento
		from pla_dss_descuentos inner join pla_pla_planilla on
			pla_codigo = dss_codpla and dss_codtpl = pla_codtpl inner join pla_tdc_tipo_descuento on
			tdc_codigo = dss_codtdc  
		where pla_anio = @anio and /* dss_codemp in (3318, 2906, 2012) and */  dss_codtpl < 15 and year(pla_fecha_pago) = @anio and dss_codtdc in (1)
		group by dss_codemp, tdc_descripcion, pla_anio, month(pla_fecha_pago) 
	) as A on codemp = dss_codemp and pla_anio = anio and mes = MesPAgo and CodigoIngreso = '01'

	update #info set renta = round(Descuento, 2)
	from #info 
	inner join (
		select dss_codemp, tdc_descripcion, pla_anio, month(pla_fecha_pago) as MesPago, sum(dss_valor) as Descuento
		from pla_dss_descuentos inner join pla_pla_planilla on
			pla_codigo = dss_codpla and dss_codtpl = pla_codtpl inner join pla_tdc_tipo_descuento on
			tdc_codigo = dss_codtdc  
		where pla_anio = @anio and /* dss_codemp in (3318, 2906, 2012)  and */ dss_codtpl < 15 and year(pla_fecha_pago) = @anio and dss_codtdc in (3)
		group by dss_codemp, tdc_descripcion, pla_anio, month(pla_fecha_pago) 
	) as A on codemp = dss_codemp and pla_anio = anio and mes = MesPAgo and CodigoIngreso = '01' 

	update #info set MontoGravado = round(ingresos + aguinaldo - (afp + isss),2)
	where CodigoIngreso = '01'

	print '--==Trabajando el codigo "60"==--'
	print 'Obteniendo los ingresos que nos son "Aguinaldos" que se pagaron a los empleados'

	insert into #info (codemp, anio, mes, ingresos, CodigoIngreso)
	select inn_codemp, pla_anio, month(pla_fecha_pago) as MesPago, 
		round(sum(inn_valor),2) As Ingreso, '60' as codigo
	from pla_inn_ingresos inner join pla_pla_planilla on
		pla_codigo = inn_codpla and inn_codtpl = pla_codtpl inner join pla_tig_tipo_ingreso on
		tig_codigo = inn_codtig
	where pla_anio = @anio and /* inn_codemp in (3318, 2906, 2012) and */ inn_codtpl < 15 and year(pla_fecha_pago) = @anio
		and tig_descripcion not in ('Aguinaldos')
	group by inn_codemp, pla_anio, month(pla_fecha_pago)
	
	--	Obteniendo los ingresos en concepto de "Aguinaldos" que se pagaron a los empleados
	update #info set Aguinaldo = round(Monto, 2)
	--Select inn_codemp, pla_anio, MesPago, Monto
	from (
		select inn_codemp, pla_anio, MesPago, codigo,
			case when Aguinaldo <= @salario_deducible_de_aguinaldo then 0 
				 else Aguinaldo - @salario_deducible_de_aguinaldo 
			end As Monto
		from (
			select  inn_codemp, sum(inn_valor) As Aguinaldo, pla_anio, month(pla_fecha_pago) as MesPago, '60' as codigo
			from pla_inn_ingresos inner join pla_pla_planilla on
				pla_codigo = inn_codpla and inn_codtpl = pla_codtpl inner join pla_tig_tipo_ingreso on
				tig_codigo = inn_codtig
			where pla_anio = @anio and /* inn_codemp in (3318, 2906, 2012) and */  inn_codtpl < 15 and year(pla_fecha_pago) = @anio
				and tig_descripcion in ('Aguinaldos')
			group by inn_codemp, pla_anio, month(pla_fecha_pago)
		) As A
	) as B
	inner join #info on codemp = inn_codemp and pla_anio = anio and mes = MesPago and CodigoIngreso = '60'

	print 'Obteniendo los descuentos de Renta, ISSS y AFP aplicados al personal'

	update #info set afp = round(Descuento, 2)
	from #info 
	inner join (
		select dss_codemp, tdc_descripcion, pla_anio, month(pla_fecha_pago) as MesPago, sum(dss_valor) as Descuento
		from pla_dss_descuentos inner join pla_pla_planilla on
			pla_codigo = dss_codpla and dss_codtpl = pla_codtpl inner join pla_tdc_tipo_descuento on
			tdc_codigo = dss_codtdc  
		where pla_anio = @anio and /* inn_codemp in (3318, 2906, 2012) and */  dss_codtpl < 15 and year(pla_fecha_pago) = @anio and dss_codtdc in (2)
		group by dss_codemp, tdc_descripcion, pla_anio, month(pla_fecha_pago) 
	) as A on codemp = dss_codemp and pla_anio = anio and mes = MesPago and CodigoIngreso = '60'

	update #info set isss = round(Descuento, 2)
	from #info 
	inner join (
		select dss_codemp, tdc_descripcion, pla_anio, month(pla_fecha_pago) as MesPago, sum(dss_valor) as Descuento
		from pla_dss_descuentos inner join pla_pla_planilla on
			pla_codigo = dss_codpla and dss_codtpl = pla_codtpl inner join pla_tdc_tipo_descuento on
			tdc_codigo = dss_codtdc  
		where pla_anio = @anio and /* dss_codemp in (3318, 2906, 2012) and */  dss_codtpl < 15 and year(pla_fecha_pago) = @anio and dss_codtdc in (1)
		group by dss_codemp, tdc_descripcion, pla_anio, month(pla_fecha_pago) 
	) as A on codemp = dss_codemp and pla_anio = anio and mes = MesPAgo and CodigoIngreso = '60'

	update #info set renta = round(Descuento, 2)
	from #info 
	inner join (
		select dss_codemp, tdc_descripcion, pla_anio, month(pla_fecha_pago) as MesPago, sum(dss_valor) as Descuento
		from pla_dss_descuentos inner join pla_pla_planilla on
			pla_codigo = dss_codpla and dss_codtpl = pla_codtpl inner join pla_tdc_tipo_descuento on
			tdc_codigo = dss_codtdc  
		where pla_anio = @anio and /* dss_codemp in (3318, 2906, 2012)  and */ dss_codtpl < 15 and year(pla_fecha_pago) = @anio and dss_codtdc in (3)
		group by dss_codemp, tdc_descripcion, pla_anio, month(pla_fecha_pago) 
	) as A on codemp = dss_codemp and pla_anio = anio and mes = MesPAgo and CodigoIngreso = '60' 

	update #info set MontoGravado = round(ingresos + aguinaldo - (afp + isss),2)
	where CodigoIngreso = '60'
	------------------------------------------------------------
	set @mes = 1
	while (@mes <= 12)
	begin
		print '@mes : ' + cast(@mes as nvarchar(5))
		set @varSql = '
			update plan_ingacum set 
				montogravado' + cast(@mes as nvarchar(2)) + ' = i.montogravado,
				renta' + cast(@mes as nvarchar(2)) + ' = i.renta,
				afp' + cast(@mes as nvarchar(2)) + ' = i.afp
			from plan_ingacum as p inner join #info as i on 
				p.codemp = i.codemp and p.anio = i.anio -- and p.mes = i.mes 
				and p.codigoingreso = ' + '''' + '01' + '''' +
			' where i.mes = ' + cast(@mes as nvarchar(2)) + ' 
				and p.anio = ' + cast(@anio as nvarchar(4)) + '' 
		print @varSql
		exec (@varSql)

		set @varSql = '
			update plan_ingacum set 
				montogravado' + cast(@mes as nvarchar(2)) + ' = montogravado'  + cast(@mes as nvarchar(2)) + ' + 
					temp_rep_retenciones_01.Salario + temp_rep_retenciones_01.Aguinaldo + temp_rep_retenciones_01.Vacacion - 
					temp_rep_retenciones_01.isss - temp_rep_retenciones_01.afp,
				renta' + cast(@mes as nvarchar(2)) + ' = renta'  + cast(@mes as nvarchar(2)) + ' + temp_rep_retenciones_01.Renta,
				afp' + cast(@mes as nvarchar(2)) + ' = afp'  + cast(@mes as nvarchar(2)) + ' + temp_rep_retenciones_01.afp
			From plan_ingacum inner join temp_rep_retenciones_01 on
				replace(plan_ingacum.nit,' + '''' + '-' + '''' + ',' + '''' + '''' + ') = temp_rep_retenciones_01.nit and plan_ingacum.anio = temp_rep_retenciones_01.anio  
			where plan_ingacum.codigoingreso = ' + '''' + '01' + '''' +
				' and temp_rep_retenciones_01.mes = ' + cast(@mes as nvarchar(2)) + ' 
				and plan_ingacum.anio = ' + cast(@anio as nvarchar(4)) + '' 

		print @varSql
		exec (@varSql)
		SET @mes = @mes + 1
	end
	delete from #info


	print '--==Trabajando el codigo "11"==--'
	insert into #info (codemp, anio, mes, ingresos, CodigoIngreso)
	select inn_codemp, pla_anio, month(pla_fecha_pago) as MesPago, 
		round(sum(inn_valor),2) As Ingreso, '11' as codigo
	from pla_inn_ingresos inner join pla_pla_planilla on
		pla_codigo = inn_codpla and inn_codtpl = pla_codtpl inner join pla_tig_tipo_ingreso on
		tig_codigo = inn_codtig
	where pla_anio = @anio and /* inn_codemp in (3318, 2906, 2012) and */ inn_codtpl >= 15 and year(pla_fecha_pago) = @anio
		--and tig_descripcion not in ('Aguinaldos')
	group by inn_codemp, pla_anio, month(pla_fecha_pago)

	print 'Obteniendo los descuentos de Renta'

	update #info set Renta = round(Descuento,2)
	from #info 
	inner join (
		select dss_codemp, tdc_descripcion, pla_anio, month(pla_fecha_pago) as MesPago, sum(dss_valor) as Descuento
		from pla_dss_descuentos inner join pla_pla_planilla on
			pla_codigo = dss_codpla and dss_codtpl = pla_codtpl inner join pla_tdc_tipo_descuento on
			tdc_codigo = dss_codtdc  
		where pla_anio = @anio and /* inn_codemp in (3318, 2906, 2012) and */  dss_codtpl >= 15 and year(pla_fecha_pago) = @anio and dss_codtdc in (3)
		group by dss_codemp, tdc_descripcion, pla_anio, month(pla_fecha_pago) 
	) as A on codemp = dss_codemp and pla_anio = anio and mes = MesPago and CodigoIngreso = '11'

	--select * from #info where codemp in (3318, 2906, 2012) 

	SET @mes = 1
	WHILE (@mes <= 12)
	BEGIN
		print '@mes : ' + cast(@mes as nvarchar(5))
		set @varSql = '
			update plan_ingacum set 
				montogravado' + cast(@mes as nvarchar(2)) + ' = i.ingresos,
				renta' + cast(@mes as nvarchar(2)) + ' = i.renta				
			from plan_ingacum as p inner join #info as i on 
				p.codemp = i.codemp and p.anio = i.anio -- and p.mes = i.mes 
				and p.codigoingreso = ' + '''' + '11' + '''' +
			' where i.mes = ' + cast(@mes as nvarchar(2)) + ' 
				and p.anio = ' + cast(@anio as nvarchar(4)) + '' 

		print @varSql
		exec (@varSql)

		set @varSql = '
			update plan_ingacum set 
				montogravado' + cast(@mes as nvarchar(2)) + ' = montogravado'  + cast(@mes as nvarchar(2)) + ' + temp_rep_retenciones_11.Monto,
				renta' + cast(@mes as nvarchar(2)) + ' = renta'  + cast(@mes as nvarchar(2)) + ' + temp_rep_retenciones_11.Retenido							
			From plan_ingacum inner join temp_rep_retenciones_11 on
				replace(plan_ingacum.nit,' + '''' + '-' + '''' + ',' + '''' + '''' + ') = temp_rep_retenciones_11.nit and plan_ingacum.anio = temp_rep_retenciones_11.anio  
			where plan_ingacum.codigoingreso = ' + '''' + '11' + '''' +
			' and temp_rep_retenciones_11.mes = ' + cast(@mes as nvarchar(2)) + ' 
				and plan_ingacum.anio = ' + cast(@anio as nvarchar(4)) + ''
		print @varSql
		exec (@varSql)
		set @mes = @mes + 1
	end
	drop table #info

END


USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_reptencion_impuesto_renta_ingacum]    Script Date: 20/1/2021 20:01:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:      <Juan Carlos Campos>
	-- Create date: <>
	-- Last Modify: Fabio, 2021-01-20T17:39:36.608
	-- Description: <Realiza el llenado de la tabla "plan_ingacum">
	-- =============================================
	-- exec rep_reptencion_impuesto_renta_ingacum 1, 2020
ALTER PROCEDURE [dbo].[rep_reptencion_impuesto_renta_ingacum]
	@codreg smallint, 
	@Panio int -- Año en el que se realizara el llenado de la tabla "plan_ingacum"
as
begin
	set nocount on

	declare @salario_deducible_de_aguinaldo float

	Select @salario_deducible_de_aguinaldo = isnull(pge_salario_deducible_de_aguinaldo, 0) 
	from PLA_PGE_PARAMETROS_GEN where pge_codreg = @codreg

	print '@salario_deducible_de_aguinaldo: ' + cast(@salario_deducible_de_aguinaldo as nvarchar(10))
	
	delete from dbo.plan_ingacum where anio = @Panio
	delete from dbo.temp_rep_retenciones_11 where anio = @Panio

	update plan_ingacum set nit = replace(nit, '-', '')

	declare cur_empleados cursor for
	select emp_codigo, uni_nombre, emp_apellidos_nombres, emp_nit, reg_codigo, emp_salario, 
	isnull(emp_codafp, 0) emp_codafp, emp_codtpl,
	case emp_codtem when 4 then '11' else '01' end pcodigoingreso
	from ra_uni_universidad, pla_emp_empleado 
	join (
		select reg_codigo, reg_nombre, reg_coduni 
		from ra_reg_regionales
	)t on reg_codigo = emp_codreg
	join (
		select distinct inn_codemp
		from pla_inn_ingresos, pla_pla_planilla
		where inn_codreg = @codreg and pla_codreg = inn_codreg
		and pla_codtpl = inn_codtpl and pla_codigo = inn_codpla
		and pla_anio = @Panio and inn_valor > 0
	) f1 on emp_codigo = f1.inn_codemp
	where emp_codreg = @codreg 
	and uni_codigo = reg_coduni
	--and emp_codigo in (4289, 4290, 4291)
	order by emp_codigo

	declare @Pcodigoanterior int, @uni_nombre varchar(150),
		@Pplanilla varchar(100), @codemp int,
		@emp_nit varchar(17), @emp_apellidos_nombres varchar(150),
		@Psalario money, @Paguinaldo money,
		@Pvacacion money, @Pindemnizacion money,
		@Pbonificacion money, @Pingresos_cch money,
		@Prenta_cch money, @Prenta money,
		@Pisss money, @emp_codafp int,
		@Pafp money, @Pipsfa money,
		@Pivm money, @emp_codtpl int, @emp_sarlio real,
		@pla_codtpl varchar(10), @pla_codigo int,
		@pla_frecuencia varchar(1), @Pmes int,
		@reg_coduni int, @Paguinaldog money,
		@potros money, @pcodigoingreso varchar(2),
		@potrosingresos money, @Prenta_eventual money
	
	open cur_empleados
	fetch next from cur_empleados into @codemp, @uni_nombre, @emp_apellidos_nombres, @emp_nit, @codreg, 
	@emp_sarlio, @emp_codafp, @emp_codtpl, @pcodigoingreso 
	while @@fetch_status = 0 
	begin
		print '--===**INICIO**===--'
		print 'Codemp : ' + cast(@codemp as nvarchar(8))
		print 'Empleado : ' + cast(@emp_apellidos_nombres as nvarchar(180))

		set @potros = 0
		set @Prenta = 0
		set @potrosingresos = 0
		set @prenta_eventual = 0
		set @Pafp = 0
		set @Pipsfa = 0

		select @Psalario = sum(round(isnull(inn_valor, 0), 2))
		from pla_inn_ingresos, pla_pla_planilla
		where inn_codreg = @codreg and pla_codreg = inn_codreg
		and pla_codtpl = inn_codtpl and pla_codigo = inn_codpla
		and pla_anio = @Panio and inn_codemp = @codemp 
		and inn_codtig in (
			select dag_cod_tig_tdc from pla_dag_detalle_agrupadores
			join pla_tag_tipo_agrupador on tag_codigo = dag_codtag
			where tag_tipo = 'R' and dag_tipo = 'I'
			and dag_codtag  <> 11 and dag_codtag <> 12 and dag_codtag = 4
		)
		and pla_codtpl <12

		select @Potros = sum(round(isnull(inn_valor, 0), 2))
		from pla_inn_ingresos, pla_pla_planilla
		where inn_codreg = @codreg and pla_codreg = inn_codreg
		and pla_codtpl = inn_codtpl and pla_codigo = inn_codpla
		and pla_anio = @Panio and inn_codemp = @codemp 
		and pla_codtpl in(1,3,4,5,6,7,8,9,10,11)
		and inn_codtig in (
			select dag_cod_tig_tdc from pla_dag_detalle_agrupadores
			join pla_tag_tipo_agrupador on tag_codigo = dag_codtag
			where tag_tipo = 'R' and dag_tipo = 'I'
			and dag_codtag  <> 11 and dag_codtag <> 12 and dag_codtag <>4
		)

		select @potrosingresos = isnull(sum(inn_valor),0)
		from pla_inn_ingresos, pla_pla_planilla
		where inn_codreg = @codreg and pla_codreg = inn_codreg
		and pla_codtpl = inn_codtpl and pla_codigo = inn_codpla
		and pla_anio = @Panio and inn_codemp = @codemp 
		and pla_codtpl not in(1,3,4,5,6,7,8,9,10,11)

		select @Paguinaldo = isnull(round(sum(inn_valor), 2),0)
		from pla_inn_ingresos, pla_pla_planilla
		where inn_codreg = @codreg and pla_codreg = inn_codreg
		and pla_codtpl = inn_codtpl and pla_codigo = inn_codpla
		and pla_anio = @Panio and inn_codemp = @codemp 
		and inn_codtig in (
			select dag_cod_tig_tdc from pla_dag_detalle_agrupadores
			join pla_tag_tipo_agrupador on tag_codigo = dag_codtag
			where tag_tipo = 'R' and dag_tipo = 'I' and dag_codtag = 11
		)
		
		print '@Psalario : ' + cast(@Psalario as nvarchar(15))
		print '@Potros : ' + cast(@Potros as nvarchar(15))
		print '@potrosingresos : ' + cast(@potrosingresos as nvarchar(15))
		print '@Paguinaldo : ' + cast(@Paguinaldo as nvarchar(15))
		
		if (@Paguinaldo <= @salario_deducible_de_aguinaldo)--484.8)--608.34
		begin
			set @Paguinaldog = @Paguinaldo 
			set @Paguinaldo = 0 	
		end
		else if(@Paguinaldo > @salario_deducible_de_aguinaldo) -- 484.8)
		begin
			set @Paguinaldog = @salario_deducible_de_aguinaldo --484.8
			set @Paguinaldo = @Paguinaldo- @salario_deducible_de_aguinaldo --484.8
		end

		select @Pvacacion = sum(round(isnull(inn_valor, 0), 2))
		from pla_inn_ingresos, pla_pla_planilla
		where inn_codreg = @codreg and pla_codreg = inn_codreg
		and pla_codtpl = inn_codtpl and pla_codigo = inn_codpla
		and pla_anio = @Panio and inn_codemp = @codemp 
		and inn_codtig in (
			select dag_cod_tig_tdc from pla_dag_detalle_agrupadores
			join pla_tag_tipo_agrupador on tag_codigo = dag_codtag
			where tag_tipo = 'R' and dag_tipo = 'I' and dag_codtag = 12
		)

		print '@Pvacacion: ' + cast(@Pvacacion as nvarchar(15))

		select @Prenta = sum(round(isnull(dss_valor, 0), 2)) 
		from pla_dss_descuentos, pla_pla_planilla 
		where dss_codreg = @codreg and dss_codemp= @codemp
		and pla_codreg = dss_codreg and pla_codtpl = dss_codtpl
		and pla_codigo = dss_codpla and pla_anio = @Panio 
		and pla_codtpl  in(1,3,4,5,6,7,8,9,10,11) 	 	
		and dss_codtdc in (
			select dag_cod_tig_tdc from pla_dag_detalle_agrupadores
			join pla_tag_tipo_agrupador on tag_codigo = dag_codtag
			where tag_tipo = 'R' and dag_tipo = 'D' and dag_codtag = 5
		)
		print '@Prenta : ' + cast(@Prenta as nvarchar(15))	
                            
		if @Prenta = 0
		begin
			set @pcodigoingreso = '60'
		end

		declare @conteo int
		select @conteo = count(1) 
		from pla_inn_ingresos join pla_pla_planilla on pla_codigo = inn_codpla
		and pla_codtpl = inn_codtpl
		where pla_anio = @Panio and pla_codtpl < 7 and inn_codemp = @codemp

		if(@conteo > 0 and @potrosingresos > 0)
		begin
			set @pcodigoingreso = '01'
		end

		--***Renta de servicios profesionales***--
		select @Prenta_eventual = sum(round(isnull(dss_valor, 0), 2)) 
		from pla_dss_descuentos, pla_pla_planilla 
		where dss_codreg = @codreg and dss_codemp= @codemp
		and pla_codreg = dss_codreg and pla_codtpl = dss_codtpl
		and pla_codigo = dss_codpla and pla_anio = @Panio 
		and pla_codtpl not in(1,3,4,5,6,7,8,9,10,11)
		and dss_codtdc in (
			select dag_cod_tig_tdc from pla_dag_detalle_agrupadores
			join pla_tag_tipo_agrupador on tag_codigo = dag_codtag
			where tag_tipo = 'R' and dag_tipo = 'D' and dag_codtag = 5
		)
		print '@Prenta_eventual : ' + cast(@Prenta_eventual as nvarchar(15))	

		select @Prenta_cch = round(isnull(cch_renta, 0), 2) 
		from com_cch_caja_chica, con_pro_proveedores
		where pro_codigo = cch_codpro and pro_codemp = @codemp
		and year(cch_fecha) = @Panio
		print '@Prenta_cch : ' + cast(@Prenta_cch as nvarchar(15))	

		set @prenta = @prenta + isnull(@Prenta_cch,0)

		select @Pisss = sum(round(isnull(dss_valor, 0), 2))
		from pla_dss_descuentos, pla_pla_planilla
		where dss_codreg = @codreg and pla_codreg = dss_codreg
		and dss_codemp= @codemp and pla_codtpl = dss_codtpl
		and pla_codigo = dss_codpla and pla_anio = @Panio 
		and dss_codemp = @codemp 
		and dss_codtdc in (
			select dag_cod_tig_tdc from pla_dag_detalle_agrupadores
			join pla_tag_tipo_agrupador on tag_codigo = dag_codtag
			where tag_tipo = 'R' and dag_tipo = 'D' and dag_codtag = 6
		)
		print '@Pisss : ' + cast(@Pisss as nvarchar(15))	

		select @Pafp = case when @emp_codafp = 5020 then 0 when @emp_codafp = 2767 then 0 else sum(round(isnull(dss_valor, 0), 2)) end --* case when (@emp_codafp = 2764 and @emp_codafp = 2766)  then sum(round(isnull(dss_valor, 0), 2)) else 0 end 
		from pla_dss_descuentos, pla_pla_planilla
		where dss_codreg = @codreg and dss_codemp= @codemp
		and pla_codreg = dss_codreg and pla_codtpl = dss_codtpl
		and pla_codigo = dss_codpla and pla_anio = @Panio 
		and dss_codemp = @codemp 
		and dss_codtdc in (
			select dag_cod_tig_tdc from pla_dag_detalle_agrupadores
			join pla_tag_tipo_agrupador on tag_codigo = dag_codtag
			where tag_tipo = 'R' and dag_tipo = 'D' and dag_codtag = 7
		)
		print '@Pafp: ' + cast(@Pafp as nvarchar(15))

		select @Pipsfa = case when @emp_codafp = 5020 then sum(round(isnull(dss_valor, 0), 2)) else 0 end
		from pla_dss_descuentos, pla_pla_planilla
		where dss_codreg = @codreg and dss_codemp= @codemp
		and pla_codreg = dss_codreg and pla_codtpl = dss_codtpl
		and pla_codigo = dss_codpla and pla_anio = @Panio 
		and dss_codemp = @codemp 
		and dss_codtdc in (
			select dag_cod_tig_tdc from pla_dag_detalle_agrupadores
			join pla_tag_tipo_agrupador on tag_codigo = dag_codtag
			where tag_tipo = 'R' and dag_tipo = 'D' and dag_codtag = 8
		)
		print '@Pipsfa: ' + cast(@Pipsfa as nvarchar(15))

		select @Pivm = case when @emp_codafp = 2767 then sum(round(isnull(dss_valor, 0), 2)) else 0 end
		from pla_dss_descuentos, pla_pla_planilla
		where dss_codreg = @codreg and dss_codemp= @codemp
		and pla_codreg = dss_codreg and pla_codtpl = dss_codtpl
		and pla_codigo = dss_codpla and pla_anio = @Panio 
		and dss_codemp = @codemp 
		and dss_codtdc in (
			select dag_cod_tig_tdc from pla_dag_detalle_agrupadores
			join pla_tag_tipo_agrupador on tag_codigo = dag_codtag
			where tag_tipo = 'R' and dag_tipo = 'D' and dag_codtag = 8
		)
		print '@Pivm: ' + cast(@Pivm as nvarchar(15))

		--***Buscar cheques de empleados existentes***--
		declare @cheque_monto money = 0, @cheque_renta money = 0

		select @cheque_monto = isnull(sum(monto),0),@cheque_renta = isnull(Sum(retenido),0) 
		from temp_rep_retenciones_11 join pla_emp_empleado on NIT = replace(emp_nit,'-','')
		and anio = @Panio
		where emp_codigo = @codemp
		print '@cheque_monto: ' + cast(@cheque_monto as nvarchar(15))

		--***Buscar empleados código 01 que se les haya asignado cheque***--
		declare @salario_cheque money, @isss_cheque money, @afp_cheque money,
		@renta_cheque money, @vacacion money, @otros_in money
		select @salario_cheque = isnull(sum(salario),0), @isss_cheque = isnull(sum(isss),0), 
		@afp_cheque = isnull(sum(afp),0), @renta_cheque = isnull(sum(renta),0), 
		@vacacion = isnull(sum(vacacion),0), @otros_in = isnull(sum(otros),0)  
		from temp_rep_retenciones_01 join pla_emp_empleado on NIT = replace(emp_nit,'-','')
		and anio = @Panio
		where emp_codigo = @codemp

		if  @pcodigoingreso ='11'--
		begin
			set @Psalario = 0
		end

		if(@Psalario > 0)
		begin
			insert into dbo.plan_ingacum (uniNombre, codreg, planilla, codemp, nit, nombre, 
			salario,
			aguinaldo, vacacion, indemnizacion, bonificacion,
			renta, isss, afp, ipsfa, ivm,
			anio, codtpl, mes,
			pla_codtpl, pla_codigo, pla_frecuencia, otros, aguinaldog, codigoingreso)
			select @uni_nombre, @codreg, @Pplanilla, @codemp,  @emp_nit, @emp_apellidos_nombres,
			isnull(isnull(@Psalario, 0)-isnull(@Pafp, 0)-isnull(@Pipsfa, 0) - isnull(@Pisss, 0)
			--Codigo agregado el dia 23/01/2017 para poder restar el monto del ISSS
			 , 0) + ISNULL(@salario_cheque, 0), 
			isnull(@Paguinaldo, 0), isnull(@Pvacacion,0) + isnull(@vacacion,0),
			isnull(@Pindemnizacion, 0), isnull(@Pbonificacion, 0),
			isnull(@Prenta,0)+ISNULL(@renta_cheque,0), isnull(@Pisss, 0)+ISNULL(@isss_cheque,0), 
			isnull(@Pafp, 0)+ISNULL(@afp_cheque,0), isnull(@Pipsfa,0), isnull(@Pivm,0),
			@Panio, @emp_codtpl, @Pmes, @pla_codtpl,
			@pla_codigo, @pla_frecuencia , isnull(@potros, 0)+isnull(@otros_in, 0), isnull(@paguinaldog, 0), @pcodigoingreso
		end

		if @potrosingresos <> 0
		begin
			insert into dbo.plan_ingacum (uniNombre, codreg, planilla, codemp, nit, nombre,
			salario,
			aguinaldo, vacacion, indemnizacion, bonificacion,
			renta, isss, afp, ipsfa, ivm,
			anio, codtpl, mes ,
			pla_codtpl, pla_codigo, pla_frecuencia, otros, aguinaldog, codigoingreso)
			select @uni_nombre, @codreg, @Pplanilla, @codemp, @emp_nit, @emp_apellidos_nombres,
			0.0, 0.0, 0.0, 0.0, 0.0,
			isnull(@Prenta_eventual,0)+isnull(@cheque_renta,0),
			0.0, 0.0, 0.0, 0.0, @Panio, @emp_codtpl ,
			@Pmes, @pla_codtpl, @pla_codigo ,
			@pla_frecuencia, round((isnull(@potrosingresos,0)+isnull(@cheque_monto,0)),2), 0.0, '11'
		end 
	 
		if  (@cheque_monto > 0) and (@pcodigoingreso in ('01','60')) and (@potrosingresos = 0)
		begin
			insert into dbo.plan_ingacum (uniNombre, codreg, planilla, codemp, nit, nombre,
			salario, aguinaldo, vacacion,
			indemnizacion, bonificacion, renta, isss, afp, 
			ipsfa, ivm, anio, codtpl, mes, pla_codtpl,
			pla_codigo, pla_frecuencia, otros, aguinaldog, codigoingreso)
			select @uni_nombre,
			@codreg, @Pplanilla, @codemp, @emp_nit, @emp_apellidos_nombres,
			0.0, 0.0, 0.0, 0.0, 0.0, isnull(@cheque_renta,0),
			0.0, 0.0, 0.0, 0.0,
			@Panio, @emp_codtpl, @Pmes, @pla_codtpl, @pla_codigo,
			--@pla_frecuencia , round(isnull(@cheque_monto,0),1),0.0,'11'
			@pla_frecuencia, isnull(@cheque_monto, 0), 0.0, '11'
		end
		print '--===**FIN**===--'

		fetch next from  cur_empleados into @codemp, @uni_nombre, @emp_apellidos_nombres, @emp_nit, @codreg, 
		@emp_sarlio, @emp_codafp, @emp_codtpl, @pcodigoingreso
	end	
	close cur_empleados
	deallocate cur_empleados

	print '***FIN DEL CURSOR cur_empleados***'

	--**Insertar cheques de empleados no existentes***--
	select 'UNIVERSIDAD TECNOLOGICA DE EL SALVADOR' uniNombre, 1 codreg, 0 planilla, 0 codemp, nit, nombre,
	0.00 salar, 0.00 aguina, 0.00 vaca, 0.00 indenm, 0.00 bono, sum(retenido) rent, 0.00 isss, 0.00 afp, 0.00 ipsfa, 
	0.00 ivm,@Panio anio,
	--0 codtpl,NULL mes,NULL pla_cod,NULL pla_codig,NULL frec,round(sum(monto),1)monto, 0.00 aguinald,codigo
	0 codtpl, NULL mes, NULL pla_cod, NULL pla_codig, NULL frec, sum(monto)monto, 0.00 aguinald, codigo
	into #Tempo0
	from temp_rep_retenciones_11 where anio = @Panio
	group by nombre, nit, codigo
	
	insert into dbo.plan_ingacum
	(uniNombre, codreg, planilla, codemp, nit, nombre, salario, aguinaldo,
	vacacion, indemnizacion, bonificacion, renta,
	isss, afp, ipsfa, ivm,
	anio, codtpl, mes,
	pla_codtpl, pla_codigo, pla_frecuencia, otros, aguinaldog,codigoingreso)
	select * from #Tempo0
	where not exists (select 1 from pla_emp_empleado where replace(emp_nit,'-','') = nit)
	----------------------------------------------------
	select 'UNIVERSIDAD TECNOLOGICA DE EL SALVADOR' uniNombre, 1 codreg, 0 planilla, emp_codigo codemp, nit,
	emp_apellidos_nombres nombre, emp_salario salario, 0.00 aguina, sum(vacacion) vaca,
	indemnizacion indenm, 0.00 bono, Sum(renta) rent, sum(isss)iss, sum(afp) afp, 0.00 ipsfa, 0.00 ivm, @Panio anio,
	-- 0 codtpl,NULL mes,NULL pla_cod,NULL pla_codig,NULL frec,round(sum(otros),1)monto, 0.00 aguinald,codigo
	0 codtpl, NULL mes, NULL pla_cod, NULL pla_codig, NULL frec, sum(otros)monto, 0.00 aguinald, codigo
	into #Tempo1
	from temp_rep_retenciones_01 join pla_emp_empleado on NIT = replace(emp_nit,'-','')
	where anio = @Panio
	group by emp_apellidos_nombres, nit, codigo, emp_codigo, emp_salario, indemnizacion
	
	insert into dbo.plan_ingacum 
	(uniNombre, codreg, planilla, codemp,
	nit, nombre, salario, aguinaldo, vacacion, indemnizacion, bonificacion,
	renta, isss, afp, ipsfa, ivm, anio, codtpl,
	mes, pla_codtpl, pla_codigo, pla_frecuencia, otros, aguinaldog, codigoingreso)
	select * from #Tempo1
	where not exists(
		select 1 from pla_inn_ingresos, pla_pla_planilla
		where inn_codreg = 1 and pla_codreg = inn_codreg
		and pla_codtpl = inn_codtpl and pla_codigo = inn_codpla and pla_anio = @Panio 
		--and pla_mes = @Pmes
		and inn_valor > 0 and inn_codemp = codemp
	)
	----------------------------------------------------
	--***************************************************************************************************
	-- Agregado
	select 'UNIVERSIDAD TECNOLOGICA DE EL SALVADOR' uniNombre, 1 codreg, 0 planilla, 0 codemp,nit, nombre nombre,
	sum(salario) salario, 0.00 aguina, sum(vacacion) vaca, sum(indemnizacion) indenm, 0.00 bono,
	sum(renta) rent, sum(isss)iss, sum(afp)afp, 0.00 ipsfa, 0.00 ivm, @Panio anio,
	-- 0 codtpl,NULL mes,NULL pla_cod,NULL pla_codig,NULL frec,round(sum(otros),1)monto, 0.00 aguinald,codigo
	0 codtpl, NULL mes, NULL pla_cod, NULL pla_codig, NULL frec, sum(otros) monto, 0.00 aguinald, codigo
	into #Tempo3
	from temp_rep_retenciones_01 where nombre is not null
	and not exists (select * from pla_emp_empleado where nit=replace(emp_nit,'-',''))
	and anio = @Panio
	group by nombre,nit,codigo

	insert into dbo.plan_ingacum
	(uniNombre, codreg, planilla, codemp, nit, nombre, salario, aguinaldo, vacacion,
	indemnizacion, bonificacion, renta, isss, 
	afp, ipsfa, ivm, anio, codtpl, mes,
	pla_codtpl, pla_codigo, pla_frecuencia, otros, aguinaldog, codigoingreso)

	select * from #Tempo3
	where not exists(
		select 1 from pla_inn_ingresos, pla_pla_planilla
		where inn_codreg = 1 and pla_codreg = inn_codreg
		and pla_codtpl = inn_codtpl and pla_codigo = inn_codpla
		and pla_anio = @Panio 
		--and pla_mes = @Pmes
		and inn_valor > 0 and inn_codemp = codemp
	)
	--***************************************************************************************************

	--------------------------------------------------------------
	select 'UNIVERSIDAD TECNOLOGICA DE EL SALVADOR' uniNombre, 1 codreg, 0 planilla, emp_codigo codemp, nit,nombre,
	0.00 salar,0.00 aguina,0.00 vaca, 0.00 indenm, 0.00 bono, sum(retenido) rent, 0.00 isss, 0.00 afp,
	0.00 ipsfa, 0.00 ivm, @Panio anio,
	-- 0 codtpl,NULL mes,NULL pla_cod,NULL pla_codig,NULL frec,round(sum(monto),1)monto, 0.00 aguinald,codigo
	0 codtpl0 ,NULL mes, NULL pla_cod, NULL pla_codig, NULL frec, sum(monto)monto, 0.00 aguinald, codigo
	INTO #Tempo2
	from temp_rep_retenciones_11 join pla_emp_empleado on replace(emp_nit,'-','') = nit
	where anio = @Panio
	group by nombre,nit,codigo,emp_codigo

	insert into dbo.plan_ingacum
	(uniNombre, codreg, planilla, codemp, nit, nombre, salario, aguinaldo, vacacion,
	indemnizacion, bonificacion, renta, isss, afp, ipsfa, ivm,
	anio, codtpl, mes, pla_codtpl, pla_codigo, pla_frecuencia, 
	otros, aguinaldog,codigoingreso)
	select * from #Tempo2
	where not exists(
		select 1
		from pla_inn_ingresos, pla_pla_planilla
		where inn_codreg = 1 and pla_codreg = inn_codreg
		and pla_codtpl = inn_codtpl and pla_codigo = inn_codpla
		and pla_anio = @Panio 
		--and pla_mes = @Pmes
		and inn_valor > 0 and inn_codemp = codemp
	)

	--	Agregado el 18/01/2019 para calcular los montos por cada mes, ya que para el registro anual del 2018 
	--	se necesita generar el archivo de texto en formato diferente, que incluye los montos por cada mes

	exec dbo.ingacum_para_meses_renta 1, @codreg, @Panio
end