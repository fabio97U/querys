update ra_per_personas set per_codpai_residencia = 1 where per_carnet in( select per_carnet from ra_per_personas inner join ra_mun_municipios
 on MUN_CODIGO=per_codmun_nac inner join ra_dep_departamentos on DEP_CODIGO = per_coddep_nac left join ra_pai_paises on pai_codigo = per_codpai_residencia
where per_codigo in (select ins_codper from ra_ins_inscripcion where ins_codcil = 119) and per_estado = 'A' and per_tipo = 'U' and DEP_NOMBRE IN('AHUACHAPAN',
'CABAÑAS',
'CHALATENANGO',
'CUSCATLAN',
'LA LIBERTAD',
'LA PAZ ',
'LA UNION',
'MORAZAN',
'SAN MIGUEL',
'SAN SALVADOR',
'SAN VICENTE',
'SANTA ANA',
'SONSONATE',
'USULUTAN') and isnull(pai_nombre, '') = '')

select 1 cant,pai_nombre, DEP_NOMBRE, MUN_NOMBRE,per_carnet, per_nombres_apellidos from ra_per_personas inner join ra_mun_municipios
on MUN_CODIGO=per_codmun_nac inner join ra_dep_departamentos on DEP_CODIGO = per_coddep_nac left join ra_pai_paises on pai_codigo = per_codpai_residencia
where per_codigo in (select ins_codper from ra_ins_inscripcion where ins_codcil = 119) and per_estado = 'A' and DEP_NOMBRE IN('AHUACHAPAN',
'CABAÑAS',
'CHALATENANGO',
'CUSCATLAN',
'LA LIBERTAD',
'LA PAZ ',
'LA UNION',
'MORAZAN',
'SAN MIGUEL',
'SAN SALVADOR',
'SAN VICENTE',
'SANTA ANA',
'SONSONATE',
'USULUTAN')  order by DEP_NOMBRE,MUN_NOMBRE asc

select per_codpai_residencia,*  from ra_per_personas where per_carnet = '25-1565-2015'