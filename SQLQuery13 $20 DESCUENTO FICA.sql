--483 alumnos pagaron $20 por certificación
--Pasar esos $20 como descuento a segunda cuota (o la que no haya pagado)
--si no ha inscrito, o si ya se hizo el descuento, o ya pago todo el ciclo, NO HACER EL DESCUENTO SE PROCEDE A HACER DEVOLUCIÓN DE DINERO

--drop table alumnos_$20_descuento_BORRAME
create table alumnos_$20_descuento_BORRAME (
	numero int,
	carnet varchar(16)
)
--select * from alumnos_$20_descuento_BORRAME
--insert into alumnos_$20_descuento_BORRAME (numero, carnet) values
--(1, '32-0151-2020'), (2, '11-4917-2018'), (3, '11-4966-2018'), (4, '51-2446-2018'), (5, '32-2580-2020'), (6, '09-0471-2020'), (7, '32-0789-2020'), (8, '32-2465-2020'), (9, '32-2944-2020'), (10, '32-2399-2020'), (11, '51-2841-2018'), (12, '13-2350-2018'), (13, '08-0961-2020'), (14, '08-0942-2020'), (15, '32-0258-2020'), (16, '32-0661-2020'), (17, '31-1225-2018'), (18, '32-0474-2020'), (19, '32-1032-2020'), (20, '08-0301-2020'), (21, '08-2149-2020'), (22, '12-0038-2017'), (23, '31-1884-2019'), (24, '08-0842-2020'), (25, '31-4816-2019'), (26, '31-4735-2019'), (27, '31-4257-2019'), (28, '08-0305-2020'), (29, '34-3413-2018'), (30, '51-0058-2019'), (31, '31-4412-2019'), (32, '32-2373-2020'), (33, '12-0945-2018'), (34, '32-0816-2020'), (35, '13-2666-2018'), (36, '08-5225-2019'), (37, '08-0922-2020'), (38, '08-2740-2020'), (39, '12-1826-2016'), (40, '05-4964-2016'), (41, '32-1471-2020'), (42, '32-0743-2020'), (43, '32-2026-2020'), (44, '32-2025-2020'), (45, '32-0657-2020'), (46, '32-0181-2020'), (47, '32-0723-2020'), (48, '32-0641-2020'), (49, '32-0235-2020'), (50, '32-0805-2020'), (51, '09-0245-2020'), (52, '32-0602-2020'), (53, '32-0526-2020'), (54, '32-0111-2020'), (55, '09-0798-2020'), (56, '32-0823-2020'), (57, '32-1975-2020'), (58, '08-1896-2020'), (59, '32-1450-2020'), (60, '32-0036-2020'), (61, '32-0220-2020'), (62, '32-0812-2020'), (63, '32-0616-2020'), (64, '32-0255-2020'), (65, '32-0671-2020'), (66, '09-0763-2020'), (67, '32-0754-2020'), (68, '32-0533-2020'), (69, '11-2825-2018'), (70, '32-2075-2020'), (71, '32-0708-2020'), (72, '13-3328-2018'), (73, '32-0030-2020'), (74, '32-1919-2020'), (75, '32-0735-2020'), (76, '32-0624-2020'), (77, '32-0714-2020'), (78, '32-0505-2020'), (79, '34-2038-2014'), (80, '05-0980-2016'), (81, '32-2628-2020'), (82, '31-0403-2015'), (83, '12-2111-2006'), (84, '11-2172-2018'), (85, '32-4949-2015'), (86, '32-2078-2015'), (87, '34-1270-2015'), (88, '67-0150-2019'), (89, '11-4437-2016'), (90, '20-5023-2018'), (91, '32-1884-2014'), (92, '32-2353-2017'), (93, '32-0658-2020'), (94, '32-2702-2020'), (95, '32-0507-2020'), (96, '11-3919-2017'), (97, '32-1920-1997'), (98, '05-1533-2017'), (99, '12-5344-2016'), (100, '08-6365-2011'), (101, '13-2076-2015'), (102, '51-1248-2017'), (103, '51-1846-2016'), (104, '34-1944-2010'), (105, '11-2976-2017'), (106, '08-2443-2020'), (107, '51-3448-2017'), (108, '12-2099-2015'), (109, '11-1116-2018'), (110, '13-4181-2017'), (111, '40-3575-2016'), (112, '34-5401-2017'), (113, '34-2733-2019'), (114, '08-3164-2016'), (115, '34-0689-2019'), (116, '08-1041-2008'), (117, '51-1686-2015'), (118, '08-4801-2019'), (119, '32-0211-2020'), (120, '12-1649-2016'), (121, '12-3281-2016'), (122, '09-4888-2018'), (123, '34-2262-2019'), (124, '32-2905-2020'), (125, '08-2433-2020'), (126, '32-3920-2020'), (127, '11-0613-2018'), (128, '13-5031-2018'), (129, '05-3530-2017'), (130, '10-0809-2019'), (131, '32-3266-1989'), (132, '11-4288-2018'), (133, '51-1940-2015'), (134, '34-0315-2018'), (135, '12-0508-2019'), (136, '08-3010-2020'), (137, '12-4669-2017'), (138, '11-0161-2017'), (139, '32-2569-2020'), (140, '51-5151-2011'), (141, '32-4037-2019'), (142, '32-0214-2020'), (143, '11-3020-2014'), (144, '56-4906-2018'), (145, '05-1138-2019'), (146, '08-0791-2020'), (147, '08-3912-2020'), (148, '51-3422-2019'), (149, '11-0229-2017'), (150, '20-0242-2018'), (151, '09-2276-2020'), (152, '12-2483-2018'), (153, '18-4294-2004'), (154, '56-0153-2019'), (155, '11-0050-2018'), (156, '08-0957-2020'), (157, '11-3953-2014'), (158, '11-5794-2016'), (159, '09-1089-2020'), (160, '34-1600-2019'), (161, '08-4373-2018'), (162, '09-0226-2020'), (163, '11-4677-2019'), (164, '11-5602-2015'), (165, '05-3927-2018'), (166, '13-5385-2018'), (167, '67-0174-2019'), (168, '12-5391-2018'), (169, '32-3051-2020'), (170, '13-4242-2018'), (171, '56-4669-2014'), (172, '05-0871-2018'), (173, '08-1057-2020'), (174, '51-5439-2017'), (175, '51-3163-2019'), (176, '31-2651-2019'), (177, '11-3362-2018'), (178, '05-2723-2018'), (179, '34-2232-2018'), (180, '31-4513-2019'), (181, '56-0664-2019'), (182, '67-1747-2018'), (183, '31-3727-2019'), (184, '05-1291-2019'), (185, '05-1245-2018'), (186, '11-1323-2019'), (187, '34-0182-2014'), (188, '34-1931-2018'), (189, '51-3229-2014'), (190, '11-3971-2019'), (191, '32-2025-2019'), (192, '56-2990-2019'), (193, '11-2695-2018'), (194, '31-4512-2019'), (195, '05-4249-2018'), (196, '12-2096-2018'), (197, '51-5171-2016'), (198, '32-1051-2020'), (199, '34-4840-2019'), (200, '32-1860-2018'), (201, '32-2561-2020'), (202, '51-1804-2018'), (203, '32-2547-2020'), (204, '11-0012-2018'), (205, '05-1388-2018'), (206, '11-0162-2017'), (207, '31-4514-2019'), (208, '32-1731-2020'), (209, '05-1603-2018'), (210, '12-0370-2018'), (211, '51-3943-2000'), (212, '20-1037-2019'), (213, '31-5196-2019'), (214, '32-1767-2020'), (215, '32-1751-2020'), (216, '11-1716-2019'), (217, '11-0692-2018'), (218, '11-0834-2018'), (219, '31-1924-2018'), (220, '13-5766-2018'), (221, '32-3415-2019'), (222, '11-1195-2018'), (223, '09-4545-2019'), (224, '31-4272-2019'), (225, '31-4796-2019'), (226, '11-1063-2018'), (227, '31-4443-2019'), (228, '12-1087-2018'), (229, '34-5690-2018'), (230, '34-1452-2018'), (231, '31-4562-2019'), (232, '31-4318-2019'), (233, '31-4930-2019'), (234, '12-1213-2019'), (235, '09-5120-2019'), (236, '31-4604-2019'), (237, '31-4286-2019'), (238, '10-0107-2019'), (239, '34-4661-2018'), (240, '67-1236-2018'), (241, '31-4536-2019'), (242, '12-1674-2018'), (243, '11-0833-2018'), (244, '10-0106-2019'), (245, '12-0950-2012'), (246, '31-1258-2019'), (247, '20-2260-2019'), (248, '12-3863-2019'), (249, '05-3564-2018'), (250, '31-5175-2019'), (251, '67-0357-2018'), (252, '67-1677-2018'), (253, '12-5010-2018'), (254, '67-1286-2019'), (255, '51-1301-2019'), (256, '51-1968-2019'), (257, '12-1188-2018'), (258, '09-1824-2020'), (259, '51-0707-2018'), (260, '11-3335-2018'), (261, '11-4424-2018'), (262, '56-1141-2019'), (263, '05-2222-2018'), (264, '09-2835-2020'), (265, '67-0178-2018'), (266, '13-1490-2018'), (267, '51-2188-2019'), (268, '31-0461-2020'), (269, '67-1323-2018'), (270, '51-0825-2019'), (271, '67-0574-2018'), (272, '09-4788-2018'), (273, '05-2924-2019'), (274, '05-0176-2018'), (275, '11-1329-2018'), (276, '08-2458-2020'), (277, '51-0932-2019'), (278, '51-1209-2019'), (279, '32-2877-2020'), (280, '32-2464-2020'), (281, '05-0445-2019'), (282, '32-1947-2020'), (283, '13-0142-2018'), (284, '11-4172-2018'), (285, '32-1210-2020'), (286, '32-2164-2020'), (287, '32-1363-2020'), (288, '13-0496-2018'), (289, '32-1817-2020'), (290, '34-4124-2019'), (291, '32-1149-2020'), (292, '32-1113-2020'), (293, '32-1545-2020'), (294, '32-1596-2020'), (295, '31-4240-2019'), (296, '13-0158-2018'), (297, '05-2706-2019'), (298, '09-2320-2020'), (299, '13-1009-2018'), (300, '05-1409-2019'), (301, '67-0625-2019'), (302, '31-4229-2019'), (303, '32-2859-2020'), (304, '32-2858-2020'), (305, '32-1358-2020'), (306, '32-1423-2020'), (307, '32-2269-2020'), (308, '51-1152-2018'), (309, '31-1666-2020'), (310, '13-1008-2018'), (311, '32-2060-2020'), (312, '11-2045-2018'), (313, '32-2541-2020'), (314, '34-4052-2018'), (315, '32-1294-2020'), (316, '34-0062-2019'), (317, '32-1744-2020'), (318, '51-0061-2018'), (319, '51-0851-2018'), (320, '05-3565-2017'), (321, '32-0327-2020'), (322, '51-2989-2019'), (323, '34-2050-2008'), (324, '32-1237-2020'), (325, '08-6200-2013'), (326, '05-1253-2018'), (327, '51-0829-2018'), (328, '13-2687-2009'), (329, '51-2280-2019'), (330, '32-1235-2020'), (331, '12-1604-2018'), (332, '31-4332-2019'), (333, '31-3923-2019'), (334, '51-0943-2018'), (335, '31-1316-2020'), (336, '32-1738-2020'), (337, '08-3376-2020'), (338, '05-1320-2016'), (339, '32-3708-2020'), (340, '10-3160-2018'), (341, '32-3191-2020'), (342, '51-0868-2018'), (343, '34-4137-2018'), (344, '32-3359-2020'), (345, '31-4692-2019'), (346, '31-0910-2017'), (347, '13-2443-2019'), (348, '32-4053-2020'), (349, '05-1350-2019'), (350, '12-1150-2018'), (351, '13-0894-2018'), (352, '32-3335-2020'), (353, '31-4854-2019'), (354, '31-6883-2014'), (355, '67-3431-2018'), (356, '51-5436-2013'), (357, '31-4393-2019'), (358, '05-0667-2018'), (359, '32-3373-2020'), (360, '34-5498-2008'), (361, '13-5433-2016'), (362, '32-3155-2020'), (363, '12-0163-2018'), (364, '32-1440-2020'), (365, '67-0455-2019'), (366, '05-0865-2019'), (367, '31-0848-2019'), (368, '51-5294-2018'), (369, '32-3277-2020'), (370, '11-0432-2018'), (371, '32-1037-2020'), (372, '08-3018-2019'), (373, '32-2612-2020'), (374, '12-2142-2018'), (375, '12-1025-2018'), (376, '51-4836-2018'), (377, '12-0232-2018'), (378, '51-4804-2017'), (379, '08-3309-2020'), (380, '51-0060-2019'), (381, '08-2596-2004'), (382, '12-0656-2018'), (383, '67-0869-2018'), (384, '13-3618-2018'), (385, '05-0984-2018'), (386, '32-1857-2020'), (387, '67-1389-2018'), (388, '11-5907-2016'), (389, '12-1997-2018'), (390, '67-1920-2018'), (391, '09-3096-2020'), (392, '51-4929-2018'), (393, '67-2217-2018'), (394, '51-3478-2019'), (395, '32-3193-2020'), (396, '31-2592-2019'), (397, '32-3293-2020'), (398, '08-2391-2020'), (399, '12-2984-2018'), (400, '56-0502-2018'), (401, '11-2464-2019'), (402, '08-1768-2020'), (403, '51-1348-2019'), (404, '11-1373-2018'), (405, '08-1234-2020'), (406, '51-0013-2019'), (407, '51-1244-2019'), (408, '12-2787-2018'), (409, '08-2641-2019'), (410, '12-5319-2018'), (411, '32-3311-2020'), (412, '51-4151-2019'), (413, '32-1302-2020'), (414, '12-2497-2018'), (415, '05-1074-2018'), (416, '05-0743-2018'), (417, '31-2465-2019'), (418, '32-2250-2019'), (419, '11-4588-2018'), (420, '67-1443-2018'), (421, '32-4738-2017'), (422, '12-2447-2018'), (423, '40-2504-2019'), (424, '05-3287-2018'), (425, '13-3240-2018'), (426, '12-2449-2018'), (427, '12-4281-2011'), (428, '34-1446-2018'), (429, '67-1777-2018'), (430, '12-0114-2018'), (431, '67-1803-2018'), (432, '12-5535-2018'), (433, '09-4278-2016'), (434, '11-0316-2018'), 
--(435, '08-2632-2020'), (436, '13-2484-2018'), (437, '34-1237-2016'), (438, '11-5194-2018'), (439, '51-2119-2018'), (440, '08-1955-2020'), (441, '08-2272-2020'), (442, '13-4738-2018'), (443, '08-1480-2020'), (444, '51-4223-2012'), (445, '08-3204-2020'), (446, '56-4752-2014'), (447, '32-1370-2020'), (448, '08-1883-2020'), (449, '32-4163-2012'), (450, '67-5458-2017'), (451, '67-5457-2017'), (452, '32-1166-2020'), (453, '34-4703-2018'), (454, '11-4221-2018'), (455, '32-1183-2020'), (456, '13-4683-2018'), (457, '32-4312-2019'), (458, '51-4764-2018'), (459, '51-2103-2019'), (460, '13-5099-2018'), (461, '08-2256-2020'), (462, '32-2165-2020'), (463, '12-2591-2018'), (464, '08-4802-2019'), (465, '51-1879-2019'), (466, '12-4821-2018'), (467, '32-5244-2012'), (468, '12-2101-2018'), (469, '34-4370-2019'), (470, '15-4898-2019'), (471, '15-2352-2019'), (472, '15-0326-2019'), (473, '15-0226-2019'), (474, '15-5044-2018'), (475, '15-0572-2018'), (476, '15-4897-2019'), (477, '15-4849-2019'), (478, '15-0552-2019'), (479, '15-5127-2018'), (480, '15-5698-2018'), (481, '15-2124-2012'), (482, '15-4298-2019'), (483, '15-0152-2018')

select numero, per_codigo, carnet, ins_codigo 'inscribio_123',
isnull((
	select top 1 dmo_codigo from alumnos_$20_descuento_BORRAME
	inner join ra_per_personas on carnet = per_carnet
	inner join col_mov_movimientos on mov_codper = per.per_codigo and mov_codcil = 123
	inner join col_dmo_det_mov on dmo_codmov = mov_codigo
	inner join col_tmo_tipo_movimiento on dmo_codtmo = tmo_codigo
	where dmo_codtmo = 1006 --T-02 Transferencia de Pago - Arancel.  
	--and numero in (84,203,363,456,457,460)
), 0) 'ya_se_aplico_descuento',
(
	select max(n) + 1 from (
		select distinct per_codigo, per_carnet, tmo.tmo_arancel,
		tmo.tmo_codigo, case substring(tmo.tmo_descripcion,1,1) when 'M' then '0' else substring(tmo.tmo_descripcion,1,1) end n, tmo.tmo_descripcion,
		case substring(tmo.tmo_arancel,1,1)
		when 'C' then 'U'
		when 'S' then 'U'
		else substring(tmo.tmo_arancel,1,1) end tipo, mov_fecha_real_pago 
		from col_mov_movimientos
		join col_dmo_det_mov on dmo_codmov=mov_codigo
		join ra_per_personas on per_codigo=mov_codper
		join ra_ins_inscripcion on ins_codper=per_codigo
		join col_tmo_tipo_movimiento as tmo on dmo_codtmo = tmo.tmo_codigo
		join vst_aranceles_x_evaluacion as v on v.are_codtmo = tmo.tmo_codigo
		where dmo_codcil = 123 and per_tipo='U' and mov_estado <> 'A'
		and are_tipo = 'PREGRADO' and mov_codper = per.per_codigo
	) t 
) 'aplica_descuento_a_cuota'
from alumnos_$20_descuento_BORRAME
inner join ra_per_personas as per on carnet = per_carnet
left join Inscripcion.dbo.ra_ins_inscripcion on ins_codper = per_codigo and ins_codcil = 123
order by numero



--select * from alumnos_$20_descuento_BORRAME
--inner join ra_per_personas on carnet = per_carnet
--inner join col_mov_movimientos on mov_codper = per_codigo and mov_codcil = 123
--inner join col_dmo_det_mov on dmo_codmov = mov_codigo
--inner join col_tmo_tipo_movimiento on dmo_codtmo = tmo_codigo
--where --dmo_codtmo = 1006 --T-02 Transferencia de Pago - Arancel.  
----and 
--numero in (84,203,363,456,457,460)
--order by numero
--select * from col_mov_movimientos
--inner join col_dmo_det_mov on dmo_codmov = mov_codigo
--where mov_codper = 217543 and mov_codcil = 123
--select max(n) + 1 from (
--	select distinct per_codigo, per_carnet, tmo.tmo_arancel,
--	tmo.tmo_codigo, case substring(tmo.tmo_descripcion,1,1) when 'M' then '0' else substring(tmo.tmo_descripcion,1,1) end n, tmo.tmo_descripcion,
--	case substring(tmo.tmo_arancel,1,1)
--	when 'C' then 'U'
--	when 'S' then 'U'
--	else substring(tmo.tmo_arancel,1,1) end tipo, mov_fecha_real_pago 
--	from col_mov_movimientos
--	join col_dmo_det_mov on dmo_codmov=mov_codigo
--	join ra_per_personas on per_codigo=mov_codper
--	join ra_ins_inscripcion on ins_codper=per_codigo
--	join col_tmo_tipo_movimiento as tmo on dmo_codtmo = tmo.tmo_codigo
--	join vst_aranceles_x_evaluacion as v on v.are_codtmo = tmo.tmo_codigo
--	where dmo_codcil = 123 and per_tipo='U' and mov_estado <> 'A'
--	and are_tipo = 'PREGRADO' and mov_codper = 219738
--) t

select * from col_tipmen_tipo_mensualidad
--insert into col_tipmen_tipo_mensualidad (tipmen_tipo, tipmen_estado, tipmen_coddtde, tipmen_codvac)
--values ('Descuento $20 en una mensualidad por certificación ($63)', 1, 1, 1)

--insert into col_tpmenara_tipo_mensualidad_aranceles (tpmenara_arancel, tpmenara_monto_pagar, 
--tpmenara_arancel_descuento, tpmenara_monto_arancel_descuento, tpmenara_codtipmen, tpmenara_monto_descuento, tpmenara_valor_mora)
--select tpmenara_arancel, case tpmenara_monto_pagar when 80 then 80 else 63 -20 end, 
--case tpmenara_arancel_descuento when '0' then '0' else 'T-02' end, 
--case tpmenara_monto_arancel_descuento when 0.00 then 0.00 else 20.0 end , 
--29, 0, 0
--from col_tpmenara_tipo_mensualidad_aranceles where tpmenara_codtipmen = 2

declare @tbl_cuota_tpmenara as table (cuota int, codtpmenara int)
insert into @tbl_cuota_tpmenara
select row_number() over(order by tpmenara_codigo) - 1 cuota, tpmenara_codigo from col_tpmenara_tipo_mensualidad_aranceles where tpmenara_codtipmen = 29
--select * from @tbl_cuota_tpmenara

--INSERTANDO LA DATA
declare @numero int, @codper int, @carnet varchar (14), @inscribio_123 int, @ya_se_aplico_descuento int, @aplica_descuento_a_cuota int
declare m_cursor cursor 
for
	select numero, per_codigo, carnet, ins_codigo 'inscribio_123',
	isnull((
		select top 1 dmo_codigo from alumnos_$20_descuento_BORRAME
		inner join ra_per_personas on carnet = per_carnet
		inner join col_mov_movimientos on mov_codper = per.per_codigo and mov_codcil = 123
		inner join col_dmo_det_mov on dmo_codmov = mov_codigo
		inner join col_tmo_tipo_movimiento on dmo_codtmo = tmo_codigo
		where dmo_codtmo = 1006 --T-02 Transferencia de Pago - Arancel.  
		--and numero in (84,203,363,456,457,460)
	), 0) 'ya_se_aplico_descuento',
	(
		select max(n) + 1 from (
			select distinct per_codigo, per_carnet, tmo.tmo_arancel,
			tmo.tmo_codigo, case substring(tmo.tmo_descripcion,1,1) when 'M' then '0' else substring(tmo.tmo_descripcion,1,1) end n, tmo.tmo_descripcion,
			case substring(tmo.tmo_arancel,1,1)
			when 'C' then 'U'
			when 'S' then 'U'
			else substring(tmo.tmo_arancel,1,1) end tipo, mov_fecha_real_pago 
			from col_mov_movimientos
			join col_dmo_det_mov on dmo_codmov=mov_codigo
			join ra_per_personas on per_codigo=mov_codper
			join ra_ins_inscripcion on ins_codper=per_codigo
			join col_tmo_tipo_movimiento as tmo on dmo_codtmo = tmo.tmo_codigo
			join vst_aranceles_x_evaluacion as v on v.are_codtmo = tmo.tmo_codigo
			where dmo_codcil = 123 and per_tipo='U' and mov_estado <> 'A'
			and are_tipo = 'PREGRADO' and mov_codper = per.per_codigo
		) t 
	) 'aplica_descuento_a_cuota'
	from alumnos_$20_descuento_BORRAME
	inner join ra_per_personas as per on carnet = per_carnet
	left join dbo.ra_ins_inscripcion on ins_codper = per_codigo and ins_codcil = 123
	--where numero = 370
	order by numero
                
open m_cursor 
 
fetch next from m_cursor into @numero, @codper, @carnet, @inscribio_123, @ya_se_aplico_descuento, @aplica_descuento_a_cuota
while @@FETCH_STATUS = 0 
begin
    if (isnull(@inscribio_123, 0) <> 0 and @ya_se_aplico_descuento = 0 and @aplica_descuento_a_cuota <= 6
		and not exists (select 1 from col_detmen_detalle_tipo_mensualidad  where detmen_codcil = 123 and detmen_codper = @codper)
		)
	begin
		--select codtpmenara from @tbl_cuota_tpmenara where cuota = @aplica_descuento_a_cuota
		exec dbo.tal_GeneraDataTalonario_alumnos_tipo_mensualidad_especial 2, 1, 123, @codper --elimina de detmen
	
		insert into col_detmen_detalle_tipo_mensualidad (detmen_codper, detmen_codtpmenara, detmen_codcil, detmen_coduser, detmen_estado)
		values (@codper, (select codtpmenara from @tbl_cuota_tpmenara where cuota = @aplica_descuento_a_cuota), 123, 378, 1)

		exec dbo.tal_GeneraDataTalonario_alumnos_tipo_mensualidad_especial 1, 1, 123, @codper --crea data especial
	end
	
    fetch next from m_cursor into @numero, @codper, @carnet, @inscribio_123, @ya_se_aplico_descuento, @aplica_descuento_a_cuota
end      
close m_cursor  
deallocate m_cursor


--select * from col_mov_movimientos 
--inner join col_dmo_det_mov on dmo_codmov = mov_codigo
--where mov_codigo = 6349822



select distinct numero, per_carnet, isnull((
		select top 1 dmo_codigo from alumnos_$20_descuento_BORRAME
		inner join ra_per_personas on carnet = per_carnet
		inner join col_mov_movimientos on mov_codper = per.per_codigo and mov_codcil = 123
		inner join col_dmo_det_mov on dmo_codmov = mov_codigo
		inner join col_tmo_tipo_movimiento on dmo_codtmo = tmo_codigo
		where dmo_codtmo = 1006 --T-02 Transferencia de Pago - Arancel.  
		--and numero in (84,203,363,456,457,460)
	), 0) 'ya_se_aplico_descuento'
from alumnos_$20_descuento_BORRAME
inner join ra_per_personas as per on carnet = per_carnet
inner join col_detmen_detalle_tipo_mensualidad on detmen_codper = per_codigo
where detmen_codcil = 123