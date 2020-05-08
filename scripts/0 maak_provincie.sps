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
DATASET DECLARE provincie.
AGGREGATE
  /OUTFILE='provincie'
  /BREAK=provincie provincie_naam
  /N_BREAK=N.
dataset activate provincie.
delete variables n_break.
rename variables provincie=gebiedscode.
rename variables provincie_naam=naam_kort.
string naam (a44).
compute naam=naam_kort.
if gebiedscode>99989 onbekend_gebied=1.
sort cases onbekend_gebied (a) naam (a).
compute volgnr=$casenum.
alter type volgnr (f8.0).

match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.


SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\provincie.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.


dataset activate kerntabel.
dataset close provincie.



