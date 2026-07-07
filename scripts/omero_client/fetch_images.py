import os
import numpy as np
import pandas as pd
import tifffile


def download_plate_images(conn, plate_id, out_dir, max_wells=5):

    plate = conn.getObject("Plate", plate_id)
    os.makedirs(out_dir, exist_ok=True)

    image_paths = []
    mapping = []

    for w, well in enumerate(plate.listChildren()):

        if w >= max_wells:
            break

        image = well.getImage(0)
        well_id = well.getId()
        image_id = image.getId()

        pixels = image.getPrimaryPixels()

        size_z = image.getSizeZ()
        size_c = image.getSizeC()
        size_t = image.getSizeT()

        print(
            f"Downloading Image {image_id} "
            f"(Z={size_z}, C={size_c}, T={size_t})"
        )

        # Export first Z and first T
        for c in range(size_c):

            plane = pixels.getPlane(0, c, 0)

            if c == 0:
                suffix = "d0"
            elif c == 1:
                suffix = "d1"
            else:
                suffix = f"d{c}"

            filename = f"{image_id}_{suffix}.tif"
            path = os.path.join(out_dir, filename)

            tifffile.imwrite(path, plane)

            image_paths.append({
                "image_id": image_id,
                "channel": c,
                "path": path,
            })

            mapping.append(
                {
                    "filename": filename,
                    "ImageID": image_id,
                    "Well": well.getId(),
                }
            )

    mapping = pd.DataFrame(mapping)
    mapping.to_csv(
        os.path.join(out_dir, "mapping.csv"),
        index=False,
    )

    image_paths = pd.DataFrame(image_paths)
    image_paths.to_csv(
        os.path.join(out_dir, "Image.csv"),
        index=False,
    )

    print(f"Downloaded {len(image_paths)} channel images.")
    print(f"Saved {len(mapping)} entries to mapping.csv")

    return image_paths