# -*- coding: utf-8 -*-
"""
Wijkindeling PinC - implementatie in PINC
Verwerking van sectoren en wijken voor Vlaanderen en Brussel.
"""
 
import pandas as pd
import numpy as np
import os
from pathlib import Path
 
pd.set_option('display.max.columns', None)
pd.set_option('display.max.rows', None)
pd.set_option('display.max_colwidth', None)
np.set_printoptions(suppress=True)


# =============================================================================
#                              CONFIGURATIE
# =============================================================================
BASE_PATH      = Path(r'C:\Github\gebiedsniveaus\kerntabellen\wijken')
OUTPUT_PATH    = BASE_PATH / 'outputbestanden_voor_pinc'

EXPORT = True  # Zet dit op False om het exporteren over te slaan (bv. om enkel te testen)

KOLOMMEN = ['CS01012025', 
            'WIJK_CODE', 
            'WIJK_NAAM', 
            'TYPE_WIJK',
            'CNIS5_2025', 
            'T_MUN_NL',
            'prov_n']

DTYPES = {
    'CS01012025': 'string',
    'WIJK_CODE':  'string',
    'WIJK_NAAM':  'string',
    'TYPE_WIJK':  'string',
    'CNIS5_2025': int,
    'T_MUN_NL':   'string',
    'prov_n':     'string',
}

GELDIGE_TYPES = {'GGW', 'D&A', 'NIS7'}

# =============================================================================
#                           INLEZEN BRONBESTANDEN
# =============================================================================
# De namen van de wijken werden toegevoegd aan de overeenkomstige sectoren (WIJK_NAAM)
# Vanuit ArcGIS werden alle attributentabellen geëxporteerd:
#   Vlaams Gewest: 1 Excelbestand per gemeente
#   Brussels Hoofdstedelijk Gewest: 19 gemeenten gebundeld in 1 Excelbestand

# Itereer door alle Excelbestanden in de folder
# We werken met een try-except statement om onvolledigheden in de bestanden op te sporen 
# Op die manier zijn we 100% zeker dat elk Excelbestand de nodige kolommen bevat
# Fouten (bv. ontbrekende kolommen) passen we aan in de bronbestanden.
GELDIGE_TYPES = {'GGW', 'D&A', 'NIS7'}

def laad_bronbestanden(folder_path, kolommen, dtypes):
    """Lees alle .xlsx-bestanden in en combineer ze tot één dataframe"""
    """Controleer de juistheid en volledigheid van het type wijkindeling"""
    alle_gemeenten = []
    for file in os.listdir(folder_path):
        if file.endswith(".xlsx"):
            try:
                df = pd.read_excel(folder_path / file, usecols=kolommen)
                ongeldige = df[~df['TYPE_WIJK'].isin(GELDIGE_TYPES) | df['TYPE_WIJK'].isna()]
                if not ongeldige.empty:
                    print(f"Ongeldig TYPE_WIJK in {file}: {ongeldige['TYPE_WIJK'].unique()}")
                alle_gemeenten.append(df)
            except Exception as e:
                print(f"Skipping {file}: {e}")
    df = pd.concat(alle_gemeenten, ignore_index=True)
    df = df.sort_values(by='CS01012025')
    df = df.astype(dtypes)
    return df

df = laad_bronbestanden(BASE_PATH, KOLOMMEN, DTYPES)

# Voor latere controles per provincie
gemeente_provincie = df[['CNIS5_2025', 'prov_n']].drop_duplicates()


# =============================================================================
#                            AANPASSINGEN BRUSSEL
# =============================================================================
# Op 05/01/2026 ontvingen we de (aangepaste) wijken voor Brussel van BISA
# De aangeleverde Brusselse wijken overschrijden echter de gemeentegrenzen
# Daarom knipten we de wijken nog op de gemeentegrenzen, zodat de wijkindeling PinC-conform is
# In zo'n gevallen zetten we wel (dus ook in de korte naam!) de gemeente er tussen haakjes achter
# Ter info: de nieuwe wijken van Brussel komen volledig overeen met de toewijzing van de oude wijken aan de sectoren volgens grootste overlap

# Filter op de gemeenten in Brussel
is_brussel = df['prov_n'] == 'Brussels Hoofdstedelijk Gewest'
# Welke wijknamen in Brussel hebben meerdere wijkcodes? Dit duidt in de meeste gevallen op wijken die de gemeentegrens overschrijden.
# Om het verschil met de oorspronkelijke BISA-wijken duidelijk te maken, plaatsen we na deze wijknamen ook de gemeentenaam.
brussel_aantepassen_wijken = df.loc[is_brussel].groupby('WIJK_NAAM')['WIJK_CODE'].transform('nunique') > 1
# Combineer beide criteria. Reindex zodat de ontbrekende niet-Brusselse rijen opgevuld worden met False.
mask = is_brussel & brussel_aantepassen_wijken.reindex(df.index, fill_value=False)
# Voeg aan deze wijknamen de gemeente toe (tussen haakjes)
df.loc[mask, 'WIJK_NAAM'] = (
    df.loc[mask, 'WIJK_NAAM'] + " (" + df.loc[mask, 'T_MUN_NL'] + ")"
)

# Maak geheugen vrij
del is_brussel, brussel_aantepassen_wijken, mask

# =============================================================================
#                           FORMATTEREN WIJKNAMEN
#   EVALUATIE DISCREPANTIES WIJKNAMEN VS. RUIMTELIJKE CONTOUR DEELGEMEENTE
# =============================================================================
# Verwijder eventuele voor- en naloopspaties in de wijknaam
df['WIJK_NAAM'] = df['WIJK_NAAM'].str.strip()

# Selecteer de wijken die niet starten met een hoofdletter en pas aan in de originele bestanden indien nodig
wijken_lower_case = df[df['WIJK_NAAM'].str[0].str.islower()]
print("Wijknamen met kleine beginletter:", wijken_lower_case['T_MUN_NL'].unique())
# Steenokkerzeel, Tongeren-Borgloon, Maasmechelen → aangepast in bronbestand

# Er zijn veel wijken die de naam van de deelgemeente dragen (al 43 gemeenten alleen in West-Vlaanderen). 
# Er zijn wel gevallen waarin de wijknaam identiek is aan de deelgemeentenaam, maar waar de contour toch verschillend is (zie bijvoorbeeld Hoogstraten)
# Er is een grondig nazicht nodig van deze gevallen. Afhankelijk daarvan, plaatsen we al dan niet (wijk) achter de wijknaam. 
# De werkgroep besliste op 14.01.2026 om dit uit te stellen tot juni. Update: wordt opgenomen als zomertaak (voor de update in december).

# Formatteer de lange naam van de wijken
df['short name'] = df['WIJK_NAAM']
df['name'] = df['WIJK_NAAM'] + ' (' + df['T_MUN_NL'] + ')'

# Voor o.a. de Brusselse wijken die de gemeentegrenzen overschrijden, staat de gemeentenaam er reeds achter.
# Bijvoorbeeld: Industrie Nato (Evere) (Evere)
# Daarom verwijderen we in deze stap herhalende, identieke haakjes in de lange naam
df['name'] = df['name'].str.replace(
    r'\s*\(([^()]*)\)\s*\(\1\)\s*$',
    r' (\1)',
    regex=True
)

df = df[['CS01012025', 'CNIS5_2025', 'T_MUN_NL',
         'short name', 'name', 'WIJK_CODE', 'TYPE_WIJK', 'prov_n']]

# Maak geheugen vrij
del wijken_lower_case

# =============================================================================
#            TOEVOEGEN VAN WIJKCODES VOLGENS NIEUWE AFSPRAKEN
# =============================================================================
# We beslisten om de wijkcodes in 2026 te uniformiseren:
#   Gemeentegedragen wijkindeling en D&A wijkindeling: NISCODE + W + 01, 02, 03... (alfabetisch op wijknaam)
#   NIS7 indeling: NIS7 code (= eerste 7 karakters van de sectorcode) + W
wijkcodes = df[['CNIS5_2025', 'short name', 'TYPE_WIJK']].drop_duplicates()
wijkcodes = wijkcodes.sort_values(by=['CNIS5_2025', 'short name'])

# Maak per niscode de sequentie aan 01, 02, 03, ...
wijkcodes['seq'] = wijkcodes.groupby('CNIS5_2025').cumcount() + 1
wijkcodes['seq'] = wijkcodes['seq'].astype(str).str.zfill(2)

# Bouw de wijkcode op
wijkcodes['ggw7'] = np.where(
    wijkcodes['TYPE_WIJK'] != 'NIS7',
    wijkcodes['CNIS5_2025'].astype(str) + 'W' + wijkcodes['seq'],
    wijkcodes['short name'] + 'W'
    # Let op: de NIS7-indeling begint niet steeds met de niscode!
    # Daarom koos de werkgroep ervoor om bij de NIS7-indeling de 'W' achteraan te zetten.
    # Op die manier wordt het type wijkindeling ook gereflecteerd in de wijkcode.
)
wijkcodes.drop(columns='seq', inplace=True)

# Voeg de wijkcodes toe aan de main dataframe
df = pd.merge(df, wijkcodes, on=['CNIS5_2025', 'short name', 'TYPE_WIJK'], how='left')

# Er zijn een aantal centrumsteden die een uitzondering hebben gevraagd op deze regel. Ook Brussel is een uitzondering.
# Antwerpen wil de letter van de deelgemeente in de wijkcode behouden (en vervolgens de 'W' weglaten, zodat we wel bij 8 karakters blijven)
# Gent wil hun intern gebruikte volgorde van de wijken behouden (dus niet alfabetisch op naam).
# Deze uitzonderingen werden toegestaan. De correcte wijkcodering voor Gent, Antwerpen en Brussel is geïntegreerd in de shapefile (en Excelbestanden)
df['ggw7'] = np.where(df['T_MUN_NL'] == 'Gent',      df['WIJK_CODE'], df['ggw7'])
df['ggw7'] = np.where(df['T_MUN_NL'] == 'Antwerpen', df['WIJK_CODE'], df['ggw7'])
df['ggw7'] = np.where(df['prov_n']   == 'Brussels Hoofdstedelijk Gewest', df['WIJK_CODE'], df['ggw7'])

# Verwijder de oude kolom WIJK_CODE (alle codes staan nu immers goed in de kolom ggw7)
df.drop(columns='WIJK_CODE', inplace=True)

# Type wijkindeling: 1=GGW, 2=NIS7, 3=D&A
# Er zijn geen gemeenten meer die een mix hebben van GGW en NIS7 door de fusies van 2025 (type 4 valt weg sinds 2026)
type_mapping = {'GGW': 1, 'NIS7': 2, 'D&A': 3}
df['v9900_type_ggw7'] = df['TYPE_WIJK'].map(type_mapping)

# Maak geheugen vrij
del wijkcodes, type_mapping

# =============================================================================
#               TOEVOEGEN VAN SECTOREN (EN WIJKEN) ONBEKEND
# =============================================================================
# Voor elke (fusie)gemeente willen we een onbekende sector toevoegen met code 'NISCODE + ZZZZ' 
# De onbekende sector moet telkens achteraan de sectoren van een gemeente gevoegd worden
# We voegen tegelijkertijd ook telkens een wijk onbekend toe

# Pre-compute: welke gemeenten hebben meer dan 1 wijk?
# Dit vermijdt een herhaalde nunique()-aanroep bij elke iteratie
multi_wijk = df.groupby('CNIS5_2025')['ggw7'].nunique() > 1

df_met_onbekende_sectoren = []

for niscode, group in df.groupby('CNIS5_2025', sort=False):
    df_met_onbekende_sectoren.append(group)

    # Neem een referentierij (laatste rij) en bouw van daaruit de onbekende sector op
    sector_onbekend = group.iloc[-1].copy()
    sector_onbekend['CS01012025'] = f"{niscode}ZZZZ"

    # Onbekende sectoren wijzen we toe aan wijk onbekend, tenzij er maar 1 wijk is (bv. Herstappe)
    # In dat geval nemen we de code en de naam van die wijk over (geen aanpassingen nodig)
    if multi_wijk[niscode]:
        sector_onbekend['ggw7'] = f"{niscode}WONB"
        sector_onbekend[['short name', 'name']] = f"{sector_onbekend['T_MUN_NL']} - niet te lokaliseren"

    df_met_onbekende_sectoren.append(pd.DataFrame([sector_onbekend]))

df = pd.concat(df_met_onbekende_sectoren, ignore_index=True)
df = df[['CS01012025', 'CNIS5_2025', 'T_MUN_NL',
         'ggw7', 'short name', 'name', 'TYPE_WIJK', 'v9900_type_ggw7']]

# Welke gemeenten hebben maar 1 wijk en dus geen wijk onbekend? (verwacht: enkel Herstappe)
print(df.loc[df['CS01012025'].str.endswith('ZZZZ') & ~df['ggw7'].str.endswith('ONB')])

# De korte wijknaam mag maximaal 50 karakters lang zijn.
# Welke wijknamen zijn te lang?
if (mask := df['short name'].str.len() > 50).any():
    print("Korte namen die 50 tekens overschrijden:\n", df.loc[mask, 'short name'].to_string())
else:
    print("Elke korte naam is maximaal 50 tekens lang.")
    
# Daarom kappen we de korte naam af op 47 tekens en voegen we "..." toe
df['short name'] = df['short name'].where(
    df['short name'].str.len() <= 50,
    df['short name'].str.slice(0, 47) + '...'
)

# Maak geheugen vrij
del multi_wijk, df_met_onbekende_sectoren, sector_onbekend, niscode, group # noqa


# =============================================================================
#                TOEVOEGEN BOVENLIGGEND NIET-TE-LOKALISEREN
# =============================================================================
niet_te_lokaliseren = pd.DataFrame({
    'CS01012025': ['99991ZZZZ', '99992ZZZZ', '99993ZZZZ', '99999ZZZZ'],
    'CNIS5_2025': [99991, 99992, 99993, 99999],
    'T_MUN_NL':   ['Niet te lokaliseren - Vlaanderen',
                   'Niet te lokaliseren - Brussel',
                   'Niet te lokaliseren',
                   'Buiten Vlaanderen en Brussel'],
    'ggw7':       ['99991WONB', '99992WONB', '99993WONB', '99999WONB'],
    'short name': ['Niet te lokaliseren - Vlaanderen',
                   'Niet te lokaliseren - Brussel',
                   'Niet te lokaliseren',
                   'Buiten Vlaanderen en Brussel'],
    'name':       ['Niet te lokaliseren - Vlaanderen',
                   'Niet te lokaliseren - Brussel',
                   'Niet te lokaliseren',
                   'Buiten Vlaanderen en Brussel'],
})

df = pd.concat([df, niet_te_lokaliseren], axis=0).reset_index(drop=True)

# Hulpkolom voor sortering (zie toelichting bij de ggw7-tabel hieronder)
df['is_onbekend'] = df['ggw7'].str.endswith('ONB')
df.rename(columns={'CS01012025': 'statsec'}, inplace=True)

# Maak geheugen vrij
del niet_te_lokaliseren


# =============================================================================
#                                  CONTROLE
# =============================================================================
# Klopt het aantal wijken onbekend? (verwacht: 307 want enkel Herstappe heeft GEEN wijk onbkeend)
# 285 Vlaamse gemeenten + 19 Brusselse gemeenten + 4 bovenliggend niet te lokaliseren
print("Wijken onbekend:", len(df[df['ggw7'].str.contains('WONB', na=False)]))

# Hoeveel sectoren telt een wijk? (totaal aantal sectoren: 10.594)
df_sector_niet_onbekend = df[~df['statsec'].str.contains('ZZZZ', na=False)]
df_wijk_niet_onbekend = df_sector_niet_onbekend.groupby(
    ['CNIS5_2025', 'ggw7', 'short name'], as_index=False
).agg({'statsec': 'count'})
print("Niet-onbekende sectoren:", df_wijk_niet_onbekend['statsec'].sum())

# Zijn er duplicate wijkcodes of wijknamen in gebruik binnen gemeente?
print("Duplicate wijkcodes binnen een gemeente:", len(df_wijk_niet_onbekend[df_wijk_niet_onbekend.duplicated(subset=['CNIS5_2025', 'ggw7'], keep=False)]))
print("Duplicate wijknamen binnen een gemeente:", len(df_wijk_niet_onbekend[df_wijk_niet_onbekend.duplicated(subset=['CNIS5_2025', 'short name'], keep=False)]))

# Zijn er duplicate wijkcodes binnen het Vlaams Gewest of BHG?
duplicate_wijkcodes = df_wijk_niet_onbekend.groupby('ggw7').size().reset_index(name='count')
print("Duplicate wijkcodes binnen database:", len(duplicate_wijkcodes[duplicate_wijkcodes['count'] > 1]))

# Zijn er duplicate wijknamen binnen het Vlaams Gewest of BHG?
duplicate_wijknamen = df_wijk_niet_onbekend.groupby('short name').size().reset_index(name='count')
print("Duplicate wijknamen binnen database:", duplicate_wijknamen[duplicate_wijknamen['count'] > 1]) # Ja, maar dit is OK. Gemeenten kunnen uiteraard dezelfde wijknaam gebruiken.

# Overzicht van het type wijkindelingen
gemeente_type_wijkindeling = df.groupby(['CNIS5_2025', 'v9900_type_ggw7'], as_index=False).agg({'statsec': 'count'})
print("Type wijkindeling:\n", gemeente_type_wijkindeling['v9900_type_ggw7'].value_counts())

# Hoeveel wijken telt een gemeente?
aantal_wijken_per_gemeente = df.groupby('CNIS5_2025')['ggw7'].nunique()
print("Min/max wijken per gemeente:", aantal_wijken_per_gemeente.min(), aantal_wijken_per_gemeente.max())

# Wijknamen die beginnen met een cijfer moeten van het type NIS7 zijn
if (mask := df['short name'].str.match(r'^\d') & (df['v9900_type_ggw7'] != 2)).any():
    print("Wijknamen die beginnen met een cijfer maar geen NIS7 zijn:\n", df.loc[mask, ['short name', 'v9900_type_ggw7']].to_string())
else:
    print("Alle wijknamen die beginnen met een cijfer zijn van het type NIS7.")

# Maak geheugen vrij
del (df_sector_niet_onbekend, df_wijk_niet_onbekend, gemeente_type_wijkindeling, 
     aantal_wijken_per_gemeente, duplicate_wijkcodes, duplicate_wijknamen, mask) #noqa


# =============================================================================
#                   AANMAAK EXCEL TABELLEN VOOR PINC
# =============================================================================

# =============================================================================
#                            1. Excel 'ggw7'
# =============================================================================
# We maken eerst een basisbestand aan waaruit we ook in de vervolgstappen kunnen vertrekken
# Dit basisbestand vertrekt vanuit de wijkcodes
ggw = df.drop_duplicates(subset='ggw7')[
    ['ggw7', 'CNIS5_2025', 'short name', 'name', 'is_onbekend', 'v9900_type_ggw7']
].copy()

# Sorteer de dataframe:
#   (1) volgens niscode
#   (2) per gemeente komen de niet-onbekende wijken eerst
#   (3) alfabetisch op naam
# Toelichting 'is_onbekend': pandas sorteert lexicografisch, letters komen ná cijfers.
# De onbekende wijken staan dus steeds achteraan bij GGW en D&A (want 'ONB' komt na een cijfer).
# Maar niet bij NIS7: bv. 21001Z5 zou na 21001WONB komen.
# Daarom werd de hulpkolom 'is_onbekend' toegevoegd als extra sorteercriterium.
ggw = ggw.sort_values(by=['CNIS5_2025', 'is_onbekend', 'short name'])

ggw['sequencenr'] = np.arange(1, len(ggw) + 1)
ggw.rename(columns={'ggw7': 'geoitem code'}, inplace=True)

ggw_short = ggw[['sequencenr', 'geoitem code', 'short name', 'name']]

# Als de 9999X gebiedcodes NIET geëxporteerd hoeven te worden, voer dan onderstaande regel uit:
# ggw_short = ggw_short.loc[~ggw_short['geoitem code'].str.startswith('9999')]

if EXPORT:
    ggw_short.to_excel(OUTPUT_PATH / 'ggw7.xlsx', index=False)


# =============================================================================
#                           2. Excel 'ggw7_gemeente'
# =============================================================================
ggw7_gemeente = ggw[['geoitem code', 'CNIS5_2025']].rename(
    columns={'geoitem code': 'ggw7', 'CNIS5_2025': 'gemeente'}
)
# In het geval de 9999-gebieden niet opgenomen moeten worden:
# ggw7_gemeente = ggw7_gemeente.loc[~ggw7_gemeente['ggw7'].str.startswith('9999')]

if EXPORT:
    ggw7_gemeente.to_excel(OUTPUT_PATH / 'ggw7_gemeente.xlsx', index=False)


# =============================================================================
#                           3. Excel 'ggw7_type'
# =============================================================================
# Maak de variabele 'eerste wijk' aan en bepaal daarvoor de volgorde
ggw7_type = ggw.loc[~ggw['geoitem code'].astype(str).str.endswith('ONB')].copy()
# De dataframe werd reeds gesorteerd op naam.
# Moet er voor Gent en Antwerpen een uitzondering komen (W01 is daar niet alfabetisch de eerste wijk) → Hoeft niet.
ggw7_type['v9900_eerstewijk'] = ggw7_type.groupby('CNIS5_2025')['geoitem code'].transform('first')
# Groepeer op niscode en extraheer de eerste rij
ggw7_type = ggw7_type.groupby('CNIS5_2025', sort=False).nth(0).reset_index(drop=True).copy()

# Transformeer naar het correcte format voor import in de Studio
ggw7_type['geolevel'] = 'gemeente'
ggw7_type['period']   = 1970
ggw7_type.rename(columns={'CNIS5_2025': 'geoitem'}, inplace=True)
ggw7_type['v9900_type_ggw7'] = ggw7_type['v9900_type_ggw7'].astype(int)
ggw7_type = ggw7_type[['geolevel', 'geoitem', 'period', 'v9900_type_ggw7', 'v9900_eerstewijk']]

# Overzicht en controle type wijkindeling per provincie
controle_type = ggw7_type.merge(gemeente_provincie, how='left', left_on='geoitem', right_on='CNIS5_2025')
print("Type wijkindeling per provincie:\n", controle_type['prov_n'].value_counts())

if EXPORT:
    ggw7_type.to_excel(OUTPUT_PATH / 'ggw7_type.xlsx', index=False)


# =============================================================================
#                           4. Excel 'statsec_ggw7'
# =============================================================================
statsec_ggw7 = df[['statsec', 'ggw7']]

if EXPORT:
    statsec_ggw7.to_excel(OUTPUT_PATH / 'statsec_ggw7.xlsx', index=False)


# =============================================================================
#                           5. Excel 'statsec_ggw7_geo'
# =============================================================================
# Identiek aan het vorige outputbestand, maar zonder de onbekende sectoren
# Dit is louter in functie van de geometrie op Swing
statsec_ggw7_geo = statsec_ggw7.loc[~statsec_ggw7['statsec'].str.endswith('ZZZZ')]

if EXPORT:
    statsec_ggw7_geo.to_excel(OUTPUT_PATH / 'statsec_ggw7_geo.xlsx', index=False)


# =============================================================================
#                          6. Excel 'statsec_ggw7_readonly'
# =============================================================================
# Dit is een kopie om te gebruiken in de verzameltabellen

statsec_ggw7_readonly = df[['statsec', 'ggw7', 'short name']].rename(
    columns={'short name': 'ggw7_naam'})

if EXPORT:
    statsec_ggw7_readonly.to_excel(
        OUTPUT_PATH / 'statsec_ggw7_readonly.xlsx',
        index=False
    )

