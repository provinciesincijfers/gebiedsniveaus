Vanaf juni 2019 bevat Provincies in Cijfers wijken gebaseerd op [statistische sectoren](https://statbel.fgov.be/nl/over-statbel/methodologie/classificaties/statistische-sectoren). Statistische sectoren zijn de basis voor heel wat beschikbare statistische verwerkingen. Elke wijk bestaat uit minstens één sector, en elke sector wordt aan niet meer of minder dan één wijk toegekend.  We volgen hierbij bij voorkeur de indeling die gemeenten zelf hanteren. Indien er geen sector-gebaseerde indeling bij ons bekend is, dan werken we met een eigen wijkindeling.

## Gemeente-gedragen

Voor de lancering in juni 2019 verzamelden we de ons bekende sector-gebaseerde wijkindelingen van gemeenten. Gemeenten kunnen ons vragen om de wijkindeling voor hun gemeente aan te passen. Neem hiervoor contact op met info@provincies.incijfers.be of [Data & Analyse in uw provincie](https://provincies.incijfers.be/databank?report=project_d_en_a&keepworkspace=true). Verdere aanvullingen of correcties worden halfjaarlijks verwerkt en jaarlijks aangevuld in Provincies in Cijfers.

Voorstellen worden opgenomen onder volgende voorwaarden:
-	Wijken bestaan bijna altijd uit meerdere statistische sectoren. Het kan slechts uitzonderlijk voorkomen dat een wijk slechts uit één sector bestaat (bijvoorbeeld omdat ze zeer atypisch is en heel weinig of net heel veel inwoners bevat. 
-	Wijken zijn doorgaans kleiner dan deelgemeenten. De wijken hoeven echter niet op te tellen tot deelgemeenten
- Wijken respecteren gemeentegrenzen
-	We werken met slechts één wijkindeling
    -	We werken met de eerste wijkindeling die we van een gemeente ontvangen. Indien we daarna van andere medewerkers van dezelfde gemeente de vraag krijgen om een andere wijkindeling te gebruiken, dan doen we dit enkel mits een collegebesluit van de gemeente dat de nieuwe wijkindeling de officiële wijkindeling is.
    -	We maken geen “thematische wijken” (bv welzijnswijken, handhavingswijken, etc.) maar streven een generiek wijkniveau na dat een grootste gemene deler voor de gemeente kan zijn
- de data wordt aangeleverd als aanvulling op de beschikbare Excel (of vergelijkbaar formaat) in dat format
- de indeling is gebaseerd op de [statistische sectoren geldig vanaf 2019](http://www.geopunt.be/catalogus/datasetfolder/c2acf4e7-bcdd-4ea0-9702-37023b08638e)
- de indeling kent elke statistische sector toe aan één wijk
- de wijk krijgt een unieke code van het format *[niscode van de gemeente][vrij te kiezen]*. Het vrij te kiezen gedeelte bevat enkel letters, cijfers en underscores.
- de wijken krijgen unieke namen binnen de gemeente. Voor gebruik op provincies.incijfers.be maken wij ze uniek over Vlaanderen door er "Naam wijk X (Gemeente Y)" van te maken.
- er wordt een verantwoordelijke voor de wijkindeling opgegeven die inhoudelijke en technische vragen kan (laten) beantwoorden

Een overzicht van de beschikbare gemeenten kan je via dit platform downloaden ([rechtsreekse link](https://github.com/provinciesincijfers/gebiedsniveaus/raw/master/gemeente_statsec_wijken/gemeentegedragen_wijken.xlsx))

## Gebiedsdekkend

Om tot een gebiedsdekkende indeling van Vlaanderen te komen, verrijken we deze indeling met een "automatische" wijkbenadering. Hiervoor baseren we ons op de structuur van de NIS-code van de statistische sectoren. Deze hebben een zekere logica. De code van een statistische sector (of "nis9") heeft negen tekens, waarbij de eerste vijf tekens voor de gemeente (situatie tot 2018, "nis5") staat. Onze voorlopige wijken zijn gebaseerd op "nis7".  We passen deze indeling echter lichtjes aan. Door hervormingen van de sectoren zijn deze codes niet altijd logisch. Daarnaast vermijden we zoveel mogelijk "wijken" die uit meerdere gebieden bestaan die niet op elkaar aansluiten. Voor een klein aantal statistische sectoren hebben we daarom aanpassingen in de indeling gemaakt.

De nis7-gebaseerde indeling kunt u via dit platform downloaden ([rechtstreeks](https://github.com/provinciesincijfers/gebiedsniveaus/raw/master/gemeente_statsec_wijken/dena_nis7.xlsx)).

Voor Brussel werken we gewoon met de gemeente. We voorzien ook een “wijk onbekend” per gemeente, per gewest en over heel de toepassing. De tabellen in deze map zijn steeds de meest actuele. 
In provincies.incijfers.be zelf kan het zijn dat de wijkindeling nog achterloopt. We publiceren ongeveer eens per zes maand een nieuwe versie van deze laag op dat platform. Op dat moment actualiseren we ook [de verzameltabel](https://github.com/provinciesincijfers/gebiedsniveaus/tree/master/verzamelbestanden) die alle gebiedsindelingen samenbrengt.

*We geven de voorkeur aan gemeentegedragen wijken en vervangen zo veel als we kunnen onze nis7-variant door het voorstel vanuit een gemeente.* 



Voor vragen, contacteer joost.schouppe@data-en-analyse.be of [uw provinciaal D&A](https://provincies.incijfers.be/databank?report=project_d_en_a)
