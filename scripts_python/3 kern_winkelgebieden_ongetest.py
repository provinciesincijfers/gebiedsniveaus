# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

# ============================================================
# Encoding: windows-1252
#
# VOORBEREIDING BUITEN DIT SCRIPT
# haal de winkelgebieden en kernwinkelgebieden af van Teams:
# https://vlbr.sharepoint.com/:f:/r/teams/DA-Interprovincialewerking/Gedeelde%20documenten/Ruwe%20data/Locatus%20(detailhandelspanden)/Geografische%20lagen
#
# OPMERKINGEN.
# om de gebiedscode en naam van het gebied als indicator (dus v9900_gebiedscode etc)
# goed te krijgen, moet ook script 4 gedraaid worden.
#
# de dummy-gebiedsniveau introduceren een extra stap tussen de (K)WG en de gemeente.
# Dit om te voorkomen dat de (onvolledige!) data geaggregeerd zou worden
# naar gemeenteniveau.
#
# OPMERKING: het huidige script veronderstelt dat je een bestand krijgt waarin
# de winkelpunten al gekoppeld zijn aan de wgb en aan de gemeente
# (hier bijvoorbeeld punten_verrijkt_poging2.dbf).
#
# (ik denk dat Joost met de zin hierboven: 'nog niet aan de gemeente gekoppeld'
# bedoeld)
#
# Je kan de nood aan zo'n bestand vermijden door in de plaats in GIS gewoon
# een spatial join te doen van de wgb met gemeentegrenzen, gebruik makende van
# "largest overlap" om toe te kennen aan gemeente,
# dan vervalt een deel van het script (aangeduid in het script).
#
# OPGELET: als je de namen uit de DBF van de shapefile zou ophalen,
# dan gaan speciale tekens kapot zijn.
#
# je kan dit normaal gezien omzeilen door de shapefile in QGIS op te slaan
# als CSV (hier wgb_naam_ansi.csv).
# Behoud enkel de indicatoren die je nodig hebt.
# Zorg dat je de juiste indicatornamen hieronder in dit script definieert.
#
# ============================================================

import pandas as pd
import numpy as np
from dbfread import DBF

# ============================================================
# BEGIN: WINKELGEBIEDEN INLEZEN
# ============================================================

base_path_input = Path("C://temp//locatus_gebiedsniveaus//2026")
input_path_wgb = base_path_input / "wgb_naam_ansi_2.csv"
# input_path_toevoegen gemeente = base_path_input / 


base_path_output = 


# GET DATA /TYPE=TXT
winkelgebied = pd.read_csv(
    r"C:\temp\locatus_gebiedsniveaus\2025\wgb_naam_ansi_2.csv",
    sep=",",
    quotechar='"',
    encoding="windows-1252"
)

# rename variables
winkelgebied = winkelgebied.rename(columns={
    "WINKELGEBI": "winkelgebied",
    "WINKELGE_1": "short name",
    "WINKELGE_2": "winkelgebiedshoofdtype",
    "WINKELGE_3": "WINKELGEBIEDSTYPERING"
})

# sort cases winkelgebied (a)
winkelgebied = winkelgebied.sort_values("winkelgebied")

# ============================================================
# BEGIN toevoegen gemeente
# niet nodig als je de gemeente al gekoppeld hebt via GIS
# ============================================================

# GET TRANSLATE /TYPE=DBF
punten = pd.DataFrame(iter(DBF(
    r"C:\temp\locatus_gebiedsniveaus\2023\levering 20230401\punten_verrijkt_poging2.dbf",
    encoding="latin1"
)))

# rename variables
punten = punten.rename(columns={
    "WINKELGEBI": "winkelgebied",
    "CS01012020": "statsec"
})

# SELECT IF (winkelgebied ~= 0)
punten = punten[punten["winkelgebied"] != 0]

# ============================================================
# statsec -> gemeente
# ============================================================

statsec_gemeente = pd.read_excel(
    r"C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\statsec_gemeente.xlsx",
    sheet_name="statsec_gemeente"
)

punten = punten.merge(
    statsec_gemeente,
    on="statsec",
    how="left"
)

# ============================================================
# aanmaken lijst combinaties van wgb met gemeente
# ============================================================

winkelgebied_gemeente = (
    punten
    .groupby(["winkelgebied", "gemeente"], as_index=False)
    .size()
    .rename(columns={"size": "combi"})
)

# SELECT IF (gemeente > 0)
winkelgebied_gemeente = winkelgebied_gemeente[
    winkelgebied_gemeente["gemeente"] > 0
]

# ============================================================
# DIT IS NIET MEER NODIG INDIEN JE MET LARGEST OVERLAP ZOU WERKEN
# Identify Duplicate Cases
# ============================================================

winkelgebied_gemeente = (
    winkelgebied_gemeente
    .sort_values(["winkelgebied", "combi"], ascending=[True, False])
    .drop_duplicates(subset=["winkelgebied"])
    [["winkelgebied", "gemeente"]]
)

# ============================================================
# MATCH FILES winkelgebied <- gemeente
# ============================================================

winkelgebied = winkelgebied.merge(
    winkelgebied_gemeente,
    on="winkelgebied",
    how="left"
)

# ============================================================
# EINDE toevoegen gemeente
# ============================================================

# ============================================================
# swing aggregatietabel
# ============================================================

agg_wgb = (
    winkelgebied
    .groupby(["winkelgebied", "gemeente"], as_index=False)
    .size()
)

agg_wgb = agg_wgb.rename(columns={"winkelgebied": "winkelgebied_dummy"})
agg_wgb = agg_wgb.drop(columns="size")

agg_wgb.to_excel(
    r"C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\winkelgebied_dummy_gemeente.xlsx",
    index=False
)

# ============================================================
# BEGIN namen aanmaken
# ============================================================

# rename variables
winkelgebied = winkelgebied.rename(columns={
    "winkelgebied": "gebiedscode"
})

# gemeente naam ophalen
gemeente_df = pd.read_excel(
    r"C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\gemeente.xlsx",
    sheet_name="gemeente"
)

gemeente_df = gemeente_df.rename(columns={
    "geoitem code": "gemeente",
    "name": "gemeente_naam"
})

winkelgebied = winkelgebied.merge(
    gemeente_df[["gemeente", "gemeente_naam"]],
    on="gemeente",
    how="left"
)

# string naam
winkelgebied["name"] = (
    winkelgebied["gemeente_naam"].str.strip()
    + " - "
    + winkelgebied["short name"].str.strip()
    + " ("
    + winkelgebied["winkelgebiedshoofdtype"].str.strip()
    + ")"
)

# sort cases gemeente_naam (a)
winkelgebied = winkelgebied.sort_values("gemeente_naam")

# compute volgnr=$casenum
winkelgebied["sequence nr"] = np.arange(1, len(winkelgebied) + 1)

# ============================================================
# gebiedsdefinities winkelgebied
# ============================================================

gebiedsniveau = winkelgebied[[
    "sequence nr", "geoitem code", "short name", "name"
]]

gebiedsniveau.to_excel(
    r"C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\winkelgebied.xlsx",
    index=False
)

gebiedsniveau.to_excel(
    r"C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\winkelgebied_dummy.xlsx",
    index=False
)

# ============================================================
# dummy aggregatie winkelgebied -> winkelgebied_dummy
# ============================================================

dummy_map = winkelgebied[["geoitem code"]].copy()
dummy_map = dummy_map.rename(columns={"geoitem code": "winkelgebied"})
dummy_map["winkelgebied_dummy"] = dummy_map["winkelgebied"]

dummy_map.to_excel(
    r"C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\winkelgebied_winkelgebied_dummy.xlsx",
    index=False
)

# ============================================================
# labels uploadbestand
# ============================================================

labels = winkelgebied.rename(columns={
    "geoitem code": "geoitem",
    "winkelgebiedshoofdtype": "v1601_label_wgb_hoofdtype",
    "WINKELGEBIEDSTYPERING": "v1601_label_wgb_type"
})

labels = labels[[
    "geoitem",
    "v1601_label_wgb_hoofdtype",
    "v1601_label_wgb_type"
]]

labels["geolevel"] = "winkelgebied"
labels["period"] = 1970

# recode v1601_label_wgb_hoofdtype
labels["v1601_label_wgb_hoofdtype"] = labels["v1601_label_wgb_hoofdtype"].map({
    "Centraal": 1,
    "Ondersteunend": 2,
    "Overig": 3
})

labels.to_excel(
    r"C:\github\gebiedsniveaus\data_voor_swing\uploadfiles\wgb_labels.xlsx",
    index=False
)

# ============================================================
# KERNWINKELGEBIEDEN
# ============================================================

# GET TRANSLATE /TYPE=DBF
kernwinkelgebied = pd.DataFrame(iter(DBF(
    r"C:\temp\locatus_gebiedsniveaus\2025\kernwinkelgebieden_2024_def.dbf",
    encoding="latin1"
)))

kernwinkelgebied = kernwinkelgebied.rename(columns={
    "KWG_ID": "kernwinkelgebied",
    "NAAM": "naam",
    "GEMEENTE": "gemeente_naam"
})

# naamcorrecties
kernwinkelgebied["naam"] = (
    kernwinkelgebied["naam"]
    .str.replace("+Â®", "é", regex=False)
    .str.replace("_", "-", regex=False)
    .str.replace("Ãš", "é", regex=False)
)

# gemeente code ophalen
kernwinkelgebied = kernwinkelgebied.merge(
    gemeente_df,
    on="gemeente_naam",
    how="left"
)

# ============================================================
# dummy aggregatie kernwinkelgebied
# ============================================================

agg_kwg = (
    kernwinkelgebied
    .groupby(["kernwinkelgebied", "gemeente"], as_index=False)
    .size()
)

agg_kwg = agg_kwg.rename(columns={"kernwinkelgebied": "kernwinkelgebied_dummy"})
agg_kwg = agg_kwg.drop(columns="size")

agg_kwg.to_excel(
    r"C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\kernwinkelgebied_dummy_gemeente.xlsx",
    index=False
)

# ============================================================
# namen kernwinkelgebied
# ============================================================

kernwinkelgebied["short name"] = kernwinkelgebied["naam"].str.replace(
    "^KWG ", "", regex=True
)

kernwinkelgebied["name"] = (
    kernwinkelgebied["gemeente_naam"].str.strip()
    + " - "
    + kernwinkelgebied["short name"].str.strip()
)

kernwinkelgebied = kernwinkelgebied.sort_values("gemeente_naam")
kernwinkelgebied["sequence nr"] = np.arange(1, len(kernwinkelgebied) + 1)

kwg_out = kernwinkelgebied[[
    "sequence nr", "kernwinkelgebied", "short name", "name"
]].rename(columns={"kernwinkelgebied": "geoitem code"})

kwg_out.to_excel(
    r"C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\kernwinkelgebied.xlsx",
    index=False
)

kwg_out.to_excel(
    r"C:\github\gebiedsniveaus\data_voor_swing\gebiedsdefinities\kernwinkelgebied_dummy.xlsx",
    index=False
)

# ============================================================
# dummy aggregatie kernwinkelgebied -> kernwinkelgebied_dummy
# ============================================================

kwg_dummy = kwg_out.drop(columns=["sequence nr", "short name", "name"])
kwg_dummy = kwg_dummy.rename(columns={"geoitem code": "kernwinkelgebied"})
kwg_dummy["kernwinkelgebied_dummy"] = kwg_dummy["kernwinkelgebied"]

kwg_dummy.to_excel(
    r"C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\kernwinkelgebied_kernwinkelgebied_dummy.xlsx",
    index=False
)

# ============================================================
# EINDE SCRIPT
# ============================================================
