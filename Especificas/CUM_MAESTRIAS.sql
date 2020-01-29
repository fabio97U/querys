--select * from ra_per_personas where per_codigo = 202330
declare @Busqueda varchar = '%%'
declare @codpla int = 238 --217
declare @codper int = 202330 --181324
declare @total_um real
declare @total_uv real
--select dbo.cum(202330)
-- union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S'

--MATERIAS DE LA CARRERA
/*SELECT plm_codpla, plm_codmat, isnull(plm_alias,mat_nombre) mat_nombre,   plm_uv,  
case when plm_horas_semanales= 0 then null else plm_horas_semanales end plm_horas_semanales,  
case when plm_horas_practicas = 0 then null else plm_horas_practicas end plm_horas_practicas,  plm_ciclo,   plm_anio_carrera,   
case when plm_num_mat = 0 then null else plm_num_mat end plm_num_mat ,   isnull(plm_electiva, 'N') plm_electiva  
FROM ra_plm_planes_materias, ra_mat_materias  
where mat_codigo = plm_codmat and plm_codpla = @codpla  --and plm_horas_semanales > 0
 order by plm_num_mat*/
 --SELECT * FROm pla_emp_empleado where emp_codigo = 3654
 --MATERIAS INSCRITAS DEL ALUMNO
 select mai.mai_codmat, n.nota, mai.mai_uv, (mai.mai_uv*n.nota) 'UM'  from ra_mai_mat_inscritas as mai, notas as n
 where mai.mai_codmat = n.mai_codmat and n.ins_codper = @codper and
 mai.mai_codins in( select ins_codigo from ra_ins_inscripcion where ins_codper = @codper and ins_codcil not in(select cil_codigo from ra_cil_ciclo where cil_vigente_mae = 'S')) and mai.mai_estado <>'R' 
 
  union 

 select 'Total', '', sum(mai.mai_uv),  sum((mai.mai_uv*n.nota)) 'UM' from ra_mai_mat_inscritas as mai, notas as n
 where mai.mai_codmat = n.mai_codmat and n.ins_codper = @codper and
 mai.mai_codins in( select ins_codigo from ra_ins_inscripcion where ins_codper = @codper and ins_codcil not in(select cil_codigo from ra_cil_ciclo where cil_vigente_mae = 'S')) and mai.mai_estado <>'R' 

 select  @total_uv = sum(mai.mai_uv), @total_um = sum((mai.mai_uv*n.nota))from ra_mai_mat_inscritas as mai, notas as n
 where mai.mai_codmat = n.mai_codmat and n.ins_codper = @codper and
 mai.mai_codins in( select ins_codigo from ra_ins_inscripcion where ins_codper = @codper and ins_codcil not in(select cil_codigo from ra_cil_ciclo where cil_vigente_mae = 'S')) and mai.mai_estado <>'R' 

 select @total_um/@total_uv 'CUM 1'

 
 select AVG(n.nota) 'CUM 2'  from ra_mai_mat_inscritas as mai, notas as n
 where mai.mai_codmat = n.mai_codmat and n.ins_codper = @codper and
 mai.mai_codins in( select ins_codigo from ra_ins_inscripcion where ins_codper = @codper and ins_codcil not in(select cil_codigo from ra_cil_ciclo where cil_vigente_mae = 'S')) and mai.mai_estado <>'R' 
 --NOTAS DE CADA MATERIA.
 --select * from notas where ins_codper = @codper

 

 --select * from ra_cil_ciclo