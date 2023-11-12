--select * from faex_facturacion_sujeto_excluido where faex_codusr_creacion = 407
--select * from faexde_facturacion_sujeto_excluido_detalle where faexde_codigo >= 345

--alter table faex_facturacion_sujeto_excluido add faex_codpla int
--alter table faex_facturacion_sujeto_excluido add faex_codemp int
--alter table faex_facturacion_sujeto_excluido add faex_codusr_creacion int


	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2023-02-24 13:41:16.183>
	-- Description: <Crea del registro de docentes en sujetos excluidos>
	-- =============================================
	-- exec dbo.sp_DHC_sujetos_excluidos 1, 202212, 'T', 309
	-- exec dbo.sp_DHC_sujetos_excluidos 2, 202212, 'T', 309
alter procedure sp_DHC_sujetos_excluidos
	@opcion int = 0,
	@codpla int = 0,
	@contribuyente varchar(3) = '', -- T: Todos los empleados, S: Contribuyentes, N: No contribuyentes
	@recibo int = 0,

	@fecha varchar(12) = '',
	@codusr int = 0,

	@codemp int = 0,
	@mes int = 0,
	@anio int = 0,
	@total_ingresos real = 0
as
begin
	
	set dateformat dmy
	declare @codfaex int = 0

	if @opcion = 3 -- Uno a uno, esta opcion hace return por que solo inserta, esto para no alterar tanto la logica porque pidieron un cambio de insert 1 a 1
	begin
		-- exec dbo.sp_DHC_sujetos_excluidos @opcion = 3, @codpla = 202301, @codemp = 276, @recibo = 309, @fecha = '27/02/2023', @codusr = 407, @mes = 1, @anio = 2023, @total_ingresos = 10.0
		if not exists (
			select 1 from pla_hipd_historico_planilla_dhc 
				inner join pla_dehp_det_hist_planilla_dhc on dehp_codhipd = hipd_codigo
				inner join pla_emp_empleado on dehp_codemp = emp_codigo
				inner join meses m on m.codigo = hipd_mes
			where hipd_codpla = @codpla and dehp_codemp = @codemp
			and concat(@codpla, @codemp) in (select distinct concat(faex_codpla, faex_codemp) from faex_facturacion_sujeto_excluido where faex_estado not in ('A'))
		)
		begin
			--@mrecibo, @fecha, @mhipd_codpla, @codemp, @codusr, @mmes, @manio, @dehp_total_ingresos
			insert into faex_facturacion_sujeto_excluido 
			(faex_recibo, faex_codpro, faex_aplica_renta, faex_condicion_pago, faex_fecha, faex_estado, faex_fecha_registro, 
			faex_aplica_iva, faex_codpla, faex_codemp, faex_codusr_creacion)
			values (@recibo, NULL, 1, 'CONTADO', cast(@fecha as date), 'R', getdate(), 
			0, @codpla, @codemp, @codusr)
			select @codfaex = @@IDENTITY
			print '@codfaex ' + cast(@codfaex as varchar(10))

			insert into faexde_facturacion_sujeto_excluido_detalle
			(faexde_codfaex, faexde_cantidad, faexde_descripcion, faexde_precio, faexde_fecha_registro)
			values (@codfaex, 1, 'Pago horas clases ' + (select mes from meses where codigo = @mes) + ' ' + cast(@anio as varchar(10)), @total_ingresos, getdate())
			select 1 'res'
			return
		end
		select 0 'res'
		return
	end

	declare @tbl_resultado as table (
		recibo int, hipd_codpla int, hipd_anio int, hipd_mes int, mes varchar(40), emp_codigo int, emp_apellidos_nombres varchar(500), emp_posee_NRC varchar(10), 
		emp_NRC varchar(50), dehp_codigo int, dehp_codemp int, dehp_hora_clase_fic real, dehp_solvencia_fic real, dehp_hora_clase_fcs real, 
		dehp_solvencia_fcs real, dehp_hora_clase_fj real, dehp_solvencia_fj real, dehp_hora_clase_fce real, dehp_solvencia_fce real, 
		dehp_hora_clase_dip real, dehp_solvencia_dip real, dehp_hora_clase_mae real, dehp_examen_suficiencia real, dehp_jurado_tesis real,
		dehp_jurado_anteproyecto real, dehp_asesoria_tesis real, dehp_proceso_graduacion real, dehp_otros_ingresos real, 
		dehp_otros_descuentos real, dehp_total_ingresos real, dehp_descuentos_renta real, dehp_total_neto real
	)
	insert into @tbl_resultado(recibo, hipd_codpla, hipd_anio, hipd_mes, mes, emp_codigo, emp_apellidos_nombres, emp_posee_NRC, emp_NRC,
		dehp_codigo,
		dehp_codemp, dehp_hora_clase_fic, dehp_solvencia_fic, dehp_hora_clase_fcs, dehp_solvencia_fcs, dehp_hora_clase_fj, 
		dehp_solvencia_fj, dehp_hora_clase_fce, dehp_solvencia_fce, dehp_hora_clase_dip, dehp_solvencia_dip, dehp_hora_clase_mae, 
		dehp_examen_suficiencia, dehp_jurado_tesis, dehp_jurado_anteproyecto, dehp_asesoria_tesis, dehp_proceso_graduacion, 
		dehp_otros_ingresos, dehp_otros_descuentos, dehp_total_ingresos, dehp_descuentos_renta, dehp_total_neto)
		
	select (row_number() over(order by emp_apellidos_nombres) + @recibo-1), 
		hipd_codpla, hipd_anio, hipd_mes, m.mes, emp_codigo, emp_apellidos_nombres, emp_posee_NRC, emp_NRC,
		dehp_codigo,
		dehp_codemp, dehp_hora_clase_fic, dehp_solvencia_fic, dehp_hora_clase_fcs, dehp_solvencia_fcs, dehp_hora_clase_fj, 
		dehp_solvencia_fj, dehp_hora_clase_fce, dehp_solvencia_fce, dehp_hora_clase_dip, dehp_solvencia_dip, dehp_hora_clase_mae, 
		dehp_examen_suficiencia, dehp_jurado_tesis, dehp_jurado_anteproyecto, dehp_asesoria_tesis, dehp_proceso_graduacion, 
		dehp_otros_ingresos, dehp_otros_descuentos, dehp_total_ingresos, dehp_descuentos_renta, dehp_total_neto

	from pla_hipd_historico_planilla_dhc 
		inner join pla_dehp_det_hist_planilla_dhc on dehp_codhipd = hipd_codigo
		inner join pla_emp_empleado on dehp_codemp = emp_codigo
		inner join meses m on m.codigo = hipd_mes
	where hipd_codpla = @codpla and emp_posee_NRC = case when @contribuyente = 'T' then emp_posee_NRC else @contribuyente end
		
	and concat(hipd_codpla, dehp_codemp) not in (select concat(faex_codpla, faex_codemp) from faex_facturacion_sujeto_excluido where faex_estado not in ('A'))
	
	if exists (select 1 from @tbl_resultado where recibo in (select faex_recibo from faex_facturacion_sujeto_excluido))
	begin
		print 'Recibo ya existe'
		select concat('0 ', ' recibo ' + cast(@recibo as varchar(10)) + ' ya esta utilizado') 'res'
		return
	end

	if @opcion =1 -- Devuelve la data a migrar
	begin
		select * from @tbl_resultado order by emp_apellidos_nombres
	end

	if @opcion = 2 -- Inserta el detalle de sujeto exlcuido MASIVO
	begin

		set @codfaex = 0
		declare @contador int = 1
		declare @mhipd_codpla int = 0, @mrecibo varchar(12), @mcodemp int = 0, @dehp_total_ingresos real = 0, @mmes varchar(50) = '', @manio int = 0--Variables del select
		
		begin tran
		begin try
			declare m_cursor cursor 
			for
				select hipd_codpla, recibo, dehp_codemp, dehp_total_ingresos, hipd_anio, mes from @tbl_resultado order by emp_apellidos_nombres
                
			open m_cursor
 
			fetch next from m_cursor into @mhipd_codpla, @mrecibo, @mcodemp, @dehp_total_ingresos, @manio, @mmes
			while @@FETCH_STATUS = 0 
			begin
				print '@mrecibo: ' + cast(@mrecibo as varchar(12))

				insert into faex_facturacion_sujeto_excluido 
				(faex_recibo, faex_codpro, faex_aplica_renta, faex_condicion_pago, faex_fecha, faex_estado, faex_fecha_registro, faex_aplica_iva, faex_codpla, faex_codemp, faex_codusr_creacion)
				values (@mrecibo, NULL, 1, 'CONTADO', cast(@fecha as date), 'R', getdate(), 0, @mhipd_codpla, @mcodemp, @codusr)
				select @codfaex = @@IDENTITY

				insert into faexde_facturacion_sujeto_excluido_detalle
				(faexde_codfaex, faexde_cantidad, faexde_descripcion, faexde_precio, faexde_fecha_registro)
				values (@codfaex, 1, 'Pago horas clases ' + @mmes + ' ' + cast(@manio as varchar(10)), @dehp_total_ingresos, getdate())
			
				set @contador = @contador + 1

				fetch next from m_cursor into @mhipd_codpla, @mrecibo, @mcodemp, @dehp_total_ingresos, @manio, @mmes
			end
			close m_cursor  
			deallocate m_cursor

			select @contador 'res'
			commit tran
		end try
		begin catch

			rollback tran 
			select concat('0 ', ERROR_MESSAGE()) 'res'
			close m_cursor  
			deallocate m_cursor

		end catch

	end

end