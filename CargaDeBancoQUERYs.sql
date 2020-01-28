-- drop table col_datb_data_bancos
create table col_datb_data_bancos (
	datb_data varchar(1000), 
	datb_codban int, 
	datb_fecha_creacion datetime default getdate()
)
-- select * from col_datb_data_bancos
ALTER procedure [dbo].[rep_col_caf_carga_archivo_final]
	-- =============================================
	-- Author:      <DESCONOCIDO>
	-- Create date: <DESCONOCIDO>
	-- Last Modify: 2019-10-31 08:54:13.580 Fabio
	-- Description: <Muestra los alumnos Cargados y no Cargados de pagos en Bancos‎‎ y los INSERTA a la tabla "archivo_bancos_final">
	-- =============================================
	-- rep_col_caf_carga_archivo_final '01/11/2019', '02/11/2019', 234959, 46, 'N', 'N'
	@fecha varchar(20),
	@fecha_archivo varchar(20),
	@factura int,
	@banco int, 
	@tipo_pago char(1),
	@px char(1)
as
begin
	set dateformat dmy
	declare @universidad varchar(200), @nombre_banco varchar(200), @puntoxpress varchar(50)
	select @puntoxpress = case when @px = 'S' then 'Puntoxpress' else '' end
	select @nombre_banco = ban_nombre from adm_ban_bancos where ban_codigo = @banco
	select @universidad = uni_nombre from ra_uni_universidad where uni_codigo = 1

	declare @pre_carga table(
		fecha datetime, 
		fecha_archivo datetime, 
		factura varchar(30),
		tipo varchar(4),
		banco int,
		valor money, 
		alumno varchar(20),
		cuota int,
		ciclo varchar(20),
		recibo varchar(50),
		codigo_carga varchar(60),
		puntoxpress bit
	)

	if @banco = 37 and @px = 'N'
	begin
		-- Davivienda 37
		delete from archivo_bancos_final 
		where fecha = @fecha and convert(varchar(20),fecha_archivo,103) = @fecha_archivo 
		and banco = @banco and puntoxpress = 0
		insert into @pre_carga (fecha,fecha_archivo,factura,tipo, banco,valor,alumno,cuota, ciclo,recibo,codigo_carga,puntoxpress)                                       
		select cast(@fecha as datetime) fecha, cast(@fecha_archivo as datetime) fecha_archivo, 
			isnull(@factura,0)+row_number() over (order by alumno) - 1 factura,
			@tipo_pago tipo, @banco banco, /*hora*/valor, alumno, cuota, ciclo, null recibo,
			codigo_carga, 0 puntoxpress
		from(
			select 
				substring(data,30,8) hora,
				cast(substring(data,46,6) as money) valor
				,substring(data,52,10) alumno
				,substring(data,62,1) cuota
				,substring(data,63,6) ciclo
				,0 estado
				,case when @px = 'S' then 'PX' when @px = 'N' then cast(@banco as varchar(10)) end+
				@tipo_pago+
				cast(datepart(day,@fecha) as varchar(20))+
				cast(datepart(month,@fecha) as varchar(20))+
				cast(datepart(year,@fecha) as varchar(20)) codigo_carga
			from dbo.archivo_salvador
			where len(substring(data,52,10)) = 10
		)t
	-- if @banco = 37 and @px = 'N'
	end if @banco = 33 and @px = 'N'
	begin 
		  --33 G&T
		  delete from archivo_bancos_final 
		  where convert(varchar(20),fecha ,103)  = @fecha and convert(varchar(20),fecha_archivo,103) = @fecha_archivo 
		  and banco = @banco and puntoxpress = 0
		  insert into @pre_carga (fecha,fecha_archivo,factura,tipo, banco,valor,alumno,cuota, ciclo,recibo,codigo_carga,puntoxpress)
	                                           
		  select cast(@fecha as datetime) fecha, cast(@fecha_archivo as datetime) fecha_archivo, 
			isnull(@factura,0)+row_number() over (order by alumno) - 1 factura,
			@tipo_pago tipo, @banco banco, /*hora*/valor, alumno, cuota, ciclo, null recibo,
			codigo_carga, 0 puntoxpress
		  from(
			select (cast(substring(data,24,5) as money)/100) valor, 
				substring(data,29,10) alumno, 
				substring(data,39,1) cuota,
				substring(data,40,6) ciclo
				,0 estado
				,case when @px = 'S' then 'PX' when @px = 'N' then cast(@banco as varchar(10)) end+
				@tipo_pago+
				cast(datepart(day,@fecha) as varchar(20))+
				cast(datepart(month,@fecha) as varchar(20))+
				cast(datepart(year,@fecha) as varchar(20)) codigo_carga
			from dbo.archivo_gt
			where len(data) = 45
		  )t
	-- end if @banco = 34 and @px = 'N'
	end if @banco = 33 and @px = 'N'
	begin
		  --34 Promerica Barras
		  delete from archivo_bancos_final 
		  where fecha = @fecha and convert(varchar(20),fecha_archivo,103) = @fecha_archivo 
		  and banco = @banco and puntoxpress = 0
		  insert into @pre_carga (fecha,fecha_archivo,factura,tipo, banco,valor,alumno,cuota, ciclo,recibo,codigo_carga,puntoxpress)                                               
		  select cast(@fecha as datetime) fecha, cast(@fecha_archivo as datetime) fecha_archivo, 
			isnull(@factura,0)+row_number() over (order by alumno) - 1 factura,
			@tipo_pago tipo, @banco banco, /*hora*/valor, alumno, cuota, ciclo, null recibo,
			codigo_carga, 0 puntoxpress
		  from(
			  select
				substring(data,12,8) hora
				,cast(substring(data,50,7) as money) valor
				,substring(data,31,10) alumno
				,substring(data,41,1) cuota
				,substring(data,42,6) ciclo
				,0 estado
				,case when @px = 'S' then 'PX' when @px = 'N' then cast(@banco as varchar(10)) end+
				@tipo_pago+
				cast(datepart(day,@fecha) as varchar(20))+
				cast(datepart(month,@fecha) as varchar(20))+
				cast(datepart(year,@fecha) as varchar(20)) codigo_carga
			  from dbo.archivo_promerica
			  where len(substring(data,31,10)) = 10
		  )t
	-- end if @banco = 33 and @px = 'N'
	end if @banco = 9 and @px = 'N'
	begin
		  --9 Citibank Barras
		  delete from archivo_bancos_final 
		  where fecha = @fecha and convert(varchar(20),fecha_archivo,103) = @fecha_archivo 
		  and banco = @banco and puntoxpress = 0
		  insert into @pre_carga (fecha,fecha_archivo,factura,tipo, banco,valor,alumno,cuota, ciclo,recibo,codigo_carga,puntoxpress)                                               
		  select cast(@fecha as datetime) fecha, cast(@fecha_archivo as datetime) fecha_archivo, 
			isnull(@factura,0)+row_number() over (order by alumno) - 1 factura,
			@tipo_pago tipo, @banco banco, /*hora*/valor, alumno, cuota, ciclo, null recibo,
			codigo_carga, 0 puntoxpress
		  from(
			  select substring(data,charindex('|',data)+1,charindex('|',substring(data,charindex('|',data)+1,len(data)))-1) hora,
				cast(substring(data,charindex('|',data)+charindex('|',substring(data,charindex('|',
								data)+1,len(data)))+1,charindex('|',substring(data,charindex('|',
								data)+charindex('|',substring(data,charindex('|',data)+1,len(data)))+1,len(data)))-1) as money) valor
				,substring(data,charindex('|',data)+charindex('|',substring(data,charindex('|',
								data)+1,len(data)))+charindex('|',substring(data,charindex('|',
								data)+charindex('|',substring(data,charindex('|',data)+1,len(data)))+1,len(data)))+1,10) alumno
				,substring(data,charindex('|',data)+charindex('|',substring(data,charindex('|',data)+1,
								len(data)))+charindex('|',substring(data,charindex('|',data)+charindex('|',
								substring(data,charindex('|',data)+1,len(data)))+1,len(data)))+11,1) cuota
				,substring(data,charindex('|',data)+charindex('|',substring(data,charindex('|',data)+1,
								len(data)))+charindex('|',substring(data,charindex('|',data)+charindex('|',
								substring(data,charindex('|',data)+1,len(data)))+1,len(data)))+12,6) ciclo
				,0 estado
				,case when @px = 'S' then 'PX' when @px = 'N' then cast(@banco as varchar(10)) end+
				@tipo_pago+
				cast(datepart(day,@fecha) as varchar(20))+
				cast(datepart(month,@fecha) as varchar(20))+
				cast(datepart(year,@fecha) as varchar(20)) codigo_carga
			  from archivo_cuscatlan
			  where len(substring(data,charindex('|',data)+charindex('|',substring(data,charindex('|',
										   data)+1,len(data)))+charindex('|',substring(data,charindex('|',
										   data)+charindex('|',substring(data,charindex('|',data)+1,len(data)))+1,len(data)))+1,10)) = 10
		  )t
	-- end if @banco = 9 and @px = 'N'
	end if @banco = 6 and @px = 'N'
	begin
		-- Banco Agricola
		if @tipo_pago = 'B'
		begin
			-- 6 Barras
			delete from archivo_bancos_final 
			where convert(varchar(20),fecha ,103)  = @fecha and convert(varchar(20),fecha_archivo,103) = @fecha_archivo 
			and banco = @banco and puntoxpress = 0 and tipo = @tipo_pago
			insert into @pre_carga (fecha,fecha_archivo,factura,tipo, banco,valor,alumno,cuota, ciclo,recibo,codigo_carga,puntoxpress)                                         
			select cast(@fecha as datetime) fecha, cast(@fecha_archivo as datetime) fecha_archivo, 
			isnull(@factura,0)+row_number() over (order by alumno) - 1 factura,
			@tipo_pago tipo, @banco banco, /*hora*/valor, alumno, cuota, ciclo, null recibo,
			codigo_carga, 0 puntoxpress
			from(
			select substring(data,8,8) hora,
					cast(substring(data,50,5) as money)/100 valor
					,substring(data,102,10) alumno
					,substring(data,112,1) cuota
					,substring(data,113,7) ciclo
					,0 estado
					,case when @px = 'S' then 'PX' when @px = 'N' then cast(@banco as varchar(10)) end+
					@tipo_pago+
					cast(datepart(day,@fecha) as varchar(20))+
					cast(datepart(month,@fecha) as varchar(20))+
					cast(datepart(year,@fecha) as varchar(20)) codigo_carga
			from archivo_agricola
			where len(substring(data,102,10)) = 10
			)t
            
		end if @tipo_pago = 'N'
		begin
			-- 6 NPE
			delete from archivo_bancos_final 
			where convert(varchar(20),fecha ,103)  = @fecha and convert(varchar(20),fecha_archivo,103) = @fecha_archivo 
			and banco = @banco and puntoxpress = 0 and tipo = @tipo_pago
			insert into @pre_carga (fecha,fecha_archivo,factura,tipo,banco,valor,alumno,cuota,ciclo,recibo,codigo_carga,puntoxpress)                                         
			select cast(@fecha as datetime) fecha, cast(@fecha_archivo as datetime) fecha_archivo, 
			isnull(@factura,0)+row_number() over (order by alumno) - 1 factura,
			@tipo_pago tipo, @banco banco, /*hora*/valor, alumno, cuota, ciclo, null recibo,
			codigo_carga, 0 puntoxpress
			from(
			select substring(data,8,8) hora,
				cast(substring(data,50,5) as money)/100 valor
				,substring(data,65,10) alumno
				,substring(data,75,1) cuota
				,substring(data,76,6) ciclo
				,0 estado
				,case when @px = 'S' then 'PX' when @px = 'N' then cast(@banco as varchar(10)) end+
				@tipo_pago+
				cast(datepart(day,@fecha) as varchar(20))+
				cast(datepart(month,@fecha) as varchar(20))+
				cast(datepart(year,@fecha) as varchar(20)) codigo_carga
			from archivo_agricola
			where len(substring(data,65,10)) = 10
			)t
            
		end
	-- end if @banco = 6 and @px = 'N'
	end if @banco = 38 and @px = 'N'
	begin
		  -- Scotiabank
		  delete from archivo_bancos_final 
		  where fecha = @fecha and convert(varchar(20),fecha_archivo,103) = @fecha_archivo 
		  and banco = @banco and puntoxpress = 0
		  insert into @pre_carga (fecha,fecha_archivo,factura,tipo, banco,valor,alumno,cuota, ciclo,recibo,codigo_carga,puntoxpress)                                               
		  select cast(@fecha as datetime) fecha, cast(@fecha_archivo as datetime) fecha_archivo, 
			isnull(@factura,0)+row_number() over (order by alumno) - 1 factura,
			@tipo_pago tipo, @banco banco, /*hora*/valor, alumno, cuota, ciclo, null recibo,
			codigo_carga, 0 puntoxpress
		  from(
		  select      @fecha_archivo +' '+ substring(data,11,2)+':'+substring(data,13,2)+':'+substring(data,15,2) fecha_archivo,
					  cast(substring(data,17,5) as money)/100 valor,
					  substring(data,22,10) alumno,
					  substring(data,32,1) cuota,
					  substring(data,33,6) ciclo,
					  case when @px = 'S' then 'PX' when @px = 'N' then cast(@banco as varchar(10)) end+
					  @tipo_pago+
					  cast(datepart(day,@fecha) as varchar(20))+
					  cast(datepart(month,@fecha) as varchar(20))+
					  cast(datepart(year,@fecha) as varchar(20)) codigo_carga,
					  case when @px = 'S' then 1 when @px = 'N' then 0 end puntoxpress
		  from archivo_scotiabank
		  where len(substring(data,22,10)) = 10
		  )t
	-- end if @banco = 38 and @px = 'N'
	end if @banco = 46 and @px = 'N' -- 46	CREDOMATIC cta 00200717619
	begin
		delete from archivo_bancos_final 
		where fecha = @fecha and convert(varchar(20),fecha_archivo,103) = @fecha_archivo 
		and banco = @banco and puntoxpress = 0
		
		insert into @pre_carga (fecha,fecha_archivo,factura,tipo, banco,valor,alumno,cuota, ciclo,recibo,codigo_carga,puntoxpress)     
		select cast(@fecha as datetime) fecha, cast(@fecha_archivo as datetime) fecha_archivo, 
			isnull(@factura,0)+row_number() over (order by alumno) - 1 factura,
			@tipo_pago tipo, @banco banco, valor, alumno, cuota, ciclo, null recibo,
			codigo_carga, 0 puntoxpress 
		from (
				select @fecha_archivo fecha_archivo,
					cast(substring(datb_data,5,6) as money)/100 valor
					,substring(datb_data,11,10) alumno
					,substring(datb_data,21,1) cuota
					,substring(datb_data,22,6) ciclo,
					case when @px = 'S' then 'PX' when @px = 'N' then cast(@banco as varchar(10)) end+
					@tipo_pago+
					cast(datepart(day,@fecha) as varchar(20))+
					cast(datepart(month,@fecha) as varchar(20))+
					cast(datepart(year,@fecha) as varchar(20)) codigo_carga,
					case when @px = 'S' then 1 when @px = 'N' then 0 end puntoxpress
				 from col_datb_data_bancos
				where datb_codban = @banco and  len(substring(datb_data,24,10)) >= 2
		)t
		
	end if @px = 'S'
	begin
		  -- Puntoxpress
		  delete from archivo_bancos_final 
		  where fecha = @fecha and convert(varchar(20),fecha_archivo,103) = @fecha_archivo 
		  and banco = @banco and puntoxpress = 1
		  insert into @pre_carga (fecha,fecha_archivo,factura,tipo, banco,valor,alumno,cuota, ciclo,recibo,codigo_carga,puntoxpress)                                               
		  select  cast(@fecha as datetime) fecha, cast(@fecha_archivo as datetime) fecha_archivo, 
			isnull(@factura,0)+row_number() over (order by alumno) - 1 factura,
			@tipo_pago tipo, @banco banco, /*hora*/valor, alumno, cuota, ciclo, recibo,
			codigo_carga, puntoxpress
		  from(
			  select @fecha_archivo +' '+ substring(data,11,2)+':'+substring(data,13,2)+':'+substring(data,15,2) fecha_archivo,
				cast(substring(data,17,5) as money)/100 valor,
				substring(data,22,10) alumno,
				substring(data,32,1) cuota,
				substring(data,33,6) ciclo,
				substring(data,39,11) recibo,
				case when @px = 'S' then 'PX' when @px = 'N' then cast(@banco as varchar(10)) end+
				@tipo_pago+
				cast(datepart(day,@fecha) as varchar(20))+
				cast(datepart(month,@fecha) as varchar(20))+
				cast(datepart(year,@fecha) as varchar(20)) codigo_carga,
				case when @px = 'S' then 1 when @px = 'N' then 0 end puntoxpress
			  from archivo_puntoxpress
			  where len(substring(data,22,10)) = 10
		  )t
	end -- end if @px = 'S'

	-- rep_col_caf_carga_archivo_final '31/10/2019', '01/11/2019', 43000, 38, 'N', 'N'
	--ESTA TABLA SE CREO PARA OBTENER BIEN EL CAMPO "alumno"(CARNET SIN QUIONES) Y EL CAMPO "ciclo"
	declare @pre_carga_carnet_ciclo table(fecha datetime,  fecha_archivo datetime,  factura varchar(30), tipo varchar(4), banco int, valor money,  
		codper int, alumno varchar(20), cuota int, codcil int, ciclo varchar(20), recibo varchar(50), codigo_carga varchar(60), puntoxpress bit, carnet varchar(16))

	insert into @pre_carga_carnet_ciclo (fecha, fecha_archivo, factura, tipo, banco, valor, codper, alumno, cuota, codcil, ciclo, recibo, codigo_carga, puntoxpress, carnet)
	select per_temp.fecha,per_temp.fecha_archivo,per_temp.factura,per_temp.tipo,per_temp.banco,per_temp.valor, per.per_codigo, cast(replace(per_carnet, '-', '') as varchar(20)) alumno, 
	per_temp.cuota,cil.cil_codigo,per_temp.ciclo,per_temp.recibo,per_temp.codigo_carga,per_temp.puntoxpress, replace(per_carnet, '-', '') carnet
	from @pre_carga as per_temp
	inner join ra_per_personas as per on  per.per_codigo = cast(per_temp.alumno as bigint) --or replace(per.per_carnet, '-', '') = per_temp.alumno
	inner join ra_cil_ciclo as cil on ('0'+cast(cil_codcic as varchar)+cast(cil_anio as varchar) =per_temp.ciclo)

	select *,
	case when (select dbo.fn_verifica_alumno_pre_gradro(codper,  0))='S'  
		THEN 'U'
	when (select dbo.fn_verifica_alumno_maestria(codper, codcil))='S'  
		THEN 'M'
	when (select dbo.fn_verifica_alumno_proc_graduacion(codper, codcil))='S'  
		THEN 'G'
	when (select dbo.fn_verifica_alumno_pre_especialidad(codper, codcil))='S'  
		THEN 'E'
	when (select dbo.fn_verifica_alumno_post_grado(codper, 0 ))='S'  
		THEN 'O'
	else 'N'-- Otros
	end Tipo_A
		into #pro
	from @pre_carga_carnet_ciclo

	insert into archivo_bancos_final(fecha,fecha_archivo,factura,tipo, banco,valor,alumno,cuota, ciclo,recibo,estado,codigo_carga,puntoxpress,tipo_a, abf_codper)
	select fecha,fecha_archivo,factura,tipo,banco,valor,cast(alumno as varchar(20)) alumno,cuota,ciclo,recibo,
	case  
		when  
			dbo.fn_verificar_validez_arancel_en_linea(valor,cast(cuota as int),Tipo_A)='S' and 
			dbo.fn_verificar_arancel_alumno_en_linea(carnet, ciclo, cast(cuota as int), valor,Tipo_A)='N' and 
			dbo.fn_verificar_validez_alumno(carnet) ='S'
		then 0 -- Correcto
		else 1 --No se cargara
	end estado, codigo_carga,puntoxpress,tipo_a, codper
	from #pro
	drop table #pro
end

ALTER procedure [dbo].[rep_col_prcb_preliminar_carga_bancos]
	-- =============================================
	-- Author:      <DESCONOCIDO>
	-- Create date: <DESCONOCIDO>
	-- Last Modify: 2019-10-30 22:06:53.580 Fabio
	-- Description: <Reporte preliminar de carga banco‎>
	-- =============================================
	-- exec rep_col_prcb_preliminar_carga_bancos 46, 'N', 'N'
	@banco int, --codban
	@tipo_pago char(1), --B: Barras, N: NPE
	@px char(1)--Punto Express, S: Si, N: No
as
begin
	--"codban": "9"{"codban": "9", "tabla": "archivo_cuscatlan"},
	--"codban": "6"{"codban": "6", "tabla": "archivo_agricola"},
	--"codban": "34"{"codban": "34", "tabla": "archivo_promerica"},
	--"codban": "37"{"codban": "37", "tabla": "archivo_salvador"},
	--"codban": "33"{"codban": "33", "tabla": "archivo_gt"},
	--"codban": "38"{"codban": "38", "tabla": "archivo_scotiabank"},
	--"codban": "46"{"codban": "46", "tabla": "col_datb_data_bancos"},
	--"codban": "Puntoxpress"{"codban": "Puntoxpress", "tabla": "archivo_puntoxpress"}
	
	declare @universidad varchar(200), @nombre_banco varchar(200), @puntoxpress varchar(50)
	declare @data_preliminar as table (id_preliminar int primary key identity(1, 1), valor money, alumno varchar(14), cuota varchar(10), ciclo varchar(10))

	select @puntoxpress = case when @px = 'S' then 'Puntoxpress' else '' end

	select @nombre_banco = ban_nombre from adm_ban_bancos where ban_codigo = @banco
	select @universidad = uni_nombre from ra_uni_universidad where uni_codigo = 1

	if @banco = 38 and @px = 'N' -- 38: SCOTIABANK CTA.COLECTORES
	begin
		insert into @data_preliminar(valor, alumno, cuota, ciclo)
		select 
			cast(substring(data,17,5) as money)/100 valor,
			substring(data,22,10) alumno,
			substring(data,32,1) cuota,
			substring(data,33,6) ciclo
		from archivo_scotiabank
		where len(substring(data,22,10)) = 10

	end if @banco = 37 and @px = 'N'-- 37	DAVIVIENDA CUENTA 068-51-00091-97
	begin
		insert into @data_preliminar(valor, alumno, cuota, ciclo)
		select
			cast(substring(data,46,6) as money) valor
			,substring(data,52,10) alumno
			,substring(data,62,1) cuota
			,substring(data,63,6) ciclo
		from dbo.archivo_salvador
		where len(substring(data,52,10)) = 10
	end if @banco = 33 and @px = 'N'--33	BANCO  G & t CONTINENTAL
	begin
		insert into @data_preliminar(valor, alumno, cuota, ciclo)
		select (cast(substring(data,24,5) as money)/100) valor, 
			substring(data,29,10) alumno, 
			substring(data,39,1) cuota,
			substring(data,40,6) cuota
		from archivo_gt
		where len(data) = 45

	end if @banco = 34 and @px = 'N' -- 34	BANCO PROMERICA  (CTA.INTEGRA PLUS)
	begin
		insert into @data_preliminar(valor, alumno, cuota, ciclo)
		select
			cast(substring(data,50,7) as money) valor
			,substring(data,31,10) alumno
			,substring(data,41,1) cuota
			,substring(data,42,6) ciclo
		from dbo.archivo_promerica
		where len(substring(data,31,10)) = 10

	end if @banco = 9 and @px = 'N' --9	CUSCATLAN CUENTA 043-301-00-000009-2
	begin
		insert into @data_preliminar(valor, alumno, cuota, ciclo)
		select 
			cast(substring(data,charindex('|',data)+charindex('|',substring(data,charindex('|',
								data)+1,len(data)))+1,charindex('|',substring(data,charindex('|',
								data)+charindex('|',substring(data,charindex('|',data)+1,len(data)))+1,len(data)))-1) as money) valor
			,substring(data,charindex('|',data)+charindex('|',substring(data,charindex('|',
								data)+1,len(data)))+charindex('|',substring(data,charindex('|',
								data)+charindex('|',substring(data,charindex('|',data)+1,len(data)))+1,len(data)))+1,10) alumno
			,substring(data,charindex('|',data)+charindex('|',substring(data,charindex('|',data)+1,
								len(data)))+charindex('|',substring(data,charindex('|',data)+charindex('|',
								substring(data,charindex('|',data)+1,len(data)))+1,len(data)))+11,1) cuota
			,substring(data,charindex('|',data)+charindex('|',substring(data,charindex('|',data)+1,
								len(data)))+charindex('|',substring(data,charindex('|',data)+charindex('|',
								substring(data,charindex('|',data)+1,len(data)))+1,len(data)))+12,6) ciclo
		from archivo_cuscatlan
		where len(substring(data,charindex('|',data)+charindex('|',substring(data,charindex('|',
									  data)+1,len(data)))+charindex('|',substring(data,charindex('|',
									  data)+charindex('|',substring(data,charindex('|',data)+1,len(data)))+1,len(data)))+1,10)) = 10

	end if @banco = 6 and @px = 'N' -- 6	AGRICOLA, S.A.
	begin
		  if @tipo_pago = 'B' -- 6	AGRICOLA, S.A. BARRAS
		  begin
				insert into @data_preliminar(valor, alumno, cuota, ciclo)
				select 
					cast(substring(data,50,5) as money)/100 valor
					,substring(data,102,10) alumno
					,substring(data,112,1) cuota
					,substring(data,113,7) ciclo
				from archivo_agricola
				where len(substring(data,102,10)) = 10

		  end if @tipo_pago = 'N' -- 6	AGRICOLA, S.A. NPE
		  begin
				
				insert into @data_preliminar(valor, alumno, cuota, ciclo)
				select 
					cast(substring(data,50,5) as money)/100 valor
					,substring(data,65,10) alumno
					,substring(data,75,1) cuota
					,substring(data,76,6) ciclo
				from archivo_agricola
				where len(substring(data,65,10)) = 10
		  end
	--end if @banco = 6 and @px = 'N'
	end if @banco = 46 and @px = 'N' --CREDOMATIC cta 00200717619
	begin
		insert into @data_preliminar(valor, alumno, cuota, ciclo)
		select 
			cast(substring(datb_data,5,6) as money)/100 valor
			,substring(datb_data,11,10) alumno
			,substring(datb_data,21,1) cuota
			,substring(datb_data,22,6) ciclo
		from col_datb_data_bancos
		where datb_codban = @banco
	end if @px = 'S'
	begin
		  insert into @data_preliminar(valor, alumno, cuota, ciclo)
		  select 
			cast(substring(data,17,5) as money)/100 valor,
			substring(data,22,10) alumno,
			substring(data,32,1) cuota,
			substring(data,33,6) ciclo
		  from archivo_puntoxpress
		  where len(substring(data,22,10)) = 10
	end

	select dat.universidad, dat.banco, dat.puntoxpress, dat.valor, replace(per_carnet, '-', '') alumno, dat.cuota, dat.ciclo from (
		select @universidad universidad,@nombre_banco banco, @puntoxpress puntoxpress, valor, alumno,cuota,ciclo, cast (alumno as varchar(12)) 'codper_o_carnet'
		from @data_preliminar
	) dat
	inner join ra_per_personas on per_codigo  = cast(dat.codper_o_carnet as bigint)-- or replace(per_carnet, '-', '') = dat.codper_o_carnet --and per_estado = 'A'

ALTER procedure [dbo].[rep_col_rec_resumen_carga] 
	-- =============================================
	-- Author:      <DESCONOCIDO>
	-- Create date: <DESCONOCIDO>
	-- Last Modify: 2019-10-30 22:54:53.580 Fabio
	-- Description: <Reporte de Alumnos Cargados y no Cargados de pagos en Bancos‎‎>
	-- =============================================
	-- rep_col_rec_resumen_carga '31/10/2019', '01/11/2019', 46, 'N', 'N'
	@fecha varchar(20), 
	@fecha_archivo varchar(20), 
	@banco int, --codban
	@px char(1),  --Punto Express, S: Si, N: No
	@tipo_pago char(1) --B: Barras, N: NPE
as
begin
	set dateformat dmy
	declare @universidad varchar(200)
	select @universidad = uni_nombre from ra_uni_universidad where uni_codigo = 1
	--select * from ra_per_personas where  replace(per_carnet, '-', '') = '0000110717' or per_codigo  = cast('0000110717' as bigint) 
	select @universidad universidad,
	isnull(
		(
			select per_nombres_apellidos 
			from ra_per_personas 
			where /*replace(per_carnet, '-', '') = alumno or*/ per_codigo  = cast(alumno as bigint) --and per_tipo not in('TI', 'DU', 'D')--SUBSTRING(alumno,1,2)+'-'+SUBSTRING(alumno,3,4)+'-'+SUBSTRING(alumno,7,4)
		),
		'CARNET NO ENCONTRADO'
	) nombres,
	isnull(
		(
			select replace(per_carnet, '-', '') 
			from ra_per_personas 
			where /*replace(per_carnet, '-', '') = alumno or */per_codigo  = cast(alumno as bigint) --and per_tipo not in('TI', 'DU', 'D')
		),
		'NO ENCONTRADO'
	) alumno,
	factura, tipo, banco, valor, cuota, ciclo,
	case when estado = 0 then 'CORRECTO' when estado = 1 then 'NO SE CARGARA' end estado,
	case when puntoxpress = 0 then ban_nombre  when puntoxpress = 1 then ban_nombre +' PUNTOXPRESS' end                          
	nombre_banco, fecha as fecha_banco, fecha_archivo as fecha_colecturia 
	from archivo_bancos_final 
		join adm_ban_bancos on ban_codigo = banco 
	where banco = @banco and puntoxpress = case when @px = 'N' then 0 when @px = 'S' then 1 end 
		and fecha = @fecha 
		and convert(varchar(20),fecha_archivo,103) = @fecha_archivo 
		and tipo = @tipo_pago 
	order by estado desc    
end

ALTER procedure [dbo].[col_vaf_validacion_facturas]
	-- =============================================
	-- Author:      <DESCONOCIDO>
	-- Create date: <DESCONOCIDO>
	-- Last Modify: 2019-10-31 08:19:53.580 Fabio
	-- Description: <Valida que no se haya ingresado el pago de la Cargada de pago en Bancos‎‎>
	-- =============================================
	-- col_vaf_validacion_facturas '16/11/2019', '17/11/2019', 37, 'N', 'N', 254372
	@fecha varchar(20),
	@fecha_archivo varchar(20),
	@banco int, 
	@tipo_pago char(1),
	@px char(1),
	@factura int
as
begin
	set dateformat dmy
	declare @cantidad int,  @lote varchar(5), @factura_final int, @bandera int

	select @lote = tit_lote
	from col_tit_tiraje
	where tit_tpodoc = 'F'
	and tit_mes = month(@fecha) and tit_anio = year(@fecha)
	and tit_codreg = 1 and tit_estado = 1
	print '@lote : ' + cast(@lote as nvarchar(5))

	select @cantidad = count(alumno)
	from archivo_bancos_final 
	where banco = @banco and puntoxpress = case when @px = 'N' then 0 when @px = 'S' then 1 end
	and fecha = @fecha and convert(varchar(20),fecha_archivo,103) = @fecha_archivo
	and tipo = @tipo_pago and estado = 0

	set @factura_final = (@cantidad - 1) + @factura

	print @cantidad
	print @factura
	print @factura_final

	select @bandera = count(mov_recibo) 
	from col_mov_movimientos 
	where cast(mov_recibo  as int) between @factura and @factura_final 
	and mov_lote = @lote and mov_estado <> 'A'

	select @bandera bandera
end

-- drop table col_ttpcb_tabla_temporal_carga_bancos
create table col_ttpcb_tabla_temporal_carga_bancos (
	ttpcb_codigo int primary key identity(1,1), 
	ttpcb_codper int, 
	ttpcb_npe varchar(50), 
	ttpcb_resultado int, 
	ttpcb_mensaje varchar(50), 
	ttpcb_usuario_transaccion varchar(50),
	ttpcb_fecha_hora_creacion datetime default getdate()
)
-- select * from col_ttpcb_tabla_temporal_carga_bancos

alter procedure [dbo].[col_inserta_carga_bancos] 
	-- =============================================
	-- Author:      <DESCONOCIDO>
	-- Create date: <DESCONOCIDO>
	-- Last Modify: 2019-10-30 23:28:11.271 Fabio
	-- Description: <Aplicacion de saldos de la carga paga de bancos>
	-- =============================================
	-- exec col_inserta_carga_bancos 30/10/2019', '01/10/2019', 38, 'N', 'N', 'carlos.rivas' --soctiabnak
	-- exec col_inserta_carga_bancos '11/11/2019', '11/11/2019', 38, 'N', 'N', 'fabio.ramos'
	-- exec col_inserta_carga_bancos '11/11/2019', '02/11/2019', 46, 'N', 'N', 'fabio.ramos' --credomatick
	@fecha varchar(20),
	@fecha_archivo varchar(20),
	@banco int, --codban
	@tipo_pago char(1), --B: Barras, N: NPE
	@px char(1), --Punto Express, S: Si, N: No
	@usuario varchar(100)
as
begin
	set nocount on
	set dateformat dmy
	--select fecha, fecha_archivo, factura, tipo, banco, valor, cuota, alumno, ciclo, recibo, codigo_carga, puntoxpress,tipo_a
	--		from archivo_bancos_final 
	--	where banco = @banco 
	--	and puntoxpress = case when @px = 'N' then 0 when @px = 'S' then 1 end
	--	and convert(varchar(20),fecha,103)=@fecha
	--	and convert(varchar(20),fecha_archivo,103) = @fecha_archivo
	--	and tipo = @tipo_pago
	--	and estado = 0
	begin try
		declare @fecha_c datetime, @fecha_archivo_c datetime, 
		@factura_c varchar(50), @tipo char(1), 
		@banco_c int, @valor money, 
		@cuota int, @alumno varchar(50),
		@ciclo varchar(20), @recibo varchar(50), 
		@codigo_carga varchar(50), @puntoxpress int,
		@tipo_a varchar(2)
		
		declare cPagos cursor for
		select fecha, fecha_archivo, factura, tipo, banco, valor, cuota, alumno, ciclo, recibo, codigo_carga, puntoxpress,tipo_a
			from archivo_bancos_final 
		where banco = @banco 
		and puntoxpress = case when @px = 'N' then 0 when @px = 'S' then 1 end
		and convert(varchar(20),fecha,103)=@fecha
		and convert(varchar(20),fecha_archivo,103) = @fecha_archivo
		and tipo = @tipo_pago
		and estado = 0

		declare @lote varchar(10), @contador int, @total_procesado money
		set @contador = 0
		set @total_procesado = 0

		select @lote = tit_lote from col_tit_tiraje where tit_tpodoc = 'F' and tit_mes = month(@fecha) and tit_anio = year(@fecha) and tit_codreg = 1 and tit_estado = 1
		declare @npe varchar(50) = '',
			@codpal int = 0, --codigo de la tabla "col_pal_pagos_linea"
			@referencia varchar(50) = '',
			@carnet varchar (14) = '',
			@per_codigo int = 0

		declare @npes as table (
				alumno varchar(255), carnet varchar(16), carrera varchar(255), npe varchar(84), monto money, 
				descripcion varchar(55), estado int, tmo_arancel varchar(8), fel_fecha_mora nvarchar(12), ciclo int, mciclo nvarchar(12))
		declare @resultado int = 0
		open cPagos
		fetch cPagos into @fecha_c, @fecha_archivo_c, @factura_c, @tipo, @banco_c, @valor, @cuota, @alumno, @ciclo, @recibo, @codigo_carga ,@puntoxpress,@tipo_a
		while (@@fetch_STATUS = 0)
		begin
			delete from @npes
			set @carnet  = substring(@alumno,1,2)+'-'+substring(@alumno,3,4)+'-'+substring(@alumno,7,4)
			print '@carnet ' + cast(@carnet as varchar(14))
			print '@cuota ' + cast(@cuota as varchar(14))
			select @per_codigo = per_codigo from ra_per_personas where per_carnet = @carnet
			---2 Intentar realizar nuevamente la transacción
			---1 NPE no existe ...
			--0 La cuota ya estaba cancelada con anterioridad
			--1 Transacción generada de forma satisfactoria
			--2 No se pudo generar la transacción			
			insert into @npes (alumno, carnet, carrera, npe, monto, descripcion, estado, tmo_arancel, fel_fecha_mora, ciclo, mciclo)
			exec sp_consulta_pago_x_carnet_estructurado 1, @carnet

			select @npe = npe from @npes where substring(npe,21,1) = @cuota --Se optiene el NPE que corresponde a la cuota "@cuota"
			print 'sp_insertar_pagos_x_carnet_estructurado_carga_banco '+cast(@npe as varchar(60))+ ', ' + cast(@banco as varchar(60))+ ', ' + cast(@factura_c as varchar(60))+ ', ' + cast(@usuario as varchar(60))+ ', ' + convert(varchar(20),@fecha_c,103)+ ', ' + convert(varchar(20),@fecha_archivo_c,103)
			if @npe != ''
			begin
				print 'NPE != ""'
				exec sp_insertar_pagos_x_carnet_estructurado_carga_banco @npe, @banco, @factura_c, @usuario, @fecha_archivo_c, @fecha_c, @per_codigo--'0313012000000016365580120190', 46, 430000, 'fabio.ramos', '07/11/2019', '01/11/2019'
				select @resultado = isnull(ttpcb_resultado, 0) from col_ttpcb_tabla_temporal_carga_bancos where ttpcb_codigo = (select max(t.ttpcb_codigo) from col_ttpcb_tabla_temporal_carga_bancos as t)
				print '@resultado ' + cast(@resultado as varchar)
			end --end if @npe != ''

			if @resultado = 1
			begin
				print '***********Transacción generada de forma satisfactoria***********'
				print ''
				set @total_procesado = @total_procesado + @valor
				set @contador = @contador + 1
			end
			else
			begin
				print '***********Transacción fallo***********'
				print ''
			end

			fetch cPagos into @fecha_c,@fecha_archivo_c, @factura_c, @tipo, @banco_c, @valor, @cuota, @alumno, @ciclo, @recibo, @codigo_carga,@puntoxpress,@tipo_a
		end -- while (@@fetch_STATUS = 0 )
		
		close cPagos
		deallocate cPagos
		select 'se procesaron ' + cast(@contador as varchar(20))+ ' registros, con un monto de: $'+cast (@total_procesado as varchar(20)) resultado
	end try
	begin catch
		print 'Se ha producido un error!'
		select 'Se ha producido un error con algunos registros de la carga pagos de bancos y esos datos no han sido aplicados al sistema, '+
		'es probable que el archivo contenga informacion incorrecta es por eso que se ha omitido registros, '+
		'favor de  comuniquese con la Direccion de Informatica' resultado, error_message(), error_number(), error_severity(), error_state(), error_procedure(), error_line()

	end catch
end
alter procedure [dbo].[sp_insertar_pagos_x_carnet_estructurado_carga_banco]
	-- exec sp_insertar_pagos_x_carnet_estructurado_carga_banco '0313006300000017655160220198', 46, '2349525', 'fabio.ramos', '06/11/2019', '02/11/2019'
	@npe varchar(50),
	@tipo int,--codban
	@referencia varchar(50), --numero de factura
	@usuario varchar(50), --codusr
	@fecha_c datetime, 
	@fecha_archivo_c datetime,
	@per_codigo int
as
begin
	set dateformat dmy
	declare @respuesta int
	declare @IdGeneradoPreviaPagoOnLine int	
	declare @codper_previo int
	select @codper_previo = @per_codigo--cast(substring(@npe,11,10) as int) --	El codper inicia en la posicion 11 del npe

	------------- Agregado para corroborar intentos de pago --------------------
    ------------------------------ Inicio --------------------------------------
	declare @carnet_previa nvarchar(15), @carnet nvarchar(15), @per_tipo nvarchar(10)
	print 'Verificando el tipo de estudiante'

	select @carnet_previa = per_carnet,
		@per_tipo = per_tipo
	from ra_per_personas 
	where per_codigo = @codper_previo
	
	set @carnet = @carnet_previa

    insert into previa_pago_online (ppo_carnet, ppo_npe, ppo_tipo)
    values(@carnet_previa, @npe, @tipo)

	set @IdGeneradoPreviaPagoOnLine = scope_identity()
	print '@IdGeneradoPreviaPagoOnLine : ' + cast(@IdGeneradoPreviaPagoOnLine as nvarchar(10))
	print '-----------------------------'
    -------------------------------- Fin ---------------------------------------
    ------------- Agregado para corroborar intentos de pago --------------------

	declare @MontoPagado float, @codper_encontrado int
	set @MontoPagado = 0
	set @codper_encontrado = 0
	declare @Mensaje nvarchar(50)

	declare @alumno_encontrado tinyint
	set @alumno_encontrado = 0
	declare @CorrelativoGenerado int
	set @CorrelativoGenerado = 0

	declare @npe_valido int
	set @npe_valido = 0

	declare @portafolio_tecnicos_pre float
	set @portafolio_tecnicos_pre = 0
	
	declare @npe_mas_antiguo nvarchar(100)
	--select @carnet = substring(@npe,11,2) + '-' + substring(@npe,13,4) + '-' + substring(@npe,17,4)  

	print 'NPE Ingresado : ' + @npe
	-- Tabla donde se obtiene el NPE mas antiguo, para evitar que el estudiante pague cuotas "salteadas"
	declare @temp table (
		alumno varchar(150),
		carnet varchar(20),
		carrera varchar(150),
		npe nvarchar(50),
		monto varchar(15),
		descripcion varchar(250),
		estado varchar(2),
		tmo_arancel nvarchar(10),
		fel_fecha_mora nvarchar(10),
		ciclo int,
		mciclo nvarchar(10)
	)
	insert into @temp 
	exec sp_consulta_pago_x_carnet_estructurado 2, @carnet

	print '----- NPE Obtenido mas antiguo segun la fecha de pago : ' 
	select @npe_mas_antiguo = npe from @temp
	print @npe_mas_antiguo

	if @npe = @npe_mas_antiguo
	begin
		print 'Es el mismo NPE que quiere pagar el estudiante'
	end
	else
	begin
		set @npe = @npe_mas_antiguo
		print 'Es NPE es diferente, se asigno el mas antiguo para que se pague por el estudiante'
	end
	print '---------------------------------------------------------'

	begin transaction 
	begin try
		/*Variables para el encabezado de factura */
			declare
				@mov_codreg int,
				@mov_codigo int,
				@mov_recibo int,
				@mov_codcil int,
				@mov_codper int,
				@mov_descripcion nvarchar(50),
				@mov_tipo_pago nvarchar(3),
				@mov_cheque nvarchar(20),
				@mov_estado nvarchar(3),
				@mov_tarjeta nvarchar(25),
				@mov_usuario nvarchar(30),
				@mov_codmod int,
				@mov_tipo nvarchar(3),
				@mov_historia nvarchar(3),
				@mov_codban int = @tipo,
				@mov_forma_pago nvarchar(5),
				@mov_lote int, 
				@mov_puntoxpress int, 
				@mov_recibo_puntoxpress nvarchar(20) = null,
				@mov_fecha datetime,
				@mov_fecha_registro datetime,
				@mov_fecha_cobro datetime

			declare 
				@tmo_valor_mora float, 
				@tmo_valor float

			set @mov_codreg = 1
			set @mov_recibo = @referencia--0
			set @mov_tipo_pago = 'B'
			set @mov_cheque = ''
			set @mov_estado = 'R'
			set @mov_tarjeta = ''
			set @mov_tipo = 'F'
			set @mov_forma_pago = 'E'
			set @mov_fecha = @fecha_archivo_c
			set @mov_fecha_registro = getdate()
			set @mov_fecha_cobro = @fecha_c
			
		/*Fin de variables para el encabezado de factura */
		
		/*Variables para el detalle de factura */
			declare
			@dmo_codreg int,
			@dmo_codmov int,
			@dmo_codigo int,
			@dmo_codtmo int,
			@dmo_cantidad int,
			@dmo_valor float,
			@dmo_codmat nvarchar(10),
			@dmo_iva float,
			@dmo_descuento float, 
			@dmo_mes int,
			@dmo_codcil int,
			@dmo_cargo float,
			@dmo_abono float,
			@dmo_eval int,
			@mov_coddip int,
			@mov_codfea int,
			@mov_codmdp int

			set @dmo_codreg = 1
			set @dmo_codmat = ''
			set @dmo_mes = 0
			set @dmo_eval = 0
			set @dmo_cantidad = 1
			set @dmo_descuento = 0
			set @mov_coddip = 0
			set @mov_codfea = 0
			set @mov_codmdp = 0
			set @mov_historia = 'N'
			set @mov_codmod = 0
		/*Fin de variables para el encabezado de factura */

			declare @corr_mov int
			declare @corr_det int
			declare @verificar_recargo_mora int
			set @verificar_recargo_mora = 0	--	0 no paga mora
			declare @monto float
			set @monto = 0
			-- *********************************************************************************************************************************
			-- Definimos quien hara los pagos segun configuracion de tabla
			declare @opcion tinyint

			declare @fecha_vencimiento datetime
			set @opcion = 2	--	Inserta el pago

			declare @paga_mora tinyint
			set @paga_mora = 0	--	0: no paga mora
			declare @dias_vencido int

			set dateformat dmy

			declare --@usuario varchar(200), 
				@banco int, @pal_codigo int,
			@descripcion varchar(200)
	
			select	--@usuario = pal_usuario, 
					@banco = '', 
					@descripcion = 'carga Bancos', 
					@pal_codigo = ''
			--from col_pal_pagos_linea where pal_codigo = @tipo
			--set @mov_codban = @banco

			declare @lote nvarchar(10)

			select @lote = tit_lote
			from col_tit_tiraje
			where tit_tpodoc = 'F' and tit_mes = month(getdate()) and tit_anio = year(getdate()) and tit_codreg = 1 and tit_estado = 1

			declare @corr int, @cil_codigo int--, @per_codigo int
			declare @codper int, @codtmo int, @codcil int, @origen int, @codvac int
			declare @carrera nvarchar(100), @arancel_beca nvarchar(10), @nombre nvarchar(100), @descripcion_arancel nvarchar(100), 
				@npe_sin_mora nvarchar(75), @npe_con_mora nvarchar(75)
			declare @fecha_sin_mora DATE, @fecha_con_mora DATE, @monto_con_mora float, @monto_sin_mora float

			declare @DatosPago table (alumno nvarchar(80), carnet nvarchar(15), carrera nvarchar(125), npe nvarchar(30), monto float, descripcion nvarchar(125), estado int)

			declare @codtmo_descuento int, @monto_descuento float, @monto_arancel_descuento float 
			declare @pago_realizado int
			set @pago_realizado = 0

			declare @verificar_cuota_pagada int	--	Almacena si la cuota se encuentra pagada
			set @verificar_cuota_pagada = 0
			declare @arancel nvarchar(10)
			declare @TipoEstudiante nvarchar(50)
			if (@per_tipo = 'M')
			begin
				print 'Alumno es de MAESTRIAS'
				set @TipoEstudiante = 'Maestrias'
				if exists(select 1 from col_art_archivo_tal_mae_mora where npe = @npe or npe_mora = @npe)
				begin
					select @codper = data.per_codigo, @codtmo = tmo.tmo_codigo, @arancel = tmo.tmo_arancel, @codcil = data.ciclo, @carnet = data.per_carnet,
						@carrera = data.pla_alias_carrera, @nombre = data.per_nombres_apellidos, @monto_con_mora = data.cuota_pagar_mora,
						@monto_sin_mora = data.cuota_pagar, @fecha_sin_mora = data.fel_fecha, @fecha_con_mora = data.fel_fecha_mora, @descripcion_arancel = tmo.tmo_descripcion,
						@npe_sin_mora = npe, @npe_con_mora = npe_mora, @origen = origen, @arancel_beca = isnull(tmo_arancel_beca,'-1'), @codvac = isnull(fel_codvac,-1),
						@tmo_valor = data.tmo_valor, @tmo_valor_mora = data.tmo_valor_mora
					from col_art_archivo_tal_mae_mora as data inner join col_tmo_tipo_movimiento as tmo on 
						tmo.tmo_arancel = data.tmo_arancel
					where npe = @npe or npe_mora = @npe
					set @npe_valido = 1
				end	--	if exists(select 1 from col_art_archivo_tal_mae_mora where npe = @npe or npe_mora = @npe)
			end	--	if (@per_tipo = 'M')

			if (@per_tipo = 'O') or (@per_tipo = 'CE')
			begin
				if @per_tipo = 'O'
				begin
					set @TipoEstudiante = 'POST GRADOS de MAESTRIAS'
				end
				if @per_tipo = 'CE'
				begin
					set @TipoEstudiante = 'CURSO ESPECIALIZADO de MAESTRIAS'
				end

				if exists(select 1 from col_art_archivo_tal_mae_posgrado where npe = @npe or npe_mora = @npe)
				begin
					select @codper = data.per_codigo, @codtmo = tmo.tmo_codigo, @arancel = tmo.tmo_arancel, @codcil = data.ciclo, @carnet = data.per_carnet,
						@carrera = data.pla_alias_carrera, @nombre = data.per_nombres_apellidos, @monto_con_mora = data.cuota_pagar_mora,
						@monto_sin_mora = data.cuota_pagar, @fecha_sin_mora = data.fel_fecha, @fecha_con_mora = data.fel_fecha_mora, @descripcion_arancel = tmo.tmo_descripcion,
						@npe_sin_mora = npe, @npe_con_mora = npe_mora, @origen = -1, @arancel_beca = '-1', @codvac = -1,
						@tmo_valor = data.tmo_valor, @tmo_valor_mora = data.tmo_valor_mora
					from col_art_archivo_tal_mae_posgrado as data inner join col_tmo_tipo_movimiento as tmo on 
						tmo.tmo_arancel = data.tmo_arancel
					where npe = @npe or npe_mora = @npe
					set @npe_valido = 1
				end	--	if exists(select 1 from col_art_archivo_tal_mae_posgrado where npe = @npe or npe_mora = @npe)
			end	--	if (@per_tipo = 'O') or (@per_tipo = 'CE')

			if (@per_tipo = 'U')
			begin
				print 'Alumno es de PRE-GRADO'
	
				if exists(select 1 from col_art_archivo_tal_mora where npe = @npe or npe_mora = @npe)
				begin
					set @npe_valido = 1
					set @alumno_encontrado = 1
					set @TipoEstudiante = 'PRE GRADO'
					select @codper = data.per_codigo, @codtmo = tmo.tmo_codigo, @arancel = tmo.tmo_arancel, @codcil = data.ciclo, @carnet = data.per_carnet,
						@carrera = data.pla_alias_carrera, @nombre = data.per_nombres_apellidos, @monto_con_mora = data.tmo_valor_mora,
						@monto_sin_mora = data.tmo_valor, @fecha_sin_mora = data.fel_fecha, @fecha_con_mora = data.fel_fecha_mora, @descripcion_arancel = tmo.tmo_descripcion,
						@npe_sin_mora = npe, @npe_con_mora = npe_mora, @origen = -1, @arancel_beca = '-1', @codvac = -1,
						@tmo_valor = data.tmo_valor, @tmo_valor_mora = data.tmo_valor_mora, 
						@codtmo_descuento = isnull(codtmo_descuento,-1), @monto_descuento = monto_descuento, @monto_arancel_descuento = monto_arancel_descuento
					from col_art_archivo_tal_mora as data inner join col_tmo_tipo_movimiento as tmo on 
						tmo.tmo_arancel = data.tmo_arancel
					where npe = @npe or npe_mora = @npe
				end	--	if exists(select 1 from col_art_archivo_tal_mora where npe = @npe or npe_mora = @npe)

				if @alumno_encontrado = 0
				begin
					if exists(select 1 from col_art_archivo_tal_preesp_mora where npe = @npe or npe_mora = @npe)
					begin
						set @npe_valido = 1
						set @alumno_encontrado = 1
						set @TipoEstudiante = 'PRE ESPECIALIDAD CARRERA'
						select @codper = data.per_codigo, @codtmo = tmo.tmo_codigo, @arancel = tmo.tmo_arancel, @codcil = data.ciclo, @carnet = data.per_carnet,
							@carrera = data.pla_alias_carrera, @nombre = data.per_nombres_apellidos, @monto_con_mora = data.tmo_valor_mora,
							@monto_sin_mora = data.tmo_valor, @fecha_sin_mora = data.fel_fecha, @fecha_con_mora = data.fel_fecha_mora, @descripcion_arancel = tmo.tmo_descripcion,
							@npe_sin_mora = npe, @npe_con_mora = npe_mora, @origen = -1, @arancel_beca = '-1', @codvac = -1,
							@tmo_valor = data.tmo_valor, @tmo_valor_mora = data.tmo_valor_mora,
							@codtmo_descuento = isnull(codtmo_descuento,-1), @monto_descuento = monto_descuento, @monto_arancel_descuento = monto_arancel_descuento
						from col_art_archivo_tal_preesp_mora as data inner join col_tmo_tipo_movimiento as tmo on 
							tmo.tmo_arancel = data.tmo_arancel
						where npe = @npe or npe_mora = @npe
					end	--	if exists(select 1 from col_art_archivo_tal_preesp_mora where npe = @npe or npe_mora = @npe)
				end	--	if @alumno_encontrado = 0

				if @alumno_encontrado = 0
				begin
					if exists(select 1 from col_art_archivo_tal_proc_grad_tec_dise_mora where npe = @npe or npe_mora = @npe)
					begin
						set @npe_valido = 1
						set @alumno_encontrado = 1
						set @TipoEstudiante = 'PRE TECNICO DE CARRERA DE DISENIO'
						select @codper = data.per_codigo, @codtmo = tmo.tmo_codigo, @arancel = tmo.tmo_arancel, @codcil = data.ciclo, @carnet = data.per_carnet,
							@carrera = data.pla_alias_carrera, @nombre = data.per_nombres_apellidos, @monto_con_mora = data.tmo_valor_mora,
							@monto_sin_mora = data.tmo_valor, @fecha_sin_mora = data.fel_fecha, @fecha_con_mora = data.fel_fecha_mora , @descripcion_arancel = tmo.tmo_descripcion,
							@npe_sin_mora = npe, @npe_con_mora = npe_mora, @origen = -1, @arancel_beca = '-1', @codvac = -1,
							@tmo_valor = data.tmo_valor, @tmo_valor_mora = data.tmo_valor_mora,

							@portafolio_tecnicos_pre = isnull(portafolio,0)
						from col_art_archivo_tal_proc_grad_tec_dise_mora as data inner join col_tmo_tipo_movimiento as tmo on 
							tmo.tmo_arancel = data.tmo_arancel
						where npe = @npe or npe_mora = @npe
					end	--	if exists(select 1 from col_art_archivo_tal_proc_grad_tec_dise_mora where npe = @npe or npe_mora = @npe)
				end	--	if @alumno_encontrado = 0		

				if @alumno_encontrado = 0
				begin
					if exists(select 1 from col_art_archivo_tal_proc_grad_tec_mora where npe = @npe or npe_mora = @npe)
					begin
						set @npe_valido = 1
						set @alumno_encontrado = 1
						set @TipoEstudiante = 'PRE TECNICO DE CARRERA diferente de disenio'
						select @codper = data.per_codigo, @codtmo = tmo.tmo_codigo, @arancel = tmo.tmo_arancel, @codcil = data.ciclo, @carnet = data.per_carnet,
							@carrera = data.pla_alias_carrera, @nombre = data.per_nombres_apellidos, @monto_con_mora = data.tmo_valor_mora,
							@monto_sin_mora = data.tmo_valor, @fecha_sin_mora = data.fel_fecha, @fecha_con_mora = data.fel_fecha_mora, @descripcion_arancel = tmo.tmo_descripcion,
							@npe_sin_mora = npe, @npe_con_mora = npe_mora, @origen = -1, @arancel_beca = '-1', @codvac = -1,
							@tmo_valor = data.tmo_valor, @tmo_valor_mora = data.tmo_valor_mora,

							@portafolio_tecnicos_pre = 0
						from col_art_archivo_tal_proc_grad_tec_mora as data inner join col_tmo_tipo_movimiento as tmo on 
							tmo.tmo_arancel = data.tmo_arancel
						where npe = @npe or npe_mora = @npe
					end	--	if exists(select 1 from col_art_archivo_tal_proc_grad_tec_dise_mora where npe = @npe or npe_mora = @npe)
				end	--	if @alumno_encontrado = 0	
				--select top 3 * from col_art_archivo_tal_mora
			end

			print '@codper : ' + cast(@codper as nvarchar(10))
			print '@carnet : ' + @carnet
			print '@codtmo : ' + cast(@codtmo as nvarchar(10))
			print '@codcil : ' + cast(@codcil as nvarchar(10))
			print '@arancel : ' + @arancel
			print '@arancel_beca : ' + @arancel_beca
			print '@nombre : ' + @nombre
			print '@monto_con_mora : ' + cast(@monto_con_mora as nvarchar(15))
			print '@monto_sin_mora : ' + cast(@monto_sin_mora as nvarchar(15))
			print '@fecha_sin_mora  : ' + cast(@fecha_sin_mora  as nvarchar(15))
			print '@fecha_con_mora  : ' + cast(@fecha_con_mora  as nvarchar(15))
			print '@descripcion_arancel  : ' + @descripcion_arancel
			print '@npe_sin_mora :' + @npe_sin_mora
			print '@npe_con_mora :' + @npe_con_mora
			print '@origen : ' + cast(@origen as nvarchar(4))
			print '@codvac : ' + cast(@codvac as nvarchar(4))
			print '@TipoEstudiante : ' + @TipoEstudiante
			print '@per_tipo : ' + @per_tipo
			print '@codtmo_descuento : ' + cast(@codtmo_descuento as nvarchar(15)) 
			print '@monto_descuento : ' + cast(@monto_descuento as nvarchar(15)) 
			print '@monto_arancel_descuento : ' + cast(@monto_arancel_descuento as nvarchar(15)) 
			print '------------------------------------------'
		
		if isnull(@codper,0) > 0
		begin
			print 'Se encontro el codper, por lo tanto se aplicara el pago'
			set @codper_encontrado = 1

			if exists(select 1 from col_mov_movimientos inner join col_dmo_det_mov on mov_codigo = dmo_codmov 
						where mov_codper = @codper and dmo_codcil = @codcil and dmo_codtmo = @codtmo and mov_estado <> 'A')
			begin
				print '....... El pago ya existe para el estudiante en el ciclo para el arancel respectivo'
				set @CorrelativoGenerado = 0
			end		--	if exists(select 1 from col_mov_movimientos inner join col_dmo_det_mov on mov_codigo = dmo_codmov where mov_codper = @codper and dmo_codcil = @codcil and dmo_codtmo = @codtmo and mov_estado <> 'A')
			else	--	if exists(select 1 from col_mov_movimientos inner join col_dmo_det_mov on mov_codigo = dmo_codmov where mov_codper = @codper and dmo_codcil = @codcil and dmo_codtmo = @codtmo and mov_estado <> 'A')
			begin
				print '...... El arancel no esta pagado .......'
				declare @codtmo_sinbeca int, @codtmo_conbeca int

				--set @mov_puntoxpress = null--@tipo
				

				if (@per_tipo = 'M')
				begin
					if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Maestrias' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula')
					begin
						print 'ES ARANCEL DE Matricula de Maestrias'

						PRINT '*-Almacenando el encabezado de la factura'
						select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
						select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca

						select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
						--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

						print '@descripcion: ' + cast(@descripcion as varchar)
						/* Insertando el encabezado de la factura*/
						exec col_efpc_EncabezadoFacturaPagoCuotas 2,
						--select 
							@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
							@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

						PRINT '*-FIN Almacenando el encabezado de la factura'
						/* Insertando el detalle de la factura*/
						/*Almacenando el arancel de la matricula */
						PRINT '**--Almacenando el arancel de la matricula'
						select @CorrelativoGenerado = @corr_mov -- max(mov_codigo) from col_mov_movimientos 
						--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo = @referencia /*mov_recibo_puntoxpress = @mov_recibo_puntoxpress*/ --and mov_codigo = @corr_mov and mov_lote = @mov_lote


						set @dmo_codtmo = @codtmo_sinbeca
						set @dmo_valor = @monto_con_mora
						set @dmo_iva = 0
						set @dmo_abono = @monto_con_mora
						set @dmo_cargo = 0

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono, @dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						PRINT '**--FIN Almacenando el arancel de la matricula'

						/* Almacenando el arancel que tiene el cargo del ciclo */
						PRINT '***---Almacenando el cargo del ciclo'
						set @dmo_codtmo = 162
						set @dmo_valor = 0
						--set @dmo_cargo = 825.75
						set @dmo_abono = 0

						--select @dmo_cargo = vac_SaldoAlum from ra_vac_valor_cuotas where vac_codigo = @codvac
						select @dmo_cargo = sum(tmo_valor)
						from col_art_archivo_tal_mae_mora 
						where ciclo = @codcil and per_carnet = @carnet and origen = @origen -- and fel_codvac = @codvac

			
						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						PRINT '***---FIN Almacenando el cargo del ciclo'
					end	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Maestrias' and spaet_codigo = 0 and tmo_arancel = @arancel and spaet_tipo_evaluacion like '%Matr%' and are_tipoarancel like '%Mat%' )
					else	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Maestrias' and spaet_codigo = 0 and tmo_arancel = @arancel and spaet_tipo_evaluacion like '%Matr%' and are_tipoarancel like '%Mat%' )
					begin
						print 'No es arancel de Matricula de Maestrias, son cuotas'

						if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Maestrias' and spaet_codigo > 0 and tmo_arancel = @arancel and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Evalua%')	
						begin
							print 'Pago de segunda cuota en adelante se verifica que tiene que pagar '
							set @verificar_recargo_mora = 1
						end				
						else	--	if exists(select count(1) from vst_Aranceles_x_Evaluacion where tde_nombre = 'Maestrias' and spaet_codigo > 1 and tmo_arancel = @arancel and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Evalua%')	
						begin
							print 'PRIMERA CUOTA, ESTA NO PAGA ARANCEL DE RECARGO'
						end		--	
	
						PRINT '*-Almacenando el encabezado de la factura'
						select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
						select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca
			
						select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
						--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

						print '@descripcion: ' + cast(@descripcion as varchar)
						/* Insertando el encabezado de la factura*/
						exec col_efpc_EncabezadoFacturaPagoCuotas 2,
						--select 
							@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
							@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

						PRINT '*-FIN Almacenando el encabezado de la factura'
						/* Insertando el detalle de la factura*/
						/*Almacenando el arancel de la matricula */
						PRINT '**--Almacenando el arancel de la cuota'
						--select @CorrelativoGenerado = max(mov_codigo) from col_mov_movimientos 
						--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo = @referencia /*mov_recibo_puntoxpress = @mov_recibo_puntoxpress*/ --and mov_codigo = @corr_mov and mov_lote = @mov_lote
						set @CorrelativoGenerado = @corr_mov

						set @dmo_codtmo = @codtmo_sinbeca
						set @dmo_valor = @tmo_valor --@monto_con_mora
						set @dmo_iva = 0
						set @dmo_abono = @tmo_valor --@monto_con_mora
						set @dmo_cargo = 0

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						print 'Correlativo generado en el detalle de la factura : ' + cast (@dmo_codigo as nvarchar(10))
						PRINT '**--FIN Almacenando el arancel de la cuota'

						if @arancel_beca = '-1'	--	no paga el descuento de un arancel de beca
						begin
							print 'no paga el descuento de un arancel de beca'
						end
						else	--	if @arancel_beca = '-1'	--	no paga el descuento de un arancel de beca
						begin
							if isnull(@arancel_beca,'') = ''
							begin
								print 'La cuota no posee arancel de beca, por lo tanto no se agrega otro registro en el detalle de la factura'
							end
							else	--	if isnull(@arancel_beca,'') = ''
							begin
							/* Almacenando el arancel que tiene el cargo del ciclo */
								PRINT '***---Almacenando el arancel del descuento de la beca'
								set @dmo_codtmo = @codtmo_conbeca
								set @dmo_valor = -1 * @monto_sin_mora
								set @dmo_iva = 0


								SELECT @dmo_valor = tmo_valor - cuota_pagar FROM col_art_archivo_tal_mae_mora 
								where ciclo = @codcil and per_carnet = @carnet and tmo_arancel = @arancel

								set @dmo_valor = @dmo_valor * -1
								set @dmo_abono = @dmo_valor
								set @dmo_cargo = @dmo_valor

								select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
								exec col_dfpc_DetalleFacturaPagoCuotas 1,
								--select 
								@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								set @MontoPagado = @MontoPagado + @dmo_valor
								PRINT '***---FIN Almacenando descuento de la beca'
							end		--	if isnull(@arancel_beca,'') = ''
						end	--	if @arancel_beca = '-1'	--	no paga el descuento de un arancel de beca
					end	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Maestrias' and spaet_codigo = 0 and tmo_arancel = @arancel)
				end	--	if (@per_tipo = 'M')

				if @per_tipo = 'U'
				begin
					print 'Alumno de Pre grado'
					if @TipoEstudiante = 'PRE GRADO'
					begin
						if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREGRADO')
						begin
							print 'ES ARANCEL DE Matricula de Pre grado'
							PRINT '*-Almacenando el encabezado de la factura'
							select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
							select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca

							select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
							--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)
							print '@descripcion: ' + cast(@descripcion as varchar)
							/* Insertando el encabezado de la factura*/
							exec col_efpc_EncabezadoFacturaPagoCuotas 2,
							--select 
								@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
								@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

							PRINT '*-FIN Almacenando el encabezado de la factura'
							/* Insertando el detalle de la factura*/
							/*Almacenando el arancel de la matricula */
							PRINT '**--Almacenando el arancel de la matricula'
							select @CorrelativoGenerado = @corr_mov --max(mov_codigo) from col_mov_movimientos 
							--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo = @referencia /*mov_recibo_puntoxpress = @mov_recibo_puntoxpress*/ --and mov_codigo = @corr_mov and mov_lote = @mov_lote

							set @dmo_codtmo = @codtmo_sinbeca
							set @dmo_valor = @monto_con_mora
							set @dmo_iva = 0
							set @dmo_abono = @monto_con_mora
							set @dmo_cargo = 0

							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
							PRINT '**--FIN Almacenando el arancel de la matricula'

							/* Almacenando el arancel que tiene el cargo del ciclo */
							PRINT '***---Almacenando el cargo del ciclo U'
							set @dmo_codtmo = 162
							set @dmo_valor = 0
							--set @dmo_cargo = 825.75
							set @dmo_abono = 0

							--select @dmo_cargo = sum(vac_SaldoAlum) from ra_vac_valor_cuotas where vac_codigo = @codvac
							if exists (select 1 from ra_per_personas join col_detmen_detalle_tipo_mensualidad on per_codigo = detmen_codper where detmen_codcil = @codcil and per_carnet = @carnet)
							begin
								print 'Alumno posee descuento'
								select @dmo_cargo = sum(ISNUll(tmo_valor,0)) +sum(isnull(matricula,0))+ sum(isnull(monto_descuento,0))+ sum(isnull(monto_arancel_descuento,0))
									from col_art_archivo_tal_mora
								where ciclo = @codcil and per_carnet = @carnet /*and (isnull(monto_descuento,0) > 0 )*/ and fel_codigo_barra >= 2		--	Alumno posee descuento
								
							end
							else
							begin
								print 'Alumno no posee descuento'
								select @dmo_cargo = 
								sum(tmo_valor) + sum(isnull(monto_descuento,0)) + sum(matricula)
									from col_art_archivo_tal_mora
								where ciclo = @codcil and per_carnet = @carnet and isnull(monto_descuento,0) = 0  and fel_codigo_barra >= 2			--	Alumno no posee descuento
							end
							print '@dmo_cargo: ' + cast(@dmo_cargo as varchar)

							select @dmo_cargo = matricula + @dmo_cargo
							from col_art_archivo_tal_mora
							where ciclo = @codcil and per_carnet = @carnet and fel_codigo_barra = 1

							--print '@dmo_cargo: ' + cast(@dmo_cargo as varchar(15))
							--select  @dmo_cargo
							--select * from ra_vac_valor_cuotas where vac_codigo = @codvac
							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
							PRINT '***---FIN Almacenando el cargo del ciclo U'
						end	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREGRADO')
						else	--	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREGRADO')
						begin
							PRINT 'SON CUOTAS DE MENSUALIDAD'
							--select @arancel
							if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREGRADO')
							begin
								print 'cuota de la segunda a la sexta cuota de pregrado, se verifica si paga recargo de pago tardio'
								set @verificar_recargo_mora = 1
							end	--	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREGRADO')
							else	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREGRADO')
							begin
								print 'Es primera cuota de mensualidad de estudiante de pregrado'
								print 'NO PAGA ARANCEL DE RECARGO'
							end		--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREGRADO')
			
							PRINT '*-Almacenando el encabezado de la factura'
							select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
							select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca
			
							select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
							--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)
							
							print '@descripcion: '
							print '@descripcion: ' + cast(@descripcion as varchar)

							/* Insertando el encabezado de la factura*/
							exec col_efpc_EncabezadoFacturaPagoCuotas 2,
							-- select 
								@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
								@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

							PRINT '*-FIN Almacenando el encabezado de la factura'
							/* Insertando el detalle de la factura*/
							/*Almacenando el arancel de la matricula */
							PRINT '**--Almacenando el arancel de la cuota'
							select @CorrelativoGenerado = @corr_mov -- max(mov_codigo) from col_mov_movimientos 
							--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo = @referencia /*mov_recibo_puntoxpress = @mov_recibo_puntoxpress*/ --and mov_codigo = @corr_mov and mov_lote = @mov_lote

							set @dmo_codtmo = @codtmo_sinbeca
							set @dmo_valor = @tmo_valor --@monto_con_mora
							set @dmo_iva = 0
							set @dmo_abono = @tmo_valor --@monto_con_mora
							set @dmo_cargo = 0
							
							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

							declare @bandera_pago int = 0
							if @monto_descuento > 0 and @codtmo_descuento = -1 and @monto_arancel_descuento = 0
							begin
								print 'if @monto_descuento > 0 and @codtmo_descuento = -1 and @monto_arancel_descuento = 0'
								set @dmo_cargo = @monto_descuento * - 1
								set @dmo_abono = @dmo_valor

								exec col_dfpc_DetalleFacturaPagoCuotas 1,
								-- select 
								@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								set @MontoPagado = @MontoPagado + @dmo_valor	
								set @bandera_pago = 1							
							end

							if @monto_descuento = 0 and @codtmo_descuento >0 and @monto_arancel_descuento > 0
							begin
								print 'if @monto_descuento = 0 and @codtmo_descuento >0 and @monto_arancel_descuento > 0'
								set @dmo_valor = @tmo_valor + @monto_arancel_descuento
								set @dmo_cargo = 0
								set @dmo_abono = @dmo_valor

								exec col_dfpc_DetalleFacturaPagoCuotas 1,
								-- select 
								@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								set @MontoPagado = @MontoPagado + @dmo_valor	
								

								set @dmo_codtmo = @codtmo_descuento
								set @dmo_valor = @monto_arancel_descuento * -1 								
								set @dmo_cargo = @dmo_valor
								set @dmo_abono = @dmo_valor

								select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
								exec col_dfpc_DetalleFacturaPagoCuotas 1,
								-- select 
								@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								--set @MontoPagado = @MontoPagado + @dmo_valor															
							end
							else
							begin
								print 'else  if @monto_descuento = 0 and @codtmo_descuento >0 and @monto_arancel_descuento > 0'
								if @bandera_pago = 0-- Si no se a realizado el pago se realiza en este IF
								begin
									print 'if @bandera_pago = 0'
									exec col_dfpc_DetalleFacturaPagoCuotas 1,
									@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
										@dmo_eval
									set @MontoPagado = @MontoPagado + @dmo_valor
								end
							end
							PRINT '**--FIN Almacenando el arancel de la cuota'
						end	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREGRADO')
					end	--	if @TipoEstudiante = 'PRE GRADO'

					if @TipoEstudiante = 'PRE ESPECIALIDAD CARRERA'
					BEGIN
						PRINT 'alumno de la carrera de la pre especializacion'

						if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREESPECIALIDAD')
						begin
							print 'ES ARANCEL DE Matricula de Pre especialidad'
							PRINT '*-Almacenando el encabezado de la factura'
							select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
							select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca

							select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
							--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)
							print '@descripcion: '
							print '@descripcion: ' + cast(@descripcion as varchar)
							/* Insertando el encabezado de la factura*/
							exec col_efpc_EncabezadoFacturaPagoCuotas 2,
							--select 
								@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
								@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

							PRINT '*-FIN Almacenando el encabezado de la factura'
							/* Insertando el detalle de la factura*/
							/*Almacenando el arancel de la matricula */
							PRINT '**--Almacenando el arancel de la matricula'
							select @CorrelativoGenerado = @corr_mov -- max(mov_codigo) from col_mov_movimientos 
							--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo = @referencia /*mov_recibo_puntoxpress = @mov_recibo_puntoxpress*/ --and mov_codigo = @corr_mov and mov_lote = @mov_lote

							set @dmo_codtmo = @codtmo_sinbeca
							set @dmo_valor = @monto_con_mora
							set @dmo_iva = 0
							set @dmo_abono = @monto_con_mora
							set @dmo_cargo = 0

							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
							PRINT '**--FIN Almacenando el arancel de la matricula'
							/* Almacenando el arancel que tiene el cargo del ciclo */
							PRINT '***---Almacenando el cargo del ciclo'
							set @dmo_codtmo = 162
							set @dmo_valor = 0
							--set @dmo_cargo = 825.75
							set @dmo_abono = 0


							if exists (select 1 from ra_per_personas join col_detmen_detalle_tipo_mensualidad on per_codigo = detmen_codper where detmen_codcil = @codcil and per_carnet = @carnet)
							begin
								print 'Alumno posee descuento'
								select @dmo_cargo = sum(ISNUll(tmo_valor,0)) + sum(isnull(matricula,0)) + sum(isnull(monto_descuento,0)) + sum(isnull(monto_arancel_descuento,0))
									from col_art_archivo_tal_preesp_mora
								where ciclo = @codcil and per_carnet = @carnet /*and (isnull(monto_descuento,0) > 0 )*/ and fel_orden >= 2		--	Alumno posee descuento
								
							end
							else
							begin
								print 'Alumno no posee descuento'
								select @dmo_cargo = 
								sum(tmo_valor) + sum(isnull(monto_descuento,0)) + sum(matricula)
									from col_art_archivo_tal_preesp_mora
								where ciclo = @codcil and per_carnet = @carnet and isnull(monto_descuento,0) = 0  and fel_orden >= 2			--	Alumno no posee descuento
							end
							print '@dmo_cargo: ' + cast(@dmo_cargo as varchar)

							--select @dmo_cargo = sum(vac_SaldoAlum) from ra_vac_valor_cuotas where vac_codigo = @codvac
							select @dmo_cargo =
									case when matricula = 0 then tmo_valor else matricula end + @dmo_cargo

							from col_art_archivo_tal_preesp_mora
							where ciclo = @codcil and per_carnet = @carnet and fel_orden = 0

							--select  @dmo_cargo
							--select * from ra_vac_valor_cuotas where vac_codigo = @codvac
							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
							PRINT '***---FIN Almacenando el cargo del ciclo'
						end		--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREESPECIALIDAD')
						else	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREESPECIALIDAD')
						begin
							PRINT 'SON CUOTAS DE MENSUALIDAD'
							--select @arancel
							if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREESPECIALIDAD')
							begin
								print 'cuota de la segunda a la sexta cuota de pregrado, se verifica si paga recargo de pago tardio'
								set @verificar_recargo_mora = 1
							end	--	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREESPECIALIDAD')
							else	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREESPECIALIDAD')
							begin
								print 'Es primera cuota de mensualidad de estudiante de Pre especialidad'
								print 'NO PAGA ARANCEL DE RECARGO'
							end		--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'PREESPECIALIDAD'))
			
							PRINT '*-Almacenando el encabezado de la factura'
							select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
							select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca
			
							select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
							--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)
							print '@descripcion: '
							print '@descripcion: ' + cast(@descripcion as varchar)

							/* Insertando el encabezado de la factura*/
							exec col_efpc_EncabezadoFacturaPagoCuotas 2,
							--select 
								@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
								@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

							PRINT '*-FIN Almacenando el encabezado de la factura'
							/* Insertando el detalle de la factura*/
							/*Almacenando el arancel de la matricula */
							PRINT '**--Almacenando el arancel de la cuota'
							select @CorrelativoGenerado = max(mov_codigo) from col_mov_movimientos 
							where mov_codper = @codper and mov_codcil = @codcil and mov_recibo = @referencia /*mov_recibo_puntoxpress = @mov_recibo_puntoxpress*/ --and mov_codigo = @corr_mov and mov_lote = @mov_lote

							set @dmo_codtmo = @codtmo_sinbeca
							set @dmo_valor = @tmo_valor --@monto_con_mora
							set @dmo_iva = 0
							set @dmo_abono = @tmo_valor --@monto_con_mora
							set @dmo_cargo = 0

							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

							declare @bandera_pago_preesp int = 0
							if @monto_descuento > 0 and @codtmo_descuento = -1 and @monto_arancel_descuento = 0
							begin
								print 'if @monto_descuento > 0 and @codtmo_descuento = -1 and @monto_arancel_descuento = 0 (cuota normal)'
								set @dmo_cargo = @monto_descuento * - 1
								set @dmo_abono = @dmo_valor

								exec col_dfpc_DetalleFacturaPagoCuotas 1,
								-- select 
								@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								set @MontoPagado = @MontoPagado + @dmo_valor	
								set @bandera_pago_preesp = 1							
							end
							
							if @monto_descuento = 0 and @codtmo_descuento >0 and @monto_arancel_descuento > 0
							begin
								print 'if @monto_descuento = 0 and @codtmo_descuento >0 and @monto_arancel_descuento > 0 (cuota con descuento)'
								set @dmo_valor = @tmo_valor + @monto_arancel_descuento
								set @dmo_cargo = 0
								set @dmo_abono = @dmo_valor

								exec col_dfpc_DetalleFacturaPagoCuotas 1,
								-- select 
								@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								set @MontoPagado = @MontoPagado + @dmo_valor	
								
								set @dmo_codtmo = @codtmo_descuento
								set @dmo_valor = @monto_arancel_descuento * -1 								
								set @dmo_cargo = @dmo_valor
								set @dmo_abono = @dmo_valor

								select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
								exec col_dfpc_DetalleFacturaPagoCuotas 1,
								-- select 
								@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
									@dmo_eval
								--set @MontoPagado = @MontoPagado + @dmo_valor															
							end
							else
							begin
								print 'else  if @monto_descuento = 0 and @codtmo_descuento >0 and @monto_arancel_descuento > 0 (cuota normal)'
								if @bandera_pago_preesp = 0-- Si no se a realizado el pago se realiza en este IF
								begin
									print 'if @@bandera_pago_preesp = 0'
									exec col_dfpc_DetalleFacturaPagoCuotas 1,
									@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
										@dmo_eval
									set @MontoPagado = @MontoPagado + @dmo_valor
								end
							end

							/*
							exec col_dfpc_DetalleFacturaPagoCuotas
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor*/
							PRINT '**--FIN Almacenando el arancel de la cuota'
						end	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREESPECIALIDAD')
					END	--	if @TipoEstudiante = 'PRE ESPECIALIDAD CARRERA'

					if @TipoEstudiante = 'PRE TECNICO DE CARRERA DE DISENIO' 
					BEGIN
						PRINT 'alumno de CARRERA TECNICO de de la pre especializacion'
						if (@arancel = 'I-73' or @arancel = 'I-74')
						begin
							print 'es pago de matricula y primera cuota, por lo tanto, no paga mora'
							if (@arancel = 'I-73')
							begin
								print 'pago exclusivamente de la matricula'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
								select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca	
								set @dmo_cargo = 0
								set @dmo_valor = @monto_sin_mora
								set @dmo_abono = @monto_sin_mora
							end	--	if (@arancel = 'I-73')
							if (@arancel = 'I-74')
							begin
								print 'pago de la primer cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-74'
								select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-57'
								--select @dmo_valor = @portafolio_tecnicos_pre	
								set @dmo_valor = @portafolio_tecnicos_pre
								set @dmo_abono = @portafolio_tecnicos_pre
								--select @portafolio_tecnicos_pre
								select @dmo_cargo = sum(isnull(portafolio,0)) from col_art_archivo_tal_proc_grad_tec_dise_mora
								where ciclo = @codcil and per_carnet = @carnet
								set @dmo_codtmo = 1633
						--set @dmo_abono 
							end --	if (@arancel = 'I-74')
						end	--	if (@arancel = 'I-73' or @arancel = 'I-74')
						else	--	--	if (@arancel = 'I-73' or @arancel = 'I-74')
						begin
							print 'pago de la segunda cuota en adelante, se verifica si hay recargo por mora'
							set @verificar_recargo_mora = 1
							set @dmo_valor = @portafolio_tecnicos_pre
							set @dmo_abono = @portafolio_tecnicos_pre
							set @dmo_cargo = 0

							if (@arancel = 'I-75')
							begin
								print 'pago de la segunda cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-75'
								select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-58'
							end --	if (@arancel = 'I-75')
							if (@arancel = 'I-76')
							begin
								print 'pago de la tercera cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-76'
								select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-59'
							end --	if (@arancel = 'I-76')
							if (@arancel = 'I-77')
							begin
								print 'pago de la cuarta cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-77'
								select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-60'
							end --	if (@arancel = 'I-77')
							if (@arancel = 'I-78')
							begin
								print 'pago de la quinta cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-78'
								select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-61'
							end --	if (@arancel = 'I-78')
							if (@arancel = 'E-03')
							begin
								print 'Examen de seminario de graduacion'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'E-03'
							end --	if (@arancel = 'E-03')
						end	--	--	if (@arancel = 'I-73' or @arancel = 'I-74')
						--select @dmo_valor, @monto_sin_mora , @portafolio_tecnicos_pre	
						select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
						--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)
						--select @corr_mov, @codtmo_sinbeca, @codtmo_conbeca
						/* Insertando el encabezado de la factura*/

						--select 
						--	@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
						--	@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea
						print '@descripcion: '
						print '@descripcion: ' + cast(@descripcion as varchar)

						exec col_efpc_EncabezadoFacturaPagoCuotas 2,
						--select 
							@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
							@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro
						print 'se inserto el encabezado de la factura'

						select @CorrelativoGenerado = @corr_mov --max(mov_codigo) from col_mov_movimientos 
						--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo = @referencia /*mov_recibo_puntoxpress = @mov_recibo_puntoxpress*/ --and mov_codigo = @corr_mov and mov_lote = @mov_lote

						PRINT '*-Almacenando el encabezado de la factura'

						print 'Almacenando el detalle de la factura'
						--set @dmo_codtmo = @codtmo_sinbeca
						--set @dmo_valor = @monto_con_mora
						set @dmo_iva = 0
						--set @dmo_abono = @monto_con_mora
						--set @dmo_cargo = 0

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						if (@arancel <> 'E-03')
						begin
							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
						end	--	if (@arancel <> 'E-03')
						else
						begin
							set @verificar_recargo_mora = 0
						end

						PRINT '**--FIN Almacenando el arancel de la matricula'

						/* Almacenando el arancel que tiene el cargo del ciclo */
						PRINT '***---Almacenando el cargo del ciclo'
					
						--set @dmo_valor = 0
						--set @dmo_cargo = 825.75
						--set @dmo_abono = 0

						if (@arancel = 'I-73')
						begin
							set @dmo_codtmo = 162
							select @dmo_cargo = sum(isnull(tmo_valor,0)) - sum(isnull(portafolio,0)) 
							from col_art_archivo_tal_proc_grad_tec_dise_mora
							where ciclo = @codcil and per_carnet = @carnet
							--set @dmo_cargo = 0
							set @dmo_abono = 0--@monto_sin_mora 
							set @dmo_valor = 0--@monto_sin_mora
						end

						if (@arancel = 'I-74' or @arancel = 'I-75' or @arancel = 'I-76' or @arancel = 'I-77' or @arancel = 'I-78')
						begin
							select @dmo_valor = (isnull(tmo_valor,0)) - (isnull(portafolio,0)) 
							from col_art_archivo_tal_proc_grad_tec_dise_mora 
							where ciclo = @codcil and per_carnet = @carnet and tmo_arancel = @arancel
							set @dmo_abono = @dmo_valor
							set @dmo_cargo = 0
							set @dmo_codtmo = @codtmo_sinbeca
						end

						if (@arancel = 'E-03')
						begin
							select @dmo_valor = @monto_con_mora 
							set @dmo_abono = @dmo_valor
							set @dmo_cargo = 0
							set @dmo_codtmo = @codtmo_sinbeca						
						end
						----select @dmo_cargo = sum(vac_SaldoAlum) from ra_vac_valor_cuotas where vac_codigo = @codvac
						--select @dmo_cargo = sum(tmo_valor) from col_art_archivo_tal_proc_grad_tec_dise_mora
						--where ciclo = @codcil and per_carnet = @carnet

						--select  @dmo_cargo
						--select * from ra_vac_valor_cuotas where vac_codigo = @codvac
						--set @dmo_cantidad = @portafolio_tecnicos_pre
						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						PRINT '***---FIN Almacenando el cargo del ciclo'
					END	--	if @TipoEstudiante = 'PRE TECNICO DE CARRERA DE DISENIO'
	--***
					if @TipoEstudiante = 'PRE TECNICO DE CARRERA diferente de disenio' 
					BEGIN
						PRINT 'alumno de CARRERA TECNICO diference de Diseño de de la pre especializacion'

						if (@arancel = 'I-73' or @arancel = 'I-74')
						begin
							print 'es pago de matricula y primera cuota, por lo tanto, no paga mora'
							if (@arancel = 'I-73')
							begin
								print 'pago exclusivamente de la matricula'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
								--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca	
								set @dmo_cargo = 0
								set @dmo_valor = @monto_sin_mora
								set @dmo_abono = @monto_sin_mora
							end	--	if (@arancel = 'I-73')
							if (@arancel = 'I-74')
							begin
								print 'pago de la primer cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-74'
								--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-57'
								--select @dmo_valor = @portafolio_tecnicos_pre	
								set @dmo_valor = @portafolio_tecnicos_pre
								set @dmo_abono = @portafolio_tecnicos_pre
								--select @portafolio_tecnicos_pre
								select @dmo_cargo = 0 --sum(isnull(portafolio,0)) from col_art_archivo_tal_proc_grad_tec_mora
								--where ciclo = @codcil and per_carnet = @carnet
								--set @dmo_codtmo = 1633
						--set @dmo_abono 
							end --	if (@arancel = 'I-74')
						end	--	if (@arancel = 'I-73' or @arancel = 'I-74')
						else	--	--	if (@arancel = 'I-73' or @arancel = 'I-74')
						begin
							print 'pago de la segunda cuota en adelante, se verifica si hay recargo por mora'
							set @verificar_recargo_mora = 1
							set @dmo_valor = @portafolio_tecnicos_pre
							set @dmo_abono = @portafolio_tecnicos_pre
							set @dmo_cargo = 0

							if (@arancel = 'I-75')
							begin
								print 'pago de la segunda cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-75'
								--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-58'
							end --	if (@arancel = 'I-75')
							if (@arancel = 'I-76')
							begin
								print 'pago de la tercera cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-76'
								--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-59'
							end --	if (@arancel = 'I-76')
							if (@arancel = 'I-77')
							begin
								print 'pago de la cuarta cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-77'
								--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-60'
							end --	if (@arancel = 'I-77')
							if (@arancel = 'I-78')
							begin
								print 'pago de la quinta cuota'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'I-78'
								--select @codtmo_conbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'J-61'
							end --	if (@arancel = 'I-78')
							if (@arancel = 'E-03')
							begin
								print 'Examen de seminario de graduacion'
								select @codtmo_sinbeca = tmo_codigo, @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = 'E-03'
							end --	if (@arancel = 'E-03')
						end	--	--	if (@arancel = 'I-73' or @arancel = 'I-74')
						--select @dmo_valor, @monto_sin_mora , @portafolio_tecnicos_pre	
						select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
						--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)
						--select @corr_mov, @codtmo_sinbeca, @codtmo_conbeca
						/* Insertando el encabezado de la factura*/

						--select 
						--	@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
						--	@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea
							print '@descripcion: '
							print '@descripcion: ' + cast(@descripcion as varchar)
						exec col_efpc_EncabezadoFacturaPagoCuotas 2,
						--select 
							@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
							@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro
						print 'se inserto el encabezado de la factura'

						select @CorrelativoGenerado = @corr_mov --max(mov_codigo) from col_mov_movimientos 
						--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo = @referencia /*mov_recibo_puntoxpress = @mov_recibo_puntoxpress*/ --and mov_codigo = @corr_mov and mov_lote = @mov_lote

						PRINT '*-Almacenando el encabezado de la factura'

						print 'Almacenando el detalle de la factura'
						--set @dmo_codtmo = @codtmo_sinbeca
						set @dmo_valor = @monto_sin_mora
						set @dmo_iva = 0
						set @dmo_abono = @dmo_valor
						set @dmo_cargo = 0

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						if (@arancel <> 'E-03')
						begin
							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
						end	--	if (@arancel <> 'E-03')
						else
						begin
							set @verificar_recargo_mora = 0
							set @dmo_valor = @monto_sin_mora
							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
						end

						--PRINT '**--FIN Almacenando el arancel de la matricula'

						--/* Almacenando el arancel que tiene el cargo del ciclo */
						--PRINT '***---Almacenando el cargo del ciclo'
					
						----set @dmo_valor = 0
						----set @dmo_cargo = 825.75
						----set @dmo_abono = 0

						if (@arancel = 'I-73')
						begin
							set @dmo_codtmo = 162
							select @dmo_cargo = sum(isnull(tmo_valor,0)) from col_art_archivo_tal_proc_grad_tec_mora
								where ciclo = @codcil and per_carnet = @carnet
							--set @dmo_cargo = 0
							set @dmo_abono = 0--@monto_sin_mora 
							set @dmo_valor = 0--@monto_sin_mora

							select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

							exec col_dfpc_DetalleFacturaPagoCuotas 1,
							--select 
							@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
								@dmo_eval
							set @MontoPagado = @MontoPagado + @dmo_valor
						end
						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

					END	--	if @TipoEstudiante = 'PRE TECNICO DE CARRERA diferente de disenio'
					--****
				end		--	if @per_tipo = 'U'

				if @per_tipo = 'CE'
				begin
					print 'Verificando el alumno de Curso Especializado'
					select @dmo_codtmo = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
	
					select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
					--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)
							print '@descripcion: '
							print '@descripcion: ' + cast(@descripcion as varchar)
					/* Insertando el encabezado de la factura*/
					exec col_efpc_EncabezadoFacturaPagoCuotas 2,
					--select 
						@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
						@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

					PRINT '*-FIN Almacenando el encabezado de la factura'
					/* Insertando el detalle de la factura*/
					/*Almacenando el arancel de la matricula */
					PRINT '**--Almacenando el arancel de la matricula'
					select @CorrelativoGenerado = @corr_mov				

		
					set @dmo_valor = @monto_sin_mora
					set @dmo_iva = 0
					set @dmo_abono = @monto_sin_mora
					set @dmo_cargo = 0

					select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
					--select @dmo_codtmo, @codtmo
					exec col_dfpc_DetalleFacturaPagoCuotas 1,
					--select 
					@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
						@dmo_eval
					set @MontoPagado = @MontoPagado + @dmo_valor
					PRINT '**--FIN Almacenando el arancel del pago'

					if (@arancel = 'M-101') -- matricula
						begin
							print 'Matricula de curso de especializacion'
							select @dmo_cargo = sum(tmo_valor) from col_art_archivo_tal_mae_posgrado 
							where per_carnet = @carnet and ciclo = @codcil
							set @dmo_valor = 0
							set @dmo_abono = 0
							set @dmo_codtmo = 162

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						--select 999
					end	--	if (@arancel = 'M-101')
				end

				if @per_tipo = 'O'
				BEGIN
					PRINT 'alumno de los Postgrados impartidos por maestrias'

					if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Postgrados' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'POSTGRADOS MAES')
					begin
						print 'ES ARANCEL DE Matricula de Postgrado de maestrias'
						PRINT '*-Almacenando el encabezado de la factura'
						select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
						select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca

						select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
						--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

						/* Insertando el encabezado de la factura*/
						exec col_efpc_EncabezadoFacturaPagoCuotas 2,
						--select 
							@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
							@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

						PRINT '*-FIN Almacenando el encabezado de la factura'
						/* Insertando el detalle de la factura*/
						/*Almacenando el arancel de la matricula */
						PRINT '**--Almacenando el arancel de la matricula'
						select @CorrelativoGenerado = @corr_mov --max(mov_codigo) from col_mov_movimientos 
						--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo = @referencia /*mov_recibo_puntoxpress = @mov_recibo_puntoxpress*/ --and mov_codigo = @corr_mov and mov_lote = @mov_lote

						set @dmo_codtmo = @codtmo_sinbeca
						set @dmo_valor = @monto_con_mora
						set @dmo_iva = 0
						set @dmo_abono = @monto_con_mora
						set @dmo_cargo = 0

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						PRINT '**--FIN Almacenando el arancel de la matricula'

						/* Almacenando el arancel que tiene el cargo del ciclo */
						PRINT '***---Almacenando el cargo del ciclo'
						set @dmo_codtmo = 162
						set @dmo_valor = 0
						--set @dmo_cargo = 825.75
						set @dmo_abono = 0

						--select @dmo_cargo = sum(vac_SaldoAlum) from ra_vac_valor_cuotas where vac_codigo = @codvac
						select @dmo_cargo = sum(tmo_valor) from col_art_archivo_tal_mae_posgrado
						where ciclo = @codcil and per_carnet = @carnet

						--select  @dmo_cargo
						--select * from ra_vac_valor_cuotas where vac_codigo = @codvac
						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov
						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						PRINT '***---FIN Almacenando el cargo del ciclo'
					end		--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Postgrados' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'POSTGRADOS MAES')
					else	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Postgrados' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'POSTGRADOS MAES')
					begin
						PRINT 'SON CUOTAS DE MENSUALIDAD'
						--select @arancel
						if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Postgrados' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'POSTGRADOS MAES')			          
						begin
							print 'cuota de la segunda a la sexta cuota de pregrado, se verifica si paga recargo de pago tardio'
							set @verificar_recargo_mora = 1
						end	--	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Postgrados' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'POSTGRADOS MAES')			          
						else	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Postgrados' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'POSTGRADOS MAES')			          
						begin
							print 'Es primera cuota de mensualidad de estudiante de Postgrados de Maestrias'
							print 'NO PAGA ARANCEL DE RECARGO'
						end		--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Postgrados' and spaet_codigo > 0 and are_tipoarancel like '%Men%' and spaet_tipo_evaluacion like '%Eva%' and tmo_arancel = @arancel and are_tipo = 'POSTGRADOS MAES')			          
			
						PRINT '*-Almacenando el encabezado de la factura'
						select @codtmo_sinbeca = tmo_codigo from col_tmo_tipo_movimiento where tmo_arancel = @arancel
						select @codtmo_conbeca = tmo_codigo from col_tmo_tipo_movimiento where isnull(tmo_arancel, -1) = @arancel_beca
			
						select @corr_mov = (isnull(max(mov_codigo),0)+1) from col_mov_movimientos
						--select * from col_dmo_det_mov where dmo_codmov in (5435564, 5435565)

						/* Insertando el encabezado de la factura*/
						exec col_efpc_EncabezadoFacturaPagoCuotas 2,
						--select 
							@mov_codreg, @corr_mov, @mov_recibo, @codcil, @codper, @descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, @usuario, @mov_codmod, 
							@mov_tipo, @mov_historia,  @mov_codban, @mov_forma_pago, @lote, @mov_puntoxpress, @mov_recibo_puntoxpress, @mov_coddip, @mov_codmdp, @mov_codfea, @mov_fecha, @mov_fecha_registro, @mov_fecha_cobro

						PRINT '*-FIN Almacenando el encabezado de la factura'
						/* Insertando el detalle de la factura*/
						/*Almacenando el arancel de la matricula */
						PRINT '**--Almacenando el arancel de la cuota'
						select @CorrelativoGenerado = @corr_mov --max(mov_codigo) from col_mov_movimientos 
						--where mov_codper = @codper and mov_codcil = @codcil and mov_recibo = @referencia /*mov_recibo_puntoxpress = @mov_recibo_puntoxpress*/ --and mov_codigo = @corr_mov and mov_lote = @mov_lote

						set @dmo_codtmo = @codtmo_sinbeca
						set @dmo_valor = @tmo_valor --@monto_con_mora
						set @dmo_iva = 0
						set @dmo_abono = @tmo_valor --@monto_con_mora
						set @dmo_cargo = 0

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						PRINT '**--FIN Almacenando el arancel de la cuota'
					end	--	if exists(select 1 from vst_Aranceles_x_Evaluacion where tde_nombre = 'Pre grado' and spaet_codigo = 0 and tmo_arancel = @arancel and are_tipoarancel like '%Mat%' and spaet_tipo_evaluacion = 'Matricula' and are_tipo = 'PREESPECIALIDAD')
				END	--	if @TipoEstudiante = 'POST GRADOS de MAESTRIAS'

				if @verificar_recargo_mora = 1	--	verifica si pagar recargo
				begin
					print 'de segunda a sexta cuota, se evalua si paga o no recargo'

					set @dias_vencido = 0
					set @dias_vencido = DATEDIFF(dd, CONVERT(CHAR(10), @fecha_sin_mora, 103) , CONVERT(CHAR(10), getdate(), 103))
					print '@dias_vencido : ' + cast(@dias_vencido as nvarchar(10))
					--select @dias_vencido as dias_vencido			

					if (@dias_vencido > 0)
					begin
						print 'esta vencido, por lo tanto, se verifica si las cuotas son las mismas'
						if @monto_sin_mora = @monto_con_mora 
						begin
							print 'las cuotas es lo mismo, por lo tanto no paga mora'
							set @monto = @monto_sin_mora
							set @paga_mora = 0
						end
						else	--	if @monto_sin_mora = @monto_con_mora 
						begin
							print 'la cuota con mora y sin mora es diferente, por lo tanto se paga recargo de mora'
							set @monto = @monto_con_mora
							set @paga_mora = 1
						end	--	if @monto_sin_mora = @monto_con_mora 
					end
					else	--	if (@dias_vencido > 0)
					begin
						print 'No paga el recargo de mora porque no esta vencido'
						set @monto = @monto_sin_mora
						set @paga_mora = 0
					end	--	if (@dias_vencido > 0)	
					--select @paga_mora
					if @paga_mora = 1
					begin
						--	select tmo_codigo, tmo_valor from col_tmo_tipo_movimiento where tmo_arancel = 'A-88'
						set @codtmo = 88
						set @monto = 10 
						/*Almacenando el arancel del recargo de pago extraordinario */
						PRINT '**--Almacenando el arancel del recargo de pago extraordinario '
						select @dmo_codmov = max(mov_codigo) from col_mov_movimientos 
						where mov_codper = @codper and mov_codcil = @codcil and mov_recibo = @referencia /*mov_recibo_puntoxpress = @mov_recibo_puntoxpress*/

						set @dmo_codtmo = @codtmo
						set @dmo_valor = @monto
						set @dmo_iva = 0
						set @dmo_abono = @monto
						set @dmo_cargo = @monto

						select @dmo_codigo = max(dmo_codigo) + 1 from col_dmo_det_mov

						exec col_dfpc_DetalleFacturaPagoCuotas 1,
						--select 
						@dmo_codreg, @CorrelativoGenerado, @dmo_codigo, @dmo_codtmo, @dmo_cantidad, @dmo_valor, @dmo_codmat, @dmo_iva, @dmo_descuento, @dmo_mes, @codcil, @dmo_cargo, @dmo_abono,
							@dmo_eval
						set @MontoPagado = @MontoPagado + @dmo_valor
						PRINT '**--FIN Almacenando el arancel del recargo de pago extraordinario '
					end	--	if @paga_mora = 1
				end	--	if exists(select count(1) from vst_Aranceles_x_Evaluacion where tde_nombre = 'Maestrias' and spaet_codigo = 1 and tmo_arancel = @arancel)


			end		--	if exists(select 1 from col_mov_movimientos inner join col_dmo_det_mov on mov_codigo = dmo_codmov where mov_codper = @codper and dmo_codcil = @codcil and dmo_codtmo = @codtmo and mov_estado <> 'A')
			print '@codtmo_sinbeca : ' + cast(@codtmo_sinbeca as nvarchar(10))
			print '@codtmo_conbeca : ' + cast(@codtmo_conbeca as nvarchar(10))

			--select * from col_mov_movimientos where mov_codper = 196586 and mov_codcil = 116 and mov_codigo in (5281547, 5269003)
			--select * from col_mov_movimientos where mov_codper = 193592 and mov_codcil = 116-- and mov_codigo in (5281547, 5269003)
		
			print '@MontoPagado: ' + cast(@MontoPagado as nvarchar(10))
			insert into col_pagos_en_linea_estructuradoSP (codper, carnet, NumFactura, formapago, lote, MontoFactura, npe, TipoEstudiante, codppo ) 
			values (@codper, @carnet, @CorrelativoGenerado, @tipo, @lote, @MontoPagado, @npe, @TipoEstudiante, @IdGeneradoPreviaPagoOnLine)
			
			--select * from col_mov_movimientos where mov_codper = @codper
			--select * from col_dmo_det_mov where dmo_codmov in (select mov_codigo from col_mov_movimientos where mov_codper = @codper)
		
		end	--	if isnull(@codper,0) > 0
		else	--	if isnull(@codper,0) > 0
		begin
			set @Mensaje = 'Por alguna razon no se encontro el codper del estudiante'
			print 'Por alguna razon no se encontro el codper del estudiante'
			set @codper_encontrado = 0 
		end	--	if isnull(@codper,0) > 0

		if @codper_encontrado = 0 
		begin
			set @Mensaje = 'Intentar realizar nuevamente la transacción'
			--select '-2' resultado, @CorrelativoGenerado as Correlativo, 'Intentar realizar nuevamente la transacción' as Descripcion
			print '-2 as resultado, '+cast(@CorrelativoGenerado as varchar(5))+' as Correlativo, Intentar realizar nuevamente la transacción as Descripcion' 
			select @respuesta = -2
		end		--	if @codper_encontrado = 0 
		else	--	if @codper_encontrado = 0 
		begin
			if @npe_valido = 0
			begin
				set @Mensaje = 'NPE no existe ...' 
				--select '-1' resultado, @CorrelativoGenerado as Correlativo, 'NPE no existe ...' as Descripcion
				print '-1 as resultado, '+cast(@CorrelativoGenerado as varchar(5))+' as Correlativo, NPE no existe ... as Descripcion' 
				select @respuesta = -1
			end	--	if @npe_valido = 0
			else
			begin
				if @CorrelativoGenerado = 0
				begin
					set @Mensaje = 'La cuota ya estaba cancelada con anterioridad' 
					--select '0' resultado, @CorrelativoGenerado as Correlativo, 'La cuota ya estaba cancelada con anterioridad' as Descripcion
					print '0 as resultado, '+cast(@CorrelativoGenerado as varchar(5))+' as Correlativo, La cuota ya estaba cancelada con anterioridad as Descripcion' 
					select @respuesta = 0
				end
				else	--	if @CorrelativoGenerado = 0
				begin
				set @Mensaje = 'Transacción generada de forma satisfactoria' 
					--select '1' resultado, @CorrelativoGenerado as Correlativo, 'Transacción generada de forma satisfactoria' as Descripcion
					print '1 as resultado, '+cast(@CorrelativoGenerado as varchar(5))+' as Correlativo, Transacción generada de forma satisfactoria as Descripcion' 
					select @respuesta = 1
				end		--	if @CorrelativoGenerado = 0
			end
		end	--	if @codper_encontrado = 0 
	-- 1: Exito registro de forma correcta el pago

	commit transaction 
	end try
	begin catch
		rollback transaction
		set @Mensaje = 'No se pudo generar la transacción' 
		insert into col_pagos_en_linea_estructuradoSP (codper, carnet, NumFactura, formapago, lote, MontoFactura, npe, TipoEstudiante, codppo ) 
		values (@codper, @carnet, @CorrelativoGenerado, @tipo, @lote, @MontoPagado, @npe, @TipoEstudiante, @IdGeneradoPreviaPagoOnLine)

		insert into col_ert_error_transaccion(ert_codper, ert_npe, ert_ciclo,ert_message,ert_numer,ert_severity,ert_state,ert_procedure,ert_line)
		values(@per_codigo, @npe, @cil_codigo,ERROR_MESSAGE() + ' ,' + @Mensaje,ERROR_NUMBER(),ERROR_severity(),error_state(),ERROR_procedure(),ERROR_line())
		
		--select '2' resultado, -1 as Correlativo, 'No se pudo generar la transacción' as Descripcion
		print '2 as resultado, -1 as Correlativo, No se pudo generar la transacción as Descripcion'
		select @respuesta = 2 
		-- 2: Error algun dato incorrecto no guardo ningun cambio
	end catch

	insert into col_ttpcb_tabla_temporal_carga_bancos (ttpcb_codper, ttpcb_npe, ttpcb_resultado, ttpcb_mensaje, ttpcb_usuario_transaccion) 
	select @codper, @npe, @respuesta, @Mensaje, @usuario
	print 'ttpcb_codigo ' + cast(scope_identity() as varchar(25))
	
end

alter procedure [dbo].[col_efpc_EncabezadoFacturaPagoCuotas] 
	@opcion int,
	@mov_codreg int,
	@mov_codigo int,
	@mov_recibo int,
	@mov_codcil int,
	@mov_codper int,
	@mov_descripcion nvarchar(50),
	@mov_tipo_pago nvarchar(3),
	@mov_cheque nvarchar(20),
	@mov_estado nvarchar(3),
	@mov_tarjeta nvarchar(25),
	@mov_usuario nvarchar(30),
	@mov_codmod int,
	@mov_tipo nvarchar(3),
	@mov_historia nvarchar(3),
	@mov_codban int,
	@mov_forma_pago nvarchar(5),
	@mov_lote int, 
	@mov_puntoxpress int, 
	@mov_recibo_puntoxpress nvarchar(20),
	@mov_coddip int,
	@mov_codfea int,
	@mov_codmdp int,
	@mov_fecha datetime,
	@mov_fecha_registro datetime,
	@mov_fecha_cobro datetime
AS
BEGIN
	set nocount on;
	if @opcion = 1 --Inserta el encabezado del pago, es invocado por: sp_insertar_pagos_x_carnet_estructurado
	begin
		insert into col_mov_movimientos(mov_codreg, mov_codigo, mov_recibo, mov_codcil, mov_codper, mov_descripcion, mov_tipo_pago, mov_cheque, mov_estado,
			mov_tarjeta, mov_usuario, mov_codmod, mov_tipo, mov_historia, mov_codban, mov_forma_pago, mov_lote, 
			mov_puntoxpress, mov_recibo_puntoxpress, mov_fecha_registro, mov_fecha_cobro, mov_fecha, mov_coddip, mov_codmdp, mov_codfea)
		--Values (@mov_codreg, @mov_codigo, @mov_recibo, @mov_codcil, @mov_codper, @mov_descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, 
		--	@mov_usuario, @mov_codmod, @mov_tipo, @mov_historia, @mov_codban, @mov_forma_pago, @mov_lote, @mov_puntoxpress, @mov_recibo_puntoxpress, 
		--	getdate(), getdate(), convert(varchar(20),getdate(),103), @mov_coddip, @mov_codmdp, @mov_codfea)
		Values (@mov_codreg, @mov_codigo, @mov_recibo, @mov_codcil, @mov_codper, @mov_descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, 
			@mov_usuario, @mov_codmod, @mov_tipo, @mov_historia, @mov_codban, @mov_forma_pago, @mov_lote, @mov_puntoxpress, @mov_recibo_puntoxpress, 
			@mov_fecha_registro, @mov_fecha_cobro, convert(varchar(20),@mov_fecha,103), @mov_coddip, @mov_codmdp, @mov_codfea)
		--values(1, @corr, '0', @cil_codigo, convert(varchar(20),getdate(),103), @per_codigo, @descripcion, 
		--'B','','R','',@usuario,getdate(),0,'F','N',@banco,'E', '', '', '',@lote,getdate(), @pal_codigo, @referencia )
	end

	if @opcion = 2 --Inserta el encabezado del pago, es invocado por: sp_insertar_pagos_x_carnet_estructurado_carga_banco
	begin
		insert into col_mov_movimientos(mov_codreg, mov_codigo, mov_recibo, mov_codcil, mov_codper, mov_descripcion, mov_tipo_pago, mov_cheque, mov_estado,
			mov_tarjeta, mov_usuario, mov_codmod, mov_tipo, mov_historia, mov_codban, mov_forma_pago, mov_lote, 
			mov_puntoxpress, mov_recibo_puntoxpress, mov_fecha_registro, mov_fecha_cobro, mov_fecha, mov_coddip, mov_codmdp, mov_codfea)
		Values (@mov_codreg, @mov_codigo, @mov_recibo, @mov_codcil, @mov_codper, @mov_descripcion, @mov_tipo_pago, @mov_cheque, @mov_estado, @mov_tarjeta, 
			@mov_usuario, @mov_codmod, @mov_tipo, @mov_historia, @mov_codban, @mov_forma_pago, @mov_lote, @mov_puntoxpress, @mov_recibo_puntoxpress, 
			@mov_fecha_registro, @mov_fecha_cobro, convert(varchar(20),@mov_fecha,103), @mov_coddip, @mov_codmdp, @mov_codfea)
	end
end

alter procedure [dbo].[elimina_data_colecturia_bancos]
	-- =============================================
	-- Author:      <DESCONOCIDO>
	-- Create date: <DESCONOCIDO>
	-- Last Modify: 2019-10-30 22:15:04.319 Fabio
	-- Description: <Borrar los registros de las tablas donde se cargar la data subida en el archivo. txt de la carga de banco>
	-- =============================================
	-- elimina_data_colecturia_bancos
as
begin
	delete from archivo_agricola
	delete from archivo_cuscatlan
	delete from archivo_promerica
	delete from archivo_salvador
	delete from archivo_puntoxpress
	delete from archivo_gt
	delete from archivo_scotiabank
	delete from col_datb_data_bancos
end


----DELETES
--delete from col_datb_data_bancos

--set dateformat dmy
--declare 	@fecha varchar(20) = '01/11/2019',
--@fecha_archivo varchar(20) = '02/11/2019',
--@factura int = 43000,
--@banco int = 46, 
--@tipo_pago char(1) = 'N',
--@px char(1) = 'N'

--set dateformat dmy
--declare @data as table (nombres varchar(125), carnet varchar(16), factura varchar(32), tipo varchar(10), banco int, valor money, cuota int, ciclo varchar(8), estado varchar(55), fechaColecturia nvarchar(12), fechaBanco nvarchar(12))
--insert into @data (nombres, carnet, factura, tipo, banco, valor, cuota, ciclo, estado, fechaColecturia, fechaBanco)
--/*delete*/select 
--		isnull(
--			(
--				select per_nombres_apellidos 
--				from ra_per_personas 
--				where replace(per_carnet, '-', '') = alumno or cast(alumno as bigint) = per_codigo and per_estado = 'A'
--			),
--			'CARNET NO ENCONTRADO'
--		) nombres,
--		isnull(
--			(
--				select replace(per_carnet, '-', '') 
--				from ra_per_personas 
--				where replace(per_carnet, '-', '') = alumno or cast(alumno as bigint) = per_codigo and per_estado = 'A'
--			),
--			'NO ENCONTRADO'
--		) carnet,
--		--alumno as carnet, 
--		factura, tipo, banco, valor, cuota, ciclo,
--		case when estado = 0 then 'CORRECTO' when estado = 1 then 'NO SE CARGARA' end estado,
--		@fecha as fechaColecturia, @fecha_archivo as fechaBanco
--from archivo_bancos_final 
--where banco = @banco 
--and puntoxpress = case when @px = 'N' then 0 when @px = 'S' then 1 end
--and fecha = @fecha
--and convert(varchar(20),fecha_archivo,103) = @fecha_archivo
--and tipo = @tipo_pago
--order by estado desc

--insert into col_cbi_carga_banco_incorrecto (cbi_nombres, cbi_carnet, cbi_factura, cbi_tipo, cbi_codban, cbi_valor, cbi_cuota, cbi_ciclo, cbi_estado, cbi_fecha_col, cbi_fecha_ban)
--select * from @data

--select * from @data

--delete from col_dmo_det_mov where dmo_codmov in (select mov_codigo from col_mov_movimientos where mov_usuario = 'fabio.ramos')
--delete from col_mov_movimientos where mov_usuario = 'fabio.ramos'

select  * from col_ttpcb_tabla_temporal_carga_bancos order by ttpcb_codigo desc
select * from col_datb_data_bancos
select top 25 * from col_mov_movimientos order by mov_codigo desc