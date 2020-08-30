ALTER VIEW dbo.electivas_cursadas
as
SELECT        dbo.ra_plm_planes_materias.plm_bloque_electiva, a.ins_codper, n.nota, /*case when(a.ins_codcil = 85)then 6.0 else nota end as nota,                  */ b.mai_codpla, b.mai_codmat, CASE WHEN mat_codigo LIKE '%1-T%' AND 
mat_electiva = 'S' AND esc_codfac = 8/*mat_codesc = 4*/ THEN 'E1' WHEN mat_codigo LIKE '%1-V%' AND mat_electiva = 'S' AND esc_codfac = 8/*mat_codesc = 4*/ THEN 'E1' WHEN mat_codigo LIKE '%2-T%' AND mat_electiva = 'S' AND 
esc_codfac = 8/*mat_codesc = 4*/ THEN 'E2' WHEN mat_codigo LIKE '%2-V%' AND mat_electiva = 'S' AND esc_codfac = 8/*mat_codesc = 4*/ THEN 'E2' WHEN mat_codigo LIKE '%3-T%' AND mat_electiva = 'S' AND 
esc_codfac = 8/*mat_codesc = 4*/ THEN 'E3' WHEN mat_codigo LIKE '%3-V%' AND mat_electiva = 'S' AND esc_codfac = 8/*mat_codesc = 4*/ THEN 'E3' WHEN mat_codigo LIKE '%4-T%' AND mat_electiva = 'S' AND 
esc_codfac = 8/*mat_codesc = 4*/ THEN 'E4' WHEN mat_codigo LIKE '%4-V%' AND mat_electiva = 'S' AND esc_codfac = 8/*mat_codesc = 4*/ THEN 'E4' END /*END */ AS Elect, b.mai_estado, b.mai_matricula, b.mai_codigo, a.ins_codcil
FROM            dbo.ra_ins_inscripcion AS a INNER JOIN
dbo.ra_mai_mat_inscritas AS b ON b.mai_codins = a.ins_codigo INNER JOIN
dbo.ra_cil_ciclo AS c ON c.cil_codigo = a.ins_codcil INNER JOIN
dbo.ra_cic_ciclos AS d ON d .cic_codigo = c.cil_codcic INNER JOIN
dbo.ra_alc_alumnos_carrera ON dbo.ra_alc_alumnos_carrera.alc_codper = a.ins_codper LEFT OUTER JOIN
dbo.notas AS n ON n.ins_codigo = a.ins_codigo AND n.mai_codigo = b.mai_codigo INNER JOIN
dbo.ra_mat_materias AS m ON m.mat_codigo = b.mai_codmat INNER JOIN
dbo.ra_pla_planes ON dbo.ra_pla_planes.pla_codigo = b.mai_codpla INNER JOIN
dbo.ra_plm_planes_materias ON dbo.ra_plm_planes_materias.plm_codpla = dbo.ra_pla_planes.pla_codigo AND b.mai_codmat = dbo.ra_plm_planes_materias.plm_codmat
/*Agreado por Fabio 15/07/2020 para ya no buscar por codesc = 4 sino que por codfac = 8*/
inner join ra_esc_escuelas on mat_codesc = esc_codigo
WHERE        (dbo.ra_plm_planes_materias.plm_bloque_electiva <> 0)
UNION ALL
SELECT        dbo.ra_plm_planes_materias.plm_bloque_electiva, a.equ_codper ins_codper, b.eqn_nota nota, /*case when(a.ins_codcil = 85)then 6.0 else nota end as nota,                  */ a.equ_codpla mai_codpla, b.eqn_codmat mai_codmat, 
CASE WHEN mat_codigo LIKE '%1-T%' AND mat_electiva = 'S' AND esc_codfac = 8/*mat_codesc = 4*/ THEN 'E1' WHEN mat_codigo LIKE '%1-V%' AND mat_electiva = 'S' AND esc_codfac = 8/*mat_codesc = 4*/ THEN 'E1' WHEN mat_codigo LIKE '%2-T%' AND 
mat_electiva = 'S' AND esc_codfac = 8/*mat_codesc = 4*/ THEN 'E2' WHEN mat_codigo LIKE '%2-V%' AND mat_electiva = 'S' AND esc_codfac = 8/*mat_codesc = 4*/ THEN 'E2' WHEN mat_codigo LIKE '%3-T%' AND mat_electiva = 'S' AND 
esc_codfac = 8/*mat_codesc = 4*/ THEN 'E3' WHEN mat_codigo LIKE '%3-V%' AND mat_electiva = 'S' AND esc_codfac = 8/*mat_codesc = 4*/ THEN 'E3' WHEN mat_codigo LIKE '%4-T%' AND mat_electiva = 'S' AND 
esc_codfac = 8/*mat_codesc = 4*/ THEN 'E4' WHEN mat_codigo LIKE '%4-V%' AND mat_electiva = 'S' AND esc_codfac = 8/*mat_codesc = 4*/ THEN 'E4' END AS Elect, 'I' mai_estado, 1 mai_matricula, b.eqn_codigo mai_codigo, 0 ins_codcil
FROM            ra_equ_equivalencia_universidad a JOIN
ra_eqn_equivalencia_notas b ON a.equ_codigo = b.eqn_codequ INNER JOIN
dbo.ra_mat_materias AS m ON m.mat_codigo = b.eqn_codmat INNER JOIN
dbo.ra_pla_planes ON dbo.ra_pla_planes.pla_codigo = a.equ_codpla INNER JOIN
dbo.ra_plm_planes_materias ON dbo.ra_plm_planes_materias.plm_codpla = dbo.ra_pla_planes.pla_codigo AND b.eqn_codmat = dbo.ra_plm_planes_materias.plm_codmat
/*Agreado por Fabio 15/07/2020 para ya no buscar por codesc = 4 sino que por codfac = 8*/
inner join ra_esc_escuelas on mat_codesc = esc_codigo
WHERE        (dbo.ra_plm_planes_materias.plm_bloque_electiva <> 0) AND eqn_nota >= 6.0
go