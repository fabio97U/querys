--use BD_RRHH
--go

--create schema contrato
--go

--select * from uonline.dbo.pla_emp_empleado where emp_nombres_apellidos like '%osiri%'
-- drop table contrato.datcon_datos_contratista
create table contrato.datcon_datos_contratista (
	datcon_codigo int primary key identity (1, 1) not null,
	datcon_codemp int not null,
	datcon_profesion varchar(50),
	datcon_domicilio varchar(50),
	datcon_departamento varchar(50),
	datcon_documento_identidad varchar(50),
	datcon_documento_identidad_texto varchar(150),

	datcon_activo bit default 1 not null,-- solo puede haber uno activo
	datcon_fecha_creacion datetime default getdate()
)
-- select * from contrato.datcon_datos_contratista
insert into contrato.datcon_datos_contratista 
(datcon_codemp, datcon_profesion, datcon_domicilio, datcon_departamento, datcon_documento_identidad, datcon_documento_identidad_texto, datcon_activo)
values (3436, 'abogado', 'Apopa', 'San Salvador', '04165444-4', 'cero cuatro uno seis cinco cuatro cuatro cuatro – cuatro', 1)

-- tabla para almacenar los detalles del contrato