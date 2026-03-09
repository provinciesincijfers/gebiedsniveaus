# -*- coding: utf-8 -*-
"""
Created on Mon Aug 25 14:37:26 2025

@author: PAUDUPE
"""


"""TODO Dit script moet nog gecontroleerd worden """

import pandas as pd

# Pad naar input en output
input_file = r'C:\github\gebiedsniveaus\kerntabellen\kerntabel.xls'
output_file = r'C:\github\gebiedsniveaus\kerntabellen\kerntabel_testpython.xlsx'

# Inlezen van de sheet 'toewijzingstabel_alles'
df = pd.read_excel(input_file, sheet_name='toewijzingstabel_alles')

def apply_lag_logic(df, col_deelgemeente):
    print(f"\n--- Verwerking voor {col_deelgemeente} ---")

    # 1. Tel aantal rijen per (deelgemeente, gemeente)
    agg1 = df.groupby([col_deelgemeente, 'gemeente']).size().reset_index(name='N_break')

    # 2. Tel aantal deelgemeentes per gemeente
    agg2 = agg1.groupby('gemeente')['N_break'].sum().reset_index(name='tel_gemeente')

    # 3. Merge terug
    agg1 = agg1.merge(agg2, on='gemeente', how='left')

    # 4. Selecteer rijen volgens SPSS logica
    valid = agg1[(agg1['tel_gemeente'] == 2) & (agg1['N_break'] == 1)][[col_deelgemeente, 'tel_gemeente']]
    print(f"Aantal geselecteerde {col_deelgemeente}-records voor correctie: {len(valid)}")

    # 5. Merge terug naar df
    df = df.merge(valid, on=col_deelgemeente, how='left')

    # 6. Gebruik shift() voor lag
    mask = (df['tel_gemeente'] == 2) & (df['gemeente'] == df['gemeente'].shift())
    print(f"Aantal rijen aangepast in {col_deelgemeente}: {mask.sum()}")

    if mask.sum() > 0:
        print("\nVoorbeelden (oude → nieuwe waarden):")
        temp = df.loc[mask, [col_deelgemeente, 'gemeente']].copy()
        temp['nieuw'] = df[col_deelgemeente].shift()[mask]
        print(temp.head())

    # pas lag toe
    df.loc[mask, col_deelgemeente] = df[col_deelgemeente].shift()[mask]

    # ook de namen mee schuiven indien aanwezig
    for extra_col in [f"{col_deelgemeente}_naam_kort", f"{col_deelgemeente}_naam"]:
        if extra_col in df.columns:
            old_vals = df.loc[mask, extra_col].copy()
            new_vals = df[extra_col].shift()[mask]
            df.loc[mask, extra_col] = new_vals

            if mask.sum() > 0:
                print(f"\nVoorbeelden {extra_col} (oude → nieuwe waarden):")
                print(pd.DataFrame({'oud': old_vals, 'nieuw': new_vals}).head())

    # 7. Opruimen
    return df.drop(columns=[c for c in ['tel_gemeente'] if c in df.columns])


# --- Eerste keer toepassen ---
df = apply_lag_logic(df, 'deelgemeente')

# --- Tweede keer toepassen (voor deelgemeente2019) ---
df = apply_lag_logic(df, 'deelgemeente2019')

# Opslaan naar Excel
df.to_excel(output_file, index=False)
print(f"\n✅ Output opgeslagen in: {output_file}")
