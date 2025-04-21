//SPDX-License-Identifier: MIT
pragma solidity ^0.2.24;

contract HelloWorld {
	string public greet = "Hello world!";
}


//$ git clone https://bitbucket.org/shop_proven/nft-marketplace.git


select * from PercepcionesAgentes
select * from Percepcionesbase
select * from PercepcionesPC
select * from PercepcionesSeguridadPublica
select * from PercepcionesSindicato
select * from percepcionesConfianza


select * from PercepcionesAgentes where aguinaldo > 0
select * from PercepcionesAgentes where rfc ='CUBE800720TQA' order by periodoINI


select periodo_ini, periodo_fin , fecha_inicial_pago, fecha_final_pago,  periodicidadASF, count(rfc_receptor)
from nominas  
where periodicidad_pago = '99 - Otra Periodicidad'
group by periodo_ini, periodo_fin , fecha_inicial_pago, fecha_final_pago,  periodicidadASF
order by periodo_ini


select *
from nominas  
where periodicidad_pago = '99 - Otra Periodicidad'
and periodo_ini = '202415'


select * from PercepcionesSeguridadPublica where periodoIni= '202408'  and periodo ='DP01'
select * from nominas where periodicidad_pago = '99 - Otra Periodicidad'  and periodo_ini = '202408' order by rfc_receptor

/*
--where periodicidad_pago = '99 - Otra Periodicidad'
202408	202408	2024-04-22	2024-04-22	86		//policias
202411	202411	2024-06-04	2024-06-04	15		//sueldo y quinquenio de policias
202412	202412	2024-06-24	2024-06-24	15		///sueldo e isr para base y es anual
202413	202413	2024-07-05	2024-07-05	21		//quinquenios de sindicalizados
202415	202415	2024-08-08	2024-08-08	6		//QUINQUENIO DE SINDICALIZADO
202423	202423	2024-12-13	2024-12-13	41		//sindicalizados
202424	202424	2024-12-20	2024-12-20	315		//aguinaldo


update nominas
set sueldo =0, retroactivoSueldo=0,compensacion=0,gratificacion=0,diaEmpleado=0,quinquenio=0,retroactivoQuinquenios=0,despensa=0,
aniversario=0,primaVacacional=0,canastaNavidena=0,aguinaldo=0,
ISRmes=0,cuotaSindical=0,prestamoAyto=0,prestamoIpe=0,prestamoAprecia=0,pensionAlimenticia=0,ipe=0,descuentoFaltas=0, diaPolicia=0
,statuspercepciones =0

update nominas set periodo_ini = '202425' where periodicidad_pago = '99 - Otra Periodicidad' and fecha_inicial_pago ='2024-12-20'

update PercepcionesAgentes set periodoini = '202425'  where aguinaldo <> 0
update PercepcionesBase set periodoini = '202425'  where aguinaldo <> 0
update percepcionesConfianza set periodoini = '202425'  where aguinaldo <> 0
update Percepcionespc set periodoini = '202425'  where aguinaldo <> 0
update Percepcionesseguridadpublica set periodoini = '202425'  where aguinaldo <> 0
update Percepcionessindicato set periodoini = '202425'  where aguinaldo <> 0
 

*/

select * from sys.all_columns


select 'agentes' as typ, sum(sueldo) as sueldo, sum(isr) as isr, sum(aprecia) as aprecia, sum(aguinaldo) as aguinaldo from PercepcionesAgentes 
select 'base' as typ, sum(sueldo) as sueldo,   sum(isr) as isr, sum(aprecia) as aprecia, sum(aguinaldo) as aguinaldo, sum(compensacion) as compensacion, sum(ipe) as ipe from Percepcionesbase
select 'proteccioncivil', sum(sueldo) as sueldo, sum(gratificacion) as gratificacion, sum(compensacion) as compensacion,  from Percepcionespc  

select * from percepcionesConfianza where aguinaldo <> 0

select * from Percepcionesseguridadpublica where aguinaldo <> 0
select * from Percepcionessindicato where aguinaldo <> 0

select 
sum(sueldo) as sueldo,
sum(isr) as isr,
sum(aprecia) as aprecia,
sum(neto) as neto,
sum(aguinaldo) as aguinaldo
from PercepcionesAgentes

select
sum(sueldo) as sueldo,
sum(isr) as isr,
sum(aprecia) as aprecia,
sum(neto) as neto,
sum(aguinaldo) as aguinaldo
from PercepcionesAgentes

select
sum(sueldo) as sueldo,
sum(aguinaldo) as aguinaldo,
sum(gratificacion) as gratificacion,
sum(compensacion) as compensacion,
sum(retroactivo) as retroactivo,
sum(isr) as isr,
sum(prestamoAyuntamiento) as prestamoAyuntamiento,
sum(aprecia) as aprecia,
sum(descuentoFaltas) as descuentoFaltas,
sum(pensionAlimenticia) as pensionAlimenticia,
sum(ipe) as ipe,
sum(neto0) as neto0,
sum(invalidezYvida) as invalidezYvida,
sum(cesantiaYvejez) as cesantiaYvejez,
sum(enfymatpatron) as enfymatpatron,
sum(fondoRetiroSar) as fondoRetiroSar,
sum(impuestoEstatal) as impuestoEstatal,
sum(riesgoTrabajo) as riesgoTrabajo,
sum(imssEmpresa) as imssEmpresa,
sum(infonavitEmpresa) as infonavitEmpresa,
sum(guarderiaImss) as guarderiaIms
from percepcionesConfianza

select 
sum(sueldo) as sueldo,
sum(gratificacion) as gratificacion,
sum(compensacion) as compensacion,
sum(retroactivo) as retroactivo,
sum(aguinaldo) as aguinaldo,
sum(isr) as isr,
sum(aprecia) as aprecia,
sum(pensionAlimenticia) as pensionAlimenticia,
sum(prestamoAyuntamiento) as prestamoAyuntamiento,
sum(neto) as neto
from percepcionespc


SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'percepcionesseguridadpublica'




select distinct *
from nominas nom
inner join PercepcionesAgentes per on nom.rfc_receptor = per.rfc and nom.periodo_ini = per.periodoINI


select rfc_receptor, nombre_receptor, periodicidadASF, periodo_ini, sueldo, aguinaldo  from nominas where rfc_receptor ='CUBE800720TQA' order by periodo_ini

select rfc_receptor, nombre_receptor, periodicidadASF, periodo_ini, sueldo, aguinaldo  from nominas where aguinaldo > 0





select distinct periodo_ini from nominas where periodicidad_pago = '99 - Otra Periodicidad' and fecha_inicial_pago ='2024-12-20'


select * 
from nominas
where periodo_ini <> periodo_fin

