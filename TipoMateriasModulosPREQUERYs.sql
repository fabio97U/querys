select * from pg_hm_horarios_mod 
inner join ra_tpm_tipo_materias on tpm_tipo_materia = hm_tpm_tipo_materia
where hm_tpm_tipo_materia = 'V'--hm_lunes = 'S' and hm_martes = 'S' and hm_miercoles = 'S' and hm_jueves = 'S' and hm_viernes = 'S' and hm_sabado = 'S' and hm_domingo = 'S'
select * from ra_tpm_tipo_materias

alter procedure [dbo].[inserta_horarios_mod] 
	-- =============================================
	-- Author:      <DESCONOCIDO>
	-- Create date: <NULL>
	-- Modify date, author: <2019-10-18 17:37:49.920, Fabio>
	-- Description: <Inserta los horarios de los modulos "comunes">
	-- =============================================
	@codcil         int, 
	@modulo         varchar(500), 
	@descripcion    varchar(10), 
	@tipo           nvarchar(2), 
	@horario        int, 
	@aula           int, 
	@capacidad      int, 
	@lunes          varchar(1), 
	@martes         varchar(1), 
	@miercoles      varchar(1), 
	@jueves         varchar(1), 
	@viernes        varchar(1), 
	@sabado         varchar(1), 
	@domingo        varchar(1), 
	@hm_max_alumnos int, 
	@hm_codemp      int, 
	@hm_modulo      int, 
	@fac_codigo     int, 
	@usuario        varchar(20)
as
begin
	begin transaction;
		declare @corr int, @lineas int, @codpla int, @ciclo int, @max_linea int;
		
		select @corr = isnull(max(hm_codigo), 0)
		from pg_hm_horarios_mod;
		insert into pg_hm_horarios_mod
		(hm_codigo, hm_nombre_mod, hm_descripcion, hm_codemp, hm_max_alumnos, hm_codman, hm_codaul,
		hm_lunes, hm_martes, hm_miercoles, hm_jueves, hm_viernes, hm_sabado, hm_domingo, hm_codcil, hm_capacidad, 
		hm_modulo, hm_codfac, hm_tpm_tipo_materia)

		select @corr + 1,  @modulo, @descripcion, @hm_codemp, @hm_max_alumnos, @horario, @aula, 
		@lunes, @martes, @miercoles, @jueves, @viernes, @sabado, @domingo, @codcil, @capacidad, 
		@hm_modulo, @fac_codigo, @tipo
	commit transaction
end

alter procedure [dbo].[actualiza_horarios_modulos_pre] 
	-- =============================================
	-- Author:      <DESCONOCIDO>
	-- Create date: <NULL>
	-- Modify date, author: <2019-10-18 17:37:49.920, Fabio>
	-- Description: <Actualiza los horarios de los modulos "comunes">
	-- =============================================
	@codigo      int, 
	@descripcion varchar(100), 
	@tipo        nvarchar(2), 
	@horario     int, 
	@aula        int, 
	@lunes       varchar(1), 
	@martes      varchar(1), 
	@miercoles   varchar(1), 
	@jueves      varchar(1), 
	@viernes     varchar(1), 
	@sabado      varchar(1), 
	@domingo     varchar(1), 
	@codemp      int, 
	@proyeccion  int, 
	@num_modulo  int, 
	@hm_pagada   int, 
	@hm_cheque   int, 
	@hm_codfac   int
as
begin
    begin transaction;
    update pg_hm_horarios_mod
    set 
        hm_descripcion = @descripcion, hm_codman = @horario, hm_codaul = @aula, 
        hm_lunes = @lunes, hm_martes = @martes, hm_miercoles = @miercoles, 
        hm_jueves = @jueves, hm_viernes = @viernes, hm_sabado = @sabado, 
        hm_domingo = @domingo, hm_max_alumnos = @proyeccion, hm_codemp = @codemp, 
        hm_modulo = @num_modulo, hm_pagada = @hm_pagada, hm_cheque = @hm_cheque,  
        hm_codfac = @hm_codfac, hm_tpm_tipo_materia = @tipo
    where hm_codigo = @codigo
    commit transaction
end

ALTER Procedure [dbo].[sp_insert_newSeccionPre]
	-- =============================================
	-- Author:      <DESCONOCIDO>
	-- Create date: <NULL>
	-- Modify date, author: <2019-10-19 10:37:49.920, Fabio>
	-- Description: <Inserta los horarios de los modulos no "comunes">
	-- =============================================
@opcion int, @hmp_codreg int, @hmp_codapr int, @hmp_codmpr int, @seccion varchar(60), @catedratico int, @capMaxAlum int, @tipo nvarchar(2)

As
Begin
	If (@opcion = 1)
	Begin
		Declare @banApr int = 0, @banCorreHmp int = 0
		Declare @correlativohmp int = (Select isnull(max(hmp_codigo),0) + 1 From pg_hmp_horario_modpre)
		
		If exists (Select 1 From pg_apr_aut_preespecializacion Where apr_codigo = @hmp_codapr)Begin Set @banApr = 1 End
		If exists (Select 1 From pg_hmp_horario_modpre Where hmp_codigo = @correlativohmp)Begin Set @banCorreHmp = 1 End

		If (@banApr = 1 and @banCorreHmp = 0)-- SI BANDERA DE codapr CAMBIA A 1 Y BANDERA codhmp PERMANECE A 0, INSERTA NUEVA SECCIÓN
		Begin
			Insert Into pg_hmp_horario_modpre 
			(hmp_codreg, hmp_codigo, hmp_codapr, hmp_codmpr, hmp_descripcion, hmp_codcat, hmp_max_alumnos, hmp_codfac, hmp_tpm_tipo_materia)
			Select @hmp_codreg, isnull(max(hmp_codigo),0) + 1, @hmp_codapr, @hmp_codmpr, @seccion, @catedratico, @capMaxAlum, 0, @tipo
			From pg_hmp_horario_modpre

			Select 'OK' as Mje
		End
		Else -- SI BANDERAS CAMBIAN DE VALOR, TIRA ALERTA DE EXISTENTE
		Begin
			Select 'NOT' as Mje
		End
	End
End


alter table pg_hmp_horario_modpre add hmp_tpm_tipo_materia nvarchar(5);
--alter table pg_hmp_horario_modpre add hm_fecharegistro datetime default getdate();

select [hmp_codigo], [hmp_descripcion], [hmp_codcat], [hmp_max_alumnos] , isnull(emp_apellidos_nombres, 'no aplica') emp_apellidos_nombres, hmp_codmpr, hmp_tpm_tipo_materia
from pg_hmp_horario_modpre
left outer join pla_emp_empleado on emp_codigo = hmp_codcat
select * from pg_hmp_horario_modpre --count(1) : 3197

select distinct cast(cic_nombre as varchar)+' - '+cast(cil_anio as varchar) cil_nombre, pre_nombre, pre_codigo, 
	mpr_codigo, mpr_codpre, apr_codigo,
	[hmp_codigo], mpr_nombre, [hmp_codcat], isnull(emp_apellidos_nombres, 'No Aplica') emp_apellidos_nombres, 
	hmp_codmpr, 
	stuff(
	(
	select concat(case dhm_dia when 1 then '-Lu' when 2 then '-Ma' when 3 then '-Mi' when 4 then '-Ju' when 5 then '-Vi' when 6 then '-Sa' when 7 then '-Do' end, '')
	from pg_apr_aut_preespecializacion
		join  pg_hmp_horario_modpre on hmp_codapr = apr_codigo
		join pg_mpr_modulo_preespecializacion on mpr_codigo = hmp_codmpr
		join ra_cil_ciclo on apr_codcil = cil_codigo
		join pg_dhm_det_hor_hmp on dhm_codhmp = hmp_codigo
		join ra_man_grp_hor on man_codigo = dhm_codman
	where apr_codpre = apr.apr_codpre and apr_codcil = apr.apr_codcil and  /*mpr_orden = 3 and*/ hmp_descripcion = '01' --and mpr_visible = 'S'
	for xml path('')
	)
	, 1, 1, '') 'dias',
	--concat(case dhm_dia when 1 then '-Lu' when 2 then '-Ma' when 3 then '-Mi' when 4 then '-Ju' when 5 then '-Vi' when 6 then '-Sa' when 7 then '-Do' end, ''), 
	hmp_tpm_tipo_materia,
	man_nomhor,aul_codigo,  aul_nombre_corto
from pg_apr_aut_preespecializacion  as apr
	join ra_cil_ciclo on cil_codigo = apr_codcil 
	join ra_cic_ciclos on cic_codigo = cil_codcic 
	join pg_pre_preespecializacion on pre_codigo = apr_codpre 
	join pg_mpr_modulo_preespecializacion on pre_codigo = mpr_codpre
	join pg_hmp_horario_modpre on mpr_codigo = hmp_codmpr
	left outer join pla_emp_empleado on emp_codigo = hmp_codcat
	join pg_dhm_det_hor_hmp on dhm_codhmp = hmp_codigo
	join ra_man_grp_hor on man_codigo = dhm_codman
	join ra_aul_aulas on aul_codigo = dhm_aula
where aul_codigo <> 160 and apr_codcil = 120

select * from pg_hmp_horario_modpre where hmp_codigo = 236
select * from pg_apr_aut_preespecializacion 
inner join pg_pre_preespecializacion on pre_codigo = apr_codpre 
inner join pg_hmp_horario_modpre on hmp_codapr = apr_codigo 
--inner join pg_dhm_det_hor_hmp on dhm_codhmp = hmp_codigo
inner join pg_mpr_modulo_preespecializacion on pre_codigo = mpr_codpre
where apr_codpre = 645

--3197
select * from pg_hmp_horario_modpre --where hmp_codapr = 561
select * from pg_hm_horarios_mod
select * from pg_pre_preespecializacion
inner join pg_mpr_modulo_preespecializacion on pre_codigo = mpr_codpre
inner join pg_apr_aut_preespecializacion on apr_codpre = pre_codigo
where pre_codigo = 645
select * from pg_hmp_horario_modpre
--435
update pg_hmp_horario_modpre set hmp_tpm_tipo_materia = 'P' where hmp_codigo in (
select distinct hmp_codigo from pg_apr_aut_preespecializacion 
	join ra_cil_ciclo on cil_codigo = apr_codcil 
	join ra_cic_ciclos on cic_codigo = cil_codcic 
	join pg_pre_preespecializacion on pre_codigo = apr_codpre 
	join pg_mpr_modulo_preespecializacion on pre_codigo = mpr_codpre
	join pg_hmp_horario_modpre on mpr_codigo = hmp_codmpr
	left outer join pla_emp_empleado on emp_codigo = hmp_codcat
	--join pg_dhm_det_hor_hmp on dhm_codhmp = hmp_codigo
	join ra_man_grp_hor on man_codigo = dhm_codman
	join ra_aul_aulas on aul_codigo = dhm_aula
where aul_codigo <> 160 --and pre_codcil = 120
)

--34
update pg_hmp_horario_modpre set hmp_tpm_tipo_materia = 'V' where hmp_codigo in (
select distinct hmp_codigo from pg_apr_aut_preespecializacion 
	join ra_cil_ciclo on cil_codigo = apr_codcil 
	join ra_cic_ciclos on cic_codigo = cil_codcic 
	join pg_pre_preespecializacion on pre_codigo = apr_codpre 
	join pg_mpr_modulo_preespecializacion on pre_codigo = mpr_codpre
	join pg_hmp_horario_modpre on mpr_codigo = hmp_codmpr
	left outer join pla_emp_empleado on emp_codigo = hmp_codcat
	join pg_dhm_det_hor_hmp on dhm_codhmp = hmp_codigo
	join ra_man_grp_hor on man_codigo = dhm_codman
	join ra_aul_aulas on aul_codigo = dhm_aula
where aul_codigo = 160--and apr_codcil = 120
)
--where hmp_codmpr = @codmpr and hmp_codapr = @codapr
select * from pg_hmp_horario_modpre where hmp_codigo = 2865


select hmp_codigo, pre_codigo,pre_nombre, mpr_codigo, mpr_nombre, hmp_descripcion from pg_pre_preespecializacion, pg_mpr_modulo_preespecializacion,pg_hmp_horario_modpre where mpr_codpre = pre_codigo and mpr_visible = 'N' and hmp_codmpr = mpr_codigo and hmp_codapr = @codapr and pre_codigo in ( select apr_codpre  from pg_apr_aut_preespecializacion  where apr_codigo = @codapr ) 

update pg_hmp_horario_modpre set hmp_tpm_tipo_materia = 'P' where isnull(hmp_tpm_tipo_materia, '0') = '0'