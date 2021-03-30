select * from ra_ins_inscripcion where ins_codper = 173322 and ins_codcil = 125
select * from ra_mai_mat_inscritas where mai_codins = 1234923
--update ra_validaciones_globales set rvg_mensaje = '0' where rvg_codper = 173322

select * from col_tmo_tipo_movimiento where tmo_arancel in ('C-09', 'R-03', 'A-03');
--3		A-03 	Adicion de Materias Ordinario.
--141	C-09 	Cambio de Seccion Ordinario.
--852	R-03 	Retiro de Materias Ordinario.

--drop table col_teins_tramites_efectuados_inscripcion
create table col_teins_tramites_efectuados_inscripcion (
	teins_codigo int primary key identity (1, 1),
	teins_codcil int,
	teins_codper int,
	teins_codins int,
	teins_codtmo int,
	teins_fecha_creacion datetime default getdate()
)
--select * from col_teins_tramites_efectuados_inscripcion




--create type tbl_teins as table(
--	teins_codcil int,
--	teins_codper int,
--	teins_codins int,
--	teins_codtmo int
--)
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2021-01-14 20:26:37.106>
	-- Description: <Realiza el mantenimiento a la tabla "col_teins_tramites_efectuados_inscripcion">
	-- =============================================
alter procedure sp_tramites_efecturado_inscripcion
	@opcion int = 0,
	@codcil int = 0,
	@codper int = 0,
	@tbl_teins as tbl_teins readonly
as
begin
	
	if @opcion = 1 --Verifica si el alumno puede realizar algun tramite a su inscripcion
	begin
		-- exec sp_tramites_efecturado_inscripcion @opcion = 1, @codcil = 125, @codper = 209231
		select tmo_codigo, tmo_arancel, tmo_descripcion, pagos_realizados, utilizados 
		from (
			select tmo_codigo, rtrim(ltrim(tmo_arancel)) tmo_arancel, tmo_descripcion, count(dmo_codtmo) 'pagos_realizados', count(teins_codtmo) 'utilizados' 
			from col_mov_movimientos
				inner join col_dmo_det_mov on dmo_codmov = mov_codigo
				inner join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
				left join col_teins_tramites_efectuados_inscripcion 
					on teins_codper = mov_codper and teins_codcil = dmo_codcil and dmo_codtmo = teins_codtmo
			where mov_codcil = @codcil and mov_codper = @codper
			and dmo_codtmo in (3, 141, 852) and mov_estado <> 'A'
			group by tmo_codigo, tmo_arancel, tmo_descripcion, dmo_codtmo, teins_codtmo
		) t
		where utilizados < pagos_realizados
	end

	if @opcion = 2
	begin
		insert into col_teins_tramites_efectuados_inscripcion (teins_codcil, teins_codper, teins_codins, teins_codtmo)
		select teins_codcil, teins_codper, teins_codins, teins_codtmo from @tbl_teins
		select SCOPE_IDENTITY() res
	end

end