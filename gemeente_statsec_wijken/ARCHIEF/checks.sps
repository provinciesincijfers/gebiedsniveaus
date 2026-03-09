* Encoding: windows-1252.

* voeg in dit bestand de nieuwe wijken toe, en maak een kolom "nieuw" en "gecontroleerd" aan om gemakkelijk te kunnen filteren.
GET DATA
  /TYPE=XLSX
  /FILE='C:\github\gebiedsniveaus\gemeente_statsec_wijken\gemeentegedragen_wijken.xlsx'
  /SHEET=name 'basistabel'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME nieuw WINDOW=FRONT.


DATASET ACTIVATE nieuw.
FILTER OFF.
USE ALL.
SELECT IF (Nieuw = 1 & gecontroleerd=0).
EXECUTE.

DATASET DECLARE test1.
AGGREGATE
  /OUTFILE='test1'
  /BREAK=gemeentecode NAAMvandewijk GebiedscodePinC
  /N_BREAK=N.


DATASET ACTIVATE test1.
* Identify Duplicate Cases.
SORT CASES BY Gemeentecode(A) NAAMvandewijk(A).
MATCH FILES
  /FILE=*
  /BY Gemeentecode NAAMvandewijk
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


* nu zie je bovenaan dubbele namen (één naam, meerdere gebiedscodes).


* Identify Duplicate Cases.
SORT CASES BY GebiedscodePinC(A).
MATCH FILES
  /FILE=*
  /BY GebiedscodePinC
 /DROP = PrimaryLast  /FIRST=PrimaryFirst
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

* nu zie je bovenaan codes die meerdere namen hebben. Dat kan nooit!.



DATASET ACTIVATE nieuw.
* Identify Duplicate Cases.
SORT CASES BY CODSEC(A).
MATCH FILES
  /FILE=*
  /BY CODSEC
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

* nu zie je bovenaan of er niet twee keer dezelfde statsec voorkomt in het bestand.

sort cases codsec (a).
rename variables codsec=gebiedscode.

GET DATA
  /TYPE=XLSX
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\statsec.xlsx'
  /SHEET=name 'statsec'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME statsec WINDOW=FRONT.
sort cases gebiedscode (a).

* cases van beide laten staan, zodat je ziet waar er gekke nieuwe rijen zijn in de twee richtingen.
DATASET ACTIVATE statsec.
MATCH FILES /FILE=*
  /FILE='nieuw'
  /BY gebiedscode.
EXECUTE.
