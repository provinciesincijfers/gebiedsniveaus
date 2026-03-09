# -*- coding: utf-8 -*-
"""
Created on Mon Aug 25 11:52:38 2025

@author: PAUDUPE
"""

"""TODO Dit script moet nog getest worden"""

import pandas as pd
import os

# Bestandspad
input_path = r'C://temp//basisindelingen//sh_statbel_statistical_sectors_20200101.dbf' #TODO NOG AANPASSEN
output_path = r'C://github//gebiedsniveaus//data_voor_swing//uploadfiles_testpython//oppervlaktes_gis.xlsx'

# DBF inlezen
df = pd.read_excel(input_path)

# Kolommen normaliseren
df.columns = [c.strip().lower() for c in df.columns]

# Filter op Brussel (02000) en Vlaanderen (04000)
df = df[df['c_regio'].isin(['02000', '04000'])]

# Behoud alleen code en oppervlakte
df = df[['cs01012020', 'arcmapopp']].copy()

# Zorg dat oppervlakte numeriek is en afgerond op 2 decimalen (float precision 12 scale 2)
df['arcmapopp'] = pd.to_numeric(df['arcmapopp'], errors='coerce').round(2)

# Meerdere jaren toevoegen
start_year = 1990
end_year = 2040

all_years = []
for year in range(start_year, end_year + 1):
    temp = df.copy()
    temp['period'] = year
    all_years.append(temp)

df_final = pd.concat(all_years, ignore_index=True)

# Kolommen hernoemen naar SPSS-stijl
df_final.rename(columns={
    'cs01012020': 'geoitem',
    'arcmapopp': 'v9900_opp_m2'
}, inplace=True)

# Geolevel toevoegen
df_final['geolevel'] = 'statsec'

# Kolommen in SPSS-volgorde zetten
ordered_cols = ['geoitem', 'v9900_opp_m2', 'geolevel', 'period']
df_final = df_final[ordered_cols]

print(f"Output opgeslagen in: {output_path}")
