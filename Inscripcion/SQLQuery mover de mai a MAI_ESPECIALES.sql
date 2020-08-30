rep_carga_academica_escuelas 1,123,4,'T'--'%INDU%'

select * from dbo.ra_ins_inscripcion--115
inner join dbo.ra_mai_mat_inscritas on mai_codins = ins_codigo
where ins_codcil = 123 
and  mai_codmat like '%INDU%'
order by mai_codigo

select * from dbo.ra_ins_inscripcion--115
inner join dbo.ra_mai_mat_inscritas_especial on mai_codins = ins_codigo
where ins_codcil = 123 
and  mai_codmat like '%INDU%'
and ins_usuario_creacion = 'user.online'
order by mai_codigo


--*********REPLICAR DE DESARROLLO A PRODUCCION LOS SP´s*********--
	--web_ins_cuposinserinscripcion_nodjs
	--web_ins_cuposinserinscripcion_nodjs_azure
	--web_mod_ins_cuposinserinscripcion_nodjs
	--web_mod_ins_cuposinserinscripcion_nodjs_azure



--*********CURSOR PARA MOVER DE MAI A MAI_ESPECIAL*********--
--*********EJECUTAR DESDE --Inicio, hasta --Fin *********--
--Inicio
	declare @mai_codigo int, @mai_codins int, @mai_codmat varchar(50), @mai_codhpl int, @mai_codpla int

	declare m_cursor cursor 
	for
		select mai_codigo, mai_codins, mai_codmat, mai_codhpl, mai_codpla from dbo.ra_ins_inscripcion--115
		inner join dbo.ra_mai_mat_inscritas on mai_codins = ins_codigo
		where ins_codcil = 123 
		and  mai_codmat like '%INDU%'
		order by mai_codigo
	open m_cursor 
 
	fetch next from m_cursor into @mai_codigo, @mai_codins, @mai_codmat, @mai_codhpl, @mai_codpla
	while @@FETCH_STATUS = 0 
	begin
		insert into dbo.ra_mai_mat_inscritas_especial
		(mai_codreg, mai_codins, mai_codigo, mai_codmat, mai_codhor, mai_estado, mai_matricula, mai_fecha, 
		mai_acuerdo, mai_fecha_acuerdo, mai_financiada, mai_codpla, mai_uv, mai_tipo)
		select 
			1, @mai_codins, max(mai_codigo)+1, @mai_codmat, @mai_codhpl, 'I', 1, getdate(), 
			'',  NULL, 'N', @mai_codpla, 0, 'n'
		from ra_mai_mat_inscritas_especial
	
		delete from ra_not_notas where not_codmai = @mai_codigo
		delete from ra_mai_mat_inscritas where mai_codigo = @mai_codigo
	
		fetch next from m_cursor into @mai_codigo, @mai_codins, @mai_codmat, @mai_codhpl, @mai_codpla
	end      
	close m_cursor  
	deallocate m_cursor
--Fin