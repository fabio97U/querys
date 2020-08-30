--select * from ra_cild_ciclos_descuentos

--select * from col_dfal_descuentos_futuro_alumnos

--select * from col_tipmen_tipo_mensualidad
----definida en una interfaz a parte, desde el expediente

	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-06-30 14:52:36.627>
	-- Description: <Realiza el mantenimiento a la tabla "col_dfal_descuentos_futuro_alumnos">
	-- =============================================
alter procedure sp_col_dfal_descuentos_futuro_alumnos
	@opcion int = 0,
	@codper int = 0,
	@codcild int = 0,
	@codtipmen int = 0,
	@codusr int = 0,
	@habilitado bit = 0
as
begin

	if @opcion = 1
	begin
		-- sp_col_dfal_descuentos_futuro_alumnos @opcion = 1, @codper = 225358
		select cild_codigo, concat('0', cild_numciclo, '-', cild_anio) 'ciclo_descuento', isnull(dfal_codper, 0) 'posee_descuento', 
		tipmen_codigo, tipmen_tipo, dfal_codigo
		from ra_cild_ciclos_descuentos
		left join col_dfal_descuentos_futuro_alumnos on dfal_codcild = cild_codigo and dfal_codper = @codper
		left join col_tipmen_tipo_mensualidad on tipmen_codigo = dfal_codtipmen
		where cild_anio >= year(getdate()) 
		order by cild_codigo asc
	end

	if @opcion = 2
	begin
		if (@habilitado = 1) --Inserta un nuevo tipo de descuento
		begin
			-- select * from col_dfal_descuentos_futuro_alumnos
			if not exists (select 1 from col_dfal_descuentos_futuro_alumnos where dfal_codcild = @codcild and dfal_codper = @codper)
			begin
				insert into col_dfal_descuentos_futuro_alumnos (dfal_codcild, dfal_codper, dfal_codtipmen, dfal_coduser) 
				values (@codcild, @codper, @codtipmen, @codusr)
				select 1
			end
			else
				select 0
		end
		else if (@habilitado = 0) --Borra el tipo de descuento
		begin
			delete from col_dfal_descuentos_futuro_alumnos where dfal_codcild = @codcild and dfal_codper = @codper
			select -1
		end
	end

end