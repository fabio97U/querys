	declare @fi varchar(10) = '01/07/2021',
	@ff varchar(10) = '16/08/2021', 
	@codcil int = 126,
	@per_tipo nvarchar(5) = 'U'

	set dateformat dmy
	
	Declare @fechaFinQ Datetime = @ff
    set @fechaFinQ = DATEADD(DAY, 1, @fechaFinQ)
    set @fechaFinQ = DATEADD(MINUTE, -1, @fechaFinQ)
	

	declare @ins table (codper_ins int)
	declare @NI table(codper_NI int, tipo_NI nvarchar(50), codpla int)
	declare @pagos table(cant int, per int)

	insert into @pagos (cant, per)
	Select count(mov_codper), mov_codper
	from col_mov_movimientos 
		inner join col_dmo_det_mov on dmo_codmov = mov_codigo 
		inner join col_tmo_tipo_movimiento as tmo on tmo.tmo_codigo = dmo_codtmo 
		inner join vst_Aranceles_x_Evaluacion as vst on vst.are_codtmo = tmo.tmo_codigo and vst.tmo_arancel = tmo.tmo_arancel
	where are_cuota <= 1 and dmo_codcil in (@codcil, (select iif(cil_codcic = 2, cil_codigo + 1, cil_codigo) from ra_cil_ciclo where cil_codigo = @codcil)) --and mov_codper = 216644
	group by mov_codper

	declare @ciclo char(7)
	select @ciclo = '0' + rtrim(cil_codcic) + '-' + rtrim(cil_anio) from ra_cil_ciclo where cil_codigo=@codcil

	insert into @ins(codper_ins)
	select ins_codper 
	from ra_ins_inscripcion 
	where ins_codcil = @codcil and ins_fecha >= CONVERT(datetime, @fi) AND ins_fecha <= @fechaFinQ--CONVERT(datetime,  @ff)
	--union
	--select ins_codper 
	--from Inscripcion.dbo.ra_ins_inscripcion 
	--where ins_codcil = @codcil and ins_fecha >= CONVERT(datetime, @fi) AND ins_fecha <= @fechaFinQ

	insert into @NI(codper_NI, tipo_NI, codpla)
	select per_codigo, 'Nuevo Ingreso' tipo_ingreso , alc_codpla
	from ra_per_personas 
		 left join ra_alc_alumnos_carrera on alc_codper = per_codigo
	where per_codcil_ingreso = @codcil and per_tipo = @per_tipo --and per_estado = 'A'
		and per_codigo in (select codper_ins from @ins)
		and per_codigo not in (select equ_codper from ra_equ_equivalencia_universidad)
	union all
	select per_codigo, 'Reingreso' tipo_ingreso , alc_codpla
	from ra_per_personas 
		 inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
		 inner join ra_rei_reingreso_personas on rei_codper = per_codigo
	where per_tipo = @per_tipo and rei_codcil in (@codcil, (select iif(cil_codcic = 2, cil_codigo + 1, cil_codigo) from ra_cil_ciclo where cil_codigo = @codcil)) --and per_estado = 'A'--and rei_codcil_pp = @codcil-- and per_tipo_ingreso = 6
		and per_codigo in (select codper_ins from @ins)
		and per_codigo in (select per from @pagos where per = per_codigo)
	union all
	select per_codigo, 'Equivalencias' tipo_ingreso, alc_codpla
	from ra_per_personas 
		 inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
		 inner join ra_equ_equivalencia_universidad on equ_codper = per_codigo
	where per_codcil_ingreso = @codcil and per_tipo = @per_tipo --and per_estado = 'A'
		and per_codigo in (select codper_ins from @ins)

	--select * from @NI

	select v.per_nombres_apellidos, v.per_carnet, v.car_nombre, per_correo_institucional, per_email, per_telefono, per_celular
	,case when isnull(tipo_NI, '-') = '-' then 'Antiguo ingreso' else tipo_NI end
	from ra_vst_aptde_AlumnoPorTipoDeEstudio v 
	inner join ra_per_personas p on p.per_codigo = v.per_codigo
	left join @NI n on n.codper_NI = v.per_codigo
	where v.tde_codigo = 1 and v.ins_codcil = 126 and p.per_estado = 'A' --and p.per_codcil_ingreso = 126
	order by v.car_nombre, v.per_nombres_apellidos--17350
