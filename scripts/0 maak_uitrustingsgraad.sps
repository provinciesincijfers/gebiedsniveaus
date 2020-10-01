* Encoding: windows-1252.

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
DATASET NAME start WINDOW=FRONT.


DATASET DECLARE uitrustingsgraad.
AGGREGATE
  /OUTFILE='uitrustingsgraad'
  /BREAK=uitrustingsgraad Nameuitrustingsgraad
  /N_BREAK=N.
dataset activate uitrustingsgraad.
delete variables n_break.
rename variables uitrustingsgraad=gebiedscode.
rename variables Nameuitrustingsgraad=naam_kort.
string naam (a61).
compute naam=naam_kort.
compute volgnr=$casenum.
alter type volgnr (f8.0).

match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.


SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\uitrustingsgraad.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

dataset close start.




