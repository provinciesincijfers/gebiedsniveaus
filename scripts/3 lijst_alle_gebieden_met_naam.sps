* Encoding: windows-1252.



GET DATA
  /TYPE=XLSX
  /FILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\arrondiss.xlsx'
  /SHEET=name 'arrondiss'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME arrondiss WINDOW=FRONT.

string geolevel (a20).
compute geolevel="arrondiss".
alter type  gebiedscode (a20).
alter type  naam_kort (a100).
alter type  naam (a100).

GET DATA
  /TYPE=XLSX
  /FILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\arrondiss2018.xlsx'
  /SHEET=name 'arrondiss2018'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet3 WINDOW=FRONT.

string geolevel (a20).
compute geolevel="arrondiss2018".
alter type  gebiedscode (a20).
alter type  naam_kort (a100).
alter type  naam (a100).

GET DATA
  /TYPE=XLSX
  /FILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\deelgemeente.xlsx'
  /SHEET=name 'deelgemeente'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet4 WINDOW=FRONT.

string geolevel (a20).
compute geolevel="deelgemeente".
alter type  gebiedscode (a20).
alter type  naam_kort (a100).
alter type  naam (a100).


GET DATA
  /TYPE=XLSX
  /FILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\fo_gem.xlsx'
  /SHEET=name 'fo_gem'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet5 WINDOW=FRONT.
string geolevel (a20).
compute geolevel="fo_gem".
alter type  gebiedscode (a20).
alter type  naam_kort (a100).
alter type  naam (a100).


GET DATA
  /TYPE=XLSX
  /FILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\gemeente.xlsx'
  /SHEET=name 'gemeente'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet6 WINDOW=FRONT.

string geolevel (a20).
compute geolevel="gemeente".
alter type  gebiedscode (a20).
alter type  naam_kort (a100).
alter type  naam (a100).

GET DATA
  /TYPE=XLSX
  /FILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\elz.xlsx'
  /SHEET=name 'elz'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet7 WINDOW=FRONT.

string geolevel (a20).
compute geolevel="elz".
alter type  gebiedscode (a20).
alter type  naam_kort (a100).
alter type  naam (a100).

GET DATA
  /TYPE=XLSX
  /FILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\gemeente2018.xlsx'
  /SHEET=name 'gemeente2018'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet8 WINDOW=FRONT.

string geolevel (a20).
compute geolevel="gemeente2018".
alter type  gebiedscode (a20).
alter type  naam_kort (a100).
alter type  naam (a100).

GET DATA
  /TYPE=XLSX
  /FILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\logo.xlsx'
  /SHEET=name 'logo'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet9 WINDOW=FRONT.

string geolevel (a20).
compute geolevel="logo".
alter type  gebiedscode (a20).
alter type  naam_kort (a100).
alter type  naam (a100).

GET DATA
  /TYPE=XLSX
  /FILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\politiezone.xlsx'
  /SHEET=name 'politiezone'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet10 WINDOW=FRONT.

string geolevel (a20).
compute geolevel="politiezone".
alter type  gebiedscode (a20).
alter type  naam_kort (a100).
alter type  naam (a100).

GET DATA
  /TYPE=XLSX
  /FILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\provincie.xlsx'
  /SHEET=name 'provincie'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet11 WINDOW=FRONT.

string geolevel (a20).
compute geolevel="provincie".
alter type  gebiedscode (a20).
alter type  naam_kort (a100).
alter type  naam (a100).


GET DATA
  /TYPE=XLSX
  /FILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\statsec.xlsx'
  /SHEET=name 'statsec'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet12 WINDOW=FRONT.

string geolevel (a20).
compute geolevel="statsec".
alter type  gebiedscode (a20).
alter type  naam_kort (a100).
alter type  naam (a100).

GET DATA
  /TYPE=XLSX
  /FILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\uitrustingsniveau.xlsx'
  /SHEET=name 'uitrustingsniveau'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet13 WINDOW=FRONT.

string geolevel (a20).
compute geolevel="uitrustingsniveau".
alter type  gebiedscode (a20).
alter type  naam_kort (a100).
alter type  naam (a100).


GET DATA
  /TYPE=XLSX
  /FILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\vervoerregio.xlsx'
  /SHEET=name 'vervoerregio'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet14 WINDOW=FRONT.

string geolevel (a20).
compute geolevel="vervoerregio".
alter type  gebiedscode (a20).
alter type  naam_kort (a100).
alter type  naam (a100).






GET DATA
  /TYPE=XLSX
  /FILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\winkelgebied.xlsx'
  /SHEET=name 'winkelgebied'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME Dataset17 WINDOW=FRONT.

string geolevel (a20).
compute geolevel="winkelgebied".
alter type  gebiedscode (a20).
alter type  naam_kort (a100).
alter type  naam (a100).


GET DATA
  /TYPE=XLSX
  /FILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\kernwinkelgebied.xlsx'
  /SHEET=name 'kernwinkelgebied'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME Dataset18 WINDOW=FRONT.

string geolevel (a20).
compute geolevel="kernwinkelgebied".
alter type  gebiedscode (a20).
alter type  naam_kort (a100).
alter type  naam (a100).


GET DATA
  /TYPE=XLSX
  /FILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\statsec2019.xlsx'
  /SHEET=name 'statsec2019'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet19 WINDOW=FRONT.

string geolevel (a20).
compute geolevel="statsec2019".
alter type  gebiedscode (a20).
alter type  naam_kort (a100).
alter type  naam (a100).


GET DATA
  /TYPE=XLSX
  /FILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\ggw7.xlsx'
  /SHEET=name 'ggw7'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet20 WINDOW=FRONT.

string geolevel (a20).
compute geolevel="ggw7".
alter type  gebiedscode (a20).
alter type  naam_kort (a100).
alter type  naam (a100).

DATASET ACTIVATE arrondiss.
ADD FILES /FILE=*
  /FILE='DataSet3'
  /FILE='DataSet4'
  /FILE='DataSet5'
  /FILE='DataSet6'
  /FILE='DataSet7'
  /FILE='DataSet8'
  /FILE='DataSet9'
  /FILE='DataSet10'
  /FILE='DataSet11'
  /FILE='DataSet12'
  /FILE='DataSet13'
  /FILE='DataSet14'
  /FILE='DataSet17'
  /FILE='DataSet18'
  /FILE='DataSet19'
  /FILE='DataSet20'.
EXECUTE.

dataset close dataset3.
dataset close dataset4.
dataset close dataset5.
dataset close dataset6.
dataset close dataset7.
dataset close dataset8.
dataset close dataset9.
dataset close dataset10.
dataset close dataset11.
dataset close dataset12.
dataset close dataset13.
dataset close dataset14.
dataset close dataset17.
dataset close dataset18.
dataset close dataset19.
dataset close dataset20.

compute gebiedscode=ltrim(rtrim(gebiedscode)).
rename variables gebiedscode=geoitem.
string v9900_gebiedscode (a20).
compute v9900_gebiedscode=ltrim(rtrim(geoitem)).
compute period=1970.
EXECUTE.
DELETE VARIABLES naam_kort.
rename variables naam=v9900_gebiedsnaam.


freq geolevel.
delete variables volgnr.
delete variables volgnummer.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\uploadfiles\gebiedsnaam_code.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
