# -*- coding: utf-8 -*-
"""
Created on Mon Aug 25 09:17:17 2025

@author: PAUDUPE
"""

# -*- coding: utf-8 -*-
import pandas as pd
import os

# Map waar de bestanden staan
base_path = r'C://Github\gebiedsniveaus//data_voor_swing//gebiedsdefinities'

# Lijst van bestanden met de gewenste geolevel namen
files = [
    ('arrondiss.xlsx', 'arrondiss'),
    ('arrondiss2018.xlsx', 'arrondiss2018'),
    ('arrondiss2024.xlsx', 'arrondiss2024'),
    ('deelgemeente.xlsx', 'deelgemeente'),
    ('deelgemeente2024.xlsx', 'deelgemeente2024'),
    ('fo_gem.xlsx', 'fo_gem'),
    ('gemeente.xlsx', 'gemeente'),
    ('elz.xlsx', 'elz'),
    ('gemeente2018.xlsx', 'gemeente2018'),
    ('gemeente2024.xlsx', 'gemeente2024'),
    ('politiezone.xlsx', 'politiezone'),
    ('provincie.xlsx', 'provincie'),
    ('provincie2024.xlsx', 'provincie2024'),
    ('statsec.xlsx', 'statsec'),
    ('statsec2024.xlsx', 'statsec2024'),
    ('uitrustingsgraad.xlsx', 'uitrustingsgraad'),
    ('vervoerregio.xlsx', 'vervoerregio'),
    ('winkelgebied.xlsx', 'winkelgebied'), # komt uit script 3. TODO check of kolomhoofden kloppen
    ('kernwinkelgebied.xlsx', 'kernwinkelgebied'), # komt uit script 3. TODO check of kolomhoofden kloppen
    ('statsec2019.xlsx', 'statsec2019'),
    ('TREG.xlsx', 'treg'),
    ('TREG_gem.xlsx', 'treg_gem'),
    ('ggw7.xlsx', 'ggw7'),
    ('ggw72024.xlsx', 'ggw72024'),
    ('treg_po.xlsx', 'treg_po'),
    ('gewest.xlsx', 'gewest'),
    ('refreg.xlsx', 'refreg'),
    ('elzantw.xlsx', 'elzantw'),
    ('woonmaatschappij.xlsx', 'woonmaatschappij'),
    ('streekwerking.xlsx', 'streekwerking'),
    ('woningmarkt.xlsx', 'woningmarkt'),
    ('kerntypering.xlsx', 'kerntypering'),
    ('kern.xlsx', 'kern'),
    ('igs.xlsx', 'igs'),
    ('gezondheidsmakers.xlsx', 'gezondheidsmakers')
]

# Functie om één bestand in te lezen en voor te bereiden
def read_and_prepare(file_name, geolevel):
    file_path = os.path.join(base_path, file_name)
    
    # Controle of bestand bestaat
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"Bestand niet gevonden: {file_path}")
    
    # Excel inlezen, eerste sheet
    df = pd.read_excel(file_path, sheet_name=0)
    
    # Kolomnamen normaliseren: lowercase en trim spaties
    df.columns = [col.strip().lower() for col in df.columns]
    
    # Kolommen hernoemen naar standaardnamen
    rename_dict = {
        'geoitem code': 'geoitem'
    }
    df.rename(columns=rename_dict, inplace=True)
    
    # Controleer of 'geoitem' en 'naam' bestaan
    missing_cols = [c for c in ['geoitem', 'name'] if c not in df.columns]
    if missing_cols:
        print(f"Kolommen in {file_name}: {df.columns.tolist()}")
        raise KeyError(f"Kolommen ontbreken in {file_name}: {missing_cols}")
    
    # Geolevel toevoegen
    df['geolevel'] = geolevel
    
    # Trimmen van strings in geoitem
    df['geoitem'] = df['geoitem'].astype(str).str.strip()
    
    # Nieuwe variabelen toevoegen zoals in SPSS
    df['v9900_gebiedscode'] = df['geoitem']
    df['period'] = 1970
    
    # Naam kolom hernoemen naar SPSS stijl
    df.rename(columns={'name': 'v9900_gebiedsnaam'}, inplace=True)
    
    # Overbodige kolommen verwijderen als ze bestaan
    drop_cols = ['short name', 'sequence nr', 'sequencenr']
    df.drop(columns=[col for col in drop_cols if col in df.columns], inplace=True)
    
    print(f"Bestand verwerkt: {file_name}")
    return df

# Alle bestanden verwerken
all_data_list = []
for file_name, geolevel in files:
    try:
        df = read_and_prepare(file_name, geolevel)
        all_data_list.append(df)
    except Exception as e:
        print(f"Fout bij verwerken van {file_name}: {e}")

# Alles samenvoegen
if all_data_list:
    all_data = pd.concat(all_data_list, ignore_index=True)
    output_path = r'C:\github\gebiedsniveaus\data_voor_swing\uploadfiles\gebiedsnaam_code.xlsx'
    all_data.to_excel(output_path, index=False)
    print(f"Alle bestanden samengevoegd en opgeslagen in: {output_path}")
else:
    print("Geen data om samen te voegen.")
