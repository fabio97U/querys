 select tmo_codigo,tmo_arancel,
 tmo_codgtm,tmo_descripcion,tmo_valor,
 tmo_tipo, tmo_talonarios, tmo_exento, tmo_cuenta,
 tmo_afecta_materia, tmo_estado, 
 isnull(tmo_matricula,'N') tmo_matricula,
 isnull(tmo_cuota1,'N') tmo_cuota1, 
 isnull(tmo_pago_inicial,'N') tmo_pago_inicial,isnull(tmo_cargo_abono,2) tmo_cargo_abono,
 isnull(tmo_codagr,0) tmo_codagr,
 agm_agrupacion,agm_codigo,otm_agrupacion,isnull(otm_codigo,0) otm_codigo,isnull(tmo_cupo,'') tmo_cupo, 
 isnull(tmo_codta,'0') tmo_codta, tmo_fecha_desde, tmo_fecha_hasta 
 from col_tmo_tipo_movimiento 
 inner join col_gtm_grupo_movimiento on gtm_codigo = tmo_codgtm 
 inner join col_agm_agrupaciones_mined on agm_codigo = gtm_codagm 
 left join col_otm_otros_mined on otm_codigo = tmo_codotm 
 --where tmo_codigo=