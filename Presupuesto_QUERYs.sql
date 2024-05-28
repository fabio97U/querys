-- drop table con_claspres_clases_presupuesto
create table con_claspres_clases_presupuesto (
	claspres_codigo varchar(5) primary key not null,
	claspres_descripcion varchar(50),
	claspres_fecha_creacion datetime default getdate()
)
-- select * from con_claspres_clases_presupuesto
insert into con_claspres_clases_presupuesto (claspres_codigo, claspres_descripcion) values ('I', 'Ingresos'), ('E', 'Egresos (costos)'), ('A', 'Fondos ajenos')

select * from con_cuc_cuentas_contables
alter table con_cuc_cuentas_contables add cuc_cuenpre_cuenta varchar(30) null
alter table con_cuc_cuentas_contables add cuc_fecha_creacion datetime default getdate()

-- drop table con_cuenpre_cuentas_presupuesto
create table con_cuenpre_cuentas_presupuesto (
	cuenpre_codigo int primary key identity (1, 1),
	cuenpre_cuenta as (cuenpre_codclaspres + '-' + cuenpre_rubro + '-' + cuenpre_sub_cuenta1 + '-' + cuenpre_sub_cuenta2 + '-' + cuenpre_sub_cuenta3),
	cuenpre_descripcion varchar(550) not null,
	cuenpre_codclaspres varchar(5) not null foreign key references con_claspres_clases_presupuesto,
	cuenpre_rubro varchar(5) not null,
	cuenpre_sub_cuenta1 varchar(5) not null,
	cuenpre_sub_cuenta2 varchar(5) not null,
	cuenpre_sub_cuenta3 varchar(5) not null,
	cuenpre_acepta_movimientos varchar(5) not null,
	cuenpre_tipo varchar(5) not null,--V: Variable, F: Fijo
	
	cuenpre_codusr int,
	cuenpre_fecha_creacion datetime default getdate()
)
-- select * from con_cuenpre_cuentas_presupuesto
--SELECT TOP (200) cuenpre_descripcion, cuenpre_codclaspres, cuenpre_rubro, cuenpre_sub_cuenta1, cuenpre_sub_cuenta2, cuenpre_sub_cuenta3, cuenpre_acepta_movimientos, cuenpre_codusr, cuenpre_tipo
--FROM con_cuenpre_cuentas_presupuesto
--update con_cuenpre_cuentas_presupuesto set cuenpre_tipo = 'F' where cuenpre_codigo in (3, 212)

-- drop table con_unipre_cuentas_unidades_presupuesto
create table con_unipre_cuentas_unidades_presupuesto (
	unipre_codigo int primary key identity (1, 1),
	unipre_coduni varchar(3),--[192.168.1.114].GRUPO.UTEC.DEPARTAMENTO
	unipre_cuenta varchar(30),--con_cuenpre_cuentas_presupuesto.cuenpre_cuenta
	unipre_codusr int,

	unipre_codusr_creacion int,
	unipre_fecha_creacion datetime default getdate()
)
-- select * from con_unipre_cuentas_unidades_presupuesto
insert into con_unipre_cuentas_unidades_presupuesto (unipre_coduni, unipre_cuenta, unipre_codusr_creacion, unipre_codusr)
select '050', cuenpre_cuenta, 407, 407 from con_cuenpre_cuentas_presupuesto where cuenpre_cuenta like 'E-07-%'
and cuenpre_cuenta in ('E-07-01-01-02', 'E-07-01-01-03', 'E-07-01-01-04')
union all
select '050', cuenpre_cuenta, 407, 402 from con_cuenpre_cuentas_presupuesto where cuenpre_cuenta like 'E-07-%'
and cuenpre_cuenta in ('E-07-01-01-02')

insert into con_unipre_cuentas_unidades_presupuesto (unipre_coduni, unipre_cuenta, unipre_codusr_creacion, unipre_codusr)
select '050', cuenpre_cuenta, 407, 407 from con_cuenpre_cuentas_presupuesto where cuenpre_cuenta in ('I-05-07-01-00', 'I-05-07-02-00', 'I-01-01-01-00')
union all
select '050', cuenpre_cuenta, 407, 402 from con_cuenpre_cuentas_presupuesto where cuenpre_cuenta in ('I-05-07-01-00')

-- drop table con_presextra_presupuesto_extraordinario
create table con_presextra_presupuesto_extraordinario (
	presextra_codigo int primary key identity (1, 1),
	presextra_coduni varchar(3),--[192.168.1.114].GRUPO.UTEC.DEPARTAMENTO
	presextra_codpec int,--con_pec_per_contable
	presextra_tipo_presupuesto varchar(5) not null,--I: Ingresos, E: Egresos

	presextra_usado bit not null default 0,
	presextra_codusr_creacion int,
	presextra_fecha_creacion datetime default getdate()
)
-- select * from con_presextra_presupuesto_extraordinario
insert into con_presextra_presupuesto_extraordinario (presextra_coduni, presextra_codpec, presextra_tipo_presupuesto, presextra_codusr_creacion)
values ('050', 199, 'E', 407)

declare @periodo_permitido varchar(20)
select @periodo_permitido = concat(presextra_codpec, '-', pec_anio, '-', pec_mes_desde, ',', presextra_tipo_presupuesto) from con_presextra_presupuesto_extraordinario 
	inner join con_pec_per_contable on presextra_codpec = pec_codigo
where presextra_coduni = '050' and presextra_usado = 0
select @periodo_permitido 'periodo_permitido'

select * from con_pec_per_contable
select * from adm_usr_usuarios where usr_nombre like '%adon%'
select * from con_pec_per_contable
alter table con_pec_per_contable add pec_permitido_presupuestar bit default 0 not null
update con_pec_per_contable set pec_permitido_presupuestar = 1 where pec_anio in (2023, 2024)
update con_pec_per_contable set pec_permitido_presupuestar = 1 where pec_anio in (2022) and pec_mes_desde = 12

select * from vst_unidades where CODUNI = 50
select * from vst_empleados_x_unidad where NOMBRECOMPLETO like '%canale%'
--select * from [192.168.1.114].GRUPO.UTEC.DEPARTAMENTO
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2024-04-18 14:30:33.300>
	-- Description: <Devuelve los unidades con cada cuenta contable>
	-- =============================================
	-- select * from vst_pres_unidades_presupuesto
create or alter view vst_pres_unidades_presupuesto
as
	select unipre_codigo 'codunipre' , d.departamento 'coduni', d.descripcion 'nombre_departamento', usr_usuario 'usuario', unipre_codusr 'codusr', emp_codigo 'codemp', emp_nombres_apellidos 'empleado', 
		cuenpre_cuenta 'cuenta', cuenpre_descripcion 'descripcion_cuenta',
		cuenpre_acepta_movimientos, cuenpre_tipo, claspres_codigo 'clase', claspres_descripcion 'clase_descripcion', unipre_fecha_creacion 'fecha_creacion'
	from con_unipre_cuentas_unidades_presupuesto
		inner join con_cuenpre_cuentas_presupuesto on cuenpre_cuenta = unipre_cuenta
		inner join [192.168.1.114].GRUPO.UTEC.DEPARTAMENTO d on d.departamento COLLATE SQL_Latin1_General_CP1_CI_AS = unipre_coduni
		inner join con_claspres_clases_presupuesto on cuenpre_codclaspres = claspres_codigo
		inner join adm_usr_usuarios on unipre_codusr = usr_codigo
		inner join pla_emp_empleado on usr_codemp = emp_codigo
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2024-04-18 14:27:36.300>
	-- Description: <Devuelve los periodos de presupestos>
	-- =============================================
	-- select * from vst_pres_periodos_presupuesto order by anio desc, mes, codpec
create or alter view vst_pres_periodos_presupuesto
as
	select codpec, mes, anio, concepto, permitido_presupuestar from (
		select pec_codigo 'codpec', pec_mes_desde 'mes', pec_anio 'anio', pec_concepto 'concepto', pec_permitido_presupuestar 'permitido_presupuestar' 
		from con_pec_per_contable
		--where pec_permitido_presupuestar = 1
		
			union all

		select (0) 'codpec', 13 'mes', p.pec_anio 'anio', concat('*** Todos los meses habilitados del año “', p.pec_anio, '” *** ') 'concepto', 1 'permitido_presupuestar' 
		from con_pec_per_contable p
		where exists (select 1 from con_pec_per_contable p2 where p2.pec_anio = p.pec_anio and p2.pec_permitido_presupuestar = 1)
		group by p.pec_anio
	) t
go

--pronóstico, por ajustar, anulado, autorizado, cerrado, Enviar a revision, DEFAULT: pronostico
-- drop table con_estpres_estados_presupuesto
create table con_estpres_estados_presupuesto (
	estpres_estado varchar(5) not null primary key,
	estpres_descripcion varchar(250),
	estpres_fecha_creacion datetime default getdate()
)
-- select * from con_estpres_estados_presupuesto
insert into con_estpres_estados_presupuesto (estpres_estado, estpres_descripcion) values ('PRON', 'Pronóstico'), ('AJUS', 'Por ajustar'), ('ANUL', 'Anulado'), ('AUT', 'Autorizado'), ('CERR', 'Cerrado'), ('REV', 'Enviado a revision')

-- drop table con_encpres_encabezado_presupuesto
create table con_encpres_encabezado_presupuesto (
	encpres_codigo int primary key identity (1, 1),
	encpres_codpec int,
	encpres_tipo_periodo_presupuesto varchar(5) not null default 'PO',--Presupuesto ordinario: PO, Presupuesto extraordinario: PE
	encpres_tipo_presupuesto varchar(5) not null,--I: Ingresos, E: Egresos
	encpres_coduni varchar(3),--[192.168.1.114].GRUPO.UTEC.DEPARTAMENTO
	encpres_codemp int,
	encpres_presupuesto_preaprobado real null,
	encpres_codusr_revisado_por int null,

	encpres_codestpres varchar(5) foreign key references con_estpres_estados_presupuesto default 'PRON',
	encpres_codusr_creacion int,
	encpres_fecha_creacion datetime default getdate(),
	encpres_fecha_modificacion datetime null
)
-- select * from con_encpres_encabezado_presupuesto
--insert into con_encpres_encabezado_presupuesto (encpres_codpec, encpres_tipo_periodo_presupuesto, encpres_coduni, encpres_codemp, encpres_codusr_creacion, encpres_tipo_presupuesto)
--values (199, 'PO', '050', 3724, 407, 'E')
go
--alter table con_encpres_encabezado_presupuesto add encpres_fecha_modificacion datetime null
--alter table con_encpres_encabezado_presupuesto add encpres_codusr_revisado_por int null
--alter table con_encpres_encabezado_presupuesto add encpres_presupuesto_preaprobado real null

update con_detpres_detalle_presupuesto set detpres_monto_aprobado = null, detpres_codestpres = 'PRON'
update con_encpres_encabezado_presupuesto set encpres_presupuesto_preaprobado = null, encpres_codestpres = 'PRON'

	-- =============================================
	-- Author:      <Author, Name>
	-- Create date: <2024-04-18 15:58:24.933>
	-- Description: <Devuelve los encabezados de los presupuestos creados>
	-- =============================================
	-- select * from vst_pres_presupuestos
create or alter view vst_pres_presupuestos
as
	select encpres_codigo 'codencpres', encpres_tipo_periodo_presupuesto 'tipo_periodo_presupuesto',
		encpres_tipo_presupuesto 'tipo_presupuesto', 
		claspres_descripcion 'tipo_presupuesto_descripcion',
		case when encpres_tipo_periodo_presupuesto = 'PO' then 'Presupuesto ordinario' when encpres_tipo_periodo_presupuesto = 'PE' then 'Presupuesto extraordinario' else '*' end 'tipo_periodo_presupuesto_descripcion', peri.codpec, 
		peri.concepto, peri.permitido_presupuestar, peri.anio, peri.mes, d.departamento 'coduni', d.descripcion 'nombre_departamento',
		emp.CODIGO 'codemp', emp.NOMBRECOMPLETO 'empleado_presupuesto', estpres_estado 'estado', estpres_descripcion 'descripcion_estado', encpres_codusr_creacion 'codusr_creacion', usr_usuario 'usuario_creacion', encpres_fecha_creacion 'fecha_creacion',
		encpres_presupuesto_preaprobado 'presupuesto_preaprobado', 
		(select count(1) from con_detpres_detalle_presupuesto where detpres_codencpres = encpres_codigo) 'cant_detalles'
	from con_encpres_encabezado_presupuesto
		inner join vst_pres_periodos_presupuesto peri on peri.codpec = encpres_codpec
		inner join [192.168.1.114].GRUPO.UTEC.DEPARTAMENTO d on d.departamento COLLATE SQL_Latin1_General_CP1_CI_AS = encpres_coduni
		inner join vst_empleados_x_unidad emp on emp.CODIGO = encpres_codemp
		inner join con_estpres_estados_presupuesto on encpres_codestpres = estpres_estado
		inner join con_claspres_clases_presupuesto on claspres_codigo = encpres_tipo_presupuesto

		left join adm_usr_usuarios on encpres_codusr_creacion = usr_codigo
go

-- drop table con_detpres_detalle_presupuesto
create table con_detpres_detalle_presupuesto (
	detpres_codigo int primary key identity (1, 1),
	detpres_codencpres int foreign key references con_encpres_encabezado_presupuesto,
	
	detpres_cuenta varchar(30), --con_cuenpre_cuentas_presupuesto.cuenpre_cuenta
	detpres_tipo varchar(5) not null,--V: Variable, F: Fijo
	detpres_concepto varchar(2048),
	detpres_codpro int foreign key references con_pro_proveedores null,
	detpres_cantidad_estudiantes int null,
	detpres_monto_unitaria_ingresos real null,
	detpres_monto_gastos real,
	
	detpres_monto_aprobado real null,
	
	detpres_codestpres varchar(5) foreign key references con_estpres_estados_presupuesto default 'PRON',

	detpres_codusr_creacion int,
	detpres_fecha_creacion datetime default getdate(),
	detpres_codusr_actualizacion int,
	detpres_fecha_actualizacion datetime null
)
-- select * from con_detpres_detalle_presupuesto
insert into con_detpres_detalle_presupuesto (detpres_codencpres, detpres_cuenta, detpres_tipo, detpres_concepto, detpres_codpro, detpres_monto_gastos, detpres_codusr_creacion)
values (1, 'E-07-01-01-02', 'V', '2 - Enlace Comercial Columbus Network COLUMBUS NETWORKS $ 11,967.00 x 12', 2723, 11967.50, 407),
 (1, 'E-07-01-01-06', 'V', 'LIMPIEZA', 2723, 10.50, 407)
go

-- drop table con_detpresl_detalle_presupuesto_logs
create table con_detpresl_detalle_presupuesto_logs (
	detpresl_codigo int primary key identity (1, 1),
	detpresl_codencpres int,
	detpresl_coddetpres int,
	
	detpresl_cuenta varchar(30), --con_cuenpre_cuentas_presupuesto.cuenpre_cuenta
	detpresl_tipo varchar(5),--V: Variable, F: Fijo
	detpresl_concepto varchar(2048),
	detpresl_codpro int foreign key references con_pro_proveedores null,
	detpresl_cantidad_estudiantes int null,
	detpresl_monto_unitaria_ingresos real null,
	detpresl_monto_gastos real,

	detpresl_monto_aprobado real null,

	detpresl_codestpres varchar(5) foreign key references con_estpres_estados_presupuesto null,

	detpresl_codusr_creacion int,
	detpresl_fecha_creacion datetime default getdate()
)
go
-- select * from con_detpresl_detalle_presupuesto_logs

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2024-04-18 16:38:13.550>
	-- Description: <Devuelve los detalles de los presupuestos creados>
	-- =============================================
	-- select * from vst_pres_detalle_presupuesto
create or alter view vst_pres_detalle_presupuesto
as
	select coddetpres, codencpres, codpec, mes, anio, clase, clase_descripcion, cuenta, cuenpre_descripcion 'cuenta_descripcion', tipo, tipo_presupuesto, concepto, codpro, proveedor, nit_proveedor, 
		round(cantidad_estudiantes, 2) cantidad_estudiantes, round(monto_unitario_ingresos, 4) monto_unitario_ingresos, round(monto_gastos, 2) monto_gastos, 
		codusr_creacion, fecha_creacion, fecha_creacion_actualizacion, monto_ejecutado, presupuesto_preaprobado, 
		round(monto_aprobado, 2) monto_aprobado,
		round((monto_gastos + (monto_unitario_ingresos * cantidad_estudiantes)), 2) 'monto_total',
		(isnull(monto_aprobado, 0) - (monto_gastos + (monto_unitario_ingresos * cantidad_estudiantes))) 'diferencia',
		estado_detalle, estado_detalle_descripcion, estado_encabezado, anio_mes
	from (
		select detpres_codigo 'coddetpres', pres.codencpres, pres.mes, pres.anio, claspres_codigo 'clase', claspres_descripcion 'clase_descripcion', cuenta.cuenpre_cuenta 'cuenta', 
			detpres_tipo 'tipo', case when detpres_tipo = 'F' then 'Fijo' when detpres_tipo  = 'V' then 'Variable' else '*' end 'tipo_presupuesto',
			detpres_concepto 'concepto', detpres_codpro 'codpro', pro_descripcion 'proveedor', pro_nit 'nit_proveedor', 
			isnull(detpres_cantidad_estudiantes, 0) 'cantidad_estudiantes', isnull(detpres_monto_unitaria_ingresos, 0.0) 'monto_unitario_ingresos', 
			detpres_monto_gastos 'monto_gastos', detpres_codusr_creacion 'codusr_creacion', detpres_fecha_creacion 'fecha_creacion',
			isnull(detpres_fecha_actualizacion, detpres_fecha_creacion)'fecha_creacion_actualizacion',
			0 'monto_ejecutado', presupuesto_preaprobado, detpres_monto_aprobado 'monto_aprobado',
			estpres_estado 'estado_detalle', estpres_descripcion 'estado_detalle_descripcion', cuenpre_descripcion,
			pres.estado 'estado_encabezado', pres.concepto 'anio_mes', codpec
		from con_detpres_detalle_presupuesto
			inner join vst_pres_presupuestos pres on pres.codencpres = detpres_codencpres
			inner join con_cuenpre_cuentas_presupuesto cuenta on detpres_cuenta = cuenta.cuenpre_cuenta
			left join con_pro_proveedores on detpres_codpro = pro_codigo
			inner join con_claspres_clases_presupuesto on cuenpre_codclaspres = claspres_codigo
			inner join con_estpres_estados_presupuesto on detpres_codestpres = estpres_estado
	) t
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2024-04-24 23:32:53.418>
	-- Description: <Devuelve el resumen de los presupuesto con los detalles totales>
	-- =============================================
	-- declare @anio int = 2024, @mes int = 1, @coduni_seleccionada varchar(3) = '050', @tipo_periodo_presupuesto varchar(5) = 'PO', @tipo_presupuesto varchar(5) = 'I'
	-- select * from vst_pres_presupuesto_resumen where anio = 2024 and mes = 1 and coduni = '050' and tipo_periodo_presupuesto = 'PO' and tipo_presupuesto = 'I'
	-- select * from vst_pres_presupuesto_resumen where codencpres = 2
create or alter view vst_pres_presupuesto_resumen
as
	select codencpres, tipo_periodo_presupuesto, tipo_presupuesto, tipo_presupuesto_descripcion, tipo_periodo_presupuesto_descripcion, codpec, concepto, 
		permitido_presupuestar, anio, mes, coduni, nombre_departamento, codemp, empleado_presupuesto, estado, descripcion_estado, codusr_creacion, usuario_creacion, 
		fecha_creacion, sum_monto_gastos, sum_monto_unitario_ingresos, sum_cantidad_estudiantes, cant_detalles, sum_monto_ejecutado, presupuesto_preaprobado,
		sum_monto_total,
		round((isnull(presupuesto_preaprobado, 0) - (sum_monto_total)), 4) 'diferencia',
		isnull(presupuesto_preaprobado, sum_monto_aprobado) 'sum_monto_aprobado'
	from (
		select codencpres, tipo_periodo_presupuesto, tipo_presupuesto, tipo_presupuesto_descripcion, tipo_periodo_presupuesto_descripcion, codpec, concepto, 
			permitido_presupuestar, anio, mes, coduni, nombre_departamento, codemp, empleado_presupuesto, estado, descripcion_estado, codusr_creacion, usuario_creacion, 
			fecha_creacion, 
			round(sum(e.monto_gastos), 4) sum_monto_gastos, round(sum(e.monto_unitario_ingresos), 4) sum_monto_unitario_ingresos, round(sum(e.monto_aprobado), 4) sum_monto_aprobado, 
			round(sum(e.cantidad_estudiantes), 4) sum_cantidad_estudiantes, round(sum(e.monto_total), 4) sum_monto_total, round(sum(e.monto_ejecutado), 4) sum_monto_ejecutado, 
			cant_detalles, presupuesto_preaprobado
		from (
			select e.codencpres, e.tipo_periodo_presupuesto, e.tipo_presupuesto, e.tipo_presupuesto_descripcion, e.tipo_periodo_presupuesto_descripcion, 
				e.codpec, e.concepto, e.permitido_presupuestar, e.anio, e.mes, e.coduni, e.nombre_departamento, e.codemp, e.empleado_presupuesto, 
				e.estado, e.descripcion_estado, e.codusr_creacion, e.usuario_creacion, e.fecha_creacion, 
				d.monto_gastos 'monto_gastos', d.monto_unitario_ingresos 'monto_unitario_ingresos', 
				d.cantidad_estudiantes 'cantidad_estudiantes', e.cant_detalles,
				d.monto_ejecutado 'monto_ejecutado', e.presupuesto_preaprobado,
				d.monto_aprobado 'monto_aprobado', d.monto_total
			from vst_pres_presupuestos e
				left join vst_pres_detalle_presupuesto d on e.codencpres = d.codencpres
		) e
		group by e.codencpres, e.tipo_periodo_presupuesto, e.tipo_presupuesto, e.tipo_presupuesto_descripcion, e.tipo_periodo_presupuesto_descripcion, 
			e.codpec, e.concepto, e.permitido_presupuestar, e.anio, e.mes, e.coduni, e.nombre_departamento, e.codemp, e.empleado_presupuesto, 
			e.estado, e.descripcion_estado, e.codusr_creacion, e.usuario_creacion, e.fecha_creacion, e.presupuesto_preaprobado, cant_detalles
	) t2
go

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_presupuesto]    Script Date: 9/5/2024 09:04:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
