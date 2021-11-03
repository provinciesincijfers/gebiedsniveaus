## Statistische-sector gebaseerde wijken

De basis van rapportage op provincies.incijfers.be zijn de [statistische sectoren](https://statbel.fgov.be/nl/over-statbel/methodologie/classificaties/statistische-sectoren). Statistische sectoren zijn sinds 1970 de basis voor subgemeentelijke statistieken. Ze werden ontwikkeld in functie van de tienjaarlijkse nationale volkstelling en werden sindsdien periodiek bijgewerkt, al loopt dat proces stroever sinds de afschaffing van de klassieke volkstellingen na 2001.

De statistische sectoren worden niet enkel door statbel gebruikt om allerlei gedetailleerde statistieken te verdelen, maar bijvoorbeeld ook door het Intermutualistische Agentschap, Fluvius, alle Centrumsteden, etc. De indeling is fijnmazig, maar is vaak groot genoeg om statistisch relevante cijfers op te leveren. Heel vaak kunnen cijfers op deze basis privacy-vriendelijke zonder veel verlies aan informatie openbaar gemaakt worden. Op basis van deze sectoren kunnen we "wijken" en "[deelgemeenten](https://github.com/provinciesincijfers/gebiedsniveaus/tree/master/deelgemeenten)" bouwen. Uiteindelijk tellen ze op tot gemeenten.

Dit alles maakt het tot een gedeelde stabiele standaard - een voorwaarde om in toepassingen zoals provincies.incijfers.be een breed aanbod aan subgemeentelijke statistieken te kunnen ontwikkelen. 

Voor sommige statistieken zijn statistische sectoren eenvoudig te klein. Sinds juni 2019 bevat provincies.incijfers.be daarom *op statistische sectoren gebaseerde wijken*. Elke wijk bestaat uit minstens één sector, en elke sector wordt aan niet meer of minder dan één wijk toegekend.  We volgen hierbij bij voorkeur de indeling die gemeenten zelf hanteren. Indien er geen sector-gebaseerde indeling bij ons bekend is, dan werken we met een voorlopige eigen wijkindeling.

### Een standaardindeling

Wegens het gebrek aan officiële standaard, streven we samenwerking en hergebruik na rond de wijkindeling die we hier ontwikkelen. We stemmen hiervoor af met het Intermutualistisch Agentschap en Arvastat (VDAB), die gelijkaardige indelingen hanteren. Ook Kind & Gezin hergebruikt deze indeling. Op termijn hopen we hier tot één set wijken te komen.

De indeling zoals die hier verdeeld wordt is beschikbaar onder de [modellicentie gratis hergebruik](https://github.com/provinciesincijfers/gebiedsniveaus/blob/master/gemeente_statsec_wijken/license.md).



## Gemeente-gedragen statistische sectoren gebaseerde wijken

Voor de lancering in juni 2019 verzamelden we de ons bekende sector-gebaseerde wijkindelingen van gemeenten. Gemeenten kunnen ons vragen om de wijkindeling voor hun gemeente aan te passen. Neem hiervoor contact op met info@provincies.incijfers.be of [Data & Analyse in uw provincie](https://provincies.incijfers.be/databank?report=project_d_en_a&keepworkspace=true). Verdere aanvullingen of correcties worden halfjaarlijks verwerkt en jaarlijks aangevuld in Provincies in Cijfers.

Een samenvattende powerpoint omtrent gemeentegedragen wijken vind je [hier](https://github.com/provinciesincijfers/gebiedsniveaus/blob/master/gemeente_statsec_wijken/gemeentegedragen%20wijken.pdf).

Voorstellen worden opgenomen onder volgende voorwaarden:
- Ze zijn gebaseerd op statistische sectoren. Immers kunnen we anders geen data uit diverse bronnen samenbrengen
- Wijken bestaan bijna altijd uit meerdere, aaneensluitende statistische sectoren. Het kan slechts uitzonderlijk voorkomen dat een wijk slechts uit één sector bestaat, bijvoorbeeld omdat ze zeer atypisch is en heel weinig of net heel veel inwoners bevat. 
- Wijken zijn doorgaans kleiner dan deelgemeenten. De wijken hoeven echter niet op te tellen tot deelgemeenten
- Wijken respecteren steeds de gemeentegrenzen
- Deze wijken zijn vooral bedoeld voor statistieken over de inwoners. Door enkele sectoren samen te voegen, krijgen we vrij grote bevolkingsaantallen waardoor je stabielere cijfers krijgt. Het kan soms wel zinvol zijn om onbewoonde gebieden af te splitsen.
- We werken met slechts één wijkindeling
    -	We werken met de eerste wijkindeling die we van een gemeente ontvangen. Indien we daarna van andere medewerkers van dezelfde gemeente de vraag krijgen om een andere wijkindeling te gebruiken, dan doen we dit enkel mits een collegebesluit van de gemeente dat de nieuwe wijkindeling de officiële wijkindeling is.
    -	We maken geen “thematische wijken” (bv welzijnswijken, handhavingswijken, etc.) maar streven een generiek wijkniveau na dat een grootste gemene deler voor de gemeente kan zijn
- de data wordt aangeleverd als aanvulling op de beschikbare Excel (of vergelijkbaar formaat) in dat format
- de indeling is gebaseerd op de [statistische sectoren geldig vanaf 2019](http://www.geopunt.be/catalogus/datasetfolder/c2acf4e7-bcdd-4ea0-9702-37023b08638e)
- de indeling kent elke statistische sector toe aan één wijk
- de wijk krijgt een unieke code van het format *[niscode van de gemeente][vrij te kiezen]*. Het vrij te kiezen gedeelte bevat enkel hoofdletters, cijfers en underscores.
- de wijken krijgen unieke namen binnen de gemeente. Voor gebruik op provincies.incijfers.be maken wij ze uniek over Vlaanderen door er "Naam wijk X (Gemeente Y)" van te maken.
- er wordt een verantwoordelijke voor de wijkindeling opgegeven die inhoudelijke en technische vragen kan (laten) beantwoorden
- de gemeente geeft door indienen van een voorstel toestemming om de informatie over de wijkindeling (aggregatietabel, namen) vrij te geven als open data onder Vlaamse modellicentie gratis hergebruik

Een overzicht van de beschikbare gemeenten kan je hier downloaden ([rechtsreekse link](https://github.com/provinciesincijfers/gebiedsniveaus/raw/master/gemeente_statsec_wijken/gemeentegedragen_wijken.xlsx))

Binnen Swing worden de wijken getoond in alfabetische volgorde op basis van de gebiedscode; "wijk onbekend" wordt steeds laatste getoond. Als je wijken wil groeperen op basis van waar ze liggen (bijvoorbeeld eerst de centrumwijken), dan moeten de gebiedscodes dit reflecteren.


## Gebiedsdekkend

[<img src="https://provincies.incijfers.be/jive/JiveInlineImg.aspx?presel=ggw7_kaart" alt="kaart" height="300"/>](https://provincies.incijfers.be/databank?presel=ggw7_kaart&keepworkspace=true)


Om tot een gebiedsdekkende indeling van Vlaanderen te komen, verrijken we deze indeling met een "automatische" wijkbenadering. Hiervoor baseren we ons op de structuur van de NIS-code van de statistische sectoren. Deze hebben een zekere logica. De code van een statistische sector (of "nis9") heeft negen tekens, waarbij de eerste vijf tekens voor de gemeente (situatie tot 2018, "nis5") staat. Onze voorlopige wijken zijn gebaseerd op "nis7".  We passen deze indeling echter lichtjes aan. Door hervormingen van de sectoren zijn deze codes niet altijd logisch. Daarnaast vermijden we zoveel mogelijk "wijken" die uit meerdere gebieden bestaan die niet op elkaar aansluiten. Voor een klein aantal statistische sectoren hebben we daarom aanpassingen in de indeling gemaakt.

De nis7-gebaseerde indeling kunt u via dit platform downloaden ([rechtstreeks](https://github.com/provinciesincijfers/gebiedsniveaus/raw/master/gemeente_statsec_wijken/dena_nis7.xlsx)).

Voor Brussel werken we met de standaard wijkindeling die in het gewest gehanteerd wordt. Wel passen we deze enigszins aan om de gemeentegrenzen te respecteren. Sommige bestaande wijken worden dus in twee of meer stukken verdeeld.

We voorzien ook een “wijk onbekend” per gemeente, per gewest en over heel de toepassing. De tabellen in deze map zijn steeds de meest actuele. 
In provincies.incijfers.be zelf kan het zijn dat de wijkindeling nog achterloopt. We publiceren ongeveer eens per zes maand een nieuwe versie van deze laag op dat platform. Op dat moment actualiseren we ook [de verzameltabel](https://github.com/provinciesincijfers/gebiedsniveaus/tree/master/verzamelbestanden) die alle gebiedsindelingen samenbrengt.

*We geven de voorkeur aan gemeentegedragen wijken en vervangen zo veel als we kunnen onze nis7-variant door het voorstel vanuit een gemeente.* 




## Kernbestanden

* [koppeltabel statistische sector aan code en naam van de bijhorende gemeentegedragen wijk](https://github.com/provinciesincijfers/gebiedsniveaus/raw/master/gemeente_statsec_wijken/gemeentegedragen_wijken.xlsx)
* [gemeenten volgens beschikbaarheid wijkindeling](https://github.com/provinciesincijfers/gebiedsniveaus/raw/master/data_voor_swing/uploadfiles/ggw7_type.xlsx)
* [definitietabel alle wijken (zowel gemeentegedragen als NIS7)](https://github.com/provinciesincijfers/gebiedsniveaus/raw/master/data_voor_swing/gebiedsdefinities/ggw7.xlsx)
* [koppeltabel alle statsec naar alle wijken (zowel gemeentegedragen als NIS7)](https://github.com/provinciesincijfers/gebiedsniveaus/raw/master/data_voor_swing/aggregatietabellen/statsec_ggw7.xlsx)



Voor vragen, contacteer joost.schouppe@data-en-analyse.be of [uw provinciaal D&A](https://provincies.incijfers.be/databank?report=project_d_en_a)

