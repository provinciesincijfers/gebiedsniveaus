* Encoding: windows-1252.



GET DATA
  /TYPE=XLS
  /FILE=
    'C:\github\gebiedsniveaus\kerntabellen\provincie_gewest.xls'
  /SHEET=name 'Blad1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0.
EXECUTE.
DATASET NAME tabel WINDOW=FRONT.



DATASET DECLARE gewest.
AGGREGATE
  /OUTFILE='gewest'
  /BREAK=gewest Namegewest
  /N_BREAK=N.
dataset activate gewest.
delete variables n_break.
rename variables gewest=gebiedscode.
rename variables Namegewest=naam_kort.
string naam (a44).
compute naam=naam_kort.
if gebiedscode>99989 onbekend_gebied=1.
sort cases gebiedscode (a).
compute volgnr=$casenum.
alter type volgnr (f8.0).

match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.


SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\gewest.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

dataset close tabel.



*!!! pas de kolomhoofden nog manueel aan van volgnr gebiedscode  naam_kort en naam naar: sequencenr    geoitem code    short name    name. 


