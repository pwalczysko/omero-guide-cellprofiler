import os
import pandas as pd

def load_image_table(input_dir, output_dir):

    # Load CellProfiler Image.csv
    image = None
    for f in os.listdir(output_dir):
        if f.startswith("Image") and f.endswith(".csv"):
            image = pd.read_csv(os.path.join(output_dir, f))
            break

    if image is None:
        raise FileNotFoundError("Image.csv not found")

    # Load OMERO mapping
    mapping = pd.read_csv(
        os.path.join(input_dir, "mapping.csv")
    )

    # Merge on the filename that CellProfiler reports
    image = image.merge(
        mapping,
        left_on="FileName_OrigBlue",
        right_on="filename",
        how="left"
    )

    # Remove helper column
    image.drop(columns=["filename"], inplace=True)

    return image