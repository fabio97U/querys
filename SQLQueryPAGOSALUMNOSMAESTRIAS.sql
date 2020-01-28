--554
--150
--01/06/2019 fecha termino  INS
--CUANTOS INSCRITOS CON SOLO LA MATRICULA O PAGO COMPLETO
select per_carnet, tmo_descripcion, tmo_codigo, tmo_valor, per_tipo, mov_fecha_registro, dmo_fecha_registro, 
/*tmo_descripcion ,mov_fecha_registro, dmo_fecha_registro,**/ ins_fecha, ins_fecha_creacion, ins_usuario_creacion 
from ra_ins_inscripcion, ra_per_personas, col_mov_movimientos, col_dmo_det_mov, col_tmo_tipo_movimiento 
where ins_codcil = 119 and ins_codper = per_codigo /*and per_tipo = ''*/ and per_codcil_ingreso = 119 and mov_codcil = 119 and mov_codper = per_codigo and mov_codigo = dmo_codmov and tmo_codigo = dmo_codtmo 
--and tmo_codigo in(2000, 2007) --MAESTRIAS
and tmo_codigo in(2156, 2157)--POSTRADOS
--and tmo_codigo in(2416, 2417) --CURSOS ESPECIALIZADOS
--and per_carnet = '48-0152-2019'
--and per_carnet = '43-0034-2019'
order by per_tipo desc, ins_fecha asc

select cil_codigo, '0' + (SELECT CAST(cil_codcic AS varchar) + ' - ' + CAST(cil_anio as varchar)) AS Ciclo from ra_cil_ciclo join ra_cic_ciclos on cic_codigo = cil_codcic where cil_codcic <>3 order by cil_vigente desc, cil_anio desc 
declare @codcil int = 119
declare @codmatricula int = 2000
declare @codprimera int = 2007

declare @cols nvarchar(max), @query nvarchar(max);
SET @cols = stuff((select distinct ','+QUOTENAME(tmo_descripcion) from ra_ins_inscripcion, ra_per_personas, col_mov_movimientos, col_dmo_det_mov, col_tmo_tipo_movimiento 
where ins_codcil = @codcil and ins_codper = per_codigo and per_tipo <> 'U' and per_codcil_ingreso = @codcil and mov_codcil = @codcil and 
mov_codper = per_codigo and mov_codigo = dmo_codmov and tmo_codigo = dmo_codtmo and tmo_codigo in(@codmatricula, @codprimera) for xml path(''), type).value('.', 'nvarchar(max)'), 1, 1, '');
print '@cols ' + cast(@cols as varchar(max))
SET @query = 'SELECT per_carnet, per_tipo, ins_fecha, ins_usuario_creacion, case when convert(date, matricula_, 103)  = convert(date, primera_, 103) then ''Pago el mismo dia'' else ''No pago el mismo dia'' end  as ''promocion'', matricula_, primera_,'+@cols+'from (
                 select r.per_carnet, r.per_tipo, ins_fecha, ins_usuario_creacion, tmo_descripcion as tmo_descripcion, tmo_valor as tmo_valor,
				(select top 1 dmo_fecha_registro
				from ra_ins_inscripcion, ra_per_personas, col_mov_movimientos, 
				col_dmo_det_mov, col_tmo_tipo_movimiento where ins_codcil = '+cast(@codcil as varchar(10))+' and ins_codper = per_codigo and per_tipo <> ''U'' and 
				per_codcil_ingreso = '+cast(@codcil as varchar(10))+' and mov_codcil = '+cast(@codcil as varchar(10))+' and mov_codper = per_codigo and mov_codigo = dmo_codmov and tmo_codigo = dmo_codtmo and tmo_codigo in('+cast(@codmatricula as varchar(10))+') and per_carnet = r.per_carnet) as matricula_,
				(select  top 1 dmo_fecha_registro
				from ra_ins_inscripcion, ra_per_personas, col_mov_movimientos, 
				col_dmo_det_mov, col_tmo_tipo_movimiento where ins_codcil = '+cast(@codcil as varchar(10))+' and ins_codper = per_codigo and per_tipo <> ''U'' and 
				per_codcil_ingreso = '+cast(@codcil as varchar(10))+' and mov_codcil = '+cast(@codcil as varchar(10))+' and mov_codper = per_codigo and mov_codigo = dmo_codmov and tmo_codigo = dmo_codtmo and tmo_codigo in('+cast(@codprimera as varchar(10))+') and per_carnet = r.per_carnet) as primera_

				from ra_ins_inscripcion, ra_per_personas as r, col_mov_movimientos, 
				col_dmo_det_mov, col_tmo_tipo_movimiento where ins_codcil = '+cast(@codcil as varchar(10))+' and ins_codper = per_codigo and per_tipo <> ''U'' and 
				per_codcil_ingreso = '+cast(@codcil as varchar(10))+' and mov_codcil = '+cast(@codcil as varchar(10))+' and mov_codper = per_codigo and mov_codigo = dmo_codmov and tmo_codigo = dmo_codtmo and tmo_codigo in('+cast(@codmatricula as varchar(10))+', '+cast(@codprimera as varchar(10))+') and mov_estado = ''I''
    )x pivot (count(tmo_valor) for tmo_descripcion in ('+@cols+')) p order by 3 asc';

print '@query ' + cast (@query as varchar(max))
EXECUTE (@query);

SELECT per_carnet, per_tipo, ins_fecha, ins_usuario_creacion, case when convert(date, matricula_, 103)  = convert(date, primera_, 103) then 'Pago el mismo dia' else 'No pago el mismo dia' end  as 'promocion', matricula_, primera_,[1ra Cuota Posgrado],[Matricula Posgrado]from (
                 select r.per_carnet, r.per_tipo, ins_fecha, ins_usuario_creacion, tmo_descripcion as tmo_descripcion, tmo_valor as tmo_valor,
				(select top 1 dmo_fecha_registro
				from ra_ins_inscripcion, ra_per_personas, col_mov_movimientos, 
				col_dmo_det_mov, col_tmo_tipo_movimiento where ins_codcil = 119 and ins_codper = per_codigo and per_tipo <> 'U' and 
				per_codcil_ingreso = 119 and mov_codcil = 119 and mov_codper = per_codigo and mov_codigo = dmo_codmov and tmo_codigo = dmo_codtmo and tmo_codigo in(2156) and per_carnet = r.per_carnet) as matricula_,
				(select  top 1 dmo_fecha_registro
				from ra_ins_inscripcion, ra_per_personas, col_mov_movimientos, 
				col_dmo_det_mov, col_tmo_tipo_movimiento where ins_codcil = 119 and ins_codper = per_codigo and per_tipo <> 'U' and 
				per_codcil_ingreso = 119 and mov_codcil = 119 and mov_codper = per_codigo and mov_codigo = dmo_codmov and tmo_codigo = dmo_codtmo and tmo_codigo in(2157) and per_carnet = r.per_carnet) as primera_

				from ra_ins_inscripcion, ra_per_personas as r, col_mov_movimientos, 
				col_dmo_det_mov, col_tmo_tipo_movimiento where ins_codcil = 119 and ins_codper = per_codigo and per_tipo <> 'U' and 
				per_codcil_ingreso = 119 and mov_codcil = 119 and mov_codper = per_codigo and mov_codigo = dmo_codmov and tmo_codigo = dmo_codtmo and tmo_codigo in(2156, 2157) and mov_estado = 'I'
    )x pivot (count(tmo_valor) for tmo_descripcion in ([1ra Cuota Posgrado],[Matricula Posgrado])) p order by 3 asc

select *
from ra_ins_inscripcion, ra_per_personas as r, col_mov_movimientos, 
				col_dmo_det_mov, col_tmo_tipo_movimiento where ins_codcil = 119 and ins_codper = per_codigo and per_tipo <> 'U' and 
				per_codcil_ingreso = 119 and mov_codcil = 119 and mov_codper = per_codigo and mov_codigo = dmo_codmov and tmo_codigo = dmo_codtmo and per_carnet  = '00-0038-0319'
SELECT per_carnet, per_tipo, ins_fecha, ins_usuario_creacion, tmo_descripcion, dmo_fecha_registro /*, [1ra Cuota Posgrado],[Matricula Posgrado]*/from (
                select per_carnet, per_tipo, ins_fecha, ins_usuario_creacion, tmo_descripcion as tmo_descripcion, tmo_valor as tmo_valor, dmo_fecha_registro, dmo_codtmo
				 from ra_ins_inscripcion, ra_per_personas, col_mov_movimientos, 
				 col_dmo_det_mov, col_tmo_tipo_movimiento where ins_codcil = 119 and ins_codper = per_codigo and per_tipo <> 'U' and 
				 per_codcil_ingreso = 119 and mov_codcil = 119 and mov_codper = per_codigo and mov_codigo = dmo_codmov and tmo_codigo = dmo_codtmo and tmo_codigo in(2156, 2157)
    )x/* pivot (count(tmo_valor) for tmo_descripcion in ([1ra Cuota Posgrado],[Matricula Posgrado])) p order by 3 asc*/

	select per_carnet, per_tipo, ins_fecha, ins_usuario_creacion, tmo_descripcion as tmo_descripcion, tmo_valor as tmo_valor, dmo_fecha_registro, dmo_codtmo
				 from ra_ins_inscripcion, ra_per_personas, col_mov_movimientos, 
				 col_dmo_det_mov, col_tmo_tipo_movimiento where ins_codcil = 119 and ins_codper = per_codigo and per_tipo <> 'U' and 
				 per_codcil_ingreso = 119 and mov_codcil = 119 and mov_codper = per_codigo and mov_codigo = dmo_codmov and tmo_codigo = dmo_codtmo and tmo_codigo in(2157) and per_carnet = '00-0002-0319'
				 select tde_codigo, tde_nombre as Nombre,  case when tde_estado = 1 then 'Activo' else 'Inactivo' End as Estado, tde_identificador as Identificador, tde_tipo as Tipo from ra_tde_TipoDeEstudio where tde_codigo not in(1,4,7)
				 --MAESTRIAS
				 --POSTGRADOS MAES
				 select * from aranceles_x_evaluacion, col_tmo_tipo_movimiento where  tmo_codigo = are_codtmo and are_cuota in (0,1) and are_tipo = 'POSTGRADOS MAES'



