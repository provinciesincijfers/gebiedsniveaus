# Wijzigende gebiedsindelingen

Af en toe wijzigen de basisindelingen die we gebruiken. Dat is met name het geval voor statistische sectoren en gemeenten. De enige wijzigingen die relevant zijn voor de gebruiker van de toepassing zijn er waar de gebiedscodes wijzigen.

Als algemeen principe geldt:
We wijzigen de code van het gebiedsniveau van de oude versie. Daarbij geven we een achtervoegsel dat aangeeft wanneer de indeling ophield te bestaan op deze manier. Dus de gebiedsniveaucode `gemeente` blijft steeds verwijzen naar "de huidige gemeenten". De "oude" gemeenten blijven raadpleegbaar via `gemeente_2018`.

Er zijn ook steeds frequentere wijzigingen in de geometrie van de gebieden. Dit heeft voor provincies.incijfers.be weinig impact. Wel kan dit aanleiding geven tot de nood om bepaalde geografische berekeningen opnieuw uit te voeren. Dit gebeurt echter achter de schermen.

Door de hier beschreven manier van werken, is het mogelijk om onmiddellijk mee te zijn met de nieuwe indelingen van zodra deze ingaan - of soms zelfs al op voorhand!

Inhoud:

* [Gemeentefusies 1 januari 2025](#gemeentefusies-1-januari-2025)
* [Gemeentefusies 1 januari 2019](#gemeentefusies-1-januari-2019)
* [Evoluerende statistische sectoren](#evoluerende-statistische-sectoren)
  
## Gemeentefusies 1 januari 2025

Op 1 januari hielden een aantal Vlaamse en twee Waalse gemeenten op te bestaan, en werden enkele nieuwe gemeenten geboren. 
Dit document beschrijft kort hoe we deze aanpassing verwerken in provincies.incijfers.be.

Voor meer context op de impact op niscodes, zie [de pagina van statbel](https://statbel.fgov.be/nl/over-statbel/methodologie/classificaties/geografie).

De geaffecteerde gemeenten:

gemeente2024 | naam gemeente 2024 | gemeente |  naam huidige gemeente
-- | -- | -- | --
11002 | Antwerpen | 11002 | Antwerpen
11007 | Borsbeek | 11002 | Antwerpen
23023 | Galmaarden | 23106 | Pajottegem 
23024 | Gooik | 23106 | Pajottegem 
23032 | Herne | 23106 | Pajottegem 
37012 | Ruiselede | 37021 | Wingene
37018 | Wingene | 37021 | Wingene
37007 | Meulebeke | 37022 | Tielt 
37015 | Tielt | 37022 | Tielt 
44012 | De Pinte | 44086 | Nazareth-De Pinte
44048 | Nazareth | 44086 | Nazareth-De Pinte
44034 | Lochristi | 44087 | Lochristi
44073 | Wachtebeke | 44087 | Lochristi
46014 | Lokeren | 46029 | Lokeren
44045 | Moerbeke | 46029 | Lokeren
44040 | Melle | 44088 | Merelbeke-Melle
44043 | Merelbeke | 44088 | Merelbeke-Melle
46003 | Beveren | 46030 | Beveren-Kruibeke-Zwijndrecht
46013 | Kruibeke | 46030 | Beveren-Kruibeke-Zwijndrecht
11056 | Zwijndrecht | 46030 | Beveren-Kruibeke-Zwijndrecht
73006 | Bilzen | 73110 | Bilzen-Hoeselt
73032 | Hoeselt | 73110 | Bilzen-Hoeselt
73009 | Borgloon | 73111 | Tongeren-Borgloon
73083 | Tongeren | 73111 | Tongeren-Borgloon
71069 | Ham | 71071 | Tessenderlo-Ham
71057 | Tessenderlo | 71071 | Tessenderlo-Ham
71022 | Hasselt | 71072 | Hasselt
73040 | Kortessem | 71072 | Hasselt
82003* | Basogne | 82039 | Bastogne
82005* | Bertogne | 82039 | Bastogne

*: Waalse gemeente


**STATISTISCHE SECTORNIVEAU**

De sectorcodes bleven ongewijzigd. **Opgelet: je kan daardoor niet meer op basis van de sectorcode de NIS-code van de gemeente waar het ligt achterhalen**. Je moet dus beschikken over een koppeltabel!

De statistische sectoren en de sub-gemeente-niveaus moesten niet aangepast worden.

Om data die op sectorniveau ingeladen wordt op de nieuwe gemeenten te kunnen tonen, hebben we enkel een nieuwe aggregatietabellen voorzien die zegt in welke nieuwe gemeente de oude sector ligt.

Uitzondering: data die niet aggregeerbaar is. Dit moest altijd al op meerdere gebiedsniveaus ingelezen worden. Zie daarvoor het volgende stukje.



**GEMEENTENIVEAU**

Eerst wijzigden we de gebiedsniveaucode gemeente naar `gemeente_2024`. Al de data die op gemeenteniveau beschikbaar was, blijft dan gewoon correct - voor die verouderde gemeenten.

We kunnen nu een nieuwe versie van de gemeenten inladen, met de code `gemeente`.

Deze heeft uiteraard nog geen data. We voorzien een aggregatietabel van de oude naar de nieuwe gemeenten en van de nieuwe gemeenten naar alle hiervan afgeleide gebiedsniveaus. Swing aggregeert nu zelf alle aggregeerbare data van de oude naar de nieuwe gemeenten. 

Tot 1 januari houden we de nieuwe gemeenten deels achter de schermen. Op 1 januari draaien we de rollen om. Dan kunnen we achter de schermen nog steeds de oude gemeenten laten zien.

**PROVINCIENIVEAU**
Zwijndrecht behoorde voor de fusies tot de provincie Antwerpen. Na de fusie behoort de fusiegemeente Beveren-Kruibeke-Zwijndrecht tot de provincie Oost-Vlaanderen. Hierdoor werd er een nieuw provincieniveau gemaakt. Het oude blijft bestaan onder provincie2024.

**Impact op databeheer**

- data op sectorniveau blijft ongewijzigd
- data die op het oude gemeenteniveau wordt geleverd kan nog steeds ingelezen worden op `gemeente_2024`
- data die op het nieuwe gemeenteniveau wordt geleverd kan gewoon ingelezen worden door te werken met `gemeente`

Uitzondering blijft niet-aggregeerbare data. Denk bijvoorbeeld aan een mediaan inkomen. Hiervoor moet de leverancier aangepaste cijfers opleveren. Om de meeste problemen op te lossen, exporteren we deze data uit het oude gemeenteniveau en lezen ze manueel in op het nieuwe gemeenteniveau. De nieuw ontstane gemeenten blijven dus leeg, tot de dataleverancier hier een historiek voor kan aanleveren. Let op met gemiddelden die aggregeren. Hierdoor wordt het verkeerde gemiddelde berekend omdat hij de gemeenten die nu leeg zijn, wel meerekent. Vermijdt dit door de mogelijkheid tot aggregeren even af te zetten totdat je data hebt voor de nieuwe gemeenten (of andere niveaus) of door de oude data te laten staan en niet opnieuw in te laden of gebruik een voetnoot:
- De gegevens van de gemeenten moeten ingeladen worden met geolevel gemeente2024 omdat het nog om de oude gemeenten gaan. Om toch een waarde voor stad Antwerpen te hebben wordt dit cijfer nog eens apart ingeladen met geolevel gemeente. In de voetnoot wordt vermeld dat bij het cijfer van Antwerpen Borsbeek niet is meegeteld.
- De gegevens van de provincies en arrondissementen moeten ingeladen worden met geolevel provincie2024 en arrondissement2024 want het gaat nog om de oude provincies en arrondissementen. Om de cijfers toch te tonen als provincie of arrondissement wordt aangeduid, worden ze nogmaals ingeladen maar met geolevel provincie en arrondissement. Er staat dan een voetnoot bij om ervoor te waarschuwen dat het om de oude provincies en arrondissementen gaat.

Let ook op met waarden die door de data-leverancier gecensureerd worden (-99997), deze tellen immers niet op binnen PinC. Wanneer je een dergelijke missing hebt voor bv. Borsbeek, dan zal je in de nieuwe fusiegemeente Antwerpen ook nog steeds deze missing zien staan, ook al heeft de voormalige gemeente Antwerpen wel cijfers. 

**Zijdelingse impact**
* Arrondissementen wijzigden ook, en werden volgens dezelfde logica aangepast
* Een aantal gemeenten die fusseerden behoorden tot verschillende bovengemeentelijke niveaus. Daarom werden zo goed als alle aggregaties opnieuw berrekend. 



## Gemeentefusies 1 januari 2019

Op 1 januari hielden enkele Vlaamse gemeenten op te bestaan, en werden enkele nieuwe gemeenten geboren. 
Dit document beschrijft kort hoe we deze aanpassing verwerken in provincies.incijfers.be.

Voor meer context op de impact op niscodes, zie [de pagina van statbel](https://statbel.fgov.be/nl/over-statbel/methodologie/classificaties/geografie)

De geaffecteerde gemeenten:

gemeente2018 | naam gemeente 2018 | gemeente |  naam huidige gemeente
-- | -- | -- | --
12030 | Puurs | 12041 | Puurs-Sint-Amands
12034 | Sint-Amands | 12041 | Puurs-Sint-Amands
44011 | Deinze | 44083 | Deinze
44049 | Nevele | 44083 | Deinze
44001 | Aalter | 44084 | Aalter
44029 | Knesselare | 44084 | Aalter
44036 | Lovendegem | 44085 | Lievegem
44072 | Waarschoot | 44085 | Lievegem
44080 | Zomergem | 44085 | Lievegem
45017 | Kruishoutem | 45068 | Kruisem
45057 | Zingem | 45068 | Kruisem
71047 | Opglabbeek | 72042 | Oudsbergen
72040 | Meeuwen-Gruitrode | 72042 | Oudsbergen
72025 | Neerpelt | 72043 | Pelt
72029 | Overpelt | 72043 | Pelt


**STATISTISCHE SECTORNIVEAU**

De sectorcodes bleven ongewijzigd. **Opgelet: je kan daardoor niet meer op basis van de sectorcode de NIS-code van de gemeente waar het ligt achterhalen**. Je moet dus beschikken over een koppeltabel!

De statistische sectoren en de sub-gemeente-niveaus moesten niet aangepast worden.

Om data die op sectorniveau ingeladen wordt op de nieuwe gemeenten te kunnen tonen, hebben we enkel een nieuwe aggregatietabellen voorzien die zegt in welke nieuwe gemeente de oude sector ligt.

Uitzondering: data die niet aggregeerbaar is. Dit moest altijd al op meerdere gebiedsniveaus ingelezen worden. Zie daarvoor het volgende stukje.



**GEMEENTENIVEAU**

Eerst wijzigden we de gebiedsniveaucode gemeente naar `gemeente_2018`. Al de data die op gemeenteniveau beschikbaar was, blijft dan gewoon correct - voor die verouderde gemeenten.

We kunnen nu een nieuwe versie van de gemeenten inladen, met de code `gemeente`.

Deze heeft uiteraard nog geen data. We voorzien een aggregatietabel van de oude naar de nieuwe gemeenten en van de nieuwe gemeenten naar alle hiervan afgeleide gebiedsniveaus. Swing aggregeert nu zelf alle aggregeerbare data van de oude naar de nieuwe gemeenten. 

Tot 1 januari houden we de nieuwe gemeenten deels achter de schermen. Op 1 januari draaien we de rollen om. Dan kunnen we achter de schermen nog steeds de oude gemeenten laten zien.


**Impact op databeheer**
Naar databeheer is er dus bijna geen probleem.

- data op sectorniveau blijft ongewijzigd
- data die op het oude gemeenteniveau wordt geleverd kan nog steeds ingelezen worden op `gemeente_2018`
- data die op het nieuwe gemeenteniveau wordt geleverd kan gewoon ingelezen worden door te werken met `gemeente`

Uitzondering blijft niet-aggregeerbare data. Denk bijvoorbeeld aan een mediaan inkomen. Hiervoor moet de leverancier aangepaste cijfers opleveren. Om de meeste problemen op te lossen, exporteren we deze data uit het oude gemeenteniveau en lezen ze manueel in op het nieuwe gemeenteniveau. De nieuw ontstane gemeenten blijven dus leeg, tot de dataleverancier hier een historiek voor kan aanleveren.

**Zijdelingse impact**
* Enkele indelingen waren niet meer mogelijk en werden verwijderd
* Arrondissementen wijzigden ook, en werden volgens dezelfde logica aangepast



## Evoluerende statistische sectoren

provincies.incijfers.be werkt op dit moment met de [statistische sectoren versie 1/1/2020, zoals gepubliceerd op Statbel](https://statbel.fgov.be/nl/open-data/statistische-sectoren-2020). Deze versie wordt zowel gebruikt in de online tool als voor analyse. Voor de online versie werken we met een vereenvoudigde geometrie, om de laadtijd van de website optimaal te houden. Voor analyse gebruiken we de originele versie.

### Wanneer volgt provincies.incijfers.be?

De statistische sectoren zijn relatief onveranderlijke eenheden. Vroeger werden deze om de tien jaar licht herzien, vooral als gevolg van grote evoluties van de bevolking. Sinds 2011 was er geen grote herziening meer. Vanaf 2019 zijn er wel enkele bewegingen. Sindsdien heeft Statbel jaarlijks een nieuwe versie online gezet
- in [2019](https://statbel.fgov.be/nl/open-data/statistische-sectoren-2019) was dit een fundamentele wijziging: voor het eerst werden de grenzen zonder vereenvoudiging als open data gepubliceerd. In Stad Antwerpen was er ook een kleine inhoudelijke wijziging. De definitie van de kustlijn werd aangepast, waardoor alle kustgemeenten een strandsector kregen.
- in [2020](https://statbel.fgov.be/nl/open-data/statistische-sectoren-2020) was er enkel een wijziging in geometrie: vooral aan gemeentegrenzen zijn er kleine aanpassingen. In Stad Antwerpen waren er relatief grenscorrecties aan de districten
- in [2021](https://statbel.fgov.be/nl/open-data/statistische-sectoren-2021) waren er opnieuwe kleine wijzigingen in de geometrie. Daarnaast werd in de Stad Antwerpen de statistische sector van de Schelde (11002M0PA) opgesplitst op de districtsgrens Antwerpen/Bezali (11002M0RA en 11002M0QA).

Overstappen naar een nieuwe versie van de statistische sectoren heeft nogal wat implicaties:
- afgeleide gebiedsindelingen moeten bijgewerkt worden ([gemeentegedragen wijken](/gemeente_statsec_wijken), [deelgemeenten](/deelgemeenten))
- de definitie van het gebiedsniveau in Swing moet bijgewerkt worden, of er moet een nieuwe toegevoegd worden
- alle tijdsreeksen in Swing moeten nagekeken worden: kunnen ze zomaar op de nieuwe indeling gezet worden? Geografische analyse moet misschien voor de hele tijdsreeks opnieuw gebeuren.
- inkomende en uitgaande [Swing Connectors](https://github.com/provinciesincijfers/connectorbeheer) moeten nagekeken worden. Moeten de partners eventueel ook aanpassingen doen in hun databeheer? Of kunnen we voor de specifieke connector zonder aanpassingen verder?

Er is dus een kosten-baten ananlyse te maken:
- voor processen waar we steeds de hele historiek verwerken, werken we liefst met een zo recent mogelijke geometrie
- voor processen waar we zelf de historiek niet kunnen herverwerken, of waar dit arbeidsintensief is, houden we de zaken liefst zo stabiel mogelijk

We houden daarom de gebiedsdefinitie (welke statsec bestaan, welke niet) zo stabiel mogelijk. We passen deze enkel aan indien er significante inhoudelijke wijzigingen in de sectoren zijn, en doen dit in principe hoogstens om de vijf jaar. Voor analyse werken we bij voorkeur met de versie die we voor Swing gebruiken. Enkel indien er een grote meerwaarde is van met de recentste geometrie te werken, kan de verwerker van een specifieke reeks er voor kiezen om met een recentere versie te werken voor een specifieke verwerking. Het is dan de verantwoordelijkheid van deze verwerker om de resultaten om te zetten naar de gebiedsdefinitie zoals deze in Swing bestaat.

Hieronder volgt een historiek van de historische wijzigingen van de statistische sectoren in provincies.incijfers.be

### Update statistische sectoren in provincies.incijfers.be 2020

Tot en met 2019 gebruikten we voor **publicatie** een vereenvoudigde versie van de statistische sectoren [zoals NGI die publiceert ("ADMIN VEC")](https://www.geo.be/catalog/details/fb1e2993-2020-428c-9188-eb5f75e284b9?l=nl). Voor **analyse** gebruikten we de statistische sectoren die statbel publiceerde, om zo dicht mogelijk bij hun analyses te blijven.


Drie nieuwswaardige feiten noopten tot een update van de statistische sectoren die we gebruiken voor analyse én voor Swing.

- In de stad Antwerpen is er een &quot;grenscorrectie&quot; van een district. Omdat dit juridische gevolgen heeft, was statbel bereid om hier een grensverlegging van de statistische sectoren te doen. Op die manier kan je nog steeds cijfers over districten bouwen op basis van statistische sectoren
- Aan de kust zijn er extra statistische sectoren gedefinieerd
- De dataset van statbel is in kwaliteit verhoogd: gemeentegrenzen wijken veel minder af van het &quot;voorlopig referentiebestand gemeentegrenzen&quot; dan vroeger. In oktober 2019 volgde nog een verder verbeterde versie. De open dataset zal niet meer met sterk vereenvoudigde geometrie gepubliceerd worden, maar in al zijn oorspronkelijke geometrische glorie

Dit betekent dat we:

- Een aanpassing moeten doen in PinC om de Stad Antwerpen met data te kunnen blijven voeden
- Een aanpassing moeten doen in PinC om oppervlakte-gerelateerde cijfers correct weer te kunnen geven op laag geometrisch niveau
- We vanaf nu één enkele dataset kunnen gebruiken voor zowel PinC als analyse. Bovendien gaat ruimtelijke analyse nu een veel kleinere foutenmarge hebben (vb. adrespunten die niet in de juiste gemeente liggen).

Opmerking: voor Swing (PinC) hebben we de conventie om het eindjaar toe te voegen van gebiedsindelingen die ophouden te bestaan, en de nieuwe versie zonder clarificatie te behouden. Verder bedoelen we met &quot;statsec&quot; de nieuwe statistische sectoren en &quot;statsec2019&quot; de versie die eindigt in het jaar 2019.

Op de kaartjes is de rode info steeds &quot;oud&quot; en de blauwe &quot;nieuw&quot;.

Het heeft lang geduurd eer statbel zelf de indeling publiceerde. Geopunt deed dit eerst. Daarom werken we met [de versie die daar is gepubliceerd](http://www.geopunt.be/catalogus/datasetfolder/c2acf4e7-bcdd-4ea0-9702-37023b08638e). Deze is lichtjes vereenvoudigd, maar zeker niet in de mate dat dit vroeger gedaan werd. 
Later ontdekten we dat ook NGI de nieuwe versie inclusief geometrie publiceert; zie [de federale data site](https://data.gov.be/en/dataset/fb1e2993-2020-428c-9188-eb5f75e284b9)
![afbeelding](https://user-images.githubusercontent.com/10122639/109805994-6c259000-7c24-11eb-939c-f724169a913a.png)
Later werd dit nog toegevoegd aan [statbel](https://statbel.fgov.be/nl/over-statbel/methodologie/classificaties/geografie) zelf. Inmiddels zijn er daar zelfs meerdere versies te vinden.

#### Wat wijzigt er precies?

##### In de Stad Antwerpen

De kaart hieronder toont de wijzigingen.

![afbeelding](https://user-images.githubusercontent.com/10122639/109805541-dee23b80-7c23-11eb-86ca-cff8f38bea3b.png)

De Stad leverde onderstaande conversietabel aan. Ondanks de grenscorrecties, kan deze tabel gebruikt worden voor het aggregeren van socio-economische gegevens. Immers liggen de adressen bijna steeds bijna geheel in één enkele sector.

| statsec2019 | statsec | deelgemeente2019\_naam | deelgemeente\_naam |
| --- | --- | --- | --- |
| 11002J81- | 11002J8AN | Antwerpen | Antwerpen |
| 11002J881 | 11002P6FK | Antwerpen | Ekeren |
| 11002J901 | 11002P6CK | Antwerpen | Ekeren |
| 11002J912 | 11002P6DK | Antwerpen | Ekeren |
| 11002J923 | 11002P6BK | Antwerpen | Ekeren |
| 11002J932 | 11002P6EK | Antwerpen | Ekeren |
| 11002J94- | 11002P6AK | Antwerpen | Ekeren |
| 11002K174 | 11002K1NP | Antwerpen | Antwerpen |
| 11002K1MN | 11002K1WN | Antwerpen | Antwerpen |
|    | 11002P6PK | Antwerpen | Ekeren |
| 11002P21- | 11002P2AP | Ekeren | Ekeren |
| 11002P291 | 11002P2AN | Ekeren | Ekeren |
| 11002Q2PA | 11002Q2PP | Merksem | Merksem |

Daarnaast leverde de Stad ook een lijst op van geaffecteerde adressen. Een aantal adressen en straten veranderen van postcode. Het gaat in totaal om een 500-tal adressen. De Stad leverde ook info aan om de aggregatie naar [wijken](https://github.com/provinciesincijfers/gebiedsniveaus/tree/master/gemeente_statsec_wijken) en [deelgemeenten](https://github.com/provinciesincijfers/gebiedsniveaus/tree/master/deelgemeenten) (=districten) volgens hun logica te kunnen doen.


##### Aan de kust

![afbeelding](https://user-images.githubusercontent.com/10122639/109805586-eefa1b00-7c23-11eb-9d46-57e17ee50d68.png)

Langsheen de hele kust worden de sectoren die de kustlijn vormden ietsje kleiner, en worden er nieuwe sectoren gedefinieerd die het stuk &quot;zee&quot; tussen eb- en vloedlijn bevatten.

Bij een snelle scan zagen we slechts een impact op één adres. 
De nieuwe sectoren krijgen steeds de code [NISCODE]X0JQ en de naam &quot;STRAND&quot;. Behalve Nieuwpoort dat een OOST-STRAND (38016X0JQ) en een WEST-STRAND (38016X1JQ) krijgt.

Er is doorgaans slechts één sector per gemeente gedefinieerd. Hierdoor kunnen deze niet aan onze subgemeentelijke indelingen toegekend worden, want doorgaans zijn er meerdere wijken die op het starnd uitgeven. In de plaats komen ze steeds bij &quot;gebied onbekend&quot; terecht.

##### Verbeterde geometrie

Grenzen zijn verbeterd. Met name aan de gemeentegrenzen is veel verbeterd. Men werkt hiervoor met de (toekomstige) authentieke bron, namelijk het kadaster. Dat is enigszins jammer, omdat in Vlaanderen men meer werkt met het &quot;voorlopig referentiebestand gemeentegrenzen&quot;. Alle wijzigingen in dit voorlopig bestand stromen uiteindelijk door naar het federale kadaster en dan zo naar statbel en uiteindelijk de statistische sectoren. Verdere grenscorrecties worden op termijn wel toegepast in dat bestand.

Daarnaast (zie voorbeeld) zijn ook grenzen die niet aan een gemeentegrens liggen aangepast.

![afbeelding](https://user-images.githubusercontent.com/10122639/109805611-fa4d4680-7c23-11eb-9288-d3c0804f3e9a.png)

Het toewijzen van CRAB-adressen op basis van hun coördinaat aan een statistische sector was vroeger enigszins problematisch. Voor een groot stuk lag dat aan de slechte geometrie van die versie. Voor een deel ligt dit aan de exacte plaats van het punt zoals het in CRAB was gedefinieerd. Bij het bepalen van de exacte adrespositie, wordt doorgaans géén rekening gehouden met statistische gebiedsindelingen.

Op basis van de nieuwe versie van de statsec en een verse dump van het CRAB, deed Karin van de GIS-dienst van Limburg eeb controle van in hoeverre dit probleem zich nog voordoet. We kunnen het enkel controleren wat betreft gemeentegrenzen. De oefening bestond eruit om na te gaan welke adressen die door het CRAB gedefinieerd zijn als &quot;behorende tot Gemeente X&quot; na ruimtelijke doordruk NIET in die Gemeente X blijken te liggen.

![afbeelding](https://user-images.githubusercontent.com/10122639/109805738-1bae3280-7c24-11eb-9b11-b70b5609dbc6.png)

Voor heel Vlaanderen blijkt het om slechts 137 gevallen te gaan. Er zijn verschillende oorzaken aan te wijzen. Voor een deel zijn deze oplosbaar aan CRAB-kant. Bijvoorbeeld hebben huizen soms adressen van twee gemeenten gekregen, waar dat eigenlijk niet logisch lijkt. Heel vaak gaat het echter om percelen of zelfs huizen die doorsneden worden door een grens. In die gevallen is het sowieso lastig om een gebied geometrisch toe kennen, aangezien het hier steeds om speciale gevallen gaat. De grootte-orde van het probleem laat toe om het ofwel te negeren, ofwel er een automatische oplossing voor te verzinnen. In enkele gevallen is het wellicht de moeite om hier een CRAB-melding voor te doen.



