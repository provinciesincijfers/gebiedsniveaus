* Encoding: windows-1252.

GET DATA
  /TYPE=XLSX
  /FILE=
    'C:\github\gebiedsniveaus\kerntabellen\gemeente_woonmaatschappij.xlsx'
  /SHEET=name 'Blad1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0.
EXECUTE.
DATASET NAME start WINDOW=FRONT.





DATASET DECLARE woonmaatschappij.
AGGREGATE
  /OUTFILE='woonmaatschappij'
  /BREAK=woonmaatschappij Namewoonmaatschappij
  /N_BREAK=N.
dataset activate woonmaatschappij.
delete variables n_break.
rename variables woonmaatschappij=gebiedscode.
rename variables Namewoonmaatschappij=naam_kort.
string naam (a55).
compute naam=naam_kort.
if (gebiedscode=91 | gebiedscode=92 | gebiedscode=99)  onbekend_gebied=1.
sort cases onbekend_gebied (a) naam (a).
compute volgnr=$casenum.
alter type volgnr (f8.0).

match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.


SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\woonmaatschappij.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

dataset close start.





