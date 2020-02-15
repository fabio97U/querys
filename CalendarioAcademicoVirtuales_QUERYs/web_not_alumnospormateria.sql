USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[web_not_alumnospormateria]    Script Date: 15/2/2020 08:38:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[web_not_alumnospormateria] 
(
--[web_not_alumnospormateria]  117, 4083, 3, '2807MP', 1, 3
--[web_not_alumnospormateria]  120, 183, 1, 'PSO2-H01', 0, 0
       @cic int,@emp int,@tip int,@tot varchar(100),@exdif int,@exor int
)
as
declare @ev int,
       @fech datetime,
       @ev1 int,
       @num int,
       @proc int,
       @procd int,
       @tipo varchar(50),
       @periodo varchar(50),
       @ciclo_pre int,
       @dias_val nvarchar(20),
       @hora_val nvarchar(10),
       @fecha_limite datetime,
       @cuota int,
       @cuota_beca int,
       @cuota_virtual int,
       @codmat_d varchar(10),
       @ev_d int,
       @codpre int,
       @seccion varchar(2),
       @codcil int,
       @cuota_virtual_beca int,
	   @codhpl int

       select @fech=getdate()
       set @ev=0
       set @ev1=0
       set @periodo=''
       set @num=0
       set @proc=0
       set @procd=0
       set @tipo=''
       set @dias_val = ''
       set @hora_val = ''
       set @fecha_limite = getdate()
       set @cuota_beca = 0
       set @cuota = 0
       set @cuota_virtual=0
       set @ev_d = 0
       set @codpre = 0
       set @seccion = ''
       set @codcil = 0

       set dateformat dmy

	   DECLARE @Aranceles_evaluar table (tmo_codigo int)
if @tip=1--pregrado
  begin
  ---------*********************************************************************************************
       select @ev_d = penot_eval from web_ra_not_penot_periodonotas where penot_codigo = @exor

       print '@ev_d : ' + cast(@ev_d as nvarchar(5))
     --select @ev1=penot_codigo,@ev=penot_eval ,@periodo=penot_periodo,@tipo=penot_tipo  from web_ra_not_penot_periodonotas  where ( (convert(varchar,getdate(),103))>=penot_fechaini) and ( (convert(varchar,getdate(),103))<=penot_fechafin)and(penot_tipo='Pregrado')
       select @ev1=penot_codigo,@ev=penot_eval ,@periodo=penot_periodo,@tipo=penot_tipo  
        from web_ra_not_penot_periodonotas   
        where getdate()>=penot_fechaini and getdate() <= penot_fechafin and penot_tipo='Pregrado'
       
	   print '@ev1 : ' + cast(@ev1 as nvarchar(5))
       declare  @eval nvarchar(20)

	   --select * from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO' order by are_codtmo
       if @ev in (1)--primera
         begin
          --set @cuota = 134 
          --set @cuota_beca = 158 
          --set @cuota_virtual = 2053
          --set @cuota_virtual_beca = 2218
			  set @eval='primera'
			  insert into @Aranceles_evaluar (tmo_codigo)
			  select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO' and are_cuota = 2 and tde_nombre = 'Pre grado'
         end
       if @ev in (2)--segunda
         begin
          --set @cuota=135 
          --set @cuota_beca=159 
          --set @cuota_virtual=2054 
          --set @cuota_virtual_beca = 2219
				set @eval='segunda'
				insert into @Aranceles_evaluar (tmo_codigo)
				select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO' and are_cuota = 3 and tde_nombre = 'Pre grado'
         end
       if @ev in (3)--tercera
         begin
          --set @cuota=136 
          --set @cuota_beca=160 
          --set @cuota_virtual=2055 
          --set @cuota_virtual_beca = 2220
				set @eval='tercera'
				insert into @Aranceles_evaluar (tmo_codigo)
				select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO' and are_cuota = 4 and tde_nombre = 'Pre grado'
          end
       if @ev in (4)--cuarta
         begin
          --set @cuota=137 
          --set @cuota_beca=161 
          --set @cuota_virtual=2056 
          --set @cuota_virtual_beca = 2221
				set @eval='cuarta'
				insert into @Aranceles_evaluar (tmo_codigo)
				select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO' and are_cuota = 5 and tde_nombre = 'Pre grado'
         end
       if @ev in (5)--quinta
         begin
          --set @cuota=943 
          --set @cuota_beca=944 
          --set @cuota_virtual=2057 
          --set @cuota_virtual_beca = 2222
				set @eval='quinta'
				insert into @Aranceles_evaluar (tmo_codigo)
				select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO' and are_cuota = 6 and tde_nombre = 'Pre grado'
         end
         print '@eval : ' + @eval

  ---*****Buscar dia y hora para validar pagos segun calendario académico
  ----Inicia
             select @dias_val=(CASE WHEN isnull(hpl_lunes, 'N') = 'S' THEN 'L-' ELSE '' END + CASE WHEN isnull(hpl_martes,'N') = 'S' THEN 'M-' ELSE '' END + CASE WHEN isnull(hpl_miercoles, 'N') = 'S' THEN 'Mi-' ELSE '' END + CASE WHEN isnull(hpl_jueves, 'N') 
             = 'S' THEN 'J-' ELSE '' END + CASE WHEN isnull(hpl_viernes, 'N') = 'S' THEN 'V-' ELSE '' END + CASE WHEN isnull(hpl_sabado, 'N') = 'S' THEN 'S-' ELSE '' END + CASE WHEN isnull(hpl_domingo, 'N') = 'S' THEN 'D-' ELSE '' END),
             @hora_val=substring(man_nomhor,1,5),@codmat_d = hpl_codmat, @codhpl = hpl_codigo
             from ra_hpl_horarios_planificacion join ra_man_grp_hor on man_codigo = hpl_codman
             where hpl_codcil = @cic
             AND (ltrim(rtrim(ra_hpl_horarios_planificacion.hpl_codmat))+ ltrim(rtrim(ra_hpl_horarios_planificacion.hpl_descripcion))= @tot)
             and hpl_codemp = @emp
  ----Termina 

   --Inicia Busqueda de fecha limite de pago en calendario académico
             select @fecha_limite = caa_fecha from dbo.web_ra_caa_calendario_acad where caa_dias = @dias_val and caa_hora = @hora_val and caa_evaluacion = @ev

       --Termina validación
  --****************************************************************************************************
   print '@fecha_limite : ' + cast(@fecha_limite as nvarchar(30))
             select @proc=count(1)from web_ra_innot_ingresosdenotas where (ltrim(rtrim (innot_codmai)) + ltrim(rtrim(innot_seccion))=@tot)and innot_codcil=@cic and innot_codemp=@emp and (innot_codpenot=@ev1)
             select @procd=count(1)from web_ra_innot_ingresosdenotas where (ltrim(rtrim (innot_codmai)) + ltrim(rtrim(innot_seccion))=@tot)and innot_codcil=@cic and (innot_codpenot=@exor)
             SELECT @ev1 as codperio, @ev as eval,@periodo as periodo,@num,@proc as procesada,@procd as procesadadif,@tipo as tipo, @codhpl codhpl
----------------************************************************

             SELECT      tpm_tipo_materia  AS Tipo
			 --CASE WHEN (hpl_tipo_materia) = 'P' THEN 'Presencial' ELSE '' END + CASE WHEN (hpl_tipo_materia) = 'V' THEN 'Virtual' ELSE '' END + CASE WHEN (hpl_tipo_materia) = 'S' THEN 'Semi-Presencial' ELSE '' END AS Tipo
			 , ra_mat_materias.mat_codigo as codmat,

                                          ra_mat_materias.mat_nombre AS materia, ra_hpl_horarios_planificacion.hpl_descripcion AS secc, ra_aul_aulas.aul_nombre_corto as aula, 
                                          man_nomhor AS horas, CASE WHEN isnull(hpl_lunes, 'N') = 'S' THEN 'L-' ELSE '' END + CASE WHEN isnull(hpl_martes,
                                           'N') = 'S' THEN 'M-' ELSE '' END + CASE WHEN isnull(hpl_miercoles, 'N') = 'S' THEN 'Mi-' ELSE '' END + CASE WHEN isnull(hpl_jueves, 'N') 
                                          = 'S' THEN 'J-' ELSE '' END + CASE WHEN isnull(hpl_viernes, 'N') = 'S' THEN 'V-' ELSE '' END + CASE WHEN isnull(hpl_sabado, 'N') 
                                          = 'S' THEN 'S-' ELSE '' END + CASE WHEN isnull(hpl_domingo, 'N') = 'S' THEN 'D-' ELSE '' END AS Dias, empleado.emp_nombres_apellidos as docente
             FROM         pla_emp_empleado AS empleado INNER JOIN
                                          ra_hpl_horarios_planificacion ON ra_hpl_horarios_planificacion.hpl_codemp = emp_codigo INNER JOIN

										  ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia inner join

                                          ra_mat_materias ON ra_mat_materias.mat_codigo = ra_hpl_horarios_planificacion.hpl_codmat INNER JOIN
                                          ra_esc_escuelas ON ra_esc_escuelas.esc_codigo = ra_mat_materias.mat_codesc INNER JOIN
                                          ra_fac_facultades ON ra_esc_escuelas.esc_codfac = ra_fac_facultades.fac_codigo INNER JOIN
                                          ra_aul_aulas ON ra_aul_aulas.aul_codigo = ra_hpl_horarios_planificacion.hpl_codaul INNER JOIN
                                          ra_man_grp_hor ON ra_man_grp_hor.man_codigo = ra_hpl_horarios_planificacion.hpl_codman
             WHERE     (ra_hpl_horarios_planificacion.hpl_codcil = @cic) AND (emp_codigo = @emp) AND (ltrim(rtrim(ra_mat_materias.mat_codigo))+ ltrim(rtrim(ra_hpl_horarios_planificacion.hpl_descripcion))= @tot) and hpl_tipo_materia <> 'A'
       --------******Validación para examenes diferidos

if @ev<>0 and @periodo='Diferido' and @procd=0 and @exor<>0 and @exdif<>0
    begin
             ----**********Crear tabla para los alumnos que ya se evaluaron
             print cast(@ev as varchar)
             declare @evaluados table(npro_alumno int)
             insert into @evaluados select npro_alumno 
             from web_ra_npro_notasprocesadas
             INNER JOIN web_ra_innot_ingresosdenotas
             ON web_ra_npro_notasprocesadas.npro_codinnot = web_ra_innot_ingresosdenotas.innot_codingre
             where ltrim(rtrim (innot_codmai)) + ltrim(rtrim(innot_seccion))=@tot and innot_codcil=@cic
             and innot_tipo='Pregrado' and (innot_codpenot=@exdif or innot_codpenot=@exor)

             -------------------------------------------------------------
             ---Crear tabla temporal para evaluar si cancelo el diferido
             declare @SinEvaluarse table(percodigo int, carnet nvarchar(12), nombres nvarchar(201))

             insert into @SinEvaluarse 
			 SELECT     distinct ra_per_personas.per_codigo AS percodigo, ra_per_personas.per_carnet AS carnet, ra_per_personas.per_apellidos_nombres AS nombres
             FROM         ra_cil_ciclo INNER JOIN
             ra_ins_inscripcion ON ra_cil_ciclo.cil_codigo = ra_ins_inscripcion.ins_codcil INNER JOIN
             ra_per_personas ON ra_ins_inscripcion.ins_codper = ra_per_personas.per_codigo INNER JOIN
             ra_mai_mat_inscritas ON ra_ins_inscripcion.ins_codigo = ra_mai_mat_inscritas.mai_codins INNER JOIN
             ra_hpl_horarios_planificacion ON ra_mai_mat_inscritas.mai_codhpl = ra_hpl_horarios_planificacion.hpl_codigo INNER JOIN
             ra_mat_materias ON ra_mai_mat_inscritas.mai_codmat = ra_mat_materias.mat_codigo INNER JOIN
             web_ra_innot_ingresosdenotas ON ra_mat_materias.mat_codigo = web_ra_innot_ingresosdenotas.innot_codmai
             WHERE (ra_cil_ciclo.cil_codigo =@cic) and (ra_mai_mat_inscritas.mai_estado = 'I')   and (ra_hpl_horarios_planificacion.hpl_codemp =@emp ) AND 
             (ltrim(rtrim(ra_mat_materias.mat_codigo))+ ltrim(rtrim(ra_hpl_horarios_planificacion.hpl_descripcion))= @tot) and 
             not exists (select 1 from @evaluados where npro_alumno = per_codigo)
             order by nombres
             ----
             ---Evaluando si cancelo examen diferido correspondiente a la materia
             
             select distinct percodigo,carnet,nombres from (
                    select percodigo,carnet,nombres 
                    from @SinEvaluarse 
                    where exists(select 1 from col_mov_movimientos join col_dmo_det_mov on dmo_codmov = mov_codigo and mov_estado <> 'A'
                    and dmo_codcil = @cic and dmo_codtmo = 909 and mov_codper = percodigo and dmo_codmat = @codmat_d and dmo_eval = @ev_d)
                    union all
                    select aan_codper percodigo, per_carnet carnet, per_apellidos_nombres nombres 
                    from ra_aan_activar_alumno_notas
                    join ra_ins_inscripcion on ins_codper = aan_codper and ins_codcil = @cic
                    join ra_per_personas on per_codigo = ins_codper
                    join ra_mai_mat_inscritas on mai_codins = ins_codigo
                    join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl and hpl_codigo = aan_codhpl and hpl_codcil = aan_codcil
                    where aan_codper=ins_codper and aan_codcil=@cic and aan_periodo=@ev_d and RTRIM(LTRIM(hpl_codmat))+RTRIM(LTRIM(hpl_descripcion))=@tot and aan_tipo = 'Extraordinario'
                    and aan_codper in (select percodigo from @SinEvaluarse)
                    ) d
             order by nombres
             --Eliminando tablas temporales
             --drop table #evaluados
             --drop table #SinEvaluarse
       -------------****Termina validacion!------------------------------
       end

if @ev<>0 and @periodo='Actividades'and @proc=0
begin
print '@ev: :' + cast(@ev as nvarchar)
	--declare @insAct table(percodigo int, carnet nvarchar(12), nombres nvarchar(201))
	--insert into @insAct
	exec web_alumnos_subir_notas_actividades 1, @tot, @cic, @ev, @periodo, 'Pregrado', @ev1

	--select distinct a.percodigo, a.carnet, a.nombres 
 --   from
 --   (
            --select percodigo,carnet,nombres from @insAct
            --union
            --select distinct aan_codper percodigo,per_carnet carnet,per_apellidos_nombres nombres 
            --from ra_aan_activar_alumno_notas
            --join ra_ins_inscripcion on ins_codper = aan_codper and ins_codcil = @cic
            --join ra_per_personas on per_codigo = ins_codper
            --join ra_mai_mat_inscritas on mai_codins = ins_codigo
            --join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl and hpl_codigo = aan_codhpl  and hpl_codcil = aan_codcil
            --where aan_codper=ins_codper and aan_codcil=@cic and aan_periodo=@ev and RTRIM(LTRIM(hpl_codmat))+RTRIM(LTRIM(hpl_descripcion))=@tot and aan_tipo = 'Extraordinario'--)as a
 --   order by a.nombres
end

if  @ev<>0 and @periodo='Ordinario' and @proc=0
       begin

             print 'if  @ev<>0 and @periodo=Ordinario and @proc=0'
             
             --Creo tabla temporal para obtener los alumnos que cancelaron antes de la fecha del parcial
             declare @ins1 table(percodigo int, carnet nvarchar(12), nombres nvarchar(201))

             print '----------------------------------------------------------'
             if ((select cil_codcic from ra_cil_ciclo where cil_codigo = @cic) = 3)
             begin
                    print 'Es Interciclo'
                    insert into @ins1 
                    SELECT distinct ra_per_personas.per_codigo as percodigo, ra_per_personas.per_carnet as carnet, ra_per_personas.per_apellidos_nombres as nombres
                    FROM         ra_cil_ciclo INNER JOIN
                                                        ra_ins_inscripcion ON ra_cil_ciclo.cil_codigo = ra_ins_inscripcion.ins_codcil INNER JOIN
                                                        ra_per_personas ON ra_ins_inscripcion.ins_codper = ra_per_personas.per_codigo INNER JOIN
                                                        ra_mai_mat_inscritas ON ra_ins_inscripcion.ins_codigo = ra_mai_mat_inscritas.mai_codins INNER JOIN
                                                        ra_hpl_horarios_planificacion ON ra_mai_mat_inscritas.mai_codhpl = ra_hpl_horarios_planificacion.hpl_codigo INNER JOIN
                                                        ra_mat_materias ON hpl_codmat = mat_codigo
                                                        --ra_mat_materias ON ra_mai_mat_inscritas.mai_codmat = ra_mat_materias.mat_codigo
                    WHERE     (ra_cil_ciclo.cil_codigo = @cic) and(ra_mai_mat_inscritas.mai_estado = 'I') AND (ltrim(rtrim(ra_mat_materias.mat_codigo))+ ltrim(rtrim(ra_hpl_horarios_planificacion.hpl_descripcion))= @tot) and (ra_hpl_horarios_planificacion.hpl_codemp=@emp)
                    print 'Fin es Interciclo'
             end    --     if ((select cil_codcic from ra_cil_ciclo where cil_codigo = @cic) = 3)
             else   --     if ((select cil_codcic from ra_cil_ciclo where cil_codigo = @cic) = 3)
             begin
                    print 'Es un ciclo normal'
                    insert into @ins1 
                    SELECT distinct ra_per_personas.per_codigo as percodigo, ra_per_personas.per_carnet as carnet, ra_per_personas.per_apellidos_nombres as nombres
                    FROM         ra_cil_ciclo INNER JOIN
                                                        ra_ins_inscripcion ON ra_cil_ciclo.cil_codigo = ra_ins_inscripcion.ins_codcil INNER JOIN
                                                        ra_per_personas ON ra_ins_inscripcion.ins_codper = ra_per_personas.per_codigo INNER JOIN
                                                        ra_mai_mat_inscritas ON ra_ins_inscripcion.ins_codigo = ra_mai_mat_inscritas.mai_codins INNER JOIN
                                                        ra_hpl_horarios_planificacion ON ra_mai_mat_inscritas.mai_codhpl = ra_hpl_horarios_planificacion.hpl_codigo INNER JOIN
                                                        ra_mat_materias ON hpl_codmat = mat_codigo
                                                        --ra_mat_materias ON ra_mai_mat_inscritas.mai_codmat = ra_mat_materias.mat_codigo
                    WHERE     (ra_cil_ciclo.cil_codigo = @cic) and(ra_mai_mat_inscritas.mai_estado = 'I') AND 
                                  (ltrim(rtrim(ra_mat_materias.mat_codigo))+ ltrim(rtrim(ra_hpl_horarios_planificacion.hpl_descripcion))= @tot) and (ra_hpl_horarios_planificacion.hpl_codemp=@emp)
                           and exists
                           (
                                  select 1 from col_mov_movimientos join col_dmo_det_mov on 
                                        dmo_codmov = mov_codigo 
                                  where mov_codper = ins_codper and mov_estado <> 'A' and 
                                        dmo_codcil = @cic and dmo_codtmo in --(@cuota,@cuota_beca,@cuota_virtual, @cuota_virtual_beca) 
                                               (
													select tmo_codigo from @Aranceles_evaluar
                                                    --select are_codtmo from vst_Aranceles_x_Evaluacion 
                                                    --where are_tipo = 'PREGRADO' and  spaet_codigo = @ev and are_tipoarancel = 'Men'
                                               )
                                  --and convert(varchar(10),mov_fecha_cobro,103) <= @fecha_limite)
								  and convert(varchar(10),mov_fecha_real_pago ,103) <= @fecha_limite)
             end    --     if ((select cil_codcic from ra_cil_ciclo where cil_codigo = @cic) = 3)
                    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                    --COMENTARIADA SOLO PARA INTERCICLO
                    --FIN COMENTARIADA SOLO PARA INTERCICLO

             print '1'
             print '@cuota : ' + cast(@cuota as nvarchar(6))
             print '@cuota_virtual : ' +  cast(@cuota_virtual as nvarchar(6))
             print '@ev : ' + cast(@ev as nvarchar(6))
                    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                    --creo tabla temporal para obtener los alumnos que tienen prórroga
                    declare @ins2 table(percodigo int, carnet nvarchar(12), nombres nvarchar(201))
                    insert into @ins2 
                    SELECT distinct ra_per_personas.per_codigo as percodigo, ra_per_personas.per_carnet as carnet, ra_per_personas.per_apellidos_nombres as nombres
                    FROM ra_cil_ciclo INNER JOIN
                           ra_ins_inscripcion ON ra_cil_ciclo.cil_codigo = ra_ins_inscripcion.ins_codcil INNER JOIN
                           ra_per_personas ON ra_ins_inscripcion.ins_codper = ra_per_personas.per_codigo INNER JOIN
                           ra_mai_mat_inscritas ON ra_ins_inscripcion.ins_codigo = ra_mai_mat_inscritas.mai_codins INNER JOIN
                           ra_hpl_horarios_planificacion ON ra_mai_mat_inscritas.mai_codhpl = ra_hpl_horarios_planificacion.hpl_codigo INNER JOIN
                           ra_mat_materias ON ra_mai_mat_inscritas.mai_codmat = ra_mat_materias.mat_codigo INNER JOIN 
                           ra_man_grp_hor ON hpl_codman=man_codigo -- SE AGREGO PARA PODER SACAR LOS SACAR LAS PRORROGAS POR HORA
                    WHERE   (ra_cil_ciclo.cil_codigo = @cic) and(ra_mai_mat_inscritas.mai_estado = 'I') AND 
                           (ltrim(rtrim(ra_mat_materias.mat_codigo))+ ltrim(rtrim(ra_hpl_horarios_planificacion.hpl_descripcion))= @tot) and 
                           (ra_hpl_horarios_planificacion.hpl_codemp=@emp)
                    and exists
                    (
                           select 1 from ra_pra_prorroga_acad 
						   where pra_codper = ins_codper and pra_codcil = @cic and pra_codtmo in -- (@cuota,@cuota_virtual)
							(
								--select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO' and spaet_codigo = @ev and are_tipoarancel = 'Men'
								select tmo_codigo from @Aranceles_evaluar
							)
                                  --SE AGREGO PARA PODER SACAR LAS PRORROGAS POR HORA  12/12/2014
                                  -- and  pra_fecha<= (select convert(datetime,caa_fecha,103)+ ' '+caa_hora  -- Para sacar por hora
                                  and  convert(datetime,convert(varchar,pra_fecha,103),103) <= 
								  (
								  select convert(datetime,convert(varchar,caa_fecha,103),103)--+ ' '+caa_hora -- para sacar po dia entero
									from web_ra_caa_calendario_acad 
								where  caa_dias=(
										case when isnull(hpl_lunes, 'N') = 'S' then 'L-' else '' end +
										case when isnull(hpl_martes, 'N') = 'S' then 'M-' else '' end +
										case when isnull(hpl_miercoles, 'N') = 'S' then 'Mi-' else '' end +
										case when isnull(hpl_jueves, 'N') = 'S' then 'J-' else '' end +
										case when isnull(hpl_viernes, 'N') = 'S' then 'V-' else '' end +
										case when isnull(hpl_sabado, 'N') = 'S' then 'S-' else '' end +
										case when isnull(hpl_domingo, 'N') = 'S' then 'D-' else '' end 
										) 
										and caa_hora = substring(man_nomhor,1,5) 
										and caa_evaluacion=@ev )
                    )
                    print '2'
					
--[web_not_alumnospormateria]  119, 1775, 1, 'EPRO-I02', 0, 0
                    --Realizo la unión de los alumnos para mostrar el listado
                    select distinct a.percodigo, a.carnet, a.nombres 
                    from
                    (
                           select percodigo,carnet,nombres from @ins1
                           union
                           select percodigo,carnet,nombres from @ins2
                           union
                           select distinct aan_codper percodigo,per_carnet carnet,per_apellidos_nombres nombres 
                           from ra_aan_activar_alumno_notas
                           join ra_ins_inscripcion on ins_codper = aan_codper and ins_codcil = @cic
                           join ra_per_personas on per_codigo = ins_codper
                           join ra_mai_mat_inscritas on mai_codins = ins_codigo
                           join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl and hpl_codigo = aan_codhpl  and hpl_codcil = aan_codcil
                           where aan_codper=ins_codper and aan_codcil=@cic and aan_periodo=@ev and RTRIM(LTRIM(hpl_codmat))+RTRIM(LTRIM(hpl_descripcion))=@tot and aan_tipo = 'Ordinario')as a
                    order by a.nombres
                    --elimino las tablas temporales
                    --drop table #ins1
                    --drop table #ins2
       end
end
----------------------------------------------------------------------------------------------------------------------------------------------------
if @tip=2--maestria
  begin


select @ev1=penot_codigo,@ev=penot_eval ,@periodo=penot_periodo,@tipo=penot_tipo  from web_ra_not_penot_periodonotas_maes  where((@fech>=penot_fechaini) and (@fech<=penot_fechafin)and(penot_tipo='Maestria'))
     select @proc=count(1)from web_ra_innot_ingresosdenotas where innot_codemp=@emp and (ltrim(rtrim (innot_codmai)) + ltrim(rtrim(innot_seccion))=@tot)and innot_codcil=@cic and innot_codpenot=@ev1
     SELECT @ev1 as codperio, @ev as eval,@periodo as periodo,@num,@proc as procesada,@tipo as tipo
SELECT     tpm_tipo_materia  AS Tipo,
			--CASE WHEN (hpl_tipo_materia) = 'P' THEN 'Presencial' ELSE '' END + CASE WHEN (hpl_tipo_materia) = 'V' THEN 'Virtual' ELSE '' END + CASE WHEN (hpl_tipo_materia) = 'S' THEN 'Semi-Presencial' ELSE '' END AS Tipo,

			ra_mat_materias.mat_codigo as codmat,
					   
                      ra_mat_materias.mat_nombre AS materia, ra_hpl_horarios_planificacion.hpl_descripcion AS secc, ra_aul_aulas.aul_nombre_corto as aula, 
                      RIGHT('0' + CAST(DATEPART(hh, ra_man_grp_hor.man_hor_ini) AS varchar), 2) + ':' + RIGHT('0' + CAST(DATEPART(n, ra_man_grp_hor.man_hor_ini) 
                      AS varchar), 2) + '-' + RIGHT('0' + CAST(DATEPART(hh, ra_man_grp_hor.man_hor_fin) AS varchar), 2) + ':' + RIGHT('0' + CAST(DATEPART(n, 
                      ra_man_grp_hor.man_hor_fin) AS varchar), 2) AS horas, CASE WHEN isnull(hpl_lunes, 'N') = 'S' THEN 'L-' ELSE '' END + CASE WHEN isnull(hpl_martes,
                       'N') = 'S' THEN 'M-' ELSE '' END + CASE WHEN isnull(hpl_miercoles, 'N') = 'S' THEN 'Mi-' ELSE '' END + CASE WHEN isnull(hpl_jueves, 'N') 
                      = 'S' THEN 'J-' ELSE '' END + CASE WHEN isnull(hpl_viernes, 'N') = 'S' THEN 'V-' ELSE '' END + CASE WHEN isnull(hpl_sabado, 'N') 
                      = 'S' THEN 'S-' ELSE '' END + CASE WHEN isnull(hpl_domingo, 'N') = 'S' THEN 'D-' ELSE '' END AS Dias, empleado.emp_nombres_apellidos as docente
FROM         pla_emp_empleado AS empleado INNER JOIN
                      ra_hpl_horarios_planificacion ON ra_hpl_horarios_planificacion.hpl_codemp = emp_codigo INNER JOIN

						ra_tpm_tipo_materias on hpl_tipo_materia = tpm_tipo_materia inner join

                      ra_mat_materias ON ra_mat_materias.mat_codigo = ra_hpl_horarios_planificacion.hpl_codmat INNER JOIN
                      ra_esc_escuelas ON ra_esc_escuelas.esc_codigo = ra_mat_materias.mat_codesc INNER JOIN
                      ra_fac_facultades ON ra_esc_escuelas.esc_codfac = ra_fac_facultades.fac_codigo INNER JOIN
                      ra_aul_aulas ON ra_aul_aulas.aul_codigo = ra_hpl_horarios_planificacion.hpl_codaul INNER JOIN
                      ra_man_grp_hor ON ra_man_grp_hor.man_codigo = ra_hpl_horarios_planificacion.hpl_codman
WHERE     (ra_hpl_horarios_planificacion.hpl_codcil = @cic) AND (emp_codigo = @emp) and (ltrim(rtrim(ra_mat_materias.mat_codigo))+ ltrim(rtrim(ra_hpl_horarios_planificacion.hpl_descripcion))= @tot) 
if @ev<>0 and @periodo='Diferido' and @proc=0 and @exdif<>0
    begin
SELECT     distinct ra_per_personas.per_codigo AS percodigo, ra_per_personas.per_carnet AS carnet, ra_per_personas.per_apellidos_nombres AS nombres
FROM         ra_cil_ciclo INNER JOIN
                      ra_ins_inscripcion ON ra_cil_ciclo.cil_codigo = ra_ins_inscripcion.ins_codcil INNER JOIN
                      ra_per_personas ON ra_ins_inscripcion.ins_codper = ra_per_personas.per_codigo INNER JOIN
                      ra_mai_mat_inscritas ON ra_ins_inscripcion.ins_codigo = ra_mai_mat_inscritas.mai_codins INNER JOIN
                      ra_hpl_horarios_planificacion ON ra_mai_mat_inscritas.mai_codhpl = ra_hpl_horarios_planificacion.hpl_codigo INNER JOIN
                      ra_mat_materias ON ra_mai_mat_inscritas.mai_codmat = ra_mat_materias.mat_codigo INNER JOIN
                      web_ra_innot_ingresosdenotas ON ra_mat_materias.mat_codigo = web_ra_innot_ingresosdenotas.innot_codmai
WHERE     (ra_cil_ciclo.cil_codigo =@cic) and (ra_mai_mat_inscritas.mai_estado = 'I') AND (ltrim(rtrim(ra_mat_materias.mat_codigo))+ ltrim(rtrim(ra_hpl_horarios_planificacion.hpl_descripcion))= @tot) AND(web_ra_innot_ingresosdenotas.innot_codpenot=@exdif) and (ra_hpl_horarios_planificacion.hpl_codemp =@emp ) AND 
                     ( ra_per_personas.per_codigo NOT IN
                          (SELECT  distinct   web_ra_npro_notasprocesadas.npro_alumno
FROM         web_ra_npro_notasprocesadas INNER JOIN
                      web_ra_innot_ingresosdenotas ON web_ra_npro_notasprocesadas.npro_codinnot = web_ra_innot_ingresosdenotas.innot_codingre where innot_codemp=@emp and (ltrim(rtrim (innot_codmai))+rtrim(ltrim(innot_seccion))=@tot) and innot_codcil=@cic and innot_tipo='Maestria' and innot_codpenot=@exdif))
ORDER BY nombres       
   
    end
if  @ev<>0 and @periodo='Ordinario' and @proc=0
  begin

SELECT distinct ra_per_personas.per_codigo as percodigo, ra_per_personas.per_carnet as carnet, ra_per_personas.per_apellidos_nombres as nombres
FROM         ra_cil_ciclo INNER JOIN
                      ra_ins_inscripcion ON ra_cil_ciclo.cil_codigo = ra_ins_inscripcion.ins_codcil INNER JOIN
                      ra_per_personas ON ra_ins_inscripcion.ins_codper = ra_per_personas.per_codigo INNER JOIN
                      ra_mai_mat_inscritas ON ra_ins_inscripcion.ins_codigo = ra_mai_mat_inscritas.mai_codins INNER JOIN
                      ra_hpl_horarios_planificacion ON ra_mai_mat_inscritas.mai_codhpl = ra_hpl_horarios_planificacion.hpl_codigo INNER JOIN
                      ra_mat_materias ON ra_mai_mat_inscritas.mai_codmat = ra_mat_materias.mat_codigo
WHERE     (ra_cil_ciclo.cil_codigo = @cic)  and (ra_mai_mat_inscritas.mai_estado = 'I') AND (ltrim(rtrim(ra_mat_materias.mat_codigo))+ ltrim(rtrim(ra_hpl_horarios_planificacion.hpl_descripcion))= @tot) and(ra_hpl_horarios_planificacion.hpl_codemp=@emp)order by nombres
end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if @tip=3--Especialidad
  begin
  
             declare @tipMod nvarchar(2), @codhmp int, @d varchar(100), @hor nvarchar(25), @aula nvarchar(30),@codmatpre nvarchar(100), @ordenMod int

             print '@tot: '+@tot
             print '---------------------------------'

             set @tipMod = right(@tot,2)
             set @tot = replace(@tot,right(@tot,2),'')

             print '@tipMod: '+@tipMod
             print '@tot: '+@tot
             print '---------------------------------'

             if @tipMod = 'MP'
             begin
                           select top 1 @codmatpre =  (cast(hmp_codapr as nvarchar(100))+cast(hmp_descripcion as nvarchar(100))) from pg_hmp_horario_modpre where cast(hmp_codigo as nvarchar(100))=@tot
                           select @ordenMod = mpr_orden, @codpre = mpr_codpre, @seccion = hmp_descripcion, @cic = pre_codcil from pg_hmp_horario_modpre
                                  inner join pg_mpr_modulo_preespecializacion on mpr_codigo = hmp_codmpr
                                  inner join pg_pre_preespecializacion on pre_codigo = mpr_codpre
                           where cast(hmp_codigo as nvarchar(100))=@tot

                           print '@codmatpre: '+ @codmatpre
                           print '@codpre: '+ cast(@codpre as nvarchar(20))
                           print '@seccion: '+ @seccion
                           print '-------------------------------'

                           print '@ordenMod: '+ cast(@ordenMod as nvarchar(2))
                           print '-------------------------------'


                           select @ciclo_pre=max(apr_codcil) 
                           from  dbo.pg_hmp_horario_modpre inner join pg_apr_aut_preespecializacion on hmp_codapr=apr_codigo
                           where (ltrim(rtrim(pg_hmp_horario_modpre.hmp_codapr))+ ltrim(rtrim(pg_hmp_horario_modpre.hmp_descripcion))= @codmatpre)
						   print '@fech: ' + cast(@fech as varchar(25))
                           select @ev1=penot_codigo,@ev=penot_eval ,@periodo=penot_periodo,@tipo=penot_tipo  from web_pg_not_penot_periodonotas  where((@fech>=penot_fechaini) and (@fech<=penot_fechafin)and(penot_tipo='Preespecialidad'))
                           select @proc=count(1)
                           from web_pg_innot_ingresosdenotas where innot_codemp=@emp and (ltrim(rtrim (innot_codmai)) + ltrim(rtrim(innot_seccion))=@codmatpre) and innot_codcil=@ciclo_pre and innot_codpenot=@ev1
                           ----***Primer Resultado muestra el periodo de evaluacion
                           SELECT @ev1 as codperio, @ev as eval,@periodo as periodo,@num,@proc as procesada,@tipo as tipo
                           ----***Segundo resultado muestra la informacion del docente y los horarios
						   -- select * from web_pg_innot_ingresosdenotas where innot_codemp = 3525 and innot_codcil = 116
                           select @hor = man_nomhor, @aula = aul_nombre_corto,
                                  @d = (substring(lunes + martes + miercoles + jueves + viernes + sabado + domingo,1,
                                  len(lunes + martes + miercoles + jueves + viernes + sabado + domingo) - 1) )
                           from
                           (
                                  select max(man_nomhor) man_nomhor,max(aul_nombre_corto) aul_nombre_corto,max(lunes) lunes, max(martes) martes,
                                        max(miercoles) miercoles, max(jueves) jueves, max(viernes) viernes, max(sabado) sabado, max(domingo) domingo
                                  from ( 
                                  select man_nomhor,aul_nombre_corto,dhm_codhmp,case when dhm_dia = 1 then 'Lunes-' else '' end lunes,
                                  case when dhm_dia = 2 then 'Martes-' else '' end martes,
                                  case when dhm_dia = 3 then 'Miercoles-' else '' end miercoles,
                                  case when dhm_dia = 4 then 'Jueves-' else '' end jueves,
                                  case when dhm_dia = 5 then 'Viernes-' else '' end viernes,
                                  case when dhm_dia = 6 then 'Sabado-' else '' end sabado,
                                  case when dhm_dia = 7 then 'Domingo-' else '' end domingo
                                  from pg_dhm_det_hor_hmp
                                        inner join ra_aul_aulas on aul_codigo = dhm_aula
                                        inner join ra_man_grp_hor on man_codigo = dhm_codman
                                  where dhm_codhmp = (select hmp_codigo from pg_hmp_horario_modpre inner join pg_mpr_modulo_preespecializacion on mpr_codigo = hmp_codmpr
                                                                   where mpr_visible = 'N' and (cast(hmp_codapr as nvarchar(100))+cast(hmp_descripcion as nvarchar(100))) = @codmatpre)
                           ) ab
                           ) bc


                           select @d Dias, @aula aula, @hor horas, pre_nombre +' ('+ mpr_nombre+')' materia,apr_codigo codmat, hmp_descripcion secc, emp_nombres_apellidos docente,cil_codigo from pg_hmp_horario_modpre 
                                  inner join pg_mpr_modulo_preespecializacion on mpr_codigo = hmp_codmpr
                                  inner join pg_pre_preespecializacion on pre_codigo = mpr_codpre
                                  inner join pg_apr_aut_preespecializacion on apr_codpre = pre_codigo
                                  inner join pla_emp_empleado on emp_codigo = hmp_codcat
                                  inner join ra_cil_ciclo on cil_codigo = apr_codcil
                           where  cast(hmp_codigo as nvarchar(20))=@tot --and mpr_orden = @ev
                                  --and apr_codcil = @cic
                           
                           ---***** Tercer Resultado donde muestra el listado

                           declare @tbl table(per_codigo int, per_carnet nvarchar(15), per_apellidos_nombres nvarchar(150), cuotasc int, ciclo nvarchar(20),
                                  pre_nombre nvarchar(200), hmp_descripcion nvarchar(5), estado nvarchar(25))
								  --[web_not_alumnospormateria]  117, 3525, 3, '2717MP', 1, 3
								  print '@periodo: ' + cast(@periodo as varchar(25)) +'@proc: ' + cast(@proc as varchar(25))+'@@exdif: ' + cast(@exdif as varchar(25))+'@@ordenMod: ' + cast(@ordenMod as varchar(25))+'@@@ev: ' + cast(@ev as varchar(25))
							if @ev<>0 and @periodo='Diferido' and @proc=0 and @exdif<>0 --and @ordenMod = @ev
							begin
							
			--[web_not_alumnospormateria]  117, 4083, 3, '2807MP', 1, 3
								print 'DIFERIDO'
								PRINT '@codcil:' + CAST(@cic AS NVARCHAR(15)) +' @codpre'+ CAST(@codpre AS NVARCHAR(15)) +' @ev:' +CAST(@ev AS NVARCHAR(15))
								PRINT '---------------------------------------------------'

								insert into @tbl(per_codigo , per_carnet , per_apellidos_nombres , cuotasc , ciclo,
								pre_nombre, hmp_descripcion, estado)
								exec rep_pg_list_alum_solv_insol @cic,@codpre,@seccion,@ev,'D'		--	Agregado por Fabio el 26/11/2018 para los alumnos que realizaran el examen diferido
								--rep_pg_list_alum_solv_insol 117, 597, '01', 3, 'D'
								--rep_pg_list_alum_solv_insol 117, 600, '01', 3, 'D'


								print 'rep_pg_list_alum_solv_insol: '+ cast(@cic as varchar(15)) +', '+cast(@codpre as varchar(15)) +', '+cast(@seccion as varchar(15)) +', '+cast(@ev as varchar(15)) +', D'

							end -- if @ev<>0 and @periodo='Diferido' and @proc=0 and @exdif<>0

                           if  @ev<>0 and @periodo='Ordinario' and @proc=0  --and @ordenMod = @ev
                             begin

			-- [web_not_alumnospormateria]  117, 3525, 3, '2717MP', 0, 0
			--rep_pg_list_alum_solv_insol 117, 597, 01, 1, 'S'
                                        print 'ORDINARIO'
                                        PRINT '@codcil:' + CAST(@cic AS NVARCHAR(15)) +', @codpre'+ CAST(@codpre AS NVARCHAR(15)) +', @ev:' +CAST(@ev AS NVARCHAR(15)) +', @seccion:' + @seccion
                                        PRINT '---------------------------------------------------'
                                         insert into @tbl(per_codigo , per_carnet , per_apellidos_nombres , cuotasc , ciclo,
                                        pre_nombre, hmp_descripcion, estado)
										
                                        exec rep_pg_list_alum_solv_insol @cic,@codpre,@seccion,@ev,'S'
										print 'rep_pg_list_alum_solv_insol: '+ cast(@cic as varchar(15)) +', '+cast(@codpre as varchar(15)) +', '+cast(@seccion as varchar(15)) +', '+cast(@ev as varchar(15)) +', S'

                             end -- if  @ev<>0 and @periodo='Ordinario' and @proc=0
                           select distinct per_codigo as percodigo , per_carnet as carnet , per_apellidos_nombres as nombres ,
                                  pre_nombre as mpr_nombre , @cic as cil_codigo
                           from @tbl
                           order by per_apellidos_nombres

                           --drop table #tbl
                                                                   
             end
             if @tipMod = 'ME'
             begin
                           
                           select @codmatpre=cast(hm_codigo as nvarchar(25))+hm_descripcion from pg_hm_horarios_mod where cast(hm_codigo as nvarchar(20)) = @tot

                           print '@codmatpre: '+ @codmatpre

                           select @ev1=penot_codigo,@ev=penot_eval ,@periodo=penot_periodo,@tipo=penot_tipo  
                           from --web_pg_not_penot_periodonotas  
                                  web_pg_pnme_per_not_mod_esp where((@fech>=penot_fechaini) and (@fech<=penot_fechafin)and(penot_tipo='Preespecialidad'))

                           select @proc=count(1)
                           from web_pg_innot_ingresosdenotas where innot_codemp=@emp and (ltrim(rtrim (innot_codmai)) + ltrim(rtrim(innot_seccion))=@codmatpre) --and innot_codcil=@ciclo_pre 
                                  and innot_codpenot=case when @ev >= 1 then 13 when @ev >= 2 then 14 end
                                        --@ev1
                           ----***Primer Resultado muestra el periodo de evaluacion
                           SELECT @ev1 as codperio, @ev as eval,@periodo as periodo,@num,@proc as procesada,@tipo as tipo

                           print '@ev : ' + cast(@ev as nvarchar(5))

                           select CASE WHEN Dias <> '' THEN substring(Dias,1,len(Dias)-1) ELSE Dias END Dias, aula, horas, materia, codmat, sec secc, docente, cil_codigo 
                           from (
                                  SELECT CASE WHEN hm_lunes = 'S' then 'Lunes-' else '' end + CASE WHEN hm_martes = 'S' then 'Martes-' else '' end +CASE WHEN hm_miercoles = 'S' then 'Miercoles-'  else '' end +
                                        CASE WHEN hm_jueves = 'S' then 'Jueves-' else '' end + CASE WHEN hm_viernes = 'S' then 'Viernes-'  else '' end + CASE WHEN hm_sabado = 'S' then 'Sabado-' else '' end +
                                        CASE WHEN hm_domingo = 'S' then 'Domingo-' else ''  end Dias, aul_nombre_corto aula, man_nomhor horas, 'General '+hm_nombre_mod materia, 
                                        hm_codigo  codmat, hm_descripcion sec, emp_nombres_apellidos docente, hm_codcil cil_codigo
                                  FROM pg_hm_horarios_mod 
                                        join pla_emp_empleado on emp_codigo = hm_codemp
                                        join ra_aul_aulas on aul_codigo = hm_codaul
                                        join ra_man_grp_hor on man_codigo = hm_codman
                                  WHERE cast(hm_codigo as nvarchar(20)) = @tot --and hm_codcil = @cic
                           )a


                           if  @ev<>0 and @periodo='Diferido' and @proc=0 and @exdif<>0 
                            begin
                                        select per_codigo as percodigo , per_carnet as carnet , per_apellidos_nombres as nombres ,
                                               hm_nombre_mod as mpr_nombre, hm_codcil as cil_codigo
                                        from pg_insm_inscripcion_mod 
                                               join ra_per_personas on per_codigo = insm_codper
                                               join pg_hm_horarios_mod on hm_codigo = insm_codhm
                                        where cast(hm_codigo as nvarchar(20)) = @tot --and hm_codcil = @cic 
                                        and case when hm_modulo = 9 then 1 when hm_modulo = 10 then 2 else 0 end = @ev
										order by per_apellidos_nombres
                           end


                           if  @ev<>0 and @periodo='Ordinario' and @proc=0
                           begin
                                        select per_codigo as percodigo , per_carnet as carnet , per_apellidos_nombres as nombres ,
                                               hm_nombre_mod as mpr_nombre, hm_codcil as cil_codigo
                                        from pg_insm_inscripcion_mod 
                                               join ra_per_personas on per_codigo = insm_codper
                                               join pg_hm_horarios_mod on hm_codigo = insm_codhm
                                        where cast(hm_codigo as nvarchar(20)) = @tot --and hm_codcil = @cic 
                                        and case when hm_modulo = 9 then 1 when hm_modulo = 10 then 2 else 0 end = @ev
										order by per_apellidos_nombres
                           end

             end  
   
end -- if @tip=3--Especialidad