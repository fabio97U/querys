select * from ni_sni_solicitud_nuevo_ingreso--16 2020-07-01 14:43:18.507, 26 2020-07-04T22:21:01.7182769-06:00, 40 2020-07-07T09:01:53.8648683-06:00
--45 2020-07-08T00:00:08.4646051-06:00, 62 2020-07-10T07:56:35.5334069-06:00

select * from err_errores_sistema 
where err_formulario = 'NI_detalle_solicitud.cs'
order by err_codigo desc--3 maxcod 4085, 2020-06-26 18:49:39.937, 12 2020-07-10T07:56:35.5334069-06:00

