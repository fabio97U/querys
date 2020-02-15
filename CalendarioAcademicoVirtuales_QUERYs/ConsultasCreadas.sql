SELECT [caa_codigo], [caa_dias], [caa_hora], CONVERT(VARCHAR,[caa_fecha],103) caa_fecha, [caa_evaluacion], [caa_grupo] 
FROM [web_ra_caa_calendario_acad]

order by caa_grupo asc, caa_evaluacion asc