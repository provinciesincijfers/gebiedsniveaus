
import pandas as pd
from pathlib import Path

# Definieer paden
input_path = Path("C:/github/gebiedsniveaus/kerntabellen/gemeente_arrondiss.xls")
output_path = Path("C:/github/gebiedsniveaus/data_voor_swing/gebiedsdefinities/arrondiss.xlsx")

# Stap 1: Laad Excel-bestand
df = pd.read_excel(
    input_path, 
    sheet_name="gemeente_arrondiss"
)

# Stap 2: Groepeer (AGGREGATE-equivalent)
df_grouped = df.groupby(['arrondiss', 'Namebestuurlijkarrondissement']).size().reset_index(name='N_BREAK')

# Stap 3: Datasetbewerking
df_grouped = df_grouped.drop(columns=['N_BREAK'])
df_grouped = df_grouped.rename(columns={
    'arrondiss': 'gebiedscode',
    'Namebestuurlijkarrondissement': 'naam_kort'
})
df_grouped['naam'] = df_grouped['naam_kort']

# Voeg onbekend_gebied toe
df_grouped['onbekend_gebied'] = (df_grouped['gebiedscode'] > 99989).astype(int)

# Sorteer zoals in SPSS
df_grouped = df_grouped.sort_values(by=['onbekend_gebied', 'naam'])

# Voeg volgnummer toe
df_grouped = df_grouped.reset_index(drop=True)
df_grouped['volgnr'] = df_grouped.index + 1

# Volgnummer als integer met nul decimalen
df_grouped['volgnr'] = df_grouped['volgnr'].astype('int64')

# Houd alleen de relevante kolommen
output_df = df_grouped[['volgnr', 'gebiedscode', 'naam_kort', 'naam']]

# Stap 4: Opslaan naar Excel
output_df.to_excel(
    output_path, 
    index=False, 
    engine='openpyxl'
)
