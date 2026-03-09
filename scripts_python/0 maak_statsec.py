# -*- coding: utf-8 -*-
"""
Created on Tue Dec  9 16:08:45 2025

@author: PAUDUPE
"""


import pandas as pd
from pathlib import Path

# Definieer paden
base_path = Path("C://github//gebiedsniveaus//")
input_path = base_path / "kerntabellen//kerntabel.xlsx"
output_path = base_path / "data_voor_swing//gebiedsdefinities//statsec.xlsx"


# Laad Excel-bestand
df = pd.read_excel(
    input_path,
    sheet_name="Sheet1"
)

# Groepeer (AGGREGATE-equivalent)
df_grouped = df.groupby(["statsec", "statsec_naam", "statsec_naam_lang"]).size().reset_index(name="aantal_gebieden")


# Datasetbewerking
df_grouped = df_grouped.drop(columns=["aantal_gebieden"])
df_grouped = df_grouped.rename(columns={
    "statsec": "geoitem code",
    "statsec_naam": "short name",
    "statsec_naam_lang": "name"
})

# Voeg onbekend_gebied toe
df_grouped["onbekend_gebied"] = df_grouped["geoitem code"].astype(str).str[:4].eq("9999").astype(int)

# Sorteer
df_grouped = df_grouped.sort_values(by=["onbekend_gebied", "name"], ascending=[True, True])

# Voeg volgnummer toe
df_grouped = df_grouped.reset_index(drop=True)
df_grouped['sequence nr'] = df_grouped.index + 1

# Volgnummer als integer met nul decimalen (in principe niet nodig)
df_grouped['sequence nr'] = df_grouped['sequence nr'].astype('int64')


#Lengte inkorten te lange namen
mask = df_grouped["short name"].str.strip().str.len() > 50
df_grouped.loc[mask, "short name"] = df_grouped.loc[mask, "short name"].str.strip().str[:47] + "..."


# Houd alleen de relevante kolommen
output_df = df_grouped[["sequence nr", "geoitem code", "short name", "name"]]

    
# Opslaan naar Excel
for path in [output_path]:
    output_df.to_excel(
        path,
        index=False,
        engine='openpyxl'
    )
