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
DATASET DECLARE deelgemeente.
AGGREGATE
  /OUTFILE='deelgemeente'
  /BREAK=deelgemeente deelgemeente_naam deelgemeente_naam_kort
  /N_BREAK=N.
dataset activate deelgemeente.
delete variables n_break.
rename variables deelgemeente=gebiedscode.
rename variables deelgemeente_naam_kort=naam_kort.
rename variables deelgemeente_naam=naam.
if char.substr(gebiedscode,1,4)="9999" onbekend_gebied=1.
sort cases onbekend_gebied (a) naam (a).
compute volgnr=$casenum.
alter type volgnr (f8.0).

match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.


SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\deelgemeente.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.


dataset activate kerntabel.
dataset close deelgemeente.


*!!! pas de kolomhoofden nog manueel aan van volgnr gebiedscode  naam_kort en naam naar: sequencenr    geoitem code    short name    name in de file voor richard. . 
