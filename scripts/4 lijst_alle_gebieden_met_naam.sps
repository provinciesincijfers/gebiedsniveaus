* Encoding: windows-1252.



GET DATA
  /TYPE=XLSX
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\arrondiss.xlsx'
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
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\arrondiss2018.xlsx'
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
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\deelgemeente.xlsx'
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
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\fo_gem.xlsx'
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
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\gemeente.xlsx'
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
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\elz.xlsx'
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
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\gemeente2018.xlsx'
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
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\logo.xlsx'
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
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\politiezone.xlsx'
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
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\provincie.xlsx'
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
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\statsec.xlsx'
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
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\uitrustingsniveau.xlsx'
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
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\vervoerregio.xlsx'
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
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\winkelgebied.xlsx'
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
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\kernwinkelgebied.xlsx'
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
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\statsec2019.xlsx'
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
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\TREG.xlsx'
  /SHEET=name 'TREG'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet20 WINDOW=FRONT.

string geolevel (a20).
compute geolevel="treg".
alter type  gebiedscode (a20).
alter type  naam_kort (a100).
alter type  naam (a100).

GET DATA
  /TYPE=XLSX
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\TREG_gem.xlsx'
  /SHEET=name 'TREG_gem'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet21 WINDOW=FRONT.

string geolevel (a20).
compute geolevel="treg_gem".
alter type  gebiedscode (a20).
alter type  naam_kort (a100).
alter type  naam (a100).


GET DATA
  /TYPE=XLSX
  /FILE='C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\ggw7.xlsx'
  /SHEET=name 'ggw7'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet22 WINDOW=FRONT.

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
  /FILE='DataSet20'
  /FILE='DataSet21'
  /FILE='DataSet22'.
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
dataset close dataset21.
dataset close dataset22.

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
SAVE TRANSLATE OUTFILE='C:\github\gebiedsniveaus\data_voor_swing\uploadfiles\gebiedsnaam_code.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
