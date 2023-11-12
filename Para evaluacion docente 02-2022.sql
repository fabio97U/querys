USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[web_ceed_crear_evaluacion_estudiantil_docente_emergencia]    Script Date: 15/10/2022 16:04:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2020-10-08 16:45:38.107>
	-- Description: <Migra la encuesta de "emergencia" de un ciclo a otro>
	-- =============================================
	-- exec web_ceed_crear_evaluacion_estudiantil_docente_emergencia 1, 1, 122, 123 -- Migra encuesta  de presencial pregrado del ciclo "@codcil_encuesta_origen" al "@codcil_encuesta_destino"
	-- exec web_ceed_crear_evaluacion_estudiantil_docente_emergencia 1, 1, 0, 129, 6 -- Copia la encuesta "@codenc_copiar" para el ciclo "@codcil_encuesta_destino"
ALTER procedure [dbo].[web_ceed_crear_evaluacion_estudiantil_docente_emergencia]
	@opcion int = 0,
	@codtde int = 0,
	@codcil_encuesta_origen int = 0,
	@codcil_encuesta_destino int = 0,
	@codenc_copiar int = 0
as
begin

	if @opcion = 1
	begin
		
		if not exists (select 1 from emer_enc_encuestas where enc_codcil = @codcil_encuesta_destino and enc_codtde = @codtde)--Si el ciclo destino no tiene encuesta para el @codtde
			or @codenc_copiar <> 0
		begin
			-- select * from emer_enc_encuestas where enc_codcil = @codcil_encuesta_origen and enc_codtde = @codtde
			-- select * from emer_grupe_grupos_estudio
			-- select * from emer_pre_preguntas
			-- select * from emer_opc_opciones
			-- select * from emer_preopc_preguntas_opciones
			declare @codenc_origen int
			declare @max_codenc int, @max_grupe int, @max_pre int, @max_opc int

			declare @tbl_grupe as table (grupe_nuevo_codigo int, grupe_codigo int, 
			grupe_nombre varchar(255), grupe_nuevo_codenc int, grupe_orden int, grupe_detalle varchar(2500), grupe_porcentaje int)
			declare @tbl_pre as table (
				pre_nuevo_codigo int,
				pre_codigo int,
				pre_codtipp int,
				pre_nuevo_codgrupe int,
				pre_codgrupe int,
				pre_orden_general int, -- numero de pregunta en la encuesta
				pre_orden int, -- numero de pregunta en el grupo
				pre_pregunta varchar(1024)
			)
			declare @tbl_opc as table (opc_nuevo_codigo int, opc_codigo int, opc_nueva_codenc int, opc_codenc int, opc_opcion varchar(255))
			declare @tbl_preopc as table (
				preopc_nueva_codpre int,
				preopc_nueva_codopc int,
				preopc_codtipo int,
				preopc_opc_orden int

			)

			if @codenc_copiar = 0 --Si no tiene encuesta a copia
			begin
				select @codenc_origen = enc_codigo from emer_enc_encuestas
				where enc_codcil = @codcil_encuesta_origen and enc_codtde = @codtde
			end
			else
			begin
				set @codenc_origen = @codenc_copiar
			end

			if (isnull(@codenc_origen, 0) <> 0) -- Si el ciclo origen tiene encuesta para el @codtde
			begin
				select @max_codenc = max(enc_codigo) + 1 from emer_enc_encuestas
				select @max_grupe = max(grupe_codigo) from emer_grupe_grupos_estudio
				select @max_pre = max(pre_codigo) from emer_pre_preguntas
				select @max_opc = max(opc_codigo) from emer_opc_opciones

				insert into @tbl_grupe
				(grupe_nuevo_codigo, grupe_codigo, grupe_nombre, grupe_nuevo_codenc, grupe_orden, grupe_detalle, grupe_porcentaje)
				select @max_grupe +  row_number() over(order by grupe_codigo),
				grupe_codigo, grupe_nombre, @max_codenc, grupe_orden, grupe_detalle, grupe_porcentaje 
				from emer_grupe_grupos_estudio
				where grupe_codenc = @codenc_origen
				--select * from @tbl_grupe

				--Preguntas
				insert into @tbl_pre (pre_nuevo_codigo, pre_codigo, pre_codtipp, pre_nuevo_codgrupe, pre_codgrupe, pre_orden_general, pre_orden, pre_pregunta)
				select  @max_pre +  row_number() over(order by pre_codigo), 
				pre.pre_codigo 'pre_codigo', pre.pre_codtipp 'pre_codtipp', tbl_grupe.grupe_nuevo_codigo 'grupe_nuevo_codigo', pre.pre_codgrupe 'pre_codgrupe', pre.pre_orden_general 'pre_orden_general', pre.pre_orden 'pre_orden', pre.pre_pregunta 'pre_pregunta'
				from emer_grupe_grupos_estudio as grupe
				inner join emer_pre_preguntas as pre on pre_codgrupe = grupe.grupe_codigo
				inner join @tbl_grupe as tbl_grupe on tbl_grupe.grupe_codigo = grupe.grupe_codigo
				where grupe.grupe_codenc = @codenc_origen
				--select * from @tbl_pre
				
				----Opciones
				insert into @tbl_opc (opc_nuevo_codigo, opc_codigo, opc_nueva_codenc, opc_codenc, opc_opcion)
				select @max_opc +  row_number() over(order by opc_codigo), 
				opc_codigo, @max_codenc, opc_codenc, opc_opcion
				from emer_enc_encuestas
				inner join emer_opc_opciones as opc on opc_codenc = enc_codigo
				where opc_codenc = @codenc_origen
				--select * from @tbl_opc

				--Preguntas-Opciones
				insert into @tbl_preopc(preopc_nueva_codpre, preopc_nueva_codopc, preopc_codtipo, preopc_opc_orden)
				select tbl_p.pre_nuevo_codigo, tbl_o.opc_nuevo_codigo, preopc_codtipo, preopc_opc_orden 
				from emer_preopc_preguntas_opciones
				inner join @tbl_pre tbl_p on tbl_p.pre_codigo = preopc_codpre
				inner join @tbl_opc tbl_o on tbl_o.opc_codigo = preopc_codopc

				--Insertando en las tablas
				insert into emer_enc_encuestas (enc_nombre, enc_codpon, enc_codcil, enc_codtde, enc_objetivo, enc_fecha_inicio, enc_fecha_fin)
				select enc_nombre, enc_codpon, @codcil_encuesta_destino 'enc_codcil', @codtde 'enc_codtde', enc_objetivo, enc_fecha_inicio, enc_fecha_fin 
				from emer_enc_encuestas
				where enc_codigo = @codenc_origen

				insert into emer_grupe_grupos_estudio (grupe_nombre, grupe_codenc, grupe_orden, grupe_detalle, grupe_porcentaje)
				select grupe_nombre, grupe_nuevo_codenc, grupe_orden, grupe_detalle, grupe_porcentaje
				from @tbl_grupe

				insert into emer_pre_preguntas (pre_codtipp, pre_codgrupe, pre_orden_general, pre_orden, pre_pregunta)
				select pre_codtipp, pre_nuevo_codgrupe, pre_orden_general, pre_orden, pre_pregunta 
				from @tbl_pre

				insert into emer_opc_opciones (opc_codenc, opc_opcion)
				select opc_nueva_codenc, opc_opcion from @tbl_opc
					
				insert into emer_preopc_preguntas_opciones (preopc_codpre, preopc_codopc, preopc_codtipo, preopc_opc_orden)
				select preopc_nueva_codpre, preopc_nueva_codopc, preopc_codtipo, preopc_opc_orden 
				from @tbl_preopc
					
				select concat('Codigo de la encuesta: ', @max_codenc) res
			end
		end
		else
		begin
			print concat('Ya existe una encuesta en el ciclo ', @codcil_encuesta_destino, ' para el tipo de estudio ', @codtde)
			declare @enc_codigo int = 0
			select @enc_codigo = enc_codigo from emer_enc_encuestas where enc_codcil = @codcil_encuesta_destino and enc_codtde = @codtde
			exec sp_data_emer_encuestas @opcion = 1, @codenc = @enc_codigo
		end
	end
end
go

exec dbo.sp_data_emer_encuestas 1, 5--carrera presencial con aula fisica
exec dbo.sp_data_emer_encuestas 1, 6--carrera presencial en linea

exec web_ceed_crear_evaluacion_estudiantil_docente_emergencia 1, 1, 0, 129, 5 -- Copia la encuesta 5
exec web_ceed_crear_evaluacion_estudiantil_docente_emergencia 1, 1, 0, 129, 6 -- Copia la encuesta 6

exec dbo.sp_data_emer_encuestas 1, 7--carrera presencial con aula fisica
exec dbo.sp_data_emer_encuestas 1, 8--carrera presencial con aula fisica

select * from emer_enc_encuestas

update emer_enc_encuestas set enc_fecha_inicio = '2022-10-17', enc_fecha_fin = '2022-10-31', enc_codpon = 3, enc_modalidad = 1
, enc_nombre = 'Evaluación Estudiantil al Docente <br><strong>Presencial</strong><br>Ciclo 02-2022'
where enc_codigo = 7

update emer_enc_encuestas set enc_fecha_inicio = '2022-10-17', enc_fecha_fin = '2022-10-31', enc_codpon = 3, enc_modalidad = 2
, enc_nombre = 'Evaluación Estudiantil al Docente<br><strong>Presencial en Línea</strong><br>Ciclo 02-2022' 
where enc_codigo = 8

select * from emer_encenc_encabezado_encuesta where encenc_codenc in (7, 8)
select * from emer_detenc_detalle_encuesta where detenc_codencenc in (101228)



select * from emer_enc_encuestas where enc_fecha_creacion > '2022-10-01'
--dbcc checkident (emer_enc_encuestas, reseed, 6)

select * from emer_grupe_grupos_estudio where grupe_fecha_creacion > '2022-10-01'
--dbcc checkident (emer_grupe_grupos_estudio, reseed, 32)

select * from emer_pre_preguntas where pre_fecha_creacion > '2022-10-01'
--dbcc checkident (emer_pre_preguntas, reseed, 187)

select * from emer_opc_opciones where opc_fecha_creacion > '2022-10-01'
--dbcc checkident (emer_opc_opciones, reseed, 155)

select * from emer_preopc_preguntas_opciones where preopc_fecha_creacion > '2022-10-01'
--dbcc checkident (emer_preopc_preguntas_opciones, reseed, 609)