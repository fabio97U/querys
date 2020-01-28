USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_recibos]    Script Date: 27/11/2019 10:33:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------
--	exec rep_recibos '6017301', 'adones.calles' 
ALTER procedure [dbo].[rep_recibos] 
	@campo0 varchar(10), 
	@campo1 varchar(20) 
as
begin
    select mov_codigo, mov_recibo, 
		mov_fecha, mov_codcil, ciclo,
		pla_codcar,  dui,
		per_carnet, per_apellidos, per_nombres, substring(per_direccion,1,50) per_direccion,
		dmo_cantidad, tmo_cuenta, tmo_descripcion, afectas, exentos, usuario,
		mov_descripcion,
		total,
		total_letras,ciclo_det,
		case when mov_tipo_pago = 'B' then 'Banco' 
			when mov_tipo_pago = 'X' then 'Cuenta x Cobrar'
			when mov_tipo_pago = 'R' then 'Credito' 
			else 'Contado' 
		end tipo_pago
    from
	(
		select row_number() over (order by mov_codigo desc) row, mov_codigo, mov_recibo, 
		   mov_fecha,mov_codcil, ciclo,
		   pla_codcar,  dui,
		   per_carnet, per_apellidos, per_nombres,per_direccion,
		   dmo_cantidad, tmo_cuenta, tmo_descripcion, afectas,exentos,usuario,
		   mov_descripcion,
		   total,
		   total_letras, ciclo_det,dmo_codigo,mov_tipo_pago
		from
		(
			select mov_codigo,mov_recibo, 
			   (mov_fecha + cast(CONVERT(varchar, mov_fecha_registro, 8) as varchar)) AS mov_fecha ,
			   mov_codcil, b.cic_nombre + '-'+ cast(a.cil_anio as varchar) ciclo,
			   pla_codcar, isnull(per_dui,'') dui,
			   per_carnet, per_apellidos_nombres per_apellidos, per_nombres,per_direccion,
			   dmo_cantidad, tmo_arancel tmo_cuenta, 

			 --  case when dmo_codmat = (select mat_codigo from ra_mat_materias where mat_codigo = dmo_codmat) 
			 --  then
				--	ltrim(rtrim(tmo_descripcion)) + ': ' /*+ case when dmo_descuento > 0 then cast(dmo_descuento as varchar) + '% Desc. ' else '' end*/ 
				--   + case when tmo_afecta_materia = 'S' 
				--			then ltrim(rtrim(isnull(isnull(plm_alias,mat_nombre),'')+ ' ' + ltrim(rtrim(isnull(pon_nombre, ''))))) 
				--			else '' 
				--	end
				--else
				--	ltrim(rtrim(tmo_descripcion)) + ': ' + dbo.fx_nombre_pre_especializacion_modulo_comun(dmo_eval, dmo_codmat, dmo_codcil)
				--end
			   tmo_descripcion + ' ' /*+ case when dmo_descuento > 0 then cast(dmo_descuento as varchar) + '% Desc. ' else '' end*/ 
			   + case when tmo_afecta_materia = 'S' then isnull(isnull(plm_alias,mat_nombre),'')+ ' ' +isnull(pon_nombre, '') else '' end  
			   tmo_descripcion, 


			   case when dmo_iva = 0 then isnull((dmo_valor),0)+isnull(dmo_iva,0) else 0 end afectas, 
			   case when dmo_iva > 0 then isnull((dmo_valor),0)+isnull(dmo_iva,0) else 0 end exentos, 
			   upper(@campo1) usuario,
			   mov_descripcion,
				(
				   select sum(isnull(dmo_valor,0)+isnull(dmo_iva,0))
				   from col_dmo_det_mov
				   where dmo_codmov = mov_codigo
				) total,
				upper(dbo.fn_crufl_NumerosALetras((select sum(isnull(dmo_valor,0)+isnull(dmo_iva,0))
				   from col_dmo_det_mov
				   where dmo_codmov = mov_codigo),1)
				) total_letras,
				d.cic_nombre + '-'+ cast(c.cil_anio as varchar) ciclo_det, dmo_codigo, mov_tipo_pago
			from col_mov_movimientos
				join col_dmo_det_mov on dmo_codmov = mov_codigo
				join ra_per_personas on per_codigo = mov_codper 
				left outer join ra_alc_alumnos_carrera on alc_codper = per_codigo
				left outer join ra_pla_planes on pla_codigo = alc_codpla
				join ra_cil_ciclo a on a.cil_codigo = mov_codcil
				join ra_cic_ciclos  b on b.cic_codigo = a.cil_codcic
				join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
				left outer join ra_plm_planes_materias on plm_codpla = alc_codpla and plm_codmat = dmo_codmat
				left outer join ra_mat_materias on mat_codigo = dmo_codmat
				left outer join ra_pon_ponderacion on pon_codigo = dmo_eval
				join ra_cil_ciclo c on c.cil_codigo = dmo_codcil
				join ra_cic_ciclos  d on d.cic_codigo = c.cil_codcic
			where mov_codigo = @campo0
---and tmo_arancel <> 'c-30'
			union all

			select '','', 
			'','', '' ciclo,
			'',
			 --------------------------------------------------------------------------------- 
	         isnull((select top 1 per_dui from ra_per_personas join col_mov_movimientos on per_codigo = mov_codper where mov_codigo = @campo0),'') dui,
			'', 			
			 isnull((select top 1 per_apellidos_nombres from ra_per_personas join col_mov_movimientos on per_codigo = mov_codper where mov_codigo = @campo0),'') apellidos
            -----------------------------------------------------------------------------------------
			, '','','',
			'', '' tmo_cuenta, '', '' afectas, '' usuario,(select mov_descripcion 
			from col_mov_movimientos 
			where mov_codigo = @campo0),
			(select sum(isnull(dmo_valor,0)+isnull(dmo_iva,0))
			from col_dmo_det_mov
			where dmo_codmov = @campo0) total,
			upper(dbo.fn_crufl_NumerosALetras((select sum(isnull(dmo_valor,0)+isnull(dmo_iva,0))
			from col_dmo_det_mov
			where dmo_codmov = @campo0),1)) total_letras,'',9999999999,''
			from syscolumns
			where id = object_id('ra_per_personas')
			and (colorder - 1) <= 9
		) t
	) z
	where row <= 9
	order by dmo_codigo
end
go


USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_recibos_masivo]    Script Date: 27/11/2019 09:48:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--	exec [rep_recibos_masivo] 249666, 249666, 20
ALTER procedure [dbo].[rep_recibos_masivo] 
	-- =============================================
	-- Author:      <>
	-- Create date: <>
	-- Description: <Realiza la impresion masiva de un rango de recibos para el lote>
	-- =============================================
	@campo0 varchar(10), --recibo_del
	@campo1 varchar(10), --recibo_al
	@campo2 varchar(2)	 --lote
as
begin
	declare @recibo int
		--create table #recibos(
	declare @recibos table(
		mov_codigo int, mov_recibo int,  mov_fecha datetime, 
		mov_codcil int,  ciclo varchar(40), 
		pla_codcar int,   dui varchar(20), 
		per_carnet varchar(12),  
		per_apellidos varchar(200),   per_nombres varchar(200), 
		per_direccion varchar(300), dmo_cantidad int,  
		tmo_cuenta varchar(10),  tmo_descripcion varchar(100),  
		afectas real,exentos real, usuario varchar(20), 
		mov_descripcion varchar(100), total real, 
		total_letras varchar(100), ciclo_det varchar(40), 
		dmo_codigo int, tipo_pago varchar(40) 
	)

	declare c_mov cursor for
	select mov_codigo
	from col_mov_movimientos
	where cast(mov_recibo as int)>= cast(@campo0 as int)
	and cast(mov_recibo as int)<= cast(@campo1 as int)
	and mov_lote = @campo2
	and exists (select 1 from col_dmo_det_mov where dmo_codmov = mov_codigo)
	order by mov_recibo

	open c_mov

	fetch next from c_mov
	into @recibo
	while @@FETCH_STATUS = 0   
	begin
		print '@recibo  : ' + cast(@recibo as nvarchar(10)) 
		--insert into #recibos
		insert into @recibos (mov_codigo, mov_recibo, mov_fecha, mov_codcil, ciclo, pla_codcar, dui, per_carnet, per_apellidos, per_nombres, per_direccion, dmo_cantidad, 
		tmo_cuenta, tmo_descripcion, afectas, exentos,usuario, mov_descripcion, total, total_letras, ciclo_det, dmo_codigo, tipo_pago)
		select mov_codigo,mov_recibo, mov_fecha,mov_codcil, ciclo,
		pla_codcar, dui,
		per_carnet, per_apellidos, per_nombres,substring(per_direccion,1,50) per_direccion,
		dmo_cantidad, tmo_cuenta, tmo_descripcion, afectas,exentos,usuario,
		mov_descripcion, total, total_letras,ciclo_det,dmo_codigo,
		case when mov_tipo_pago = 'B' then 'Banco' when mov_tipo_pago = 'X' then 'Cuenta x Cobrar' else 'Contado' end tipo_pago
		from
		(
			select row_number() over (order by mov_codigo desc) row,mov_codigo,mov_recibo, 
			mov_fecha,mov_codcil, ciclo,
			pla_codcar,  dui,
			per_carnet, per_apellidos, per_nombres,per_direccion,
			dmo_cantidad, tmo_cuenta, tmo_descripcion, afectas,exentos,usuario,
			mov_descripcion,
			total,
			total_letras, ciclo_det,dmo_codigo,mov_tipo_pago
			from
			(
				select @recibo recibo,mov_codigo,mov_recibo, 
				(mov_fecha + cast(CONVERT(varchar, mov_fecha_registro, 8) as varchar)) AS mov_fecha,mov_codcil,
				--(mov_fecha+REPLACE(REPLACE(RIGHT(CONVERT(VARCHAR(25), mov_fecha_registro, 100), 7), 'AM', ' a.m.'), 'PM', ' p.m.')) as mov_fecha,mov_codcil, 
				b.cic_nombre + '-'+ cast(a.cil_anio as varchar) ciclo,
				pla_codcar, isnull(per_dui,'') dui,
				per_carnet, per_apellidos_nombres per_apellidos, per_nombres,per_direccion,
				dmo_cantidad, tmo_arancel tmo_cuenta, 
				tmo_descripcion + ' ' /*+ case when dmo_descuento > 0 then cast(dmo_descuento as varchar) + '% Desc. ' else '' end*/ 
				+ case when tmo_afecta_materia = 'S' then isnull(mat_nombre,'')+ ' ' +isnull(pon_nombre, '') else '' end  tmo_descripcion, 
				case when dmo_iva = 0 then isnull((dmo_valor),0)+isnull(dmo_iva,0) else 0 end afectas, 
				case when dmo_iva > 0 then isnull((dmo_valor),0)+isnull(dmo_iva,0) else 0 end exentos, 
				upper(@campo1) usuario,
				mov_descripcion,
				(select sum(isnull(dmo_valor,0)+isnull(dmo_iva,0))
				from col_dmo_det_mov
				where dmo_codmov = @recibo) total,
				upper(dbo.fn_crufl_NumerosALetras((select sum(isnull(dmo_valor,0)+isnull(dmo_iva,0))
				from col_dmo_det_mov
				where dmo_codmov = @recibo),1)) total_letras,
				d.cic_nombre + '-'+ cast(c.cil_anio as varchar) ciclo_det, dmo_codigo,mov_tipo_pago
				from col_mov_movimientos
				join col_dmo_det_mov on dmo_codmov = mov_codigo
				join ra_per_personas on per_codigo = mov_codper 
				left outer join ra_alc_alumnos_carrera on alc_codper = per_codigo
				left outer join ra_pla_planes on pla_codigo = alc_codpla
				join ra_cil_ciclo a on a.cil_codigo = mov_codcil
				join ra_cic_ciclos  b on b.cic_codigo = a.cil_codcic
				join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
				left outer join ra_mat_materias on mat_codigo = dmo_codmat
				left outer join ra_pon_ponderacion on pon_codigo = dmo_eval
				join ra_cil_ciclo c on c.cil_codigo = dmo_codcil
				join ra_cic_ciclos  d on d.cic_codigo = c.cil_codcic
				where mov_codigo = @recibo

				union all

				select @recibo,@recibo,(select mov_recibo 
				from col_mov_movimientos 
				where mov_codigo = @recibo), 
				'','', '' ciclo,
				'', 
				--------------------------------------------------------------------------------- 
				isnull((select top 1 per_dui from ra_per_personas join col_mov_movimientos on per_codigo = mov_codper where mov_codigo = @recibo),'') dui,
				-----------------------------------------------------------------------------------
				'', 
				isnull((select top 1 per_apellidos_nombres from ra_per_personas join col_mov_movimientos on per_codigo = mov_codper where mov_codigo = @recibo),'') apellidos
				, '','','',
				'', '' tmo_cuenta, '', '' afectas, '' usuario,(select mov_descripcion 
				from col_mov_movimientos 
				where mov_codigo = @recibo),
				(select sum(isnull(dmo_valor,0)+isnull(dmo_iva,0))
				from col_dmo_det_mov
				where dmo_codmov = @recibo) total,
				upper(dbo.fn_crufl_NumerosALetras((select sum(isnull(dmo_valor,0)+isnull(dmo_iva,0))
				from col_dmo_det_mov
				where dmo_codmov = @recibo),1)) total_letras,'',99999999,''
				from syscolumns
				where id = object_id('ra_per_personas')
				and (colorder - 1) <= 9
			) t
		) z
		where row <= 9
		fetch next from c_mov
		into @recibo
	end
	close c_mov
	deallocate c_mov
	select * from @recibos order by mov_recibo,dmo_codigo
end
go