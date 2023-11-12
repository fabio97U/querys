select * from ra_tde_TipoDeEstudio
-- drop table acb_aranceles_carga_banco
CREATE TABLE acb_aranceles_carga_banco (
	acb_codigo int primary key identity (1, 1),
	acb_codtde int,
	acb_cuota_numero int,
	acb_codtmo int,
	acb_valor float,
	acb_arancel varchar(10),
	acb_descripcion_arancel varchar(100),
	acb_codtmo_descuento int,
	acb_valor_descuento float,
	acb_arancel_descuento varchar(10),
	acb_descripcion_arancel_descuento varchar(100),
	acb_alumno_virtual int,-- 1: Es alumno virtual, 0: No es alumno virtual
	acb_extrangero_o_interno char(1),--Graduado, E: Externo, I: Interno, X: Cualquier tipo
	acb_fecha_creacion datetime default getdate()
)
-- select * from acb_aranceles_carga_banco
select * from acb_aranceles_carga_banco where acb_codtde = 1
and acb_cuota_numero = 1 and acb_extrangero_o_interno = 'E'
insert into acb_aranceles_carga_banco 
(acb_codtde, acb_cuota_numero, acb_codtmo, acb_valor, acb_arancel, acb_codtmo_descuento, acb_valor_descuento, 
acb_arancel_descuento, acb_alumno_virtual, acb_extrangero_o_interno)
values
(2, 0, 2000, 120, 'Z-01', 0, 0, '0', 0, 'I'), 
(2, 1, 2001, 150, 'Z-02', 2615, -40, 'Z-82', 0, 'I'), 
(2, 2, 2002, 150, 'Z-03', 2615, -40, 'Z-82', 0, 'I'), 
(2, 3, 2003, 150, 'Z-04', 2615, -40, 'Z-82', 0, 'I'), 
(2, 4, 2004, 150, 'Z-05', 2615, -40, 'Z-82', 0, 'I'), 
(2, 5, 2005, 150, 'Z-06', 2615, -40, 'Z-82', 0, 'I'), 
(2, 6, 2006, 150, 'Z-07', 2615, -40, 'Z-82', 0, 'I'), 

(2, 0, 2000, 120, 'Z-01', 0, 0, '0', 0, 'E'), 
(2, 1, 2007, 175, 'Z-08', 2614, -65, 'Z-81', 0, 'E'), 
(2, 2, 2008, 175, 'Z-09', 2614, -65, 'Z-82', 0, 'E'), 
(2, 3, 2009, 175, 'Z-10', 2614, -65, 'Z-83', 0, 'E'), 
(2, 4, 2010, 175, 'Z-11', 2614, -65, 'Z-84', 0, 'E'), 
(2, 5, 2011, 175, 'Z-12', 2614, -65, 'Z-85', 0, 'E'), 
(2, 6, 2012, 175, 'Z-13', 2614, -65, 'Z-86', 0, 'E'), 

(2, 0, 3286, 120, 'M-130', 0, 0, '0', 1, 'I'), 
(2, 1, 3287, 150, 'M-131', 3297, -40, 'M-143', 1, 'I'), 
(2, 2, 3288, 150, 'M-132', 3297, -40, 'M-144', 1, 'I'), 
(2, 3, 3305, 150, 'M-133', 3297, -40, 'M-145', 1, 'I'), 
(2, 4, 3289, 150, 'M-134', 3297, -40, 'M-146', 1, 'I'), 
(2, 5, 3290, 150, 'M-135', 3297, -40, 'M-147', 1, 'I'), 
(2, 6, 3306, 150, 'M-136', 3297, -40, 'M-148', 1, 'I'), 

(2, 0, 3286, 120, 'M-130', 0, 0, '0', 1, ''), 
(2, 1, 3291, 175, 'M-137', 3298, -65, 'M-144', 1, 'E'), 
(2, 2, 3292, 175, 'M-138', 3298, -65, 'M-145', 1, 'E'), 
(2, 3, 3293, 175, 'M-139', 3298, -65, 'M-146', 1, 'E'), 
(2, 4, 3294, 175, 'M-140', 3298, -65, 'M-147', 1, 'E'), 
(2, 5, 3295, 175, 'M-141', 3298, -65, 'M-148', 1, 'E'), 
(2, 6, 3296, 175, 'M-142', 3298, -65, 'M-149', 1, 'E'), 

(3, 0, 3576, 120, 'U-90', 0, 0, '0', 0, 'X'), 
(3, 1, 3577, 110, 'U-91', 0, 0, '0', 0, 'X'), 
(3, 2, 3578, 110, 'U-92', 0, 0, '0', 0, 'X'), 
(3, 3, 3579, 110, 'U-93', 0, 0, '0', 0, 'X'), 
(3, 4, 3580, 110, 'U-94', 0, 0, '0', 0, 'X'), 
(3, 5, 3581, 110, 'U-95', 0, 0, '0', 0, 'X'), 
(3, 6, 3582, 110, 'U-96', 0, 0, '0', 0, 'X'), 
(3, 7, 3583, 110, 'U-97', 0, 0, '0', 0, 'X'), 
(3, 8, 3584, 110, 'U-98', 0, 0, '0', 0, 'X'), 
(3, 9, 3585, 110, 'U-99', 0, 0, '0', 0, 'X'),

(2, 0, 3598, 140, 'M-150', 0, 0, '0', 0, 'X'), 
(2, 1, 3599, 140, 'M-151', 0, 0, '0', 0, 'X'), 
(2, 2, 3600, 140, 'M-152', 0, 0, '0', 0, 'X'), 
(2, 3, 3601, 140, 'M-153', 0, 0, '0', 0, 'X'), 
(2, 4, 3602, 140, 'M-154', 0, 0, '0', 0, 'X'), 
(2, 5, 3603, 140, 'M-155', 0, 0, '0', 0, 'X'), 
(2, 6, 3604, 140, 'M-156', 0, 0, '0', 0, 'X'), 

(3, 0, 2156, 120, 'Z-59', 0, 0, '0', 0, 'X'), 
(3, 1, 2157, 100, 'Z-60', 0, 0, '0', 0, 'X'), 
(3, 2, 2158, 100, 'Z-61', 0, 0, '0', 0, 'X'), 
(3, 3, 2159, 100, 'Z-62', 0, 0, '0', 0, 'X'), 
(3, 4, 2160, 100, 'Z-63', 0, 0, '0', 0, 'X'), 
(3, 5, 2161, 100, 'Z-64', 0, 0, '0', 0, 'X'), 
(3, 6, 2162, 100, 'Z-65', 0, 0, '0', 0, 'X'), 
(3, 7, 2163, 100, 'Z-66', 0, 0, '0', 0, 'X'), 
(3, 8, 2164, 100, 'Z-67', 0, 0, '0', 0, 'X'), 
(3, 9, 2165, 100, 'Z-68', 0, 0, '0', 0, 'X'), 

(6, 0, 2416, 75, 'M-101', 0, 0, '0', 0, 'X'), 
(6, 1, 2417, 75, 'M-102', 0, 0, '0', 0, 'X'), 
(6, 2, 2418, 75, 'M-103', 0, 0, '0', 0, 'X'), 
(6, 3, 2419, 75, 'M-104', 0, 0, '0', 0, 'X')

update acb set acb_descripcion_arancel = tmo_descripcion
from acb_aranceles_carga_banco acb
inner join col_tmo_tipo_movimiento on acb_codtmo = tmo_codigo

update acb set acb_descripcion_arancel_descuento = tmo_descripcion
from acb_aranceles_carga_banco acb
inner join col_tmo_tipo_movimiento on acb_codtmo_descuento = tmo_codigo









-----------------------------**************
select * from archivo_bancos_final where ciclo = '022021' and tipo_a in ('M')
select * from col_agar_agrupador_aranceles 
inner join col_tmo_tipo_movimiento on agar_codtmo = tmo_codigo
where agar_codtmo = 485

select ROW_NUMBER() over( order by tmo_codigo ) N,tmo_codigo,tmo_valor, * from col_tmo_tipo_movimiento
						where tmo_codigo between 2007  and 2012
select * from col_tmo_tipo_movimiento where tmo_codigo = 88

select per_tipo_graduado, * from ra_per_personas where per_tipo = 'M' order by per_codigo
select tmo_codigo, tmo_arancel, tmo_descripcion from col_tmo_tipo_movimiento where tmo_codigo between 647 and 651 union all
select tmo_codigo, tmo_arancel, tmo_descripcion from col_tmo_tipo_movimiento where tmo_codigo between 1801 and 1806 union all
select tmo_codigo, tmo_arancel, tmo_descripcion from col_tmo_tipo_movimiento where tmo_codigo between 2001 and 2006 union all
select tmo_codigo, tmo_arancel, tmo_descripcion from col_tmo_tipo_movimiento where tmo_codigo between 2007  and 2012 union all
select tmo_codigo, tmo_arancel, tmo_descripcion, tmo_valor from col_tmo_tipo_movimiento where tmo_codigo IN (2077)
select * from col_tmo_tipo_movimiento where tmo_arancel in ('Z-82', 'Z-36', 'Z-35', 'Z-81', 'Z-37')

-------------------------------------*



USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[col_inserta_carga_bancos]    Script Date: 06/12/2021 09:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:      <DESCONOCIDO>
	-- Create date: <DESCONOCIDO>
	-- Last Modify: 2019-10-30 23:28:11.271 Fabio
	-- Description: <Aplicacion de saldos de la carga paga de bancos>
	-- =============================================
	 --	exec col_inserta_carga_bancos 30/10/2019', '01/10/2019', 38, 'N', 'N', 'carlos.rivas'
ALTER procedure [dbo].[col_inserta_carga_bancos] 
	@fecha varchar(20),
	@fecha_archivo varchar(20),
	@banco int, -- codban
	@tipo_pago char(1), -- B: Barras, N: NPE
	@px char(1), -- Punto Express, S: Si, N: No
	@usuario varchar(100)
as
begin
	set dateformat dmy
	begin transaction
	begin try
	-- ***************************************************************************************************************************
	-- Declaracion de variables y pasos previos al recorrido de los pagos de los alumnos
	declare @fecha_c datetime,
		@fecha_archivo_c datetime, 
		@factura_c varchar(50), 
		@tipo char(1), 
		@banco_c int, 
		@valor money, 
		@cuota int, 
		@alumno varchar(50),
		@ciclo varchar(20), 
		@recibo varchar(50), 
		@codigo_carga varchar(50),
		@puntoxpress int,
		@tipo_a varchar(2)

	declare cPagos cursor for
		select fecha, fecha_archivo, factura, tipo, banco, valor, cuota, alumno, ciclo, recibo, codigo_carga, puntoxpress,tipo_a
		from archivo_bancos_final 
		where banco = @banco 
		and puntoxpress = case when @px = 'N' then 0 when @px = 'S' then 1 end
		and convert(varchar(20),fecha,103) = @fecha
		and convert(varchar(20),fecha_archivo,103) = @fecha_archivo
		and tipo = @tipo_pago
		and estado = 0

	-- Variables parte del proceso
	declare @matricula_normal money,
	@matricula_normal_virtual money,
	@matricula_preespecialidad money,
	@matricula_proc_tecnico money,
	-- Agrego
	@matricula_pg_maestria money,
	@matricula_maestria money,
	@matricula_postgrado money,
	--
	@lote varchar(10),
	@corr int,
	@cil_codigo int,
	@codper int,
	@descripcion varchar(50),
	@mora char(1),
	@codigo_mora int,
	@codigo_arancel int,
	@valor_cuota money, 
	@valor_mora money,
	@corr_det int,
	@codigo_papeleria int,
	@valor_papeleria money,
	@saldo_alumno money,
	@codigo_cuota_alumnos int,
	@contador int,
	@total_procesado money,
	@valor_arancel_extra money,
	@codigo_arancel_extra int

	set @codigo_mora = 88
	set @codigo_cuota_alumnos = 162
	set @contador = 0
	set @total_procesado = 0

	select @lote = tit_lote from col_tit_tiraje where tit_tpodoc = 'F'
	and tit_mes = month(@fecha) and tit_anio = year(@fecha) and tit_codreg = 1 and tit_estado = 1

	-- Matricula Pregrado
	select @matricula_normal = (tmo_valor)
	from col_agar_agrupador_aranceles join col_tmo_tipo_movimiento on agar_codtmo = tmo_codigo
	where agar_codtmo = 604

	-- Matricula Pregrado Virtuales
	select @matricula_normal_virtual = (tmo_valor)
	from col_agar_agrupador_aranceles join col_tmo_tipo_movimiento on agar_codtmo = tmo_codigo
	where agar_codtmo = 2051

	-- Matricula Pre-especialidad
	select @matricula_preespecialidad = (tmo_valor + 
				(select tmo_valor from col_tmo_tipo_movimiento where tmo_codigo = agar_papeleria))
	from col_agar_agrupador_aranceles join col_tmo_tipo_movimiento on agar_codtmo = tmo_codigo
	where agar_codtmo = 485

	-- Maticula Tecnico proceso de graduacion
	select @matricula_proc_tecnico =tmo_valor
				 --(tmo_valor + 
				---(select tmo_valor from col_tmo_tipo_movimiento where tmo_codigo = agar_papeleria))
	from col_agar_agrupador_aranceles join col_tmo_tipo_movimiento on agar_codtmo = tmo_codigo
	where agar_codtmo = 555

	-- Agrego
	-- Matricula Maestrias Internos- Externos
	select @matricula_maestria = (tmo_valor + (select tmo_valor from col_tmo_tipo_movimiento where tmo_codigo = agar_papeleria))
	from col_agar_agrupador_aranceles join col_tmo_tipo_movimiento on agar_codtmo = tmo_codigo
	where agar_codtmo = 646

	-- Matricula Proceso de Graduacion Maestrias 
	select @matricula_pg_maestria = (tmo_valor +  (select tmo_valor from col_tmo_tipo_movimiento where tmo_codigo = agar_papeleria))
	from col_agar_agrupador_aranceles join col_tmo_tipo_movimiento on agar_codtmo = tmo_codigo
	where agar_codtmo =849

	--Matricula de Post grados
	select @matricula_postgrado= (tmo_valor)
	from col_agar_agrupador_aranceles join col_tmo_tipo_movimiento on agar_codtmo = tmo_codigo
	where agar_codtmo =2156

	-- ***************************************************************************************************************************
	open cPagos
	fetch cPagos into @fecha_c, @fecha_archivo_c, @factura_c, @tipo, @banco_c, @valor, @cuota, @alumno, @ciclo, @recibo, @codigo_carga ,@puntoxpress,@tipo_a
	while (@@fetch_STATUS = 0 )
	begin
		set @total_procesado = @total_procesado + @valor
		set @contador = @contador + 1
		-- ***************************************************************************************************************************
		-- Se guarda el encabezado
		print '******************************************************************'
		print @factura_c + ' ' + cast(@valor as varchar(10)) + ' ' + @alumno
		print 'Encabezado guardado'
      
		-- Correlativo de movimiento
		select @corr = isnull(max(mov_codigo),0) + 1 from col_mov_movimientos
      
		-- Codigo del ciclo
		select @cil_codigo = cil_codigo
		from ra_cil_ciclo join ra_cic_ciclos on cil_codcic = cic_codigo
		where concat('0', cast(cic_orden as varchar(10)), cast(cil_anio as varchar(20))) = @ciclo
      
		-- Codigo de alumno
		select @codper = per_codigo from ra_per_personas
		where per_carnet = substring(@alumno, 1, 2)+'-'+substring(@alumno, 3, 4)+'-'+substring(@alumno, 7, 4)
      
		select @descripcion = (case when @tipo_pago = 'B' then 'Banco (barras)' when @tipo_pago = 'N' then 'Banco (NPE)' end)
      
		-- Se guarda el encabezado
		insert into col_mov_movimientos(mov_codreg,mov_codigo,mov_recibo,mov_codcil,
		mov_fecha,mov_codper,mov_descripcion, mov_tipo_pago,mov_cheque, mov_estado,
		mov_tarjeta, mov_usuario, mov_fecha_registro,mov_codmod, mov_tipo, mov_historia, mov_codban,
		mov_forma_pago,mov_coddip,mov_codmdp,mov_codfea, mov_lote,mov_fecha_cobro,mov_puntoxpress,mov_recibo_puntoxpress, mov_fecha_real_pago)
		values(1, @corr, @factura_c, @cil_codigo, @fecha_c, @codper,@descripcion, 
		'B','','R','',@usuario,getdate(),0,'F','N',@banco,'E', '', '', '',@lote,@fecha_archivo_c,
		case when @puntoxpress = 1 then @puntoxpress when @puntoxpress = 0 then null end,
		case when @puntoxpress = 1 then @recibo when @puntoxpress = 0 then null end, @fecha_archivo_c)

		-- ***************************************************************************************************************************
		-- Se guardan los detalle del pago de los alumnos    
		-- se verifica si es pago de matricula Pregrado o Preespecialidad
		if (@cuota = 0 and @tipo_a = 'M') or 
			(@cuota=0 or @cuota = 1 and @tipo_a <> 'M') and  
			(@valor = @matricula_normal 
			or @valor =@matricula_normal_virtual
			or @valor = @matricula_preespecialidad 
			or @valor = @matricula_proc_tecnico
			or @valor = @matricula_maestria
			or @valor = @matricula_pg_maestria
			or @valor = @matricula_postgrado)
		begin
			select	
			@codigo_arancel=tmo_codigo,
			@valor_cuota=tmo_valor,
			@codigo_papeleria= agar_papeleria,
			@valor_papeleria= (case when (select tmo_valor from col_tmo_tipo_movimiento where tmo_codigo=agar_papeleria)>0 then (select tmo_valor from col_tmo_tipo_movimiento where tmo_codigo = agar_papeleria) else 0 end )							  

			from col_agar_agrupador_aranceles join col_tmo_tipo_movimiento on agar_codtmo = tmo_codigo
			where ((tmo_valor+isnull((select tmo_valor 
										from col_tmo_tipo_movimiento 
										where tmo_codigo = agar_papeleria),0)) = @valor or agar_valormora = @valor ) 
				and agar_orden_npe = @cuota and agar_tipo=@tipo_a
				-- Saldo
				if @cuota = 0 and @valor = @matricula_preespecialidad
				begin
						set @saldo_alumno = dbo.fn_verifica_saldo_preespecialidad(@alumno)
				end
				else if @cuota = 1 and (@valor = @matricula_normal or @valor =@matricula_normal_virtual)
				begin
						--set @saldo_alumno = dbo.fn_verifica_saldo_pregrado(@alumno)
						--Existen 2 tipos de saldos de los alumnos tipo pregrado
						select @saldo_alumno=vac_saldoalum from ra_vac_valor_cuotas where vac_valormatricula=@valor
				end
				else if @cuota = 1 and @valor = @matricula_proc_tecnico
				begin
						set @saldo_alumno = dbo.fn_verifica_saldo_tecnico(@alumno)
				end
				else if @cuota = 0 and @valor = @matricula_maestria
				begin
						select @saldo_alumno= case when isnull(per_tipo_graduado,'I')='E' then 825.75 else    705.75 end  from ra_per_personas where per_carnet=substring(@alumno,1,2)+'-'+substring(@alumno,3,4)+'-'+substring(@alumno,7,4)
				end
				else if @cuota = 1 and @valor = @matricula_pg_maestria
				begin
						select @saldo_alumno= case when isnull(per_tipo_graduado,'I')='E' then 1025.75 else  1205.75 end  from ra_per_personas where per_carnet=substring(@alumno,1,2)+'-'+substring(@alumno,3,4)+'-'+substring(@alumno,7,4)
				end
				else if @cuota = 1 and @valor = @matricula_postgrado
				begin
						-- select @saldo_alumno= case when isnull(per_tipo_graduado,'I')='E' then 1025.75 else  1205.75 end  from ra_per_personas where per_carnet=substring(@alumno,1,2)+'-'+substring(@alumno,3,4)+'-'+substring(@alumno,7,4)
						select @saldo_alumno=vac_saldoalum from ra_vac_valor_cuotas where vac_valormatricula=@valor and vac_codcar=substring(@alumno,1,2)
				end
            
				select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov
				print 'Saldo '
				print @codigo_cuota_alumnos
				print @saldo_alumno 

				insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo,
						dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
						dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
				values(1,@corr, @corr_det, @codigo_cuota_alumnos, 1, 0.0, '', 0,
						getdate(), 0, 0, @cil_codigo,@saldo_alumno,0,0)
                  
				-- Actualizamos el saldo del alumno
				--exec col_insert_dmo_saldo @codper,@saldo_alumno,0
            
				-- Matricula
				select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov
				print 'Matricula '
				insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo,
						dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
						dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
				values(1,@corr, @corr_det, @codigo_arancel, 1, @valor_cuota, '', 0,
						getdate(), 0, 0, @cil_codigo,0,@valor_cuota,0)

				-- Actualizamos el saldo del alumno
				--exec col_insert_dmo_saldo @codper,0,@valor_papeleria
		end
		else
		begin 
		if @tipo_a = 'M' -- Es alumno de maestrias
		begin
			declare @per_tipo_graduado varchar(50), @beca_maes_valor money, @beca_maes_codigo int

			select @per_tipo_graduado = per_tipo_graduado from ra_per_personas where per_codigo = @codper

			if @per_tipo_graduado = 'E' -- Pago $175, NO SON GRADUADOS UTEC
			begin
				select @codigo_arancel = tmo_Codigo,
				@valor_cuota = tmo_valor,
				@valor_mora = (select c.tmo_valor from col_tmo_tipo_movimiento c where c.tmo_codigo = 88),
				@valor_arancel_extra = 0,
				@codigo_arancel_extra = 0 from (
					select ROW_NUMBER() over(order by tmo_codigo) N,tmo_codigo,tmo_valor from col_tmo_tipo_movimiento
					where tmo_codigo between 2007  and 2012
				) t 
				where n = @cuota

				select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov
				print 'Pago de cuota'

				select @beca_maes_codigo=tmo_Codigo, @beca_maes_valor = tmo_valor
				from (
					select ROW_NUMBER() over( order by tmo_codigo ) N,tmo_codigo,tmo_valor from col_tmo_tipo_movimiento
					where tmo_codigo = 2077
				) t

				insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo,
				dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
				dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
				values(1,@corr, @corr_det, @codigo_arancel, 1, @valor_cuota, '', 0,
				getdate(), 0, 0, @cil_codigo,0,@valor_cuota,0)

				if exists (
					select 1 from col_art_archivo_tal_mae_mora where per_codigo = @codper and ciclo = @cil_codigo 
					and tmo_arancel = (select tmo_arancel from col_tmo_tipo_movimiento where tmo_codigo = @codigo_arancel) 
					and cuota_pagar_mora <> @valor and convert(date,fel_fecha) < convert(date,@fecha_archivo_c)
				)
				begin
					select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov

					insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo,
					dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
					dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
					values(1,@corr, @corr_det, 88, 1, 0, '', 0,
					getdate(), 0, 0, @cil_codigo,10,0,0)
				end
				--BECA -75
				select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov
				print 'Pago de cuota'

				insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo,
				dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
				dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
				values(1,@corr, @corr_det, @beca_maes_codigo, 1, @beca_maes_valor, '', 0,
				getdate(), 0, 0, @cil_codigo,@beca_maes_valor,@beca_maes_valor,0)
			
			end
			
			if @per_tipo_graduado='I'  -- Pago $150, SON GRADUADOS UTEC
			begin
				select @codigo_arancel = tmo_Codigo,
				@valor_cuota = tmo_valor,
				@valor_mora = (select c.tmo_valor from col_tmo_tipo_movimiento c where c.tmo_codigo = 88),
				@valor_arancel_extra = 0,
				@codigo_arancel_extra = 0 from (
					select ROW_NUMBER() over( order by tmo_codigo ) N,tmo_codigo,tmo_valor from col_tmo_tipo_movimiento
					where tmo_codigo between 2001 and 2006
				) t
				where n = @cuota


				select @beca_maes_codigo = tmo_Codigo,
				@beca_maes_valor = tmo_valor
				from (
					select ROW_NUMBER() over( order by tmo_codigo ) N,tmo_codigo,tmo_valor from col_tmo_tipo_movimiento
					where tmo_codigo = 2614--2076 ANTIGUO
				) t

				select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov
				print 'Pago de cuota'

				insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo,
				dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
				dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
				values(1,@corr, @corr_det, @codigo_arancel, 1, @valor_cuota, '', 0,
				getdate(), 0, 0, @cil_codigo,0,(@valor_cuota),0)

				if exists (
					select 1 from col_art_archivo_tal_mae_mora where per_codigo = @codper and ciclo = @cil_codigo 
					and tmo_arancel = (select tmo_arancel from col_tmo_tipo_movimiento where tmo_codigo = @codigo_arancel) 
					and cuota_pagar_mora <> @valor and convert(date,fel_fecha) < convert(date,@fecha_archivo_c)
				)
				begin
					select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov

					insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo,
					dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
					dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
					values(1,@corr, @corr_det, 88, 1, 0, '', 0,
					getdate(), 0, 0, @cil_codigo,10,0,0)
				end

				--BECA -50
				select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov
				print 'Pago de cuota'

				insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo,
				dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
				dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
				values(1,@corr, @corr_det, @beca_maes_codigo, 1, @beca_maes_valor, '', 0,
				getdate(), 0, 0, @cil_codigo,@beca_maes_valor,@beca_maes_valor,0)

			end

			-- Actualizamos el saldo del alumno
			--exec col_insert_dmo_saldo @codper,0,@valor_cuota
            
			-- Registramos el arancel extra cobrado en una cuota si existe
			if @valor_arancel_extra > 0 and @codigo_arancel_extra <> 0
			begin
				-- Se agrega el cargo si existe
				select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov
				print 'Se agrega el arancel extra'
				insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo,
				dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
				dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
				values(1,@corr, @corr_det, @codigo_arancel_extra, 1, @valor_arancel_extra, '', 0,
				getdate(), 0, 0, @cil_codigo,0,@valor_arancel_extra,0)
                  
				-- Actualizamos el saldo del alumno
				--exec col_insert_dmo_saldo @codper,@valor_mora,@valor_mora
			end
            
			--set @mora = dbo.fn_verifica_mora_cuota_alumno(@valor, @cuota,@tipo_a)
			if @valor = 110 
			begin
				-- Se agrega el cargo si existe
				select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov
				print 'Se agrega el alrancel de recargo'
				insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo,
				dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
				dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
				values(1,@corr, @corr_det, @codigo_mora, 1, @valor_mora, '', 0,
				getdate(), 0, 0, @cil_codigo,@valor_mora,@valor_mora,0)
				-- Actualizamos el saldo del alumno
				--exec col_insert_dmo_saldo @codper,@valor_mora,@valor_mora
			end
		end

		else if @tipo_a='O'
			begin
				--VERIFICANDO SI A PAGADO LA 1,2,3 cuota
				 if @cuota=2 and exists(select 1 from col_mov_movimientos
				 join col_dmo_det_mov on dmo_codmov=mov_codigo
				 where dmo_codtmo=2157 and mov_codper=@codper and dmo_codcil=@cil_codigo)
				 begin 
					set @cuota=10
				 end
				 if @cuota=3 and exists(select 1 from col_mov_movimientos
				 join col_dmo_det_mov on dmo_codmov=mov_codigo
				 where dmo_codtmo=2158 and mov_codper=@codper and dmo_codcil=@cil_codigo)
				 begin 
					set @cuota=11
				 end
				 if @cuota=4 and exists(select 1 from col_mov_movimientos
				 join col_dmo_det_mov on dmo_codmov=mov_codigo
				 where dmo_codtmo=2159 and mov_codper=@codper and dmo_codcil=@cil_codigo)
				 begin 
					set @cuota=12
				 end
			 
				-- se procesa cuota normal
				-- Se extrae el codigo del arancel y el valor
				select      @codigo_arancel = a.agar_codtmo, 
							@valor_cuota = b.tmo_valor ,
							@valor_mora = (select c.tmo_valor from col_tmo_tipo_movimiento c where c.tmo_codigo = @codigo_mora),
							-- Añadimos el portafolio de los tecnicos o otro aracel que se cobre con la cuota adicionalmente
							@valor_arancel_extra = (isnull((select d.tmo_valor from col_tmo_tipo_movimiento d where d.tmo_codigo = a.agar_papeleria),0)),-- Valor arancel extra
							@codigo_arancel_extra = a.agar_papeleria -- Codigo Arancel Extra
											--
				from col_agar_agrupador_aranceles a join col_tmo_tipo_movimiento b on agar_codtmo = tmo_codigo
				where ((tmo_valor + isnull((select tmo_valor from col_tmo_tipo_movimiento where tmo_codigo = agar_papeleria),0)) = @valor or agar_valormora = @valor ) and
				 agar_orden_npe = @cuota and agar_tipo=@tipo_a 
            
				select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov
				print 'Pago de cuota'

				insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo,
					  dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
					  dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
				values(1,@corr, @corr_det, @codigo_arancel, 1, @valor_cuota, '', 0,
					  getdate(), 0, 0, @cil_codigo,0,@valor_cuota,0)
            
				-- Actualizamos el saldo del alumno
				--exec col_insert_dmo_saldo @codper,0,@valor_cuota
            
				-- Registramos el arancel extra cobrado en una cuota si existe
				if @valor_arancel_extra > 0 and @codigo_arancel_extra <> 0
				begin
					  -- Se agrega el cargo si existe
					  select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov
					  print 'Se agrega el alrancel extra'
					  insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo,
							dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
							dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
					  values(1,@corr, @corr_det, @codigo_arancel_extra, 1, @valor_arancel_extra, '', 0,
							getdate(), 0, 0, @cil_codigo,0,@valor_arancel_extra,0)
					  -- Actualizamos el saldo del alumno
					  --exec col_insert_dmo_saldo @codper,@valor_mora,@valor_mora
                  
				end
				set @mora = dbo.fn_verifica_mora_cuota_alumno(@valor, @cuota,@tipo_a)
				if @mora = 'S'
				begin
					  -- Se agrega el cargo si existe
					  select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov
					  print 'Se agrega el alrancel de recargo'
					  insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo,
							dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
							dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
					  values(1,@corr, @corr_det, @codigo_mora, 1, @valor_mora, '', 0,
							getdate(), 0, 0, @cil_codigo,@valor_mora,@valor_mora,0)
                  
					  -- Actualizamos el saldo del alumno
					  --exec col_insert_dmo_saldo @codper,@valor_mora,@valor_mora
				end
			end
			else 
			begin 
				--AGREGADO MACR 2015
		 
				-- se procesa cuota normal
				-- Se extrae el codigo del arancel y el valor
				select      @codigo_arancel = a.agar_codtmo, 
							@valor_cuota = b.tmo_valor ,
							@valor_mora = (select c.tmo_valor from col_tmo_tipo_movimiento c where c.tmo_codigo = @codigo_mora),
							-- Añadimos el portafolio de los tecnicos o otro aracel que se cobre con la cuota adicionalmente
							@valor_arancel_extra = (isnull((select d.tmo_valor from col_tmo_tipo_movimiento d where d.tmo_codigo = a.agar_papeleria),0)),-- Valor arancel extra
							@codigo_arancel_extra = a.agar_papeleria -- Codigo Arancel Extra
											--
				from col_agar_agrupador_aranceles a join col_tmo_tipo_movimiento b on agar_codtmo = tmo_codigo
				where ((tmo_valor + isnull((select tmo_valor from col_tmo_tipo_movimiento where tmo_codigo = agar_papeleria),0)) = @valor or agar_valormora = @valor ) and
				 agar_orden_npe = @cuota and agar_tipo=@tipo_a 
            
				select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov
				print 'Pago de cuota'

				 if @valor_arancel_extra > 0 and @codigo_arancel_extra <> 0
				begin

					if (@codigo_arancel_extra>=1633 and @codigo_arancel_extra<=1637) --or @papeleria=1633
					 begin 
						--***************
						-- Si el arancel extra es 1633 que pertenece a la primera cuota de proc graduacion tecnicos diseño se le asiga el valor de 42
						declare @monto_cargo_papeleria money
						select @monto_cargo_papeleria = case when @codigo_arancel_extra=1633 then @valor_arancel_extra else 0 end 
						select  @valor_arancel_extra= case when @codigo_arancel_extra=1633 then 42.00 else @valor_arancel_extra end  

						print 'Papeleria o pago extra'
						insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo,
							  dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
							  dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
						values(1,@corr, @corr_det, @codigo_arancel_extra, 1, (@valor_arancel_extra), '', 0,
							  getdate(), 0, 0, @cil_codigo,@monto_cargo_papeleria,@valor_arancel_extra,0)

						select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov

						insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo,
						dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
						dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
						values(1,@corr, @corr_det, @codigo_arancel, 1, @valor_cuota, '', 0,
						getdate(), 0, 0, @cil_codigo,0,@valor_cuota,0)

						if exists (
							select 1 from col_art_archivo_tal_mora where per_codigo = @codper and ciclo = @cil_codigo 
								and tmo_arancel = (select tmo_arancel from col_tmo_tipo_movimiento where tmo_codigo = @codigo_arancel) 
								and tmo_valor_mora <> @valor and convert(date,fel_fecha) < convert(date,@fecha_archivo_c)
								)
					begin

					 select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov

						insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo,
						  dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
						  dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
						  values(1,@corr, @corr_det, 88, 1, 0, '', 0,
						  getdate(), 0, 0, @cil_codigo,10,0,0)
					end
					if exists (
							select 1 from col_art_archivo_tal_preesp_mora where per_codigo = @codper and ciclo = @cil_codigo 
							and tmo_arancel = (select tmo_arancel from col_tmo_tipo_movimiento where tmo_codigo = @codigo_arancel) 
							and tmo_valor_mora <> @valor and convert(date,fel_fecha) < convert(date,@fecha_archivo_c)
								)
					begin

					 select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov

						insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo,
						  dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
						  dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
						  values(1,@corr, @corr_det, 88, 1, 0, '', 0, getdate(), 0, 0, @cil_codigo, 10 ,0,0)
					end
					if exists (				
					select 1 from col_art_archivo_tal_proc_grad_tec_mora where per_codigo = @codper and ciclo = @cil_codigo 
					and tmo_arancel = (select tmo_arancel from col_tmo_tipo_movimiento where tmo_codigo = @codigo_arancel) 
					and tmo_valor_mora <> @valor and convert(date,fel_fecha) < convert(date,@fecha_archivo_c)
								)
					begin

					 select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov

						insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo,
						  dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
						  dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
						  values(1,@corr, @corr_det, 88, 1, 0, '', 0,
						  getdate(), 0, 0, @cil_codigo,10,0,0)
					end

					 end
					 else
						begin
					  -- Se agrega el cargo si existe
					  select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov
					  print 'Se agrega el alrancel extra'
					  insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo,
							dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
							dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
					  values(1,@corr, @corr_det, @codigo_arancel_extra, 1, @valor_arancel_extra, '', 0,
							getdate(), 0, 0, @cil_codigo,0,@valor_arancel_extra,0)

					  -- Actualizamos el saldo del alumno
					  --exec col_insert_dmo_saldo @codper,@valor_mora,@valor_mora
					  end
				   end
				else
				begin
					--ARANCEL SI NADA EXTRA LIBRE
					insert into col_dmo_det_mov
					(dmo_codreg,dmo_codmov,dmo_codigo, dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
					dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
					values(1,@corr, @corr_det, @codigo_arancel, 1, @valor_cuota, '', 0, getdate(), 
					0, 0, @cil_codigo, 0, @valor_cuota, 0)

					if exists (
						select 1 from col_art_archivo_tal_mora where per_codigo = @codper and ciclo = @cil_codigo 
							and tmo_arancel = (select tmo_arancel from col_tmo_tipo_movimiento where tmo_codigo = @codigo_arancel) 
							and tmo_valor_mora <> @valor and convert(date,fel_fecha) < convert(date,@fecha_archivo_c)
						)
					begin
						select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov

						insert into col_dmo_det_mov
						(dmo_codreg,dmo_codmov,dmo_codigo, dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
						dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
						values(1,@corr, @corr_det, 88, 1, 0, '', 0, getdate(), 
						0, 0, @cil_codigo,10,0,0)
					end

					if exists (
							select 1 from col_art_archivo_tal_preesp_mora where per_codigo = @codper and ciclo = @cil_codigo 
							and tmo_arancel = (select tmo_arancel from col_tmo_tipo_movimiento where tmo_codigo = @codigo_arancel) 
							and tmo_valor_mora <> @valor and convert(date,fel_fecha) < convert(date,@fecha_archivo_c)
						)
					begin
						select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov

						insert into col_dmo_det_mov
						(dmo_codreg,dmo_codmov,dmo_codigo, dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,
						dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
						values(1,@corr, @corr_det, 88, 1, 0, '', 0, getdate(), 
						0, 0, @cil_codigo, 10, 0, 0)
					end

					if exists (				
					select 1 from col_art_archivo_tal_proc_grad_tec_mora where per_codigo = @codper and ciclo = @cil_codigo 
					and tmo_arancel = (select tmo_arancel from col_tmo_tipo_movimiento where tmo_codigo = @codigo_arancel) 
					and tmo_valor_mora <> @valor and convert(date,fel_fecha) < convert(date,@fecha_archivo_c)
						)
					begin
						select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov
						insert into col_dmo_det_mov
						(dmo_codreg,dmo_codmov,dmo_codigo, dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva, dmo_fecha_registro,
						dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
						values(1,@corr, @corr_det, 88, 1, 0, '', 0, getdate(), 
						0, 0, @cil_codigo, 10, 0, 0)
					end
				end

				set @mora = dbo.fn_verifica_mora_cuota_alumno(@valor, @cuota,@tipo_a)
				if @mora = 'S'
				begin
					-- Se agrega el cargo si existe
					select @corr_det = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov
					print 'Se agrega el alrancel de recargo'
					insert into col_dmo_det_mov
					(dmo_codreg,dmo_codmov,dmo_codigo, dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro, 
					dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
					values(1,@corr, @corr_det, @codigo_mora, 1, @valor_mora, '', 0, getdate(), 
					0, 0, @cil_codigo, @valor_mora, @valor_mora, 0)
					-- Actualizamos el saldo del alumno
					--exec col_insert_dmo_saldo @codper,@valor_mora,@valor_mora
				end
			end
		end
		fetch cPagos into @fecha_c,@fecha_archivo_c, @factura_c, @tipo, @banco_c, @valor, @cuota, @alumno, @ciclo, @recibo, @codigo_carga,@puntoxpress,@tipo_a
	end -- while (@@fetch_STATUS = 0)
	
	close cPagos
	deallocate cPagos
	commit transaction

	select 'se procesaron ' + cast(@contador as varchar(20))+ ' registros, con un monto de: $ '+ cast(@total_procesado as varchar(20)) resultado
	
	declare @ultimo_ciclo_vigente_pre int 
	select top 1 @ultimo_ciclo_vigente_pre = cil_codigo 
	from ra_cil_ciclo 
	where cil_vigente_pre = 'S' 
	order by cil_codigo desc
	
	if exists (select @ultimo_ciclo_vigente_pre)
		exec col_corregir_saldos_alumnos_preespecialidad 2, @ultimo_ciclo_vigente_pre

	end try
	begin catch
		rollback transaction
		print 'Se ha producido un error!'
		select 'Se ha producido un error con algunos registros de la carga pagos de bancos y esos datos no han sido aplicados al sistema, '+
		'es probable que el archivo contenga informacion incorrecta es por eso que se ha omitido registros, '+
		'favor de  comuniquese con la Direccion de Informatica' resultado--, ERROR_MESSAGE(),ERROR_NUMBER(),ERROR_severity(),error_state(),ERROR_procedure(),ERROR_line()
	end catch
end
