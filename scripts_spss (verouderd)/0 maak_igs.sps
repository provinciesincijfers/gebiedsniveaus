* Encoding: windows-1252.

GET DATA
  /TYPE=XLSX
  /FILE=
    'C:\github\gebiedsniveaus\kerntabellen\gemeente_igs.xlsx'
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
  /BREAK=igs Nameigs
  /N_BREAK=N.
dataset activate werkbestand.
delete variables n_break.
rename variables igs=gebiedscode.
rename variables Nameigs=naam_kort.
string naam (a55).
compute naam=naam_kort.
compute volgnr=$casenum.
alter type volgnr (f8.0).

match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.


SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\igs.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

dataset close start.



*!!! pas de kolomhoofden nog manueel aan van volgnr gebiedscode  naam_kort en naam naar: sequencenr    geoitem code    short name    name in de file voor richard. . 
