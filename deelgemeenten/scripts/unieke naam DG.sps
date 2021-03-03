* Encoding: windows-1252.

DATASET ACTIVATE DataSet1.
USE ALL.
COMPUTE filter_$=(statsec~="").
VARIABLE LABELS filter_$ 'statsec~="" (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

DATASET ACTIVATE DataSet1.
DATASET DECLARE dg19.
AGGREGATE
  /OUTFILE='dg19'
  /BREAK=deelgemeente deelgemeente_naam gemeente_naam
  /N_BREAK=N.
dataset activate dg19.

DATASET ACTIVATE dg19.
* Identify Duplicate Cases.
SORT CASES BY deelgemeente_naam(A).
MATCH FILES
  /FILE=*
  /BY deelgemeente_naam
  /FIRST=PrimaryFirst
  /LAST=PrimaryLast.
DO IF (PrimaryFirst).
COMPUTE  MatchSequence=1-PrimaryLast.
ELSE.
COMPUTE  MatchSequence=MatchSequence+1.
END IF.
LEAVE  MatchSequence.
FORMATS  MatchSequence (f7).
COMPUTE  InDupGrp=MatchSequence>0.
SORT CASES InDupGrp(D).

VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary' MatchSequence 
    'Sequential count of matching cases'.
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryLast (ORDINAL) /MatchSequence (SCALE).
FREQUENCIES VARIABLES=PrimaryLast MatchSequence.
EXECUTE.

string deelgemeente_naam_kort (a150).
compute deelgemeente_naam_kort = deelgemeente_naam.
if indupgrp=1 & char.index(ltrim(rtrim(deelgemeente_naam)),ltrim(rtrim(gemeente_naam)))=0 deelgemeente_naam_kort=concat(ltrim(rtrim(deelgemeente_naam))," (",ltrim(rtrim(gemeente_naam)),")").
EXECUTE.

string deelgemeente_naam_lang (a150).
compute deelgemeente_naam_lang = deelgemeente_naam.
if char.index(ltrim(rtrim(deelgemeente_naam)),ltrim(rtrim(gemeente_naam)))=0 deelgemeente_naam_lang=concat(ltrim(rtrim(deelgemeente_naam))," (",ltrim(rtrim(gemeente_naam)),")").
EXECUTE.





DATASET ACTIVATE DataSet1.
USE ALL.
EXECUTE.

DATASET ACTIVATE DataSet1.
DATASET DECLARE dg19.
AGGREGATE
  /OUTFILE='dg19'
  /BREAK=deelgemeente2019 deelgemeente2019_naam gemeente2018_naam
  /N_BREAK=N.
dataset activate dg19.

DATASET ACTIVATE dg19.
* Identify Duplicate Cases.
SORT CASES BY deelgemeente2019_naam(A).
MATCH FILES
  /FILE=*
  /BY deelgemeente2019_naam
  /FIRST=PrimaryFirst
  /LAST=PrimaryLast.
DO IF (PrimaryFirst).
COMPUTE  MatchSequence=1-PrimaryLast.
ELSE.
COMPUTE  MatchSequence=MatchSequence+1.
END IF.
LEAVE  MatchSequence.
FORMATS  MatchSequence (f7).
COMPUTE  InDupGrp=MatchSequence>0.
SORT CASES InDupGrp(D).

VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary' MatchSequence 
    'Sequential count of matching cases'.
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryLast (ORDINAL) /MatchSequence (SCALE).
FREQUENCIES VARIABLES=PrimaryLast MatchSequence.
EXECUTE.

string deelgemeente2019_naam_kort (a150).
compute deelgemeente2019_naam_kort = deelgemeente2019_naam.
if indupgrp=1 & char.index(ltrim(rtrim(deelgemeente2019_naam)),ltrim(rtrim(gemeente2018_naam)))=0 deelgemeente2019_naam_kort=concat(ltrim(rtrim(deelgemeente2019_naam))," (",ltrim(rtrim(gemeente2018_naam)),")").
EXECUTE.

string deelgemeente2019_naam_lang (a150).
compute deelgemeente2019_naam_lang = deelgemeente2019_naam.
if char.index(ltrim(rtrim(deelgemeente2019_naam)),ltrim(rtrim(gemeente2018_naam)))=0 deelgemeente2019_naam_lang=concat(ltrim(rtrim(deelgemeente2019_naam))," (",ltrim(rtrim(gemeente2018_naam)),")").
EXECUTE.


