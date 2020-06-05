declare @codcil int = 122, @eva int = 3, @codpoo int = 0
		declare @pra_codigo_inicial int = 174831--Indica el código de la primera prórroga solicitada ya con las restricciones de año

		select @codpoo = poo_codigo from ra_poo_prorroga_otorgar where poo_codcil = @codcil and poo_codpon = @eva
		declare @tbl_data as table (anio int, cantidad int, solicitado_prorrogas_detalladas_anio int)
		
		insert into @tbl_data (anio, cantidad, solicitado_prorrogas_detalladas_anio)
		select anio, count(1) cantidad, sum(solicitado_prorrogas_detalladas_anio) solicitado_prorrogas_detalladas_anio 
		from (
			select SUBSTRING(per_carnet, 9, 4) anio, case when pra_codigo >= @pra_codigo_inicial then 1 else 0 end solicitado_prorrogas_detalladas_anio
			from ra_pra_prorroga_acad
			inner join ra_poo_prorroga_otorgar on poo_codigo = pra_codpoo
			inner join ra_per_personas on per_codigo = pra_codper
			where poo_codcil = @codcil and pra_codpoo = @codpoo --and pra_codigo >= 174831
		) t
		group by anio

		declare @tbl_data_res as table (anio_desde varchar(10), anio_hasta varchar(10), cantidad int, cantidad_prorrogas int, solicitado_prorrogas_detalladas_anio int)

		declare @pproac_codigo int, @pproac_anio_carnet int, @pproac_anio_carnet_fin int, @pproac_cantidad int
		declare mcursor cursor 
		for
			select pproac_codigo, pproac_anio_carnet, pproac_anio_carnet_fin, pproac_cantidad 
			from ra_pproac_parametros_prorrogas_anio_carnet 
			where pproac_numero_cuota = @eva--sera de asumir que el numero de cuota minima es igual a la evaluacion

		open mcursor 
		fetch next from mcursor into @pproac_codigo, @pproac_anio_carnet, @pproac_anio_carnet_fin, @pproac_cantidad
		while @@FETCH_STATUS = 0 
		begin
			insert into @tbl_data_res (anio_desde, anio_hasta, cantidad, cantidad_prorrogas, solicitado_prorrogas_detalladas_anio)
			select @pproac_anio_carnet, @pproac_anio_carnet_fin, @pproac_cantidad, 
			(select sum(cantidad) from @tbl_data where anio between @pproac_anio_carnet and @pproac_anio_carnet_fin),

			(select sum(solicitado_prorrogas_detalladas_anio) from @tbl_data where anio between @pproac_anio_carnet and @pproac_anio_carnet_fin)
			fetch next from mcursor into @pproac_codigo, @pproac_anio_carnet, @pproac_anio_carnet_fin, @pproac_cantidad
		end      
		close mcursor  
		deallocate mcursor
						
		select isnull(anio_desde, '') 'Desde años de carnet', isnull(anio_hasta, 'TOTALES.') 'Hasta años de carnet', 
		[Otorgadas con restricciones de años], 
		[Otorgadas sin restricción de años], [Total de prorrogas otorgadas], 
		[Cantidad definidas por años], [Prorrogas disponibles por años]  
		from (
			select [t], anio_desde, anio_hasta,
			sum(solicitado_prorrogas_detalladas_anio) 'Otorgadas con restricciones de años',
			sum(sin_restriccion) 'Otorgadas sin restricción de años',
			sum(total_otorgadas) 'Total de prorrogas otorgadas',
			sum(cantidad) 'Cantidad definidas por años',
			sum(disponibles_por_anio) 'Prorrogas disponibles por años'
			from (
				select 'TOTALES' 't', anio_desde, anio_hasta,
				solicitado_prorrogas_detalladas_anio,
				(cantidad_prorrogas - solicitado_prorrogas_detalladas_anio) sin_restriccion,
				cantidad_prorrogas total_otorgadas,
				cantidad,
				(cantidad - cantidad_prorrogas) disponibles_por_anio
				from @tbl_data_res
			) dat
			group by grouping sets((anio_desde, anio_hasta), ([t]))
		) tabla
		order by anio_desde desc