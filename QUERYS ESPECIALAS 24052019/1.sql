USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[web_col_art_archivo_tal]    Script Date: 24/05/2019 18:48:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--	web_col_art_archivo_tal 181324, 119, ''

--0500122014
ALTER  procedure [dbo].[web_col_art_archivo_tal]
	@codper int, 
	@ciclo int,
	@cuota varchar(50)
--set @codper= 145160
--set @ciclo= 100
--set @cuota='Matricula'

--  pre grado 145160 ciclo 100							1-- E U  1-7
--  Pre especialidad  98447 ciclo 100					2-- E U  00-9
--  Maestrias 166084  ciclo =96							3-- A M  1-7
-- Maestria proceso graduacion 137633 ciclo 93			4-- E M	0-9
-- Tecnico  151176 ciclo 100							5-- E U	1-7
-- Tecnico diseño  143527 ciclo 100						6-- E U	1-7
as 
begin
	

	declare @resul TABLE (
       [cil_codigo] [int] NULL,
       [per_codigo] [int] NOT NULL,
       [per_carnet] [varchar](50) NOT NULL,
       [carrera] [varchar](100) NULL,
       [alumno] [varchar](201) NOT NULL,
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
       [orden] [int] NULL,
       [papeleria] [numeric](3, 2) NULL,
       [portafolio] [numeric](2, 2) NOT NULL,
       [valor_m] [numeric](19, 2) NULL,
       [matricula] [numeric](18, 2) NULL,
       [ciclo] [varchar](62) NULL,
       [per_estado] [varchar](1) NOT NULL,
       [per_tipo] [int] NOT NULL,
       [Texto] [varchar](37) NULL,
       [Estado] [varchar](9) NOT NULL,
	   [are_cuota] [int] NULL
	) 

	insert into @resul (cil_codigo, per_codigo, per_carnet, carrera, alumno, fechaf, referencia, barra_f, barra, npe, barra_m_f, barra_mora, NPE_m,
	valor, fecha, fecha_v, orden, papeleria, portafolio, valor_m, matricula, ciclo, per_estado, per_tipo, Texto, Estado, are_cuota)
	select * 
		from 
		(
			select  ciclo cil_codigo,
				t.per_codigo,
				t.per_carnet, 
				t.pla_alias_carrera carrera,
				t.per_nombres_apellidos alumno,
				t.cc96 fechaf,
				t.cc8020 referencia,
				('('+c415+')'+cc415+'('+c3902+')'+cc3902+'('+c96+')'+cc96+'('+c8020+')'+cc8020) barra_f,
				t.barra barra,
				t.npe NPE,
				('('+c415m+')'+cc415m+'('+c3902m+')'+cc3902m+'('+c96m+')'+cc96m+'('+c8020m+')'+cc8020m) barra_m_f,
				t.barra_mora,
				t.npe_mora NPE_m,
				CASE WHEN LEN(t.tmo_valor)=2 THEN  t.tmo_valor+'.00' ELSE t.tmo_valor END Valor,
				convert(varchar,t.fel_fecha,103) fecha,
				convert(varchar,t.fecha_banco,103) fecha_v,
				t.fel_codigo_barra orden,
				t.papeleria papeleria,
				00.00 portafolio,
				t.tmo_valor_mora valor_m,
				t.matricula matricula,
				t.mciclo ciclo,
				p.per_estado,
				1 per_tipo,
				(case when (t.fel_codigo_barra=1 ) then 'Matricula' else cast((t.fel_codigo_barra-1) as varchar)+'a Cuota' end) Texto,
				(Case When pagos.Estado = 'Cancelado' then 'Cancelado' else 'Pendiente' end) as Estado,
				pagos.are_cuota
				from col_art_archivo_tal_mora as t inner join ra_per_personas as p on
				p.per_codigo = t.per_codigo Inner join col_tmo_tipo_movimiento as c on
				c.tmo_arancel = t.tmo_arancel
				left join
					(
						select t.tmo_arancel, mov_codper, count(mov_codigo) as cantidad, 'Cancelado' as Estado, v.are_cuota from col_mov_movimientos
							join col_dmo_det_mov on mov_codigo = dmo_codmov --and mov_codcil = dmo_codcil
							join col_tmo_tipo_movimiento r on dmo_codtmo = r.tmo_codigo 
							join col_art_archivo_tal_mora as t on t.ciclo = dmo_codcil and t.per_codigo = mov_codper --and t.tmo_arancel = r.tmo_arancel
							join vst_Aranceles_x_Evaluacion as v on --v.tmo_arancel = r.tmo_arancel
							v.are_codtmo = dmo_codtmo 
						where mov_codper = @codper and dmo_codcil = @ciclo and t.tmo_arancel = r.tmo_arancel and v.are_tipo = 'PREGRADO'
						group by t.tmo_arancel, mov_codper, v.are_cuota
					) as pagos
					on pagos.tmo_arancel = t.tmo_arancel and pagos.mov_codper = p.per_codigo
				where p.per_codigo = @codper and t.ciclo = @ciclo
		) a


	declare @pendientes table (arancel nvarchar(25), codper int, cantidad int, Estado nvarchar(25),descripcion nvarchar(150), cuota int, codcil int)

	insert into @pendientes (arancel, codper, cantidad, Estado, descripcion, cuota, codcil)
	select tmo.tmo_arancel, t.per_codigo as codper, 1 as cantidad, 
		'Pendiente' as Estado, tmo.tmo_descripcion, vst.are_cuota, t.ciclo
	from col_tmo_tipo_movimiento as tmo inner join vst_Aranceles_x_Evaluacion as vst
		on vst.tmo_arancel = tmo.tmo_arancel and vst.are_codtmo = tmo.tmo_codigo inner join col_art_archivo_tal_mora as t 
		on t.tmo_arancel = tmo.tmo_arancel inner join ra_per_personas as p 
		on p.per_codigo = t.per_codigo

	where t.per_codigo = @codper and t.ciclo = @ciclo and vst.are_tipo = 'PREGRADO'
	and are_cuota not in
	(
		select vst.are_cuota
		from col_mov_movimientos as mov inner join col_dmo_det_mov as dmo
			on dmo.dmo_codmov = mov.mov_codigo -- and dmo.dmo_codcil = mov.mov_codcil 
			inner join col_tmo_tipo_movimiento as tmo
			on tmo.tmo_codigo =  dmo.dmo_codtmo inner join vst_Aranceles_x_Evaluacion as vst
			on vst.tmo_arancel = tmo.tmo_arancel and vst.are_codtmo = tmo.tmo_codigo 
		where mov_codper = @codper and mov_codcil = @ciclo and vst.are_tipo = 'PREGRADO'		
	)
	
	update @resul set Estado = 'Cancelado' 
	where substring(texto,1,1) not in (select substring(descripcion,1,1) from @pendientes)


	if (@cuota <> '')
	begin
		select * from @resul where texto = @cuota order by orden
	end
	else
	begin
		select * from @resul order by orden
	end


	--select * 
	--into #resul
	--from 
	--(
	--	select distinct t.ciclo as cil_codigo,
	--		t.per_codigo,
	--		t.per_carnet, 
	--		t.pla_alias_carrera carrera
	--		--t.per_nombres_apellidos alumno,
	--		--t.cc96 fechaf,
	--		--t.cc8020 referencia,
	--		--('('+c415+')'+cc415+'('+c3902+')'+cc3902+'('+c96+')'+cc96+'('+c8020+')'+cc8020) barra_f,
	--		--t.barra barra,
	--		--t.npe NPE,
	--		--('('+c415m+')'+cc415m+'('+c3902m+')'+cc3902m+'('+c96m+')'+cc96m+'('+c8020m+')'+cc8020m) barra_m_f,
	--		--t.barra_mora,
	--		--t.npe_mora NPE_m,
	--		--CASE WHEN LEN(t.tmo_valor)=2 THEN  t.tmo_valor+'.00' ELSE t.tmo_valor END Valor,
	--		--convert(varchar,t.fel_fecha,103) fecha,
	--		--convert(varchar,t.fecha_banco,103) fecha_v,
	--		--t.fel_codigo_barra orden,
	--		--t.papeleria papeleria,
	--		--00.00 portafolio,
	--		--t.tmo_valor_mora valor_m,
	--		--t.matricula matricula,
	--		--t.mciclo ciclo,
	--		--p.per_estado,
	--		--1 per_tipo,
	--		--(case when (t.fel_codigo_barra=1 ) then 'Matricula' else cast((t.fel_codigo_barra-1) as varchar)+'a Cuota' end) Texto,
	--		--pagos.Estado 

	--		--(Case When pagos.Estado = 'Cancelado' then 'Cancelado' else 'Pendiente' end) as Estado
		

	--		from col_art_archivo_tal_mora as t inner join ra_per_personas as p on
	--		p.per_codigo = t.per_codigo 
	--		--Inner join col_tmo_tipo_movimiento as c on
	--		--c.tmo_arancel = t.tmo_arancel
	--		--t.ciclo = pagos.codcil
	--		left join
	--			(
	--				--select t.tmo_arancel, mov_codper, count(mov_codigo) as cantidad, 'Cancelado' as Estado from col_mov_movimientos
	--				--	join col_dmo_det_mov on mov_codigo = dmo_codmov and mov_codcil = dmo_codcil
	--				--	join col_tmo_tipo_movimiento r on dmo_codtmo = r.tmo_codigo 
	--				--	join col_art_archivo_tal_mora as t on t.ciclo = mov_codcil and t.per_codigo = mov_codper and t.tmo_arancel = r.tmo_arancel
	--				--	join vst_Aranceles_x_Evaluacion as v on v.tmo_arancel = r.tmo_arancel
	--				--where mov_codper = @codper and mov_codcil = @ciclo and t.tmo_arancel = r.tmo_arancel and v.are_tipo = 'PREGRADO'
	--				--group by t.tmo_arancel, mov_codper

	--CUOTAS PAGADAS

	--				select tmo.tmo_arancel, mov.mov_codper as codper, count(mov.mov_codigo) as cantidad, 'Cancelado' as Estado, tmo.tmo_descripcion, vst.are_cuota, mov_codcil as codcil
	--				from col_mov_movimientos as mov inner join col_dmo_det_mov as dmo
	--					on dmo.dmo_codmov = mov.mov_codigo and dmo.dmo_codcil = mov.mov_codcil inner join col_tmo_tipo_movimiento as tmo
	--					on tmo.tmo_codigo =  dmo.dmo_codtmo inner join vst_Aranceles_x_Evaluacion as vst
	--					on vst.tmo_arancel = tmo.tmo_arancel and vst.are_codtmo = tmo.tmo_codigo inner join col_art_archivo_tal_mora as t 
	--					on t.ciclo = mov.mov_codcil and t.per_codigo = mov.mov_codper
	--				where mov_codper = 180168 and mov_codcil = 119 and vst.are_tipo = 'PREGRADO'
	--				group by tmo.tmo_arancel, mov_codper, tmo.tmo_descripcion, vst.are_cuota, mov_codcil

	--CUOTAS PAGADAS

	--				union

	--				select tmo.tmo_arancel, t.per_codigo as codper, 1 as cantidad, 
	--					'Pendiente' as Estado, tmo.tmo_descripcion, vst.are_cuota, t.ciclo
	--				from col_tmo_tipo_movimiento as tmo inner join vst_Aranceles_x_Evaluacion as vst
	--					on vst.tmo_arancel = tmo.tmo_arancel and vst.are_codtmo = tmo.tmo_codigo inner join col_art_archivo_tal_mora as t 
	--					on t.tmo_arancel = tmo.tmo_arancel inner join ra_per_personas as p 
	--					on p.per_codigo = t.per_codigo

	--				where t.per_codigo = 180168 and t.ciclo = 119 and vst.are_tipo = 'PREGRADO'
	--				and are_cuota not in
	--				(
	--									select vst.are_cuota
	--				from col_mov_movimientos as mov inner join col_dmo_det_mov as dmo
	--					on dmo.dmo_codmov = mov.mov_codigo and dmo.dmo_codcil = mov.mov_codcil inner join col_tmo_tipo_movimiento as tmo
	--					on tmo.tmo_codigo =  dmo.dmo_codtmo inner join vst_Aranceles_x_Evaluacion as vst
	--					on vst.tmo_arancel = tmo.tmo_arancel and vst.are_codtmo = tmo.tmo_codigo 
	--				where mov_codper = 180168 and mov_codcil = 119 and vst.are_tipo = 'PREGRADO'
					
	--				)
	--				--group by tmo.tmo_arancel, mov_codper, tmo.tmo_descripcion, vst.are_cuota
	--				--select t.tmo_arancel, mov_codper, count(mov_codigo) as cantidad, 'Cancelado' as Estado, r.tmo_descripcion from col_mov_movimientos
	--				--	join col_dmo_det_mov on mov_codigo = dmo_codmov and mov_codcil = dmo_codcil
	--				--	join col_tmo_tipo_movimiento r on dmo_codtmo = r.tmo_codigo 
	--				--	join col_art_archivo_tal_mora as t on t.ciclo = mov_codcil and t.per_codigo = mov_codper --and t.tmo_arancel = r.tmo_arancel
	--				--	join vst_Aranceles_x_Evaluacion as v on --v.tmo_arancel = r.tmo_arancel
	--				--	v.are_codtmo = dmo_codtmo 
	--				--where mov_codper = 180168 and mov_codcil = 119  and v.are_tipo = 'PREGRADO' and t.tmo_arancel = r.tmo_arancel
	--				--group by t.tmo_arancel, mov_codper, r.tmo_descripcion
	--			) as pagos
	--			on --pagos.tmo_arancel = t.tmo_arancel and 
	--			pagos.codper = p.per_codigo 
	--		where p.per_codigo = 180168 and t.ciclo = 119	
end

