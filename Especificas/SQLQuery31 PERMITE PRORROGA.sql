declare @codper int = 163640, @codcil int =122, @eval int = 3
declare @per_carnet_anio int, @codtde int, @cum real, @cuotas_canceladas int, @ultima_eva_con_prorroga int, @per_tipo_ingreso int
		select @per_carnet_anio = substring(per_carnet, 9, 4), @codtde = tde_codigo,
		@per_tipo_ingreso = isnull(per_tipo_ingreso, 0)
		from ra_per_personas 
		inner join ra_tde_TipoDeEstudio on tde_tipo = per_tipo where per_codigo = @codper

		select @cuotas_canceladas = (count(mov_codper) - 1)-- -1 para descartar la matricula
		from col_mov_movimientos 
			inner join col_dmo_det_mov on dmo_codmov = mov_codigo and dmo_codcil = mov_codcil
			inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo_codtmo 
			inner join vst_Aranceles_x_Evaluacion as vst on vst.are_codtmo = tmo.tmo_codigo and vst.tmo_arancel = tmo.tmo_arancel
		where mov_codcil = @codcil and mov_codper = @codper  

		select top 1 @ultima_eva_con_prorroga = isnull(pon_orden, 0) from ra_pra_prorroga_acad
		inner join ra_poo_prorroga_otorgar on poo_codigo = pra_codpoo
		inner join ra_per_personas on per_codigo = pra_codper
		inner join ra_pon_ponderacion on pon_codigo = poo_codpon
		where poo_codcil = @codcil and pra_codper = @codper
		order by pon_orden desc
		set @ultima_eva_con_prorroga = isnull(@ultima_eva_con_prorroga, -1)

		declare @codpproac int, @anio_carnet int, @anio_carnet_fin int, @numero_cuota int, @cantidad int, @cum_minimo real, 
		@mensaje_afirmativo varchar(400), @mensaje_negativo varchar(400), @prorroga_sucesiva int

		select @codpproac = pproac_codigo, @anio_carnet = pproac_anio_carnet, @anio_carnet_fin = pproac_anio_carnet_fin, 
		@numero_cuota = pproac_numero_cuota,
		@cantidad = pproac_cantidad, @cum_minimo = pproac_cum_minimo, @mensaje_afirmativo = pproac_mensaje_afirmativo,
		@mensaje_negativo = pproac_mensaje_negativo, @prorroga_sucesiva = pproac_prorroga_sucesiva
		from ra_pproac_parametros_prorrogas_anio_carnet
		where pproac_codcil = @codcil 
		and convert(date, getdate(), 103) between convert(date, pproac_fecha_inicio, 103) and convert(date, pproac_fecha_fin, 103)
		and @per_carnet_anio between pproac_anio_carnet and pproac_anio_carnet_fin and pproac_codtde = @codtde
		and pproac_activo = 1
		print '@codpproac ' + cast(@codpproac as varchar(5))
	
		if ((isnull(@anio_carnet, 0)) <> 0)--Si devuelve algo el select anterior es porque esta en el periodo
		begin
			if not exists (select 1 from ra_pra_prorroga_acad
					inner join ra_poo_prorroga_otorgar on poo_codigo = pra_codpoo
					inner join ra_per_personas on per_codigo = pra_codper 
					inner join ra_pon_ponderacion on pon_codigo = poo_codpon 
					where poo_codcil = @codcil and pra_codper = @codper and poo_codpon = @eval)-- Si no a pedido prorroga
			begin
				declare @alumnos_han_solicitado_prorroga int
				select @alumnos_han_solicitado_prorroga = count(1) from ra_pra_prorroga_acad
				inner join ra_poo_prorroga_otorgar on poo_codigo = pra_codpoo
				inner join ra_per_personas on per_codigo = pra_codper
				inner join ra_pon_ponderacion on pon_codigo = poo_codpon
				where poo_codcil = @codcil and pon_orden = @eval and per_anio_ingreso between @anio_carnet and @anio_carnet_fin

				if (@cuotas_canceladas > @numero_cuota)
					select -6 res, 'No puede solicitar prórroga porque estas solvente' texto
				else
				begin
					if @per_tipo_ingreso = 1
						set @cum = dbo.fn_cum_ciclo_notas(@codper, @codcil)--dbo.fn_cum_ciclo(@codper, @codcil)--223299
					else
						set @cum = dbo.fn_cum_limpio(@codper, 1)

					print '@alumnos_han_solicitado_prorroga: ' + cast(@alumnos_han_solicitado_prorroga as varchar(25)) +'/' +cast(@cantidad as varchar(5)) + ', con carnet entre los años ' + cast(@anio_carnet as varchar(5)) + ' al ' + cast(@anio_carnet_fin as varchar(5))
					print '@cum: ' + cast(@cum as varchar(25)) + ' @cum_minimo: ' + cast(@cum_minimo as varchar(10))
					print '@cuotas_canceladas: ' + cast(@cuotas_canceladas as varchar(5)) + ' @numero_cuota: ' + cast(@numero_cuota as varchar(10))
					print '@prorroga_sucesiva: ' + cast(@prorroga_sucesiva as varchar(5)) + ' @eval - 1: ' + cast((@eval - 1) as varchar(10)) + ' @ultima_eva_con_prorroga: ' + cast(@ultima_eva_con_prorroga as varchar(10))

					if (@alumnos_han_solicitado_prorroga >= @cantidad)
						select -1 res, @mensaje_negativo texto
					else if (@cum < @cum_minimo)
						select -2 res, 'Lo sentimos, pero no posee el CUM mínimo para este proceso' texto
					else if (@cuotas_canceladas < @numero_cuota)
						select -3 res, 'Lo sentimos, pero no se encuentra solvente con la cuota requisito para este proceso' texto
					else if (@prorroga_sucesiva = 0 and (((@eval - 1) = (@ultima_eva_con_prorroga ))))
						select -4 res, 'Lo sentimos, ya ha solicitado prórroga en la evaluación anterior' texto
					else
						select 0 res, @mensaje_afirmativo texto
				end
			end
			else
			begin
				select -5 res, 'Ya tienes prórroga solicitada para la evaluación' texto
			end
		end
		else
		begin
			select -2 res, 'No esta activa la prórroga' texto
		end