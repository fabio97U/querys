USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[pol_pago_online_pregrado_web]    Script Date: 10/2/2020 15:23:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--	exec pol_pago_online_pregrado_web 1,'43-0167-2018','','cindy.carrillo@sykes.com',''
--	exec pol_pago_online_pregrado_web 8,'00-0001-0717','Guillermo47','guilleijc@gmail.com','.0123456789(Mz)'
ALTER PROCEDURE [dbo].[pol_pago_online_pregrado_web]
	@opcion int,
	@per_carnet varchar(50),
	@upo_usuario varchar(50),
	@upo_email varchar(50),
	@upo_pwd varchar(50)
AS
BEGIN	
	DECLARE @codper int 

	if @opcion = 1
	Begin
		--ALUMNOS PREGRADO GENERAL
		--select per_codigo from ra_per_personas 
		--where rtrim(ltrim(per_carnet)) = rtrim(ltrim(@per_carnet)) and per_estado='A' and per_tipo='U' and rtrim(ltrim(per_email))=rtrim(ltrim(@upo_email)) or rtrim(ltrim(per_email_opcional))=rtrim(ltrim(@upo_email))
		
		----SOLO PARA VIRTUALES

		select @codper = per_codigo from ra_per_personas where per_carnet = @per_carnet

		select per_codigo from ra_per_personas 
		join ra_car_carreras on car_identificador=substring(per_carnet,1,2)
		where rtrim(ltrim(per_carnet)) = rtrim(ltrim(@per_carnet)) 
		and per_estado in('A','E')  and per_tipo in('U','M')  and (car_nombre like '%no presencial%' or  car_nombre like '%maestria%')
		--and rtrim(ltrim(per_email)) = rtrim(ltrim(@upo_email)) 
		--or rtrim(ltrim(per_email_opcional)) = rtrim(ltrim(@upo_email))
		and per_codigo = @codper
	End

	if @opcion = 2
	begin
		select @codper =per_codigo from ra_per_personas where per_carnet=@per_carnet and per_estado in('A','E') and per_tipo in('U','M')

		if exists(select upo_id from user_pago_online where rtrim(ltrim(upo_usuario))=rtrim(ltrim(@upo_usuario)) or rtrim(ltrim(upo_codper))=rtrim(ltrim(@codper)))
		begin
			select 'El usuario ya tiene cuenta' mensaje
		end
		else 
		begin 
			Insert Into user_pago_online (upo_usuario, upo_pwd,upo_email, upo_codper,upo_estado)
			Values (@upo_usuario, dbo.dkrpt(@upo_pwd,'E'),@upo_email, @codper,'R')

			select 'Se agrego exitosamente' mensaje
		end
	end
	if @opcion = 3
	begin
		Select * from user_pago_online 
		join ra_per_personas on upo_codper=per_codigo
		Where rtrim(ltrim(upo_usuario)) = rtrim(ltrim(@upo_usuario)) and per_estado in('A','E') and per_tipo in('U','M') and rtrim(ltrim(dbo.dkrpt(upo_pwd,'D'))) = rtrim(ltrim(@upo_pwd)) and upo_estado='C' and per_carnet<>'0000000000'
	end
	if @opcion=4
	begin
		select @codper =per_codigo from ra_per_personas where per_carnet=@per_carnet and per_estado in('A','E') and per_tipo='U'

		delete from user_pago_online where upo_codper=rtrim(ltrim(@codper))
		select '1' mensaje
	end
	if @opcion=5
	begin 
		update user_pago_online set upo_estado='C' where upo_codper=Cast(@per_carnet as integer)
		select '1' mensaje


		select * from user_pago_online
	end
	if @opcion=6
	begin 
		insert into user_hia_historico_acceso(hia_nombre,hia_clave,hia_estado_anterior) 
		values(@upo_usuario,dbo.dkrpt(@upo_pwd,'E'),'B')

		update user_pago_online set upo_estado='B' 
		where rtrim(ltrim(upo_usuario))=rtrim(ltrim(@upo_usuario)) 
		
		select '1' mensaje
	end
	if @opcion=7
	begin 
		select * from ra_per_personas 
		where rtrim(ltrim(per_codigo)) = rtrim(ltrim(@per_carnet))
	end 






	if @opcion = 8
	Begin

	-------------------------------------------------------------------------------------------------------------------------------------------------------------
		----ALUMNOS PREGRADO GENERAL
		----select per_codigo from ra_per_personas 
		----where rtrim(ltrim(per_carnet)) = rtrim(ltrim(@per_carnet)) and per_estado='A' and per_tipo='U' and rtrim(ltrim(per_email))=rtrim(ltrim(@upo_email)) or rtrim(ltrim(per_email_opcional))=rtrim(ltrim(@upo_email))
		
		------SOLO PARA VIRTUALES
		--select per_codigo from ra_per_personas 
		--join ra_car_carreras on car_identificador=substring(per_carnet,1,2)
		--where rtrim(ltrim(per_carnet)) = rtrim(ltrim(@per_carnet)) 
		----and per_estado in('A','E') and car_nombre like '%no presencial%' or  car_nombre like '%maestria%'  and per_tipo in('U','M') 
		--and per_tipo = 'TI' 
		--and rtrim(ltrim(per_email))=rtrim(ltrim(@upo_email)) 
		----or rtrim(ltrim(per_email_opcional))=rtrim(ltrim(@upo_email))

		----   select per_carnet,per_codigo, per_email_opcional,per_email from ra_per_personas where per_tipo = 'TI'
		-------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		select per_codigo from ra_per_personas 
		--join ra_car_carreras on car_identificador=substring(per_carnet,1,2)
		inner join 
		ra_alc_alumnos_carrera  on alc_codper = per_codigo inner join ra_pla_planes on alc_codpla = pla_codigo 
		where 
		rtrim(ltrim(per_carnet)) = rtrim(ltrim(@per_carnet)) 
		----and per_estado in('A','E') and car_nombre like '%no presencial%' or  car_nombre like '%maestria%'  and per_tipo in('U','M') 
		and 
		per_tipo = 'TI'
		and 
		rtrim(ltrim(per_email))=rtrim(ltrim(@upo_email)) 
		order by per_carnet desc
 
	End


	if @opcion = 9
	begin
		Select * from user_pago_online 
		join ra_per_personas on upo_codper=per_codigo
		Where 
		rtrim(ltrim(upo_usuario)) = rtrim(ltrim(@upo_usuario)) 
		--and per_estado in('A','E') 
		--and per_tipo in('U','M') 
		and per_tipo = 'TI' 
		and rtrim(ltrim(dbo.dkrpt(upo_pwd,'D'))) = rtrim(ltrim(@upo_pwd)) 
		and upo_estado='C' 
		and per_carnet<>'0000000000'
	end


	if @opcion = 10
	begin
		select @codper =per_codigo from ra_per_personas where per_carnet=@per_carnet and per_tipo = 'TI'
		--select @codper =per_codigo from ra_per_personas where per_carnet=@per_carnet and per_estado in('A','E') and per_tipo in('U','M')

		if exists(select upo_id from user_pago_online where rtrim(ltrim(upo_usuario))=rtrim(ltrim(@upo_usuario)) or rtrim(ltrim(upo_codper))=rtrim(ltrim(@codper)))
		begin
			select 'El usuario ya tiene cuenta' mensaje
		end
		else 
		begin 
			Insert Into user_pago_online (upo_usuario, upo_pwd,upo_email, upo_codper,upo_estado)
			Values (@upo_usuario, dbo.dkrpt(@upo_pwd,'E'),@upo_email, @codper,'R')

			select 'Se agrego exitosamente' mensaje
		end
	end






END
select * from ra_per_personas where per_codigo = 225898--58-3077-2020
select *, dbo.dkrpt(upo_pwd,'D') from user_pago_online order by upo_id desc
select * from err_errores_sistema
