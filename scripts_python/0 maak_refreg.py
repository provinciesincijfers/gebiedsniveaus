# -*- coding: utf-8 -*-
"""
Created on Fri Aug  8 14:48:22 2025

@author: PAUDUPE
"""


import pandas as pd
from pathlib import Path

# Definieer paden
base_path = Path("C://github//gebiedsniveaus//")
input_path = base_path / "kerntabellen//gemeente_refreg.xlsx"
output_path = base_path / "data_voor_swing//gebiedsdefinities//refreg.xlsx"

# Laad Excel-bestand
col_names = ['gemeente', 'Name gemeente', 'refreg', 'Name refreg']
dtypes = {'gemeente':'Int64', 'Name gemeente': 'string', 'refreg':'string', 'Name refreg':'string'} 
# Mocht het niveau letters hebben (bv. zzzz), dan string

df = pd.read_excel(
    input_path, 
    sheet_name="Blad1",
    names=col_names,
    dtype=dtypes
)

# Groepeer (AGGREGATE-equivalent)
df_grouped = df.groupby(['refreg', 'Name refreg']).size().reset_index(name='aantal_gebieden')

# Datasetbewerking
df_grouped = df_grouped.drop(columns=['aantal_gebieden'])
df_grouped = df_grouped.rename(columns={
    'refreg': 'geoitem code',
    'Name refreg': 'short name'
})
df_grouped['name'] = df_grouped['short name']


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
