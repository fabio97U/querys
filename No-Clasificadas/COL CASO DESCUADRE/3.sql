select * from con_tip_tipo_partidas
select * from con_cim_cierre_mes
select * from con_pec_per_contable

select * from con_par_partidas
where par_estado = 'A'
--and par_partida = 'I02210025'
order by par_codigo

select * from con_pec_per_contable

select * from con_cuc_cuentas_contables
where cuc_cuenta = '2250101'

select * from col_fac_facturas where fac_codigo = 6673
select * from con_recc_registro_cuentas_cobrar
select * from con_decc_det_cta_cobrar
----------------referencias a "con_pad_partidas_det"