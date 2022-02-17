* Encoding: UTF-8.

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
DATASET NAME start WINDOW=FRONT.


DATASET DECLARE werkbestand.
AGGREGATE
  /OUTFILE='werkbestand'
  /BREAK=REFREG NameREFREG
  /N_BREAK=N.
dataset activate werkbestand.
delete variables n_break.
rename variables REFREG=gebiedscode.
rename variables NameREFREG=naam_kort.
string naam (a55).
compute naam=naam_kort.
compute volgnr=$casenum.
alter type volgnr (f8.0).

match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.


SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\REFREG.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

dataset close start.




