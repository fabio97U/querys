USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[web_ptl_Alum_solventes]    Script Date: 15/2/2020 08:38:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--	select * from ra_hpl_horarios_planificacion where hpl_codemp = 3318 and hpl_codcil = 117
--	select * from ra_hpl_horarios_planificacion where hpl_codemp = 3795 and hpl_codcil = 116
--	web_ptl_Alum_solventes 'BAS1-I','01',3318
--web_ptl_alum_solventes 'TED2-AC', '02', 4013
ALTER PROCEDURE [dbo].[web_ptl_Alum_solventes]
	@codmat varchar(12), 
	@hplsec int,
	@codemp int 
AS

--set @codmat = 'BAS1-I'
--set @hplsec = '01'
--set @codemp = 3318

set dateformat dmy

declare @ev int,
	@cuota int,
	@cuota_beca int,
	@cuota_wallmart int,
	@cuota_virtual int,
	@eval varchar(50),
	@cil_codigo int,
	@cuota_virtual_beca int
	
declare @temp_listado_autorizados table
(
	per_codigo int,
	carnet varchar(12),
	apellidos varchar(250), 
	nombres varchar(250), 
	ban_nombre varchar(50)
)


select @ev=pel_eval 
from web_ra_pel_periodo_listados  
--where ( (convert(varchar,getdate(),103))>=convert(varchar,pel_fechaini,103)) and ( (convert(varchar,getdate(),103))<=convert(varchar,pel_fechafin,103))
where (cast(getdate() as date) >= cast(pel_fechaini as date)) and (cast(getdate() as date) <= cast(pel_fechafin as date))

print '@ev : '
print @ev
print '----------'
   set @cuota=0 
   set @cuota_beca=0 
   set @cuota_wallmart=0
   set @cuota_virtual=0
   set @eval=0
   
   select @cil_codigo = cil_codigo from ra_cil_ciclo where ra_cil_ciclo.cil_vigente = 'S'
   --	set @cil_codigo = 117
  -- select * from ra_cil_ciclo
   --select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO'
   --and  spaet_codigo = 4 and are_tipoarancel = 'Men'

   declare @Aranceles_evaluar table (tmo_codigo int)


if @ev in (1)--primera
  begin
    -- set @cuota=134 --Prorroga
   --set @cuota_beca=158 
   --set @cuota_wallmart=1081
   --set @cuota_virtual=2053
   --set @cuota_virtual_beca = 2218
   set @eval='primera'
   insert into @Aranceles_evaluar (tmo_codigo)
   select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO' and are_cuota = 2 and tde_nombre = 'Pre grado'

  end
if @ev in (2)--segunda
  begin
     --set @cuota=135 --Prorroga
   --set @cuota_beca=159 
   --set @cuota_wallmart=1082
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
   --set @cuota_wallmart=1083
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
   --set @cuota_wallmart=1081
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
   --set @cuota_wallmart=1085
   --set @cuota_virtual=2057
   --set @cuota_virtual_beca = 2222
   set @eval='quinta'
   insert into @Aranceles_evaluar (tmo_codigo)
   select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO' and are_cuota = 6 and tde_nombre = 'Pre grado'
  end
 
SELECT  top 1   @eval as eval,dbo.ra_per_personas.per_carnet AS carnet,                    
                       dbo.ra_hpl_horarios_planificacion.hpl_descripcion AS secc, 
                      dbo.ra_mai_mat_inscritas.mai_codmat AS codmat, 
                      dbo.pla_emp_empleado.emp_apellidos_nombres AS empleado, dbo.ra_mat_materias.mat_nombre AS nommat, 
                      dbo.ra_esc_escuelas.esc_nombre AS escuela, dbo.ra_fac_facultades.fac_nombre AS facultad, dbo.ra_cil_ciclo.cil_codcic AS codcic, 
                      dbo.ra_cil_ciclo.cil_anio AS anio, dbo.ra_aul_aulas.aul_nombre_corto AS aula, dbo.ra_man_grp_hor.man_nomhor AS horario, 
					  ra_hpl_horarios_planificacion.hpl_lunes AS lunes, ra_hpl_horarios_planificacion.hpl_martes AS martes, 
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
	hpl_codcil = @cil_codigo and
(ra_hpl_horarios_planificacion.hpl_codmat = @codmat) AND 
                      (ra_hpl_horarios_planificacion.hpl_descripcion = @hplsec) AND (ra_hpl_horarios_planificacion.hpl_codemp = @codemp)

insert into @temp_listado_autorizados
SELECT DISTINCT per_codigo, carnet, apellidos, nombres, ban_nombre
FROM
(
	SELECT DISTINCT ra_per_personas.per_codigo, ra_per_personas.per_carnet AS carnet, ra_per_personas.per_apellidos AS apellidos, 
		ra_per_personas.per_nombres AS nombres, substring(ISNULL(ban_nombre,'UTEC'),1,10) ban_nombre
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
						  ra_aul_aulas ON ra_hpl_horarios_planificacion.hpl_codaul = ra_aul_aulas.aul_codigo left outer JOIN
						  adm_ban_bancos on ban_codigo = mov_codban 
	WHERE     --(ra_cil_ciclo.cil_vigente = 'S') AND 
	hpl_codcil = @cil_codigo and (col_mov_movimientos.mov_estado <> 'A') AND (ra_mai_mat_inscritas.mai_codmat = @codmat) AND 
						  (ra_hpl_horarios_planificacion.hpl_descripcion = @hplsec) 
						  --AND (col_tmo_tipo_movimiento.tmo_codigo = @cuota OR
						  --col_tmo_tipo_movimiento.tmo_codigo = @cuota_beca OR
						  --col_tmo_tipo_movimiento.tmo_codigo = @cuota_wallmart OR
						  --col_tmo_tipo_movimiento.tmo_codigo = @cuota_virtual)
						   AND col_tmo_tipo_movimiento.tmo_codigo in ( select are_codtmo from vst_Aranceles_x_Evaluacion 
						   where are_tipo = 'PREGRADO' and  spaet_codigo = @ev and are_tipoarancel = 'Men')
						   AND (pla_emp_empleado.emp_codigo = @codemp) AND dmo_codcil = @cil_codigo
						  and mai_estado <> 'R'
	UNION ALL
	select  per_codigo, per_carnet AS carnet,per_apellidos AS apellidos,per_nombres AS nombres,'Prórroga' ban_nombre
	from ra_per_personas join ra_ins_inscripcion on ins_codper = per_codigo
	join ra_mai_mat_inscritas on mai_codins = ins_codigo
	join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
	join ra_pra_prorroga_acad on pra_codper = per_codigo
	join ra_man_grp_hor ON hpl_codman=man_codigo
	where ins_codcil = @cil_codigo and pra_codcil = @cil_codigo-- and pra_codtmo = @cuota
	and hpl_codmat = @codmat AND hpl_descripcion = @hplsec and hpl_codemp = @codemp
	and exists  (
	/*--select tmo_codigo from @Aranceles_evaluar
	select 1 from col_mov_movimientos join col_dmo_det_mov on dmo_codmov = mov_codigo 
				where dmo_codtmo in (
				select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO'
				and  spaet_codigo = 2 and are_tipoarancel = 'Men'
				)
    and dmo_codcil = @cil_codigo and mov_codper = ins_codper
	*/

	 select 1 from ra_pra_prorroga_acad 
						   where pra_codper = ins_codper and pra_codcil = @cil_codigo and pra_codtmo in -- (@cuota,@cuota_virtual)
							(
								--select are_codtmo from vst_Aranceles_x_Evaluacion where are_tipo = 'PREGRADO' and spaet_codigo = @ev and are_tipoarancel = 'Men'
								select tmo_codigo from @Aranceles_evaluar
							)
	)
	--web_ptl_alum_solventes 'TED2-AC', '02', 4013

	and mai_estado <> 'R'

	-- and  pra_fecha<= (select convert(datetime,caa_fecha,103)+ ' '+caa_hora -- horas
	and  convert(datetime,convert(varchar,pra_fecha,103),103)<= (select convert(datetime,caa_fecha,103)-- por dias
						from web_ra_caa_calendario_acad 
						where  caa_dias=(case when isnull(hpl_lunes, 'N') = 'S' then 'L-' else '' end +
						case when isnull(hpl_martes, 'N') = 'S' then 'M-' else '' end +
						case when isnull(hpl_miercoles, 'N') = 'S' then 'Mi-' else '' end +
						case when isnull(hpl_jueves, 'N') = 'S' then 'J-' else '' end +
						case when isnull(hpl_viernes, 'N') = 'S' then 'V-' else '' end +
						case when isnull(hpl_sabado, 'N') = 'S' then 'S-' else '' end +
						case when isnull(hpl_domingo, 'N') = 'S' then 'D-' else '' end ) and caa_hora= substring(man_nomhor,1,5) and caa_evaluacion=@ev )

) T
ORDER BY T.apellidos


select carnet, apellidos,nombres,ban_nombre from @temp_listado_autorizados
union all
select distinct per_carnet AS carnet,per_apellidos AS apellidos,per_nombres AS nombres,'Autorizado' ban_nombre
from ra_aan_activar_alumno_notas
	join ra_ins_inscripcion on ins_codper = aan_codper and ins_codcil = @cil_codigo
	join ra_per_personas on per_codigo = ins_codper
	join ra_mai_mat_inscritas on mai_codins = ins_codigo
	join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
where aan_codper=ins_codper and aan_codcil=@cil_codigo and aan_periodo=@ev and hpl_codmat = @codmat and hpl_descripcion=@hplsec and 
	aan_codper not in (select per_codigo from @temp_listado_autorizados)
order by apellidos

