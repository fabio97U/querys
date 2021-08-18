select top 10 * from col_mov_movimientos order by mov_codigo desc
select * from ra_reg_regionales
select * from col_tit_tiraje
insert into col_tit_tiraje 
(tit_codigo, tit_tpodoc, tit_desde, tit_hasta, tit_codusr, tit_mes, tit_anio, tit_lote, tit_codreg, tit_estado)
values (8, 'F', 1, 50000, 407, 8, 2021, '23', 4, 1)
select * from adm_usr_usuarios where usr_nombre like '%glenda%'
--glenda.lopez, yc4257*

--https://dinpruebas.utec.edu.sv/uonlinetres/privado/FormaManRep.aspx?codigo=535
--select tit_lote codigo, tit_lote + ' - ' +
--case when tit_codreg = 1 then 'Colecturia'
--when tit_codreg = 2 then 'Metrocentro'
--when tit_codreg = 3 then 'Maestria'
--when tit_codreg = 4 then 'Plaza mundo'
--end
--nombre
--from dbo.col_tit_tiraje union select 21, '21 - Colecturia'


insert into adm_rol_roles (rol_codigo, rol_role)
values (187, 'Nuevo ingreso plaza mundo')

select * from adm_opm_opciones_menu
select * from adm_opu_opciones_role
insert into adm_opu_opciones_role (opu_role, opu_codopm, opu_acceso)
select 187, opu_codopm, opu_acceso from adm_opu_opciones_role where opu_role = 30

select max(cast(tit_anio as varchar)+right('00'+cast(tit_mes as varchar),2))
	from col_tit_tiraje, adm_usr_usuarios 
where tit_tpodoc = 'F' and usr_codigo = tit_codusr and tit_estado = 1

select max(b.mov_fecha_registro)
from col_mov_movimientos b 
	join col_tit_tiraje on tit_anio = year(b.mov_fecha) and tit_mes = month(b.mov_fecha) 
where b.mov_usuario = 'glenda.lopez' and b.mov_lote = tit_lote and tit_estado = 1







USE [uonline3]
GO
/****** Object:  StoredProcedure [dbo].[rep_facturas_ingreso_sucursal]    Script Date: 17/8/2021 11:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- =============================================
	-- Author:      <>
	-- Create date: <>
	-- Last modify: <Fabio, 2021-08-17 11:07:57.790>
	-- Description: <Devuelve los ingresos por suscursal, usado en el reporte rep_facturas_ingreso_sucursal.rpt>
	-- =============================================
	-- exec rep_facturas_ingreso_sucursal 1,'17/08/2021','17/08/2021','22'
ALTER proc [dbo].[rep_facturas_ingreso_sucursal] 
	@campo0 int,
	@campo1 varchar(10),
	@campo2 varchar(10),
	@sucursal varchar(10)
as
begin
    set dateformat dmy

    declare @regional varchar(100) ,
            @nombre_sucursal varchar(200)

    select @nombre_sucursal = 
		case 
			when tit_codreg = 1 then 'Colecturia UTEC'
			when tit_codreg = 2 then 'Metrocentrocentro'
            else 'Otro'
        end
    from col_tit_tiraje where tit_lote = @sucursal

    print '@nombre_sucursal ' + cast(@nombre_sucursal as varchar(125))

    select @regional = reg_nombre from ra_reg_regionales where reg_codigo = @campo0

    select uni_nombre, @regional regional, transacciones, tmo_arancel, tmo_descripcion, descripcion, sum(suma_ca) suma_ca, 
	sum(suma_cc) suma_cc, sum(suma_ba) suma_ba, sum(suma_cr) suma_cr, convert(datetime,@campo1,103) del, 
	convert(datetime,@campo2,103) al, upper(@nombre_sucursal) nombre_sucursal
    from (
		select count(tmo_arancel) transacciones, uni_nombre, tmo_arancel, tmo_descripcion, 'Ingresos' descripcion, 
			sum(case when mov_tipo_pago = 'C' then round(isnull(dmo_valor,0),2)+ round(isnull(dmo_iva,0),2) else 0 end) suma_ca, 
			sum(case when mov_tipo_pago = 'X' then round(isnull(dmo_valor,0),2)+ round(isnull(dmo_iva,0),2) else 0 end) suma_cc, 
			sum(case when mov_tipo_pago = 'B' then round(isnull(dmo_valor,0),2)+ round(isnull(dmo_iva,0),2) else 0 end) suma_ba, 
			sum(case when mov_tipo_pago = 'R' then round(isnull(dmo_valor,0),2)+ round(isnull(dmo_iva,0),2) else 0 end) suma_cr
		from col_mov_movimientos
			join col_dmo_det_mov on dmo_codmov = mov_codigo
			join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
			join ra_per_personas on per_codigo = mov_codper
			join ra_reg_regionales on reg_codigo = per_codreg
			join ra_uni_universidad on uni_codigo = reg_coduni 
		where mov_codreg = @campo0 and mov_fecha between convert(datetime,@campo1) and convert(datetime,@campo2)
			and mov_estado <> 'A' and dmo_valor >= 0 and mov_lote = @sucursal
		group by uni_nombre, tmo_arancel, tmo_descripcion, tmo_arancel
		
			union all

		select count(tmo_arancel) transacciones, uni_nombre, tmo_arancel, tmo_descripcion, 'Descuentos' descripcion, 
			sum(case when mov_tipo_pago = 'C' then round(isnull(dmo_valor,0),2)+ round(isnull(dmo_iva,0),2) else 0 end) suma_ca, 
			sum(case when mov_tipo_pago = 'X' then round(isnull(dmo_valor,0),2)+ round(isnull(dmo_iva,0),2) else 0 end) suma_cc, 
			sum(case when mov_tipo_pago = 'B' then round(isnull(dmo_valor,0),2)+ round(isnull(dmo_iva,0),2) else 0 end) suma_ba, 
			sum(case when mov_tipo_pago = 'R' then round(isnull(dmo_valor,0),2)+ round(isnull(dmo_iva,0),2) else 0 end) suma_cr
		from col_mov_movimientos
			join col_dmo_det_mov on dmo_codmov = mov_codigo
			join col_tmo_tipo_movimiento on tmo_codigo = dmo_codtmo
			join ra_per_personas on per_codigo = mov_codper
			join ra_reg_regionales on reg_codigo = per_codreg
			join ra_uni_universidad on uni_codigo = reg_coduni 
		where mov_codreg = @campo0 and mov_fecha between convert(datetime,@campo1) and convert(datetime,@campo2)
			and mov_estado <> 'A' and dmo_valor < 0 and mov_lote = @sucursal
		group by uni_nombre, tmo_arancel, tmo_descripcion, tmo_arancel

			union all

		select count(tmo_arancel) transacciones, uni_nombre, tmo_arancel, tmo_descripcion, ' Cuentas por Cobrar' descripcion, 0 suma_ca,
			case 
			when fac_tipo = 'F' then sum(round(isnull(dfa_valor,0),2))
			when fac_tipo = 'C' then 
				case 
					when tmo_exento = 'S' then sum(round(isnull(dfa_valor,0),2))
					when tmo_exento = 'N' then sum(round(isnull(dfa_valor,0),2)+ round(isnull(dfa_iva,0),2))
				end
			when fac_tipo = 'E' then 
				case 
					when tmo_exento = 'S' then sum(round(isnull(dfa_valor,0),2))
					when tmo_exento = 'N' then sum(round(isnull(dfa_valor,0),2)+ round(isnull(dfa_iva,0),2))
				end
			end suma_cc,
			0 suma_ba, 0 suma_cr
		from col_fac_facturas
			join col_dfa_det_fac on dfa_codfac = fac_codigo
			join col_tmo_tipo_movimiento on tmo_codigo = dfa_codtmo
			join col_cli_clientes on cli_codigo = fac_codcli
			join ra_reg_regionales on reg_codigo = @campo0
			join ra_uni_universidad on uni_codigo = reg_coduni 
		where fac_codreg = @campo0 
			and fac_fecha between convert(datetime,@campo1) and convert(datetime,@campo2) and fac_estado <> 'A' 
			and fac_factura <> 0 and cli_alumnos in('S','N') and fac_lote = @sucursal
		group by uni_nombre, tmo_arancel, tmo_descripcion, fac_tipo, tmo_exento, tmo_arancel
    ) t group by uni_nombre, tmo_arancel, tmo_descripcion, descripcion, transacciones
    order by descripcion desc, tmo_arancel

end


-- =============================================
-- Author:      <>
-- Create date: <>
-- Last modify: <2020-04-12 02:16:28.960, Fabio>
-- Description: <Realiza la consulta a que colecturía pertenece un usuario cajero>
-- =============================================
-- col_buscar_role 'glenda.lopez', 187
ALTER procedure [dbo].[col_buscar_role] 
(
	@usr_usuario varchar(40), 
	@rus_role int out
)
as
begin
	declare @roles as table (rol int)
	--set @rol=0
	set @rus_role =0;
	insert into @roles (rol)
	select rus_role FROM [adm_usr_usuarios] 
	inner join  adm_rus_role_usuarios on usr_codigo = rus_codusr
	where usr_usuario = @usr_usuario

	if exists (select 1 from @roles where rol in (10, 12)) --COLECTURIA UTEC
	begin
		set @rus_role = 1
	end

	if exists (select 1 from @roles where rol in (30, 70)) --COLECTURIA METRO
	begin
		set @rus_role = 2
	end

	if exists (select 1 from @roles where rol in (118)) --COLECTURIA MAESTRIAS
	begin
		set @rus_role = 3
	end

	if exists (select 1 from @roles where rol in (187)) --COLECTURIA MAESTRIAS
	begin
		set @rus_role = 4
	end

end


	-- exec col_siguinte_recibo 'glenda.lopez'
ALTER procedure [dbo].[col_siguinte_recibo]  
	@usuario varchar(20) 
as
begin
	set dateformat dmy 
	select recibo from ( 
		select max(recibo) recibo
		from  ( 
		select recibo
		from ( 
				select isnull(max(cast(a.mov_recibo as int)),0)+1 recibo 
				from col_mov_movimientos a
				where cast(year(a.mov_fecha) as varchar) + right('00'+cast(month(a.mov_fecha) as varchar),2) >= 
				(
					select max(cast(tit_anio as varchar)+right('00'+cast(tit_mes as varchar),2))
						from col_tit_tiraje, adm_usr_usuarios 
					where tit_tpodoc = 'F' and usr_codigo = tit_codusr and tit_estado = 1
				)
				and a.mov_fecha_registro < getdate() 
				and a.mov_usuario = @usuario
				and (
					select max(b.mov_fecha_registro)
					from col_mov_movimientos b 
						join col_tit_tiraje on tit_anio = year(b.mov_fecha) and tit_mes = month(b.mov_fecha) 
					where b.mov_usuario = @usuario and b.mov_lote = tit_lote and tit_estado = 1
				) = a.mov_fecha_registro
			) t
		) z 
	) z1

end
