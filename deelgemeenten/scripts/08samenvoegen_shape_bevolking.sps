* Encoding: windows-1252.

GET TRANSLATE
  FILE='C:\Users\plu3532\Documents\gebiedsindelingen\verwerking\statsec_deelgemeente_av_72.dbf'
  /TYPE=DBF /MAP .
DATASET NAME shape WINDOW=FRONT.

rename variables secdg=statsec_splits.
rename variables niscode_1=deelgemeente.
rename variables area=oppervlakte.
alter type oppervlakte (f10.2).
alter type statsec_splits (a20).
match files
/file=*
/keep=statsec_splits statsec deelgemeente oppervlakte.
EXECUTE.
compute statsec_splits=ltrim(statsec_splits).
sort cases statsec_splits (a).


GET
  FILE='C:\Users\plu3532\Documents\gebiedsindelingen\bevolking_xy\statsec_limburg.sav'.
DATASET NAME bevolking WINDOW=FRONT.

DATASET ACTIVATE bevolking.
ADD FILES /FILE=*
  /FILE='C:\Users\plu3532\Documents\gebiedsindelingen\bevolking_xy\statsec_antwerpen.sav'
  /FILE='C:\Users\plu3532\Documents\gebiedsindelingen\bevolking_xy\statsec_vlaamsbrabant.sav'
  /FILE='C:\Users\plu3532\Documents\gebiedsindelingen\bevolking_xy\statsec_westvlaanderen.sav'
  /FILE='C:\Users\plu3532\Documents\gebiedsindelingen\bevolking_xy\statsec_oostvlaanderen.sav'.
EXECUTE.

* er ontstaan 6 dubbels omdat er soms X-Y'en zijn van buiten de Provincie.
DATASET DECLARE bevolkingstatsec.
AGGREGATE
  /OUTFILE='bevolkingstatsec'
  /BREAK=statsec_splits
  /inwoners2016=SUM(inwoners2016).
DATASET activate bevolkingstatsec.
dataset close bevolking.

sort cases statsec_splits (a).



DATASET ACTIVATE shape.

sort cases statsec_splits (a).
MATCH FILES /FILE=*
  /TABLE='bevolkingstatsec'
  /BY statsec_splits.
EXECUTE.


STRING  provincie (A1).
COMPUTE provincie=statsec_splits.

RECODE inwoners2016 (SYSMIS=0).
EXECUTE.

dataset close bevolkingstatsec.


* OPTIONEEL DEEL.
* samenvatting met problematische sectoren.
DATASET ACTIVATE shape.
DATASET DECLARE test.
AGGREGATE
  /OUTFILE='test'
  /BREAK=statsec
  /oppervlakte_min=MIN(oppervlakte) 
  /oppervlakte_max=MAX(oppervlakte) 
  /oppervlakte_sum=SUM(oppervlakte)
  /inwoners2016_min=MIN(inwoners2016) 
  /inwoners2016_max=MAX(inwoners2016) 
  /inwoners2016_sum=SUM(inwoners2016)
  /testsecsplits=N.
dataset activate test.

DATASET ACTIVATE test.
FILTER OFF.
USE ALL.
SELECT IF (testsecsplits > 1).
EXECUTE.

* 21 sectoren met een conflict.
* 13 hebben geen inwoners, dus niet echt problematisch.
* 8 met inwoners in verschillende delen. Allemaal hebben die de meerderheid in één deel.
 
DATASET ACTIVATE test.
COMPUTE oppervlakte_test=oppervlakte_max/oppervlakte_sum*100.
COMPUTE inwoners_test=inwoners2016_max/inwoners2016_sum*100.
EXECUTE.


SAVE TRANSLATE OUTFILE='C:\Users\plu3532\Documents\gebiedsindelingen\bevolking_xy\lastige_sectoren.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES.

* EINDE OPTIONEEL DEEL.



dataset activate shape.
dataset close test.
* sectoren die niet ingevuld zijn: stukjes zee die wel in de gemeente zitten, maar niet in een sector.
FILTER OFF.
USE ALL.
SELECT IF (statsec ~= "").
EXECUTE.


* manuele aanpassingen eerst.

* Eén sector wordt door het NGI verkeerd toegewezen. Manueel toegewezen aan deelgemeente waar ze het beste bij aansluit.
if statsec="1104411PQ" deelgemeente="11044B".

compute behouden=1.

*Vinkem (H-II) bestaat uit twee sectoren, die beide gedeeld zijn met Wulveringen (H-I). Wulveringen heeft daarnaast nog één andere sector.
*Beide gedeelde sectoren liggen nagenoeg gelijk verdeeld over de twee deelgemeenten. Voorstel: HI en HII samenvoegen tot Wulveringen-Vinkem.

*38025H009        38025H-I
38025H009        38025H-II
38025H099        38025H-I
38025H099        38025H-II.

if statsec="38025H009" & deelgemeente="38025H-II" behouden=0.
if statsec="38025H099" & deelgemeente="38025H-II" behouden=0.
recode deelgemeente ("38025H-I" = "38025H-I_II") ("38025H-I" = "38025H-I_II").
EXECUTE.

*Sint-Rijkers (A-III), Alveringem (A-II) en Oeren (A-I) hebben meer overlap dan niet-overlap. Voorstel: samenvoegen tot Oeren - Alveringem - Sint-Rijkers.

*38002A089        38002A-II
38002A089        38002A-III
38002A099        38002A-I
38002A099        38002A-II
38002A181        38002A-II
38002A181        38002A-III

if statsec="38002A089" & deelgemeente="38002A-II" behouden=0.
if statsec="38002A099" & deelgemeente="38002A-I" behouden=0.
if statsec="38002A181" & deelgemeente="38002A-II" behouden=0.
recode deelgemeente ("38002A-I" = "38002A-I_II_III") ("38002A-II" = "38002A-I_II_III") ("38002A-III" = "38002A-I_II_III") .
EXECUTE.


*Hoeke en Oostkerke. Hoeke is onmogelijk te identificeren als deelgemeente. Samenvoegen tot Hoeke-Oostkerke.
*31006C099        31006C-I
31006C10-        31006C-I
31006C099        31006C-II
31006C00-        31006C-II
31006C012        31006C-II

if statsec="31006C099" & deelgemeente="31006C-I" behouden=0.
recode deelgemeente ("31006C-I" = "31006C-I_II") ("31006C-II" = "31006C-I_II") .
EXECUTE.


*Gentbrugge-Ledeberg: de sector is dicht bevolkt in beide delen. Op basis van "wat in de hoofden van de mensen het meest waarschijnlijk is" toegekend aan Gentbrugge.
*44021G200        44021F
44021G200        44021G

if statsec="44021G200" & deelgemeente="44021G" behouden=0.
EXECUTE.


DATASET ACTIVATE shape.
FILTER OFF.
USE ALL.
SELECT IF (behouden = 1).
EXECUTE.




* er schiet nog één sector over die een sliver heeft. Al de andere probleemgevallen zijn volledig onbewoond.
* check in deze stap of N slechts met één record vermindert!.
AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=statsec
  /inwoners2016_sum=SUM(inwoners2016).
FILTER OFF.
USE ALL.
SELECT IF (inwoners2016 = inwoners2016_sum).
EXECUTE.

* de rest zijn er die onbewoond zijn.
* toekennen op grootste oppervlakte.

* De Schelde in Antwerpen: toekennen aan Deelgemeente Antwerpen.
if statsec="11002M0PA" & deelgemeente="11002-Y" behouden=0.
EXECUTE.
FILTER OFF.
USE ALL.
SELECT IF (behouden = 1).
EXECUTE.


* de rest zijn allemaal in Wallonië en/of slivers. Toekennen op grootste gebied.
AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=statsec
  /oppervlakte_sum=SUM(oppervlakte).
COMPUTE oppervlakte_test=oppervlakte/oppervlakte_sum*100.
EXECUTE.


AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=statsec
  /testsecsplits=N.
RECODE testsecsplits (2 thru Highest=1) (ELSE=0) INTO problem.
EXECUTE.

AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=statsec
  /oppervlakte_max=MAX(oppervlakte).

if testsecsplits > 1 & oppervlakte~=oppervlakte_max behouden=0.
EXECUTE.

FILTER OFF.
USE ALL.
SELECT IF (behouden = 1).
EXECUTE.

* koppelen aan geolaag met gesplitste sectoren. Polygonen een keer samenvoegen tot statsec, en een keer tot deelgemeente.
match files
/file=*
/keep=statsec_splits statsec deelgemeente.
EXECUTE.
sort cases statsec_splits (a).
rename variables statsec=twstatsec.
rename variables deelgemeente=twdeelgemeente.


* vorige versie wordt niet overschreven!
* eerst backup maken van de oude, dan pas saven.
SAVE TRANSLATE OUTFILE='C:\Users\plu3532\Documents\gebiedsindelingen\bevolking_xy\statsec_toewijzing.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES.

* deze excel wordt gelezen door C:\Users\plu3532\Documents\gebiedsindelingen\verwerking\beperkte_mxd.mxd in de laag statsec_deelgemeente_av_72_minimal
* daar dan:
* de sectoren zijn nog gesplitst! Dus je moet de polygonen nog aggregeren op unieke statistische sector naam.
* de sectoren weten in welke deelgemeente ze liggen. Dus de gesplitste sectoren samenvoegen op basis van de code van de deelgemeente.
(Eerst de laag exporteren als nieuwe shapefile, want Dissolve werkt niet op basis van een gekoppelde kolom!
ArcGIS>Geoprocessing>Dissolve> Dissolve fields: statsec_toewijzing.twdeelgemeente)




SAVE TRANSLATE OUTFILE='C:\Users\plu3532\Documents\gebiedsindelingen\verwerking\gislagen\toewijzingstabel.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
  /DROP=statsec_splits.

delete variables statsec_splits.
rename variables twstatsec=statsec.
rename variables twdeelgemeente=deelgemeente.

string gemeente (a5).
compute gemeente=deelgemeente.

DATASET ACTIVATE shape.
DATASET DECLARE gemeente.
AGGREGATE
  /OUTFILE='gemeente'
  /BREAK=gemeente
  /statsec=FIRST(statsec).
DATASET ACTIVATE gemeente.
compute statsec=concat(char.substr(statsec,1,5),"Z").
EXECUTE.

dataset activate shape.
ADD FILES /FILE=*
  /FILE='gemeente'.
EXECUTE.
dataset close gemeente.



if deelgemeente="" deelgemeente=concat(gemeente,"ONBE").
EXECUTE.
* namen toevoegen.
GET TRANSLATE
  FILE='C:\Users\plu3532\Documents\gebiedsindelingen\adsei_statsec\scbel01012011_gen13.dbf'
  /TYPE=DBF /MAP .
DATASET NAME adsei WINDOW=FRONT.
match files
/file=*
/keep=Cs012011 sector_nl gemeente.
rename variables Cs012011=statsec.
alter type statsec (a27).
rename variables sector_nl=statsec_naam.
rename variables gemeente=gemeente_naam.
sort cases statsec (a).
compute statsec_naam=LOWER(statsec_naam).

* we willen graag leesbare sectornamen.
* aangepast , op basis van http://www.spsstools.net/en/syntax/syntax-index/concatenatemodify-string-variables/convert-first-letter-of-each-word-to-uppercase/.
STRING a1 to a15 (a60).
string address (a60).
compute address=statsec_naam.
compute address=replace(address,"-","- ").
compute address=replace(address,"(","( ").
compute address=replace(address,".",". ").
EXECUTE.

DO REPEAT a=a1 to a15.
COMPUTE space=char.index(address," ").
if space=0 space=length(address)+1.
COMPUTE a=char.substr(address,1,space-1).
COMPUTE address=char.substr(address,space+1).
COMPUTE a=concat(upcase(char.substr(a,1,1)),char.substr(a,2)).
END REPEAT.
COMPUTE address=concat(rtrim(a1)," ", rtrim(a2)," ",rtrim(a3)," ", rtrim(a4)," ",rtrim(a5)," ",rtrim(a6)," ",rtrim(a7)," ",rtrim(a8)," ",rtrim(a9)," ",rtrim(a10)," ",rtrim(a11)," ",rtrim(a12)," ",rtrim(a13)," ",rtrim(a14)," ",rtrim(a15)).
EXECUTE.
DELETE VARIABLES a1 to a15.

compute address=replace(address,"- ","-").
compute address=replace(address,"( ","(").
compute address=replace(address,". "," ").
EXECUTE.

* extra cleaning.
if char.index(address,"(")>0 & char.substr(address,char.index(address,"(")-1,1)~=" " address=replace(address,"("," (").
compute address=ltrim(address,"-").
compute address=replace(address,"  "," ").
compute statsec_naam=address.
EXECUTE.
delete variables address space.


* idem voor gemeentenaam.
STRING a1 to a15 (a60).
string address (a60).
compute address=lower(gemeente_naam).
compute address=replace(address,"-","- ").
compute address=replace(address,"(","( ").
compute address=replace(address,".",". ").
EXECUTE.

DO REPEAT a=a1 to a15.
COMPUTE space=char.index(address," ").
if space=0 space=length(address)+1.
COMPUTE a=char.substr(address,1,space-1).
COMPUTE address=char.substr(address,space+1).
COMPUTE a=concat(upcase(char.substr(a,1,1)),char.substr(a,2)).
END REPEAT.
COMPUTE address=concat(rtrim(a1)," ", rtrim(a2)," ",rtrim(a3)," ", rtrim(a4)," ",rtrim(a5)," ",rtrim(a6)," ",rtrim(a7)," ",rtrim(a8)," ",rtrim(a9)," ",rtrim(a10)," ",rtrim(a11)," ",rtrim(a12)," ",rtrim(a13)," ",rtrim(a14)," ",rtrim(a15)).
EXECUTE.
DELETE VARIABLES a1 to a15.

compute address=replace(address,"- ","-").
compute address=replace(address,"( ","(").
compute address=replace(address,". "," ").
EXECUTE.

* extra cleaning.
if char.index(address,"(")>0 & char.substr(address,char.index(address,"(")-1,1)~=" " address=replace(address,"("," (").
compute address=ltrim(address,"-").
compute address=replace(address,"  "," ").
compute gemeente_naam=address.
EXECUTE.
delete variables address space.


dataset activate shape.
sort cases statsec (a).
MATCH FILES /FILE=*
  /TABLE='adsei'
  /BY statsec.
EXECUTE.
dataset close adsei.

if gemeente_naam="" & gemeente=lag(gemeente) gemeente_naam=lag(gemeente_naam).
if statsec_naam="" statsec_naam=concat(gemeente_naam," - niet te lokaliseren"). 
EXECUTE.


DATASET DECLARE gemeentenamen.
AGGREGATE
  /OUTFILE='gemeentenamen'
  /BREAK=deelgemeente gemeente_naam
  /N_BREAK=N.
dataset activate gemeentenamen.
delete variables n_break.
rename variables deelgemeente = twdeelgeme.
SAVE OUTFILE='C:\Users\plu3532\Documents\gebiedsindelingen\verwerking\gislagen\werkbestanden\deelgemeente_gemeentenamen.sav'
  /COMPRESSED.
dataset activate shape.
dataset close gemeentenamen.




if char.substr(gemeente,1,2)='21' provincie=4000.
if char.substr(gemeente,1,1)='1' provincie=10000.
if char.substr(gemeente,1,2)='23' | char.substr(gemeente,1,2)='24' provincie=20001.
if char.substr(gemeente,1,1)='3' provincie=30000.
if char.substr(gemeente,1,1)='4' provincie=40000.
if char.substr(gemeente,1,1)='7' provincie=70000.
alter type provincie (f5.0).
VALUE LABELS provincie
10000 'Antwerpen'
4000 'Brussels Hoofdstedelijk Gewest'
70000 'Limburg'
40000 'Oost-Vlaanderen'
20001 'Vlaams-Brabant'
30000 'West-Vlaanderen'
99999 'provincie onbekend'.


EXECUTE.
FILTER OFF.
USE ALL.
SELECT IF (provincie > 0).
EXECUTE.


* namen van sectoren uniek maken.
AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=statsec_naam
  /stap1=N.
if stap1>1 statsec_naam=concat(statsec_naam," (",rtrim(char.substr(statsec,6,4))).
EXECUTE.
AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=statsec_naam
  /stap2=N.
if stap2>1 statsec_naam=concat(statsec_naam, ", ",gemeente_naam,")").
if stap1>1 & stap2=1 statsec_naam=concat(statsec_naam,")").
EXECUTE.
delete variables stap1 stap2.



SAVE OUTFILE='C:\Users\plu3532\Documents\gebiedsindelingen\verwerking\gislagen\basis_tabel.sav'
  /COMPRESSED.

