# -*- coding: utf-8 -*-
"""
Python-versie van SPSS-script voor gemeentegedragen wijken
Inclusief:
- Naam-kort max 50 tekens
- Eerste wijk per gemeente
- Wijk onbekend correcties
- Aggregatietabellen
- Controle aantal rijen t.o.v. origineel ggw7.xlsx
"""

from pathlib import Path
import pandas as pd

# === Basis paden ===
base_path = Path(r"C://GitHub//gebiedsniveaus//")
input_ggw = base_path / "gemeente_statsec_wijken//gemeentegedragen_wijken.xlsx"
input_nis7 = base_path / "kerntabellen//dena_nis7.xlsx"
input_kern = base_path / "kerntabellen//kerntabel.xls"

output_paths = {
    "gebiedsdef": base_path / "data_voor_swing//gebiedsdefinities_testpython//ggw7.xlsx",
    "type": base_path / "data_voor_swing//uploadfiles_testpython//ggw7_type.xlsx",
    "agg_statsec": base_path / "data_voor_swing//aggregatietabellen_testpython//statsec_ggw7.xlsx",
    "agg_gemeente": base_path / "data_voor_swing//aggregatietabellen_testpython//ggw7_gemeente.xlsx",
    "statsec_readonly": base_path / "kerntabellen//statsec_ggw7_readonly_testpython.xlsx",
    "geo": Path("C://temp_testpython//statsec_ggw7_geo.xlsx")
}

def save_excel(df, path):
    Path(path).parent.mkdir(parents=True, exist_ok=True)
    df.to_excel(path, index=False, engine="openpyxl")

# === Stap 1: Inladen gemeentegedragen wijken ===
dtypes_ggw = {
    "CODSEC": "string",
    "Gemeentecode": "string",
    "Naam_wijk": "string",
    "Gebiedscode_pinc": "string",
    "provinciegemaakt": "Int64",
    "mengvorm_nafusies": "Int64",
}
df_ggw = pd.read_excel(input_ggw, sheet_name="basistabel", usecols="A,B,E,G,I,J", dtype=dtypes_ggw)
df_ggw.columns = df_ggw.columns.str.lower()
df_ggw = df_ggw.rename(columns={
    "codsec":"statsec",
    "naam_wijk":"ggw7_naam",
    "gebiedscode_pinc":"ggw7",
    "gemeentecode":"gemeentecode"
})

# === Type-classificatie ===
df_ggw['type0'] = 1
df_ggw.loc[df_ggw['provinciegemaakt']==1, 'type0'] = 3
df_ggw.loc[df_ggw['mengvorm_nafusies']==1, 'type0'] = 4
df_ggw['type0'] = df_ggw['type0'].fillna(2)

# === Merge met NIS7 ===
df_nis7 = pd.read_excel(input_nis7, sheet_name="Blad1", usecols="A,G", dtype={"statsec":"string","dena_nis7":"string"})
df_merged = df_ggw.merge(df_nis7, on="statsec", how="left")
df_merged['ggw7'] = df_merged['ggw7'].fillna(df_merged['dena_nis7'])
df_merged['ggw7_naam'] = df_merged['ggw7_naam'].fillna(df_merged['dena_nis7'])

# === Merge met kerntabel ===
df_kern = pd.read_excel(input_kern, sheet_name="toewijzingstabel_alles",
                        usecols="D,K,M,R,S,V",
                        dtype={"statsec":"string","deelgemeente":"string","deelgemeente_naam":"string",
                               "gemeente":"string","gemeente_naam":"string","provincie":"string"})
df_merged = df_merged.merge(df_kern, on="statsec", how="left")

# === Onbekendgebied en strandlogica ===
df_merged['onbekendgebied'] = 0
mask_onb = df_merged['ggw7'].str.contains("ONB|ZZZZ", na=False) | \
           df_merged['ggw7'].str.contains("X0JQ|X1JQ", na=False)
df_merged.loc[mask_onb & (df_merged['type0']==2), 'ggw7_naam'] = "Wijk onbekend"
df_merged.loc[mask_onb & (df_merged['type0']==2), 'ggw7'] = df_merged['gemeente'].astype(str).str.zfill(5)+"ONB"
df_merged.loc[mask_onb, 'onbekendgebied'] = 1

# === Wijkpergemeente logica ===
df_merged = df_merged.sort_values(['gemeentecode','onbekendgebied','ggw7']).reset_index(drop=True)
df_merged['wijkpergemeente'] = 0
prev_gemeente = None
prev_ggw7 = None
counter = 0
for idx, row in df_merged.iterrows():
    gemeente = row['gemeentecode']
    gg = row['ggw7']
    if gemeente != prev_gemeente:
        counter = 1
    else:
        if gg != prev_ggw7:
            counter += 1
    df_merged.at[idx, 'wijkpergemeente'] = counter
    prev_gemeente = gemeente
    prev_ggw7 = gg

mask_correction = (df_merged['onbekendgebied']==1) & (df_merged['wijkpergemeente']==2)
df_merged.loc[mask_correction, 'ggw7'] = df_merged['ggw7'].shift(1)
df_merged.loc[mask_correction, 'ggw7_naam'] = df_merged['ggw7_naam'].shift(1)

# === Volledige naam genereren ===
df_merged['ggw7_naamlang'] = df_merged['ggw7_naam'].str.strip() + " (" + df_merged['gemeente_naam'].fillna('').str.strip() + ")"
mask_equal = df_merged['ggw7_naam'].str.strip() == df_merged['gemeente_naam'].str.strip()
df_merged.loc[mask_equal, 'ggw7_naamlang'] = df_merged['ggw7_naam'].str.strip() + " (wijk)"

# === Eerste wijk per gemeente ===
df_merged['v9900_eerstewijk'] = df_merged.groupby('gemeentecode')['ggw7'].transform('first')

# === Naam-kort max 50 tekens ===
df_merged['naam_kort'] = df_merged['ggw7_naam'].str.slice(0,50)
df_merged.loc[df_merged['ggw7_naam'].str.len()>50, 'naam_kort'] = df_merged['ggw7_naam'].str.slice(0,47) + "..."

# === ggW7_type.xlsx ===
df_type = df_merged[['ggw7','v9900_eerstewijk','type0','gemeentecode']].drop_duplicates()
df_type = df_type.rename(columns={'ggw7':'geoitem','gemeentecode':'geoitem','type0':'v9900_type_ggw7'})
df_type['geolevel'] = 'gemeente'
df_type['period'] = 1970
save_excel(df_type, output_paths['type'])

# === ggW7.xlsx ===
df_def = df_merged[['ggw7','naam_kort','ggw7_naamlang','gemeentecode','wijkpergemeente']].drop_duplicates()
df_def = df_def.sort_values(['gemeentecode','wijkpergemeente']).reset_index(drop=True)

# Voeg expliciete Wijk onbekend-rijen toe om SPSS output na te bootsen
gemeente_counts = df_merged.groupby('gemeentecode')['ggw7'].nunique().reset_index(name='aantal_wijken')
gemeenten_onb = gemeente_counts[gemeente_counts['aantal_wijken']==1]['gemeentecode']

missing_onb_rows = []
for g in gemeenten_onb:
    onb_row = {
        'ggw7': g + "ONB",
        'naam_kort': "Wijk onbekend",
        'ggw7_naamlang': "Wijk onbekend - " + df_merged.loc[df_merged['gemeentecode']==g, 'gemeente_naam'].iloc[0],
        'gemeentecode': g,
        'wijkpergemeente': df_def['wijkpergemeente'].max()+1
    }
    missing_onb_rows.append(onb_row)

if missing_onb_rows:
    df_def = pd.concat([df_def, pd.DataFrame(missing_onb_rows)], ignore_index=True)

df_def = df_def.sort_values(['gemeentecode','wijkpergemeente']).reset_index(drop=True)
df_def['sequencenr'] = range(1, len(df_def)+1)
df_def = df_def.rename(columns={'ggw7':'geoitem code','naam_kort':'short name','ggw7_naamlang':'name'})
save_excel(df_def[['sequencenr','geoitem code','short name','name']], output_paths['gebiedsdef'])

# === Aggregatietabellen ===
df_agg_statsec = df_merged[['statsec','ggw7']].drop_duplicates()
save_excel(df_agg_statsec, output_paths['agg_statsec'])

df_agg_gemeente = df_merged[['ggw7','gemeentecode']].drop_duplicates()
df_agg_gemeente = df_agg_gemeente.rename(columns={'ggw7':'ggw7','gemeentecode':'gemeente'})
save_excel(df_agg_gemeente, output_paths['agg_gemeente'])

df_statsec_readonly = df_merged[['statsec','ggw7']].drop_duplicates()
df_statsec_readonly = df_statsec_readonly.rename(columns={'ggw7':'ggw7'})
save_excel(df_statsec_readonly, output_paths['statsec_readonly'])

df_geo = df_merged[['statsec','ggw7','gemeente','gemeente_naam','deelgemeente','deelgemeente_naam','provincie']].drop_duplicates()
save_excel(df_geo, output_paths['geo'])

# === Controle aantal rijen t.o.v. origineel ggw7.xlsx ===
original_ggw7_path = base_path / "data_voor_swing//gebiedsdefinities//ggw7.xlsx"
if original_ggw7_path.exists():
    df_original = pd.read_excel(original_ggw7_path, engine="openpyxl")
    n_original = len(df_original)
    n_new = len(df_def)
    if n_new != n_original:
        print(f"⚠️ Aantal rijen klopt niet! Origineel: {n_original}, Nieuw: {n_new}")
    else:
        print(f"✅ Aantal rijen komt overeen met origineel: {n_new}")
else:
    print(f"⚠️ Origineel ggw7.xlsx bestand niet gevonden op {original_ggw7_path}")

print("✅ Script voltooid. Outputs opgeslagen in:")
for k, v in output_paths.items():
    print(f" - {k}: {v}")
