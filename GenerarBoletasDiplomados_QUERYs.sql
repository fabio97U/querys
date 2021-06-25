--insert into col_dtde_detalle_tipo_estudio (dtde_codtde, dtde_nombre, dtde_valor, dtde_descripcion) values (9, 'Diplomado/Cursos Libres', 'D', 'Estos son los alumnos de Diplomado/Cursos Libres')


select top 10 * from dip_dip_diplomados 
where dip_codigo in (
1031,1033
)
order by dip_codigo desc

select * from dip_ped_personas_dip
where ped_coddip in (1031,1033)
and 
ped_codper in (
231905, 231904, 231903, 231902, 231901, 231899, 231896, 231895, 231894, 231893, 231891, 231890, 231889, 231887, 231886, 231884, 231883, 231882, 231881, 231880, 231879, 231878, 231874, 231873, 231868, 231844, 231842, 231835, 231830, 231827, 231821, 231820, 231817, 231815, 231814, 231813, 231812, 231811, 231808, 231806, 231805, 231801, 231797, 231796, 231788
)
order by ped_codigo desc

select * from ra_alc_alumnos_carrera where alc_codper = 231788
select * from ra_per_personas 
where per_codigo = 231788
select * from adm_opm_opciones_menu
--insert into adm_opm_opciones_menu (opm_codigo, opm_nombre, opm_link, opm_opcion_padre, opm_orden, opm_sistema) values (1138, 'Generar boletas alumnos diplomados', 'col_generar_data_diplomados.aspx', 949, 5, 'U')

--1031, DIPLOMADO: EXPORTACIONES E IMPORTACIONES VIRTUAL
	--Graduado UTEC
	select tmo_arancel, tmo_descripcion, tmo_valor, * from col_tmo_tipo_movimiento where tmo_arancel in ('D-123', 'D-124')
	--Externo UTEC
	select tmo_arancel, tmo_descripcion, tmo_valor, * from col_tmo_tipo_movimiento where tmo_arancel in ('D-125', 'D-126')
--1033, CURSO ESPECIALIZADO: INVESTIGACION SOCIAL
	select tmo_arancel, tmo_descripcion, tmo_valor, * from col_tmo_tipo_movimiento where tmo_arancel in ('C-209', 'C-210')


--Generados el 07/04/2021
--1035 DIPLOMADO: INTERVENCIÓN CON PROGRAMACIÓN NEUROLINGUISTICA E INTELIGENCIA EMOCIONAL
	--Graduado UTEC
	select tmo_arancel, tmo_descripcion, tmo_valor, * from col_tmo_tipo_movimiento where tmo_arancel in ('D-286')
	--Externo UTEC
	select tmo_arancel, tmo_descripcion, tmo_valor, * from col_tmo_tipo_movimiento where tmo_arancel in ('D-278')

--insert into cil_cpd_cuotas_pagar_diplomado (cpd_coddip, cpd_codtmo, cpd_orden, cpd_graduado_utec)
--values (1035, 3685, 0, 1), (1035, 3685, 1, 1),
--(1035, 3647, 0, 0), (1035, 3647, 1, 0)


--1036 DIPLOMADO: ADMINISTRACIÓN DE PROYECTOS CON ENFOQUE TECNOLÓGICO
	--Graduado UTEC
	select tmo_arancel, tmo_descripcion, tmo_valor, * from col_tmo_tipo_movimiento where tmo_arancel in ('D-282', 'D-283')
	--Externo UTEC
	select tmo_arancel, tmo_descripcion, tmo_valor, * from col_tmo_tipo_movimiento where tmo_arancel in ('D-284', 'D-285')
--1037 DIPLOMADO: EXCEL AVANZADO COMO HERRAMIENTA PARA LA GESTIÓN DE LOS NEGOCIOS
	select tmo_arancel, tmo_descripcion, tmo_valor, * from col_tmo_tipo_movimiento where tmo_arancel in ('D-281')

--insert into cil_cpd_cuotas_pagar_diplomado (cpd_coddip, cpd_codtmo, cpd_orden, cpd_graduado_utec)
--values (1036, 3681, 0, 1), (1036, 3682, 1, 1), (1036, 3682, 2, 1),
--(1036, 3683, 0, 0), (1036, 3684, 1, 0), (1036, 3684, 2, 0),

--(1037, 3680, 0, 0)--, (1033, 3630, 1, 0)


-- 1038, SEMINARIO: CURSO ESPECIALIZADO SOBRE CAMPAÑAS DIGITALES Y GOOGLE ADWORDS
	--Graduado UTEC
	select tmo_arancel, tmo_descripcion, tmo_valor, * from col_tmo_tipo_movimiento where tmo_arancel in ('T-202', 'T-203')
	--Externo UTEC
	select tmo_arancel, tmo_descripcion, tmo_valor, * from col_tmo_tipo_movimiento where tmo_arancel in ('T-204', 'T-205')

--1039, SEMINARIO: TALLER   COMERCIO ELECTRÓNICO A TRAVÉS DE LANDING PAGE
	--Graduado UTEC
	select tmo_arancel, tmo_descripcion, tmo_valor, * from col_tmo_tipo_movimiento where tmo_arancel in ('T-206', 'T-207')
	--Externo UTEC
	select tmo_arancel, tmo_descripcion, tmo_valor, * from col_tmo_tipo_movimiento where tmo_arancel in ('T-208', 'T-209')

insert into cil_cpd_cuotas_pagar_diplomado (cpd_coddip, cpd_codtmo, cpd_orden, cpd_graduado_utec)
values (1038, 3686, 0, 1), (1038, 3687, 1, 1), (1038, 3688, 0, 0), (1038, 3689, 1, 0),
(1039, 3690, 0, 1), (1039, 3691, 1, 1), (1039, 3692, 0, 0), (1039, 3693, 1, 0)

-- drop table cil_cpd_cuotas_pagar_diplomado
create table cil_cpd_cuotas_pagar_diplomado (
	cpd_codigo int primary key identity (1, 1),
	cpd_coddip int,
	cpd_codtmo int,
	cpd_orden int, --0:Matricula, > 0: cuotas
	cpd_graduado_utec int,
	cpd_fecha_creacion datetime default getdate()
)
-- select * from cil_cpd_cuotas_pagar_diplomado
--insert into cil_cpd_cuotas_pagar_diplomado (cpd_coddip, cpd_codtmo, cpd_orden, cpd_graduado_utec)
--values (1031, 2866, 0, 1), (1031, 2867, 1, 1), (1031, 2867, 2, 1),
--(1031, 2868, 0, 0), (1031, 2869, 1, 0), (1031, 2869, 2, 0),
--(1033, 3629, 0, 0), (1033, 3630, 1, 0)


--SP´s cambiados:
---- sp_col_daapl_datos_alu_pago_linea_estructurado
---- tal_GenerarDataOtrosAranceles
--	exec sp_insertar_pagos_x_carnet_estructurado  '0313004000000023178800012719', 1, 'xxx'

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2021-02-26 21:33:03.551>
	-- Description: <Realiza el proceso de generacion de la data para boletas de pago de diplomados>
	-- =============================================
create procedure sp_boletas_diplomados
	@opcion int = 0,
	--@codper int = 0, 
	@per_carnet varchar(16) = '',
	@pboa_codigo int = 0
as
begin
	declare @per_codigo int = 0, @coddip int = 0, @per_carnet_anterior varchar(32) = '',
	@graduado_utec int = 0, @cil_codigo_vigente int = 0

	declare @tbl_data as table (
		carnet nvarchar(15), alumno nvarchar(75),
		tmo_arancel nvarchar(15), Monto float,
		arancel nvarchar(125), carrera nvarchar(150),
		barra nvarchar(80), npe nvarchar(40),
		ciclo nvarchar(10), coddao int,
		fecha_creacion datetime
	)

	select top 1 @cil_codigo_vigente = cil_codigo from ra_cil_ciclo where cil_vigente = 'S' order by cil_codigo desc

	select @per_codigo = per_codigo, @coddip = ped_coddip, @per_carnet_anterior = per_carnet_anterior 
	from dip_ped_personas_dip 
		inner join ra_per_personas on per_codigo = ped_codper
	where per_carnet = @per_carnet

	if (isnull(@per_carnet_anterior, '') != '')
	begin
		set @graduado_utec = 1
	end

	if @opcion = 1
	begin
		-- exec dbo. sp_boletas_diplomados @opcion = 1, @per_carnet = 'DI-0001-2021'
		select per_carnet, per_nombres_apellidos, dip_nombre, fac_nombre
		from dip_ped_personas_dip 
			inner join ra_per_personas on per_codigo = ped_codper
			inner join dip_dip_diplomados on ped_coddip = dip_codigo
			left join ra_fac_facultades on fac_codigo = dip_codfac
		where ped_codper = @per_codigo

		select dpboa_codigo, cpd_codtmo, cpd_orden, tmo_arancel, tmo_descripcion, tmo_valor, cpd_graduado_utec 
		from cil_cpd_cuotas_pagar_diplomado
			inner join col_tmo_tipo_movimiento on tmo_codigo = cpd_codtmo
			inner join col_dpboa_definir_parametro_boleta_otros_aranceles on dpboa_codtmo = cpd_codtmo
		where cpd_coddip = @coddip and cpd_graduado_utec = @graduado_utec
		order by cpd_orden

	end

	if @opcion = 2
	begin
		-- exec dbo. sp_boletas_diplomados @opcion = 2, @per_carnet = 'DI-0001-2021', @pboa_codigo = 156
		exec dbo.sp_col_dao_data_otros_aranceles @opcion = 3, @codper = @per_codigo, 
			@codcil = @cil_codigo_vigente, @codpboa = @pboa_codigo
	end

end