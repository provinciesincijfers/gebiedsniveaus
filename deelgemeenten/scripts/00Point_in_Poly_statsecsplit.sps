* Encoding: UTF-8.

* zie bijhorend document om je SPSS-installatie hier klaar voor te maken.

* Script van https://andrewpwheeler.wordpress.com/2016/12/09/spatial-join-points-to-polygons-using-python-and-spss/ , 
gebaseerd op http://rexdouglass.com/fast-spatial-joins-in-python-with-a-spatial-index/.

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
bg_statsec = shapefile.Reader(data + r'\statsec_deelgemeente_av_72.shp')
bg_shapes = bg_statsec.shapes()  #convert to shapely objects
bg_points = [q.points for q in bg_shapes]
polygons = [Polygon(q) for q in bg_points]

#looking at the fields and records
#bg_fields = bg_statsec.fields
bg_records = bg_statsec.records()
print bg_records[0][1] #als je hier commentaar uitzet, dan laat je de eerste record zien

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

* neem een willekeurig bestand vast.
GET
  FILE=
    'G:\OD_IF_AUD\2_04_Statistiek\2_04_01_Data_en_kaarten\Bevolking\Bevolking_2017\Bevolking_2017_wer'+
    'kbestand.sav'.
DATASET NAME basis WINDOW=FRONT.

DATASET DECLARE werkbestand.
AGGREGATE
  /OUTFILE='werkbestand'
  /BREAK=codePostcode omschrijvingStraat codeStraat huisnr index x y statsec
  /inwoners=N.

dataset activate werkbestand.
DATASET CLOSE basis.


* geef je coordinaten een zinvolle naam.
rename variables x=x_adres.
rename variables y=y_adres.

dataset activate werkbestand.

* enkel indien je wil kunnen timen.
SHOW $VAR.

* roep het programma op, zeg welke variabele opgevuld moet worden (hier statsec_splits) en hoeveel tekens deze mag hebben (type=7).
* type=0 betekent numeriek.
* geef vervolgens aan in welke variabele x en y teruggevonden kunnen worden.
SPSSINC TRANS RESULT=statsec_splits TYPE=7
  /FORMULA "assign_area(x=x_adres,y=y_adres)".

SHOW $VARS.

* controleer waar de twee waarden van elkaar veschillen.
COMPUTE Check = (statsec = statsec_splits).
FREQ Check.

