* Encoding: windows-1252.

* De dummy-gebiedsniveau introduceren een extra stap tussen de (K)WG en de gemeente. Dit om te voorkomen dat de (onvolledige!) data geaggregeerd zou worden naar gemeenteniveau.

* Wacht op de definitieve versies (1 april)
* haal de winkelgebieden en kernwinkelgebieden af van Teams
* hint: neem het recentste jaar, met op het einde _def.
* open in QGIS en gooi de rommel eruit. Sla op als Lambert72.
* verwijder winkelgebieden buiten Vlaanderen/Brussel.

* 2022: manueel de versie 21 en 22 samengevoegd omdat de namen in de shapefile van Locatus al kapot waren.
PRESERVE.
SET DECIMAL DOT.

GET DATA  /TYPE=TXT
  /FILE="C:\temp\locatus_gebiedsniveaus\winkelgebied.csv"
  /DELIMITERS=","
  /QUALIFIER='"'
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  WINKELGEBI F6.0
  WINKELGE_1 A100
  WINKELGE_2 A100
  WINKELGE_3 A100
  /MAP.
RESTORE.
CACHE.
EXECUTE.
DATASET NAME winkelgebied WINDOW=FRONT.
rename variables winkelgebi=winkelgebied.
sort cases  winkelgebied (a).
delete variables ID.




GET
  FILE='C:\temp\locatus_gebiedsniveaus\winkelgebied2022.sav'.
DATASET NAME winkelgebied WINDOW=FRONT.


* BEGIN toevoegen gemeente.
* we kennen het toe aan de gemeente op basis van de winkel-data. Niet geografisch, omdat er soms stukjes op een andere gemeente liggen.
* we verwijderen wel wat "verdwaalde winkels" die dubbels veroorzaken.

GET TRANSLATE
  FILE='C:\temp\detailhandel\2022\saga_xy_codsec.dbf'
  /TYPE=DBF /MAP .
DATASET NAME pandstatsec WINDOW=FRONT.
match files
/file=*
/keep=unique_id2 cs01012020.
sort cases unique_id2 (a).


GET TRANSLATE
  FILE='C:\temp\detailhandel\2022\saga_xy_winkelgebied.dbf'
  /TYPE=DBF /MAP .
DATASET NAME pandwinkelgebied WINDOW=FRONT.
match files
/file=*
/keep=unique_id2 winkelgebi.
sort cases unique_id2 (a).
rename variables winkelgebi=winkelgebied.

DATASET ACTIVATE pandwinkelgebied.
FILTER OFF.
USE ALL.
SELECT IF (winkelgebied ~= 0).
EXECUTE.


DATASET ACTIVATE pandstatsec.
MATCH FILES /FILE=*
  /TABLE='pandwinkelgebied'
  /BY unique_id2.
EXECUTE.
FILTER OFF.
USE ALL.
SELECT IF (winkelgebied ~= 0).
EXECUTE.
dataset close pandwinkelgebied.
sort cases cs01012020 (a).
rename variables cs01012020=statsec.



GET DATA
  /TYPE=XLSX
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\statsec_gemeente.xlsx'
  /SHEET=name 'statsec_gemeente'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME statsecgemeente WINDOW=FRONT.
sort cases statsec (a).

dataset activate pandstatsec.
MATCH FILES /FILE=*
  /TABLE='statsecgemeente'
  /BY statsec.
EXECUTE.
dataset close statsecgemeente.


DATASET DECLARE winkelgebiedgemeente.
AGGREGATE
  /OUTFILE='winkelgebiedgemeente'
  /BREAK=winkelgebied gemeente
  /combi=N.
dataset activate winkelgebiedgemeente.
DATASET CLOSE pandstatsec.

DATASET ACTIVATE winkelgebiedgemeente.
FILTER OFF.
USE ALL.
SELECT IF (gemeente >0).
EXECUTE.




* Identify Duplicate Cases.
SORT CASES BY winkelgebied(A) combi(D).
MATCH FILES
  /FILE=*
  /BY winkelgebied
  /FIRST=PrimaryFirst
  /LAST=PrimaryLast.
DO IF (PrimaryFirst).
COMPUTE  MatchSequence=1-PrimaryLast.
ELSE.
COMPUTE  MatchSequence=MatchSequence+1.
END IF.
LEAVE  MatchSequence.
FORMATS  MatchSequence (f7).
COMPUTE  InDupGrp=MatchSequence>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimaryLast InDupGrp MatchSequence.
VARIABLE LABELS  PrimaryFirst 'Indicator of each first matching case as Primary'.
VALUE LABELS  PrimaryFirst 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryFirst (ORDINAL).
EXECUTE.

FILTER OFF.
USE ALL.
SELECT IF (PrimaryFirst=1).
EXECUTE.

match files
/file=*
/keep=winkelgebied gemeente.
sort cases winkelgebied (a).

dataset activate winkelgebied.
sort cases winkelgebied (a).

DATASET ACTIVATE winkelgebied.
MATCH FILES /FILE=*
  /TABLE='winkelgebiedgemeente'
  /BY winkelgebied.
EXECUTE.

dataset close winkelgebiedgemeente.

* EINDE toevoegen gemeente.

* swing aggregatietabel.
DATASET DECLARE agg1.
AGGREGATE
  /OUTFILE='agg1'
  /BREAK=winkelgebied gemeente
  /N_BREAK=N.
dataset activate agg1.
rename variables winkelgebied=winkelgebied_dummy.
delete variables n_break.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\winkelgebied_dummy_gemeente.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

dataset activate winkelgebied.
dataset close agg1.


* BEGIN namen aanmaken.
rename variables winkelgebied=gebiedscode.
rename variables winkelgebied_naam=naam_kort.
rename variables winkelge_2=winkelgebiedshoofdtype.
rename variables winkelge_3=WINKELGEBIEDSTYPERING.

* naam van de gemeente ophalen.
GET DATA
  /TYPE=XLSX
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\gemeente.xlsx'
  /SHEET=name 'gemeente'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME gemeentenaam WINDOW=FRONT.
match files
/file=*
/keep=gebiedscode naam.
rename variables gebiedscode=gemeente.
rename variables naam=gemeente_naam.
sort cases gemeente (a).

dataset activate winkelgebied.
sort cases gemeente (a).

MATCH FILES /FILE=*
  /TABLE='gemeentenaam'
  /BY gemeente.
EXECUTE.
DATASET CLOSE gemeentenaam.



string naam (a150).
compute naam=concat(ltrim(rtrim(gemeente_naam))," - ",ltrim(rtrim(naam_kort))," (",ltrim(rtrim(winkelgebiedshoofdtype)),")").
sort cases gemeente_naam (a).
compute volgnr=$casenum.
alter type volgnr (f8.0).


dataset copy gebiedsniveau.
dataset activate gebiedsniveau.

match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.

SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\winkelgebied.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\winkelgebied_dummy.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

delete variables volgnr naam_kort naam.
rename variables gebiedscode=winkelgebied.
compute winkelgebied_dummy=winkelgebied.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\winkelgebied_winkelgebied_dummy.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.


dataset activate winkelgebied.
dataset close gebiedsniveau.
rename variables gebiedscode=geoitem.
rename variables WINKELGEBIEDSHOOFDTYPE=v1601_label_wgb_hoofdtype.
rename variables WINKELGEBIEDSTYPERING=v1601_label_wgb_type.

match files
/file=*
/keep=geoitem
v1601_label_wgb_hoofdtype
v1601_label_wgb_type.
string geolevel (a12).
compute geolevel="winkelgebied".
compute period=2022.
EXECUTE.

recode v1601_label_wgb_hoofdtype
('Centraal'='1')
('Ondersteunend'='2')
('Overig'='3').
alter type v1601_label_wgb_hoofdtype (f1.0).

recode v1601_label_wgb_type
('Binnenstad'='1')
('Hoofdwinkelgebied groot'='2')
('Hoofdwinkelgebied klein'='3')
('Kernverzorgend centrum groot'='4')
('Kernverzorgend centrum klein'='5')
('Baanconcentratie'='6')
('Binnenstedelijke winkelstraat'='7')
('Buurtcentrum'='8')
('Wijkcentrum groot'='9')
('Wijkcentrum klein'='10')
('Grootschalige concentratie'='11')
('Shopping center'='12')
('Speciaal Winkelgebied'='13')
('Speciaal winkelgebied'='13').
alter type v1601_label_wgb_type (f2.0).

SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\uploadfiles\wgb_labels.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.





* kernwinkelgebieden.

GET TRANSLATE
  FILE='C:\github\gebiedsniveaus\data_voor_swing\shapefiles\kernwinkelgebied.dbf'
  /TYPE=DBF /MAP .
DATASET NAME kernwinkelgebied WINDOW=FRONT.
dataset close winkelgebied.
match files
/file=*
/keep=id naam gemeente.
rename variables id=kernwinkelgebied.
rename variables gemeente=gemeente_naam.
sort cases  gemeente_naam (a).

compute naam=replace(naam,"+®","é").

* naam van de gemeente ophalen.
GET DATA
  /TYPE=XLSX
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\gemeente.xlsx'
  /SHEET=name 'gemeente'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME gemeentenaam WINDOW=FRONT.
match files
/file=*
/keep=gebiedscode naam.
rename variables gebiedscode=gemeente.
rename variables naam=gemeente_naam.
alter type gemeente_naam (a50).
sort cases gemeente_naam (a).

dataset activate kernwinkelgebied.


MATCH FILES /FILE=*
  /TABLE='gemeentenaam'
  /BY gemeente_naam.
EXECUTE.
DATASET CLOSE gemeentenaam.

DATASET DECLARE agg1.
AGGREGATE
  /OUTFILE='agg1'
  /BREAK=kernwinkelgebied gemeente
  /N_BREAK=N.
dataset activate agg1.
rename variables kernwinkelgebied = kernwinkelgebied_dummy.
delete variables n_break.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\kernwinkelgebied_dummy_gemeente.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

dataset activate kernwinkelgebied.
dataset close agg1.


rename variables kernwinkelgebied=gebiedscode.

compute naam=replace(naam,"_","-").
compute naam=replace(naam,"Ú","é").
EXECUTE.

string naam_kort (a45).
compute naam_kort=naam.
if char.index(naam,"KWG ")=1 naam_kort=char.substr(naam_kort,5,100).
EXECUTE.
RENAME VARIABLES naam=naam_orig.
string naam (a150).
compute naam=concat(ltrim(rtrim(gemeente_naam))," - ",ltrim(rtrim(naam_kort))).
sort cases gemeente_naam (a).
compute volgnr=$casenum.
alter type volgnr (f8.0).



match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.

SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\kernwinkelgebied.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

* dummy niveau.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\kernwinkelgebied_dummy.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.


* dummy aggregatie.
delete variables volgnr naam_kort naam.
rename variables gebiedscode=kernwinkelgebied.
compute kernwinkelgebied_dummy=kernwinkelgebied.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\kernwinkelgebied_kernwinkelgebied_dummy.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.




