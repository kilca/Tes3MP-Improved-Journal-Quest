import pandas as pd
def supprimer_colonnes_vides(df):
    # Trouver les colonnes contenant des valeurs vides
    colonnes_vides = df.columns[df.isnull().all()].tolist()
    # Supprimer les colonnes contenant des valeurs vides
    df = df.drop(colonnes_vides, axis=1)
    return df

def exporter_csv_tab(df, nom_fichier):
    df.to_csv(nom_fichier, sep="@", index=False)

# Charger le fichier CSV en utilisant le séparateur de colonnes '\t'
df = pd.read_csv('J:/Work/Morrowind/testquest./quests.txt', sep='\t', header=None)
# Filtrer les données pour ne garder que celles ayant "Journal" dans la troisième colonne
df = df[df[3] == "Journal"]
# Enlever les 3 premières colonnes
df = supprimer_colonnes_vides(df)
df = df.iloc[:, 3:]
# Conversion de la 4ème colonne en minuscules
df.iloc[:, 1] = df.iloc[:, 1].str.lower()
df = df.fillna("EMPTY")
# Afficher les données du fichier CSV
exporter_csv_tab(df,'J:/Work/Morrowind/testquest./journal.txt')
print("done")