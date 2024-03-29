USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_record_academico_limpio]    Script Date: 6/12/2019 10:51:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- rep_record_academico_limpio 1,'12-6436-2011','N'
-- rep_record_academico_limpio 1,'25-1565-2015','N'

-- rep_record_academico_limpio 1,'25-4018-2018','N'
-- web_ptl_pensum 209966
ALTER proc [dbo].[rep_record_academico_limpio]
       @campo0 int,  
       @campo1 varchar(12),  
       @campo2 varchar(1)
as
begin  
       declare @nota_minima real, @codigo_persona int, @materias int, @aprobadas int, @reprobadas int,   
       @equivalencias int, @ciclo_vigente int, @estado_persona varchar(20),  
       @tipo_ingreso int, @apellidos_nombres varchar(100), @tipo varchar(1),  
       @codpla_act int,@cum_repro real, @cum real  
  
       --create table #record
       declare @record table
       (  
             cil_codcic int,  
             cil_codigo varchar(80),  
             uni_nombre varchar(250),  
             per_carnet varchar(12),  
             per_nombres_apellidos varchar(200),  
             car_nombre varchar(250),
             pla_alias_carrera varchar(150),  
             fac_nombre varchar(100),  
             pla_nombre varchar(100),  
             reg_nombre varchar(80),  
             cic_nombre varchar(50),  
             cil_anio int,  
             mat_codigo varchar(10),  
             mat_nombre varchar(200),  
             nota real,  
             nota_letras varchar(100),  
             estado varchar(20),  
             cum_parcil real,  
             cum real,  
             materias int,  
             aprobadas int,  
             reprobadas int,  
             matricula int,  
             equivalencias int,  
             ing_nombre varchar(50),  
             estado_a varchar(20),  
             plm_anio_carrera int,   
             plm_ciclo int,   
             absorcion varchar(2),  
             uv int,
             um float  
       )  
       --create table #ra_mai_mat_inscritas_h_v
       declare @ra_mai_mat_inscritas_h_v table
       (  
             codper int,  
             codcil int,  
             mai_codigo int,  
             mai_codins int,  
             mai_codmat varchar(10) collate Modern_Spanish_CI_AS,  
             mai_absorcion varchar(1),  
             mai_financiada varchar(1),  
             mai_estado varchar(1),  
             mai_codhor int,  
             mai_matricula int,  
             mai_acuerdo varchar(20),  
             mai_fecha_acuerdo datetime,  
             mai_codmat_del varchar(10) collate Modern_Spanish_CI_AS,  
             fechacreacion datetime,   
             mai_codpla int,  
             mai_uv int,  
             mai_tipo varchar(1),  
             mai_codhpl int  
       )   
       --create table #notas
       declare @notas table
       (  
             ins_codreg int,  
             ins_codigo int,  
             ins_codcil int,  
             ins_codper int,  
             mai_codigo int,  
             mai_codmat varchar(10) collate Modern_Spanish_CI_AS,  
             mai_codhor int,  
             mai_matricula int,  
             estado varchar(1),  
             mai_codpla int,  
             absorcion_notas varchar(1),  
             uv int,  
             nota float, mai_codhpl int  
       )   

       select @nota_minima = uni_nota_minima  
       from ra_reg_regionales, ra_uni_universidad  
       where reg_codigo = @campo0  
       and uni_codigo = reg_coduni

       select @codigo_persona = per_codigo,  
       @estado_persona = estp_descripcion,  
       @tipo_ingreso = per_tipo_ingreso,  
       @apellidos_nombres = per_apellidos_nombres ,  
       @tipo = per_tipo  
       from ra_per_personas 
       inner join  ra_estp_estado_persona on per_estado = estp_estado
       where per_carnet = @campo1  
       
       declare @ins table (codins int)
       insert into @ins (codins)
       select max(ins_codigo) codins  
       --into #ins  
       from ra_ins_inscripcion  
       join ra_cil_ciclo on cil_codigo = ins_codcil  
       where --cil_vigente = 'S'  
       --and 
       ins_codper = @codigo_persona  

       select @codpla_act = alc_codpla  
       from ra_alc_alumnos_carrera   
       where alc_codper = @codigo_persona  

       if @tipo = 'U'
       begin
             --insert into #ra_mai_mat_inscritas_h_v  
             insert into @ra_mai_mat_inscritas_h_v  
             select *  
             from ra_mai_mat_inscritas_h_v  
             where codper = @codigo_persona  
             and mai_codpla = @codpla_act  
             and codcil not in --(@ciclo_vigente) --, 114) --CAMBIO DE RENY
             (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
       end
       else
       begin
             --insert into #ra_mai_mat_inscritas_h_v  
             insert into @ra_mai_mat_inscritas_h_v  
             select *  
             from ra_mai_mat_inscritas_h_v  
             where codper = @codigo_persona  
             and mai_codpla = @codpla_act  
       end
----
       --insert into #notas  
       insert into @notas
       select * from notas  
       where ins_codper = @codigo_persona  
       and mai_codpla = @codpla_act
       select @materias = count(1)   
       from ra_alc_alumnos_carrera, ra_plm_planes_materias  
       where alc_codper = @codigo_persona  
       and plm_codpla = alc_codpla  

       select @aprobadas = sum(a)   
       from   
       (
             select count(1) a   
             from @notas b,ra_alc_alumnos_carrera, ra_plm_planes_materias  
             where b.ins_codper = @codigo_persona  
             and round(b.nota,1) >= @nota_minima  
             and alc_codper = b.ins_codper  
             and plm_codpla = alc_codpla  
             and plm_codmat = b.mai_codmat
             and b.ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
             union all  
             select count(distinct eqn_codmat)   
             from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,  
             ra_alc_alumnos_carrera, ra_plm_planes_materias  
             where equ_codigo = eqn_codequ  
             and equ_codper = @codigo_persona 
             --and eqn_nota > 0
             and eqn_nota >= @nota_minima  ---------01/2019 
             and alc_codper = equ_codper  
             and plm_codpla = alc_codpla  
             and plm_codmat = eqn_codmat  
       ) t   

       select @reprobadas = sum(a)
       from(
       select count(1) a 
       from @notas b,ra_alc_alumnos_carrera, ra_plm_planes_materias  
       where b.ins_codper = @codigo_persona  
       and b.ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
       and b.estado = 'I'  
       and round(b.nota,1) < @nota_minima  
       and alc_codper = b.ins_codper  
       and plm_codpla = alc_codpla  
       and plm_codmat = b.mai_codmat 
       union all  
       select count(distinct eqn_codmat)   
       from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,  
       ra_alc_alumnos_carrera, ra_plm_planes_materias  
       where equ_codigo = eqn_codequ  
       and equ_codper = @codigo_persona 
       and eqn_nota > 0 
       and eqn_nota < @nota_minima
       and alc_codper = equ_codper  
       and plm_codpla = alc_codpla  
       and plm_codmat = eqn_codmat 
       )t
       

       if @campo2 = 'S' set @reprobadas = 0

       select @equivalencias = count(distinct eqn_codmat)   
       from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,   
       ra_alc_alumnos_carrera, ra_plm_planes_materias  
       where equ_codigo = eqn_codequ  
       and equ_codper = @codigo_persona  
       and eqn_nota > 0   
       and equ_tipo = 'E'  
       and alc_codper = equ_codper  
       and plm_codpla = alc_codpla  
       and plm_codmat = eqn_codmat  


       -------------------------------------
       declare @tot_uv real
       declare @uv_total table(codmat nvarchar(50), uv int, nota real)
       insert into @uv_total
       select a,b,max(c)
       from 
       (
             select plm_codmat as a, plm_uv as b, nota as c
             from @notas b,ra_alc_alumnos_carrera, ra_plm_planes_materias
             where b.ins_codper = @codigo_persona
             and round(b.nota,1) >= @nota_minima
             and alc_codper = b.ins_codper
             and plm_codpla = alc_codpla
             and plm_codmat = b.mai_codmat
             union all
             select eqn_codmat, plm_uv, eqn_nota
             from 
             (
                    select distinct eqn_codmat, plm_uv, eqn_nota
                    from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,
                    ra_alc_alumnos_carrera, ra_plm_planes_materias
                    where equ_codigo = eqn_codequ
                    and equ_codper = @codigo_persona
                    and eqn_nota > 0
                    and alc_codper = equ_codper
                    and plm_codpla = alc_codpla
                    and plm_codmat = eqn_codmat
             )z
       ) t 
       group by a,b

       select @tot_uv = sum(uv) from @uv_total

             -------------------------------------

       ---    select @cum_repro = round(dbo.cum_repro(@codigo_persona),1)  
       select @cum_repro = dbo.nota_aproximacion(dbo.cum_repro(@codigo_persona))

       ---    select @cum = round(dbo.cum(@codigo_persona),1)
       select @cum = round(dbo.nota_aproximacion(dbo.cum(@codigo_persona)),1)
   
       if @campo2 = 'N'  
       begin  
             insert into @record  (cil_codcic, cil_codigo ,uni_nombre ,per_carnet ,per_nombres_apellidos ,car_nombre ,pla_alias_carrera ,fac_nombre ,pla_nombre ,reg_nombre ,cic_nombre ,cil_anio ,mat_codigo ,mat_nombre ,nota ,nota_letras ,estado ,cum_parcil ,cum ,materias ,aprobadas ,reprobadas ,matricula ,equivalencias ,ing_nombre ,estado_a ,plm_anio_carrera ,plm_ciclo ,absorcion ,uv ) 
             select cil_codcic, cast(cil_anio as varchar) + cic_nombre cil_codigo,  
             uni_nombre, per_carnet, per_nombres_apellidos,   
             car_nombre,x.pla_alias_carrera, fac_nombre, pla_nombre,reg_nombre,   
             cic_nombre, cil_anio,  
             mat_codigo, mat_nombre,   
             round(nota,1) nota,   
             upper(dbo.NotaALetras(round(nota,1))),  
             estado estado, round(cum_ciclo,1) cum_parcial,   
             @cum_repro cum,  
             @materias,  
             @aprobadas,  
             @reprobadas,   
             matricula,  
             @equivalencias,   
             ing_nombre,   
             estado_a, plm_anio_carrera, plm_ciclo, absorcion, uv  
             from  
             (  
                    select cil_codcic,cil_codigo codcil,uni_nombre, codper,per_carnet,   
                    per_nombres_apellidos,   
                    car_nombre,pla_alias_carrera, fac_nombre,pla_codigo,pla_nombre,  
                    reg_nombre,   
                    cic_nombre, cil_anio,   
                    mat_codigo, mat_nombre, isnull(nota,0) nota,      
                    estado =          
                       case 
                            when (mai_estado)= 'R' THEN 'Retirada'
                           when isnull(round(nota,1),0) <  @nota_minima THEN 'Reprobada' 
                            else 'Aprobada'
                       end,

                    dbo.cum_ciclo(cil_codigo,codper) cum_ciclo,0 cum,  
                    matricula,ing_nombre, estado_a, plm_anio_carrera, plm_ciclo, absorcion, uv  
                    from  
                    (  
                           select cil_codcic,cil_codigo,uni_nombre, codper codper, @campo1 per_carnet,   
                           @apellidos_nombres per_nombres_apellidos,   
                           car_nombre,pla_alias_carrera, reg_nombre, mat_codigo,  
                           isnull(plm_alias,mat_nombre) +  
                           case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre,   
                           cic_nombre, cil_anio, mai_estado,mai_codins codins,  
                           @campo0 codreg, mai_matricula matricula, fac_nombre, pla_codigo,pla_nombre, ing_nombre,  
                           @estado_persona estado_a, plm_anio_carrera, plm_ciclo,   
                           mai_absorcion absorcion, mai_codmat_del  
                           from @ra_mai_mat_inscritas_h_v, ra_mat_materias,   
                           ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras,ra_fac_facultades,  
                           ra_cil_ciclo, ra_cic_ciclos, ra_ing_ingreso, ra_plm_planes_materias,  
                           ra_uni_universidad, ra_reg_regionales  
                           where codper = @codigo_persona  
                           and alc_codper = codper  
                           and pla_codigo = alc_codpla  
                           and car_codigo = pla_codcar  
                           and fac_codigo = car_codfac  
                           and cil_codigo = codcil  
                           and cic_codigo = cil_codcic  
                           and mat_codigo = mai_codmat  
                           and ing_codigo = @tipo_ingreso  
                           and plm_codpla = pla_codigo  
                           and plm_codmat = mai_codmat  
                           and not exists (select 1 from ra_cca_cambio_carrera 
                                                      where cca_codper = @codigo_persona 
                                                      and cca_codmat_eqn is not null 
                                                      and cca_codmat_eqn <> '0'
                                                      and mai_codmat_del = cca_codmat)   
                           and reg_codigo = cil_codreg  
                           and uni_codigo = reg_coduni  
                           and substring(@tipo,1,1) in('U','M')  
                    )j left outer join @notas on ins_codper = codper  
                    and mai_codmat = mai_codmat_del  
                    and ins_codcil = cil_codigo  
                    union all  
                    select 0,0,  
                    uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera,   
                    fac_nombre,pla_codigo,pla_nombre,  
                    reg_nombre,uni,car,eqn_codmat, mat_nombre, eqn_nota,   
                    case when eqn_nota >= @nota_minima then 'Aprobada' else 'Reprobada' end estado,  
                    0, 0,1,ing_nombre,  
                    estado, plm_anio_carrera, plm_ciclo,'',plm_uv  
                    from  
                    (  
                           select distinct uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera,   
                           reg_nombre,'Eq. Externa ' uni, '' car,   
                           eqn_codmat, isnull(plm_alias,mat_nombre) +  
                           case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre,   
                           (select avg(a.eqn_nota)   
                           from ra_eqn_equivalencia_notas a, ra_equ_equivalencia_universidad b  
                           where a.eqn_codmat = mat_codigo   
                           and a.eqn_codequ = b.equ_codigo  
                           and a.eqn_codmat is not null   
                           and a.eqn_nota > 0  
                           and b.equ_codper = per_codigo) eqn_nota, fac_nombre, pla_codigo,pla_nombre,  
                           ing_nombre,  estp_descripcion estado, plm_anio_carrera, plm_ciclo,  
                           plm_uv  
                           from ra_per_personas,ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,  
                           ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras, ra_reg_regionales, ra_uni_universidad,  
                           ra_mat_materias, ra_fac_facultades, ra_ing_ingreso, ra_plm_planes_materias,ra_estp_estado_persona  
                           where per_codigo = @codigo_persona  
                           and equ_codper = per_codigo  
                           and eqn_codequ = equ_codigo  
       --                  and equ_tipo = 'E'  
                           and alc_codper = per_codigo  
                           and pla_codigo = alc_codpla  
                           and car_codigo = pla_codcar  
                           and fac_codigo = car_codfac  
                           and mat_codigo = eqn_codmat  
                           and reg_codigo = per_codreg  
                           and uni_codigo = reg_coduni  
                           and eqn_nota > 0  
                           and ing_codigo = per_tipo_ingreso  
                           and plm_codpla = pla_codigo  
                           and plm_codmat = mat_codigo  
                           and equ_codist <> 711
                           and per_estado = estp_estado
                    ) t  
                    union all  
                    select 0,0,  
                    uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera,   
                    fac_nombre,pla_codigo,pla_nombre,  
                    reg_nombre,uni,car,eqn_codmat, mat_nombre, eqn_nota,   
                    case when eqn_nota >= @nota_minima then 'Aprobada' else 'Reprobada' end estado, 
                    0, 0,1,ing_nombre,  
                    estado, plm_anio_carrera, plm_ciclo,'', plm_uv  
                    from  
                    (  
                           select distinct uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera,   
                           reg_nombre,'Eq. Interna ' uni, '1' car,   
                           eqn_codmat, isnull(plm_alias,mat_nombre) +  
                           case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre,   
                           (select avg(a.eqn_nota)   
                           from ra_eqn_equivalencia_notas a, ra_equ_equivalencia_universidad b  
                           where a.eqn_codmat = mat_codigo   
                           and a.eqn_codequ = b.equ_codigo  
                           and a.eqn_codmat is not null  
                           and a.eqn_nota > 0  
                           and b.equ_codper = per_codigo) eqn_nota, equ_codigo codequ, fac_nombre, pla_codigo,pla_nombre,  
                           ing_nombre,estp_descripcion estado, plm_anio_carrera, plm_ciclo,  
                           plm_uv  
                           from ra_per_personas,ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,  
                           ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras, ra_reg_regionales, ra_uni_universidad,  
                           ra_mat_materias, ra_fac_facultades, ra_ing_ingreso, ra_plm_planes_materias,ra_estp_estado_persona
       
                           where per_codigo = @codigo_persona  
                           and equ_codper = per_codigo  
                           and eqn_codequ = equ_codigo  
       --                  and equ_tipo = 'I'  
                           and alc_codper = per_codigo  
                           and pla_codigo = alc_codpla  
                           and car_codigo = pla_codcar  
                           and fac_codigo = car_codfac  
                           and mat_codigo = eqn_codmat  
                           and reg_codigo = per_codreg  
                           and uni_codigo = reg_coduni  
                           and eqn_nota > 0  
                           and ing_codigo = per_tipo_ingreso  
                           and plm_codpla = pla_codigo  
                           and plm_codmat = mat_codigo 
                           and equ_codist = 711 
                           and per_estado = estp_estado
                    ) t  
                    union all  
                    select distinct 1,0,  
                    uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,b.pla_alias_carrera, fac_nombre,  
                    alc_codpla pla_codigo,b.pla_nombre pla_nombre,  
                    reg_nombre,'Eq. Interna ', '1',   
                    cca_codmat, isnull(plm_alias,mat_nombre) +  
                    case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre, /*cast(*/nota/* as varchar)*/,   
                    'Aprobada' estado,0 , 0, 1,  
                    ing_nombre,  estp_descripcion estado, plm_anio_carrera, plm_ciclo,'',plm_uv  
                    from ra_per_personas,ra_cca_cambio_carrera,ra_alc_alumnos_carrera,ra_pla_planes b,  
                    ra_pla_planes a, ra_car_carreras, ra_fac_facultades,  
                    ra_reg_regionales, ra_uni_universidad,  
                    ra_mat_materias, @notas,ra_ing_ingreso, ra_plm_planes_materias, ra_estp_estado_persona
                    where per_codigo = @codigo_persona  
                    and cca_codper = per_codigo  
                    and a.pla_codigo = cca_codpla_eqn  
                    and car_codigo = a.pla_codcar  
                    and fac_codigo = car_codfac  
                    and mat_codigo = cca_codmat_eqn  
                    and reg_codigo = per_codreg  
                    and uni_codigo = reg_coduni  
                    and ins_codper = cca_codper  
                    and mai_codmat = cca_codmat  
                    and cca_codmat_eqn is not null and cca_codmat_eqn <> '0'  
                    and ing_codigo = per_tipo_ingreso  
                    and plm_codpla = a.pla_codigo  
                    and plm_codmat = mat_codigo  
                    and nota >= @nota_minima   
                    and alc_codper = per_codigo  
                    and b.pla_codigo = alc_codpla 
                    and per_estado = estp_estado 
             
             ) x  

             select cil_codcic,cast(cil_anio as varchar) +' ' + cic_nombre cil_codigo,uni_nombre,per_carnet,per_nombres_apellidos,car_nombre,pla_alias_carrera,fac_nombre,pla_nombre,
                    reg_nombre,cic_nombre,cil_anio,mat_codigo,mat_nombre,nota,nota_letras,estado,cum_parcil,cum,materias,
                    case when aprobadas >= materias then materias else aprobadas end aprobadas,
                    reprobadas,matricula,equivalencias,ing_nombre,estado_a,plm_anio_carrera, plm_ciclo, absorcion,uv 
             from @record  
             order by cil_anio, cil_codcic, plm_anio_carrera, plm_ciclo
       end  
  
       else  
  
       begin  
  
             insert into @record  (cil_codcic, cil_codigo ,uni_nombre ,per_carnet ,per_nombres_apellidos ,car_nombre ,pla_alias_carrera ,fac_nombre ,pla_nombre ,reg_nombre ,cic_nombre ,cil_anio ,mat_codigo ,mat_nombre ,nota ,nota_letras ,estado ,cum_parcil ,cum ,materias ,aprobadas ,reprobadas ,matricula ,equivalencias ,ing_nombre ,estado_a ,plm_anio_carrera ,plm_ciclo ,absorcion ,uv ) 
             select cil_codcic, cast(cil_anio as varchar) + cic_nombre cil_codigo,  
             uni_nombre, per_carnet, per_nombres_apellidos,   
             car_nombre,x.pla_alias_carrera, fac_nombre, pla_nombre,reg_nombre,   
             cic_nombre, cil_anio,  
             mat_codigo, mat_nombre,   
             round(nota,1) nota,   
             upper(dbo.NotaALetras(round(nota,1))),  
             estado estado, round(cum_ciclo,1) cum_parcial,   
             @cum cum,  
             @materias,  
             @aprobadas,  
             @reprobadas,   
             matricula,  
             @equivalencias,   
             ing_nombre,   
             estado_a, plm_anio_carrera, plm_ciclo, absorcion, uv  
             from  
             (  
                    select cil_codcic,cil_codigo codcil,uni_nombre, codper,per_carnet,   
                    per_nombres_apellidos,   
                    car_nombre,pla_alias_carrera, fac_nombre,pla_codigo,pla_nombre,  
                    reg_nombre,   
                    cic_nombre, cil_anio,   
                    mat_codigo, mat_nombre, isnull(nota,0) nota,   
                    estado =
                    CASE 
         
                     WHEN (mai_estado)= 'R' THEN 'Retirada'
                    WHEN isnull(round(nota,1),0) <  @nota_minima THEN 'Reprobada' 
                     ELSE 'Aprobada'

                END,

       --           case when mai_estado = 'I' and codins <> isnull((select codins from #ins),0) then   
       --           CASE WHEN  isnull(round(nota,1),0) < @nota_minima   
       --           THEN 'Reprobada'   
       --           ELSE 'Aprobada' END   
       --           when mai_estado = 'R' then 'Retirada'     
       --           when mai_estado = 'I'  and isnull((select codins from #ins),0) = codins then 'Cursando' else 'Aprobada' end estado,



                    dbo.cum_ciclo(cil_codigo,codper) cum_ciclo,0 cum,  
                    matricula,ing_nombre, estado_a, plm_anio_carrera, plm_ciclo, absorcion, uv  
                    from  
                    (  
                           select cil_codcic,cil_codigo,uni_nombre, codper codper, @campo1 per_carnet,   
                           @apellidos_nombres per_nombres_apellidos,   
                           car_nombre,pla_alias_carrera, reg_nombre, mat_codigo,  
                           isnull(plm_alias,mat_nombre) +  
                           case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre,   
                           cic_nombre, cil_anio, mai_estado,mai_codins codins,  
                           @campo0 codreg, mai_matricula matricula, fac_nombre, pla_codigo,pla_nombre, ing_nombre,  
                           @estado_persona estado_a, plm_anio_carrera, plm_ciclo,   
                           mai_absorcion absorcion, mai_codmat_del  
                           from @ra_mai_mat_inscritas_h_v, ra_mat_materias,   
                           ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras,ra_fac_facultades,  
                           ra_cil_ciclo, ra_cic_ciclos, ra_ing_ingreso, ra_plm_planes_materias,  
                           ra_uni_universidad, ra_reg_regionales  
                           where codper = @codigo_persona  
                           and alc_codper = codper  
                           and pla_codigo = alc_codpla  
                           and car_codigo = pla_codcar  
                           and fac_codigo = car_codfac  
                           and cil_codigo = codcil  
                           and cic_codigo = cil_codcic  
                           and mat_codigo = mai_codmat  
                           and ing_codigo = @tipo_ingreso  
                           and plm_codpla = pla_codigo  
                           and plm_codmat = mai_codmat  
                           and not exists (select 1 from ra_cca_cambio_carrera 
                                                      where cca_codper = @codigo_persona 
                                                      and cca_codmat_eqn is not null 
                                                      and cca_codmat_eqn <> '0'
                                                      and mai_codmat_del = cca_codmat)
                           and reg_codigo = cil_codreg  
                           and uni_codigo = reg_coduni  
                           and substring(@tipo,1,1) in('U','M')  
                    )j left outer join @notas on ins_codper = codper  
                    and mai_codmat = mai_codmat_del  
                    and ins_codcil = cil_codigo  
                    union all  
                    select 0,0,  
                    uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera,   
                    fac_nombre,pla_codigo,pla_nombre,  
                    reg_nombre,uni,car,eqn_codmat, mat_nombre, eqn_nota,   
                    case when eqn_nota >= @nota_minima then 'Aprobada' else 'Reprobada' end estado,  
                    0, 0,1,ing_nombre,  
                    estado, plm_anio_carrera, plm_ciclo,'',plm_uv  
                    from  
                    (  
                           select distinct uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera,   
                           reg_nombre,'Eq. Externa ' uni, '' car,   
                           eqn_codmat, isnull(plm_alias,mat_nombre) +  
                           case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre,   
                           (select avg(a.eqn_nota)   
                           from ra_eqn_equivalencia_notas a, ra_equ_equivalencia_universidad b  
                           where a.eqn_codmat = mat_codigo   
                           and a.eqn_codequ = b.equ_codigo  
                           and a.eqn_codmat is not null   
                           and a.eqn_nota > 0  
                           and b.equ_codper = per_codigo) eqn_nota, fac_nombre, pla_codigo,pla_nombre,  
                           ing_nombre,  estp_descripcion estado, plm_anio_carrera, plm_ciclo,  
                           plm_uv  
                           from ra_per_personas,ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,  
                           ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras, ra_reg_regionales, ra_uni_universidad,  
                           ra_mat_materias, ra_fac_facultades, ra_ing_ingreso, ra_plm_planes_materias, ra_estp_estado_persona 
                           where per_codigo = @codigo_persona  
                           and equ_codper = per_codigo  
                           and eqn_codequ = equ_codigo  
       --                  and equ_tipo = 'E'  
                           and alc_codper = per_codigo  
                           and pla_codigo = alc_codpla  
                           and car_codigo = pla_codcar  
                           and fac_codigo = car_codfac  
                           and mat_codigo = eqn_codmat  
                           and reg_codigo = per_codreg  
                           and uni_codigo = reg_coduni  
                           and eqn_nota > 0  
                           and ing_codigo = per_tipo_ingreso  
                           and plm_codpla = pla_codigo  
                           and plm_codmat = mat_codigo
                           and equ_codist <> 711    
                           and per_estado = estp_estado
                    ) t  
                    union all  
                    select 0,0,  
                    uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera,   
                    fac_nombre,pla_codigo,pla_nombre,  
                    reg_nombre,uni,car,eqn_codmat, mat_nombre, eqn_nota,   
                    case when eqn_nota >= @nota_minima then 'Aprobada' else 'Reprobada' end estado, 
                    0, 0,1,ing_nombre,  
                    estado, plm_anio_carrera, plm_ciclo,'', plm_uv  
                    from  
                    (  
                           select distinct uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,pla_alias_carrera,   
                           reg_nombre,'Eq. Interna ' uni, '1' car,   
                           eqn_codmat, isnull(plm_alias,mat_nombre) +  
                           case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre,   
                           (select avg(a.eqn_nota)   
                           from ra_eqn_equivalencia_notas a, ra_equ_equivalencia_universidad b  
                           where a.eqn_codmat = mat_codigo   
                           and a.eqn_codequ = b.equ_codigo  
                           and a.eqn_codmat is not null  
                           and a.eqn_nota > 0  
                           and b.equ_codper = per_codigo) eqn_nota, equ_codigo codequ, fac_nombre, pla_codigo,pla_nombre,  
                           ing_nombre, estp_descripcion estado, plm_anio_carrera, plm_ciclo,  
                           plm_uv  
                           from ra_per_personas,ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,  
                           ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras, ra_reg_regionales, ra_uni_universidad,  
                           ra_mat_materias, ra_fac_facultades, ra_ing_ingreso, ra_plm_planes_materias,ra_estp_estado_persona 
                           where per_codigo = @codigo_persona  
                           and equ_codper = per_codigo  
                           and eqn_codequ = equ_codigo  
       --                  and equ_tipo = 'I'  
                           and alc_codper = per_codigo  
                           and pla_codigo = alc_codpla  
                           and car_codigo = pla_codcar  
                           and fac_codigo = car_codfac  
                           and mat_codigo = eqn_codmat  
                           and reg_codigo = per_codreg  
                           and uni_codigo = reg_coduni  
                           and eqn_nota > 0  
                           and ing_codigo = per_tipo_ingreso  
                           and plm_codpla = pla_codigo  
                           and plm_codmat = mat_codigo
                           and equ_codist = 711  
                           and per_estado = estp_estado
                    ) t  
                    union all  
                    select distinct 1,0,  
                    uni_nombre, per_codigo,per_carnet, per_nombres_apellidos, car_nombre,b.pla_alias_carrera, fac_nombre,  
                    alc_codpla pla_codigo,b.pla_nombre pla_nombre,  
                    reg_nombre,'Eq. Interna ', '1',   
                    cca_codmat, isnull(plm_alias,mat_nombre) +  
                    case when plm_ciclo = 0 and plm_anio_carrera = 0 then ' (Optativa)' else '' end mat_nombre, nota,   
                    'Aprobada' estado,0 , 0, 1,  
                    ing_nombre, estp_descripcion  estado, plm_anio_carrera, plm_ciclo,'',plm_uv  
                    from ra_per_personas,ra_cca_cambio_carrera,ra_alc_alumnos_carrera,ra_pla_planes b,  
                    ra_pla_planes a, ra_car_carreras, ra_fac_facultades,  
                    ra_reg_regionales, ra_uni_universidad,  
                    ra_mat_materias, @notas,ra_ing_ingreso, ra_plm_planes_materias, ra_estp_estado_persona 
                    where per_codigo = @codigo_persona  
                    and cca_codper = per_codigo  
                    and a.pla_codigo = cca_codpla_eqn  
                    and car_codigo = a.pla_codcar  
                    and fac_codigo = car_codfac  
                    and mat_codigo = cca_codmat_eqn  
                    and reg_codigo = per_codreg  
                    and uni_codigo = reg_coduni  
                    and ins_codper = cca_codper  
                    and mai_codmat = cca_codmat  
                    and cca_codmat_eqn is not null and cca_codmat_eqn <> '0'
                    and ing_codigo = per_tipo_ingreso  
                    and plm_codpla = a.pla_codigo  
                    and plm_codmat = mat_codigo  
                    and nota >= @nota_minima   
                    and alc_codper = per_codigo  
                    and b.pla_codigo = alc_codpla  
                    and per_estado = estp_estado
             ) x  
             where round(nota,1) >= @nota_minima  
  
             declare @um float
             select @um = round(sum(isnull(uv,0) * isnull(nota,0)),2) from @uv_total
             --select sum(uv) from @uv_total
             update @record set um = @um

             select cil_codcic,cast(cil_anio as varchar) + ' '+cic_nombre cil_codigo,uni_nombre,per_carnet,per_nombres_apellidos,car_nombre,pla_alias_carrera,fac_nombre,pla_nombre,
                    reg_nombre,cic_nombre,cil_anio,mat_codigo,mat_nombre,nota,nota_letras,estado,cum_parcil, round((um/@tot_uv),1) cum,materias,
                    case when aprobadas >= materias then materias else aprobadas end aprobadas,
                    reprobadas,matricula,equivalencias,ing_nombre,estado_a,plm_anio_carrera, plm_ciclo, absorcion,uv
             from @record
             order by cil_anio, cil_codcic, plm_anio_carrera, plm_ciclo

       end
end

