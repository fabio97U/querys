--PRUEBAS INSCRIPCION INTERCICLO:
--codper, carnet	  , usuario   , pwd   
--225358, 05-2540-2020, 0525402020, 10081998--ciecias empres
--217864, 11-3128-2019, 1131282019, 15041995
--214958, 12-0492-2019, 1204922019, 28061999
--226737, 60-3850-2020, 6038502020, 10062002-- fica
--215153, 51-0639-2019, 5106392019, 02111999 --derecho
select * from ra_mat_materias where mat_codigo = 'PASV-HA'
declare @mi_hpl as tbl_hpls
insert into @mi_hpl (hpl, codmat, seccion, especial, estado, tipo_materia, codpla, uv, matricula) values
(42331, 'CDLA-E', '01', 0, 1, 'P', 318, 4, '1')

--insert into ra_validaciones_globales (rvg_codper, rvg_mensaje, rvg_carnet) values (226737, 0, '60-3850-2020')
--exec dbo.web_ins_cuposinserinscripcion_nodjs 1, 225358, 124, @mi_hpl, '181.225.132.69'--Insercion por primera vez
exec dbo.web_mod_ins_cuposinserinscripcion_nodjs 1, 225358, 124, 1192220, @mi_hpl,'192.168.114.69'--Inserccion o modificacion

select * from ra_validaciones_globales where rvg_codper = '225358'
--update ra_validaciones_globales set rvg_mensaje = 0 where rvg_codper = '217864'

declare @codins int
select @codins = ins_codigo from ra_ins_inscripcion where ins_codcil = 123 and ins_codper = 225358 
select * from ra_mai_mat_inscritas_especial where mai_codins = @codins
select * from ra_mai_mat_inscritas where mai_codins = @codins
select * from ra_ins_inscripcion where ins_codigo = @codins



web_col_art_archivo_tal 225358, 124, ''
exec web_ins_genasesoria_con_matins_nodjs 124, 225358
exec web_ins_asesoria_cl 1, 124
exec dbo.web_ptl_login_ldap
-- web_ptl_login_ldap '5150592013', 117, 93  
web_ins_genasesoria_con_matins_nodjs 190505, 120

web_ins_matinscritas_nodjs 225358, 124

-----------MODIFICADOS 
--drop type tbl_dips_ins
create type tbl_dips_ins as table(codhrm int, codfea int, estado smallint);
estado:{
 -1: "delete",
	0: "sin accion",
	1: "insertar"
}
  
select * from dip_hrm_horarios

exec web_ins_asesoria_cl 1, 124
exec dip_inscribir_alumno_diplomado
exec ra_ins_cantidad_inscritas_interciclo 225358, 124
exec rep_alm_diplomado

select * from dip_hrm_horarios
rep_alm_diplomado

create table ra_ins_bitcam_inscripcion_bitacora_cambios(
	bitcam_codigo int primary key identity (1, 1),
	bitcam_codper int,
	bitcam_codins int,
	bitcam_codhpl int,
	bitcam_estado varchar(2), --I: Inserto, E: Elimino
	bitcam_tipo_tbl_inscripcion varchar(2), --M: Materia, ME: Materia Especial
	bitcam_fecha_creacion datetime default getdate()
)

select bitcam_codigo, per_carnet, per_apellidos_nombres, hpl_codmat, mat_nombre, hpl_descripcion, bitcam_estado, 
case when hpl_lunes = 'S' then 'Lun-' ELSE '' END +   
case when hpl_martes = 'S' then 'Mar-' ELSE '' END +   
case when hpl_miercoles = 'S' then 'Mie-' ELSE '' END +   
case when hpl_jueves = 'S' then 'Jue-' ELSE '' END +   
case when hpl_viernes = 'S' then 'Vie-' ELSE '' END +   
case when hpl_sabado = 'S' then 'Sab-' ELSE '' END +   
case when hpl_domingo = 'S' then 'Dom-' ELSE '' END DIAS, aul_nombre_corto,
bitcam_tipo_tbl_inscripcion, bitcam_fecha_creacion
from ra_ins_bitcam_inscripcion_bitacora_cambios
inner join ra_per_personas on per_codigo = bitcam_codper 
inner join ra_hpl_horarios_planificacion on hpl_codigo = bitcam_codhpl
inner join ra_mat_materias on mat_codigo = hpl_codmat
inner join ra_aul_aulas on aul_codigo = hpl_codaul
where per_carnet = '05-2540-2020' and hpl_codcil = 124
order by bitcam_codigo

--Modificados 30/05/2020
web_mod_ins_cuposinserinscripcion_nodjs_azure
web_mod_ins_cuposinserinscripcion_nodjs

web_Ins_detinscripcion_nodjs_azure
web_Ins_detinscripcion_nodjs

web_ins_cuposinserinscripcion_nodjs_azure
web_ins_cuposinserinscripcion_nodjs

rep_alm_diplomado

select * from ra_alc_alumnos_carrera where alc_codper = 225358
web_ins_verificainscripcion 191915, 124--12-3276-2016, per_tipo_ingreso: 5

exec dbo.web_ins_genasesoria 124, 225358

select per_tipo_ingreso, * from ra_per_personas where per_codigo = 191915
