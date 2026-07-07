# main.py
from omero_client.connect import connect
from omero_client.fetch_images import download_plate_images
from cp.run_cellprofiler import run_cellprofiler
from cp.collect_results import load_image_table
from omero_client.upload_results import upload_as_table

from getpass import getpass

HOST = input("OMERO host [workshop.openmicroscopy.org]: ").strip()
if not HOST:
    HOST = "workshop.openmicroscopy.org"

USER = input("Username: ").strip()
PW = getpass("Password: ")
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
    df = load_image_table(INPUT_DIR, OUTPUT_DIR)

    print("Uploading to OMERO...")
    upload_as_table(conn, PLATE_ID, df)

    conn.close()

if __name__ == "__main__":
    main()