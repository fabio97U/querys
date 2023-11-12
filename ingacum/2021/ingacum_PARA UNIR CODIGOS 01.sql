select * from plan_ingacum where anio = 2022
--and nombre like '%isleñ%'
and codigoingreso = '01'
and nit in ('0101-010179-101-6', '0203-131189-101-4', '0307-270684-102-6', '0501-250196-101-5', '0515-060585-101-0', '0605-060494-101-5', '0607-011092-102-0', '0607-060590-101-8', '0607-130888-102-0', '0607-250986-103-2', '0608-060286-101-0', '0608-280297-115-8', '0610-280155-001-4', '0614-010591-123-6', '0614-010693-109-5', '0614-011100-152-7', '0614-020596-128-1', '0614-050179-106-5', '0614-060797-133-0', '0614-071292-121-6', '0614-090896-117-8', '0614-130987-117-5', '0614-140795-152-7', '0614-160887-109-2', '0614-181290-114-6', '0614-190589-111-6', '0614-201191-156-1', '0614-230277-116-3', '0614-230386-120-4', '0614-230484-115-0', '0614-260486-107-2', '0614-280282-133-7', '0614-300593-141-7', '0614-300886-147-9', '0614-310791-114-3', '0617-090288-101-2', '0619-211078-102-2', '0619-220890-101-8', '0702-241290-101-0', '0710-160794-101-3', '0803-240387-101-8', '0806-280189-101-7', '0815-260989-101-0', '0817-070693-101-7', '0822-100890-101-0', '0905-251085-101-6', '1217-180996-104-9', '1218-111183-101-7', '1408-230389-103-9', '1418-030873-101-5', '9414-051159-101-0')
--group by nit
--having count(1) > 1
order by codemp

declare @codingacum int = 0
declare @nit varchar(50)--Variables del select
declare m_cursor cursor 
for
	select distinct nit from plan_ingacum 
	where anio = 2021 and codigoingreso = '01'
		and nit in ('0101-010179-101-6', '0203-131189-101-4', '0307-270684-102-6', '0501-250196-101-5', '0515-060585-101-0', '0605-060494-101-5', '0607-011092-102-0', '0607-060590-101-8', '0607-130888-102-0', '0607-250986-103-2', '0608-060286-101-0', '0608-280297-115-8', '0610-280155-001-4', '0614-010591-123-6', '0614-010693-109-5', '0614-011100-152-7', '0614-020596-128-1', '0614-050179-106-5', '0614-060797-133-0', '0614-071292-121-6', '0614-090896-117-8', '0614-130987-117-5', '0614-140795-152-7', '0614-160887-109-2', '0614-181290-114-6', '0614-190589-111-6', '0614-201191-156-1', '0614-230277-116-3', '0614-230386-120-4', '0614-230484-115-0', '0614-260486-107-2', '0614-280282-133-7', '0614-300593-141-7', '0614-300886-147-9', '0614-310791-114-3', '0617-090288-101-2', '0619-211078-102-2', '0619-220890-101-8', '0702-241290-101-0', '0710-160794-101-3', '0803-240387-101-8', '0806-280189-101-7', '0815-260989-101-0', '0817-070693-101-7', '0822-100890-101-0', '0905-251085-101-6', '1217-180996-104-9', '1218-111183-101-7', '1408-230389-103-9', '1418-030873-101-5', '9414-051159-101-0')
	--order by codemp        
open m_cursor
 
fetch next from m_cursor into @nit
while @@FETCH_STATUS = 0 
begin
	print '@nit: ' + cast(@nit as varchar(50))
		set @codingacum = 0

		insert into plan_ingacum 
		(uniNombre, codreg, planilla, codemp, nit, nombre, salario, aguinaldo, vacacion, indemnizacion, bonificacion, renta, isss, afp, ipsfa, 
		ivm, anio, codtpl, mes, pla_codtpl, pla_codigo, pla_frecuencia, aguinaldog, otros, codigoingreso, excedente, otrosgrava, 
		montogravado1, renta1, afp1, montogravado2, renta2, afp2, montogravado3, renta3, afp3, montogravado4, renta4, afp4, 
		montogravado5, renta5, afp5, montogravado6, renta6, afp6, montogravado7, renta7, afp7, montogravado8, renta8, afp8, 
		montogravado9, renta9, afp9, montogravado10, renta10, afp10, montogravado11, renta11, afp11, montogravado12, renta12, afp12, fechahora)
		select 
		uniNombre, codreg, planilla, codemp, nit, nombre, 
		sum(isnull(salario, 0)) salario, sum(isnull(aguinaldo, 0)) aguinaldo, sum(isnull(vacacion, 0)) vacacion, sum(isnull(indemnizacion, 0)) indemnizacion, 
		sum(isnull(bonificacion, 0)) bonificacion, sum(isnull(renta, 0)) renta, sum(isnull(isss, 0)) isss, 
		sum(isnull(afp, 0)) afp, sum(isnull(ipsfa, 0)) ipsfa, sum(isnull(ivm, 0)) ivm, anio, codtpl, 
		mes, pla_codtpl, pla_codigo, pla_frecuencia, 
		sum(isnull(aguinaldog, 0)) aguinaldog, sum(isnull(otros, 0)) otros, codigoingreso, excedente, otrosgrava, 
		sum(isnull(montogravado1, 0)) montogravado1, sum(isnull(renta1, 0)) renta1, sum(isnull(afp1, 0)) afp1, 
		sum(isnull(montogravado2, 0)) montogravado2, sum(isnull(renta2, 0)) renta2, sum(isnull(afp2, 0)) afp2, 
		sum(isnull(montogravado3, 0)) montogravado3, sum(isnull(renta3, 0)) renta3, sum(isnull(afp3, 0)) afp3, 
		sum(isnull(montogravado4, 0)) montogravado4, sum(isnull(renta4, 0)) renta4, sum(isnull(afp4, 0)) afp4, 
		sum(isnull(montogravado5, 0)) montogravado5, sum(isnull(renta5, 0)) renta5, sum(isnull(afp5, 0)) afp5, 
		sum(isnull(montogravado6, 0)) montogravado6, sum(isnull(renta6, 0)) renta6, sum(isnull(afp6, 0)) afp6, 
		sum(isnull(montogravado7, 0)) montogravado7, sum(isnull(renta7, 0)) renta7, sum(isnull(afp7, 0)) afp7, 
		sum(isnull(montogravado8, 0)) montogravado8, sum(isnull(renta8, 0)) renta8, sum(isnull(afp8, 0)) afp8, 
		sum(isnull(montogravado9, 0)) montogravado9, sum(isnull(renta9, 0)) renta9, sum(isnull(afp9, 0)) afp9, 
		sum(isnull(montogravado10, 0)) montogravado10, sum(isnull(renta10, 0)) renta10, sum(isnull(afp10, 0)) afp10, 
		sum(isnull(montogravado11, 0)) montogravado11, sum(isnull(renta11, 0)) renta11, sum(isnull(afp11, 0)) afp11, 
		sum(isnull(montogravado12, 0)) montogravado12, sum(isnull(renta12, 0)) renta12, sum(isnull(afp12, 0)) afp12, getdate()
		from plan_ingacum where anio = 2021 
		and nit = @nit
		and codigoingreso = '01'
		--and nit in ('0101-010179-101-6', '0203-131189-101-4', '0307-270684-102-6', '0501-250196-101-5', '0515-060585-101-0', '0605-060494-101-5', '0607-011092-102-0', '0607-060590-101-8', '0607-130888-102-0', '0607-250986-103-2', '0608-060286-101-0', '0608-280297-115-8', '0610-280155-001-4', '0614-010591-123-6', '0614-010693-109-5', '0614-011100-152-7', '0614-020596-128-1', '0614-050179-106-5', '0614-060797-133-0', '0614-071292-121-6', '0614-090896-117-8', '0614-130987-117-5', '0614-140795-152-7', '0614-160887-109-2', '0614-181290-114-6', '0614-190589-111-6', '0614-201191-156-1', '0614-230277-116-3', '0614-230386-120-4', '0614-230484-115-0', '0614-260486-107-2', '0614-280282-133-7', '0614-300593-141-7', '0614-300886-147-9', '0614-310791-114-3', '0617-090288-101-2', '0619-211078-102-2', '0619-220890-101-8', '0702-241290-101-0', '0710-160794-101-3', '0803-240387-101-8', '0806-280189-101-7', '0815-260989-101-0', '0817-070693-101-7', '0822-100890-101-0', '0905-251085-101-6', '1217-180996-104-9', '1218-111183-101-7', '1408-230389-103-9', '1418-030873-101-5', '9414-051159-101-0')
		--group by nit
		--having count(1) > 1
		group by uniNombre, codreg, planilla, codemp, nit, nombre, anio, codtpl, mes, pla_codtpl, pla_codigo, pla_frecuencia, codigoingreso, excedente, otrosgrava
		order by codemp

		select @codingacum = SCOPE_IDENTITY()
		select @codingacum
		delete
		from plan_ingacum where anio = 2021 
		and nit = @nit
		and codigoingreso = '01'
		and plan_ingcodigo not in (@codingacum)

    fetch next from m_cursor into @nit
end      
close m_cursor  
deallocate m_cursor