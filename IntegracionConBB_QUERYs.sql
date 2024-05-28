--Proceso de cambio de contraseña
--[POST]/cambioContraseña
	-- {"carnet": "0308741981"}

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-10-26T14:36:12.1731369-06:00>
	-- Description: <Devuelve la ultima contraseña registrada>
	-- =============================================
	-- select dbo.fn_ultima_contrasenia ('2515652015') 'contrasenia'
create or alter function dbo.fn_ultima_contrasenia
(
    @cuenta VARCHAR(50)
)
RETURNS VARCHAR(50)
with schemabinding
AS
BEGIN
    DECLARE @contrasenia AS VARCHAR(50)
	select top 1 @contrasenia = esp_pass from dbo.web_esp_estadisticas_portal esp where esp.esp_usuario = @cuenta order by esp.esp_codigo desc
    RETURN @contrasenia
END
go

alter table dbo.ra_per_personas add per_id_usuario_blackboard varchar(20) null 
alter table dbo.pla_emp_empleado add emp_id_usuario_blackboard varchar(20) null
go
select * from ra_tde_TipoDeEstudio
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-10-26 09:52:23.150>
	-- Description: <Datos de usuarios en blackboard>
	-- =============================================
	-- select * from vst_bb_usuarios where cuenta = '0308741981'
	-- select * from vst_bb_usuarios where cuenta = 'rebeca.ganuza'
create or alter view vst_bb_usuarios
--with schemabinding
as
	select t.rol, t.id_usuario_blackboard, t.codigo_usuario, t.tabla_origen, t.cuenta, t.nombre_completo, t.carrera, '123'/*dbo.fn_ultima_contrasenia (t.cuenta)*/ 'clave',
	t.nombres, t.apellidos, t.sexo, t.fecha_nacimiento, t.nodeId, t.systemRoleIds
	from (
		select 'student' 'rol', per_id_usuario_blackboard 'id_usuario_blackboard', 'per' 'tabla_origen', per.per_codigo 'codigo_usuario', 
			replace(per.per_carnet, '-', '') 'cuenta', per_nombres 'nombres', per_apellidos 'apellidos', per_sexo 'sexo', cast(per_fecha_nac as date) 'fecha_nacimiento', 
			per.per_nombres_apellidos 'nombre_completo', pla.pla_alias_carrera 'carrera', '_5_1' 'nodeId'/*Traer de otro lado dinamicamente..*/,
			'user' 'systemRoleIds'
		from dbo.ra_per_personas per
			inner join dbo.ra_alc_alumnos_carrera alc on alc_codper = per_codigo
			inner join dbo.ra_pla_planes pla on alc_codpla = pla_codigo
		where pla.pla_alias_carrera like '%NO PRES%'
			
			union all

		select 'teacher' 'rol', emp_id_usuario_blackboard, 'emp' 'tabla_origen', emp.emp_codigo 'codigo_usuario', 
			replace(emp.emp_email_institucional, '@mail.utec.edu.sv', '') 'cuenta', 
			concat(emp_primer_nom, ' ', emp_segundo_nom) 'nombres', concat(emp_primer_nom, ' ', emp_segundo_nom) 'apellidos', emp_sexo, cast(emp_fecha_nac as date) emp_fecha_nac,
			emp.emp_nombres_apellidos 'nombre_completo', '' 'carrera', '_5_1' 'nodeId'/*Traer de otro lado dinamicamente..*/,
			'user' 'systemRoleIds'
		from dbo.pla_emp_empleado emp
		where emp.emp_codigo in (select distinct hpl.hpl_codemp from ra_hpl_horarios_planificacion hpl)
	) t
go

--select * from ra_tde_TipoDeEstudio
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-10-26 09:52:23.150>
	-- Description: <Origenes de datos creados en blackboard>
	-- =============================================
	-- select * from vst_bb_origenes_datos
create or alter view vst_bb_origenes_datos
as
	--Pregrado
	select --concat('Utec_',{TIPO_ESTUDIO_CORTO},'_',{St|Doc},'_',{ciclo})
	top 1 'Utec_Pg_St_02203' 'nombre_origen_datos'
	from ra_cil_ciclo