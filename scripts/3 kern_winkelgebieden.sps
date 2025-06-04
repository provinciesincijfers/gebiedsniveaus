* Encoding: windows-1252.

* VOORBEREIDING BUITEN DIT SCRIPT
* haal de winkelgebieden en kernwinkelgebieden af van Teams: https://vlbr.sharepoint.com/:f:/r/teams/DA-Interprovincialewerking/Gedeelde%20documenten/Ruwe%20data/Locatus%20(detailhandelspanden)/Geografische%20lagen?csf=1&web=1&e=2YW8Ga

* OPMERKINGEN.
* om de gebiedscode en naam van het gebied als indicator (dus v9900_gebiedscode etc) goed te krijgen, moet ook script 4 gedraaid worden.
* de dummy-gebiedsniveau introduceren een extra stap tussen de (K)WG en de gemeente. Dit om te voorkomen dat de (onvolledige!) data geaggregeerd zou worden naar gemeenteniveau.
* OPMERKING: het huidige script veronderstelt dat je een bestand krijgt waarin de winkelpunten al gekoppeld zijn aan de wgb en aan de gemeente (hier bijvoorbeeld punten_verrijkt_poging2.dbf). 
* (ik denk dat Joost met de zin hierboven: 'nog niet aan de gemeente gekoppeld' bedoeld)
*Je kan de nood aan zo'n bestand vermijden door in de plaats in GIS gewoon een spatial join te doen van de wgb met gemeentegrenzen, gebruik makende van "largest overlap" om toe te kennen aan gemeente, 
    dan vervalt een deel van het script (aangeduid in het script).


* OPGELET: als je de namen uit de DBF van de shapefile zou ophalen, dan gaan speciale tekens kapot zijn.
* je kan dit normaal gezien omzeilen door de shapefile in QGIS op te slaan als CSV (hier wgb_naam_ansi.csv). Behoud enkel de indicatoren die je nodig hebt. Zorg dat je de juiste indicatornamen hieronder in dit script definieert. 
* SPSS verwacht doorgaans ANSI, dus mogelijk nodig om nog te hercoderen met bv Notepad++.

PRESERVE.
SET DECIMAL DOT.

GET DATA  /TYPE=TXT
  /FILE="C:\temp\locatus_gebiedsniveaus\2025\wgb_naam_ansi_2.csv"
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
  gemeente A100
  naam A100
  /MAP.
RESTORE.
CACHE.
EXECUTE.
DATASET NAME winkelgebied WINDOW=FRONT.
rename variables winkelgebi=winkelgebied.
sort cases  winkelgebied (a).






* BEGIN toevoegen gemeente: niet nodig als je het zelf de gemeente al gekoppeld hebt aan de winkelpunten en winkelgebieden. Het volgende deel in het script veronderstelt immers dat je zelf d egeografische analyse hebt gemaakt (Filip doet dit nu)
* we kennen het toe aan de gemeente op basis van de winkel-data. Niet geografisch, omdat er soms stukjes op een andere gemeente liggen.
* we verwijderen wel wat "verdwaalde winkels" die dubbels veroorzaken.
GET TRANSLATE
  FILE='C:\temp\locatus_gebiedsniveaus\2023\levering 20230401\punten_verrijkt_poging2.dbf'
  /TYPE=DBF /MAP .
DATASET NAME pandstatsec WINDOW=FRONT.
rename variables winkelgebi=winkelgebied.
FILTER OFF.
USE ALL.
SELECT IF (winkelgebied ~= 0).
EXECUTE.

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


* aanmaken lijst combinaties van wgb met gemeente.
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



* DIT IS NIET MEER NODIG INDIEN JE MET LARGEST OVERLAP ZOU WERKEN.
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
rename variables winkelge_1=naam_kort.
rename variables winkelge_2=winkelgebiedshoofdtype.
rename variables winkelge_3=WINKELGEBIEDSTYPERING.
rename variables gemeentenaam = gemeente_naam.

* naam van de gemeente ophalen: NIET NODIG als de namen al in de file staan. Zorg er wel voor dat de variabele de correcte naam heeft

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
string geolevel (a12).
compute geolevel="winkelgebied".
* dit mag op 1970 staan omdat het periode-onafhankelijke info is.
compute period=1970.
EXECUTE.


recode v1601_label_wgb_hoofdtype
('Centraal'='1')
('Ondersteunend'='2')
('Overig'='3').
alter type v1601_label_wgb_hoofdtype (f1.0).

*wordt niet meer gebruikt
recode v1601_label_wgb_type
('Binnenstad'='1')
('Hoofdwinkelgebied groot'='2')
('Hoofdwinkelgebied klein'='3')
('Kernverzorgend centrum groot'='4')
('Kernverzorgend centrum klein'='5')
('Baanconcentratie'='6')
('Binnenstedelijke winkelstraat'='7')
('Kernondersteunend klein'='8')
('Kernondersteunend middel'='9')
('Kernondersteunend groot'='10')
('Grootschalige concentratie'='11')
('Shopping center'='12')
('Speciaal Winkelgebied'='13')
('Speciaal winkelgebied'='13').
*alter type v1601_label_wgb_type (f2.0).

SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\uploadfiles\wgb_labels.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.





* kernwinkelgebieden.
*check of de namen nog kloppen die in het bestand zouden moeten zitten

GET TRANSLATE
  FILE='C:\temp\locatus_gebiedsniveaus\2025\kernwinkelgebieden_2024_def.dbf'
  /TYPE=DBF /MAP .
DATASET NAME kernwinkelgebied WINDOW=FRONT.
dataset close winkelgebied.
match files
/file=*
/keep=kwg_id naam gemeente.
rename variables kwg_id=kernwinkelgebied.
rename variables gemeente=gemeente_naam.
sort cases  gemeente_naam (a).

compute naam=replace(naam,"+®","é").
compute naam=replace(naam,"_","-").
compute naam=replace(naam,"Ú","é").

* code van de gemeente ophalen.
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




