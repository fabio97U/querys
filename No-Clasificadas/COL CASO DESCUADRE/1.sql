select pad_codigo, pad_codpar,pad_codcuc,cuc_cuenta cuenta,pad_concepto, case when pad_debe = 0 then 'Haber' else 'Debe' end tipo, 
case when pad_debe = 0 then 1 else 0 end tipod, case when pad_haber = 0 then 1 else 0 end tipoh, pad_tipo, convert(money,pad_debe) pad_debe, 
convert(money,pad_haber) pad_haber, isnull(pad_codcco,0) pad_codcco,isnull(cco_nombre, '') centro 
from con_pad_partidas_det 
left outer join con_cuc_cuentas_contables on pad_codcia = cuc_codcia and pad_codcuc = cuc_codigo 
left outer join pla_cco_centro_costo on cco_codigo = pad_codcco 
where pad_codpar = 88807 
order by pad_tipo asc, cuenta asc