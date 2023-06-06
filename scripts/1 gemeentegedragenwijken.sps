* Encoding: windows-1252.

* OPGELET: op dit moment genereert dit ook "wijk onbekend" aan de kust. Wanneer je een nieuwe geometrie aanmaakt, let dan op dat "wijk onbekend" niet als gebied op de kaart verschijnt.

* mastertabel van de gemeentegedragen wijken van Github afhalen.
GET DATA
  /TYPE=XLSX
  /FILE='C:\github\gebiedsniveaus\gemeente_statsec_wijken\gemeentegedragen_wijken.xlsx'
  /SHEET=name 'basistabel'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME ggw WINDOW=FRONT.


* controleer nog eens opnieuw of de wijkcodes wel uniek zijn.
DATASET ACTIVATE ggw.
DATASET DECLARE testuniek.
AGGREGATE
  /OUTFILE='testuniek'
  /BREAK=NAAMvandewijk GebiedscodePinC
  /N_BREAK=N.
dataset activate testuniek.

* Identify Duplicate Cases.
SORT CASES BY GebiedscodePinC(A).
MATCH FILES
  /FILE=*
  /BY GebiedscodePinC
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
* manuele check.

dataset activate ggw.
dataset close testuniek.
match files
/file=*
/keep=codsec naamvandewijk gebiedscodepinc.
* we gebruiken "type" om de wijken te classificeren, vb "gemeentegedragen" of "nis7-achtig".
compute type=1.
value labels type
1 'gemeentegedragen'.
rename variables codsec=statsec.
alter type statsec (a9).
sort cases statsec (a).

* mastertabel van de nis7-variant van Github afhalen.
GET DATA
  /TYPE=XLSX
  /FILE='C:\github\gebiedsniveaus\kerntabellen\dena_nis7.xlsx'
  /SHEET=name 'Blad1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME nis7 WINDOW=FRONT.
match files
/file=*
/keep=statsec dena_nis7.
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
add value labels type
2 'gebaseerd op nis7'.

if gebiedscodepinc="" gebiedscodepinc=dena_nis7.
if naamvandewijk="" naamvandewijk=dena_nis7.
EXECUTE.






* verrijken met kerntabel.

GET DATA
  /TYPE=XLS
  /FILE='C:\github\gebiedsniveaus\kerntabellen\kerntabel.xls'
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

* onderwerp vervolledigen dat de wijken indeelt volgens type.
* dit stuk is gedesactiveerd, omdat Brussel nu ook wijken heeft.
*if missing(type) & provincie~=4000 & lag(gemeente)=gemeente type=lag(type).
*if provincie=4000 type=3.
*EXECUTE.
*add value labels type
*3 'Brussel'.

* opgelet: we hebben rijen geintroduceerd waar type nog niet ingevuld is.
* we vullen dat gat op met het gemiddelde voor de gemeente.
* dat MOET steeds 1 of 2 zijn, anders is er iets mis in de data! Het is normaal dat de 3 overkoepelende "gebied onbekend" geen type hebben.

rename variables type=type0.
AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=gemeente
  /type=MEAN(type0).
value labels type
1 'gemeentegedragen'
2 'gebaseerd op nis7'.
frequencies type.
* check de frequentietabel.


* gebied onbekend aanvullen.
if char.index(statsec,"ZZZZ")>0 & ggw7_naam="" ggw7_naam = "Wijk onbekend".
if char.index(statsec,"ZZZZ")>0 & ggw7="" ggw7 = concat(string(gemeente,F5.0),"ONB").



* X?JQ indiceert stranden in de kustgemeenten.
* indien een gemeente een EIGEN wijkindeling heeft, dan doen we met de strandsectoren wat die gemeente wil.
* in de andere gemeenten nemen we ze NIET mee en worden ze aan gebied onbekend toegevoegd.
do if type=2.
if char.index(statsec,"ZZZZ")>0 | char.index(statsec,"X0JQ")>0 | char.index(statsec,"X1JQ")>0 ggw7_naam = "Wijk onbekend".
if (char.index(statsec,"ZZZZ")>0 | char.index(statsec,"X0JQ")>0 | char.index(statsec,"X1JQ")>0) & ggw7="" ggw7 = concat(string(gemeente,F5.0),"ONB").
end if.
EXECUTE.

* zorg dat de wijken steeds gesorteerd staan per gemeente, alfabetisch op wijkcode, met wijk onbekend als laatste.
if char.index(ggw7,"ONB")>0 | char.index(ggw7,"ZZZZ")>0 | char.index(ggw7,"ONB")>0 | char.index(ggw7_naam,"Wijk onbekend")>0 onbekendgebied=1.
sort cases gemeente (a) onbekendgebied (a) ggw7 (a).

alter type ggw7 (a15).
* twee regels vervallen nu we wijken voor Brussel hebben.
*if provincie=4000 & ggw7="" ggw7=deelgemeente.
*if provincie=4000 & ggw7_naam="" ggw7_naam=deelgemeente_naam.


* volledige naam.
string ggw7_naamlang (a150).
if char.index(statsec,"ZZZZ")>0 ggw7_naamlang = concat(ltrim(rtrim(ggw7_naam))," (",ltrim(rtrim(gemeente_naam)),")").
compute ggw7_naamlang = concat(ltrim(rtrim(ggw7_naam))," (",ltrim(rtrim(gemeente_naam)),")").
* expliciteren dat het om een wijk gaat..
if ltrim(rtrim(ggw7_naam))=ltrim(rtrim(gemeente_naam)) ggw7_naamlang=concat(ltrim(rtrim(ggw7_naam))," (wijk)").


*if provincie=4000 & ggw7_naamlang="" ggw7_naamlang = ggw7_naam.
if onbekendgebied=1 & gemeente < 99991 ggw7_naamlang = concat("Wijk onbekend - ",gemeente_naam).
if gemeente > 99990 ggw7_naamlang=gemeente_naam.

* indien er slechts één echte wijk is, dan hoeft er geen wijk onbekend gedefinieerd te worden.
* vind deze gevallen.
if $casenum=1 wijkpergemeente=1.
if lag(gemeente)~=gemeente wijkpergemeente=1.
if lag(gemeente)=gemeente & ggw7=lag(ggw7) wijkpergemeente=lag(wijkpergemeente).
if lag(gemeente)=gemeente & ggw7~=lag(ggw7) wijkpergemeente=lag(wijkpergemeente)+1.
* overschrijf gebied onbekend.
do if onbekendgebied=1 & wijkpergemeente=2.
compute ggw7=lag(ggw7).
compute ggw7_naam=lag(ggw7_naam).
compute ggw7_naamlang=lag(ggw7_naamlang).
end if.
EXECUTE.

* definieer de eerste wijk van de gemeente (omwille van Dashboard).
string v9900_eerstewijk (a15).
if $casenum=1 v9900_eerstewijk=ggw7.
if lag(gemeente)~=gemeente v9900_eerstewijk=ggw7.
EXECUTE.

DATASET ACTIVATE aggkerntabel.
DATASET DECLARE typewijk.
AGGREGATE
  /OUTFILE='typewijk'
  /BREAK=gemeente gemeente_naam type
  /v9900_eerstewijk=first(v9900_eerstewijk).
DATASET ACTIVATE typewijk.
* controleer op missings, dubbels, afwijkende waarde bij type. Enkel nog missings doordat gebied onbekend niet echt relevant is hier.
*verwijder missings.
FILTER OFF.
USE ALL.
SELECT IF (type>-1 ).
EXECUTE.


rename variables gemeente=geoitem.
string geolevel (a8).
compute geolevel="gemeente".
rename variables type=v9900_type_ggw7.
compute period=1970.
match files
/file=*
/keep=geolevel geoitem period
v9900_type_ggw7 v9900_eerstewijk.

SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\uploadfiles\ggw7_type.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

* einde aanmaak onderwerp.

dataset activate aggkerntabel.
dataset close typewijk.


DATASET DECLARE definitie.
AGGREGATE
  /OUTFILE='definitie'
  /BREAK=ggw7 ggw7_naam ggw7_naamlang gemeente
  /volgnummer0=min(wijkpergemeente).
DATASET ACTIVATE definitie.
sort cases gemeente (a) volgnummer0 (a).
compute volgnummer=$casenum.
EXECUTE.
delete variables gemeente volgnummer0.
rename variables
(ggw7 ggw7_naam ggw7_naamlang
=gebiedscode naam_kort naam).


COMPUTE lengte=length(ltrim(rtrim(naam_kort))).
frequencies lengte.
if lengte>50 naam_kort=concat(char.substr(naam_kort,1,47),"...").
EXECUTE.
delete variables lengte.

SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\ggw7.xlsx'
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


DATASET DECLARE agg.
AGGREGATE
  /OUTFILE='agg'
  /BREAK=statsec ggw7
  /tel=N.
DATASET ACTIVATE agg.
frequencies tel.
* dit zou altijd 1 moeten zijn.
delete variables tel.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\statsec_ggw7.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\kerntabellen\statsec_ggw7_readonly.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

* versie voor geometrie.
* OPGELET: op dit moment genereert dit ook "wijk onbekend" aan de kust. Wanneer je een nieuwe geometrie aanmaakt, let dan op dat "wijk onbekend" niet als gebied op de kaart verschijnt.

string ggwtonbekendtest (a3).
compute ggwtonbekendtest=CHAR.SUBSTR(ggw7,6,3).
EXECUTE.
DATASET ACTIVATE agg.
FILTER OFF.
USE ALL.
SELECT IF (ggwtonbekendtest ~= "ONB").
EXECUTE.
delete variables ggwtonbekendtest.
SAVE TRANSLATE OUTFILE='C:\temp\statsec_ggw7_geo.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\ggw7_gemeente.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

dataset activate aggkerntabel.
dataset close agg.

* deze laten we vallen omdat dat niet meer helemaal kan, en Swing misschien in de war gaat zijn.
*dataset activate aggkerntabel.
*DATASET DECLARE agg.
*AGGREGATE
  /OUTFILE='agg'
  /BREAK=ggw7 gemeente
  /tel=N.
*DATASET ACTIVATE agg.
*delete variables tel.
*SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\ggw7_gemeente2018.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.



