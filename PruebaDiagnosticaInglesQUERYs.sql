
select top 10 * from eeg_pre_pregunta
select top 10 * from eeg_cla_clave
--161960 31-1200-2013 
--sp_help eeg_cla_clave
--select * from eeg_cla_clave where cla_codcar in(37, 38, 39)
select * from eeg_cla_clave where cla_codcar = 31
--insert into eeg_cla_clave (cla_codcar, cla_codide, cla_codcil, cla_indicaciones, cla_fecha_crea, cla_niveles) values (31, 'A', 119, 'Examen diagnostico pre especialización escuela de idioma utilizado desde el ciclo I-2019', getdate(), 1)
select * from eeg_rub_rubro where rub_codcla in (/*41,*/ 82)
--insert into eeg_rub_rubro (rub_codcla, rub_rubro, rub_ponderacion, rub_indicaciones, rub_nivel) values (82, 'Grammar', 25, '', 1),(82, 'Lexical And Phonological Terms', 25, '', 2),(82, 'Teaching Approches', 25, '', 3),(82, 'Translation', 25, '', 4)
select * from eeg_pre_pregunta where pre_codrub in (/*41,*/ select rub_codigo from eeg_rub_rubro where rub_codcla in (/*41,*/ 82))

select max(pre_codigo)+13 from eeg_pre_pregunta
/*
insert into eeg_pre_pregunta (pre_codrub, pre_codtre, pre_numero, pre_pregunta, pre_fecha ) values 
(80, 1, '1', 'Think of the structure that could best complete the sentence, then select the option that would be more suitable. <br /><br />I .......... there for six years before moving to Budapest.<br />',  getdate()),
(80, 1, '2', 'Think of the structure that could best complete the sentence, then select the option that would be more suitable. <br /><br />Where (you/fly) if (you/be) a bird?<br />',  getdate()),
(80, 1, '3', 'Think of the structure that could best complete the sentence, then select the option that would be more suitable. <br /><br />Coffee (grow) in Brazil. It (export) to many countries in the world.<br />',  getdate()),
(80, 1, '4', 'Complete the sentences with ... +ing or to + ... .  Then select the structure that would be more suitable. <br /><br />I decided (send) a letter to my friend.<br />',  getdate()),
(80, 1, '5', 'Think of the structure that could best complete the sentence, then select the option that would be more suitable.<br /><br />Shanghai is the .......... city in the world.<br />',  getdate()),
(80, 1, '6', 'Select the appropriate meaning for each underlined clause. <br /><br />It was such a bad film <li>that we walked out.</li><br />',  getdate()),
(80, 1, '7', 'Select the appropriate meaning for each underlined clause. <br /><br />I decided to go and see him <li>since he hadn’t phoned me.</li><br />',  getdate()),
(80, 1, '8', 'Select the appropriate meaning for each underlined clause. <br /><br />I fell asleep in the car <li>because I was so tired.</li><br />',  getdate()),
(80, 1, '9', 'Select the appropriate meaning for each underlined clause. <br /><br /><li>As there was no coffee left</li>, I had a cup of tea.<br />',  getdate()),
(80, 1, '10', 'Select the appropriate meaning for each underlined clause. <br /><br />I won’t speak to him again <li>unless he apologizes</li>.<br />',  getdate()),
(80, 1, '11', 'Select the appropriate meaning for each underlined clause. <br /><br /><li>As long as you can save the money yourself</li>, you can go on the trip.<br />',  getdate()),
(80, 1, '12', 'Select the appropriate meaning for each underlined clause. <br /><br />I walked into town <li>so that I could avoid the traffic.</li><br />',  getdate()),

(81, 1, '13', 'Unhappy, disagree and incorrect include examples of ________.<br /><br />', getdate()),
(81, 1, '14', 'Hole and whole; mail and male; by and buy are examples of ________.<br /><br />', getdate()),
(81, 1, '15', 'Put out; put off; put away are examples of ________.<br /><br />', getdate()),
(81, 1, '16', 'Vehicle – car, bicycle, plane; pet – dog, cat, rabbit; food – bread, pizza, meat are examples of ________.<br /><br />', getdate()),
(81, 1, '17', 'Can’t; don’t; he’s are examples of ________.<br /><br />', getdate()),
(81, 1, '18', 'Fit and feet; fear and fair; track and truck are examples of ________.<br /><br />', getdate()),
(82, 1, '19', 'Based on the class activity, select their respective  teaching approach. <br /><br />I asked groups to design an advertisement for a new type of cereal. While they were working, we looked at some real advertisements together, and the students practiced writing some ‘slogans’.<br />', getdate()),

(82, 1, '20', 'Based on the class activity, select their  respective  teaching approach. <br /><br />I gave the class a series of instructions, for instance, to stand up and turn around, which they followed. Then some students gave me the same instructions.<br />', getdate()),
(82, 1, '21', 'Based on the class activity, select their  respective  teaching approach. <br /><br />I introduced a new structure to the class by showing a set of pictures while I said sentences containing the structure. Then I gave pairs some sentence prompts to complete. Finally, students talked in groups about a similar set of pictures while I monitored their conversations.<br />', getdate()),
(82, 1, '22', 'Based on the class activity, select their respective  teaching approach. <br /><br />I gave the class an authentic text from a magazine about unusual sports. We found lots of useful sports collocations in it and looked in some detail at how the text was written. The students then practiced using some of the new language, orally and in writing.<br />', getdate()),
(83, 1, '23', '<b>English to Spanish</b> <br /><br />A statement in English is presented followed by four statements in Spanish. For each one, select the option that most closely matches the translation into Spanish.<br /><br />The speaker cleared his throat before starting his speech.<br />', getdate()),
(83, 1, '24', '<b>English to Spanish</b> <br /><br />A statement in English is presented followed by four statements in Spanish. For each one, select the option that most closely matches the translation into Spanish.<br /><br />He was told to begin after he had studied the matter thoroughly.<br />', getdate()),
(83, 1, '25', '<b>English to Spanish</b> <br /><br />A statement in English is presented followed by four statements in Spanish. For each one, select the option that most closely matches the translation into Spanish.<br /><br />She was being pressured to make her decision.<br />', getdate()),
(83, 1, '26', '<b>English to Spanish</b> <br /><br />A statement in English is presented followed by four statements in Spanish. For each one, select the option that most closely matches the translation into Spanish.<br /><br />The defendant stated he did not commit the crime.<br />', getdate()),
(83, 1, '27', '<b>English to Spanish</b> <br /><br />A statement in English is presented followed by four statements in Spanish. For each one, select the option that most closely matches the translation into Spanish.<br /><br />The district attorney examined the witnesses.<br />', getdate()),
(83, 1, '28', '<b>Spanish to English</b> <br /><br />A statement in Spanish is presented followed by four statements in English. For each one, select the option that most closely matches the translation into English.<br /><br />Si no fuera por su buena apariencia, nunca lo habrían contratado para administrar el negocio de su familia política.<br />', getdate()),
(83, 1, '29', '<b>Spanish to English</b> <br /><br />A statement in Spanish is presented followed by four statements in English. For each one, select the option that most closely matches the translation into English.<br /><br />El catedrático solía recalcar ciertos temas.<br />', getdate()),
(83, 1, '30', '<b>Spanish to English</b> <br /><br />A statement in Spanish is presented followed by four statements in English. For each one, select the option that most closely matches the translation into English.<br /><br />Al avanzar la jornada de ese día el empezó a sentirse cada vez más débil.<br />', getdate()),
(83, 1, '31', '<b>Spanish to English</b> <br /><br />A statement in Spanish is presented followed by four statements in English. For each one, select the option that most closely matches the translation into English.<br /><br />“Al pan, pan y al vino, vino”.<br />', getdate()),
(83, 1, '32', '<b>Spanish to English</b> <br /><br />A statement in Spanish is presented followed by four statements in English. For each one, select the option that most closely matches the translation into English.<br /><br />Tocaron a la puerta pero no conteste por temor a que me arrestaran.<br />', getdate())
*/

select * from eeg_res_respuesta 
inner join eeg_pre_pregunta on pre_codigo = res_codpre
inner join eeg_rub_rubro on rub_codigo = pre_codrub
where res_codpre in (select pre_codigo from eeg_pre_pregunta where pre_codrub in (/*41,*/ select rub_codigo from eeg_rub_rubro where rub_codcla in (/*41,*/ 82)))
/*
insert into eeg_res_respuesta (res_codpre, res_numero, res_respuesta, res_correcta, res_fecha)
values
(50670,'a','Past simple', 1, getdate()),
(50670,'b','Present simple', 0, getdate()),
(50670,'c','Second conditional', 0, getdate()),
(50671,'a','Past simple', 1, getdate()),
(50671,'b','Present simple', 0, getdate()),
(50671,'c','Second conditional', 1, getdate()),
(50672,'a','Gerunds and infinitives', 0, getdate()),
(50672,'b','Passive ', 1, getdate()),
(50672,'c','Second conditional', 0, getdate()),
(50673,'a','Gerunds and infinitives', 1, getdate()),
(50673,'b','Passive ', 0, getdate()),
(50673,'c','Second conditional', 0, getdate()),
(50674,'a','Superlative', 1, getdate()),
(50674,'b','Present simple', 0, getdate()),
(50674,'c','Second conditional', 0, getdate()),
(50675,'a','Condition', 0, getdate()),
(50675,'b','Reason', 0, getdate()),
(50675,'c','Result', 1, getdate()),
(50676,'a','Condition', 0, getdate()),
(50676,'b','Reason', 1, getdate()),
(50676,'c','Result', 0, getdate()),
(50677,'a','Condition', 0, getdate()),
(50677,'b','Reason', 1, getdate()),
(50677,'c','Result', 0, getdate()),
(50678,'a','Condition', 0, getdate()),
(50678,'b','Reason', 1, getdate()),
(50678,'c','Result', 0, getdate()),
(50679,'a','Condition', 1, getdate()),
(50679,'b','Reason', 0, getdate()),
(50679,'c','Result', 0, getdate()),
(50680,'a','Condition', 1, getdate()),
(50680,'b','Reason', 0, getdate()),
(50680,'c','Result', 0, getdate()),
(50681,'a','Condition', 0, getdate()),
(50681,'b','Reason', 1, getdate()),
(50681,'c','Result', 0, getdate()),

(50682,'a','prefixes.', 1, getdate()),
(50682,'b','informal language.', 0, getdate()),
(50682,'c','synonyms.', 0, getdate()),

(50683,'a','homophones.', 1, getdate()),
(50683,'b','unvoiced sounds.', 0, getdate()),
(50683,'c','false friends.', 0, getdate()),

(50684,'a','antonyms.', 0, getdate()),
(50684,'b','verb patterns.', 0, getdate()),
(50684,'c','multi-word verbs.', 1, getdate()),

(50685,'a','collocations.', 0, getdate()),
(50685,'b','lexical sets.', 1, getdate()),
(50685,'c','collective nouns.', 0, getdate()),

(50686,'a','connected speech.', 0, getdate()),
(50686,'b','weak forms.', 0, getdate()),
(50686,'c','contractions.', 1, getdate()),

(50687,'a','rhymes.', 0, getdate()),
(50687,'b','minimal pairs.', 1, getdate()),
(50687,'c','linking.', 0, getdate()),

(50688,'a','Presentation, Practice and Production (PPP)', 0, getdate()),
(50688,'b','Task-based Learning (TBL)', 1, getdate()),
(50688,'c','Total Physical Response (TPR)', 0, getdate()),
(50688,'c','The Lexical Approach', 0, getdate()),

(50689,'a','Presentation, Practice and Production (PPP)', 0, getdate()),
(50689,'b','Task-based Learning (TBL)', 0, getdate()),
(50689,'c','Total Physical Response (TPR)', 1, getdate()),
(50689,'d','The Lexical Approach', 0, getdate()),

(50690,'a','Presentation, Practice and Production (PPP)', 1, getdate()),
(50690,'b','Task-based Learning (TBL)', 0, getdate()),
(50690,'c','Total Physical Response (TPR)', 0, getdate()),
(50690,'c','The Lexical Approach', 0, getdate()),

(50691,'a','Presentation, Practice and Production (PPP)', 0, getdate()),
(50691,'b','Task-based Learning (TBL)', 0, getdate()),
(50691,'c','Total Physical Response (TPR)', 0, getdate()),
(50691,'c','The Lexical Approach', 1, getdate()),

(50692,'a','El orador carraspeó antes de comenzar a su discurso.', 1, getdate()),
(50692,'b','El orador se aclaró la garganta después de dar comienzo a su discurso.', 0, getdate()),
(50692,'c','El orador limpió su garganta antes de dar comienzo a su discurso.', 0, getdate()),
(50692,'c','El orador aclara la garganta antes de dar comienzo a su discurso.', 0, getdate()),

(50693,'a','Le dijeron que comenzara cuando había estudiado el asunto por todas sus partes.', 0, getdate()),
(50693,'b','Se le dijo que comenzara después de que hubiera estudiado el asunto a fondo.', 1, getdate()),
(50693,'c','Se le dijo que el debería comenzar cuando haya estudiado el asunto en distintas formas.', 0, getdate()),
(50693,'c','Ellos le dijeron a el que comenzara después de haber estudiado el asunto completamente.', 0, getdate()),

(50694,'a','Hacían presión a ella para que decidiera.', 0, getdate()),
(50694,'b','Presionaban a ella para que hiciera su decisión.', 0, getdate()),
(50694,'c','Presión se le ponía para que dijera su decisión.', 0, getdate()),
(50694,'d','Ella fue presionaba para que tomara su decisión.', 1, getdate()),

(50695,'a','El defendiente declaró que él no cometió el delito.', 0, getdate()),
(50695,'b','El acusado declaró que el no hizo crimen.', 0, getdate()),
(50695,'c','El acusado declaró que el no cometió el delito.', 1, getdate()),
(50695,'d','El defendiente declaró que el no cometió el crimen.', 0, getdate()),

(50696,'a','El abogado del distrito examinó a los testigos.', 0, getdate()),
(50696,'b','El fiscal interrogó a los testigos.', 1, getdate()),
(50696,'c','El fiscal le hizo un examen a los testigos.', 0, getdate()),
(50696,'d','El abogado del distrito interrogó a los testigos.', 0, getdate()),

(50697,'a','If it weren’t for his good status, he would never have managed to get hired to run his in-laws’ business.', 0, getdate()),
(50697,'b','If it weren’t for his good looks, he would never have been hired to run his in-laws’ business.', 1, getdate()),
(50697,'c','His good looks managed to help him get hired to run his in-laws’ business.', 0, getdate()),
(50697,'d','He would never use his good looks to manage to run his in-laws’ business.', 0, getdate()),

(50698,'a','The speaker had the habit of repeating certain themes.', 0, getdate()),
(50698,'b','The professor used to emphasize certain topics.', 1, getdate()),
(50698,'c','The professor was accustomed to stressing certain themes.', 0, getdate()),
(50698,'d','The lecturer would dwell on certain themes.', 0, getdate()),

(50699,'a','As the day advanced he felt weaker and weaker.', 0, getdate()),
(50699,'b','With each passing hour of the day he began to feel weak.', 0, getdate()),
(50699,'c','As the day’s work advanced he felt weaker.', 0, getdate()),
(50699,'d','As the day’s work progressed, he began to feel weaker and weaker.', 1, getdate()),

(50700,'a','Bread and wine don’t mix.', 0, getdate()),
(50700,'b','Wine is stronger than bread.', 0, getdate()),
(50700,'c','Call a spade a spade.', 1, getdate()),
(50700,'d','Let them eat cake.', 0, getdate()),

(50701,'a','They knocked at the door but did not answer for fear that they would arrest me.', 0, getdate()),
(50701,'b','There was a knock at the door but I did not answer due to fear of being arrested.', 1, getdate()),
(50701,'c','They knocked at the door but I did not answer it for fear of being arrested.', 0, getdate()),
(50701,'d','There was a knock at the door but did not contest it in fear of being arrested.', 0, getdate())
*/

select * from ra_alc_alumnos_carrera where alc_codper in(select per_codigo from ra_per_personas where per_carnet = '31-0583-2009')
select concat(per_carnet, ' ', per_nombres_apellidos) from ra_per_personas where per_codigo = 181324
go

alter procedure [dbo].[sp_prueba_diagnostica_ingles]
	-- =============================================
	-- Author:      <Fabio>
	-- Create date: <2019-07-11 14:30:00.543>
	-- Description: <Retorna la data de preguntas para la prueba diagnostica de egresados de ingles>
	-- =============================================
	--sp_prueba_diagnostica_ingles 1, 0, 31, 119
	--sp_prueba_diagnostica_ingles 2, 50670, 31, 119
	@opcion int = 0,
	@codpre int = 0,
	@codcar int = 0,--31
	@codcil int = 0--
as
begin
	if @opcion = 1 --Retorna las preguntas
	begin
		select cla_codigo, cla_indicaciones, rub_codigo, rub_rubro, rub_ponderacion, pre_codigo, pre_numero,pre_pregunta/*, res_codigo, res_numero, res_respuesta, res_correcta */from eeg_cla_clave 
		inner join eeg_rub_rubro on rub_codcla = cla_codigo
		inner join eeg_pre_pregunta on pre_codrub = rub_codigo
		--inner join eeg_res_respuesta on res_codpre = pre_codigo
		where cla_codigo in (
		select cla_codigo from eeg_cla_clave where cla_codcar = @codcar and cla_codcil = @codcil
		)
		order by newid()
	end

	if @opcion = 2--Devuelve las opciones de la pregunta @codpre
	begin
		select cla_codigo, cla_indicaciones, rub_codigo, rub_rubro, rub_ponderacion, pre_codigo, pre_numero,pre_pregunta, res_codigo, res_numero, res_respuesta, res_correcta from eeg_cla_clave 
		inner join eeg_rub_rubro on rub_codcla = cla_codigo
		inner join eeg_pre_pregunta on pre_codrub = rub_codigo
		inner join eeg_res_respuesta on res_codpre = pre_codigo
		where cla_codigo in (
		select cla_codigo from eeg_cla_clave where cla_codcar = @codcar and cla_codcil = @codcil
		) and pre_codigo = @codpre
		order by newid()
	end
end

select top 10 * from eeg_ree_resultado_eval where ree_codper  = 161960--in (select ree_codper from eeg_pre_pregunta where pre_codrub in (/*41,*/ 71))
select top 10 * from eeg_dee_detalle_eval where dee_codree = 12852
select top 10 * from eeg_res_respuesta where res_codigo in (select top 10 dee_codres from eeg_dee_detalle_eval where dee_codree = 12852)



ALTER PROCEDURE [dbo].[eeg_insertar_evaluacion] 
	-- =============================================
	-- Author:      <DESCONOCIDO>
	-- Create date: <DESCONOCIDO>
	-- Description: <Inserta las respuesta de las pruebas diagnosticas de egresados>
	-- =============================================
	-- eeg_insertar_evaluacion  1148,93,29,'9,7,8,9,77,88,996,55,44,45,55,44,11,22,33,22,55,44,77,88,99'
	@codper int, 
	@codcil int, 
	@codcla int, 
	@respuestas varchar(600), 
	@comentario varchar(5000)
as
begin
	if not exists(select 1 from eeg_ree_resultado_eval where ree_codcil = @codcil and ree_codper = @codper)
	begin
		declare @sqlres varchar(1000),@key int
		declare @temp_resp table
		(
			codigo int identity(1,1) not null,
			codree int null,
			codpre int null,
			codres int null
		)
		set @sqlres = 'select res_codpre, res_codigo from eeg_res_respuesta join eeg_pre_pregunta on pre_codigo = res_codpre where res_codigo in  ('+@respuestas+')'

		insert into [eeg_ree_resultado_eval] select @codper,@codcil,@codcla,@comentario, getdate()
		SET @key = @@identity

		insert into @temp_resp (codpre,codres)
		exec(@sqlres)

		insert into eeg_dee_detalle_eval(dee_codree,dee_codpre,dee_codres)
		select @key,codpre,codres from @temp_resp

		select 1--Se inserto correctamente, se redirecciona al comprobante
	end
	else
	begin
		select 0--No se inserto porque ya hay un registro del alumno en la prueba, NO HACE NADA
	end
end

ALTER procedure [dbo].[eeg_nota_final] 
	-- =============================================
	-- Author:      <DESCONOCIDO>
	-- Create date: <DESCONOCIDO>
	-- Description: <Genera la nota de la prueba diagnostica segun el @codcil para el alumno @codper>
	-- ============================================= 
	--eeg_nota_final 119, 118592
	@codcil int, 
	@codper int
as
begin
	--OBTENER LOS RESULTADOS DE LA PRUEBA REALIZADA Y MOSTRAR LOS DATOS AL FINAL DE LA PRUEBA.
	declare @total real, @correctas real, @nota numeric(9,1), @porcentaje numeric(9,1),@codcla int,@nivel int,@carne varchar(50),@electiva int

	select  @codcla=ree_codcla from eeg_ree_resultado_eval where ree_codper = @codper and ree_codcil = @codcil
	print '@codcla ' + cast(@codcla as varchar(10))

	select @nivel=rub_nivel from eeg_rub_rubro where rub_codcla = @codcla
	print '@nivel ' + cast(@nivel as varchar(10))

	select @total = count(1) from eeg_pre_pregunta join eeg_rub_rubro on rub_codigo = pre_codrub where rub_codcla = @codcla --and rub_nivel =@nivel --ELIMINADO POR FABIO PORQUE NO TIENE SENTIDO SI SE CONOCE EL @CODCLA, 2019-07-12 15:04:06.173
	print '@total ' + cast(@total as varchar(10))

	select @carne = per_carnet from ra_per_personas where per_codigo=@codper
	print '@carne ' + cast(@carne as varchar(10))

	if substring(@carne,1,2) = '22'--Si es industrial
	begin
		--71: Electiva Técnica de Calidad
		select @electiva = count(1) from eeg_pre_pregunta join eeg_rub_rubro on rub_codigo = pre_codrub where rub_codcla=@codcla--71 --and rub_nivel =@nivel
		set @total=@total+@electiva
	end
	--set @total = 15--TEMPORAL PARA CALCULO DE PROGRAMACION Y TECNCIOS
	select @correctas = count(1) from eeg_res_respuesta 
	join eeg_dee_detalle_eval on res_codigo = dee_codres 
	join eeg_ree_resultado_eval on ree_codigo = dee_codree
	where ree_codcla=@codcla and ree_codcil = @codcil and ree_codper = @codper and res_correcta = 1 --res_correcta = @nivel ESTO FUE QUITADO POR QUE NO TIENE SENTIDO QUE LA RESPUESTA CORRECTA SEA IGUAL QUE EL NIVEL, 2019-07-12 15:04:06.173

	--where ree_codcla=36 and ree_codcil = 93 and ree_codper = 76424 and res_correcta = 1

	set @nota = round((round((@correctas/@total), 2)*100)*0.1, 1)
	set @porcentaje=round(round((@correctas/@total), 2)*100, 0)

	select @nota nota,@porcentaje porcentaje_correctas, 100-@porcentaje porcentaje_incorrectas, @correctas correctas, 
	@total - @correctas incorrectas, @total total, per_carnet + '. '+ per_nombres_apellidos nombres,@nivel nivel
	from ra_per_personas where per_codigo = @codper
end


ALTER procedure [dbo].[web_eeg_seleccionar_clave] 
	-- =============================================
	-- Author:      <DESCONOCIDO>
	-- Create date: <DESCONOCIDO>
	-- Description: <Devuelve el un codcla aleatorio para las pruebas diagnosticas de egresado>
	-- ============================================= 
	@per_carnet varchar(12), 
	@codcil int
as
begin
	declare @cla_codigo int,@car_codigo int
	select @car_codigo=car_codigo from ra_car_carreras where car_identificador = substring(@per_carnet,1,2)

	--Se obtiene la clave de manera aleatoria de las claves activas para la carrera @car_codigo en el ciclo @codcil
	select top 1 @cla_codigo=cla_codigo from eeg_cla_clave
	where cla_codcar = @car_codigo and cla_codcil = @codcil and cla_codigo not in(71,72) --Electiva Técnica de Calidad, Electiva Técnica de Logistica
	order by newid()

	select @cla_codigo
end