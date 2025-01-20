* Encoding: windows-1252.
GET TRANSLATE
  FILE='C:\temp\gebiedsniveaus\werkbestanden\basis geodata\2019\adminvec_statsec_31370.dbf'
  /TYPE=DBF /MAP .
DATASET NAME belgie WINDOW=FRONT.

string gemeentenbe2018 (a5).
compute gemeentenbe2018=niscode.
EXECUTE.


DATASET ACTIVATE belgie.
DATASET DECLARE belagg.
AGGREGATE
  /OUTFILE='belagg'
  /BREAK=niscode gemeentenbe2018
  /N_BREAK=N.
dataset activate belagg.
dataset close belgie.
FILTER OFF.
USE ALL.
SELECT IF (niscode ~= "").
EXECUTE.
delete variables n_break.


string gemeentenbe2024 (a5).
recode gemeentenbe2018
('55022'='58001')
('56011'='58002')
('56085'='58003')
('56087'='58004')
('52063'='55085')
('52043'='55086')
('55010'='51067')
('55039'='51068')
('55023'='51069')
('54007'='57096')
('54010'='57097')
('12030'='12041')
('12034'='12041')
('44011'='44083')
('44049'='44083')
('44001'='44084')
('44029'='44084')
('44036'='44085')
('44072'='44085')
('44080'='44085')
('45017'='45068')
('45057'='45068')
('71047'='72042')
('72040'='72042')
('72025'='72043')
('72029'='72043')
(else=copy) into gemeentenbe2024.
exe.

string gemeentenbe (a5).
recode gemeentenbe2024
('11007'='11002')
('23023'='23106')
('23024'='23106')
('23032'='23106')
('37012'='37021')
('37018'='37021')
('37007'='37022')
('37015'='37022')
('44012'='44086')
('44048'='44086')
('44034'='44087')
('44073'='44087')
('46014'='46029')
('44045'='46029')
('44040'='44088')
('44043'='44088')
('46003'='46030')
('46013'='46030')
('11056'='46030')
('73006'='73110')
('73032'='73110')
('73009'='73111')
('73083'='73111')
('71069'='71071')
('71057'='71071')
('71022'='71072')
('73040'='71072')
('82003'='82039')
('82005'='82039')
(else=copy) into gemeentenbe.
exe.

rename variables niscode=statsec.



* deze is om een kaartlaag te kunnen maken?.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\kerntabellen\verwerkt_belgie2018_2019.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

* verrijken met namen.
GET DATA
  /TYPE=XLSX
  /FILE='C:\temp\gebiedsniveaus\kerntabellen\gemeentenbe2018_definitie.xlsx'
  /SHEET=name 'gemeentenbe2018'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME definitie2018 WINDOW=FRONT.
compute volgnummer=$casenum.
EXECUTE.
rename variables gebiedscode = gemeentenbe2018.
alter type gemeentenbe2018 (a5).
sort cases gemeentenbe2018 (a).


dataset activate belagg.
DATASET DECLARE belagg2.
AGGREGATE
  /OUTFILE='belagg2'
  /BREAK=gemeentenbe2018 gemeentenbe2024 gemeentenbe
  /N_BREAK=N.
dataset activate belagg2.

sort cases gemeentenbe2018 (a).
MATCH FILES /FILE=*
  /FILE='definitie2018'
  /BY gemeentenbe2018.
EXECUTE.
dataset close definitie2018.
rename variables naam=naam_gemeentenbe2018.
if gemeentenbe2024="" gemeentenbe2024=gemeentenbe2018.
if gemeentenbe="" gemeentenbe=gemeentenbe2018.

string naam_gemeentenbe2024 (a50).
recode gemeentenbe2018
('12030'='Puurs-Sint-Amands')
('12034'='Puurs-Sint-Amands')
('44011'='Deinze')
('44049'='Deinze')
('44001'='Aalter')
('44029'='Aalter')
('44036'='Lievegem')
('44072'='Lievegem')
('44080'='Lievegem')
('45017'='Kruisem')
('45057'='Kruisem')
('71047'='Oudsbergen')
('72040'='Oudsbergen')
('72025'='Pelt')
('72029'='Pelt') into naam_gemeentenbe2024.
exe.
if naam_gemeentenbe2024="" naam_gemeentenbe2024=naam_gemeentenbe2018.
exe.


string naam_gemeentenbe (a50).
recode gemeentenbe2024
('11007'='Antwerpen')
('23023'='Pajottegem')
('23024'='Pajottegem')
('23032'='Pajottegem')
('37012'='Wingene')
('37018'='Wingene')
('37007'='Tielt')
('37015'='Tielt')
('44012'='Nazareth-De Pinte')
('44048'='Nazareth-De Pinte')
('44034'='Lochristi')
('44073'='Lochristi')
('46014'='Lokeren')
('44045'='Lokeren')
('44040'='Merelbeke-Melle')
('44043'='Merelbeke-Melle')
('46003'='Beveren-Kruibeke-Zwijndrecht')
('46013'='Beveren-Kruibeke-Zwijndrecht')
('11056'='Beveren-Kruibeke-Zwijndrecht')
('73006'='Bilzen-Hoeselt')
('73032'='Bilzen-Hoeselt')
('73009'='Tongeren-Borgloon')
('73083'='Tongeren-Borgloon')
('71069'='Tessenderlo-Ham')
('71057'='Tessenderlo-Ham')
('71022'='Hasselt')
('73040'='Hasselt')
('82003'='Bastogne')
('82005'='Bastogne') into naam_gemeentenbe.
exe.
if naam_gemeentenbe="" naam_gemeentenbe=naam_gemeentenbe2024.
exe.
*****




DATASET ACTIVATE belagg2.
DATASET DECLARE werkbestand.
AGGREGATE
  /OUTFILE='werkbestand'
  /BREAK=gemeentenbe2018 naam_gemeentenbe2018
/volgnummer=min(volgnummer)
  /N_BREAK=N.
dataset activate werkbestand.
delete variables n_break.
rename variables gemeentenbe2018=gebiedscode.
rename variables naam_gemeentenbe2018=naam_kort.
string naam (a55).
compute naam=naam_kort.
sort cases volgnummer (a).
compute volgnr=$casenum.
alter type volgnr (f8.0).
DELETE VARIABLES volgnummer.
match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.


SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\gemeentenbe2018.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.


dataset activate belagg2.
DATASET DECLARE werkbestand.
AGGREGATE
  /OUTFILE='werkbestand'
  /BREAK=gemeentenbe2024 naam_gemeentenbe2024
/volgnummer=min(volgnummer)
  /N_BREAK=N.
dataset activate werkbestand.
delete variables n_break.
rename variables gemeentenbe2024=gebiedscode.
rename variables naam_gemeentenbe2024=naam_kort.
string naam (a55).
compute naam=naam_kort.
sort cases volgnummer (a).
compute volgnr=$casenum.
alter type volgnr (f8.0).
DELETE VARIABLES volgnummer.

match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.


SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\gemeentenbe2024.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

dataset activate belagg2.
DATASET DECLARE werkbestand.
AGGREGATE
  /OUTFILE='werkbestand'
  /BREAK=gemeentenbe naam_gemeentenbe
/volgnummer=min(volgnummer)
  /N_BREAK=N.
dataset activate werkbestand.
delete variables n_break.
rename variables gemeentenbe=gebiedscode.
rename variables naam_gemeentenbe=naam_kort.
string naam (a55).
compute naam=naam_kort.
sort cases volgnummer (a).
compute volgnr=$casenum.
alter type volgnr (f8.0).
DELETE VARIABLES volgnummer.

match files
/file=*
/keep= volgnr gebiedscode naam_kort naam.
EXECUTE.


SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsdefinities swing\gemeentenbe.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.

dataset activate belagg2.
DATASET close werkbestand.





DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=gemeentenbe2018 gemeentenbe2024
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\gemeentenbe2018_gemeentenbe2024.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
dataset activate belagg2.


DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=gemeentenbe2024 gemeentenbe
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\gemeentenbe2024_gemeentenbe.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.


DATASET ACTIVATE belagg.






GET DATA
  /TYPE=XLS
  /FILE='C:\temp\gebiedsniveaus\kerntabellen\gemeente_arrondiss.xls'
  /SHEET=name 'gemeente_arrondiss'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0.
EXECUTE.
DATASET NAME verrijken WINDOW=FRONT.

rename variables gemeente = gemeentenbe.
alter type gemeentenbe (a5).
sort cases gemeentenbe (a).
match files
/file=*
/keep=gemeentenbe.
compute vl_br=1.
EXECUTE.

DATASET ACTIVATE belagg2.
sort cases gemeentenbe (a).
MATCH FILES /FILE=*
  /TABLE='verrijken'
  /BY gemeentenbe.
EXECUTE.
dataset close verrijken.
string gemeente (a5).
if vl_br=1 gemeente=gemeentenbe.
if gemeente="" gemeente="99999".
EXECUTE.


DATASET DECLARE ag1.
AGGREGATE
  /OUTFILE='ag1'
  /BREAK=gemeentenbe gemeente 
  /N_BREAK=N.
dataset activate ag1.
delete variables n_break.
DATASET ACTIVATE ag1.
FILTER OFF.
USE ALL.
SELECT IF (gemeente ~= "").
EXECUTE.
SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\gebiedsaggregaties swing\gemeentenbe_gemeente.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
/replace.
DATASET ACTIVATE belagg2.
dataset close ag1.

****tot hier. opgelet: staat nog in temp files.
* de officiële verdeling statsec via geopunt bevat DE OUDE niscode, niet de nieuwe.
GET TRANSLATE
  FILE='C:\Users\plu3532\Documents\gebiedsindelingen\statsec_2019\diff3\SCBEL01012019N_diff03.dbf'
  /TYPE=DBF /MAP .
DATASET NAME statsecniscode WINDOW=FRONT.

match files
/file=*
/keep=cs01012019
cnis5_2019.
rename variables (cs01012019
cnis5_2019 = 
statsec
gemeentenbe).

SAVE TRANSLATE OUTFILE='C:\temp\gebiedsniveaus\werkbestanden\basis '+ 
    'geodata\2020\statsec_gemeentenbe.xlsx' 
  /TYPE=XLS 
  /VERSION=12 
  /MAP 
  /FIELDNAMES VALUE=NAMES 
  /CELLS=VALUES
/replace.
