-- drop table cons_constancias
create table cons_constancias (
	cons_codigo int primary key identity (1, 1),
	cons_nombre varchar(100) not null,
	cons_descripcion varchar(1024) not null,
	
	cons_ejemplo varchar(1024) not null,
	cons_url_constancia varchar(2048) not null, --reportes.utec.edu.sv/{0}/{1}

	cons_activa bit default 1 not null,
	cons_fecha_creacion datetime default getdate()
)
-- select * from cons_constancias

insert into cons_constancias (cons_nombre, cons_descripcion, cons_url_constancia, cons_ejemplo)
values ('Constancia de salario', 'salario', '', '/assets/archivos/ejemplos/constancias/1.pdf'), ('Constancia de trabajo', 'trabajo', '', '/assets/archivos/ejemplos/constancias/2.pdf'), 
('Constancia de asignaturas', 'asignaturas', '', '/assets/archivos/ejemplos/constancias/4.pdf'), ('Constancia combinada', 'combinada', '', '/assets/archivos/ejemplos/constancias/3.pdf'), 
('Reporte de pagos por año', 'pagos por año', '', '/assets/archivos/ejemplos/constancias/5.pdf')

-- drop table scons_solicitud_constancia
create table scons_solicitud_constancia (
	scons_codigo int primary key identity (1, 1),
	scons_codcons int foreign key references cons_constancias not null,
	scons_codemp int not null,
	
	scons_anio int not null,
	scons_comentario_empleado varchar(1024) null,

	scons_estado char(3) default 'SOL' not null,-- SOL: Solicitada, GEN: Generada
	scons_codemp_reviso int,
	
	scons_link_consntancia varchar(2048) null,--OneDrive

	scons_fecha_generacion datetime null,
	scons_visto_por_empleado bit default 0,
	scons_fecha_visto_por_empleado datetime null,

	scons_activa bit not null default 1,
	scons_fecha_creacion datetime default getdate() not null
)
-- select * from scons_solicitud_constancia

select * from uonline.dbo.vst_empleados_x_unidad where ESDERHHH = 1

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-03-29 18:58:08.573>
	-- Description: <Devuelve las constancias solicitadas>
	-- =============================================
	-- select * from vst_solicitud_constancias order by codscons desc
alter view vst_solicitud_constancias
as
	select scons_codigo 'codscons', scons_codcons 'codcons', cons_nombre 'constancia', cons_ejemplo, cons_descripcion, scons_anio 'anio_constancia',
		scons_codemp 'codemp', emp1.emp_nombres_apellidos 'empleado_solicito', 
		iif(isnull(emp1.emp_email_empresarial, '') = '',  iif(isnull(emp1.emp_email_institucional, '') = '', emp1.emp_correo_alterno, emp1.emp_email_institucional), emp1.emp_email_empresarial)
		'corre_empleado',
		scons_comentario_empleado,
		scons_estado, case when scons_estado = 'SOL' then 'Solicitada' when scons_estado = 'GEN' then 'Generada' end 'estado',
		scons_codemp_reviso 'codemp_reviso', emp2.emp_nombres_apellidos 'empleado_reviso', 
		scons_link_consntancia 'link_constancia', scons_fecha_generacion 'fecha_generacion', 
		scons_visto_por_empleado 'visto_por_empleado', scons_fecha_visto_por_empleado, scons_activa 'activa', scons_fecha_creacion 'fecha_solicitud'
	from scons_solicitud_constancia
		inner join uonline.dbo.pla_emp_empleado emp1 on scons_codemp = emp1.emp_codigo
		inner join cons_constancias on scons_codcons = cons_codigo
		left join uonline.dbo.pla_emp_empleado emp2 on scons_codemp = emp2.emp_codigo
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-04-14 16:14:24.797>
	-- Description: <Devuelve el link del reporte de la constancia de RRHH>
	-- =============================================
	-- exec dbo.sp_link_contancia 1, 4291, 2023
alter procedure sp_link_contancia
	@codcons int = 0,
	@codemp int = 0,
	@anio int = 0
as
begin
	
	declare @link_constancia varchar(1024) = ''

	if @codcons = 1 -- Constancia de salario
		set @link_constancia = 'https://reportes.utec.edu.sv/reporte.aspx?reporte=rep_softec_constancia_salarial&filas=Mw==&campo0=MQ==&campo1=MTMw&campo2=VA==&tipo_archivo=P'
	if @codcons = 2 -- Constancia de trabajo
		set @link_constancia = 'https://reportes.utec.edu.sv/reporte.aspx?reporte=rep_softec_constancia_laboral&filas=Mw==&campo0=MQ==&campo1=MTMw&campo2=VA==&tipo_archivo=P'
	if @codcons = 3 -- Constancia de asignaturas
		set @link_constancia = 'https://reportes.utec.edu.sv/reporte.aspx?reporte=rep_softec_constancia_asignaturas&filas=Mw==&campo0=MQ==&campo1=MTMw&campo2=VA==&tipo_archivo=P'
	if @codcons = 4 -- Constancia combinada
		set @link_constancia = 'https://reportes.utec.edu.sv/reporte.aspx?reporte=rep_softec_constancia_combinada&filas=Mw==&campo0=MQ==&campo1=MTMw&campo2=VA==&tipo_archivo=P'
	if @codcons = 5 -- Reporte de pagos por año
		set @link_constancia = 'https://reportes.utec.edu.sv/reporte.aspx?reporte=rep_softec_constancia_pagos_por_anios&filas=Mw==&campo0=MQ==&campo1=MTMw&campo2=VA==&tipo_archivo=P'
	
	select @link_constancia 'link_constancia'

end
go
