* Encoding: windows-1252.

GET DATA
  /TYPE=XLS
  /FILE=
    'C:\github\gebiedsniveaus\kerntabellen\kerntabel.xls'
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


* uitzonderlijk, omdat ggw7 combinatie is van twee kerntabellen!.
GET DATA
  /TYPE=XLSX
  /FILE=
    'C:\github\gebiedsniveaus\kerntabellen\statsec_ggw7_readonly.xlsx'
  /SHEET=name 'statsec_ggw7_readonly'
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



GET DATA
  /TYPE=XLS
  /FILE=
    'C:\github\gebiedsniveaus\kerntabellen\gemeente2018_arrondiss2018.xls'
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
    'C:\github\gebiedsniveaus\kerntabellen\gemeente_arrondiss.xls'
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
    'C:\github\gebiedsniveaus\kerntabellen\gemeente_fogem.xls'
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
    'C:\github\gebiedsniveaus\kerntabellen\gemeente_politiezone.xlsx'
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
    'C:\github\gebiedsniveaus\kerntabellen\provincie_gewest.xls'
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
    'C:\github\gebiedsniveaus\kerntabellen\gemeente_elz.xls'
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
    'C:\github\gebiedsniveaus\kerntabellen\gemeente_uitrustingsniveau.xlsx'
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
    'C:\github\gebiedsniveaus\kerntabellen\gemeente_uitrustingsgraad.xlsx'
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
    'C:\github\gebiedsniveaus\kerntabellen\gemeente_logo.xlsx'
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
    'C:\github\gebiedsniveaus\kerntabellen\gemeente_vervoerregio.xlsx'
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
    'C:\github\gebiedsniveaus\kerntabellen\statsec_treg.xlsx'
  /SHEET=name 'Blad1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME treg WINDOW=FRONT.
match files
/file=*
/keep=statsec treg.
sort cases statsec (a).
DATASET ACTIVATE kerntabel.
sort cases statsec (a).
MATCH FILES /FILE=*
  /TABLE='treg'
  /BY statsec.
EXECUTE.
dataset close treg.



GET DATA
  /TYPE=XLSX
  /FILE=
    'C:\github\gebiedsniveaus\kerntabellen\statsec_treg_po.xlsx'
  /SHEET=name 'Blad1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME treg WINDOW=FRONT.
match files
/file=*
/keep=statsec treg_po.
sort cases statsec (a).
DATASET ACTIVATE kerntabel.
sort cases statsec (a).
MATCH FILES /FILE=*
  /TABLE='treg'
  /BY statsec.
EXECUTE.
dataset close treg.


GET DATA
  /TYPE=XLSX
  /FILE=
    'C:\github\gebiedsniveaus\kerntabellen\gemeente_treg_gem.xlsx'
  /SHEET=name 'Blad1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME treggem WINDOW=FRONT.
match files
/file=*
/keep=gemeente treg_gem.
sort cases gemeente (a).
DATASET ACTIVATE kerntabel.
sort cases gemeente (a).
MATCH FILES /FILE=*
  /TABLE='treggem'
  /BY gemeente.
EXECUTE.
dataset close treggem.

alter type vervoerregio (a2).
compute vervoerregio=ltrim(rtrim(vervoerregio)).
EXECUTE.

GET DATA
  /TYPE=XLSX
  /FILE=
    'C:\github\gebiedsniveaus\kerntabellen\gemeente_refreg.xlsx'
  /SHEET=name 'Blad1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME refreg WINDOW=FRONT.
match files
/file=*
/keep=gemeente refreg.
sort cases gemeente (a).
DATASET ACTIVATE kerntabel.
sort cases gemeente (a).
MATCH FILES /FILE=*
  /TABLE='refreg'
  /BY gemeente.
EXECUTE.
dataset close refreg.



GET DATA
  /TYPE=XLSX
  /FILE='C:\github\gebiedsniveaus\kerntabellen\gewest_belgie.xlsx'
  /SHEET=name 'Blad1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME belgie WINDOW=FRONT.
match files
/file=*
/keep=gewest belgie.
sort cases gewest (a).
DATASET ACTIVATE kerntabel.
sort cases gewest (a).
MATCH FILES /FILE=*
  /TABLE='belgie'
  /BY gewest.
EXECUTE.
dataset close belgie.



GET DATA
  /TYPE=XLSX
  /FILE='C:\github\gebiedsniveaus\kerntabellen\gemeente_woonmaatschappij.xlsx'
  /SHEET=name 'Blad1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME woonmaatschappij WINDOW=FRONT.
match files
/file=*
/keep=gemeente woonmaatschappij.
sort cases gemeente (a).
DATASET ACTIVATE kerntabel.
sort cases gemeente (a).
MATCH FILES /FILE=*
  /TABLE='woonmaatschappij'
  /BY gemeente.
EXECUTE.
dataset close woonmaatschappij.


GET DATA
  /TYPE=XLSX
  /FILE='C:\github\gebiedsniveaus\kerntabellen\ggw7_ELZantw.xlsx'
  /SHEET=name 'Sheet1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME elzantw WINDOW=FRONT.
match files
/file=*
/keep=ggw7 elzantw.
alter type ggw7 (a11).
sort cases ggw7 (a).
DATASET ACTIVATE kerntabel.
sort cases ggw7 (a).
MATCH FILES /FILE=*
  /TABLE='elzantw'
  /BY ggw7.
EXECUTE.
dataset close elzantw.



GET DATA
  /TYPE=XLSX
  /FILE='C:\github\gebiedsniveaus\kerntabellen\gemeente_streekwerking.xlsx'
  /SHEET=name 'Blad1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME streekwerking WINDOW=FRONT.
match files
/file=*
/keep=gemeente streekwerking.
sort cases gemeente (a).
DATASET ACTIVATE kerntabel.
sort cases gemeente (a).
MATCH FILES /FILE=*
  /TABLE='streekwerking'
  /BY gemeente.
EXECUTE.
dataset close streekwerking.




SAVE OUTFILE='C:\github\gebiedsniveaus\verzamelbestanden\verwerkt_alle_gebiedsniveaus.sav'
  /COMPRESSED.


SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\verzamelbestanden\verwerkt_alle_gebiedsniveaus.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

* voor het gebruik van deze tabel, zie "https://github.com/provinciesincijfers/gebiedsniveaus/blob/master/gebiedsniveaus_voorstellen_verwerken.md", hoofdstuk "toevoegen van gebiedsniveaus".

dataset copy statsec.
dataset activate statsec.

delete variables statsec2019 gemeente2018 arrondiss2018.

* Identify Duplicate Cases.
SORT CASES BY statsec(A).
MATCH FILES
  /FILE=*
  /BY statsec
  /FIRST=PrimaryFirst
  /LAST=PrimaryLast.
DO IF (PrimaryFirst).
COMPUTE  MatchSequence=1-PrimaryLast.
ELSE.
COMPUTE  MatchSequence=MatchSequence+1.
END IF.
LEAVE  MatchSequence.
FORMATS  MatchSequence (f7).
MATCH FILES
  /FILE=*
  /DROP=PrimaryFirst  MatchSequence.
EXECUTE.

FILTER OFF.
USE ALL.
SELECT IF (PrimaryLast = 1).
EXECUTE.

DELETE VARIABLES PrimaryLast.

SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\verzamelbestanden\statsec_als_basis.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/REPLACE.

* versie voor geometrie.
string ggwtonbekendtest (a3).
compute ggwtonbekendtest=CHAR.SUBSTR(ggw7,6,3).
EXECUTE.
string DGCHECK (a4).
COMPUTE DGCHECK=CHAR.SUBSTR(deelgemeente,6,4).

if ggwtonbekendtest="ONB" ggw7="NULL".
if DGCHECK="ONBE" deelgemeente="NULL".

SAVE TRANSLATE OUTFILE='C:\temp\statsec_voor_geo.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/REPLACE.



dataset activate kerntabel.
dataset close statsec.
dataset copy statsec2019.
dataset activate statsec2019.

* de rij met de kustsector deleten.
if char.index(statsec,"X0JQ")>0 | char.index(statsec,"X1JQ")>0 delete=1.
* de lege rij deleten.
if statsec2019="" delete=1.
execute.

DATASET ACTIVATE statsec2019.
FILTER OFF.
USE ALL.
SELECT IF (missing(delete)).
EXECUTE.

delete variables statsec delete.


SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\verzamelbestanden\statsec2019_als_basis.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/REPLACE.

dataset activate kerntabel.
dataset close statsec2019.




**EINDE DEEL 1











**BEGIN DEEL 2














* AGGREGATIETABELLEN.


DATASET ACTIVATE kerntabel.
DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=statsec2019 statsec
  /N_BREAK=N.
DATASET ACTIVATE ag1.
* de nieuwe strandsectoren zouden kunnen aggregeren naar de oude gebied onbekend. Maar uiteraard willen we de OUDE gebied onbekend NIET laten aggregeren naar de strandsectoren.
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\statsec2019_statsec.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\statsec_deelgemeente.xlsx'
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
* Voor "deelgemeente onbekend" kan je eigenlijk niet correct aggregeren. In de nieuwe fusies is er immers een enkel gebied onbekend, terwijl er in de oude gemeenten twee of drie waren binnen de huidige fusie.
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\deelgemeente_gemeente2018.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\gemeente2018_gemeente.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\gemeente2018_arrondiss2018.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\arrondiss2018_provincie.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\provincie_gewest.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\deelgemeente_gemeente.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\gemeente_arrondiss.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\arrondiss_provincie.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\gemeente_fo_gem.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\gemeente_politiezone.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\gemeente_uitrustingsniveau.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\gemeente_uitrustingsgraad.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\gemeente_elz.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\fo_gem_gewest.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\politiezone_gewest.xlsx'
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

SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\uitrustingsniveau_gewest.xlsx'
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

SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\uitrustingsgraad_gewest.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\elz_gewest.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\gemeente_logo.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\logo_provincie.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\gemeente_provincie.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\politiezone_provincie.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\gemeente_vervoerregio.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\vervoerregio_gewest.xlsx'
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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\statsec_gemeente.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.



*treg.
DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=statsec treg
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
FILTER OFF.
USE ALL.
SELECT IF (treg ~="").
EXECUTE.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\statsec_treg.xlsx'
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
  /BREAK=treg provincie
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
FILTER OFF.
USE ALL.
SELECT IF (treg ~="").
EXECUTE.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\treg_provincie.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.



*treg_po.
DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=statsec treg_po
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
FILTER OFF.
USE ALL.
SELECT IF (treg_po ~="").
EXECUTE.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\statsec_treg_po.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.

*treg_po_gewest: verwijderd want gaf problemen bij data ingelezen op subgemeentelijk niveau. Deze werden niet correct geaggregeerd naar gewest niveau.
*DATASET DECLARE ag1.
*AGGREGATE
  */OUTFILE='ag1'
  /BREAK=treg_po gewest
  /N_BREAK=N.
*dataset activate ag1.
*delete variables n_break.
*FILTER OFF.
*USE ALL.
*SELECT IF (treg_po ~="").
*EXECUTE.
*SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\treg_po_gewest.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
*DATASET ACTIVATE kerntabel.


*treg_gem.

DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=gemeente treg_gem
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
FILTER OFF.
USE ALL.
SELECT IF (treg_gem ~="").
EXECUTE.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\gemeente_treg_gem.xlsx'
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
  /BREAK=treg_gem provincie
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
FILTER OFF.
USE ALL.
SELECT IF (treg_gem ~="").
EXECUTE.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\treg_gem_provincie.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.


*refreg.

DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=gemeente refreg
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
FILTER OFF.
USE ALL.
SELECT IF (refreg ~="").
EXECUTE.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\gemeente_refreg.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.


*referentieregio's bouwen niet meer op tot provincies (cfr zwijndrecht)

*DATASET DECLARE ag1.
*AGGREGATE
  /OUTFILE='ag1'
  /BREAK=refreg provincie
  /N_BREAK=N.
*dataset activate ag1.
*delete variables n_break.
*FILTER OFF.
*USE ALL.
*SELECT IF (refreg ~="").
*EXECUTE.
*SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\refreg_provincie.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.


DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=refreg gewest
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
FILTER OFF.
USE ALL.
SELECT IF (refreg ~="").
EXECUTE.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\refreg_gewest.xlsx'
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
  /BREAK=gewest belgie
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
FILTER OFF.
USE ALL.
SELECT IF (gewest ~="").
EXECUTE.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\gewest_belgie.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

DATASET ACTIVATE kerntabel.
dataset close aggkerntabel.
dataset close ag1.



*woonmaatschappij.

DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=gemeente woonmaatschappij
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
FILTER OFF.
USE ALL.
SELECT IF (werkingsgebied_woonmaatschappij > -1).
EXECUTE.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\gemeente_woonmaatschappij.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.

* woonmaatschappij aggregeert NIET naar provincie.

DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=woonmaatschappij gewest
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
FILTER OFF.
USE ALL.
SELECT IF (woonmaatschappij>-1).
EXECUTE.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\woonmaatschappij_gewest.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.


* elzantw.


DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=ggw7 elzantw
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
FILTER OFF.
USE ALL.
SELECT IF (elzantw >-1).
EXECUTE.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\ggw7_elzantw.xlsx'
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
  /BREAK=elzantw elz
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
FILTER OFF.
USE ALL.
SELECT IF (elzantw ~="").
EXECUTE.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\elzantw_elz.xlsx'
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
  /BREAK=statsec provincie
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
FILTER OFF.
USE ALL.
SELECT IF (statsec ~="").
EXECUTE.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\statsec_provincie.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE kerntabel.


*streekwerking

DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=gemeente streekwerking
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
FILTER OFF.
USE ALL.
SELECT IF (streekwerking ~="").
EXECUTE.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\gemeente_streekwerking.xlsx'
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
  /BREAK=streekwerking provincie
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
FILTER OFF.
USE ALL.
SELECT IF (streekwerking ~="").
EXECUTE.
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\streekwerking_provincie.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
