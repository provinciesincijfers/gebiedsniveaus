# Toevoegen van gebiedsniveaus

## Inhoudelijke criteria

Nieuwe gebiedsniveaus moeten:
- Voor heel Vlaanderen van toepassing zijn
- Een relatief breed draagvlak hebben
- Goedgekeurd worden door de Redactiegroep

## Aanvragen van een gebiedsniveau

Om de gebiedsniveau-informatie beheersbaar te houden, zijn enkele gebiedsniveaus als _basis_ gedefinieerd. Zij worden samen beheerd in één grote [kerntabel](https://github.com/provinciesincijfers/gebiedsniveaus/blob/master/kerntabellen/kerntabel.xls) die alle statistische sectoren van Vlaanderen en Brussel bevat. Deze is niét bedoeld  om gebruiksvriendelijk te zijn. Voor *handige* verzameltabellen, ga naar [gebiedsniveaus/verzamelbestanden](https://github.com/provinciesincijfers/gebiedsniveaus/tree/master/verzamelbestanden)

Alle andere gebiedsindelingen kunnen gedefinieerd worden in functie van deze basis. Om de kans op fouten te verkleinen en de transparantie te verhogen, verzamelen we deze allemaal in eenvoudige tabellen, per gebiedsniveau. Deze staan opgelijst in [gebiedsniveaus/kerntabellen](https://github.com/provinciesincijfers/gebiedsniveaus/tree/master/kerntabellen).

Om een nieuw gebiedsniveau aan te vragen, maak je een bestand zoals je daar aantreft. De naamgeving van deze bestanden is van de vorm `basisniveau_nieuweafgeleide.xlsx`. Structuur van de bestanden is steeds zoals het voorbeeld hieronder. `name basisniveau` mag leeg zijn maar de kolom moet aanwezig zijn. Vervang overal het woord `basisniveau` door de gebiedsniveaucode van dit niveau. Vervang overal `nieuweafgeleide` door de gebiedsniveaucode van je nieuwe gebiedsindeling.

| basisniveau | Name basisniveau | nieuweafgeleide | Name nieuweafgeleide |
| --- | --- | --- | --- |
| 41002 | Aalst | 41000 | Aalst (Arr.) |

Elk gebied van het basisniveau mag aan slechts één afgeleide toegekend worden. De code van het _nieuweafgeleide_ gebied komt doorgaans meerdere keren voor. 

Naast &quot;gebied onbekend&quot; wordt overal &quot;gebied onbekend (Vlaanderen)&quot; en &quot;gebied onbekend (Brussel)&quot; toegevoegd. Enkel op die manier kan Swing een correct totaal berekenen voor Vlaanderen en Brussel. Wanneer een bron enkel &quot;gebied onbekend (om het even waar in België)&quot; heeft, kan je geen correct totaal geven. Databeheerders gebruiken 99991 (Vla), 99992 (Bru) en 99999 (België) voor gemeenten. Op statsec wordt dat 99991ZZZZ en varianten. Wanneer er geen data voor Brussel beschikbaar is, hoef je ook geen gebied onbekend voor Brussel toe te voegen.

Voorzie ook een tekstje voor de [metadata over gebiedsniveaus](https://provincies.incijfers.be/info/9900_gebiedsniveaus.html)

## Verder verloop

Met de basistabel en de tabellen per gebiedsniveau werden SPSS scripts (zie [gebiedsniveaus/scripts](https://github.com/provinciesincijfers/gebiedsniveaus/tree/master/scripts) opgezet die het volgende doen:

- Map [data_voor_swing/gebiedsdefinities](https://github.com/provinciesincijfers/gebiedsniveaus/tree/master/data_voor_swing/gebiedsdefinities): definitiebestand voor Swing; de lijst van gebieden en hun namen
- Map [data_voor_swing/aggregatietabellen](https://github.com/provinciesincijfers/gebiedsniveaus/tree/master/data_voor_swing/aggregatietabellen): aggregatietabellen  voor Swing: dit is eigenlijk identiek aan de originele-aanvraagtabel in de meeste gevallen
- Map [verzamelbestanden](https://github.com/provinciesincijfers/gebiedsniveaus/tree/master/verzamelbestanden): bestanden  met alle gebiedsindelingen samen, bouwende vanuit de statistische sectoren. Dit afzonderlijk voor de oude statistische sectoren (`statsec_2019`) en de nieuwe (`statsec`). 
- Map [data_voor_swing/uploadfiles](https://github.com/provinciesincijfers/gebiedsniveaus/tree/master/data_voor_swing/uploadfiles). Dit zijn bestanden die je achteraf zelf kunt inlezen in Swing; ze bevatten metadata over de gebieden zelf (naam, code, wijktype)

*Opgelet: zelfs als je enkel de wijken update, moet je ook de eerste helft van **2 geo_verzamel_aggregatie.sps** draaien om de verzameltabellen te updaten, en **4 lijst_alle_gebieden_met_naam.sps** om de uploadfiles met gebiedscode en gebiedsnaam aan te maken.*

Het verwerkte bestand [statsec als basis](https://github.com/provinciesincijfers/gebiedsniveaus/blob/master/verzamelbestanden/statsec_als_basis.xlsx) koppelen we aan een geografisch bestand van de statistische sectoren. Vervolgens kunnen we in GIS op basis van dat bestand het geografisch bestand maken per gebiedsniveau. Dit is dan eenvoudig een geografische aggregatie. De grenzen vallen per definitie allemaal mooi samen.

  - Praktisch: maak een vereenvoudigde versie van de statsec (indien nog niet beschikbaar). Dit doen we in [Mapshaper](https://mapshaper.org/). Gebruik de optie &quot;-clean&quot; om er fouten uit te halen.
  - Open de output in QGIS.
  - Koppel aan een bijgewerkte versie van [verwerkt_alle_gebiedsniveaus.xlsx](https://github.com/provinciesincijfers/gebiedsniveaus/blob/master/verzamelbestanden/verwerkt_alle_gebiedsniveaus.xlsx)
  - Exporteer deze verrijkte versie van de sectoren naar een nieuwe shapefile om er vlot mee te kunnen werken
  - Gebruik de GDAL-functie _Samensmelten_ om de statsec die een gemeenschappelijke gebiedscode hebben op het nieuwe niveau tot één object te versmelten.
  - Opgelet: bij deze operatie ontstaan soms artefacten; verdwaalde stukjes grens zonder betekenis. Dit kan je vermijden mits een goede cleaning van je basislaag. Gebruik je een nieuwe basislaag, controleer dan eens of ze goed is door eerst naar gewest samen te smelten en dan te controleren op artefacten._
  - Verwijder kaart-objecten die geen zinvolle gebiedscode hebben (ggw7 met een ZZZZ code aan het strand; indelingen waar Brussel niet gedefinieerd is, ...)
  - Converteer naar GeoJSON voor [kiezen_op_kaart](https://github.com/provinciesincijfers/kiezen_op_kaart/) (verdere instructies daar te vinden)

Bij het draaien van de scripts worden alle relevante bestanden automatisch in de juiste map gezet. Enkel de shapefiles moet je manueel in de map [data_voor_swing/shapefiles](https://github.com/provinciesincijfers/gebiedsniveaus/tree/master/data_voor_swing/shapefiles) zetten. 

Opgelet: soms is het nodig om niet enkel NAAR je gebiedsniveau te aggregeren, maar ook VAN je gebiedsniveau naar hogere gebiedsniveaus te aggregeren. Indien je dit nalaat, dan kan je de hogere gebiedsniveaus niet uitsplitsen naar je nieuwe gebiedsniveau. De basisstructuur van de hiërarchie van gebiedsindelingen wordt hieronder uitgelegd.

Dan laten we aan ABF weten dat er nieuwe gebiedsniveau informatie klaar staat, en lezen zij die in in Swing.
We moeten vervolgens nog enkele stappen uitvoeren:
- de uploadfiles zelf opladen
- kiezen op kaart updaten (indien nodig)
- de metadata op https://provincies.incijfers.be/info/9900_gebiedsniveaus.html aanvullen. 
- nieuwe gebiedsniveaus toevoegen aan het rapport met [meer info over een gebied](https://provincies.incijfers.be/databank/jivereportcontents.ashx?report=gebiedsinfo)
- bij Geolevels vul de velden InfoURL en Reportcode nog aan met de juiste verwijzingen en pas je (indien nodig) de sequencenr aan.
- bij AccesGroups verschuif je het geolevel van 'not visible' naar 'visible'.
- de update aanvullen in het [logboek](https://provincies.incijfers.be/databank?report=logboek)
- indien belangrijke wijzigingen: een nieuwe [release](https://github.com/provinciesincijfers/gebiedsniveaus/releases) maken en dit per mail melden aan geïnteresseerde partners
- de fiche op metadata.vlaanderen.be updaten (indien er nieuwe wijkindelingen zijn)


## Hiërarchie

Om data te laten optellen en om gebieden uit te kunnen splitsen, moeten er aggregatietabellen voorzien worden. Die bevatten informatie van het type _gebied X en gebied Y tellen op tot gebied op hoger schaalniveau A_. Deze vormen deels een hiërarchie. Wanneer dat het geval is, dan is het niet meer nodig om als V optelt tot W en W tot X ook nog eens te definiëren hoe V optelt tot X.

Opmerkingen: 
* We zitten met een dubbele hiërarchie zolang de twee versies van gemeenten in gebruik zijn.
* [Onze wijkindeling](https://github.com/provinciesincijfers/gebiedsniveaus/tree/master/gemeente_statsec_wijken) aggregeert wel naar gemeente, maar niet naar deelgemeente.
* Een heel aantal indelingen zijn een &quot;doodlopend straatje&quot; dat niet verder aggregeert naar hogere gebiedsniveaus, behalve doorgaans naar gewest. Echter is er geen bovenliggend gebied dat Brussel, Vlaanderen en onbekende gebieden omvat. Als er dus een gebied is dat zowel Vlaamse als Brusselse gebieden omvat, dan kan dit niet verder geaggregeerd worden.
