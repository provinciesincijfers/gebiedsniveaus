* Encoding: UTF-8.
* west vlaanderen.

GET
  FILE='C:\Users\plu3532\Documents\gebiedsindelingen\bevolking_xy\xy_inwoners_westvlaanderen.sav'.
DATASET NAME bevolkingxy WINDOW=FRONT.

rename variables x=x_adres.
rename variables y=y_adres.

* roep het programma op, zeg welke variabele opgevuld moet worden (hier statsec_splits) en hoeveel tekens deze mag hebben (type=7).
* type=0 betekent numeriek.
* geef vervolgens aan in welke variabele x en y teruggevonden kunnen worden.

SPSSINC TRANS RESULT=statsec_splits TYPE=20
  /FORMULA "assign_area(x=x_adres,y=y_adres)".

SAVE OUTFILE='C:\Users\plu3532\Documents\gebiedsindelingen\bevolking_xy\xy_inwoners_westvlaanderen.sav'
  /COMPRESSED.

DATASET DECLARE population2016.
AGGREGATE
  /OUTFILE='population2016'
  /BREAK=statsec_splits
  /inwoners2016=SUM(inwoners2016_max).
dataset activate population2016.


DATASET ACTIVATE population2016.
FILTER OFF.
USE ALL.
SELECT IF (statsec_splits ~= "").
EXECUTE.

SAVE OUTFILE='C:\Users\plu3532\Documents\gebiedsindelingen\bevolking_xy\statsec_westvlaanderen.sav'
  /COMPRESSED.


* Vlaams Brabant.

GET
  FILE='C:\Users\plu3532\Documents\gebiedsindelingen\bevolking_xy\xy_inwoners_vlaamsbrabant.sav'.
DATASET NAME bevolkingxy WINDOW=FRONT.

rename variables x=x_adres.
rename variables y=y_adres.

* roep het programma op, zeg welke variabele opgevuld moet worden (hier statsec_splits) en hoeveel tekens deze mag hebben (type=7).
* type=0 betekent numeriek.
* geef vervolgens aan in welke variabele x en y teruggevonden kunnen worden.

SPSSINC TRANS RESULT=statsec_splits TYPE=20
  /FORMULA "assign_area(x=x_adres,y=y_adres)".

SAVE OUTFILE='C:\Users\plu3532\Documents\gebiedsindelingen\bevolking_xy\xy_inwoners_vlaamsbrabant.sav'
  /COMPRESSED.

DATASET DECLARE population2016.
AGGREGATE
  /OUTFILE='population2016'
  /BREAK=statsec_splits
  /inwoners2016=SUM(inwoners2016_max).
dataset activate population2016.


DATASET ACTIVATE population2016.
FILTER OFF.
USE ALL.
SELECT IF (statsec_splits ~= "").
EXECUTE.

SAVE OUTFILE='C:\Users\plu3532\Documents\gebiedsindelingen\bevolking_xy\statsec_vlaamsbrabant.sav'
  /COMPRESSED.



* Oost-Vlaanderen.

GET
  FILE='C:\Users\plu3532\Documents\gebiedsindelingen\bevolking_xy\xy_inwoners_oostvlaanderen.sav'.
DATASET NAME bevolkingxy WINDOW=FRONT.

rename variables x=x_adres.
rename variables y=y_adres.

* roep het programma op, zeg welke variabele opgevuld moet worden (hier statsec_splits) en hoeveel tekens deze mag hebben (type=7).
* type=0 betekent numeriek.
* geef vervolgens aan in welke variabele x en y teruggevonden kunnen worden.

SPSSINC TRANS RESULT=statsec_splits TYPE=20
  /FORMULA "assign_area(x=x_adres,y=y_adres)".

SAVE OUTFILE='C:\Users\plu3532\Documents\gebiedsindelingen\bevolking_xy\xy_inwoners_oostvlaanderen.sav'
  /COMPRESSED.

DATASET DECLARE population2016.
AGGREGATE
  /OUTFILE='population2016'
  /BREAK=statsec_splits
  /inwoners2016=SUM(inwoners2016_max).
dataset activate population2016.


DATASET ACTIVATE population2016.
FILTER OFF.
USE ALL.
SELECT IF (statsec_splits ~= "").
EXECUTE.

SAVE OUTFILE='C:\Users\plu3532\Documents\gebiedsindelingen\bevolking_xy\statsec_oostvlaanderen.sav'
  /COMPRESSED.


