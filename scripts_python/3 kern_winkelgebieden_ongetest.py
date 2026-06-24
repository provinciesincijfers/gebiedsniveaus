# -*- coding: utf-8 -*-
"""
Locatus gebiedsniveaus verwerking
"""

import pandas as pd
import numpy as np
from dbfread import DBF
from pathlib import Path

# ============================================================
# FUNCTIES
# ============================================================

def truncate_name(series, max_len=50):
    series = series.str.strip()
    mask = series.str.len() > max_len
    series.loc[mask] = series.loc[mask].str[:max_len-3] + "..."
    return series

# ============================================================
# PADEN
# ============================================================

base_path_input = Path("C://temp//locatus_gebiedsniveaus//2026")

# ============================================================
# WINKELGEBIEDEN INLEZEN
# ============================================================

winkelgebied = pd.read_csv(
    r"C:\temp\locatus_gebiedsniveaus\2025\wgb_naam_ansi_2.csv",
    sep=",",
    quotechar='"',
    encoding="windows-1252"
)

winkelgebied = winkelgebied.rename(columns={
    "WINKELGEBI": "winkelgebied",
    "WINKELGE_1": "short name",
    "WINKELGE_2": "winkelgebiedshoofdtype",
    "WINKELGE_3": "WINKELGEBIEDSTYPERING"
})

winkelgebied = winkelgebied.sort_values("winkelgebied")

# ============================================================
# GEMEENTE TOEVOEGEN
# ============================================================

punten = pd.DataFrame(iter(DBF(
    r"C:\temp\locatus_gebiedsniveaus\2023\levering 20230401\punten_verrijkt_poging2.dbf",
    encoding="latin1"
)))

punten = punten.rename(columns={
    "WINKELGEBI": "winkelgebied",
    "CS01012020": "statsec"
})

punten = punten[punten["winkelgebied"] != 0]

statsec_gemeente = pd.read_excel(
    r"C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\statsec_gemeente.xlsx",
    sheet_name="statsec_gemeente"
)

punten = punten.merge(statsec_gemeente, on="statsec", how="left")

winkelgebied_gemeente = (
    punten
    .groupby(["winkelgebied", "gemeente"], as_index=False)
    .size()
    .rename(columns={"size": "combi"})
)

winkelgebied_gemeente = winkelgebied_gemeente[
    winkelgebied_gemeente["gemeente"] > 0
]

winkelgebied_gemeente = (
    winkelgebied_gemeente
    .sort_values(["winkelgebied", "combi"], ascending=[True, False])
    .drop_duplicates(subset=["winkelgebied"])
    [["winkelgebied", "gemeente"]]
)

winkelgebied = winkelgebied.merge(
    winkelgebied_gemeente,
    on="winkelgebied",
    how="left"
)

# ============================================================
# AGGREGATIES WINKELGEBIED
# ============================================================

agg_wgb = (
    winkelgebied
    .groupby(["winkelgebied", "gemeente"], as_index=False)
    .size()
)

agg_wgb = agg_wgb.rename(columns={"winkelgebied": "winkelgebied_dummy"})
agg_wgb = agg_wgb.drop(columns="size")

# dummy 1 → gemeente
agg_wgb.to_excel(
    r"C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\winkelgebied_dummy_gemeente.xlsx",
    index=False
)

# dummy 1 → dummy 2
wg_dummy_map = winkelgebied[["winkelgebied"]].copy()
wg_dummy_map = wg_dummy_map.rename(columns={"winkelgebied": "winkelgebied_dummy"})
wg_dummy_map["winkelgebied_dummy2"] = wg_dummy_map["winkelgebied_dummy"]

wg_dummy_map.to_excel(
    r"C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\winkelgebied_dummy_winkelgebied_dummy2.xlsx",
    index=False
)

# dummy 2 → gemeente
agg_wgb_dummy2 = agg_wgb.rename(columns={
    "winkelgebied_dummy": "winkelgebied_dummy2"
})

agg_wgb_dummy2.to_excel(
    r"C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\winkelgebied_dummy2_gemeente.xlsx",
    index=False
)

# ============================================================
# NAMEN WINKELGEBIED
# ============================================================

winkelgebied = winkelgebied.rename(columns={
    "winkelgebied": "gebiedscode"
})

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

# truncate short name
winkelgebied["short name"] = truncate_name(winkelgebied["short name"])

winkelgebied["name"] = (
    winkelgebied["gemeente_naam"].str.strip()
    + " - "
    + winkelgebied["short name"].str.strip()
    + " ("
    + winkelgebied["winkelgebiedshoofdtype"].str.strip()
    + ")"
)

winkelgebied = winkelgebied.sort_values("gemeente_naam")
winkelgebied["sequence nr"] = np.arange(1, len(winkelgebied) + 1)

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
# LABELS
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

kernwinkelgebied = pd.DataFrame(iter(DBF(
    r"C:\temp\locatus_gebiedsniveaus\2025\kernwinkelgebieden_2024_def.dbf",
    encoding="latin1"
)))

kernwinkelgebied = kernwinkelgebied.rename(columns={
    "KWG_ID": "kernwinkelgebied",
    "NAAM": "naam",
    "GEMEENTE": "gemeente_naam"
})

kernwinkelgebied["naam"] = (
    kernwinkelgebied["naam"]
    .str.replace("+Â®", "é", regex=False)
    .str.replace("_", "-", regex=False)
    .str.replace("Ãš", "é", regex=False)
)

kernwinkelgebied = kernwinkelgebied.merge(
    gemeente_df,
    on="gemeente_naam",
    how="left"
)

# aggregatie dummy 1 → gemeente
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

# dummy 1 → dummy 2
kwg_dummy_map = kernwinkelgebied[["kernwinkelgebied"]].copy()
kwg_dummy_map = kwg_dummy_map.rename(columns={
    "kernwinkelgebied": "kernwinkelgebied_dummy"
})
kwg_dummy_map["kernwinkelgebied_dummy2"] = kwg_dummy_map["kernwinkelgebied_dummy"]

kwg_dummy_map.to_excel(
    r"C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\kernwinkelgebied_dummy_kernwinkelgebied_dummy2.xlsx",
    index=False
)

# dummy 2 → gemeente
agg_kwg_dummy2 = agg_kwg.rename(columns={
    "kernwinkelgebied_dummy": "kernwinkelgebied_dummy2"
})

agg_kwg_dummy2.to_excel(
    r"C:\github\gebiedsniveaus\data_voor_swing\aggregatietabellen\kernwinkelgebied_dummy2_gemeente.xlsx",
    index=False
)

# ============================================================
# NAMEN KERNWINKELGEBIED
# ============================================================

kernwinkelgebied["short name"] = kernwinkelgebied["naam"].str.replace(
    "^KWG ", "", regex=True
)

kernwinkelgebied["short name"] = truncate_name(kernwinkelgebied["short name"])

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
# EINDE
# ============================================================