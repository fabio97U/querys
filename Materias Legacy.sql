-- drop table ra_cill_ciclo_legacy
create table ra_cill_ciclo_legacy (
	--cill_codigo int primary key identity (1, 1),
	cill_codigo char(8) primary key,
	cill_anio varchar(6),
	cill_prefijo char(1),
	cill_numero int,
	cill_orden int,
	--cill_nombre as (concat(cill_prefijo, cill_numero, '-', cill_anio)),
	cill_fecha_creacion datetime default getdate()
)
-- select cill_anio, cill_prefijo, cill_numero from ra_cill_ciclo_legacy
-- select * from ra_cill_ciclo_legacy
insert into ra_cill_ciclo_legacy (cill_anio, cill_prefijo, cill_numero, cill_orden, cill_codigo)
values
('1972', 'I', 1, 1, 'I1-1972'), ('1972', 'I', 2, 3, 'I2-1972'), ('1972', '0', 1, 2, '01-1972'), ('1972', '0', 2, 4, '02-1972'), ('1973', 'I', 1, 1, 'I1-1973'), ('1973', 'I', 2, 3, 'I2-1973'), ('1973', '0', 1, 2, '01-1973'), ('1973', '0', 2, 4, '02-1973'), ('1974', 'I', 1, 1, 'I1-1974'), ('1974', 'I', 2, 3, 'I2-1974'), ('1974', '0', 1, 2, '01-1974'), ('1974', '0', 2, 4, '02-1974'), ('1975', 'I', 1, 1, 'I1-1975'), ('1975', 'I', 2, 3, 'I2-1975'), ('1975', '0', 1, 2, '01-1975'), ('1975', '0', 2, 4, '02-1975'), ('1976', 'I', 1, 1, 'I1-1976'), ('1976', 'I', 2, 3, 'I2-1976'), ('1976', '0', 1, 2, '01-1976'), ('1976', '0', 2, 4, '02-1976'), ('1977', 'I', 1, 1, 'I1-1977'), ('1977', 'I', 2, 3, 'I2-1977'), ('1977', '0', 1, 2, '01-1977'), ('1977', '0', 2, 4, '02-1977'), ('1978', 'I', 1, 1, 'I1-1978'), ('1978', 'I', 2, 3, 'I2-1978'), ('1978', '0', 1, 2, '01-1978'), ('1978', '0', 2, 4, '02-1978'), ('1979', 'I', 1, 1, 'I1-1979'), ('1979', 'I', 2, 3, 'I2-1979'), ('1979', '0', 1, 2, '01-1979'), ('1979', '0', 2, 4, '02-1979'), ('1980', 'I', 1, 1, 'I1-1980'), ('1980', 'I', 2, 3, 'I2-1980'), ('1980', '0', 1, 2, '01-1980'), ('1980', '0', 2, 4, '02-1980'), ('1981', 'I', 1, 1, 'I1-1981'), ('1981', 'I', 2, 3, 'I2-1981'), ('1981', '0', 1, 2, '01-1981'), ('1981', '0', 2, 4, '02-1981'), ('1982', 'I', 1, 1, 'I1-1982'), ('1982', 'I', 2, 3, 'I2-1982'), ('1982', '0', 1, 2, '01-1982'), ('1982', '0', 2, 4, '02-1982'), ('1983', 'I', 1, 1, 'I1-1983'), ('1983', 'I', 2, 3, 'I2-1983'), ('1983', '0', 1, 2, '01-1983'), ('1983', '0', 2, 4, '02-1983'), ('1984', 'I', 1, 1, 'I1-1984'), ('1984', 'I', 2, 3, 'I2-1984'), ('1984', '0', 1, 2, '01-1984'), ('1984', '0', 2, 4, '02-1984'), ('1985', 'I', 1, 1, 'I1-1985'), ('1985', 'I', 2, 3, 'I2-1985'), ('1985', '0', 1, 2, '01-1985'), ('1985', '0', 2, 4, '02-1985'), ('1986', 'I', 1, 1, 'I1-1986'), ('1986', 'I', 2, 3, 'I2-1986'), ('1986', '0', 1, 2, '01-1986'), ('1986', '0', 2, 4, '02-1986'), ('1987', 'I', 1, 1, 'I1-1987'), ('1987', 'I', 2, 3, 'I2-1987'), ('1987', '0', 1, 2, '01-1987'), ('1987', '0', 2, 4, '02-1987'), ('1988', 'I', 1, 1, 'I1-1988'), ('1988', 'I', 2, 3, 'I2-1988'), ('1988', '0', 1, 2, '01-1988'), ('1988', '0', 2, 4, '02-1988'), ('1989', 'I', 1, 1, 'I1-1989'), ('1989', 'I', 2, 3, 'I2-1989'), ('1989', '0', 1, 2, '01-1989'), ('1989', '0', 2, 4, '02-1989'), ('1990', 'I', 1, 1, 'I1-1990'), ('1990', 'I', 2, 3, 'I2-1990'), ('1990', '0', 1, 2, '01-1990'), ('1990', '0', 2, 4, '02-1990'), ('1991', 'I', 1, 1, 'I1-1991'), ('1991', 'I', 2, 3, 'I2-1991'), ('1991', '0', 1, 2, '01-1991'), ('1991', '0', 2, 4, '02-1991'), ('1992', 'I', 1, 1, 'I1-1992'), ('1992', 'I', 2, 3, 'I2-1992'), ('1992', '0', 1, 2, '01-1992'), ('1992', '0', 2, 4, '02-1992'), ('1993', 'I', 1, 1, 'I1-1993'), ('1993', 'I', 2, 3, 'I2-1993'), ('1993', '0', 1, 2, '01-1993'), ('1993', '0', 2, 4, '02-1993'), ('1994', 'I', 1, 1, 'I1-1994'), ('1994', 'I', 2, 3, 'I2-1994'), ('1994', '0', 1, 2, '01-1994'), ('1994', '0', 2, 4, '02-1994'), ('1995', 'I', 1, 1, 'I1-1995'), ('1995', 'I', 2, 3, 'I2-1995'), ('1995', '0', 1, 2, '01-1995'), ('1995', '0', 2, 4, '02-1995'), ('1996', 'I', 1, 1, 'I1-1996'), ('1996', 'I', 2, 3, 'I2-1996'), ('1996', '0', 1, 2, '01-1996'), ('1996', '0', 2, 4, '02-1996'), ('1997', 'I', 1, 1, 'I1-1997'), ('1997', 'I', 2, 3, 'I2-1997'), ('1997', '0', 1, 2, '01-1997'), ('1997', '0', 2, 4, '02-1997'), ('1998', 'I', 1, 1, 'I1-1998'), ('1998', 'I', 2, 3, 'I2-1998'), ('1998', '0', 1, 2, '01-1998'), ('1998', '0', 2, 4, '02-1998'), ('1999', 'I', 1, 1, 'I1-1999'), ('1999', 'I', 2, 3, 'I2-1999'), ('1999', '0', 1, 2, '01-1999'), ('1999', '0', 2, 4, '02-1999'), ('2000', 'I', 1, 1, 'I1-2000'), ('2000', 'I', 2, 3, 'I2-2000'), ('2000', '0', 1, 2, '01-2000'), ('2000', '0', 2, 4, '02-2000')

select * from ra_cill_ciclo_legacy order by cill_anio, cill_orden

-- drop table ra_mccl_materias_cursadas_ciclo_legacy
create table ra_mccl_materias_cursadas_ciclo_legacy (
	mccl_codigo int primary key identity (1, 1),
	mccl_codper int,
	mccl_codmat varchar(50),
	mccl_codcill char(8) foreign key references ra_cill_ciclo_legacy,
	mccl_fecha_creacion datetime default getdate(),
	mccl_codusr_creacion int
)
-- select * from ra_mccl_materias_cursadas_ciclo_legacy

insert into ra_mccl_materias_cursadas_ciclo_legacy (mccl_codper, mccl_codmat, mccl_codcill, mccl_codusr_creacion)
values
(37126, 'GRAS-H', 'I2-1994', 378), (37126, 'FILO-H', 'I2-1994', 378), (37126, 'PSIU-H', 'I1-1994', 378), (37126, 'REPI-H', 'I1-1995', 378), 
(37126, 'INRR-H', 'I1-1995', 378), (37126, 'SOC1-H', 'I2-1995', 378), (37126, 'PROP-H', 'I2-1995', 378), (37126, 'AECO-H', 'I1-1996', 378), 
(37126, 'HGAC-H', 'I1-1996', 378), (37126, 'PUB1-H', 'I2-1996', 378), (37126, 'GERE-H', 'I2-1996', 378)

declare @per_carnet VARCHAR(19) = '34-0514-1994', @mat_codigo varchar(80) = 'GRAS-H', @codcill varchar(80) = 'I1-1999', @codusr int = 378
declare @codper int = 0
select @codper = per_codigo from ra_per_personas where per_carnet = @per_carnet

if exists (select 1 from ra_mccl_materias_cursadas_ciclo_legacy where mccl_codmat = @mat_codigo and mccl_codper = @codper)
begin
	PRINT 'update'
	update ra_mccl_materias_cursadas_ciclo_legacy set mccl_codcill = @codcill where mccl_codmat = @mat_codigo and mccl_codper = @codper
end
else
begin
	print 'insert'
	insert into ra_mccl_materias_cursadas_ciclo_legacy (mccl_codper, mccl_codmat, mccl_codcill, mccl_codusr_creacion) 
	values (@codper, @mat_codigo, @codcill, @codusr)
end