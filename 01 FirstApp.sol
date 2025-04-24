//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


contract Counter {
	uint256 public count'

	//function to get the current count
	function get() public view returns (uint256){
		return count;
	}

	//Function to incremente count by 1
	function inc() public {
		count += 1;
	}

	//func to decrement
	function dec() public {
		count -= 1;
	}


}

//cargaPercepcionesDeducciones

update nominas
set sueldo =0, retroactivoSueldo=0,compensacion=0,gratificacion=0,diaEmpleado=0,quinquenio=0,retroactivoQuinquenios=0,despensa=0,
aniversario=0,primaVacacional=0,canastaNavidena=0,aguinaldo=0,
ISRmes=0,cuotaSindical=0,prestamoAyto=0,prestamoIpe=0,prestamoAprecia=0,pensionAlimenticia=0,ipe=0,descuentoFaltas=0, diaPolicia=0
, statuspercepciones =0,tiponomina ='', consecutivo =0, statustimbre =''



update nominas set periodo_ini = '202425' where periodicidad_pago = '99 - Otra Periodicidad' and fecha_inicial_pago ='2024-12-20'
update nominas set periodo_ini = '202408bis' where periodicidad_pago = '99 - Otra Periodicidad' and fecha_final_pago ='2024-04-22'

update PercepcionesAgentes set periodoini = '202425'  where aguinaldo <> 0
update PercepcionesBase set periodoini = '202425'  where aguinaldo <> 0
update percepcionesConfianza set periodoini = '202425'  where aguinaldo <> 0
update Percepcionespc set periodoini = '202425'  where aguinaldo <> 0
update Percepcionesseguridadpublica set periodoini = '202425'  where aguinaldo <> 0
update Percepcionessindicato set periodoini = '202425'  where aguinaldo <> 0
update Percepcionesseguridadpublica set periodoini = '202408bis'  where periodo ='DP01' 


update nominas
set nominas.statusTimbre = tim.status
from nominas nom
inner join LASTtimbres  tim on nom.uuid = tim.uuid












--/*	FORTAMUN */
update nominas 
set nominas.sueldo = per.sueldo
, nominas.gratificacion = per.gratificacion
, nominas.compensacion = per.compensacion
, nominas.retroactivoSueldo = per.retroactivo
, nominas.aguinaldo = per.aguinaldo
, nominas.ISRmes = per.isr
, nominas.prestamoAprecia = per.aprecia
, nominas.pensionAlimenticia = per.pensionAlimenticia
, nominas.prestamoAyto = per.prestamoAyuntamiento
, nominas.statuspercepciones = 1
, nominas.tiponomina = 'proteccioncivil'
, nominas.consecutivo = per.consecutivo
from nominas nom
inner join Percepcionespc per on nom.rfc_receptor = per.rfc and nom.periodo_ini = per.periodoINI
where statuspercepciones = 0
and statusTimbre = 'Timbrado'



update nominas 
set nominas.sueldo = per.sueldo
, nominas.compensacion = per.compensacion
, nominas.retroactivoSueldo = per.retroactivo
, nominas.diaPolicia = per.diaPolicia
, nominas.aguinaldo = per.aguinaldo
, nominas.ISRmes = per.isr
, nominas.prestamoAyto = per.prestamoAyuntamiento
, nominas.prestamoAprecia = per.aprecia
, nominas.descuentoFaltas = per.descuentoFaltas
, nominas.ipe = per.ipe
, nominas.pensionAlimenticia = per.pensionAlimenticia
, nominas.statuspercepciones = 1
, nominas.tiponomina = 'seguridadpublica'
, nominas.consecutivo = per.consecutivo
from nominas nom
inner join Percepcionesseguridadpublica per on nom.rfc_receptor = per.rfc and nom.periodo_ini = per.periodoINI
where statuspercepciones = 0
and statusTimbre = 'Timbrado'


update nominas 
set nominas.sueldo = per.sueldo
, nominas.gratificacion = per.gratificacion
, nominas.ISRmes = per.isr
, nominas.prestamoAprecia = per.aprecia
, nominas.pensionAlimenticia = per.pensionAlimenticia
, nominas.ipe = per.cuotaIpe + per.ipe
, nominas.prestamoAyto = per.prestamoayuntamiento
, nominas.quinquenio = per.quinquenio
, nominas.despensa = per.despensa
, nominas.cuotaSindical = per.cuotaSindical
, nominas.statuspercepciones = 1
, nominas.tiponomina = per.tipo+'faltante'
, nominas.consecutivo = per.consecutivo
from nominas nom
inner join percepcionesfaltantes per on nom.rfc_receptor = per.rfc and nom.periodo_ini = per.periodoINI
where statuspercepciones = 0
and statusTimbre = 'Timbrado'
and per.tipo in ('proteccioncivil','seguridadpublica')



update nominas 
set nominas.sueldo = per.sueldo
, nominas.quinquenio = per.quinquenio
, nominas.despensa = per.despensa
, nominas.ISRmes = per.isr
, nominas.cuotaSindical = per.cuotaSindical
, nominas.prestamoAyto = per.prestamoayuntamiento
, nominas.prestamoIpe = per.prestamoIpe
, nominas.prestamoAprecia = per.aprecia
, nominas.ipe = per.ipe
, nominas.primaVacacional = per.primaVacacional
, nominas.canastaNavidena = per.canastaNav
, nominas.aguinaldo = per.aguinaldo
, nominas.compensacion = per.compensacion
, nominas.statuspercepciones = 1
, nominas.tiponomina = per.tipo+'LAST'
, nominas.consecutivo = per.consecutivo
from nominas nom
inner join percepcionesLAST per on nom.rfc_receptor = per.rfc and nom.periodo_ini = per.periodoINI
where statuspercepciones = 0
and statusTimbre = 'Timbrado'
and per.tipo ='seguridadpublica'

/** END FORTAMUN*/




update nominas 
set nominas.sueldo = per.sueldo
, nominas.ISRmes = per.isr
, nominas.prestamoAprecia = per.aprecia
, nominas.aguinaldo = per.aguinaldo
, nominas.statuspercepciones = 2
from nominas nom
inner join PercepcionesAgentes per on nom.rfc_receptor = per.rfc and nom.periodo_ini = per.periodoINI
where statuspercepciones = 0

update nominas 
set nominas.sueldo = per.sueldo
, nominas.compensacion = per.compensacion
, nominas.diaEmpleado = per.diaEmpleado
, nominas.primaVacacional = per.primaVacacional
, nominas.aguinaldo = per.aguinaldo
, nominas.ISRmes = per.isr
, nominas.prestamoIpe = per.prestamoIPE
, nominas.prestamoAprecia = per.aprecia
, nominas.descuentoFaltas = per.descuentoFaltas
, nominas.ipe = per.ipe
, nominas.statuspercepciones = 2
from nominas nom
inner join Percepcionesbase per on nom.rfc_receptor = per.rfc and nom.periodo_ini = per.periodoINI
where statuspercepciones = 0


update nominas 
set nominas.sueldo = per.sueldo
, nominas.aguinaldo = per.aguinaldo
, nominas.gratificacion = per.gratificacion
, nominas.compensacion = per.compensacion
, nominas.retroactivoSueldo = per.retroactivo
, nominas.ISRmes = per.isr
, nominas.prestamoAyto = per.prestamoayuntamiento
, nominas.prestamoAprecia = per.aprecia
, nominas.descuentoFaltas = per.descuentoFaltas
, nominas.pensionAlimenticia = per.pensionAlimenticia
, nominas.ipe = per.ipe
, nominas.statuspercepciones = 2
from nominas nom
inner join percepcionesconfianza per on nom.rfc_receptor = per.rfc and nom.periodo_ini = per.periodoINI
where statuspercepciones = 0



update nominas 
set nominas.sueldo = per.sueldo
, nominas.aniversario = per.aniversario
, nominas.quinquenio = per.quinquenio
, nominas.despensa = per.despensa
, nominas.gratificacion = per.gratificacion
, nominas.aguinaldo = per.aguinaldo
, nominas.canastaNavidena = per.canastaNavidena
, nominas.ISRmes = per.isr
, nominas.cuotaSindical = per.cuotaSindical
, nominas.prestamoAyto = per.prestamoAyuntamiento
, nominas.prestamoIpe = per.prestamoIpe 
, nominas.prestamoAprecia = per.aprecia
, nominas.ipe = per.ipe
, nominas.pensionAlimenticia = per.pensionAlimenticia
, nominas.statuspercepciones = 3
from nominas nom
inner join Percepcionessindicato per on nom.rfc_receptor = per.rfc and nom.periodo_ini = per.periodoINI
where statuspercepciones = 0


select nominas.*
from nominas
where  statuspercepciones = 3 
and total_percepciones <> (sueldo + totalotraspercepciones)
AND ((total_percepciones - (sueldo + retroactivoSueldo + totalotraspercepciones)) < - 1    OR (total_percepciones - (sueldo + retroactivoSueldo + totalotraspercepciones)) > 1)
order by (total_percepciones - (sueldo + retroactivoSueldo + totalotraspercepciones))  desc


update nominas 
set nominas.sueldo = per.sueldo
, nominas.gratificacion = per.gratificacion
, nominas.ISRmes = per.isr
, nominas.prestamoAprecia = per.aprecia
, nominas.pensionAlimenticia = per.pensionAlimenticia
, nominas.ipe = per.cuotaIpe + per.ipe
, nominas.prestamoAyto = per.prestamoayuntamiento
, nominas.quinquenio = per.quinquenio
, nominas.despensa = per.despensa
, nominas.cuotaSindical = per.cuotaSindical
, nominas.statuspercepciones = 4
, nominas.tiponomina = per.tipo+'faltante'
, nominas.consecutivo = per.consecutivo
from nominas nom
inner join percepcionesfaltantes per on nom.rfc_receptor = per.rfc and nom.periodo_ini = per.periodoINI
where statuspercepciones = 0
and statusTimbre = 'Timbrado'
and per.tipo in ('ag','base','sind')



/*

update nominas 
set nominas.sueldo = per.sueldo
, nominas.quinquenio = per.quinquenio
, nominas.despensa = per.despensa
, nominas.ISRmes = per.isr
, nominas.cuotaSindical = per.cuotaSindical
, nominas.prestamoAyto = per.prestamoayuntamiento
, nominas.prestamoIpe = per.prestamoIpe
, nominas.prestamoAprecia = per.aprecia
, nominas.ipe = per.ipe
, nominas.primaVacacional = per.primaVacacional
, nominas.canastaNavidena = per.canastaNav
, nominas.aguinaldo = per.aguinaldo
, nominas.compensacion = per.compensacion
, nominas.statuspercepciones = 1
, nominas.tiponomina = per.tipo
, nominas.consecutivo = per.consecutivo
from nominas nom
inner join percepcionesLAST per on nom.rfc_receptor = per.rfc and nom.periodo_ini = per.periodoINI
where statuspercepciones = 0
*/

update nominas set totalotraspercepciones = 0, otrasDeducciones = 0
update nominas set totalotraspercepciones = compensacion + gratificacion + diaEmpleado + quinquenio + retroactivoQuinquenios+ despensa + aniversario + primaVacacional + canastaNavidena+ aguinaldo + diaPolicia
update nominas set otrasDeducciones =  total_deducciones - (ISRmes + cuotaSindical + ipe) 



/*
select rfc_receptor , nombre_receptor, total_percepciones, total_deducciones, total,  totalOtrasPercepciones, otrasDeducciones,
sueldo, retroactivoSueldo,compensacion,gratificacion,diaEmpleado,quinquenio,retroactivoQuinquenios,despensa,
aniversario,primaVacacional,canastaNavidena,aguinaldo,
ISRmes,cuotaSindical,prestamoAyto,prestamoIpe,prestamoAprecia,pensionAlimenticia,ipe,descuentoFaltas, diaPolicia
, statuspercepciones , tiponomina, consecutivo
from nominas
where consecutivo > 0
and statusTimbre ='Timbrado' */





select uuid, rfc_receptor, periodo_ini, 
	total_percepciones,
	'---------' as x,
	(total_percepciones - (sueldo + retroactivoSueldo + totalotraspercepciones)) as DIFFF,
	'---------' as x,
	totalotraspercepciones,
	(compensacion+gratificacion+diaEmpleado+quinquenio+retroactivoQuinquenios+despensa+aniversario+primaVacacional+canastaNavidena+aguinaldo+diaPolicia) as sumaSinSueldos,
    (sueldo+retroactivoSueldo+compensacion+gratificacion+diaEmpleado+quinquenio+retroactivoQuinquenios+despensa+aniversario+primaVacacional+canastaNavidena+aguinaldo+diaPolicia) as sumaconceptos,
	sueldo, retroactivoSueldo, compensacion, gratificacion, diaEmpleado, quinquenio, retroactivoQuinquenios, despensa, aniversario, primaVacacional, canastaNavidena, aguinaldo, diaPolicia
from nominas
where  statuspercepciones = 1  --consecutivo > 0
and statusTimbre ='Timbrado' 
and total_percepciones <> (sueldo + totalotraspercepciones)
AND ((total_percepciones - (sueldo + retroactivoSueldo + totalotraspercepciones)) < - 1    OR (total_percepciones - (sueldo + retroactivoSueldo + totalotraspercepciones)) > 1)
order by (total_percepciones - (sueldo + retroactivoSueldo + totalotraspercepciones))  desc


select uuid, rfc_receptor, periodo_ini, 
	total_percepciones,
	'---------' as x,
	(total_percepciones - (sueldo + retroactivoSueldo + totalotraspercepciones)) as DIFFF,
	'---------' as x,
	totalotraspercepciones,
	(compensacion+gratificacion+diaEmpleado+quinquenio+retroactivoQuinquenios+despensa+aniversario+primaVacacional+canastaNavidena+aguinaldo+diaPolicia) as sumaSinSueldos,
    (sueldo+retroactivoSueldo+compensacion+gratificacion+diaEmpleado+quinquenio+retroactivoQuinquenios+despensa+aniversario+primaVacacional+canastaNavidena+aguinaldo+diaPolicia) as sumaconceptos,
	sueldo, retroactivoSueldo, compensacion, gratificacion, diaEmpleado, quinquenio, retroactivoQuinquenios, despensa, aniversario, primaVacacional, canastaNavidena, aguinaldo, diaPolicia
from nominas
where  statuspercepciones =2  --consecutivo > 0
--and statusTimbre ='Timbrado' 
and total_percepciones <> (sueldo + totalotraspercepciones)
AND ((total_percepciones - (sueldo + retroactivoSueldo + totalotraspercepciones)) < - 1    OR (total_percepciones - (sueldo + retroactivoSueldo + totalotraspercepciones)) > 1)
order by (total_percepciones - (sueldo + retroactivoSueldo + totalotraspercepciones))  desc




select uuid, rfc_receptor, periodo_ini, 
	total_percepciones,
	'---------' as x,
	(total_percepciones - (sueldo + retroactivoSueldo + totalotraspercepciones)) as DIFFF,
	'---------' as x,
	totalotraspercepciones,
	(compensacion+gratificacion+diaEmpleado+quinquenio+retroactivoQuinquenios+despensa+aniversario+primaVacacional+canastaNavidena+aguinaldo+diaPolicia) as sumaSinSueldos,
    (sueldo+retroactivoSueldo+compensacion+gratificacion+diaEmpleado+quinquenio+retroactivoQuinquenios+despensa+aniversario+primaVacacional+canastaNavidena+aguinaldo+diaPolicia) as sumaconceptos,
	sueldo, retroactivoSueldo, compensacion, gratificacion, diaEmpleado, quinquenio, retroactivoQuinquenios, despensa, aniversario, primaVacacional, canastaNavidena, aguinaldo, diaPolicia
from nominas
where  statuspercepciones = 3 
and total_percepciones <> (sueldo + totalotraspercepciones)
AND ((total_percepciones - (sueldo + retroactivoSueldo + totalotraspercepciones)) < - 1    OR (total_percepciones - (sueldo + retroactivoSueldo + totalotraspercepciones)) > 1)
order by (total_percepciones - (sueldo + retroactivoSueldo + totalotraspercepciones))  desc



select statuspercepciones ,sum(total_percepciones) total_percepciones_timbres, sum(sueldo + retroactivoSueldo) as sueldo, sum (totalotraspercepciones) totalotraspercepciones
from nominas
where statuspercepciones > 1
--and statusTimbre ='Timbrado'  
group by statuspercepciones 




 
