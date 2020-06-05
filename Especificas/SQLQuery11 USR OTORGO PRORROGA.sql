select per_carnet, per_apellidos_nombres, usr_nombre 'USUARIO OTORGO PRORROGA', pra_fecha 'FECHA OTORGO' 
from ra_pra_prorroga_acad 
inner join ra_per_personas on per_codigo = pra_codper
inner join adm_usr_usuarios on usr_codigo = pra_codusr
where pra_codpoo = 113 and SUBSTRING(per_carnet, 9, 4) between '1980' and '2016'
and pra_codusr <> 378 and pra_codigo >= 174831
order by pra_fecha desc