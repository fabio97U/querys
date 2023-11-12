select convert(datetime, rei_fecha, 103) rei_fecha
from dbo.con_rei_retencion_iva 
	inner join dbo.con_pro_proveedores on rei_codpro = pro_codigo
	inner join dbo.cat_m013_municipio_013 on pro_codm013 = m013_mundep

	inner join dbo.adm_usr_usuarios on usr_codigo = rei_codusr_creacion
	inner join dbo.pla_emp_empleado on usr_codemp = emp_codigo
where rei_codigo >= 12150

select cast('13/02/2023' as date)
select * from con_rei_retencion_iva
alter table con_rei_retencion_iva add rei_codusr_creacion int

select * from adm_usr_usuarios where usr_nombre like '%rebec%'
select * from pla_emp_empleado where emp_nombres_apellidos like '%rebeca%'

update con_rei_retencion_iva set rei_codusr_creacion = 102


alter table con_rei_retencion_iva add rei_codigo_generacion varchar(60)
alter table con_rei_retencion_iva add rei_numero_control varchar(35)
alter table con_rei_retencion_iva add rei_sello_recepcion varchar(60)
alter table con_rei_retencion_iva add rei_fecha_generacion_fe datetime
alter table con_rei_retencion_iva add rei_rechazado_por_mh bit null
alter table con_rei_retencion_iva add rei_rechazos_por_mh int null

alter table con_rei_retencion_iva add rei_modelo_invalido bit null
alter table con_rei_retencion_iva add rei_rechazos_modelo_invalido int null

alter table con_rei_retencion_iva add rei_correlativo_anual int not null default 0

update con_rei_retencion_iva set rei_correlativo_anual = 0
ALTER TABLE con_rei_retencion_iva ALTER column rei_correlativo_anual int not null

ALTER TABLE con_rei_retencion_iva ADD CONSTRAINT default_rei_correlativo_anual DEFAULT 0 FOR rei_correlativo_anual
go
