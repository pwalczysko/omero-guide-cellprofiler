# main.py
from omero_client.connect import connect
from omero_client.fetch_images import download_plate_images
from cp.run_cellprofiler import run_cellprofiler
from cp.collect_results import load_nuclei_table
from omero_client.upload_results import upload_as_table

HOST = "workshop.openmicroscopy.org"
USER = "user-1"
PW = "elmi2026"
PLATE_ID = 55

WORKDIR = "./workspace"
INPUT_DIR = f"{WORKDIR}/input"
OUTPUT_DIR = f"{WORKDIR}/output"
PIPELINE = "./cp/ExamplePercentPositive.cppipe"

def main():
    conn = connect(HOST, USER, PW)

    print("Downloading images...")
    download_plate_images(conn, PLATE_ID, INPUT_DIR)

    print("Running CellProfiler...")
    run_cellprofiler(INPUT_DIR, OUTPUT_DIR, PIPELINE)

    print("Collecting results...")
    df = load_nuclei_table(OUTPUT_DIR)

    print("Uploading to OMERO...")
    upload_as_table(conn, PLATE_ID, df)

    conn.close()

if __name__ == "__main__":
    main()