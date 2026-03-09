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

output_path_verz_alle_xlsx = base_path_output_verz / "verwerkt_alle_gebiedsniveaus.xlsx"
output_path_verz_statsec = base_path_output_verz / "statsec_als_basis.xlsx"
output_path_statsecgeo = Path("C://temp_testpython//statsec_voor_geo.xlsx")

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
    statsec_basis = master_df.copy()


    # Hulpkolommen aanmaken
    """statsec_basis["ggwtonbekendtest"] = statsec_basis["ggw7"].str[5:8]"""
    statsec_basis["DGCHECK"] = statsec_basis["deelgemeente"].str[5:9]

    # Recode "ONB" → NULL
    """statsec_basis.loc[statsec_basis["ggwtonbekendtest"] == "ONB", "ggw7"] = "NULL" """
    statsec_basis.loc[statsec_basis["DGCHECK"] == "ONB", "deelgemeente"] = "NULL"

    # Wegschrijven naar Excel
    statsec_basis.to_excel(output_path_statsecgeo, index=False)
    print(f"✅ Geometrieversie geschreven: {output_path_statsecgeo}")



# =========================
# START: basisbestand
# =========================
basis_kolommen = [
    "statsec", "statsec_naam",
    "deelgemeente", "deelgemeente_naam",
    "gemeente", "gemeente_naam",
    "provincie2024", "provincie2024_naam",
    "provincie", "provincie_naam",
    "gewest", "gewest_naam"
]

master = pd.read_excel(
    base_path_input / "kerntabel.xlsx",
    usecols=basis_kolommen,
    dtype=str
)

# =========================
# MERGES
# =========================
# Voor elk bestand: merge_on + select_cols invullen
# ------------------------------------------------


# Statsec - Ggw7
master = merge_mapping(
    master,
    base_path_input / "statsec_ggw7_readonly.xlsx",
    merge_on="statsec",
    select_cols=["statsec", "ggw7"],
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


# Statsec - Toeristische regio
master = merge_mapping(
    master,
    base_path_input / "statsec_treg.xlsx",
    merge_on="statsec",  # <<< HIER INVULLEN
    select_cols=["statsec", "TREG", "NAME TREG"],
    new_names={"NAME TREG": "treg_naam"}
)

# Statsec - Toeristische regio provincies
master = merge_mapping(
    master,
    base_path_input / "statsec_treg_po.xlsx",
    merge_on="statsec", 
    select_cols=["statsec", "TREG_po", "NAME TREG_po"],  
    new_names={"NAME TREG_po": "treg_po_naam"}
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


# Statsec - Eerstelijnszone Antwerpen
master = merge_mapping(
    master,
    base_path_input / "statsec_elzantw.xlsx",
    merge_on="statsec",  
    select_cols=["statsec", "ELZantw", "Name ELZantw"], 
    new_names={"Name ELZantw": "Elzantw_naam"}
)


# Gemeente - Streekwerking
master = merge_mapping(
    master,
    base_path_input / "gemeente_streekwerking.xlsx",
    merge_on="gemeente", 
    select_cols=["gemeente", "streekwerking", "Name gebied streekwerking"],
    new_names={"Name gebied streekwerking": "gebied_streekwerking_naam"}
)

"""
# Statsec - Kern
master = merge_mapping(
    master,
    base_path_input / "statsec_kern.xlsx",
    merge_on="statsec",  
    select_cols=["statsec", "kern", "Name kern"],
    new_names={"Name kern": "kern_naam"}
)


# Statsec - Kerntypering
master = merge_mapping(
    master,
    base_path_input / "statsec_kerntypering.xlsx",
    merge_on="statsec", 
    select_cols=["statsec", "kerntypering", "Name kerntypering"],
    new_names={"Name kerntypering": "kerntypering_naam"}
)

# Statsec - Woningmarkt
master = merge_mapping(
    master,
    base_path_input / "statsec_woningmarkt.xlsx",
    merge_on="statsec", 
    select_cols=["statsec", "woningmarkt", "Name woningmarkt"],
    new_names={"Name woningmarkt": "woningmarkt_naam"}
)
"""

# Gemeente - IGS
master = merge_mapping(
    master,
    base_path_input / "gemeente_igs.xlsx",
    merge_on="gemeente",
    select_cols=["gemeente", "igs", "Name igs"],
    new_names={"Name igs": "igs_naam"}
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

# statsec als basis wegschrijven
ordered_subset(master, []).to_excel(
    output_path_verz_statsec, index=False, engine="openpyxl"
)

# 3) versie voor de geometrie
export_geometry_version(master, output_path_statsecgeo)

print("✅ Alle verzamelbestanden weggeschreven")
