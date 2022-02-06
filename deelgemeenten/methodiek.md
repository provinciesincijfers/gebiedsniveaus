# METHODIEK
 
## Basismethodiek
We vertrekken van de sectoren van het NGI. Die zijn op allerlei manieren verknipt in kleine deeltjes. We voegen ze samen tot ze enkel nog opgesplitst zijn indien ze in meerdere NGI deelgemeenten liggen. In bijna alle gevallen levert dit een één-op-één relatie op.
 
Er zijn 21 sectoren die in meerdere deelgemeenten liggen. Om die toe te kennen aan een deelgemeente, baseren we ons op de bevolking en oppervlakte per sectordeel per deelgemeente.
 
In de praktijk kunnen we in die gevallen de bestaande deelgemeente-grenzen niet respecteren. Dit wordt in het technische luik uitgelegd.
 
De meeste van de moeilijke sectoren zijn onbevolkt. Waar ze onbewoond zijn, kennen we de sector toe aan de deelgemeente waar het grootste deel ligt. Bijvoorbeeld krijgt hierdoor de deelgemeente Antwerpen in Antwerpen een wat vreemde vorm.
 
Waar ze wel bevolkt zijn, was de verwachting dat in de praktijk zowat iedereen in een van de gebieden zou wonen. Dit was een foute verwachting. In de praktijk is het hier niét mogelijk om de NGI-deelgemeenten te respecten. We construeren in die enkele gevallen lichtjes aangepaste deelgemeenten.
 
Op basis van de automatische en manuele keuzes ontstaat een tabel met 100% consistente deelgemeenten: elke sector hoort aan één deelgemeente. Op basis van deze tabel voegen we de sectorpolygonen samen tot één polygoon per deelgemeente. De grenzen van de deelgemeenten vallen dus per definitie perfect samen met de sectorgrenzen.
 
De methodiek is ondertussen nagekeken in Vlaams-Brabant en is daar helemaal OK. In de provincies Oost- en West-Vlaanderen waren enkele aanpassingen nodig: zie hiervoor het hoofdstukje "Details over genomen beslissingen".
 
 
## Keuze van het basisbestand: NGI sectoren
Er is reeds eerder beslist dat we de geometrie van het NGI zouden gebruiken. Deze heeft het voordeel onderling afgestemd te zijn, 't is te zeggen: grotere gebiedsniveaus (voorbeeld deelgemeenten) zijn in principe gebouwd op kleinere onderdelen. Dit zou ook de authentieke bron voor de geometrie van sectoren zijn. De gemeentegrenzen in de NGI geometrie stemmen alvast min of meer overeen met die van het "voorlopig referentiebestand gemeentegrenzen" van Vlaanderen.
 
De geometrie van de sectoren is niet exact dezelfde als die van de open dataset van de sectoren die ADSEI aanbiedt. 
Dit heeft niets met projectiesystemen te maken, het is gewoon anders ingetekend. 

In Provincies in Cijfers gebruiken we met toestemming de geometrie van het NGI. Aangezien deze bestanden nog geen open data zijn, kunnen we de deelgemeenten die we zelf gebruiken hier niet delen.
 
OPMERKING: de opgezette methodiek kan eenvoudig gebruikt worden om lagen te maken van de statistische sectoren die consistent zijn met de geometrie van ADSEI. De afgeleide deelgemeenten en eventueel zelfs gemeenten kunnen hier ook mee consistent gemaakt worden.
 
De meeste sectoren liggen in één deelgemeente. Maar dat is niet STEEDS het geval.
 
 
 
 
 
## Technisch
 
Eerst herprojecteren we de twee lagen van het NGI naar Lambert72. Dit is het projectiesysteem waarin zowat al onze data zit.
 
In de [dataset van het NGI (adminvec)](https://www.geo.be/catalog/details/fb1e2993-2020-428c-9188-eb5f75e284b9?l=nl) zijn de sectoren al in stukjes geknipt op alle mogelijke manieren. Eerst voegen we ze samen tot een unieke polygoon per sector en deelgemeente. We doen dit op zo'n manier dat je in de attributentabel daarbij de code meekrijgt van de sector en de deelgemeente waarin dat stukje ligt. Dus een sector die geheel binnen één deelgemeente ligt, bestaat nog één keer. Een sector die in twee gesplitst wordt door een deelgemeentegrens vinden we twee keer terug. De oppervlakte per deel nemen we mee in de analyse.
 
Vervolgens nemen we de bevolking van 2016, en wijzen die toe aan de gesplitste sectoren op basis van de X-Y coordinaten. 
Dit kan grotendeels conflictvrij, maar er moeten wel enkele keuzes gemaakt worden in de datavoorbereiding.
 
Op 21 sectoren na, kunnen we alle sectoren eenvoudig aan één deelgemeente toekennen. Om deze lastige 21 toe te kennen, beginnen we met een onderzoek van de bewoonde sectoren. 
 
In enkele gevallen moeten we hiering afwijken van de "officiële" deelgemeenten. Voorbeeld: Vinkem (H-II) bestaat uit twee sectoren, die beide in gelijke mate gedeeld zijn met Wulveringen (H-I). Wulveringen heeft daarnaast slechts één andere sector. Het is dus niet mogelijk zinvolle statistieken over deze twee gebieden afzonderlijk te maken. Daarom voegen we de twee gebieden samen tot Wulveringen-Vinkem.
Analoog hiermee maken we ook een deelgemeente Oeren - Alveringem - Sint-Rijkers en een deelgemeente Hoeke-Oostkerke. 
In Gent hebben we een probleem: een zeer dichtbevolkte sector is gedeeld tussen Gentbrugge en Ledeberg. We kunnen deze dus niet op een goede manier toekennen aan een van de twee. Een deelgemeente Ledeberg-Gentbrugge zou zeer vreemd zijn. Op basis van "wat in de hoofden van de mensen het meest waarschijnlijk is", hebben we dit gebied toegekend aan Gentbrugge.
 
Van wat nu nog overblijft, is enkel nog de Schelde in Stad Antwerpen een probleem. Deze is gedeeld tussen Antwerpen en Bezali. Deze is toegekend aan deelgemeente Antwerpen omdat dit logischer lijkt.
Daarnaast zijn er nog enkele gevallen in Wallonië, waar we natuurlijk geen inwonersgegevens op XY ter beschikking hebben. Daar zijn de sectoren eenvoudig toegekend op basis van de grootste oppervlakte.
Opmerking: nog in Antwerpen waren er twee (onbewoonde) sectoren die in een ander District vallen dan wat je zou verwachten op basis van de deelgemeenten van NGI. We hebben hier de grenzen van de Districten gevolgd, en het NGI gaf aan dat dit een fout in hun bestand was.
 
Uit een check van sectoren die niet in de juiste gemeente lijken te vallen komt maar één probleem. De onbewoonde sector 1104411PQ wordt in NGI toegekend aan de Stad Antwerpen (niscode 11002), omdat dit gebied voor de grote fusiegolf nog behoorde tot de stad. In de statistische sectoren versie 2001 was deze voor het eerst een deel van 11044. In de sectoren 1991 behoorde het gebied nog tot Antwerpen. De Stad Antwerpen beschouwt dit niet als zijn grondgebied, en ook de dataset van ADSEI beschouwt dit als 11044. Dus dit moeten we respecten. Blijft het probleem van toekenning aan een deelgemeente. De grens met Hoevenen is het langste, dus hebben we het daaraan toegekend. Na overleg met NGI bleek dit ook effectief de beste keuze.
 
Op deze manier bereiken we een 100% juiste toekenning van sectoren aan "onze" deelgemeenten. Het is dus niet zo dat er "verdwaalde" inwoners zijn, die fysiek buiten een deelgemeente zitten, maar op basis van hun sector daar wel aan toegekend worden. Daarom is het ook logischer om de geometrie van de deelgemeenten ook op deze sectorgrenzen te bouwen. Hierdoor wijken "onze" deelgemeenten op vier plaatsen in Vlaanderen af van de "officiële realiteit". Maar in tegenstelling tot de officiële deelgemeenten zijn ze zowel geografisch als demografisch consistent. 
 
In deze methodiek landen we op een unieke sleutel van de deelgemeenten die gebaseerd is op de sleutel van het NGI, en niet een die gebaseerd is op het hopelijk juist zijn van de schrijfwijze van de sector. Daardoor hebben we ook een stap meer in de historiek van de fusies mee. Bijvoorbeeld is Walshoutem nog uitgesplitst:
 
24059C-I        Walshoutem  
24059C-II        Waasmont  
24059C-III        Walsbets  
24059C-IV        Wezeren  
 
 
 
 
## Onbekende gebieden
 
Sectoren
Elke gemeente krijgt één onbekende sector. We volgen de ADSEI logica: deze krijgt de NIScode van de gemeente + ZZZZ. Er is geen verwarring mogelijk met deelgemeente-codes, want die zijn van de vorm NIScode-Z. Voorbeeld: 11002ZZZZ is de onbekende statistische sector van Antwerpen, 11002-Z is de deelgemeente Antwerpen in de Stad Antwerpen.
Naamgeving: "Gemeente - niet te lokaliseren"
 
Deelgemeenten  
Per gemeente is een onbekende deelgemeente nodig. Om verwarring met 11002-Z en 11002Z te vermijden, geven we de "onbekende deelgemeente" de code 11002ONBE.  
Naamgeving: "Gemeente - niet te lokaliseren"  
 
 
## Naamgeving
 
De namen zijn hier reeds leesbaar. We volgen de naam die het NGI gebruikt, behalve voor onze eigen deelgemeenten (zie onder).
De namen zijn evenwel niet uniek. Indien een naam niet uniek is, dan voegen we het achtervoegsel "(Gemeente Naam)" toe. Indien de naam van de deelgemeente identiek is aan de gemeente, dan doen we dit niet. Aangezien gemeentenamen uniek zijn, is dit niet nodig.
 
 
 
## Details over genomen beslissingen
 
Vinkem (H-II) bestaat uit twee sectoren, die beide gedeeld zijn met Wulveringen (H-I). Wulveringen heeft daarnaast nog één andere sector.
Beide gedeelde sectoren liggen nagenoeg gelijk verdeeld over de twee deelgemeenten. Voorstel: HI en HII samenvoegen tot Wulveringen-Vinkem.
 
38025H009        38025H-I  
38025H009        38025H-II  
38025H099        38025H-I  
38025H099        38025H-II  
 
 
Sint-Rijkers (A-III), Alveringem (A-II) en Oeren (A-I) hebben meer overlap dan niet-overlap. Voorstel: samenvoegen tot Oeren - Alveringem - Sint-Rijkers.  
38002A089        38002A-II  
38002A089        38002A-III  
38002A099        38002A-I  
38002A099        38002A-II  
38002A181        38002A-II  
38002A181        38002A-III  
 
Hoeke en Oostkerke. Hoeke is onmogelijk te identificeren als deelgemeente. Samenvoegen tot Hoeke-Oostkerke.  
31006C099        31006C-I  
31006C10-        31006C-I  
31006C099        31006C-II  
31006C00-        31006C-II  
31006C012        31006C-II  
 
Gentbrugge-Ledeberg: de sector is dicht bevolkt in beide delen. Op basis van "wat in de hoofden van de mensen het meest waarschijnlijk is" toegekend aan Gentbrugge.  
44021G200        44021F  
44021G200        44021G  
 
Enkel een sliver, geen verdwaalde inwoners.  
24066C091
 
 
 
 
 
 
 
 
