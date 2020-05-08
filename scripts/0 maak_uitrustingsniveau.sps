* Encoding: windows-1252.

GET DATA
  /TYPE=XLSX
  /FILE=
    'C:\temp\gebiedsniveaus\kerntabellen\gemeente_uitrustingsniveau.xlsx'
  /SHEET=name 'Blad1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME start WINDOW=FRONT.


DATASET DECLARE uitrustingsniveau.
AGGREGATE
  /OUTFILE='uitrustingsniveau'
  /BREAK=uitrustingsniveau Nameuitrustingsniveau
  /N_BREAK=N.
dataset activate uitrustingsniveau.
delete variables n_break.
rename variables uitrustingsniveau=gebiedscode.
rename variables Nameuitrustingsniveau=naam_kort.
string naam (a55).
compute naam=naam_kort.
compute volgnr=$casenum.
alter type volgnr (f8.0).

match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.


SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\uitrustingsniveau.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

dataset close start.




