// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


contract Variables {
	//state variables are stored on the blockchain
	string public text ="hello";
	uint256 public num =123;


	function doSomething() public {
		//local variables are not saved to the blockchain
		uint256 i = 456;

		//here are some global variables
		uint256 timestamp = block.timestamp; // current block timestamp
		address sender = msg.sender; // address of the caller
	}

}



//x1percepciones llenado

--select uuid, rfc_receptor, periodo_ini, periodo_fin, sueldo,aniversario,quinquenio,despensa,gratificacion,ISRmes,cuotaSindical,prestamoAyto,prestamoIpe,prestamoAprecia,ipe,pensionAlimenticia,diaEmpleado,descuentoFaltas,retroactivoSueldo,retroactivoQuinquenios
--,primaVacacional,canastaNavidena,aguinaldo,compensacion,diaPolicia 
/*
select consecutivo,uuid, rfc_receptor, periodo_ini, periodo_fin, 
total_percepciones,
sueldo, retroactivoSueldo , compensacion , gratificacion , diaEmpleado , quinquenio , retroactivoQuinquenios , despensa , aniversario , primaVacacional ,canastaNavidena ,aguinaldo , diapolicia
from nominas 
where statuspercepciones = 1
order by rfc_receptor, periodo_fin
*/


/* DIFERENCIAS EN TOTALES PERCEPCIONES */
select consecutivo,uuid, rfc_receptor, periodo_ini, periodo_fin, 
total_percepciones, (sueldo + retroactivoSueldo + totalOtrasPercepciones) as percep, 
total_percepciones - (sueldo + retroactivoSueldo + totalOtrasPercepciones )  as diff,
'00000000' as tab
,sueldo, retroactivoSueldo , compensacion , gratificacion , diaEmpleado , quinquenio , retroactivoQuinquenios , despensa , aniversario , primaVacacional ,canastaNavidena ,aguinaldo , diapolicia
from nominas 
where statuspercepciones = 1
and (total_percepciones <> (sueldo + retroactivoSueldo + totalOtrasPercepciones ) )
--and tiponomina = 'seguridadpublica'
order by rfc_receptor, periodo_fin



/*  VALIDAMOS QUE NO MARQUE DOS REGISTROS */
/*
select tiponomina, consecutivo , count(id)
from nominas 
where statuspercepciones > 0
group by tiponomina, consecutivo 
having count(id) > 1
order by tiponomina, consecutivo 


select * from nominas where consecutivo = 8 and tiponomina ='seguridadpublica'
select * from LASTtimbres where uuid in ('541BADB8-B506-4F8C-9B80-F1E22D43C0B3','572BB005-F6A0-40F6-A754-C0CF3980C2E1')
select * from PercepcionesSeguridadPublica where rfc ='AAFO920320IM3' and periodoIni ='202408bis'

select * from nominas where consecutivo = 94 and tiponomina ='seguridadpublica'
select * from LASTtimbres where uuid in ('8BD72CED-9510-4F97-92F0-9ABDC32D2442','25842472-3CF9-408B-AFB5-5821881540E6')
select * from PercepcionesSeguridadPublica where rfc ='AUFL9504209R7' and periodoIni ='202408bis'

select * from nominas where consecutivo = 360 and tiponomina ='seguridadpublica'
select * from LASTtimbres where uuid in ('59FEB8DD-B96B-4D4D-979A-AC1A5E09FFDF','1A5C2217-F21F-4345-92E3-9E2D1A4F99F1')
select * from PercepcionesSeguridadPublica where rfc ='CORM680802466' and periodoIni ='202408bis'
*/ 
