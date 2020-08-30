declare @beca table(
    codigo int,
    numero char(1),
    descripcion varchar(50),
    tipo char(1)
)

insert into @beca (codigo,numero,descripcion,tipo)
select tmo_codigo,substring(tmo_descripcion,1,1) n,tmo_descripcion,
case substring(tmo_arancel,1,1) 
when 'C' then 'U' 
when 'S' then 'U' 
else substring(tmo_arancel,1,1) end tipo
from col_tmo_tipo_movimiento 
where tmo_codigo =604 or tmo_codigo=2051 or tmo_codigo=133 or tmo_codigo=157 or tmo_codigo=2052 or tmo_codigo=2217
or tmo_codigo=1490 or tmo_codigo=203

declare @tbl_pagos as table (codper int)

insert into @tbl_pagos
select distinct per_codigo from (
select per_codigo,count(per_codigo) conteo
       from uonline.dbo.ra_per_personas
       --join uonline.dbo.ra_ins_inscripcion on ins_codper=per_codigo
       join uonline.dbo.col_mov_movimientos on mov_codper=per_codigo
       join uonline.dbo.col_dmo_det_mov on dmo_codmov=mov_codigo
       join @beca on codigo=dmo_codtmo
       where  dmo_codcil=123 and per_tipo='U' and mov_estado<>'A' and per_tipo_ingreso not in(1,4) and per_codcil_ingreso<>123
       group by per_codigo
       having count(per_codigo)>=1
       /*Inicio azure descometarear para inscripcion*/
       union all
       --select per_codigo,ins_codcil,count(per_codigo) conteo
       select per_codigo,count(per_codigo) conteo
       from uonline.dbo.ra_per_personas
       join dbo.ra_ins_inscripcion on ins_codper=per_codigo
       join uonline.dbo.col_mov_movimientos on mov_codper=ins_codper
       join uonline.dbo.col_dmo_det_mov on dmo_codmov=mov_codigo
       join @beca on codigo=dmo_codtmo
       where ins_codcil=123 and dmo_codcil=123 and per_tipo='U' and mov_estado<>'A'
       group by per_codigo,ins_codcil
       having count(per_codigo)>=1
) t --11674
--select * from @tbl_pagos

SELECT fac, count(1) 'pagos_ra_validac', count(ins_codigo) 'inscritos' FROM (
	SELECT case when car_nombre like '%NO PRESENCIAL%' then 'VIRTUAL' else fac_nombre end fac--, count(1) 
	--case when  fac_nombre, count(1)
	, ins_codigo
	FROM @tbl_pagos
	inner join ra_per_personas on codper = per_codigo
	inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
	inner join ra_pla_planes on alc_codpla = pla_codigo
	inner join ra_car_carreras on car_codigo = pla_codcar
	inner join ra_esc_escuelas on esc_codigo = car_codesc
	inner join ra_fac_facultades on esc_codfac = fac_codigo
	left join dbo.ra_ins_inscripcion on ins_codper = per_codigo and ins_codcil = 123
) T
group by fac
order by fac

--SELECT fac, car_nombre, count(1) 'pagos_ra_validac', count(ins_codigo) 'inscritos' FROM (
--	SELECT case when car_nombre like '%NO PRESENCIAL%' then 'VIRTUAL' else fac_nombre end fac, car_nombre--, count(1) 
--	--case when  fac_nombre, count(1)
--	, ins_codigo
--	FROM @tbl_pagos
--	inner join ra_per_personas on codper = per_codigo
--	inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
--	inner join ra_pla_planes on alc_codpla = pla_codigo
--	inner join ra_car_carreras on car_codigo = pla_codcar
--	inner join ra_esc_escuelas on esc_codigo = car_codesc
--	inner join ra_fac_facultades on esc_codfac = fac_codigo
--	left join dbo.ra_ins_inscripcion on ins_codper = per_codigo and ins_codcil = 123
--) T
--group by fac, car_nombre
--order by fac, car_nombre