alter function fn_pre_categori_res
(
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-07-15 08:06:52.407>
	-- Description: <Esta funcion retorna o la respuesta o la categoria de la @pre_IdPregunta y @prer_Numero>
	-- =============================================
	--esta funcion es llamada desde el procedimiento "sp_pv_consultar_preguntas_escalas"
	--SE REALIZO EL CAMBIO AL PROCEDIMIENTO "sp_pv_consultar_preguntas_escalas", CAMBIANDO LAS CONSULTAS Y SE PASO A UTILIZAR LA FUNCION "fn_pre_categori_res"
	--select dbo.fn_pre_categori_res(510, 1, 1)
	@pre_IdPregunta int,
	@prer_Numero int,
	@return_res_Respuesta int --ESTA PARAMETRO SIRVE PARA IDENTIFICAR SI RESPUESTA(res_Respuesta) Ó CATEGORIA(pre_categorias) LO QUE SE DEVOLVERA
)
returns varchar(160)
begin
	declare @res varchar(160)

	if @return_res_Respuesta = 1 --SE DEVUELVE RESPUESTA(res_Respuesta)
	begin
		select @res = rs.res_Respuesta
		from prb_pre_preguntas pr inner join prb_prer_preguntas_respuestas prs on pr.pre_IdPregunta=prs.prer_codpre 
		inner join prb_res_respuestas rs on prs.prer_codres=rs.res_IdRespuesta
		where prs.prer_codpre=@pre_IdPregunta and prs.prer_Numero=@prer_Numero
	end
	else  --SE DEVUELVE CATEGORIA(pre_categorias)
	begin
		select @res = pr.pre_categorias
		from prb_pre_preguntas pr inner join prb_prer_preguntas_respuestas prs on pr.pre_IdPregunta=prs.prer_codpre 
		inner join prb_res_respuestas rs on prs.prer_codres=rs.res_IdRespuesta
		where prs.prer_codpre=@pre_IdPregunta and prs.prer_Numero=@prer_Numero
	end

	return @res
end

