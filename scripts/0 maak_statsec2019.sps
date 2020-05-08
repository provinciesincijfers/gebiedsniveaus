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

DATASET DECLARE nieuw.
AGGREGATE
  /OUTFILE='nieuw'
  /BREAK=statsec2019 statsec2019_naam statsec2019_naam_lang
  /N_BREAK=N.
dataset activate nieuw.

*OPGELET: bij aggregatie vanaf statsec2019 is er nu een lege waarde omdat 11002K1MN gesplitst wordt in 11002K1WN en 11002P6PK. 
*Maar we negeren die tweede optie en dus is er een lege cel die verwijderd moet worden als je werkt vanaf statsec2019
DATASET ACTIVATE nieuw.
FILTER OFF.
USE ALL.
SELECT IF (statsec2019 ~= "").
EXECUTE.


delete variables n_break.
rename variables statsec2019=gebiedscode.
rename variables statsec2019_naam=naam_kort.
rename variables statsec2019_naam_lang=naam.
if char.substr(gebiedscode,1,4)="9999" onbekend_gebied=1.
sort cases onbekend_gebied (a) naam (a).
compute volgnr=$casenum.
alter type volgnr (f8.0).

match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.

SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\statsec2019.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

dataset activate kerntabel.
dataset close nieuw.
