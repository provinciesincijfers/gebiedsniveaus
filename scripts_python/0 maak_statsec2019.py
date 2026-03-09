# -*- coding: utf-8 -*-
"""
Created on Mon Aug 11 08:57:57 2025

@author: PAUDUPE
"""

import pandas as pd
from pathlib import Path

# Definieer paden
base_path = Path("C://github//gebiedsniveaus//")
input_path = base_path / "kerntabellen//kerntabel.xls"
output_path = base_path / "data_voor_swing//gebiedsdefinities//statsec2019.xlsx"


# Laad Excel-bestand
df = pd.read_excel(
    input_path,
    sheet_name="toewijzingstabel_alles"
)

# Groepeer (AGGREGATE-equivalent)
df_grouped = df.groupby(["statsec2019", "statsec2019_naam", "statsec2019_naam_lang"]).size().reset_index(name="aantal_gebieden")

# OPGELET: bij aggregatie vanaf statsec2019 is er nu een lege waarde omdat 11002K1MN gesplitst wordt in 11002K1WN en 11002P6PK. 
# Maar we negeren die tweede optie en dus is er een lege cel die verwijderd moet worden als je werkt vanaf statsec2019
# Selecteer alleen rijen waar statsec2019 niet leeg is
df = df[df["statsec2019"].notna() & (df["statsec2019"].astype(str).str.strip() != "")]



# Datasetbewerking
df_grouped = df_grouped.drop(columns=["aantal_gebieden"])
df_grouped = df_grouped.rename(columns={
    "statsec2019": "geoitem code",
    "statsec2019_naam": "short name",
    "statsec2019_naam_lang": "name"
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
output_df.to_excel(
    output_path,
    index=False,
    engine='openpyxl'
    )
