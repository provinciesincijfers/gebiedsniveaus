# gebiedsniveaus
Deze omgeving bevat alles in verband met de organisatie van gebiedsniveaus


## Onderdelen:

[gebiedsniveaus_voorstellen_verwerken.md](https://github.com/provinciesincijfers/gebiedsniveaus/blob/master/gebiedsniveaus_voorstellen_verwerken.md): uitleg over hoe je een nieuwe gebiedsindeling voor Swing kunt voorstellen. Gevolgd door een praktisch stappenplan dat de databeheerders van Swing volgen om de input te verwerken.

[wijzigende_gebiedsindelingen.md](https://github.com/provinciesincijfers/gebiedsniveaus/blob/master/wijzigende_gebiedsindelingen.md): uitleg over hoe we omgaan met wijzigingen in de basisindelingen die we gebruiken. In casu gemeentefusies en een herdefiniëring van de statistische sectoren.


### data_voor_swing
bestanden in Swing-formaat om aan de toepassing duidelijk te maken hoe de gebiedsniveaus in elkaar zitten 

- aggregatietabellen: hoe moet swing van een gedetailleerd gebiedsniveau een eenvoudiger gebiedsniveau maken
- gebiedsdefinities: per gebiedsniveau de code en de naam van de gebieden
- shapefiles: de geometrie van de gebiedsniveaus. Perfect overlappen en vereenvoudigde geometrie voor online gebruik
- uploadfiles: beschrijvende info over de gebieden die we zelf in Swing inlezen

### deelgemeenten
Uitleg over hoe onze deelgemeenten tot stand kwamen, en een csv met de indeling voor heel België

### gemeente_statsec_wijken
Uitleg en info over onze op statistische sectoren gebaseerde wijkindeling. Dit luik bevat enkel het stuk wijken die we van de gemeenten hebben ontvangen; en uitleg over hoe je als gemeente dit kunt aandragen.

### kerntabellen
Op basis van deze tabellen maken we onze gebiedsniveaus aan. Om een nieuw gebiedsniveau toe te kunnen voegen, is dus enkel een tabel nodig van het formaat zoals je daar kan vinden

### scripts
We moeten de gebiedsindelingen regelmatig bijwerken. Dit vraagt een enigszins omslachtige verwerking. Om fouten te vermijden, is dit grotendeels geautomatiseerd aan de hand van SPSS scripts.

### verzamelbestanden
Hier vind je tabellen die alle informatie bundelen over welke gebiedsniveaus optellen naar welke.

Algemene opmerking: gebiedsniveaus die enkel nog om historische redenen zijn opgenomen, kan je herkennen aan het jaartal aan het einde van de naam. Het betreft het laatste jaar dat ze de officiële versie waren.
