* Encoding: windows-1252.

GET DATA
  /TYPE=XLS
  /FILE=
    'C:\temp\gebiedsniveaus\kerntabellen\kerntabel.xls'
  /SHEET=name 'toewijzingstabel_alles'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0.
EXECUTE.
DATASET NAME kerntabel WINDOW=FRONT.

match files
/file=*
/keep=statsec statsec2019
deelgemeente
gemeente2018
gemeente
provincie.


GET DATA
  /TYPE=XLS
  /FILE=
    'C:\temp\gebiedsniveaus\kerntabellen\gemeente2018_arrondiss2018.xls'
  /SHEET=name 'gemeente_arrondiss'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0.
EXECUTE.
DATASET NAME gemeente_arrondiss WINDOW=FRONT.
match files
/file=*
/keep=gemeente2018 arrondiss2018.
sort cases gemeente2018 (a).
DATASET ACTIVATE kerntabel.
sort cases gemeente2018 (a).
MATCH FILES /FILE=*
  /TABLE='gemeente_arrondiss'
  /BY gemeente2018.
EXECUTE.
dataset close gemeente_arrondiss.



GET DATA
  /TYPE=XLS
  /FILE=
    'C:\temp\gebiedsniveaus\kerntabellen\gemeente_arrondiss.xls'
  /SHEET=name 'gemeente_arrondiss'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0.
EXECUTE.
DATASET NAME gemeente_arrondis WINDOW=FRONT.
match files
/file=*
/keep=gemeente arrondiss.
sort cases gemeente (a).
DATASET ACTIVATE kerntabel.
sort cases gemeente (a).
MATCH FILES /FILE=*
  /TABLE='gemeente_arrondis'
  /BY gemeente.
EXECUTE.
dataset close gemeente_arrondis.



GET DATA
  /TYPE=XLS
  /FILE=
    'C:\temp\gebiedsniveaus\kerntabellen\gemeente_fogem.xls'
  /SHEET=name 'gemeente_fogem'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0.
EXECUTE.
DATASET NAME fogem WINDOW=FRONT.
match files
/file=*
/keep=gemeente fo_gem.
sort cases gemeente (a).
DATASET ACTIVATE kerntabel.
sort cases gemeente (a).
MATCH FILES /FILE=*
  /TABLE='fogem'
  /BY gemeente.
EXECUTE.
dataset close fogem.




GET DATA
  /TYPE=XLSX
  /FILE=
    'C:\temp\gebiedsniveaus\kerntabellen\gemeente_politiezone.xlsx'
  /SHEET=name 'Blad1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME politiezone WINDOW=FRONT.
match files
/file=*
/keep=gemeente politiezone.
sort cases gemeente (a).
DATASET ACTIVATE kerntabel.
sort cases gemeente (a).
MATCH FILES /FILE=*
  /TABLE='politiezone'
  /BY gemeente.
EXECUTE.
dataset close politiezone.



GET DATA
  /TYPE=XLS
  /FILE=
    'C:\temp\gebiedsniveaus\kerntabellen\provincie_gewest.xls'
  /SHEET=name 'Blad1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0.
EXECUTE.
DATASET NAME gewest WINDOW=FRONT.
match files
/file=*
/keep=provincie gewest.
sort cases provincie (a).
DATASET ACTIVATE kerntabel.
sort cases provincie (a).
MATCH FILES /FILE=*
  /TABLE='gewest'
  /BY provincie.
EXECUTE.
dataset close gewest.



GET DATA
  /TYPE=XLS
  /FILE=
    'C:\temp\gebiedsniveaus\kerntabellen\gemeente_elz.xls'
  /SHEET=name 'Blad1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0.
EXECUTE.
DATASET NAME elz WINDOW=FRONT.
match files
/file=*
/keep=gemeente elz.
sort cases gemeente (a).
DATASET ACTIVATE kerntabel.
sort cases gemeente (a).
MATCH FILES /FILE=*
  /TABLE='elz'
  /BY gemeente.
EXECUTE.
dataset close elz.



GET DATA
  /TYPE=XLSX
  /FILE=
    'C:\temp\gebiedsniveaus\kerntabellen\gemeente_uitrustingsniveau.xlsx'
  /SHEET=name 'Blad1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME uitrustingsniveau WINDOW=FRONT.
match files
/file=*
/keep=gemeente uitrustingsniveau.
sort cases gemeente (a).
DATASET ACTIVATE kerntabel.
sort cases gemeente (a).
MATCH FILES /FILE=*
  /TABLE='uitrustingsniveau'
  /BY gemeente.
EXECUTE.
dataset close uitrustingsniveau.


GET DATA
  /TYPE=XLSX
  /FILE=
    'C:\temp\gebiedsniveaus\kerntabellen\gemeente_uitrustingsgraad.xlsx'
  /SHEET=name 'Blad1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME uitrustingsgraad WINDOW=FRONT.
match files
/file=*
/keep=gemeente uitrustingsgraad.
sort cases gemeente (a).
DATASET ACTIVATE kerntabel.
sort cases gemeente (a).
MATCH FILES /FILE=*
  /TABLE='uitrustingsgraad'
  /BY gemeente.
EXECUTE.
dataset close uitrustingsgraad.

GET DATA
  /TYPE=XLSX
  /FILE=
    'C:\temp\gebiedsniveaus\kerntabellen\gemeente_logo.xlsx'
  /SHEET=name 'Blad1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME logo WINDOW=FRONT.
match files
/file=*
/keep=gemeente logo.
sort cases gemeente (a).
DATASET ACTIVATE kerntabel.
sort cases gemeente (a).
MATCH FILES /FILE=*
  /TABLE='logo'
  /BY gemeente.
EXECUTE.
dataset close logo.






GET DATA
  /TYPE=XLSX
  /FILE=
    'C:\temp\gebiedsniveaus\kerntabellen\gemeente_vervoerregio.xlsx'
  /SHEET=name 'Blad1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME vervoer WINDOW=FRONT.
match files
/file=*
/keep=gemeente vervoerregio.
sort cases gemeente (a).
DATASET ACTIVATE kerntabel.
sort cases gemeente (a).
MATCH FILES /FILE=*
  /TABLE='vervoer'
  /BY gemeente.
EXECUTE.
dataset close vervoer.




GET DATA
  /TYPE=XLSX
  /FILE=
    'C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\statsec_ggw7.xlsx'
  /SHEET=name 'statsec_ggw7'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME ggw7 WINDOW=FRONT.
match files
/file=*
/keep=statsec ggw7.
sort cases statsec (a).
DATASET ACTIVATE kerntabel.
sort cases statsec (a).
MATCH FILES /FILE=*
  /TABLE='ggw7'
  /BY statsec.
EXECUTE.
dataset close ggw7.





SAVE OUTFILE='C:\temp\gebiedsniveaus\kerntabellen\verwerkt_alle_gebiedsniveaus.sav'
  /COMPRESSED.


SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\kerntabellen\verwerkt_alle_gebiedsniveaus.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

* voor het gebruik van deze tabel, zie "gebiedsindelingen voorstellen.docx", hoofdstuk "toevoegen van gebiedsniveaus".









































* AGGREGATIETABELLEN.


DATASET ACTIVATE kerntabel.
DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=statsec2019 statsec
  /N_BREAK=N.
DATASET ACTIVATE ag1.
* verwijder stukjes kust uit de nieuwe versie die in de oude versie in onbekend zouden zitten.
if char.substr(statsec2019,6,4)="ZZZZ" & char.substr(statsec2019,6,4)~=char.substr(statsec,6,4) teverwijderen=1.
FILTER OFF.
USE ALL.
SELECT IF (missing(teverwijderen)).
EXECUTE.
* verwijder volledig nieuwe statsec.
FILTER OFF.
USE ALL.
SELECT IF (statsec2019 ~= "").
EXECUTE.
delete variables n_break teverwijderen.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\statsec2019_statsec.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.



DATASET ACTIVATE kerntabel.
DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=statsec deelgemeente
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\statsec_deelgemeente.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.

DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=deelgemeente gemeente2018
  /N_BREAK=N.
dataset activate ag1.
* Voor �deelgemeente onbekend� kan je eigenlijk niet correct aggregeren. In de nieuwe fusies is er immers een enkel gebied onbekend, terwijl er in de oude gemeenten twee of drie waren binnen de huidige fusie.
* Om dit op te lossen, kennen we het nieuwe gebied onbekend toe aan de gemeente die voor de fusie het grootst was. Hierote verwijderen we de overbodige records uit het bestand.
if deelgemeente='12041ONBE' & gemeente2018=12034 teverwijderen=1.
if deelgemeente='44083ONBE' & gemeente2018=44049 teverwijderen=1.
if deelgemeente='44084ONBE' & gemeente2018=44029 teverwijderen=1.
if deelgemeente='44085ONBE' & gemeente2018=44072 teverwijderen=1.
if deelgemeente='44085ONBE' & gemeente2018=44080 teverwijderen=1.
if deelgemeente='45068ONBE' & gemeente2018=45057 teverwijderen=1.
if deelgemeente='72042ONBE' & gemeente2018=71047 teverwijderen=1.
if deelgemeente='72043ONBE' & gemeente2018=72029 teverwijderen=1.
EXECUTE.
FILTER OFF.
USE ALL.
SELECT IF (missing(teverwijderen)).
EXECUTE.
delete variables n_break teverwijderen.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\deelgemeente_gemeente2018.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.



DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=gemeente2018 gemeente
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\gemeente2018_gemeente.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.



DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=gemeente2018 arrondiss2018
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\gemeente2018_arrondiss2018.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.



DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=arrondiss2018 provincie
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\arrondiss2018_provincie.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.




DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=provincie gewest
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\provincie_gewest.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.



DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=deelgemeente gemeente
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\deelgemeente_gemeente.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.




DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=gemeente arrondiss
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\gemeente_arrondiss.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.


DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=arrondiss provincie
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\arrondiss_provincie.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.

DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=gemeente fo_gem
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
DATASET ACTIVATE ag1.
FILTER OFF.
USE ALL.
SELECT IF (fo_gem ~= "").
EXECUTE.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\gemeente_fo_gem.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.



DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=gemeente politiezone
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\gemeente_politiezone.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.



DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=gemeente uitrustingsniveau
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
DATASET ACTIVATE ag1.
FILTER OFF.
USE ALL.
SELECT IF (uitrustingsniveau ~= "").
EXECUTE.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\gemeente_uitrustingsniveau.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.



DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=gemeente uitrustingsgraad
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
DATASET ACTIVATE ag1.
FILTER OFF.
USE ALL.
SELECT IF (uitrustingsgraad ~= "").
EXECUTE.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\gemeente_uitrustingsgraad.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.


DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=gemeente elz
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\gemeente_elz.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.





DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=fo_gem gewest
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
FILTER OFF.
USE ALL.
SELECT IF (fo_gem ~= "").
EXECUTE.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\fo_gem_gewest.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.




DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=politiezone gewest
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\politiezone_gewest.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.



DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=uitrustingsniveau gewest
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.

* enkele zijn leeg wegens Brussel of gebied onbekend.
FILTER OFF.
USE ALL.
SELECT IF (uitrustingsniveau ~= "").
EXECUTE.

SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\uitrustingsniveau_gewest.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.



DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=uitrustingsgraad gewest
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.

* enkele zijn leeg wegens Brussel of gebied onbekend.
FILTER OFF.
USE ALL.
SELECT IF (uitrustingsgraad ~= "").
EXECUTE.

SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\uitrustingsgraad_gewest.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.


DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=elz gewest
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\elz_gewest.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.



DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=elz gewest
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\elz_gewest.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.



DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=gemeente logo
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
DATASET ACTIVATE ag1.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\gemeente_logo.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.



DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=logo provincie
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
DATASET ACTIVATE ag1.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\logo_provincie.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.



DATASET ACTIVATE kerntabel.


* om swing te helpen.
DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=gemeente provincie
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\gemeente_provincie.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.


* om swing te helpen.
DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=politiezone provincie
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\politiezone_provincie.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.




* nieuw toegevoegd vervoerregio.
DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=gemeente vervoerregio
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
FILTER OFF.
USE ALL.
SELECT IF (vervoerregio >-1).
EXECUTE.

DATASET ACTIVATE ag1.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\gemeente_vervoerregio.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.


DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=vervoerregio gewest
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
FILTER OFF.
USE ALL.
SELECT IF (vervoerregio >-1).
EXECUTE.

DATASET ACTIVATE ag1.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\vervoerregio_gewest.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.


* om swing te helpen.
DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=statsec gemeente
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\statsec_gemeente.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.

DATASET ACTIVATE kerntabel.
DATASET DECLARE aggkerntabel.
AGGREGATE
  /OUTFILE='aggkerntabel'
  /BREAK=statsec
  /N_BREAK=N.