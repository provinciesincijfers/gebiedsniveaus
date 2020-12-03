* Encoding: windows-1252.

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
DATASET NAME start WINDOW=FRONT.


DATASET DECLARE werkbestand.
AGGREGATE
  /OUTFILE='werkbestand'
  /BREAK=TREG_po NameTREG_po
  /N_BREAK=N.
dataset activate werkbestand.
delete variables n_break.
rename variables TREG_po=gebiedscode.
rename variables NameTREG_po=naam_kort.
string naam (a55).
compute naam=naam_kort.
compute volgnr=$casenum.
alter type volgnr (f8.0).

match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.


SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\TREG_po.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

dataset close start.




