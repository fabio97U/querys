--SOLICITADO POR: KRISSIA 
--DESCRIPCION: ENVIAR LA SOLICITUD DEL ALUMNO QUE QUIERE OPTAR A PASANTIAS DESDE EL PORTAL UTEC SIEMPRE Y CUANDO CUMPLA REQUISITOS, LAS SOLICITUDES LE CAE AL CORREO PROPIO DE PASANTIAS
--DESARROLLADORES INVOLUCRADOS: FABIO

create table ra_reqpassol_requisitos_pasantias_solicitud(
	reqpassol_codigo int primary key identity (1,1),
	reqpassol_por_hor_soc int,
	reqpassol_por_mat_pas int,
	reqpassol_cum_min decimal(5,1),
	reqpassol_codcil int foreign key references ra_cil_ciclo,
	reqpassol_fecha_creacion datetime default getdate()
);
go

insert into ra_reqpassol_requisitos_pasantias_solicitud (reqpassol_por_hor_soc, reqpassol_por_mat_pas, reqpassol_cum_min, reqpassol_codcil)
values (100,50,7.5,117);
go
/*select * from ra_reqpassol_requisitos_pasantias_solicitud*/

create procedure web_dec_pas_sol
	-- =============================================
	-- Author:		<Fabio>
	-- Create date: <06/11/2018>
	-- Description:	<Devuelve los requisitos(CUM, %H.Sociales, %M.Pasadas) de pasantia del ciclo junto con los datos propios(CUM, %H.Sociales, %M.Pasadas) del alumno>
	-- =============================================
	--web_dec_pas_sol '181324', '117'
	@codper int, 
	@codcil int
as 
begin
	declare @carnet nvarchar(12)
	select @carnet = per_carnet from ra_per_personas where per_codigo = @codper
	declare @aprobadas table(total_aprobadas int)
	insert into @aprobadas(total_aprobadas) 
	exec rep_certificacion_notas_au @carnet, '', '', '', '', '', '',  'P'
	select 
		--pla.pla_alias_carrera 'carrera',
		--pla.pla_anio, 
		ISNULL((select * from @aprobadas),0) as 'materias_pasadas', 
		isnull((select pla_n_mat from ra_pla_planes where pla_codigo = alc.alc_codpla),0) 'total_materias',
		ISNULL((select sum(hsp_horas) from ra_hsp_horas_sociales_personas where hsp_codper = @codper), 0) as 'horas_realizadas',
		(select car_horas_soc from ra_car_carreras where car_codigo = (select pla_codcar from ra_pla_planes where pla_codigo = alc.alc_codpla)) as 'total_horas',
		round(dbo.cum_repro(@codper),1) as 'cum',
		reqpassol.reqpassol_por_hor_soc,
		reqpassol.reqpassol_por_mat_pas,
		reqpassol.reqpassol_cum_min
	from ra_alc_alumnos_carrera as alc 
		inner join ra_pla_planes as pla 
		on pla.pla_codigo = alc.alc_codpla
		inner join ra_reqpassol_requisitos_pasantias_solicitud as reqpassol 
		on reqpassol.reqpassol_codcil = @codcil
		where alc.alc_codper = @codper;
end
go


create table ra_decpassol_decanato_pasantias_solicitud(
	decpassol_codigo int primary key identity(1,1),
	decpassol_codper int foreign key references ra_per_personas,
	decpassol_codcil int foreign key references ra_cil_ciclo,
	decpassol_por_hor_soc int,
	decpassol_por_mat_pas int,
	decpassol_cum_min decimal(5, 1),
	decpassol_nombrecv nvarchar(125),
	decpassol_fecha_solicitud datetime,
	decpassol_fecha_solicitud_ultima_modifcacion datetime
)
go

create procedure web_dec_envio_solicitud 
	-- =============================================
	-- Author:		<Fabio>
	-- Create date: <02/11/2018>
	-- Description:	<Permite conocer si el alumno ya realizo una solicitud para pasantias en el ciclo(1 si ya realizo, 0 si no a realizado)>
	-- =============================================
	--web_dec_envio_solicitud 181324, 117
	@decpassol_codper int,
	@decpassol_codcil int
as
begin
	if((select count(1) from ra_decpassol_decanato_pasantias_solicitud where decpassol_codper = @decpassol_codper and decpassol_codcil = @decpassol_codcil)>0)
	begin
		select 1
	end
	else
	begin
		select 0
	end
end
go

create procedure web_dec_decpassol
	-- =============================================
	-- Author:		<Fabio>
	-- Create date: <05/11/2018>
	-- Description:	<Mantenimiento a la tabla de solicitudes de pasantias, ra_decpassol_decanato_pasantias_solicitud>
	-- =============================================
	-- web_dec_decpassol 1, 1,1,117,1,1,1,''
	@opcion int,--1:Muestra, 2:Inserta, 3: Actualiza
	@decpassol_codigo int = 1,
	@decpassol_codper int,
	@decpassol_codcil int,
	@decpassol_por_hor_soc int,
	@decpassol_por_mat_pas int,
	@decpassol_cum_min decimal(5,1),
	@decpassol_nombrecv nvarchar(125)
as
begin
	if(@opcion=1)
	begin
		select decpassol.decpassol_codigo, per.per_apellidos_nombres,
		per.per_carnet,
		(select pla_alias_carrera from ra_pla_planes where pla_codigo = (select alc_codpla from ra_alc_alumnos_carrera where alc_codper = per.per_codigo)) as 'Carrera'
		   ,decpassol.decpassol_codcil, decpassol.decpassol_por_hor_soc, decpassol.decpassol_por_mat_pas, decpassol.decpassol_cum_min, decpassol.decpassol_nombrecv, decpassol.decpassol_fecha_solicitud, decpassol.decpassol_fecha_solicitud_ultima_modifcacion
		   from ra_decpassol_decanato_pasantias_solicitud as decpassol
		inner join ra_per_personas as per on decpassol.decpassol_codper = per.per_codigo
		where decpassol.decpassol_codcil = @decpassol_codcil;
	end
	if(@opcion=2)
	begin
		insert into ra_decpassol_decanato_pasantias_solicitud(decpassol_codper,decpassol_codcil,decpassol_por_hor_soc,decpassol_por_mat_pas,decpassol_cum_min, decpassol_nombrecv, decpassol_fecha_solicitud, decpassol_fecha_solicitud_ultima_modifcacion)
		values(@decpassol_codper,@decpassol_codcil,@decpassol_por_hor_soc,@decpassol_por_mat_pas,@decpassol_cum_min,@decpassol_nombrecv, GETDATE(), GETDATE());
		select @@IDENTITY;
	end
	if(@opcion=3)
	begin
		declare @codigo int;
		select @codigo = decpassol_codigo from ra_decpassol_decanato_pasantias_solicitud where decpassol_codper = @decpassol_codper and decpassol_codcil = @decpassol_codcil;
		update  ra_decpassol_decanato_pasantias_solicitud set 
		decpassol_por_hor_soc = @decpassol_por_hor_soc, decpassol_por_mat_pas = @decpassol_por_mat_pas,decpassol_cum_min=@decpassol_cum_min, 
		decpassol_fecha_solicitud_ultima_modifcacion = getdate(), decpassol_nombrecv = @decpassol_nombrecv
		where decpassol_codigo = @codigo;
		select @codigo
	end
end

create procedure web_reqpassol_requisitos_pasantias_solicitud
	-- =============================================
	-- Author:		<Fabio>
	-- Create date: <05/11/2018>
	-- Description:	<Mantenimiento a la tabla de requerimientos para solicitar pasantias, ra_reqpassol_requisitos_pasantias_solicitud>
	-- =============================================
	@opcion int, --1:Muestra, 2: Inserta, 3:Actualiza
	@reqpassol_codigo int,
	@reqpassol_por_hor_soc int,
	@reqpassol_por_mat_pas int,
	@reqpassol_cum_min decimal(5,1),
	@reqpassol_codcil int
as
begin
	if(@opcion=1)
	begin
		select reqpassol.reqpassol_codigo, reqpassol.reqpassol_por_hor_soc, reqpassol.reqpassol_por_mat_pas, reqpassol.reqpassol_cum_min, reqpassol.reqpassol_codcil
		, '0' + (SELECT CAST(cil.cil_codcic AS varchar) + ' - ' + CAST(cil.cil_anio as varchar))  as 'ciclo'
		from ra_reqpassol_requisitos_pasantias_solicitud as reqpassol 
		inner join ra_cil_ciclo as cil on reqpassol.reqpassol_codcil = cil.cil_codigo
	end
	if(@opcion=2)
	begin
		if((select count(1) from ra_reqpassol_requisitos_pasantias_solicitud where reqpassol_codcil = @reqpassol_codcil)>0)
		begin
			select 'Ya existe un ciclo con requisitos' --Existe un ciclo con los requisitos
		end
		else
		begin
			insert into ra_reqpassol_requisitos_pasantias_solicitud(reqpassol_por_hor_soc, reqpassol_por_mat_pas,reqpassol_cum_min,reqpassol_codcil)
			values(@reqpassol_por_hor_soc, @reqpassol_por_mat_pas, @reqpassol_cum_min, @reqpassol_codcil)
			select ('Se ingreso el registro con codigo: '+@@IDENTITY)
		end
	end
	if(@opcion=3)
	begin
		update ra_reqpassol_requisitos_pasantias_solicitud set reqpassol_por_hor_soc=@reqpassol_por_hor_soc, 
		reqpassol_por_mat_pas=@reqpassol_por_mat_pas,reqpassol_cum_min=@reqpassol_cum_min,reqpassol_codcil=@reqpassol_codcil
		where reqpassol_codigo = @reqpassol_codigo
		select @reqpassol_codigo
	end
end


/*
insert into adm_opm_opciones_menu(opm_codigo, opm_nombre, opm_link,	opm_opcion_padre, opm_orden, opm_sistema) 
values('865',	'Pasantias', 'logo.html',	'478',	'5', 'U'),
('866',	'Requerimientos para pasantias', 'ra_reqpassol_requisitos_pasantias_solicitud.aspx',	'865',	'5', 'U'),
('867',	'Solicitudes de pasantias', 'ra_decpassol_decanato_pasantias_solicitud.aspx',	'865',	'5', 'U');
go
*/


/*
--rep_certificacion_notas_au '25-1565-2015', '', '', '', '', '', '',  'P'
ALTER proc [dbo].[rep_certificacion_notas_au]
	@campo0 varchar(12),
	@campo1 varchar(25),
	@campo2 varchar(10),
	@campo3 varchar(60),
	@campo4 varchar(60),
	@campo5 varchar(60),
	@campo6 varchar(60),
	@campo7 varchar(1)
as

declare @codper int, @aprobadas int, @reprobadas int, 
@equivalencias int, @nota_minima real, @unidades int, @uv_plan int, @codpla_act int, @cum_n real, @cum real,
@total_mat int,@car_nombre varchar(100), @pla_nombre nvarchar(100)


--	Comentariado el dia miercoles 11-Oct-2017
--SELECT    @car_nombre =  ra_pla_planes.pla_alias_carrera, @pla_nombre = pla_nombre
--FROM         ra_per_personas INNER JOIN
--                      ra_alc_alumnos_carrera ON ra_per_personas.per_codigo = ra_alc_alumnos_carrera.alc_codper INNER JOIN
--                      ra_pla_planes ON ra_alc_alumnos_carrera.alc_codpla = ra_pla_planes.pla_codigo
--where ra_per_personas.per_carnet = @campo0


SELECT @car_nombre =  ra_pla_planes.pla_alias_carrera, -- car_nombre_legal
	@pla_nombre = pla_nombre
FROM         ra_per_personas INNER JOIN
                      ra_alc_alumnos_carrera ON ra_per_personas.per_codigo = ra_alc_alumnos_carrera.alc_codper INNER JOIN
                      ra_pla_planes ON ra_alc_alumnos_carrera.alc_codpla = ra_pla_planes.pla_codigo inner join 
					  ra_car_carreras on pla_codcar = car_codigo
where ra_per_personas.per_carnet = @campo0 -- '53-0782-2015' -- '43-0272-2016'


--select * from ra_pla_planes

select @codper = per_codigo,
	@codpla_act = alc_codpla
	from ra_per_personas
	join ra_alc_alumnos_carrera on alc_codper = per_codigo
where per_carnet = @campo0

select @cum_n = dbo.cum_repro(@codper) 
select @cum = dbo.cum(@codper) 

					select @nota_minima = uni_nota_minima
					from ra_reg_regionales, ra_uni_universidad
					where reg_codigo = 1
					and uni_codigo = reg_coduni

				--create table #ra_mai_mat_inscritas_h_v(
				declare @ra_mai_mat_inscritas_h_v table(
					codper int,
					codcil int,
					mai_codigo int,
					mai_codins int,
					mai_codmat varchar(10) collate Modern_Spanish_CI_AS,
					mai_absorcion varchar(1),
					mai_financiada varchar(1),
					mai_estado varchar(1),
					mai_codhor int,
					mai_matricula int,
					mai_acuerdo varchar(20),
					mai_fecha_acuerdo datetime,
					mai_codmat_del varchar(10) collate Modern_Spanish_CI_AS,
					fechacreacion datetime, 
					mai_codpla int,
					mai_uv int,
					mai_tipo varchar(1),
					mai_codhpl int
				) 

				--create table #notas(
				declare @notas table(
					ins_codreg int,
					ins_codigo int,
					ins_codcil int,
					ins_codper int,
					mai_codigo int,
					mai_codmat varchar(10) collate Modern_Spanish_CI_AS,
					mai_codhor int,
					mai_matricula int,
					estado varchar(1),
					mai_codpla int,
					absorcion_notas varchar(1),
					uv int,
					nota float, mai_codhpl int
				) 

				--insert into #ra_mai_mat_inscritas_h_v
				insert into @ra_mai_mat_inscritas_h_v (codper, codcil, mai_codigo, mai_codins, mai_codmat, mai_absorcion, mai_financiada, mai_estado, mai_codhor, mai_matricula,
						mai_acuerdo, mai_fecha_acuerdo, mai_codmat_del, fechacreacion, mai_codpla, mai_uv, mai_tipo, mai_codhpl)
					select codper, codcil, mai_codigo, mai_codins, mai_codmat, mai_absorcion, mai_financiada, mai_estado, mai_codhor, mai_matricula,
						mai_acuerdo, mai_fecha_acuerdo, mai_codmat_del, fecha_creacion, mai_codpla, mai_uv, mai_tipo, mai_codhpl
					from ra_mai_mat_inscritas_h_v
					where codper = @codper
					and mai_codpla = @codpla_act

				--insert into #notas
				insert into @notas (ins_codreg, ins_codigo, ins_codcil, ins_codper, mai_codigo, mai_codmat, mai_codhor, mai_matricula, estado, mai_codpla, 
						absorcion_notas, uv, nota)
     				select ins_codreg, ins_codigo, ins_codcil, ins_codper, mai_codigo, mai_codmat, mai_codhor, mai_matricula, estado, mai_codpla, 
						absorcion_notas, uv, nota
					from notas                   
					where ins_codper = @codper
					and mai_codpla = @codpla_act
             


					select @aprobadas = sum(a) 
					from 
					(
						select count(distinct b.mai_codmat) a 
						from @notas b,ra_alc_alumnos_carrera, ra_plm_planes_materias
						where b.ins_codper = @codper
						and round(b.nota,1) >= @nota_minima
						and alc_codper = b.ins_codper
						and plm_codpla = alc_codpla
						and plm_codmat = b.mai_codmat
						and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
						and not exists (select 1 from ra_equ_equivalencia_universidad
										join ra_eqn_equivalencia_notas on eqn_codequ = equ_codigo
										where equ_codper = alc_codper
										and eqn_codmat = plm_codmat
										and eqn_nota > 0)
						union all
						select count(distinct eqn_codmat) 
						from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,
						ra_alc_alumnos_carrera, ra_plm_planes_materias
						where equ_codigo = eqn_codequ
						and equ_codper = @codper
						and eqn_nota > 0
	--					and equ_tipo = 'E'
						and alc_codper = equ_codper
						and plm_codpla = alc_codpla
						and plm_codmat = eqn_codmat
					) t 

					select @reprobadas = count(1)
					from @notas b,ra_alc_alumnos_carrera, ra_plm_planes_materias
					where b.ins_codper = @codper
						and b.ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
						and b.estado = 'I'
						and round(b.nota,1) < @nota_minima
						and alc_codper = b.ins_codper
						and plm_codpla = alc_codpla
						and plm_codmat = b.mai_codmat

					select @total_mat = count(1)
					from @notas b,ra_alc_alumnos_carrera, ra_plm_planes_materias
					where b.ins_codper = @codper
						and b.ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
						and alc_codper = b.ins_codper
						and plm_codpla = alc_codpla
						and plm_codmat = b.mai_codmat

					if @campo7 = 'S' set @reprobadas = 0
					  

					select @equivalencias = count(distinct eqn_codmat) 
					from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas, 
						ra_alc_alumnos_carrera, ra_plm_planes_materias
					where equ_codigo = eqn_codequ
						and equ_codper = @codper
						and eqn_nota > 0 
						and equ_tipo = 'E'
						and alc_codper = equ_codper
						and plm_codpla = alc_codpla
						and plm_codmat = eqn_codmat


					select @uv_plan = sum(plm_uv)
					from ra_plm_planes_materias, ra_alc_alumnos_carrera
					where plm_ciclo <> 0
						and plm_anio_carrera <> 0
						and plm_codpla = alc_codpla
						and alc_codper = @codper

					select @unidades = sum(uv)
					from 
					(
						select plm_uv uv
						from @notas b,
						ra_alc_alumnos_carrera, ra_plm_planes_materias
						where b.ins_codper = @codper
						and round(b.nota,1) >= @nota_minima
						and alc_codper = b.ins_codper
						and plm_codpla = alc_codpla
						and plm_codmat = b.mai_codmat
						and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
						union all
						select plm_uv
						from ra_equ_equivalencia_universidad, ra_eqn_equivalencia_notas,
						ra_alc_alumnos_carrera, ra_plm_planes_materias
						where equ_codigo = eqn_codequ
						and equ_codper = @codper
						and eqn_nota > 0
						and alc_codper = equ_codper
						and plm_codpla = alc_codpla
						and plm_codmat = eqn_codmat
					) t


	if @unidades > @uv_plan set @unidades = @uv_plan


if @campo7 = 'N'
begin

	select @campo1 Lugar,dbo.fn_crufl_FechaALetras(convert(datetime,@campo2,103),1,1) fecha,
		'' lee_firma,fac_nombre,@campo4 comprobante, @campo5 elaboro,@campo6 confronto,
		'' Secretaria,@campo3 Rector,cil_codigo,uni_nombre, per_carnet, per_nombres_apellidos, 
		@car_nombre as car_nombre, reg_nombre,@unidades UV,@total_mat total_mat,
		case when cil_codigo = 0 then '' else 
		right('00'+cast(cil_codcic as varchar),2) + '-' + CAST(cil_anio as varchar) end cic_nombre,
		mat_codigo, mat_nombre, nota nota, estado estado, '(' + upper(dbo.NotaALetras(nota)) + ')' nota_letras,
		ciclo_min, ciclo_max, uni_nota_minima, 
		upper(dbo.NotaALetras(uni_nota_minima)) uni_nota_minima_letras,
		materias_aprobadas total_aprobadas,
		case when materias_equivalencia > 0 then 
		'('+cast(materias_aprobadas as varchar) + ') aprobadas ' + 'En esta Institucion ' 
		else
		'' end materias_aprobadas, 
		materias_reprobadas,
		dbo.MateriasALetras(materias_aprobadas) total_aprobadas_letras,
		case when materias_equivalencia > 0 then 
		dbo.MateriasALetras(materias_aprobadas) + '('+cast(materias_aprobadas as varchar) + ') aprobadas ' + 'En esta Institucion ' 
		else
		'' end materias_aprobadas_letras, 
		dbo.MateriasALetras(materias_reprobadas) materias_reprobadas_letras,not_num,round(cum_n,1) cum_n,
		dbo.NotaALetras(round(cum_n,1)) cum_n_letras,
		case when cil_codigo = 0 then 'EQ' else '' end equ,
		case when materias_equivalencia > 0 then
		dbo.MateriasALetras(materias_equivalencia) + '(' + cast(materias_equivalencia as varchar) + ')' +
		' asignaturas concedidas por equivalencia, ' else '' end equ_concedidas,
		plm_uv
	from
	(
		select cil_codcic,cil_codigo,uni_nombre, per_carnet, per_nombres_apellidos, uni_nota_minima,
		fac_nombre,@car_nombre as car_nombre, reg_nombre, cic_nombre, cil_anio, per_acta_equivalencia,
		mat_codigo, mat_nombre, per_resolucion_equivalencia, per_fecha_equivalencia,plm_uv,

		round(isnull(
		(select sum(nota)
		from
		(
			(
				select isnull(nota,0) nota 
				from @notas 
				where ins_codper = codper
				and mai_codmat = codmat_del
				and ins_codcil = cil_codigo
				and mat_codigo not in  (select eqn_codmat
								from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
								where eqn_codequ = equ_codigo
								and equ_codper = @codper
								and eqn_nota > 0)
				and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')

				union all
				select isnull(round(avg(eqn_nota),1),0)
				from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad
				where eqn_codequ = equ_codigo
				and eqn_codmat = mat_codigo
				and equ_codper = codper
				and eqn_nota > 0
			)
		) t)
		,0),1) nota, 

		isnull((select sum(nota)
		from
		(
			(
				select isnull(nota,0)  nota
				from @notas 
				where ins_codper = codper
				and mai_codmat = codmat_del
				and ins_codcil = cil_codigo
				and mat_codigo not in  (select eqn_codmat
								from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
								where eqn_codequ = equ_codigo
								and equ_codper = @codper
								and eqn_nota > 0)
				and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')

				union all
				select isnull(round(avg(eqn_nota),1),0)
				from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad
				where eqn_codequ = equ_codigo
				and eqn_codmat = mat_codigo
				and equ_codper = codper
				and eqn_nota > 0
			)
		)t ),0) not_num,

		case when mai_estado = 'I' then CASE WHEN isnull((select sum(nota)
		from
		(
		(select isnull(nota,0) nota
		from @notas 
		where ins_codper = codper
		and mai_codmat = codmat_del
		and ins_codcil = cil_codigo
		and mat_codigo not in  (select eqn_codmat
						from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
						where eqn_codequ = equ_codigo
						and equ_codper = @codper
						and eqn_nota > 0)
		and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
		union all
		select isnull(round(avg(eqn_nota),1),0)
		from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad
		where eqn_codequ = equ_codigo
		and eqn_codmat = mat_codigo
		and equ_codper = codper
		and eqn_nota > 0
		)) t ),0) < 
		(select cast(uni_nota_minima as real) 
		from ra_uni_universidad 
		join ra_reg_regionales on uni_codigo = reg_coduni 
		join ra_per_personas on reg_codigo = per_codreg 
		where per_codigo = codper) 
		THEN 'Reprobada' ELSE 'Aprobada' END else 'Retirada' end estado, 

		(select cic_nombre + ' del año academico ' + cast(cil_anio as varchar) 
		from ra_cil_ciclo, ra_cic_ciclos
		where cic_codigo = cil_codcic
		and cast(cil_anio as varchar) + cast(cil_codigo as varchar) =
		(select min(cast(cil_anio as varchar) + cast(cil_codigo as varchar))
		from ra_cil_ciclo, ra_ins_inscripcion
		where ins_codper = codper
		and cil_codigo = ins_codcil)) ciclo_min,
		(select cic_nombre + ' del año academico ' + cast(cil_anio as varchar) 
		from ra_cil_ciclo, ra_cic_ciclos
		where cic_codigo = cil_codcic
		and cast(cil_anio as varchar) + cast(cil_codigo as varchar) = 
		(select max(cast(cil_anio as varchar) + cast(cil_codigo as varchar))
		from ra_cil_ciclo, ra_ins_inscripcion
		where ins_codper = codper
		and cil_codigo = ins_codcil)) ciclo_max,

		@equivalencias  materias_equivalencia,

		@aprobadas materias_aprobadas,

		@reprobadas materias_reprobadas,

		@cum_n cum_n
		from
		(
		select cil_codcic,cil_codigo,uni_nombre, ins_codper codper, per_carnet, 
		per_nombres_apellidos, 
		@car_nombre as car_nombre, reg_nombre, mat_codigo, isnull(plm_alias,mat_nombre) mat_nombre, cic_nombre, cil_anio, fac_nombre, uni_nota_minima,
		pla_codigo codpla, per_codreg codreg,  per_resolucion_equivalencia, per_fecha_equivalencia,
		plm_uv, mai_codmat_del codmat_del,per_acta_equivalencia, mai_estado
		from @ra_mai_mat_inscritas_h_v, ra_mat_materias, ra_per_personas,
		ra_uni_universidad, ra_reg_regionales, ra_ins_inscripcion, 
		ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras,
		ra_cil_ciclo, ra_cic_ciclos, ra_fac_facultades, ra_plm_planes_materias
		where per_carnet = @campo0
		and ins_codper = per_codigo
		and reg_codigo = per_codreg
		and uni_codigo = reg_coduni
		and alc_codper = per_codigo
		and alc_codpla = pla_codigo
		and car_codigo = pla_codcar
		and cil_codigo = ins_codcil
		and cic_codigo = cil_codcic
		and mai_codins = ins_codigo
		and mai_codmat = mat_codigo
		--and mai_estado = 'I'
		and fac_codigo = car_codfac
		and plm_codpla = alc_codpla
		and plm_codmat = mat_codigo
		and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
		and mai_codmat not in  (select eqn_codmat
						from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
						where eqn_codequ = equ_codigo
						and equ_codper = @codper
						and eqn_nota > 0)
		union all
		select distinct 0,0,uni_nombre, equ_codper codper, per_carnet, per_nombres_apellidos per_nombres_apellidos, 
		@car_nombre as car_nombre, reg_nombre, eqn_codmat, isnull(plm_alias,mat_nombre) mat_nombre, '' cic_nombre, 0 cil_anio, fac_nombre, uni_nota_minima,
		pla_codigo codpla, per_codreg codreg, per_resolucion_equivalencia, per_fecha_equivalencia, plm_uv,
		eqn_codmat, per_acta_equivalencia, 'I'
		from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas,
		ra_mat_materias, ra_per_personas,ra_uni_universidad, ra_reg_regionales, 
		ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras, ra_fac_facultades,
		ra_plm_planes_materias
		where per_carnet = @campo0
		and equ_codper = per_codigo
		and eqn_codequ = equ_codigo
		and reg_codigo = per_codreg
		and uni_codigo = reg_coduni
		and alc_codper = per_codigo
		and alc_codpla = pla_codigo
		and car_codigo = pla_codcar
		and eqn_codmat = mat_codigo
		and fac_codigo = car_codfac
		and eqn_nota > 0
		and plm_codpla = alc_codpla
		and plm_codmat = mat_codigo
		)j 
		)t
		order by cil_anio, cil_codcic, mat_codigo

end

else if @campo7 = 'P'  --Esta condicion P es utilizada para devolver unicamente el total de materias aprobadas de estudiante que solicite PASANTIAS 
begin

	select top 1 
		materias_aprobadas total_aprobadas
		
	from
	(
		select cil_codcic,cil_codigo,uni_nombre, per_carnet, per_nombres_apellidos, uni_nota_minima,
		fac_nombre,@car_nombre as car_nombre, reg_nombre, cic_nombre, cil_anio, per_acta_equivalencia,
		mat_codigo, mat_nombre, per_resolucion_equivalencia, per_fecha_equivalencia,plm_uv,

		round(isnull(
		(select sum(nota)
		from
		(
			(
				select isnull(nota,0) nota 
				from @notas 
				where ins_codper = codper
				and mai_codmat = codmat_del
				and ins_codcil = cil_codigo
				and mat_codigo not in  (select eqn_codmat
								from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
								where eqn_codequ = equ_codigo
								and equ_codper = @codper
								and eqn_nota > 0)
				and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')

				union all
				select isnull(round(avg(eqn_nota),1),0)
				from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad
				where eqn_codequ = equ_codigo
				and eqn_codmat = mat_codigo
				and equ_codper = codper
				and eqn_nota > 0
			)
		) t)
		,0),1) nota, 

		isnull((select sum(nota)
		from
		(
			(
				select isnull(nota,0)  nota
				from @notas 
				where ins_codper = codper
				and mai_codmat = codmat_del
				and ins_codcil = cil_codigo
				and mat_codigo not in  (select eqn_codmat
								from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
								where eqn_codequ = equ_codigo
								and equ_codper = @codper
								and eqn_nota > 0)
				and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')

				union all
				select isnull(round(avg(eqn_nota),1),0)
				from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad
				where eqn_codequ = equ_codigo
				and eqn_codmat = mat_codigo
				and equ_codper = codper
				and eqn_nota > 0
			)
		)t ),0) not_num,

		case when mai_estado = 'I' then CASE WHEN isnull((select sum(nota)
		from
		(
		(select isnull(nota,0) nota
		from @notas 
		where ins_codper = codper
		and mai_codmat = codmat_del
		and ins_codcil = cil_codigo
		and mat_codigo not in  (select eqn_codmat
						from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
						where eqn_codequ = equ_codigo
						and equ_codper = @codper
						and eqn_nota > 0)
		and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
		union all
		select isnull(round(avg(eqn_nota),1),0)
		from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad
		where eqn_codequ = equ_codigo
		and eqn_codmat = mat_codigo
		and equ_codper = codper
		and eqn_nota > 0
		)) t ),0) < 
		(select cast(uni_nota_minima as real) 
		from ra_uni_universidad 
		join ra_reg_regionales on uni_codigo = reg_coduni 
		join ra_per_personas on reg_codigo = per_codreg 
		where per_codigo = codper) 
		THEN 'Reprobada' ELSE 'Aprobada' END else 'Retirada' end estado, 

		(select cic_nombre + ' del año academico ' + cast(cil_anio as varchar) 
		from ra_cil_ciclo, ra_cic_ciclos
		where cic_codigo = cil_codcic
		and cast(cil_anio as varchar) + cast(cil_codigo as varchar) =
		(select min(cast(cil_anio as varchar) + cast(cil_codigo as varchar))
		from ra_cil_ciclo, ra_ins_inscripcion
		where ins_codper = codper
		and cil_codigo = ins_codcil)) ciclo_min,
		(select cic_nombre + ' del año academico ' + cast(cil_anio as varchar) 
		from ra_cil_ciclo, ra_cic_ciclos
		where cic_codigo = cil_codcic
		and cast(cil_anio as varchar) + cast(cil_codigo as varchar) = 
		(select max(cast(cil_anio as varchar) + cast(cil_codigo as varchar))
		from ra_cil_ciclo, ra_ins_inscripcion
		where ins_codper = codper
		and cil_codigo = ins_codcil)) ciclo_max,

		@equivalencias  materias_equivalencia,

		@aprobadas materias_aprobadas,

		@reprobadas materias_reprobadas,

		@cum_n cum_n
		from
		(
		select cil_codcic,cil_codigo,uni_nombre, ins_codper codper, per_carnet, 
		per_nombres_apellidos, 
		@car_nombre as car_nombre, reg_nombre, mat_codigo, isnull(plm_alias,mat_nombre) mat_nombre, cic_nombre, cil_anio, fac_nombre, uni_nota_minima,
		pla_codigo codpla, per_codreg codreg,  per_resolucion_equivalencia, per_fecha_equivalencia,
		plm_uv, mai_codmat_del codmat_del,per_acta_equivalencia, mai_estado
		from @ra_mai_mat_inscritas_h_v, ra_mat_materias, ra_per_personas,
		ra_uni_universidad, ra_reg_regionales, ra_ins_inscripcion, 
		ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras,
		ra_cil_ciclo, ra_cic_ciclos, ra_fac_facultades, ra_plm_planes_materias
		where per_carnet = @campo0
		and ins_codper = per_codigo
		and reg_codigo = per_codreg
		and uni_codigo = reg_coduni
		and alc_codper = per_codigo
		and alc_codpla = pla_codigo
		and car_codigo = pla_codcar
		and cil_codigo = ins_codcil
		and cic_codigo = cil_codcic
		and mai_codins = ins_codigo
		and mai_codmat = mat_codigo
		--and mai_estado = 'I'
		and fac_codigo = car_codfac
		and plm_codpla = alc_codpla
		and plm_codmat = mat_codigo
		and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
		and mai_codmat not in  (select eqn_codmat
						from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
						where eqn_codequ = equ_codigo
						and equ_codper = @codper
						and eqn_nota > 0)
		union all
		select distinct 0,0,uni_nombre, equ_codper codper, per_carnet, per_nombres_apellidos per_nombres_apellidos, 
		@car_nombre as car_nombre, reg_nombre, eqn_codmat, isnull(plm_alias,mat_nombre) mat_nombre, '' cic_nombre, 0 cil_anio, fac_nombre, uni_nota_minima,
		pla_codigo codpla, per_codreg codreg, per_resolucion_equivalencia, per_fecha_equivalencia, plm_uv,
		eqn_codmat, per_acta_equivalencia, 'I'
		from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas,
		ra_mat_materias, ra_per_personas,ra_uni_universidad, ra_reg_regionales, 
		ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras, ra_fac_facultades,
		ra_plm_planes_materias
		where per_carnet = @campo0
		and equ_codper = per_codigo
		and eqn_codequ = equ_codigo
		and reg_codigo = per_codreg
		and uni_codigo = reg_coduni
		and alc_codper = per_codigo
		and alc_codpla = pla_codigo
		and car_codigo = pla_codcar
		and eqn_codmat = mat_codigo
		and fac_codigo = car_codfac
		and eqn_nota > 0
		and plm_codpla = alc_codpla
		and plm_codmat = mat_codigo
		)j 
		)t
		order by cil_anio, cil_codcic, mat_codigo

end
else
begin

		select @campo1 Lugar,dbo.fn_crufl_FechaALetras(convert(datetime,@campo2,103),1,1) fecha,
		'' lee_firma,fac_nombre,@campo4 comprobante, @campo5 elaboro,@campo6 confronto,
		'' Secretaria,@campo3 Rector,cil_codigo,uni_nombre, per_carnet, per_nombres_apellidos, 
		@car_nombre as car_nombre, reg_nombre,@unidades UV,@total_mat total_mat,
		case when cil_codigo = 0 then '' else 
		right('00'+cast(cil_codcic as varchar),2) + '-' + CAST(cil_anio as varchar) end cic_nombre,
		mat_codigo, mat_nombre, nota nota, estado estado, '(' + upper(dbo.NotaALetras(nota)) + ')' nota_letras,
		ciclo_min, ciclo_max, uni_nota_minima, 
		upper(dbo.NotaALetras(uni_nota_minima)) uni_nota_minima_letras,
		materias_aprobadas total_aprobadas,
		case when materias_equivalencia > 0 then 
		'('+cast(materias_aprobadas as varchar) + ') aprobadas ' + 'En esta Institucion ' 
		else
		'' end materias_aprobadas, 
		materias_reprobadas,
		dbo.MateriasALetras(materias_aprobadas) total_aprobadas_letras,
		case when materias_equivalencia > 0 then 
		dbo.MateriasALetras(materias_aprobadas) + '('+cast(materias_aprobadas as varchar) + ') aprobadas ' + 'En esta Institucion ' 
		else
		'' end materias_aprobadas_letras, 
		dbo.MateriasALetras(materias_reprobadas) materias_reprobadas_letras,not_num,round(cum_n,1) cum_n,
		dbo.NotaALetras(round(cum_n,1)) cum_n_letras,
		case when cil_codigo = 0 then 'EQ' else '' end equ,
		case when materias_equivalencia > 0 then
		dbo.MateriasALetras(materias_equivalencia) + '(' + cast(materias_equivalencia as varchar) + ')' +
		' asignaturas concedidas por equivalencia, ' else '' end equ_concedidas,
		plm_uv
		from
		(
		select cil_codcic,cil_codigo,uni_nombre, per_carnet, per_nombres_apellidos, uni_nota_minima,
		fac_nombre,car_nombre, reg_nombre, cic_nombre, cil_anio, per_acta_equivalencia,
		mat_codigo, mat_nombre, per_resolucion_equivalencia, per_fecha_equivalencia,plm_uv,

		round(isnull((select sum(nota)
		from
		(
		(select isnull(nota,0) nota 
		from @notas 
		where ins_codper = codper
		and mai_codmat = codmat_del
		and ins_codcil = cil_codigo
		and mat_codigo not in  (select eqn_codmat
						from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
						where eqn_codequ = equ_codigo
						and equ_codper = @codper
						and eqn_nota > 0)
		and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')

		union all
		select isnull(round(avg(eqn_nota),1),0)
		from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad
		where eqn_codequ = equ_codigo
		and eqn_codmat = mat_codigo
		and equ_codper = codper
		and eqn_nota > 0
		)
		) t)
		,0),1) nota, 

		isnull((select sum(nota)
		from
		(
		(select isnull(nota,0)  nota
		from @notas 
		where ins_codper = codper
		and mai_codmat = codmat_del
		and ins_codcil = cil_codigo
		and mat_codigo not in  (select eqn_codmat
						from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
						where eqn_codequ = equ_codigo
						and equ_codper = @codper
						and eqn_nota > 0)
		and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
		union all
		select isnull(round(avg(eqn_nota),1),0)
		from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad
		where eqn_codequ = equ_codigo
		and eqn_codmat = mat_codigo
		and equ_codper = codper
		and eqn_nota > 0
		))t ),0) not_num,

		CASE WHEN isnull((select sum(nota)
		from
		(
		(select isnull(nota,0) nota
		from @notas 
		where ins_codper = codper
		and mai_codmat = codmat_del
		and ins_codcil = cil_codigo
		and mat_codigo not in  (select eqn_codmat
						from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
						where eqn_codequ = equ_codigo
						and equ_codper = @codper
						and eqn_nota > 0)
		and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
		union all
		select isnull(round(avg(eqn_nota),1),0)
		from ra_eqn_equivalencia_notas, ra_equ_equivalencia_universidad
		where eqn_codequ = equ_codigo
		and eqn_codmat = mat_codigo
		and equ_codper = codper
		and eqn_nota > 0
		)) t ),0) < 
		(select cast(uni_nota_minima as real) 
		from ra_uni_universidad 
		join ra_reg_regionales on uni_codigo = reg_coduni 
		join ra_per_personas on reg_codigo = per_codreg 
		where per_codigo = codper) 
		THEN 'Reprobada' ELSE 'Aprobada' END estado, 

		(select cic_nombre + ' del año academico ' + cast(cil_anio as varchar) 
		from ra_cil_ciclo, ra_cic_ciclos
		where cic_codigo = cil_codcic
		and cast(cil_anio as varchar) + cast(cil_codigo as varchar) =
		(select min(cast(cil_anio as varchar) + cast(cil_codigo as varchar))
		from ra_cil_ciclo, ra_ins_inscripcion
		where ins_codper = codper
		and cil_codigo = ins_codcil)) ciclo_min,
		(select cic_nombre + ' del año academico ' + cast(cil_anio as varchar) 
		from ra_cil_ciclo, ra_cic_ciclos
		where cic_codigo = cil_codcic
		and cast(cil_anio as varchar) + cast(cil_codigo as varchar) = 
		(select max(cast(cil_anio as varchar) + cast(cil_codigo as varchar))
		from ra_cil_ciclo, ra_ins_inscripcion
		where ins_codper = codper
		and cil_codigo = ins_codcil)) ciclo_max,

		@equivalencias  materias_equivalencia,

		@aprobadas materias_aprobadas,

		@reprobadas materias_reprobadas,

		@cum cum_n
		from
		(
		select cil_codcic,cil_codigo,uni_nombre, ins_codper codper, per_carnet, 
		per_nombres_apellidos, 
		car_nombre, reg_nombre, mat_codigo, isnull(plm_alias,mat_nombre) mat_nombre, cic_nombre, cil_anio, fac_nombre, uni_nota_minima,
		pla_codigo codpla, per_codreg codreg,  per_resolucion_equivalencia, per_fecha_equivalencia,
		plm_uv, mai_codmat_del codmat_del,per_acta_equivalencia
		from @ra_mai_mat_inscritas_h_v, ra_mat_materias, ra_per_personas,
		ra_uni_universidad, ra_reg_regionales, ra_ins_inscripcion, 
		ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras,
		ra_cil_ciclo, ra_cic_ciclos, ra_fac_facultades, ra_plm_planes_materias
		where per_carnet = @campo0
			and ins_codper = per_codigo
			and reg_codigo = per_codreg
			and uni_codigo = reg_coduni
			and alc_codper = per_codigo
			and alc_codpla = pla_codigo
			and car_codigo = pla_codcar
			and cil_codigo = ins_codcil
			and cic_codigo = cil_codcic
			and mai_codins = ins_codigo
			and mai_codmat = mat_codigo
			and mai_estado = 'I'
			and fac_codigo = car_codfac
			and plm_codpla = alc_codpla
			and plm_codmat = mat_codigo
			and ins_codcil not in (select cil_codigo from ra_cil_ciclo where cil_vigente = 'S' union select cil_codigo from ra_cil_ciclo where cil_vigente2 = 'S')
			and mai_codmat not in  (select eqn_codmat
							from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas
							where eqn_codequ = equ_codigo
							and equ_codper = @codper
							and eqn_nota > 0)
		union all
		select distinct 0,0,uni_nombre, equ_codper codper, per_carnet, per_nombres_apellidos per_nombres_apellidos, 
		car_nombre, reg_nombre, eqn_codmat, isnull(plm_alias,mat_nombre) mat_nombre, '' cic_nombre, 0 cil_anio, fac_nombre, uni_nota_minima,
		pla_codigo codpla, per_codreg codreg, per_resolucion_equivalencia, per_fecha_equivalencia, plm_uv,
		eqn_codmat, per_acta_equivalencia
		from ra_equ_equivalencia_universidad,ra_eqn_equivalencia_notas,
		ra_mat_materias, ra_per_personas,ra_uni_universidad, ra_reg_regionales, 
		ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras, ra_fac_facultades,
		ra_plm_planes_materias
		where per_carnet = @campo0
			and equ_codper = per_codigo
			and eqn_codequ = equ_codigo
			and reg_codigo = per_codreg
			and uni_codigo = reg_coduni
			and alc_codper = per_codigo
			and alc_codpla = pla_codigo
			and car_codigo = pla_codcar
			and eqn_codmat = mat_codigo
			and fac_codigo = car_codfac
			and eqn_nota > 0
			and plm_codpla = alc_codpla
			and plm_codmat = mat_codigo
		)j 
		)t
		where nota >= @nota_minima
		order by cil_anio, cil_codcic, mat_codigo

end
return


*/