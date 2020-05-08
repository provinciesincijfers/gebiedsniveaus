* Encoding: windows-1252.

* OPGELET: op dit moment genereert dit ook "wijk onbekend" aan de kust.

* mastertabel van Github afhalen.
GET DATA
  /TYPE=XLSX
  /FILE='C:\temp\gebiedsniveaus\kerntabellen\gemeentegedragen_wijken.xlsx'
  /SHEET=name 'basistabel'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME ggw WINDOW=FRONT.
match files
/file=*
/keep=codsec naamvandewijk gebiedscodepinc.
compute type=1.
rename variables codsec=statsec.
alter type statsec (a9).
sort cases statsec (a).

GET DATA
  /TYPE=XLSX
  /FILE='C:\temp\gebiedsniveaus\kerntabellen\dena_nis7.xlsx'
  /SHEET=name 'Blad1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME nis7 WINDOW=FRONT.
match files
/file=*
/keep=statsec  dena_nis7.
EXECUTE.
alter type statsec (a9).
sort cases statsec (a).


DATASET ACTIVATE nis7.
MATCH FILES /FILE=*
  /FILE='ggw'
  /BY statsec.
EXECUTE.
dataset close ggw.

recode type (missing=2).
value labels type
1 'gemeentegedragen'
2 'gebaseerd op nis7'.

if gebiedscodepinc="" gebiedscodepinc=dena_nis7.
if naamvandewijk="" naamvandewijk=dena_nis7.
EXECUTE.








GET DATA
  /TYPE=XLS
  /FILE='C:\temp\gebiedsniveaus\kerntabellen\kerntabel.xls'
  /SHEET=name 'toewijzingstabel_alles'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0.
EXECUTE.
DATASET NAME kerntabel WINDOW=FRONT.


dataset activate kerntabel.
DATASET DECLARE aggkerntabel.
AGGREGATE
  /OUTFILE='aggkerntabel'
  /BREAK=statsec gemeente gemeente_naam deelgemeente deelgemeente_naam provincie
  /tel=N.
dataset activate aggkerntabel.
sort cases statsec (a).
MATCH FILES /FILE=*
  /FILE='nis7'
  /BY statsec.
EXECUTE.
dataset close kerntabel.

dataset close nis7.
rename variables naamvandewijk=ggw7_naam.
rename variables gebiedscodepinc=ggw7.

* X?JQ indiceert stranden in de kustgemeenten.
if char.index(statsec,"ZZZZ")>0 | char.index(statsec,"X0JQ")>0 | char.index(statsec,"X1JQ")>0 ggw7_naam = "Wijk onbekend".
if (char.index(statsec,"ZZZZ")>0 | char.index(statsec,"X0JQ")>0 | char.index(statsec,"X1JQ")>0) & ggw7="" ggw7 = concat(string(gemeente,F5.0),"ONB").
EXECUTE.



alter type ggw7 (a15).
if provincie=4000 & ggw7="" ggw7=deelgemeente.
if provincie=4000 & ggw7_naam="" ggw7_naam=deelgemeente_naam.

string ggw7_naamlang (a150).
if char.index(statsec,"ZZZZ")>0 ggw7_naamlang = concat(ltrim(rtrim(ggw7_naam))," (",ltrim(rtrim(gemeente_naam)),")").
if provincie~=4000 ggw7_naamlang = concat(ltrim(rtrim(ggw7_naam))," (",ltrim(rtrim(gemeente_naam)),")").
if provincie=4000 & ggw7_naamlang="" ggw7_naamlang = ggw7_naam.

EXECUTE.


* onderwerp toevoegen dat de wijken indeelt volgens type.
if missing(type) & provincie~=4000 & lag(gemeente)=gemeente type=lag(type).
if provincie=4000 type=3.
EXECUTE.
add value labels type
3 'Brussel'.
DATASET ACTIVATE aggkerntabel.
DATASET DECLARE typewijk.
AGGREGATE
  /OUTFILE='typewijk'
  /BREAK=gemeente gemeente_naam type
  /N_BREAK=N.
DATASET ACTIVATE typewijk.
* controleer. Missings doordat gebied onbekend later toegevoegd wordt; misschien ook nog onbekende gemeenten of dubbele gemeenten?
*verwijder missings.
FILTER OFF.
USE ALL.
SELECT IF (type>-1).
EXECUTE.

rename variables gemeente=geoitem.
string geolevel (a8).
compute geolevel="gemeente".
rename variables type=v9900_type_ggw7.
compute period=1970.
match files
/file=*
/keep=geolevel geoitem period
v9900_type_ggw7.

SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\uploadfiles\ggw7_type.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

* einde aanmaak onderwerp.

dataset activate aggkerntabel.
DATASET DECLARE definitie.
AGGREGATE
  /OUTFILE='definitie'
  /BREAK=ggw7 ggw7_naam ggw7_naamlang
  /N_BREAK=N.
DATASET ACTIVATE definitie.
delete variables n_break.
compute volgnummer=$casenum.
rename variables
(ggw7 ggw7_naam ggw7_naamlang
=gebiedscode naam_kort naam).


SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\ggw7.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.


dataset activate aggkerntabel.
dataset close definitie.
* aggregatietabellen:
-statsec-wijk
-wijk-gemeente
wijk-gemeente2018.

* geometrie aanmaken.

DATASET DECLARE agg.
AGGREGATE
  /OUTFILE='agg'
  /BREAK=statsec ggw7
  /tel=N.
DATASET ACTIVATE agg.
delete variables tel.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\statsec_ggw7.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

dataset activate aggkerntabel.
DATASET DECLARE agg.
AGGREGATE
  /OUTFILE='agg'
  /BREAK=ggw7 gemeente
  /tel=N.
DATASET ACTIVATE agg.
delete variables tel.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\ggw7_gemeente.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.


dataset activate aggkerntabel.
DATASET DECLARE agg.
AGGREGATE
  /OUTFILE='agg'
  /BREAK=ggw7 gemeente
  /tel=N.
DATASET ACTIVATE agg.
delete variables tel.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\ggw7_gemeente2018.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.




