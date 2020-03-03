
create table web_caav_calendario_acad_virtual(
	caav_codigo int primary key identity(1,1),
	caav_codmat nvarchar(15),
	caav_codpla int,
	caav_evaluacion int,
	caav_fecha_limite datetime,
	caav_bloque int,
	caav_usuario int,
	caav_fecha_registro datetime default getdate()
)



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Adones>
-- Create date: <15.02.2020>
-- Description:	<Mantenimiento de el calendario academico para virtuales.>
-- =============================================
--sp_calendario_academico_virtual 1, 'hhhh', 80, 2, '', 2
CREATE PROCEDURE [dbo].[sp_calendario_academico_virtual]
	@opcion int,
	@codmat nvarchar(10),
	@codpla int,
	@evaluacion int,
	@bloque_fecha int,
	@fecha_li nvarchar(10),
	@coduser int
AS
BEGIN
set dateformat dmy
	if @opcion = 1
	begin		
		declare @fecha_evaluacion nvarchar(10)
		set @fecha_evaluacion = (select top 1 convert(nvarchar(10),caav_fecha_limite,103) from web_caav_calendario_acad_virtual where caav_evaluacion = @evaluacion and caav_codpla = @codpla )
		set @fecha_evaluacion = case when @fecha_evaluacion is null then convert(nvarchar(10),getdate(),103) else @fecha_evaluacion end
		if not exists (select 1 from web_caav_calendario_acad_virtual where caav_codmat = @codmat and caav_codpla = @codpla and caav_evaluacion = @evaluacion and caav_bloque = @bloque_fecha  )
			begin
				insert into web_caav_calendario_acad_virtual (caav_codmat,caav_codpla,caav_evaluacion,caav_bloque,caav_fecha_limite,caav_usuario)
				values (@codmat,@codpla,@evaluacion,@bloque_fecha,@fecha_evaluacion,@coduser)
			end
	end
	if @opcion = 2
	begin
		select caav_codpla codpla,caav_bloque bloque_fecha,caav_evaluacion evaluacion,convert(nvarchar(10),max(caav_fecha_limite),103) fecha_li
			from web_caav_calendario_acad_virtual where caav_codpla = @codpla and caav_evaluacion = @evaluacion
		group by caav_evaluacion,caav_codpla,caav_bloque
	end
	if @opcion = 3
	begin
		select caav_codigo,mat_codigo,mat_nombre,caav_evaluacion,caav_bloque from web_caav_calendario_acad_virtual 
			inner join ra_mat_materias on mat_codigo = caav_codmat
			where caav_codpla = @codpla and caav_evaluacion = @evaluacion and caav_bloque = @bloque_fecha
	end
	if @opcion = 4
	begin
		begin try
			update web_caav_calendario_acad_virtual set caav_fecha_limite = @fecha_li
				where caav_codpla = @codpla and caav_evaluacion = @evaluacion and caav_bloque = @bloque_fecha
		end try
		begin catch
			
		end catch
	end
END