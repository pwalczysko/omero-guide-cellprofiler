# omero_client/fetch_images.py
import numpy as np
import tifffile
import os

def download_plate_images(conn, plate_id, out_dir, max_wells=5):
    plate = conn.getObject("Plate", plate_id)

    os.makedirs(out_dir, exist_ok=True)

    image_paths = []

    for w, well in enumerate(plate.listChildren()):
        if w >= 2:
            break

        image = well.getImage(0)
        pixels = image.getPrimaryPixels()

        size_z = image.getSizeZ()
        size_c = image.getSizeC()
        size_t = image.getSizeT()

        image_id = image.getId()

        print(
            f"Downloading Image {image_id} "
            f"(Z={size_z}, C={size_c}, T={size_t})"
        )

        # Export one TIFF per channel (first Z, first T)
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

            image_paths.append(
                {
                    "image_id": image_id,
                    "channel": c,
                    "path": path,
                }
            )

    print(f"Downloaded {len(image_paths)} channel images.")

    return image_paths
