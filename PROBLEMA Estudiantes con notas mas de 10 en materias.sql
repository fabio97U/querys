declare @codper int = 206588, @tipo varchar(2) = 'A', @Busqueda varchar(50) = ''
select 
right('00' + cast(cil_codcic as varchar),2) + '-' + cast(cil_anio as varchar) ciclo,
p.per_carnet, a.ins_codper, b.mai_codmat, round( isnull(n.nota,0),1) nota, alc_codpla, n.mai_codpla, p.per_estado
--a.ins_codigo ins_codigo,b.mai_codigo mai_codigo, c.cil_codigo cil_codigo, 
--d.cic_nombre + '-' + cast(c.cil_anio as varchar) cic_nombre,  ltrim(rtrim(b.mai_codmat)) mai_codmat,  
--ltrim(rtrim(b.mai_codmat)) + ' ' + m.mat_nombre mat_nombre, b.mai_matricula mai_matricula, 
--round( isnull(n.nota,0),1) nota, c.cil_anio cil_anio, d.cic_codigo cic_codigo, isnull(mai_absorcion,'N') absorcion_notas, 
--b.mai_codpla codpla, pla_nombre + ' ' + cast(car_codigo as varchar) nombre_plan, b.mai_estado mai_estado 
from ra_ins_inscripcion a 
join ra_mai_mat_inscritas  b on b.mai_codins = a.ins_codigo 
inner join ra_per_personas p on p.per_codigo = a.ins_codper
join ra_cil_ciclo c on c.cil_codigo = a.ins_codcil 
join ra_cic_ciclos d on d.cic_codigo = c.cil_codcic 
join ra_alc_alumnos_carrera on alc_codper = a.ins_codper 
left outer join notas n on n.ins_codigo = a.ins_codigo and n.mai_codigo = b.mai_codigo 
join ra_mat_materias m on m.mat_codigo = b.mai_codmat 
join ra_pla_planes on pla_codigo = b.mai_codpla 
join ra_car_carreras on car_codigo = pla_codcar 
where 
n.nota > 10 and --alc_codper = @codper and
case when @tipo = 'A' then alc_codpla else b.mai_codpla end = b.mai_codpla and (d.cic_nombre + '-' + cast(c.cil_anio as varchar) 
like '%' + case when isnull(ltrim(rtrim(@Busqueda)), '') = '' then '' else ltrim(rtrim(@Busqueda)) + '%' end 
or ltrim(rtrim(b.mai_codmat)) + ' ' + m.mat_nombre like '%' + case when isnull(ltrim(rtrim(@Busqueda)), '') = '' 
then '' else ltrim(rtrim(@Busqueda)) + '%' end or  isnull(n.nota,0)  like '%' + case when isnull(ltrim(rtrim(@Busqueda)), '') = '' 
then '' else ltrim(rtrim(@Busqueda)) + '%' end or  pla_nombre + ' ' + cast(car_codigo as varchar) like '%' + 
case when isnull(ltrim(rtrim(@Busqueda)), '') = '' then '' else ltrim(rtrim(@Busqueda)) + '%' end) 

order by c.cil_anio, d.cic_codigo