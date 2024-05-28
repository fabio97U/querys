--Veronica Sarai Herrera Coto     -> VSHC.2024
--(veronica.herrera@utec.edu.sv)

--Christian Geovanny Reyes Vigil  -> CGRV.2024
--(christian.reyes@utec.edu.sv)

declare @codusr_mis_roles int = 374, @codusr int = 0
--select * from adm_usr_usuarios where usr_NOMBRE like '%vaqu%'
--select top 10 emp_email_empresarial, emp_dui, * from pla_emp_empleado where emp_nombres_apellidos like '%evely%' order by emp_codigo desc

declare @usr_nombre varchar(80) = 'Maria Soledad Rodas',
@usr_usuario  varchar(20) = 'evelyn.alfaro',
@usr_password varchar(30) = 'U73c.2024!!',
@usr_codemp int = 4814, 
@codpunven int = NULL

select @codusr = isnull(max(usr_codigo), 0) + 1 from adm_usr_usuarios

insert into adm_usr_usuarios (usr_codigo, usr_usuario, usr_password, usr_nombre, usr_codemp, usr_codcue, usr_codpunven)
select @codusr, @usr_usuario, dbo.dkrpt(@usr_password, 'e'),@usr_nombre,@usr_codemp,0, @codpunven

insert into adm_rus_role_usuarios (rus_role, rus_codusr)
select rus_role, @codusr from adm_rus_role_usuarios where rus_codusr = @codusr_mis_roles



select * from adm_usr_usuarios where usr_codigo = @codusr
select rus_role, @codusr from adm_rus_role_usuarios where rus_codusr = @codusr

SELECT emp_email_empresarial, emp_dui, * from pla_emp_empleado where emp_codigo in (4760, 4759, 4761)


select * from adm_usr_usuarios where usr_codigo = 522