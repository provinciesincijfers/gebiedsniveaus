# -*- coding: utf-8 -*-
"""
Created on Mon Aug 11 14:34:01 2025

@author: PAUDUPE
"""


import pandas as pd
from pathlib import Path

# Definieer paden
base_path = Path("C://github//gebiedsniveaus//")
input_path = base_path / "kerntabellen//kerntabel2024.xls"
output_path = base_path / "data_voor_swing//gebiedsdefinities//sector2024.xlsx"

# Voor extra export 'sector.xlsx'
sector_prefixes = [
    "11002", "12025", "13004", "13031", "13040", "13046", "24062",
    "31005", "34022", "35013", "36015", "41002", "44021", "46021", 
    "71016", "71022", "13017", "13019", "11007", "73040"
]


# Laad Excel-bestand
df = pd.read_excel(
    input_path,
    sheet_name="toewijzingstabel_alles"
)

# Groepeer (AGGREGATE-equivalent)
df_grouped = df.groupby(["statsec2024", "statsec2024_naam", "statsec2024_naam_lang", "gemeente_naam"]).size().reset_index(name="aantal_gebieden")


# Datasetbewerking
df_grouped = df_grouped.drop(columns=["aantal_gebieden"])
df_grouped = df_grouped.rename(columns={
    "statsec2024": "geoitem code",
    "statsec2024_naam": "short name",
    "statsec2024_naam_lang": "name"
})

# Voeg onbekend_gebied toe
df_grouped["onbekend_gebied"] = df_grouped["geoitem code"].astype(str).str[:4].eq("9999").astype(int)

# Sorteer
df_grouped = df_grouped.sort_values(by=["gemeente_naam"], ascending=True)

# Voeg volgnummer toe
df_grouped = df_grouped.reset_index(drop=True)
df_grouped['sequence nr'] = df_grouped.index + 1

# Volgnummer als integer met nul decimalen (in principe niet nodig)
df_grouped['sequence nr'] = df_grouped['sequence nr'].astype('int64')


#Lengte inkorten te lange namen
mask = df_grouped["short name"].str.strip().str.len() > 50
df_grouped.loc[mask, "short name"] = df_grouped.loc[mask, "short name"].str.strip().str[:47] + "..."


# Naam aanpassen: gemeente + ": " + oude name
df_grouped["name"] = df_grouped["gemeente_naam"].astype(str) + ": " + df_grouped["name"].astype(str)


# Filter voor sector2024.xlsx op basis van eerste 5 karakters
sector_df = df_grouped[
    df_grouped["geoitem code"].astype(str).str[:5].isin(sector_prefixes)
]


# Houd alleen de relevante kolommen
output_df = sector_df[["sequence nr", "geoitem code", "short name", "name"]]


    
# Opslaan naar Excel
output_df.to_excel(
    output_path,
    index=False,
    engine='openpyxl'
)
