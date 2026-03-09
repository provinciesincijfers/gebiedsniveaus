# -*- coding: utf-8 -*-
"""
Created on Mon Aug 11 10:46:43 2025

@author: PAUDUPE
"""

import pandas as pd
from pathlib import Path

# Definieer paden
base_path = Path("C://github//gebiedsniveaus//")
input_path = base_path / "kerntabellen//statsec_treg_po.xlsx"
output_path = base_path / "data_voor_swing//gebiedsdefinities//treg_po.xlsx"

# Laad Excel-bestand
col_names = ['statsec', 'NAME statsec', 'TREG_po', 'NAME TREG_po']
dtypes = {'statsec':'string', 'NAME statsec': 'string', 'TREG_po':'string', 'NAME TREG_po':'string'} 
# Mocht het niveau letters hebben (bv. zzzz), dan string

df = pd.read_excel(
    input_path, 
    sheet_name="Sheet1",
    names=col_names,
    dtype=dtypes
)

# Groepeer (AGGREGATE-equivalent)
df_grouped = df.groupby(['TREG_po', 'NAME TREG_po']).size().reset_index(name='aantal_gebieden')

# Datasetbewerking
df_grouped = df_grouped.drop(columns=['aantal_gebieden'])
df_grouped = df_grouped.rename(columns={
    'TREG_po': 'geoitem code',
    'NAME TREG_po': 'short name'
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
