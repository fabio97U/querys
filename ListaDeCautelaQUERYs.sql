drop table gc_movcau_motivo_cautela
create table gc_movcau_motivo_cautela(
	movcau_codigo int primary key identity(1,1),
	movcau_motivo varchar(255),
	movcau_fecha_crecacion datetime default getdate()
);
insert into gc_movcau_motivo_cautela(movcau_motivo) values('Lavado de dinero'), ('Delitos menores'), ('Delitos mayores');
select * from gc_movcau_motivo_cautela

drop table gc_liscaut_lista_cautela
create table gc_liscaut_lista_cautela(
	liscaut_codigo int primary key identity(1,1),
	liscaut_cod_cli_prov_per varchar(20),
	liscaut_codmovcau int foreign key references gc_movcau_motivo_cautela,
	liscaut_fecha_creacion datetime default getdate(),
	liscaut_nombre_entidad varchar(255),--Almacena el nombre de la entidad que no pertenece a clientes, proveedores ni alumno
	liscaut_codusr int foreign key references adm_usr_usuarios
);
insert into gc_liscaut_lista_cautela(liscaut_cod_cli_prov_per, liscaut_codmovcau, liscaut_codusr, liscaut_nombre_entidad)
values('C_1', 1, 407, ''), ('P_1', 2, 407, ''), ('E_181324', 3, 407, ''), ('L_4', 3, 407, 'Carlos Soriano');

select * from gc_liscaut_lista_cautela;
SELECT @@IDENTITY

select (isnull(max(liscaut_codigo), 0)+1) from gc_liscaut_lista_cautela

select l.liscaut_codigo, l.liscaut_cod_cli_prov_per, movcau_motivo, case SUBSTRING(liscaut_cod_cli_prov_per,1,1) when 'E' then 'Estudiante' when 'C' then 'Cliente' when 'P' then 'Proveedor'  when 'L' then 'N/A' end  'Tipo Entidad' , SUBSTRING(liscaut_cod_cli_prov_per,3,LEN(liscaut_cod_cli_prov_per)) 'Codigo'
,case --SUBSTRING(liscaut_cod_cli_prov_per,1,1) 
when SUBSTRING(liscaut_cod_cli_prov_per,1,1) = 'C' then 
(select cli_nombre from gc_cli_clientes where cli_codigo = SUBSTRING(liscaut_cod_cli_prov_per,3,LEN(liscaut_cod_cli_prov_per)))
when SUBSTRING(liscaut_cod_cli_prov_per,1,1) = 'P' then 
(select prov_nombre_comercial from gc_prov_proveedores where prov_codigo = SUBSTRING(liscaut_cod_cli_prov_per,3,LEN(liscaut_cod_cli_prov_per)))
when SUBSTRING(liscaut_cod_cli_prov_per,1,1) = 'E' then 
(select per_nombres_apellidos from ra_per_personas where per_codigo = SUBSTRING(liscaut_cod_cli_prov_per,3,LEN(liscaut_cod_cli_prov_per)))
when SUBSTRING(liscaut_cod_cli_prov_per,1,1) = 'L' then 
(select liscaut_nombre_entidad from gc_liscaut_lista_cautela where liscaut_codigo = l.liscaut_codigo)
end as 'Entidad'
from gc_liscaut_lista_cautela as l, gc_movcau_motivo_cautela
where liscaut_codmovcau = movcau_codigo 


select liscaut_codigo, liscaut_cod_cli_prov_per, movcau_motivo, SUBSTRING(liscaut_cod_cli_prov_per,1,1) 'Tipo Entidad' , SUBSTRING(liscaut_cod_cli_prov_per,3,LEN(liscaut_cod_cli_prov_per)) 'Codigo'
,case --SUBSTRING(liscaut_cod_cli_prov_per,1,1) 
when SUBSTRING(liscaut_cod_cli_prov_per,1,1) = 'C' then 
(select cli_nombre from gc_cli_clientes where cli_codigo = SUBSTRING(liscaut_cod_cli_prov_per,3,LEN(liscaut_cod_cli_prov_per)))
when SUBSTRING(liscaut_cod_cli_prov_per,1,1) = 'P' then 
(select prov_nombre_comercial from gc_prov_proveedores where prov_codigo = SUBSTRING(liscaut_cod_cli_prov_per,3,LEN(liscaut_cod_cli_prov_per)))
when SUBSTRING(liscaut_cod_cli_prov_per,1,1) = 'E' then 
(select per_nombres_apellidos from ra_per_personas where per_codigo = SUBSTRING(liscaut_cod_cli_prov_per,3,LEN(liscaut_cod_cli_prov_per)))
end as 'Busqueda'
from gc_liscaut_lista_cautela, gc_movcau_motivo_cautela
where liscaut_codmovcau = movcau_codigo and liscaut_cod_cli_prov_per = 

select concat('C_',cli_codigo) 'codigo', concat(cli_nombre,'-', cli_nombre_comercial,'-', tper_persona) 'Busqueda' 
from gc_cli_clientes, gc_tper_tipo_persona where cli_codtper = tper_codigo and cli_codigo not in(select SUBSTRING(liscaut_cod_cli_prov_per,3,LEN(liscaut_cod_cli_prov_per)) from gc_liscaut_lista_cautela where SUBSTRING(liscaut_cod_cli_prov_per,1,1) = 'C')
union all
select concat('P_',prov_codigo), concat(prov_razon_social,'-', prov_nombre_comercial,'-', prov_representante_legal,'-', tper_persona) 'Busqueda' 
from gc_prov_proveedores, gc_tper_tipo_persona where prov_codtper = tper_codigo and prov_codigo not in(select SUBSTRING(liscaut_cod_cli_prov_per,3,LEN(liscaut_cod_cli_prov_per)) from gc_liscaut_lista_cautela where SUBSTRING(liscaut_cod_cli_prov_per,1,1) = 'P')
union all

select distinct concat('E_',per_codigo) 'codigo', concat(per_carnet, ':',ltrim(per_apellidos_nombres)) 
from ra_per_personas, ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras 
where per_estado = 'A' and /*
per_codigo in(select distinct ins_codper from ra_ins_inscripcion where ins_codcil = 119) and */  per_tipo = 'U'and per_codigo = alc_codper and alc_codpla = pla_codigo and pla_codcar = car_codigo 
and ((ltrim(rtrim(per_nombres_apellidos)) like '%' + case when isnull(ltrim(rtrim(' '))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
                                        else ltrim(rtrim(' '))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end ))
and ((ltrim(rtrim(per_carnet)) like '%' + case when isnull(ltrim(rtrim(' '))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then '' 
                                        else ltrim(rtrim(' '))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end ))



			select concat('C_',cli_codigo) 'codigo', concat(cli_nombre,'-', cli_nombre_comercial,'-', tper_persona) 'Busqueda' 
			from gc_cli_clientes, gc_tper_tipo_persona where cli_codtper = tper_codigo union all
			select concat('P_',prov_codigo), concat(prov_razon_social,'-', prov_nombre_comercial,'-', prov_representante_legal,'-', tper_persona) 'Busqueda' 
			from gc_prov_proveedores, gc_tper_tipo_persona where prov_codtper = tper_codigo


select distinct concat ('E_',per_codigo) 'codigo', concat(per_carnet, ':',ltrim(per_apellidos_nombres))  'Busqueda'             
from ra_per_personas, ra_alc_alumnos_carrera, ra_pla_planes, ra_car_carreras              
where per_estado = 'A' and per_tipo = 'U'and per_codigo = alc_codper and alc_codpla = pla_codigo and pla_codcar = car_codigo              
and 
(ltrim(rtrim(per_nombres_apellidos)) like '%' + case when isnull(ltrim(rtrim('Fabio'))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''else ltrim(rtrim('Fabio'))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end
or ltrim(rtrim(per_carnet)) like '%' + case when isnull(ltrim(rtrim('Fabio'))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI, '') = '' then ''else ltrim(rtrim('Fabio'))COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI + '%' end
)

select * from gc_liscaut_lista_cautela
delete from gc_liscaut_lista_cautela where liscaut_codigo = 6

select liscaut_codigo, liscaut_cod_cli_prov_per, movcau_motivo, case SUBSTRING(liscaut_cod_cli_prov_per,1,1) when 'E' then 'Estudiante' when 'C' then 'Cliente' when 'P' then 'Proveedor' end  'Tipo Entidad', SUBSTRING(liscaut_cod_cli_prov_per,3,LEN(liscaut_cod_cli_prov_per)) 'Codigo'
                ,case --SUBSTRING(liscaut_cod_cli_prov_per,1,1) 
                when SUBSTRING(liscaut_cod_cli_prov_per,1,1) = 'C' then 
                (select cli_nombre from gc_cli_clientes where cli_codigo = SUBSTRING(liscaut_cod_cli_prov_per,3,LEN(liscaut_cod_cli_prov_per)))
                when SUBSTRING(liscaut_cod_cli_prov_per,1,1) = 'P' then 
                (select prov_nombre_comercial from gc_prov_proveedores where prov_codigo = SUBSTRING(liscaut_cod_cli_prov_per,3,LEN(liscaut_cod_cli_prov_per)))
                when SUBSTRING(liscaut_cod_cli_prov_per,1,1) = 'E' then 
                (select per_nombres_apellidos from ra_per_personas where per_codigo = SUBSTRING(liscaut_cod_cli_prov_per,3,LEN(liscaut_cod_cli_prov_per)))
                end as 'Entidad', movcau_codigo
                from gc_liscaut_lista_cautela, gc_movcau_motivo_cautela
                where liscaut_codmovcau = movcau_codigo

				select * from gc_liscaut_lista_cautela
				select l.liscaut_codigo, l.liscaut_cod_cli_prov_per, movcau_motivo, case SUBSTRING(liscaut_cod_cli_prov_per,1,1) when 'E' then 'Estudiante' when 'C' then 'Cliente' when 'P' then 'Proveedor'  when 'L' then 'N/A' end  'Tipo Entidad' , SUBSTRING(liscaut_cod_cli_prov_per,3,LEN(liscaut_cod_cli_prov_per)) 'Codigo'
                ,case --SUBSTRING(liscaut_cod_cli_prov_per,1,1) 
                when SUBSTRING(liscaut_cod_cli_prov_per,1,1) = 'C' then 
                (select cli_nombre from gc_cli_clientes where cli_codigo = SUBSTRING(liscaut_cod_cli_prov_per,3,LEN(liscaut_cod_cli_prov_per)))
                when SUBSTRING(liscaut_cod_cli_prov_per,1,1) = 'P' then 
                (select prov_nombre_comercial from gc_prov_proveedores where prov_codigo = SUBSTRING(liscaut_cod_cli_prov_per,3,LEN(liscaut_cod_cli_prov_per)))
                when SUBSTRING(liscaut_cod_cli_prov_per,1,1) = 'E' then 
                (select per_nombres_apellidos from ra_per_personas where per_codigo = SUBSTRING(liscaut_cod_cli_prov_per,3,LEN(liscaut_cod_cli_prov_per)))
                when SUBSTRING(liscaut_cod_cli_prov_per,1,1) = 'L' then 
                (select liscaut_nombre_entidad from gc_liscaut_lista_cautela where liscaut_codigo = l.liscaut_codigo)
                end as 'Entidad', movcau_codigo, liscaut_codmovcau, liscaut_nombre_entidad
                from gc_liscaut_lista_cautela as l, gc_movcau_motivo_cautela
                where liscaut_codmovcau = movcau_codigo

