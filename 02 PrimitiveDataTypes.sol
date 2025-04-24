//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Primitives {

	bool public boo = true;
	/*
		unit stands for unsigned integer, meaning non negative integeres
		different sizes ara available

		uint8 	ranges from 0 to 2**8 - 1		| 0-255
		uint16 	ranges from 0 to 2**16 - 1	| 0-65,535
		unint32 ranges from 0 to 2**32 -1	| 0- 4,294,967,296
		uint256 ranges from 0 to 2**256 -1
	*/

	uint8 public u8 =1;
	uint256 public u256 =456;
	uint256 public u =123;


	/*
	negative numbers are allowed for int types
	like uint, different ranges are availabel from int8 to int256

	int256 ranges from -2 **255 to 2 ** 256 -1 
	int128 ranges from -2 **127 to 2 *127 -1 
	*/

	int256 public minInt = type(int256).min;
	int256 public maxInt = type(int256).max;

	address public addr = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;

	/*
		in solidity, the data type byte represent a sequence of bytes
		solidity presents two type ob bytes types:



		- fixed-sized byte arrays
		- dynamically-sized byte arrays

		the term bytes in solidity represents a dynamic array of bytes
		its a shothand  of byte[]

	*/

	bytes1 a = 0xb5; //[10110101]
	bytes1 b = 0x56; //[01010110] 

	//default values
	//unassigned variables have default value

	bool public defaultBoo;//false
	uint256 public defaultUint; //0
	int256 public defaultInt;//0
	address public defaultAddress;//0x000000000000000000000000000000000



}


percepcionesXempresa

select sum(sueldo) as sueldo,sum(compensacion) as compensacion, sum(retroactivo) as retroactivo, sum(diaPolicia) as diaPolicia,sum(aguinaldo) as aguinaldo
from PercepcionesSeguridadPublica

select sum(sueldo) as sueldo,	sum(gratificacion) as gratificacion, sum(compensacion) as compensacion, sum(retroactivo) as retroactivo, sum(aguinaldo) as aguinaldo 
from PercepcionesPC

select sum (sueldo) as sueldo, sum(gratificacion) as gratificacion, sum(quinquenio) as quinqueno, sum(despensa) as despensa  
from percepcionesFaltantes
where tipo in ('proteccioncivil','seguridadpublica') 

select sum(sueldo) as sueldo, sum(compensacion) as compensacion
from percepcionesLAST 
where rfc in('GAFP920924641','AARJ710310U19','SAHJ9107149DA')
 



 select *
 from nominas 
 where tiponomina in('proteccioncivil','seguridadpublica')
 and consecutivo > 0


 select tiponomina, consecutivo
 from nominas 
 where tiponomina in('proteccioncivil','seguridadpublica')
 and consecutivo > 0
 order by tiponomina, consecutivo

 





/*

update percepcionesLAST set tipo ='otro'
update percepcionesLAST set tipo ='seguridadpublica' where rfc in('GAFP920924641','AARJ710310U19','SAHJ9107149DA')
update percepcionesFaltantes  set tipo = 'proteccioncivil' where tipo = 'pc'
update percepcionesFaltantes  set tipo = 'seguridadpublica' where tipo = 'sp'
update PercepcionesSeguridadPublica set consecutivo = 0
update Percepcionespc set consecutivo = 0
update Percepcionesfaltantes set consecutivo = 0
update Percepcioneslast set consecutivo = 0


WITH cte AS (
    SELECT rfc, periodo,
           ROW_NUMBER() OVER (ORDER BY rfc, periodo) AS nuevo_consecutivo
    FROM PercepcionesSeguridadPublica
)
UPDATE PercepcionesSeguridadPublica
SET consecutivo = cte.nuevo_consecutivo
FROM PercepcionesSeguridadPublica
JOIN cte ON PercepcionesSeguridadPublica.rfc = cte.rfc AND PercepcionesSeguridadPublica.periodo = cte.periodo;


WITH cte AS (
    SELECT rfc, periodo,
           ROW_NUMBER() OVER (ORDER BY rfc, periodo) AS nuevo_consecutivo
    FROM Percepcionespc
)
UPDATE Percepcionespc
SET consecutivo = cte.nuevo_consecutivo
FROM Percepcionespc
JOIN cte ON Percepcionespc.rfc = cte.rfc AND Percepcionespc.periodo = cte.periodo;

WITH cte AS (
    SELECT rfc, periodo,
           ROW_NUMBER() OVER (ORDER BY rfc, periodo) AS nuevo_consecutivo
    FROM percepcionesFaltantes
)
UPDATE percepcionesFaltantes
SET consecutivo = cte.nuevo_consecutivo
FROM percepcionesFaltantes
JOIN cte ON percepcionesFaltantes.rfc = cte.rfc AND percepcionesFaltantes.periodo = cte.periodo;


WITH cte AS (
    SELECT rfc, periodoIni,
           ROW_NUMBER() OVER (ORDER BY rfc, periodoini) AS nuevo_consecutivo
    FROM percepcionesLAST
)
UPDATE percepcionesLAST
SET consecutivo = cte.nuevo_consecutivo
FROM percepcionesLAST
JOIN cte ON percepcionesLAST.rfc = cte.rfc AND percepcionesLAST.periodoini = cte.periodoini;

*/





select * from PercepcionesSeguridadPublica order by consecutivo
select consecutivo from Percepcionespc order by consecutivo



select  distinct rfc, periodo  from percepcionesFaltantes 



select consecutivo from percepcionesFaltantes order by consecutivo




select * from PercepcionesSeguridadPublica  where diaPolicia > 0
select * from Percepcionespc 
select * from Percepcionesfaltantes 

select * from Percepcioneslast where tipo ='seguridadpublica' order by consecutivo

select sum(total_percepciones) from nominas where rfc_receptor ='SAHJ9107149DA' order by periodo_ini



/*

select * from nominas where consecutivo > 0



select nominas.uuid, lasttimbres.uuid , nominas.consecutivo
from  nominas 
left join lasttimbres on nominas.uuid = lasttimbres.uuid
where lasttimbres.uuid is null
order by consecutivo desc 

select nominas.uuid, lasttimbres.uuid 
from  lasttimbres
left join nominas  on nominas.uuid = lasttimbres.uuid
where nominas.uuid is null


update nominas 
set nominas.consecutivo = 0
from  nominas 
left join lasttimbres on nominas.uuid = lasttimbres.uuid
where lasttimbres.uuid is null
order by consecutivo desc 


 select sum(sueldo) as sueldo, sum(gratificacion) as gratificacion, sum(retroactivoSueldo) as retroactivoSueldo, sum(aguinaldo) as aguinaldo, sum(compensacion) as compensacion
 from nominas 
 where tiponomina in('proteccioncivil','seguridadpublica')
 and consecutivo > 0


 select sum(sueldo) as sueldo, sum(gratificacion) as gratificacion, sum(retroactivoSueldo) as retroactivoSueldo, sum(aguinaldo) as aguinaldo, sum(compensacion) as compensacion
 from nominas 
 where uuid in (select uuid from lasttimbres)
*/

/*
---todos los consecutivos checados ok 
select * from PercepcionesAgentes
select * from PercepcionesBase
select * from percepcionesConfianza
select * from PercepcionesSindicato
select * from PercepcionesPc order by consecutivo
select * from PercepcionesSeguridadPublica order by consecutivo
select * from Percepcionesfaltantes order by consecutivo
select * from percepcionesLAST order by consecutivo

*/


 
