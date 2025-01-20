* Encoding: windows-1252.
GET DATA
  /TYPE=XLS
  /FILE=
    'C:\github\gebiedsniveaus\kerntabellen\gemeente2018_arrondiss2018.xls'
  /SHEET=name 'gemeente_arrondiss'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0.
EXECUTE.
DATASET NAME gemeente_arrondiss WINDOW=FRONT.



DATASET DECLARE arrondiss.
AGGREGATE
  /OUTFILE='arrondiss'
  /BREAK=arrondiss2018 Namebestuurlijkarrondissement2018
  /N_BREAK=N.
dataset activate arrondiss.
delete variables n_break.
rename variables arrondiss2018=gebiedscode.
rename variables Namebestuurlijkarrondissement2018=naam_kort.
string naam (a44).
compute naam=naam_kort.
if gebiedscode>99989 onbekend_gebied=1.
sort cases onbekend_gebied (a) naam (a).
compute volgnr=$casenum.
alter type volgnr (f8.0).

match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.


SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\arrondiss2018.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.


dataset close gemeente_arrondiss.


*!!! pas de kolomhoofden nog manueel aan van volgnr gebiedscode  naam_kort en naam naar: sequencenr    geoitem code    short name    name in de file voor richard. . 

