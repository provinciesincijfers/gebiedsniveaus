* Encoding: windows-1252.

* enkel wanneer gebied onbekend bij meerdere deelgemeenten voorkomt

GET DATA
  /TYPE=XLS
  /FILE=
    'C:\github\gebiedsniveaus\kerntabellen\kerntabel.xls'
  /SHEET=name 'toewijzingstabel_alles'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0.
EXECUTE.
DATASET NAME kerntabel WINDOW=FRONT.

DATASET ACTIVATE kerntabel.
DATASET DECLARE dgtel.
AGGREGATE
  /OUTFILE='dgtel'
  /BREAK=deelgemeente gemeente
  /N_BREAK=N.
dataset activate dgtel.


DATASET ACTIVATE dgtel.
AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=gemeente
  /tel_gemeente=N.

FILTER OFF.
USE ALL.
SELECT IF (tel_gemeente = 2).
EXECUTE.

FILTER OFF.
USE ALL.
SELECT IF (N_BREAK = 1).
EXECUTE.

match files
/file=*
/keep=deelgemeente tel_gemeente.
EXECUTE.

sort cases deelgemeente (a).

dataset activate kerntabel.
sort cases deelgemeente (a).

DATASET ACTIVATE kerntabel.
MATCH FILES /FILE=*
  /TABLE='dgtel'
  /BY deelgemeente.
EXECUTE.

dataset close dgtel.

do if tel_gemeente=2 & lag(gemeente)=gemeente.
compute deelgemeente=lag(deelgemeente).
compute deelgemeente_naam_kort=lag(deelgemeente_naam_kort).
compute deelgemeente_naam=lag(deelgemeente_naam).
compute aangepast=1.
else.
end if.
EXECUTE.


* oude deelgemeente.
delete variables aangepast tel_gemeente.
sort cases statsec (a).


DATASET ACTIVATE kerntabel.
DATASET DECLARE dgtel.
AGGREGATE
  /OUTFILE='dgtel'
  /BREAK=deelgemeente2019 gemeente
  /N_BREAK=N.
dataset activate dgtel.


DATASET ACTIVATE dgtel.
AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=gemeente
  /tel_gemeente=N.

FILTER OFF.
USE ALL.
SELECT IF (tel_gemeente = 2).
EXECUTE.

FILTER OFF.
USE ALL.
SELECT IF (N_BREAK = 1).
EXECUTE.

match files
/file=*
/keep=deelgemeente2019 tel_gemeente.
EXECUTE.

sort cases deelgemeente2019 (a).

dataset activate kerntabel.
sort cases deelgemeente2019 (a).

DATASET ACTIVATE kerntabel.
MATCH FILES /FILE=*
  /TABLE='dgtel'
  /BY deelgemeente2019.
EXECUTE.

dataset close dgtel.

do if tel_gemeente=2 & lag(gemeente)=gemeente.
compute deelgemeente2019=lag(deelgemeente2019).
compute deelgemeente2019_naam_kort=lag(deelgemeente2019_naam_kort).
compute deelgemeente2019_naam=lag(deelgemeente2019_naam).
compute aangepast=1.
else.
end if.
EXECUTE.

delete variables aangepast tel_gemeente.


SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\kerntabellen\kerntabel.xls'
  /TYPE=XLS
  /VERSION=8
  /MAP
  /REPLACE
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES.
