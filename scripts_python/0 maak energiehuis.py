# -*- coding: utf-8 -*-
"""
Created on Mon Jun  8 14:30:30 2026

@author: PAUDUPE
"""


import pandas as pd
from pathlib import Path

# Definieer paden
base_path = Path("C://github//gebiedsniveaus//")
input_path = base_path / "kerntabellen//gemeente_energiehuis.xlsx"
output_path = base_path / "data_voor_swing//gebiedsdefinities//energiehuis.xlsx"

# Laad Excel-bestand
col_names = ['gemeente', 'Name gemeente', 'werkingsgebied energiehuis', 'Name werkingsgebied energiehuis']
dtypes = {'gemeente':'Int64', 'Name gemeente': 'string', 'werkingsgebied energiehuis':'string', 'Name werkingsgebied energiehuis':'string'} 
# Mocht het niveau letters hebben (bv. zzzz), dan string

df = pd.read_excel(
    input_path, 
    sheet_name="Blad1",
    dtype=dtypes
)

# Groepeer (AGGREGATE-equivalent)
df_grouped = df.groupby(['werkingsgebied energiehuis', 'Name werkingsgebied energiehuis']).size().reset_index(name='aantal_gebieden')

# Datasetbewerking
df_grouped = df_grouped.drop(columns=['aantal_gebieden'])
df_grouped = df_grouped.rename(columns={
    'werkingsgebied energiehuis': 'geoitem code',
    'Name werkingsgebied energiehuis': 'short name'
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

# Opslaan naar Excel
output_df.to_excel(
    output_path, 
    index=False, 
    engine='openpyxl'
)
