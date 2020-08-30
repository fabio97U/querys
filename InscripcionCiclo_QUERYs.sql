declare @rvg_mensaje varchar(10) = '4'
declare @codper int = 226737, @codcil int = 123
select * from col_mov_movimientos where mov_codper = @codper and mov_codcil = @codcil
select * from ra_ins_inscripcion inner join ra_mai_mat_inscritas on mai_codins = ins_codigo 
where ins_codper = @codper and ins_codcil = @codcil
select * from ra_ins_bitcam_inscripcion_bitacora_cambios
inner join ra_ins_inscripcion on ins_codigo = bitcam_codins
where bitcam_codper = @codper and ins_codcil = @codcil
--select * from ra_validaciones_globales where rvg_codper = @codper

--select @rvg_mensaje = rvg_mensaje from ra_validaciones_globales where rvg_codper = @codper
--if not exists (select 1 from ra_ins_inscripcion where ins_codper = @codper and ins_codcil = @codcil)
--	select @rvg_mensaje prob 
--else
--	select '1' prob

select * from ra_per_personas where per_codigo in (227555)
select * from ra_validaciones_globales 
inner join ra_per_personas on per_codigo = rvg_codper 
where SUBSTRING(per_carnet, 1, 2) = '29' and per_estado = 'A'
SELECT * FROM Tbl_Alumnos_Aptos_Inscribir where codper = 227555

exec web_ins_alumnos_listos_inscribir 1, 0, 123, 122    --    Almacenar los alumnos que pagaron todas las cuotas del ciclo anterior

select * from ins_errins_errores_inscrpcion where errins_codcil = 124

select * from ra_cola_espera




select case 
when per_tipo = 'U' then 'Alumno' 
when per_tipo = 'M' then 'Maestria' 
else per_tipo end as tipo, per_nombres_apellidos as nombres, 
per_carnet,per_codigo as codigo, per_estado, pla_alias_carrera, pla_codigo, fac_nombre
from ra_per_personas 
inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
inner join ra_pla_planes on pla_codigo = alc_codpla
inner join ra_car_carreras on car_codigo = pla_codcar
--inner join ra_esc_escuelas on esc_codigo = car_codesc
inner join ra_fac_facultades on fac_codigo = car_codfac
where per_codigo = 225358 and per_estado = 'A'

select * from ra_fac_facultades
select * from ra_validaciones_globales where rvg_carnet like '51%'
insert into ra_validaciones_globales (rvg_codper, rvg_mensaje, rvg_carnet)
values (160888, '0', '2902342013')
--PRUEBAS INSCRIPCION CICLO:
--codper, carnet	  , usuario   , pwd   
--225358, 05-2540-2020, 0525402020, 10081998--ciencias empres
--217864, 11-3128-2019, 1131282019, 15041995--ciencias empres
--214958, 12-0492-2019, 1204922019, 28061999--ciencias empres
--226737, 60-3850-2020, 6038502020, 10062002-- fica
--215153, 51-0639-2019, 5106392019, 02111999 --derecho
--160888, 29-0234-2013, 2902342013, 27071994 --virtual

declare @codins int
select @codins = ins_codigo from ra_ins_inscripcion where ins_codcil = 123 and ins_codper = 225358 
select * from ra_mai_mat_inscritas_especial where mai_codins = @codins
select * from ra_mai_mat_inscritas where mai_codins = @codins
select * from ra_ins_inscripcion where ins_codigo = @codins


-- web_ptl_login_ldap '0525402020', 124, 93
-- web_ptl_login_ldap '5150592013', 117, 93

--CORREGIR APELLIDOS DE:
select distinct substring(per_apellidos, 1, 1) from ra_ins_inscripcion 
inner join ra_per_personas on per_codigo = ins_codper
where --ins_codcil in (select cil_codigo from ra_cil_ciclo where cil_anio between 2014 and 2020)
--and 
--substring(per_apellidos, 1, 1) in (' ') 
--and 
per_estado = 'A' and per_tipo = 'U'
order by 1

select * from ins_errins_errores_inscrpcion order by errins_codigo desc

--SPs node_azure:
--05/07/2020
--web_ins_genasesoria_con_matins_nodjs		--hoja_inscripcion
--web_ins_cuposinserinscripcion_nodjs		--inscribir matererias
--web_mod_ins_cuposinserinscripcion_nodjs	--modificar materias
--web_ins_matinscritas_nodjs				--comprobante de materias

SELECt * from ins_errins_errores_inscrpcion where errins_codcil = 123
select * from Inscripcion.dbo.ra_ins_inscripcion where ins_codcil = 123 --and ins_codigo >=1217561
and ins_codper = 160888
select * from Inscripcion.dbo.ra_mai_mat_inscritas where mai_codins = 1217580
--select * from Inscripcion.dbo.ra_mai_mat_inscritas

select * from dbo.ra_ins_inscripcion where ins_codcil = 123

select * from ra_ins_bitcam_inscripcion_bitacora_cambios 
inner join ra_ins_inscripcion on ins_codigo = bitcam_codins
where ins_codcil = 123

--exec web_ins_matinscritas_data_nodjs 225358, 123 
exec web_ins_matinscritas_data_nodjs_azure 160888, 123 

--exec dbo.web_ins_genasesoria_con_matins_nodjs 123, 160888
exec dbo.web_ins_genasesoria_con_matins_nodjs_azure 123, 160888

exec dbo.web_ins_matinscritas_nodjs 225358, 123
exec dbo.web_ins_matinscritas_nodjs_azure 225358, 123

select * from ins_errins_errores_inscrpcion where errins_mensaje_error like '%web_ins_matinscritas_data_nodjs%'

select * from ra_validaciones_globales

select * from ins_errins_errores_inscrpcion

exec dbo.web_ins_genasesoria 123, 158985