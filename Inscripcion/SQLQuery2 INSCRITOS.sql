select *  from ra_ins_inscripcion 
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
--11092, 11180, 11788, 11846, 11992, 12191, 12242, 12253, 12342, 12377, 12392, 12474, 12501, 12567, 12864,
--12905, 12912, 13027, 13107, 13108, 13152, 13352, 13449, 13442
where ins_codcil = 124 --and isnull(mai_codigo, 0) = 0
order by ins_codigo

select *  from dip_amd_alm_modulo where amd_codigo >= 21899 --and amd_codper = 207734
order by amd_codigo desc
--2309, 2405, 3045, 3111, 3242, 3420, 3462, 3486, 3571, 3602, 3628, 3713, 3739, 3777, 3939,
--3956, 3958, 4041, 4144, 4145, 4232, 4610, 4086, 4826

select *  from ra_ins_bitcam_inscripcion_bitacora_cambios-- where bitcam_codper = 225521
--2102, 2874, 3292, 3347, 3471, 3508, 3531, 3622, 3654, 4051, 4096, 4099, 4612 (5710, 2020-06-17 18:34:36.607)
--4921, 4934

select * from ins_errins_errores_inscrpcion where-- errins_mensaje_error like '%mai_tg%'
errins_codigo >= 8334--17, 19, 20, 21, 23

select *  from ra_ins_inscripcion where ins_codcil = 124
--11092, 11180, 11788, 11846, 11992, 12191, 12242, 12253, 12342, 12377, 12392, 12474, 12501, 12567, 12864,
--12905, 12912

select 1, concat('Alumnos inscritos: ', (select count(1) from ra_ins_inscripcion where ins_codcil = 124)) union
select 2, concat('Alumnos inscribieron diplomados: ', (select count(1) from dip_amd_alm_modulo where amd_codigo >= 21899))

select * from ra_per_personas where per_codigo = 218291

select * from ra_ins_inscripcion 
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
where ins_codper = 223191 and ins_codcil = 124--42366

select * from ra_ins_bitcam_inscripcion_bitacora_cambios where bitcam_codper = 223191
select * from ra_hpl_horarios_planificacion where hpl_codigo in (
42401,
42334,
42403)





select top 1 amd_codper  from dip_amd_alm_modulo 
inner join dip_fea_fechas_autorizadas on fea_codigo = amd_codfea
inner join dip_hrm_horarios on hrm_codigo = amd_codhrm
inner join dip_mdp_modulos_diplomado on fea_codmdp = mdp_codigo
inner join dip_dip_diplomados on dip_codigo = mdp_coddip
inner join ra_fac_facultades on fac_codigo = dip_codfac
where amd_codigo >= 21899 and amd_codper not in (select ins_codper  from ra_ins_inscripcion where ins_codcil = 124)
--order by amd_codigo desc
group by fac_nombre

select * from (
select fac_nombre, count(1) tot from ra_ins_inscripcion 
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
inner join ra_hpl_horarios_planificacion on hpl_codigo = mai_codhpl
inner join ra_esc_escuelas on esc_codigo = hpl_codesc
inner join ra_fac_facultades on fac_codigo = esc_codfac
--inner join ra_fac_facultades on fac_codigo = codfac
where ins_codcil = 124
--group by ins_codper
group by fac_nombre
) r
where r.tot > 1

select * from ra_ins_inscripcion 
inner join ra_mai_mat_inscritas on mai_codins = ins_codigo
where ins_codper in (
223191
)and ins_codcil = 124

select * from ins_errins_errores_inscrpcion
where errins_mensaje_error like '%172909%' or errins_parametros like '%172909%'

select * from ra_per_personas where per_codigo = 172909


--32-0505-2020 SE LE BORRO LA SECCION 06 Y SE LE DEJO LA 08