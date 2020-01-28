--=========================================****************************************=========================================
create table ma_reqexext_requisitos_examen_extraordinario (--requisitos_exam_extraor.aspx
	reqexext_codigo int primary key identity(1,1),
	reqexext_codcil int foreign key references ra_cil_ciclo,
	reqexext_orden_materia int,
	reqexext_fecha_examen datetime,
	reqexext_fecha_creacion datetime default getdate(),
	reqexext_codusr_creacion int
);
go
select * from ma_reqexext_requisitos_examen_extraordinario
insert into ma_reqexext_requisitos_examen_extraordinario(reqexext_codcil, reqexext_orden_materia, reqexext_fecha_examen,reqexext_codusr_creacion) values(117, 1, '2018-12-22', 407),(117, 2, '2019-02-16', 407),(117, 3, '2019-03-23', 407),(117, 4, '2019-04-18', 407)

create procedure sp_ma_reqexext_requisitos_examen_extraordinario
	@opcion int,
	@reqexext_codigo int,
	@reqexext_codcil int,
	@reqexext_orden_materia int,
	@reqexext_fecha_examen varchar(12),
	@reqexext_codusr_creacion int
as	
begin
	if @opcion = 1
	begin
		select * from ma_reqexext_requisitos_examen_extraordinario
	end
	if @opcion = 2
	begin
		if not exists(select 1 from ma_reqexext_requisitos_examen_extraordinario where reqexext_orden_materia = @reqexext_orden_materia and reqexext_codcil = @reqexext_codcil)
		begin
			insert into ma_reqexext_requisitos_examen_extraordinario(reqexext_codcil, reqexext_orden_materia, reqexext_fecha_examen,reqexext_codusr_creacion) 
			values(@reqexext_codcil, @reqexext_orden_materia, @reqexext_fecha_examen, @reqexext_codusr_creacion)
		end
		
	end
	if @opcion = 3
	begin
		update ma_reqexext_requisitos_examen_extraordinario set reqexext_codcil = @reqexext_codcil, reqexext_orden_materia = @reqexext_orden_materia, reqexext_fecha_examen = @reqexext_fecha_examen
		where reqexext_codigo = @reqexext_codigo
	end
end

--=========================================****************************************=========================================

create table ma_fecant_fechas_cancelar_tramites(--fechas_cancelar_tramites.aspx
	fecant_codigo int primary key identity(1,1), 
	fecant_n_evaluacion int,
	fecant_fecha_inicio datetime,
	fecant_fecha_fin datetime,
	fecant_codtde int foreign key references ra_tde_TipoDeEstudio,
	fecant_codtrao int foreign key references ra_Tramites_academicos_online,
	fecant_fecha_creacion datetime default getdate()
)
go

--[sp_ma_fecant_fechas_cancelar_tramites] 2,0,1, " "," ",4,4
create procedure [dbo].[sp_ma_fecant_fechas_cancelar_tramites]
----------------------*----------------------
-- =============================================
-- Author:      <Adones, Calles>
-- Create date: <2019-02-21 15:12:16.627>
-- Description: <Realiza el mantimiendo de la tabla ma_fecant_fechas_cancelar_tramites>
-- =============================================
	@opcion int,
	@fecant_codigo int = 0,
	@fecant_n_evaluacion int=0,
	@fecant_fecha_inicio varchar(20) ='',
	@fecant_fecha_fin varchar(20) = '',
	@fecant_codtde int = 0,
	@fecant_codtrao int = 0
as
begin
	set dateformat dmy
	if @opcion = 1-- MUESTRA
	begin
		select fecant_codigo, fecant_n_evaluacion,CONVERT(varchar, fecant_fecha_inicio, 103) fecant_fecha_inicio, CONVERT(varchar, fecant_fecha_fin, 103) fecant_fecha_fin, fecant_codtde,tde_nombre, fecant_codtrao,trao_nombre, fecant_fecha_creacion
		 from ma_fecant_fechas_cancelar_tramites INNER JOIN 
		 ra_tde_TipoDeEstudio on fecant_codtde = tde_codigo INNER JOIN
		 ra_Tramites_academicos_online on fecant_codtrao = trao_codigo where tde_codigo not in (1,7)
	end
	if @opcion = 2-- INSERTA
	begin
		if not exists(select 1 from ma_fecant_fechas_cancelar_tramites where fecant_codtde = @fecant_codtde and fecant_codtrao = @fecant_codtrao and fecant_n_evaluacion = @fecant_n_evaluacion)
		begin
			insert into ma_fecant_fechas_cancelar_tramites (fecant_n_evaluacion,fecant_fecha_inicio,fecant_fecha_fin,fecant_codtde,fecant_codtrao)
			values (@fecant_n_evaluacion,GETDATE(),GETDATE(),@fecant_codtde,@fecant_codtrao)
		end
	end
	if @opcion = 3-- ACTUALIZA
	begin
		begin try
			update ma_fecant_fechas_cancelar_tramites set fecant_n_evaluacion=@fecant_n_evaluacion,
			  fecant_fecha_inicio = @fecant_fecha_inicio, fecant_fecha_fin=  @fecant_fecha_fin,fecant_codtde= @fecant_codtde,fecant_codtrao= @fecant_codtrao
			where fecant_codigo = @fecant_codigo
		end try
		begin catch	
		end catch
	end
end

--=========================================****************************************=========================================

create PROCEDURE [dbo].[sp_web_spa_solicitud_proceso_academico_maestrias]--******************************@Deprecated 
	--sp_web_spa_solicitud_proceso_academico_maestrias 1, 117, 202330, '01', 'DEGE-M', 1, 2, 1
	@opcion int,
	@spa_codcil int,
	@spa_codper int,
	@spa_seccion varchar(50),
	@spa_codmat varchar(10),
	@spa_codspar int,
	@spa_codspat int, --2: MAESTRIAS
	@spa_eva int
AS
begin
    if @opcion = 1--opcion para insertar diferido
	begin
		declare @contador int
		select @contador= isnull(count(1),0)
		from web_spa_solicitud_proceso_academico 
		where spa_codper = @spa_codper AND spa_codcil = @spa_codcil and spa_codmat = @spa_codmat --AND spa_codspar > 0 

		print '@contador ' + cast(@contador as varchar(4))

		if (@contador = 0)
		begin
			print 'insert'
			insert into web_spa_solicitud_proceso_academico(spa_codcil,spa_codper,spa_seccion,spa_codmat,spa_estatus,spa_codspar ,spa_codspat,spa_razon_otros,spa_eva) 
					values (@spa_codcil ,@spa_codper ,@spa_seccion,@spa_codmat,'solicitado', @spa_codspar,@spa_codspat,@spa_codspat,@spa_eva)
					Select 'Diferido solicitado con exito en la materia: ' +cast(@spa_codmat as varchar(12)) as msj
		end
		else
		begin
			select 'Materia: ' + cast(@spa_codmat as varchar(12)) + ' ya se realizo la solictud de examen diferido'
		end
	end
end
go

--=========================================****************************************=========================================

create PROCEDURE [dbo].[sp_ra_aan_activar_alumno_notas_insertar_maestrias]
----------------------*----------------------
-- =============================================
-- Author:      <Fabio, Ramos>
-- Create date: <2019-02-10 14:48:40.980>
-- Description: <Realiza la insersion a la tabla ra_aan_activar_alumno_notas y ma_soltraam_solicitudes_tramites_academicos_maestrias>
-- =============================================
	@codper int,
	@codcil int,
	@periodo int,
	@Tipo varchar(50),--TIPO DE TRAMITE, DIFERIDO O EXTRAORDINARIO
	@aan_codhpl int,
	@codusr int
as
begin
	set dateformat dmy
	if exists (select 1 from ra_aan_activar_alumno_notas where aan_codper = @codper and aan_codcil = @codcil and aan_periodo = @periodo and aan_codhpl = @aan_codhpl)
	begin
		select 'El alumno ya esta activado para que le ingresen la nota en la evaluacion ' + cast(@periodo as varchar(5))
	end
	else
	begin 
		declare @ev int
		select @ev = adem_eval from adem_activar_desactivar_evaluaciones_maes where adem_estado = 'A'
		if @ev is not null
		begin
			--select * from col_dmo_det_mov, col_tmo_tipo_movimiento where  tmo_codigo = dmo_codtmo  and tmo_arancel = 'E-21' and dmo_codcil = 117
			INSERT INTO ra_aan_activar_alumno_notas(aan_codper, aan_codcil, aan_periodo, aan_fecha, aan_tipo, aan_codhpl, aan_codusr) 
			values (@codper, @codcil, @periodo, GETDATE(), @tipo, @aan_codhpl, @codusr)
			--SELECT 'Al alumno ya se le puede ingresar nota en el período seleccionado'
			--select * from ma_soltraam_solicitudes_tramites_academicos_maestrias
			--delete from ra_aan_activar_alumno_notas where aan_codusr = 412

			/*insert into ma_soltraam_solicitudes_tramites_academicos_maestrias(soltraam_codper, soltraam_codpon, soltraam_materia_numero, soltraam_codhpl, soltraam_codusr, soltraam_codcil,soltraam_tipo, soltraam_estado)
			values (@codper, @periodo, (select adem_orden from adem_activar_desactivar_evaluaciones_maes where adem_estado = 'A'), @aan_codhpl, @codusr, @codcil, @tipo, 'Solicitado')*/
			
			update ma_soltraam_solicitudes_tramites_academicos_maestrias 
				set soltraam_codpon = @periodo, 
				soltraam_materia_numero = (select adem_orden from adem_activar_desactivar_evaluaciones_maes where adem_estado = 'A'), soltraam_fecha_solicito = getdate(),
				soltraam_codhpl = @aan_codhpl, soltraam_codusr = @codusr, soltraam_estado ='Solicitado'
			where soltraam_codper = @codper 
				and soltraam_tipo = @tipo 
				and soltraam_estado = 'Ingresado'
				and isnull(soltraam_codpon,0) =0 
				and isnull(soltraam_materia_numero,0) = 0  
				and isnull(soltraam_fecha_solicito,0) =0
				and isnull(soltraam_codhpl,0) =0
				and isnull(soltraam_fecha_solicito,0) =0
				and isnull(soltraam_codusr,0) =0
				and soltraam_codcil = @codcil
			--select * from ma_soltraam_solicitudes_tramites_academicos_maestrias where soltraam_codusr = 412
			--delete from ma_soltraam_solicitudes_tramites_academicos_maestrias where soltraam_codusr = 412
			select 'Examen '+ cast(@Tipo as varchar(25)) + ', solicitado con exito!. se envio un comprobante a su correo institucional'
		end
		else
		begin
			print 'No hay periodo habilitado para poder autorizar para subir notas'
			select 'No hay periodo habilitado para poder autorizar para subir notas'
		end
	END
END
go

--=========================================****************************************=========================================

--drop table #Max_ciclo
ALTER PROCEDURE [dbo].[pol_verificar_pagos_aranceles_tramite_online] --******************OBSOLETO******************
	--pol_verificar_pagos_aranceles_tramite_online 4, 202330, 117,1,4
	@opcion int,
	@codper int,
	@codcil int,
	@evaluacion int,
	@TipoTramiteAcademico int --select trao_codigo, * from ra_Tramites_academicos_online
								--select * from ra_traar_tramites_aranceles_online
AS
BEGIN
	--	SET NOCOUNT ON;
	--declare @codper int
	--declare @codcil int
	--declare @evaluacion int
	--declare @TipoTramiteAcademico int

	--set @codper = 190297
	--set @codcil = 113
	--set @evaluacion = 3
	--set @TipoTramiteAcademico = 1

	--select top 25 * from col_dmo_det_mov inner join col_mov_movimientos on mov_codigo = dmo_codmov
	--where dmo_codtmo = 909 and dmo_codcil = 113 --and mov_codper in (200586, 201175, 152965)
	--order by dmo_fecha_registro desc
	if (@opcion = 1)
	begin
		select distinct Rtrim(Ltrim(dmo_codmat)) as codmat,hpl_descripcion,hpl_codigo
		from col_dmo_det_mov 
		inner join col_mov_movimientos on mov_codigo = dmo_codmov
		--inner join ra_aranceles_tramite_academicos on ata_codtmo = dmo_codtmo --and dmo_eval = 
		inner join ra_traar_tramites_aranceles_online on traar_codtmo = dmo_codtmo
		inner join ra_per_personas on per_codigo = mov_codper 
		inner join ra_ins_inscripcion on ins_codper = per_codigo 
		inner join ra_mai_mat_inscritas on  mai_codins = ins_codigo 
		inner join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl 
	
		where mov_estado <> 'A' and mov_codcil = @codcil and dmo_eval = @evaluacion and traar_codtrao  = @TipoTramiteAcademico --and ata_codtrao = @TipoTramiteAcademico 
			and mov_codper = @codper and Rtrim(Ltrim (dmo_codmat)) = hpl_codmat
			and ins_codcil = @codcil and mai_estado = 'I'
			--select COUNT('valor') as resultado
	end

	if (@opcion = 2)
	begin
	select hpl_codmat,hpl_descripcion,hpl_codigo 
	from ra_per_personas  join ra_ins_inscripcion on ins_codper = per_codigo join ra_mai_mat_inscritas on  mai_codins = ins_codigo join
	ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl where per_codigo = @codper and ins_codcil = @codcil
	end

	if (@opcion = 3)
	begin
		--select distinct Rtrim(Ltrim(dmo_codmat)) as 'Codigo de materia',hpl_descripcion as 'Seccion',hpl_codigo as 'Codigo', mat_nombre as 'Nombre de la materia'
		--select * from ra_mat_materias
		select  distinct mat_nombre as Nombre, Rtrim(Ltrim(dmo_codmat)) as Codigo,hpl_descripcion as Seccion--,hpl_codigo as 'Codigo'
			from col_dmo_det_mov 
			inner join col_mov_movimientos on mov_codigo = dmo_codmov

			--inner join ra_aranceles_tramite_academicos on ata_codtmo = dmo_codtmo --and dmo_eval = 
			inner join ra_traar_tramites_aranceles_online on traar_codtmo = dmo_codtmo
			inner join ra_per_personas on per_codigo = mov_codper 
			inner join ra_ins_inscripcion on ins_codper = per_codigo 
			inner join ra_mai_mat_inscritas on  mai_codins = ins_codigo 
			inner join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl 
			inner join ra_mat_materias on dmo_codmat = mat_codigo
	
			where mov_estado <> 'A' and mov_codcil = @codcil and dmo_eval = @evaluacion and traar_codtrao  = @TipoTramiteAcademico  --and ata_codtrao = @TipoTramiteAcademico 
				and mov_codper = @codper and Rtrim(Ltrim (dmo_codmat)) = hpl_codmat and ins_codcil = @codcil and mai_estado = 'I'
				--select COUNT('valor') as resultado
	end
	--pol_verificar_pagos_aranceles_tramite_online 4, 202261, 119, 
	if (@opcion = 4)--VALIDA EL EXAMEN DIFERIDO O EXAMEN EXTRAORDINARIO DE MAESTRIAS, agregado por Fabio <2019-02-11 16:38:38.377>
	begin
	--pol_verificar_pagos_aranceles_tramite_online 4, 202261, 119,1,4
		select  distinct mat_nombre as Nombre, rtrim(ltrim(dmo_codmat)) as Codigo,hpl_descripcion as Seccion
			from col_dmo_det_mov inner join col_mov_movimientos on mov_codigo = dmo_codmov 
			inner join ra_traar_tramites_aranceles_online on traar_codtmo = dmo_codtmo
			inner join ra_per_personas on per_codigo = mov_codper 
			inner join ra_ins_inscripcion on ins_codper = per_codigo 
			inner join ra_mai_mat_inscritas on  mai_codins = ins_codigo 
			inner join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl 
			inner join ra_mat_materias on dmo_codmat = mat_codigo
			where mov_estado <> 'A' and mov_codcil = @codcil and traar_codtrao  = @TipoTramiteAcademico and mov_codper = @codper and rtrim(ltrim (dmo_codmat)) = hpl_codmat 
			and ins_codcil = @codcil and mai_estado = 'I' and traar_codtmo 
			in(--arancel que necesita haber pagado
			select traar_codtmo from ra_traar_tramites_aranceles_online, col_tmo_tipo_movimiento where traar_codtrao in (select trao_codigo from ra_Tramites_academicos_online where trao_codigo = @TipoTramiteAcademico) and tmo_codigo = traar_codtmo
			)
	end
END
go 

--=========================================****************************************=========================================

/*
declare @codper_ int = 201951--202330

select * from ra_aan_activar_alumno_notas where aan_codper = @codper_
select * from  web_spa_solicitud_proceso_academico where spa_codper = @codper_
select * from ra_regr_registro_egresados where regr_codper = @codper_
		
delete from ra_aan_activar_alumno_notas where aan_codper = 201951
delete from web_spa_solicitud_proceso_academico where spa_codper = 201951
delete from ra_regr_registro_egresados where regr_codper = 201951

declare @codper_ int = 201951
select * from col_mov_movimientos where mov_codper = 202330
delete from col_mov_movimientos where mov_codigo in (5808821)
delete from col_dmo_det_mov where dmo_codigo in(13826704)
select * from col_dmo_det_mov, col_tmo_tipo_movimiento where  tmo_codigo = dmo_codtmo  and tmo_arancel = 'E-21' and dmo_codcil = 117
*/

--=========================================****************************************=========================================

/*COLECTURIA*/
USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[insertadetrecibo]    Script Date: 23/02/2019 16:15:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[insertadetrecibo]
	@dmo_codreg int,
	@dmo_codmov varchar(20),
	@dmo_codtmo varchar(10),
	@dmo_cantidad int,
	@dmo_valor real,
	@dmo_codmat varchar(10),
	@dmo_eval int,
	@dmo_descuento real,
	@dmo_mes int,
	@dmo_codcil int,
	@dmo_cargo real,
	@dmo_abono real

AS

set dateformat dmy
declare @exento varchar(1), @iva real, @valor_iva real, @valor_sin_iva real, @abono real,
@cargo real, @codper int, @codcil int

begin transaction

set @valor_iva = 0
set @valor_sin_iva = 0

select @exento = tmo_exento
from col_tmo_tipo_movimiento
where tmo_codigo = @dmo_codtmo

select @iva = isnull(uni_iva,13)
from ra_uni_universidad, ra_reg_regionales
where reg_codigo = @dmo_codreg
and uni_codigo = reg_coduni

select @codper = mov_codper,
@codcil = mov_codcil
from col_mov_movimientos
where mov_codigo = @dmo_codmov

declare @valor real
set @dmo_valor = @dmo_abono


DECLARE @dmo_codigo int 
select @dmo_codigo = (isnull(max(dmo_codigo),0)+1) from col_dmo_det_mov

if (@exento = 'N' )
	begin
		set @valor = (case when @dmo_valor = 0 then @dmo_abono else @dmo_valor end*@dmo_cantidad) - ((case when @dmo_valor = 0 then @dmo_abono else @dmo_valor end*@dmo_cantidad)*(@dmo_descuento/100))
		set @abono = (@dmo_abono*@dmo_cantidad) - ((@dmo_abono*@dmo_cantidad)*(@dmo_descuento/100))
		set @cargo = case when @dmo_descuento > 0 then ((-1*@dmo_valor*@dmo_cantidad)*(@dmo_descuento/100)) else @dmo_cargo end
		select @valor_iva = round( @valor / (@iva/100+1),2)
		select @valor_sin_iva = round(@valor - @valor_iva,2)

		insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo,dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva, dmo_fecha_registro, dmo_descuento,dmo_mes,dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
		select @dmo_codreg,@dmo_codmov,isnull(max(dmo_codigo),0)+1
		, @dmo_codtmo,@dmo_cantidad,@valor_iva, @dmo_codmat, @valor_sin_iva,getdate(), @dmo_descuento,isnull(@dmo_mes,0), 
		case when @dmo_codcil = 0 then @codcil else @dmo_codcil end, @cargo, @abono, @dmo_eval
		from col_dmo_det_mov
--		update ra_per_personas
--		set per_saldo = isnull(per_saldo,0) + (@cargo - @abono)
--		where per_codigo = @codper
	end
else
	begin
			set @valor = (case when @dmo_valor = 0 then @dmo_abono else @dmo_valor end*@dmo_cantidad) - ((case when @dmo_valor = 0 then @dmo_abono else @dmo_valor end*@dmo_cantidad)*(@dmo_descuento/100))
			set @abono = (@dmo_abono*@dmo_cantidad) - ((@dmo_abono*@dmo_cantidad)*(@dmo_descuento/100))
			set @cargo = case when @dmo_descuento > 0 then ((-1*@dmo_valor*@dmo_cantidad)*(@dmo_descuento/100)) else @dmo_cargo end
			
			insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo, dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
			select @dmo_codreg,@dmo_codmov,isnull(max(dmo_codigo),0)+1
			, @dmo_codtmo,@dmo_cantidad,@valor, @dmo_codmat, 0, getdate(), @dmo_descuento,isnull(@dmo_mes,0), 
			case when @dmo_codcil = 0 then @codcil else @dmo_codcil end,@cargo, @abono,@dmo_eval
			from col_dmo_det_mov
--			update ra_per_personas
--			set per_saldo = isnull(per_saldo,0) + (@cargo - @abono)
--			where per_codigo = @codper
	end
	if(@dmo_codtmo = 351 or @dmo_codtmo = 352)--351: Examen Extraordinario (Maestria), 352: Examen Diferido (Maestria) --AGREGADO POR FABIO
	begin
		declare @tipo varchar(25)
		if (@dmo_codtmo = 351) set @tipo = 'Examen-Extraordinario'
		else set @tipo = 'Diferido'
		insert into ma_soltraam_solicitudes_tramites_academicos_maestrias (soltraam_codper, soltraam_codmov, soltraam_tipo, soltraam_codcil) values (@codper, @dmo_codigo, @dmo_codmov, @tipo, @codcil)
		--SELECT * FROM ma_soltraam_solicitudes_tramites_academicos_maestrias
		--13848207
	end
commit transaction
RETURN


/*--ANTES DEL CAMBIO
ALTER PROCEDURE [dbo].[insertadetrecibo]
	@dmo_codreg int,
	@dmo_codmov varchar(20),
	@dmo_codtmo varchar(10),
	@dmo_cantidad int,
	@dmo_valor real,
	@dmo_codmat varchar(10),
	@dmo_eval int,
	@dmo_descuento real,
	@dmo_mes int,
	@dmo_codcil int,
	@dmo_cargo real,
	@dmo_abono real

AS

set dateformat dmy
declare @exento varchar(1), @iva real, @valor_iva real, @valor_sin_iva real, @abono real,
@cargo real, @codper int, @codcil int

begin transaction

set @valor_iva = 0
set @valor_sin_iva = 0

select @exento = tmo_exento
from col_tmo_tipo_movimiento
where tmo_codigo = @dmo_codtmo

select @iva = isnull(uni_iva,13)
from ra_uni_universidad, ra_reg_regionales
where reg_codigo = @dmo_codreg
and uni_codigo = reg_coduni

select @codper = mov_codper,
@codcil = mov_codcil
from col_mov_movimientos
where mov_codigo = @dmo_codmov

declare @valor real
set @dmo_valor = @dmo_abono


if (@exento = 'N' )
	begin
		set @valor = (case when @dmo_valor = 0 then @dmo_abono else @dmo_valor end*@dmo_cantidad) - ((case when @dmo_valor = 0 then @dmo_abono else @dmo_valor end*@dmo_cantidad)*(@dmo_descuento/100))
		set @abono = (@dmo_abono*@dmo_cantidad) - ((@dmo_abono*@dmo_cantidad)*(@dmo_descuento/100))
		set @cargo = case when @dmo_descuento > 0 then ((-1*@dmo_valor*@dmo_cantidad)*(@dmo_descuento/100)) else @dmo_cargo end
		select @valor_iva = round( @valor / (@iva/100+1),2)
		select @valor_sin_iva = round(@valor - @valor_iva,2)

		insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo,dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva, dmo_fecha_registro, dmo_descuento,dmo_mes,dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
		select @dmo_codreg,@dmo_codmov,isnull(max(dmo_codigo),0)+1
		, @dmo_codtmo,@dmo_cantidad,@valor_iva, @dmo_codmat, @valor_sin_iva,getdate(), @dmo_descuento,isnull(@dmo_mes,0), 
		case when @dmo_codcil = 0 then @codcil else @dmo_codcil end, @cargo, @abono, @dmo_eval
		from col_dmo_det_mov
--		update ra_per_personas
--		set per_saldo = isnull(per_saldo,0) + (@cargo - @abono)
--		where per_codigo = @codper
	end
else
	begin
			set @valor = (case when @dmo_valor = 0 then @dmo_abono else @dmo_valor end*@dmo_cantidad) - ((case when @dmo_valor = 0 then @dmo_abono else @dmo_valor end*@dmo_cantidad)*(@dmo_descuento/100))
			set @abono = (@dmo_abono*@dmo_cantidad) - ((@dmo_abono*@dmo_cantidad)*(@dmo_descuento/100))
			set @cargo = case when @dmo_descuento > 0 then ((-1*@dmo_valor*@dmo_cantidad)*(@dmo_descuento/100)) else @dmo_cargo end
			
			insert into col_dmo_det_mov(dmo_codreg,dmo_codmov,dmo_codigo, dmo_codtmo,dmo_cantidad,dmo_valor, dmo_codmat, dmo_iva,dmo_fecha_registro,dmo_descuento,dmo_mes, dmo_codcil,dmo_cargo, dmo_abono,dmo_eval)
			select @dmo_codreg,@dmo_codmov,isnull(max(dmo_codigo),0)+1
			, @dmo_codtmo,@dmo_cantidad,@valor, @dmo_codmat, 0, getdate(), @dmo_descuento,isnull(@dmo_mes,0), 
			case when @dmo_codcil = 0 then @codcil else @dmo_codcil end,@cargo, @abono,@dmo_eval
			from col_dmo_det_mov
--			update ra_per_personas
--			set per_saldo = isnull(per_saldo,0) + (@cargo - @abono)
--			where per_codigo = @codper
	end
commit transaction
RETURN
*/

USE [uonline]
GO
/****** Object:  StoredProcedure [dbo].[elimina_detrecibo]    Script Date: 23/02/2019 16:43:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec [elimina_detrecibo] 13097004,5250823,'karla.medina'
ALTER PROCEDURE [dbo].[elimina_detrecibo]
       @dmo_codigo int,
       @dmo_codmov int,
       @usuario varchar(50)
as
declare @correlativo int, 
        @recibo int, 
        @idfactura int, 
        @lote varchar(2), 
        @arancel varchar(4),
        @cargo real, 
        @abono real, 
        @codper int, 
        @valor real             

begin transaction
-- ***********************************************************************************************************************
-- Auditoria 
	declare @registro_eliminacion varchar(200), @fecha datetime
	set @fecha = getdate()
	select @registro_eliminacion = 'Recibo:' + mov_recibo + ' Fecha fact: ' + convert(varchar(20),mov_fecha,103) 
				+ ' Usuario: ' + mov_usuario + ' codper: ' + cast(mov_codper as varchar(20)) 
				+ ' codban: ' + cast(mov_codban as varchar(20))
	from col_mov_movimientos where mov_codigo = @dmo_codmov
	exec auditoria_del_sistema 'col_mov_movimientos', 'E', @usuario, @fecha, @registro_eliminacion
-- ***********************************************************************************************************************
    select @codper = mov_codper from col_mov_movimientos where mov_codigo = @dmo_codmov

    select @arancel = tmo_arancel, @cargo = dmo_cargo, @abono = dmo_abono from col_dmo_det_mov join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo where dmo_codigo = @dmo_codigo


	if(@arancel = 'E-21' or @arancel = 'E-20')--AGREGADO POR FABIO
	begin
		update ma_soltraam_solicitudes_tramites_academicos_maestrias set soltraam_estado = 'Eliminado' where soltraam_coddmo = @dmo_codigo and soltraam_codmov = @dmo_codmov
	end

    set @valor = @abono - @cargo
    set @correlativo = 0

    delete from col_tal_dmo_talonario where tal_coddmo =@dmo_codigo 

    delete from col_dmo_det_mov where dmo_codigo = @dmo_codigo

	select @correlativo = count(1) from col_dmo_det_mov where dmo_codmov = @dmo_codmov
	if @correlativo = 0 
    begin
		delete from col_mov_movimientos where mov_codigo = @dmo_codmov
    end;
commit transaction
RETURN

/*--ANTES DEL CAMBIO DE DIFERIDOS

ALTER PROCEDURE [dbo].[elimina_detrecibo]
       @dmo_codigo int,
       @dmo_codmov int,
       @usuario varchar(50)
as
declare @correlativo int, 
        @recibo int, 
        @idfactura int, 
        @lote varchar(2), 
        @arancel varchar(4),
        @cargo real, 
        @abono real, 
        @codper int, 
        @valor real             

begin transaction
-- ***********************************************************************************************************************
-- Auditoria 
	declare @registro_eliminacion varchar(200), @fecha datetime
	set @fecha = getdate()
	select @registro_eliminacion = 'Recibo:' + mov_recibo + ' Fecha fact: ' + convert(varchar(20),mov_fecha,103) 
				+ ' Usuario: ' + mov_usuario + ' codper: ' + cast(mov_codper as varchar(20)) 
				+ ' codban: ' + cast(mov_codban as varchar(20))
	from col_mov_movimientos where mov_codigo = @dmo_codmov
	exec auditoria_del_sistema 'col_mov_movimientos', 'E', @usuario, @fecha, @registro_eliminacion
-- ***********************************************************************************************************************
    select @codper = mov_codper from col_mov_movimientos where mov_codigo = @dmo_codmov

    select @arancel = tmo_arancel, @cargo = dmo_cargo, @abono = dmo_abono from col_dmo_det_mov join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo where dmo_codigo = @dmo_codigo

    set @valor = @abono - @cargo
    set @correlativo = 0

    delete from col_tal_dmo_talonario where tal_coddmo =@dmo_codigo 

    delete from col_dmo_det_mov where dmo_codigo = @dmo_codigo

	select @correlativo = count(1) from col_dmo_det_mov where dmo_codmov = @dmo_codmov
	if @correlativo = 0 
    begin
		delete from col_mov_movimientos where mov_codigo = @dmo_codmov
    end;
commit transaction
RETURN
*/

--=========================================****************************************=========================================


--select * from ma_soltraam_solicitudes_tramites_academicos_maestrias

alter procedure [dbo].[sp_mostrar_examenes_diferidos_realizados]
	----------------------*----------------------
	-- =============================================
	-- Author:      <Fabio, Ramos>
	-- Create date: <2019-02-13 10:48:40.980>
	-- Description: <Devuelve los examenes diferidos y si aun tiene(opcion 3) examenes diferidos>
	-- =============================================
	-- exec sp_ver_ra_aan_activar_alumno_notas_maestrias 1,'43-0033-2017','1'
	-- exec sp_mo strar_examenes_diferidos_realizados 2,'43-0033-2017','1', 'Diferido'
	-- exec sp_mostrar_examenes_diferidos_realizados 4,'43-0132-2017','1', 'Diferido', 117
	-- exec sp_mostrar_examenes_diferidos_realizados 3,'43-0132-2017','0', 'Diferido'
	-- exec sp_ver_ra_aan_activar_alumno_notas_maestrias 2,'43-0033-2017','1', 'Examen-Extraordinario'
	@opcion int,
	@per_carnet nvarchar(25),
	@evaluacion int,
	@Tramite varchar(125),
	@codcil int = 0
as
begin
	if(@opcion=1)--EL GRIP DE LOS SOLICITADOS CON EXITO, ******************OBSOLETO******************
	begin
		select mat_nombre as MATERIA,hpl_codmat as 'CODIGO DE MATERIA',hpl_descripcion as SECCION, aan_periodo as EVALUACION,aan_tipo as TIPO
		from ra_aan_activar_alumno_notas 
			inner join ra_hpl_horarios_planificacion on aan_codhpl = hpl_codigo 
			inner join ra_mat_materias on mat_codigo = hpl_codmat  
			inner join ra_per_personas on per_codigo = aan_codper
			inner join ra_alc_alumnos_carrera on alc_codper = per_codigo
			inner join ra_pla_planes on pla_codigo = alc_codpla
		where per_carnet = @per_carnet and hpl_codcil in(select cil_codigo from ra_cil_ciclo where cil_vigente_mae = 'S') and  aan_periodo = @evaluacion and  aan_tipo =@Tramite order by aan_fecha desc  --and aan_codusr= 378 
	end
	if (@opcion = 2)--EL GRIP PARA ENVIAR EL CORREO
	begin
		select per_carnet as CARNET, per_nombres_apellidos as NOMBRE, mat_nombre as MATERIA, hpl_codmat as 'CODIGO DE MATERIA', hpl_descripcion as SECCION,
				 pla_alias_carrera as CARRERA, aan_periodo as EVALUACION, aan_tipo as TIPO
		from ra_aan_activar_alumno_notas 
				inner join ra_hpl_horarios_planificacion on aan_codhpl = hpl_codigo 
				inner join ra_mat_materias on mat_codigo = hpl_codmat 
				inner join ra_per_personas on per_codigo = aan_codper  

				/*inner join col_mov_movimientos on mov_codper = per_codigo
				inner join col_dmo_det_mov on dmo_codmov = mov_codigo 
				inner join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo */

				inner join ra_alc_alumnos_carrera on alc_codper = per_codigo  
				inner join ra_pla_planes on pla_codigo = alc_codpla
		where per_carnet = @per_carnet and hpl_codcil in(select cil_codigo from ra_cil_ciclo where cil_vigente_mae = 'S') and aan_periodo = @evaluacion and aan_tipo =@Tramite  -- and tmo_codigo = (select traar_codtmo from ra_traar_tramites_aranceles_online where traar_codtrao = @Tramite) 
		order by aan_fecha desc --aan_codusr= 412 and 
	end

	if (@opcion = 3)--DEVUELVE TODOS LOS TRAMITES SOLICITADOS POR EL ALUMNO
	begin
		declare @maximo_diferidos int, @diferidos_solicitados int
		select @maximo_diferidos = reqexd_max_diferidos from ma_reqexd_requisitos_examen_diferido where reqexd_codcil_vigencia = @codcil
		
		print '@maximo_diferidos: '  +cast(@maximo_diferidos as varchar(2))

		select @diferidos_solicitados = count(1)--per_carnet as CARNET, per_nombres_apellidos as NOMBRE, mat_nombre as MATERIA, hpl_codmat as 'CODIGO DE MATERIA', hpl_descripcion as SECCION, pla_alias_carrera as CARRERA, aan_periodo as EVALUACION, aan_tipo as TIPO
		from ra_aan_activar_alumno_notas 
			inner join ra_hpl_horarios_planificacion on aan_codhpl = hpl_codigo 
			inner join ra_mat_materias on mat_codigo = hpl_codmat 
			inner join ra_per_personas on per_codigo = aan_codper  

			/*inner join col_mov_movimientos on mov_codper = per_codigo
			inner join col_dmo_det_mov on dmo_codmov = mov_codigo 
			inner join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo */

			inner join ra_alc_alumnos_carrera on alc_codper = per_codigo  
			inner join ra_pla_planes on pla_codigo = alc_codpla
		where per_carnet = @per_carnet and hpl_codcil in(select cil_codigo from ra_cil_ciclo where cil_vigente_mae = 'S') and aan_tipo =@Tramite  -- and tmo_codigo = (select traar_codtmo from ra_traar_tramites_aranceles_online where traar_codtrao = @Tramite) 
		
		print '@diferidos_solicitados: '  +cast(@diferidos_solicitados as varchar(2))
		 if (@diferidos_solicitados >= @maximo_diferidos)
		begin
			print 'Ya solicito el maximo de diferidos'
			select 1
		end
		else
		begin
			print 'Aun puede solicitar diferidos'
			select 0
		end
	end
	if(@opcion=4)--Muestra los diferidos solicitados por el alumno en el ciclo
	begin
		if @Tramite = 'Diferido'
		begin
			select soltraam_codigo 'Codigo', soltraam_codpon as 'Evaluacion',mat_nombre as 'MATERIA', hpl_codmat as 'CODIGO DE MATERIA', hpl_descripcion as 'SECCION', soltraam_tipo as 'TIPO', soltraam_codhpl 'CodMat', soltraam_fecha_solicito 'Fecha solicito'
				from ma_soltraam_solicitudes_tramites_academicos_maestrias, ra_per_personas, ra_hpl_horarios_planificacion, ra_mat_materias
			where soltraam_codcil = @codcil and soltraam_codusr = 412 and soltraam_tipo = @Tramite and soltraam_codper = per_codigo and hpl_codigo = soltraam_codhpl and soltraam_codper = per_codigo and hpl_codmat = mat_codigo
				and soltraam_estado = 'Solicitado'
		end
		if @Tramite = 'Examen-Extraordinario'
		begin
			select soltraam_codigo 'Codigo', soltraam_codpon as 'Materia Nª',mat_nombre as 'MATERIA', hpl_codmat as 'CODIGO DE MATERIA', hpl_descripcion as 'SECCION', soltraam_tipo as 'TIPO', soltraam_codhpl 'CodMat', soltraam_fecha_solicito 'Fecha solicito'
				from ma_soltraam_solicitudes_tramites_academicos_maestrias, ra_per_personas, ra_hpl_horarios_planificacion, ra_mat_materias
			where soltraam_codcil = @codcil and soltraam_codusr = 412 and soltraam_tipo = @Tramite and soltraam_codper = per_codigo and hpl_codigo = soltraam_codhpl and soltraam_codper = per_codigo and hpl_codmat = mat_codigo
				and soltraam_estado = 'Solicitado'
		end
	end
end
go

--=========================================****************************************=========================================
