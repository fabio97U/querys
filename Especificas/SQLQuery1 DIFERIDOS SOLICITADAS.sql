--ultimo codigo antes del cambio 12108, 2020-04-21 09:53:30.477
-- primer codigo sin la validacion de pago 12109, 2020-04-21 10:17:57.037
select top 10 * from web_spa_solicitud_proceso_academico 
inner join ra_per_personas on per_codigo = spa_codper
--where spa_eva = 3 and spa_codcil = 122
order by spa_codigo desc
select top 10 * from err_errores_sistema order by err_codigo desc