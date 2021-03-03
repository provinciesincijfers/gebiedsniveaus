# Wijzigende gebiedsindelingen

Af en toe wijzigen de basisindelingen die we gebruiken. Dat is met name het geval voor statistische sectoren en gemeenten. De enige wijzigingen die relevant zijn voor de gebruiker van de toepassing zijn er waar de gebiedscodes wijzigen.

Als algemeen principe geldt:
We wijzigen de code van het gebiedsniveau van de oude versie. Daarbij geven we een achtervoegsel dat aangeeft wanneer de indeling ophield te bestaan op deze manier. Dus de gebiedsniveaucode `gemeente` blijft steeds verwijzen naar "de huidige gemeenten". De "oude" gemeenten blijven raadpleegbaar via `gemeente_2018`.

Er zijn ook steeds frequentere wijzigingen in de geometrie van de gebieden. Dit heeft voor provincies.incijfers.be weinig impact. Wel kan dit aanleiding geven tot de nood om bepaalde geografische berekeningen opnieuw uit te voeren. Dit gebeurt echter achter de schermen.

Door de hier beschreven manier van werken, is het mogelijk om onmiddellijk mee te zijn met de nieuwe indelingen van zodra deze ingaan - of soms zelfs al op voorhand!

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

