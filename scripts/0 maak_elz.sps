* Encoding: windows-1252.

GET DATA
  /TYPE=XLS
  /FILE=
    'C:\github\gebiedsniveaus\kerntabellen\gemeente_elz.xls'
  /SHEET=name 'Blad1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0.
EXECUTE.
DATASET NAME start WINDOW=FRONT.





DATASET DECLARE elz.
AGGREGATE
  /OUTFILE='elz'
  /BREAK=elz Nameelz
  /N_BREAK=N.
dataset activate elz.
delete variables n_break.
rename variables elz=gebiedscode.
rename variables Nameelz=naam_kort.
string naam (a55).
compute naam=naam_kort.
if (gebiedscode="elz91" | gebiedscode="elz92" | gebiedscode="elz99")  onbekend_gebied=1.
sort cases onbekend_gebied (a) naam (a).
compute volgnr=$casenum.
alter type volgnr (f8.0).

match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.


SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\elz.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

dataset close start.





