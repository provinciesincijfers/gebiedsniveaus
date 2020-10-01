* Encoding: windows-1252.


GET DATA
  /TYPE=XLS
  /FILE='C:\github\gebiedsniveaus\kerntabellen\gemeente_fogem.xls'
  /SHEET=name 'gemeente_fogem'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0.
EXECUTE.
DATASET NAME gem_fogem WINDOW=FRONT.




DATASET DECLARE fogem.
AGGREGATE
  /OUTFILE='fogem'
  /BREAK=fo_gem Namefo_gem
  /N_BREAK=N.
dataset activate fogem.
delete variables n_break.
rename variables fo_gem=gebiedscode.
rename variables Namefo_gem=naam_kort.
string naam (a44).
compute naam=naam_kort.
compute volgnr=$casenum.
alter type volgnr (f8.0).

match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.




SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\fo_gem.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.


dataset close gem_fogem.
