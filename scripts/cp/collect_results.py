import os
import pandas as pd

def load_nuclei_table(output_dir):

    for f in os.listdir(output_dir):

        if f.lower().startswith("nuclei") and f.endswith(".csv"):
            path = os.path.join(output_dir, f)
            df = pd.read_csv(path)

            # safety: drop Experiment / junk columns if present
            df = df.dropna(axis=1, how="all")

            return df

    raise FileNotFoundError("Nuclei.csv not found in output directory")