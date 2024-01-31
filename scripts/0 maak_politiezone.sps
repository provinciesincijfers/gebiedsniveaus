* Encoding: windows-1252.

GET DATA
  /TYPE=XLSX
  /FILE=
    'C:\github\gebiedsniveaus\kerntabellen\gemeente_politiezone.xlsx'
  /SHEET=name 'Blad1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME gem_pol WINDOW=FRONT.




DATASET DECLARE politiezone.
AGGREGATE
  /OUTFILE='politiezone'
  /BREAK=politiezone Namesamenwerkingpolitie
  /N_BREAK=N.
dataset activate politiezone.
delete variables n_break.
rename variables politiezone=gebiedscode.
rename variables Namesamenwerkingpolitie=naam_kort.
string naam (a44).
compute naam=naam_kort.
if (gebiedscode="ipz991" | gebiedscode="ipz992" | gebiedscode="ipz999" | gebiedscode="ipz993")  onbekend_gebied=1.
sort cases onbekend_gebied (a) naam (a).
compute volgnr=$casenum.
alter type volgnr (f8.0).

match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.


SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\politiezone.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

dataset close gem_pol.




