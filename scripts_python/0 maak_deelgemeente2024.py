# -*- coding: utf-8 -*-
"""
Created on Fri Aug  8 07:28:20 2025

@author: PAUDUPE
"""

import pandas as pd
from pathlib import Path

# Definieer paden
base_path = Path("C://github//gebiedsniveaus//")
input_path = base_path / "kerntabellen//kerntabel2024.xls"
output_path = base_path / "data_voor_swing//gebiedsdefinities//deelgemeente2024.xlsx"

# Laad Excel-bestand
df = pd.read_excel(
    input_path,
    sheet_name="toewijzingstabel_alles"
)

# Groepeer (AGGREGATE-equivalent)
df_grouped = df.groupby(["deelgemeente2024", "deelgemeente2024_naam", "deelgemeente2024_naam_kort"]).size().reset_index(name="aantal_gebieden")


# Datasetbewerking
df_grouped = df_grouped.drop(columns=["aantal_gebieden"])
df_grouped = df_grouped.rename(columns={
    "deelgemeente2024": "geoitem code",
    "deelgemeente2024_naam_kort": "short name",
    "deelgemeente2024_naam": "name"
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

# Houd alleen de relevante kolommen
output_df = df_grouped[["sequence nr", "geoitem code", "short name", "name"]]

# Opslaan naar Excel
output_df.to_excel(
    output_path,
    index=False,
    engine='openpyxl'
)
