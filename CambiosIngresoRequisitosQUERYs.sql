select plm_codmat,mat_codigo,isnull(plm_alias,mat_nombre) mat_nombre, isnull(reu_uv,0) reu_uv, plm_codpla, 
isnull(reo_porcentaje,0) reo_porcentaje 
from ra_plm_planes_materias 
join ra_mat_materias on mat_codigo = plm_codmat 
left outer join ra_reu_requisitos_uv on reu_codmat = mat_codigo and reu_codpla = plm_codpla 
left outer join ra_reo_requisitos_porc on reo_codmat = mat_codigo and reo_codpla = plm_codpla 
where plm_codpla = 326 and (
plm_codmat like '%' + case when isnull(ltrim(rtrim(' ')), '') = '' 
then ''  else ltrim(rtrim(' ')) + '%' end or mat_nombre like '%' + case when isnull(ltrim(rtrim(' ')), '') = '' 
then '' else ltrim(rtrim(' ')) + '%' end
) order by plm_anio_carrera, plm_ciclo

select  * from ra_reo_requisitos_porc where reo_codpla = 217

delete from ra_reu_requisitos_uv where reu_codpla = @plm_codpla and reu_codmat = @plm_codmat  
if @reu_uv > 0 
	insert into ra_reu_requisitos_uv values(@plm_codpla, @plm_codmat, @reu_uv)
delete from ra_reo_requisitos_porc where reo_codpla = @plm_codpla and reo_codmat = @plm_codmat  
if @reo_porcentaje > 0 
insert into ra_reo_requisitos_porc values(@plm_codpla, @plm_codmat, @reo_porcentaje)