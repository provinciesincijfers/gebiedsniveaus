* Encoding: windows-1252.
* download de statsec 2020 van statbel: https://statbel.fgov.be/nl/open-data/statistische-sectoren-2020 .
* open de open data statsec van statbel in ArcMap (QGIS geeft lichtjes afwijkende resultaten!).
* bereken de oppervlakte (vanzelf in m2 aangezien het bestand in Lambert72 staat) in een float precision 12 scale 2 met name arcmapopp
* open de bijgewerkte DBF in SPSS.

GET TRANSLATE 
  FILE='C:\temp\basisindelingen\sh_statbel_statistical_sectors_20200101.dbf' 
  /TYPE=DBF /MAP .
DATASET NAME DataSet1 WINDOW=FRONT.

* bewaar enkel Brussel en Vlaanderen.
FILTER OFF.
USE ALL.
SELECT IF (c_regio = "02000" OR c_regio = "04000").
EXECUTE.

* bewaar enkel unieke code en oppervlakte.
match files
/file=*
/keep=cs01012020 arcmapopp.
EXECUTE.

* plak de dataset een hoop keren onder elkaar.
string geolevel (a10).
compute geolevel="statsec".
EXECUTE.
compute period=1990.

dataset copy kopie.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.


dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

dataset activate kopie.
compute period=period+1.
DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='kopie'.
EXECUTE.

freq period.

dataset close kopie.

rename variables cs01012020=geoitem.
rename variables arcmapopp = v9900_opp_m2.
EXECUTE.




SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\uploadfiles\oppervlaktes_gis.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

