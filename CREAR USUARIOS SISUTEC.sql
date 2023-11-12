declare @codusr_mis_roles int = 461, @codusr int = 0
--select * from adm_usr_usuarios where usr_NOMBRE like '%carlo%'
--select top 10 * from pla_emp_empleado where emp_nombres_apellidos like '%xiom%' order by emp_codigo desc

declare @usr_nombre   varchar(80) = 'Xiomara Raquel Moran Jacinto',
@usr_usuario  varchar(20) = 'xiomara.moran',
@usr_password varchar(30) = 'XRMJ.2023*+',
@usr_codemp int = 4646, 
@codpunven int = null

select @codusr = isnull(max(usr_codigo), 0) + 1 from adm_usr_usuarios

insert into adm_usr_usuarios (usr_codigo, usr_usuario, usr_password, usr_nombre, usr_codemp, usr_codcue, usr_codpunven)
select @codusr, @usr_usuario, dbo.dkrpt(@usr_password, 'e'),@usr_nombre,@usr_codemp,0, @codpunven

insert into adm_rus_role_usuarios (rus_role, rus_codusr)
select rus_role, @codusr from adm_rus_role_usuarios where rus_codusr = @codusr_mis_roles

select * from adm_usr_usuarios where usr_codigo = @codusr
select rus_role, @codusr from adm_rus_role_usuarios where rus_codusr = @codusr
