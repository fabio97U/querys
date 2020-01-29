USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[rep_registro_egresados_fecha]    Script Date: 29/1/2020 10:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--   [rep_registro_egresados_fecha] 119,'9','12/06/2019','24/06/2019'
ALTER procedure [dbo].[rep_registro_egresados_fecha]
	@codcil int,
	@car_codigo char(2),
	@fecha_inicio varchar(10), 
	@fecha_final varchar(10)

--declare  @codcil int,@car_codigo char(2),@fecha_inicio varchar(10), @fecha_final varchar(10)
as
Begin
	declare @nombreciclo varchar(20)
	--set @codcil = 99
	--set @car_codigo = '0' 
	--set @fecha_inicio = '10/12/2014' 
	--set @fecha_final = '03/01/2015'


	set @car_codigo =(case when @car_codigo = '0' then '%%' else @car_codigo end)
	--select @car_codigo

	set @nombreciclo = (select cic_nombre+'-'+ CAST(cil_anio as varchar) from ra_cil_ciclo join ra_cic_ciclos on cil_codcic=cic_codigo
	where cil_codigo=@codcil)

	select ROW_NUMBER() over(partition by car_nombre order by per_carnet)corr, per_codigo, per_carnet, per_nombres_apellidos, 
		sum(hsp_horas) horas, regr_cum, regr_documentos, regr_observaciones, regr_estado, cic_nombre+'-'+ CAST(cil_anio as varchar) ciclo, car_identificador, car_nombre,
		case when isnull(regr_record,'R') = 'R' then 'Registrado'
		when isnull(regr_record,'R') = 'I' then 'Impreso'
		else '' end Record, case when isnull(regr_rendimiento,'R') = 'R' then 'Registrado'
		when isnull(regr_rendimiento,'R') = 'I' then 'Impreso'
		else '' end Rendimiento, case when isnull(regr_carta,'R') = 'R' then 'Registrado'
		when isnull(regr_carta,'R') = 'I' then 'Impreso'
		else '' end carta, @nombreciclo nombreciclo
	from ra_per_personas join ra_regr_registro_egresados on per_codigo = regr_codper 
		join ra_hsp_horas_sociales_personas on hsp_codper=per_codigo 
		join ra_cil_ciclo on cil_codigo=regr_codcil 
		join ra_cic_ciclos on cic_codigo=cil_codcic
		join ra_alc_alumnos_carrera on alc_codper=per_codigo
		join ra_pla_planes on pla_codigo=alc_codpla
		join ra_car_carreras on car_codigo=pla_codcar
	where regr_codcil_ing = @codcil 
	 and convert (char(2),car_codigo) like ''+@car_codigo+'' -- FUNCION, EL RESULTADO ES EL MISMO PERO SE TIENE QUE REALIZAR CONVERSION DE TIPO DE DATOS
	--	and car_identificador like @car_codigo
		and convert(datetime,regr_fecha,103) >= convert(datetime,@fecha_inicio,103) and convert(datetime,regr_fecha,103) <= convert(datetime,@fecha_final,103)
	group by per_codigo, per_carnet, per_nombres_apellidos, regr_cum, regr_documentos, regr_observaciones, regr_estado, cil_anio, cic_nombre, regr_record, regr_rendimiento, regr_carta, car_identificador, car_nombre
	order by 3
End