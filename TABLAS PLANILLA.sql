select * from pla_tpl_tipo_planilla
select * from pla_pla_planilla where pla_codcil = 125
select * from meses

select * from pla_hort_emp_trabajadas
where HorT_codcil = 125

select pla_codigo,pla_codtpl, tpl_nombre,
right('0'+cast(day(pla_inicio) as varchar),2)+'/'+right('0'+cast(month(pla_inicio) as varchar),2)+'/'+cast(year(pla_inicio)as varchar) pla_inicio,right('0'+cast(day(pla_final) as varchar),2)+'/'+right('0'+cast(month(pla_final) as varchar),2)+'/'+cast(year(pla_final)as varchar) pla_final,right('0'+cast(day( pla_fecha_pago) as varchar),2)+'/'+right('0'+cast(month( pla_fecha_pago) as varchar),2)+'/'+cast(year( pla_fecha_pago)as varchar) pla_fecha_pago,pla_anio,pla_mes,
 case when pla_estado='G' then 'Generada' 
when pla_estado='A' then  'Autorizada'
when pla_estado='R' then 'Registrada' end Estado, cast(pla_codtpl as varchar) + '*' + cast(pla_codigo as varchar) codigopla
from pla_pla_planilla 
join pla_tpl_tipo_planilla on tpl_codigo = pla_codtpl
join adm_tlr_tipo_planilla_role on tlr_codtpl = tpl_codigo  
join adm_rol_roles on rol_codigo = tlr_role 
join adm_rus_role_usuarios on rus_role = rol_codigo 
join adm_usr_usuarios on usr_codigo = rus_codusr 
where pla_codreg=1 
and pla_codcil=125 
and pla_codtpl > 14
and  pla_estado <> 'A' and pla_cierre <> 'C'
and usr_codigo = 407
order by pla_anio desc, pla_mes desc




                         select hort_codemp, hort_codigo,hort_codreg,emp_apellidos_nombres,hort_codtpl, mat_codigo, mat_nombre, hort_codpla,hort_codcil,
hort_horastrabajadas,hort_horasreales , hort_valor_hora,hort_valor_hora_practica,hort_horasreales_practica, hort_solvencia_normal, 
hort_solvencia_extraordinaria, hpl_descripcion, hort_codusr_crea, hort_fecha_crea 
from pla_hort_emp_trabajadas 
join pla_emp_empleado on emp_codigo= hort_codemp 
join ra_mat_materias on mat_codigo = hort_codmat 
join ra_hpl_horarios_planificacion on hort_codhpl = hpl_codigo 
where hort_codreg =1/*@codempreg*/  and hort_codcil =125/*@codcl*/  
and cast(hort_codtpl as varchar) + '*' + cast(hort_codpla as varchar) = '15*202101'/*@codigopla*/
--and ( emp_apellidos_nombres like'%' + case when isnull(ltrim(rtrim(@busqueda)), '') = '' then ''  else ltrim(rtrim(@busqueda)) 
--+ '%' end  )
order by emp_apellidos_nombres asc, mat_nombre