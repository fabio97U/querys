--2) Decimo ciclo
select * from ra_egr_egresados as egr
inner join ra_per_personas as per on egr.egr_codper = per.per_codigo 
where egr_fecha > '2018-01-01' and egr_fecha <'2018-12-31'

--3) Egresados del 2018
select distinct per.per_carnet, per.per_apellidos_nombres, per.per_correo_institucional, per.per_email, per.per_email_opcional, car.car_nombre, fac.fac_nombre, egr.egr_fecha from ra_egr_egresados as egr
inner join ra_per_personas as per on egr.egr_codper = per.per_codigo 
inner join ra_alc_alumnos_carrera as alc on alc.alc_codper = per.per_codigo
inner join ra_pla_planes on pla_codigo = alc_codpla
inner join ra_car_carreras as car on car.car_codigo = pla_codcar
inner join ra_fac_facultades as fac on car_codfac = fac.fac_codigo
where egr_fecha > '2018-01-01' and egr_fecha <'2018-12-31'
ORDER by fac.fac_nombre  asc


--4) Egresados del 2013-2017
select distinct per.per_carnet, per.per_apellidos_nombres, per.per_correo_institucional, per.per_email, per.per_email_opcional, car.car_nombre, fac.fac_nombre, egr.egr_fecha from ra_egr_egresados as egr
inner join ra_per_personas as per on egr.egr_codper = per.per_codigo 
inner join ra_alc_alumnos_carrera as alc on alc.alc_codper = per.per_codigo
inner join ra_pla_planes on pla_codigo = alc_codpla
inner join ra_car_carreras as car on car.car_codigo = pla_codcar
inner join ra_fac_facultades as fac on car_codfac = fac.fac_codigo
where egr_fecha > '2013-01-01' and egr_fecha <'2017-12-31' --and fac.fac_nombre <> 'MAESTRIAS'
ORDER by fac.fac_nombre  asc
