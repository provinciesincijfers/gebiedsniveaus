* Encoding: windows-1252.

* haal de nodige data af:
https://share.vlaamsbrabant.be/share/page/site/socialeplanning/documentlibrary#filter=path%7C%2FGegevens%2FLocatus%2520%2528detailhandelspanden%2529%2FGeografische%2520lagen%7C&page=1
* hint: neem het recentste jaar, met op het einde _def.
* open in QGIS en gooi de rommel eruit. Dubbelecheck dat het in Lambert 72 staat.
* verwijder winkelgebieden buiten Vlaanderen/Brussel.




GET TRANSLATE
  FILE='C:\temp\gebiedsniveaus\werkbestanden\geolagen swing\winkelgebied.dbf'
  /TYPE=DBF /MAP .
DATASET NAME winkelgebied WINDOW=FRONT.
match files
/file=*
/keep=winkelgebi.
rename variables winkelgebi=winkelgebied.
sort cases  winkelgebied (a).

* we kennen het toe aan de gemeente op basis van de winkel-data. Niet geografisch, omdat er soms stukjes op een andere gemeente liggen.
* we verwijderen wel wat "verdwaalde winkels" die dubbels veroorzaken.
GET
  FILE=
    'C:\Users\plu3532\Documents\detailhandel\locatus\HERVERWERKING\bestanden\werkbestand_volledig.sav'.
DATASET NAME locatus WINDOW=FRONT.

FILTER OFF.
USE ALL.
SELECT IF (JAAR = 2020).
EXECUTE.

DATASET DECLARE wgb_nis.
AGGREGATE
  /OUTFILE='wgb_nis'
  /BREAK=winkelgebied_id niscode2019_locatus winkelgebied_naam
WINKELGEBIEDSHOOFDTYPE
WINKELGEBIEDSTYPERING
  /koppeling=N.
DATASET ACTIVATE wgb_nis.

FILTER OFF.
USE ALL.
SELECT IF (winkelgebied_id ~= 0).
EXECUTE.


* Identify Duplicate Cases.
SORT CASES BY winkelgebied_id(A) koppeling(A).
MATCH FILES
  /FILE=*
  /BY winkelgebied_id
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
  /DROP=PrimaryFirst InDupGrp MatchSequence.
VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary'.
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryLast (ORDINAL).
FREQUENCIES VARIABLES=PrimaryLast.
EXECUTE.

FILTER OFF.
USE ALL.
SELECT IF (PrimaryLast = 1).
EXECUTE.

DELETE VARIABLES koppeling primarylast.

sort cases winkelgebied_id (a).
rename variables winkelgebied_id = winkelgebied.

DATASET ACTIVATE winkelgebied.
MATCH FILES /FILE=*
  /TABLE='wgb_nis'
  /BY winkelgebied.
EXECUTE.

dataset close wgb_nis.


GET DATA
  /TYPE=XLSX
  /FILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\gemeente.xlsx'
  /SHEET=name 'gemeente'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME gemeente WINDOW=FRONT.
match files
/file=*
/keep=gebiedscode naam.
rename variables gebiedscode=niscode2019_locatus.
alter type niscode2019_locatus (a5).
sort cases niscode2019_locatus (a).
rename variables naam=gemeente_naam.

dataset activate winkelgebied.
sort cases niscode2019_locatus (a).
MATCH FILES /FILE=*
  /TABLE='gemeente'
  /BY niscode2019_locatus.
EXECUTE.




DATASET DECLARE agg1.
AGGREGATE
  /OUTFILE='agg1'
  /BREAK=winkelgebied niscode2019_locatus
  /N_BREAK=N.
dataset activate agg1.
delete variables n_break.
rename variables niscode2019_locatus=gemeente.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\winkelgebied_gemeente.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES.

dataset activate winkelgebied.
dataset close agg1.

rename variables winkelgebied=gebiedscode.
rename variables winkelgebied_naam=naam_kort.
string naam (a150).
compute naam=concat(ltrim(rtrim(gemeente_naam))," - ",ltrim(rtrim(naam_kort))," (",ltrim(rtrim(WINKELGEBIEDSHOOFDTYPE)),")").
sort cases gemeente_naam (a).
compute volgnr=$casenum.
alter type volgnr (f8.0).


dataset copy gebiedsniveau.

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
compute period=2020.
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
('Speciaal Winkelgebied'='13').
alter type v1601_label_wgb_type (f1.0).

SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\uploadfiles\wgb_labels.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

dataset activate gebiedsniveau.
dataset close winkelgebied.
match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.

SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\winkelgebied.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.




* kernwinkelgebieden.

GET TRANSLATE
  FILE='C:\temp\gebiedsniveaus\werkbestanden\geolagen swing\kernwinkelgebied.dbf'
  /TYPE=DBF /MAP .
DATASET NAME kernwinkelgebied WINDOW=FRONT.
dataset close gebiedsniveau.
match files
/file=*
/keep=id.
rename variables id=kernwinkelgebied.
sort cases  kernwinkelgebied (a).


dataset activate locatus.

DATASET DECLARE wgb_nis.
AGGREGATE
  /OUTFILE='wgb_nis'
  /BREAK=kernafbakening_id niscode2019_locatus
  /koppeling=N.
DATASET ACTIVATE wgb_nis.

FILTER OFF.
USE ALL.
SELECT IF (kernafbakening_id ~= 0).
EXECUTE.


* Identify Duplicate Cases.
SORT CASES BY kernafbakening_id(A) koppeling(A).
MATCH FILES
  /FILE=*
  /BY kernafbakening_id
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
  /DROP=PrimaryFirst InDupGrp MatchSequence.
VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary'.
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryLast (ORDINAL).
FREQUENCIES VARIABLES=PrimaryLast.
EXECUTE.

FILTER OFF.
USE ALL.
SELECT IF (PrimaryLast = 1).
EXECUTE.

DELETE VARIABLES koppeling primarylast.

sort cases kernafbakening_id (a).
rename variables kernafbakening_id = kernwinkelgebied.

DATASET ACTIVATE kernwinkelgebied.
MATCH FILES /FILE=*
  /TABLE='wgb_nis'
  /BY kernwinkelgebied.
EXECUTE.

dataset close wgb_nis.


sort cases niscode2019_locatus (a).
MATCH FILES /FILE=*
  /TABLE='gemeente'
  /BY niscode2019_locatus.
EXECUTE.
dataset close gemeente.


PRESERVE.
 SET DECIMAL COMMA.

GET DATA  /TYPE=TXT
  /FILE=
    "C:\temp\gebiedsniveaus\werkbestanden\basis geodata\kernwinkelgebieden 2020.csv"
  /DELIMITERS=","
  /QUALIFIER='"'
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  kernwinkelgebied AUTO
  kernwinkelgebied_NAAM AUTO
  /MAP.
RESTORE.
CACHE.
EXECUTE.
DATASET NAME kwg_naam WINDOW=FRONT.
*match files
/file=*
/keep=kernwinkelgebied
kernwinkelgebied_NAAM.
sort cases kernwinkelgebied (a).

DATASET ACTIVATE kernwinkelgebied.
sort cases kernwinkelgebied (a).
MATCH FILES /FILE=*
  /TABLE='kwg_naam'
  /BY kernwinkelgebied.
EXECUTE.



DATASET DECLARE agg1.
AGGREGATE
  /OUTFILE='agg1'
  /BREAK=kernwinkelgebied niscode2019_locatus
  /N_BREAK=N.
dataset activate agg1.
delete variables n_break.
rename variables niscode2019_locatus=gemeente.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\kernwinkelgebied_gemeente.xlsx'
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
compute naam_kort=kernwinkelgebied_NAAM.
if char.index(kernwinkelgebied_NAAM,"KWG ")=1 naam_kort=char.substr(naam_kort,5,100).
EXECUTE.
string naam (a150).
compute naam=concat(ltrim(rtrim(gemeente_naam))," - ",ltrim(rtrim(naam_kort))).
sort cases gemeente_naam (a).
compute volgnr=$casenum.
alter type volgnr (f8.0).



match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.

SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\kernwinkelgebied.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
