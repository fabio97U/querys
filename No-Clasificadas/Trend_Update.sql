select * from ra_per_personas WHERE per_carnet = '29-0283-2021'--228673

--select * from ni_sni_solicitud_nuevo_ingreso 
--where sni_per_codigo_asignado = 228673
--order by sni_codigo desc

select * from ni_sni_solicitud_nuevo_ingreso 
where sni_codigo = 611

--228673, 29-0283-2021--JOSE EDUARDO	MARTINEZ CHILIN
--228691, 29-0300-2021--JESUS GILBERTO	LEMUS DIAZ
--228740, 27-0349-2021--EDWIN ANTONIO	ESCOBAR RUMALDO

select * from ra_per_personas
where per_codigo in (228740,228691,228673)
order by per_codigo

update ni_sni_solicitud_nuevo_ingreso set sni_per_codigo_asignado = 228691/*ORIGINAL: 228673*/
where sni_codigo = 611

--select * from ni_sni_solicitud_nuevo_ingreso where sni_codigo = 606
update ni_sni_solicitud_nuevo_ingreso set sni_per_codigo_asignado = 228673/*ORIGINAL: NULL*/
where sni_codigo = 606

--select * from ni_sni_solicitud_nuevo_ingreso where sni_codigo = 534
update ni_sni_solicitud_nuevo_ingreso set sni_per_codigo_asignado = 228740/*ORIGINAL: NULL*/
where sni_codigo = 534