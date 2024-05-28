USE [uonline]
--QUITAR COMENTARIOS DE LAS VISTAS AL FINALIZAR PARA DEJAR SOLO VIRTUALES EN TODO :)  
--TABLAS SOLO CON LOS CAMPOS QUE SE UTILIZAN
--7502682021 09111996 estudiante maestria
GO
CREATE SCHEMA bkb
GO

create TABLE bkb.ori_origen(
	ori_id VARCHAR(100) PRIMARY KEY,
	ori_externalId VARCHAR(100),
	ori_description varchar(225),
	ori_cil_codigo INT,
	ori_estado BIT,
	ori_fecha_creacion datetime default getdate()
);
-- select * from bkb.ori_origen
GO

	-- =============================================
	-- Author:      <Ever>
	-- Create date: <2024-01-08 16:59:18.000>
	-- Description: <Devuelve todos los origenes por ciclo>
	-- =============================================
	-- select * from bkb.vst_bkb_origen where codcil = 134
CREATE OR ALTER VIEW bkb.vst_bkb_origen
AS
	SELECT t.ExternalId, ori_id 'id_blackboard', t.codigo 'codcil', t.estado,
	CASE when t.ExternalId like '%Pg%' then 'U' when t.ExternalId like '%Mae%' then 'M' else '' end 'tipo_estudio'
	FROM(
		SELECT 
			CASE 
				WHEN v.tipo = 'cil_vigente' THEN concat('Utec_Pg_St_',concat('0', cil.cil_codcic, cil.cil_anio))
				WHEN v.tipo = 'cil_vigente_pre' THEN concat('Utec_Prees_St_',concat('0', cil.cil_codcic, cil.cil_anio))         
				WHEN v.tipo = 'cil_vigente_mae' THEN concat('Utec_Mae_St_',concat('0', cil.cil_codcic, cil.cil_anio))
				ELSE NULL
			END AS 'ExternalId',
			cil.cil_codigo 'codigo',v.vigente 'estado'
		FROM ra_cil_ciclo cil
		CROSS APPLY (VALUES ('cil_vigente', cil.cil_vigente), ('cil_vigente_pre', cil.cil_vigente_pre), ('cil_vigente_mae', cil.cil_vigente_mae)) v (tipo, vigente)
		where cil_codigo > 130
		UNION ALL

		SELECT 
			CASE
				WHEN v.tipo = 'cil_vigente' THEN concat('Utec_Pg_Doc_',concat('0', cil.cil_codcic, cil.cil_anio))
				WHEN v.tipo = 'cil_vigente_pre' THEN concat('Utec_Prees_Doc_',concat('0', cil.cil_codcic, cil.cil_anio))         
				WHEN v.tipo = 'cil_vigente_mae' THEN concat('Utec_Mae_Doc_',concat('0', cil.cil_codcic, cil.cil_anio))
				ELSE NULL
			END AS 'ExternalId',
			cil.cil_codigo 'codigo',v.vigente 'estado'
		FROM ra_cil_ciclo cil
		CROSS APPLY (VALUES ('cil_vigente', cil.cil_vigente), ('cil_vigente_pre', cil.cil_vigente_pre), ('cil_vigente_mae', cil.cil_vigente_mae)) v (tipo, vigente)
		where cil_codigo > 130
	)t
		left join bkb.ori_origen on ori_externalId = t.ExternalId
go

-- drop table bkb.nodo
--ALTER TABLE ra_tde_TipoDeEstudio DROP CONSTRAINT FK__ra_tde_Ti__tde_n__7F94929I;
CREATE TABLE bkb.nodo(
	nodo_id VARCHAR(100),
	nodo_externalId VARCHAR(100) PRIMARY KEY,
	nodo_title VARCHAR(225),
	nodo_description varchar(225),
	nodo_per_tipo varchar(5),
	nodo_per_estado varchar(5)
);
-- select * from bkb.nodo
GO

-- drop table bkb.usr_usuarios
CREATE TABLE bkb.usr_usuarios ( 
	usr_id VARCHAR(100) PRIMARY KEY, 
	usr_uuid NVARCHAR(225),
	usr_nameGiven VARCHAR(225),
	usr_nameFamily VARCHAR(225),
	usr_gender VARCHAR(10),--Male/Female/Other
	usr_birthDate DATETIME,
	usr_userName VARCHAR(225),
	usr_usrPassword VARCHAR(225),
	usr_available BIT, -- 0=YES , 1=NO
	usr_institutionRoleIds NVARCHAR(250),
	usr_systemRoleIds NVARCHAR(250),
	usr_dataSourceId VARCHAR(100) foreign key references bkb.ori_origen,
	usr_nodeId VARCHAR(100) foreign key references bkb.nodo,
	usr_fecha_creacion datetime default getdate()
);
-- select * from bkb.usr_usuarios
GO

-- drop table bkb.peri_periodo
CREATE TABLE bkb.peri_periodo(
	peri_id varchar(100) PRIMARY KEY,
	peri_externalId VARCHAR(100),
	peri_dataSourceId VARCHAR(100) foreign key references bkb.ori_origen,
	peri_name VARCHAR(225),
	peri_description VARCHAR(225),
	peri_usr_available BIT,
	peri_durationType VARCHAR(50),
	peri_durationStart VARCHAR(225),
	peri_durationEnd VARCHAR(225),
	
	peri_tipo_estudio varchar(3),
	peri_fecha_creacion datetime default getdate()
);
-- select * from bkb.peri_periodo
GO

	-- =============================================
	-- Author:      <Ever>
	-- Create date: <2023-12-09 13:42:04.090>
	-- Description: <Devuelve la data de las materias virtuales disponibles para crearlas en blackboard>
	-- =============================================
	-- select * from bkb.vst_bkb_curso where codcil = 134 and codhpl = 55193
CREATE OR ALTER VIEW bkb.vst_bkb_curso  
as
	SELECT codigo_origen, table_origen, t.nodeId, t.dataSourceId, t.codcil,  t.ciclo,t.codigo_curso,t.seccion, t.codPre, t.nombre, t.descripcion, 
		t.status, t.periodoId, t.disponible, t.tipo_duracion, t.tipo_inscripcion, t.modulo_disponible, t.tipo_estudio, 
		c.cur_id, c.cur_fecha_creacion
	FROM (
		--Pregrado
		SELECT n.nodo_id 'nodeId', o.id_blackboard 'dataSourceId', hpl.hpl_codigo 'codhpl', cil.cil_codigo 'codcil',
			concat(replace(hpl.hpl_codmat,' ',''), hpl.hpl_descripcion,'-0', cil.cil_codcic, cil.cil_anio) 'codigo_curso', 
			hpl_descripcion 'seccion', '' 'codPre', mat.mat_nombre 'nombre', '' 'descripcion', 'ultra' 'status', 
			peri.peri_id 'periodoId', cil.cil_estado 'disponible', 'Term' 'tipo_duracion', 'InstructorLed' 'tipo_inscripcion', '' 'modulo_disponible',
			o.tipo_estudio, hpl_codigo 'codigo_origen', 'hpl' 'table_origen', concat('0', cil_codcic, '-', cil_anio) 'ciclo'
		from dbo.ra_hpl_horarios_planificacion hpl 
			inner join dbo.ra_cil_ciclo cil on cil.cil_codigo = hpl.hpl_codcil
			inner join dbo.ra_esc_escuelas on hpl_codesc = esc_codigo
			inner join bkb.nodo n on n.nodo_per_tipo = esc_tipo and n.nodo_per_estado = 'A'
			inner join bkb.vst_bkb_origen o on o.codcil = hpl_codcil and o.ExternalId not like '%Prees%' and o.tipo_estudio = n.nodo_per_tipo 
				and o.ExternalId like '%Doc%'
			inner join dbo.ra_mat_materias mat on hpl.hpl_codmat = mat.mat_codigo

			inner join bkb.peri_periodo peri on cil.cil_codigo = peri.peri_description
		where hpl_codcil >= 131 and hpl.hpl_tipo_materia = 'V'
	
		--UNION ALL
		----PREESPECIALIDAD
		--select '_196_1' 'nodeId', '_1_1' 'dataSourceId',hmp.hmp_codigo 'codigo', cil.cil_codigo 'Codcil',
		--concat('P',LEFT(replace(modulo.mpr_nombre,' ',''), 3),modulo.mpr_orden,'-',hmp.hmp_descripcion,'-',LEFT(FORMAT(CONVERT(DATETIME, fecha.apr_fecha_del, 120), 'MMMM'), 1), FORMAT(CONVERT(DATETIME, fecha.apr_fecha_del, 120), 'yy')) 'codigo_curso', 
		--hmp.hmp_descripcion 'seccion',  modulo.mpr_codpre 'codPre',
		--modulo.mpr_nombre 'nombre', '' 'descripcion', 'ultra' 'status', peri.peri_id 'periodoId', cil.cil_estado 'disponible','Term' 'tipo_duracion',
		--'InstructorLed' 'tipo_inscripcion', modulo.mpr_visible 'modulo_disponible'
		--from dbo.pg_pre_preespecializacion pre
		--INNER JOIN dbo.pg_mpr_modulo_preespecializacion modulo ON pre.pre_codigo =  modulo.mpr_codpre
		--INNER JOIN dbo.pg_apr_aut_preespecializacion fecha ON pre.pre_codigo = fecha.apr_codpre
		--INNER JOIN dbo.ra_cil_ciclo cil ON fecha.apr_codcil = cil.cil_codigo
		--INNER JOIN dbo.pg_hmp_horario_modpre hmp ON hmp.hmp_codmpr = modulo.mpr_codigo
		--LEFT OUTER JOIN bkb.peri_periodo peri ON cil.cil_codigo = peri.peri_description
		--where /*hmp.hmp_tpm_tipo_materia = 'V' AND*/ modulo.mpr_visible = 'S' 
		--union all
		--select distinct  '_196_1' 'nodeId','_1_1' 'dataSourceId',hm.hm_codigo 'codigo',cil.cil_codigo 'Codcil'
		--,concat('P',LEFT(replace(hm.hm_nombre_mod,' ',''), 3),hm.hm_modulo,'-',hm.hm_descripcion,'-',LEFT(FORMAT(CONVERT(DATETIME, insm.insm_fecha, 120), 'MMMM'), 1), FORMAT(CONVERT(DATETIME, insm.insm_fecha, 120), 'yy')) 'codigo_curso'
		--,hm.hm_descripcion 'seccion',insm.insm_codper 'codPre',hm.hm_nombre_mod 'nombre','' 'descripcion','ultra' 'status',
		--peri.peri_id 'periodoId',cil.cil_estado 'disponible','Term' 'tipo_duracion','InstructorLed' 'tipo_inscripcion',insm.insm_estado 'modulo_disponible'
		--from pg_insm_inscripcion_mod insm
		--inner join pg_hm_horarios_mod hm on insm.insm_codhm = hm.hm_codigo
		--inner join ra_cil_ciclo cil on cil.cil_codigo = hm.hm_codcil
		--LEFT OUTER JOIN bkb.peri_periodo peri ON peri.peri_description = hm.hm_codcil
		----where hm.hm_tpm_tipo_materia = 'V'

	)t
		left join bkb.cur_cursos c on c.cur_courseId = t.codigo_curso
go

-- drop table bkb.cur_cursos
CREATE TABLE bkb.cur_cursos(
	cur_id varchar(100) PRIMARY KEY,
	cur_uuid NVARCHAR(225),
    cur_externalId VARCHAR(100), -- bkb.vst_bkb_curso.codigo_curso
	cur_nodeId VARCHAR(100) foreign key references bkb.nodo,
    cur_dataSourceId VARCHAR(100) foreign key references bkb.ori_origen,
    cur_courseId VARCHAR(255), --: bkb.vst_bkb_curso.codigo_curso
    cur_name VARCHAR(255),
	cur_created DATETIME,
    cur_description NVARCHAR(250),
    cur_ultraStatus VARCHAR(20),
    cur_termId VARCHAR(100) foreign key references bkb.peri_periodo, --id del Periodo
    cur_available VARCHAR(5), --Term/Yes/No -default Term
    cur_DurationType VARCHAR(20), -- Term/Continuous -default Term
    cur_enrollmentType VARCHAR(20),
	cur_fecha_creacion datetime default getdate()
);
go
-- select * from bkb.cur_cursos

-- drop table bkb.mim_miembros
CREATE TABLE bkb.mim_miembros(
	mim_id int identity(1,1) PRIMARY KEY,
	mim_idBkb VARCHAR(225),
	mim_userId NVARCHAR(225), -- fk bkb.usr_usuarios.usr_userName
	mim_courseId NVARCHAR(225), -- fk bkb.cur_cursos.cur_externalId
	mim_dataSourceId VARCHAR(100) foreign key references bkb.ori_origen,
	mim_created DATETIME,
	mim_available NVARCHAR(5),
	mim_courseRoleId NVARCHAR(100),
	mim_fecha_creacion datetime default getdate()
);
go
-- select * from bkb.mim_miembros

CREATE OR ALTER PROCEDURE bkb.crearUsuario
    @usr_uuid NVARCHAR(250),
    @usr_nameGiven VARCHAR(225),
    @usr_nameFamily VARCHAR(225),
    @usr_gender VARCHAR(10),
    @usr_birthDate DATETIME,
    @usr_userName VARCHAR(225),
    @usr_usrPassword VARCHAR(225),
    @usr_available BIT,
    @usr_institutionRoleIds NVARCHAR(250),
    @usr_systemRoleIds NVARCHAR(250),
    @usr_dataSourceId VARCHAR(20),
    @usr_nodeId VARCHAR(20),
    @usr_id VARCHAR(20)
AS
BEGIN 
    SET NOCOUNT ON;

    BEGIN TRY
        -- Verificar si el userName ya existe en la tabla Usuario
        IF EXISTS (SELECT 1 FROM bkb.usr_Usuarios WHERE usr_userName = @usr_userName)
        BEGIN
            SELECT -1 AS res, 'El usuario debe ser diferente en la base de datos de UTEC' AS msj;
            RETURN;
        END

        INSERT INTO bkb.usr_Usuarios(usr_id, usr_uuid, usr_nameGiven, usr_nameFamily, usr_gender, usr_birthDate, usr_userName, usr_UsrPassword, usr_available, usr_institutionRoleIds, usr_systemRoleIds, usr_dataSourceId, usr_nodeId)
        VALUES (@usr_id, @usr_uuid, @usr_nameGiven, @usr_nameFamily, @usr_gender, @usr_birthDate, @usr_userName, @usr_usrPassword, @usr_available, @usr_institutionRoleIds, @usr_systemRoleIds, @usr_dataSourceId, @usr_nodeId);
		 
        SELECT 1 AS res, 'listo, usuario creado!' AS msj;
    END TRY
    BEGIN CATCH
        SELECT -1 AS res, 'Error ' + ERROR_MESSAGE() AS msj;
    END CATCH;
END

GO

CREATE OR ALTER PROCEDURE bkb.crearCurso
	@cur_id varchar(20),
	@cur_uuid NVARCHAR(250),
    @cur_externalId VARCHAR(255),
	@cur_nodeId varchar(20),
    @cur_dataSourceId VARCHAR(20),
    @cur_courseId VARCHAR(255),
    @cur_name VARCHAR(255),
	@cur_created DATETIME,
    @cur_description NVARCHAR(250),
    @cur_ultraStatus VARCHAR(20),
    @cur_termId VARCHAR(255),
    @cur_available VARCHAR(5),
    @cur_DurationType VARCHAR(20),
    @cur_enrollmentType VARCHAR(20)
AS
BEGIN 
SET NOCOUNT ON;
	DECLARE @ErrorMessage VARCHAR(255);

	BEGIN TRY
        IF EXISTS (SELECT 1 FROM bkb.cur_Cursos WHERE cur_courseId = @cur_courseId)
        BEGIN
		SELECT -1 AS res, 'Ya existe el curso DB UTEC' AS msj;
        END
        
		INSERT INTO bkb.cur_Cursos(cur_id, cur_uuid, cur_externalId, cur_nodeId, cur_dataSourceId, cur_courseId, cur_name, cur_created, cur_description, cur_ultraStatus, cur_termId, cur_available, cur_DurationType, cur_enrollmentType) 
		VALUES (@cur_id, @cur_uuid, @cur_externalId,@cur_nodeId, @cur_dataSourceId, @cur_courseId, @cur_name, @cur_created, @cur_description, @cur_ultraStatus, @cur_termId, @cur_available, @cur_DurationType, @cur_enrollmentType);
	
        SELECT 1 AS res, 'listo, usuario creado!' AS msj;
	END TRY
    BEGIN CATCH
        SELECT -1 AS res, 'Ya existe el curso DB UTEC' AS msj;
    END CATCH;
END
GO

CREATE OR ALTER PROCEDURE bkb.crearOrigenDeDato
	@ori_id VARCHAR(100),
	@ori_externalId VARCHAR(100),
	@ori_description varchar(225),
	@ori_cil_codigo INT,
	@ori_estado BIT
AS
BEGIN 
SET NOCOUNT ON;
	BEGIN TRY
        IF EXISTS (SELECT 1 FROM bkb.ori_origen WHERE ori_externalId = @ori_externalId)
        BEGIN
		SELECT -1 AS res, 'Ya existe el origen en DB UTEC' AS msj;
		RETURN
        END
        
		INSERT INTO bkb.ori_origen(ori_id, ori_externalId, ori_description, ori_cil_codigo, ori_estado) 
		VALUES (@ori_id, @ori_externalId, @ori_description, @ori_cil_codigo, @ori_estado);
	
        SELECT 1 AS res, 'listo, MATERIAS ASIGNADAS creado!' AS msj;
	END TRY
    BEGIN CATCH
        SELECT -1 AS res, 'Ya existe asignacion DB UTEC' AS msj;
    END CATCH;
END
GO

CREATE OR ALTER PROCEDURE bkb.AsignarMateriasConUsuario
	@mim_idBkb VARCHAR(225),
	@mim_userId NVARCHAR(225),
	@mim_courseId NVARCHAR(225),
	@mim_dataSourceId NVARCHAR(225),
	@mim_created DATETIME,
	@mim_available NVARCHAR(5),
	@mim_courseRoleId NVARCHAR(100)
AS
BEGIN 
SET NOCOUNT ON;
	BEGIN TRY

		INSERT INTO bkb.mim_miembros(mim_idBkb, mim_userId, mim_courseId, mim_dataSourceId, mim_created,mim_available,mim_courseRoleId) 
		VALUES (@mim_idBkb, @mim_userId, @mim_courseId, @mim_dataSourceId,@mim_created,@mim_available,@mim_courseRoleId);
	
        SELECT 1 AS res, 'listo, usuario creado!' AS msj;
	END TRY
    BEGIN CATCH
        SELECT -1 AS res, 'error en DB UTEC proc mim_miembros' AS msj;
    END CATCH;
END
GO

--EXEC bkb.AsignarMateriasConUsuario 
--                    @mim_idBkb='_1_1',
--                    @mim_userId=1727092020,
--                    @mim_courseId='_1_1',
--                    @mim_dataSourceId='_1_1',
--                    @mim_created='2024-01-08T20:20:02.713Z',
--                    @mim_available='yes',
--                    @mim_courseRoleId='Student'
--go

select * from bkb.peri_periodo where peri_description = 134

	-- =============================================
	-- Author:      <Ever>
	-- Create date: <2023-11-09 14:04:37.497>
	-- Description: <Devuelva los periodos de cada tipo de estudio, si es pregrado es la duracion del ciclo, si maes o prees son la duracion (semanas) del modulo>
	-- =============================================
	-- select * from bkb.vst_bkb_periodo where codcil = 134
CREATE OR ALTER VIEW bkb.vst_bkb_periodo 
AS
	select  cil.cil_codigo 'codcil', '_107_1' 'dataSourceId',concat('Ciclo 0',cil.cil_codcic,'-',cil.cil_anio) 'nombre', cil.cil_inicio 'inicio',
		cil.cil_fin 'fin', 'DateRange' 'tipo',cil.cil_estado 'estado' , 'PREGRADO' 'tipo_Estudiantes', peri_id, peri_fecha_creacion
	from dbo.ra_cil_ciclo cil
		left join bkb.peri_periodo on cil_codigo = peri_description
	where cil_codigo >= 131
go


--agregue per_estado y emp_estado
--cambie rol del docente de 'teacher' a 'FACULTY' (es 'personal docente' en blackboard)
--nodeId (usar per_tipo para saber si el estudiante es de maestria, etc.)
--Origen de datos (se agregó "ra_ins_inscripcion" , "ra_cil_ciclo" y en el WHERE "AND ins.ins_fecha")

--LOS EMPLEADOS NO SE COMO PONERLES NODO YA QUE DAN CLASES PARA PREGRADO Y PREESPECIALIDAD EL MISMO CICLO        PROBLEMA ***********
--LOS MISMO CON EL ORIGEN DE DATOS, EL MISMO PROBLEMA

-- alter table dbo.ra_per_personas add per_id_usuario_blackboard varchar(100)
-- alter table dbo.pla_emp_empleado add emp_id_usuario_blackboard varchar(100)

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-10-26 09:52:23.150>
	-- Description: <Datos de usuarios en blackboard>
	-- =============================================
	-- exec bkb.sp_bb_usuarios @cuenta = '0220582024'
create or alter procedure bkb.sp_bb_usuarios
	@cuenta varchar(30) = ''
as
begin
	
	set dateformat dmy

	declare @codigo_usuario int = 0, @esp_tipo varchar(30) = '', @esp_clave varchar(125) = '', @rol varchar(20) = 'student', 
		@esp_codigo int = 0

	select top 1 @esp_codigo = esp_codigo, @esp_tipo = esp_tipo, @esp_clave = esp_pass, @codigo_usuario = esp_cuenta_codigo
	from web_esp_estadisticas_portal where esp_usuario = @cuenta
	order by esp_codigo desc

	if @esp_tipo = 'Docente'
	begin
		set @rol = 'FACULTY'
	end

	select @rol rol, u.usr_id id_usuario_blackboard, per.per_codigo codigo_usuario, 'per' tabla_origen, replace(per.per_carnet, '-', '') cuenta, 
		per.per_nombres_apellidos nombre_completo, pla.pla_alias_carrera carrera, 
		case when @esp_codigo = '' then format(cast(per_fecha_nac as date), 'ddMMyyyy') else @esp_clave end 'clave',
		per.per_nombres nombres, per.per_apellidos apellidos, per.per_sexo sexo, cast(per_fecha_nac as date) fecha_nacimiento, 
		n.nodo_id nodeId, 'user' systemRoleIds, per.per_tipo tipo, per.per_estado estado, '_2_1' 
		/*
		CASE
			WHEN per.per_tipo = 'U' AND per.per_estado = 'E' THEN
				CONCAT('UTEC_ST', cil.cil_codcic, 'PEES-', RIGHT(cil.cil_anio, 2))
			WHEN per.per_tipo = 'U' AND per.per_estado = 'A' THEN
				CONCAT('UTEC_ST', cil.cil_codcic, 'PREG-', RIGHT(cil.cil_anio, 2))
			WHEN per.per_tipo = 'M' THEN
				CONCAT('UTEC_ST', cil.cil_codcic, 'MAE-', RIGHT(cil.cil_anio, 2))
			ELSE NULL
		END AS 'dataSourceId'
		*/ AS dataSourceId
	from ra_per_personas per 
		left join bkb.usr_usuarios u on usr_userName = @cuenta

		inner join dbo.ra_alc_alumnos_carrera alc on alc_codper = per_codigo
		inner join dbo.ra_pla_planes pla on alc_codpla = pla_codigo
		inner join ra_car_carreras on car_codigo = pla_codcar
		inner join ra_esc_escuelas on car_codesc = esc_codigo

		inner join bkb.nodo n on n.nodo_per_tipo = esc_tipo and n.nodo_per_estado = 'A'
	where replace(per.per_carnet, '-', '') = @cuenta and pla.pla_alias_carrera like '%NO PRES%'
    
		union all

	select @rol rol, u.usr_id id_usuario_blackboard, emp.emp_codigo codigo_usuario, 'emp' tabla_origen, 
		replace(emp.emp_email_institucional, '@mail.utec.edu.sv', '') cuenta, 
		emp.emp_nombres_apellidos nombre_completo, '' carrera, 
		case when @esp_codigo = '' then format(cast(emp_fecha_nac as date), 'ddMMyyyy') else @esp_clave end 'clave',
		concat(emp_primer_nom, ' ', emp_segundo_nom) nombres, concat(emp_primer_ape, ' ', emp_segundo_ape) apellidos, emp_sexo sexo, 
		cast(emp_fecha_nac as date) fecha_nacimiento, 
		'_194_1'/*n.nodo_id*/ nodeId, 'user' systemRoleIds, '' tipo, emp.emp_estado estado, '_2_1' /*'_218_1'*/ AS dataSourceId
	from pla_emp_empleado emp 
		left join bkb.usr_usuarios u on emp.emp_codigo = @codigo_usuario and usr_userName = @cuenta

		--inner join bkb.nodo n on n.nodo_per_tipo = esc_tipo and n.nodo_per_estado = 'A'
	where replace(emp.emp_email_institucional, '@mail.utec.edu.sv', '') = @cuenta

end
go
select * from bkb.mim_miembros

	-- =============================================
	-- Author:      <Ever>
	-- Create date: <2023-11-26 09:52:23.150>
	-- Description: <Devuelve los cursos de cada usuario>
	-- =============================================
	-- select * from bkb.vst_bkb_materiasEst_materiasDoc where codigo_usuario = 152982
	-- select * from bkb.vst_bkb_materiasEst_materiasDoc where codcil = 134 and codigo_origen_curso = 55193 and cuenta = '0220582024'
create OR ALTER view bkb.vst_bkb_materiasEst_materiasDoc
AS
	SELECT t.table_origen_curso, t.codigo_origen_curso, t.rol,t.id_usuario_blackboard, t.tabla_origen_usuario, t.codigo_usuario, 
		t.cuenta, t.nombres, t.apellidos, t.fecha_nacimiento, t.nombre_completo,t.carrera, t.nodeId, t.systemRoleIds, t.materia, 
		t.tipo, t.estado, t.codcil, t.hm_codigo, t.cur_id, t.cur_fecha_creacion, t.mim_idBkb, t.mim_fecha_creacion
	FROM (
		-- Materias de estudiantes pregrado y maestria
		SELECT vst.table_origen 'table_origen_curso', vst.codigo_origen 'codigo_origen_curso', 'student' AS 'rol', 
			per_id_usuario_blackboard AS 'id_usuario_blackboard', 'per' AS 'tabla_origen_usuario', per.per_codigo AS 'codigo_usuario', 
			REPLACE(per.per_carnet, '-', '') AS 'cuenta', per_nombres AS 'nombres', per_apellidos AS 'apellidos', 
			CAST(per_fecha_nac AS DATE) AS 'fecha_nacimiento', per.per_nombres_apellidos AS 'nombre_completo', pla.pla_alias_carrera AS 'carrera',  
			vst.nodeId AS 'nodeId', 'user' AS 'systemRoleIds', per.per_tipo AS 'tipo', per.per_estado AS 'estado',
			vst.codigo_curso 'materia', vst.codcil 'codcil', '' 'hm_codigo', vst.cur_id, vst.cur_fecha_creacion, mim.mim_idBkb, mim.mim_fecha_creacion
		FROM dbo.ra_per_personas per
			inner join dbo.ra_alc_alumnos_carrera alc ON alc_codper = per_codigo
			inner join dbo.ra_pla_planes pla ON alc_codpla = pla_codigo
			inner join ra_ins_inscripcion ins ON per.per_codigo = ins.ins_codper
			inner join ra_cil_ciclo cil ON ins.ins_codcil = cil.cil_codigo
			inner join ra_mai_mat_inscritas mai on mai_codins = ins_codigo
			inner join bkb.vst_bkb_curso vst on vst.codigo_origen = mai_codhpl and vst.table_origen = 'hpl'

			left join bkb.mim_miembros mim on mim.mim_courseId = vst.codigo_curso and mim.mim_userId = REPLACE(per.per_carnet, '-', '')
		WHERE ins_codcil >= 131

			union all

		select vst.table_origen, vst.codigo_origen 'codigo_origen_curso', 'FACULTY' 'rol', emp_id_usuario_blackboard 'id_usuario_blackboard', 
			'emp' 'tabla_origen', emp.emp_codigo 'codigo_usuario', REPLACE(emp.emp_email_institucional, '@mail.utec.edu.sv', '') AS 'cuenta',
			CONCAT(emp_primer_nom, ' ', emp_segundo_nom) 'nombres', CONCAT(emp_primer_ape, ' ', emp_segundo_ape) 'apellidos',
			CAST(emp_fecha_nac AS DATE) AS 'fecha_nacimiento', emp.emp_nombres_apellidos 'nombre_completo', '' 'carrera', 
			vst.nodeId 'nodeId', 'user' 'systemRoleIds', '' 'tipo', emp.emp_estado 'estado', vst.codigo_curso 'materia', 
			cil.cil_codigo 'codcil','' 'hm_codigo', vst.cur_id, vst.cur_fecha_creacion, mim.mim_idBkb, mim.mim_fecha_creacion
		from dbo.pla_emp_empleado emp
			inner join ra_hpl_horarios_planificacion hpl ON hpl.hpl_codemp = emp.emp_codigo
			inner join ra_cil_ciclo cil ON cil.cil_codigo = hpl.hpl_codcil

			inner join bkb.vst_bkb_curso vst on vst.codigo_origen = hpl_codigo and vst.table_origen = 'hpl'

			left join bkb.mim_miembros mim on mim.mim_courseId = vst.codigo_curso and mim.mim_userId = REPLACE(emp.emp_email_institucional, '@mail.utec.edu.sv', '')
				and mim_available = 'Yes'
		where hpl_codcil >= 131
		--and hpl_codemp = 2012

		----MATERIAS DE ESTUDIANTES PREESPECIALIDAD
		--UNION ALL

		--SELECT 'student' 'rol', per_id_usuario_blackboard 'id_usuario_blackboard', 'per' 'tabla_origen', per.per_codigo 'codigo_usuario', 
		--REPLACE(per.per_carnet, '-', '') 'cuenta', per.per_nombres 'nombres', per_apellidos 'apellidos', 
		--CAST(per_fecha_nac AS DATE) 'fecha_nacimiento', per.per_nombres_apellidos 'nombre_completo',mpr.mpr_nombre 'carrera',bkb.nodo.nodo_id 'nodeId', 'user' 'systemRoleIds',
		--per.per_tipo 'tipo', per.per_estado 'estado',
		--concat('P',LEFT(replace(mpr.mpr_nombre,' ',''), 3),mpr.mpr_orden,'-',hmp.hmp_descripcion,'-',LEFT(FORMAT(CONVERT(DATETIME, apr.apr_fecha_del, 120), 'MMMM'), 1), FORMAT(CONVERT(DATETIME, apr.apr_fecha_del, 120), 'yy')) 'materia' /* = codigo_curso*/
		--, cil.cil_codigo 'Cod_ciclo',pre_codigo 'hm_codigo'
		--FROM ra_per_personas per
		--INNER JOIN pg_imp_ins_especializacion imp ON imp.imp_codper = per.per_codigo
		--INNER JOIN pg_apr_aut_preespecializacion apr ON imp.imp_codapr=apr.apr_codigo
		--LEFT JOIN ra_cil_ciclo cil ON apr.apr_codcil = cil.cil_codigo
		--INNER JOIN dbo.pg_pre_preespecializacion pre ON apr.apr_codpre = pre.pre_codigo
		--INNER JOIN pg_mpr_modulo_preespecializacion mpr ON pre.pre_codigo = mpr.mpr_codpre
		--INNER JOIN dbo.pg_hmp_horario_modpre hmp ON hmp.hmp_codigo=imp.imp_codhmp
		--LEFT OUTER JOIN bkb.nodo ON bkb.nodo.nodo_per_tipo = per.per_tipo AND bkb.nodo.nodo_per_estado = per.per_estado
		--where imp.imp_codper= per.per_codigo and mpr.mpr_visible = 'S' AND per.per_estado = 'E'
		--union all
		--SELECT 'student' 'rol', per_id_usuario_blackboard 'id_usuario_blackboard', 'per' 'tabla_origen', per.per_codigo 'codigo_usuario', 
		--REPLACE(per.per_carnet, '-', '') 'cuenta', per.per_nombres 'nombres', per_apellidos 'apellidos', 
		--CAST(per_fecha_nac AS DATE) 'fecha_nacimiento', per.per_nombres_apellidos 'nombre_completo',hm.hm_nombre_mod 'carrera',bkb.nodo.nodo_id 'nodeId', 'user' 'systemRoleIds',
		--per.per_tipo 'tipo', per.per_estado 'estado',concat('P',LEFT(replace(hm.hm_nombre_mod,' ',''), 3),hm.hm_modulo,'-',hm.hm_descripcion,'-',LEFT(FORMAT(CONVERT(DATETIME, insm.insm_fecha, 120), 'MMMM'), 1), FORMAT(CONVERT(DATETIME,  insm.insm_fecha, 120), 'yy')) 'materia' /* = codigo_curso*/
		--,cil.cil_codigo 'Cod_ciclo',per.per_codigo 'hm_codigo'
		--from pg_insm_inscripcion_mod insm
		--inner join pg_hm_horarios_mod hm on insm.insm_codhm = hm.hm_codigo
		--inner join ra_per_personas per on per.per_codigo = insm.insm_codper
		--LEFT JOIN ra_cil_ciclo cil ON cil.cil_codigo = insm.insm_codcil
		--LEFT OUTER JOIN bkb.nodo ON bkb.nodo.nodo_per_tipo = per.per_tipo AND bkb.nodo.nodo_per_estado = per.per_estado
		--where insm_codper = per.per_codigo AND per.per_estado = 'E'

		--MATERIAS DE MAESTROS - se puede usar (nombre completo o cuenta(ever.castellon)) y el codigo del ciclo
			--UNION ALL

		--PARA SABER LAS MATERIAS DE PREGRADO Y MAESTRIA QUE IMPARTE CADA PROFESOR
		
		----PARA SABER MATERIAS DE PREESPECIALIDAD QUE IMPARTE CADA PROFESOR
		--SELECT 'FACULTY' 'rol', emp_id_usuario_blackboard 'id_usuario_blackboard', 'per' 'tabla_origen', emp.emp_codigo 'codigo_usuario', 
		--REPLACE(emp.emp_email_institucional, '@mail.utec.edu.sv', '') AS 'cuenta', emp.emp_primer_ape 'nombres', emp.emp_segundo_ape 'apellidos', 
		--CAST(emp_fecha_nac AS DATE) 'fecha_nacimiento', emp.emp_nombres_apellidos 'nombre_completo','' 'carrera','' 'nodeId', 'user' 'systemRoleIds',
		--'' 'tipo', emp.emp_estado 'estado',
		--concat('P',LEFT(replace(modulo.mpr_nombre,' ',''), 3),modulo.mpr_orden,'-',hmp.hmp_descripcion,'-',LEFT(FORMAT(CONVERT(DATETIME, fecha.apr_fecha_del, 120), 'MMMM'), 1), FORMAT(CONVERT(DATETIME, fecha.apr_fecha_del, 120), 'yy')) 'materia' /* = codigo_curso*/
		--, cil.cil_codigo 'Cod_ciclo',pre_codigo 'hm_codigo'
		--from dbo.pg_pre_preespecializacion pre
		--INNER JOIN dbo.pg_mpr_modulo_preespecializacion modulo ON pre.pre_codigo =  modulo.mpr_codpre
		--INNER JOIN dbo.pg_apr_aut_preespecializacion fecha ON pre.pre_codigo = fecha.apr_codpre
		--INNER JOIN dbo.ra_cil_ciclo cil ON fecha.apr_codcil = cil.cil_codigo
		--INNER JOIN dbo.pg_hmp_horario_modpre hmp ON hmp.hmp_codmpr = modulo.mpr_codigo
		--inner join pla_emp_empleado emp ON emp.emp_codigo = hmp.hmp_codcat
		--LEFT OUTER JOIN bkb.peri_periodo peri ON cil.cil_codigo = peri.peri_description
		--where /*hmp.hmp_tpm_tipo_materia = 'V' AND*/ modulo.mpr_visible = 'S' 
		--UNION ALL
		----PARA SABER MATERIAS DE PREESPECIALIDAD (Liderazgo y Teambuilding) QUE IMPARTE CADA PROFESOR
		--select distinct 'FACULTY' 'rol', emp_id_usuario_blackboard 'id_usuario_blackboard', 'emp' 'tabla_origen', emp.emp_codigo 'codigo_usuario', REPLACE(emp.emp_email_institucional, '@mail.utec.edu.sv', '') AS 'cuenta',
		--CONCAT(emp_primer_nom, ' ', emp_segundo_nom) 'nombres', CONCAT(emp_primer_ape, ' ', emp_segundo_ape) 'apellidos',
		--CAST(emp_fecha_nac AS DATE) AS 'fecha_nacimiento', emp.emp_nombres_apellidos 'nombre_completo', '' 'carrera', '' 'nodeId', 'user' 'systemRoleIds',
		--'' 'tipo', emp.emp_estado 'estado',
		--concat('P',LEFT(replace(hm.hm_nombre_mod,' ',''), 3),hm.hm_modulo,'-',hm.hm_descripcion,'-',LEFT(FORMAT(CONVERT(DATETIME, insm.insm_fecha, 120), 'MMMM'), 1), FORMAT(CONVERT(DATETIME,  insm.insm_fecha, 120), 'yy')) 'materia'
		--,cil.cil_codigo 'Cod_ciclo',hm.hm_codigo 'hm_codigo'
		--from dbo.pla_emp_empleado emp
		--inner join pg_hm_horarios_mod hm ON hm.hm_codemp = emp.emp_codigo
		--inner join pg_insm_inscripcion_mod insm ON insm.insm_codhm = hm.hm_codigo
		--inner join ra_cil_ciclo cil on cil.cil_codigo = hm.hm_codcil
	)t
GO

--per_estado           I=inactivo , G=gaduado ,E=egresado
/*A
CE=curso especializado
CI=curso internacional
D=diplomado
DU=diplomado pregrado
M=maestria
O=postgrado
OV=postgrado virtual
P
S= seminario
SM
TI
U=pregrado
*/

--PARA AGREGAR COLUMNA Y LLAVE FORANEA EN LA TABLA 'ra_tde_TipoDeEstudio'
alter table ra_tde_TipoDeEstudio add tde_nodo_id varchar(100)
alter table ra_tde_TipoDeEstudio add CONSTRAINT FK__ra_tde_Ti__tde_n__7F94929I FOREIGN KEY (tde_nodo_id) REFERENCES bkb.nodo(nodo_externalId) 
select * from ra_tde_TipoDeEstudio

/*insert into bkb.nodo(nodo_id,nodo_externalId,nodo_title,nodo_description,nodo_per_tipo,nodo_per_estado)values('_194_1','123456','Pregrado','Nodo Pregrado','U','A')
go
insert into bkb.nodo(nodo_id,nodo_externalId,nodo_title,nodo_description,nodo_per_tipo,nodo_per_estado)values('_194_1','1234567','Pregrado','Nodo Pregrado','U','E')
go
insert into bkb.nodo(nodo_id,nodo_externalId,nodo_title,nodo_description,nodo_per_tipo,nodo_per_estado)values('_195_1','1234','Maestria','Nodo Maestria','M','A')
go
insert into bkb.nodo(nodo_id,nodo_externalId,nodo_title,nodo_description,nodo_per_tipo,nodo_per_estado)values('_195_1','12345','Maestria','Nodo Maestria','M','E')
go
insert into bkb.nodo(nodo_id,nodo_externalId,nodo_title,nodo_description,nodo_per_tipo,nodo_per_estado)values('_196_1','123456','Preespecialidad','Nodo Pregrado','U','A')
go
insert into bkb.nodo(nodo_id,nodo_externalId,nodo_title,nodo_description,nodo_per_tipo,nodo_per_estado)values('_196_1','1234567','Preespecialidad','Nodo Pregrado','U','E')
go*/
select * from bkb.nodo
insert into bkb.nodo(nodo_id,nodo_externalId,nodo_title,nodo_description,nodo_per_tipo,nodo_per_estado)values('_194_1','123456','Pregrado','Nodo Pregrado','U','A')
go
insert into bkb.nodo(nodo_id,nodo_externalId,nodo_title,nodo_description,nodo_per_tipo,nodo_per_estado)values('_196_1','1234567','Preespecialidad','Nodo Preespecialidad','U','E')
go
insert into bkb.nodo(nodo_id,nodo_externalId,nodo_title,nodo_description,nodo_per_tipo,nodo_per_estado)values('_195_1','1234','Maestria','Nodo Maestria','M','A')
go
insert into bkb.nodo(nodo_id,nodo_externalId,nodo_title,nodo_description,nodo_per_tipo,nodo_per_estado)values('_195_1','12345','Maestria','Nodo Maestria','M','E')
go

select * from bkb.peri_periodo
insert into bkb.peri_periodo(peri_id,peri_externalId,peri_dataSourceId,peri_name,peri_description,peri_usr_available,peri_durationType,peri_durationStart,peri_durationEnd)
values('_213_1','Ciclo 02-2023','_193_1','Ciclo 02-2023','131',1,'DateRange','2023-07-24T00:00:00.000Z','2023-12-17T00:00:00.000Z');
insert into bkb.peri_periodo(peri_id,peri_externalId,peri_dataSourceId,peri_name,peri_description,peri_usr_available,peri_durationType,peri_durationStart,peri_durationEnd)
values('_215_1','Ciclo 01-2023','_193_1','Ciclo 01-2023','130',1,'DateRange','2023-01-19T00:00:00.000Z','2023-06-11T00:00:00.000Z');
insert into bkb.peri_periodo(peri_id,peri_externalId,peri_dataSourceId,peri_name,peri_description,peri_usr_available,peri_durationType,peri_durationStart,peri_durationEnd)
values('_216_1','Ciclo 03-2023','_193_1','Ciclo 03-2023','133',1,'DateRange','2023-06-13T00:00:00.000Z','2023-07-21T00:00:00.000Z');
go
/*
insert into  bkb.ori_origen(ori_id,ori_externalId,ori_description,ori_cil_codigo,ori_estado)values('_215_1','UTEC_ST1PREG-23','',130,0);
insert into  bkb.ori_origen(ori_id,ori_externalId,ori_description,ori_cil_codigo,ori_estado)values('_216_1','UTEC_ST1PREES-23','',130,1);
insert into  bkb.ori_origen(ori_id,ori_externalId,ori_description,ori_cil_codigo,ori_estado)values('_217_1','UTEC_ST1MAE-23','',130,0);
insert into  bkb.ori_origen(ori_id,ori_externalId,ori_description,ori_cil_codigo,ori_estado)values('_218_1','UTEC_DOC1PREG-23','',130,0);
insert into  bkb.ori_origen(ori_id,ori_externalId,ori_description,ori_cil_codigo,ori_estado)values('_219_1','UTEC_DOC1PREES-23','',130,1);
insert into  bkb.ori_origen(ori_id,ori_externalId,ori_description,ori_cil_codigo,ori_estado)values('_220_1','UTEC_DOC1MAE-23','',130,0);
*/
insert into  bkb.ori_origen(ori_id,ori_externalId,ori_description,ori_cil_codigo,ori_estado)values('_215_1','UTEC_ST2PREG-23','',131,0);
insert into  bkb.ori_origen(ori_id,ori_externalId,ori_description,ori_cil_codigo,ori_estado)values('_216_1','UTEC_ST2PREES-23','',131,1);
insert into  bkb.ori_origen(ori_id,ori_externalId,ori_description,ori_cil_codigo,ori_estado)values('_217_1','UTEC_ST2MAE-23','',131,0);
insert into  bkb.ori_origen(ori_id,ori_externalId,ori_description,ori_cil_codigo,ori_estado)values('_218_1','UTEC_DOC2PREG-23','',131,0);
insert into  bkb.ori_origen(ori_id,ori_externalId,ori_description,ori_cil_codigo,ori_estado)values('_219_1','UTEC_DOC2PREES-23','',131,1);
insert into  bkb.ori_origen(ori_id,ori_externalId,ori_description,ori_cil_codigo,ori_estado)values('_220_1','UTEC_DOC2MAE-23','',131,0);
