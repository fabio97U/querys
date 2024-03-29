USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[sp_reversion_pago]    Script Date: 24/3/2020 10:24:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from ra_per_personas where per_codigo =209261
--25-3368-2018

--	exec sp_reversion_pago '0313006300000020926150120200', '11', 'TFS20002LN73N'
ALTER procedure [dbo].[sp_reversion_pago]
	@npe varchar(100),
	@tipo int,
	@referencia varchar(100)
 as
 begin
--*************************************************************************
--Declaracion de variables 
--*************************************************************************
	declare @n_valor varchar(6),
	@n_carnet varchar(15), @carnet nvarchar(15),
	@n_cuota varchar(5),
	@n_ciclo varchar(6),
	@per_codigo int,
	@fecha datetime,
	@pal_usuario nvarchar(50)

	select @pal_usuario = @pal_usuario from col_pal_pagos_linea where pal_codigo = @tipo

--*************************************************************************
--Asignacion de variables
--*************************************************************************
	select @n_valor = substring(@npe,6,5) 
	select @n_carnet = -- substring(@npe,11,2)+ '-' + substring(@npe,13,4) + '-'+substring(@npe,17,4) 
						substring(@npe,11,2) + substring(@npe,13,4) + substring(@npe,17,4) 
	set @per_codigo = cast(substring(@npe,11,2) + substring(@npe,13,4) + substring(@npe,17,4) as int)

	select @n_cuota = substring(@npe,21,1) 
	select @n_ciclo = substring(@npe,22,6)
	set  @carnet = (SELECT per_carnet FROM ra_per_personas where per_codigo = @per_codigo)
	set @fecha=getdate();

	print '@n_valor : ' + @n_valor
	print '@n_carnet : ' + @n_carnet
	print '@n_cuota : ' + @n_cuota
	print '@carnet : ' + @carnet
	print '@n_ciclo : ' + @n_ciclo
	print '@per_codigo : ' + cast(@per_codigo as nvarchar(10))

	UPDATE [dbo].[col_mov_movimientos]
	   SET 
			[mov_estado]='A'
			,[mov_usuario_anula] = @pal_usuario
			,[mov_fecha_anula] = getdate()
	--select * from col_mov_movimientos
	WHERE    [mov_codper] = @per_codigo
      and [mov_puntoxpress] = @tipo
      and [mov_recibo_puntoxpress] = @referencia
	  and CONVERT (char(10), mov_fecha_registro, 103) = CONVERT (char(10), getdate(), 103)
	  
	  select count(1) Resultado
	  from col_mov_movimientos
	  where  [mov_codper] = @per_codigo
      and [mov_puntoxpress] = @tipo
      and [mov_recibo_puntoxpress] = @referencia
	  and [mov_estado] = 'A'
end

--select top 5 * from col_mov_movimientos order by mov_codigo desc