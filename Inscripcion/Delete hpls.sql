declare @codhpl int = 45962
delete from mvpch_materias_virtuales_po_ciclo_historico where mvpch_codhpl = @codhpl
delete from aupla_auditoria_planificacion where aupla_codhpl = @codhpl
delete from ra_hpc_hpl_car where hpc_codhpl = @codhpl
delete from ra_mai_mat_inscritas where mai_codhpl = @codhpl
delete from ra_prha_planificacion_restriccion_hoja_asesoria where prha_codhpl = @codhpl
delete from ra_hpl_horarios_planificacion where hpl_codigo = @codhpl