--SOLICITADO POR: LIGIA HENRIQUEZ
--DESCRIPCION: SOLICITAR DESDE EL PORTAL DEL ALUMNO LAS PRORROGAS PARA PREESPECIALIDAD, UTILIZAR LAS MISMA LOGICA DEL PROCESO MANUAL
--DESARROLLADORES INVOLUCRADOS: FABIO

/*delete from ra_prp_prorroga_prees where prp_codigo in(select prp_codigo
from ra_prp_prorroga_prees
inner join 
ra_per_personas as per on prp_codper = per.per_codigo
inner join 
ra_cil_ciclo as cil on prp_codcil = cil.cil_codigo
inner join 
ra_cic_ciclos as cic on cil.cil_codcic = cic.cic_codigo
inner join col_tmo_tipo_movimiento as tmo on prp_codtmo = tmo.tmo_codigo where per_carnet = '13-1647-2015')*/


create table ra_fpropre_fechas_prorrogas_pre(fpropre_codigo int primary key identity(1,1),
fpropre_codcil int foreign key references ra_cil_ciclo,
fpropre_codtmo int foreign key references col_tmo_tipo_movimiento,
fpropre_inicio nvarchar(10),
fpropre_fin nvarchar(10),
fpropre_creacion datetime default getdate());
go

insert into ra_fpropre_fechas_prorrogas_pre(fpropre_codcil, fpropre_codtmo, fpropre_inicio, fpropre_fin) values
(117, 188, '2018-11-15 00:00:00.000', '2018-11-21 11:22:29.693'),
(117, 190, '2018-11-22 11:22:29.693', '2018-11-26 11:22:29.693'),
(117, 192, '2018-11-27 11:22:29.693', '2018-11-29 11:22:29.693'),
(117, 193, '2018-11-30 11:22:29.693', '2018-12-28 11:22:29.693');
go
--select * from ra_fpropre_fechas_prorrogas_pre
				
alter procedure proc_ra_fpropre_fechas_prorrogas_pre
	--proc_ra_fpropre_fechas_prorrogas_pre 1, 0,117,0,'',''
	-- =============================================
	-- Author:		<Fabio>
	-- Create date: <18/11/2018>
	-- Description:	<Realiza el manteminiento a la tabla(ra_fpropre_fechas_prorrogas_pre) de las fechas de prorrogas de la pre especialidad>
	-- =============================================
	@opcion int,
	@fpropre_codigo int = 1,
	@fpropre_codcil int = 1,
	@fpropre_codtmo int = 1,
	@fpropre_inicio nvarchar(10),
	@fpropre_fin nvarchar(10)
as
begin
	set dateformat dmy
	if(@opcion = 1)--Muestra
	begin
		select fpropre.fpropre_codigo,fpropre.fpropre_codcil, tmo.tmo_descripcion, cast(fpropre.fpropre_inicio as date) as fpropre_inicio, cast(fpropre.fpropre_fin as date) as fpropre_fin, fpropre.fpropre_codtmo, tmo.tmo_arancel 
		from ra_fpropre_fechas_prorrogas_pre as fpropre
		inner join col_tmo_tipo_movimiento as tmo on fpropre.fpropre_codtmo = tmo.tmo_codigo
		where fpropre_codcil = @fpropre_codcil
	end
	if(@opcion = 2)--Inserta
	begin
		if((select count(1) from ra_fpropre_fechas_prorrogas_pre where
		 fpropre_codcil = @fpropre_codcil and fpropre_codtmo=@fpropre_codtmo)>0)--Valida si existe fecha de prorrogas
		begin
			select 'Ya existen fechas para prorrogas'
		end
		else
		begin
			if(cast(@fpropre_inicio as date)  >= cast(@fpropre_fin as date))--Valida que la fecha de inicio no sea mayor que la final
			begin
				select 'f_inicio >= f_fin'
			end
			else
			begin--Agrega
				insert into ra_fpropre_fechas_prorrogas_pre(fpropre_codcil, fpropre_codtmo, fpropre_inicio, fpropre_fin) 
				values(@fpropre_codcil, @fpropre_codtmo, cast(@fpropre_inicio as date),cast(@fpropre_fin as date));
				select 'Agregado'
			end
		end
	end
	if(@opcion = 3)--Update
	begin
		if(cast(@fpropre_inicio as date)  >= cast(@fpropre_fin as date))--Valida que la fecha de inicio no sea mayor que la final
		begin
			select 'f_inicio >= f_fin'
		end
		else
		begin--Actualiza
			update ra_fpropre_fechas_prorrogas_pre set 
			fpropre_codcil = @fpropre_codcil, fpropre_codtmo=@fpropre_codtmo, 
			fpropre_inicio=@fpropre_inicio, fpropre_fin=@fpropre_fin
			where fpropre_codigo = @fpropre_codigo
			select 'Actualizado'
		end
	end
end
go

create procedure proc_ra_mostrar_arancel_para_prorroga_preespecialidad
--proc_ra_mostrar_arancel_para_prorroga_preespecialidad '2018-11-20', 117
-- =============================================
-- Author:		<Fabio>
-- Create date: <19/11/2018>
-- Description:	<Devuelve la el codigo de tipo movimiento que se encuetra segun la fecha, si no hay fecha de prorrogra devuelve 0>
-- =============================================
	@fecha date,
	@codcil int
as
begin

	declare @fpropre_codtmo int, @tmo_arancel varchar(50)
	select @fpropre_codtmo = fpropre_codtmo, @tmo_arancel = tmo.tmo_descripcion from ra_fpropre_fechas_prorrogas_pre as fpropre inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = fpropre.fpropre_codtmo 
	where cast(@fecha as date) BETWEEN fpropre.fpropre_inicio and fpropre.fpropre_fin and tmo.tmo_descripcion not like '%Beca%' and fpropre.fpropre_codcil = @codcil

	print 'Codigo cuota pagar: @fpropre_codtmo' + cast(@fpropre_codtmo as varchar(10))	+ ', @monto: '+@tmo_arancel
	if (count(@fpropre_codtmo)) > 0
	begin
		select @fpropre_codtmo as fpropre_codtmo
	end
	else
	begin
		select 0 as fpropre_codtmo 
	end
end
go

alter procedure proc_seccion_alumno_pre
	-- proc_seccion_alumno_pre 187, 117, 181413 
	-- proc_seccion_alumno_pre 187, 117, 152761 
	-- =============================================
	-- Author:		<Fabio>
	-- Create date: <19/11/2018>
	-- Description:	<Devuelve el modulo y la fecha limite(Fecha_Examen) para solicitar prorroga del alumno, si no se a asignado una fecha para prorroga devuelve vacio>
	-- =============================================
	@codtmo int,
	@codcil int,
	@codper int
as
begin
	declare @evalucaion int, @mpr_nombre varchar(150), @hmp_descripcion varchar(5), @nombre_pre varchar(150)
	select  @evalucaion = arev_evaluacion from pg_arev_aranceles_x_evaluacion where arev_codtmo = @codtmo and arev_proceso = (select cil_codcic from ra_cil_ciclo where cil_codigo  = @codcil)
	
	declare @tabla_secciones as table(sec varchar(5), mpr int, modulo varchar(6));

	insert into  @tabla_secciones(sec, mpr, modulo)
	SELECT distinct hmp_descripcion sec,mpr_codigo mpr,pg_pmp_ponderacion.pmp_nombre_corto modulo
	FROM  (select  * from (select * from  pg_pmp_ponderacion left join (select * from pg_nmp_notas_mod_especializacion where  nmp_codimp = (select max(imp_codigo) from pg_imp_ins_especializacion where imp_codper=@codper )) t
	 on pmp_codigo = t.nmp_codpmp ) a , pg_imp_ins_especializacion where imp_codper=@codper)  r
	INNER JOIN pg_apr_aut_preespecializacion ON apr_codigo = r.imp_codapr 
	INNER JOIN pg_hmp_horario_modpre ON hmp_codapr = apr_codigo and hmp_codigo = imp_codhmp
	INNER JOIN pg_pre_preespecializacion ON pre_codigo = apr_codpre
	INNER JOIN pg_pmp_ponderacion on pg_pmp_ponderacion.pmp_codigo = r.pmp_codigo
	INNER JOIN pg_mpr_modulo_preespecializacion ON mpr_codpre=pre_codigo and mpr_orden = pg_pmp_ponderacion.pmp_orden
	INNER JOIN ra_pgc_pre_esp_carrera on pre_codigo=pgc_codpre
	INNER JOIN ra_per_personas on per_codigo = imp_codper
	INNER JOIN ra_cil_ciclo on cil_codigo = apr_codcil
	INNER JOIN ra_cic_ciclos on cic_codigo = cil_codcic
	WHERE     (ra_per_personas.per_codigo = @codper ) AND (pg_apr_aut_preespecializacion.apr_codcil  = @codcil) AND (mpr_visible = 'S')
	--select* from @tabla_secciones
	SELECT distinct 
					@nombre_pre = pg_pre_preespecializacion.pre_nombre,
					@mpr_nombre = mpr_nombre,
					@hmp_descripcion = hmp_descripcion
	FROM  (select  * from (select * from  pg_pmp_ponderacion left join (select * from pg_nmp_notas_mod_especializacion where  nmp_codimp = (select max(imp_codigo) from pg_imp_ins_especializacion where imp_codper=@codper )) t
		on pmp_codigo = t.nmp_codpmp ) a , pg_imp_ins_especializacion where imp_codper=@codper )  r
	INNER JOIN pg_apr_aut_preespecializacion ON apr_codigo = r.imp_codapr 
	INNER JOIN pg_pre_preespecializacion ON pre_codigo = apr_codpre
	INNER JOIN pg_pmp_ponderacion on pg_pmp_ponderacion.pmp_codigo = r.pmp_codigo
	INNER JOIN pg_mpr_modulo_preespecializacion ON mpr_codpre=pre_codigo and mpr_orden = pg_pmp_ponderacion.pmp_orden
	INNER JOIN pg_hmp_horario_modpre ON pg_pre_preespecializacion.pre_codigo = pg_mpr_modulo_preespecializacion.mpr_codpre AND pg_hmp_horario_modpre.hmp_codmpr = pg_mpr_modulo_preespecializacion.mpr_codigo  
	INNER JOIN ra_pgc_pre_esp_carrera on pre_codigo=pgc_codpre
	INNER JOIN ra_car_carreras ON car_codigo = pgc_codcar
	INNER JOIN ra_fac_facultades on fac_codigo=car_codfac
	INNER JOIN ra_per_personas on per_codigo = imp_codper
	INNER JOIN ra_alc_alumnos_carrera ON alc_codper = per_codigo
	INNER JOIN ra_pla_planes ON pla_codigo = alc_codpla
	INNER JOIN ra_reg_regionales ON per_codreg = reg_codigo
	INNER JOIN ra_uni_universidad ON uni_codigo = reg_coduni
	INNER JOIN ra_cil_ciclo on cil_codigo = apr_codcil
	INNER JOIN ra_cic_ciclos on cic_codigo = cil_codcic
	join @tabla_secciones s on hmp_codmpr=s.mpr and hmp_descripcion=s.sec 
	WHERE ra_per_personas.per_codigo = @codper AND pg_apr_aut_preespecializacion.apr_codcil  = @codcil AND mpr_visible = 'S' and mpr_orden = @evalucaion
	
	print 'Pre: '+ @nombre_pre
	print 'Mod: '+ @mpr_nombre
	print 'Sec: '+ @hmp_descripcion 
	print 'Eva: '+ cast(@evalucaion as varchar(5))

	select femp_codigo, pre_nombre as Preespecialidad,mpr_nombre as Modulo,hmp_descripcion as seccion,femp_fecha as Fecha_Examen,cic_nombre + '-' + CAST(ra_cil_ciclo.cil_anio AS varchar) AS Ciclo, CONCAT('Mod.',mpr_orden)  as 'Mod_N'
	from prees_femp_fechasExamenes_ModuloPrees
		join pg_hmp_horario_modpre on hmp_codigo = femp_codhmp
		join pg_mpr_modulo_preespecializacion on mpr_codigo = hmp_codmpr
		join  pg_pre_preespecializacion on pre_codigo = mpr_codpre
		join ra_cil_ciclo on cil_codigo = femp_codcil
		join ra_cic_ciclos on cic_codigo = cil_codcic
	where cil_codigo = @codcil and	mpr_nombre = @mpr_nombre and hmp_descripcion = @hmp_descripcion
	order by cil_codigo, pre_codigo
end
go
