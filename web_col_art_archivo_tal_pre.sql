USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[web_col_art_archivo_tal_pre]    Script Date: 1/4/2020 21:27:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:          <Author,,Name>
-- Create date: <Create Date,,>
-- Description:     <Description,,>
-- =============================================
--select top 1 * from web_esp_estadisticas_portal
--where esp_cuenta_codigo = 'reina.granados'
--order by esp_fecha desc
----   exec web_col_art_archivo_tal_pre 164070,119, ''
----   exec web_col_art_archivo_tal_mae 165925,107, ''
--select * from ra_per_personas where per_carnet = '25-2729-2010'
--     web_col_art_archivo_tal_pre 181413, 117, ''
-- web_col_art_archivo_tal_pre 182844, 122, '3a. Cuota'
ALTER PROCEDURE [dbo].[web_col_art_archivo_tal_pre] 
        @codper int, 
        @ciclo int,
       @cuota varchar(75)
AS
BEGIN
       SET NOCOUNT ON;

       --Select * from col_art_archivo_tal_preesp_mora 
       --where per_codigo = @codper and ciclo = @ciclo
       --update col_art_archivo_tal_mae_mora set cuota_pagar = 100, cuota_pagar_mora = 110 where per_codigo = 165925 and ciclo = 107
       set dateformat dmy

		select @ciclo =	max(ciclo) 
       from col_art_archivo_tal_preesp_mora
       where per_codigo=@codper

       declare @resul TABLE (
       [cil_codigo] [int] NULL,
       [per_codigo] [int] NOT NULL,
       [per_carnet] [varchar](50) NOT NULL,
       [carrera] [varchar](100) NULL,
       [Alumno] [varchar](201) NOT NULL,
       [fechaf] [varchar](34) NULL,
       [referencia] [varchar](72) NULL,
       [barra_f] [varchar](150) NULL,
       [barra] [varchar](142) NULL,
       [NPE] [varchar](83) NULL,
       [barra_m_f] [varchar](150) NULL,
       [barra_mora] [varchar](142) NULL,
       [NPE_m] [varchar](83) NULL,
       [Valor] [numeric](20, 2) NULL,
       [fecha] [varchar](30) NULL,
       [fecha_v] [varchar](30) NULL,
       [Orden] [int] NULL,
       [papeleria] [numeric](3, 2) NULL,
       [portafolio] [numeric](2, 2) NOT NULL,
       [valor_m] [numeric](19, 2) NULL,
       [matriculo] [numeric](18, 2) NULL,
       [ciclo] [varchar](62) NULL,
       [per_estado] [varchar](1) NOT NULL,
       [per_tipo] [int] NOT NULL,
       [texto] [varchar](80) NULL,
       [Estado] [varchar](9) NOT NULL,
          --[are_cuota] [int] NULL,
          --aranceles nvarchar(25),
          cuota_pagar float, cuota_pagar_mora float
       ) 

       declare @pendientes table (arancel nvarchar(25), codper int, cantidad int, Estado nvarchar(25),descripcion nvarchar(150), cuota int, codcil int)

       insert into @pendientes (arancel, codper, cantidad, Estado, descripcion, cuota, codcil)
       select tmo.tmo_arancel, t.per_codigo as codper, 1 as cantidad, 
             'Pendiente' as Estado, tmo.tmo_descripcion, vst.are_cuota, t.ciclo
       from col_tmo_tipo_movimiento as tmo inner join vst_Aranceles_x_Evaluacion as vst
             on vst.tmo_arancel = tmo.tmo_arancel and vst.are_codtmo = tmo.tmo_codigo inner join col_art_archivo_tal_preesp_mora as t 
             on t.tmo_arancel = tmo.tmo_arancel inner join ra_per_personas as p 
             on p.per_codigo = t.per_codigo

       where t.per_codigo = @codper and t.ciclo = @ciclo and vst.are_tipo = 'PREESPECIALIDAD'
       and are_cuota not in
       (
             select vst.are_cuota
             from col_mov_movimientos as mov inner join col_dmo_det_mov as dmo
                    on dmo.dmo_codmov = mov.mov_codigo inner join col_tmo_tipo_movimiento as tmo
                    on tmo.tmo_codigo =  dmo.dmo_codtmo inner join vst_Aranceles_x_Evaluacion as vst
                    on vst.tmo_arancel = tmo.tmo_arancel and vst.are_codtmo = tmo.tmo_codigo 
             where mov_codper = @codper and dmo_codcil = @ciclo and vst.are_tipo = 'PREESPECIALIDAD' and mov.mov_estado <> 'A'       
       )

       insert into @resul (cil_codigo, per_codigo, per_carnet, carrera, alumno, /*fechaf, referencia, barra_f, */ barra, npe, /*barra_m_f, */ barra_mora, NPE_m,
       valor, fecha, fecha_v, orden, papeleria, portafolio, valor_m, matriculo, ciclo, per_estado, per_tipo, Texto, Estado,cuota_pagar, cuota_pagar_mora)
       select * 
             from 
             (
                    select  ciclo cil_codigo,
                           t.per_codigo,
                           t.per_carnet, 
                           t.pla_alias_carrera carrera,
                           t.per_nombres_apellidos alumno,
                           --t.cc96 fechaf,
                           --t.cc8020 referencia,
                           --('('+c415+')'+cc415+'('+c3902+')'+cc3902+'('+c96+')'+cc96+'('+c8020+')'+cc8020) barra_f,
                           t.barra barra,
                           t.npe NPE,
                           --('('+c415m+')'+cc415m+'('+c3902m+')'+cc3902m+'('+c96m+')'+cc96m+'('+c8020m+')'+cc8020m) barra_m_f,
                           t.barra_mora,
                           t.npe_mora NPE_m,
                           CASE WHEN LEN(t.tmo_valor)=2 THEN  t.tmo_valor+'.00' ELSE t.tmo_valor END Valor,
                           convert(varchar,t.fel_fecha,103) fecha,
                           convert(varchar,t.fel_fecha_mora,103) fecha_v,
                           t.fel_codigo_barra orden,
                           t.papeleria papeleria,
                           00.00 portafolio,
                           t.tmo_valor_mora valor_m,
                           t.matricula matricula,
                           t.mciclo ciclo,
                           p.per_estado,
                           1 per_tipo,
                           --(case when (t.fel_codigo_barra=1 ) then 'Matricula' else cast((t.fel_codigo_barra-1) as varchar)+'a Cuota' end) Texto,
                           c.tmo_descripcion texto,
                           (Case When pagos.Estado = 'Cancelado' then 'Cancelado' else 'Pendiente' end) as Estado,
                           t.tmo_valor as cuota_pagar , t.tmo_valor_mora as cuota_pagar_mora
                           from col_art_archivo_tal_preesp_mora as t inner join ra_per_personas as p on
                           p.per_codigo = t.per_codigo Inner join col_tmo_tipo_movimiento as c on
                           c.tmo_arancel = t.tmo_arancel
                           left join
                                  (
                                        select r.tmo_arancel, mov_codper codper, count(mov_codigo) as cantidad, 'Cancelado' as Estado, r.tmo_descripcion, v.are_cuota, mov_codcil 
										from col_mov_movimientos
                                               join col_dmo_det_mov on mov_codigo = dmo_codmov and mov_codcil = dmo_codcil
                                               join col_tmo_tipo_movimiento r on dmo_codtmo = r.tmo_codigo 
                                               join col_art_archivo_tal_preesp_mora as t on t.ciclo = mov_codcil and t.per_codigo = mov_codper-- and t.tmo_arancel = r.tmo_arancel
                                               join vst_Aranceles_x_Evaluacion as v on --v.tmo_arancel = r.tmo_arancel and
                                               v.are_codtmo = dmo_codtmo 
                                        where mov_codper = @codper and mov_codcil = @ciclo and v.are_tipo = 'PREESPECIALIDAD' and mov_estado <> 'A'  
                                        group by r.tmo_arancel, mov_codper, v.are_cuota, r.tmo_descripcion, mov_codcil
                                        ----
                                        union
                                        ----
                                        select arancel, codper, cantidad, Estado, descripcion, cuota, codcil from @pendientes

                                  ) as pagos
                                  on pagos.tmo_arancel = t.tmo_arancel and pagos.codper = p.per_codigo
                           where p.per_codigo = @codper and t.ciclo = @ciclo
             ) a
       --select * from @pendientes
       
       update @resul set Estado = 'Cancelado'
       where case when substring(texto,1,2) = '10' then substring(texto,1,2) else substring(texto,1,1) end not in (
             select case when substring(descripcion,1,2) = '10' then substring(descripcion,1,2) else substring(descripcion,1,1) end  from @pendientes
       )


          if (@cuota <> '')
       begin
             select * from @resul where texto like '%'+@cuota+'%' order by orden
       end
       else
       begin
             select * from @resul order by orden
       end
       --if @cuota = ''
       --begin
       --     select cil_codigo, per_codigo, per_carnet, carrera, Alumno, fechaf, referencia, barra_f, barra, NPE, barra_m_f, barra_mora, NPE_m, Valor, 
       --     convert(nvarchar,fecha,103) as fecha, convert(nvarchar,fecha_v,103) as fecha_v,
       --     Orden, papeleria, portafolio, valor_m, matriculo, ciclo, per_estado, per_tipo, texto, Estado, cuota_pagar, cuota_pagar_mora
       --     from @Tabla 
       --     where cil_codigo = @ciclo
       --     order by fechaf asc, orden desc
       --end
       --else
       --begin
       --     select cil_codigo, per_codigo, per_carnet, carrera, Alumno, fechaf, referencia, barra_f, barra, NPE, barra_m_f, barra_mora, NPE_m, Valor, 
       --     convert(nvarchar,fecha,103) as fecha, convert(nvarchar,fecha_v,103) as fecha_v,
       --     Orden, papeleria, portafolio, valor_m, matriculo, ciclo, per_estado, per_tipo, texto, Estado, cuota_pagar, cuota_pagar_mora
       --     from @Tabla where texto = @cuota order by orden
       --end
END

 

