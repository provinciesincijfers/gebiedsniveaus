# -*- coding: utf-8 -*-
"""
Created on Thu Aug  7 14:55:38 2025

@author: PAUDUPE
"""

import pandas as pd
from pathlib import Path

# Definieer paden
base_path = Path("C://github//gebiedsniveaus//")
input_path = base_path / "kerntabellen//gemeente_arrondiss.xls"
output_path = base_path / "data_voor_swing//gebiedsdefinities//arrondiss.xlsx"

# Laad Excel-bestand
col_names = ['gemeente', 'Name gemeente', 'arrondiss', 'Name bestuurlijk arrondissement']
dtypes = {'gemeente':'Int64', 'Name gemeente': 'string', 'arrondiss':'Int64', 'Name bestuurlijk arrondissement':'string'} 
# Mocht het niveau letters hebben (bv. zzzz), dan string

df = pd.read_excel(
    input_path, 
    sheet_name="gemeente_arrondiss",
    names=col_names,
    dtype=dtypes
)

# Groepeer (AGGREGATE-equivalent)
df_grouped = df.groupby(['arrondiss', 'Name bestuurlijk arrondissement']).size().reset_index(name='aantal_gebieden')

# Datasetbewerking
df_grouped = df_grouped.drop(columns=['aantal_gebieden'])
df_grouped = df_grouped.rename(columns={
    'arrondiss': 'geoitem code',
    'Name bestuurlijk arrondissement': 'short name'
})
df_grouped['name'] = df_grouped['short name']

# Voeg onbekend_gebied toe (eigenlijk niet nodig)
df_grouped['onbekend_gebied'] = (df_grouped['geoitem code'] > 99989).astype(int)

# Sorteer (eigenlijk niet nodig)
df_grouped = df_grouped.sort_values(by=['onbekend_gebied', 'name'], ascending=[True, True])

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
