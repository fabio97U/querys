USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[web_ptl_Alum_Insolventes]    Script Date: 15/2/2020 08:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[web_ptl_Alum_Insolventes] 'adcc-i','01',1156
--  [web_ptl_Alum_Insolventes] 'COF1-V','01',38

ALTER PROCEDURE [dbo].[web_ptl_Alum_Insolventes]
(
	@codmat varchar(12), 
	@hplsec int,
	@codemp int 
)
as
set dateformat dmy

declare @ev int,
@cuota int,
@cuota_beca int,
@cuota_virtual int,
@cuota_wallmart int,
@eval varchar(50),
@cil_codigo int,
@cuota_virtual_beca int

select @ev=pel_eval 
from web_ra_pel_periodo_listados  
--where ( (convert(varchar,getdate(),103))>=pel_fechaini) and ( (convert(varchar,getdate(),103))<=pel_fechafin)
where (cast(getdate() as date) >= cast(pel_fechaini as date)) and (cast(getdate() as date) <= cast(pel_fechafin as date))

   set @cuota=0 
   set @cuota_beca=0 
   set @cuota_virtual=0
   set @cuota_wallmart=0 
   set @eval=0

   select @cil_codigo = cil_codigo from ra_cil_ciclo where ra_cil_ciclo.cil_vigente = 'S'
   --set @cil_codigo = 117

if @ev in (1)--primera
  begin
   --set @cuota=134 
   --set @cuota_beca=158 
   --set @cuota_virtual=2053
   --set @cuota_wallmart=1081
   --set @cuota_virtual_beca = 2218 
   set @eval='primera'
  end
if @ev in (2)--segunda
  begin
   --set @cuota=135 
   --set @cuota_beca=159 
   --set @cuota_virtual=2054
   --set @cuota_wallmart=1082 
   --set @cuota_virtual_beca = 2219
   set @eval='segunda'
  end
if @ev in (3)--tercera
  begin
   --set @cuota=136 
   --set @cuota_beca=160 
   --set @cuota_virtual=2055
   --set @cuota_wallmart=1083
   --set @cuota_virtual_beca = 2220
   set @eval='tercera'
  end
if @ev in (4)--cuarta
  begin
   --set @cuota=137 
   --set @cuota_beca=161 
   --set @cuota_virtual=2056
   --set @cuota_wallmart=1081 
   --set @cuota_virtual_beca = 2221
   set @eval='cuarta'
  end
if @ev in (5)--quinta
  begin
   --set @cuota=943 
   --set @cuota_beca=944 
   --set @cuota_virtual=2057
   --set @cuota_wallmart=1085
   --set @cuota_virtual_beca = 2222
   set @eval='quinta'
  end
 
declare @solventes table
(
	carnet varchar(12),
	apellidos varchar(250), 
	nombres varchar(250)
)

SELECT  top 1   @eval as eval,dbo.ra_per_personas.per_carnet AS carnet,                    
                       dbo.ra_hpl_horarios_planificacion.hpl_descripcion AS secc, 
                      dbo.ra_mai_mat_inscritas.mai_codmat AS codmat, 
                      dbo.pla_emp_empleado.emp_apellidos_nombres AS empleado, dbo.ra_mat_materias.mat_nombre AS nommat, 
                      dbo.ra_esc_escuelas.esc_nombre AS escuela, dbo.ra_fac_facultades.fac_nombre AS facultad, dbo.ra_cil_ciclo.cil_codcic AS codcic, 
                      dbo.ra_cil_ciclo.cil_anio AS anio, dbo.ra_aul_aulas.aul_nombre_corto AS aula, dbo.ra_man_grp_hor.man_nomhor AS horario, ra_hpl_horarios_planificacion.hpl_lunes AS lunes, ra_hpl_horarios_planificacion.hpl_martes AS martes, 
                      ra_hpl_horarios_planificacion.hpl_miercoles AS miercoles, ra_hpl_horarios_planificacion.hpl_jueves AS jueves, 
                      ra_hpl_horarios_planificacion.hpl_viernes AS viernes, ra_hpl_horarios_planificacion.hpl_sabado AS sabado, 
                      ra_hpl_horarios_planificacion.hpl_domingo AS domingo
FROM           ra_fac_facultades INNER JOIN
                      ra_esc_escuelas ON ra_fac_facultades.fac_codigo = ra_esc_escuelas.esc_codfac INNER JOIN
                      ra_per_personas INNER JOIN
                      ra_ins_inscripcion ON ra_per_personas.per_codigo = ra_ins_inscripcion.ins_codper INNER JOIN
                      ra_mai_mat_inscritas ON ra_ins_inscripcion.ins_codigo = ra_mai_mat_inscritas.mai_codins INNER JOIN
                      ra_hpl_horarios_planificacion ON ra_mai_mat_inscritas.mai_codhpl = ra_hpl_horarios_planificacion.hpl_codigo INNER JOIN
                      ra_cil_ciclo ON ra_ins_inscripcion.ins_codcil = ra_cil_ciclo.cil_codigo INNER JOIN
                      ra_aul_aulas ON ra_hpl_horarios_planificacion.hpl_codaul = ra_aul_aulas.aul_codigo INNER JOIN
                      ra_man_grp_hor ON ra_hpl_horarios_planificacion.hpl_codman = ra_man_grp_hor.man_codigo INNER JOIN
                      ra_mat_materias ON ra_mai_mat_inscritas.mai_codmat = ra_mat_materias.mat_codigo ON 
                      ra_esc_escuelas.esc_codigo = ra_mat_materias.mat_codesc INNER JOIN
                      pla_emp_empleado ON ra_hpl_horarios_planificacion.hpl_codemp = pla_emp_empleado.emp_codigo
where --(ra_cil_ciclo.cil_vigente = 'S') AND 
	hpl_codcil = @cil_codigo and (ra_hpl_horarios_planificacion.hpl_codmat = @codmat) AND 
                      (ra_hpl_horarios_planificacion.hpl_descripcion = @hplsec) AND (ra_hpl_horarios_planificacion.hpl_codemp = @codemp)


insert into @solventes
SELECT DISTINCT ra_per_personas.per_carnet AS carnet, ra_per_personas.per_apellidos AS apellidos, ra_per_personas.per_nombres AS nombres
FROM         ra_ins_inscripcion INNER JOIN
                      ra_mai_mat_inscritas INNER JOIN
                      ra_mat_materias ON ra_mai_mat_inscritas.mai_codmat = ra_mat_materias.mat_codigo ON 
                      ra_ins_inscripcion.ins_codigo = ra_mai_mat_inscritas.mai_codins INNER JOIN
                      col_mov_movimientos INNER JOIN
                      col_dmo_det_mov ON col_dmo_det_mov.dmo_codmov = col_mov_movimientos.mov_codigo INNER JOIN
                      col_tmo_tipo_movimiento ON col_tmo_tipo_movimiento.tmo_codigo = col_dmo_det_mov.dmo_codtmo INNER JOIN
                      ra_per_personas ON col_mov_movimientos.mov_codper = ra_per_personas.per_codigo ON 
                      ra_ins_inscripcion.ins_codper = ra_per_personas.per_codigo INNER JOIN
                      ra_fac_facultades INNER JOIN
                      ra_esc_escuelas ON ra_fac_facultades.fac_codigo = ra_esc_escuelas.esc_codfac ON 
                      ra_mat_materias.mat_codesc = ra_esc_escuelas.esc_codigo INNER JOIN
                      ra_hpl_horarios_planificacion ON ra_mai_mat_inscritas.mai_codhpl = ra_hpl_horarios_planificacion.hpl_codigo INNER JOIN
                      pla_emp_empleado ON ra_hpl_horarios_planificacion.hpl_codemp = pla_emp_empleado.emp_codigo INNER JOIN
                      ra_cil_ciclo ON ra_ins_inscripcion.ins_codcil = ra_cil_ciclo.cil_codigo AND col_dmo_det_mov.dmo_codcil = ra_cil_ciclo.cil_codigo INNER JOIN
                      ra_man_grp_hor ON ra_hpl_horarios_planificacion.hpl_codman = ra_man_grp_hor.man_codigo INNER JOIN
                      ra_aul_aulas ON ra_hpl_horarios_planificacion.hpl_codaul = ra_aul_aulas.aul_codigo
WHERE  ---   (ra_cil_ciclo.cil_vigente = 'S') 
	hpl_codcil = @cil_codigo 
	AND (col_mov_movimientos.mov_estado <> 'A') AND (ra_mai_mat_inscritas.mai_codmat = @codmat) AND 
                      (ra_hpl_horarios_planificacion.hpl_descripcion = @hplsec) AND col_tmo_tipo_movimiento.tmo_codigo 
					  in --( @cuota, @cuota_beca,@cuota_virtual,@cuota_wallmart,@cuota_virtual_beca)
					  (select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO'
   and  spaet_codigo = @ev and are_tipoarancel = 'Men')
                      --col_tmo_tipo_movimiento.tmo_codigo = @cuota_beca OR col_tmo_tipo_movimiento.tmo_codigo = @cuota_virtual OR
                      --col_tmo_tipo_movimiento.tmo_codigo = @cuota_wallmart) 
					  AND (pla_emp_empleado.emp_codigo = @codemp) AND dmo_codcil = @cil_codigo
					  and mai_estado <> 'R'
union all 
select distinct per_carnet AS carnet,per_apellidos AS apellidos,per_nombres AS nombres--,'Autorizado' ban_nombre
from ra_aan_activar_alumno_notas
join ra_ins_inscripcion on ins_codper = aan_codper and ins_codcil = @cil_codigo
join ra_per_personas on per_codigo = ins_codper
join ra_mai_mat_inscritas on mai_codins = ins_codigo
join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
where aan_codper=ins_codper and aan_codcil=@cil_codigo and aan_periodo=@ev and hpl_codmat = @codmat and hpl_descripcion=@hplsec --and aan_codper not in (select per_codigo from @temp_listado_autorizados)
ORDER BY apellidos

--GENERA LOS INSOLVENTES
SELECT DISTINCT ra_per_personas.per_carnet AS carnet, ra_per_personas.per_apellidos AS apellidos, ra_per_personas.per_nombres AS nombres
FROM ra_ins_inscripcion INNER JOIN ra_mai_mat_inscritas INNER JOIN ra_mat_materias ON ra_mai_mat_inscritas.mai_codmat = ra_mat_materias.mat_codigo 
     ON ra_ins_inscripcion.ins_codigo = ra_mai_mat_inscritas.mai_codins 
     INNER JOIN ra_per_personas ON  ra_ins_inscripcion.ins_codper = ra_per_personas.per_codigo 
     INNER JOIN ra_fac_facultades INNER JOIN ra_esc_escuelas ON ra_fac_facultades.fac_codigo = ra_esc_escuelas.esc_codfac ON 
     ra_mat_materias.mat_codesc = ra_esc_escuelas.esc_codigo 
     INNER JOIN ra_hpl_horarios_planificacion ON ra_mai_mat_inscritas.mai_codhpl = ra_hpl_horarios_planificacion.hpl_codigo 
     INNER JOIN pla_emp_empleado ON ra_hpl_horarios_planificacion.hpl_codemp = pla_emp_empleado.emp_codigo 
     INNER JOIN ra_cil_ciclo ON ra_ins_inscripcion.ins_codcil = ra_cil_ciclo.cil_codigo 
     INNER JOIN ra_man_grp_hor ON ra_hpl_horarios_planificacion.hpl_codman = ra_man_grp_hor.man_codigo 
     INNER JOIN ra_aul_aulas ON ra_hpl_horarios_planificacion.hpl_codaul = ra_aul_aulas.aul_codigo
WHERE  (ra_cil_ciclo.cil_vigente = 'S') AND (ra_mai_mat_inscritas.mai_codmat = @codmat) AND 
       (ra_hpl_horarios_planificacion.hpl_descripcion = @hplsec) AND (pla_emp_empleado.emp_codigo = @codemp) AND hpl_codcil = @cil_codigo
         and per_carnet not in (select carnet from @solventes) and mai_estado <> 'R'
         and not exists(select 1 from ra_pra_prorroga_acad where pra_codper = ins_codper and 
		 pra_codtmo in  (select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO'
   and  spaet_codigo = @ev and are_tipoarancel = 'Men')
		 and pra_codcil = @cil_codigo
		 -- and  pra_fecha<= (select convert(datetime,caa_fecha,103)+ ' '+caa_hora -- por horas
			and  convert(datetime,convert(varchar,pra_fecha,103),103)<= (select convert(datetime,caa_fecha,103)-- por dias 
									from web_ra_caa_calendario_acad 
									where  caa_dias=(case when isnull(hpl_lunes, 'N') = 'S' then 'L-' else '' end +
									case when isnull(hpl_martes, 'N') = 'S' then 'M-' else '' end +
									case when isnull(hpl_miercoles, 'N') = 'S' then 'Mi-' else '' end +
									case when isnull(hpl_jueves, 'N') = 'S' then 'J-' else '' end +
									case when isnull(hpl_viernes, 'N') = 'S' then 'V-' else '' end +
									case when isnull(hpl_sabado, 'N') = 'S' then 'S-' else '' end +
									case when isnull(hpl_domingo, 'N') = 'S' then 'D-' else '' end ) and caa_hora= substring(man_nomhor,1,5) 
									and caa_evaluacion=@ev )
		 
		 )
ORDER BY apellidos


--drop table #solventes






