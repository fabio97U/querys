USE [uonline]
GO
/****** Object:  UserDefinedFunction [dbo].[cum2]    Script Date: 19/6/2020 12:17:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--	select dbo.cum2(102744)--7.94

ALTER FUNCTION [dbo].[cum2] (@codper int)
returns real as
begin
    declare @cum real = 0.0, @nota_minima real, @codpla int
	declare @CUM_division float = 0.0

	select @nota_minima = uni_nota_minima from ra_uni_universidad where uni_codigo = 1

	select @codpla = alc_codpla from ra_alc_alumnos_carrera where alc_codper = @codper

	select @CUM_division = sum(cum)/sum(uv)
	from (
		select sum(round(nota, 1) * plm_uv) cum, sum(plm_uv) as uv 
		from (
			select mai.mai_codmat, max(nota) nota, max(uv) plm_uv
			from ra_mai_mat_inscritas_h_v mai
			inner join notas b on b.ins_codper = mai.codper and b.ins_codcil = mai.codcil and b.mai_codmat = mai.mai_codmat_del
			inner join ra_alc_alumnos_carrera on alc_codper = mai.codper
			where mai.codper = @codper and round(b.nota, 1) >= @nota_minima
			and b.estado = 'I' and mai.mai_codpla = @codpla
			and b.ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
			group by mai.mai_codmat
		) r
		union all
		select sum(eqn_nota * plm_uv) cum, sum(plm_uv) as uv
		from (
			select distinct eqn_codmat, eqn_nota, plm_uv
			from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad, 
				ra_alc_alumnos_carrera,ra_plm_planes_materias
				where equ_codigo = eqn_codequ
				and equ_codper = @codper
				and eqn_nota > 0
				and alc_codper = equ_codper
				and plm_codmat = eqn_codmat
				and plm_codpla = alc_codpla
		) r
	) t
	set @cum = round(@CUM_division, 2)
	
	select @cum = case when substring(cast(@cum as varchar), len(cast(@cum as varchar)), 1) = 5 then @cum - 0.01 else @cum end
	return isnull(@cum, 0)
end