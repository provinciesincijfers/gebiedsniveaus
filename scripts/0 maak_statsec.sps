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

DATASET DECLARE nieuw.
AGGREGATE
  /OUTFILE='nieuw'
  /BREAK=statsec statsec_naam statsec_naam_lang
  /N_BREAK=N.
dataset activate nieuw.


delete variables n_break.
rename variables statsec=gebiedscode.
rename variables statsec_naam=naam_kort.
rename variables statsec_naam_lang=naam.
if char.substr(gebiedscode,1,4)="9999" onbekend_gebied=1.
sort cases onbekend_gebied (a) naam (a).
compute volgnr=$casenum.
alter type volgnr (f8.0).

match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.

DATASET ACTIVATE nieuw.
COMPUTE lengte=length(ltrim(rtrim(naam_kort))).
if lengte>50 naam_kort=concat(char.substr(naam_kort,1,47),"...").
EXECUTE.
delete variables lengte.


SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\statsec.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

dataset activate kerntabel.
dataset close nieuw.


*!!! pas de kolomhoofden nog manueel aan van volgnr gebiedscode  naam_kort en naam naar: sequencenr    geoitem code    short name    name in de file voor richard. . 
