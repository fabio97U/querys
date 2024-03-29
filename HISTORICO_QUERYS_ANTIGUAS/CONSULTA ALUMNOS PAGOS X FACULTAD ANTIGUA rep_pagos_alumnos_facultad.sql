USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_pagos_alumnos_facultad]    Script Date: 18/3/2020 15:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- rep_pagos_alumnos_facultad 88, 6

ALTER procedure [dbo].[rep_pagos_alumnos_facultad] @ciclo int, @fac int 
as

declare @facultad varchar(100),@ciclotexto varchar(20)
set @facultad = 'FACULTAD DE  ' + (select fac_nombre from ra_fac_facultades where fac_codigo = @fac)

set @ciclotexto = 'Ciclo  ' + (select(case when cast (cil_codcic as char(1))= 1 then '01'+'-'+cast (cil_anio as char(4)) 
when cast (cil_codcic as char(1))= 2 then '02'+'-'+cast (cil_anio as char(4)) 
when cast (cil_codcic as char(1))= 3 then '03'+'-'+cast (cil_anio as char(4)) else '' end) as ciclo
from ra_cil_ciclo where cil_codigo = @ciclo) 

select distinct (per_carnet), per_apellidos_nombres, per_telefono,per_celular,per_email,@facultad as Facultad,@ciclotexto as Ciclo,
       SUM(case when tmo_arancel = 'M-01' then 1 else 0 end) as Matricula,
	   SUM(case when tmo_arancel in ('C-01','C-25') then 1 else 0 end) as [1ª Cuota],
	   SUM(case when tmo_arancel in ('C-02','C-26') then 1 else 0 end) as [2ª Cuota],
       SUM(case when tmo_arancel in ('C-03','C-27') then 1 else 0 end) as [3ª Cuota],
	   SUM(case when tmo_arancel in ('C-04','C-28') then 1 else 0 end) as [4ª Cuota],
	   SUM(case when tmo_arancel in ('C-05','C-29') then 1 else 0 end) as [5ª Cuota],
	   SUM(case when tmo_arancel in ('S-38','S-39') then 1 else 0 end) as [6ª Cuota]
from
(

SELECT DISTINCT per_carnet, per_apellidos_nombres, per_telefono, per_celular, per_email, tmo_arancel
FROM ra_ins_inscripcion INNER JOIN
     ra_mai_mat_inscritas ON ins_codigo = mai_codins INNER JOIN
     ra_per_personas ON per_codigo = ins_codper INNER JOIN
     col_mov_movimientos ON per_codigo = mov_codper INNER JOIN
     col_dmo_det_mov ON mov_codigo = dmo_codmov INNER JOIN
     col_tmo_tipo_movimiento ON dmo_codtmo = tmo_codigo
WHERE (dmo_codcil = @ciclo) AND (mov_estado <> 'A') 
AND (tmo_arancel IN ('M-01', 'C-01','C-25', 'C-02', 'C-26', 'C-03', 'C-27', 'C-04', 'C-28', 'C-05', 'C-29', 'S-38', 'S-39')) 
AND (ins_codcil = @ciclo) AND (dmo_codcil = @ciclo) AND (mai_estado = 'I') 
AND (SUBSTRING(per_carnet, 1, 2)) collate SQL_Latin1_General_CP1_CI_AS 
IN (select car_identificador from ra_car_carreras where car_codfac = @fac and car_estado = 'A')
)
pagos
-- dbo.V_Pagos_Alumnos_CE 
group by per_carnet, per_apellidos_nombres, per_telefono,per_celular,per_email
order by per_carnet, [1ª Cuota]




