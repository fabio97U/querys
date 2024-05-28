use bd_rrhh
go
create schema mvi
go

/*
drop table mvi.revmov_revisores_movilidad_empleado
drop table mvi.anexmov_anexos_movilidad
drop table mvi.tipane_tipos_anexos
drop table mvi.movemp_movilidad_empleados
drop table mvi.prev_personas_revisoras_movilidad
drop table mvi.teapr_tipo_empleado_aprobacion
drop table mvi.insmov_instituciones_movilidad
drop table mvi.tippar_tipo_participacion
drop table mvi.tipmov_tipo_movilidad
*/

-- drop table mvi.tipmov_tipo_movilidad
create table mvi.tipmov_tipo_movilidad (
	tipmov_codigo int primary key identity (1, 1),
	tipmov_nombre varchar(250) not null,
	tipmov_mas_detalles bit not null default 1,
	tipmov_descripcion_mas_detalles varchar(500) not null,
	tipmov_activa bit not null default 1,
	tipmov_fecha_creacion datetime default getdate()
)
-- select * from mvi.tipmov_tipo_movilidad
insert into mvi.tipmov_tipo_movilidad (tipmov_nombre, tipmov_mas_detalles, tipmov_descripcion_mas_detalles)
values ('Congreso internacional', 1, 'colocar el nombre del congreso'), ('Seminario internacional', 1, 'colocar el nombre del seminario'), ('Estancia docente internacional', 0, ''), 
('Estancia de capacitación internacional', 1, 'colocar el nombre de la capacitación'), 
('Proyectos de desarrollo de capacidades', 1, 'colocar el nombre del proyecto'), ('Movilidad por investigaciones', 1, 'colocar el nombre de la investigacion'), 
('Misión internacional (giras académicas, o representación en instancias internacionales)', 1, 'colocar el nombre de la misión internacional'), 
('Otro', 1, 'especifique')
go

-- drop table mvi.tippar_tipo_participacion
create table mvi.tippar_tipo_participacion (
	tippar_codigo int primary key identity (1, 1),
	tippar_nombre varchar(250) not null,
	tippar_mas_detalles bit not null default 1,
	tippar_descripcion_mas_detalles varchar(500) not null,
	tippar_activa bit not null default 1,
	tippar_fecha_creacion datetime default getdate()
)
-- select * from mvi.tippar_tipo_participacion
insert into mvi.tippar_tipo_participacion (tippar_nombre, tippar_mas_detalles, tippar_descripcion_mas_detalles)
values ('Ponente', 0, ''), ('Panelista', 0, ''), ('Asistente', 0, ''), ('Otro', 1, 'Especifique')
go

-- drop table mvi.insmov_instituciones_movilidad
create table mvi.insmov_instituciones_movilidad(
	insmov_codigo int primary key identity (1, 1),
	insmov_nombre_institucion varchar(1024) not null,
	insmov_activa bit not null default 1,
	insmov_fecha_creacion datetime default getdate(),

	insmov_codciu int,
	insmov_codorg int
)
--select * from mvi.insmov_instituciones_movilidad
--insert into mvi.insmov_instituciones_movilidad (insmov_nombre_institucion, insmov_codciu) values ('Universidad Internacional de la Rioja', 1)

-- drop table mvi.teapr_tipo_empleado_aprobacion
create table mvi.teapr_tipo_empleado_aprobacion (
	teapr_codigo int primary key identity (1, 1),
	teapr_tipo_empleado varchar(30) not null,
	teapr_fecha_creacion datetime default getdate()
)
-- select * from mvi.teapr_tipo_empleado_aprobacion
insert into mvi.teapr_tipo_empleado_aprobacion (teapr_tipo_empleado) values ('Academico'), ('Administrativo'), ('Investigaciones')

-- drop table mvi.prev_personas_revisoras_movilidad
create table mvi.prev_personas_revisoras_movilidad (
	prev_codigo int primary key identity (1, 1),
	prev_codteapr int foreign key references mvi.teapr_tipo_empleado_aprobacion not null,
	prev_orden int not null,
	prev_codemp int null,
	prev_revisor_anexos bit default 0 not null,
	prev_revisor_activo bit default 1 not null,
	prev_fecha_creacion datetime default getdate()
)
-- select * from mvi.prev_personas_revisoras_movilidad
insert into mvi.prev_personas_revisoras_movilidad (prev_revisor_anexos, prev_codteapr, prev_orden, prev_codemp) 
values (1, 1, 0, 4291), /*(1, 1, 1, 3853), */(1, 1, 1, 364), (0, 1, 2, NULL), (0, 1, 3, 184), --academicos --(0, 1, 4, 183),
(1, 2, 0, 4291), /*(1, 2, 1, 3853), */(1, 2, 1, 364), (0, 2, 2, NULL), (0, 2, 3, 184),--administrativos -- (0, 2, 4, 181)
(1, 3, 0, 4291), /*(1, 2, 1, 3853), */(1, 3, 1, 364), (0, 3, 2, 788), (0, 3, 3, 184)-- investigaciones --, (0, 2, 4, 181)

-- drop table mvi.tipane_tipos_anexos
create table mvi.tipane_tipos_anexos (
	tipane_codigo int primary key identity (1, 1),
	tipane_codtipmov int foreign key references mvi.tipmov_tipo_movilidad not null,
	tipane_tipo_anexo varchar(10) not null default 'SAL',--SAL: deben cargarse previamente para un permiso de salida internacional, REG: deben cargarse a su regreso

	tipane_nombre_tipo varchar(125) not null,
	tipane_obligatorio bit default 1 not null,

	tipane_activo bit default 1 not null,
	tipane_fecha_creacion datetime default getdate()
)
-- select * from mvi.tipane_tipos_anexos
insert into mvi.tipane_tipos_anexos (tipane_tipo_anexo, tipane_nombre_tipo, tipane_codtipmov, tipane_obligatorio) 
values ('SAL', 'Carta invitación', 1, 1), ('SAL', 'Carta aceptación', 1, 1),--, ('SAL', 'Delegación por misión institucional'), 
('REG', 'Certificado , diploma, carta o algún otro comprobante', 1, 1), ('REG', 'Si resulta una publicación, la aceptación y agenda', 1, 0),

('SAL', 'Carta invitación', 2, 1), ('SAL', 'Carta aceptación', 2, 1),
('REG', 'Certificado , diploma, carta o algún otro comprobante', 2, 1), ('REG', 'Agenda', 2, 1),

('SAL', 'Carta invitación', 3, 1), ('SAL', 'Carta aceptación', 3, 1),
('REG', 'Certificado de curso impartido', 3, 1), ('REG', 'Diploma o carta de estancia', 3, 1), ('REG', 'Agenda o plan de trabajo', 3, 0),

('SAL', 'Carta invitación', 4, 1), ('SAL', 'Carta aceptación', 4, 1),
('REG', 'Certificado, diploma', 4, 1), ('REG', 'Agenda', 4, 1),

('SAL', 'Carta invitación', 5, 1), ('SAL', 'Carta aceptación', 5, 1),
('REG', 'Certificado, diplomas', 5, 1), ('REG', 'Agenda o plan de trabajo', 5, 1),

('SAL', 'Carta invitación', 6, 1), ('SAL', 'Carta aceptación', 6, 1),
('REG', 'Certificado o diploma', 6, 1), ('REG', 'Agenda', 6, 1),

('SAL', 'Carta invitación', 7, 1), ('SAL', 'Carta aceptación', 7, 1),
('REG', 'Certificado, diplomas', 7, 1), ('REG', 'Agenda o plan de trabajo', 7, 1),

('SAL', 'Carta invitación', 8, 1), ('SAL', 'Carta aceptación', 8, 1),
('REG', 'Certificado o diploma', 8, 1), ('REG', 'Agenda', 8, 1)
go

	-- =============================================
	-- Author:      <Jonathan>
	-- Create date: <2024-04-05 15:43:51.747>
	-- Description: <Devuelve la lista de instituciones registradas>
	-- =============================================
	-- select * from vst_instituciones_organizaciones
create or alter VIEW [dbo].[vst_instituciones_organizaciones] 
AS
	select insmov_codigo 'codinsmov', insmov_nombre_institucion 'nombre_institucion', insmov_codciu 'codciu', ciu_ciudad 'nombre_ciudad', ciu_codpa 'codpa', 
		pa_pais 'nombre_pais', pa_codconti 'codconti', conti_continente 'nombre_continente', org_codigo 'codorg', org_redes 'nombre_red', case when insmov_codorg is not null then 'Organizacion' else 'Institucion' end 'tipo_institucion', 
		insmov_activa
	from mvi.insmov_instituciones_movilidad
		left join ciu_ciudad on insmov_codciu = ciu_codigo
		left join pa_pais on ciu_codpa = pa_codigo
		left join conti_continente on pa_codconti = conti_codigo
		left join org_organizaciones on insmov_codorg = org_codigo
GO

-- drop table mvi.movemp_movilidad_empleados
create table mvi.movemp_movilidad_empleados (
    movemp_codigo int primary key identity (1, 1),
	movemp_codteapr varchar(15),--Academia, Administrativo
	movemp_codemp int not null,
	movemp_coduni int not null,
	movemp_codplz int not null,
	movemp_codtipmov int foreign key references mvi.tipmov_tipo_movilidad not null,
	movemp_tipo_movilidad_detalle varchar(500) null,

	movemp_codinsmov int foreign key references mvi.insmov_instituciones_movilidad not null,
	movemp_desde date not null,
	movemp_hasta date not null,
	movemp_codtippar int foreign key references mvi.tippar_tipo_participacion not null,
	movemp_tipo_participacion_detalle varchar(500) null,

	movemp_codemp_jefe int null,
	movemp_autorizado_jefe bit default 0 null,
	movemp_estado varchar(3) default 'PEN' not null, --PEN: Pendiente, APR: Aprobado, DEN: Denegado
	movemp_fecha_reviso_jefe datetime null,
	movemp_comentario_jefe varchar(1024) null,
	movemp_goce_sueldo bit default 0 null,

	movemp_cantidad_revisores int not null,

	movemp_fecha_creacion datetime default getdate() not null
);
go
-- select * from mvi.movemp_movilidad_empleados
--insert into mvi.movemp_movilidad_empleados 
--(movemp_codteapr, movemp_codemp, movemp_coduni, movemp_codplz, movemp_codtipmov, movemp_tipo_movilidad_detalle, movemp_codinsmov, movemp_desde, movemp_hasta, movemp_codtippar, movemp_cantidad_revisores)
--values (2, 4291, 50, 53, 1, 'Voy a un congreso..', 1, '2024-03-03', '2024-04-04', 3, 3)

-- drop table mvi.anexmov_anexos_movilidad
create table mvi.anexmov_anexos_movilidad ( -- Pueden ser varios archivos por cada empleado
    anexmov_codigo int primary key identity (1, 1),
    anexmov_codmovemp int foreign key references mvi.movemp_movilidad_empleados,
    anexmov_codtipane int foreign key references mvi.tipane_tipos_anexos,
	
	anexmov_estado varchar(3) default 'PEN' not null, --PEN: Pendiente, APR: Aprobado, DEN: Denegado
	anexmov_codemp_revision int null,
	anexmov_fecha_revison datetime null,
	anexmov_comentario varchar(1024) null,

	anexmov_nombre_archivo varchar(1024) null,
	anexmov_link_anexo varchar(1024) null,

	anexmov_fecha_creacion datetime default getdate() not null
);
go
-- select * from mvi.anexmov_anexos_movilidad
--insert into mvi.anexmov_anexos_movilidad (anexmov_codmovemp, anexmov_codtipane, anexmov_nombre_archivo, anexmov_link_anexo)
--values(1, 1, 'Carta invitación.png', 'https://www.google.com/?hl=es'), (1, 2, 'Carta aceptación.png', 'https://www.google.com/?hl=es'), (1, 3, 'Delegación por misión institucional.jpg', 'https://www.google.com/?hl=es'), 
--(1, 4, null, null), (1, 5, null, null)

-- drop table mvi.revmov_revisores_movilidad_empleado
create table mvi.revmov_revisores_movilidad_empleado (
	revmov_codigo int primary key identity (1, 1),
    revmov_codmovemp int foreign key references mvi.movemp_movilidad_empleados,
	
	revmov_codemp_revisor int,
	revmov_codprev int foreign key references mvi.prev_personas_revisoras_movilidad,
	
	revmov_estado varchar(3) default 'PEN' not null, --PEN: Pendiente, APR: Aprobado, DEN: Denegado
	revmov_fecha_revison datetime null,
	revmov_comentario varchar(1024) null,

	revmov_fecha_creacion datetime default getdate()
);
-- select * from mvi.revmov_revisores_movilidad_empleado
go
--insert into mvi.revmov_revisores_movilidad_empleado (revmov_codmovemp, revmov_codprev)
--values (1, 5), (1, 6), (1, 7), (1, 8)
--go

--select * from uonline.dbo.V_puestos_empleados where emp_codigo = 276

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2024-02-27 09:27:31.053>
	-- Description: <Vista de la movilidad de empleados>
	-- =============================================
	-- select * from mvi.vst_movilidad_empleados where codemp = 4291
create or alter view mvi.vst_movilidad_empleados
as
	select movemp_estado 'estado_general', movemp_codigo 'codmovemp', teapr_codigo 'codteapr', v.bd_rrhh_codteapr 'codteapr_actual', teapr.teapr_tipo_empleado 'tipo_empleado', 
		movemp_codemp 'codemp', emp.emp_apellidos_nombres 'nombre_empleado', emp.emp_email_empresarial 'correo_empleado', cast(d.departamento as int) 'coduni', d.descripcion 'nombre_departamento', p.puesto, p.descripcion 'nombre_puesto', movemp_codtipmov 'codtipmov', tipmov_nombre 'tipo_movilidad',
		movemp_tipo_movilidad_detalle 'tipo_movilidad_detalle', insmov_codigo 'codinsmov', insmov_nombre_institucion 'nombre_institucion', 
		movemp_desde, movemp_hasta, case when movemp_desde = movemp_hasta then FORMAT(movemp_hasta, 'dd/MM/yyyy') else concat(FORMAT(movemp_desde, 'dd/MM/yyyy'), ' a ', FORMAT(movemp_hasta, 'dd/MM/yyyy')) end 'fecha_desde_hasta_junto',
		tippar_codigo 'codtippar', tippar_nombre 'tipo_participacion', movemp_tipo_participacion_detalle 'tipo_participacion_detalle', movemp_fecha_creacion 'fecha_solicitud',
		movemp_codemp_jefe, v2.EMPRESARIAL 'correo_jefe_unidad', movemp_comentario_jefe, movemp_goce_sueldo
	from mvi.movemp_movilidad_empleados
		inner join mvi.teapr_tipo_empleado_aprobacion teapr on movemp_codteapr = teapr_codigo
		inner join uonline.dbo.pla_emp_empleado emp on emp.emp_codigo = movemp_codemp
		inner join mvi.tipmov_tipo_movilidad on movemp_codtipmov = tipmov_codigo
		inner join mvi.insmov_instituciones_movilidad on movemp_codinsmov = insmov_codigo
		inner join mvi.tippar_tipo_participacion on tippar_codigo = movemp_codtippar

		left join [192.168.1.114].GRUPO.UTEC.EMPLEADO E on e.empleado = emp.emp_codigo
		LEFT OUTER JOIN [192.168.1.114].GRUPO.UTEC.DEPARTAMENTO D on D.DEPARTAMENTO = E.DEPARTAMENTO
		LEFT OUTER JOIN [192.168.1.114].GRUPO.UTEC.PUESTO P on P.PUESTO = E.PUESTO

		left join uonline.dbo.V_puestos_empleados v on v.emp_codigo = emp.emp_codigo
		left join uonline.dbo.vst_empleados_x_unidad v2 on v2.CODIGO = movemp_codemp_jefe
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2024-02-27 10:41:27.037>
	-- Description: <Vista de los documentos adjuntos para la movilidad de empleados>
	-- =============================================
	-- select * from mvi.vst_anexos_movilidad_empleados where codemp = 4291
create or alter view mvi.vst_anexos_movilidad_empleados
as
	select anexmov_codigo 'codanexmov', tipane_codigo 'codtipane', tipane_tipo_anexo 'tipo_anexo', tipane_obligatorio, tipane_activo, codmovemp, codemp, nombre_empleado, tipane_nombre_tipo, 
		anexmov_estado, anexmov_codemp_revision, 
		anexmov_fecha_revison, anexmov_comentario, anexmov_link_anexo, anexmov_fecha_creacion, anexmov_nombre_archivo
	from mvi.anexmov_anexos_movilidad
		inner join mvi.vst_movilidad_empleados on anexmov_codmovemp = codmovemp
		inner join mvi.tipane_tipos_anexos on tipane_codigo = anexmov_codtipane	
go

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2024-02-27 11:22:30.613>
	-- Description: <Vista de las estado de la revision para la movilidad de empleados>
	-- =============================================
	-- select * from mvi.vst_revisores_movilidad_empleados where codemp = 4291 order by codrevmov, orden_revision
create or alter view mvi.vst_revisores_movilidad_empleados
as
	select revmov_codigo 'codrevmov', codmovemp, codemp, nombre_empleado, prev_orden 'orden_revision', prev_revisor_anexos, v.CODIGO 'codemp_revisor', 
		v.NOMBRECOMPLETO 'nombre_revisor', v.EMPRESARIAL 'correo_revisor',
		revmov_estado, revmov_fecha_revison, revmov_comentario, revmov_fecha_creacion 
	from mvi.revmov_revisores_movilidad_empleado
		inner join mvi.vst_movilidad_empleados on revmov_codmovemp = codmovemp
		inner join mvi.prev_personas_revisoras_movilidad on revmov_codprev = prev_codigo
		inner join uonline.dbo.vst_empleados_x_unidad v on v.CODIGO = revmov_codemp_revisor--prev_codemp
go
