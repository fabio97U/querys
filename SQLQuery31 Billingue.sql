update ra_mat_materias set mat_nombre = UPPER(mat_nombre) where mat_codigo in (
select mat_codigo from ra_mat_materias
where mat_fechahora >= '2020-07-07 15:50:27.130')

select mat_codigo, mat_nombre,mat_codigo from ra_mat_materias
where mat_fechahora >= '2020-07-07 15:50:27.130'

--select * from codmat_BORRAME
--create table codmat_BORRAME (codmat_bili varchar(50), mat_nombre varchar(125), codmat_orginal varchar(50))

--Insert de FormaPlan.aspx
--insert into ra_plm_planes_materias(plm_codpla, plm_codmat,
--plm_uv,plm_horas_semanales,plm_horas_practicas,plm_ciclo, plm_anio_carrera, plm_num_mat,plm_laboratorio, plm_alias,plm_electiva, plm_bloque_electiva)
--values (@plm_codpla, @plm_codmat,
--@plm_uv,@plm_horas_semanales,@plm_horas_practicas,@plm_ciclo, @plm_anio_carrera, @plm_num_mat,'N', @plm_alias,@plm_electiva, @plm_bloque_electiva)

--set @fecha = getdate()
--select @registro = @plm_codmat + '/' + isnull(@plm_alias,'') + '/' + cast(@plm_codpla as varchar)

--exec auditoria_del_sistema 'ra_plm_planes_materias','I',@usuario,@fecha,@registro

select top 11 * from ra_plm_planes_materias
order by plm_fechahora desc

-- 206588, 177886 , 175639
-- 10, 18, 67
select * from ra_car_carreras where car_codigo in (106, 18, 67)
select * from ra_pla_planes where pla_codigo in (319, 320, 381)
select * from ra_alc_alumnos_carrera 
inner join ra_per_personas on per_codigo = alc_codper
where alc_codpla  in (319, 320, 381)

--Insert prerrequisitos
--ReqInsercion
--alter table ra_req_requisitos add req_fecha_hora_creacion datetime default getdate()
select * from ra_req_requisitos
where req_codmat like '%-B%'
order by req_fecha_hora_creacion
-- 10-0848-2018, 18-6218-2014, 67-5407-2014
-- 206588, 177886 , 175639
-- 10, 18, 67
-- 319, 320, 381
exec dbo.web_ptl_pensum 175639

select * from notas where ins_codper = 113426 and mai_codpla = 320
order by mai_codmat

select * from codmat_BORRAME
exec dbo.web_ins_genasesoria_con_matins_nodjs 123, 113426

delete from ra_plm_planes_materias where plm_codmat = 'ARHU-E' and plm_codpla = 320 
--and not exists (select 1 from ra_dma_det_matau where dma_codpla = plm_codpla and dma_codmat = plm_codmat) 
and not exists (select 1 from ra_req_requisitos where req_codmat = plm_codmat and req_codpla = plm_codpla) 
--and not exists (select 1 from ra_reu_requisitos_uv where reu_codpla = plm_codpla and reu_codmat = plm_codmat) 
--and not exists (select 1 from ra_reo_requisitos_porc where reo_codpla = plm_codpla and reo_codmat = plm_codmat)  

--set @fecha = getdate() select @registro = @plm_codmat + '/' + cast(@plm_codpla as varchar)  
--exec auditoria_del_sistema 'ra_plm_planes_materias','D',@usuario,@fecha,@registro

SELECT * from ra_req_requisitos where req_codmat IN('PLAE-E') and req_codpla IN (319, 320, 381)