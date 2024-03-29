USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[tal_GenerarDataTalonarioPreGradoPorAgrupacion]    Script Date: 7/12/2020 14:45:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:		<Juan Carlos Campos Rivera>
	-- Create date: <Martes 18 Junio 2019>
	-- Description:	<Generar data de boletas de pagos por agrupacion de alumnos
	--				esta opcion es para evitar que se genere mas de una data por estudiante
	--				se toman en cuenta los alumnos que pagaron todas las cuotas del ciclo base>
	-- =============================================
	--	exec tal_GenerarDataTalonarioPreGradoPorAgrupacion 1, 125, 123

ALTER PROCEDURE [dbo].[tal_GenerarDataTalonarioPreGradoPorAgrupacion]
	@opcion int = 0,
	--@generardata int, -- 1: almacenar en tabla, 0: solo mostrar data previa
	--@codreg int,
	@codcil_destino int = 0,
	@codcil_origen int = 0
as
begin
	set nocount on

	--create table @alm_generar_data (codper_i int)
	declare @alm_generar_data as table (codper_i int)

	print 'Obteniendo los alumnos que pagaron todo el ciclo anterior'
	declare @alm_pagos_completos table(
		per_codigo int, per_carnet nvarchar(15), per_nombres_apellidos nvarchar(200), Matricula int,
		Cuota1 int, Cuota2 int, Cuota3 int, Cuota4 int, Cuota5 int, Cuota6 int
	)

	insert into @alm_pagos_completos 
	(per_codigo, per_carnet, per_nombres_apellidos, Matricula, Cuota1, Cuota2, Cuota3, Cuota4, Cuota5, Cuota6)
	exec col_pagos_por_alumno_pivot 1, @codcil_origen, @codcil_origen

	print 'Se almacena el codper del alumno que ya pago todo el ciclo'
	insert into @alm_generar_data (codper_i) 
	select distinct per_codigo from @alm_pagos_completos 
	
	print 'Se eliminan los codper de los alumnos que estan con data de tecnicos'
	delete from @alm_generar_data where codper_i in (
		select distinct per_codigo 
		from col_art_archivo_tal_proc_grad_tec_mora
		where ciclo = @codcil_destino
		union
		select distinct per_codigo 
		from col_art_archivo_tal_proc_grad_tec_dise_mora 
		where ciclo = @codcil_destino
	)

	-- SE GENERAN LOS ALUMNOS QUE TIENE PAGO DE RETIRO DE CICLO (ESTO PARA NO GENERAR DATOS DE ESTOS ALUMNOS)--  799 --15/05/204  
	print 'Obteniendo los codper de los que tienen retiro de ciclo'
	declare @alm_retiro_ciclo table (mov_codper int)
	insert into @alm_retiro_ciclo (mov_codper)
	select distinct mov_codper
	from col_mov_movimientos 
		inner join col_dmo_det_mov on dmo_codmov = mov_codigo
	where mov_estado <> 'A'
		and mov_fecha <= convert(datetime,GETDATE(),103)
		and dmo_codtmo in (854)-- (136,137,160,161,943,944) --(@cod_arancel1,@cod_arancel2)
		and mov_codcil = @codcil_origen

	print 'Obteniendo los alumnos posiblemente egresados'
	-- Genera los alumnos que posiblemente egresaran, esto para no ser tomados en cuenta al momento de generar la data de los talonarios
	declare @Alumnos_X_Egresar table (
		carrera nvarchar(80), per_carnet nvarchar(15), 
		per_nombres_apellidos nvarchar(80), ins_codper int
	)

	insert into @Alumnos_X_Egresar(carrera, per_carnet, per_nombres_apellidos, ins_codper)
	select distinct substring(per_carnet,1,2) carrera, per_carnet,  per_nombres_apellidos,ins_codper
	from ra_ins_inscripcion 
		join ra_alc_alumnos_carrera on alc_codper = ins_codper
		join ra_pla_planes on alc_codpla = pla_codigo
		join ra_per_personas on per_codigo = ins_codper
	where ins_codcil in (@codcil_origen) 
	and per_tipo = 'U' and ((select dbo.mat_apro_por_egresar(ins_codper)) >= pla_n_mat)
	order by 1

	delete from @alm_generar_data where codper_i in (select ins_codper from @Alumnos_X_Egresar)
	delete from @alm_generar_data where codper_i in (select mov_codper from @alm_retiro_ciclo)
	delete from @alm_generar_data where codper_i in (select distinct per_codigo from col_art_archivo_tal_mora where ciclo = @codcil_destino)

	select count(1) from @alm_generar_data--3467
	--00:02:36.680, 00:02:37.482

	--Se comienza proceso para generar la data
	declare @contador int = 1

	declare @codper int
	declare cursordata cursor for 
		select codper_i from @alm_generar_data order by codper_i
	open cursordata
	fetch next from cursordata into @codper
	while @@fetch_status = 0
	begin
		print '------------------------'
		print '@contador : ' + cast(@contador as nvarchar(6)) + ' , ' + cast(@codper as nvarchar(6))

		exec tal_GenerarDataTalonarioPreGrado_porAlumno -1, 1, @codcil_origen, @codcil_origen, @codper
		exec tal_GenerarDataTalonarioPreGrado_porAlumno 2, 1, @codcil_destino, @codcil_destino, @codper

		set @contador = @contador + 1

		fetch next from cursordata into @codper
	end
	close cursordata
	deallocate cursordata
	--00:03:40.890

end