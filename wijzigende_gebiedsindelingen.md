# Wijzigende gebiedsindelingen

Af en toe wijzigen de basisindelingen die we gebruiken. Dat is met name het geval voor statistische sectoren en gemeenten. De enige wijzigingen die relevant zijn voor de gebruiker van de toepassing zijn er waar de gebiedscodes wijzigen.

Als algemeen principe geldt:
We wijzigen de code van het gebiedsniveau van de oude versie. Daarbij geven we een achtervoegsel dat aangeeft wanneer de indeling ophield te bestaan op deze manier. Dus de gebiedsniveaucode `gemeente` blijft steeds verwijzen naar "de huidige gemeenten". De "oude" gemeenten blijven raadpleegbaar via `gemeente_2018`.

Er zijn ook steeds frequentere wijzigingen in de geometrie van de gebieden. Dit heeft voor provincies.incijfers.be weinig impact. Wel kan dit aanleiding geven tot de nood om bepaalde geografische berekeningen opnieuw uit te voeren. Dit gebeurt echter achter de schermen.

Door de hier beschreven manier van werken, is het mogelijk om onmiddellijk mee te zijn met de nieuwe indelingen van zodra deze ingaan - of soms zelfs al op voorhand!

Inhoud:

* [Gemeentefusies 1 januari 2019](#gemeentefusies-1-januari-2019)
* [Wijziging statsec 1 januari 2020](#statsec-1-januari-2020)

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
* Enkele indelingen waren niet mogelijk en werden verwijderd
* Arrondissementen wijzigden ook, en werden volgens dezelfde logica aangepast



## statsec 1 januari 2020

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

### Wat wijzigt er precies?

#### In de Stad Antwerpen

De kaart hieronder toont de wijzigingen.

![afbeelding](https://user-images.githubusercontent.com/10122639/109805541-dee23b80-7c23-11eb-86ca-cff8f38bea3b.png)

De Stad leverde onderstaande conversietabel aan. Ondanks de grenscorrecties, kan deze tabel gebruikt worden voor het aggregeren van socio-economische gegevens. Immers liggen de adressen bijna steeds bijna geheel in één enkele sector.

|
statsec2019 | statsec | deelgemeente2019\_naam | deelgemeente\_naam |
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


#### Aan de kust

![afbeelding](https://user-images.githubusercontent.com/10122639/109805586-eefa1b00-7c23-11eb-9d46-57e17ee50d68.png)

Langsheen de hele kust worden de sectoren die de kustlijn vormden ietsje kleiner, en worden er nieuwe sectoren gedefinieerd die het stuk &quot;zee&quot; tussen eb- en vloedlijn bevatten.

Bij een snelle scan zagen we slechts een impact op één adres. 
De nieuwe sectoren krijgen steeds de code [NISCODE]X0JQ en de naam &quot;STRAND&quot;. Behalve Nieuwpoort dat een OOST-STRAND (38016X0JQ) en een WEST-STRAND (38016X1JQ) krijgt.

Er is doorgaans slechts één sector per gemeente gedefinieerd. Hierdoor kunnen deze niet aan onze subgemeentelijke indelingen toegekend worden, want doorgaans zijn er meerdere wijken die op het starnd uitgeven. In de plaats komen ze steeds bij &quot;gebied onbekend&quot; terecht.

#### Verbeterde geometrie

Grenzen zijn verbeterd. Met name aan de gemeentegrenzen is veel verbeterd. Men werkt hiervoor met de (toekomstige) authentieke bron, namelijk het kadaster. Dat is enigszins jammer, omdat in Vlaanderen men meer werkt met het &quot;voorlopig referentiebestand gemeentegrenzen&quot;. Alle wijzigingen in dit voorlopig bestand stromen uiteindelijk door naar het federale kadaster en dan zo naar statbel en uiteindelijk de statistische sectoren. Verdere grenscorrecties worden op termijn wel toegepast in dat bestand.

Daarnaast (zie voorbeeld) zijn ook grenzen die niet aan een gemeentegrens liggen aangepast.

![afbeelding](https://user-images.githubusercontent.com/10122639/109805611-fa4d4680-7c23-11eb-9288-d3c0804f3e9a.png)

Het toewijzen van CRAB-adressen op basis van hun coördinaat aan een statistische sector was vroeger enigszins problematisch. Voor een groot stuk lag dat aan de slechte geometrie van die versie. Voor een deel ligt dit aan de exacte plaats van het punt zoals het in CRAB was gedefinieerd. Bij het bepalen van de exacte adrespositie, wordt doorgaans géén rekening gehouden met statistische gebiedsindelingen.

Op basis van de nieuwe versie van de statsec en een verse dump van het CRAB, deed Karin van de GIS-dienst van Limburg eeb controle van in hoeverre dit probleem zich nog voordoet. We kunnen het enkel controleren wat betreft gemeentegrenzen. De oefening bestond eruit om na te gaan welke adressen die door het CRAB gedefinieerd zijn als &quot;behorende tot Gemeente X&quot; na ruimtelijke doordruk NIET in die Gemeente X blijken te liggen.

![afbeelding](https://user-images.githubusercontent.com/10122639/109805738-1bae3280-7c24-11eb-9b11-b70b5609dbc6.png)

Voor heel Vlaanderen blijkt het om slechts 137 gevallen te gaan. Er zijn verschillende oorzaken aan te wijzen. Voor een deel zijn deze oplosbaar aan CRAB-kant. Bijvoorbeeld hebben huizen soms adressen van twee gemeenten gekregen, waar dat eigenlijk niet logisch lijkt. Heel vaak gaat het echter om percelen of zelfs huizen die doorsneden worden door een grens. In die gevallen is het sowieso lastig om een gebied geometrisch toe kennen, aangezien het hier steeds om speciale gevallen gaat. De grootte-orde van het probleem laat toe om het ofwel te negeren, ofwel er een automatische oplossing voor te verzinnen. In enkele gevallen is het wellicht de moeite om hier een CRAB-melding voor te doen.


### Project overzicht aanpassingen in PinC

- Aanmaak van basisdata om gebiedsniveaus aan te kunnen maken
  - statsec2019 naar statsec
    - aanpassen van de naam (want deze bevat de nis9 code)
    - keuze ivm gebied onbekend.
      - Gebied onbekend van de oude statsec aggregeert naar gebied onbekend van de nieuwe statsec
      - In de nieuwe versie gebruiken we een &quot;gebied onbekend&quot; per unieke gemeente zoals die na de fusiegolf van 2018 bestaan.
      - De nieuwe sectoren aan de kust worden NIET opgevuld vanuit de oude sectoren. Er kan daar dus enkel data ingevuld worden door RECHTSTREEKS op die nieuwe sectoren in te laden!
  - statsec naar ggw7
    - enkel impact op stad Antwerpen. Aanpassen zodat deze gebaseerd zijn op nieuwe, niet de oude sectoren.
    - geen impact wat betreft kust
  - statsec naar deelgemeente
    - pmerking: namen van Deelgemeenten uniek gemaakt
    - ude deelgemeenten worden deelgemeente2019, nieuwe &quot;deelgemeente&quot;
    - moest aangepast nav Stad Antwerpen
    - k &quot;gebied onbekend&quot; aangepast zodat er maar één gebied onbekend is per gemeente vanaf 2019
- In de marge hiervan nagaan of het mogelijk/zinvol is een &quot;statsec-conforme versie van de postcodes&quot; te maken. De GIS-diensten maakten een mooie gebiedslaag met alle postzones van België. \&gt; on hold tot BePost zijn postzones als open data vrijgeeft (zie [issue 21](https://github.com/provinciesincijfers/gebiedsniveaus/issues/21)
- Vereenvoudigen van geometrie voor gebruik in Swing
- Omzetten van deze data naar de gebiedsdefinities zoals Swing die nodig heeft: aanpassen bestaande scripts, openstaande todo&#39;s meenemen
- Aanpassen data in PinC
  - Voor aggregeerbare data: geen actie nodig
  - Voor niet-aggregeerbare data: import/export, mits conversie in Stad Antwerpen
  - Impact op connector: enkel voor Stad Brugge en Stad Antwerpen.
    - Brugge: kustsector toevoegen, of niets doen
    - Antwerpen: kiezen of data van statsec2019 naar sector\_oud gaat of van statsec naar sector
- Controleren rapporten; kaarten gebiedsniveaus; kiezen op kaart
- Updaten documentatie AlFresco, Github, metadata gebiedsniveaus
- Publiceren gebiedsniveaus als open data

De kust-sectoren worden bij subgemeentelijke indelingen steeds toegekend aan gebied onbekend. Enkel vanaf gemeenteniveau tellen ze dus volwaardig mee.

