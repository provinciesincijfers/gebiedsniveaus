# -*- coding: utf-8 -*-
"""
moet nog gecontroleerd worden
"""

from pathlib import Path
import pandas as pd

# === Basis paden ===
base_path = Path(r"C://GitHub//gebiedsniveaus//gemeente_statsec_wijken")
input_file = base_path / "gemeentegedragen_wijken.xlsx"

output_paths = {
    "dup_names": base_path / "duplicates_wijknamen.xlsx",
    "dup_codes": base_path / "duplicates_gebiedscodepinc.xlsx",
    "statsec_dup": base_path / "statsec_duplicates.xlsx"
}

# === Helper functie om Excel op te slaan ===
def save_excel(df, path):
    Path(path).parent.mkdir(parents=True, exist_ok=True)
    df.to_excel(path, index=False, engine="openpyxl")

# === Kolommen naar lowercase en rename ===
def rename_variables(df):
    df = df.rename(columns=str.lower)
    return df.rename(columns={
        "codsec": "statsec",
        "naam_wijk": "naam_wijk",
        "gebiedscode_pinc": "gebiedscode_pinc",
        "gemeentecode": "gemeentecode"
    })

# === Duplicate-tests functie ===
def duplicate_tests(df):
    df = df.copy()
    for c in ["naam_wijk", "gebiedscode_pinc", "gemeentecode"]:
        df[c] = df[c].astype("string").str.replace(r"\s+", " ", regex=True).str.strip()
        df[c] = df[c].replace({"": pd.NA})

    # --- Test 1: wijknaam -> meerdere codes binnen gemeente ---
    tA = (
        df.groupby(["gemeentecode", "naam_wijk"], dropna=False)["gebiedscode_pinc"]
          .nunique(dropna=True)
          .reset_index(name="aantal_codes")
    )
    tA_dup_keys = tA[tA["aantal_codes"] > 1][["gemeentecode", "naam_wijk", "aantal_codes"]]
    if not tA_dup_keys.empty:
        details_A = df.merge(tA_dup_keys, on=["gemeentecode", "naam_wijk"], how="inner")
        details_A = details_A[["gemeentecode", "naam_wijk", "gebiedscode_pinc", "statsec"]].drop_duplicates()
        details_A = details_A.merge(tA_dup_keys, on=["gemeentecode", "naam_wijk"], how="left")
        details_A = details_A.sort_values(["gemeentecode", "naam_wijk", "gebiedscode_pinc"])
        save_excel(details_A, output_paths["dup_names"])
        print(f"⚠️ Duplicaten bij wijknamen → meerdere codes: {len(tA_dup_keys)} gevallen, {len(details_A)} rijen.")
    else:
        save_excel(pd.DataFrame(columns=["gemeentecode","naam_wijk","gebiedscode_pinc","statsec","aantal_codes"]), output_paths["dup_names"])
        print("✅ Geen duplicaten bij wijknamen.")

    # --- Test 2: code -> meerdere namen binnen gemeente ---
    tB = (
        df.groupby(["gemeentecode", "gebiedscode_pinc"], dropna=False)["naam_wijk"]
          .nunique(dropna=True)
          .reset_index(name="aantal_namen")
    )
    tB_dup_keys = tB[tB["aantal_namen"] > 1][["gemeentecode", "gebiedscode_pinc", "aantal_namen"]]
    if not tB_dup_keys.empty:
        details_B = df.merge(tB_dup_keys, on=["gemeentecode", "gebiedscode_pinc"], how="inner")
        details_B = details_B[["gemeentecode", "gebiedscode_pinc", "naam_wijk", "statsec"]].drop_duplicates()
        details_B = details_B.merge(tB_dup_keys, on=["gemeentecode", "gebiedscode_pinc"], how="left")
        details_B = details_B.sort_values(["gemeentecode", "gebiedscode_pinc", "naam_wijk"])
        save_excel(details_B, output_paths["dup_codes"])
        print(f"⚠️ Duplicaten bij gebiedscodes → meerdere wijknamen: {len(tB_dup_keys)} gevallen, {len(details_B)} rijen.")
    else:
        save_excel(pd.DataFrame(columns=["gemeentecode","gebiedscode_pinc","naam_wijk","statsec","aantal_namen"]), output_paths["dup_codes"])
        print("✅ Geen duplicaten bij gebiedscodes.")

# === Statsec-duplicaten functie (SPSS nabootsing) ===
def statsec_duplicates(df):
    df = df.copy()
    df = df.rename(columns={"codsec": "statsec", "gebiedscode_pinc": "gebiedscode"})
    df = df.sort_values("statsec").reset_index(drop=True)

    df["PrimaryFirst"] = ~df["statsec"].duplicated(keep="first")
    df["PrimaryLast"] = ~df["statsec"].duplicated(keep="last")

    df["MatchSequence"] = 0
    match_seq = 0
    for idx, row in df.iterrows():
        if row["PrimaryFirst"]:
            match_seq = 1 - int(row["PrimaryLast"])
        else:
            match_seq += 1
        df.at[idx, "MatchSequence"] = match_seq

    df["InDupGrp"] = df["MatchSequence"] > 0

    df_out = df.drop(columns=["PrimaryFirst", "InDupGrp", "MatchSequence"])
    df_out["PrimaryLast"] = df["PrimaryLast"].astype(int)
    df_out = df_out.sort_values(["statsec", "PrimaryLast"])
    save_excel(df_out, output_paths["statsec_dup"])
    print(f"✅ Statsec duplicaten-analyse uitgevoerd. Output: {output_paths['statsec_dup']}")
    print(f" - Aantal unieke statsec: {df_out['statsec'].nunique()}")
    print(f" - Aantal rijen met duplicaten: {df_out[df_out['PrimaryLast']==0].shape[0]}")

# === Inladen bestand ===
dtypes = {
    "CODSEC": "string",
    "Naam_wijk": "string",
    "Gebiedscode_pinc": "string",
    "Gemeentecode": "string"
}
df = pd.read_excel(input_file, sheet_name="basistabel", usecols="A,B,E,G", dtype=dtypes)
df = rename_variables(df)

# === Uitvoeren analyses ===
duplicate_tests(df)
statsec_duplicates(df)

print("\n📂 Alle analyses voltooid. Outputbestanden in dezelfde map:")
for k, v in output_paths.items():
    print(f" - {k}: {v}")
