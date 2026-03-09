# -*- coding: utf-8 -*-
"""
Created on Mon Dec  1 12:52:33 2025

@author: PAUDUPE
"""

# -*- coding: utf-8 -*-
"""
Final SPSS-conforme Python script
- gebruikt paden die je opgaf
- masterfile (aggregate) op basis van gemeentenbe2018_definitie (zoals SPSS)
- speciale codes automatisch opgenomen in belagg2 en aggregaties
- mergt namen uit gemeentenbe2018_definitie.xlsx
- voert naam-recodes en fallbacks uit
- accent-onafhankelijke sortering en 's-behandeling
- schrijft definitie- en aggregatie-excelbestanden weg
"""

import pandas as pd
import geopandas as gpd
import unicodedata
from pathlib import Path

# === PADEN ===
base_path = Path("C://temp_testpython//gebiedsniveaus//")

input_path_basisgeo = base_path / "werkbestanden//basis geodata//2019//adminvec_statsec_31370.dbf"
input_path_gemeentenbe2018def = base_path / "kerntabellen//gemeentenbe2018_definitie.xlsx"
input_path_gemeente_arro = base_path / "kerntabellen//gemeente_arrondiss.xls"

output_path_verwerkt_belgie = base_path / "kerntabellen//verwerkt_belgie2018_2019test.xlsx"
output_path_defswing_gemeentenbe2018 = base_path / "werkbestanden//gebiedsdefinities swing//gemeentenbe2018test.xlsx"
output_path_defswing_gemeentenbe2024 = base_path / "werkbestanden//gebiedsdefinities swing//gemeentenbe2024test.xlsx"
output_path_defswing_gemeentenbe = base_path / "werkbestanden//gebiedsdefinities swing//gemeentenbetest.xlsx"
output_path_agg_gemeentenbe2018_gemeentenbe2024 = base_path / "werkbestanden//gebiedsaggregaties swing//gemeentenbe2018_gemeentenbe2024test.xlsx"
output_path_agg_gemeentenbe2024_gemeentenbe = base_path / "werkbestanden//gebiedsaggregaties swing//gemeentenbe2024_gemeentenbetest.xlsx"
output_path_agg_gemeentenbe_gemeente = base_path / "werkbestanden//gebiedsaggregaties swing//gemeentenbe_gemeentetest.xlsx"

# === HULPFUNCTIES ===
def remove_accents(txt):
    if not isinstance(txt, str):
        return ""
    return ''.join(
        c for c in unicodedata.normalize('NFKD', txt)
        if not unicodedata.combining(c)
    )

SPECIAL_ORDER = [
    "00103","00111","00113","00129",
    "09999","99991","99992","99993","99994","99995"
]

def sort_definitie_df(tmp, code_col, name_col):
    tmp = tmp.copy()
    tmp[code_col] = tmp[code_col].astype(str).str.zfill(5)

    specials = tmp[tmp[code_col].isin(SPECIAL_ORDER)].copy()
    normals = tmp[~tmp[code_col].isin(SPECIAL_ORDER)].copy()

    def key_for(n):
        if not isinstance(n, str):
            return ""
        s = n.strip()
        if s.lower().startswith("'s "):
            s = s[1:]
        s = remove_accents(s)
        return s.lower()

    normals["_sort"] = normals[name_col].map(key_for)
    normals = normals.sort_values("_sort").drop(columns=["_sort"]).reset_index(drop=True)

    specials["_order"] = specials[code_col].apply(
        lambda c: SPECIAL_ORDER.index(c) if c in SPECIAL_ORDER else 9999
    )
    specials = specials.sort_values("_order").drop(columns=["_order"]).reset_index(drop=True)

    combined = pd.concat([normals, specials], ignore_index=True)
    combined = combined.rename(columns={code_col: "geoitem code", name_col: "short name"})
    combined["name"] = combined["short name"]
    combined.insert(0, "sequence nr", range(1, len(combined) + 1))
    return combined[["sequence nr", "geoitem code", "short name", "name"]]

def save_definitie(df, code_col, name_col, path):
    out = df[[code_col, name_col]].drop_duplicates().reset_index(drop=True)
    formatted = sort_definitie_df(out, code_col, name_col)
    formatted.to_excel(path, index=False)
    print(f"✔ Definitie opgeslagen: {path} ({len(formatted)} rijen)")

def save_aggr(df, van_col, naar_col, path):
    agg = df[[van_col, naar_col]].drop_duplicates().sort_values([van_col, naar_col])
    agg.to_excel(path, index=False)
    print(f"✔ Aggregatie opgeslagen: {path} ({len(agg)} rijen)")

# === 1) Lees definities (gemeentenbe2018) ===
df2018 = pd.read_excel(input_path_gemeentenbe2018def, sheet_name="gemeentenbe2018")
df2018 = df2018.rename(columns={"gebiedscode": "gemeentenbe2018", "naam": "naam_gemeentenbe2018"})
df2018["gemeentenbe2018"] = df2018["gemeentenbe2018"].astype(str).str.zfill(5)

# === 2) Prepare code recode mappings ===
recode_2018_2024 = {
    '55022':'58001','56011':'58002','56085':'58003','56087':'58004',
    '52063':'55085','52043':'55086','55010':'51067','55039':'51068',
    '55023':'51069','54007':'57096','54010':'57097','12030':'12041',
    '12034':'12041','44011':'44083','44049':'44083','44001':'44084',
    '44029':'44084','44036':'44085','44072':'44085','44080':'44085',
    '45017':'45068','45057':'45068','71047':'72042','72040':'72042',
    '72025':'72043','72029':'72043'
}

recode_2024_final = {
    '11007':'11002','23023':'23106','23024':'23106','23032':'23106',
    '37012':'37021','37018':'37021','37007':'37022','37015':'37022',
    '44012':'44086','44048':'44086','44034':'44087','44073':'44087',
    '46014':'46029','44045':'46029','44040':'44088','44043':'44088',
    '46003':'46030','46013':'46030','11056':'46030','73006':'73110',
    '73032':'73110','73009':'73111','73083':'73111','71069':'71071',
    '71057':'71071','71022':'71072','73040':'71072','82003':'82039',
    '82005':'82039'
}

# naamrecodes
recode_naam_2024 = {
    '12030': 'Puurs-Sint-Amands','12034': 'Puurs-Sint-Amands',
    '44011': 'Deinze','44049': 'Deinze',
    '44001': 'Aalter','44029': 'Aalter',
    '44036': 'Lievegem','44072': 'Lievegem','44080': 'Lievegem',
    '45017': 'Kruisem','45057': 'Kruisem',
    '71047': 'Oudsbergen','72040': 'Oudsbergen',
    '72025': 'Pelt','72029': 'Pelt'
}

recode_naam_final = {
    '11007':'Antwerpen','23023':'Pajottegem','23024':'Pajottegem','23032':'Pajottegem',
    '37012':'Wingene','37018':'Wingene','37007':'Tielt','37015':'Tielt',
    '44012':'Nazareth-De Pinte','44048':'Nazareth-De Pinte',
    '44034':'Lochristi','44073':'Lochristi','46014':'Lokeren','44045':'Lokeren',
    '44040':'Merelbeke-Melle','44043':'Merelbeke-Melle',
    '46003':'Beveren-Kruibeke-Zwijndrecht','46013':'Beveren-Kruibeke-Zwijndrecht',
    '11056':'Beveren-Kruibeke-Zwijndrecht','73006':'Bilzen-Hoeselt',
    '73032':'Bilzen-Hoeselt','73009':'Tongeren-Borgloon','73083':'Tongeren-Borgloon',
    '71069':'Tessenderlo-Ham','71057':'Tessenderlo-Ham','71022':'Hasselt',
    '73040':'Hasselt','82003':'Bastogne','82005':'Bastogne'
}

# === 3) Lees shapefile (belagg blijft bestaan maar bepaalt NIET meer aggregaties) ===
belgie = gpd.read_file(input_path_basisgeo)
belgie["niscode"] = belgie["niscode"].astype(str).str.zfill(5)
belgie["gemeentenbe2018"] = belgie["niscode"].str[:5]

belagg = belgie[["niscode", "gemeentenbe2018"]].copy()
belagg["gemeentenbe2018"] = belagg["gemeentenbe2018"].astype(str).str.zfill(5)

belagg["gemeentenbe2024"] = belagg["gemeentenbe2018"].replace(recode_2018_2024).astype(str)
belagg["gemeentenbe"] = belagg["gemeentenbe2024"].replace(recode_2024_final).astype(str)

# === 4B) **MASTER belagg2: op basis van ALLE codes uit gemeentenbe2018_definitie (zoals SPSS) ===
belagg2 = df2018[["gemeentenbe2018", "naam_gemeentenbe2018"]].copy()

# recode 2018 → 2024
belagg2["gemeentenbe2024"] = belagg2["gemeentenbe2018"].replace(recode_2018_2024)
belagg2["gemeentenbe2024"] = belagg2["gemeentenbe2024"].fillna(belagg2["gemeentenbe2018"])

# recode 2024 → final
belagg2["gemeentenbe"] = belagg2["gemeentenbe2024"].replace(recode_2024_final)
belagg2["gemeentenbe"] = belagg2["gemeentenbe"].fillna(belagg2["gemeentenbe2024"])

# === 5) NAAM recode 2024 ===
belagg2["naam_gemeentenbe2024"] = belagg2["gemeentenbe2018"].map(recode_naam_2024)
belagg2["naam_gemeentenbe2024"] = belagg2["naam_gemeentenbe2024"].fillna(
    belagg2["naam_gemeentenbe2018"]
)

# === 6) NAAM recode final ===
belagg2["naam_gemeentenbe"] = belagg2["gemeentenbe2024"].map(recode_naam_final)
belagg2["naam_gemeentenbe"] = belagg2["naam_gemeentenbe"].fillna(
    belagg2["naam_gemeentenbe2024"]
)

# === 7) DEFINITIEBESTANDEN ===
save_definitie(df2018, "gemeentenbe2018", "naam_gemeentenbe2018", output_path_defswing_gemeentenbe2018)

df2024_names = belagg2[["gemeentenbe2024", "naam_gemeentenbe2024"]].drop_duplicates()
save_definitie(df2024_names, "gemeentenbe2024", "naam_gemeentenbe2024", output_path_defswing_gemeentenbe2024)

df_final_names = belagg2[["gemeentenbe", "naam_gemeentenbe"]].drop_duplicates()
save_definitie(df_final_names, "gemeentenbe", "naam_gemeentenbe", output_path_defswing_gemeentenbe)

# === 8) AGGREGATIES (nu op basis van belagg2 = SPSS-correct) ===
save_aggr(belagg2, "gemeentenbe2018", "gemeentenbe2024", output_path_agg_gemeentenbe2018_gemeentenbe2024)
save_aggr(belagg2, "gemeentenbe2024", "gemeentenbe", output_path_agg_gemeentenbe2024_gemeentenbe)

# === 9) ARRONDISSEMENT verrijking ===
verrijken = pd.read_excel(input_path_gemeente_arro)
verrijken["gemeente"] = verrijken["gemeente"].apply(lambda x: str(int(x)).zfill(5))
verrijken = verrijken.rename(columns={"gemeente": "gemeentenbe"})
verrijken["vl_br"] = 1

belagg2 = belagg2.merge(verrijken[["gemeentenbe", "vl_br"]], on="gemeentenbe", how="left")
belagg2["gemeente"] = belagg2.apply(
    lambda r: r["gemeentenbe"] if r.get("vl_br") == 1 else "99999", axis=1
)

save_aggr(belagg2, "gemeentenbe", "gemeente", output_path_agg_gemeentenbe_gemeente)

print("\n✔ Script voltooid. Alle bestanden geschreven.")
