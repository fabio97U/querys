--http://consultas.utec.edu.sv/prueba_vocacional/

--http://consultas.utec.edu.sv/maestrias/prueba_vocacional/
--*cambiar el formulario de ingreso 
----maestrias

--*quitar escala 6

--*solo con darle clic a evitar quitar escala 

--*colocar en dahsboard de resultados filtros por maetrias y pregrado 

drop table prb_tipa_tipos_evaluaciones
create table prb_tipa_tipos_evaluaciones(
	tipa_codigo int primary key identity(1, 1),
	tipa_nombre varchar(125),
	tipa_fecha_creacion datetime default getdate()
)
--insert into prb_tipa_tipos_evaluaciones (tipa_nombre) values ('Prueba vocacional de pregrado'), ('Prueba vocacional de maestrias')
select * from prb_tipa_tipos_evaluaciones
select * from prb_adat_dat_alumno
-- Este campo almacenara los valores 1: TourUTEC, 2: Otro, 3: PruebaEscala6
alter table prb_adat_dat_alumno add adat_codtipa int default 1 foreign key references prb_tipa_tipos_evaluaciones

alter table prb_adat_dat_alumno add adat_nacionalidad varchar(50)
alter table prb_adat_dat_alumno add adat_departamento varchar(50)
alter table prb_adat_dat_alumno add adat_programa_academico varchar(100)
alter table prb_adat_dat_alumno add adat_titulo_pregrado varchar(50)
alter table prb_adat_dat_alumno add adat_institucion_titulo_pregrado varchar(100)
alter table prb_adat_dat_alumno add adat_anio_graduacion smallint
alter table prb_adat_dat_alumno add adat_estudios_postgrado varchar(255)
alter table prb_adat_dat_alumno add adat_nombre_empresa_labora varchar(50)
alter table prb_adat_dat_alumno add adat_cargo_desempenia varchar(100)

--update prb_adat_dat_alumno set adat_codtipa = 1
select * from prb_adat_dat_alumno where adat_IdAlumno >= 68340
select * from prb_usu_usuarios


sp_pv_inserta_datos_alumnos

rpe_prueba_vocacional_general