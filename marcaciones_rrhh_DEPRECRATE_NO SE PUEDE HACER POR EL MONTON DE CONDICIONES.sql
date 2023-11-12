set dateformat ymd

declare @inicio datetime = '2023-05-01 00:00:00.000',
		@fin datetime = '2023-05-31 00:00:00.000',
		@hora_entrada_manana nvarchar(5) = '08:00',
		@hora_salida_manana nvarchar(5) = '12:00',
		@hora_entrada_tarde nvarchar(5) = '13:00',
		@hora_salida_tarde nvarchar(5) = '17:00'

declare @datos_marcacion table(
	[D-019] float, 
	[D-112] float,
	[S-026] float,
	dia int,
	idnumero int, justificacionDeMinutosTarde int
)

insert into @datos_marcacion ([D-019], [D-112], [S-026], dia, idnumero, justificacionDeMinutosTarde)
select 
	   iif(cast(datediff(minute, manana_entra, tmanana_entra) as float) < 0, 0,cast(datediff(minute,manana_entra, tmanana_entra)  as float)) [D-019],
	   iif(cast(datediff(minute, tarde_entra, ttarde_entra) as numeric) < 0, 0,cast(datediff(minute,tarde_entra, ttarde_entra) as numeric)) [D-112],
	   iif(cast(datediff(minute, ttarde_sale, tarde_sale) as numeric) < 0, 0,cast(datediff(minute,ttarde_sale, tarde_sale) as numeric)) [S-026],
	   dia, idnumero, justificacionDeMinutosTarde
from (
	select CONVERT(datetime, concat(CONVERT(varchar(10), fecha_entra, 120), ' ', hora_entra), 120) tmanana_entra,
		CONVERT(datetime, concat(CONVERT(varchar(10), fecha_entra, 120), ' ', desc1_ini), 120) tmanana_sale,
		CONVERT(datetime, concat(CONVERT(varchar(10), fecha_entra, 120), ' ', desc1_fin), 120) ttarde_entra,
		CONVERT(datetime, concat(CONVERT(varchar(10), fecha_entra, 120), ' ', hora_sale), 120) ttarde_sale,
		CONVERT(datetime, concat(CONVERT(varchar(10), fecha_entra, 120), ' ', @hora_entrada_manana), 120) manana_entra,
		CONVERT(datetime, concat(CONVERT(varchar(10), fecha_entra, 120), ' ', @hora_salida_manana), 120) manana_sale,
		CONVERT(datetime, concat(CONVERT(varchar(10), fecha_entra, 120), ' ', @hora_entrada_tarde), 120) tarde_entra,
		CONVERT(datetime, concat(CONVERT(varchar(10), fecha_entra, 120), ' ', @hora_salida_tarde), 120) tarde_sale,
		datepart(weekday,fecha_entra) dia,
		fecha_entra, idnumero, 
		(
			select count(1) from utec.marcas_incidencias mi 
			where mi.idnumero = vm.idnumero and mi.fecha = vm.fecha_entra and mi.incidencia_just <> 0
		) 'justificacionDeMinutosTarde'
	from UTEC.VMarcas_Comedor vm
	where fecha_entra between @inicio and @fin 
)t
--select * from UTEC.VMarcas_Comedor where idnumero = '04289' order by fecha_entra

select * from (
	select idnumero,
	sum([D-019]) - 15.0 [D-019],
	sum([D-112]) [D-112],
	sum([S-026]) [S-026]
	from @datos_marcacion dm
	where justificacionDeMinutosTarde = 0
	group by idnumero
) t
inner join utec.empleados e on e.idnumero = t.idnumero
where t.[D-019] > 0

-- select *from UTEC.empleados where idnumero = '04291'
-- select *from UTEC.ph_conceptos 

