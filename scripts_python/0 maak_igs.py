# -*- coding: utf-8 -*-
"""
Created on Fri Aug  8 11:45:32 2025

@author: PAUDUPE
"""

import pandas as pd
from pathlib import Path

# Definieer paden
base_path = Path("C://github//gebiedsniveaus//")
input_path = base_path / "kerntabellen//gemeente_igs.xlsx"
output_path = base_path / "data_voor_swing//gebiedsdefinities//igs.xlsx"

# Laad Excel-bestand
col_names = ['gemeente', 'Name gemeente', 'igs', 'Name igs']
dtypes = {'gemeente':'Int64', 'Name gemeente': 'string', 'igs':'string', 'Name igs':'string'} 
# Mocht het niveau letters hebben (bv. zzzz), dan string

df = pd.read_excel(
    input_path, 
    sheet_name="Sheet1",
    names=col_names,
    dtype=dtypes
)

# Groepeer (AGGREGATE-equivalent)
df_grouped = df.groupby(['igs', 'Name igs']).size().reset_index(name='aantal_gebieden')

# Datasetbewerking
df_grouped = df_grouped.drop(columns=['aantal_gebieden'])
df_grouped = df_grouped.rename(columns={
    'igs': 'geoitem code',
    'Name igs': 'short name'
})
df_grouped['name'] = df_grouped['short name']

# Geen gebied onbekend en sorteren want geeft miserie met igs999 (Geen IGS), moet immers achteraan de lijst staan, voor de gebieden onbekend

# Voeg volgnummer toe
df_grouped = df_grouped.reset_index(drop=True)
df_grouped['sequence nr'] = df_grouped.index + 1
print(df_grouped.dtypes)

# Volgnummer als integer met nul decimalen (in principe niet nodig)
df_grouped['sequence nr'] = df_grouped['sequence nr'].astype('int64')

# Houd alleen de relevante kolommen
output_df = df_grouped[['sequence nr', 'geoitem code', 'short name', 'name']]

# Stap 4: Opslaan naar Excel
output_df.to_excel(
    output_path, 
    index=False, 
    engine='openpyxl'
)
