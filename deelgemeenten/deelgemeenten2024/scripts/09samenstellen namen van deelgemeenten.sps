* Encoding: windows-1252.
GET TRANSLATE 
  FILE='C:\Users\plu3532\Documents\gebiedsindelingen\AdminVector_2015_L08_shp\AD_1_MunicipalSection.dbf' 
  /TYPE=DBF /MAP . 
DATASET NAME naambasis WINDOW=FRONT.

string deelgemeente_naam (a150).
compute deelgemeente_naam=name_dut.
if deelgemeente_naam="" deelgemeente_naam=name_fre.
if deelgemeente_naam="" deelgemeente_naam=name_ger.


GET DATA
  /TYPE=XLSX
  /FILE='C:\Users\plu3532\Documents\gebiedsindelingen\verwerking\gislagen\toewijzingstabel.xlsx'
  /SHEET=name 'toewijzingstabel'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME allegebieden WINDOW=FRONT.

DATASET ACTIVATE allegebieden.
DATASET DECLARE twdeelgemeente.
AGGREGATE
  /OUTFILE='twdeelgemeente'
  /BREAK=twdeelgemeente
  /N_BREAK=N.
dataset activate twdeelgemeente.
dataset close allegebieden.
rename variables twdeelgemeente=niscode.


dataset activate naambasis.
alter type niscode (a15).
DATASET DECLARE uniekenamen.
AGGREGATE
  /OUTFILE='uniekenamen'
  /BREAK=niscode deelgemeente_naam
  /records=N.
DATASET ACTIVATE uniekenamen.

MATCH FILES /FILE=*
  /FILE='twdeelgemeente'
  /BY niscode.
EXECUTE.

* sorteren op deelgemeente naam geeft de zelfgemaakte NIS-codes.
if niscode="31006C-I_II" deelgemeente_naam="Hoeke - Oostkerke".
if niscode="38002A-I_II_III" deelgemeente_naam="Wulveringen - Vinkem".
if niscode="38025H-I_II" deelgemeente_naam="Oeren - Alveringem - Sint-Rijkers".
EXECUTE.

* sorteren op N_break laat zien welke deelgemeenten niet meer bestaan in onze indeling.¨
* dit zijn met name de deelgemeenten die hierboven zijn samengevoegd, plus Freloux (waar wellicht de sectoren allemaal bij meerderheid in een andere deelgemeente lagen).


DATASET ACTIVATE uniekenamen.
FILTER OFF.
USE ALL.
SELECT IF (N_BREAK > 0).
EXECUTE.

delete variables records
N_BREAK.

* opmerking: de Franstalige en Duitstalige deelgemeenten staan nog vol met coderingsmiserie.

sort cases niscode (a).
rename variables niscode= twdeelgeme.



* voeg gemeentenamen toe.
GET
  FILE='C:\Users\plu3532\Documents\gebiedsindelingen\verwerking\gislagen\werkbestanden\deelgemeente_gemeentenamen.sav'.
DATASET NAME gemeentenamen WINDOW=FRONT.
alter type twdeelgeme (a15).
sort cases twdeelgeme (a).
DATASET ACTIVATE uniekenamen.
sort cases twdeelgeme (a).
MATCH FILES /FILE=*
  /TABLE='gemeentenamen'
  /BY twdeelgeme.
EXECUTE.
dataset close gemeentenamen.

* uniek maken van de deelgemeentenamen.
AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=deelgemeente_naam
  /stap1=N.
if stap1>1 & deelgemeente_naam~=gemeente_naam deelgemeente_naam=concat(deelgemeente_naam," (",gemeente_naam,")").
EXECUTE.
AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=deelgemeente_naam
  /stap2=N.
EXECUTE.
* check voor de zekerheid of alles nu echt uniek is.
delete variables stap1 stap2.

SAVE TRANSLATE OUTFILE='C:\Users\plu3532\Documents\gebiedsindelingen\verwerking\gislagen\namen_deelgemeenten.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES.


*DELETE VARIABLES gemeente_naam.

* indien nog openstaat activate in plaats van get.
dataset activate shape.
GET
  FILE='C:\Users\plu3532\Documents\gebiedsindelingen\verwerking\gislagen\basis_tabel.sav'.
DATASET NAME verzamelbestand WINDOW=FRONT.
alter type deelgemeente (a15).
sort cases deelgemeente (a).



dataset close naambasis.

dataset close twdeelgemeente.

dataset activate uniekenamen.
rename variables twdeelgeme=deelgemeente.
sort cases deelgemeente (a).



DATASET ACTIVATE verzamelbestand.
MATCH FILES /FILE=*
  /TABLE='uniekenamen'
  /BY deelgemeente.
EXECUTE.
dataset close uniekenamen.

if char.index(deelgemeente,"ONBE")=6 &deelgemeente_naam="" deelgemeente_naam=statsec_naam.


compute statsec_naam_lengte=length(statsec_naam).
compute gemeente_naam_lengte=length(gemeente_naam).
compute deelgemeente_naam_lengte=length(deelgemeente_naam).
FREQUENCIES VARIABLES=statsec_naam_lengte gemeente_naam_lengte deelgemeente_naam_lengte
  /FORMAT=NOTABLE
  /STATISTICS=MAXIMUM
  /ORDER=ANALYSIS.
delete variables statsec_naam_lengte
gemeente_naam_lengte
deelgemeente_naam_lengte.
alter type statsec_naam
gemeente_naam
deelgemeente_naam (a100).
string statsec_naam_lang (a300).
compute statsec_naam_lang=gemeente_naam.
* CHECKEN OF HIER NOG ALLES GOED LOOPT.
if deelgemeente_naam~=gemeente_naam statsec_naam_lang=concat(statsec_naam_lang," (",deelgemeente_naam,") - ",statsec_naam).
if deelgemeente_naam=gemeente_naam statsec_naam_lang=concat(statsec_naam_lang," - ",statsec_naam).
if char.index(deelgemeente,"ONBE")=6 statsec_naam_lang=statsec_naam.
EXECUTE.



DATASET ACTIVATE verzamelbestand.
DATASET COPY  leeg.
DATASET ACTIVATE  leeg.
FILTER OFF.
USE ALL.
SELECT IF ($casenum  =1).
EXECUTE.
compute statsec = "99999ZZZZ".
compute statsec_naam="Niet te lokaliseren".
compute deelgemeente="99999onbe".
compute deelgemeente_naam="Niet te lokaliseren".
compute gemeente_naam="Niet te lokaliseren".
compute gemeente="99999".
compute provincie=99999.
compute statsec_naam_lang="Niet te lokaliseren".

DATASET ACTIVATE verzamelbestand.
ADD FILES /FILE=*
  /FILE='leeg'.
EXECUTE.
dataset close leeg.




SAVE TRANSLATE OUTFILE='C:\Users\plu3532\Documents\gebiedsindelingen\verwerking\gislagen\toewijzingstabel_alles.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES.


SAVE OUTFILE='C:\Users\plu3532\Documents\gebiedsindelingen\verwerking\gislagen\uitgebreide_tabel.sav'
  /COMPRESSED.

DATASET ACTIVATE verzamelbestand.
FREQUENCIES VARIABLES=statsec_naam_lengte gemeente_naam_lengte deelgemeente_naam_lengte
  /FORMAT=NOTABLE
  /STATISTICS=MAXIMUM
  /ORDER=ANALYSIS.





