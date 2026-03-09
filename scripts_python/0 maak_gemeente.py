# -*- coding: utf-8 -*-
"""
Created on Fri Aug  8 10:37:49 2025

@author: PAUDUPE
"""

import pandas as pd
from pathlib import Path

# Definieer paden
base_path = Path("C://github//gebiedsniveaus//")
input_path = base_path / "kerntabellen//kerntabel.xlsx"
output_path = base_path / "data_voor_swing//gebiedsdefinities//gemeente.xlsx"

df = pd.read_excel(
    input_path, 
    sheet_name="Sheet1"
)

# Groepeer (AGGREGATE-equivalent)
df_grouped = df.groupby(['gemeente', 'gemeente_naam']).size().reset_index(name='aantal_gebieden')

# Datasetbewerking
df_grouped = df_grouped.drop(columns=['aantal_gebieden'])
df_grouped = df_grouped.rename(columns={
    'gemeente': 'geoitem code',
    'gemeente_naam': 'short name'
})
df_grouped['name'] = df_grouped['short name']

# Voeg onbekend_gebied toe
df_grouped['onbekend_gebied'] = (df_grouped['geoitem code'] > 99989).astype(int)

# Sorteer
df_grouped = df_grouped.sort_values(by=['onbekend_gebied', 'name'], ascending=[True, True])

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
