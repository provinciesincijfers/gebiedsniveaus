# -*- coding: utf-8 -*-
"""
Created on Tue Aug 19 08:58:54 2025

@author: PAUDUPE
"""

# -*- coding: utf-8 -*-
"""
Aggregaties op basis van verwerkt_alle_gebiedsniveaus.xlsx
- unieks per (LEFT, RIGHT) zoals SPSS AGGREGATE /BREAK=...
- filter op RIGHT wanneer SPSS 'SELECT IF (RIGHT ~= "")' gebruikte
"""

from pathlib import Path
import pandas as pd

# na run script:
# maak de dummybestanden aan voor statsec(2024) > provincie(2024), fo_gem > gewest en elantw > elz
# en verwijder de rechstreekse aggregatie


# =========================
# PADDEFINITIES (zoals opgegeven)
# =========================
## Input
input_path2024 = Path("C://github//gebiedsniveaus//verzamelbestanden//verwerkt_alle_gebiedsniveaus2024.xlsx")
input_path = Path("C://github//gebiedsniveaus//verzamelbestanden//verwerkt_alle_gebiedsniveaus.xlsx")

## Output
base_path_output_agg = Path("C://github//gebiedsniveaus//data_voor_swing//aggregatietabellen")
# vanaf oude statsec
output_path_agg_statsec2019_statsec2024 = base_path_output_agg / "statsec2019_statsec2024.xlsx"
output_path_agg_statsec2024_deelg2024 = base_path_output_agg / "statsec2024_deelgemeente2024.xlsx"
output_path_agg_statsec2024_gem2024 = base_path_output_agg / "statsec2024_gemeente2024.xlsx"
output_path_agg_statsec2024_gem = base_path_output_agg / "statsec2024_gemeente.xlsx"
output_path_agg_statsec2024_provincie2024 = base_path_output_agg / "statsec2024_provincie2024.xlsx"
output_path_agg_deelg2024_gem2018 = base_path_output_agg / "deelgemeente2024_gemeente2018.xlsx"
output_path_agg_deelg2024_gem2024 = base_path_output_agg / "deelgemeente2024_gemeente2024.xlsx"
output_path_agg_gem24_gem = base_path_output_agg / "gemeente2024_gemeente.xlsx"
output_path_agg_gem24_arro24 = base_path_output_agg / "gemeente2024_arrondiss2024.xlsx"
output_path_agg_gem24_elz = base_path_output_agg / "gemeente2024_elz.xlsx"
output_path_agg_gem24_prov24 = base_path_output_agg / "gemeente2024_provincie2024.xlsx"
output_path_agg_arro24_prov24 = base_path_output_agg / "arrondiss2024_provincie2024.xlsx"
output_path_agg_statsec2024_kern = base_path_output_agg / "statsec2024_kern.xlsx"
output_path_agg_statsec2024_kerntypering = base_path_output_agg / "statsec2024_kerntypering.xlsx"
output_path_agg_statsec2024_woningmarkt = base_path_output_agg / "statsec2024_woningmarkt.xlsx"
output_path_agg_woningmarkt_gewest = base_path_output_agg / "woningmarkt_gewest.xlsx"
output_path_agg_kerntyp_gewest = base_path_output_agg / "kerntypering_gewest.xlsx"
output_path_agg_kern_kerntyp = base_path_output_agg / "kern_kerntypering.xlsx"
output_path_agg_kern_gewest = base_path_output_agg / "kern_gewest.xlsx"


#vanaf nieuwe statsec
output_path_agg_statsec_deelg = base_path_output_agg / "statsec_deelgemeente.xlsx"
output_path_agg_statsec_dummy = base_path_output_agg / "statsec_provincie.xlsx"
output_path_agg_prov24_gewest = base_path_output_agg / "provincie2024_gewest.xlsx"
output_path_agg_prov_gewest = base_path_output_agg / "provincie_gewest.xlsx"
output_path_agg_deelg_gem = base_path_output_agg / "deelgemeente_gemeente.xlsx"
output_path_agg_gem_arro = base_path_output_agg / "gemeente_arrondiss.xlsx"
output_path_agg_arro_prov = base_path_output_agg / "arrondiss_provincie.xlsx"
output_path_agg_gemeente_gewest = base_path_output_agg / "gemeente_gewest.xlsx"
output_path_agg_gem_fogem = base_path_output_agg / "gemeente_fo_gem.xlsx"
output_path_agg_gem_politie = base_path_output_agg / "gemeente_politiezone.xlsx"
output_path_agg_gem_uitrgraad = base_path_output_agg / "gemeente_uitrustingsgraad.xlsx"
output_path_agg_gem_elz = base_path_output_agg / "gemeente_elz.xlsx"
output_path_agg_fogem_gewest = base_path_output_agg / "fo_gem_gewest.xlsx"
output_path_agg_politie_gewest = base_path_output_agg / "politiezone_gewest.xlsx"
output_path_agg_uitrgraad_gewest = base_path_output_agg / "uitrustingsgraad_gewest.xlsx"
output_path_agg_elz_prov = base_path_output_agg / "elz_provincie.xlsx"
output_path_agg_gem_gezondh = base_path_output_agg / "gemeente_gezondheidsmakers.xlsx"
output_path_agg_gezondh_prov = base_path_output_agg / "gezondheidsmakers_provincie.xlsx"
output_path_agg_gem_prov = base_path_output_agg / "gemeente_provincie.xlsx"
output_path_agg_gem_vervoer = base_path_output_agg / "gemeente_vervoerregio.xlsx"
output_path_agg_vervoer_gewest = base_path_output_agg / "vervoerregio_gewest.xlsx"
output_path_agg_statsec_gem = base_path_output_agg / "statsec_gemeente.xlsx"
output_path_agg_statsec_treg = base_path_output_agg / "statsec_treg.xlsx"
output_path_agg_treg_prov = base_path_output_agg / "treg_provincie.xlsx"
output_path_agg_statsec_tregpo = base_path_output_agg / "statsec_treg_po.xlsx"
output_path_agg_gem_treggem = base_path_output_agg / "gemeente_treg_gem.xlsx"
output_path_agg_treggem_prov = base_path_output_agg / "treg_gem_provincie.xlsx"
output_path_agg_gem_refreg = base_path_output_agg / "gemeente_refreg.xlsx"
output_path_agg_refreg_prov = base_path_output_agg / "refreg_provincie.xlsx"
output_path_agg_gewest_belgie = base_path_output_agg / "gewest_belgie.xlsx"
output_path_agg_gem_woonmtsch = base_path_output_agg / "gemeente_woonmaatschappij.xlsx"
output_path_agg_woonmtsch_prov = base_path_output_agg / "woonmaatschappij_provincie.xlsx"
output_path_agg_statsec_elzantw = base_path_output_agg / "statsec_elzantw.xlsx"
output_path_agg_elzantw_elz = base_path_output_agg / "elzantw_elz.xlsx"
output_path_agg_statsec_prov = base_path_output_agg / "statsec_provincie.xlsx"
output_path_agg_gem_streek = base_path_output_agg / "gemeente_streekwerking.xlsx"
output_path_agg_streek_prov = base_path_output_agg / "streekwerking_provincie.xlsx"
# output_path_agg_statsec_woningmarkt = base_path_output_agg / "statsec_woningmarkt.xlsx"
# output_path_agg_woningmarkt_gewest = base_path_output_agg / "woningmarkt_gewest.xlsx"
# output_path_agg_statsec_kerntyp = base_path_output_agg / "statsec_kerntypering.xlsx"
# output_path_agg_kerntyp_gewest = base_path_output_agg / "kerntypering_gewest.xlsx"
# output_path_agg_statsec_kern = base_path_output_agg / "statsec_kern.xlsx"
# output_path_agg_kern_kerntyp = base_path_output_agg / "kern_kerntypering.xlsx"
# output_path_agg_kern_gewest = base_path_output_agg / "kern_gewest.xlsx"
output_path_agg_gem_igs = base_path_output_agg / "gemeente_igs.xlsx"
output_path_agg_igs_gewest = base_path_output_agg / "igs_gewest.xlsx"
output_path_agg_treggem_treg = base_path_output_agg / "treg_gem_treg.xlsx"

# =========================
# Inlezen basisbestand
# =========================
df = pd.read_excel(input_path, dtype=str)
df2024 = pd.read_excel(input_path2024, dtype=str)

# =========================
# Verwijderen foute koppelingen deelgemeente2024 - gemeente2018
# =========================

# lijst ongewenste combinaties
te_verwijderen = [
    ("12041ONBE", "12034"),
    ("44083ONBE", "44049"),
    ("44084ONBE", "44029"),
    ("44085ONBE", "44072"),
    ("44085ONBE", "44080"),
    ("45068ONBE", "45057"),
    ("72042ONBE", "71047"),
    ("72043ONBE", "72029"),
]

# bouw maskers voor elke combinatie
mask = pd.Series(False, index=df2024.index)
for dg, gem in te_verwijderen:
    mask |= (df2024["deelgemeente2024"] == dg) & (df2024["gemeente2018"] == gem)

# verwijder deze rijen
df2024 = df2024[~mask]

# =========================
# Helper: aggregatie & export
# =========================
def save_mapping(df: pd.DataFrame, left: str, right: str, out_path: Path, filter_col: str | None = None):
    """
    Schrijf unieke paren (left,right) naar out_path.
    - filter_col: wanneer opgegeven, drop rijen waar filter_col leeg is (SPSS SELECT IF ... ~= "")
    - geen extra kolommen in output (exact 2 kolommen)
    """
    sub = df[[left, right]].copy()
    if filter_col:
        sub = sub[sub[filter_col].notna() & (sub[filter_col].str.strip() != "")]
    # Unieke combinaties zoals AGGREGATE /BREAK=...
    out = (
        sub.groupby([left, right], dropna=False, as_index=False)
           .size()
           .drop(columns="size")
    )
    out.to_excel(out_path, index=False)

# =========================
# Alle mappings (met filters waar SPSS die had)
# =========================

jobs_2024 = [
    ("statsec2019", "statsec2024", output_path_agg_statsec2019_statsec2024, None),
    ("statsec2024", "deelgemeente2024", output_path_agg_statsec2024_deelg2024, None),
    ("statsec2024", "gemeente2024", output_path_agg_statsec2024_gem2024, None),
    ("statsec2024", "gemeente", output_path_agg_statsec2024_gem, None),
    ("statsec2024", "provincie2024", output_path_agg_statsec2024_provincie2024, None),
    ("deelgemeente2024", "gemeente2018", output_path_agg_deelg2024_gem2018, None),  
    ("deelgemeente2024", "gemeente2024", output_path_agg_deelg2024_gem2024, None),   
    ("gemeente2024", "gemeente", output_path_agg_gem24_gem, None),   
    ("gemeente2024", "arrondiss2024", output_path_agg_gem24_arro24, None),  
    ("gemeente2024", "elz", output_path_agg_gem24_elz, None),  
    ("gemeente2024", "provincie2024", output_path_agg_gem24_prov24, None),
    ("arrondiss2024","provincie2024", output_path_agg_arro24_prov24, None),
    ("statsec2024", "kern", output_path_agg_statsec2024_kern, None),
    ("statsec2024", "kerntypering", output_path_agg_statsec2024_kerntypering, None),
    ("statsec2024", "woningmarkt", output_path_agg_statsec2024_woningmarkt, None),
    #("woningmarkt", "gewest",         output_path_agg_woningmarkt_gewest,  "woningmarkt"),
    #("kerntypering","gewest",         output_path_agg_kerntyp_gewest,      "kerntypering"),
    # ("kern",        "kerntypering",   output_path_agg_kern_kerntyp,        "kern"),
     #("kern",        "gewest",         output_path_agg_kern_gewest,         "kern"),
]   


jobs = [
    # (left, right, output_path, optional filter_col)
    ("statsec",     "deelgemeente",   output_path_agg_statsec_deelg,       None),
    ("statsec",     "provincie",      output_path_agg_statsec_dummy,       None),
    ("provincie2024","gewest",        output_path_agg_prov24_gewest,       None),
    ("provincie",   "gewest",         output_path_agg_prov_gewest,         None),
    ("deelgemeente","gemeente",       output_path_agg_deelg_gem,           None),
    ("gemeente",    "arrondiss",      output_path_agg_gem_arro,            None),
    ("arrondiss",   "provincie",      output_path_agg_arro_prov,           None),
    ("gemeente",    "gewest",         output_path_agg_gemeente_gewest,     None),
    ("gemeente",    "fo_gem",         output_path_agg_gem_fogem,           "fo_gem"),
    ("gemeente",    "politiezone",    output_path_agg_gem_politie,         None),
    ("gemeente",    "uitrustingsgraad", output_path_agg_gem_uitrgraad,     "uitrustingsgraad"),
    ("gemeente",    "elz",            output_path_agg_gem_elz,             None),
    ("fo_gem",      "gewest",         output_path_agg_fogem_gewest,        "fo_gem"),
    ("politiezone", "gewest",         output_path_agg_politie_gewest,      None),
    ("uitrustingsgraad","gewest",     output_path_agg_uitrgraad_gewest,    "uitrustingsgraad"),
    ("elz",         "provincie",      output_path_agg_elz_prov,            None),
    ("gemeente",    "gezondheidsmakers", output_path_agg_gem_gezondh,      "gezondheidsmakers"),
    ("gezondheidsmakers", "provincie", output_path_agg_gezondh_prov,       "gezondheidsmakers"),
    ("gemeente",    "provincie",      output_path_agg_gem_prov,            None),
    ("gemeente",    "vervoerregio",   output_path_agg_gem_vervoer,         "vervoerregio"),  
    ("vervoerregio","gewest",         output_path_agg_vervoer_gewest,      "vervoerregio"),
    ("statsec",     "gemeente",       output_path_agg_statsec_gem,         None),
    ("statsec",     "TREG",           output_path_agg_statsec_treg,        "TREG"),
    ("TREG",        "provincie",      output_path_agg_treg_prov,           "TREG"),
    ("statsec",     "TREG_po",        output_path_agg_statsec_tregpo,      "TREG_po"),
    ("gemeente",    "TREG_gem",       output_path_agg_gem_treggem,         "TREG_gem"),
    ("TREG_gem",    "provincie",      output_path_agg_treggem_prov,        "TREG_gem"),
    ("gemeente",    "REFREG",         output_path_agg_gem_refreg,          "REFREG"),
    ("REFREG",      "provincie",      output_path_agg_refreg_prov,         "REFREG"),
    ("gewest",      "belgie",         output_path_agg_gewest_belgie,       "gewest"),
    ("gemeente",    "woonmaatschappij", output_path_agg_gem_woonmtsch,     "woonmaatschappij"),
    ("woonmaatschappij","provincie",  output_path_agg_woonmtsch_prov,      "woonmaatschappij"),
    ("statsec",        "ELZantw",     output_path_agg_statsec_elzantw,      "ELZantw"),
    ("ELZantw",     "elz",            output_path_agg_elzantw_elz,         "ELZantw"),
    ("statsec",     "provincie",      output_path_agg_statsec_prov,        "statsec"),
    ("gemeente",    "streekwerking",  output_path_agg_gem_streek,          "streekwerking"),
    ("streekwerking","provincie",     output_path_agg_streek_prov,         "streekwerking"),
  # ("statsec",     "woningmarkt",    output_path_agg_statsec_woningmarkt, "woningmarkt"),
  # ("statsec",     "kerntypering",   output_path_agg_statsec_kerntyp,     "kerntypering"),
  # ("statsec",     "kern",           output_path_agg_statsec_kern,        "kern"),
    ("gemeente",    "igs",            output_path_agg_gem_igs,             "igs"),
    ("igs",         "gewest",        output_path_agg_igs_gewest,          "igs"),
  # ("woningmarkt", "gewest",         output_path_agg_woningmarkt_gewest,  "woningmarkt"),
  # ("kerntypering","gewest",         output_path_agg_kerntyp_gewest,      "kerntypering"),
  # ("kern",        "kerntypering",   output_path_agg_kern_kerntyp,        "kern"),
  # ("kern",        "gewest",         output_path_agg_kern_gewest,         "kern"),
    ("TREG_gem",     "TREG",          output_path_agg_treggem_treg,        "TREG_gem")
]



# =========================
# Run aggregaties op basisbestand 2024
# =========================


for left, right, out_path, filt in jobs_2024:
    save_mapping(df2024, left, right, out_path, filter_col=filt)
    print(f"✅ (2024) {left} → {right} → {out_path}")

# =========================
# Run aggregaties op basisbestand
# =========================
for left, right, out_path, filt in jobs:
    save_mapping(df, left, right, out_path, filter_col=filt)
    print(f"✅ {left} → {right} → {out_path}")

print("🎉 Klaar: alle aggregatietabellen zijn weggeschreven.")

# maak de dummybestanden aan voor statsec(2024) > provincie(2024), fo_gem > gewest en elantw > elz
# en verwijder de rechstreekse aggregatie
# treg_gem > treg: aggregatie 06b handmatig verwijderen

