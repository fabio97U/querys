select * from adm_cead_cuentas_error_ad

select 0 fac_codigo, 'No definida' fac_nombre 
union all SELECT fac_codigo,fac_nombre
FROM ra_fac_facultades WHERE fac_codigo not in (16) order by 2

select 0 dip_codigo, ' Seleccione' dip_nombre union all select dip_codigo, dip_nombre 
from dip_dip_diplomados where dip_estado = 'A' order by 2
--select * from adm_usr_usuarios
select * from dip_dip_diplomados where dip_codfac IN (0)

alter table dip_dip_diplomados add dip_necesita_cuenta_AD bit default 0
update dip_dip_diplomados set dip_necesita_cuenta_AD = 0
alter table dip_dip_diplomados add dip_codusr_creacion int
update dip_dip_diplomados set dip_codusr_creacion = 12

declare @dip_codigo int = 1297
select * from dip_dip_diplomados where dip_codigo = @dip_codigo
--select * from ra_per_personas where per_codigo in (242350, 242407, 242413)
select * from dip_ped_personas_dip where ped_coddip = @dip_codigo 
	--union 
select * from dip_amd_alm_modulo where amd_codhrm in (
	select hrm_codigo from dip_hrm_horarios where hrm_codfea in (
		select fea_codigo from dip_fea_fechas_autorizadas 
		where fea_codmdp in (select mdp_codigo from dip_mdp_modulos_diplomado where mdp_coddip = @dip_codigo)
    )
)

select dip_codigo, dip_codofa, dip_nombre, dip_fecha_ingreso, dip_codfac, fea_estado, dip_necesita_cuenta_AD, 
	mdp_codigo, mdp_nombre, fea_codigo, fea_fecha, fea_fin, hrm_codigo, hrm_descripcion 'seccion', cil_codigo, 
	concat('0', cil_codcic, '-', cil_anio) 'ciclo', hrm_max_alm, hrm_codemp, amd_codigo, amd_usuario 'usuario_inscripcion', 
	amd_estado, amd_fecha_ingreso 'fecha_inscripcion', per_codigo, per_carnet, per_nombres, per_apellidos

	, cead_codigo, cead_estado, cead_fecha_registro, usr_codigo cead_codusr, usr_usuario
	--,(select count(1) from adm_cead_cuentas_error_ad cead where cead.cead_codper = per.per_codigo and cead.cead_estado = 'Creado') 'Creado',
	--(select count(1) from adm_cead_cuentas_error_ad cead where cead.cead_codper = per.per_codigo and cead.cead_estado = 'Eliminado') 'Eliminado'
	--cead_estado: Creado, Eliminado
from dip_mdp_modulos_diplomado
	inner join dip_fea_fechas_autorizadas on fea_codmdp = mdp_codigo
	inner join dip_hrm_horarios on fea_codigo = hrm_codfea
	inner join dip_dip_diplomados on dip_codigo = mdp_coddip
	inner join dip_ped_personas_dip on ped_coddip = dip_codigo
	inner join ra_cil_ciclo on fea_codcil = cil_codigo
	inner join ra_per_personas per on ped_codper = per_codigo
	left join adm_cead_cuentas_error_ad on cead_codper = per_codigo
	left join adm_usr_usuarios on usr_codigo = cead_codusr
	left join dip_amd_alm_modulo on amd_codhrm = hrm_codigo and amd_codfea = fea_codigo and amd_codper = per_codigo
where dip_codigo = 1307

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
where pla_codreg=@codreg 
and pla_codcil=@codcil and pla_codtpl > 14 and  pla_estado <> 'A' and pla_cierre <> 'C'
and usr_codigo = @usuario
order by pla_anio desc, pla_mes desc




USE [uonline]
GO

/****** Object:  View [dbo].[vst_inscritos_diplomados]    Script Date: 3/10/2022 09:05:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2022-09-30 11:30:46.190>
	-- Description: <Vista de los inscritos en diplomados>
	-- =============================================
	-- select * from vst_inscritos_diplomados where dip_codigo = 1307
alter view [dbo].[vst_inscritos_diplomados]
as
	select dip_codigo, dip_codofa, dip_nombre, dip_fecha_ingreso, dip_codfac, fac_nombre, fea_estado, dip_necesita_cuenta_AD, 
		mdp_codigo, mdp_nombre, fea_codigo, fea_fecha, fea_fin, hrm_codigo, hrm_descripcion 'seccion', cil_codigo, 
		concat('0', cil_codcic, '-', cil_anio) 'ciclo', hrm_max_alm, hrm_codemp, amd_codigo, amd_usuario 'usuario_inscripcion', 
		amd_estado, amd_fecha_ingreso 'fecha_inscripcion', per_codigo, per_carnet, per_nombres, per_apellidos, per_fecha_nac, per_correo_institucional

		, cead_codigo, cead_estado, cead_fecha_registro, usr_codigo cead_codusr, usr_usuario
		--,(select count(1) from adm_cead_cuentas_error_ad cead where cead.cead_codper = per.per_codigo and cead.cead_estado = 'Creado') 'Creado',
		--(select count(1) from adm_cead_cuentas_error_ad cead where cead.cead_codper = per.per_codigo and cead.cead_estado = 'Eliminado') 'Eliminado'
		--cead_estado: Creado, Eliminado
	from dip_mdp_modulos_diplomado
		inner join dip_fea_fechas_autorizadas on fea_codmdp = mdp_codigo
		inner join dip_hrm_horarios on fea_codigo = hrm_codfea
		inner join dip_dip_diplomados on dip_codigo = mdp_coddip
		inner join dip_ped_personas_dip on ped_coddip = dip_codigo
		inner join ra_cil_ciclo on fea_codcil = cil_codigo
		inner join ra_per_personas per on ped_codper = per_codigo
		left join adm_cead_cuentas_error_ad on cead_codper = per_codigo
		left join adm_usr_usuarios on usr_codigo = cead_codusr
		left join dip_amd_alm_modulo on amd_codhrm = hrm_codigo and amd_codfea = fea_codigo and amd_codper = per_codigo
		inner join ra_fac_facultades on dip_codfac = fac_codigo
GO

