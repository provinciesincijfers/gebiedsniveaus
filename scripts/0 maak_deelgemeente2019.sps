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
DATASET DECLARE deelgemeente2019.
AGGREGATE
  /OUTFILE='deelgemeente2019'
  /BREAK=deelgemeente2019 deelgemeente2019_naam deelgemeente2019_naam_kort
  /N_BREAK=N.
dataset activate deelgemeente2019.
delete variables n_break.
rename variables deelgemeente2019=gebiedscode.
rename variables deelgemeente2019_naam_kort=naam_kort.
rename variables deelgemeente2019_naam=naam.
if char.substr(gebiedscode,1,4)="9999" onbekend_gebied=1.
sort cases onbekend_gebied (a) naam (a).
compute volgnr=$casenum.
alter type volgnr (f8.0).

match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.


SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\deelgemeente2019.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.


dataset activate kerntabel.
dataset close deelgemeente2019.


