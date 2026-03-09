# -*- coding: utf-8 -*-
"""
Created on Thu Aug 14 13:52:13 2025

@author: PAUDUPE
"""

import pandas as pd
from pathlib import Path

# =========================
# PADDEFINITIES
# =========================
base_path_input = Path("C://github//gebiedsniveaus//kerntabellen//")
base_path_output_verz = Path("C://github//gebiedsniveaus//verzamelbestanden//")

output_path_verz_alle_xlsx = base_path_output_verz / "verwerkt_alle_gebiedsniveaus2024.xlsx"
output_path_verz_statsec = base_path_output_verz / "statsec2024_als_basis.xlsx"
output_path_verz_statsec19 = base_path_output_verz / "statsec2019_als_basis.xlsx"
output_path_statsecgeo = Path("C://temp_testpython//statsec2024_voor_geo.xlsx")

# =========================
# FUNCTIE: inlezen + mergen
# =========================
def merge_mapping(master, path, merge_on, select_cols, new_names=None, sheet_name=0):
    """
    master: huidig verzamel-DataFrame
    path: pad naar Excel/CSV
    merge_on: kolomnaam (string) waarop gemerged wordt
    select_cols: lijst van kolommen die ingelezen worden uit bestand
    new_names: dict om kolommen te hernoemen (optioneel)
    sheet_name: indien Excel, welk tabblad
    """
    df = pd.read_excel(path, sheet_name=sheet_name, dtype=str)

    # enkel de kolommen die nodig zijn
    df = df[select_cols]

    # hernoemen indien opgegeven
    if new_names:
        df = df.rename(columns=new_names)

    # merge uitvoeren
    master = master.merge(df, on=merge_on, how="left")
    return master

def export_geometry_version(master_df, output_path_statsecgeo):
    """
    Maakt een geometrieversie van statsec_als_basis.
    Vertrekt dus van master_df, verwijdert statsec2019-kolommen,
    en berekent daarna ggwtonbekendtest en DGCHECK.
    """

    # Start vanuit statsec_als_basis
    statsec_basis = master_df.drop(columns=["statsec2019", "statsec2019_naam"], errors="ignore").copy()

    # Dedup op statsec2024
    statsec_basis = statsec_basis.drop_duplicates(subset=["statsec2024"], keep="first")


    # Hulpkolommen aanmaken
    statsec_basis["ggwtonbekendtest"] = statsec_basis["ggw72024"].str[5:8]
    statsec_basis["DGCHECK"] = statsec_basis["deelgemeente2024"].str[5:9]

    # Recode "ONB" en "ONBE" → NULL
    statsec_basis.loc[statsec_basis["ggwtonbekendtest"] == "ONB", "ggw7"] = "NULL"
    statsec_basis.loc[statsec_basis["DGCHECK"] == "ONBE", "deelgemeente"] = "NULL"

    # Wegschrijven naar Excel
    statsec_basis.to_excel(output_path_statsecgeo, index=False)
    print(f"✅ Geometrieversie geschreven: {output_path_statsecgeo}")



# =========================
# START: basisbestand
# =========================
basis_kolommen = [
    "statsec2024", "statsec2024_dummy", "statsec2024_naam",
    "statsec2019", "statsec2019_naam",
    "deelgemeente2024", "deelgemeente2024_naam",
    "gemeente2018", "gemeente2018_naam",
    "gemeente2024", "gemeente2024_naam",
    "gemeente", "gemeente_naam",
    "provincie2024", "provincie2024_naam",
    "provincie", "provincie_naam",
    "gewest", "gewest_naam"
]

master = pd.read_excel(
    base_path_input / "kerntabel2024.xls",
    usecols=basis_kolommen,
    dtype=str
)

# =========================
# MERGES
# =========================
# Voor elk bestand: merge_on + select_cols invullen
# ------------------------------------------------

# Statsec2024 - Ggw72024
master = merge_mapping(
    master,
    base_path_input / "statsec2024_ggw72024_readonly.xlsx",
    merge_on="statsec2024",
    select_cols=["statsec2024", "ggw72024"],
)

# Gemeente2018 - Arrondissement2018
master = merge_mapping(
    master,
    base_path_input / "gemeente2018_arrondiss2018.xls",
    merge_on="gemeente2018",
    select_cols=["gemeente2018", "arrondiss2018", "Name bestuurlijk arrondissement2018"],
    new_names={"Name bestuurlijk arrondissement2018": "bestuurlijk_arondissement2018_naam"}
)

# Gemeente2024 - Arrondissement2024
master = merge_mapping(
    master,
    base_path_input / "gemeente2024_arrondiss2024.xls",
    merge_on="gemeente2024",
    select_cols=["gemeente2024", "arrondiss2024", "Name bestuurlijk arrondissement2024"], 
    new_names={"Name bestuurlijk arrondissement2024": "bestuurlijk_arrondissement2024_naam"}
)

# Gemeente - Arrondissement
master = merge_mapping(
    master,
    base_path_input / "gemeente_arrondiss.xls",
    merge_on="gemeente",
    select_cols=["gemeente", "arrondiss", "Name bestuurlijk arrondissement"],
    new_names={"Name bestuurlijk arrondissement": "bestuurlijk_arrondissement_naam"}
)

# Gemeente - Centrumsteden en Vlaamse rand
master = merge_mapping(
    master,
    base_path_input / "gemeente_fogem.xls",
    merge_on="gemeente",
    select_cols=["gemeente", "fo_gem", "Name fo_gem"], 
    new_names={"Name fo_gem": "fo_gem_naam"}
)

# Gemeente - Politiezone
master = merge_mapping(
    master,
    base_path_input / "gemeente_politiezone.xlsx",
    merge_on="gemeente",
    select_cols=["gemeente", "politiezone", "Name samenwerking politie"],
    new_names={"Name samenwerking politie": "samenwerking_politie_naam"}
)


# Gemeente - Eerstelijnszone
master = merge_mapping(
    master,
    base_path_input / "gemeente_elz.xls",
    merge_on="gemeente",
    select_cols=["gemeente", "elz", "Name elz"],
    new_names={"Name elz": "elz_naam"}
)

# Gemeente - Uitrustingsgraad
master = merge_mapping(
    master,
    base_path_input / "gemeente_uitrustingsgraad.xlsx",
    merge_on="gemeente", 
    select_cols=["gemeente", "uitrustingsgraad", "Name uitrustingsgraad"],
    new_names={"Name uitrustingsgraad": "uitrustingsgraad_naam"}
)

# Gemeente - Gezondheidsmakers
master = merge_mapping(
    master,
    base_path_input / "gemeente_gezondheidsmakers.xlsx",
    merge_on="gemeente", 
    select_cols=["gemeente", "gezondheidsmakers", "Name regio gezondheidsmakers"], 
    new_names={"Name regio gezondheidsmakers": "gezondheidsmakers_naam"}
)

# Gemeente - Vervoerregio
master = merge_mapping(
    master,
    base_path_input / "gemeente_vervoerregio.xlsx",
    merge_on="gemeente",
    select_cols=["gemeente", "vervoerregio", "Name vervoerregio"],
    new_names={"Name vervoerregio": "vervoerregio_naam"}
)


# Gemeente -Toeristische regio gemeenten
master = merge_mapping(
    master,
    base_path_input / "gemeente_treg_gem.xlsx",
    merge_on="gemeente", 
    select_cols=["gemeente", "TREG_gem", "Name TREG_gem"],
    new_names={"Name TREG_gem": "treg_gem_naam"}
)

# Gemeente – Referentieregio
master = merge_mapping(
    master,
    base_path_input / "gemeente_refreg.xlsx",
    merge_on="gemeente",
    select_cols=["gemeente", "REFREG", "Name REFREG"],
    new_names={"Name REFREG": "refreg_naam"}
)

# Gewest - België
master = merge_mapping(
    master,
    base_path_input / "gewest_belgie.xlsx",
    merge_on="gewest", 
    select_cols=["gewest", "belgie", "Name belgie"],  
    new_names={"Name belgie": "belgie_naam"}
)

# Gemeente - Woonmaatschappij
master = merge_mapping(
    master,
    base_path_input / "gemeente_woonmaatschappij.xlsx",
    merge_on="gemeente", 
    select_cols=["gemeente", "woonmaatschappij", "Name woonmaatschappij"],
    new_names={"Name woonmaatschappij": "woonmaatschappij_naam"}
)


# Gemeente - Streekwerking
master = merge_mapping(
    master,
    base_path_input / "gemeente_streekwerking.xlsx",
    merge_on="gemeente", 
    select_cols=["gemeente", "streekwerking", "Name gebied streekwerking"],
    new_names={"Name gebied streekwerking": "gebied_streekwerking_naam"}
)



# Gemeente - IGS
master = merge_mapping(
    master,
    base_path_input / "gemeente_igs.xlsx",
    merge_on="gemeente",
    select_cols=["gemeente", "igs", "Name igs"],
    new_names={"Name igs": "igs_naam"}
)


# Statsec2024 - kern
master = merge_mapping(
    master,
    base_path_input / "statsec2024_kern.xlsx",
    merge_on="statsec2024",
    select_cols=["statsec2024", "kern", "Name kern"],
    new_names={"Name kern": "kern_naam"}
)

# Statsec2024 - kerntypering
master = merge_mapping(
    master,
    base_path_input / "statsec2024_kerntypering.xlsx",
    merge_on="statsec2024",
    select_cols=["statsec2024", "kerntypering", "Name kerntypering"],
    new_names={"Name kerntypering": "kerntypering_naam"}
)

# Statsec2024 - woningmarkt
master = merge_mapping(
    master,
    base_path_input / "statsec2024_woningmarkt.xlsx",
    merge_on="statsec2024",
    select_cols=["statsec2024", "woningmarkt", "Name woningmarkt"],
    new_names={"Name woningmarkt": "woningmarkt_naam"}
)

# =========================
# OUTPUTS
# =========================
# Volledig bestand naar Excel en SPSS
master.to_excel(output_path_verz_alle_xlsx, index=False)

# Specifieke subsets
def ordered_subset(df: pd.DataFrame, drop_cols) -> pd.DataFrame:
    drop = set(drop_cols)
    cols = [c for c in df.columns if c not in drop]  # behoud originele volgorde
    return df.loc[:, cols]

# 1) statsec als basis: alles behalve statsec2019 & statsec2019_naam
# Dedup enkel op statsec2024 voor de statsec-exports
master_dedup_statsec2024 = master.drop_duplicates(subset=["statsec2024"], keep="first")

ordered_subset(master_dedup_statsec2024, ["statsec2019", "statsec2019_naam"]).to_excel(
    output_path_verz_statsec, index=False, engine="openpyxl"
)

# 2) statsec2019 als basis
df_statsec19 = master.copy()

# --- extra filtering zoals in SPSS ---
# Verwijder rijen met kustsectorcodes
df_statsec19 = df_statsec19[~df_statsec19["statsec2024"].str.contains("X0JQ|X1JQ", na=False)]

# Verwijder lege statsec2019
df_statsec19 = df_statsec19[df_statsec19["statsec2019"].notna() & (df_statsec19["statsec2019"].str.strip() != "")]

# Verwijder variabelen statsec, statsec_dummy en statsec_naam
df_statsec19 = ordered_subset(df_statsec19, ["statsec2024", "statsec2024_dummy", "statsec2024_naam"])

# Wegschrijven
df_statsec19.to_excel(output_path_verz_statsec19, index=False, engine="openpyxl")

# 3) versie voor de geometrie
export_geometry_version(master, output_path_statsecgeo)

print("✅ Alle verzamelbestanden weggeschreven")
