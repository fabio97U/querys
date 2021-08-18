--CORRECTO:
--https://portalempresarial.utec.edu.sv/uonline/privado/reportes.aspx?reporte=rep_abono_cuenta_dhc&filas=8&campo0=1&campo1=1&campo2=2021&campo3=6&campo4=1&campo5=51&campo6=125&campo7=125

--INCORRECTO NO SUMA EL ARANCEL DE $60, CARLOS GUILLERMO BRAN
--https://portalempresarial.utec.edu.sv/uonline/privado/reportes.aspx?reporte=rep_archivo_banco_azul&filas=8&campo0=2&campo1=1&campo2=1&campo3=2021&campo4=6&campo5=1&campo6=51&campo7=0


select * from pla_tpl_tipo_planilla where tpl_codigo in (15, 16, 20, 24, 27, 29)
select * from PLA_INN_INGRESOS 
--inner join pla_emp_empleado on inn_codemp = emp_codigo
where inn_codpla = 202106 and inn_codemp = 1156
select * from PLA_DSS_DESCUENTOS 
--inner join pla_emp_empleado on dss_codemp = emp_codigo
where dss_codpla = 202106 and dss_codemp = 1156
select * from pla_hort_emp_trabajadas where HorT_codpla = 202106

select * from pla_tpl_tipo_planilla where tpl_codigo in (15, 16, 17, 18, 20, 21, 23, 24, 27, 29, 32, 33, 19, 22, 25, 26, 28, 30, 34, 35, 36, 37)
select * from pla_pla_planilla
select * from pla_net_neto_v where --NET_CODEMP = 1156 and 
NET_CODPLA = 202106 and NET_TIPO_ID = 50

declare @codreg int = 1, @anio int = 2021, @mes int = 6, @frecuencia int = 1, @banco int = 51
select *
--distinct emp_codigo, emp_nombres_apellidos, emp_cuenta_dhc,
--	case when NET_TIPO = 'I' then sum(net_valor)
--	when NET_TIPO = 'D' then -1 * sum(net_valor)
--	end as Monto, net_tipo
from pla_emp_empleado
	join pla_plz_plaza on plz_codigo = emp_codplz
	join pla_uni_unidad on uni_codigo = plz_coduni
	join pla_net_neto_v on net_codemp = emp_codigo
	join pla_pla_planilla on pla_codtpl = net_codtpl
		and pla_codigo = net_codpla
	join con_cuc_cuentas_contables on cuc_codigo = uni_codcuc
	join adm_ban_bancos on ban_codigo = emp_codban_pago 
where emp_codreg = @codreg and pla_anio = @anio and pla_mes = @mes and pla_frecuencia = @frecuencia
	and pla_codtpl in (15, 16, 17, 18, 20, 21, 23, 24, 27, 29, 32, 33, 19, 22, 25, 26, 28, 30, 34, 35, 36, 37)
	and emp_codban_dhc = case @banco when 0 then emp_codban_dhc else @banco end
	and len(emp_cuenta) > 0 and emp_codigo in (3325)
	and NET_CODPLA = pla_codigo
group by emp_codigo, emp_nombres_apellidos, emp_cuenta_dhc, net_tipo


-- exec rep_abono_cuenta_dhc 1, 1, 2021, 6, 1, 51, 125, 125
-- exec dbo.rep_archivo_con_deposito_para_empleados 1, 1, 1, 2020, 6, 1, 51, 1		-- Planilla de personal de quincenal