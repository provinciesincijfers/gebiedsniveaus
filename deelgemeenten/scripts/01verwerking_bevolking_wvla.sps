* Encoding: UTF-8.

* TODO: west vlaanderen heeft ander bestand correspondentie nodig.

* bron van de bevolkingsdata: https://share.vlaamsbrabant.be/share/page/site/socialeplanning/documentlibrary#filter=path%7C%2FGegevens%2FRijksregister%7C&page=1


* todo: statsec meepakken uit bevolking!

get sas data="C:\Users\plu3532\Documents\gebiedsindelingen\verwerking\werkbestanden_bevolking\ipw2016.sas7bdat"
/formats="C:\Users\plu3532\Documents\gebiedsindelingen\verwerking\werkbestanden_bevolking\formout.sas7bdat".
DATASET NAME bevolking.

* aanpassing: gegevens van gezinshoofd meenemen, want er gebeurt een correctie op basis van gezinshoofd voor alle afgeleide variabelen, edoch niet voor de adrescode van de persoon.
DATASET ACTIVATE bevolking.
AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=RRNR_HOOFDPERSOON
  /inwoners_gezin=N.

FILTER OFF.
USE ALL.
SELECT IF (RRNR_HOOFDPERSOON = NATIONAAL_NUMMER).
EXECUTE.

DATASET ACTIVATE bevolking.
DATASET DECLARE adresinwoners.
AGGREGATE
  /OUTFILE='adresinwoners'
  /BREAK=ADRESCODE sscode
  /inwoners2016=sum(inwoners_gezin).
dataset activate adresinwoners.
dataset close bevolking.

* er zijn 7 gevallen waar eenzelfde adres aan meerdere statsec is gekoppeld.
* hou het adres en de inwoners over van het meest bevolkte adres.
DATASET ACTIVATE adresinwoners.
* Identify Duplicate Cases.
SORT CASES BY ADRESCODE(A) inwoners2016(A).
MATCH FILES
  /FILE=*
  /BY ADRESCODE
/LAST=PrimaryLast.
VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary'.
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryLast (ORDINAL).
EXECUTE.
FILTER OFF.
USE ALL.
SELECT IF (PrimaryLast = 1).
EXECUTE.
delete variables primarylast.

* uitbreiden met x-y coordinaten.

PRESERVE.
 SET DECIMAL COMMA.

GET DATA  /TYPE=TXT
  /FILE=
    "C:\Users\plu3532\Documents\gebiedsindelingen\verwerking\werkbestanden_bevolking\Correspondentiet"+
    "abel_WestVlaanderen.txt"
  /ENCODING='UTF8'
  /DELCASE=LINE
  /DELIMITERS="\t"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  Id AUTO
  NISCODE AUTO
  ADRESCODE AUTO
  BOUWBLOK AUTO
  STAT_SECTOR AUTO
  DEELGEMEENTE AUTO
  WIJKCODE AUTO
  WIJKNAAM AUTO
  NRKERNTYPE AUTO
  X AUTO
  Y AUTO
  /MAP.
RESTORE.

CACHE.
EXECUTE.
DATASET NAME correspondentie WINDOW=FRONT.

match files
/file=*
/keep=adrescode x y.
sort cases adrescode (a).

* verwijder adressen zonder adrescode...
DATASET ACTIVATE correspondentie.
FILTER OFF.
USE ALL.
SELECT IF (ADRESCODE > -1).
EXECUTE.


DATASET ACTIVATE adresinwoners.
sort cases adrescode (a).
MATCH FILES /FILE=*
  /TABLE='correspondentie'
  /BY Adrescode.
EXECUTE.
dataset close correspondentie.



* verwijder adrescodes zonder coordinaten.
FILTER OFF.
USE ALL.
SELECT IF (X > 0).
EXECUTE.

* helaas is niet elke XY steeds in dezelfde sector.
* wat niet logisch coherent is natuurlijk. Wellicht te verklaren doordat de toewijzing van sector niet puur geografisch gebeurt.
* we houden enkel de x y - statsec combinatie over met de meeste inwoners en houden enkel die inwoners over.
DATASET DECLARE xyinwoner.
AGGREGATE
  /OUTFILE='xyinwoner'
  /BREAK=X Y sscode
  /inwoners2016=SUM(inwoners2016).
dataset activate xyinwoner.

DATASET ACTIVATE xyinwoner.
AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=X Y
  /twijfelsector=N.

DATASET DECLARE xyinwonerplat.
AGGREGATE
  /OUTFILE='xyinwonerplat'
  /BREAK=X Y
  /inwoners2016_max=MAX(inwoners2016)
  /twijfelsector=N.
DATASET ACTIVATE xyinwonerplat.


dataset close xyinwoner.
dataset close adresinwoners.


SAVE OUTFILE='C:\Users\plu3532\Documents\gebiedsindelingen\bevolking_xy\xy_inwoners_westvlaanderen.sav'
  /COMPRESSED.


* definieer programma.
BEGIN PROGRAM Python.
# Building a function to assign a point to a polygon
# dit vereist dat je SPSS versie een Python versie heeft die shapefile, rtree en shapely kent
import shapefile
from rtree import index
from shapely.geometry import Polygon, Point

# kies je shapefile: eerst de map, in de regel erna het bestand
# de eerste betekenisvolle kolom wordt genomen als identificator. Hier is dat de kolom waar vb A01-A1 in staat 
# (en waarmee je dus kan hercoderen naar de juiste buurt en wijk)
# de naam bg_statsec is willekeurig, en je hoeft die dus niet aan te passen met een andere bron
# je polygonen moeten wel steeds wederzijds uitsluitend zijn (dus een punt kan steeds slechts in een enkel gebied liggen)
data = r'C:\Users\plu3532\Documents\gebiedsindelingen\verwerking'
bg_statsec = shapefile.Reader(data + r'\statsec_deelgemeente_av_72_minimal.shp')
bg_shapes = bg_statsec.shapes()  #convert to shapely objects
bg_points = [q.points for q in bg_shapes]
polygons = [Polygon(q) for q in bg_points]

#looking at the fields and records
#bg_fields = bg_statsec.fields
bg_records = bg_statsec.records()
#print bg_records[0][1] #als je hier commentaar uitzet, dan laat je de eerste record zien

#build spatial index from bounding boxes
#also has a second vector associating
#area IDs to numeric id
idx = index.Index()
c_id = 0
area_match = []
for a,b in zip(bg_shapes,bg_records):
    area_match.append(b[1])
    idx.insert(c_id,a.bbox,obj=b[1])
    c_id += 1

#now can define function with polygons, area_match, and idx as globals
def assign_area(x,y):
    if x == None or y == None: return None
    point = Point(x,y)
    for i in idx.intersection((x,y,x,y)):
        if point.within(polygons[i]):
            return area_match[i]
    return None
#note points on the borders will return None
        
END PROGRAM.

rename variables x=x_adres.
rename variables y=y_adres.

SAVE OUTFILE='C:\Users\plu3532\Documents\gebiedsindelingen\bevolking_xy\xy_inwoners_westvlaanderen.sav'
  /COMPRESSED.

* roep het programma op, zeg welke variabele opgevuld moet worden (hier statsec_splits) en hoeveel tekens deze mag hebben (type=7).
* type=0 betekent numeriek.
* geef vervolgens aan in welke variabele x en y teruggevonden kunnen worden.

SPSSINC TRANS RESULT=statsec_splits TYPE=20
  /FORMULA "assign_area(x=x_adres,y=y_adres)".

DATASET DECLARE population2016.
AGGREGATE
  /OUTFILE='population2016'
  /BREAK=statsec_splits
  /inwoners2016=SUM(inwoners2016_max).
dataset activate population2016.


DATASET ACTIVATE population2016.
FILTER OFF.
USE ALL.
SELECT IF (statsec_splits ~= "").
EXECUTE.

SAVE OUTFILE='C:\Users\plu3532\Documents\gebiedsindelingen\bevolking_xy\statsec_westvlaanderen.sav'
  /COMPRESSED.

