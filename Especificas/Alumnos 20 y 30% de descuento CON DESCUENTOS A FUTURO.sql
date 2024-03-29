--drop table almdes_BORRAME
--truncate table col_dfal_descuentos_futuro_alumnos

--create table almdes_BORRAME (codper int, cantidad_ciclos int)
--insert into almdes_BORRAME (codper, cantidad_ciclos)
--values
--(59780,5),(59780,6), (65437,5),(65437,6), (75243,5),(75243,6), (79675,5),(79675,6), (84194,4),(84194,5), (84484,4),(84484,5), (88033,5),(88033,6), (91032,5),(91032,6), (95126,4),(95126,5), (99860,5),(99860,6), (100042,5),(100042,6), (100922,4),(100922,5), (102098,5),(102098,6), (103689,5),(103689,6), (105392,5),(105392,6), (106397,4),(106397,5), (109170,5),(109170,6), (110969,4),(110969,5), (134095,5),(134095,6), (134098,5),(134098,6), (138240,5),(138240,6), (139264,5),(139264,6), (141683,5),(141683,6), (144554,5),(144554,6), (144773,5),(144773,6), (151637,5),(151637,6), (153312,5),(153312,6), (153775,5),(153775,6), (159729,5),(159729,6), (161814,5),(161814,6), (163160,5),(163160,6), (165720,5),(165720,6), (166408,5),(166408,6), (168936,5),(168936,6), (171504,5),(171504,6), (171665,5),(171665,6), (171699,5),(171699,6), (173064,5),(173064,6), (174302,5),(174302,6), (175134,5),(175134,6), (175565,5),(175565,6), (178839,5),(178839,6), (180120,5),(180120,6), (180920,5),(180920,6), (181568,4),(181568,5), (181733,4),(181733,5), (181744,5),(181744,6), (182855,4),(182855,5), (183437,5),(183437,6), (185325,5),(185325,6), (186452,4),(186452,5), (186808,5),(186808,6), (188604,5),(188604,6), (188616,5),(188616,6), (189034,4),(189034,5), (189745,4),(189745,5), (191456,5),(191456,6), (191587,4),(191587,5), (193148,4),(193148,5), (193163,5),(193163,6), (195316,5),(195316,6), (195740,5),(195740,6), (195770,5),(195770,6), (195896,5),(195896,6), (197275,5),(197275,6), (197396,5),(197396,6), (197436,5),(197436,6), (197499,4),(197499,5), (198450,5),(198450,6), (198550,5),(198550,6), (198588,5),(198588,6), (198895,5),(198895,6), (198976,5),(198976,6), (199310,5),(199310,6), (199408,5),(199408,6), (199436,5),(199436,6), (199522,5),(199522,6), (199529,5),(199529,6), (199670,5),(199670,6), (199841,5),(199841,6), (200127,5),(200127,6), (200149,5),(200149,6), (200197,5),(200197,6), (200550,5),(200550,6), (201197,5),(201197,6), (201224,5),(201224,6), (201406,5),(201406,6), (201713,5),(201713,6), (203558,5),(203558,6), (203806,5),(203806,6), (203887,5),(203887,6), (204090,4),(204090,5), (204628,5),(204628,6), (204645,5),(204645,6), (23398,3),(23398,4) ,(23398,5),(23398,6), (31112,4),(31112,5) ,(31112,6),(31112,7), (33671,2),(33671,3) ,(33671,4),(33671,5), (35638,1),(35638,2) ,(35638,3),(35638,4),(35638,5), (40343,3),(40343,4) ,(40343,5),(40343,6), (49939,5),(49939,6) ,(49939,7),(49939,8), (76732,3),(76732,4) ,(76732,5),(76732,6), (78576,5),(78576,6) ,(78576,7),(78576,8), (81226,4),(81226,5) ,(81226,6),(81226,7), (93888,4),(93888,5) ,(93888,6),(93888,7), (102744,5),(102744,6) ,(102744,7),(102744,8) 

declare @codper varchar(12), @cantidad_ciclos int, @codtipmen int
declare m_cursor cursor 
for
select a.codper, a.cantidad_ciclos, b.codtipmen from almdes_BORRAME as a
inner join descuentos_borrame as b on a.codper = b.codper
                
open m_cursor 
 
fetch next from m_cursor into @codper, @cantidad_ciclos, @codtipmen
while @@FETCH_STATUS = 0 
begin
	insert into col_dfal_descuentos_futuro_alumnos (dfal_codcild, dfal_codper, dfal_codtipmen, dfal_coduser)
	select @cantidad_ciclos, @codper, @codtipmen, 378-- from ra_cild_ciclos_descuentos where cild_codigo between 1 and @cantidad_ciclos
    fetch next from m_cursor into @codper, @cantidad_ciclos, @codtipmen
end      
close m_cursor  
deallocate m_cursor

--select * from col_dfal_descuentos_futuro_alumnos

se