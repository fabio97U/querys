--CAMBIOS EN EL PORTAL DE PAGO
---SE INCORPORAN LOS PAGOS DE OTROS ARANCELES
USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_update_user_pago_online]    Script Date: 16/08/2019 9:19:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[sp_update_user_pago_online]
       @Email varchar(50),
       @Estado varchar(10),
       @Codigo int
As
Begin
       update user_pago_online set upo_email = @Email, upo_estado = @Estado
       where upo_codper = @Codigo
end

select dbo.dkrpt(upo_pwd,'D') as Clave , *
from user_pago_online
inner join ra_per_personas on per_codigo = upo_codper
--select * from pla_emp_empleado where emp_apellidos_nombres like '%francisco javier%'
--select * from col_dao_data_otros_aranceles
--	select crp_usuario users,crp_clave pass from adm_crp_credenciales_promerica
alter procedure validar_CODIGOBARRA_boleta_otros_aranceles
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-08-21 08:40:44.767>
	-- Description: <Realiza las validaciones del codigo de barra en el portal pago - pagos especiales>
	-- =============================================
	-- validar_CODIGOBARRA_boleta_otros_aranceles 1, 187281, 120, '415741970000313739020000001500960000000180200000187281022019'
	-- validar_CODIGOBARRA_boleta_otros_aranceles 2, 187281, 0, '415741970000313739020000001500960000000180200000187281022019'
	@opcion int = 0,
	@codper int = 0,
	@codcil int = 0,
	@barra  nvarchar(80) = ''
as
begin

	if @opcion = 1 -- Valida que de codigo de barra ingresado exista 
	begin
		-- este procedimiento hace los mismo que sp "validar_NPE_boleta"
		-- Estado == "1" //Puede cancelar ese arancel
		-- Estado == "2" //NPE Cancelado
		-- Estado == "3" //NPE Invalido
		declare @estado varchar(2) = '1'
		if not exists (select 1 from col_dao_data_otros_aranceles where dao_barra = @barra)
		begin
			set @estado = '3'
		end 
		declare @coddpboa int
		declare @res int
		select @coddpboa = dao_coddpboa from col_dao_data_otros_aranceles where dao_barra = @barra
		print '@coddpboa ' + cast(@coddpboa as varchar(5))
		select @res = dbo.fn_cumple_parametros_boleta_otros_aranceles(@coddpboa,@codcil,-1) 
		print '@res ' + cast(@res as varchar(5))
		-- -1:NO EXISTE EL ARANCEL, 0: todo bien, 1: cupo acabado, 2: fecha vencimiento vencio, 3: fuera del periodo (fecha_desde a fecha_hasta)

		if @res = 0
		begin
			select tmo_codigo, dpboa_codtmo, per_codigo, per_carnet, tmo_arancel, tmo_valor, tmo_descripcion, per_tipo,0 'Mora', 
			/*isnull(((select '2' from col_mov_movimientos  
			join col_dmo_det_mov on dmo_codmov=mov_codigo 
			join col_tmo_tipo_movimiento a on tmo_codigo=dmo_codtmo
			where mov_codper=181324 and dmo_codcil=dao_codcil and a.tmo_arancel = tmo_arancel and mov_estado <> 'A'
			)),'1')*/
			@estado
				'Estado' 
			from col_dao_data_otros_aranceles
			inner join ra_per_personas on per_codigo = dao_codper
			left join ra_hpl_horarios_planificacion on hpl_codigo = dao_codhpl
			left join ra_pon_ponderacion on pon_codigo = dao_codpon
			inner join ra_cil_ciclo on cil_codigo = dao_codcil
			inner join col_dpboa_definir_parametro_boleta_otros_aranceles on dpboa_codigo = dao_coddpboa
			inner join col_tmo_tipo_movimiento on tmo_codigo = dpboa_codtmo
			where dao_barra = @barra and dao_codper = @codper-- and dao_codcil = @codcil
		end
	end

	if @opcion = 2-- Devuelve los datos del alumno junto con el monto a cancelar
	begin
		-- este procedimiento hace los mismo que sp "sp_col_daapl_datos_alu_pago_linea_estructurado"
		select per_nombres_apellidos 'alumno', per_carnet 'carnet', pla_alias_carrera 'carrera', tmo_valor 'monto', tmo_descripcion 'descripcion', 1 'estado', dao_npe
		from col_dao_data_otros_aranceles
		inner join ra_per_personas on per_codigo = dao_codper
		left join ra_hpl_horarios_planificacion on hpl_codigo = dao_codhpl
		left join ra_pon_ponderacion on pon_codigo = dao_codpon
		inner join ra_cil_ciclo on cil_codigo = dao_codcil
		inner join col_dpboa_definir_parametro_boleta_otros_aranceles on dpboa_codigo = dao_coddpboa
		inner join col_tmo_tipo_movimiento on tmo_codigo = dpboa_codtmo

		inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
		inner join ra_pla_planes on pla_codigo = alc_codpla
		where dao_barra = @barra and dao_codper = @codper
	end
end


select * from col_dao_data_otros_aranceles